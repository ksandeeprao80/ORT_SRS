

CREATE NONCLUSTERED INDEX IX_TR_FileLibrary_LibId ON DBO.TR_FileLibrary(LibId)
GO
CREATE NONCLUSTERED INDEX IX_TR_GraphicFiles_LibId ON DBO.TR_GraphicFiles(LibId)
CREATE NONCLUSTERED INDEX IX_TR_GraphicFiles_CategoryId ON DBO.TR_GraphicFiles(CategoryId)
CREATE NONCLUSTERED INDEX IX_TR_GraphicFiles_CustomerId ON DBO.TR_GraphicFiles(CustomerId)
GO
CREATE NONCLUSTERED INDEX IX_TR_GraphicInfo_GraphicLibId ON DBO.TR_GraphicInfo(GraphicLibId)
GO
CREATE NONCLUSTERED INDEX IX_TR_GraphicLibrary_LibId ON DBO.TR_GraphicLibrary(LibId)
GO
CREATE NONCLUSTERED INDEX IX_TR_LibraryCategory_LibId ON DBO.TR_LibraryCategory(LibId)
GO
CREATE NONCLUSTERED INDEX IX_TR_MediaInfo_QuestionId ON DBO.TR_MediaInfo(QuestionId)
CREATE NONCLUSTERED INDEX IX_TR_MediaInfo_FileLibId ON DBO.TR_MediaInfo(FileLibId)
GO
CREATE NONCLUSTERED INDEX IX_TR_MediaSkipLogic_QuestionId ON DBO.TR_MediaSkipLogic(QuestionId)
GO
CREATE NONCLUSTERED INDEX IX_TR_MessageLibrary_LibId ON DBO.TR_MessageLibrary(LibId)
GO
CREATE NONCLUSTERED INDEX IX_TR_PanelCategory_LibId ON DBO.TR_PanelCategory(LibId)
GO
CREATE NONCLUSTERED INDEX IX_TR_PlayList_FileLibId ON DBO.TR_PlayList(FileLibId)
GO
CREATE NONCLUSTERED INDEX IX_TR_QuestionLibrary_LibId ON DBO.TR_QuestionLibrary(LibId)
CREATE NONCLUSTERED INDEX IX_TR_QuestionLibrary_QuestionId ON DBO.TR_QuestionLibrary(QuestionId)
GO
CREATE NONCLUSTERED INDEX IX_TR_QuestionSettings_QuestionId ON DBO.TR_QuestionSettings(QuestionId)
GO
CREATE NONCLUSTERED INDEX IX_TR_Respondent_PlayList_SurveyId ON DBO.TR_Respondent_PlayList(SurveyId)
GO
CREATE NONCLUSTERED INDEX IX_TR_Responses_QuestionId ON DBO.TR_Responses(QuestionId)
CREATE NONCLUSTERED INDEX IX_TR_Responses_AnswerId ON DBO.TR_Responses(AnswerId)
GO
CREATE NONCLUSTERED INDEX IX_TR_SkipLogic_SurveyId ON DBO.TR_SkipLogic(SurveyId)
GO
CREATE NONCLUSTERED INDEX IX_TR_SoundClipInfo_FileLibId ON DBO.TR_SoundClipInfo(FileLibId)
GO
CREATE NONCLUSTERED INDEX IX_TR_SoundClipInfoException_FileLibId ON DBO.TR_SoundClipInfoException(FileLibId)
CREATE NONCLUSTERED INDEX IX_TR_SoundClipInfoException_SessionId ON DBO.TR_SoundClipInfoException(SessionId)
GO
CREATE NONCLUSTERED INDEX IX_TR_Survey_CustomerId ON DBO.TR_Survey(CustomerId)
GO
CREATE NONCLUSTERED INDEX IX_TR_SurveyAnswers_QuestionId ON DBO.TR_SurveyAnswers(QuestionId)
GO
CREATE NONCLUSTERED INDEX IX_TR_SurveyLibrary_LibId ON DBO.TR_SurveyLibrary(LibId)
CREATE NONCLUSTERED INDEX IX_TR_SurveyLibrary_SurveyId ON DBO.TR_SurveyLibrary(SurveyId)
GO
CREATE NONCLUSTERED INDEX IX_TR_SurveyQuestions_SurveyId ON DBO.TR_SurveyQuestions(SurveyId)
CREATE NONCLUSTERED INDEX IX_TR_SurveyQuestions_CustomerId ON DBO.TR_SurveyQuestions(CustomerId)
GO
CREATE NONCLUSTERED INDEX IX_TR_SurveyQuota_SurveyId ON DBO.TR_SurveyQuota(SurveyId)
GO
CREATE NONCLUSTERED INDEX IX_TR_SurveySettings_SurveyId ON DBO.TR_SurveySettings(SurveyId)
CREATE NONCLUSTERED INDEX IX_TR_SurveySettings_CustomerId ON DBO.TR_SurveySettings(CustomerId)
GO
CREATE NONCLUSTERED INDEX IX_TR_Translations_SurveyId ON DBO.TR_Translations(SurveyId)
GO
CREATE NONCLUSTERED INDEX IX_TR_UploadSession_CustomerId ON DBO.TR_UploadSession(CustomerId)
GO
CREATE NONCLUSTERED INDEX IX_MS_RoleAccess_RoleId ON DBO.MS_RoleAccess(RoleId)
CREATE NONCLUSTERED INDEX IX_MS_RoleAccess_AccessId ON DBO.MS_RoleAccess(AccessId)
GO
CREATE NONCLUSTERED INDEX IX_MS_Users_CustomerId ON DBO.MS_Users(CustomerId)
GO
CREATE NONCLUSTERED INDEX IX_MS_PanelMembers_CustomerId ON DBO.MS_PanelMembers(CustomerId)
