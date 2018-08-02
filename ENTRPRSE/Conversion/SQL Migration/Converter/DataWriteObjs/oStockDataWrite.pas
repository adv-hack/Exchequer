Unit oStockDataWrite;

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TStockDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    stCodeParam, stDescLine1Param, stDescLine2Param, stDescLine3Param, 
    stDescLine4Param, stDescLine5Param, stDescLine6Param, stAltCodeParam, 
    stSuppTempParam, stNomCode1Param, stNomCode2Param, stNomCode3Param, 
    stNomCode4Param, stNomCode5Param, stReorderFlagParam, stMinReorderFlagParam, 
    stFolioNumParam, stParentCodeParam, stTypeParam, stUnitOfStockParam, 
    stUnitOfSaleParam, stUnitOfPurchParam, stCostPriceCurrencyParam, stCostPriceParam, 
    stSalesBand1CurrencyParam, stSalesBand1PriceParam, stSalesBand2CurrencyParam, 
    stSalesBand2PriceParam, stSalesBand3CurrencyParam, stSalesBand3PriceParam, 
    stSalesBand4CurrencyParam, stSalesBand4PriceParam, stSalesBand5CurrencyParam, 
    stSalesBand5PriceParam, stSalesBand6CurrencyParam, stSalesBand6PriceParam, 
    stSalesBand7CurrencyParam, stSalesBand7PriceParam, stSalesBand8CurrencyParam, 
    stSalesBand8PriceParam, stSalesBand9CurrencyParam, stSalesBand9PriceParam, 
    stSalesBand10CurrencyParam, stSalesBand10PriceParam, stSalesUnitsParam, 
    stPurchaseUnitsParam, stSpare1Param, stVATCodeParam, stDepartmentParam, 
    stCostCentreParam, stQtyInStockParam, stQtyPostedParam, stQtyAllocatedParam, 
    stQtyOnOrderParam, stQtyMinParam, stQtyMaxParam, stReOrderQtyParam,
    stNLineCountParam, stSubAssemblyFlagParam, stShowKitOnSalesParam, stBLineCountParam, 
    stSSDCommodityCodeParam, stSSDSalesUnitWeightParam, stSSDPurchaseUnitWeightParam, 
    stSSDUnitDescParam, stSSDStockUnitsParam, stBinLocationParam, stStockTakeFlagParam, 
    stCoverPeriodsParam, stCoverPeriodUnitsParam, stCoverMinPeriodsParam, 
    stCoverMinPeriodUnitsParam, stSupplierParam, stQtyFreezeParam, stCoverQtySoldParam, 
    stUseCoverParam, stCoverMaxPeriodsParam, stCoverMaxPeriodUnitsParam, 
    stReorderCurrencyParam, stReorderPriceParam, stReorderDateParam, stQtyStockTakeParam, 
    stValuationMethodParam, stHasSerialNoParam, stQtyPickedParam, stLastUsedParam, 
    stCalcPackParam, stAnalysisCodeParam, stUserField1Param, stUserField2Param, 
    stBarCodeParam, stReorderDepartmentParam, stReorderCostCentreParam,
    stLocationParam, stPriceByPackParam, stShowQtyAsPacksParam, stUseKitPriceParam, 
    stShowKitOnPurchaseParam, stDefaultLineTypeParam, stSalesReturnQtyParam, 
    stQtyAllocWORParam, stQtyIssuedWORParam, stUseForEbusParam, stWebLiveCatalogParam, 
    stWebPrevCatalogParam, stUserField3Param, stUserField4Param, stSerNoWAvgParam, 
    stSizeColParam, stSSDDespatchUpliftParam, stSSDCountryParam, stTimeChangeParam, 
    stInclusiveVATCodeParam, stSSDArrivalUpliftParam, stPrivateRecParam, 
    stOperatorParam, stImageFileParam, stTempBLocParam, stQtyPickedWORParam, 
    stWIPGLParam, stProductionTimeParam, stLeadTimeParam, stCalcProductionTimeParam, 
    stBOMProductionTimeParam, stMinEccQtyParam, stMultiBinModeParam, stSalesWarrantyLengthParam, 
    stSalesWarrantyTypeParam, stManufacturerWarrantyLengthParam, stManufacturerWarrantyTypeParam, 
    stPurchaseReturnQtyParam, stSalesReturnGLParam, stRestockPercentParam, 
    stRestockGLParam, BOMDedCompParam, stPurchaseReturnGLParam, stRestockPChrParam, 
    stLastStockTypeParam, stUserField5Param, stUserField6Param, stUserField7Param, 
    stUserField8Param, stUserField9Param, stUserField10Param, stIsServiceParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TStockDataWrite

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

//=========================================================================

