IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetPanelistRespondent]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetPanelistRespondent]

GO
 
/*
EXEC UspGetPanelistRespondent 1,'<?xml version="1.0" encoding="utf-16"?>
<PageModel>
  <Page>1</Page>
  <Start>0</Start>
  <Limit>100</Limit>
  <SortBy>
    <SortModel>
      <Property>SurveyName</Property>
      <Direction>DESC</Direction>
    </SortModel>
    <SortModel>
      <Property>Responses</Property>
      <Direction>ASC</Direction>
    </SortModel>
    <SortModel>
      <Property>SurveyId</Property>
      <Direction>ASC</Direction>
    </SortModel>
  </SortBy>
</PageModel>'
*/

CREATE PROCEDURE DBO.UspGetPanelistRespondent
	@PanelistId INT,
	@PageData AS NTEXT 
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT 
		MPM.PanelistId, MPM.PanelistName, MPM.CustomerId, MPM.LastUsed, MPM.IsActive, MPM.LibId, 
		MPM.CategoryId, MR.TotalMembers
	FROM DBO.MS_PanelMembers MPM WITH(NOLOCK)
	LEFT JOIN
	(
		SELECT 
			PanelistId, COUNT(1) AS TotalMembers 
		FROM DBO.MS_Respondent WITH(NOLOCK)
		WHERE PanelistId = @PanelistId AND IsActive = 1
		GROUP BY PanelistId
	) MR
		ON MPM.PanelistId = MR.PanelistId
	WHERE MPM.PanelistId = @PanelistId
	
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
	
	IF EXISTS(SELECT 1 FROM @PagingViewModel)
	BEGIN
		DECLARE @TotalRecords INT
		SET @TotalRecords = 0 
				
		CREATE TABLE #Respondents
		(
			RespondentId INT, FirstName VARCHAR(50), LastName VARCHAR(50), Gender VARCHAR(20), BirthDate VARCHAR(20), 
			EmailId VARCHAR(50), Town VARCHAR(50), UDF1 VARCHAR(50), UDF2 VARCHAR(50), UDF3 VARCHAR(50), 
			UDF4 VARCHAR(50), UDF5 VARCHAR(50)
		)
		INSERT INTO #Respondents
		(
			RespondentId, FirstName, LastName, Gender, BirthDate, EmailId, Town, UDF1, UDF2, UDF3, UDF4, UDF5
		)
		SELECT 
			RespondentId, FirstName, LastName, Gender, BirthDate, EmailId, Town, UDF1, UDF2, UDF3, UDF4, UDF5
		FROM DBO.MS_Respondent WITH(NOLOCK)
		WHERE PanelistId = @PanelistId AND IsActive = 1
		
		SELECT @TotalRecords = COUNT(1) FROM #Respondents
		
		DECLARE @Count INT
		DECLARE @PageNo INT
		DECLARE @PageSize INT
		DECLARE @ColumnNameOrderBy VARCHAR(150)
		SET @Count = 0
		SET @ColumnNameOrderBy = ''
		
		SELECT @PageNo = PageNo, @PageSize = RowLimit FROM @PagingViewModel WHERE RowId = 1	
		
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
			SET @ColumnNameOrderBy = 'FirstName, LastName ASC'
		END
		
		DECLARE @FirstRecord INT
		DECLARE @LastRecord INT
		SET @FirstRecord = (@PageNo - 1) * @PageSize + 1  
		SET @LastRecord = @FirstRecord + @PageSize - 1    

		DECLARE @PanelRespondents TABLE 
		(
			RowNum INT IDENTITY NOT NULL PRIMARY KEY CLUSTERED, RespondentId INT, FirstName VARCHAR(50), LastName VARCHAR(50), 
			Gender VARCHAR(20), BirthDate VARCHAR(20), EmailId VARCHAR(50), Town VARCHAR(50), UDF1 VARCHAR(50), 
			UDF2 VARCHAR(50), UDF3 VARCHAR(50), UDF4 VARCHAR(50), UDF5 VARCHAR(50)
		)
		
		SET ROWCOUNT @LastRecord
		
		DECLARE @SqlScript NVARCHAR(4000)
		SET @SqlScript = 'SELECT RespondentId, FirstName, LastName, Gender, BirthDate, EmailId, Town, UDF1, UDF2, 
			UDF3, UDF4, UDF5
		FROM #Respondents ORDER BY '+ @ColumnNameOrderBy
		
		INSERT INTO @PanelRespondents
		(
			RespondentId, FirstName, LastName, Gender, BirthDate, EmailId, Town, UDF1, UDF2, UDF3, UDF4, UDF5
		)	
		EXEC SP_ExecuteSql @SqlScript  

		SET ROWCOUNT 0

		SELECT 
			OK.RespondentId,RS.FirstName, RS.LastName, RS.Gender, RS.BirthDate, RS.EmailId, RS.Town, RS.UDF1, 
			RS.UDF2, RS.UDF3, RS.UDF4, RS.UDF5
		FROM #Respondents RS
		INNER JOIN @PanelRespondents OK 
		   ON RS.RespondentId = OK.RespondentId
		WHERE OK .RowNum >= @FirstRecord
		ORDER BY OK .RowNum 
		
		SELECT ISNULL(@TotalRecords,0) AS TotalRecords
	END
	ELSE
	BEGIN
		SELECT 
			RespondentId, FirstName, LastName, Gender, BirthDate, EmailId, Town, UDF1, UDF2, UDF3, UDF4, UDF5
		FROM DBO.MS_Respondent WITH(NOLOCK)
		WHERE PanelistId = @PanelistId AND IsActive = 1
		ORDER BY FirstName, LastName ASC
	END
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 