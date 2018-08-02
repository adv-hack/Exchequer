program blowtest;

uses
  Forms,
  frmctest in 'frmctest.pas' {frmCipherTest};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Blowfish Test Application';
  Application.CreateForm(TfrmCipherTest, frmCipherTest);
  Application.Run;
end.
