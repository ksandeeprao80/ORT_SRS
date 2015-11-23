IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSavePlayList]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSavePlayList]

GO 

/*
EXEC UspSavePlayList '<?xml version="1.0" encoding="utf-16"?>
<PlayList>	
	<PlayListId/>
	<PlayListName>Best of Pankaj Udhas</PlayListName>
	<Songs/>
</PlayList>'
*/ 
CREATE PROCEDURE DBO.UspSavePlayList
	@XmlData NTEXT,
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
	
	
	DECLARE @input XML = @XmlData

	CREATE TABLE #PlayList
	(PlayListId VARCHAR(20), PlayListName VARCHAR(150), Songs VARCHAR(150))
	INSERT INTO #PlayList
	(
		PlayListId, PlayListName, Songs
	)
	SELECT
		Parent.Elm.value('(PlayListId)[1]','VARCHAR(20)') AS PlayListId,
		Parent.Elm.value('(PlayListName)[1]','VARCHAR(150)') AS PlayListName,
		Parent.Elm.value('(Songs)[1]','VARCHAR(150)') AS Songs
	--INTO ##PlayList
	FROM @input.nodes('/PlayList') AS Parent(Elm)
	
	IF EXISTS
	(
		SELECT 1 FROM DBO.MS_PlayList MPL 
		INNER JOIN #PlayList PL
			ON LTRIM(RTRIM(MPL.PlayListName)) = LTRIM(RTRIM(PL.PlayListName))
			AND MPL.CustomerId = @CustomerId
	)
	BEGIN
		SELECT 1 AS RetValue, 'Play List Name Already Exist In The System' AS Remark, 0 AS PlayListId
	END
	ELSE
	BEGIN
		DECLARE @PlayListId INT
		SET @PlayListId = 0

		INSERT INTO DBO.MS_PlayList
		(PlayListName, IsActive, CustomerId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT PlayListName, 1, @CustomerId, @CreatedBy, GETDATE(), @CreatedBy, GETDATE() FROM #PlayList

		SET @PlayListId = @@IDENTITY

		SELECT CASE WHEN @PlayListId = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN @PlayListId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark, 
			@PlayListId AS PlayListId
	END

	DROP TABLE #PlayList
		
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
