unit TreeSet;

{ prutherford440 09:36 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, ComCtrls;

type

  TCoTreeObject = Class
  public
    CoExpanded,
    AuthExpanded,
    UsersExpanded,
    ReqsExpanded : Boolean;
  end;

  TTreeSettings = Class
  private
    FList : TStringList;
    FCurrent : Integer;
    function GetBool(Index : Integer) : Boolean;
    procedure SetBool(Index : Integer; Value : Boolean);
    procedure ClearSettings;
    procedure SetCompany(const Value : String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const Value : String);
    procedure Delete(Index : Integer);
    property CoExpanded : Boolean Index 0 read GetBool write SetBool;
    property AuthExpanded : Boolean Index 1 read GetBool write SetBool;
    property UsersExpanded : Boolean Index 2 read GetBool write SetBool;
    property ReqsExpanded : Boolean Index 3 read GetBool write SetBool;
    property Company : String write SetCompany;
  end;



implementation

constructor TTreeSettings.Create;
begin
  inherited Create;
  FList := TStringList.Create;
  FCurrent := - 1;
end;

destructor TTreeSettings.Destroy;
begin
  if Assigned(FList) then
  begin
    ClearSettings;
    FList.Free;
  end;
  inherited Destroy;
end;

procedure TTreeSettings.ClearSettings;
var
  i : integer;
begin
  for i := 0 to FList.Count - 1 do
  begin
    if Assigned(FList.Objects[i]) then
      TCoTreeObject(FList.Objects[i]).Free;
  end;
  FList.Clear;
end;

function TTreeSettings.GetBool(Index : Integer) : Boolean;
begin
  if FCurrent > -1 then
  Case Index of
    0  : Result := TCoTreeObject(FList.Objects[FCurrent]).CoExpanded;
    1  : Result := TCoTreeObject(FList.Objects[FCurrent]).AuthExpanded;
    2  : Result := TCoTreeObject(FList.Objects[FCurrent]).UsersExpanded;
    3  : Result := TCoTreeObject(FList.Objects[FCurrent]).ReqsExpanded;
  end;
end;

procedure TTreeSettings.SetBool(Index : Integer; Value : Boolean);
begin
  if FCurrent > -1 then
   Case Index of
     0  :  TCoTreeObject(FList.Objects[FCurrent]).CoExpanded := Value;
     1  :  TCoTreeObject(FList.Objects[FCurrent]).AuthExpanded := Value;
     2  :  TCoTreeObject(FList.Objects[FCurrent]).UsersExpanded := Value;
     3  :  TCoTreeObject(FList.Objects[FCurrent]).ReqsExpanded := Value;
   end;

end;

procedure TTreeSettings.SetCompany(const Value : String);
begin
  FCurrent := FList.IndexOf(Value);
end;

procedure TTreeSettings.Add(const Value : String);
var
  Sett : TCoTreeObject;
begin
  Sett := TCoTreeObject.Create;
  with Sett do
  begin
    CoExpanded := False;
    AuthExpanded := False;
    UsersExpanded := False;
    ReqsExpanded := False;
  end;
  FList.AddObject(Value, Sett);
end;

procedure TTreeSettings.Delete(Index : Integer);
begin
  if Index < FList.Count then
  begin
    if Assigned(FList.Objects[Index]) then
      TCoTreeObject(FList.Objects[Index]).Free;
    FList.Delete(Index);
  end;
end;

end.
