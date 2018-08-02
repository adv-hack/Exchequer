// Implementation of the "thTender" COM Object
unit OTender;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComCtrls, ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils, EPOSProc
  , VarConst, CustomP, oAddr, DLLInc, EPOSCnst, oCardDet;


type

  TTenderPropertyIndex = (pIdxNeverAuthorise, pIdxteCash, pIdxteCard, pIdxteCheque
  , pIdxteChange, pIdxteDepositToBeTaken, pIdxteMoneyTaken, pIdxteNetAmount
  , pIdxtePrintTo, pIdxteSettlementAmount, pIdxteSettlementToBeTaken, pIdxteTotalAmount
  , pIdxteTotalOutstanding, pIdxteVatAmount);

  TTenderFunctionIndex = (fIdxUnknownfunction);

  TTradeEventTender = class(TAutoIntfObject, ITradeEventTender, ITradeEventTender2)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;

    FCardDetO : TTradeCardDetails;
    FCardDetI : ITradeCardDetails;

    oEventData : TObject;

    Function GetDataChanged : Boolean;

  protected
    function Get_teCash: Double; safecall;
    procedure Set_teCash(Value: Double); safecall;
    function Get_teCheque: Double; safecall;
    procedure Set_teCheque(Value: Double); safecall;
    function Get_teCard: Double; safecall;
    procedure Set_teCard(Value: Double); safecall;
    function Get_teAccount: Double; safecall;
    function Get_teCardDetails: ITradeCardDetails; safecall;

    // ITradeEventTender2
    function Get_teChange: Double; safecall;
    procedure Set_teChange(Value: Double); safecall;
    function Get_teTotalOutstanding: Double; safecall;
    procedure Set_teTotalOutstanding(Value: Double); safecall;
    function Get_teNetAmount: Double; safecall;
    procedure Set_teNetAmount(Value: Double); safecall;
    function Get_teVatAmount: Double; safecall;
    procedure Set_teVatAmount(Value: Double); safecall;
    function Get_teTotalAmount: Double; safecall;
    procedure Set_teTotalAmount(Value: Double); safecall;
    function Get_teMoneyTaken: Double; safecall;
    procedure Set_teMoneyTaken(Value: Double); safecall;
    function Get_teDepositToBeTaken: Double; safecall;
    procedure Set_teDepositToBeTaken(Value: Double); safecall;
    function Get_teSettlementToBeTaken: WordBool; safecall;
    procedure Set_teSettlementToBeTaken(Value: WordBool); safecall;
    function Get_teSettlementAmount: Double; safecall;
    procedure Set_teSettlementAmount(Value: Double); safecall;
    function Get_tePrintTo: TTradePrintTo; safecall;
    procedure Set_tePrintTo(Value: TTradePrintTo); safecall;

    // Local Methods
    Procedure AuthoriseProperty (Const PropertyIdx : TTenderPropertyIndex; const PropName : ShortString);
    Procedure AuthoriseFunction (Const FunctionIdx : TTenderFunctionIndex; const FuncName : ShortString);
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    // properties of this object OR any sub-objects
    Property DataChanged : Boolean Read GetDataChanged;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign(EventData : TObject);

  End; { TTradeEventTender }

implementation

uses
  TXHead, oEvent, ComServ;

//---------------------------------------------------------------------------

Constructor TTradeEventTender.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  FCardDetO := TTradeCardDetails.Create;
  FCardDetI := FCardDetO;

  FDataChanged := False;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeEventTender.Destroy;
Begin { Destroy }

  FCardDetO := nil;
  FCardDetI := nil;

  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Procedure TTradeEventTender.Assign(EventData : TObject);

begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;
  oEventData := EventData;

  // Assign sub-objects
  FCardDetO.Assign(oEventData);

end; { Assign }

//---------------------------------------------------------------------------

Procedure TTradeEventTender.AuthoriseProperty (Const PropertyIdx : TTenderPropertyIndex; const PropName : ShortString);
Var
  Authorised : Boolean;
Begin

  // Check for specific enablement of fields
  Authorised := FALSE;
  with TTradeEventData(oEventData) do begin

