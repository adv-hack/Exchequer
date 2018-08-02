program CheckPlugIns;

uses
  Forms,
  MainF in 'MainF.pas' {Form1},
  CheckForPlugIns in 'CheckForPlugIns.pas',
  VAOUtil in 'X:\ENTRPRSE\FUNCS\VAOUtil.pas',
  PlugInFrame in 'PlugInFrame.pas' {SinglePlugInFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer v6.00 Plug-Ins';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
