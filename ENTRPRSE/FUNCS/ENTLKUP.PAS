unit EntLkup;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

// Notes: Wrapper code around Exchequer code lookup routines

interface

uses
  Classes, StrUtil, GlobVar;

type
  TValidationMode = (vmShowList, vmCheckValue);

  {Note : the order of the items in TCustIndex needs to be preserved}
  TCustIndex = (ciAccountCode, ciAccountName, ciTaxCode, ciPhoneNo, ciAltCode, ciCSCode
  ,ciCSCompany, ciCSAltCustCode, ciPostCode, ciTheirCode, ciInvoiceTo, ciEmailAddress, ciNone);

  {Note : the order of the items in TStockIndex needs to be preserved}
  TStockIndex = (siStockCode, siStockFolio, siStockGroup, siStockDesc, siSupplier, siStockValNom
  ,siAltStockCode, siBinLocation, siBarCode, siNone, siAltSupplierCode);

  TTraderType = (trdCustomer, trdSupplier, trdEither);
  TStockType = (stkGroup, stkProduct, stkDelisted, stkBOM);
  TNomType = (nomProfitAndLoss, nomBalanceSheet, nomControl, nomHeading, nomCarryForward);
  TAnalysisType = (jaRevenue, jaOverheads, jaMaterials, jaLabour);

  TStockTypeSet = Set of TStockType;
  TNomTypeSet = Set of TNomType;
  TAnalysisTypeSet = Set of TAnalysisType;

function DoGetCust(AOwner : TComponent; sCompPath : string; const sCodeSearch : str20;
                   var sCodeFound : str20; TraderType : TTraderType;
                   ValidationMode : TValidationMode; bOpenClose : boolean;
                   CustIndex : TCustIndex = ciAccountCode) : boolean;

function DoGetCCDep(AOwner : TComponent; sCompPath : string;
                    const sCodeSearch : str20; var sCodeFound : str20;
                    bIsCC : boolean; ValidationMode : TValidationMode;
                    bOpenClose : boolean) : boolean;

function DoGetMLoc(AOwner : TComponent; sCompPath : string;
                   const sCodeSearch : string10; var sCodeFound : string10;
                   ValidationMode : TValidationMode;
                   bOpenClose : boolean) : boolean;

function DoGetNom(AOwner : TComponent; sCompPath : string; sCodeSearch : str20;
                  var iCodeFound : longint; NomType : TNomTypeSet;
                  ValidationMode : TValidationMode; bOpenClose : boolean) : boolean;

function DoGetJobCode(AOwner : TComponent; CompPath : string; CodeSearch : str20;
                      var CodeFound : str20; ValidationMode : TValidationMode;
                      OpenClose : boolean) : boolean;

function DoGetJobAnalysis(AOwner : TComponent; CompPath : string; CodeSearch : str20;
           var CodeFound : str20; AnalysisType : TAnalysisTypeSet;
           ValidationMode : TValidationMode; OpenClose : boolean) : boolean;

function DoGetStock(AOwner : TComponent; CompPath : string; CodeSearch : str20;
                     var CodeFound : str20; StockType : TStockTypeSet;
                     ValidationMode : TValidationMode; OpenClose : boolean;
                     StockIndex : TStockIndex = siStockCode) : boolean;

implementation

uses
  InvListU, VarConst, Varrec2U, BtrvU2;

//-----------------------------------------------------------------------

function OpenMiscFile(const Path : string) : boolean;
// Notes : Misc file used for storage of screen coordinates which the lookup dialogs
//         seem to require.
var
  FSpec : FileSpec;
begin
  Result := false;
  // Potentially MiscF could be open for the wrong company but this shouldn't
  // cause any problems in this context?
  if GetFileSpec(F[MiscF], MiscF, FSpec) <> 0 then
    Result := Open_File(F[MiscF], Path + FileNames[MiscF], 0) = 0;
end;

//-----------------------------------------------------------------------

procedure CloseMiscFile;
begin
  Close_File(F[MiscF]);
end;

//-----------------------------------------------------------------------

function DoGetCust(AOwner : TComponent; sCompPath : string; const sCodeSearch : str20;
                   var sCodeFound : str20; TraderType : TTraderType;
                   ValidationMode : TValidationMode; bOpenClose : boolean;
                   CustIndex : TCustIndex = ciAccountCode) : boolean;
