unit oConfig;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }
{$WARN SYMBOL_PLATFORM OFF}

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     SysConst, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarConst,
     //PR: 03/11/2011 v6.9
     EnterpriseBeta_TLB, ExceptIntf;

type
  TConfiguration = class(TAutoIntfObjectEx, IConfiguration, IConfiguration2, IConfiguration3, IConfiguration4,
                         IInternalDebug, IBetaConfig, IBetaConfig2, IConfiguration5,
                         // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Added pool for the Forms Toolkit
                         IConfiguration6)
  private
    FToolkit : TObject;
  protected
    // IConfiguration
    function  Get_EnterpriseDirectory: WideString; safecall;
    procedure Set_EnterpriseDirectory(const Value: WideString); safecall;
    function  Get_DataDirectory: WideString; safecall;
    procedure Set_DataDirectory(const Value: WideString); safecall;
    function  Get_AutoSetPeriod: WordBool; safecall;
    procedure Set_AutoSetPeriod(Value: WordBool); safecall;
    function  Get_DefaultNominalCode: Integer; safecall;
    procedure Set_DefaultNominalCode(Value: Integer); safecall;
    function  Get_DefaultCostCentre: WideString; safecall;
    procedure Set_DefaultCostCentre(const Value: WideString); safecall;
    function  Get_DefaultDepartment: WideString; safecall;
    procedure Set_DefaultDepartment(const Value: WideString); safecall;
    function  Get_DefaultVATCode: WideString; safecall;
    procedure Set_DefaultVATCode(const Value: WideString); safecall;
    function  Get_AutoSetStockCost: WordBool; safecall;
    procedure Set_AutoSetStockCost(Value: WordBool); safecall;
    function  Get_DeductBOMStock: WordBool; safecall;
    procedure Set_DeductBOMStock(Value: WordBool); safecall;
    function  Get_DeductMultiLocationStock: WordBool; safecall;
    procedure Set_DeductMultiLocationStock(Value: WordBool); safecall;
    function  Get_OverwriteTransactionNumbers: WordBool; safecall;
    procedure Set_OverwriteTransactionNumbers(Value: WordBool); safecall;
    function  Get_OverwriteNotepad: WordBool; safecall;
    procedure Set_OverwriteNotepad(Value: WordBool); safecall;
    function  Get_AutoSetTransCurrencyRates: WordBool; safecall;
    procedure Set_AutoSetTransCurrencyRates(Value: WordBool); safecall;
    function  Get_AllowTransactionEditing: WordBool; safecall;
    procedure Set_AllowTransactionEditing(Value: WordBool); safecall;
    function  Get_DefaultCurrency: Integer; safecall;
    procedure Set_DefaultCurrency(Value: Integer); safecall;
    function  Get_UpdateAccountBalances: WordBool; safecall;
    procedure Set_UpdateAccountBalances(Value: WordBool); safecall;
    function  Get_UpdateStockLevels: WordBool; safecall;
    procedure Set_UpdateStockLevels(Value: WordBool); safecall;
    function  Get_ValidateJobCostingFields: WordBool; safecall;
    procedure Set_ValidateJobCostingFields(Value: WordBool); safecall;
    function  Get_ToolkitPath: WideString; safecall;

    //PR: 04/11/2011 v6.9 Added UserID to EnterpriseBeta.IBetaConfig to allow
    //LIVE to set UserID for Audit Notes.
    function Get_UserID: WideString; safecall;
    procedure Set_UserID(const Value: WideString); safecall;

    //PR: 19/11/2012 ABSEXCH-13753 Add StockReOrderMode property to allow NF to unfix ABSEXCH-9480
    function Get_StockReOrderMode: TStockReOrderMode; safecall;
    procedure Set_StockReOrderMode(Value: TStockReOrderMode); safecall;

    function Get_IgnoreCreditChecks: WordBool; safecall;
    procedure Set_IgnoreCreditChecks(Value: WordBool); safecall;

    //PR: 15/10/2013 MRD 2.5.18 v7.0.7 IConfiguration3
    function Get_DeliveryAddressPostcodeMapping: TDeliveryAddressPostcodeMapping; safecall;
    procedure Set_DeliveryAddressPostcodeMapping(Value: TDeliveryAddressPostcodeMapping); safecall;

    //PR: 29/10/2013 ABSEXCH-14705 IConfiguration4
    function Get_DefaultUser: WideString; safecall;
    procedure Set_DefaultUser(const Value: WideString); safecall;

    //PR: 16/01/2015 ABSEXCH-16044 IConfiguration5
    function Get_DefaultCountryCode: WideString; safecall;
    procedure Set_DefaultCountryCode(const Value: WideString); safecall;

    // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Added pool for the Forms Toolkit
    // IConfiguration5
    procedure FlushPrintingPool; safecall;

    function SetDebugMode(Param1: Integer; Param2: Integer; Param3: Integer) :
                OleVariant; safecall;

    function  Wibble(Param1: Integer; Param2: Integer; Param3: Integer): OleVariant; safecall;

    // Local methods
    Procedure Bang(Const BangName : String);
    procedure InitObjs;
  public
    Constructor Create (Const Toolkit : TObject);
    Destructor Destroy; override;
  End; { TConfiguration }


