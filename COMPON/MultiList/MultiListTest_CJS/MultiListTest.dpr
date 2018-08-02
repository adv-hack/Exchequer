program MultiListTest;

uses
  Forms,
  MainFrmU in 'MainFrmU.pas' {Form1},
  uSQLDatasets in '..\DevComp\ExDatasets\uSQLDatasets.pas',
  uBTGlobalDataset in '..\DevComp\ExDatasets\uBTGlobalDataset.pas',
  uBtrieveDataset in '..\DevComp\ExDatasets\uBtrieveDataset.pas',
  uComTKDataset in '..\DevComp\ExDatasets\uComTKDataset.pas',
  uExDatasets in '..\DevComp\ExDatasets\uExDatasets.pas',
  uDBMultiList in '..\DevComp\uDBMultiList.pas',
  uMultiList in '..\DevComp\uMultiList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
