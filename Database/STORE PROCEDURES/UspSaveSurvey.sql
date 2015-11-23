IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSurvey]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveSurvey]
GO
/*
EXEC UspSaveSurvey @XmlData='<?xml version="1.0" encoding="utf-16"?>
<Survey>
  <SurveyId />
  <SurveyName>new1312</SurveyName>
  <RewardEnabled>false</RewardEnabled>
  <Starred>false</Starred>
  <LanguageId>1</LanguageId>
  <IsActive>false</IsActive>
   <SurveyEndDate>01/14/2013</SurveyEndDate>
  <SurveyLibrary>
    <LibType>Survey</LibType>
    <Category>
      <CategoryId>169</CategoryId>
    </Category>
  </SurveyLibrary>
</Survey>',@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
<User>
  <UserId>5</UserId>
  <UserName>Nilesh More</UserName>
  <UserDetails>
    <IsActive>false</IsActive>
    <Customer>
      <CustomerId>1</CustomerId>
      <IsActive>false</IsActive>
    </Customer>
    <UserRole>
      <RoleId>2</RoleId>
      <RoleDesc>SRS Admin</RoleDesc>
      <Hierarchy>1</Hierarchy>
    </UserRole>
  </UserDetails>
</User>'
*/
CREATE PROCEDURE DBO.UspSaveSurvey
	@XmlData AS NTEXT,
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo
	
	DECLARE @UserId INT, @CustomerId INT 
	SELECT @UserId = CONVERT(INT,UserId) FROM @UserInfo
	SELECT @CustomerId = CONVERT(INT,CustomerId) FROM @UserInfo
	
	DECLARE @SurveyId INT, @SurveyName VARCHAR(150)
	SET @SurveyId = 0
	 
	DECLARE @input XML = @XmlData
	 
	CREATE TABLE #Survey 
	(
		SurveyId VARCHAR(20), SurveyName NVARCHAR(50), RewardEnabled VARCHAR(20), LanguageId INT, 
		Starred VARCHAR(20), IsActive VARCHAR(20), SurveyEndDate VARCHAR(20),CategoryId INT
	)
	INSERT INTO #Survey
	(
		SurveyId, SurveyName, RewardEnabled, LanguageId, IsActive, SurveyEndDate,CategoryId
	)
	SELECT 
		Parent.Elm.value('(SurveyId)[1]','VARCHAR(20)') AS SurveyId,
		Parent.Elm.value('(SurveyName)[1]','NVARCHAR(50)') AS SurveyName,
		Parent.Elm.value('(RewardEnabled)[1]','VARCHAR(20)') AS RewardEnabled,
		Parent.Elm.value('(LanguageId)[1]','VARCHAR(20)') AS LanguageId,
		Parent.Elm.value('(IsActive)[1]','VARCHAR(20)') AS IsActive,
		Parent.Elm.value('(SurveyEndDate)[1]','VARCHAR(25)') AS SurveyEndDate,
		Child.Elm.value('(CategoryId)[1]','INT') AS CategoryId
	FROM @input.nodes('/Survey') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('SurveyLibrary/Category') AS Child(Elm)
		
	SELECT @SurveyName = LTRIM(RTRIM(SurveyName)) FROM #Survey		

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN ('SLU'))
	BEGIN
		SELECT 0 AS RetValue, 'Access Denied' AS Remark
	END
	ELSE
	BEGIN
		IF EXISTS 
		(
			SELECT 1 FROM #Survey S INNER JOIN DBO.TR_Survey TS WITH(NOLOCK) 
			ON LTRIM(RTRIM(S.SurveyId)) = CONVERT(VARCHAR(12),TS.SurveyId)
		)
		BEGIN
			SELECT @SurveyId = CONVERT(INT,SurveyId) FROM #Survey
			
			IF EXISTS
			(
				SELECT 1 FROM DBO.TR_Survey WITH(NOLOCK) 
				WHERE LTRIM(RTRIM(SurveyName)) = LTRIM(RTRIM(@SurveyName))
				AND SurveyId <> @SurveyId
			)
			BEGIN
				SELECT 0 AS RetValue, 'Survey with same name already exists....' AS Remark		
			END
			ELSE
			BEGIN
				IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA') 
				BEGIN
					UPDATE TS
					SET TS.SurveyName = S.SurveyName,
						TS.RewardEnabled = CASE WHEN S.RewardEnabled = 'False' THEN 0 ELSE 1 END,
						TS.SurveyEndDate = CASE WHEN ISNULL(S.SurveyEndDate,'01/01/1900') = '01/01/1900' THEN TS.SurveyEndDate ELSE CONVERT(DATE,S.SurveyEndDate) END,
						TS.ModifiedBy = @UserId,
						TS.ModifiedDate = GETDATE(),
						TS.PublishStatus = 'U',
						TS.CategoryId = S.CategoryId,
						TS.LanguageId = S.LanguageId
					FROM DBO.TR_Survey TS
					INNER JOIN #Survey S
						ON TS.SurveyId = CONVERT(INT,S.SurveyId)
						
					SELECT 1 AS RetValue, 'Successfully Updated' AS Remark, SurveyId FROM #Survey
				END

				IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'GU') 
				BEGIN
					IF EXISTS
					(	
						SELECT 1 FROM #Survey S INNER JOIN DBO.TR_Survey TS 
						ON TS.SurveyId = CONVERT(INT,S.SurveyId) AND CustomerId = @CustomerId
					)
					BEGIN
						UPDATE TS
						SET TS.SurveyName = S.SurveyName,
							TS.RewardEnabled = CASE WHEN S.RewardEnabled = 'False' THEN 0 ELSE 1 END,
							TS.SurveyEndDate = CASE WHEN ISNULL(S.SurveyEndDate,'') = '' THEN TS.SurveyEndDate ELSE CONVERT(DATE,S.SurveyEndDate) END,
							TS.ModifiedBy = @UserId,
							TS.ModifiedDate = GETDATE(),
							TS.PublishStatus = 'U',
							TS.CategoryId = S.CategoryId,
							TS.LanguageId = S.LanguageId
						FROM DBO.TR_Survey TS
						INNER JOIN #Survey S
							ON TS.SurveyId = CONVERT(INT,S.SurveyId)
							
						SELECT 1 AS RetValue, 'Successfully Updated' AS Remark, SurveyId FROM #Survey
					END
					ELSE
					BEGIN
						SELECT 0 AS RetValue, 'Access Denied' AS Remark
					END
				END	
				IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SU') 
				BEGIN
					IF EXISTS
					(
						SELECT 1 FROM #Survey S INNER JOIN DBO.TR_Survey TS 
						ON TS.SurveyId = CONVERT(INT,S.SurveyId) AND CreatedBy = @UserId
					)
					BEGIN
						UPDATE TS
						SET TS.SurveyName = S.SurveyName,
							TS.RewardEnabled = CASE WHEN S.RewardEnabled = 'False' THEN 0 ELSE 1 END,
							TS.SurveyEndDate = CASE WHEN ISNULL(S.SurveyEndDate,'') = '' THEN TS.SurveyEndDate ELSE CONVERT(DATE,S.SurveyEndDate) END,
							TS.ModifiedBy = @UserId,
							TS.ModifiedDate = GETDATE(),
							TS.PublishStatus = 'U',
							TS.CategoryId = S.CategoryId,
							TS.LanguageId = S.LanguageId
						FROM DBO.TR_Survey TS
						INNER JOIN #Survey S
							ON TS.SurveyId = CONVERT(INT,S.SurveyId)
							
						SELECT 1 AS RetValue, 'Successfully Updated' AS Remark, SurveyId FROM #Survey
					END
					ELSE
					BEGIN
						SELECT 0 AS RetValue, 'Access Denied' AS Remark
					END
				END
			END	
		END
		ELSE
		BEGIN
			IF EXISTS
			(
				SELECT 1 FROM DBO.TR_Survey WITH(NOLOCK) 
				WHERE LTRIM(RTRIM(SurveyName)) = LTRIM(RTRIM(@SurveyName))
			)
			BEGIN
				SELECT 0 AS RetValue, 'Survey with same name already exists....' AS Remark
			END
			ELSE
			BEGIN
				/*Temporty Default Value taken StatusId, CategoryId, LanguageId*/
				INSERT INTO DBO.TR_Survey 
				(
					SurveyName, CustomerId, StarMarked, RewardEnabled, CreatedBy, CreatedDate, ModifiedBy, 
					ModifiedDate, IsActive, StatusId, CategoryId, LanguageId, SurveyEndDate
				) 
				SELECT 
					 SurveyName, @CustomerId, 1, 0, @UserId, GETDATE(), @UserId, GETDATE(),
					 1, 0, CategoryId, LanguageId, CONVERT(DATE,SurveyEndDate,101) 
				FROM #Survey 
				
				SET @SurveyId = @@IDENTITY
				 
				SELECT CASE WHEN @SurveyId = 0 THEN 0 ELSE 1 END AS RetValue, 
					CASE WHEN @SurveyId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
					@SurveyId AS SurveyId
			END		
		END 
	END
		
	DROP TABLE #Survey
		
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END