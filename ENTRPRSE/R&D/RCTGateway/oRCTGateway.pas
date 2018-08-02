unit oRCTGateway;

interface

uses
  Dialogs,
  Forms,
  SysUtils,
  Enterprise_TLB,
  Registry,
  ComObj,
  VarConst,
  ExWrap1U,
  BtSupU3;

type
  TRCTGateway = class(TAutoIntfObject, IRCTGateway)
  private
    { Reference to external COM plugin }
    FPlugin: IRCTPlugin;

    { Record for Batch Control Header details }
    FPasswordRec: ^PassWordRec;

    { Record for print form details }
    FReportForm: PFormRepPtr;

    { Local files object }
    ExLocal: TdExLocal;

    { True if eRCT process is running }
    FIsRunning: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    { Internal methods, for use within Exchequer only (hence excluded from the
      interface) }
    function HasActivePlugin: Boolean;
    function IsRunning: Boolean;

    function MenuCaption: string;
    function Start: Boolean;
    function ValidateHeader(var CanContinue: Boolean): Boolean;
    procedure Process;
    procedure Finish;

    { Implementation of IRCTGateway interface methods }
    function TagTransaction(const OurRef: WideString): LongInt; safecall;
    function ProcessPayments: LongInt; safecall;

    { Property Get/Set methods }
    function Get_PaymentType: WideString; safecall;
    procedure Set_PaymentType(const Value: WideString); safecall;
    function Get_BankGLCode: Integer; safecall;
    procedure Set_BankGLCode(Value: Integer); safecall;
    function Get_GLControlAccount: Integer; safecall;
    procedure Set_GLControlAccount(Value: Integer); safecall;
    function Get_CostCentre: WideString; safecall;
    procedure Set_CostCentre(const Value: WideString); safecall;
    function Get_Department: WideString; safecall;
    procedure Set_Department(const Value: WideString); safecall;
    function Get_UseAccountCCDept: WordBool; safecall;
    procedure Set_UseAccountCCDept(Value: WordBool); safecall;
    function Get_InvoiceCurrency: Integer; safecall;
    procedure Set_InvoiceCurrency(Value: Integer); safecall;
    function Get_PaymentCurrency: Integer; safecall;
    procedure Set_PaymentCurrency(Value: Integer); safecall;
    function Get_YourRef: WideString; safecall;
    procedure Set_YourRef(const Value: WideString); safecall;
    function Get_AgeBalancesBy: TBatchAgeType; safecall;
    procedure Set_AgeBalancesBy(Value: TBatchAgeType); safecall;
    function Get_AgeInterval: Integer; safecall;
    procedure Set_AgeInterval(Value: Integer); safecall;
    function Get_IncludeSettlementDiscount: WordBool; safecall;
    procedure Set_IncludeSettlementDiscount(Value: WordBool); safecall;
    function Get_PPDExpiryTolerance: Integer; safecall;
    procedure Set_PPDExpiryTolerance(Value: Integer); safecall;
    function Get_UseChequePrinting: WordBool; safecall;
    procedure Set_UseChequePrinting(Value: WordBool); safecall;
    function Get_ChequeNumber: Integer; safecall;
    procedure Set_ChequeNumber(Value: Integer); safecall;
    function Get_ApplyPPD: WordBool; safecall;
    procedure Set_ApplyPPD(Value: WordBool); safecall;
    function Get_PPDPaymentDate: WideString; safecall;
    procedure Set_PPDPaymentDate(const Value: WideString); safecall;
    function Get_DaysOverSettlementDiscount: Integer; safecall;
    procedure Set_DaysOverSettlementDiscount(Value: Integer); safecall;

    // MH 06/02/2018 2018-R1 ABSEXCH-19292: Added new properties
    function Get_CompanyCode: WideString; safecall;
    function Get_UserID: WideString; safecall;
  end;

function RCTGateway: TRCTGateway;

implementation

uses Windows, ComServ, GlobVar, SysU1, BtrvU2, CurrncyU, BTKeys1U, BTSupU1, InvListU, ETDateU, BPayLstU, BPyItemU, EParentU, BACS3U,
     // MH 06/02/2018 2018-R1 ABSEXCH-19292: Added new properties
     CustIntU;

