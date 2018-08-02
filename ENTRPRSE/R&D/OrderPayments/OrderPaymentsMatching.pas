unit OrderPaymentsMatching;

interface

Uses GlobVar, VarConst, ExBtth1u, Classes, OrderPaymentsInterfaces, oOPVATPayMemoryList;

Type

  //Interface for financial and order payment matching - implemented by specialised objects to deal with different scenarios
  IMatcher = Interface
  ['{58A6774C-EB23-4A68-83A2-A2C4B753A062}']
    function GetSORRef : String;
    procedure SetSORRef(const Value : String);

    function GetSRCRef : String;
    procedure SetSRCRef(const Value : String);

    function GetSINRef : String;
    procedure SetSINRef(const Value : String);

    function GetMatchRef : String;
    procedure SetMatchRef(const Value : String);             

    Function GetExLocal : TdPostExLocalPtr;
    Procedure SetExLocal(const Value : TdPostExLocalPtr);

    function GetAmount : Double;
    procedure SetAmount(Value : Double);

    function GetCurrency : Integer;
    procedure SetCurrency(Value : Integer);

    function GetVATPayList : TOrderPaymentsVATPayDetailsList;
    procedure SetVATPayList(const Value : TOrderPaymentsVATPayDetailsList);

    function Execute : Integer;

    property SORRef : string read GetSORRef write SetSORRef;
    property SRCRef : string read GetSRCRef write SetSRCRef;
    property SINRef : string read GetSINRef write SetSINRef;
    property MatchRef : string read GetMatchRef write SetMatchRef;
    property Amount : Double read GetAmount write SetAmount;
    property Currency : Integer read GetCurrency write SetCurrency;
    property ExLocal : TdPostExLocalPtr Read GetExLocal write SetExLocal;

    property VATPayList : TOrderPaymentsVATPayDetailsList read GetVATPayList write SetVATPayList;
  end;

  function NewMatcher(AnElement : enumOrderPaymentElement) : IMatcher;

implementation

uses
  BtKeys1U, EtDateU, SysU1, Event1U, CurrncyU, ComnUnit, TransactionOriginator, SysUtils, AuditNotes, EtStrU,{$IFNDEF EXDLL} LedgSupU, {$ENDIF}BtrvU2,
  Math, BtSupU1, EtMiscU, InvCtSuU, VarRec2U, SysU2, Forms, {$IFNDEF EXDLL} Saltxl2u, {$ENDIF} Contnrs, MathUtil,ComnU2,
  oOPVATPayBtrieveFile, MiscU, oOrderPaymentsTransactionInfo;

