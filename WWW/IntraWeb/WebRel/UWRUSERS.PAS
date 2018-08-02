unit uWRUsers;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompListbox, IWCompText,
  IWCompButton, IWCompCheckbox, IWCompEdit, IWCompLabel, Classes, Controls,
  IWControl;

type
  TUserCode = class
  public
    UserCode: string;
    constructor Create(NewUserCode: string); reintroduce; overload;
  end;

  TfrmUsers = class(TIWAppForm)
    cbUser: TIWComboBox;
    lblEditUser: TIWLabel;
    bnNewUser: TIWButton;
    lblhdrUsers: TIWLabel;
    bnReturnAdmin: TIWButton;
    bnReturnMain: TIWButton;
    bnEditUser: TIWButton;
    txtUser: TIWText;
    bnPWChange: TIWButton;
    bnFilterUser: TIWButton;
    edFilterUser: TIWEdit;
    cbContainsUser: TIWCheckBox;
    cbPwordNotification: TIWCheckBox;
    procedure bnReturnAdminClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure bnNewUserClick(Sender: TObject);
    procedure bnEditUserClick(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure bnPWChangeClick(Sender: TObject);
    procedure edFilterUserSubmit(Sender: TObject);
  private
    procedure LoadUsers(FilterCond: string);
  end;

implementation

{$R *.dfm}

uses uWRServer, uWRData, uWRSite, uWRAdmin, uWRedUsers, uPermissionIDs, SysUtils;

//*** TUserCode ****************************************************************

constructor TUserCode.Create(NewUserCode: string);
begin
  {Used to identify specific users given the user names in the user drop-down
   are not necessarily unique;}

  Create;
  UserCode:= NewUserCode;
end;

//*** Startup and Shutdown *****************************************************

procedure TfrmUsers.IWAppFormCreate(Sender: TObject);
begin
  LoadUsers('');
end;

procedure TfrmUsers.IWAppFormDestroy(Sender: TObject);
var
NameIndex: integer;
begin
  {Free all the TUserCode objects in the user drop-down;}

  for NameIndex:= 0 to cbUser.Items.Count - 1 do cbUser.Items.Objects[NameIndex].Free;
end;

//*** Main *********************************************************************

procedure TfrmUsers.bnNewUserClick(Sender: TObject);
begin
  {Create the edit users form and initialise the UserState variable; Select the
   first parent in the parent drop-down and update the related controls; Initialise
   control properties, show the form and release the current form;}

  with TfrmedUsers.Create(WebApplication) do
  begin
    UserState:= usNew;
    InitEmail:= '';

    if cbParent.Items.Count > 0 then cbParent.ItemIndex:= 0;
    cbParentChange(Self);
    cbSuspended.Checked:= false;
    edExpiryDays.Text:= '30';
    lblExpiryDate.Caption:= DateToStr(Date + 30);
    lblPassword.Caption:= UserSession.GetPassword;
    LoadPermissionFroms;
    
    Show;
  end;

  Release;
end;

procedure TfrmUsers.bnEditUserClick(Sender: TObject);
begin
  {Ensure a user has been selected in the user drop-down; Create the edit users
   form and initialise the UserState variable; Extract the user code from the
   object associated with the selected item in the edit user drop-down; Initialise
   the form controls for the selected user and initialise the form fields primarily
   for auditing purposes; Add the user's current permissions to the lbPermitTo
   list-box; Release the current form;}

  if Trim(cbUser.Text) = '' then
  begin
    WebApplication.ShowMessage('Please select a user from the Edit User drop-down box.');
    Exit;
  end;

  with WRData.qyPrimary, TfrmedUsers.Create(WebApplication) do
  begin
    UserState:= usEdit;
    OriginalCode:= TUserCode(cbUser.Items.Objects[cbUser.ItemIndex]).UserCode;
    edUserName.Text:= Trim(cbUser.Text);

    Close;
    Sql.Clear;
    Sql.Add('select a.userid as userid, a.username as username, a.userpassword as userpassword, ');
    Sql.Add('a.useractive as useractive, a.usercode as usercode, a.email as email, ');
    Sql.Add('a.smsphone as smsphone, a.pwexpires as pwexpires, a.expirydays as expirydays, ');
    Sql.Add('b.groupdesc as groupdesc, d.permissiondesc as permissiondesc ');
    Sql.Add('from users a left join usergroups b on a.groupid = b.groupid ');
    Sql.Add('left join userpermissions c on a.userid = c.userid ');
    Sql.Add('left join permissions d on c.permissionid = d.permissionid ');
    Sql.Add('where ((d.groupid between 6 and 15) or (d.groupid is null)) ');
    Sql.Add('and a.usercode = :pusercode ');
    ParamByName('pusercode').AsString:= OriginalCode;
    Open;

    UserID:= FieldByName('UserID').AsInteger;
    cbParent.ItemIndex:= cbParent.Items.IndexOf(FieldByName('GroupDesc').AsString);
    edUserCode.Text:= FieldByName('UserCode').AsString;
    edEmail.Text:= FieldByName('Email').AsString;
    edSMSPhone.Text:= FieldByName('SMSPhone').AsString;
    edExpiryDays.Text:= FieldByName('ExpiryDays').AsString;
    lblPassword.Caption:= FieldByName('UserPassword').AsString;
    lblExpiryDate.Caption:= FieldByName('PWExpires').AsString;
    cbSuspended.Checked:= not FieldByName('UserActive').AsBoolean;

    while not eof do
    begin
      if not FieldByName('PermissionDesc').IsNull then lbPermitTo.Items.Add(FieldByName('PermissionDesc').AsString);
      Next;
    end;

    InitName:= edUserName.Text;
    InitEmail:= edEmail.Text;
    InitSMSPhone:= edSMSPhone.Text;
    InitParent:= cbParent.ItemIndex;
    InitSuspended:= cbSuspended.Checked;
    InitExpiryDays:= edExpiryDays.Text;

    LoadPermissionFroms;

    Show;
  end;

  Release;
end;

procedure TfrmUsers.bnPWChangeClick(Sender: TObject);
var
UserCode, UserName: string;
UserID, ExpiryDays: integer;
Success: boolean;
begin
  {Ensure a user has been selected in the edit user drop-down; Extract the
   UserCode from the object associated with the selected user; Retrieve the
   necessary fields from the user record to determine the new expiry date and
   establish an audit trail; Update the user record with the new password and
   expiry date, email the user their new password, log the occurrence, and
   display confirmation to the current user;}

  Success := false;

  if Trim(cbUser.Text) = '' then
  begin
    WebApplication.ShowMessage('Please select a user from the Edit User drop-down box.');
    Exit;
  end;

  UserCode:= TUserCode(cbUser.Items.Objects[cbUser.ItemIndex]).UserCode;

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select username, userid, expirydays from users ');
    Sql.Add('where usercode = :pusercode ');
    ParamByName('pusercode').AsString:= UserCode;
    Open;

    UserID:= FieldByName('UserID').AsInteger;
    UserName:= FieldByName('UserName').AsString;
    ExpiryDays:= FieldByName('ExpiryDays').AsInteger;

    Close;
    Sql.Clear;
    Sql.Add('update users set userpassword = :puserpassword, pwexpires = :ppwexpires ');
    Sql.Add('where usercode = :pusercode ');
    ParamByName('puserpassword').AsString:= UserSession.GetPassword;
    ParamByName('ppwexpires').AsDateTime:= Date + ExpiryDays;
    ParamByName('pusercode').AsString:= UserCode;
    ExecSql;
  end;

  // AB - 5
  if (not cbPwordNotification.Checked) then
    Success := UserSession.EmailPassword(UserCode);

  if Success then WebApplication.ShowMessage('A new password has been emailed to ' + UserName + '.')
  else WebApplication.ShowMessage('The new password was unable to be emailed to ' + UserName + '.');

  UserSession.AdminLog(UserID, itUser, 'Password changed for ' + UserName);
end;

//*** Helper Functions *********************************************************

procedure TfrmUsers.LoadUsers(FilterCond: string);
begin
  {Populate the user drop-down with all users that have the Run WebRel permission,
   except for the administrator and the user templates; Add a TUserCode object
   for each user to store the UserCode and enforce uniqueness within the drop-
   down; Select the first user;}

  cbUser.Items.Clear;

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select a.username as username, a.usercode as usercode from users a ');
    Sql.Add('where a.userid <> 0 and a.template = 0 ');
    Sql.Add('and exists (select * from userpermissions b ');
    Sql.Add('where a.userid = b.userid and permissionid = :ppermissionid) ');
    Sql.Add(FilterCond);
    ParamByName('ppermissionid').AsInteger:= pidRunWebRel;
    Open;

    while not eof do
    begin
      cbUser.Items.AddObject(FieldByName('UserName').AsString, TUserCode.Create(FieldByName('UserCode').AsString));
      Next;
    end;

    if cbUser.Items.Count > 0 then cbUser.ItemIndex:= 0;
  end;
end;

//*** Event Handlers ***********************************************************

{Show the corresponding form for the button clicked and release the current form;}

procedure TfrmUsers.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmUsers.bnReturnAdminClick(Sender: TObject);
begin
  TfrmAdmin.Create(WebApplication).Show;
  Release;
end;

procedure TfrmUsers.edFilterUserSubmit(Sender: TObject);
var
FilterCond, Contains: string;
begin
  if cbContainsUser.Checked then Contains:= '%' else Contains:= '';
  FilterCond:= 'and a.username like ''' + Contains + Trim(edFilterUser.Text) + '%'' ';
  LoadUsers(FilterCond);
end;

//******************************************************************************

end.
