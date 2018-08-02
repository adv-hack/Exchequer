unit uWRedCustomers;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompEdit, IWCompListbox,
  IWCompButton, Classes, Controls, IWControl, IWCompLabel, IWCompMemo,
  IWCompText, IWCompCheckbox, IWGrids;

type
  TCustomerState = (csNil, csNew, csEdit);

  TESNID = class
  public
    ESNID: integer;
    constructor Create(NewESNID: integer); reintroduce; overload;
  end;

  TfrmedCustomers = class(TIWAppForm)
    lblCustomer: TIWLabel;
    lblParent: TIWLabel;
    bnSaveChanges: TIWButton;
    bnReturnAdmin: TIWButton;
    bnReturnMain: TIWButton;
    lblhdrCustomers: TIWLabel;
    bnCancel: TIWButton;
    cbParent: TIWComboBox;
    edCustomer: TIWEdit;
    memoCustomer: TIWMemo;
    lblCustNotes: TIWLabel;
    lblEditESN: TIWLabel;
    bnNewESN: TIWButton;
    bnEditESN: TIWButton;
    txtESN: TIWText;
    lblCustESNs: TIWLabel;
    lbESN: TIWListbox;
    lblActive: TIWLabel;
    cbRestrict30: TIWCheckBox;
    cbActive: TIWCheckBox;
    gdThresholds: TIWGrid;
    lblThresholds: TIWLabel;
    bnThresholds: TIWButton;
    txtThresholds: TIWText;
    lblNoOverrides: TIWLabel;
    bnFilterCust: TIWButton;
    edFilterCust: TIWEdit;
    cbContainsCust: TIWCheckBox;
    lblCustomerCode: TIWLabel;
    edCustomerCode: TIWEdit;
    procedure bnReturnAdminClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnCancelClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure bnSaveChangesClick(Sender: TObject);
    procedure bnNewESNClick(Sender: TObject);
    procedure bnEditESNClick(Sender: TObject);
    procedure bnThresholdsClick(Sender: TObject);
    procedure edFilterCustSubmit(Sender: TObject);
  private
    procedure DoAdminLog(NotesStr: string);
    procedure LoadDealers(FilterCond: string);
    function isDealerInactive: boolean;
  public
    CustID: integer;
    CustState: TCustomerState;
    OriginalName: string;
    InitNotes: string;
    InitRestricted: boolean;
    InitActive: boolean;
    InitParent: integer;
    procedure LoadThresholds(ThresholdGrid: TIWGrid);
  end;

implementation

{$R *.dfm}

uses uWRServer, uWRData, uWRSite, uWRAdmin, uWRCustomers, uWRedESNs, uWRThresholds,
     uCodeIDs, Graphics, SysUtils;

//*** TESNID *******************************************************************

constructor TESNID.Create(NewESNID: integer);
begin
  Create;
  ESNID:= NewESNID;
end;

//******************************************************************************

procedure TfrmedCustomers.bnReturnAdminClick(Sender: TObject);
begin
  TfrmAdmin.Create(WebApplication).Show;
  Release;
end;

procedure TfrmedCustomers.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmedCustomers.bnCancelClick(Sender: TObject);
begin
  TfrmCustomers.Create(WebApplication).Show;
  Release;
end;

//******************************************************************************

procedure TfrmedCustomers.IWAppFormCreate(Sender: TObject);
begin
  LoadDealers('');
end;

