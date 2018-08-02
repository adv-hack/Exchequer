unit UsersListF;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, GlobVar, VarConst, oPPDLedgerTransactions,
  ExtCtrls, StrUtils, CommCtrl, EnterToTab, BTSupU1, Tranl1U, oUserList, RPDevice, 
  EntWindowSettings, Menus, ExBtth1u, ActnList, ImgList, oUserIntf, PasswordComplexityConst;

type
  TfrmUserManagement = class(TForm)
    lvUsers: TListView;
    btnAddUser: TButton;
    btnClose: TButton;
    btnEditUser: TButton;
    btnDeleteUser: TButton;
    EnterToTab1: TEnterToTab;
    PopupMenu1: TPopupMenu;
    mnuAdd: TMenuItem;
    mnuResetCustom: TMenuItem;
    mnuPrintSettings: TMenuItem;
    N2: TMenuItem;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    N3: TMenuItem;
    alMain: TActionList;
    btnCopyUser: TButton;
    btnResetCustom: TButton;
    btnPrintSettings: TButton;
    btnResetPassword: TButton;
    btnImportUsers: TButton;
    btnConfiguration: TButton;
    btnChangePassword: TButton;
    mnuEdit: TMenuItem;
    mnuDelete: TMenuItem;
    mnuCopy: TMenuItem;
    N4: TMenuItem;
    mnuChangePassword: TMenuItem;
    mnuResetPassword: TMenuItem;
    mnuImportUsers: TMenuItem;
    mnuConfiguration: TMenuItem;
    N5: TMenuItem;
    actAdd: TAction;
    actEdit: TAction;
    actCopy: TAction;
    actDelete: TAction;
    actResetCustom: TAction;
    actPrintSettings: TAction;
    actChangePassword: TAction;
    actResetPassword: TAction;
    actImportUsers: TAction;
    actConfiguration: TAction;
    actClose: TAction;
    actProperties: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    // Method to Save properties
    procedure lvUsersSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvUsersCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure actCloseExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actResetCustomExecute(Sender: TObject);
    procedure actPrintSettingsExecute(Sender: TObject);
    procedure actChangePasswordExecute(Sender: TObject);
    procedure actResetPasswordExecute(Sender: TObject);
    procedure actImportUsersExecute(Sender: TObject);
    procedure actConfigurationExecute(Sender: TObject);
    procedure actPropertiesExecute(Sender: TObject);
    procedure lvUsersDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FUserListIntf: IUserDetailList;
    FSettings: IWindowSettings;
    FDeleteAction: Boolean;
    FSelectedIndex: Integer;
    procedure LoadList;
    procedure WMGetMinMaxInfo(var message: TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMRefresh(var message: TMessage); message WM_REFRESH;
    // Method to save Coordinates
    procedure SaveCoordinates;
    procedure SetAction(AItem: TListItem);
    procedure LoadUserSig(var AList: TStringList; const AUserName: String);
    procedure PrintSettings(const AUserDetailsIntf: IUserDetails);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); reintroduce;
  end;

implementation

{$R *.dfm}

uses UserProfileF, AuthenticationSettingsF, ChangePasswordF, ImportUsersF,
      {$IFDEF RP}
        {$IFDEF FRM}
          ReportHU,
        {$ENDIF}
      {$ENDIF}
     BtKeys1U, ETStrU, PasswordUtil, ForgottenPasswordRequestF, oSystemSetup,
     BtSupu2, LoginF, VarRec2U;

//------------------------------------------------------------------------------

constructor TfrmUserManagement.Create(AOwner: TComponent);
begin
  inherited Create (Owner);
  MDI_SetFormCoord(TForm(Self));
  ClientHeight := 299;
  ClientWidth := 891;
  // Load any previously saved colors and positions
  FSettings := GetWindowSettings(Self.Name);
  if Assigned(FSettings) then
    FSettings.LoadSettings;

  if Assigned(FSettings) And (Not FSettings.UseDefaults) then
  begin
    FSettings.SettingsToWindow(Self);
    FSettings.SettingsToParent(Self);
    FSettings.SettingsToParent(lvUsers);
  end;
  FSelectedIndex := 0;
  LoadList;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.FormCreate(Sender: TObject);
