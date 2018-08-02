program TestDLL;

uses
  Forms,
  TestDLLForm in 'TestDLLForm.pas' {Form7},
  IRISLicenceDLL in 'IRISLicenceDLL.pas';

{$R *.res}

begin
  Application.Initialize;
//  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm7, Form7);
  Application.Run;
end.
