unit PSUpliftPROC;

{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  StrUtil, CustABSU, Enterprise01_TLB, {TFile,}Classes, StdCtrls;

const
  GL_FIRSTCODE = 1;
  GL_CAT = 0;
//  GL_FREIGHT = 1;
//  GL_INSURANCE = 2;
//  GL_INTEREST = 3;
//  GL_DUTY = 4;
//  GL_CONTAINER = 5;
//  GL_HMC = 6;
//  GL_RHD = 7;
//  GL_LASTCODEBUTONE = 7;
  GL_ROUNDING = 11;
  GL_LASTCODE = GL_ROUNDING;
  GL_LASTCODEBUTONE = GL_ROUNDING-1;

//  aNoteDescs : array[GL_FIRSTCODE..GL_LASTCODEBUTONE] of string = ('FREIGHT=', 'INSURANCE='
//  , 'INTEREST=', 'DUTY=', 'CONTAINER=', 'HMC=', 'RH&D=');
//  aDescs : array[GL_FIRSTCODE..GL_LASTCODEBUTONE] of string = ('Freight', 'Insurance'
//  , 'Interest', 'Duty', 'Container', 'HMC', 'RH&D');
  sApportioned = 'Apportioned: See Matching Information';
  iApportionedNoteLineNo = GL_LASTCODE;
  sAPFPIINIFileName = 'APFPI.INI';

type
  TCompanyRec = Record
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;

{  TCompanyInfo = Class
    CompanyRec : TCompanyRec;
  end;}

  TSetupRec = Record
    CategoryUsed : Array[GL_FIRSTCODE..GL_LASTCODEBUTONE] of boolean;
    CategoryType : Array[GL_FIRSTCODE..GL_LASTCODEBUTONE] of char;
    GLCodes : Array[GL_FIRSTCODE..GL_LASTCODE] of longint;
    Descriptions : Array[GL_FIRSTCODE..GL_LASTCODEBUTONE] of string;
    sCostCentre : string3;
    sDepartment : string3;
    bLiveStock, bPurchasePostingWarning, bSalesPostingWarning, bReadDefaultValues, bShowQuantity, bShowValue, bShowWeight : boolean;
    iAllocateDefault : integer;
    iFreightUpliftGLCode : integer;
  end;

  TCompanyInfo = Class
    CompanyRec : TCompanyRec;
    bCurrentCompany : boolean;
  end;{with}

  TCurrencyInfo = Class
    CurrencyNo : integer;
  end;{with}

  procedure StartToolkit(LEventData : TAbsEnterpriseSystem);
  procedure FillCurrencyCombo(cmbCurrency : TComboBox; iDefaultCcy : integer);
//  function GetCustNameFromCode(sCustCode : string) : string;
//  function GetProdNameFromCode(sStockCode : string) : string;
//  procedure InitToolkit(cmbCompany : TComboBox);
  function ConvertCurrency(rValue : real; iFromCcy : integer; Transaction : ITransaction) : real;
  function GetStockWeight(sStockCode : string) : double;
  function GetAPFPIINISettings(sDataPath : string; bUseToolkit : boolean = TRUE) : boolean;

var
  SetupRec : TSetupRec;

implementation
uses
  inifiles, HandlerU, MathUtil, MiscUtil, SecCodes, Dialogs, BTConst, SysUtils, BTUtil, APIUtil, COMObj;

procedure StartToolkit(LEventData : TAbsEnterpriseSystem);
var
  a, b, c : LongInt;
  FuncRes : integer;

begin{StartToolkit}
  if oToolkit = nil then
  begin
    // Create COM Toolkit object
    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

    // Check it created OK
    If Assigned(oToolkit) Then Begin
      With oToolkit Do Begin
        EncodeOpCode(97, a, b, c);
        oToolkit.Configuration.SetDebugMode(a, b, c);

        oToolkit.Configuration.OverwriteTransactionNumbers := TRUE;

  //      oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;
        oToolkit.Configuration.AutoSetTransCurrencyRates := FALSE;

        // Open Default Company
        oToolkit.Configuration.DataDirectory := LEventData.Setup.ssDataPath;
        FuncRes := OpenToolkit;

        // Check it opened OK
        If (FuncRes = 0) then {DoUpdates}
        else begin
          // Error opening Toolkit - display error
          ShowMessage ('The following error occurred opening the Toolkit:-'#13#13
          + QuotedStr(oToolkit.LastErrorString));
        end;{if}

      End; { With OToolkit }

    End { If Assigned(oToolkit) }
    Else
      // Failed to create COM Object
      ShowMessage ('Cannot create COM Toolkit instance');
  end;{if}
end;{StartToolkit}

procedure FillCurrencyCombo(cmbCurrency : TComboBox; iDefaultCcy : integer);
var
  iSelected, iPos : integer;
  sCurrChar : string;
  CurrencyInfo : TCurrencyInfo;
begin
  ClearList(cmbCurrency.Items);
  iSelected := 0;
//  cmbCurrency.Items.Add('(no currency selected)');
  For iPos := 1 to oToolkit.SystemSetup.ssMaxCurrency do begin
    if Trim(oToolkit.SystemSetup.ssCurrency[iPos].scDesc) <> '' then begin
      // get correct currency char
      sCurrChar := oToolkit.SystemSetup.ssCurrency[iPos].scSymbol;
      if sCurrChar = #156 then sCurrChar := '£';

      CurrencyInfo := TCurrencyInfo.Create;
      CurrencyInfo.CurrencyNo := iPos;
      cmbCurrency.Items.AddObject(IntToStr(iPos) + ' - ' + oToolkit.SystemSetup.ssCurrency[iPos].scDesc
      + ' (' + sCurrChar + ')', CurrencyInfo);

      if iPos = iDefaultCcy then iSelected := cmbCurrency.Items.count -1;
    end;
  end;{for}

  if cmbCurrency.Items.Count > 0 then cmbCurrency.Itemindex := iSelected;
end;
(*
function GetCustNameFromCode(sCustCode : string) : string;
begin
  with oToolkit.Customer do begin
    Index := acIdxCode;
    if GetEqual(BuildCodeIndex(sCustCode)) = 0
    then Result := acCompany
    else Result := '';
  end;{with}
end;

function GetProdNameFromCode(sStockCode : string) : string;
begin
  Result := '';
  with oToolkit.Stock do begin
    Index := stIdxCode;
    if GetEqual(BuildCodeIndex(sStockCode)) = 0
    then begin
      if (stType in [stTypeProduct, stTypeDescription, stTypeBillOfMaterials])
      then begin
        Result := stDesc[1];
      end;
    end;{if}
  end;{with}
end;

procedure InitToolkit(cmbCompany : TComboBox);
var
  iSelectIndex, iPos : integer;
  CompanyInfo : TCompanyInfo;
  a, b, c : LongInt;
begin{InitToolkit}
  // Create COM Toolkit object
  oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin

    EncodeOpCode(97, a, b, c);
    oToolkit.Configuration.SetDebugMode(a, b, c);
    oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;

    if (cmbCompany <> nil) then
    begin
      iSelectIndex := 0;
      For iPos := 1 to oToolkit.Company.cmCount do begin
        CompanyInfo := TCompanyInfo.Create;
        CompanyInfo.CompanyRec.Path := Trim(oToolkit.Company.cmCompany[iPos].coPath);
        CompanyInfo.CompanyRec.Name := Trim(oToolkit.Company.cmCompany[iPos].coName);
        CompanyInfo.CompanyRec.Code := Trim(oToolkit.Company.cmCompany[iPos].coCode);
        cmbCompany.Items.AddObject(oToolkit.Company.cmCompany[iPos].coName, CompanyInfo);

        if oToolkit.Enterprise.enRunning
        and ((uppercase(CompanyInfo.CompanyRec.Path)) = (uppercase(Trim(oToolkit.Enterprise.enCompanyPath))))
        then iSelectIndex := iPos -1;
      end;{for}

      // select current or first company
      cmbCompany.ItemIndex := iSelectIndex;
  //    cmbCompanyChange(cmbCompany);
      cmbCompany.OnChange(cmbCompany);;
    end;{if}

  End { If Assigned(oToolkit) }
  Else
    // Failed to create COM Object
    ShowMessage ('Cannot create COM Toolkit instance');
end;{InitToolkit}
*)

// MH 27/08/2015 ABSEXGENERIC-384: Modified to use Transaction Rates for currency conversions
// Converts a value in a specified currency to the Transaction currency using the Transaction's
// own rates where possible 
function ConvertCurrency(rValue : real; iFromCcy : integer; Transaction : ITransaction) : real;
begin
  if iFromCcy = Transaction.thCurrency then
    // Already in transaction currency
    Result := rValue
  else
  begin
    // Need to convert between currencies - start by getting to Base (if not already there)
    If (iFromCcy > 1) Then
      // Convert to Base/Consolidated Currency using Live System Rates
      Result := oToolkit.Functions.entConvertAmount(rValue, iFromCcy, 0, oToolkit.SystemSetup.ssCurrencyRateType)
    Else
      // Already in Base/Consolidated
      Result := rValue;

    // Next convert the Base/Consolidated to Transaction Currency using the Transaction Rate
    Result := oToolkit.Functions.entConvertAmountWithRates(Result,                     // Amount
                                                           False,                      // ConvertToBase
                                                           Transaction.thCurrency,     // RateCurrency
                                                           Transaction.thCompanyRate,  // CompanyRate
                                                           Transaction.thDailyRate);   // DailyRate
  end;{if}
end;

function GetStockWeight(sStockCode : string) : double;
var
  iStatus : integer;
begin
  oToolkit.Stock.Index := stIdxCode;
  iStatus := oToolkit.Stock.GetEqual(oToolkit.Stock.BuildCodeIndex(sStockCode));
  if iStatus = 0 then Result := oToolkit.Stock.stIntrastat.stSSDPurchaseUnitWeight
  else Result := 0;
end;

function GetAPFPIINISettings(sDataPath : string; bUseToolkit : boolean = TRUE) : boolean;
var
  TheInifile : TInifile;
  sType, sSection : string;
  iCategory, iPos : integer;
begin{GetAPFPIINISettings}
  Result := TRUE;
//    TheInifile := TInifile.Create(ExtractFilePath(Application.Exename) + sInifileName);
  TheInifile := TInifile.Create(IncludeTrailingPathDelimiter(Trim(sDataPath)) + sAPFPIINIFileName);
  with SetupRec do
  begin
    For iCategory := GL_CAT+1 to GL_CAT+10 do
    begin
      sSection := 'UPLIFTCAT' + PadString(psLeft, IntToStr(iCategory), '0', 2);
      CategoryUsed[iCategory] := TheInifile.SectionExists(sSection);
      sType := Trim(TheInifile.ReadString(sSection, 'Type', 'V'));
      if Length(sType) >= 1 then CategoryType[iCategory] := sType[1];
      GLCodes[iCategory] := TheInifile.ReadInteger(sSection, 'GL', 0);
      Descriptions[iCategory] := TheInifile.ReadString(sSection, 'Description', '');
    end;{for}
    GLCodes[GL_ROUNDING] := TheInifile.ReadInteger('Settings', 'RoundingGL', 0);
    sCostCentre  := TheInifile.ReadString('Settings',' CostCentre', '');
    sDepartment := TheInifile.ReadString('Settings', 'Department', '');
    bReadDefaultValues := TheInifile.ReadInteger('Settings', 'ReadDefaultValues', 0) = 1;
    if bUseToolkit then bLiveStock := oToolkit.SystemSetup.ssLiveStockCOSVal;
    if bUseToolkit then iFreightUpliftGLCode  := TheInifile.ReadInteger('Settings', 'FreightUpliftGL', oToolkit.SystemSetup.ssGLCtrlCodes[ssGLFreightUplift]);
    bPurchasePostingWarning := TheInifile.ReadInteger('Settings', 'PurchasePostingWarning', 1) = 1;
    bSalesPostingWarning := TheInifile.ReadInteger('Settings', 'SalesPostingWarning', 0) = 1;

    bShowQuantity := TheInifile.ReadString('AllocateBy','ShowQuantity','1') = '1';
    bShowValue := TheInifile.ReadString('AllocateBy','ShowValue','1') = '1';
    bShowWeight := TheInifile.ReadString('AllocateBy','ShowWeight','1') = '1';
    iAllocateDefault := TheInifile.ReadInteger('AllocateBy','Default',1);

    if (iAllocateDefault = 1) and (not bShowQuantity) then Result := FALSE;
    if (iAllocateDefault = 2) and (not bShowValue) then Result := FALSE;
    if (iAllocateDefault = 3) and (not bShowWeight) then Result := FALSE;
    if not Result then exit;

    if bUseToolkit then
    begin
      with oToolkit do
      begin
        // Check GL Codes
        oToolkit.GeneralLedger.Index := glIdxCode;
        For iPos := GL_FIRSTCODE to GL_LASTCODE do
        begin
          if (iPos = GL_ROUNDING) or CategoryUsed[iPos] then
          begin
            if GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(GLCodes[iPos])) <> 0
            then begin
              Result := FALSE;
              break;
            end;{if}
          end;{if}
        end;{for}

        // Check Freight Uplift
        if GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(iFreightUpliftGLCode)) <> 0
        then Result := FALSE;

        // Check CostCentre
        oToolkit.CostCentre.Index := cdIdxCode;
        if oToolkit.CostCentre.GetEqual(oToolkit.CostCentre.BuildCodeIndex(sCostCentre)) <> 0
        then Result := FALSE;

        // Check Department
        oToolkit.Department.Index := cdIdxCode;
        if oToolkit.Department.GetEqual(oToolkit.Department.BuildCodeIndex(sDepartment)) <> 0
        then Result := FALSE;
      end;{with}
    end;{if}
    TheInifile.Free;
  end;{with}
end;{GetAPFPIINISettings}

initialization
  oToolkit := nil;

finalization

end.
