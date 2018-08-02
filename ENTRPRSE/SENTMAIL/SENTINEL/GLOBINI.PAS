unit GlobIni;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  IniFiles;


type
  TSentIniObject = Class
  private
    FIniFile : TIniFile;
  protected
    function GetString(Index : Integer) : ShortString;
    procedure SetString(Index : Integer; const Value : ShortString);
    function GetInt(Index : Integer) : SmallInt;
    procedure SetInt(Index : Integer; Value : SmallInt);
    function GetBool(Index : Integer) : Boolean;
    procedure SetBool(Index : Integer; Value : Boolean);
  public
    constructor Create(const AFileName : AnsiString);
    destructor Destroy; override;
    property AdminEmail : ShortString index 0 read GetString write SetString;
    property AdminSMS : ShortString index 1 read GetString write SetString;
    property ConvLogCount : SmallInt index 0 read GetInt write SetInt;
    property QueryLogCount : SmallInt index 1 read GetInt write SetInt;
    property PollLogCount : SmallInt index 2 read GetInt write SetInt;
    property SMSWarnLevel : SmallInt index 3 read GetInt write SetInt;
    property SMSWarnCount : SmallInt index 4 read GetInt write SetInt;
    property SMSSendWarning : SmallInt index 5 read GetInt write SetInt;
    property SMSCredit : ShortString index 2 read GetString write SetString;
    property SMSDefCountry : ShortString index 3 read GetString write SetString;
    property QueueCount : SmallInt index 6 read GetInt write SetInt;

  end;

var
  GlobalIniFileName : AnsiString;

implementation

constructor TSentIniObject.Create(const AFileName : AnsiString);
begin
  inherited Create;
  FIniFile := TIniFile.Create(AFileName);
end;

destructor TSentIniObject.Destroy;
begin
  if Assigned(FIniFile) then
    FIniFile.Free;
end;


function TSentIniObject.GetString(Index : Integer) : ShortString;
begin
  Result := '';
  if Assigned(FIniFile) then
  begin
    Case Index of
      0  :  Result := FIniFile.ReadString('Notify', 'Email', '');
      1  :  Result := FIniFile.ReadString('Notify', 'SMS', '');
      2  :  Result := FIniFile.ReadString('SMS', 'Credit', '');
      3  :  Result := FIniFile.ReadString('SMS', 'Country', '');
    end;
  end;
end;

procedure TSentIniObject.SetString(Index : Integer; const Value : ShortString);
begin
  if Assigned(FIniFile) then
  begin
    Case Index of
      0  : FIniFile.WriteString('Notify', 'Email', Value);
      1  : FIniFile.WriteString('Notify', 'SMS', Value);
      2  : FIniFile.WriteString('SMS', 'Credit', Value);
      3  : FIniFile.WriteString('SMS', 'Country', Value);
    end;
    FIniFile.UpdateFile;
  end;
end;

function TSentIniObject.GetInt(Index : Integer) : SmallInt;
begin
  Result := 0;
  if Assigned(FIniFile) then
  begin
    Case Index of
      0  :  Result := FIniFile.ReadInteger('LogFiles', 'Conveyor', 0);
      1  :  Result := FIniFile.ReadInteger('LogFiles', 'Query', 0);
      2  :  Result := FIniFile.ReadInteger('LogFiles', 'Poller', 0);
      3  :  Result := FIniFile.ReadInteger('SMS', 'WarnLevel', 0);
      4  :  Result := FIniFile.ReadInteger('SMS', 'WarnCount', 0);
      5  :  Result := FIniFile.ReadInteger('SMS', 'WarnSend', 0);
      6  :  Result := FIniFile.ReadInteger('Queuing', 'Count', 0);
    end;
  end;
end;


procedure TSentIniObject.SetInt(Index : Integer; Value : SmallInt);
begin
  if Assigned(FIniFile) then
  begin
    Case Index of
      0  : FIniFile.WriteInteger('LogFiles', 'Conveyor', Value);
      1  : FIniFile.WriteInteger('LogFiles', 'Query', Value);
      2  : FIniFile.WriteInteger('LogFiles', 'Poller', Value);
      3  : FIniFile.WriteInteger('SMS', 'WarnLevel', Value);
      4  : FIniFile.WriteInteger('SMS', 'WarnCount', Value);
      5  : FIniFile.WriteInteger('SMS', 'WarnSend', Value);
      6  : FIniFile.WriteInteger('Queuing', 'Count', Value);

    end;
    FIniFile.UpdateFile;
  end;
end;

function TSentIniObject.GetBool(Index : Integer) : Boolean;
begin
  Result := False;
  if Assigned(FIniFile) then
  begin
    Case Index of
      0  :  Result := FIniFile.ReadBool('Settings', 'AllowQueuing', False);
    end;
  end;
end;

procedure TSentIniObject.SetBool(Index : Integer; Value : Boolean);
begin
  if Assigned(FIniFile) then
  begin
    Case Index of
      0  : FIniFile.WriteBool('Settings', 'AllowQueuing', Value);
    end;
    FIniFile.UpdateFile;
  end;
end;




end.
