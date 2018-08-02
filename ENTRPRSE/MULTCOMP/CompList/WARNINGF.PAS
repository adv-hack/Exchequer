unit WarningF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, ExtCtrls, StdCtrls;

type
  TfrmWarnings = class(TSetupTemplate)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NextBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWarnings: TfrmWarnings;

implementation

{$R *.dfm}

Uses ResultsF, oEntList;

//--------------------------------------------------------------------------

procedure TfrmWarnings.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := Application.Title;
  ExitMsg := 255;

  If (oSurveyInfo.WarningText.Text = '') Then
    Memo1.Text := 'No problems found'
  Else
    Memo1.Lines.Assign(oSurveyInfo.WarningText);
end;

//--------------------------------------------------------------------------

procedure TfrmWarnings.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;

  If CanClose And (ExitCode = '?') Then Application.MainForm.Close;
end;

//--------------------------------------------------------------------------

procedure TfrmWarnings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  Action := caFree;
end;

//--------------------------------------------------------------------------

procedure TfrmWarnings.NextBtnClick(Sender: TObject);
begin
  inherited;

  TfrmResults.Create(Application.MainForm).Show;
end;

end.
