unit uWRIntPlugs;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompButton, IWCompEdit, IWCompListbox,
  Classes, Controls, IWControl, IWCompLabel, uWRServer, IWExtCtrls,
  IWLayoutMgr, IWTemplateProcessorHTML;

type
  TfrmIntPlugs = class(TIWAppForm)
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
    lblSecPlugIn: TIWLabel;
    lblMCM: TIWLabel;
    lblDaily: TIWLabel;
    lblDirectors: TIWLabel;
    lblhdrSecurity: TIWLabel;
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
    lblhdrUserCount: TIWLabel;
    cb30RelCodeType: TIWComboBox;
    lbl30RelCodeType: TIWLabel;
    cbPlugIn: TIWComboBox;
    lblModule: TIWLabel;
    cb30PlugIn: TIWComboBox;
    lbl30PlugIn: TIWLabel;
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
    procedure cbPlugInChange(Sender: TObject);
    procedure edSecCodeSubmit(Sender: TObject);
    procedure cbRelCodeTypeChange(Sender: TObject);
    procedure cb30PlugInChange(Sender: TObject);
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
    procedure LoadPlugIns;
    procedure LoadTab;

    procedure EnterpriseClick(Sender: TObject);
    procedure ModulesClick(Sender: TObject);
    procedure OtherClick(Sender: TObject);
    procedure PlugInsClick(Sender: TObject);
    procedure VectronClick(Sender: TObject);

    function CanFullRelease: boolean;
    function GetPlugCode(PlugDesc: string): string;
  end;

implementation

{$R *.dfm}

uses SysUtils, uWRIntEntx, uWRIntMods, uWRIntVect, uWRIntOther, uWRData,
     uWRSite, uPermissionIDs, uCodeIDs;

//*** Startup and Shutdown *****************************************************

procedure TfrmIntPlugs.IWAppFormCreate(Sender: TObject);
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
      if Validate(UserCode, pidFullPlugRel) = 0 then cbRelCodeType.Items.Add(fullRelease);
      if Validate(UserCode, pidFullPlugUCRel) = 0 then cb30RelCodeType.Items.Add(fullRelease);
    end;

    // AB - 7
    bnPlugIn.Enabled := (Validate(UserCode, pidPlugPass) = 0) and (isNewerVersion(version5));
    bnMCM.Enabled := (Validate(UserCode, pidMCMPass) = 0) and (isNewerVersion(version5));

    bnDaily.Enabled:= Validate(UserCode, pidDailyPass) = 0;
    bnDirectors.Enabled:= not(isDummyCust) and (Validate(UserCode, pidDirsPass) = 0);
    bnRelCode.Enabled:= (Validate(UserCode, pidGetPlugRel) = 0) and (cbPlugIn.Items.Count > 0);
    bn30RelCode.Enabled:= (Validate(UserCode, pidGetPlugUCRel) = 0) and (cb30PlugIn.Items.Count > 0);

    bnDirectors.Visible:= bnDirectors.Enabled;
    lblDirectors.Visible:= bnDirectors.Enabled;
    edDirectors.Visible:= bnDirectors.Enabled;
  end;

  LoadDates;
  GetCodes;
  CreateTabs;
  LoadPlugIns;
  LoadTab;
end;

//*** Main *********************************************************************

procedure TfrmIntPlugs.LoadDates;
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

procedure TfrmIntPlugs.GetCodes;
begin
  with UserSession do
  begin
    if PassPlugIn <> '' then edPlugIn.Text:= PassPlugIn;
    if PassMCM <> '' then edMCM.Text:= PassMCM;
    if PassDaily <> '' then edDaily.Text:= PassDaily;
    if PassDirectors <> '' then edDirectors.Text:= PassDirectors;
  end;
end;

procedure TfrmIntPlugs.CreateTabs;
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

procedure TfrmIntPlugs.CreateImage(var CurrentImg: integer; ImageName: string; ClickProc: TImageClickProc);
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

procedure TfrmIntPlugs.LoadPlugIns;
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

