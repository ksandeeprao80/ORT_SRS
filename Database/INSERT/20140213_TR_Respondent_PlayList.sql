SELECT * INTO TR_Respondent_PlayList_Backup_20140213 FROM TR_Respondent_PlayList

GO

UPDATE TPL
SET TPL.QuestionId = TSQ.QuestionId
FROM DBO.MS_QuestionSettings MQS
	INNER JOIN DBO.PB_TR_QuestionSettings TQS 
		ON TQS.SettingId = MQS.SettingId 
		AND MQS.SettingName = 'PlayListId'
	INNER JOIN DBO.PB_TR_SurveyQuestions TSQ 
		ON TSQ.QuestionId = TQS.QuestionId 
		AND TQS.Value NOT IN ('0','')
		AND TSQ.IsDeleted = 1
INNER JOIN DBO.TR_Respondent_PlayList TPL
   ON TSQ.SurveyId = TPL.SurveyId
INNER JOIN dbo.TR_FileLibrary TFL 
	ON TPL.FileLibId = TFL.FileLibId
INNER JOIN dbo.TR_Library TL 
	ON TFL.LIBID = TL.LibId
LEFT OUTER JOIN dbo.TR_LibraryCategory TLC 
	ON TLC.LibId = TL.LibId
	AND TLC.CategoryId = TFL.Category
 WHERE TPL.QuestionId IS NULL
 
	