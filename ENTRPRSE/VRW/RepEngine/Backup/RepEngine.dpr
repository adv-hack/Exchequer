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
  SysUtils,
  Classes,
  RepTreeIF in '..\..\GUIRW\Common\RepTreeIF.pas',
  RepEngIF in '..\..\GUIRW\Common\RepEngIF.pas',
  History in '..\..\GUIRW\Common\History.pas',
  CtrlPrms in '..\..\GUIRW\Common\CtrlPrms.pas',
  GlobalTypes in '..\..\GUIRW\Common\GlobalTypes.pas',
  EntLicence in '..\..\DRILLDN\EntLicence.pas',
  LicRec in '..\..\..\SBSLIB\WIN\EXCOMMON\LicRec.pas',
  SerialU in '..\..\MULTCOMP\SERIALU.PAS',
  EntLic in '..\..\MULTCOMP\ENTLIC.PAS',
  GlobVar in '..\..\R&D\GLOBVAR.PAS',
  Btrvu2 in '..\..\..\SBSLIB\WIN\WIN32\BTRVU2.PAS',
  Crypto in '..\..\MULTCOMP\CRYPTO.PAS',
  LicFuncU in '..\..\..\SBSLIB\WIN\EXCOMMON\LicFuncU.pas',
  VarFPOSU in '..\..\GUIRW\RepEngine\VARFPOSU.PAS',
  VarConst in '..\..\GUIRW\RepEngine\Varconst.pas',
  oRepEngineManager in 'oRepEngineManager.pas',
  oRepTreeSecurity in '..\..\GUIRW\RepEngine\oRepTreeSecurity.pas',
  oRepTree in '..\..\GUIRW\RepEngine\oRepTree.pas',
  RptPersist in '..\..\GUIRW\RepEngine\RptPersist.pas',
  oRepEngine in '..\..\GUIRW\RepEngine\oRepEngine.pas',
  BtSupu2 in '..\..\R&D\Btsupu2.pas',
  BTSupU1 in '..\..\R&D\Btsupu1.pas',
  oRepGenerator in '..\..\GUIRW\RepEngine\oRepGenerator.pas',
  Prntdlg2 in '..\..\GUIRW\RepEngine\PrntDlg2.pas' {PrintDlg},
  CommsInt in '..\..\ENTCOMMS\COMMSINT.PAS',
  CompUtil in '..\..\MULTCOMP\COMPUTIL.PAS',
  FaxIntO in '..\..\FAX\FAXINTO.PAS',
  RWOpenF in '..\..\GUIRW\RepEngine\RWOpenF.pas',
  McmfUNCS in '..\..\MULTCOMP\MCMFUNCS.PAS',
  ENTLIC2 in '..\..\MULTCOMP\ENTLIC2.PAS',
  PrintFrm in '..\..\GUIRW\RepEngine\PRINTFRM.PAS',
  CIS in '..\..\GUIRW\Common\CIS.PAS',
  DbAccessFilter in '..\..\GUIRW\RepEngine\DbAccessFilter.pas',
  prntprev in '..\..\GUIRW\RepEngine\PrntPrev.pas' {Form_PrintPreview},
  VRWReportDataIF in '..\..\GUIRW\Common\VRWReportDataIF.pas',
  VRWReportDataU in 'X:\ENTRPRSE\GUIRW\RepEngine\VRWReportDataU.pas',
  VRWReportIF in '..\Common\VRWReportIF.pas',
  VRWReportU in 'VRWReportU.pas',
  RptEngDll in 'X:\ENTRPRSE\VRW\Common\RptEngDll.pas',
  VRWReportFileU in 'VRWReportFileU.pas',
  HexConverter in 'X:\ENTRPRSE\VRW\RepEngine\HexConverter.pas',
  VRWReportGeneratorU in 'VRWReportGeneratorU.pas';

{$R *.res}

//-------------------------------------------------------------------------

// returns the report engine interface object to the outside world
function GetReportEngine : IReport_Interface;
begin
  Result := RepEngineManager.ReportEngine;
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

//-------------------------------------------------------------------------

// HM 11/03/05: Added independant version for RepEngine.Dll
Function RepEngineDllVer : ShortString;
begin
  Result := RepEngineVer;
end;

//-------------------------------------------------------------------------

Exports
  GetReportEngine,
  GetReportTree,
  RepEngineDllVer,
  GetVRWReportData,
  GetVRWReport;
end.
