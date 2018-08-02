/****** Object:  View [!ActiveSchema!].[evw_BillOfMaterials]    Script Date: 06/07/2015 12:56:57 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_BillOfMaterials]'))
DROP VIEW [!ActiveSchema!].[evw_BillOfMaterials]
GO

CREATE VIEW [!ActiveSchema!].[evw_BillOfMaterials]
AS
SELECT BOMPositionId          = BOM.PositionId
     , StockFolioNumber       = BOM.Exchqchkcode3Trans2
     , FullStockCode          = RTRIM(BOM.FullStkCode)
     , QuantityUsed           = BOM.QtyUsedTrans
     , QuantityUnitCost       = BOM.QtyCost
     , QuantityUnitCostInBase = common.efn_ExchequerCurrencyConvert( QtyCost
                                                                   , ConversionRate
                                                                   , QCurrency
                                                                   , 0
                                                                   , 0
                                                                   , C.TriRate
                                                                   , C.TriInverted
                                                                   , C.TriCurrencyCode
                                                                   , C.IsFloating
                                                                   )
     , QuantityTotalCost       = BOM.QtyCost * BOM.QtyUsedTrans
     , QuantityTotalCostInBase = common.efn_ExchequerCurrencyConvert( QtyCost * BOM.QtyUsedTrans
                                                                    , ConversionRate
                                                                    , QCurrency
                                                                    , 0
                                                                    , 0
                                                                    , C.TriRate
                                                                    , C.TriInverted
                                                                    , C.TriCurrencyCode
                                                                    , C.IsFloating
                                                                    )
     , QuantityCurrency   = BOM.QCurrency
     , IsFreeIssue        = BOM.FreeIssue
     , QuantityTime       = BOM.QtyTime

     , ParentBOMFolioNumber = Exchqchkcode1Trans5

FROM   !ActiveSchema!.EXCHQCHK BOM
LEFT JOIN !ActiveSchema!.CURRENCY C ON BOM.QCurrency = C.CurrencyCode
CROSS JOIN !ActiveSchema!.evw_SystemSettings SS 
CROSS APPLY ( VALUES ( (CASE
                        WHEN CurrencyCode IN (0, 1) THEN 1
                        WHEN UseCompanyRate = 1 THEN C.CompanyRate
                        WHEN UseDailyRate = 1 THEN C.DailyRate
                        END
                       )
                     )
            ) Rate (ConversionRate)
WHERE BOM.RecPfix = 'B'
AND   BOM.SubType = 77

GO


