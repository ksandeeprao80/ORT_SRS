IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetTrSurveySettings]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetTrSurveySettings]

GO
-- EXEC UspGetTrSurveySettings NULL,1602
CREATE PROCEDURE DBO.UspGetTrSurveySettings
	@SettingId INT = NULL,
	@SurveyId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @E_O_S_Message_Text NVARCHAR(MAX),
			@E_O_S_Email_Text NVARCHAR(MAX),
			@CustomerId INT,
			@ReferMessageText NVARCHAR(MAX), 	
			@ReferFriendEmailMessageText  NVARCHAR(MAX)	
	SET @E_O_S_Message_Text = ''
	SET @E_O_S_Email_Text = ''
	SET @CustomerId = 0
	SET @ReferMessageText = ''
	SET @ReferFriendEmailMessageText = ''
	
	IF EXISTS
	(
		SELECT 1 FROM DBO.MS_SurveySettings MSS INNER JOIN DBO.PB_TR_SurveySettings TSS 
			ON MSS.SettingId = TSS.SettingId AND TSS.SurveyId = @SurveyId
			AND MSS.SettingName = 'E_O_S_MESSAGE' AND TSS.Value = 'True'
	)
	BEGIN
		IF EXISTS
		(
			SELECT 1 FROM DBO.PB_TR_SurveySettings TSS INNER JOIN DBO.MS_SurveySettings MSS
				ON MSS.SettingId = TSS.SettingId AND TSS.SurveyId = @SurveyId
				AND MSS.SettingName = 'E_O_S_MESSAGE_ID' AND TSS.Value = '0'
		)
		BEGIN
			SELECT 
				@E_O_S_Message_Text = TSS.Value, @CustomerId = TSS.CustomerId 
			FROM DBO.PB_TR_SurveySettings TSS INNER JOIN DBO.MS_SurveySettings MSS
				ON MSS.SettingId = TSS.SettingId AND TSS.SurveyId = @SurveyId
				AND MSS.SettingName = 'E_O_S_MESSAGE_TEXT'
		END
		ELSE
		BEGIN	
			SELECT @E_O_S_Message_Text = TML.MessageText, @CustomerId = TSS.CustomerId 
			FROM DBO.TR_MessageLibrary TML
			INNER JOIN 
			(
				SELECT TSS.* FROM DBO.PB_TR_SurveySettings TSS
				INNER JOIN DBO.MS_SurveySettings MSS
					ON MSS.SettingId = TSS.SettingId
					AND TSS.SurveyId = @SurveyId
					AND MSS.SettingName = 'E_O_S_MESSAGE_ID'
			) TSS
				ON TSS.Value = CONVERT(VARCHAR(12),TML.MessageLibId)
		END
	END

	IF EXISTS
	(
		SELECT 1 FROM DBO.MS_SurveySettings MSS INNER JOIN DBO.PB_TR_SurveySettings TSS 
			ON MSS.SettingId = TSS.SettingId AND TSS.SurveyId = @SurveyId
			AND MSS.SettingName = 'E_O_S_EMAIL' AND TSS.Value = 'True'
	)
	BEGIN
		IF EXISTS
		(
			SELECT 1 FROM DBO.PB_TR_SurveySettings TSS INNER JOIN DBO.MS_SurveySettings MSS
				ON MSS.SettingId = TSS.SettingId AND TSS.SurveyId = @SurveyId
				AND MSS.SettingName = 'E_O_S_EMAIL_ID' AND TSS.Value = '0'
		)
		BEGIN
			SELECT 
				@E_O_S_Email_Text = TSS.Value, @CustomerId = TSS.CustomerId 
			FROM DBO.PB_TR_SurveySettings TSS INNER JOIN DBO.MS_SurveySettings MSS
				ON MSS.SettingId = TSS.SettingId AND TSS.SurveyId = @SurveyId
				AND MSS.SettingName = 'E_O_S_EMAIL_TEXT'
		END
		ELSE
		BEGIN
			SELECT @E_O_S_Email_Text = TML.MessageText, @CustomerId = TSS.CustomerId 
			FROM DBO.TR_MessageLibrary TML 
			INNER JOIN 
			(
				SELECT TSS.* FROM DBO.PB_TR_SurveySettings TSS INNER JOIN DBO.MS_SurveySettings MSS
					ON MSS.SettingId = TSS.SettingId AND TSS.SurveyId = @SurveyId
					AND MSS.SettingName = 'E_O_S_EMAIL_ID'
			) TSS
				ON LTRIM(RTRIM(TSS.Value)) = CONVERT(VARCHAR(12),TML.MessageLibId)
		END
	END
	
	IF EXISTS
	(
		SELECT 1 FROM DBO.MS_SurveySettings MSS INNER JOIN DBO.PB_TR_SurveySettings TSS 
			ON MSS.SettingId = TSS.SettingId AND TSS.SurveyId = @SurveyId
			AND MSS.SettingName = 'ReferFriend' AND TSS.Value = 'True'
	)
	BEGIN
		SELECT @ReferMessageText = TML.MessageText, @CustomerId = TSS.CustomerId 
		FROM DBO.TR_MessageLibrary TML
		INNER JOIN 
		(
			SELECT TSS.* FROM DBO.PB_TR_SurveySettings TSS
			INNER JOIN DBO.MS_SurveySettings MSS
				ON MSS.SettingId = TSS.SettingId
				AND TSS.SurveyId = @SurveyId
				AND MSS.SettingName = 'ReferMessageLibId'
		) TSS
			ON LTRIM(RTRIM(TSS.Value)) = CONVERT(VARCHAR(12),TML.MessageLibId)
	END
	ELSE
	BEGIN
		SELECT 
			@ReferMessageText = '', @CustomerId = TSS.CustomerId 
		FROM DBO.PB_TR_SurveySettings TSS INNER JOIN DBO.MS_SurveySettings MSS
			ON MSS.SettingId = TSS.SettingId AND TSS.SurveyId = @SurveyId
			AND MSS.SettingName = 'ReferFriend'	
	END
	
	IF EXISTS
	(
		SELECT 1 FROM MS_SurveySettings MSS INNER JOIN DBO.PB_TR_SurveySettings TSS
		ON MSS.SettingId = TSS.SettingId AND TSS.SurveyId = @SurveyId 
		AND MSS.SettingName = 'ReferFriendMessageId' AND ISNULL(TSS.Value,'') <> ''
	)
	BEGIN
		SELECT @ReferFriendEmailMessageText = TML.MessageText
		FROM DBO.TR_MessageLibrary TML  
		INNER JOIN 
		(
			SELECT TSS.* FROM DBO.PB_TR_SurveySettings TSS
			INNER JOIN DBO.MS_SurveySettings MSS
				ON MSS.SettingId = TSS.SettingId
				AND TSS.SurveyId = @SurveyId
				AND MSS.SettingName = 'ReferFriendMessageId'
		) TSS
			ON LTRIM(RTRIM(TSS.Value)) = CONVERT(VARCHAR(12),TML.MessageLibId)	
	END
	
	SELECT 
		TSS.SurveyId, MSS.SettingId, LTRIM(RTRIM(ISNULL(MSS.SettingType,''))) AS SettingType, 
		LTRIM(RTRIM(ISNULL(MSS.SettingName,''))) AS SettingName, ISNULL(TSS.CustomerId,'') AS CustomerId, 
		CASE WHEN TSS.SettingId = 15 AND LTRIM(RTRIM(TSS.Value)) = '0' THEN ''
			 WHEN TSS.SettingId = 16 AND LTRIM(RTRIM(TSS.Value)) = '0' THEN ''
			 ELSE LTRIM(RTRIM(ISNULL(TSS.Value,''))) END AS Value, 
		ISNULL(MSS.DisplayText,'') AS DisplayText
	FROM DBO.MS_SurveySettings MSS  
	LEFT OUTER JOIN 
	(
		SELECT TSS.* FROM DBO.PB_TR_SurveySettings TSS
		WHERE TSS.SettingId = ISNULL(@SettingId,TSS.SettingId)
			AND TSS.SurveyId = ISNULL(@SurveyId,TSS.SurveyId)
	) TSS
		ON MSS.SettingId = TSS.SettingId
	WHERE MSS.SettingName NOT IN('E_O_S_MESSAGE_TEXT','E_O_S_EMAIL_TEXT')
		
	UNION
	
	SELECT 
		ISNULL(@SurveyId,0) AS SurveyId, -1 AS SettingId, '' AS SettingType, 'E_O_S_MESSAGE_TEXT' AS SettingName,
		@CustomerId AS CustomerId, @E_O_S_Message_Text AS Value, '' AS MessageText
	
	UNION
	
	SELECT 
		ISNULL(@SurveyId,0) AS SurveyId, -2 AS SettingId, '' AS SettingType, 'E_O_S_EMAIL_TEXT' AS SettingName,
		@CustomerId AS CustomerId, @E_O_S_Email_Text AS Value, '' AS MessageText
		
	UNION
	
	SELECT 
		ISNULL(@SurveyId,0) AS SurveyId, -3 AS SettingId, '' AS SettingType, 'ReferMessageText' AS SettingName,
		@CustomerId AS CustomerId, @ReferMessageText AS Value, '' AS MessageText	
	
	UNION
	
	SELECT 
		ISNULL(@SurveyId,0) AS SurveyId, -4 AS SettingId, '' AS SettingType, 'ReferFriendEmailMessageText' AS SettingName,
		@CustomerId AS CustomerId, @ReferFriendEmailMessageText AS Value, '' AS MessageText	
	ORDER BY SettingId

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END