implementation

uses ComServ, GlobVar, VarCnst3, MiscFunc, oBakDoor, oToolkit, SecCodes, EntLicence, DllTh_Up,
     //PR: 03/11/2011 v6.9
     AuditNoteIntf, EtStrU, BtKeys1U,

     //PR: 19/11/2012 ABSEXCH-13753
     DLLSK01U,

     //PR: 16/01/2015 ABSEXCH-16044
     CountryCodes,

     // MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Added pool for the Forms Toolkit
     oFormsToolkitPoolManager;

{-------------------------------------------------------------------------------------------------}

Constructor TConfiguration.Create (Const Toolkit : TObject);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IConfiguration6);

  InitObjs;

  FToolkit := Toolkit;
End; { Create }

{-----------------------------------------}

Destructor TConfiguration.Destroy;
Begin { Destroy }
  InitObjs;

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

procedure TConfiguration.InitObjs;
begin
  FToolkit := Nil;
end;

{-----------------------------------------}

Procedure TConfiguration.Bang(Const BangName : String);
Begin { Bang }
  If ((FToolkit As TToolkit).Status <> tkClosed) Then
    Raise Exception.Create ('Toolkit.Configuration.' + BangName + ' cannot be changed whilst the Toolkit is Open');
End; { Bang }

{-----------------------------------------}

function TConfiguration.Get_AllowTransactionEditing: WordBool;
begin
  Result := ExSyss.AllowEdit;
end;

procedure TConfiguration.Set_AllowTransactionEditing(Value: WordBool);
begin
  Bang ('AllowTransactionEditing');

  ExSyss.AllowEdit := Value
end;

{-----------------------------------------}

function TConfiguration.Get_AutoSetPeriod: WordBool;
begin
  Result := ExSyss.AutoSetPr;
end;

procedure TConfiguration.Set_AutoSetPeriod(Value: WordBool);
begin
  ExSyss.AutoSetPr := Value
end;

{-----------------------------------------}

function TConfiguration.Get_AutoSetStockCost: WordBool;
begin
  Result := ExSyss.AutoSetStkCost;
end;

procedure TConfiguration.Set_AutoSetStockCost(Value: WordBool);
begin
  Bang ('AutoSetStockCost');

  ExSyss.AutoSetStkCost := Value
end;

{-----------------------------------------}

function TConfiguration.Get_AutoSetTransCurrencyRates: WordBool;
begin
  Result := ExSyss.UseExCrRate;
end;

procedure TConfiguration.Set_AutoSetTransCurrencyRates(Value: WordBool);
begin
  ExSyss.UseExCrRate := Value
end;

{-----------------------------------------}

function TConfiguration.Get_DataDirectory: WideString;
begin
  Result := ExSyss.ExPath;
end;

procedure TConfiguration.Set_DataDirectory(const Value: WideString);
Var
  Path   : String;
  ErrStr : ShortString;
begin
  Bang ('DataDirectory');

  // Check the directory
  Path := Value;
  If ValidateDataDirectory (Path, ErrStr) Then
    // Hooray
    ExSyss.ExPath := Path
  Else
    // Whoops
    Raise EValidation.Create (ErrStr);
