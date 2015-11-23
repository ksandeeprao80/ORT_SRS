IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveWebRequestData]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveWebRequestData

GO  
/*
EXEC UspSaveWebRequestData '<?xml version="1.0" encoding="utf-16"?>
<WebRequestInfo>
  <Controller>Engine</Controller>
  <Action>RenderSurvey</Action>
  <InputStream>ABCD</InputStream>
  <WebFormParams>Data=Rl%2bwWeqdfvANNVbAuIZSyvNz9NoPKNnz1HLWH6KmPi024S1TVhl%2bWA%3d%3d&amp;SessionId=UserSessionId%3d5c53423ywj1rjnu25gbbmx45%26SurveyId%3d1098&amp;SessionId1102=UserSessionId%3dfupijdum2rgg4z55jjrqukz2%26SurveyId%3d1102&amp;SessionId1098=UserSessionId%3d0zrthmyztw4nfj55jaybbrno%26SurveyId%3d1098&amp;SessionId1100=UserSessionId%3d3d3rewfca2mo2z21ifavub45%26SurveyId%3d1100&amp;ASP.NET_SessionId=4riazs55rjawbi45akzb5k55&amp;ALL_HTTP=HTTP_CACHE_CONTROL%3amax-age%3d0%0d%0aHTTP_CONNECTION%3akeep-alive%0d%0aHTTP_ACCEPT%3atext%2fhtml%2capplication%2fxhtml%2bxml%2capplication%2fxml%3bq%3d0.9%2c*%2f*%3bq%3d0.8%0d%0aHTTP_ACCEPT_CHARSET%3aISO-8859-1%2cutf-8%3bq%3d0.7%2c*%3bq%3d0.3%0d%0aHTTP_ACCEPT_ENCODING%3agzip%2cdeflate%2csdch%0d%0aHTTP_ACCEPT_LANGUAGE%3aen-GB%2cen-US%3bq%3d0.8%2cen%3bq%3d0.6%0d%0aHTTP_COOKIE%3aSessionId%3dUserSessionId%3d5c53423ywj1rjnu25gbbmx45%26SurveyId%3d1098%3b+SessionId1102%3dUserSessionId%3dfupijdum2rgg4z55jjrqukz2%26SurveyId%3d1102%3b+SessionId1098%3dUserSessionId%3d0zrthmyztw4nfj55jaybbrno%26SurveyId%3d1098%3b+SessionId1100%3dUserSessionId%3d3d3rewfca2mo2z21ifavub45%26SurveyId%3d1100%3b+ASP.NET_SessionId%3d4riazs55rjawbi45akzb5k55%0d%0aHTTP_HOST%3alocalhost%3a5000%0d%0aHTTP_USER_AGENT%3aMozilla%2f5.0+(Windows+NT+6.1)+AppleWebKit%2f537.4+(KHTML%2c+like+Gecko)+Chrome%2f22.0.1229.94+Safari%2f537.4%0d%0a&amp;ALL_RAW=Cache-Control%3a+max-age%3d0%0d%0aConnection%3a+keep-alive%0d%0aAccept%3a+text%2fhtml%2capplication%2fxhtml%2bxml%2capplication%2fxml%3bq%3d0.9%2c*%2f*%3bq%3d0.8%0d%0aAccept-Charset%3a+ISO-8859-1%2cutf-8%3bq%3d0.7%2c*%3bq%3d0.3%0d%0aAccept-Encoding%3a+gzip%2cdeflate%2csdch%0d%0aAccept-Language%3a+en-GB%2cen-US%3bq%3d0.8%2cen%3bq%3d0.6%0d%0aCookie%3a+SessionId%3dUserSessionId%3d5c53423ywj1rjnu25gbbmx45%26SurveyId%3d1098%3b+SessionId1102%3dUserSessionId%3dfupijdum2rgg4z55jjrqukz2%26SurveyId%3d1102%3b+SessionId1098%3dUserSessionId%3d0zrthmyztw4nfj55jaybbrno%26SurveyId%3d1098%3b+SessionId1100%3dUserSessionId%3d3d3rewfca2mo2z21ifavub45%26SurveyId%3d1100%3b+ASP.NET_SessionId%3d4riazs55rjawbi45akzb5k55%0d%0aHost%3a+localhost%3a5000%0d%0aUser-Agent%3a+Mozilla%2f5.0+(Windows+NT+6.1)+AppleWebKit%2f537.4+(KHTML%2c+like+Gecko)+Chrome%2f22.0.1229.94+Safari%2f537.4%0d%0a&amp;APPL_MD_PATH=&amp;APPL_PHYSICAL_PATH=D%3a%5cSandeepRao%5cDevelopment%5cORT_SRS%5cORT_FrontEnd%5cORT_APPLICATION%5c&amp;AUTH_TYPE=&amp;AUTH_USER=&amp;AUTH_PASSWORD=&amp;LOGON_USER=MUMBAI%5csandeepr&amp;REMOTE_USER=&amp;CERT_COOKIE=&amp;CERT_FLAGS=&amp;CERT_ISSUER=&amp;CERT_KEYSIZE=&amp;CERT_SECRETKEYSIZE=&amp;CERT_SERIALNUMBER=&amp;CERT_SERVER_ISSUER=&amp;CERT_SERVER_SUBJECT=&amp;CERT_SUBJECT=&amp;CONTENT_LENGTH=0&amp;CONTENT_TYPE=&amp;GATEWAY_INTERFACE=&amp;HTTPS=&amp;HTTPS_KEYSIZE=&amp;HTTPS_SECRETKEYSIZE=&amp;HTTPS_SERVER_ISSUER=&amp;HTTPS_SERVER_SUBJECT=&amp;INSTANCE_ID=&amp;INSTANCE_META_PATH=&amp;LOCAL_ADDR=127.0.0.1&amp;PATH_INFO=%2fEngine%2fRenderSurvey&amp;PATH_TRANSLATED=D%3a%5cSandeepRao%5cDevelopment%5cORT_SRS%5cORT_FrontEnd%5cORT_APPLICATION%5cEngine%5cRenderSurvey&amp;QUERY_STRING=Data%3dRl%252bwWeqdfvANNVbAuIZSyvNz9NoPKNnz1HLWH6KmPi024S1TVhl%252bWA%253d%253d&amp;REMOTE_ADDR=127.0.0.1&amp;REMOTE_HOST=127.0.0.1&amp;REMOTE_PORT=&amp;REQUEST_METHOD=GET&amp;SCRIPT_NAME=%2fEngine%2fRenderSurvey&amp;SERVER_NAME=localhost&amp;SERVER_PORT=5000&amp;SERVER_PORT_SECURE=0&amp;SERVER_PROTOCOL=HTTP%2f1.1&amp;SERVER_SOFTWARE=&amp;URL=%2fEngine%2fRenderSurvey&amp;HTTP_CACHE_CONTROL=max-age%3d0&amp;HTTP_CONNECTION=keep-alive&amp;HTTP_ACCEPT=text%2fhtml%2capplication%2fxhtml%2bxml%2capplication%2fxml%3bq%3d0.9%2c*%2f*%3bq%3d0.8&amp;HTTP_ACCEPT_CHARSET=ISO-8859-1%2cutf-8%3bq%3d0.7%2c*%3bq%3d0.3&amp;HTTP_ACCEPT_ENCODING=gzip%2cdeflate%2csdch&amp;HTTP_ACCEPT_LANGUAGE=en-GB%2cen-US%3bq%3d0.8%2cen%3bq%3d0.6&amp;HTTP_COOKIE=SessionId%3dUserSessionId%3d5c53423ywj1rjnu25gbbmx45%26SurveyId%3d1098%3b+SessionId1102%3dUserSessionId%3dfupijdum2rgg4z55jjrqukz2%26SurveyId%3d1102%3b+SessionId1098%3dUserSessionId%3d0zrthmyztw4nfj55jaybbrno%26SurveyId%3d1098%3b+SessionId1100%3dUserSessionId%3d3d3rewfca2mo2z21ifavub45%26SurveyId%3d1100%3b+ASP.NET_SessionId%3d4riazs55rjawbi45akzb5k55&amp;HTTP_HOST=localhost%3a5000&amp;HTTP_USER_AGENT=Mozilla%2f5.0+(Windows+NT+6.1)+AppleWebKit%2f537.4+(KHTML%2c+like+Gecko)+Chrome%2f22.0.1229.94+Safari%2f537.4</WebFormParams>
  <IpAddress>127.0.0.1</IpAddress>
  <BrowserType>Desktop</BrowserType>
  <Browser>AppleMAC-Safari</Browser>
  <BrowserVersion>5.0</BrowserVersion>
  <ScreenResolution />
  <FlashVersion />
  <JavaSupport>1.4</JavaSupport>
  <SupportCookies>True</SupportCookies>
  <UserAgent>Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4</UserAgent>
</WebRequestInfo>'
*/

