program SMSTEST;

uses
  Forms,
  EnterpriseSMS_TLB in '..\CALLCNTR\EnterpriseSMS_TLB.pas',
  main in 'MAIN.PAS' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
