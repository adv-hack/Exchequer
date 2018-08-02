unit sms_http;

interface

uses
  SysUtils, Classes, Mssocket, mshttp, IniFiles;

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
    FNumber : AnsiString;
    FIniDir : AnsiString;
    FTimeOut : longint;
    FTestMode : Boolean;
    FDialUp, FHangUp : Boolean;
    FLogFile : TextFile;
    function SendMessage(Svr : integer; Msg : AnsiString) : SmallInt;
    function ReplaceInvalidChars(const Msg : AnsiString) : AnsiString;
    function ReadNameAndPassword : SmallInt;
  public
    { Public declarations }
    ErrorStr : string;
    AccountAvailable : Boolean;
    function ReadDefaults : Boolean;
    function CheckAccount : longint;
    function Send : SmallInt;
    property Msg : AnsiString read FMsg write FMsg;
    property Number : AnsiString read FNumber write FNumber;
    property IniDir : AnsiString read FIniDir write FIniDir;
    property UserName : AnsiString read FUserName write FUserName;
    property Password : AnsiString read FPassword write FPassword;
  end;

var
  dmHttp: TdmHttp;

implementation

uses
 msDef, RegUtil, SmsLic, ApiUtil, Dial, Dialogs;

{$R *.dfm}
const

  InvalidString = '&+%# =';
  InvalidCharCount = 6;

  CGI_URL = '/sendsms?';
  ACC_URL = '/cgi/accparam.cgi';

  InvalidChars : Array[1..InvalidCharCount] of String[3] = ('%26','%2B','%25',
                                                            '%23', '%20','%3D');

function TdmHttp.SendMessage(Svr : integer; Msg : AnsiString) : SmallInt;
var
  PostData : ShortString;
  ResArray : Array[1..2] of Char;
  ResString : String;
