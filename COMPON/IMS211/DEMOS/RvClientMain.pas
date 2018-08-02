{
This is a client application, which works with
RcServer.dpr.  First, recompile the RcServer.dpr and
leave it running.  Then run this applicaiton, enter
any string in the 'String to Send' box, and click
Send button. The server should reverce the
string and return it back.
}
unit RvClientMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mssocket, ComCtrls;

type
  TClientForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    SendButton: TButton;
    CancelButton: TButton;
    Label3: TLabel;
    ResultLabel: TLabel;
    ServerEdit: TEdit;
    DataEdit: TEdit;
    StatusBar: TStatusBar;
    msClientSocket1: TmsClientSocket;
    procedure SendButtonClick(Sender: TObject);
    procedure msClientSocket1Connecting(Sender: TObject);
    procedure msClientSocket1Connected(Sender: TObject);
    procedure msClientSocket1Disconnected(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClientForm: TClientForm;

implementation

{$R *.DFM}

procedure TClientForm.SendButtonClick(Sender: TObject);
begin
  SendButton.Enabled:=false;
  CancelButton.Enabled:=true;
  try
    msClientSocket1.Host:=ServerEdit.Text;
    msClientSocket1.Connect;
    try
      msClientSocket1.SendLine(DataEdit.Text);
      ResultLabel.Caption:=msClientSocket1.RecvLine;
    finally
      msClientSocket1.Disconnect;
    end;
  finally
    SendButton.Enabled:=true;
    CancelButton.Enabled:=false;
  end;
end;

procedure TClientForm.msClientSocket1Connecting(Sender: TObject);
begin
  StatusBar.SimpleText:='Connecting to '+msClientSocket1.Host;
end;

procedure TClientForm.msClientSocket1Connected(Sender: TObject);
begin
  StatusBar.SimpleText:='Connected';
end;

procedure TClientForm.msClientSocket1Disconnected(Sender: TObject);
begin
  StatusBar.SimpleText:='Disconnected';
end;

end.
