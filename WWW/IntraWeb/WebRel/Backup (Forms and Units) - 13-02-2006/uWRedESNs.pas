unit uWRedESNs;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompMemo, IWCompButton, IWCompLabel,
  Classes, Controls, IWControl, IWCompEdit, IWCompCheckbox, IWCompListbox;

type
  TESNState = (esNil, esNew, esEdit);

  TfrmedESNs = class(TIWAppForm)
    edESN: TIWEdit;
    lblESN: TIWLabel;
    lblCustESNs: TIWLabel;
    memoESN: TIWMemo;
    lblESNNotes: TIWLabel;
    bnSaveChanges: TIWButton;
    bnCancel: TIWButton;
    cbUnspecified: TIWCheckBox;
    cbActive: TIWCheckBox;
    lblVersion: TIWLabel;
    cbVersion: TIWComboBox;
    bnReturnAdmin: TIWButton;
    bnReturnMain: TIWButton;
    procedure bnReturnAdminClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnCancelClick(Sender: TObject);
    procedure bnSaveChangesClick(Sender: TObject);
  private
    procedure DoAdminLog(NotesStr: string);
    procedure RestoreCustomerPage;
    function isUniqueActiveESN: boolean;
    function isUnspecifiable: boolean;
  public
    CustID: integer;
    CustName: string;
    ESNActive: boolean;
    ESNID: integer;
    ESNNotes: string;
    ESNUnspecified: boolean;
    ESNVersion: integer;
    ESNState: TESNState;
    OriginalESN: string;
    procedure LoadVersions;
  end;

implementation

{$R *.dfm}

uses uWRServer, uWRSite, uWRAdmin, uWRedCustomers, uWRData, uCodeIDs, SysUtils;

//******************************************************************************

procedure TfrmedESNs.bnReturnAdminClick(Sender: TObject);
begin
  TfrmAdmin.Create(WebApplication).Show;
  Release;
end;

procedure TfrmedESNs.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmedESNs.bnCancelClick(Sender: TObject);
begin
  RestoreCustomerPage;
end;

procedure TfrmedESNs.RestoreCustomerPage;
begin
  with WRData.qyPrimary, TfrmedCustomers.Create(WebApplication) do
  begin
    CustState:= csEdit;
    OriginalName:= Self.CustName;
    CustID:= Self.CustID;
    edCustomer.Text:= Self.CustName;

    Close;
    Sql.Clear;
    Sql.Add('select a.custnotes as custnotes, b.groupdesc as groupdesc ');
    Sql.Add('from customers a left join usergroups b on a.groupid = b.groupid ');
    Sql.Add('where a.custid = :pcustid ');
    ParamByName('pcustid').AsInteger:= Self.CustID;
    Open;

    cbParent.ItemIndex:= cbParent.Items.IndexOf(FieldByName('GroupDesc').AsString);
    memoCustomer.Lines.Add(FieldByName('CustNotes').AsString);

    Close;
    Sql.Clear;
    Sql.Add('select esnid, esn, active from esns where custid = :pcustid ');
    ParamByName('pcustid').AsInteger:= Self.CustID;
    Open;

    with lbESN.Items as TStringList do Duplicates:= dupAccept;

    while not eof do
    begin
      if FieldByName('Active').AsBoolean then lbESN.Items.AddObject(FieldByName('ESN').AsString + ' *', TESNID.Create(FieldByName('ESNID').AsInteger))
      else lbESN.Items.AddObject(FieldByName('ESN').AsString, TESNID.Create(FieldByName('ESNID').AsInteger));
      Next;
    end;

    if lbESN.Items.Count > 0 then lbESN.ItemIndex:= 0;
    Show;
  end;

  Release;
end;

//******************************************************************************

