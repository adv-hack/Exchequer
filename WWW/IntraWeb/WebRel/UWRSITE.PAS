unit uWRSite;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompLabel, Classes, Controls, IWControl,
  IWCompListbox, DB, IWCompButton, IWCompMemo, IWLayoutMgr,
  IWTemplateProcessorHTML, IWCompCheckbox, IWCompEdit;

type
  TESN = class
  public
    ESNID: integer;
    constructor Create(NewESNID: integer); reintroduce; overload;
  end;

  TfrmSite = class(TIWAppForm)
    cbDealership: TIWComboBox;
    cbCustomer: TIWComboBox;
    cbESN: TIWComboBox;
    lblDealership: TIWLabel;
    lblCustomer: TIWLabel;
    lblESN: TIWLabel;
    lblVersion: TIWLabel;
    cbVersion: TIWComboBox;
    bnContinue: TIWButton;
    bnAdmin: TIWButton;
    memoDealer: TIWMemo;
    memoCustomer: TIWMemo;
    lblCustNotes: TIWLabel;
    lblDealerNotes: TIWLabel;
    bnDummy: TIWButton;
    TemplateProcessor: TIWTemplateProcessorHTML;
    bnLogout: TIWButton;
    edFilterDealer: TIWEdit;
    edFilterCust: TIWEdit;
    bnFilterDealer: TIWButton;
    bnFilterCust: TIWButton;
    cbContainsDealer: TIWCheckBox;
    cbContainsCust: TIWCheckBox;
    lbDemoHint: TIWLabel;
    procedure IWAppFormCreate(Sender: TObject);
    procedure cbDealershipChange(Sender: TObject);
    procedure cbCustomerChange(Sender: TObject);
    procedure cbESNChange(Sender: TObject);
    procedure bnContinueClick(Sender: TObject);
    procedure bnAdminClick(Sender: TObject);
    procedure bnDummyClick(Sender: TObject);
    procedure bnLogoutClick(Sender: TObject);
    procedure bnFilterDealerClick(Sender: TObject);
    procedure bnFilterCustomerClick(Sender: TObject);
  private
    procedure AddDistribDealers(GroupID: integer);
    procedure LoadCustomers(FilterCond : string);

    procedure LoadDealers(FilterCond : string);
    procedure LoadESNs;
    procedure LoadVersions;
    procedure SetCustID;
    procedure SetDealerID;
    procedure SetESNID;
    procedure SetVersion;
    procedure UpdateVersion;
    function isNewESN: boolean;
    function isValidSelections: boolean;
    function isPartialESN(const ESN : ShortString) : boolean;
    procedure UpdateDemoLabel;
  end;

implementation

{$R *.dfm}

uses uWRServer, uWRData, uWRAdmin, uPermissionIDs, uWRSpecESN, Variants, uCodeIDs,
     LicFuncU, // LicFuncU for 7th segment decode function licDecodeDemoFlag()
     LicRec, // LicRec defines ESNByteArrayType 
     SysUtils;

//*** TESN *********************************************************************

constructor TESN.Create(NewESNID: integer);
begin
  {TESN is used because ESNs are non-unique for each customer; TESN objects are
   attached to the cbESN drop-down to distinguish which ESN has been selected;}

  Create;
  ESNID:= NewESNID;
end;

//*** Startup and Shutdown *****************************************************

procedure TfrmSite.IWAppFormCreate(Sender: TObject);
begin
  {Populate and initialise all three drop-down combos; Ensure the session state
   variables have been reset in case we are returning here from release code
   pages; The admin and auditing buttons are made available if the user has the
   appropriate permissions; The notes memos are only made available to internal
   users;}

  LoadVersions;
  LoadDealers('');
  LoadCustomers('');
  LoadESNs;

//  UpdateDemoLabel;

  with UserSession, Security do
  begin
    ResetState;
    bnDummy.Visible := InternalHQUser and (Validate(UserCode, pidDummy) = 0);
// FIXME The code below will replace the code above so that the "Use Dummy" button is avaliable to Distributor users.
//    bnDummy.Visible := (InternalHQUser or DistributorUser) and (Validate(UserCode, pidDummy) = 0);
    bnAdmin.Visible:= InternalHQUser and (Validate(UserCode, pidAdmin) = 0);

    memoDealer.Visible:= InternalHQUser;
    memoCustomer.Visible:= InternalHQUser;
    lblDealerNotes.Visible:= InternalHQUser;
    lblCustNotes.Visible:= InternalHQUser;

    edFilterDealer.Visible := (InternalHQUser or DistributorUser);
    edFilterCust.Visible := (InternalHQUser or DistributorUser);
    bnFilterDealer.Visible := (InternalHQUser or DistributorUser);
    bnFilterCust.Visible := (InternalHQUser or DistributorUser);
    cbContainsDealer.Visible := (InternalHQUser or DistributorUser);
    cbContainsCust.Visible := (InternalHQUser or DistributorUser);
  end;
