unit uWRedDealers;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompEdit, IWCompButton,
  IWCompCheckbox, IWCompLabel, Classes, Controls, IWControl, IWCompListbox,
  IWCompMemo;

type
  TDealerState = (dsNil, dsNew, dsEdit);

  TfrmedDealers = class(TIWAppForm)
    cbParent: TIWComboBox;
    lblParent: TIWLabel;
    cbDealerType: TIWComboBox;
    lblDealerType: TIWLabel;
    cbSuspended: TIWCheckBox;
    bnSaveChanges: TIWButton;
    bnReturnAdmin: TIWButton;
    bnReturnMain: TIWButton;
    edDealerName: TIWEdit;
    lblDealerName: TIWLabel;
    lblhdrDealers: TIWLabel;
    bnCancel: TIWButton;
    memoDealer: TIWMemo;
    lblDealerNotes: TIWLabel;
    edEmail: TIWEdit;
    lblEmail: TIWLabel;
    cbActive: TIWCheckBox;
    bnFilterDealer: TIWButton;
    edFilterDealer: TIWEdit;
    cbContainsDealer: TIWCheckBox;
    lblDealerCode: TIWLabel;
    edDealerCode: TIWEdit;
    procedure bnReturnAdminClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnSaveChangesClick(Sender: TObject);
    procedure bnCancelClick(Sender: TObject);
    procedure edFilterDealerSubmit(Sender: TObject);
  private
    procedure DoAdminLog(NotesStr: string);
    function isDealerNameInUse: boolean;
    function isNameChanged: boolean;
    function HasUsersOrCustomers: boolean;
    function HasChildren(const sDealerName : string) : boolean;
  public
    DealerState: TDealerState;
    GroupID: integer;

    OriginalName: string;
    InitParent: integer;
    InitType: integer;
    InitEmail: string;
    InitNotes: string;
    InitActive: boolean;
    InitSuspended: boolean;

    procedure LoadParentCombo(FilterCond: string);
  end;

implementation

{$R *.dfm}

uses uWRServer, uWRData, uWRAdmin, uWRSite, uWRDealers, SysUtils;

//******************************************************************************

procedure TfrmedDealers.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmedDealers.bnReturnAdminClick(Sender: TObject);
begin
  TfrmAdmin.Create(WebApplication).Show;
  Release;
end;

//******************************************************************************

