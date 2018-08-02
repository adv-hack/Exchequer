unit SchedVar;

interface
{$ALIGN 1}
uses
  GlobVar, BtrvU2,
//PR: 15/08/2012 Added conditional define to keep toolkit out of SQL conversion
{$IFNDEF SQLConversion}
  {$IFDEF SCHEDDLL}
  Enterprise04_TLB,
  {$ELSE}
   Enterprise01_TLB,
  {$ENDIF}
{$ENDIF}
  ComObj, Classes, VarConst;


const
 TaskNumOfKeys      = 3;
 TaskNumSegments    = 4;

 TaskNameIdx        = 0;
 TaskNextDueIdx     = 1;
 TaskTypeIdx        = 2;

 ConfigNumOfKeys    = 1;
 ConfigNumSegments  = 1;

 ConfigIdIdx        = 0;

 SchedulePath       = 'Schedule\';
 TaskFilename       = SchedulePath + 'Schedule.dat';
 ConfigFilename     = 'SchedCfg.dat';

 TaskF      = 20;
 ConfigF    = 21;

 DaybookPostFileName = 'Posting';
 PostExceptFileName = 'Post_err';

 ttSpecific = 0;
 ttInterval = 1;
 ttIntervalBetween = 2;

 tsInactive   = 0;
 tsIdle       = 1;
 tsProcessing = 2;
 tsError      = 3;

 SchedServiceDesc = 'Runs scheduled tasks in Exchequer.';

 SchedAdminName   = 'Exchequer Scheduler';
 SchedEngineName  = 'Exchequer Scheduler';
 SchedServiceName = 'Exchequer Scheduler';

 SchedErrMessage  = 'There was a problem when running this task. The error message was:'#10#10;

 pwAllNomViews = 546;
 pwRefreshNomViews = 556;
 pwAccessViewBase = 557;

 pwPostSales   = 8;
 pwPostPurch   = 17;
 pwPostNominal = 29;
 pwPostStock   = 122;
 pwPostJob     = 216;
 pwPostTSH     = 218;

 iMonday    = 1;
 iTuesDay   = 2;
 iWednesday = 4;
 iThursday  = 8;
 iFriday    = 16;
 iSaturday  = 32;
 iSunday    = 64;

 pgTask = 0;
{$IFNDEF SCHEDDLL}
 pgDetails = 1;
 pgDay = 2;
 pgtime = 3;
 pgEmail = 4;
{$ELSE}
 pgDetails = 0;
 pgDay = 1;
 pgEmail = 2;
{$ENDIF}

 ttView = 0;
 ttSalesDaybook = 1;
 ttPurchDaybook = 2;
 ttNominalDaybook = 3;
 ttStockDaybook = 4;
 ttJobDaybook = 5;

 DocTypeFirst = SIN;
 DocTypeLast  = JPA;

 tcView = 'A';
 tcSalesDaybook = 'B';
 tcPurchDaybook = 'C';
 tcNominalDaybook = 'D';
 tcStockDaybook = 'E';
 tcJobDaybook = 'F';

 tcCustom = '@';

 tagDetails = 101;

 jpCommitment = 1;
 jpActuals = 2;
 jpTimesheets = 4;
 jpRetentions = 8;


 DayBookSet = [tcSalesDayBook, tcPurchDayBook, tcNominalDaybook, tcStockDaybook, tcJobDaybook];


