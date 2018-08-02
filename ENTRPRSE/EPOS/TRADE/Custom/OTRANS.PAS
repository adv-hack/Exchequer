// Implementation of the "Transaction" COM Object
unit oTrans;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils, EPOSProc
  , oLines, oCust, oAddr, CustomP, ComCtrls, DLLInc, oTender, oPLines;

type
  TTransactionPropertyIndex = (pIdxNeverAuthorise, pIdxThOurRef, pIdxThAcCode
  , pIdxThYourRef, pIdxthLongYourRef, pIdxthSettleDiscAmount, pIdxthNetValue
  , pIdxthSettleDiscDays, pIdxthSettleDiscPerc, pIdxthSettleDiscTaken, pIdxthUserField1
  , pIdxthUserField2, pIdxthUserField3, pIdxthUserField4, pIdxthAnalysisCode
  , pIdxthBatchDiscAmount, pIdxthCompanyRate, pIdxthControlGL, pIdxthCurrency
  , pIdxthDailyRate, pIdxthDeliveryTerms, pIdxthDueDate, pIdxthEmployeeCode
  , pIdxthFixedRate, pIdxthFolioNum, pIdxthHoldFlag, pIdxthJobCode, pIdxthManualVAT
  , pIdxthNoLabels, pIdxthOperator, pIdxthPeriod, pIdxthPORPickSOR, pIdxthPrePost
  , pIdxthProcess, pIdxthTagNo, pIdxthTotalCost, pIdxthTotalLineDiscount
  , pIdxthTotalOrderOS, pIdxthTotalWeight, pIdxthTransDate, pIdxthTransportMode
  , pIdxthTransportNature, pIdxthVATAnalysis, pIdxthYear);

  TTransactionFunctionIndex = (fIdxUnknownfunction);

  TTradeEventTransaction = class(TAutoIntfObject, ITradeEventTransaction)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;

    FTHLinesO : TTradeEventTransLines;
    FTHLinesI : ITradeEventTransLines;

    FPaymentLinesO : TTradeEventPaymentLines;
    FPaymentLinesI : ITradeEventPaymentLines;

    FCustO : TTradeEventCustomer;
    FCustI : ITradeEventCustomer;

    FDelAddrO : TTradeAddress;
    FDelAddrI : ITradeAddress;

    FTenderO : TTradeEventTender;
    FTenderI : ITradeEventTender;

    oEventData : TObject;

    Function GetDataChanged : Boolean;

  protected
    // ITradeEventTransaction
    function Get_thOurRef: WideString; safecall;
    procedure Set_thOurRef(const Value: WideString); safecall;
    function Get_thYourRef: WideString; safecall;
    procedure Set_thYourRef(const Value: WideString); safecall;
    function Get_thAcCode: WideString; safecall;
    procedure Set_thAcCode(const Value: WideString); safecall;
    function Get_thRunNo: Integer; safecall;
    function Get_thFolioNum: Integer; safecall;
    procedure Set_thFolioNum(Value: Integer); safecall;
    function Get_thCurrency: Smallint; safecall;
    procedure Set_thCurrency(Value: Smallint); safecall;
    function Get_thYear: Smallint; safecall;
    procedure Set_thYear(Value: Smallint); safecall;
    function Get_thPeriod: Smallint; safecall;
    procedure Set_thPeriod(Value: Smallint); safecall;
    function Get_thTransDate: WideString; safecall;
    procedure Set_thTransDate(const Value: WideString); safecall;
    function Get_thDueDate: WideString; safecall;
    procedure Set_thDueDate(const Value: WideString); safecall;
    function Get_thCompanyRate: Double; safecall;
    procedure Set_thCompanyRate(Value: Double); safecall;
    function Get_thDailyRate: Double; safecall;
    procedure Set_thDailyRate(Value: Double); safecall;
    function Get_thDocType: TTradeDocTypes; safecall;
    function Get_thVATAnalysis(const Index: WideString): Double; safecall;
    procedure Set_thVATAnalysis(const Index: WideString; Value: Double); safecall;
    function Get_thNetValue: Double; safecall;
    procedure Set_thNetValue(Value: Double); safecall;
    function Get_thTotalVAT: Double; safecall;
    procedure Set_thTotalVAT(Value: Double); safecall;
    function Get_thSettleDiscPerc: Double; safecall;
    procedure Set_thSettleDiscPerc(Value: Double); safecall;
    function Get_thSettleDiscAmount: Double; safecall;
    procedure Set_thSettleDiscAmount(Value: Double); safecall;
    function Get_thTotalLineDiscount: Double; safecall;
    procedure Set_thTotalLineDiscount(Value: Double); safecall;
    function Get_thSettleDiscDays: Smallint; safecall;
    procedure Set_thSettleDiscDays(Value: Smallint); safecall;
    function Get_thSettleDiscTaken: WordBool; safecall;
    procedure Set_thSettleDiscTaken(Value: WordBool); safecall;
    function Get_thAmountSettled: Double; safecall;
    function Get_thTransportNature: Smallint; safecall;
    procedure Set_thTransportNature(Value: Smallint); safecall;
    function Get_thTransportMode: Smallint; safecall;
    procedure Set_thTransportMode(Value: Smallint); safecall;
    function Get_thHoldFlag: Smallint; safecall;
    procedure Set_thHoldFlag(Value: Smallint); safecall;
    function Get_thTotalWeight: Double; safecall;
    procedure Set_thTotalWeight(Value: Double); safecall;
    function Get_thDelAddress: ITradeAddress; safecall;
    function Get_thTotalCost: Double; safecall;
    procedure Set_thTotalCost(Value: Double); safecall;
    function Get_thPrinted: WordBool; safecall;
    function Get_thManualVAT: WordBool; safecall;
    procedure Set_thManualVAT(Value: WordBool); safecall;
    function Get_thDeliveryTerms: WideString; safecall;
    procedure Set_thDeliveryTerms(const Value: WideString); safecall;
    function Get_thOperator: WideString; safecall;
    procedure Set_thOperator(const Value: WideString); safecall;
    function Get_thJobCode: WideString; safecall;
    procedure Set_thJobCode(const Value: WideString); safecall;
    function Get_thAnalysisCode: WideString; safecall;
    procedure Set_thAnalysisCode(const Value: WideString); safecall;
    function Get_thTotalOrderOS: Double; safecall;
    procedure Set_thTotalOrderOS(Value: Double); safecall;
    function Get_thUserField1: WideString; safecall;
    procedure Set_thUserField1(const Value: WideString); safecall;
    function Get_thUserField2: WideString; safecall;
    procedure Set_thUserField2(const Value: WideString); safecall;
    function Get_thUserField3: WideString; safecall;
    procedure Set_thUserField3(const Value: WideString); safecall;
    function Get_thUserField4: WideString; safecall;
    procedure Set_thUserField4(const Value: WideString); safecall;
    function Get_thTagNo: Integer; safecall;
    procedure Set_thTagNo(Value: Integer); safecall;
    function Get_thNoLabels: Smallint; safecall;
    procedure Set_thNoLabels(Value: Smallint); safecall;
    function Get_thControlGL: Integer; safecall;
    procedure Set_thControlGL(Value: Integer); safecall;
    function Get_thProcess: TTradeIntrastatProcess; safecall;
    procedure Set_thProcess(Value: TTradeIntrastatProcess); safecall;
    function Get_thSource: Integer; safecall;
    function Get_thPostedDate: WideString; safecall;
    function Get_thPORPickSOR: WordBool; safecall;
    procedure Set_thPORPickSOR(Value: WordBool); safecall;
    function Get_thBatchDiscAmount: Double; safecall;
    procedure Set_thBatchDiscAmount(Value: Double); safecall;
    function Get_thPrePost: Integer; safecall;
    procedure Set_thPrePost(Value: Integer); safecall;
    function Get_thOutstanding: WideString; safecall;
    function Get_thFixedRate: WordBool; safecall;
    procedure Set_thFixedRate(Value: WordBool); safecall;
    function Get_thLongYourRef: WideString; safecall;
    procedure Set_thLongYourRef(const Value: WideString); safecall;
