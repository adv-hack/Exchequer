program D6Client;

uses
  Forms,
  MainF in 'MainF.pas' {Form3},
  EnterpriseTC_TLB in 'EnterpriseTC_TLB.pas',
  oClient in 'OCLIENT.PAS' {D6Client: CoClass},
  ConfigF in 'ConfigF.pas' {frmPlugInconfiguration};

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainform := False;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
