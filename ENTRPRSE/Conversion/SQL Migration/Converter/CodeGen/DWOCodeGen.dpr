program DWOCodeGen;

uses
  Forms,
  MainF in 'MainF.pas' {Form1},
  SQLCallerU in '..\..\..\..\FUNCS\SQLCallerU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