procedure TfrmIntPlugs.LoadTab;
begin
  with UserSession do
  begin
    if PlugsModule <> '' then cbPlugIn.ItemIndex:= cbPlugIn.Items.IndexOf(PlugsModule);
    if PlugsSecCode <> '' then edSecCode.Text:= PlugsSecCode;
    if PlugsRelCodeType <> '' then cbRelCodeType.ItemIndex:= cbRelCodeType.Items.IndexOf(PlugsRelCodeType);
    if PlugsRelCode <> '' then edRelCode.Text:= PlugsRelCode;

    if Plugs30Module <> '' then cb30PlugIn.ItemIndex:= cb30PlugIn.Items.IndexOf(Plugs30Module);
    if Plugs30SecCode <> '' then ed30SecCode.Text:= Plugs30SecCode;
    if Plugs30RelCodeType <> '' then cb30RelCodeType.ItemIndex:= cb30RelCodeType.Items.IndexOf(Mod30RelCodeType);
    if Plugs30UserCount <> '' then ed30UserCount.Text:= Plugs30UserCount;
    if Plugs30RelCode <> '' then ed30RelCode.Text:= Plugs30RelCode;
  end;
end;

procedure TfrmIntPlugs.EnterpriseClick(Sender: TObject);
begin
  TfrmIntEntx.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntPlugs.ModulesClick(Sender: TObject);
begin
  TfrmIntMods.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntPlugs.PlugInsClick(Sender: TObject);
begin
  //
end;

procedure TfrmIntPlugs.VectronClick(Sender: TObject);
begin
  TfrmIntVect.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntPlugs.OtherClick(Sender: TObject);
begin
  TfrmIntOther.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntPlugs.cbDateChange(Sender: TObject);
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

