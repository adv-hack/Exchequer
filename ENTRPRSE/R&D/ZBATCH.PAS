unit ZBatch;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  TCOMBatchSerial = class(TAutoIntfObject, ICOMBatchSerial, ICOMBatchSerial2, ICOMBatchSerial3)
  private
    FEntSysObj : TEnterpriseSystem;
  protected
    function  Get_AccessRights: TRecordAccessStatus; safecall;
    function  Get_DataChanged: WordBool; safecall;
    function  Get_bsSerialCode: WideString; safecall;
    procedure Set_bsSerialCode(const Value: WideString); safecall;
    function  Get_bsSerialNo: WideString; safecall;
    procedure Set_bsSerialNo(const Value: WideString); safecall;
    function  Get_bsBatchNo: WideString; safecall;
    procedure Set_bsBatchNo(const Value: WideString); safecall;
    function  Get_bsInDoc: WideString; safecall;
    procedure Set_bsInDoc(const Value: WideString); safecall;
    function  Get_bsOutDoc: WideString; safecall;
    procedure Set_bsOutDoc(const Value: WideString); safecall;
    function  Get_bsSold: WordBool; safecall;
    procedure Set_bsSold(Value: WordBool); safecall;
    function  Get_bsDateIn: WideString; safecall;
    procedure Set_bsDateIn(const Value: WideString); safecall;
    function  Get_bsSerCost: Double; safecall;
    procedure Set_bsSerCost(Value: Double); safecall;
    function  Get_bsSerSell: Double; safecall;
    procedure Set_bsSerSell(Value: Double); safecall;
    function  Get_bsStkFolio: Integer; safecall;
    procedure Set_bsStkFolio(Value: Integer); safecall;
    function  Get_bsDateOut: WideString; safecall;
    procedure Set_bsDateOut(const Value: WideString); safecall;
    function  Get_bsSoldLine: Integer; safecall;
    procedure Set_bsSoldLine(Value: Integer); safecall;
    function  Get_bsCurCost: TCurrencyType; safecall;
    procedure Set_bsCurCost(Value: TCurrencyType); safecall;
    function  Get_bsCurSell: TCurrencyType; safecall;
    procedure Set_bsCurSell(Value: TCurrencyType); safecall;
    function  Get_bsBuyLine: Integer; safecall;
    procedure Set_bsBuyLine(Value: Integer); safecall;
    function  Get_bsBatchRec: WordBool; safecall;
    procedure Set_bsBatchRec(Value: WordBool); safecall;
    function  Get_bsBuyQty: Double; safecall;
    procedure Set_bsBuyQty(Value: Double); safecall;
    function  Get_bsQtyUsed: Double; safecall;
    procedure Set_bsQtyUsed(Value: Double); safecall;
    function  Get_bsBatchChild: WordBool; safecall;
    procedure Set_bsBatchChild(Value: WordBool); safecall;
    function  Get_bsInMLoc: WideString; safecall;
    procedure Set_bsInMLoc(const Value: WideString); safecall;
    function  Get_bsOutMLoc: WideString; safecall;
    procedure Set_bsOutMLoc(const Value: WideString); safecall;
    function  Get_bsCompanyRate: Double; safecall;
    procedure Set_bsCompanyRate(Value: Double); safecall;
    function  Get_bsDailyRate: Double; safecall;
    procedure Set_bsDailyRate(Value: Double); safecall;
    function  Get_bsInOrdDoc: WideString; safecall;
    procedure Set_bsInOrdDoc(const Value: WideString); safecall;
    function  Get_bsOutOrdDoc: WideString; safecall;
    procedure Set_bsOutOrdDoc(const Value: WideString); safecall;
    function  Get_bsInOrdLine: Integer; safecall;
    procedure Set_bsInOrdLine(Value: Integer); safecall;
    function  Get_bsOutOrdLine: Integer; safecall;
    procedure Set_bsOutOrdLine(Value: Integer); safecall;
    function  Get_bsNLineCount: Integer; safecall;
    procedure Set_bsNLineCount(Value: Integer); safecall;
    function  Get_bsNoteFolio: Integer; safecall;
    procedure Set_bsNoteFolio(Value: Integer); safecall;
    function  Get_bsDateUseX: WideString; safecall;
    procedure Set_bsDateUseX(const Value: WideString); safecall;
    function  Get_bsSUseORate: Smallint; safecall;
    procedure Set_bsSUseORate(Value: Smallint); safecall;

    // HM 10/09/03 v5.52: ICOMBatchSerial2
    function Get_bsBinCode: WideString; safecall;
    procedure Set_bsBinCode(const Value: WideString); safecall;

    // MH 27/07/05 - v5.70 - ICOMBatchSerial3
    function Get_bsReturned: WordBool; safecall;
    procedure Set_bsReturned(Value: WordBool); safecall;
    function Get_bsReturnOurRef: WideString; safecall;
    procedure Set_bsReturnOurRef(const Value: WideString); safecall;
    function Get_bsBatchReturnedQty: Double; safecall;
    procedure Set_bsBatchReturnedQty(Value: Double); safecall;
    function Get_bsReturnLineNo: Integer; safecall;
    procedure Set_bsReturnLineNo(Value: Integer); safecall;
  public
    Constructor Create;

    Procedure InitBatch(EntSysObj : TEnterpriseSystem);
  End; { TCOMBatchSerial }

