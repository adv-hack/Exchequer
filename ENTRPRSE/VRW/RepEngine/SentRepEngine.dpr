library SentRepEngine;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  ShareMem,
  Forms,
  SysUtils,
  Classes,
  RepTreeIF in '..\Common\RepTreeIF.pas',
  RepEngIF in '..\Common\RepEngIF.pas',
  CtrlPrms in '..\Common\CtrlPrms.pas',
  EntLicence in 'W:\ENTRPRSE\DRILLDN\EntLicence.pas',
  LicRec in 'W:\SBSLIB\WIN\EXCOMMON\LicRec.pas',
  SerialU in 'W:\ENTRPRSE\MULTCOMP\SERIALU.PAS',
  EntLic in 'W:\ENTRPRSE\MULTCOMP\ENTLIC.PAS',
  GlobVar in 'W:\ENTRPRSE\R&D\GLOBVAR.PAS',
  Btrvu2 in 'W:\SBSLIB\WIN\WIN32\BTRVU2.PAS',
  Crypto in 'W:\ENTRPRSE\MULTCOMP\CRYPTO.PAS',
  LicFuncU in 'W:\SBSLIB\WIN\EXCOMMON\LicFuncU.pas',
  VARFPOSU in '..\Common\VARFPOSU.PAS',
  VarConst in 'VarConst.pas',
  oRepTreeSecurity in 'oRepTreeSecurity.pas',
  oRepTree in 'oRepTree.pas',
  RptPersist in 'RptPersist.pas',
  BtSupu2 in 'W:\ENTRPRSE\R&D\Btsupu2.pas',
  BTSupU1 in 'W:\ENTRPRSE\R&D\Btsupu1.pas',
  PrntDlg2 in 'PrntDlg2.pas' {PrintDlg},
  CommsInt in 'W:\ENTRPRSE\ENTCOMMS\COMMSINT.PAS',
  CompUtil in 'W:\ENTRPRSE\MULTCOMP\COMPUTIL.PAS',
  FaxIntO in 'W:\ENTRPRSE\FAX\FAXINTO.PAS',
  McmfUNCS in 'W:\ENTRPRSE\MULTCOMP\MCMFUNCS.PAS',
  ENTLIC2 in 'W:\ENTRPRSE\MULTCOMP\ENTLIC2.PAS',
  PrntPrev in 'PrntPrev.pas' {Form_PrintPreview},
  VRWReportDataIF in '..\Common\VRWReportDataIF.pas',
  RptEngDll in '..\Common\RptEngDll.pas',
  HexConverter in 'HexConverter.pas',
  Globtype in 'W:\ENTRPRSE\FORMDES2\Globtype.pas',
  frmVRWRangeFilterDetailsU in '..\Common\frmVRWRangeFilterDetailsU.pas' {frmVRWRangeFilterDetails},
  VRWReportIF in '..\Common\VRWReportIF.pas',
  VRWReportFileU in 'VRWReportFileU.pas',
  VRWReportGeneratorU in 'VRWReportGeneratorU.pas',
  VRWReportU in 'VRWReportU.pas',
  oRepEngineManager in 'oRepEngineManager.pas',
  VRWConverterIF in '..\Common\VRWConverterIF.pas',
  VRWConverterU in 'VRWConverterU.pas',
  VRWClipboardManagerU in 'VRWClipboardManagerU.pas',
  VRWClipboardManagerIF in '..\Common\VRWClipboardManagerIF.pas',
  VRWPreviewFormManagerU in 'VRWPreviewFormManagerU.pas',
  GlobalTypes in '..\Common\GlobalTypes.pas',
  frmVRWRangeFiltersU in '..\Common\frmVRWRangeFiltersU.pas' {frmVRWRangeFilters},
  History in '..\Common\History.pas',
  RwOpenF in '..\Common\RWOPENF.PAS',
  RWRIntF in '..\RWReader\RWRIntF.pas',
  VRWReportDataU in 'VRWReportDataU.pas',
  PrintFrm in 'PRINTFRM.PAS',
  FrmThrdU in 'FrmThrdU.pas',
  dbfutil in 'DBFutil.PAS',
  RWPrintR in 'RWPRINTR.PAS',
  VRWPaperSizesIF in '..\Common\VRWPaperSizesIF.pas',
  VRWPaperSizesU in 'VRWPaperSizesU.pas',
  EmlDetsF in 'EmlDetsF.pas' {frmEmailDets},
  ExScreen in 'W:\ENTRPRSE\FORMDES2\ExScreen.pas',
  AccountContactRoleUtil in 'w:\ENTRPRSE\R&D\AccountContacts\AccountContactRoleUtil.pas',
  ContactsManager in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManager.pas',
  oAccountContactBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactBtrieveFile.pas',
  oAccountContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactRoleBtrieveFile.pas',
  oContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oContactRoleBtrieveFile.pas',
  ContactsManagerPerv in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerPerv.pas',
  ContactsManagerSQL in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerSQL.pas',

  oOPVatPayBtrieveFile in 'W:\ENTRPRSE\R&D\OrderPayments\oOPVatPayBtrieveFile.pas',
  oOPPreviousVATTracker in 'W:\ENTRPRSE\FormDes2\oOPPreviousVATTracker.pas',
  zexmlss in 'w:\COMPON\zexmlss\src\zexmlss.pas';

  

{$R *.res}

//-------------------------------------------------------------------------

// returns the report engine interface object to the outside world
function GetReportEngine : IReport_Interface;
begin
  Result := nil;  //RepEngineManager.ReportEngine;
end;
//-------------------------------------------------------------------------

function GetReportTree : IReportTree_Interface;
begin
  Result := RepEngineManager.ReportTree;
end;

//-------------------------------------------------------------------------

function GetVRWReportData : IVRWReportData;
begin
  Result := RepEngineManager.VRWReportData;
end;

//-------------------------------------------------------------------------

function GetVRWReport: IVRWReport;
begin
  Result := RepEngineManager.VRWReport;
end;

function GetVRWConverter: IVRWConverter;
begin
  Result := RepEngineManager.VRWConverter;
end;

//-------------------------------------------------------------------------

procedure ClosePreviewWindows;
begin
  PreviewFormManager.CloseAll;
end;

//-------------------------------------------------------------------------

// HM 11/03/05: Added independant version for RepEngine.Dll
Function RepEngineDllVer : ShortString;
begin
  Result := RepEngineVer;
end;

//-------------------------------------------------------------------------

procedure InitPreview(App: TApplication; Scr: TScreen);
begin
  if SavedApplication = nil then
  begin
    SavedApplication := Application;
    Application      := App;
  end;
  if SavedScreen = nil then
  begin
//    SavedScreen := Screen;
//    Screen      := Scr;
  end;
end;

//-------------------------------------------------------------------------

Exports
  GetReportEngine,
  GetReportTree,
  RepEngineDllVer,
  GetVRWReportData,
  GetVRWReport,
  GetVRWConverter,
  InitPreview,
  ClosePreviewWindows;

end.
