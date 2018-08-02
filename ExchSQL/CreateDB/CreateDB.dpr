program CreateDB;

uses
  Forms,
  MainF in 'MainF.pas' {Form1},
  AddRec in 'AddRec.pas',
  GLF in 'GLF.pas' {frmGLs};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmGLs, frmGLs);
  Application.Run;
end.
