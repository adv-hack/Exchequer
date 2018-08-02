unit EntLoggerClass;

interface

uses
  EntLogIniClass;

type

  TEntBaseLogger = Class
  private
    function GetDataPath: string;
    procedure SetDataPath(const Value: string);
  protected
    FComputerName      : string;
    FWindowsUser       : string;
    FEnterpriseDir     : string;
    FEnterpriseVersion : string;
    FApplication       : string;
    FModule            : string;
    FProcessID         : integer;
    FThreadID          : Integer;
    FLevel             : TLoggingLevel;
    FArea              : string;
    FLogFilename          : string;
    function GetTimeStamp : string;
    function GetPrefix    : string;
    procedure SendLineToLog(const sLevel : string;
                            const Msg : string;
                            const xd1 : string;
                            const xd2 : string;
                            const xd3 : string);
  public
    procedure LogError(const Msg : string; const xd1 : string = ''; const xd2 : string = ''; const xd3 : string = '');
    procedure LogInfo(const Msg : string; const xd1 : string = ''; const xd2 : string = ''; const xd3 : string = '');
    constructor Create(const APurpose : string);

    property Level : TLoggingLevel read FLevel write FLevel;

    //PR: 06/09/2011 Added datapath property to enable different log files to be used
    property DataPath : string read GetDataPath write SetDataPath;
  end;

  //------------------------------

  TEntSQLReportLogger = Class(TEntBaseLogger)
  protected
    FQueryStartTime  : TDateTime;
    FReportStartTime : TDateTime;
  public
    procedure StartReport;
    procedure FinishReport;
    procedure StartQuery (SQLQuery : String);
    procedure QueryRowCount(Const RowCount : Integer);
    procedure FinishQuery;
  end;

  //------------------------------

  TEntSQLProcessLogger = Class(TEntBaseLogger)
  protected
    FQueryStartTime   : TDateTime;
    FProcessStartTime : TDateTime;
    FSubProcessStartTime : TDateTime;
  public
    procedure StartProcess;
    procedure FinishProcess;
    procedure StartSubProcess (Const SubProcessName : ShortString);
    procedure FinishSubProcess (Const SubProcessName : ShortString);
    procedure StartQuery (SQLQuery : String);
    procedure QueryRowCount(Const RowCount : Integer);
    procedure FinishQuery;
  end; // TEntSQLProcessLogger

  //------------------------------

  procedure StartLogging(DataPath : string);
  procedure StopLogging;

implementation

uses
  EntLogQueueClass, EntLogWriterClass, FileUtil, SysUtils, DateUtils, ApiUtil, Windows;

const
  S_INFO  = '1';
  S_ERROR = '2';

var
  sDataPath : string;

procedure StartLogging(DataPath : string);
begin
  sDataPath := DataPath;
  CreateLoggingIniFile(DataPath);
  StartLogWriter;
end;

procedure StopLogging;
begin
  StopLogWriter;
  DestroyLoggingIniFile;
end;

{ TEntBaseLogger }

constructor TEntBaseLogger.Create(const APurpose : string);
begin
  inherited Create;
  FComputerName := WinGetComputerName;
  FEnterpriseDir := GetEnterpriseDirectory;
  FWindowsUser := WinGetUserName;
  FEnterpriseVersion := GetFileVersion(FEnterpriseDir + 'Enter1.exe');
  FApplication := ParamStr(0);
  if IsLibrary then
    FModule := EntGetModuleFileName
  else
    FModule := '';
  FProcessId := GetCurrentProcessID;
  FThreadID := GetCurrentThreadID;
  FArea := UpperCase(APurpose);
  FLevel := llNone;
  FLogFilename := '';
  if LoggingIniFile <> nil then
  Try
    FLevel := LoggingIniFile.Level[FArea];
  Except
  End;
end;

function TEntBaseLogger.GetDataPath: string;
begin
  Result := ExtractFilePath(FLogFilename);
end;

//PR: 06/09/2011 Added datapath property to enable different log files to be used
//When value is set we open an ini file in the datapath to get the filename and
//level to be used for this logger.
procedure TEntBaseLogger.SetDataPath(const Value: string);
var
  LogIni : TEntLogIniFile;
begin
  LogIni := TEntLogIniFile.Create(Value);
  if Assigned(LogIni) then
  Try
    FLogFilename := LogIni.LogFilename;
    FLevel := LogIni.Level[FArea];
    if Trim(FLogFilename) <> '' then
      FLogFilename := 'LOG:' + FLogFilename + ',';
  Finally
    LogIni.Free;
  End;
end;

function TEntBaseLogger.GetPrefix: string;
begin
  Result := Format('%s,%d,%d,%s,%s,%s,%s,%s,%s,', [FComputerName,
                                                   FProcessID,
                                                   FThreadID,
                                                   FWindowsUser,
                                                   FApplication,
                                                   FModule,
                                                   FEnterpriseVersion,
                                                   FEnterpriseDir,
                                                   FArea]);
