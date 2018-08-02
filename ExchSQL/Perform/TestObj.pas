unit TestObj;

interface

uses
  BtrvU2, VarConst, ExWrap1U, Windows, GlobVar, Classes, Contnrs, Recon3U,  Dialogs;

const
  I_REC_INTERVAL = 20;
  S_INVALID_KEY = 'XOXOXO';

  //Change the following to control which exchequer files are included in the test
  I_NO_OF_FILES = 5;
  I_FILES : Array[1..I_NO_OF_FILES] of Integer = (1, 2, 3, 5, 6);
  I_EXT_FILES = [2, 3, 5];

type
  TProgressProc = procedure (Sender : TObject; const sMessage : string;
                               RecCount : Integer; StatusPanel : Boolean) of Object;

  TRecAddress = Class
    RecPos : longint;
  end;

  TPerformanceTester = Class
  private
    function GetClientIDOn: Boolean;
    procedure SetClientIDOn(const Value: Boolean);
  protected
    FFileNo : Integer;
    FExLocal : TdMTExLocalPtr;
    FStartTick, FEndTick : longint;
    FTareStart, FTare : longint;
    FRepeatCount, FFileCount : Integer;
    FCID : ^ClientIdType;
    FOnProgress : TProgressProc;
    FCurrentIdx : integer;
    FKeyList : Array[1..I_NO_OF_FILES] of TStringList;
    FLockList : TobjectList;
    FThisTest : string;
    FTotalRecs : Int64;
    function GetTimeTaken: longint;
    function OpenFile : Integer;
    function CloseFile : Integer;
    procedure HandleError(Res: Integer);
    procedure DoProgress(RecCount : Integer; StatusPanel : Boolean = False);
    procedure StartTimer;
    procedure EndTimer;
    procedure LoadKeyList;
    procedure ClearKeyLists;
    procedure StartTare;
    procedure EndTare;
    function KeyListNoFromFileNo(AFileNo : Integer) : integer;

    //Tests
    procedure OpenCloseFile;
    procedure GetStat;
    procedure First(BFunc : integer);
    procedure FirstNext(BFirstFunc, BNextFunc : Integer);
    procedure GetRecord(BFunc : integer);
    procedure GetNonExistent;
    procedure GetPosition;
    procedure GetRecordDirect;

    procedure SingleLock;
    procedure SingleUnlock;
    procedure MultipleLock;
    procedure MultipleUnlock;

    procedure Add;
    procedure Update;
    procedure Delete;

    procedure GetExtended(BFunc : Integer);

    function StartTrans : integer;
    function EndTrans : integer;
    function AbortTrans : integer;
    procedure RunTransaction(TestNo : Integer);

    procedure DoTest(TestNo : Integer);
  public
    constructor Create;
    destructor Destroy;
    procedure OpenAllFiles;
    procedure CloseAllFiles;
    procedure RunTest(TestNo : Integer);

    property FileNumber : Integer read FFileNo write FFileNo;
    property TimeTaken : longint read GetTimeTaken;
    property RepeatCount : Integer read FRepeatCount write FRepeatCount;
    property OnProgress : TProgressProc read FOnProgress write FOnProgress;
    property ClientIDOn : Boolean read GetClientIDOn write SetClientIDOn;
    property TotalRecs : Int64 read FTotalRecs;
  end;

  function TestObject : TPerformanceTester;

implementation


{ TPerformanceTester }
uses
  SysUtils, Forms, BtSupU1, ExtObj;

var
  LTestObj : TPerformanceTester;

function TestObject : TPerformanceTester;
begin
  if not Assigned(LTestObj) then
    LTestObj := TPerformanceTester.Create;

  Result := LTestObj;
end;

function TPerformanceTester.CloseFile: Integer;
begin
  Result := Close_FileCID(F[FFileNo], FCID);
end;

constructor TPerformanceTester.Create;
var
  i : integer;
begin
  FCID := nil;
  FFileCount := I_NO_OF_FILES;
  FRepeatCount := 1;
  FCurrentIdx := 0;
  for i := 1 to I_NO_OF_FILES do
    FKeyList[i] := TStringList.Create;
  FLockList := TObjectList.Create;
  FLockList.OwnsObjects := True;
