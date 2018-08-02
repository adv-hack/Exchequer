unit ChangePasswordF;

interface

//{$I DEFOVR.Inc}
//Hitesh
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, oSystemSetup, Strutil, VarConst, oUserIntf,
  oUserList, EnterToTab, BtSupu2, VarRec2U;

type
  TfrmChangePassword = class(TForm)
    ilTickUntick: TImageList;
    pnlPassReq: TPanel;
    shpPassReq: TShape;
    lblPassReq: TLabel;
    lblMiniPassLength: TLabel;
    lblUppercase: TLabel;
    lblLowercase: TLabel;
    lblNumber: TLabel;
    lblSpecialChar: TLabel;
    imgMinPassLength: TImage;
    imgUpperCase: TImage;
    imgLowerCase: TImage;
    imgNumber: TImage;
    imgSpecialChar: TImage;
    pnlBottom: TPanel;
    lblNewPass: TLabel;
    lblConfirmPass: TLabel;
    lblPassMatch: TLabel;
    edtNewPass: TEdit;
    edtConfirmPass: TEdit;
    btnSave: TButton;
    pnlOldPass: TPanel;
    lblOldPass: TLabel;
    edtOldPass: TEdit;
    btnCancel: TButton;
    EnterToTab1: TEnterToTab;
    imgInfo: TImage;
    procedure FormCreate(Sender: TObject);
    procedure edtNewPassExit(Sender: TObject);
    procedure edtConfirmPassExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtNewPassChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure imgInfoClick(Sender: TObject);
  private
    { Private declarations }
    FPassLength: Integer;
    FIsUpperChecked: Boolean;
    FIsLowerChecked: Boolean;
    FIsSpCharChecked: Boolean;
    FIsNumberChecked: Boolean;
    FUserDetailsIntf: IUserDetails;
    FNewUser: Boolean;
    procedure ClearImages;
    procedure SetControls;
    procedure ValidateNewPassword;
    function IsCurrentUser: Boolean;
    function StorePassword: Integer;
    procedure RearrangeControls;
    procedure SetFormSize;
  public
    { Public declarations }
  end;

function DisplayChangePasswordDlg(AOwner: TComponent;
                                   var AUserDetailsIntf: IUserDetails;
                                   ANewUser: Boolean = False): Integer;

implementation
{$R *.dfm}

uses
  SHA3HashUtil, PasswordComplexityConst;

function DisplayChangePasswordDlg(AOwner: TComponent;
                                  var AUserDetailsIntf: IUserDetails;
                                  ANewUser: Boolean = False): Integer;
var
  lChangePassword: TfrmChangePassword;
begin
  Result:= -1;
  lChangePassword := TfrmChangePassword.Create(AOwner);
  try
    with lChangePassword do
    begin
      FNewUser := ANewUser;
      FUserDetailsIntf := AUserDetailsIntf;
      if ShowModal = mrOk then
        Result:= StorePassword
    end;
  finally
    if Assigned(lChangePassword) then
      Freeandnil(lChangePassword);
  end;
end;

procedure TfrmChangePassword.FormCreate(Sender: TObject);
begin
  ilTickUntick.GetBitmap(0, imgSpecialChar.Picture.Bitmap);
  ilTickUntick.GetBitmap(0, imgMinPassLength.Picture.Bitmap);
  ilTickUntick.GetBitmap(0, imgLowerCase.Picture.Bitmap);
  ilTickUntick.GetBitmap(0, imgNumber.Picture.Bitmap);
  ilTickUntick.GetBitmap(0, imgUpperCase.Picture.Bitmap);

  //Enabling and disabling Components which gets enabled later.
  with SystemSetup(True) do
  begin
    FPassLength := PasswordAuthentication.MinimumPasswordLength;
    FisUpperChecked := PasswordAuthentication.RequireUppercase;
    FIsLowerChecked := PasswordAuthentication.RequireLowercase;
    FisSpCharChecked := PasswordAuthentication.RequireSymbol;
    FisNumberChecked := PasswordAuthentication.RequireNumeric;
  end;
