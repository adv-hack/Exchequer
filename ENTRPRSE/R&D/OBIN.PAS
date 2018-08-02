unit oBin;

{$I DEFOVR.INC}

Interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU, VarRec2U, oCcyTri;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TMultiBin = Class(TAbsMultiBin2)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..33] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : brBinRecType;

    FCcyTri    : TAbsCurrencyTriangulation;
  Protected
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function GetBinCode : cuStr10; OverRide;
    Procedure SetBinCode (Value : cuStr10); OverRide;
    Function  GetStockFolio : longint; OverRide;
    Procedure SetStockFolio (Value : longint); OverRide;
    Function  GetPickingPriority : cuStr10; OverRide;
    Procedure SetPickingPriority (Value : cuStr10); OverRide;
    Function  GetUseByDate : cuStr10; OverRide;
    Procedure SetUseByDate (Value : cuStr10); OverRide;
    Function  GetUnitOfMeasurement : cuStr10; OverRide;
    Procedure SetUnitOfMeasurement (Value : cuStr10); OverRide;
    Function  GetAutoPickMode : Smallint; OverRide;
    Procedure SetAutoPickMode (Value : Smallint); OverRide;
    Function  GetTagNo : Smallint; OverRide;
    Procedure SetTagNo (Value : Smallint); OverRide;
    Function  GetQty : Double; OverRide;
    Procedure SetQty (Value : Double); OverRide;
    Function  GetQtyUsed : Double; OverRide;
    Procedure SetQtyUsed (Value : Double); OverRide;
    Function  GetCapacity : Double; OverRide;
    Procedure SetCapacity (Value : Double); OverRide;
    Function  GetCostPrice : Double; OverRide;
    Procedure SetCostPrice (Value : Double); OverRide;
    Function  GetCostPriceCurrency : Smallint; OverRide;
    Procedure SetCostPriceCurrency (Value : Smallint); OverRide;
    Function  GetSalesPrice : Double; OverRide;
    Procedure SetSalesPrice (Value : Double); OverRide;
    Function  GetSalesPriceCurrency : Smallint; OverRide;
    Procedure SetSalesPriceCurrency (Value : Smallint); OverRide;
    Function GetInDate : cuStr8; OverRide;
    Procedure SetInDate (Value : cuStr8); OverRide;
    Function GetInOrderRef : cuStr10; OverRide;
    Procedure SetInOrderRef (Value : cuStr10); OverRide;
    Function GetInOrderLine : longint; OverRide;
    Procedure SetInOrderLine (Value : longint); OverRide;
    Function GetInDocRef : cuStr10; OverRide;
    Procedure SetInDocRef (Value : cuStr10); OverRide;
    Function GetInDocLine : longint; OverRide;
    Procedure SetInDocLine (Value : longint); OverRide;
    Function GetInLocation : cuStr10; OverRide;
    Procedure SetInLocation (Value : cuStr10); OverRide;
    Function GetUsedRec : Boolean; OverRide;
    Procedure SetUsedRec (Value : Boolean); OverRide;
    Function GetSold : Boolean; OverRide;
    Procedure SetSold (Value : Boolean); OverRide;
    Function GetOutDate : cuStr8; OverRide;
    Procedure SetOutDate (Value : cuStr8); OverRide;
    Function GetOutOrderRef : cuStr10; OverRide;
    Procedure SetOutOrderRef (Value : cuStr10); OverRide;
    Function GetOutOrderLine : longint; OverRide;
    Procedure SetOutOrderLine (Value : longint); OverRide;
    Function GetOutDocRef : cuStr10; OverRide;
    Procedure SetOutDocRef (Value : cuStr10); OverRide;
    Function GetOutDocLine : longint; OverRide;
    Procedure SetOutDocLine (Value : longint); OverRide;
    Function GetOutLocation : cuStr10; OverRide;
    Procedure SetOutLocation (Value : cuStr10); OverRide;
    Function GetCompanyRate : Double; OverRide;
    Procedure SetCompanyRate (Value : Double); OverRide;
    Function GetDailyRate : Double; OverRide;
    Procedure SetDailyRate (Value : Double); OverRide;
    Function GetUseORate : Byte; OverRide;
    Procedure SetUseORate (Value : Byte); OverRide;
    Function GetTriangulation : TAbsCurrencyTriangulation; OverRide;

    // TAbsMultiBin2
    Function GetReturned : Boolean; OverRide;
    Procedure SetReturned (Value : Boolean); OverRide;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const BinRec           : MLocRec);
  End; { TMultiBin }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  EmplRecErrStr = 'Bin ';


