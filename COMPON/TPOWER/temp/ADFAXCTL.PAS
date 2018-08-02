{*********************************************************}
{*                   ADFAXCTL.PAS 4.03                   *}
{*      Copyright (c) TurboPower Software 1997-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$T-}

unit AdFaxCtl;
  {- Controller component for printer drivers.}
interface

uses
  WinTypes,
  WinProcs,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ooMisc;

type
  TApdFaxDriverInterface = class;

  {$IFDEF Win32}

  {Thread for monitoring messages from the NT driver}
  TMonitorThread = class(TThread)
    Owner      : TApdFaxDriverInterface; {Link to component}
    Pipe       : THandle;            {Connection with driver}
    Overlapped : TOverlapped;        {Used to control overlapped i/o}
    Semaphore  : THandle;            {Used for sync. with driver}
    Events     : array[0..1] of THandle;
      // Stop & Overlapped finished - array used for WaitForMultiple...
    procedure Execute; override;
  end;
  {$ENDIF Win32}

  TApdFaxDriverInterface = class(TApdBaseComponent)
  private
    fFileName,
    fDocName      : string;
    fOnDocStart,
    fOnDocEnd     : TNotifyEvent;

    {$IFDEF Win32}
    MonitorThread : TMonitorThread;
    SecDesc       : TSecurityDescriptor;
    SecAttr       : TSecurityAttributes;
    {$ENDIF Win32}

    FWindowHandle : HWND;
  protected
    procedure WndProc(var Msg: TMessage);
    procedure NotifyStartDoc; virtual;
    procedure NotifyEndDoc; virtual;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property DocName : string read fDocName;
  published
    property FileName : string read fFileName write fFileName;
    property OnDocStart: TNotifyEvent read fOnDocStart write fOnDocStart;
    property OnDocEnd: TNotifyEvent read fOnDocEnd write fOnDocEnd;
  end;

implementation
{$IFDEF TRIALRUN}
{$I TRIAL07.INC}
{$I TRIAL03.INC}
{$I TRIAL01.INC}
{$ENDIF}

{$IFDEF Win32}
procedure TMonitorThread.Execute;
  {- Monitor thread. Looks for "events" coming through the pipe from the driver.}
var
  Wait, BytesRead, BytesWritten : DWord;
  InBuffer,OutBuffer : TPipeEvent;
  Res : Bool;
begin
  repeat
    fillchar(Overlapped,sizeof(Overlapped),0);
    Overlapped.hEvent := Events[1];
    ResetEvent(Events[1]);

    ConnectNamedPipe(Pipe, @Overlapped);  // wait for driver to send something

    if GetLastError = ERROR_IO_PENDING then begin
      Wait := WaitForMultipleObjects(2, @Events, FALSE, INFINITE);
      if Wait <> WAIT_OBJECT_0+1 then     // not overlapped i/o event - error occurred,
        break;                            // or stop signaled
    end;

    fillchar(Overlapped,sizeof(Overlapped),0);
    Overlapped.hEvent := Events[1];
    ResetEvent(Events[1]);

    Res := ReadFile(
      Pipe,
      InBuffer,
      sizeof(InBuffer),
      BytesRead,
      @Overlapped);

    if not Res and (GetLastError = ERROR_IO_PENDING) then
      begin
        Wait := WaitForMultipleObjects(2, @Events, False, Infinite);
        if Wait <> WAIT_OBJECT_0+1 then    // not overlapped i/o event - error occurred,
          Break;                           // or stop signaled
        GetOverlappedResult(Pipe,Overlapped,BytesRead,False);
      end;

    if BytesRead > 0 then begin
      case InBuffer.Event of
      eNull : ;
      eStartDoc :
        begin
          Owner.fDocName := InBuffer.Data;
          Synchronize(Owner.NotifyStartDoc);
        end;
      eEndDoc :
        begin
          Synchronize(Owner.NotifyEndDoc);
        end;
      else
        raise Exception.CreateFmt('Unknown incoming event encountered:%d',[InBuffer.Event]);
      end;

      case InBuffer.Event of
      eStartDoc :
        begin
          fillchar(Overlapped,sizeof(Overlapped),0);
          Overlapped.hEvent := Events[1];
          ResetEvent(Events[1]);

          OutBuffer.Event := eSetFileName;
          OutBuffer.Data := Owner.FileName;

          Res := WriteFile(
            Pipe,
            OutBuffer,
            sizeof(OutBuffer),
            BytesWritten,
            @Overlapped);

          if not Res and (GetLastError() = ERROR_IO_PENDING) then begin
            Wait := WaitForMultipleObjects(2, @Events, FALSE, INFINITE);
            if Wait <> WAIT_OBJECT_0+1 then    // not overlapped i/o event - error occurred,
              Break;                           // or stop signaled
          end;
        end;
      end;
    end;

    DisconnectNamedPipe(Pipe);
  until false;
  Suspend;
end;

function IsWinNT : Boolean;
  {- Are we running under Windows NT}
{$IFDEF TRIALRUN}
{$I TRIAL04.INC}
{$ENDIF}
var
  Osi : TOSVersionInfo;
begin
  {$IFDEF TRIALRUN}
  TC;
  {$ENDIF}
  Osi.dwOSVersionInfoSize := sizeof(Osi);
  GetVersionEx(Osi);
  Result := (Osi.dwPlatformID = Ver_Platform_Win32_NT);
end;
{$ENDIF Win32}

constructor TApdFaxDriverInterface.Create;
var
  pPipeName : PChar; {NF: Added 21/03/2001}
