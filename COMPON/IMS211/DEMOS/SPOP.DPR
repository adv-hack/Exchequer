program spop;

uses
  Forms,
  spopmain in 'spopmain.pas' {SelForm},
  spopsu in 'spopsu.pas' {SPOPSetupDlg},
  popview in 'popview.pas' {MsgViewDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TSelForm, SelForm);
  Application.Run;
end.
