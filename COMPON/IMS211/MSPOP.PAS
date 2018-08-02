(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit Mspop;

{$I msDef.Inc}

interface

uses
  Windows,
{$IFDEF VCL}
  Forms,
  Dialogs,
  Graphics,
  Controls,
{$ENDIF}
  msMsg, msMsgCls, SysUtils, Messages, Classes, Mssocket, msDef, msWSock;

type
  TmsPOPClient = class(TmsClientSocket)
  private
    { Private declarations }
    FUserName : ShortString;
    FPassword : ShortString;
    FTotalMessages : Integer;
    FTotalOctets : Integer;
    FMailMessage : TmsMessage;
    FCurrentMessage : Integer;
    FOnRetrievingMessage : TNotifyEvent;
    FOnMessageRetrieved: TNotifyEvent;
    procedure SetCurrentMessage(Value : Integer);
    procedure DoRetrievingMessage(Sender: TObject);
    procedure DoMessageRetrieved(Sender: TObject);
  protected
    { Protected declarations }
    procedure GetStatistics;
    function GetServerReplyCode(const s : string) : Integer; override;
{$IFDEF VCL}
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
{$ENDIF}
  public
    { Public declarations }
{$IFDEF VCL}
    constructor Create(AOwner : TComponent); override;
{$ELSE}
    constructor Create; override;
{$ENDIF}
    procedure Login;
    procedure Logout;
    procedure Retrieve;
    procedure RetrieveAsStream(Stream: TStream);
    procedure RetrieveHeaders;
    function GetUIDL : string;
    function GetSize: LongInt;
    procedure Delete;
    property CurrentMessage : Integer read FCurrentMessage write SetCurrentMessage;
    property TotalMessages : Integer read FTotalMessages;
    property TotalOctets : Integer read FTotalOctets;
  published
    { Published declarations }
    property MailMessage : TmsMessage read FMailMessage write FMailMessage;
    property UserName : ShortString read FUserName write FUserName;
    property Password : ShortString read FPassword write FPassword;
    property OnMessageRetrieved: TNotifyEvent read FOnMessageRetrieved
      write FOnMessageRetrieved;
    property OnRetrievingMessage : TNotifyEvent read FOnRetrievingMessage
      write FOnRetrievingMessage;
  end;

implementation

uses msUtils;

{$IFDEF VCL}
constructor TmsPOPClient.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Port:=110;
  FDefaultPort:=Port;
end;
{$ELSE}
constructor TmsPOPClient.Create;
begin
  inherited Create;
  Port:=110;
  FDefaultPort:=Port;
end;
{$ENDIF}

{$IFDEF VCL}
procedure TmsPOPClient.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation=opRemove) and (AComponent=FMailMessage) then
    FMailMessage:=nil;
end;
{$ENDIF}

procedure TmsPOPClient.DoRetrievingMessage(Sender : TObject);
begin
  if Assigned(FOnRetrievingMessage) then
    FOnRetrievingMessage(Sender);
end;

procedure TmsPOPClient.DoMessageRetrieved(Sender: TObject);
begin
  if Assigned(FOnMessageRetrieved) then
    FOnMessageRetrieved(Sender);
end;

procedure TmsPOPClient.SetCurrentMessage(Value : Integer);
begin
  if FTotalMessages=0 then
    FCurrentMessage:=-1
  else
  if Value>=FTotalMessages then
    FCurrentMessage:=FTotalMessages-1
  else
  if Value<0 then
    FCurrentMessage:=0
  else
    FCurrentMessage:=Value;
end;

function TmsPOPClient.GetServerReplyCode(const s : string) : Integer;
begin
  Result:=0;
  if Length(s)>0 then
  begin
    case s[1] of
      '+' : Result:=1;
      '-' : Result:=-1;
    end;
  end;
end;

procedure TmsPOPClient.Login;
var
  rs : Integer;
begin
  Connect;
  rs:=iRecvLines;
  if rs<>1 then
    raise EmsServerError.Create(TempS);
  SendLine('USER '+FUserName);
  rs:=iRecvLine(TempS);
  if rs<>1 then
    raise EmsServerError.Create(TempS);
  SendLine('PASS '+FPassword);
  rs:=iRecvLine(TempS);
  if rs<>1 then
    raise EmsServerError.Create(TempS);
  GetStatistics;
  if FTotalMessages>0 then
    FCurrentMessage:=0;
