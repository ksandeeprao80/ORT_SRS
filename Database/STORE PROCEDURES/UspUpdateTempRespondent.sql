IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspUpdateTempRespondent]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspUpdateTempRespondent
GO
/*  
EXEC UspUpdateTempRespondent '<?xml version="1.0" encoding="utf-16"?>
<ArrayOfRespondent>
  <Respondent>
    <Panel>
      <PanelId>2</PanelId>
      <LastUsed>0001-01-01T00:00:00</LastUsed>
      <IsPanelActive>false</IsPanelActive>
    </Panel>
    <FirstName>Nilesh</FirstName>
    <LastName>More</LastName>
    <Gender>M</Gender>
    <Age>28</Age>
    <BirthDate>2/5/1984</BirthDate>
    <Town>Thane</Town>
    <RespondentEmailId>nilesh@winsoftech.com</RespondentEmailId>
    <UserDefineColumn1>Test</UserDefineColumn1>
    <UserDefineColumn2>Test</UserDefineColumn2>
    <UserDefineColumn3>Test</UserDefineColumn3>
    <UserDefineColumn4>Test</UserDefineColumn4>
    <UserDefineColumn5>Test</UserDefineColumn5>
    <IsRespondentDeleted>false</IsRespondentDeleted>
    <IsRespondentActive>false</IsRespondentActive>
    <Customer>
      <CustomerId>1</CustomerId>
      <IsActive>false</IsActive>
    </Customer>
    <CreatedBy>
      <UserId>5</UserId>
    </CreatedBy>
    <TempId>141</TempId>
    <Status>O</Status>
    <StatusMessage>Success</StatusMessage>
    <SessionId>
      <SessionId>144</SessionId>
    </SessionId>
  </Respondent>
  <Respondent>
    <Panel>
      <PanelId>2</PanelId>
      <LastUsed>0001-01-01T00:00:00</LastUsed>
      <IsPanelActive>false</IsPanelActive>
    </Panel>
    <FirstName>Johnny</FirstName>
    <LastName>Dias</LastName>
    <Gender>M</Gender>
    <Age>29</Age>
    <BirthDate>5/5/1983</BirthDate>
    <Town>Kalyan</Town>
    <RespondentEmailId>johnnyD@winsoftech.com</RespondentEmailId>
    <UserDefineColumn1>Test</UserDefineColumn1>
    <UserDefineColumn2>Test</UserDefineColumn2>
    <UserDefineColumn3>Test</UserDefineColumn3>
    <UserDefineColumn4>Test</UserDefineColumn4>
    <UserDefineColumn5>Test</UserDefineColumn5>
    <IsRespondentDeleted>false</IsRespondentDeleted>
    <IsRespondentActive>false</IsRespondentActive>
    <Customer>
      <CustomerId>1</CustomerId>
      <IsActive>false</IsActive>
    </Customer>
    <CreatedBy>
      <UserId>5</UserId>
    </CreatedBy>
    <TempId>142</TempId>
    <Status>O</Status>
    <StatusMessage>Success</StatusMessage>
    <SessionId>
      <SessionId>144</SessionId>
    </SessionId>
  </Respondent>
  <Respondent>
    <Panel>
      <PanelId>2</PanelId>
      <LastUsed>0001-01-01T00:00:00</LastUsed>
      <IsPanelActive>false</IsPanelActive>
    </Panel>
    <FirstName>Sachin</FirstName>
    <LastName>Ghanekar</LastName>
    <Gender>M</Gender>
    <BirthDate />
    <Town>Mulund</Town>
    <RespondentEmailId>SachinG@winsoftech.com</RespondentEmailId>
    <UserDefineColumn1>Test</UserDefineColumn1>
    <UserDefineColumn2>Test</UserDefineColumn2>
    <UserDefineColumn3>Test</UserDefineColumn3>
    <UserDefineColumn4>Test</UserDefineColumn4>
    <UserDefineColumn5>Test</UserDefineColumn5>
    <IsRespondentDeleted>false</IsRespondentDeleted>
    <IsRespondentActive>false</IsRespondentActive>
    <Customer>
      <CustomerId>1</CustomerId>
      <IsActive>false</IsActive>
    </Customer>
    <CreatedBy>
      <UserId>5</UserId>
    </CreatedBy>
    <TempId>143</TempId>
    <Status>E</Status>
    <StatusMessage>Invalid BirthDate. </StatusMessage>
    <SessionId>
      <SessionId>144</SessionId>
    </SessionId>
  </Respondent>
  <Respondent>
    <Panel>
      <PanelId>2</PanelId>
      <LastUsed>0001-01-01T00:00:00</LastUsed>
      <IsPanelActive>false</IsPanelActive>
    </Panel>
    <FirstName>Anish02</FirstName>
    <LastName>Khan##</LastName>
    <Gender>M</Gender>
    <Age>29</Age>
    <BirthDate>5/5/1983</BirthDate>
    <Town>Bhandup</Town>
    <RespondentEmailId>AnishK@winsoftech.com</RespondentEmailId>
    <UserDefineColumn1>Test</UserDefineColumn1>
    <UserDefineColumn2>Test</UserDefineColumn2>
    <UserDefineColumn3>Test</UserDefineColumn3>
    <UserDefineColumn4>Test</UserDefineColumn4>
    <UserDefineColumn5>Test</UserDefineColumn5>
    <IsRespondentDeleted>false</IsRespondentDeleted>
    <IsRespondentActive>false</IsRespondentActive>
    <Customer>
      <CustomerId>1</CustomerId>
      <IsActive>false</IsActive>
    </Customer>
    <CreatedBy>
      <UserId>5</UserId>
    </CreatedBy>
    <TempId>144</TempId>
    <Status>E</Status>
    <StatusMessage>Invalid First Name. Invalid Last Name. </StatusMessage>
    <SessionId>
      <SessionId>144</SessionId>
    </SessionId>
  </Respondent>
</ArrayOfRespondent>'  
*/  
  
