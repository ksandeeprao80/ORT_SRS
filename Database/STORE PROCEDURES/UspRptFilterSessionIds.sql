IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptFilterSessionIds]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptFilterSessionIds]

GO

 --EXEC UspRptFilterSessionIds NULL,40
 --SELECT * FROM TempFilterSessionIds
	
CREATE PROCEDURE DBO.UspRptFilterSessionIds
	@QuestionId INT,
	@ReportId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	CREATE TABLE #ReportFilter
	(
		RowId INT IDENTITY(1,1), FilterId INT, QuestionId INT, Operator VARCHAR(30),
		AnswerId INT, AnswerText VARCHAR(30), FilterOperator VARCHAR(10), Conjunction VARCHAR(20)
	)
	INSERT INTO #ReportFilter
	(FilterId,QuestionId,Operator,AnswerId,AnswerText,FilterOperator, Conjunction)
	SELECT 
		TRF.FilterId, TRF.QuestionId, TRF.Operator, TRF.AnswerId, TRF.AnswerText, TRF.FilterOperator, TRFM.Conjuction
	FROM TR_ReportFilter TRF
	INNER JOIN dbo.TR_ReportFilterMapping TRFM
		ON TRF.FilterId = TRFM.FilterId
	WHERE TRFM.ReportId = @ReportId
	ORDER BY TRFM.Conjuction DESC

	DECLARE @Coma VARCHAR(1)
	DECLARE @SessionId VARCHAR(250)
	DECLARE @MinRow INT, @MaxRow INT
	DECLARE @SQL NVARCHAR(MAX)	
	DECLARE @FirstRow NVARCHAR(1000)
	DECLARE @FilterString VARCHAR(8000)
	DECLARE @AddFilterString VARCHAR(8000)
	
	SET @AddFilterString = ''
	SET @FilterString = ''
	SET @MinRow = 2
	SET @Coma = ''''
	
	SELECT 
		RowId,
		'QuestionId ='+CONVERT(VARCHAR(12),QuestionId)+ 
		CASE WHEN Operator IN ('IN','NOT IN') THEN ' AND AnswerId' ELSE ' AND AnswerText' END+ 
		CASE WHEN Operator='IN' THEN '=' 
			 WHEN Operator='NOT IN' THEN '<>' ELSE Operator END+
		CASE WHEN Operator IN ('IN','NOT IN') THEN  @Coma+CONVERT(VARCHAR(12),AnswerId)+@Coma ELSE @Coma+AnswerText+@Coma END
		+ ')' AS Filter, Conjunction  
	INTO #ReportFilter1	
	FROM #ReportFilter

	SELECT @MaxRow = MAX(RowId) FROM #ReportFilter

	IF @MaxRow = 1
		SET @SessionId = 'A.SessionId'
	IF @MaxRow = 2
		SET @SessionId = 'ISNULL(B.SessionId,A.SessionId)'
	IF @MaxRow = 3
		SET @SessionId = 'ISNULL(C.SessionId,ISNULL(B.SessionId,A.SessionId))'
	IF @MaxRow = 4
		SET @SessionId = 'ISNULL(D.SessionId,ISNULL(C.SessionId,ISNULL(B.SessionId,A.SessionId)))'
	IF @MaxRow = 5
		SET @SessionId = 'ISNULL(E.SessionId,ISNULL(D.SessionId,ISNULL(C.SessionId,ISNULL(B.SessionId,A.SessionId))))'
	IF @MaxRow = 6
		SET @SessionId = 'ISNULL(F.SessionId,ISNULL(E.SessionId,ISNULL(D.SessionId,ISNULL(C.SessionId,ISNULL(B.SessionId,A.SessionId)))))'
	IF @MaxRow = 7
		SET @SessionId = 'ISNULL(G.SessionId,ISNULL(F.SessionId,ISNULL(E.SessionId,ISNULL(D.SessionId,ISNULL(C.SessionId,ISNULL(B.SessionId,A.SessionId))))))'
	IF @MaxRow = 8
		SET @SessionId = 'ISNULL(H.SessionId,ISNULL(G.SessionId,ISNULL(F.SessionId,ISNULL(E.SessionId,ISNULL(D.SessionId,ISNULL(C.SessionId,ISNULL(B.SessionId,A.SessionId)))))))'
	IF @MaxRow = 9
		SET @SessionId = 'ISNULL(I.SessionId,ISNULL(H.SessionId,ISNULL(G.SessionId,ISNULL(F.SessionId,ISNULL(E.SessionId,ISNULL(D.SessionId,ISNULL(C.SessionId,ISNULL(B.SessionId,A.SessionId))))))))'
	IF @MaxRow = 10
		SET @SessionId = 'ISNULL(J.SessionId,ISNULL(I.SessionId,ISNULL(H.SessionId,ISNULL(G.SessionId,ISNULL(F.SessionId,ISNULL(E.SessionId,ISNULL(D.SessionId,ISNULL(C.SessionId,ISNULL(B.SessionId,A.SessionId)))))))))'

	SELECT @FirstRow = 
		'SELECT DISTINCT '+ @SessionId +' AS SessionId FROM '+' (SELECT * FROM TR_Responses WHERE '+
		Filter +' A ' + CASE WHEN Conjunction = 'and' THEN ' INNER JOIN ' 
				      WHEN Conjunction = 'or' THEN ' LEFT JOIN ' 
				      ELSE ' ' END
	FROM #ReportFilter1	WHERE RowId = 1

	WHILE @MinRow <= @MaxRow
	BEGIN
		SELECT @FilterString = '(SELECT * FROM TR_Responses WHERE '+ 
								Filter
								+ CASE WHEN @MinRow = 2 THEN ' B ON A.SessionId = B.SessionId '
										WHEN @MinRow = 3 THEN ' C ON A.SessionId = C.SessionId '
										WHEN @MinRow = 4 THEN ' D ON A.SessionId = D.SessionId '
										WHEN @MinRow = 5 THEN ' E ON A.SessionId = E.SessionId '
										WHEN @MinRow = 6 THEN ' F ON A.SessionId = F.SessionId '
										WHEN @MinRow = 7 THEN ' G ON A.SessionId = G.SessionId '
										WHEN @MinRow = 8 THEN ' H ON A.SessionId = H.SessionId '
										WHEN @MinRow = 9 THEN ' I ON A.SessionId = I.SessionId '
										WHEN @MinRow = 10 THEN ' J ON A.SessionId = J.SessionId '
										ELSE '  ' END
								+ CASE WHEN Conjunction = 'and' THEN ' INNER JOIN ' 
											  WHEN Conjunction = 'or' THEN ' LEFT JOIN ' ELSE ' ' END 
		FROM #ReportFilter1 
		WHERE RowId = @MinRow
							    
		SET @AddFilterString = ISNULL(@AddFilterString,'')+@FilterString 
		
		SET @MinRow = @MinRow+1
	END		

	SET @SQL = @FirstRow + @AddFilterString
	
	TRUNCATE TABLE DBO.TempFilterSessionIds

	INSERT INTO DBO.TempFilterSessionIds
	(SessionId)
	EXEC SP_Executesql @SQL 

	DROP TABLE #ReportFilter
	DROP TABLE #ReportFilter1
	
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END



 