unit OMiscDat;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU;

Const
  NumBool = 1;
  NumDbl = 1;
  NumLong = 1;
  NumStr = 1;
  NumVar = 1;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TMiscData = Class(TAbsMiscData)
  Private
    RecAccess  : TRecAccessStatus;
    EntSys     : TEnterpriseSystem;

    FBoolAccess   : Array [1..NumBool] Of TPropertyAccess;
    FDoubleAccess : Array [1..NumDbl]  Of TPropertyAccess;
    FLongAccess   : Array [1..NumLong] Of TPropertyAccess;
    FStringAccess : Array [1..NumStr]  Of TPropertyAccess;
    FVarAccess    : Array [1..NumVar]  Of TPropertyAccess;

    RecChanged : Boolean;
  Protected
    Function  GetRecStatus : TRecAccessStatus; OverRide;
    Function  GetRecChanged : Boolean; OverRide;

    Function  GetBoolean(Index : SmallInt) : Boolean; OverRide;
    Procedure SetBoolean(Index : SmallInt; Value : Boolean); OverRide;
    Function  GetDouble(Index : SmallInt) : Double; OverRide;
    Procedure SetDouble(Index : SmallInt; Value : Double); OverRide;
    Function  GetLongInt(Index : SmallInt) : LongInt; OverRide;
    Procedure SetLongInt(Index : SmallInt; Value : LongInt); OverRide;
    Function  GetShortString(Index : SmallInt) : ShortString; OverRide;
    Procedure SetShortString(Index : SmallInt; Value : ShortString); OverRide;
    Function  GetVariant(Index : SmallInt) : Variant; OverRide;
    Procedure SetVariant(Index : SmallInt; Value : Variant); OverRide;
  Public
    FBool         : Array [1..NumBool] Of Boolean;
    FDouble       : Array [1..NumDbl]  Of Double;
    FLong         : Array [1..NumLong] Of LongInt;
    FString       : Array [1..NumStr]  Of ShortString;
    FVar          : Array [1..NumVar]  Of Variant;

    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt);
  End; { TMiscData }

implementation

Uses Variants, CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  mdErrStr = 'MiscData ';

{-------------------------------------------------------------------------------------------------}

Constructor TMiscData.Create (hEntSys  : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;
End;

{-------------------------------------------------------------------------------------------------}

Destructor TMiscData.Destroy;
Begin { Destroy }
  EntSys := Nil;

  Inherited Destroy;
End; { Destroy }

{-------------------------------------------------------------------------------------------------}

Procedure TMiscData.Assign (Const WinId, HandlerId : LongInt);
Var
  I : SmallInt;
Begin
  { Set Security Access to Record }
  Case WinId of
    { Add Window Classes here }
    1
                          :  RecAccess:=ReadOnly;
  Else
    RecAccess:=NotAvailable;
  End; { If }

  { Re-Initialise storage arrays }
  For I := Low(FBool) To High(FBool) Do
    FBool[I] := False;
  For I := Low(FDouble) To High(FDouble) Do
    FDouble[I] := 0.00;
  For I := Low(FLong) To High(FLong) Do
    FLong[I] := 0;
  For I := Low(FString) To High(FString) Do
    FString[I] := '';
  For I := Low(FVar) To High(FVar) Do
    FVar[I] := UnAssigned;

  { Re-Initialise changed flag }
  RecChanged := False;

  { Adjust Security Access for field by Window and Event }
  If (RecAccess <> NotAvailable) Then Begin
    { Set Default Security options }
    For I := Low(FBoolAccess) To High(FBoolAccess) Do
      FBoolAccess[I] := paReadOnly;
    For I := Low(FDoubleAccess) To High(FDoubleAccess) Do
      FDoubleAccess[I] := paReadOnly;
    For I := Low(FLongAccess) To High(FLongAccess) Do
      FLongAccess[I] := paReadOnly;
    For I := Low(FStringAccess) To High(FStringAccess) Do
      FStringAccess[I] := paReadOnly;
    For I := Low(FVarAccess) To High(FVarAccess) Do
      FVarAccess[I] := paReadOnly;

    { Modify default for specific cases }
    Case ((WinId * 1000) + HandlerId) Of
      { Add event specific enabling here }
      1 : ;
    End; { Case }
  End; { If }
End;

{-------------------------------------------------------------------------------------------------}

Function TMiscData.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

{---------------------------------------------}

Function TMiscData.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

{---------------------------------------------}

Function TMiscData.GetBoolean(Index : SmallInt) : Boolean;
Var
  GotOK : Boolean;
Begin { GetBoolean }
  { Check record is available and index is valid }
  GotOK := (RecAccess <> NotAvailable);
  If GotOK Then GotOK := (Index >= Low(FBool)) And (Index <= High(FBool));

  If GotOK Then
    Result := FBool[Index]
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, mdErrStr + 'mdBoolean[' + IntToStr(Index) + ']');
  End; { Else }
End; { GetBoolean }

Procedure TMiscData.SetBoolean(Index : SmallInt; Value : Boolean);
Var
  GotOK : Boolean;
Begin { SetBoolean }
  { Check record is available and index is valid }
  GotOK := (RecAccess <> NotAvailable);
  If GotOK Then GotOK := (Index >= Low(FBool)) And (Index <= High(FBool));

  { Check field is writeable }
  If GotOK Then GotOK := (FBoolAccess[Index] = paReadWrite);

  If GotOK Then Begin
    { Check value has changed }
    If (Value <> FBool[Index]) Then Begin
      FBool[Index] := Value;
      RecChanged := True;
    End; { If (Value <> FBool[Index]) }
  End { If GotOK }
  Else
    EntSys.DataAccessErrDlg(False, mdErrStr + 'mdBoolean[' + IntToStr(Index) + ']');
