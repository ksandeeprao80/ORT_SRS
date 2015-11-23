IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSurveyQuestions]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveSurveyQuestions]
GO
/*
-- EXEC UspSaveSurveyQuestions 1102, '<?xml version="1.0" encoding="utf-16"?>
<Question>
  <Customer>
    <CustomerId>1</CustomerId>
    <IsActive>false</IsActive>
  </Customer>
  <QuestionId>8943</QuestionId>
  <QuestionType>SingleChoice</QuestionType>
  <Answers>
    <Answer>
      <AnswerDesc>Singer</AnswerDesc>
      <AnswerText>Singer</AnswerText>
    </Answer>
    <Answer>
      <AnswerDesc>Dancer</AnswerDesc>
      <AnswerText>Dancer</AnswerText>
    </Answer>
    <Answer>
      <AnswerDesc>Musician</AnswerDesc>
      <AnswerText>Musician</AnswerText>
    </Answer>
  </Answers>
  <QuestionText>Tested By JD</QuestionText>
  <IsDeleted>false</IsDeleted>
  <IsMediaFollowUp>false</IsMediaFollowUp>
  <QuestionTag>Undefined</QuestionTag>
  <QuestionNo>1</QuestionNo>
  <PreviousQuestionNo>16</PreviousQuestionNo>
</Question>'
*/

