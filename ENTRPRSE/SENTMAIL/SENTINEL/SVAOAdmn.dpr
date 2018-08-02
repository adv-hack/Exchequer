program SVAOAdmn;

uses
  Forms,
  WORKSTA2 in 'X:\ENTRPRSE\SENTMAIL\SENTINEL\WORKSTA2.PAS' {frmWorkstationSetup};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmWorkstationSetup, frmWorkstationSetup);
  Application.Run;
end.
