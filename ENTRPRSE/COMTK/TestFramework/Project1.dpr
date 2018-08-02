program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  SQLCallerU in '..\..\..\ExchSQL\BtrvSQL\SQLCallerU.pas',
  CompareIntf in 'CompareIntf.pas',
  CompareSQLU in 'CompareSQLU.pas',
  CompareIniFile in 'CompareIniFile.pas',
  CompareSQLDb in 'CompareSQLDb.pas',
  FrameworkUtils in 'FrameworkUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