procedure TfrmedCustomers.LoadThresholds(ThresholdGrid: TIWGrid);
var
RowIndex: integer;
begin
  with WRData.qyPrimary, ThresholdGrid do
  begin
    Clear;
    RowCount:= 1;

    Close;
    Sql.Clear;
    Sql.Add('select a.threshold as threshold, a.period as period, b.codedesc as codedesc ');
    Sql.Add('from thresholds a inner join codetypes b on a.codeid = b.codeid ');
    Sql.Add('where a.codeid not in (8, 9, 10, 11) and a.custid = :pcustid ');
    Sql.Add('order by b.codedesc ');
    ParamByName('pcustid').AsInteger:= CustID;
    Open;

    RowIndex:= 0;

    if not eof then
    begin
      Cell[RowIndex, 0].Text:= 'Password / Release Code';
      Cell[RowIndex, 1].Text:= 'Threshold';
      Cell[RowIndex, 0].Font.Style:= Cell[RowIndex, 0].Font.Style + [fsBold];
      Cell[RowIndex, 1].Font.Style:= Cell[RowIndex, 1].Font.Style + [fsBold];

      while not eof do
      begin
        RowCount:= RowCount + 1;
        inc(RowIndex);

        Cell[RowIndex, 0].Text:= FieldByName('CodeDesc').AsString;
        Cell[RowIndex, 1].Text:= FieldByName('Threshold').AsString + ' every ' + FieldByName('Period').AsString + ' days';
        Next;
      end;
    end;

    Close;
    Sql.Clear;
    Sql.Add('select a.threshold as threshold, a.period as period, a.codeid as codeid, ');
    Sql.Add('b.modulename as modulename, b.plugin as plugin, b.usercount as usercount ');
    Sql.Add('from thresholds a inner join modules b on a.moduleid = b.moduleid ');
    Sql.Add('where a.codeid in (8, 9, 10, 11) and a.custid = :pcustid ');
    Sql.Add('order by b.plugin, a.codeid, b.modulename ');
    ParamByName('pcustid').AsInteger:= CustID;
    Open;

    if not eof then
    begin
      if RowCount > 1 then
      begin
        inc(RowIndex);
        RowCount:= RowCount + 1;
        Cell[RowIndex, 0].Text:= ' ';
        Cell[RowIndex, 1].Text:= ' ';
      end;

      inc(RowIndex);
      RowCount:= RowCount + 1;
      Cell[RowIndex, 0].Text:= 'Module / Plug-In Release Code';
      Cell[RowIndex, 1].Text:= 'Threshold';
      Cell[RowIndex, 0].Font.Style:= Cell[RowIndex, 0].Font.Style + [fsBold];
      Cell[RowIndex, 1].Font.Style:= Cell[RowIndex, 1].Font.Style + [fsBold];

      while not eof do
      begin
        RowCount:= RowCount + 1;
        inc(RowIndex);

        case FieldByName('CodeID').AsInteger of
          8: Cell[RowIndex, 0].Text:= 'Module - ' + FieldByName('ModuleName').AsString;
          9: Cell[RowIndex, 0].Text:= 'Module - User Count - ' + FieldByName('ModuleName').AsString;
          10: Cell[RowIndex, 0].Text:= 'Plug-In - ' + FieldByName('ModuleName').AsString;
          11: Cell[RowIndex, 0].Text:= 'Plug-In - User Count - ' + FieldByName('ModuleName').AsString;
        end;

        Cell[RowIndex, 1].Text:= FieldByName('Threshold').AsString + ' every ' + FieldByName('Period').AsString + ' days';
        Next;
      end;
    end;

    Visible:= RowCount > 1;
    lblNoOverrides.Visible:= RowCount <= 1;
  end;
end;

