IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurvey]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurvey]

GO
/*
-- EXEC UspGetSurvey NULL,NULL,'<?xml version="1.0" encoding="utf-16"?>
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
      <Property>SurveyEndDate</Property>
      <Direction>ASC</Direction>
    </SortModel>
     <SortModel>
      <Property>SurveyId</Property>
      <Direction>ASC</Direction>
    </SortModel>
  </SortBy>
</PageModel>'
*/
CREATE PROCEDURE DBO.UspGetSurvey
	@SurveyId INT = NULL,
	@CustomerId INT = NULL,
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

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN ('SA','GU','SU'))
	BEGIN
		DECLARE @TotalRecords INT
		SET @TotalRecords = 0
		
		SELECT  
			@TotalRecords = COUNT(1)
		FROM DBO.TR_Survey TS
		LEFT OUTER JOIN @UserInfo UI
			ON TS.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TS.CustomerId ELSE CONVERT(INT,UI.CustomerId) END)
		WHERE TS.SurveyId = ISNULL(@SurveyId,TS.SurveyId)
	
		CREATE TABLE #MySurvey 
		(
			SurveyId INT, SurveyName NVARCHAR(50), CustomerId INT, StarMarked INT, RewardEnabled INT, 
			CreatedBy INT, CreatedDate VARCHAR(10), ModifiedBy INT, ModifiedDate VARCHAR(10), 
			IsActive INT, CategoryId INT, LanguageId INT, SurveyEndDate VARCHAR(10)
		)
		INSERT INTO #MySurvey
		(
			SurveyId, SurveyName, CustomerId, StarMarked, RewardEnabled, CreatedBy, CreatedDate, ModifiedBy, 
			ModifiedDate, IsActive, CategoryId, LanguageId, SurveyEndDate
		)		
		SELECT  
			TS.SurveyId, TS.SurveyName, TS.CustomerId, ISNULL(TS.StarMarked,0) AS StarMarked, 
			TS.RewardEnabled, TS.CreatedBy, TS.CreatedDate, ISNULL(TS.ModifiedBy,0) AS ModifiedBy, 
			ISNULL(TS.ModifiedDate,'') AS ModifiedDate, ISNULL(TS.IsActive,0) AS IsActive, TS.CategoryId, TS.LanguageId,
			CASE WHEN CONVERT(VARCHAR(10),TS.SurveyEndDate,101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(10),TS.SurveyEndDate,121) END AS SurveyEndDate
		FROM DBO.TR_Survey TS
		LEFT OUTER JOIN @UserInfo UI
			ON TS.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TS.CustomerId ELSE CONVERT(INT,UI.CustomerId) END)
		WHERE TS.SurveyId = ISNULL(@SurveyId,TS.SurveyId)
		
		--------------------------------------
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
			RowNum INT IDENTITY NOT NULL PRIMARY KEY CLUSTERED, SurveyId INT, SurveyName NVARCHAR(50), CustomerId INT, 
			StarMarked INT, RewardEnabled INT, CreatedBy INT, CreatedDate VARCHAR(10), ModifiedBy INT, 
			ModifiedDate VARCHAR(10), IsActive VARCHAR(5), CategoryId INT, LanguageId INT, SurveyEndDate VARCHAR(10)
		)
		
		SET ROWCOUNT @LastRecord
		
		DECLARE @SqlScript NVARCHAR(4000)
		SET @SqlScript = 'SELECT SurveyId, SurveyName, CustomerId, StarMarked, RewardEnabled, CreatedBy, CreatedDate, 
						  ModifiedBy, ModifiedDate, IsActive, CategoryId, LanguageId, SurveyEndDate 
						  FROM #MySurvey ORDER BY '+ @ColumnNameOrderBy

		INSERT INTO @OrderedKeys
		(
			SurveyId, SurveyName, CustomerId, StarMarked, RewardEnabled, CreatedBy, CreatedDate, ModifiedBy, 
			ModifiedDate, IsActive, CategoryId, LanguageId, SurveyEndDate
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