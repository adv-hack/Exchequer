library RepEngine;

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
  RepTreeIF in '..\..\Common\RepTreeIF.pas',
  RepEngIF in '..\..\Common\RepEngIF.pas',
  CtrlPrms in '..\..\Common\CtrlPrms.pas',
  EntLicence in '..\..\..\DRILLDN\EntLicence.pas',
  LicRec in '..\..\..\..\SBSLIB\WIN\EXCOMMON\LicRec.pas',
  SerialU in '..\..\..\MULTCOMP\SERIALU.PAS',
  EntLic in '..\..\..\MULTCOMP\ENTLIC.PAS',
  GlobVar in '..\..\..\R&D\GLOBVAR.PAS',
  Btrvu2 in '..\..\..\..\SBSLIB\WIN\WIN32\BTRVU2.PAS',
  Crypto in '..\..\..\MULTCOMP\CRYPTO.PAS',
  LicFuncU in '..\..\..\..\SBSLIB\WIN\EXCOMMON\LicFuncU.pas',
  VARFPOSU in '..\..\Common\VARFPOSU.PAS',
  VarConst in '..\VarConst.pas',
  oRepTreeSecurity in '..\oRepTreeSecurity.pas',
  oRepTree in '..\oRepTree.pas',
  RptPersist in '..\RptPersist.pas',
  BtSupu2 in '..\..\..\R&D\Btsupu2.pas',
  BTSupU1 in '..\..\..\R&D\Btsupu1.pas',
  PrntDlg2 in '..\PrntDlg2.pas' {PrintDlg},
  CommsInt in '..\..\..\ENTCOMMS\COMMSINT.PAS',
  CompUtil in '..\..\..\MULTCOMP\COMPUTIL.PAS',
  FaxIntO in '..\..\..\FAX\FAXINTO.PAS',
  McmfUNCS in '..\..\..\MULTCOMP\MCMFUNCS.PAS',
  ENTLIC2 in '..\..\..\MULTCOMP\ENTLIC2.PAS',
  PrntPrev in '..\PrntPrev.pas' {Form_PrintPreview},
  VRWReportDataIF in '..\..\Common\VRWReportDataIF.pas',
  RptEngDll in '..\..\Common\RptEngDll.pas',
  HexConverter in '..\HexConverter.pas',
  Globtype in '..\..\..\FORMDES2\Globtype.pas',
  frmVRWRangeFilterDetailsU in '..\..\Common\frmVRWRangeFilterDetailsU.pas' {frmVRWRangeFilterDetails},
  VRWReportIF in '..\..\Common\VRWReportIF.pas',
  VRWReportFileU in '..\VRWReportFileU.pas',
  VRWReportGeneratorU in '..\VRWReportGeneratorU.pas',
  VRWReportU in '..\VRWReportU.pas',
  oRepEngineManager in '..\oRepEngineManager.pas',
  VRWConverterIF in '..\..\Common\VRWConverterIF.pas',
  VRWConverterU in '..\VRWConverterU.pas',
  VRWClipboardManagerU in '..\VRWClipboardManagerU.pas',
  VRWClipboardManagerIF in '..\..\Common\VRWClipboardManagerIF.pas',
  VRWPreviewFormManagerU in '..\VRWPreviewFormManagerU.pas',
  GlobalTypes in '..\..\Common\GlobalTypes.pas',
  frmVRWRangeFiltersU in '..\..\Common\frmVRWRangeFiltersU.pas' {frmVRWRangeFilters},
  History in '..\..\Common\History.pas',
  RwOpenF in '..\..\Common\RWOPENF.PAS',
  RWRIntF in '..\..\RWReader\RWRIntF.pas',
  VRWReportDataU in '..\VRWReportDataU.pas',
  PrintFrm in '..\PRINTFRM.PAS',
  FrmThrdU in '..\FrmThrdU.pas',
  dbfutil in '..\DBFutil.PAS',
  RWPrintR in '..\RWPRINTR.PAS',
  VRWPaperSizesIF in '..\..\Common\VRWPaperSizesIF.pas',
  VRWPaperSizesU in '..\VRWPaperSizesU.pas',
  EmlDetsF in '..\EmlDetsF.pas' {frmEmailDets};

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
    SavedScreen := Screen;
    Screen      := Scr;
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
