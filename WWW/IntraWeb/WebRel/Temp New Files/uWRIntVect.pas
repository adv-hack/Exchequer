unit uWRIntVect;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompButton, IWCompEdit, IWCompListbox,
  Classes, Controls, IWControl, IWCompLabel, uWRServer, IWExtCtrls,
  IWLayoutMgr, IWTemplateProcessorHTML;

type
  TfrmIntVect = class(TIWAppForm)
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
    edSecCode: TIWEdit;
    edRelCode: TIWEdit;
    bnRelCode: TIWButton;
    lblRelCode: TIWLabel;
    cbRelCodeType: TIWComboBox;
    lblRelCodeType: TIWLabel;
    lblhdrSecurity: TIWLabel;
    bnPlugIn: TIWButton;
    bnDaily: TIWButton;
    bnDirectors: TIWButton;
    bnMCM: TIWButton;
    bnReturnMain: TIWButton;
    edVectronDaily: TIWEdit;
    lblVectronDaily: TIWLabel;
    bnVectronDaily: TIWButton;
    capUserName: TIWLabel;
    lblUserName: TIWLabel;
    TemplateProcessor: TIWTemplateProcessorHTML;
    img1: TIWImage;
    img2: TIWImage;
    img3: TIWImage;
    img4: TIWImage;
    img5: TIWImage;
    bnLogOut: TIWButton;
    lblSystemSecurity: TIWLabel;
    procedure IWAppFormCreate(Sender: TObject);
    procedure cbDateChange(Sender: TObject);
    procedure bnRelCodeClick(Sender: TObject);
    procedure edSecCodeSubmit(Sender: TObject);
    procedure cbRelCodeTypeChange(Sender: TObject);
    procedure bnPlugInClick(Sender: TObject);
    procedure bnMCMClick(Sender: TObject);
    procedure bnDailyClick(Sender: TObject);
    procedure bnDirectorsClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnVectronDailyClick(Sender: TObject);
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

uses SysUtils, uWRIntEntx, uWRIntMods, uWRIntPlugs, uWRIntOther, uPermissionIDs,
     uWRSite, uCodeIDs;

//*** Startup and Shutdown *****************************************************

procedure TfrmIntVect.IWAppFormCreate(Sender: TObject);
begin
  {Initialise form controls;}

  with UserSession, Security do
  begin
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

    // AB - 7
    bnPlugIn.Enabled := (Validate(UserCode, pidPlugPass) = 0) and (isNewerVersion(version5));
    bnMCM.Enabled := (Validate(UserCode, pidMCMPass) = 0) and (isNewerVersion(version5));

    bnDaily.Enabled:= Validate(UserCode, pidDailyPass) = 0;
    bnDirectors.Enabled:= not(isDummyCust) and (Validate(UserCode, pidDirsPass) = 0);
    bnVectronDaily.Enabled:= Validate(UserCode, pidVectDaily) = 0;
    bnRelCode.Enabled:= Validate(UserCode, pidGetVectRel) = 0;

    bnDirectors.Visible:= bnDirectors.Enabled;
    lblDirectors.Visible:= bnDirectors.Enabled;
    edDirectors.Visible:= bnDirectors.Enabled;
  end;

  LoadDates;
  GetCodes;
  CreateTabs;
  LoadTab;
end;

//*** Main *********************************************************************

function TfrmIntVect.CanFullRelease: boolean;
begin
  with UserSession, Security do
  begin
    fCautionOnRelease:= CustRestricted and (Validate(UserCode, pidOverrideCustRestrict) = 0);
    CanFullRelease := ((not(CustRestricted)) or (Validate(UserCode, pidOverrideCustRestrict) = 0)) and
                      (UserSession.bUsingDummyESN = FALSE); // AB - added
  end;
end;

procedure TfrmIntVect.LoadDates;
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

procedure TfrmIntVect.GetCodes;
begin
  with UserSession do
  begin
    if PassPlugIn <> '' then edPlugIn.Text:= PassPlugIn;
    if PassMCM <> '' then edMCM.Text:= PassMCM;
    if PassDaily <> '' then edDaily.Text:= PassDaily;
    if PassDirectors <> '' then edDirectors.Text:= PassDirectors;
  end;
end;

procedure TfrmIntVect.CreateTabs;
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

procedure TfrmIntVect.CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
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

procedure TfrmIntVect.LoadTab;
begin
  with UserSession do
  begin
    if VectDaily <> '' then edVectronDaily.Text:= VectDaily;
    if VectSecCode <> '' then edSecCode.Text:= VectSecCode;
    if VectRelCodeType <> '' then cbRelCodeType.ItemIndex:= cbRelCodeType.Items.IndexOf(VectRelCodeType);
    if VectRelCode <> '' then edRelCode.Text:= VectRelCode;
  end;
end;

procedure TfrmIntVect.EnterpriseClick(Sender: TObject);
begin
  TfrmIntEntx.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntVect.ModulesClick(Sender: TObject);
begin
  TfrmIntMods.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntVect.PlugInsClick(Sender: TObject);
begin
  TfrmIntPlugs.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntVect.VectronClick(Sender: TObject);
