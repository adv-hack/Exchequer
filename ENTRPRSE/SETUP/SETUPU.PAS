unit SetupU;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses Dialogs, FileCtrl, Forms, classes,
     {$IFDEF WIN32}
       Registry, Messages,
     {$ENDIF}
     WinTypes, WinProcs, SysUtils;
type
{$ifndef WIN32}
  { 16-Bit - Delphi 1.0 }
  ParamRec = record
     wStructLen: Word;   { The length of the structure }
     hMainWnd: HWnd;     { Handle to main window }
     wMaxReplaces: Word; { Maximum number of replaces }
     wRepNameWidth: Word;{ The width of a replace name }
     wRepStrWidth: Word; { The width of each replace string }
     wCurrReps: Word;    { Current number of replace strings }
     szRepName: PChar;   { The actual replace names }
     szRepStr: PChar;    { The actual replace values }
     wRunMode: Word;     { The installation mode }
     fLogFile: Integer;  { A file handle to the log file }
     szParam: PChar;     { String parameter from Wise Installation = System }
  end;

  pLongInt = ^LongInt;

{$else}
  { 32-Bit - Delphi 2.0 }
  ParamRec = record
     wStructLen: DWORD;    { The length of the structure }
     hMainWnd: HWND;       { Handle to main window }
     wMaxReplaces: DWORD;  { Maximum number of replaces }
     wRepNameWidth: DWORD; { The width of a replace name }
     wRepStrWidth: DWORD;  { The width of each replace string }
     wCurrReps: DWORD;     { Current number of replace strings }
     szRepName: PChar;     { The actual replace names }
     szRepStr: PChar;      { The actual replace values }
     wRunMode: DWORD;      { The installation mode }
     fLogFile: DWORD;      { A file handle to the log file }
     szParam: PChar;       { String parameter from Wise Installation System }
  end;
{$endif}

