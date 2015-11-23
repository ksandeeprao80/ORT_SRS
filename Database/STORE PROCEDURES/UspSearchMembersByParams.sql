IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSearchMembersByParams]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSearchMembersByParams]

GO
 
/*
EXEC UspSearchMembersByParams 1,'<?xml version="1.0" encoding="utf-16"?>
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
</PageModel>',
@XMlData='<?xml version="1.0" encoding="utf-16"?>
<Respondent>
	<FirstName>SandeepRao</FirstName>
	<LastName>RaoSandeep</LastName>
	<Gender>male</Gender>
	<Age />
	<BirthDate>1981-04-12</BirthDate>
	<Ethnicity />
	<CreatedOn></CreatedOn>
</Respondent>' 
*/

CREATE PROCEDURE DBO.UspSearchMembersByParams
	@PanelistId INT,
	@PageData AS NTEXT,
	@XmlData AS NTEXT 
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY
	
	DECLARE @input XML = @XmlData
	DECLARE @input1 XML = @PageData

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
		
	DECLARE @SearchRespondent TABLE
	(
		FirstName VARCHAR(50), LastName VARCHAR(50), Gender VARCHAR(20), Age INT, BirthDate VARCHAR(20), 
		UDF2 VARCHAR(50), CreatedOn VARCHAR(30)
	)
	INSERT INTO @SearchRespondent
	(
		FirstName, LastName, Gender, Age, BirthDate, UDF2/*Ethnicity*/, CreatedOn
	)
	SELECT
		Parent.Elm.value('(FirstName)[1]','VARCHAR(50)') AS FirstName,
		Parent.Elm.value('(LastName)[1]','VARCHAR(50)') AS LastName,
		Parent.Elm.value('(Gender)[1]','VARCHAR(20)') AS Gender,
		Parent.Elm.value('(Age)[1]','VARCHAR(12)') AS Age,
		Parent.Elm.value('(BirthDate)[1]','VARCHAR(20)') AS BirthDate,
		Parent.Elm.value('(Ethnicity)[1]','VARCHAR(50)') AS Ethnicity,  
		Parent.Elm.value('(CreatedOn)[1]','VARCHAR(30)') AS CreatedOn
	FROM @input.nodes('/Respondent') AS Parent(Elm)
	
	DECLARE @FirstName VARCHAR(50) 
	DECLARE @LastName VARCHAR(50)
	DECLARE @Gender VARCHAR(20)
	DECLARE @Age INT
	DECLARE @BirthDate VARCHAR(20) 
	DECLARE @UDF2 VARCHAR(50)
	DECLARE @CreatedOn VARCHAR(30)
	
	SELECT 
		@FirstName = FirstName, @LastName = LastName, @Gender = Gender, @Age = Age, 
		@BirthDate = BirthDate, @UDF2 = UDF2, @CreatedOn = CreatedOn
	FROM @SearchRespondent
	
	IF @FirstName = '' SET @FirstName = NULL
	IF @LastName = '' SET @LastName = NULL
	IF @Gender = '' SET @Gender = NULL
	IF @Age = 0 SET @Age = NULL
	IF @BirthDate = '' SET @BirthDate = NULL
	IF @UDF2 = '' SET @UDF2 = NULL
	IF @CreatedOn = '' SET @CreatedOn = NULL
		
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
			AND FirstName LIKE '%'+ISNULL(@FirstName,FirstName)+'%' 
			AND LastName LIKE '%'+ISNULL(@LastName,LastName)+'%'
			AND Gender LIKE '%'+ISNULL(@Gender,Gender)+'%'
			--AND Age LIKE ISNULL(@Age,Age)
			AND BirthDate LIKE '%'+ISNULL(@BirthDate,BirthDate)+'%' 
			AND UDF2 LIKE '%'+ISNULL(@UDF2,UDF2)+'%'
			--AND @CreatedOn = CreatedOn
		
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
		AND FirstName LIKE '%'+ISNULL(@FirstName,FirstName)+'%' 
			AND LastName LIKE '%'+ISNULL(@LastName,LastName)+'%'
			AND Gender LIKE '%'+ISNULL(@Gender,Gender)+'%'
			AND Age LIKE '%'+ISNULL(@Age,Age)+'%'
			AND BirthDate LIKE '%'+ISNULL(@BirthDate,BirthDate)+'%' 
			AND UDF2 LIKE '%'+ISNULL(@UDF2,UDF2)+'%'
			--AND @CreatedOn = CreatedOn
		ORDER BY FirstName, LastName ASC
	END
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 