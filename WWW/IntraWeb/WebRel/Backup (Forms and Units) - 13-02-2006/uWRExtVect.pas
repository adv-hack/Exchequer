unit uWRExtVect;
{PUBDIST}

interface

uses
  IWAppForm, IWApplication, IWTypes, IWLayoutMgr, IWTemplateProcessorHTML,
  IWCompCheckbox, IWCompButton, IWCompListbox, Classes, Controls,
  IWControl, IWCompLabel, IWExtCtrls, IWCompEdit,
  uWRServer;

type
  TfrmExtVect = class(TIWAppForm)
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
    lblSecCode: TIWLabel;
    edSecCode: TIWEdit;
    bnRelCode: TIWButton;
    cbRelCodeType: TIWComboBox;
    lblRelCodeType: TIWLabel;
    lblhdrSecurity: TIWLabel;
    bnPlugIn: TIWButton;
    bnDaily: TIWButton;
    bnDirectors: TIWButton;
    bnMCM: TIWButton;
    bnReturnMain: TIWButton;
    lblVectronDaily: TIWLabel;
    bnVectronDaily: TIWButton;
    capUserName: TIWLabel;
    lblUserName: TIWLabel;
    img1: TIWImage;
    img2: TIWImage;
    img3: TIWImage;
    img4: TIWImage;
    img5: TIWImage;
    bnLogOut: TIWButton;
    TemplateProcessor: TIWTemplateProcessorHTML;
    lblSendVia: TIWLabel;
    cbEmail: TIWCheckBox;
    cbSMS: TIWCheckBox;
    lblSystemSecurity: TIWLabel;
    procedure IWAppFormCreate(Sender: TObject);
    procedure bnPlugInClick(Sender: TObject);
    procedure bnMCMClick(Sender: TObject);
    procedure bnDailyClick(Sender: TObject);
    procedure bnDirectorsClick(Sender: TObject);
    procedure bnLogoutClick(Sender: TObject);
    procedure bnVectronDailyClick(Sender: TObject);
    procedure cbRelCodeTypeChange(Sender: TObject);
    procedure bnRelCodeClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
  public
  private
    fCautionOnRelease: boolean;

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

uses
  SysUtils,
  uWRSite, uWRExtPlug, uWRExtMods, uWRExtTkit, uWRExtOther, uWRExtEntx,
  uPermissionIDs, uCodeIDs;

procedure TfrmExtVect.IWAppFormCreate(Sender: TObject);
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
      if Validate(UserCode, pidFullVectRel) = 0 then cbRelCodeType.Items.Add(fullRelease);
    end;
    if Validate(UserCode, pidPlugPass) = 0 then bnPlugIn.Caption:= 'Get Password';
    if Validate(UserCode, pidMCMPass) = 0 then bnMCM.Caption:= 'Get Password';
    if Validate(UserCode, pidDailyPass) = 0 then bnDaily.Caption:= 'Get Password';
    if Validate(UserCode, pidDirsPass) = 0 then bnDirectors.Caption:= 'Get Password';
    cbRelCodeTypeChange(Self);

    // AB - 7
    bnPlugIn.Enabled := (Validate(UserCode, pidPlugPass) = 0) and (isNewerVersion(version5));
    bnMCM.Enabled := (Validate(UserCode, pidMCMPass) = 0) and (isNewerVersion(version5));

    bnDaily.Enabled:= Validate(UserCode, pidDailyPass) = 0;
    bnDirectors.Enabled:= not(isDummyCust) and (Validate(UserCode, pidDirsPass) = 0);
    bnVectronDaily.Enabled:= Validate(UserCode, pidVectDaily) = 0;
    bnRelCode.Enabled:= Validate(UserCode, pidGetVectRel) = 0;

    bnDirectors.Visible:= bnDirectors.Enabled;
    lblDirectors.Visible:= bnDirectors.Enabled;
  end;

  LoadDates;
  CreateTabs;
  LoadTab;
end;

function TfrmExtVect.CanFullRelease: boolean;
begin
  with UserSession, Security do
  begin
    fCautionOnRelease:= CustRestricted and (Validate(UserCode, pidOverrideCustRestrict) = 0);
    CanFullRelease := ((not(CustRestricted)) or (Validate(UserCode, pidOverrideCustRestrict) = 0)) and
                      (UserSession.bUsingDummyESN = FALSE); // AB - added
  end;
end;

procedure TfrmExtVect.LoadDates;
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

procedure TfrmExtVect.CreateTabs;
var
  CurrentImg : integer;
begin
  CurrentImg := 1;

  with UserSession do
  begin
    if npEnterprise in Pages then CreateImage(CurrentImg, 'EnterpriseBack.jpg', EnterpriseClick);
    if npModules in Pages then CreateImage(CurrentImg, 'ModulesBack.jpg', ModulesClick);
    // AB - 8
    if (npPlugIns in Pages) and isNewerVersion(version5) then CreateImage(CurrentImg, 'PlugInsBack.jpg', PlugInsClick);
    if npVectron in Pages then CreateImage(CurrentImg, 'VectronFront.jpg', VectronClick);
    if (npOther in Pages) and isNewerVersion(version431) then CreateImage(CurrentImg, 'OtherBack.jpg', OtherClick);
  end;
end;

procedure TfrmExtVect.CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
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

procedure TfrmExtVect.LoadTab;
begin
  with UserSession do
  begin
    if VectSecCode <> '' then edSecCode.Text:= VectSecCode;
    if VectRelCodeType <> '' then cbRelCodeType.ItemIndex:= cbRelCodeType.Items.IndexOf(VectRelCodeType);
  end;
end;

