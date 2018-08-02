program VRWCOM;

uses
  Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  VRWCOM_TLB in 'VRWCOM_TLB.pas',
  VRWCOMIF in 'VRWCOMIF.pas' {ReportTree: CoClass},
  RepTreeIF in '..\..\VRW\Common\RepTreeIF.pas',
  VRWReportIF in '..\..\VRW\Common\VRWReportIF.pas',
  VRWRawBMPStore in '..\..\VRW\Common\VRWRawBMPStore.pas',
  CtrlPrms in '..\..\VRW\Common\CtrlPrms.pas',
  Globtype in '..\..\FORMDES2\GLOBTYPE.PAS',
  VRWPaperSizesIF in '..\..\VRW\Common\VRWPaperSizesIF.pas',
  ReportProgress in 'ReportProgress.pas' {frmReportProgress},
  VRWReportDataIF in '..\..\VRW\Common\VRWReportDataIF.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