{    Case PropertyIdx Of
      pIdxteCash, pIdxteCard, pIdxteCheque : begin
        Authorised := ((FWindowId = twiTransaction) and (FHandlerId = 101)); // Custom Button 1
      end;
    End; { Case }

    if (not Authorised) then begin
      // Raise exception to notify the user that the Plug-In has been naughty
      raise ERightsError.Create (Format('Customisation Error in ITradeEventTender for Event %d.%d - The property %s is Read-Only'
      , [FWindowId, FHandlerId, QuotedStr(PropName)]));
    end;{if}
  end;{with}

End;{AuthoriseProperty}

//---------------------------------------------------------------------------

// Returns True if the specified function/procedure can be called by the Plug-In during the current event
Procedure TTradeEventTender.AuthoriseFunction (Const FunctionIdx : TTenderFunctionIndex; const FuncName : ShortString);
begin

  //
  // This section needs to be coded once some functions are added in
  //
  Raise Exception.Create ('TTradeEventTender.AuthoriseFunction Not Implemented - Please notify your technical support');

  { TODO -cDO : TTradeEventTender.AuthoriseFunction Not Implemented }

end;


function TTradeEventTender.Get_teCash: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.arPayments[pbCash];
end;

procedure TTradeEventTender.Set_teCash(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxteCash, 'teCash');
  TTradeEventData(oEventData).LTXRec.arPayments[pbCash]
  := CustomSetReal(TTradeEventData(oEventData).LTXRec.arPayments[pbCash], Value, FDataChanged);
end;


function TTradeEventTender.Get_teCard: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.arPayments[pbCard];

  // Card refunds are shown as positive, but are in fact negative
  if TTradeEventData(oEventData).LTXRec.bCardRefund then Result := Result * -1;
end;

procedure TTradeEventTender.Set_teCard(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxteCard, 'teCard');
  TTradeEventData(oEventData).LTXRec.arPayments[pbCard]
  := CustomSetReal(TTradeEventData(oEventData).LTXRec.arPayments[pbCard], Value, FDataChanged);
end;


function TTradeEventTender.Get_teCheque: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.arPayments[pbCheque];
end;

procedure TTradeEventTender.Set_teCheque(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxteCheque, 'teCheque');
  TTradeEventData(oEventData).LTXRec.arPayments[pbCheque]
  := CustomSetReal(TTradeEventData(oEventData).LTXRec.arPayments[pbCheque], Value, FDataChanged);
end;


function TTradeEventTender.Get_teAccount: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.arPayments[pbAccount];
end;


function TTradeEventTender.Get_teCardDetails: ITradeCardDetails;
begin
  Result := FCardDetI;
end;

// Returns TRUE if any properties have been changed
Function TTradeEventTender.GetDataChanged : Boolean;
Begin { GetDataChanged }
  Result := FDataChanged or FCardDetO.DataChanged;
End; { GetDataChanged }


function TTradeEventTender.Get_teChange: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.rChange;
end;

function TTradeEventTender.Get_teDepositToBeTaken: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.rDepositToTake;
end;

function TTradeEventTender.Get_teMoneyTaken: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.rDepositsTaken;
end;

function TTradeEventTender.Get_teNetAmount: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.rNetTotal;
end;

function TTradeEventTender.Get_tePrintTo: TTradePrintTo;
begin
  if FrmTender.btnPrinter.Caption = 'Receipt Printer' then Result := ptReceiptPrinter;
  if FrmTender.btnPrinter.Caption = 'Invoice Printer' then Result := ptInvoicePrinter;
  if FrmTender.btnPrinter.Caption = 'Order Printer' then Result := ptOrderPrinter;
end;

function TTradeEventTender.Get_teSettlementAmount: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscSetAm;
end;

function TTradeEventTender.Get_teSettlementToBeTaken: WordBool;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscTaken;
end;

function TTradeEventTender.Get_teTotalAmount: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.rVATIncTotal;
end;

function TTradeEventTender.Get_teTotalOutstanding: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.rOutstanding;
end;

function TTradeEventTender.Get_teVatAmount: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.InvVat;
end;

procedure TTradeEventTender.Set_teChange(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxteChange, 'teChange');
end;

procedure TTradeEventTender.Set_teDepositToBeTaken(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxteDepositToBeTaken, 'teDepositToBeTaken');
end;

procedure TTradeEventTender.Set_teMoneyTaken(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxteMoneyTaken, 'teMoneyTaken');
end;

procedure TTradeEventTender.Set_teNetAmount(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxteNetAmount, 'teNetAmount');
end;

procedure TTradeEventTender.Set_tePrintTo(Value: TTradePrintTo);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxtePrintTo, 'tePrintTo');
end;

procedure TTradeEventTender.Set_teSettlementAmount(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxteSettlementAmount, 'teSettlementAmount');
end;

procedure TTradeEventTender.Set_teSettlementToBeTaken(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxteSettlementToBeTaken, 'teSettlementToBeTaken');
end;

procedure TTradeEventTender.Set_teTotalAmount(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxteTotalAmount, 'teTotalAmount');
end;

procedure TTradeEventTender.Set_teTotalOutstanding(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxteTotalOutstanding, 'teTotalOutstanding');
end;

procedure TTradeEventTender.Set_teVatAmount(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxteVatAmount, 'teVatAmount');
end;

end.
