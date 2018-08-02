unit oLoc;

{$I DEFOVR.INC}

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU, VarRec2U;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TLocation = Class(TAbsLocation)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..26] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : MLocLocType;
  Protected
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function GetCode : cuStr3; Override;
    Procedure SetCode (Value : cuStr3); Override;
    Function GetName : cuStr45; Override;
    Procedure SetName (Value : cuStr45); Override;
    Function  GetAddr(Index : cuAddrIndex) : cuStr30; Override;
    Procedure SetAddr(Index : cuAddrIndex; Value : cuStr30); Override;
    Function GetPhone : cuStr25; Override;
    Procedure SetPhone (Value : cuStr25); Override;
    Function GetFax : cuStr25; Override;
    Procedure SetFax (Value : cuStr25); Override;
    Function GetEmailAddr : cuStr100; Override;
    Procedure SetEmailAddr (Value : cuStr100); Override;
    Function GetModem : cuStr25; Override;
    Procedure SetModem (Value : cuStr25); Override;
    Function GetContact : cuStr30; Override;
    Procedure SetContact (Value : cuStr30); Override;
    Function GetCurrency : cuCurrencyType; Override;
    Procedure SetCurrency (Value : cuCurrencyType); Override;
    Function GetArea : cuStr5; Override;
    Procedure SetArea (Value : cuStr5); Override;
    Function GetRep : cuStr5; Override;
    Procedure SetRep (Value : cuStr5); Override;
    Function GetTagged : Boolean; Override;
    Procedure SetTagged (Value : Boolean); Override;
    Function GetCostCentre : cuStr3; Override;
    Procedure SetCostCentre (Value : cuStr3); Override;
    Function GetDepartment : cuStr3; Override;
    Procedure SetDepartment (Value : cuStr3); Override;
    Function GetOverrideSalesPrice : Boolean; Override;
    Procedure SetOverrideSalesPrice (Value : Boolean); Override;
    Function GetOverrideGLCodes : Boolean; Override;
    Procedure SetOverrideGLCodes (Value : Boolean); Override;
    Function GetOverrideCCDept : Boolean; Override;
    Procedure SetOverrideCCDept (Value : Boolean); Override;
    Function GetOverrideSupplier : Boolean; Override;
    Procedure SetOverrideSupplier (Value : Boolean); Override;
    Function GetOverrideBinLocation : Boolean; Override;
    Procedure SetOverrideBinLocation (Value : Boolean); Override;
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
    Function GetPurchaseReturnGL : LongInt; Override;
    Procedure SetPurchaseReturnGL (Value : LongInt); Override;
    Function GetSalesReturnGL : LongInt; Override;
    Procedure SetSalesReturnGL (Value : LongInt); Override;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const LocRec           : MLocRec);
  End; { TLocation }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  LocRecErrStr = 'Location ';

//=========================================================================

