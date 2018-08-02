unit uWRSecAudit;

interface

uses
  IWAppForm, IWApplication, IWTypes, Classes, Controls, IWControl, uWRData,
  IWCompButton, IWCompLabel, IWCompEdit, IWCompMemo, IWCompListbox, DB,
  pvtables, sqldataset, IWGrids, IWDBGrids, IWDBStdCtrls, IWCompText,
  IWCompCheckbox;

type
  TOrderType = (otNil, otTimestamp, otUserCode, otDealership, otCustomer, otESN, otReleaseCode);
  
  TfrmSecAudit = class(TIWAppForm)
    cbUserCode: TIWComboBox;
    cbDealership: TIWComboBox;
    cbCustomer: TIWComboBox;
    cbESN: TIWComboBox;
    cbRelCode: TIWComboBox;
    edDateFrom: TIWEdit;
    edDateTo: TIWEdit;
    bnRetrieve: TIWButton;
    lblUserCode: TIWLabel;
    lblDealership: TIWLabel;
    lblCustomer: TIWLabel;
    lblESN: TIWLabel;
    lblRelCode: TIWLabel;
    lblDate: TIWLabel;
    lblFrom: TIWLabel;
    lblTo: TIWLabel;
    dbgAudit: TIWDBGrid;
    bnPrevious: TIWButton;
    bnNext: TIWButton;
    lbOrderFrom: TIWListbox;
    lbOrderTo: TIWListbox;
    bnAdd: TIWButton;
    bnRemove: TIWButton;
    lblSorts: TIWLabel;
    lblFilters: TIWLabel;
    txtSorts: TIWText;
    bnReturnMain: TIWButton;
    bnReturnAdmin: TIWButton;
    procedure bnRetrieveClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure cbDealershipChange(Sender: TObject);
    procedure cbCustomerChange(Sender: TObject);
    procedure cbESNChange(Sender: TObject);
    procedure bnAddClick(Sender: TObject);
    procedure bnRemoveClick(Sender: TObject);
    procedure bnPreviousClick(Sender: TObject);
    procedure bnNextClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnReturnAdminClick(Sender: TObject);
  private
    fPageNo: integer;
    fPageLow: integer;
    fPageHigh: integer;
    fTotalRecs: integer;
    procedure BuildOrderString;
    procedure GetRelCodeText;
    procedure LoadRecs;
    function isSimpleOrder: boolean;
  end;

  procedure InitCombo(Combo: TIWComboBox; LoadField: string; LoadTable: string);

implementation

{$R *.dfm}

uses uWRServer, uWRSite, uWRAdmin, SysUtils;

//*** Startup and Shutdown *****************************************************

procedure TfrmSecAudit.IWAppFormCreate(Sender: TObject);
begin
  {Populate all the drop-down combos and initialise the date fields;}

  WRData.qyAuditGrid.Close;

  InitCombo(cbUserCode, 'UserCode', 'Users');
  InitCombo(cbDealership, 'GroupDesc', 'UserGroups');
  InitCombo(cbCustomer, 'CustName', 'Customers');
  InitCombo(cbESN, 'ESN', 'ESNs');
  UserSession.InitRelCodes(cbRelCode);

  edDateFrom.Text:= FormatDateTime('dd/mm/yyyy', Date - 7);
  edDateTo.Text:= FormatDateTime('dd/mm/yyyy', Date);
end;

//*** Retrieval Methods ********************************************************