procedure TfrmedESNs.bnSaveChangesClick(Sender: TObject);
var
LineIndex, MaxID: integer;
ValidESN: boolean;
NotesStr, LogString: string;
begin
  // AB - 4
  ValidESN := ((Length(edESN.Text) = 21) or (Length(edESN.Text) = 27)) and
                UserSession.isValidESN(Trim(edESN.Text));

  if (Trim(edESN.Text) = '') or not(ValidESN) then
  begin
    WebApplication.ShowMessage('Please specify a valid ESN.');
    Exit;
  end;

  if not isUniqueActiveESN then
  begin
    WebApplication.ShowMessage('This ESN already exists and is active for this customer.');
    Exit;
  end;

  if cbUnspecified.Checked and cbActive.Checked and not(isUnspecifiable) then
  begin
    WebApplication.ShowMessage('A customer may not have more than one unspecified active ESN.');
    Exit;
  end;

  NotesStr:= '';
  with memoESN, Lines do
  begin
    for LineIndex:= 0 to Count - 2 do NotesStr:= NotesStr + Lines[LineIndex] + #13#10;
    if Count > 0 then NotesStr:= NotesStr + Lines[Count - 1];
  end;
  NotesStr:= Copy(NotesStr, 1, 250);

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select max(esnid) from esns ');
    Open;
    MaxID:= Fields[0].AsInteger;

    Close;
    Sql.Clear;
    case ESNState of
      esNew:
      begin
        Sql.Add('insert into esns (esnid, custid, esn, esnnotes, version, unspecified, active) ');
        Sql.Add('values (:pesnid, :pcustid, :pesn, :pesnnotes, :pversion, :punspecified, :pactive) ');
        ParamByName('pesnid').AsInteger:= MaxID + 1;
      end;
      esEdit:
      begin
        Sql.Add('update esns set custid = :pcustid, esn = :pesn, esnnotes = :pesnnotes, ');
        Sql.Add('version = :pversion, unspecified = :punspecified, active = :pactive ');
        Sql.Add('where esnid = :pesnid ');
        ParamByName('pesnid').AsInteger:= ESNID;
      end;
    end;
    ParamByName('pcustid').AsInteger:= CustID;
    ParamByName('pesn').AsString:= UserSession.GetESN(edESN.Text);
    ParamByName('pesnnotes').AsString:= NotesStr;
    ParamByName('pversion').AsString:= cbVersion.Text;
    ParamByName('punspecified').AsBoolean:= cbUnspecified.Checked;
    ParamByName('pactive').AsBoolean:= cbActive.Checked;
    ExecSql;

    case ESNState of
      esNew:
      begin
        LogString:= 'New ESN inserted - ESN:' + UserSession.GetESN(edESN.Text) + ', Version:' + cbVersion.Text;
        UserSession.AdminLog(MaxID + 1, itESN, Copy(LogString, 1, 250));
      end;
      esEdit: DoAdminLog(NotesStr);
    end;

    RestoreCustomerPage;

    if ESNState = esNew then WebApplication.ShowMessage('The ESN ' + UserSession.GetESN(edESN.Text) + ' has been added successfully for ' + CustName + '.')
    else WebApplication.ShowMessage('The ESN ' + UserSession.GetESN(edESN.Text) + ' has been updated successfully for ' + CustName + '.');
  end;
end;

procedure TfrmedESNs.DoAdminLog(NotesStr: string);
var
BuildStr: string;
begin
  {When an ESN is edited, only those fields that have been changed are logged
   to the AdminLog table;}

  BuildStr:= '';

  with UserSession do
  begin
    if OriginalESN <> UserSession.GetESN(edESN.Text) then BuildStr:= BuildStr + 'ESN:' + UserSession.GetESN(edESN.Text) + ', ';
    if ESNVersion <> cbVersion.ItemIndex then BuildStr:= BuildStr + 'Version:' + cbVersion.Text + ', ';
    if ESNNotes <> NotesStr then BuildStr:= BuildStr + 'Notes Changed, ';
    if ESNActive <> cbActive.Checked then
    begin
      if cbActive.Checked then BuildStr:= BuildStr + 'Activated, '
      else BuildStr:= BuildStr + 'Deactivated, ';
    end;
    if ESNUnspecified <> cbUnspecified.Checked then
    begin
      if cbUnspecified.Checked then BuildStr:= BuildStr + 'Unspecified, '
      else BuildStr:= BuildStr + 'Specified, ';
    end;

    Delete(BuildStr, Length(BuildStr) - 1, 2);
    AdminLog(Self.ESNID, itESN, 'ESN ' + OriginalESN + ' updated - ' + Copy(BuildStr, 1, 250));
  end;
end;

function TfrmedESNs.isUnspecifiable: boolean;
begin
  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select count(esnid) from esns ');
    Sql.Add('where esnid <> :pesnid and custid = :pcustid ');
    Sql.Add('and unspecified = 1 and active = 1 ');
    ParamByName('pesnid').AsInteger:= ESNID;
    ParamByName('pcustid').AsInteger:= CustID;
    Open;

    Result:= Fields[0].AsInteger = 0;
  end;
end;

function TfrmedESNs.isUniqueActiveESN: boolean;
begin
  Result:= true;

  if ESNState = esEdit then
  begin
    if ESNActive then Exit
    else if not cbActive.Checked then Exit;
  end;

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select count(esnid) from esns ');
    Sql.Add('where custid = :pcustid and esn = :pesn and active = 1 ');
    ParamByName('pcustid').AsInteger:= CustID;
    ParamByName('pesn').AsString:= UserSession.GetESN(edESN.Text);
    Open;

    Result:= Fields[0].AsInteger = 0;
  end;
end;

procedure TfrmedESNs.LoadVersions;
begin
  {Loads the version constants into the versions drop-down list;}

  with cbVersion, Items do
  begin
    Add(version430);
    Add(version430c);
    Add(version431);
    Add(version5);

    ItemIndex:= IndexOf(version5);
  end;
end;

end.
