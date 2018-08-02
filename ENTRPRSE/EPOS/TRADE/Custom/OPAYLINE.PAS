// Implementation of the "thPaymentLine" COM Object
unit oPayLine;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils, EPOSProc, CustomP
  , oStock, DLLInc, oSerials, oLoctn, BTKeys1u;

type
  TPayLinePropertyIndex = (pIdxNeverAuthorise, pIdxtlQty, pIdxtlPayingInRef, pIdxtlLineNo
  , pIdxtlGLCode, pIdxtlCompanyRate, pIdxtlCurrency, pIdxtlDailyRate, pIdxtlCostCentre
  , pIdxtlDepartment, pIdxtlNetValue, pIdxtlLineDate, pIdxtlLineType, pIdxtlRecStatus
  , pIdxtlUserField1, pIdxtlUserField2, pIdxtlUserField3, pIdxtlUserField4);

//  TPayLineFunctionIndex = (fIdxSave, fIdxCancel);

  TTradeEventPaymentLine = class(TAutoIntfObject, ITradeEventPaymentLine)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;

    oEventData : TObject;

    lTKPayLineRec : pTKTLRec;

    Function GetDataChanged : Boolean;

  protected
    function Get_tlLineNo: Integer; safecall;
    procedure Set_tlLineNo(Value: Integer); safecall;
    function Get_tlGLCode: Integer; safecall;
    procedure Set_tlGLCode(Value: Integer); safecall;
    function Get_tlCurrency: Integer; safecall;
    procedure Set_tlCurrency(Value: Integer); safecall;
    function Get_tlCompanyRate: Double; safecall;
    procedure Set_tlCompanyRate(Value: Double); safecall;
    function Get_tlDailyRate: Double; safecall;
    procedure Set_tlDailyRate(Value: Double); safecall;
    function Get_tlCostCentre: WideString; safecall;
    procedure Set_tlCostCentre(const Value: WideString); safecall;
    function Get_tlDepartment: WideString; safecall;
    procedure Set_tlDepartment(const Value: WideString); safecall;
    function Get_tlNetValue: Double; safecall;
    procedure Set_tlNetValue(Value: Double); safecall;
    function Get_tlLineDate: WideString; safecall;
    procedure Set_tlLineDate(const Value: WideString); safecall;
    function Get_tlPayingInRef: WideString; safecall;
    procedure Set_tlPayingInRef(const Value: WideString); safecall;
    function Get_tlChequeNo: WideString; safecall;
    procedure Set_tlChequeNo(const Value: WideString); safecall;
    function Get_tlLineType: TTradeTransLineType; safecall;
    procedure Set_tlLineType(Value: TTradeTransLineType); safecall;
    function Get_tlFolioNum: Integer; safecall;
    function Get_tlLineClass: WideString; safecall;
    function Get_tlRecStatus: Smallint; safecall;
    procedure Set_tlRecStatus(Value: Smallint); safecall;
    function Get_tlABSLineNo: Integer; safecall;
    function Get_tlUserField1: WideString; safecall;
    procedure Set_tlUserField1(const Value: WideString); safecall;
    function Get_tlUserField2: WideString; safecall;
    procedure Set_tlUserField2(const Value: WideString); safecall;
    function Get_tlUserField3: WideString; safecall;
    procedure Set_tlUserField3(const Value: WideString); safecall;
    function Get_tlUserField4: WideString; safecall;
    procedure Set_tlUserField4(const Value: WideString); safecall;
    function Get_tlOurRef: WideString; safecall;

//    procedure Save; safecall;
//    procedure Cancel; safecall;

    // Local Methods
    Procedure AuthoriseProperty (Const PropertyIdx : TPayLinePropertyIndex; const PropName : ShortString);
//    Procedure AuthoriseFunction (Const FunctionIdx : TPayLineFunctionIndex; const FuncName : ShortString);
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    // properties of this object OR any sub-objects
    Property DataChanged : Boolean Read GetDataChanged;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign(EventData : TObject; ThePayLineRec : pTKTLRec);
  End; { TTradeEventTransaction }

implementation

uses
  ETMiscU, oEvent, ComServ, oVersion;

//---------------------------------------------------------------------------

