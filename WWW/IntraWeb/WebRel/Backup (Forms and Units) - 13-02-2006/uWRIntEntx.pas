unit uWRIntEntx;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompButton, IWCompEdit, IWCompListbox,
  Classes, Controls, IWControl, IWCompLabel, jpeg, IWExtCtrls, uWRServer,
  IWLayoutMgr, IWTemplateProcessorHTML;

type
  TfrmIntEntx = class(TIWAppForm)
    capDealership: TIWLabel;
    lblDealership: TIWLabel;
    capCustomer: TIWLabel;
    lblCustomer: TIWLabel;
    capESN: TIWLabel;
    lblESN: TIWLabel;
    capVersion: TIWLabel;
    lblhdrPasswords: TIWLabel;
    cbDate: TIWComboBox;
    lblVersion: TIWLabel;
    lblDate: TIWLabel;
    edPlugIn: TIWEdit;
    edMCM: TIWEdit;
    edDaily: TIWEdit;
    edDirectors: TIWEdit;
    lblPlugIn: TIWLabel;
    lblMCM: TIWLabel;
    lblDaily: TIWLabel;
    lblDirectors: TIWLabel;
    lblSecCode: TIWLabel;
    lbl30SecCode: TIWLabel;
    edSecCode: TIWEdit;
    ed30SecCode: TIWEdit;
    edRelCode: TIWEdit;
    bnRelCode: TIWButton;
    ed30RelCode: TIWEdit;
    bn30RelCode: TIWButton;
    lblRelCode: TIWLabel;
    cbRelCodeType: TIWComboBox;
    lblRelCodeType: TIWLabel;
    ed30UserCount: TIWEdit;
    lbl30UserCount: TIWLabel;
    lbl30RelCode: TIWLabel;
    lblhdrSecurity: TIWLabel;
    lblhdrUserCount: TIWLabel;
    cb30RelCodeType: TIWComboBox;
    lbl30RelCodeType: TIWLabel;
    bnPlugIn: TIWButton;
    bnDaily: TIWButton;
    bnDirectors: TIWButton;
    bnMCM: TIWButton;
    lblCoySecCode: TIWLabel;
    edCoySecCode: TIWEdit;
    edCoyRelCode: TIWEdit;
    bnCoyRelCode: TIWButton;
    edCoyCount: TIWEdit;
    lblCoyCount: TIWLabel;
    lblCoyRelCode: TIWLabel;
    lblhdrCompany: TIWLabel;
    bnReturnMain: TIWButton;
    capUserName: TIWLabel;
    lblUserName: TIWLabel;
    TemplateProcessor: TIWTemplateProcessorHTML;
    img1: TIWImage;
    img2: TIWImage;
    img3: TIWImage;
    img4: TIWImage;
    img5: TIWImage;
    bnLogOut: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure cbDateChange(Sender: TObject);
    procedure bnRelCodeClick(Sender: TObject);
    procedure cbRelCodeTypeChange(Sender: TObject);
    procedure edSecCodeSubmit(Sender: TObject);
    procedure ed30SecCodeSubmit(Sender: TObject);
    procedure cb30RelCodeTypeChange(Sender: TObject);
    procedure ed30UserCountSubmit(Sender: TObject);
    procedure bn30RelCodeClick(Sender: TObject);
    procedure bnPlugInClick(Sender: TObject);
    procedure bnMCMClick(Sender: TObject);
    procedure bnDailyClick(Sender: TObject);
    procedure bnDirectorsClick(Sender: TObject);
    procedure bnCoyRelCodeClick(Sender: TObject);
    procedure edCoySecCodeSubmit(Sender: TObject);
    procedure edCoyCountSubmit(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnLogOutClick(Sender: TObject);
  private
    fCautionOnRelease: boolean;

    procedure CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
    procedure CreateTabs;
    procedure GetCodes;
    procedure LoadDates;
    procedure LoadTab;

    procedure EnterpriseClick(Sender: TObject);
    procedure ModulesClick(Sender: TObject);
    procedure OtherClick(Sender: TObject);
    procedure PlugInsClick(Sender: TObject);
    procedure VectronClick(Sender: TObject);

    function CanFullRelease: boolean;
  end;

implementation

{$R *.dfm}

uses SysUtils, uWRIntMods, uWRIntPlugs, uWRIntVect, uWRIntOther, uPermissionIDs,
     uWRSite, uCodeIDs;

//*** Startup and Shutdown *****************************************************

procedure TfrmIntEntx.IWAppFormCreate(Sender: TObject);
begin
  {Initialise the captions that display the site selections; The 30-Day system
   user count option is only available for ESNs version 5 or later;}

  with UserSession, Security do
  begin
    lblDealership.Text:= DealerName;
    lblCustomer.Text:= CustName;
    lblESN.Text:= ESN;
    lblVersion.Text:= Version;
    // AB - 11
    lblUserName.Text := UserName;

    if isNewerVersion(version5) then cb30RelCodeType.Items.Add('30 Day');


    {Ensure there are no customer 30-Day code restrictions, or if there are,
     ensure the user has the override permission for this; Check the user has
     full release permissions for both the Enterprise System release code and
     the user count code and provide the full release option if all conditions
     are satisfied;}

    if CanFullRelease then
    begin
      if Validate(UserCode, pidGetFullEntRel) = 0 then cbRelCodeType.Items.Add(fullRelease);
      if Validate(UserCode, pidGetFullEntUCRel) = 0 then cb30RelCodeType.Items.Add(fullRelease);
    end;


    {All Password and Release Code buttons are disabled by default; The Directors
     password is also invisible; Enable these codes based on the user having the
     required permissions; Note the Directors Password is unavailable for the
     Dummy customer;}

    // AB - 7
    bnPlugIn.Enabled := (Validate(UserCode, pidPlugPass) = 0) and (isNewerVersion(version5));
    bnMCM.Enabled := (Validate(UserCode, pidMCMPass) = 0) and (isNewerVersion(version5));

    bnDaily.Enabled:= Validate(UserCode, pidDailyPass) = 0;
    bnDirectors.Enabled:= not(isDummyCust) and (Validate(UserCode, pidDirsPass) = 0);
    bnRelCode.Enabled:= Validate(UserCode, pidGetFullEntRel) = 0;
    bn30RelCode.Enabled:= Validate(UserCode, pidGetFullEntUCRel) = 0;
    bnCoyRelCode.Enabled:= Validate(UserCode, pidEntCoyRel) = 0;


    {If the system user count release code is unavailable for either 30-day or
     full release i.e. the ESN is pre-version 5 and the user does not have the
     required permissions, do not display the user count controls; Otherwise,
     select the first option;}

    if cb30RelCodeType.Items.Count <= 0 then
    begin
      lblhdrUserCount.Visible:= false;
      lbl30SecCode.Visible:= false;
      ed30SecCode.Visible:= false;
      lbl30RelCodeType.Visible:= false;
      cb30RelCodeType.Visible:= false;
      lbl30UserCount.Visible:= false;
      ed30UserCount.Visible:= false;
      bn30RelCode.Visible:= false;
      lbl30RelCode.Visible:= false;
      ed30RelCode.Visible:= false;
    end
    else cb30RelCodeType.ItemIndex:= 0;


    {The Company Count section is only displayed for version 5 ESNs or later;}

    lblhdrCompany.Visible:= isNewerVersion(version5);
    lblCoySecCode.Visible:= isNewerVersion(version5);
    edCoySecCode.Visible:= isNewerVersion(version5);
    lblCoyCount.Visible:= isNewerVersion(version5);
    edCoyCount.Visible:= isNewerVersion(version5);
    bnCoyRelCode.Visible:= isNewerVersion(version5);
    lblCoyRelCode.Visible:= isNewerVersion(version5);
    edCoyRelCode.Visible:= isNewerVersion(version5);
    bnCoyRelCode.Visible:= isNewerVersion(version5);

    bnDirectors.Visible:= bnDirectors.Enabled;
    lblDirectors.Visible:= bnDirectors.Enabled;
    edDirectors.Visible:= bnDirectors.Enabled;
  end;

  LoadDates;
  GetCodes;
  CreateTabs;
  LoadTab;
end;

procedure TfrmIntEntx.LoadDates;
begin
  {Adds four dates to the date combo box and sets the text to today;}

  with UserSession, cbDate, Items do
  begin
    Add(FormatDateTime('dddd d mmmm yyyy', Date - 1));
    Add(FormatDateTime('dddd d mmmm yyyy', Date));
    Add(FormatDateTime('dddd d mmmm yyyy', Date + 1));
    Add(FormatDateTime('dddd d mmmm yyyy', Date + 2));

    if SecDate <> '' then ItemIndex:= IndexOf(SecDate) else ItemIndex:= 1;
  end;
end;

procedure TfrmIntEntx.GetCodes;
begin
  {If any session state exists for the passwords, restore that state;}

  with UserSession do
  begin
    if PassPlugIn <> '' then edPlugIn.Text:= PassPlugIn;
    if PassMCM <> '' then edMCM.Text:= PassMCM;
    if PassDaily <> '' then edDaily.Text:= PassDaily;
    if PassDirectors <> '' then edDirectors.Text:= PassDirectors;
  end;
end;

procedure TfrmIntEntx.CreateTabs;
var
  CurrentImg : integer;
begin
  {Add each of the tabs the user is permitted to see, keeping track of the tabs
   onscreen position; The other tab is not displayed for pre-version 4.31 ESNs;}

  CurrentImg := 1;

  with UserSession do
  begin
    if npEnterprise in Pages then CreateImage(CurrentImg, 'EnterpriseFront.jpg', EnterpriseClick);
    if npModules in Pages then CreateImage(CurrentImg, 'ModulesBack.jpg', ModulesClick);
    // AB - 8
    if (npPlugIns in Pages) and isNewerVersion(version5) then CreateImage(CurrentImg, 'PlugInsBack.jpg', PlugInsClick);
    if npVectron in Pages then CreateImage(CurrentImg, 'VectronBack.jpg', VectronClick);
    if (npOther in Pages) and isNewerVersion(version431) then CreateImage(CurrentImg, 'OtherBack.jpg', OtherClick);
  end;
end;

procedure TfrmIntEntx.LoadTab;
begin
  {If any session state exists for the release codes and their required fields,
   restore that state;}

  with UserSession do
  begin
    if EntSecCode <> '' then edSecCode.Text:= EntSecCode;
    if EntRelCodeType <> '' then cbRelCodeType.ItemIndex:= cbRelCodeType.Items.IndexOf(EntRelCodeType);
    if EntRelCode <> '' then edRelCode.Text:= EntRelCode;

    if Ent30SecCode <> '' then ed30SecCode.Text:= Ent30SecCode;
    if Ent30RelCodeType <> '' then cb30RelCodeType.ItemIndex:= cb30RelCodeType.Items.IndexOf(Ent30RelCodeType);
    if Ent30UserCount <> '' then ed30UserCount.Text:= Ent30UserCount;
    if Ent30RelCode <> '' then ed30RelCode.Text:= Ent30RelCode;

    if EntCoySecCode <> '' then edCoySecCode.Text:= EntCoySecCode;
    if EntCoyCount <> '' then edCoyCount.Text:= EntCoyCount;
    if EntCoyRelCode <> '' then edCoyRelCode.Text:= EntCoyRelCode;
  end;
end;

//*** Release Code Requests ****************************************************

procedure TfrmIntEntx.bnPlugInClick(Sender: TObject);
var
RelCode: string;
begin
  {Ensure the customer has not reached the threshold for this password; If so,
   notification is made in the ExceededThreshold routine and the event is exited;}

  with UserSession do
  begin
    if ExceededThreshold(cidPlugIn, '') then
    begin
      edPlugIn.Text:= '';
      Exit;
    end;

    {Obtain the internal release code; If unsuccessful, notification is made in
     the GetInternalCode routine; Otherwise, log the release, and set the session
     state variables; If a user moves to a different tab, this password will
     remain visible; Display the password;}

    RelCode:= GetInternalCode(cidPlugIn, GetDate(cbDate.ItemIndex));
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidPlugIn, cbDate.ItemIndex, 0, 0, '');
      PassPlugIn:= RelCode;
      edPlugIn.Text:= PassPlugIn;
    end;
  end;