end;

{-----------------------------------------}

function TConfiguration.Get_DeductBOMStock: WordBool;
begin
  Result := ExSyss.DeductBOM;
end;

procedure TConfiguration.Set_DeductBOMStock(Value: WordBool);
begin
  Bang ('DeductBOMStock');

  ExSyss.DeductBOM := Value;
end;

{-----------------------------------------}

function TConfiguration.Get_DeductMultiLocationStock: WordBool;
begin
  Result := ExSyss.UseMLoc;
end;

procedure TConfiguration.Set_DeductMultiLocationStock(Value: WordBool);
begin
  Bang ('DeductMultiLocationStock');

  ExSyss.UseMLoc := Value;
end;

{-----------------------------------------}

function TConfiguration.Get_DefaultCostCentre: WideString;
begin
  Result := ExSyss.DefCCDep[True];
end;

procedure TConfiguration.Set_DefaultCostCentre(const Value: WideString);
begin
  ExSyss.DefCCDep[True] := Value;
end;

{-----------------------------------------}

function TConfiguration.Get_DefaultCurrency: Integer;
begin
  if ExSyss.MCMode then
    //Euro/Multi-Currency
    Result := ExSyss.DefCur
  else
    Result := 0; //single currency
end;

procedure TConfiguration.Set_DefaultCurrency(Value: Integer);
begin
  If (ExSyss.MCMode And ((Value < 1) or (Value > 90))) Then
    // Euro/Multi-Currency and Currency Invalid
    Raise EValidation.Create ('The Default Currency must be in the range 1 to 90 for Euro and Global systems')
  Else
    If (Not ExSyss.MCMode) And (Value <> 0) Then
      // Single Currency and Currency Invalid
      Raise EValidation.Create ('The Default Currency must be 0 for Professional systems');

  ExSyss.DefCur := Value;
end;

{-----------------------------------------}

function TConfiguration.Get_DefaultDepartment: WideString;
begin
  Result := ExSyss.DefCCDep[False];
end;

procedure TConfiguration.Set_DefaultDepartment(const Value: WideString);
begin
  ExSyss.DefCCDep[False] := Value;
end;

{-----------------------------------------}

function TConfiguration.Get_DefaultNominalCode: Integer;
begin
  Result := ExSyss.DefNom;
end;

procedure TConfiguration.Set_DefaultNominalCode(Value: Integer);
begin
  ExSyss.DefNom := Value;
end;

{-----------------------------------------}

function TConfiguration.Get_DefaultVATCode: WideString;
begin
  Result := ExSyss.DefVAT;
end;

