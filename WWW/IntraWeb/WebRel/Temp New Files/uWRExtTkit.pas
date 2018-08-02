unit uWRExtTkit;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompEdit, IWCompCheckbox, uWRServer,
  IWCompButton, IWCompListbox, Classes, Controls, IWControl, IWCompLabel,
  IWExtCtrls, IWLayoutMgr, IWTemplateProcessorHTML;

type
  TfrmExtTkit = class(TIWAppForm)
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
    edSecCode: TIWEdit;
    bnRelCode: TIWButton;
    lblhdrToolkit: TIWLabel;
    lbl30SecCode: TIWLabel;
    ed30SecCode: TIWEdit;
    bn30RelCode: TIWButton;
    ed30UserCount: TIWEdit;
    lbl30UserCount: TIWLabel;
    lblhdr30UserCount: TIWLabel;
    TemplateProcessor: TIWTemplateProcessorHTML;
    img1: TIWImage;
    img2: TIWImage;
    img3: TIWImage;
    bnLogout: TIWButton;
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
    procedure ed30SecCodeSubmit(Sender: TObject);
    procedure bnLogoutClick(Sender: TObject);
    procedure cbDateChange(Sender: TObject);
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

    function GetSendSet: TSendSet;
  end;

implementation

{$R *.dfm}

uses
  SysUtils,
  uCodeIDs, uPermissionIDs,
  uWRSite, uCodeGen,
  uWRExtEntx, uWRExtOther, uWRExtVect, uWRExtPlug;

//*** Startup and Shutdown *****************************************************

procedure TfrmExtTkit.IWAppFormCreate(Sender: TObject);
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

    if Validate(UserCode, pidPlugPass) = 0 then bnPlugIn.Caption:= 'Get Password';
    if Validate(UserCode, pidMCMPass) = 0 then bnMCM.Caption:= 'Get Password';
    if Validate(UserCode, pidDailyPass) = 0 then bnDaily.Caption:= 'Get Password';
    if Validate(UserCode, pidDirsPass) = 0 then bnDirectors.Caption:= 'Get Password';
    if Validate(UserCode, pidGet30ModRel) = 0 then bnRelCode.Caption:= 'Get Release Code';
    if Validate(UserCode, pidGet30ModUCRel) = 0 then bn30RelCode.Caption:= 'Get Release Code';

    lblhdr30UserCount.Visible:= isNewerVersion(version5);
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
    bnRelCode.Enabled:= (Validate(UserCode, pidReq30ModRel) = 0) or (Validate(UserCode, pidGet30ModRel) = 0);
    bn30RelCode.Enabled:= (Validate(UserCode, pidReq30ModUCRel) = 0) or (Validate(UserCode, pidGet30ModUCRel) = 0);

    bnDirectors.Visible:= bnDirectors.Enabled;
    lblDirectors.Visible:= bnDirectors.Enabled;
  end;

  LoadDates;
  CreateTabs;
  LoadTab;
end;

//*** Main *********************************************************************

procedure TfrmExtTkit.LoadDates;
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

procedure TfrmExtTkit.CreateTabs;
var
CurrentImg: integer;
begin
  CurrentImg:= 1;

  with UserSession do
  begin
    if npEnterprise in Pages then CreateImage(CurrentImg, 'EnterpriseBack.jpg', EnterpriseClick);
    if npModules in Pages then CreateImage(CurrentImg, 'ToolkitFront.jpg', ModulesClick);
    if (npPlugIns in Pages) and isNewerVersion(version5) then CreateImage(CurrentImg, 'PlugInsBack.jpg', PlugInsClick);
    if npVectron in Pages then CreateImage(CurrentImg, 'VectronBack.jpg', VectronClick);
    if (npOther in Pages) and isNewerVersion(version431) then CreateImage(CurrentImg, 'OtherBack.jpg', OtherClick);
  end;
end;

procedure TfrmExtTkit.CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
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

