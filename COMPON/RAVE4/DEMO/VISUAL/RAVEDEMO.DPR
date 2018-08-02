program RaveDemo;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  DM in 'DM.pas' {DataModule2: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule2, DataModule2);
  Application.Run;
end.