begin
  // DO NOT USE
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.FormDestroy(Sender: TObject);
begin
  // Release the transaction list interface
  FUserListIntf := NIL;
  if Assigned(FSettings) then
  begin
    FSettings.WindowToSettings(Self);
    FSettings.ParentToSettings(lvUsers, lvUsers);
    //Method to save Coordinates and column arrangement
    SaveCoordinates;
    FSettings := nil;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.FormActivate(Sender: TObject);
begin
// Do Not Use
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.FormResize(Sender: TObject);
const
  BorderPix = 4;
begin
  // Align buttons to right border
  btnClose.Left := ClientWidth - BorderPix - btnClose.Width;
  btnAddUser.Left := btnClose.Left;
  btnEditUser.Left := btnClose.Left;
  btnDeleteUser.Left := btnClose.Left;
  btnCopyUser.Left := btnClose.Left;
  btnResetCustom.Left := btnClose.Left;
  btnPrintSettings.Left := btnClose.Left;
  btnChangePassword.Left := btnClose.Left;
  btnResetPassword.Left := btnClose.Left;

  btnImportUsers.Left := btnClose.Left;
  btnConfiguration.Left := btnClose.Left;

  // Fit ListView in middle
  lvUsers.Top := BorderPix;
  lvUsers.Left := BorderPix;
  lvUsers.Width := btnClose.Left - BorderPix - lvUsers.Left;
  lvUsers.Height := ClientHeight - lvUsers.Top - BorderPix;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.WMGetMinMaxInfo(var message: TWMGetMinMaxInfo);
begin
  with Message.MinMaxInfo^ do
  begin
    ptMinTrackSize.X := 650;
    ptMinTrackSize.Y := 270;
  end;
  message.Result:=0;

  inherited;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.LoadList;
var
  I: Integer;
begin
  FUserListIntf := UserDetailList(True);
  if Assigned(FUserListIntf) Then
  begin
    lvUsers.Clear;
    try
      for I := 0 To (FUserListIntf.Count - 1) Do
      begin
        with lvUsers.Items.Add do
        begin
          Caption := FUserListIntf[i].udUserName;
          SubItems.Add(FUserListIntf[i].udFullName);
          SubItems.Add(FUserListIntf[i].udEmailAddr);
          SubItems.Add(FUserListIntf[i].udWindowUserId);

          if (FUserListIntf[i].udUserStatus in [usActive, usSuspendedAdmin]) and (FUserListIntf[i].udPwdExpMode = PWExpModeExpired) then
            SubItems.Add(FUserListIntf[i].udUserStatusDescription + ', Pwd Expired')
          else if FUserListIntf[i].udUserStatus in [usSuspendedLoginFailure, usPasswordExpired] then
            SubItems.Add('Suspended, '+FUserListIntf[i].udUserStatusDescription)
          else
            SubItems.Add(FUserListIntf[i].udUserStatusDescription);
        end;
      end;
    finally
      if (lvUsers.Items.Count > 0) and (FSelectedIndex > -1) and (lvUsers.Items.Count > FSelectedIndex) then
        lvUsers.Items[FSelectedIndex].Selected := True;
    end;
  end;
end;

