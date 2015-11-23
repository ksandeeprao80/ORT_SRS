BEGIN 
	DECLARE @SettingId INT
	DECLARE @SettingId1 INT
	DECLARE @SettingId2 INT
	DECLARE @SettingId3 INT

	SET @SettingId = 0
	SET @SettingId1 = 0
	SET @SettingId2 = 0
	SET @SettingId3 = 0

	INSERT INTO MS_SurveySettings
	(SettingType,SettingName,DisplayText)
	VALUES('','OutPanelSurveyCompleteLink','OutPanelSurveyCompleteLink')

	SET @SettingId = @@IDENTITY
	
	INSERT INTO MS_SurveySettings
	(SettingType,SettingName,DisplayText)
	VALUES('','OutPanelQuotaFullLink','OutPanelQuotaFullLink')  

	SET @SettingId1 = @@IDENTITY

	INSERT INTO MS_SurveySettings
	(SettingType,SettingName,DisplayText) 
	VALUES('','OutPanelDisqualifyLink','OutPanelDisqualifyLink')

	SET @SettingId2 = @@IDENTITY
	
	INSERT INTO MS_SurveySettings
	(SettingType,SettingName,DisplayText) 
	VALUES('','PanelType','PanelType')

	SET @SettingId3 = @@IDENTITY
	
	INSERT INTO TR_SurveySettings
	(SurveyId,SettingId,CustomerId,Value)
	SELECT DISTINCT SurveyId,@SettingId,CustomerId,'' FROM TR_SurveySettings UNION
	SELECT DISTINCT SurveyId,@SettingId1,CustomerId,'' FROM TR_SurveySettings UNION
	SELECT DISTINCT SurveyId,@SettingId2,CustomerId,'' FROM TR_SurveySettings 
	
	INSERT INTO TR_SurveySettings
	(SurveyId,SettingId,CustomerId,Value)
	SELECT 
		DISTINCT TSS.SurveyId, @SettingId3, TSS.CustomerId,  
		CASE WHEN ISNULL(TSS.Value,'') = '' THEN 'outside ' ELSE 'internal' END 
	FROM MS_SurveySettings MSS
	INNER JOIN TR_SurveySettings TSS
		ON MSS.SettingId = TSS.SettingId
	WHERE MSS.SettingName = 'PanelId'

END

