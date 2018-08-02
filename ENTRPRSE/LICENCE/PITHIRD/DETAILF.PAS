unit DetailF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, TEditVal, ComCtrls, Buttons, ExtCtrls, Menus,
  LicRec;

const
  UtilVerNo = 'v5.00.004';

type
  TfrmDetail = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    MenuOpt_File_Exit: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Options1: TMenuItem;
    MenuOpt_Options_ShowCustDets: TMenuItem;
    panCustHdr: TPanel;
    Label82: Label8;
    Panel2: TPanel;
    Label2: TLabel;
    edtAcCode: TEdit;
    panCustDets: TPanel;
    Label87: Label8;
    Label88: Label8;
    Label89: Label8;
    Label816: Label8;
    Label817: Label8;
    edtAcAddr1: TEdit;
    edtAcPhone: TEdit;
    edtAcEmail: TEdit;
    edtAcContact: TEdit;
    edtComments: TEdit;
    panSecurity: TPanel;
    Label81: Label8;
    lblSystemType: Label8;
    lblSystemSecurity: Label8;
    lblSystemRelease: Label8;
    Label810: Label8;
    Label811: Label8;
    lblUserCountHdr: TLabel;
    lblUserCount: Label8;
    lblUserSecurity: Label8;
    lblUserRelease: Label8;
    Bevel1: TBevel;
    Label815: Label8;
    shSysSecHdr: TShape;
    shUserCountHdr: TShape;
    Panel1: TPanel;
    Label1: TLabel;
    udUserCount: TUpDown;
    lstPlugIns: TComboBox;
    btnGenSystemRelCode: TButton;
    lstSystemType: TComboBox;
    edtSystemSecurity: TEdit;
    edtSystemRelease: TEdit;
    edtCurrDate: TEdit;
    edtPlugInPW: TEdit;
    edtUserCount: TEdit;
    edtUserSecurity: TEdit;
    edtUserRelease: TEdit;
    meCustESN: TMaskEdit;
    edtAcAddr2: TEdit;
    edtAcAddr3: TEdit;
    edtAcAddr4: TEdit;
    edtAcAddr5: TEdit;
    edtAcName: TEdit;
    lblAcName: Label8;
    MenuOpt_File_Clear: TMenuItem;
    MenuOpt_File_SepBar1: TMenuItem;
    lblSysSecHdr: TLabel;
    btnGenUserRelCode: TButton;
    popPlugInConfig: TPopupMenu;
    Menu_Popup_System: TMenuItem;
    Menu_Popup_ShowUserCount: TMenuItem;
    MenuOpt_Options_ChangeUserPW: TMenuItem;
    MenuOpt_Options_ChangeMasterPW: TMenuItem;
    MenuOpt_Options_SepBar1: TMenuItem;
    MenuOpt_File_Logout: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MenuOpt_File_ExitClick(Sender: TObject);
    procedure MenuOpt_Options_ShowCustDetsClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure meCustESNExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure MenuOpt_File_ClearClick(Sender: TObject);
    procedure lstPlugInsClick(Sender: TObject);
    procedure DispPhoneticCode(Sender: TObject);
    procedure btnGenSystemRelCodeClick(Sender: TObject);
    procedure btnGenUserRelCodeClick(Sender: TObject);
    procedure lstSystemTypeClick(Sender: TObject);
    procedure edtUserSecurityChange(Sender: TObject);
    procedure edtPlugInPWDblClick(Sender: TObject);
    procedure Menu_Popup_SystemClick(Sender: TObject);
    procedure Menu_Popup_ShowUserCountClick(Sender: TObject);
    procedure MenuOpt_Options_ChangeUserPWClick(Sender: TObject);
    procedure MenuOpt_Options_ChangeMasterPWClick(Sender: TObject);
    procedure MenuOpt_File_LogoutClick(Sender: TObject);
  private
    { Private declarations }
    FESN   : ESNByteArrayType;
    FPISNo : LongInt;

    procedure ChangePW (Const PWType : Byte);
    Function Check_CheckSum(Const SecNo : ShortString; Const ChkSum, ModuleNo, RevOR : SmallInt) : Boolean;
    procedure RecalcRelCodes;
    procedure UpdateCSVExport(Const StatType : ShortString);
    procedure UpdateSalesStats(Const StatType : Byte; Const Adj : Longint);
  public
    { Public declarations }
  end;

