IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_Nominal]'))
DROP VIEW [!ActiveSchema!].[evw_Nominal]
GO

CREATE VIEW !ActiveSchema!.evw_Nominal
AS
SELECT NominalId               = N.PositionId
     , NominalCode             = N.glCode
     , NominalName             = RTRIM(N.glName)
     , NominalTypeId           = NT.NominalTypeId
     , NominalTypeCode         = N.glType
     , NominalTypeDescription
     , ParentNominalId         = PAR.PositionId
     , ParentNominalCode       = PAR.glCode
     , PageBreakAtEnd          = N.glPage
     , SubtotalAtEnd           = N.glSubtotal
     , Revalue                 = N.glRevalue
     , IsInactive              = N.glInactive
     , NominalClassificationId
     , NominalClassificationCode
     , NominalClassificationDescription
     , CurrencyId              = N.glCurrency
     , AlternativeNominalCode  = N.glAltCode
     , HasChildren

     -- select *
FROM   !ActiveSchema!.NOMINAL N
JOIN   common.evw_NominalType           NT ON N.glType  = NT.NominalTypeCode COLLATE SQL_Latin1_General_CP1_CI_AS

LEFT JOIN common.evw_NominalClassification NC ON N.glClass = NC.NominalClassificationId
LEFT JOIN !ActiveSchema!.NOMINAL                  PAR ON N.glParent = PAR.glCode

CROSS APPLY ( SELECT HasChildren = CONVERT(BIT, ISNULL((SELECT TOP 1 1
                                                        FROM   [!ActiveSchema!].NOMINAL C
                                                        WHERE  N.glCode = C.glParent), 0))
            ) HC

GO