procedure TfrmExtTkit.LoadTab;
begin
  with UserSession do
  begin
    if ModSecCode <> '' then edSecCode.Text:= ModSecCode;

    if Mod30SecCode <> '' then ed30SecCode.Text:= Mod30SecCode;
    if Mod30UserCount <> '' then ed30UserCount.Text:= Mod30UserCount;
  end;
end;

procedure TfrmExtTkit.EnterpriseClick(Sender: TObject);
begin
  TfrmExtEntx.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtTkit.ModulesClick(Sender: TObject);
begin
  //
end;

procedure TfrmExtTkit.OtherClick(Sender: TObject);
begin
  TfrmExtOther.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtTkit.PlugInsClick(Sender: TObject);
begin
  TfrmExtPlugs.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtTkit.VectronClick(Sender: TObject);
begin
  TfrmExtVect.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtTkit.bnPlugInClick(Sender: TObject);
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

procedure TfrmExtTkit.bnMCMClick(Sender: TObject);
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

procedure TfrmExtTkit.bnDailyClick(Sender: TObject);
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

procedure TfrmExtTkit.bnDirectorsClick(Sender: TObject);
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

procedure TfrmExtTkit.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtTkit.bnRelCodeClick(Sender: TObject);
var
SecCode, RelCode: string;
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

    if ExceededThreshold(cidModRel, tidToolkit) then Exit;

    if Validate(UserCode, pidGet30ModRel) = 0 then RelCode:= GetExternalCode(GetSendSet, true, dcToolkit, GetDate(cbDate.ItemIndex), true, SecCode)
    else if Validate(UserCode, pidReq30ModRel) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcToolkit, GetDate(cbDate.ItemIndex), true, SecCode)
    else RelCode:= '';

    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidModRel, cbDate.ItemIndex, 0, 0, 'Toolkit');
      ModSecCode:= Trim(edSecCode.Text);
    end;  
  end;
end;

procedure TfrmExtTkit.bn30RelCodeClick(Sender: TObject);
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

    if ExceededThreshold(cidModUCRel, tidToolkit) then Exit;

    if Validate(UserCode, pidGet30ModUCRel) = 0 then RelCode:= GetExternalCode(GetSendSet, true, dcToolkitUC, GetDate(cbDate.ItemIndex), true, SecCode, UserCount)
    else if Validate(UserCode, pidReq30ModUCRel) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcToolkitUC, GetDate(cbDate.ItemIndex), true, SecCode, UserCount)
    else RelCode:= '';

    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidModUCRel, cbDate.ItemIndex, 0, UserCount, 'Toolkit');
      Mod30SecCode:= Trim(ed30SecCode.Text);
      Mod30UserCount:= Trim(ed30UserCount.Text);
    end;
  end;
end;

function TfrmExtTkit.GetSendSet: TSendSet;
begin
  Result:= [];

  if cbEmail.Checked then Result:= Result + [stEmail];
  if cbSMS.Checked then Result:= Result + [stSMS];
end;

procedure TfrmExtTkit.cbEmailClick(Sender: TObject);
begin
  UserSession.SendViaEmail:= cbEmail.Checked;
end;

procedure TfrmExtTkit.cbSMSClick(Sender: TObject);
begin
  UserSession.SendViaSMS:= cbSMS.Checked;
end;

procedure TfrmExtTkit.ed30SecCodeSubmit(Sender: TObject);
begin
  ActiveControl:= ed30UserCount;
end;

procedure TfrmExtTkit.bnLogoutClick(Sender: TObject);
begin
  //PR: 17/07/2013 ABSEXCH-14438 Rebranding - replaced old web site with exchequer.com
  //LogoutRedirect is declared in uWRServer
  WebApplication.TerminateAndRedirect(LogoutRedirect);
end;

procedure TfrmExtTkit.cbDateChange(Sender: TObject);
begin
  with UserSession do
  begin
    ResetState;
    SecDate:= cbDate.Text;
  end;
end;

end.
