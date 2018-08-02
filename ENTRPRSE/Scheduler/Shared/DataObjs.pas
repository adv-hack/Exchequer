unit DataObjs;

interface

uses
  BtrvU2, SchedVar, SyncObjs, Dialogs, GlobVar;

type

  PClientIdType = ^ClientIdType;

  TScheduleBaseObject = Class
  protected
    FFileNo : Byte;
    FDataPath : string;
    FClientID : PClientIdType;
    FFileOpen : Boolean;
  public
    constructor Create;
    property FileNo : Byte read FFileNo write FFileNo;
    function OpenFile : Integer;
    function CloseFile : Integer;
    property DataPath : string read FDataPath write FDataPath;
    property ClientID : PClientIdType read FClientID write FClientID;
  end;

  TScheduleConfigObject = Class(TScheduleBaseObject)
  private
    FHasRecord : Boolean;
    function GetEmail: String;
    function GetEndTime: TDateTime;
    function GetStartTime: TDateTime;
    procedure SetEmail(const Value: String);
    procedure SetEndTime(const Value: TDateTime);
    procedure SetStartTime(const Value: TDateTime);
    function GetTimeStamp: TDateTime;
    procedure SetTimeStamp(const Value: TDateTime);
  public
    constructor Create;
    function GetRecord(Lock : Boolean = False) : Integer; //Only need a getfirst
    function SaveRecord(NewRec : Boolean = False) : Integer;
    function UnlockRecord : Integer;
    property StartTime : TDateTime read GetStartTime write SetStartTime;
    property EndTime : TDateTime read GetEndTime write SetEndTime;
    property EmailAddress : String read GetEmail write SetEmail;
    property HasRecord : Boolean read FHasRecord;
    property TimeStamp : TDateTime read GetTimeStamp write SetTimeStamp;
  end;

  TScheduledTaskObject = Class(TScheduleBaseObject)
  private
    FIndex : Byte;
    FKeyS : Str255;
    function GetName: string;
    function GetNextRunDue: TDateTime;
    function GetStatus: Byte;
    function GetTaskType: Char;
    procedure SetName(const Value: string);
    procedure SetNextRunDue(const Value: TDateTime);
    procedure SetStatus(const Value: Byte);
    procedure SetTaskType(const Value: Char);
    function GetDateTime(const Index: Integer): TDateTime;
    function GetDayNo: longint;
    function GetInterval: Smallint;
    function GetTaskID: string;
    procedure SetDateTime(const Index: Integer; const Value: TDateTime);
    procedure SetDayNo(const Value: longint);
    procedure SetInterval(const Value: Smallint);
    procedure SetTaskID(const Value: string);
    function GetWeekMonth: Byte;
    procedure SetWeekMonth(const Value: Byte);
    function GetTimeType: Byte;
    procedure SetTimeType(const Value: Byte);
    function GetEmail: string;
    procedure SetEmail(const Value: string);
    function GetBool(const Index: Integer): Boolean;
    function GetIncludeInPost: Int64;
    procedure SetBool(const Index: Integer; const Value: Boolean);
    procedure SetIncludeInPost(const Value: Int64);
    function GetDataRecord: TScheduledTaskRec;
    function GetCustomClassName: string;
    procedure SetCustomClassName(const Value: string);
    function GetOneTimeOnly: Boolean;
    procedure SetOneTimeOnly(const Value: Boolean);
  public
    function FindRecord(BFunc : Byte; KeyS : string; Lock : Boolean = False) : Integer;
    function AddRec(CalcNextRun : Boolean = True) : Integer;
    function PutRec(CalcNextRun : Boolean = False) : Integer;
    function DeleteRec : Integer;
    function Unlock : Integer;
    procedure Clear;
    procedure CalcNextRunDue;
    procedure ResetTask(const sPath, sName : string);
    function Restart : Boolean;
    property Name : string read GetName write SetName;
    property NextRunDue : TDateTime read GetNextRunDue write SetNextRunDue;
    property Status : Byte read GetStatus write SetStatus;
    property TaskType : Char read GetTaskType write SetTaskType;
    property TaskID : string read GetTaskID write SetTaskID;
    property DayNo : longint read GetDayNo write SetDayNo;
    property TimeOfDay   : TDateTime Index 0 read GetDateTime write SetDateTime;
    property StartTime : TDateTime Index 1 read GetDateTime write SetDateTime;
    property EndTime   : TDateTime Index 2 read GetDateTime write SetDateTime;
    property LastRun   : TDateTime Index 3 read GetDateTime write SetDateTime;
    property Interval  : Smallint read GetInterval write SetInterval;
    property WeekMonth : Byte read GetWeekMonth write SetWeekMonth;
    property TimeType : Byte read GetTimeType write SetTimeType;
    property Email : string read GetEmail write SetEmail;
    property Index : Byte read FIndex write FIndex;
    property IncludeInPost : Int64 read GetIncludeInPost write SetIncludeInPost;
    property PostProtected : Boolean Index 1 read GetBool write SetBool;
    property PostSeparated : Boolean Index 2 read GetBool write SetBool;
    property DataRecord : TScheduledTaskRec read GetDataRecord;
    property CustomClassName : string read GetCustomClassName write SetCustomClassName;
    property OneTimeOnly : Boolean read GetOneTimeOnly write SetOneTimeOnly;
  end;

  function ConfigObject : TScheduleConfigObject;
  function TaskObject   : TScheduledTaskObject;

