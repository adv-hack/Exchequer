
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Some basic classes for RichView.                }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}


unit RVClasses;

interface

{$I RV_Defs.inc}

uses Windows, {$IFDEF RICHVIEWDEF6}RTLConsts{$ELSE}Consts{$ENDIF}, Classes, SysUtils, Graphics;

{$IFDEF RICHVIEWDEF6}
{$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

type
  {
    List of TObjects. Automatically frees objects on deletion
  }
  TRVList = class (TList)
    public
      procedure Clear; {$IFDEF RICHVIEWDEF4}override;{$ENDIF}
      procedure Delete(Index: Integer);
      procedure DeleteAsPointer(Index: Integer);
      procedure SortPointers;
      function Find(FindThis: TObject; CompareProc: TListSortCompare): Integer;
      destructor Destroy; override;
  end;

  { This class is used inside TRVIndexedList }
  TRVListIndexerItem = class
    public
      Item: TObject;
      Index: Integer;
  end;
  { This class is used inside TRVIndexedList }
  TRVListIndexer = class (TRVList)
    public
      procedure Sort;
      function GetItemIndex(Item: TObject): Integer;
  end;

  { Unsorted list with fast search }
  TRVIndexedList = class (TRVList)
    private
      FIndexer: TRVListIndexer;
    public
      constructor Create;
      destructor Destroy; override;
      procedure CreateIndexer;
      function Find(Item: TObject): Integer;
  end;

  {
    List of integers
  }
  TRVIntegerList = class(TList)
    private
      function Get(Index: Integer): Integer;
      procedure Put(Index: Integer; const Value: Integer);
    public
      constructor CreateEx(Count, Value: Integer);
      constructor CreateCopy(Source:TRVIntegerList);
      procedure Sort;
      procedure InitWith(Value, Count: Integer);
      procedure Fill(Value: Integer);
      procedure Add(Value: Integer);
      function AreAllEqualTo(Value: Integer): Boolean;
      function AddUnique(Value: Integer): Integer;
      procedure Insert(Index, Value: Integer);
      procedure Assign(Source:TRVIntegerList);
      property Items[Index: Integer]: Integer read Get write Put; default;
  end;
  {
    List of TColors
  }
  TRVColorList = class (TRVIntegerList)
    public
      procedure AddUnique(Value: Integer);
  end;

  {$IFNDEF RVDONOTUSERVMEMORYSTREAM}
  {
     The same as TMemoryStream, but memory delta is customizable
    (and larger initially)
  }
  TRVMemoryStream = class(TCustomMemoryStream)
  private
    FCapacity: Longint;
    FMemory: Pointer;
    FSize, FPosition: Longint;
    procedure SetCapacity(NewCapacity: Longint);
  protected
    function Realloc(var NewCapacity: Longint): Pointer; virtual;
    procedure SetPointer(Ptr: Pointer; Size: Longint);
    property Capacity: Longint read FCapacity write SetCapacity;
  public
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(const FileName: string);
    procedure SetSize(NewSize: Longint); override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    procedure SaveToStream(Stream: TStream);
    procedure SaveToFile(const FileName: string);
    property Memory: Pointer read FMemory;
  end;
  const
    RVMemoryDelta = $40000; { Must be a power of 2 }
  {$ELSE}
  TRVMemoryStream = TMemoryStream;
  {$ENDIF}

implementation

function SortIntegers(Item1, Item2: Pointer): Integer;
begin
  Result := Integer(Item1)-Integer(Item2);
end;

function SortIndexerItems(Item1, Item2: Pointer): Integer;
begin
  Result := Integer(TRVListIndexerItem(Item1).Item)-Integer(TRVListIndexerItem(Item2).Item);
end;

{================================= TRVList ====================================}
{ Removes all items from the list. Frees all objects.                          }
procedure TRVList.Clear;
var i: Integer;
begin
   for i := 0 to Count-1 do
     TObject(Items[i]).Free;
   inherited Clear;
end;
{------------------------------------------------------------------------------}
{ Deletes the item with Index. Frees the item's object.                        }
procedure TRVList.Delete(Index: Integer);
begin
  TObject(Items[Index]).Free;
  inherited Delete(Index);
end;
{------------------------------------------------------------------------------}
{ Deletes the item Index without freeing its object.                           }
procedure TRVList.DeleteAsPointer(Index: Integer);
begin
  inherited Delete(Index);
end;
{------------------------------------------------------------------------------}
{ Destructor.                                                                  }
destructor TRVList.Destroy;
begin
  Clear;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVList.SortPointers;
begin
  Sort(SortIntegers);
end;
{------------------------------------------------------------------------------}
function TRVList.Find(FindThis: TObject; CompareProc: TListSortCompare): Integer;
var L, H, I, C: Integer;
begin
  Result := -1;
  L := 0;
  H := Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := CompareProc(Items[I], FindThis);
    if C < 0 then
      L := I + 1
    else begin
      H := I - 1;
      if C = 0 then begin
        Result := I;
        exit;
      end;
    end;
  end;
end;
{============================== TRVListIndexer ================================}
function TRVListIndexer.GetItemIndex(Item: TObject): Integer;
var L, H, I, C: Integer;
begin
  Result := -1;
  L := 0;
  H := Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := Integer(TRVListIndexerItem(Items[I]).Item)-Integer(Item);
    if C < 0 then
      L := I + 1
    else begin
      H := I - 1;
      if C = 0 then begin
        Result := I;
        exit;
      end;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVListIndexer.Sort;
begin
  inherited Sort(SortIndexerItems);
end;
{============================== TRVIndexedList ================================}
constructor TRVIndexedList.Create;
begin
  inherited;
  FIndexer := TRVListIndexer.Create;
end;
{------------------------------------------------------------------------------}
destructor TRVIndexedList.Destroy;
begin
  FIndexer.Free;
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TRVIndexedList.CreateIndexer;
var i: Integer;
    IdxItem: TRVListIndexerItem;
begin
  FIndexer.Clear;
  FIndexer.Capacity := Count;
  for i := 0 to Count-1 do begin
    IdxItem := TRVListIndexerItem.Create;
    IdxItem.Index := i;
    IdxItem.Item := Items[i];
    FIndexer.Add(IdxItem)
  end;
  FIndexer.Sort;
end;
{------------------------------------------------------------------------------}
function TRVIndexedList.Find(Item: TObject): Integer;
begin
  Result := FIndexer.GetItemIndex(Item);
end;
{============================== TRVIntegerList ================================}
{ Adds a new value                                                             }
procedure TRVIntegerList.Add(Value: Integer);
begin
  inherited Add(Pointer(Value));
end;
{------------------------------------------------------------------------------}
{ Inserts a new value                                                          }
procedure TRVIntegerList.Insert(Index, Value: Integer);
begin
  inherited Insert(Index, Pointer(Value));
end;
{------------------------------------------------------------------------------}
{ Accessing Items[Index]                                                       }
function TRVIntegerList.Get(Index: Integer): Integer;
begin
  Result := Integer(inherited Get(Index));
end;
{------------------------------------------------------------------------------}
{ Assigning Items[Index]                                                       }
procedure TRVIntegerList.Put(Index: Integer; const Value: Integer);
begin
  inherited Put(Index, Pointer(Value));
end;
{------------------------------------------------------------------------------}
{ Creates a new list with Count items having Value                             }
constructor TRVIntegerList.CreateEx(Count, Value: Integer);
begin
  inherited Create;
  Capacity := Count;
  while Count>0 do begin
    Add(Value);
    dec(Count);
  end;
end;
{------------------------------------------------------------------------------}
{ Creates a copy of Source                                                     }
constructor TRVIntegerList.CreateCopy(Source: TRVIntegerList);
begin
  inherited Create;
  Assign(Source);
end;
{------------------------------------------------------------------------------}
{ Adds Value if it does not exist in the list. In any case, returns its index  }
function TRVIntegerList.AddUnique(Value: Integer): Integer;
begin
  Result := IndexOf(Pointer(Value));
  if Result=-1 then begin
    inherited Add(Pointer(Value));
    Result := Count-1;
  end;
end;
{------------------------------------------------------------------------------}
{ Makes Self a copy of Source.                                                 }
procedure TRVIntegerList.Assign(Source: TRVIntegerList);
var i: Integer;
begin
  Clear;
  Capacity := Source.Count;
  for i := 0 to Source.Count-1 do
    Add(Source.Items[i]);
end;
{------------------------------------------------------------------------------}
{ Adds Count items equal to Value                                              }
procedure TRVIntegerList.InitWith(Value, Count: Integer);
var i: Integer;
begin
  Clear;
  Capacity := Count;
  for i := 0 to Count-1 do
    Add(Value);
end;
{------------------------------------------------------------------------------}
{ Assigns Value to all items                                                   }
procedure TRVIntegerList.Fill(Value: Integer);
var i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i] := Value;
end;
{------------------------------------------------------------------------------}
{ Ascending sort                                                               }
procedure TRVIntegerList.Sort;
begin
  inherited Sort(SortIntegers);
end;
{------------------------------------------------------------------------------}
{ Returns True if all items are equal to Value                                 }
function TRVIntegerList.AreAllEqualTo(Value: Integer): Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to Count-1 do
    if Items[i]<>Value then
      exit;
  Result := True;
end;
{================================= TRVColorList ===============================}
{ The same as in TRVIntegerList, but does not allow adding clNone.             }
procedure TRVColorList.AddUnique(Value: Integer);
begin
  if Value<>clNone then
    inherited AddUnique(Value);
end;
{=============================== TRVMemoryStream ==============================}
{$IFNDEF RVDONOTUSERVMEMORYSTREAM}
destructor TRVMemoryStream.Destroy;
begin
  Clear;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVMemoryStream.Clear;
begin
  SetCapacity(0);
  FSize := 0;
  FPosition := 0;
end;
{------------------------------------------------------------------------------}
procedure TRVMemoryStream.LoadFromStream(Stream: TStream);
var
  Count: Longint;
begin
  Stream.Position := 0;
  Count := Stream.Size;
  SetSize(Count);
  if Count <> 0 then Stream.ReadBuffer(FMemory^, Count);
end;
{------------------------------------------------------------------------------}
procedure TRVMemoryStream.LoadFromFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVMemoryStream.SetCapacity(NewCapacity: Longint);
begin
  SetPointer(Realloc(NewCapacity), FSize);
  FCapacity := NewCapacity;
end;
{------------------------------------------------------------------------------}
procedure TRVMemoryStream.SetSize(NewSize: Longint);
var
  OldPosition: Longint;
begin
  OldPosition := FPosition;
  SetCapacity(NewSize);
  FSize := NewSize;
  if OldPosition > NewSize then Seek(0, soFromEnd);
end;
{------------------------------------------------------------------------------}
function TRVMemoryStream.Realloc(var NewCapacity: Longint): Pointer;
begin
  if (NewCapacity > 0) and (NewCapacity <> FSize) then
    NewCapacity := (NewCapacity + (RVMemoryDelta - 1)) and not (RVMemoryDelta - 1);
  Result := Memory;
  if NewCapacity <> FCapacity then
  begin
    if NewCapacity = 0 then
    begin
      GlobalFreePtr(Memory);
      Result := nil;
    end else
    begin
      if Capacity = 0 then
        Result := GlobalAllocPtr(HeapAllocFlags, NewCapacity)
      else
        Result := GlobalReallocPtr(Memory, NewCapacity, HeapAllocFlags);
      if Result = nil then raise
        {$IFDEF RICHVIEWDEF5}
        EStreamError.CreateRes(@SMemoryStreamError);
        {$ELSE}
        EStreamError.Create(SMemoryStreamError);
        {$ENDIF}
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TRVMemoryStream.Write(const Buffer; Count: Longint): Longint;
var
  Pos: Longint;
begin
  if (FPosition >= 0) and (Count >= 0) then
  begin
    Pos := FPosition + Count;
    if Pos > 0 then
    begin
      if Pos > FSize then
      begin
        if Pos > FCapacity then
          SetCapacity(Pos);
        FSize := Pos;
      end;
      System.Move(Buffer, Pointer(Longint(FMemory) + FPosition)^, Count);
      FPosition := Pos;
      Result := Count;
      Exit;
    end;
  end;
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TRVMemoryStream.Read(var Buffer; Count: Integer): Longint;
begin
  if (FPosition >= 0) and (Count >= 0) then
  begin
    Result := FSize - FPosition;
    if Result > 0 then
    begin
      if Result > Count then Result := Count;
      Move(Pointer(Longint(FMemory) + FPosition)^, Buffer, Result);
      Inc(FPosition, Result);
      Exit;
    end;
  end;
  Result := 0;
end;
{------------------------------------------------------------------------------}
procedure TRVMemoryStream.SaveToFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVMemoryStream.SaveToStream(Stream: TStream);
begin
  if FSize <> 0 then Stream.WriteBuffer(FMemory^, FSize);
end;
{------------------------------------------------------------------------------}
function TRVMemoryStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent: Inc(FPosition, Offset);
    soFromEnd: FPosition := FSize + Offset;
  end;
  Result := FPosition;
end;
{------------------------------------------------------------------------------}
procedure TRVMemoryStream.SetPointer(Ptr: Pointer; Size: Integer);
begin
  FMemory := Ptr;
  FSize := Size;
end;
{$ENDIF}

end.
