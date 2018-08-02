unit sms_http;

interface

uses
  SysUtils, Classes, Mssocket, mshttp, IniFiles, WinHTTP;


const

  SuccessSet = [158, 160, 161];
  ThisOneInvalidSet = [3..14, 16..30, 23, 24, 35, 36, 54, 76, 173..199];

  SMS_RETURN_INI = 'SmsReturn.ini';
  SMS_RETURN_SECTION = 'ReturnCodes';

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
    FIniFile : TIniFile;
    function SendMessage(Svr : integer; Msg : AnsiString) : SmallInt;
    function ReplaceInvalidChars(const Msg : AnsiString) : AnsiString;
    function ReadNameAndPassword : SmallInt;
    function ReadResultCategory(Res : Integer) : Integer;
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

{Notes on CSoft's new api: The number of return codes is now huge, so we'll need to categorise them simply. Effectively there are
 3 types of return that govern what we do next:
   1 : Message successfully sent or queued : 158, 160, 161, -10..0
   2 : Message can't be sent - move on to next message: eg invalid phone no (3..14, 16..30, 76)
   3 : Message can't be sent - don't try sending any messages (eg invalid logon, no credit left.  (151..156, 1..2, 71..75)

   Safest procedure is to treat anything that doesn't fall into Categories 1 or 2 as Category 3}

implementation

uses
 msDef, Setup, SmsLic, ApiUtil, Dial, Dialogs;

{$R *.dfm}
const

  InvalidString = '&+%# =';
  InvalidCharCount = 6;

  CGI_URL = '/webservices/http/sendsms?';
  ACC_URL = '/webservices/http/queryaccount?';

  ER_TIMEOUT = 2000;

  InvalidChars : Array[1..InvalidCharCount] of String[3] = ('%26','%2B','%25',
                                                            '%23', '%20','%3D');

//  FatalSet = [151..156, 1..2, 71..75, 171, 172];


function TdmHttp.SendMessage(Svr : integer; Msg : AnsiString) : SmallInt;
const
  ReturnSize = 8000;
var
//  PostData : ShortString;
  ResArray : Array[1..ReturnSize] of Char;
  ResString, ResString1 : String;
  i, iReturn : Integer;
  bRes : Boolean;

  function GetResultValue(const s : string) : Integer;
  var
    j, c : integer;
  begin
    Result := -1;
    j := Pos(' ', s);
    if j > 0 then
      Val(Copy(s, 1, j - 1), Result, c);
  end;

  function GetErrorString(const s : string) : string;
  begin
    Result := Copy(s, Pos('-', s) + 2, Length(s));
  end;
begin
  FillChar(ResArray, ReturnSize, #0);
  ErrorStr := '';
  FResult := -1;
  http1.WaitThread := True;
  http1.WaitTimeOut := FTimeOut * 1000;

  Http1.URL := 'https://' + HostList[Svr] + CGI_URL;


  http1.Proxy.ProxyServer := FProxy;
  http1.Proxy.ProxyPort := FProxyPort;
{  PostData := 'N='+ Trim(FNumber)+'&UID='+FUserName+'&PW='+FPassword;
  if FTestMode then
    PostData := PostData + '&TEST=1';}
  http1.RequestMethod := rmPost;
  {$IFDEF EX600}
  http1.PostData := 'Username='+FUserName+'&PIN='+FPassword;
  http1.PostData := http1.PostData + '&Message=' + Trim(ReplaceInvalidChars(FMsg))+'&SendTo='+Trim(FNumber);
  {$ELSE}
  http1.PostData := 'UN='+FUserName+'&PIN='+FPassword+'&N='+Trim(FNumber);
  http1.PostData := http1.PostData + '&M=' + Trim(ReplaceInvalidChars(FMsg));
  {$ENDIF}

  Try
    bRes := http1.Read;
    if bRes then
    begin
      Result := GetResultValue(SMSResultString);
      ErrorStr := GetErrorString(SMSResultString);
    end
    else
    begin
      Result := ER_TIMEOUT;
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

  Result := ER_TIMEOUT;
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

    //if we get a timeout then assume that the server is not available
    //and roll over to the next server
    while (Result = ER_TIMEOUT) and (i < 2) do
    begin
      Result := SendMessage(i, FMsg);
      inc(i);
    end;

{    if Result = 0 then
    begin
      if FResult in [97, 98, 99] then
        Result := FResult;
    end;}

{    if (Result in SuccessSet) or (Result <= 0) then
      Result := 0 //Message sent or queued
    else
    if Result in ThisOneInvalidSet then
      Result := 1 //Don't try to resend this message, but can send others
    else
      Result := 2; //Don't try to send any more until issues is sorted}

    LogIt('SMS Send: Number = ' + FNumber + '; Result = ' + IntToStr(Result), True);

    Result := ReadResultCategory(Result);

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

function TdmHttp.ReadResultCategory(Res: Integer): Integer;
begin
  if not Assigned(FIniFile) then
    FIniFile := TIniFile.Create( IncludeTrailingBackSlash(GetCOMObjectDir('EnterpriseSMS.SMSSender')) + SMS_RETURN_INI);

  if Assigned(FIniFile) then
    Result := FIniFile.ReadInteger(SMS_RETURN_SECTION, IntToStr(Res), 2)
  else
    Result := 2;

end;

end.
