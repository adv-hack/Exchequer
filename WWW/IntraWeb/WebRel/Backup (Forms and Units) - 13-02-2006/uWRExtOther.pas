unit uWRExtOther;

interface

uses IWAppForm, IWApplication, IWTypes, IWCompCheckbox, IWCompButton, IWExtCtrls,
  IWCompListbox, Classes, Controls, IWControl, IWCompLabel, uWRServer,
  IWLayoutMgr, IWTemplateProcessorHTML;

type
  TfrmExtOther = class(TIWAppForm)
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
    lblhdrSecurity: TIWLabel;
    lblResync: TIWLabel;
    bnResetEnt: TIWButton;
    lblResetEnt: TIWLabel;
    bnResync: TIWButton;
    TemplateProcessor: TIWTemplateProcessorHTML;
    img1: TIWImage;
    img2: TIWImage;
    img3: TIWImage;
    bnInstructions: TIWButton;
    bnLogout: TIWButton;
    capUserName: TIWLabel;
    lblUserName: TIWLabel;
    img4: TIWImage;
    img5: TIWImage;
    procedure bnReturnMainClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure bnPlugInClick(Sender: TObject);
    procedure bnMCMClick(Sender: TObject);
    procedure bnDailyClick(Sender: TObject);
    procedure bnDirectorsClick(Sender: TObject);
    procedure bnResyncClick(Sender: TObject);
    procedure bnResetEntClick(Sender: TObject);
    procedure cbEmailClick(Sender: TObject);
    procedure cbSMSClick(Sender: TObject);
    procedure bnInstructionsClick(Sender: TObject);
    procedure bnLogoutClick(Sender: TObject);
    procedure cbDateChange(Sender: TObject);
  private
    procedure CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
    procedure CreateTabs;
    procedure LoadDates;

    procedure EnterpriseClick(Sender: TObject);
    procedure ModulesClick(Sender: TObject);
    procedure OtherClick(Sender: TObject);
    procedure PlugInsClick(Sender: TObject);
    procedure VectronClick(Sender: TObject);

    function GetSendSet: TSendSet;
  end;

implementation

{$R *.dfm}

uses uCodeIds, uPermissionIDs,
     uWRSite, uWRData,
     uWRExtEntx, uWRExtTkit, uWRExtMods, uWRExtVect, uWRExtPlug,
     uCodeGen, uWRInstrx, SysUtils;

//******************************************************************************

procedure TfrmExtOther.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

//*** Startup and Shutdown *****************************************************

procedure TfrmExtOther.IWAppFormCreate(Sender: TObject);
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
    if Validate(UserCode, pidResyncPass) = 0 then bnResync.Caption:= 'Get Password';
    if Validate(UserCode, pidResetEntUCPass) = 0 then bnResetEnt.Caption:= 'Get Password';

    // AB - 7
    bnPlugIn.Enabled := ((Validate(UserCode, pidReqPlugPass) = 0) or
                         (Validate(UserCode, pidPlugPass) = 0)) and
                        (isNewerVersion(version5));
    bnMCM.Enabled := ((Validate(UserCode, pidReqMCMPass) = 0) or
                      (Validate(UserCode, pidMCMPass) = 0)) and
                     (isNewerVersion(version5));

    bnDaily.Enabled:= (Validate(UserCode, pidReqDailyPass) = 0) or (Validate(UserCode, pidDailyPass) = 0);
    bnDirectors.Enabled:= (Validate(UserCode, pidReqDirsPass) = 0) or (Validate(UserCode, pidDirsPass) = 0);
    bnResync.Enabled:= (Validate(UserCode, pidReqResyncPass) = 0) or (Validate(UserCode, pidResyncPass) = 0);
    bnResetEnt.Enabled:= (Validate(UserCode, pidReqResetEntUCPass) = 0) or (Validate(UserCode, pidResetEntUCPass) = 0);

    bnResync.Visible:= isNewerVersion(version431);
    lblResync.Visible:= isNewerVersion(version431);
    bnResetEnt.Visible:= isNewerVersion(version5);
    lblResetEnt.Visible:= isNewerVersion(version5);
    bnInstructions.Visible:= Version = version431;

    bnDirectors.Visible:= bnDirectors.Enabled;
    lblDirectors.Visible:= bnDirectors.Enabled;
  end;

  LoadDates;
  CreateTabs;
end;

//*** Main *********************************************************************

procedure TfrmExtOther.LoadDates;
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

