IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetQuestionTags]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetQuestionTags]

GO

--EXEC UspGetQuestionTags  
CREATE PROCEDURE DBO.UspGetQuestionTags
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT 
		QuestionTagId, TagName
	FROM DBO.MS_QuestionTags WITH(NOLOCK)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 