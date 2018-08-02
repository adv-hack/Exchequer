program NFMANAG;

{$REALCOMPATIBILITY ON}

uses
  Forms,
  ElManF in 'ElManF.pas' {frmELManager},
  elRepDel in 'elRepDel.pas' {frmRepDelivery},
  debuglog in 'debuglog.pas',
  thingU in 'thingU.pas',
  Sentu in 'Sentu.pas',
  SentEx1u in 'SentEx1u.pas',
  smsedit in 'smsedit.pas' {frmEditSMS},
  testu in 'testu.pas' {frmTestOutput},
  emailed in 'emailed.pas' {frmEmailEdit},
  WORKSTAT in 'WORKSTAT.PAS' {frmWorkstationSetup};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Sentimail Sentinel Manager';
  Application.CreateForm(TfrmELManager, frmELManager);
  Application.CreateForm(TfrmEmailEdit, frmEmailEdit);
  Application.CreateForm(TfrmWorkstationSetup, frmWorkstationSetup);
  Application.Run;
end.
