unit AllcBase;

interface

uses
  DataModule, SQLUtils, Enterprise01_TLB, ComObj, Classes;

type
  TCoCodeObj = Class
    CoCode  : string[6];
    CoDir   : string[50];
  end;

  {$I ExdllBt.inc}

var
  oToolkit : IToolkit;
//  bSQL : Boolean;

  procedure LoadCompanyList(AList : TStrings);
  procedure StartToolkit;

  function OpenFile : Integer;
  procedure CloseFile;
  function AddRec : Integer;
  function PutRec : Integer;
  function DeleteRec : Integer;

  function FindRec(var SearchKey : ShortString; SearchType : Byte;
                     Lock : Boolean = False) : SmallInt;
  function UnlockRecord : Smallint;

//  procedure CreateTestFile;
  function LJVar(const s : string; i : integer) : string;

var
  FIndex : integer = 0;

implementation

uses
  SecCodes, SysUtils, GlobVar, BtrvU2, AllocVar, Dialogs;

var
  FLockPos : longint;

function LJVar(const s : string; i : integer) : string;
begin
  Result := Copy(s + StringOfChar(' ', i), 1, i);
end;


procedure StartToolkit;
var
  a, b, c : longint;

begin
  oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
  if Assigned(oToolkit) then
  begin
    EncodeOpCode(97, a, b, c);
    oToolkit.Configuration.SetDebugMode(a, b, c);
  end
  else
    raise Exception.Create('Unable to create COM Toolkit');
end;

procedure LoadCompanyList(AList : TStrings);
var
  i : integer;
  CodeObj : TCoCodeObj;
begin
  with oToolkit do
  for i := 1 to Company.cmCount do
  begin
    CodeObj := TCoCodeObj.Create;

    CodeObj.CoCode := Company.cmCompany[i].coCode;
    CodeObj.CoDir := Company.cmCompany[i].coPath;

    AList.AddObject(Trim(Company.cmCompany[i].coName), CodeObj);
  end;
end;

function OpenFile : Integer;
begin
  if bSQL then
  begin
    // MS-SQL
    ShowMessage('MS_SQL');
  end
  else
  begin
    // Pervasive
    Result := 0;

  {$IFDEF MAKEFILE}
    if not FileExists(FileNames[AllocF]) then
      Result := Make_File(F[AllocF],FileNames[AllocF], FileSpecOfs[AllocF]^,FileSpecLen[AllocF]);
  {$ENDIF}

    if Result = 0 then
      Result := Open_File(F[AllocF], FileNames[AllocF], 0)
    else
      ShowMessage('Unable to open file Alloc.Dat');
  end;{if}
end;

procedure CloseFile;
begin
  Close_File(F[AllocF]);
end;

function AddRec : Integer;
begin
  Result := Add_rec(F[AllocF], AllocF, RecPtr[AllocF]^, FIndex);
end;

function DeleteRec : integer;
begin
  Result := Delete_Rec(F[AllocF], AllocF, FIndex);
end;

function PutRec : integer;
begin
  Result := Put_rec(F[AllocF], AllocF, RecPtr[AllocF]^, FIndex);
end;

function LockRecord : Smallint;
begin
  Result := GetPos(F[AllocF], AllocF, FLockPos);

  if Result = 0 then
  begin
    Move(FLockPos, RecPtr[AllocF]^, SizeOf(FLockPos));
    Result := GetDirect(F[AllocF], AllocF, RecPtr[AllocF]^, FIndex,
                       B_SingLock + B_SingNWLock);
  end;
end;

function UnlockRecord : Smallint;
var
  KeyS : String[255];
begin
   FillChar(KeyS, SizeOf(KeyS), #0);
   Move(FLockPos, RecPtr[AllocF]^, SizeOf(FLockPos));
   Result := Find_Rec(B_Unlock, F[AllocF], AllocF, RecPtr[AllocF]^,
                        0, KeyS);
end;

function FindRec(var SearchKey : ShortString; SearchType : Byte;
                                       Lock : Boolean = False) : SmallInt;
//Find record and load into data buffer
var
  KeyS : string[255];
  TempString : string[6];
begin
  FillChar(AllocRec, SizeOf(AllocRec), #0);
  KeyS := SearchKey;
  Result := Find_Rec(SearchType, F[AllocF],AllocF,RecPtr[AllocF]^, FIndex, KeyS);
  SearchKey := KeyS;

  //Get lock if necessary
  if Lock and (Result = 0) then
    Result := LockRecord;
end;

{
procedure CreateTestFile;
var
  Res : integer;
begin
  Res := OpenFile;

  if Res = 0 then
  with AllocRec do
  begin
    CoCode := 'ZZZZ01';
    GLCode := 52010;
    LinePos := 1;
    AllocType := 0;
    AllocName := UpperCase(LJVar('Blah blah', 20));
    CC := 'AAA';
    Dep := 'AAA';
    Percentage := 100;
    StopKey := '!';

    Res := AddRec;

    if Res <> 0 then
      ShowMessage('Add: ' + IntToStr(Res));

  end
  else
    ShowMessage('Create: ' + IntToStr(Res));

end;
}

end.