begin
  //
end;

procedure TfrmIntVect.OtherClick(Sender: TObject);
begin
  TfrmIntOther.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntVect.cbDateChange(Sender: TObject);
begin
  UserSession.ResetState;

  edPlugIn.Text:= '';
  edMCM.Text:= '';
  edDaily.Text:= '';
  edDirectors.Text:= '';
  edRelCode.Text:= '';

  UserSession.SecDate:= cbDate.Text;
end;

procedure TfrmIntVect.bnRelCodeClick(Sender: TObject);
var
ThirtyDay: boolean;
SecCode, RelCode: string;
RelCodeType: integer;
begin
  with UserSession do
  begin
    if Trim(edSecCode.Text) = '' then
    begin
      WebApplication.ShowMessage('A release code can not be generated without a security code.');
      Exit;
    end
    else SecCode:= UpperCase(Trim(edSecCode.Text));

    if ExceededThreshold(cidVectRel, '') then
    begin
      edRelCode.Text:= '';
      Exit;
    end;

    ThirtyDay:= cbRelCodeType.Text <> fullRelease;
    if cbRelCodeType.Text = fullRelease then RelCodeType:= 1 else RelCodeType:= 0;

    RelCode:= GetInternalCode(cidVectRel, GetDate(cbDate.ItemIndex), ThirtyDay, SecCode);
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidVectRel, cbDate.ItemIndex, RelCodeType, 0, '');
      VectSecCode:= edSecCode.Text;
      VectRelCodeType:= cbRelCodeType.Text;
      VectRelCode:= RelCode;
      edRelCode.Text:= VectRelCode;
      if fCautionOnRelease and (cbRelCodeType.Text = fullRelease) then WebApplication.ShowMessage('You have overridden the 30-day release code restriction for this customer.' + #13#10#13#10 + 'You may want to reconsider giving this release code out.');
    end;
  end;
end;

procedure TfrmIntVect.edSecCodeSubmit(Sender: TObject);
begin
  UserSession.VectSecCode:= edSecCode.Text;
  UserSession.VectRelCode:= '';
  edRelCode.Text:= '';
  ActiveControl:= cbRelCodeType;
end;

procedure TfrmIntVect.cbRelCodeTypeChange(Sender: TObject);
begin
  UserSession.VectRelCodeType:= cbRelCodeType.Text;
  UserSession.VectRelCode:= '';
  edRelCode.Text:= '';
end;

procedure TfrmIntVect.bnPlugInClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession do
  begin
    if ExceededThreshold(cidPlugIn, '') then
    begin
      edPlugIn.Text:= '';
      Exit;
    end;

    RelCode:= GetInternalCode(cidPlugIn, GetDate(cbDate.ItemIndex));
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidPlugIn, cbDate.ItemIndex, 0, 0, '');
      PassPlugIn:= RelCode;
      edPlugIn.Text:= PassPlugIn;
    end;
  end;
end;

procedure TfrmIntVect.bnMCMClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession do
  begin
    if ExceededThreshold(cidMCM, '') then
    begin
      edMCM.Text:= '';
      Exit;
    end;

    RelCode:= GetInternalCode(cidMCM, GetDate(cbDate.ItemIndex));
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidMCM, cbDate.ItemIndex, 0, 0, '');
      PassMCM:= RelCode;
      edMCM.Text:= PassMCM;
    end;
  end;
end;

procedure TfrmIntVect.bnDailyClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession do
  begin
    if ExceededThreshold(cidDaily, '') then
    begin
      edDaily.Text:= '';
      Exit;
    end;

    RelCode:= GetInternalCode(cidDaily, GetDate(cbDate.ItemIndex));
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidDaily, cbDate.ItemIndex, 0, 0, '');
      PassDaily:= RelCode;
      edDaily.Text:= PassDaily;
    end;
  end;
end;

procedure TfrmIntVect.bnDirectorsClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession do
  begin
    if ExceededThreshold(cidDirectors, '') then
    begin
      edDirectors.Text:= '';
      Exit;
    end;

    RelCode:= GetInternalCode(cidDirectors, GetDate(cbDate.ItemIndex));
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidDirectors, cbDate.ItemIndex, 0, 0, '');
      PassDirectors:= RelCode;
      edDirectors.Text:= PassDirectors;
    end;
  end;
end;

procedure TfrmIntVect.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntVect.bnVectronDailyClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession do
  begin
    if ExceededThreshold(cidVectDaily, '') then
    begin
      edVectronDaily.Text:= '';
      Exit;
    end;

    RelCode:= GetInternalCode(cidVectDaily, GetDate(cbDate.ItemIndex));
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidVectDaily, cbDate.ItemIndex, 0, 0, '');
      VectDaily:= RelCode;
      edVectronDaily.Text:= VectDaily;
    end;  
  end;
end;

procedure TfrmIntVect.bnLogOutClick(Sender: TObject);
begin
  //PR: 17/07/2013 ABSEXCH-14438 Rebranding - replaced old web site with exchequer.com
  //LogoutRedirect is declared in uWRServer
  WebApplication.TerminateAndRedirect(LogoutRedirect);
end;

end.