//=========================================================================

Constructor TMultiBin.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  FillChar (DataRec, SizeOf (DataRec), #0);
  FillChar (OrigRec, SizeOf (OrigRec), #0);

  FCcyTri := TCurrencyTriangulation.Create(hEntSys);
End;

//------------------------------

Destructor TMultiBin.Destroy;
Begin { Destroy }
  FreeAndNIL(FCcyTri);
  EntSys := NIL;

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TMultiBin.Assign (Const WinId, HandlerId : LongInt;
                            Const BinRec           : MLocRec);
Var
  I : SmallInt;
Begin { Assign }
  { Set Security Access to Record }
  If (WinId = wiSerialBatch) Then
    RecAccess:=ReadOnly
  Else
    RecAccess:=NotAvailable;

  { Load fields from ExLocal }
  FillChar (DataRec, SizeOf (DataRec), #0);
  RecChanged := False;
  If (RecAccess <> NotAvailable) Then Begin
    If (BinRec.RecPfix = BRRecCode) And (BinRec.SubType = MSernSub) Then
      DataRec := BinRec.brBinRec
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


    //
    // IMPORTANT NOTE: When enabling fields check the Set method for
    //                 the field to ensure the validation is correct
    //

    Case ((WinId * 1000) + HandlerId) Of
      103100002  {BrBincode Entry}
           :   Begin
                 PropAccess[01] := paReadWrite; {brBincode}
               end;

    end; {Case..}

    // Setup Triangulation sub-object
    TCurrencyTriangulation(FCcyTri).Assign (WinId, HandlerId, DataRec.brSerTriR);
  End; { If }

End; { Assign }

//-------------------------------------------------------------------------

Function TMultiBin.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

//-------------------------------------------------------------------------

Function TMultiBin.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

//-------------------------------------------------------------------------

function TMultiBin.GetBinCode: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.brBinCode1
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'BinCode');
end;

procedure TMultiBin.SetBinCode(Value: cuStr10);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[1] = paReadWrite) Then Begin
    If (DataRec.brBinCode1 <> Value) Then Begin
      DataRec.brBinCode1 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'BinCode');
end;

//------------------------------

function TMultiBin.GetStockFolio: longint;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brStkFolio
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'StockFolio');
end;

procedure TMultiBin.SetStockFolio(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[2] = paReadWrite) Then Begin
    If (DataRec.brStkFolio <> Value) Then Begin
      DataRec.brStkFolio := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'StockFolio');
end;

//------------------------------

function TMultiBin.GetPickingPriority: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.brPriority
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'PickingPriority');
end;

procedure TMultiBin.SetPickingPriority(Value: cuStr10);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[3] = paReadWrite) Then Begin
    If (DataRec.brPriority <> Value) Then Begin
      DataRec.brPriority := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'PickingPriority');
end;

//------------------------------

function TMultiBin.GetUseByDate: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.brDateUseX
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'UseByDate');
end;

procedure TMultiBin.SetUseByDate(Value: cuStr10);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[4] = paReadWrite) Then Begin
    If (DataRec.brDateUseX <> Value) Then Begin
      DataRec.brDateUseX := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'UseByDate');
end;

//------------------------------

function TMultiBin.GetUnitOfMeasurement: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.brUOM
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'UnitOfMeasurement');
end;

procedure TMultiBin.SetUnitOfMeasurement(Value: cuStr10);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[5] = paReadWrite) Then Begin
    If (DataRec.brUOM <> Value) Then Begin
      DataRec.brUOM := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'UnitOfMeasurement');
end;

//------------------------------

function TMultiBin.GetAutoPickMode: Smallint;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brHoldFlg
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'AutoPickMode');
end;

procedure TMultiBin.SetAutoPickMode(Value: Smallint);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[6] = paReadWrite) Then Begin
    If (DataRec.brHoldFlg <> Value) Then Begin
      DataRec.brHoldFlg := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'AutoPickMode');
end;

//------------------------------

function TMultiBin.GetTagNo: Smallint;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brTagNo
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'TagNo');
end;

procedure TMultiBin.SetTagNo(Value: Smallint);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[7] = paReadWrite) Then Begin
    If (DataRec.brTagNo <> Value) Then Begin
      DataRec.brTagNo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'TagNo');
end;

//------------------------------

function TMultiBin.GetQty: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brBuyQty
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'Qty');
end;