procedure TfrmSecAudit.LoadRecs;
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


  {Left join all related tables to the AuditLog table; Where filter drop-down
   selections have been made, add parameterised conditions to the query where
   clause; BuildOrderString generates the order by clause; Pass the parameters
   as needed and retrieve the resultset;}

  with WRData.qyAuditGrid do
  begin
    Close;
    Sql.Clear;

    Sql.Add('select a.auditid as "ID", ');
    Sql.Add('a.auditstamp as "Timestamp", b.usercode as "User Code", ');
    Sql.Add('c.groupdesc as "Dealership", d.custname as "Customer", e.esn as "ESN", ');
    Sql.Add('f.codedesc as "Release Code", h.modulename as "Module/Plug-In", ');
    Sql.Add('a.fullrelease as "Full Release", a.counts as "Counts", a.secdate as "Security Date" ');
    Sql.Add('from ');
    Sql.Add('(((((((auditlog a left join users b on a.userid = b.userid) ');
    Sql.Add('left join usergroups c on a.dealerid = c.groupid) ');
    Sql.Add('left join customers d on a.custid = d.custid) ');
    Sql.Add('left join esns e on a.esnid = e.esnid) ');
    Sql.Add('left join codetypes f on a.codeid = f.codeid) ');
    Sql.Add('left join auditmodules g on a.auditid = g.auditid) ');
    Sql.Add('left join modules h on g.moduleid = h.moduleid) ');
    Sql.Add('where ');
    if cbUserCode.ItemIndex >= 0 then Sql.Add('b.usercode = :pusercode and ');
    if cbDealerShip.ItemIndex >= 0 then Sql.Add('c.groupdesc = :pgroupdesc and ');
    if cbCustomer.ItemIndex >= 0 then Sql.Add('d.custname = :pcustname and ');
    if cbESN.ItemIndex >= 0 then Sql.Add('e.esn = :pesn and ');
    if cbRelCode.ItemIndex >= 0 then GetRelCodeText;
    Sql.Add('a.auditstamp between :pdate1 and :pdate2 ');
    BuildOrderString;

    ParamByName('pdate1').AsDateTime:= DateFrom;
    ParamByName('pdate2').AsDateTime:= DateTo;
    if cbUserCode.ItemIndex >= 0 then ParamByName('pusercode').AsString:= cbUserCode.Text;
    if cbDealerShip.ItemIndex >= 0 then ParamByName('pgroupdesc').AsString:= cbDealership.Text;
    if cbCustomer.ItemIndex >= 0 then ParamByName('pcustname').AsString:= cbCustomer.Text;
    if cbESN.ItemIndex >= 0 then ParamByName('pesn').AsString:= cbESN.Text;

    Prepare;
    Open;


    {If the query is ordered by timestamp only, page-scrolling is enabled;
     Otherwise the page-scrolling buttons are disabled; If page-scrolling is
     enabled, retrieve all records and position the cursor based on the upper
     and lower bounds of the current 15-record page; Store the page bounds
     and reissue the query with an additional predicate in the where clause;
     Reactivating the datasource then populates the DB Grid;}

    if isSimpleOrder then
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

procedure TfrmSecAudit.GetRelCodeText;
var
ModType: TModuleType;
begin
  {Determine the release code from the release code drop-down string; Update the
   audit query sql accordingly;}

  ModType:= mtNil;

  if Pos('Module - User Count - ', cbRelCode.Text) <> 0 then ModType:= mtModuleUC
  else if Pos('Module - ', cbRelCode.Text) <> 0 then ModType:= mtModule
  else if Pos('Plug-In - User Count - ', cbRelCode.Text) <> 0 then ModType:= mtPlugInUC
  else if Pos('Plug-In - ', cbRelCode.Text) <> 0 then ModType:= mtPlugIn;

  with WRData.qyAuditGrid do
  begin
    case ModType of
      mtNil:
      begin
        Sql.Add('f.codedesc = :pcodedesc and ');
        ParamByName('pcodedesc').AsString:= cbRelCode.Text;
      end;
      mtModule:
      begin
        Sql.Add('a.codeid = 8 and h.modulename = :pmodulename and ');
        ParamByName('pmodulename').AsString:= Copy(cbRelCode.Text, 10, Length(cbRelCode.Text));
      end;
      mtModuleUC:
      begin
        Sql.Add('a.codeid = 9 and h.modulename = :pmodulename and ');
        ParamByName('pmodulename').AsString:= Copy(cbRelCode.Text, 23, Length(cbRelCode.Text));
      end;
      mtPlugIn:
      begin
        Sql.Add('a.codeid = 10 and h.modulename = :pmodulename and ');
        ParamByName('pmodulename').AsString:= Copy(cbRelCode.Text, 11, Length(cbRelCode.Text));
      end;
      mtPlugInUC:
      begin
        Sql.Add('a.codeid = 11 and h.modulename = :pmodulename and ');
        ParamByName('pmodulename').AsString:= Copy(cbRelCode.Text, 24, Length(cbRelCode.Text));
      end;
    end;
  end;
end;

