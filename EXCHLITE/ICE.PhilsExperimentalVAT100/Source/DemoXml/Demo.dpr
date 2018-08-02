program Demo;

{$REALCOMPATIBILITY ON}
{$Align 1}

uses
  Forms,
  uDemo in 'uDemo.pas' {frmXmlFunctions},
  uCommon in '..\Common\uCommon.pas',
  uConsts in '..\Common\uConsts.pas',
  uBaseClass in '..\Common\uBaseClass.pas',
  uCompression in '..\Common\uCompression.pas',
  uCrypto in '..\Common\uCrypto.pas',
  MSXML2_TLB in '..\xml\MSXML2_TLB.pas',
  uXmlBaseClass in '..\Common\uXmlBaseClass.pas',
  uCustExport in '..\Common\uCustExport.pas',
  uExportBaseClass in '..\Common\uExportBaseClass.pas',
  uImportBaseClass in '..\Common\uImportBaseClass.pas',
  uCustImport in '..\Common\uCustImport.pas',
  Demo_TLB in 'Demo_TLB.pas',
  USEDLLU in '..\exchequer\USEDLLU.PAS',
  uEXCHBaseClass in '..\Common\uEXCHBaseClass.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmXmlFunctions, frmXmlFunctions);
  Application.Run;
end.