var
  MiscFileOpened : boolean;
begin
  Result := FALSE;
  if (not bOpenClose) or (bOpenClose and (Open_File(F[CustF], sCompPath + FileNames[CustF], 0) = 0))
  then begin
    MiscFileOpened := OpenMiscFile(sCompPath);
    if TraderType = trdEither then
      begin
        {Validation only - not supported by GetCust}
        Result := GetCust(AOwner, sCodeSearch, sCodeFound, TRUE, 99, Ord(CustIndex));
      end
    else begin
      Result := GetCust(AOwner, sCodeSearch, sCodeFound, (TraderType = trdCustomer), -1, Ord(CustIndex));
      if (not Result) and (ValidationMode = vmShowList) then Result := GetCust(AOwner, sCodeSearch, sCodeFound, (TraderType = trdCustomer), 0, Ord(CustIndex));
    end;{if}
    if bOpenClose then Close_File(F[CustF]);
    if MiscFileOpened then CloseMiscFile;
  end;{if}
end;

//-----------------------------------------------------------------------

function DoGetCCDep(AOwner : TComponent; sCompPath : string; const sCodeSearch : str20;
                    var sCodeFound : str20; bIsCC : boolean;
                    ValidationMode : TValidationMode; bOpenClose : boolean) : boolean;
var
  MiscFileOpened : boolean;
begin
  Result := FALSE;
  if (not bOpenClose) or (bOpenClose and (Open_File(F[PwrdF], sCompPath + FileNames[PWrdF], 0) = 0))
  then begin
    MiscFileOpened := OpenMiscFile(sCompPath);
    Result := GetCCDep(AOwner, sCodeSearch, sCodeFound, bIsCC, -1);
    if (not Result) and (ValidationMode = vmShowList) then Result := GetCCDep(AOwner, sCodeSearch, sCodeFound, bIsCC, 0);
    if bOpenClose then Close_File(F[PWrdF]);
    if MiscFileOpened then CloseMiscFile;
  end;{if}
end;

//-----------------------------------------------------------------------

function DoGetMLoc(AOwner : TComponent; sCompPath : string; const sCodeSearch : string10;
                   var sCodeFound : string10; ValidationMode : TValidationMode;
                   bOpenClose : boolean) : boolean;
var
  MiscFileOpened : boolean;
begin
  Result := FALSE;
  if (not bOpenClose) or (bOpenClose and (Open_File(F[MLocF], sCompPath + FileNames[MLocF], 0) = 0))
  then begin
    MiscFileOpened := OpenMiscFile(sCompPath);
    Result := GetMLoc(AOwner, sCodeSearch, sCodeFound, '', -1);
    if (not Result) and (ValidationMode = vmShowList) then Result := GetMLoc(AOwner, sCodeSearch, sCodeFound, '', 0);
    if bOpenClose then Close_File(F[MLocF]);
    if MiscFileOpened then CloseMiscFile;
  end;{if}
end;

//-----------------------------------------------------------------------

function DoGetNom(AOwner : TComponent; sCompPath : string; sCodeSearch : str20;
                  var iCodeFound : longint; NomType : TNomTypeSet;
                  ValidationMode : TValidationMode; bOpenClose : boolean) : boolean;
var
  MiscFileOpened : boolean;
  Mode : shortint;
begin
  if (not bOpenClose) or (bOpenClose and
    (Open_File(F[NomF], sCompPath + FileNames[NomF] ,0) = 0)) then
  begin
    MiscFileOpened := OpenMiscFile(sCompPath);
    // Default of
    // [nomProfitAndLoss, nomBalanceSheet, nomControl, nomHeading, nomCarryForward]

    if ValidationMode = vmCheckValue then Mode := -1
    else begin
      Mode := 99;
      if NomType = [nomProfitAndLoss, nomBalanceSheet] then
        Mode := 0;
      if NomType = [nomHeading] then
        Mode := 1;
      if NomType = [nomProfitAndLoss, nomBalanceSheet, nomControl] then
        Mode := 5;
      if NomType = [nomBalanceSheet, nomControl] then
        Mode := 77;
      if NomType = [nomControl] then
        Mode := 79;
    end;{if}

    Result := GetNom(AOwner, sCodeSearch, iCodeFound, Mode);
    if bOpenClose then
      Close_File(F[NomF]);
    if MiscFileOpened then CloseMiscFile;
  end;{if}
