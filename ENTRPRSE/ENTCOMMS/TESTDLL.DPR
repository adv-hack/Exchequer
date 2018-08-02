program TestDLL;

uses
  ShareMem,
  Forms,
  TestF in 'TestF.pas' {Form1},
  CommsInt in 'Commsint.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'ENTCOMMS.DLL Testing Utility';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
