IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveRespondentReferrels]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveRespondentReferrels
GO 
/* 
EXEC UspSaveRespondentReferrels '<?xml version="1.0" encoding="utf-16"?>
<ArrayOfFriendViewModel>
	<FriendViewModel> 
		<RespondentId>1</RespondentId>
		<SurveyId>1212</SurveyId>
		<RefName></RefName>
		<RefMail>dias</RefMail>
		<RefPhoneNo>2222222</RefPhoneNo>
	</FriendViewModel>
	<FriendViewModel> 
		<RespondentId>1</RespondentId>
		<SurveyId>1212</SurveyId>
		<RefName>JOHNNY</RefName>
		<RefMail>dias</RefMail>
		<RefPhoneNo>2222222</RefPhoneNo>
	</FriendViewModel>
</ArrayOfFriendViewModel>'
*/  
CREATE PROCEDURE DBO.UspSaveRespondentReferrels
	@XmlData NTEXT
AS 
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	DECLARE @RowCount INT 

	--INSERT INTO TR_RespondentReferrels
	--(RespondentId, SurveyId, RefName, RefMail, RefPhoneNo)
	SELECT
		Child.Elm.value('(RespondentId)[1]','VARCHAR(20)') AS RespondentId,
		Child.Elm.value('(SurveyId)[1]','VARCHAR(30)') AS SurveyId,
		Child.Elm.value('(RefName)[1]','VARCHAR(150)') AS RefName,		
		Child.Elm.value('(RefMail)[1]','VARCHAR(20)') AS RefMail,
		Child.Elm.value('(RefPhoneNo)[1]','VARCHAR(150)') AS RefPhoneNo
	INTO #RespondentReferrels	
	FROM @input.nodes('/ArrayOfFriendViewModel') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('FriendViewModel') AS Child(Elm)
		
	INSERT INTO TR_RespondentReferrels
	(RespondentId, SurveyId, RefName, RefMail, RefPhoneNo)
	SELECT 
		RespondentId, SurveyId, RefName, RefMail, RefPhoneNo
	FROM #RespondentReferrels		
	WHERE ISNULL(RefName,'') <> ''

	SET @RowCount = @@ROWCOUNT
	
	SELECT CASE WHEN ISNULL(@RowCount,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN ISNULL(@RowCount,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark

	COMMIT TRAN

END TRY

BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END



