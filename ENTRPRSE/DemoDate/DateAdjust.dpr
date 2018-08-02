program DateAdjust;

uses
  Forms,
  ajdustf in 'X:\ENTRPRSE\DemoDate\ajdustf.pas' {frmDateAdjust};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmDateAdjust, frmDateAdjust);
  Application.Run;
end.