//    function Get_thGoodsAnalysis(const Index: WideString): Double; safecall;
//    function Get_thLineTypeAnalysis(Index: Integer): Double; safecall;
    function Get_thEmployeeCode: WideString; safecall;
    procedure Set_thEmployeeCode(const Value: WideString); safecall;
    function Get_thLines: ITradeEventTransLines; safecall;
    function Get_thPaymentLines: ITradeEventPaymentLines; safecall;
    function Get_thCustomer: ITradeEventCustomer; safecall;
    function Get_thTender: ITradeEventTender; safecall;

    procedure Recalculate; safecall;

    // Local Methods
    Procedure AuthoriseProperty (Const PropertyIdx : TTransactionPropertyIndex; const PropName : ShortString);
    Procedure AuthoriseFunction (Const FunctionIdx : TTransactionFunctionIndex; const FuncName : ShortString);
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    Property DataChanged : Boolean Read GetDataChanged;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign(const EventData : TObject);
//    function GetLTXRec : TTXRec;
  End; { TTradeEventTransaction }

implementation

uses
  TXRecs, VarConst, EPOSCnst, EntLkup, StrUtil, ETMiscU, TXHead, ComServ, oEvent, oVersion;

//---------------------------------------------------------------------------

Constructor TTradeEventTransaction.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  FTHLinesO := TTradeEventTransLines.Create;
  FTHLinesI := FTHLinesO;

  FPaymentLinesO := TTradeEventPaymentLines.Create;
  FPaymentLinesI := FPaymentLinesO;

  FCustO := TTradeEventCustomer.Create;
  FCustI := FCustO;

  FDelAddrO := TTradeAddress.Create;
  FDelAddrI := FDelAddrO;

  FTenderO := TTradeEventTender.Create;
  FTenderI := FTenderO;

  FDataChanged := False;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeEventTransaction.Destroy;
