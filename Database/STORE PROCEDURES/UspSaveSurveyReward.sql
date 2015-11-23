IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSurveyReward]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveSurveyReward]
GO
/*
-- EXEC UspSaveSurveyReward '<?xml version="1.0" encoding="utf-16"?>
<Reward>
  <Fees>50</Fees>
  <ApproxValue>5</ApproxValue>
  <Customer>
		<CustomerId>1</CustomerId>
		<IsActive>false</IsActive>
  </Customer>
  <RewardSurvey>
    <SurveyId>1101</SurveyId>
    <RewardEnabled>false</RewardEnabled>
    <Starred>false</Starred>
    <IsActive>false</IsActive>
  </RewardSurvey>
  <TotalRewards>10</TotalRewards>
</Reward>'
*/
CREATE PROCEDURE DBO.UspSaveSurveyReward
	@XmlData NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData 

	CREATE TABLE #Reward
	(SurveyId VARCHAR(20), CustomerId VARCHAR(20), Fees VARCHAR(50), ApproxValue VARCHAR(50), TotalRewards VARCHAR(50)) 
	INSERT INTO #Reward
	(SurveyId, CustomerId, Fees, ApproxValue, TotalRewards) 
	SELECT
		Child1.Elm.value('(SurveyId)[1]','VARCHAR(100)') AS SurveyId,
		Child.Elm.value('(CustomerId)[1]','VARCHAR(100)') AS CustomerId,
		Parent.Elm.value('(Fees)[1]','VARCHAR(20)') AS Fees,
		Parent.Elm.value('(ApproxValue)[1]','VARCHAR(250)') AS ApproxValue,
		Parent.Elm.value('(TotalRewards)[1]','VARCHAR(50)') AS TotalRewards
	FROM @input.nodes('/Reward') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Customer') AS Child(Elm)
	CROSS APPLY
		Parent.Elm.nodes('RewardSurvey') AS Child1(Elm)

	DECLARE @RewardId INT
	SET @RewardId = 0
 
 
	DECLARE @SurveyId INT
	SELECT @SurveyId = CONVERT(INT,SurveyId) FROM #Reward
	
	IF EXISTS(SELECT 1 FROM DBO.TR_Reward WHERE SurveyId = @SurveyId)
	BEGIN
		UPDATE TR
		SET TR.Fees = R.Fees, 
			TR.ApproxValue = R.ApproxValue,
			TR.TotalRewards = R.TotalRewards
		FROM DBO.TR_Reward TR
		INNER JOIN #Reward R
			ON TR.SurveyId = R.SurveyId
			
		SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark,RewardId FROM DBO.TR_Reward WHERE SurveyId = @SurveyId
	END
	ELSE
	BEGIN
 		INSERT INTO DBO.TR_Reward
		(SurveyId, CustomerId, Fees, ApproxValue, TotalRewards)
		SELECT
			SurveyId, CustomerId, Fees, ApproxValue, TotalRewards
 		FROM #Reward

		SET @RewardId = @@IDENTITY

		SELECT CASE WHEN @RewardId = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN @RewardId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark, 
			@RewardId AS RewardId
	END
		
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark, 0 AS RewardId
END CATCH 

SET NOCOUNT OFF
END