Constructor TLocation.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  FillChar (DataRec, SizeOf (DataRec), #0);
  FillChar (OrigRec, SizeOf (OrigRec), #0);
End;

//------------------------------

Destructor TLocation.Destroy;
Begin { Destroy }
  EntSys := NIL;

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TLocation.Assign (Const WinId, HandlerId : LongInt;
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
    wiLocation    : RecAccess := ReadOnly;
//    wiStockLoc    : RecAccess := ReadOnly;
//    wiMisc        : RecAccess := ReadOnly;
//    wiSystemOps   : RecAccess := ReadOnly;
  Else
    RecAccess := NotAvailable;
  End; { If }

  { Load fields from ExLocal }
  FillChar (DataRec, SizeOf (DataRec), #0);
  RecChanged := False;
  If (RecAccess <> NotAvailable) Then Begin
    If (LocRec.RecPfix = CostCCode) And (LocRec.SubType = CSubCode[True]) Then
      DataRec := LocRec.MLocLoc
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

Function TLocation.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

//-------------------------------------------------------------------------

Function TLocation.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

//-------------------------------------------------------------------------

function TLocation.GetCode: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.loCode
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loCode');
end;
procedure TLocation.SetCode(Value: cuStr3);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (DataRec.loCode <> Value) Then
    Begin
      DataRec.loCode := Value;
      RecChanged := True;
    End; // If (DataRec.loCode <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loCode');
end;

//------------------------------

function TLocation.GetName: cuStr45;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.loName
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loName');
end;
procedure TLocation.SetName(Value: cuStr45);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[02] = paReadWrite) Then
  Begin
    If (DataRec.loName <> Value) Then
    Begin
      DataRec.loName := Value;
      RecChanged := True;
    End; // If (DataRec.loName <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[02] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loName');
end;

//------------------------------

function TLocation.GetAddr(Index: cuAddrIndex): cuStr30;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.loAddr[Index]
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loAddr');
end;
procedure TLocation.SetAddr(Index: cuAddrIndex; Value: cuStr30);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[03] = paReadWrite) Then
  Begin
    If (DataRec.loAddr[Index] <> Value) Then
    Begin
      DataRec.loAddr[Index] := Value;
      RecChanged := True;
    End; // If (DataRec.loAddr[Index] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[03] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loAddr');
end;

//------------------------------

function TLocation.GetPhone: cuStr25;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.loTel
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loPhone');
end;
procedure TLocation.SetPhone(Value: cuStr25);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[04] = paReadWrite) Then
  Begin
    If (DataRec.loTel <> Value) Then
    Begin
      DataRec.loTel := Value;
      RecChanged := True;
    End; // If (DataRec.loTel <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[04] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loPhone');
end;

//------------------------------

function TLocation.GetFax: cuStr25;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.loFax
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loFax');
end;
procedure TLocation.SetFax(Value: cuStr25);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[05] = paReadWrite) Then
  Begin
    If (DataRec.loFax <> Value) Then
    Begin
      DataRec.loFax := Value;
      RecChanged := True;
    End; // If (DataRec.loFax <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[05] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loFax');
end;

//------------------------------

function TLocation.GetEmailAddr: cuStr100;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.loEmail
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loEmailAddr');
end;
procedure TLocation.SetEmailAddr(Value: cuStr100);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[06] = paReadWrite) Then
  Begin
    If (DataRec.loEmail <> Value) Then
    Begin
      DataRec.loEmail := Value;
      RecChanged := True;
    End; // If (DataRec.loEmail <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[06] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loEmailAddr');
end;

//------------------------------

function TLocation.GetModem: cuStr25;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.loModem
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loModem');
end;
procedure TLocation.SetModem(Value: cuStr25);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[07] = paReadWrite) Then
  Begin
    If (DataRec.loModem <> Value) Then
    Begin
      DataRec.loModem := Value;
      RecChanged := True;
    End; // If (DataRec.loModem <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[07] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loModem');
end;

//------------------------------

Function TLocation.GetContact : cuStr30;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.loContact
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loContact');
end;
Procedure TLocation.SetContact (Value : cuStr30);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[08] = paReadWrite) Then
  Begin
    If (DataRec.loContact <> Value) Then
    Begin
      DataRec.loContact := Value;
      RecChanged := True;
    End; // If (DataRec.loContact <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[08] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loContact');
end;

//------------------------------

function TLocation.GetCurrency: cuCurrencyType;
begin
  Result := Low(cuCurrencyType);
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.loCurrency
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loCurrency');
end;
procedure TLocation.SetCurrency(Value: cuCurrencyType);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[09] = paReadWrite) Then
  Begin
    If (DataRec.loCurrency <> Value) Then
    Begin
      If EntSys.ValidCCy (Value) Then Begin
        DataRec.loCurrency := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (LocRecErrStr + 'loCurrency');
    End; // If (DataRec.loCurrency <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[09] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loCurrency');
end;

//------------------------------

function TLocation.GetArea: cuStr5;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.loArea
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loArea');
end;
procedure TLocation.SetArea(Value: cuStr5);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[10] = paReadWrite) Then
  Begin
    If (DataRec.loArea <> Value) Then
    Begin
      DataRec.loArea := Value;
      RecChanged := True;
    End; // If (DataRec.loArea <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[10] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loArea');
end;

//------------------------------