end;

procedure TfrmSite.LoadDealers(FilterCond : string);
begin
  {Populate and initialise the dealership combo with fresh data;}

  cbDealership.Items.Clear;

  with UserSession do
  begin
    {For HQ users with the ReleaseToAll permission, add all dealers to the combo;
     If an internal user lacks this permission, only add its parent dealer i.e.
     the root node;}

    if Security.IsHQUser(UserCode) = 0 then
    begin
      with WRData.qyUserGroups, UserSession.Security do
      begin
        // AB - added if..then and Sql.Add
        Close;
        Sql.Clear;
        Sql.Add('select * from usergroups ');
        Sql.Add('where active = 1 ');
        if (Length(FilterCond) > 0) then
          Sql.Add(FilterCond);
        Open;

        if Validate(UserCode, pidReleaseToAll) = 0 then
        begin
          while not eof do
          begin
            cbDealership.Items.Add(FieldByName('GroupDesc').AsString);
            Next;
          end;
        end
        else
        begin
          Locate('groupid;parentid', VarArrayOf([1, 0]), []);
          cbDealerShip.Items.Add(FieldByName('GroupDesc').AsString);
        end;
      end; // with WRData.qyUserGroups, UserSession.Security do...
    end; // if...then...


    {Join the user record to its dealer record using the user code; For external
     users, populate the combo with the single dealer; Store the DealerID and set
     the text in the dealership combo; If the UserGroup is a distributor, add
     the distributors dealers;}

    with WRData, qyPrimary, cbDealership do
    begin
      Close;
      Sql.Clear;
      Sql.Add('select a.groupdesc as groupdesc, a.groupid as dealerid, ');
      Sql.Add('a.grouptype as grouptype from usergroups a, users b ');
      Sql.Add('where a.groupid = b.groupid and b.usercode = :pusercode ');
      ParamByName('pusercode').AsString:= UserCode;
      Open;

      DealerID:= FieldByName('DealerID').AsInteger;
      DealerName:= FieldByName('GroupDesc').AsString;

      if Security.IsHQUser(UserCode) <> 0 then
        Items.Add(FieldByName('GroupDesc').AsString);

      if FieldByName('GroupType').AsInteger = gtDistributor then
        AddDistribDealers(FieldByName('DealerID').AsInteger);

      cbDealership.ItemIndex := cbDealership.Items.IndexOf(FieldByName('GroupDesc').AsString);
      if (cbDealership.ItemIndex < 0) then cbDealership.ItemIndex := 0;
    end;
  end; // with UserSession do...
end;

procedure TfrmSite.AddDistribDealers(GroupID: integer);
begin
  {If the distributor user has the ReleaseToAll permission, add the distributors
   immediate dealers to the dealership drop-down list;}

  with UserSession, Security do
  begin
    if Validate(UserCode, pidReleaseToAll) = 0 then with WRData.qyUserGroups do
    begin
      Close;
      Sql.Clear;
      Sql.Add('select * from usergroups ');
      Sql.Add('where active = 1 ');
      Open;

      while not eof do
      begin
        if FieldByName('ParentID').AsInteger = GroupID then cbDealership.Items.Add(FieldByName('GroupDesc').AsString);
        Next;
      end;
    end;  
  end;
end;

procedure TfrmSite.LoadCustomers(FilterCond : string);
begin
  {Populate and initialise the customers combo with fresh data; All customers
   are added for the current dealer;}

  with WRData.qyCustomers do
  begin
    cbCustomer.Items.Clear;
    cbCustomer.ItemIndex := -1;

    Close;
    Sql.Clear;
    Sql.Add('select * from customers ');
    Sql.Add('where groupid = :pgroupid ');    
    Sql.Add('and active = 1 ');
    if (Length(FilterCond) > 0) then
      Sql.Add(FilterCond);
    ParamByName('pgroupid').AsInteger := UserSession.DealerID;
    Open;

    while not WRData.qyCustomers.Eof do
    begin
      cbCustomer.Items.Add(FieldByName('CustName').AsString);
      WRData.qyCustomers.Next;
    end;

    {If customers have been added, set the combo text to the first customer in
     the list; Store the CustID;}

    with cbCustomer do
      if Items.Count <= 0 then ItemIndex := -1 else ItemIndex := 0;

    SetCustID;

  end;
