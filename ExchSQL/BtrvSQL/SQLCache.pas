unit SQLCache;

interface

{This unit provides a system to allow files to be set as 'dirty' when they have been updated by one clientId, allowing other clientIDs to refresh their
cache on the their next read.

The structure is as follows:

The CacheList object contains 3 lists:

  FList contains a list of pointers to the File position blocks for all open files in any client id

  FObjectList contains a list of objects of type TSQLCacheRecord. This list is synchronised to FList, so that we can find the index of
  a pos block pointer in FList and the index no returned will give us the equivalent object in FObjectList. This will then give us
  the ClientId, Filename and IsDirty status of the pos block.

  When a record in any file is altered, then the CacheList must find any pos blocks which also have the file open and set their status to dirty.
  When a record is to be read, then the CacheList must check the dirty status of the pos block and flush the cache if necessary.

  To speed up these functions, FIndexList is a stringlist containing the names of the files that have been opened, with the equivalent Object
  for each string being a TList which contains the pos block pointers which have been used to open the file specified by the string.

The CacheList will only be used if a program turns it on by calling the exported function UseSQLCacheList}

uses
  Classes;

  procedure CheckCacheList(Operation : Integer; var pFileVar; var pKeyBuf; var pClientID); overload;
  procedure CheckCacheList(Operation : Integer; var pFileVar; var pKeyBuf); overload;
  procedure UseSQLCacheList; export;

  Procedure Finalize_SQLCache;


implementation

uses
  BtrvU2, Contnrs, BtrvSQLU;

const
  B_Delete = 4;

type

  PClientIDType = ^ClientIDType;

  TSQLCacheRecord = Class
    ClientID : Pointer;
    FileName : AnsiString;
    IsDirty : Boolean;
  end;

  TSQLCacheList = Class
  private
    FList : TList;
    FObjectList : TObjectList;
    FIndexList : TStringList;
    function Find(P : Pointer) : Integer;
    procedure AddIndex(const Item : TSQLCacheRecord; const sFilename : string; pFileVar : Pointer);
    procedure RemoveIndex(Index : Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const Filename : AnsiString; pFileVar, pClientID : Pointer); //Called from Open_File
    procedure Remove(pFileVar : Pointer);                                      //Called from Close_File
    procedure CheckAndUpdate(pFileVar : Pointer);                              //Called by Find_Record funcs to drop SQLCache if necessary
    procedure UpdateList(pFileVar : Pointer);                                  //Called by Update, Add, Delete to set file as dirty
                                                                               // for all registered ClientIDs
  end;

var
  SQLCacheList : TSQLCacheList;





procedure CheckCacheList(Operation : Integer; var pFileVar; var pKeyBuf; var pClientID);
begin
  if Assigned(SQLCacheList) then
  begin
    Case Operation of
      B_Open    : SQLCacheList.Add(AnsiString(PChar(@pKeyBuf)), Pointer(@pFileVar), Pointer(@pClientID));
      B_Close   : SQLCacheList.Remove(Pointer(@pFileVar));
      B_Insert,
      B_Update,
      B_Delete  : SQLCacheList.UpdateList(Pointer(@pFileVar));
      B_GetEq,
      B_GetNext,
      B_GetPrev,
      B_GetGEq,
      B_GetLessEq,
      B_GetLess,
      B_GetGretr: begin
                    if Assigned(Pointer(@pClientID)) then
                    begin   // Currently we're only using this for COM Tk functions - identified by 'TK' AppID in the ClientID.
                      if ClientIDType(pClientID).AppID = 'TK' then
                        SQLCacheList.CheckAndUpdate(Pointer(@pFileVar));
                    end;
                  end;
    end //Case
  end;

end;

procedure CheckCacheList(Operation : Integer; var pFileVar; var pKeyBuf);
var
  pClientID : Pointer;
begin
  pClientID := nil;
  CheckCacheList(operation, pFileVar, pKeyBuf, pClientID);
end;

procedure UseSQLCacheList;
begin
  if not Assigned(SQLCacheList) then
    SQLCacheList := TSQLCacheList.Create;
end;


