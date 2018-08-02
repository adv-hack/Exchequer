unit AddNomPROC;

{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  Controls, Graphics, StrUtil, {CustABSU,} Enterprise01_TLB, Classes, StdCtrls;

const
  GL_FIRSTCODE = 1;
  GL_COMMISSION = 1;
  GL_IMPORTDUTY = 2;
  GL_FREIGHT = 3;
  GL_TICKETING = 4;
  GL_PROCESSING = 5;
  GL_ROUNDING = 6;
  GL_LASTCODE = 6;

  ERROR_COLOR = $00F0E1FF;

  aNotes : array[GL_COMMISSION..GL_PROCESSING] of string = ('COMMISSION=', 'IMPORT='
  , 'FREIGHT=', 'TICKET=', 'PROCESS=');
  aDescs : array[GL_COMMISSION..GL_PROCESSING] of string = ('Commission', 'Import Duty'
  , 'Freight', 'Ticketing', 'Processing');
  sApportioned = 'Apportioned: See Matching Information';

type
  ValidationRec = Record
    FieldControl : TWinControl;
    FieldOK : boolean;
    Description : string;
  end;

  TVATInfo = class
    rRate : real;
    cCode : string;
    constructor create(Rate : real; Code : string);
  end;

  TCompanyRec = Record
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;

  TSetupRec = Record
    GLCodes : Array[GL_FIRSTCODE..GL_LASTCODE] of longint;
    sCostCentre : string3;
    sDepartment : string3;
  end;

  TCompanyInfo = Class
    CompanyRec : TCompanyRec;
    bCurrentCompany : boolean;
  end;{with}

  TCurrencyInfo = Class
    CurrencyNo : integer;
    Rate : real;
  end;{with}

  procedure StartToolkit(sPath : string);
  procedure FillCurrencyCombo(cmbCurrency : TComboBox; iDefaultCcy : integer);
  function GetCustNameFromCode(sCustCode : string) : string;
  function GetProdNameFromCode(sStockCode : string) : string;
  procedure InitToolkit(cmbCompany : TComboBox);
  function ConvertCurrency(rValue : real; iFromCcy, iToCcy : integer) : real;
  function ValidateGLCode(TheEdit : TEdit) : IGeneralLedger;
  function ValidateCostCentre(TheEdit : TEdit) : ICCDept;
  function ValidateDepartment(TheEdit : TEdit) : ICCDept;

var
  oToolkit : IToolkit;
  CompanyRec : TCompanyRec;
  SetupRec : TSetupRec;

implementation
uses
  MathUtil, MiscUtil, SecCodes, Dialogs, BTConst, SysUtils, BTUtil, APIUtil, COMObj;

constructor TVATInfo.Create(Rate : real; Code : string);
begin
  inherited create;
  rRate := Rate;
  cCode := Code;
end;

procedure StartToolkit(sPath : string);
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
        oToolkit.Configuration.DataDirectory := sPath;
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

      case oToolkit.SystemSetup.ssCurrencyRateType of
        rtCompany : CurrencyInfo.Rate := oToolkit.SystemSetup.ssCurrency[iPos].scCompanyRate;
        rtDaily : CurrencyInfo.Rate := oToolkit.SystemSetup.ssCurrency[iPos].scDailyRate;
      end;{case}

      cmbCurrency.Items.AddObject(IntToStr(iPos) + ' - ' + oToolkit.SystemSetup.ssCurrency[iPos].scDesc
      + ' (' + sCurrChar + ')', CurrencyInfo);

      if iPos = iDefaultCcy then iSelected := cmbCurrency.Items.count -1;
    end;
  end;{for}

  if cmbCurrency.Items.Count > 0 then cmbCurrency.Itemindex := iSelected;
end;

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

function ConvertCurrency(rValue : real; iFromCcy, iToCcy : integer) : real;
begin
  if iFromCcy = iToCcy then
  begin
    Result := rValue;
  end else
  begin
    Result := oToolkit.Functions.entConvertAmount(rValue
    ,iFromCcy, iToCcy, oToolkit.SystemSetup.ssCurrencyRateType);
  end;{if}
end;

function ValidateGLCode(TheEdit : TEdit) : IGeneralLedger;
begin{ValidateGLCode}
  with oToolkit.GeneralLedger do begin
    Index := glIdxCode;
    if GetEqual(BuildCodeIndex(StrToIntDef(TheEdit.Text,0))) = 0 then
    begin
      Result := oToolkit.GeneralLedger;
      TheEdit.Hint := oToolkit.GeneralLedger.glName;
      TheEdit.Color := clWindow;
    end else
    begin
      Result := nil;
      TheEdit.Hint := '';
      TheEdit.Color := ERROR_COLOR;
    end;{if}
  end;{with}
end;{ValidateGLCode}

function ValidateCostCentre(TheEdit : TEdit) : ICCDept;
begin{ValidateCostCentre}
  with oToolkit.CostCentre do begin
    Index := cdIdxCode;
    if GetEqual(BuildCodeIndex(TheEdit.Text)) = 0 then
    begin
      Result := oToolkit.CostCentre;
      TheEdit.Hint := oToolkit.CostCentre.cdName;
      TheEdit.Color := clWindow;
    end else
    begin
      Result := nil;
      TheEdit.Hint := '';
      TheEdit.Color := ERROR_COLOR;
    end;
  end;{with}
end;{ValidateCostCentre}

function ValidateDepartment(TheEdit : TEdit) : ICCDept;
begin{ValidateDepartment}
  with oToolkit.Department do begin
    Index := cdIdxCode;
    if GetEqual(BuildCodeIndex(TheEdit.Text)) = 0 then
    begin
      Result := oToolkit.Department;
      TheEdit.Hint := oToolkit.Department.cdName;
      TheEdit.Color := clWindow;
    end else
    begin
      Result := nil;
      TheEdit.Hint := '';
      TheEdit.Color := ERROR_COLOR;
    end;
  end;{with}
end;{ValidateDepartment}


initialization
  oToolkit := nil;

finalization

end.