End; { SetBoolean }

{---------------------------------------------}

Function TMiscData.GetDouble(Index : SmallInt) : Double;
Var
  GotOK : Boolean;
Begin { GetDouble }
  { Check record is available and index is valid }
  GotOK := (RecAccess <> NotAvailable);
  If GotOK Then GotOK := (Index >= Low(FDouble)) And (Index <= High(FDouble));

  If GotOK Then
    Result := FDouble[Index]
  Else Begin
    Result := 0.00;
    EntSys.DataAccessErrDlg(True, mdErrStr + 'mdDouble[' + IntToStr(Index) + ']');
  End; { Else }
End; { GetDouble }

Procedure TMiscData.SetDouble(Index : SmallInt; Value : Double);
Var
  GotOK : Boolean;
Begin { SetDouble }
  { Check record is available and index is valid }
  GotOK := (RecAccess <> NotAvailable);
  If GotOK Then GotOK := (Index >= Low(FDouble)) And (Index <= High(FDouble));

  { Check field is writeable }
  If GotOK Then GotOK := (FDoubleAccess[Index] = paReadWrite);

  If GotOK Then Begin
    { Check value has changed }
    If (Value <> FDouble[Index]) Then Begin
      FDouble[Index] := Value;
      RecChanged := True;
    End; { If (Value <> FDouble[Index]) }
  End { If GotOK }
  Else
    EntSys.DataAccessErrDlg(False, mdErrStr + 'mdDouble[' + IntToStr(Index) + ']');
End; { SetDouble }

{---------------------------------------------}

Function TMiscData.GetLongInt(Index : SmallInt) : LongInt;
Var
  GotOK : Boolean;
Begin { GetLongInt }
  { Check record is available and index is valid }
  GotOK := (RecAccess <> NotAvailable);
  If GotOK Then GotOK := (Index >= Low(FLong)) And (Index <= High(FLong));

  If GotOK Then
    Result := FLong[Index]
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, mdErrStr + 'mdLongInt[' + IntToStr(Index) + ']');
  End; { Else }
End; { GetLongInt }

Procedure TMiscData.SetLongInt(Index : SmallInt; Value : LongInt);
Var
  GotOK : Boolean;
Begin { SetLongInt }
  { Check record is available and index is valid }
  GotOK := (RecAccess <> NotAvailable);
  If GotOK Then GotOK := (Index >= Low(FLong)) And (Index <= High(FLong));

  { Check field is writeable }
  If GotOK Then GotOK := (FLongAccess[Index] = paReadWrite);

  If GotOK Then Begin
    { Check value has changed }
    If (Value <> FLong[Index]) Then Begin
      FLong[Index] := Value;
      RecChanged := True;
    End; { If (Value <> FLong[Index]) }
  End { If GotOK }
  Else
    EntSys.DataAccessErrDlg(False, mdErrStr + 'mdLongInt[' + IntToStr(Index) + ']');
End; { SetLongInt }

{---------------------------------------------}

Function TMiscData.GetShortString(Index : SmallInt) : ShortString;
Var
  GotOK : Boolean;
Begin { GetShortString }
  { Check record is available and index is valid }
  GotOK := (RecAccess <> NotAvailable);
  If GotOK Then GotOK := (Index >= Low(FString)) And (Index <= High(FString));

  If GotOK Then
    Result := FString[Index]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, mdErrStr + 'mdString[' + IntToStr(Index) + ']');
  End; { Else }
End; { GetShortString }

Procedure TMiscData.SetShortString(Index : SmallInt; Value : ShortString);
Var
  GotOK : Boolean;
Begin { SetShortString }
  { Check record is available and index is valid }
  GotOK := (RecAccess <> NotAvailable);
  If GotOK Then GotOK := (Index >= Low(FString)) And (Index <= High(FString));

  { Check field is writeable }
  If GotOK Then GotOK := (FStringAccess[Index] = paReadWrite);

  If GotOK Then Begin
    { Check value has changed }
    If (Value <> FString[Index]) Then Begin
      FString[Index] := Value;
      RecChanged := True;
    End; { If (Value <> FString[Index]) }
  End { If GotOK }
  Else
    EntSys.DataAccessErrDlg(False, mdErrStr + 'mdString[' + IntToStr(Index) + ']');
End; { SetShortString }

{---------------------------------------------}

Function TMiscData.GetVariant(Index : SmallInt) : Variant;
Var
  GotOK : Boolean;
Begin { GetVariant }
  { Check record is available and index is valid }
  GotOK := (RecAccess <> NotAvailable);
  If GotOK Then GotOK := (Index >= Low(FVar)) And (Index <= High(FVar));

  If GotOK Then
    Result := FVar[Index]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, mdErrStr + 'mdVariant[' + IntToStr(Index) + ']');
  End; { Else }
End; { GetVariant }

Procedure TMiscData.SetVariant(Index : SmallInt; Value : Variant);
Var
  GotOK : Boolean;
Begin { SetVariant }
  { Check record is available and index is valid }
  GotOK := (RecAccess <> NotAvailable);
  If GotOK Then GotOK := (Index >= Low(FVar)) And (Index <= High(FVar));

  { Check field is writeable }
  If GotOK Then GotOK := (FVarAccess[Index] = paReadWrite);

  If GotOK Then Begin
    { Check value has changed }
    If (Value <> FVar[Index]) Then Begin
      FVar[Index] := Value;
      RecChanged := True;
    End; { If (Value <> FVar[Index]) }
  End { If GotOK }
  Else
    EntSys.DataAccessErrDlg(False, mdErrStr + 'mdVariant[' + IntToStr(Index) + ']');
End; { SetVariant }

{-------------------------------------------------------------------------------------------------}

end.

