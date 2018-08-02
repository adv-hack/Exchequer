unit uWRedUsers;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompText, IWCompListbox,
  IWCompButton, IWCompCheckbox, IWCompEdit, IWCompLabel, Classes, Controls,
  IWControl, DB;

type
  TUserState = (usNil, usNew, usEdit);

  TfrmedUsers = class(TIWAppForm)
    cbParent: TIWComboBox;
    lblParent: TIWLabel;
    lblUserCode: TIWLabel;
    capPassword: TIWLabel;
    edUserCode: TIWEdit;
    cbSuspended: TIWCheckBox;
    bnSaveChanges: TIWButton;
    bnReturnAdmin: TIWButton;
    bnReturnMain: TIWButton;
    lbPermitFrom: TIWListbox;
    lbPermitTo: TIWListbox;
    bnAdd: TIWButton;
    bnRemove: TIWButton;
    lblTemplate: TIWLabel;
    cbTemplate: TIWComboBox;
    lblPermissions: TIWLabel;
    txtPermissions: TIWText;
    edUserName: TIWEdit;
    lblDealerName: TIWLabel;
    lblhdrUsers: TIWLabel;
    bnCancel: TIWButton;
    bnAddAll: TIWButton;
    bnRemoveAll: TIWButton;
    lblAvailable: TIWLabel;
    lblGranted: TIWLabel;
    lblEmail: TIWLabel;
    edEmail: TIWEdit;
    lblSMSPhone: TIWLabel;
    edSMSPhone: TIWEdit;
    lblPassword: TIWLabel;
    capExpiryDate: TIWLabel;
    lblExpiryDate: TIWLabel;
    lblExpiryDays: TIWLabel;
    edExpiryDays: TIWEdit;
    bnFilterUser: TIWButton;
    edFilterUser: TIWEdit;
    cbContainsUser: TIWCheckBox;
    procedure bnCancelClick(Sender: TObject);
    procedure bnReturnAdminClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure bnSaveChangesClick(Sender: TObject);
    procedure cbTemplateChange(Sender: TObject);
    procedure bnAddClick(Sender: TObject);
    procedure bnRemoveClick(Sender: TObject);
    procedure bnAddAllClick(Sender: TObject);
    procedure bnRemoveAllClick(Sender: TObject);
    procedure cbParentChange(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure edFilterUserSubmit(Sender: TObject);
  private
    fPermissionsChanged: boolean;
    fWarnedList: TStringlist;
    procedure AddUserPermissions;
    procedure DoAdminLog;
    procedure LoadDealers(FilterCond: string);
    function DoEmailDomainsMatch: boolean;
    function isCodeChanged: boolean;
    function isUserCodeInUse: boolean;
  public
    OriginalCode: string;
    InitName: string;
    InitEmail: string;
    InitSMSPhone: string;
    InitParent: integer;
    InitSuspended: boolean;
    InitExpiryDays: string;
    UserState: TUserState;
    UserID: integer;
    procedure LoadPermissionFroms;
  end;

implementation

{$R *.dfm}

uses uWRServer, uWRData, uWRAdmin, uWRSite, uWRUsers, uPermissionIDs, SysUtils,
     Dialogs;

//******************************************************************************

procedure TfrmedUsers.IWAppFormCreate(Sender: TObject);
begin
  {}

  fWarnedList:= TStringlist.Create;

  with WRData, qyPrimary do
  begin
    LoadDealers('');

    Close;
    Sql.Clear;
    Sql.Add('select username from users where template = 1 ');
    Open;

    while not eof do
    begin
      cbTemplate.Items.Add(FieldByName('UserName').AsString);
      Next;
    end;
  end;
end;

procedure TfrmedUsers.IWAppFormDestroy(Sender: TObject);
begin
  if Assigned(fWarnedList) then FreeAndNil(fWarnedList);
end;

procedure TfrmedUsers.bnReturnAdminClick(Sender: TObject);
begin
  TfrmAdmin.Create(WebApplication).Show;
  Release;
end;

procedure TfrmedUsers.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmedUsers.bnCancelClick(Sender: TObject);
begin
  TfrmUsers.Create(WebApplication).Show;
  Release;
end;

//******************************************************************************

procedure TfrmedUsers.bnSaveChangesClick(Sender: TObject);
var
ParentID, ExpiryDays: integer;
LogString: string;
begin
  if Trim(edUserName.Text) = '' then
  begin
    WebApplication.ShowMessage('Please specify a name for the new user.');
    Exit;
  end;

  if Trim(cbParent.Text) = '' then
  begin
    WebApplication.ShowMessage('You must select a parent from the parent drop-down list.');
    Exit;
  end;

  if Trim(edUserCode.Text) = '' then
  begin
    WebApplication.ShowMessage('Please specify a user code for the new user.');
    Exit;
  end;

  if isUserCodeInUse then
  begin
    WebApplication.ShowMessage('This user code is already in use. Please choose another.');
    Exit;
  end;

  if Trim(edEmail.Text) = '' then
  begin
    WebApplication.ShowMessage('You must specify an email address for this user.');
    Exit;
  end
  else if not UserSession.isValidEmail(edEmail.Text) then Exit;

  if Length(Trim(edEmail.Text)) > 50 then
  begin
    WebApplication.ShowMessage('The email address is limited to 50 characters. Please contact technical support for extension.');
    Exit;
  end;

  if Length(Trim(edSMSPhone.Text)) > 20 then
  begin
    WebApplication.ShowMessage('The SMSPhone field is limited to 20 characters. Please contact technical support for extension.');
    Exit;
  end;

  ExpiryDays:= StrToIntDef(edExpiryDays.Text, -1);
  if ExpiryDays = -1 then
  begin
    WebApplication.ShowMessage('Please specify a suitable value for the expiry days.');
    Exit;
  end;

  if not DoEmailDomainsMatch then Exit;

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select groupid from usergroups where groupdesc = :pgroupdesc ');
    ParamByName('pgroupdesc').AsString:= Trim(cbParent.Text);
    Open;
    ParentID:= FieldByName('GroupID').AsInteger;

    Close;
    Sql.Clear;

    case UserState of
      usNew:
      begin
        Sql.Add('select max(userid) from users ');
        Open;
        UserID:= Fields[0].AsInteger + 1;

        Close;
        Sql.Clear;
        Sql.Add('insert into users (userid, usercode, username, userpassword, useractive, ');
        Sql.Add('groupid, template, email, smsphone, pwexpires, expirydays, customsendvia) ');
        Sql.Add('values (:puserid, :pusercode, :pusername, :puserpassword, :puseractive, ');
        Sql.Add(':pgroupid, 0, :pemail, :psmsphone, :ppwexpires, :pexpirydays, 1) ');
        ParamByName('puserpassword').AsString:= lblPassword.Caption;
        ParamByName('ppwexpires').AsDateTime:= Date + ExpiryDays;
      end;
      usEdit:
      begin
        Sql.Add('delete from userpermissions where userid = :puserid ');
        Sql.Add('and permissionid between :ppermissionlow and :ppermissionhigh ');
        ParamByName('puserid').AsInteger:= UserID;
        ParamByName('ppermissionlow').AsInteger:= pidSecEnterprise;
        ParamByName('ppermissionhigh').AsInteger:= pidReq30ModUCRel;
        ExecSql;

        Close;
        Sql.Clear;
        Sql.Add('update users set usercode = :pusercode, username = :pusername, ');
        Sql.Add('useractive = :puseractive, groupid = :pgroupid, email = :pemail, ');
        Sql.Add('smsphone = :psmsphone, expirydays = :pexpirydays where userid = :puserid ');
      end;
    end;

    ParamByName('puserid').AsInteger:= UserID;
    ParamByName('pusercode').AsString:= UpperCase(Copy(edUserCode.Text, 1, 30));
    ParamByName('pusername').AsString:= Copy(edUserName.Text, 1, 30);
    ParamByName('puseractive').AsBoolean:= not cbSuspended.Checked;
    ParamByName('pgroupid').AsInteger:= ParentID;
    ParamByName('pemail').AsString:= Copy(Trim(edEmail.Text), 1, 50);
    ParamByName('psmsphone').AsString:= Copy(Trim(edSMSPhone.Text), 1, 20);
    ParamByName('pexpirydays').AsInteger:= ExpiryDays;
    ExecSql;

    AddUserPermissions;

    case UserState of
      usNew:
      begin
        LogString:= 'New User inserted - Code:' + Copy(Trim(edUserCode.Text), 1, 30) + ', Name:' + Copy(Trim(edUserName.Text), 1, 30) + ', Parent:' + cbParent.Text + ', Email:' + Copy(Trim(edEmail.Text), 1, 50) + ', SMSPhone:' + Copy(Trim(edSMSPhone.Text), 1, 20) + ', PWExpiryDays:' + edExpiryDays.Text;
        UserSession.AdminLog(UserID, itUser, Copy(LogString, 1, 250));
      end;
      usEdit: DoAdminLog;
    end;

    TfrmUsers.Create(WebApplication).Show;
    if UserState = usNew then
    begin
      //UserSession.EmailPassword(OriginalCode);   {To be decided};
      WebApplication.ShowMessage('The user ' + Copy(Trim(edUserName.Text), 1, 30) + ' has been added successfully.');
    end
    else WebApplication.ShowMessage('The user ' + Copy(Trim(edUserName.Text), 1, 30) + ' has been updated successfully.');
  end;

  Release;
end;

procedure TfrmedUsers.DoAdminLog;
var
BuildStr: string;
begin
  {When a user is edited, only those fields that have been changed are logged
   to the AdminLog table;}

  BuildStr:= '';

  with UserSession do
  begin
    if OriginalCode <> Copy(Trim(edUserCode.Text), 1, 30) then BuildStr:= BuildStr + 'UserCode:' + Copy(Trim(edUserCode.Text), 1, 30) + ', ';
    if InitName <> Copy(Trim(edUserName.Text), 1, 30) then BuildStr:= BuildStr + 'Name:' + Copy(Trim(edUserName.Text), 1, 30) + ', ';
    if InitParent <> cbParent.ItemIndex then BuildStr:= BuildStr + 'Parent:' + cbParent.Text + ', ';
    if InitEmail <> Copy(Trim(edEmail.Text), 1, 50) then BuildStr:= BuildStr + 'Email:' + Copy(Trim(edEmail.Text), 1, 50) + ', ';
    if InitSMSPhone <> Copy(Trim(edSMSPhone.Text), 1, 20) then BuildStr:= BuildStr + 'SMSPhone:' + Copy(Trim(edSMSPhone.Text), 1, 20) + ', ';
    if InitExpiryDays <> Trim(edExpiryDays.Text) then BuildStr:= BuildStr + 'PWExpiryDays:' + Trim(edExpiryDays.Text) + ', ';
    if InitSuspended <> cbSuspended.Checked then
    begin
      if cbSuspended.Checked then BuildStr:= BuildStr + 'Suspended, '
      else BuildStr:= BuildStr + 'Unsuspended, ';
    end;
    if fPermissionsChanged then BuildStr:= BuildStr + 'Permissions Changed, ';

    Delete(BuildStr, Length(BuildStr) - 1, 2);
    AdminLog(Self.UserID, itUser, 'User ' + InitName + ' updated - ' + Copy(BuildStr, 1, 250));
  end;
end;

procedure TfrmedUsers.AddUserPermissions;
var
MaxID, PermissionIndex: integer;
begin
  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select max(upid) from userpermissions ');
    Open;
    MaxID:= Fields[0].AsInteger + 1;

    Close;
    Sql.Clear;
    Sql.Add('insert into userpermissions (upid, userid, permissionid) ');
    Sql.Add('values (:pupid, :puserid, :ppermissionid) ');

    with qySecondary do
    begin
      Close;
      Sql.Clear;
      Sql.Add('select permissionid, permissiondesc from permissions ');
      Open;
    end;

    with qyTertiary do
    begin
      Close;
      Sql.Clear;
      Sql.Add('select permissionid from userpermissions ');
      Sql.Add('where userid = :puserid ');
      ParamByName('puserid').AsInteger:= UserID;
      Open;
    end;

    for PermissionIndex:= 0 to lbPermitTo.Items.Count - 1 do
    begin
      if qySecondary.Locate('PermissionDesc', lbPermitTo.Items[PermissionIndex], [loCaseInsensitive]) then
      begin
        if not qyTertiary.Locate('PermissionID', qySecondary.FieldByName('PermissionID').AsInteger, []) then
        begin
          ParamByName('pupid').AsInteger:= MaxID + PermissionIndex;
          ParamByName('puserid').AsInteger:= UserID;
          ParamByName('ppermissionid').AsInteger:= qySecondary.FieldByName('PermissionID').AsInteger;
          ExecSql;
        end;
      end;
    end;
  end;
end;

function TfrmedUsers.isUserCodeInUse: boolean;
begin
  Result:= false;

  if (UserState = usNew) or isCodeChanged then with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select count(usercode) from users ');
    Sql.Add('where usercode = :pusercode ');
    ParamByName('pusercode').AsString:= Copy(Trim(edUserCode.Text), 1, 30);
    Open;

    Result:= Fields[0].AsInteger > 0;
  end;
end;

function TfrmedUsers.isCodeChanged: boolean;
begin
  Result:= Copy(Trim(OriginalCode), 1, 30) <> Copy(Trim(edUserCode.Text), 1, 30);
end;

//*** Event Handlers ***********************************************************

procedure TfrmedUsers.cbTemplateChange(Sender: TObject);
begin
  if Trim(cbTemplate.Text) = '' then Exit;

  lbPermitTo.Items.Clear;
  
  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select c.permissiondesc as permissiondesc ');
    Sql.Add('from users a, userpermissions b, permissions c ');
    Sql.Add('where a.userid = b.userid and b.permissionid = c.permissionid ');
    Sql.Add('and a.username = :pusername ');
    ParamByName('pusername').AsString:= Trim(cbTemplate.Text);
    Open;

    while not eof do
    begin
      lbPermitTo.Items.Add(FieldByName('PermissionDesc').AsString);
      Next;
    end;

    LoadPermissionFroms;
  end;
end;

procedure TfrmedUsers.bnAddClick(Sender: TObject);
var
ItemsIndex, HoldIndex: integer;
begin
  if lbPermitFrom.Items[0] = ' ' then Exit;

  HoldIndex:= 0;
  ActiveControl:= lbPermitFrom;

  with TStringlist.Create do
  try

    for ItemsIndex:= lbPermitFrom.Items.Count - 1 downto 0 do
    begin
      if lbPermitFrom.Selected[ItemsIndex] then
      begin
        fPermissionsChanged:= true;
        HoldIndex:= ItemsIndex;

        Add(lbPermitFrom.Items[ItemsIndex]);
        lbPermitTo.Items.Add(lbPermitFrom.Items[ItemsIndex]);
        lbPermitFrom.Items.Delete(ItemsIndex);
      end;
    end;

    lbPermitFrom.ResetSelection;
    lbPermitTo.ResetSelection;
    if lbPermitFrom.Items.Count <= 0 then lbPermitFrom.Items.Add(' ');

    if Count > 0 then
    begin
      for ItemsIndex:= 0 to Pred(Count) do lbPermitTo.Selected[lbPermitTo.Items.IndexOf(Strings[ItemsIndex])]:= true;
      while HoldIndex >= lbPermitFrom.Items.Count do dec(HoldIndex);
      lbPermitFrom.Selected[HoldIndex]:= true;
    end;

  finally
    Free;
  end;
end;

procedure TfrmedUsers.bnRemoveClick(Sender: TObject);
var
ItemsIndex, HoldIndex: integer;
begin
  if lbPermitTo.Selected[lbPermitTo.Items.IndexOf('Run WebRel')] then
  begin
    WebApplication.ShowMessage('The ''Run WebRel'' permission can not be removed.');
    Exit;
  end;

  HoldIndex:= 0;
  ActiveControl:= lbPermitTo;

  with TStringlist.Create do
  try

    if lbPermitFrom.Items.IndexOf(' ') >= 0 then lbPermitFrom.Items.Delete(lbPermitFrom.Items.IndexOf(' '));

    for ItemsIndex:= lbPermitTo.Items.Count - 1 downto 0 do
    begin
      if lbPermitTo.Selected[ItemsIndex] then
      begin
        fPermissionsChanged:= true;
        HoldIndex:= ItemsIndex;

        Add(lbPermitTo.Items[ItemsIndex]);
        lbPermitFrom.Items.Add(lbPermitTo.Items[ItemsIndex]);
        lbPermitTo.Items.Delete(ItemsIndex);
      end;
    end;

    lbPermitFrom.ResetSelection;
    lbPermitTo.ResetSelection;

    if Count > 0 then
    begin
      for ItemsIndex:= 0 to Pred(Count) do lbPermitFrom.Selected[lbPermitFrom.Items.IndexOf(Strings[ItemsIndex])]:= true;
      while HoldIndex >= lbPermitTo.Items.Count do dec(HoldIndex);
      lbPermitTo.Selected[HoldIndex]:= true;
    end;

  finally
    Free;
  end;
end;

procedure TfrmedUsers.bnAddAllClick(Sender: TObject);
var
PermissionIndex: integer;
begin
  with TStringlist.Create do
  try

    fPermissionsChanged:= true;
    for PermissionIndex:= 0 to Pred(lbPermitFrom.Items.Count) do
    begin
      if lbPermitFrom.Items[PermissionIndex] <> ' ' then
      begin
        Add(lbPermitFrom.Items[PermissionIndex]);
        lbPermitTo.Items.Add(lbPermitFrom.Items[PermissionIndex]);
      end;
    end;

    lbPermitFrom.Items.Clear;
    lbPermitFrom.Items.Add(' ');
    lbPermitFrom.Selected[0]:= true;

    for PermissionIndex:= 0 to Pred(Count) do lbPermitTo.Selected[lbPermitTo.Items.IndexOf(Strings[PermissionIndex])]:= true;

  finally
    Free;
  end;
end;

procedure TfrmedUsers.bnRemoveAllClick(Sender: TObject);
var
ItemsIndex: integer;
begin
  with TStringlist.Create do
  try

    fPermissionsChanged:= true;
    for ItemsIndex:= 0 to Pred(lbPermitFrom.Items.Count) do Add(lbPermitFrom.Items[ItemsIndex]);

    lbPermitTo.Items.Clear;
    lbPermitTo.Items.Add('Run WebRel');
    lbPermitTo.Selected[0]:= true;

    LoadPermissionFroms;

    for ItemsIndex:= 0 to Pred(lbPermitFrom.Items.Count) do
    begin
      if IndexOf(lbPermitFrom.Items[ItemsIndex]) < 0 then lbPermitFrom.Selected[ItemsIndex]:= true;
    end;

  finally
    Free;
  end;
end;

procedure TfrmedUsers.cbParentChange(Sender: TObject);
begin
  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select userdef1 from usergroups where groupdesc = :pgroupdesc ');
    ParamByName('pgroupdesc').AsString:= cbParent.Text;
    Open;

    edEmail.Text:= FieldByName('UserDef1').AsString;
  end;
end;

procedure TfrmedUsers.edFilterUserSubmit(Sender: TObject);
var
FilterCond, Contains: string;
begin
  if cbContainsUser.Checked then Contains:= '%' else Contains:= '';
  FilterCond:= 'where groupdesc like ''' + Contains + Trim(edFilterUser.Text) + '%'' ';
  LoadDealers(FilterCond);
end;

//*** Helper Functions *********************************************************

procedure TfrmedUsers.LoadDealers(FilterCond: string);
begin
  cbParent.Items.Clear;

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select groupdesc from usergroups ');
    Sql.Add(FilterCond);
    Open;

    while not eof do
    begin
      cbParent.Items.Add(FieldByName('GroupDesc').AsString);
      Next;
    end;

    if cbParent.Items.Count > 0 then cbParent.ItemIndex:= 0;
  end;
end;

procedure TfrmedUsers.LoadPermissionFroms;
begin
  lbPermitFrom.Items.Clear;

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select permissiondesc from permissions where groupid between 6 and 15 ');
    Open;

    while not eof do
    begin
      if lbPermitTo.Items.IndexOf(FieldByName('PermissionDesc').AsString) < 0 then lbPermitFrom.Items.Add(FieldByName('PermissionDesc').AsString);
      Next;
    end;
  end;
                             
  if lbPermitFrom.Items.Count <= 0 then lbPermitFrom.Items.Add(' ');
  lbPermitFrom.Selected[0]:= true;
end;

function TfrmedUsers.DoEmailDomainsMatch: boolean;
var
DomainGroup, DomainUser: string;
begin
  Result:= true;
  if Trim(edEmail.Text) = InitEmail then Exit;
  if fWarnedList.IndexOf(UpperCase(Trim(edEmail.Text))) >= 0 then Exit;

  fWarnedList.Add(UpperCase(Trim(edEmail.Text)));

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select userdef1 from usergroups where groupdesc = :pgroupdesc ');
    ParamByName('pgroupdesc').AsString:= cbParent.Text;
    Open;

    DomainGroup:= Copy(FieldByName('userdef1').AsString, Pos('@', FieldByName('userdef1').AsString) + 1, Length(FieldByName('userdef1').AsString));
    DomainUser:= Copy(Trim(edEmail.Text), Pos('@', Trim(edEmail.Text)) + 1, Length(Trim(edEmail.Text)));

    if UpperCase(DomainGroup) <> UpperCase(DomainUser) then
    begin
      Result:= false;
      WebApplication.ShowMessage('The user ' + Copy(Trim(edUserName.Text), 1, 30) + ' has an email address that does not match the dealer''s domain (' + DomainGroup + '). ' + #13#10#13#10 + 'Press Save Changes again if you are sure the details are correct otherwise make the necessary changes to the email field.');
    end;
  end;
end;

//******************************************************************************

end.