procedure TfrmExtOther.CreateTabs;
var
CurrentImg: integer;
begin
  CurrentImg:= 1;

  with UserSession, Security do
  begin
    if npEnterprise in Pages then CreateImage(CurrentImg, 'EnterpriseBack.jpg', EnterpriseClick);
    if npModules in Pages then
    begin
      if Validate(UserCode, pidShowAllModules) = 0 then CreateImage(CurrentImg, 'ModulesBack.jpg', ModulesClick)
      else CreateImage(CurrentImg, 'ToolkitBack.jpg', ModulesClick)
    end;
    if (npPlugIns in Pages) and isNewerVersion(version5) then CreateImage(CurrentImg, 'PlugInsBack.jpg', PlugInsClick);
    if npVectron in Pages then CreateImage(CurrentImg, 'VectronBack.jpg', VectronClick);
    if (npOther in Pages) and isNewerVersion(version431) then CreateImage(CurrentImg, 'OtherFront.jpg', OtherClick);
  end;
end;

procedure TfrmExtOther.CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
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

procedure TfrmExtOther.bnPlugInClick(Sender: TObject);
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

procedure TfrmExtOther.bnMCMClick(Sender: TObject);
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

procedure TfrmExtOther.bnDailyClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession, Security do
  begin
    if not isValidSendVia(GetSendSet) then Exit;
    if ExceededThreshold(cidDaily, '') then Exit;

    if Validate(UserCode, pidReqDailyPass) = 0 then RelCode:= GetExternalCode(GetSendSet, true, dcDaily, GetDate(cbDate.ItemIndex))
    else if Validate(UserCode, pidReqDailyPass) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcDaily, GetDate(cbDate.ItemIndex))
    else RelCode:= '';

    if RelCode <> '' then AuditLog(RelCode, cidDaily, cbDate.ItemIndex, 0, 0, '');
  end;
end;

procedure TfrmExtOther.bnDirectorsClick(Sender: TObject);
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

procedure TfrmExtOther.bnResyncClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession, Security do
  begin
    if not isValidSendVia(GetSendSet) then Exit;
    if ExceededThreshold(cidResync, '') then Exit;

    if Validate(UserCode, pidResyncPass) = 0 then
    begin
      RelCode:= GetExternalCode(GetSendSet, true, dcResync, GetDate(cbDate.ItemIndex));
      if isNewerVersion(version5) then ResyncCompanies;
    end
    else if Validate(UserCode, pidReqResyncPass) = 0 then
    begin
      RelCode:= GetExternalCode(GetSendSet, false, dcResync, GetDate(cbDate.ItemIndex));
      if isNewerVersion(version5) then ResyncCompanies;
    end
    else RelCode:= '';

    if RelCode <> '' then AuditLog(RelCode, cidResync, cbDate.ItemIndex, 0, 0, '');
  end;
end;

procedure TfrmExtOther.bnResetEntClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession, Security do
  begin
    if not isValidSendVia(GetSendSet) then Exit;
    if ExceededThreshold(cidResetEnt, '') then Exit;

    if Validate(UserCode, pidResetEntUCPass) = 0 then RelCode:= GetExternalCode(GetSendSet, true, dcResetEnt, GetDate(cbDate.ItemIndex))
    else if Validate(UserCode, pidReqResetEntUCPass) = 0 then RelCode:= GetExternalCode(GetSendSet, false, dcResetEnt, GetDate(cbDate.ItemIndex))
    else RelCode:= '';

    if RelCode <> '' then AuditLog(RelCode, cidResetEnt, cbDate.ItemIndex, 0, 0, '');
  end;
end;

procedure TfrmExtOther.EnterpriseClick(Sender: TObject);
begin
  TfrmExtEntx.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtOther.ModulesClick(Sender: TObject);
begin
  with UserSession, Security do
  begin
    if Validate(UserCode, pidShowAllModules) = 0 then TfrmExtMods.Create(WebApplication).Show
    else TfrmExtTkit.Create(WebApplication).Show;
  end;

  Release;
end;

procedure TfrmExtOther.PlugInsClick(Sender: TObject);
begin
  TfrmExtPlugs.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtOther.VectronClick(Sender: TObject);
begin
  TfrmExtVect.Create(WebApplication).Show;
  Release;
end;

procedure TfrmExtOther.OtherClick(Sender: TObject);
begin
  //
end;

function TfrmExtOther.GetSendSet: TSendSet;
begin
  Result:= [];

  if cbEmail.Checked then Result:= Result + [stEmail];
  if cbSMS.Checked then Result:= Result + [stSMS];
end;

procedure TfrmExtOther.cbEmailClick(Sender: TObject);
begin
  UserSession.SendViaEmail:= cbEmail.Checked;
end;

procedure TfrmExtOther.cbSMSClick(Sender: TObject);
begin
  UserSession.SendViaSMS:= cbSMS.Checked;
end;

procedure TfrmExtOther.bnInstructionsClick(Sender: TObject);
begin
  TfrmInstructions.Create(WebApplication).Show;
end;

procedure TfrmExtOther.bnLogoutClick(Sender: TObject);
begin
  WebApplication.TerminateAndRedirect('http://www.exchequer.com');
end;

procedure TfrmExtOther.cbDateChange(Sender: TObject);
begin
  with UserSession do
  begin
    ResetState;
    SecDate:= cbDate.Text;
  end;
end;

end.
