IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspCopySurvey]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspCopySurvey

GO
/*
EXEC UspCopySurvey @XmlData='<?xml version="1.0" encoding="utf-16"?>
<Survey>
  <SurveyId>1321</SurveyId>
  <SurveyName>SurveyCopy_5_1321</SurveyName>
  <RewardEnabled>false</RewardEnabled>
  <Starred>false</Starred>
  <IsActive>false</IsActive>
   <SurveyEndDate>04/30/2013</SurveyEndDate>
  <SurveyLibrary>
    <LibType>Survey</LibType>
    <Category>
      <CategoryId>667</CategoryId>
    </Category>
  </SurveyLibrary>
</Survey>',@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
<User>
  <UserId>98</UserId>
  <UserName>Nilesh More</UserName>
  <UserDetails>
    <IsActive>false</IsActive>
    <Customer>
      <CustomerId>56</CustomerId>
      <IsActive>false</IsActive>
    </Customer>
    <UserRole>
      <RoleId>1</RoleId>
      <RoleDesc>Group User</RoleDesc>
      <Hierarchy>2</Hierarchy>
    </UserRole>
  </UserDetails>
</User>'
*/
CREATE PROCEDURE DBO.UspCopySurvey
	@XmlData AS NTEXT,
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	--- XML DATA CODE START -----------------------------------------------------------------------------
	
	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo
	
	DECLARE @input XML = @XmlData
	 
	CREATE TABLE #Survey 
	(
		SurveyId VARCHAR(20), SurveyName NVARCHAR(50), RewardEnabled VARCHAR(20), Starred VARCHAR(20),
		IsActive VARCHAR(20), SurveyEndDate VARCHAR(20),CategoryId INT
	)
	INSERT INTO #Survey
	(
		SurveyId, SurveyName, RewardEnabled, IsActive, SurveyEndDate,CategoryId
	)
	SELECT 
		Parent.Elm.value('(SurveyId)[1]','VARCHAR(20)') AS SurveyId,
		Parent.Elm.value('(SurveyName)[1]','NVARCHAR(50)') AS SurveyName,
		Parent.Elm.value('(RewardEnabled)[1]','VARCHAR(20)') AS RewardEnabled,
		Parent.Elm.value('(IsActive)[1]','VARCHAR(20)') AS IsActive,
		Parent.Elm.value('(SurveyEndDate)[1]','VARCHAR(25)') AS SurveyEndDate,
		Child.Elm.value('(CategoryId)[1]','INT') AS CategoryId
	FROM @input.nodes('/Survey') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('SurveyLibrary/Category') AS Child(Elm)

	DECLARE @UserId INT, @CustomerId INT, @SurveyId INT, @SurveyName NVARCHAR(50)
	SELECT @UserId = CONVERT(INT,UserId) FROM @UserInfo
	SELECT @CustomerId = CONVERT(INT,CustomerId) FROM @UserInfo
	SELECT @SurveyId = CONVERT(INT,SurveyId), @SurveyName = SurveyName FROM #Survey


	--- XML DATA CODE FINISH -----------------------------------------------------------------------------

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN ('SLU'))
	BEGIN
		SELECT 0 AS RetValue, 'Access Denied' AS Remark
		COMMIT TRAN	
	END

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SU') 
	BEGIN
		IF NOT EXISTS
		(
			SELECT 1 FROM #Survey S INNER JOIN DBO.TR_Survey TS 
			ON TS.SurveyId = CONVERT(INT,S.SurveyId) AND CreatedBy = @UserId
		)
		BEGIN
			SELECT 0 AS RetValue, 'Access Denied' AS Remark
			COMMIT TRAN	
		END
	END
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'GU') 
	BEGIN
		IF NOT EXISTS
		(	
			SELECT 1 FROM #Survey S INNER JOIN DBO.TR_Survey TS 
			ON TS.SurveyId = CONVERT(INT,S.SurveyId) AND CustomerId = @CustomerId
		)
		BEGIN
			SELECT 0 AS RetValue, 'Access Denied' AS Remark
			COMMIT TRAN
		END
	END

	-- DBO.TR_Survey
		
	DECLARE @NewSurveyId INT
	SET @NewSurveyId = 0

	INSERT INTO DBO.TR_Survey
	(
		SurveyName, CustomerId, StarMarked, RewardEnabled, CreatedBy, CreatedDate, IsActive, 
		StatusId, CategoryId, LanguageId, SurveyEndDate
	)
	SELECT  
		@SurveyName, CustomerId, StarMarked, RewardEnabled, @UserId, GETDATE(), 1 AS IsActive, 
		0 AS StatusId, CategoryId, LanguageId, SurveyEndDate
	FROM DBO.TR_Survey WHERE SurveyId = @SurveyId 
	
	SET @NewSurveyId = @@IDENTITY

	-- DBO.TR_SurveyQuestions
	
	INSERT INTO DBO.TR_SurveyQuestions 
	(SurveyId, CustomerId, QuestionTypeId, QuestionText, IsDeleted, DefaultAnswerId, QuestionNo)
	SELECT @NewSurveyId, CustomerId, QuestionTypeId, QuestionText, IsDeleted, DefaultAnswerId, QuestionNo
	FROM DBO.TR_SurveyQuestions WHERE SurveyId = @SurveyId AND QuestionNo <> 0 
	
	-- All data of old and new question answer mapping taken in temp table
	CREATE TABLE #OldNewQuestionMap
	(OldSurveyId INT, NewSurveyId INT, OldQuestionId INT, NewQuestionId INT, QuestionNo INT, QuestionText NVARCHAR(2000))
	INSERT INTO #OldNewQuestionMap
	(OldSurveyId, NewSurveyId, OldQuestionId, QuestionNo, QuestionText)
	SELECT SurveyId, @NewSurveyId, QuestionId, QuestionNo, QuestionText 
	FROM DBO.TR_SurveyQuestions WHERE SurveyId = @SurveyId  AND QuestionNo <> 0 

	-- Old and New Question Mapped
	UPDATE ONQM
	SET ONQM.NewQuestionId = TSQ.QuestionId
	FROM #OldNewQuestionMap ONQM
	INNER JOIN DBO.TR_SurveyQuestions TSQ 
		ON ONQM.QuestionNo = TSQ.QuestionNo AND ONQM.QuestionText  = TSQ.QuestionText AND TSQ.SurveyId = @NewSurveyId

	-- DBO.TR_SurveyAnswers
	
	CREATE TABLE #OldNewAnswerMap
	(
		OldSurveyId INT, OldQuestionId INT, NewQuestionId INT, OldAnswerId INT, NewAnswerId INT, 
		Answer NVARCHAR(1000), AnswerText NVARCHAR(1000)
	)
	INSERT INTO #OldNewAnswerMap
	(OldSurveyId, OldQuestionId, NewQuestionId, OldAnswerId, Answer, AnswerText)
	SELECT @SurveyId, TSA.QuestionId, ONQM.NewQuestionId, TSA.AnswerId, TSA.Answer, TSA.AnswerText
	FROM DBO.TR_SurveyAnswers TSA
	INNER JOIN #OldNewQuestionMap ONQM ON TSA.QuestionId = ONQM.OldQuestionId
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId, Answer, AnswerText)
	SELECT ONQM.NewQuestionId, TSA.Answer, TSA.AnswerText 
	FROM DBO.TR_SurveyAnswers TSA
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TSA.QuestionId = TSQ.QuestionId AND TSQ.SurveyId = @SurveyId
	INNER JOIN #OldNewQuestionMap ONQM ON TSQ.QuestionId = ONQM.OldQuestionId	
	 
	UPDATE ONAM
	SET ONAM.NewAnswerId = TSA.AnswerId
	FROM #OldNewAnswerMap ONAM
	INNER JOIN #OldNewQuestionMap ONQM ON ONAM.NewQuestionId = ONQM.NewQuestionId
	INNER JOIN DBO.TR_SurveyAnswers TSA ON ONAM.Answer = TSA.Answer AND ONAM.AnswerText = TSA.AnswerText AND ONAM.NewQuestionId = TSA.QuestionId
	 
	-- DBO.TR_SurveySettings

	INSERT INTO DBO.TR_SurveySettings 
	(SurveyId, SettingId, CustomerId, Value)
	SELECT @NewSurveyId, SettingId, CustomerId, Value FROM DBO.TR_SurveySettings WHERE SurveyId = @SurveyId
	
	-- DBO.TR_QuestionSettings
	 
	INSERT INTO DBO.TR_QuestionSettings
	(QuestionId,SettingId,Value)
	SELECT ONQM.NewQuestionId, TQS.SettingId, TQS.Value 
	FROM DBO.TR_QuestionSettings TQS 
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TQS.QuestionId = TSQ.QuestionId AND TSQ.SurveyId = @SurveyId
	INNER JOIN #OldNewQuestionMap ONQM ON TSQ.QuestionId = ONQM.OldQuestionId
	
	UPDATE TQS
	SET TQS.Value = CONVERT(VARCHAR(12),ONQM.NewQuestionId)
	FROM TR_QuestionSettings TQS
	INNER JOIN dbo.TR_SurveyQuestions TSQ
		ON TQS.QuestionId = TSQ.QuestionId AND TSQ.SurveyId = @NewSurveyId
	INNER JOIN #OldNewQuestionMap ONQM
		ON LTRIM(RTRIM(TQS.Value)) = CONVERT(VARCHAR(12),ONQM.OldQuestionId) AND TQS.SettingId = 32
	
	-- Due to one survey copied multiple times hence in join it may get mutiple times 	
	UPDATE MS_QuestionBranches
	SET OldBranchId = NULL
	WHERE ISNULL(OldBranchId,0) <> 0
	-- End Due to one survey copied multiple times hence in join it may get mutiple times
	
	INSERT INTO DBO.MS_QuestionBranches
	(BranchType, SurveyId, QuestionId, OldBranchId)
	SELECT 
		DISTINCT MQB.BranchType, @NewSurveyId AS SurveyId, ONQM1.NewQuestionId AS QuestionId, MQB.BranchId
	FROM DBO.MS_QuestionBranches MQB
	INNER JOIN #OldNewQuestionMap ONQM1
		ON MQB.SurveyId = ONQM1.OldSurveyId AND MQB.QuestionId = ONQM1.OldQuestionId
		AND MQB.BranchType = 'Quota'
	WHERE MQB.SurveyId = @SurveyId

	INSERT INTO DBO.TR_QuestionQuota 
	(LogicExpression, Conjunction, BranchId, PreviousQuestionId)
	SELECT 
		REPLACE(TQQ.LogicExpression,ONAM.OldAnswerId,ONAM.NewAnswerId), TQQ.Conjunction, MQB.BranchId, 
		ONQM4.NewQuestionId AS PreviousQuestionId
	FROM DBO.TR_QuestionQuota TQQ 
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TQQ.BranchId = MQB.OldBranchId
		AND MQB.BranchType = 'Quota'
	INNER JOIN #OldNewAnswerMap ONAM 
		ON TQQ.LogicExpression LIKE '%'+CONVERT(VARCHAR(12),ONAM.OldAnswerId)+'%'
	LEFT OUTER JOIN #OldNewQuestionMap ONQM4
		ON TQQ.PreviousQuestionId = ONQM4.OldQuestionId		
		
	-- DBO.TR_SurveyQuota

	INSERT INTO DBO.TR_SurveyQuota
	(SurveyId, QuotaId, Limit)
	SELECT @NewSurveyId, QuotaId, Limit FROM DBO.TR_SurveyQuota WHERE SurveyId = @SurveyId
	
	-- DBO.TR_SkipLogic
	
	INSERT INTO DBO.MS_QuestionBranches
	(BranchType, TrueAction, FalseAction, SurveyId, QuestionId, OldBranchId)
	SELECT 
		DISTINCT MQB.BranchType, ONQM.NewQuestionId AS TrueAction, ONQM1.NewQuestionId AS FalseAction, 
		@NewSurveyId AS SurveyId, ONQM1.NewQuestionId AS QuestionId, MQB.BranchId
	FROM DBO.MS_QuestionBranches MQB
	INNER JOIN #OldNewQuestionMap ONQM
		ON MQB.SurveyId = ONQM.OldSurveyId
		AND MQB.TrueAction = ONQM.OldQuestionId
		AND MQB.BranchType = 'Skip'
	LEFT OUTER JOIN #OldNewQuestionMap ONQM1
		ON MQB.SurveyId = ONQM.OldSurveyId
		AND MQB.QuestionId = ONQM1.OldQuestionId
	WHERE MQB.SurveyId = @SurveyId
	
	INSERT INTO DBO.TR_SkipLogic 
	(LogicExpression, Conjunction, BranchId, PreviousQuestionId)
	SELECT 
		REPLACE(REPLACE(TSL.LogicExpression,ISNULL(ONQM2.OldQuestionId,''),ISNULL(ONQM2.NewQuestionId,'')),ISNULL(ONAM.OldAnswerId,''),ISNULL(ONAM.NewAnswerId,'')),
		TSL.Conjunction, MQB.BranchId, ONQM4.NewQuestionId AS PreviousQuestionId 
	FROM DBO.TR_SkipLogic TSL 
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TSL.BranchId = MQB.OldBranchId
		AND MQB.BranchType = 'Skip'
	LEFT OUTER JOIN #OldNewQuestionMap ONQM2
		ON TSL.LogicExpression LIKE '%Question('+CONVERT(VARCHAR(12),ONQM2.OldQuestionId)+')%'
	LEFT OUTER JOIN #OldNewAnswerMap ONAM
		ON TSL.LogicExpression LIKE '%Answer('+CONVERT(VARCHAR(12),ONAM.OldAnswerId)+')%' 	
	LEFT OUTER JOIN #OldNewQuestionMap ONQM4
		ON TSL.PreviousQuestionId = ONQM4.OldQuestionId	
	
	-- DBO.TR_MediaSkipLogic
	
	INSERT INTO DBO.MS_QuestionBranches
	(BranchType, TrueAction, FalseAction, SurveyId, QuestionId, OldBranchId)
	SELECT 
		DISTINCT MQB.BranchType, ONQM2.NewQuestionId AS TrueAction, ONQM1.NewQuestionId AS FalseAction, 
		@NewSurveyId AS SurveyId, ONQM.NewQuestionId AS QuestionId, MQB.BranchId
	FROM DBO.MS_QuestionBranches MQB
	INNER JOIN #OldNewQuestionMap ONQM
		ON MQB.QuestionId = ONQM.OldQuestionId
		AND MQB.BranchType = 'Media'
	LEFT OUTER JOIN #OldNewQuestionMap ONQM1
		ON MQB.FalseAction = CONVERT(VARCHAR(12),ONQM1.OldQuestionId)
	LEFT OUTER JOIN #OldNewQuestionMap ONQM2
		ON MQB.TrueAction = CONVERT(VARCHAR(12),ONQM2.OldQuestionId)
	WHERE MQB.SurveyId = @SurveyId
			
	INSERT INTO DBO.TR_MediaSkipLogic
	(LogicExpression, Conjunction, BranchId, PreviousQuestionId)
	SELECT 
		REPLACE(REPLACE(TMSL.LogicExpression,ISNULL(ONQM3.OldQuestionId,''),ISNULL(ONQM3.NewQuestionId,'')),ISNULL(ONAM.OldAnswerId,''),ISNULL(ONAM.NewAnswerId,'')) AS LogicExpression,
		TMSL.Conjunction, MQB.NewBranchId, ONQM4.NewQuestionId AS PreviousQuestionId 
	FROM DBO.TR_MediaSkipLogic TMSL
	INNER JOIN 
	(
		SELECT 
			MQB.*, MQB1.BranchId AS NewBranchId
		FROM DBO.MS_QuestionBranches MQB
		INNER JOIN DBO.MS_QuestionBranches MQB1 
		ON MQB.BranchId = MQB1.OldBranchId
	) MQB	
		ON TMSL.BranchId = MQB.BranchId
		AND MQB.BranchType = 'Media'

	INNER JOIN #OldNewQuestionMap ONQM
		ON MQB.QuestionId = ONQM.OldQuestionId
	LEFT OUTER JOIN #OldNewQuestionMap ONQM3
		ON TMSL.LogicExpression LIKE '%Question('+CONVERT(VARCHAR(12),ONQM3.OldQuestionId)+')%'
	LEFT OUTER JOIN #OldNewAnswerMap ONAM
		ON TMSL.LogicExpression LIKE '%Answer('+CONVERT(VARCHAR(12),ONAM.OldAnswerId)+')%' 
	LEFT OUTER JOIN #OldNewQuestionMap ONQM4
		ON TMSL.PreviousQuestionId = ONQM4.OldQuestionId
			
	-- 	TR_EmailTrigger
	INSERT INTO DBO.MS_QuestionBranches
	(BranchType, SurveyId, TrueAction, QuestionId, SendAtEnd, MessageLibId, EmailDetailId, OldBranchId)
	SELECT 
		DISTINCT MQB.BranchType, @NewSurveyId AS SurveyId, MQB.TrueAction, ONQM1.NewQuestionId AS QuestionId, 
		MQB.SendAtEnd, MQB.MessageLibId, MQB.EmailDetailId, MQB.BranchId
	FROM DBO.MS_QuestionBranches MQB
	INNER JOIN #OldNewQuestionMap ONQM1
		ON MQB.SurveyId = ONQM1.OldSurveyId
		AND MQB.QuestionId = ONQM1.OldQuestionId
		AND MQB.BranchType = 'Email'
	WHERE MQB.SurveyId = @SurveyId

	INSERT INTO DBO.TR_EmailTrigger 
	(TriggerExpression, Conjunction, BranchId, PreviousQuestionId)
	SELECT 
		REPLACE(REPLACE(TR.TriggerExpression,ISNULL(ONQM3.OldQuestionId,''),ISNULL(ONQM3.NewQuestionId,'')),ISNULL(ONAM.OldAnswerId,''),ISNULL(ONAM.NewAnswerId,'')) AS TriggerExpression,
		TR.Conjunction, MQB.BranchId, ONQM4.NewQuestionId AS PreviousQuestionId 
	FROM DBO.TR_EmailTrigger TR
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TR.BranchId = MQB.OldBranchId
		AND MQB.BranchType = 'Email'
	LEFT OUTER JOIN #OldNewQuestionMap ONQM
		ON MQB.QuestionId = ONQM.OldQuestionId
	LEFT OUTER JOIN #OldNewQuestionMap ONQM3
		ON TR.TriggerExpression LIKE '%Question('+CONVERT(VARCHAR(12),ONQM3.OldQuestionId)+')%'
	LEFT OUTER JOIN #OldNewAnswerMap ONAM
		ON TR.TriggerExpression LIKE '%Answer('+CONVERT(VARCHAR(12),ONAM.OldAnswerId)+')%' 	
	LEFT OUTER JOIN #OldNewQuestionMap ONQM4
		ON TR.PreviousQuestionId = ONQM4.OldQuestionId

	---TR_QuestionFollowUpMap   
	INSERT INTO TR_QuestionFollowUpMap
	(QuestionId, FollowUpQuestionId)
	SELECT ONQM.NewQuestionId, ONQM1.NewQuestionId
	FROM TR_QuestionFollowUpMap TQFM
	INNER JOIN #OldNewQuestionMap ONQM
		ON TQFM.QuestionId = ONQM.OldQuestionId 
	LEFT OUTER JOIN #OldNewQuestionMap ONQM1
		ON TQFM.FollowUpQuestionId = ONQM1.OldQuestionId 
	---------------------------------------------------------------------------------------
	
	SELECT CASE WHEN @NewSurveyId = 0 THEN 0 ELSE 1 END AS RetValue, 
		  CASE WHEN @NewSurveyId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
		  @NewSurveyId AS SurveyId

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END



