unit EntOdbcU;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, Registry, SysUtils, Windows;

Procedure AddDataSource (coCode, coName : ShortString; coPath : String); Export;
Procedure CheckForSources (Const MainComp : ShortString); Export;
Function GotPervyDriver : Boolean; Export;

implementation

Uses GlobVar, VarConst, VarFPosU, BtrvU2, EntRegU, BtSupU1,
{$IFDEF EXSQL}
  SQLUtils,
{$ENDIF}
  CompUtil;

Const
  PervName = 'Pervasive Software ODBC-32';
  OdbcBase = 'Software\ODBC\ODBC.INI\';
  OdbcInst = 'Software\ODBC\ODBCINST.INI\';

Type
  TListEntry = Class(TObject)
  Public
    dsCode        : ShortString;
    dsDataPath    : String;

    Constructor Create (SourceCode : String);
  End; { TListEntry }

  TSourceList = Class(TList)
  Private
    DSProperties : TList;
  Public
    Constructor Create;
    Destructor  Destroy; Override;

    Procedure CheckForSource (coCode, coName : ShortString; coPath : String);
  End; { TSourceList }


{------------------------------------------------------------------------------}



Constructor TListEntry.Create (SourceCode : String);
Var
  RegObj  : TRegistry;
Begin
  Inherited Create;

  { Load Source Details }
  dsCode        := SourceCode;
  dsDataPath    := '';

  { Create registry access object }
  RegObj := TRegistry.Create;
  Try
    RegObj.Access := KEY_READ;
    RegObj.RootKey := HKEY_CURRENT_USER;

    If RegObj.OpenKey(OdbcBase + dsCode, False) Then Begin
      dsDataPath := RegObj.ReadString('DataPath');
      FixPath(dsDataPath);
      dsDataPath := UpperCase(dsDataPath);
    End; { If }
  Finally
    RegObj.CloseKey;
    RegObj.Free;
  End;
End;


{-----------------------------------------------------------------------------}


Constructor TSourceList.Create;
Var
  RegObj  : TRegistry;
  Str     : TStringList;
  LEntry  : TListEntry;
  I       : SmallInt;
  DrvName : String;
Begin
  Inherited Create;

  { Create internal Data Source Properties list }
  DSProperties := TList.Create;

  { Load Source details }
  Str := TStringList.Create;
  Try
    { Create registry access object }
    RegObj := TRegistry.Create;
    Try
      RegObj.Access := KEY_READ;
      RegObj.RootKey := HKEY_CURRENT_USER;

      If RegObj.OpenKey(OdbcBase + 'ODBC Data Sources', False) Then Begin
        { Load in Codes of all installed Data Sources }
        RegObj.GetValueNames(Str);

        { Load details of existing data sources }
        If (Str.Count > 0) Then
          For I := 0 To Pred(Str.Count) Do Begin
            { Check the Data Source entry exists - paranoid programming or what!!! }
            If RegObj.ValueExists(Str.Strings[I]) Then Begin
              { Get Driver Name }
              DrvName := RegObj.ReadString(Str.Strings[I]);

              { See if its one of ours }
              If (Trim(UpperCase(DrvName)) = UpperCase(PervName)) Then Begin
                { Its a Pervasive Data Source - store in list }
                LEntry := TListEntry.Create(Str.Strings[I]);
                Add (LEntry);
              End; { If }
            End; { If }
          End; { For }
      End; { If }
    Finally
      RegObj.CloseKey;
      RegObj.Free;
    End;
  Finally
    Str.Free;
  End;
End;

Destructor TSourceList.Destroy;
Var
  LEntry : TListEntry;
Begin
  { Delete any Source Objects in the list }
  While (Count > 0) Do Begin
    LEntry := Items[0];
    Delete(0);
    LEntry.Free;
  End; { While }

  Inherited Destroy;
End;


