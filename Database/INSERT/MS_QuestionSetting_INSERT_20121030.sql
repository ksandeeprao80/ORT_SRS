  DECLARE @IsPipedIn VARCHAR(20),
	@IsPipedOut VARCHAR(20),
	@QuestionTagId VARCHAR(50),
	@Setting INT
  SET @IsPipedIn = 'IsPipedIn'
  SET @IsPipedOut = 'IsPipedOut'
  SET @QuestionTagId = 'QuestionTagId'
  SET @Setting = 0 
  
  IF NOT EXISTS(SELECT 1 FROM MS_QuestionSettings WHERE SettingName = @IsPipedIn)
  BEGIN
	INSERT INTO DBO.MS_QuestionSettings
	(SettingName)
	SELECT @IsPipedIn
  END	
  
    
  IF NOT EXISTS(SELECT 1 FROM MS_QuestionSettings WHERE SettingName = @IsPipedOut)
  BEGIN
	INSERT INTO DBO.MS_QuestionSettings
	(SettingName)
	SELECT @IsPipedOut
  END	
  
  IF NOT EXISTS(SELECT 1 FROM MS_QuestionSettings WHERE SettingName = @QuestionTagId)
  BEGIN
	INSERT INTO DBO.MS_QuestionSettings
	(SettingName)
	SELECT @QuestionTagId
  END	
  
   