end;

procedure TfrmSite.LoadESNs;
begin
  {Populate and initialise the ESN combo with fresh data; All ESNs are added for
   the current customer;}

  with WRData, qyESNs, cbESN do
  begin
    TStringList(Items).Duplicates:= dupAccept;
    Items.Clear;
    ItemIndex:= -1;

    Close;
    ParamByName('pcustid').AsInteger:= UserSession.CustID;
    Open;

    while not eof do
    begin
      if (FieldByName('Unspecified').AsBoolean) and
         (isPartialESN(FieldByName('ESN').AsString) = FALSE) then
        Items.AddObject(' --- New ESN --- ', TESN.Create(FieldByName('ESNID').AsInteger))
      else
        Items.AddObject(FieldByName('ESN').AsString, TESN.Create(FieldByName('ESNID').AsInteger));
      Next;
    end;

    {If ESNs have been added, set the combo text to the first ESN in the list;
     Store the ESNID and set the version combo text; Note that the versions are
     already loaded;}

    if Items.Count <= 0 then ItemIndex:= -1 else ItemIndex:= 0;
    SetESNID;
    SetVersion;
  end;
end;

procedure TfrmSite.LoadVersions;
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

//*** Helper Functions *********************************************************

{Locates the record for the currently selected dealer/customer or ESN and then
 stores the respective DealerID/CustID or ESNID, plus string field;}

procedure TfrmSite.SetDealerID;
begin
  with WRData.qyUserGroups do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select * from usergroups ');
    Sql.Add('where active = 1 ');
    Open;

    if Locate('GroupDesc', cbDealership.Text, [loCaseInsensitive]) then
    begin
      UserSession.DealerID:= FieldByName('GroupID').AsInteger;
      UserSession.DealerName:= FieldByName('GroupDesc').AsString;

      memoDealer.Lines.Clear;
      memoDealer.Lines.Add(FieldByName('GroupNotes').AsString);
    end;
  end;
end;

procedure TfrmSite.SetCustID;
begin
  with WRData.qyCustomers do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select * from customers ');
    Sql.Add('where groupid = :pgroupid ');
    Sql.Add('and active = 1 ');
    ParamByName('pgroupid').AsInteger := UserSession.DealerID;
    Open;

    Locate('CustName', cbCustomer.Text, [loCaseInsensitive]);
    UserSession.CustID:= FieldByName('CustID').AsInteger;
    UserSession.CustName:= FieldByName('CustName').AsString;
    UserSession.CustRestricted:= FieldByName('Restricted').AsBoolean;

    memoCustomer.Lines.Clear;
    memoCustomer.Lines.Add(FieldByName('CustNotes').AsString);
  end;
end;

procedure TfrmSite.SetESNID;
begin
  if cbESN.Items.Count > 0 then with WRData, qyESNs do
  begin
    Locate('ESNID', TESN(cbESN.Items.Objects[cbESN.ItemIndex]).ESNID, []);
    UserSession.ESNID:= FieldByName('ESNID').AsInteger;
    UserSession.ESN:= FieldByName('ESN').AsString;
  end;
end;

procedure TfrmSite.SetVersion;
begin
  {Locate the record for the currently selected ESN, and set the version combo
   text to match the ESN version;}

  if cbESN.Items.Count > 0 then with WRData, qyESNs, cbVersion do
  begin
    if Locate('ESNID', TESN(cbESN.Items.Objects[cbESN.ItemIndex]).ESNID, [])then ItemIndex:= Items.IndexOf(FieldByName('Version').AsString);
  end;
end;

function TfrmSite.isValidSelections: boolean;
var
InvalidMsg: string;
begin
  {Tests whether selections have been made for each of the drop-downs; Notifies
   the user if this is not the case;}

  InvalidMsg:= '';

  if Trim(cbDealership.Text) = '' then InvalidMsg:= 'Please select a dealership from the dealership drop-down.'
  else if Trim(cbCustomer.Text) = '' then InvalidMsg:= 'Please select a customer from the customer drop-down.'
  else if Trim(cbESN.Text) = '' then InvalidMsg:= 'Please select an esn from the esn drop-down.'
  else if Trim(cbVersion.Text) = '' then InvalidMsg:= 'Please select a version from the version drop-down.';

  Result:= InvalidMsg = '';
  if not Result then WebApplication.ShowMessage(InvalidMsg);
