program CISIncoming;

uses
  SvcMgr,
  uCISIncoming in 'uCISIncoming.pas' {CISService: TService},
  CISIncoming_TLB in 'CISIncoming_TLB.pas',
  uCISCallback in 'uCISCallback.pas' {CISCallBack: CoClass},
  uDSRSettings in 'X:\EXCHLITE\ICE\Source\DSR\uDSRSettings.pas';

{$R *.TLB}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'CIS Incoming Service';
  Application.CreateForm(TCISService, CISService);
  Application.Run;
end.
