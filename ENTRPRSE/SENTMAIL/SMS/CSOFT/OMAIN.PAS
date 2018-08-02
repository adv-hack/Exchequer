unit oMain;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, EnterpriseSMS_TLB, StdVcl, sms_http;

const
  sVersion = 'v6.00.003';
  OurMargin = 0.085;

type
  TSMSSender = class(TAutoObject, ISMSSender)
  private
    FHttp : TdmHttp;
    FMessage, FNumber : AnsiString;
    FIniDir : AnsiString;
    FUserName, FPassword : AnsiString;
    FAccountAvailable : Boolean;
    FAccountMsg : AnsiString;
    LastErrorString : string;
    function ReadNameAndPassword : SmallInt;
    function GetDummyResult : Integer;
  protected
    function Get_Version: WideString; safecall;
    function Send: Smallint; safecall;
    function Setup: Smallint; safecall;
    procedure Reset; safecall;
    function Get_Message: WideString; safecall;
    function Get_Number: WideString; safecall;
    procedure Set_Message(const Value: WideString); safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function AreYouReady: WordBool; safecall;
    procedure Abort; safecall;
    function GetErrorDesc(ErrorNo: Integer): WideString; safecall;
    { Protected declarations }
  public
    procedure Initialize; override;
    Destructor Destroy; override;

  end;

implementation

uses ComServ, Setup, RegUtil, SmsLic, ApiUtil, SysUtils, dialogs, Classes, IniFiles;

procedure writeinifile;
var
  i : Integer;
  T : TStringList;
begin
  T := TStringList.Create;
  T.Add('[ReturnCodes]');
  for i := -10 to 199 do
  begin
    if (i <= 0) or (i in SuccessSet) then
      T.Add(IntToStr(i) + '=0')
    else
    if (i in ThisOneInvalidSet) then
      T.Add(IntToStr(i) + '=1');
  end;
  T.SaveToFile('c:\smsreturn.ini');
end;


procedure TSMSSender.Initialize;
var
  TempInt : SmallInt;
begin
  Inherited Initialize;
{$IFNDEF DUMMY}
  FIniDir := GetCOMObjectDir('EnterpriseSMS.SMSSender');
  FLogFile := IncludeTrailingBackSlash(FIniDir) + 'smslog.txt';
  LogIt('COM Directory: ' + FIniDir);
//  ReadDefaults;
  TempInt := ReadNameAndPassword;
  FAccountAvailable := TempInt = 0;
  Case TempInt of
    0  : FAccountMsg := '';
    1  : FAccountMsg := 'Unable to read SMS Account file';
    2  : FAccountMsg := 'Invalid ESN';
    3  : FAccountMsg := 'Invalid checksum';
  end;
{$ELSE}
  writeinifile;
{$ENDIF}
end;

Destructor TSMSSender.Destroy;
begin
{$IFNDEF DUMMY}
  if Assigned(FHttp) then
    FHttp.Free;
{$ENDIF}
end;

function TSMSSender.Get_Version: WideString;
begin
  Result := sVersion;
end;

function TSMSSender.Send: Smallint;
begin
{$IFDEF DUMMY}
  if FNumber = '1111' then
    Result := 1
  else
    Result := 0;
//  Result := GetDummyResult;
{$ELSE}
  if FAccountAvailable then
  begin
    FHttp := TdmHttp.create(nil);
    Try
      if Assigned(FHttp) then
      begin
        FHttp.Number := FNumber;
        FHttp.Msg := FMessage;

        FHttp.UserName := FUserName;
        FHttp.Password := FPassword;

        if {FHttp.}FAccountAvailable then
        begin
          Try
            Result := FHttp.Send;
            LastErrorString := FHttp.ErrorStr;
          Except
            on E:Exception do
            begin
              LastErrorString := E.Message;
              Result := 1000;
            end;
          End;
        end
        else
          Result := 1003;
      end
      else
        Result := 999;
    Finally
      FreeAndNil(FHttp);
    End;
  end
  else
    Result := 3000;
{$ENDIF}
end;

function TSMSSender.Setup: Smallint;
begin
  with TfrmSetup.Create(nil) do
  Try
    ShowModal;
  Finally
    Free;
  End;
end;

procedure TSMSSender.Reset;
begin
{  if Assigned(FHttp) then
  begin
    FHttp.Number := FNumber;
    FHttp.Msg := FMessage;
  end;}
end;

function TSMSSender.Get_Message: WideString;
begin
  Result := FMessage;
end;

function TSMSSender.Get_Number: WideString;
begin
  Result := FNumber;
end;

procedure TSMSSender.Set_Message(const Value: WideString);
begin
  FMessage := Value;
end;

procedure TSMSSender.Set_Number(const Value: WideString);
begin
  FNumber := Value;
end;

function TSMSSender.AreYouReady: WordBool;
begin
  result := True;
end;

procedure TSMSSender.Abort;
begin
  //Do nothing
end;

function TSMSSender.GetErrorDesc(ErrorNo: Integer): WideString;
var
  tmpAcc : Double;
begin
  {$IFDEF DUMMY}
   LastErrorString := 'Error';
  {$ENDIF}
  Case ErrorNo of
 {   0     :  Result := 'Message sent successfully';
    97    :  Result := 'Invalid CGI Syntax: ' + QuotedStr(FHttp.ErrorStr);
    98    :  Result := 'Not enough SMS credits to send message';
    99    :  Result := 'Invalid UserName or Password';}
    {$IFDEF DUMMY}
    0..2  :  Result := 'Error';
    {$ELSE}
    0..2  :  Result := LastErrorString;
    {$ENDIF}

    1000  :  Result := 'Exception while sending SMS: ' + LastErrorString;
    1001  :  Result := 'Wininet.dll not available';
    1002  :  Result := 'Unable to connect to internet';
    1003  :  Result := 'Unable to read SMS Account file';
    2000  :  Result := 'Operation timed out';

    3000  :  Result := FAccountMsg;


    3333  :  begin
               {$IFDEF DUMMY}
                 Result := '1';
               {$ELSE}
               if FAccountAvailable then
               begin
                 FHttp := TdmHttp.Create(nil);
                 Try
                   FHttp.UserName := FUserName;
                   FHttp.Password := FPassword;
                   Result :=  FHttp.CheckAccount;
                   {$IFDEF Credits}
                   if Result <> '-1' then
                   Try
                     TmpAcc := StrToFloat(Result);
                     TmpAcc := TmpAcc / OurMargin;
                     Result := IntToStr(Trunc(TmpAcc));
                   Except
                     Result := '-1';
                   End;
                   {$ENDIF}
                 Finally
                   FreeAndNil(FHttp);
                 End;
               end;
               {$ENDIF}
             end;
  end;
end;

function TSMSSender.ReadNameAndPassword : SmallInt;
var
  Lic : TSmsWapLicence;
begin
{$IFDEF DUMMY}
   Result := 0;
{$ELSE}
  {$IFDEF READFILE}
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
  {$ELSE}
    FUserName := 'PRutherford.62584';
    FPassword := '16899957';
    Result := 0;
  {$ENDIF}
{$ENDIF}
end;





function TSMSSender.GetDummyResult: Integer;
begin
  with TIniFile.Create('C:\smsdummy.ini') do
  Try
    Result := ReadInteger('Dummy', 'Result', 0);
  Finally
    Free;
  End;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSMSSender, Class_SMSSender,
    ciMultiInstance, tmApartment);
end.
