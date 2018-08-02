unit uWRIntNone;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompEdit, IWCompListbox, Classes,
  Controls, IWControl, IWCompLabel, IWCompButton, IWLayoutMgr,
  IWTemplateProcessorHTML;

type
  TfrmIntNone = class(TIWAppForm)
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
    bnPlugIn: TIWButton;
    bnDaily: TIWButton;
    bnDirectors: TIWButton;
    bnMCM: TIWButton;
    bnReturnMain: TIWButton;
    capUserName: TIWLabel;
    lblUserName: TIWLabel;
    TemplateProcessor: TIWTemplateProcessorHTML;
    bnLogOut: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure cbDateChange(Sender: TObject);
    procedure bnPlugInClick(Sender: TObject);
    procedure bnMCMClick(Sender: TObject);
    procedure bnDailyClick(Sender: TObject);
    procedure bnDirectorsClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnLogOutClick(Sender: TObject);
  private
    procedure GetCodes;
    procedure LoadDates;
  end;

implementation

{$R *.dfm}

uses uWRServer, uWRSite, uPermissionIDs, uCodeIDs, SysUtils;

//******************************************************************************

procedure TfrmIntNone.IWAppFormCreate(Sender: TObject);

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
    bnDirectors.Enabled:= not(isDummyCust) and (Validate(UserCode, pidDirsPass) = 0);

    bnDirectors.Visible:= bnDirectors.Enabled;
    lblDirectors.Visible:= bnDirectors.Enabled;
    edDirectors.Visible:= bnDirectors.Enabled;
  end;

  LoadDates;
  GetCodes;
end;

//*** Main *********************************************************************

procedure TfrmIntNone.LoadDates;
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

procedure TfrmIntNone.GetCodes;
begin
  with UserSession do
  begin
    if PassPlugIn <> '' then edPlugIn.Text:= PassPlugIn;
    if PassMCM <> '' then edMCM.Text:= PassMCM;
    if PassDaily <> '' then edDaily.Text:= PassDaily;
    if PassDirectors <> '' then edDirectors.Text:= PassDirectors;
  end;
end;

procedure TfrmIntNone.cbDateChange(Sender: TObject);
begin
  UserSession.ResetState;

  edPlugIn.Text:= '';
  edMCM.Text:= '';
  edDaily.Text:= '';
  edDirectors.Text:= '';

  UserSession.SecDate:= cbDate.Text;
end;

procedure TfrmIntNone.bnPlugInClick(Sender: TObject);
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

procedure TfrmIntNone.bnMCMClick(Sender: TObject);
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

procedure TfrmIntNone.bnDailyClick(Sender: TObject);
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

procedure TfrmIntNone.bnDirectorsClick(Sender: TObject);
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

procedure TfrmIntNone.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmIntNone.bnLogOutClick(Sender: TObject);
begin
  //PR: 17/07/2013 ABSEXCH-14438 Rebranding - replaced old web site with exchequer.com
  //LogoutRedirect is declared in uWRServer
  WebApplication.TerminateAndRedirect(LogoutRedirect);
end;

end.