procedure TfrmedDealers.bnSaveChangesClick(Sender: TObject);
var
LineIndex, MaxID, ParentID: integer;
NotesStr, LogString: string;
begin
  if Trim(edDealerName.Text) = '' then
  begin
    WebApplication.ShowMessage('Please specify a name for the new dealer.');
    Exit;
  end;

  if Trim(cbParent.Text) = '' then
  begin
    WebApplication.ShowMessage('You must select a parent from the parent drop-down list.');
    Exit;
  end;

  if cbParent.Text = edDealerName.Text then
  begin
    WebApplication.ShowMessage('A dealer can not have itself as parent. Please select a new parent.');
    Exit;
  end;

  if isDealerNameInUse then
  begin
    WebApplication.ShowMessage('This dealer name is already in use. Please choose another.');
    Exit;
  end;

  if Trim(edEmail.Text) = '' then
  begin
    WebApplication.ShowMessage('You must specify an email address for this dealer.');
    Exit;
  end
  else if not UserSession.isValidEmail(edEmail.Text) then Exit;

  if Length(Trim(edEmail.Text)) > 50 then
  begin
    WebApplication.ShowMessage('The email address is limited to 50 characters. Please contact technical support for extension.');
    Exit;
  end;

  if not(cbActive.Checked) and HasUsersOrCustomers then
  begin
    WebApplication.ShowMessage('This dealer has active customers.' + #13#10#13#10 + 'Dealers cannot be deactivated until all their customers have been first removed or deactivated.');
    Exit;
  end;

  if not(InitActive) and InitSuspended and not(cbActive.Checked) and not(cbSuspended.Checked) then
  begin
    WebApplication.ShowMessage('An inactive dealer must also be suspended to ensure its users cannot login.');
    Exit;
  end;

  // AB - 9
  // Itemindex 0 is Dealer.
  if (cbDealerType.ItemIndex = 0) and (HasChildren(edDealerName.Text)) then
  begin
    WebApplication.ShowMessage('Cannot change this distributor to a dealer.' + #13#10#13#10 +
                               'This distributor is a "parent" to other dealers. ' +
                               'Dealers must be attached to a distributor or HQ.');
    Exit;
  end;

  MaxID:= 0;
  NotesStr:= '';
  with memoDealer, Lines do
  begin
    for LineIndex:= 0 to Count - 2 do NotesStr:= NotesStr + Lines[LineIndex] + #13#10;
    if Count > 0 then NotesStr:= NotesStr + Lines[Count - 1];
  end;
  NotesStr:= Copy(NotesStr, 1, 250);

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select groupid from usergroups where groupdesc = :pgroupdesc ');
    ParamByName('pgroupdesc').AsString:= cbParent.Text;
    Open;
    ParentID:= FieldByName('GroupID').AsInteger;

    Close;
    Sql.Clear;

    case DealerState of
      dsNew:
      begin
        Sql.Add('select max(groupid) from usergroups ');
        Open;
        MaxID:= Fields[0].AsInteger;

        Close;
        Sql.Clear;
        Sql.Add('insert into usergroups '+
                '(groupid, parentid, groupdesc, grouptype, userdef1, groupactive, groupnotes, active, linkcode) ');
        Sql.Add('values (:pgroupid, :pparentid, :pgroupdesc, :pgrouptype, ' +
                ':puserdef1, :pgroupactive, :pgroupnotes, :pactive, :plinkcode) ');
        ParamByName('pgroupid').AsInteger:= MaxID + 1;
      end;
      dsEdit:
      begin
        Sql.Add('update usergroups set groupdesc = :pgroupdesc, grouptype = :pgrouptype, ');
        Sql.Add('parentid = :pparentid, userdef1 = :puserdef1, groupactive = :pgroupactive, ');
        // AB - 10 
        Sql.Add('groupnotes = :pgroupnotes, active = :pactive, linkcode = :plinkcode where groupid = :pgroupid ');
        ParamByName('pgroupid').AsInteger:= GroupID;
      end;
    end;

    ParamByName('pparentid').AsInteger:= ParentID;
    ParamByName('pgroupdesc').AsString:= Copy(Trim(edDealerName.Text), 1, 30);
    // AB - 10
    ParamByName('plinkcode').AsString := Copy(trim(edDealerCode.Text),1,6);

    ParamByName('pgrouptype').AsInteger:= cbDealerType.ItemIndex + 1;
    ParamByName('puserdef1').AsString:= Copy(Trim(edEmail.Text), 1, 50);
    ParamByName('pgroupnotes').AsString:= Copy(NotesStr, 1, 250);
    ParamByName('pactive').AsBoolean:= cbActive.Checked;
    if not cbActive.Checked then cbSuspended.Checked:= true;
    ParamByName('pgroupactive').AsBoolean:= not cbSuspended.Checked;
    ExecSql;

    case DealerState of
      dsNew:
      begin
        LogString:= 'New Dealer inserted - Name:' + Copy(Trim(edDealerName.Text), 1, 30) + ', Parent:' + cbParent.Text + ', Type:' + cbDealerType.Text + ', Email:' + edEmail.Text;
        UserSession.AdminLog(MaxID + 1, itDealer, Copy(LogString, 1, 250));
      end;
      dsEdit: DoAdminLog(NotesStr);
    end;

    TfrmDealers.Create(WebApplication).Show;
    if DealerState = dsNew then WebApplication.ShowMessage('The ' + cbDealerType.Text + ' ' + Copy(Trim(edDealerName.Text), 1, 30) + ' has been added successfully.')
    else WebApplication.ShowMessage('The ' + cbDealerType.Text + ' ' + Copy(Trim(edDealerName.Text), 1, 50) + ' has been updated successfully.');
  end;

  Release;
end;

procedure TfrmedDealers.bnCancelClick(Sender: TObject);
begin
  TfrmDealers.Create(WebApplication).Show;
  Release;  
end;

//*** Helper Functions *********************************************************

function TfrmedDealers.isDealerNameInUse: boolean;
begin
  Result:= false;

  if (DealerState = dsNew) or isNameChanged then with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select count(groupdesc) from usergroups ');
    Sql.Add('where groupdesc = :pgroupdesc ');
    ParamByName('pgroupdesc').AsString:= Copy(Trim(edDealerName.Text), 1, 30);
    Open;

    Result:= Fields[0].AsInteger > 0;
  end;
end;

function TfrmedDealers.isNameChanged: boolean;
begin
  Result:= OriginalName <> Trim(edDealerName.Text);
end;

function TfrmedDealers.HasUsersOrCustomers: boolean;
begin
  {Determines whether the dealer about to be deactivated has active associated
   with it; If so, the deactivation is prevented;}

  Result:= false;

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select count(custid) from customers ');
    Sql.Add('where active = 1 and groupid = :pgroupid ');
    ParamByName('pgroupid').AsInteger:= GroupID;
    Open;

    if Fields[0].AsInteger > 0 then Result:= true;
  end;
end;

function TfrmedDealers.HasChildren(const sDealerName : string) : boolean;
var
  iParentID : integer;
begin
  Result := FALSE;

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select parentid from usergroups ');
    Sql.Add('where active = 1 and parentid = :ssgroupid ');
    // GroupID is a module-wide variable set after FormCreate by the parent form.
    ParamByName('ssgroupid').AsInteger := GroupID;
    Open;

    iParentID := (Fields[0].AsInteger);
    if (iParentID = GroupID) then
      Result := TRUE;

  end;
end;

procedure TfrmedDealers.LoadParentCombo(FilterCond: string);
begin
  {Dealers cannot hang off other dealers; Distributors can hang off the root
   parent only;}

  cbParent.Items.Clear;

  with WRData, qySecondary do
  begin
    Close;
    Sql.Clear;

    case cbDealerType.ItemIndex of
      0: Sql.Add('select groupdesc from usergroups where grouptype <> 1 ');
      1: Sql.Add('select groupdesc from usergroups where groupid = 1 and parentid = 0 ');
    end;
    Sql.Add(FilterCond);
    Open;

    while not eof do
    begin
      if FieldByName('GroupDesc').AsString <> OriginalName then cbParent.Items.Add(FieldByName('GroupDesc').AsString);
      Next;
    end;

    if cbParent.Items.Count > 0 then cbParent.ItemIndex:= 0;
  end;
end;

procedure TfrmedDealers.DoAdminLog(NotesStr: string);
var
BuildStr: string;
begin
  {When a dealer is edited, only those fields that have been changed are logged
   to the AdminLog table;}

  BuildStr:= '';

  with UserSession do
  begin
    if OriginalName <> Copy(Trim(edDealerName.Text), 1, 30) then BuildStr:= BuildStr + 'Name:' + Copy(Trim(edDealerName.Text), 1, 30) + ', ';
    if InitType <> cbDealerType.ItemIndex then BuildStr:= BuildStr + 'Type:' + cbDealerType.Text + ', ';
    if InitParent <> cbParent.ItemIndex then BuildStr:= BuildStr + 'Parent:' + cbParent.Text + ', ';
    if InitEmail <> Copy(Trim(edEmail.Text), 1, 50) then BuildStr:= BuildStr + 'Email:' + Copy(Trim(edEmail.Text), 1, 50) + ', ';
    if InitNotes <> NotesStr then BuildStr:= BuildStr + 'Notes Changed, ';
    if InitSuspended <> cbSuspended.Checked then
    begin
      if cbSuspended.Checked then BuildStr:= BuildStr + 'Suspended, '
      else BuildStr:= BuildStr + 'Unsuspended, ';
    end;
    if InitActive <> cbActive.Checked then
    begin
      if cbActive.Checked then BuildStr:= BuildStr + 'Activated, '
      else BuildStr:= BuildStr + 'Deactivated, ';
    end;

    Delete(BuildStr, Length(BuildStr) - 1, 2);
    AdminLog(GroupID, itDealer, 'Dealer ' + OriginalName + ' updated - ' + Copy(BuildStr, 1, 250));
  end;
end;

//*** Event Handlers ***********************************************************

procedure TfrmedDealers.edFilterDealerSubmit(Sender: TObject);
var
FilterCond, Contains: string;
begin
  if cbContainsDealer.Checked then Contains:= '%' else Contains:= '';
  FilterCond:= 'and groupdesc like ''' + Contains + Trim(edFilterDealer.Text) + '%'' ';
  LoadParentCombo(FilterCond);
end;

//******************************************************************************

end.