end;

procedure TfrmIntEntx.bnMCMClick(Sender: TObject);
var
RelCode: string;
begin
  {Ensure the customer has not reached the threshold for this password; If so,
   notification is made in the ExceededThreshold routine and the event is exited;}

  with UserSession do
  begin
    if ExceededThreshold(cidMCM, '') then
    begin
      edMCM.Text:= '';
      Exit;
    end;

    {Obtain the internal release code; If unsuccessful, notification is made in
     the GetInternalCode routine; Otherwise, log the release, and set the session
     state variables; If a user moves to a different tab, this password will
     remain visible; Display the password;}

    RelCode:= GetInternalCode(cidMCM, GetDate(cbDate.ItemIndex));
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidMCM, cbDate.ItemIndex, 0, 0, '');
      PassMCM:= RelCode;
      edMCM.Text:= PassMCM;
    end;
  end;
end;

procedure TfrmIntEntx.bnDailyClick(Sender: TObject);
var
RelCode: string;
begin
  {Ensure the customer has not reached the threshold for this password; If so,
   notification is made in the ExceededThreshold routine and the event is exited;}

  with UserSession do
  begin
    if ExceededThreshold(cidDaily, '') then
    begin
      edDaily.Text:= '';
      Exit;
    end;

    {Obtain the internal release code; If unsuccessful, notification is made in
     the GetInternalCode routine; Otherwise, log the release, and set the session
     state variables; If a user moves to a different tab, this password will
     remain visible; Display the password;}

    RelCode:= GetInternalCode(cidDaily, GetDate(cbDate.ItemIndex));
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidDaily, cbDate.ItemIndex, 0, 0, '');
      PassDaily:= RelCode;
      edDaily.Text:= PassDaily;
    end;
  end;
