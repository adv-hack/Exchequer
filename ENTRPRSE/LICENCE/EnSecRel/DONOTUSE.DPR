program DONOTUSE;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  Forms,
  MainFrmU in 'MainFrmU.pas' {Form1},
  ESNImpU in '..\Esnimpu.pas',
  SecVarU in 'SecVarU.pas',
  LicRec in '..\..\..\SBSLIB\WIN\EXCOMMON\Licrec.pas',
  SecUtilU in 'SecUtilU.pas',
  RSyncU in '..\..\MULTCOMP\RSYNCU.PAS',
  APIUtil in '..\..\FUNCS\APIUTIL.PAS',
  DiskUtil in 'X:\ENTRPRSE\FUNCS\DISKUTIL.PAS';

{$R *.RES}
{$R X:\Entrprse\FormDes2\WinXPMan.Res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Security Release Code Utility';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