end;

//-----------------------------------------------------------------------

function DoGetJobCode(AOwner : TComponent; CompPath : string; CodeSearch : str20;
           var CodeFound : str20; ValidationMode : TValidationMode;
           OpenClose : boolean) : boolean;
var
  MiscFileOpened : boolean;
  Mode : shortint;
begin
  if (not OpenClose) or
    (OpenClose and (Open_File(F[JobF], CompPath + FileNames[JobF], 0) = 0)) then
  begin
    MiscFileOpened := OpenMiscFile(CompPath);
    case ValidationMode of
      vmShowList : Mode := 0;
      vmCheckValue : Mode := -1;
    end;
    Result := GetJob(AOwner, CodeSearch, CodeFound, Mode);
    if OpenClose then
      Close_File(F[JobF]);
    if MiscFileOpened then CloseMiscFile;
  end;
end;

//-----------------------------------------------------------------------

function DoGetJobAnalysis(AOwner : TComponent; CompPath : string; CodeSearch : str20;
           var CodeFound : str20; AnalysisType : TAnalysisTypeSet;
           ValidationMode : TValidationMode; OpenClose : boolean) : boolean;
var
  MiscFileOpened : boolean;
  JobMode,
  Mode : shortint;
begin
  if (not OpenClose) or
    (OpenClose and (Open_File(F[JMiscF], CompPath + FileNames[JMiscF], 0) = 0)) then
  begin
    MiscFileOpened := OpenMiscFile(CompPath);
    case ValidationMode of
      vmShowList :
      begin
        Mode := 99; // Default of [jaRevenue, jaOverheads, jaMaterials, jaLabour]
        if AnalysisType = [jaRevenue] then
          Mode := 1;
        if AnalysisType = [jaMaterials] then
          Mode := 2;
        if AnalysisType = [jaLabour, jaOverheads, jaMaterials] then
          Mode := 3;
        if AnalysisType = [jaLabour, jaOverheads] then
          Mode := 4;
      end;
      vmCheckValue : Mode := -1;
    end;
    // JobMode = 1 => Job types
    // JobMode = 2 => Job analysis
    // JobMode = 3 => Job actuals
    JobMode := 2;
    Result := GetJobMisc(AOwner, CodeSearch, CodeFound, JobMode, Mode);

    if OpenClose then
      Close_File(F[JMiscF]);
    if MiscFileOpened then CloseMiscFile;
  end;
end;

//-----------------------------------------------------------------------

function DoGetStock(AOwner : TComponent; CompPath : string; CodeSearch : str20;
                     var CodeFound : str20; StockType : TStockTypeSet;
                     ValidationMode : TValidationMode; OpenClose : boolean;
                     StockIndex : TStockIndex = siStockCode) : boolean;
var
  MiscFileOpened : boolean;
  Mode : shortint;
begin
  if (not OpenClose) or
    (OpenClose and (Open_File(F[StockF], CompPath + FileNames[StockF], 0) = 0) and
    (Open_File(F[MLocF], CompPath + FileNames[MLocF], 0) = 0)) then
  begin
    MiscFileOpened := OpenMiscFile(CompPath);
    case ValidationMode of
      vmShowList :
      begin
        Mode := 99; // Default of [stkGroup, stkBOM, stkProduct, stkDelisted]
        if StockType = [stkGroup] then
          Mode := 1;
        if StockType = [stkBOM] then
          Mode := 2;
        if StockType = [stkProduct, stkBOM] then
          Mode := 3;
        if StockType = [stkGroup, stkProduct, stkBOM] then
          Mode := 4;
        if StockType = [stkProduct, stkDelisted, stkBOM] then
          Mode := 0;
      end;
      vmCheckValue : Mode := -1;
    end;
    Result := GetStock(AOwner, CodeSearch, CodeFound, Mode, Ord(StockIndex));

    if OpenClose then begin
      Close_File(F[StockF]);
      Close_File(F[MLocF]);
    end;{if}

    if MiscFileOpened then CloseMiscFile;
  end;
end;

//-----------------------------------------------------------------------

end.


