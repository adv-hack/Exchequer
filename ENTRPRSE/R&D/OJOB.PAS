unit OJob;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU, ExWrap1U, oJobAct, oJobBudg, oJobRet;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TJob = Class(TAbsJob5)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..39] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : JobRecPtr;

    FJobActual    : TAbsJobActual;
    FJobBudget    : TAbsJobBudget;
    FJobRetention : TAbsJobRetention;
  Protected
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function  GetJobCode : cuStr10; Override;
    Procedure SetJobCode(Value : cuStr10); Override;
    Function  GetJobDesc : cuStr30; Override;
    Procedure SetJobDesc(Value : cuStr30); Override;
    Function  GetJobFolio : LongInt; Override;
    Procedure SetJobFolio(Value : LongInt); Override;
    Function  GetCustCode : cuStr10; Override;
    Procedure SetCustCode(Value : cuStr10); Override;
    Function  GetJobCat : cuStr10; Override;
    Procedure SetJobCat(Value : cuStr10); Override;
    Function  GetJobAltCode : cuStr10; Override;
    Procedure SetJobAltCode(Value : cuStr10); Override;
    Function  GetCompleted : LongInt; Override;
    Procedure SetCompleted(Value : LongInt); Override;
    Function  GetContact : cuStr25; Override;
    Procedure SetContact(Value : cuStr25); Override;
    Function  GetJobMan : cuStr25; Override;
    Procedure SetJobMan(Value : cuStr25); Override;
    Function  GetChargeType : SmallInt; Override;
    Procedure SetChargeType(Value : SmallInt); Override;
    Function  GetQuotePrice : Double; Override;
    Procedure SetQuotePrice(Value : Double); Override;
    Function  GetCurrPrice : Byte; Override;
    Procedure SetCurrPrice(Value : Byte); Override;
    Function  GetStartDate : cuLongDate; Override;
    Procedure SetStartDate(Value : cuLongDate); Override;
    Function  GetEndDate : cuLongDate; Override;
    Procedure SetEndDate(Value : cuLongDate); Override;
    Function  GetRevEDate : cuLongDate; Override;
    Procedure SetRevEDate(Value : cuLongDate); Override;
    Function  GetSORRef : cuStr10; Override;
    Procedure SetSORRef(Value : cuStr10); Override;
    Function  GetVATCode : Char; Override;
    Procedure SetVATCode(Value : Char); Override;
    Function  GetDept : cuStr3; Override;
    Procedure SetDept(Value : cuStr3); Override;
    Function  GetCostCentre : cuStr3; Override;
    Procedure SetCostCentre(Value : cuStr3); Override;
    Function  GetJobAnal : cuStr3; Override;
    Procedure SetJobAnal(Value : cuStr3); Override;
    Function  GetJobType : Char; Override;
    Procedure SetJobType(Value : Char); Override;
    Function  GetJobStat : LongInt; Override;
    Procedure SetJobStat(Value : LongInt); Override;
    Function  GetUserDef1 : cuStr20; Override;
    Procedure SetUserDef1(Value : cuStr20); Override;
    Function  GetUserDef2 : cuStr20; Override;
    Procedure SetUserDef2(Value : cuStr20); Override;
    Function  GetUserDef3 : cuStr20; Override;
    Procedure SetUserDef3(Value : cuStr20); Override;
    Function  GetUserDef4 : cuStr20; Override;
    Procedure SetUserDef4(Value : cuStr20); Override;

    // TAbsJob2
    Function GetActual : TAbsJobActual; Override;
    Function GetJobBudget : TAbsJobBudget; Override;
    Function GetRetention : TAbsJobRetention; Override;

    // TAbsJob3
    Function  GetDefRetentionCcy : cuCurrencyType; Override;
    Procedure SetDefRetentionCcy(Value : cuCurrencyType); Override;
    Function  GetJPTRef : cuStr10; Override;
    Procedure SetJPTRef(Value : cuStr10); Override;
    Function  GetJSTRef : cuStr10; Override;
    Procedure SetJSTRef(Value : cuStr10); Override;
    Function  GetQSCode : cuStr20; Override;
    Procedure SetQSCode(Value : cuStr20); Override;

    // v6.9 TABSJob4
    Function GetUserDef5 : cuStr30; Override;
    Procedure SetUserDef5 (Value : cuStr30); Override;
    Function GetUserDef6 : cuStr30; Override;
    Procedure SetUserDef6 (Value : cuStr30); Override;
    Function GetUserDef7 : cuStr30; Override;
    Procedure SetUserDef7 (Value : cuStr30); Override;
    Function GetUserDef8 : cuStr30; Override;
    Procedure SetUserDef8 (Value : cuStr30); Override;
    Function GetUserDef9 : cuStr30; Override;
    Procedure SetUserDef9 (Value : cuStr30); Override;
    Function GetUserDef10 : cuStr30; Override;
    Procedure SetUserDef10 (Value : cuStr30); Override;

    //2018R1 TABSJob5
    Function GetAnonymised: Boolean; Override;
    Function GetAnonymisedDate: cuStr8; Override;
    Function GetAnonymisedTime: cuStr6; Override;  

    // Internal methods
    Function GetoJobActual : TJobActual;
    Function GetoJobBudget : TJobBudget;
    Function GetoJobRetention : TJobRetention;
  Public
    Property oJobActual : TJobActual Read GetoJobActual;
    Property oJobBudget : TJobBudget Read GetoJobBudget;
    Property oJobRetention : TJobRetention Read GetoJobRetention;

    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const ExLocal          : TdExLocal);
  End; { TJob }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  JobRecErrStr = 'Job ';

  idxUserDef5  = 34;
  idxUserDef6  = 35;
  idxUserDef7  = 36;
  idxUserDef8  = 37;
  idxUserDef9  = 38;
  idxUserDef10 = 39;


