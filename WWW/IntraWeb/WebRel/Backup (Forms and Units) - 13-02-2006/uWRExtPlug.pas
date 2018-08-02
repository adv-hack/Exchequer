unit uWRExtPlug;
{PUBDIST}

interface

uses
  IWAppForm, IWApplication, IWTypes, IWLayoutMgr, IWTemplateProcessorHTML,
  IWCompCheckbox, IWCompButton, IWCompListbox, Classes, Controls,
  IWControl, IWCompLabel, IWExtCtrls,
  uWRServer, IWCompEdit;

type
  TfrmExtPlugs = class(TIWAppForm)
    capDealership: TIWLabel;
    lblDealership: TIWLabel;
    capCustomer: TIWLabel;
    lblCustomer: TIWLabel;
    capESN: TIWLabel;
    lblESN: TIWLabel;
    capVersion: TIWLabel;
    cbDate: TIWComboBox;
    lblVersion: TIWLabel;
    lblDate: TIWLabel;
    bnReturnMain: TIWButton;
    lblSendVia: TIWLabel;
    cbEmail: TIWCheckBox;
    cbSMS: TIWCheckBox;
    bnLogout: TIWButton;
    capUserName: TIWLabel;
    lblUserName: TIWLabel;
    TemplateProcessor: TIWTemplateProcessorHTML;
    img1: TIWImage;
    img2: TIWImage;
    img3: TIWImage;
    lblhdrPasswords: TIWLabel;
    lblPlugIn: TIWLabel;
    lblMCM: TIWLabel;
    lblDaily: TIWLabel;
    lblDirectors: TIWLabel;
    bnPlugIn: TIWButton;
    bnDaily: TIWButton;
    bnDirectors: TIWButton;
    bnMCM: TIWButton;
    img4: TIWImage;
    img5: TIWImage;
    lblhdrSecurity: TIWLabel;
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
    lblhdrUserCount: TIWLabel;
    cb30RelCodeType: TIWComboBox;
    lbl30RelCodeType: TIWLabel;
    cbPlugIn: TIWComboBox;
    lblModule: TIWLabel;
    cb30PlugIn: TIWComboBox;
    lbl30PlugIn: TIWLabel;
    procedure IWAppFormCreate(Sender: TObject);
    procedure bnPlugInClick(Sender: TObject);
    procedure bnMCMClick(Sender: TObject);
    procedure bnDailyClick(Sender: TObject);
    procedure bnDirectorsClick(Sender: TObject);
    procedure cbRelCodeTypeChange(Sender: TObject);
    procedure bnRelCodeClick(Sender: TObject);
    procedure bn30RelCodeClick(Sender: TObject);
    procedure bnLogoutClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
  private
    fCautionOnRelease: boolean;
    
    procedure CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
    procedure CreateTabs;
    procedure LoadDates;
    procedure LoadPlugIns;
    procedure LoadTab;

    procedure EnterpriseClick(Sender: TObject);
    procedure ModulesClick(Sender: TObject);
    procedure OtherClick(Sender: TObject);
    procedure PlugInsClick(Sender: TObject);
    procedure VectronClick(Sender: TObject);

    function CanFullRelease: boolean;
    function GetSendSet: TSendSet;
    function GetPlugCode(PlugDesc: string): string;
  public
  end;

implementation

{$R *.dfm}

uses
  SysUtils,
  uWRSite, uWRExtEntx, uWRExtMods, uWRExtOther, uWRExtVect,
  uPermissionIDs, uCodeIDs, uWRData;

