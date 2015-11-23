SET IDENTITY_INSERT MS_Users ON

INSERT INTO DBO.MS_Users
(UserId,LoginId,UserCode,UserName,UserPassword,CustomerId,EmailId,IsActive,UserType
,LangauageName,TimeZone,Phone1,Phone2,Phone3,Department,CreatedBy,CreatedOn 
)
SELECT 1,'j007','SRS1','SYSADMIN','ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',1,'sysadmin@gmail.com',
1,'SA','ENGLISH','GMT+05:30','020-61231235','020-61231234','','admin',1,GETDATE()

SET IDENTITY_INSERT MS_Users OFF

