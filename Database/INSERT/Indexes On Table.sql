CREATE NONCLUSTERED INDEX IX_MS_City_StateId ON MS_City(StateId)
CREATE NONCLUSTERED INDEX IX_MS_State_CountryId ON MS_State(CountryId)
--
CREATE NONCLUSTERED INDEX IX_TR_QuestionSettings_SettingId ON TR_QuestionSettings(SettingId)
CREATE NONCLUSTERED INDEX IX_PB_TR_QuestionSettings_SettingId ON PB_TR_QuestionSettings(SettingId)
CREATE NONCLUSTERED INDEX IX_PB_TR_QuestionSettings_QuestionId ON PB_TR_QuestionSettings(QuestionId)
--
CREATE NONCLUSTERED INDEX IX_TR_EmailTrigger_BranchId ON TR_EmailTrigger(BranchId)
CREATE NONCLUSTERED INDEX IX_PB_TR_EmailTrigger_BranchId ON PB_TR_EmailTrigger(BranchId)
--
CREATE NONCLUSTERED INDEX IX_TR_MediaSkipLogic_BranchId ON TR_MediaSkipLogic(BranchId)
CREATE NONCLUSTERED INDEX IX_PB_TR_MediaSkipLogic_BranchId ON PB_TR_MediaSkipLogic(BranchId)
--
CREATE NONCLUSTERED INDEX IX_TR_SkipLogic_BranchId ON TR_SkipLogic(BranchId)
CREATE NONCLUSTERED INDEX IX_PB_TR_SkipLogic_BranchId ON PB_TR_SkipLogic(BranchId)
--
CREATE NONCLUSTERED INDEX IX_PB_TR_SurveySettings_SettingId ON PB_TR_SurveySettings(SettingId)
CREATE NONCLUSTERED INDEX IX_PB_TR_SurveySettings_CustomerId ON PB_TR_SurveySettings(CustomerId)
--
CREATE NONCLUSTERED INDEX IX_TR_EmailDetails_QuestionId ON TR_EmailDetails(QuestionId)
--
CREATE NONCLUSTERED INDEX IX_TR_EmailTrigger_BranchId ON TR_EmailTrigger(BranchId)
-- 
CREATE NONCLUSTERED INDEX IX_TR_GraphicCategory_GraphicLibId ON TR_GraphicCategory(GraphicLibId)
--
CREATE NONCLUSTERED INDEX IX_TR_Invite_InviteId ON TR_Invite(InviteId) 
--
CREATE NONCLUSTERED INDEX IX_TR_InviteChannelDetail_InviteId ON TR_InviteChannelDetail(InviteId) 
--
CREATE NONCLUSTERED INDEX IX_TR_InviteDetails_RowId ON TR_InviteDetails(RowId) 
--
CREATE NONCLUSTERED INDEX IX_TR_Library_CustomerId ON TR_Library(CustomerId) 
--
CREATE NONCLUSTERED INDEX IX_TR_MediaInfo_CustomerId ON TR_MediaInfo(CustomerId) 
--
CREATE NONCLUSTERED INDEX IX_TR_PlayList_PlayListId ON TR_PlayList(PlayListId) 
--
CREATE NONCLUSTERED INDEX IX_TR_QuestionLibraryAnswers_QuestionLibId ON TR_QuestionLibraryAnswers(QuestionLibId) 
--
CREATE NONCLUSTERED INDEX IX_TR_QuestionLibrarySetting_QuestionLibId ON TR_QuestionLibrarySetting(QuestionLibId) 
--
CREATE NONCLUSTERED INDEX IX_TR_QuestionQuota_BranchId ON TR_QuestionQuota(BranchId) 
CREATE NONCLUSTERED INDEX IX_PB_TR_QuestionQuota_BranchId ON PB_TR_QuestionQuota(BranchId) 
--
CREATE NONCLUSTERED INDEX IX_TR_Report_CustomerId ON TR_Report(CustomerId) 
--
CREATE NONCLUSTERED INDEX IX_TR_ReportDataSource_ReportId ON TR_ReportDataSource(ReportId) 
CREATE NONCLUSTERED INDEX IX_TR_ReportDataSource_SurveyId ON TR_ReportDataSource(SurveyId) 
--
CREATE NONCLUSTERED INDEX IX_TR_ReportFilter_QuestionId ON TR_ReportFilter(QuestionId) 
--
CREATE NONCLUSTERED INDEX IX_TR_ReportFilterMapping_ReportId ON TR_ReportFilterMapping(ReportId) 
CREATE NONCLUSTERED INDEX IX_TR_ReportFilterMapping_FilterId ON TR_ReportFilterMapping(FilterId) 
--
CREATE NONCLUSTERED INDEX IX_TR_ReportQuestions_ReportId ON TR_ReportQuestions(ReportId) 
CREATE NONCLUSTERED INDEX IX_TR_ReportQuestions_QuestionId ON TR_ReportQuestions(QuestionId) 
--
CREATE NONCLUSTERED INDEX IX_TR_Reward_SurveyId ON TR_Reward(SurveyId)  
--
CREATE NONCLUSTERED INDEX IX_TR_SurveyRequestDetails_SurveyId ON TR_SurveyRequestDetails(SurveyId)  
--
CREATE NONCLUSTERED INDEX IX_TR_SurveySettings_SettingId ON TR_SurveySettings(SettingId)  
--
CREATE NONCLUSTERED INDEX IX_TR_TrendCrossTabs_ReportId ON TR_TrendCrossTabs(ReportId)   
--
CREATE NONCLUSTERED INDEX IX_TR_TrendOptionMapping_TrendId ON TR_TrendOptionMapping(TrendId)   
--
CREATE NONCLUSTERED INDEX IX_TR_TrendReportColumns_ReportId ON TR_TrendReportColumns(ReportId)   
--
CREATE NONCLUSTERED INDEX IX_TR_TrendReportColumnSettings_ReportId ON TR_TrendReportColumnSettings(ReportId)   
--
CREATE NONCLUSTERED INDEX IX_TR_Trends_ReportId ON TR_Trends(ReportId)   
CREATE NONCLUSTERED INDEX IX_TR_Trends_SurveyId ON TR_Trends(SurveyId)   
--
CREATE NONCLUSTERED INDEX IX_TR_Winner_SurveyId ON TR_Winner(SurveyId)   
