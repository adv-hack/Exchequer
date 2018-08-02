unit uWRIntMods;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompButton, IWCompEdit, IWCompListbox,
  Classes, Controls, IWControl, IWCompLabel, uWRServer, IWExtCtrls,
  IWLayoutMgr, IWTemplateProcessorHTML;

type
  TfrmIntMods = class(TIWAppForm)
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
    cbModule: TIWComboBox;
    lblModule: TIWLabel;
    cb30Module: TIWComboBox;
    lbl30Module: TIWLabel;
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
    procedure IWAppFormCreate(Sender: TObject);
    procedure cbDateChange(Sender: TObject);
    procedure bnRelCodeClick(Sender: TObject);
    procedure bn30RelCodeClick(Sender: TObject);
    procedure cbModuleChange(Sender: TObject);
    procedure edSecCodeSubmit(Sender: TObject);
    procedure cbRelCodeTypeChange(Sender: TObject);
    procedure cb30ModuleChange(Sender: TObject);
    procedure ed30SecCodeSubmit(Sender: TObject);
    procedure cb30RelCodeTypeChange(Sender: TObject);
    procedure ed30UserCountSubmit(Sender: TObject);
    procedure bnPlugInClick(Sender: TObject);
    procedure bnMCMClick(Sender: TObject);
    procedure bnDailyClick(Sender: TObject);
    procedure bnDirectorsClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnLogOutClick(Sender: TObject);
  private
    fCautionOnRelease: boolean;

    procedure CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
    procedure CreateTabs;
    procedure GetCodes;
    procedure LoadDates;
    procedure LoadModules;
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

uses SysUtils, uWRIntEntx, uWRIntPlugs, uWRIntVect, uWRIntOther, uWRData,
     uWRSite, uPermissionIDs, uCodeIDs;

//*** Startup and Shutdown *****************************************************

procedure TfrmIntMods.IWAppFormCreate(Sender: TObject);
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
      if Validate(UserCode, pidGetFullModRel) = 0 then cbRelCodeType.Items.Add(fullRelease);
      if Validate(UserCode, pidGetFullModUCRel) = 0 then cb30RelCodeType.Items.Add(fullRelease);
    end;

    // AB - 7
    bnPlugIn.Enabled := (Validate(UserCode, pidPlugPass) = 0) and (isNewerVersion(version5));
    bnMCM.Enabled := (Validate(UserCode, pidMCMPass) = 0) and (isNewerVersion(version5));

    bnDaily.Enabled:= Validate(UserCode, pidDailyPass) = 0;
    bnDirectors.Enabled:= not(isDummyCust) and (Validate(UserCode, pidDirsPass) = 0);
    bnRelCode.Enabled:= (Validate(UserCode, pidGetFullModRel) = 0) and (cbModule.Items.Count > 0);
    bn30RelCode.Enabled:= (Validate(UserCode, pidGetFullModUCRel) = 0) and (cb30Module.Items.Count > 0);

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
    lbl30RelCode.Visible:= isNewerVersion(version5);
    ed30RelCode.Visible:= isNewerVersion(version5);
  
    bnDirectors.Visible:= bnDirectors.Enabled;
    lblDirectors.Visible:= bnDirectors.Enabled;
    edDirectors.Visible:= bnDirectors.Enabled;
  end;

  LoadDates;
  GetCodes;
  CreateTabs;
  LoadModules;
  LoadTab;
end;

//*** Main *********************************************************************

procedure TfrmIntMods.LoadDates;
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

procedure TfrmIntMods.GetCodes;
begin
  with UserSession do
  begin
    if PassPlugIn <> '' then edPlugIn.Text:= PassPlugIn;
    if PassMCM <> '' then edMCM.Text:= PassMCM;
    if PassDaily <> '' then edDaily.Text:= PassDaily;
    if PassDirectors <> '' then edDirectors.Text:= PassDirectors;
  end;
end;

procedure TfrmIntMods.CreateTabs;
var
  CurrentImg : integer;
