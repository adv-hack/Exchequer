unit oSMS;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, EnterpriseSMS_TLB, StdVcl, sms_http;

const
  ClassVersion = '1.00';

type
  TSMSSender = class(TAutoObject, ISMSSender)
  private
    FMessage, FNumber : WideString;
    FHttp : TdmHttp;
  protected
    function AreYouReady: WordBool; safecall;
    function Get_Message: WideString; safecall;
    function Get_Number: WideString; safecall;
    function Get_Version: WideString; safecall;
    function GetErrorDesc(ErrorNo: Integer): WideString; safecall;
    function Send: Integer; safecall;
    function Setup: Integer; safecall;
    procedure Abort; safecall;
    procedure Reset; safecall;
    procedure Set_Message(const Value: WideString); safecall;
    procedure Set_Number(const Value: WideString); safecall;
    { Protected declarations }
  public
    procedure Initialize; override;
    Destructor Destroy; override;
  end;

implementation

uses ComServ;

procedure TSMSSender.Initialize;
begin
  FHttp := TdmHttp.Create(nil);
end;

Destructor TSMSSender.Destroy;
begin
  if Assigned(FHttp) then
    FHttp.Free;
end;


function TSMSSender.AreYouReady: WordBool;
begin
  Result := True;
end;

function TSMSSender.Get_Message: WideString;
begin
  Result := FMessage;
end;

function TSMSSender.Get_Number: WideString;
begin
  Result := FNumber;
end;

function TSMSSender.Get_Version: WideString;
begin
  Result := ClassVersion;
end;

function TSMSSender.GetErrorDesc(ErrorNo: Integer): WideString;
begin
  Result := '';
end;

function TSMSSender.Send: Integer;
begin
  if Assigned(FHttp) then
  begin
    FHttp.Msg := FMessage;
    FHttp.Number := FNumber;

    Result := FHttp.Send;
  end;
end;

function TSMSSender.Setup: Integer;
begin

end;

procedure TSMSSender.Abort;
begin

end;

procedure TSMSSender.Reset;
begin
  if Assigned(FHttp) then
  begin
    FHttp.Msg := '';
    FHttp.Number := '';
  end;
end;

procedure TSMSSender.Set_Message(const Value: WideString);
begin
  FMessage := Value;
end;

procedure TSMSSender.Set_Number(const Value: WideString);
begin
  FNumber := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSMSSender, Class_SMSSender,
    ciMultiInstance, tmApartment);
end.
