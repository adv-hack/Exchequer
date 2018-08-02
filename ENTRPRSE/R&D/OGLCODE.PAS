unit oGLCode;

interface

Uses Classes, Dialogs, SysUtils, Windows, CustAbsU, CustTypU, GlobVar,
     VarConst;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TGLCode = Class(TAbsGLCode)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..6] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : ^NominalRec;
  Protected
    { Abstract Property Access methods from TAbsCostCentre }
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function  GetNomCode : LongInt; Override;
    Procedure SetNomCode(Value : LongInt); Override;
    Function  GetDesc : cuStr30; Override;
    Procedure SetDesc(Value : cuStr30); Override;
    Function  GetCat : LongInt; Override;
    Procedure SetCat(Value : LongInt); Override;
    Function  GetNomType : Char; Override;
    Procedure SetNomType(Value : Char); Override;

    Function  GetAltCode : cuStr50; Override;
    Procedure SetAltCode(Value : cuStr50); Override;
    Function  GetDefCurr : Byte; Override;
    Procedure SetDefCurr(Value : Byte); Override;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const GL               : NominalRec);
    Function LinkToNom (Const NomCode : LongInt) : Boolean;
  End; { TGLCode }


implementation

Uses EtStrU, BtrvU2, BtKeys1U, CustWinU;

Const
  GLErrStr = 'Nominal ';

Constructor TGLCode.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  New (DataRec);
  FillChar (DataRec^, SizeOf (DataRec^), #0);
  New (OrigRec);
  FillChar (OrigRec^, SizeOf (OrigRec^), #0);

  RecAccess  := NotAvailable;
  RecChanged := False;
End;

Destructor TGLCode.Destroy;
Begin
  Dispose (DataRec);
  Dispose (OrigRec);

  Inherited Destroy;
End;

Procedure TGLCode.Assign (Const WinId, HandlerId : LongInt;
                          Const GL               : NominalRec);
Var
  I : SmallInt;
Begin
  { Set Security Access to Record }
  Case WinId of
    EnterpriseBase+1000,                { Account }
    EnterpriseBase+4000
         :  RecAccess:=ReadOnly;
  Else
    RecAccess:=NotAvailable;
  End; { If }

  { Load fields from ExLocal }
  FillChar (DataRec^, SizeOf (DataRec^), #0);
  RecChanged := False;
  If (RecAccess <> NotAvailable) Then Begin
    DataRec^ := GL;

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
      101000002   { Account - Before Save }
           :   Begin
                 FuncAccess[1] := pfEnabled; { Add }
               End;
      104000051   { Substitute revalaution G/L Code }
           :   Begin
                 FuncAccess[1] := pfEnabled; { Add }
               End;
    End; { Case }
  End; { If }
End;

Function TGLCode.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

Function TGLCode.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

Function TGLCode.GetNomCode : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.NomCode
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, GLErrStr + 'Code');
  End; { Else }
End;

Procedure TGLCode.SetNomCode(Value : LongInt);
{Var
  TmpStr : ShortString;}
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[1] = paReadWrite) Then Begin

    (*
    TmpStr := LJVar(UpperCase(Value), CCKeyLen);
    If (DataRec.PCostC <> TmpStr) Then Begin
      { Validate }
      If (Trim(TmpStr) <> '') And
         ((TmpStr = OrigRec^.PCostC) Or (Not EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[IsCC],TmpStr),PWrdF,PWK))) Then Begin
        DataRec.PCostC := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CCCodeStr + 'Code');
    End; { If }
    *)
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, GlErrStr + 'Code');
End;

Function TGLCode.GetDesc : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Desc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, GLErrStr + 'Description');
  End; { Else }
End;

Procedure TGLCode.SetDesc(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[2] = paReadWrite) Then Begin
    If (DataRec.Desc <> Value) Then Begin
      DataRec.Desc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, GLErrStr + 'Description');
End;

Function TGLCode.GetCat : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Cat
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, GLErrStr + 'Parent');
  End; { Else }
End;

Procedure TGLCode.SetCat(Value : LongInt);
{Var
  TmpStr : ShortString;}
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[3] = paReadWrite) Then Begin

    (*
    TmpStr := LJVar(UpperCase(Value), CCKeyLen);
    If (DataRec.PCostC <> TmpStr) Then Begin
      { Validate }
      If (Trim(TmpStr) <> '') And
         ((TmpStr = OrigRec^.PCostC) Or (Not EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[IsCC],TmpStr),PWrdF,PWK))) Then Begin
        DataRec.PCostC := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (GlErrStr + 'Parent');
    End; { If }
    *)
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, GlErrStr + 'Parent');
End;

Function TGLCode.GetNomType : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.NomType
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, GLErrStr + 'Type');
  End; { Else }
End;

Procedure TGLCode.SetNomType(Value : Char);
{Var
  TmpStr : ShortString;}
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[3] = paReadWrite) Then Begin

    (*
    TmpStr := LJVar(UpperCase(Value), CCKeyLen);
    If (DataRec.PCostC <> TmpStr) Then Begin
      { Validate }
      If (Trim(TmpStr) <> '') And
         ((TmpStr = OrigRec^.PCostC) Or (Not EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[IsCC],TmpStr),PWrdF,PWK))) Then Begin
        DataRec.PCostC := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (GlErrStr + 'Parent');
    End; { If }
    *)
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, GlErrStr + 'Parent');
End;

Function TGLCode.LinkToNom (Const NomCode : LongInt) : Boolean;
Const
  FNum              = NomF;
  KeyPath : Integer = NomCodeK;
Var
  TmpStat, TmpKPath : Integer;
  TmpRecAddr        : LongInt;
  KeyS              : Str255;
Begin
  Result := False;

  { Check we're allowed to reload with different GL records }
  If (FuncAccess[1] = pfEnabled) Then
    With EntSys, LocalBtr^ Do
      { Check its non blank search }
      If (NomCode <> 0) Then Begin
        { Save current details }
        LastNom := LNom;
        TmpKPath := GetPosKey;
        TmpStat  := LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        KeyS := FullNomKey (NomCode);
        LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);
        Result := (LStatus = 0);

        If Result Then Begin
          { Reload Cust object with new record }
          Assign (WinId, HandlerId, LNom);
        End; { If }

        { Restore file position }
        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
        LNom := LastNom;
      End; { If }
End;

Function TGLCode.GetAltCode : cuStr50;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AltCode
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, GLErrStr + 'AltCode');
  End; { Else }
End;

Procedure TGLCode.SetAltCode(Value : cuStr50);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[5] = paReadWrite) Then Begin
    Value := Uppercase(Trim(Value));

    If (DataRec.AltCode <> Value) Then Begin
      DataRec.AltCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, GLErrStr + 'AltCode');
End;

Function TGLCode.GetDefCurr : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DefCurr
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, GLErrStr + 'DefCurr');
  End; { Else }
End;

Procedure TGLCode.SetDefCurr(Value : Byte);
Begin
  {$IFDEF MC}
  If (RecAccess <> NotAvailable) And (PropAccess[6] = paReadWrite) Then Begin
    If (DataRec.DefCurr <> Value) Then Begin
      If (Value >= 0) And ((EuroVers And (Value <= 2)) Or ((Not EuroVers) And (Value <= CurrencyType))) Then Begin
        DataRec.DefCurr := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (GlErrStr + 'DefCurr');
    End; { If }
  End { If }
  Else
  {$ENDIF}
    EntSys.DataAccessErrDlg(False, GLErrStr + 'DefCurr');
End;



end.

