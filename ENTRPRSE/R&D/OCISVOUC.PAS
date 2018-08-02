unit oCISVouc;

Interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TCISVoucher = Class(TAbsCISVoucher)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..17] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : JobCISType;
  Protected
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function  GetNumber : cuStr10; Override;
    Procedure SetNumber(Value : cuStr10); Override;
    Function  GetEmployee : cuStr6; Override;
    Procedure SetEmployee(Value : cuStr6); Override;
    Function  GetDate : cuLongDate; Override;
    Procedure SetDate(Value : cuLongDate); Override;
    Function  GetTransaction : cuStr10; Override;
    Procedure SetTransaction(Value : cuStr10); Override;
    Function  GetFolio : LongInt; Override;
    Function  GetCertificateNo : cuStr14; Override;
    Procedure SetCertificateNo(Value : cuStr14); Override;
    Function  GetGrossTotal : Double; Override;
    Procedure SetGrossTotal(Value : Double); Override;
    Function  GetType : Byte; Override;
    Procedure SetType(Value : Byte); Override;
    Function  GetAutoTotalTax : Double; Override;
    Procedure SetAutoTotalTax(Value : Double); Override;
    Function  GetManualTax : Boolean; Override;
    Procedure SetManualTax(Value : Boolean); Override;
    Function  GetTaxableTotal : Double; Override;
    Procedure SetTaxableTotal(Value : Double); Override;
    Function  GetCurrency : Byte; Override;
    Procedure SetCurrency(Value : Byte); Override;
    Function  GetAddress(Index : cuAddrIndex) : cuStr30; Override;
    Procedure SetAddress(Index : cuAddrIndex; Value : cuStr30); Override;
    Function  GetBehalf : cuStr80; Override;
    Procedure SetBehalf(Value : cuStr80); Override;
    Function  GetCorrection : Boolean; Override;
    Procedure SetCorrection(Value : Boolean); Override;
    Function  GetTaxDue : Double; Override;
    Procedure SetTaxDue(Value : Double); Override;
    Function  GetSupplier : cuStr6; Override;
    Procedure SetSupplier(Value : cuStr6); Override;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const CISRec           : JobDetlRec);
  End; { TCISVoucher }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  CISRecErrStr = 'CIS Voucher ';

//=========================================================================

Constructor TCISVoucher.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  FillChar (DataRec, SizeOf (DataRec), #0);
  FillChar (OrigRec, SizeOf (OrigRec), #0);
End;

//------------------------------

Destructor TCISVoucher.Destroy;
Begin { Destroy }
  EntSys := NIL;

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TCISVoucher.Assign (Const WinId, HandlerId : LongInt;
                              Const CISRec           : JobDetlRec);
Var
  I : SmallInt;
Begin { Assign }
  { Set Security Access to Record }
  If (WinId = wiJobRec) Then
    RecAccess:=ReadOnly
  Else
    RecAccess:=NotAvailable;

  { Load fields from ExLocal }
  FillChar (DataRec, SizeOf (DataRec), #0);
  RecChanged := False;
  If (RecAccess <> NotAvailable) Then Begin
    If (CISRec.RecPfix = JATCode) And (CISRec.SubType = JBSCode) Then
      DataRec := CISRec.JobCISV
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
    //Case ((WinId * 1000) + HandlerId) Of

      // Enable Writeable fields here for each hook point

    //End; { Case ((WinId * 1000) + HandlerId) }
  End; { If }
End; { Assign }

//-------------------------------------------------------------------------

Function TCISVoucher.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

//-------------------------------------------------------------------------

Function TCISVoucher.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

//-------------------------------------------------------------------------

function TCISVoucher.GetNumber: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISCertNo
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'Number');
  End; { Else }
end;

procedure TCISVoucher.SetNumber(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvNumber');
end;

//------------------------------

function TCISVoucher.GetEmployee: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := Copy (DataRec.CISvCode1, 1, 6)
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'Employee');
  End; { Else }
end;

procedure TCISVoucher.SetEmployee(Value: cuStr6);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvEmployee');
end;

//------------------------------

function TCISVoucher.GetDate: cuLongDate;
begin
  If (RecAccess <> NotAvailable) Then
    Result := Copy (DataRec.CISVCode2, 1, 8)
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'Date');
  End; { Else }
end;

procedure TCISVoucher.SetDate(Value: cuLongDate);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvDate');
end;

//------------------------------

function TCISVoucher.GetTransaction: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISVORef
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'Transaction');
  End; { Else }
