unit IntroductionF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseF, ExtCtrls, StdCtrls, Buttons;

Const
  Stage_Abort   = 0;
  Stage_Main    = 1;
  Stage_EntDir  = 2;
  Stage_Scan    = 3;
  Stage_Results = 4;

Type
  TfrmMainForm = class(TSetupTemplate)
    lblVersion: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Var
  frmMainForm: TfrmMainForm;


implementation

{$R *.dfm}

Uses History, ScanCompaniesF;

//--------------------------------------------------------------------------

procedure TfrmMainForm.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := Application.Title;
  ExitMsg := 255;

  lblVersion.Caption := SurveyVersion;
end;

//--------------------------------------------------------------------------

procedure TfrmMainForm.NextBtnClick(Sender: TObject);
begin
  // NOTE: Inherited has to be removed as it calls close which ballses things up
  //Inherited;

  // Hide the 'Introduction' form
  Hide;

  // Display the 'Scanning In Progress' form which does the scan from the FormActivate
  TfrmScanEnterprise.Create(Self).Show;
end;

end.
