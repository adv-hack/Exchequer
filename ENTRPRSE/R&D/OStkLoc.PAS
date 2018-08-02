unit OStkLoc;

{$I DEFOVR.INC}

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU, VarRec2U;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TStockLocation = Class(TAbsStockLocation)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..44] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : MStkLocType;
  Protected
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function GetStockCode : cuStr16; Override;
    Procedure SetStockCode (Value : cuStr16); Override;
    Function GetLocationCode : cuStr3; Override;
    Procedure SetLocationCode (Value : cuStr3); Override;
    Function GetQtyInStock : Double; Override;
    Procedure SetQtyInStock (Value : Double); Override;
    Function GetQtyOnOrder : Double; Override;
    Procedure SetQtyOnOrder (Value : Double); Override;
    Function GetQtyAllocated : Double; Override;
    Procedure SetQtyAllocated (Value : Double); Override;
    Function GetQtyPicked : Double; Override;
    Procedure SetQtyPicked (Value : Double); Override;
    Function GetQtyMin : Double; Override;
    Procedure SetQtyMin (Value : Double); Override;
    Function GetQtyMax : Double; Override;
    Procedure SetQtyMax (Value : Double); Override;
    Function GetQtyFreeze : Double; Override;
    Procedure SetQtyFreeze (Value : Double); Override;
    Function GetReorderQty : Double; Override;
    Procedure SetReorderQty (Value : Double); Override;
    Function GetReorderCur : cuCurrencyType; Override;
    Procedure SetReorderCur (Value : cuCurrencyType); Override;
    Function GetReorderPrice : Double; Override;
    Procedure SetReorderPrice (Value : Double); Override;
    Function GetReorderDate : cuLongDate; Override;
    Procedure SetReorderDate (Value : cuLongDate); Override;
    Function GetReorderCostCentre : cuStr3; Override;
    Procedure SetReorderCostCentre (Value : cuStr3); Override;
    Function GetReorderDepartment : cuStr3; Override;
    Procedure SetReorderDepartment (Value : cuStr3); Override;
    Function GetCostCentre : cuStr3; Override;
    Procedure SetCostCentre (Value : cuStr3); Override;
    Function GetDepartment : cuStr3; Override;
    Procedure SetDepartment (Value : cuStr3); Override;
    Function GetBinLocation : cuStr10; Override;
    Procedure SetBinLocation (Value : cuStr10); Override;
    Function GetCostPriceCur : cuCurrencyType; Override;
    Procedure SetCostPriceCur (Value : cuCurrencyType); Override;
    Function GetCostPrice : Double; Override;
    Procedure SetCostPrice (Value : Double); Override;
    Function GetBelowMinLevel : Boolean; Override;
    Procedure SetBelowMinLevel (Value : Boolean); Override;
    Function GetSuppTemp : cuStr6; Override;
    Procedure SetSuppTemp (Value : cuStr6); Override;
    Function GetSupplier : cuStr6; Override;
    Procedure SetSupplier (Value : cuStr6); Override;
    Function GetLastUsed : cuLongDate; Override;
    Procedure SetLastUsed (Value : cuLongDate); Override;
    Function GetQtyPosted : Double; Override;
    Procedure SetQtyPosted (Value : Double); Override;
    Function GetQtyStockTake : Double; Override;
    Procedure SetQtyStockTake (Value : Double); Override;
    Function GetTimeChange : cuStr6; Override;
    Procedure SetTimeChange (Value : cuStr6); Override;
    Function GetSalesGL : LongInt; Override;
    Procedure SetSalesGL (Value : LongInt); Override;
    Function GetCostOfSalesGL : LongInt; Override;
    Procedure SetCostOfSalesGL (Value : LongInt); Override;
    Function GetPandLGL : LongInt; Override;
    Procedure SetPandLGL (Value : LongInt); Override;
    Function GetBalSheetGL : LongInt; Override;
    Procedure SetBalSheetGL (Value : LongInt); Override;
    Function GetWIPGL : LongInt; Override;
    Procedure SetWIPGL (Value : LongInt); Override;
    Function  GetSaleBandsCcy (Index : cuSalesBandIndex) : cuCurrencyType; Override;
    Procedure SetSaleBandsCcy(Index : cuSalesBandIndex; Value : cuCurrencyType); Override;
    Function  GetSaleBandsPrice (Index : cuSalesBandIndex) : Real; Override;
    Procedure SetSaleBandsPrice(Index : cuSalesBandIndex; Value : Real); Override;
    Function GetQtyFree : Double; Override;
    Function GetPurchaseReturnGL : LongInt; Override;
    Procedure SetPurchaseReturnGL (Value : LongInt); Override;
    Function GetPurchaseReturnQty : Double; Override;
    Procedure SetPurchaseReturnQty (Value : Double); Override;
    Function GetManufacturerWarrantyLength : Byte; Override;
    Procedure SetManufacturerWarrantyLength (Value : Byte); Override;
    Function GetManufacturerWarrantyUnits : TStockWarrantyUnits; Override;
    Procedure SetManufacturerWarrantyUnits (Value : TStockWarrantyUnits); Override;
    Function GetRestockCharge : Double; Override;
    Procedure SetRestockCharge (Value : Double); Override;
    Function GetSalesReturnGL : LongInt; Override;
    Procedure SetSalesReturnGL (Value : LongInt); Override;
    Function GetSalesReturnQty : Double; Override;
    Procedure SetSalesReturnQty (Value : Double); Override;
    Function GetSalesWarrantyLength : Byte; Override;
    Procedure SetSalesWarrantyLength (Value : Byte); Override;
    Function GetSalesWarrantyUnits : TStockWarrantyUnits; Override;
    Procedure SetSalesWarrantyUnits (Value : TStockWarrantyUnits); Override;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const LocRec           : MLocRec);
  End; { TStockLocation }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  StkLocRecErrStr = 'Stock-Location ';

