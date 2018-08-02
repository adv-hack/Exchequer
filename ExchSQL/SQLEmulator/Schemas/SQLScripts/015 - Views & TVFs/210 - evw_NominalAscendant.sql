IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_NominalAscendant]'))
DROP VIEW [!ActiveSchema!].[evw_NominalAscendant]
GO

CREATE VIEW !ActiveSchema!.evw_NominalAscendant
AS
SELECT NominalCode = DescendantNominalCode
     , AscendantNominalCode = NominalCode
FROM   !ActiveSchema!.evw_NominalDescendant

GO