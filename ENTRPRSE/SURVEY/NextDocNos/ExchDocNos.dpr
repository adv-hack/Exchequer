program ExchDocNos;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

uses
  Forms,
  DocNoReportF in 'DocNoReportF.pas', {frmDocumentNumbersReport}
  oScanCompanies in 'oScanCompanies.pas',
  History in 'History.pas',
  Brand in '\ENTRPRSE\FUNCS\Brand.pas',
  oBtrieveFile in '\Entrprse\MultComp\oBtrieveFile.pas',
  oExchqNumFile in 'oExchqNumFile.pas',
  XMLFuncs in '\Entrprse\Funcs\XMLFuncs.pas';

{$R *.res}

{$R w:\Entrprse\FormDes2\WinXPMan.res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Document Numbers Report';
  Application.CreateForm(TfrmDocumentNumbersReport, frmDocumentNumbersReport);
  Application.Run;
end.
