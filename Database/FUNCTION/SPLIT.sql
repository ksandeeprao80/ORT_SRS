/****** Object:  UserDefinedFunction [dbo].[SPLIT]    Script Date: 11/29/2012 11:10:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPLIT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Split]
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 11/29/2012 11:10:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
SELECT * FROM [dbo].[Split] (',','1,2,3,0,11,22,33')
*/
CREATE FUNCTION [dbo].[Split] 
(  
	@Delimiter VARCHAR(5), 
	@List VARCHAR(MAX) 
) 
RETURNS @TableOfValues TABLE 
(  
	RowId SMALLINT IDENTITY(1,1), 
    [Value] VARCHAR(MAX) 
) 
AS 
BEGIN
	DECLARE @LenString INT 

	WHILE LEN(@List) > 0 
	BEGIN 
		SELECT @LenString = (CASE CHARINDEX(@Delimiter,@List) WHEN 0 THEN LEN(@List) 
							ELSE (CHARINDEX(@Delimiter,@List)-1)END) 

		INSERT INTO @TableOfValues 
		SELECT SUBSTRING(@List,1,@LenString)

		SELECT @List = (CASE(LEN(@List)-@LenString) WHEN 0 THEN '' ELSE RIGHT(@List,LEN(@List)-@LenString-1)END) 
	END

	RETURN 
END

GO


