unit oBatch;

{$I DEFOVR.INC}

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TBatchSerial = Class(TAbsBatchSerial3)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..34] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : ^SerialType;
  Protected
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function  GetSerialCode : cuStr26; Override;
    Procedure SetSerialCode(Value : cuStr26); Override;
    Function  GetSerialNo : cuStr20; Override;
    Procedure SetSerialNo(Value : cuStr20); Override;
    Function  GetBatchNo : cuStr10; Override;
    Procedure SetBatchNo(Value : cuStr10); Override;
    Function  GetInDoc : cuStr10; Override;
    Procedure SetInDoc(Value : cuStr10); Override;
    Function  GetOutDoc : cuStr10; Override;
    Procedure SetOutDoc(Value : cuStr10); Override;
    Function  GetSold : Boolean; Override;
    Procedure SetSold(Value : Boolean); Override;
    Function  GetDateIn : cuLongDate; Override;
    Procedure SetDateIn(Value : cuLongDate); Override;
    Function  GetSerCost : Double; Override;
    Procedure SetSerCost(Value : Double); Override;
    Function  GetSerSell : Double; Override;
    Procedure SetSerSell(Value : Double); Override;
    Function  GetStkFolio : LongInt; Override;
    Procedure SetStkFolio(Value : LongInt); Override;
    Function  GetDateOut : cuLongDate; Override;
    Procedure SetDateOut(Value : cuLongDate); Override;
    Function  GetSoldLine : LongInt; Override;
    Procedure SetSoldLine(Value : LongInt); Override;
    Function  GetCurCost : cuCurrencyType; Override;
    Procedure SetCurCost(Value : cuCurrencyType); Override;
    Function  GetCurSell : cuCurrencyType; Override;
    Procedure SetCurSell(Value : cuCurrencyType); Override;
    Function  GetBuyLine : LongInt; Override;
    Procedure SetBuyLine(Value : LongInt); Override;
    Function  GetBatchRec : Boolean; Override;
    Procedure SetBatchRec(Value : Boolean); Override;
    Function  GetBuyQty : Double; Override;
    Procedure SetBuyQty(Value : Double); Override;
    Function  GetQtyUsed : Double; Override;
    Procedure SetQtyUsed(Value : Double); Override;
    Function  GetBatchChild : Boolean; Override;
    Procedure SetBatchChild(Value : Boolean); Override;
    Function  GetInMLoc : cuStr3; Override;
    Procedure SetInMLoc(Value : cuStr3); Override;
    Function  GetOutMLoc : cuStr3; Override;
    Procedure SetOutMLoc(Value : cuStr3); Override;
    Function  GetCompanyRate : Real; Override;
    Procedure SetCompanyRate(Value : Real); Override;
    Function  GetDailyRate : Real; Override;
    Procedure SetDailyRate(Value : Real); Override;
    Function  GetInOrdDoc : cuStr10; Override;
    Procedure SetInOrdDoc(Value : cuStr10); Override;
    Function  GetOutOrdDoc : cuStr10; Override;
    Procedure SetOutOrdDoc(Value : cuStr10); Override;
    Function  GetInOrdLine : LongInt; Override;
    Procedure SetInOrdLine(Value : LongInt); Override;
    Function  GetOutOrdLine : LongInt; Override;
    Procedure SetOutOrdLine(Value : LongInt); Override;
    Function  GetNLineCount : LongInt; Override;
    Procedure SetNLineCount(Value : LongInt); Override;
    Function  GetNoteFolio : LongInt; Override;
    Procedure SetNoteFolio(Value : LongInt); Override;
    Function  GetDateUseX : cuLongDate; Override;
    Procedure SetDateUseX(Value : cuLongDate); Override;
    Function  GetSUseORate : Byte; Override;
    Procedure SetSUseORate(Value : Byte); Override;

    // HM 10/09/03: Added TAbsBatchSerial2 for BinCode
    Function  GetBinCode : cuStr10; Override;
    Procedure SetBinCode(Value : cuStr10); Override;

    // TAbsBatchSerial3
    Function GetReturned : Boolean; Override;
    Procedure SetReturned (Value : Boolean); Override;
    Function GetReturnOurRef : cuStr10; Override;
    Procedure SetReturnOurRef (Value : cuStr10); Override;
    Function GetBatchReturnedQty : Double; Override;
    Procedure SetBatchReturnedQty (Value : Double); Override;
    Function GetReturnLineNo : LongInt; Override;
    Procedure SetReturnLineNo (Value : LongInt); Override;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const Batch            : MiscRec);
  End; { TBatchSerial }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  BatchErrStr = 'Serial/Batch ';