function TLocation.GetRep: cuStr5;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.loRep
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loRep');
end;
procedure TLocation.SetRep(Value: cuStr5);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[11] = paReadWrite) Then
  Begin
    If (DataRec.loRep <> Value) Then
    Begin
      DataRec.loRep := Value;
      RecChanged := True;
    End; // If (DataRec.loRep <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[11] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loRep');
end;

//------------------------------

function TLocation.GetTagged: Boolean;
begin
  Result := False;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.loTag
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loTagged');
end;
procedure TLocation.SetTagged(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[12] = paReadWrite) Then
  Begin
    If (DataRec.loTag <> Value) Then
    Begin
      DataRec.loTag := Value;
      RecChanged := True;
    End; // If (DataRec.loTag <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[12] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loTagged');
end;

//------------------------------

function TLocation.GetCostCentre: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.loCCDep[BOn]
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loCostCentre');
end;
procedure TLocation.SetCostCentre(Value: cuStr3);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[13] = paReadWrite) Then
  Begin
    If (DataRec.loCCDep[BOn] <> Value) Then
    Begin
      DataRec.loCCDep[BOn] := Value;
      RecChanged := True;
    End; // If (DataRec.loCCDep[BOn] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[13] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loCostCentre');
end;

//------------------------------

function TLocation.GetDepartment: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.loCCDep[BOff]
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loDepartment');
end;
procedure TLocation.SetDepartment(Value: cuStr3);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[14] = paReadWrite) Then
  Begin
    If (DataRec.loCCDep[BOff] <> Value) Then
    Begin
      DataRec.loCCDep[BOff] := Value;
      RecChanged := True;
    End; // If (DataRec.loCCDep[BOff] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[14] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loDepartment');
end;

//------------------------------

function TLocation.GetOverrideSalesPrice: Boolean;
begin
  Result := False;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.loUsePrice
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loOverrideSalesPrice');
end;
procedure TLocation.SetOverrideSalesPrice(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[15] = paReadWrite) Then
  Begin
    If (DataRec.loUsePrice <> Value) Then
    Begin
      DataRec.loUsePrice := Value;
      RecChanged := True;
    End; // If (DataRec.loUsePrice <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[15] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loOverrideSalesPrice');
end;

//------------------------------

function TLocation.GetOverrideGLCodes: Boolean;
begin
  Result := False;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.loUseNom
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loOverrideGLCodes');
end;
procedure TLocation.SetOverrideGLCodes(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[16] = paReadWrite) Then
  Begin
    If (DataRec.loUseNom <> Value) Then
    Begin
      DataRec.loUseNom := Value;
      RecChanged := True;
    End; // If (DataRec.loUseNom <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[16] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loOverrideGLCodes');
end;

//------------------------------

function TLocation.GetOverrideCCDept: Boolean;
begin
  Result := False;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.loUseCCDep
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loOverrideCCDept');
end;
procedure TLocation.SetOverrideCCDept(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[17] = paReadWrite) Then
  Begin
    If (DataRec.loUseCCDep <> Value) Then
    Begin
      DataRec.loUseCCDep := Value;
      RecChanged := True;
    End; // If (DataRec.loUseCCDep <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[17] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loOverrideCCDept');
end;

//------------------------------

function TLocation.GetOverrideSupplier: Boolean;
begin
  Result := False;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.loUseSupp
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loOverrideSupplier');
end;
procedure TLocation.SetOverrideSupplier(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[18] = paReadWrite) Then
  Begin
    If (DataRec.loUseSupp <> Value) Then
    Begin
      DataRec.loUseSupp := Value;
      RecChanged := True;
    End; // If (DataRec.loUseSupp <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[18] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loOverrideSupplier');
end;

//------------------------------

function TLocation.GetOverrideBinLocation: Boolean;
begin
  Result := False;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.loUseBinLoc
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loOverrideBinLocation');
end;
procedure TLocation.SetOverrideBinLocation(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[19] = paReadWrite) Then
  Begin
    If (DataRec.loUseBinLoc <> Value) Then
    Begin
      DataRec.loUseBinLoc := Value;
      RecChanged := True;
    End; // If (DataRec.loUseBinLoc <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[19] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loOverrideBinLocation');
