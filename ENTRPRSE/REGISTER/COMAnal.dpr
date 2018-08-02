program COMAnal;

uses
  Forms,
  ComAnalF in 'ComAnalF.pas' {frmCOMRegAnal};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer COM Object Analysis v11';
  Application.CreateForm(TfrmCOMRegAnal, frmCOMRegAnal);
  Application.Run;
end.
