unit uWRExtMods;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompEdit, IWCompCheckbox, uWRServer,
  IWCompButton, IWCompListbox, Classes, Controls, IWControl, IWCompLabel,
  IWExtCtrls, IWLayoutMgr, IWTemplateProcessorHTML;

type
  TfrmExtMods = class(TIWAppForm)
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
    img1: TIWImage;
    img2: TIWImage;
    img3: TIWImage;
    bnLogout: TIWButton;
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
    cb30RelCodeType: TIWComboBox;
    lbl30RelCodeType: TIWLabel;
    cbModule: TIWComboBox;
    lblModule: TIWLabel;
    cb30Module: TIWComboBox;
    lbl30Module: TIWLabel;
    TemplateProcessor: TIWTemplateProcessorHTML;
    capUserName: TIWLabel;
    lblUserName: TIWLabel;
    img4: TIWImage;
    img5: TIWImage;
    procedure IWAppFormCreate(Sender: TObject);
    procedure cbEmailClick(Sender: TObject);
    procedure cbDateChange(Sender: TObject);
    procedure cbSMSClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnLogoutClick(Sender: TObject);
    procedure bnPlugInClick(Sender: TObject);
    procedure bnMCMClick(Sender: TObject);
    procedure bnDailyClick(Sender: TObject);
    procedure bnDirectorsClick(Sender: TObject);
    procedure cbModuleChange(Sender: TObject);
    procedure edSecCodeSubmit(Sender: TObject);
    procedure cbRelCodeTypeChange(Sender: TObject);
    procedure bnRelCodeClick(Sender: TObject);
    procedure cb30ModuleChange(Sender: TObject);
    procedure ed30SecCodeSubmit(Sender: TObject);
    procedure cb30RelCodeTypeChange(Sender: TObject);
    procedure ed30UserCountSubmit(Sender: TObject);
    procedure bn30RelCodeClick(Sender: TObject);
  private
    procedure CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
    procedure CreateTabs;
    procedure LoadDates;
    procedure LoadModules;
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

uses
  SysUtils,
  uCodeGen, uCodeIDs, uPermissionIDs,
  uWRSite, uWRExtEntx, uWRExtOther, uWRExtPlug, uWRExtVect,
  uWRData;

procedure TfrmExtMods.IWAppFormCreate(Sender: TObject);
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

    cbSMS.Enabled := (UserSession.SMSPhone <> '' );
    if cbSMS.Enabled then
      cbSMS.Checked:= SendViaSMS
    else
      cbSMS.Checked := FALSE;

    lblDealership.Text:= DealerName;
    lblCustomer.Text:= CustName;
    lblESN.Text:= ESN;
    lblVersion.Text:= Version;
    // AB - 11
    lblUserName.Text := UserName;

    if CanFullRelease then
    begin
      if ((Validate(UserCode, pidGetFullModRel) = 0) or (Validate(UserCode, pidReqFullModRel) = 0)) then cbRelCodeType.Items.Add(fullRelease);
      if ((Validate(UserCode, pidGetFullModUCRel) = 0) or (Validate(UserCode, pidReqFullModUCRel) = 0)) then cb30RelCodeType.Items.Add(fullRelease);
    end;

    if Validate(UserCode, pidPlugPass) = 0 then bnPlugIn.Caption:= 'Get Password';
    if Validate(UserCode, pidMCMPass) = 0 then bnMCM.Caption:= 'Get Password';
    if Validate(UserCode, pidDailyPass) = 0 then bnDaily.Caption:= 'Get Password';
    if Validate(UserCode, pidDirsPass) = 0 then bnDirectors.Caption:= 'Get Password';
    cbRelCodeTypeChange(Self);
    cb30RelCodeTypeChange(Self);

    // AB - 7
    bnPlugIn.Enabled := ((Validate(UserCode, pidReqPlugPass) = 0) or
                         (Validate(UserCode, pidPlugPass) = 0)) and
                         (isNewerVersion(version5));
    bnMCM.Enabled := ((Validate(UserCode, pidReqMCMPass) = 0) or
                      (Validate(UserCode, pidMCMPass) = 0)) and
                      (isNewerVersion(version5));

    bnDaily.Enabled:= (Validate(UserCode, pidReqDailyPass) = 0) or (Validate(UserCode, pidDailyPass) = 0);
    bnDirectors.Enabled:= (Validate(UserCode, pidReqDirsPass) = 0) or (Validate(UserCode, pidDirsPass) = 0);
    bnRelCode.Enabled:= (Validate(UserCode, pidReqFullModRel) = 0) or (Validate(UserCode, pidGetFullModRel) = 0) or (Validate(UserCode, pidReq30ModRel) = 0) or (Validate(UserCode, pidGet30ModRel) = 0);
    bn30RelCode.Enabled:= (Validate(UserCode, pidReqFullModUCRel) = 0) or (Validate(UserCode, pidGetFullModUCRel) = 0) or (Validate(UserCode, pidReq30ModUCRel) = 0) or (Validate(UserCode, pidGet30ModUCRel) = 0);

    lblhdrUserCount.Visible:= isNewerVersion(version5);
    lbl30Module.Visible:= isNewerVersion(version5);
    cb30Module.Visible:= isNewerVersion(version5);
    lbl30SecCode.Visible:= isNewerVersion(version5);
    ed30SecCode.Visible:= isNewerVersion(version5);
    lbl30RelCodeType.Visible:= isNewerVersion(version5);
    cb30RelCodeType.Visible:= isNewerVersion(version5);
    lbl30UserCount.Visible:= isNewerVersion(version5);
    ed30UserCount.Visible:= isNewerVersion(version5);
    bn30RelCode.Visible:= isNewerVersion(version5);

    bnDirectors.Visible:= bnDirectors.Enabled;
    lblDirectors.Visible:= bnDirectors.Enabled;
  end;

  LoadDates;
  CreateTabs;
  LoadModules;
  LoadTab;
