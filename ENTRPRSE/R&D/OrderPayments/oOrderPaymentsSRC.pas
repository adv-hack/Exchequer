Unit oOrderPaymentsSRC;

Interface

Uses GlobVar, VarConst, ExBtth1u, Classes, OrderPaymentsInterfaces, oOPVATPayMemoryList, oCreditCardGateway;

Type
  TIntrastatTransctionType = (ittNormal, ittTriangulation, ittProcess);

  // Interface for object creating SRC payments or refuncs.
  IOrderPaymentsSRC = Interface
    ['{156E3E5F-9FF8-4B89-ADAD-9E8B5D3C0CA0}']
    // --- Internal Methods to implement Public Properties ---
    Function GetAccount : String;
    Procedure SetAccount (Value : String);
    Function GetCurrency : Integer;
    Procedure SetCurrency (Value : Integer);
    Function GetPaymentValue : Double;
    Procedure SetPaymentValue (Value : Double);
    Function GetBankGL : Integer;
    Procedure SetBankGL (Value : Integer);
    Function GetPayInRef : String;
    Procedure SetPayInRef (Value : String);
    Function GetCostCentre : String;
    Procedure SetCostCentre (Value : String);
    Function GetDepartment : String;
    Procedure SetDepartment (Value : String);

    Function GetExLocal : TdPostExLocalPtr;
    Procedure SetExLocal(const Value : TdPostExLocalPtr);
    Function GetRemitNo : String;
    Procedure SetRemitNo (Value : String);

    //OurRef of original Order
    Function GetOrderReference : String;
    Procedure SetOrderReference(Value : string);

    //OurRef of transaction which this payment is against - could be SOR/SDN/SIN
    Function GetTransactionRef : String;
    Procedure SetTransactionRef(Value : string);

    //ExchangeRate of above transaction
    Procedure SetOriginalXRate(Value : Double);

    //OurRef of created SRC
    Function GetOurRef : String;
    Procedure SetOurRef(Value : string);

    //OurRef of SRC we're refunding against (if applicable)
    Function GetPaymentRef : String;
    Procedure SetPaymentRef(Value : string);

    Function GetOPElement : enumOrderPaymentElement;
    Procedure SetOPElement(Value : enumOrderPaymentElement);

    //Credit card details to be stored in SRC header
    function GetCardType : string;
    procedure SetCardType(const Value : string);

    function GetCardNo : string;
    procedure SetCardNo(const Value : string);

    function GetCardExpiry : string;
    procedure SetCardExpiry(const Value : string);

    function GetCardAuthorisationNo : string;
    procedure SetCardAuthorisationNo(const Value : string);

    function GetCardReferenceNo : string;
    procedure SetCardReferenceNo(const Value : string);

    //PR: 30/01/2015 ABSEXCH-16102
    Function GetCreditCardAction : enumCreditCardAction;
    Procedure SetCreditCardAction (Value : enumCreditCardAction);

    // MH 29/06/2015 2015-R1 ABSEXCH-16507: Made COM Toolkit Transaction Date property standard
    Function GetSRCTransDate : ShortString;
    Procedure SetSRCTransDate(const Value : ShortString);

    // MH 03/07/2015 2015-R1 ABSEXCH-16408: Copy SOR YourRef into SRC
    Function GetYourRef : ShortString;
    Procedure SetYourRef (Value : ShortString);

    function GetVATPayList : TOrderPaymentsVATPayDetailsList;
    procedure SetVATPayList(const Value : TOrderPaymentsVATPayDetailsList);

    procedure SetControlGL(Value : longint);

    // ------------------ Public Properties ------------------
    Property Account : String Read GetAccount Write SetAccount;
    Property Currency : Integer Read GetCurrency Write SetCurrency;
    Property PaymentValue : Double Read GetPaymentValue Write SetPaymentValue;
    Property BankGL : Integer Read GetBankGL Write SetBankGL;
    Property PayInRef : String Read GetPayInRef Write SetPayInRef;
    Property CostCentre : String Read GetCostCentre Write SetCostCentre;
    Property Department : String Read GetDepartment Write SetDepartment;
    Property RemitNo : String Read GetRemitNo Write SetRemitNo;
    Property OrderReference : String Read GetOrderReference Write SetOrderReference;
    Property TransactionRef : String Read GetTransactionRef Write SetTransactionRef;
    Property PaymentRef : String Read GetPaymentRef Write SetPaymentRef;
    Property OPElement : enumOrderPaymentElement Read GetOPElement Write SetOPElement;
    Property OurRef : String Read GetOurRef Write SetOurRef;
    Property OriginalXRate : Double write SetOriginalXRate;
    Property ControlGL : Longint write SetControlGL;

    // MH 29/06/2015 2015-R1 ABSEXCH-16507: Made COM Toolkit Transaction Date property standard
    Property SRCTransDate : ShortString Read GetSRCTransDate Write SetSRCTransDate;

    // MH 03/07/2015 2015-R1 ABSEXCH-16408: Copy SOR YourRef into SRC
    Property YourRef : ShortString Read GetYourRef Write SetYourRef;

    //Credit card details to be stored in SRC header
    Property CardType : String Read GetCardType Write SetCardType;
    Property CardNo : String Read GetCardNo Write SetCardNo;
    Property CardExpiry : String Read GetCardExpiry Write SetCardExpiry;
    Property CardAuhorisationNo : String Read GetCardAuthorisationNo Write SetCardAuthorisationNo;
    Property CardReferenceNo : String Read GetCardReferenceNo Write SetCardReferenceNo;

    //PR: 30/01/2015 ABSEXCH-16102
    Property CreditCardAction : enumCreditCardAction Read GetCreditCardAction Write SetCreditCardAction;

    Property ExLocal : TdPostExLocalPtr Read GetExLocal write SetExLocal;
    property VATPayList : TOrderPaymentsVATPayDetailsList read GetVATPayList write SetVATPayList;

    {$IFDEF COMTK}
    Function GetSRCRef : ShortString;
    Procedure SetSRCRef(const Value : ShortString);

    Function GetSRCYear : Integer;
    Procedure SetSRCYear(const Value : Integer);

    Function GetSRCPeriod : Integer;
    Procedure SetSRCPeriod(const Value : Integer);

    Property SRCPeriod : Integer Read GetSRCPeriod Write SetSRCPeriod;
    Property SRCYear : Integer Read GetSRCYear Write SetSRCYear;
    Property SRCRef : ShortString Read GetSRCRef Write SetSRCRef;
    {$ENDIF}


    // ------------------- Public Methods --------------------
    function Save : integer;
    function Update : Integer;
  End; // IOrderPaymentsSRC