type
  //Record for adding matching record to VATPay table
  PSINLine = ^TSINLine;
  TSINLine = Record
    VATPayRec : OrderPaymentsVATPayDetailsRecType;
    Goods : Double;
    VAT   : Double;
    VATRate : Double;
  end;

  //Record for keeping track of how much goods and vat is left to allocate for a line
  PCheckRecord = ^TCheckRecord;
  TCheckRecord = Record
    SORLine : Integer;
    Goods : Double;
    VAT   : Double;
  end;

  //Class to apportion SOR payment value to matching records for SIN lines
  TSINApportioner = Class
  protected
    FList : TList;
    FVATPayList : TOrderPaymentsVATPayDetailsList;
    CheckList : TList;
    FSINTotal : Double;
    FPaymentTotal : Double;
    FThisTotal : Double;
    FOrderPaymentsTransaction : IOrderPaymentsTransactionInfo;
    function GetCount : Integer;
    procedure CalculateLineValues(var Line : TSINLine);
    procedure LoadCheckList;
    function GetCheckRec(LineNo : Integer) : PCheckRecord;
    procedure FillLocalCheckRec(CheckRec : PCheckRecord);
  public
    procedure Execute;
    procedure Clear;
    procedure Add(Goods : Double; VAT : Double; VATRate : Double;
                  AVATPayRec : OrderPaymentsVATPayDetailsRecType);
    constructor Create;
    destructor Destroy; override;
    property Count : Integer read GetCount;
    property SINTotal : Double read FSINTotal write FSINTotal;
    property ThisTotal : Double read FTHisTotal write FThisTotal;
    property PaymentTotal : Double read FPaymentTotal write FPaymentTotal;
    property VATPayList : TOrderPaymentsVATPayDetailsList read FVATPayList write FVATPayList;
    property OrderPaymentsTransaction : IOrderPaymentsTransactionInfo read FOrderPaymentsTransaction write FOrderPaymentsTransaction;
  end;

  {Base class for matching. Descendent classes implement the functions GetNextTrans, which returns the next transaction to be matched to,
   and AddRecord, which adds the appropriate financial and order payment matching records and updates existing matching records and
   transactions where necessary.}
  TMatcher = Class(TInterfacedObject, IMatcher)
  protected
    FSORREf : string;
    FSRCRef : string;
    FSINRef : string;

    FMatchRef : string;
    FCurrency : Integer;

    FAmount : Double;

    FExLocal : TdPostExLocalPtr;

    FVATPayList: TOrderPaymentsVATPayDetailsList;

    ThisAmount : Double;
    OriginalAmount : Double;

    FKeyS : Str255;
    FKeyChk : Str255;
    FBFunc : Integer;

    FRecAddress : Integer;


    //Interface functions
    function GetSORRef : String;
    procedure SetSORRef(const Value : String);

    function GetSRCRef : String;
    procedure SetSRCRef(const Value : String);

    function GetSINRef : String;
    procedure SetSINRef(const Value : String);

    function GetMatchRef : String;
    procedure SetMatchRef(const Value : String);

    function GetCurrency : Integer;
    procedure SetCurrency(Value : Integer);

    Function GetExLocal : TdPostExLocalPtr;
    Procedure SetExLocal(const Value : TdPostExLocalPtr);

    function GetVATPayList : TOrderPaymentsVATPayDetailsList;
    procedure SetVATPayList(const Value : TOrderPaymentsVATPayDetailsList);

    function GetAmount : Double;
    procedure SetAmount(Value : Double);


    function Execute : Integer;

    //local functions
    function FindNextTrans : Boolean; virtual; abstract; //Implemented by descendants

    function AddRecord : Integer; virtual; abstract; //Implemented by descendants

    function Finalise : Integer; virtual;

    function DoAddRecord(const DocCode : string; const PayRef : string; AnAmount : Double) : Integer;

    function UpdateMatchRecord : Integer; virtual;
    function UpdateMatchedTrans(const TransRef : string; AnAmount : Double) : Integer;

    function AddOrderPaymentMatching(const DocRef : String; const PayRef : String; AnAmount : Double) : integer;
    function AddDefaultOrderPaymentMatching : Integer;

    procedure SaveRecordPosition;
    procedure RestoreRecordPosition;
  end;

  TSORPaymentMatcher = Class(TMatcher)
  protected
    oSINApportioner : TSINApportioner;
    iOrderPaymentsTransaction : IOrderPaymentsTransactionInfo;
    procedure AddLine(const oSINApportioner : TSINApportioner);
    procedure AddVATPayMatchRecordsForSIN;
    function FindNextTrans : Boolean; override;
    function AddRecord : Integer; override;
    function GetOutstanding : Double;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TSINPaymentMatcher = Class(TMatcher)
  protected
    function FindNextTrans : Boolean; override;
    function AddRecord : Integer; override;
  end;

  TSINRefundMatcher = Class(TMatcher)
  protected
    function FindNextTrans : Boolean; override;
    function AddRecord : Integer; override;
    function UpdateSIN : Integer; virtual;
  end;

  TSORRefundMatcher = Class(TMatcher)
  protected
    function FindNextTrans : Boolean; override;
    function AddRecord : Integer; override;
  end;

  TSDNPaymentMatcher = Class(TMatcher)
  protected
    function FindNextTrans : Boolean; override;
    function AddRecord : Integer; override;
  end;

//=========================================================================

//Creates a matcher object for the element specified
function NewMatcher(AnElement : enumOrderPaymentElement) : IMatcher;
begin
  Case AnElement of
    opeOrderPayment : Result := TSORPaymentMatcher.Create;
    opeInvoicePayment : Result := TSINPaymentMatcher.Create;
    opeInvoiceRefund :  Result := TSINRefundMatcher.Create;
    opeOrderRefund : Result := TSORRefundMatcher.Create;
    opeDeliveryPayment : Result := TSDNPaymentMatcher.Create;
    else
      raise Exception.Create('Invalid Order Payment matcher type.');
  end;
end;


//==================== TMatcher ======================//

//Original SOR
function TMatcher.GetSORRef : String;
begin
  Result := FSORRef;
end;

