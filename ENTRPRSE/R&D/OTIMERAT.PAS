unit oTimeRat;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TTimeRate = Class(TAbsTimeRate)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..22] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : EmplPayType;
  Protected
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function  GetRateCode : cuStr10; Override;
    Procedure SetRateCode(Value : cuStr10); Override;
    Function  GetEmployeeCode : cuStr6; Override;
    Procedure SetEmployeeCode(Value : cuStr6); Override;
    Function  GetCostCurrency : Byte; Override;
    Procedure SetCostCurrency(Value : Byte); Override;
    Function  GetTimeCost : Double; Override;
    Procedure SetTimeCost(Value : Double); Override;
    Function  GetChargeCurrency : Byte; Override;
    Procedure SetChargeCurrency(Value : Byte); Override;
    Function  GetTimeCharge : Double; Override;
    Procedure SetTimeCharge(Value : Double); Override;
    Function  GetAnalysisCode : cuStr10; Override;
    Procedure SetAnalysisCode(Value : cuStr10); Override;
    Function  GetDescription : cuStr30; Override;
    Procedure SetDescription(Value : cuStr30); Override;
    Function  GetPayFactor : Smallint; Override;
    Procedure SetPayFactor(Value : Smallint); Override;
    Function  GetPayRate : Smallint; Override;
    Procedure SetPayRate(Value : Smallint); Override;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const TimeRateRec      : JobCtrlRec);
  End; { TTimeRate }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  ObjErrStr = 'Time Rate ';

//=========================================================================

Constructor TTimeRate.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  FillChar (DataRec, SizeOf (DataRec), #0);
  FillChar (OrigRec, SizeOf (OrigRec), #0);
End;

//------------------------------

Destructor TTimeRate.Destroy;
Begin { Destroy }
  EntSys := NIL;

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TTimeRate.Assign (Const WinId, HandlerId : LongInt;
                            Const TimeRateRec      : JobCtrlRec);
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
    If (TimeRateRec.RecPfix = JBRCode) And (TimeRateRec.SubType In [JBECode, JBPCode]) Then
      DataRec := TimeRateRec.EmplPay
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

Function TTimeRate.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

//-------------------------------------------------------------------------

Function TTimeRate.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

//-------------------------------------------------------------------------

function TTimeRate.GetRateCode: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.EStockCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'RateCode');
  End; { Else }
end;

procedure TTimeRate.SetRateCode(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsTimeRate.trRateCode');
end;

//------------------------------

function TTimeRate.GetEmployeeCode: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.EmpCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'EmployeeCode');
  End; { Else }
end;

procedure TTimeRate.SetEmployeeCode(Value: cuStr6);
begin
  EntSys.NotImplException ('TAbsTimeRate.trEmployeeCode');
end;

//------------------------------

function TTimeRate.GetCostCurrency: Byte;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CostCurr
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CostCurrency');
  End; { Else }
end;

procedure TTimeRate.SetCostCurrency(Value: Byte);
begin
  EntSys.NotImplException ('TAbsTimeRate.trCostCurrency');
end;

//------------------------------

function TTimeRate.GetTimeCost: Double;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Cost
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'TimeCost');
  End; { Else }
end;

procedure TTimeRate.SetTimeCost(Value: Double);
begin
  EntSys.NotImplException ('TAbsTimeRate.trTimeCost');
end;

//------------------------------

function TTimeRate.GetChargeCurrency: Byte;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ChargeCurr
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'ChargeCurrency');
  End; { Else }
end;

procedure TTimeRate.SetChargeCurrency(Value: Byte);
begin
  EntSys.NotImplException ('TAbsTimeRate.trChargeCurrency');
end;

//------------------------------

function TTimeRate.GetTimeCharge: Double;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ChargeOut
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'TimeCharge');
  End; { Else }
end;

procedure TTimeRate.SetTimeCharge(Value: Double);
begin
  EntSys.NotImplException ('TAbsTimeRate.trTimeCharge');
end;

//------------------------------

function TTimeRate.GetAnalysisCode: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.EAnalCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'AnalysisCode');
  End; { Else }
end;

procedure TTimeRate.SetAnalysisCode(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsTimeRate.trAnalysisCode');
end;

//------------------------------

function TTimeRate.GetDescription: cuStr30;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PayRDesc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Description');
  End; { Else }
end;

procedure TTimeRate.SetDescription(Value: cuStr30);
begin
  EntSys.NotImplException ('TAbsTimeRate.trDescription');
end;

//------------------------------

function TTimeRate.GetPayFactor: Smallint;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PayRFact
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'PayFactor');
  End; { Else }
end;

procedure TTimeRate.SetPayFactor(Value: Smallint);
begin
  EntSys.NotImplException ('TAbsTimeRate.trPayFactor');
end;

//------------------------------

function TTimeRate.GetPayRate: Smallint;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PayRRate
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'PayRate');
  End; { Else }
end;

procedure TTimeRate.SetPayRate(Value: Smallint);
begin
  EntSys.NotImplException ('TAbsTimeRate.trPayRate');
end;

//-------------------------------------------------------------------------


end.
