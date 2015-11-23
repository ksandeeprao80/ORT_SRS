IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspCheckSurveyName]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspCheckSurveyName

GO
-- EXEC DBO.UspCheckSurveyName 'Adelaide November'

CREATE PROCEDURE DBO.UspCheckSurveyName
	@SurveyName VARCHAR(50)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	IF EXISTS(SELECT 1 FROM dbo.TR_Survey WHERE LTRIM(RTRIM(SurveyName)) = LTRIM(RTRIM(@SurveyName)))
	BEGIN
		SELECT 0 AS RetValue, 'Survey name already exists.' AS Remark
	END
	ELSE
	BEGIN
		SELECT 1 AS RetValue, 'Success' AS Remark
	END

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
