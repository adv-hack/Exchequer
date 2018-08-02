program ConnStringEditor;

uses
  Forms,
  main in 'main.pas' {mainform},
  FileProcess in 'FileProcess.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tmainform, mainform);
  Application.Run;
end.
