Unit oOrderPaymentsSRC;

Interface

Uses GlobVar, VarConst, ExBtth1u, Classes, OrderPaymentsInterfaces;

Type
  TIntrastatTransctionType = (ittNormal, ittTriangulation, ittProcess);

  //Object for processing serial batch records for stock lines on SRF
  TSerialBatchDetails = Class
    BatchNo : String;
    LineNo : Integer;
    StockCode : string;
    StockFolio : longint;
    Location : string;
    Qty : Double;
    RecordAddress : longint;
  end;

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

    //Credit card details to be stored in SRC header
    Property CardType : String Read GetCardType Write SetCardType;
    Property CardNo : String Read GetCardNo Write SetCardNo;
    Property CardExpiry : String Read GetCardExpiry Write SetCardExpiry;
    Property CardAuhorisationNo : String Read GetCardAuthorisationNo Write SetCardAuthorisationNo;
    Property CardReferenceNo : String Read GetCardReferenceNo Write SetCardReferenceNo;

    Property ExLocal : TdPostExLocalPtr Read GetExLocal write SetExLocal;

    // ------------------- Public Methods --------------------
    function Save : integer;
  End; // IOrderPaymentsSRC

  IOrderPaymentsSRF = Interface(IOrderPaymentsSRC)
    function GetStockLineList : TInterfaceList;
    procedure SetPaymentTransaction(const Value : IOrderPaymentsTransactionPaymentInfoPaymentHeader);
    procedure SetSerialBatchList(const Value : TStringList);

    Property StockLineList : TInterfaceList read GetStockLineList;
    Property PaymentTransaction : IOrderPaymentsTransactionPaymentInfoPaymentHeader write SetPaymentTransaction;
    Property SerialBatchList : TStringList write SetSerialBatchList;
  end;


Function NewOrderPaymentsSRC : IOrderPaymentsSRC;
Function NewOrderPaymentsSRF : IOrderPaymentsSRF;

Implementation

uses
  BtKeys1U, EtDateU, SysU1, Event1U, CurrncyU, ComnUnit, TransactionOriginator, SysUtils, AuditNotes, EtStrU,{$IFNDEF EXDLL} LedgSupU, {$ENDIF}BtrvU2,
  Math, BtSupU1, EtMiscU, InvCtSuU, VarRec2U, SysU2, Forms, {$IFNDEF EXDLL} Saltxl2u, {$ENDIF} Contnrs, MathUtil;

const
  CURRENCY_DEC_PLACES = 6;

Type
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

    //Value for matching - if payment this will equal FPaymentValue; if Refund then it must be the smaller
    //of FPaymentValue and the outstanding amount on the matching document
    FMatchValue : Double;
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


    //Internal functions
    function AddMatching(const DocRef : String; const PayRef : String) : integer;
    function AddOrderPaymentMatching : integer;
    function AddFinancialMatching : integer;
    function AddAuditNote : integer;
    function StorePaymentLine(Value : Double) : Integer;
    procedure SetHeaderDefaults;

    function VarianceNeeded : Double;
    function StoreVarianceLine(VarianceAmount : Double) : integer;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    //Stores transaction header and line
    function Save : integer; virtual;
  End; // TOrderPaymentsSRC


  TOrderPaymentsSRF = Class(TOrderPaymentsSRC, IOrderPaymentsSRF)
  protected
    FStockLineList : TInterfaceList;
    FPaymentTransaction : IOrderPaymentsTransactionPaymentInfoPaymentHeader;
    function GetStockLineList : TInterfaceList;
    procedure SetPaymentTransaction(const Value : IOrderPaymentsTransactionPaymentInfoPaymentHeader);
    procedure SetSerialBatchList(const Value : TStringList);
    function GetSerialBatch(anID : IDetail) : TObjectList;
    function ProcessSerialBatch(ASerialBatch : TSerialBatchDetails) : integer;
  public
    Constructor Create;
    Destructor Destroy; Override;
    function StoreLines : Integer;
    function Save : integer; override;

  end;


//=========================================================================