end;

function TfrmSite.isNewESN: boolean;
begin
  Result:= false;

  with WRData, qyESNs do
  begin
    if Locate('ESNID', TESN(cbESN.Items.Objects[cbESN.ItemIndex]).ESNID, []) then Result:= FieldByName('Unspecified').AsBoolean;
  end;
end;

function TfrmSite.isPartialESN(const ESN : ShortString) : boolean;
const
  ESN_SEGMENTS = 6;
var
  PosHyphen, Idx : SmallInt;
  aSegments : array[1..ESN_SEGMENTS] of ShortString;
  ssESN : ShortString;
begin
  ssESN := ESN;
  if (length(trim(ssESN)) > 0 ) then
  begin
    // This loop extracts all segments of the ESN.
    for Idx := 1 to ESN_SEGMENTS do
    begin
      PosHyphen := Pos('-',ssESN);
      if (PosHyphen > 0) and (Length(ssESN) > 0) then
      begin
        aSegments[Idx] := Copy(ssESN,1,PosHyphen-1);
        Delete(ssESN,1,PosHyphen);
      end
      else
      begin
        aSegments[Idx] := ssESN; // This is for the last ESN segment.
      end;
    end; // for Idx := 1 to ESN_SEGMENTS do

    // Partial ESNs are defined as EITHER segment 1 OR 4 are non-zero.
    // ALL the other segments, 2, 3, 5 and 6 are all ZERO.
    if ((aSegments[1] <> '000') or (aSegments[4] <> '000')) and
       ((aSegments[2] = '000') and (aSegments[3] = '000') and
        (aSegments[5] = '000') and (aSegments[6] = '000')) then
    begin
      Result := TRUE;
    end
    else
      Result := FALSE;

  end // if (length(trim(ssESN)) > 0 ) then
  else
    Result := TRUE;
end;

procedure TfrmSite.UpdateVersion;
begin
  {Persist the version in UserSession and ensure the ESN table is current;}

  with WRData, qyPrimary, cbVersion do
  begin
    Close;
    Sql.Clear;
    Sql.Add('update esns set version = :pversion where esnid = :pesnid ');
    ParamByName('pversion').AsString:= UserSession.Version;
    ParamByName('pesnid').AsInteger:= UserSession.ESNID;
    ExecSql;
  end;
end;

//*** Event Handlers ***********************************************************

procedure TfrmSite.bnDummyClick(Sender: TObject);
begin
  UserSession.bUsingDummyESN := TRUE;
  {Display the New ESN form;}

  UserSession.Version:= cbVersion.Text;
 
  with TfrmSpecESN.Create(WebApplication) do
  begin
    DummyESN:= true;
    InitControls;
    Show;
  end;

  Release;
end;

procedure TfrmSite.bnAdminClick(Sender: TObject);
begin
  {Display the admin form;}

  TfrmAdmin.Create(WebApplication).Show;
  Release;
end;

procedure TfrmSite.cbDealershipChange(Sender: TObject);
begin
  UserSession.bUsingDummyESN := FALSE;
  
  {Set the DealerID for the new dealer and load the associated customers and ESNs;}
  SetDealerID;
  LoadCustomers('');
  LoadESNs;

  UpdateDemoLabel;
end;

procedure TfrmSite.cbCustomerChange(Sender: TObject);
begin
  UserSession.bUsingDummyESN := FALSE;

  {Set the CustID for the new customer and load the associated ESNs;}
  SetCustID;
  LoadESNs;

  UpdateDemoLabel;
end;

procedure TfrmSite.cbESNChange(Sender: TObject);
begin
  {Set the ESNID for the new ESN and set the associated version text;}

  SetESNID;
  SetVersion;

  UpdateDemoLabel;
end;

procedure TfrmSite.bnContinueClick(Sender: TObject);
begin
  {Validate the drop-down selections; Persist the version in the UserSession and
   check whether the ESN is specified; Unspecified ESNs will need specifying
   before advancing to the release code pages;}

  if not isValidSelections then Exit;

  UserSession.Version:= cbVersion.Text;
  UpdateVersion;

  if isNewESN then with TfrmSpecESN.Create(WebApplication) do
  begin
    DummyESN:= false;
    InitControls;

    if isPartialESN(cbESN.Items[cbESN.ItemIndex]) then
    begin
      txtESN.Lines.Clear;
      txtESN.Lines.Add('Please complete the ESN.');
      edESN.Text := cbESN.Items[cbESN.ItemIndex];
    end;

    Show;
  end
  else UserSession.ShowPages;

  Release;
