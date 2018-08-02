unit DistRelF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, Mask, TEditVal, ExtCtrls,
  GlobVar, VarRec2U;

Const
  RelCodeVer = 'v1.09';

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    MenuOpt_File_Clear: TMenuItem;
    MenuOpt_File_Exit: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Label81: Label8;
    meCustESN: TMaskEdit;
    PageControl1: TPageControl;
    tabshPasswords: TTabSheet;
    Label83: Label8;
    lstEntVer: TComboBox;
    Bevel2: TBevel;
    Label84: Label8;
    edtPlugInPw: TEdit;
    edtMCMPW: TEdit;
    Label85: Label8;
    edtDailyPW: TEdit;
    Label86: Label8;
    Bevel1: TBevel;
    Panel1: TPanel;
    panDate: TPanel;
    panLicencee: TPanel;
    tabshEnterpriseSystem: TTabSheet;
    Label1: TLabel;
    edtEntSysSecCode: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtEntSysRelCode: TEdit;
    lstEntSysRelType: TComboBox;
    Label9: TLabel;
    edtResetUserCount: TEdit;
    lblESNVersion: Label8;
    Label82: Label8;
    lblPWExpiry: Label8;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuOpt_File_ExitClick(Sender: TObject);
    procedure MenuOpt_File_LogoutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DisplayPhoneticText(Sender: TObject);
    procedure MenuOpt_File_ClearClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure meCustESNExit(Sender: TObject);
    procedure lstEntVerClick(Sender: TObject);
    procedure UpdateRelCodes(Sender: TObject);
    procedure udEntUCCountClick(Sender: TObject; Button: TUDBtnType);
  private
    { Private declarations }
    FVersion : String[20];
    FUserESN : ISNArrayType;

    Function Calc_CheckSum(PModuleNo, PIChkSum  :  SmallInt)  :  SmallInt;
    Function Check_CheckSum(SecNo    : Str20;
                            ChkSum   : SmallInt;
                            ErrDesc  : ShortString;
                            ModuleNo : SmallInt = 0)  :  Boolean;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

Uses ContKey, LoginF, SecSup2U, Phonetic, ESNImpU, RSyncU, LicRec, LicFuncU,
  oDistLic, ETStrU, ETMiscU, ETDateU;

Var
  DummyESN : ISNArrayType;

