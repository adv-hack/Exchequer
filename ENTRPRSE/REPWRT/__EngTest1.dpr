program EngTest1;

uses
  Forms,
  gt1 in 'gt1.pas' {frmGuiTest},
  GuiVar in 'GuiVar.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmGuiTest, frmGuiTest);
  Application.Run;
end.