//=========================================================================

Constructor TStockLocation.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  FillChar (DataRec, SizeOf (DataRec), #0);
  FillChar (OrigRec, SizeOf (OrigRec), #0);
End;

//------------------------------

Destructor TStockLocation.Destroy;
Begin { Destroy }
  EntSys := NIL;

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TStockLocation.Assign (Const WinId, HandlerId : LongInt;
                            Const LocRec           : MLocRec);
Var
  I : SmallInt;
Begin { Assign }
  // Set Security Access to Record by hook point location
  Case WinId of
//    wiAccount     : RecAccess := ReadOnly;
//    wiTransaction : RecAccess := ReadOnly;
//    wiBACS        : RecAccess := ReadOnly;
//    wiStock       : RecAccess := ReadOnly;
//    wiStockDetail : RecAccess := ReadOnly;
//    wiSerialBatch : RecAccess := ReadOnly;
//    wiTransLine   : RecAccess := ReadOnly;
//    wiJobRec      : RecAccess := ReadOnly;
//    wiLocation    : RecAccess := ReadOnly;
    wiStockLoc    : RecAccess := ReadOnly;
//    wiMisc        : RecAccess := ReadOnly;
//    wiSystemOps   : RecAccess := ReadOnly;
  Else
    RecAccess := NotAvailable;
  End; { If }

  { Load fields from ExLocal }
  FillChar (DataRec, SizeOf (DataRec), #0);
  RecChanged := False;
  If (RecAccess <> NotAvailable) Then Begin
    If (LocRec.RecPfix = CostCCode) And (LocRec.SubType = CSubCode[False]) Then
      DataRec := LocRec.MStkLoc
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

//    Case ((WinId * 1000) + HandlerId) Of
//      103100002  {BrBincode Entry}
//           :   Begin
//                 PropAccess[01] := paReadWrite; {brBincode}
//               end;
//
//    end; {Case..}
  End; { If }

End; { Assign }

//-------------------------------------------------------------------------

Function TStockLocation.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

//-------------------------------------------------------------------------

Function TStockLocation.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

//-------------------------------------------------------------------------

function TStockLocation.GetStockCode: cuStr16;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsStkCode
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slStockCode');
end;
procedure TStockLocation.SetStockCode(Value: cuStr16);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsStkCode <> Value) Then
    Begin
      DataRec.lsStkCode := Value;
      RecChanged := True;
    End; // If (DataRec.lsStkCode <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slStockCode');
end;

//------------------------------

function TStockLocation.GetLocationCode: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsLocCode
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slLocationCode');
end;
procedure TStockLocation.SetLocationCode(Value: cuStr3);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsLocCode <> Value) Then
    Begin
      DataRec.lsLocCode := Value;
      RecChanged := True;
    End; // If (DataRec.lsLocCode <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slLocationCode');
end;

//------------------------------

function TStockLocation.GetQtyInStock: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsQtyInStock
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slQtyInStock');
end;
procedure TStockLocation.SetQtyInStock(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsQtyInStock <> Value) Then
    Begin
      DataRec.lsQtyInStock := Value;
      RecChanged := True;
    End; // If (DataRec.lsQtyInStock <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slQtyInStock');
end;

//------------------------------

function TStockLocation.GetQtyOnOrder: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsQtyOnOrder
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slQtyOnOrder');
end;
procedure TStockLocation.SetQtyOnOrder(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsQtyOnOrder <> Value) Then
    Begin
      DataRec.lsQtyOnOrder := Value;
      RecChanged := True;
    End; // If (DataRec.lsQtyOnOrder <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slQtyOnOrder');
end;

//------------------------------

function TStockLocation.GetQtyAllocated: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsQtyAlloc
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slQtyAllocated');
end;
procedure TStockLocation.SetQtyAllocated(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsQtyAlloc <> Value) Then
    Begin
      DataRec.lsQtyAlloc := Value;
      RecChanged := True;
    End; // If (DataRec.lsQtyAlloc <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slQtyAllocated');
end;

//------------------------------

function TStockLocation.GetQtyPicked: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsQtyPicked
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slQtyPicked');
end;
procedure TStockLocation.SetQtyPicked(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsQtyPicked <> Value) Then
    Begin
      DataRec.lsQtyPicked := Value;
      RecChanged := True;
    End; // If (DataRec.lsQtyPicked <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slQtyPicked');
end;

//------------------------------

function TStockLocation.GetQtyMin: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsQtyMin
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slQtyMin');
end;
procedure TStockLocation.SetQtyMin(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsQtyMin <> Value) Then
    Begin
      DataRec.lsQtyMin := Value;
      RecChanged := True;
    End; // If (DataRec.lsQtyMin <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slQtyMin');
end;

//------------------------------

function TStockLocation.GetQtyMax: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsQtyMax
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slQtyMax');
end;
procedure TStockLocation.SetQtyMax(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsQtyMax <> Value) Then
    Begin
      DataRec.lsQtyMax := Value;
      RecChanged := True;
    End; // If (DataRec.lsQtyMax <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slQtyMax');
end;

//------------------------------

function TStockLocation.GetQtyFreeze: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsQtyFreeze
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slQtyFreeze');
end;
procedure TStockLocation.SetQtyFreeze(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsQtyFreeze <> Value) Then
    Begin
      DataRec.lsQtyFreeze := Value;
      RecChanged := True;
    End; // If (DataRec.lsQtyFreeze <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slQtyFreeze');
end;

//------------------------------

function TStockLocation.GetReorderQty: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsRoQty
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slReorderQty');
end;
procedure TStockLocation.SetReorderQty(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsRoQty <> Value) Then
    Begin
      DataRec.lsRoQty := Value;
      RecChanged := True;
    End; // If (DataRec.lsRoQty <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slReorderQty');
end;

//------------------------------

function TStockLocation.GetReorderCur: cuCurrencyType;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsRoCurrency
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slReorderCur');
end;
procedure TStockLocation.SetReorderCur(Value: cuCurrencyType);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsRoCurrency <> Value) Then
    Begin
      If EntSys.ValidCCy (Value) Then Begin
        DataRec.lsRoCurrency := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StkLocRecErrStr + 'slReorderCur');
    End; // If (DataRec.lsRoCurrency <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slReorderCur');
