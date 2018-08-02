unit LoginF;

interface

{$IFNDEF IMPv6}
  {$IFNDEF OLE}     // this conditional define added to work with OLE Server
    {$IFNDEF OLEDATAQUERY}
      {$I DEFOVR.Inc}
    {$ENDIF OLEDATAQUERY}
  {$ENDIF OLE}
{$ENDIF IMPv6}   

//Define USETOOLKIT Directive for Scheduler and OleDataquery.
{$IFDEF OLEDATAQUERY}
  {$DEFINE USETOOLKIT}
{$ENDIF}
{$IFDEF SCHEDULER}
  {$DEFINE USETOOLKIT}
{$ENDIF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, TEditVal, Mask, antLabel, PasswordComplexityConst,
  {$IFDEF IMPV6} TPosterClass, {$ENDIF}
  { this coditional check is meant to avoid COM server registration error for apps which uses com toolkit object}
  {$IFNDEF SQLConversion}
    {$IFDEF USETOOLKIT}
      Enterprise01_TLB,
    {$ELSE}
      Enterprise04_TLB,
    {$ENDIF}
  {$ENDIF}
  COMObj, EnterToTab;



type
  TOLECloseEvent = function(Sender: TObject): Boolean of object;
  TfrmLogin = class(TForm)
    imgExchequer: TImage;
    txtUserName: Text8Pt;
    txtPassword: Text8Pt;
    btnCancel: TButton;
    btnLogin: TButton;
    lblUserName: TantLabel;
    lblForgottenPassword: TantLabel;
    cbbCompany: TComboBox;
    lblCapsLockWarning: TantLabel;
    lblCompany: TantLabel;
    lblLockedWarning: TantLabel;
    EnterToTab1: TEnterToTab;
    lblUserCount: Label8;
    lblPassword: TantLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure txtUserNameExit(Sender: TObject);
    procedure lblForgottenPasswordClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cbbCompanyChange(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FAuthenticationMode: String;
    FReLoginMode: Boolean;
    FUserID: String;
    FFailedAttempt: Byte;
    FLoginDialog: TLoginDialog;
    FOLECloseEvent: TOLECloseEvent;
    FCompanyDrive: String;
    FCompanyDataPath: TStringList;
    FLoggedInUserName: String;
    FLoggedInWinId: String;
    {$IFDEF IMPV6}
      FPoster: TPoster;
    {$ENDIF}

    {$IFDEF EBUS}
      FeBussCompanyPath: String;
      FTKOpen: Boolean;
      procedure InitEBussines;
    {$ENDIF}
    procedure EnableForgetPass;
    procedure CheckCapsLockStatus;
    procedure PopulateCompanyList;
    procedure InitLoginDlg;
    procedure DoBranding;
    procedure SetFocusUserEvent(Sender: TObject);
    {$IFDEF IMPV6}
      procedure StartupImporter;
      procedure SetPoster(const AValue: TPoster);
      {AP:01/10/2017 ABSEXCH-19378:Importer - When Running the Job: It gives error related to Invalid User Name or Password}
      procedure InitImportEvent(Sender: TObject);
    {$ENDIF}
    procedure UpdateUserInfoEvent(const AuthenticationMode, AUserID, AWinID: String);
  public
    { Public declarations }
    procedure InitDefaults;
    procedure SetReLogin(ALogin: String);
    procedure InitCompanyPath;
    property LoginDialog: TLoginDialog read FLoginDialog write FLoginDialog;
    property CompanyDrive: String read FCompanyDrive write FCompanyDrive;
    property OnOLECloseEvent: TOLECloseEvent read FOLECloseEvent write FOLECloseEvent;

	  {$IFDEF IMPV6}
      Class procedure Show;
      property Poster: TPoster read FPoster write SetPoster;
    {$ENDIF}
    {$IFDEF EBUS}
      property eBussCompanyPath: String read FeBussCompanyPath write FeBussCompanyPath;
    {$ENDIF}
    property LoggedInUserName: String read FLoggedInUserName write FLoggedInUserName;
    property LoggedInWinId: String read FLoggedInWinId write FLoggedInWinId;
  end;

{$IFDEF IMPv6}
  Var
    LoginOk: Boolean;
    LoginCompany: String;
    LoginPassword: String;
    LoginPath: String;
    frmLogin: TfrmLogin;
{$ENDIF}

{$IFDEF OLEDATAQUERY}
  Var
    CompNamePath : AnsiString;
    CompName     : AnsiString;
    AreaCode     : Integer;
    AreaCodeName : AnsiString;
    OK           : Boolean;
{$ENDIF}

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses ETStrU, Brand,
     {$IFDEF USETOOLKIT}
        AuthenticateUserTKUtil,
     {$ELSE}
        AuthenticateUserUtil, oSystemSetup, BtSupU2,
     {$ENDIF}
     {$IFDEF EBUS} VarFPosU, TKUtil, USEDLLU, {$ENDIF}
     {$IFDEF LTE} IAOReadO, {$ENDIF}
     {$IFDEF IMPv6} Utils, VAOUtil, EntLicence,{$ENDIF}
     WinAuthUtil, SQLUtils, ADOConnect;

{$R *.DFM}

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

procedure TfrmLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {$IFNDEF USETOOLKIT}
    GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
  {$ENDIF}
  CheckCapsLockStatus;
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  {$IFNDEF USETOOLKIT}
    GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
  {$ENDIF}
  CheckCapsLockStatus;
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.txtUserNameExit(Sender: TObject);
begin
  EnableForgetPass;
end;

//------------------------------------------------------------------------------
procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  FCompanyDrive := GetCompanyDrive;
  OnSetFocusUserEvent := SetFocusUserEvent;
  FCompanyDataPath := TStringList.Create;

  {MH 22/01/07: Moved IAO Branding code here so it applies to /NL: mode as well}
  {$IFDEF LTE}
    {$IFDEF DBD}
      InitBranding(FCompanyDrive); // Not Necessary at run time taken from Main Co direct not data set directory
    {$ENDIF}
    Caption := Branding.pbProductName + ' Login';
  {$ENDIF}

  //initialize variables
  FUserID := EmptyStr;
  FReLoginMode := False;
  EnableForgetPass;
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.FormDestroy(Sender: TObject);
begin
  {$IFDEF EBUS}
    if FTKOpen then
    begin
      FTKOpen := False;
      EX_CloseData;
    end;
  {$ENDIF}
  {$IFDEF IMPv6}
    FreeObjects([FPoster]);
  {$ENDIF}
end;

//------------------------------------------------------------------------------
// Init fileds to default values
procedure TfrmLogin.InitDefaults;
begin
  FFailedAttempt := 0;
  {$IFNDEF OLEDATAQUERY}
    PopulateCompanyList;
  {$ELSE}
    OK := True;
    cbbCompany.Style := csDropDown;
    cbbCompany.Clear;
    cbbCompany.Text := CompName;
    //Change the Company Path
    FCompanyDrive := CompNamePath;
    InitCompanyPath;
  {$ENDIF}

  InitLoginDlg;
  DoBranding; //please call the branding function after InitLoginDialog, do not push it upward
  CheckCapsLockStatus;

  {$IFDEF S2}
    if FAuthenticationMode = AuthMode_Exchequer then
    begin
      txtUserName.Text := GetWinUserOfFirstLogin;
      if txtUserName.Text <> '' then
        txtUserName.SelectAll;
    end;
  {$ENDIF}
end;

//------------------------------------------------------------------------------
//Forget Password Functionality
procedure TfrmLogin.lblForgottenPasswordClick(Sender: TObject);
begin
  DisplayForgottenPwrdDialog(Self, txtUsername.Text);
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.CheckCapsLockStatus;
begin
  lblCapsLockWarning.Visible := Odd(GetKeyState(VK_CAPITAL));
end;

//------------------------------------------------------------------------------
// Enables forgottenPassword label at different scenerios
procedure TfrmLogin.EnableForgetPass;
begin
  if lblForgottenPassword.Visible then
    lblForgottenPassword.Enabled := (txtUserName.Text <> EmptyStr);
  SetAuditUser(txtUserName.Text);
end;

//------------------------------------------------------------------------------
//If authenticated checks if the user has recently resetted their password
procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  lUserSuspended: Boolean;
begin
  {$IFDEF IMPv6}
    LoginOk := False;
  {$ENDIF}

  SetAuditUser(txtUserName.Text);

  lUserSuspended := False;
  Screen.Cursor := crHourGlass;
  try
    if FUserID <> Strip('B', [#32], txtUserName.Text) then
    begin
      FUserID := Strip('B', [#32], txtUserName.Text);
      {$IFNDEF OLEDATAQUERY}
        FFailedAttempt := 0;
      {$ELSE}
        FFailedAttempt := 3;
      {$ENDIF}
    end;
    if FUserID <> EmptyStr then
    begin
      {$IFNDEF OLEDATAQUERY}
        if ValidateUser(FUserID, txtPassword.Text, FFailedAttempt, FLoginDialog, lUserSuspended) then
      {$ELSE}
        if ValidateUser(FUserID, txtPassword.Text, FFailedAttempt, FLoginDialog, lUserSuspended, CompNamePath, AreaCodeName, AreaCode) then
      {$ENDIF}
          Self.ModalResult := mrOk
        else
        begin
          //HV 12/02/2018 2018R1 ABSEXCH-19748 : Getting error ‘Cannot focus a disabled or invisible window’ when using ‘Lock Exchequer’ functionality.
          if txtUserName.Enabled then
            ActiveControl := txtUserName
          else
            ActiveControl := txtPassword;
        end;

      if lUserSuspended then
        Self.ModalResult := mrCancel;
    end
    else
      MessageDlg(msgUsernameBlank, mtError, [mbOk], 0);

    {$IFDEF IMPv6}
      if (FLoginDialog = ldImporter) and LoginOk then
      begin
        if Assigned(Application.MainForm) then
          PostMessage(Application.MainForm.Handle, WM_COMPANYCHANGED, 0, 0);
        Self.ModalResult := mrOK;
      end;
    {$ENDIF}
  finally 
    Screen.Cursor := crDefault;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.PopulateCompanyList;
var
  i,
  lCurCompInd: Integer;
  lToolkit: IToolkit;
  lCompCode: String;
begin
  // Create COM Toolkit object
  try
    {$IFNDEF SQLConversion}
      {$IFDEF USETOOLKIT}
        lToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
      {$ELSE}
        lToolkit := CreateOLEObject('Enterprise04.Toolkit') as IToolkit;
      {$ENDIF}
    {$ENDIF}
  except
    ShowMessage('Unable to create COM Toolkit. Application will terminate');
    Application.Terminate;
  end;

  //HV 11/07/2018 2018R1.1 ABSEXCH-21002: Importer > Importing after Re-login to another company with same job gives access violation.
  lCompCode := GetCompanyCode(FCompanyDrive);
  lCurCompInd := 0;
  try
    if assigned(lToolkit) then
    begin
      with lToolkit.Company do
      begin
        cbbCompany.Clear;
        if cmCount > 0 then
        begin
          for i := 1 to cmCount do
          begin
            with cmCompany[i] do
            begin
              cbbCompany.Items.Add(format('%s - %s', [trim(coCode), trim(coName)]));
              FCompanyDataPath.Add(coPath);
              if AnsiCompareText(Trim(coCode), lCompCode) = 0 then
                lCurCompInd := i-1;
            end;
          end;
        end;
      end;

      if cbbCompany.Items.Count > 0 then
      begin
        cbbCompany.ItemIndex := lCurCompInd;
        cbbCompany.Hint := cbbCompany.text; // in case its too long to fit in the display
      end;
    end;
  finally
    lToolkit := nil;
  end;
  InitCompanyPath;
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FCompanyDataPath);
  {$IFDEF IMPv6}               
    frmLogin := nil;
  {$ENDIF}

  {$IFDEF OLEDATAQUERY}
    if not OK then
    begin
       // If the user has had three attempts of entering a password and has managed
      // to get it wrong three times then the user is sent back to the main screen.
      if FFailedAttempt > 0 Then
        Action := caFree; //caNone;
    end;
  {$ELSE}
    Action := caFree;
  {$ENDIF}
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.SetReLogin(ALogin: String);
begin
  btnCancel.Visible := False;
  txtUserName.Text := trim(ALogin);
  txtUserName.Enabled := False;
  txtUserName.Color := clBtnFace;
  FReLoginMode := True;
  btnLogin.Left := btnCancel.Left;
  lblForgottenPassword.Visible := False;
  lblLockedWarning.Visible := True;
  lblUserCount.Visible := False;
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.InitLoginDlg;
begin
  Self.OnKeyDown := FormKeyDown;
  Self.OnKeyPress := FormKeyPress;
  if LoginDialog <> ldExchequerCore then
  begin
    Self.BorderStyle := bsDialog;
    Self.ClientHeight :=  360;
    Self.ClientWidth := 500;
  end;
  lblUserCount.Visible := LoginDialog = ldExchequerCore;
  lblUserCount.Font.Color := RGB(221, 108, 30);

  if (FLoginDialog = ldOLEServer) then
    btnCancel.ModalResult := 0;

  {$IFDEF EBUS}
    if LoginDialog = ldeBusiness then
      InitEBussines;
  {$ENDIF}
  OnSetUserInfoEvent := UpdateUserInfoEvent;

  {$IFDEF IMPv6}
    if FLoginDialog = ldImporter then
    begin
      StartupImporter;
      FPoster := TPoster.Create;
      OnInitImportEvent := InitImportEvent;
    end;
  {$ENDIF}

  {$IFDEF LTE}
    Caption := Branding.pbProductName + ' Login';
  {$ELSE}
    Self.Caption := LoginDialogCaption[Ord(LoginDialog)];
  {$ENDIF}
  cbbCompany.Enabled := LoginDialogCompanyEnabled[Ord(LoginDialog)];
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  if (FLoginDialog = ldOLEServer) and Assigned(OnOLECloseEvent) then
  begin
    if OnOLECloseEvent(Self) then
      ModalResult := mrCancel;
  end;
  {$IFDEF OLEDATAQUERY}
    OK := False;    //SSK 12/10/2017 ABSEXCH-19304 : this line added to solve cancel button probelm
    ModalResult := mrCancel;
  {$ENDIF}
end;

//------------------------------------------------------------------------------
{$IFDEF EBUS}
procedure TfrmLogin.InitEBussines;
var
  lMainCoPath: String;
  lRes: Integer;
begin
  if Trim(FeBussCompanyPath) = '' then
    lMainCoPath := IncludeTrailingBackSlash(GetMultiCompDir)
  else
    lMainCoPath := FeBussCompanyPath;

  ExMainCoPath^ := '';
  lRes := SetToolkitPath(lMainCoPath);
  ShowTKError('Attempting to open main company '+#13+lMainCoPath,84,lRes);
  if lRes = 0 then
  begin
    lRes := EX_InitDLL;
    ShowTKError('Attempting to open DLL for '+#13+lMainCoPath,1,lRes);
  end;
  FTKOpen := lRes = 0;
end;
{$ENDIF}

//------------------------------------------------------------------------------
{$IFDEF IMPv6}
procedure TfrmLogin.StartupImporter;
begin
  LoginOk := False;
  InitBranding(FCompanyDrive);
  if EnterpriseLicence.IsLITE then
    Self.Caption := 'IRIS Accounts Office Importer Login';
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.SetPoster(const AValue: TPoster);
begin
  FPoster := AValue;
end;

//------------------------------------------------------------------------------

class procedure TfrmLogin.Show;
begin
  if not Assigned(frmLogin) then
    frmLogin := TfrmLogin.Create(nil);
  with frmLogin do
  begin
    LoginDialog := TLoginDialog(ldImporter);
    InitDefaults;
    ShowModal;
  end;
end;

//------------------------------------------------------------------------------

{AP:01/10/2017 ABSEXCH-19378:Importer - When Running the Job: It gives error related to Invalid User Name or Password}
procedure TfrmLogin.InitImportEvent(Sender: TObject);
begin
  LoginOk := True;
  LoginCompany  := cbbCompany.Text;
  {AP:01/10/2017 ABSEXCH-19378:Importer - When Running the Job: It gives error related to Invalid User Name or Password}
  LoginPassword := BlowFishEncrypt(Trim(txtPassword.Text));
  LoginPath     := FCompanyDataPath[cbbCompany.itemIndex];
end;

{$ENDIF}

//------------------------------------------------------------------------------

procedure TfrmLogin.DoBranding;
begin
  if XLogoEnabled then
  begin
    imgExchequer.Picture := nil;
    Self.Height := Self.Height - 80;
  end
  else
  begin
    if Branding.BrandingFileExists(ebfCommonLogin) then
    begin
      with Branding.BrandingFile(ebfCommonLogin) do
        ExtractImageCD(imgExchequer, 'CommonLogin');
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.SetFocusUserEvent(Sender: TObject);
begin
  txtPassword.Text := EmptyStr;
  if txtUserName.CanFocus then txtUserName.SetFocus;
  {$IFDEF OLEDATAQUERY}
    OK := False;
  {$ENDIF}
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.cbbCompanyChange(Sender: TObject);
begin
  InitCompanyPath;
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.InitCompanyPath;
var
  lDomainName,
  lWinUserID: string;
begin
  //Change the Company Path
  if Assigned(FCompanyDataPath) and (FCompanyDataPath.Count > 0) then
    FCompanyDrive := Trim(FCompanyDataPath[cbbCompany.itemIndex]);

  {$IFDEF IMPV6}
    VAOInfo.UseSubCompany := True;
    VAOInfo.vaoSubCompanyDir := FCompanyDrive;
  {$ELSE}
    {$IFNDEF USETOOLKIT}
      SetCurrCompPath(FCompanyDrive);
    {$ENDIF}
  {$ENDIF}

   //this will close the ADO Connection Object for SQL
  {$IFDEF EXSQL}
    if SQLUtils.UsingSQL Then
    begin
      if Assigned(GlobalAdoConnection) then
        ResetConnection(FCompanyDrive)
      else
        InitialiseGlobalADOConnection(FCompanyDrive);
    end;
  {$ENDIF}

  {$IFNDEF USETOOLKIT}
    SystemSetup.Refresh;
  {$ENDIF}

  {$IFNDEF OLEDATAQUERY}
    FAuthenticationMode := GetAuthenticationMode();
  {$ELSE}
    FAuthenticationMode := GetAuthenticationMode(FCompanyDrive);
  {$ENDIF}

  // Set Exchequer Version in Audit
  InitAuditInfo;

  txtPassword.Text := EmptyStr;
  txtUserName.Text := EmptyStr;
  if FAuthenticationMode = AuthMode_Windows then
  begin
    lDomainName := GetWindowDomainName;
    lWinUserID := GetWindowUserName;
    txtUserName.Text := lDomainName + '\' + lWinUserID;
    if txtPassword.Enabled then
      ActiveControl := txtPassword;
  end;
  lblForgottenPassword.Visible := LoginDialogForgottenPwdVisible[Ord(LoginDialog)] and (FAuthenticationMode = AuthMode_Exchequer);
end;

//------------------------------------------------------------------------------
//AP:14/11/2017 ABSEXCH-19445:All Common Login dialog boxes > Enter Valid Username & password > Hitting "Enter Key", lead User to login.
procedure TfrmLogin.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 13) then
  begin
    if (LoginDialog in [ldImporter, ldSentimail, ldScheduler]) and (ActiveControl = txtPassword)  then
      btnLoginClick(Sender)
    else if (ActiveControl = btnLogin) then
      btnLoginClick(Sender);
  end;
end;

procedure TfrmLogin.UpdateUserInfoEvent(const AuthenticationMode, AUserID,
  AWinID: String);
begin
  FLoggedInUserName := AUserID;
  FLoggedInWinId := AWinID;
end;

end.
