IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveTranslations]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveTranslations]
GO
-- EXEC UspSaveTranslations 
CREATE PROCEDURE DBO.UspSaveTranslations
	@SurveyId INT,
	@LanguageId INT,
	@EntityType CHAR(1),
	@EntityTypeId INT,
	@TransText VARCHAR(1000)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_Translations WITH(NOLOCK)
		WHERE SurveyId = @SurveyId AND LanguageId = @LanguageId 
			AND EntityType = @EntityType AND EntityTypeId = @EntityTypeId
	) 
	BEGIN
		SELECT 1 AS RetValue, 'Already Exist In The System' AS Remark 
		
		RETURN
	END
	ELSE
	BEGIN
		INSERT INTO DBO.TR_Translations
		(		
			SurveyId, LanguageId, EntityType, EntityTypeId, TransText
		)
		VALUES
		(
			@SurveyId, @LanguageId, LTRIM(RTRIM(@EntityType)), @EntityTypeId, LTRIM(RTRIM(@TransText))
	 	)
	
		SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark
		
		RETURN
	END
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END