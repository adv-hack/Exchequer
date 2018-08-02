program EnPlugIn;

uses
  ShareMem,
  Forms,
  SETUPBAS in 'W:\Entrprse\Setup\SETUPBAS.PAS' {SetupTemplate},
  EDITDLG in 'EDITDLG.PAS' {CustomControl};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'EnPlugIn';
  Application.CreateForm(TCustomControl, CustomControl);
  Application.Run;
end.