implementation

uses ComServ, CustIntU;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMBatchSerial.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMBatchSerial3);

End; { Create }

{-----------------------------------------}

Procedure TCOMBatchSerial.InitBatch(EntSysObj : TEnterpriseSystem);
Begin { InitBatch }
  FEntSysObj := EntSysObj;

End; { InitBatch }

{-----------------------------------------}

function TCOMBatchSerial.Get_AccessRights: TRecordAccessStatus;
Begin { Get_AccessRights }
  Result := Ord(FEntSysObj.BatchSerial.AccessRights);
End; { Get_AccessRights }

{-----------------------------------------}

function TCOMBatchSerial.Get_DataChanged: WordBool;
Begin { Get_DataChanged }
  Result := FEntSysObj.BatchSerial.DataChanged;
End; { Get_DataChanged }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsSerialCode: WideString;
Begin { Get_bsSerialCode }
  Result := FEntSysObj.BatchSerial.bsSerialCode;
End; { Get_bsSerialCode }

procedure TCOMBatchSerial.Set_bsSerialCode(const Value: WideString);
Begin { Set_bsSerialCode }
  FEntSysObj.BatchSerial.bsSerialCode := Value;
End; { Set_bsSerialCode }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsSerialNo: WideString;
Begin { Get_bsSerialNo }
  Result := FEntSysObj.BatchSerial.bsSerialNo;
End; { Get_bsSerialNo }

procedure TCOMBatchSerial.Set_bsSerialNo(const Value: WideString);
Begin { Set_bsSerialNo }
  FEntSysObj.BatchSerial.bsSerialNo := Value;
End; { Set_bsSerialNo }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsBatchNo: WideString;
Begin { Get_bsBatchNo }
  Result := FEntSysObj.BatchSerial.bsBatchNo;
End; { Get_bsBatchNo }

procedure TCOMBatchSerial.Set_bsBatchNo(const Value: WideString);
Begin { Set_bsBatchNo }
  FEntSysObj.BatchSerial.bsBatchNo := Value;
End; { Set_bsBatchNo }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsInDoc: WideString;
Begin { Get_bsInDoc }
  Result := FEntSysObj.BatchSerial.bsInDoc;
End; { Get_bsInDoc }

procedure TCOMBatchSerial.Set_bsInDoc(const Value: WideString);
Begin { Set_bsInDoc }
  FEntSysObj.BatchSerial.bsInDoc := Value;
End; { Set_bsInDoc }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsOutDoc: WideString;
Begin { Get_bsOutDoc }
  Result := FEntSysObj.BatchSerial.bsOutDoc;
End; { Get_bsOutDoc }

procedure TCOMBatchSerial.Set_bsOutDoc(const Value: WideString);
Begin { Set_bsOutDoc }
  FEntSysObj.BatchSerial.bsOutDoc := Value;
End; { Set_bsOutDoc }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsSold: WordBool;
Begin { Get_bsSold }
  Result := FEntSysObj.BatchSerial.bsSold;
End; { Get_bsSold }

procedure TCOMBatchSerial.Set_bsSold(Value: WordBool);
Begin { Set_bsSold }
  FEntSysObj.BatchSerial.bsSold := Value;