Function NewOrderPaymentsSRC : IOrderPaymentsSRC;

procedure ReportOrderPaymentError(ErrNo : Integer; const Process : string);

Implementation

uses
  BtKeys1U, EtDateU, SysU1, Event1U, CurrncyU, ComnUnit, TransactionOriginator, SysUtils, AuditNotes, EtStrU,{$IFNDEF EXDLL} LedgSupU, {$ENDIF}BtrvU2,
  Math, BtSupU1, EtMiscU, InvCtSuU, VarRec2U, SysU2, Forms, {$IFNDEF EXDLL} Saltxl2u, {$ENDIF} Contnrs, MathUtil,ComnU2,
  OrderPaymentsMatching, apiUtil, Dialogs;

const
  CURRENCY_DEC_PLACES = 6;

type

  TOrderPaymentsSRC = Class(TInterfacedObject, IOrderPaymentsSRC)
  Protected
    FAccount : String;
    FCurrency : Integer;
    FPaymentValue : Double;
    FBankGL : Integer;
    FPayInRef : string;
    FCostCentre : string;
    FDepartment : string;
    FRemitNo    : string;
    FExLocal : TdPostExLocalPtr;

    FOrderReference : String;
    FTransactionRef : string;
    FPaymentRef : string;
    FOurRef : string;
    FOPElement : enumOrderPaymentElement;

    //PR: 30/01/2015 ABSEXCH-16102
    FCreditCardAction : enumCreditCardAction;

    //Variables for dealing with variance
    FOriginalXRate : Double;
    dVarianceNeeded : Double;
    FControlGL : longint;

    //Credit card details to be stored in SRC header
    FCardType : string;
    FCardNo : string;
    FCardExpiry : string;
    FCardAuthorisationNo : string;
    FCardReferenceNo : String;

    FSerialBatchList : TStringList;

    FVATPayList: TOrderPaymentsVATPayDetailsList;

    //Value for matching - if payment this will equal FPaymentValue; if Refund then it must be the smaller
    //of FPaymentValue and the outstanding amount on the matching document
    FMatchValue : Double;
    FSINRef : string;

    // MH 29/06/2015 2015-R1 ABSEXCH-16507: Made COM Toolkit Transaction Date property standard
    FSRCTransDate : string;

    // MH 03/07/2015 2015-R1 ABSEXCH-16408: Copy SOR YourRef into SRC
    FYourRef : ShortString;

    {$IFDEF COMTK}
    //PR: 22/01/2015 Creating SRC for disaster recovery
    FSRCRef       : string;
    FSRCYear      : Byte;
    FSRCPeriod    : Byte;

    Function GetSRCRef : ShortString;
    Procedure SetSRCRef(const Value : ShortString);

    Function GetSRCYear : Integer;
    Procedure SetSRCYear(const Value : Integer);

    Function GetSRCPeriod : Integer;
    Procedure SetSRCPeriod(const Value : Integer);
    {$ENDIF}

    // MH 29/06/2015 2015-R1 ABSEXCH-16507: Made COM Toolkit Transaction Date property standard
    Function GetSRCTransDate : ShortString;
    Procedure SetSRCTransDate(const Value : ShortString);

    // IOrderPaymentsSRC
    Function GetAccount : String;
    Procedure SetAccount (Value : String);
    Function GetCurrency : Integer;
    Procedure SetCurrency (Value : Integer);

    Function GetPaymentValue : Double;
    Procedure SetPaymentValue (Value : Double);
    Function GetBankGL : Integer;
    Procedure SetBankGL (Value : Integer);
    Function GetPayInRef : String;
    Procedure SetPayInRef (Value : String);
    Function GetCostCentre : String;
    Procedure SetCostCentre (Value : String);
    Function GetDepartment : String;
    Procedure SetDepartment (Value : String);

    Function GetRemitNo : String;
    Procedure SetRemitNo (Value : String);

    Function GetOrderReference : String;
    Procedure SetOrderReference(Value : string);

    Function GetTransactionRef : String;
    Procedure SetTransactionRef(Value : string);

    Function GetPaymentRef : String;
    Procedure SetPaymentRef(Value : string);

    Function GetOurRef : String;
    Procedure SetOurRef(Value : string);

    Function GetExLocal : TdPostExLocalPtr;
    Procedure SetExLocal(const Value : TdPostExLocalPtr);

    Function GetOPElement : enumOrderPaymentElement;
    Procedure SetOPElement(Value : enumOrderPaymentElement);

    Procedure SetOriginalXRate(Value : Double);
    procedure SetControlGL(Value : longint);

    //Credit card details to be stored in SRC header
    function GetCardType : string;
    procedure SetCardType(const Value : string);

    function GetCardNo : string;
    procedure SetCardNo(const Value : string);

    function GetCardExpiry : string;
    procedure SetCardExpiry(const Value : string);

    function GetCardAuthorisationNo : string;
    procedure SetCardAuthorisationNo(const Value : string);

    function GetCardReferenceNo : string;
    procedure SetCardReferenceNo(const Value : string);

    //PR: 30/01/2015 ABSEXCH-16102
    Function GetCreditCardAction : enumCreditCardAction;
    Procedure SetCreditCardAction (Value : enumCreditCardAction);

    function GetVATPayList : TOrderPaymentsVATPayDetailsList;
    procedure SetVATPayList(const Value : TOrderPaymentsVATPayDetailsList);

    // MH 03/07/2015 2015-R1 ABSEXCH-16408: Copy SOR YourRef into SRC
    Function GetYourRef : ShortString;
    Procedure SetYourRef (Value : ShortString);

    //Internal functions
    function AddFinancialMatching : integer;
    function AddAuditNote : integer;
    function StorePaymentLine(Value : Double) : Integer;
    procedure SetHeaderDefaults;

    function VarianceNeeded : Double;
    function StoreVarianceLine(VarianceAmount : Double) : integer;

    procedure SetSINReference(const PayRef : string);
  Public
    Constructor Create;
    Destructor Destroy; Override;

    //Stores transaction header and line
    function Save : integer; virtual;

    function Update : Integer;
  End; // TOrderPaymentsSRC


