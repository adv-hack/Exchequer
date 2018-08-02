program EDFReadr;

uses
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  ViewEDF in 'VIEWEDF.PAS' {Form1},
  StrUtil in 'X:\ENTRPRSE\FUNCS\STRUTIL.PAS';

{$R *.RES}
{$R X:\Entrprse\FormDes2\WinXPMan.Res}

begin
  Application.Initialize;
  { CJS - 2013-07-08 - ABSEXCH-14438 - update branding and copyright }
  Application.Title := 'Exchequer EDF/EDZ Reader';
  Application.HelpFile := 'EDFREADR.CHM';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
