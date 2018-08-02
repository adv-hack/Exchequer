program EbusExp;
{$REALCOMPATIBILITY ON}
uses
  ShareMem,
  Forms,
  Windows,
  SysUtils,
  Dialogs,
  APIUtil,
  Export in 'Export.pas' {frmeBisExport},
  About in 'About.pas' {frmAbout},
  expman in 'expman.pas' {FrmExportManager},
  ExpWiz in 'ExpWiz.pas' {frmExportWizard},
  CSVUtils in 'CSVUtils.pas',
  csvmapst in 'csvmapst.pas' {frmCSVMapStart},
  dragutil in 'dragutil.pas',
  startup in 'startup.pas',
  EBusBtrv in '..\Shared\Ebusbtrv.pas',
  Ebuscnst in '..\Shared\Ebuscnst.pas',
  Ebusutil in '..\Shared\Ebusutil.pas',
  EBusVar in '..\Shared\Ebusvar.pas',
  DragStk in 'Dragstk.pas',
  IOUtil in 'Ioutil.pas',
  ExptProg in 'Exptprog.pas' {frmExportProgress},
  ExprtCSV in 'Exprtcsv.pas',
  FieldSel in 'Fieldsel.pas' {frmFieldSelect},
  RunExp in 'RunExp.pas',
  DragCust in 'Dragcust.pas',
  FTP in 'FTP.pas' {frmFTP},
  FileSel in 'Filesel.pas' {FrmSelectMapFile},
  filelock in 'filelock.pas' {frmFileLocking},
  XMLCust in '..\xml\XMLCust.pas',
  XMLStock in '..\xml\XMLStock.pas',
  CopyExp in 'CopyExp.pas' {FrmCopyExport},
  FTPLog in 'FTPLog.pas' {FrmFTPLog},

  // MH 14/07/2015 v7.0.14: Added as the new XMLFuncs.pas in Entrprse\Funcs was being picked up instead
  XMLFuncs in '\EBus2\XMLDLL\XMLFuncs.pas';

{$R *.RES}

begin
  Application.ShowMainForm := false;
  IsLibrary := False;
  Application.Title := 'Exchequer eBis Export Module';
  Application.HelpFile := 'ebus.hlp';
  if not IsAppAlreadyRunning(ExtractFileName(Application.EXEName))then begin
    Application.CreateForm(TfrmeBisExport, frmeBisExport);
  Application.Run;
  end;{if}
end.


