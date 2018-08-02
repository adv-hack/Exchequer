unit LicVar;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Forms, IniFiles, SysUtils, LicRec;

Const
  { Wizard indices }
  Wiz_Type      = 1;
  Wiz_CustDets  = 2;
  Wiz_Serial    = 3;
  Wiz_EntVer    = 4;
  Wiz_ClServer  = 5;
  Wiz_Workgroup = 6;
  Wiz_Modules   = 7;
  Wiz_Confirm   = 8;

  Wiz_Start     = Wiz_Type;
  Wiz_Last      = Wiz_Confirm;

  Wiz_Prev      = -1;
  Wiz_Abort     = 0;
  Wiz_Next      = 1;

Type
  ConfigRecType  = Record
    CDDrive         : Char;
    FileDir         : String[255];
    LicenceDir      : String[255];

    ExpUnits        : Char;
    ExpOffset       : LongInt;

    AddMode         : Boolean;
  End; { ConfigRecType }

  {$IFDEF CDGEN}
  // Additional info structure used by CD Licence Generator to store info not in the Licence
  CDGenInfoRecType = Record
    AccountCode     : String[6];
    DealerCode      : String[6];
    VersionStr      : String[20];
  End; { CDGenInfoRecType }
  {$ENDIF}

Var
  LicenceInfo : CDLicenceRecType;
  ConfigInfo  : ConfigRecType;
  {$IFDEF CDGEN}
  CDGenInfo   : CDGenInfoRecType;     // Additional info used by CD Licence Generator
  {$ENDIF}


{ Initialises the Wizard window }
Procedure licInitWin (F : TForm; Const WinNo : Byte);

{ Initialises theGlobal LicenceInfo record to the default settings }
Procedure licInitGlobToDefaults;

// Loads the saved co-ordinates in from the cdgenrat.ini file
Function licLoadCoords(F : TForm) : Boolean;

// Saves the form co-ordinates into the cdgenrat.ini file
Procedure licSaveCoords (F : TForm);

{ Generates a description string for the Toolkit options - returns blank if none enabled }
Function licToolkitDesc (Const ModRunTK, ModDevTK : Byte;
                         Const TKUc30, TKUcFull   : SmallInt) : ShortString;

{ Generates a description string for the WOP options - returns blank if none enabled }
Function licWOPDesc (Const ModStdWOP, ModProWOP : Byte ) : ShortString;

{ Generates a description string for the Elerts options - returns blank if none enabled }
Function licElertsDesc (Const RelElerts : Byte; Const SentCount : SmallInt) : ShortString;

implementation

Uses APIUtil, SerialU, LicFuncU;

//--------------------------------------------------------------------------

// Loads the saved co-ordinates in from the cdgenrat.ini file
Function licLoadCoords(F : TForm) : Boolean;
Var
  SectName : ShortString;
Begin { licLoadCoords }
  Result := False;

  With TIniFile.Create(ChangeFileExt(Application.ExeName, '.Ini')) Do
    Try
      SectName := Trim(WinGetUserName) + '-' + Trim(F.Name);

      Result := SectionExists (SectName);

      If Result Then Begin
        F.Top := ReadInteger (SectName, 'Top', F.Top);
        F.Left := ReadInteger (SectName, 'Left', F.Left);
      End; { If Result }
    Finally
      Free;
    End;
End; { licLoadCoords }

//--------------------------------------------------------------------------

// Saves the form co-ordinates into the cdgenrat.ini file
Procedure licSaveCoords (F : TForm);
Var
  SectName : ShortString;
Begin { licLoadCoords }
  With TIniFile.Create(ChangeFileExt(Application.ExeName, '.Ini')) Do
    Try
      SectName := Trim(WinGetUserName) + '-' + Trim(F.Name);

      WriteInteger(SectName, 'Top', F.Top);
      WriteInteger(SectName, 'Left', F.Left);
    Finally
      Free;
    End;
End; { licLoadCoords }

//--------------------------------------------------------------------------

{ Initialises the Wizard window }
Procedure licInitWin (F : TForm; Const WinNo : Byte);
Begin { licInitWin }
  With F Do Begin
    { Set Caption }
    Caption := '2018-R1 CD Licencing Wizard - Step ' + IntToStr(WinNo) + ' of ' + IntToStr(Wiz_Last);

    { Try to load previously saved co-ordinates in from .ini file }
    If Not licLoadCoords(F) Then Begin
      { Centre Window over main form }
      Left := (Screen.Width - Width) Div 2;
      Top := (Screen.Height - Height) Div 2;
    End; { If Not licLoadCoords(F) }
  End; { With F }
End; { licInitWin }

//--------------------------------------------------------------------------