Constructor TTradeEventPaymentLine.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  FDataChanged := False;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeEventPaymentLine.Destroy;
Begin { Destroy }

  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Procedure TTradeEventPaymentLine.Assign(EventData : TObject; ThePayLineRec : pTKTLRec);

begin { Assign }

  // Reset Datachanged flag for new event
  FDataChanged := False;
  oEventData := EventData;

  // make local copy of data required for this object
  lTKPayLineRec := ThePayLineRec;

end; { Assign }

//---------------------------------------------------------------------------

// Returns True if the specified property can be written to by the Plug-In during the current event
Procedure TTradeEventPaymentLine.AuthoriseProperty (Const PropertyIdx : TPayLinePropertyIndex; const PropName : ShortString);
Var
  Authorised : Boolean;
Begin { AuthoriseProperty }
  // Check for specific enablement of fields

  Authorised := FALSE; // Generally all fields are Read-Only

  with TTradeEventData(oEventData) do begin
{    case PropertyIdx of
      pIdxtlPayingInRef : Authorised := TRUE;
      pIdxtlQty : Authorised := TRUE;
      pIdxNeverAuthorise : Authorised := FALSE;
    end; { Case }

    If (Not Authorised) Then begin
      // Raise exception to notify the user that the Plug-In has been naughty
      Raise ERightsError.Create (Format('Customisation Error in ITradeEventPaymentLine for Event %d.%d - The property %s is Read-Only'
      , [FWindowId, FHandlerId, QuotedStr(PropName)]));
    end;{if}
  end;{with}
End; { AuthoriseProperty }

//---------------------------------------------------------------------------

// Returns True if the specified function/procedure can be called by the Plug-In during the current event
(*
Procedure TTradeEventPaymentLine.AuthoriseFunction (Const FunctionIdx : TPayLineFunctionIndex; const FuncName : ShortString);
var
  bAuthorised : Boolean;
begin
  // Check for specific enablement of fields
  bAuthorised := FALSE;

  with TTradeEventData(oEventData) do begin

    // Authorise if appropriate
{    case FunctionIdx of
      fIdxSave, fIdxCancel : begin
        bAuthorised := iLineNo = NEW_LINE;
      end;
    end; { Case }

    if (not bAuthorised) then begin
      // Raise exception to notify the user that the Plug-In has been naughty
      Raise ERightsError.Create (Format('Customisation Error in ITradeEventPaymentLine for Event %d.%d - The property %s is Read-Only'
      , [FWindowId, FHandlerId, QuotedStr(FuncName)]));
    end;{if}
  end;{with}
end;
*)
//---------------------------------------------------------------------------

// Returns TRUE if any properties within the eventdata have been changed
Function TTradeEventPaymentLine.GetDataChanged : Boolean;
Begin { GetDataChanged }
  Result := FDataChanged;
End; { GetDataChanged }


function TTradeEventPaymentLine.Get_tlABSLineNo: Integer;
begin
  Result := lTKPayLineRec.ABSLineNo;
end;

function TTradeEventPaymentLine.Get_tlCompanyRate: Double;
begin
  Result := lTKPayLineRec.CoRate;
end;

procedure TTradeEventPaymentLine.Set_tlCompanyRate(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlCompanyRate, 'tlCompanyRate');

  // Set Value
  lTKPayLineRec.CoRate := CustomSetReal(lTKPayLineRec.CoRate, Value, FDataChanged);
end;


function TTradeEventPaymentLine.Get_tlCostCentre: WideString;
begin
  Result := lTKPayLineRec.CC;
end;

procedure TTradeEventPaymentLine.Set_tlCostCentre(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlCostCentre, 'tlCostCentre');

  // Set Value
  lTKPayLineRec.CC := CustomSetString(lTKPayLineRec.CC
  , FullCCDepKey(UpperCase(Value)), FDataChanged);
end;


function TTradeEventPaymentLine.Get_tlCurrency: Integer;
begin
  Result := lTKPayLineRec.Currency;
end;

procedure TTradeEventPaymentLine.Set_tlCurrency(Value: Integer);
var
  FVersionO : TTradeVersion;
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlCurrency, 'tlCurrency');

  // Set Value
  FVersionO := TTradeVersion.Create;
  lTKPayLineRec.Currency := CustomSetInteger(lTKPayLineRec.Currency
  , FVersionO.ValidateCurrencyNo(Value), FDataChanged);
  FVersionO := nil;
end;


function TTradeEventPaymentLine.Get_tlDailyRate: Double;
begin
  Result := lTKPayLineRec.VATRate;
end;

procedure TTradeEventPaymentLine.Set_tlDailyRate(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlDailyRate, 'tlDailyRate');

  // Set Value
  lTKPayLineRec.VATRate := CustomSetReal(lTKPayLineRec.VATRate, Value, FDataChanged);
end;


function TTradeEventPaymentLine.Get_tlDepartment: WideString;
begin
  Result := lTKPayLineRec.Dep;
end;

procedure TTradeEventPaymentLine.Set_tlDepartment(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlDepartment, 'tlDepartment');

  // Set Value
  lTKPayLineRec.Dep := CustomSetString(lTKPayLineRec.Dep
  , FullCCDepKey(UpperCase(Value)), FDataChanged);
end;


function TTradeEventPaymentLine.Get_tlFolioNum: Integer;
begin
  Result := lTKPayLineRec.FolioNum;
end;


function TTradeEventPaymentLine.Get_tlGLCode: Integer;
begin
  Result := lTKPayLineRec.NomCode;
end;

procedure TTradeEventPaymentLine.Set_tlGLCode(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlGLCode, 'tlGLCode');

  // Set Value
  lTKPayLineRec.NomCode := CustomSetInteger(lTKPayLineRec.NomCode, Value, FDataChanged);
end;


function TTradeEventPaymentLine.Get_tlLineClass: WideString;
begin
  Result := lTKPayLineRec.LineType;
end;


function TTradeEventPaymentLine.Get_tlLineDate: WideString;
begin
  Result := lTKPayLineRec.LineDate;
end;

procedure TTradeEventPaymentLine.Set_tlLineDate(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlLineDate, 'tlLineDate');

  // Set Value
  lTKPayLineRec.LineDate := CustomSetString(lTKPayLineRec.LineDate, Value, FDataChanged);
//  lTKPayLineRec.bDateChangedByCustomisation := TRUE;
end;


function TTradeEventPaymentLine.Get_tlLineNo: Integer;
begin
  Result := lTKPayLineRec.LineNo;
end;

procedure TTradeEventPaymentLine.Set_tlLineNo(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlLineNo, 'tlLineNo');

  // Set Value
  lTKPayLineRec.LineNo := CustomSetInteger(lTKPayLineRec.LineNo, Value, FDataChanged);
end;


function TTradeEventPaymentLine.Get_tlLineType: TTradeTransLineType;
begin
  Result := lTKPayLineRec.DocLTLink;
end;

procedure TTradeEventPaymentLine.Set_tlLineType(Value: TTradeTransLineType);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlLineType, 'tlLineType');

  // Set Value
  lTKPayLineRec.DocLTLink := CustomSetInteger(lTKPayLineRec.DocLTLink, Value, FDataChanged);
