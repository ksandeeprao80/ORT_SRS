IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetReward]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetReward]

GO

-- EXEC UspGetReward 1202
CREATE PROCEDURE DBO.UspGetReward
	@SurveyId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		RewardId, SurveyId, CustomerId, ISNULL(Fees,0) AS Fees, ISNULL(RewardName,'') AS RewardName,
		ISNULL(RewardDescription,'') AS RewardDescription, ISNULL(ApproxValue,0) AS ApproxValue, 
		ISNULL(EndDate,'') AS EndDate, ISNULL(TotalRewards,'0') AS TotalRewards
	FROM DBO.TR_Reward 
	WHERE SurveyId = ISNULL(@SurveyId,SurveyId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END