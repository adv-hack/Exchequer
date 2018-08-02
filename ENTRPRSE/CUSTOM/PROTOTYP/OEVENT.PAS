// Implementation of the Event Data COM Object
unit oEvent;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, oTrans;

type
  TTradeEventData = class(TAutoIntfObject, ITradeEventData)
  private
    FDataChanged : Boolean;

    // Event WindowId/HandlerId
    FWindowId  : TTradeWindowIds;
    FHandlerId : Integer;

    // Transaction sub-object
    FTransactionO : TTradeEventTransaction;
    FTransactionI : ITradeEventTransaction;
  protected
    // ITradeEventData
    function Get_edWindowId: TTradeWindowIds; safecall;
    function Get_edHandlerId: Integer; safecall;
    function Get_Customer: Integer; safecall;
    function Get_Stock: Integer; safecall;
    function Get_Transaction: ITradeEventTransaction; safecall;

    // Local methods
    Function GetDataChanged : Boolean;
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    // properties of this object OR any sub-objects
    Property DataChanged : Boolean Read GetDataChanged;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign (Const WinHandle : THandle;
                      Const WindowId  : TTradeWindowIds;
                      Const HandlerId : Integer;
                      Const sEdit1, sEdit2, sEdit3 : ShortString);
  End; { TTradeEventData }

implementation

uses ComServ, CustIntU;

//---------------------------------------------------------------------------

Constructor TTradeEventData.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventData);

  // Ensure all sub-objects/variables are correctly initialised
  FDataChanged := False;

  // Create Transaction sub-object
  FTransactionO := TTradeEventTransaction.Create;
  FTransactionI := FTransactionO;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeEventData.Destroy;
Begin { Destroy }
  // Destroy any sub-objects that were created during the run

  // Transaction sub-object
  FTransactionO := NIL;
  FTransactionI := NIL;

  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

// Returns TRUE if any properties within the eventdata have been changed
Function TTradeEventData.GetDataChanged : Boolean;
Begin { GetDataChanged }
  Result := FDataChanged Or
            //FCustomerO.DataChanged Or
            // etc...
            FTransactionO.DataChanged;
End; { GetDataChanged }

//---------------------------------------------------------------------------

function TTradeEventData.Get_edWindowId: TTradeWindowIds;
begin
  Result := FWindowId;
end;

//----------------------------------------

function TTradeEventData.Get_edHandlerId: Integer;
begin
  Result := FHandlerId;
end;

//----------------------------------------

function TTradeEventData.Get_Transaction: ITradeEventTransaction;
begin
  // Return interface for object
  Result := FTransactionI;
end;

//---------------------------------------------------------------------------

Procedure TTradeEventData.Assign (Const WinHandle : THandle;
                                  const WindowId: TTradeWindowIds;
                                  const HandlerId: Integer;
                                  const sEdit1, sEdit2, sEdit3: ShortString);
Begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;

  // make local copy of data required for this object
  FWindowId := WindowId;
  FHandlerId := HandlerId;

  // Setup global window Handle for focus swapping
  TradeCustomisation.FunctionsO.TradehWnd := WinHandle;

  // Update sub-objeccts
  FTransactionO.Assign (WindowId, HandlerId, sEdit1, sEdit2, sEdit3);
End; { Assign }

//---------------------------------------------------------------------------

function TTradeEventData.Get_Customer: Integer;
begin
  // Temporary thing added to illustrate the structure
  Result := 0;
end;

//---------------------------------------------------------------------------

function TTradeEventData.Get_Stock: Integer;
begin
  // Temporary thing added to illustrate the structure
  Result := 0;
end;

//---------------------------------------------------------------------------

end.