end;

procedure TPerformanceTester.DoProgress(RecCount: Integer; StatusPanel : Boolean = False);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, FThisTest, RecCount, StatusPanel);
end;

procedure TPerformanceTester.DoTest(TestNo: Integer);
begin
  Case TestNo of
    0 : OpenCloseFile;
    1 : GetStat;
    2 : First(B_StepFirst);
    3 : FirstNext(B_StepFirst, B_StepNext);
    4 : First(B_StepLast);
    5 : FirstNext(B_StepLast, B_StepPrev);
    6 : First(B_GetFirst);
    7 : FirstNext(B_GetFirst, B_GetNext);
    8 : First(B_GetLast);
    9 : FirstNext(B_GetLast, B_GetPrev);
   10 : GetRecord(B_GetEq);
   11 : GetNonExistent;
   12 : GetRecord(B_GetGEq);
   13 : GetRecord(B_GetGretr);
   14 : GetRecord(B_GetLessEq);
   15 : GetRecord(B_GetLess);
   16 : GetPosition;
   17 : GetRecordDirect;
   18 : SingleLock;
   19 : SingleUnlock;
   20 : MultipleLock;
   21 : MultipleUnlock;
   22 : Add;
   23 : Update;
   24 : Delete;
   25 : GetExtended(B_GetNext);
   26 : GetExtended(B_GetPrev);
   27,
   28,
   29 : RunTransaction(TestNo);
  end;
end;

procedure TPerformanceTester.EndTimer;
begin
  FEndTick := GetTickCount;
end;

procedure TPerformanceTester.GetStat;
var
  Res : integer;
  DataBuf :  FullFileKeySpec;
begin
  FThisTest := 'Get Stat';
  DataBuf := GetFullFile_StatCId(F[FFileNo], FFileNo, FCID);
  if DataBuf.FS.RecLen = 0 then
    Res := 1
  else
    Res := 0;
  HandleError(Res);
end;

function TPerformanceTester.GetTimeTaken: longint;
begin
  Result := (FEndTick - FStartTick) - FTare;
end;

procedure TPerformanceTester.HandleError(Res: Integer);
begin
  if Res <> 0 then
    raise Exception.Create(Format('Error %d occurred during function %s - File: %s',
                            [Res, FThisTest, FileNames[FFileNo]]));
end;

procedure TPerformanceTester.OpenAllFiles;
var
  i, Res : integer;
begin
  FThisTest := 'Open all files';
  for i := 1 to FFileCount do
  begin
    FFileNo := I_FILES[i];
    Res := OpenFile;
    HandleError(Res);
  end;
end;

procedure TPerformanceTester.OpenCloseFile;
var
  Res : Integer;
begin
  FThisTest := 'Opening and closing file';
  Res := OpenFile;
  Res := CloseFile;
  HandleError(Res);
end;

function TPerformanceTester.OpenFile: Integer;
begin
  Result := Open_FileCID(F[FFileNo], Setdrive + Filenames[FFileNo], 0, FCID);
end;

procedure TPerformanceTester.RunTest(TestNo: Integer);
var
  i, FC : Integer;
begin
  FTare := 0;
  FTotalRecs := 0;
  StartTimer;
  for i := 1 to FRepeatCount do
    for FC := 1 to FFileCount do
    begin
      FFileNo := I_FILES[FC];
      DoTest(TestNo);
      DoProgress(FC);
    end;
  EndTimer;
end;

procedure TPerformanceTester.StartTimer;
begin
  FStartTick := GetTickCount;
end;

procedure TPerformanceTester.First(BFunc : Integer);
var
  Res : Integer;
  KeyS : Str255;
begin
  FThisTest := 'Get First or Last';
  Res := Find_RecCID(BFunc, F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, KeyS, FCID);
  if Res = 9 then
    Res := 0;
  HandleError(Res);
end;

procedure TPerformanceTester.FirstNext(BFirstFunc, BNextFunc : Integer);
var
  Res : Integer;
  KeyS : Str255;
  RecCount : Integer;