end;

//------------------------------

function TStockLocation.GetReorderPrice: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsRoPrice
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slReorderPrice');
end;
procedure TStockLocation.SetReorderPrice(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsRoPrice <> Value) Then
    Begin
      DataRec.lsRoPrice := Value;
      RecChanged := True;
    End; // If (DataRec.lsRoPrice <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slReorderPrice');
end;

//------------------------------

function TStockLocation.GetReorderDate: cuLongDate;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsRoDate
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slReorderDate');
end;
procedure TStockLocation.SetReorderDate(Value: cuLongDate);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsRoDate <> Value) Then
    Begin
      DataRec.lsRoDate := Value;
      RecChanged := True;
    End; // If (DataRec.lsRoDate <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slReorderDate');
end;

//------------------------------

function TStockLocation.GetReorderCostCentre: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsRoCCDep[BOn]
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slReorderCostCentre');
end;
procedure TStockLocation.SetReorderCostCentre(Value: cuStr3);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsRoCCDep[BOn] <> Value) Then
    Begin
      DataRec.lsRoCCDep[BOn] := Value;
      RecChanged := True;
    End; // If (DataRec.lsRoCCDep[BOn] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slReorderCostCentre');
end;

//------------------------------

function TStockLocation.GetReorderDepartment: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsRoCCDep[BOff]
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slReorderDepartment');
end;
procedure TStockLocation.SetReorderDepartment(Value: cuStr3);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsRoCCDep[BOff] <> Value) Then
    Begin
      DataRec.lsRoCCDep[BOff] := Value;
      RecChanged := True;
    End; // If (DataRec.lsRoCCDep[BOff] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slReorderDepartment');