{-------------------------------------------------------------------------------------------------}

Constructor TBatchSerial.Create (hEntSys  : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  New (DataRec);
  FillChar (DataRec^, SizeOf (DataRec^), #0);
  New (OrigRec);
  FillChar (OrigRec^, SizeOf (OrigRec^), #0);
End;

{-------------------------------------------------------------------------------------------------}

Destructor TBatchSerial.Destroy;
Begin { Destroy }
  Dispose (DataRec);
  Dispose (OrigRec);

  Inherited Destroy;
End; { Destroy }

{-------------------------------------------------------------------------------------------------}

Procedure TBatchSerial.Assign (Const WinId, HandlerId : LongInt;
                               Const Batch            : MiscRec);
Var
  I : SmallInt;
Begin
  { Set Security Access to Record }
  Case WinId of
    EnterpriseBase+3100                { Account }
         :  RecAccess:=ReadOnly;
  Else
    RecAccess:=NotAvailable;
  End; { If }

  { Load fields from ExLocal }
  FillChar (DataRec^, SizeOf (DataRec^), #0);
  RecChanged := False;
  If (RecAccess <> NotAvailable) Then Begin
    { Check ExLocal has a Cost Centre record loaded }
    If (Batch.RecMfix = MFIFOCode) And (Batch.SubType = MSERNSub) Then Begin
      DataRec^ := Batch.SerialRec;
      
    End { If }
    Else
      RecAccess := NotAvailable;
  End; { If }
  OrigRec^ := DataRec^;

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
      { Serial/Batch Entry - Enter Batch Number }
      103100001 : Begin
                    PropAccess[3] := paReadWrite;    { Batch Number }
                  End;
      { Serial/Batch Entry - Enter Bin Code}
      103100003,
      103100004 : Begin
                    PropAccess[32] := paReadWrite;    { Bin Code }
                  End;
    End; { Case }
  End; { If }
End;

{-------------------------------------------------------------------------------------------------}

Function TBatchSerial.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

{-------------------------------------------------------------------------------------------------}

Function TBatchSerial.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

{-------------------------------------------------------------------------------------------------}

Function TBatchSerial.GetSerialCode : cuStr26;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SerialCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'SerialCode');
  End; { Else }
End;

Procedure TBatchSerial.SetSerialCode(Value : cuStr26);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[1] = paReadWrite) Then Begin
    If (DataRec.SerialCode <> Value) Then Begin
      DataRec.SerialCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'SerialCode');
End;

Function TBatchSerial.GetSerialNo : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SerialNo
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'SerialNo');
  End; { Else }
End;

Procedure TBatchSerial.SetSerialNo(Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[2] = paReadWrite) Then Begin
    If (DataRec.SerialNo <> Value) Then Begin
      DataRec.SerialNo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'SerialNo');
End;

Function TBatchSerial.GetBatchNo : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BatchNo
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'BatchNo');
  End; { Else }
End;

Procedure TBatchSerial.SetBatchNo(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[3] = paReadWrite) Then Begin
    If (DataRec.BatchNo <> Value) Then Begin
      DataRec.BatchNo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'BatchNo');
End;

Function TBatchSerial.GetInDoc : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.InDoc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'InDoc');
  End; { Else }
