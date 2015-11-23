INSERT INTO DBO.MS_PlayList
SELECT 'Hits Of Steve Wonder',1
INSERT INTO MS_PlayList
SELECT 'Seattle Modern Pop',1
DECLARE @PlayListId INT
SET @PlayListId = 0
SELECT @PlayListId = PlayListId FROM DBO.MS_PlayList WHERE PlayListName = 'Seattle Modern Pop'
INSERT INTO DBO.TR_PlayList
(PlayListId,FileLibId)
SELECT TOP 50 @PlayListId,FileLibId FROM DBO.TR_FileLibrary WHERE FileLibName = 'KLCK1' 