procedure TfrmSecAudit.BuildOrderString;
var
OrderIndex: integer;
Comma, Descend: string;
OrderType: TOrderType;
begin
  {Build the order by clause; Examine the contents of the OrderTo listbox, and
   for each item, add the appropriate comma-separated text to the order by clause;
   Append the DESC keyword where necessary; At the very least order by the
   descending timestamp;}

  WRData.qyAuditGrid.Sql.Add('order by ');

  if lbOrderTo.Items.Count > 0 then with WRData.qyAuditGrid, lbOrderTo do
  begin
    OrderType:= otNil;

    for OrderIndex:= 0 to Items.Count - 1 do
    begin
      if OrderIndex = Items.Count - 1 then Comma:= ' ' else Comma:= ', ';
      if Pos('Desc ', Items[OrderIndex]) <> 0 then Descend:= ' DESC' + Comma else Descend:= Comma;

      if Pos('Timestamp', Items[OrderIndex]) <> 0 then OrderType:= otTimestamp;
      if Pos('User Code', Items[OrderIndex]) <> 0 then OrderType:= otUserCode;
      if Pos('Dealership', Items[OrderIndex]) <> 0 then OrderType:= otDealership;
      if Pos('Customer', Items[OrderIndex]) <> 0 then OrderType:= otCustomer;
      if Pos('ESN', Items[OrderIndex]) <> 0 then OrderType:= otESN;
      if Pos('Release Code', Items[OrderIndex]) <> 0 then OrderType:= otReleaseCode;

      case OrderType of
        otTimestamp: Sql.Add('a.auditstamp ' + Descend);
        otUserCode: Sql.Add('b.usercode ' + Descend);
        otDealership: Sql.Add('c.groupdesc ' + Descend);
        otCustomer: Sql.Add('d.custname ' + Descend);
        otESN: Sql.Add('e.esn ' + Descend);
        otReleaseCode: Sql.Add('f.codedesc ' + Descend);
      end;
    end;
  end
  else WRData.qyAuditGrid.Sql.Add('a.auditstamp DESC ');
end;

//*** Helper Functions *********************************************************

procedure InitCombo(Combo: TIWComboBox; LoadField: string; LoadTable: string);
begin
  {Load the combo drop-down with values from LoadField in LoadTable;}

  Combo.Items.Clear;
  Combo.ItemIndex:= -1;

  with WRData.qyAudit do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select ' + LoadField + ' from ' + LoadTable + ' ');
    Open;

    while not eof do
    begin
      Combo.Items.Add(FieldByName(LoadField).AsString);
      Next;
    end;
  end;
end;

function TfrmSecAudit.isSimpleOrder: boolean;
var
OrderIndex: integer;
begin
  {An audit query is ordered simply if it is sorted by timestamp only;}

  Result:= true;

  with lbOrderTo, Items do
  begin
    for OrderIndex:= 0 to Items.Count - 1 do
    begin
      if Pos('Timestamp', Items[OrderIndex]) = 0 then Result:= false;
    end;
  end;
end;

//*** Event Handlers ***********************************************************

procedure TfrmSecAudit.cbDealershipChange(Sender: TObject);
begin
  {If no selection has been made, populate the customer and esn drop-downs with
   all records; Otherwise, add the dealer's customers to the customer drop-down
   and all the corresponding ESNs to the ESN drop-down;}

  if cbDealership.ItemIndex < 0 then
  begin
    InitCombo(cbCustomer, 'CustName', 'Customers');
    InitCombo(cbESN, 'ESN', 'ESNs');
    Exit;
  end;

  cbCustomer.Items.Clear;
  cbCustomer.ItemIndex:= -1;
  cbESN.Items.Clear;
  cbESN.ItemIndex:= -1;

  with WRData.qyAudit do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select b.custname as custname, c.esn as esn ');
    Sql.Add('from usergroups a inner join customers b on a.groupid = b.groupid ');
    Sql.Add('left join esns c on b.custid = c.custid ');
    Sql.Add('where a.groupdesc = :pgroupdesc ');
    ParamByName('pgroupdesc').AsString:= cbDealership.Text;
    Open;

    while not eof do
    begin
      if cbCustomer.Items.IndexOf(FieldByName('CustName').AsString) < 0 then cbCustomer.Items.Add(FieldByName('CustName').AsString);
      if (FieldByName('ESN').AsString <> '') and (cbESN.Items.IndexOf(FieldByName('ESN').AsString) < 0) then cbESN.Items.Add(FieldByName('ESN').AsString);
      Next;
    end;
  end;
