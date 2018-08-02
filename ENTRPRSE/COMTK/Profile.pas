unit Profile;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows;

type

  TFuncDuration = Class
    StartTime, Duration : Cardinal;
    Called : longInt;
  end;

  TFuncDurationList = Class(TStringList)
  private
    function GetDurations(Index: Integer): TFuncDuration;
  public
    property Durations[Index : Integer] : TFuncDuration read GetDurations;
  end;

  TProfiler = Class
  private
    FList : TFuncDurationList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure StartFunc(const sFunc : string);
    procedure EndFunc(const sFunc : string);
    procedure Save;
  end;

  function Profiler : TProfiler;


implementation

uses
  FileUtil;

var
  oProfiler : TProfiler;

function Profiler : TProfiler;
begin
  if not Assigned(oProfiler) then
    oProfiler := TProfiler.Create;

  Result := oProfiler;
end;

{ TProfiler }

constructor TProfiler.Create;
begin
  inherited;
  FList := TFuncDurationList.Create;
  FList.Add('Function,Times Called,Total Duration');
end;

destructor TProfiler.Destroy;
begin
  Save;
  FList.Free;
  inherited;
end;

procedure TProfiler.EndFunc(const sFunc: string);
var
  i : integer;
begin
{$IFDEF Profile}
  i := FList.IndexOf(sFunc);
  if i >= 0 then
    with FList.Durations[i] do
      Duration := Duration + GetTickCount - StartTime;
{$ENDIF}
end;

procedure TProfiler.Save;
var
  i : integer;
begin
{$IFDEF Profile}
  for i := 1 to FList.Count - 1 do
    FList[i] := FList[i] + ',' + IntToStr(FList.Durations[i].Called) + ',' + IntToStr(FList.Durations[i].Duration);

  FList.SaveToFile('c:\durations.csv');
{$ENDIF}
end;

procedure TProfiler.StartFunc(const sFunc: string);
var
  i : integer;
  oFD : TFuncDuration;
begin
{$IFDEF Profile}
  i := FList.IndexOf(sFunc);
  if i = -1 then
  begin
    oFD := TFuncDuration.Create;
    oFD.Called := 0;
    oFD.Duration := 0;
    i := FList.AddObject(sFunc, oFD);
  end;

  with FList.Durations[i] do
  begin
    StartTime := GetTickCount;
    inc(Called);
  end;
{$ENDIF}
end;

{ TFuncDurationList }

function TFuncDurationList.GetDurations(Index: Integer): TFuncDuration;
begin
  if Assigned(Objects[Index]) then
    Result := TFuncDuration(Objects[Index])
  else
    Result := nil;
end;

Initialization

  oProfiler := nil;

Finalization

  if Assigned(oProfiler) then
    oProfiler.Free;

end.
