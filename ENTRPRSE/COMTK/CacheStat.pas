unit CacheStat;

interface

uses
  Classes;

type

  ICacheStatus = Interface (IInterface)
   ['{471D22B7-E98D-4A9F-A347-8820A8476F76}']
    procedure SetFileChanged(FileNo, ClientID : Integer);
  end;


  TCacheStatusList = Class
  private
    FList : TInterfaceList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const Item : ICacheStatus);
    procedure Update(FileNo,ClientID : Integer);
  end;

  function CacheStatusList : TCacheStatusList;

implementation


var
  LCacheStatusList : TCacheStatusList;

function CacheStatusList : TCacheStatusList;
begin
  Result := LCacheStatusList;
end;

{ TCacheStatusList }

procedure TCacheStatusList.Add(const Item: ICacheStatus);
begin
  if FList.IndexOf(Item) < 0 then
    FList.Add(Item);
end;

constructor TCacheStatusList.Create;
begin
  inherited;
  FList := TInterfaceList.Create;
end;

destructor TCacheStatusList.Destroy;
var
  i : integer;
begin
  for i := 0 to FList.Count -1 do
    FList[i] := nil;
  FList.Free;
  inherited;
end;

procedure TCacheStatusList.Update(FileNo,ClientID : Integer );
var
  i : Integer;
begin
  for i := 0 to FList.Count - 1 do
    with FList.Items[i] as ICacheStatus do
      SetFileChanged(FileNo, ClientID);
end;

Initialization
   LCacheStatusList := TCacheStatusList.Create;

Finalization
   LCacheStatusList.Free;
end.