{-------------------------------------------------------------------------------------------------}

Constructor TJob.Create (hEntSys  : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  New (DataRec);
  FillChar (DataRec^, SizeOf (DataRec^), #0);
  New (OrigRec);
  FillChar (OrigRec^, SizeOf (OrigRec^), #0);

  FJobActual := TJobActual.Create(hEntSys);
  FJobBudget := TJobBudget.Create(hEntSys);
  FJobRetention := TJobRetention.Create(hEntSys);
End;

{-------------------------------------------------------------------------------------------------}

Destructor TJob.Destroy;
Begin { Destroy }
  FreeAndNIL(FJobRetention);
  FreeAndNIL(FJobBudget);
  FreeAndNIL(FJobActual);

  Dispose (DataRec);
  Dispose (OrigRec);

  Inherited Destroy;
End; { Destroy }

{-------------------------------------------------------------------------------------------------}

Procedure TJob.Assign (Const WinId, HandlerId : LongInt;
                       Const ExLocal          : TdExLocal);
Var
  I : SmallInt;
Begin
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
  FillChar (DataRec^, SizeOf (DataRec^), #0);
  RecChanged := False;
  If (RecAccess <> NotAvailable) Then Begin
    DataRec^ := ExLocal.LJobRec^;

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
      105000031 : PropAccess[23] := paReadWrite;    { User Def 1 }
      105000032 : PropAccess[24] := paReadWrite;    { User Def 2 }
      105000033 : PropAccess[25] := paReadWrite;    { User Def 3 }
      105000034 : PropAccess[26] := paReadWrite;    { User Def 4 }
      //GS 25/10/2011 ABSEXCH-11706: added support for UDEF 6-10
      105000211 : PropAccess[idxUserDef5] := paReadWrite;    { User Def 5 }
      105000212 : PropAccess[idxUserDef6] := paReadWrite;    { User Def 6 }
      105000213 : PropAccess[idxUserDef7] := paReadWrite;    { User Def 7 }
      105000214 : PropAccess[idxUserDef8] := paReadWrite;    { User Def 8 }
      105000215 : PropAccess[idxUserDef9] := paReadWrite;    { User Def 9 }
      105000216 : PropAccess[idxUserDef10] := paReadWrite;    { User Def 10 }

      105000038 : PropAccess[33] := paReadWrite;    { QSCode  }
      105000039 : PropAccess[33] := paReadWrite;    { QSCode }

      105000041 : PropAccess[23] := paReadWrite;    { User Def 1 }
      105000042 : PropAccess[24] := paReadWrite;    { User Def 2 }
      105000043 : PropAccess[25] := paReadWrite;    { User Def 3 }
      105000044 : PropAccess[26] := paReadWrite;    { User Def 4 }

      105000077 : PropAccess[01] := paReadWrite;    { Job Code }
      105000078 : PropAccess[09] := paReadWrite;    { Job Manager }
    End; { Case }

    TJobActual(FJobActual).Assign(WinId, HandlerId, ExLocal.LJobDetl^);
    TJobBudget(FJobBudget).Assign(WinId, HandlerId, ExLocal.LJobCtrl^);
    TJobRetention(FJobRetention).Assign(WinId, HandlerId, ExLocal.LJobDetl^);
  End; { If }
End;

{-------------------------------------------------------------------------------------------------}

Function TJob.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

{-------------------------------------------------------------------------------------------------}

Function TJob.GetRecChanged : Boolean;
Begin
  Result := RecChanged Or
            // HM 17/03/03: Added sub-objects
            FJobActual.DataChanged Or
            FJobBudget.DataChanged Or
            FJobRetention.DataChanged;
End;

{-------------------------------------------------------------------------------------------------}

Function TJob.GetJobCode : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JobCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'JobCode');
  End; { Else }
End;

Procedure TJob.SetJobCode(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[1] = paReadWrite) Then Begin
    If (DataRec.JobCode <> Value) Then Begin
      DataRec.JobCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'JobCode');
End;

Function TJob.GetJobDesc : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JobDesc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'JobDesc');
  End; { Else }
End;

Procedure TJob.SetJobDesc(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[2] = paReadWrite) Then Begin
    If (DataRec.JobDesc <> Value) Then Begin
      DataRec.JobDesc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'JobDesc');
