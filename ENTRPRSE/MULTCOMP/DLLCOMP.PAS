unit DllComp;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_DEPRECATED OFF}

{ Contains the interface to the Multi-Company Manager }

interface

Uses Controls, Dialogs, Forms, FileCtrl, IniFiles, SysUtils, Windows, Messages;

Procedure InitCompMan (NewApp : TApplication); Export;
Procedure ShowCompMan (SplashHandle : hWnd; CmdParam : ShortString); Export;

// MH 15/02/2013 v7.0.2 ABSEXCH-13994: Added new function with flags for resetting Workstation's User Counts
// Display the Multi-Company Manager as a normal window
Procedure ShowCompManEx (SplashHandle : hWnd; CmdParam : ShortString; Const ResetEnter1UC, ResetToolkitUC, ResetTradeUC : Boolean); Export; StdCall;

Procedure InitCompDll (NewApp : TApplication); Export;
Procedure InitCompDllEx (DataPath : ShortString); Export;
Procedure InitCompDllEx2 (DataPath : ShortString); Export;
Procedure TermCompDll; Export;
Procedure TermCompDll2; Export;
Procedure TermCompDll3; Export;

// MH 13/08/07: Added to try and workaround problems with HTML Help and the
// form being made inactive/sent to back
Procedure EntComp_ShareScreen (Const ParentScreen : TScreen); StdCall; Export;


Var
  OldApp : TApplication;
  OldScreen : TScreen;

implementation

Uses GlobVar, VarConst, CompUtil,  BtrvU2, VarFPosU, CompSec,
     {$IFDEF BUREAU}
     BTSupU1,
     BureauSecurity,  // SecurityManager Object
     CompListBureauF, // Bureau MCM
     CompListMCMF,    // Non-Bureau MCM
     GroupCompFile,   // Company-Group XReference File
     GroupsFile,      // Groups File
     GroupUsersFile,  // Definition of GroupUsr.Dat (GroupUsersF) and utility functions
     uSettings,       // Colour/Position editing and saving routines
     {$ENDIF}
{$IFDEF EXSQL}
     SQLUtils,
     //RoundWarnF,
{$ENDIF}

     // MH 14/02/2012 v7.0.2 ABSEXCH-13994: Added functionality to reset user counts for a workstation
     ResetWorkstationUserCounts,

     CompId, CompWdlg, ESNCheck;

Const
  {$I FilePath.Inc}

Procedure RestOldApp;
Begin
  If Assigned (OldApp) Then Begin
    Application := OldApp;
    OldApp := Nil;
  End; { If }

  If Assigned (OldScreen) Then Begin
    Screen := OldScreen;
    OldScreen := Nil;
  End; { If }
End;

//-------------------------------------------------------------------------

// MH 13/08/07: Added to try and workaround problems with HTML Help and the
// form being made inactive/sent to back
Procedure EntComp_ShareScreen (Const ParentScreen : TScreen); StdCall; Export;
Begin // EntComp_ShareScreen
  OldScreen := forms.Screen;
  forms.Screen := ParentScreen;
End; // EntComp_ShareScreen

//-------------------------------------------------------------------------

Procedure InitCompMan (NewApp  : TApplication);
Begin
  If (Not Assigned(OldApp)) Then Begin
    OldApp := Application;
    Application := NewApp;
  End; { If }

  Application.HelpFile := 'MCM.CHM';
End;

//-------------------------------------------------------------------------

// MH 15/02/2013 v7.0.2 ABSEXCH-13994: Redirected legacy function to new function
Procedure ShowCompMan (SplashHandle : hWnd; CmdParam : ShortString);
Begin // ShowCompMan
  ShowCompManEx (SplashHandle, CmdParam, False, False, False);
End; // ShowCompMan

//------------------------------

// MH 15/02/2013 v7.0.2 ABSEXCH-13994: Added new function with flags for resetting Workstation's User Counts
// Display the Multi-Company Manager as a normal window
Procedure ShowCompManEx (SplashHandle : hWnd; CmdParam : ShortString; Const ResetEnter1UC, ResetToolkitUC, ResetTradeUC : Boolean);
Var
  frmStandardMCM : TfrmStandardMCM;  // Non-Bureau MCM Form
  frmBureauMCM   : TfrmBureauMCM;    // Bureau MCM Form
  TmpDir         : ShortString;
  CompCount, I   : SmallInt;
  NoNob          : Boolean;
  lStatus        : Smallint;
