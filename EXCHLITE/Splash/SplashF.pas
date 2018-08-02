unit SplashF;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {GlobVar, }ExtCtrls, Registry, FileCtrl, StdCtrls, IniFiles;

// Compiler Definition for debuging the Mobile-Desktop statup problem
{ DEFINE DBG_MOD_DESK}

Const
  WM_SBSFDMsg      = WM_User + $100;
  WM_PrintProgress = WM_USER + $101;
  WM_InPrint       = WM_USER + $103;

type
  TEnterSplash = class(TForm)
    imgSplash: TImage;
    lblCopyright: TLabel;
    Timer1: TTimer;
    lblProdName: TLabel;
    lblLicenceType: TLabel;
    lblLicencee: TLabel;
    lblDemoVer: TLabel;
    lblVAOFlag: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    _InitCompMan : Procedure (NewApp : TApplication);
    _ShowCompMan : Procedure (SplashHandle : hWnd; CmdParam : ShortString);
    _MyGSRHandle : THandle;

    WantCompMan : Boolean;

    InPrint     : Boolean;

    IsWSLocal   : Boolean;
    IsWorkgroup : Boolean;
    WSNetDir    : ShortString;

    VAOConfigError : Boolean;

    Function RunNonMCM : ShortString;

    Procedure WMSBSFDMsg(Var Message  :  TMessage); Message WM_SBSFDMsg;
     procedure PrintProgress(var Msg: TMessage); message WM_PrintProgress;
  public
    { Public declarations }
  end;

Var
  EnterSplash  :  TEnterSplash;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ShellAPI,
  PathUtil,
  DiskUtil,
  CompUtil,
  ChkPrntr,
  spFixReg,
  LicRec,
  EntLic,
  VAOUtil,
  OSChecks,
  Brand;

{$R *.DFM}
{$R EntrprXP.Res}

Const
  {$I FilePath.Inc}
  {$I VerModU.Pas}


procedure TEnterSplash.FormCreate(Sender: TObject);
//Const
  //ResNames : Array[0..2] of PChar = ('EntComp', 'InitCompMan', 'ShowCompMan');
Var
  //DLLAddr  : TFarProc;
  LicRec    : EntLicenceRecType;
  LibPath   : ANSIString;
  NeedFixup : Boolean;