procedure TfrmExtPlugs.IWAppFormCreate(Sender: TObject);
begin
  {Initialise form controls;}

  with UserSession, Security do
  begin
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

    if CanFullRelease then
    begin
      if (Validate(UserCode, pidFullPlugRel) = 0) or (Validate(UserCode, pidReqFullPlugRel) = 0) then cbRelCodeType.Items.Add(fullRelease);
      if (Validate(UserCode, pidFullPlugUCRel) = 0) or (Validate(UserCode, pidReqFullPlugUCRel) = 0) then cb30RelCodeType.Items.Add(fullRelease);
    end;

    if Validate(UserCode, pidPlugPass) = 0 then bnPlugIn.Caption:= 'Get Password';
    if Validate(UserCode, pidMCMPass) = 0 then bnMCM.Caption:= 'Get Password';
    if Validate(UserCode, pidDailyPass) = 0 then bnDaily.Caption:= 'Get Password';
    if Validate(UserCode, pidDirsPass) = 0 then bnDirectors.Caption:= 'Get Password';
    if Validate(UserCode, pidGet30EntUCRel) = 0 then bn30RelCode.Caption:= 'Get Release Code';
    cbRelCodeTypeChange(Self);

    // AB - 7
    bnPlugIn.Enabled := (Validate(UserCode, pidPlugPass) = 0) and (isNewerVersion(version5));
    bnMCM.Enabled := (Validate(UserCode, pidMCMPass) = 0) and (isNewerVersion(version5));

    bnDaily.Enabled:= Validate(UserCode, pidDailyPass) = 0;
    bnDirectors.Enabled:= not(isDummyCust) and (Validate(UserCode, pidDirsPass) = 0);
    bnRelCode.Enabled := ((Validate(UserCode, pidFullPlugRel) = 0) or
                          (Validate(UserCode, pidGetPlugRel)  = 0) or
                          (Validate(UserCode, pidReq30PlugRel) = 0) or
                          (Validate(UserCode, pidReqFullPlugRel) = 0)) and
                         (cbPlugIn.Items.Count > 0);
    bn30RelCode.Enabled:= (Validate(UserCode, pidGetPlugUCRel) = 0) and (cb30PlugIn.Items.Count > 0);

    bnDirectors.Visible:= bnDirectors.Enabled;
    lblDirectors.Visible:= bnDirectors.Enabled;
  end;

  LoadDates;
  CreateTabs;
  LoadPlugIns;
  LoadTab;
end;

procedure TfrmExtPlugs.LoadDates;
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

procedure TfrmExtPlugs.CreateTabs;
var
  CurrentImg : integer;
begin
  CurrentImg := 1;

  with UserSession do
  begin
    if npEnterprise in Pages then CreateImage(CurrentImg, 'EnterpriseBack.jpg', EnterpriseClick);
    if npModules in Pages then CreateImage(CurrentImg, 'ModulesBack.jpg', ModulesClick);
    if npPlugIns in Pages then CreateImage(CurrentImg, 'PlugInsFront.jpg', PlugInsClick);
    if npVectron in Pages then CreateImage(CurrentImg, 'VectronBack.jpg', VectronClick);
    if (npOther in Pages) and isNewerVersion(version431) then CreateImage(CurrentImg, 'OtherBack.jpg', OtherClick);
  end;
end;

procedure TfrmExtPlugs.CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
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

procedure TfrmExtPlugs.LoadPlugIns;
begin
  cbPlugIn.Items.Clear;
  cb30PlugIn.Items.Clear;

  with WRData.qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select * from modules where plugin = 1 ');
    Open;

    while not eof do
    begin
      cbPlugIn.Items.Add(FieldByName('ModuleName').AsString);
      Next;
    end;

    Close;
    Sql.Clear;
    Sql.Add('select * from modules where plugin = 1 and usercount = 1 ');
    Open;

    while not eof do
    begin
      cb30PlugIn.Items.Add(FieldByName('ModuleName').AsString);
      Next;
    end;
  end;

  if cbPlugIn.Items.Count > 0 then with UserSession do
  begin
    if PlugsModule <> '' then cbPlugIn.ItemIndex:= cbPlugIn.Items.IndexOf(PlugsModule) else cbPlugIn.ItemIndex:= 0;
  end;

  if cb30PlugIn.Items.Count > 0 then with UserSession do
  begin
    if Plugs30Module <> '' then cb30PlugIn.ItemIndex:= cb30PlugIn.Items.IndexOf(Plugs30Module) else cb30PlugIn.ItemIndex:= 0;
  end;
end;