begin
  FillChar(ResArray, 2, #0);
  ErrorStr := '';
  FResult := -1;
  http1.TimeOut := FTimeOut;

  http1.Host := HostList[Svr];

{  if Trim(FProxy) <> '' then
    Http1.URL := 'http://' + http1.Host + CGI_URL
  else
    Http1.URL := CGI_URL;}

  http1.Host := HostList[Svr];

  http1.Proxy := FProxy;
  http1.ProxyPort := FProxyPort;
{  PostData := 'N='+ Trim(FNumber)+'&UID='+FUserName+'&PW='+FPassword;
  if FTestMode then
    PostData := PostData + '&TEST=1';}
  PostData := 'UN='+FUserName+'&PIN='+FPassword+'&N='+Trim(FNumber);
  PostData := PostData + '&M=' + Trim(ReplaceInvalidChars(FMsg));

  Http1.URL := 'http://' + http1.Host + CGI_URL + PostData;

//  http1.OutStream.Write(PostData[1],Length(PostData));
  http1.OutStream.Position:=0;
  Try
    http1.Get;
    http1.InStream.Position:=0;
    http1.InStream.Read(ResArray[1], 2);
    ResString := ResArray[1] + ResArray[2];
    FResult := StrToInt(ResString);
    Result := 0;
    if FResult = 97 then
      ErrorStr := PostData;
{$I-}
  WriteLn(FLogFile, 'Result: ' + IntToStr(Fresult));
{$I+}
  Except
    on EmsTimedOutError do Result := 2000;
    on E:Exception do
    begin
      Result := 1000;
      ErrorStr := E.Message;
    end;
  End;
end;

function TdmHttp.ReplaceInvalidChars(const Msg : AnsiString) : AnsiString;
const
  InvalidSet = [$20, $22, $23, $25, $26, $2C, $2E, $2F, $3A..$3F];
var
  i, j : integer;
  s : AnsiString;
begin
  s := Msg;
  i := 1;
  while i < Length(s) do
  begin
    if s[i] in [#10, #13] then
      Delete(s, i, 1)
    else
    begin
      j := Ord(s[i]);
      if j in InvalidSet then
      begin

        Delete(s, i, 1);
        Insert('%' + IntToHex(j, 2), s, i);
        inc(i, 2);
      end;
      inc(i);
    end;
    Result := s;
  end;
  i := 1;

end;

procedure TdmHttp.DataModuleCreate(Sender: TObject);
var
  TempInt : SmallInt;
begin
  FTestMode := False;
  HostList := TStringList.Create;
  HostList.Add('www.csoft.co.uk');
  HostList.Add('www2.csoft.co.uk');
  FTimeOut := 60;
  FIniDir := GetCOMObjectDir('EnterpriseSMS.SMSSender');
  ReadDefaults;
{  TempInt := ReadNameAndPassword;
  AccountAvailable := TempInt = 0;
  Case TempInt of
    1  : ShowMessage('Unable to read SMS Account file');
    2  : ShowMessage('Invalid ESN');
    3  : ShowMessage('Invalid checksum');
  end;}

end;

function TdmHttp.Send : SmallInt;
var
  i : integer;
  UseDialup : Boolean;
begin

  Result := -1;
  i := 0;

  UseDialup := FDialup and (GetWindowsVersion > wv98);

  if UseDialup then
  begin
    if LoadInet then
    begin
      if not DialInet then
      begin
        Result := 1002;
        EXIT;
      end;
    end
    else
    begin
      Result := 1001;
      EXIT;
    end;
  end;

  if Trim(FMsg) <> '' then
  begin

    while (Result <> 0) and (i < 3) do
    begin
      Result := SendMessage(i, FMsg);
      inc(i);
    end;

    if Result = 0 then
    begin
      if FResult in [97, 98, 99] then
        Result := FResult;
    end;

  end
  else
    Result := 0;

  if UseDialup then
  begin
    if FHangup then
      Hangup;
    FreeInet;
  end;

end;

function TdmHttp.ReadNameAndPassword : SmallInt;
var
  Lic : TSmsWapLicence;
begin
  Lic := TSmsWapLicence.Create;
  Try
    Lic.FileName := FIniDir + 'Smail.dat';
    Result := Lic.ReadFile;
    if Result = 0 then
    begin
      FUserName := Lic.UserName;
      FPassword := Lic.Password;
    end;
  Finally
    Lic.Free;
  End;
end;

function TdmHttp.ReadDefaults : Boolean;
var
  TheIni : TIniFile;
  UseProxy : Boolean;
begin
  Result := True;
  TheIni := TIniFile.Create(FIniDir + 'SmsWap.ini');
  Try
    UseProxy := TheIni.ReadBool('Proxy Settings','UseProxy',False);
    FTimeOut := TheIni.ReadInteger('Settings', 'TimeOut', 360);
    FTestMode := TheIni.ReadBool('Settings','xDebug',False);
    FDialup := TheIni.ReadBool('Settings', 'Dialup', False);
    FHangup := TheIni.ReadBool('Settings', 'Hangup', True);

    if UseProxy then
    begin
      FProxy := TheIni.ReadString('Proxy Settings','Proxy', '');
      FProxyPort := TheIni.ReadInteger('Proxy Settings','ProxyPort', 0);
    end
    else
    begin
      FProxy := '';
      FProxyPort := 0;
    end;
  Finally
    TheIni.Free;
  End;

end;

function TdmHttp.CheckAccount : longint;
var
  PostData : ShortString;
  ResArray : Array[1..50] of Char;
  ResString : String;
  AccString : string;
  i, BytesRead : integer;
  UseDialup : Boolean;
begin
  Result := -1;
  UseDialup := FDialup and (GetWindowsVersion > wv98);

  if UseDialup then
  begin
    if LoadInet then
    begin
      if not DialInet then
      begin
        FResult := 1002;
        EXIT;
      end;
    end
    else
    begin
      FResult := 1001;
      EXIT;
    end;
  end;


  FillChar(ResArray, SizeOf(ResArray), #0);
  FResult := -1;
  Result := -1;


  http1.Host := HostList[0];

  if Trim(FProxy) <> '' then
    Http1.URL := 'http://' + http1.Host + ACC_URL
  else
    Http1.URL := ACC_URL;

  http1.Host := HostList[0];

  http1.Proxy := FProxy;
  http1.ProxyPort := FProxyPort;
  PostData := 'UID='+FUserName+'&PW='+FPassword + '&M=1';


  http1.OutStream.Write(PostData[1],Length(PostData));
  http1.OutStream.Position:=0;
  Try
    Try
      http1.Post;
      http1.InStream.Position:=0;
      BytesRead := http1.InStream.Read(ResArray[1], 50);
      ResString := ResArray[1] + ResArray[2];
      FResult := StrToInt(ResString);
      if FResult = 1 then
      begin
        i := 3;
        while i < BytesRead do
        begin
          if ResArray[i] in ['0'..'9'] then
            AccString := AccString + ResArray[i];
          inc(i);
        end;
        Try
          Result := StrToInt(AccString);
        Except
          Result := -1;
        End;
      end;


    Except
      on EmsTimedOutError do FResult := 2000;
      on Exception do FResult := 1000;
    End;

  Finally
    if UseDialup then
    begin
      if FHangup then
        Hangup;
      FreeInet;
    end;
  End;


end;

end.