begin
  FThisTest := 'Get First/Next or Last/Prev';
  Res := Find_RecCID(BFirstFunc, F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, KeyS, FCID);
  RecCount := 1;
  while Res = 0 do
  begin
    DoProgress(RecCount, True);
    Res := Find_RecCID(BNextFunc, F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, KeyS, FCID);
    inc(RecCount);
  end;

  FTotalRecs := FTotalRecs + RecCount;
  if Res = 9 then
    Res := 0;

  HandleError(Res);

end;

destructor TPerformanceTester.Destroy;
var
  i, j : integer;
begin
  for j := 1 to I_NO_OF_FILES do
  begin
    for i := 0 to FKeyList[j].Count - 1 do
      if Assigned(FKeyList[j].Objects[i]) then
        FKeyList[j].Objects[i].Free;
    FKeyList[j].Free;
  end;
  FLockList.Free;
end;

procedure TPerformanceTester.LoadKeyList;
//Reads through the current file adding the keystring + Address for every 20th record to FKeyList -
//this allows us to do a getequal, etc for every 20th record
var
  Res, Res1, RecCount, FullRecCount, i, j, ThisFile : Integer;
  KeyS : Str255;
  RecPos : Longint;
  RecAddr : TRecAddress;
begin
  StartTare;
  RecCount := 0;
  FullRecCount := 0;

  for i := 1 to I_NO_OF_FILES do
  begin

    ThisFile := I_FILES[i];
    Res := Find_RecCID(B_GetFirst, F[ThisFile], ThisFile, RecPtr[ThisFile]^, FCurrentIdx, KeyS, FCID);
    while Res = 0 do
    begin
      inc(RecCount);
      inc(FullRecCount);
      if RecCount = 1 then
      begin
        RecAddr := TRecAddress.Create;
        Res1 := GetPosCID(F[ThisFile], ThisFile, RecPos, FCID);
        if Res1 = 0 then
          RecAddr.RecPos := RecPos
        else
          RecAddr.RecPos := 0;
        FKeyList[i].AddObject(KeyS, RecAddr);
      end
      else
      if RecCount = I_REC_INTERVAL then
        RecCount := 0;

      Res := Find_RecCID(B_GetNext, F[ThisFile], ThisFile, RecPtr[ThisFile]^, FCurrentIdx, KeyS, FCID);
      DoProgress(FullRecCount, True);
    end;

  end;
  EndTare;
end;

procedure TPerformanceTester.GetRecord(BFunc: integer);
var
  Res, i, ThisFile : Integer;
  KeyS : Str255;
begin
  FTotalRecs := 0;
  FThisTest := 'Get Record';
  if FKeyList[1].Count = 0 then
    LoadKeyList;
  ThisFile := KeyListNoFromFileNo(FFileNo);
  for i := FKeyList[ThisFile].Count - 1 downto 0 do
  begin
    KeyS := FKeyList[ThisFile][i];
    Res := Find_RecCID(BFunc, F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, KeyS, FCID);
    if Res = 9 then
      Res := 0;
    HandleError(Res);
    DoProgress(i, True);
  end;
  FTotalRecs := FTotalRecs + FKeyList[ThisFile].Count;
end;

procedure TPerformanceTester.GetNonExistent;
var
  Res : Integer;
  KeyS : Str255;
begin
  KeyS := S_INVALID_KEY;
  Res := Find_RecCID(B_GetEq, F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, KeyS, FCID);
end;

procedure TPerformanceTester.GetPosition;
var
  RecPos : Longint;
  Res : Integer;
  KeyS : Str255;
begin
  FThisTest := 'Get Position';
  Res := GetPosCId(F[FFileNo], FFileNo, RecPos, FCID);
  HandleError(Res);
end;

procedure TPerformanceTester.GetRecordDirect;
var
  Res, RecPos, i, ThisIdx, ThisFile : longint;
  KeyS : Str255;
  ValidIndexes : Boolean;