procedure ReportOrderPaymentError(ErrNo : Integer; const Process : string);
var
  ErrString : string;
  ActualError : Integer; //Error without weighting
  Action : string;

  function ValueBetween(var Value : Integer; iLow, iHigh : Integer; AdjustValue : Boolean = True) : Boolean;
  begin
    Result := (Value > iLow) and (Value < iHigh);
    if Result and AdjustValue then
      Value := Value - iLow;
  end;

begin
  ActualError := ErrNo;

  Action := ' processing'; //Default for unknown errors

  if ValueBetween(ActualError, 5000, 6000) then
    Action := 'storing the SRC Header'
  else
  if ValueBetween(ActualError, 6000, 7000) then
    Action := 'storing the SRC Line'
  else
  if ValueBetween(ActualError, 7000, 8000) then
    Action := 'storing Audit Note for the SRC'
  else
  if ValueBetween(ActualError, 8000, 9000) then
    Action := 'storing Order Payment Matching for the SRC'
  else
  if ValueBetween(ActualError, 9000, 10000) then
    Action := 'storing Financial Matching records for the SRC'
  else
  if ValueBetween(ActualError, 51000, 520000) then
    Action := 'reading the SOR'
  else
  if ValueBetween(ActualError, 52000, 530000) then
    Action := 'restoring position on the SOR'
  else
  if ValueBetween(ActualError, 53000, 540000) then
    Action := 'updating the SOR';

  ErrString := Format('Error %d occurred when %s.', [ActualError, Action]);

  //If the error is related to locking, give the user some additional information
  if ActualError in [78, 81, 84, 85, 93] then
    ErrString := ErrString + #10#13 +
      'This may be because a record is locked by another workstation.';

  {$IFDEF ENTER1}
  if ActualError = 99 then
    msgBox('No values for ' + LowerCase(Process), mtError, [mbOK], mbOK, Process)
  else
    msgBox(ErrString, mtError, [mbOK], mbOK, Process);
  {$ENDIF}
