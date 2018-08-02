program Ftpdemo;

uses
  Forms,
  Ftpmain in 'FTPMAIN.PAS' {FTPForm},
  Ftpconn in 'FTPCONN.PAS' {FTPConnectDlg},
  msabout in 'MSABOUT.PAS' {AboutDlg},
  ftptrans in 'ftptrans.pas' {TransferForm};

{$R *.RES}

begin
  Application.CreateForm(TFTPForm, FTPForm);
  Application.CreateForm(TTransferForm, TransferForm);
  Application.Run;
end.