end;

//------------------------------

function TStockLocation.GetCostCentre: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsCCDep[BOn]
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slCostCentre');
end;
procedure TStockLocation.SetCostCentre(Value: cuStr3);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsCCDep[BOn] <> Value) Then
    Begin
      DataRec.lsCCDep[BOn] := Value;
      RecChanged := True;
    End; // If (DataRec.lsCCDep[BOn] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slCostCentre');
end;

//------------------------------

function TStockLocation.GetDepartment: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsCCDep[BOff]
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slDepartment');
end;
procedure TStockLocation.SetDepartment(Value: cuStr3);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsCCDep[BOff] <> Value) Then
    Begin
      DataRec.lsCCDep[BOff] := Value;
      RecChanged := True;
    End; // If (DataRec.lsCCDep[BOff] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slDepartment');
end;

//------------------------------

function TStockLocation.GetBinLocation: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsBinLoc
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slBinLocation');
end;
procedure TStockLocation.SetBinLocation(Value: cuStr10);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsBinLoc <> Value) Then
    Begin
      DataRec.lsBinLoc := Value;
      RecChanged := True;
    End; // If (DataRec.lsBinLoc <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slBinLocation');
end;

//------------------------------

function TStockLocation.GetCostPriceCur: cuCurrencyType;
begin
  Result := Low(cuCurrencyType);
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsPCurrency
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slCostPriceCur');
end;
procedure TStockLocation.SetCostPriceCur(Value: cuCurrencyType);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsPCurrency <> Value) Then
    Begin
      If EntSys.ValidCCy (Value) Then Begin
        DataRec.lsPCurrency := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StkLocRecErrStr + 'slCostPriceCur');
    End; // If (DataRec.lsPCurrency <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slCostPriceCur');
end;

//------------------------------

function TStockLocation.GetCostPrice: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsCostPrice
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slCostPrice');
end;
procedure TStockLocation.SetCostPrice(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsCostPrice <> Value) Then
    Begin
      DataRec.lsCostPrice := Value;
      RecChanged := True;
    End; // If (DataRec.lsCostPrice <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slCostPrice');
end;

//------------------------------

function TStockLocation.GetBelowMinLevel: Boolean;
begin
  Result := False;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsMinFlg
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slBelowMinLevel');
end;
procedure TStockLocation.SetBelowMinLevel(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsMinFlg <> Value) Then
    Begin
      DataRec.lsMinFlg := Value;
      RecChanged := True;
    End; // If (DataRec.lsMinFlg <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slBelowMinLevel');
end;

//------------------------------

function TStockLocation.GetSuppTemp: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsTempSupp
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slSuppTemp');
end;
procedure TStockLocation.SetSuppTemp(Value: cuStr6);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsTempSupp <> Value) Then
    Begin
      DataRec.lsTempSupp := Value;
      RecChanged := True;
    End; // If (DataRec.lsTempSupp <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slSuppTemp');
end;

//------------------------------

