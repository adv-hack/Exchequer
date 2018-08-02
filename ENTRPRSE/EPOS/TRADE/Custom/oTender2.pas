// Implementation of the "thTender2" COM Object
unit OTender2;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComCtrls, ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils, EPOSProc
  , VarConst, CustomP, oAddr, DLLInc, EPOSCnst, oCardDet;


type

  TTender2PropertyIndex = (pIdxNeverAuthorise, pIdxteChange);

  TTender2FunctionIndex = (fIdxUnknownfunction);

  TTradeEventTender2 = class(TAutoIntfObject, ITradeEventTender2)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;

    oEventData : TObject;

    Function GetDataChanged : Boolean;

  protected
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
    function Get_teSetllementAmount: Double; safecall;
    procedure Set_teSetllementAmount(Value: Double); safecall;
    function Get_teLeftOnAccount: Double; safecall;
    procedure Set_teLeftOnAccount(Value: Double); safecall;
    function Get_tePrintTo: Integer; safecall;
    procedure Set_tePrintTo(Value: Integer); safecall;

    // Local Methods
    Procedure AuthoriseProperty (Const PropertyIdx : TTender2PropertyIndex; const PropName : ShortString);
    Procedure AuthoriseFunction (Const FunctionIdx : TTender2FunctionIndex; const FuncName : ShortString);
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    // properties of this object OR any sub-objects
    Property DataChanged : Boolean Read GetDataChanged;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign(EventData : TObject);

  End; { TTradeEventTender2 }

implementation

uses
  oEvent, ComServ;

//---------------------------------------------------------------------------

Constructor TTradeEventTender2.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  FDataChanged := False;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeEventTender2.Destroy;
Begin { Destroy }
  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Procedure TTradeEventTender2.Assign(EventData : TObject);

begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;
  oEventData := EventData;
end; { Assign }

//---------------------------------------------------------------------------

Procedure TTradeEventTender2.AuthoriseProperty (Const PropertyIdx : TTender2PropertyIndex; const PropName : ShortString);
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
      raise ERightsError.Create (Format('Customisation Error in ITradeEventTender2 for Event %d.%d - The property %s is Read-Only'
      , [FWindowId, FHandlerId, QuotedStr(PropName)]));
    end;{if}
  end;{with}

End;{AuthoriseProperty}

//---------------------------------------------------------------------------

// Returns True if the specified function/procedure can be called by the Plug-In during the current event
Procedure TTradeEventTender2.AuthoriseFunction (Const FunctionIdx : TTender2FunctionIndex; const FuncName : ShortString);
begin

  //
  // This section needs to be coded once some functions are added in
  //
  Raise Exception.Create ('TTradeEventTender2.AuthoriseFunction Not Implemented - Please notify your technical support');

  { TODO -cDO : TTradeEventTender2.AuthoriseFunction Not Implemented }

end;

// Returns TRUE if any properties have been changed
Function TTradeEventTender2.GetDataChanged : Boolean;
Begin { GetDataChanged }
  Result := FDataChanged or FCardDetO.DataChanged;
End; { GetDataChanged }

