unit Entreg2u;

{ markd6 14:23 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Setupbas, ExtCtrls, StdCtrls, TEditVal, BorBtns, bkgroup, SBSPanel,
  IniFiles, Registry, FileCtrl, ComObj, LicRec, SetupReg, RegCOM,
  ShellApi;

const
  // PKR. 20/04/2015. ABSEXCH-16308. Credit Card Add-in.
  // There is no AfterShow event on Delphi forms, but we might need to display
  // a dialog box if the Credit Card add-in is installed.  This looks better if
  // it pops up after the main form has been shown.
  // To simulate the AfterShow event, we use the FormShow event to send a message
  // to the main form which means the FormShow event completes and the dialog can
  // then be displayed.
  WM_AFTER_SHOW = WM_USER + 300;
  DOT_NET_4_5_1_DOWNLOAD_PAGE = 'http://www.microsoft.com/en-gb/download/details.aspx?id=40773';

type
  TSetupTemplate1 = class(TSetupTemplate)
    lblEntVer: Label8;
    Notebook1: TNotebook;
    ListBox1: TListBox;
    lblVersion: TLabel;
    lblBtrUser: Label8;
    chkOLEServer: TCheckBox;
    chkGraphs: TCheckBox;
    chkCOMCust: TCheckBox;
    chkCOMToolkit: TCheckBox;
    chkSecurity: TCheckBox;
    chkDBFWriter: TCheckBox;
    chkExchOutlookToday: TCheckBox;
    chkExchSetupClientSync: TCheckBox;
    chkExchSentimail: TCheckBox;
    chkLITECOMCust: TCheckBox;
    chkLITECOMToolkit: TCheckBox;
    chkLITEDBFWriter: TCheckBox;
    chkLITEGraphs: TCheckBox;
    chkLITEOLEServer: TCheckBox;
    chkLITESecurity: TCheckBox;
    chkLITEConfigDB: TCheckBox;
    chkLITEICE: TCheckBox;
    chkLITESpeller: TCheckBox;
    chkConfigDB: TCheckBox;
    chkExchSpell: TCheckBox;
    chkExchHTMLHelp: TCheckBox;
    chkFaxComponents: TCheckBox;
    chkCreditCardAddin: TCheckBox;
    chkExcelExportUtilities: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure InstrLblDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FClServer    : Boolean;
    FMultiUser   : Boolean;
    FPervVersion : SmallInt;
    FWorkgVer    : Byte;
    LITEMode     : Boolean;

    // PKR. 20/04/2015. ABSEXCH-16308. Credit Card Add-in.
    creditCardAddinInstalled : boolean;
    minimumDotNetInstalled   : boolean;

    Procedure AddListMsg (Const Msg : ShortString);
    //procedure DoConfig;
    //Function  IS_WinNT  :  Boolean;
    Function  ValidOk(VCode : Char) : Boolean; OverRide;
    Procedure RegistrationNotification (Const NotificationType : TNotificationType; Const Desc : ShortString);

    function isCreditCardAddinInstalled : Boolean;
    procedure WmAfterShow(var Msg: TMessage); message WM_AFTER_SHOW;
  public
    { Public declarations }
  end;

var
  SetupTemplate1: TSetupTemplate1;

implementation

{$R *.DFM}
{$R winXPman.Res}

Uses CompUtil, EntLic, LicFuncU, History, Brand, APIUtil, PervInfo, WGEConfig, EntLicence,
     DiskUtil, HTMLHelpPath, FileVirtualisation, DotNet;

//-------------------------------------------------------------------------

procedure TSetupTemplate1.FormCreate(Sender: TObject);
Var
  EntLicR : EntLicenceRecType;
  sParam, sPath : ShortString;
  I, iPos : SmallInt;
begin
  inherited;

  // MH 06/02/06: Updated branding for LITE
  Application.Title := Branding.pbProductName + ' Component Setup';
  Caption := Application.Title;

  ModifyCaptions ('<APPTITLE>', Branding.pbProductName, [InstrLbl]);

  LITEMode := (Branding.pbProduct In [ptLITE]);
  If LITEMode Then
  Begin
    // LITE
    Notebook1.ActivePage := 'LITE Options';

    lblVersion.Top := 3;
    lblVersion.Caption := LITEVersion_Reg;
    lblVersion.Font.Color := clNavy;
  End // If LITEMode
  Else
  Begin
    // Exchequer
    lblVersion.Caption := CurrVersion_Reg;
    NoteBook1.ActivePage := 'Options';
  End; // Else

//  Caption := 'Exchequer Component Setup';

  // Only enable the HTML Help option if running from a remote drive
  chkExchHTMLHelp.Enabled := NeedsHTMLHelpPath(ExtractFilePath(Application.ExeName));

  // Check Command Line Parameters for automation switches
  If FindCmdLineSwitch('Auto',  ['-', '/'], True) Then
    // Ran from splash screen to fix workstation setup
    BackBtn.Caption := '&Fix';
  chkConfigDB.Checked   := FindCmdLineSwitch('Btr',     ['-', '/'], True);
  chkGraphs.Checked     := FindCmdLineSwitch('Graph',   ['-', '/'], True);
  chkOLEServer.Checked  := FindCmdLineSwitch('Ole',     ['-', '/'], True);
  chkSecurity.Checked   := FindCmdLineSwitch('Sec',     ['-', '/'], True);
  chkCOMCust.Checked    := FindCmdLineSwitch('ComCust', ['-', '/'], True);
  chkCOMToolkit.Checked := FindCmdLineSwitch('ComTK',   ['-', '/'], True);

  // HM 08/05/02: Added support for Win RW DBF Writer
  If FileExists (ExtractFilePath(Application.ExeName) + 'DBFWrite.Dll') Then
    chkDBFWriter.Checked  := FindCmdLineSwitch('DBF',   ['-', '/'], True)
  Else
    chkDBFWriter.Enabled := False;

  If FindCmdLineSwitch('Toolkit',  ['-', '/'], True) Then Begin
    chkOLEServer.Enabled := False;
    chkGraphs.Enabled := False;
    chkSecurity.Enabled := True;
  End; { If FindCmdLineSwitch('Toolkit'... }

  chkLITECOMCust.Checked := chkCOMCust.Checked;
  chkLITECOMToolkit.Checked := chkCOMToolkit.Checked;
  chkLITEDBFWriter.Checked := chkDBFWriter.Checked;
  chkLITEGraphs.Checked := chkGraphs.Checked;
  chkLITEOLEServer.Checked := chkOLEServer.Checked;
  chkLITESecurity.Checked := chkSecurity.Checked;
  chkLITEConfigDB.Checked := chkConfigDB.Checked;

  // PKR. 20/04/2015. ABSEXCH-16308. Credit Card Add-in.
  creditCardAddinInstalled := isCreditCardAddinInstalled;
  minimumDotNetInstalled   := DotNetInfo.Net451Installed;

  chkCreditCardAddin.Enabled := (creditCardAddinInstalled) and (minimumDotNetInstalled);

  // Read Exchequer Licence File to determine Exchequer versioning details
  ExMainCoPath^ := ExtractFilePath(Application.ExeName);
  FillChar (EntLicR, SizeOf(EntLicR), #0);
  If ReadEntLic (EntLicFName, EntLicR) Then
  Begin
    With EntLicR Do
    Begin
      { Generate an Exchequer version string for the top-left }
      //lblEntVer.Caption := licCDEntVersion (licCopyEntLicToCDLic (EntLicR), True);

      lblEntVer.Caption := EnterpriseLicence.elShortVersionDesc;

      // Cache Client-Server flag for later
      FClServer := (licEntClSvr = 1);

      // Determine whether to optimise Btrieve for Single-User or Multi-User use
      With TIniFile.Create(ExtractFilePath(Application.ExeName) + 'WSTATION\SETUP.USR') Do
        Try
          // First check for specific override in SETUP.USR
          If ValueExists ('BtrConfig', 'MultiUser') Then
            // Use override setting
            FMultiUser := ReadBool ('BtrConfig', 'MultiUser', True)
          Else
            // Determine from user count licencing
            FMultiUser := (licUserCnt > 1) Or                   // Exchequer User Count
                          (licUserCounts[ucToolkit30] > 1) Or   // 30-Day Toolkit User Count
                          (licUserCounts[ucToolkitFull] > 1) Or // Full Toolkit User Count
                          (licUserCounts[ucTradeCounter] > 1);  // Trade Counter User Count

          // Display on screen for support info
          If FMultiUser Then
            lblBtrUser.Caption := '(MU)'
          Else
            lblBtrUser.Caption := '(SU)';

          // HM 17/07/03: Added Pervasive Version Code so v8 can be intelligently registered
          If FClServer Then
            FPervVersion := ReadInteger('ClientServer','EngineVersion',0)
          Else
            FPervVersion := 0;
        Finally
          Free;
        End;

// MH 28/02/06: Modified to check the Installed setting in the registry as for LITE (and future
// versions of Exchequer) the full Workgroup Client is installed into PVSW\BIN so the
// following check is incorrect
//
//      // HM 13/10/03: Modified to check Btrieve Registry settings for Workgroup engine - firstly
//      // check licence to see that Workgroup was licenced at some point, then check for a WGE
//      // specific .EXE in the BIN directory - this is more secure than checking the INSTALLED
//      // setting in Setup.Usr.
//      FWorkgVer := licPSQLWGEVer;
//      If (FWorkgVer > 0) Then
//      Begin
//        If (Not FileExists(ExtractFilePath(Application.ExeName) + 'BIN\CLILCADM.EXE')) Then
//          FWorkgVer := 0;
//      End; // If FIsWorkgroup

      If PervasiveInfo.WorkgroupInstalled Then
        FWorkgVer := 1  // v8/v8.7
      Else
        FWorkgVer := 0;
    End; { With EntLicR }

    // MH 22/06/07: Check the .EXE location for File Virtualisation - because EntRegX runs as
    // an administrator under Vista we are passing the path of the original users VirtualStore
    // directory in as a parameter:-
    //
    //  /VirtualStore:C:\Users\Obi Wan Kenobi\AppData\Local\VirtualStore\Users\Obi Wan Kenobi\AppData\Roaming\Exch600.2\
    //
    // NOTE: Passed in with " around the path but ParamStr strips them off when it consolidates the separate parameters
    If (ParamCount > 0) Then
    Begin
      For I := 1 To ParamCount Do
      Begin
        sParam := ParamStr(I);
        iPos := Pos ('/VIRTUALSTORE:', UpperCase(sParam));
        If (iPos > 0) Then
        Begin
          sPath := Copy (sParam, 15, Length(sParam));
    //ShowMessage (CmdLine + #13 + sPath);
          If DoVirtualisationChecks (ExtractFileDrive(sPath)) Then
          Begin
            If DirectoryExists(SPath) Then
            Begin
              MessageDlg ('Windows File Virtualisation has been detected and must be disabled for the ' +
                          Branding.pbProductName + ' system to run correctly, please contact your Technical ' +
                          'Support immediately', mtError, [mbOK], 0);
              PostMessage (Self.Handle, WM_Close, 0, 0);
            End; // If DirectoryExists(SPath)
          End; // If DoVirtualisationChecks (ExtractFileDrive(sPath))
        End; // If (iPos > 0)
      End; // For I
    End; // If (ParamCount > 0); // If (ParamCount > 0)
  End // If ReadEntLic (EntLicFName, EntLicR)
  Else Begin
    MessageDlg ('EntReg.Exe cannot load the Exchequer Licence File to determine the correct ' +
                'settings, please contact your Technical support', mtError, [mbok], 0);
    PostMessage (Self.Handle, WM_Close, 0, 0);
  End; { Else }
end;

//-------------------------------------------------------------------------

{ Called by all check boxes for updating linked info }
Function TSetupTemplate1.ValidOk(VCode : Char) : Boolean;
Var
  sAppsDir, sDataDir : String;

  //------------------------------

  // Set BtrieveMode correctly
  Procedure SetupBtrieveMode;
  Begin // SetupBtrieveMode
    With TRegistry.Create Do
    Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        If OpenKey('SOFTWARE\Exchequer\Enterprise', True) Then
        Begin
          If FClServer Then
          Begin
            WriteInteger('BtrieveMode', 1);

            If ValueExists ('ForceCS') Then
            Begin
              WriteInteger ('ForceCS', 0);
            End; // If ValueExists ('ForceCS')
          End // If FClServer
          Else
            WriteInteger('BtrieveMode', 2);
        End; // If OpenKey('SOFTWARE\Exchequer\Enterprise', True)
      Finally
        Free;
      End; // Try..Finally
    End; // With TRegistry.Create
  End; // SetupBtrieveMode

  //------------------------------

Begin { ValidOK }
  If (VCode = 'B') Then Begin
    Result := False;

    { Setup the specified components }
    With TSetupEntRegistry.Create Do
    Begin
      Try
        // Setup the form to show info
        NoteBook1.ActivePage := 'Progress';
        ListBox1.Refresh;
        BackBtn.Enabled := False;

        With NextBtn Do Begin
          Cancel := False;
          Caption := 'Close';
          Default := True;
          Enabled := False;
        End; { With }

        // Configure the Configuration Object
        ClientServer := FClServer;
        If FMultiUser Then UserCount := 2 Else UserCount := 1;
        DispProgress := AddListMsg;
        PervasiveVersion := FPervVersion;
        PSQLWorkgroupVer := FWorkgVer;

        // HM 08/05/04: Added local sDataDir to store long file name as needed for SetupSystemDir, the
        // EntDir and DataDir properties of TSetupEntRegistry automatically convert to short names for
        // safe Btrieve usage, but the SystemDir registry field will be safer as a long file name
        sAppsDir := ExtractFilePath(Application.ExeName);
        sDataDir := sAppsDir;

        // Check for Local Program Files
        If FileExists (sAppsDir + 'ENTWREPL.INI') Then
        Begin
          With TIniFile.Create (sAppsDir + 'ENTWREPL.INI') Do
          Begin
            Try
              sDataDir := ReadString ('UpdateEngine', 'NetworkDir', sAppsDir);
              If (Trim(sDataDir) = '') Or (Not FileExists (IncludeTrailingBackslash(sDataDir) + 'COMPANY.DAT')) Then
                sDataDir := IncludeTrailingBackslash(sAppsDir);
            Finally
              Free;
            End; // Try..Finally
          End; // With TIniFile.Create (sDataDir + 'ENTWREPL.INI')
        End; // If FileExists (sDataDir + 'ENTWREPL.INI')

        EntDir := sAppsDir;
        DataDir := sDataDir;

        // HM 05/08/04: Added SystemDir value into HKEY_CURRENT_USER\Software\Exchequer\Enterprise
        //              to indicate the location of the main Exchequer directory for the VAO system
        //              to use.
        SetupSystemDir(sDataDir);

        // Btrieve - Exchequer Only
        If ((Not LITEMode) And chkConfigDB.Checked) Or (LITEMode And chkLITEConfigDB.Checked) Then
        Begin
          AddListMsg ('');
          AddListMsg ('  Configuring Database Engine');
          SetupBtrieveMode;
          AddListMsg ('    OK');
        End; // If ((Not LITEMode) And chkConfigDB.Checked)

        // MH 28/03/06: Added support for TSpellers spell check component
        If chkExchSpell.Checked Or chkLITESpeller.Checked Then
        Begin
          AddListMsg ('');
          AddListMsg ('  Configuring Spell Checker');
          SetupSpellCheck(EntDir);
          AddListMsg ('    OK');
        End; // If chkExchSpell.Checked Or chkLITESpeller.Checked
      Finally
        Free;
      End; // Try..Finally
    End; // With TSetupEntRegistry.Create

    With TExchequerCOMRegistration.Create (sAppsDir, sDataDir) Do
    Begin
      Try
        OnNotify := RegistrationNotification;

        SelectedComponents := [];
        If ((Not LITEMode) And chkCOMCust.Checked) Or (LITEMode And chkLITECOMCust.Checked) Then
          SelectedComponents := SelectedComponents + [ecCOMCustomisation];
        If ((Not LITEMode) And chkCOMToolkit.Checked) Or (LITEMode And chkLITECOMToolkit.Checked) Then
          SelectedComponents := SelectedComponents + [ecToolkits];
        If ((Not LITEMode) And chkDBFWriter.Checked) Or (LITEMode And chkLITEDBFWriter.Checked) Then
          SelectedComponents := SelectedComponents + [ecDBFWriter];
        If ((Not LITEMode) And chkGraphs.Checked) Or (LITEMode And chkLITEGraphs.Checked) Then
          SelectedComponents := SelectedComponents + [ecGraphOCX];
        If ((Not LITEMode) And chkOLEServer.Checked) Or (LITEMode And chkLITEOLEServer.Checked) Then
          SelectedComponents := SelectedComponents + [ecOLEServer];
        If ((Not LITEMode) And chkSecurity.Checked) Or (LITEMode And chkLITESecurity.Checked) Then
          SelectedComponents := SelectedComponents + [ecSecurity];
        If (Not LITEMode) And chkExchOutlookToday.Checked Then
          SelectedComponents := SelectedComponents + [ecOutlookToday];
        If ((Not LITEMode) And chkExchSetupClientSync.Checked) Or (LITEMode And chkLITEICE.Checked)  Then
          SelectedComponents := SelectedComponents + [ecClientSync];
        If (Not LITEMode) And chkExchSentimail.Checked Then
          SelectedComponents := SelectedComponents + [ecSentimail];
        If (Not LITEMode) And chkFaxComponents.Checked Then
          SelectedComponents := SelectedComponents + [ecFaxing];
        if (not LITEMode) and chkCreditCardAddin.Checked then
          SelectedComponents := SelectedComponents + [ecCreditCards];
        // MH 14/03/2018 2018-R2 ABSEXCH-19845: Added support for registering XLUtils.DLL
        if (not LITEMode) and chkExcelExportUtilities.Checked Then
          SelectedComponents := SelectedComponents + [ecExcelUtils];

        RegisterCOMObjects (True); // Register all, ignore errors
      Finally
        Free;
      End; // Try..Finally
    End; // With TExchequerCOMRegistration.Create

    If chkExchHTMLHelp.Checked Then
      RegisterHTMLHelpPath(sAppsDir);

    NextBtn.Enabled := True;
    NextBtn.SetFocus;
    AddListMsg ('');
    AddListMsg ('Configuration Complete');
  End { If }
  Else
    Result := True;
End; { ValidOK }

procedure TSetupTemplate1.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  { Stop the 'Do you want to abort the installation' message }
  {inherited;}
end;

Procedure TSetupTemplate1.AddListMsg (Const Msg : ShortString);
Begin { AddListMsg }
  ListBox1.Items.Add (Msg);
  ListBox1.ItemIndex := PreD(ListBox1.Items.Count);
  ListBox1.Refresh;
End; { AddListMsg }

procedure TSetupTemplate1.InstrLblDblClick(Sender: TObject);
begin
  inherited;

  If (Notebook1.ActivePage = 'Options') Then
  Begin
    chkCOMCust.Checked    := True;
    chkCOMToolkit.Checked := True;
    chkDBFWriter.Checked  := True;
    chkGraphs.Checked     := True;
    chkOLEServer.Checked  := True;
    chkSecurity.Checked   := True;
    //chkExchOutlookToday.Checked := True;
    //chkExchSetupClientSync.Checked := True;
    //chkExchSentimail.Checked := True;
    chkConfigDB.Checked := True;
    // PKR. 20/04/2015. ABSEXCH-16308. Credit Card Add-in.
    chkCreditCardAddin.Checked := chkCreditCardAddin.Enabled;
    // MH 14/03/2018 2018-R2 ABSEXCH-19845: Added support for registering XLUtils.DLL
    chkExcelExportUtilities.Checked := True;
  End // If (Notebook1.ActivePage = 'Options')
  Else If (Notebook1.ActivePage = 'LITE Options') Then
  Begin
    chkLITECOMCust.Checked := True;
    chkLITECOMToolkit.Checked := True;
    chkLITEDBFWriter.Checked := True;
    chkLITEICE.Checked := True;
    chkLITEGraphs.Checked := True;
    chkLITEOLEServer.Checked := True;
    chkLITESecurity.Checked := True;
    chkLITEConfigDB.Checked := True;
    chkLITESpeller.Checked := True;
  End; // If (Notebook1.ActivePage = 'LITE Options')
end;

//-------------------------------------------------------------------------

Procedure TSetupTemplate1.RegistrationNotification (Const NotificationType : TNotificationType; Const Desc : ShortString);
Begin // RegistrationNotification
  Case NotificationType Of
    notRegistering : Begin
                       AddListMsg ('');
                       AddListMsg ('  Registering ' + Desc);
                     End;
    notTesting     : AddListMsg ('    Checking ' + Desc);
    notOK          : AddListMsg ('      OK');
    notFailed      : AddListMsg ('      Error');
  End; // Case NotificationType
End; // RegistrationNotification

//-------------------------------------------------------------------------
// Determine whether the Credit Card Add-in has been installed or not.
// As we are trying to register it, it's not in the Registry, so we'll just look
// for key files in the local directory.
function TSetupTemplate1.isCreditCardAddinInstalled : Boolean;
var
  appPath : string;
begin
  appPath := ExtractFilePath(Application.ExeName);
  // Check for the existence of 2 key files; the Add-in dll and the portal client dll.
  Result := (fileExists(appPath + 'ExchequerPaymentGateway.dll') and
             fileExists(appPath + 'Exchequer.Payments.Portal.COM.Client.dll'));
end;

//-------------------------------------------------------------------------
procedure TSetupTemplate1.FormShow(Sender: TObject);
begin
  inherited;
  // PKR. 20/04/2015. ABSEXCH-16308. Credit Card Add-in.
  // Post a message to ourself to trigger an event that occurs after the form has shown.
  // Uses PostMessage rather than SendMessage so that FormShow completes while the
  // message is being handled.
  PostMessage(Self.Handle, WM_AFTER_SHOW, 0, 0);
end;

//-------------------------------------------------------------------------
// PKR. 20/04/2015. ABSEXCH-16308. Credit Card Add-in.
// If we don't have the pre-requisites for the Credit Card add-in, we need to
//  prompt the user to install them.
procedure TSetupTemplate1.WmAfterShow(var Msg: TMessage);
var
  dlgRes : integer;
begin
  if creditCardAddinInstalled then
  begin
    // The Credit Card Addin is installed.
    if not minimumDotNetInstalled then
    begin
      // Don't have the required .NET Framework
      dlgRes := Application.MessageBox('The Credit Card Add-in requires .NET 4.5.1 or later.'#13#10#13#10 +
                           'Would you like to download and run the installer?', 'Download .NET 4.5.1', MB_YESNO);
      case dlgRes of
        mrYes:
          begin
            // Added try..finally for slightly more graceful handling of exceptions.
            try
              // Shell Execute the default browser to the download page. Successful return value is > 32
              ShellExecute(self.Handle, 'open', DOT_NET_4_5_1_DOWNLOAD_PAGE, nil, nil, SW_SHOWNORMAL);
            finally
              // Can't continue with the registration if we're going to do a .NET installation
              close;
            end;
          end;
        mrNo:
          // Do nothing
          begin
          end;
      end; // case dlgRes

      chkCreditCardAddin.Enabled := false;
      chkCreditCardAddin.Checked := false;
    end
  end
  else
  begin
    chkCreditCardAddin.Enabled := false;
    chkCreditCardAddin.Checked := false;
  end;
end;

//-------------------------------------------------------------------------

end.