Begin { Destroy }

  FTHLinesO := nil;
  FTHLinesI := nil;

  FPaymentLinesO := nil;
  FPaymentLinesI := nil;

  FCustO := nil;
  FCustI := nil;

  FDelAddrO := nil;
  FDelAddrI := nil;

  FTenderO := nil;
  FTenderI := nil;

  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Procedure TTradeEventTransaction.Assign(const EventData : TObject);

begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;

  oEventData := EventData;

  // Assign sub-objects
  FCustO.Assign(oEventData);
  FDelAddrO.Assign(oEventData, waTransaction);
  FTHLinesO.Assign(oEventData);
  FPaymentLinesO.Assign(oEventData);
  FTenderO.Assign(oEventData);
end; { Assign }

//---------------------------------------------------------------------------

//function TTradeEventTransaction.GetLTXRec : TTXRec;
//begin
//  Result := lTXRec;
//end;

//---------------------------------------------------------------------------

// Returns True if the specified property can be written to by the Plug-In during the current event
procedure TTradeEventTransaction.AuthoriseProperty (Const PropertyIdx : TTransactionPropertyIndex; const PropName : ShortString);
var
  Authorised : Boolean;
begin { AuthoriseProperty }
  // Check for specific enablement of fields

  Authorised := FALSE;

  with TTradeEventData(oEventData) do begin
    case PropertyIdx of
      pIdxThUserField1, pIdxThUserField2, pIdxThUserField3 : begin
        Authorised := HookIsBeforeTenderScreen or HookIsTXHeadCustom1 or HookIsTXHeadCustom2;
      end;

      pIdxThYourRef, pIdxThLongYourRef : begin
        Authorised := HookIsBeforeTenderScreen or HookIsTXHeadCustom1 or HookIsTXHeadCustom2;
      end;

      pIdxthHoldFlag, pIdxthTagNo : begin
        Authorised := HookIsBeforeTenderScreen;
      end;

      pIdxThAcCode : Authorised := HookIsExitCustCodeBeforeVal or HookIsTXHeadCustom1;
    end; { Case }


    if (not Authorised) then begin
      // Raise exception to notify the user that the Plug-In has been naughty
      raise ERightsError.Create (Format('Customisation Error in ITradeEventTransaction for Event %d.%d - The property %s is Read-Only'
      , [FWindowId, FHandlerId, QuotedStr(PropName)]));
    end;{if}
  end;{with}

end; { AuthoriseProperty }

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


// Returns TRUE if any properties within the eventdata have been changed
Function TTradeEventTransaction.GetDataChanged : Boolean;
Begin { GetDataChanged }
  Result := FDataChanged or FTHLinesO.DataChanged or FPaymentLinesO.DataChanged
  or FCustO.DataChanged or FDelAddrO.DataChanged or FTenderO.DataChanged;
End; { GetDataChanged }


