unit ChatMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mssocket;

type
  TChatForm = class(TForm)
    ChatMemo: TMemo;
    Label1: TLabel;
    ComputerNameEdit: TEdit;
    Label2: TLabel;
    DataStringEdit: TEdit;
    SendButton: TButton;
    LS: TmsListenerSocket;
    CS: TmsClientSocket;
    procedure SendButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChatForm: TChatForm;

implementation

{$R *.DFM}

type
  TChatServerThread = class(TmsServerThread)
  private
    FLine: string;
    procedure AddToChatMemo;
  protected
    procedure Execute; override;
  end;

procedure TChatserverThread.AddToChatMemo;
begin
  ChatForm.ChatMemo.Lines.Add(FLine);
  ChatForm.ComputerNameEdit.Text:=Peer;
end;

procedure TChatServerThread.Execute;
begin
  try
    FLine:=ServerSocket.RecvLine;
    Synchronize(AddToChatMemo);
  finally
    ServerSocket.Disconnect;
  end;
end;

procedure TChatForm.SendButtonClick(Sender: TObject);
begin
  CS.Host:=ComputerNameEdit.Text;
  CS.Connect;
  try
    CS.SendLine(DataStringEdit.Text);
    ChatMemo.Lines.Add(DataStringEdit.Text);
  finally
    CS.Disconnect;
  end;
end;

procedure TChatForm.FormCreate(Sender: TObject);
begin
  LS.Start;
  LS.ServerThreadClass:=TChatServerThread;
end;

procedure TChatForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LS.Stop;
end;

end.
