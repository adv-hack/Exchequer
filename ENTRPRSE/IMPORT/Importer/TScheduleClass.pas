unit TScheduleClass;

{******************************************************************************}
{   Given certain conditions on when a job should be run, TSchedule calculates }
{   when the next scheduled run should be or, in the case of missed jobs, when }
{   it should have been.                                                       }
{   NextRun will calculate the next scheduled run from BaseDateTime, which     }
{   would typically be set to the last run date/time.                          }
{   If NextRun returns a DateTime less than the current date and time this     }
{   signifies a missed job and it is up to the caller to react to that - the   }
{   usual solution would be to either run the job immediately or recall NextRun}
{   with BaseDateTime set to Now.                                              }
{   If missed jobs aren't an issue, call NextRun once with BaseDateTime := Now }
{******************************************************************************}

interface

uses SysUtils, Controls, DateUtils, Utils, dialogs;

type
  TSchedule = class(TObject)
  private
{* Internal Fields *}
{* Property Fields *}
    FSunday: boolean;
    FFriday: boolean;
    FWeek2: boolean;
    FDaily: boolean;
    FWeek3: boolean;
    FOnceAt: boolean;
    FMonthly: boolean;
    FWeekx: boolean;
    FTuesday: boolean;
    FWednesday: boolean;
    FMonday: boolean;
    FWeek4: boolean;
    FUseISO8601: boolean;
    FSaturday: boolean;
    FThursday: boolean;
    FWeek1: boolean;
    FEveryMins: integer;
    FEveryBetweenMins: integer;
    FBetweenFrom: TTime;
    FBetweenTo: TTime;
    FEvery: boolean;
    FOnceAtTime: TTime;
    FEveryBetween: boolean;
    FBaseDateTime: TDateTime;
    FMissedJob: boolean;
{* Procedural Methods *}
    function IsLastXDayOfMonth(TheDate: TDate): boolean;
    function NextRunDate(TheDate: TDate): TDate;
    function NextRunDay(TheDate: TDate): TDate;
    function NextRunTime(TheDate: TDate): TTime;
{* Getters and Setters *}
    function GetThisDay(index: word): boolean;
    procedure SetBetweenFrom(const Value: TTime);
    procedure SetBetweenTo(const Value: TTime);
    procedure SetDaily(const Value: boolean);
    procedure SetEveryMins(const Value: integer);
    procedure SetEveryBetweenMins(const Value: integer);
    procedure SetFriday(const Value: boolean);
    procedure SetMonday(const Value: boolean);
    procedure SetMonthly(const Value: boolean);
    procedure SetOnceAt(const Value: boolean);
    procedure SetSaturday(const Value: boolean);
    procedure SetSunday(const Value: boolean);
    procedure SetThisDay(index: word; const Value: boolean);
    procedure SetThursday(const Value: boolean);
    procedure SetTuesday(const Value: boolean);
    procedure SetUseISO8601(const Value: boolean);
    procedure SetWednesday(const Value: boolean);
    procedure SetWeek1(const Value: boolean);
    procedure SetWeek2(const Value: boolean);
    procedure SetWeek3(const Value: boolean);
    procedure SetWeek4(const Value: boolean);
    procedure SetWeekx(const Value: boolean);
    function GetThisWeek(index: word): boolean;
    procedure SetThisWeek(index: word; const Value: boolean);
    procedure SetEvery(const Value: boolean);
    procedure SetOnceAtTime(const Value: TTime);
    procedure SetEveryBetween(const Value: boolean);
    procedure SetBaseDateTime(const Value: TDateTime);
    procedure SetBaseDate(const Value: TDate);
    function GetBaseDate: TDate;
    function GetBaseTime: TTime;
    procedure SetBaseTime(const Value: TTime);
  public
    function NextRun: TDateTime;
    property BaseDate: TDate read GetBaseDate write SetBaseDate;
    property BaseDateTime: TDateTime read FBaseDateTime write SetBaseDateTime;
    property BaseTime: TTime read GetBaseTime write SetBaseTime;
    property Monthly: boolean read FMonthly write SetMonthly;
    property Daily: boolean read FDaily write SetDaily;
    property Monday: boolean read FMonday write SetMonday;
    property Tuesday: boolean read FTuesday write SetTuesday;
    property Wednesday: boolean read FWednesday write SetWednesday;
    property Thursday: boolean read FThursday write SetThursday;
    property Friday: boolean read FFriday write SetFriday;
    property Saturday: boolean read FSaturday write SetSaturday;
    property Sunday: boolean read FSunday write SetSunday;
    property ThisDay[index: word]: boolean read GetThisDay write SetThisDay;
    property ThisWeek[index: word]: boolean read GetThisWeek write SetThisWeek;
    property Week1: boolean read FWeek1 write SetWeek1;
    property Week2: boolean read FWeek2 write SetWeek2;
    property Week3: boolean read FWeek3 write SetWeek3;
    property Week4: boolean read FWeek4 write SetWeek4;
    property RunInLastWeek: boolean read FWeekx write SetWeekx;
    property Every: boolean read FEvery write SetEvery;
    property EveryMins: integer read FEveryMins write SetEveryMins;
    property EveryBetween: boolean read FEveryBetween write SetEveryBetween;
    property EveryBetweenMins: integer read FEveryBetweenMins write SetEveryBetweenMins;
    property OnceAt: boolean read FOnceAt write SetOnceAt;
    property OnceAtTime: TTime read FOnceAtTime write SetOnceAtTime;
    property BetweenFrom: TTime read FBetweenFrom write SetBetweenFrom;
    property BetweenTo: TTime read FBetweenTo write SetBetweenTo;
    property UseISO8601: boolean read FUseISO8601 write SetUseISO8601;
    property MissedJob: boolean read FMissedJob;
  end;

function JobScheduler: TSchedule;

implementation

var
  FSchedule: TSchedule;

function JobScheduler: TSchedule;
// Wizard.pas and Scheduler.pas will use the same instance of TSchedule
begin
  result := FSchedule;
end;

{ TSchedule }

function TSchedule.NextRunDay(TheDate: TDate): TDate;
// Finds the next day of the week that this job will run
// by finding the next xxxDay=true entry starting from the date supplied
var
  DayNoOfWeek: word;
  RunThisDayOfWeek: boolean;
begin
  repeat
    DayNoOfWeek := DayOfTheWeek(TheDate);              // what xxxDay is it ?
    RunThisDayOfWeek := ThisDay[DayNoOfWeek];          // run on a xxxDay ?
    if not RunThisDayOfWeek then
      TheDate := IncDay(TheDate);                                  // maybe not so try the next day, or the day after....
  until RunThisDayOfWeek;
  result := TheDate;
end;

function TSchedule.IsLastXDayOfMonth(TheDate: TDate): boolean;
// Is this the last Monday, Tuesday, Wednesday etc. of the month ?
//
// ISO-8601: "Any week with four or more days in any month belongs to that month."
// So Monday 28th to Wednesday 30th November are in the first week of December.
// Therefore, the last Monday of November will be the 21st.
// Similarly, Friday 1st to Sunday 3rd will be in the last week of the previous
// month.
//
// Currently, the option for the user to be able to use ISO8601 date calculations
// is hidden from them (Schedule tab in Wizard.pas). Even though DateUtils.pas
// uses ISO8601 as standard, we would prefer the "last monday" of the month etc.
// to actually be the last, not the one from the previous week.
var
  LastDayOfThisMonth: word;
  WeeksThisMonth:  word;
  WeekOfDaMonth: word;
begin
  if FUseISO8601 then begin
    LastDayOfThisMonth := DaysInAMonth(YearOf(TheDate), MonthOf(TheDate)); // what's the last day of this month
    WeekOfDaMonth      := WeekOfTheMonth(EncodeDate(YearOf(TheDate), MonthOf(TheDate), LastDayOfThisMonth)); // what week of the month is that in ?

    WeeksThisMonth     := WeeksBetween(EncodeDate(YearOf(TheDate), MonthOf(TheDate), 1),
                                       EncodeDate(YearOf(TheDate), MonthOf(TheDate), LastDayOfThisMonth)) + 1; // how many weeks this month ?

    if WeekOfDaMonth = 1 then
      WeeksThisMonth := WeeksThisMonth - 1;         // the last day of the month is in the first week of next month

    result := WeekOfTheMonth(TheDate) = WeeksThisMonth;
  end
  else
    result := MonthOf(TheDate) <> MonthOf(IncDay(TheDate, 7));
end;

function TSchedule.NextRunDate(TheDate: TDate): TDate;
// A job can be run on any of the first, second, third, fourth or last xxxDay of the month.
// Starting at TheDate, find the next week that the job should run (which might be this week).
// When the week has been found, call NextRunDay to find the day in that week that the job should run.
//
// ISO-8601: Any week with four or more days in any month belongs to that month.
// Most of Delphi's date routines adhere to ISO8601 when determining how many weeks are in a month
// and whether the first and last day are in the calendar month or in the previous or next business month.
// Because this is not appropriate for our purposes, this function avoids ISO8601, so the first Monday in a month
// might be in the second week (e.g. the 7th) and the last Monday might actually be the 4th Monday in what is
// considered to be a 5-week month, whereas the last Tuesday will be the 5th Tuesday (cf. Nov 2005) because the month
// started on a Tuesay.
//
// Currently, the option for the user to be able to use ISO8601 date calculations
// is hidden from them in Importer.
var
  RunThisWeek: boolean;
  WeekNumberOfMonth: word;
begin
  if Daily then begin
    result := NextRunDay(TheDate); // "run this week" is always true for "Daily" so just find what day this week
                                   // If we've passed it, NextRunDay will return the day from next week.
    exit;
  end;

  repeat
    if FUseISO8601 then
      WeekNumberOfMonth  := WeekOfTheMonth(TheDate)
    else
      WeekNumberOfMonth  := NthDayOfWeek(TheDate);

    RunThisWeek := ThisWeek[WeekNumberOfMonth]             // set to run this week of the month ?
                    or (RunInLastWeek and IsLastXDayOfMonth(TheDate)); // or run job on last xxxDay of the month ?

    if not RunThisWeek then
      TheDate := IncDay(TheDate) // walk forward through the days til we get to a run week
    else
      if (FUseISO8601 and (WeekOfTheMonth(NextRunDay(TheDate)) <> WeekNumberOfMonth))// we've missed all the days this week it could have run coz NextRunDay returned a day from next week
       or (NthDayOfWeek(NextRunDay(TheDate)) <> WeekNumberOfMonth) then begin        // we've missed all the days this week it could have run coz NextRunDay returned a day from next week
        RunThisWeek := false;        // force the search into next week
        TheDate := IncDay(TheDate);
      end;
  until RunThisWeek;
  result := NextRunDay(TheDate); // found the week, now find the day in the week
end;

function TSchedule.NextRunTime(TheDate: TDate): TTime;
begin
  result := 0; // happy compiler

{* Run Every nn minutes:-                                                                  *}
{* Calculate increments of nn minutes from midnight until we pass the current time or the  *}
{* last run time depending on which the caller has used as the base date and time.         *}
{* We calculate run times from midnight onwards so that each runtime is predictable.       *}
{* It could be changed to calculate from when Scheduler is started but that's not as clean *}
{* The same applies to calculating from the last run time.                                 *}
  if Every then begin
    if TheDate = BaseDate then begin
      result := 0;
      while result <= BaseTime do
        result := IncMinute(result, EveryMins); // walk through n minutes at a time from BaseTime until have a time in the future
      if TimeToStr(result) = TimeToStr(BaseTime) then // precision issues cause this even when always working with whole minutes
        result := IncMinute(result, EveryMins);       // e.g. last run at 10:45, set to run every 15 minutes. This statement will execute
    end
    else
      result := IncMinute(result, EveryMins); // tomorrow at midnight + nn at the earliest
    exit;
  end;

{* run once at a set time *}
  if OnceAt then begin
    result := OnceAtTime;
    exit;
  end;

{* Every n minutes between xx:xx and yy:yy *}
  if not EveryBetween then exit;

  if TheDate <> BaseDate then begin
    result := BetweenFrom; // earliest will be next day at the start time
    exit;
  end;

{* Today *}
  if BaseTime < BetweenFrom then begin
    result := BetweenFrom; // today at the start time
    exit;
  end;

  if BaseTime > BetweenTo then begin
    result := BetweenFrom; // force next run into tomorrow
    exit;
  end;
   //RJ 08/02/2016 2016-R1 ABSEXCH-14702: Fixed have been implemented for display proper next run time in the Importer Scheduler
  result := BetweenFrom; // in increments of nn minutes from midnight
  while result <= BaseTime do
    result := IncMinute(result, EveryBetweenMins); // walk through nn minutes at a time from start time until we reach some time in the future
  if TimeToStr(result) = TimeToStr(BaseTime) then  // precision issues cause this even when always working with whole minutes
    result := IncMinute(result, EveryBetweenMins); // e.g. last run at 10:45, set to run every 15 minutes. This statement will execute

  if result > BetweenTo then                       // if that takes us past the end time
    result := BetweenFrom;                         // next run is tomorrow at the earliest
end;

function TSchedule.NextRun: TDateTime;
var
  RunTime: TTime;
  RunDate: TDate;
begin
  RunDate := NextRunDate(BaseDate);    // find the next run date starting from BaseDate
  RunTime := NextRunTime(RunDate);     // find the next run time on that date

  if (RunDate = BaseDate) and (RunTime < BaseTime) then begin // next rundate is BaseDate but all that day's runs have passed....
    RunDate := NextRunDate(BaseDate + 1);                     // so find next run date starting from day after BaseDate
    RunTime := NextRunTime(RunDate);                          // and the runtime on that date
  end;

  result := RunDate + RunTime;

//  ShowMessage(FloatToStr(result) + ' <=> ' + FloatToStr(Date + EncodeTime(HourOf(now), MinuteOf(now), 0, 0)));
//  ShowMessage(DateTimeToStr(result) + ' ' + DateTimeToStr(BaseDateTime));

  FMissedJob := result < (Date + EncodeTime(HourOf(now), MinuteOf(now), 0, 0)); // BaseDateTime < RunDateTime < CurrentDateTime
end;

{* Getters and Setters *}

function TSchedule.GetThisDay(index: word): boolean;
begin
  case index of
    1: result := Monday;
    2: result := Tuesday;
    3: result := Wednesday;
    4: result := Thursday;
    5: result := Friday;
    6: result := Saturday;
    else
      result := Sunday;
  end;
end;

procedure TSchedule.SetBetweenFrom(const Value: TTime);
begin
  FBetweenFrom := Value;
end;

procedure TSchedule.SetBetweenTo(const Value: TTime);
begin
  FBetweenTo := Value;
end;

procedure TSchedule.SetDaily(const Value: boolean);
begin
  FDaily := Value;
end;

procedure TSchedule.SetEveryMins(const Value: integer);
begin
  FEveryMins := Value;
end;

procedure TSchedule.SetEveryBetweenMins(const Value: integer);
begin
  FEveryBetweenMins := Value;
end;

procedure TSchedule.SetFriday(const Value: boolean);
begin
  FFriday := Value;
end;

procedure TSchedule.SetMonday(const Value: boolean);
begin
  FMonday := Value;
end;

procedure TSchedule.SetMonthly(const Value: boolean);
begin
  FMonthly := Value;
end;

procedure TSchedule.SetOnceAt(const Value: boolean);
begin
  FOnceAt := Value;
end;

procedure TSchedule.SetSaturday(const Value: boolean);
begin
  FSaturday := Value;
end;

procedure TSchedule.SetSunday(const Value: boolean);
begin
  FSunday := Value;
end;

procedure TSchedule.SetThisDay(index: word; const Value: boolean);
begin
  case index of
    1: Monday := Value;
    2: Tuesday := Value;
    3: Wednesday := Value;
    4: Thursday := Value;
    5: Friday := Value;
    6: Saturday := Value;
    7: Sunday := Value;
  end;
end;

procedure TSchedule.SetThursday(const Value: boolean);
begin
  FThursday := Value;
end;

procedure TSchedule.SetTuesday(const Value: boolean);
begin
  FTuesday := Value;
end;

procedure TSchedule.SetUseISO8601(const Value: boolean);
begin
  FUseISO8601 := Value;
end;

procedure TSchedule.SetWednesday(const Value: boolean);
begin
  FWednesday := Value;
end;

procedure TSchedule.SetWeek1(const Value: boolean);
begin
  FWeek1 := Value;
end;

procedure TSchedule.SetWeek2(const Value: boolean);
begin
  FWeek2 := Value;
end;

procedure TSchedule.SetWeek3(const Value: boolean);
begin
  FWeek3 := Value;
end;

procedure TSchedule.SetWeek4(const Value: boolean);
begin
  FWeek4 := Value;
end;

procedure TSchedule.SetWeekx(const Value: boolean);
begin
  FWeekx := Value;
end;

function TSchedule.GetThisWeek(index: word): boolean;
begin
  case index of
    1: result := Week1;
    2: result := Week2;
    3: result := Week3;
    4: result := Week4;
  else
    result := false;
  end;
end;

procedure TSchedule.SetThisWeek(index: word; const Value: boolean);
begin
  case index of
    1: Week1 := Value;
    2: Week2 := Value;
    3: Week3 := Value;
    4: Week4 := Value;
  end;
end;

procedure TSchedule.SetEvery(const Value: boolean);
begin
  FEvery := Value;
end;

procedure TSchedule.SetOnceAtTime(const Value: TTime);
begin
  FOnceAtTime := Value;
end;

procedure TSchedule.SetEveryBetween(const Value: boolean);
begin
  FEveryBetween := Value;
end;

procedure TSchedule.SetBaseDateTime(const Value: TDateTime);
// lop-off the seconds and milliseconds - TScheduler only deals in whole minutes
begin
  FBaseDateTime := DateOf(Value) + EncodeTime(HourOf(Value), MinuteOf(Value), 0, 0);
end;

procedure TSchedule.SetBaseDate(const Value: TDate);
begin
  FBaseDateTime := FBaseDateTime - Trunc(FBaseDateTime) + Value; // change the BaseDate to that supplied
end;

function TSchedule.GetBaseDate: TDate;
begin
  result := Trunc(FBaseDateTime);
end;

function TSchedule.GetBaseTime: TTime;
begin
  result := FBaseDateTime - Trunc(FBaseDateTime);
end;

procedure TSchedule.SetBaseTime(const Value: TTime);
// lop-off the seconds and milliseconds - TScheduler only deals in whole minutes
begin
  FBaseDateTime := Trunc(FBaseDateTime) + EncodeTime(HourOf(Value), MinuteOf(Value), 0, 0); // change the BaseTime to that supplied
end;

initialization
  FSchedule := TSchedule.Create;

finalization
  FreeObjects([FSchedule]);

end.
