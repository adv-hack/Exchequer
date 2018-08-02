unit oJobRet;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TJobRetention = Class(TAbsJobRetention2)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..34] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : JobRetType;
  Protected
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function  GetAnalysisCode : cuStr10; Override;
    Procedure SetAnalysisCode(Value : cuStr10); Override;
    Function  GetOriginalCurrency : cuCurrencyType; Override;
    Procedure SetOriginalCurrency(Value : cuCurrencyType); Override;
    Function  GetYear : Byte; Override;
    Procedure SetYear(Value : Byte); Override;
    Function  GetPeriod : Byte; Override;
    Procedure SetPeriod(Value : Byte); Override;
    Function  GetPosted : Boolean; Override;
    Procedure SetPosted(Value : Boolean); Override;
    Function  GetPercent : Double; Override;
    Procedure SetPercent(Value : Double); Override;
    Function  GetCurrency : cuCurrencyType; Override;
    Procedure SetCurrency(Value : cuCurrencyType); Override;
    Function  GetValue : Double; Override;
    Procedure SetValue(Value : Double); Override;
    Function  GetJobCode : cuStr10; Override;
    Procedure SetJobCode(Value : cuStr10); Override;
    Function  GetCreditDoc : cuStr10; Override;
    Procedure SetCreditDoc(Value : cuStr10); Override;
    Function  GetExpiryDate : cuLongDate; Override;
    Procedure SetExpiryDate(Value : cuLongDate); Override;
    Function  GetInvoiced : Boolean; Override;
    Procedure SetInvoiced(Value : Boolean); Override;
    Function  GetAcCode : cuStr6; Override;
    Procedure SetAcCode(Value : cuStr6); Override;
    Function  GetEntryDate : cuLongDate; Override;
    Procedure SetEntryDate(Value : cuLongDate); Override;
    Function  GetCostCentre : cuStr3; Override;
    Procedure SetCostCentre(Value : cuStr3); Override;
    Function  GetDepartment : cuStr3; Override;
    Procedure SetDepartment(Value : cuStr3); Override;
    Function  GetDefVatCode : Char; Override;
    Procedure SetDefVatCode(Value : Char); Override;
    Function  GetTransaction : cuStr10; Override;
    Procedure SetTransaction(Value : cuStr10); Override;
    Function  GetCISTax : Double; Override;
    Procedure SetCISTax(Value : Double); Override;
    Function  GetCISGross : Double; Override;
    Procedure SetCISGross(Value : Double); Override;
    Function  GetCISEmployee : cuStr6; Override;
    Procedure SetCISEmployee(Value : cuStr6); Override;

    // TAbsJobRetention2
    Function  GetAppMode : Byte; Override;
    Procedure SetAppMode(Value : Byte); Override;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const JobDetl          : JobDetlRec);
  End; { TJobRetention }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2, oCcyTri;

Const
  ObjErrStr = 'Job Retention ';

//=========================================================================