var
  GatewayObj : TRCTGateway;
  GatewayIntf: IRCTGateway;

//------------------------------------------------------------------------------

function RCTGateway: TRCTGateway;
begin
  if (GatewayObj = nil) then
  begin
    GatewayObj := TRCTGateway.Create;
    GatewayIntf := GatewayObj;
  end; // if (GatewayObj = nil)

  Result := GatewayObj;
end;

//------------------------------------------------------------------------------

constructor TRCTGateway.Create;
begin
  inherited Create(ComServer.TypeLib, IRCTGateway);
  FPlugin := nil;
  try
    with TRegistry.Create do
    try
      Access := KEY_READ;
      RootKey := HKEY_CLASSES_ROOT;
      // Is there an RCT Plugin registered?
      if OpenKey('RCT.Plugin', False) then
      begin
        FPlugin := CreateOleObject('RCT.Plugin') as IRCTPlugin;
        CloseKey;
      end;
    finally
      Free;
    end;
  except
    FPlugin := nil;
  end;
end;

//------------------------------------------------------------------------------

destructor TRCTGateway.Destroy;
begin
  FPlugin := nil;
  ExLocal.Destroy;
  inherited Destroy;
end;

//------------------------------------------------------------------------------

function TRCTGateway.HasActivePlugin: Boolean;
begin
  Result := (FPlugin <> nil);
end;

//------------------------------------------------------------------------------

function TRCTGateway.Start: Boolean;
var
  HeaderValidated: Boolean;
  CanContinue: Boolean;
begin
  Result := False;
  FIsRunning := True;

  if not MainForm.BatchPayInUse[False] then
  begin
    // Batch Payments is not in use, so we can lay claim.
    Mainform.BatchPayInUse[False] := True;
    Result := True;
  end
  else
  begin
    ShowMessage('The ' + BatchPTit(False) + ' list is currently in use.');
  end;

  if (Result) then
  begin
    ExLocal.Create;

    // Create a record for the Password file (EXCHQCHK)
    // This consists of
    //   RecPfix : Char; { Record Prefix }
    //   SubType : Char; { Subsplit Record Type }
    // Followed by a variant record part.
    New(FPasswordRec);
    // Clear the record down to zeros.
    FillChar(FPasswordRec^, Sizeof(FPasswordRec^), 0);

    // Initialise some fields in the record
    BACS_CtrlGet(PWrdF, PWK, FPasswordRec^, False, nil);

    // Create a new form rep param record
    New(FReportForm);
    // Clear it down to zeros.
    FillChar(FReportForm^, Sizeof(FReportForm^), 0);

    // Set the batch flag and form
    FReportForm^.PParam.PBatch := true;
    FReportForm^.RForm := SyssForms.FormDefs.PrimaryForm[5];

    // Set the default values
    with FPasswordRec^.BacsCRec do
    begin
      TagRunNo   := BACS_GetRunNo(False, False, Nil);
      PayType    := 'B';
      PayCurr    := 1;
      InvCurr    := 1;
      AgeType    := 1;
      AgeInt     := 30;
      ShowLog    := False;
      CQStart    := 0;
      SetCQatP   := false;
      SRCPIRef   := '';
      TagCount   := 0;
      TagStatus  := BOff;
      TagRunDate := Today;
      TagRunYr   := GetLocalPr(0).CYr;
      TagRunPr   := GetLocalPr(0).CPr;
      TagAsDate  := Today;
      UseOsNdx   := False;
      ApplyPPD   := False;
      PPDExpiryToleranceDays := 0;
    end;

    // Allow the plug-in to fill in the other header details (it will do this
    // by setting the properties on this instance, via the Get/Set methods).
    if FPlugin.Start(GatewayIntf) then
    begin
      BACS_CtrlPut(PWrdF, PWK, FPasswordRec^, nil, 0);
      HeaderValidated := False;
      CanContinue     := True;
      while CanContinue and not HeaderValidated do
      begin
        // Validate the header details, and report any errors back to the plug-in
        HeaderValidated := ValidateHeader(CanContinue);
      end;
      if CanContinue then
        AddBACSScan2Thread(Mainform, FPasswordRec^, Mainform.Handle)
      else
        Finish;
    end
    else
    begin
      Finish;
      Result := False;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TRCTGateway.ValidateHeader(var CanContinue: Boolean): Boolean;
