unit uWRExtEntx;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompLabel, IWCompButton, Classes,
  Controls, IWControl, IWCompListbox, IWCompEdit, IWCompCheckbox, uWRServer,
  IWExtCtrls, IWLayoutMgr, IWTemplateProcessorHTML;

type
  TfrmExtEntx = class(TIWAppForm)
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
    lblPlugIn: TIWLabel;
    lblMCM: TIWLabel;
    lblDaily: TIWLabel;
    lblDirectors: TIWLabel;
    bnPlugIn: TIWButton;
    bnDaily: TIWButton;
    bnDirectors: TIWButton;
    bnMCM: TIWButton;
    bnReturnMain: TIWButton;
    lblSendVia: TIWLabel;
    cbEmail: TIWCheckBox;
    cbSMS: TIWCheckBox;
    lblSecCode: TIWLabel;
    lbl30SecCode: TIWLabel;
    edSecCode: TIWEdit;
    ed30SecCode: TIWEdit;
    bnRelCode: TIWButton;
    bn30RelCode: TIWButton;
    cbRelCodeType: TIWComboBox;
    lblRelCodeType: TIWLabel;
    ed30UserCount: TIWEdit;
    lbl30UserCount: TIWLabel;
    lblhdrSecurity: TIWLabel;
    lblhdrUserCount: TIWLabel;
    img1: TIWImage;
    img2: TIWImage;
    img3: TIWImage;
    bnLogout: TIWButton;
    TemplateProcessor: TIWTemplateProcessorHTML;
    capUserName: TIWLabel;
    lblUserName: TIWLabel;
    img4: TIWImage;
    img5: TIWImage;
    procedure IWAppFormCreate(Sender: TObject);
    procedure bnPlugInClick(Sender: TObject);
    procedure bnMCMClick(Sender: TObject);
    procedure bnDailyClick(Sender: TObject);
    procedure bnDirectorsClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnRelCodeClick(Sender: TObject);
    procedure bn30RelCodeClick(Sender: TObject);
    procedure cbEmailClick(Sender: TObject);
    procedure cbSMSClick(Sender: TObject);
    procedure edSecCodeSubmit(Sender: TObject);
    procedure ed30SecCodeSubmit(Sender: TObject);
    procedure bnLogoutClick(Sender: TObject);
    procedure cbDateChange(Sender: TObject);
    procedure cbRelCodeTypeChange(Sender: TObject);
  private
    procedure CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
    procedure CreateTabs;
    procedure LoadDates;
    procedure LoadTab;

    procedure EnterpriseClick(Sender: TObject);
    procedure ModulesClick(Sender: TObject);
    procedure OtherClick(Sender: TObject);
    procedure PlugInsClick(Sender: TObject);
    procedure VectronClick(Sender: TObject);

    function CanFullRelease: boolean;
    function GetSendSet: TSendSet;
  end;

implementation

{$R *.dfm}

uses uCodeIDs, uCodeGen, uPermissionIDs,
     uWRSite, uWRExtTkit, uWRExtOther, uWRExtMods, uWRExtVect, uWRExtPlug,
     SysUtils;

//*** Startup and Shutdown *****************************************************

