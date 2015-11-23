IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyForReports]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyForReports]

GO
/*
-- EXEC UspGetSurveyForReports NULL,NULL,'<?xml version="1.0" encoding="utf-16"?>
<User>
  <UserId>5</UserId>
  <UserName>Nilesh More</UserName>
  <UserDetails>
    <IsActive>false</IsActive>
    <Customer>
      <CustomerId>1</CustomerId>
      <IsActive>false</IsActive>
    </Customer>
    <UserRole>
      <RoleId>1</RoleId>
      <RoleDesc>Group User</RoleDesc>
      <Hierarchy>1</Hierarchy>
    </UserRole>
  </UserDetails>
</User>','<?xml version="1.0" encoding="utf-16"?>
<PageModel>
  <Page>1</Page>
  <Start>0</Start>
  <Limit>5</Limit>
  <SortBy>
    <SortModel>
      <Property>SurveyName</Property>
      <Direction>DESC</Direction>
    </SortModel>
    <SortModel>
      <property>Responses</property>
      <direction>ASC</direction>
    </SortModel>
     <SortModel>
      <Property>SurveyId</Property>
      <Direction>ASC</Direction>
    </SortModel>
  </SortBy>
</PageModel>'
*/
CREATE PROCEDURE DBO.UspGetSurveyForReports
	@SurveyId INT = NULL,
	@CustomerId INT = NULL,
	@XmlUserInfo AS NTEXT,
	@PageData AS NTEXT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SU','GU','SA'))
	BEGIN
		SELECT 
			TS.SurveyId, TS.SurveyName, TS.CustomerId, ISNULL(TR1.Responses,0) AS Responses, 0 AS RequiredSamples, 
			TS.StarMarked, TS.RewardEnabled, TS.CreatedBy, CONVERT(VARCHAR(10),TS.CreatedDate,101) AS CreatedDate,
			ISNULL(TS.ModifiedBy,0) AS ModifiedBy, CONVERT(VARCHAR(10),TS.ModifiedDate,101) AS ModifiedDate,
			CASE WHEN ISNULL(TS.IsActive,0) = 0 THEN 'False' ELSE 'True' END AS IsActive,
			TS.StatusId, MSS.SurveyStatusName, TS.CategoryId, TS.LanguageId, ML.LangauageName AS LanguageDesc,
			CASE WHEN CONVERT(VARCHAR(10),TS.SurveyEndDate,101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(10),TS.SurveyEndDate,101) END AS SurveyEndDate,
			1 AS RetValue, ISNULL(CONVERT(VARCHAR(10),APS.PublishedDate,101),'') AS PublishedDate
		FROM DBO.TR_Survey TS
		INNER JOIN DBO.MS_SurveyStatus MSS
			ON TS.StatusId = MSS.StatusId
			AND TS.SurveyId = ISNULL(@SurveyId,TS.SurveyId)
			AND TS.StatusId IN(1,2)
		INNER JOIN @UserInfo UI
			ON TS.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TS.CustomerId ELSE CONVERT(INT,UI.CustomerId) END) 
			AND TS.CreatedBy = (CASE WHEN UI.RoleDesc IN ('SA','GU') THEN TS.CreatedBy ELSE CONVERT(INT,UI.UserId) END)
		LEFT OUTER JOIN DBO.MS_Languages ML
			ON TS.LanguageId = ML.LanguageId	
		LEFT OUTER JOIN
		(
			SELECT 
				COUNT(1) AS Responses, RCNT.SurveyId, RCNT.CustomerId
			FROM 
			(	
				SELECT 
					DISTINCT TSQ.SurveyId, TSQ.CustomerId,
					CASE WHEN TR.RespondentId > 0 THEN CONVERT(VARCHAR(12),RespondentId) ELSE TR.SessionId END AS SessionId 
				FROM DBO.TR_Responses TR
				INNER JOIN DBO.TR_SurveyQuestions TSQ
					ON TR.QuestionId = TSQ.QuestionId AND TSQ.IsDeleted = 1 
					AND TSQ.SurveyId = ISNULL(@SurveyId,TSQ.SurveyId) AND TR.[Status] = 'C'
				INNER JOIN @UserInfo UI
					ON TSQ.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TSQ.CustomerId ELSE CONVERT(INT,UI.CustomerId) END) 
			) RCNT
			GROUP BY RCNT.SurveyId, RCNT.CustomerId
		) TR1
			ON TS.SurveyId = TR1.SurveyId
			AND TS.CustomerId = TR1.CustomerId
		LEFT JOIN 
		(
			SELECT SurveyId, MAX(PublishedDate) AS PublishedDate
			FROM DBO.Audit_PublishSurvey 
			WHERE SurveyId = ISNULL(@SurveyId,SurveyId)
			GROUP BY SurveyId 
		) APS
			ON TS.SurveyId = APS.SurveyId	
		WHERE ISNULL(TR1.Responses,0) <> 0
		ORDER BY TS.SurveyId DESC		
 	END
	ELSE
	BEGIN
		SELECT 0 AS RetValue, 'Access Denied' AS Remark
	END


END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END