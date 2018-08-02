unit oTeleLin;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU, VarRec2U;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TTelesalesLine = Class(TAbsTelesalesLine)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..30] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : CuStkType;
  Protected
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function GetCustCode : cuStr6; Override;
    Procedure SetCustCode (Value : cuStr6); Override;
    Function GetStockCode : cuStr16; Override;
    Procedure SetStockCode (Value : cuStr16); Override;
    Function GetRepeatQty : Double; Override;
    Procedure SetRepeatQty (Value : Double); Override;
    Function GetLastSaleDate : cuLongDate; Override;
    Procedure SetLastSaleDate (Value : cuLongDate); Override;
    Function GetDisplayOrder : LongInt; Override;
    Procedure SetDisplayOrder (Value : LongInt); Override;
    Function GetLastPrice : Double; Override;
    Procedure SetLastPrice (Value : Double); Override;
    Function GetLastPriceCurr : Byte; Override;
    Procedure SetLastPriceCurr (Value : Byte); Override;
    Function GetJobCode : cuStr10; Override;
    Procedure SetJobCode (Value : cuStr10); Override;
    Function GetJobAnal : cuStr10; Override;
    Procedure SetJobAnal (Value : cuStr10); Override;
    Function GetLocation : cuStr3; Override;
    Procedure SetLocation (Value : cuStr3); Override;
    Function GetGLCode : LongInt; Override;
    Procedure SetGLCode (Value : LongInt); Override;
    Function GetCostCentre : cuStr3; Override;
    Procedure SetCostCentre (Value : cuStr3); Override;
    Function GetDepartment : cuStr3; Override;
    Procedure SetDepartment (Value : cuStr3); Override;
    Function GetQty : Double; Override;
    Procedure SetQty (Value : Double); Override;
    Function GetNetValue : Double; Override;
    Procedure SetNetValue (Value : Double); Override;
    Function GetDiscount : Double; Override;
    Procedure SetDiscount (Value : Double); Override;
    Function GetVATCode : Char; Override;
    Procedure SetVATCode (Value : Char); Override;
    Function GetCost : Double; Override;
    Procedure SetCost (Value : Double); Override;
    Function  GetDescr(Index : cuDescIndex) : cuStr35; Override;
    Procedure SetDescr(Index : cuDescIndex; Value : cuStr35); Override;
    Function GetVATAmount : Double; Override;
    Procedure SetVATAmount (Value : Double); Override;
    Function GetPriceByPack : Boolean; Override;
    Procedure SetPriceByPack (Value : Boolean); Override;
    Function GetQtyInPack : Double; Override;
    Procedure SetQtyInPack (Value : Double); Override;
    Function GetQtyMul : Double; Override;
    Procedure SetQtyMul (Value : Double); Override;
    Function GetDiscFlag : Char; Override;
    Procedure SetDiscFlag (Value : Char); Override;
    Function GetEntered : Boolean; Override;
    Procedure SetEntered (Value : Boolean); Override;
    Function GetCalcPack : Boolean; Override;
    Procedure SetCalcPack (Value : Boolean); Override;
    Function GetShowAsPacks : Boolean; Override;
    Procedure SetShowAsPacks (Value : Boolean); Override;
    Function GetLineType : cuLineTIndex; Override;
    Procedure SetLineType (Value : cuLineTIndex); Override;
    Function GetPriceMultiplier : Double; Override;
    Procedure SetPriceMultiplier (Value : Double); Override;
    Function GetInclusiveVATCode : Char; Override;
    Procedure SetInclusiveVATCode (Value : Char); Override;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const TeleRec          : MLocRec);
  End; { TTelesalesLine }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  ObjErrStr = 'Telesales Line ';

//=========================================================================

