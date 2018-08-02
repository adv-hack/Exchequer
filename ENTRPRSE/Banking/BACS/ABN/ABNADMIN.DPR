program AbnAdmin;

uses
  Forms,
  abnconfg in 'ABNCONFG.PAS' {frmAbnConfig};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmAbnConfig, frmAbnConfig);
  Application.Run;
end.