end;


//=========================================================================

Function NewOrderPaymentsSRC : IOrderPaymentsSRC;
Begin // NewOrderPaymentsSRC
  Result := TOrderPaymentsSRC.Create;
End; // NewOrderPaymentsSRC

//=========================================================================


Constructor TOrderPaymentsSRC.Create;
Begin // Create
  Inherited Create;

  FAccount := '';
  FCurrency := 0;
  FPaymentValue := 0;
  FBankGL := 0;
  FPayInRef := '';
  FCostCentre := '';
  FDepartment := '';
  FTransactionRef := '';
  FPaymentRef := '';
  FSINRef := '';

  // MH 29/06/2015 2015-R1 ABSEXCH-16507: Made COM Toolkit Transaction Date property standard
  FSRCTransDate := ETDateU.Today;

  // MH 03/07/2015 2015-R1 ABSEXCH-16408: Copy SOR YourRef into SRC
  FYourRef := '';
End; // Create

//------------------------------

Destructor TOrderPaymentsSRC.Destroy;
Begin // Destroy

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TOrderPaymentsSRC.GetAccount : String;
Begin // GetAccount
  Result := FAccount;
End; // GetAccount
Procedure TOrderPaymentsSRC.SetAccount (Value : String);
Begin // SetAccount
  FAccount := Value;
End; // SetAccount

//------------------------------

Function TOrderPaymentsSRC.GetCurrency : Integer;
Begin // GetCurrency
  Result := FCurrency;
End; // GetCurrency
Procedure TOrderPaymentsSRC.SetCurrency (Value : Integer);
Begin // SetCurrency
  FCurrency := Value;
End; // SetCurrency

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.GetBankGL: Integer;
begin
  Result := FBankGL;
end; // GetBankGL

procedure TOrderPaymentsSRC.SetBankGL(Value: Integer);
begin
  FBankGL := Value;
end; // SetBankGL

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.GetDepartment: String;
begin
  Result := FDepartment;
end; // GetDepartment

procedure TOrderPaymentsSRC.SetDepartment(Value: String);
begin
  FDepartment := Value;
end; // SetDepartment

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.GetPaymentValue: Double;
begin
  Result := FPaymentValue;
end; // GetValue

procedure TOrderPaymentsSRC.SetPaymentValue(Value: Double);
begin
  FPaymentValue := Value;
end; // SetValue

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.GetCostCentre: String;
begin
  Result := FCostCentre;
end; // GetCostCentre

procedure TOrderPaymentsSRC.SetCostCentre(Value: String);
begin
  FCostCentre := Value;
end; // SetCostCentre

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.GetPayInRef: String;
begin
  Result := FPayInRef;
end; // GetPayInRef

procedure TOrderPaymentsSRC.SetPayInRef(Value: String);
begin
  FPayInRef := Value;
end; // SetPayInRef

//-------------------------------------------------------------------------
//Results:
//   0         Success
//   5001-5999 Error storing SRC Header
//   6001-6999 Error storing SRC Line
//   7001-7999 Error storing Audit Note for SRC
//   8001-8999 Error storing OP Matching

function TOrderPaymentsSRC.Save: integer;
//Details for storing header and line adapted from RecepU.pas/PayLineU.pas
var
  NewSRC : InvRec;
  i : integer;

  SavedPos : Integer;
  Res1 : Integer;

  procedure SetResult(Res : Integer; Weight : Integer);
  begin
    if Res = 0 then
      Result := Res
    else
      Result := Res + Weight;
  end;

  procedure SetMatchValue;
  var
    Res : Integer;
    KeyS : Str255;
  begin
    FMatchValue := FPaymentValue;

    //We only need to check the outstanding value on the matching transaction if we're doing a refund
    if FOPElement = opeInvoiceRefund then
    with FExLocal^ do
    begin
      //Find transaction to match to and check outstanding amount
      KeyS := LJVar(FTransactionRef,DocKeyLen);
      Res := LFind_Rec(B_GetEq, InvF, InvOurRefK, KeyS);

      if Res = 0 then
      begin
        //We want to allocate the lower of the SRC value and the Settled value on the target transaction

        //PR: 19/09/2014 ABSEXCH-15640 Was using base settled rather than currency
        FMatchValue := Sign(FPaymentValue) * Min(Abs(FPaymentValue), LInv.CurrSettled)

      end
      else
        raise Exception.Create('Unable to get settled amount from ' + FTransactionRef);
    end;
  end;

  function StoreHeader : Integer;
  begin
    with FExLocal^ do
    begin
      LResetRec(InvF);

      LInv.InvDocHed := SRC;
      SetHeaderDefaults;


      //Set Line count fields to include 1 trans line (+ possible variance line) and 1 notes line
      LInv.NLineCount:=2;
      LInv.ILineCount:=3;


      //Value
      LInv.InvNetVal := FPaymentValue;

      //PR: 03/10/2014  ABSEXCH-15683 moved from below so we set variance correctly
      dVarianceNeeded := VarianceNeeded;

      LInv.Variance := dVarianceNeeded;
      LInv.TotalReserved := LInv.Variance;

      //Settled values if we're paying/refunding against an invoice
      if FOPElement in [opeOrderRefund, opeInvoicePayment, opeInvoiceRefund] then
      begin
        LInv.CurrSettled := FMatchValue * -1;
        LInv.Settled := Conv_TCurr(LInv.CurrSettled, XRate(LInv.CXRate, False, FExLocal.LInv.Currency), FExLocal.LInv.Currency, 0, False) - LInv.Variance;
        LInv.BDiscount := FMatchValue;
      end;

      LInv.TotalInvoiced := Conv_TCurr(FPaymentValue, XRate(LInv.CXRate, False, FExLocal.LInv.Currency), FExLocal.LInv.Currency, 0, False);