end;

//*** Main *********************************************************************

procedure TfrmExtMods.LoadDates;
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

procedure TfrmExtMods.CreateTabs;
var
CurrentImg: integer;
begin
  CurrentImg:= 1;

  with UserSession do
  begin
    if npEnterprise in Pages then CreateImage(CurrentImg, 'EnterpriseBack.jpg', EnterpriseClick);
    if npModules in Pages then CreateImage(CurrentImg, 'ModulesFront.jpg', ModulesClick);
    if npPlugIns in Pages then CreateImage(CurrentImg, 'PlugInsBack.jpg', PlugInsClick);
    if npVectron in Pages then CreateImage(CurrentImg, 'VectronBack.jpg', VectronClick);
    if (npOther in Pages) and isNewerVersion(version431) then CreateImage(CurrentImg, 'OtherBack.jpg', OtherClick);
  end;
end;

procedure TfrmExtMods.CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
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

procedure TfrmExtMods.LoadModules;
begin
  cbModule.Items.Clear;
  cb30Module.Items.Clear;

  with WRData.qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select * from modules where plugin = 0 ');
    Open;

    while not eof do
    begin
      cbModule.Items.Add(FieldByName('ModuleName').AsString);
      Next;
    end;

    Close;
    Sql.Clear;
    Sql.Add('select * from modules where plugin = 0 and usercount = 1 ');
    Open;

    while not eof do
    begin
      cb30Module.Items.Add(FieldByName('ModuleName').AsString);
      Next;
    end;
  end;

  if cbModule.Items.Count > 0 then with UserSession do
  begin
    if ModModule <> '' then cbModule.ItemIndex:= cbModule.Items.IndexOf(ModModule) else cbModule.ItemIndex:= 0;
  end;

  if cb30Module.Items.Count > 0 then with UserSession do
  begin
    if Mod30Module <> '' then cb30Module.ItemIndex:= cb30Module.Items.IndexOf(Mod30Module) else cb30Module.ItemIndex:= 0;
  end;
end;

procedure TfrmExtMods.LoadTab;
begin
  with UserSession do
  begin
    if ModModule <> '' then cbModule.ItemIndex:= cbModule.Items.IndexOf(ModModule);
    if ModSecCode <> '' then edSecCode.Text:= ModSecCode;
    if ModRelCodeType <> '' then cbRelCodeType.ItemIndex:= cbRelCodeType.Items.IndexOf(ModRelCodeType);

    if Mod30Module <> '' then cb30Module.ItemIndex:= cb30Module.Items.IndexOf(Mod30Module);
    if Mod30SecCode <> '' then ed30SecCode.Text:= Mod30SecCode;
    if Mod30RelCodeType <> '' then cb30RelCodeType.ItemIndex:= cb30RelCodeType.Items.IndexOf(Mod30RelCodeType);
    if Mod30UserCount <> '' then ed30UserCount.Text:= Mod30UserCount;
  end;
