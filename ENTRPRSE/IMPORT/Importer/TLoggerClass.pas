unit TLoggerClass;

{******************************************************************************}
{  TLogger controls numerous log files simultaneously. Each log file is        }
{  is identified by the FileNo which should be unique within each job.         }
{  When reading a sort file containing records from multiple import files,     }
{  TLogger will have multiple log files open.                                  }
{                                                                              }
{  Each TImportJob calls NewLog to create a log file for the FileNo it will    }
{  import. However, each TImportJob leaves its log file open if it is not set  }
{  to read the sort file back in. After the last TImportjob, TRecordMgr can    }
{  then read a mixture of records from various TImportJobs and output any      }
{  messages to the correct log file depending on the FileNo on the input       }
{  records. It then calls CloseLogs to close however many logs were opened.    }
{                                                                              }
{  In this way, each log file only contains messages for one import file, even }
{  when records from multiple import files have been mixed together in the     }
{  sort file.                                                                  }
{                                                                              }
{  Log zero is used as a general log for the entire application.               }
{                                                                              }
{  ??/2006: each import file's log file is closed at the end of its import job.}
{  When the sort file is read back in, all subsequent error messages are written}
{  to the log file of whichever import job is reading the sort file.           }
{                                                                              }
{  PR: 03/07/2014 ABSEXCH-13927 Rewrote to use a TList descendant rather than  }
{  a dynamic array to hold the details of the log files                        }
{                                                                              }
{******************************************************************************}

interface

type
  ILogger = interface
    ['{30D19C41-2095-4838-9A6D-64E0255069B3}']

    function  GetSysMsg: string;
    function  GetSysMsgSet: boolean;
    procedure SetSysMsg(Value: string);
    // public methods and properties
    function  CloseLog(AFileNo: integer): integer;
    function  CloseLogs: integer;
    function  LogEntry(AFileNo: integer; const ALogEntry: string): integer;
    function  NewLog(AFileNo: integer; const ALogFileName: string): integer;
    property  SysMsg: string read GetSysMsg;
    property  SysMsgSet: boolean read GetSysMsgSet;
  end;

function Logger: ILogger;

implementation

uses SysUtils, windows, TErrors, Utils, Classes;

type
  PLogFile = ^TLogFile;
  TLogFile = record
    FileVar:     TextFile;
    FileName:    string;
    AlreadyOpen: boolean;
  end;

  //Sub-class TList for readability
  TLogFileList = Class(TList)
    function  Get(Index: Integer): PLogFile;
    procedure Put(Index: Integer; Item: PLogFile);
  private
  public
    property  Items[Index: Integer]: PLogFile read Get write Put; default;
  end;

  TLogger = class(TInterfacedObject, ILogger)
  private
{* internal fields *}
    FLogFiles: TLogFileList; //Changed from array of TLogFile
{* property fields *}
{* procedural methods *}
{* getters and setters *}
    function  GetSysMsg: string;
    function  GetSysMsgSet: boolean;
    procedure SetSysMsg(Value: string);
  public
    constructor create;
    destructor destroy; override;
    function  CloseLog(AFileNo: integer): integer;
    function  CloseLogs: integer;
    function  FindOpenFileNo(AFileNo: integer): integer;
    function  LogEntry(AFileNo: integer; const ALogEntry: string): integer;
    function  NewLog(AFileNo: integer; const ALogFileName: string): integer;
    property  SysMsg: string read GetSysMsg;
    property  SysMsgSet: boolean read GetSysMsgSet;
  end;

var
  FLogger: ILogger;

function Logger: ILogger;
begin
  if not assigned(FLogger) then
    FLogger := TLogger.create;

  result := FLogger; // exposes the global Logger instance
end;

{ TLogger }

constructor TLogger.create;
begin
  inherited;
  //create list
  FLogFiles := TLogFileList.Create;
  // it was just a thought
end;

destructor TLogger.destroy;
var
  i : Integer;
begin
  CloseLogs; // in case someone forgot to
  CloseLog(0);
  //Deallocate all records in the list before freeing
  for i := 0 to FLogFiles.Count - 1 do
    Dispose(FLogFiles.Items[i]);
  FreeAndNil(FLogFiles);
  inherited;
end;

{* procedural methods *}

function TLogger.CloseLog(AFileNo: integer): integer;
// closes the given log file if it's open
begin
  Result := 0;
  if FLogFiles.Count < (AFileNo + 1) then exit; // never got opened

  if FLogFiles[AFileNo].AlreadyOpen then begin
    CloseFile(FLogFiles[AFileNo].FileVar);
    FLogFiles[AFileNo].AlreadyOpen := false;
    FLogFiles[AFileNo].FileName    := '';
  end;
end;

function TLogger.CloseLogs: integer;
// closes all log files except the main application log, FLogFiles[0]
var
  LogIx: integer;
begin
  Result := 0;
  for LogIx := 1 to FLogFiles.Count - 1 do
   if FLogFiles[LogIx].AlreadyOpen then begin
     CloseFile(FLogFiles[LogIx].FileVar);
     FLogFiles[LogIx].AlreadyOpen := false;
   end;
end;

function TLogger.FindOpenFileNo(AFileNo: integer): integer;
begin
  result := AFileNo;
  while (not FLogFiles[result].AlreadyOpen) do
    inc(result);

  if result > FLogFiles.Count - 1 then
    result := 0; // write to main log file
end;

function TLogger.LogEntry(AFileNo: integer; const ALogEntry: string): integer;
var
  FileNo: integer;
begin
  result := -1;

  if (AFileNo = 0) and ( (FLogFiles.Count = 0) or (not FLogFiles[0].AlreadyOpen) ) then
    NewLog(0, AppLogFileName); // The first call to LogEntry for the application log will open it automatically

  if FLogFiles.Count < (AFileNo + 1) then
    raise exception.create(format('Request to write to Log for file %d rejected', [AFileNo]));

  try
    FileNo := FindOpenFileNo(AFileNo);
    begin
      WriteLn(FLogFiles[FileNo].FileVar, ALogEntry);
      flush(FLogFiles[FileNo].FileVar); // make sure we get all lines in the event of a program crash
    end;
  except on EInOutError do begin
    SetSysMsg(format('Log file "%s": %s', [FLogFiles[AFileNo].FileName, SysErrorMessage(GetLastError)]));
    exit;
  end; end;

  result := 0;
end;

function TLogger.NewLog(AFileNo: integer; const ALogFileName: string): integer;
var
  ALogFileRec : PLogFile;
begin
  result := -1;

  ForceDirectories(ExtractFilePath(ALogFileName));
  if not DirectoryExists(ExtractFilePath(ALogFileName)) then begin
    SetSysMsg(format('Log folder "%s" does not exist and cannot be created', [ExtractFilePath(ALogFileName)]));
    exit;
  end;

  if FLogFiles.Count < (AFileNo + 1) then
  begin
    New(ALogFileRec);
    FillChar(ALogFileRec^, SizeOf(ALogFileRec^), 0);
    FLogFiles.Add(ALogFileRec);
  end;

  if AFileNo <> 0 then                 // we don't close the application log
    if FLogFiles[AFileNo].AlreadyOpen then
      CloseFile(FLogFiles[AFileNo].FileVar);

  FLogFiles[AFileNo].FileName := ALogFileName;

  AssignFile(FLogFiles[AFileNo].FileVar, ALogFileName);

  if (AFileNo <> 0) or ((AFileNo = 0) and not FLogFiles[0].AlreadyOpen) then
  try
    if (AFileNo <> 0) or (not FileExists(ALogFileName)) then
      rewrite(FLogFiles[AFileNo].FileVar)
    else
      append(FLogFiles[AFileNo].FileVar); // append to the application log if it exists
  except on EInOutError do begin
    SetSysMsg(format('Log file "%s": %s', [ALogFileName, SysErrorMessage(GetLastError)]));
    exit;
  end; end;

  FLogFiles[AFileNo].AlreadyOpen := true;
  result := 0;
end;

{* getters and setters *}

function TLogger.GetSysMsg: string;
begin
  result := TErrors.SysMsg;
end;

function TLogger.GetSysMsgSet: boolean;
begin
  result := TErrors.SysMsgSet;
end;

procedure TLogger.SetSysMsg(Value: string);
begin
  TErrors.SetSysMsg(Value);
end;

{ TLogFileList }

function TLogFileList.Get(Index: Integer): PLogFile;
begin
 result := PLogFile(inherited Get(Index));
end;

procedure TLogFileList.Put(Index: Integer; Item: PLogFile);
begin
  inherited Put(Index, pointer(item));
end;

initialization
  FLogger := nil;

finalization
  FLogger := nil;

end.
