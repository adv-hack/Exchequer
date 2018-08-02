// Implementation of the Event Data COM Object
unit oEvent;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComCtrls, ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, oTrans, EPOSProc
  , DLLInc, SysUtils, Classes, Forms, TXRecs;

const
  NO_OF_BOOL_RESULTS = 2;
  NO_OF_STRING_RESULTS = 1;
//  NO_OF_LONG_RESULTS = 1;
  NO_OF_LONG_RESULTS = 2; // NF: 22/05/2008 {.290} New for Tomlinson Parbands
  NO_OF_DOUBLE_RESULTS = 1;
  NO_OF_VARIANT_RESULTS = 1;


type
  TEventDataPropertyIndex = (pIdxNeverAuthorise, pIdxedBoolResult
  , pIdxedStringResult, pIdxedLongResult, pIdxedDoubleResult, pIdxedVariantResult);

  TTradeEventData = class(TAutoIntfObject, ITradeEventData)

  private
    FDataChanged : Boolean;

    // Transaction sub-object
    FTransactionO : TTradeEventTransaction;
    FTransactionI : ITradeEventTransaction;

    Procedure CheckIndexBounds(iIndex, iMaxIndex : integer);
    procedure AuthoriseProperty(Const PropertyIdx : TEventDataPropertyIndex
    ; iIndex : integer; const PropName : ShortString);
  protected
    // ITradeEventData
    function Get_edWindowId: TTradeWindowIds; safecall;
    function Get_edHandlerId: Integer; safecall;
    function Get_Transaction: ITradeEventTransaction; safecall;
    function Get_edBoolResult(Index: Integer): WordBool; safecall;
    procedure Set_edBoolResult(Index: Integer; Value: WordBool); safecall;
    function Get_edStringResult(Index: Integer): WideString; safecall;
    procedure Set_edStringResult(Index: Integer; const Value: WideString); safecall;
    function Get_edLongResult(Index: Integer): Integer; safecall;
    procedure Set_edLongResult(Index: Integer; Value: Integer); safecall;
    function Get_edDoubleResult(Index: Integer): Double; safecall;
    procedure Set_edDoubleResult(Index: Integer; Value: Double); safecall;
    function Get_edVariantResult(Index: Integer): OleVariant; safecall;
    procedure Set_edVariantResult(Index: Integer; Value: OleVariant); safecall;

    // Local methods
    Function GetDataChanged : Boolean;
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    // properties of this object OR any sub-objects

    // Event WindowId/HandlerId
    FWindowId  : TTradeWindowIds;
    FHandlerId : Integer;

    LTXRec : TTXRec;
    LCurrentTXLineRec : TTXLineRec;
    LListView : TListView;
    LItems : TStringlist;
    LTKLocationRec : TBatchMLocRec;
    LTKPayLines : TTKPayLines;

    aBoolResult : Array [1..NO_OF_BOOL_RESULTS] of Boolean;
    aStringResult : Array [1..NO_OF_STRING_RESULTS] of String;
    aLongResult : Array [1..NO_OF_LONG_RESULTS] of Integer;
    aDoubleResult : Array [1..NO_OF_DOUBLE_RESULTS] of Double;
    aVariantResult : Array [1..NO_OF_VARIANT_RESULTS] of OleVariant;

    Property DataChanged : Boolean Read GetDataChanged;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign(Const WinHandle : THandle;
                                  const WindowId: TTradeWindowIds;
                                  const HandlerId: Integer;
                                  const TheTXRec : TTXRec;
                                  const TheListView : TListView;
                                  const TheTKLocationRecord : TBatchMLocRec;
                                  const TheTXLineRec : TTXLineRec;
                                  const TheTKPayLines : TTKPayLines;
                                  const TheMainForm : TForm);
    function GetTransactionObject: TTradeEventTransaction;

    function HookIsTXHeadCustom1 : boolean;
    function HookIsTXHeadCustom2 : boolean;
    function HookIsExitCustCodeAfterVal: boolean;
    function HookIsExitCustCodeBeforeVal: boolean;
    function HookIsBeforeTenderScreen: boolean;

    function HookIsTXLineCustom1: boolean;
    function HookIsTXLineCustom2: boolean;
    function HookIsTXLineInitialise: boolean;
    function HookIsTXLineEnterQuantity: boolean;
    function HookIsTXLineBeforeStore: boolean;
    function HookIsTXLineBeforeCalcStockPrice: boolean;

    function HookIsNonStockCustom1: boolean;
    function HookIsNonStockCustom2: boolean;
    function HookIsNonStockEnterQuantity: boolean;
    function HookIsNonStockBeforeStore: boolean;

    function HookIsSerialCustom1: boolean;
    function HookIsSerialCustom2: boolean;

    function HookIsTenderCustom1: boolean;
    function HookIsTenderCustom2: boolean;
    function HookIsOnFireCashDrawer: boolean;
    function HookIsTenderOnTender: boolean;

    function HookIsCreditCardCustom1: boolean;
    function HookIsCreditCardCustom2: boolean;
    function HookIsCreditCardBeforeShow: boolean;
    function HookIsTenderBeforePrint: boolean; // NF: 22/05/2008 {.290} New for Tomlinson Parbands
  End; { TTradeEventData }