Function NewOrderPaymentsSRC : IOrderPaymentsSRC;
Begin // NewOrderPaymentsSRC
  Result := TOrderPaymentsSRC.Create;
End; // NewOrderPaymentsSRC

//=========================================================================

Function NewOrderPaymentsSRF : IOrderPaymentsSRF;
Begin // NewOrderPaymentsSRF
  Result := TOrderPaymentsSRF.Create;
End; // NewOrderPaymentsSRF

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
  i : integer;

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

      LInv.Variance := dVarianceNeeded;
      LInv.TotalReserved := LInv.Variance;

      //Settled values if we're paying/refunding against an invoice
      if FOPElement in [opeOrderRefund, opeInvoicePayment, opeInvoiceRefund] then
      begin
        LInv.CurrSettled := FMatchValue * -1;
        LInv.Settled := Conv_TCurr(LInv.CurrSettled, LInv.CXRate[UseCoDayRate], FExLocal.LInv.Currency, 0, False) - LInv.Variance;
        LInv.BDiscount := FMatchValue;
      end;

      LInv.TotalInvoiced := Conv_TCurr(FPaymentValue, LInv.CXRate[UseCoDayRate], FExLocal.LInv.Currency, 0, False);
//      LInv.TotalOrdered := FPaymentValue;
      LInv.AllocStat := #0;

      //Set RemitNo if required
      if Trim(FRemitNo) <> '' then
        LInv.RemitNo := FRemitNo;

      //Credit Card detail fields
      LInv.thCreditCardType := FCardType;
      LInv.thCreditCardNumber := FCardNo;
      LInv.thCreditCardExpiry := FCardExpiry;
      LInv.thCreditCardAuthorisationNo := FCardAuthorisationNo;
      LInv.thCreditCardReferenceNo := FCardReferenceNo;

      dVarianceNeeded := VarianceNeeded;



      //Insert Record
      Result := LAdd_Rec(InvF, 0);

      //Update account balance if required
      if (Result = 0) and Not Syss.UpBalOnPost then
        LUpdateCustBal(LastInv,LInv);

    end; //with DataAccess
  end; //StoreHeader


begin
  SetMatchValue;

  SetResult(StoreHeader, 5000);

  if Result = 0 then
    SetResult(StorePaymentLine(FPaymentValue), 6000);

  if Result = 0 then
    SetResult(AddAuditNote, 7000);

  if Result = 0 then
    SetResult(AddOrderPaymentMatching, 8000);

  if (Result = 0) and (FOPElement in [opeOrderRefund, opeInvoicePayment, opeInvoiceRefund]) then
      SetResult(AddFinancialMatching, 9000)
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
    LInv.TransDate := EtDateU.Today;
    LInv.DueDate := LInv.TransDate;
    LInv.AcPr := GetLocalPr(0).CPr;
    LInv.AcYr := GetLocalPr(0).CYr;

    If Syss.AutoPrCalc then //Calculate period from date - Date2Pr contains call to customisation if CU defined
      Date2Pr(LInv.TransDate,LInv.AcPr,LInv.AcYr,FExLocal);

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
    LSetNextDocNos(LInv, True);
    FOurRef := LInv.OurRef;

    //Order payment tracking fields
    LInv.thOrderPaymentOrderRef := FOrderReference;
    LInv.thOrderPaymentElement := FOPElement;
 end; //with
end;


//-------------------------------------------------------------------------
function TOrderPaymentsSRC.AddMatching(const DocRef : String; const PayRef : String) : integer;
begin
  with FExLocal^ do
  begin
    LResetRec(PWrdF);

    LPassWord.RecPFix:=MatchTCode;
    LPassWord.SubType := MatchOrderPaymentCode;

    LPassword.MatchPayRec.MatchType := MatchOrderPaymentCode;
    LPassword.MatchPayRec.DocCode := LJVar(DocRef,DocKeyLen);
    LPassword.MatchPayRec.PayRef := LJVar(PayRef,DocKeyLen);

    LPassword.MatchPayRec.MCurrency := FCurrency;
    LPassword.MatchPayRec.RCurrency := FCurrency;
    LPassword.MatchPayRec.OwnCVal := FPaymentValue;
    LPassword.MatchPayRec.SettledVal := Currency_Txlate(FPaymentValue, FCurrency, 0);

    Result := LAdd_Rec(PWrdF, 0);
  end; //with FDataAccess
