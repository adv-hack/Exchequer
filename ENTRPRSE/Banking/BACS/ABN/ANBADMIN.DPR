program AnbAdmin;

uses
  Forms,
  abnconfg in 'abnconfg.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmAbnConfig, frmAbnConfig);
  Application.Run;
end.