begin
  CurrentImg := 1;

  with UserSession do
  begin
    if npEnterprise in Pages then CreateImage(CurrentImg, 'EnterpriseBack.jpg', EnterpriseClick);
    if npModules in Pages then CreateImage(CurrentImg, 'ModulesFront.jpg', ModulesClick);
    // AB - 8
    if (npPlugIns in Pages) and isNewerVersion(version5) then CreateImage(CurrentImg, 'PlugInsBack.jpg', PlugInsClick);
    if npVectron in Pages then CreateImage(CurrentImg, 'VectronBack.jpg', VectronClick);
    if (npOther in Pages) and isNewerVersion(version431) then CreateImage(CurrentImg, 'OtherBack.jpg', OtherClick);
  end;
end;

procedure TfrmIntMods.CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
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

procedure TfrmIntMods.LoadModules;
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

procedure TfrmIntMods.LoadTab;
begin
  with UserSession do
  begin
    if ModModule <> '' then cbModule.ItemIndex:= cbModule.Items.IndexOf(ModModule);
    if ModSecCode <> '' then edSecCode.Text:= ModSecCode;
    if ModRelCodeType <> '' then cbRelCodeType.ItemIndex:= cbRelCodeType.Items.IndexOf(ModRelCodeType);
    if ModRelCode <> '' then edRelCode.Text:= ModRelCode;

    if Mod30Module <> '' then cb30Module.ItemIndex:= cb30Module.Items.IndexOf(Mod30Module);
    if Mod30SecCode <> '' then ed30SecCode.Text:= Mod30SecCode;
    if Mod30RelCodeType <> '' then cb30RelCodeType.ItemIndex:= cb30RelCodeType.Items.IndexOf(Mod30RelCodeType);
    if Mod30UserCount <> '' then ed30UserCount.Text:= Mod30UserCount;
    if Mod30RelCode <> '' then ed30RelCode.Text:= Mod30RelCode;
  end;
end;

procedure TfrmIntMods.EnterpriseClick(Sender: TObject);
begin
  TfrmIntEntx.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntMods.ModulesClick(Sender: TObject);
begin
  //
end;

procedure TfrmIntMods.PlugInsClick(Sender: TObject);
begin
  TfrmIntPlugs.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntMods.VectronClick(Sender: TObject);
begin
  TfrmIntVect.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntMods.OtherClick(Sender: TObject);
begin
  TfrmIntOther.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntMods.cbDateChange(Sender: TObject);
begin
  UserSession.ResetState;

  edPlugIn.Text:= '';
  edMCM.Text:= '';
  edDaily.Text:= '';
  edDirectors.Text:= '';
  edRelCode.Text:= '';
  ed30RelCode.Text:= '';

  UserSession.SecDate:= cbDate.Text;
end;