//---------------------------------------------------------------------------

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title + ' ' + RelCodeVer;

  PageControl1.ActivePage := tabshEnterpriseSystem;

  // Setup footer fields
  panDate.Caption := '  ' + FormatDateTime ('dddd DD/MM/YYYY', Now);
  panLicencee.Caption := oLicence.dlLicencee + '  ';

  // Initialise all fields ready to begin
  FillChar (FUserESN, SizeOf(FUserESN), #0);
  MenuOpt_File_ClearClick(Sender);

  // Calculate release codes
  UpdateRelCodes(Self);
end;

//-----------------------------------

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If (Not frmLogin.Visible) Then
    frmLogin.Close;
end;

//---------------------------------------------------------------------------

procedure TfrmMain.MenuOpt_File_LogoutClick(Sender: TObject);
begin
  // Hide this form
  Self.Hide;

  // Re-Display login form
  frmLogin.Timer1.Tag := 2;
  frmLogin.Timer1Timer(Self);

  // Close this form
  PostMessage (Self.Handle, WM_CLOSE, 0, 0);
end;

//---------------------------------------------------------------------------

procedure TfrmMain.MenuOpt_File_ExitClick(Sender: TObject);
begin
  Close;
end;

//---------------------------------------------------------------------------

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

//---------------------------------------

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

//---------------------------------------------------------------------------

// Double-Click
procedure TfrmMain.DisplayPhoneticText(Sender: TObject);
Var
  ModDesc : ShortString;
begin
  If Sender Is TEdit Then
    With Sender As TEdit Do Begin
      Case Tag Of
        1    : ModDesc := 'Plug-In Password';
        2    : ModDesc := 'Multi-Company Manager Password';
        3    : ModDesc := 'Enterprise Daily System Password';
        4    : ModDesc := 'Reset Enterprise User Counts Password';
        5    : ModDesc := lstEntSysRelType.Text + ' Enterprise System Security Code';
        6    : ModDesc := lstEntSysRelType.Text + ' Enterprise System Release Code';
(*
        7    : ModDesc := lstEntUCType.Text + ' Enterprise User Count Security Code';
        8    : ModDesc := lstEntUCType.Text + ' Enterprise User Count Release Code';
*)
      Else
        Exit;
      End; { Case }

      // Display Msg with phonetic version of Release Code
      MessageDlg('The phonetic ' + ModDesc + ' is ' +
                 QuotedStr(StringToPhonetic (Text)),
                 mtInformation, [mbOK], 0);
    End; { With Sender As TEdit }
end;

//---------------------------------------------------------------------------

// Clears out all the fields ready for the next series
procedure TfrmMain.MenuOpt_File_ClearClick(Sender: TObject);
begin
  lstEntVer.ItemIndex := lstEntVer.items.Count - 1;
  lstEntVerClick(Sender);

  meCustESN.Text := '';
  lblESNVersion.Caption := '';
  FillChar (FUserESN, SizeOf(FUserESN), #0);

  // Passwords Tab

  // Enterprise Tab
  edtEntSysSecCode.Text := '';
  lstEntSysRelType.ItemIndex := 0;
  edtEntSysRelCode.Text := '';

(*
  edtEntUCSecCode.Text := '';
  //edtEntUCCount: TEdit;
  udEntUCCount.Position := 1;
  lstEntUCType.ItemIndex := 0;
  edtEntUCRelCode.Text := '';
*)
end;

//---------------------------------------------------------------------------

procedure TfrmMain.About1Click(Sender: TObject);
begin
   MessageDlg (Application.Title + ' ' + RelCodeVer + #13 +
               'Licence Expires ' + FormatDateTime ('DD/MM/YYYY', oLicence.dlLicenceExpiry) + #13#13 +
               frmLogin.lblCopyright.Caption,
               mtInformation, [mbOk], 0);
end;
//---------------------------------------------------------------------------

procedure TfrmMain.meCustESNExit(Sender: TObject);
Var
  LicESN   :  ESNByteArrayType;
  DemoFlag : Byte;
begin
  If ProcessESN7Str(LicESN,DemoFlag,meCustESN) Then Begin
    FUserESN:=ISNArrayType(LicESN);

    // Validate the DemoFlag byte
    If licDecodeDemoFlag (licESN, DemoFlag) Then
      lblESNVersion.Caption := '(' + licLicTypeToStr (DemoFlag, True) + ')'
    Else Begin
      // Byte7 is invalid
      lblESNVersion.Caption := 'Invalid v5.00 ESN';
      SysUtils.Beep;
    End; { Else }

    UpdateRelCodes(Sender);
  End; { If ProcessESN7Str (... }
end;

//---------------------------------------------------------------------------

Function TfrmMain.Check_CheckSum(SecNo    : Str20;
                                 ChkSum   : SmallInt;
                                 ErrDesc  : ShortString;
                                 ModuleNo : SmallInt = 0)  :  Boolean;

Var
  CSLen          : Byte;
  CS             : Integer;
  Secy           : LongInt;
  CSStr, SecyStr : Str20;
Begin
  CS:=ChkSum;
  CSStr:=Form_Int(CS,0);

  CSLen:=Length(CSStr);

  Secy := Calc_Security (SecNo, False);

  SecyStr:=Form_Int(Secy,0);

  Result:=(CS=IntStr(Copy(SecyStr,Length(SecyStr)-Pred(CSLen),CSLen))) or (CS=0);

  If (Not Result) Then
    ShowMessage('The ESN and ' + ErrDesc + ' Security Code do not match');
end;

//---------------------------------------------------------------------------

Function TfrmMain.Calc_CheckSum(PModuleNo, PIChkSum  :  SmallInt)  :  SmallInt;
Var
  CSESN  :  ISNArrayType;
Begin
  FillChar(CSESN,Sizeof(CSESN),0);

  { On older versions, if module release leave ESN out of calculation }
  If (((PModuleNo>=1) and (PModuleNo<=99)) or (PModuleNo=254)) and  (FVersion<ExNewVer) then
    FillChar(CSESN,Sizeof(CSESN),0)
  Else
    CSESN:=FUserESN;

  Result := Calc_ESN_CheckSum(CSESN,PModuleNo,PIChkSum);
end;

//---------------------------------------------------------------------------

procedure TfrmMain.UpdateRelCodes(Sender: TObject);
Var
  SecCode  : String[20];
  ModMode  : SmallInt;
begin
  // Passwords -----------------------------------------------------
  // Plug-In Password
  If (FVersion = '5.00') Then
    edtPlugInPw.Text := Generate_ESN_BaseSecurity(DummyESN,248,0,0)
  Else
    edtPlugInPw.Text := 'N/A';
  // Multi-Company Manager Password
  If (FVersion = '5.00') Then
    edtMCMPw.Text := Generate_ESN_BaseSecurity(DummyESN,245,0,0)
  Else
    edtMCMPw.Text := 'N/A';
  // Enterprise Daily System Password
  edtDailyPw.Text := Generate_ESN_BaseSecurity(DummyESN,251,0,0);
  // Reset User Count
  If (FVersion = '5.00') Then
    edtResetUserCount.Text := CalcRSysnc (2, Now, FUserESN[1], FUserESN[2], FUserESN[3], FUserESN[4], FUserESN[5], FUserESN[6])
  Else
    edtResetUserCount.Text := 'N/A';
  lblPWExpiry.Caption := POutDate(Calc_TodaySecurityLasts);

  // Enterprise System Security ------------------------------------
  edtEntSysRelCode.Text := '';
  If (Trim(edtEntSysSecCode.Text) <> '') Then
    // Security Code is set - validate and generate release code if OK
    If Check_CheckSum (edtEntSysSecCode.Text, Calc_CheckSum(0,0), 'System') Then Begin
      // Security Code matches ESN
      SecCode := edtEntSysSecCode.Text;

      // Check Security Code is AOK
      If (Calc_Security(SecCode,BOff) <> 0) Then
        // Calculate Release Code for ESN / SecCode
        edtEntSysRelCode.Text := Generate_ESN_BaseRelease(SecCode, 0, 0, (lstEntSysRelType.ItemIndex <> 1), FVersion);
    End; { If Check_CheckSum }

(***
  // Enterprise User Count Security --------------------------------
  edtEntUCRelCode.Text := '';
  If (Trim(edtEntUCSecCode.Text) <> '') And (udEntUCCount.Position > 0) Then Begin
    // Security Code is set - validate and generate release code if OK
    ModMode:=254-(7 * Ord(lstEntUCType.ItemIndex <> 1));
    If Check_CheckSum (edtEntUCSecCode.Text, Calc_CheckSum(ModMode,0), 'User Count', ModMode) Then Begin
      // Security Code matches ESN
      SecCode := edtEntUCSecCode.Text;

      // Check Security Code is AOK
      If (Calc_Security(SecCode,BOff) <> 0) Then
        edtEntUCRelCode.Text := Gen_UsrRelCode(SecCode, udEntUCCount.Position);
    End; { If Check_CheckSum }
  End; { If (Trim(edtEntUCSecCode.Text) <> '') }
***)
end;

//---------------------------------------------------------------------------

procedure TfrmMain.lstEntVerClick(Sender: TObject);
begin
  Case lstEntVer.ItemIndex Of
    // v4.00 or earlier
    0  : FVersion := '4.00';
    // v4.30
    1  : FVersion := '4.30';
    // v4.31 and v4.32
    2  : FVersion := '4.31';
    // v5.00 or later
    3  : FVersion := '5.00';
  Else
    Raise Exception.Create ('Invalid Release Code Version Selected');
  End; { Case }

  UpdateRelCodes(Sender);
end;

//---------------------------------------------------------------------------

procedure TfrmMain.udEntUCCountClick(Sender: TObject; Button: TUDBtnType);
begin
  UpdateRelCodes(Sender);
end;

//---------------------------------------------------------------------------

Initialization
  // Setup a dummy zero ESN for non-ESN based calls
  FillChar (DummyESN, SizeOf(DummyESN), #0);
end.
