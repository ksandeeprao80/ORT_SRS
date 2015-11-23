--SELECT * FROM MS_Templates

SET IDENTITY_INSERT MS_Templates ON
--1

INSERT INTO DBO.MS_Templates
(TemplateId, TemplateName,TemplateType,IsActive)
SELECT 4, 'surveyEngine1_red.html','template1_red_new.jpg',1
--2
INSERT INTO DBO.MS_Templates
(TemplateId, TemplateName,TemplateType,IsActive)
SELECT 5, 'surveyEngine2_red.html','template2_red_new.jpg',1
--3
INSERT INTO DBO.MS_Templates
(TemplateId, TemplateName,TemplateType,IsActive)
SELECT 6, 'surveyEngine3_red.html','template3_red_new.jpg',1
 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)
SELECT 4, ItemId, AttributeId, Value FROM TR_Templates WHERE TemplateId = 1

INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)
SELECT 5, ItemId, AttributeId, Value FROM TR_Templates WHERE TemplateId = 2

INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)
SELECT 6, ItemId, AttributeId, Value FROM TR_Templates WHERE TemplateId = 3

SET IDENTITY_INSERT MS_Templates OFF

---- 20130417
--SELECT * FROM MS_Templates

SET IDENTITY_INSERT MS_Templates ON
--1

INSERT INTO DBO.MS_Templates
(TemplateId, TemplateName,TemplateType,IsActive)
SELECT 7, 'surveyEngine1_green.html','template1_green_new.jpg',1
--2
INSERT INTO DBO.MS_Templates
(TemplateId, TemplateName,TemplateType,IsActive)
SELECT 8, 'surveyEngine2_green.html','template2_green_new.jpg',1
--3
INSERT INTO DBO.MS_Templates
(TemplateId, TemplateName,TemplateType,IsActive)
SELECT 9, 'surveyEngine3_green.html','template3_green_new.jpg',1
 
 
INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)
SELECT 7, ItemId, AttributeId, Value FROM TR_Templates WHERE TemplateId = 1

INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)
SELECT 8, ItemId, AttributeId, Value FROM TR_Templates WHERE TemplateId = 2

INSERT INTO DBO.TR_Templates
(TemplateId, ItemId, AttributeId, Value)
SELECT 9, ItemId, AttributeId, Value FROM TR_Templates WHERE TemplateId = 3

SET IDENTITY_INSERT MS_Templates OFF