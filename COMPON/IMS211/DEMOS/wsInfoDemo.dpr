program wsInfoDemo;

uses
  Forms,
  wsinfo in 'Wsinfo.pas' {WSInfoDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TWSInfoDlg, WSInfoDlg);
  Application.Run;
end.
