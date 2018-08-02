unit oCC;

interface

Uses Classes, Dialogs, SysUtils, Windows, CustAbsU, CustTypU, GlobVar,
     VarConst;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TCCDept = Class(TAbsCCDept)
  Private
    IsCC       : Boolean;
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..45] Of TPropertyAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec  : ^CostCtrType;

    CCCodeStr  : ShortString;
  Protected
    { Abstract Property Access methods from TAbsCostCentre }
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;
    Function  GetCode : cuStr3;  Override;
    Procedure SetCode (Value : cuStr3); Override;
    Function  GetDesc : cuStr20;  Override;
    Procedure SetDesc (Value : cuStr20); Override;
    Function  GetTag : Boolean;  Override;
    Procedure SetTag (Value : Boolean); Override;
    Function  GetAccess : cuLongDate;  Override;
    Procedure SetAccess (Value : cuLongDate); Override;
  Public
    Constructor Create (      hEntSys : TEnterpriseSystem;
                        Const CC      : Boolean);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const CCDept           : PasswordRec);
  End; { TAbsCostCentre }


implementation

Uses EtStrU, BtKeys1U, CustWinU;

Constructor TCCDept.Create (      hEntSys : TEnterpriseSystem;
                            Const CC      : Boolean);
Begin
  Inherited Create;

  EntSys := hEntSys;

  New (DataRec);
  FillChar (DataRec^, SizeOf (DataRec^), #0);
  New (OrigRec);
  FillChar (OrigRec^, SizeOf (OrigRec^), #0);

  RecAccess  := NotAvailable;
  RecChanged := False;

  IsCC := CC;
  If IsCC Then
    CCCodeStr := 'Cost Centre '
  Else
    CCCodeStr := 'Department ';
End;

Destructor TCCDept.Destroy;
Begin
  Dispose (DataRec);
  Dispose (OrigRec);

  Inherited Destroy;
End;

Procedure TCCDept.Assign (Const WinId, HandlerId : LongInt;
                          Const CCDept           : PasswordRec);
Var
  I : SmallInt;
Begin
  { Set Security Access to Record }
  Case WinId of
    EnterpriseBase+3000,                { Stock Record - CC Needed for Loc Code on Stock List }
    1900001                             { Cost Centre List or Detail }
        : RecAccess := ReadOnly
  Else
    RecAccess:=NotAvailable;
  End; { If }

  { Load fields from ExLocal }
  FillChar (DataRec^, SizeOf (DataRec^), #0);
  RecChanged := False;
  If (RecAccess <> NotAvailable) Then Begin
    { Check ExLocal has a Cost Centre record loaded }
    If (CCDept.RecPfix = CostCCode) And (CCDept.SubType = CSubCode[IsCC]) Then Begin
      DataRec^ := CCDept.CostCtrRec;
      
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

    { Modify default for specific cases }
    Case ((WinId * 1000) + HandlerId) Of
      { 1000-1999 = Cost Centre List }

      { 2000-2999 = Cost Centre Detail }
      1900001 : Begin { Tab Off CC Description }
               {PropAccess[1] := paReadWrite;}
               PropAccess[2] := paReadWrite;
             End;


    End; { Case }
  End; { If }
End;

Function TCCDept.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

Function TCCDept.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

Function TCCDept.GetCode : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PCostC
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CCCodeStr + 'Code');
  End; { Else }
End;

Procedure TCCDept.SetCode (Value : cuStr3);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[1] = paReadWrite) Then Begin
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
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CCCodeStr + 'Code');
End;

Function TCCDept.GetDesc : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CCDesc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CCCodeStr + 'Description');
  End; { Else }
End;

Procedure TCCDept.SetDesc (Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[2] = paReadWrite) Then Begin
    If (DataRec.CCDesc <> Value) Then Begin
      DataRec.CCDesc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CCCodeStr + 'Description');
End;

Function TCCDept.GetTag : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CCTag
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, CCCodeStr + 'Tag');
  End; { Else }
End;

Procedure TCCDept.SetTag (Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[3] = paReadWrite) Then Begin
    If (DataRec.CCTag <> Value) Then Begin
      DataRec.CCTag := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CCCodeStr + 'Tag');
End;

Function TCCDept.GetAccess : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LastAccess
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CCCodeStr + 'LastAccessDate');
  End; { Else }
End;

Procedure TCCDept.SetAccess (Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[4] = paReadWrite) Then Begin
    If (DataRec.LastAccess <> Value) Then Begin
      If EntSys.ValidDate (Value) Then Begin
        DataRec.LastAccess := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CCCodeStr + 'LastAccessDate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CCCodeStr + 'LastAccessDate');
End;


end.