end;

procedure TfrmExtMods.EnterpriseClick(Sender: TObject);
begin
  TfrmExtEntx.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtMods.ModulesClick(Sender: TObject);
begin
  //
end;

procedure TfrmExtMods.PlugInsClick(Sender: TObject);
begin
  TfrmExtPlugs.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtMods.VectronClick(Sender: TObject);
begin
  TfrmExtVect.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtMods.OtherClick(Sender: TObject);
begin
  TfrmExtOther.Create(WebApplication).Show;
  Release;
end;

function TfrmExtMods.GetSendSet: TSendSet;
begin
  Result:= [];

  if cbEmail.Checked then Result:= Result + [stEmail];
  if cbSMS.Checked then Result:= Result + [stSMS];
end;

procedure TfrmExtMods.cbEmailClick(Sender: TObject);
begin
  UserSession.SendViaEmail:= cbEmail.Checked;
end;

procedure TfrmExtMods.cbSMSClick(Sender: TObject);
begin
  UserSession.SendViaSMS:= cbSMS.Checked;
end;

procedure TfrmExtMods.cbDateChange(Sender: TObject);
begin
  with UserSession do
  begin
    ResetState;
    SecDate:= cbDate.Text;
  end;
end;

procedure TfrmExtMods.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtMods.bnLogoutClick(Sender: TObject);
begin
  WebApplication.TerminateAndRedirect('http://www.exchequer.com');
end;

procedure TfrmExtMods.bnPlugInClick(Sender: TObject);
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

procedure TfrmExtMods.bnMCMClick(Sender: TObject);
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

procedure TfrmExtMods.bnDailyClick(Sender: TObject);
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

procedure TfrmExtMods.bnDirectorsClick(Sender: TObject);
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

procedure TfrmExtMods.cbModuleChange(Sender: TObject);
begin
  UserSession.ModModule:= cbModule.Text;
  UserSession.ModSecCode:= '';
end;

procedure TfrmExtMods.edSecCodeSubmit(Sender: TObject);
begin
  UserSession.ModSecCode:= edSecCode.Text;
  ActiveControl:= cbRelCodeType;
end;

procedure TfrmExtMods.cbRelCodeTypeChange(Sender: TObject);
begin
  with UserSession, Security do
  begin
    ModRelCodeType:= cbRelCodeType.Text;

    if cbRelCodeType.Text = fullRelease then
    begin
      if Validate(UserCode, pidGetFullModRel) = 0 then bnRelCode.Caption:= 'Get Release Code' else bnRelCode.Caption:= 'Request Code';
    end
    else
    begin
      if Validate(UserCode, pidGet30ModRel) = 0 then bnRelCode.Caption:= 'Get Release Code' else bnRelCode.Caption:= 'Request Code';
    end;
  end;
end;

procedure TfrmExtMods.bnRelCodeClick(Sender: TObject);
var
SecCode, RelCode: string;
ThirtyDay: boolean;
RelCodeType: integer;
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

    if ExceededThreshold(cidModRel, cbModule.Text) then Exit;

    RelCode:= '';
    if cbRelCodeType.Text = fullRelease then RelCodeType:= 1 else RelCodeType:= 0;
    ThirtyDay:= cbRelCodeType.Text <> fullRelease;

    if ThirtyDay then
    begin
      if Validate(UserCode, pidGet30ModRel) = 0 then
      RelCode:= GetExternalCode(GetSendSet, true, dcModules, GetDate(cbDate.ItemIndex), true, SecCode, 0, Trim(cbModule.Text))
      else if Validate(UserCode, pidReq30ModRel) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcModules, GetDate(cbDate.ItemIndex), true, SecCode, 0, Trim(cbModule.Text));
    end
    else
    begin
      if Validate(UserCode, pidGetFullModRel) = 0 then RelCode:= GetExternalCode(GetSendSet, true, dcModules, GetDate(cbDate.ItemIndex), false, SecCode, 0, Trim(cbModule.Text))
      else if Validate(UserCode, pidReqFullModRel) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcModules, GetDate(cbDate.ItemIndex), false, SecCode, 0, Trim(cbModule.Text));
    end;

    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidModRel, cbDate.ItemIndex, RelCodeType, 0, cbModule.Text);
      ModModule:= cbModule.Text;
      ModSecCode:= edSecCode.Text;
      ModRelCodeType:= cbRelCodeType.Text;
    end;
  end;