function TStockLocation.GetSupplier: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsSupplier
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slSupplier');
end;
procedure TStockLocation.SetSupplier(Value: cuStr6);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsSupplier <> Value) Then
    Begin
      DataRec.lsSupplier := Value;
      RecChanged := True;
    End; // If (DataRec.lsSupplier <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slSupplier');
end;

//------------------------------

function TStockLocation.GetLastUsed: cuLongDate;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsLastUsed
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slLastUsed');
end;
procedure TStockLocation.SetLastUsed(Value: cuLongDate);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsLastUsed <> Value) Then
    Begin
      DataRec.lsLastUsed := Value;
      RecChanged := True;
    End; // If (DataRec.lsLastUsed <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slLastUsed');
end;

//------------------------------

function TStockLocation.GetQtyPosted: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsQtyPosted
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slQtyPosted');
end;
procedure TStockLocation.SetQtyPosted(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsQtyPosted <> Value) Then
    Begin
      DataRec.lsQtyPosted := Value;
      RecChanged := True;
    End; // If (DataRec.lsQtyPosted <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slQtyPosted');
end;

//------------------------------

function TStockLocation.GetQtyStockTake: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsQtyTake
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slQtyStockTake');
end;
procedure TStockLocation.SetQtyStockTake(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsQtyTake <> Value) Then
    Begin
      DataRec.lsQtyTake := Value;
      RecChanged := True;
    End; // If (DataRec.lsQtyTake <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slQtyStockTake');
end;

//------------------------------

function TStockLocation.GetTimeChange: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsLastTime
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slTimeChange');
end;
procedure TStockLocation.SetTimeChange(Value: cuStr6);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsLastTime <> Value) Then
    Begin
      DataRec.lsLastTime := Value;
      RecChanged := True;
    End; // If (DataRec.lsLastTime <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slTimeChange');
end;

//------------------------------

function TStockLocation.GetSalesGL: LongInt;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsDefNom[1]
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slSalesGL');
end;
procedure TStockLocation.SetSalesGL(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsDefNom[1] <> Value) Then
    Begin
      DataRec.lsDefNom[1] := Value;
      RecChanged := True;
    End; // If (DataRec.lsDefNom[1] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slSalesGL');
end;

//------------------------------

function TStockLocation.GetCostOfSalesGL: LongInt;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsDefNom[2]
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slCostOfSalesGL');
end;
procedure TStockLocation.SetCostOfSalesGL(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsDefNom[2] <> Value) Then
    Begin
      DataRec.lsDefNom[2] := Value;
      RecChanged := True;
    End; // If (DataRec.lsDefNom[2] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slCostOfSalesGL');
end;

//------------------------------

function TStockLocation.GetPandLGL: LongInt;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsDefNom[3]
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slPandLGL');
end;
procedure TStockLocation.SetPandLGL(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsDefNom[3] <> Value) Then
    Begin
      DataRec.lsDefNom[3] := Value;
      RecChanged := True;
    End; // If (DataRec.lsDefNom[3] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slPandLGL');
end;

//------------------------------

function TStockLocation.GetBalSheetGL: LongInt;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsDefNom[4]
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slBalSheetGL');
end;
procedure TStockLocation.SetBalSheetGL(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsDefNom[4] <> Value) Then
    Begin
      DataRec.lsDefNom[4] := Value;
      RecChanged := True;
    End; // If (DataRec.lsDefNom[4] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slBalSheetGL');
end;

//------------------------------

function TStockLocation.GetWIPGL: LongInt;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsDefNom[5]
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slWIPGL');
end;
procedure TStockLocation.SetWIPGL(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsDefNom[5] <> Value) Then
    Begin
      DataRec.lsDefNom[5] := Value;
      RecChanged := True;
    End; // If (DataRec.lsDefNom[5] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slWIPGL');
end;

//------------------------------

function TStockLocation.GetSaleBandsCcy(Index: cuSalesBandIndex): cuCurrencyType;
begin
  {$IFDEF MC_On}
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsSaleBands[Ord(Index) - Ord('A') + 1].Currency
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slSaleBandsCcy');
  {$ELSE}
    Result := 0;
  {$ENDIF}
