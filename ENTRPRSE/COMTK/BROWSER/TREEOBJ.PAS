unit treeobj;

interface

uses
  ComCtrls, Classes, Dialogs;

const
  MaxSubs = 64000;

type
  PInterfaceSubItem = ^TInterfaceSubItem;
  TInterfaceSubItem = Record
    Index,
    ParentIndex   : longint;
    IsNode  : Boolean;
    IndLevel : Word;
    ParentPtr : Pointer;
    Caption : string[50];
    Value   : string[100];
    ParentGUID : string[100];
    TypeStr : string[40];
    DocString : string[255];
  end;

  SubItemArray = Array[0..MaxSubs - 1] of PInterfaceSubItem;

  TInterfaceTreeObject = Class
    CurrentParent : longint;
    Items : SubItemArray;
    ItemCount : longint;
    StateList : TList;
    FRoot : string;
    InArray : Boolean;
    CurrentDoc : string;
    constructor Create;
    destructor Destroy; override;
    function AddItem(const ACaption, AValue, AGuid, TypeS : string;
                           Level : word; const ParentAddr : Pointer) : longint;
    function AddParentedItem(const ACaption, AValue, AGuid, TypeS : string;
                           Level : word; const ParentAddr : Pointer; PID : longint) : longint;
    function ShowBranch(TheList : TListView; Item : TListItem; GUIDFirst : Boolean) : Word;
    procedure AddState(const index : Pointer);
    procedure RemoveState(const index : Pointer);
    function CurrentParentCaption(Level : integer) : string;
    function ItemType(const Item : TListItem) : string;
    function ItemDoc(const Item : TListItem) : string;
    function ParentType(const Item : TListItem; const DefaultParent : string) : string;
    function GetTypeString(i : longint) : string;
    function GetDocString(i : longint) : string;
    procedure Clear;
    function ItemInterfaceAddress(const Item : TListItem) : Pointer;
    function InterfaceAddress(i : longint) : Pointer;
    procedure WriteToFile(const FName:  string);
  end;


implementation

uses
  SysUtils;

constructor TInterfaceTreeObject.Create;
var
  i : integer;
begin
  inherited Create;
  StateList := TList.Create;
  ItemCount := 1;
  InArray := False;
  for i := 0 to MaxSubs - 1 do
    Items[i] := nil;
end;

destructor TInterfaceTreeObject.Destroy;
var
  i : longint;
begin
  for i := 0 to ItemCount - 1 do
   if Assigned(Items[i]) then
   begin
    Items[i]^.ParentPtr := nil;
    Dispose(Items[i]);
   end;

  if Assigned(StateList) then
    StateList.Free;
  inherited Destroy;
end;

procedure TInterfaceTreeObject.Clear;
var
  i : integer;
begin
  for i := 0 to ItemCount - 1 do
   if Assigned(Items[ItemCount]) then
   begin
      Items[ItemCount]^.ParentPtr := nil;
      Dispose(Items[ItemCount]);
      Items[ItemCount] := nil;
   end;
  ItemCount := 1;
  InArray := False;
  CurrentParent := 0;
 { StateList.Clear;}
  FRoot := '';
end;

function TInterfaceTreeObject.AddItem(const ACaption, AValue, AGuid, TypeS : string;
                                            Level : word; const ParentAddr : Pointer) : longint;
begin
  New(Items[ItemCount]);
  with Items[ItemCount]^ do
  begin
    Caption := ACaption;
    Value := AValue;
    ParentGUID := AGuid;
    TypeStr := TypeS;
    IndLevel := Level;
    //if this is an array then we don't reset current parent - array members
    //are added using AddParentedItem.
    IsNode := (Value[1] = '[');
    ParentIndex := CurrentParent;
    Index := ItemCount;
    ParentPtr := ParentAddr;
    DocString := CurrentDoc;
    if IsNode  and (Value <> '[ Array ]') then
      CurrentParent := ItemCount;
  end;
  Result := ItemCount;
  inc(ItemCount);
  if ItemCount > MaxSubs then
  begin
    raise ERangeError.Create('Too many properties for data array');
  end;
end;

function TInterfaceTreeObject.AddParentedItem(const ACaption, AValue, AGuid, TypeS : string;
                                         Level : word; const ParentAddr : Pointer; PID : longint) : longint;
begin
  New(Items[ItemCount]);
  with Items[ItemCount]^ do
  begin
    Caption := ACaption;
    Value := AValue;
    ParentGUID := AGuid;
    TypeStr := TypeS;
    IndLevel := Level;
    IsNode := (Value[1] = '[') ;
    ParentIndex := PID;
    Index := ItemCount;
    ParentPtr := ParentAddr;
    DocString := CurrentDoc;
    if IsNode and (Value <> '[ Array ]') then
      CurrentParent := ItemCount;
  end;
  Result := ItemCount;
  inc(ItemCount);
  if ItemCount > MaxSubs then
  begin
    raise ERangeError.Create('Too many properties for data array');
  end;
