IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'SaveSurvey' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 53,'Survey','SaveSurvey','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,53,'SaveSurvey' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END 


IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'PublishSurvey' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 54,'Survey','PublishSurvey','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,54,'PublishSurvey' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END


IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'SaveQuestion' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 55,'Survey','SaveQuestion','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,55,'SaveQuestion' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'DeleteQuestion' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 56,'Survey','DeleteQuestion','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,56,'DeleteQuestion' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'GetSurvey' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 57,'Survey','GetSurvey','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,57,'GetSurvey' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'GetQuestions' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 58,'Survey','GetQuestions','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,58,'GetQuestions' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END


IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'DeleteSurvey' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 59,'Survey','DeleteSurvey','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,59,'DeleteSurvey' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END


IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'SearchEntity' AND AccessName = 'Music')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 60,'Music','SearchEntity','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,60,'SearchEntity' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

----------------------- New Start after AWS 18/12/2012--- 
IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'SearchEntity' AND AccessName = 'Entity')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 61,'Entity','SearchEntity','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,61,'SearchEntity' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'ReOrderQuestion' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 62,'Survey','ReOrderQuestion','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,62,'ReOrderQuestion' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'GetSurveyTemplates' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 63,'Survey','GetSurveyTemplates','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,63,'GetSurveyTemplates' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'Landing' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 64,'Reports','Landing','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,64,'Landing' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

----------------------- New Start From AWS 24/12/2012--- 

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'CreateReport' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 65,'Reports','CreateReport','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,65,'CreateReport' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END


IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'ViewReport' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 66,'Reports','ViewReport','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,66,'ViewReport' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'ResponseReport' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 67,'Reports','ResponseReport','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,67,'ResponseReport' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'TrendReport' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 68,'Reports','TrendReport','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,68,'TrendReport' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'SetQuestionStatus' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 69,'Reports','SetQuestionStatus','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,69,'SetQuestionStatus' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END


IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'SaveReportName' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 70,'Reports','SaveReportName','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,70,'SaveReportName' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'ChangeChart' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 71,'Reports','ChangeChart','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,71,'ChangeChart' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'ViewReports' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 72,'Reports','ViewReports','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,72,'ViewReports' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'DeleteReport' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 73,'Reports','DeleteReport','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,73,'DeleteReport' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'EditReport' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 74,'Reports','EditReport','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,74,'EditReport' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

---------------- Start From 02/01/2013
IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'PreviewSurvey' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 75,'Survey','PreviewSurvey','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,75,'PreviewSurvey' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'RestoreQuestion' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 76,'Survey','RestoreQuestion','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,76,'RestoreQuestion' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END
 
IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'GetResponseDump' AND AccessName = 'Report')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 77,'Report','GetResponseDump','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,77,'GetResponseDump' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END


IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'SendSurvey' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 78,'Survey','SendSurvey','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,78,'SendSurvey' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'GetPlayListSongs' AND AccessName = 'MusicCloset')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 79,'MusicCloset','GetPlayListSongs','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,79,'GetPlayListSongs' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'PostToFaceBook' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 80,'Survey','PostToFaceBook','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,80,'PostToFaceBook' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END
 
 --21/01/2013
 
IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'ExportQuestions' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 81,'Survey','ExportQuestions','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,81,'ExportQuestions' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END


IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'DeleteSongsFromLib' AND AccessName = 'MusicCloset')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 82,'MusicCloset','DeleteSongsFromLib','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,82,'DeleteSongsFromLib' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'GetDistributeHistory' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 83,'Survey','GetDistributeHistory','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,83,'GetDistributeHistory' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'DeleteSongsFromPlayList' AND AccessName = 'MusicCloset')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 84,'MusicCloset','DeleteSongsFromPlayList','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,84,'DeleteSongsFromPlayList' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END
 
--2013/01/25------------------------------------------  


IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'SaveQuestionInLibrary' AND AccessName = 'Library')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 85,'Library','SaveQuestionInLibrary','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,85,'SaveQuestionInLibrary' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'DeleteQuestionFromLibrary' AND AccessName = 'Library')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 86,'Library','DeleteQuestionFromLibrary','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,86,'DeleteQuestionFromLibrary' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END


IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'AddQuestionToLibrary' AND AccessName = 'Library')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 87,'Library','AddQuestionToLibrary','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,87,'AddQuestionToLibrary' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

