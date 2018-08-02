unit sms_http;

interface

uses
  SysUtils, Classes, Mssocket, mshttp;

type
  TdmHttp = class(TDataModule)
    http1: TmsHTTPClient;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    HostList : TStringList;
    FMsg : AnsiString;
    FProxy : String;
    FProxyPort : longint;
    FUserName, FPassword : string;
    FResult : SmallInt;
    FTest : Boolean;
    FNumber : AnsiString;
    FIniDir : AnsiString;
    function SendMessage(Svr : integer; Msg : AnsiString) : SmallInt;
    function ReplaceInvalidChars(const Msg : AnsiString) : AnsiString;
    function ReadNameAndPassword : Boolean;
    function ReadDefaults : Boolean;
  public
    { Public declarations }
    function Send : SmallInt;
    property Msg : AnsiString read FMsg write FMsg;
    property Number : AnsiString read FNumber write FNumber;
    property IniDir : AnsiString read FIniDir write FIniDir;
  end;

var
  dmHttp: TdmHttp;

implementation

uses
 msDef;

{$R *.dfm}
const

  InvalidString = '&+%# =';
  InvalidCharCount = 6;

  CGIURL = '/cgi/csend.cgi';

  InvalidChars : Array[1..InvalidCharCount] of String[3] = ('%26','%2B','%25',
                                                            '%23', '%20','%3D');

function TdmHttp.SendMessage(Svr : integer; Msg : AnsiString) : SmallInt;
var
  PostData : AnsiString;
  ResArray : Array[1..2] of Char;
  ResString : String;
begin
  FResult := -1;
  http1.Host := HostList[Svr];
  Http1.URL := 'http://' + http1.Host + CGIURL;
  http1.Proxy := FProxy;
  http1.ProxyPort := FProxyPort;
  PostData := 'N='+ Trim(FNumber)+'&UID='+FUserName+'&PW='+FPassword;
  if FTest then
    PostData := PostData + '&TEST=1';
  PostData := PostData + '&M=' + Trim(ReplaceInvalidChars(FMsg));


  http1.OutStream.Write(PostData[1],Length(PostData));
  http1.OutStream.Position:=0;
  Try
    http1.Post;
    http1.InStream.Position:=0;
    http1.InStream.Read(ResArray[1], 2);
    ResString := ResArray[1] + ResArray[2];
    FResult := StrToInt(ResString);
    Result := 0;
  Except
    on EmsTimedOutError do Result := 2000;
    on Exception do Result := 1000;
  End;
end;

function TdmHttp.ReplaceInvalidChars(const Msg : AnsiString) : AnsiString;
var
  i, j : integer;
  s : AnsiString;
begin
  s := Msg;
  i := 1;
  while i < Length(s) do
  begin
    j := Pos(s[i], InvalidString);
    if j > 0 then
    begin
      Delete(s, i, 1);
      Insert(InvalidChars[j], s, i);
      i := i + 2;
    end;
    inc(i);
    Result := s;
  end;
end;

procedure TdmHttp.DataModuleCreate(Sender: TObject);
begin
  HostList := TStringList.Create;
  HostList.Add('clients.sms-wap.com');
  HostList.Add('clients2.sms-wap.com');
  HostList.Add('clients3.sms-wap.com');

  ReadDefaults;
  ReadNameAndPassword;
end;

function TdmHttp.Send : SmallInt;
var
  i : integer;
begin
  Result := -1;
  i := 0;

  if Trim(FMsg) <> '' then
  begin

    while (Result <> 0) and (i < 3) do
    begin
      Result := SendMessage(i, FMsg);
      inc(i);
    end;

  end
  else
    Result := 0;
end;

function TdmHttp.ReadNameAndPassword : Boolean;
begin
  FUserName := 'rutp5071';
  FPassword := 'atemandi';
end;

function TdmHttp.ReadDefaults : Boolean;
begin
  FProxy := 'ntbox';
  FProxyPort := 80;
end;

end.