var
  FoundLong: Integer;
  FoundCode: Str20;

  function CheckGLCurrency(GLCode: Integer; Currency: Integer): Boolean;
  begin
    Result := Global_GetMainRec(NomF, FullNomKey(GLCode));
    Result := Result and ((Currency=Nom.DefCurr) or (Nom.DefCurr=0) or (Currency=0));
  end;

begin
  // On return, Result will hold False if any of the validations failed. If
  // CanContinue is True the implication is that the plug-in has corrected
  // the error, and we can try again. If it is False, the Batch Payments run
  // should be continued.
  Result := True;
  CanContinue := True;
  // Check the Bank G/L Code
  if not GetNom(nil, IntToStr(FPasswordRec^.BACSCRec.BankNom), FoundLong, -1) then
  begin
    Result      := False;
    CanContinue := FPlugin.OnHeaderError(self, rsInvalidGLCode, 'Invalid Bank G/L Code: ' + IntToStr(FPasswordRec^.BACSCRec.BankNom));
  end
  // Check the Cost Centre
  else if not GetCCDep(nil, FPasswordRec^.BACSCRec.TagCCDep[True], FoundCode, True, -1) then
  begin
    Result      := False;
    CanContinue := FPlugin.OnHeaderError(self, rsInvalidCostCentre, 'Invalid Cost Center: ' + FPasswordRec^.BACSCRec.TagCCDep[True]);
  end
  // Check the Department
  else if not GetCCDep(nil, FPasswordRec^.BACSCRec.TagCCDep[False], FoundCode, False, -1) then
  begin
    Result      := False;
    CanContinue := FPlugin.OnHeaderError(self, rsInvalidDepartment, 'Invalid Department: ' + FPasswordRec^.BACSCRec.TagCCDep[False]);
  end
  // Check the Payment Currency (this must match the currency of the select Bank G/L Code)
  else if not CheckGLCurrency(FPasswordRec^.BACSCRec.BankNom, FPasswordRec^.BACSCRec.PayCurr) then
  begin
    Result      := False;
    CanContinue := FPlugin.OnHeaderError(self, rsInvalidBankGLCurrency, 'Invalid Bank G/L Currency. The selected bank account cannot be paid in ' + Ssymb(FPasswordRec^.BACSCRec.PayCurr));
  end;
end;

//------------------------------------------------------------------------------

procedure TRCTGateway.Process;
begin
  try
    // Execute the plug-in, passing this object to it so that it can set up
    // the properties and call the relevant methods to add transactions and
    // run the process routine
    FPlugin.Process(GatewayIntf);

    PostMessage(Application.MainForm.Handle, WM_THREADFINISHED, PID_BATCH_PAYMENTS_FINISHED, 0);
  except
    on E:Exception do
    begin
      ShowMessage('Error calling RCT Plugin: ' + E.message);
      Finish();
    end;
  end;
end;

//------------------------------------------------------------------------------

function TRCTGateway.TagTransaction(const OurRef: WideString): LongInt;
const
  SAVE_POSITION: Boolean = False;
  RESTORE_POSITION = True;
var
  RecAddr: LongInt;
  PreserveRecord: Boolean;
  Action: Boolean;
  Status: LongInt;
  KeyPath: Integer;
  Key: Str255;
begin
  // Save Transaction Header record position
  PreserveRecord := True;
  Action := SAVE_POSITION;
  KeyPath := InvOurRefK;
  Status := ExLocal.LPresrv_BTPos(InvF, KeyPath, F[InvF], RecAddr, Action, PreserveRecord);

  try
    // Locate the Transaction Header
    Key    := OurRef;
    Status := Find_Rec(B_GetEq, F[InvF], InvF, ExLocal.LInv, Keypath, Key);

    if Status = 0 then
    begin
      // MH 07/02/2018 2018-R1 ABSEXCH-19292: Added new method to allow eRCT Plug-In to validate the Account is valid
      Status := BACS_ValidateAccount (ExLocal, ExLocal.LInv.CustCode);
      If (Status = 0) Then
      Begin
        // Tag the Transaction Header
        BACS_TagTransaction(1, True, True, False, PWK, ExLocal, FPasswordRec^);
        // All OK
        Result := 0;
      End // If (Status = 0)
      Else
        Case Status of
          1 : Result := rsBatchPaymentsHeaderNotFound;
          2 : Result := rsAccountHeaderNotFound;
        Else
          Result := rsUnknownError;
        End; // Case Status
    end
    else
      Result := rsTransactionNotFound;

  finally
    // Restore the Transaction Header record position
    Action := RESTORE_POSITION;
    Status := ExLocal.LPresrv_BTPos(InvF, KeyPath, F[InvF], RecAddr, Action, PreserveRecord);
  end;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_PaymentType: WideString;