var
  ConfigLock : TCriticalSection;


implementation

uses
  SysUtils, EtStrU, FileUtil, SQLUtils;

var
  ConfigurationObject : TScheduleConfigObject;
  ScheduledTaskObject : TScheduledTaskObject;

function ConfigObject : TScheduleConfigObject;
begin
  if not Assigned(ConfigurationObject) then
  begin
    ConfigurationObject := TScheduleConfigObject.Create;
    ConfigurationObject.FileNo := ConfigF;
  end;

  Result := ConfigurationObject;
end;

function TaskObject : TScheduledTaskObject;
begin
  if not Assigned(ScheduledTaskObject) then
  begin
    ScheduledTaskObject := TScheduledTaskObject.Create;
    ScheduledTaskObject.FileNo := TaskF;
  end;

  Result := ScheduledTaskObject;
end;


{ TScheduleBaseObject }

function TScheduleBaseObject.CloseFile : Integer;
begin
  Result := Close_FileCID(F[FFileNo], FClientID);
end;

constructor TScheduleBaseObject.Create;
begin
  inherited;
  FClientID := nil;
  FFileOpen := False;
end;

function TScheduleBaseObject.OpenFile: Integer;
var
  OpenStatus : SmallInt;
  sPath : string;
begin
  if FFileNo = TaskF then
    sPath := CompanyPath
  else
  if FFileNo = ConfigF then
    sPath := GetEnterpriseDirectory;
//Define 'CreateFiles' to allow the program to create blank dat files.
  Result := 0;
{$IFDEF CreateFiles}  // Only used in-house for creating blank files.
{$IFDEF EXSQL}
  if (not SQLUtils.TableExists(sPath + FileNames[FFileNo])) then
{$ELSE}
  If (Not FileExists(sPath + FileNames[FFileNo])) Then
{$ENDIF}
  begin
    Result :=
       Make_File(F[FFileNo],sPath + FileNames[FFileNo], FileSpecOfs[FFileNo]^,FileSpecLen[FFileNo]);
  end;
{$ENDIF}
  Try
    if Result = 0 then
    begin
      Result := Open_FileCID(F[FFileNo],sPath + FileNames[FFileNo], 0, FClientID);
      FFileOpen := Result = 0;
    end;
  Except
    on E:Exception do
    ShowMessage(E.Message);
  End;

{  if OpenStatus = 0 then
    FFileOpen := True;}

//  Result := OpenStatus;  //if open failed then exception is raised by calling proc
end;
{ TScheduleConfigObject }

function TScheduleConfigObject.SaveRecord(NewRec : Boolean = False): Integer;
begin
  if NewRec then
    Result := Add_Rec(F[FFileNo],FFileNo, ConfigRec, 0)
  else
    Result := Put_Rec(F[FFileNo],FFileNo, ConfigRec, 0);
end;

function TScheduleConfigObject.GetEmail: String;
begin
  Result := ConfigRec.scDefaultEmail;
end;

function TScheduleConfigObject.GetEndTime: TDateTime;
begin
  Result := ConfigRec.scOfflineEnd;
end;

function TScheduleConfigObject.GetRecord(Lock : Boolean = False): Integer;
var
  KeyS : Str255;
  iLock : Integer;
  Res : Integer;
begin
  if not FFileOpen then
  begin
    Res := OpenFile;
    if Res <> 0 then
      raise Exception.Create('Unable to open Scheduler configuration file ' + IntToStr(Res));
  end;

  if Lock then
    iLock := B_SingNWLock
  else
    iLock := 0;
  Result := Find_Rec(B_GetFirst + iLock, F[FFileNo],FFileNo, ConfigRec, 0, KeyS);
  if Result = 0 then
    FHasRecord := True;
