unit oMain;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, EnterpriseSMS_TLB, StdVcl, sms_http;

const
  sVersion = 'v1.02';

type
  TSMSSender = class(TAutoObject, ISMSSender)
  private
    FHttp : TdmHttp;
    FMessage, FNumber : AnsiString;
    FIniDir : AnsiString;
    FUserName, FPassword : AnsiString;
    FAccountAvailable : Boolean;
    FAccountMsg : AnsiString;
    function ReadNameAndPassword : SmallInt;
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

uses ComServ, Setup, RegUtil, SmsLic, ApiUtil, SysUtils, dialogs;


procedure TSMSSender.Initialize;
var
  TempInt : SmallInt;
begin
  Inherited Initialize;
  FIniDir := GetCOMObjectDir('EnterpriseSMS.SMSSender');
//  ReadDefaults;
  TempInt := ReadNameAndPassword;
  FAccountAvailable := TempInt = 0;
  Case TempInt of
    0  : FAccountMsg := '';
    1  : FAccountMsg := 'Unable to read SMS Account file';
    2  : FAccountMsg := 'Invalid ESN';
    3  : FAccountMsg := 'Invalid checksum';
  end;

end;

Destructor TSMSSender.Destroy;
begin
  if Assigned(FHttp) then
    FHttp.Free;
end;

function TSMSSender.Get_Version: WideString;
begin
  Result := sVersion;
end;

function TSMSSender.Send: Smallint;
begin
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
          Result := FHttp.Send
        else
          Result := 1003;
      end
      else
        Result := 1000;
    Finally
      FreeAndNil(FHttp);
    End;
  end
  else
    Result := 3000;
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
begin
  Case ErrorNo of
    0     :  Result := 'Message sent successfully';
    97    :  Result := 'Invalid CGI Syntax: ' + QuotedStr(FHttp.ErrorStr);
    98    :  Result := 'Not enough SMS credits to send message';
    99    :  Result := 'Invalid UserName or Password';

    1000  :  Result := 'Exception while sending SMS: ' + FHttp.ErrorStr;
    1001  :  Result := 'Wininet.dll not available';
    1002  :  Result := 'Unable to connect to internet';
    1003  :  Result := 'Unable to read SMS Account file';
    2000  :  Result := 'Operation timed out';

    3000  :  Result := FAccountMsg;


    3333  :  begin
               FHttp := TdmHttp.Create(nil);
               Try
                 FHttp.UserName := FUserName;
                 FHttp.Password := FPassword;
                 Result :=  IntToStr(FHttp.CheckAccount);
               Finally
                 FreeAndNil(FHttp);
               End;
             end;
  end;
end;

function TSMSSender.ReadNameAndPassword : SmallInt;
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





initialization
  TAutoObjectFactory.Create(ComServer, TSMSSender, Class_SMSSender,
    ciMultiInstance, tmApartment);
end.
