unit sms_http;

interface

uses
  SysUtils, Classes, Mssocket, mshttp, IniFiles, WinHTTP;

type
  TdmHttp = class(TDataModule)
    Http1: TWinHTTP;
    procedure DataModuleCreate(Sender: TObject);
    procedure Http1Done(Sender: TObject; const ContentType: String;
      FileSize: Integer; Stream: TStream);
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
    SMSResultString : string;
    function SendMessage(Svr : integer; Msg : AnsiString) : SmallInt;
    function ReplaceInvalidChars(const Msg : AnsiString) : AnsiString;
    function ReadNameAndPassword : SmallInt;
  public
    { Public declarations }
    ErrorStr : string;
    AccountAvailable : Boolean;
    function ReadDefaults : Boolean;
    function CheckAccount : string;
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
 msDef, Setup, SmsLic, ApiUtil, Dial, Dialogs;

{$R *.dfm}
const

  InvalidString = '&+%# =';
  InvalidCharCount = 6;

  CGI_URL = '/sendsms?';
  ACC_URL = '/sendsms?';

  InvalidChars : Array[1..InvalidCharCount] of String[3] = ('%26','%2B','%25',
                                                            '%23', '%20','%3D');

function TdmHttp.SendMessage(Svr : integer; Msg : AnsiString) : SmallInt;
const
  ReturnSize = 8000;
var
//  PostData : ShortString;
  ResArray : Array[1..ReturnSize] of Char;
  ResString, ResString1 : String;
  i, iReturn : Integer;
  bRes : Boolean;
begin
  FillChar(ResArray, ReturnSize, #0);
  ErrorStr := '';
  FResult := -1;
  http1.WaitThread := True;
  http1.WaitTimeOut := FTimeOut * 1000;

  Http1.URL := 'http://' + HostList[Svr] + CGI_URL;


  http1.Proxy.ProxyServer := FProxy;
  http1.Proxy.ProxyPort := FProxyPort;
{  PostData := 'N='+ Trim(FNumber)+'&UID='+FUserName+'&PW='+FPassword;
  if FTestMode then
    PostData := PostData + '&TEST=1';}
  http1.RequestMethod := rmPost;
  http1.PostData := 'UN='+FUserName+'&PIN='+FPassword+'&N='+Trim(FNumber);
  http1.PostData := http1.PostData + '&M=' + Trim(ReplaceInvalidChars(FMsg));

  Try
    bRes := http1.Read;
    if bRes then
    begin
      if Length(SMSResultString) = 2 then
        FResult := StrToInt(SMSResultString)
      else
        FResult := -1;
      if FResult = 97 then
        ErrorStr := http1.POSTData;
      Result := 0;
    end
    else
    begin
      Result := 2000;
      ErrorStr := 'Timed out';
    end;
{    if FResult = 97 then
      ErrorStr := PostData;}
  Except
    on E:Exception do
    begin
      Result := 1000;
      ErrorStr := E.Message;
    end;
  End;
end;

function TdmHttp.ReplaceInvalidChars(const Msg : AnsiString) : AnsiString;
const
  InvalidSet = [$20, $22, $23, $25, $26, $2C, $2E, $2F, $3A..$3F, $A3..$A5, $A7,
                $C4..$C7, $C9, $D1, $D6, $D8, $DC, $DF, $E0, $E4, $E5, $E8, $E9, $EC,
                $F1, $F2, $F6, $F9, $FC];
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
      end
      else
      if j = 128 then {euro}
      begin
        Delete(s, i, 1);
        Insert('E', s, i);
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

    while (Result <> 0) and (i < 2) do
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
    FTimeOut := TheIni.ReadInteger('Settings', 'TimeOut', 60);
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

function TdmHttp.CheckAccount : string;
const
  S_AVAILABLE_CREDIT = 'AvailableCredit';
  S_AVAILABLE_MESSAGES = 'AvailableMessages';
var
  PostData : ShortString;
  ResArray : Array[1..50] of Char;
  ResString : String;
  AccString : string;
  i, BytesRead : integer;
  UseDialup, bRes : Boolean;
  sAvailable : String;
begin
  Result := '-1';
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
  Result := '-1';


  Http1.URL := 'http://' + HostList[0] + ACC_URL;


  http1.Proxy.ProxyServer := FProxy;
  http1.Proxy.ProxyPort := FProxyPort;
  http1.RequestMethod := rmPost;
  http1.WaitThread := True;
  http1.WaitTimeOut := FTimeOut * 1000;
  {$IFDEF Credits}
  http1.PostData := 'Username='+FUserName+'&PIN='+FPassword + '&AvailableCredit=';
  sAvailable := S_AVAILABLE_CREDITS;
  {$ELSE}
  http1.PostData := 'Username='+FUserName+'&PIN='+FPassword + '&AvailableMessages=';
  sAvailable := S_AVAILABLE_MESSAGES;
  {$ENDIF}


  Try
    Try
      bRes := http1.Read;
      if bRes then
      begin
        i := Pos(sAvailable, SMSResultString);
        if i > 0 then
        begin
          Delete(SMSResultString, 1, Length(sAvailable) + 1);
          Result := SMSResultString;
        end;
      end
      else
        Result := '-1';


    Except
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

procedure TdmHttp.Http1Done(Sender: TObject; const ContentType: String;
  FileSize: Integer; Stream: TStream);
var
  i : integer;
begin
  with Stream as TMemoryStream do
  begin
    i := Size;
    SetLength(SMSResultString, i);
    Move(Memory^, SMSResultString[1], i);
  end;
end;

end.
