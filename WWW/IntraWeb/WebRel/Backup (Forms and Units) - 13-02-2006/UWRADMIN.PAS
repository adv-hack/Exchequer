unit uWRAdmin;

interface

uses
  IWAppForm, IWApplication, IWTypes, Classes, Controls, IWControl,
  IWCompButton, IWCompLabel;

type
  TfrmAdmin = class(TIWAppForm)
    bnDealers: TIWButton;
    bnCustomers: TIWButton;
    bnUsers: TIWButton;
    bnModules: TIWButton;
    bnReturnMain: TIWButton;
    bnSecAudit: TIWButton;
    bnAdminAudit: TIWButton;
    bnThresholds: TIWButton;
    bnEmails: TIWButton;
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnDealersClick(Sender: TObject);
    procedure bnUsersClick(Sender: TObject);
    procedure bnCustomersClick(Sender: TObject);
    procedure bnModulesClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure bnSecAuditClick(Sender: TObject);
    procedure bnAdminAuditClick(Sender: TObject);
    procedure bnThresholdsClick(Sender: TObject);
    procedure bnEmailsClick(Sender: TObject);
  end;

implementation

{$R *.dfm}

uses uWRServer, uWRSite, uWRDealers, uWRUsers, uWRCustomers, uWRModules,
     uWRThresholds, uWREmail, uWRSecAudit, uWRAdAudit, uPermissionIDs;

//*** Startup and Shutdown *****************************************************

procedure TfrmAdmin.IWAppFormCreate(Sender: TObject);
begin
  {Enable access to the auditing areas if the user has the necessary permissions;}

  with UserSession, Security do
  begin
    bnSecAudit.Visible:= Validate(UserCode, pidSecAudit) = 0;
    bnAdminAudit.Visible:= Validate(UserCode, pidAdminAudit) = 0;
  end;
end;

//*** Event Handlers ***********************************************************

{Show the corresponding form for the button clicked and release the current form;}

procedure TfrmAdmin.bnDealersClick(Sender: TObject);
begin
  TfrmDealers.Create(WebApplication).Show;
  Release;
end;

procedure TfrmAdmin.bnUsersClick(Sender: TObject);
begin
  TfrmUsers.Create(WebApplication).Show;
  Release;
end;

procedure TfrmAdmin.bnCustomersClick(Sender: TObject);
begin
  TfrmCustomers.Create(WebApplication).Show;
  Release;
end;

procedure TfrmAdmin.bnModulesClick(Sender: TObject);
begin
  TfrmModules.Create(WebApplication).Show;
  Release;
end;

procedure TfrmAdmin.bnThresholdsClick(Sender: TObject);
begin
  with TfrmThresholds.Create(WebApplication) do
  begin
    lblhdrThresholds.Caption:= 'Global Thresholds';
    bnNew.Visible:= true;
    lblReleaseCodes.Visible:= true;
    cbRelCode.Visible:= true;
    bnReturnCust.Visible:= false;
    InitThresholds(0, nil);
    Show;
  end;

  Release;
end;

procedure TfrmAdmin.bnEmailsClick(Sender: TObject);
begin
  TfrmEmail.Create(WebApplication).Show;
  Release;
end;

procedure TfrmAdmin.bnSecAuditClick(Sender: TObject);
begin
  TfrmSecAudit.Create(WebApplication).Show;
  Release;
end;

procedure TfrmAdmin.bnAdminAuditClick(Sender: TObject);
begin
  TfrmAdminAudit.Create(WebApplication).Show;
  Release;
end;

procedure TfrmAdmin.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

//******************************************************************************

end.
