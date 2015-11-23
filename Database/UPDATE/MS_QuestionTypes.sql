UPDATE DBO.MS_QuestionTypes SET QuestionCode = 'MultiChoice',QuestionName = 'MultiChoice'
WHERE QuestionTypeId = 2 AND QuestionCode LIKE '%Multi%'

UPDATE DBO.MS_QuestionTypes SET QuestionCode = 'Boolean',QuestionName = 'Boolean'
WHERE QuestionTypeId = 5 AND QuestionCode LIKE '%Boolean%'

UPDATE DBO.MS_QuestionTypes SET QuestionCode = 'WelcomePage',QuestionName = 'WelcomePage'
WHERE QuestionTypeId = 10 AND QuestionCode LIKE '%Welcome%'

UPDATE DBO.MS_QuestionTypes SET QuestionCode = 'ThankYouPage',QuestionName = 'ThankYouPage'
WHERE QuestionTypeId = 14 AND QuestionCode LIKE '%ThankYou%'
 