type
  //Record for scheduled task. One data file per company, so don't need company id
  PScheduledTaskRec = ^TScheduledTaskRec;
  TScheduledTaskRec = Record
    stTaskType      : Char;       //Type of task 'A'-'z'.
    stTaskName      : String[50]; //Unique identifier for this task. Indexed
    stNextRunDue    : String[12]; //Date and time of next scheduled run (yyyymmddhhnn). Indexed

    stTaskID        : String[20]; //An identifier for the task to be carried out. Meaning dependent
                                  //upon type of task.

    stScheduleType  : Byte;       //Days per week/month
    stDayNumber     : longint;    //Bit-mapped - gives us days 0-31
    stTimeOfDay     : TDateTime;  //Time of day if only once a day
    stInterval      : SmallInt;   //If more than once a day then interval between
    stStartTime,
    stEndTime       : TDateTime;  //If more than once a day then start and end times.

    stStatus        : Byte;       //Inactive/Idle/Processing/Error

    stEmailAddress  : string[100];//Address to send error notification to

    stLastRun       : TDateTime;  //Date and time task was last run
    stLastUpdated   : TDateTime;  //Date and time task was last updated
    stLastUpdatedBy : String[10]; //UserID of user who updated task last
    stTimeType      : Byte;       //OnceOnly/Mins/MinsBetween
    stIncludeInPost : Int64;      //Bit specific list of DocTypes in posting run
    stPostProtected : Boolean;
    stPostSeparated : Boolean;
    stCustomClassName : string[50];
    stOneTimeOnly   : Boolean;   //PR: 15/12/2010
    stRestartCount  : Byte; //PR: 11/01/2011 Count of how many times the task has been restarted after a crash.
    Spare           : Array[1..448] of Byte;
  end;

  //Configuration Record. One file only in MCM directory
  TSchedulerConfigRec = Record
    scID            : String[10]; //Unique identifier for record - only one record at the moment
    scOfflineStart,
    scOfflineEnd    : TDateTime;  //Start and end times for offline period for backup
    scDefaultEmail  : string[100];//Email address to be used unless overridden in individual task
    scTimeStamp     : TDateTime; //PR: 15/12/2010
    Spare           : Array[1..504] of Byte;
  end;

  TaskFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..TaskNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  ConfigFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..ConfigNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

var
  TaskRec    : TScheduledTaskRec;
  TaskFile   : TaskFileDef;

  ConfigRec     : TSchedulerConfigRec;
  ConfigFile    : ConfigFileDef;

  CompanyPath : AnsiString;  //SetDrive
{$IFNDEF SQLConversion}
  oToolkit : IToolkit;
{$ENDIF}

  CurrentUser : String;
  ViewsAllowed : Array[0..9] of Boolean;
  AllViewsAllowed : Boolean;
  AnyViewsAllowed : Boolean;

procedure DefineTaskFile;
procedure DefineConfigFile;
procedure DoMessage(const s : string);
function DT2Str(dt : TDateTime) : string;
function Str2DT(const s : string) : TDateTime;
function StatusString(Status : Byte) : string;
procedure LoadNomViews(var AList : TStringList);
function TimeOnly(dt : TDateTime) : TDateTime;

function FindNextRunDue(LTaskRec : TScheduledTaskRec) : TDateTime;
function GetUserID : string;
function SetDocTypesInPost(DTypes : DocSetType) : Int64;
function GetDocTypesInPost(iDTypes : Int64) : DocSetType;
function TaskTypeString(TaskType : Char) : string;

function IsInBackupWindow(T : TDateTime) : Boolean;
function BackupWindowString : string;

function PostAllowed(Area : Integer) : Boolean;

procedure UpdateSchedulerTimeStamp;
function GetSchedulerTimeStamp : TDateTime; stdcall; export;

function SchedulerVersion : string;


implementation

uses
  Dialogs, FileUtil, SysUtils, DateUtils, ApiUtil, DataObjs, ExchequerRelease;

const
  BuildNo = '046';


function SchedulerVersion : string;
begin
  Result := ExchequerModuleVersion(emScheduler, BuildNo);
  {$IFNDEF MC_ON}
  Result := Result + 'SC';
  {$ENDIF}
end;

function IsInBackupWindow(T : TDateTime) : Boolean;
var
  t1Start, t1End : TDateTime;
  FCrossMidnight : Boolean;

begin
  ConfigLock.Enter;
  Try
  if not ConfigObject.HasRecord then
    ConfigObject.GetRecord;
  t1Start := TimeOnly(ConfigObject.StartTime);
  t1End := TimeOnly(ConfigObject.EndTime);

  FCrossMidnight := t1Start > t1End;

  T := TimeOnly(T);

  if FCrossMidnight then
    Result := (T > t1Start) or (T < t1End)
  else
    Result := (T > t1Start) and (T < t1End);
  Finally
    ConfigLock.Leave;
  End;