end;

procedure TCISVoucher.SetTransaction(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvTransaction');
end;

//------------------------------

function TCISVoucher.GetFolio: LongInt;
begin
  If (RecAccess <> NotAvailable) Then
    Move(DataRec.CISFolio[1], Result, SizeOf(Result))
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'Folio');
  End; { Else }
end;

//------------------------------

function TCISVoucher.GetCertificateNo: cuStr14;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISVCert
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'CertificateNo');
  End; { Else }
end;

procedure TCISVoucher.SetCertificateNo(Value: cuStr14);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvCertificateNo');
end;

//------------------------------

function TCISVoucher.GetGrossTotal: Double;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISVGrossTotal
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'GrossTotal');
  End; { Else }
end;

procedure TCISVoucher.SetGrossTotal(Value: Double);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvGrossTotal');
end;

//------------------------------

function TCISVoucher.GetType: Byte;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISCType
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'Type');
  End; { Else }
end;

procedure TCISVoucher.SetType(Value: Byte);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvType');
end;

//------------------------------

function TCISVoucher.GetAutoTotalTax: Double;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISvAutoTotalTax
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'AutoTotalTax');
  End; { Else }
end;

procedure TCISVoucher.SetAutoTotalTax(Value: Double);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvAutoTotalTax');
end;

//------------------------------

function TCISVoucher.GetManualTax: Boolean;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISvManualTax
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'ManualTax');
  End; { Else }
end;

procedure TCISVoucher.SetManualTax(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvManualTax');
end;

//------------------------------

function TCISVoucher.GetTaxableTotal: Double;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISTaxableTotal
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'TaxableTotal');
  End; { Else }
end;

procedure TCISVoucher.SetTaxableTotal(Value: Double);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvTaxableTotal');
end;

//------------------------------

function TCISVoucher.GetCurrency: Byte;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISCurr
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'Currency');
  End; { Else }
end;

procedure TCISVoucher.SetCurrency(Value: Byte);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvCurrency');
end;

//------------------------------

function TCISVoucher.GetAddress(Index: cuAddrIndex): cuStr30;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISAddr[Index]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'Address');
  End; { Else }
end;

procedure TCISVoucher.SetAddress(Index: cuAddrIndex; Value: cuStr30);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvAddress');
end;

//------------------------------

function TCISVoucher.GetBehalf: cuStr80;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISBehalf
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'Behalf');
  End; { Else }
end;

procedure TCISVoucher.SetBehalf(Value: cuStr80);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvBehalf');
end;

//------------------------------

function TCISVoucher.GetCorrection: Boolean;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISCorrect
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'Correction');
  End; { Else }
end;

procedure TCISVoucher.SetCorrection(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvCorrection');
end;

//------------------------------

function TCISVoucher.GetTaxDue: Double;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISVTaxDue
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'TaxDue');
  End; { Else }
end;

procedure TCISVoucher.SetTaxDue(Value: Double);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvTaxDue');
end;

//------------------------------

function TCISVoucher.GetSupplier: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := Copy(DataRec.CISVSDate, 1, CustKeyLen)
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CISRecErrStr + 'Supplier');
  End; { Else }
end;

procedure TCISVoucher.SetSupplier(Value: cuStr6);
begin
  EntSys.NotImplException ('TAbsCISVoucher.cvSupplier');
end;

//-------------------------------------------------------------------------

end.
