INSERT INTO TR_FileLibrary
SELECT 9,'NeeleNeeleAmbarPar','File','NeeleNeeleAmbarPar.mp3',1
go
update TR_FileLibrary set FileName = FileName+'.mp3' where Filelibid > 20
go
update TR_FileLibrary set FileLibName = replace(FileLibName,'.mp3','') where Filelibid > 20
go
INSERT INTO TR_MediaInfo
SELECT 8738,25,1,1,1,1,1,5
go
insert into TR_SoundClipInfo
select 25,'NeeleNeeleAmbarPar','Lata','1970',''
