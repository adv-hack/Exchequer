(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msCls;

{$I msdef.inc}

interface

uses
  Windows,
{$IFDEF VCL}
  Forms,
  ExtCtrls,
  Messages,
  Consts,
  Controls,
{$ENDIF}
  Classes;

const
  BadString = #255#255#255#255;

type

  TmsTempFileStream = class(TFileStream)
  private
    FFileName : string;
    FFile : file;
  protected
    function MakeTempFileName : string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromStream(Stream : TStream);
    procedure LoadFromFile(const FileName : string);
    procedure SaveToStream(Stream : TSTream);
    procedure SaveToFile(const FileName : string);
  end;

  TLineStream = class(TMemoryStream)
  private
    FLines : TStringList;
    FCurLine : Integer;
    FBufSize : Word;
    FEOS : boolean;
    procedure SetBufSize(Value : Word);
  protected
    Finished : boolean;
    procedure LoadNextPart;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Reset;
    function GetNextLine : string;
    property BufSize : Word read FBufSize write SetBufSize
                         default $4000;
    property EOS : boolean read FEOS;
 end;

{$IFDEF VCL}
  TmsTimer = class
  private
    FInterval: Cardinal;
    FWindowHandle: HWND;
    FOnTimer: TNotifyEvent;
    FEnabled: Boolean;
    procedure UpdateTimer;
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: Cardinal);
    procedure SetOnTimer(Value: TNotifyEvent);
    procedure WndProc(var Msg: TMessage);
  protected
    procedure Timer; dynamic;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Interval: Cardinal read FInterval write SetInterval default 1000;
    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
  end;

 TmsTimeCounter = class
 private
   FTimer : TmsTimer;
   FCount : Integer;
   FTimeOut : Integer;
   FTimedOut : boolean;
 protected
   procedure TimerOnTimer(Sender : TObject);
 public
   constructor Create;
   destructor Destroy; override;
   procedure TimerOn;
   procedure TimerOff;
   procedure TimerReset;
   property TimedOut : boolean read FTimedOut write FTimedOut;
   property TimeOut : Integer read FTimeOut write FTimeOut;
 end;

 TmsTimerThread = class(TThread)
 private
   TC : TmsTimer;
   FCount : Integer;
 protected
   procedure TimerOnTimer(Sender : TObject);
 public
   constructor Create(TimeOut : Integer);
   destructor Destroy; override;
   procedure Execute; override;
 end;
 {$ENDIF}

implementation

uses
  msUtils, SysUtils;

constructor TmsTempFileStream.Create;
begin
  FFileName:=MakeTempFileName;
  inherited Create(FFileName,fmCreate or fmOpenReadWrite);
end;

destructor TmsTempFileStream.Destroy;
begin
  inherited Destroy;
  AssignFile(FFile,FFileName);
  try
    Erase(FFile);
  except
    {Do Nothing}
  end;
end;

function TmsTempFileStream.MakeTempFileName : string;
var
  TempPath : array[0..255] of char;
  TempFileName : array[0..255] of char;