function GetEnterDir   (var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;
function CheckForFonts(var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;
{$IFDEF WIN32}
  function GetConnectFlags(var DLLParams: ParamRec): LongBool; StdCall; export;
  function GetCDVer(var DLLParams: ParamRec) : LongBool; StdCall; export;

  function sbsDiskFree(Drive: Byte) : Double; Export;
  function sbsDiskSize(Drive: Byte) : Double; Export;

  function GetWStationOpts(var DLLParams: ParamRec): LongBool; StdCall; export;
  function GetCompCreateMethod(var DLLParams: ParamRec): LongBool; StdCall; export;

  function GetLastEntDir(var DLLParams: ParamRec): LongBool; StdCall; export;
  Function SCD_GetLastEntDir(var DLLParams: ParamRec): LongBool; StdCall; export;

  { Initializes the Scalable SQL Settings used by ODBC }
  Function SetScalableSQL(var DLLParams: ParamRec): LongBool; StdCall; export;

  { Returns a Drives Serial Number from a specified path }
  function GetDriveSno(var DLLParams: ParamRec) : LongBool; StdCall; export;

  { Updates the PATH statement for the current process }
  function SCD_SetEnvPath(var DLLParams: ParamRec) : LongBool; StdCall; export;

  // Callback function to identify the Btrieve window
  function EnumBtrieveWindow (Hwnd: THandle; lParam : pLongInt): Bool; stdcall; export;

  // Tries to find and close Btrieve
  function SCD_DieBtrieveDie (var DLLParams: ParamRec) : LongBool; StdCall; export;

  // Check to see if Btrieve is still running in memory
  function SCD_CheckForBtrieve (var DLLParams: ParamRec) : LongBool; StdCall; export;

  { Updates the PATH statement for the current process to include the Enterprise directory }
  function SCD_SetEnterprisePath(var DLLParams: ParamRec) : LongBool; StdCall; export;

  { Updates the PATH statement for the current process to include the Enterprise\FaxSrv directory }
  function SCD_SetEnterpriseFaxingPath(var DLLParams: ParamRec) : LongBool; StdCall; export;

  {Updates the EXCHEQUERDBTYPE statment for sqlutils calls}
  function SCD_SetEnterpriseDBTYPE(var DLLParams: ParamRec) : LongBool; StdCall; export;

  // Updates the PATH statement for the current process to include the PVSW\BIN directory
  function SCD_SetPVSWPath(var DLLParams: ParamRec) : LongBool; StdCall; export;

{$ELSE}
  Function Trim(S : String) : String;
{$ENDIF}

procedure GetVariable (var DLLParams: ParamRec; const VarName: string; var VarValue: string); export;
procedure SetVariable (var DLLParams: ParamRec; const VarName: string; const NewValue: string); export;



implementation

{$IFDEF WIN32}
  Uses SetupDi2, wstcfg, CompType, CDVerU, SerialU, APIUtil, PervInfo;
{$ELSE}
  Uses SetDir16;
{$ENDIF}

{$IFNDEF WIN32}
  { Function Required by 16-bit Delphi 1.0 }
  Function Trim(S : String) : String;
  Begin
    { Trim Blanks Off Start }
    While (Length(S) > 0) And (S[0] In [#0, #32]) Do
      Delete (S, 1, 1);

    { Trim (Blanks Off End }
    While (Length(S) > 0) And (S[Length(S)] In [#0, #32]) Do
      Delete (S, Length(S), 1);

    Result := S;
  End;
{$ENDIF}

{ Retrieves a WISE Variable Value }
procedure GetVariable(var DLLParams: ParamRec; const VarName: string; var VarValue: string);
var
  i: Integer;
  szVarName: array[0..255] of char;
begin
  VarValue := '';
  szVarName[0] := '%';
  StrPCopy(@szVarName[1],VarName);
  StrCat(szVarName,'%');
  for i := 0 to DLLParams.wCurrReps do
  begin
     if (StrComp(szVarName,@DLLParams.szRepName[i * DLLParams.wRepNameWidth]) = 0) then
     begin
        VarValue := StrPas(@DLLParams.szRepStr[i * DLLParams.wRepStrWidth]);
        Exit;
     end;
  end;
end;


{ Sets a WISE Variable value }
procedure SetVariable(var DLLParams: ParamRec; const VarName: string; const NewValue: string);
var
  i: Integer;
  szVarName: array[0..255] of char;
begin
  szVarName[0] := '%';
  StrPCopy(@szVarName[1],VarName);
  StrCat(szVarName,'%');
  for i := 0 to DLLParams.wCurrReps do
  begin
     if (StrComp(szVarName,@DLLParams.szRepName[i * DLLParams.wRepNameWidth]) = 0) then
     begin
        StrPCopy(@DLLParams.szRepStr[i * DLLParams.wRepStrWidth],NewValue);
        Exit;
     end;
  end;
  StrCopy(@DLLParams.szRepName[DLLParams.wCurrReps * DLLParams.wRepNameWidth],szVarName);
  StrPCopy(@DLLParams.szRepStr[DLLParams.wCurrReps * DLLParams.wRepStrWidth],NewValue);
  DLLParams.wCurrReps := DLLParams.wCurrReps + 1;
end;


{ Get }
function GetEnterDir(var DLLParams: ParamRec): LongBool;
var
  DirectoryDialog                : TDirectoryDialog;
  DlgPN, HlpPath, DefDrv, CcyVer : String;

  Function Switch (Bool : Boolean; Val1, Val2 : LongInt) : LongInt;
  Begin
    If Bool Then Result := Val1 Else Result := Val2;
  End;

begin
  { Get path of help file }
  GetVariable(DLLParams, 'INST', DlgPN);
  {If (Copy (DlgPN, Length(DlgPN), 1)[1] In [':', '\']) Then
    Application.HelpFile := DlgPN + 'ENTREAD.HLP'
  Else
    Application.HelpFile := DlgPN + '\ENTREAD.HLP';}

  If Not (Copy (DlgPN, Length(DlgPN), 1)[1] In [':', '\']) Then
    HlpPath := DlgPN + '\'
  Else
    HlpPath := DlgPN;

  DirectoryDialog := TDirectoryDialog.Create(Application);
  Try
    With DirectoryDialog Do Begin
      {$IFDEF WIN32}
        { Resize for the resolution }
        AutoResize (2, 0);
      {$ENDIF}

      { Get Prev/Next dialog string }
      GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);

      { Get default installation directory from WISE }
      GetVariable(DLLParams, 'DLGDIR', DefDrv);

      {$IFDEF WIN32}
        SCuD := (Length(DlgPN) = 6);
      {$ELSE}
        SCuD := False;
      {$ENDIF}

      { HM 10/05/99: Modified to support new Setup }
      If SCuD Then Begin
        { Single CD: Get Currency Type of CD }
        GetVariable(DLLParams, 'L_CURRVER', CcyVer);
        If (Length(Trim(CcyVer)) = 1) Then
          Case CcyVer[1] Of
            '0' : CurrMode := 'S';  { Single Currency }
            '1' : CurrMode := 'M';  { Euro }
            '2' : CurrMode := 'M';  { Multi-Currency }
          Else
            CurrMode := 'S';
          End { Case }
        Else
          CurrMode := 'S'; { Shouldn't ever happen }
      End { If }
      Else Begin
        { Old Setup: Get Currency Type of CD }
        GetVariable(DLLParams, 'CURRENCYVER', CcyVer);
        If (Length(Trim(CcyVer)) = 1) Then
          CurrMode := Trim(CcyVer)[1]
        Else
          CurrMode := 'S'; { Shouldn't ever happen }
      End; { Else }

      { Get mode - passed as parameter }
      ValidMode := DllParams.szParam[0];

      { Set On-Line Help File }
      If (ValidMode In ['Y', 'Z', 'z']) Then
        Application.HelpFile := HlpPath + 'ENTDLL31.HLP'
      Else
        If (ValidMode = 'V') Then
          Application.HelpFile := HlpPath + 'COMPASS.HLP'
        Else
          If (ValidMode = 'v') Then
            Application.HelpFile := HlpPath + 'SETUPCUS.HLP'
          Else
            Application.HelpFile := HlpPath + 'ENTREAD.HLP';

      Case ValidMode Of
        '1' : Begin { Pervasive.SQL CD Image }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory where you want your Pervasive.SQL CD Image to be installed:';
                Title := 'Pervasive.SQL CD';
              End;
        '2' : Begin { Single CD Image - Update Directory }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing your Exchequer system files:';
                Title := 'Upgrade Directory';

                WantFindEnt := 3;
              End;
        'A' : Begin { Install Connectivity Kit }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing your Exchequer system files:';
                Title := 'Main Company';
              End;
        'B' : Begin { Upgrade Connectivity Kit }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the Connectivity Kit directory you want to upgrade:';
                Title := 'Upgrade Connectivity Kit';
              End;
        'C' : Begin { Install New Company - System }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing your Exchequer system ' +
                                'files or click the &Find button to search for the directory:';
                Title := 'Main Company';

                WantFindEnt := 1;
              End; { C }
        'c',
        'k' : Begin { Install New Company - Data }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory you want to install the new company data files into:';
                Title := 'New Company';

                If (ValidMode = 'c') And (Length(DlgPN) <> 6) Then
                  NextBtn.Caption := '&Install';
              End; { c }
        'I' : Begin { Install Enterprise }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory where you want to install Exchequer:';
                Title := 'Install Exchequer';
              End; { I }
        'K' : Begin { Connectivity Kit - Install New Company - System }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing your Exchequer system files:';
                Title := 'Main Company';
              End; { K }
        'N' : Begin { Networked Enterprise directory }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing your Networked Exchequer system ' +
                                'or click the &Find button to search for the directory:';
                Title := 'Network Exchequer';

                WantFindEnt := 1;
              End; { N }
        'n' : Begin { Local Enterprise dir for program files on workstation }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the Local directory where you want the Exchequer ' +
                                'Program Files to be installed:';
                Title := 'Local Exchequer';
              End; { n }
        'R' : Begin { Register }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing your Exchequer system ' +
                                'files or click the &Find button to search your computer for the directory:';
                Title := 'Register Exchequer';

                WantFindEnt := 1;
              End; { R }
        'r' : Begin { Register Connectivity Kit }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing the Connectivity Kit ' +
                                'you want to register:';
                Title := 'Register Connectivity Kit';
              End; { R }
        'T' : Begin { Toolkit DLL }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory you want to install the Toolkit DLL into:';
                Title := 'Toolkit DLL';
              End; { U }
        'U' : Begin { Upgrade from Exchequer }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing the Exchequer DOS system to be ' +
                                'upgraded to Exchequer for Windows or click the &Find button to search ' +
                                'for the directory:';
                Title := 'Upgrade Exchequer DOS';

                WantFindEnt := 2;
              End; { U }
        'u' : Begin { Upgrade Enterprise }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the Exchequer directory you want to upgrade ' +
                                'or click the &Find button to search for the directory:';
                Title := 'Upgrade Exchequer';

                WantFindEnt := 1;
              End; { u }
        'W' : Begin { Workstation }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing the Exchequer system ' +
                                'you want to setup on this computer or click the &Find button to search ' +
                                'for the directory:';
                Title := 'Workstation Setup';

                WantFindEnt := 1;
              End; { W }
        'w' : Begin { Workstation - Connectivity Kit }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing the Connectivity Kit you want ' +
                                'to setup on this machine:';
                Title := 'Workstation Setup';
              End; { W }
        'X' : Begin { Crystal Reports directory }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing your copy of Crystal Reports:';
                Title := 'Crystal Reports';
              End;
        'Z' : Begin { Install Toolkit DLL }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory you want to install the Toolkit DLL into:';
                Title := 'Toolkit DLL';
              End; { U }
        'z' : Begin { Upgrade Toolkit DLL }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing the Toolkit DLL:';
                Title := 'Upgrade Toolkit DLL';
              End; { U }
        'Y' : Begin { Configure Toolkit DLL }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing the Toolkit DLL:';
                Title := 'Configure Toolkit DLL';
              End; { U }
        'V' : Begin { Compass - Enterprise Directory }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing the Exchequer System:';
                Title := 'Exchequer Directory';
                Caption := 'Exchequer Compass Installation';
              End; { U }
        'v' : Begin { Customisation - Enterprise Directory }
                HelpContextID := 10005;
                InstallPath := DefDrv;
                Instructions := 'Please specify the directory containing the Exchequer System:';
                Title := 'Exchequer Directory';
                Caption := 'Exchequer Customisation Setup';
              End; { U }
      End; { Case }

      ShowModal;

      { HM 27/04/99: Modified to support new Setup with 3-digit dialog id's }
      Case ExitCode Of
        'B' : Begin { Back }
                If SCuD Then
                  { New Method - 3 character Id for each Dialog }
                  SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3))
                Else
                  { Old Method - 1 character Id for each Dialog }
                  SetVariable(DLLParams,'DIALOG',DlgPN[1]);
              End;
        'N' : Begin { Next }
                If SCuD Then
                  { New Method - 3 character Id for each Dialog }
                  SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3))
                Else
                  { Old Method - 1 character Id for each Dialog }
                  SetVariable(DLLParams,'DIALOG',DlgPN[2]);

                SetVariable(DLLParams,'DLGDIR',InstallPath);

                If SCuD Then Begin
                  { Write Warning flags to Wise Script }
                  If (GlobFlags[1] = 0) Then Begin
                    SetVariable(DLLParams, 'W_OVERWRITE', 'N');
                    SetVariable(DLLParams, 'W_OWDIR', '');
                  End { If }
                  Else Begin
                    SetVariable(DLLParams, 'W_OVERWRITE', 'Y');
                    SetVariable(DLLParams, 'W_OWDIR', InstallPath);
                  End; { Else }
                End; { If SCuD }
              End;
        'X' : Begin { Exit Installation }
                If SCuD Then
                  { New Method - 3 character Id for each Dialog }
                  SetVariable(DLLParams,'DIALOG','999')
                Else
                  { Old Method - 1 character Id for each Dialog }
                  SetVariable(DLLParams,'DIALOG','Z');
              End;
      End; { If }
    End; { With }
  Finally
    DirectoryDialog.Free;
  End;

  Result := False;
end;


{ Get }
function CheckForFonts(var DLLParams: ParamRec): LongBool;
Type
  FontSetType = Array [1..12] Of ShortString;
Const
  Codabar_Fonts : FontSetType = ('CBARHDM2.TTF','CBARHDM3.TTF','CBARHDN2.TTF',
                                 'CBARHDN3.TTF','CBARHDW2.TTF','CBARHDW3.TTF',
                                 'CBARM2.TTF','CBARM3.TTF','CBARN2.TTF',
                                 'CBARN3.TTF','CBARW2.TTF','CBARW3.TTF');
  Code128_Fonts : FontSetType = ('C128HDM.TTF','C128HDN.TTF','C128HDW.TTF',
                                 'C128M.TTF','C128N.TTF','C128W.TTF',
                                 '','','','','','');
  Code39_Fonts  : FontSetType = ('C39HDM2.TTF','C39HDM3.TTF','C39HDN2.TTF',
                                 'C39HDN3.TTF','C39HDW2.TTF','C39HDW3.TTF',
                                 'C39M2.TTF','C39M3.TTF','C39N2.TTF',
                                 'C39N3.TTF','C39W2.TTF','C39W3.TTF');
  Inter25_Fonts : FontSetType = ('I25HDM.TTF','I25HDN.TTF','I25HDW.TTF',
                                 'I25M.TTF','I25N.TTF','I25W.TTF',
                                 '','','','','','');
  PostNet_Fonts : FontSetType = ('PNET.TTF','','','','','','','','','','','');
  UPC_EAN_Fonts : FontSetType = ('UPCHDM.TTF','UPCHDN.TTF','UPCHDW.TTF',
                                 'UPCM.TTF','UPCN.TTF','UPCW.TTF',
                                 '','','','','','');
var
  DlgPN           : String;
  FontNo          : LongInt;
  FontSet         : FontSetType;
  I               : Byte;
begin
  Result := False;

  { Get path of help file }
  GetVariable(DLLParams, 'DEFFONTDIR', DlgPN);
  If Not (Copy (DlgPN, Length(DlgPN), 1)[1] In [':', '\']) Then
    DlgPN := DlgPN + '\';

  Try
    { Get mode - passed as parameter }
    FontNo := StrToInt(DllParams.szParam[0]);
    Case FontNo Of
      1 : FontSet := Codabar_Fonts;   { Codabar }
      2 : FontSet := Code39_Fonts;    { Code 39 }
      3 : FontSet := Code128_Fonts;   { Code 128 }
      4 : FontSet := Inter25_Fonts;   { Interleaved 2 of 5 }
      5 : FontSet := PostNet_Fonts;   { Postnet }
      6 : FontSet := UPC_EAN_Fonts;   { UPC / EAN }
    End; { Case }

    For I := Low(FontSet) To High(FontSet) Do Begin
      If (FontSet[I] <> '') Then Begin
        If FileExists(DlgPn + FontSet[I]) Then Begin
          Result := True;
          Break;
        End; { If }
      End { If }
      Else
        { Exit as no more fonts in array }
        Break;
    End; { For }
  Except
    On Ex:Exception Do
      MessageDlg ('An error occurred in CheckForFonts: ''' + Ex.Message + '''.',
                  mtError,
                  [mbOk],
                  0);
  End;
End;

{$IFDEF WIN32}
  function sbsDiskFree(Drive: Byte) : Double;
  var
    RootPath: array[0..4] of Char;
    RootPtr: PChar;
    SectorsPerCluster,
    BytesPerSector,
    FreeClusters,
    TotalClusters: DWord;
    SPC, BPS, FC : Double;
  begin
    RootPtr := nil;
    if Drive > 0 then begin
      StrCopy(RootPath, 'A:\');
      RootPath[0] := Char(Drive + $40);
      RootPtr := RootPath;
    end;
    If GetDiskFreeSpace(RootPtr, SectorsPerCluster, BytesPerSector, FreeClusters, TotalClusters) Then Begin
      SPC := SectorsPerCluster;
      BPS := BytesPerSector;
      FC  := FreeClusters;

      Result := SPC * BPS * FC;
    End { If }
    Else
      { Call Failed }
      Result := -1;
  end;

  function sbsDiskSize(Drive: Byte) : Double;
  var
    RootPath: array[0..4] of Char;
    RootPtr: PChar;
    SectorsPerCluster,
    BytesPerSector,
    FreeClusters,
    TotalClusters: DWord;
    SPC, BPS, TC : Double;
  begin
    RootPtr := nil;
    if Drive > 0 then
    begin
      StrCopy(RootPath, 'A:\');
      RootPath[0] := Char(Drive + $40);
      RootPtr := RootPath;
    end;
    if GetDiskFreeSpace(RootPtr, SectorsPerCluster, BytesPerSector, FreeClusters, TotalClusters) then Begin
      SPC := SectorsPerCluster;
      BPS := BytesPerSector;
      TC  := TotalClusters;

      Result := SPC * BPS * TC;
    End { If }
    Else
      { Call failed }
      Result := -1;
  end;

  { Get }
  function GetConnectFlags(var DLLParams: ParamRec): LongBool;
  var
    DirectoryDialog : TDirectoryDialog;
    DlgPN, ConFlags : String;
  begin
    { Get path of help file }
    GetVariable(DLLParams, 'INST', DlgPN);
    If (Copy (DlgPN, Length(DlgPN), 1)[1] In [':', '\']) Then
      Application.HelpFile := DlgPN + 'ENTREAD.HLP'
    Else
      Application.HelpFile := DlgPN + '\ENTREAD.HLP';


    { Get installation directory from WISE }
    GetVariable(DLLParams, 'DLGDIR', DlgPN);
    GetVariable(DLLParams, 'CONNECTFLAGS', ConFlags);

    { Check Installation Dir and build ConnectFlags string }
    ConFlags := '';
    If FileExists (DlgPN + '\ENTER1.EXE') Then
      ConFlags := ConFlags + 'A';
    If FileExists (DlgPN + '\MCOMPMAN.SYS') Then
      ConFlags := ConFlags + 'B';
    If FileExists (DlgPN + '\ENTEROLE.EXE') Then
      ConFlags := ConFlags + 'C';
    If FileExists (DlgPN + '\FIELD.DDF') Then
      ConFlags := ConFlags + 'D';

    { Send Flags back to WISE }
    SetVariable(DLLParams,'CONNECTFLAGS', ConFlags);

    Result := False;
  end;


  { Gets the CD Version based on the ~Mc... files }
  function GetCDVer(var DLLParams: ParamRec) : LongBool;
  var
    DlgPN, EnMu, EnVer : String;
    UCount             : SmallInt;
    ClSvr              : Boolean;
  begin
    { Get path of help file }
    GetVariable(DLLParams, 'INST', DlgPN);

    { Get installation info from WISE }
    GetVariable(DLLParams, 'ENVER', EnVer);
    GetVariable(DLLParams, 'ENMU', EnMu);

    If FindCDVer(DlgPN, EnVer, UCount, ClSvr) Then Begin
      If (UCount > 1) Then
        EnMU := 'Y'
      Else
        EnMU := 'N';
    End { If }
    Else Begin
      EnVer := '';
      EnMU  := 'Y';
    End; { If }

    { Send Flags back to WISE }
    SetVariable(DLLParams, 'ENVER', EnVer);
    SetVariable(DLLParams, 'ENMU', EnMu);

    Result := False;

    (*
    If Not (Copy (DlgPN, Length(DlgPN), 1)[1] In [':', '\']) Then
      DlgPN := DlgPN + '\~*.u*'
    Else
      DlgPN := DlgPN + '~*.u*';

    { Get installation info from WISE }
    GetVariable(DLLParams, 'ENVER', EnVer);
    GetVariable(DLLParams, 'ENMU', EnMu);

    EnVer := '';
    EnMu  := 'N';
    If (FindFirst (DlgPN, faAnyFile, F) = 0) Then Begin
      F.Name := UpperCase(F.Name);

      If (Pos('PF', F.Name) > 0) Then
        EnVer := EnVer + 'Professional/'
      Else
        EnVer := EnVer + 'Global/';
      If (Pos('SOP', F.Name) > 0) Then EnVer := EnVer + 'SOP/';
      If (Pos('STK', F.Name) > 0) Then EnVer := EnVer + 'STK/';
      If (Pos('CS.', F.Name) > 0) Then EnVer := EnVer + 'CS/';

      Ext := ExtractFileExt(F.Name);
      If (Length(Ext) > 2) Then Begin
        { Extract user count - delete '.U' part of extension }
        Delete (Ext, 1, 2);
        EnVer := EnVer + Ext;

        Try
          { Calculate user count }
          If (StrToInt(Ext) > 1) Then
            EnMu := 'Y';
        Except
          On E:Exception Do
            MessageDlg ('An error occurred whilst calculating the User Count - Single User has been assumed',
                        mtWarning, [mbOk], 0);
        End;
      End; { If }

      If (Length(EnVer) > 0) Then Begin
        { Take off any crud at the end }
        If (EnVer[Length(EnVer)] = '/') Then
          Delete (EnVer, Length(EnVer), 1);
      End; { If }
    End; { If }
    FindClose(F);

    { Send Flags back to WISE }
    SetVariable(DLLParams, 'ENVER', EnVer);
    SetVariable(DLLParams, 'ENMU', EnMu);

    Result := False;
    *)
  end;
{$ENDIF}


{$IFDEF WIN32}
  { Get }
  function GetWStationOpts(var DLLParams: ParamRec): LongBool;
  var
    frmWStationConfig      : TfrmWStationConfig;
    DlgPN, HlpPath, CcyVer : String;
  begin
    { Get path of help file }
    GetVariable(DLLParams, 'INST', DlgPN);
    If Not (Copy (DlgPN, Length(DlgPN), 1)[1] In [':', '\']) Then
      HlpPath := DlgPN + '\'
    Else
      HlpPath := DlgPN;
    Application.HelpFile := HlpPath + 'ENTREAD.HLP';

    frmWStationConfig := TfrmWStationConfig.Create(Application);
    Try
      With frmWStationConfig Do Begin
        { Setup dialog }
        GetVariable(DLLParams, 'WANTWSLOCAL', DlgPN);
        If (DlgPN[1] = 'Y') Then
          radLocal.Checked := True
        Else
          radStandard.Checked := True;

        { Display dialog }
        ShowModal;

        { Get Previous/next dialog ID's }
        If (ExitCode In ['B', 'N']) Then
          GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);

        Case ExitCode Of
          'B' : Begin { Back }
                  SetVariable(DLLParams,'DIALOG',DlgPN[1]);
                End;
          'N' : Begin { Next }
                  SetVariable(DLLParams,'DIALOG',DlgPN[2]);

                  { Return selected option }
                  If radLocal.Checked Then
                    SetVariable(DLLParams,'WANTWSLOCAL', 'Y')
                  Else
                    SetVariable(DLLParams,'WANTWSLOCAL', 'N');
                End;
          'X' : Begin { Exit Installation }
                  SetVariable(DLLParams,'DIALOG','Z');
                End;
        End; { If }
      End; { With }
    Finally
      frmWStationConfig.Free;
    End;

    Result := False;
  end;

  { Gets the method to create a company}
  function GetCompCreateMethod(var DLLParams: ParamRec): LongBool;
  var
    frmCompanyType    : TfrmCompanyType;
    DlgPN, HlpPath    : String;
    VarName, ChkState : String;
  begin
    { Get path of help file }
    GetVariable(DLLParams, 'INST', DlgPN);
    If Not (Copy (DlgPN, Length(DlgPN), 1)[1] In [':', '\']) Then
      HlpPath := DlgPN + '\'
    Else
      HlpPath := DlgPN;
    Application.HelpFile := HlpPath + 'SETUP.HLP';

    frmCompanyType := TfrmCompanyType.Create(Application);
    Try
      With frmCompanyType Do Begin
        { HM 27/04/99: Modified to support new Setup with 3-digit dialog id's }
        GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);
        If (Length(DlgPN) = 6) Then
          VarName := 'V_DEMODATA'
        Else
          VarName := 'WANTDEMOCOMP';

        { Setup dialog }
        GetVariable(DLLParams, VarName, ChkState);
        If (ChkState[1] = 'N') Then
          radNew.Checked := True
        Else
          radDemo.Checked := True;

        { Display dialog }
        ShowModal;

        Case ExitCode Of
          'B' : Begin { Back }
                  If (Length(DlgPN) = 6) Then
                    { New Method - 3 character Id for each Dialog }
                    SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3))
                  Else
                    { Old Method - 1 character Id for each Dialog }
                    SetVariable(DLLParams,'DIALOG',DlgPN[1]);
                End;
          'N' : Begin { Next }
                  If (Length(DlgPN) = 6) Then
                    { New Method - 3 character Id for each Dialog }
                    SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3))
                  Else
                    { Old Method - 1 character Id for each Dialog }
                    SetVariable(DLLParams,'DIALOG',DlgPN[2]);

                  { Return selected option }
                  If radNew.Checked Then
                    SetVariable(DLLParams, VarName, 'N')
                  Else
                    SetVariable(DLLParams, VarName, 'Y');
                End;
          'X' : Begin { Exit Installation }
                  If (Length(DlgPN) = 6) Then
                    { New Method - 3 character Id for each Dialog }
                    SetVariable(DLLParams,'DIALOG','999')
                  Else
                    { Old Method - 1 character Id for each Dialog }
                    SetVariable(DLLParams,'DIALOG','Z');
                End;
        End; { If }
      End; { With }
    Finally
      frmCompanyType.Free;
    End;

    Result := False;
  end;

  Function GetEntDir (Const MainDir : ShortString) : ShortString;
  var
    RegObj    : TRegistry;
    LastDir   : String;
  Begin { GetEntDir }
    LastDir := '';

    { Create registry access object }
    RegObj := TRegistry.Create;
    Try
      RegObj.Access := KEY_READ;
      RegObj.RootKey := HKEY_LOCAL_MACHINE;

      If RegObj.KeyExists('Software\Exchequer\Enterprise') Then Begin
        If RegObj.OpenKey('Software\Exchequer\Enterprise', False) Then Begin
          { Key opened ok }
          LastDir := Trim(RegObj.ReadString ('LastDir'));

          If (Length(LastDir) > 0) Then Begin
            If (LastDir[Length(LastDir)] <> '\') Then Begin
              LastDir := LastDir + '\';
            End; { If }
          End; { If }
        End; { If }
      End; { If }
    Finally
      RegObj.CloseKey;
      RegObj.Free;
    End;

    If (Trim(LastDir) <> '') Then Begin
      { Check path points to a valid Enterprise system }
      If Not (DirectoryExists (LastDir) And
              FileExists (LastDir + 'ENTER1.EXE') And
//              FileExists (LastDir + 'EXCHQSS.DAT') And
              DirectoryExists (LastDir + '\FORMS')) Then Begin
        LastDir := MainDir;
      End; { If }
    End { If }
    Else Begin
      LastDir := MainDir;
    End; { Else }

    Result := LastDir;
  End; { GetEntDir }

  Function GetLastEntDir(var DLLParams: ParamRec): LongBool;
  Var
    MainDir : String;
  Begin { GetLastEntDir }
    GetVariable(DLLParams, 'MAINDIR', MainDir);

    SetVariable(DLLParams,'LASTDIR',GetEntDir (MainDir));

    Result := False;
  End;  { GetLastEntDir }

  Function SCD_GetLastEntDir(var DLLParams: ParamRec): LongBool;
  Var
    MainDir : String;
  Begin { SCD_GetLastEntDir }
    GetVariable(DLLParams, 'V_MAINDIR', MainDir);

    SetVariable(DLLParams,'V_LASTDIR',GetEntDir (MainDir));

    Result := False;
  End;  { SCD_GetLastEntDir }


  { Initializes the Scalable SQL Settings used by ODBC        }
  { Note: Also set in EntRegU (MCM) and EntReg2u (EntReg.Exe) }
  Function SetScalableSQL(var DLLParams: ParamRec): LongBool;
  var
    RegObj  : TRegistry;
    TmpStr  : String;

    Procedure CheckDWord (Const Key : String;Const Value : Integer);
    Var
      DWord  : Integer;
    Begin
      DWord := RegObj.ReadInteger(Key);
      If (DWord < Value) Then Begin
        DWord := Value;
        RegObj.WriteInteger (Key, DWord);
      End; { If }
    End;

  Begin { GetLastEntDir }
    GetVariable(DLLParams, 'WANTSCALSQL', TmpStr);
    TmpStr := Uppercase(TmpStr) + ' ';

    { Create registry access object }
    RegObj := TRegistry.Create;
    Try
      RegObj.Access := KEY_READ Or KEY_WRITE;
      RegObj.RootKey := HKEY_LOCAL_MACHINE;

      If RegObj.OpenKey('SOFTWARE\Pervasive Software\Scalable SQL Requester\Version 4.00\Settings', False) Then Begin
        RegObj.WriteString ('local', 'yes');
        CheckDWord  ('logins', 10);
        RegObj.WriteInteger ('target engine', 0);

        If (TmpStr[1] = 'Y') Then Begin
          RegObj.WriteString ('requester', 'yes');
        End { If }
        Else Begin
          RegObj.WriteString ('requester', 'no');
        End; { Else }
      End; { If }
    Finally
      RegObj.CloseKey;
      RegObj.Free;
    End;

    Result := False;
  End;  { GetLastEntDir }

  { Returns a Drives Serial Number from a specified path }
  function GetDriveSno(var DLLParams: ParamRec) : LongBool; StdCall; export;
  var
    Params : ANSIString;
    TheSno : ShortString;
  Begin { GetDriveSno }
    TheSno := '0000-0000';

    { Check security parameter }
    Params := DLLParams.szParam;
    If (Trim(Params) <> '') Then Begin
      TheSNo := GetDriveSerial (Params[1]);
    End; { If }

    SetVariable(DLLParams, 'V_CDSNO', TheSno)
  End; { GetDriveSno }

  //-------------------------------------------------------------------------

  { Updates the PATH statement for the current process }
  function SCD_SetEnvPath(var DLLParams: ParamRec) : LongBool; StdCall; export;
  var
    CurrentPath : String;
    EntDir      : String;
    NewPath     : ANSIString;
  Begin { SCD_SetEnvPath }
    // Get path from Workstation Setup
    GetVariable(DLLParams, 'V_MAINDIR', EntDir);
    EntDir := EntDir + '\BIN';

    // Get current PATH for the process
    CurrentPath := SysUtils.GetEnvironmentVariable('PATH');

    // Check to see if it is already present in the path
    If (Pos(UpperCase(EntDir), UpperCase(CurrentPath)) = 0) Then Begin
      // Build the new path with the Enterprise directory at the start
      NewPath := EntDir + ';' + CurrentPath;

      // Update the environment settings for the current process
      SetEnvironmentVariable('PATH', PChar(NewPath));
    End; { If (Pos(UpperCase(EntDir), CurrentPath) = 0) }
  End; { SCD_SetEnvPath }

  //-------------------------------------------------------------------------

  function strToken(var S: String; Seperator: Char): String;
  var
    I               : Word;
  begin
    I:=Pos(Seperator,S);
    if I<>0 then
    begin
      Result:=System.Copy(S,1,I-1);
      System.Delete(S,1,I);
    end else
    begin
      Result:=S;
      S:='';
    end;
  end; {strToken}


  //-------------------------------------------------------------------------

  { Updates the PATH statement for the current process to include the Enterprise directory }
  function SCD_SetEnterprisePath(var DLLParams: ParamRec) : LongBool; StdCall; export;
  var
    CurrentPath, TempPath : String;
    EntDir      : String;
    NewPath     : ANSIString;
    lFound: Boolean;
  Begin { SCD_SetEnterprisePath }
    // Get path from Workstation Setup
    GetVariable(DLLParams, 'V_MAINDIR', EntDir);

    // Get current PATH for the process
    CurrentPath := SysUtils.GetEnvironmentVariable('PATH');

//    // Check to see if it is already present in the path
//    If (Pos(UpperCase(EntDir), UpperCase(CurrentPath)) = 0) Then Begin
//      // Build the new path with the Enterprise directory at the start
//      NewPath := EntDir + ';' + CurrentPath;
//
//      // Update the environment settings for the current process
//      SetEnvironmentVariable('PATH', PChar(NewPath));
//    End; { If (Pos(UpperCase(EntDir), CurrentPath) = 0) }

    lFound:= False;
    TempPath := UpperCase(CurrentPath);
    While Length(TempPath) > 0 do
    begin
      lFound := UpperCase(EntDir) = strToken(TempPath, ';');
      if lFound then
        Break;
    end; {for lCont:= 0 to lList.Count - 1 do}

    if not lFound then
    begin
      // Build the new path with the Enterprise directory at the start
      NewPath := EntDir + ';' + CurrentPath;

      // Update the environment settings for the current process
      SetEnvironmentVariable('PATH', PChar(NewPath));
    end;

    // Update the environment settings for the current process
    EntDir := IncludeTrailingPathDelimiter(EntDir);
    SetEnvironmentVariable('EXCHEQUERINSTALLDIR', PChar(EntDir));

//CurrentPath := SysUtils.GetEnvironmentVariable('PATH');
//ShowMessage('CurrentPath: ' + CurrentPath);
  End; { SCD_SetEnterprisePath }

  //-------------------------------------------------------------------------

  { Updates the PATH statement for the current process to include the Enterprise\FaxSrv directory }
  function SCD_SetEnterpriseFaxingPath(var DLLParams: ParamRec) : LongBool; StdCall; export;
  var
    CurrentPath, TempPath : String;
    EntDir      : String;
    NewPath     : ANSIString;
    lFound: Boolean;
  Begin { SCD_SetEnterpriseFaxingPath }
    // Get path from Workstation Setup
    GetVariable(DLLParams, 'V_MAINDIR', EntDir);
    EntDir := IncludeTrailingPathDelimiter(EntDir) + 'FaxSrv';

    // Get current PATH for the process
    CurrentPath := SysUtils.GetEnvironmentVariable('PATH');

    lFound:= False;
    TempPath := UpperCase(CurrentPath);
    While Length(TempPath) > 0 do
    begin
      lFound := UpperCase(EntDir) = strToken(TempPath, ';');
      if lFound then
        Break;
    end; {for lCont:= 0 to lList.Count - 1 do}

    if not lFound then
    begin
      // Build the new path with the Enterprise directory at the start
      NewPath := EntDir + ';' + CurrentPath;

      // Update the environment settings for the current process
      SetEnvironmentVariable('PATH', PChar(NewPath));
    end;
  End; { SCD_SetEnterpriseFaxingPath }

  //-------------------------------------------------------------------------

  { Updates the exchequerdbtype value for the current process }
  function SCD_SetEnterpriseDBTYPE(var DLLParams: ParamRec) : LongBool; StdCall; export;
  var
    DBTYPE : String;
  Begin { SCD_SetEnterpriseDBTYPE }
    // Get dbtype from Workstation Setup
    GetVariable(DLLParams, 'L_DBTYPE', DBTYPE);

    // Update the environment settings for the current process
    SetEnvironmentVariable('EXCHEQUERDBTYPE', PChar(DBTYPE));
  End; { SCD_SetEnterpriseDBTYPE }


  //-------------------------------------------------------------------------

  // Updates the PATH statement for the current process to include the PVSW\BIN directory
  function SCD_SetPVSWPath(var DLLParams: ParamRec) : LongBool;
  var
    CurrentPath : String;
    EntDir      : String;
    NewPath     : ANSIString;
  Begin // SCD_SetPVSWPath
    If PervasiveInfo.WorkgroupInstalled Then
    Begin
      // Get current PATH for the process
      CurrentPath := SysUtils.GetEnvironmentVariable('PATH');

      // Check to see if it is already present in the path
      If (Pos(UpperCase(PervasiveInfo.WorkgroupDirectory), UpperCase(CurrentPath)) = 0) Then
      Begin
        // Build the new path with the Enterprise directory at the start
        NewPath := PervasiveInfo.WorkgroupDirectory + ';' + CurrentPath;

        // Update the environment settings for the current process
        SetEnvironmentVariable('PATH', PChar(NewPath));
      End; // If (Pos(UpperCase(PervasiveInfo.WorkgroupDirectory), UpperCase(CurrentPath)) = 0)
    End; // If PervasiveInfo.WorkgroupInstalled

//CurrentPath := SysUtils.GetEnvironmentVariable('PATH');
//ShowMessage('CurrentPath: ' + CurrentPath);
  End; // SCD_SetPVSWPath

  //-------------------------------------------------------------------------

  // Callback function to identify the Btrieve window
  function EnumBtrieveWindow (Hwnd: THandle; lParam : pLongInt): Bool;
  var
    ClassName : string;
  begin { EnumBtrieveWindow }
    // Get the window Class Name e.g. TForm1
    SetLength (ClassName, 100);
    GetClassName (Hwnd, PChar (ClassName), Length (ClassName));
    ClassName := PChar (Trim(ClassName));

    // Check to see if the class matches that of the Btrieve v6.15 Microkernel Engine
    If (AnsiCompareText (ClassName, 'BTI-MKDE') = 0) then begin
      // Return False to stop the enumeration
      lParam^ := hWnd;
      Result := False;
    End { If (AnsiCompareText (ClassName, 'BTI-MKDE') = 0) }
    Else
      // Continue the enumeration
      Result := True;
  end; { EnumBtrieveWindow }

  //------------------------------

  // Tries to find and close Btrieve
  function SCD_DieBtrieveDie (var DLLParams: ParamRec) : LongBool; StdCall; export;
  Var
    lParam : LongInt;
  begin { SCD_DieBtrieveDie }
    lParam := 0;
    EnumWindows (@EnumBtrieveWindow, Longint(@lParam));

    If (lParam <> 0) Then
    Begin
      // HM 24/10/03: Modified to Show the Btrieve window and post the message to avoid
      // the function stalling when the 'Clients Active - Close Y/N' message is displayed
      // by the 6.15 Microkernel Engine when its running as hidden.
      ShowWindow (lParam, SW_SHOWNORMAL);
      PostMessage (lParam, WM_Close, 0, 0);
    End; // If (lParam <> 0)
  end; { SCD_DieBtrieveDie }

  //------------------------------

  // Check to see if Btrieve is still running in memory
  function SCD_CheckForBtrieve (var DLLParams: ParamRec) : LongBool; StdCall; export;
  Var
    lParam : LongInt;
    DlgPN  : String;
  begin { SCD_CheckForBtrieve }
    GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);

    // Search for v6.15 MKDE window
    lParam := 0;
    EnumWindows (@EnumBtrieveWindow, Longint(@lParam));

    If (lParam <> 0) Then
    Begin
      MessageDlg('The Btrieve v6.15 Microkernel Database Engine is still running ' +
                 'and must be manually shutdown before the Workstation Setup can continue.',
                 mtWarning, [mbOK], 0);

      SetForegroundWindow (lParam);

      SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));
    End // If (lParam <> 0)
    Else
    Begin
      SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));
    End; // Else
  end; { SCD_CheckForBtrieve }

  //-------------------------------------------------------------------------

{$ENDIF}

Initialization
  Application.HelpFile := 'ENTREAD.HLP';
end.