procedure TfrmIntPlugs.bnRelCodeClick(Sender: TObject);
var
ThirtyDay: boolean;
SecCode, PlugCode, RelCode: string;
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

    if ExceededThreshold(cidPlugRel, cbPlugIn.Text) then
    begin
      edRelCode.Text:= '';
      Exit;
    end;

    ThirtyDay:= cbRelCodeType.Text <> fullRelease;
    if cbRelCodeType.Text = fullRelease then RelCodeType:= 1 else RelCodeType:= 0;
    PlugCode:= GetPlugCode(Trim(cbPlugIn.Text));

    RelCode:= GetInternalCode(cidPlugRel, GetDate(cbDate.ItemIndex), ThirtyDay, SecCode, 0, PlugCode);
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidPlugRel, cbDate.ItemIndex, RelCodeType, 0, cbPlugIn.Text);
      PlugsModule:= cbPlugIn.Text;
      PlugsSecCode:= edSecCode.Text;
      PlugsRelCodeType:= cbRelCodeType.Text;
      PlugsRelCode:= RelCode;
      edRelCode.Text:= PlugsRelCode;
      if fCautionOnRelease and (cbRelCodeType.Text = fullRelease) then WebApplication.ShowMessage('You have overridden the 30-day release code restriction for this customer.' + #13#10#13#10 + 'You may want to reconsider giving this release code out.');
    end;
  end;
end;

procedure TfrmIntPlugs.bn30RelCodeClick(Sender: TObject);
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

    if ExceededThreshold(cidPlugUCRel, cb30PlugIn.Text) then
    begin
      ed30RelCode.Text:= '';
      Exit;
    end;

    ThirtyDay:= cb30RelCodeType.Text <> fullRelease;
    if cb30RelCodeType.Text = fullRelease then RelCodeType:= 1 else RelCodeType:= 0;
    PlugCode:= GetPlugCode(Trim(cb30PlugIn.Text));

    RelCode:= GetInternalCode(cidPlugUCRel, GetDate(cbDate.ItemIndex), ThirtyDay, SecCode, UserCount, PlugCode);
    if RelCode <> '' then
    begin
      AuditLog(RelCode, cidPlugUCRel, cbDate.ItemIndex, RelCodeType, StrToIntDef(ed30UserCount.Text, 0), cb30PlugIn.Text);
      Plugs30Module:= cb30PlugIn.Text;
      Plugs30SecCode:= ed30SecCode.Text;
      Plugs30RelCodeType:= cb30RelCodeType.Text;
      Plugs30UserCount:= ed30UserCount.Text;
      Plugs30RelCode:= RelCode;
      ed30RelCode.Text:= Plugs30RelCode;
      if fCautionOnRelease and (cb30RelCodeType.Text = fullRelease) then WebApplication.ShowMessage('You have overridden the 30-day release code restriction for this customer.' + #13#10#13#10 + 'You may want to reconsider giving this release code out.');
    end;
  end;
end;

procedure TfrmIntPlugs.cbPlugInChange(Sender: TObject);
begin
  UserSession.PlugsModule:= cbPlugIn.Text;
  UserSession.PlugsSecCode:= '';
  UserSession.PlugsRelCode:= '';
  edSecCode.Text:= '';
  edRelCode.Text:= '';
end;

procedure TfrmIntPlugs.edSecCodeSubmit(Sender: TObject);
begin
  UserSession.PlugsSecCode:= edSecCode.Text;
  UserSession.PlugsRelCode:= '';
  edRelCode.Text:= '';
  ActiveControl:= cbRelCodeType;
end;

procedure TfrmIntPlugs.cbRelCodeTypeChange(Sender: TObject);
begin
  UserSession.PlugsRelCodeType:= cbRelCodeType.Text;
  UserSession.PlugsRelCode:= '';
  edRelCode.Text:= '';
end;

procedure TfrmIntPlugs.cb30PlugInChange(Sender: TObject);
begin
  UserSession.Plugs30Module:= cb30PlugIn.Text;
  UserSession.Plugs30SecCode:= '';
  UserSession.Plugs30UserCount:= '';
  UserSession.Plugs30RelCode:= '';
  ed30SecCode.Text:= '';
  ed30UserCount.Text:= '';
  ed30RelCode.Text:= '';
end;

procedure TfrmIntPlugs.ed30SecCodeSubmit(Sender: TObject);
begin
  UserSession.Plugs30SecCode:= ed30SecCode.Text;
  UserSession.Plugs30RelCode:= '';
  ed30RelCode.Text:= '';
  ActiveControl:= cb30RelCodeType;
end;

procedure TfrmIntPlugs.cb30RelCodeTypeChange(Sender: TObject);
begin
  UserSession.Plugs30RelCodeType:= cb30RelCodeType.Text;
  UserSession.Plugs30RelCode:= '';
  ed30RelCode.Text:= '';
end;

procedure TfrmIntPlugs.ed30UserCountSubmit(Sender: TObject);
begin
  UserSession.Plugs30UserCount:= ed30UserCount.Text;
  UserSession.Plugs30RelCode:= '';
  ed30RelCode.Text:= '';
  ActiveControl:= bn30RelCode;
end;

procedure TfrmIntPlugs.bnPlugInClick(Sender: TObject);
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

procedure TfrmIntPlugs.bnMCMClick(Sender: TObject);
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

procedure TfrmIntPlugs.bnDailyClick(Sender: TObject);
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

procedure TfrmIntPlugs.bnDirectorsClick(Sender: TObject);
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

procedure TfrmIntPlugs.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

function TfrmIntPlugs.CanFullRelease: boolean;
begin
  with UserSession, Security do
  begin
    fCautionOnRelease:= CustRestricted and (Validate(UserCode, pidOverrideCustRestrict) = 0);
    CanFullRelease := ((not(CustRestricted)) or (Validate(UserCode, pidOverrideCustRestrict) = 0)) and
                      (UserSession.bUsingDummyESN = FALSE); // AB - added
  end;
end;

function TfrmIntPlugs.GetPlugCode(PlugDesc: string): string;
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

procedure TfrmIntPlugs.bnLogOutClick(Sender: TObject);
begin
  WebApplication.TerminateAndRedirect('http://www.exchequer.com');
end;

end.