procedure TMultiBin.SetQty(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[8] = paReadWrite) Then Begin
    If (DataRec.brBuyQty <> Value) Then Begin
      DataRec.brBuyQty := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'Qty');
end;

//------------------------------

function TMultiBin.GetQtyUsed: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brQtyUsed
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'QtyUsed');
end;

procedure TMultiBin.SetQtyUsed(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[9] = paReadWrite) Then Begin
    If (DataRec.brQtyUsed <> Value) Then Begin
      DataRec.brQtyUsed := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'QtyUsed');
end;

//------------------------------

function TMultiBin.GetCapacity: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brBinCap
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'Capacity');
end;

procedure TMultiBin.SetCapacity(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[10] = paReadWrite) Then Begin
    If (DataRec.brBinCap <> Value) Then Begin
      DataRec.brBinCap := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'Capacity');
end;

//------------------------------

function TMultiBin.GetCostPrice: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brBinCost
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'CostPrice');
end;

procedure TMultiBin.SetCostPrice(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[11] = paReadWrite) Then Begin
    If (DataRec.brBinCost <> Value) Then Begin
      DataRec.brBinCost := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'CostPrice');
end;

//------------------------------

function TMultiBin.GetCostPriceCurrency: Smallint;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brCurCost
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'CostPriceCurrency');
end;

procedure TMultiBin.SetCostPriceCurrency(Value: Smallint);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[12] = paReadWrite) Then Begin
    If (DataRec.brCurCost <> Value) Then Begin
      DataRec.brCurCost := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'CostPriceCurrency');
end;

//------------------------------

function TMultiBin.GetSalesPrice: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brBinSell
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'SalesPrice');
end;

procedure TMultiBin.SetSalesPrice(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[13] = paReadWrite) Then Begin
    If (DataRec.brBinSell <> Value) Then Begin
      DataRec.brBinSell := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'SalesPrice');
end;

//------------------------------

function TMultiBin.GetSalesPriceCurrency: Smallint;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brCurSell
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'SalesPriceCurrency');
end;

procedure TMultiBin.SetSalesPriceCurrency(Value: Smallint);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[14] = paReadWrite) Then Begin
    If (DataRec.brCurSell <> Value) Then Begin
      DataRec.brCurSell := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'SalesPriceCurrency');
end;

//------------------------------

function TMultiBin.GetInDate: cuStr8;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.brDateIn
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'InDate');
end;

procedure TMultiBin.SetInDate(Value: cuStr8);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[15] = paReadWrite) Then Begin
    If (DataRec.brDateIn <> Value) Then Begin
      DataRec.brDateIn := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'InDate');
end;

//------------------------------

function TMultiBin.GetInOrderRef: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.brInOrdDoc
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'InOrderRef');
end;

procedure TMultiBin.SetInOrderRef(Value: cuStr10);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[16] = paReadWrite) Then Begin
    If (DataRec.brInOrdDoc <> Value) Then Begin
      DataRec.brInOrdDoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'InOrderRef');
end;

//------------------------------

function TMultiBin.GetInOrderLine: longint;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brInOrdLine
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'InOrderLine');
end;

procedure TMultiBin.SetInOrderLine(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[17] = paReadWrite) Then Begin
    If (DataRec.brInOrdLine <> Value) Then Begin
      DataRec.brInOrdLine := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'InOrderLine');
end;

//------------------------------

function TMultiBin.GetInDocRef: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.brInDoc
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'InDocRef');
end;

procedure TMultiBin.SetInDocRef(Value: cuStr10);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[18] = paReadWrite) Then Begin
    If (DataRec.brInDoc <> Value) Then Begin
      DataRec.brInDoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'InDocRef');
end;

//------------------------------

function TMultiBin.GetInDocLine: longint;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brBuyLine
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'InDocLine');
end;

procedure TMultiBin.SetInDocLine(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[19] = paReadWrite) Then Begin
    If (DataRec.brBuyLine <> Value) Then Begin
      DataRec.brBuyLine := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'InDocLine');
end;

//------------------------------

function TMultiBin.GetInLocation: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.brInMLoc
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'InLocation');
end;

procedure TMultiBin.SetInLocation(Value: cuStr10);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[20] = paReadWrite) Then Begin
    If (DataRec.brInMLoc <> Value) Then Begin
      DataRec.brInMLoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'InLocation');
end;

//------------------------------

