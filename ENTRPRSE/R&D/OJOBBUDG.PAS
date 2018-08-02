unit oJobBudg;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TJobBudget = Class(TAbsJobBudget3)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..35] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : JobBudgType;
    FBudgetType      : Byte;
  Protected
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function  GetBudgetType : Byte; Override;
    Procedure SetBudgetType(Value : Byte); Override;
    Function  GetJobCode : cuStr10; Override;
    Procedure SetJobCode(Value : cuStr10); Override;
    Function  GetStockCode : cuStr16; Override;
    Procedure SetStockCode(Value : cuStr16); Override;
    Function  GetAnalysisCode : cuStr10; Override;
    Procedure SetAnalysisCode(Value : cuStr10); Override;
    Function  GetType : Byte; Override;
    Procedure SetType(Value : Byte); Override;
    Function  GetUnitPrice : Double; Override;
    Procedure SetUnitPrice(Value : Double); Override;
    Function  GetOriginalQty : Double; Override;
    Procedure SetOriginalQty(Value : Double); Override;
    Function  GetRevisedQty : Double; Override;
    Procedure SetRevisedQty(Value : Double); Override;
    Function  GetOriginalValue : Double; Override;
    Procedure SetOriginalValue(Value : Double); Override;
    Function  GetRevisedValue : Double; Override;
    Procedure SetRevisedValue(Value : Double); Override;
    Function  GetOriginalValuation : Double; Override;
    Procedure SetOriginalValuation(Value : Double); Override;
    Function  GetRevisedValuation : Double; Override;
    Procedure SetRevisedValuation(Value : Double); Override;
    Function  GetUplift : Double; Override;
    Procedure SetUplift(Value : Double); Override;
    Function  GetRecharge : Boolean; Override;
    Procedure SetRecharge(Value : Boolean); Override;
    Function  GetCostOverhead : Double; Override;
    Procedure SetCostOverhead(Value : Double); Override;

    // TAbsJobBudget2
    Function  GetOrigValuation : Double; Override;
    Procedure SetOrigValuation(Value : Double); Override;
    Function  GetRevValuation : Double; Override;
    Procedure SetRevValuation(Value : Double); Override;
    Function  GetValuationPercentage : Double; Override;
    Procedure SetValuationPercentage(Value : Double); Override;
    Function  GetValuationBasis : Byte; Override;
    Procedure SetValuationBasis(Value : Byte); Override;

    // TAbsJobBudget3
    Function  GetBudgetCurrency : Byte; Override;
    Procedure SetBudgetCurrency(Value : Byte); Override;

  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const JobCtrl          : JobCtrlRec);
  End; { TJobBudget }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  ObjErrStr = 'Job Budget ';

//=========================================================================

Constructor TJobBudget.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  FillChar (DataRec, SizeOf (DataRec), #0);
  FillChar (OrigRec, SizeOf (OrigRec), #0);
End;

//------------------------------

Destructor TJobBudget.Destroy;
Begin { Destroy }
  EntSys := NIL;

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TJobBudget.Assign (Const WinId, HandlerId : LongInt;
                             Const JobCtrl          : JobCtrlRec);
Var
  I : SmallInt;
Begin { Assign }
  { Set Security Access to Record }
  Case WinId of
    EnterpriseBase+2000,  // Transaction
    EnterpriseBase+4000,  // Transaction Line
    EnterpriseBase+5000   // Job Details
                          :  RecAccess:=ReadOnly;
  Else
    RecAccess:=NotAvailable;
  End; { If }

  { Load fields from ExLocal }
  FillChar (DataRec, SizeOf (DataRec), #0);
  FBudgetType := 0;
  RecChanged := False;
  If (RecAccess <> NotAvailable) Then Begin
    If (JobCtrl.RecPfix = JBRCode) And (JobCtrl.SubType In [JBBCode, JBMCode, JBSCode]) Then Begin
      DataRec := JobCtrl.JobBudg;

      // Identify Budget Type
      If (JobCtrl.SubType = JBBCode) Then
        // Analysis Code
        FBudgetType := 1
      Else
        If (JobCtrl.SubType = JBMCode) Then
          // Totals
          FBudgetType := 2
        Else
          If (JobCtrl.SubType = JBSCode) Then Begin
            // Stock or TimeRate
            If JobCtrl.JobBudg.PayRMode Then
              FBudgetType := 4
            Else
              FBudgetType := 3;
          End; { If (JobCtrl.SubType = JBSCode) }
    End { If (JobCtrl.RecPfix... }
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
      { Serial/Batch Entry - Enter Batch Number }

      105000075 : Begin
                    PropAccess[06] := paReadWrite;    { Unit Price }
                    PropAccess[07] := paReadWrite;    { Orig Qty }
                    PropAccess[08] := paReadWrite;    { Revised Qty }
                    PropAccess[09] := paReadWrite;    { Original Value}
                    PropAccess[10] := paReadWrite;    { Revised Value}
                    
                    PropAccess[14] := paReadWrite;    { Recharge }
                    PropAccess[15] := paReadWrite;    { Cost Overhead }

                  end;
    End; { Case }

  End; { If }
End; { Assign }

//-------------------------------------------------------------------------

Function TJobBudget.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

//-------------------------------------------------------------------------

Function TJobBudget.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

//-------------------------------------------------------------------------

Function TJobBudget.GetBudgetType : Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := FBudgetType
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Type');
end;

Procedure TJobBudget.SetBudgetType(Value : Byte);
begin
  EntSys.NotImplException ('TAbsJobBudget.jbBudgetType');
end;

//------------------------------

function TJobBudget.GetType: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BType
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Type');
end;

procedure TJobBudget.SetType(Value: Byte);
begin
  EntSys.NotImplException ('TAbsJobBudget.jbType');
end;

//------------------------------

function TJobBudget.GetUnitPrice: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UnitPrice
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'UnitPrice');
end;

procedure TJobBudget.SetUnitPrice(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[6] = paReadWrite) Then Begin
    If (DataRec.UnitPrice <> Value) Then Begin
      DataRec.UnitPrice := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, ObjErrStr + 'UnitPrice');
end;

//------------------------------

function TJobBudget.GetOriginalQty: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BoQty
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'OriginalQty');
end;

procedure TJobBudget.SetOriginalQty(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[7] = paReadWrite) Then Begin
    If (DataRec.BoQty <> Value) Then Begin
      DataRec.BoQty := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, ObjErrStr + 'OriginalQty');
