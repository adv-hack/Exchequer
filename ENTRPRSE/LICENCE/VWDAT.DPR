program VwDat;

{$REALCOMPATIBILITY ON}

uses
  Forms,
  VwDatF in 'VwDatF.pas' {Form1},
  Crypto in 'X:\Entrprse\MULTCOMP\Crypto.pas',
  EntLic in 'X:\Entrprse\MULTCOMP\Entlic.pas',
  SerialU in 'X:\Entrprse\MULTCOMP\Serialu.pas',
  DiskUtil in 'X:\Entrprse\FUNCS\Diskutil.pas',
  LicRec in 'X:\SBSLIB\WIN\EXCOMMON\LICREC.PAS',
  LicFuncU in 'X:\SBSLIB\WIN\EXCOMMON\LICFUNCU.PAS',
  LicVar in 'LICVAR.PAS';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'ENTRPRSE.DAT Viewer';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
