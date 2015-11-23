IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSurveyRequestDetails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveSurveyRequestDetails
GO 
/*
EXEC UspSaveSurveyRequestDetails @XMlData='<?xml version="1.0" encoding="utf-16"?>
<SurveyDetailsFromRequest>
  <SurveyId>1240</SurveyId>
  <RespondentId>3319</RespondentId>
  <SurveyKey>EQXUQRSAYKKKENFXRGJS</SurveyKey>
  <RenderMode>R</RenderMode>
   <QuestionId>123</QuestionId>
   <RefereeId></RefereeId>
   <Channel>Facebook</Channel>
   <InviteId>1</InviteId>
</SurveyDetailsFromRequest>'
*/
CREATE PROCEDURE DBO.UspSaveSurveyRequestDetails 
	@XMlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DECLARE @input XML = @XmlData
	
	CREATE TABLE #SurveyDetailsFromRequest
	(
		RequestId INT IDENTITY(1,1), SurveyId VARCHAR(20), RespondentId VARCHAR(20), RespondentSessionId VARCHAR(100),
		SurveyPassword VARCHAR(100), SurveyKey VARCHAR(100), RenderMode CHAR(1), QuestionId INT, RefereeId INT,
		Channel VARCHAR(100), InviteId INT
	)
	INSERT INTO #SurveyDetailsFromRequest
	(
		SurveyId, RespondentId, RespondentSessionId, SurveyPassword, SurveyKey, RenderMode, 
		QuestionId, RefereeId, Channel, InviteId
	)
	SELECT
		Parent.Elm.value('(SurveyId)[1]','VARCHAR(20)') AS SurveyId,
		Parent.Elm.value('(RespondentId)[1]','VARCHAR(20)') AS RespondentId,
		Parent.Elm.value('(RespondentSessionId)[1]','VARCHAR(100)') AS RespondentSessionId,
		Parent.Elm.value('(SurveyPassword)[1]','VARCHAR(100)') AS SurveyPassword,
		Parent.Elm.value('(SurveyKey)[1]','VARCHAR(100)') AS SurveyKey,
		Parent.Elm.value('(RenderMode)[1]','VARCHAR(1)') AS RenderMode,
		Parent.Elm.value('(QuestionId)[1]','VARCHAR(12)') AS QuestionId,
		Parent.Elm.value('(RefereeId)[1]','VARCHAR(12)') AS RefereeId,
		Parent.Elm.value('(Channel)[1]','VARCHAR(100)') AS Channel,
		Parent.Elm.value('(InviteId)[1]','VARCHAR(12)') AS InviteId
	-- INTO #SurveyDetailsFromRequest
	FROM @input.nodes('/SurveyDetailsFromRequest') AS Parent(Elm)
	
	INSERT INTO DBO.Audit_SurveyRequestDetails
	(
		SurveyId, RespondentId, RespondentSessionId, SurveyPassword, SurveyKey, RenderMode, QuestionId, 
		AuditDate, RefereeId, Channel, InviteId
	)
	SELECT 
		SurveyId, RespondentId, RespondentSessionId, SurveyPassword, SurveyKey, RenderMode, QuestionId, 
		GETDATE(), RefereeId, LTRIM(RTRIM(Channel)), InviteId
	FROM #SurveyDetailsFromRequest
	
	DELETE TSRD
	FROM DBO.TR_SurveyRequestDetails TSRD
	INNER JOIN #SurveyDetailsFromRequest SDFR
		ON LTRIM(RTRIM(TSRD.SurveyId)) = LTRIM(RTRIM(SDFR.SurveyId))
		AND LTRIM(RTRIM(TSRD.RespondentId)) = LTRIM(RTRIM(SDFR.RespondentId))
		AND LTRIM(RTRIM(TSRD.Channel)) = LTRIM(RTRIM(SDFR.Channel))
		AND LTRIM(RTRIM(TSRD.RenderMode)) = LTRIM(RTRIM(SDFR.RenderMode))
	
	INSERT INTO DBO.TR_SurveyRequestDetails
	(
		SurveyId, RespondentId, RespondentSessionId, SurveyPassword, SurveyKey, RenderMode, 
		QuestionId, RefereeId, Channel, InviteId
	)
	SELECT 
		SurveyId, RespondentId, RespondentSessionId, SurveyPassword, SurveyKey, RenderMode, QuestionId, 
		RefereeId, LTRIM(RTRIM(Channel)), InviteId
	FROM #SurveyDetailsFromRequest

	SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark

	DROP TABLE #SurveyDetailsFromRequest	

	COMMIT TRAN

END TRY

BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
