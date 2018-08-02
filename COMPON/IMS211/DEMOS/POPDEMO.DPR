program popdemo;

uses
  Forms,
  popmain in 'popmain.pas' {PopForm},
  popview in 'popview.pas' {MsgViewDlg},
  msabout in 'msabout.pas' {AboutDlg},
  popsu in 'popsu.pas' {SetupDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TPopForm, PopForm);
  Application.Run;
end.