Constructor TTelesalesLine.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  FillChar (DataRec, SizeOf (DataRec), #0);
  FillChar (OrigRec, SizeOf (OrigRec), #0);
End;

//------------------------------

Destructor TTelesalesLine.Destroy;
Begin { Destroy }
  EntSys := NIL;

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TTelesalesLine.Assign (Const WinId, HandlerId : LongInt;
                                 Const TeleRec          : MLocRec);
Var
  I : SmallInt;
Begin { Assign }
  { Set Security Access to Record }
  If (WinId = wiAccount) Or (WinId = wiTransaction) Or (WinId = wiTransLine) Then
    RecAccess:=ReadOnly
  Else
    RecAccess:=NotAvailable;

  { Load fields from ExLocal }
  FillChar (DataRec, SizeOf (DataRec), #0);
  RecChanged := False;
  If (RecAccess <> NotAvailable) Then Begin
    If (TeleRec.RecPfix = MatchTCode) And (TeleRec.SubType = MatchSCode) Then
      DataRec := TeleRec.CuStkRec
    Else
      RecAccess := NotAvailable;
  End; { If }
  OrigRec := DataRec;

  { Adjust Security Access for field by Window and Event }
  If (RecAccess <> NotAvailable) Then Begin
    { Set Default Security options }
    For I := Low(PropAccess) To High(PropAccess) Do
      If (RecAccess = ReadOnly) Then
        PropAccess[I] := paReadOnly
      Else
        PropAccess[I] := paReadWrite;

    { Disable additional functions }
    For I := Low(FuncAccess) To High(FuncAccess) Do
      FuncAccess[I] := pfDisabled;

    { Modify default for specific cases }
    Case ((WinId * 1000) + HandlerId) Of

      // Enable Writeable fields here for each hook point

      104000070,
      104000071 : Begin
                    PropAccess[15] := paReadWrite;    { Unit Price/ NetValue }
                  end;

    End; { Case ((WinId * 1000) + HandlerId) }
  End; { If }

End; { Assign }

//-------------------------------------------------------------------------

Function TTelesalesLine.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

//-------------------------------------------------------------------------

Function TTelesalesLine.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

//-------------------------------------------------------------------------

function TTelesalesLine.GetCustCode: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csCustCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CustCode');
end;

procedure TTelesalesLine.SetCustCode(Value: cuStr6);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telCustCode');
end;

//------------------------------

function TTelesalesLine.GetStockCode: cuStr16;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csStockCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'StockCode');
end;

procedure TTelesalesLine.SetStockCode(Value: cuStr16);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telStockCode');
end;

//------------------------------

function TTelesalesLine.GetRepeatQty: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csSOQty
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'RepeatQty');
end;

procedure TTelesalesLine.SetRepeatQty(Value: Double);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telRepeatQty');
end;

//------------------------------

function TTelesalesLine.GetLastSaleDate: cuLongDate;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csLastDate
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'LastSaleDate');
end;

procedure TTelesalesLine.SetLastSaleDate(Value: cuLongDate);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telLastSaleDate');
end;

//------------------------------

function TTelesalesLine.GetDisplayOrder: LongInt;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csLineNo
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DisplayOrder');
end;

procedure TTelesalesLine.SetDisplayOrder(Value: Integer);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telDisplayOrder');
end;

//------------------------------

function TTelesalesLine.GetLastPrice: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csLastPrice
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'LastPrice');
end;

procedure TTelesalesLine.SetLastPrice(Value: Double);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telLastPrice');
end;

//------------------------------

function TTelesalesLine.GetLastPriceCurr: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csLPCurr
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'LastPriceCurr');
end;

procedure TTelesalesLine.SetLastPriceCurr(Value: Byte);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telLastPriceCurr');
end;

//------------------------------

function TTelesalesLine.GetJobCode: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csJobCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'JobCode');
end;

procedure TTelesalesLine.SetJobCode(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telJobCode');
end;

//------------------------------

function TTelesalesLine.GetJobAnal: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csJACode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'JobAnal');
end;

procedure TTelesalesLine.SetJobAnal(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telJobAnal');
end;

//------------------------------

function TTelesalesLine.GetLocation: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csLocCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Location');
end;

procedure TTelesalesLine.SetLocation(Value: cuStr3);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telLocation');
end;

//------------------------------

function TTelesalesLine.GetGLCode: LongInt;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csNomCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'GLCode');
end;

procedure TTelesalesLine.SetGLCode(Value: Integer);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telGLCode');
end;

//------------------------------

function TTelesalesLine.GetCostCentre: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csCCDep[BOn]
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CostCentre');
end;

procedure TTelesalesLine.SetCostCentre(Value: cuStr3);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telCostCentre');
end;