end;


function TTradeEventPaymentLine.Get_tlNetValue: Double;
begin
  Result := Round_Up(lTKPayLineRec.NetValue, TKSysRec.PriceDP);
end;

procedure TTradeEventPaymentLine.Set_tlNetValue(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlNetValue, 'tlNetValue');

  // Set Value
  lTKPayLineRec.NetValue := CustomSetReal(lTKPayLineRec.NetValue, Value, FDataChanged);
end;


function TTradeEventPaymentLine.Get_tlOurRef: WideString;
begin
  Result := lTKPayLineRec.TransRefNo;
end;


function TTradeEventPaymentLine.Get_tlRecStatus: Smallint;
begin
  Result := lTKPayLineRec.Reconcile;
end;

procedure TTradeEventPaymentLine.Set_tlRecStatus(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlRecStatus, 'tlRecStatus');

  // Set Value
  lTKPayLineRec.Reconcile := CustomSetInteger(lTKPayLineRec.Reconcile, Value, FDataChanged);
end;


function TTradeEventPaymentLine.Get_tlUserField1: WideString;
begin
  Result := lTKPayLineRec.LineUser1;
end;

procedure TTradeEventPaymentLine.Set_tlUserField1(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlUserField1, 'tlUserField1');

  // Set Value
  lTKPayLineRec.LineUser1 := CustomSetString(lTKPayLineRec.LineUser1, Value, FDataChanged);
