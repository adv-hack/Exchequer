unit oAnalCod;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TJobAnalysis = Class(TAbsJobAnalysis2)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..7] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : JobAnalType;
  Protected
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function  GetCode : cuStr10; Override;
    Procedure SetCode(Value : cuStr10); Override;
    Function  GetDescription : cuStr30; Override;
    Procedure SetDescription(Value : cuStr30); Override;
    Function  GetType : Smallint; Override;
    Procedure SetType(Value : Smallint); Override;
    Function  GetCategory : Smallint; Override;
    Procedure SetCategory(Value : Smallint); Override;
    Function  GetWIPGL : LongInt; Override;
    Procedure SetWIPGL(Value : LongInt); Override;
    Function  GetPandLGL : LongInt; Override;
    Procedure SetPandLGL(Value : LongInt); Override;
    Function  GetLineType : cuLineTIndex; Override;
    Procedure SetLineType(Value : cuLineTIndex); Override;

    // TAbsJobAnalysis2
    Function  GetDeductType : Byte; Override;
    Procedure SetDeductType(Value : Byte); Override;
    Function  GetCalcDeductBeforeRetent : Boolean; Override;
    Procedure SetCalcDeductBeforeRetent(Value : Boolean); Override;
    Function  GetDeductAnalysisMode : Byte; Override;
    Procedure SetDeductAnalysisMode(Value : Byte); Override;
    Function  GetRetentionType : Byte; Override;
    Procedure SetRetentionType(Value : Byte); Override;
    Function  GetRetentionPercentage : Double; Override;
    Procedure SetRetentionPercentage(Value : Double); Override;
    Function  GetRetentionExpiryMode : Byte; Override;
    Procedure SetRetentionExpiryMode(Value : Byte); Override;
    Function  GetRetentionExpiryInterval : Byte; Override;
    Procedure SetRetentionExpiryInterval(Value : Byte); Override;
    Function  GetPreserveToRetentention : Boolean; Override;
    Procedure SetPreserveToRetentention(Value : Boolean); Override;
    Function  GetDeductCalcMode : Byte; Override;
    Procedure SetDeductCalcMode(Value : Byte); Override;
    Function  GetPayrollDeductCode : cuStr5; Override;
    Procedure SetPayrollDeductCode(Value : cuStr5); Override;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const AnalRec          : JobMiscRec);
  End; { TTimeRate }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  ObjErrStr = 'Analysis Code ';

//=========================================================================

Constructor TJobAnalysis.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  FillChar (DataRec, SizeOf (DataRec), #0);
  FillChar (OrigRec, SizeOf (OrigRec), #0);
End;

//------------------------------

Destructor TJobAnalysis.Destroy;
Begin { Destroy }
  EntSys := NIL;

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TJobAnalysis.Assign (Const WinId, HandlerId : LongInt;
                               Const AnalRec          : JobMiscRec);
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
    If (AnalRec.RecPfix = JARCode) And (AnalRec.SubType = JAACode) Then
      DataRec := AnalRec.JobAnalRec
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

Function TJobAnalysis.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

//-------------------------------------------------------------------------

Function TJobAnalysis.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

//-------------------------------------------------------------------------

function TJobAnalysis.GetCode: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JAnalCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Code');
  End; { Else }
end;

procedure TJobAnalysis.SetCode(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anCode');
end;

//------------------------------

function TJobAnalysis.GetDescription: cuStr30;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JAnalName
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Description');
  End; { Else }
end;

procedure TJobAnalysis.SetDescription(Value: cuStr30);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anDescription');
end;

//------------------------------

function TJobAnalysis.GetType: Smallint;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JAType
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Type');
  End; { Else }
end;

procedure TJobAnalysis.SetType(Value: Smallint);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anType');
end;

//------------------------------

function TJobAnalysis.GetCategory: Smallint;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AnalHed
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Category');
  End; { Else }
end;

procedure TJobAnalysis.SetCategory(Value: Smallint);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anCatagory');
end;

//------------------------------

function TJobAnalysis.GetWIPGL: LongInt;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.WIPNom[BOff]
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'WIPGL');
  End; { Else }
end;

procedure TJobAnalysis.SetWIPGL(Value: Integer);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anWIPGL');
end;

//------------------------------

function TJobAnalysis.GetPandLGL: LongInt;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.WIPNom[BOn]
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'PandLGL');
  End; { Else }
end;

procedure TJobAnalysis.SetPandLGL(Value: Integer);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anPandLGL');
end;

//------------------------------

function TJobAnalysis.GetLineType: cuLineTIndex;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JLinkLT
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'LineType');
  End; { Else }
end;

procedure TJobAnalysis.SetLineType(Value: cuLineTIndex);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anLineType');
end;

//------------------------------

function TJobAnalysis.GetDeductType : Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JADetType
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DeductType');
end;

procedure TJobAnalysis.SetDeductType(Value : Byte);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anDeductType');
end;

//------------------------------

function TJobAnalysis.GetCalcDeductBeforeRetent : Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JACalcB4Ret
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CalcDeductBeforeRetent');
end;

procedure TJobAnalysis.SetCalcDeductBeforeRetent(Value : Boolean);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anCalcDeductBeforeRetent');
end;

//------------------------------

function TJobAnalysis.GetDeductAnalysisMode : Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JADedApply
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DeductAnalysisMode');
end;

procedure TJobAnalysis.SetDeductAnalysisMode(Value : Byte);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anDeductAnalysisMode');
end;

//------------------------------

function TJobAnalysis.GetRetentionType : Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JARetType
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'RetentionType');
end;

procedure TJobAnalysis.SetRetentionType(Value : Byte);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anRetentionType');
end;

//------------------------------

function TJobAnalysis.GetRetentionPercentage : Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JARetValue
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'RetentionPercentage');
end;

procedure TJobAnalysis.SetRetentionPercentage(Value : Double);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anRetentionPercentage');
end;

//------------------------------

function TJobAnalysis.GetRetentionExpiryMode : Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JARetExp
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'RetentionExpiryMode');
end;

procedure TJobAnalysis.SetRetentionExpiryMode(Value : Byte);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anRetentionExpiryMode');
end;

//------------------------------

function TJobAnalysis.GetRetentionExpiryInterval : Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JARetExpInt
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'RetentionExpiryInterval');
end;

procedure TJobAnalysis.SetRetentionExpiryInterval(Value : Byte);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anRetentionExpiryInterval');
end;

//------------------------------

function TJobAnalysis.GetPreserveToRetentention : Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JARetPres
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'PreserveToRetentention');
end;

procedure TJobAnalysis.SetPreserveToRetentention(Value : Boolean);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anPreserveToRetentention');
end;

//------------------------------

function TJobAnalysis.GetDeductCalcMode : Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JADedComp
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DeductCalcMode');
end;

procedure TJobAnalysis.SetDeductCalcMode(Value : Byte);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anDeductCalcMode');
end;

//------------------------------

function TJobAnalysis.GetPayrollDeductCode : cuStr5;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JAPayCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'PayrollDeductCode');
end;

procedure TJobAnalysis.SetPayrollDeductCode(Value : cuStr5);
begin
  EntSys.NotImplException ('TAbsJobAnalysis.anPayrollDeductCode');
end;

//-------------------------------------------------------------------------

end.
