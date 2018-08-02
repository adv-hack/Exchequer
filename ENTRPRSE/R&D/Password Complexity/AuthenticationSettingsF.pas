unit AuthenticationSettingsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, oUserIntf,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, oSystemSetup, BtSupu2, VarConst, GlobVar,
  TEditVal;

type
  TfrmUserAuthenticationSettings = class(TForm)
    radExchequerAuthentication: TRadioButton;
    lblPleaseSelect: TLabel;
    radWindowsAuthentication: TRadioButton;
    lblusrsLog: TLabel;
    lblWinAuthentication: TLabel;
    btnSave: TButton;
    btnCancel: TButton;
    lblMinPwordLength: TLabel;
    udMinPwordLength: TUpDown;
    lbl0to30: TLabel;
    chkUppercase: TCheckBox;
    chkLowercase: TCheckBox;
    chkNumber: TCheckBox;
    chkSpecalCharacter: TCheckBox;
    chkSuspendOnLoginFailure: TCheckBox;
    lblExchqrPswrd: TLabel;
    bevel1: TBevel;
    bevel2: TBevel;
    udSuspendCount: TUpDown;
    lblFailedAttempts: TLabel;
    edtSuspendCount: TEdit;
    lblAutosuspendOption: TLabel;
    bevel3: TBevel;
    edtMinPwordLength: TCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure radExchequerAuthenticationClick(Sender: TObject);
    procedure radWindowsAuthenticationClick(Sender: TObject);
    procedure chkSuspendOnLoginFailureClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure ChkboxCustomOnClickEvent(Sender: TObject);
    procedure edtMinPwordLengthKeyPress(Sender: TObject; var Key: Char);
    procedure edtMinPwordLengthExit(Sender: TObject);
    procedure edtSuspendCountKeyPress(Sender: TObject; var Key: Char);
    procedure edtSuspendCountExit(Sender: TObject);
  private
    { Private declarations }
    FUserListIntf: IUserDetailList;
    FPasslength : Integer;

  	procedure PopulatePwdSettings;
    procedure SetControls;
    procedure StorePwdSettings;
    procedure ChangeMinPassLength;
    function ValidateWinAuthentication: boolean;
    function ValidateMinPasswordLength: boolean;
    procedure IsValid(var Key: Char);
    procedure Send_UpdateList;
  public
    { Public declarations }
    property UserListIntf: IUserDetailList write FUserListIntf;
  end;

implementation

uses
  PasswordComplexityConst, BTSupU1;

{$R *.dfm}

//------------------------------------------------------------------------------

procedure TfrmUserAuthenticationSettings.SetControls;
var
  lExchequerMode: Boolean;
begin
  lExchequerMode := radExchequerAuthentication.Checked;

  //When the authentication Mode is Exchequer
  edtMinPwordLength.Enabled := lExchequerMode;
  udMinPwordLength.Enabled := lExchequerMode;
  chkUppercase.Enabled := lExchequerMode;
  chkLowercase.Enabled := lExchequerMode;
  chkNumber.Enabled := lExchequerMode;
  chkSpecalCharacter.Enabled := lExchequerMode;
  lblExchqrPswrd.Enabled := lExchequerMode;
  lblMinPwordLength.enabled := lExchequerMode;
  lbl0to30.enabled := lExchequerMode;
  edtSuspendCount.enabled := chkSuspendOnLoginFailure.checked;
  udSuspendCount.enabled := chkSuspendOnLoginFailure.checked;

end;

//------------------------------------------------------------------------------

procedure TfrmUserAuthenticationSettings.FormCreate(Sender: TObject);
begin
  PopulatePwdSettings;
  SetControls;
end;

//------------------------------------------------------------------------------

procedure TfrmUserAuthenticationSettings.radExchequerAuthenticationClick(
  Sender: TObject);
begin
  SetControls;
end;

//------------------------------------------------------------------------------

procedure TfrmUserAuthenticationSettings.radWindowsAuthenticationClick(
  Sender: TObject);
begin
  SetControls;
end;

//------------------------------------------------------------------------------
//populates data in controls from the DB
procedure TfrmUserAuthenticationSettings.PopulatePwdSettings;
begin
  with SystemSetup(True) do // Refresh the SystemSetup settings
  begin
    if Trim(PasswordAuthentication.AuthenticationMode) = AuthMode_Exchequer then
      radExchequerAuthentication.Checked := True
    else
      radWindowsAuthentication.Checked := True;

    edtMinPwordLength.Value := PasswordAuthentication.MinimumPasswordLength;
    udMinPwordLength.Position := PasswordAuthentication.MinimumPasswordLength;
    chkUppercase.Checked := PasswordAuthentication.RequireUppercase;
    chkLowercase.Checked := PasswordAuthentication.RequireLowercase;
    chkNumber.Checked := PasswordAuthentication.RequireNumeric;
    chkSpecalCharacter.Checked := PasswordAuthentication.RequireSymbol;

    // Suspended
    chkSuspendOnLoginFailure.Checked := PasswordAuthentication.SuspendUsersAfterLoginFailures;
    edtSuspendCount.Text := IntToStr(PasswordAuthentication.SuspendUsersLoginFailureCount);
    udSuspendCount.Position := PasswordAuthentication.SuspendUsersLoginFailureCount;
  end;