end;

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.AddFinancialMatching : integer;
var
  KeyS : Str255;
  SRCRef : string;
begin
  with FExLocal^ do
  begin
    //Store SRC OurRef
    SRCRef := LInv.OurRef;

    //Reload transaction to match so we can update it
    KeyS := LJVar(FTransactionRef,DocKeyLen);
    Result := LFind_Rec(B_GetEq, InvF, InvOurRefK, KeyS);

    if Result = 0 then
    begin
      //Update settled value on transaction we're matching to
      LInv.CurrSettled := LInv.CurrSettled + FMatchValue;
      LInv.Settled := Conv_TCurr(LInv.CurrSettled, LInv.CXRate[UseCoDayRate], FExLocal.LInv.Currency, 0, False);

      //Set allocated status
      Set_DocAlcStat(LInv, False);

      //Set Remit No
      LInv.RemitNo := LPassword.MatchPayRec.PayRef;

      //Store
      Result := LPut_Rec(InvF, InvOurRefK);
    end;

    if Result <> 0 then
      Result := Result + 1000; //weighting to bring final result up to 10000 + Btrieve error

    if Result = 0 then
    begin
      LResetRec(PWrdF);

      LPassWord.RecPFix:=MatchTCode;
      LPassWord.SubType := MatchSCode;

      LPassword.MatchPayRec.MatchType := 'A';
      LPassword.MatchPayRec.DocCode := LJVar(FTransactionRef,DocKeyLen);
      LPassword.MatchPayRec.PayRef := LJVar(SRCRef,DocKeyLen);

      LPassword.MatchPayRec.MCurrency := FCurrency;
      LPassword.MatchPayRec.RCurrency := FCurrency;

      //Match value is set in the .Save function
      LPassword.MatchPayRec.OwnCVal := FMatchValue;
      LPassword.MatchPayRec.SettledVal := Conv_TCurr(LPassword.MatchPayRec.OwnCVal, LInv.CXRate[UseCoDayRate], FCurrency, 0, False);

      Result := LAdd_Rec(PWrdF, 0);

    end;
  end; //with FDataAccess
end;

//-------------------------------------------------------------------------
function TOrderPaymentsSRC.AddOrderPaymentMatching: integer;
begin
  //Always match against order
  Result := AddMatching(FOrderReference, FOurRef);

  if (Result = 0) and (FOPElement in [opeOrderRefund, opeInvoicePayment, opeInvoiceRefund]) then
  begin
    //Match against Invoice for invoice payment/refund or SRC for order refund
    Result :=  AddMatching(FTransactionRef, FOurRef);

    //Match agains SRC for Invoice Refund
    if (Result = 0) and (FPaymentRef <> '') then
      Result := AddMatching(FPaymentRef, FOurRef);
  end;
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


//
//================================================ TOrderPaymentsSRF methods =====================================//
//

Constructor TOrderPaymentsSRF.Create;
begin
  inherited;

  FStockLineList := TInterfaceList.Create;
end;

Destructor TOrderPaymentsSRF.Destroy;
begin
  FStockLineList.Free;

  FPaymentTransaction := nil;

  inherited Destroy;
end;