procedure TfrmExtPlugs.LoadTab;
begin
  with UserSession do
  begin
    if PlugsModule <> '' then cbPlugIn.ItemIndex:= cbPlugIn.Items.IndexOf(PlugsModule);
    if PlugsSecCode <> '' then edSecCode.Text:= PlugsSecCode;
    if PlugsRelCodeType <> '' then cbRelCodeType.ItemIndex:= cbRelCodeType.Items.IndexOf(PlugsRelCodeType);

    if Plugs30Module <> '' then cb30PlugIn.ItemIndex:= cb30PlugIn.Items.IndexOf(Plugs30Module);
    if Plugs30SecCode <> '' then ed30SecCode.Text:= Plugs30SecCode;
    if Plugs30RelCodeType <> '' then cb30RelCodeType.ItemIndex:= cb30RelCodeType.Items.IndexOf(Mod30RelCodeType);
    if Plugs30UserCount <> '' then ed30UserCount.Text:= Plugs30UserCount;
  end;
end;

procedure TfrmExtPlugs.EnterpriseClick(Sender: TObject);
begin
  TfrmExtEntx.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtPlugs.ModulesClick(Sender: TObject);
begin
  TfrmExtMods.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtPlugs.PlugInsClick(Sender: TObject);
begin
  // already on this tab, no action needed.
end;

procedure TfrmExtPlugs.VectronClick(Sender: TObject);
begin
  TfrmExtVect.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtPlugs.OtherClick(Sender: TObject);
begin
  TfrmExtOther.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtPlugs.bnPlugInClick(Sender: TObject);
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

procedure TfrmExtPlugs.bnMCMClick(Sender: TObject);
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

procedure TfrmExtPlugs.bnDailyClick(Sender: TObject);
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

procedure TfrmExtPlugs.bnDirectorsClick(Sender: TObject);
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

function TfrmExtPlugs.GetSendSet: TSendSet;
begin
  Result:= [];

  if cbEmail.Checked then Result:= Result + [stEmail];
  if cbSMS.Checked then Result:= Result + [stSMS];
end;

function TfrmExtPlugs.CanFullRelease: boolean;
begin
  with UserSession, Security do
  begin
    fCautionOnRelease:= CustRestricted and (Validate(UserCode, pidOverrideCustRestrict) = 0);
    CanFullRelease := ((not(CustRestricted)) or (Validate(UserCode, pidOverrideCustRestrict) = 0)) and
                      (UserSession.bUsingDummyESN = FALSE); // AB - added
  end;
end;

procedure TfrmExtPlugs.cbRelCodeTypeChange(Sender: TObject);
begin
  with UserSession, Security do
  begin
    if cbRelCodeType.Text = fullRelease then
    begin
      if Validate(UserCode, pidFullPlugRel) = 0 then bnRelCode.Caption:= 'Get Release Code' else bnRelCode.Caption:= 'Request Code';
    end
    else
    begin
      if Validate(UserCode, pidGetPlugRel) = 0 then bnRelCode.Caption:= 'Get Release Code' else bnRelCode.Caption:= 'Request Code';
    end;
  end;
end;

