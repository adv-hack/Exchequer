unit uWRIntOther;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompButton, IWCompEdit, IWCompListbox,
  Classes, Controls, IWControl, IWCompLabel, uWRServer, IWExtCtrls,
  IWLayoutMgr, IWTemplateProcessorHTML;

type
  TfrmIntOther = class(TIWAppForm)
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
    lblhdrSecurity: TIWLabel;
    lblResync: TIWLabel;
    edResync: TIWEdit;
    edResetEnt: TIWEdit;
    edResetPlugIn: TIWEdit;
    bnResetEnt: TIWButton;
    bnResetPlugIn: TIWButton;
    lblResetPlugIn: TIWLabel;
    lblResetEnt: TIWLabel;
    bnResync: TIWButton;
    bnPlugIn: TIWButton;
    bnDaily: TIWButton;
    bnDirectors: TIWButton;
    bnMCM: TIWButton;
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
    lblhdrSpecialFunction: TIWLabel;
    lblSFSecCode: TIWLabel;
    edSFSecCode: TIWEdit;
    edSFPassword: TIWEdit;
    lblSFPassword: TIWLabel;
    bnSFGetCode: TIWButton;
    lblMCMLast: TIWLabel;
    lblDailyLast: TIWLabel;
    procedure IWAppFormCreate(Sender: TObject);
    procedure cbDateChange(Sender: TObject);
    procedure bnResyncClick(Sender: TObject);
    procedure bnResetEntClick(Sender: TObject);
    procedure bnResetPlugInClick(Sender: TObject);
    procedure bnPlugInClick(Sender: TObject);
    procedure bnMCMClick(Sender: TObject);
    procedure bnDailyClick(Sender: TObject);
    procedure bnDirectorsClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnLogOutClick(Sender: TObject);
    procedure bnSFGetCodeClick(Sender: TObject);
  private
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
  end;

implementation

{$R *.dfm}

uses SysUtils, uWRIntEntx, uWRIntMods, uWRIntPlugs, uWRIntVect, uPermissionIDs,
     uCodeIDs, uWRSite, uWRData
     ;

//*** Startup and Shutdown *****************************************************

procedure TfrmIntOther.IWAppFormCreate(Sender: TObject);
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

    // AB - 7
    bnPlugIn.Enabled := (Validate(UserCode, pidPlugPass) = 0) and (isNewerVersion(version5));
    bnMCM.Enabled := (Validate(UserCode, pidMCMPass) = 0) and (isNewerVersion(version5));

    bnDaily.Enabled:= Validate(UserCode, pidDailyPass) = 0;
    bnResync.Enabled:= Validate(UserCode, pidResyncPass) = 0;
    bnResetEnt.Enabled:= Validate(UserCode, pidResetEntUCPass) = 0;
    bnResetPlugIn.Enabled:= Validate(UserCode, pidResetPlugUCPass) = 0;

    bnResync.Visible:= isNewerVersion(version431);
    edResync.Visible:= isNewerVersion(version431);
    lblResync.Visible:= isNewerVersion(version431);
    bnResetEnt.Visible:= isNewerVersion(version5);
    edResetEnt.Visible:= isNewerVersion(version5);
    lblResetEnt.Visible:= isNewerVersion(version5);
    bnResetPlugIn.Visible:= isNewerVersion(version5);
    edResetPlugIn.Visible:= isNewerVersion(version5);
    lblResetPlugIn.Visible:= isNewerVersion(version5);

    bnDirectors.Visible:= not(isDummyCust) and (Validate(UserCode, pidDirsPass) = 0);    lblDirectors.Visible:= bnDirectors.Visible;
    edDirectors.Visible:= bnDirectors.Visible;
  end;

  LoadDates;
  GetCodes;
  CreateTabs;
  LoadTab;
end;

//*** Main *********************************************************************

procedure TfrmIntOther.LoadDates;
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

procedure TfrmIntOther.GetCodes;
begin
  with UserSession do
  begin
    if PassPlugIn <> '' then edPlugIn.Text:= PassPlugIn;
    if PassMCM <> '' then edMCM.Text:= PassMCM;
    if PassDaily <> '' then edDaily.Text:= PassDaily;
    if PassDirectors <> '' then edDirectors.Text:= PassDirectors;
  end;
end;

procedure TfrmIntOther.CreateTabs;
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
    if npVectron in Pages then CreateImage(CurrentImg, 'VectronBack.jpg', VectronClick);
    if (npOther in Pages) and isNewerVersion(version431) then CreateImage(CurrentImg, 'OtherFront.jpg', OtherClick);
  end;
end;

procedure TfrmIntOther.CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
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

