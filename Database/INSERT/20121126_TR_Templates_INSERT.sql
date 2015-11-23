--SELECT * FROM dbo.MS_Templates 
DECLARE @TemplateId INT
INSERT INTO dbo.MS_Templates 
(TemplateName,TemplateType,IsActive)
SELECT 'surveyEngine3.html','jpg',1
SET @TemplateId = @@IDENTITY

INSERT INTO dbo.TR_Templates
(TemplateId,ItemId,AttributeId,Value)
SELECT @TemplateId,1,1,'Verdana' UNION-- Header Font  
SELECT @TemplateId,1,2,'20px'  UNION-- Header Size
SELECT @TemplateId,1,3, '#fff'  UNION-- Header Color

SELECT @TemplateId,2,1,'Verdana'  UNION-- Question Font  
SELECT @TemplateId,2,2,'14px'  UNION-- Question Size
SELECT @TemplateId,2,3, '#fff'  UNION-- Question Color

SELECT @TemplateId,3,1,'Verdana'  UNION-- Answer Font  
SELECT @TemplateId,3,2,'14px'  UNION-- Answer Size
SELECT @TemplateId,3,3, '#000' -- Answer Color
 
 
 
 