procedure TfrmExtEntx.IWAppFormCreate(Sender: TObject);
begin
  {Initialise form controls;}

  with UserSession, Security do
  begin
    // AB - 14
    cbEmail.Enabled := (UserSession.Email <> '');
    if cbEmail.Enabled then
      cbEmail.Checked := SendViaEmail
    else
      cbEmail.Checked := FALSE;

    cbSMS.Enabled := (UserSession.SMSPhone <> '');
    if cbSMS.Enabled then
      cbSMS.Checked := SendViaSMS
    else
      cbSMS.Checked := FALSE;

    lblDealership.Text:= DealerName;
    lblCustomer.Text:= CustName;
    lblESN.Text:= ESN;
    lblVersion.Text:= Version;
    // AB - 11
    lblUserName.Text := UserName;

    if CanFullRelease and ((Validate(UserCode, pidGetFullEntRel) = 0) or (Validate(UserCode, pidReqFullEntRel) = 0)) then cbRelCodeType.Items.Add(fullRelease);
    if Validate(UserCode, pidPlugPass) = 0 then bnPlugIn.Caption:= 'Get Password';
    if Validate(UserCode, pidMCMPass) = 0 then bnMCM.Caption:= 'Get Password';
    if Validate(UserCode, pidDailyPass) = 0 then bnDaily.Caption:= 'Get Password';
    if Validate(UserCode, pidDirsPass) = 0 then bnDirectors.Caption:= 'Get Password';
    if Validate(UserCode, pidGet30EntUCRel) = 0 then bn30RelCode.Caption:= 'Get Release Code';
    cbRelCodeTypeChange(Self);

    lblhdrUserCount.Visible:= isNewerVersion(version5);
    lbl30SecCode.Visible:= isNewerVersion(version5);
    ed30SecCode.Visible:= isNewerVersion(version5);
    lbl30UserCount.Visible:= isNewerVersion(version5);
    ed30UserCount.Visible:= isNewerVersion(version5);
    bn30RelCode.Visible:= isNewerVersion(version5);

    // AB - 7
    bnPlugIn.Enabled := ((Validate(UserCode, pidReqPlugPass) = 0) or
                         (Validate(UserCode, pidPlugPass) = 0)) and
                        (isNewerVersion(version5));
    bnMCM.Enabled := ((Validate(UserCode, pidReqMCMPass) = 0) or
                      (Validate(UserCode, pidMCMPass) = 0)) and
                     (isNewerVersion(version5));

    bnDaily.Enabled:= (Validate(UserCode, pidReqDailyPass) = 0) or (Validate(UserCode, pidDailyPass) = 0);
    bnDirectors.Enabled:= (Validate(UserCode, pidReqDirsPass) = 0) or (Validate(UserCode, pidDirsPass) = 0);
    bnRelCode.Enabled:= (Validate(UserCode, pidReqFullEntRel) = 0) or (Validate(UserCode, pidGetFullEntRel) = 0) or (Validate(UserCode, pidReq30EntRel) = 0) or (Validate(UserCode, pidGet30EntRel) = 0);
    bn30RelCode.Enabled:= (Validate(UserCode, pidGetFullEntUCRel) = 0) or (Validate(UserCode, pidReq30EntUCRel) = 0) or (Validate(UserCode, pidGet30EntUCRel) = 0);

    bnDirectors.Visible:= bnDirectors.Enabled;
    lblDirectors.Visible:= bnDirectors.Enabled;
  end;

  LoadDates;
  CreateTabs;
  LoadTab;
end;

//*** Main *********************************************************************

procedure TfrmExtEntx.LoadDates;
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

procedure TfrmExtEntx.CreateTabs;
var
CurrentImg: integer;
begin
  CurrentImg:= 1;

  with UserSession, Security do
  begin
    if npEnterprise in Pages then CreateImage(CurrentImg, 'EnterpriseFront.jpg', EnterpriseClick);
    if npModules in Pages then
    begin
      if Validate(UserCode, pidShowAllModules) = 0 then
        CreateImage(CurrentImg, 'ModulesBack.jpg', ModulesClick)
      else
        CreateImage(CurrentImg, 'ToolkitBack.jpg', ModulesClick)
    end;
    if (npPlugIns in Pages) and isNewerVersion(version5) then CreateImage(CurrentImg, 'PlugInsBack.jpg', PlugInsClick);
    if npVectron in Pages then CreateImage(CurrentImg, 'VectronBack.jpg', VectronClick);
    if (npOther in Pages) and isNewerVersion(version431) then
      CreateImage(CurrentImg, 'OtherBack.jpg', OtherClick);
  end;
end;

procedure TfrmExtEntx.CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
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

procedure TfrmExtEntx.LoadTab;
begin
  with UserSession do
  begin
    if EntSecCode <> '' then edSecCode.Text:= EntSecCode;
    if EntRelCodeType <> '' then cbRelCodeType.ItemIndex:= cbRelCodeType.Items.IndexOf(EntRelCodeType);
    
    if Ent30SecCode <> '' then ed30SecCode.Text:= Ent30SecCode;
    if Ent30UserCount <> '' then ed30UserCount.Text:= Ent30UserCount;
  end;
end;

procedure TfrmExtEntx.EnterpriseClick(Sender: TObject);
begin
  //
end;