//      LInv.TotalOrdered := FPaymentValue;

      //PR: 05/11/2014 ABSEXCH-15797 Set AllocStat correctly
      Set_DocAlcStat(LInv, False);

      //Set RemitNo if required
      if Trim(FRemitNo) <> '' then
        LInv.RemitNo := FRemitNo;

      //Insert Record
      Result := LAdd_Rec(InvF, 0);

      //Update account balance if required
      if (Result = 0) and Not Syss.UpBalOnPost then
        LUpdateCustBal(LastInv,LInv);

    end; //with DataAccess
  end; //StoreHeader


begin
  SavedPos :=0;
  SetMatchValue;

  SetResult(StoreHeader, 5000);

  //PR: ABSEXCH-16143 store position of record rather than just contents
  If (Result = 0) Then
  with FExLocal^ do
  begin
    // Store position of the SRC we have just created as the matching routines for refunds will change it
    // to the payment SRC being refunded
    LGetRecAddr(InvF);
    SavedPos := LastRecAddr[InvF];
  end;

  if Result = 0 then
    SetResult(StorePaymentLine(FPaymentValue), 6000);

  if Result = 0 then
    SetResult(AddAuditNote, 7000);

  if (Result = 0) then
      SetResult(AddFinancialMatching, 0); //Amended to deal with order payment matching as well - result returned includes weighting

  If (Result = 0) Then
  //PR: ABSEXCH-16143 restore position of record rather than just contents
  with FExLocal^ do
  begin
    // Restore original position / record (SRC)
    LastRecAddr[InvF] := SavedPos;
    SetResult(LGetDirectRec(InvF, 0), 52000);  // Idx 0 used for insert of SRC
  end;
end; // Save

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.GetRemitNo: String;
begin
  Result := FRemitNo;
end; // GetRemitNo

procedure TOrderPaymentsSRC.SetRemitNo(Value: String);
begin
  FRemitNo := Value;
end; // SetRemitNo

//-------------------------------------------------------------------------
Function TOrderPaymentsSRC.GetOrderReference : String;
begin
  Result := FOrderReference;
end; // GetOrderReference

Procedure TOrderPaymentsSRC.SetOrderReference(Value : string);
begin
  FOrderReference := Value;
end; // SetOrderReference

//-------------------------------------------------------------------------

Function TOrderPaymentsSRC.GetExLocal : TdPostExLocalPtr;
begin
  Result := FExLocal;
end;

Procedure TOrderPaymentsSRC.SetExLocal(const Value : TdPostExLocalPtr);
begin
  FExLocal := Value;
end;

//-------------------------------------------------------------------------
Function TOrderPaymentsSRC.GetTransactionRef : String;
begin
  Result := FTransactionRef;
end;

Procedure TOrderPaymentsSRC.SetTransactionRef(Value : string);
begin
  FTransactionRef := Value;
end;

//-------------------------------------------------------------------------
Function TOrderPaymentsSRC.GetOurRef : String;
begin
  Result := FOurRef;
end;

Procedure TOrderPaymentsSRC.SetOurRef(Value : string);
begin
  FOurRef := Value;
end;


//-------------------------------------------------------------------------

Function TOrderPaymentsSRC.GetOPElement : enumOrderPaymentElement;
begin
  Result := FOPElement;
end; // GetOPElement

Procedure TOrderPaymentsSRC.SetOPElement(Value : enumOrderPaymentElement);
begin
  FOPElement := Value;
end; // SetOPElement