end;

//------------------------------

function TJobBudget.GetRevisedQty: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BRQty
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'RevisedQty');
end;

procedure TJobBudget.SetRevisedQty(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[8] = paReadWrite) Then Begin
    If (DataRec.BRQty <> Value) Then Begin
      DataRec.BRQty := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, ObjErrStr + 'RevisedQty');
end;

//------------------------------

function TJobBudget.GetOriginalValue: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BoValue
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'OriginalValue');
end;

procedure TJobBudget.SetOriginalValue(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[9] = paReadWrite) Then Begin
    If (DataRec.BoValue <> Value) Then Begin
      DataRec.BoValue := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, ObjErrStr + 'OriginalValue');
end;

//------------------------------

function TJobBudget.GetRevisedValue: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BRValue
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'RevisedValue');
end;

procedure TJobBudget.SetRevisedValue(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[10] = paReadWrite) Then Begin
    If (DataRec.BRValue <> Value) Then Begin
      DataRec.BRValue := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, ObjErrStr + 'RevisedValue');
end;

//------------------------------

function TJobBudget.GetOriginalValuation: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OrigValuation
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'OriginalValuation');
end;

procedure TJobBudget.SetOriginalValuation(Value: Double);
begin
  EntSys.NotImplException ('TAbsJobBudget.jbOriginalValuation');
end;

//------------------------------

function TJobBudget.GetRevisedValuation: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RevValuation
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'RevisedValuation');
end;

procedure TJobBudget.SetRevisedValuation(Value: Double);
begin
  EntSys.NotImplException ('TAbsJobBudget.jbRevisedValuation');
end;

//------------------------------

function TJobBudget.GetUplift: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JBUpliftP
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Uplift');
end;

procedure TJobBudget.SetUplift(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[13] = paReadWrite) Then Begin
    If (DataRec.JBUpliftP <> Value) Then Begin
      DataRec.JBUpliftP := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, ObjErrStr + 'Uplift');
end;

//------------------------------

function TJobBudget.GetJobCode: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JobCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'JobCode');
end;

procedure TJobBudget.SetJobCode(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsJobBudget.jbJobCode');
end;

//------------------------------

function TJobBudget.GetStockCode: cuStr16;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StockCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'StockCode');
end;

procedure TJobBudget.SetStockCode(Value: cuStr16);
begin
  EntSys.NotImplException ('TAbsJobBudget.jbStockCode');
end;

//------------------------------

function TJobBudget.GetAnalysisCode: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AnalCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'AnalysisCode');
end;

procedure TJobBudget.SetAnalysisCode(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsJobBudget.jbAnalysisCode');
end;

//------------------------------

function TJobBudget.GetRecharge: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ReCharge
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'ReCharge');
end;

procedure TJobBudget.SetRecharge(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[14] = paReadWrite) Then Begin
    If (DataRec.ReCharge <> Value) Then Begin
      DataRec.ReCharge := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, ObjErrStr + 'ReCharge');
end;

//------------------------------

function TJobBudget.GetCostOverhead: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OverCost
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CostOverhead');
end;

procedure TJobBudget.SetCostOverhead(Value: Double);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[15] = paReadWrite) Then Begin
    If (DataRec.OverCost <> Value) Then Begin
      DataRec.OverCost := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, ObjErrStr + 'CostOverhead');
end;

//------------------------------

Function  TJobBudget.GetOrigValuation : Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OrigValuation
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'OrigValuation');
end;

Procedure TJobBudget.SetOrigValuation(Value : Double);
begin
  EntSys.NotImplException ('TJobBudget.jbOrigValuation');
End;

//------------------------------

Function  TJobBudget.GetRevValuation : Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RevValuation
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'RevValuation');
end;

Procedure TJobBudget.SetRevValuation(Value : Double);
begin
  EntSys.NotImplException ('TJobBudget.jbRevValuation');
End;

//------------------------------

Function TJobBudget.GetValuationPercentage : Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JAPcntApp
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'ValuationPercentage');
end;

Procedure TJobBudget.SetValuationPercentage(Value : Double);
begin
  EntSys.NotImplException ('TJobBudget.jbValuationPercentage');
End;

//------------------------------

Function  TJobBudget.GetValuationBasis : Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JABBasis
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'ValuationBasis');
end;

Procedure TJobBudget.SetValuationBasis(Value : Byte);
begin
  EntSys.NotImplException ('TJobBudget.jbValuationBasis');
End;

//-------------------------------------------------------------------------

function TJobBudget.GetBudgetCurrency: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JBudgetCurr
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'BudgetCurrency');
end;

procedure TJobBudget.SetBudgetCurrency(Value: Byte);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[20] = paReadWrite) Then Begin
    If (DataRec.JBudgetCurr <> Value) Then Begin
      If EntSys.ValidCcy (Value) Then Begin
        DataRec.JBudgetCurr := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (ObjErrStr + 'BudgetCurrency');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, ObjErrStr + 'BudgetCurrency');
end;

//-------------------------------------------------------------------------

end.
