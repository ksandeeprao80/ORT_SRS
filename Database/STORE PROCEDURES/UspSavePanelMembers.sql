IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSavePanelMembers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSavePanelMembers
GO
/*
EXEC UspSavePanelMembers '<?xml version="1.0" encoding="utf-16"?>
<Panel>
	<LibraryId>58</LibraryId>
	<LibType>Panel</LibType>
	<Customer>
		<CustomerId>1</CustomerId>
		<IsActive>false</IsActive>
	</Customer>
	<PanelId>undefined</PanelId>
	<PanelName>TestPanel</PanelName>
	<PanelCategory>
	<CategoryId>5</CategoryId>
	</PanelCategory>
	<Members />
	<LastUsed>2012-10-01T00:00:00</LastUsed>
	<IsPanelActive>true</IsPanelActive>
	<CreatedBy />
	<ModifiedBy />
</Panel>'
*/

CREATE PROCEDURE DBO.UspSavePanelMembers
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	-----------------------------------------------------------------------------

	CREATE TABLE #PanelMembers
	(
		PanelistId VARCHAR(20), PanelistName VARCHAR(150), LibId VARCHAR(50), Members VARCHAR(150),
		LastUsed VARCHAR(50), IsPanelActive VARCHAR(20), LibType VARCHAR(50), CustomerId VARCHAR(20), 
		IsActive VARCHAR(10), CategoryId VARCHAR(20), CreatedBy VARCHAR(20), ModifiedBy VARCHAR(20)
		
	)
	INSERT INTO #PanelMembers
	(
		PanelistId, PanelistName, LibId, Members, LastUsed, IsPanelActive, LibType, 
		CustomerId, IsActive, CategoryId, CreatedBy, ModifiedBy
	)
	SELECT
		Parent.Elm.value('(PanelId)[1]','VARCHAR(20)') AS PanelistId,
		Parent.Elm.value('(PanelName)[1]','VARCHAR(150)') AS PanelistName,
		Parent.Elm.value('(LibraryId)[1]','VARCHAR(50)') AS LibId,
		Parent.Elm.value('(Members)[1]','VARCHAR(150)') AS Members,
		Parent.Elm.value('(LastUsed)[1]','VARCHAR(50)') AS LastUsed,
		Parent.Elm.value('(IsPanelActive)[1]','VARCHAR(20)') AS IsPanelActive,
		Parent.Elm.value('(LibType)[1]','VARCHAR(20)') AS LibType, 
		-- Customer----------
		Child.Elm.value('(CustomerId)[1]','VARCHAR(20)') AS CustomerId,
		Child.Elm.value('(IsActive)[1]','VARCHAR(10)') AS IsActive,
		-- PanelCategory----------
		Child1.Elm.value('(CategoryId)[1]','VARCHAR(20)') AS CategoryId,
		-- CreatedBy----------
		Child1.Elm.value('(UserId)[1]','VARCHAR(20)') AS CreatedBy,
		-- ModifiedBy----------
		Child1.Elm.value('(UserId)[1]','VARCHAR(20)') AS ModifiedBy
	--INTO #PanelMembers
	FROM @input.nodes('/Panel') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Customer') AS Child(Elm)
	CROSS APPLY
		Parent.Elm.nodes('PanelCategory') AS Child1(Elm)
	CROSS APPLY
		Parent.Elm.nodes('CreatedBy') AS Child2(Elm)
	CROSS APPLY
		Parent.Elm.nodes('ModifiedBy') AS Child3(Elm)

	IF EXISTS 
	(
		SELECT 1 FROM DBO.MS_PanelMembers MPM
		INNER JOIN #PanelMembers PM ON CONVERT(VARCHAR(12),MPM.LibId) = LTRIM(RTRIM(PM.LibId)) 
			AND CONVERT(VARCHAR(12),MPM.CustomerId) = LTRIM(RTRIM(PM.CustomerId))
			AND LTRIM(RTRIM(MPM.PanelistName)) = LTRIM(RTRIM(PM.PanelistName))
			AND MPM.CategoryId = CONVERT(INT,PM.CategoryId)
		WHERE PM.PanelistId = 'undefined' 
	)
	BEGIN
		SELECT 0 AS RetValue, 'Panelist already exist in the system' AS Remark, PanelistId FROM #PanelMembers
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT 1 FROM #PanelMembers WHERE PanelistId = 'undefined')
		BEGIN
			DECLARE @PanelistId INT
			SET @PanelistId = 0
			
			-- New Users insert query
			INSERT INTO DBO.MS_PanelMembers
			(PanelistName, CustomerId, LibId, LastUsed, IsActive, CategoryId)
			SELECT 
				LTRIM(RTRIM(PM.PanelistName)), CONVERT(INT,PM.CustomerId), CONVERT(INT,PM.LibId), GETDATE(), 1, CONVERT(INT,CategoryId)
			FROM #PanelMembers PM
			WHERE PM.PanelistId = 'undefined' 

			SET @PanelistId = @@IDENTITY
			
			SELECT CASE WHEN @PanelistId = 0 THEN 0 ELSE 1 END AS RetValue,
				CASE WHEN @PanelistId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,  
				@PanelistId AS PanelistId 
		END
		ELSE
		BEGIN
			-- Exist Panel Member update query	
			UPDATE MPM
			SET MPM.PanelistName = CASE WHEN ISNULL(PM.PanelistName,'') = '' THEN MPM.PanelistName ELSE LTRIM(RTRIM(PM.PanelistName)) END,
				MPM.CustomerId = CASE WHEN ISNULL(PM.CustomerId,'') = '' THEN MPM.CustomerId ELSE CONVERT(INT,PM.CustomerId) END,
				MPM.LibId = CASE WHEN ISNULL(PM.LibId,'') = '' THEN MPM.LibId ELSE CONVERT(INT,PM.LibId) END,
				MPM.LastUsed = GETDATE(), --CASE WHEN ISNULL(PM.LastUsed,'') = '' THEN GETDATE() ELSE CONVERT(DATETIME,PM.LastUsed,121) END,	
				MPM.IsActive = CASE WHEN LTRIM(RTRIM(PM.IsPanelActive)) = 'FALSE' THEN 0 ELSE 1 END 
			FROM DBO.MS_PanelMembers MPM
			INNER JOIN #PanelMembers PM
				ON MPM.PanelistId = CONVERT(INT,PM.PanelistId)
			WHERE PM.PanelistId <> 'undefined' 

			SELECT 1 AS RetValue, 'Successfully Updated' AS Remark, PanelistId AS PanelistId FROM #PanelMembers
		END
	END

	DROP TABLE #PanelMembers
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