Procedure licInitToDefaults (Var LicInfo : CDLicenceRecType);
Begin { licInitToDefaults }
  FillChar (LicInfo, SizeOf(LicInfo), #0);
  With LicInfo Do Begin
    { Set default licence values }
    licCountry   := 1;     { UK }
    licType      := 0;     { Install }
    licEntCVer   := 0;     { Euro }
    licEntModVer := 0;     { Core }
    licEntClSvr  := 0;     { Non Client-Server }
    licUserCnt   := 4;     { 4 user }

    licUserCounts[ucCompanies] := 5;  { Default Company Count }

    licExpiry    := Now;
  End; { With }

  {$IFDEF CDGEN}
  // Additional info structure used by CD Licence Generator to store info not in the Licence
  FillChar (CDGenInfo, SizeOf(CDGenInfo), #0);
  {$ENDIF}
End; { licInitToDefaults }

//--------------------------------------------------------------------------

{ Initialises theGlobal LicenceInfo record to the default settings }
Procedure licInitGlobToDefaults;
Begin { licInitGlobToDefaults }
  licInitToDefaults(LicenceInfo);
End; { licInitGlobToDefaults }

//--------------------------------------------------------------------------

Procedure licLoadConfig;
Var
  IniF : TIniFile;
Begin { licLoadConfig }
  FillChar (ConfigInfo, SizeOf(ConfigInfo), #0);
  With ConfigInfo Do Begin
    IniF := TIniFile.Create (ChangeFileExt (Application.ExeName, '.INI'));
    Try
      FileDir := IniF.ReadString ('Config', 'FileDir', '');
      If (Length(FileDir) > 0) Then Begin
        If (FileDir[Length(FileDir)] <> '\') Then Begin
          FileDir := FileDir + '\';
        End; { If }
      End; { If }

      LicenceDir := IniF.ReadString ('Config', 'LicenceDir', '');
      If (Length(LicenceDir) > 0) Then Begin
        If (LicenceDir[Length(LicenceDir)] <> '\') Then Begin
          LicenceDir := LicenceDir + '\';
        End; { If }
      End; { If }

      CDDrive := IniF.ReadString ('Config', 'CDDrive', 'D')[1];

      { Expiry Date }
      ExpOffset := IniF.ReadInteger ('Expiry', 'Offset', 0);
      If (ExpOffset <> 0) Then Begin
        ExpUnits := Copy(UpperCase(IniF.ReadString ('Expiry', 'Units', '')), 1, 1)[1];
        If Not (ExpUnits In ['D', 'M', 'W']) Then Begin
          { Set to defaults }
          ExpOffset := 2;
          ExpUnits  := 'M';
        End; { If }
      End { If}
      Else Begin
        { Set to defaults }
        ExpOffset := 2;
        ExpUnits  := 'M';
      End; { Else }
    Finally
      IniF.Free;
    End;
  End; { With }
End; { licLoadConfig }

//--------------------------------------------------------------------------

{ Generates a description string for the Toolkit options - returns blank if none enabled }
Function licToolkitDesc (Const ModRunTK, ModDevTK : Byte;
                         Const TKUc30, TKUcFull   : SmallInt) : ShortString;
Var
  Tot : Byte;
Begin { licToolkitDesc }
  Result := '';

  Tot := ModRunTK + ModDevTK;

  If (Tot > 0) Then Begin
    { One of the modules is enabled }
    If (Tot = 1) Then
      Result := '30-Day'
    Else
      Result := 'Full';

    { Version - Std / Prof }
    If (ModDevTK > 0) Then
      Result := Result + ' Developer'
    Else
      Result := Result + ' Runtime';

    If (TKUc30 > 0) Or (TKUcFull > 0) Then
      { User Counts }
      Result := Result + Format (' - %d/%d', [TKUc30, TKUcFull]);
  End; { If (Tot > 0) }
End; { licToolkitDesc }

//--------------------------------------------------------------------------

{ Generates a description string for the WOP options - returns blank if none enabled }
Function licWOPDesc (Const ModStdWOP, ModProWOP : Byte ) : ShortString;
Var
  Tot : Byte;
Begin { licWOPDesc }
  Result := '';

  Tot := ModStdWOP + ModProWOP;

  If (Tot > 0) Then Begin
    { One of the modules is enabled }
    If (Tot = 1) Then
      Result := '30-Day'
    Else
      Result := 'Full';

    { Version - Std / Prof }
    If (ModProWOP > 0) Then
      Result := Result + ' Professional'
    Else
      Result := Result + ' Standard';
  End; { If (Tot > 0) }
End; { licWOPDesc }

//--------------------------------------------------------------------------

{ Generates a description string for the Elerts options - returns blank if none enabled }
Function licElertsDesc (Const RelElerts : Byte; Const SentCount : SmallInt) : ShortString;
Begin { licElertsDesc }
  Result := '';

  If (RelElerts > 0) Then Begin
    If (RelElerts = 1) Then
      Result := '30-Day'
    Else
      Result := 'Full';

    Result := Result + ' - ' + IntToStr(SentCount) + ' Sentinels';
  End; { If (RelElerts > 0) }
End; { licElertsDesc }

//--------------------------------------------------------------------------


Initialization
  licInitGlobToDefaults;
  licLoadConfig;
end.
