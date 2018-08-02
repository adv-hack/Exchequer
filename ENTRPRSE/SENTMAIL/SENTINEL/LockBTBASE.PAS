unit LockBTBASE;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{base object for dealing with btrieve files.  FindRec and buildSearchKey are abstract
and need to be implemented by descendent objects}
interface

uses
  SysUtils, ElVar, Btrvu2, Windows;


type
  EBtrieveException = Class(Exception);

  TBtrieveObject = Class
  protected
    FLockPos   : longint;
    FFileOpen  : Boolean;
    FSegmented : Boolean;
    FPrefix : Char;
    FUserID   : String[UIDSize];
    FIndex    : byte;
    FFileNo   : integer; //data file
    FDataBuffer  : Array [1..MaxRecSize + 1] of Char;
    FData     : Pointer; //Pointer to appropriate data record
    FDataSize : integer; //Size of     "      "    "     "
    function FindRec(const SearchKey : string; SearchType : Byte;
                           Lock : Boolean) : SmallInt; virtual; abstract;
    procedure SetIndex(Value : Byte);
    procedure SetUserID(const Value : String);
    function GetUserID : string;
    function LockRecord : SmallInt;
    function UnlockRecord : SmallInt; virtual;
    procedure MoveDataForRead; virtual;
    procedure MoveDataForWrite;
    function BuildSearchKey(const Key : string) : ShortString; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;
    function GetEqual(const SearchKey : string; Lock : Boolean = False) : SmallInt; virtual;
    function GetGreaterThanOrEqual(const SearchKey : string; Lock : Boolean = False) : SmallInt; virtual;
    function GetFirst(Lock : Boolean = False) : SmallInt; virtual;
    function GetNext(Lock : Boolean = False) : SmallInt; virtual;
    function GetLessThan(const SearchKey : string; Lock : Boolean = False) : SmallInt; virtual;
    function GetLast(Lock : Boolean = False) : SmallInt; virtual;
    function GetPrevious(Lock : Boolean = False) : SmallInt; virtual;
    function OpenFile : SmallInt; virtual;
    function CloseFile : SmallInt; virtual;
    function Add : smallInt; virtual;
    function Delete : SmallInt; virtual;
    function Save : Smallint; virtual;
    function Cancel : Smallint; virtual;
    property Index : Byte read FIndex write SetIndex;
    property UserID : String read GetUserID write SetUserID;
  end;


implementation

uses
  GlobVar;


