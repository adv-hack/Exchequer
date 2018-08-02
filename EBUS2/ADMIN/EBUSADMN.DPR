program EBusAdmn;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  DyBkMain,
  TKitUtil in 'TKitUtil.pas',
  EbusLic in '..\SHARED\EbusLic.pas',
  matchlst in 'matchlst.pas' {frmEbusMatchList},
  matchopt in 'matchopt.pas' {frmMatchOptions},
  pinlist in 'pinlist.pas' {frmPINList},
  MainF in 'MAINF.PAS' {frmMain};

{$R ARROWS.RES}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer eBusiness Admin Module';
  Application.HelpFile := 'Ebus.chm';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
