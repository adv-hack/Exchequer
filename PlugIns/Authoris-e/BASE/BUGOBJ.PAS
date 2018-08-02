unit bugObj;

interface

type
  TDebugObject = Class
  private
    FUnit  : String;
    FID : string;
  protected
    procedure SetString(Index : Integer; const s : string);
    function GetString(Index : Integer) : string;
  public
    property EUnit : String Index 0 read GetString write SetString;
    property EID : String Index 1 read GetString write SetString;
  end;

var
  DebugObject : TDebugObject;


implementation

procedure TDebugObject.SetString(Index : integer; const s : string);
begin
  Case Index of
    0  : FUnit := s;
    1  : FID := s;
  end;
end;

function TDebugObject.GetString(Index : Integer) : string;
begin
  Case Index of
    0  : Result := FUnit;
    1  : Result := FID;
  end;
end;

Initialization
  DebugObject := TDebugObject.Create;
Finalization
  DebugObject.Free;

end.
