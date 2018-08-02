program Index;

uses
  Forms,
  IndexForm in 'IndexForm.pas' {Form1},
  IdxObj in 'IdxObj.pas',
  ErrorLogForm in 'ErrorLogForm.pas' {frmErrorLog};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
