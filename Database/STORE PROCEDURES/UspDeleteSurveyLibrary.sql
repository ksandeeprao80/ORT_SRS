IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteSurveyLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteSurveyLibrary]
GO

--EXEC UspDeleteSurveyLibrary 1 

CREATE PROCEDURE DBO.UspDeleteSurveyLibrary
	@SurveyLibId INT,
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo

	DECLARE @CreatedBy INT, @CustomerId INT
	SELECT @CreatedBy = CONVERT(INT,UserId) FROM @UserInfo
	SELECT @CustomerId = CONVERT(INT,CustomerId) FROM @UserInfo

	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_SurveyLibrary TSL
		INNER JOIN DBO.TR_Survey TS
			ON TSL.SurveyId = TS.SurveyId
			AND TSL.SurveyLibId = @SurveyLibId
			AND TS.SurveyId = 1
	)
	BEGIN
		SELECT 1 AS RetValue, 'Survey Library Can not Deleted' AS Remark
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SU')
		BEGIN
			IF EXISTS(SELECT 1 FROM DBO.TR_SurveyLibrary WHERE SurveyLibId = @SurveyLibId AND CreatedBy = @CreatedBy)
			BEGIN
				DELETE FROM DBO.TR_SurveyLibrary WHERE SurveyLibId = @SurveyLibId AND CreatedBy = @CreatedBy
				
				SELECT 1 AS RetValue, 'Successfully Survey Library Deleted' AS Remark
			END
			ELSE
			BEGIN
				SELECT 0 AS RetValue, 'Access Denied' AS Remark
			END
		END
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'GU')
		BEGIN
			DELETE TSL
			FROM DBO.TR_SurveyLibrary TSL 
			INNER JOIN DBO.TR_Library TL
				ON TSL.LibId = TL.LibId
			WHERE TL.CustomerId = @CustomerId
				AND TSL.SurveyLibId = @SurveyLibId
				
			SELECT 1 AS RetValue, 'Successfully Survey Library Deleted' AS Remark
		END
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
		BEGIN
			DELETE FROM DBO.TR_SurveyLibrary WHERE SurveyLibId = @SurveyLibId
			
			SELECT 1 AS RetValue, 'Successfully Survey Library Deleted' AS Remark
		END
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SLU')
		BEGIN
			SELECT 0 AS RetValue, 'Access Denied' AS Remark
		END
	END

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