procedure TfrmIntOther.LoadTab;
begin
  with UserSession do
  begin
    if OtherResync <> '' then edResync.Text:= OtherResync;
    if OtherResetEnt <> '' then edResetEnt.Text:= OtherResetEnt;
    if OtherResetPlugIn <> '' then edResetPlugIn.Text:= OtherResetPlugIn;
  end;
end;

procedure TfrmIntOther.EnterpriseClick(Sender: TObject);
begin
  TfrmIntEntx.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntOther.ModulesClick(Sender: TObject);
begin
  TfrmIntMods.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntOther.PlugInsClick(Sender: TObject);
begin
  TfrmIntPlugs.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntOther.VectronClick(Sender: TObject);
begin
  TfrmIntVect.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntOther.OtherClick(Sender: TObject);
begin
  //
end;

procedure TfrmIntOther.cbDateChange(Sender: TObject);
begin
  UserSession.ResetState;

  edPlugIn.Text:= '';
  edMCM.Text:= '';
  edDaily.Text:= '';
  edDirectors.Text:= ''; 
  edResync.Text:= '';
  edResetEnt.Text:= '';
  edResetPlugIn.Text:= '';

  UserSession.SecDate:= cbDate.Text;
end;

procedure TfrmIntOther.bnResyncClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession do
  begin
    if ExceededThreshold(cidResync, '') then
    begin
      edResync.Text:= '';
      Exit;
    end;

    RelCode:= GetInternalCode(cidResync, GetDate(cbDate.ItemIndex));
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidResync, cbDate.ItemIndex, 0, 0, '');
      if isNewerVersion(version5) then ResyncCompanies;
      OtherResync:= RelCode;
      edResync.Text:= OtherResync;
    end;
  end;
end;

procedure TfrmIntOther.bnResetEntClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession do
  begin
    if ExceededThreshold(cidResetEnt, '') then
    begin
      edResetEnt.Text:= '';
      Exit;
    end;  

    RelCode:= GetInternalCode(cidResetEnt, GetDate(cbDate.ItemIndex));
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidResetEnt, cbDate.ItemIndex, 0, 0, '');
      OtherResetEnt:= RelCode;
      edResetEnt.Text:= OtherResetEnt;
    end;
  end;
end;

procedure TfrmIntOther.bnResetPlugInClick(Sender: TObject);
var
RelCode: string;
begin
  with UserSession do
  begin
    if ExceededThreshold(cidResetPlug, '') then
    begin
      edResetPlugIn.Text:= '';
      Exit;
    end;

    RelCode:= GetInternalCode(cidResetPlug, GetDate(cbDate.ItemIndex));
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidResetPlug, cbDate.ItemIndex, 0, 0, '');
      OtherResetPlugIn:= RelCode;
      edResetPlugIn.Text:= OtherResetPlugIn;
    end;
  end;
end;

procedure TfrmIntOther.bnPlugInClick(Sender: TObject);
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

procedure TfrmIntOther.bnMCMClick(Sender: TObject);
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
      lblMCMLast.Text := GetTodaySecurityLasts;
      PassMCM:= RelCode;
      edMCM.Text:= PassMCM;
    end;
  end;
end;

procedure TfrmIntOther.bnDailyClick(Sender: TObject);
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
      lblDailyLast.Text := GetTodaySecurityLasts;
      PassDaily:= RelCode;
      edDaily.Text:= PassDaily;
    end;
  end;
end;

procedure TfrmIntOther.bnDirectorsClick(Sender: TObject);
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

procedure TfrmIntOther.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntOther.bnLogOutClick(Sender: TObject);
begin
  //PR: 17/07/2013 ABSEXCH-14438 Rebranding - replaced old web site with exchequer.com
  //LogoutRedirect is declared in uWRServer
  WebApplication.TerminateAndRedirect(LogoutRedirect);
end;

procedure TfrmIntOther.bnSFGetCodeClick(Sender: TObject);
begin
  with UserSession do
  begin
    if ExceededThreshold(cidSpecialFunction, '') then
    begin
      edSFSecCode.Clear;
      edSFPassword.Clear;
    end;

    edSFSecCode.Text := UpperCase(edSFSecCode.Text);
    edSFPassword.Text := GetSpecialFunctionPass(edSFSecCode.Text);

    if edSFPassword.Text <> '' then
      AuditLog(edSFPassword.Text, cidSpecialFunction, -1, 0, 0, '');
  end;

(*  with UserSession do
  begin
    if ExceededThreshold(cidResetPlug, '') then
    begin
      edResetPlugIn.Text:= '';
      Exit;
    end;

    RelCode:= GetInternalCode(cidResetPlug, GetDate(cbDate.ItemIndex));
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidResetPlug, cbDate.ItemIndex, 0, 0, '');
      OtherResetPlugIn:= RelCode;
      edResetPlugIn.Text:= OtherResetPlugIn;
    end;
  end;
*)
end;

end.