function TOrderPaymentsSRF.Save: integer;

  procedure SetResult(Res : Integer; Weight : Integer);
  begin
    if Res = 0 then
      Result := Res
    else
      Result := Res + Weight;
  end;

  function StoreHeader : Integer;
  var
    i : integer;
    vatno : VatType;
  begin
    with FExLocal^ do
    begin
      LResetRec(InvF);

      LInv.InvDocHed := SRF;
      SetHeaderDefaults;


      //Set Line count fields to include 1 notes line and enought transaction lines
      LInv.NLineCount:=2;
      LInv.ILineCount:=3 + (2 * FPaymentTransaction.opphPaymentLineCount);



      //Settled values if we're paying/refunding against an invoice

      //PR: 19/09/2014 ABSEXCH-15646 Settled fields need to be negative on an SRF
      LInv.CurrSettled := -FPaymentValue;
      LInv.Settled := Currency_Txlate(LInv.CurrSettled, LInv.Currency, 0);

      LInv.TotalInvoiced := FPaymentValue;
      LInv.TotalOrdered := FPaymentValue;

      //Totals
      for i := 0 to FPaymentTransaction.opphPaymentLineCount - 1 do
      with FPaymentTransaction.opphPaymentLines[i] do
      if opplRefundSelected then
      begin
        LInv.InvNetVal := LInv.InvNetVal + opplRefundGoods;

        //Update total vat
        LInv.InvVAT := LInv.InvVAT + opplRefundVAT;

        //Update appropriate vat analysis row
        vatno := GetVATNo(opplOrderLine.opolLine.VATCode, opplOrderLine.opolLine.VATIncFlg);
        LInv.InvVATAnal[vatno] := LInv.InvVATAnal[vatno] + opplRefundVAT;
      end;

      //SRF is automatically matched
      LInv.AllocStat := #0;

      //Insert Record
      Result := LAdd_Rec(InvF, 0);

      //Update account balance if required
      if (Result = 0) and Not Syss.UpBalOnPost then
        LUpdateCustBal(LastInv,LInv);


    end; //with DataAccess
  end; //StoreHeader

begin
  SetResult(StoreHeader, 5000);

  if Result = 0 then
    SetResult(StoreLines, 6000);

  if Result = 0 then
    SetResult(AddAuditNote, 7000);

  if Result = 0 then
    SetResult(AddOrderPaymentMatching, 8000);
end;

function TOrderPaymentsSRF.GetStockLineList : TInterfaceList;
begin
  Result := FStockLineList;
end;

function TOrderPaymentsSRF.StoreLines: Integer;
var
  i, j : integer;
  SerialBatchDetails : TSerialBatchDetails;
  DetailList : TObjectList;
  DeductQty : Double;
begin
  //Store payment line
  StorePaymentLine(FPaymentValue);

  //Populate and store stock lines
  with FExLocal^ do
  begin
    //Set common properties of lines
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

    for i := 0 to FPaymentTransaction.opphPaymentLineCount - 1 do
    with FPaymentTransaction.opphPaymentLines[i] do
    if opplRefundSelected then
    begin
      //Fields directly from SOR order line
      LId.StockCode := opplOrderLine.opolLine.StockCode;
      LId.Desc := opplOrderLine.opolLine.Desc;
      LId.MLocStk := opplOrderLine.opolLine.MLocStk;
      LId.CCDep := opplOrderLine.opolLine.CCDep;
      LId.NomCode := opplOrderLine.opolLine.NomCode;
      LId.VATCode := opplOrderLine.opolLine.VATCode;
      LId.CostPrice := opplOrderLine.opolLine.CostPrice;
      LId.QtyMul := opplOrderLine.opolLine.QtyMul;

      LId.JobCode := opplOrderLine.opolLine.JobCode;
      LId.AnalCode := opplOrderLine.opolLine.AnalCode;

      //Fields from the order payment system
      LId.Qty := opplRefundQuantity;
      LId.DeductQty := LId.Qty;
      LId.NetValue := Round_Up(DivWChk(opplRefundGoods, LId.Qty), Syss.NoNetDec);
      LId.VAT := opplRefundVAT;

      //Line numbers
      LId.LineNo := 3 + (i * 2);
      LId.AbsLineNo := opplOrderLine.opolLine.AbsLineNo;

      //Do Serial/BatchStuff
      if Assigned(FSerialBatchList) and (FSerialBatchList.Count > 0) then
      begin
        //Find appropriate serial batch
        DetailList := GetSerialBatch(LId);

        if Assigned(DetailList) then
        begin
          DeductQty := 0;
          for j := 0 to DetailList.Count - 1 do
          begin
            DeductQty := DeductQty + TSerialBatchDetails(DetailList[j]).Qty;
            //Delete serial or update/delete batch child
            ProcessSerialBatch(TSerialBatchDetails(DetailList[j]));

          end;

          //Set serial qty on line
          LId.SerialQty := DeductQty;
        end;
      end;

      //Insert Record
      Result := LAdd_Rec(IDetailF, 0);

