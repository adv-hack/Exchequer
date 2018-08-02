program EntDrill;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  ShareMem,
  Forms,
  SetPath in 'SETPATH.PAS',
  MainF in 'MAINF.PAS' {frmMainDebug},
  Enterprise_TLB in 'Enterprise_TLB.pas',
  oDrill in 'ODRILL.PAS' {DrillDown: CoClass},
  EntLicence in 'EntLicence.pas',
  FuncList in 'FuncList.pas',
  FuncParser in 'FuncParser.pas',
  ProcFunc in 'ProcFunc.pas',
  EntData in 'EntData.pas',
  VarConst in '..\MULTCOMP\VARCONST.PAS',
  DispDocF in 'DispDocF.pas' {frmDisplayTransManager},
  EBGLLine in 'EBGLLINE.PAS',
  frmStkAdjU in 'frmStkAdjU.pas' {frmStkAdj},
  VATMatrx in 'VATMatrx.pas',
  PaylineU in 'PAYLINEU.PAS' {PayLine},
  SOPLineF in 'SOPLINEF.PAS' {frmSOPLine},
  MemMap in '..\OLE\MEMMAP.PAS',
  SRCPPYF in 'SRCPPYF.pas' {RecepForm},
  SelDataF in 'SelDataF.pas' {frmSelectData},
  SelDataO in 'SelDataO.pas',
  DDAboutF in 'DDABOUTF.PAS' {frmAbout},
  History in 'History.pas',
  DrillLog in 'DrillLog.pas',
  NomTfrU in 'NOMTFRU.PAS' {NTxfrForm},
  NomLineU in 'NOMLINEU.PAS' {NTLine},
  NomLineF in 'NOMLINEF.PAS' {frmGLLineDrill},
  JobLineF in 'JobLineF.PAS' {frmJobLineDrill},
  JobActlF in 'JobActlF.pas' {frmJobActual},
  JHistDDU in 'JHistDDU.PAS',
  EBJCLine in 'EBJCLine.pas',
  frmStockU in 'frmStockU.pas' {frmStock},
  EBStockLine in 'EBStockLine.pas',
  Recon3U in 'Recon3U.pas',
  SysU2 in '..\R&D\Sysu2.pas',
  DrillConst in 'DrillConst.pas',
  frmCustU in 'frmCustU.pas' {frmCustHistory},
  EBCustLine in 'EBCustLine.pas',
  DrillUtils in 'DrillUtils.pas',
  frmAdjLineU in 'frmAdjLineU.pas' {frmAdjLine},
  frmTimeSheetU in 'frmTimeSheetU.pas' {frmTimeSheet},
  frmTimeSheetEntryU in 'frmTimeSheetEntryU.pas' {frmTimeSheetEntry},
  frmWorksOrderU in 'frmWorksOrderU.PAS' {frmWorksOrder},
  frmWorksOrderEntryU in 'frmWorksOrderEntryU.PAS' {frmWorksOrderEntry},
  TranSOPF in 'TRANSOPF.PAS' {frmSOPTrans},
  CustomFieldsIntf in '..\R&D\CustomFieldsIntf.pas',
  PromptPaymentDiscountFuncs in '..\Funcs\PromptPaymentDiscountFuncs.pas';


{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  {$IFNDEF DRILLDEBUG}
    Application.ShowMainForm := False;
  {$ENDIF} // DRILLDEBUG
  Application.Title := 'Exchequer Drill-Down Add-In';
  Application.CreateForm(TfrmMainDebug, frmMainDebug);
  Application.Run;
end.