procedure TConfiguration.Set_DefaultVATCode(const Value: WideString);
begin
  ExSyss.DefVAT := ExtractChar(Value, #255);
end;

{-----------------------------------------}

function TConfiguration.Get_EnterpriseDirectory: WideString;
begin
  Result := ExSyss.BatchPath;
end;

procedure TConfiguration.Set_EnterpriseDirectory(const Value: WideString);
Var
  Path, ErrStr : ShortString;
begin
  Bang ('EnterpriseDirectory');

  // Check the directory
  Path := Value;
  If ValidateEnterpriseDirectory (Path, ErrStr) Then
    // Hooray
    ExSyss.BatchPath := Path
  Else
    // Whoops
    Raise EValidation.Create (ErrStr);
end;

{-----------------------------------------}

(*
function TConfiguration.Get_MultiCurrency: WordBool;
begin
  Result := ExSyss.MCMode;
end;

procedure TConfiguration.Set_MultiCurrency(Value: WordBool);
Var
  Path   : String;
  ErrStr : ShortString;
begin
  Bang ('MultiCurrency');

  // Validate against the Data Directory
  Path := ExSyss.ExPath;
  If ValidateDataDirectory (Path, ErrStr) Then Begin
    // Data Directory path is AOK
    If (Not Value) Then Begin
      // Single-Currency - 'Professional'
      If (Not FileExists (Path + 'DEFPF044.SYS')) Then
        Raise EValidation.Create (QuotedStr(Path) + ' does not contain a Single Currency system');
    End { If }
    Else Begin
      // Multi-Currency - 'Euro/Global'
      If (Not FileExists (Path + 'DEFMC044.SYS')) Then
        Raise EValidation.Create (QuotedStr(Path) + ' does not contain a Multi Currency system');
    End; { Else }

    ExSyss.MCMode := Value;
  End; { If ValidateDataDirectory (Path, ErrStr) }
end;
*)

{-----------------------------------------}

function TConfiguration.Get_OverwriteNotepad: WordBool;
begin
  Result := ExSyss.OverWNPad;
end;

procedure TConfiguration.Set_OverwriteNotepad(Value: WordBool);
begin
  // HM 25/06/01: Opened up the OverwriteNotepad option for read-write access
  //              after OpenCompany has been called.
  //Bang ('OverwriteNotepad');

  ExSyss.OverWNPad := Value;
end;

{-----------------------------------------}

function TConfiguration.Get_OverwriteTransactionNumbers: WordBool;
begin
  Result := ExSyss.OverWORef;
end;

procedure TConfiguration.Set_OverwriteTransactionNumbers(Value: WordBool);
begin
  ExSyss.OverWORef := Value;
end;

{-----------------------------------------}

function TConfiguration.Get_UpdateAccountBalances: WordBool;
begin
  Result := ExSyss.UpAccBal;
end;

procedure TConfiguration.Set_UpdateAccountBalances(Value: WordBool);
begin
  Bang ('UpdateAccountBalances');

  ExSyss.UpAccBal := Value;
end;

{-----------------------------------------}

function TConfiguration.Get_UpdateStockLevels: WordBool;
begin
  Result := ExSyss.UpStkBal;
end;

procedure TConfiguration.Set_UpdateStockLevels(Value: WordBool);
begin
  Bang ('UpdateStockLevels');

  ExSyss.UpStkBal := Value;
end;

{-----------------------------------------}

function TConfiguration.Get_ValidateJobCostingFields: WordBool;
begin
  Result := Not ExSyss.JBIgnore;
end;

procedure TConfiguration.Set_ValidateJobCostingFields(Value: WordBool);
begin
  Bang ('ValidateJobCostingFields');

  ExSyss.JBIgnore := Not Value;
end;

{-----------------------------------------}

// Backdoor function for bypassing release codes, etc...
function TConfiguration.SetDebugMode(Param1: Integer; Param2: Integer; Param3: Integer) : OleVariant;
Var
  ErrStr : ANSIString;
  OpCode : Byte;
begin { SetDebugMode }
  Try
    // Validate the Parameters and extract the OpCode
    If DecodeOpCode (OpCode, Param1, Param2, Param3) Then Begin
      // Validated AOK
      Case OpCode Of
        // NOTE: Valid OpCodes must be in the range 1 - 220

        { Backdoor Object }
        64       : Begin
                     BackDoor := TBackDoor.CreateWithToolkit(FToolkit);
                     Result := BackDoor.OleObject;
                   End; { 64 - Backdoor Object }

        //PR 05/10/2006 Added to allow importer to validate imports without saving
        65       : CheckOnly := True;
        66       : CheckOnly := False;

        //PR 1/03/05 Added extra backdoor (121) for Exchequer Ireland
        //PR: 14/02/2013 ABSEXCH-13581 v7.02 Added 124 for Konnect-IT (eXchequer 365)
        { Don't do release code check }
        97, 121,
        124      : CheckRelease := BOff;

        // LITE - Reserve 181-220 inclusive for LITE 3rd Party backdoors.
        181..220 : Begin
                     If EnterpriseLicence.IsLITE Then
                       CheckRelease := BOff
                     Else
                       Raise Exception.Create ('');
                   End; // 181..220

        // NOTE: Max OpCode is 220 - no idea why
      Else
        Raise Exception.Create ('');
      End; { Case }
    End { If DecodeOpCode }
    Else
      Raise Exception.Create ('');
  Except
    // User trying to hack system - do something suitably nasty
    On Exception Do Begin
      Randomize;

      ErrStr := 'The following error occurred in SetDebugMode:-' + #13#13 +
                QuotedStr(Format ('Access violation at address %8.8x in module KERNEL32.DLL', [Random(2147000000)])) +
                #13#13 + 'WARNING: You may need to restart Windows to ensure correct operation';

      Application.MessageBox (PCHAR(ErrStr), 'System Error', MB_OK + MB_ICONSTOP + MB_APPLMODAL);
    End; { On }
  End; { Try..Except }
end; { SetDebugMode }

{-----------------------------------------}

// Returns the path of the loaded COM Toolkit Library
function TConfiguration.Get_ToolkitPath: WideString;
Var
  ModuleNameBuffer : Array [0..255] of char;
  LengthModuleName : Integer;
begin
  // Extract COM Toolkit Path and Name from Windows
  FillChar(ModuleNameBuffer, SizeOf(ModuleNameBuffer), #0);
  LengthModuleName := GetModuleFileName(HInstance, ModuleNameBuffer, SizeOf(ModuleNameBuffer));
  If (LengthModuleName > 0) Then
    Result := IncludeTrailingBackslash(ExtractFileDir(ModuleNameBuffer));
end;

{-----------------------------------------}

function TConfiguration.Wibble(Param1, Param2,
  Param3: Integer): OleVariant;
begin
  Result := Format ('Wibble (%d, %d, %d);', [Param1, Param2, Param3]);
end;


function TConfiguration.Get_IgnoreCreditChecks: WordBool;
begin
  Result := GetIgnoreCreditLimit;
end;

procedure TConfiguration.Set_IgnoreCreditChecks(Value: WordBool);
begin
  SetIgnoreCreditLimit(Value);
end;

//PR: 04/11/2011 v6.9 Added UserID to EnterpriseBeta.IBetaConfig to allow
//LIVE to set UserID for Audit Notes.
function TConfiguration.Get_UserID: WideString;
begin
  Result := ToolkitUser;
end;

procedure TConfiguration.Set_UserID(const Value: WideString);
begin
  if Trim(Value) = '' then
    ToolkitUser := ''
  else
    ToolkitUser := LJVar(UpperCase(Trim(Value)), LoginKeyLen);
  //PR: 28/02/2014 ABSEXCH-15092 Need to clear AuditNote object so it can be recreated with new UserID
  ClearAuditNoteObject;
end;

//PR: 19/11/2012 ABSEXCH-13753 Add StockReOrderMode property to allow NF to unfix ABSEXCH-9480
function TConfiguration.Get_StockReOrderMode: TStockReOrderMode;
begin
  if Use9480ReOrder then
    Result := sr66
  else
    Result := sr65;
end;

procedure TConfiguration.Set_StockReOrderMode(Value: TStockReOrderMode);
begin
  Use9480ReOrder := Value <> sr65;
end;

function TConfiguration.Get_DeliveryAddressPostcodeMapping: TDeliveryAddressPostcodeMapping;
begin
  Result := ExSyss.AddressPostcodeMapping;
end;

procedure TConfiguration.Set_DeliveryAddressPostcodeMapping(
  Value: TDeliveryAddressPostcodeMapping);
begin
  ExSyss.AddressPostcodeMapping := Value;
end;

//PR: 29/10/2013 ABSEXCH-14705 IConfiguration4
function TConfiguration.Get_DefaultUser: WideString;
begin
  Result := ExSyss.DefaultUser;
end;

procedure TConfiguration.Set_DefaultUser(const Value: WideString);
begin
  ExSyss.DefaultUser := Value;
end;

function TConfiguration.Get_DefaultCountryCode: WideString;
begin
  Result := ExSyss.DefaultCountryCode;
end;

procedure TConfiguration.Set_DefaultCountryCode(const Value: WideString);
begin
  ExSyss.DefaultCountryCode := Value;
end;

//-------------------------------------------------------------------------

// MH 01/10/2015 ABSPLUG-1632 v7.0.11 Patch: Added pool for the Forms Toolkit
// IConfiguration6
procedure TConfiguration.FlushPrintingPool;
Begin // FlushPrintingPool
  FlushFormsToolkitPoolManager;
End; // FlushPrintingPool

//-------------------------------------------------------------------------

end.