Constructor TStockDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TStockDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TStockDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].Stock (' + 
                                            'stCode, ' + 
                                            'stDescLine1, ' + 
                                            'stDescLine2, ' + 
                                            'stDescLine3, ' +
                                            'stDescLine4, ' + 
                                            'stDescLine5, ' +
                                            'stDescLine6, ' + 
                                            'stAltCode, ' + 
                                            'stSuppTemp, ' + 
                                            'stNomCode1, ' + 
                                            'stNomCode2, ' + 
                                            'stNomCode3, ' + 
                                            'stNomCode4, ' + 
                                            'stNomCode5, ' + 
                                            'stReorderFlag, ' + 
                                            'stMinReorderFlag, ' + 
                                            'stFolioNum, ' + 
                                            'stParentCode, ' + 
                                            'stType, ' + 
                                            'stUnitOfStock, ' + 
                                            'stUnitOfSale, ' + 
                                            'stUnitOfPurch, ' +
                                            'stCostPriceCurrency, ' + 
                                            'stCostPrice, ' + 
                                            'stSalesBand1Currency, ' + 
                                            'stSalesBand1Price, ' + 
                                            'stSalesBand2Currency, ' + 
                                            'stSalesBand2Price, ' + 
                                            'stSalesBand3Currency, ' + 
                                            'stSalesBand3Price, ' + 
                                            'stSalesBand4Currency, ' + 
                                            'stSalesBand4Price, ' + 
                                            'stSalesBand5Currency, ' + 
                                            'stSalesBand5Price, ' + 
                                            'stSalesBand6Currency, ' + 
                                            'stSalesBand6Price, ' + 
                                            'stSalesBand7Currency, ' + 
                                            'stSalesBand7Price, ' + 
                                            'stSalesBand8Currency, ' + 
                                            'stSalesBand8Price, ' + 
                                            'stSalesBand9Currency, ' +
                                            'stSalesBand9Price, ' + 
                                            'stSalesBand10Currency, ' + 
                                            'stSalesBand10Price, ' + 
                                            'stSalesUnits, ' + 
                                            'stPurchaseUnits, ' + 
                                            'stSpare1, ' + 
                                            'stVATCode, ' + 
                                            'stDepartment, ' + 
                                            'stCostCentre, ' + 
                                            'stQtyInStock, ' + 
                                            'stQtyPosted, ' +
                                            'stQtyAllocated, ' + 
                                            'stQtyOnOrder, ' + 
                                            'stQtyMin, ' + 
                                            'stQtyMax, ' + 
                                            'stReOrderQty, ' +
                                            'stNLineCount, ' + 
                                            'stSubAssemblyFlag, ' + 
                                            'stShowKitOnSales, ' + 
                                            'stBLineCount, ' + 
                                            'stSSDCommodityCode, ' + 
                                            'stSSDSalesUnitWeight, ' +
                                            'stSSDPurchaseUnitWeight, ' + 
                                            'stSSDUnitDesc, ' + 
                                            'stSSDStockUnits, ' + 
                                            'stBinLocation, ' + 
                                            'stStockTakeFlag, ' + 
                                            'stCoverPeriods, ' + 
                                            'stCoverPeriodUnits, ' + 
                                            'stCoverMinPeriods, ' + 
                                            'stCoverMinPeriodUnits, ' + 
                                            'stSupplier, ' + 
                                            'stQtyFreeze, ' + 
                                            'stCoverQtySold, ' + 
                                            'stUseCover, ' + 
                                            'stCoverMaxPeriods, ' + 
                                            'stCoverMaxPeriodUnits, ' + 
                                            'stReorderCurrency, ' + 
                                            'stReorderPrice, ' + 
                                            'stReorderDate, ' + 
                                            'stQtyStockTake, ' + 
                                            'stValuationMethod, ' + 
                                            'stHasSerialNo, ' + 
                                            'stQtyPicked, ' + 
                                            'stLastUsed, ' + 
                                            'stCalcPack, ' + 
                                            'stAnalysisCode, ' + 
                                            'stUserField1, ' + 
                                            'stUserField2, ' + 
                                            'stBarCode, ' + 
                                            'stReorderDepartment, ' +
                                            'stReorderCostCentre, ' + 
                                            'stLocation, ' + 
                                            'stPriceByPack, ' + 
                                            'stShowQtyAsPacks, ' + 
                                            'stUseKitPrice, ' + 
                                            'stShowKitOnPurchase, ' + 
                                            'stDefaultLineType, ' + 
                                            'stSalesReturnQty, ' +
                                            'stQtyAllocWOR, ' + 
                                            'stQtyIssuedWOR, ' + 
                                            'stUseForEbus, ' + 
                                            'stWebLiveCatalog, ' +
                                            'stWebPrevCatalog, ' + 
                                            'stUserField3, ' + 
                                            'stUserField4, ' + 
                                            'stSerNoWAvg, ' +
                                            'stSizeCol, ' + 
                                            'stSSDDespatchUplift, ' + 
                                            'stSSDCountry, ' + 
                                            'stTimeChange, ' + 
                                            'stInclusiveVATCode, ' + 
                                            'stSSDArrivalUplift, ' + 
                                            'stPrivateRec, ' + 
                                            'stOperator, ' + 
                                            'stImageFile, ' + 
                                            'stTempBLoc, ' + 
                                            'stQtyPickedWOR, ' + 
                                            'stWIPGL, ' + 
                                            'stProductionTime, ' + 
                                            'stLeadTime, ' + 
                                            'stCalcProductionTime, ' + 
                                            'stBOMProductionTime, ' + 
                                            'stMinEccQty, ' + 
                                            'stMultiBinMode, ' + 
                                            'stSalesWarrantyLength, ' +
                                            'stSalesWarrantyType, ' + 
                                            'stManufacturerWarrantyLength, ' + 
                                            'stManufacturerWarrantyType, ' + 
                                            'stPurchaseReturnQty, ' + 
                                            'stSalesReturnGL, ' + 
                                            'stRestockPercent, ' + 
                                            'stRestockGL, ' + 
                                            'BOMDedComp, ' + 
                                            'stPurchaseReturnGL, ' + 
                                            'stRestockPChr, ' + 
                                            'stLastStockType, ' + 
                                            'stUserField5, ' + 
                                            'stUserField6, ' + 
                                            'stUserField7, ' + 
                                            'stUserField8, ' + 
                                            'stUserField9, ' +
                                            'stUserField10, ' +
                                            'stIsService' +
                                            ') ' +
              'VALUES (' + 
                       ':stCode, ' + 
                       ':stDescLine1, ' +
                       ':stDescLine2, ' + 
                       ':stDescLine3, ' + 
                       ':stDescLine4, ' + 
                       ':stDescLine5, ' + 
                       ':stDescLine6, ' + 
                       ':stAltCode, ' + 
                       ':stSuppTemp, ' + 
                       ':stNomCode1, ' + 
                       ':stNomCode2, ' + 
                       ':stNomCode3, ' + 
                       ':stNomCode4, ' + 
                       ':stNomCode5, ' + 
                       ':stReorderFlag, ' + 
                       ':stMinReorderFlag, ' + 
                       ':stFolioNum, ' + 
                       ':stParentCode, ' + 
                       ':stType, ' + 
                       ':stUnitOfStock, ' + 
                       ':stUnitOfSale, ' + 
                       ':stUnitOfPurch, ' +
                       ':stCostPriceCurrency, ' + 
                       ':stCostPrice, ' + 
                       ':stSalesBand1Currency, ' + 
                       ':stSalesBand1Price, ' + 
                       ':stSalesBand2Currency, ' + 
                       ':stSalesBand2Price, ' + 
                       ':stSalesBand3Currency, ' + 
                       ':stSalesBand3Price, ' + 
                       ':stSalesBand4Currency, ' + 
                       ':stSalesBand4Price, ' + 
                       ':stSalesBand5Currency, ' + 
                       ':stSalesBand5Price, ' + 
                       ':stSalesBand6Currency, ' + 
                       ':stSalesBand6Price, ' + 
                       ':stSalesBand7Currency, ' + 
                       ':stSalesBand7Price, ' + 
                       ':stSalesBand8Currency, ' +
                       ':stSalesBand8Price, ' + 
                       ':stSalesBand9Currency, ' + 
                       ':stSalesBand9Price, ' + 
                       ':stSalesBand10Currency, ' + 
                       ':stSalesBand10Price, ' + 
                       ':stSalesUnits, ' + 
                       ':stPurchaseUnits, ' + 
                       ':stSpare1, ' + 
                       ':stVATCode, ' +
                       ':stDepartment, ' + 
                       ':stCostCentre, ' +
                       ':stQtyInStock, ' + 
                       ':stQtyPosted, ' + 
                       ':stQtyAllocated, ' + 
                       ':stQtyOnOrder, ' + 
                       ':stQtyMin, ' + 
                       ':stQtyMax, ' + 
                       ':stReOrderQty, ' + 
                       ':stNLineCount, ' + 
                       ':stSubAssemblyFlag, ' + 
                       ':stShowKitOnSales, ' + 
                       ':stBLineCount, ' + 
                       ':stSSDCommodityCode, ' + 
                       ':stSSDSalesUnitWeight, ' +
                       ':stSSDPurchaseUnitWeight, ' + 
                       ':stSSDUnitDesc, ' + 
                       ':stSSDStockUnits, ' + 
                       ':stBinLocation, ' + 
                       ':stStockTakeFlag, ' + 
                       ':stCoverPeriods, ' + 
                       ':stCoverPeriodUnits, ' + 
                       ':stCoverMinPeriods, ' + 
                       ':stCoverMinPeriodUnits, ' + 
                       ':stSupplier, ' + 
                       ':stQtyFreeze, ' + 
                       ':stCoverQtySold, ' + 
                       ':stUseCover, ' + 
                       ':stCoverMaxPeriods, ' + 
                       ':stCoverMaxPeriodUnits, ' + 
                       ':stReorderCurrency, ' + 
                       ':stReorderPrice, ' +
                       ':stReorderDate, ' + 
                       ':stQtyStockTake, ' + 
                       ':stValuationMethod, ' + 
                       ':stHasSerialNo, ' + 
                       ':stQtyPicked, ' + 
                       ':stLastUsed, ' + 
                       ':stCalcPack, ' + 
                       ':stAnalysisCode, ' + 
                       ':stUserField1, ' + 
                       ':stUserField2, ' + 
                       ':stBarCode, ' + 
                       ':stReorderDepartment, ' + 
                       ':stReorderCostCentre, ' + 
                       ':stLocation, ' + 
                       ':stPriceByPack, ' + 
                       ':stShowQtyAsPacks, ' + 
                       ':stUseKitPrice, ' + 
                       ':stShowKitOnPurchase, ' +
                       ':stDefaultLineType, ' +
                       ':stSalesReturnQty, ' + 
                       ':stQtyAllocWOR, ' + 
                       ':stQtyIssuedWOR, ' + 
                       ':stUseForEbus, ' + 
                       ':stWebLiveCatalog, ' +
                       ':stWebPrevCatalog, ' + 
                       ':stUserField3, ' + 
                       ':stUserField4, ' + 
                       ':stSerNoWAvg, ' + 
                       ':stSizeCol, ' + 
                       ':stSSDDespatchUplift, ' + 
                       ':stSSDCountry, ' + 
                       ':stTimeChange, ' + 
                       ':stInclusiveVATCode, ' + 
                       ':stSSDArrivalUplift, ' + 
                       ':stPrivateRec, ' + 
                       ':stOperator, ' + 
                       ':stImageFile, ' + 
                       ':stTempBLoc, ' + 
                       ':stQtyPickedWOR, ' + 
                       ':stWIPGL, ' + 
                       ':stProductionTime, ' +
                       ':stLeadTime, ' + 
                       ':stCalcProductionTime, ' + 
                       ':stBOMProductionTime, ' + 
                       ':stMinEccQty, ' + 
                       ':stMultiBinMode, ' + 
                       ':stSalesWarrantyLength, ' + 
                       ':stSalesWarrantyType, ' + 
                       ':stManufacturerWarrantyLength, ' + 
                       ':stManufacturerWarrantyType, ' + 
                       ':stPurchaseReturnQty, ' + 
                       ':stSalesReturnGL, ' + 
                       ':stRestockPercent, ' + 
                       ':stRestockGL, ' + 
                       ':BOMDedComp, ' + 
                       ':stPurchaseReturnGL, ' + 
                       ':stRestockPChr, ' + 
                       ':stLastStockType, ' + 
                       ':stUserField5, ' + 
                       ':stUserField6, ' + 
                       ':stUserField7, ' + 
                       ':stUserField8, ' + 
                       ':stUserField9, ' + 
                       ':stUserField10, ' +
                       ':stIsService' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    stCodeParam := FindParam('stCode');
    stDescLine1Param := FindParam('stDescLine1');
    stDescLine2Param := FindParam('stDescLine2');
    stDescLine3Param := FindParam('stDescLine3');
    stDescLine4Param := FindParam('stDescLine4');
    stDescLine5Param := FindParam('stDescLine5');
    stDescLine6Param := FindParam('stDescLine6');
    stAltCodeParam := FindParam('stAltCode');
    stSuppTempParam := FindParam('stSuppTemp');
    stNomCode1Param := FindParam('stNomCode1');
    stNomCode2Param := FindParam('stNomCode2');
    stNomCode3Param := FindParam('stNomCode3');
    stNomCode4Param := FindParam('stNomCode4');
    stNomCode5Param := FindParam('stNomCode5');
    stReorderFlagParam := FindParam('stReorderFlag');
    stMinReorderFlagParam := FindParam('stMinReorderFlag');
    stFolioNumParam := FindParam('stFolioNum');
    stParentCodeParam := FindParam('stParentCode');
    stTypeParam := FindParam('stType');
    stUnitOfStockParam := FindParam('stUnitOfStock');
    stUnitOfSaleParam := FindParam('stUnitOfSale');
    stUnitOfPurchParam := FindParam('stUnitOfPurch');
    stCostPriceCurrencyParam := FindParam('stCostPriceCurrency');
    stCostPriceParam := FindParam('stCostPrice');
    stSalesBand1CurrencyParam := FindParam('stSalesBand1Currency');
    stSalesBand1PriceParam := FindParam('stSalesBand1Price');
    stSalesBand2CurrencyParam := FindParam('stSalesBand2Currency');
    stSalesBand2PriceParam := FindParam('stSalesBand2Price');
    stSalesBand3CurrencyParam := FindParam('stSalesBand3Currency');
    stSalesBand3PriceParam := FindParam('stSalesBand3Price');
    stSalesBand4CurrencyParam := FindParam('stSalesBand4Currency');
    stSalesBand4PriceParam := FindParam('stSalesBand4Price');
    stSalesBand5CurrencyParam := FindParam('stSalesBand5Currency');
    stSalesBand5PriceParam := FindParam('stSalesBand5Price');
    stSalesBand6CurrencyParam := FindParam('stSalesBand6Currency');
    stSalesBand6PriceParam := FindParam('stSalesBand6Price');
    stSalesBand7CurrencyParam := FindParam('stSalesBand7Currency');
    stSalesBand7PriceParam := FindParam('stSalesBand7Price');
    stSalesBand8CurrencyParam := FindParam('stSalesBand8Currency');
    stSalesBand8PriceParam := FindParam('stSalesBand8Price');
    stSalesBand9CurrencyParam := FindParam('stSalesBand9Currency');
    stSalesBand9PriceParam := FindParam('stSalesBand9Price');
    stSalesBand10CurrencyParam := FindParam('stSalesBand10Currency');
    stSalesBand10PriceParam := FindParam('stSalesBand10Price');
    stSalesUnitsParam := FindParam('stSalesUnits');
    stPurchaseUnitsParam := FindParam('stPurchaseUnits');
    stSpare1Param := FindParam('stSpare1');
    stVATCodeParam := FindParam('stVATCode');
    stDepartmentParam := FindParam('stDepartment');
    stCostCentreParam := FindParam('stCostCentre');
    stQtyInStockParam := FindParam('stQtyInStock');
    stQtyPostedParam := FindParam('stQtyPosted');
    stQtyAllocatedParam := FindParam('stQtyAllocated');
    stQtyOnOrderParam := FindParam('stQtyOnOrder');
    stQtyMinParam := FindParam('stQtyMin');
    stQtyMaxParam := FindParam('stQtyMax');
    stReOrderQtyParam := FindParam('stReOrderQty');
    stNLineCountParam := FindParam('stNLineCount');
    stSubAssemblyFlagParam := FindParam('stSubAssemblyFlag');
    stShowKitOnSalesParam := FindParam('stShowKitOnSales');
    stBLineCountParam := FindParam('stBLineCount');
    stSSDCommodityCodeParam := FindParam('stSSDCommodityCode');
    stSSDSalesUnitWeightParam := FindParam('stSSDSalesUnitWeight');
    stSSDPurchaseUnitWeightParam := FindParam('stSSDPurchaseUnitWeight');
    stSSDUnitDescParam := FindParam('stSSDUnitDesc');
    stSSDStockUnitsParam := FindParam('stSSDStockUnits');
    stBinLocationParam := FindParam('stBinLocation');
    stStockTakeFlagParam := FindParam('stStockTakeFlag');
    stCoverPeriodsParam := FindParam('stCoverPeriods');
    stCoverPeriodUnitsParam := FindParam('stCoverPeriodUnits');
    stCoverMinPeriodsParam := FindParam('stCoverMinPeriods');
    stCoverMinPeriodUnitsParam := FindParam('stCoverMinPeriodUnits');
    stSupplierParam := FindParam('stSupplier');
    stQtyFreezeParam := FindParam('stQtyFreeze');
    stCoverQtySoldParam := FindParam('stCoverQtySold');
    stUseCoverParam := FindParam('stUseCover');
    stCoverMaxPeriodsParam := FindParam('stCoverMaxPeriods');
    stCoverMaxPeriodUnitsParam := FindParam('stCoverMaxPeriodUnits');
    stReorderCurrencyParam := FindParam('stReorderCurrency');
    stReorderPriceParam := FindParam('stReorderPrice');
    stReorderDateParam := FindParam('stReorderDate');
    stQtyStockTakeParam := FindParam('stQtyStockTake');
    stValuationMethodParam := FindParam('stValuationMethod');
    stHasSerialNoParam := FindParam('stHasSerialNo');
    stQtyPickedParam := FindParam('stQtyPicked');
    stLastUsedParam := FindParam('stLastUsed');
    stCalcPackParam := FindParam('stCalcPack');
    stAnalysisCodeParam := FindParam('stAnalysisCode');
    stUserField1Param := FindParam('stUserField1');
    stUserField2Param := FindParam('stUserField2');
    stBarCodeParam := FindParam('stBarCode');
    stReorderDepartmentParam := FindParam('stReorderDepartment');
    stReorderCostCentreParam := FindParam('stReorderCostCentre');
    stLocationParam := FindParam('stLocation');
    stPriceByPackParam := FindParam('stPriceByPack');
    stShowQtyAsPacksParam := FindParam('stShowQtyAsPacks');
    stUseKitPriceParam := FindParam('stUseKitPrice');
    stShowKitOnPurchaseParam := FindParam('stShowKitOnPurchase');
    stDefaultLineTypeParam := FindParam('stDefaultLineType');
    stSalesReturnQtyParam := FindParam('stSalesReturnQty');
    stQtyAllocWORParam := FindParam('stQtyAllocWOR');
    stQtyIssuedWORParam := FindParam('stQtyIssuedWOR');
    stUseForEbusParam := FindParam('stUseForEbus');
    stWebLiveCatalogParam := FindParam('stWebLiveCatalog');
    stWebPrevCatalogParam := FindParam('stWebPrevCatalog');
    stUserField3Param := FindParam('stUserField3');
    stUserField4Param := FindParam('stUserField4');
    stSerNoWAvgParam := FindParam('stSerNoWAvg');
    stSizeColParam := FindParam('stSizeCol');
    stSSDDespatchUpliftParam := FindParam('stSSDDespatchUplift');
    stSSDCountryParam := FindParam('stSSDCountry');
    stTimeChangeParam := FindParam('stTimeChange');
    stInclusiveVATCodeParam := FindParam('stInclusiveVATCode');
    stSSDArrivalUpliftParam := FindParam('stSSDArrivalUplift');
    stPrivateRecParam := FindParam('stPrivateRec');
    stOperatorParam := FindParam('stOperator');
    stImageFileParam := FindParam('stImageFile');
    stTempBLocParam := FindParam('stTempBLoc');
    stQtyPickedWORParam := FindParam('stQtyPickedWOR');
    stWIPGLParam := FindParam('stWIPGL');
    stProductionTimeParam := FindParam('stProductionTime');
    stLeadTimeParam := FindParam('stLeadTime');
    stCalcProductionTimeParam := FindParam('stCalcProductionTime');
    stBOMProductionTimeParam := FindParam('stBOMProductionTime');
    stMinEccQtyParam := FindParam('stMinEccQty');
    stMultiBinModeParam := FindParam('stMultiBinMode');
    stSalesWarrantyLengthParam := FindParam('stSalesWarrantyLength');
    stSalesWarrantyTypeParam := FindParam('stSalesWarrantyType');
    stManufacturerWarrantyLengthParam := FindParam('stManufacturerWarrantyLength');
    stManufacturerWarrantyTypeParam := FindParam('stManufacturerWarrantyType');
    stPurchaseReturnQtyParam := FindParam('stPurchaseReturnQty');
    stSalesReturnGLParam := FindParam('stSalesReturnGL');
    stRestockPercentParam := FindParam('stRestockPercent');
    stRestockGLParam := FindParam('stRestockGL');
    BOMDedCompParam := FindParam('BOMDedComp');
    stPurchaseReturnGLParam := FindParam('stPurchaseReturnGL');
    stRestockPChrParam := FindParam('stRestockPChr');
    stLastStockTypeParam := FindParam('stLastStockType');
    stUserField5Param := FindParam('stUserField5');
    stUserField6Param := FindParam('stUserField6');
    stUserField7Param := FindParam('stUserField7');
    stUserField8Param := FindParam('stUserField8');
    stUserField9Param := FindParam('stUserField9');
    stUserField10Param := FindParam('stUserField10');
    stIsServiceParam := FindParam('stIsService');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TStockDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^StockRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    stCodeParam.Value := StockCode;                                                          // SQL=varchar, Delphi=String[20]
    stDescLine1Param.Value := Desc[1];                                                       // SQL=varchar, Delphi=String[35]
    stDescLine2Param.Value := Desc[2];                                                       // SQL=varchar, Delphi=String[35]
    stDescLine3Param.Value := Desc[3];                                                       // SQL=varchar, Delphi=String[35]
    stDescLine4Param.Value := Desc[4];                                                       // SQL=varchar, Delphi=String[35]
    stDescLine5Param.Value := Desc[5];                                                       // SQL=varchar, Delphi=String[35]
    stDescLine6Param.Value := Desc[6];                                                       // SQL=varchar, Delphi=String[35]
    stAltCodeParam.Value := AltCode;                                                         // SQL=varchar, Delphi=String[20]
    stSuppTempParam.Value := SuppTemp;                                                       // SQL=varchar, Delphi=String[10]
    stNomCode1Param.Value := NomCodeS[1];                                                    // SQL=int, Delphi=LongInt
    stNomCode2Param.Value := NomCodeS[2];                                                    // SQL=int, Delphi=LongInt
    stNomCode3Param.Value := NomCodeS[3];                                                    // SQL=int, Delphi=LongInt
    stNomCode4Param.Value := NomCodeS[4];                                                    // SQL=int, Delphi=LongInt
    stNomCode5Param.Value := NomCodeS[5];                                                    // SQL=int, Delphi=LongInt
    stReorderFlagParam.Value := ROFlg;                                                       // SQL=bit, Delphi=Boolean
    stMinReorderFlagParam.Value := MinFlg;                                                   // SQL=bit, Delphi=Boolean
    stFolioNumParam.Value := StockFolio;                                                     // SQL=int, Delphi=LongInt
    stParentCodeParam.Value := StockCat;                                                     // SQL=varchar, Delphi=String[20]
    stTypeParam.Value := ConvertCharToSQLEmulatorVarChar(StockType);                         // SQL=varchar, Delphi=Char
    stUnitOfStockParam.Value := UnitK;                                                       // SQL=varchar, Delphi=String[10]
    stUnitOfSaleParam.Value := UnitS;                                                        // SQL=varchar, Delphi=String[10]
    stUnitOfPurchParam.Value := UnitP;                                                       // SQL=varchar, Delphi=String[10]
    stCostPriceCurrencyParam.Value := PCurrency;                                             // SQL=int, Delphi=Byte
    stCostPriceParam.Value := CostPrice;                                                     // SQL=float, Delphi=Real
    stSalesBand1CurrencyParam.Value := SaleBands[1].Currency;                                // SQL=int, Delphi=Byte
    stSalesBand1PriceParam.Value := SaleBands[1].SalesPrice;                                 // SQL=float, Delphi=Real
    stSalesBand2CurrencyParam.Value := SaleBands[2].Currency;                                // SQL=int, Delphi=Byte
    stSalesBand2PriceParam.Value := SaleBands[2].SalesPrice;                                 // SQL=float, Delphi=Real
    stSalesBand3CurrencyParam.Value := SaleBands[3].Currency;                                // SQL=int, Delphi=Byte
    stSalesBand3PriceParam.Value := SaleBands[3].SalesPrice;                                 // SQL=float, Delphi=Real
    stSalesBand4CurrencyParam.Value := SaleBands[4].Currency;                                // SQL=int, Delphi=Byte
    stSalesBand4PriceParam.Value := SaleBands[4].SalesPrice;                                 // SQL=float, Delphi=Real
    stSalesBand5CurrencyParam.Value := SaleBands[5].Currency;                                // SQL=int, Delphi=Byte
    stSalesBand5PriceParam.Value := SaleBands[5].SalesPrice;                                 // SQL=float, Delphi=Real
    stSalesBand6CurrencyParam.Value := SaleBands[6].Currency;                                // SQL=int, Delphi=Byte
    stSalesBand6PriceParam.Value := SaleBands[6].SalesPrice;                                 // SQL=float, Delphi=Real
    stSalesBand7CurrencyParam.Value := SaleBands[7].Currency;                                // SQL=int, Delphi=Byte
    stSalesBand7PriceParam.Value := SaleBands[7].SalesPrice;                                 // SQL=float, Delphi=Real
    stSalesBand8CurrencyParam.Value := SaleBands[8].Currency;                                // SQL=int, Delphi=Byte
    stSalesBand8PriceParam.Value := SaleBands[8].SalesPrice;                                 // SQL=float, Delphi=Real
    stSalesBand9CurrencyParam.Value := SaleBands[9].Currency;                                // SQL=int, Delphi=Byte
    stSalesBand9PriceParam.Value := SaleBands[9].SalesPrice;                                 // SQL=float, Delphi=Real
    stSalesBand10CurrencyParam.Value := SaleBands[10].Currency;                              // SQL=int, Delphi=Byte
    stSalesBand10PriceParam.Value := SaleBands[10].SalesPrice;                               // SQL=float, Delphi=Real
    stSalesUnitsParam.Value := SellUnit;                                                     // SQL=float, Delphi=Real
    stPurchaseUnitsParam.Value := BuyUnit;                                                   // SQL=float, Delphi=Real
    stSpare1Param.Value := CreateVariantArray (@Spare, SizeOf(Spare));                       // SQL=varbinary, Delphi=String[10]
    stVATCodeParam.Value := ConvertCharToSQLEmulatorVarChar(VATCode);                        // SQL=varchar, Delphi=Char
    stDepartmentParam.Value := CCDep[False];                                                 // SQL=varchar, Delphi=String[3]
    stCostCentreParam.Value := CCDep[True];                                                  // SQL=varchar, Delphi=String[3]
    stQtyInStockParam.Value := QtyInStock;                                                   // SQL=float, Delphi=Real
    stQtyPostedParam.Value := QtyPosted;                                                     // SQL=float, Delphi=Real
    stQtyAllocatedParam.Value := QtyAllocated;                                               // SQL=float, Delphi=Real
    stQtyOnOrderParam.Value := QtyOnOrder;                                                   // SQL=float, Delphi=Real
    stQtyMinParam.Value := QtyMin;                                                           // SQL=float, Delphi=Real
    stQtyMaxParam.Value := QtyMax;                                                           // SQL=float, Delphi=Real
    stReOrderQtyParam.Value := ROQty;                                                        // SQL=float, Delphi=Real
    stNLineCountParam.Value := NLineCount;                                                   // SQL=int, Delphi=LongInt
    stSubAssemblyFlagParam.Value := SubAssyFlg;                                              // SQL=bit, Delphi=Boolean
    stShowKitOnSalesParam.Value := ShowasKit;                                                // SQL=bit, Delphi=Boolean
    stBLineCountParam.Value := BLineCount;                                                   // SQL=int, Delphi=LongInt
    stSSDCommodityCodeParam.Value := CommodCode;                                             // SQL=varchar, Delphi=String[10]
    stSSDSalesUnitWeightParam.Value := SWeight;                                              // SQL=float, Delphi=Real
    stSSDPurchaseUnitWeightParam.Value := PWeight;                                           // SQL=float, Delphi=Real
    stSSDUnitDescParam.Value := UnitSupp;                                                    // SQL=varchar, Delphi=String[10]
    stSSDStockUnitsParam.Value := SuppSUnit;                                                 // SQL=float, Delphi=Real
    stBinLocationParam.Value := BinLoc;                                                      // SQL=varchar, Delphi=String[10]
    stStockTakeFlagParam.Value := StkFlg;                                                    // SQL=bit, Delphi=Boolean
    stCoverPeriodsParam.Value := CovPr;                                                      // SQL=int, Delphi=SmallInt
    stCoverPeriodUnitsParam.Value := Ord(CovPrUnit);                                         // SQL=int, Delphi=Char
    stCoverMinPeriodsParam.Value := CovMinPr;                                                // SQL=int, Delphi=SmallInt
    stCoverMinPeriodUnitsParam.Value := Ord(CovMinUnit);                                     // SQL=int, Delphi=Char
    stSupplierParam.Value := Supplier;                                                       // SQL=varchar, Delphi=String[10]
    stQtyFreezeParam.Value := QtyFreeze;                                                     // SQL=float, Delphi=Double
    stCoverQtySoldParam.Value := CovSold;                                                    // SQL=float, Delphi=Double
    stUseCoverParam.Value := UseCover;                                                       // SQL=bit, Delphi=Boolean
    stCoverMaxPeriodsParam.Value := CovMaxPr;                                                // SQL=int, Delphi=SmallInt
    stCoverMaxPeriodUnitsParam.Value := Ord(CovMaxUnit);                                     // SQL=int, Delphi=Char
    stReorderCurrencyParam.Value := ROCurrency;                                              // SQL=int, Delphi=Byte
    stReorderPriceParam.Value := ROCPrice;                                                   // SQL=float, Delphi=Double
    stReorderDateParam.Value := RODate;                                                      // SQL=varchar, Delphi=LongDate
    stQtyStockTakeParam.Value := QtyTake;                                                    // SQL=float, Delphi=Double
    stValuationMethodParam.Value := ConvertCharToSQLEmulatorVarChar(StkValType);             // SQL=varchar, Delphi=Char
    stHasSerialNoParam.Value := HasSerNo;                                                    // SQL=bit, Delphi=Boolean
    stQtyPickedParam.Value := QtyPicked;                                                     // SQL=float, Delphi=Double
    stLastUsedParam.Value := LastUsed;                                                       // SQL=varchar, Delphi=LongDate
    stCalcPackParam.Value := CalcPack;                                                       // SQL=bit, Delphi=Boolean
    stAnalysisCodeParam.Value := JAnalCode;                                                  // SQL=varchar, Delphi=String[10]
    stUserField1Param.Value := StkUser1;                                                     // SQL=varchar, Delphi=String[20]
    stUserField2Param.Value := StkUser2;                                                     // SQL=varchar, Delphi=String[20]
    stBarCodeParam.Value := BarCode;                                                         // SQL=varchar, Delphi=String[20]
    stReorderDepartmentParam.Value := ROCCDep[False];                                        // SQL=varchar, Delphi=String[3]
    stReorderCostCentreParam.Value := ROCCDep[True];                                         // SQL=varchar, Delphi=String[3]
    stLocationParam.Value := DefMLoc;                                                        // SQL=varchar, Delphi=String[3]
    stPriceByPackParam.Value := PricePack;                                                   // SQL=bit, Delphi=Boolean
    stShowQtyAsPacksParam.Value := DPackQty;                                                 // SQL=bit, Delphi=Boolean
    stUseKitPriceParam.Value := KitPrice;                                                    // SQL=bit, Delphi=Boolean
    stShowKitOnPurchaseParam.Value := KitOnPurch;                                            // SQL=bit, Delphi=Boolean
    stDefaultLineTypeParam.Value := StkLinkLT;                                               // SQL=int, Delphi=Byte
    stSalesReturnQtyParam.Value := QtyReturn;                                                // SQL=float, Delphi=Double
    stQtyAllocWORParam.Value := QtyAllocWOR;                                                 // SQL=float, Delphi=Double
    stQtyIssuedWORParam.Value := QtyIssueWOR;                                                // SQL=float, Delphi=Double
    stUseForEbusParam.Value := WebInclude;                                                   // SQL=int, Delphi=Byte
    stWebLiveCatalogParam.Value := WebLiveCat;                                               // SQL=varchar, Delphi=String[20]
    stWebPrevCatalogParam.Value := WebPrevCat;                                               // SQL=varchar, Delphi=String[20]
    stUserField3Param.Value := StkUser3;                                                     // SQL=varchar, Delphi=String[30]
    stUserField4Param.Value := StkUser4;                                                     // SQL=varchar, Delphi=String[30]
    stSerNoWAvgParam.Value := SerNoWAvg;                                                     // SQL=int, Delphi=Byte
    stSizeColParam.Value := StkSizeCol;                                                      // SQL=int, Delphi=Byte
    stSSDDespatchUpliftParam.Value := SSDDUplift;                                            // SQL=float, Delphi=Double
    stSSDCountryParam.Value := SSDCountry;                                                   // SQL=varchar, Delphi=String[5]
    stTimeChangeParam.Value := TimeChange;                                                   // SQL=varchar, Delphi=String[6]
    stInclusiveVATCodeParam.Value := ConvertCharToSQLEmulatorVarChar(SVATIncFlg);            // SQL=varchar, Delphi=Char
    stSSDArrivalUpliftParam.Value := SSDAUpLift;                                             // SQL=float, Delphi=Double
    stPrivateRecParam.Value := PrivateRec;                                                   // SQL=int, Delphi=Byte
    stOperatorParam.Value := LastOpo;                                                        // SQL=varchar, Delphi=String[10]
    stImageFileParam.Value := ImageFile;                                                     // SQL=varchar, Delphi=String[30]
    stTempBLocParam.Value := TempBLoc;                                                       // SQL=varchar, Delphi=String[10]
    stQtyPickedWORParam.Value := QtyPickWOR;                                                 // SQL=float, Delphi=Double
    stWIPGLParam.Value := WOPWIPGL;                                                          // SQL=int, Delphi=LongInt
    stProductionTimeParam.Value := ProdTime;                                                 // SQL=int, Delphi=LongInt
    stLeadTimeParam.Value := Leadtime;                                                       // SQL=int, Delphi=LongInt
    stCalcProductionTimeParam.Value := CalcProdTime;                                         // SQL=bit, Delphi=Boolean
    stBOMProductionTimeParam.Value := BOMProdTime;                                           // SQL=int, Delphi=LongInt
    stMinEccQtyParam.Value := MinEccQty;                                                     // SQL=float, Delphi=Double
    stMultiBinModeParam.Value := MultiBinMode;                                               // SQL=bit, Delphi=Boolean
    stSalesWarrantyLengthParam.Value := SWarranty;                                           // SQL=int, Delphi=Byte
    stSalesWarrantyTypeParam.Value := SWarrantyType;                                         // SQL=int, Delphi=Byte
    stManufacturerWarrantyLengthParam.Value := MWarranty;                                    // SQL=int, Delphi=Byte
    stManufacturerWarrantyTypeParam.Value := MWarrantyType;                                  // SQL=int, Delphi=Byte
    stPurchaseReturnQtyParam.Value := QtyPReturn;                                            // SQL=float, Delphi=Double
    stSalesReturnGLParam.Value := ReturnGL;                                                  // SQL=int, Delphi=LongInt
    stRestockPercentParam.Value := ReStockPcnt;                                              // SQL=float, Delphi=Double
    stRestockGLParam.Value := ReStockGL;                                                     // SQL=int, Delphi=LongInt
    BOMDedCompParam.Value := BOMDedComp;                                                     // SQL=bit, Delphi=Boolean
    stPurchaseReturnGLParam.Value := PReturnGL;                                              // SQL=int, Delphi=LongInt
    stRestockPChrParam.Value := Ord(ReStockPChr);                                            // SQL=int, Delphi=Char
    stLastStockTypeParam.Value := Ord(LastStockType);                                        // SQL=int, Delphi=Char
    stUserField5Param.Value := StkUser5;                                                     // SQL=varchar, Delphi=String[30]
    stUserField6Param.Value := StkUser6;                                                     // SQL=varchar, Delphi=String[30]
    stUserField7Param.Value := StkUser7;                                                     // SQL=varchar, Delphi=String[30]
    stUserField8Param.Value := StkUser8;                                                     // SQL=varchar, Delphi=String[30]
    stUserField9Param.Value := StkUser9;                                                     // SQL=varchar, Delphi=String[30]
    stUserField10Param.Value := StkUser10;                                                   // SQL=varchar, Delphi=String[30]
    stIsServiceParam.Value := stIsService;
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