End; { Set_bsSold }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsDateIn: WideString;
Begin { Get_bsDateIn }
  Result := FEntSysObj.BatchSerial.bsDateIn;
End; { Get_bsDateIn }

procedure TCOMBatchSerial.Set_bsDateIn(const Value: WideString);
Begin { Set_bsDateIn }
  FEntSysObj.BatchSerial.bsDateIn := Value;
End; { Set_bsDateIn }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsSerCost: Double;
Begin { Get_bsSerCost }
  Result := FEntSysObj.BatchSerial.bsSerCost;
End; { Get_bsSerCost }

procedure TCOMBatchSerial.Set_bsSerCost(Value: Double);
Begin { Set_bsSerCost }
  FEntSysObj.BatchSerial.bsSerCost := Value;
End; { Set_bsSerCost }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsSerSell: Double;
Begin { Get_bsSerSell }
  Result := FEntSysObj.BatchSerial.bsSerSell;
End; { Get_bsSerSell }

procedure TCOMBatchSerial.Set_bsSerSell(Value: Double);
Begin { Set_bsSerSell }
  FEntSysObj.BatchSerial.bsSerSell := Value;
End; { Set_bsSerSell }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsStkFolio: Integer;
Begin { Get_bsStkFolio }
  Result := FEntSysObj.BatchSerial.bsStkFolio;
End; { Get_bsStkFolio }

procedure TCOMBatchSerial.Set_bsStkFolio(Value: Integer);
Begin { Set_bsStkFolio }
  FEntSysObj.BatchSerial.bsStkFolio := Value;
End; { Set_bsStkFolio }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsDateOut: WideString;
Begin { Get_bsDateOut }
  Result := FEntSysObj.BatchSerial.bsDateOut;
End; { Get_bsDateOut }

procedure TCOMBatchSerial.Set_bsDateOut(const Value: WideString);
Begin { Set_bsDateOut }
  FEntSysObj.BatchSerial.bsDateOut := Value;
End; { Set_bsDateOut }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsSoldLine: Integer;
Begin { Get_bsSoldLine }
  Result := FEntSysObj.BatchSerial.bsSoldLine;
End; { Get_bsSoldLine }

procedure TCOMBatchSerial.Set_bsSoldLine(Value: Integer);
Begin { Set_bsSoldLine }
  FEntSysObj.BatchSerial.bsSoldLine := Value;
End; { Set_bsSoldLine }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsCurCost: TCurrencyType;
Begin { Get_bsCurCost }
  Result := FEntSysObj.BatchSerial.bsCurCost;
End; { Get_bsCurCost }

procedure TCOMBatchSerial.Set_bsCurCost(Value: TCurrencyType);
Begin { Set_bsCurCost }
  FEntSysObj.BatchSerial.bsCurCost := Value;
End; { Set_bsCurCost }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsCurSell: TCurrencyType;
Begin { Get_bsCurSell }
  Result := FEntSysObj.BatchSerial.bsCurSell;
End; { Get_bsCurSell }

procedure TCOMBatchSerial.Set_bsCurSell(Value: TCurrencyType);
Begin { Set_bsCurSell }
  FEntSysObj.BatchSerial.bsCurSell := Value;
End; { Set_bsCurSell }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsBuyLine: Integer;
Begin { Get_bsBuyLine }
  Result := FEntSysObj.BatchSerial.bsBuyLine;
End; { Get_bsBuyLine }

procedure TCOMBatchSerial.Set_bsBuyLine(Value: Integer);
Begin { Set_bsBuyLine }
  FEntSysObj.BatchSerial.bsBuyLine := Value;
End; { Set_bsBuyLine }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsBatchRec: WordBool;
Begin { Get_bsBatchRec }
  Result := FEntSysObj.BatchSerial.bsBatchRec;
End; { Get_bsBatchRec }

procedure TCOMBatchSerial.Set_bsBatchRec(Value: WordBool);
Begin { Set_bsBatchRec }
  FEntSysObj.BatchSerial.bsBatchRec := Value;
End; { Set_bsBatchRec }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsBuyQty: Double;
Begin { Get_bsBuyQty }
  Result := FEntSysObj.BatchSerial.bsBuyQty;
