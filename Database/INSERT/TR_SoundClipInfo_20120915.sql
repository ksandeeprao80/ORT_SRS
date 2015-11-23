INSERT INTO TR_SoundClipInfo
SELECT FileLibId, FileName,'Sahgal','1950','' FROM TR_FileLibrary WHERE FileLibId = 21 UNION
SELECT FileLibId, FileName,'Hemant','1955','' FROM TR_FileLibrary WHERE FileLibId = 22 UNION
SELECT FileLibId, FileName,'Mukesh','1960','' FROM TR_FileLibrary WHERE FileLibId = 23 UNION
SELECT FileLibId, FileName,'Rafi','1965','' FROM TR_FileLibrary WHERE FileLibId = 24 