End;

Procedure TBatchSerial.SetInDoc(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[4] = paReadWrite) Then Begin
    If (DataRec.InDoc <> Value) Then Begin
      DataRec.InDoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'InDoc');
End;

Function TBatchSerial.GetOutDoc : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OutDoc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'OutDoc');
  End; { Else }
End;

Procedure TBatchSerial.SetOutDoc(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[5] = paReadWrite) Then Begin
    If (DataRec.OutDoc <> Value) Then Begin
      DataRec.OutDoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'OutDoc');
End;

Function TBatchSerial.GetSold : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Sold
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'Sold');
  End; { Else }
End;

Procedure TBatchSerial.SetSold(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[6] = paReadWrite) Then Begin
    If (DataRec.Sold <> Value) Then Begin
      DataRec.Sold := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'Sold');
End;

Function TBatchSerial.GetDateIn : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DateIn
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'DateIn');
  End; { Else }
End;

Procedure TBatchSerial.SetDateIn(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[7] = paReadWrite) Then Begin
    If (DataRec.DateIn <> Value) Then Begin
      DataRec.DateIn := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'DateIn');
End;

Function TBatchSerial.GetSerCost : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SerCost
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'SerCost');
  End; { Else }
End;

Procedure TBatchSerial.SetSerCost(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[8] = paReadWrite) Then Begin
    If (DataRec.SerCost <> Value) Then Begin
      DataRec.SerCost := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'SerCost');
End;

Function TBatchSerial.GetSerSell : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SerSell
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'SerSell');
  End; { Else }
End;

Procedure TBatchSerial.SetSerSell(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[9] = paReadWrite) Then Begin
    If (DataRec.SerSell <> Value) Then Begin
      DataRec.SerSell := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'SerSell');
End;

Function TBatchSerial.GetStkFolio : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StkFolio
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'StkFolio');
  End; { Else }
End;

Procedure TBatchSerial.SetStkFolio(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[10] = paReadWrite) Then Begin
    If (DataRec.StkFolio <> Value) Then Begin
      DataRec.StkFolio := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'StkFolio');
End;

Function TBatchSerial.GetDateOut : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DateOut
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'DateOut');
  End; { Else }
End;

Procedure TBatchSerial.SetDateOut(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[11] = paReadWrite) Then Begin
    If (DataRec.DateOut <> Value) Then Begin
      DataRec.DateOut := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'DateOut');
End;

Function TBatchSerial.GetSoldLine : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SoldLine
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'SoldLine');
  End; { Else }
End;

Procedure TBatchSerial.SetSoldLine(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[12] = paReadWrite) Then Begin
    If (DataRec.SoldLine <> Value) Then Begin
      DataRec.SoldLine := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'SoldLine');
End;

Function TBatchSerial.GetCurCost : cuCurrencyType;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CurCost
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'CurCost');
  End; { Else }
End;

Procedure TBatchSerial.SetCurCost(Value : cuCurrencyType);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[13] = paReadWrite) Then Begin
    If (DataRec.CurCost <> Value) Then Begin
      DataRec.CurCost := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'CurCost');
End;

Function TBatchSerial.GetCurSell : cuCurrencyType;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CurSell
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'CurSell');
  End; { Else }
End;

Procedure TBatchSerial.SetCurSell(Value : cuCurrencyType);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[14] = paReadWrite) Then Begin
    If (DataRec.CurSell <> Value) Then Begin
      DataRec.CurSell := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'CurSell');
End;

Function TBatchSerial.GetBuyLine : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BuyLine
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'BuyLine');
  End; { Else }
End;

Procedure TBatchSerial.SetBuyLine(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[15] = paReadWrite) Then Begin
    If (DataRec.BuyLine <> Value) Then Begin
      DataRec.BuyLine := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'BuyLine');
End;