end;

procedure TfrmIntEntx.bnDirectorsClick(Sender: TObject);
var
RelCode: string;
begin
  {Ensure the customer has not reached the threshold for this password; If so,
   notification is made in the ExceededThreshold routine and the event is exited;}

  with UserSession do
  begin
    if ExceededThreshold(cidDirectors, '') then
    begin
      edDirectors.Text:= '';
      Exit;
    end;

    {Obtain the internal release code; If unsuccessful, notification is made in
     the GetInternalCode routine; Otherwise, log the release, and set the session
     state variables; If a user moves to a different tab, this password will
     remain visible; Display the password;}

    RelCode:= GetInternalCode(cidDirectors, GetDate(cbDate.ItemIndex));
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidDirectors, cbDate.ItemIndex, 0, 0, '');
      PassDirectors:= RelCode;
      edDirectors.Text:= PassDirectors;
    end;
  end;
end;

procedure TfrmIntEntx.bnRelCodeClick(Sender: TObject);
var
RelCodeType: integer;
SecCode, RelCode: string;
ThirtyDay: boolean;
begin
  {Ensure a security code has been provided and that it is in uppercase; Also
   ensure the threshold for this code has not been reached; If these criteria
   are not met display the error notification and exit;}

  with UserSession do
  begin
    if Trim(edSecCode.Text) = '' then
    begin
      WebApplication.ShowMessage('A release code can not be generated without a security code.');
      Exit;
    end
    else SecCode:= UpperCase(Trim(edSecCode.Text));

    if ExceededThreshold(cidEntRel, '') then
    begin
      edRelCode.Text:= '';
      Exit;
    end;


    {Initialise a couple of parameter variables based on the release code type;
     The AuditLog routine requires an index, the routines that generate the
     release codes require a ThirtyDay boolean;}

    if cbRelCodeType.Text = fullRelease then RelCodeType:= 1 else RelCodeType:= 0;
    ThirtyDay:= cbRelCodeType.Text <> fullRelease;


    {Obtain the release code supplying all but the last two default parameters;
     If a release code is not returned successfully, the release code routine
     will have handled user notification; Otherwise log the successful release,
     and set the session state variables; Now when a user returns to this tab,
     the values will be restored so long as the security date has not been changed
     and the user is not returned to the Site page in between; Display the release
     code; Finally, if the user has overridden the 30-Day customer code restriction,
     caution them;}

    RelCode:= GetInternalCode(cidEntRel, GetDate(cbDate.ItemIndex), ThirtyDay, SecCode);
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidEntRel, cbDate.ItemIndex, RelCodeType, 0, '');
      EntSecCode:= edSecCode.Text;
      EntRelCodeType:= cbRelCodeType.Text;
      EntRelCode:= RelCode;
      edRelCode.Text:= EntRelCode;
      if fCautionOnRelease and (cbRelCodeType.Text = fullRelease) then WebApplication.ShowMessage('You have overridden the 30-day release code restriction for this customer.' + #13#10#13#10 + 'You may want to reconsider giving this release code out.');
    end;
  end;
end;

procedure TfrmIntEntx.bn30RelCodeClick(Sender: TObject);
var
UserCount, RelCodeType: integer;
SecCode, RelCode: string;
ThirtyDay: boolean;
begin
  {Ensure a security code has been provided and that it is in uppercase; Also
   ensure a valid user count has been supplied and that the threshold for this
   code has not been reached; If these criteria are not met display the error
   notification and exit;}

  with UserSession do
  begin
    if Trim(ed30SecCode.Text) = '' then
    begin
      WebApplication.ShowMessage('A release code can not be generated without a security code.');
      Exit;
    end
    else SecCode:= UpperCase(Trim(ed30SecCode.Text));

    UserCount:= StrToIntDef(Trim(ed30UserCount.Text), -1);
    if UserCount < 0 then
    begin
      WebApplication.ShowMessage('Please enter a valid user count.');
      Exit;
    end;

    if ExceededThreshold(cidEntUCRel, '') then
    begin
      ed30RelCode.Text:= '';
      Exit;
    end;


    {Initialise a couple of variables based on the release code type; The AuditLog
     routine requires an index, the routines that generate the release codes
     require a ThirtyDay boolean;}

    ThirtyDay:= cb30RelCodeType.Text <> fullRelease;
    if cb30RelCodeType.Text = fullRelease then RelCodeType:= 1 else RelCodeType:= 0;


    {Obtain the release code supplying all but the module parameter; If a release
     code is not returned successfully, the release code routine will have handled
     user notification; Otherwise log the successful release, and set the session
     state variables; Now when a user returns to this tab, the values will be
     restored so long as the security date has not been changed and the user is
     not returned to the Site page in between; Display the release code; Finally,
     if the user has overridden the 30-Day customer code restriction, caution them;}

    RelCode:= GetInternalCode(cidEntUCRel, GetDate(cbDate.ItemIndex), ThirtyDay, SecCode, UserCount);
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidEntUCRel, cbDate.ItemIndex, RelCodeType, StrToIntDef(ed30UserCount.Text, 0), '');
      Ent30SecCode:= ed30SecCode.Text;
      Ent30RelCodeType:= cb30RelCodeType.Text;
      Ent30UserCount:= ed30UserCount.Text;
      Ent30RelCode:= RelCode;
      ed30RelCode.Text:= Ent30RelCode;
      if fCautionOnRelease and (cb30RelCodeType.Text = fullRelease) then WebApplication.ShowMessage('You have overridden the 30-day release code restriction for this customer.' + #13#10#13#10 + 'You may want to reconsider giving this release code out.');
    end;
  end;
end;

procedure TfrmIntEntx.bnCoyRelCodeClick(Sender: TObject);
var
CoyCount: integer;
SecCode, RelCode: string;
begin
  {Ensure a security code has been provided and that it is in uppercase; Also
   ensure a valid company count has been supplied and that the threshold for this
   code has not been reached; If these criteria are not met display the error
   notification and exit;}

  with UserSession do
  begin
    if Trim(edCoySecCode.Text) = '' then
    begin
      WebApplication.ShowMessage('A release code can not be generated without a security code.');
      Exit;
    end
    else SecCode:= UpperCase(Trim(edCoySecCode.Text));

    CoyCount:= StrToIntDef(Trim(edCoyCount.Text), -1);
    if CoyCount < 0 then
    begin
      WebApplication.ShowMessage('Please enter a valid user count.');
      Exit;
    end;

    if ExceededThreshold(cidEntCoyRel, '') then
    begin
      edCoyRelCode.Text:= '';
      Exit;
    end;


    {Obtain the release code supplying all but the module parameter; If a release
     code is not returned successfully, the release code routine will have handled
     user notification; Otherwise log the successful release, and set the session
     state variables; Now when a user returns to this tab, the values will be
     restored so long as the security date has not been changed and the user is
     not returned to the Site page in between; Display the release code;}

    RelCode:= GetInternalCode(cidEntCoyRel, GetDate(cbDate.ItemIndex), true, SecCode, CoyCount);
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidEntCoyRel, cbDate.ItemIndex, 0, StrToIntDef(edCoyCount.Text, 0), '');
      EntCoySecCode:= edCoySecCode.Text;
      EntCoyCount:= edCoyCount.Text;
      EntCoyRelCode:= RelCode;
      edCoyRelCode.Text:= EntCoyRelCode;
    end;
  end;