End;

Function TJob.GetJobFolio : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JobFolio
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'JobFolio');
  End; { Else }
End;

Procedure TJob.SetJobFolio(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[3] = paReadWrite) Then Begin
    If (DataRec.JobFolio <> Value) Then Begin
      DataRec.JobFolio := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'JobFolio');
End;

Function TJob.GetCustCode : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CustCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'CustCode');
  End; { Else }
End;

Procedure TJob.SetCustCode(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[4] = paReadWrite) Then Begin
    If (DataRec.CustCode <> Value) Then Begin
      DataRec.CustCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'CustCode');
End;

Function TJob.GetJobCat : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JobCat
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'JobCat');
  End; { Else }
End;

Procedure TJob.SetJobCat(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[5] = paReadWrite) Then Begin
    If (DataRec.JobCat <> Value) Then Begin
      DataRec.JobCat := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'JobCat');
End;

Function TJob.GetJobAltCode : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JobAltCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'JobAltCode');
  End; { Else }
End;

Procedure TJob.SetJobAltCode(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[6] = paReadWrite) Then Begin
    If (DataRec.JobAltCode <> Value) Then Begin
      DataRec.JobAltCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'JobAltCode');
End;

Function TJob.GetCompleted : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Completed
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'Completed');
  End; { Else }
End;

Procedure TJob.SetCompleted(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[7] = paReadWrite) Then Begin
    If (DataRec.Completed <> Value) Then Begin
      DataRec.Completed := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'Completed');
End;

Function TJob.GetContact : cuStr25;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Contact
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'Contact');
  End; { Else }
End;