implementation

uses
  CustomP, ComServ, CustIntU;

//---------------------------------------------------------------------------

Constructor TTradeEventData.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventData);

  // Ensure all sub-objects/variables are correctly initialised
  FDataChanged := False;

  // Create Transaction sub-object
  FTransactionO := TTradeEventTransaction.Create;
  FTransactionI := FTransactionO;

  LListView := TListView.Create(nil);
  LListView.Visible := FALSE;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeEventData.Destroy;
Begin { Destroy }
  // Destroy any sub-objects that were created during the run

  // Transaction sub-object
  FTransactionO := NIL;
  FTransactionI := NIL;

  LListView.Items.Clear;
  LListView.Free;

  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

// Returns TRUE if any properties within the eventdata have been changed
Function TTradeEventData.GetDataChanged : Boolean;
Begin { GetDataChanged }
  Result := FDataChanged or FTransactionO.DataChanged;
            //or FCustomerO.DataChanged
            // etc...
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

function TTradeEventData.GetTransactionObject : TTradeEventTransaction;
begin
  // Return interface for object
  Result := FTransactionO;
end;

function TTradeEventData.Get_Transaction: ITradeEventTransaction;
begin
  // Return interface for object
  Result := FTransactionI;
end;

//---------------------------------------------------------------------------

Procedure TTradeEventData.Assign (Const WinHandle : THandle;
                                  const WindowId: TTradeWindowIds;
                                  const HandlerId: Integer;
                                  const TheTXRec : TTXRec;
                                  const TheListView : TListView;
                                  const TheTKLocationRecord : TBatchMLocRec;
                                  const TheTXLineRec : TTXLineRec;
                                  const TheTKPayLines : TTKPayLines;
                                  const TheMainForm : TForm);

  procedure InitArrays;
  var
    iPos : integer;
  begin{InitArrays}
    for iPos := 1 to NO_OF_BOOL_RESULTS do aBoolResult[iPos] := FALSE;
    for iPos := 1 to NO_OF_STRING_RESULTS do aStringResult[iPos] := '';
    for iPos := 1 to NO_OF_LONG_RESULTS do aLongResult[iPos] := 0;
    for iPos := 1 to NO_OF_DOUBLE_RESULTS do aDoubleResult[iPos] := 0;
    for iPos := 1 to NO_OF_VARIANT_RESULTS do aVariantResult[iPos] := '';
  end;{InitArrays}

Begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;
  InitArrays;

  // make local copy of data required for this object
  FWindowId := WindowId;
  FHandlerId := HandlerId;
  LTXRec := TheTXRec;
  LCurrentTXLineRec := TheTXLineRec;
  LTKPayLines := TheTKPayLines;

  LListView.Parent := TheMainForm;

  CopyListViewItems(TheListView.Items, LListView.Items);

  LTKLocationRec := TheTKLocationRecord;

  // Setup global window Handle for focus swapping
  TradeCustomisation.FunctionsO.TradehWnd := WinHandle;

  // Update sub-objects
  FTransactionO.Assign(Self);
End; { Assign }

//---------------------------------------------------------------------------

// Returns True if the specified property can be written to by the Plug-In during the current event
procedure TTradeEventData.AuthoriseProperty (Const PropertyIdx : TEventDataPropertyIndex
; iIndex : integer; const PropName : ShortString);
var
  Authorised : Boolean;
begin { AuthoriseProperty }
  // Check for specific enablement of fields
  Authorised := FALSE;
  case PropertyIdx of
    pIdxedBoolResult : begin
      case iIndex of
        1 : Authorised := HookIsTenderOnTender or HookIsTXLineInitialise
        or HookIsCreditCardBeforeShow or HookIsBeforeTenderScreen;
        2 : Authorised := HookIsCreditCardBeforeShow;
      end;
    end;

    pIdxedStringResult : begin
      case iIndex of