End; { Get_bsBuyQty }

procedure TCOMBatchSerial.Set_bsBuyQty(Value: Double);
Begin { Set_bsBuyQty }
  FEntSysObj.BatchSerial.bsBuyQty := Value;
End; { Set_bsBuyQty }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsQtyUsed: Double;
Begin { Get_bsQtyUsed }
  Result := FEntSysObj.BatchSerial.bsQtyUsed;
End; { Get_bsQtyUsed }

procedure TCOMBatchSerial.Set_bsQtyUsed(Value: Double);
Begin { Set_bsQtyUsed }
  FEntSysObj.BatchSerial.bsQtyUsed := Value;
End; { Set_bsQtyUsed }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsBatchChild: WordBool;
Begin { Get_bsBatchChild }
  Result := FEntSysObj.BatchSerial.bsBatchChild;
End; { Get_bsBatchChild }

procedure TCOMBatchSerial.Set_bsBatchChild(Value: WordBool);
Begin { Set_bsBatchChild }
  FEntSysObj.BatchSerial.bsBatchChild := Value;
End; { Set_bsBatchChild }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsInMLoc: WideString;
Begin { Get_bsInMLoc }
  Result := FEntSysObj.BatchSerial.bsInMLoc;
End; { Get_bsInMLoc }

procedure TCOMBatchSerial.Set_bsInMLoc(const Value: WideString);
Begin { Set_bsInMLoc }
  FEntSysObj.BatchSerial.bsInMLoc := Value;
End; { Set_bsInMLoc }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsOutMLoc: WideString;
Begin { Get_bsOutMLoc }
  Result := FEntSysObj.BatchSerial.bsOutMLoc;
End; { Get_bsOutMLoc }

procedure TCOMBatchSerial.Set_bsOutMLoc(const Value: WideString);
Begin { Set_bsOutMLoc }
  FEntSysObj.BatchSerial.bsOutMLoc := Value;
End; { Set_bsOutMLoc }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsCompanyRate: Double;
Begin { Get_bsCompanyRate }
  Result := FEntSysObj.BatchSerial.bsCompanyRate;
End; { Get_bsCompanyRate }

procedure TCOMBatchSerial.Set_bsCompanyRate(Value: Double);
Begin { Set_bsCompanyRate }
  FEntSysObj.BatchSerial.bsCompanyRate := Value;
End; { Set_bsCompanyRate }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsDailyRate: Double;
Begin { Get_bsDailyRate }
  Result := FEntSysObj.BatchSerial.bsDailyRate;
End; { Get_bsDailyRate }

procedure TCOMBatchSerial.Set_bsDailyRate(Value: Double);
Begin { Set_bsDailyRate }
  FEntSysObj.BatchSerial.bsDailyRate := Value;
End; { Set_bsDailyRate }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsInOrdDoc: WideString;
Begin { Get_bsInOrdDoc }
  Result := FEntSysObj.BatchSerial.bsInOrdDoc;
End; { Get_bsInOrdDoc }

procedure TCOMBatchSerial.Set_bsInOrdDoc(Const Value: WideString);
Begin { Set_bsInOrdDoc }
  FEntSysObj.BatchSerial.bsInOrdDoc := Value;
End; { Set_bsInOrdDoc }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsOutOrdDoc: WideString;
Begin { Get_bsOutOrdDoc }
  Result := FEntSysObj.BatchSerial.bsOutOrdDoc;
End; { Get_bsOutOrdDoc }

procedure TCOMBatchSerial.Set_bsOutOrdDoc(const Value: WideString);
Begin { Set_bsOutOrdDoc }
  FEntSysObj.BatchSerial.bsOutOrdDoc := Value;
End; { Set_bsOutOrdDoc }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsInOrdLine: Integer;
Begin { Get_bsInOrdLine }
  Result := FEntSysObj.BatchSerial.bsInOrdLine;
End; { Get_bsInOrdLine }

procedure TCOMBatchSerial.Set_bsInOrdLine(Value: Integer);
Begin { Set_bsInOrdLine }
  FEntSysObj.BatchSerial.bsInOrdLine := Value;
End; { Set_bsInOrdLine }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsOutOrdLine: Integer;
Begin { Get_bsOutOrdLine }
  Result := FEntSysObj.BatchSerial.bsOutOrdLine;