Procedure TJob.SetContact(Value : cuStr25);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[8] = paReadWrite) Then Begin
    If (DataRec.Contact <> Value) Then Begin
      DataRec.Contact := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'Contact');
End;

Function TJob.GetJobMan : cuStr25;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JobMan
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'JobMan');
  End; { Else }
End;

Procedure TJob.SetJobMan(Value : cuStr25);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[9] = paReadWrite) Then Begin
    If (DataRec.JobMan <> Value) Then Begin
      DataRec.JobMan := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'JobMan');
End;

Function TJob.GetChargeType : SmallInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ChargeType
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'ChargeType');
  End; { Else }
End;

Procedure TJob.SetChargeType(Value : SmallInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[10] = paReadWrite) Then Begin
    If (DataRec.ChargeType <> Value) Then Begin
      DataRec.ChargeType := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'ChargeType');
End;

Function TJob.GetQuotePrice : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QuotePrice
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'QuotePrice');
  End; { Else }
End;

Procedure TJob.SetQuotePrice(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[11] = paReadWrite) Then Begin
    If (DataRec.QuotePrice <> Value) Then Begin
      DataRec.QuotePrice := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'QuotePrice');
End;

Function TJob.GetCurrPrice : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CurrPrice
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'CurrPrice');
  End; { Else }
End;

Procedure TJob.SetCurrPrice(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[12] = paReadWrite) Then Begin
    If (DataRec.CurrPrice <> Value) Then Begin
      DataRec.CurrPrice := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'CurrPrice');
End;

Function TJob.GetStartDate : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StartDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'StartDate');
  End; { Else }
End;

Procedure TJob.SetStartDate(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[13] = paReadWrite) Then Begin
    If (DataRec.StartDate <> Value) Then Begin
      DataRec.StartDate := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'StartDate');
End;

Function TJob.GetEndDate : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.EndDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'EndDate');
  End; { Else }
End;

Procedure TJob.SetEndDate(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[14] = paReadWrite) Then Begin
    If (DataRec.EndDate <> Value) Then Begin
      DataRec.EndDate := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'EndDate');
End;

Function TJob.GetRevEDate : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RevEDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'RevEDate');
  End; { Else }
End;

Procedure TJob.SetRevEDate(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[15] = paReadWrite) Then Begin
    If (DataRec.RevEDate <> Value) Then Begin
      DataRec.RevEDate := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'RevEDate');
End;

Function TJob.GetSORRef : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SORRef
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'SORRef');
  End; { Else }
End;

Procedure TJob.SetSORRef(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[16] = paReadWrite) Then Begin
    If (DataRec.SORRef <> Value) Then Begin
      DataRec.SORRef := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'SORRef');
End;

Function TJob.GetVATCode : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.VATCode
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'VATCode');
  End; { Else }
End;

Procedure TJob.SetVATCode(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[17] = paReadWrite) Then Begin
    If (DataRec.VATCode <> Value) Then Begin
      DataRec.VATCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'VATCode');
End;

Function TJob.GetDept : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CCDep[False]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'Dept');
  End; { Else }
End;

Procedure TJob.SetDept(Value : cuStr3);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[18] = paReadWrite) Then Begin
    If (DataRec.CCDep[False] <> Value) Then Begin
      DataRec.CCDep[False] := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'Dept');
End;

Function TJob.GetCostCentre : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CCDep[True]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'CostCentre');
  End; { Else }
End;

Procedure TJob.SetCostCentre(Value : cuStr3);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[19] = paReadWrite) Then Begin
    If (DataRec.CCDep[True] <> Value) Then Begin
      DataRec.CCDep[True] := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'CostCentre');
End;

Function TJob.GetJobAnal : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JobAnal
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'JobAnal');
  End; { Else }
End;

Procedure TJob.SetJobAnal(Value : cuStr3);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[20] = paReadWrite) Then Begin
    If (DataRec.JobAnal <> Value) Then Begin
      DataRec.JobAnal := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'JobAnal');