begin
  FThisTest := 'Get Direct';
  FCurrentIdx := 0;
  ValidIndexes := True;
  ThisIdx := 0;
  while ValidIndexes do
  begin
    if FKeyList[1].Count = 0 then
      LoadKeyList;
    ThisFile := KeyListNoFromFileNo(FFileNo);
    for i := 0 to FKeyList[ThisFile].Count - 1 do
    begin
      RecPos := (FKeyList[ThisFile].Objects[i] as TRecAddress).RecPos;
      if RecPos <> 0 then
      begin
        SetDataRecOfs(FFileNo, RecPos);
        Res := GetDirectCID(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, 0, FCID);
        HandleError(Res);
      end;
    end;
    inc(FCurrentIdx);
    Res := Find_RecCID(B_GetFirst, F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, KeyS, FCID);
    ValidIndexes := Res <> 6;
  end;
  FCurrentIdx := 0;
end;

procedure TPerformanceTester.SingleLock;
var
  Locked : Boolean;
  Res : Integer;
  RecPos : Longint;
  KeyS : Str255;
begin
  FThisTest := 'Single Lock';
  Res := Find_RecCID(B_GetFirst, F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, KeyS, FCID);
  if Res = 0 then
  begin
    Res := GetPosCID(F[FFileNo], FFileNo, RecPos, FCID);
    if Res = 0 then
    begin
      SetDataRecOfs(FFileNo, RecPos);
      Res := GetDirectCID(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIDX,
                              B_SingLock + B_SingNWLock, FCID);
    end;
  end;
  HandleError(Res);
end;

procedure TPerformanceTester.SingleUnlock;
var
  Res : Integer;
  KeyS : Str255;
begin
  FThisTest := 'Single Unlock';
  Res := Find_RecCID(B_Unlock, F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, KeyS, FCID);
  HandleError(Res);
end;

procedure TPerformanceTester.MultipleLock;
var
  Locked : Boolean;
  Res : Integer;
  RecPos : Longint;
  KeyS : Str255;
  RecAddr : TRecAddress;
begin
  FThisTest := 'Multiple Lock';
  Res := Find_RecCID(B_GetFirst, F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, KeyS, FCID);
  if Res = 0 then
  begin
    Res := GetPosCID(F[FFileNo], FFileNo, RecPos, FCID);
    RecAddr := TRecAddress.Create;
    if Res = 0 then
      RecAddr.RecPos := RecPos
    else
      RecAddr.RecPos := 0;
    FLockList.Add(RecAddr);
    SetDataRecOfs(FFileNo, RecPos);
    Res := GetDirectCID(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIDX,
                              B_MultNWLock, FCID);
  end;
  HandleError(Res);
end;

procedure TPerformanceTester.MultipleUnlock;
var
  Res : Integer;
  KeyS : Str255;
begin
  FThisTest := 'Multiple Unlock';
  with FLockList[0] as TRecAddress do
    SetDataRecOfs(FFileNo, RecPos);
  FLockList.Delete(0);
  Res := Find_RecCID(B_Unlock, F[FFileNo], FFileNo, RecPtr[FFileNo]^, -1, KeyS, FCID);
  HandleError(Res);
end;

procedure TPerformanceTester.Add;
var
  Res : Integer;
  KeyS : Str255;
begin
  FThisTest := 'Add';
  StartTare;
  Res := Find_RecCID(B_GetFirst, F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, KeyS, FCID);
  Res := Delete_RecCID(F[FFileNo], FFileNo, FCurrentIdx, FCID);
  EndTare;
  Res := Add_RecCID(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, FCID);
  HandleError(Res);
end;

procedure TPerformanceTester.Delete;
var
  Res : Integer;
  KeyS : Str255;
begin
  FThisTest := 'Delete';
  StartTare;
  Res := Find_RecCID(B_GetFirst, F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, KeyS, FCID);
  EndTare;
  Res := Delete_RecCID(F[FFileNo], FFileNo, FCurrentIdx, FCID);
  HandleError(Res);
end;

procedure TPerformanceTester.Update;
var
  Res : Integer;
  KeyS : Str255;