//        1 : ;
        1 : Authorised := HookIsTenderBeforePrint; // NF: 22/05/2008 {.290} New for Tomlinson Parbands
      end;
    end;

    pIdxedLongResult : begin
      case iIndex of
        1 : Authorised := HookIsTenderOnTender;
        2 : Authorised := HookIsTenderBeforePrint; // NF: 22/05/2008 {.290} New for Tomlinson Parbands
      end;
    end;

    pIdxedDoubleResult : begin
      case iIndex of
        1 : ;
      end;
    end;

    pIdxedVariantResult : begin
      case iIndex of
        1 : ;
      end;
    end;
  end; { Case }


  if (not Authorised) then begin
    // Raise exception to notify the user that the Plug-In has been naughty
    raise ERightsError.Create (Format('Customisation Error in ITradeEventData for Event %d.%d - The property %s is Read-Only'
    , [FWindowId, FHandlerId, QuotedStr(PropName + '[' + IntToStr(iIndex) + ']')]));
  end;{if}

end; { AuthoriseProperty}


Procedure TTradeEventData.CheckIndexBounds(iIndex, iMaxIndex : integer);
begin
  if (iIndex > iMaxIndex) or (iIndex < 0) then
  Raise EValidation.Create('Invalid Result Index Number (' + IntToStr(iIndex) + ')');
end;


function TTradeEventData.Get_edBoolResult(Index: Integer): WordBool;
begin
  CheckIndexBounds(Index, NO_OF_BOOL_RESULTS);
  Result := aBoolResult[Index];
end;

procedure TTradeEventData.Set_edBoolResult(Index: Integer;
  Value: WordBool);
begin
  CheckIndexBounds(Index, NO_OF_BOOL_RESULTS);
  AuthoriseProperty(pIdxedBoolResult, Index, 'edBoolResult');
  aBoolResult[Index] := CustomSetBoolean(aBoolResult[Index], Value, FDataChanged);
end;


function TTradeEventData.Get_edStringResult(Index: Integer): WideString;
begin
  CheckIndexBounds(Index, NO_OF_STRING_RESULTS);
  Result := aStringResult[Index];
end;

procedure TTradeEventData.Set_edStringResult(Index: Integer;
  const Value: WideString);
begin
  CheckIndexBounds(Index, NO_OF_STRING_RESULTS);
  AuthoriseProperty(pIdxedStringResult, Index, 'edStringResult');
  aStringResult[Index] := CustomSetString(aStringResult[Index], Value, FDataChanged);
end;


function TTradeEventData.Get_edDoubleResult(Index: Integer): Double;
begin
  CheckIndexBounds(Index, NO_OF_DOUBLE_RESULTS);
  Result := aDoubleResult[Index];
end;

procedure TTradeEventData.Set_edDoubleResult(Index: Integer;
  Value: Double);
begin
  CheckIndexBounds(Index, NO_OF_DOUBLE_RESULTS);
  AuthoriseProperty(pIdxedDoubleResult, Index, 'edDoubleResult');
  aDoubleResult[Index] := CustomSetReal(aDoubleResult[Index], Value, FDataChanged);
end;


function TTradeEventData.Get_edLongResult(Index: Integer): Integer;
begin
  CheckIndexBounds(Index, NO_OF_LONG_RESULTS);
  Result := aLongResult[Index];
end;

procedure TTradeEventData.Set_edLongResult(Index, Value: Integer);
begin
  CheckIndexBounds(Index, NO_OF_LONG_RESULTS);
  AuthoriseProperty(pIdxedLongResult, Index, 'edLongResult');
  aLongResult[Index] := CustomSetInteger(aLongResult[Index], Value, FDataChanged);
end;


function TTradeEventData.Get_edVariantResult(Index: Integer): OleVariant;
begin
  CheckIndexBounds(Index, NO_OF_VARIANT_RESULTS);
  Result := aVariantResult[Index];
end;

procedure TTradeEventData.Set_edVariantResult(Index: Integer;
  Value: OleVariant);
begin
  CheckIndexBounds(Index, NO_OF_VARIANT_RESULTS);
  AuthoriseProperty(pIdxedVariantResult, Index, 'edVariantResult');
  aVariantResult[Index] := CustomSetVariant(aVariantResult[Index], Value, FDataChanged);
end;


function TTradeEventData.HookIsTXHeadCustom1: boolean;
begin
  Result := (FWindowId = twiTransaction) and (FHandlerId = hpTXHeadCustom1);
end;