end;


function TScheduleConfigObject.GetStartTime: TDateTime;
begin
  Result := ConfigRec.scOfflineStart;
end;

procedure TScheduleConfigObject.SetEmail(const Value: String);
begin
  ConfigRec.scDefaultEmail := Value;
end;

procedure TScheduleConfigObject.SetEndTime(const Value: TDateTime);
begin
  ConfigRec.scOfflineEnd := Value;
end;

procedure TScheduleConfigObject.SetStartTime(const Value: TDateTime);
begin
  ConfigRec.scOfflineStart := Value;
end;

function TScheduleConfigObject.UnlockRecord : Integer;
var
  KeyS : Str255;
begin
  Result := Find_Rec(B_UnLock, F[FFileNo],FFileNo, ConfigRec, 0, KeyS);
end;

constructor TScheduleConfigObject.Create;
begin
  inherited;
  FHasRecord := False;
  FillChar(ConfigRec, SizeOf(ConfigRec), 0);
end;

function TScheduleConfigObject.GetTimeStamp: TDateTime;
begin
  Result := ConfigRec.scTimeStamp;
end;

procedure TScheduleConfigObject.SetTimeStamp(const Value: TDateTime);
begin
  ConfigRec.scTimeStamp := Value;
end;

{ TScheduledTaskObject }

function TScheduledTaskObject.AddRec(CalcNextRun : Boolean = True): Integer;
begin
  if CalcNextRun then
    CalcNextRunDue;
  Result := Add_RecCID(F[FFileNo],FFileNo, TaskRec, FIndex, FClientID);
end;

procedure TScheduledTaskObject.Clear;
begin
  FillChar(TaskRec, SizeOf(TaskRec), 0);
end;

function TScheduledTaskObject.DeleteRec: Integer;
begin
  Result := Delete_RecCID(F[FFileNo],FFileNo, FIndex, FClientID);
end;

function TScheduledTaskObject.FindRecord(BFunc: Byte;
  KeyS: string; Lock : Boolean = False): Integer;
var
  LKeyS : Str255;
  iLock : Integer;
begin
  //PR: 04/04/2011 For GetNext & GetPrev we should be passing the KeyString from the previous call
  if BFunc in [B_GetNext, B_GetPrev] then
    LKeyS := FKeyS
  else
  Case FIndex of
    0 : LKeyS := LJVar(KeyS, 50);
    1 : LKeyS := LJVar(KeyS, 12);
  end;

  if Lock then
    iLock := B_SingNWLock
  else
    iLock := 0;

  Result := Find_RecCID(BFunc + iLock, F[FFileNo],FFileNo, TaskRec, FIndex, LKeyS, FClientID);

  FKeyS := LKeyS;
end;

function TScheduledTaskObject.GetDateTime(const Index: Integer): TDateTime;
begin
  Result := 0;
  Case Index of
    0 : Result := TaskRec.stTimeOfDay;
    1 : Result := TaskRec.stStartTime;
    2 : Result := TaskRec.stEndTime;
    3 : Result := TaskRec.stLastRun;
  end;
end;

function TScheduledTaskObject.GetDayNo: longint;
begin
  Result := TaskRec.stDayNumber;
end;

function TScheduledTaskObject.GetEmail: string;
begin
  Result := TaskRec.stEmailAddress;
end;

function TScheduledTaskObject.GetInterval: Smallint;
begin
  Result := TaskRec.stInterval;
end;

function TScheduledTaskObject.GetName: string;
begin
  Result := TaskRec.stTaskName;
end;

function TScheduledTaskObject.GetNextRunDue: TDateTime;
begin
  Result := Str2DT(TaskRec.stNextRunDue);
end;

procedure TScheduledTaskObject.CalcNextRunDue;
begin
  TaskRec.stNextRunDue := DT2Str(FindNextRunDue(TaskRec));
end;

function TScheduledTaskObject.GetStatus: Byte;
begin
  Result := TaskRec.stStatus;
end;

function TScheduledTaskObject.GetTaskID: string;
begin
  Result := TaskRec.stTaskID;
end;

function TScheduledTaskObject.GetTaskType: Char;
begin
  Result := TaskRec.stTaskType;
end;

function TScheduledTaskObject.GetTimeType: Byte;
begin
  Result := TaskRec.stTimeType;
end;

function TScheduledTaskObject.GetWeekMonth: Byte;
begin
  Result := TaskRec.stScheduleType;
end;

function TScheduledTaskObject.PutRec(CalcNextRun : Boolean = False): Integer;
begin
  if CalcNextRun then
    CalcNextRunDue;
  Result := Put_RecCID(F[FFileNo],FFileNo, TaskRec, FIndex, ClientID);
