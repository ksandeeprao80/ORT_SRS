IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveMessageLibraryDetails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveMessageLibraryDetails
GO 
/* 
EXEC UspSaveMessageLibraryDetails '<?xml version="1.0" encoding="utf-16"?>
<MessageLibrary>
  <LibraryId>22</LibraryId>
  <LibType>Message</LibType>
  <LibraryName>Jd tested</LibraryName>
  <Customer>
    <CustomerId>1</CustomerId>
    <IsActive>false</IsActive>
  </Customer>
  <Description>Test Description. Des</Description>
  <MessageLibraryId>22</MessageLibraryId>
  <MailType>General</MailType>
  <MessageDescription>Jd tested</MessageDescription>
  <MessageText>Test Description. Des</MessageText>
  <Category>
    <CategoryId>999</CategoryId>
  </Category>
</MessageLibrary>'
*/
CREATE PROCEDURE DBO.UspSaveMessageLibraryDetails
	@XmlData NTEXT,
	@XmlUserInfo AS NTEXT
AS 
SET NOCOUNT ON
BEGIN
BEGIN TRY

	DECLARE @MessageLibId INT,
		@Remark VARCHAR(100),
		@RetValue INT
	SET @MessageLibId = 0
	SET @Remark = ''
	SET @RetValue = 0
		
	BEGIN TRAN
	
	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo
	
	DECLARE @CreatedBy INT
	SELECT @CreatedBy = CONVERT(INT,UserId) FROM @UserInfo
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SLU')
	BEGIN
		SET @MessageLibId = 0
		SET @RetValue = 0 
		SET @Remark = 'Access Denied'
	END
	ELSE
	BEGIN
		DECLARE @input XML = @XmlData
		-------------------------------------------------------------------------------------

		CREATE TABLE #MessageLibrary
		(
			LibraryId VARCHAR(20),LibType VARCHAR(30), LibraryName VARCHAR(150), /*[Description] VARCHAR(150),*/ 
			MessageLibraryId VARCHAR(20), MessageDescription NVARCHAR(150), MessageText NVARCHAR(MAX), 
			CustomerId VARCHAR(20), IsActive VARCHAR(20), CategoryId VARCHAR(20)
		)
		INSERT INTO #MessageLibrary
		(
			LibraryId,LibType, LibraryName, /*[Description],*/ MessageLibraryId, MessageDescription, 
			MessageText, CustomerId, IsActive, CategoryId
		)
		SELECT
			Parent.Elm.value('(LibraryId)[1]','VARCHAR(20)') AS LibraryId,
			Parent.Elm.value('(LibraryName)[1]','VARCHAR(30)') AS LibType,
			Parent.Elm.value('(LibraryName)[1]','VARCHAR(150)') AS LibraryName,		
			Parent.Elm.value('(MessageLibraryId)[1]','VARCHAR(20)') AS MessageLibraryId,
			Parent.Elm.value('(MessageDescription)[1]','NVARCHAR(150)') AS MessageDescription,
			Parent.Elm.value('(MessageText)[1]','NVARCHAR(MAX)') AS MessageText,
			Child.Elm.value('(CustomerId)[1]','VARCHAR(20)') AS CustomerId,
			Child.Elm.value('(IsActive)[1]','VARCHAR(20)') AS IsActive,
			Child1.Elm.value('(CategoryId)[1]','VARCHAR(20)') AS CategoryId
		FROM @input.nodes('/MessageLibrary') AS Parent(Elm)
		CROSS APPLY
			Parent.Elm.nodes('Customer') AS Child(Elm)
		CROSS APPLY
			Parent.Elm.nodes('Category') AS Child1(Elm)

		IF EXISTS
		(
			SELECT 1 FROM DBO.TR_LibraryCategory TLC
			INNER JOIN #MessageLibrary ML
				ON TLC.LibId = CONVERT(INT,ML.LibraryId) 
				AND TLC.CategoryId = CONVERT(INT,ML.CategoryId)
		)
		BEGIN
			IF EXISTS
			(
				SELECT 1 FROM #MessageLibrary ML INNER JOIN DBO.TR_MessageLibrary TML
				ON ML.LibraryId = CONVERT(INT,TML.LibId) 
					AND LTRIM(RTRIM(ML.MessageDescription)) = LTRIM(RTRIM(TML.MessageDescription))
					AND LTRIM(RTRIM(ML.MessageText)) = LTRIM(RTRIM(TML.MessageText))
					AND ML.MessageLibraryId = 'undefined'  
			)
			BEGIN 
				SET @RetValue = 1
				SET @Remark = 'Message Library Already Exist'
				SET @MessageLibId = 0
			END		
			ELSE
			BEGIN 
				IF EXISTS(SELECT 1 FROM #MessageLibrary WHERE MessageLibraryId = 'undefined') 
				BEGIN
				
					DECLARE @UserId INT, @RoleDesc VARCHAR(2)
					SET @UserId = 0					
					SELECT @UserId = TL.CreatedBy FROM #MessageLibrary ML
					INNER JOIN DBO.TR_Library TL
						ON CONVERT(INT,ML.LibraryId) = TL.LibId
					
					SELECT @RoleDesc = LTRIM(RTRIM(UserType)) FROM MS_Users WHERE UserId = @UserId	

					IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
					BEGIN
						INSERT INTO DBO.TR_MessageLibrary
						(
							LibId, MessageTypeId, MessageDescription, MessageText, TemplateName, IsActive, CategoryId,
							CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
						)
						SELECT -- Hard coded as per instruction due to in ui it is not mentioned.-- Nilesh 26092012
							CONVERT(INT,ML.LibraryId), 2 AS MessageTypeId, ML.MessageDescription, ML.MessageText, NULL, 1,
							CONVERT(INT,ML.CategoryId), @CreatedBy, GETDATE(), @CreatedBy, GETDATE()
						FROM #MessageLibrary ML
						INNER JOIN DBO.TR_Library TL
							ON CONVERT(INT,ML.LibraryId) = TL.LibId
						WHERE ML.MessageLibraryId = 'undefined'	
						
						SET @MessageLibId = @@IDENTITY
						SELECT @RetValue = 1 
						SELECT @Remark = 'Successfully Inserted' 
					END
					IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'GU') 
					BEGIN
						IF @RoleDesc = 'SA'
						BEGIN
							SET @MessageLibId = 0
							SET @RetValue = 0 
							SET @Remark = 'Access Denied' 
						END
						ELSE
						BEGIN
							INSERT INTO DBO.TR_MessageLibrary
							(
								LibId, MessageTypeId, MessageDescription, MessageText, TemplateName, IsActive, CategoryId,
								CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
							)
							SELECT -- Hard coded as per instruction due to in ui it is not mentioned.-- Nilesh 26092012
								CONVERT(INT,ML.LibraryId), 2 AS MessageTypeId, ML.MessageDescription, ML.MessageText, NULL, 1,
								CONVERT(INT,ML.CategoryId), @CreatedBy, GETDATE(), @CreatedBy, GETDATE()
							FROM #MessageLibrary ML
							INNER JOIN DBO.TR_Library TL
								ON CONVERT(INT,ML.LibraryId) = TL.LibId
							INNER JOIN @UserInfo UI
								ON TL.CustomerId = CONVERT(INT,UI.CustomerId)  	
							WHERE ML.MessageLibraryId = 'undefined'	
							
							SET @MessageLibId = @@IDENTITY
							SELECT @RetValue = 1 
							SELECT @Remark = 'Successfully Inserted'		
						END
					END
					IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SU')
					BEGIN
						IF EXISTS
						(
							SELECT 1 FROM #MessageLibrary ML
							INNER JOIN DBO.TR_Library TL
								ON CONVERT(INT,ML.LibraryId) = TL.LibId
							WHERE TL.CreatedBy = @CreatedBy
						)
						BEGIN
							INSERT INTO DBO.TR_MessageLibrary
							(
								LibId, MessageTypeId, MessageDescription, MessageText, TemplateName, IsActive, CategoryId,
								CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
							)
							SELECT -- Hard coded as per instruction due to in ui it is not mentioned.-- Nilesh 26092012
								CONVERT(INT,ML.LibraryId), 2 AS MessageTypeId, ML.MessageDescription, ML.MessageText, NULL, 1,
								CONVERT(INT,ML.CategoryId), @CreatedBy, GETDATE(), @CreatedBy, GETDATE()
							FROM #MessageLibrary ML
							WHERE ML.MessageLibraryId = 'undefined'	
							
							SET @MessageLibId = @@IDENTITY
							SELECT @RetValue = 1 
							SELECT @Remark = 'Successfully Inserted' 
						END
						ELSE	
						BEGIN
							SET @MessageLibId = 0
							SET @RetValue = 0 
							SET @Remark = 'Access Denied' 
						END
					END
				END
				ELSE
				IF NOT EXISTS(SELECT 1 FROM #MessageLibrary WHERE MessageLibraryId = 'undefined') 
				BEGIN
					IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
					BEGIN
						UPDATE TML 
						SET TML.MessageText = ML.MessageText,
							TML.MessageDescription = ML.MessageDescription,
							TML.ModifiedBy = @CreatedBy,
							TML.ModifiedOn = GETDATE()   
						FROM TR_MessageLibrary TML
						INNER JOIN DBO.TR_Library TL
							ON TML.LibId = TL.LibId
						INNER JOIN #MessageLibrary ML 
							ON CONVERT(VARCHAR(12),TML.MessageLibId) = ML.MessageLibraryId
							
						SET @RetValue = 1
						SET @Remark = 'Successfully Updated'
						SET @MessageLibId = 0
					END
					IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'GU')
					BEGIN
						IF @RoleDesc = 'SA'
						BEGIN
							SET @MessageLibId = 0
							SET @RetValue = 0 
							SET @Remark = 'Access Denied' 
						END
						ELSE
						BEGIN
							UPDATE TML 
							SET TML.MessageText = ML.MessageText,
								TML.MessageDescription = ML.MessageDescription,
								TML.ModifiedBy = @CreatedBy,
								TML.ModifiedOn = GETDATE()   
							FROM TR_MessageLibrary TML
							INNER JOIN DBO.TR_Library TL
								ON TML.LibId = TL.LibId
							INNER JOIN #MessageLibrary ML 
								ON CONVERT(VARCHAR(12),TML.MessageLibId) = ML.MessageLibraryId
							INNER JOIN @UserInfo UI
								ON TL.CustomerId = CONVERT(INT,UI.CustomerId)  
								
							SET @RetValue = 1
							SET @Remark = 'Successfully Updated'
							SET @MessageLibId = 0
						END
					END
					IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SU')
					BEGIN
						IF EXISTS
						(
							SELECT 1 FROM TR_MessageLibrary TML
							INNER JOIN DBO.TR_Library TL
								ON TML.LibId = TL.LibId
							INNER JOIN #MessageLibrary ML 
								ON CONVERT(VARCHAR(12),TML.MessageLibId) = ML.MessageLibraryId
							WHERE TL.CreatedBy = @CreatedBy
						)
						BEGIN
							UPDATE TML 
							SET TML.MessageText = ML.MessageText,
								TML.MessageDescription = ML.MessageDescription,
								TML.ModifiedBy = @CreatedBy,
								TML.ModifiedOn = GETDATE()   
							FROM TR_MessageLibrary TML
							INNER JOIN #MessageLibrary ML 
								ON CONVERT(VARCHAR(12),TML.MessageLibId) = ML.MessageLibraryId
						
							SET @RetValue = 1
							SET @Remark = 'Successfully Updated'
							SELECT @MessageLibId = 0
						END
						ELSE	
						BEGIN
							SET @MessageLibId = 0
							SET @RetValue = 0 
							SET @Remark = 'Access Denied' 
						END
					END
				END
			END
		END
		ELSE
		BEGIN
			SET @RetValue = 0
			SET @Remark = 'Please select correct category'
			SET @MessageLibId = 0
		END
	END

	SELECT @RetValue AS RetValue, @Remark AS Remark, @MessageLibId AS MessageLibId

	COMMIT TRAN

END TRY

BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END



