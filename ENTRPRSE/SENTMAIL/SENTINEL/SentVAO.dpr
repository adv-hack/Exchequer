program SentVAO;

{$REALCOMPATIBILITY ON}

uses
  Sharemem,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  SvcMgr,
  Servmn1 in 'Servmn1.pas' {SentimailService: TService},
  SysUtils,
  Localu in 'Localu.pas',
  VarFPOSU in '..\..\VRW\Common\VARFPOSU.PAS',
  SdiMainf in 'SdiMainf.pas' {frmEngine};

{$R *.RES}

{$R ARROWS.RES}
var
  sParam : string;

begin
  Application.Initialize;
  Application.Title := 'Sentimail Service';
  Application.CreateForm(TSentimailService, SentimailService);
  sParam := UpperCase(ParamStr(1));
  if (sParam <> '/INSTALL') and (sParam <> '/UNINSTALL') then
    Application.CreateForm(TfrmEngine, frmEngine);
  Application.Run;
end.
