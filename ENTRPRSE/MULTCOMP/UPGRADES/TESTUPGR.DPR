program TestUPGR;

uses
  ShareMem,
  Forms,
  Test1U in 'Test1U.pas' {Form1},
  DLLLinkU in 'DLLLinkU.pas';

{$R *.RES}

{$R W:\Entrprse\FormDes2\WinXPMan.Res}

begin
  Application.Initialize;
  Application.Title := 'Enterprise Upgrade';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