End;

Function TJob.GetJobType : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JobType
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'JobType');
  End; { Else }
End;

Procedure TJob.SetJobType(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[21] = paReadWrite) Then Begin
    If (DataRec.JobType <> Value) Then Begin
      DataRec.JobType := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'JobType');
End;

Function TJob.GetJobStat : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JobStat
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'JobStat');
  End; { Else }
End;

Procedure TJob.SetJobStat(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[22] = paReadWrite) Then Begin
    If (DataRec.JobStat <> Value) Then Begin
      DataRec.JobStat := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'JobStat');
End;

Function TJob.GetUserDef1 : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef1
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'UserDef1');
  End; { Else }
End;

Procedure TJob.SetUserDef1(Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[23] = paReadWrite) Then Begin
    If (DataRec.UserDef1 <> Value) Then Begin
      DataRec.UserDef1 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'UserDef1');
End;

Function TJob.GetUserDef2 : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef2
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'UserDef2');
  End; { Else }
End;

Procedure TJob.SetUserDef2(Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[24] = paReadWrite) Then Begin
    If (DataRec.UserDef2 <> Value) Then Begin
      DataRec.UserDef2 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'UserDef2');
End;

Function TJob.GetUserDef3 : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef3
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'UserDef3');
  End; { Else }
End;

Procedure TJob.SetUserDef3(Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[25] = paReadWrite) Then Begin
    If (DataRec.UserDef3 <> Value) Then Begin
      DataRec.UserDef3 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'UserDef3');
End;

Function TJob.GetUserDef4 : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef4
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'UserDef4');
  End; { Else }
End;

Procedure TJob.SetUserDef4(Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[26] = paReadWrite) Then Begin
    If (DataRec.UserDef4 <> Value) Then Begin
      DataRec.UserDef4 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'UserDef4');
End;

//-------------------------------------------------------------------------

Function TJob.GetActual : TAbsJobActual;
Begin
  Result := nil;
  If (RecAccess <> NotAvailable) Then
    Result := FJobActual
  Else
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'Actual');
End;

Function TJob.GetoJobActual : TJobActual;
Begin
  Result := TJobActual(FJobActual);
End;

//-------------------------------------------------------------------------

Function TJob.GetJobBudget : TAbsJobBudget;
Begin
  Result := nil;
  If (RecAccess <> NotAvailable) Then
    Result := FJobBudget
  Else
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'Budget');
End;

Function TJob.GetoJobBudget : TJobBudget;
Begin
  Result := TJobBudget(FJobBudget);
End;

//-------------------------------------------------------------------------

Function TJob.GetRetention : TAbsJobRetention;
Begin
  Result := nil;
  If (RecAccess <> NotAvailable) Then
    Result := FJobRetention
  Else
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'Retention');
End;

Function TJob.GetoJobRetention : TJobRetention;
Begin
  Result := TJobRetention(FJobRetention);
End;

//------------------------------

Function TJob.GetDefRetentionCcy : cuCurrencyType;
Begin
  Result := Low(cuCurrencyType);
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DefRetCurr
  Else
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'DefRetentionCcy');
End;

Procedure TJob.SetDefRetentionCcy(Value : cuCurrencyType);
begin
  EntSys.NotImplException ('TJob.jrDefRetentionCcy');
End;

//------------------------------

Function TJob.GetJPTRef : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JPTOurRef
  Else
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'JPTRef');
End;

Procedure TJob.SetJPTRef(Value : cuStr10);
begin
  EntSys.NotImplException ('TJob.jrJPTRef');
End;

//------------------------------

Function TJob.GetJSTRef : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JSTOurRef
  Else
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'JSTRef');
End;

Procedure TJob.SetJSTRef(Value : cuStr10);
begin
    EntSys.NotImplException ('TJob.jrJSTRef');
End;

//------------------------------

Function TJob.GetQSCode : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JQSCode
  Else
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'QSCode');
End;