//-------------------------------------------------------------------------
procedure TOrderPaymentsSRC.SetHeaderDefaults;
begin
  with FExLocal^ do
  begin
    {$IFDEF COMTK}
    if FSRCYear <> 0 then
    begin
      LInv.TransDate := FSRCTransDate;
      LInv.AcYr := FSRCYear;
      LInv.AcPr := FSRCPeriod;
    end
    else
    {$ENDIF}
    begin
      // MH 29/06/2015 2015-R1 ABSEXCH-16507: Added in Payment Date on Payment window
      LInv.TransDate := FSRCTransDate;
      LInv.AcPr := GetLocalPr(0).CPr;
      LInv.AcYr := GetLocalPr(0).CYr;

      If Syss.AutoPrCalc then //Calculate period from date - Date2Pr contains call to customisation if CU defined
        Date2Pr(LInv.TransDate,LInv.AcPr,LInv.AcYr,FExLocal);
    end;
    LInv.DueDate := LInv.TransDate;
    LInv.UntilDate := LInv.TransDate;

    //Standard fields
    LInv.CustSupp := TradeCode[True];
    LInv.OpName := EntryRec^.Login;
    LInv.NomAuto := True; //NomAuto is true for normal trans, false for Auto-transactions.
    TransactionOriginator.SetOriginator(LInv);

    //Account
    LInv.CustCode := FullCustCode(FAccount);

    //Ctrl GL
    LInv.CtrlNom := FControlGL;

    //Set currency and rates
    LInv.Currency := FCurrency;
    LInv.CXrate := SyssCurr.Currencies[FCurrency].CRates;

    //Incomprehensible Eduardo currency stuff
    //----------------------------------------------------
    LInv.CXRate[False] := 0;

    LInv.VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;

    with LInv do
    begin
      SetTriRec(FCurrency,UseORate,CurrTriR);
      SetTriRec(FCurrency,UseORate,OrigTriR);
      SetTriRec(Syss.VATCurr,UseORate,VATTriR);
    end;
    //-----------------------------------------------------

    //Set OurRef & Folio
    //PR: 22/01/2015 Set SRC ref for disaster recovery if needed
    {$IFDEF COMTK}
    if Trim(FSRCRef) <> '' then
    begin
      LInv.OurRef := FSRCRef;

      //Need to set Folio Number separately
      LInv.FolioNum := LGetNextCount(FOL, True, False, 0);
    end
    else
    {$ENDIF}
      LSetNextDocNos(LInv, True);

    FOurRef := LInv.OurRef;

    //Order payment tracking fields
    LInv.thOrderPaymentOrderRef := FOrderReference;
    LInv.thOrderPaymentElement := FOPElement;

    // MH 03/07/2015 2015-R1 ABSEXCH-16408: Copy SOR YourRef into SRC
    LInv.YourRef := FYourRef;
 end; //with
end;


//-------------------------------------------------------------------------
function TOrderPaymentsSRC.AddFinancialMatching : Integer;
var
  KeyS, KeyChk : Str255;
  SRCRef : string;
  Res : Integer;
  OrderSINRef : Integer; //ABSEXCH-15717
  oMatcher : IMatcher;
begin
  Result := 0;
  oMatcher := NewMatcher(FOPElement); //OrderPaymentsMatching.pas

  if Assigned(oMatcher) then
  Try
    oMatcher.Currency := FCurrency;
    oMatcher.SORRef := FOrderReference;
    oMatcher.SRCRef := FOurRef;
    oMatcher.VATPayList := FVATPayList;

    //PR: 18/01/2015 Need to pass in the SIN OurRef to SIN refunds
    if FOPElement = opeInvoiceRefund then
    begin
      oMatcher.MatchRef := FPaymentRef;
      oMatcher.SINRef := FTransactionRef;
    end
    else
      oMatcher.MatchRef := FTransactionRef;

    oMatcher.ExLocal := FExLocal;
    oMatcher.Amount := FMatchValue;
    Result := oMatcher.Execute;
  Finally
    oMatcher := nil;
  End;
end;

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.AddAuditNote: integer;
var
  AuditNote : TAuditNote;
begin
  Result := 999;
  auditNote := TAuditNote.Create(EntryRec^.Login, @FExLocal.LocalF[PwrdF], FExLocal.ExClientID);
  Try
    Result := auditNote.AddNote(anTransaction, FExLocal.LInv.FolioNum, anCreate);
  Finally
    auditNote.Free;
  End;

end;

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.GetCardType : string;
begin
  Result := FCardType;
end;

procedure TOrderPaymentsSRC.SetCardType(const Value : string);
begin
  FCardType := Value;
end;

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.GetCardNo : string;
begin
  Result := FCardNo;
end;

procedure TOrderPaymentsSRC.SetCardNo(const Value : string);
begin
  FCardNo := Value;