end;

function BackupWindowString : string;
begin
  Result := Format('(%s-%s)', [FormatDateTime('hh:nn', ConfigObject.StartTime),
                               FormatDateTime('hh:nn', ConfigObject.EndTime)]);
end;


procedure DefineTaskFile;
const
  Idx = TaskF;
begin
  FileSpecLen[Idx] := SizeOf(TaskFile);
  FillChar(TaskFile, FileSpecLen[Idx],0);

  with TaskFile do
  begin
    RecLen := Sizeof(TaskRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := TaskNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);

    //Key 0 - TaskName
    KeyBuff[1].KeyPos := BtKeyPos(@TaskRec.stTaskName[1], @TaskRec);
    KeyBuff[1].KeyLen := SizeOf(TaskRec.stTaskName) - 1;
    KeyBuff[1].KeyFlags := Modfy;

    //Key 1 - Next Run Due (yyyymmddhhnn)
    KeyBuff[2].KeyPos := BtKeyPos(@TaskRec.stNextRunDue[1], @TaskRec);;
    KeyBuff[2].KeyLen := SizeOf(TaskRec.stNextRunDue) - 1;
    KeyBuff[2].KeyFlags := DupMod;

    //Key 2 - TaskType + TaskName
    KeyBuff[3].KeyPos := BtKeyPos(@TaskRec.stTaskType, @TaskRec);
    KeyBuff[3].KeyLen := 1;
    KeyBuff[3].KeyFlags := ModSeg;


    KeyBuff[4].KeyPos := BtKeyPos(@TaskRec.stTaskName[1], @TaskRec);
    KeyBuff[4].KeyLen := SizeOf(TaskRec.stTaskName) - 1;
    KeyBuff[4].KeyFlags := Modfy;

    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(TaskRec);
  FillChar(TaskRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @TaskRec;
  FileSpecOfS[Idx] := @TaskFile;
  FileNames[Idx] := TaskFilename;
end;

procedure DefineConfigFile;
const
  Idx = ConfigF;
begin
  FileSpecLen[Idx] := SizeOf(ConfigFile);
  FillChar(ConfigFile, FileSpecLen[Idx],0);

  with ConfigFile do
  begin
    RecLen := Sizeof(ConfigRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := ConfigNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);

    //Key 0 - ConfigName
    KeyBuff[1].KeyPos := BtKeyPos(@ConfigRec.scID[1], @ConfigRec);
    KeyBuff[1].KeyLen := SizeOf(ConfigRec.scID) - 1;
    KeyBuff[1].KeyFlags := Modfy;

    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(ConfigRec);
  FillChar(ConfigRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @ConfigRec;
  FileSpecOfS[Idx] := @ConfigFile;
  FileNames[Idx] := ConfigFilename;
end;

procedure DoMessage(const s : string);
begin
  msgBox(s, mtWarning, [mbOK], mbOK, 'Exchequer Scheduler');
//  ShowMessage(s);
end;

function DT2Str(dt : TDateTime) : string;
begin
  Result := FormatDateTime('yyyymmddhhnn',dt);
end;

function Str2DT(const s : string) : TDateTime;
var
  yy, mm, dd, hh, nn : word;
  hhnn : string;
begin
  yy := StrToInt(Copy(s, 1, 4));
  mm := StrToInt(Copy(s, 5, 2));
  dd := StrToInt(Copy(s, 7, 2));
  hh := StrToInt(Copy(s, 9, 2));
  nn := StrToInt(Copy(s, 11, 2));
  Result := EncodeDateTime(yy, mm, dd, hh, nn, 0, 0);
end;

function StatusString(Status : Byte) : string;
begin
  Case Status of
    0 : Result := 'Inactive';
    1 : Result := 'Idle';
    2 : Result := 'Processing';
    3 : Result := 'Error';
  end;
end;

procedure LoadNomViews(var AList : TStringList);
var
  Res, ViewIdx : Integer;
  KeyS : Str255;
  sViewNo : string;
begin
  if AllViewsAllowed then
    AList.Add('All views');
  Res := Open_File(F[NomViewF], CompanyPath + Filenames[NomViewF], 0);
  if Res = 0 then
  begin
    Res := Find_Rec(B_GetFirst, F[NomViewF], NomViewF, RecPtr[NomViewF]^, 0, KeyS);

    while Res = 0 do
    begin
      if NomView.SubType = 'C' then
      begin
        ViewIdx := (NomView.ViewCtrl.ViewCtrlNo - 1) div 100;
        if ViewsAllowed[ViewIdx] then
        begin
          AList.Add(Format ('%.3d - %s', [NomView.ViewCtrl.ViewCtrlNo, Trim(NomView.ViewCtrl.ViewDesc)]));
        end;
      end;

      Res := Find_Rec(B_GetNext, F[NomViewF], NomViewF, RecPtr[NomViewF]^, 0, KeyS);
    end;
  end;

  Close_File(F[NomViewF]);
end;

{Function to calculate the next run from the Task Record.}
function FindNextRunDue(LTaskRec : TScheduledTaskRec) : TDateTime;
const
  iEndOfMonth = 1 shl 30;
var
  NextTime, Interval : TDateTime;
  St : Byte;
  hh, mm : Word;
  iYear, iMonth, iDay : Word;

  procedure IntervalToHoursAndMins(iInterval : Integer; var iHour : Word; var iMin : Word);
  begin
    iHour := iInterval div 60;
    iMin := iInterval - (hh * 60);
  end;

  function NextTimeDue : TDateTime;
  var
    j : integer;
  begin
    Result := 0;
    Case LTaskRec.stTimeType of
      ttSpecific        : Result := LTaskRec.stTimeOfDay;
      ttInterval        : Result := LTaskRec.stLastRun + Interval;
      ttIntervalBetween : begin
                            Result := LTaskRec.stStartTime;
                            while (Result < TimeOnly(Now)) and
                                  (Result < LTaskrec.stEndTime) do
                                    Result := Result + Interval;
                            if Result > LTaskRec.stEndTime then
                              Result := LTaskRec.stStartTime;
                          end;
    end;
  end;

  //Calculate which is the next day the task runs on. The day is held in LTaskRec.stDay number as
  //bit-specific - eg bits 0-30, when set, specify that the task runs on that day of the month (1-31)(or
  //week, when only bits 0-6 will be set.)
  function NextDayDue(StartPoint : Byte) : TDateTime;
  var
    i, iMask : longint;
    Step : Byte;
    iDay, iDaysInMonth : Word;
  begin
    Result := 0;
    Case LTaskRec.stScheduleType of
      0 : begin
            iDay := DayOfTheWeek(Date);

            iMask := 1 shl (iDay - 1 + StartPoint);
            Step := StartPoint;
            while LTaskRec.stDayNumber and iMask <> iMask do
            begin
              inc(Step);
              inc(iDay);
              if iDay > 7 then
              begin
                iDay := 1;
                StartPoint := 0;
                Dec(Step);
              end;

              iMask := 1 shl (iDay - 1 + StartPoint);
            end;
            Result := Date + Step;
          end;
      1 : begin
            iDay := DayOfTheMonth(Date);
            DecodeDate(Date, iYear, iMonth, iDay);
            iDaysInMonth := DaysInAMonth(iYear, iMonth);
            if iDay >= iDaysInMonth then
            begin
              iDay := 1;
              inc(iMonth);
              if iMonth > 12 then
              begin
                iMonth := 1;
                inc(iYear);
              end;
              iDaysInMonth := DaysInAMonth(iYear, iMonth);
            end;

            iMask := 1 shl (iDay - 1);
            Step := 0;

            if (StartPoint = 1) or (LTaskRec.stDayNumber and iMask <> iMask) then
            while LTaskRec.stDayNumber and iMask <> iMask do
            begin
              inc(Step);
              inc(iDay);
              if iDay > iDaysInMonth then
              begin //special handling to check for last day in the month
                if LTaskRec.stDayNumber and iEndOfMonth = iEndOfMonth then
                begin
                  Dec(Step);
                  Break;
                end
                else
                  iDay := 1;
              end;

              iMask := 1 shl (iDay - 1);
            end;
            Result := Date + Step;

          end;
    end; //Case
  end;

begin
  //Convert stInterval to a TDateTime
  IntervalToHoursAndMins(LTaskRec.stInterval, hh, mm);
  Interval := EncodeTime(hh, mm, 0, 0);

  NextTime := TimeOnly(NextTimeDue);

  //St is the starting point for deciding which day the next run is on. It will be 0 (for today)
  //if the next time to run is today, otherwise it will be 1 (for tomorrow)
  St := 0; //Today as default
  Case LTaskRec.stTimeType of
    ttSpecific        : if NextTime < Time then
                          St := 1;
{    ttInterval        : if TimeOnly(LTaskRec.stLastRun) + Interval < NextTime then
                          St := 1;}
    ttIntervalBetween : if TimeOnly(LTaskRec.stLastRun) + Interval > LTaskRec.stEndTime then
                          St := 1;
  end;

  Result := Trunc(NextDayDue(St)) + NextTime;

  //We now have the next day and we have the next time if it is a specific time or if it is today -
  //otherwise we need to reset the time to either stStartTime or 0:00.
  if (Trunc(Result) > Trunc(Date)) then
  begin
    case LTaskRec.stTimeType of
      ttInterval        : Result := Trunc(Result);
      ttIntervalBetween : Result := Trunc(Result) + LTaskRec.stStartTime;
    end;
  end;
end;

function GetUserID : string;
begin
  if UserProfile^.Loaded then
    Result := Trim(UserProfile^.Login)
  else
    Result := Trim(EntryRec^.Login);
end;

function TimeOnly(dt : TDateTime) : TDateTime;
//Returns time part of TDateTime
begin
  Result := dt - Trunc(dt);
end;

function SetDocTypesInPost(DTypes : DocSetType) : Int64;
var
  DT : DocTypes;
  i : Int64;
begin
  Result := 0;
  for DT := DocTypeFirst to DocTypeLast do
    if DT in DTypes then
    begin
      i := 1;
      Result := Result or (i shl Ord(DT));
    end;
end;

function GetDocTypesInPost(iDTypes : Int64) : DocSetType;
var
  DT : DocTypes;
  iMask, i : Int64;
begin
  Result := [];
  for DT := DocTypeFirst to DocTypeLast do
  begin
    i := 1;
    iMask := i shl Ord(DT);
    if iDTypes and iMask = iMask then
      Include(Result, DT);
  end;
end;

function TaskTypeString(TaskType : Char) : string;
begin
  Case TaskType of
    tcView           : Result := 'Update GL View';
    tcSalesDaybook   : Result := 'Post Sales Daybook';
    tcPurchDaybook   : Result := 'Post Purchase Daybook';
    tcNominalDaybook : Result := 'Post Nominal Daybook';
    tcStockDaybook   : Result := 'Post Stock Daybook';
    tcJobDaybook     : Result := 'Post Job Daybook';
  end;

end;

function PostAllowed(Area : Integer) : Boolean;
begin
{$IFNDEF SQLConversion}
  Result := (oToolkit.Functions.entCheckSecurity(CurrentUser, Area) = 0) or
            (Trim(CurrentUser) = 'SYSTEM');
{$ENDIF}
end;

procedure UpdateSchedulerTimeStamp;
begin
  ConfigLock.Enter;
  Try
    if not ConfigObject.HasRecord then
      ConfigObject.GetRecord;

    ConfigObject.TimeStamp := Now;
    ConfigObject.SaveRecord(not ConfigObject.HasRecord);
  Finally
    ConfigLock.Leave;
  End;
end;

function GetSchedulerTimeStamp : TDateTime;
begin
  ConfigLock.Enter;
  Try
    ConfigObject.GetRecord;
    Result := ConfigObject.TimeStamp;
  Finally
    ConfigLock.Leave;
  End;
end;



Initialization
  CompanyPath := SetDrive;
  DefineTaskFile;
  DefineConfigFile;

Finalization
  {$IFDEF SCHEDDLL}
   ConfigObject.CloseFile;
  {$ENDIF}

end.