begin
  Result := FPasswordRec^.BacsCRec.PayType;
end;

procedure TRCTGateway.Set_PaymentType(const Value: WideString);
Var
  S : ShortString;
begin
  S := Value + ' ';

  If (S[1] = BACSRCode) Or      // B - BACS Run Code
     (S[1] = BACSCCode) Or      // C - Cheque Type
     (S[1] = BACS2Code) Or      // 2 - Alt Cheque 2
     (S[1] = BACS3Code) Then    // 3 - Alt Cheque 3
    FPasswordRec^.BacsCRec.PayType := S[1];
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_AgeBalancesBy: TBatchAgeType;
begin
  Result := TBatchAgeType(Pred(FPasswordRec^.BacsCRec.AgeType));
end;

procedure TRCTGateway.Set_AgeBalancesBy(Value: TBatchAgeType);
begin
  FPasswordRec^.BacsCRec.AgeType := Succ(Ord(Value));
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_AgeInterval: Integer;
begin
  Result := FPasswordRec^.BacsCRec.AgeInt;
end;

procedure TRCTGateway.Set_AgeInterval(Value: Integer);
begin
  FPasswordRec^.BacsCRec.AgeInt := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_BankGLCode: Integer;
begin
  Result := FPasswordRec^.BacsCRec.BankNom;
end;

procedure TRCTGateway.Set_BankGLCode(Value: Integer);
begin
  FPasswordRec^.BacsCRec.BankNom := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_CostCentre: WideString;
begin
  Result := FPasswordRec^.BacsCRec.TagCCDep[True];
end;

procedure TRCTGateway.Set_CostCentre(const Value: WideString);
begin
  FPasswordRec^.BacsCRec.TagCCDep[True] := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_InvoiceCurrency: Integer;
begin
  Result := FPasswordRec^.BacsCRec.InvCurr;
end;

procedure TRCTGateway.Set_InvoiceCurrency(Value: Integer);
begin
  FPasswordRec^.BacsCRec.InvCurr := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_Department: WideString;
begin
  Result := FPasswordRec^.BacsCRec.TagCCDep[False];
end;

procedure TRCTGateway.Set_Department(const Value: WideString);
begin
  FPasswordRec^.BacsCRec.TagCCDep[False] := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_PPDExpiryTolerance: Integer;
begin
  Result := FPasswordRec^.BacsCRec.SDDaysOver;
end;

procedure TRCTGateway.Set_PPDExpiryTolerance(Value: Integer);
begin
  FPasswordRec^.BacsCRec.SDDaysOver := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_GLControlAccount: Integer;
begin
  Result := FPasswordRec^.BacsCRec.TagCtrlCode;
end;

procedure TRCTGateway.Set_GLControlAccount(Value: Integer);
begin
  FPasswordRec^.BacsCRec.TagCtrlCode := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_IncludeSettlementDiscount: WordBool;
begin
  Result := FPasswordRec^.BacsCRec.IncSDisc;
end;

procedure TRCTGateway.Set_IncludeSettlementDiscount(Value: WordBool);
begin
  FPasswordRec^.BacsCRec.IncSDisc := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_UseAccountCCDept: WordBool;
begin
  Result := FPasswordRec^.BacsCRec.UseAcCC;
end;

procedure TRCTGateway.Set_UseAccountCCDept(Value: WordBool);
begin
  FPasswordRec^.BacsCRec.UseAcCC := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_YourRef: WideString;
begin
  Result := FPasswordRec^.BACSCRec.YourRef;
end;

procedure TRCTGateway.Set_YourRef(const Value: WideString);
begin
  FPasswordRec^.BACSCRec.YourRef := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_ChequeNumber: Integer;