begin
  IsWSLocal := False;
  WSNetDir := '';

  // MH 25/07/06: Modified so that for Btrieve v6.15 mode it checks the registry entries
  //IsWorkgroup := True;
  IsWorkgroup := Not FileExists(ExtractFilePath(Application.ExeName) + 'W32MKDE.Exe');

  ClientHeight := 214;
  ClientWidth := 357;

  Try
    lblVAOFlag.Visible := (VAOInfo.vaoMode = smVAO) {And VAOInfo.vaoHideBitmaps};
    imgSplash.Visible := (Not VAOInfo.vaoHideBitmaps);
    If (Not imgSplash.Visible) Then
    Begin
      lblDemoVer.Font.Color := clBlack;
      lblLicenceType.Font.Color := clBlack;
      lblLicencee.Font.Color := clBlack;
      lblCopyright.Font.Color := clBlack;
    End; // If (Not imgSplash.Visible)
    VAOConfigError := False;
  Except
    On E:Exception Do
    Begin
      VAOConfigError := True;
    End; // On E:Exception
  End; // Try..Except

  // Branding --------------------------------------
  //Application.Icon := Branding.pbProductIcon;
  Application.Title := Branding.pbProductName;

  Self.Caption := Application.Title;

  If Branding.BrandingFileExists(ebfCore) Then
  Begin
    lblProdName.Caption := Branding.pbProductName;
    lblCopyright.Caption := Branding.pbCopyright;
  End; // If Branding.BrandingFileExists(ebfCore)

  If Branding.BrandingFileExists(ebfSplash) Then
  Begin
    With Branding.BrandingFile(ebfSplash) Do
    Begin
      If imgSplash.Visible Then
      Begin
        // Get appropriate bitmap from branding file
        ExtractImageCD (imgSplash, 'Splash');
      End; // If imgSplash.Visible
    End; // With Branding.BrandingFile(ebfSplash)
  End // If Branding.BrandingFileExists(ebfSplash)
  Else
  Begin
    lblDemoVer.Font.Color := clBlack;
    lblLicenceType.Font.Color := clBlack;
    lblLicencee.Font.Color := clBlack;
    lblCopyright.Font.Color := clBlack;
  End; // Else

  InPrint := False;

  //--------------------

  // HM 11/12/01: Modified to force usage of Multi-Company Manager, switch changed
  //              to '/NOMCM', '-NOMCM', '\NOMCM', '/NOMCM:', '-NOMCM:', '\NOMCM:'
  //              so that any pre-existing usages need to be setup again
  (*
  WantCompMan := FileExists (ExtractFilePath(Application.ExeName) + 'MCOMPMAN.SYS') And
                 (UpperCase(ParamStr(1)) <> '/NOMC');
  *)
  WantCompMan := (Not FindCmdLineSwitch ('NOMCM', ['/', '-', '\'], True)) And
                 (Not FindCmdLineSwitch ('NOMCM:', ['/', '-', '\'], True));

  // HM 11/12/01: Modified to create MCompMan.Sys if missing
  If (Not FileExists (ExtractFilePath(Application.ExeName) + 'MCOMPMAN.SYS')) Then
    With TStringList.Create Do
      Try
        Add ('Exchequer Multi-Company Manager');
        Add ('');
        Add (lblCopyright.Caption);
        //Add (Label2.Caption);

        SaveToFile (ExtractFilePath(Application.ExeName) + 'MCOMPMAN.SYS');
      Finally
        Free;
      End;

  //--------------------

  // HM 28/01/02: Modified to create MCompMan.Sys if missing
  If FileExists (ExtractFilePath(Application.ExeName) + EntLicFName) Then
    // Read Enterprise Licence
    If ReadEntLic (ExtractFilePath(Application.ExeName) + EntLicFName, LicRec) Then Begin
      // Demo System
      lblDemoVer.Visible := (LicRec.licLicType In [1, 2]);
      lblLicencee.Caption := Trim(LicRec.licCompany);
    End { If ReadEntLic (EntLicFName, LicRec) }
    Else
      // Unabled to read Licence
      lblLicenceType.Caption := '*** UNLICENCED ***'
  Else
    // Licence File not found
    lblLicenceType.Caption := '*** UNLICENCED ***';

  //--------------------

  If WantCompMan Then Begin
    WantCompMan := True;

    LibPath := ExtractFilePath(Application.ExeName) + 'EntComp.Dll';

    _InitCompMan := Nil;
    _ShowCompMan := Nil;
    _MyGSRHandle:=LoadLibrary(PCHAR(LibPath));

    Try
      If (_MyGSRHandle > HInstance_Error) Then Begin
        // Get handle for InitCompMan in DllComp.Pas in EntComp.Dll
        _InitCompMan := GetProcAddress(_MyGSRHandle, 'InitCompMan');

        If Assigned(_InitCompMan) Then Begin
          // Get handle for ShowCompMan in DllComp.Pas in EntComp.Dll
          _ShowCompMan := GetProcAddress(_MyGSRHandle, 'ShowCompMan');

          If (Not Assigned(_ShowCompMan)) Then Begin
            MessageDlg ('Windows returned an error ' + IntToStr(GetLastError) + ' attempting to get the address of ShowCompMan ' +
                        'in EntComp.Dll, Please contact your Technical Support Helpline for advice', mtError, [mbOk], 0);

            FreeLibrary(_MyGSRHandle);
            _MyGSRHandle:=0;
            _InitCompMan := Nil;

            PostMessage (Self.Handle, WM_CLOSE, 0, 0);
          End; { If (Not Assigned(_ShowCompMan)) }
        End { If Assigned(_InitCompMan) }
        Else Begin
          // Failed to get address of InitCompMan in EntComp.Dll
          MessageDlg ('Windows returned an error ' + IntToStr(GetLastError) + ' attempting to get the address of InitCompMan ' +
                      'in EntComp.Dll, Please contact your Technical Support Helpline for advice', mtError, [mbOk], 0);

          FreeLibrary(_MyGSRHandle);
          _MyGSRHandle:=0;

          PostMessage (Self.Handle, WM_CLOSE, 0, 0);
        End; { Else }
      End { If }
      Else Begin
        // Failed to load EntComp.Dll
        _MyGSRHandle:=0;

        MessageDlg ('Windows returned an error ' + IntToStr(GetLastError) + ' attempting to load EntComp.Dll, Please ' +
                    'contact your Technical Support Helpline for advice', mtError, [mbOk], 0);
        PostMessage (Self.Handle, WM_CLOSE, 0, 0);
      End; { Else }
    Except
      FreeLibrary(_MyGSRHandle);
      _MyGSRHandle:=0;

      _InitCompMan := Nil;
      _ShowCompMan := Nil;
    End; { Try }

    If Assigned (_InitCompMan) Then
      // Setup the shared Application instance
      _InitCompMan(Application);
  End { If }
  Else
    WantCompMan := False;
end;


procedure TEnterSplash.FormActivate(Sender: TObject);
Var
  DriveInfo        : DriveInfoType;
  ChkDir, LogPath  : ShortString;
  CanRun           : Boolean;

  { Check for /NOCHECK command line switch }
  Function WantChecks : Boolean;
  Var
    PStr : ShortString;
    I    : SmallInt;
  Begin
    Result := True;

    If (ParamCount > 0) Then
      For I := 1 To ParamCount Do Begin
        PStr := UpperCase(ParamStr(I));

        If Result And (Copy (PStr, 1, 8) = '/NOCHECK') Then
          Result := False;
      End; { For I }
  End;


  { Checks for the Local W/S configuration }
  Function CheckLocalWS : Boolean;
  Var
    IniF : TIniFile;
    I, J : SmallInt;
  Begin { CheckLocalWS }
    Result := False;

    { Check for /CMPDIR: parameter }
    If (ParamCount > 0) then Begin
      For I := 1 To ParamCount Do Begin
        { Check for Company Path }
        J := Pos ('/CMPDIR:', UpperCase(ParamStr(I)));
        If (J > 0) Then Begin
          { Extract path from command line }
          WSNetDir := Trim(Copy (ParamStr(I), J + 8, Length(ParamStr(I))));
          If (Length(WSNetDir) > 0) Then
            If (WSNetDir[Length(WSNetDir)] <> '\') Then
              WSNetDir := WSNetDir + '\';

          { Check the path is valid }
          Result := DirectoryExists (WSNetDir) And
                    FileExists (WSNetDir + 'COMPANY.DAT') And
                    FileExists (WSNetDir + Path1 + CustName) And
                    FileExists (WSNetDir + Path2 + DocName);

          If (Not Result) Then Begin
            MessageDlg ('Invalid Network Directory ''' + WSNetDir + '''.', mtError, [mbOk], 0);
          End { If }
          Else
            { Got Network Directory - exit loop now }
            Break;
        End; { If }
      End; { For }
    End; { If }

    If (Not Result) Then Begin
      { Check for ENTWREPL.INI configuration file }
      If FileExists (ExtractFilePath(Application.ExeName) + 'ENTWREPL.INI') Then Begin
        IniF := TIniFile.Create (ExtractFilePath (Application.ExeName) + 'ENTWREPL.INI');
        Try
          WSNetDir := IniF.ReadString ('UpdateEngine', 'NetworkDir', '');
          If (Length(WSNetDir) > 0) Then Begin
            If (WSNetDir[Length(WSNetDir)] <> '\') Then
              WSNetDir := WSNetDir + '\';

            { Check the path is valid }
            Result := DirectoryExists (WSNetDir) And
                      FileExists (WSNetDir + 'COMPANY.DAT') And
                      FileExists (WSNetDir + Path1 + CustName) And
                      FileExists (WSNetDir + Path2 + DocName);

            If (Not Result) Then
              MessageDlg ('Invalid Network Directory ''' + WSNetDir + '''.', mtError, [mbOk], 0);
          End; { If }
        Finally
          IniF.Destroy;
        End;
      End; { If }
    End; { If }

    If Result Then Begin
      { Convert to short date format }
      WSNetDir := PathToShort (WSNetDir);
    End; { If }
  End;  { CheckLocalWS }


  { Checks the specified Path for disk space, rights, etc depending on CheckMode }
  { CheckMode: 1 - Check Drive only, 2 - Check Drive and data subdirectories     }
  Function CheckPath (Const DirPath   : ShortString;
                      Const CheckMode : Byte) : Boolean;
  Begin { CheckPath }
    Result := False;

    { Get Drive information }
    DriveInfo.drDrive := Copy(ExtractFilePath(DirPath), 1, 1)[1];
    If GetDriveInfo (DriveInfo) Then Begin
      { Check they aren't running it from a CD-ROM }
      If (DriveInfo.drDriveType In [dtCDROM]) Then Begin
        Result := False;
        MessageDlg ('The system should not be run from a CD-ROM, this will cause problems.', mtWarning, [mbOk], 0);
      End { If }
      Else Begin
        { Check current directory }
        ChkDir := ExtractFilePath(DirPath);
        If Not (Copy(ChkDir, Length(ChkDir), 1)[1] = '\') Then
          ChkDir := ChkDir + '\';

        { Work out \Logs path }
        LogPath := ChkDir + 'LOGS\';
        If Not DirectoryExists(ChkDir + 'LOGS\') Then
          LogPath := '';

        { Check Disk Space > 1mb free }
        Result := CheckDiskSpace (ChkDir, LogPath);

        If Result Then Begin
          { Check Directory Rights }
          Result := CheckDirRights (ChkDir, LogPath, 1);

          { Check Subdirectories off Enterprise directory }
          If Result And DirectoryExists(ChkDir) And (CheckMode = 2) Then Begin
            { Check Directory Rights }
            If Result Then Result := CheckDirRights (ChkDir + 'CUST\', LogPath, 1);
            If Result Then Result := CheckDirRights (ChkDir + 'JOBS\', LogPath, 1);
            If Result Then Result := CheckDirRights (ChkDir + 'MISC\', LogPath, 1);
            If Result Then Result := CheckDirRights (ChkDir + 'REPORTS\', LogPath, 1);
            If Result Then Result := CheckDirRights (ChkDir + 'STOCK\', LogPath, 1);
            If Result Then Result := CheckDirRights (ChkDir + 'TRANS\', LogPath, 1);

            { Following directories can be missing - check if they are there }
            If Result And DirectoryExists (ChkDir + 'DOCS\') Then
              Result := CheckDirRights (ChkDir + 'DOCS\', LogPath, 2);

            If Result And DirectoryExists (ChkDir + 'FORMS\') Then
              Result := CheckDirRights (ChkDir + 'FORMS\', LogPath, 1);

            If Result And DirectoryExists (ChkDir + 'LOGS\') Then
              Result := CheckDirRights (ChkDir + 'LOGS\', LogPath, 2);

            If Result And DirectoryExists (ChkDir + 'SWAP\') Then
              Result := CheckDirRights (ChkDir + 'SWAP\', LogPath, 2);
          End; { If }
        End; { If }
      End; { Else }
    End; { If }
  End;  { CheckPath }

  { Returns True if machine is running Windows NT }
  Function IS_WinNT  :  Boolean;
  Var
    OSVerIRec : TOSVersionInfo;
  Begin
    Result:=False;

    FillChar(OSVerIRec,Sizeof(OSVerIRec),0);

    OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);

    If (GetVersionEx(OSVerIRec)) then
      Result:=(OSVerIRec.dwPlatformId=VER_PLATFORM_WIN32_NT);
  end;

  { Checks Workstation Configuration and offers to fix }
  Function WStationChecks : Boolean;
  Var
    WSCheckInfo : WSCheckRecType;
  Begin { WStationChecks }
    { Check for invalid configuration }
    Result := WSChecks(WSCheckInfo, Isworkgroup);

    If (Not Result) Then Begin
      { Display a dialog to allow user to fix automatically }
      Result := DisplayWSSetup (WSCheckInfo);
    End; { If (Not Result) }
  End; { WStationChecks }

  { Runs EntWRepl.Exe }
  Procedure RunUpdEngine;
  Var
    Cmd : PChar;
  Begin { RunUpdEngine }
    Cmd := StrAlloc (255);

    StrPCopy (Cmd, ExtractFilePath(Application.ExeName) + 'ENTWREPL.EXE /AUTO');

    If (WinExec  (Cmd, SW_SHOW) <= 31) Then
      MessageDlg ('An error occured running the Exchequer Update Engine', mtError, [mbOk], 0);

    StrDispose (Cmd);
  End; { RunUpdEngine }

  Procedure RunEntReg;
  Var
    Cmd : PChar;
  Begin { RunEntReg }
    Cmd := StrAlloc (255);
    Try
      StrPCopy (Cmd, ExtractFilePath(Application.ExeName) + 'ENTREG.EXE /AUTO');
      If (WinExec  (Cmd, SW_SHOW) <= 31) Then
        MessageDlg ('An error occured running the Exchequer Component Setup Utility', mtError, [mbOk], 0);
    Finally
      StrDispose (Cmd);
    End; // Try..Finally
  End; { RunEntReg }

begin
  Refresh;

  // HM 22/11/04: Added error checking with auto-fixing for VAO system dir
  If (Not VAOConfigError) Then
  Begin
    CanRun := True;

    // HM 18/08/04: Added warning at start if user is
    If (Not VAOInfo.IsCorrectDir) Then
    Begin
      MessageDlg ('This workstation is setup to be running Exchequer from a different directory, please contact your Technical Support',
                  mtError, [mbOk], 0);
    End; // If (Not VAOInfo.IsCorrectDir)

    IsWSLocal := CheckLocalWS;

    If WantChecks Then Begin
      CanRun := CheckForUNCPathMsg('Exchequer', 'Exchequer Workstation Configuration');

      If CanRun Then
        { Check to see if workstation has been setup correctly }
        CanRun := WStationChecks;

      If CanRun Then Begin
        If IsWSLocal Then Begin
          { Local Program Files - Check ExeName Directory }
          CanRun := CheckPath (ExtractFilePath(Application.ExeName), 1);

          { Check WSNetDir dir and data dirs off WSNetDir }
          If CanRun Then CanRun := CheckPath (WSNetDir, 2);
        End { If }
        Else Begin
          { Conventional Setup - Check ExeName Directory }
          CanRun := CheckPath (ExtractFilePath(Application.ExeName), 2);
        End; { Else }
      End; { If CanRun }
    End; { If }

    If CanRun And IsWSLocal Then Begin
      { Check to see if ENTER1.EXE and SBSFORM.DLL are the dogs wotsits }
      If (FileAge(ExtractFilePath(Application.ExeName) + 'ENTER1.EXE') <> FileAge(WSNetDir + 'ENTER1.EXE')) Or
         (FileAge(ExtractFilePath(Application.ExeName) + 'SBSFORM.DLL') <> FileAge(WSNetDir + 'SBSFORM.DLL')) Then Begin
        { One of the files is out of date }

        { HM 29/04/99: Modified to make system more secure }
        {CanRun := (MessageDlg ('Your Exchequer system is out of date, please ' +
                               'use the Exchequer Update Engine to correct this.' +
                               #13#13 + 'Do you want to run Exchequer Anyway?', mtWarning, [mbYes, mbNo], 0) = mrYes);}

        CanRun := False;

        If (MessageDlg ('Your accounts system is out of date and connot be ' +
                        'used. Do you want to run the Update Engine ' +
                        'now to correct this.', mtWarning, [mbYes, mbNo], 0) = mrYes) Then Begin
          RunUpdEngine;
        End; { If }
      End; { If }
    End; { If }

    // MH 19/07/06: Added OS and Terminal Services checks
    If CanRun Then
    Begin
      With TOSChecks.Create Do
      Begin
        Try
          If (Not ocSupportedOS) Then
          Begin
            CanRun := False;

            If ocTSSession Then
              MessageDlg (Branding.pbProductName + ' does not support Terminal Services',
                          mtError, [mbOk], 0)
            Else
            Begin
              If ocNeedsServicePack Then
                MessageDlg ('This machine is running an unsupported Service Pack level, ' +
                            'Please check the Technical Documentation for more details',
                            mtError, [mbOk], 0)
              Else
                MessageDlg ('This machine is running an unsupported Operating System, ' +
                            'Please check the Technical Documentation for more details',
                            mtError, [mbOk], 0);
            End; // Else
          End; // If (Not ocSupportedOS)
        Finally
          Free;
        End; // Try..Finally
      End; // With TOSChecks.Create
    End; // If CanRun

    If CanRun Then Begin
      // Check that the default printer is valid
      If CheckPrintersOK Then
        { OK - Run Enterprise/MCM }
        Timer1.Enabled := True
      Else
        { Close System }
        Close;
    End { If CanRun }
    Else
      { Close System }
      Close;
  End // If (Not VAOConfigError)
  Else
  Begin
    MessageDlg('This Installation or User is not correctly configured for the IAOO system, please contact ' +
               'your Technical Support and then use the Exchequer Component Setup Utility to ' +
               'correctly configure the system.', mtWarning, [mbOK], 0);
    RunEntReg;
    Close;
  End; // Else
End;

procedure TEnterSplash.Timer1Timer(Sender: TObject);
Var
  Cmd            : Array [0..255] Of Char;
  Tmp, TmpPath   : String[255];
  n              : Integer;
  WantParm       : Boolean;
  GotCoDir,
  GotDir, IgPath : Boolean;

  Function GotSysFiles : Boolean;
  Var
    A, B, C, D, E : Boolean;
    MissComp   : String;
  Begin { GotSysFiles }
    A := FileExists (ExtractFilePath(Application.ExeName) + 'ENTCOMP.DLL');
    B := FileExists (ExtractFilePath(Application.ExeName) + 'SBSFORM.DLL');
    C := FileExists (ExtractFilePath(Application.ExeName) + 'ENTER1.EXE');
    D := FileExists (ExtractFilePath(Application.ExeName) + 'FORMDES.EXE');
    E := FileExists (ExtractFilePath(Application.ExeName) + 'ENTCUSTM.DLL');

    Result := A And B And C And D;

    If (Not Result) Then Begin
      MissComp := '';

      If (Not A) Then MissComp := MissComp + 'EntComp.Dll, ';
      If (Not E) Then MissComp := MissComp + 'EntCustm.Dll, ';
      If (Not C) Then MissComp := MissComp + 'Enter1.Exe, ';
      If (Not D) Then MissComp := MissComp + 'FormDes.Exe, ';
      If (Not B) Then MissComp := MissComp + 'SbsForm.Dll, ';

      MissComp := Trim(MissComp);
      If (MissComp[Length(MissComp)] = ',') Then
        Delete (MissComp, Length(MissComp), 1);

      MessageDlg ('The following components are missing: ' + #13#13 +
                   MissComp + #13#13 + 'Contact Technical Support', mtError, [mbOk], 0);

      PostMessage (Self.Handle, WM_CLOSE, 0, 0);
    End; { If }
  End; { GotSysFiles }

begin
  Timer1.Enabled := False;

  IgPath := False;

  If GotSysFiles Then Begin
    If WantCompMan Then Begin
      If Assigned (_ShowCompMan) Then Begin
        { Build command-line parameter string for multi-company manager }
        Tmp := '';
        If (ParamCount>0) then Begin
          n := 1;
          While (n <= ParamCount) Do Begin
            If (UpperCase(ParamStr(n)) <> '/DIR:') And
               (UpperCase(ParamStr(n)) <> '/NOPATH') And
               (Pos ('/CMPDIR:', UpperCase(ParamStr(n))) = 0) Then
              Tmp := Tmp + ParamStr(n) + ' ';

            If (UpperCase(ParamStr(n)) = '/NOPATH') Then
              IgPath := True;

            Inc (n);
          End; { While }
        End; { If }

        If IsWSLocal And (Not IgPath) Then
          Tmp := Tmp + ' /CMPDIR:' + WSNetDir;

        { Display Multi-Company Manager }
        _ShowCompMan (Self.Handle, Tmp);
//Application.MessageBox ('Returned From MCM', 'Splash', 0);

        { Get status }

      End; { If }
    End { If }
    Else Begin
      Tmp := RunNonMCM;

      { run enterprise }
      FillChar (Cmd, SizeOf (Cmd), #0);
      StrPCopy (Cmd, Tmp);
      WinExec  (Cmd, SW_SHOWNORMAL);
    End; { Else }
  End; { If }
End;

Function TEnterSplash.RunNonMCM : ShortString;
Var
  TmpPath, ThisParm, EntDataDir, EntCoDir   : String;
  GotCoDir, GotDir                          : Boolean;
  I, J                                      : Integer;

  Function ValidDataDir (Const DataDirPath : String) : Boolean;
  Begin { ValidDataDir }
    Result :=  DirectoryExists(DataDirPath) And
               FileExists (DataDirPath + Path1 + CustName) And        { Cust\CustSupp.Dat }
               FileExists (DataDirPath + Path2 + DocName) And         { Trans\Document.Dat }
               FileExists (DataDirPath + Path3 + MiscNam) And         { Misc\ExStkChk.Dat }
               FileExists (DataDirPath + Path4 + MLocName);           { Stock\MLocStk.Dat }
  End; { ValidDataDir }

  Function ValidCoDir (Const CoDirPath : String) : Boolean;
  Begin { ValidCoDir }
    Result :=  ValidDataDir(CoDirPath) And FileExists (TmpPath + MultCompNam);
  End; { ValidCoDir }

Begin { RunNonMCM }
  Result := 'ENTER1.EXE ';

  GotDir     := False;
  EntDataDir := '';

  GotCoDir := False;
  EntCoDir := '';

  If (ParamCount > 0) Then Begin
    { Run through parameters and check for /DIR: or /CODIR: }
    I := 1;
    While (I <= ParamCount) Do Begin
      ThisParm := UpperCase(ParamStr(I));

      If (ThisParm = '/DIR:') Then Begin
        { /DIR: - data directory switch }
        Inc (I);  { Move to path }

        If (Not GotDir) And (I <= ParamCount) Then Begin
          { Get path, convert to MS-DOS 8.3 format, etc... }
          TmpPath := UpperCase(ParamStr(I));
          FixPath(TmpPath);

          { Check its a valid data directory }
          If ValidDataDir(TmpPath) Then Begin
            EntDataDir := TmpPath;
            GotDir := True;
          End; { If }
        End; { If }
      End { If }
      Else Begin
        If (ThisParm = '/CODIR:') Then Begin
          { /CODIR: - Company directory switch }
          Inc (I);  { Move to path }

          If (Not GotCoDir) And (I <= ParamCount) Then Begin
            { Get path, convert to MS-DOS 8.3 format, etc... }
            TmpPath := UpperCase(ParamStr(I));
            FixPath(TmpPath);

            { Check its a valid Company directory }
            If ValidCoDir(TmpPath) Then Begin
              EntCoDir := TmpPath;
              GotCoDir := True;
            End; { If }
          End; { If }
        End { If }
        Else Begin
          If (Copy (ThisParm, 1, 8) = '/CMPDIR:') Then Begin
            { /CMPDIR: - Old Company directory switch }
            If (Not GotCoDir) And (I < ParamCount) Then Begin
              { Get path, convert to MS-DOS 8.3 format, etc... }
              TmpPath := UpperCase(Trim(Copy (ParamStr(I), J + 8, Length(ParamStr(I)))));
              FixPath(TmpPath);

              { Check its a valid Company directory }
              If ValidCoDir(TmpPath) Then Begin
                EntCoDir := TmpPath;
                GotCoDir := True;
              End; { If }
            End; { If }
          End { If }
          Else Begin
            Result := Result + ParamStr(I) + ' ';
          End; { Else }
        End; { Else }
      End; { Else }

      Inc (I);
    End; { For I }
  End; { If (ParamCount > 0) }

  If (Not GotCoDir) Then Begin
    { Company directory invalid }
    If IsWSLocal Then Begin
      { Local Program files }
      EntCoDir := WSNetDir;
      GotCoDir := True;
    End { If }
    Else Begin
      If GotDir Then Begin
        { Check Data Dir }
        If ValidCoDir(EntDataDir) Then Begin
          EntCoDir := EntDataDir;
          GotCoDir := True;
        End; { If }
      End; { If }
    End; { If }

    If (Not GotCoDir) Then Begin
      { Use .Exe Dir }
      EntCoDir := ExtractFilePath(Application.ExeName);
      GotCoDir := True;
    End; { If }
  End; { If }

  If (Not GotDir) Then Begin
    { Data Directory is invalid }
    EntDataDir := EntCoDir;
    GotDir := True;
  End; { If }

  Result := Result + '/DIR: ' + EntDataDir + ' /CODIR: ' + EntCoDir;
End; { RunNonMCM }

Procedure TEnterSplash.WMSBSFDMsg(Var Message  :  TMessage);
Begin
  With Message do Begin
    Case WParam of
      0  :  Close;
//      0  : Timer2.Enabled := True;

      1  :  Hide;

      2  :  Begin
              Show;
              Refresh;
            End;
    End; { Case }
  End; { With }

  Inherited;
End;

procedure TEnterSplash.FormDestroy(Sender: TObject);
begin
//Application.MessageBox ('Unloading EntComp.Dll', 'Splash.FormDestroy', 0);
  If (_MyGSRHandle <> 0) Then Begin
    FreeLibrary(_MyGSRHandle);
    _MyGSRHandle:=0;
  End; { If }
//Application.MessageBox ('EntComp.Dll Unloaded Successfully', 'Splash.FormDestroy', 0);
End;

procedure TEnterSplash.PrintProgress(var Msg: TMessage);
begin
  With Msg Do Begin
    { Mode passes in WParam }
    Case WParam Of
      { Set HWnd }
      {2 : PrintHwnd := LParam;}

      { Set InPrint Flag }
      3 : InPrint := (LParam = 1);

      { Check InPrint Flag }
      4 : SendMessage(LParam,WM_InPrint,Ord(InPrint),0);
    End; { Case }
  End; { With }
end;


end.