end;

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.GetCardExpiry : string;
begin
  Result := FCardExpiry;
end;

procedure TOrderPaymentsSRC.SetCardExpiry(const Value : string);
begin
  FCardExpiry := Value;
end;

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.GetCardAuthorisationNo : string;
begin
  Result := FCardAuthorisationNo;
end;

procedure TOrderPaymentsSRC.SetCardAuthorisationNo(const Value : string);
begin
  FCardAuthorisationNo := Value;
end;

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.GetCardReferenceNo : string;
begin
  Result := FCardReferenceNo;
end;

procedure TOrderPaymentsSRC.SetCardReferenceNo(const Value : string);
begin
  FCardReferenceNo := Value;
end;

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.StorePaymentLine(Value : Double) : Integer;
begin
  with FExLocal^ do
  begin
    LResetRec(IDetailF);

    //Fields taken directly from header
    LId.FolioRef := LInv.FolioNum;
    LId.DocPRef := LInv.OurRef;
    LId.PDate := LInv.TransDate;
    LId.PPr := LInv.AcPr;
    LId.PYr := LInv.AcYr;
    LId.IdDocHed := LInv.InvDocHed;
    LId.CXRate:=LInv.CXRate;
    LId.CurrTriR:=LInv.CurrTriR;
    LId.Currency := LInv.Currency;
    LId.CustCode := FAccount;

    //General line fields
    if LInv.InvDocHed = SRC then
      LId.Payment := DocPayType[LId.IdDocHed]
    else
      LId.Payment := 'N';
    LId.Qty := 1.0;
    LId.QtyMul := 1;
    LId.LineNo := RecieptCode;
    LId.AbsLineNo := 1;
    LId.PriceMulx := 1;


    //Reconcile if needed
    If (Syss.AutoClearPay) then
      LId.Reconcile:=ReconC;

    //Fields set in interface
    LId.CCDep[True] := FCostCentre;
    LId.CCDep[False] := FDepartment;
    LId.NomCode := FBankGL;
    LId.StockCode := Pre_PostPayInKey(PayInCode, FPayInRef);
    LId.NetValue := Value;


    //Insert record
    Result := LAdd_Rec(IDetailF, 0);

    if Result = 0 then
    begin

      if not ZeroFloat(dVarianceNeeded) then
        Result := StoreVarianceLine(dVarianceNeeded);
    end;
  end; //With DataAccess
end; //StoreLine

Function TOrderPaymentsSRC.GetPaymentRef : String;
begin
  Result := FPaymentRef;
end;

Procedure TOrderPaymentsSRC.SetPaymentRef(Value : string);
begin
  FPaymentRef := Value;
end;


function TOrderPaymentsSRC.StoreVarianceLine(VarianceAmount : Double): integer;
begin
  with FExLocal^ do
  begin
    LId.AbsLineNo := 2;
    LId.NetValue := VarianceAmount;
    LId.Currency := 1;
    LId.NomCode := Syss.NomCtrlCodes[CurrVar];
    LId.CXRate[False] := 1;
    LId.CXRate[True] := 1;

    Result := LAdd_Rec(IDetailF, 0);
  end;
end;

function TOrderPaymentsSRC.VarianceNeeded: Double;
var
  ThisRate : Double;
  ThisBase, OriginalBase : Double;
begin
  Result := 0;
  ThisRate := XRate(FExLocal.LInv.CXRate, False, FExLocal.LInv.Currency);
  if ThisRate <> FOriginalXRate then
  begin
    ThisBase := Conv_TCurr(FPaymentValue, ThisRate, FExLocal.LInv.Currency, 0, False);
    OriginalBase := Conv_TCurr(FPaymentValue, FOriginalXRate, FExLocal.LInv.Currency, 0, False);
    Result := Round_Up(OriginalBase - ThisBase, 2);
  end;
end;

procedure TOrderPaymentsSRC.SetOriginalXRate(Value: Double);
begin
  FOriginalXRate := Value;
end;

procedure TOrderPaymentsSRC.SetControlGL(Value: Integer);
begin
  FControlGL := Value;
end;

procedure TOrderPaymentsSRC.SetSINReference(const PayRef: string);
var
  Res : Integer;
  KeyS, KeyChk : Str255;
  Found : Boolean;
begin
  //If we're refunding either a SIN or an order which has been converted to a SIN we
  //need to know the OurRef of the SIN as we need to unallocate it, when the payment SRC
  //is now matched to the refund SRC. This procedure finds the match record for the payment we're refunding
  //and checks the DocCode - if it's a SIN then we put the OurRef in FSINRef.
  //If we don't have a SIN then FSINRef is left as an empty string
  with FExLocal^ do
  begin
    KeyS := MatchTCode + MatchSCode + PayRef;
    KeyChk := KeyS;
    Found := False;

    Res := LFind_Rec(B_GetGEq, PWrdF, HelpNdxK, KeyS);

    while (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) and not Found do
    begin
      Found := (Copy(LPassword.MatchPayRec.DocCode, 1, 3) = 'SIN' );

      //If not correct record then try next - if found then we leave it on the correct record for update
      if not Found then
        Res := LFind_Rec(B_GetNext, PWrdF, HelpNdxK, KeyS);

    end;

   if Found then
     FSINRef := LPassword.MatchPayRec.DocCode;

 end;