end;
procedure TStockLocation.SetSaleBandsCcy(Index: cuSalesBandIndex; Value: cuCurrencyType);
begin
  {$IFDEF MC_On}
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsSaleBands[Ord(Index) - Ord('A') + 1].Currency <> Value) Then
    Begin
      DataRec.lsSaleBands[Ord(Index) - Ord('A') + 1].Currency := Value;
      RecChanged := True;
    End; // If (DataRec.lsSaleBands[Ord(Index) - Ord('A') + 1].Currency <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slSaleBandsCcy');
  {$ELSE}
    DataRec.lsSaleBands[Ord(Index) - Ord('A') + 1].Currency := 0;
  {$ENDIF}
end;

//------------------------------

function TStockLocation.GetSaleBandsPrice(Index: cuSalesBandIndex): Real;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.lsSaleBands[Ord(Index) - Ord('A') + 1].SalesPrice
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slSaleBandsPrice');
end;
procedure TStockLocation.SetSaleBandsPrice(Index: cuSalesBandIndex; Value: Real);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.lsSaleBands[Ord(Index) - Ord('A') + 1].SalesPrice <> Value) Then
    Begin
      DataRec.lsSaleBands[Ord(Index) - Ord('A') + 1].SalesPrice := Value;
      RecChanged := True;
    End; // If (DataRec.lsSaleBands[Ord(Index) - Ord('A') + 1].SalesPrice <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slSaleBandsPrice');
end;

//------------------------------

function TStockLocation.GetQtyFree: Double;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
  Begin
    If Syss.FreeExAll Then
      Result := DataRec.lsQtyInStock
    Else
    Begin
      If Syss.UsePick4All Then
        Result := DataRec.lsQtyInStock - DataRec.lsQtyPicked
      Else
        Result := DataRec.lsQtyInStock - DataRec.lsQtyAlloc;
    End; { Else }
  End // If (RecAccess <> NotAvailable)
  Else
    EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slQtyFree');
end;

//------------------------------

