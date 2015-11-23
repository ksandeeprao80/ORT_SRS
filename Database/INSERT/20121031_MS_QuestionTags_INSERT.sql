DECLARE @AGE VARCHAR(20),
	@DateOfBirth VARCHAR(20),
	@Sex VARCHAR(20)
SET @AGE = 'AGE'
SET @DateOfBirth = 'DateOfBirth'
SET @Sex = 'Sex'

IF NOT EXISTS(SELECT 1 FROM DBO.MS_QuestionTags WHERE TagName = @AGE)
BEGIN
	INSERT INTO DBO.MS_QuestionTags
	(TagName)
	SELECT 'AGE'
END

IF NOT EXISTS(SELECT 1 FROM DBO.MS_QuestionTags WHERE TagName = @DateOfBirth)
BEGIN
	INSERT INTO DBO.MS_QuestionTags
	(TagName)
	SELECT 'DateOfBirth'
END

IF NOT EXISTS(SELECT 1 FROM DBO.MS_QuestionTags WHERE TagName = @Sex)
BEGIN
	INSERT INTO DBO.MS_QuestionTags
	(TagName)
	SELECT 'Sex'
END

