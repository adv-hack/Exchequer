
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_NominalDescendant]'))
DROP VIEW [!ActiveSchema!].[evw_NominalDescendant]
GO

CREATE VIEW !ActiveSchema!.evw_NominalDescendant
AS
SELECT NominalCode
     , DescendantNominalCode
FROM !ActiveSchema!.evw_Nominal N
CROSS APPLY ( (SELECT NominalCode
               FROM !ActiveSchema!.evw_NominalHierarchy NH
               WHERE NH.NominalHierarchy LIKE '%~' + CONVERT(VARCHAR(50), N.NominalCode) + '~%')
               ) NA (DescendantNominalCode)
GO
