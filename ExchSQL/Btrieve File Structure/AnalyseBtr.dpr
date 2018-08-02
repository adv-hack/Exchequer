program AnalyseBtr;

uses
  Forms,
  AnalyseF in 'AnalyseF.pas' {Form1},
  oBtrieveFile in 'X:\ENTRPRSE\Conversion\v600 Converter\oBtrieveFile.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