end;


function TOrderPaymentsSRC.GetVATPayList: TOrderPaymentsVATPayDetailsList;
begin
  Result := FVATPayList;
end;

procedure TOrderPaymentsSRC.SetVATPayList(
  const Value : TOrderPaymentsVATPayDetailsList);
begin
  FVATPayList := Value;
end;

{$IFDEF COMTK}
function TOrderPaymentsSRC.GetSRCPeriod: Integer;
begin
  Result := FSRCPeriod;
end;

function TOrderPaymentsSRC.GetSRCRef: ShortString;
begin
  Result := FSRCRef;
end;

function TOrderPaymentsSRC.GetSRCYear: Integer;
begin
  Result := FSRCYear;
end;

procedure TOrderPaymentsSRC.SetSRCPeriod(const Value: Integer);
begin
  FSRCPeriod := Value;
end;

procedure TOrderPaymentsSRC.SetSRCRef(const Value: ShortString);
begin
  FSRCRef := Value;
end;

procedure TOrderPaymentsSRC.SetSRCYear(const Value: Integer);
begin
  FSRCYear := Value;
end;
{$ENDIF COMTK}

//------------------------------

// MH 29/06/2015 2015-R1 ABSEXCH-16507: Made COM Toolkit Transaction Date property standard
function TOrderPaymentsSRC.GetSRCTransDate: ShortString;
begin
  Result := FSRCTransDate;
end;
procedure TOrderPaymentsSRC.SetSRCTransDate(const Value: ShortString);
begin
  FSRCTransDate := Value;
end;

//------------------------------

// MH 03/07/2015 2015-R1 ABSEXCH-16408: Copy SOR YourRef into SRC
Function TOrderPaymentsSRC.GetYourRef : ShortString;
Begin // GetYourRef
  Result := FYourRef
End; // GetYourRef
Procedure TOrderPaymentsSRC.SetYourRef (Value : ShortString);
Begin // SetYourRef
  FYourRef := Value
End; // SetYourRef

//------------------------------

//PR: 30/01/2015 ABSEXCH-16102 Getter and setter for CreaditCardAction property
function TOrderPaymentsSRC.GetCreditCardAction: enumCreditCardAction;
begin
  Result := FCreditCardAction;
end;

procedure TOrderPaymentsSRC.SetCreditCardAction(
  Value: enumCreditCardAction);
begin
  FCreditCardAction := Value;
end;

function TOrderPaymentsSRC.Update: Integer;
var
  Res : Integer;
  KeyS : Str255;
begin
  with FExLocal^ do
  begin
    //PR: 02/02/2015 Moved from above as we're now setting these fields after storing the SRC (but still within the db transaction)
    //PR: 18/02/2015 No need to fetch record again as position will have been restored before calling this function

    //Credit Card detail fields
    LInv.thCreditCardType := FCardType;
    LInv.thCreditCardNumber := FCardNo;
    LInv.thCreditCardExpiry := FCardExpiry;
    LInv.thCreditCardAuthorisationNo := FCardAuthorisationNo;
    LInv.thCreditCardReferenceNo := FCardReferenceNo;

    //PR: 30/01/2015 ABSEXCH-16102 Set Order Payment flags for SRC
    if FCreditCardAction in [ccaRequestPayment, ccaRequestPaymentUsingExistingAuth, ccaRequestRefund] then
    begin
      LInv.thOrderPaymentFlags := thopfCreditCardPaymentTaken;

      // MH 29/01/2015 v7.1 ABSEXCH-16088: Copy Credit Card fields into additional payment details fields (aka Delivery Address)
      // MH 03/02/2015 v7.1 ABSEXCH-16109: Only set additional payment details fields (aka Delivery Address) for Credit Card transactions
      LInv.DAddr[1] := LInv.thCreditCardType;
      LInv.DAddr[2] := 'XXXX-XXXX-XXXX-' + LInv.thCreditCardNumber;
      LInv.DAddr[3] := Copy(LInv.thCreditCardExpiry, 1, 2) + '/' + Copy(LInv.thCreditCardExpiry, 3, 2);
      LInv.DAddr[4] := LInv.thCreditCardAuthorisationNo;
    end; // if FCreditCardAction in […


    Res := LPut_Rec(InvF, InvOurRefK);

    if Res <> 0 then
      Res := Res + 10000;
  end;

  Result := Res;
end;

End.