end;

//Set Visibility of control depending upon which user is been selected in the ListView
//------------------------------------------------------------------------------
procedure TfrmChangePassword.SetControls;
begin
  if FUserDetailsIntf.udMode In [umInsert, umCopy] then
    Self.Caption := 'Set New Password for '+ FUserDetailsIntf.udUserName
  else
    Self.Caption := 'Change Password for '+ FUserDetailsIntf.udUserName;

  lblMiniPassLength.Caption := 'Minimum Length - ' + IntToStr(FPassLength) + ' characters';

  lblUppercase.Visible := FisUpperChecked;
  imgUpperCase.Visible := FisUpperChecked;
  lblLowercase.Visible := FisLowerChecked;
  imgLowerCase.Visible := FisLowerChecked;
  lblNumber.Visible := FisNumberChecked;
  imgNumber.Visible := FisNumberChecked;
  lblSpecialChar.Visible := FisSpCharChecked;
  imgSpecialChar.Visible := FisSpCharChecked;
  imgInfo.Visible := FisSpCharChecked;
  lblSpecialChar.Hint := msgSpecialCharHint;

  lblPassMatch.Visible := False;
  edtNewPass.MaxLength := 50;

  if IsCurrentUser then
  begin
    pnlOldPass.Visible := True;
    edtOldPass.SetFocus;
  end
  else
  begin
    pnlOldPass.Visible := False;
    Self.ClientHeight := 205;
    edtNewPass.SetFocus;
  end;
  btnSave.Enabled := False;
  //SSK 26/03/2018 2018-R1 ABSEXCH-20287://if min password length is <> 0
  if (FPassLength <> 0) then
    edtConfirmPass.Enabled := False
  else
    edtConfirmPass.Enabled := True;
  ClearImages;
end;

//Confirms if the Password meets the defined criteria
//------------------------------------------------------------------------------
procedure TfrmChangePassword.edtNewPassExit(Sender: TObject);
begin
  lblPassMatch.Visible := (edtConfirmPass.Text <> EmptyStr) and (not btnSave.Enabled);
  //SSK 22/03/2018 2018-R1 ABSEXCH-20287: for min. password length 0 call ValidateNewPassword
  if (Self.ActiveControl <> btnCancel) then
  begin
    if (FPassLength = 0) and (edtNewPass.Text = EmptyStr) then
    begin
      ValidateNewPassword;
      if edtConfirmPass.canFocus then edtConfirmPass.SetFocus;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmChangePassword.edtConfirmPassExit(Sender: TObject);
begin
  // Save Button Enable while New and Old Password match
  btnSave.Enabled := (AnsiCompareStr(edtNewPass.Text, edtConfirmPass.Text)=0);
  if btnSave.Enabled then btnSave.SetFocus;
  lblPassMatch.Visible := (edtConfirmPass.Text <> EmptyStr) and (not btnSave.Enabled);
end;

//Checks if the user who is selected on the listView is the current logged in user
//------------------------------------------------------------------------------
function TfrmChangePassword.IsCurrentUser: Boolean;
begin
  if Assigned(EntryRec) then
    Result := Trim(FUserDetailsIntf.udUserName) = Trim(EntryRec^.Login)
  else
    Result := True;
end;

//------------------------------------------------------------------------------
procedure TfrmChangePassword.FormShow(Sender: TObject);
begin
  SetControls;
  RearrangeControls;
  SetFormSize;
end;

//------------------------------------------------------------------------------
procedure TfrmChangePassword.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

//------------------------------------------------------------------------------
procedure TfrmChangePassword.edtNewPassChange(Sender: TObject);
begin                 
  edtConfirmPass.Text := EmptyStr;
  edtConfirmPass.Enabled := False;
  lblPassMatch.Visible := False;
  ClearImages;
  ValidateNewPassword;
end;