Function TBatchSerial.GetBatchRec : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BatchRec
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'BatchRec');
  End; { Else }
End;

Procedure TBatchSerial.SetBatchRec(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[16] = paReadWrite) Then Begin
    If (DataRec.BatchRec <> Value) Then Begin
      DataRec.BatchRec := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'BatchRec');
End;

Function TBatchSerial.GetBuyQty : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BuyQty
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'BuyQty');
  End; { Else }
End;

Procedure TBatchSerial.SetBuyQty(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[17] = paReadWrite) Then Begin
    If (DataRec.BuyQty <> Value) Then Begin
      DataRec.BuyQty := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'BuyQty');
End;

Function TBatchSerial.GetQtyUsed : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyUsed
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'QtyUsed');
  End; { Else }
End;

Procedure TBatchSerial.SetQtyUsed(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[18] = paReadWrite) Then Begin
    If (DataRec.QtyUsed <> Value) Then Begin
      DataRec.QtyUsed := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'QtyUsed');
End;

Function TBatchSerial.GetBatchChild : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BatchChild
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'BatchChild');
  End; { Else }
End;

Procedure TBatchSerial.SetBatchChild(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[19] = paReadWrite) Then Begin
    If (DataRec.BatchChild <> Value) Then Begin
      DataRec.BatchChild := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'BatchChild');
End;

Function TBatchSerial.GetInMLoc : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.InMLoc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'InMLoc');
  End; { Else }
End;

Procedure TBatchSerial.SetInMLoc(Value : cuStr3);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[20] = paReadWrite) Then Begin
    If (DataRec.InMLoc <> Value) Then Begin
      DataRec.InMLoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'InMLoc');
End;

Function TBatchSerial.GetOutMLoc : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OutMLoc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'OutMLoc');
  End; { Else }
End;

Procedure TBatchSerial.SetOutMLoc(Value : cuStr3);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[21] = paReadWrite) Then Begin
    If (DataRec.OutMLoc <> Value) Then Begin
      DataRec.OutMLoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'OutMLoc');
End;

Function TBatchSerial.GetCompanyRate : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SerCRates[False]
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'CompanyRate');
  End; { Else }
End;

Procedure TBatchSerial.SetCompanyRate(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[22] = paReadWrite) Then Begin
    If (DataRec.SerCRates[False] <> Value) Then Begin
      DataRec.SerCRates[False] := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'CompanyRate');
End;

Function TBatchSerial.GetDailyRate : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SerCRates[True]
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'DailyRate');
  End; { Else }
End;

Procedure TBatchSerial.SetDailyRate(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[23] = paReadWrite) Then Begin
    If (DataRec.SerCRates[True] <> Value) Then Begin
      DataRec.SerCRates[True] := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'DailyRate');
End;

Function TBatchSerial.GetInOrdDoc : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.InOrdDoc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'InOrdDoc');
  End; { Else }
End;

Procedure TBatchSerial.SetInOrdDoc(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[24] = paReadWrite) Then Begin
    If (DataRec.InOrdDoc <> Value) Then Begin
      DataRec.InOrdDoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'InOrdDoc');
End;

Function TBatchSerial.GetOutOrdDoc : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OutOrdDoc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'OutOrdDoc');
  End; { Else }
End;

Procedure TBatchSerial.SetOutOrdDoc(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[25] = paReadWrite) Then Begin
    If (DataRec.OutOrdDoc <> Value) Then Begin
      DataRec.OutOrdDoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'OutOrdDoc');
End;

Function TBatchSerial.GetInOrdLine : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.InOrdLine
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'InOrdLine');
  End; { Else }
End;

Procedure TBatchSerial.SetInOrdLine(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[26] = paReadWrite) Then Begin
    If (DataRec.InOrdLine <> Value) Then Begin
      DataRec.InOrdLine := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'InOrdLine');
End;

Function TBatchSerial.GetOutOrdLine : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OutOrdLine
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'OutOrdLine');
  End; { Else }