end;

procedure TfrmSite.bnLogoutClick(Sender: TObject);
begin
  //PR: 17/07/2013 ABSEXCH-14438 Rebranding - replaced old web site with exchequer.com
  //LogoutRedirect is declared in uWRServer
  WebApplication.TerminateAndRedirect(LogoutRedirect);
end;

procedure TfrmSite.bnFilterDealerClick(Sender: TObject);
var
  FilterCond, Contains : string;
begin

  if cbContainsDealer.Checked then
    Contains := '%'
  else
    Contains := '';

  if (Length(Trim(edFilterDealer.Text)) > 0) then
  begin
    // AB 15/09/2003 Changed filter functionality so that a second click
    // without changing the filter will reshow the whole original list.
    // Changed for both dealer and customer filtering.
    if (Trim(edFilterDealer.Text) <> UserSession.sLastDealerFilter) then
    begin
      UserSession.sLastDealerFilter := trim(edFilterDealer.Text);
      FilterCond := 'and groupdesc like ''' + Contains + Trim(edFilterDealer.Text) + '%'' ';
      LoadDealers(FilterCond);
    end
    else
    begin
      UserSession.sLastDealerFilter := '';
      edFilterDealer.Text := '';
      LoadDealers('');
    end;
  end
  else
    LoadDealers('');

  SetDealerID;
  LoadCustomers('');
  LoadESNs;

  UpdateDemoLabel;
end;

procedure TfrmSite.bnFilterCustomerClick(Sender: TObject);
var
  FilterCond, Contains : string;
begin
  if cbContainsCust.Checked then
    Contains := '%'
  else
    Contains := '';

  if (Length(Trim(edFilterCust.Text)) > 0) then
  begin
    // AB 15/09/2003 Changed filter functionality so that a second click
    // without changing the filter will reshow the whole original list.
    // Changed for both dealer and customer filtering.
    if (Trim(edFilterCust.Text) <> UserSession.sLastCustomerFilter) then
    begin
      UserSession.sLastCustomerFilter := trim(edFilterCust.Text);
      FilterCond := 'and custname like ''' + Contains + Trim(edFilterCust.Text) + '%'' ';
      LoadCustomers(FilterCond);
    end
    else
    begin
      UserSession.sLastCustomerFilter := '';
      edFilterCust.Text := '';
      LoadCustomers('');
    end;
  end
  else
    LoadCustomers('');

  LoadESNs;

  UpdateDemoLabel;
end;

procedure TfrmSite.UpdateDemoLabel;
var
  byDemoFlag : byte;
  aESN : ESNByteArrayType;
  ssESN : ShortString;
  siIdx : ShortInt;
begin
  if (trim(cbVersion.Text) = version5) then
  begin
    ssESN := trim(cbESN.Text);
    if (Length(ssESN)>0) then
    begin
      for siIdx := 1 to 7 do
      begin
        if (Length(ssESN) > 3) then
        begin
          try
            aESN[siIdx] := StrToInt(Copy(ssESN, 1, (Pos('-',ssESN)-1)));
          except on EConvertError do
            aESN[siIdx] := 0;
          end; // try...except
          Delete(ssESN, 1, (Pos('-',ssESN)));
        end
        else
        begin
          try
            aESN[siIdx] := StrToInt(ssESN);
          except on EConvertError do
            aESN[siIdx] := 0;
          end; // try...except
        end; // if (Length(ssESN) > 3) then...else...
      end; // for iIdx := 1 to 7 do...
      // zero to the 8th segment for safety
      aESN[8] := 0;
      // byDemoFlag needs to be the 7th segment and...
      byDemoFlag := aESN[7];
      //...the 7th segment needs to be zeroed before the function call.
      aESN[7] := 0;

      if licDecodeDemoFlag(aESN, byDemoFlag) then
        lbDemoHint.Caption := licLicTypeToStr(byDemoFlag, TRUE)
      else
        lbDemoHint.Caption := 'Unknown';
    end; // if (Length(ssESN)) then...
  end
  else
  begin
    lbDemoHint.Caption := '';
  end; // if (cbVersion.Text = version5) then...
end;

//******************************************************************************

end.