procedure TfrmExtVect.EnterpriseClick(Sender: TObject);
begin
  TfrmExtEntx.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtVect.ModulesClick(Sender: TObject);
begin
  TfrmExtMods.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtVect.PlugInsClick(Sender: TObject);
begin
  TfrmExtPlugs.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtVect.VectronClick(Sender: TObject);
begin
  // already on this tab, no action needed.
end;

procedure TfrmExtVect.OtherClick(Sender: TObject);
begin
  TfrmExtOther.Create(WebApplication).Show;
  Release;
end;


procedure TfrmExtVect.bnPlugInClick(Sender: TObject);
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

procedure TfrmExtVect.bnMCMClick(Sender: TObject);
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

procedure TfrmExtVect.bnDailyClick(Sender: TObject);
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

procedure TfrmExtVect.bnDirectorsClick(Sender: TObject);
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

function TfrmExtVect.GetSendSet: TSendSet;
begin
  Result:= [];

  if cbEmail.Checked then Result:= Result + [stEmail];
  if cbSMS.Checked then Result:= Result + [stSMS];
end;

procedure TfrmExtVect.bnLogoutClick(Sender: TObject);
begin
  WebApplication.TerminateAndRedirect('http://www.exchequer.com');
end;

procedure TfrmExtVect.bnVectronDailyClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession, Security do
  begin
    if not isValidSendVia(GetSendSet) then Exit;
    if ExceededThreshold(cidResync, '') then Exit;

    if Validate(UserCode, pidVectDaily) = 0 then
    begin
      RelCode := GetExternalCode(GetSendSet, true, dcVectronDaily, GetDate(cbDate.ItemIndex));
    end
    else if Validate(UserCode, pidReqVectPass) = 0 then
    begin
      RelCode := GetExternalCode(GetSendSet, false, dcVectronDaily, GetDate(cbDate.ItemIndex));
    end
    else RelCode:= '';

    if RelCode <> '' then AuditLog(RelCode, cidVectDaily, cbDate.ItemIndex, 0, 0, '');
  end;
end;

procedure TfrmExtVect.cbRelCodeTypeChange(Sender: TObject);
begin
  with UserSession, Security do
  begin
    if cbRelCodeType.Text = fullRelease then
    begin
      if Validate(UserCode, pidFullVectRel) = 0 then bnRelCode.Caption:= 'Get Release Code' else bnRelCode.Caption:= 'Request Code';
    end
    else
    begin
      if Validate(UserCode, pidGet30VectRel) = 0 then bnRelCode.Caption:= 'Get Release Code' else bnRelCode.Caption:= 'Request Code';
    end;
  end;
end;

procedure TfrmExtVect.bnRelCodeClick(Sender: TObject);
var
  ThirtyDay : boolean;
  SecCode, RelCode : string;
  RelCodeType : integer;
begin
  with UserSession, Security do
  begin
    if Trim(edSecCode.Text) = '' then
    begin
      WebApplication.ShowMessage('A release code can not be generated without a security code.');
      Exit;
    end
    else SecCode:= UpperCase(Trim(edSecCode.Text));

    if ExceededThreshold(cidVectRel, '') then Exit;

    if cbRelCodeType.Text = fullRelease then RelCodeType:= 1 else RelCodeType:= 0;
    ThirtyDay:= cbRelCodeType.Text <> fullRelease;

    if ThirtyDay then
    begin
      if Validate(UserCode, pidGetVectRel) = 0 then // Get Vectron Release Code
      begin
        if (Version = version430) then
          RelCode := GetExternalCode(GetSendSet, true, dcSystem, GetDate(cbDate.ItemIndex), true, SecCode)
        else
          RelCode := GetExternalCode(GetSendSet, true, dcVectronRel, GetDate(cbDate.ItemIndex), true, SecCode);
      end
      else if Validate(UserCode, pidReq30VectRel) = 0 then // Request 30 Day Vectron Release Code
      begin
        if (Version = version430) then
          RelCode := GetExternalCode(GetSendSet, false, dcSystem, GetDate(cbDate.ItemIndex), true, SecCode)
        else
          RelCode := GetExternalCode(GetSendSet, false, dcVectronRel, GetDate(cbDate.ItemIndex), true, SecCode);
      end;
    end
    else
    begin
      if Validate(UserCode, pidFullVectRel) = 0 then // Allow Full Vectron Release Code
      begin
        if (Version = version430) then
          RelCode := GetExternalCode(GetSendSet, true, dcSystem, GetDate(cbDate.ItemIndex), false, SecCode)
        else
          RelCode := GetExternalCode(GetSendSet, true, dcVectronRel, GetDate(cbDate.ItemIndex), false, SecCode);
      end
      else if Validate(UserCode, pidReqFullVectRel) = 0 then // Request Full vectron Release Code
      begin
        if (Version = version430) then
          RelCode := GetExternalCode(GetSendSet, false, dcSystem, GetDate(cbDate.ItemIndex), false, SecCode)
        else
          RelCode := GetExternalCode(GetSendSet, false, dcVectronRel, GetDate(cbDate.ItemIndex), false, SecCode);
      end;
    end;

    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidVectRel, cbDate.ItemIndex, RelCodeType, 0, '');
      VectSecCode:= edSecCode.Text;
      VectRelCodeType:= cbRelCodeType.Text;
      VectRelCode:= RelCode;
      if fCautionOnRelease and (cbRelCodeType.Text = fullRelease) then WebApplication.ShowMessage('You have overridden the 30-day release code restriction for this customer.' + #13#10#13#10 + 'You may want to reconsider giving this release code out.');
    end;
  end;
end;


procedure TfrmExtVect.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

end.
