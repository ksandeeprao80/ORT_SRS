IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspCheckRewardApplicable]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspCheckRewardApplicable

GO

-- EXEC UspCheckRewardApplicable 1101
CREATE PROCEDURE DBO.UspCheckRewardApplicable
	@SurveyId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	IF EXISTS(SELECT 1 FROM DBO.TR_Reward WHERE SurveyId = @SurveyId)
	BEGIN
		SELECT 1 AS RetValue, 'Survey Exist In The System' AS Remark
	END
	ELSE
	BEGIN
		SELECT 0 AS RetValue, 'Survey Not Exist In The System' AS Remark
	END

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