--2013/01/31------------------------------------------  

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'SaveRewards' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 88,'Survey','SaveRewards','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,88,'SaveRewards' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

-------2013/02/06---------------------
IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'SaveFilters' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 89,'Reports','SaveFilters','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,89,'SaveFilters' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

-------2013/02/25 Deployed on Local/Prod/AWS---------------------
IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'ChangePassword' AND AccessName = 'User')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 90,'User','ChangePassword','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,90,'ChangePassword' FROM MS_Roles 
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END

-------2013/02/27 ---------------------
IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'ChangeStatus' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 91,'Survey','ChangeStatus','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,91,'ChangeStatus' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END
  
 ------2013/03/20 -------------------------------
IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'RePublishSurvey' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT MS_UserAccess ON
	INSERT INTO MS_UserAccess
	(AccessId,AccessName,AccessModule,AccessLink,IsActive)
	SELECT 92,'Survey','RePublishSurvey','',1

	INSERT INTO MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)
	SELECT RoleId,RoleType,92,'RePublishSurvey' FROM MS_RoleAccess where AccessModule = 'PublishSurvey'

	SET IDENTITY_INSERT MS_UserAccess OFF 
END	


IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'CanDeleteQuestion' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT MS_UserAccess ON
	INSERT INTO MS_UserAccess
	(AccessId,AccessName,AccessModule,AccessLink,IsActive)
	SELECT 93,'Survey','CanDeleteQuestion','',1

	INSERT INTO MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)
	SELECT RoleId,RoleType,93,'CanDeleteQuestion' FROM MS_RoleAccess where AccessModule = 'DeleteQuestion'

	SET IDENTITY_INSERT MS_UserAccess OFF 
END	
---- 20130404---------------------------

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'DrawWinners' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT MS_UserAccess ON
	INSERT INTO MS_UserAccess
	(AccessId,AccessName,AccessModule,AccessLink,IsActive)
	SELECT 94,'Survey','GetWinners','',1
	
	INSERT INTO MS_UserAccess
	(AccessId,AccessName,AccessModule,AccessLink,IsActive)
	SELECT 95,'Survey','DrawWinners','',1

	INSERT INTO MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)
	SELECT 1,'GU',94,'GetWinners' UNION
	SELECT 2,'SA',94,'GetWinners' UNION
	SELECT 1,'GU',95,'DrawWinners' UNION
	SELECT 2,'SA',95,'DrawWinners'

	SET IDENTITY_INSERT MS_UserAccess OFF 
END	


IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'GetAnonymousWinners' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT MS_UserAccess ON
	INSERT INTO MS_UserAccess
	(AccessId,AccessName,AccessModule,AccessLink,IsActive)
	SELECT 96,'Survey','GetAnonymousWinners','',1
	
	INSERT INTO MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)
	SELECT 1,'GU',96,'GetAnonymousWinners' UNION
	SELECT 2,'SA',96,'GetAnonymousWinners' 

	SET IDENTITY_INSERT MS_UserAccess OFF 
END	

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'ShowAnonymousResponses' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT MS_UserAccess ON
	INSERT INTO MS_UserAccess
	(AccessId,AccessName,AccessModule,AccessLink,IsActive)
	SELECT 97,'Reports','ShowAnonymousResponses','',1
	
	INSERT INTO MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)
	SELECT 1,'GU',97,'ShowAnonymousResponses' UNION
	SELECT 2,'SA',97,'ShowAnonymousResponses' 

	SET IDENTITY_INSERT MS_UserAccess OFF 
END	

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'GetResponseHtml' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT MS_UserAccess ON
	INSERT INTO MS_UserAccess
	(AccessId,AccessName,AccessModule,AccessLink,IsActive)
	SELECT 98,'Reports','GetResponseHtml','',1
	
	INSERT INTO MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)
	SELECT 1,'GU',98,'GetResponseHtml' UNION
	SELECT 2,'SA',98,'GetResponseHtml' 

	SET IDENTITY_INSERT MS_UserAccess OFF 
END	

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'ExportResponses' AND AccessName = 'Reports')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 99,'Reports','ExportResponses','',1

	INSERT INTO MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)
	SELECT 1,'GU',99,'GetResponseHtml' UNION
	SELECT 2,'SA',99,'GetResponseHtml'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END