function TTradeEventTransaction.Get_thLines: ITradeEventTransLines;
begin
  Result := FTHLinesI;
end;


function TTradeEventTransaction.Get_thOurRef: WideString;
begin
//  Result := TTradeEventData(oEventData).LTXRec.sRefNo;
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.OurRef;
end;

procedure TTradeEventTransaction.Set_thOurRef(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxThOurRef, 'ThOurRef');

  // Set String Value
//  TTradeEventData(oEventData).LTXRec.sRefNo := CustomSetString(TTradeEventData(oEventData).LTXRec.sRefNo, Value, FDataChanged);
  TTradeEventData(oEventData).LTXRec.TKTXHeader.OurRef
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.OurRef, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thYourRef: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.YourRef;
end;

procedure TTradeEventTransaction.Set_thYourRef(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxThYourRef, 'ThYourRef');

  // Set String Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.YourRef
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.YourRef, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thAcCode: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.CustCode;
end;

procedure TTradeEventTransaction.Set_thAcCode(const Value: WideString);
var
  sAccountCode : string20;
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxThAcCode, 'ThAcCode');

  TTradeEventData(oEventData).LTXRec.TKTXHeader.CustCode
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.CustCode, UpperCase(Value), FDataChanged);


  // Update Customer Object
{  if Trim(TTradeEventData(oEventData).LTXRec.TKTXHeader.CustCode) <> UpperCase(Trim(Value)) then begin
    sAccountCode := UpperCase(Value);
    if DoGetCust(nil, sCurrCompPath, sAccountCode, sAccountCode, trdCustomer, vmCheckValue, TRUE
    , ciAccountCode) and (UpperCase(Trim(sAccountCode)) = UpperCase(Trim(Value))) then
      begin

        TTradeEventData(oEventData).LTXRec.LCust := Cust;

        // Set String Value
        TTradeEventData(oEventData).LTXRec.TKTXHeader.CustCode
        := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.CustCode, UpperCase(Value), FDataChanged);

        // Recalc lines and totals
        RepopulateOtherThingsAboutAllLines(TTradeEventData(oEventData).LTXRec, TTradeEventData(oEventData).LListView);
        RecalcAllTXLines(TTradeEventData(oEventData).LTXRec, TTradeEventData(oEventData).LListView, TRUE);
        RecalcTXTotals(TTradeEventData(oEventData).LTXRec, TTradeEventData(oEventData).LListView);
      end
    else begin
      Raise EValidation.Create ('Invalid Account Code. This account code does not exist (' + UpperCase(Value) + ')');
    end;{if}
{  end;{if}

end;


function TTradeEventTransaction.Get_thCustomer: ITradeEventCustomer;
begin
  Result := FCustI;
end;


function TTradeEventTransaction.Get_thPaymentLines: ITradeEventPaymentLines;
begin
  Result := FPaymentLinesI;
end;


function TTradeEventTransaction.Get_thTender: ITradeEventTender;
begin
  Result := FTenderI;
end;


function TTradeEventTransaction.Get_thAmountSettled: Double;
begin
//  Result := Round_Up(TTradeEventData(oEventData).LTXRec.rTendered, TKSysRec.PriceDP);
  Result := Round_Up(TTradeEventData(oEventData).LTXRec.TKTXHeader.Settled , TKSysRec.PriceDP);
end;


function TTradeEventTransaction.Get_thAnalysisCode: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.DJobAnal;
end;

procedure TTradeEventTransaction.Set_thAnalysisCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthAnalysisCode, 'thAnalysisCode');

  // Set String Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.DJobAnal
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.DJobAnal, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thBatchDiscAmount: Double;
begin
  Result := Round_Up(TTradeEventData(oEventData).LTXRec.TKTXHeader.BDiscount , TKSysRec.PriceDP);
end;

