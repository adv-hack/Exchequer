IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_Stock]'))
DROP VIEW [!ActiveSchema!].[evw_Stock]
GO

CREATE VIEW [!ActiveSchema!].[evw_Stock]
AS

SELECT StockId                         = PositionId
     , StockCode                       = RTRIM(stCode) 
     , ParentStockCode                 = RTRIM(stParentCode)
     , AlternateStockCode              = RTRIM(stAltCode)
     , StockDescription1               = stDescLine1
     , StockDescription2               = stDescLine2
     , StockDescription3               = stDescLine3
     , StockDescription4               = stDescLine4
     , StockDescription5               = stDescLine5
     , StockDescription6               = stDescLine6
     , BarCode                         = stBarCode
     , BinLocation                     = stBinLocation
     , ImageFileName                   = stImageFile
     , TimeLastUpdated                 = stTimeChange
     , LastUsedDate                    = CONVERT(INT, stLastUsed)
     , UnitOfSaleDescription           = stUnitOfSale
     , UnitOfPurchaseDescription       = stUnitOfPurch
     , UnitOfStockDescription          = stUnitOfStock
     , FolioNumber                     = stFolioNum
     , UseKitPricing                   = stUseKitPrice
     , UseMultiBins                    = stMultiBinMode
     , WebCatalogue                    = stWebLiveCatalog
     , SalesNominalCode                = stNomCode1
     , CostOfSalesNominalCode          = stNomCode2
     , ClosingStockWriteOffNominalCode = stNomCode3
     , StockValueNominalCode           = stNomCode4
     , BoMFinishedGoodsNominalCode     = stNomCode5
     , WIPNominalCode                  = stWIPGL
     , SalesReturnNominalCode          = stSalesReturnGL
     , PurchaseReturnNominalCode       = stPurchaseReturnGL

     , StockType                       = stType
     , StockTypeDescription
     , ValuationMethod                 = CASE
                                         WHEN stSerNoWAvg = 1 THEN CONVERT(VARCHAR(3), 'RAC')
                                         ELSE CONVERT(VARCHAR(3), stValuationMethod)
                                         END
     , CostPriceCurrencyCode           = stCostPriceCurrency
     , DefaultLineType                 = stDefaultLineType
     , ManufacturerWarrantyType        = stManufacturerWarrantyType
     , SalesWarrantyType               = stSalesWarrantyType
     , PreferredSupplierCode           = stSupplier
     , JobAnalysisCode                 = stAnalysisCode
     , LocationCode                    = stLocation
     , VATCode                         = stVATCode
     , InclusiveVATCode                = stInclusiveVATCode
     , DepartmentCode                  = stDepartment
     , CostCentreCode                  = stCostCentre
     , CostPrice                       = stCostPrice
     , ReorderDate                     = stReorderDate
     , ReorderCurrencyCode             = stReorderCurrency
     , ReorderPrice                    = stReorderPrice
     , ReorderCostCentre               = stReorderCostCentre
     , ReorderDepartment               = stReorderDepartment
     , ShowQuantityAsPacks             = stShowQtyAsPacks
     , ShowKitOnSales                  = stShowKitOnSales
     , ShowKitOnPurchase               = stShowKitOnPurchase
     , SalesUnits                      = stSalesUnits
     , PurchaseUnits                   = stPurchaseUnits
     , QuantityInStock                 = stQtyInStock
     , QuantityPosted                  = stQtyPosted
     , QuantityAllocated               = stQtyAllocated
     , QuantityOnOrder                 = stQtyOnOrder
     , QuantityPicked                  = stQtyPicked
     , MinimumStock                    = stQtyMin
     , MaximumStock                    = stQtyMax
     , MinimumEconomicBuildQuantity    = stMinEccQty
     , SalesReturnedQuantity           = stSalesReturnQty
     , QuantityAllocatedToWOR          = stQTYAllocWOR
     , QuantityIssuedToWOR             = stQtyIssuedWOR
     , QuantityPickedWOR               = stQtyPickedWOR
     , BoMProductionTime               = stBOMProductionTime
     , ManufacturerWarrantyLength      = stManufacturerWarrantyLength
     , SalesWarrantyLength             = stSalesWarrantyLength
     , PurchaseReturnedQuantity        = stPurchaseReturnQty
     , ProductionTime                  = stProductionTime
     , RestockCharge                   = CASE stRestockPChr
                                         WHEN 0 THEN stRestockPercent
                                         ELSE NULL
                                         END
     , RestockChargePercent            = CASE stRestockPChr
                                         WHEN 1 THEN stRestockPercent
                                         ELSE NULL 
                                         END


     , BOMPrice                        = CASE
                                         WHEN stValuationMethod IN ('A', 'E') THEN stReorderPrice
                                         ELSE stCostPrice
                                         END
     , BOMPriceCurrency                = CASE
                                         WHEN stValuationMethod IN ('A', 'E') THEN stReorderCurrency
                                         ELSE stCostPriceCurrency
                                         END

FROM !ActiveSchema!.STOCK S
JOIN common.evw_StockType ST ON ST.StockTypeCode = S.stType COLLATE SQL_Latin1_General_CP437_BIN

GO


