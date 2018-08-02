unit EntColumnSettings;

interface

uses
  EntSettings;

type
  TColumnSettings = Class
  private
    FSettings   : TColumnSettingsRec;
    FIsDirty    : Boolean;
    function GetLeft: LongInt;
    function GetWidth: LongInt;
    procedure SetLeft(const Value: LongInt);
    procedure SetWidth(const Value: LongInt);
    function GetColumnNo: Integer;
    function GetParentName: string;
    procedure SetColumnNo(const Value: Integer);
    procedure SetParentName(const Value: string);
    function GetHeight: LongInt;
    function GetTop: LongInt;
    procedure SetHeight(const Value: LongInt);
    procedure SetTop(const Value: LongInt);
    function GetOrder: LongInt;
    procedure SetOrder(const Value: LongInt);
  public
    constructor Create(const sExeName    : string;
                       const sUserID     : string;
                       const sWindowName : string);
    property csParentName : string read GetParentName write SetParentName;
    property csColumnNo : Integer read GetColumnNo write SetColumnNo;
    property csLeft  : LongInt read GetLeft write SetLeft;
    property csWidth  : LongInt read GetWidth write SetWidth;
    property csTop : LongInt read GetTop write SetTop;
    property csHeight : LongInt read GetHeight write SetHeight;
    property csOrder : LongInt read GetOrder write SetOrder;

    property IsDirty : Boolean read FIsDirty write FIsDirty;
    property SettingsRec : TColumnSettingsRec read FSettings write FSettings;
  end;



implementation

uses
  EtStrU;

{ TColumnSettings }

constructor TColumnSettings.Create(const sExeName    : string;
                                   const sUserID     : string;
                                   const sWindowName : string);
begin
  inherited Create;
  FIsDirty := False;
  FillChar(FSettings, SizeOf(FSettings), 0);
  FSettings.csExeName := sExeName;
  FSettings.csUserName := sUserID;
  FSettings.csWindowName := sWindowName;
  FSettings.DummyChar := '!';
end;

function TColumnSettings.GetColumnNo: Integer;
begin
  Result := FSettings.csColumnNo;
end;

function TColumnSettings.GetLeft: LongInt;
begin
  Result := FSettings.csLeft;
end;

function TColumnSettings.GetParentName: string;
begin
  Result := FSettings.csParentName;
end;

function TColumnSettings.GetWidth: LongInt;
begin
  Result := FSettings.csWidth;
end;

procedure TColumnSettings.SetColumnNo(const Value: Integer);
begin
  FSettings.csColumnNo := Value;
end;

procedure TColumnSettings.SetLeft(const Value: LongInt);
begin
  if FSettings.csLeft <> Value then
  begin
    FSettings.csLeft := Value;
    FIsDirty := True;
  end;
end;

procedure TColumnSettings.SetParentName(const Value: string);
begin
  FSettings.csParentName := LJVar(Value, COMP_NAME_LENGTH);
end;

procedure TColumnSettings.SetWidth(const Value: LongInt);
begin
  if FSettings.csWidth <> Value then
  begin
    FSettings.csWidth := Value;
    FIsDirty := True;
  end;
end;

function TColumnSettings.GetHeight: LongInt;
begin
  Result := FSettings.csHeight;
end;

function TColumnSettings.GetTop: LongInt;
begin
  Result := FSettings.csTop;
end;

procedure TColumnSettings.SetHeight(const Value: LongInt);
begin
  if FSettings.csHeight <> Value then
  begin
    FSettings.csHeight := Value;
    FIsDirty := True;
  end;
end;

procedure TColumnSettings.SetTop(const Value: LongInt);
begin
  if FSettings.csTop <> Value then
  begin
    FSettings.csTop := Value;
    FIsDirty := True;
  end;
end;

function TColumnSettings.GetOrder: LongInt;
begin
  Result := FSettings.csOrder;
end;

procedure TColumnSettings.SetOrder(const Value: LongInt);
begin
  if FSettings.csOrder <> Value then
  begin
    FSettings.csOrder := Value;
    FIsDirty := True;
  end;
end;

end.
