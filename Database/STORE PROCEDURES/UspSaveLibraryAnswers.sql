IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveLibraryAnswers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveLibraryAnswers]
GO
/*
EXEC UspSaveLibraryAnswers 16, @XmlData='<?xml version="1.0" encoding="utf-16"?>
<Answer>
	<AnswerId></AnswerId>
	<AnswerDesc>Johnny Tested Successfully</AnswerDesc>
	<AnswerText>Johnny Test Successfully</AnswerText>
</Answer>'
*/
CREATE PROCEDURE DBO.UspSaveLibraryAnswers
	@QuestionLibId INT,
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	 
	CREATE TABLE #SurveyAnswers
	(AnswerId VARCHAR(20), Answer VARCHAR(1000), AnswerText VARCHAR(1000))
	INSERT INTO #SurveyAnswers
	(AnswerId, Answer, AnswerText)
	SELECT 
		Parent.Elm.value('(AnswerId)[1]','VARCHAR(20)') AS AnswerId,
		Parent.Elm.value('(AnswerDesc)[1]','VARCHAR(1000)') AS AnswerDesc,
		Parent.Elm.value('(AnswerText)[1]','VARCHAR(1000)') AS AnswerText
	--INTO #SurveyAnswers
	FROM @input.nodes('/Answer') AS Parent(Elm)
		
	DECLARE @AnswerId INT
	SET @AnswerId = 0

	INSERT INTO DBO.TR_QuestionLibraryAnswers
	(QuestionLibId, Answer, AnswerText) 
	SELECT 
		@QuestionLibId, Answer, AnswerText
	FROM #SurveyAnswers 
	
	SET @AnswerId = @@IDENTITY
	
	SELECT 
		CASE WHEN ISNULL(@AnswerId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN ISNULL(@AnswerId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
		@AnswerId AS AnswerId

	DROP TABLE #SurveyAnswers
		
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
