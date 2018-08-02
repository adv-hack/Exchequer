unit AddNomPROC;
{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface
uses
  TKPICKLIST04, Controls, Graphics, StrUtil, Enterprise04_TLB, Classes, StdCtrls;

const
  ERROR_COLOR = $00F0E1FF;

  F_BANK_ACCOUNT = 1;
  F_BANK_TO = 2;
  F_COSTCENTRE = 3;
  F_DEPARTMENT = 4;
  F_TRANSFER_VALUE = 5;
//  F_DESCRIPTION = 6;
//  F_CURRENCY_RATE = 7;
  F_CURRENCY_RATE = 6;
  F_DESCRIPTION = 7;
  F_PAY_IN_REF = 8;

  TH_NO_OF_FIELDS_TO_STORE = 8;
//  TH_NO_OF_FIELDS_TO_VALIDATE = 5;
  TH_NO_OF_FIELDS_TO_VALIDATE = 6;

  MAX_VALUE = 1000000000000;

type
  ValidationRec = Record
    FieldControl : TWinControl;
    FieldOK : boolean;
    Description : string;
  end;

  TVATInfo = class
    rRate : real;
    cCode : char;
    constructor create(Rate : real; Code : char);
  end;

  TCurrencyInfo = Class
    CurrencyNo : integer;
    Rate : real;
  end;{with}

  procedure StartToolkit(sPath : string);
  procedure FillCurrencyCombo(cmbCurrency : TComboBox; iDefaultCcy : integer);
  function ValidateGLCode(TheEdit : TEdit; iGLCurrency : integer; bBankAccountsOnly : boolean) : IGeneralLedger2;
  function ValidateCostCentre(TheEdit : TEdit) : ICCDept2;
  function ValidateDepartment(TheEdit : TEdit) : ICCDept2;
  procedure ColorEditBox(TheEdit : TEdit; clColor : TColor);

var
  oToolkit : IToolkit;
  aPreviousField : array [1..TH_NO_OF_FIELDS_TO_STORE] of string;

implementation
uses
  Windows, MathUtil, MiscUtil, SecCodes, Dialogs, BTConst, SysUtils, BTUtil
  , APIUtil, Messages, COMObj;


constructor TVATInfo.Create(Rate : real; Code : char);
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
    oToolkit := CreateOLEObject('Enterprise04.Toolkit') as IToolkit;

    // Check it created OK
    If Assigned(oToolkit) Then Begin
      With oToolkit Do Begin
        // Backdoor
        EncodeOpCode(97, a, b, c);
        oToolkit.Configuration.SetDebugMode(a, b, c);

        // Set Configuration
        oToolkit.Configuration.OverwriteTransactionNumbers := TRUE;
        oToolkit.Configuration.AllowTransactionEditing	:= TRUE;
        oToolkit.Configuration.AutoSetPeriod := FALSE;
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
  // Initialise
  ClearList(cmbCurrency.Items);
  iSelected := 0;

  // Go through all available currencies
  For iPos := 1 to oToolkit.SystemSetup.ssMaxCurrency do begin
    if Trim(oToolkit.SystemSetup.ssCurrency[iPos].scDesc) <> '' then begin

      // get correct currency char
      sCurrChar := oToolkit.SystemSetup.ssCurrency[iPos].scSymbol;
      if sCurrChar = #156 then sCurrChar := '£';

      // Create Object to add to combo
      CurrencyInfo := TCurrencyInfo.Create;
      CurrencyInfo.CurrencyNo := iPos;

      // Get correct Rate
      case oToolkit.SystemSetup.ssCurrencyRateType of
        rtCompany : CurrencyInfo.Rate := oToolkit.SystemSetup.ssCurrency[iPos].scCompanyRate;
        rtDaily : CurrencyInfo.Rate := oToolkit.SystemSetup.ssCurrency[iPos].scDailyRate;
      end;{case}

      // Add Item to combo
      cmbCurrency.Items.AddObject(IntToStr(iPos) + ' - ' + oToolkit.SystemSetup.ssCurrency[iPos].scDesc
      + ' (' + sCurrChar + ')', CurrencyInfo);

      // store default currency index
      if iPos = iDefaultCcy then iSelected := cmbCurrency.Items.count -1;
    end;
  end;{for}

  // Select default currency
  if cmbCurrency.Items.Count > 0 then cmbCurrency.Itemindex := iSelected;
end;

function ValidateGLCode(TheEdit : TEdit; iGLCurrency : integer; bBankAccountsOnly : boolean) : IGeneralLedger2;
begin{ValidateGLCode}
  with oToolkit.GeneralLedger do begin
    Index := glIdxCode;
    if (GetEqual(BuildCodeIndex(StrToIntDef(TheEdit.Text,0))) = 0) // GL Code Found
    and ((not bBankAccountsOnly) or ((oToolkit.GeneralLedger as IGeneralLedger2).glClass = glcBankAccount)) // GLCode is of the correct "class"
    and ((iGLCurrency = glccyANY_CURRENCY) or (oToolkit.GeneralLedger.glCurrency = iGLCurrency) or (oToolkit.GeneralLedger.glCurrency = glccyCONSOLIDATED)) then // GLCode is of the correct currency
    begin
      // Return GL Object, and color field with the default colour
      Result := oToolkit.GeneralLedger as IGeneralLedger2;
      TheEdit.Hint := glName;
//      TheEdit.Color := clWindow;
      ColorEditBox(TheEdit, clWindow);
    end else
    begin
      // Return nothing, and color field with the error colour
      Result := nil;
      TheEdit.Hint := '';
//      TheEdit.Color := ERROR_COLOR;
      ColorEditBox(TheEdit, ERROR_COLOR);
    end;{if}
  end;{with}
end;{ValidateGLCode}

function ValidateCostCentre(TheEdit : TEdit) : ICCDept2;
begin{ValidateCostCentre}
  // Return nothing, and color field with the error colour
  Result := nil;
  TheEdit.Hint := '';
//  TheEdit.Color := ERROR_COLOR;
  ColorEditBox(TheEdit, ERROR_COLOR);

  with oToolkit.CostCentre do begin
    Index := cdIdxCode;
    if GetEqual(BuildCodeIndex(TheEdit.Text)) = 0 then
    begin
      if not (oToolkit.CostCentre as ICCDept2).cdInactive then
      begin
        // Return CC Object, and color field with the default colour
        Result := (oToolkit.CostCentre as ICCDept2);
        TheEdit.Hint := cdName;
//        TheEdit.Color := clWindow;
        ColorEditBox(TheEdit, clWindow);
      end;{if}
    end;{if}
  end;{with}
end;{ValidateCostCentre}

function ValidateDepartment(TheEdit : TEdit) : ICCDept2;
begin{ValidateDepartment}
  // Return nothing, and color field with the error colour
  Result := nil;
  TheEdit.Hint := '';
//  TheEdit.Color := ERROR_COLOR;
  ColorEditBox(TheEdit, ERROR_COLOR);

  with oToolkit.Department do begin
    Index := cdIdxCode;
    if GetEqual(BuildCodeIndex(TheEdit.Text)) = 0 then
    begin
      if not (oToolkit.Department as ICCDept2).cdInactive then
      begin
        // Return Dept Object, and color field with the default colour
        Result := (oToolkit.Department as ICCDept2);
        TheEdit.Hint := cdName;
//        TheEdit.Color := clWindow;
        ColorEditBox(TheEdit, clWindow);
      end;{if}
    end;{if}
  end;{with}
end;{ValidateDepartment}

procedure ColorEditBox(TheEdit : TEdit; clColor : TColor);
begin
  TheEdit.Color := clColor;
  PostMessage(TheEdit.Handle, WM_MOUSEMOVE, 0, 0);
end;

initialization
  oToolkit := nil;
  FillChar(aPreviousField, SizeOf(aPreviousField),#0);

end.
