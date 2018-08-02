unit MAILp1;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mssocket, Mspop, msmsg, Email, ExtCtrls;

const
  WantToClose = False;

type

  TEmailType = (emlMAPI, emlSMTP);
  TGetMessageProc = procedure(const Sender, Subject : ShortString;
                              Text : PChar) of object;
  TCheckTimerProc = procedure(Secs : longint) of object;
  TShowStatusProc = procedure(const Msg : ShortString) of object;

  TdmPoll = class(TDataModule)
    Email1: TEmail;
    msMessage1: TmsMessage;
    msPOP1: TmsPOPClient;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FPollFrequency : longint; //seconds
    FSecsElapsed   : longint;
    FEmailType     : TEmailType;
    FOnGetMessage  : TGetMessageProc;
    FPop3Server,
    FPop3UserName,
    FPop3Password  : string;
    FOnCheckTimer : TCheckTimerProc;
    FOnStatus     : TShowStatusProc;
    procedure SaveOriginator(Const Originator,OrigAddr,Subject,FileName  :  String);
    procedure ShowStatus(const Msg : string);
  protected
    procedure SetPollFrequency(Value : longint);
    procedure CheckForEmails;
    procedure DownloadMAPIEmails;
    procedure DownloadPOP3Emails;
    procedure SetString(Index : integer; const Value : string);
  public
    { Public declarations }
    procedure Start;
    procedure Stop;
    property PollFrequency : longint read FPollFrequency write SetPollFrequency;
    property OnGetMessage : TGetMessageProc read FOnGetMessage write FOnGetMessage;
    property OnCheckTimer : TCheckTimerProc read FOnCheckTimer write FOnCheckTimer;
    property OnStatus : TShowStatusProc read FOnStatus write FOnStatus;
    property Pop3Server : string Index 1 read FPop3Server write SetString;
    property Pop3UserName : string Index 2 read FPop3UserName write SetString;
    property Pop3Password : string Index 3 read FPop3Password write SetString;
    property EmailType : TEmailType read FEmailType write FEMailType;
  end;

var
  dmPoll: TdmPoll;

implementation

{$R *.DFM}

procedure TdmPoll.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  inc(FSecsElapsed);
  if Assigned(FOnCheckTimer) then
    FOnCheckTimer(FSecsElapsed);
  if FSecsElapsed >= FPollFrequency then
  begin
    FSecsElapsed := 0;
    //Do something
    CheckForEmails;
  end;
  Timer1.Enabled := True;
end;

procedure TdmPoll.SetPollFrequency(Value : longint);
begin
  if Value < 1 then
    Value := 1;

  FPollFrequency := Value;
end;

procedure TdmPoll.CheckForEmails;
var
  NumWaiting : longint;
  OldText    : string;
begin
{  OldText := StatusDisplay;
  fStatusDisplay := 'Checking Emails';
  CallDisplayUpdate;}

  case FEmailType of
    emlMAPI:
    begin
      try
        { Logon to MAPI and download all emails to inbox }
        Email1.Logon;
        try
          { Count unread emails }
          NumWaiting := Email1.CountUnread;
          if NumWaiting > 0 then // Process e-mails
            DownloadMAPIEmails;
        finally
          { Logoff MAPI }
          Email1.LogOff
        end;
      except
        On Ex:Exception Do
          MessageDlg ('The following exception occured whilst checking for MAPI mail:' + #13#10 +
                        Ex.Message, mtError, [mbOk], 0);
      end;
    end;

    emlSMTP:
    begin
      try
        with MSPop1 do
        begin
          Host     := POP3Server;
          UserName := POP3UserName;
          Password := POP3PassWord;
          { Connect to Server }
          Login;

          try
            { Check for outstanding messages }
            if TotalMessages > 0 then
              DownloadPOP3Emails;
          finally
            // Close connection
            Logout;
          end;
        end; // with
      except
        on Ex:Exception Do
          MessageDlg ('The following exception occured whilst checking for SMTP/POP3 mail:' + #13#13 +
                      Ex.Message, mtError, [mbOk], 0);
      end;
    end;
  end; // case

{  fStatusDisplay := OldText;
  CallDisplayUpdate;}
end; { CheckforEmails }

//-----------------------------------------------------------------------------------

