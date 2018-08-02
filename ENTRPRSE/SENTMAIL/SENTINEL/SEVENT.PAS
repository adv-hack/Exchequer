unit Sevent;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Sentimail_TLB, StdVcl;

type
  TSentimailEvent = class(TAutoObject, ISentimailEvent)
  private
    FDataType : TEventDataType;
    FHandlerID : Integer;
    FWindowID : Integer;
    FDataPath : String;
    FKey : String;
  protected
    function Get_seDataType: TEventDataType; safecall;
    function Get_seHandlerID: Integer; safecall;
    function Get_seKey: WideString; safecall;
    function Get_seWindowID: Integer; safecall;
    function Save: Integer; safecall;
    procedure Set_seDataType(Value: TEventDataType); safecall;
    procedure Set_seHandlerID(Value: Integer); safecall;
    procedure Set_seKey(const Value: WideString); safecall;
    procedure Set_seWindowID(Value: Integer); safecall;
    function Get_seDataPath: WideString; safecall;
    procedure Set_seDataPath(const Value: WideString); safecall;
    { Protected declarations }
  end;

implementation

uses ComServ, eventfnc, GlobVar, SysUtils, ElVar;

function TSentimailEvent.Get_seDataType: TEventDataType;
begin
  Result := FDataType;
end;

function TSentimailEvent.Get_seHandlerID: Integer;
begin
  Result := FHandlerID;
end;

function TSentimailEvent.Get_seKey: WideString;
begin
  Result := FKey;
end;

function TSentimailEvent.Get_seWindowID: Integer;
begin
  Result := FWindowID;
end;

function TSentimailEvent.Save: Integer;
begin
  SetDrive := FDataPath;
  Result := ProcessEvent(FWindowID, FHandlerID, FDataType, FKey);
end;

procedure TSentimailEvent.Set_seDataType(Value: TEventDataType);
begin
  FDataType := Value;
end;

procedure TSentimailEvent.Set_seHandlerID(Value: Integer);
begin
  FHandlerID := Value;
end;

procedure TSentimailEvent.Set_seKey(const Value: WideString);
begin
  FKey := Value;
end;

procedure TSentimailEvent.Set_seWindowID(Value: Integer);
begin
  FWindowID := Value;
end;

function TSentimailEvent.Get_seDataPath: WideString;
begin
  Result := FDataPath;
end;

procedure TSentimailEvent.Set_seDataPath(const Value: WideString);
begin
  FDataPath := IncludeTrailingBackslash(Value);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSentimailEvent, Class_SentimailEvent,
    ciMultiInstance, tmApartment);
  DefineFiles('');
end.