begin
  FThisTest := 'Update';
  StartTare;
  Res := Find_RecCID(B_GetFirst, F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, KeyS, FCID);
  EndTare;
  Res := Put_RecCID(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FCurrentIdx, FCID);
  HandleError(Res);
end;

procedure TPerformanceTester.EndTare;
begin
  FTare := FTare + (GetTickCount - FTareStart);
end;

procedure TPerformanceTester.StartTare;
begin
  FTareStart := GetTickCount;
end;

function TPerformanceTester.EndTrans : integer;
begin
  Result := Ctrl_BTransCId(B_EndTrans, FCID);
end;

function TPerformanceTester.StartTrans : integer;
begin
  Result := Ctrl_BTransCId(B_BeginTrans, FCID);
end;

function TPerformanceTester.AbortTrans : integer;
begin
  Result := Ctrl_BTransCId(B_AbortTrans, FCID);
end;


procedure TPerformanceTester.RunTransaction(TestNo: Integer);
var
  Res : Integer;
begin
  FThisTest := 'Start Transaction';
  Res := StartTrans;
  if Res = 0 then
  Try
    Case TestNo of
       27 : Add;
       28 : Update;
       29 : Delete;
    end;
    EndTrans;
  Except
    AbortTrans;
    raise;
  End;
  HandleError(Res);
end;

function TPerformanceTester.GetClientIDOn: Boolean;
begin
  Result := Assigned(FCID);
end;

procedure TPerformanceTester.SetClientIDOn(const Value: Boolean);
begin
  if Value then
  begin
    if not Assigned(FCID) then
    begin
      New(FCID);
      Prime_ClientIdRec(FCID^,'EX',1);
    end;
  end
  else
  if Assigned(FCID) then
  begin
    Dispose(FCID);
    FCID := nil;
  end;
  ClearKeyLists;
end;

procedure TPerformanceTester.CloseAllFiles;
var
  i, Res : integer;
begin
  FThisTest := 'Close all files';
  for i := 1 to FFileCount do
  begin
    FFileNo := I_FILES[i];
    Res := CloseFile;
    HandleError(Res);
  end;
end;


procedure TPerformanceTester.GetExtended(BFunc: Integer);
var
  Res, BFunc2 : Integer;
  ExtendedObj : TExtendedTestObject;
  KeyS : Str255;
begin
  if FFileNo in I_EXT_FILES then
  begin
    StartTare;
    FThisTest := 'Get Extended';
    BFunc2 := BFunc + 6; //GetNext -> GetFirst, GetPrev -> GetLast
    Res := Find_RecCID(BFunc2, F[FFileno], FFileno, RecPtr[FFileNo]^, FCurrentIdx, KeyS, FCID);
    if Res = 0 then
    Try
      Case FFileNo of
        2 : ExtendedObj := TExtendedDocTest.Create;
        3 : ExtendedObj := TExtendedDetailTest.Create;
        5 : ExtendedObj := TExtendedStockTest.Create;
      end;

      ExtendedObj.FileNo := FFileNo;
      ExtendedObj.CID := PClientIdType(FCID);
      EndTare;
      Res := ExtendedObj.FindRec(BFunc + 30, FCurrentIdx, KeyS);
      if Res in [9, 4, 60] then
        Res := 0;
      HandleError(Res);
    Finally
      ExtendedObj.Free;
    End
    else
    begin
      FThisTest := 'Get Extended (Get initial position)';
      HandleError(Res);
    end;
  end;

end;

function TPerformanceTester.KeyListNoFromFileNo(AFileNo: Integer): integer;
var
  i : integer;
begin
  for i := 1 to I_NO_OF_FILES do
    if AFileNo = I_FILES[i] then
    begin
      Result := i;
      Break;
    end;
end;

procedure TPerformanceTester.ClearKeyLists;
var
  i, j : integer;
begin
  for j := 1 to I_NO_OF_FILES do
  begin
    for i := 0 to FKeyList[j].Count - 1 do
      if Assigned(FKeyList[j].Objects[i]) then
         FKeyList[j].Objects[i].Free;

    FKeyList[j].Clear;
  end;
end;

Initialization
  LTestObj := nil;

Finalization
  LTestObj.Free;

end.
