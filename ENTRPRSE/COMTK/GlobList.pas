unit globlist;

interface

uses
  ExBtTh1U, Classes;

const
  MaxGlobalBtrListItems = 99;

Type
  TCtkTdPostExLocalPtr = ^TCtkTdPostExLocal;
  TCtkTdPostExLocal = Object(TdPostExLocal)
    constructor Create(CIdNo  :  SmallInt);
    destructor Destroy;
  end;


  TGlobalBtrList = Class
  private
    FItems : Array[1..MaxGlobalBtrListItems] of TList;
    procedure RemoveAll;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Index: Integer; Value : TCtkTdPostExLocalPtr);
    procedure Remove(Index: Integer; ExLocal : TCtkTdPostExLocalPtr);
    procedure CloseAll;
  end;

var
  GlobalBtrList : TGlobalBtrList;

implementation

uses
  SysUtils;

Constructor TCtkTdPostExLocal.Create(CIdNo  :  SmallInt);

Begin
  //Btr adds iteslf to the global list
  Inherited Create(CIdNo);

  GlobalBtrList.Add(CIdNo, @Self);
end;

Destructor TCtkTdPostExLocal.Destroy;
var
  i : integer;
Begin
  //checks global list and if there calls remove which calls close_files. If not there then
  //files have already been closed by CloseToolkit.
  i := ExClientID^.TaskId;
{  if Assigned(GlobalBtrList.Items[i]) {and (GlobalBtrList.Items[i] = @Self) then}
  GlobalBtrList.Remove(i, @Self);

  Inherited Destroy;
end;



{ TGlobalBtrList }

procedure TGlobalBtrList.Add(Index: Integer; Value: TCtkTdPostExLocalPtr);
begin
  if (Index > 0) and (Index <= MaxGlobalBtrListItems)  then
    FItems[Index].Add(Value)
  else
    raise Exception.Create('Index out of range (' + IntToStr(Index) + ')' );
end;


procedure TGlobalBtrList.CloseAll;
var
  i : integer;
begin
  //Call close files on all assigned btrIntfs and set all array members to nil

{  for i := 1 to MaxGlobalBtrListItems do
    Remove(i, nil);}
//Changed 15/9/04 to call removeall, as this function was doing nothing at all
  RemoveAll;
end;

procedure TGlobalBtrList.Remove(Index: Integer; ExLocal : TCtkTdPostExLocalPtr);
var
  ListLocal : TCtkTdPostExLocalPtr;
  i : integer;
begin
//Close files of BtrIntf and set array member to nil
  if Assigned(Self) then
  if Assigned(FItems[Index]) then
  begin
    if Assigned(ExLocal) then
    begin
      for i := 0 to FItems[Index].Count - 1 do
        if ExLocal = FItems[Index][i] then
        begin
          if FItems[Index].Count = 1 then
             TCtkTdPostExLocalPtr(FItems[Index][i]).Close_Files;
          FItems[Index].Remove(ExLocal);
          Break;
        end;
    end;
  end;
end;

constructor TGlobalBtrList.Create;
var
  i : integer;
begin
  inherited Create;
  for i := Low(FItems) to High(FItems) do
    FItems[i] := TList.Create;
end;

procedure TGlobalBtrList.RemoveAll;
var
  i, j : integer;
begin
  for i := Low(FItems) to High(FItems) do
  begin
    for j := 0 to FItems[i].Count - 1 do
      if Assigned(FItems[i][j]) then
      begin
        TCtkTdPostExLocalPtr(FItems[i][j])^.Close_Files;
//        Break;
      end;

    FItems[i].Clear;
  end;
end;

destructor TGlobalBtrList.Destroy;
var
  i : integer;
begin
  for i := Low(FItems) to High(FItems) do
    FItems[i].Free;
  inherited Destroy;
end;


Initialization

  GlobalBtrList := TGlobalBtrList.Create;

Finalization
  FreeAndNil(GlobalBtrList);

end.
