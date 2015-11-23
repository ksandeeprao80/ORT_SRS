SELECT * FROM TR_SurveyQuestions WHERE SurveyId = 1114

SELECT * FROM TR_SurveyAnswers WHERE QuestionId = 9456

INSERT INTO TR_MediaSkipLogic
VALUES ('Question(9456).Answer == Answer(106267)','9457','9456',9456)


INSERT INTO TR_SoundClipInfo
SELECT TF.FileLibId,'Seattle Track','MJ','2012', '' 
FROM TR_FileLibrary TF
JOIN TR_PlayList TP ON TP.FileLibId = TF.FileLibId AND TP.PlayListId = 4