//------------------------------------------------------------------------------
// Save Columns and Coordinates
procedure TfrmUserManagement.SaveCoordinates;
begin
  if Assigned(FSettings) then
    FSettings.SaveSettings(SaveCoordinates1.Checked);
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.lvUsersSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if not FDeleteAction then
    SetAction(Item);
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.lvUsersCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  lItem: TListItem;
begin
  lItem := Item;
  if Assigned(lItem) then
  begin
    if Trim(lItem.Caption) = Trim(EntryRec^.Login) then
      Sender.Canvas.Font.Style := [fsBold];
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.actCloseExecute(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.actAddExecute(Sender: TObject);
var
  lPermission: Boolean;
  lUserProfile: TfrmUserProfile;
  loUserDetails: IUserDetails;
begin
  try
    lPermission := MessageDlg(msgConfirmUserAccessSettingYes, mtConfirmation, [mbYes,mbNo], 0) = mrYes;
    loUserDetails := FUserListIntf.AddUser;
    if Assigned(loUserDetails) then
    begin
      lUserProfile := TfrmUserProfile.Create(Self, umInsert, loUserDetails, lPermission);
      lUserProfile.Show;
    end;
  except
    if Assigned(lUserProfile) then
      Freeandnil(lUserProfile);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.actEditExecute(Sender: TObject);
var
  lIndex: Integer;
  lUserProfile: TfrmUserProfile;
  loUserDetails: IUserDetails;
begin
  if assigned(lvUsers.Selected) then
  begin
    lIndex := lvUsers.Items.IndexOf(lvUsers.Selected);
    if lIndex <> -1 then
    begin
      try
        loUserDetails := FUserListIntf.Users[lIndex].EditUser;
        if Assigned(loUserDetails) then
        begin
          FSelectedIndex := lIndex;
          lUserProfile := TfrmUserProfile.Create(Self, umUpdate, loUserDetails);
          lUserProfile.Show;
        end;
      except
        if Assigned(lUserProfile) then
          Freeandnil(lUserProfile);
      end
    end;
  end
  else
    MessageDlg ('Please select an User before this operation.', mtInformation, [mbOK], 0);
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.actDeleteExecute(Sender: TObject);
var
  lIndex: Integer;
  lDeleteMsg,
  lUser: String;
  lRes: Integer;
begin
  lDeleteMsg := '';
  if assigned(lvUsers.Selected) then
  begin
    if MessageDlg(msgDeleteUserConfirm, mtConfirmation, [mbYes,mbNo],0) = mrYes then
    begin
      FDeleteAction := True;
      Screen.Cursor := crHourGlass;
      try
        lIndex := lvUsers.Items.IndexOf(lvUsers.Selected);
        if lIndex <> -1 then
        begin
          lUser := FUserListIntf.Users[lIndex].udUserName;
          lRes := FUserListIntf.DeleteUser(lUser, lDeleteMsg);
          if lRes = 0 then
          begin
            FSelectedIndex := lIndex;
            LoadList;
            MessageDlg(Format(lDeleteMsg, [Trim(lUser)]), mtInformation, [mbOk], 0);
          end
          else
            MessageDlg(lDeleteMsg, mtError, [mbOk], 0);
        end;
      finally
        FDeleteAction := False;
        Screen.Cursor := crDefault;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.actCopyExecute(Sender: TObject);
var
  lIndex: Integer;
  lUserProfile: TfrmUserProfile;
  loCopyUserDetails,
  loUserDetails: IUserDetails;
begin
  lIndex := lvUsers.Items.IndexOf(lvUsers.Selected);
  if lIndex <> -1 then
  begin
    try
      loCopyUserDetails := FUserListIntf.Users[lIndex].EditUser;
      if Assigned(loCopyUserDetails) then
        loUserDetails := FUserListIntf.CopyUser(loCopyUserDetails);
      if Assigned(loUserDetails) then
      begin
        lUserProfile := TfrmUserProfile.Create(Self, umCopy, loUserDetails);
        lUserProfile.Show;
      end;
    except
      if Assigned(lUserProfile) then
        Freeandnil(lUserProfile);
    end;
  end
  else
    MessageDlg ('Please select an User before this operation.', mtInformation, [mbOK], 0);
end;

//------------------------------------------------------------------------------
// Remove all the custom settings saved for the user
procedure TfrmUserManagement.actResetCustomExecute(Sender: TObject);
var
  lIndex: Integer;
  lDeleteMsg,
  lUser: String;
  loSettings: IWindowSettings;
  lRes: Integer;
begin
  if Assigned(lvUsers.Selected) then
  begin
    if MessageDlg(msgConfirmResetCustom, mtConfirmation, [mbYes,mbNo],0) = mrYes then
    begin
      lIndex := lvUsers.Items.IndexOf(lvUsers.Selected);
      if lIndex <> -1 then
      begin
        lUser := FUserListIntf.Users[lIndex].udUserName;
        loSettings := GetWindowSettings(SetDrive, ExtractFilename(GetModuleName(HInstance)), lUser, '');
        if Assigned(loSettings) then
        begin
          try
            loSettings.DeleteAllSettingsForUser;
          finally
            loSettings := nil;
          end;
        end;
        lRes := FUserListIntf.DeleteCustomSetting(lUser, lDeleteMsg);
        {$IFDEF EXSQL}
          if (lRes = 0) then
            MessageDlg((Format(lDeleteMsg, [Trim(lUser)])), mtInformation, [mbOk], 0)
          else
            MessageDlg((Format(lDeleteMsg, [Trim(lUser)])), mtError, [mbOk], 0);
        {$ENDIF}

      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.actPrintSettingsExecute(Sender: TObject);
var
  lIndex: Integer;
  loUserDetails: IUserDetails;
begin
  if assigned(lvUsers.Selected) then
  begin
    lIndex := lvUsers.Items.IndexOf(lvUsers.Selected);
    if lIndex <> -1 then
    begin
      loUserDetails := FUserListIntf.Users[lIndex].EditUser;
      if Assigned(loUserDetails) then
        PrintSettings(loUserDetails);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.actChangePasswordExecute(Sender: TObject);
var
  lIndex: Integer;
  lUserDetailsObj: IUserDetails;
  lIUserDetails: IUserDetails;
begin
  if assigned(lvUsers.Selected) then
  begin
    lIndex := lvUsers.Items.IndexOf(lvUsers.Selected);
    if lIndex <> -1 then
    begin
      lUserDetailsObj := FUserListIntf.Users[lIndex].EditUser;
      lIUserDetails := lUserDetailsObj;
      if Assigned(lIUserDetails) then
        DisplayChangePasswordDlg(Self, lIUserDetails);
    end;
  end
  else
    MessageDlg ('Please select an User before this operation.', mtInformation, [mbOK], 0);
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.actResetPasswordExecute(Sender: TObject);
var
  lUserDetails: IUserDetails;
  lRes: Integer;
begin
  Screen.Cursor := crHourGlass;
  try
    if Assigned(lvUsers.Selected) then
    begin
      lUserDetails := FUserListIntf.Users[lvUsers.Selected.Index];
      if Assigned(lUserDetails) then
      begin
        lRes := lUserDetails.ResetPassword(True, True);
        if lRes = 0 then
          MessageDlg(Format(msgEmailSent, [Trim(lUserDetails.udUserName)]), mtInformation, [mbOK], 0)
        else
          MessageDlg(lUserDetails.ResetPasswordErrorDescription(lRes), mtError, [mbOk], 0);
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.actImportUsersExecute(Sender: TObject);
begin
  With TfrmImportUsers.Create(Self) Do
    Try
      ShowModal;
    Finally
      Free;
    End; // Try..Finally
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.actConfigurationExecute(Sender: TObject);
var
  lfrmUserAuthentication: TfrmUserAuthenticationSettings;
begin
  lfrmUserAuthentication := TfrmUserAuthenticationSettings.Create(Self);
  try
    lfrmUserAuthentication.UserListIntf := FUserListIntf;
    lfrmUserAuthentication.ShowModal;
  finally
    FreeAndNil(lfrmUserAuthentication);
    if Assigned(lvUsers.Selected) then
      SetAction(lvUsers.Selected);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.actPropertiesExecute(Sender: TObject);
begin
  if Assigned(FSettings) then
    FSettings.Edit(Self, lvUsers);
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.SetAction(AItem: TListItem);
var
  lEnabled: Boolean;
  lAuthMode: String;
  lUser: IUserDetails;
begin
  if not Assigned(FUserListIntf) then Exit;

  lEnabled := Assigned(AItem) and (AItem.Selected);
  lAuthMode := Trim(SystemSetup(True).PasswordAuthentication.AuthenticationMode);
  lUser := FUserListIntf.Users[AItem.Index];

  actAdd.Enabled := True;
  actEdit.Enabled := lEnabled and Assigned(lUser);

  //PL 04/09/2017 2017-R2 ABSEXCH-19173 CR - Users who are Active can not be deleted, Rest other User Status can be deleted.
  actDelete.Enabled := actEdit.Enabled and (Trim(lUser.udUserName) <> Trim(EntryRec^.Login)) and (lUser.udUserStatus <> usActive);
  actCopy.Enabled := actEdit.Enabled;
  actPrintSettings.Enabled := actEdit.Enabled;
  actResetCustom.Enabled := actEdit.Enabled;
  actChangePassword.Enabled := actEdit.Enabled and (lAuthMode = AuthMode_Exchequer);
  actResetPassword.Enabled := lEnabled and (lAuthMode = AuthMode_Exchequer) and (lUser.udEmailaddr <> EmptyStr) and (Trim(lUser.udUserName) <> Trim(EntryRec^.Login));
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.WMRefresh(var message: TMessage);
begin
  LoadList;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.PrintSettings(const AUserDetailsIntf: IUserDetails);
var
  lPrintJobList: TStringList;
  lGrpAry: LongInt;
  lEffect: Byte;
  lPNo,
  i: SmallInt;
  lLineWord,
  lLineText,
  lSendLine :  Str255;

  lPWTreeGrpAry: tPWTreeGrpAry;
  lEntryRec : EntryRecType;
  {$IFDEF FRM}
    lPrnInfo  : TSBSPrintSetupInfo;
  {$ENDIF}
begin
  lPrintJobList := TStringList.Create;
  try
    lPrintJobList.Clear;
    lEntryRec := AUserDetailsIntf.udUserAccessRec;
    PrimeTreeGroups(lPWTreeGrpAry);

    lGrpAry := 1;
    lLineWord :=EmptyStr;
    while lGrpAry <= High(lPWTreeGrpAry) do
    begin
      with lPWTreeGrpAry[lGrpAry] do
      begin
        if (not Exclude) and (tCaption <> EmptyStr) then {* Exclude for modules sensitive, + deliberrate gaps for other groups *}
        begin
          with lPrintJobList do
          begin
            lEffect := 2-IsChild;
            if lEffect < 1 then
              lEffect := 1;

            Add('');
            Add(Chr(lEffect)+#9+tCaption);
            if WordCnt(PWLink) > 0 then
            begin
              for i:=1 to WordCnt(PWLink) do
              begin
                lLineWord := ExtractWords(i, 1, PWLink);
                if lLineWord <> 'X' then
                begin
                  lLineText := GetPWText(lLineWord, lPNo);
                  if lLineText = 'XNANX' then
                    lLineText := 'Password Missing!';
                  lSendLine := YesNoBo((lEntryRec.Access[lPno]<>0))+#9+lLineText+' ('+lLineWord+')';

                  if lEntryRec.Access[lPno] <> 0 then
                    lSendLine := #0+lSendLine;
                  Add(lSendLine);
                end; // if lLineWord <> 'X' then
              end; // for Loop
            end; // if WordCnt(PWLink) > 0 then
            Inc(lGrpAry);
          end; // with lPrintJobList do
        end // if (not Exclude) and (tCaption <> EmptyStr) then
        else
          Inc(lGrpAry);
      end; // with lPWTreeGrpAry[lGrpAry] do
    end;// while Loop

    LoadUserSig(lPrintJobList, Uppercase(Trim(AUserDetailsIntf.udUserName)));
    lLineText:='Password Access Listing For User '+ dbFormatName(AUserDetailsIntf.udUserName, AUserDetailsIntf.udFullName);

    {$IFDEF RP}
      {$IFDEF FRM}
        AddMemoRep2ThreadMode(lPrnInfo, lPrintJobList, lLineText, Application.MainForm, 1);
      {$ENDIF}
    {$ENDIF}
  finally
    FreeAndNil(lPrintJobList);
  end;
end;

//------------------------------------------------------------------------------
{Load User Email/Fax Signature Settings for Print Settings}
procedure TfrmUserManagement.LoadUserSig(var AList: TStringList; const AUserName: String);
var
  lFileName: String;
  lStrList: TStringList;
  i: Integer;
begin
  lStrList := TStringList.Create;
  try
    lFileName := SetDrive + SignDirectoryPath + AUserName + '.TXT';
    if not FileExists(lFileName) then
      lFileName := SetDrive + SignDirectoryPath + CompanyEmailFile;
    if FileExists(lFileName) then
    begin
      AList.Add('');
      AList.Add(#1+#9+'Email Signature Settings');
      lStrList.LoadFromFile(lFileName);
      for i:=0 to Pred(lStrList.Count) do
        AList.Add(#9+ lStrList.Strings[i]);
    end;
    // Fax Sign
    lFileName := SetDrive + SignDirectoryPath + AUserName + '.TX2';
    if not FileExists(lFileName) then
      lFileName := SetDrive + SignDirectoryPath + CompanyFaxFile;
    if FileExists(lFileName) then
    begin
      {$IFNDEF LTE}
        AList.Add('');
        AList.Add(#1+#9+'Fax Signature Settings');
      {$ENDIF}
      lStrList.Clear;
      lStrList.LoadFromFile(lFileName);
      for i:=0 to Pred(lStrList.Count) do
        AList.Add(#9+ lStrList.Strings[i]);
    end;
  finally
    FreeAndNil(lStrList);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.lvUsersDblClick(Sender: TObject);
begin
  actEditExecute(Self);
end;

//------------------------------------------------------------------------------

procedure TfrmUserManagement.FormShow(Sender: TObject);
begin
  if (GetWindowlong(lvUsers.Handle, GWL_STYLE) and WS_VSCROLL) <> 0 then
    Self.ClientWidth := Self.ClientWidth + 21;
end;

end.
