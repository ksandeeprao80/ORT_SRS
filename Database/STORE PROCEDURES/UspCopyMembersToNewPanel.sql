IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspCopyMembersToNewPanel]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspCopyMembersToNewPanel

GO 

/*   
EXEC UspCopyMembersToNewPanel @XMlData='<?xml version="1.0" encoding="utf-16"?>
<Panel>
	<LibType>Panel</LibType>
	<PanelId>105</PanelId>
	<PanelName>27102014</PanelName>
	<LibraryId>12</LibraryId>
	<PanelCategory>
		<CategoryId>34</CategoryId>
	</PanelCategory>
	<Members>
		<Respondent>
			<RespondentId>5362</RespondentId>
			<IsRespondentDeleted>false</IsRespondentDeleted>
			<IsRespondentActive>false</IsRespondentActive>
		</Respondent>
		<Respondent>
			<RespondentId>10105</RespondentId>
			<IsRespondentDeleted>false</IsRespondentDeleted>
			<IsRespondentActive>false</IsRespondentActive>
		</Respondent>
	</Members>
	<LastUsed>0001-01-01T00:00:00</LastUsed>
	<IsPanelActive>false</IsPanelActive>
</Panel>',@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
<User>
  <UserId>116</UserId>
  <UserName>GRPUsr One</UserName>
  <UserDetails>
    <IsActive>false</IsActive>
    <Customer>
      <CustomerId>46</CustomerId>
      <IsActive>false</IsActive>
    </Customer>
    <UserRole>
      <RoleId>1</RoleId>
      <RoleDesc>Group User</RoleDesc>
      <Hierarchy>2</Hierarchy>
    </UserRole>
  </UserDetails>
</User>'
*/ 

