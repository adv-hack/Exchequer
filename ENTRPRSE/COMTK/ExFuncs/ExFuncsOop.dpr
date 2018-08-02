program ExFuncsOop;

uses
  Forms,
  mainf in 'mainf.pas' {Form1},
  ExFuncsOop_TLB in 'ExFuncsOop_TLB.pas',
  oOopFunc in 'oOopFunc.pas' {ExchquerFunctions: CoClass};

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