procedure TdmPoll.DownloadMAPIEmails;
var
  Messages       : TStringList;
  MsgCnt, MsgPos : SmallInt;
  I              : SmallInt;
  ErrStr         : ShortString;
Begin { DownLoadEmails }
  { Create list to store Message ID's in }
  Messages := TStringList.Create;

  Try { Finally }
    Try { Except }
      { Download all Message ID's into local list }
{      fStatusDisplay := 'Downloading Email Headers';
      CallDisplayUpdate;}

      Email1.GetNextMessageId;

      While (Length(Email1.MessageId) <> 0)  and (Not WantToClose) Do
      Begin
        Messages.Add(Email1.MessageId);

        Email1.GetNextMessageID;
      End; { While (Length(Email1.MessageId) <> 0) }

      { Process downloaded messages -have to do this way otherwise positioning }
      { is lost in message queue and it starts looping, etc...                 }
      MsgPos := 1;
      MsgCnt := Messages.Count;
      While (Messages.Count > 0)  and (Not WantToClose) Do
      Begin
        Application.ProcessMessages;

{        fStatusDisplay := 'Processing ' + IntToStr(MsgPos) + ' of ' + IntToStr(MsgCnt);
        CallDisplayUpdate;}

        With Email1 Do Begin
          { Set Message ID from list }
          MessageId := Messages[0];

          { Mark messages as read }
          LeaveUnRead := False;

          { fetch the specified message }
          ReadMail;

          if Assigned(FOnGetMessage) then
            FOnGetMessage(Recipient[0], Subject, GetLongText);

        End; { With Email1 }

        { Increment progress counter }
        Inc (MsgPos);

        { Remove Message ID from list }
        Messages.Delete(0);
      End; { While (Messages.Count > 0) }
    Except
      On Ex:Exception Do
        MessageDlg ('The following exception occured whilst reading the messages:' + #13#13 +
                    Ex.Message, mtError, [mbOk], 0);
    End;
  finally
    Messages.Destroy;
  end;
End; { DownLoadEmails }

procedure TdmPoll.DownloadPOP3Emails;
Var
  I, J, FVar : LongInt;
  RepFName   : ShortString;
  EmlFileName: String;
Begin { DownloadPOP3Emails }
  EmlFileName:='';

  Try { Except }
    With msPOP1 Do
    begin
      { Download all messages }
      for I := 0 To Pred(TotalMessages) do
      begin
        Application.ProcessMessages;

       { fStatusDisplay := 'Processing ' + IntToStr(I + 1) + ' of ' + IntToStr(TotalMessages);
        CallDisplayUpdate;}

        { Download full message details }
        CurrentMessage := i;
        Retrieve;

        With MailMessage Do
        Begin
          With MailMessage.Sender do  {* Save email details for auto response back *}
          Begin
                  {EL: 04/10/2000. For some reason, name & address are the wrong way around, so pass in wrong way around}
            SaveOriginator(Address,Name,Subject,RepFName);

          if Assigned(FOnGetMessage) then
            FOnGetMessage(Address, Subject, Body.GetText);

          end;
        End; { With Msg }

        { Delete message from server }
        Delete;

        If (WantToClose) then
          Break;
      End; { For }
    End; { With msPOP1 }
  Except
    On Ex:Exception Do
      MessageDlg ('The following exception occured whilst reading the messages:' + #13#13 +
                  Ex.Message, mtError, [mbOk], 0);
  End;
End; { DownloadPOP3Emails }


procedure TdmPoll.SaveOriginator(Const Originator,OrigAddr,Subject,FileName  :  String);
begin
  //Do nothing yet - don't know if i need this
end;

procedure TdmPoll.SetString(Index : integer; const Value : string);
begin
  Case Index of
    1  : FPop3Server := Value;
    2  : FPop3Username  := Value;
    3  : FPop3Password  := Value;
  end;
end;

procedure TdmPoll.DataModuleCreate(Sender: TObject);
begin
  PollFrequency := 60;
end;

procedure TdmPoll.Start;
begin
  Timer1.Enabled := True;
end;

procedure TdmPoll.Stop;
begin
  Timer1.Enabled := False;
end;

procedure TdmPoll.ShowStatus(const Msg : string);
begin
  if Assigned(FOnStatus) then
    FOnStatus(Msg);
end;


end.