procedure TfrmIntMods.bnRelCodeClick(Sender: TObject);
var
SecCode, RelCode: string;
ThirtyDay: boolean;
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

    if ExceededThreshold(cidModRel, cbModule.Text) then
    begin
      edRelCode.Text:= '';
      Exit;
    end;

    ThirtyDay:= cbRelCodeType.Text <> fullRelease;
    if cbRelCodeType.Text = fullRelease then RelCodeType:= 1 else RelCodeType:= 0;

    RelCode:= GetInternalCode(cidModRel, GetDate(cbDate.ItemIndex), ThirtyDay, SecCode, 0, Trim(cbModule.Text));
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidModRel, cbDate.ItemIndex, RelCodeType, 0, cbModule.Text);
      ModModule:= cbModule.Text;
      ModSecCode:= edSecCode.Text;
      ModRelCodeType:= cbRelCodeType.Text;
      ModRelCode:= RelCode;
      edRelCode.Text:= ModRelCode;
      if fCautionOnRelease and (cbRelCodeType.Text = fullRelease) then WebApplication.ShowMessage('You have overridden the 30-day release code restriction for this customer.' + #13#10#13#10 + 'You may want to reconsider giving this release code out.');
    end;
  end;
end;

procedure TfrmIntMods.bn30RelCodeClick(Sender: TObject);
var
UserCount, RelCodeType: integer;
SecCode, RelCode: string;
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

    if ExceededThreshold(cidModUCRel, cb30Module.Text) then
    begin
      ed30RelCode.Text:= '';
      Exit;
    end;

    ThirtyDay:= cb30RelCodeType.Text <> fullRelease;
    if cb30RelCodeType.Text = fullRelease then RelCodeType:= 1 else RelCodeType:= 0;

    RelCode:= GetInternalCode(cidModUCRel, GetDate(cbDate.ItemIndex), ThirtyDay, SecCode, UserCount, cb30Module.Text);
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidModUCRel, cbDate.ItemIndex, RelCodeType, StrToIntDef(ed30UserCount.Text, 0), Trim(cb30Module.Text));
      Mod30Module:= cb30Module.Text;
      Mod30SecCode:= ed30SecCode.Text;
      Mod30RelCodeType:= cb30RelCodeType.Text;
      Mod30UserCount:= ed30UserCount.Text;
      Mod30RelCode:= RelCode;
      ed30RelCode.Text:= Mod30RelCode;
      if fCautionOnRelease and (cb30RelCodeType.Text = fullRelease) then WebApplication.ShowMessage('You have overridden the 30-day release code restriction for this customer.' + #13#10#13#10 + 'You may want to reconsider giving this release code out.');
    end;
  end;
end;

procedure TfrmIntMods.cbModuleChange(Sender: TObject);
begin
  UserSession.ModModule:= cbModule.Text;
  UserSession.ModRelCode:= '';
  UserSession.ModSecCode:= '';
  edSecCode.Text:= '';
  edRelCode.Text:= '';
end;

procedure TfrmIntMods.edSecCodeSubmit(Sender: TObject);
begin
  UserSession.ModSecCode:= edSecCode.Text;
  UserSession.ModRelCode:= '';
  edRelCode.Text:= '';
  ActiveControl:= cbRelCodeType;
end;

procedure TfrmIntMods.cbRelCodeTypeChange(Sender: TObject);
begin
  UserSession.ModRelCodeType:= cbRelCodeType.Text;
  UserSession.ModRelCode:= '';
  edRelCode.Text:= '';
end;

procedure TfrmIntMods.cb30ModuleChange(Sender: TObject);
begin
  UserSession.Mod30Module:= cb30Module.Text;
  UserSession.Mod30SecCode:= '';
  UserSession.Mod30UserCount:= '';
  UserSession.Mod30RelCode:= '';
  ed30SecCode.Text:= '';
  ed30UserCount.Text:= '';
  ed30RelCode.Text:= '';
end;

procedure TfrmIntMods.ed30SecCodeSubmit(Sender: TObject);
begin
  UserSession.Mod30SecCode:= ed30SecCode.Text;
  UserSession.Mod30RelCode:= '';
  ed30RelCode.Text:= '';
  ActiveControl:= cb30RelCodeType;
end;

procedure TfrmIntMods.cb30RelCodeTypeChange(Sender: TObject);
begin
  UserSession.Mod30RelCodeType:= cb30RelCodeType.Text;
  UserSession.Mod30RelCode:= '';
  ed30RelCode.Text:= '';
end;

procedure TfrmIntMods.ed30UserCountSubmit(Sender: TObject);
begin
  UserSession.Mod30UserCount:= ed30UserCount.Text;
  UserSession.Mod30RelCode:= '';
  ed30RelCode.Text:= '';
  ActiveControl:= bn30RelCode;
end;

procedure TfrmIntMods.bnPlugInClick(Sender: TObject);
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

procedure TfrmIntMods.bnMCMClick(Sender: TObject);
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

procedure TfrmIntMods.bnDailyClick(Sender: TObject);
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

procedure TfrmIntMods.bnDirectorsClick(Sender: TObject);
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

procedure TfrmIntMods.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

function TfrmIntMods.CanFullRelease: boolean;
begin
  with UserSession, Security do
  begin
    fCautionOnRelease:= CustRestricted and (Validate(UserCode, pidOverrideCustRestrict) = 0);
    CanFullRelease := ((not(CustRestricted)) or (Validate(UserCode, pidOverrideCustRestrict) = 0)) and
                      (UserSession.bUsingDummyESN = FALSE); // AB - added
  end;
end;

procedure TfrmIntMods.bnLogOutClick(Sender: TObject);
begin
  WebApplication.TerminateAndRedirect('http://www.exchequer.com');
end;

end.