procedure TfrmExtEntx.ModulesClick(Sender: TObject);
begin
  with UserSession, Security do
  begin
    if Validate(UserCode, pidShowAllModules) = 0 then TfrmExtMods.Create(WebApplication).Show
    else TfrmExtTkit.Create(WebApplication).Show;
  end;

  Release;
end;

procedure TfrmExtEntx.OtherClick(Sender: TObject);
begin
  TfrmExtOther.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtEntx.PlugInsClick(Sender: TObject);
begin
  TfrmExtPlugs.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtEntx.VectronClick(Sender: TObject);
begin
  TfrmExtVect.Create(WebApplication).Show;
  Release;
end;

//******************************************************************************

function TfrmExtEntx.GetSendSet: TSendSet;
begin
  Result:= [];

  if cbEmail.Checked then Result:= Result + [stEmail];
  if cbSMS.Checked then Result:= Result + [stSMS];
end;

procedure TfrmExtEntx.bnPlugInClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession, Security do
  begin
    if not isValidSendVia(GetSendSet) then Exit;
    if ExceededThreshold(cidPlugIn, '') then Exit;

    if Validate(UserCode, pidPlugPass) = 0 then RelCode:= GetExternalCode(GetSendSet, true, dcPlugIn, GetDate(cbDate.ItemIndex))
    else if Validate(UserCode, pidReqPlugPass) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcPlugIn, GetDate(cbDate.ItemIndex))
    else RelCode:= '';

    if RelCode <> '' then AuditLog(RelCode, cidPlugIn, cbDate.ItemIndex, 0, 0, '');
  end;
end;

procedure TfrmExtEntx.bnMCMClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession, Security do
  begin
    if not isValidSendVia(GetSendSet) then Exit;
    if ExceededThreshold(cidMCM, '') then Exit;

    if Validate(UserCode, pidMCMPass) = 0 then RelCode:= GetExternalCode(GetSendSet, true, dcMCM, GetDate(cbDate.ItemIndex))
    else if Validate(UserCode, pidReqMCMPass) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcMCM, GetDate(cbDate.ItemIndex))
    else RelCode:= '';

    if RelCode <> '' then AuditLog(RelCode, cidMCM, cbDate.ItemIndex, 0, 0, '');
  end;
end;

procedure TfrmExtEntx.bnDailyClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession, Security do
  begin
    if not isValidSendVia(GetSendSet) then Exit;
    if ExceededThreshold(cidDaily, '') then Exit;

    if Validate(UserCode, pidDailyPass) = 0 then RelCode:= GetExternalCode(GetSendSet, true, dcDaily, GetDate(cbDate.ItemIndex))
    else if Validate(UserCode, pidReqDailyPass) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcDaily, GetDate(cbDate.ItemIndex))
    else RelCode:= '';

    if RelCode <> '' then AuditLog(RelCode, cidDaily, cbDate.ItemIndex, 0, 0, '');
  end;
end;

procedure TfrmExtEntx.bnDirectorsClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession, Security do
  begin
    if not isValidSendVia(GetSendSet) then Exit;
    if ExceededThreshold(cidDirectors, '') then Exit;

    if Validate(UserCode, pidDirsPass) = 0 then RelCode:= GetExternalCode(GetSendSet, true, dcDirectors, GetDate(cbDate.ItemIndex))
    else if Validate(UserCode, pidReqDirsPass) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcDirectors, GetDate(cbDate.ItemIndex))
    else RelCode:= '';

    if RelCode <> '' then AuditLog(RelCode, cidDirectors, cbDate.ItemIndex, 0, 0, '');
  end;
end;