procedure TMatcher.SetSORRef(const Value : String);
begin
  FSORRef := Value;
end;
//=========================================================================

//The SRC that's just been created
function TMatcher.GetSRCRef : String;
begin
  Result := FSRCRef;
end;

procedure TMatcher.SetSRCRef(const Value : String);
begin
  FSRCRef := Value;
end;
//=========================================================================

//The transaction that a refund is matching to
function TMatcher.GetMatchRef : String;
begin
  Result := FMatchRef;
end;

procedure TMatcher.SetMatchRef(const Value : String);
begin
  FMatchRef := Value;
end;
//=========================================================================

function TMatcher.GetCurrency : Integer;
begin
  Result := FCurrency;
end;

procedure TMatcher.SetCurrency(value : Integer);
begin
  FCurrency := Value;
end;
//=========================================================================


Function TMatcher.GetExLocal : TdPostExLocalPtr;
begin
  Result := FExLocal;
end;

Procedure TMatcher.SetExLocal(const Value : TdPostExLocalPtr);
begin
  FExLocal := Value;
end;
//=========================================================================

function TMatcher.GetAmount : Double;
begin
  Result := FAmount;
end;

procedure TMatcher.SetAmount(Value : Double);
begin
  FAmount := Value;
  OriginalAmount := Value;
end;
//=========================================================================

//Adds an order payment match record
function TMatcher.AddOrderPaymentMatching(const DocRef : String; const PayRef : String; AnAmount : Double) : integer;
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
    LPassword.MatchPayRec.OwnCVal := AnAmount;
    LPassword.MatchPayRec.SettledVal := Currency_Txlate(LPassword.MatchPayRec.OwnCVal, FCurrency, 0);

    //PR: 10/02/2015 ABSEXCH-16156 Change keypath to -1 to avoid change in position/keypath
    Result := LAdd_Rec(PWrdF, -1);

    if Result <> 0 then
      Result := 8000 + Result;
  end; //with FDataAccess
end;

//=========================================================================
//Calls AddOrderPaymentMatching with the most common values
function TMatcher.AddDefaultOrderPaymentMatching: Integer;
begin
  Result := AddOrderPaymentMatching(FSORRef, FMatchRef, ThisAmount);
end;

//=========================================================================
//Main function
function TMatcher.Execute : Integer;
begin
  FBFunc := B_GetGEq;
  ThisAmount := 0.0; //Set to the correct value by FindNextTrans function in sub-objects

  //Add order payment matching: Match this transaction to the original SOR
  Result := AddOrderPaymentMatching(FSORRef, FSRCRef, FAmount);

  //Iterate through all transactions until we've used up the match value
  while not ZeroFloat(FAmount) and (Result = 0) and FindNextTrans do
  begin
    SaveRecordPosition; //Store current position in matching table
    if Result = 0 then
      Result := AddRecord; //Adds the matching record & updates the transactions

    if Result = 0 then
    begin  //Reduce the match value by the amount we've just used
      FAmount := FAmount - ThisAmount;
      ThisAmount := 0.0;
    end;
    RestoreRecordPosition; //Back to the saved position in matching table
  end; //While

  if Result = 0 then
    Result := Finalise;

  //Set bias to specify where result happened (see OrderPaymentsInvoiceMatching.pas)
  // 8000 - adding Order Payment matching
  // 9000 - adding Financial Matching
  if (Result <> 0) and (Result < 8000) then
    Result := Result + 9000;
end;

//=========================================================================

//Adds a financial matching record to match DocCode to PayRef
function TMatcher.DoAddRecord(const DocCode : string; const PayRef : string; AnAmount : Double) : Integer;
begin
  with FExLocal^ do
  begin
    //Add the matching
    LResetRec(PWrdF);

    LPassWord.RecPFix:=MatchTCode;
    LPassWord.SubType := MatchSCode;

    LPassword.MatchPayRec.MatchType := 'A';

    LPassword.MatchPayRec.PayRef := LJVar(PayRef,DocKeyLen);
    LPassword.MatchPayRec.DocCode := LJVar(DocCode,DocKeyLen);

    LPassword.MatchPayRec.MCurrency := FCurrency;
    LPassword.MatchPayRec.RCurrency := FCurrency;

    //Match value is set in the .Save function
    //PR: 29/06/2014 ABSEXCH-15657 Values in matching should be positive even for a refund.
    LPassword.MatchPayRec.OwnCVal := Abs(AnAmount);
    LPassword.MatchPayRec.SettledVal := Conv_TCurr(Abs(LPassword.MatchPayRec.OwnCVal), XRate(LInv.CXRate, False, FCurrency), FCurrency, 0, False);

    //PR: 10/02/2015 ABSEXCH-16156 Change keypath to -1 to avoid change in position/keypath
    Result := LAdd_Rec(PWrdF, -1);
  end;
