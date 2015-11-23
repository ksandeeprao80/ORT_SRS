IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveInviteLog]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveInviteLog]

GO
/*
EXEC UspSaveInviteLog '<?xml version="1.0" encoding="utf-16"?>
<ArrayOfMailData>
  <MailData>
    <InviteId>25</InviteId>
    <SurveyId>1240</SurveyId>
    <InternalPanelId>61</InternalPanelId>
    <PanelMemberId>3319</PanelMemberId>
    <PanelMemberEmailId>ksandee@gmail.com</PanelMemberEmailId>
    <InviteSubject>Test invite</InviteSubject>
    <InviteMessage>INACTIVE SURVEY</InviteMessage>
    <RowId>67</RowId>
    <IsSuccess>Y</IsSuccess>
    <IsSuccess>Y</IsSuccess> 
	<ErrorMessage></ErrorMessage>  
  </MailData>
  <MailData>
    <InviteId>26</InviteId>
    <SurveyId>1240</SurveyId>
    <InternalPanelId>61</InternalPanelId>
    <PanelMemberId>3319</PanelMemberId>
    <PanelMemberEmailId>ksandee@gmail.com</PanelMemberEmailId>
    <InviteSubject>Test invite</InviteSubject>
    <InviteMessage>INACTIVE SURVEY</InviteMessage>
    <RowId>68</RowId>
    <IsSuccess>Y</IsSuccess> 
	<ErrorMessage></ErrorMessage>  
  </MailData>
  <MailData>
    <InviteId>27</InviteId>
    <SurveyId>1240</SurveyId>
    <InternalPanelId>61</InternalPanelId>
    <PanelMemberId>3319</PanelMemberId>
    <PanelMemberEmailId>ksandee@gmail.com</PanelMemberEmailId>
    <InviteSubject>Test invite</InviteSubject>
    <InviteMessage>INACTIVE SURVEY</InviteMessage>
    <RowId>69</RowId>
    <IsSuccess>Y</IsSuccess> 
	<ErrorMessage></ErrorMessage>
  </MailData>
</ArrayOfMailData>'
*/
		
CREATE PROCEDURE DBO.UspSaveInviteLog
	@XMlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	
	SELECT
		Child.Elm.value('(InviteId)[1]','VARCHAR(20)') AS InviteId,
		Child.Elm.value('(SurveyId)[1]','VARCHAR(20)') AS SurveyId,
		Child.Elm.value('(InternalPanelId)[1]','VARCHAR(20)') AS InternalPanelId,
		Child.Elm.value('(PanelMemberId)[1]','VARCHAR(20)') AS PanelMemberId,
		Child.Elm.value('(PanelMemberEmailId)[1]','VARCHAR(50)') AS PanelMemberEmailId,
		Child.Elm.value('(InviteSubject)[1]','NVARCHAR(100)') AS InviteSubject,
		Child.Elm.value('(InviteMessage)[1]','NVARCHAR(MAX)') AS InviteMessage,
		Child.Elm.value('(RowId)[1]','VARCHAR(20)') AS RowId,
		Child.Elm.value('(IsSuccess)[1]','VARCHAR(1)') AS IsSuccess,
		Child.Elm.value('(ErrorMessage)[1]','NVARCHAR(500)') AS ErrorMessage
	INTO #InviteLog
	FROM @input.nodes('/ArrayOfMailData') AS Parent(Elm)
	CROSS APPLY 
		Parent.Elm.nodes('MailData') AS Child(Elm)	

	DECLARE @RowId INT
	DECLARE @CurrentDate DATETIME
	SET @RowId = 0
	SET @CurrentDate = GETDATE()
	
	INSERT INTO DBO.TR_InviteLog
	(
		InviteId, SurveyId, InternalPanelId, PanelMemberId, PanelMemberEmailId, InviteSubject,
		InviteMessage, RowId, SentDate, IsSuccess, ErrorMessage
	)
	SELECT 
		CONVERT(INT,InviteId), CONVERT(INT,SurveyId), CONVERT(INT,InternalPanelId), CONVERT(INT,PanelMemberId), 
		PanelMemberEmailId, InviteSubject, InviteMessage, CONVERT(INT,RowId), @CurrentDate,
		LEFT(IsSuccess,1), ErrorMessage
	FROM #InviteLog
	
	SET @RowId = @@ROWCOUNT
		
	IF @RowId <> 0 
	BEGIN	
		IF EXISTS(SELECT 1 FROM #InviteLog WHERE LTRIM(RTRIM(IsSuccess)) = 'Y')
		BEGIN
			UPDATE TI
			SET TI.SentDate = @CurrentDate,
				TI.Locked = NULL
			FROM DBO.TR_Invite TI
			INNER JOIN #InviteLog IL
				ON TI.RowId = CONVERT(INT,IL.RowId)
				AND LTRIM(RTRIM(IL.IsSuccess)) = 'Y'
			
			UPDATE TID
			SET TID.SentDate = @CurrentDate,
				TID.Locked = NULL
			FROM DBO.TR_InviteDetails TID
			INNER JOIN #InviteLog IL
				ON TID.RowId = CONVERT(INT,IL.RowId)
				AND LTRIM(RTRIM(IL.IsSuccess)) = 'Y'
		END
	END
		
	SELECT 
		CASE WHEN ISNULL(@RowId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Update Failed' ELSE 'Successfully Updated' END AS Remark
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END