function TStockLocation.GetPurchaseReturnGL: LongInt;
begin
  Result := 0;
   {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.lsPReturnGL
    Else
      EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slPurchaseReturnGL');
  End { If RetMOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slPurchaseReturnGL');
end;
procedure TStockLocation.SetPurchaseReturnGL(Value: Integer);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
    Begin
      If (DataRec.lsPReturnGL <> Value) Then
      Begin
        DataRec.lsPReturnGL := Value;
        RecChanged := True;
      End; // If (DataRec.lsPReturnGL <> Value)
    End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
    Else
      EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slPurchaseReturnGL');
  End { If RetMOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slPurchaseReturnGL');
end;

//------------------------------

function TStockLocation.GetPurchaseReturnQty: Double;
begin
  Result := 0;
   {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.lsQtyPReturn
    Else
      EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slPurchaseReturnQty');
  End { If RetMOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slPurchaseReturnQty');
end;
procedure TStockLocation.SetPurchaseReturnQty(Value: Double);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
    Begin
      If (DataRec.lsQtyPReturn <> Value) Then
      Begin
        DataRec.lsQtyPReturn := Value;
        RecChanged := True;
      End; // If (DataRec.lsQtyPReturn <> Value)
    End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
    Else
      EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slPurchaseReturnQty');
  End { If RetMOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slPurchaseReturnQty');
end;

//------------------------------

function TStockLocation.GetManufacturerWarrantyLength: Byte;
begin
  Result := 0;
   {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.lsMWarranty
    Else
      EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slManufacturerWarrantyLength');
  End { If RetMOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slManufacturerWarrantyLength');
end;
procedure TStockLocation.SetManufacturerWarrantyLength(Value: Byte);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
    Begin
      If (DataRec.lsMWarranty <> Value) Then
      Begin
        DataRec.lsMWarranty := Value;
        RecChanged := True;
      End; // If (DataRec.lsMWarranty <> Value)
    End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
    Else
      EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slManufacturerWarrantyLength');
  End { If RetMOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slManufacturerWarrantyLength');
end;

//------------------------------

function TStockLocation.GetManufacturerWarrantyUnits: TStockWarrantyUnits;
begin
  Result := Low(TStockWarrantyUnits);
    {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := TStockWarrantyUnits(DataRec.lsMWarrantyType)
    Else
      EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slManufacturerWarrantyUnits');
  End { If RetMOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slManufacturerWarrantyUnits');
end;
procedure TStockLocation.SetManufacturerWarrantyUnits(Value: TStockWarrantyUnits);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
    Begin
      If (DataRec.lsMWarrantyType <> Byte(Ord(Value))) Then
      Begin
        DataRec.lsMWarrantyType := Ord(Value);
        RecChanged := True;
      End; // If (DataRec.lsMWarrantyType <> Ord(Value))
    End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
    Else
      EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slManufacturerWarrantyUnits');
  End { If RetMOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slManufacturerWarrantyUnits');
end;

//------------------------------

function TStockLocation.GetRestockCharge: Double;
begin
  Result := 0;
   {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.lsReStockPcnt
    Else
      EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slRestockCharge');
  End { If RetMOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slRestockCharge');
end;
procedure TStockLocation.SetRestockCharge(Value: Double);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
    Begin
      If (DataRec.lsReStockPcnt <> Value) Then
      Begin
        DataRec.lsReStockPcnt := Value;
        RecChanged := True;
      End; // If (DataRec.lsReStockPcnt <> Value)
    End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
    Else
      EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slRestockCharge');
  End { If RetMOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slRestockCharge');
end;

//------------------------------

function TStockLocation.GetSalesReturnGL: LongInt;
begin
  Result := 0;
   {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.lsReturnGL
    Else
      EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slSalesReturnGL');
  End { If RetMOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slSalesReturnGL');
end;
procedure TStockLocation.SetSalesReturnGL(Value: Integer);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
    Begin
      If (DataRec.lsReturnGL <> Value) Then
      Begin
        DataRec.lsReturnGL := Value;
        RecChanged := True;
      End; // If (DataRec.lsReturnGL <> Value)
    End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
    Else
      EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slSalesReturnGL');
  End { If RetMOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slSalesReturnGL');
end;

//------------------------------

function TStockLocation.GetSalesReturnQty: Double;
begin
  Result := 0;
   {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.lsQtyReturn
    Else
      EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slSalesReturnQty');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slSalesReturnQty');
end;
procedure TStockLocation.SetSalesReturnQty(Value: Double);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
    Begin
      If (DataRec.lsQtyReturn <> Value) Then
      Begin
        DataRec.lsQtyReturn := Value;
        RecChanged := True;
      End; // If (DataRec.lsQtyReturn <> Value)
    End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
    Else
      EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slSalesReturnQty');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slSalesReturnQty');
end;

//------------------------------

function TStockLocation.GetSalesWarrantyLength: Byte;
begin
  Result := 0;
   {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.lsSWarranty
    Else
      EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slSalesWarrantyLength');
  End { If RetMOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slSalesWarrantyLength');
end;
procedure TStockLocation.SetSalesWarrantyLength(Value: Byte);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
    Begin
      If (DataRec.lsSWarranty <> Value) Then
      Begin
        DataRec.lsSWarranty := Value;
        RecChanged := True;
      End; // If (DataRec.lsSWarranty <> Value)
    End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
    Else
      EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slSalesWarrantyLength');
  End { If RetMOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slSalesWarrantyLength');
end;

//------------------------------

function TStockLocation.GetSalesWarrantyUnits: TStockWarrantyUnits;
begin
  Result := Low(TStockWarrantyUnits);
  {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := TStockWarrantyUnits(DataRec.lsSWarrantyType)
    Else
      EntSys.DataAccessErrDlg(True, StkLocRecErrStr + 'slSalesWarrantyUnits');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('slSalesWarrantyUnits');
end;
procedure TStockLocation.SetSalesWarrantyUnits(Value: TStockWarrantyUnits);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
    Begin
      If (DataRec.lsSWarrantyType <> Byte(Ord(Value))) Then
      Begin
        DataRec.lsSWarrantyType := Ord(Value);
        RecChanged := True;
      End; // If (DataRec.lsSWarrantyType <> Ord(Value))
    End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
    Else
      EntSys.DataAccessErrDlg(False, StkLocRecErrStr + 'slSalesWarrantyUnits');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('slSalesWarrantyUnits');
end;

//-------------------------------------------------------------------------

end.

