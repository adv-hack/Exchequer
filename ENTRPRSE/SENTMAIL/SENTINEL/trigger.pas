unit trigger;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Sentimail_TLB, StdVcl, ElVar, ElObjs, Classes;

const
  TRIGGERED_EVENT_VERSION = '6.5.002';

type

  TTriggeredEvent = class(TAutoObject, ITriggeredEvent)
  private
    FUser,
    FSentinel  : String;
    FEmailAddresses,
    FSMSNumbers : TStringList;
    FTriggered : TTriggered;
    FLines : TStringList;
    FDataPath : string;
    FEmailSubject : string;
    FInstance : Integer;
    function Triggered : TTriggered;
    procedure LoadLines;
    function CheckLine(const User, Sentinel : ShortString; Instance : SmallInt) : Boolean;
    procedure ClearAllFields;
  protected
    function Get_teUser: WideString; safecall;
    function Get_teSentinel: WideString; safecall;
    function Get_teLineCount: Integer; safecall;
    function Get_teDataPath: WideString; safecall;
    procedure Set_teDataPath(const Value: WideString); safecall;
    function Get_teLine(Index: Integer): WideString; safecall;
    function Get_teEmailAddress(Index: Integer): WideString; safecall;
    function Get_teSMSNumber(Index: Integer): WideString; safecall;
    function GetFirst(const User: WideString): Integer; safecall;
    function GetNext: Integer; safecall;
    function GetEqual(const User: WideString; const Sentinel: WideString; Instance: Integer): Integer; safecall;
    function Delete: Integer; safecall;
    function Get_teEmailSubject: WideString; safecall;
    function Get_teEmailAddressCount: Integer; safecall;
    function Get_teSMSNumberCount: Integer; safecall;
    function Get_teInstance: Integer; safecall;
    function Get_teVersion: WideString; safecall;    
  public
    destructor Destroy; override;
    procedure Initialize; override;
  end;


implementation

{ TTriggeredEvent }
uses
 ComServ, SysUtils, GlobVar;

function TTriggeredEvent.CheckLine(const User,
  Sentinel: ShortString; Instance : SmallInt): Boolean;
begin
  Result := (Trim(User) = Trim(Triggered.UserID)) and (Trim(Sentinel) = Trim(Triggered.ElertName));
  if Instance > 0 then
    Result := Result and (Instance = Triggered.Instance);
end;

procedure TTriggeredEvent.ClearAllFields;
begin
  FUser := '';
  FSentinel := '';
  FEmailSubject := '';
  FEmailAddresses.Clear;
  FSMSNumbers.Clear;
  FLines.Clear;
  FInstance := 0;
end;

function TTriggeredEvent.Delete: Integer;
begin
  Result := Triggered.DeleteInstTempRecs(pxTriggered, FInstance);
end;

destructor TTriggeredEvent.Destroy;
begin
  if Assigned(FTriggered) then
    FTriggered.Free;
  if Assigned(FLines) then
    FLines.Free;
  if Assigned(FEmailAddresses) then
    FEmailAddresses.Free;
  if Assigned(FSMSNumbers) then
    FSMSNumbers.Free;
  inherited;
end;

function TTriggeredEvent.GetEqual(const User,
  Sentinel: WideString; Instance: Integer): Integer;
var
  sUser, sSentinel : ShortString;
begin
  sUser := LJVar(User, UIDSize);
  sSentinel := LJVar(Sentinel, 30);
  Result := Triggered.GetGreaterThanOrEqual(sUser + sSentinel);
  if Instance > 0 then
    while (Result = 0) and (Triggered.Instance <> Instance) do
      Result := Triggered.GetNext;

  if (Result = 0) and CheckLine(sUser, sSentinel, 0) then
    LoadLines
  else
    Result := 4;
end;

function TTriggeredEvent.GetFirst(const User: WideString): Integer;
var
  sUser, sSentinel : ShortString;
begin
  sUser := LJVar(User, UIDSize);
  sSentinel := '';
  Result := Triggered.GetGreaterThanOrEqual(sUser + sSentinel);
  if (Result = 0) and (Trim(sUser) = Trim(Triggered.UserID)) then
    LoadLines
  else
    Result := 9;
end;

function TTriggeredEvent.GetNext: Integer;
var
  sUser : ShortString;
begin
  sUser := Triggered.UserID;
  Result := Triggered.GetNext;
  if (Result = 0) and (Trim(sUser) = Trim(Triggered.UserID)) then
    LoadLines
  else
    Result := 9;
end;

function TTriggeredEvent.Get_teDataPath: WideString;
begin
  Result := FDataPath;
end;

function TTriggeredEvent.Get_teEmailAddress(Index: Integer): WideString;
begin
  Result := FEmailAddresses[Index - 1];
