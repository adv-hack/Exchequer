program nntpdemo;

uses
  Forms,
  nntpmain in 'nntpmain.pas' {NNTPForm},
  nntppst in 'nntppst.pas' {ArticleForm},
  popview in 'popview.pas' {MsgViewDlg},
  msabout in 'msabout.pas' {AboutDlg},
  nntpsu in 'nntpsu.pas' {SetupDlg},
  nntplst in 'nntplst.pas' {NGListDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TNNTPForm, NNTPForm);
  Application.Run;
end.