end;

procedure TmsPOPClient.Logout;
var
  rs : Integer;
begin
  SendLine('QUIT');
  try
    rs:=iRecvLine(TempS);
    if rs<>1 then
      raise EmsServerError.Create(TempS);
  except
    on E:EWinsockError do
    begin
      if Pos('10054',E.Message)=0 then raise;
    end
    else
      raise;
  end;
  Disconnect;
end;

procedure TmsPOPClient.Retrieve;
var
  TempStream : TStream;
  rs, Size : Integer;
begin
  FMailMessage.Clear;
  DoRetrievingMessage(Self);
  SendLine('RETR '+IntToStr(FCurrentMessage+1));
  rs:=iRecvLine(TempS);
  if rs<>1 then
    raise EmsServerError.Create(TempS);
  Size:=PickNumber(TempS,1);
  TempStream:=TMemoryStream.Create;
  try
    RecvLineStream(TempStream,Size);
    TempStream.Position:=0;
    MailMessage.LoadFromStream(TempStream);
  finally
    TempStream.Free;
  end;
  DoMessageRetrieved(Self);
end;

procedure TmsPOPClient.RetrieveAsStream(Stream: TStream);
var
  rs, Size: Integer;
begin
  DoRetrievingMessage(Self);
  SendLine('RETR '+IntToStr(FCurrentMessage+1));
  rs:=iRecvLine(TempS);
  if rs<>1 then
    raise EmsServerError.Create(TempS);
  Size:=PickNumber(TempS,1);
  RecvLineStream(Stream,Size);
  Stream.Position:=0;
  DoMessageRetrieved(Self);
end;

procedure TmsPOPClient.RetrieveHeaders;
var
  TempStream : TStream;
  TempHeaders : TmsHeaders;
  rs : Integer;
begin
  FMailMessage.Clear;
  SendLine('TOP '+IntToStr(FCurrentMessage+1)+' 1');
  rs:=iRecvLine(TempS);
  if rs<>1 then
    raise EmsServerError.Create(TempS);
  TempStream:=TMemoryStream.Create;
  try
    RecvLineStream(TempStream,-1);
    TempStream.Position:=0;
    TempHeaders:=TmsHeaders.Create;
    try
      TempHeaders.LoadFromStream(TempStream);
      MailMessage.ProcessHeaders(TempHeaders);
    finally
      TempHeaders.Free;
    end;
  finally
    TempStream.Free;
  end;
end;

function TmsPOPClient.GetUIDL : string;
var
  rs: Integer;
begin
  SendLine('UIDL '+IntToStr(FCurrentMessage+1));
  rs:=iRecvLine(TempS);
  if rs=1 then
    Result:=PickString(TempS,2,true)
  else
    Result:='';
end;

function TmsPOPClient.GetSize: LongInt;
var
  rs: Integer;
begin
  SendLine('LIST '+IntToStr(FCurrentMessage+1));
  rs:=iRecvLine(TempS);
  if rs<>1 then
    raise EmsServerError.Create(TempS);
  Result:=PickNumber(TempS,2);
end;

procedure TmsPOPClient.Delete;
var
  rs : Integer;
begin
  SendLine('DELE '+IntToStr(FCurrentMessage+1));
  rs:=iRecvLine(TempS);
  if rs<>1 then
    raise EmsServerError.Create(TempS);
end;

procedure TmsPOPClient.GetStatistics;
var
  i : byte;
  rs : Integer;
begin
  FCurrentMessage:=-1;
  SendLine('STAT');
  rs:=iRecvLine(TempS);
  if rs<>1 then
    raise EmsServerError.Create(TempS);
  System.Delete(TempS,1,4);
  i:=Pos(' ',TempS);
  if i>0 then
  begin
    FTotalMessages:=StrToInt(Copy(TempS,1,i-1));
    System.Delete(TempS,1,i);
    i:=Pos(' ',TempS);
    if i>0 then
      FTotalOctets:=StrToInt(Copy(TempS,1,i-1))
    else
      FTotalOctets:=StrToInt(TempS);
  end;
end;

end.