(*      //If Serial/Multibin  item then do appropriate stuff
      if Is_SerNo(Stock.StkValType) or Stock.MultiBinMode then
      with FExLocal^ do
      begin
        //Display dialog
        {$IFNDEF EXDLL}
        Control_SNos(LId, LInv, Stock, 1, Application.MainForm.ActiveMDIChild, FExLocal);

        //store line with updated values
        LPut_Rec(IDetailF, 0);
        {$ENDIF}
      end; *)

      //Stock movement/valuation
      Stock_Deduct(LId, LInv, True, True, 0, FExLocal);

    end;
  end;
end;

procedure TOrderPaymentsSRF.SetPaymentTransaction(
  const Value: IOrderPaymentsTransactionPaymentInfoPaymentHeader);
begin
  FPaymentTransaction := Value;
end;


procedure TOrderPaymentsSRF.SetSerialBatchList(const Value: TStringList);
begin
  FSerialBatchList := Value;
end;

function TOrderPaymentsSRF.GetSerialBatch(
  anID: IDetail): TObjectList;
var
  i : Integer;
  KeyS : string;
begin
  Result := nil;

  KeyS := anID.StockCode + IntToStr(anID.AbsLineNo);
  for i := 0 to FSerialBatchList.Count - 1 do
    if FSerialBatchList[i] = KeyS then
    begin
      if Result = nil then
        Result := TObjectList.Create;

      if Assigned(Result) then
        Result.Add(FSerialBatchList.Objects[i]);
    end;

end;

function TOrderPaymentsSRF.ProcessSerialBatch(
  ASerialBatch: TSerialBatchDetails): integer;
var
  Res : Integer;
  KeyS, KeyChk : Str255;
  ParentFolio : longint;
  Found : Boolean;
begin
  FExLocal.LastRecAddr[MiscF] := ASerialBatch.RecordAddress;
  Result := FExLocal.LGetDirectRec(MiscF, 0);

  if Result = 0 then
  begin
    with FExLocal.LMiscRecs.SerialRec do
    begin
      if Trim(SerialNo) <> '' then
      begin //Serial no
        Sold := False;
        SerSell := 0;
        DateOut := '        ';
        SoldLine := 0;
        OutMLoc := '   ';
        OutDoc := '          ';
        InDoc := FExLocal.LInv.OurRef;
        SerialCode := MakeSNKey(ASerialBatch.StockFolio,Sold,SerialNo);
        Result := FExLocal.LPut_Rec(MiscF, MIK);
      end
      else
      begin
        Found := False;
        ParentFolio := ChildNfolio;

        //Reduce value on Batch Child
        QtyUsed := QtyUsed - ASerialBatch.Qty;
        //if we've unused all the used items on child delete it else update it
        if ZeroFloat(QtyUsed) then
          Result := FExLocal.LDelete_Rec(MiscF, MIK)
        else
          Result := FExLocal.LPut_Rec(MiscF, MIK);

        //Find and update Batch Parent
        KeyS := MFIFOCode+MSernSub + ASerialBatch.BatchNo;
        KeyChk := KeyS;

        Res := FExLocal.LFind_Rec(B_GetGEq, MiscF, MiscBtcK, KeyS);

        while (Res = 0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and not Found do
        begin
          Found := not BatchChild and (NoteFolio = ParentFolio);

          if not Found then
            Res := FExLocal.LFind_Rec(B_GetNext, MiscF, MiscBtcK, KeyS);
        end;

        if Found then
        begin
          //Reduce used qty
          QtyUsed := QtyUsed - ASerialBatch.Qty;

          //Store record
          Result := FExLocal.LPut_Rec(MiscF, MiscBtcK);
        end;
      end; //Batch
    end; //with FExLocal
  end; //Result = 0
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
  ThisRate := FExLocal.LInv.CXRate[UseCoDayRate];
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

End.