function TTradeEventData.HookIsTXHeadCustom2: boolean;
begin
  Result := (FWindowId = twiTransaction) and (FHandlerId = hpTXHeadCustom2);
end;

function TTradeEventData.HookIsExitCustCodeAfterVal: boolean;
begin
  Result := (FWindowId = twiTransaction) and (FHandlerId = hpTXExitCustCodeAfterVal);
end;

function TTradeEventData.HookIsExitCustCodeBeforeVal: boolean;
begin
  Result := (FWindowId = twiTransaction) and (FHandlerId = hpTXExitCustCodeBeforeVal);
end;

function TTradeEventData.HookIsBeforeTenderScreen: boolean;
begin
  Result := (FWindowId = twiTransaction) and (FHandlerId = hpTXBeforeTenderScreen);
end;


function TTradeEventData.HookIsTXLineCustom1: boolean;
begin
  Result := (FWindowId = twiTransactionLine) and (FHandlerId = hpTXLineCustom1);
end;

function TTradeEventData.HookIsTXLineCustom2: boolean;
begin
  Result := (FWindowId = twiTransactionLine) and (FHandlerId = hpTXLineCustom2);
end;

function TTradeEventData.HookIsTXLineInitialise: boolean;
begin
  Result := (FWindowId = twiTransactionLine) and (FHandlerId = hpTXLineInitialise);
end;

function TTradeEventData.HookIsTXLineEnterQuantity: boolean;
begin
  Result := (FWindowId = twiTransactionLine) and (FHandlerId = hpTXLineEnterQuantity);
end;

function TTradeEventData.HookIsTXLineBeforeStore: boolean;
begin
  Result := (FWindowId = twiTransactionLine) and (FHandlerId = hpTXLineBeforeStore);
end;

function TTradeEventData.HookIsTXLineBeforeCalcStockPrice: boolean;
begin
  Result := (FWindowId = twiTransactionLine) and (FHandlerId = hpTXLineBeforeCalcStockPrice);
end;


function TTradeEventData.HookIsNonStockCustom1: boolean;
begin
  Result := (FWindowId = twiNonStock) and (FHandlerId = hpNonStockCustom1);
end;

function TTradeEventData.HookIsNonStockCustom2: boolean;
begin
  Result := (FWindowId = twiNonStock) and (FHandlerId = hpNonStockCustom2);
end;

function TTradeEventData.HookIsNonStockEnterQuantity: boolean;
begin
  Result := (FWindowId = twiNonStock) and (FHandlerId = hpNonStockEnterQuantity);
end;

function TTradeEventData.HookIsNonStockBeforeStore: boolean;
begin
  Result := (FWindowId = twiNonStock) and (FHandlerId = hpNonStockBeforeStore);
end;


function TTradeEventData.HookIsSerialCustom1: boolean;
begin
  Result := (FWindowId = twiSerialNumbers) and (FHandlerId = hpSerialCustom1);
end;

function TTradeEventData.HookIsSerialCustom2: boolean;
begin
  Result := (FWindowId = twiSerialNumbers) and (FHandlerId = hpSerialCustom2);
end;


function TTradeEventData.HookIsTenderCustom1: boolean;
begin
  Result := (FWindowId = twiTender) and (FHandlerId = hpTenderCustom1);
end;

function TTradeEventData.HookIsTenderCustom2: boolean;
begin
  Result := (FWindowId = twiTender) and (FHandlerId = hpTenderCustom2);
end;

function TTradeEventData.HookIsOnFireCashDrawer: boolean;
begin
  Result := (FWindowId = twiTender) and (FHandlerId = hpOnFireCashDrawer);
end;

function TTradeEventData.HookIsTenderOnTender: boolean;
begin
  Result := (FWindowId = twiTender) and (FHandlerId = hpTenderOnTender);
end;


function TTradeEventData.HookIsCreditCardCustom1: boolean;
begin
  Result := (FWindowId = twiCreditCard) and (FHandlerId = hpCreditCardCustom1);
end;

function TTradeEventData.HookIsCreditCardCustom2: boolean;
begin
  Result := (FWindowId = twiCreditCard) and (FHandlerId = hpCreditCardCustom2);
end;

function TTradeEventData.HookIsCreditCardBeforeShow: boolean;
begin
  Result := (FWindowId = twiCreditCard) and (FHandlerId = hpCreditCardBeforeShow);
end;

// NF: 22/05/2008 {.290} New for Tomlinson Parbands
function TTradeEventData.HookIsTenderBeforePrint: boolean;
begin
  Result := (FWindowId = twiTender) and (FHandlerId = hpTenderBeforePrint);
end;

end.