constructor TBtrieveObject.Create;
begin
  inherited Create;
  FIndex := 0;
  FUserID := '';
  FillChar(FDataBuffer, MaxRecSize, #0);
  FSegmented := True;
end;

destructor TBtrieveObject.Destroy;
begin
  CloseFile;
  inherited Destroy;
end;

function TBtrieveObject.GetEqual(const SearchKey : string; Lock : Boolean = False) : SmallInt;
begin
  Result := FindRec(SearchKey, B_GetEq, Lock);
end;

function TBtrieveObject.GetFirst(Lock : Boolean = False) : SmallInt;
begin
//UserID is already set, so we want to use GetGEq to get the first record of that UserID
  Result := FindRec('', B_GetGEq, Lock);
end;

function TBtrieveObject.GetLast(Lock : Boolean = False) : SmallInt;
begin
//UserID is already set, so we want to use GetLessEq to get the last record of that UserID
  Result := FindRec(#255, B_GetLessEq, Lock);
end;


function TBtrieveObject.GetGreaterThanOrEqual(const SearchKey : string;
                                               Lock : Boolean = False) : SmallInt;
begin
  Result := FindRec(SearchKey, B_GetGEq, Lock);
end;

function TBtrieveObject.GetNext(Lock : Boolean = False) : SmallInt;
begin
  Result := FindRec('', B_GetNext, Lock);
end;

function TBtrieveObject.Add : smallInt;
var
  i : integer;
  KeyS : Str255;
begin
  FIndex := 0;
  Move(FPrefix, FDataBuffer[1], 1);
  Move(FUserID[0], FDataBuffer[2], 11);
  MoveDataForWrite;
  Result := Add_rec(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex);
  if Result = 3 then
  begin
    OpenFile;
    Result := Add_rec(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex);
  end;

end;

function TBtrieveObject.Delete : SmallInt;
begin
  Result := Delete_Rec(F[FFileNo], FFileNo, FIndex);
end;


procedure TBtrieveObject.SetIndex(Value : Byte);
begin
  FIndex := Value
end;

function TBtrieveObject.Save : Smallint;
begin
  MoveDataForWrite;
  OutputDebugString(PChar('BTObject.Save ====  FileNo ' + IntToStr(FFileNo) + ' FileB ' + IntToStr(Integer(Pointer(@F[FFileNo])))));
  Result := Put_rec(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex);
end;

function TBtrieveObject.Cancel : Smallint;
begin
  UnlockRecord;
end;

procedure TBtrieveObject.SetUserID(const Value : String);
begin
  FUserID := LJVar(Value, 10);
end;

function TBtrieveObject.GetUserID : string;
begin
  Result := Trim(FUserID);
end;


function TBtrieveObject.LockRecord : Smallint;
begin
  Result := GetPos(F[FFileNo], FFileNo, FLockPos);

  if Result = 0 then
  begin
    Move(FLockPos, RecPtr[FFileNo]^, SizeOf(FLockPos));
    Result := GetDirect(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex,
                       B_SingLock + B_SingNWLock);
  end;
end;

function TBtrieveObject.UnlockRecord : Smallint;
var
  KeyS : String[255];
begin
   FillChar(KeyS, SizeOf(KeyS), #0);
   Move(FLockPos, RecPtr[FFileNo]^, SizeOf(FLockPos));
   Result := Find_Rec(B_Unlock, F[FFileNo], FFileNo, RecPtr[FFileNo]^,
                        0, KeyS);
   if Result <> 0 then
     raise EBtrieveException.Create('Error ' + IntToStr(Result) + ' unlocking record');
end;


function TBtrieveObject.OpenFile : SmallInt;
var
  OpenStatus : SmallInt;

begin
//Define 'CreateFiles' to allow the program to create blank dat files.
  OpenStatus := 0;
{$IFDEF CreateFiles}
  if not FileExists(SetDrive  + FileNames[FFileNo]) then
  begin
    OpenStatus :=
       Make_File(F[FFileNo],SetDrive + FileNames[FFileNo], FileSpecOfs[FFileNo]^,FileSpecLen[FFileNo]);
  end;
{$ENDIF}

  if OpenStatus = 0 then
  begin
    OpenStatus := Open_File(F[FFileNo], SetDrive + FileNames[FFileNo], 0);
  end;

  if OpenStatus = 0 then
    FFileOpen := True;

  Result := OpenStatus;  //if open failed then exception is raised by calling proc
end;

function TBtrieveObject.CloseFile : SmallInt;
begin
   if FFileOpen then
     Close_File(F[FFileNo]);
   FFileOpen := False;
end;

procedure TBtrieveObject.MoveDataForRead;
//Moves data from data record to FDataBuffer
begin
 Move(FData^, FDataBuffer[1], FDataSize);
 Move(FDataBuffer[2], FUserID[0], 11);
end;

procedure TBtrieveObject.MoveDataForWrite;
//Moves data from FDataBuffer to data record for writing to table
begin
  Move(FDataBuffer, FData^, FDataSize);
end;


function TBtrieveObject.GetLessThan(const SearchKey : string; Lock : Boolean = False) : SmallInt;
begin
  Result := FindRec(SearchKey, B_GetLess, Lock);
end;

function TBtrieveObject.GetPrevious(Lock : Boolean = False) : SmallInt;
begin
  Result := FindRec('', B_GetPrev, Lock);
end;


end.
