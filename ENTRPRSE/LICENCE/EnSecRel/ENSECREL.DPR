program EnSecRel;

uses
  Forms,
  LoginF in 'LoginF.PAS' {frmLogin},
  SerialU in '..\..\MULTCOMP\SERIALU.PAS',
  MainF in 'MainF.pas' {frmMain},
  Contkey in '..\..\..\BESPOKE\EXCHEQR\CONTACTS\DLLHOOK\CONTKEY.PAS',
  VarRec2U in 'x:\ENTRPRSE\LICENCE\COMSecO\VARREC2U.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