end;

procedure TfrmSecAudit.cbCustomerChange(Sender: TObject);
begin
  {If no selection has been made, populate the esn drop-down with all records;
   Otherwise, determine the select the customer's dealer in the dealer drop-down
   and add the associated esns to the esn drop-down;}

  if cbCustomer.ItemIndex < 0 then
  begin
    InitCombo(cbESN, 'ESN', 'ESNs');
    Exit;
  end;

  cbESN.Items.Clear;
  cbESN.ItemIndex:= -1;

  with WRData.qyAudit do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select a.groupdesc as groupdesc from usergroups a, customers b ');
    Sql.Add('where a.groupid = b.groupid and b.custname = :pcustname ');
    ParamByName('pcustname').AsString:= cbCustomer.Text;
    Open;

    cbDealership.ItemIndex:= cbDealership.Items.IndexOf(FieldByName('GroupDesc').AsString);

    Close;
    Sql.Clear;
    Sql.Add('select b.esn as esn from customers a, esns b ');
    Sql.Add('where a.custid = b.custid and a.custname = :pcustname ');
    ParamByName('pcustname').AsString:= cbCustomer.Text;
    Open;

    while not eof do
    begin
      cbESN.Items.Add(FieldByName('ESN').AsString);
      Next;
    end;
  end;
end;

procedure TfrmSecAudit.cbESNChange(Sender: TObject);
begin
  {If an esn has been selected, select the associated dealer and customer in their
   respective drop-downs;}

  if cbESN.ItemIndex < 0 then Exit;

  with WRData.qyAudit do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select a.groupdesc as groupdesc, b.custname as custname ');
    Sql.Add('from usergroups a, customers b, esns c ');
    Sql.Add('where a.groupid = b.groupid and b.custid = c.custid ');
    Sql.Add('and c.esn = :pesn ');
    ParamByName('pesn').AsString:= cbESN.Text;
    Open;

    cbDealership.ItemIndex:= cbDealership.Items.IndexOf(FieldByName('GroupDesc').AsString);
    cbCustomer.ItemIndex:= cbCustomer.Items.IndexOf(FieldByName('CustName').AsString);
  end;
end;

procedure TfrmSecAudit.bnRetrieveClick(Sender: TObject);
begin
  {Restore the PageNo field to 0 and load the records into the DB Grid;}

  fPageNo:= 0;
  LoadRecs;
end;

procedure TfrmSecAudit.bnAddClick(Sender: TObject);
begin
  {If an item has been selected in the OrderFrom listbox, and the item does not
   already exist in the OrderTo listbox, add the item to the OrderTo box;}

  if (lbOrderFrom.ItemIndex >= 0) and (lbOrderTo.Items.IndexOf(lbOrderFrom.Text) < 0) then lbOrderTo.Items.Add(lbOrderFrom.Text);
end;

procedure TfrmSecAudit.bnRemoveClick(Sender: TObject);
begin
  {If there are at least two items in the OrderTo box then one may be deleted;
   The listbox items play up when it contains no items;}

  if lbOrderTo.Items.Count >= 2 then lbOrderTo.Items.Delete(lbOrderTo.ItemIndex)
  else WebApplication.ShowMessage('At least one ''order by'' condition is required');
end;

procedure TfrmSecAudit.bnPreviousClick(Sender: TObject);
begin
  {Decrement the PageNo field if we are beyond the first page, and load the records
   for the new page into the DB Grid;}

  if fPageNo > 0 then dec(fPageNo);
  LoadRecs;
end;

procedure TfrmSecAudit.bnNextClick(Sender: TObject);
begin
  {Increment the PageNo field if we are before the last page, and load the records
   for the new page into the DB Grid;}

  if fPageNo < (fTotalRecs div 15) then inc(fPageNo);
  LoadRecs;
end;

procedure TfrmSecAudit.bnReturnMainClick(Sender: TObject);
begin
  {Recreate the site form and release the current form;}

  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmSecAudit.bnReturnAdminClick(Sender: TObject);
begin
  {Recreate the admin form and release the current form;}

  TfrmAdmin.Create(WebApplication).Show;
  Release;
end;

//******************************************************************************

end.
