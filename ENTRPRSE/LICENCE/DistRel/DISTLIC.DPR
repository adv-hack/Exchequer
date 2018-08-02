program DistLic;

uses
  Forms,
  LicenceF in 'LicenceF.pas' {Form1},
  oDistLic in 'oDistLic.pas',
  Crypto in 'X:\ENTRPRSE\MULTCOMP\CRYPTO.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Distributor Release Code Utility Licence Generator v1.04';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