begin
{$IFDEF WIN32}
  GetTempPath(255,@TempPath);
  GetTempFileName(@TempPath,PChar('ms'),0,@TempFileName);
{$ELSE}
  GetTempFileName(#0,'ms',0,@TempFileName);
{$ENDIF}
  Result:=StrPas(@TempFileName);
end;

procedure TmsTempFileStream.LoadFromStream(Stream : TStream);
var
  Buf : PChar;
  rd : LongInt;
begin
  Buf:=StrAlloc(2048);
  try
    Position:=0;
    Stream.Position:=0;
    repeat
      rd:=Stream.Read(Buf^,2048);
      Write(Buf^,rd);
    until rd<2048;
  finally
    StrDispose(Buf);
  end;
end;

procedure TmsTempFileStream.LoadFromFile(const FileName : string);
var
  FileStream : TFileStream;
begin
  FileStream:=TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

procedure TmsTempFileStream.SaveToStream(Stream : TStream);
var
  Buf : PChar;
  rd : LongInt;
begin
  Buf:=StrAlloc(2048);
  try
    Position:=0;
    Stream.Position:=0;
    repeat
      rd:=Read(Buf^,2048);
      Stream.Write(Buf^,rd);
    until rd<2048;
  finally
    StrDispose(Buf);
  end;
end;

procedure TmsTempFileStream.SaveToFile(const FileName : string);
var
  FileStream : TFileStream;
begin
  FileStream:=TFileStream.Create(FileName, fmOpenWrite or fmCreate);
  try
    SaveToStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

constructor TLineStream.Create;
begin
  inherited Create;
  FLines:=TStringList.Create;
  Finished:=false;
  FCurLine:=-1;
  FEOS:=false;
  FBufSize:=$4000;
end;

destructor TLineStream.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

procedure TLineStream.SetBufSize(Value : word);
begin
  if FBufSize<>Value then
    FBufSize:=Value;
end;

procedure TLineStream.LoadNextPart;
var
  Buf,BufEnd : PChar;
  rb : LongInt;
begin
  Buf:=StrAlloc(FBufSize);
  try
    FillChar(Buf^,FBufSize,0);
    rb:=Read(Buf^,FBufSize);
    Finished:=rb<FBufSize;
    BufEnd:=LineStart(Buf,Buf+FBufSize);
    Position:=Position-(Buf+FBufSize-BufEnd);
    if not Finished then
      BufEnd^:=#0;
{$IFDEF WIN32}
    FLines.SetText(Buf);
{$ELSE}
    BufToLines(Buf,FLines,255);
{$ENDIF}
  finally
    StrDispose(Buf);
  end;
end;

procedure TLineStream.Reset;
begin
  FCurLine:=-1;
  FLines.Clear;
  FEOS:=false;
  Position:=0;
  Finished:=false;
end;

function TLineStream.GetNextLine : string;
begin
  Inc(FCurLine);
  if FCurLine>=FLines.Count then
  begin
    if not Finished then
    begin
      LoadNextPart;
      FCurLine:=0;
      if FLines.Count>0 then
        Result:=FLines[FCurLine]
      else
      begin
        Result:=BadString;
        FEOS:=true;
      end;
    end
    else
    begin
      Result:=BadString;
      FEOS:=true;
    end;
  end
  else
    Result:=FLines[FCurLine];
end;

{$IFDEF VCL}
constructor TmsTimer.Create;
begin
  inherited Create;
  FEnabled := True;
  FInterval := 1000;
  FWindowHandle := AllocateHWnd(WndProc);
end;

destructor TmsTimer.Destroy;
begin
  FEnabled := False;
  UpdateTimer;
  DeallocateHWnd(FWindowHandle);
  inherited Destroy;
end;

procedure TmsTimer.WndProc(var Msg: TMessage);
begin
  with Msg do
    if Msg = WM_TIMER then
      try
        Timer;
      except
        Application.HandleException(Self);
      end
    else
      Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
end;

procedure TmsTimer.UpdateTimer;
begin
  KillTimer(FWindowHandle, 1);
  if (FInterval <> 0) and FEnabled and Assigned(FOnTimer) then
    if SetTimer(FWindowHandle, 1, FInterval, nil) = 0 then
      raise EOutOfResources.Create('Not enough timers');
end;

procedure TmsTimer.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    UpdateTimer;
  end;
end;

procedure TmsTimer.SetInterval(Value: Cardinal);
begin
  if Value <> FInterval then
  begin
    FInterval := Value;
    UpdateTimer;
  end;
end;

procedure TmsTimer.SetOnTimer(Value: TNotifyEvent);
begin
  FOnTimer := Value;
  UpdateTimer;
end;

procedure TmsTimer.Timer;
begin
  if Assigned(FOnTimer) then FOnTimer(Self);
end;

{TmsTimeCounter}
constructor TmsTimeCounter.Create;
begin
  inherited Create;
  FTimer:=TmsTimer.Create;
  FTimer.Enabled:=false;
  FTimeOut:=60;
  FTimer.OnTimer:=TimerOnTimer;
end;

destructor TmsTimeCounter.Destroy;
begin
  FTimer.Free;
  inherited Destroy;
end;

procedure TmsTimeCounter.TimerOnTimer(Sender : TObject);
begin
  Dec(FCount);
  if FCount<=0 then
    FTimedOut:=true;
end;

procedure TmsTimeCounter.TimerOn;
begin
  FCount:=FTimeOut;
  FTimer.Enabled:=true;
end;

procedure TmsTimeCounter.TimerOff;
begin
  FTimer.Enabled:=false;
end;

procedure TmsTimeCounter.TimerReset;
begin
  FCount:=FTimeOut;
  FTimedOut:=false;
  if not FTimer.Enabled then
    FTimer.Enabled:=true;
end;

{TmsTimerThread}
constructor TmsTimerThread.Create(TimeOut : Integer);
begin
  inherited Create(false);
  FreeOnTerminate:=true;
  TC:=TmsTimer.Create;
  FCount:=TimeOut;
  TC.OnTimer:=TimerOnTimer;
end;

destructor TmsTimerThread.Destroy;
begin
  TC.Free;
  inherited Destroy;
end;

procedure TmsTimerThread.TimerOnTimer(Sender : TObject);
begin
  Dec(FCount);
  if FCount<=0 then
    Terminate;
end;

procedure TmsTimerThread.Execute;
begin
  TC.Enabled:=true;
end;
{$ENDIF}

end.
