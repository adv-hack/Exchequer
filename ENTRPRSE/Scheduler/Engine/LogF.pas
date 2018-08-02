unit LogF;

interface

uses
  SyncObjs, Classes;

type
  TSchedLogFile = Class
  private
    FFilename : string;
    FFile : TextFile;
    procedure InitFile;
  public
    constructor Create(const Filename : string);
    procedure LogIt(const s : String);
  end;

  procedure DoLog(const s : string);
  procedure ThreadDoLog(const s : string);

  procedure AddInUse(const sPath, sName : string);
  procedure RemoveInUse(const sPath, sName : string);
  function AnyTasksInUse : Boolean;
  procedure ResetQueuedTasks;

var
  //Both threads will be using the log, so they must go thru the critical section
  LogLock, InUseLock : TCriticalSection;
  LogFile : TSchedLogFile;
  InUseList : TStringList;

implementation

uses
  SysUtils, FileUtil, DataObjs;

{ TSchedLogFile }

constructor TSchedLogFile.Create(const Filename: string);
begin
  inherited Create;
  FFilename := Filename;
  AssignFile(FFile, Filename);
  if not FileExists(Filename) then
    InitFile;
end;

procedure TSchedLogFile.InitFile;
begin
  AssignFile(FFile, FFilename);
  Rewrite(FFile);
  WriteLn(FFile, 'Exchequer Scheduler Log File');
  WriteLn(FFile, '============================');
  WriteLn(FFile, ' ');
  CloseFile(FFile);
end;

procedure TSchedLogFile.LogIt(const s: String);
begin

  if not FileExists(FFilename) then //may have been deleted
    InitFile;

  Append(FFile);

  WriteLn(FFile, FormatDateTime('dd/mm/yyyy hh:nn', Now) + '> ' + s);
  CloseFile(FFile);
end;

procedure DoLog(const s : string);
begin
  LogLock.Enter;
  LogFile.LogIt(s);
  LogLock.Leave;
end;

procedure ThreadDoLog(const s : string);
begin
  LogLock.Enter;
  LogFile.LogIt(s);
  LogLock.Leave;
end;

procedure AddInUse(const sPath, sName : string);
begin
  InUseLock.Enter;
  InUseList.Add(sPath + '|' + sName);
  InUseLock.Leave;
end;

procedure RemoveInUse(const sPath, sName : string);
var
  i : integer;
  s : string;
begin
  s := sPath + '|' + sName;
  InUseLock.Enter;
  i := InUseList.IndexOf(s);
  if i >= 0 then
    InUseList.Delete(i);
  InUseLock.Leave;
end;

function AnyTasksInUse : Boolean;
begin
  Result := InUseList.Count > 0;
end;

procedure ResetQueuedTasks;
var
  sPath, sName : string;
  i : integer;

  procedure ParsePathAndTaskString(const s : string);
  var
    j : integer;
  begin
    j := Pos('|', s);
    sPath := Copy(s, 1, j - 1);
    sName := Copy(s, j+1, Length(s));
  end;

begin
  for i := 0 to InUseList.Count - 1 do
  begin
    ParsePathAndTaskString(InUseList[i]);
    TaskObject.ResetTask(sPath, sName);
  end;
end;

Initialization
  LogLock := TCriticalSection.Create;
  InUseLock := TCriticalSection.Create;
  LogFile := TSchedLogFile.Create(GetEnterpriseDirectory + 'LOGS\Schedule.log');
  InUseList := TStringList.Create;
  InUseList.Sorted := True;
  InUseList.Duplicates := dupIgnore;

Finalization
  LogLock.Free;
  LogFile.Free;
  InUseList.Free;
  InUseLock.Free;
end.
