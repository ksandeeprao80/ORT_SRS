UPDATE MS_QuestionTypes 
SET QuestionCode = 'SingleChoice',
    QuestionName = 'Single Choice',
    SampleTemplate = 'SingleChoice_Sample.HTML',
    BlankTemplate = 'SingleChoice_Blank.HTML'
WHERE QuestionTypeId = 1  

GO

UPDATE MS_QuestionTypes 
SET QuestionCode = 'MultiSelect',
    QuestionName = 'Multi Select',
    SampleTemplate = 'MultiSelect_Sample.HTML',
    BlankTemplate = 'MultiSelect_Blank.HTML'
WHERE QuestionTypeId = 2

GO

UPDATE MS_QuestionTypes 
SET QuestionCode = 'TextInput',
    QuestionName = 'Text Input',
    SampleTemplate = 'TextInput_Sample.HTML',
    BlankTemplate = 'TextInput_Blank.HTML'
WHERE QuestionTypeId = 3

GO

UPDATE MS_QuestionTypes 
SET QuestionCode = 'PageBreak',
    QuestionName = 'Page Break',
    SampleTemplate = 'PageBreak_Sample.HTML',
    BlankTemplate = 'PageBreak_Blank.HTML'
WHERE QuestionTypeId = 4

GO 

INSERT INTO MS_QuestionTypes
(QuestionCode,QuestionName,SampleTemplate,BlankTemplate)
SELECT 'Boolean','Boolean','Boolean_Sample.HTML','Boolean_Blank.HTML'  
GO
INSERT INTO MS_QuestionTypes
SELECT 'DateInput','Date Input','DateInput_Sample.HTML','DateInput_Blank.HTML'   
GO
INSERT INTO MS_QuestionTypes
SELECT 'TimeInput','Time Input','TimeInput_Sample.HTML','TimeInput_Blank.HTML'  
GO
INSERT INTO MS_QuestionTypes
SELECT 'SliderInput','Slider Input','SliderInput_Sample.HTML','SliderInput_Blank.HTML' 