CREATE PROCEDURE DBO.UspCopyMembersToNewPanel
	@XmlData AS NTEXT,
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	DECLARE @input XML = @XmlData
	
	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo
	
	DECLARE @UserId INT, @CustomerId INT, @RoleDesc VARCHAR(3)
	SELECT @UserId = CONVERT(INT,UserId), @CustomerId = CONVERT(INT,CustomerId), @RoleDesc = RoleDesc FROM @UserInfo

	CREATE TABLE #Respondent
	(PanelistId INT, PanelistName VARCHAR(150), LibId INT, CategoryId INT, RespondentId INT)
	INSERT INTO #Respondent
	(PanelistId, PanelistName, LibId, CategoryId, RespondentId)
	SELECT
		Parent.Elm.value('(PanelId)[1]','VARCHAR(12)') AS PanelistId,
		Parent.Elm.value('(PanelName)[1]','VARCHAR(150)') AS PanelistName,
		Parent.Elm.value('(LibraryId)[1]','VARCHAR(12)') AS LibId,
		Child2.Elm.value('(CategoryId)[1]','VARCHAR(12)') AS CategoryId,
		Child1.Elm.value('(RespondentId)[1]','VARCHAR(12)') AS RespondentId
	FROM @input.nodes('/Panel') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Members') AS Child(Elm)
	CROSS APPLY
		Child.Elm.nodes('Respondent') AS Child1(Elm)	
	CROSS APPLY
		Parent.Elm.nodes('PanelCategory') AS Child2(Elm)	
	
	DECLARE @Row INT
	DECLARE @PanelistId INT
	DECLARE @PanelId INT
	DECLARE @PanelistName VARCHAR(150)
		
	SELECT TOP 1 @PanelId = PanelistId, @PanelistName = PanelistName FROM #Respondent 

	IF ISNULL(@PanelId,0) = 0
	BEGIN
		IF EXISTS(SELECT 1 FROM DBO.MS_PanelMembers WHERE LTRIM(RTRIM(PanelistName)) = LTRIM(RTRIM(@PanelistName)))
		BEGIN
			SELECT 0 AS RetValue, 'Panelist Name already exist in the system.' AS Remark, 0 AS PanelistId
			RETURN
		END
		ELSE
		BEGIN
			BEGIN TRAN
			
			INSERT INTO DBO.MS_PanelMembers
			(PanelistName, CustomerId, LibId, IsActive, CategoryId,LastUsed)
			SELECT
				DISTINCT 
				LTRIM(RTRIM(@PanelistName)) AS PanelistName, @CustomerId AS CustomerId,  
				LibId, 1 AS IsActive, CategoryId,GETDATE()
			FROM #Respondent
			
			SET @PanelistId = @@IDENTITY
			
			INSERT INTO DBO.MS_Respondent
			(
				CustomerId, EmailId, PanelistId, IsActive, IsDeleted, FirstName, LastName, BirthDate, Gender, 
				Town, UDF1, UDF2, UDF3, UDF4, UDF5, CreatedBy, CreatedOn, Age
			)
			SELECT 
				@CustomerId AS CustomerId, MR.EmailId, @PanelistId, MR.IsActive, MR.IsDeleted, MR.FirstName, 
				MR.LastName, MR.BirthDate, MR.Gender, MR.Town, MR.UDF1, MR.UDF2, MR.UDF3, MR.UDF4, MR.UDF5, 
				@UserId AS CreatedBy, GETDATE() AS CreatedOn, MR.Age	
			FROM #Respondent R
			INNER JOIN DBO.MS_Respondent MR WITH(NOLOCK)
				ON R.RespondentId = MR.RespondentId

			SET @Row = @@ROWCOUNT

			UPDATE DBO.MS_Respondent
			SET RespondentCode = 'Res'+CONVERT(VARCHAR(12),RespondentId) 
			WHERE PanelistId = @PanelistId
			
			IF @Row = 0 OR @PanelistId = 0
			BEGIN 		
				ROLLBACK TRAN
				SELECT 0 AS RetValue, 'Insert Failed' AS Remark, ISNULL(@PanelistId,0) AS PanelistId
			END
			ELSE
			BEGIN
				SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark, ISNULL(@PanelistId,0) AS PanelistId
				COMMIT TRAN
			END
		END
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		DECLARE @PanelCusId INT
		SELECT @PanelCusId = CustomerId FROM DBO.MS_PanelMembers WHERE PanelistId = @PanelId
		
		INSERT INTO DBO.MS_Respondent
		(
			CustomerId, EmailId, PanelistId, IsActive, IsDeleted, FirstName, LastName, BirthDate, Gender, 
			Town, UDF1, UDF2, UDF3, UDF4, UDF5, CreatedBy, CreatedOn, Age
		)
		SELECT 
			R.CustomerId, R.EmailId, R.PanelistId, R.IsActive, R.IsDeleted, R.FirstName, R.LastName, R.BirthDate, 
			R.Gender, R.Town, R.UDF1, R.UDF2, R.UDF3, R.UDF4, R.UDF5, R.CreatedBy, R.CreatedOn, R.Age
		FROM
		(
			SELECT 
				@PanelCusId AS CustomerId, MR.EmailId, @PanelId AS PanelistId , MR.IsActive, MR.IsDeleted, MR.FirstName, 
				MR.LastName, MR.BirthDate, MR.Gender, MR.Town, MR.UDF1, MR.UDF2, MR.UDF3, MR.UDF4, MR.UDF5, 
				@UserId AS CreatedBy, GETDATE() AS CreatedOn, MR.Age	
			FROM #Respondent R
			INNER JOIN DBO.MS_Respondent MR WITH(NOLOCK)
				ON R.RespondentId = MR.RespondentId  
		) R 
		LEFT JOIN
		(
			SELECT EmailId, FirstName, LastName FROM DBO.MS_Respondent
			WHERE PanelistId = @PanelId
		) P 
			ON LTRIM(RTRIM(R.EmailId)) = LTRIM(RTRIM(P.EmailId))
			AND LTRIM(RTRIM(R.FirstName)) = LTRIM(RTRIM(P.FirstName))
			AND LTRIM(RTRIM(R.LastName)) = LTRIM(RTRIM(P.LastName))
		WHERE ISNULL(P.EmailId,'') = '' 
		
		SET @Row = @@ROWCOUNT

		UPDATE DBO.MS_Respondent
		SET RespondentCode = 'Res'+CONVERT(VARCHAR(12),RespondentId) 
		WHERE PanelistId = @PanelId
		
		IF @Row = 0  
		BEGIN 		
			ROLLBACK TRAN
			SELECT 0 AS RetValue, 'same data already exist for the panelist' AS Remark, ISNULL(@PanelId,0) AS PanelistId
		END
		ELSE
		BEGIN
			SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark, ISNULL(@PanelId,0) AS PanelistId
			COMMIT TRAN
		END
	END
 
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END