end;


function TInterfaceTreeObject.ShowBranch(TheList : TListView;
                                         Item : TListItem; GUIDFirst : Boolean) : Word;
var
  i, d : longint;
  Level : word;
begin
  Result := 0;
  Level := Item.Indent + 1;
  d := longint(Item.Data);
  for i := ItemCount - 1 downto 0 do
  begin
   if Assigned(Items[i]) then
    if (Items[i]^.ParentIndex = d) and ((Item.SubItems[0] <> '[Array]') or(Items[i]^.IndLevel = Level)) then
      with TheList.Items.Insert(Item.Index + 1) do
      begin
        Caption := Items[i]^.Caption;
        Data := Pointer(i);
        SubItems.Add(Items[i]^.Value);
        if GUIDFirst then
        begin
          SubItems.Add(Items[i]^.ParentGuid);
          SubItems.Add('$' + IntToHex(longint(Items[i]^.ParentPtr),8));
        end
        else
        begin
          SubItems.Add('$' + IntToHex(longint(Items[i]^.ParentPtr),8));
          SubItems.Add(Items[i]^.ParentGuid);
        end;

        if Items[i]^.IsNode then
        begin
          if Items[i]^.Value = '[ *Unassigned* ]' then
            ImageIndex := 2
          else
            ImageIndex := 0;
          Data := Pointer(Items[i]^.Index);
        end
        else
          ImageIndex := -1;
        Indent := Item.Indent + 1;
        inc(Result);
      end;
  end;
end;

procedure TInterfaceTreeObject.AddState(const index : Pointer);
begin
  if Assigned(StateList) then
    StateList.Add(index);
end;

procedure TInterfaceTreeObject.RemoveState(const index : Pointer);
var
  i : integer;
begin
  if Assigned(StateList) then
  begin
    i := StateList.IndexOf(index);
    StateList.Delete(i);
  end;
end;

function TInterfaceTreeObject.CurrentParentCaption(Level : integer) : string;
begin
  if Level = 0 then
    Result := FRoot
  else
    Result := Items[CurrentParent]^.Caption;
end;


function TInterfaceTreeObject.ItemDoc(const Item : TListItem) : string;
var
  d : longint;
begin
  Result := '';
  d := longint(Item.Data);
  if Assigned(Items[d]) then
  begin
    Result := GetDocString(d);
  end;

end;

function TInterfaceTreeObject.ItemType(const Item : TListItem) : string;
var
  d : longint;
begin
  Result := '';
  d := longint(Item.Data);
  if Assigned(Items[d]) then
  begin
    Result := GetTypeString(d);
  end;

end;


function TInterfaceTreeObject.ParentType(const Item : TListItem;
                                       const DefaultParent : string) : string;
var
  d : longint;
begin
  Result := '';
  d := longint(Item.Data);
  if Pos('[', Item.Caption) > 0 then
  begin
  //if it's an array then we want the parent of the parent
    if Assigned(Items[d]) then
      d := Items[d]^.ParentIndex;
  end;
  if Assigned(Items[d]) then
    d := Items[d]^.ParentIndex;
  if d = 0 then
    Result := DefaultParent
  else
  begin
    Result := GetTypeString(d);
  end;
end;

function TInterfaceTreeObject.GetTypeString(i : longint) : string;
begin
    if Assigned(Items[i]) then
    begin
      Result := Items[i]^.TypeStr;
      if Result = 'IDispatch' then
      begin
        Result := Items[i]^.Value;
        Delete(Result, 1, 2);
        Delete(Result, Length(Result) - 1, 2);
      end;
    end
    else
      Result := '';
end;

function TInterfaceTreeObject.GetDocString(i : longint) : string;
begin
    if Assigned(Items[i]) then
      Result := Items[i]^.DocString
    else
      Result := '';
end;


function TInterfaceTreeObject.ItemInterfaceAddress(const Item : TListItem) : Pointer;
var
  i : longint;
begin
  Result := nil;
  i := Integer(Item.Data);
  if Assigned(Item) then
  begin
    if Assigned(Items[i]) then
    begin
      Result := Items[i]^.ParentPtr;
    end;
  end;

end;

function TInterfaceTreeObject.InterfaceAddress(i : longint) : Pointer;
begin
  Result := nil;
  if Assigned(Items[i]) then
  begin
    Result := Items[i]^.ParentPtr;
  end;
end;

procedure TInterfaceTreeObject.WriteToFile(const FName:  string);
var
  F : TextFile;
  i : longint;
begin
 AssignFile(F, FName);
  Rewrite(F);
  for i := 1 to ItemCount do
  with Items[i]^ do
  begin
   if Assigned(Items[i]) then
    WriteLn(F, IntToStr(i) + ': ' + Caption + ' : ' + IntToStr(Index) + ' : ' +
               IntToStr(ParentIndex));
  end;
  CloseFile(F);
{  ShowMessage('Done');}
end;



end.
