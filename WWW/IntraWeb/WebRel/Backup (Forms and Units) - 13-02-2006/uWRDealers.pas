unit uWRDealers;

{Assumes that dealer names are unique;}

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompText, IWCompButton,
  IWCompCheckbox, IWCompEdit, IWCompLabel, Classes, Controls, IWControl,
  IWCompListbox;

type
  TDealerID = class
  public
    DealerID: integer;
    constructor Create(NewDealerID: integer); reintroduce; overload;
  end;

  TfrmDealers = class(TIWAppForm)
    cbDealership: TIWComboBox;
    lblEditDealer: TIWLabel;
    bnNewDealer: TIWButton;
    lblhdrDealers: TIWLabel;
    bnReturnAdmin: TIWButton;
    bnReturnMain: TIWButton;
    bnEditDealer: TIWButton;
    txtDealer: TIWText;
    bnFilterDealer: TIWButton;
    edFilterDealer: TIWEdit;
    cbContainsDealer: TIWCheckBox;
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnReturnAdminClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure bnNewDealerClick(Sender: TObject);
    procedure bnEditDealerClick(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure edFilterDealerSubmit(Sender: TObject);
  private
    procedure LoadDealers(FilterCond: string);
  end;

implementation

{$R *.dfm}

uses uWRServer, uWRData, uWRSite, uWRAdmin, uWRedDealers, SysUtils;

//*** TDealerID ****************************************************************

constructor TDealerID.Create(NewDealerID: integer);
begin
  {Used to identify specific dealers given the dealer names in the drop-down
   are not necessarily unique;}

  Create;
  DealerID:= NewDealerID;
end;

//*** Startup and Shutdown *****************************************************

procedure TfrmDealers.IWAppFormCreate(Sender: TObject);
begin
  LoadDealers('');
end;

procedure TfrmDealers.IWAppFormDestroy(Sender: TObject);
var
IDIndex: integer;
begin
  {Free all the TDealerID objects in the user drop-down;}

  for IDIndex:= 0 to cbDealership.Items.Count - 1 do cbDealership.Items.Objects[IDIndex].Free;
end;

//*** Main *********************************************************************

procedure TfrmDealers.bnNewDealerClick(Sender: TObject);
begin
  {Create the Edit Dealers form, initialising the DealerState variable, loading
   the parent drop-down and selecting the first field; Release the current form;}

  with TfrmedDealers.Create(WebApplication) do
  begin
    DealerState:= dsNew;

    LoadParentCombo('');
    Show;
  end;

  Release;
end;

procedure TfrmDealers.bnEditDealerClick(Sender: TObject);
begin
  {Ensure a dealer has been selected in the dealer drop-down; Create the Edit
   Dealers form, initialising the DealerState variable; Extract the DealerID from
   the TDealerID object associated with the drop-down selection and populate the
   form controls for the selected dealer; Initialise the form fields primarily for
   auditing purposes and release the current form;}

  if Trim(cbDealership.Text) = '' then
  begin
    WebApplication.ShowMessage('Please select a dealer from the Edit Dealer drop-down box.');
    Exit;
  end;

  with WRData.qyPrimary, TfrmedDealers.Create(WebApplication) do
  begin
    DealerState:= dsEdit;
    OriginalName:= cbDealership.Text;
    GroupID:= TDealerID(cbDealership.Items.Objects[cbDealership.ItemIndex]).DealerID;
    edDealerName.Text:= cbDealership.Text;

    Close;
    Sql.Clear;
    Sql.Add('select a.grouptype as grouptype, a.userdef1 as userdef1, ');
    Sql.Add('a.groupactive as groupactive, a.groupnotes as groupnotes, ');
    Sql.Add('a.parentid as parentid, a.groupdesc as firstdesc, ');
    // AB - 10 added next line.
    Sql.Add('a.linkcode as linkcode, ');
    Sql.Add('a.active as active, b.groupdesc as groupdesc ');
    Sql.Add('from usergroups a left join usergroups b on a.parentid = b.groupid ');
    Sql.Add('where a.groupid = :pgroupid ');
    ParamByName('pgroupid').AsInteger:= GroupID;
    Open;

    // AB - 10
    edDealerCode.Text := FieldByName('LinkCode').AsString;
    
    edEmail.Text:= FieldByName('UserDef1').AsString;
    memoDealer.Lines.Add(FieldByName('GroupNotes').AsString);
    cbSuspended.Checked:= not FieldByName('GroupActive').AsBoolean;
    cbActive.Checked:= FieldByName('Active').AsBoolean;
    cbDealerType.ItemIndex:= FieldByName('GroupType').AsInteger - 1;

    LoadParentCombo('');

    cbParent.ItemIndex:= cbParent.Items.IndexOf(FieldByName('GroupDesc').AsString);

    InitNotes:= FieldByName('GroupNotes').AsString;
    InitType:= cbDealerType.ItemIndex;
    InitEmail:= edEmail.Text;
    InitActive:= cbActive.Checked;
    InitSuspended:= cbSuspended.Checked;
    InitParent:= cbParent.ItemIndex;

    Show;
  end;

  Release;
end;

//*** Helper Functions *********************************************************

procedure TfrmDealers.LoadDealers(FilterCond: string);
begin
  {Load the dealers drop-down with all dealers and distributors (excludes
   the root and naming groups); Add a TDealerID object for each dealer to store
   the DealerID and enforce uniqueness within the drop-down; Select the first
   item in the drop-down;}

  cbDealership.Items.Clear;

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select groupid, groupdesc from usergroups where grouptype > 0 ');
    Sql.Add(FilterCond);
    Open;

    while not eof do
    begin
      cbDealership.Items.AddObject(FieldByName('GroupDesc').AsString, TDealerID.Create(FieldByName('GroupID').AsInteger));
      Next;
    end;

    if cbDealership.Items.Count > 0 then cbDealership.ItemIndex:= 0;
  end;
end;

//*** Event Handlers ***********************************************************

{Show the corresponding form for the button clicked and release the current form;}

procedure TfrmDealers.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmDealers.bnReturnAdminClick(Sender: TObject);
begin
  TfrmAdmin.Create(WebApplication).Show;
  Release;
end;

procedure TfrmDealers.edFilterDealerSubmit(Sender: TObject);
var
FilterCond, Contains: string;
begin
  if cbContainsDealer.Checked then Contains:= '%' else Contains:= '';
  FilterCond:= 'and groupdesc like ''' + Contains + Trim(edFilterDealer.Text) + '%'' ';
  LoadDealers(FilterCond);
end;

//******************************************************************************

end.
