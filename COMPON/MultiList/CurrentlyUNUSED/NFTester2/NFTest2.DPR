program NFTest2;
{$REALCOMPATIBILITY ON}
{$ALIGN 1}
{%File 'Debug.inc'}

uses
  Sharemem,
  Forms,
  Controls,
  MainF in 'Mainf.pas' {frmMain},
  VarConst in 'VARCONST.PAS',
  ToolDetF in 'ToolDetF.pas' {ToolDetails},
  ToolOpt in 'ToolOpt.pas' {ToolsOptions},
  Findcard in 'Findcard.pas' {FrmFindCard},
  PLUDet in 'PLUDet.pas' {FrmPLUDetails},
  FindDlg in 'FindDlg.pas' {FrmFindDlg},
  cardproc in 'cardproc.pas',
  BtKeys1U in 'Btkeys1u.pas',
  startup in 'startup.pas' {FrmStartUp},
  SysSetup in 'SysSetup.pas' {FrmSystemSetup},
  TXDetail in 'TXDetail.pas' {FrmTXDetails},
  Comms in 'Comms.pas' {FrmComms},
  DLLProc in 'DLLProc.pas',
  ExchLink in 'ExchLink.pas',
  about in 'about.pas' {frmAbout},
  LinkList in 'LinkList.pas',
  SaleItem in 'SaleItem.pas',
  DuffTill in 'dufftill.pas',
  AutoEOD in 'AutoEOD.pas' {FrmAutoEOD},
  ClubU in 'clubu.pas',
  Club2Exp in 'Club2exp.pas',
  Club2000 in 'Club2000.pas',
  Reports in 'Reports.pas' {ModReports},
  prntprev in 'Prntprev.pas' {FrmPrintPreview},
  RunRange in 'RunRange.pas' {FrmRunNoRange},
  carddet in 'Carddet.pas' {FrmCardDetails},
  PLUList in 'PLUList.pas' {FrmPLUList},
  ProcFunc in 'ProcFunc.pas' {FrmProcessFunction},
  FuncBook in 'Funcbook.pas' {FrmFunctionList},
  Billdet in 'Billdet.pas' {FrmBillSplitDetails},
  NeilProc in 'E:\DEV\NeilProc.pas',
  HeldCard in 'HeldCard.pas' {FrmHeldCardsList},
  DatRange in 'Datrange.pas' {FrmDateRange},
  Browse in 'Browse.pas' {FrmDirBrowse},
  tillname in 'tillname.pas' {FrmTillNames},
  Tilldet in 'Tilldet.pas' {FrmTillDetails},
  ChngPass in 'ChngPass.pas' {FrmChangePassword},
  BillSplt in 'BillSplt.pas' {FrmBillSplit},
  FuncDet in 'Funcdet.pas' {FrmFunctionDetails},
  progtill in 'progtill.pas' {wizReprogTills},
  Progress in 'Progress.pas' {FrmProgress},
  Eod in 'Eod.pas',
  debuginf in 'debuginf.pas' {FrmDebugInfo},
  messscrn in 'messscrn.pas' {FrmMessageScreen},
  Utils in 'Utils.pas' {FrmUtilities},
  Prntdlg in 'Prntdlg.pas' {PrintDlg},
  Expiry in 'Expiry.pas' {frmReleaseCode},
  HelpSupU in 'Helpsupu.pas',
  VarRec2U in 'varrec2u.pas',
  logview in 'logview.pas' {frmCommslogViewer},
  PrntList in 'PrntList.pas' {FrmPrintCardList},
  MPComms in 'MPCOMMS\Mpcomms.pas',
  debug in 'MPCOMMS\Debug.pas' {FrmMPCommsDebug},
  cmdlist in 'MPCOMMS\Cmdlist.pas' {FrmCommandList},
  message in 'MPCOMMS\Message.pas' {FrmMessage},
  OpenTab in 'OpenTab.pas' {frmOpenTablesRep},
  EntSetup in 'EntSetup.pas' {frmEnterpriseSetup},
  ChkPrntr in 'CHKPRNTR.PAS' {frmInvalidPrinter},
  EOY in 'EOY.pas' {frmEOY},
  SecureU in '..\..\..\ENTRPRSE\R&D\SECUREU.PAS' {SecureFrm},
  cardlist in '\\SBS_SERVER\VOL2\ENT500\COMPON\MultiList\NFTester2\CARDLIST.PAS' {FrmCardList2},
  cardl3 in 'cardl3.pas' {FrmCardList3};

{$R ARROWS.RES}

{$R *.RES}

begin
  Application.Initialize;
  if oDLL.Opened then begin
    Application.Title := 'Exchequer Loyalty';
    Application.HelpFile := 'WINCARD.HLP';
    Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TModReports, ModReports);
  Application.Run;
  end;{if}
end.
