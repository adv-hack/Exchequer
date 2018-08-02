unit uWRCustomers;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompText, IWCompButton, IWCompEdit,
  IWCompLabel, Classes, Controls, IWControl, IWCompListbox, IWCompCheckbox;

type
  TCustomerID = class
  public
    CustID: integer;
    constructor Create(NewCustID: integer); reintroduce; overload;
  end;

  TfrmCustomers = class(TIWAppForm)
    lblhdrCustomers: TIWLabel;
    cbCustomer: TIWComboBox;
    lblEditCustomer: TIWLabel;
    bnNewCustomer: TIWButton;
    bnReturnAdmin: TIWButton;
    bnReturnMain: TIWButton;
    bnEditCustomer: TIWButton;
    txtCustomer: TIWText;
    bnFilterCust: TIWButton;
    edFilterCust: TIWEdit;
    cbContainsCust: TIWCheckBox;
    bnDelCustomer: TIWButton;
    procedure bnReturnAdminClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure bnNewCustomerClick(Sender: TObject);
    procedure bnEditCustomerClick(Sender: TObject);
    procedure bnDelCustomerClick(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure edFilterCustSubmit(Sender: TObject);
  private
    procedure LoadCustomers(FilterCond: string);
  end;

implementation

{$R *.dfm}

uses uWRServer, uWRedCustomers, uWRData, uWRSite, uWRAdmin, SysUtils;

//*** TCustomerID **************************************************************

constructor TCustomerID.Create(NewCustID: integer);
begin
  {Used to identify specific customers given the customer names in the drop-down
   are not necessarily unique;}

  Create;
  CustID:= NewCustID;
end;

//*** Startup and Shutdown *****************************************************

procedure TfrmCustomers.IWAppFormCreate(Sender: TObject);
begin
  bnDelCustomer.Visible := UserSession.InternalHQUser;
  LoadCustomers('');
end;

procedure TfrmCustomers.IWAppFormDestroy(Sender: TObject);
var
IDIndex: integer;
begin
  {Free all the TCustomerID objects in the user drop-down;}

  for IDIndex:= 0 to cbCustomer.Items.Count - 1 do cbCustomer.Items.Objects[IDIndex].Free;
end;

//*** Main *********************************************************************

procedure TfrmCustomers.bnNewCustomerClick(Sender: TObject);
begin
  {Create the Edit Customers form, initialising the CustState variable, loading
   the parent drop-down and selecting the first field; Hide all controls relating
   to ESNs and release the current form;}

  with TfrmedCustomers.Create(WebApplication) do
  begin
    CustState:= csNew;
    if cbParent.Items.Count > 0 then cbParent.ItemIndex:= 0;

    lblCustESNs.Visible:= false;
    txtESN.Visible:= false;
    lblEditESN.Visible:= false;
    lbESN.Visible:= false;
    lblActive.Visible:= false;
    bnNewESN.Visible:= false;
    bnEditESN.Visible:= false;

    lblThresholds.Visible:= false;
    txtThresholds.Visible:= false;
    bnThresholds.Visible:= false;
    gdThresholds.Visible:= false;
    lblNoOverrides.Visible:= false;

    Show;
  end;

  Release;
end;

procedure TfrmCustomers.bnEditCustomerClick(Sender: TObject);
begin
  {Ensure a customer has been selected in the customer drop-down; Create the Edit
   Customers form, initialising the CustState variable; Extract the CustID from
   the TCustomerID object associated with the drop-down selection and populate the
   form controls for the selected customer; Initialise the form fields primarily
   for auditing purposes; Retrieve the esns for the current customer and load all
   esns, including duplicates, into the lbESN list-box; Suffix the active esns
   with an asterisk; Select the first esn and release the current form;}

  if Trim(cbCustomer.Text) = '' then
  begin
    WebApplication.ShowMessage('Please select a customer from the Edit Customer drop-down box.');
    Exit;
  end;

  with WRData.qyPrimary, TfrmedCustomers.Create(WebApplication) do
  begin

    CustState:= csEdit;
    OriginalName:= cbCustomer.Text;
    CustID:= TCustomerID(cbCustomer.Items.Objects[cbCustomer.ItemIndex]).CustID;
    edCustomer.Text:= cbCustomer.Text;

    Close;
    Sql.Clear;
    Sql.Add('select a.custnotes as custnotes, a.restricted as restricted, ');
    // AB - 10 added next line.
    Sql.Add('a.linkcode as linkcode, ');
    Sql.Add('a.active as active, b.groupdesc as groupdesc ');
    Sql.Add('from customers a left join usergroups b on a.groupid = b.groupid ');
    Sql.Add('where a.custname = :pcustname ');
    ParamByName('pcustname').AsString:= cbCustomer.Text;
    Open;

    cbParent.ItemIndex:= cbParent.Items.IndexOf(FieldByName('GroupDesc').AsString);
    // AB - 10
    edCustomerCode.Text := FieldByName('LinkCode').AsString;
    
    cbRestrict30.Checked:= FieldByName('Restricted').AsBoolean;
    cbActive.Checked:= FieldByName('Active').AsBoolean;
    memoCustomer.Lines.Add(FieldByName('CustNotes').AsString);

    InitNotes:= FieldByName('CustNotes').AsString;
    InitRestricted:= cbRestrict30.Checked;
    InitActive:= cbActive.Checked;
    InitParent:= cbParent.ItemIndex;

    Close;
    Sql.Clear;
    Sql.Add('select esnid, esn, active from esns where custid = :pcustid ');
    ParamByName('pcustid').AsInteger:= CustID;
    Open;

    with lbESN.Items as TStringList do Duplicates:= dupAccept;

    while not eof do
    begin
      if FieldByName('Active').AsBoolean then lbESN.Items.AddObject(FieldByName('ESN').AsString + ' *', TESNID.Create(FieldByName('ESNID').AsInteger))
      else lbESN.Items.AddObject(FieldByName('ESN').AsString, TESNID.Create(FieldByName('ESNID').AsInteger));
      Next;
    end;

    if lbESN.Items.Count > 0 then lbESN.ItemIndex:= 0;

    LoadThresholds(gdThresholds);
    Show;
  end;

  Release;
end;

procedure TfrmCustomers.bnDelCustomerClick(Sender: TObject);
begin
  if Trim(cbCustomer.Text) = '' then
  begin
    WebApplication.ShowMessage('Please select a customer from the Edit Customer drop-down box.');
    Exit;
  end;

  with WRData.qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('delete from customers');
    Sql.Add('where custname = :pcustname ');
    ParamByName('pcustname').AsString := Trim(cbCustomer.Text);
    Open;
  end;

  LoadCustomers('');
end;

//*** Helper Functions *********************************************************

procedure TfrmCustomers.LoadCustomers(FilterCond: string);
begin
  {Load the customers drop-down with all customers; Add a TCustomerID object for
   each customer to store the CustID and enforce uniqueness within the drop-down;
   Select the first item in the drop-down;}

  cbCustomer.Items.Clear;

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select custid, custname from customers ');
    Sql.Add(FilterCond);
    Open;

    while not eof do
    begin
      cbCustomer.Items.AddObject(FieldByName('CustName').AsString, TCustomerID.Create(FieldByName('CustID').AsInteger));
      Next;
    end;

    if cbCustomer.Items.Count > 0 then cbCustomer.ItemIndex:= 0;
  end;
end;

//*** Event Handlers ***********************************************************

{Show the corresponding form for the button clicked and release the current form;}

procedure TfrmCustomers.bnReturnAdminClick(Sender: TObject);
begin
  TfrmAdmin.Create(WebApplication).Show;
  Release;
end;

procedure TfrmCustomers.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmCustomers.edFilterCustSubmit(Sender: TObject);
var
FilterCond, Contains: string;
begin
  if cbContainsCust.Checked then Contains:= '%' else Contains:= '';
  FilterCond:= 'where custname like ''' + Contains + Trim(edFilterCust.Text) + '%'' ';
  LoadCustomers(FilterCond);
end;

//******************************************************************************

end.