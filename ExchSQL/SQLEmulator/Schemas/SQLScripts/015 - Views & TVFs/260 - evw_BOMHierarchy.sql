IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_BOMHierarchy]'))
DROP VIEW [!ActiveSchema!].[evw_BOMHierarchy]
GO

CREATE VIEW !ActiveSchema!.evw_BOMHierarchy
AS
WITH BOMData
   ( BOMStockFolioNumber
   , BOMStockCode
   , BOMHierarchy
   , BOMLevel
   , BOMCurrency
   , BOMQuantity
   , BOMCost
   , BOMCostInBase
   )
AS
(
SELECT BOMStockFolioNumber = BOM.stFolioNum
     , BOMStockCode        = RTRIM(BOM.stCode)
     , BOMHierarchy        = CONVERT(VARCHAR(max), RTRIM(BOM.stCode)) + '~'
     , BOMLevel            = 0
     , BOMCurrency         = BOM.stCostPriceCurrency
     , BOMQuantity         = CONVERT(float, 1)
     , BOMCost             = BOM.stCostPrice

     , BOMCostInBase       = common.efn_ExchequerCurrencyConvert( stCostPrice
                                                                , ConversionRate
                                                                , stCostPriceCurrency
                                                                , 0
                                                                , 0
                                                                , C.TriRate
                                                                , C.TriInverted
                                                                , C.TriCurrencyCode
                                                                , C.IsFloating
                                                                )

FROM   !ActiveSchema!.STOCK BOM
LEFT JOIN !ActiveSchema!.CURRENCY C ON BOM.stCostPriceCurrency = C.CurrencyCode
CROSS JOIN !ActiveSchema!.evw_SystemSettings SS 
CROSS APPLY ( VALUES ( (CASE
                        WHEN CurrencyCode IN (0, 1) THEN 1
                        WHEN UseCompanyRate = 1 THEN C.CompanyRate
                        WHEN UseDailyRate = 1 THEN C.DailyRate
                        END
                       )
                     )
            ) Rate (ConversionRate)
WHERE  stType = 'M'
UNION ALL
SELECT BOMStockFolioNumber  = BD.StockFolioNumber
     , BOMStockCode         = BD.FullStockCode
     , BOMHierarchy         = AboveLevel.BOMHierarchy + RTRIM(BD.FullStockCode) + '~'
     , BOMLevel             = AboveLevel.BOMLevel + 1
     , BOMCurrency          = BD.QuantityCurrency
     , BOMQuantity          = BD.QuantityUsed
     , BOMCost              = BD.QuantityTotalCost
     , BOMCostInBase        = BD.QuantityTotalCostInBase

FROM BOMData AboveLevel  
JOIN !ActiveSchema!.evw_BillOfMaterials BD ON AboveLevel.BOMStockFolioNumber = BD.ParentBOMFolioNumber

)
SELECT *
FROM   BOMData

GO