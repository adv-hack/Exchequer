unit oMain;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, EnterpriseSMS_TLB, StdVcl, sms_http;

const
  sVersion = 'v1.00';
//  API_ID = 22717; //psr account
  API_ID = 23920;  //Exchequer account

type
  TSMSSender = class(TAutoObject, ISMSSender)
  private
    FMessage, FNumber : AnsiString;
    FUserName, FPassword : AnsiString;
    Routo : Variant;
    OKToSend : Boolean;
    FIniDir : AnsiString;
    FHttp : TdmHttp;
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

uses ComServ, Setup, SysUtils, Variants, smsLic, FileUtil, dialogs, ApiUtil, Dial;

procedure TSMSSender.Initialize;
begin
  Inherited Initialize;
  FHttp := TDmHttp.Create(nil);
  FIniDir := GetEnterpriseDirectory;
  OKToSend := ReadNameAndPassword = 0;
  Routo := CreateOLEObject('Clickatell_COMAPI.SMS');
end;

Destructor TSMSSender.Destroy;
begin
  Routo := Unassigned;
  if Assigned(FHttp) then
    FHttp.Free;
end;

function TSMSSender.Get_Version: WideString;
begin
  Result := sVersion;
end;

{function TSMSSender.Send: Smallint;
var
  ResStr : Variant;
begin
  if OKToSend then
  begin
    Routo.UserName := FUserName;
    Routo.Password := FPassword;
    Routo.PhoneNumber := FNumber;
    Routo.Message := FMessage;

    ResStr := Routo.Send;
    ShowMessage(ResStr);
    Result := 0;
  end
  else
    Result := 102;
end;}

function TSMSSender.Send: Smallint;
Var
  ResStr : WideString;
  UseDialup : Boolean;
begin
  if OKToSend and FHttp.ReadDefaults then
  begin
    UseDialup := FHttp.Dialup and (GetWindowsVersion > wv98);

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

    Try
      ResStr := Routo.SendSimpleSMS(API_ID, FUserName, FPassword, FNumber, FMessage);
    Finally
      if UseDialup then
      begin
        if FHttp.WantHangup then
          Hangup;
        FreeInet;
      end;
    End;

    ResStr := Copy(ResStr, 1, 2);
    if ResStr = 'ID' then
      Result := 0
    else
    Try
      Result :=  StrToInt(ResStr);
    Except
      Result := 96;
    End;
  end
  else
    Result := 102;
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
  ResStr : WideString;
begin
  Case ErrorNo of
    0     :  Result := 'Message sent successfully';

    1000  :  Result := 'Exception while sending SMS';
    1001  :  Result := 'Wininet.dll not available';
    1002  :  Result := 'Unable to connect to internet';
    1003  :  Result := 'Unable to read SMS Account file';
    2000  :  Result := 'Operation timed out';

    3333  :  {begin
               FHttp := TdmHttp.Create(nil);
               Try
                 Result :=  IntToStr(FHttp.CheckAccount);
               Finally
                 FreeAndNil(FHttp);
               End;
             end;}
             begin
               Routo.authenticate(API_ID, FUserName, FPassword);
               ResStr := Routo.QueryBalance;
               Result := ResStr;
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