var
  frmDetail : TfrmDetail;

implementation

{$R *.dfm}

Uses SplashF, ESNImpU, ContKey, VarRec2U, SecSup2U, Phonetic, LicfuncU,
     ETStrU, ETMiscU, AboutF, FileUtil, APIUtil, oConfig, PWordDlg;

//---------------------------------------------------------------------------

procedure TfrmDetail.FormCreate(Sender: TObject);
Var
  I : SmallInt;
begin
  // Update Caption with Version Number
  Caption := Caption + UtilVerNo;

  // Setup defaults and security options
  MenuOpt_Options_ShowCustDets.Checked := oConfiguration.cfgShowCustDets;
  MenuOpt_Options_ShowCustDets.Enabled := (LoginType = ltMaster);
  MenuOpt_Options_ChangeMasterPW.Enabled := (LoginType = ltMaster);
  MenuOpt_File_Logout.Visible := (oConfiguration.cfgUserPW <> '') Or (oConfiguration.cfgMasterPW <> '');

  // Disable popup menu for customising plug-in security for normal users
  Menu_Popup_System.Enabled := (LoginType = ltMaster);
  Menu_Popup_ShowUserCount.Enabled := (LoginType = ltMaster);

  If (LoginType <> ltMaster) Then Begin
    // Disable Full Release codes and User Counts > 1 for normal users
    lstSystemType.Items.Delete(1);
    udUserCount.Position := 1;
    udUserCount.Enabled := False;
    edtUserCount.Enabled := False;
  End; { If (LoginType <> ltMaster) }

  If (Not oLicence.Expired) Then Begin
    // Add Plug-Ins into Plug-In List
    lstPlugIns.Clear;
    If (oLicence.PlugInCount > 0) Then
      For I := 0 To Pred(oLicence.PlugInCount) Do
        With oLicence.PlugIn[I] Do
          // Check Plug-In Expiry Date - Don't add if its expired
          If (Not Expired) Then
            lstPlugIns.AddItem(piCode + ' - ' + piName, Pointer(piNumber));

    // Automatically select the first Plug-In
    If (lstPlugIns.Items.Count > 0) Then
      lstPlugIns.ItemIndex := 0;

    lstPlugInsClick(Self);
  End; { If (Not oLicence.Expired) }

  // Setup the preferred dialog configuration
  MenuOpt_Options_ShowCustDetsClick(Sender);

  // Initialise variables
  FillChar(FESN, SizeOf(FESN), #0);

  // Set the Plug-In Password
  edtCurrDate.Text := FormatDateTime ('DD/MM/YYYY', Now);
  edtPlugInPW.Text := Generate_ESN_BaseSecurity(ISNArrayType(FESN),248,0,0);
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If (Not frmSplash.Visible) Then
    frmSplash.Close;
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.MenuOpt_File_ExitClick(Sender: TObject);
begin
  Close;
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.MenuOpt_Options_ShowCustDetsClick(Sender: TObject);
begin
  panCustDets.Visible := MenuOpt_Options_ShowCustDets.Checked;
  lblAcName.Visible := panCustDets.Visible;
  edtAcName.Visible := panCustDets.Visible;

  Self.ClientHeight := panCustHdr.Height +
                       (panCustDets.Height * Ord(panCustDets.Visible)) +
                       panSecurity.Height;

  With oConfiguration Do Begin
    OpenConfigFile;

    If (cfgShowCustDets <> MenuOpt_Options_ShowCustDets.Checked) Then Begin
      cfgShowCustDets := MenuOpt_Options_ShowCustDets.Checked;
      SaveConfigFile;
    End; { If (cfgShowCustDets <> MenuOpt_Options_ShowCustDets.Checked) }
  End; { With oConfiguration }
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.About1Click(Sender: TObject);
begin
  With TfrmPlugInAbout.Create(Self) Do
    Try
      ShowModal
    Finally
      Free;
    End;
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.meCustESNExit(Sender: TObject);
Var
  DemoFlag   : Byte;
begin
  If ProcessESN7Str(FESN, DemoFlag, meCustESN) Then Begin

    // Update the Release Code stuff
    RecalcRelCodes;

    (*
    SecRelLic.ESN:=ISNArrayType(LicESN);

    // Validate the DemoFlag byte
    If licDecodeDemoFlag (licESN, DemoFlag) Then
      lblInstVer.Caption := '(' + licLicTypeToStr (DemoFlag, True) + ')'
    Else Begin
      // Byte7 is invalid
      lblInstVer.Caption := 'INVALID';
      SysUtils.Beep;
    End; { Else }
    *)
  End; { If ProcessESN7Str (... }
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.RecalcRelCodes;
Begin { RecalcRelCodes }
  If (lstPlugIns.ItemIndex >= 0) Then Begin

    // ?

  End { If (lstPlugIns.ItemIndex >= 0) }
  Else
    MessageDlg ('A Plug-In must be selected before release codes can be generated', mtError, [mbOk], 0);
End; { RecalcRelCodes }

//---------------------------------------------------------------------------

procedure TfrmDetail.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.MenuOpt_File_ClearClick(Sender: TObject);
begin
  // Clear all fields for new entry
  edtAcCode.Text := '';
  edtAcName.Text := '';
  edtAcContact.Text := '';

  edtAcAddr1.Text := '';
  edtAcAddr2.Text := '';
  edtAcAddr3.Text := '';
  edtAcAddr4.Text := '';
  edtAcAddr5.Text := '';
  edtAcPhone.Text := '';
  edtAcEmail.Text := '';
  edtComments.Text := '';

  meCustESN.Text := '';
  If (lstPlugIns.Items.Count > 0) Then lstPlugIns.ItemIndex := 0;

  lstPlugInsClick(Sender);
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.lstPlugInsClick(Sender: TObject);
begin
  // Reset fields below the Plug-In List
  edtSystemSecurity.Text := '';
  lstSystemType.ItemIndex := 0;
  edtSystemRelease.Text := '';

  edtUserSecurity.Text := '';
  udUserCount.Position := 1;
  edtUserRelease.Text := '';

  // Set the Plug-In Serial Number
  If (lstPlugIns.ItemIndex >= 0) Then
    FPISNo := PI_CheckSum(LongInt(lstPlugIns.Items.Objects[lstPlugIns.ItemIndex]))
  Else
    FPISNo := 0;

  // Refresh configuration details
  oConfiguration.OpenConfigFile;

  // Setup the popup configuration menu for this Plug-In
  If (lstPlugIns.ItemIndex >= 0) Then
    With oConfiguration.cfgPlugIns[Copy (lstPlugIns.Text, 1, 16)] Do Begin
      Menu_Popup_System.Tag := Ord (picUsesSystem);
      Menu_Popup_System.Checked := (Menu_Popup_System.Tag <> 0);
      Menu_Popup_SystemClick(Self);

      Menu_Popup_ShowUserCount.Tag := Ord (picUsesUserCount);
      Menu_Popup_ShowUserCount.Checked := (Menu_Popup_ShowUserCount.Tag <> 0);
      Menu_Popup_ShowUserCountClick(Sender);
    End; { With oConfiguration.cfgPlugIns... }
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.DispPhoneticCode(Sender: TObject);
Var
  CodeType : String[50];
begin
  If Sender Is TEdit Then
    With Sender As TEdit Do Begin
      // Determine Security/Release Type from Tag
      Case Tag Of
        1     : CodeType := 'System Security Code';
        2     : CodeType := 'System Release Code';
        1001  : CodeType := 'User Count Security Code';
        1002  : CodeType := 'User Count Release Code';
      End; { Case Tag }

      // Display Msg with phonetic version of Password
      MessageDlg('The phonetic ' + CodeType + ' for the ' + QuotedStr(lstPlugIns.Text) +
                 ' Plug-In is ' + QuotedStr(StringToPhonetic (Text)),
                 mtInformation, [mbOK], 0);
    End; { With Sender As Text8Pt }
end;

//---------------------------------------------------------------------------

// HM 04/03/02: Copied from SecRel
Function TfrmDetail.Check_CheckSum(Const SecNo : ShortString; Const ChkSum, ModuleNo, RevOR : SmallInt) : Boolean;
Var
  ModuleRelMode  : Boolean;
  CSLen          : Byte;
  CS             : Integer;
  Secy           : LongInt;
  CSStr, SecyStr : String[20];
Begin { Check_CheckSum }
  CS:=ChkSum;
  CSStr:=Form_Int(CS,0);

  CSLen:=Length(CSStr);

  ModuleRelMode:=(((ModuleNo>=1) and (ModuleNo<=99)) or ((ModuleNo>=1001) and (ModuleNo<=1099))) and (RevOR=0);

  Secy:=Calc_Security(SecNo,ModuleRelMode);

  SecyStr:=Form_Int(Secy,0);

  Result:=(CS=IntStr(Copy(SecyStr,Length(SecyStr)-Pred(CSLen),CSLen))) or (CS=0);
End; { Check_CheckSum }

//---------------------------------------------------------------------------

procedure TfrmDetail.btnGenSystemRelCodeClick(Sender: TObject);
Var
  RelCode  : LongInt;
  OK       : Boolean;
begin
  // Move focus to this button to cause any OnExit events to occur
  btnGenSystemRelCode.SetFocus;

  // Validate Details  -----------------------------------------------------
  OK := True;
  edtSystemRelease.Text := '';

  // Check ESN is set
  If (Not licESNSet(FESN)) Then
    OK := (MessageDlg('The ESN is not set, do you want to continue anyway?', mtConfirmation, [mbYes,mbNo], 0) = mrYes);

  // Check a Plug-In is selected
  If OK And (lstPlugIns.ItemIndex = -1) Then Begin
    OK := False;
    MessageDlg('A Plug-In must be selected before a Release Code can be generated', mtError, [mbOK], 0);
  End; { If OK And edtSystemSecurity ... }

  // Check System Security Code is set
  If OK And edtSystemSecurity.Visible And (Trim(edtSystemSecurity.Text) = '') Then Begin
    OK := False;
    MessageDlg('The System Security Code is not set', mtError, [mbOK], 0);
  End; { If OK And edtSystemSecurity ... }

  // Check ESN / SecCode CheckSums  -------------------------------------------------

  If OK And edtSystemSecurity.Visible Then Begin
    OK := Check_CheckSum(edtSystemSecurity.Text, Calc_ESN_CheckSum(ISNArrayType(FESN),252,FPISno), 252,0);
    If (Not OK) Then
      MessageDlg('The ESN, Plug-In Code and System Security Code do not match - please check them and try again', mtError, [mbOK], 0);
  End; { If OK And edtSystemSecurity.Visible }

  // Calculate Release Codes And Log Entries ----------------------------------------

  If OK And edtSystemSecurity.Visible Then Begin
    // Generate System Release Code
    RelCode := Calc_Security(edtSystemSecurity.Text, False);
    If (RelCode <> 0) then Begin
      // Generate System Release Code
      edtSystemRelease.Text := Generate_ESN_BaseRelease(edtSystemSecurity.Text, 252, FPISno, (lstSystemType.ItemIndex <> 1), ExNewVer);

      // Update internal stats & Add to CSV Log
      If (lstSystemType.ItemIndex = 0) Then Begin
        UpdateSalesStats (1, 1);
        UpdateCSVExport('30-Day');
      End { If (lstSystemType.ItemIndex = 0) }
      Else Begin
        UpdateSalesStats (2, 1);
        UpdateCSVExport('Full');
      End; { Else }
    End { If (RelCode <> 0)  }
    Else
      Beep;
  End; { If edtSystemSecurity.Visible  }
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.btnGenUserRelCodeClick(Sender: TObject);
Var
  RelCode  : LongInt;
  OK       : Boolean;
begin
  // Move focus to this button to cause any OnExit events to occur
  btnGenUserRelCode.SetFocus;

  // Validate Details  -----------------------------------------------------
  OK := True;
  edtUserRelease.Text := '';

  // Check ESN is set
  If (Not licESNSet(FESN)) Then
    OK := (MessageDlg('The ESN is not set, do you want to continue anyway?', mtConfirmation, [mbYes,mbNo], 0) = mrYes);

  // Check a Plug-In is selected
  If OK And (lstPlugIns.ItemIndex = -1) Then Begin
    OK := False;
    MessageDlg('A Plug-In must be selected before a Release Code can be generated', mtError, [mbOK], 0);
  End; { If OK And edtSystemSecurity ... }

  // Check User Count Security Code is set
  If OK And edtUserSecurity.Visible And (Trim(edtUserSecurity.Text) = '') Then Begin
    OK := False;
    MessageDlg('The User Count Security Code is not set', mtError, [mbOK], 0);
  End; { If OK And edtUserSecurity ... }

  // Check User Count is set
  If OK And edtUserCount.Visible And (udUserCount.Position <= 0) Then Begin
    OK := False;
    MessageDlg('The required User Count must be set correctly before a Release Code can be generated', mtError, [mbOK], 0);
  End; { If OK And edtSystemSecurity ... }

  // Check ESN / SecCode CheckSums  -------------------------------------------------

  If OK And edtUserSecurity.Visible Then Begin
    OK := Check_CheckSum(edtUserSecurity.Text, Calc_ESN_CheckSum(ISNArrayType(FESN),250, FPISno), 250, 0);
    If (Not OK) Then
      MessageDlg('The ESN, Plug-In Code and User Count Security Code do not match - please check them and try again', mtError, [mbOK], 0);
  End; { If OK And edtUserCount.Visible }

  // Calculate Release Codes And Log Entries ----------------------------------------

  If OK And edtUserSecurity.Visible Then Begin
    // Generate User Count Release Code
    RelCode := Calc_Security(edtUserSecurity.Text, False);
    If (RelCode <> 0) Then Begin
      // Generate User Count Release Code
      edtUserRelease.Text := Gen_UsrRelCode(edtUserSecurity.Text, udUserCount.Position);

      // Update internal stats
      UpdateSalesStats (3, udUserCount.Position);

      // Add to CSV Log
      UpdateCSVExport(IntToStr(udUserCount.Position) + ' User');
    End { If (RelCode <> 0)  }
    Else
      Beep;
  End; { If edtUserSecurity.Visible  }
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.lstSystemTypeClick(Sender: TObject);
begin
  edtSystemRelease.Text := '';
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.edtUserSecurityChange(Sender: TObject);
begin
  edtUserRelease.Text := '';
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.edtPlugInPWDblClick(Sender: TObject);
begin
  MessageDlg('The phonetic Plug-In Password for today is ' +
             QuotedStr(StringToPhonetic (edtPlugInPW.Text)), mtInformation, [mbOK], 0);

end;

//---------------------------------------------------------------------------

procedure TfrmDetail.UpdateSalesStats(Const StatType : Byte; Const Adj : Longint);
begin
  With oConfiguration Do Begin
    // Reload the configuration details to ensure they are up-to-date
    OpenConfigFile;

    With cfgPlugIns[Copy (lstPlugIns.Text, 1, 16)] Do
      Case StatType Of
        1 : picSystem30DayInst := picSystem30DayInst + 1;
        2 : picSystemFullInst := picSystemFullInst + 1;
        3 : Begin
              picUserCountInst := picUserCountInst + 1;
              picUserCountTotal := picUserCountTotal + Adj;
            End;
      End; { Case StatType  }

     // Update configuration file
     SaveConfigFile;
   End; { With oConfiguration }
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.UpdateCSVExport(Const StatType : ShortString);
Var
  CSVLine : ANSIString;
Begin { UpdateCSVExport }
  // Standard Output string
  CSVLine := '"' + FormatDateTime ('HH:MM:SS', Now) + '","' +           // Time + Date
                   FormatDateTime ('DD/MM/YYYY', Now) + '","' +         // Time + Date
                   WinGetUserName + '","' +                             // Windows User Name
                   WinGetComputerName + '","' +                         // Windows computer Name
                   Copy(lstPlugIns.Text, 1, 16) + '","' +               // Plug-In Code
                   StatType + '","' +                                   // Action being logged
                   meCustESN.Text + '","' +                             // Site ESN
                   edtAcCode.Text + '"';                                // Account Code

  If edtAcName.Visible Then
    CSVLine := CSVLine + ',"' + edtAcName.Text + '","' +                // Company Name
                                edtAcContact.Text + '","' +             // Contact Name
                                edtAcAddr1.Text + '","' +               // Address Line 1
                                edtAcAddr2.Text + '","' +               // Address Line 2
                                edtAcAddr3.Text + '","' +               // Address Line 3
                                edtAcAddr4.Text + '","' +               // Address Line 4
                                edtAcAddr5.Text + '","' +               // Address Line 5
                                edtAcPhone.Text + '","' +               // Phone Number
                                edtAcEmail.Text + '","' +               // Email Address
                                edtComments.Text + '"';                 // Optional Comments

  AddLineToFile(CSVLine, ChangeFileExt(Application.ExeName, '.CSV'));
End; { UpdateCSVExport }

//---------------------------------------------------------------------------

procedure TfrmDetail.Menu_Popup_SystemClick(Sender: TObject);
begin
  If (lstPlugIns.ItemIndex >= 0) Then Begin
    // Hide/Display fields as appropriate
    lblSysSecHdr.Visible := Menu_Popup_System.Checked;
    shSysSecHdr.Visible := Menu_Popup_System.Checked;
    lblSystemSecurity.Visible := Menu_Popup_System.Checked;
    edtSystemSecurity.Visible := Menu_Popup_System.Checked;
    lblSystemType.Visible := Menu_Popup_System.Checked;
    lstSystemType.Visible := Menu_Popup_System.Checked;
    btnGenSystemRelCode.Visible := Menu_Popup_System.Checked;
    lblSystemRelease.Visible := Menu_Popup_System.Checked;
    edtSystemRelease.Visible := Menu_Popup_System.Checked;

    If (Menu_Popup_System.Tag <> Ord(Menu_Popup_System.Checked)) Then Begin
      // Changed since last save - update configuration file
      oConfiguration.OpenConfigFile;
      oConfiguration.cfgPlugIns[Copy (lstPlugIns.Text, 1, 16)].picUsesSystem := Menu_Popup_System.Checked;
      oConfiguration.SaveConfigFile;

      // Record last saved state
      Menu_Popup_System.Tag := Ord(Menu_Popup_System.Checked);
    End; { If (Menu_Popup_System.Tag <> Ord(Menu_Popup_System.Checked)) }
  End; { If (lstPlugIns.ItemIndex >= 0) }
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.Menu_Popup_ShowUserCountClick(Sender: TObject);
begin
  If (lstPlugIns.ItemIndex >= 0) Then Begin
    // Hide/Display fields as appropriate
    lblUserCountHdr.Visible := Menu_Popup_ShowUserCount.Checked;
    shUserCountHdr.Visible := Menu_Popup_ShowUserCount.Checked;
    lblUserSecurity.Visible := Menu_Popup_ShowUserCount.Checked;
    edtUserSecurity.Visible := Menu_Popup_ShowUserCount.Checked;
    lblUserCount.Visible := Menu_Popup_ShowUserCount.Checked;
    edtUserCount.Visible := Menu_Popup_ShowUserCount.Checked;
    udUserCount.Visible := Menu_Popup_ShowUserCount.Checked;
    btnGenUserRelCode.Visible := Menu_Popup_ShowUserCount.Checked;
    edtUserRelease.Visible := Menu_Popup_ShowUserCount.Checked;
    lblUserRelease.Visible := Menu_Popup_ShowUserCount.Checked;

    If (Menu_Popup_ShowUserCount.Tag <> Ord(Menu_Popup_ShowUserCount.Checked)) Then Begin
      // Changed since last save - update configuration file
      oConfiguration.OpenConfigFile;
      oConfiguration.cfgPlugIns[Copy (lstPlugIns.Text, 1, 16)].picUsesUserCount := Menu_Popup_ShowUserCount.Checked;
      oConfiguration.SaveConfigFile;

      // Record last saved state
      Menu_Popup_ShowUserCount.Tag := Ord(Menu_Popup_ShowUserCount.Checked);
    End; { If (Menu_Popup_ShowUserCount.Tag <> Ord(Menu_Popup_ShowUserCount.Checked)) }
  End; { If (lstPlugIns.ItemIndex >= 0) }
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.ChangePW (Const PWType : Byte);
Var
  PasswordDialog          : TPasswordDialog;
  CurrPW, TmpPW, OtherPW  : ShortString;
  Res                     : LongInt;
  State                   : Byte;
  OK                      : Boolean;
Begin { ChangePW }
  Res := oConfiguration.OpenConfigFile(True);
  If (Res = 0) Then Begin
    Case PWType Of
      1 : Begin
            CurrPW := oConfiguration.cfgUserPW;
            OtherPW := oConfiguration.cfgMasterPW;
          End;
      2 : Begin
            CurrPW := oConfiguration.cfgMasterPW;
            OtherPW := oConfiguration.cfgUserPW;
          End;
    End; { Case PWType }

    PasswordDialog := TPasswordDialog.Create(Self);
    Try
      Ok := True;
      State := 1;

      Repeat
        Case State Of
          { Get Existing Password }
          1 : If (CurrPW <> '') Then Begin
                { Get Existing Password - check against LoggedPW }
                PasswordDialog.Title := 'Current Password';
                PasswordDialog.Msg := 'Enter the current password to continue';
                Ok := PasswordDialog.Execute;

                If Ok Then Begin
                  { Check got correct password }
                  If (PasswordDialog.PassWord = CurrPW) Then Begin
                    { Correct Password - move to next stage }
                    Inc (State);
                  End { If }
                  Else
                    { invalid password - stay on this stage }
                    MessageDlg ('The current password was entered incorrectly', mtWarning, [mbOk], 0)
                End; { If }
              End { If }
              Else
                // No password specified - move to new password entry
                Inc (State);

          { Get new password }
          2 : Begin
                PasswordDialog.Title := 'Enter New Password';
                PasswordDialog.Msg := 'Enter the new password';
                Ok := PasswordDialog.Execute;

                If Ok Then Begin
                  { Got a new password - check its not the same as the other password }
                  If (PasswordDialog.PassWord <> OtherPW) Or (PasswordDialog.PassWord = '') Then Begin
                    TmpPW := PasswordDialog.PassWord;
                    Inc (State);
                  End { If }
                  Else
                    { Password already in use }
                    MessageDlg ('Invalid Password - please try another', mtWarning, [mbOk], 0);
                End { If }
                Else
                  { Dialog Cancelled }
                  MessageDlg ('Password not changed', mtInformation, [mbOk], 0);
              End;

          { get new passwaord again }
          3 : Begin
                PasswordDialog.Title := 'Confirm Password';
                PasswordDialog.Msg := 'Re-enter the new password';
                Ok := PasswordDialog.Execute;

                If OK Then Begin
                  If (PasswordDialog.PassWord = TmpPW) Then Begin
                    { Password was retyped correctly }

                    { Set new password }
                    Res := oConfiguration.OpenConfigFile(True);
                    If (Res = 0) Then Begin
                      // Copy update password back into configuration and update it
                      Case PWType Of
                        1 : oConfiguration.cfgUserPW := TmpPW;
                        2 : oConfiguration.cfgMasterPW := TmpPW;
                      End; { Case PWType }

                      oConfiguration.SaveConfigFile(True);
                      Inc (State);

                      If (LoginType = ltMaster) and (PWType = 1) And (oConfiguration.cfgMasterPW = '') Then
                        MessageDlg ('Don''t forget to set the Master Password as well as the user password', mtWarning, [mbOk], 0);
                    End; { If (Res = 0) }
                  End { If }
                  Else Begin
                    { Password was NOT retyped correctly }
                    State := 2;
                    MessageDlg ('The new password was not re-entered correctly', mtWarning, [mbOk], 0);
                  End; { Else }
                End; { If }
              End;
        End; { Case }
      Until (Not OK) Or (State = 4);

      MenuOpt_File_Logout.Visible := (oConfiguration.cfgUserPW <> '') Or (oConfiguration.cfgMasterPW <> '');
    Finally
      FreeAndNIL(PasswordDialog);
    End;
  End { If (oConfiguration.OpenConfigFile = 0) }
  Else
    MessageDlg ('Error ' + IntToStr(Res) + ' refreshing the configuration settings', mtError, [mbOk], 0);
End; { ChangePW }

procedure TfrmDetail.MenuOpt_Options_ChangeUserPWClick(Sender: TObject);
begin
  ChangePW (1);
end;

procedure TfrmDetail.MenuOpt_Options_ChangeMasterPWClick(Sender: TObject);
begin
  ChangePW (2);
end;

//---------------------------------------------------------------------------

procedure TfrmDetail.MenuOpt_File_LogoutClick(Sender: TObject);
begin
  // Hide this form
  Self.Hide;

  // Re-Display login form
  frmSplash.Timer1.Tag := 2;
  frmSplash.Timer1Timer(Self);

  // Close this form
  PostMessage (Self.Handle, WM_CLOSE, 0, 0);
end;

//---------------------------------------------------------------------------

end.