end;



{ TSORPaymentMatcher }

procedure TSORPaymentMatcher.AddLine(const oSINApportioner : TSINApportioner);
var
  VATPayRec : OrderPaymentsVATPayDetailsRecType;
  i : integer;
  IdTotal : Double;
  IdVAT : Double;
  VATRate : Double;
begin
  with FExLocal^ do
  begin
    IdTotal := Round_Up(InvLTotal(LId, True, (LInv.DiscSetl * Ord(LInv.DiscTaken))), 2);
    CalcVAT(LId, LInv.DiscSetl);
    IdVAT := Round_Up(LId.VAT, 2);

    VATRate := TrueReal(SyssVAT^.VATRates.VAT[GetVATNo(LId.VatCode,LId.VATIncFlg)].Rate,10);
    //Find the corresponding VATPayRecord for this line and use it as the basis for the matching record
    for i := 1 to FVATPayList.Count - 1 do
    begin
      if FVATPayList.Records[i].vpSORABSLineNo = LId.SOPLineNo then
      begin
        VATPayRec := FVATPayList.Records[i];

        //Set required fields
        VATPayRec.vpTransRef := PadTransRefKey(LInv.OurRef); //SIN OurRef
        VatPayRec.vpType := vptMatching; //matching record
        VATPayRec.vpLineOrderNo := FVATPayList.Count + 1 + oSInApportioner.Count; //Line Order No

        //Add record
        oSInApportioner.Add(IdTotal, IdVAT, VATRate, VATPayRec);


        Break;
      end;
    end;
  end;


end;

procedure TSORPaymentMatcher.AddVATPayMatchRecordsForSIN;
var
  Res : Integer;
  KeyS : Str255;
begin
  oSINApportioner.Clear;

  with FExLocal^ do
  begin
    oSINApportioner.VATPayList := FVATPayList;
    oSINApportioner.ThisTotal := ThisAmount;
    oSINApportioner.SINTotal := Itotal(LInv);
    oSINApportioner.PaymentTotal := FAmount;
    oSINApportioner.OrderPaymentsTransaction := iOrderPaymentsTransaction;

    KeyS := FullNomKey(LInv.FolioNum) + #1;

    Res := LFind_Rec(B_GetGEq, IDetailF, IdFolioK, KeyS);

    while (Res = 0) and (LId.FolioRef = LInv.FolioNum) do
    begin
      if LId.SOPLineNo > 0 then
        AddLine(oSINApportioner);

      Res := LFind_Rec(B_GetNext, IDetailF, IdFolioK, KeyS);
    end;
  end;
  oSINApportioner.Execute;
end;

function TSORPaymentMatcher.AddRecord: Integer;
begin
  Result := 0;
  if FMatchRef <> '' then
  begin
    //Add matching record for SIN
    Result := DoAddRecord(FMatchRef, FSRCRef, ThisAmount);

    //Add order payment matching: Match SIN to original SOR;
    if Result = 0 then
      Result := AddDefaultOrderPaymentMatching;

    //Update settled amount on SIN
    if Result = 0 then
      Result := UpdateMatchedTrans(FMatchRef, ThisAmount);

    if Result = 0 then
    begin
      //Update settled amount on SRC
      FMatchRef := '';
      Result := UpdateMatchedTrans(FSRCRef, -ThisAmount);
    end;
  end;
end;

//We need to check whether there are any SINs created from the SOR and, if so, match them. This function iterates through the
//matching table checking for SPOP matching records. When it finds the next appropriate one it stores the OurRef in FMatchRef
//and returns True.
function TSORPaymentMatcher.FindNextTrans: Boolean;
var
  Res : Integer;
  Found : Boolean;
  KeyS : Str255;
  OsAmount : Double;