CREATE PROCEDURE DBO.UspUpdateTempRespondent  
	@XmlData AS NTEXT  
AS  
SET NOCOUNT ON  
BEGIN  
BEGIN TRY  

	BEGIN TRAN  
  
	DECLARE @input XML = @XmlData  
	SELECT  
		Child3.Elm.value('(PanelId)[1]','VARCHAR(20)') AS 'PanelId',  
		Child3.Elm.value('(LastUsed)[1]','VARCHAR(50)') AS 'LastUsed', 
		Child3.Elm.value('(IsPanelActive)[1]','VARCHAR(20)') AS 'IsPanelActive',  
		Child.Elm.value('(FirstName)[1]','VARCHAR(50)') AS 'FirstName',  
		Child.Elm.value('(LastName)[1]','VARCHAR(50)') AS 'LastName',  
		Child.Elm.value('(Gender)[1]','VARCHAR(50)') AS 'Gender',  
		Child.Elm.value('(Age)[1]','VARCHAR(50)') AS 'Age',  
		Child.Elm.value('(BirthDate)[1]','VARCHAR(50)') AS 'BirthDate',  
		Child.Elm.value('(Town)[1]','VARCHAR(50)') AS 'Town',  
		Child.Elm.value('(RespondentEmailId)[1]','VARCHAR(50)') AS 'EmailId',  
		Child.Elm.value('(UserDefineColumn1)[1]','VARCHAR(50)') AS 'UDF1',  
		Child.Elm.value('(UserDefineColumn2)[1]','VARCHAR(50)') AS 'UDF2',  
		Child.Elm.value('(UserDefineColumn3)[1]','VARCHAR(50)') AS 'UDF3',  
		Child.Elm.value('(UserDefineColumn4)[1]','VARCHAR(50)') AS 'UDF4',  
		Child.Elm.value('(UserDefineColumn5)[1]','VARCHAR(50)') AS 'UDF5',  
		Child.Elm.value('(IsRespondentDeleted)[1]','VARCHAR(50)') AS 'IsRespondentDeleted',  
		Child.Elm.value('(IsRespondentActive)[1]','VARCHAR(50)') AS 'IsRespondentActive',  
		Child4.Elm.value('(CustomerId)[1]','VARCHAR(50)') AS 'CustomerId',   
		Child4.Elm.value('(IsActive)[1]','VARCHAR(20)') AS 'IsActive',  
		Child1.Elm.value('(UserId)[1]','VARCHAR(20)') AS 'UserId',  
		Child.Elm.value('(TempId)[1]','VARCHAR(20)') AS 'TempId',  
		Child.Elm.value('(Status)[1]','VARCHAR(20)') AS 'Status',  
		Child.Elm.value('(StatusMessage)[1]','VARCHAR(150)') AS 'StatusMessage',  
		Child2.Elm.value('(SessionId)[1]','VARCHAR(50)') AS 'SessionId'   
	INTO #Respondent  
	FROM @input.nodes('/ArrayOfRespondent') AS Parent(Elm)  
	CROSS APPLY  
		Parent.Elm.nodes('Respondent') AS Child(Elm)  
	CROSS APPLY  
		Child.Elm.nodes('CreatedBy') AS Child1(Elm)  
	CROSS APPLY  
		Child.Elm.nodes('SessionId') AS Child2(Elm)  
	CROSS APPLY  
		Child.Elm.nodes('Panel') AS Child3(Elm)  
	CROSS APPLY  
		Child.Elm.nodes('Customer') AS Child4(Elm)  
  
	UPDATE TR  
	SET TR.CustomerId = R.CustomerId,  
	    TR.PanelistId = R.PanelId,   
	    TR.Age = CONVERT(INT,R.Age),  
	    TR.SessionId = R.SessionId,  
	    TR.UserId = R.UserId,  
	    TR.Status = R.Status,  
	    TR.StatusMessage= R.StatusMessage  
	FROM DBO.TempRespondent TR  
	INNER JOIN #Respondent R  
		ON TR.TempId = R.TempId  
  
	DECLARE @SessionId VARCHAR(50)  
	DECLARE @TotalCount INT  
	DECLARE @TotalExceptionCount INT  
	DECLARE @TotalInsertCount INT  
	
	SET @TotalCount = 0  
	SET @TotalInsertCount = 0  
	SET @TotalExceptionCount = 0  
	SELECT @SessionId = SessionId FROM #Respondent   
  
	UPDATE TR
	SET TR.Status = 'E',  
	    TR.StatusMessage = 'Duplicate EmailId Found Within FileList'
	FROM DBO.TempRespondent TR 
	INNER JOIN
	( 
		SELECT EmailId, SessionId, COUNT(1) AS Duplicate 
		FROM DBO.TempRespondent  
		WHERE SessionId = @SessionId  
			AND [Status] = 'O'   
		GROUP BY SessionId, EmailId 
		HAVING COUNT(1) > 1  
	) TR1
		ON TR.EmailId = TR1.EmailId
		AND TR.SessionId = TR1.SessionId
		AND TR.SessionId = @SessionId  
			AND TR.[Status] = 'O'
			
	UPDATE TR  
	SET TR.Status = 'E',  
	    TR.StatusMessage = 'Duplicate EmailId Found In Panelist : '+MPM.PanelistName  
	FROM DBO.TempRespondent TR   
	INNER JOIN DBO.MS_Respondent MR  
		ON TR.EmailId = MR.EmailId 
		AND TR.CustomerId = MR.CustomerId 
	INNER JOIN DBO.MS_PanelMembers MPM  
		ON MR.PanelistId = MPM.PanelistId 		
			
	UPDATE TR
	SET TR.Status = 'O',  
	    TR.StatusMessage = NULL
	FROM DBO.TempRespondent TR 
	INNER JOIN
	( 
		SELECT MIN(TempId) AS TempId, EmailId, SessionId
		FROM DBO.TempRespondent  
		WHERE SessionId = @SessionId  
			AND [Status] = 'E'   
			AND StatusMessage = 'Duplicate EmailId Found Within FileList'
		GROUP BY SessionId, EmailId 
	) TR1
		ON TR.TempId = TR1.TempId
			
	SELECT @TotalCount = COUNT(1) FROM DBO.TempRespondent WHERE SessionId = @SessionId  
	SELECT @TotalExceptionCount = COUNT(1) FROM DBO.TempRespondent WHERE SessionId = @SessionId AND Status = 'E'  
	SELECT @TotalInsertCount = COUNT(1) FROM DBO.TempRespondent WHERE SessionId = @SessionId AND Status = 'O'  
	
	SELECT 1 AS RetValue, 'Successfully Inserted/Updated' AS Remark, @SessionId AS SessionId,  
	ISNULL(@TotalCount,0) AS TotalCount, ISNULL(@TotalExceptionCount,0) AS TotalExceptionCount,   
	ISNULL(@TotalInsertCount,0) AS TotalInsertCount   
	
	COMMIT TRAN  
  
END TRY    
    
BEGIN CATCH  
	ROLLBACK TRAN  
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark  
END CATCH   
  
SET NOCOUNT OFF  
END 