end;

//*** Helper Functions *********************************************************

procedure TfrmIntEntx.CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
begin
  case CurrentImg of
    1:
    begin
      img1.Picture.LoadFromFile('C:\Development\WebRel\TabImages\' + ImageName);
      img1.OnClick:= ClickProc;
    end;
    2:
    begin
      img2.Picture.LoadFromFile('C:\Development\WebRel\TabImages\' + ImageName);
      img2.OnClick:= ClickProc;
    end;
    3:
    begin
      img3.Picture.LoadFromFile('C:\Development\WebRel\TabImages\' + ImageName);
      img3.OnClick:= ClickProc;
    end;
    4:
    begin
      img4.Picture.LoadFromFile('C:\Development\WebRel\TabImages\' + ImageName);
      img4.OnClick:= ClickProc;
    end;
    5:
    begin
      img5.Picture.LoadFromFile('C:\Development\WebRel\TabImages\' + ImageName);
      img5.OnClick:= ClickProc;
    end;
  end;

  inc(CurrentImg);
end;

function TfrmIntEntx.CanFullRelease: boolean;
begin
  {Set a caution flag if a user could potentially override a 30-Day customer code
   restriction on this page; If an override occurs, the release handler will
   display a caution message;

   If the customer is not restricted in this way, or they are restricted but the
   user has permission to override this restriction, a full release can be granted
   and this function returns true;}

  with UserSession, Security do
  begin
    fCautionOnRelease:= CustRestricted and (Validate(UserCode, pidOverrideCustRestrict) = 0);
    CanFullRelease := ((not(CustRestricted)) or (Validate(UserCode, pidOverrideCustRestrict) = 0)) and
                      (UserSession.bUsingDummyESN = FALSE); // AB Added 
  end;
end;

//*** Event Handlers ***********************************************************

procedure TfrmIntEntx.cbDateChange(Sender: TObject);
begin
  {Reset all session state because new release codes can now be obtained; Clear
   all the current onscreen fields;}

  UserSession.ResetState;

  edPlugIn.Text:= '';
  edMCM.Text:= '';
  edDaily.Text:= '';
  edDirectors.Text:= '';
  edRelCode.Text:= '';
  ed30RelCode.Text:= '';
  edCoyRelCode.Text:= '';

  UserSession.SecDate:= cbDate.Text;
end;

procedure TfrmIntEntx.bnReturnMainClick(Sender: TObject);
begin
  {Return to the Site page and release the current page;}

  TfrmSite.Create(WebApplication).Show;
  Release;
end;

//*** Tab Click Handlers *******************************************************

{Display the page corresponding with the tab clicked and release the current page;
 Clicking on the current tab has no effect;}

procedure TfrmIntEntx.EnterpriseClick(Sender: TObject);
begin
  //
end;

procedure TfrmIntEntx.ModulesClick(Sender: TObject);
begin
  TfrmIntMods.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntEntx.PlugInsClick(Sender: TObject);
begin
  TfrmIntPlugs.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntEntx.VectronClick(Sender: TObject);
begin
  TfrmIntVect.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntEntx.OtherClick(Sender: TObject);
begin
  TfrmIntOther.Create(WebApplication).Show;
  Release;
end;

//*** Control Submit Handlers **************************************************

{When a page control is submitted ensure that any release code currently onscreen
 is cleared and the session state is consistent; Update the new submission in the
 session state; The active control is also advanced except in the case of
 drop-down lists where a user may only be scrolling in the control with the arrow
 keys;}

procedure TfrmIntEntx.cbRelCodeTypeChange(Sender: TObject);
begin
  UserSession.EntRelCodeType:= cbRelCodeType.Text;
  UserSession.EntRelCode:= '';
  edRelCode.Text:= '';
end;

procedure TfrmIntEntx.edSecCodeSubmit(Sender: TObject);
begin
  UserSession.EntSecCode:= edSecCode.Text;
  UserSession.EntRelCode:= '';
  edRelCode.Text:= '';
  ActiveControl:= cbRelCodeType;
end;

procedure TfrmIntEntx.ed30SecCodeSubmit(Sender: TObject);
begin
  UserSession.Ent30SecCode:= ed30SecCode.Text;
  UserSession.Ent30RelCode:= '';
  ed30RelCode.Text:= '';
  ActiveControl:= cb30RelCodeType;
end;

procedure TfrmIntEntx.cb30RelCodeTypeChange(Sender: TObject);
begin
  UserSession.Ent30RelCodeType:= cb30RelCodeType.Text;
  UserSession.Ent30RelCode:= '';
  ed30RelCode.Text:= '';
end;

procedure TfrmIntEntx.ed30UserCountSubmit(Sender: TObject);
begin
  UserSession.Ent30UserCount:= ed30UserCount.Text;
  UserSession.Ent30RelCode:= '';
  ed30RelCode.Text:= '';
  ActiveControl:= bn30RelCode;
end;

procedure TfrmIntEntx.edCoySecCodeSubmit(Sender: TObject);
begin
  UserSession.EntCoySecCode:= edCoySecCode.Text;
  UserSession.EntCoyRelCode:= '';
  edCoyRelCode.Text:= '';
  ActiveControl:= edCoyCount;
end;

procedure TfrmIntEntx.edCoyCountSubmit(Sender: TObject);
begin
  UserSession.EntCoyCount:= edCoyCount.Text;
  UserSession.EntCoyRelCode:= '';
  edCoyRelCode.Text:= '';
  ActiveControl:= bnCoyRelCode;
end;

//******************************************************************************

procedure TfrmIntEntx.bnLogOutClick(Sender: TObject);
begin
  WebApplication.TerminateAndRedirect('http://www.exchequer.com');
end;

end.