Constructor TJobRetention.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  FillChar (DataRec, SizeOf (DataRec), #0);
  FillChar (OrigRec, SizeOf (OrigRec), #0);
End;

//------------------------------

Destructor TJobRetention.Destroy;
Begin { Destroy }
  EntSys := NIL;

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TJobRetention.Assign (Const WinId, HandlerId : LongInt;
                                Const JobDetl          : JobDetlRec);
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
    If (JobDetl.RecPfix = JBRCode) And (JobDetl.SubType = JBPCode) Then
      DataRec := JobDetl.JobReten
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

Function TJobRetention.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

//-------------------------------------------------------------------------

Function TJobRetention.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

//-------------------------------------------------------------------------

function TJobRetention.GetAnalysisCode: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AnalCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'AnalysisCode');
end;

procedure TJobRetention.SetAnalysisCode(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtAnalysisCode');
end;

//------------------------------

function TJobRetention.GetOriginalCurrency: cuCurrencyType;
begin
  Result := Low(cuCurrencyType);
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OrgCurr
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'OriginalCurrency');
end;

procedure TJobRetention.SetOriginalCurrency(Value: cuCurrencyType);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtOriginalCurrency');
end;

//------------------------------

function TJobRetention.GetYear: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetYr
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Year');
end;

procedure TJobRetention.SetYear(Value: Byte);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtYear');
end;

//------------------------------

function TJobRetention.GetPeriod: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetPr
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Period');
end;

procedure TJobRetention.SetPeriod(Value: Byte);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtPeriod');
end;

//------------------------------

function TJobRetention.GetPosted: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Posted
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Posted');
end;

procedure TJobRetention.SetPosted(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtPosted');
end;

//------------------------------

function TJobRetention.GetPercent: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetDisc
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Percent');
end;

procedure TJobRetention.SetPercent(Value: Double);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtPercent');
end;

//------------------------------

function TJobRetention.GetCurrency: cuCurrencyType;
begin
  Result := Low(cuCurrencyType);
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetCurr
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Currency');
end;

procedure TJobRetention.SetCurrency(Value: cuCurrencyType);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtCurrency');
end;

//------------------------------

function TJobRetention.GetValue: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetValue
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'RetValue');
end;

procedure TJobRetention.SetValue(Value: Double);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtValue');
end;

//------------------------------

function TJobRetention.GetJobCode: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JobCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'JobCode');
end;

procedure TJobRetention.SetJobCode(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtJobCode');
end;

//------------------------------

function TJobRetention.GetCreditDoc: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetCrDoc
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CreditDoc');
end;

procedure TJobRetention.SetCreditDoc(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtCreditDoc');
end;

//------------------------------

function TJobRetention.GetExpiryDate: cuLongDate;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetDate
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'ExpiryDate');
end;

procedure TJobRetention.SetExpiryDate(Value: cuLongDate);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtExpiryDate');
end;

//------------------------------

function TJobRetention.GetInvoiced: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Invoiced
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Invoiced');
end;

procedure TJobRetention.SetInvoiced(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtInvoiced');
end;

//------------------------------

function TJobRetention.GetAcCode: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetCustCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'AcCode');
end;

procedure TJobRetention.SetAcCode(Value: cuStr6);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtAcCode');
end;

//------------------------------

function TJobRetention.GetEntryDate: cuLongDate;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OrigDate
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'EntryDate');
end;

procedure TJobRetention.SetEntryDate(Value: cuLongDate);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtEntryDate');
end;

//------------------------------

function TJobRetention.GetCostCentre: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetCCDep[BOn]
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CostCentre');
end;

procedure TJobRetention.SetCostCentre(Value: cuStr3);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtCostCentre');
end;

//------------------------------

function TJobRetention.GetDepartment: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetCCDep[BOff]
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Department');
end;

procedure TJobRetention.SetDepartment(Value: cuStr3);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtDepartment');
end;

//------------------------------

function TJobRetention.GetDefVatCode: Char;
begin
  Result := #0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DefVATCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DefVATCode');
end;

procedure TJobRetention.SetDefVatCode(Value: Char);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtDefVatCode');
end;

//------------------------------

function TJobRetention.GetTransaction: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetDoc
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Transaction');
end;

procedure TJobRetention.SetTransaction(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtTransaction');
end;

//------------------------------

function TJobRetention.GetCISTax: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetCISTax
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CISTax');
end;

procedure TJobRetention.SetCISTax(Value: Double);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtCISTax');
end;

//------------------------------

function TJobRetention.GetCISGross: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetCISGross
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CISGross');
end;

procedure TJobRetention.SetCISGross(Value: Double);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtCISGross');
end;

//------------------------------

function TJobRetention.GetCISEmployee: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetCISEmpl
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CISEmployee');
end;

procedure TJobRetention.SetCISEmployee(Value: cuStr6);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtCISEmployee');
end;

//------------------------------

Function TJobRetention.GetAppMode : Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RetAppMode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'AppMode');
end;

Procedure TJobRetention.SetAppMode(Value : Byte);
begin
  EntSys.NotImplException ('TAbsJobRetention.jrtAppMode');
end;

//-------------------------------------------------------------------------

end.
