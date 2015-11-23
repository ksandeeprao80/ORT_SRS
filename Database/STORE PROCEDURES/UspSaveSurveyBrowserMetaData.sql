IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSurveyBrowserMetaData]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveSurveyBrowserMetaData]
GO

CREATE PROCEDURE DBO.UspSaveSurveyBrowserMetaData
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
		 
	DECLARE @MetaInfo TABLE
	(
		SurveyId VARCHAR(20), RespondentId VARCHAR(20), RespondentSessionId VARCHAR(100), IpAddress VARCHAR(100),
		Browser VARCHAR(100), BrowserVersion VARCHAR(20), OperatingSystem VARCHAR(100), ScreenResolution VARCHAR(100),
		FlashVersion VARCHAR(100), JavaSupport VARCHAR(20), SupportCookies VARCHAR(100), UserAgent VARCHAR(MAX)
	 )

	 
	INSERT INTO @MetaInfo
	(
		SurveyId, RespondentId, RespondentSessionId, IpAddress, Browser, BrowserVersion, OperatingSystem,
		ScreenResolution, FlashVersion, JavaSupport, SupportCookies, UserAgent
	)
	SELECT 
		Parent.Elm.value('(SurveyId)[1]','VARCHAR(20)') AS SurveyId,
		Parent.Elm.value('(RespondentId)[1]','VARCHAR(20)') AS RespondentId,
		Parent.Elm.value('(RespondentSessionId)[1]','VARCHAR(100)') AS RespondentSessionId,
		Child.Elm.value('(IpAddress)[1]','VARCHAR(100)') AS IpAddress,
		Child.Elm.value('(Browser)[1]','VARCHAR(100)') AS Browser,
		Child.Elm.value('(BrowserVersion)[1]','VARCHAR(20)') AS BrowserVersion,
		Child.Elm.value('(OperatingSystem)[1]','VARCHAR(100)') AS OperatingSystem,
		Child.Elm.value('(ScreenResolution)[1]','VARCHAR(100)') AS ScreenResolution,
		Child.Elm.value('(FlashVersion)[1]','VARCHAR(100)') AS FlashVersion,
		Child.Elm.value('(JavaSupport)[1]','VARCHAR(20)') AS JavaSupport,
		Child.Elm.value('(SupportCookies)[1]','VARCHAR(100)') AS SupportCookies,
		Child.Elm.value('(UserAgent)[1]','VARCHAR(MAX)') AS UserAgent
	FROM @input.nodes('/SurveyDetailsFromRequest') AS Parent(Elm)
	CROSS APPLY 
		Parent.Elm.nodes('MetaInfo') AS Child(Elm)


    DECLARE @SurveyId VARCHAR(20)
    DECLARE @RespondentId VARCHAR(20)
    DECLARE @RespondentSessionId VARCHAR(20)
    
    SELECT 
		@SurveyId = SurveyId, @RespondentId = RespondentId, @RespondentSessionId = RespondentSessionId  
	FROM @MetaInfo
	
	IF NOT EXISTS 
	(
		SELECT 1 FROM DBO.TR_SurveyBrowserMetaData WHERE SurveyId = @SurveyId 
		AND RespondentId = @RespondentId AND RespondentSessionId = @RespondentSessionId
	)
	BEGIN
		INSERT INTO DBO.TR_SurveyBrowserMetaData
		(
			SurveyId, RespondentId, RespondentSessionId, IpAddress, Browser, BrowserVersion, OperatingSystem,
			ScreenResolution, FlashVersion, JavaSupport, SupportCookies, UserAgent
		)
		SELECT 
			SurveyId, RespondentId, RespondentSessionId,IpAddress, Browser, BrowserVersion, OperatingSystem,
			ScreenResolution, FlashVersion, JavaSupport, SupportCookies, UserAgent 
		FROM @MetaInfo
		
		SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark, @SurveyId AS SurveyId
	END
	ELSE
	BEGIN
	    UPDATE TR 
	    SET TR.IpAddress = M.IpAddress,
			TR.Browser = M.Browser,
			TR.BrowserVersion = M.BrowserVersion,
			TR.OperatingSystem = M.OperatingSystem,
			TR.ScreenResolution = M.ScreenResolution,
			TR.FlashVersion = M.FlashVersion,
			TR.JavaSupport = M.JavaSupport,
			TR.SupportCookies = M.SupportCookies,
			TR.UserAgent = M.UserAgent
	    FROM DBO.TR_SurveyBrowserMetaData TR
	    INNER JOIN @MetaInfo M 
			ON TR.SurveyId = M.SurveyId 
			AND TR.RespondentId = M.RespondentId
			AND TR.RespondentSessionId = M.RespondentSessionId
	    
	    SELECT 1 AS RetValue, 'Successfully Updated' AS Remark, @SurveyId AS SurveyId
	END

	COMMIT TRAN
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END