end;

//------------------------------------------------------------------------------
//this will save password setting values into DB table
procedure TfrmUserAuthenticationSettings.StorePwdSettings;
var
  lAuthMode: String;
  lRes: Integer;

  //----------------------------------------------------------------------------
  procedure UpdateSystemSetupValue(var aRes: Integer;
                                   const aFieldIdx : TSystemSetupFieldIds;
                                   const aBeforeValue, aAfterValue: String;
                                   const aErrorDesc: String = '');
  begin
    if (aRes = 0) and (aBeforeValue <> aAfterValue) Then
    begin
      with SystemSetup(True) do
      aRes := UpdateValue(aFieldIdx, aBeforeValue, aAfterValue);
      if aRes = 2 then
        MessageDlg ('Error - another user has already changed the ' + aErrorDesc + ', please re-open the window and try again', mtError, [mbOK], 0)
      else if aRes > 0 then
        MessageDlg ('An error ' + IntToStr(aRes) + ' occurred updating the ' + aErrorDesc, mtWarning, [mbOK], 0);
    end;
  end;
  //----------------------------------------------------------------------------
  function BooleanToStr(aValue: Boolean) : string;
  begin
    Result := IntToStr(ord(aValue));
  end;
  //----------------------------------------------------------------------------

begin

  with SystemSetup(True) do
  begin
  	if radExchequerAuthentication.Checked then
  		lAuthMode := AuthMode_Exchequer
    else
  		lAuthMode := AuthMode_Windows;
    lRes := 0;

    with PasswordAuthentication do
    begin
      UpdateSystemSetupValue(lRes, siAuthenticationMode, AuthenticationMode, Trim(lAuthMode), '');
      if lAuthMode = AuthMode_Exchequer then
      begin
        UpdateSystemSetupValue(lRes, siAuthenticationMode, AuthenticationMode, Trim(lAuthMode), '');
        UpdateSystemSetupValue(lRes, siAuthenticationMode, AuthenticationMode, Trim(lAuthMode), '');
        UpdateSystemSetupValue(lRes, siMinimumPasswordLength, IntToStr(MinimumPasswordLength), Trim(edtMinPwordLength.Text), '');
        UpdateSystemSetupValue(lRes, siRequireUppercase, BooleanToStr(RequireUppercase), BooleanToStr(chkUppercase.Checked), '');
        UpdateSystemSetupValue(lRes, siRequireLowercase, BooleanToStr(RequireLowercase), BooleanToStr(chkLowercase.Checked), '');
        UpdateSystemSetupValue(lRes, siRequireNumeric, BooleanToStr(RequireNumeric), BooleanToStr(chkNumber.Checked), '');
        UpdateSystemSetupValue(lRes, siRequireSymbol, BooleanToStr(RequireSymbol), BooleanToStr(chkSpecalCharacter.Checked), '');
  		end;
      UpdateSystemSetupValue(lRes, siSuspendUsersAfterLoginFailures, BooleanToStr(SuspendUsersAfterLoginFailures), BooleanToStr(chkSuspendOnLoginFailure.Checked), '');
      if chkSuspendOnLoginFailure.checked then
          UpdateSystemSetupValue(lRes, siSuspendUsersLoginFailureCount, IntToStr(SuspendUsersLoginFailureCount), Trim(edtSuspendCount.Text), '');
	  end;
	end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserAuthenticationSettings.chkSuspendOnLoginFailureClick(
  Sender: TObject);
begin
  SetControls;
end;

//------------------------------------------------------------------------------

procedure TfrmUserAuthenticationSettings.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

//------------------------------------------------------------------------------

procedure TfrmUserAuthenticationSettings.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

//----------------------------------------------------------------------------
//Validation for Windows Authentication
function TfrmUserAuthenticationSettings.ValidateWinAuthentication: boolean;
var
  lFlgAdminUsrErr: boolean;
  lCurrentUser: string;
  lStrUserList: string;
  I: integer;
begin
  Result := True;
  lCurrentUser := EntryRec^.Login;
  lFlgAdminUsrErr := False;
  lStrUserList := EmptyStr;
  if Assigned(FUserListIntf) then
  for I := 0 To (FUserListIntf.Count - 1) Do
  begin
    if lCurrentUser = FUserListIntf[i].udUserName then
    begin
      lFlgAdminUsrErr := FUserListIntf[i].udWindowUserId = EmptyStr;
      Break;
    end;

    if (FUserListIntf[i].udWindowUserId = EmptyStr) and (lCurrentUser <> FUserListIntf[i].udUserName) then
      lStrUserList := FUserListIntf[i].udUserName + ', ' + lStrUserList;
  end;

  if lFlgAdminUsrErr then
  begin
    MessageDlg ('You do not have a Windows/Domain User ID set in you user profile so you will not be able to login to Exchequer. ' + #13 +
                'Please set a valid Windows User ID in your user profile before applying the Windows Authentication option.' , mtError, [mbOK], 0);

    Result := False;
  end
  else if lStrUserList <> EmptyStr then
  begin
    MessageDlg ('There are user profiles without Windows/Domain User ID set. These users will not be able to login next time. ' + #13 +
                'Please set a valid Windows User ID for those user profiles.', mtWarning, [mbOK], 0);
    Result := True;
  end;