//Clear all the bitmaps to assign new ones
//------------------------------------------------------------------------------
procedure TfrmChangePassword.ClearImages;
begin
  imgMinPassLength.Picture.Graphic := nil;
  imgUpperCase.Picture.Graphic := nil;
  imgLowerCase.Picture.Graphic := nil;
  imgNumber.Picture.Graphic := nil;
  imgSpecialChar.Picture.Graphic := nil;
end;

//------------------------------------------------------------------------------

function TfrmChangePassword.StorePassword: Integer;
var
  lRes: Integer;
begin
  lRes := 1;
  try
    if Assigned(FUserDetailsIntf) then
    begin
      if (AnsiCompareStr(edtNewPass.Text, edtConfirmPass.Text) = 0) then
      begin
        FUserDetailsIntf.udPwdHash := edtNewPass.Text;
        FUserDetailsIntf.udForcePwdChange := False;
        lRes := 0;
        if not FNewUser then
        begin
          lRes := FUserDetailsIntf.ResetPassword(False, True);
          if lRes <> 0 then
            MessageDlg(FUserDetailsIntf.ResetPasswordErrorDescription(lRes), mtError, [mbOk], 0);
        end;
      end;
    end;
  finally
    Result := lRes;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmChangePassword.ValidateNewPassword;
var
  lNewPassString: String;
  lValidLength,
  lValidUpper,
  lValidLower,
  lValidNumber,
  lValidSpecialChar,
  lEnabled: Boolean;
  i: Integer;
begin
  lNewPassString := edtNewPass.text;
  lEnabled := True;
  lValidUpper := False;
  lValidLower := False;
  lValidNumber := False;
  lValidSpecialChar := False;

  lValidLength := Length(lNewPassString) >= FPassLength;
  ilTickUntick.GetBitmap(Ord(lValidLength), imgMinPassLength.Picture.Bitmap);  
  if lNewPassString <> EmptyStr then
  begin
    i := Length(lNewPassString);
    while (i > 0) do
    begin
      if (not lValidUpper) and FisUpperChecked then
        lValidUpper :=  IsCharUpper(lNewPassString[i]) and (Pos(lNewPassString[i], cUpper) > 0);
      if (not lValidLower) and FisLowerChecked then
        lValidLower :=  IsCharLower(lNewPassString[i]) and (Pos(lNewPassString[i], cLower) > 0);
      if (not lValidNumber) and FisNumberChecked then
        lValidNumber := Pos(lNewPassString[i], cNumber) > 0;
      if (not lValidSpecialChar) and FisSpCharChecked then
        lValidSpecialChar := Pos(lNewPassString[i], cSpecialChar) > 0;
      Dec(i);
    end;

    ilTickUntick.GetBitmap(Ord(lValidUpper and FisUpperChecked), imgUpperCase.Picture.Bitmap);
    ilTickUntick.GetBitmap(Ord(lValidLower and FisLowerChecked), imgLowerCase.Picture.Bitmap);
    ilTickUntick.GetBitmap(Ord(lValidNumber and FisNumberChecked), imgNumber.Picture.Bitmap);
    ilTickUntick.GetBitmap(Ord(lValidSpecialChar and FisSpCharChecked),imgSpecialChar.Picture.Bitmap);

    if FisUpperChecked then
      lEnabled := lValidUpper;
    if FisLowerChecked then
      lEnabled := lEnabled and lValidLower;
    if FisNumberChecked then
      lEnabled := lEnabled and lValidNumber;
    if FisSpCharChecked then
      lEnabled := lEnabled and lValidSpecialChar;
  end
  else
  begin
    ilTickUntick.GetBitmap(0,imgSpecialChar.Picture.Bitmap);
    ilTickUntick.GetBitmap(0,imgLowerCase.Picture.Bitmap);
    ilTickUntick.GetBitmap(0,imgNumber.Picture.Bitmap);
    ilTickUntick.GetBitmap(0,imgUpperCase.Picture.Bitmap);
  end;
  // Save Button Enable while New and Old Password match
  edtConfirmPass.Enabled := lEnabled and lValidLength;
  btnSave.Enabled := (AnsiCompareStr(edtNewPass.Text, edtConfirmPass.Text) = 0) and lValidLength;
