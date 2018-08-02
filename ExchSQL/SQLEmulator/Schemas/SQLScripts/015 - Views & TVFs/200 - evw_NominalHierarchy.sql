IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_NominalHierarchy]'))
DROP VIEW [!ActiveSchema!].[evw_NominalHierarchy]
GO

CREATE VIEW !ActiveSchema!.evw_NominalHierarchy
AS
WITH NominalHierarchy ( ParentNominalId
                        , NominalId
                        , NominalCode
                        , NominalName
                        , NominalLevel
                        , NominalHierarchy
                        , SortSequence
                        )
  AS
  (
    SELECT ParentNominalId    = CONVERT(INT, NULL)
         , NominalId
         , NominalCode
         , NominalName
         , NominalLevel       = 0
         , NominalHierarchy   = CONVERT(NVARCHAR(100), '~' + CONVERT(VARCHAR(50), NominalCode) + '~')
         , SortSequence       = CONVERT(NVARCHAR(50), RIGHT('000' + CONVERT(NVARCHAR(50), ROW_NUMBER() OVER (ORDER BY NominalCode)), 3))

    FROM  !ActiveSchema!.evw_Nominal TopLevel
    WHERE ParentNominalCode IS NULL
    UNION ALL
    SELECT ParentNominalId  = AboveLevel.NominalId
         , NominalId        = ThisLevel.NominalId
         , NominalCode      = ThisLevel.NominalCode
         , NominalName      = ThisLevel.NominalName
         , NominalLevel     = AboveLevel.NominalLevel + 1
         , NominalHierarchy = CONVERT(NVARCHAR(100), AboveLevel.NominalHierarchy + CONVERT(NVARCHAR(50), ThisLevel.NominalCode) +'~' )
         , SortSequence     = CONVERT(NVARCHAR(50), AboveLevel.SortSequence + '.' + CONVERT(NVARCHAR(50), RIGHT('000' + CONVERT(NVARCHAR(50), ROW_NUMBER() OVER (ORDER BY AboveLevel.SortSequence, ThisLevel.NominalCode)), 3)))

    FROM  !ActiveSchema!.evw_Nominal ThisLevel
    JOIN  NominalHierarchy AboveLevel ON ThisLevel.ParentNominalCode = AboveLevel.NominalCode
                                     AND ThisLevel.ParentNominalCode IS NOT NULL
    )
SELECT *
FROM NominalHierarchy

GO