End;

Procedure TBatchSerial.SetOutOrdLine(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[27] = paReadWrite) Then Begin
    If (DataRec.OutOrdLine <> Value) Then Begin
      DataRec.OutOrdLine := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'OutOrdLine');
End;

Function TBatchSerial.GetNLineCount : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.NLineCount
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'NLineCount');
  End; { Else }
End;

Procedure TBatchSerial.SetNLineCount(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[28] = paReadWrite) Then Begin
    If (DataRec.NLineCount <> Value) Then Begin
      DataRec.NLineCount := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'NLineCount');
End;

Function TBatchSerial.GetNoteFolio : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.NoteFolio
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'NoteFolio');
  End; { Else }
End;

Procedure TBatchSerial.SetNoteFolio(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[29] = paReadWrite) Then Begin
    If (DataRec.NoteFolio <> Value) Then Begin
      DataRec.NoteFolio := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'NoteFolio');
End;

Function TBatchSerial.GetDateUseX : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DateUseX
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'DateUseX');
  End; { Else }
End;

Procedure TBatchSerial.SetDateUseX(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[30] = paReadWrite) Then Begin
    If (DataRec.DateUseX <> Value) Then Begin
      DataRec.DateUseX := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'DateUseX');
End;

Function TBatchSerial.GetSUseORate : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SUseORate
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'SUseORate');
  End; { Else }
End;

Procedure TBatchSerial.SetSUseORate(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[31] = paReadWrite) Then Begin
    If (DataRec.SUseORate <> Value) Then Begin
      DataRec.SUseORate := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'SUseORate');
End;

//------------------------------

// HM 10/09/03: Added TAbsBatchSerial2 for BinCode
Function TBatchSerial.GetBinCode : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.InBinCode
  Else
    EntSys.DataAccessErrDlg(True, BatchErrStr + 'BinCode');
End;

Procedure TBatchSerial.SetBinCode(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[32] = paReadWrite) Then Begin
    If (DataRec.InBinCode <> Value) Then Begin
      DataRec.InBinCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, BatchErrStr + 'BinCode');
End;

//------------------------------

function TBatchSerial.GetReturned: Boolean;
begin
  Result := False;
   {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.ReturnSNo
    Else
      EntSys.DataAccessErrDlg(True, BatchErrStr + 'bsReturned');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('bsReturned');
end;
procedure TBatchSerial.SetReturned(Value: Boolean);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsBatchSerial3.bsReturned');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('bsReturned');
end;

//------------------------------

function TBatchSerial.GetReturnOurRef : cuStr10;
begin
  {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.RetDoc
    Else
      EntSys.DataAccessErrDlg(True, BatchErrStr + 'bsReturnOurRef');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('bsReturnOurRef');
end;
Procedure TBatchSerial.SetReturnOurRef (Value: cuStr10);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsBatchSerial3.bsReturnOurRef');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('bsReturnOurRef');
end;

//------------------------------

Function TBatchSerial.GetBatchReturnedQty : Double;
begin
  Result := 0;
   {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.BatchRetQty
    Else
      EntSys.DataAccessErrDlg(True, BatchErrStr + 'bsBatchReturnedQty');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('bsBatchReturnedQty');
end;
Procedure TBatchSerial.SetBatchReturnedQty (Value : Double);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsBatchSerial3.bsBatchReturnedQty');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('bsBatchReturnedQty');
end;

//------------------------------

function TBatchSerial.GetReturnLineNo: LongInt;
begin
  Result := 0;
   {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.RetDocLine
    Else
      EntSys.DataAccessErrDlg(True, BatchErrStr + 'bsReturnLineNo');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('bsReturnLineNo');
end;
procedure TBatchSerial.SetReturnLineNo(Value: Integer);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsBatchSerial3.bsReturnLineNo');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('bsReturnLineNo');
end;

//-------------------------------------------------------------------------


end.