//------------------------------

function TTelesalesLine.GetDepartment: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csCCDep[BOff]
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Department');
end;

procedure TTelesalesLine.SetDepartment(Value: cuStr3);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telDepartment');
end;

//------------------------------

function TTelesalesLine.GetQty: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csQty
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Qty');
end;

procedure TTelesalesLine.SetQty(Value: Double);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telQty');
end;

//------------------------------

function TTelesalesLine.GetNetValue: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csNetValue
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'NetValue');
end;

procedure TTelesalesLine.SetNetValue(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[15] = paReadWrite) Then Begin
    If (DataRec.csNetValue <> Value) Then Begin
      DataRec.csNetValue := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, ObjErrStr + 'NetValue');
end;

//------------------------------

function TTelesalesLine.GetDiscount: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csDiscount
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Discount');
end;

procedure TTelesalesLine.SetDiscount(Value: Double);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telDiscount');
end;

//------------------------------

function TTelesalesLine.GetVATCode: Char;
begin
  Result := #0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csVATCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'VATCode');
end;

procedure TTelesalesLine.SetVATCode(Value: Char);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telVATCode');
end;

//------------------------------

function TTelesalesLine.GetCost: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csCost
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Cost');
end;

procedure TTelesalesLine.SetCost(Value: Double);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telCost');
end;

//------------------------------

function TTelesalesLine.GetDescr(Index: cuDescIndex): cuStr35;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csDesc[Index]
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Descr');
end;

procedure TTelesalesLine.SetDescr(Index: cuDescIndex; Value: cuStr35);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telDescr');
end;

//------------------------------

function TTelesalesLine.GetVATAmount: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csVAT
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'VATAmount');
end;

procedure TTelesalesLine.SetVATAmount(Value: Double);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telVATAmount');
end;

//------------------------------

function TTelesalesLine.GetPriceByPack: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csPrxPack
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'PriceByPack');
end;

procedure TTelesalesLine.SetPriceByPack(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telPriceByPack');
end;

//------------------------------

function TTelesalesLine.GetQtyInPack: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csQtyPack
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'QtyInPack');
end;

procedure TTelesalesLine.SetQtyInPack(Value: Double);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telQtyInPack');
end;

//------------------------------

function TTelesalesLine.GetQtyMul: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csQtyMul
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'QtyMul');
end;

procedure TTelesalesLine.SetQtyMul(Value: Double);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telQtyMul');
end;

//------------------------------

function TTelesalesLine.GetDiscFlag: Char;
begin
  Result := #0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csDiscCh
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DiscFlag');
end;

procedure TTelesalesLine.SetDiscFlag(Value: Char);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telDiscFlag');
end;

//------------------------------

function TTelesalesLine.GetEntered: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csEntered
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Entered');
end;

procedure TTelesalesLine.SetEntered(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telEntered');
end;

//------------------------------

function TTelesalesLine.GetCalcPack: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csUsePack
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CalcPack');
end;

procedure TTelesalesLine.SetCalcPack(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telCalcPack');
end;

//------------------------------

function TTelesalesLine.GetShowAsPacks: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csShowCase
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'ShowAsPacks');
end;

procedure TTelesalesLine.SetShowAsPacks(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telShowAsPacks');
end;

//------------------------------

function TTelesalesLine.GetLineType: cuLineTIndex;
begin
  Result := Low(cuLineTIndex);
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csLineType
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'LineType');
end;

procedure TTelesalesLine.SetLineType(Value: cuLineTIndex);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telLineType');
end;

//------------------------------

function TTelesalesLine.GetPriceMultiplier: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csPriceMulX
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'PriceMultiplier');
end;

procedure TTelesalesLine.SetPriceMultiplier(Value: Double);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telPriceMultiplier');
end;

//------------------------------

function TTelesalesLine.GetInclusiveVATCode: Char;
begin
  Result := #0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.csVATIncFlg
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'InclusiveVATCode');
end;

procedure TTelesalesLine.SetInclusiveVATCode(Value: Char);
begin
  EntSys.NotImplException ('TAbsTelesalesLine.telInclusiveVATCode');
end;

//-------------------------------------------------------------------------

end.