procedure TTradeEventTransaction.Set_thBatchDiscAmount(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthBatchDiscAmount, 'thBatchDiscAmount');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.BDiscount
  := CustomSetReal(TTradeEventData(oEventData).LTXRec.TKTXHeader.BDiscount, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thCompanyRate: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.CoRate;
end;

procedure TTradeEventTransaction.Set_thCompanyRate(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthCompanyRate, 'thCompanyRate');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.CoRate
  := CustomSetReal(TTradeEventData(oEventData).LTXRec.TKTXHeader.CoRate, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thControlGL: Integer;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.CtrlNom;
end;

procedure TTradeEventTransaction.Set_thControlGL(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthControlGL, 'thControlGL');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.CtrlNom
  := CustomSetInteger(TTradeEventData(oEventData).LTXRec.TKTXHeader.CtrlNom, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thCurrency: Smallint;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.Currency;
end;

procedure TTradeEventTransaction.Set_thCurrency(Value: Smallint);
var
  FVersionO : TTradeVersion;
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthCurrency, 'thCurrency');

  // Set Value
  FVersionO := TTradeVersion.Create;
  TTradeEventData(oEventData).LTXRec.TKTXHeader.Currency
  := CustomSetInteger(TTradeEventData(oEventData).LTXRec.TKTXHeader.Currency
  , FVersionO.ValidateCurrencyNo(Value), FDataChanged);
  FVersionO := nil;
end;


function TTradeEventTransaction.Get_thDailyRate: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.VATRate;
end;

procedure TTradeEventTransaction.Set_thDailyRate(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthDailyRate, 'thDailyRate');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.VATRate
  := CustomSetReal(TTradeEventData(oEventData).LTXRec.TKTXHeader.VATRate, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thDelAddress: ITradeAddress;
begin
  Result := FDelAddrI;
end;


function TTradeEventTransaction.Get_thDeliveryTerms: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.DelTerms;
end;

procedure TTradeEventTransaction.Set_thDeliveryTerms(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthDeliveryTerms, 'thDeliveryTerms');

  // Set String Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.DelTerms
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.DelTerms, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thDocType: TTradeDocTypes;
begin
  Result := TKDocTypeToTLBDocType(TTradeEventData(oEventData).LTXRec.TKTXHeader.TransDocHed);
end;


function TTradeEventTransaction.Get_thDueDate: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.DueDate;
end;

procedure TTradeEventTransaction.Set_thDueDate(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthDueDate, 'thDueDate');

  // Set String Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.DueDate
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.DueDate, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thEmployeeCode: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.EmpCode;
end;

procedure TTradeEventTransaction.Set_thEmployeeCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthEmployeeCode, 'thEmployeeCode');

  // Set String Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.EmpCode
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.EmpCode, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thFixedRate: WordBool;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.SOPKeepRate;
end;

procedure TTradeEventTransaction.Set_thFixedRate(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthFixedRate, 'thFixedRate');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.SOPKeepRate
  := CustomSetBoolean(TTradeEventData(oEventData).LTXRec.TKTXHeader.SOPKeepRate, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thFolioNum: Integer;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.FolioNum;
end;

procedure TTradeEventTransaction.Set_thFolioNum(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthFolioNum, 'thFolioNum');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.FolioNum
  := CustomSetInteger(TTradeEventData(oEventData).LTXRec.TKTXHeader.FolioNum, Value, FDataChanged);
end;

(*
function TTradeEventTransaction.Get_thGoodsAnalysis(const Index: WideString): Double;
Var
  I     : SmallInt;
begin
  // check to see if cache can be used
  If (FTH.FolioNum <> FGoodsFolio) Then Begin
    // Recalculate Goods Analysis Array
    FillChar (FGoodsAnalysis, SizeOf(FGoodsAnalysis), #0);

    // Force the transaction lines to be loaded/updated
    Get_thLines;

    // Start the enum of the transaction lines, for the recalculation proc
    FTHLinesO.EnumLines (enumGoodsAnalysis, NIL);

    // Update cache info
    If (FTH.FolioNum <> 0) Then
      FGoodsFolio := FTH.FolioNum;
  End; { If (FTH.FolioNum <> FGoodsFolio) }

  Result := FGoodsAnalysis[GetVATNo(ExtractChar(Index, #255), #0)];
end;
*)

function TTradeEventTransaction.Get_thHoldFlag: Smallint;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.HoldFlg;
end;

procedure TTradeEventTransaction.Set_thHoldFlag(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthHoldFlag, 'thHoldFlag');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.HoldFlg
  := CustomSetInteger(TTradeEventData(oEventData).LTXRec.TKTXHeader.HoldFlg, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thJobCode: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.DJobCode;
end;

procedure TTradeEventTransaction.Set_thJobCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthJobCode, 'thJobCode');

  // Set String Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.DJobCode
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.DJobCode, Value, FDataChanged);
end;

(*
function TTradeEventTransaction.Get_thLineTypeAnalysis(Index: Integer): Double;
Var
  I : SmallInt;
begin
  If (Index >= 0) And (Index <= 6) Then Begin
    // check to see if cache can be used
    If (FTH.FolioNum <> FLineTypeFolio) Then Begin
      // Recalculate Goods Analysis Array
      FillChar (FLTypeAnalysis, SizeOf(FLTypeAnalysis), #0);

      // Force the transaction lines to be loaded/updated
      Get_thLines;

      // Start the enum of the transaction lines, for the recalculation proc
      FTHLinesO.EnumLines (enumLineTypeAnalysis, NIL);

      // Update cache info
      If (FTH.FolioNum <> 0) Then
        FLineTypeFolio := FTH.FolioNum;
    End; { If (FTH.FolioNum <> FLineTypeFolio) }

    Result := FLTypeAnalysis[Index];
  End { If (Index >= 0) And (Index <= 6) }
  Else
    Raise EUnknownValue.Create ('Invalid Line Type (' + IntToStr(Index) + ') retrieving thLineTypeAnalysis');
end;
*)

function TTradeEventTransaction.Get_thLongYourRef: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.LongYrRef;
end;

procedure TTradeEventTransaction.Set_thLongYourRef(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthLongYourRef, 'thLongYourRef');

  // Set String Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.LongYrRef
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.LongYrRef, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thManualVAT: WordBool;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.ManVAT;
end;

procedure TTradeEventTransaction.Set_thManualVAT(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthManualVAT, 'thManualVAT');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.ManVAT
  := CustomSetBoolean(TTradeEventData(oEventData).LTXRec.TKTXHeader.ManVAT, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thNetValue: Double;
begin
  Result := Round_Up(TTradeEventData(oEventData).LTXRec.rNetTotal , TKSysRec.PriceDP);
end;

procedure TTradeEventTransaction.Set_thNetValue(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthNetValue, 'thNetValue');

  TTradeEventData(oEventData).LTXRec.rNetTotal
  := CustomSetReal(TTradeEventData(oEventData).LTXRec.rNetTotal, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thNoLabels: Smallint;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.thNoLabels;
end;

procedure TTradeEventTransaction.Set_thNoLabels(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthNoLabels, 'thNoLabels');

  TTradeEventData(oEventData).LTXRec.TKTXHeader.thNoLabels
  := CustomSetInteger(TTradeEventData(oEventData).LTXRec.TKTXHeader.thNoLabels, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thOperator: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.OpName;
end;

procedure TTradeEventTransaction.Set_thOperator(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthOperator, 'thOperator');

  TTradeEventData(oEventData).LTXRec.TKTXHeader.OpName
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.OpName, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thOutstanding: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.AllocStat;
end;


function TTradeEventTransaction.Get_thPeriod: Smallint;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.AcPr;
end;

procedure TTradeEventTransaction.Set_thPeriod(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxthPeriod, 'thPeriod');

  TTradeEventData(oEventData).LTXRec.TKTXHeader.AcPr
  := CustomSetInteger(TTradeEventData(oEventData).LTXRec.TKTXHeader.AcPr, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thPORPickSOR: WordBool;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.PORPickSOR;
end;

procedure TTradeEventTransaction.Set_thPORPickSOR(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxthPORPickSOR, 'thPORPickSOR');

  TTradeEventData(oEventData).LTXRec.TKTXHeader.PORPickSOR
  := CustomSetBoolean(TTradeEventData(oEventData).LTXRec.TKTXHeader.PORPickSOR, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thPostedDate: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.PostDate;
end;

function TTradeEventTransaction.Get_thPrePost: Integer;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.PrePostFlg;
end;

procedure TTradeEventTransaction.Set_thPrePost(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxthPrePost, 'thPrePost');

  TTradeEventData(oEventData).LTXRec.TKTXHeader.PrePostFlg
  := CustomSetInteger(TTradeEventData(oEventData).LTXRec.TKTXHeader.PrePostFlg, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thPrinted: WordBool;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.PrintedDoc;
end;

function TTradeEventTransaction.Get_thProcess: TTradeIntrastatProcess;
begin
  Case TTradeEventData(oEventData).LTXRec.TKTXHeader.SSDProcess Of
    ' ', #0 : Result := ipNormal;
    'T' : Result := ipTriangulation;
    'P' : Result := ipProcess;
  Else
    Raise EValidation.Create ('Invalid SSD Process Flag ('
    + TTradeEventData(oEventData).LTXRec.TKTXHeader.SSDProcess + ')');
  End; { Case FTH.SSDProcess }
end;

procedure TTradeEventTransaction.Set_thProcess(Value: TTradeIntrastatProcess);
var
  sProcess : WideString;
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxthProcess, 'thProcess');

  Case Value Of
    ipNormal        : sProcess := ' ';
    ipTriangulation : sProcess := 'T';
    ipProcess       : sProcess := 'P';
  Else
    Raise EValidation.Create ('Invalid SSD Process Flag (' + IntToStr(Ord(Value)) + ')');
  End; { Case FTH.SSDProcess }

  TTradeEventData(oEventData).LTXRec.TKTXHeader.SSDProcess
  := ExtractChar(CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.SSDProcess
  , sProcess, FDataChanged), #255);
end;


function TTradeEventTransaction.Get_thRunNo: Integer;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.RunNo;
end;


function TTradeEventTransaction.Get_thSettleDiscAmount: Double;
begin
  Result := Round_Up(TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscSetAm , TKSysRec.PriceDP);
end;

procedure TTradeEventTransaction.Set_thSettleDiscAmount(Value: Double);
begin
  // Check this property can be written to for this event
//  AuthoriseProperty (pIdxthSettleDiscAmount, 'thSettleDiscAmount');
  AuthoriseProperty (pIdxthSettleDiscAmount, 'thSettleDiscAmount');

  // Set Real Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscSetAm
  := CustomSetReal(TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscSetAm, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thSettleDiscDays: Smallint;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscDays;
end;

procedure TTradeEventTransaction.Set_thSettleDiscDays(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthSettleDiscDays, 'thSettleDiscDays');

  // Set Integer Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscDays
  := CustomSetInteger(TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscDays, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thSettleDiscPerc: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscSetl;
end;

procedure TTradeEventTransaction.Set_thSettleDiscPerc(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthSettleDiscPerc, 'thSettleDiscPerc');

  // Set Real Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscSetl
  := CustomSetReal(TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscSetl, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thSettleDiscTaken: WordBool;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscTaken;
end;

procedure TTradeEventTransaction.Set_thSettleDiscTaken(Value: WordBool);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthSettleDiscTaken, 'thSettleDiscTaken');

  // Set Boolean Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscTaken
  := CustomSetBoolean(TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscTaken, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thSource: Integer;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.ExtSource;
end;

function TTradeEventTransaction.Get_thTagNo: Integer;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.Tagged;
end;

procedure TTradeEventTransaction.Set_thTagNo(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthTagNo, 'thTagNo');

  if (Value < 0) or (Value > 99) then
    begin
      raise ERangeError.Create('Tag Number out of range : ' + IntToStr(Value) + #13 + #13
      + 'The Tag Number must be from 0 to 99')
    end
  else begin
    // Set Value
    TTradeEventData(oEventData).LTXRec.TKTXHeader.Tagged
    := CustomSetInteger(TTradeEventData(oEventData).LTXRec.TKTXHeader.Tagged, Value, FDataChanged);
  end;{if}
end;


function TTradeEventTransaction.Get_thTotalCost: Double;
begin
  Result := Round_Up(TTradeEventData(oEventData).LTXRec.TKTXHeader.TotalCost , TKSysRec.CostDP);
end;

procedure TTradeEventTransaction.Set_thTotalCost(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthTotalCost, 'thTotalCost');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.TotalCost
  := CustomSetReal(TTradeEventData(oEventData).LTXRec.TKTXHeader.TotalCost, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thTotalLineDiscount: Double;
begin
  Result := Round_Up(TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscAmount , TKSysRec.PriceDP);
end;

procedure TTradeEventTransaction.Set_thTotalLineDiscount(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthTotalLineDiscount, 'thTotalLineDiscount');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscAmount
  := CustomSetReal(TTradeEventData(oEventData).LTXRec.TKTXHeader.DiscAmount, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thTotalOrderOS: Double;
begin
  Result := Round_Up(TTradeEventData(oEventData).LTXRec.TKTXHeader.TotOrdOS, TKSysRec.PriceDP);
end;

procedure TTradeEventTransaction.Set_thTotalOrderOS(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthTotalOrderOS, 'thTotalOrderOS');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.TotOrdOS
  := CustomSetReal(TTradeEventData(oEventData).LTXRec.TKTXHeader.TotOrdOS, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thTotalVAT: Double;
begin
  Result := Round_Up(TTradeEventData(oEventData).LTXRec.TKTXHeader.InvVat , TKSysRec.PriceDP);
end;

procedure TTradeEventTransaction.Set_thTotalVAT(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxNeverAuthorise, 'thTotalVAT');
end;


function TTradeEventTransaction.Get_thTotalWeight: Double;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.TotalWeight;
end;

procedure TTradeEventTransaction.Set_thTotalWeight(Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthTotalWeight, 'thTotalWeight');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.TotalWeight
  := CustomSetReal(TTradeEventData(oEventData).LTXRec.TKTXHeader.TotalWeight, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thTransDate: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.TransDate;
end;

procedure TTradeEventTransaction.Set_thTransDate(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthTransDate, 'thTransDate');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.TransDate
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.TransDate, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thTransportMode: Smallint;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.TransMode;
end;

procedure TTradeEventTransaction.Set_thTransportMode(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxthTransportMode, 'thTransportMode');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.TransMode
  := CustomSetInteger(TTradeEventData(oEventData).LTXRec.TKTXHeader.TransMode, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thTransportNature: Smallint;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.TransNat;
end;

procedure TTradeEventTransaction.Set_thTransportNature(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxthTransportNature, 'thTransportNature');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.TransNat
  := CustomSetInteger(TTradeEventData(oEventData).LTXRec.TKTXHeader.TransNat, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thUserField1: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.DocUser1;
end;

procedure TTradeEventTransaction.Set_thUserField1(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthUserField1, 'thUserField1');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.DocUser1
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.DocUser1, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thUserField2: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.DocUser2;
end;

procedure TTradeEventTransaction.Set_thUserField2(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthUserField2, 'thUserField2');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.DocUser2
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.DocUser2, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thUserField3: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.DocUser3;
end;

procedure TTradeEventTransaction.Set_thUserField3(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxthUserField3, 'thUserField3');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.DocUser3
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.DocUser3, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thUserField4: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.DocUser4;
end;

procedure TTradeEventTransaction.Set_thUserField4(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxNeverAuthorise, 'thUserField4');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.DocUser4
  := CustomSetString(TTradeEventData(oEventData).LTXRec.TKTXHeader.DocUser4, Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thVATAnalysis(const Index: WideString): Double;
var
  cIndex : Char;
begin
  Result := Round_Up(TTradeEventData(oEventData).LTXRec.TKTXHeader.InvVatAnal[VatCharToIdx(ExtractChar(Index, #255))]
  , TKSysRec.PriceDP);
end;

procedure TTradeEventTransaction.Set_thVATAnalysis(const Index: WideString; Value: Double);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxthVATAnalysis, 'thVATAnalysis');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.InvVatAnal[VatCharToIdx(ExtractChar(Index, #255))]
  := CustomSetReal(TTradeEventData(oEventData).LTXRec.TKTXHeader.InvVatAnal[VatCharToIdx(ExtractChar(Index, #255))]
  , Value, FDataChanged);
end;


function TTradeEventTransaction.Get_thYear: Smallint;
begin
  Result := TTradeEventData(oEventData).LTXRec.TKTXHeader.AcYr + 1900;
end;

procedure TTradeEventTransaction.Set_thYear(Value: Smallint);
begin
  // Check this property can be written to for this event
  AuthoriseProperty(pIdxthYear, 'thYear');

  // Set Value
  TTradeEventData(oEventData).LTXRec.TKTXHeader.AcYr
  := CustomSetInteger(TTradeEventData(oEventData).LTXRec.TKTXHeader.AcYr - 1900, Value, FDataChanged);
end;


procedure TTradeEventTransaction.Recalculate;
begin
  RecalcAllTXLines(TTradeEventData(oEventData).LTXRec, TTradeEventData(oEventData).LListView, FALSE);
  RecalcTXTotals(TTradeEventData(oEventData).LTXRec, TTradeEventData(oEventData).LListView);
  RepopulateOtherThingsAboutAllLines(TTradeEventData(oEventData).LTXRec, TTradeEventData(oEventData).LListView);
end;


end.
