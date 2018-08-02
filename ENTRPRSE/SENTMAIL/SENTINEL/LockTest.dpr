program LockTest;
{$ALIGN 1}
uses
  Forms,
  LockF in 'LockF.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