Begin
  { need to open data files }
  SetDrive := PathToShort(ExtractFilePath (Application.ExeName));

  { Check Command Line Parameters for Company Redirection switch }
  If (Pos ('/CMPDIR:', CmdParam) > 0) Then Begin
    { Got it - now extract it }
    TmpDir := Trim(Copy (CmdParam, Pos ('/CMPDIR:', CmdParam) + 8, Length(CmdParam)));

    { Delete any extra parameters on end }
    If (Pos (' ', TmpDir) > 0) Then
      Delete (TmpDir, Pos (' ', TmpDir), Length(TmpDir));

    If (Length(TmpDir) > 3) Then Begin
      { Make sure its got a '\' on end }
      If (TmpDir[Length(TmpDir)] <> '\') Then
        TmpDir := TmpDir + '\';

{$IFDEF EXSQL}
      if SQLUtils.ValidSystem(TmpDir) then
      begin
{$ELSE}
      { See if it points to a valid system }
      If DirectoryExists (TmpDir) And
         FileExists(TmpDir + 'COMPANY.DAT') And
         {FileExists(TmpDir + 'MCOMPMAN.SYS') And}
         FileExists(TmpDir + Path3 + MiscNam) Then
      Begin
{$ENDIF}
        SetDrive := TmpDir;
      End; { If }
    End; { If }
  End; { If }

  { Open data files }
  ExMainCoPath^ := SetDrive;

  // MH 14/02/2012 v7.0.2 ABSEXCH-13994: Reset user counts for a workstation, must be done here
  // before MiscF is opened otherwise the SQL Emulator closes MiscF
  Open_System(CompF, CompF);
  If ResetEnter1UC Or ResetToolkitUC Or ResetTradeUC Then
  Begin
    ResetWorkstationUCounts (ResetEnter1UC, ResetToolkitUC, ResetTradeUc);
  End; // If ResetEnter1UC Or ResetToolkitUC Or ResetTradeUC

  // MH 02/08/06: Modified for IAO to allow detection of expiry of P.SQL Demo Licences, will
  // also be useful when we finally switch Exchequer to the 20th century!
  //Open_System(MiscF, MiscF);
  lStatus := Open_File(F[MiscF],SetDrive+FileNames[MiscF],0);
  If (lStatus = 0) Then
  Begin
    //Open_System(CompF, CompF);
    {$IFDEF BUREAU}
    Open_System(GroupF, GroupF);
    Open_System(GroupCompXRefF, GroupCompXRefF);
    Open_System(GroupUsersF, GroupUsersF);
    {$ENDIF}

  { TODO : Make sure the files are closed properly }

    // Set the path for the Settings.Dat file which contains the
    // window positions and colours
    sMiscDirLocation := SetDrive;

    // Load the MCM settings record
    LoadCompanyOpt;

    { HM 16/07/01: Check the Company Licence Count has not been exceeded }
    CompCount := GetActualCompanyCount;
    If (CompCount > GetLicencedCompanyCount) Then
      { Count exceeded - display warning }
      DisplayCompCountWarning (CompCount, GetLicencedCompanyCount);

    //------------------------------

    {$IFDEF EXSQL}
// MH 16/09/08:
//    If SQLUtils.UsingSQL And (SQLUtils.CheckExchRnd <> 0) Then
//    Begin
//      // Notify the users that the Exchequer SQL Rounding function is non-functional
//      DisplayRoundingWarning;
//    End; // If SQLUtils.UsingSQL And (SQLUtils.CheckExchRnd <> 0)
    {$ENDIF}

    //------------------------------

    // Check Backdoor for testing purposes
    NoNob := True;
    If FindCmdLineSwitch('NOB', ['-', '/'], True) Then
    Begin
      // No Bureau switch - check for backdoor authorisation file
      NoNob := Not FileExists ('C:\6453892.TMP');
    End; // If FindCmdLineSwitch('NOB', ['-', '/'], True)

    //------------------------------

    // Check whether to display the standard MCM or the Bureau MCM
    If SyssCompany^.CompOpt.OptBureauModule And NoNob Then
    Begin
      // Bureau Module - Display Bureau Login
      If SecurityManager.Login(SplashHandle) Then
      Begin
        // Setup the Bureau Module with per-user settings
        oSettings.UserName := SecurityManager.smUserCode;

        // Display the Bureau's Company List
        frmBureauMCM := TfrmBureauMCM.Create(Application);
        Try
          frmBureauMCM.CmdParam := CmdParam;
          frmBureauMCM.SplashHandle := SplashHandle;

          { HM 24/07/01: Check ESN in Company.Dat against that in Enterprise Licence }
          frmBureauMCM.ESNError := (CheckESNIntegrity <> 0);

          frmBureauMCM.ShowModal;
        Finally
          FreeAndNIL(frmBureauMCM);
          Close_File (F[CompF]);
        End;
      End // If SecurityManager.Login
      Else
      Begin
        Close_File (F[CompF]);
        PostMessage (SplashHandle, WM_SBSFDMsg, 0, 0);
      End; // Else
    End // If SyssCompany^.CompOpt.OptBureauModule And NoNob
    Else
    Begin
      // Display non-Bureau MCM
      frmStandardMCM := TfrmStandardMCM.Create(Application);
      Try
        frmStandardMCM.CmdParam := CmdParam;
        frmStandardMCM.SplashHandle := SplashHandle;

        { HM 24/07/01: Check ESN in Company.Dat against that in Enterprise Licence }
        frmStandardMCM.ESNError := (CheckESNIntegrity <> 0);

        frmStandardMCM.ShowModal;
      Finally
        FreeAndNIL(frmStandardMCM);
        Close_File (F[CompF]);
        Close_File (F[GroupF]);
        Close_File (F[GroupCompXRefF]);
        Close_File (F[GroupUsersF]);
      End;
    End; // Else
  End // If (lStatus = 0)  
  Else
  Begin
    // Btrieve error opening data files
    If (lStatus = 161) Then
      // P.SQL Expired or too many users
      MessageDlg('A Pervasive.SQL User Count Error (161) occurred opening the data files, this ' +
                 'usually means that either the maximum number of users are already using the system or ' +
                 'that you are running a Pervasive.SQL Demo Licence which has expired',
                 mtError,[mbOk],0)
    Else
      MessageDlg('Error in File:'+FileNames[MiscF]+' Type '+InttoStr(lStatus)+#13+
                 Set_StatMes(lStatus),mtError,[mbOk],0);
    PostMessage (SplashHandle, WM_Close, 0, 0);
  End; // Else

// HM 04/02/04: Replaced Old MCM window
//    { Display MCM }
//    CompListMode := 1;
//    Form_CompanyList := TForm_CompanyList.Create(Application);
//    Try
//      { HM 24/07/01: Check ESN in Company.Dat against that in Enterprise Licence }
//      Form_CompanyList.ESNError := (CheckESNIntegrity <> 0);
//
//      Form_CompanyList.CmdParam := CmdParam;
//      Form_CompanyList.SplashHandle := SplashHandle;
//      Form_CompanyList.ShowModal;
//    Finally
//      Form_CompanyList.Free;
//
//      Close_File (F[CompF]);
//    End;

  {TermCompDll;}
  RestOldApp;
End;

{ Called to open the btrieve files }
Procedure BaseInitCompDllEx (DataPath : ShortString; OpenMiscF : Boolean);
Var
  IniF    : TIniFile;
  TmpPath : ShortString;
Begin
  { need to open data files }
  If (Trim(DataPath) = '') Then DataPath := ExtractFilePath(Application.ExeName);
  SetDrive := IncludeTrailingBackSlash(PathToShort(DataPath));

  { See if the Company Directory needs to be redirected }
  If FileExists (SetDrive + 'ENTWREPL.INI') Then Begin
    IniF := TIniFile.Create (SetDrive + 'ENTWREPL.INI');
    Try
      TmpPath := IniF.ReadString ('UpdateEngine', 'NetworkDir', '');
    Finally
      IniF.Destroy;
    End;

    If (Trim(TmpPath) <> '') Then Begin
      { Make sure its got a '\' on end }
      If (TmpPath[Length(TmpPath)] <> '\') Then
        TmpPath := TmpPath + '\';

{$IFDEF EXSQL}
      if SQLUtils.ValidSystem(TmpPath) then
      begin
{$ELSE}
      { See if it points to a valid system }
      If DirectoryExists (TmpPath) And
         FileExists(TmpPath + 'COMPANY.DAT') And
         {FileExists(TmpPath + 'MCOMPMAN.SYS') And}
         FileExists(TmpPath + Path3 + MiscNam) Then
      Begin
{$ENDIF}
        SetDrive := TmpPath;
      End; { If }
    End; { If }
  End; { If }

  { Open data files }
  ExMainCoPath^ := SetDrive;
//ShowMessage ('EntComp.DllComp.InitCompDllEx'#13'SetDrive='+SetDrive);
  If OpenMiscF Then Open_System(MiscF, MiscF);
  Open_System(CompF, CompF);

  { Load company setup record }
  LoadCompanyOpt;
End;

{ Called to open the btrieve files }
Procedure InitCompDllEx (DataPath : ShortString);
Begin // InitCompDllEx
  BaseInitCompDllEx (DataPath, True);
End; // InitCompDllEx

{ Called to open the btrieve files }
Procedure InitCompDllEx2 (DataPath : ShortString);
Begin // InitCompDllEx
  BaseInitCompDllEx (DataPath, False);
End; // InitCompDllEx

//-------------------------------------------------------------------------

{ Called to open the btrieve files }
Procedure InitCompDll (NewApp : TApplication);
Begin { InitCompDll }
  InitCompMan (NewApp);

  InitCompDllEx (ExtractFilePath(Application.ExeName));
End; { InitCompDll }

//-------------------------------------------------------------------------

{ Called to close the Btrieve files }
Procedure TermCompDll;
Begin
{ShowMessage ('Starting TermCompDll');}
  Close_File (F[MiscF]);
  Close_File (F[CompF]);

  RestOldApp;

  Reset_B;
{ShowMessage ('Finished TermCompDll');}
End;

//-------------------------------------------------------------------------

{ Called to close the Btrieve files }
Procedure BaseTermCompDll (CloseMiscF : Boolean);
Begin // BaseTermCompDll
  If CloseMiscF Then Close_File (F[MiscF]);
  Close_File (F[CompF]);

  RestOldApp;
End; // BaseTermCompDll

Procedure TermCompDll2;
Begin // TermCompDll2
  BaseTermCompDll (True);
End; // TermCompDll2

Procedure TermCompDll3;
Begin // TermCompDll3
  BaseTermCompDll (False);
End; // TermCompDll3

//-------------------------------------------------------------------------

Initialization
  OldApp := Nil;
  OldScreen := NIL;
Finalization
  RestOldApp;
end.