CREATE PROCEDURE DBO.UspSaveSurveyQuestions
	@SurveyId INT,
	@XmlData AS NTEXT,
	@XmlUserInfo AS NTEXT 
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo

	DECLARE @UserId INT
	SELECT @UserId = CONVERT(INT,UserId) FROM @UserInfo
	
	DECLARE @input XML = @XmlData
	
	CREATE TABLE #SurveyQuestions
	(
		QuestionId VARCHAR(20), CustomerId VARCHAR(20), QuestionType VARCHAR(100), QuestionText NVARCHAR(2000), 
		IsDeleted VARCHAR(20), QuestionNo VARCHAR(20), PreviousQuestionNo VARCHAR(20)
	)
	INSERT INTO #SurveyQuestions
	(
		QuestionId, CustomerId, QuestionType, QuestionText, IsDeleted, QuestionNo, PreviousQuestionNo
	)
	SELECT 
		Parent.Elm.value('(QuestionId)[1]','VARCHAR(20)') AS QuestionId,
		Child.Elm.value('(CustomerId)[1]','VARCHAR(50)') AS CustomerId,
		Parent.Elm.value('(QuestionType)[1]','VARCHAR(100)') AS QuestionType,
		Parent.Elm.value('(QuestionText)[1]','NVARCHAR(2000)') AS QuestionText,
		Parent.Elm.value('(IsDeleted)[1]','VARCHAR(20)') AS IsDeleted,
		Parent.Elm.value('(QuestionNo)[1]','VARCHAR(20)') AS QuestionNo,
		Parent.Elm.value('(PreviousQuestionNo)[1]','VARCHAR(20)') AS PreviousQuestionNo
	--INTO #SurveySettings
	FROM @input.nodes('/Question') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Customer') AS Child(Elm)

	BEGIN TRAN
	
	DECLARE @PreviousQuestionNo INT
	DECLARE @QuestionNo INT
	SET @QuestionNo = 0
	SET @PreviousQuestionNo = 0
	
	SELECT @PreviousQuestionNo = CASE WHEN PreviousQuestionNo IS NULL THEN 0 
									  WHEN PreviousQuestionNo = '-1'  THEN 0 ELSE CONVERT(INT,PreviousQuestionNo) END FROM #SurveyQuestions 
	
	SELECT @QuestionNo = ISNULL(TSQ.QuestionNo,0) 
	FROM DBO.TR_SurveyQuestions TSQ INNER JOIN #SurveyQuestions SQ 
	ON CONVERT(VARCHAR(20),TSQ.QuestionId) = LTRIM(RTRIM(SQ.QuestionId))

	IF EXISTS
	(
		SELECT 1 FROM #SurveyQuestions SQ INNER JOIN DBO.TR_SurveyQuestions TSQ 
		ON LTRIM(RTRIM(SQ.QuestionId)) = CONVERT(VARCHAR(20),TSQ.QuestionId) 
	)
	BEGIN
		IF @QuestionNo < @PreviousQuestionNo
		BEGIN
			UPDATE DBO.TR_SurveyQuestions
			SET QuestionNo = QuestionNo-1
			WHERE SurveyId = @SurveyId
				AND QuestionNo > @QuestionNo 
				AND QuestionNo <= @PreviousQuestionNo
				
			UPDATE TSQ
			SET TSQ.QuestionTypeId = MQT.QuestionTypeId,
				TSQ.QuestionText = SQ.QuestionText,
				TSQ.IsDeleted = CASE WHEN SQ.IsDeleted = 'False' THEN 1 ELSE 0 END,
				TSQ.QuestionNo = @PreviousQuestionNo
			FROM DBO.TR_SurveyQuestions TSQ
			INNER JOIN #SurveyQuestions SQ
				ON TSQ.QuestionId = CONVERT(INT,SQ.QuestionId)
				AND TSQ.SurveyId = @SurveyId
			INNER JOIN DBO.MS_QuestionTypes MQT
				ON LTRIM(RTRIM(SQ.QuestionType)) = LTRIM(RTRIM(MQT.QuestionCode))
		END
		
		IF @QuestionNo > @PreviousQuestionNo
		BEGIN
			UPDATE DBO.TR_SurveyQuestions
			SET QuestionNo = QuestionNo+1
			WHERE SurveyId = @SurveyId
				AND QuestionNo > @PreviousQuestionNo 
				AND QuestionNo < @QuestionNo
				
			UPDATE TSQ
			SET TSQ.QuestionTypeId = MQT.QuestionTypeId,
				TSQ.QuestionText = SQ.QuestionText,
				TSQ.IsDeleted = CASE WHEN SQ.IsDeleted = 'False' THEN 1 ELSE 0 END,
				TSQ.QuestionNo = @PreviousQuestionNo+1
			FROM DBO.TR_SurveyQuestions TSQ
			INNER JOIN #SurveyQuestions SQ
				ON TSQ.QuestionId = CONVERT(INT,SQ.QuestionId)
				AND TSQ.SurveyId = @SurveyId
			INNER JOIN DBO.MS_QuestionTypes MQT
				ON LTRIM(RTRIM(SQ.QuestionType)) = LTRIM(RTRIM(MQT.QuestionCode))
		END
						
		SELECT 1 AS RetValue, 'Successfully Updated' AS Remark, QuestionId, QuestionNo FROM #SurveyQuestions
	END
	ELSE		
	BEGIN
		DECLARE @QuestionId INT 
		SET @QuestionId = 0 
		
		UPDATE DBO.TR_SurveyQuestions
		SET QuestionNo = QuestionNo+1
		WHERE SurveyId = @SurveyId
			AND QuestionNo > @PreviousQuestionNo
			
		INSERT INTO DBO.TR_SurveyQuestions
		(SurveyId, CustomerId, QuestionTypeId, QuestionText, IsDeleted, QuestionNo) 
		SELECT 
			@SurveyId, CONVERT(INT,CustomerId), MQT.QuestionTypeId, SQ.QuestionText, 1 AS IsDeleted, 
			ISNULL(@PreviousQuestionNo,0)+1
		FROM #SurveyQuestions SQ
		INNER JOIN DBO.MS_QuestionTypes MQT
			ON LTRIM(RTRIM(SQ.QuestionType)) = LTRIM(RTRIM(MQT.QuestionCode))
			AND ISNULL(SQ.QuestionId,'') = '' 
		 
		SET @QuestionId = @@IDENTITY
		 
		SELECT 
			CASE WHEN ISNULL(@QuestionId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN ISNULL(@QuestionId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
			QuestionId, QuestionNo 
		FROM DBO.TR_SurveyQuestions
		WHERE QuestionId = @QuestionId
	END

	UPDATE DBO.TR_Survey SET ModifiedBy = @UserId, ModifiedDate = GETDATE() WHERE SurveyId = @SurveyId

	DROP TABLE #SurveyQuestions
		
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

