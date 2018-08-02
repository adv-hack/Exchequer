unit SendF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, ExtCtrls, StdCtrls;

type
  TfrmSendSurvey = class(TSetupTemplate)
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NextBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

//--------------------------------------------------------------------------

procedure TfrmSendSurvey.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := Application.Title;
  ExitMsg := 255;
end;

//--------------------------------------------------------------------------

procedure TfrmSendSurvey.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;

  If CanClose And (ExitCode = '?') Then Application.MainForm.Close;
end;

//--------------------------------------------------------------------------

procedure TfrmSendSurvey.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  Action := caFree;
end;

//--------------------------------------------------------------------------

procedure TfrmSendSurvey.NextBtnClick(Sender: TObject);
begin
  inherited;
  Application.MainForm.Close;
end;

end.
