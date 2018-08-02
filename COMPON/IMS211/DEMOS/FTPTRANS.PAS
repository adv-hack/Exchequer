unit ftptrans;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TTransferForm = class(TForm)
    ProgressBar1: TProgressBar;
    CancelButton: TButton;
    Label1: TLabel;
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowProgress(Received, Total : LongInt);
  end;

var
  TransferForm: TTransferForm;

implementation

{$R *.DFM}

uses
  FtpMain;

procedure TTransferForm.ShowProgress(Received, Total : LongInt);
begin
  if Total<>-1 then
  begin
    Label1.Caption:=IntToStr(Received)+' of '+IntToStr(Total)+
      ' bytes transferred...';
    if Total<>0 then
      ProgressBar1.Position:=Round(100*Received/Total)
    else
      ProgressBar1.Position:=0;
  end
  else
  begin
    Label1.Caption:=IntToStr(Received)+' bytes received';
    ProgressBar1.Position:=0;
  end;
end;

procedure TTransferForm.CancelButtonClick(Sender: TObject);
begin
  Hide;
  FTPForm.msFTPClient1.CancelDataTransfer;
end;

end.