end;

function TEntBaseLogger.GetTimeStamp: string;
begin
  Result := FormatDateTime('yyyymmdd","hh:nn:ss:zzz","', Now);
end;

procedure TEntBaseLogger.LogError(const Msg : string;
                                  const xd1 : string = '';
                                  const xd2 : string = '';
                                  const xd3 : string = '');
begin
  if FLevel > llNone then
    SendLineToLog(S_ERROR, Msg, xd1, xd2, xd3);
end;

procedure TEntBaseLogger.LogInfo(const Msg : string;
                                 const xd1 : string = '';
                                 const xd2 : string = '';
                                 const xd3 : string = '');
begin
  if FLevel = llInfo then
    SendLineToLog(S_INFO, Msg, xd1, xd2, xd3);
end;

procedure TEntBaseLogger.SendLineToLog(const sLevel : string;
                                       const Msg : string;
                                       const xd1 : string;
                                       const xd2 : string;
                                       const xd3 : string);
var
  s : string;
begin
  //PR; 06/09/2011 Prefix log line with log file name if any
  s := Format('%s%s%s%s,%s,%s,%s,%s', [FLogFilename,
                                       GetTimeStamp,
                                       GetPrefix,
                                       sLevel, Msg, xd1, xd2, xd3]);

  //Wait for critical section
  EntLogProtector.Enter;
  Try
    //Add Message to log
    EntLogQueue.Add(s);
  Finally
    EntLogProtector.Leave;
  End;
end;

//=========================================================================

procedure TEntSQLProcessLogger.StartProcess;
Begin // StartProcess
  FProcessStartTime := Time;
  LogInfo('Start Process');
End; // StartProcess

procedure TEntSQLProcessLogger.FinishProcess;
Begin // FinishProcess
  //xd1 - duration of report in ms
  LogInfo('Finish Process', IntToStr(MillisecondsBetween(Time, FProcessStartTime)) + 'ms');
End; // FinishProcess

//------------------------------

procedure TEntSQLProcessLogger.StartSubProcess (Const SubProcessName : ShortString);
Begin // StartSubProcess
  FSubProcessStartTime := Time;
  // Note: Due to sub-processes calling other sub-processes the object cannot store the
  // sub-process name as it gets overwritten - it would need some sort of list
  //FSubProcessName := SubProcessName;
  LogInfo('Start Subprocess (' + SubProcessName + ')');
End; // StartSubProcess

procedure TEntSQLProcessLogger.FinishSubProcess (Const SubProcessName : ShortString);
Begin // FinishSubProcess
  //xd1 - duration of report in ms
  LogInfo('Finish Subprocess (' + SubProcessName + ')', IntToStr(MillisecondsBetween(Time, FSubProcessStartTime)) + 'ms');
End; // FinishSubProcess

//------------------------------

procedure TEntSQLProcessLogger.StartQuery (SQLQuery : String);
Begin // StartQuery
  FQueryStartTime := Time;
  LogInfo('Start Query', '"' + SQLQuery + '"');
End; // StartQuery

procedure TEntSQLProcessLogger.QueryRowCount(Const RowCount : Integer);
Begin // QueryRowCount
  //xd1 - rows returned
  LogInfo('Query RowCount', IntToStr(RowCount));
End; // QueryRowCount

procedure TEntSQLProcessLogger.FinishQuery;
Begin // FinishQuery
  //xd1 - duration of query in ms
  LogInfo('Finish Query', IntToStr(MillisecondsBetween(Time, FQueryStartTime)) + 'ms');
End; // FinishQuery

//=========================================================================

procedure TEntSQLReportLogger.StartReport;
begin
  FReportStartTime := Time;
  LogInfo('Start Report');
end;

//------------------------------

procedure TEntSQLReportLogger.FinishReport;
begin
  //xd1 - duration of report in ms
  LogInfo('Finish Report', IntToStr(MillisecondsBetween(Time, FReportStartTime)) + 'ms');
end;

//-------------------------------------------------------------------------

procedure TEntSQLReportLogger.StartQuery(SQLQuery: String);
begin
  FQueryStartTime := Time;
  LogInfo('Start Query', '"' + SQLQuery + '"');
end;

//------------------------------

procedure TEntSQLReportLogger.QueryRowCount(Const RowCount : Integer);
Begin // QueryRowCount
  //xd1 - rows returned
  LogInfo('Query RowCount', IntToStr(RowCount));
End; // QueryRowCount

//------------------------------

procedure TEntSQLReportLogger.FinishQuery;
begin
  //xd1 - duration of query in ms
  LogInfo('Finish Query', IntToStr(MillisecondsBetween(Time, FQueryStartTime)) + 'ms');
end;

//=========================================================================

Initialization

Finalization
  StopLogging;
end.