function TMultiBin.GetUsedRec: Boolean;
begin
  Result := False;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brBatchChild
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'UsedRec');
end;

procedure TMultiBin.SetUsedRec(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[21] = paReadWrite) Then Begin
    If (DataRec.brBatchChild <> Value) Then Begin
      DataRec.brBatchChild := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'UsedRec');
end;

//------------------------------

function TMultiBin.GetSold: Boolean;
begin
  Result := False;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brSold
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'Sold');
end;

procedure TMultiBin.SetSold(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[22] = paReadWrite) Then Begin
    If (DataRec.brSold <> Value) Then Begin
      DataRec.brSold := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'Sold');
end;

//------------------------------

function TMultiBin.GetOutDate: cuStr8;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.brDateOut
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'OutDate');
end;

procedure TMultiBin.SetOutDate(Value: cuStr8);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[23] = paReadWrite) Then Begin
    If (DataRec.brDateOut <> Value) Then Begin
      DataRec.brDateOut := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'OutDate');
end;

//------------------------------

function TMultiBin.GetOutOrderRef: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.brOutOrdDoc
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'OutOrderRef');
end;

procedure TMultiBin.SetOutOrderRef(Value: cuStr10);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[24] = paReadWrite) Then Begin
    If (DataRec.brOutOrdDoc <> Value) Then Begin
      DataRec.brOutOrdDoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'OutOrderRef');
end;

//------------------------------

function TMultiBin.GetOutOrderLine: longint;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brOutOrdLine
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'OutOrderLine');
end;

procedure TMultiBin.SetOutOrderLine(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[25] = paReadWrite) Then Begin
    If (DataRec.brOutOrdLine <> Value) Then Begin
      DataRec.brOutOrdLine := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'OutOrderLine');
end;

//------------------------------

function TMultiBin.GetOutDocRef: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.brOutDoc
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'OutDocRef');
end;

procedure TMultiBin.SetOutDocRef(Value: cuStr10);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[26] = paReadWrite) Then Begin
    If (DataRec.brOutDoc <> Value) Then Begin
      DataRec.brOutDoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'OutDocRef');
end;

//------------------------------

function TMultiBin.GetOutDocLine: longint;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brSoldLine
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'OutDocLine');
end;

procedure TMultiBin.SetOutDocLine(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[27] = paReadWrite) Then Begin
    If (DataRec.brSoldLine <> Value) Then Begin
      DataRec.brSoldLine := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'OutDocLine');
end;

//------------------------------

function TMultiBin.GetOutLocation: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.brOutMLoc
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'OutLocation');
end;

procedure TMultiBin.SetOutLocation(Value: cuStr10);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[28] = paReadWrite) Then Begin
    If (DataRec.brOutMLoc <> Value) Then Begin
      DataRec.brOutMLoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'OutLocation');
end;

//------------------------------

function TMultiBin.GetCompanyRate: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brSerCRates[BOff]
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'CompanyRate');
end;

procedure TMultiBin.SetCompanyRate(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[29] = paReadWrite) Then Begin
    If (DataRec.brSerCRates[BOff] <> Value) Then Begin
      DataRec.brSerCRates[BOff] := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'CompanyRate');
end;

//------------------------------

function TMultiBin.GetDailyRate: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brSerCRates[BOn]
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'DailyRate');
end;

procedure TMultiBin.SetDailyRate(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[30] = paReadWrite) Then Begin
    If (DataRec.brSerCRates[BOn] <> Value) Then Begin
      DataRec.brSerCRates[BOn] := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'DailyRate');
end;

//------------------------------

function TMultiBin.GetUseORate: Byte;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.brSUseORate
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'UseORate');
end;

procedure TMultiBin.SetUseORate(Value: Byte);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[31] = paReadWrite) Then Begin
    If (DataRec.brSUseORate <> Value) Then Begin
      DataRec.brSUseORate := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'UseORate');
end;

//------------------------------

function TMultiBin.GetTriangulation : TAbsCurrencyTriangulation;
begin
  Result := nil;
   If (RecAccess <> NotAvailable) Then
    Result := FCcyTri
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'Triangulation');
end;

//------------------------------

function TMultiBin.GetReturned: Boolean;
begin
  Result := False;
   {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.brReturnBin
    Else
      EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'brReturned');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('brReturned');
end;
procedure TMultiBin.SetReturned(Value: Boolean);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsMultiBin2.brReturned');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('brReturned');
end;

//-------------------------------------------------------------------------

end.