begin
  Result := FPasswordRec^.BACSCRec.CQStart;
end;

procedure TRCTGateway.Set_ChequeNumber(Value: Integer);
begin
  FPasswordRec^.BACSCRec.CQStart := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_DaysOverSettlementDiscount: Integer;
begin
  Result := FPasswordRec^.BACSCRec.SDDaysOver;
end;

procedure TRCTGateway.Set_DaysOverSettlementDiscount(Value: Integer);
begin
  FPasswordRec^.BACSCRec.SDDaysOver := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_ApplyPPD: WordBool;
begin
  Result := FPasswordRec^.BACSCRec.ApplyPPD;
end;

procedure TRCTGateway.Set_ApplyPPD(Value: WordBool);
begin
  FPasswordRec^.BACSCRec.ApplyPPD := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_PaymentCurrency: Integer;
begin
  Result := FPasswordRec^.BACSCRec.PayCurr;
end;

procedure TRCTGateway.Set_PaymentCurrency(Value: Integer);
begin
  FPasswordRec^.BACSCRec.PayCurr := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_PPDPaymentDate: WideString;
begin
  Result := FPasswordRec^.BACSCRec.IntendedPaymentDate;
end;

procedure TRCTGateway.Set_PPDPaymentDate(const Value: WideString);
begin
  FPasswordRec^.BACSCRec.IntendedPaymentDate := Value;
end;

//------------------------------------------------------------------------------

function TRCTGateway.Get_UseChequePrinting: WordBool;
begin
  Result := FPasswordRec^.BACSCRec.SetCQatP;
end;

procedure TRCTGateway.Set_UseChequePrinting(Value: WordBool);
begin
  FPasswordRec^.BACSCRec.SetCQatP := Value;
end;

//-------------------------------------------------------------------------

// MH 06/02/2018 2018-R1 ABSEXCH-19292: Added new properties
function TRCTGateway.Get_CompanyCode: WideString;
Begin // Get_CompanyCode
  // Extract the  current company code from the Customisation - this is populated from EParentU during Login/Change Company
  Result := CustomisationCompanyCode;
End; // Get_CompanyCode

//------------------------------------------------------------------------------

// MH 06/02/2018 2018-R1 ABSEXCH-19292: Added new properties
function TRCTGateway.Get_UserID: WideString;
Begin // Get_UserID
  Result := EntryRec^.Login;
End; // Get_UserID

//------------------------------------------------------------------------------

function TRCTGateway.MenuCaption: string;
begin
  { Retrieve the menu caption from the plug-in }
  if HasActivePlugin then
    Result := FPlugin.MenuCaption
  else
    Result := ''
end;

//------------------------------------------------------------------------------

function TRCTGateway.ProcessPayments: Integer;
begin
  // Run the Batch Payments process
//  if ((FPasswordRec.BACSCRec.PayType=BACS2Code) or (FPasswordRec.BACSCRec.PayType=BACS3Code)) or  (Not Check4NegBatch(MiscF,MIK,BOn)) then
  Begin
    // MH 15/05/2018 ABSEXCH-20514: RCT version of Batch Payments was skipping tagged transactions as an out-of-date
    //                              version of BacsCRec was being passed into BACSCtrl causing LastInv to be reset to
    //                              the original value from when the RCT process was started.  LastInv contains the
    //                              highest folio number to process to prevent new transactions being picked up.
    BACS_CtrlGet(PWrdF, PWK, FPasswordRec^, False, nil);
    
    BACSCtrl(False, FPasswordRec^, Application.MainForm);
    Result := 0;
  end;
end;

//------------------------------------------------------------------------------

function TRCTGateway.IsRunning: Boolean;
begin
  Result := FIsRunning;
end;

//------------------------------------------------------------------------------

procedure TRCTGateway.Finish;
begin
  FIsRunning := False;
  Mainform.BatchPayInUse[False] := False;
  try
    FPlugin.Finish(GatewayIntf);
  except
    on Exception do
      // If the plug-in fails at this point there isn't much we can do, and not
      // much point in handling the error as we've finished anyway.
      ;
  end;
end;

//------------------------------------------------------------------------------

initialization

finalization
  GatewayIntf := nil;
  GatewayObj := nil;
end.
