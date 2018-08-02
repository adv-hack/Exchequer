unit ermtest;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, MailPoll,
  MsgTest, StdCtrls, ComCtrls;

type
  TfrmPollTest = class(TForm)
    Start: TButton;
    Stop: TButton;
    Label1: TLabel;
    Label2: TLabel;
    edtServer: TEdit;
    edtUser: TEdit;
    edtPassword: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtFreq: TEdit;
    Label6: TLabel;
    UpDown1: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure StartClick(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    dmPoll : TEmailPoller;
    procedure ShowMessage(const Sender, Subject : ShortString;
                               Text : PChar);
    procedure ShowSomeProgress(Secs : longint);
    procedure Status(const Msg : ShortString);
  public
    { Public declarations }
  end;

var
  frmPollTest: TfrmPollTest;

implementation

{$R *.DFM}

procedure TfrmPollTest.ShowMessage(const Sender, Subject : ShortString;
                                                    Text : PChar);
begin
  with tfrmMsg.Create(Application) do
  begin
    Try
      lblSender.Caption := Sender;
      lblSubject.Caption := Subject;
      memMsg.Lines.SetText(Text);
      ShowModal;
    Finally
      Free;
    end;
  end;
end;


procedure TfrmPollTest.FormCreate(Sender: TObject);
begin
  dmPoll := TEmailPoller.Create;
end;

procedure TfrmPollTest.StartClick(Sender: TObject);
begin
  with dmPoll do
  begin
    POP3Server := edtServer.Text;
    Pop3UserName := edtUser.Text;
    Pop3Password := edtPassword.Text;
    OnGetMessage := ShowMessage;
    OnCheckTimer := ShowSomeProgress;
    OnStatus := Status;
    EmailType := emlSMTP;
    PollFrequency := StrToInt(edtFreq.Text);
  end;

  dmPoll.Start;
end;

procedure TfrmPollTest.StopClick(Sender: TObject);
begin
  dmPoll.Stop;
end;

procedure TfrmPollTest.ShowSomeProgress(Secs : longint);
begin
  Label1.Caption := 'Seconds elapsed: ' + IntToStr(Secs);
  Label1.Update;
end;

procedure TfrmPollTest.FormDestroy(Sender: TObject);
begin
  dmPoll.Free;
end;

procedure TfrmPollTest.Status(const Msg : ShortString);
begin
  Label2.Caption := Msg;
  Label2.Update;
end;

end.