begin

  Result := False;
  with FExLocal^ do
  begin
    if FBFunc = B_GetGEq then
    begin //First call - set KeyS & KeyChk
      FKeyS := MatchTCode + MatchSCode + FSORRef;
      FKeyChk := FKeyS;
    end;

    Res := LFind_Rec(FBFunc, PWrdF, HelpNdxK, FKeyS);
    FBFunc := B_GetNext; //Change after first call.

    while (Res = 0) and (Copy(FKeyS, 1, Length(FKeyChk)) = FKeyChk) and not Result do
    begin
      with LPassword.MatchPayRec do
        if (Copy(DocCode, 1, 3) = 'SIN') and (MatchType = 'O') then
        begin
          KeyS := DocCode;
          Res := LFind_Rec(B_GetEq, InvF, InvOurRefK, KeyS);

          if Res = 0 then
          begin
            OsAmount := GetOutstanding;

            Try
              if not ZeroFloat(OsAmount) then
              begin
                Result := True;

                if OsAmount < FAmount then
                  ThisAmount := OsAmount
                else
                  ThisAmount := FAmount;

                AddVATPayMatchRecordsForSIN;
              end;
            Finally
              iOrderPaymentsTransaction := nil;
            End;
          end;

        end;


      //If not correct record then try next - if found then we leave it on the correct record for update
      if not Result then
        Res := LFind_Rec(FBFunc, PWrdF, HelpNdxK, FKeyS);

    end;

    if Result then
      FMatchRef := LPassword.MatchPayRec.DocCode;
 end; //with

end;

//PR: 10/11/2014 ABSEXCH-15717 Moved to TMatcher object
//For a refund this function updates/deletes as necessary the original matching record for the payment
function TMatcher.UpdateMatchRecord: Integer;
begin
  if FMatchRef <> '' then
  begin
    with FExLocal^ do
    begin
      LPassword.MatchPayRec.OwnCVal := LPassword.MatchPayRec.OwnCVal - Abs(ThisAmount);
      LPassword.MatchPayRec.SettledVal := Conv_TCurr(Abs(LPassword.MatchPayRec.OwnCVal), XRate(LInv.CXRate, False, FCurrency), FCurrency, 0, False);

      //If we've reduced it to zero then delete rather than updating
      if ZeroFloat(LPassword.MatchPayRec.OwnCVal) then
        Result := LDelete_Rec(PWrdF, HelpNdxK)
      else
        Result := LPut_Rec(PWrdF, HelpNdxK);

    end; //with
  end
  else
   Result := 0; //No matching ref so nothing to do
end;

//PR: 10/11/2014 ABSEXCH-15717 Moved to TMatcher object
//This function sets the settled value and, if necessary, the RemitNo field, on the transaction matched to
function TMatcher.UpdateMatchedTrans(
  const TransRef: string; AnAmount : Double): Integer;
var
  KeyS : Str255;
begin
{  if (Copy(TransRef, 1, 3) = 'SRC') and (FMatchRef <> '') then
      //Refunding SRC matched against SIN - don't do anything - trans matched to has changed (to Refund SRC), but settled value is the same
    Result := 0
  else}
  with FExLocal^ do
  begin
    //Reload transaction to match so we can update it
    KeyS := LJVar(TransRef,DocKeyLen);
    Result := LFind_Rec(B_GetEq, InvF, InvOurRefK, KeyS);

    if Result = 0 then
    begin
      //Update settled value on transaction we're matching to
      if not ZeroFloat(AnAmount) then
      begin
        LInv.CurrSettled := LInv.CurrSettled + AnAmount;

        //PR: 13/02/2015 ABSEXCH-16160 Need to subtract any variance from Settled
        LInv.Settled := Conv_TCurr(LInv.CurrSettled, XRate(LInv.CXRate, False, FExLocal.LInv.Currency), FExLocal.LInv.Currency, 0, False) - LInv.Variance;

        LInv.BDiscount := LInv.CurrSettled;
      end;

      //Set allocated status
      Set_DocAlcStat(LInv, False);

      //Store
      Result := LPut_Rec(InvF, InvOurRefK);
    end;
  end; //with
end;

procedure TMatcher.RestoreRecordPosition;
var
  Res : Integer;
begin
  Res := FExLocal.LGetPos(PWrdF, FRecAddress);
end;

procedure TMatcher.SaveRecordPosition;
var
  Res : Integer;
begin
  with FExLocal^ do
  begin
    LSetDataRecOfs(PWrdF, FRecAddress);

    Res := LGetDirectRec(PWrdF, HelpNdxK);
  end;
end;