end;

procedure TfrmChangePassword.btnSaveClick(Sender: TObject);
var
  lOldPassStr: String;
begin
  if Assigned(FUserDetailsIntf) then
  begin
    //Get OldPassword HASH
    lOldPassStr := StrToSHA3Hase(FUserDetailsIntf.udPwdSalt + Trim(edtoldPass.Text)); //Hash the old password value

    if IsCurrentUser and (lOldPassStr <> FUserDetailsIntf.udPwdHash) then
    begin
      ModalResult := mrNone;
      MessageDlg ('Invalid Old Password entered' , mtError, [mbOK], 0);
      edtOldPass.Text := EmptyStr;
      if edtOldPass.CanFocus then edtOldPass.SetFocus;
    end;
  end;
end;
//------------------------------------------------------------------------------
procedure TfrmChangePassword.RearrangeControls;
var
  lIsRow1Visible,
  lIsRow2Visible: Boolean;
  lCtr: Integer;

  procedure MoveCtrl(src, des: TControl);
  begin
     src.Left := des.Left;
     src.Top := des.Top;
  end;
begin
  lIsRow1Visible := True;
  lIsRow2Visible := True;
  lCtr := 0;

  //1st Row
  if not FIsUpperChecked then
  begin
    if FIsNumberChecked then
    begin
      //shift 1 Number
      MoveCtrl (lblnumber, lblUppercase);
      MoveCtrl (imgNumber, imgUpperCase);
    end else
      lisRow1Visible := False;
  end;

  //2nd Row
  if not FisLowerChecked then
  begin
    if FisSpCharChecked then
    begin
      //Move Special Character
      MoveCtrl(lblSpecialChar, lblLowercase);
      MoveCtrl(imgSpecialChar, imgLowerCase);
      imgInfo.Left := lblSpecialChar.Width + lblSpecialChar.Left + 1;
      imgInfo.Top := imgSpecialChar.Top;
    end
    else
      lIsRow2Visible := False;
  end;
  if not lIsRow1Visible then
  begin
    //Move 2nd row up
    if FisLowerChecked then
    begin
      MoveCtrl(lblLowercase, lblUppercase);
      MoveCtrl(imgLowerCase, imgUpperCase);
      MoveCtrl(lblSpecialChar, lblNumber);
      MoveCtrl(imgSpecialChar, imgNumber);
      imgInfo.Left := lblSpecialChar.Width + lblSpecialChar.Left + 1;
      imgInfo.Top := imgSpecialChar.Top;
    end
    else
    begin
      MoveCtrl(lblSpecialChar, lblUppercase);
      MoveCtrl(imgSpecialChar, imgUpperCase);
      imgInfo.Left := lblSpecialChar.Width + lblSpecialChar.Left + 1;
      imgInfo.Top := imgSpecialChar.Top;
    end;
  end;

  if lIsRow1Visible then inc(lCtr);
  if lIsRow2Visible then inc(lCtr);

  if lCtr = 0 then
    shpPassReq.Height := 52
  else if lCtr = 1 then
    shpPassReq.Height := 70
  else if lCtr = 2 then
    shpPassReq.Height := 90;

  pnlPassReq.Height := shpPassReq.Height + 15;
end;
//------------------------------------------------------------------------------
procedure TfrmChangePassword.SetFormSize;
var
  lHgt, I: Integer;
  ACtrl: TControl;
begin
  lHgt := 0;
  for I := 0 to ControlCount-1  do
  begin
    if Controls[I] is TPanel then
    begin
      if TPanel(Controls[I]).Visible then
        lHgt := lHgt + Controls[I].Height;
    end;
  end;
  ClientHeight := lHgt;
end;

procedure TfrmChangePassword.imgInfoClick(Sender: TObject);
begin
  MessageDlg(msgSpecialChar, mtInformation, [mbOk], 0);
end;

end.
