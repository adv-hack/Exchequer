unit TTimeLeftu;

interface

uses types, classes, windows;

type
  TTimeLeft = class(TObject)
  private
    FAvgTimePerUnit: cardinal;
    FCounting: boolean;
    FEstTimeLeft:    cardinal;
    FEstMinsLeft:    cardinal;
    FEstSecsLeft:    cardinal;
    FTotalUnits:     cardinal;
    StartTime:       DWORD;
    TimeNow:         DWORD;
    TimeSoFar:       DWORD;
  public
    procedure StartCounting;
    procedure StopCounting;
    function  TimeLeft(UnitCount: cardinal): cardinal;
    property  AvgTimePerUnit: cardinal read FAvgTimePerUnit;
    property  Counting:       boolean  read FCounting;
    property  EstMinsLeft:    cardinal read FEstMinsLeft;
    property  EstSecsLeft:    cardinal read FEstSecsLeft;
    property  EstTimeLeft:    cardinal read FEstTimeLeft;
    property  TotalUnits:     cardinal read FTotalUnits write FTotalUnits;
  end;

implementation

{ TTimeLeft }

procedure TTimeLeft.StartCounting;
begin
  StartTime    := GetTickCount;
  FCounting    := true;
end;

procedure TTimeLeft.StopCounting;
begin
  FCounting       := false;
  StartTime       := 0;
  TimeNow         := 0;
  FAvgTimePerUnit := 0;
  FEstTimeLeft    := 0;
  FEstMinsLeft    := 0;
  FEstSecsLeft    := 0;
end;

function TTimeLeft.TimeLeft(UnitCount: cardinal): cardinal;
// given the number of units so far (UnitCount), returns the estimated time remaining
// + 1 second as we don't want to display 0 seconds to go
begin
  result := 0;
  if not counting then exit;

  TimeNow         := GetTickCount;
  TimeSoFar       := TimeNow - StartTime;

  FAvgTimePerUnit := TimeSoFar div UnitCount;

  FEstTimeLeft    := ((AvgTimePerUnit * (TotalUnits - UnitCount)) div 1000) + 1; // in round seconds

  FEstMinsLeft    := EstTimeLeft div 60;
  FEstSecsLeft    := EstTimeLeft mod 60;

  result          := EstTimeLeft; // so client can do their own calculation if reqd.
end;

end.
