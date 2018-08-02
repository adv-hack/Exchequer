// Implementation of the Event Data COM Object
unit oTrans;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils, VarCustm;

type
  TTransactionPropertyIndex = (pIdxThOurRef, pIdxThAcCode, pIdxEdit1, pIdxEdit2, pIdxEdit3);

  TTransactionFunctionIndex = (fIdxUnknownfunction);

  TTradeEventTransaction = class(TAutoIntfObject, ITradeEventTransaction)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;

    // Event WindowId/HandlerId
    FWindowId  : TTradeWindowIds;
    FHandlerId : Integer;

    FEdit1, FEdit2, FEdit3 : ShortString;
  protected
    // ITradeEventTransaction
    function Get_Edit1: WideString; safecall;
    procedure Set_Edit1(const Value: WideString); safecall;
    function Get_Edit2: WideString; safecall;
    procedure Set_Edit2(const Value: WideString); safecall;
    function Get_Edit3: WideString; safecall;
    procedure Set_Edit3(const Value: WideString); safecall;

    // Local Methods
    Procedure AuthoriseProperty (Const PropertyIdx : TTransactionPropertyIndex; const PropName : ShortString);
    Procedure AuthoriseFunction (Const FunctionIdx : TTransactionFunctionIndex; const FuncName : ShortString);
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    // properties of this object OR any sub-objects
    Property DataChanged : Boolean Read FDataChanged;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign (Const WindowId  : TTradeWindowIds;
                      Const HandlerId : Integer;
                      Const Edit1, Edit2, Edit3 : ShortString);
  End; { TTradeEventTransaction }

implementation

uses ComServ;

//---------------------------------------------------------------------------

Constructor TTradeEventTransaction.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  FDataChanged := False;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeEventTransaction.Destroy;
Begin { Destroy }

  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Procedure TTradeEventTransaction.Assign (Const WindowId  : TTradeWindowIds;
                                         Const HandlerId : Integer;
                                         Const Edit1, Edit2, Edit3 : ShortString);
begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;

  // make local copy of event WindowId/HandlerId for controlling access to properties
  FWindowId := WindowId;
  FHandlerId := HandlerId;

  // make local copy of data required for this object
  FEdit1 := Edit1;
  FEdit2 := Edit2;
  FEdit3 := Edit3;
end; { Assign }

//---------------------------------------------------------------------------

// Returns True if the specified property can be written to by the Plug-In during the current event
Procedure TTradeEventTransaction.AuthoriseProperty (Const PropertyIdx : TTransactionPropertyIndex; const PropName : ShortString);
Var
  Authorised : Boolean;
Begin { AuthoriseProperty }
  // Check for specific enablement of fields
  Case PropertyIdx Of
    pIdxEdit1      : Authorised := ((FWindowId = twiTransaction) And (FHandlerId = 1)) Or    // Exit Edit1
                                   ((FWindowId = twiTransaction) And (FHandlerId = 101)) Or  // Custom Button 1
                                   ((FWindowId = twiTransaction) And (FHandlerId = 102));    // Custom Button 2

    pIdxEdit2      : Authorised := ((FWindowId = twiTransaction) And (FHandlerId = 2)) Or    // Exit Edit2
                                   ((FWindowId = twiTransaction) And (FHandlerId = 101)) Or  // Custom Button 1
                                   ((FWindowId = twiTransaction) And (FHandlerId = 102));    // Custom Button 2

    pIdxEdit3      : Authorised := ((FWindowId = twiTransaction) And (FHandlerId = 3)) Or    // Exit Edit3
//                                   ((FWindowId = twiTransaction) And (FHandlerId = 101)) Or  // Custom Button 1
                                   ((FWindowId = twiTransaction) And (FHandlerId = 102));    // Custom Button 2

    // etc...
  Else
    // Generally all fields are Read-Only
    Authorised := False;
  End; { Case }

  If (Not Authorised) Then
    // Raise exception to notify the user that the Plug-In has been naughty
    Raise ERightsError.Create (Format('Customisation Error in ITradeEventTransaction for Event %d/%d - The property %s is Read-Only',
                                      [FWindowId, FHandlerId, QuotedStr(PropName)]));
End; { AuthoriseProperty }

//---------------------------------------------------------------------------

// Returns True if the specified function/procedure can be called by the Plug-In during the current event
Procedure TTradeEventTransaction.AuthoriseFunction (Const FunctionIdx : TTransactionFunctionIndex; const FuncName : ShortString);
begin

  //
  // This section needs to be coded once some functions are added in
  //
  Raise Exception.Create ('TTradeEventTransaction.AuthoriseFunction Not Implemented - Please notify your technical support');

  { TODO -cDO : TTradeEventTransaction.AuthoriseFunction Not Implemented }

end;

//---------------------------------------------------------------------------

function TTradeEventTransaction.Get_Edit1: WideString;
begin
  Result := FEdit1;
end;

procedure TTradeEventTransaction.Set_Edit1(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxEdit1, 'Edit1');

  If (Value <> FEdit1) Then Begin
    FEdit1 := Value;
    FDatachanged := True;
  End; { If (Value <> FEdit1) }
end;

//----------------------------------------

function TTradeEventTransaction.Get_Edit2: WideString;
begin
  Result := FEdit2;
end;

procedure TTradeEventTransaction.Set_Edit2(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxEdit2, 'Edit2');

  FEdit2 := Value;
  FDatachanged := True;
end;

//----------------------------------------

function TTradeEventTransaction.Get_Edit3: WideString;
begin
  Result := FEdit3;
end;

procedure TTradeEventTransaction.Set_Edit3(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxEdit3, 'Edit3');

  FEdit3 := Value;
  FDatachanged := True;
end;

//---------------------------------------------------------------------------

end.
