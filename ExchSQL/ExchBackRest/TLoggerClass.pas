unit TLoggerClass;

interface

uses
  classes, SysUtils;

type
  TLogger = class(TObject)
  private
    FLogFile: TStringList;
    FLogFileName: string;
    function  FormattedLogLine(const ALogLine: string): string;
    procedure LoadLogFile;
    function  GetLogFileName: string;
    procedure WriteLogFile;
    constructor create;
  public
    procedure LogLine(const ALogLine: string);
    property  LogFileName: string read FLogFileName write FLogFileName;
  end;

function Logger: TLogger;

implementation

var
  FLogger: TLogger;

function Logger: TLogger;
begin
  if not assigned(FLogger) then
    FLogger := TLogger.Create;

  result := FLogger;
end;

{ TLogger }

constructor TLogger.create;
begin
  FLogFileName := GetLogFileName; // get the default file name
end;

function TLogger.FormattedLogLine(const ALogLine: string): string;
begin
  result := format('%s %s %s',[FormatDateTime('yyyy/mm/dd', date), FormatDateTime('hh:nn:ss', now), ALogLine]);
end;

procedure TLogger.LoadLogFile;
begin
  FLogFile := TStringList.Create;
  if FileExists(FLogFileName) then
    FLogFile.LoadFromFile(FLogFileName);
end;

function TLogger.GetLogFileName: string;
// get the default log file name. This can be overridden with the LogFileName property.
var
  FileName: string;
begin
  if FLogFileName <> '' then EXIT; // its already been overridden
  FileName := ExtractFileName(ParamStr(0));
  FileName := ChangeFileExt(FileName, '.log');
  result := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0))) + FileName;
end;

procedure TLogger.LogLine(const ALogLine: string);
var
  LogLine: string;
begin
  LoadLogFile;
  FLogFile.Add(FormattedLogLine(ALogLine));
  WriteLogFile;
end;

procedure TLogger.WriteLogFile;
begin
  FLogFile.SaveToFile(FLogFileName);
  FLogFile.Free;
end;

initialization
  FLogger := nil;

finalization
  if assigned(FLogger) then
    FreeAndNil(FLogger);

end.
