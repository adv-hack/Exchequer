unit CommonMCM;

// Common functionality called by the Standard and Bureau MCM windows

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

Uses Controls, Dialogs, FileCtrl, Forms, Messages, SysUtils, Windows, ShellAPI, GlobVar, VarConst;

Type
  TBackupOrRestoreType = (brBackup, brRestore);


// Determines whether the Scroll Bar widths should be reset
Procedure CheckforXPScrollParams (Var SetXPScrollSize : Boolean);

// Changes various Windows settings to get around historicaal problems we have experienced
Procedure ChangeWindowsSettings (Const ChangeScrollSize       : Boolean;
                                 Var   ONCMetrics, NCMetrics  : PNonClientMetrics;
                                 Var   KeybDelay              : SmallInt;
                                 Var   KeybSpeed              : DWord;
                                 Var   ScrSaveActive          : Boolean);

// Restores the various Windows settings changed by an earlier call to ChangeWindowsSettings
Procedure RestoreWindowsSettings (Const ChangeScrollSize       : Boolean;
                                  Var   ONCMetrics, NCMetrics  : PNonClientMetrics;
                                  Var   KeybDelay              : SmallInt;
                                  Var   KeybSpeed              : DWord;
                                  Var   ScrSaveActive          : Boolean);

// Checks out the specified dataset and returns TRUE if OK to use it
Function CheckCompany (Var CompDets : CompanyDetRec; Const CompCode : ShortString; Const WantChecks : Boolean) : Boolean;

// Executes Enterprise for the specified company dataset, returns TRUE if successful
Function RunEnterprise (Var   CompDets     : CompanyDetRec;
                        Const CmdParam     : ShortString;
                        Const SplashHandle : hWnd;
                        Const WantChecks   : Boolean;
                        Const BureauUserId : ShortString = '') : Boolean;

// Executes Exchequer for the specified company dataset, returns TRUE if successful
Function RunExchequer (Var   CompDets     : CompanyDetRec;
                       Const CmdParam     : ShortString;
                       Const SplashHandle : hWnd;
                       Const WantChecks   : Boolean) : Boolean;

// Executes the E-Business Module, returns TRUE if successful
Function RunEBus (Var CompDets : CompanyDetRec) : Boolean;

// Executes the Scheduler Admin Module, returns TRUE if successful
Function RunScheduler (Var CompDets : CompanyDetRec) : Boolean;

// Executes the Sentimail Module, returns TRUE if successful
Function RunSentimail (Var CompDets : CompanyDetRec) : Boolean;

// Replicates the security settings around all the companies
Procedure ReplicateSecurity;

// Controls the entry of the Enterprise main Release Code
Procedure EntReleaseCode;

// Displays the Module Release Code dialog, returns TRUE if updated
Function ModuleReleaseCodeDialog (Const ParentForm : TForm; Const IsPlugInPW : Boolean) : Boolean;

// Displays the Enterprise User Count dialog
procedure EnterpriseUserCountDialog (Const ParentForm : TForm);

// Challenge for the Resynch Companies password and run the utility if provided
Procedure ResynchCompanies;

// MH 25/02/2013 v7.0.2 ABSEXCH-13994: Allows users to clear down individual user counts
Procedure ResetIndividualEntUserCounts (Const ParentForm : TForm);

// Resets the Enterprise User counts
Procedure ResetEntUserCounts (Const ParentForm : TForm);

// Reset Plug-In User Counts
procedure ResetPlugInUserCounts;

// Print the Logged In Users Report to Preview
Procedure RunLoggedInUsersReport (Const ParentForm : TForm);

// Runs the rebuild module for the selected company
Procedure RunRebuild (Const ParentForm : TForm; Const CompCode : ShortString; const SysLoggedIn : Boolean);

// Runs the defined Backup or Restore command
Procedure RunBackupOrRestore (Const ParentForm : TForm; Const CompCode : ShortString; Const OpType : TBackupOrRestoreType);

// Displays the Multi-Company Manager Options dialog
procedure DisplayMCMOptions(Const ParentForm : TForm; Var LoggedPass : ShortString; Const IsSystemUser : Boolean);

// Displays the Session Info dialog
Procedure DisplaySessionInfo (Const ParentForm : TForm);

// Displays the MCM Help-About dialog
procedure DisplayHelpAbout (Const ParentForm : TForm; Const ShowExePath : Boolean);


implementation

Uses VarFPosU, BtrvU2, BTKeys1U, BTSupU1,
     AboutU,          // Enterprise Help-About dialog
     BureauSecurity,  // SecurityManager Object
     Chk4User,        // Logged In Users report
     ChkComp,         // Routines for checking the validity of a company dataset
     ChkSizeF,        // Data File size checking routines
     CompOpt,         // MCM Options dialog
     CompSec,         // Company Count Security
     CompUtil,        // PathToShort
     DiskUtil,        // Misc disk routines
     EntLicence,      // EnterpriseLicence Object for accessing the Enterprise Licence details
     ESNPWF,          // ESN based Password Entry dialog for security utilities
     MURel2,          // Enterprise User Count Release Code window
     RebuildF,        // confirm Rebuild dialog
     ReplSysF,        // Licencing replication functions
     RunDlg,          // Command line window for Backup/Restore options
     SavePos,         // Object encapsulating the btrieve saveposition/restoreposition functions
     SecWarn2,        // Enterprise Release Code wizard
     SetModU,         // Module Release Codes dialog
     UserSec,         // User Count Security routines
     uSettings,       // Colour/Position editing and saving routines
     // MH 25/02/2013 v7.0.2 ABSEXCH-13994: Allows users to clear down individual user counts
     ResetUserCountsF, // Reset Individual User Counts form
     StrUtils,
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     APIUtil;

//-------------------------------------------------------------------------