{ Checks to see if the company exists as a Data Source and adds it if it doesn't }
Procedure TSourceList.CheckForSource (coCode, coName : ShortString; coPath : String);
Var
  LEntry : TListEntry;
  Found  : Boolean;
  I      : SmallInt;
Begin
  { Modify path to standard format }
  FixPath(coPath);

  Found := False;
  If (Count > 0) Then
    For I := 0 to Pred(Count) Do Begin
      { Get Local Handle to List Item }
      LEntry := Items[I];

      { Check to See if it matches }
      Found := (Trim(LEntry.dsDataPath) = Trim(coPath));

      { Got a match - then finish loop }
      If Found Then Break;
    End; { For }

  If (Not Found) And (Count > 0) Then Begin
    { Add Data Source - use last Data Source as base on theory that it will }
    {                   be most likely to be up to date                     }
    LEntry := Items[Pred(Count)];

    AddDataSource(Trim(coCode), Trim(coName), Trim(coPath));
  End; { If }
End;


{------------------------------------------------------------------------------}


{ Check to see if Pervasive Software ODBC-32 is Installed }
Function GotPervyDriver : Boolean;
Var
  RegObj  : TRegistry;
Begin
  Result := False;

  { Create registry access object }
  RegObj := TRegistry.Create;
  Try
    RegObj.Access := KEY_READ;
    RegObj.RootKey := HKEY_LOCAL_MACHINE;

    If RegObj.OpenKey(OdbcInst + 'ODBC Drivers', False) Then Begin
      { See If Pervasive value is there }
      Result := RegObj.ValueExists(PervName);
    End; { If }
  Finally
    RegObj.CloseKey;
    RegObj.Free;
  End;
End;


{ Adds a Data Source }
Procedure AddDataSource (coCode, coName : ShortString; coPath : String);
Var
  RegObj     : TRegistry;
  Suff       : Byte;
  CompCode   : ShortString;
  Hokay      : Boolean;
  DrvName    : String;
Begin
  { Check Data Source doesn't already exist for the code }
  RegObj := TRegistry.Create;
  Try
    Hokay := False;

    RegObj.Access := KEY_READ or KEY_WRITE;
    RegObj.RootKey := HKEY_CURRENT_USER;
    If RegObj.OpenKey(OdbcBase + 'ODBC Data Sources', False) Then Begin
      { Generate unique code for data source }
      Suff := 0;
      Repeat
        If (Suff > 0) Then
          CompCode := coCode + '-' + IntToStr(Suff)
        Else
          CompCode := coCode;

        Hokay := Not RegObj.ValueExists(CompCode);

        Inc (Suff);
      Until Hokay Or (Suff > 250);

      RegObj.CloseKey;
    End; { If }

    If Hokay Then Begin
      { Get Btrieve ODBC Driver Name }
      RegObj.RootKey := HKEY_LOCAL_MACHINE;
      If RegObj.OpenKey(OdbcInst + PervName, False) Then
        DrvName := RegObj.ReadString('Driver')
      Else
        Hokay := False;

      RegObj.CloseKey;
    End; { If }

    If Hokay Then Begin
      RegObj.RootKey := HKEY_CURRENT_USER;

      { Create new data source entry }
      If RegObj.OpenKey(OdbcBase + 'ODBC Data Sources', False) Then Begin
        RegObj.WriteString (CompCode, PervName);
        RegObj.CloseKey;
      End; { If }

      { Create new data source section }
      If RegObj.OpenKey(OdbcBase + CompCode, True) Then Begin
        RegObj.WriteString ('Driver', DrvName);
        RegObj.WriteString ('Description', CoName);
        RegObj.WriteString ('UID', '');
        RegObj.WriteString ('DATAPATH', CoPath);
        RegObj.WriteString ('DDFPATH', CoPath);
        RegObj.WriteString ('DB', '');
        RegObj.WriteString ('BOB', '');
        RegObj.WriteString ('LoginScript', '');
        RegObj.WriteString ('NullEnabled', 'no');
        RegObj.WriteString ('FeaturesUsed', 'no');
        RegObj.WriteString ('AccessFriendly', 'no');

        RegObj.CloseKey;
      End; { If }
    End; { If }
  Finally
    RegObj.Free;
  End;
End;


{ Checks all companies to see which need to have a data source added }
Procedure CheckForSources (Const MainComp : ShortString);
Const
  FNum    = CompF;
  KeyPath : Integer = CompCodeK;
Var
  SourceList    : TSourceList;
  KeyS, KeyFind : Str255;
Begin
  DllStatus := 0;

  If GotPervyDriver Then Begin
    { Create a list of Pervasive ODBC-32 Data sources }
    SourceList := TSourceList.Create;
    Try
      { Get path of help file }
      Application.HelpFile := MainComp + 'ENTREAD.HLP';

      { Check Btrieve is running }
      If Check4BtrvOk Then Begin
{$IFDEF EXSQL}
        if ValidCompany(MainComp) then begin
{$ELSE}
        If FileExists (MainComp + MultCompNam) Then Begin
{$ENDIF}
          { Open company database }
          Status := Open_File(F[CompF], MainComp + FileNames[CompF], 0);
          If StatusOk Then Begin
            { Step through each company }
            KeyS := cmCompDet;
            KeyFind := KeyS;
            Status := Find_Rec(B_GetGEQ, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
            While StatusOk And CheckKey(KeyFind, KeyS, Length(KeyFind), BOn) Do Begin
              With Company^.CompDet Do
                SourceList.CheckForSource (CompCode, CompName, CompPath);

              Status := Find_Rec(B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
            End; { While }

            { close company database }
            Close_File(F[CompF]);
          End { If }
          Else
            DllStatus := Status;
        End { If }
        Else
          { Error: Company.Dat not found }
          DllStatus := 1;

        { Stop Btrieve }
        Stop_B;
      End; { If }
    Finally
      SourceList.Free;
    End;
  End { If }
  Else
    MessageDlg ('The Pervasive Software ODBC Driver is not installed. Data Sources have not been added.', mtWarning, [mbOk], 0);
End;

end.
