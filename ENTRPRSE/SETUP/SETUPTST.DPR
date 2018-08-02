program SetupTst;

uses
  Forms,
  setupts2 in 'setupts2.pas' {Form1},
  SetupBas in 'SetupBas.pas' {SetupTemplate},
  setupdir in 'setupdir.pas' {DirectoryDialog},
  DiskU in '\ENTRPRSE\R&D\DiskU.pas',
  FindDlg in 'FindDlg.pas' {frmFindDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.HelpFile := 'ENTREAD.HLP';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
