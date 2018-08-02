unit CRECache;

interface

uses
  Classes, VarConst, BtrvU2;

type
  TCRECacheRecord = Class
    pData : Pointer;
    iSize : Integer;
    destructor Destroy; override;
  end;

  TCRECache = Class
  private
    FList : TStringList;
    FEnabled : Boolean;
    FMaxSize,
    FCurrentSize : Cardinal;
    function BuildKeyString(const KeyR     :  ShortString;
                        FileNum,KeyPath
                                 :  Byte) : ShortString;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Find(const KeyR     :  string;
                        FileNum,KeyPath
                                 :  Byte;
                        pDataRec : Pointer) : Boolean;
    procedure Add(const KeyR     :  string;
                        FileNum,KeyPath
                                 :  Byte;
                        pDataRec : Pointer);

    property Enabled : Boolean read FEnabled write FEnabled;
    property MaxSize : Cardinal read FMaxSize write FMaxSize;
  end;

  procedure StartCRECache;
  procedure EndCRECache;
  procedure ClearCRECache;

var
  oCRECache : TCRECache;

implementation

const

  MAX_CACHED_RECORDS = 100;
  MAX_CACHE_SIZE = 100000;

procedure StartCRECache;
begin
  oCRECache.Enabled := True;
end;

procedure EndCRECache;
begin
  oCRECache.Enabled := False;
end;

procedure ClearCRECache;
begin
  oCRECache.Clear;
end;


{ TCRECache }

procedure TCRECache.Add(const KeyR: string; FileNum, KeyPath: Byte;
  pDataRec: Pointer);
var
  oDataRec : TCRECacheRecord;
begin
  if FEnabled then
  begin    //PR: 28/05/2010 Change to clear list when it reaches a certain size (defined above.)
    if (FCurrentSize > MAX_CACHE_SIZE) or
       (FList.Count >  MAX_CACHED_RECORDS) then
       Clear;
    oDataRec := TCRECacheRecord.Create;
    oDataRec.iSize := FileRecLen[FileNum];
    GetMem(oDataRec.pData, oDataRec.iSize);
    Move(pDataRec^, oDataRec.pData^, oDataRec.iSize);
    FList.AddObject(BuildKeyString(KeyR, FileNum, KeyPath), oDataRec);
    FCurrentSize := FCurrentSize + Cardinal(oDataRec.iSize);
  end;
end;

function TCRECache.BuildKeyString(const KeyR: ShortString; FileNum,
  KeyPath: Byte): ShortString;
begin
  Result := Char(FileNum) + Char(KeyPath) + KeyR;
end;

procedure TCRECache.Clear;
var
  i : Integer;
begin
  for i := 0 to FList.Count - 1 do
    FList.Objects[i].Free;
  FList.Clear;
  FCurrentSize := 0;
end;

constructor TCRECache.Create;
begin
  inherited;
  FList := TStringList.Create;
  FList.Sorted := True;
  FList.Duplicates := dupIgnore;
  FCurrentSize := 0;
  FEnabled := True;
end;

destructor TCRECache.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;


function TCRECache.Find(const KeyR: string; FileNum, KeyPath: Byte;
  pDataRec: Pointer): Boolean;
var
  i : Integer;
begin
  i := FList.IndexOf(BuildKeyString(KeyR, FileNum, KeyPath));
  Result := i >= 0;
  if Result then
    with FList.Objects[i] as TCRECacheRecord do
      Move(pData^, pDataRec^, iSize);
end;

{ TCRECacheRecord }

destructor TCRECacheRecord.Destroy;
begin
  FreeMem(pData, iSize);
  inherited Destroy;
end;

Initialization
  oCRECache := TCRECache.Create;

Finalization
  oCRECache.Free;

end.
