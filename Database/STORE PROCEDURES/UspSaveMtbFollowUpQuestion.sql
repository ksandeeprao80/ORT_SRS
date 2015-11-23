IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveMtbFollowUpQuestion]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveMtbFollowUpQuestion]
GO
/*
-- EXEC UspSaveMtbFollowUpQuestion 1102, '<?xml version="1.0" encoding="utf-16"?>
<Question>
	<Customer>
		<CustomerId>1</CustomerId>
		<IsActive>false</IsActive>
	</Customer>
	<QuestionType>Boolean</QuestionType>
	<QuestionText>why are you tired of ?</QuestionText>
	<IsDeleted>false</IsDeleted>
	<IsMediaFollowUp>false</IsMediaFollowUp>
	<Config>
		<ForceResponse>false</ForceResponse>
		<HasSkipLogic>false</HasSkipLogic>
		<HasEmailTrigger>false</HasEmailTrigger>
		<IsMtbQuestion>false</IsMtbQuestion>
		<HasMedia>false</HasMedia>
		<HasImage>false</HasImage>
		<IsPipedIn>false</IsPipedIn>
		<IsPipedOut>false</IsPipedOut>
		<VerifyRespondentInfo>false</VerifyRespondentInfo>
		<VerfiyDefaultAnswer>false</VerfiyDefaultAnswer>
		<CheckQuota>false</CheckQuota>
		<IsMediaFollowup>true</IsMediaFollowup>
		<AutoAdvance>false</AutoAdvance>
		<AutoPlay>false</AutoPlay>
		<RandomizeTestList>false</RandomizeTestList>
	</Config>
	<QuestionTag>Undefined</QuestionTag>
	<QuestionNo>47</QuestionNo>
	<PartOfReport>false</PartOfReport>
</Question>'
*/

CREATE PROCEDURE DBO.UspSaveMtbFollowUpQuestion
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
		CustomerId VARCHAR(20), QuestionType VARCHAR(100), QuestionText VARCHAR(2000), 
		IsDeleted VARCHAR(20), QuestionNo VARCHAR(20),IsFollowUp VARCHAR(20),
		MtbQuestionId INT
	)
	INSERT INTO #SurveyQuestions
	(CustomerId, QuestionType, QuestionText, IsDeleted, QuestionNo,IsFollowUp,MtbQuestionId)
	SELECT 
		Child.Elm.value('(CustomerId)[1]','VARCHAR(50)') AS CustomerId,
		Parent.Elm.value('(QuestionType)[1]','VARCHAR(100)') AS QuestionType,
		Parent.Elm.value('(QuestionText)[1]','VARCHAR(2000)') AS QuestionText,
		Parent.Elm.value('(IsDeleted)[1]','VARCHAR(20)') AS IsDeleted,
		Parent.Elm.value('(QuestionNo)[1]','VARCHAR(20)') AS QuestionNo,
		Child1.Elm.value('(IsMediaFollowup)[1]','VARCHAR(20)') AS IsFollowUp,
		Child1.Elm.value('(MtbQuestionId)[1]','VARCHAR(20)') AS MtbQuestionId
	FROM @input.nodes('/Question') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Customer') AS Child(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Config') AS Child1(Elm)

	BEGIN TRAN
	
	    DECLARE @MtbQuestionId INT,@QuestionId INT,@FollowupQuestionId INT,@QuestionNo INT,@CustomerId INT
	    
	    SELECT @QuestionNo = CONVERT(INT,QuestionNo),@CustomerId = CONVERT(int,CustomerId) FROM #SurveyQuestions

		SELECT @MtbQuestionId = CONVERT(INT,MtbQuestionId) FROM #SurveyQuestions

		SELECT @FollowupQuestionId = FollowUpQuestionId   
		FROM DBO.TR_QuestionFollowUpMap WHERE QuestionId = @MtbQuestionId
		
		DECLARE @Value VARCHAR(5)
		SET @Value = ''

		IF @FollowupQuestionId <> 0
	 	BEGIN
			DELETE TET FROM DBO.TR_EmailTrigger TET 
			INNER JOIN DBO.MS_QuestionBranches MQB 
				ON TET.BranchId = MQB.BranchId AND MQB.QuestionId = @FollowupQuestionId AND MQB.BranchType = 'Email'
				
			DELETE FROM DBO.MS_QuestionBranches WHERE QuestionId = @FollowupQuestionId AND BranchType = 'Email'

			DELETE TQQ FROM DBO.TR_QuestionQuota TQQ 
			INNER JOIN DBO.MS_QuestionBranches MQB ON TQQ.BranchId = MQB.BranchId 
				AND MQB.QuestionId = @FollowupQuestionId AND MQB.BranchType = 'Quota'
				
			DELETE FROM DBO.MS_QuestionBranches WHERE QuestionId = @FollowupQuestionId AND BranchType = 'Quota'	

			DELETE TSL FROM DBO.TR_SkipLogic TSL
			INNER JOIN DBO.MS_QuestionBranches MQB ON TSL.BranchId = MQB.BranchId 
				AND MQB.QuestionId = @FollowupQuestionId AND MQB.BranchType = 'Skip'

			DELETE FROM DBO.MS_QuestionBranches WHERE QuestionId = @FollowupQuestionId AND BranchType = 'Skip'	
			
			DELETE FROM DBO.TR_EmailDetails WHERE QuestionId = @FollowupQuestionId

			DELETE FROM DBO.TR_MediaInfo WHERE QuestionId = @FollowupQuestionId

			DELETE TMSL FROM DBO.TR_MediaSkipLogic TMSL 
			INNER JOIN DBO.MS_QuestionBranches MQB 
				ON TMSL.BranchId = MQB.BranchId AND MQB.QuestionId = @FollowupQuestionId AND MQB.BranchType = 'Media'
			DELETE FROM DBO.MS_QuestionBranches WHERE QuestionId = @FollowupQuestionId AND BranchType = 'Media'
			
			DELETE FROM DBO.TR_QuestionSettings WHERE QuestionId = @FollowupQuestionId

			DELETE FROM DBO.TR_Responses WHERE QuestionId = @FollowupQuestionId

			DELETE FROM DBO.TR_SurveyAnswers WHERE QuestionId = @FollowupQuestionId

			DELETE FROM DBO.TR_SurveyQuestions WHERE QuestionId = @FollowupQuestionId
			
			DELETE FROM dbo.TR_QuestionFollowUpMap WHERE QuestionId = @MtbQuestionId
	END
	
			INSERT INTO DBO.TR_SurveyQuestions
			(SurveyId, CustomerId, QuestionTypeId, QuestionText, IsDeleted, QuestionNo)
			SELECT 
				@SurveyId, @CustomerId AS CustomerId, MQT.QuestionTypeId, SQ.QuestionText, 1 AS IsDeleted, 
				@QuestionNo--+1
			FROM #SurveyQuestions SQ
			INNER JOIN DBO.MS_QuestionTypes MQT
				ON SQ.QuestionType = MQT.QuestionCode
				
			SET @FollowupQuestionId = @@IDENTITY
			
			INSERT INTO TR_QuestionFollowUpMap(QuestionId,FollowUpQuestionId)
			VALUES (@MtbQuestionId,@FollowupQuestionId)
			
			SELECT CASE WHEN ISNULL(@FollowupQuestionId,0) = 0 THEN 0 ELSE 1 END AS RetValue,
				CASE WHEN ISNULL(@FollowupQuestionId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
				ISNULL(@FollowupQuestionId,0) AS QuestionId,@QuestionNo/*+1*/ AS QuestionNo
				
	
	DROP TABLE #SurveyQuestions
		
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