// Determines whether the Scroll Bar widths should be reset
Procedure CheckforXPScrollParams (Var SetXPScrollSize : Boolean);
Begin // CheckforXPScrollParams
  // HM 11/08/03: Added flag to control whether the scrollbar size gets reset - causes
  //              tray icon corruption under Windows XP - AOK on all other OS's
  If (GetWindowsVersion In wvXPStyle) Then
    SetXPScrollSize := FindCmdLineSwitch('XPSCROLL', ['-', '/', '\'], True) Or
                       FindCmdLineSwitch('XPSCROLL:', ['-', '/', '\'], True)
  Else
    SetXPScrollSize := True;
End; // CheckforXPScrollParams

//-------------------------------------------------------------------------

// Changes various Windows settings to get around historicaal problems we have experienced
Procedure ChangeWindowsSettings (Const ChangeScrollSize       : Boolean;
                                 Var   ONCMetrics, NCMetrics  : PNonClientMetrics;
                                 Var   KeybDelay              : SmallInt;
                                 Var   KeybSpeed              : DWord;
                                 Var   ScrSaveActive          : Boolean);
Var
  MCCancel   :  Boolean;
  SBW,SBH    :  Integer;
Begin // ChangeWindowsSettings
  // MH 13/09/06: Under Vista don't do the following code as it break the window borders
  // and is borderline malware according to Microsoft standards (which is bad)
  // MH 08/05/2013 v7.0.4 ABSEXCH-12022: Added support for Windows 7, Windows 8 and Windows Server 2012
  If (GetWindowsVersion < wvVista) Then
  Begin
    // ---------------- Change the Scroll Bar Width  -----------------
    If ChangeScrollSize Then
    Begin
      MCCancel := False;

      New(NCMetrics);

      New(ONCMetrics);
      FillChar(ONCMetrics^,Sizeof(ONCMetrics^),0);
      ONCMetrics^.cbSize:=Sizeof(ONCMetrics^);

      If SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, ONCMETRICS, 0) Then
      Begin
        With ONCMetrics^ Do
        Begin
          Move(iScrollWidth,SBW,Sizeof(SBW));
          Move(iScrollHeight,SBH,Sizeof(SBH));
        End; // With ONCMetrics^

        If (SBW <> 16) Or (SBH <> 16) Then
        Begin
          With NCMetrics^ do Begin
            NCMetrics^:=ONCMetrics^;

            SBW:=16;
            SBH:=16;

            Move(SBW,iScrollWidth,Sizeof(SBW));
            Move(SBH,iScrollHeight,Sizeof(SBH));

            MCCancel:=Not SystemParametersInfo(SPI_SETNONCLIENTMETRICS,0,NCMETRICS,{SPIF_SENDWININICHANGE}0);
          End; { With }
        End // If (SBW <> 16) Or (SBH <> 16)
        Else
          MCCancel:=True;
      End { If }
      Else
        MCCancel:=True;

      If MCCancel Then
      Begin
        Dispose(ONCMetrics);
        ONCMetrics:=nil;

        Dispose(NCMetrics);
        NCMetrics:=nil;
      End; // If MCCancel
    End; // If ChangeScrollSize
  End // If (GetWindowsVersion < wvVista)
  Else
  Begin
    ONCMetrics:=nil;
  End; // Else

  // ----------- Change the Keyboard Delay and Repeat Rate ----------

  KeybDelay:=-1;
  If (GetWindowsVersion < wvVista) Or (FindCmdLineSwitch('DoKBDelay', ['/', '-'], True)) Then
  Begin
    If SystemParametersInfo(SPI_GETKEYBOARDDELAY,0,@KeybDelay,0) Then
    Begin
      SystemParametersInfo(SPI_SETKEYBOARDDELAY, 2, NIL, 0);
    End; // If SystemParametersInfo(SPI_GETKEYBOARDDELAY, ...
  End; // If (GetWindowsVersion < wvVista) Or (FindCmdLineSwitch('DoKBDelay', ['/', '-'], True))

  KeybSpeed:=65535;
  If (GetWindowsVersion < wvVista) Or (FindCmdLineSwitch('DoKBSpeed', ['/', '-'], True)) Then
  Begin
    If SystemParametersInfo(SPI_GETKEYBOARDSPEED, 0, @KeybSpeed, 0) Then
    Begin
      SystemParametersInfo(SPI_SETKEYBOARDSPEED,15,nil,0);
    End; // If SystemParametersInfo(SPI_GETKEYBOARDSPEED,
  End; // If (GetWindowsVersion < wvVista) Or (FindCmdLineSwitch('DoKBSpeed', ['/', '-'], True))

  // --------------------- Disable Screen Savers --------------------

  ScrSaveActive := False;
  If (GetWindowsVersion < wvVista) Or (FindCmdLineSwitch('DoScrSave', ['/', '-'], True)) Then
  Begin
    If SystemParametersInfo(SPI_GETSCREENSAVEACTIVE,0,@ScrSaveActive,0) Then
    Begin
      If ScrSaveActive Then
      Begin
        SystemParametersInfo(SPI_SETSCREENSAVEACTIVE,0,Nil,0);
      End; // If ScrSaveActive
    End; { If }
  End; // If (GetWindowsVersion < wvVista) Or (FindCmdLineSwitch('DoScrSave', ['/', '-'], True))
End; // ChangeWindowsSettings

//-------------------------------------------------------------------------

// Restores the various Windows settings changed by an earlier call to ChangeWindowsSettings
Procedure RestoreWindowsSettings (Const ChangeScrollSize       : Boolean;
                                  Var   ONCMetrics, NCMetrics  : PNonClientMetrics;
                                  Var   KeybDelay              : SmallInt;
                                  Var   KeybSpeed              : DWord;
                                  Var   ScrSaveActive          : Boolean);
Begin // RestoreWindowsSettings
  // HM 11/08/03: Added flag to control whether the scrollbar size gets reset - causes
  //              tray icon corruption under Windows XP - AOK on all other OS's
  If Assigned(ONCMetrics) And ChangeScrollSize Then
  Begin
    SystemParametersInfo(SPI_SETNONCLIENTMETRICS, 0, ONCMETRICS, 0);

    Dispose(ONCMetrics);
    ONCMetrics:=nil;

    Dispose(NCMetrics);
    NCMetrics:=nil;
  End; // If Assigned(ONCMetrics) And ChangeScrollSize

  If (KeybDelay <> -1) Then
  Begin
    SystemParametersInfo(SPI_SETKEYBOARDDELAY,KeybDelay,nil,0);
  End; // If (KeybDelay <> -1)

  If (KeybSpeed <> 65535) Then
  Begin
    SystemParametersInfo(SPI_SETKEYBOARDSPEED,KeybSpeed,nil,0);
  End; // If (KeybSpeed <> 65535)

  If ScrSaveActive Then
  Begin
    SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 1, Nil, 0);
  End; // If ScrSaveActive
End; // RestoreWindowsSettings

//-------------------------------------------------------------------------

// Checks out the specified dataset and returns TRUE if OK to use it
Function CheckCompany (Var CompDets : CompanyDetRec; Const CompCode : ShortString; Const WantChecks : Boolean) : Boolean;
Var
  DriveInfo          : DriveInfoType;
  sChkDir, sLogPath  : ShortString;
  sKey               : Str255;
  iStatus            : SmallInt;
Begin // CheckCompany
  Result := False;

  // Load the Company Record
  sKey := FullCompCodeKey(cmCompDet, CompCode);
  iStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sKey);
  If (iStatus = 0) Then
  Begin
    // Checkout the Company Directory and security
    CompDets := Company^.CompDet;
    CheckCompanyDir (CompDets);

    // Only allow the dataset to be opened if its OK, unless its a reseller system
    If (CompDets.CompAnal = 1) Or CompDets.CompDemoSys Then
    Begin
      // Check data exists in that directory
{$IFDEF EXSQL}
      if SQLUtils.ValidCompany(CompDets.CompPath) then
{$ELSE}
      If FileExists(Trim(CompDets.CompPath) + PathSys) Then
{$ENDIF}
      Begin
        If WantChecks Then
        Begin
          { Check Drive Rights in data directory }
          DriveInfo.drDrive := Copy(ExtractFilePath(CompDets.CompPath), 1, 1)[1];
          If GetDriveInfo (DriveInfo) Then
          Begin
            { Check they aren't running it from a CD-ROM }
            If (DriveInfo.drDriveType In [dtCDROM]) Then
            Begin
              Result := False;
              MessageDlg ('The system should not be run from a CD-ROM, this will cause problems.', mtWarning, [mbOk], 0);
            End // If (DriveInfo.drDriveType In [dtCDROM])
            Else
            Begin
              // Check the company dataset directory and sub-directories
              sChkDir := IncludeTrailingPathDelimiter(ExtractFilePath(CompDets.CompPath));

              // Work out \Logs path
              sLogPath := sChkDir + 'LOGS\';
              If (Not DirectoryExists(sChkDir + 'LOGS\')) Then
              Begin
                sLogPath := '';
              End; // If (Not DirectoryExists(sChkDir + 'LOGS\'))

              // Check Disk Space > 1mb free
              Result := CheckDiskSpace (sChkDir, sLogPath);

              If Result Then
              Begin
                { Check Directory Rights }
                Result := CheckDirRights (sChkDir, sLogPath, 1);

                { Check Subdirectories off Enterprise directory }
                If Result And DirectoryExists(sChkDir) Then
                Begin
                  { Check Directory Rights }
                  {$IFDEF EXSQL}
                  if Result and DirectoryExists(sChkDir + 'CUST\') then
                    Result := CheckDirRights (sChkDir + 'CUST\', sLogPath, 1);
                  if Result and DirectoryExists(sChkDir + 'JOBS\') then
                    Result := CheckDirRights (sChkDir + 'JOBS\', sLogPath, 1);
                  if Result and DirectoryExists(sChkDir + 'MISC\') then
                    Result := CheckDirRights (sChkDir + 'MISC\', sLogPath, 1);
                  if Result and DirectoryExists(sChkDir + 'REPORTS\') then
                    Result := CheckDirRights (sChkDir + 'REPORTS\', sLogPath, 1);
                  if Result and DirectoryExists(sChkDir + 'STOCK\') then
                    Result := CheckDirRights (sChkDir + 'STOCK\', sLogPath, 1);
                  if Result and DirectoryExists(sChkDir + 'TRANS\') then
                    Result := CheckDirRights (sChkDir + 'TRANS\', sLogPath, 1);
                  {$ELSE}
                  If Result Then Result := CheckDirRights (sChkDir + 'CUST\', sLogPath, 1);
                  If Result Then Result := CheckDirRights (sChkDir + 'JOBS\', sLogPath, 1);
                  If Result Then Result := CheckDirRights (sChkDir + 'MISC\', sLogPath, 1);
                  If Result Then Result := CheckDirRights (sChkDir + 'REPORTS\', sLogPath, 1);
                  If Result Then Result := CheckDirRights (sChkDir + 'STOCK\', sLogPath, 1);
                  If Result Then Result := CheckDirRights (sChkDir + 'TRANS\', sLogPath, 1);
                  {$ENDIF}

                  If Result And DirectoryExists(sChkDir + 'DOCS\') Then
                    Result := CheckDirRights (sChkDir + 'DOCS\', sLogPath, 2);

                  If Result And DirectoryExists(sChkDir + 'FORMS\') Then
                    Result := CheckDirRights (sChkDir + 'FORMS\', sLogPath,1 );

                  If Result And DirectoryExists(sChkDir + 'LOGS\') Then
                    Result := CheckDirRights (sChkDir + 'LOGS\', sLogPath, 2);

                  If Result And DirectoryExists(sChkDir + 'SWAP\') Then
                    Result := CheckDirRights (sChkDir + 'SWAP\', sLogPath, 2);
                End; // If Result And DirectoryExists(sChkDir)
              End; // If Result

              // HM 05/02/03: Added checks on data file size
              // HM and VM 12/04/2007 removed checkfiles section for v6.00 and SQL
//              With CompDets Do
//              Begin
//                ChkFileSizes (Trim(CompCode),
//                              Trim(CompName),
//                              IncludeTrailingPathDelimiter(Trim(CompPath)),
//                              True,    // Check Daily record
//                              False);
//              End; // With CompDets
            End; { Else }
          End { If }
          Else Begin
            Result := False;
            MessageDlg ('The Company resides in an Invalid Drive', mtError, [mbOk], 0);
          End; { Else }
        End { If }
        Else
          Result := True;
      End // If FileExists(Trim(CompDets.CompPath) + PathSys)
      Else
      Begin
        MessageDlg ('No Company data was found in ''' + Trim(CompDets.CompPath) + '''', mtWarning, [mbOk], 0);
      End; // Else
    End; // If (CompDets.CompAnal = 1) Or CompDets.CompDemoSys
  End; // If (iStatus = 0)
End; // CheckCompany

//------------------------------

// Executes Enterprise for the specified company dataset, returns TRUE if successful
Function RunEnterprise (Var   CompDets     : CompanyDetRec;
                        Const CmdParam     : ShortString;
                        Const SplashHandle : hWnd;
                        Const WantChecks   : Boolean;
                        Const BureauUserId : ShortString = '') : Boolean;
Var
  ExecPath : ANSIString;
Begin // RunEnterprise
  // Checks out the specified dataset and returns TRUE if OK to use it
  Result := CheckCompany (CompDets, CompDets.CompCode, WantChecks);
  If Result Then
  Begin
    // Redisplay the splash screen whilst Enterprise loads
    If (SplashHandle <> 0) Then
    Begin
      SendMessage (SplashHandle, WM_SBSFDMsg, 2, 2);
    End; // If (SplashHandle <> 0)

    ExecPath := ExtractFilePath(Application.EXEName) + 'ENTER1.EXE ' + CmdParam + ' ' +
                RemDirSwitch +' ' + Trim(CompDets.CompPath) + ' /CODIR: ' + SetDrive;

    If (Trim(BureauUserId) <> '') Then
    Begin
      ExecPath := ExecPath + ' /BUSR:'+Trim(BureauUserId)
    End; // If (Trim(BureauUserId) <> '')

    Close_File (F[MiscF]);
    Close_File (F[CompF]);
{ TODO : What about GroupF/GroupCompXrefF }

    // Close the user settings file/object and re-open it after the btrieve reset
    oSettings.Free;
    Try
      Reset_B;
    Finally
      If SyssCompany^.CompOpt.OptBureauModule Then
      Begin
        // Setup the Bureau Module with per-user settings
        oSettings.UserName := SecurityManager.smUserCode;
      End; // If SyssCompany^.CompOpt.OptBureauModule
    End; // Try..finally

    Open_System(CompF, CompF);

    Result := (WinExec(PCHAR(ExecPath), SW_SHOW) > 31);
    If (Not Result) Then
    Begin
      // Error - redisplay the splash
      If (SplashHandle <> 0) Then
      Begin
        PostMessage (SplashHandle, WM_SBSFDMsg, 1, 1);
      End; // If (SplashHandle <> 0)
    End; // If (Not Result)
  End; // If Result
End; // RunEnterprise

//------------------------------

// Executes Exchequer for the specified company dataset, returns TRUE if successful
Function RunExchequer (Var   CompDets     : CompanyDetRec;
                       Const CmdParam     : ShortString;
                       Const SplashHandle : hWnd;
                       Const WantChecks   : Boolean) : Boolean;
Var
  ExecPath : ANSIString;
  CurrDir  : ShortString;
Begin // RunExchequer
  // Checks out the specified dataset and returns TRUE if OK to use it
  Result := CheckCompany (CompDets, CompDets.CompCode, WantChecks);
  If Result Then
  Begin
    // Select the correct batch file to run for Exchequer for DOS
    If (GetWindowsVersion In wvNTVersions) Then
    Begin
      // Windows NT/2000/XP
      ExecPath := ExtractFilePath(PathToShort(Application.EXEName)) + SyssCompany.CompOpt.OptWinNTCmd + '.BAT';
    End // If (GetWindowsVersion In wvNTVersions)
    Else
    Begin
      // Windows 95 or 98
      ExecPath := ExtractFilePath(PathToShort(Application.EXEName)) + SyssCompany.CompOpt.OptWin9xCmd + '.BAT';
    End; // Else

    // Check the batch file exists
    If (Not FileExists (ExecPath)) Then
    Begin
      // No - default to REX.BAT
      ExecPath := ExtractFilePath(PathToShort(Application.EXEName)) + 'REX.BAT';
    End; // If (Not FileExists (ExecPath))

    // Change current directory to application directory
    CurrDir := GetCurrentDir;
    SetCurrentDir (ExtractFilePath(PathToShort(Application.EXEName)));
    Try
      ExecPath := ExecPath + ' ' + CmdParam + ' ' +
                  RemDirSwitch +' ' + Trim(CompDets.CompPath) + ' /CODIR: ' + SetDrive;

      Result := (WinExec(PCHAR(ExecPath), SW_SHOW) > 31);
    Finally
      SetCurrentDir (CurrDir);
    End; // Try..Finally
  End; // If Result
End; // RunExchequer

//------------------------------

// Executes the E-Business Module, returns TRUE if successful
Function RunEBus (Var CompDets : CompanyDetRec) : Boolean;
Var
  //cmdFile, cmdPath, cmdParams : PChar;
  //Params                      : ANSIString;
  //Res                         : LongInt;
  ExecPath                    : ANSIString;
Begin // RunEBus
  (*** MH 26/09/07: Switched to WinExec to avoid VISTA asking if the user wanted to run it every time
  Params := '/EXCHQ: ' + ExtractFilePath(Application.ExeName) +
            ' /CODIR: ' + SetDrive +
            ' /DIR: ' + Trim(CompDets.CompPath);

  cmdFile   := StrAlloc(255);
  cmdPath   := StrAlloc(255);
  cmdParams := StrAlloc(255);

  StrPCopy (cmdParams, Params);
  StrPCopy (cmdFile,   'EBusAdmn.Exe');
  StrPCopy (cmdPath,   ExtractFilePath(Application.ExeName));

  Res := ShellExecute (0, NIL, cmdFile, cmdParams, cmdPath, SW_SHOW);

  StrDispose(cmdFile);
  StrDispose(cmdPath);
  StrDispose(cmdParams);

  Result := (Res > 32);
  ***)

  ExecPath:= ExtractFilePath(Application.ExeName) + 'EBusAdmn.Exe /EXCHQ: ' + ExtractFilePath(Application.ExeName) +
            ' /CODIR: ' + SetDrive + ' /DIR: ' + Trim(CompDets.CompPath);
  Result := (WinExec(PCHAR(ExecPath), SW_SHOW) > 31);
End; // RunEBus

//-------------------------------------------------------------------------

// Executes the Scheduler Admin Module, returns TRUE if successful
Function RunScheduler (Var CompDets : CompanyDetRec) : Boolean;
Var
  //cmdFile, cmdPath, cmdParams : PChar;
  //Params                      : ANSIString;
  //Res                         : LongInt;
  ExecPath                    : ANSIString;
Begin // RunScheduler
  (*** MH 26/09/07: Switched to WinExec to avoid VISTA asking if the user wanted to run it every time
  Params := ' /CODIR: ' + SetDrive +
            ' /DIR: ' + Trim(CompDets.CompPath);

  cmdFile   := StrAlloc(255);
  cmdPath   := StrAlloc(255);
  cmdParams := StrAlloc(255);

  StrPCopy (cmdParams, Params);
  StrPCopy (cmdFile,   'ExSched.Exe');
  StrPCopy (cmdPath,   ExtractFilePath(Application.ExeName));

  Res := ShellExecute (0, NIL, cmdFile, cmdParams, cmdPath, SW_SHOW);

  StrDispose(cmdFile);
  StrDispose(cmdPath);
  StrDispose(cmdParams);

  Result := (Res > 32);
  ***)

  ExecPath:= ExtractFilePath(Application.ExeName) + 'ExSched.Exe /CODIR: ' + SetDrive + ' /DIR: ' + Trim(CompDets.CompPath);
  Result := (WinExec(PCHAR(ExecPath), SW_SHOW) > 31);
End; // RunScheduler

//-------------------------------------------------------------------------

// Executes the Sentimail Module, returns TRUE if successful
Function RunSentimail (Var CompDets : CompanyDetRec) : Boolean;
Var
  //cmdFile, cmdPath, cmdParams : PChar;
  //Params                      : ANSIString;
  //Res                         : LongInt;
  ExecPath                    : ANSIString;
Begin // RunEBus
  (*** MH 26/09/07: Switched to WinExec to avoid VISTA asking if the user wanted to run it every time
  Params := ' /CODIR: ' + SetDrive +
            ' /DIR: ' + Trim(CompDets.CompPath);

  cmdFile   := StrAlloc(255);
  cmdPath   := StrAlloc(255);
  cmdParams := StrAlloc(255);

  StrPCopy (cmdParams, Params);
  StrPCopy (cmdFile,   'ELMANAGE.Exe');
  StrPCopy (cmdPath,   ExtractFilePath(Application.ExeName));

  Res := ShellExecute (0, NIL, cmdFile, cmdParams, cmdPath, SW_SHOW);

  StrDispose(cmdFile);
  StrDispose(cmdPath);
  StrDispose(cmdParams);

  Result := (Res > 32);
  ***)

  ExecPath:= ExtractFilePath(Application.ExeName) + 'ELMANAGE.Exe /CODIR: ' + SetDrive + ' /DIR: ' + Trim(CompDets.CompPath);
  Result := (WinExec(PCHAR(ExecPath), SW_SHOW) > 31);
End; // RunEBus

//-------------------------------------------------------------------------

// Replicates the security settings around all the companies
Procedure ReplicateSecurity;
Var
  ErrDir  : ShortString;
  Res     : LongInt;
Begin // ReplicateSecurity
  // Close the MCM file
  Close_File(F[CompF]);
  Try
    // Call the function to replicate the security settings
    ErrDir := SetDrive;
    Res := ReplicateEntLicence (SetDrive, ErrDir);
    If (Res > 0) Then
    Begin
      MessageDlg ('The following error occurred replicating the Release Code changes:-' + #13#13 +
                  'Error: ' + IntToStr(Res) + ' in ' + ErrDir, mtInformation, [mbOk], 0);
    End; // If (Res > 0)
  Finally
    Open_File(F[CompF], SetDrive + FileNames[CompF], 0);
  End; // Try..Finally
End; // ReplicateSecurity

//-------------------------------------------------------------------------

// Controls the entry of the Enterprise main Release Code
Procedure EntReleaseCode;
Var
  oCoPath : ShortString;
  Res     : LongInt;
Begin // EntReleaseCode
  Close_File(F[CompF]);
  Try
    //  0           OK
    //  1           Already Fully Released
    //  2           Release Code Entered
    //  1000        Unknown Error
    //  1001        Unknown Exception
    //  1100..1199  Btrieve Error opening SysF
    //  1200..1299  Btrieve Error Opening PwrdF
    //  1300        Unknown Error Reading Enterprise Licence File
    //  10000+      Error in SCD_SecWarnWizard
    oCoPath := ExMainCoPath^;
    ExMainCoPath^ := '';
    Res := MCM_SecWizard (SetDrive, SetDrive, 3, True);
    ExMainCoPath^ := oCoPath;
    If (Res > 2) Then
    Begin
      MessageDlg ('An error ' + IntToStr(Res) + ' occurred in the Release Code Wizard', mtError, [mbOk], 0);
    End; // If (Res > 2)
  Finally
    Status := Open_File(F[CompF], SetDrive + FileNames[CompF], 0);
  End; // Try..Finally
End; // EntReleaseCode

//-------------------------------------------------------------------------

// Displays the Module Release Code dialog, returns TRUE if updated
Function ModuleReleaseCodeDialog (Const ParentForm : TForm; Const IsPlugInPW : Boolean) : Boolean;
Var
  ModLics : TSetModRec;
  ErrDir  : ShortString;
  Res     : LongInt;
  iStatus : SmallInt;
Begin // ModuleReleaseCodeDialog
  Result := False;

  { open system file for main company }
  iStatus := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
  If (iStatus = 0) Then
  Begin
    iStatus := Open_File(F[PwrdF], SetDrive + FileNames[PwrdF], 0);
    If (iStatus = 0) Then
    Begin
      Try
        Init_AllSys;

        // HM 24/01/02: Define mode for dialog base on login password
        If IsPlugInPW Then
        Begin
          // Plug-In Password - Show Plug-In tab only
          ModuleMode := mmPlugIns
        End // If IsPlugInPW
        Else
        Begin
          ModuleMode := mmAll
        End; // Else

        { Display editing dialog }
        ModLics := TSetModRec.Create(ParentForm);
        Try
          // Get and Lock ModRR
          ModLics.ProcessSyss;

          // Get and Lock the MCM Global Security record
          LoadnLockCompanyOpt;

          Result := (ModLics.ShowModal = mrOK);
        Finally
          FreeAndNIL(ModLics);
        End;
      Finally
        { close system file for main company }
        Close_File(F[SysF]);
        Close_File(F[PwrdF]);
      End;

      //------------------------------

      If Result Then
      Begin
        // replicate security codes across all companies
        ParentForm.Refresh;
        ReplicateSecurity;
      End; // If (Res <> mrCancel)
    End // If (iStatus = 0)
    Else
    Begin
      Close_File(F[SysF]);
    End; // Else
  End; // If (iStatus = 0)
End; // ModuleReleaseCodeDialog

//-------------------------------------------------------------------------

// Displays the Enterprise User Count dialog
procedure EnterpriseUserCountDialog (Const ParentForm : TForm);
Var
  iStatus : SmallInt;
  Locked  : Boolean;
  Stat    : Boolean;
begin
  Stat := False;

  { open system file for main company }
  iStatus := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
  If (iStatus = 0) Then
  Begin
    iStatus := Open_File(F[PwrdF], SetDrive + FileNames[PwrdF], 0);
    If (iStatus = 0) Then
    Begin
      Locked := False;
      Ok := GetMultiSys (Boff, Locked, SysR);

      If OK Then
      Begin
        { multi user license }
        Stat := Control_USRLine;
      End; // If OK

      { close system file for main company }
      Close_File(F[SysF]);
      Close_File(F[PwrdF]);

      {-----------------------------------------------------------------}

      If Stat Then
      Begin
        // Force update of MCM window
        ParentForm.Refresh;

        // replicate security codes across all companies
        ReplicateSecurity;
      End; // If Stat
    End // If (iStatus = 0)
    Else
      Close_File(F[SysF]);
  End; // If (iStatus = 0)
end;

//-------------------------------------------------------------------------

// Challenge for the Resynch Companies password and run the utility if provided
Procedure ResynchCompanies;
Var
  ErrDir  : ShortString;
  Res     : LongInt;
Begin // ResynchCompanies
  // Challenge for ESN Security Password before continuing
  If GetESNPword (3, 'Resynchronise Licencing') Then
  Begin
    // Got Password - Remove all the user count xref stuff to reset system completely

    { Close Company.Dat }
    Close_File(F[CompF]);
    Try
      ErrDir := SetDrive;
      Res := ReplicateEntLicence2 (SetDrive, ErrDir, False, True, False, False);

      If (Res > 0) Then
      Begin
        MessageDlg ('The following error occurred resynchronising the Licencing:-' + #13#13 +
                    'Error: ' + IntToStr(Res) + ' in ' + ErrDir, mtInformation, [mbOk], 0);
      End; // If (Res > 0)
    Finally
      { Reopen Company.Dat }
      Status := Open_File(F[CompF], SetDrive + FileNames[CompF], 0);

      // Reload company setup record with new ESN
      LoadCompanyOpt;
    End;  // Try..Finally
  End; { If GetESNPword }
End; // ResynchCompanies

//-------------------------------------------------------------------------

// MH 25/02/2013 v7.0.2 ABSEXCH-13994: Allows users to clear down individual user counts
Procedure ResetIndividualEntUserCounts (Const ParentForm : TForm);
Begin // ResetIndividualEntUserCounts
  // Challenge for ESN Security Password before continuing
  If GetESNPword (2, 'Reset User Count') Then
  Begin
    ParentForm.Refresh;

    With TfrmResetUserCounts.Create(ParentForm) Do
    Begin
      Try
        ShowModal;
      Finally
        Free;
      End; // Try..Finally
    End; // With TfrmResetUserCounts.Create(ParentForm)
  End; // If GetESNPword (2, 'Reset User Count')
End; // ResetIndividualEntUserCounts

//-------------------------------------------------------------------------

// Resets the Enterprise User counts
Procedure ResetEntUserCounts (Const ParentForm : TForm);
Var
  Res     : LongInt;
  ErrInfo : ShortString;
begin // ResetEntUserCounts
  // Challenge for ESN Security Password before continuing
  If GetESNPword (2, 'Reset User Count') Then
  Begin
    ParentForm.Refresh;

    // Got Password - Remove all the user count xref stuff to reset system completely
    Res := ResetUserCounts(ErrInfo);
    If (Res = 0) Then
      // AOK
      MessageDlg('The User Count Security has been reset', mtInformation, [mbOK], 0)
    Else
      // Error
      MessageDlg('The following error occurred whilst resetting the User Count Security:-' + #13#13 +
                 '   Error: ' + IntToStr (Res) + ' - ' + ErrInfo + #13#13 +
                 'Please contact your Technical Support.', mtError, [mbOK], 0);
  End; // If GetESNPword (2, 'Reset User Count')
end; // ResetEntUserCounts

//-------------------------------------------------------------------------

// Reset Plug-In User Counts
procedure ResetPlugInUserCounts;
Var
  KeyS    : Str255;
  LStatus : SmallInt;
  Locked  : Boolean;
  RecAddr : LongInt;
begin // ResetPlugInUserCounts
  // Challenge for ESN Security Password before continuing
  If GetESNPword (4, 'Reset Plug-In User Counts') Then
  Begin
    KeyS := cmPlugInSecurity;
    LStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompPathK, KeyS);
    While (LStatus = 0) And (Company^.RecPFix = cmPlugInSecurity) Do
    Begin
      With Company^.PlugInSec Do
      Begin
        // Check current user count is > 0
        If (hkCurrUCount > 0) Then
        Begin
          // Lock security record
          Locked := False;
          If GetMultiRec(B_GetDirect, B_MultLock, KeyS, CompPathK, CompF, BOn, Locked) And Locked Then Begin
            // Get record position so the record can be unlocked
            GetPos(F[CompF], CompF, RecAddr);

            // Reset Logged-In user count
            hkCurrUCount := 0;

            // Update record
            LStatus := Put_Rec(F[CompF], CompF, RecPtr[CompF]^, CompPathK);
            Report_BError (CompF, LStatus);

            // Unlock record
            UnlockMultiSing(F[CompF], CompF, RecAddr);
          End { If GetMultiRec ... }
          Else
            // Failed to lock record
            MessageDlg('The Security Record for ' + QuotedStr(hkDesc) +
                       ' could not be locked for updating, please try again later',
                       mtWarning, [mbOK], 0);
        End; // If (hkCurrUCount > 0)
      End; // With Company^.PlugInSec

      LStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompPathK, KeyS);
    End; { While }
  End; // If GetESNPword (4, 'Reset Plug-In User Counts')
end; // ResetPlugInUserCounts

//-------------------------------------------------------------------------

// Print the Logged In Users Report to Preview
Procedure RunLoggedInUsersReport (Const ParentForm : TForm);
begin // RunLoggedInUsersReport
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveFilePosition (CompF, GetPosKey);
      SaveDataBlock (Company, SizeOf(Company^));

      //------------------------------

      ParentForm.Enabled := False;
      Try
        // Prints the Check For Users Report
        CheckForUsers (ParentForm);
      Finally
        ParentForm.Enabled := True;
        If ParentForm.CanFocus Then ParentForm.SetFocus;
      End;

      //------------------------------

      // Restore position in file
      RestoreSavedPosition (True);
      RestoreDataBlock (Company);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // RunLoggedInUsersReport

//-------------------------------------------------------------------------

// Runs the rebuild module for the selected company
Procedure RunRebuild (Const ParentForm : TForm; Const CompCode : ShortString; const SysLoggedIn : Boolean);
Var
  frmConfirmRebuild           : TfrmConfirmRebuild;
  cmdFile, cmdPath, cmdParams : PChar;
  Params                      : AnsiString;
  Flags, Res                  : LongInt;
  sKey                        : Str255;
  iStatus                     : SmallInt;
Begin // RunRebuild
  // Load the Company Record
  sKey := FullCompCodeKey(cmCompDet, CompCode);
  iStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sKey);
  If (iStatus = 0) Then
  Begin
    // Check data exists in that directory
{$IFDEF EXSQL}
    if SQLUtils.ValidCompany(Company^.CompDet.CompPath) then
{$ELSE}
    If FileExists(Trim(Company^.CompDet.CompPath) + PathSys) Then
{$ENDIF}
    Begin
      frmConfirmRebuild := TfrmConfirmRebuild.Create(ParentForm);
      Try
        With frmConfirmRebuild, Company^.CompDet Do
        Begin
          Caption := ParentForm.Caption;

          lblCompDets.Caption := 'Company: ' + Trim(CompName) + #13 +
                                 'Directory: ' + Trim(CompPath);

          lblDailyPword.Visible := (Not SysLoggedIn);

          ShowModal;

          If (ExitCode = 'B') Then
          Begin
            { Run Enterprise Rebuild Module }
            cmdFile   := StrAlloc(255);
            cmdPath   := StrAlloc(255);
            cmdParams := StrAlloc(255);

            Params := RemDirSwitch + ' ' + Trim(Company^.CompDet.CompPath) +
                      ' /CODIR: ' + SetDrive;
            If SysLoggedIn Then Params := Params + ' /GDP:';

            StrPCopy (cmdParams, Params);
            StrPCopy (cmdFile,   'SpecFunc.Exe');
            StrPCopy (cmdPath,   ExtractFilePath(Application.ExeName));

            Res := ShellExecute (0, NIL, cmdFile, cmdParams, cmdPath, SW_SHOW);

            StrDispose(cmdFile);
            StrDispose(cmdPath);
            StrDispose(cmdParams);

            // HM 24/05/00: Need to close MCM to remove access to MiscF in main company
            PostMessage (PArentForm.Handle, WM_Close, 0, 0);
          End; // If (ExitCode = 'B')
        End; // With frmConfirmRebuild, Company^.CompDet
      Finally
        FreeAndNIL(frmConfirmRebuild);
      End;
    End; // If FileExists(Trim(Company^.CompDet.CompPath) + PathSys)
  End; // If (iStatus = 0)
End; // RunRebuild

//-------------------------------------------------------------------------

// Runs the defined Backup or Restore command
Procedure RunBackupOrRestore (Const ParentForm : TForm; Const CompCode : ShortString; Const OpType : TBackupOrRestoreType);
var
  RunDialog                   : TRunDialog;
  RunStr, Str1, Str2, WorkStr : ANSIString;
  CompPath                    : ShortString;
  Pos1                        : Integer;
  sKey                        : Str255;
  iStatus                     : SmallInt;
begin
  // Load the Company Record
  sKey := FullCompCodeKey(cmCompDet, CompCode);
  iStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sKey);
  If (iStatus = 0) Then
  Begin
    CompPath := Trim(Company^.CompDet.CompPath);

    // Get command line to execute
    Case OpType Of
      brBackup  : RunStr := SyssCompany^.CompOpt.OptBackup;
      brRestore : RunStr := SyssCompany^.CompOpt.OptRestore;
    Else
      Raise Exception.Create ('CommonMCM.RunBackupOrRestore: Unhandled OpType (' + IntToStr(Ord(OpType)) + ')');
    End; // Case OpType Of

    // Proces the command line replacing macrp's
    If (CompPath <> '') And (Pos ('%DIR%', RunStr) > 0) Then
    Begin
      { Replace any instances of %DIR% with path of company }
      Pos1 := Pos ('%DIR%', RunStr);
      While (Pos1 > 0) Do Begin
        If (Pos1 > 1) Then
          Str1 := Copy (RunStr, 1, Pos1 - 1)
        Else
          Str1 := '';
        Str2 := Copy (RunStr, Pos1 + 5, Length(RunStr));

        RunStr := Str1 + CompPath + Str2;

        Pos1 := Pos ('%DIR%', RunStr);
      End; { While }
    End; // If (CompPath <> '') And (Pos ('%DIR%', RunStr) > 0)

    If (CompPath <> '') And (Pos ('%DRIVE%', RunStr) > 0) Then
    Begin
      { Replace any instances of %DRIVE% with drive of company }
      Pos1 := Pos ('%DRIVE%', RunStr);
      While (Pos1 > 0) Do Begin
        If (Pos1 > 1) Then
          Str1 := Copy (RunStr, 1, Pos1 - 1)
        Else
          Str1 := '';
        Str2 := Copy (RunStr, Pos1 + 7, Length(RunStr));

        RunStr := Str1 + ExtractFileDrive(CompPath) + Str2;

        Pos1 := Pos ('%DRIVE%', RunStr);
      End; { While }
    End; // If (CompPath <> '') And (Pos ('%DRIVE%', RunStr) > 0)

    If (CompPath <> '') And (Pos ('%PATH%', RunStr) > 0) Then
    Begin
      { Replace any instances of %PATH% with path of company less drive}
      Pos1 := Pos ('%PATH%', RunStr);
      While (Pos1 > 0) Do Begin
        If (Pos1 > 1) Then
          Str1 := Copy (RunStr, 1, Pos1 - 1)
        Else
          Str1 := '';
        Str2 := Copy (RunStr, Pos1 + 6, Length(RunStr));

        WorkStr := ExtractFileDir(CompPath);
        If (Trim(WorkStr) <> '') Then Begin
          { Remove drive }
          If (WorkStr[2] = ':') Then
            Delete (WorkStr, 1, 2);
        End; { If }

        RunStr := Str1 + WorkStr + Str2;

        Pos1 := Pos ('%PATH%', RunStr);
      End; { While }
    End; // If (CompPath <> '') And (Pos ('%PATH%', RunStr) > 0)

    If (CompPath <> '') And (Pos ('%CODE%', RunStr) > 0) Then
    Begin
      Pos1 := Pos ('%CODE%', RunStr);
      While (Pos1 > 0) Do Begin
        If (Pos1 > 1) Then
          Str1 := Copy (RunStr, 1, Pos1 - 1)
        Else
          Str1 := '';
        Str2 := Copy (RunStr, Pos1 + 6, Length(RunStr));

        RunStr := Str1 + CompCode + Str2;

        Pos1 := Pos ('%CODE%', RunStr);
      End; { While }
    End; // If (CompPath <> '') And (Pos ('%CODE%', RunStr) > 0)

    { Display Command Line for user confirmation/editing }
    RunDialog := TRunDialog.Create(ParentForm);
    Try
      Case OpType Of
        brBackup  : RunDialog.Caption := 'Backup Company';
        brRestore : RunDialog.Caption := 'Restore Company';
      Else
        Raise Exception.Create ('CommonMCM.RunBackupOrRestore: Unhandled OpType (' + IntToStr(Ord(OpType)) + ')');
      End; // Case OpType Of
      RunDialog.Command := RunStr;

      // HM 02/06/00: Need to close MCM to remove access to files during backup/restore
      If RunDialog.Execute Then
      Begin
        PostMessage (ParentForm.Handle, WM_Close, 0, 0);
      End; // If RunDialog.Execute
    Finally
      FreeAndNIL(RunDialog);
    End; // Try..Finally
  End; // If (iStatus = 0)
end;

//-------------------------------------------------------------------------

// Displays the Multi-Company Manager Options dialog
procedure DisplayMCMOptions(Const ParentForm : TForm; Var LoggedPass : ShortString; Const IsSystemUser : Boolean);
Var
  frmCompOpt : TfrmCompOpt;
begin
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveFilePosition (CompF, GetPosKey);
      SaveDataBlock (Company, SizeOf(Company^));

      { Copy company options record into company record }
      Company^ := SyssCompany^;

      { do options dialog }
      frmCompOpt := TfrmCompOpt.Create(ParentForm);
      Try
        With frmCompOpt Do
        Begin
          { Give options dialog a copy of the login password }
          LoggedPW := LoggedPass;
          SystemUser := IsSystemUser;

          { Lock record }
          ShowLink;

          { display company details }
          DisplayRec;

          { Display Window }
          ShowModal;

          If OK Then
          Begin
            { Options saved }
            LoggedPass := LoggedPW;
          End; { If }
        End; { With }
      Finally
        FreeAndNIL(frmCompOpt);
      End;

      { Copy company options record into company record }
      SyssCompany^ := Company^;

      // Restore position in file
      RestoreSavedPosition (True);
      RestoreDataBlock (Company);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
end;

//-------------------------------------------------------------------------

// Displays the Session Info dialog
Procedure DisplaySessionInfo (Const ParentForm : TForm);
Begin // DisplaySessionInfo
  ABMode := 1;
  With TAboutFrm.Create(Parentform) Do
  Begin
    Try
      ShowModal;
    Finally
      Free;
    End;
  End; // With TAboutFrm.Create(ParentForm)
End; // DisplaySessionInfo

//------------------------------

// Displays the MCM Help-About dialog
procedure DisplayHelpAbout (Const ParentForm : TForm; Const ShowExePath : Boolean);
Const
  KeyPath : Integer = CompCodeK;
Var
  EStatus, LStatus, TmpStat : Integer;
  TmpRecAddr, CompCount     : LongInt;
  TmpPath                   : ShortString;
  AboutFrm                  : TAboutFrm;
  KeyS                      : Str255;
Begin // DisplayHelpAbout
  ABMode:=0;
  If (Not SyssCompany^.CompOpt.OptHidePath) Or ShowExePath Then
  Begin
    { Display .EXE Path }
    ABMode := 2;
  End; // If (Not SyssCompany^.CompOpt.OptHidePath) Or ShowExePath

  AboutFrm:=TAboutFrm.Create(ParentForm);
  Try
    AboutFrm.HelpContext := 16;

    // Add the Company Count into the Help-About dialog
    With TBtrieveSavePosition.Create Do
    Begin
      Try
        // Save the current position in the file for the current key
        SaveFilePosition (CompF, KeyPath);
        SaveDataBlock (Company, SizeOf(Company^));

        (** MH 29/11/06: Removed as it didn't seem to be used
        // Count the instances of a Company Details record
        CompCount := 0;
        LStatus := Find_Rec(B_StepFirst, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
        While (LStatus = 0) Do
        Begin
          { Check its a company }
          If (Company^.RecPFix = cmCompDet) Then
          Begin
            Inc (CompCount);
          End; // If (Company^.RecPFix = cmCompDet)

          LStatus := Find_Rec(B_StepNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
        End; // While (LStatus = 0)
        **)

        // Add Company Count into About Text
        With AboutFrm Do
        Begin
          Memo1.Lines.Add ('');

          CompCount := GetLicencedCompanyCount;
          Memo1.Lines.Add (IntToStr(CompCount) + ' Compan' + IfThen(CompCount=1,'y','ies') + ' Licenced');
          CompCount := GetActualCompanyCount;
          Memo1.Lines.Add (IntToStr(CompCount) + ' Compan' + IfThen(CompCount=1,'y','ies') + ' in Use');
        End; // With AboutFrm

        // Restore position in file
        RestoreSavedPosition (True);
        RestoreDataBlock (Company);
      Finally
        Free;
      End; // Try..Finally
    End; // With TBtrieveSavePosition.Create

// HM 09/02/04: Removed as ESN now displayed as standard in Help-About
//
//    // Add the ESN into the the Help-About dialog
//    With AboutFrm Do
//    Begin
//      Memo1.Lines.Add ('');
//      Memo1.Lines.Add ('ESN: ' + EnterpriseLicence.elFullESN);
//    End; // With AboutFrm

    AboutFrm.ShowModal;
  Finally
    FreeAndNIL(AboutFrm);
  End;
End; // DisplayHelpAbout

//-------------------------------------------------------------------------

end.
