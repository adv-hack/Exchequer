program SortViews;

uses
  Forms,
  SortViewOptionsF in 'SortViewOptionsF.pas' {Form1},
  SortViewConfigurationF in 'SortViewConfigurationF.pas' {Form2};

{$R *.res}

{$R x:\entrprse\formdes2\winxpman.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