procedure TfrmedCustomers.bnSaveChangesClick(Sender: TObject);
var
LineIndex, MaxCustID, MaxESNID, ParentID: integer;
NotesStr, LogString: string;
begin
  if Trim(edCustomer.Text) = '' then
  begin
    WebApplication.ShowMessage('Please specify a name for the new customer.');
    Exit;
  end;

  if Trim(cbParent.Text) = '' then
  begin
    WebApplication.ShowMessage('You must select a parent from the parent drop-down list.');
    Exit;
  end;

  if not(InitActive) and cbActive.Checked and IsDealerInactive then
  begin
    WebApplication.ShowMessage('This customer will belong to an inactive dealer.' + #13#10#13#10 + 'Either reactivate the dealer or move the customer to an active dealer.');
    Exit;
  end;

  MaxCustID:= 0;
  NotesStr:= '';
  with memoCustomer, Lines do
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

    case CustState of
      csNew:
      begin
        Sql.Add('select max(custid) from customers ');
        Open;
        MaxCustID:= Fields[0].AsInteger;

        Close;
        Sql.Clear;                                                     
        Sql.Add('select max(esnid) from esns ');
        Open;
        MaxESNID:= Fields[0].AsInteger;

        Close;
        Sql.Clear;
        Sql.Add('insert into esns (esnid, custid, esn, version, esnnotes, unspecified, active) ');
        Sql.Add('values(:pesnid, :pcustid, :pesn, :pversion, '''', 1, 1) ');
        ParamByName('pesnid').AsInteger:= MaxESNID + 1;
        ParamByName('pcustid').AsInteger:= MaxCustID + 1;
        ParamByName('pesn').AsString:= '000-000-000-000-000-000-000';
        ParamByName('pversion').AsString:= version5;
        ExecSql;

        Close;
        Sql.Clear;
        // AB - 10
        Sql.Add('insert into customers (custid, groupid, custname, custnotes, restricted, active, linkcode) ');
        Sql.Add('values (:pcustid, :pgroupid, :pcustname, :pcustnotes, :prestricted, :pactive, :plinkcode) ');
        ParamByName('pcustid').AsInteger:= MaxCustID + 1;
      end;
      csEdit:
      begin
        Sql.Add('update customers set groupid = :pgroupid, custname = :pcustname, ');
        Sql.Add('custnotes = :pcustnotes, restricted = :prestricted, active = :pactive, ');
        // AB - 10
        Sql.Add('linkcode = :plinkcode ');
        Sql.Add('where custid = :pcustid ');
        ParamByName('pcustid').AsInteger:= CustID;
      end;
    end;

    ParamByName('pgroupid').AsInteger:= ParentID;
    ParamByName('pcustname').AsString:= Copy(Trim(edCustomer.Text), 1, 50);
    ParamByName('pcustnotes').AsString:= NotesStr;
    ParamByName('prestricted').AsBoolean:= cbRestrict30.Checked;
    ParamByName('pactive').AsBoolean:= cbActive.Checked;
    // AB - 10
    ParamByName('plinkcode').AsString := Copy(trim(edCustomerCode.Text),1,6);
    ExecSql;

    case CustState of
      csNew:
      begin
        LogString:= 'New Customer inserted - Name:' + Copy(Trim(edCustomer.Text), 1, 50) + ', Dealer:' + cbParent.Text;
        if cbRestrict30.Checked then LogString:= LogString + ', Restricted to 30 day codes' else LogString:= LogString + ', No restrictions';
        if cbActive.Checked then LogString:= LogString + ', Active' else LogString:= LogString + ', Inactive';
        // AB - 10
        if (length(edCustomerCode.Text) > 0) then LogString := LogString + ', Customer code: ' + edCustomerCode.Text;
        UserSession.AdminLog(MaxCustID + 1, itCustomer, Copy(LogString, 1, 250));
      end;
      csEdit: DoAdminLog(NotesStr);
    end;

    TfrmCustomers.Create(WebApplication).Show;
    if CustState = csNew then WebApplication.ShowMessage('The customer ' + Copy(Trim(edCustomer.Text), 1, 50) + ' has been added successfully.')
    else WebApplication.ShowMessage('The customer ' + Copy(Trim(edCustomer.Text), 1, 50) + ' has been updated successfully.');
  end;

  Release;
end;

procedure TfrmedCustomers.DoAdminLog(NotesStr: string);
var
BuildStr: string;
begin
  {When a customer is edited, only those fields that have been changed are logged
   to the AdminLog table;}

  BuildStr:= '';

  with UserSession do
  begin
    if OriginalName <> Copy(Trim(edCustomer.Text), 1, 50) then BuildStr:= BuildStr + 'Name:' + Copy(Trim(edCustomer.Text), 1, 50) + ', ';
    if InitParent <> cbParent.ItemIndex then BuildStr:= BuildStr + 'Dealer:' + cbParent.Text + ', ';
    if InitNotes <> NotesStr then BuildStr:= BuildStr + 'Notes Changed, ';
    if InitRestricted <> cbRestrict30.Checked then
    begin
      if cbRestrict30.Checked then BuildStr:= BuildStr + 'Restricted to 30-day codes only, ' else BuildStr:= BuildStr + '30-day code restriction removed, ';
    end;
    if InitActive <> cbActive.Checked then
    begin
      if cbActive.Checked then BuildStr:= BuildStr + 'Activated, ' else BuildStr:= BuildStr + 'Deactivated, ';
    end;

    Delete(BuildStr, Length(BuildStr) - 1, 2);
    AdminLog(Self.CustID, itCustomer, 'Customer ' + OriginalName + ' updated - ' + Copy(BuildStr, 1, 250));
  end;
end;

procedure TfrmedCustomers.bnNewESNClick(Sender: TObject);
begin
  with TfrmedESNs.Create(WebApplication) do
  begin
    CustID:= Self.CustID;
    CustName:= Self.OriginalName;
    ESNState:= esNew;
    LoadVersions;
    Show;
  end;

  Release;
end;

procedure TfrmedCustomers.bnEditESNClick(Sender: TObject);
begin
  if Trim(lbESN.Text) = '' then
  begin
    WebApplication.ShowMessage('Please select an ESN from the Edit ESN drop-down box.');
    Exit;
  end;

  with WRData.qyPrimary, TfrmedESNs.Create(WebApplication) do
  begin
    ESNState:= esEdit;
    CustID:= Self.CustID;
    CustName:= Self.OriginalName;
    OriginalESN:= Copy(lbESN.Text, 1, 27);
    ESNID:= TESNID(lbESN.Items.Objects[lbESN.ItemIndex]).ESNID;
    edESN.Text:= Copy(lbESN.Text, 1, 27);
    LoadVersions;
    
    Close;
    Sql.Clear;
    Sql.Add('select version, esnnotes, unspecified, active ');
    Sql.Add('from esns where esnid = :pesnid ');
    ParamByName('pesnid').AsInteger:= ESNID;
    Open;

    cbVersion.ItemIndex:= cbVersion.Items.IndexOf(FieldByName('Version').AsString);
    memoESN.Lines.Add(FieldByName('ESNNotes').AsString);
    cbUnspecified.Checked:= FieldByName('Unspecified').AsBoolean;
    cbActive.Checked:= FieldByName('Active').AsBoolean;

    ESNVersion:= cbVersion.ItemIndex;
    ESNUnspecified:= cbUnspecified.Checked;
    ESNActive:= FieldByName('Active').AsBoolean;
    ESNNotes:= FieldByName('ESNNotes').AsString;

    Show;
  end;

  Release;
end;

procedure TfrmedCustomers.bnThresholdsClick(Sender: TObject);
begin
  with TfrmThresholds.Create(WebApplication) do
  begin
    lblhdrThresholds.Caption:= OriginalName + ' Thresholds';
    bnNew.Visible:= false;
    lblReleaseCodes.Visible:= false;
    cbRelCode.Visible:= false;
    bnReturnCust.Visible:= true;
    InitThresholds(CustID, Self);
    Show;
  end;
end;

procedure TfrmedCustomers.edFilterCustSubmit(Sender: TObject);
var
FilterCond, Contains: string;
begin
  if cbContainsCust.Checked then Contains:= '%' else Contains:= '';
  FilterCond:= 'where groupdesc like ''' + Contains + Trim(edFilterCust.Text) + '%'' ';
  LoadDealers(FilterCond);
end;

//*** Helper functions *********************************************************

procedure TfrmedCustomers.LoadDealers(FilterCond: string);
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

function TfrmedCustomers.isDealerInactive: boolean;
begin
  {Checks whether the customer being edited is associated with an active dealer;
   If not, the customer cannot be reactivated;}

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select active from usergroups where groupdesc = :pgroupdesc ');
    ParamByName('pgroupdesc').AsString:= Trim(cbParent.Text);
    Open;

    Result:= not FieldByName('Active').AsBoolean;
  end;
end;

//******************************************************************************

end.
