
INSERT INTO DBO.MS_Templates
(TemplateName,TemplateType,IsActive)
SELECT 'surveyEngine1.html','jpg',1
INSERT INTO DBO.MS_Templates
(TemplateName,TemplateType,IsActive)
SELECT 'surveyEngine2.html','jpg',1


INSERT INTO DBO.MS_TemplatesItems
(ItemName)
SELECT 'Header'
INSERT INTO DBO.MS_TemplatesItems
(ItemName)
SELECT 'Question'
INSERT INTO DBO.MS_TemplatesItems
(ItemName)
SELECT 'Answer'


INSERT INTO DBO.MS_Attributes
(AttributeName)
SELECT 'Font'
INSERT INTO DBO.MS_Attributes
(AttributeName)
SELECT 'Size'
INSERT INTO DBO.MS_Attributes
(AttributeName)
SELECT 'Color'



INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Header Font
SELECT 1,1,1,'Verdana' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Header Size
SELECT 1,1,2,'20px' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Header Color
SELECT 1,1,3,'#fff' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Question Font
SELECT 1,2,1,'Verdana' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Question Size
SELECT 1,2,2,'14px' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Question Color
SELECT 1,2,3,'#fff' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Answer Font
SELECT 1,3,1,'Verdana' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Answer Size
SELECT 1,3,2,'12px' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Answer Color
SELECT 1,3,3,'#191970' 

-- Template surveyEngine2.html
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Header Font
SELECT 2,1,1,'Verdana' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Header Size
SELECT 2,1,2,'20px' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Header Color
SELECT 2,1,3,'#093f78' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Question Font
SELECT 2,2,1,'Verdana' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Question Size
SELECT 2,2,2,'14px' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Question Color
SELECT 2,2,3,'#000' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Answer Font
SELECT 2,3,1,'Verdana' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Answer Size
SELECT 2,3,2,'14px' 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)-- Answer Color
SELECT 2,3,3,'#000' 
 