end;

//------------------------------

function TLocation.GetSalesGL: LongInt;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.loNominal[1]
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loSalesGL');
end;
procedure TLocation.SetSalesGL(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[20] = paReadWrite) Then
  Begin
    If (DataRec.loNominal[1] <> Value) Then
    Begin
      DataRec.loNominal[1] := Value;
      RecChanged := True;
    End; // If (DataRec.loNominal[1] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[20] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loSalesGL');
end;

//------------------------------

function TLocation.GetCostOfSalesGL: LongInt;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.loNominal[2]
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loCostOfSalesGL');
end;
procedure TLocation.SetCostOfSalesGL(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[21] = paReadWrite) Then
  Begin
    If (DataRec.loNominal[2] <> Value) Then
    Begin
      DataRec.loNominal[2] := Value;
      RecChanged := True;
    End; // If (DataRec.loNominal[2] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[21] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loCostOfSalesGL');
end;

//------------------------------

function TLocation.GetPandLGL: LongInt;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.loNominal[3]
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loPandLGL');
end;
procedure TLocation.SetPandLGL(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[22] = paReadWrite) Then
  Begin
    If (DataRec.loNominal[3] <> Value) Then
    Begin
      DataRec.loNominal[3] := Value;
      RecChanged := True;
    End; // If (DataRec.loNominal[3] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[22] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loPandLGL');
end;

//------------------------------

function TLocation.GetBalSheetGL: LongInt;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.loNominal[4]
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loBalSheetGL');
end;
procedure TLocation.SetBalSheetGL(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[23] = paReadWrite) Then
  Begin
    If (DataRec.loNominal[4] <> Value) Then
    Begin
      DataRec.loNominal[4] := Value;
      RecChanged := True;
    End; // If (DataRec.loNominal[4] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[23] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loBalSheetGL');
end;

//------------------------------

function TLocation.GetWIPGL: LongInt;
begin
  Result := 0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.loNominal[5]
  Else
    EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loWIPGL');
end;
procedure TLocation.SetWIPGL(Value: Integer);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[24] = paReadWrite) Then
  Begin
    If (DataRec.loNominal[5] <> Value) Then
    Begin
      DataRec.loNominal[5] := Value;
      RecChanged := True;
    End; // If (DataRec.loNominal[5] <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[24] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loWIPGL');
end;

//------------------------------

function TLocation.GetPurchaseReturnGL: LongInt;
begin
  Result := 0;
   {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.loPReturnGL
    Else
      EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loPurchaseReturnGL');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('loPurchaseReturnGL');
end;
procedure TLocation.SetPurchaseReturnGL(Value: Integer);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) And (PropAccess[25] = paReadWrite) Then
    Begin
      If (DataRec.loPReturnGL <> Value) Then
      Begin
        DataRec.loPReturnGL := Value;
        RecChanged := True;
      End; // If (DataRec.loPReturnGL <> Value)
    End // If (RecAccess <> NotAvailable) And (PropAccess[25] = paReadWrite)
    Else
      EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loPurchaseReturnGL');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('loPurchaseReturnGL');
end;

//------------------------------

function TLocation.GetSalesReturnGL: LongInt;
begin
  Result := 0;
   {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.loReturnGL
    Else
      EntSys.DataAccessErrDlg(True, LocRecErrStr + 'loSalesReturnGL');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('loSalesReturnGL');
end;
procedure TLocation.SetSalesReturnGL(Value: Integer);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    If (RecAccess <> NotAvailable) And (PropAccess[26] = paReadWrite) Then
    Begin
      If (DataRec.loReturnGL <> Value) Then
      Begin
        DataRec.loReturnGL := Value;
        RecChanged := True;
      End; // If (DataRec.loReturnGL <> Value)
    End // If (RecAccess <> NotAvailable) And (PropAccess[26] = paReadWrite)
    Else
      EntSys.DataAccessErrDlg(False, LocRecErrStr + 'loSalesReturnGL');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('loSalesReturnGL');
end;

//-------------------------------------------------------------------------

end.

