program PrdSetup;

uses
  Forms,
  PerView in 'PerView.pas' {frmPeriodList},
  PerSet in 'PerSet.pas' {frmPeriodSet},
  AutoFill in 'AutoFill.pas' {frmAutoFill},
  About in 'about.pas' {AboutBox};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPeriodList, frmPeriodList);
  Application.CreateForm(TfrmPeriodSet, frmPeriodSet);
  Application.CreateForm(TfrmAutoFill, frmAutoFill);
  Application.Run;
end.
