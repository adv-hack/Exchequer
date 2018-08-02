constructor TVATInfo.create(Rate: real; Code: string);
begin
  inherited create;
  rRate := Rate;
  cCode := Code;
end;

Procedure ShowTKError(sMessage : string; iResult : integer);
begin
  MsgBox('An error has occured in the Exchequer COM Toolkit call : ' + sMessage
  +#13#13 + 'Result : ' + IntToStr(iResult), mtError, [mbOK], mbOk, 'COM Toolkit Error');
end;

Function OpenToolkit(sDataDir : string; bUseBackDoor : boolean) : IToolkit;
var
  a, b, c : LongInt;
  oToolkit : IToolkit;

  Function DoOpenTK : boolean;
  var
    iResult : integer;
  begin
    Result := FALSE;
    with oToolkit do begin
      Configuration.DataDirectory := sDataDir;
      iResult := OpenToolkit;
      if iResult = 0 then Result := TRUE
      else ShowTKError('OpenToolkit', iResult);
    end;{with}
  end; {OpenTK}

begin
  oToolkit := CreateOLEObject(sClassName) as IToolkit;
  if assigned (oToolkit) then
    begin
      if bUseBackDoor then
        begin
          EncodeOpCode(97, a, b, c);
          oToolkit.Configuration.SetDebugMode(a, b, c);
          if not DoOpenTK then oToolkit := nil;
        end
      else begin
        if not DoOpenTK then oToolkit := nil;
      end;{if}
    end
  else ShowTKError('Creating Toolkit', 0);
  Result := oToolkit;
end;

function CompanyCodeFromPath(const oToolkit : IToolkit;
                             const Path     : ShortString) : string;
var
  i : integer;
begin
//Input is the company data path - use oToolkit to find and return the company code
  Result := '';
  if Assigned(oToolkit) then
  with oToolkit.Company do
  begin
    for i := 1 to cmCount do
      if Trim(cmCompany[i].coPath) = Trim(UpperCase(Path)) then
      begin
        Result := cmCompany[i].coCode;
        Break;
      end;
  end
  else
    raise Exception.Create('Unable to access COM Toolkit');
end;

function CompanyPathFromCode(const oToolkit : IToolkit;
                             const Code     : ShortString) : string;
var
  i : integer;
begin
//Input is the company data path - use oToolkit to find and return the company code
  Result := '';
  if Assigned(oToolkit) then
  with oToolkit.Company do
  begin
    for i := 1 to cmCount do
      if Trim(cmCompany[i].coCode) = Trim(UpperCase(Code)) then
      begin
        Result := cmCompany[i].coPath;
        Break;
      end;
  end
  else
    raise Exception.Create('Unable to access COM Toolkit');
end;


function CreateToolkitWithBackdoor : IToolkit;
var
  a, b, c : longint;
begin
  Result := CreateOLEObject(sClassName) as IToolkit2;
  if Assigned(Result) then
  begin
    EncodeOpCode(97, a, b, c);
    Result.Configuration.SetDebugMode(a, b, c);
  end
  else
    raise Exception.Create('Unable to create COM Toolkit');
end;

procedure CopyLineProperties(const oFromLine, oToLine : ITransactionLine; Mode : Byte = 0);
var
  oFromLineEx,
  oToLineEx : ITransactionLine4;
begin
  oFromLineEx := oFromLine as ITransactionLine4;
  oToLineEx := oToLine as ITransactionLine4;
  Try
  //  oToLine.tlLineNo := oFromLine.tlLineNo;
    oToLineEx.tlGLCode := oFromLineEx.tlGLCode;
    oToLineEx.tlCurrency := oFromLineEx.tlCurrency;
    oToLineEx.tlCompanyRate := oFromLineEx.tlCompanyRate;
    oToLineEx.tlDailyRate := oFromLineEx.tlDailyRate;
    oToLineEx.tlCostCentre := oFromLineEx.tlCostCentre;
    oToLineEx.tlDepartment := oFromLineEx.tlDepartment;
    oToLineEx.tlStockCode := oFromLineEx.tlStockCode;
    oToLineEx.tlQty := oFromLineEx.tlQty;
    oToLineEx.tlQtyMul := oFromLineEx.tlQtyMul;
    oToLineEx.tlNetValue := oFromLineEx.tlNetValue;
    oToLineEx.tlDiscount := oFromLineEx.tlDiscount;
    oToLineEx.tlDiscFlag := oFromLineEx.tlDiscFlag;
    oToLineEx.tlVATCode := oFromLineEx.tlVATCode;
    oToLineEx.tlVATAmount := oFromLineEx.tlVATAmount;
    oToLineEx.tlPayment := oFromLineEx.tlPayment;
    oToLineEx.tlQtyWOFF := oFromLineEx.tlQtyWOFF;
    oToLineEx.tlQtyDel := oFromLineEx.tlQtyDel;
    oToLineEx.tlCost := oFromLineEx.tlCost;
    oToLineEx.tlLineDate := oFromLineEx.tlLineDate;
    oToLineEx.tlItemNo := oFromLineEx.tlItemNo;
    oToLineEx.tlDescr := oFromLineEx.tlDescr;
    oToLineEx.tlJobCode := oFromLineEx.tlJobCode;
    oToLineEx.tlAnalysisCode := oFromLineEx.tlAnalysisCode;
    oToLineEx.tlUnitWeight := oFromLineEx.tlUnitWeight;
    oToLineEx.tlLocation := oFromLineEx.tlLocation;
    oToLineEx.tlChargeCurrency := oFromLineEx.tlChargeCurrency;
    oToLineEx.tlLineType := oFromLineEx.tlLineType;
    oToLineEx.tlRecStatus := oFromLineEx.tlRecStatus;
  //  oToLineEx.tlSOPFolioNum := oFromLineEx.tlSOPFolioNum;
  //  oToLineEx.tlSOPABSLineNo := oFromLineEx.tlSOPABSLineNo;
    oToLineEx.tlUserField1 := oFromLineEx.tlUserField1;
    oToLineEx.tlUserField2 := oFromLineEx.tlUserField2;
    oToLineEx.tlUserField3 := oFromLineEx.tlUserField3;
    oToLineEx.tlUserField4 := oFromLineEx.tlUserField4;
    oToLineEx.tlSSDUpliftPerc := oFromLineEx.tlSSDUpliftPerc;
    oToLineEx.tlSSDCommodCode := oFromLineEx.tlSSDCommodCode;
    oToLineEx.tlSSDSalesUnit := oFromLineEx.tlSSDSalesUnit;
    oToLineEx.tlSSDUseLineValues := oFromLineEx.tlSSDUseLineValues;
    oToLineEx.tlPriceMultiplier := oFromLineEx.tlPriceMultiplier;
    oToLineEx.tlQtyPicked := oFromLineEx.tlQtyPicked;
    oToLineEx.tlQtyPickedWO := oFromLineEx.tlQtyPickedWO;
    oToLineEx.tlSSDCountry := oFromLineEx.tlSSDCountry;
    oToLineEx.tlInclusiveVATCode := oFromLineEx.tlInclusiveVATCode;
    if Mode = 1 then
    begin
      oToLineEx.tlBOMKitLink := oFromLineEx.tlBOMKitLink;
      oToLineEx.tlYear := oFromLineEx.tlYear;
      oToLineEx.tlPeriod := oFromLineEx.tlPeriod;
    end;

    oToLineEx.tlCostApport := oFromLineEx.tlCostApport;
    oToLineEx.tlCISRate := oFromLineEx.tlCISRate;
    oToLineEx.tlCISRateCode := oFromLineEx.tlCISRateCode;

    oToLineEx.tlVATIncValue := oFromLineEx.tlVATIncValue;
  Finally
    oFromLineEx := nil;
    oToLineEx := nil;
  End;
end;

procedure CopyTransactionProperties(const oFromTrans, oToTrans : ITransaction);
var
  i : integer;
  oFromTransEx,
  oToTransEx : ITransaction4; //Update this for new descendants
begin
  oFromTransEx := oFromTrans as ITransaction4;
  oToTransEx := oToTrans as ITransaction4;
  Try
    oToTransEx.thExported:= oFromTransEx.thExported;
    oToTransEx.thTagNo:= oFromTransEx.thTagNo;
    oToTransEx.thCISTaxDue:= oFromTransEx.thCISTaxDue;
    oToTransEx.thCISManualTax:= oFromTransEx.thCISManualTax;
    oToTransEx.thCISTotalGross:= oFromTransEx.thCISTotalGross;
    oToTransEx.thTotalCostApport:= oFromTransEx.thTotalCostApport;
    oToTransEx.thCISEmployee:= oFromTransEx.thCISEmployee;
    oToTransEx.thYourRef:= oFromTransEx.thYourRef;
    oToTransEx.thAcCode:= oFromTransEx.thAcCode;
    oToTransEx.thCurrency:= oFromTransEx.thCurrency;
    oToTransEx.thYear:= oFromTransEx.thYear;
    oToTransEx.thPeriod:= oFromTransEx.thPeriod;
    oToTransEx.thTransDate:= oFromTransEx.thTransDate;
    oToTransEx.thDueDate:= oFromTransEx.thDueDate;
    oToTransEx.thCompanyRate:= oFromTransEx.thCompanyRate;
    oToTransEx.thDailyRate:= oFromTransEx.thDailyRate;
    oToTransEx.thNetValue:= oFromTransEx.thNetValue;
    oToTransEx.thTotalVAT:= oFromTransEx.thTotalVAT;
    oToTransEx.thSettleDiscPerc:= oFromTransEx.thSettleDiscPerc;
    oToTransEx.thSettleDiscAmount:= oFromTransEx.thSettleDiscAmount;
    oToTransEx.thTotalLineDiscount:= oFromTransEx.thTotalLineDiscount;
    oToTransEx.thSettleDiscDays:= oFromTransEx.thSettleDiscDays;
    oToTransEx.thSettleDiscTaken:= oFromTransEx.thSettleDiscTaken;
    oToTransEx.thTransportNature:= oFromTransEx.thTransportNature;
    oToTransEx.thTransportMode:= oFromTransEx.thTransportMode;
    oToTransEx.thHoldFlag:= oFromTransEx.thHoldFlag;
    oToTransEx.thTotalWeight:= oFromTransEx.thTotalWeight;
    for i := 1 to 5 do
      oToTransEx.thDelAddress[i] := oFromTransEx.thDelAddress[i];
    oToTransEx.thTotalCost:= oFromTransEx.thTotalCost;
    oToTransEx.thManualVAT:= oFromTransEx.thManualVAT;
    oToTransEx.thDeliveryTerms:= oFromTransEx.thDeliveryTerms;
    oToTransEx.thOperator:= oFromTransEx.thOperator;
    oToTransEx.thJobCode:= oFromTransEx.thJobCode;
    oToTransEx.thAnalysisCode:= oFromTransEx.thAnalysisCode;
    oToTransEx.thTotalOrderOS:= oFromTransEx.thTotalOrderOS;
    oToTransEx.thUserField1:= oFromTransEx.thUserField1;
    oToTransEx.thUserField2:= oFromTransEx.thUserField2;
    oToTransEx.thUserField3:= oFromTransEx.thUserField3;
    oToTransEx.thUserField4:= oFromTransEx.thUserField4;
    oToTransEx.thTagged:= oFromTransEx.thTagged;
    oToTransEx.thNoLabels:= oFromTransEx.thNoLabels;
    oToTransEx.thControlGL:= oFromTransEx.thControlGL;
    Try
      oToTransEx.thProcess:= oFromTransEx.thProcess;
    Except
    End;
    oToTransEx.thPORPickSOR:= oFromTransEx.thPORPickSOR;
    oToTransEx.thBatchDiscAmount:= oFromTransEx.thBatchDiscAmount;
    oToTransEx.thPrePost:= oFromTransEx.thPrePost;
    oToTransEx.thFixedRate:= oFromTransEx.thFixedRate;
    oToTransEx.thLongYourRef:= oFromTransEx.thLongYourRef;
    for i := 1 to oFromTransEx.thLines.thLineCount do
      CopyLineProperties(oFromTransEx.thLines[i] as ITransactionLine4,
       oToTransEx.thLines.Add as ITransactionLine4, 1);
  Finally
    oFromTransEx := nil;
    oToTransEx :=nil;
  End;
end;

procedure CopyStockProperties(const oFromStock, oToStock : IStock);
// Note : This does not copy the bom components. You cannot do this whilst adding a stock record.
//
// Note : This does not copy the notes. To do this, you must call the CopyStockNotes procedure separately
// , after storing the stock item.
var
  oFromStockEx,
  oToStockEx : IStock4; //Update this for new descendants

begin
  oFromStockEx := oFromStock as IStock4;
  oToStockEx := oToStock as IStock4;
  try

    {IStock}
    oToStockEx.stCode := oFromStockEx.stCode;
    oToStockEx.stDesc[1] := oFromStockEx.stDesc[1];
    oToStockEx.stDesc[2] := oFromStockEx.stDesc[2];
    oToStockEx.stDesc[3] := oFromStockEx.stDesc[3];
    oToStockEx.stDesc[4] := oFromStockEx.stDesc[4];
    oToStockEx.stDesc[5] := oFromStockEx.stDesc[5];
    oToStockEx.stAltCode  := oFromStockEx.stAltCode;
    oToStockEx.stType  := oFromStockEx.stType;
    oToStockEx.stSalesGL  := oFromStockEx.stSalesGL;
    oToStockEx.stCOSGL  := oFromStockEx.stCOSGL;
    oToStockEx.stPandLGL  := oFromStockEx.stPandLGL;
    oToStockEx.stBalSheetGL  := oFromStockEx.stBalSheetGL;
    oToStockEx.stWIPGL  := oFromStockEx.stWIPGL;
    oToStockEx.stBelowMinLevel  := oFromStockEx.stBelowMinLevel;
    oToStockEx.stParentCode  := oFromStockEx.stParentCode;
    oToStockEx.stSuppTemp  := oFromStockEx.stSuppTemp;
    oToStockEx.stUnitOfStock  := oFromStockEx.stUnitOfStock;
    oToStockEx.stUnitOfSale  := oFromStockEx.stUnitOfSale;
    oToStockEx.stUnitOfPurch  := oFromStockEx.stUnitOfPurch;
    oToStockEx.stCostPriceCur  := oFromStockEx.stCostPriceCur;
    oToStockEx.stCostPrice  := oFromStockEx.stCostPrice;
    oToStockEx.stSalesUnits  := oFromStockEx.stSalesUnits;
    oToStockEx.stPurchUnits  := oFromStockEx.stPurchUnits;
    oToStockEx.stVATCode  := oFromStockEx.stVATCode;
    oToStockEx.stCostCentre  := oFromStockEx.stCostCentre;
    oToStockEx.stDepartment  := oFromStockEx.stDepartment;
    oToStockEx.stQtyMin  := oFromStockEx.stQtyMin;
    oToStockEx.stQtyMax  := oFromStockEx.stQtyMax;
    oToStockEx.stBinLocation  := oFromStockEx.stBinLocation;
    oToStockEx.stCover.stCoverMaxPeriods  := oFromStockEx.stCover.stCoverMaxPeriods;
    oToStockEx.stCover.stCoverMaxPeriodUnits  := oFromStockEx.stCover.stCoverMaxPeriodUnits;
    oToStockEx.stCover.stCoverMinPeriods  := oFromStockEx.stCover.stCoverMinPeriods;
    oToStockEx.stCover.stCoverMinPeriodUnits  := oFromStockEx.stCover.stCoverMinPeriodUnits;
    oToStockEx.stCover.stCoverPeriods  := oFromStockEx.stCover.stCoverPeriods;
    oToStockEx.stCover.stCoverPeriodUnits  := oFromStockEx.stCover.stCoverPeriodUnits;
    oToStockEx.stCover.stCoverQtySold  := oFromStockEx.stCover.stCoverQtySold;
    oToStockEx.stCover.stUseCover := oFromStockEx.stCover.stUseCover;
    oToStockEx.stIntrastat.stSSDCommodityCode  := oFromStockEx.stIntrastat.stSSDCommodityCode;
    oToStockEx.stIntrastat.stSSDSalesUnitWeight  := oFromStockEx.stIntrastat.stSSDSalesUnitWeight;
    oToStockEx.stIntrastat.stSSDPurchaseUnitWeight  := oFromStockEx.stIntrastat.stSSDPurchaseUnitWeight;
    oToStockEx.stIntrastat.stSSDUnitDesc  := oFromStockEx.stIntrastat.stSSDUnitDesc;
    oToStockEx.stIntrastat.stSSDStockUnits  := oFromStockEx.stIntrastat.stSSDStockUnits;
    oToStockEx.stIntrastat.stSSDDespatchUplift  := oFromStockEx.stIntrastat.stSSDDespatchUplift;
    oToStockEx.stIntrastat.stSSDCountry  := oFromStockEx.stIntrastat.stSSDCountry;
    oToStockEx.stReorder.stReorderQty  := oFromStockEx.stReorder.stReorderQty;
    oToStockEx.stReorder.stReorderCur  := oFromStockEx.stReorder.stReorderCur;
    oToStockEx.stReorder.stReorderPrice  := oFromStockEx.stReorder.stReorderPrice;
    oToStockEx.stReorder.stReorderDate  := oFromStockEx.stReorder.stReorderDate;
    oToStockEx.stReorder.stReorderCostCentre  := oFromStockEx.stReorder.stReorderCostCentre;
    oToStockEx.stReorder.stReorderDepartment  := oFromStockEx.stReorder.stReorderDepartment;
    oToStockEx.stAnalysisCode  := oFromStockEx.stAnalysisCode;
    oToStockEx.stSalesBands['A'].stCurrency  := oFromStockEx.stSalesBands['A'].stCurrency;
    oToStockEx.stSalesBands['A'].stPrice := oFromStockEx.stSalesBands['A'].stPrice;
    oToStockEx.stSalesBands['B'].stCurrency  := oFromStockEx.stSalesBands['B'].stCurrency;
    oToStockEx.stSalesBands['B'].stPrice := oFromStockEx.stSalesBands['B'].stPrice;
    oToStockEx.stSalesBands['C'].stCurrency  := oFromStockEx.stSalesBands['C'].stCurrency;
    oToStockEx.stSalesBands['C'].stPrice := oFromStockEx.stSalesBands['C'].stPrice;
    oToStockEx.stSalesBands['D'].stCurrency  := oFromStockEx.stSalesBands['D'].stCurrency;
    oToStockEx.stSalesBands['D'].stPrice := oFromStockEx.stSalesBands['D'].stPrice;
    oToStockEx.stSalesBands['E'].stCurrency  := oFromStockEx.stSalesBands['E'].stCurrency;
    oToStockEx.stSalesBands['E'].stPrice := oFromStockEx.stSalesBands['E'].stPrice;
    oToStockEx.stSalesBands['F'].stCurrency  := oFromStockEx.stSalesBands['F'].stCurrency;
    oToStockEx.stSalesBands['F'].stPrice := oFromStockEx.stSalesBands['F'].stPrice;
    oToStockEx.stSalesBands['G'].stCurrency  := oFromStockEx.stSalesBands['G'].stCurrency;
    oToStockEx.stSalesBands['G'].stPrice := oFromStockEx.stSalesBands['G'].stPrice;
    oToStockEx.stSalesBands['H'].stCurrency  := oFromStockEx.stSalesBands['H'].stCurrency;
    oToStockEx.stSalesBands['H'].stPrice := oFromStockEx.stSalesBands['H'].stPrice;
    oToStockEx.stInclusiveVATCode  := oFromStockEx.stInclusiveVATCode;
    oToStockEx.stOperator  := oFromStockEx.stOperator;
    oToStockEx.stSupplier  := oFromStockEx.stSupplier;
    oToStockEx.stDefaultLineType  := oFromStockEx.stDefaultLineType;
    oToStockEx.stValuationMethod  := oFromStockEx.stValuationMethod;
    oToStockEx.stBarCode  := oFromStockEx.stBarCode;
    oToStockEx.stLocation  := oFromStockEx.stLocation;
    oToStockEx.stPricingMethod  := oFromStockEx.stPricingMethod;
    oToStockEx.stShowQtyAsPacks  := oFromStockEx.stShowQtyAsPacks;
    oToStockEx.stUseKitPrice  := oFromStockEx.stUseKitPrice;
    oToStockEx.stUserField1  := oFromStockEx.stUserField1;
    oToStockEx.stUserField2  := oFromStockEx.stUserField2;
    oToStockEx.stUserField3  := oFromStockEx.stUserField3;
    oToStockEx.stUserField4  := oFromStockEx.stUserField4;
    oToStockEx.stShowKitOnPurchase  := oFromStockEx.stShowKitOnPurchase;
    oToStockEx.stImageFile  := oFromStockEx.stImageFile;
    oToStockEx.stWebLiveCatalog  := oFromStockEx.stWebLiveCatalog;
    oToStockEx.stWebPrevCatalog  := oFromStockEx.stWebPrevCatalog;
    oToStockEx.stUseForEbus  := oFromStockEx.stUseForEbus;
    //oToStockEx.stLocationList  := oFromStockEx.stLocationList;
    //oToStockEx.stNotes  := oFromStockEx.stNotes;
    //oToStockEx.stQtyBreaks  := oFromStockEx.stQtyBreaks;
    //oToStockEx.stWhereUsed  := oFromStockEx.stWhereUsed;
    //oToStockEx.stSerialBatch  := oFromStockEx.stSerialBatch;

        {IStock2}
    oToStockEx.stQtyStockTake  := oFromStockEx.stQtyStockTake;
    oToStockEx.stWOPAssemblyDays  := oFromStockEx.stWOPAssemblyDays;
    oToStockEx.stWOPAssemblyHours  := oFromStockEx.stWOPAssemblyHours;
    oToStockEx.stWOPAssemblyMins  := oFromStockEx.stWOPAssemblyMins;
    oToStockEx.stWOPAutoCalcTime  := oFromStockEx.stWOPAutoCalcTime;
    oToStockEx.stWOPIssuedWIPGL  := oFromStockEx.stWOPIssuedWIPGL;
    oToStockEx.stWOPMinEconBuild  := oFromStockEx.stWOPMinEconBuild;
    oToStockEx.stWOPRoLeadTime  := oFromStockEx.stWOPRoLeadTime;
    oToStockEx.stUsesBins  := oFromStockEx.stUsesBins;
    oToStockEx.stShowKitOnSales  := oFromStockEx.stShowKitOnSales;
    //oToStockEx.stAltStockCode  := oFromStockEx.stAltStockCode;
    //oToStockEx.stMultiBin  := oFromStockEx.stMultiBin;
    //oToStockEx.stSalesAnalysis  := oFromStockEx.stSalesAnalysis;

        {IStock3}
    //oToStockEx.stEquivalent  := oFromStockEx.stEquivalent;
    //oToStockEx.stSupersededBy  := oFromStockEx.stSupersededBy;
    //oToStockEx.stOpportunity  := oFromStockEx.stOpportunity;

        {IStock4}
    oToStockEx.stSalesWarrantyLength  := oFromStockEx.stSalesWarrantyLength;
    oToStockEx.stSalesWarrantyUnits  := oFromStockEx.stSalesWarrantyUnits;
    oToStockEx.stManufacturerWarrantyLength  := oFromStockEx.stManufacturerWarrantyLength;
    oToStockEx.stManufacturerWarrantyUnits  := oFromStockEx.stManufacturerWarrantyUnits;
    oToStockEx.stSalesReturnGL  := oFromStockEx.stSalesReturnGL;
    oToStockEx.stPurchaseReturnGL  := oFromStockEx.stPurchaseReturnGL;
    oToStockEx.stRestockCharge  := oFromStockEx.stRestockCharge;
    oToStockEx.stRestockFlag  := oFromStockEx.stRestockFlag;

//    if oFromStockEx.stType = stTypeBillOfMaterials then CopyBOMComponents;

  finally
    oFromStockEx := nil;
    oToStockEx := nil;
  end;{try}
end;

procedure CopyNote(oNotesFrom, oNotesTo : INotes);
//var
//  iType, iStatus, iNote : integer;
//  oNote : INotes;
begin{CopyNotes}
  oNotesTo.ntType := oNotesFrom.ntType;
  oNotesTo.ntDate := oNotesFrom.ntDate;
  oNotesTo.ntText := oNotesFrom.ntText;
  oNotesTo.ntAlarmDate := oNotesFrom.ntAlarmDate;
  oNotesTo.ntAlarmSet := oNotesFrom.ntAlarmSet;
  oNotesTo.ntLineNo := oNotesFrom.ntLineNo;
  oNotesTo.ntOperator := oNotesFrom.ntOperator;
  oNotesTo.ntAlarmDays := oNotesFrom.ntAlarmDays;
  oNotesTo.ntAlarmUser := oNotesFrom.ntAlarmUser;
end;{CopyNotes}

function CopyStockNotes(sStockCodeFrom, sStockCodeTo : string; oToolkit : IToolkit) : integer;
var
  iLastPosition, iType, iStatus, iNote : integer;
  oNewNote : INotes;
begin{CopyNotes}

  For iType := ntTypeGeneral to ntTypeDated do // copy both types of notes
  begin
    Result := 0;
    oToolkit.Stock.Index := stIdxCode;

    // Get Stock Item to copy TO
    iStatus := oToolkit.Stock.GetEqual(oToolkit.Stock.BuildCodeIndex(sStockCodeTo));
    if iStatus <> 0 then
    begin
      Result := -1;
      exit;
    end else
    begin
      // Get an add object
      oToolkit.Stock.stNotes.ntType := iType;
      oNewNote := oToolkit.Stock.stNotes.Add;
      if oNewNote = nil then
      begin
        Result := -2;
        exit;
      end else
      begin
        // Get Stock Item to copy FROM
        iStatus := oToolkit.Stock.GetEqual(oToolkit.Stock.BuildCodeIndex(sStockCodeFrom));
        if iStatus <> 0 then
        begin
          Result := -3;
          exit;
        end else
        begin
          // Get first Note on FROM stock item
          oToolkit.Stock.stNotes.ntType := iType;
          iStatus := oToolkit.Stock.stNotes.GetFirst;
          // Save position of notes record
          oToolkit.Stock.stNotes.SavePosition;
          iLastPosition := oToolkit.Stock.stNotes.Position;

          while iStatus = 0 do
          begin
            // copy notes details
            CopyNote(oToolkit.Stock.stNotes, oNewNote);

            // save note
            iStatus := oNewNote.Save;

            if iStatus = 0 then
            begin
              // Get Stock Item to copy TO
              iStatus := oToolkit.Stock.GetEqual(oToolkit.Stock.BuildCodeIndex(sStockCodeTo));
              if iStatus = 0 then
              begin
                // Add a new note
                oToolkit.Stock.stNotes.ntType := iType;
                oNewNote := oToolkit.Stock.stNotes.Add;
                if oNewNote = nil then
                begin
                  Result := -4;
                  exit;
                end else
                begin
                  // Get Stock Item to copy FROM
                  oToolkit.Stock.GetEqual(oToolkit.Stock.BuildCodeIndex(sStockCodeFrom));

                  // Go back to the last note we copied
                  oToolkit.Stock.stNotes.ntType := iType;
                  oToolkit.Stock.stNotes.Position := iLastPosition;
                  oToolkit.Stock.stNotes.RestorePosition;

                  // Get the next note
                  iStatus := oToolkit.Stock.stNotes.GetNext;

                  // Save position of notes record
                  oToolkit.Stock.stNotes.SavePosition;
                  iLastPosition := oToolkit.Stock.stNotes.Position;
                end;{if}
              end;{if}
            end else
            begin
              // return result of the save error
              Result := iStatus;
              exit;
            end;{if}
          end;{while}
        end;{if}
      end;{if}
    end;{if}
  end;{for}
end;{CopyNotes}

procedure CopyBOMComponents(oFromStock, oToStock : IStock);
var
  iComp : integer;
begin{CopyBOMComponents}
  For iComp := 1 to oFromStock.stBillOfMaterials.blComponentCount do
  begin
    with oFromStock.stBillOfMaterials.blComponent[iComp] do
    begin
      oToStock.stBillOfMaterials.AddComponent(bmStockCode, bmQuantityUsed);
    end;{with}
  end;{for}
end;{CopyBOMComponents}

procedure FillVATCombo(oToolkit : IToolkit; cmbVATRate : TComboBox);
Const
  VATCodeList : Array [1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
var
  iPos : smallint;
  sPos : string;
//  TKVATRec : TBatchVATRec;
begin
  if (oToolkit.Status = tkOpen) then begin
    For iPos := Low(VATCodeList) To High(VATCodeList) Do begin
      sPos := VATCodeList[iPos];
      cmbVATRate.Items.AddObject(oToolkit.SystemSetup.ssVATRates[sPos].svDesc + ' ('
      + oToolkit.SystemSetup.ssVATRates[sPos].svCode + ')'
      ,TVATInfo.Create(oToolkit.SystemSetup.ssVATRates[sPos].svRate
      , oToolkit.SystemSetup.ssVATRates[sPos].svCode));
    end;{for}
    if cmbVATRate.Items.Count > 0 then cmbVATRate.ItemIndex := 0;
  end;{if}
end;
