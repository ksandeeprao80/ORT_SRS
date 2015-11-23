IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptRemoveReportFilterMap]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptRemoveReportFilterMap]
GO
 
 
--EXEC UspRptRemoveReportFilterMap 

CREATE PROCEDURE DBO.UspRptRemoveReportFilterMap
	@ReportId INT,
	@FilterId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DECLARE @Count INT
    DECLARE @PREVRECDOUNT INT
    DECLARE @NEXTMAPID INT
    DECLARE @CURRENTMAPID INT
    
    --logic has been impletemeted below to update the conjuction of the next mapid 
    --if there are previous maps then conjution is not updated, if there are no previous map with respect to current map then next map id conjustion
    --is updated as blank
    
    SELECT @CURRENTMAPID = MAPID FROM DBO.TR_ReportFilterMapping WHERE ReportId = @ReportId AND FilterId = @FilterId
    
    SELECT @PREVRECDOUNT = COUNT(1) FROM dbo.TR_ReportFilterMapping WHERE MAPID < @CURRENTMAPID AND ReportId = @ReportId


	DELETE FROM DBO.TR_ReportFilterMapping WHERE ReportId = @ReportId AND FilterId = @FilterId
	
	SELECT @NEXTMAPID = MIN ( mapid) FROM TR_ReportFilterMapping WHERE ReportId = @ReportId AND  MAPID > @CURRENTMAPID
	
	SELECT @Count = COUNT(1) FROM TR_ReportFilterMapping WHERE ReportId = @ReportId
	
	IF @Count = 1
	BEGIN
	    UPDATE TR_ReportFilterMapping SET Conjuction = '' WHERE ReportId = @ReportId
	END
	
	IF @PREVRECDOUNT = 0
	BEGIN
	   UPDATE TR_ReportFilterMapping SET Conjuction = '' WHERE mapid = @NEXTMAPID
	END
	
	
	
	SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
 