constructor TSORPaymentMatcher.Create;
begin
  inherited;
  oSINApportioner := TSINApportioner.Create;
end;

destructor TSORPaymentMatcher.Destroy;
begin
  oSINApportioner.Free;
  inherited;
end;

function TSORPaymentMatcher.GetOutstanding: Double;
begin
  with FExLocal^ do
  begin
    iOrderPaymentsTransaction := OPTransactionInfo (LInv, LCust);
    Result := iOrderPaymentsTransaction.optOutstandingTotal;
  end;
end;

{ TSORRefundMatcher }

function TSORRefundMatcher.AddRecord: Integer;
begin
  //Add matching record for SRC-SRC
  ThisAmount := FAmount;
  Result := DoAddRecord(FSRCRef, FMatchRef, FAmount);


  //PR: 27/01/2015 ABSEXCH-16072/16073 Update settled amount on SRC
  if Result = 0 then
    Result := UpdateMatchedTrans(FMatchRef, ThisAmount);
end;

function TSORRefundMatcher.FindNextTrans: Boolean;
begin
  Result := True;
end;


{ TSINPaymentMatcher }

function TSINPaymentMatcher.AddRecord: Integer;
begin
  //Paying the full amount specified
  ThisAmount := FAmount;

  //Add matching record for SIN
  Result := DoAddRecord(FMatchRef, FSRCRef, ThisAmount);

  //Add order payment matching: Match SIN to original SOR;
  if Result = 0 then
      Result := AddDefaultOrderPaymentMatching;

  //Update settled amount on SIN
  if Result = 0 then
    Result := UpdateMatchedTrans(FMatchRef, ThisAmount);
end;

function TSINPaymentMatcher.FindNextTrans: Boolean;
begin
  Result := True; //Should only be called once, as full FAmount is used.
end;

{ TSINRefundMatcher }

function TSINRefundMatcher.AddRecord : Integer;
begin
  FAmount := -FAmount;
  //Paying the full amount specified
  ThisAmount := FAmount;

  //Add matching record for SRC-SRC
  Result := DoAddRecord(FSRCRef, FMatchRef, ThisAmount);

  //Update match rec SRC-SIN and update settled amount on SIN
  if Result = 0 then
    Result := UpdateSIN;
end;

function TSINRefundMatcher.FindNextTrans: Boolean;
begin
  Result := True; //Should only be called once, as full FAmount is used.
end;

function TSINRefundMatcher.UpdateSIN: Integer;
var
  KeyS, KeyChk : Str255;
  Res : Integer;
  Found : Boolean;
begin
  Result := 0;
  with FExLocal^ do
  begin
    KeyS := MatchTCode + MatchSCode + FSINRef;
    KeyChk := KeyS;

    Found := False;
    Result := LFind_Rec(B_GetGEq, PWrdF, PWK, KeyS);

    while (Result = 0) and CheckKey(KeyS, KeyChk, Length(KeyChk), True) and not Found do
    begin

      Found := (LPassword.MatchPayRec.MatchType = 'A');

      if not Found then
        Result := LFind_Rec(B_GetNext, PWrdF, PWK, KeyS);
    end;

    if Found then
    begin
      Result := UpdateMatchRecord;

      if Result = 0 then
        Result := UpdateMatchedTrans(FSINRef, -FAmount);
    end
    else
      Result := 4;

  end;
end;


function TMatcher.Finalise: Integer;
begin
  Result := 0;
end;

//SDN Payment - no need to do anything specific but needs to be here to add order payment matching (in Execute method.)
function TSDNPaymentMatcher.FindNextTrans : Boolean;
begin
  Result := True; //Only called once
end;

function TSDNPaymentMatcher.AddRecord : Integer;
begin
  Result := 0;
  FAmount := 0; //Set FMaount to 0 to end FindNextTrans process
end;


function TMatcher.GetSINRef: String;
begin
  Result := FSINRef;
end;

procedure TMatcher.SetSINRef(const Value: String);
begin
  FSINRef := Value;
end;

function TMatcher.GetVATPayList: TOrderPaymentsVATPayDetailsList;
begin
  Result := FVATPayList;
end;

procedure TMatcher.SetVATPayList(
  const Value: TOrderPaymentsVATPayDetailsList);
begin
  FVATPayList := Value;
end;

{ TSINApportioner }

