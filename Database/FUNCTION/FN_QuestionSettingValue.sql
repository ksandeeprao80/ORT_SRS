/****** Object:  UserDefinedFunction [dbo].[FN_QuestionSettingValue]    Script Date: 06/24/2013 11:10:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FN_QuestionSettingValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[FN_QuestionSettingValue]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_QuestionSettingValue]    Script Date: 11/29/2012 11:10:03 ******/

--SELECT DBO.FN_QuestionSettingValue(12975,'HideNextButtonFor')

CREATE FUNCTION DBO.FN_QuestionSettingValue(@QuestionId INT, @SettingName VARCHAR(50))
RETURNS VARCHAR(500)
AS 
BEGIN

	DECLARE @Value VARCHAR(500)
	SET @Value = ''

	SELECT @Value = TSS.Value 
	FROM MS_QuestionSettings MSS
	INNER JOIN TR_QuestionSettings TSS
	ON MSS.SettingId = TSS.SettingId
	AND MSS.SettingName = @SettingName
	AND TSS.QuestionId = @QuestionId
 
	RETURN @Value 
END	

 