Procedure TJob.SetQSCode(Value : cuStr20);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[33] = paReadWrite) Then
  Begin
    If (DataRec.jQSCode<> Value) Then
    Begin
      DataRec.jQSCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'jrQSCode');
End;

//------------------------------

Function TJob.GetUserDef5 : cuStr30;
Begin // GetUserDef5
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef5
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'UserDef5');
  End; { Else }
End; // GetUserDef5

Procedure TJob.SetUserDef5 (Value : cuStr30);
Begin // SetUserDef5
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef5] = paReadWrite) Then
  Begin
    If (DataRec.UserDef5 <> Value) Then
    Begin
      DataRec.UserDef5 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'UserDef5');
End; // SetUserDef5

//------------------------------

Function TJob.GetUserDef6 : cuStr30;
Begin // GetUserDef6
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef6
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'UserDef6');
  End; { Else }
End; // GetUserDef6

Procedure TJob.SetUserDef6 (Value : cuStr30);
Begin // SetUserDef6
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef6] = paReadWrite) Then
  Begin
    If (DataRec.UserDef6 <> Value) Then
    Begin
      DataRec.UserDef6 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'UserDef6');
End; // SetUserDef6

//------------------------------

Function TJob.GetUserDef7 : cuStr30;
Begin // GetUserDef7
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef7
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'UserDef7');
  End; { Else }
End; // GetUserDef7

Procedure TJob.SetUserDef7 (Value : cuStr30);
Begin // SetUserDef7
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef7] = paReadWrite) Then
  Begin
    If (DataRec.UserDef7 <> Value) Then
    Begin
      DataRec.UserDef7 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'UserDef7');
End; // SetUserDef7

//------------------------------

Function TJob.GetUserDef8 : cuStr30;
Begin // GetUserDef8
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef8
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'UserDef8');
  End; { Else }
End; // GetUserDef8

Procedure TJob.SetUserDef8 (Value : cuStr30);
Begin // SetUserDef8
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef8] = paReadWrite) Then
  Begin
    If (DataRec.UserDef8 <> Value) Then
    Begin
      DataRec.UserDef8 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'UserDef8');
End; // SetUserDef8

//------------------------------

Function TJob.GetUserDef9 : cuStr30;
Begin // GetUserDef9
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef9
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'UserDef9');
  End; { Else }
End; // GetUserDef9

Procedure TJob.SetUserDef9 (Value : cuStr30);
Begin // SetUserDef9
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef9] = paReadWrite) Then
  Begin
    If (DataRec.UserDef9 <> Value) Then
    Begin
      DataRec.UserDef9 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'UserDef9');
End; // SetUserDef9

//------------------------------

Function TJob.GetUserDef10 : cuStr30;
Begin // GetUserDef10
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef10
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'UserDef5');
  End; { Else }
End; // GetUserDef10

Procedure TJob.SetUserDef10 (Value : cuStr30);
Begin // SetUserDef10
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef10] = paReadWrite) Then
  Begin
    If (DataRec.UserDef10 <> Value) Then
    Begin
      DataRec.UserDef10 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, JobRecErrStr + 'UserDef10');
End; // SetUserDef10

//AP 15/12/2017 ABSEXCH-19486:DLL + COM Customisation Support
Function TJob.GetAnonymised: Boolean;
Begin // GetAnonymised
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.jrAnonymised
  Else
  Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'Anonymised');
  End; { Else }
End; // GetAnonymised

Function TJob.GetAnonymisedDate: cuStr8;
Begin // GetAnonymisedDate
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.jrAnonymisedDate
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'AnonymisedDate');
  End; { Else }
End; // GetAnonymisedDate

Function TJob.GetAnonymisedTime: cuStr6;
Begin // GetAnonymisedTime
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.jrAnonymisedTime
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, JobRecErrStr + 'AnonymisedTime');
  End; { Else }
End; // GetAnonymisedTime


//-------------------------------------------------------------------------


end.
