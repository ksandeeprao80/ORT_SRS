IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetPublishSurvey]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetPublishSurvey]

GO
/*
-- EXEC UspGetPublishSurvey 4,'<?xml version="1.0" encoding="utf-16"?>
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
      <RoleId>1</RoleId>
      <RoleDesc>Group User</RoleDesc>
      <Hierarchy>1</Hierarchy>
    </UserRole>
  </UserDetails>
</User>','<?xml version="1.0" encoding="utf-16"?>
<PageModel>
  <Page>1</Page>
  <Start>0</Start>
  <Limit>5</Limit>
  <SortBy>
    <SortModel>
      <Property>SurveyName</Property>
      <Direction>DESC</Direction>
    </SortModel>
    <SortModel>
      <property>Responses</property>
      <direction>ASC</direction>
    </SortModel>
     <SortModel>
      <Property>SurveyId</Property>
      <Direction>ASC</Direction>
    </SortModel>
  </SortBy>
</PageModel>'
*/
CREATE PROCEDURE DBO.UspGetPublishSurvey
	@CustomerId INT,
	@XmlUserInfo AS NTEXT,
	@PageData AS NTEXT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SU','GU','SA'))
	BEGIN
		DECLARE @TotalRecords INT
		SET @TotalRecords = 0 
	
		CREATE TABLE #MySurvey 
		(
			SurveyId INT, SurveyName NVARCHAR(50), CustomerId INT, Responses INT, RequiredSamples INT,
			StarMarked INT, RewardEnabled INT, CreatedBy INT, CreatedDate VARCHAR(10), ModifiedBy INT, 
			ModifiedDate VARCHAR(10), IsActive VARCHAR(5), StatusId INT, SurveyStatusName VARCHAR(10), 
			CategoryId INT, LanguageId INT, LangauageName VARCHAR(50), SurveyEndDate VARCHAR(10)
		)
		INSERT INTO #MySurvey
		(
			SurveyId, SurveyName, CustomerId, Responses, RequiredSamples, StarMarked, RewardEnabled, 
			CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, IsActive, StatusId, SurveyStatusName, 
			CategoryId, LanguageId, LangauageName, SurveyEndDate
		)	
		SELECT 
			DISTINCT
			TS.SurveyId, TS.SurveyName, TS.CustomerId, ISNULL(TR1.Responses,0) AS Responses, 0 AS RequiredSamples, 
			TS.StarMarked, TS.RewardEnabled, TS.CreatedBy, CONVERT(VARCHAR(10),TS.CreatedDate,103) AS CreatedDate,
			ISNULL(TS.ModifiedBy,0) AS ModifiedBy, CONVERT(VARCHAR(10),TS.ModifiedDate,103) AS ModifiedDate,
			CASE WHEN ISNULL(TS.IsActive,0) = 0 THEN 'False' ELSE 'True' END AS IsActive,
			TS.StatusId, MSS.SurveyStatusName, TS.CategoryId, TS.LanguageId, ML.LangauageName,
			CASE WHEN CONVERT(VARCHAR(10),TS.SurveyEndDate,101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(10),TS.SurveyEndDate,101) END AS SurveyEndDate
		FROM DBO.TR_Survey TS
		INNER JOIN DBO.MS_SurveyStatus MSS
			ON TS.StatusId = MSS.StatusId
			AND TS.StatusId <> 2 AND TS.IsActive = 1
			AND TS.PublishStatus = 'P'
			AND 
			(	CONVERT(VARCHAR(10),TS.SurveyEndDate,121) >= CONVERT(VARCHAR(10),GETDATE(),121) 
				OR
				CONVERT(VARCHAR(10),TS.SurveyEndDate,121) = '1900-01-01'
			)  
		INNER JOIN @UserInfo UI
			ON TS.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TS.CustomerId ELSE CONVERT(INT,UI.CustomerId) END) 
			AND TS.CreatedBy = (CASE WHEN UI.RoleDesc IN ('SA','GU') THEN TS.CreatedBy ELSE CONVERT(INT,UI.UserId) END)  	
		LEFT OUTER JOIN DBO.MS_Languages ML
			ON TS.LanguageId = ML.LanguageId	
		LEFT OUTER JOIN
		(
			SELECT 
				COUNT(RCNT.Responses) AS Responses, RCNT.SurveyId, RCNT.CustomerId	 
			FROM 
			(	
				SELECT 
					COUNT(1) AS Responses, TSQ.SurveyId, TSQ.CustomerId, TR.RespondentId, TR.SessionId  
				FROM DBO.TR_Responses TR
				INNER JOIN DBO.TR_SurveyQuestions TSQ
					ON TR.QuestionId = TSQ.QuestionId
					AND TSQ.IsDeleted = 1 AND TR.[Status] = 'C'
				INNER JOIN @UserInfo UI
					ON TSQ.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TSQ.CustomerId ELSE CONVERT(INT,UI.CustomerId) END) 
				GROUP BY TSQ.SurveyId, TSQ.CustomerId, TR.RespondentId, TR.SessionId
			) RCNT
			GROUP BY RCNT.SurveyId, RCNT.CustomerId
		) TR1
			ON TS.SurveyId = TR1.SurveyId
			AND TS.CustomerId = TR1.CustomerId
		
		SELECT @TotalRecords = COUNT(1) FROM #MySurvey
		
		DECLARE @input1 XML = @PageData        
	
		DECLARE @PagingViewModel TABLE
		(RowId INT IDENTITY(1,1), PageNo INT, Start INT, RowLimit INT)
		INSERT INTO @PagingViewModel
		(PageNo, Start, RowLimit)
		SELECT
			Parent.Elm.value('(Page)[1]','VARCHAR(20)') AS PageNo,
			Parent.Elm.value('(Start)[1]','VARCHAR(20)') AS Start,
			Parent.Elm.value('(Limit)[1]','VARCHAR(20)') AS RowLimit
		FROM @input1.nodes('/PageModel') AS Parent(Elm)

		DECLARE @PagingViewModelOrder TABLE
		(RowId INT IDENTITY(1,1), Property VARCHAR(50), Direction VARCHAR(5))
		INSERT INTO @PagingViewModelOrder
		(Property, Direction)
		SELECT
			Child1.Elm.value('(Property)[1]','VARCHAR(20)') AS Property,
			Child1.Elm.value('(Direction)[1]','VARCHAR(20)') AS Direction
		FROM @input1.nodes('/PageModel') AS Parent(Elm)
		CROSS APPLY
			Parent.Elm.nodes('SortBy') AS Child(Elm)
		CROSS APPLY
			Child.Elm.nodes('SortModel') AS Child1(Elm)	
			
		DECLARE @Count INT
		DECLARE @PageNo INT
		DECLARE @PageSize INT
		DECLARE @ColumnNameOrderBy VARCHAR(150)
		SET @Count = 0
		SET @ColumnNameOrderBy = ''
		
		SELECT @PageNo = PageNo, @PageSize = RowLimit FROM @PagingViewModel WHERE RowId = 1

		SELECT @Count = COUNT(1) FROM @PagingViewModelOrder
		IF @Count >= 1
		BEGIN
			SELECT @ColumnNameOrderBy = COALESCE(@ColumnNameOrderBy,'','') +  Property+' '+ISNULL(Direction,'ASC')+',' FROM @PagingViewModelOrder ORDER BY RowId ASC
			SET @ColumnNameOrderBy = LEFT(@ColumnNameOrderBy,LEN(@ColumnNameOrderBy)-1)
		END
		
		IF ISNULL(@PageNo,0) = 0 
		BEGIN			
			SET @PageNo = 1
		END
		IF ISNULL(@PageSize,0) = 0
		BEGIN
			SET @PageSize = 20
		END
		IF ISNULL(@ColumnNameOrderBy,'') = ''
		BEGIN
			SET @ColumnNameOrderBy = 'SurveyId DESC'
		END

		DECLARE @FirstRecord INT
		DECLARE @LastRecord INT
		SET @FirstRecord = (@PageNo - 1) * @PageSize + 1  
		SET @LastRecord = @FirstRecord + @PageSize - 1    

		DECLARE @OrderedKeys TABLE 
		(
			RowNum INT IDENTITY NOT NULL PRIMARY KEY CLUSTERED, SurveyId INT NOT NULL, SurveyName NVARCHAR(50), 
			CustomerId INT, Responses INT, RequiredSamples INT, StarMarked INT, RewardEnabled INT, CreatedBy INT, 
			CreatedDate VARCHAR(10), ModifiedBy INT, ModifiedDate VARCHAR(10), IsActive VARCHAR(5), StatusId INT, 
			SurveyStatusName VARCHAR(10), CategoryId INT, LanguageId INT, LangauageName VARCHAR(50), 
			SurveyEndDate VARCHAR(10)
		)
		
		SET ROWCOUNT @LastRecord
		
		DECLARE @SqlScript NVARCHAR(4000)
		SET @SqlScript = 'SELECT SurveyId, SurveyName, CustomerId, Responses, RequiredSamples, StarMarked, RewardEnabled, 
			CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, IsActive, StatusId, SurveyStatusName, 
			CategoryId, LanguageId, LangauageName, SurveyEndDate 
		FROM #MySurvey ORDER BY '+ @ColumnNameOrderBy

		INSERT INTO @OrderedKeys
		(
			SurveyId, SurveyName, CustomerId, Responses, RequiredSamples, StarMarked, RewardEnabled, 
			CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, IsActive, StatusId, SurveyStatusName, 
			CategoryId, LanguageId, LangauageName, SurveyEndDate
		)	
		EXEC SP_ExecuteSql @SqlScript  

		SET ROWCOUNT 0

		SELECT 
		  MS.*, ML.LangauageName AS LanguageDesc 
		FROM #MySurvey MS
		INNER JOIN @OrderedKeys OK 
		  ON OK.SurveyId = MS.SurveyId
		INNER JOIN DBO.MS_Languages ML
		  ON MS.LanguageId = ML.LanguageId  
		WHERE OK.RowNum >= @FirstRecord
		ORDER BY OK.RowNum 
		
		SELECT ISNULL(@TotalRecords,0) AS TotalRecords
 	END
	ELSE
	BEGIN
		SELECT 0 AS RetValue, 'Access Denied' AS Remark
	END

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END