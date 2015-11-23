IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetQuestionTypes]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetQuestionTypes]

GO

--EXEC UspGetQuestionTypes
CREATE PROCEDURE DBO.UspGetQuestionTypes
	@QuestionTypeId INT = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT  
		QuestionTypeId, ISNULL(QuestionCode,'') AS QuestionCode, ISNULL(QuestionName,'') AS QuestionName, 
		ISNULL(SampleTemplate,'') AS SampleTemplate, ISNULL(BlankTemplate,'') AS BlankTemplate
	FROM DBO.MS_QuestionTypes WITH(NOLOCK)
	WHERE QuestionTypeId = ISNULL(@QuestionTypeId,QuestionTypeId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END