end;

//------------------------------------------------------------------------------
//Validate minimum password length as per selected checkbox
function TfrmUserAuthenticationSettings.ValidateMinPasswordLength: boolean;
var
  lMinPwdLen: Byte;
begin
  Result := True;
  lMinPwdLen := 0;

  lMinPwdLen := lMinPwdLen + ord(chkUppercase.Checked);
  lMinPwdLen := lMinPwdLen + ord(chkLowercase.Checked);
  lMinPwdLen := lMinPwdLen + ord(chkNumber.Checked);
  lMinPwdLen := lMinPwdLen + ord(chkSpecalCharacter.Checked);

  if (edtMinPwordLength.Value < lMinPwdLen) then
  begin
    MessageDlg ('Minimum password length should be ' + inttostr(lMinPwdLen) + ' as per the selection.', mtError, [mbOK], 0);
    edtMinPwordLength.SetFocus;
    Result := false;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserAuthenticationSettings.btnSaveClick(Sender: TObject);
var
  lIsValidateOk: boolean;
begin
  if radExchequerAuthentication.Checked then      //Exchequer Auth
    lIsValidateOk := ValidateMinPasswordLength
  else                                            //Windows Auth
    lIsValidateOk := ValidateWinAuthentication;

  if lIsValidateOk then
  begin
    StorePwdSettings;
    Send_UpdateList;
    Close;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserAuthenticationSettings.btnCancelClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
// Sets Minimum pass length depending upon the number of criteria checkboxes checked
procedure TfrmUserAuthenticationSettings.ChangeMinPassLength;
begin
  FPasslength := 0;
  if(chkLowercase.Checked) then
    Inc(FPasslength);
  if(chkNumber.Checked) then
    Inc(FPasslength);
  if(chkSpecalCharacter.Checked) then
    inc(FPasslength);
  if(chkUppercase.Checked) then
    Inc(FPasslength);
  if (edtMinPwordLength.Value < FPasslength) then
    edtMinPwordLength.Value := FPasslength;
  udMinPwordLength.Min := FPasslength;
  lbl0to30.Caption := '('+ IntToStr(FPasslength) + ' - 30)'
end;

//------------------------------------------------------------------------------
procedure TfrmUserAuthenticationSettings.edtMinPwordLengthKeyPress(
  Sender: TObject; var Key: Char);
begin
  IsValid(key);
end;

//------------------------------------------------------------------------------
procedure TfrmUserAuthenticationSettings.edtMinPwordLengthExit(
  Sender: TObject);
begin
  if (edtMinPwordLength.Text <> '') then
  begin
    if (edtMinPwordLength.Value < FPasslength) or (edtMinPwordLength.Value > 30) then
    begin
      MessageDlg('Minimum Password length should be between '+ IntToStr(FPasslength) + ' and 30',mtWarning,[mbOk],0);
      edtMinPwordLength.Value := FPasslength;
      edtMinPwordLength.SetFocus;
    end;
  end;
end;

//------------------------------------------------------------------------------
// does not allow anything other then digits and backspace (#8)
procedure TfrmUserAuthenticationSettings.IsValid(var Key: Char);
begin
  if not (Key in [#8, '0'..'9'])  then
    Key := #0;
end;

//------------------------------------------------------------------------------
procedure TfrmUserAuthenticationSettings.edtSuspendCountKeyPress(
  Sender: TObject; var Key: Char);
begin
  IsValid(key);
end;

//------------------------------------------------------------------------------
procedure TfrmUserAuthenticationSettings.edtSuspendCountExit(
  Sender: TObject);
begin
  if chkSuspendOnLoginFailure.Checked then
  begin
    if edtSuspendCount.text <> '' then
    begin
      if ((StrToInt(edtSuspendCount.text) < 1) or (StrToInt(edtSuspendCount.Text) > 20)) then
      begin
        MessageDlg('Auto Suspend count should be between 1 and 20',mtWarning,[mbOk],0);
        edtSuspendCount.Text := '3';
      end;
    end;
    if edtSuspendCount.text = '' then
        edtSuspendCount.text := '3';
  end;
end;

//------------------------------------------------------------------------------
// One Event for all the checkboxes to calculate the minimum password length
procedure TfrmUserAuthenticationSettings.ChkboxCustomOnClickEvent(
  Sender: TObject);
begin
  changeMinPassLength;
end;

//------------------------------------------------------------------------------
// According to Exchequer authentication mode changePassword Menuitem is set visible
// in main form
procedure TfrmUserAuthenticationSettings.Send_UpdateList;
begin
  SendMessage(Application.MainForm.Handle, WM_FormCloseMsg, 101, 0);
end;
//------------------------------------------------------------------------------

end.
