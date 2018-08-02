unit EntLogWriterClass;

interface

  procedure StartLogWriter;
  procedure StopLogWriter;

implementation

uses
  Classes, EntLogQueueClass, EntLogIniClass, SysUtils, Windows, ApiUtil, Forms;

type
  TEntLogWriter = Class(TThread)
  private
    FLine : string;
    FFile : TextFile;
    FFileName : string;
    FAlwaysFileName : string;
    FFatalError : Boolean;
    FFatalErrorNo : Integer;
    FErrorCount : Integer;
    FAppName : AnsiString;
    procedure GetNextLine;
    procedure WriteLine;
    procedure WriteRemainingLines(Sender : TObject);
    function GetFileAccess : Boolean;
    procedure SetFilename;
  public
    constructor Create;
    procedure Execute; override;
  end;


const
  I_TIMEOUT = 200;
  I_TERMINATE_TIMEOUT = 100;

  IO_SHARE_ERRORS = [32, 33];
  I_MAX_ERRORS = 5;

  S_CSV_HEADER = 'Date,Time,Computer Name,Process ID,Thread ID,User ID,Application,Module,' +
                 'Exchequer Version,Exchequer Directory,Name,Level,Message,XD1,XD2,XD3';

var
  EntLogWriter : TEntLogWriter;

procedure StartLogWriter;
begin
  if not Assigned(EntLogWriter) then
  begin
    EntLogWriter := TEntLogWriter.Create;
    EntLogWriter.Resume;
  end;
end;

procedure StopLogWriter;
begin
  Try
    if Assigned(EntLogWriter) then
    begin
      EntLogWriter.Terminate;
      EntLogWriter := nil;
    end;
  Except
  End;
end;


{ TEntLogWriter }

constructor TEntLogWriter.Create;
begin
  inherited Create(True);

  //Initialise inherited properties
  Priority := tpLowest;
  FreeOnTerminate := True;

  //Initialise our variables
  FFatalError := False;
  FFatalErrorNo := 0;
  FErrorCount := 0;
  FLine := '';
  if LoggingIniFile <> nil then
  begin
    FFileName := LoggingIniFile.LogFileName;
    FAlwaysFileName := FFileName;

    //PR: 06/09/2011 Moved to GetFileAccess to allow use of different log files in the same application
    //AssignFile(FFile, FFilename);

    //FAppName is used in case of a fatal error, and will be used to identify the program in the Windows Event Log
    FAppName := Application.Title;
    if Trim(FAppName) = '' then
      FAppName := ExtractFileName(ParamStr(0));

    //Set OnTerminate event
    OnTerminate := WriteRemainingLines;
  end
  else
  begin
    Terminate;
    FFatalError := True;
    FFatalErrorNo := -1;
  end;
end;

procedure TEntLogWriter.Execute;
begin
  while not Terminated do
  begin
    //if FLine is blank then we need to read the next line (if any) from the log stringlist.
    if FLine = '' then
      GetNextLine;
    //if we have a line then write it to file.
    if FLine <> '' then
      WriteLine;
  end;
end;

function TEntLogWriter.GetFileAccess: Boolean;
var
  IORes : Integer;
  StartTime : Cardinal;
begin
  {$I-}
  //Try to open the log file for writing. If we get a 32 or 33 error, then some other
  //program is using it, so retry until we succeed or timeout
  StartTime := GetTickCount;
  repeat
    //PR: 06/09/2011 Moved AssignFile from .Create to allow use of different log files.
    AssignFile(FFile, FFilename);
    if FileExists(FFileName) then
      Append(FFile)
    else
    begin
      Rewrite(FFile);
      WriteLn(FFile, S_CSV_HEADER);
    end;
    IORes := IOResult;
  until (not (IORes in IO_SHARE_ERRORS)) or (GetTickCount - StartTime > I_TIMEOUT);

  Result := IORes = 0;

  //if we didn't succeed and it wasn't a sharing error, then terminate the thread
  if not Result and not (IORes in IO_SHARE_ERRORS) then
  begin
    inc(FErrorCount);
    if FErrorCount > I_MAX_ERRORS then
    begin
      FFatalError := True;
      FFatalErrorNo := IORes;
      Terminate;
    end;
  end;
  {$I+}
end;

procedure TEntLogWriter.GetNextLine;
begin
  //Wait for critical section
  EntLogProtector.Enter;
  Try
    Try
      //Get next line
      FLine := EntLogQueue.Read;

      //Check for log file name in the line we've just read
      SetFilename;
    Except
      //Hide any exceptions.
    End;
  Finally
    EntLogProtector.Leave;

    //PR: 17/10/2010 Added sleep to stop this process taking up full processor when nothing else was happening. ABSEXCH-11997
    SleepEx(1, True);
  End;
end;

procedure TEntLogWriter.SetFilename;
var
  i : integer;
begin
  //Check if we have a log file name at the start of the line - if so, set FFilename to use it, otherwise reset FFilename
  //to the original name.
  if Pos('LOG:', UpperCase(FLine)) = 1 then
  begin
    i := Pos(',', FLine);
    FFilename := Copy(FLine, 5, i - 5);
    Delete(FLine, 1, i);
  end
  else
    FFilename := FAlwaysFilename;
end;

procedure TEntLogWriter.WriteLine;
begin
  if GetFileAccess then
  {$I-}
  Try //Write current line, then clear it so we can get next line.
    WriteLn(FFile, FLine);
    if IOResult = 0 then
    begin
      FLine := '';
      FErrorCount := 0;
    end;
  Finally
    CloseFile(FFile);
  End;
  {$I+}
end;

procedure TEntLogWriter.WriteRemainingLines(Sender: TObject);
var
  i : integer;
  s : AnsiString;
  StartTime : Cardinal;
  GotFileAccess : Boolean;

  //Write message to Windows event log
  procedure EventLogMessage(Message: String);
  var
    P: Pointer;
    EventLog : Integer;
  begin
    Try
      P := PChar(Message);
      EventLog := RegisterEventSource(nil, PChar(FAppName));
      if EventLog <> 0 then
      Try
        ReportEvent(EventLog, 1, 0, 0, nil, 1, 0, @P, nil);
      Finally
        DeregisterEventSource(EventLog);
      End;
    Except
    End;
  end;

begin
  //This is the OnTerminate event, so when the thread is terminated, we can write
  //any remaining log lines to the file.
  Try
    if not FFatalError and (EntLogQueue.HasLines) then
    begin
      StartTime := GetTickCount;
      repeat
        GotFileAccess := GetFileAccess;
        if not GotFileAccess then
          Wait(10);
      until GotFileAccess or FFatalError or (GetTickCount - StartTime > I_TERMINATE_TIMEOUT);

      if GotFileAccess then
      {$I-}
      EntLogProtector.Enter;
      Try
        while FLine <> '' do
        begin
          FLine := EntLogQueue.Read;
          if FLine <> '' then
            WriteLn(FFile, FLine);
        end;
      Finally
        CloseFile(FFile);
        EntLogProtector.Leave;
      End;
      {$I+}
    end;
  Except
  End;

  if FFatalError then //We're closing down because we can't write to the log file, so just output a message to Windows Event Log.
  Try
    EventLogMessage('Unable to write log file to ' + FFileName + '. I/O Error ' + IntToStr(FFatalErrorNo));
  Except
  End;
end;

Initialization
  EntLogWriter := nil;
end.
