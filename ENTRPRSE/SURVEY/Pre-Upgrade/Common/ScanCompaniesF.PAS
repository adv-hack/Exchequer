unit ScanCompaniesF;

{$ALIGN 1}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdvProgressBar;

type
  TfrmScanEnterprise = class(TForm)
    lblProgress: TLabel;
    Timer1: TTimer;
    AdvProgressBar1: TAdvProgressBar;
    procedure FormActivate(Sender: TObject);
    Procedure ScanEnterprise(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

Uses oSurveyStore, SurveyF;

//--------------------------------------------------------------------------

procedure TfrmScanEnterprise.FormCreate(Sender: TObject);
begin
//  ProgressBar1.Min := 0;
//  ProgressBar1.Position := 0;
end;

//---------------------------------------

procedure TfrmScanEnterprise.FormActivate(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

//---------------------------------------

procedure TfrmScanEnterprise.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//--------------------------------------------------------------------------

// Scans the Exchequer installation and creates a text report
// of the installed companies
Procedure TfrmScanEnterprise.ScanEnterprise(Sender: TObject);
Begin { ScanEnterprise }
  // Disable timer to prevent event happening again
  Timer1.Enabled := False;

  // Update Progress Screen
  lblProgress.Caption := 'Checking Exchequer Directory...';
  lblProgress.Refresh;

  // Read Exchequer Licence if available
  oSurveyInfo.CheckEntLicence;

  // MH 11/10/07: Added reporting on installed plug-ins
  oSurveyInfo.CheckPlugIns;

  // Scan the installation data
  oSurveyInfo.InstallationData.ScanInstallation;

  // Move to Warnings dialog
  Hide;
  With TfrmCustSurvey.Create(Application.MainForm) Do
  Begin
    Mode := FirstSurveyDialog;
    Show;
  End; // With TfrmCustSurvey.Create(Application.MainForm)
  Close;
End; { ScanEnterprise }

//--------------------------------------------------------------------------

end.