End; { Get_bsOutOrdLine }

procedure TCOMBatchSerial.Set_bsOutOrdLine(Value: Integer);
Begin { Set_bsOutOrdLine }
  FEntSysObj.BatchSerial.bsOutOrdLine := Value;
End; { Set_bsOutOrdLine }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsNLineCount: Integer;
Begin { Get_bsNLineCount }
  Result := FEntSysObj.BatchSerial.bsNLineCount;
End; { Get_bsNLineCount }

procedure TCOMBatchSerial.Set_bsNLineCount(Value: Integer);
Begin { Set_bsNLineCount }
  FEntSysObj.BatchSerial.bsNLineCount := Value;
End; { Set_bsNLineCount }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsNoteFolio: Integer;
Begin { Get_bsNoteFolio }
  Result := FEntSysObj.BatchSerial.bsNoteFolio;
End; { Get_bsNoteFolio }

procedure TCOMBatchSerial.Set_bsNoteFolio(Value: Integer);
Begin { Set_bsNoteFolio }
  FEntSysObj.BatchSerial.bsNoteFolio := Value;
End; { Set_bsNoteFolio }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsDateUseX: WideString;
Begin { Get_bsDateUseX }
  Result := FEntSysObj.BatchSerial.bsDateUseX;
End; { Get_bsDateUseX }

procedure TCOMBatchSerial.Set_bsDateUseX(const Value: WideString);
Begin { Set_bsDateUseX }
  FEntSysObj.BatchSerial.bsDateUseX := Value;
End; { Set_bsDateUseX }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsSUseORate: SmallInt;
Begin { Get_bsSUseORate }
  Result := FEntSysObj.BatchSerial.bsSUseORate;
End; { Get_bsSUseORate }

procedure TCOMBatchSerial.Set_bsSUseORate(Value: SmallInt);
Begin { Set_bsSUseORate }
  FEntSysObj.BatchSerial.bsSUseORate := Value;
End; { Set_bsSUseORate }

{-----------------------------------------}

function TCOMBatchSerial.Get_bsBinCode: WideString;
Begin { Get_bsBinCode }
  Result := TAbsBatchSerial2(FEntSysObj.BatchSerial).bsBinCode;
End; { Get_bsBinCode }

procedure TCOMBatchSerial.Set_bsBinCode(Const Value: WideString);
Begin { Set_bsBinCode }
  TAbsBatchSerial2(FEntSysObj.BatchSerial).bsBinCode := Value;
End; { Set_bsBinCode }

//------------------------------

function TCOMBatchSerial.Get_bsReturned: WordBool;
begin
  Result := TAbsBatchSerial3(FEntSysObj.BatchSerial).bsReturned;
end;
procedure TCOMBatchSerial.Set_bsReturned(Value: WordBool);
begin
  TAbsBatchSerial3(FEntSysObj.BatchSerial).bsReturned := Value;
end;

//------------------------------

function TCOMBatchSerial.Get_bsReturnOurRef: WideString;
begin
  Result := TAbsBatchSerial3(FEntSysObj.BatchSerial).bsReturnOurRef;
end;
procedure TCOMBatchSerial.Set_bsReturnOurRef(const Value: WideString);
begin
  TAbsBatchSerial3(FEntSysObj.BatchSerial).bsReturnOurRef := Value;
end;

//------------------------------

function TCOMBatchSerial.Get_bsBatchReturnedQty: Double;
begin
  Result := TAbsBatchSerial3(FEntSysObj.BatchSerial).bsBatchReturnedQty;
end;
procedure TCOMBatchSerial.Set_bsBatchReturnedQty(Value: Double);
begin
  TAbsBatchSerial3(FEntSysObj.BatchSerial).bsBatchReturnedQty := Value;
end;

//------------------------------

function TCOMBatchSerial.Get_bsReturnLineNo: Integer;
begin
  Result := TAbsBatchSerial3(FEntSysObj.BatchSerial).bsReturnLineNo;
end;
procedure TCOMBatchSerial.Set_bsReturnLineNo(Value: Integer);
begin
  TAbsBatchSerial3(FEntSysObj.BatchSerial).bsReturnLineNo := Value;
end;

//------------------------------

end.