end;


function TTradeEventPaymentLine.Get_tlUserField2: WideString;
begin
  Result := lTKPayLineRec.LineUser2;
end;

procedure TTradeEventPaymentLine.Set_tlUserField2(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlUserField2, 'tlUserField2');

  // Set Value
  lTKPayLineRec.LineUser2 := CustomSetString(lTKPayLineRec.LineUser2, Value, FDataChanged);
end;


function TTradeEventPaymentLine.Get_tlUserField3: WideString;
begin
  Result := lTKPayLineRec.LineUser3;
end;

procedure TTradeEventPaymentLine.Set_tlUserField3(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlUserField3, 'tlUserField3');

  // Set Value
  lTKPayLineRec.LineUser3 := CustomSetString(lTKPayLineRec.LineUser3, Value, FDataChanged);
end;


function TTradeEventPaymentLine.Get_tlUserField4: WideString;
begin
  Result := lTKPayLineRec.LineUser4;
end;

procedure TTradeEventPaymentLine.Set_tlUserField4(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlUserField4, 'tlUserField4');

  // Set Value
  lTKPayLineRec.LineUser4 := CustomSetString(lTKPayLineRec.LineUser4, Value, FDataChanged);
end;


function TTradeEventPaymentLine.Get_tlChequeNo: WideString;
begin
//***Special
//***Special
  Result := lTKPayLineRec.Desc;
//***Special
//***Special
end;

procedure TTradeEventPaymentLine.Set_tlChequeNo(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxNeverAuthorise, 'tlChequeNo');

//***Special
//***Special
  lTKPayLineRec.Desc := CustomSetString(lTKPayLineRec.Desc, Value, FDataChanged);
//***Special
//***Special
end;


function TTradeEventPaymentLine.Get_tlPayingInRef: WideString;
begin
//***Special
//***Special
  Result := lTKPayLineRec.StockCode;
//***Special
//***Special
end;

procedure TTradeEventPaymentLine.Set_tlPayingInRef(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxtlPayingInRef, 'tlPayingInRef');

//***Special
//***Special
  lTKPayLineRec.StockCode := CustomSetString(lTKPayLineRec.StockCode, Value, FDataChanged);
//***Special
//***Special

end;


(*
procedure TTradeEventPaymentLine.Cancel;
begin
  // Check that it is valid to call this function at this time
  AuthoriseFunction(fIdxCancel, 'Cancel');

  // Reset Current Line
{  InitialiseTXLine(lTKPayLineRec^);
  TTradeEventTransLines(oLines).bGetCurrentLine := TRUE;}
end;

procedure TTradeEventPaymentLine.Save;
//var
//  oLine : pTransLineType;
//  NewItem : TListItem;
begin
  // Check that it is valid to call this function at this time
  AuthoriseFunction(fIdxSave, 'Save');

  // Add New Line To List
  New (oLine);
  With oLine^ Do Begin
    // Allocate unique Id number
    IdNo := TTradeEventTransLines(oLines).IdControl.OpenBit;
    TTradeEventTransLines(oLines).IdControl.Bits[IdNo] := True;
    // Create lines object
    TLO  := TTradeEventTransLine.Create;
    TLI  := oLine.TLO;
    TLO.Assign(oEventData, oLines, lTKPayLineRec, TTradeEventData(oEventData).LListView.Items.Count);
  End; { With oLine }

  // Add into Lines List
  TTradeEventTransLines(oLines).Lines.Add(oLine);

  // Add into Local Copy of the listview
  with TTradeEventData(oEventData).LListView do begin
    NewItem := Items.Add;
    NewItem.Data := TTXLineInfo.create(lTKPayLineRec^);
  end;{with}

  // Reset Current Line
  InitialiseTXLine(lTKPayLineRec^);
  TTradeEventTransLines(oLines).bGetCurrentLine := TRUE;
end;
*)
end.