end;

procedure TScheduledTaskObject.SetDateTime(const Index: Integer;
  const Value: TDateTime);
begin
  Case Index of
    0 : TaskRec.stTimeOfDay := Value;
    1 : TaskRec.stStartTime := Value;
    2 : TaskRec.stEndTime := Value;
    3 : TaskRec.stLastRun := Value;
  end;
end;

procedure TScheduledTaskObject.SetDayNo(const Value: longint);
begin
  TaskRec.stDayNumber := Value;
end;

procedure TScheduledTaskObject.SetEmail(const Value: string);
begin
  TaskRec.stEmailAddress := Value;
end;

procedure TScheduledTaskObject.SetInterval(const Value: Smallint);
begin
  TaskRec.stInterval := Value
end;

procedure TScheduledTaskObject.SetName(const Value: string);
begin
  TaskRec.stTaskName := LJVar(Value, 50);
end;

procedure TScheduledTaskObject.SetNextRunDue(const Value: TDateTime);
begin
  TaskRec.stNextRunDue := DT2Str(Value);
end;

procedure TScheduledTaskObject.SetStatus(const Value: Byte);
begin
  TaskRec.stStatus := Value;
end;

procedure TScheduledTaskObject.SetTaskID(const Value: string);
begin
  TaskRec.stTaskID := Value;
end;

procedure TScheduledTaskObject.SetTaskType(const Value: Char);
begin
  TaskRec.stTaskType := Value;
end;

procedure TScheduledTaskObject.SetTimeType(const Value: Byte);
begin
  TaskRec.stTimeType := Value;
end;

procedure TScheduledTaskObject.SetWeekMonth(const Value: Byte);
begin
  TaskRec.stScheduleType := Value;
end;

function TScheduledTaskObject.Unlock: Integer;
var
  KeyS : Str255;
begin
  Result := Find_RecCID(B_Unlock, F[TaskF], TaskF, TaskRec, 0, KeyS, FClientID);
end;

function TScheduledTaskObject.GetBool(const Index: Integer): Boolean;
begin
  Result := False;
  Case Index of
    1  : Result := TaskRec.stPostProtected;
    2  : Result := TaskRec.stPostSeparated;
  end;
end;

function TScheduledTaskObject.GetIncludeInPost: Int64;
begin
  Result := TaskRec.stIncludeInPost;
end;

procedure TScheduledTaskObject.SetBool(const Index: Integer;
  const Value: Boolean);
begin
  Case Index of
    1  : TaskRec.stPostProtected := Value;
    2  : TaskRec.stPostSeparated := Value;
  end;
end;

procedure TScheduledTaskObject.SetIncludeInPost(const Value: Int64);
begin
  TaskRec.stIncludeInPost := Value;
end;

function TScheduledTaskObject.GetDataRecord: TScheduledTaskRec;
begin
  Result := TaskRec;
end;

procedure TScheduledTaskObject.ResetTask(const sPath, sName: string);
var
  Res : Integer;
begin
  FDataPath := sPath;
  OpenFile;
  Res := FindRecord(B_GetEq, sName);
  if Res = 0 then
  begin
    TaskRec.stStatus := tsIdle;
    PutRec;
  end;
end;

function TScheduledTaskObject.GetCustomClassName: string;
begin
  Result := TaskRec.stCustomClassName;
end;

procedure TScheduledTaskObject.SetCustomClassName(const Value: string);
begin
  TaskRec.stCustomClassName := Value;
end;

function TScheduledTaskObject.GetOneTimeOnly: Boolean;
begin
  Result := TaskRec.stOneTimeOnly;
end;

procedure TScheduledTaskObject.SetOneTimeOnly(const Value: Boolean);
begin
  TaskRec.stOneTimeOnly := Value;
end;

function TScheduledTaskObject.Restart : Boolean;
begin
  Result := True;
  Inc(TaskRec.stRestartCount);
  if TaskRec.stRestartCount > 3 then
  begin
    Result := False;
    TaskRec.stRestartCount := 0;
    TaskRec.stStatus := tsError;
  end
  else
    TaskRec.stStatus := tsIdle;
  PutRec;
end;

Initialization
  ConfigurationObject := nil;
  ScheduledTaskObject := nil;
  ConfigLock := TCriticalSection.Create;

Finalization
  if Assigned(ConfigurationObject) then
    ConfigurationObject.Free;

  if Assigned(ScheduledTaskObject) then
    ScheduledTaskObject.Free;

  ConfigLock.Free;
end.