begin
  inherited Create(AOwner);
  fFileName := ApdDefFileName;
  fDocName := '';
  pPipeName := StrAlloc(255); {NF: Added 21/03/2001}
  if csDesigning in ComponentState then exit;
  {$IFDEF Win32}
  if IsWinNT then
    begin {32-bit (NT) driver communicates via a named pipe}
      MonitorThread := TMonitorThread.Create(True); // Suspended
      try
        MonitorThread.Owner := Self;
        with MonitorThread do begin
          {Create security descriptor for pipe}
          if not InitializeSecurityDescriptor(@SecDesc, 1) then
            raise Exception.Create('Unable to initialize security descriptor');

          if not SetSecurityDescriptorDacl(@SecDesc, True, nil, False) then
            raise Exception.Create('Unable to set security DACL');

          {Create security attributes record for the pipe}
          SecAttr.nLength := sizeof(SecAttr);
          SecAttr.lpSecurityDescriptor := @SecDesc;
          SecAttr.bInheritHandle := True;

          {Create pipe that the driver can communicate through}
          Pipe := INVALID_HANDLE_VALUE;

          StrPCopy(pPipeName, ApdPipeName + sExtraPipeName); {NF: Added 21/03/2001}
          Pipe := CreateNamedPipe(
            pPipeName, {NF: Changed 21/03/2001}                                              {!!.03}
            FILE_FLAG_OVERLAPPED or
            PIPE_ACCESS_DUPLEX,     // pipe open mode
            PIPE_TYPE_MESSAGE or
            PIPE_READMODE_MESSAGE or
            PIPE_WAIT,              // pipe IO type
            1,                      // number of instances
            sizeof(TPipeEvent),     // size of outbuf (0 = allocate as necessary)
            sizeof(TPipeEvent),     // size of inbuf
            ApdPipeTimeout,         // default time-out value
            @SecAttr);              // security attributes

          if (Pipe = INVALID_HANDLE_VALUE) or (Pipe = 0) then
            raise Exception.CreateFmt('Unable to create named pipe. Error:%d',[GetLastError]);
          try
            {Create events to signal Overlapped i/o and Stop.}
            Events[0] := CreateEvent(nil,true,False,nil);
            if Events[0] = 0 then
              raise Exception.Create('Unable to create event');
            try
              Events[1] := CreateEvent(nil,true,False,nil);
              if Events[1] = 0 then
                raise Exception.Create('Unable to create event');
              try

                {Start monitor thread}
                Resume;

                {Check if we were started by driver}
                Semaphore := OpenSemaphore(EVENT_ALL_ACCESS, False, ApdSemaphoreName); 
                if Semaphore <> 0 then
                  begin
                    if not ReleaseSemaphore(Semaphore, 1, nil) then //tell driver to continue
                      raise Exception.Create('Unable to release semaphore');
                  end
                else {No, so...}
                  {Block driver from auto-starting another instance of us}
                  Semaphore := CreateSemaphore(nil, 0, 1, ApdSemaphoreName); 

              except
                CloseHandle(Events[1]);
                raise;
              end;
            except
              CloseHandle(Events[0]);
              raise;
            end;
          except
            CloseHandle(MonitorThread.Pipe);
            raise;
          end;
        end;
      except
        raise;
      end;
    end
  else
  {$ENDIF Win32}
    begin {16-bit driver communicates via messages}
      FWindowHandle := AllocateHWnd(WndProc);
      if FWindowHandle = 0 then
        raise Exception.Create('Unable to create "pipe" window');
      SetWindowText (FWindowHandle, pPipeName); {NF: Added 21/03/2001}
    end;
  StrDispose(pPipeName); {NF: Added 21/03/2001}
end;

destructor TApdFaxDriverInterface.Destroy;
begin
  fFileName := '';
  fDocName := '';
  if not (csDesigning in ComponentState) then begin
    {$IFDEF Win32}
    if IsWinNT then
      with MonitorThread do begin
        if not Suspended then begin
          SetEvent(Events[0]);     // tell monitor thread to terminate
          while not Suspended do;  // wait for it to do so before we pull the carpet
        end;
        CloseHandle(Events[0]);
        CloseHandle(Events[1]);
        CloseHandle(MonitorThread.Pipe);
        if Semaphore <> 0 then
          CloseHandle(Semaphore);
        Free;
      end
    else
    {$ENDIF Win32}
      DeallocateHWnd(FWindowHandle);
  end;
  inherited Destroy;
end;

procedure TApdFaxDriverInterface.NotifyStartDoc;
begin
  if Assigned(fOnDocStart) then
    fOnDocStart(Self);
end;

procedure TApdFaxDriverInterface.NotifyEndDoc;
begin
  if Assigned(fOnDocEnd) then
    fOnDocEnd(Self);
end;

procedure TApdFaxDriverInterface.WndProc(var Msg: TMessage);
  {- Window procedure for the 16-bit driver comm. window}
var
  JobNameBuffer : array[0..255] of char;
begin
  with Msg do
    if Msg = apw_BeginDoc then
      try
        GetWindowText(FWindowHandle,JobNameBuffer,sizeof(JobNameBuffer));
        fDocName := StrPas(JobNameBuffer);
        NotifyStartDoc;
        fFileName[length(fFileName)+1] := #0;
        SetWindowText(FWindowHandle,@fFileName[1]);
      except
        Application.HandleException(Self);
      end
    else
    if Msg = apw_EndDoc then
      try
        NotifyEndDoc;
      except
        Application.HandleException(Self);
      end
    else
      Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
end;

end.

