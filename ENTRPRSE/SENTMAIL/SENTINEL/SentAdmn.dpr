program SentAdmn;

uses
  Forms,
  WORKSTA2 in 'WORKSTA2.PAS' {frmWorkstationSetup};

{$R *.res}
{$R SentAdXP.Res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmWorkstationSetup, frmWorkstationSetup);
  Application.Run;
end.