end;

procedure TfrmExtMods.cb30ModuleChange(Sender: TObject);
begin
  UserSession.Mod30Module:= cb30Module.Text;
  UserSession.Mod30SecCode:= '';
  UserSession.Mod30UserCount:= '';
end;

procedure TfrmExtMods.ed30SecCodeSubmit(Sender: TObject);
begin
  UserSession.Mod30SecCode:= ed30SecCode.Text;
  ActiveControl:= cb30RelCodeType;
end;

procedure TfrmExtMods.cb30RelCodeTypeChange(Sender: TObject);
begin
  with UserSession, Security do
  begin
    Mod30RelCodeType:= cb30RelCodeType.Text;

    if cb30RelCodeType.Text = fullRelease then
    begin
      if Validate(UserCode, pidGetFullModUCRel) = 0 then bn30RelCode.Caption:= 'Get Release Code' else bn30RelCode.Caption:= 'Request Code';
    end
    else
    begin
      if Validate(UserCode, pidGet30ModUCRel) = 0 then bn30RelCode.Caption:= 'Get Release Code' else bn30RelCode.Caption:= 'Request Code';
    end;
  end;
end;

procedure TfrmExtMods.ed30UserCountSubmit(Sender: TObject);
begin
  UserSession.Mod30UserCount:= ed30UserCount.Text;
  ActiveControl:= bn30RelCode;
end;

procedure TfrmExtMods.bn30RelCodeClick(Sender: TObject);
var
SecCode, RelCode: string;
UserCount, RelCodeType: integer;
ThirtyDay: boolean;
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

    if ExceededThreshold(cidModUCRel, cb30Module.Text) then Exit;

    RelCode:= '';
    ThirtyDay:= cb30RelCodeType.Text <> fullRelease;
    if cb30RelCodeType.Text = fullRelease then RelCodeType:= 1 else RelCodeType:= 0;

    if ThirtyDay then
    begin
      if Validate(UserCode, pidGet30ModUCRel) = 0 then RelCode:= GetExternalCode(GetSendSet, true, dcModulesUC, GetDate(cbDate.ItemIndex), true, SecCode, UserCount, Trim(cb30Module.Text))
      else if Validate(UserCode, pidReq30ModUCRel) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcModulesUC, GetDate(cbDate.ItemIndex), true, SecCode, UserCount, Trim(cb30Module.Text));
    end
    else
    begin
      if Validate(UserCode, pidGetFullModUCRel) = 0 then RelCode:= GetExternalCode(GetSendSet, true, dcModulesUC, GetDate(cbDate.ItemIndex), false, SecCode, UserCount, Trim(cb30Module.Text))
      else if Validate(UserCode, pidReqFullModUCRel) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcModulesUC, GetDate(cbDate.ItemIndex), false, SecCode, UserCount, Trim(cb30Module.Text));
    end;

    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidModUCRel, cbDate.ItemIndex, RelCodeType, StrToIntDef(ed30UserCount.Text, 0), Trim(cb30Module.Text));
      Mod30Module:= cb30Module.Text;
      Mod30SecCode:= ed30SecCode.Text;
      Mod30RelCodeType:= cb30RelCodeType.Text;
      Mod30UserCount:= ed30UserCount.Text;
    end;
  end;
end;

function TfrmExtMods.CanFullRelease: boolean;
begin
  with UserSession, Security do
  begin
    CanFullRelease := ((not(CustRestricted)) or (Validate(UserCode, pidOverrideCustRestrict) = 0)) and
                      (UserSession.bUsingDummyESN = FALSE); // AB - added
  end;
end;

end.