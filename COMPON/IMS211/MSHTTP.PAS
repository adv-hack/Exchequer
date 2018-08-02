(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit mshttp;

{$I msDef.Inc}

interface

uses
  Windows,
{$IFDEF VCL}
  Graphics, Controls, Forms, Dialogs,
{$ENDIF}
  Messages, SysUtils, Classes, msSocket, msMsgCls, msDef, msUtils;

type
  TmsHTTPClient = class(TmsClientSocket)
  private
    { Private declarations }
    FInStream : TMemoryStream;
    FOutStream: TMemoryStream;
    FURL : string;
    FHeaders : TmsHeaders;
    FFileName : string;
    FUserAgent: string;
    FAuthorization: boolean;
    FProxyAuthorization: boolean;
    FUserName: string;
    FPassword: string;
    FProxyUserName: string;
    FProxyPassword: string;
    FPostContentType: string;
    FOnSendingRequest: TNotifyEvent;
    FOnRequestSent : TNotifyEvent;
    FBoundary: string;
    procedure SetURL(Value : string);
    procedure SetHeaders(Value: TmsHeaders);
    procedure SetPostContentType(const Value: string);
    procedure DoSendingRequest(Sender: TObject);
    procedure DoRequestSent(Sender: TObject);
    procedure SendPostQuery;
    procedure SendQuery(const Query: string);
    procedure SendPostData;
  protected
    { Protected declarations }
    AddInfo : string;
    procedure RecvData;
    function RecvHeaders: Integer;
    procedure StringToStream(Stream: TStream; const s: string);
  public
    { Public declarations }
{$IFDEF VCL}
    constructor Create(AOwner : TComponent); override;
{$ELSE}
    constructor Create; override;
{$ENDIF}
    destructor Destroy; override;
    function Get: Integer;
    function Head: Integer;
    function Post: Integer;
    property InStream : TMemoryStream read FInStream write FInStream;
    property OutStream: TMemoryStream read FOutStream write FOutStream;
    property FileName : string read FFileName;
    property Boundary: string read FBoundary write FBoundary;
    property PostContentType: string read FPostContentType
      write SetPostContentType;
  published
    { Published declarations }
    property Authorization: boolean read FAuthorization write FAuthorization;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
    property ProxyAuthorization: boolean read FProxyAuthorization
      write FProxyAuthorization;
    property ProxyUserName: string read FProxyUserName write FProxyUserName;
    property ProxyPassword: string read FProxyPassword write FProxyPassword;
    property Port default 80;
    property Proxy;
    property ProxyPort;
    property URL : string read FURL write SetURL;
    property UserAgent: string read FUserAgent write FUserAgent;
    property Headers : TmsHeaders read FHeaders write SetHeaders;
    property OnSendingRequest: TNotifyEvent read FOnSendingRequest write FOnSendingRequest;
    property OnRequestSent : TNotifyEvent read FOnRequestSent write FOnRequestSent;
  end;

implementation

uses msMime;

{$IFDEF VCL}
constructor TmsHTTPClient.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
{$ELSE}
constructor TmsHTTPClient.Create;
begin
  inherited Create;
{$ENDIF}
  FInStream:=TMemoryStream.Create;
  FOutStream:=TMemoryStream.Create;
  FHeaders:=TmsHeaders.Create;
  Port:=80;
  FDefaultPort:=Port;
  FPostContentType:='application/x-www-form-urlencoded';
end;

destructor TmsHTTPClient.Destroy;
begin
  FHeaders.Free;
  FOutStream.Free;
  FInStream.Free;
  inherited Destroy;
end;

procedure TmsHTTPClient.DoSendingRequest(Sender: TObject);
begin
  if Assigned(FOnSendingRequest) then
    FOnSendingRequest(Sender);
end;

procedure TmsHTTPClient.DoRequestSent(Sender : TObject);
begin
  if Assigned(FOnRequestSent) then
    FOnRequestSent(Sender);
end;

procedure TmsHTTPClient.SetURL(Value: string);
var
  i : Integer;
begin
  FURL:=Value;
  if Copy(UpperCase(Value),1,7)='HTTP://' then
    Delete(Value,1,7);
  i:=Pos('/',Value);
  if i=0 then
  begin
    Host:=Value;
    AddInfo:='/';
  end
  else
  begin
    Host:=Copy(Value,1,i-1);
    Delete(Value,1,i-1);
    AddInfo:=Value;
    i:=Pos('.',Value);
    if i<>0 then
{if the filename is specified}
    begin
{find last '/'}
      i:=Length(Value);
      while (i>0) and (Value[i]<>'/') do Dec(i);
      if i=0 then
        raise EmsError.Create('Invalid URL');
      FFileName:=Copy(Value,i+1,Length(Value)-i);
      if FFileName='' then
        FFileName:='index.htm';
    end;
    if AddInfo='' then
      AddInfo:='/';
  end;
end;

procedure TmsHTTPClient.SetPostContentType(const Value: string);
begin
  if (LowerCase(Value)='application/x-www-form-urlencoded') or
     (LowerCase(Value)='multipart/form-data') then
    FPostContentType:=Value
  else
    raise EmsError.Create('Invalid content-type');
end;

procedure TmsHTTPClient.StringToStream(Stream: TStream; const s: string);
var
  Buf: PChar;
begin
  Buf:=StrAlloc(Length(s)+3);
  try
    FillChar(Buf^,StrBufSize(Buf),0);
    StrPCopy(Buf,Concat(s,^M^J));
    Stream.Write(Buf^,StrLen(Buf));
  finally
    StrDispose(Buf);
  end;
end;

procedure TmsHTTPClient.SetHeaders(Value: TmsHeaders);
begin
  FHeaders.Assign(Value);
end;

procedure TmsHTTPClient.SendQuery(const Query: string);
var
  LineToSend: string;
  s1,s2: ShortString;
  TempStream: TStream;
begin
  TempStream:=TMemoryStream.Create;
  try
    if Proxy<>'' then LineToSend:=FURL
      else LineToSend:=AddInfo;
    if (Proxy<>'') and (Pos('/',Copy(LineToSend,8,Length(LineToSend)))=0) then
      LineToSend:=Concat(LineToSend,'/');
    StringToStream(TempStream,Concat(Query,' ',LineToSend,' HTTP/1.1'));
    StringToStream(TempStream,Concat('Host: ',Host));
    StringToStream(TempStream,'Accept: */*');
    if FAuthorization then
    begin
      s1:=Concat(FUserName,':',FPassword);
      MakeTextData(s1,s2);
      StringToStream(TempStream,Concat('Authorization: Basic ',s2));
    end;
    if FProxyAuthorization then
    begin
      s1:=Concat(FProxyUserName,':',FProxyPassword);
      MakeTextData(s1,s2);
      StringToStream(TempStream,Concat('Proxy-Authorization: Basic ',s2));
    end;
    if FUserAgent<>'' then
      StringToStream(TempStream,Concat('User-Agent: ',FUserAgent));
    StringToStream(TempStream,'Connection: close');
    StringToStream(TempStream,'');
    SendStream(TempStream,0);
  finally
    TempStream.Free;
  end;
end;

function TmsHTTPClient.RecvHeaders: Integer;
var
  s : string;
begin
  Result:=-1;
  FHeaders.Clear;
  repeat
{$IFDEF VCL}
    Application.ProcessMessages;
{$ENDIF}    
    s:=RecvLine;
    FHeaders.Add(s);
  until s='';
  if FHeaders.Count>0 then
    Result:=PickNumber(FHeaders[0],1);
end;

procedure TmsHTTPClient.RecvData;
var
  FullSize : LongInt;
begin
  FInStream.Clear;
  if LowerCase(Headers.GetFieldBody('Transfer-Encoding'))='chunked' then
    RecvChunkedStream(FInStream)
  else
  begin
    FullSize:=StrToIntDef(Headers.GetFieldBody('Content-Length'),-1);
    RecvStream(FInStream,FullSize,0);
  end;
  FInStream.Position:=0;
end;

function TmsHTTPClient.Get: Integer;
begin
  ReInit;
  Connect;
  try
    DoSendingRequest(Self);
    SendQuery('GET');
    DoRequestSent(Self);
    Result:=RecvHeaders;
    RecvData;
  finally
    Disconnect;
  end;
end;

function TmsHTTPClient.Head: Integer;
begin
  ReInit;
  Connect;
  try
    DoSendingRequest(Self);
    SendQuery('HEAD');
    DoRequestSent(Self);
    Result:=RecvHeaders;
  finally
    Disconnect;
  end;
end;

procedure TmsHTTPClient.SendPostQuery;
var
  TempStream: TStream;
  LineToSend: string;
  s1, s2: ShortString;
begin
  TempStream:=TMemoryStream.Create;
  try
    if Proxy<>'' then LineToSend:=FURL
      else LineToSend:=AddInfo;
{$IFNDEF SENT}
    if (Proxy<>'') and (Pos('/',Copy(LineToSend,8,Length(LineToSend)))=0) then
      LineToSend:=Concat(LineToSend,'/');
{$ENDIF}

{$IFDEF SENT}
    StringToStream(TempStream,Concat('POST ',LineToSend,' HTTP/1.0'));
{$ELSE}
    StringToStream(TempStream,Concat('POST ',LineToSend,' HTTP/1.1'));
{$ENDIF}

    StringToStream(TempStream,Concat('Host: ',Host));
{$IFNDEF SENT}
    StringToStream(TempStream,'Accept: */*');
{$ENDIF}
    if FAuthorization then
    begin
      s1:=Concat(FUserName,':',FPassword);
      MakeTextData(s1,s2);
      StringToStream(TempStream,Concat('Authorization: Basic ',s2));
    end;
    if FProxyAuthorization then
    begin
      s1:=Concat(FProxyUserName,':',FProxyPassword);
      MakeTextData(s1,s2);
      StringToStream(TempStream,Concat('Proxy-Authorization: Basic ',s2));
    end;
    if LowerCase(FPostContentType)='application/x-www-form-urlencoded' then
      StringToStream(TempStream,Concat('Content-Type: ',FPostContentType))
    else
      StringToStream(TempStream,Concat('Content-Type: ',FPostContentType,
        '; boundary=',FBoundary));
    if FUserAgent<>'' then
      StringToStream(TempStream,Concat('User-Agent: ',FUserAgent));
    StringToStream(TempStream,Concat('Content-Length: ',IntToStr(FOutStream.Size)));
{$IFNDEF SENT}
    StringToStream(TempStream,'Connection: close');
{$ENDIF}
    StringToStream(TempStream,'');
    SendStream(TempStream,0);
    FOutStream.Position:=0;
  finally
    TempStream.Free;
  end;
end;

procedure TmsHTTPClient.SendPostData;
begin
  SendStream(FOutStream,0);
end;

function TmsHTTPClient.Post: Integer;
begin
  Connect;
  try
    DoSendingRequest(Self);
    SendPostQuery;
    SendPostData;
    Result:=RecvHeaders;
    if Result=100 then {if the reply is Continue}
    begin
      SendLine('');
      Result:=RecvHeaders;
    end;
    DoRequestSent(Self);
    RecvData;
  finally
    Disconnect;
  end;
end;

end.