end;

function TTriggeredEvent.Get_teEmailAddressCount: Integer;
begin
  Result := FEmailAddresses.Count;
end;

function TTriggeredEvent.Get_teEmailSubject: WideString;
begin
  Result := FEmailSubject;
end;

function TTriggeredEvent.Get_teInstance: Integer;
begin
  Result := Finstance;
end;

function TTriggeredEvent.Get_teLine(Index: Integer): WideString;
begin
  Result := FLines[Index - 1];
end;

function TTriggeredEvent.Get_teLineCount: Integer;
begin
  Result := FLines.Count;
end;

function TTriggeredEvent.Get_teSentinel: WideString;
begin
  Result := FSentinel;
end;

function TTriggeredEvent.Get_teSMSNumber(Index: Integer): WideString;
begin
  Result := FSMSNumbers[Index - 1];
end;

function TTriggeredEvent.Get_teSMSNumberCount: Integer;
begin
  Result := FSMSNumbers.Count;
end;

function TTriggeredEvent.Get_teUser: WideString;
begin
  Result := FUser;
end;


function TTriggeredEvent.Get_teVersion: WideString;
begin
  Result := TRIGGERED_EVENT_VERSION;
end;

procedure TTriggeredEvent.Initialize;
begin
  inherited;
  FTriggered := nil;
  FLines := TStringList.Create;
  FEmailAddresses := TStringList.Create;
  FSMSNumbers := TStringList.Create;
  ClearAllFields;
end;

procedure TTriggeredEvent.LoadLines;
const
  SMS_PREFIX = #1;
var
  ThisInstance : SmallInt;
  Res : Integer;

  procedure CleanLines;
  var
    i : integer;
  begin
    //Because we don't have access to the Elert header and the lines are not necessarily ordered, if we have both
    //SMS and Email lines then we want to remove the SMS lines. We've marked SMS lines by prefixing them with
    //#1, so if we only have SMS lines then we want to remove the prefix.
    if (FSMSNumbers.Count > 0) then
    begin
      if (FEmailAddresses.Count > 0) then
      begin
        for i := FLines.Count - 1 downto 0 do
          if FLines[i][1] = SMS_PREFIX then
             FLines.Delete(i);
      end
      else
      begin
        for i := 0 to FLines.Count - 1 do
          if FLines[i][1] = SMS_PREFIX then
            FLines[i] := Copy(FLines[i], 2, Length(FLines[i]));
      end;
    end
  end;
begin
  ClearAllFields;
  //We've already loaded the first record into the Triggered object.
  Res := 0;
  ThisInstance := Triggered.Instance;
  FUser := Triggered.UserId;
  FSentinel := Triggered.ElertName;
  FInstance := Triggered.Instance;

  while (Res = 0) and CheckLine(FUser, FSentinel, ThisInstance) do
  begin
    Case Triggered.TypeChar of
      otEmailSub2Go  : FEmailSubject := Triggered.Line1;
      otEmailAdd2Go  : if FEmailAddresses.IndexOf(Triggered.Line1) < 0 then
                         FEmailAddresses.Add(Triggered.Line1);
      otSMSNumber2Go : if FSMSNumbers.IndexOf(Triggered.Line1) < 0 then
                         FSMSNumbers.Add(Triggered.Line1);
      otSMS2Go       : FLines.Add(SMS_PREFIX + Triggered.Line1);
      else
        FLines.Add(Triggered.Line1);
    end;

    Res := Triggered.GetNext;
  end;

  CleanLines;

  if Res = 0 then
  begin
    //We've moved onto the record after the last line of this Sentinel, so move back to the last line
    Res := Triggered.GetPrevious;
  end;
end;

procedure TTriggeredEvent.Set_teDataPath(const Value: WideString);
begin
  if IncludeTrailingPathDelimiter(UpperCase(Trim(Value))) <> FDataPath then
  begin
    //The files in the datapath are opened in the create method of the triggered object, so we need to free it so it
    //will be created again the next time it is accessed.
    if Assigned(FTriggered) then
      FreeAndNil(FTriggered);
    FDataPath := IncludeTrailingPathDelimiter(UpperCase(Trim(Value)));
  end;
end;

function TTriggeredEvent.Triggered: TTriggered;
begin
  if not Assigned(FTriggered) then
  begin
    if Trim(FDataPath) <> '' then
    begin
      SetDrive := FDataPath;
      FTriggered := TTriggered.Create;
    end
    else
      raise Exception.Create('No data path has been set');
  end;

  Result := FTriggered;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTriggeredEvent, Class_TriggeredEvent,
    ciMultiInstance, tmApartment);
end.