procedure TSINApportioner.Add(Goods : Double; VAT : Double; VATRate : Double;
  AVATPayRec: OrderPaymentsVATPayDetailsRecType);
var
  pLine : PSINLine;
begin
  New(pLine);
  pLine.VATPayRec := AVATPayRec;
  pLine.Goods := Goods;
  pLine.VAT := VAT;
  pLine.VATRate := VATRate;
  FList.Add(pLine);
end;

constructor TSINApportioner.Create;
begin
  inherited;
  FList := TList.Create;
  CheckList := TList.Create;
end;

destructor TSINApportioner.Destroy;
begin
  CheckList.Free;
  FList.Free;
  FOrderPaymentsTransaction := nil;
  inherited;
end;

procedure TSINApportioner.Execute;
var
  i, j : Integer;
  ALine : TSINLine;
begin
  if CheckList.Count = 0 then
    LoadCheckList;

  for i := 0 to FList.Count - 1 do
  begin
    CalculateLineValues(TSINLine(FList[i]^));

    with TSINLine(FList[i]^).VATPayRec do
      if vpGoodsValue + vpVATValue > 0 then
        VATPayList.Add(TSINLine(FList[i]^).VATPayRec);
  end;
end;

//Calculate goods and VAT values for the matching record for this line
function TSINApportioner.GetCount: Integer;
begin
  Result := FList.Count;
end;

procedure TSINApportioner.CalculateLineValues(var Line: TSINLine);
var
  LineGoods : Double;
  LineVAT : Double;
  CheckRec : PCheckRecord;
  ThisCheckRec : TCheckRecord;

begin
  //Get the CheckRec for this line - holds the running total of outstanding values from SRC
  CheckRec := GetCheckRec(Line.VATPayRec.vpSORAbsLineNo);

  //Copy to local CheckRec
  ThisCheckRec := CheckRec^;

  //Adjust local check rec according to o/s on this SIN line
  //PR: 17/11/2015 ABSEXCH-17014 Was populating the wrong CheckRec
  FillLocalCheckRec(CheckRec);

  //Set Goods & VAT
  if ThisCheckRec.Goods < Line.Goods then
    LineGoods := ThisCheckRec.Goods
  else
    LineGoods := Line.Goods;

  if ThisCheckRec.VAT < Line.VAT then
    LineVAT := ThisCheckRec.VAT
  else
    LineVAT := Line.VAT;


  //Reduce values in check list
  CheckRec.Goods := CheckRec.Goods - LineGoods;
  CheckRec.VAT := CheckRec.VAT - LineVAT;

  //Set field in VATPayRec
  Line.VATPayRec.vpGoodsValue := LineGoods;
  Line.VATPayRec.vpVATValue := LineVAT;
end;

procedure TSINApportioner.Clear;
begin
  FList.Clear;
end;

procedure TSINApportioner.LoadCheckList;
var
  i : Integer;
  CheckRec : PCheckRecord;
  CheckRec2 : TCheckRecord;
begin
  for i := 1 to FVATPayList.Count -1 do
  begin
    New(CheckRec);
    CheckRec^.SORLine := FVATPayList.Records[i].vpSORAbsLineNo;
    CheckRec^.Goods   := FVATPayList.Records[i].vpGoodsValue;
    CheckRec^.VAT := FVATPayList.Records[i].vpVATValue;

    CheckList.Add(CheckRec);
  end;
end;

function TSINApportioner.GetCheckRec(LineNo: Integer): PCheckRecord;
var
  i : integer;
begin
  Result := nil;

  for i := 0 to CheckList.Count - 1 do
    if LineNo = PCheckRecord(CheckList[i])^.SORLine then
    begin
      Result := PCheckRecord(CheckList[i]);
      Break;
    end;

  if Result = nil then
    raise Exception.Create('No check record found for SOR Line no ' + IntToStr(LineNo));
end;

//Function to set o/s values from SIN Lines Op Info
procedure TSINApportioner.FillLocalCheckRec(CheckRec: PCheckRecord);
var
  i : Integer;
begin
  with FOrderPaymentsTransaction do
  begin
    for i := 0 to optTransactionLineCount - 1 do
    if CheckRec.SORLine = optTransactionLines[i].optlLineNo then
    begin
      CheckRec.Goods := optTransactionLines[i].optlOutstandingGoods;
      CheckRec.VAT := optTransactionLines[i].optlOutstandingVAT;
    end;
  end;
end;

end.