procedure TfrmExtPlugs.bnRelCodeClick(Sender: TObject);
var
ThirtyDay: boolean;
SecCode, PlugCode, RelCode: string;
RelCodeType: integer;
begin
  with UserSession, Security do
  begin
    if Trim(edSecCode.Text) = '' then
    begin
      WebApplication.ShowMessage('A release code can not be generated without a security code.');
      Exit;
    end
    else SecCode := UpperCase(Trim(edSecCode.Text));

    if ExceededThreshold(cidPlugRel, cbPlugIn.Text) then Exit;

    if (cbRelCodeType.Text = fullRelease) then RelCodeType := 1 else RelCodeType:= 0;
    PlugCode := GetPlugCode(Trim(cbPlugIn.Text));
    ThirtyDay := (cbRelCodeType.Text <> fullRelease);

    if ThirtyDay then
    begin
      if (Validate(UserCode, pidGetPlugRel) = 0) then
      begin
        RelCode := GetExternalCode(GetSendSet, true, dcPlugInRel, GetDate(cbDate.ItemIndex), ThirtyDay, SecCode, 0, PlugCode);
      end
      else if (Validate(UserCode, pidReq30PlugRel) = 0) then
        RelCode := GetExternalCode(GetSendSet, false, dcPlugInRel, GetDate(cbDate.ItemIndex), ThirtyDay, SecCode, 0, PlugCode);
    end
    else
    begin
      if (Validate(UserCode, pidFullPlugRel) = 0) then
        RelCode := GetExternalCode(GetSendSet, true, dcPlugInRel, GetDate(cbDate.ItemIndex), ThirtyDay, SecCode, 0, PlugCode)
      else if (Validate(UserCode, pidReqFullPlugRel) = 0) then
        RelCode := GetExternalCode(GetSendSet, false, dcPlugInRel, GetDate(cbDate.ItemIndex), ThirtyDay, SecCode, 0, PlugCode);
    end;

    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidPlugRel, cbDate.ItemIndex, RelCodeType, 0, cbPlugIn.Text);
      PlugsModule:= cbPlugIn.Text;
      PlugsSecCode:= edSecCode.Text;
      PlugsRelCodeType:= cbRelCodeType.Text;
      PlugsRelCode:= RelCode;
      if fCautionOnRelease and (cbRelCodeType.Text = fullRelease) then WebApplication.ShowMessage('You have overridden the 30-day release code restriction for this customer.' + #13#10#13#10 + 'You may want to reconsider giving this release code out.');
    end;
  end;
end;

procedure TfrmExtPlugs.bn30RelCodeClick(Sender: TObject);
var
UserCount, RelCodeType: integer;
SecCode, PlugCode, RelCode: string;
ThirtyDay: boolean;
begin
  with UserSession, Security do
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

    if ExceededThreshold(cidPlugUCRel, cb30PlugIn.Text) then Exit;

    ThirtyDay:= cb30RelCodeType.Text <> fullRelease;
    if cb30RelCodeType.Text = fullRelease then RelCodeType:= 1 else RelCodeType:= 0;
    PlugCode:= GetPlugCode(Trim(cb30PlugIn.Text));

    if ThirtyDay then
    begin
      if (Validate(UserCode, pidGet30PlugUCRel) = 0) then // Get 30 Day Plug-In User Count Release Code
        RelCode := GetExternalCode(GetSendSet, true, dcPlugIn, GetDate(cbDate.ItemIndex), true, SecCode, UserCount, PlugCode)
      else if (Validate(UserCode, pidReg30PlugUCRel) = 0) then // Request 30 Day Plug-In User Count Release Code
        RelCode := GetExternalCode(GetSendSet, false, dcPlugIn, GetDate(cbDate.ItemIndex), true, SecCode, UserCount, PlugCode);
    end
    else
    begin
      if (Validate(UserCode, pidGetFullPlugUCRel) = 0) then  // Get Plug-In User Count Release Code
        RelCode:= GetExternalCode(GetSendSet, true, dcPlugIn, GetDate(cbDate.ItemIndex), false, SecCode, UserCount, PlugCode)
      else if (Validate(UserCode, pidReqFullPlugUCRel) = 0) then  // Request Plug-In User Count Release Code (dealer version)
        RelCode:= GetExternalCode(GetSendSet, false, dcPlugIn, GetDate(cbDate.ItemIndex), false, SecCode, UserCount, PlugCode);
    end;

    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidPlugUCRel, cbDate.ItemIndex, RelCodeType, StrToIntDef(ed30UserCount.Text, 0), cb30PlugIn.Text);
      Plugs30Module:= cb30PlugIn.Text;
      Plugs30SecCode:= ed30SecCode.Text;
      Plugs30RelCodeType:= cb30RelCodeType.Text;
      Plugs30UserCount:= ed30UserCount.Text;
      Plugs30RelCode:= RelCode;
      if fCautionOnRelease and (cb30RelCodeType.Text = fullRelease) then WebApplication.ShowMessage('You have overridden the 30-day release code restriction for this customer.' + #13#10#13#10 + 'You may want to reconsider giving this release code out.');
    end;
  end;
end;

function TfrmExtPlugs.GetPlugCode(PlugDesc: string): string;
begin
  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select plugcode from modules ');
    Sql.Add('where plugin = 1 and modulename = :pmodulename ');
    ParamByName('pmodulename').AsString:= PlugDesc;
    Open;

    Result:= Copy(FieldByName('PlugCode').AsString, 11, 6);
  end;
end;

procedure TfrmExtPlugs.bnLogoutClick(Sender: TObject);
begin
  WebApplication.TerminateAndRedirect('http://www.exchequer.com');
end;

procedure TfrmExtPlugs.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

end.