CREATE PROCEDURE DBO.UspSaveWebRequestData
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData

	DECLARE @RequestId INT
	SET @RequestId = 0
	
	DECLARE @TableRename VARCHAR(100)
	DECLARE @Year VARCHAR(4)
	DECLARE @Month VARCHAR(15)
	SET @Year = YEAR(GETDATE())
	SET @Month = DATENAME(MONTH,GETDATE())
	SET @TableRename = 'MS_WebRequestInfo_'+@Year+'_'+LTRIM(RTRIM(@Month)) 
	--SELECT @TableRename -- MS_WebRequestInfo_2013_April
	
	DECLARE @WebRequestInfo TABLE
	(
		[Controller] [varchar](100) NULL, [Action] [varchar](100) NULL, [WebFormParams] [varchar](500) NULL,
		[IpAddress] [varchar](100) NULL, [BrowserType] [varchar](100) NULL, [Browser] [varchar](100) NULL,
		[BrowserVersion] [varchar](20) NULL, [ScreenResolution] [varchar](100) NULL,
		[FlashVersion] [varchar](100) NULL, [JavaSupport] [varchar](20) NULL, [SupportCookies] [varchar](100) NULL,
		[UserAgent] [varchar](MAX) NULL, [InputStream] [varchar](MAX) NULL	
	)
	INSERT INTO @WebRequestInfo
	(
		Controller, [Action], InputStream, WebFormParams, IpAddress, BrowserType, Browser, BrowserVersion, 
		ScreenResolution, FlashVersion, JavaSupport, SupportCookies, UserAgent
	)
	SELECT
		Parent.Elm.value('(Controller)[1]','VARCHAR(100)') AS 'Controller',
		Parent.Elm.value('(Action)[1]','VARCHAR(100)') AS 'Action',
		Parent.Elm.value('(InputStream)[1]','VARCHAR(MAX)') AS 'InputStream',
		Parent.Elm.value('(WebFormParams)[1]','VARCHAR(500)') AS 'WebFormParams',
		Parent.Elm.value('(IpAddress)[1]','VARCHAR(100)') AS 'IpAddress',
		Parent.Elm.value('(BrowserType)[1]','VARCHAR(100)') AS 'BrowserType',
		Parent.Elm.value('(Browser)[1]','VARCHAR(100)') AS 'Browser',
		Parent.Elm.value('(BrowserVersion)[1]','VARCHAR(20)') AS 'BrowserVersion',
		Parent.Elm.value('(ScreenResolution)[1]','VARCHAR(100)') AS 'ScreenResolution',
		Parent.Elm.value('(FlashVersion)[1]','VARCHAR(100)') AS 'FlashVersion',
		Parent.Elm.value('(JavaSupport)[1]','VARCHAR(20)') AS 'JavaSupport',
		Parent.Elm.value('(SupportCookies)[1]','VARCHAR(100)') AS 'SupportCookies',
		Parent.Elm.value('(UserAgent)[1]','VARCHAR(MAX)') AS 'UserAgent'
	--INTO #WebRequestInfo
	FROM @input.nodes('/WebRequestInfo') AS Parent(Elm)
	
	
	IF EXISTS(SELECT 1 FROM SYSOBJECTS WHERE XTYPE = 'U' AND NAME = @TableRename)
	BEGIN
		INSERT INTO DBO.MS_WebRequestInfo
		(
			Controller, [Action], InputStream, WebFormParams, IpAddress, BrowserType, Browser, BrowserVersion, 
			ScreenResolution, FlashVersion, JavaSupport, SupportCookies, UserAgent, ReqDate
		)
		SELECT 
			Controller, [Action], InputStream, WebFormParams, IpAddress, BrowserType, Browser, BrowserVersion, 
			ScreenResolution, FlashVersion, JavaSupport, SupportCookies, UserAgent, GETDATE()		
		FROM @WebRequestInfo

		SET @RequestId = @@IDENTITY

		SELECT 1 AS RetValue, 'Successfully Response Inserted' AS Remark, @RequestId AS RequestId
	END
	ELSE
	BEGIN
		EXEC sp_rename 'MS_WebRequestInfo', @TableRename
		
		CREATE TABLE [dbo].[MS_WebRequestInfo]
		(
			[RequestId] [int] IDENTITY(1,1) NOT NULL, 
			[Controller] [varchar](100) NULL, 
			[Action] [varchar](100) NULL,
			[WebFormParams] [varchar](500) NULL,
			[IpAddress] [varchar](100) NULL,
			[BrowserType] [varchar](100) NULL,
			[Browser] [varchar](100) NULL,
			[BrowserVersion] [varchar](20) NULL,
			[ScreenResolution] [varchar](100) NULL,
			[FlashVersion] [varchar](100) NULL,
			[JavaSupport] [varchar](20) NULL,
			[SupportCookies] [varchar](100) NULL,
			[UserAgent] [varchar](MAX) NULL,
			[InputStream] [varchar](MAX) NULL,
			[ReqDate] [datetime] NULL  
		)   
		INSERT INTO DBO.MS_WebRequestInfo
		(
			Controller, [Action], InputStream, WebFormParams, IpAddress, BrowserType, Browser, BrowserVersion, 
			ScreenResolution, FlashVersion, JavaSupport, SupportCookies, UserAgent, ReqDate
		)
		SELECT 
			Controller, [Action], InputStream, WebFormParams, IpAddress, BrowserType, Browser, BrowserVersion, 
			ScreenResolution, FlashVersion, JavaSupport, SupportCookies, UserAgent, GETDATE()		
		FROM @WebRequestInfo

		SET @RequestId = @@IDENTITY

		SELECT 1 AS RetValue, 'Successfully Response Inserted' AS Remark, @RequestId AS RequestId
	END

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