{ TSQLCacheList }

procedure TSQLCacheList.Add(const Filename: AnsiString; pFileVar,
  pClientID: Pointer);
var
  oSQLCacheRecord : TSQLCacheRecord;
begin
  oSQLCacheRecord := TSQLCacheRecord.Create;

  oSQLCacheRecord.Filename := Filename;
  oSQLCacheRecord.ClientID := pClientID;
  oSQLCacheRecord.IsDirty := False;

  FObjectList.Add(oSQLCacheRecord);
  FList.Add(pFileVar);
  AddIndex(oSQLCacheRecord, Filename, pFileVar);
end;

constructor TSQLCacheList.Create;
begin
  inherited;
  FList := TList.Create;
  FObjectList := TObjectList.Create;
  FIndexList := TStringList.Create;
end;

destructor TSQLCacheList.Destroy;
var
  i : integer;
begin
  FObjectList.Free;
  FList.Free;
  for i := 0 to FIndexList.Count - 1 do
    if Assigned(FIndexList.Objects[i]) then
      FIndexList.Objects[i].Free;
  FIndexList.Free;
  inherited;
end;

function TSQLCacheList.Find(P: Pointer): Integer;
begin
  Result := FList.IndexOf(P);
end;

procedure TSQLCacheList.CheckAndUpdate(pFileVar: Pointer);
var
  i : integer;
begin
  i := Find(pFileVar);

  if i >= 0 then
  begin
    with FObjectList[i] as TSQLCacheRecord do
    begin
      if IsDirty then
      begin
        DiscardCachedData(PChar(Filename), ClientID);
        IsDirty := False;
      end;
    end;
  end;
end;

procedure TSQLCacheList.Remove(pFileVar: Pointer);
var
  i : integer;
begin
  i := Find(pFileVar);

  if i >= 0 then
  begin
    RemoveIndex(i);
    FObjectList.Delete(i);
    FList.Delete(i);
  end;

end;

procedure TSQLCacheList.UpdateList(pFileVar: Pointer);
var
  i, j : integer;
  sFilename : string;
begin
  i := Find(pFileVar);

  if i >= 0 then
  begin
    with FObjectList[i] as TSQLCacheRecord do
      sFilename := Filename;

    i := FIndexList.IndexOf(sFilename);
    if i >= 0 then
    begin
      with FIndexList.Objects[i] as TList do
      begin
        for j := 0 to Count - 1 do
        begin
          if Items[j] <> pFileVar then
          begin
            i := FList.IndexOf(Items[j]);
            if i >= 0 then
              with FObjectList[i] as TSQLCacheRecord do
                 IsDirty := True;
          end;
        end; //for j
      end; //with FIndexList.Objects[i]
    end; //i >= 0
  end; //i >= 0

end;


procedure TSQLCacheList.AddIndex(const Item: TSQLCacheRecord;
  const sFilename: string; pFileVar: Pointer);
var
  oList : TList;
  i : integer;
begin
  i := FIndexList.IndexOf(sFilename);

  if i < 0 then
  begin
    oList := TList.Create;
    i := FIndexList.AddObject(sFilename, oList);
  end;

  with FIndexList.Objects[i] as TList do
    Add(pFileVar);
end;

procedure TSQLCacheList.RemoveIndex(Index: Integer);
var
  i : integer;
  P : Pointer;
begin
  i := FIndexList.IndexOf((FObjectList[Index] as TSQLCacheRecord).Filename);
  if i >= 0 then
  begin
    with FIndexList.Objects[i] as TList do
    begin
      i := IndexOf(FList[Index]);
      if i >= 0 then
        Delete(i);
    end;
  end;
end;


Procedure Finalize_SQLCache;
Begin // Finalize_SQLCache
  if Assigned(SQLCacheList) then
    SQLCacheList.Free;
End; // Finalize_SQLCache


initialization

  SQLCacheList := nil;

finalization
// MH 15/03/2010 v6.3: Moved into Finalize_SQLCache as getting problems with order of finalizations
//  if Assigned(SQLCacheList) then
//    SQLCacheList.Free;

end.
