ALTER TABLE DBO.MS_PanelMembers ADD CategoryId INT

GO
UPDATE MPM
SET MPM.CategoryId = TPC.CategoryId
FROM DBO.MS_PanelMembers MPM
INNER JOIN DBO.TR_PanelCategory TPC
ON MPM.LibId = TPC.LibId

