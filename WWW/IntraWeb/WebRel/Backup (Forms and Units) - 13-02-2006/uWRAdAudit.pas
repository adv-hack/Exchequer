unit uWRAdAudit;

interface

uses
  IWAppForm, IWApplication, IWTypes, Classes, Controls, IWControl,
  IWCompButton, IWGrids, IWDBGrids, IWCompLabel, IWCompEdit, IWCompListbox,
  IWCompCheckbox;

type
  TfrmAdminAudit = class(TIWAppForm)
    bnReturnMain: TIWButton;
    bnReturnAdmin: TIWButton;
    cbUserCode: TIWComboBox;
    cbAuditType: TIWComboBox;
    edDateFrom: TIWEdit;
    edDateTo: TIWEdit;
    bnRetrieve: TIWButton;
    lblUserCode: TIWLabel;
    lblAuditType: TIWLabel;
    lblDate: TIWLabel;
    lblFrom: TIWLabel;
    lblTo: TIWLabel;
    dbgAudit: TIWDBGrid;
    bnPrevious: TIWButton;
    bnNext: TIWButton;
    lblFilters: TIWLabel;
    lblDescription: TIWLabel;
    edDescSubstr: TIWEdit;
    cbChanged: TIWComboBox;
    lblChanged: TIWLabel;
    cbSortAsc: TIWCheckBox;
    cbRetrieveAll: TIWCheckBox;
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnReturnAdminClick(Sender: TObject);
    procedure bnRetrieveClick(Sender: TObject);
    procedure bnPreviousClick(Sender: TObject);
    procedure bnNextClick(Sender: TObject);
    procedure cbAuditTypeChange(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    fPageNo: integer;
    fPageLow: integer;
    fPageHigh: integer;
    fTotalRecs: integer;
    procedure LoadDBNames(var TableName: string; var ColumnIDName: string; var ColumnName: string);
    procedure LoadRecs;
    function GetEntityCode: integer;
  end;

implementation

{$R *.dfm}

uses
  uWRServer, uWRAdmin, uWRSite, uWRData, uWRSecAudit, SysUtils, Dialogs;

//*** Startup and Shutdown *****************************************************

procedure TfrmAdminAudit.IWAppFormCreate(Sender: TObject);
begin
  {Ensure the DBGrid is not populated with an open AuditGrid dataset; Load the
   UserCode drop-down and initialise the date controls;}

  WRData.qyAuditGrid.Close;

  InitCombo(cbUserCode, 'UserCode', 'Users');
  edDateFrom.Text:= FormatDateTime('dd/mm/yyyy', Date - 7);
  edDateTo.Text:= FormatDateTime('dd/mm/yyyy', Date);
end;

//*** Retrieval Methods ********************************************************

procedure TfrmAdminAudit.LoadRecs;
var
DateFrom, DateTo: TDateTime;
RecIndex: integer;
begin
  {Verify the selected dates are valid, notifying the user and aborting if they
   are not; Disable the datasource for the duration of the DB query;}

  DateFrom:= StrToDateDef(edDateFrom.Text, 0);
  DateTo:= StrToDateDef(edDateTo.Text, 0) + 1;
  if (DateFrom = 0) or (DateTo = 1) then
  begin
    WebApplication.ShowMessage('The dates are invalid. Please ensure the dates are of the form ''dd/mm/yyyy''. ');
    Exit;
  end;

  WRData.dsAudit.Enabled:= false;


  {Retrieve audit records from the AdminLog table; Where filter drop-down
   selections have been made, add parameterised conditions to the query where
   clause; Add an order by clause consistent with checking of the SortAsc
   checkbox; Pass the parameters as needed and retrieve the resultset;}

  with WRData.qyAuditGrid do
  begin
    Close;
    Sql.Clear;

    Sql.Add('select a.auditid as "ID", a.auditstamp as "Timestamp", ');
    Sql.Add('b.usercode as "User Code", a.changedesc as "Description" ');
    Sql.Add('from ');
    Sql.Add('adminlog a left join users b on a.userid = b.userid ');
    Sql.Add('where ');
    if cbUserCode.ItemIndex >= 0 then Sql.Add('b.usercode = :pusercode and ');
    if cbAuditType.ItemIndex >= 0 then Sql.Add('a.idtype = :pidtype and ');
    if cbChanged.ItemIndex >= 0 then Sql.Add('a.idadministered = :pidadministered and ');
    if Trim(edDescSubstr.Text) <> '' then Sql.Add('a.changedesc like :pchangedesc and ');
    Sql.Add('a.auditstamp between :pdate1 and :pdate2 ');
    
    Sql.Add('order by ');
    if cbSortAsc.Checked then Sql.Add('auditstamp ') else Sql.Add('auditstamp desc ');

    ParamByName('pdate1').AsDateTime:= DateFrom;
    ParamByName('pdate2').AsDateTime:= DateTo;
    if cbUserCode.ItemIndex >= 0 then ParamByName('pusercode').AsString:= cbUserCode.Text;
    if cbAuditType.ItemIndex >= 0 then ParamByName('pidtype').AsInteger:= cbAuditType.ItemIndex + 1;
    if cbChanged.ItemIndex >= 0 then ParamByName('pidadministered').AsInteger:= GetEntityCode;
    if Trim(edDescSubstr.Text) <> '' then ParamByName('pchangedesc').AsString:= '%' + Trim(edDescSubstr.Text) + '%';

    Prepare;
    Open;


    {All records have been retrieved; If the Retrieve All box is checked, disable
     the previous and next buttons and reactivate the datasource;

     Otherwise position the cursor based on the upper and lower bounds of the
     current 15-record page; Store the page bounds and reissue the query with an
     additional predicate in the where clause; Reactivating the datasource then
     populates the DB Grid;}

    if not cbRetrieveAll.Checked then
    begin

      fTotalRecs:= RecordCount;
      for RecIndex:= 1 to (15 * fPageNo) do Next;
      fPageLow:= FieldByName('ID').AsInteger;
      for RecIndex:= 1 to 14 do Next;
      fPageHigh:= FieldByName('ID').AsInteger;

      bnPrevious.Enabled:= fPageNo > 0;
      bnNext.Enabled:= not eof;

      Close;
      if fPageLow <= fPageHigh then Sql.Insert(Sql.IndexOf('order by '), 'and a.auditid between :ppagelow and :ppagehigh ')
      else Sql.Insert(Sql.IndexOf('order by '), 'and a.auditid between :ppagehigh and :ppagelow ');
      ParamByName('ppagelow').AsInteger:= fPageLow;
      ParamByName('ppagehigh').AsInteger:= fPageHigh;
      Open;
      
    end
    else
    begin
      bnPrevious.Enabled:= false;
      bnNext.Enabled:= false;
    end;
  end;

  WRData.dsAudit.Enabled:= true;
end;

//*** Helper Functions *********************************************************

function TfrmAdminAudit.GetEntityCode: integer;
var
TableName, ColumnIDName, ColumnName: string;
begin
  {This function must get the ColumnID for the item selected in the Entity
   Changed drop-down; First load the necessary database entity names based on
   the selection in the AuditType drop-down; Then determine and return the ID
   value;}

  LoadDBNames(TableName, ColumnIDName, ColumnName);

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select ' + ColumnIDName + ' from ' + TableName + ' ');
    Sql.Add('where ' + ColumnName + ' = :pchanged ');
    ParamByName('pchanged').AsString:= cbChanged.Text;
    Open;

    Result:= FieldByName(ColumnIDName).AsInteger;
  end;
end;

procedure TfrmAdminAudit.LoadDBNames(var TableName: string; var ColumnIDName: string; var ColumnName: string);
begin
  {Set the reference variables to database specific entity strings for use in the
   AuditGrid query SQL; These strings include the table name for the current
   AuditType, the column name for entities being displayed in the Changed Entity
   drop-down, and the column name for the ID field;}

  case cbAuditType.ItemIndex + 1 of
    ord(itDealer):
    begin
      TableName:= 'UserGroups';
      ColumnIDName:= 'GroupID';
      ColumnName:= 'GroupDesc';
    end;
    ord(itUser):
    begin
      TableName:= 'Users';
      ColumnIDName:= 'UserID';
      ColumnName:= 'UserCode';
    end;
    ord(itCustomer):
    begin
      TableName:= 'Customers';
      ColumnIDName:= 'CustID';
      ColumnName:= 'CustName';
    end;
    ord(itESN):
    begin
      TableName:= 'ESNs';
      ColumnIDName:= 'ESNID';
      ColumnName:= 'ESN';
    end;
    ord(itModule):
    begin
      TableName:= 'Modules';
      ColumnIDName:= 'ModuleID';
      ColumnName:= 'ModuleName';
    end;
  end;
end;

//*** Event Handlers ***********************************************************

procedure TfrmAdminAudit.cbAuditTypeChange(Sender: TObject);
var
TableName, ColumnName, DummyName: string;
begin
  {If the Logins audit type is selected, clear the UserCode and EntityChanged
   drop-downs and exit; Otherwise ensure the UserCode drop-down is populated; If
   no selection has been made in the AuditType drop-down, exit; Otherwise retrieve
   the database names based on the current AuditType selection and populate the
   EntityChanged drop-down with the entity names associated with the current
   AuditType selection, e.g. specific dealers, customers, ESNs, users or modules;}

  cbChanged.Items.Clear;
  cbChanged.ItemIndex:= -1;

  if cbAuditType.ItemIndex + 1 = ord(itLogin) then
  begin
    cbUserCode.Items.Clear;
    Exit;
  end;

  if cbUserCode.Items.Count <= 0 then InitCombo(cbUserCode, 'UserCode', 'Users');
  if (cbAuditType.ItemIndex < 0) or (cbAuditType.ItemIndex + 1 = ord(itThreshold)) then Exit;

  LoadDBNames(TableName, DummyName, ColumnName);

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select ' + ColumnName + ' from ' + TableName + ' ');
    Open;

    while not eof do
    begin
      cbChanged.Items.Add(FieldByName(ColumnName).AsString);
      Next;
    end;
  end;
end;

procedure TfrmAdminAudit.bnRetrieveClick(Sender: TObject);
begin
  {Restore the PageNo field to 0 and load the records into the DB Grid;}

  fPageNo:= 0;
  LoadRecs;
end;

procedure TfrmAdminAudit.bnPreviousClick(Sender: TObject);
begin
  {Decrement the PageNo field if we are beyond the first page, and load the records
   for the new page into the DB Grid;}

  if fPageNo > 0 then dec(fPageNo);
  LoadRecs;
end;

procedure TfrmAdminAudit.bnNextClick(Sender: TObject);
begin
  {Increment the PageNo field if we are before the last page, and load the records
   for the new page into the DB Grid;}
  if fPageNo < (fTotalRecs div 15) then inc(fPageNo);
  LoadRecs;
end;

procedure TfrmAdminAudit.bnReturnMainClick(Sender: TObject);
begin
  {Recreate the site form and release the current form;}

  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmAdminAudit.bnReturnAdminClick(Sender: TObject);
begin
  {Recreate the admin form and release the current form;}

  TfrmAdmin.Create(WebApplication).Show;
  Release;
end;

//******************************************************************************

end.
