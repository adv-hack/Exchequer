program ENDISTRC;

uses
  Forms,
  LoginF in 'LOGINF.PAS' {frmLogin},
  SerialU in '..\..\MULTCOMP\SERIALU.PAS',
  DistRelF in 'DistRelF.pas' {frmMain},
  Contkey in 'CONTKEY.PAS',
  VarRec2U in '..\COMSecO\VARREC2U.PAS',
  oDistLic in 'X:\ENTRPRSE\LICENCE\DISTREL\oDistLic.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Distributor Release Code Utility';
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.
