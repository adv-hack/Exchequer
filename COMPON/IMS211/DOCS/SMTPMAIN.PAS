unit smtpmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, msmsg, Mssocket, msSmtp;

type
  TForm1 = class(TForm)
    msSMTPClient1: TmsSMTPClient;
    msMessage1: TmsMessage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    HostEdit: TEdit;
    SenderEdit: TEdit;
    RecipientEdit: TEdit;
    BodyMemo: TMemo;
    SendButton: TButton;
    procedure SendButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SendButtonClick(Sender: TObject);
begin
  msSMTPClient1.Host:=ServerEdit.Text;
  msMessage1.Clear;
  msMessage1.Sender.Address:=SenderEdit.Text;
  msMessage1.Recipients.AddAddress(RecipientEdit.Text,'');
  msMessage1.Body:=BodyMemo.Lines;
  msSMTP1.Send;
end;

end.