procedure TfrmExtEntx.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtEntx.bnRelCodeClick(Sender: TObject);
var
RelCodeType: integer;
SecCode, RelCode: string;
ThirtyDay: boolean;
begin
  with UserSession, Security do
  begin
    if not isValidSendVia(GetSendSet) then Exit;

    if Trim(edSecCode.Text) = '' then
    begin
      WebApplication.ShowMessage('A release code can not be generated without a security code.');
      Exit;
    end
    else SecCode:= UpperCase(Trim(edSecCode.Text));

    if ExceededThreshold(cidEntRel, '') then Exit;

    RelCode:= '';
    if cbRelCodeType.Text = fullRelease then RelCodeType:= 1 else RelCodeType:= 0;
    ThirtyDay:= cbRelCodeType.Text <> fullRelease;

    if ThirtyDay then
    begin
      if Validate(UserCode, pidGet30EntRel) = 0 then RelCode:= GetExternalCode(GetSendSet, true, dcSystem, GetDate(cbDate.ItemIndex), true, SecCode)
      else if Validate(UserCode, pidReq30EntRel) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcSystem, GetDate(cbDate.ItemIndex), true, SecCode);
    end
    else
    begin
      if Validate(UserCode, pidGetFullEntRel) = 0 then RelCode:= GetExternalCode(GetSendSet, true, dcSystem, GetDate(cbDate.ItemIndex), false, SecCode)
      else if Validate(UserCode, pidReqFullEntRel) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcSystem, GetDate(cbDate.ItemIndex), false, SecCode);
    end;

    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidEntRel, cbDate.ItemIndex, RelCodeType, 0, '');
      EntSecCode:= Trim(edSecCode.Text);
      EntRelCodeType:= cbRelCodeType.Text;
    end;
  end;
end;

procedure TfrmExtEntx.bn30RelCodeClick(Sender: TObject);
var
SecCode, RelCode: string;
UserCount: integer;
begin
  with UserSession, Security do
  begin
    if not isValidSendVia(GetSendSet) then Exit;

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

    if ExceededThreshold(cidEntUCRel, '') then Exit;

    if Validate(UserCode, pidGet30EntUCRel) = 0 then RelCode:= GetExternalCode(GetSendSet, true, dcSystemUC, GetDate(cbDate.ItemIndex), true, SecCode, UserCount)
    else if Validate(UserCode, pidReq30EntUCRel) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcSystemUC, GetDate(cbDate.ItemIndex), true, SecCode, UserCount)
    else RelCode:= '';

    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidEntUCRel, cbDate.ItemIndex, 0, StrToIntDef(ed30UserCount.Text, 0), '');
      Ent30SecCode:= Trim(ed30SecCode.Text);
      Ent30UserCount:= Trim(ed30UserCount.Text);
    end;
  end;
end;

procedure TfrmExtEntx.cbEmailClick(Sender: TObject);
begin
  UserSession.SendViaEmail:= cbEmail.Checked;
end;

procedure TfrmExtEntx.cbSMSClick(Sender: TObject);
begin
  UserSession.SendViaSMS:= cbSMS.Checked;
end;

function TfrmExtEntx.CanFullRelease: boolean;
begin
  with UserSession, Security do
  begin
    CanFullRelease := ((not(CustRestricted)) or (Validate(UserCode, pidOverrideCustRestrict) = 0)) and
                      (UserSession.bUsingDummyESN = FALSE);    // AB - Added
  end;
end;

procedure TfrmExtEntx.edSecCodeSubmit(Sender: TObject);
begin
  ActiveControl:= cbRelCodeType;
end;

procedure TfrmExtEntx.ed30SecCodeSubmit(Sender: TObject);
begin
  ActiveControl:= ed30UserCount;
end;

procedure TfrmExtEntx.bnLogoutClick(Sender: TObject);
begin
  //PR: 17/07/2013 ABSEXCH-14438 Rebranding - replaced old web site with exchequer.com
  //LogoutRedirect is declared in uWRServer
  WebApplication.TerminateAndRedirect(LogoutRedirect);
end;

procedure TfrmExtEntx.cbDateChange(Sender: TObject);
begin
  with UserSession do
  begin
    ResetState;
    SecDate:= cbDate.Text;
  end;
end;

procedure TfrmExtEntx.cbRelCodeTypeChange(Sender: TObject);
begin
  with UserSession, Security do
  begin
    if cbRelCodeType.Text = fullRelease then
    begin
      if Validate(UserCode, pidGetFullEntRel) = 0 then bnRelCode.Caption:= 'Get Release Code' else bnRelCode.Caption:= 'Request Code';
    end
    else
    begin
      if Validate(UserCode, pidGet30EntRel) = 0 then bnRelCode.Caption:= 'Get Release Code' else bnRelCode.Caption:= 'Request Code';
    end;
  end;
end;

end.
