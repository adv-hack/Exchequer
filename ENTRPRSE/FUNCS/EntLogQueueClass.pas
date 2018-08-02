unit EntLogQueueClass;

interface

uses
  SyncObjs, Classes;
{The log queue is implemented as a wrapper around a stringlist, with methods to add a line to the list, and to read and delete the
first line in the list. The constructor is private so that there can only be one queue object, which must be accessed by the
EntLogQueue function.}
type
  TEntLogQueue = Class
  private
    FList : TStringList;
    procedure WaitForLog;
    function GetHasLines: Boolean;

    constructor Create;
    destructor Destroy; override;
  public
    procedure Add(const s : string);
    function Read : string;
    property HasLines : Boolean read GetHasLines;
  end;

var
  EntLogProtector : TCriticalSection;

  function EntLogQueue : TEntLogQueue;

implementation

uses
  ApiUtil, Windows;

const
  I_CLOSING_TIMEOUT = 2000;

var
  LogQueue  : TEntLogQueue;

function EntLogQueue : TEntLogQueue;
begin
  if not Assigned(LogQueue) then
    LogQueue := TEntLogQueue.Create;

  Result := LogQueue;
end;

{ TEntLogQueue }

procedure TEntLogQueue.Add(const s: string);
begin
  FList.Add(s);
end;

constructor TEntLogQueue.Create;
begin
  inherited;
  FList := TStringList.Create;
end;

destructor TEntLogQueue.Destroy;
begin
  WaitForLog;
  inherited;
end;

function TEntLogQueue.GetHasLines: Boolean;
begin
  Result := FList.Count > 0;
end;

function TEntLogQueue.Read: string;
begin
  if FList.Count > 0 then
  begin
    Result := FList[0];
    FList.Delete(0);
  end
  else
    Result := '';
end;

//Called on close down. If there are any lines in the log that haven't been written,
//wait until they have or a certain time elapses.
procedure TEntLogQueue.WaitForLog;
var
  StartTime : Cardinal;
begin
  if FList.Count > 0 then
  begin
    StartTime := GetTickCount;
    repeat
      Wait(100);

    until (FList.Count = 0) or (GetTickCount - StartTime > I_CLOSING_TIMEOUT);
  end;
end;



Initialization

  EntLogProtector := TCriticalSection.Create;


Finalization
  EntLogProtector.Enter;
  Try
    EntLogQueue.Free;
  Finally
    EntLogProtector.Leave;
  End;
  EntLogProtector.Free;

end.
