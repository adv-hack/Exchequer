{*********************************************************}
{*                 APFAXCNV.PAS 4.01                     *}
{*      Copyright (c) TurboPower Software 1997-2001      *}
{*                 All rights reserved.                  *}                
{*********************************************************}

{.$DEFINE Debug}
{.$DEFINE Dump}

{$IFNDEF PRNDRV}
  !! Define PRNDRV in  Project | Options | Directories/Conditionals
  !! this will reduce the size of the driver
{$ENDIF}

library ApFaxCnv;
uses
  Windows,
  SysUtils,
  Registry,
  OOMisc,
  AwFaxCvt,
  Dialogs, {NF: Added 11/01/2002}
  FileUtil, 
  APIUtil; {NF: Added 11/01/2002}

{$R *.RES}


{$IFDEF Debug}

const
  Version = '1';

var
  T : Text;

procedure LogEvent(Msg : ShortString);
  {- Write line of trace info to C:\FAXCONV.LOG}
begin
  try
    AssignFile(T,'C:\FAXCONV.LOG');
    try
      Append(T);
    except
      on E:EInOutError do
        if E.ErrorCode = 2 then
          Rewrite(T)
        else
          raise;
    end;
    Write(T,DateTimeToStr(Now),':');
    WriteLn(T,Msg);
    CloseFile(T);
  except
    ShowException(ExceptObject,ExceptAddr);
  end;
end;
{$ENDIF}

function ClientAppRunning : Boolean;
  {- Check whether the controlling app. has been started.}
var
  Semaphore : THandle;
begin
  Result := False;

  Semaphore := OpenSemaphore(SYNCHRONIZE, False, ApdSemaphoreName);
  if Semaphore <> 0 then
    begin
      CloseHandle(Semaphore);
      Result := True;
    end
  else
    begin
      {$IFDEF Debug}
      LogEvent('OpenSemaphore failed.');
      LogEvent('Reason:'+IntToStr(GetLastError));
      {$ENDIF}
    end;

  {$IFDEF Debug}
  LogEvent('ClientAppRunning?');
  if Result then
    LogEvent('Yes')
  else
    LogEvent('No');
  {$ENDIF}
end;

function GetClientAppPath : string;
  {- Read the client app path (if any) from the registry.}
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(ApdRegKey,False);
    Result := Reg.ReadString('AutoExec');
    {$IFDEF Debug}
    LogEvent('GetClientAppPath:'+Result);
    {$ENDIF}
  finally
    Reg.Free;
  end;
end;

function GetTimeout : LongInt;
  {- Read the timeout value for waiting for the client from the registry.}
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(ApdRegKey,False);
    try
      Result := Reg.ReadInteger('Timeout');
    except
      Result := LongInt(INFINITE);
    end;
    {$IFDEF Debug}
    LogEvent('Timeout:'+IntToStr(Result));
    {$ENDIF}
  finally
    Reg.Free;
  end;
end;

function GetShellHandle : THandle;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(ApdRegKey, False);
    try
      Result := Reg.ReadInteger('ShellHandle');
    except
      Result := INVALID_HANDLE_VALUE;
    end;
    {$IFDEF Debug}
    LogEvent('ShellHandle:'+IntToStr(Result));
    {$ENDIF}
  finally
    Reg.Free;
  end;
end;

function GetShellName : string;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(ApdRegKey, False);
    try
      Result := Reg.ReadString('ShellName');
    except
      Result := ApdDefFileName;
    end;
    {$IFDEF Debug}
    LogEvent('ShellName:'+Result);
    {$ENDIF}
  finally
    Reg.Free;
  end;
end;

procedure RemoveShellRegKeys;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(ApdRegKey,False);
    Reg.DeleteValue('ShellName');
    Reg.DeleteValue('ShellHandle');
    {$IFDEF Debug}
    LogEvent('Removed shell reg keys');
    {$ENDIF}
  finally
    Reg.Free;
  end;
end;

function StartClientApp(AppPath : string) : Bool;
  {- Execute command line with default settings.}
var
  StartupInfo : TStartupInfo;
  ProcessInfo : TProcessInformation;
begin
  FillChar(StartupInfo,Sizeof(StartupInfo),0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_SHOWDEFAULT;
  {$IFDEF Debug}
  LogEvent('StartClientApp:'+AppPath);
  {$ENDIF}
  Result :=
  CreateProcess(
    nil,                   {Application name (nil = take from next arg.)}
    pChar(AppPath),
    nil,                   {Process security attributes}
    nil,                   {Thread security attributes}
    false,                 {Inheritance flag}
    CREATE_NEW_CONSOLE or  {Creation flags}
    NORMAL_PRIORITY_CLASS,
    nil,                   {Environment block}
    nil,                   {Current directory name}
    StartupInfo,
    ProcessInfo);
  {$IFDEF Debug}
  if not Result then
    LogEvent('CreateProcess failed. Reason:'+IntToStr(GetLastError));
  {$ENDIF}
end;

const
  BufferSize = 16384; // Could be anything > 560 (two landscape scan lines)
type
  pScanNode = ^tScanNode;
  tScanNode =
    record
      {used for landscape orientation only}
      ScanLines : array[1..8] of pointer;
      slIndex   : byte;
      NextNode  : pScanNode;
    end;
  TBuffer = array[0..pred(BufferSize)] of Byte;
  TFaxConvData = record
    {$IFDEF Dump}
    FileHandle      : THandle;               {Raw dump file handle}
    {$ENDIF}
    apfConverter    : PAbsFaxCvt;            {Converter handle}
    cvtLastError    : Integer;               {Last error reported by converter}
    Buffer          : TBuffer;               {Local data buffer}
    ReadPtr         : 0..pred(BufferSize);   {Next byte to be processed}
    BytesInBuffer   : 0..BufferSize;         {Bytes in buffer}
    HaveData        : Bool;                  {Indicates whether data has been converted but not written}
    IsLandscape     : Bool;
    slDest          : PByteArray;            {Used duting landscape rotation}
    slDataSize      : Integer;               {Used duting landscape rotation}
    slBitWidth      : Integer;
    FirstScanNode   : pScanNode;
    CurrentScanNode : pScanNode;
  end;
  PFaxConvData = ^TFaxConvData;

procedure FaxConvInit; cdecl;
  {- Called by port driver during initialization.}
  {- Can be used for initialization.}
begin
  try
    {$IFDEF Debug}
    LogEvent('FaxConvInit');
    {$ENDIF}
    { make sure we don't have any residual registry keys... }
    RemoveShellRegKeys;
  except
    ShowException(ExceptObject,ExceptAddr);
  end;
end;

function FaxConvStartDoc(DocName : PWideChar) : THandle; cdecl;
  {- Called by port driver when a new document is about to print.}
  {- Create output file(s) and notify client (if any).}
var
  FaxConvData        : PFaxConvData {Our data structure for this job.}
    absolute Result;                {Note! Pointer treated as handle.}
  Res                : Bool;        {Pipe API result var.}
  BytesReadFromPipe  : DWord;
  Semaphore          : THandle;     {For waiting for client to start.}
  PipeReadBuffer,
  PipeWriteBuffer    : TPipeEvent;
  ClientAppName      : string;      {Path to auto-start client.}
  ShellHandle        : THandle;
  pPipeName : PChar; {NF: Added 11/01/2002}
begin
  {NF: Added 11/01/2002}
  SetPipename; {NF: Added 20/09/2005}
{  if GetWindowsVersion in wvTSVersions then sExtraPipeName := WinGetUserName
  else sExtraPipeName := '';}

//Debugtofile(sExtraPipeName + 'APFAXCNV 1');

  {$IFDEF Debug}
  LogEvent('FaxConvStartDoc'+WideCharToString(DocName));
  {$ENDIF}
  try
    Result := 0;
    { see if the TApdFaxConverter is doing a ShellExecute }
    ShellHandle := GetShellHandle;
    if ShellHandle = INVALID_HANDLE_VALUE then begin
      if not ClientAppRunning then begin
        ClientAppName := GetClientAppPath;
        if ClientAppName <> '' then begin
          Semaphore := CreateSemaphore(nil, 0, 1, ApdSemaphoreName);
          if Semaphore <> 0 then
            try
              if StartClientApp(ClientAppName) then
                begin
                  {$IFDEF Debug}
                  LogEvent('Client app. started');
                  {$ENDIF}
                  if Semaphore <> 0 then begin
                    {$IFDEF Debug}
                    LogEvent('Waiting for client...');
                    {$ENDIF}
                    WaitForSingleObject(Semaphore,GetTimeout);
                    {$IFDEF Debug}
                    LogEvent('Client signaled');
                    {$ENDIF}
                  end;
                end
              else
                begin
                  {$IFDEF Debug}
                  LogEvent('!!! Client app. didn''t start');
                  {$ENDIF}
                end;
            finally
              CloseHandle(Semaphore);
            end
          else
            {$IFDEF Debug}
            LogEvent('Unable to create semaphore');
            {$ENDIF}
        end;
      end;
    end;
    New(FaxConvData);

    {$IFDEF Dump}
    FaxConvData^.FileHandle := CreateFile( 'C:\FAXCONV.DMP', GENERIC_WRITE, FILE_SHARE_READ, nil,
                          OPEN_ALWAYS,
                          FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN,
                          0 );

    if FaxConvData^.FileHandle <> INVALID_HANDLE_VALUE then
      SetEndOfFile(FaxConvData^.FileHandle);
    {$ENDIF}

    with FaxConvData^  do begin

      BytesInBuffer := 0;
      ReadPtr := 0;

      acInitFaxConverter(apfConverter, nil, nil, nil, nil, '');

      acSetResolutionMode(apfConverter, True); // High

      if ShellHandle <> INVALID_HANDLE_VALUE then begin
        ClientAppName := GetShellName;  //re-using ClientAppName
        StrPCopy(apfConverter^.OutFileName, ClientAppName);
      end else begin
        apfConverter^.OutFilename := ApdDefFileName;

        PipeWriteBuffer.Event := eStartDoc;
        PipeWriteBuffer.Data := WideCharToString(DocName);

        pPipeName := StrAlloc(255); {NF: Added 11/01/2002}

//Debugtofile(sExtraPipeName + 'APFAXCNV 2');

        StrPCopy(pPipeName, ApdPipeName + sExtraPipeName); {NF: Added 11/01/2002}

        Res := CallNamedPipe(pPipeName, {NF: Changed 11/01/2002}
                             @PipeWriteBuffer, sizeof(PipeWriteBuffer),
                             @PipeReadBuffer, sizeof(PipeReadBuffer),
                             BytesReadFromPipe, NMPWAIT_USE_DEFAULT_WAIT);
        StrDispose(pPipeName); {NF: Added 21/03/2001}

        if Res then
          begin
            {$IFDEF Debug}
            LogEvent(format('Wrote %d bytes to pipe.',[sizeof(PipeWriteBuffer)]));
            LogEvent(format('Read %d bytes from pipe.',[BytesReadFromPipe]));
            {$ENDIF}
            if BytesReadFromPipe > 0 then begin
              {$IFDEF Debug}
              LogEvent(format('Read code %d from pipe.',[PipeReadBuffer.Event]));
              {$ENDIF}
              StrPCopy(apfConverter^.OutFilename,PipeReadBuffer.Data);
              {$IFDEF Debug}
              LogEvent('File name supplied:'+apfConverter^.OutFilename);
              {$ENDIF}
            end;
          end
        else
          begin
            {$IFDEF Debug}
            LogEvent('CallNamedPipe failed. Reason:'+IntToStr(GetLastError));
            {$ENDIF}
          end;
      end;
      {$IFDEF Debug}
      LogEvent('Output file: ' + apfConverter^.OutFilename);
      {$ENDIF}
      cvtLastError := acCreateOutputFile(apfConverter);
      if cvtLastError <> ecOk then begin
        {$IFDEF Debug}
        LogEvent('acCreateOutputFile failure'+IntToStr(cvtLastError));
        {$ENDIF}
        exit;
      end;
    end;
    
    FaxConvData.apfConverter.StatusWnd := ShellHandle;                   {!!.01}
  except
    ShowException(ExceptObject,ExceptAddr);
  end;
end;

{Codes defined by the printer mini-driver}
const
  BEGINDOC = $41;
  BEGINPAGE = $42;
  ENDDOC = $43;
  ENDPAGE = $44;
  ABORT = $45;
  PORTRAIT = $46;
  LANDSCAPE = $47;
  MULTCOP = $48;
  XM_ABS = $58;
  YM_ABS = $59;
  SENDBLOCK = $4D;
  ENDBLOCK = $4E;
  HIRES = $52;
  LORES = $53;

procedure Advance(Handle : THandle);
  {- Move buffer read pointer one byte forward}
var
  FaxConvData : PFaxConvData absolute Handle;
begin
  with FaxConvData^ do begin
    inc(ReadPtr);
    dec(BytesInBuffer);
  end;
end;

procedure AdvanceN(Handle : THandle;N : DWord);
  {- Move buffer read pointer N bytes forward}
var
  FaxConvData : PFaxConvData absolute Handle;
begin
  with FaxConvData^ do begin
    inc(ReadPtr,N);
    dec(BytesInBuffer,N);
  end;
end;

procedure ProcessBuffer(Handle : THandle);
  {- Process next escape sequence in buffer, then advance the pointer.}
var
  FaxConvData : PFaxConvData absolute Handle;
  S : string;
  N,i : integer;
  {$IFDEF Dump}
  BytesWritten : DWord;
  {$ENDIF}
begin
  with FaxConvData^ do
    case Buffer[ReadPtr] of
    $1B :
      begin
        Advance(Handle);
        case Buffer[ReadPtr] of
        BEGINDOC :
          begin
            {$IFDEF Debug}
            LogEvent('BEGINDOC');
            LogEvent(Version);
            {$ENDIF}
            Advance(Handle);
            HaveData := False;
          end;
        BEGINPAGE :
          begin
            {$IFDEF Debug}
            LogEvent('BEGINPAGE');
            {$ENDIF}
            Advance(Handle);
            inc(apfConverter^.CurrPage);
          end;
        ENDDOC :
          begin
            {$IFDEF Debug}
            LogEvent('ENDDOC');
            {$ENDIF}
            Advance(Handle);
          end;
        ENDPAGE :
          begin
            if apfConverter.StatusWnd <> INVALID_HANDLE_VALUE then       {!!.01}
              PostMessage(apfConverter.StatusWnd, apw_EndPage, 0, 0);    {!!.01}
            {$IFDEF Debug}
            LogEvent('ENDPAGE');
            LogEvent('*** PostMessage to: ' + IntToStr(apfConverter.StatusWnd));
            {$ENDIF}
            with apfConverter^  do begin
              FillChar(TmpBuffer^, MaxData, 0);
              if HaveData then
                begin
                  N := ByteOfs;
                  HaveData := False;
                end
              else
                N := 0;
              cvtLastError := acOutToFileCallBack(apfConverter, DataLine^, N, True, True);
            end;
            Advance(Handle);

          end;
        ABORT :
          begin
            {$IFDEF Debug}
            LogEvent('ABORT');
            {$ENDIF}
            Advance(Handle);
          end;
        PORTRAIT :
          begin
            {$IFDEF Debug}
            LogEvent('PORTRAIT');
            {$ENDIF}
            IsLandscape := False;
            Advance(Handle);
          end;
        LANDSCAPE :
          begin
            {$IFDEF Debug}
            LogEvent('LANDSCAPE');
            {$ENDIF}
            IsLandscape := True;
            Advance(Handle);
          end;
        MULTCOP :
          begin
            {$IFDEF Debug}
            LogEvent('MULTCOP');
            {$ENDIF}
            Advance(Handle);
          end;
        XM_ABS :
          begin
            {$IFDEF Debug}
            LogEvent('XM_ABS');
            {$ENDIF}
            Advance(Handle);
            S := '';
            while char(Buffer[ReadPtr]) <> 'X' do begin
              S := S + char(Buffer[ReadPtr]);
              Advance(Handle);
            end;
            Advance(Handle);
            {$IFDEF Debug}
            LogEvent(S);
            {$ENDIF}
          end;
        YM_ABS :
          begin
            {$IFDEF Debug}
            LogEvent('YM_ABS');
            {$ENDIF}
            Advance(Handle);
            S := '';
            while char(Buffer[ReadPtr]) <> 'Y' do begin
              S := S + char(Buffer[ReadPtr]);
              Advance(Handle);
            end;
            Advance(Handle);
            {$IFDEF Debug}
            LogEvent(S);
            {$ENDIF}
            N := StrToInt(S);
            { in Standard Res, RASDD is giving us YMove twice as big as they }
            { should be, we're dividing the increment in half here }
            if not apfConverter^.UseHighRes then
              N := N div 2;
            if HaveData then begin
              with ApfConverter^  do
                cvtLastError := acOutToFileCallBack(apfConverter, DataLine^, ByteOfs, False, True);
              HaveData := False;
            end;
            with ApfConverter^  do begin
              FillChar(TmpBuffer^, MaxData, 0);
              acCompressRasterLine(apfConverter, TmpBuffer^);
            end;
            for i := 1 to pred(N) do
              with ApfConverter^  do
                cvtLastError := acOutToFileCallBack(apfConverter, DataLine^, ByteOfs, False, True);
          end;
        SENDBLOCK :
          begin
            if HaveData then begin
              with ApfConverter^  do
                cvtLastError := acOutToFileCallBack(apfConverter, DataLine^, ByteOfs, False, True);
              HaveData := False;
            end;
            {$IFDEF Debug}
            LogEvent('SENDBLOCK');
            {$ENDIF}
            Advance(Handle);
            S := '';
            while char(Buffer[ReadPtr]) <> 'M' do begin
              S := S + char(Buffer[ReadPtr]);
              Advance(Handle);
            end;
            Advance(Handle);
            {$IFDEF Debug}
            LogEvent(S);
            {$ENDIF}
            N := StrToInt(S);

            {$IFDEF Dump}
            WriteFile(FileHandle,Buffer[ReadPtr],N,BytesWritten,nil);
            {$ENDIF}

            with ApfConverter^  do begin

              FillChar(TmpBuffer^, MaxData, 0);
              Move(Buffer[ReadPtr], TmpBuffer^, N);
              acCompressRasterLine(apfConverter, TmpBuffer^);
              FillChar(TmpBuffer^, MaxData, 0);
              HaveData := True;
            end;
            AdvanceN(Handle,N);
          end;
        ENDBLOCK :
          begin
            {$IFDEF Debug}
            LogEvent('ENDBLOCK');
            {$ENDIF}
            Advance(Handle);
          end;
        HIRES :
          begin
            {$IFDEF Debug}
            LogEvent('HIRES');
            {$ENDIF}
            Advance(Handle);
            acSetResolutionMode(apfConverter, True);
          end;
        LORES :
          begin
            {$IFDEF Debug}
            LogEvent('LORES');
            {$ENDIF}
            Advance(Handle);
            acSetResolutionMode(apfConverter, False);
          end;
        else
          raise Exception.CreateFmt('Unexpected subcode in stream:%x',[Buffer[ReadPtr]]);
        end
      end;
    else
      raise Exception.CreateFmt('Unexpected code in stream:%x',[Buffer[ReadPtr]]);
    end;
end;

procedure TrimBuffer(Handle : THandle);
  {- Remove data already processed from the buffer.}
var
  FaxConvData : PFaxConvData absolute Handle;
begin
  with FaxConvData^ do begin
    move(Buffer[ReadPtr],Buffer,BytesInBuffer);
    ReadPtr := 0;
  end;
end;

procedure AddToBuffer(Handle : THandle;var InBuffer;InBufSize : DWord);
  {- Append data to buffer - process and trim as necessary to make it fit.}
var
  FaxConvData : PFaxConvData absolute Handle;
begin
  with FaxConvData^ do begin
    while BytesInBuffer + InBufSize > BufferSize do
      ProcessBuffer(Handle);
    TrimBuffer(Handle);
    move(InBuffer,Buffer[BytesInBuffer],InBufSize);
    inc(BytesInBuffer,InBufSize);
  end;
end;

procedure FaxConvEndDoc(Handle : THandle); cdecl;
  {- Called by driver when no more data is pending.}
  {- Process any remaining data in buffer and close output file(s).}
var
  FaxConvData : PFaxConvData absolute Handle;
  PipeWriteBuffer : TPipeEvent;
  BytesReadFromPipe : DWord;
  ShellHandle : THandle;
  pPipeName : PChar; {NF: Added 21/03/2001}
begin
  try
    {$IFDEF Debug}
    LogEvent('FaxConvEndDoc');
    {$ENDIF}
    with FaxConvData^ do begin
      while BytesInBuffer > 0 do
        ProcessBuffer(Handle);

      {$IFDEF Dump}
      CloseHandle(FaxConvData.FileHandle);
      {$ENDIF}

      if apfConverter <> nil then begin
        with apfConverter^ do
          cvtLastError := acCloseOutputFile(apfConverter);

        {$IFDEF Debug}
        LogEvent('Closing output file: ' + apfConverter^.OutFilename);
        if cvtLastError <> ecOk then
          LogEvent('acCloseOutputFile failure'+IntToStr(cvtLastError));
        {$ENDIF}

        acDoneFaxConverter(apfConverter);

        ShellHandle := GetShellHandle;
        if ShellHandle <> INVALID_HANDLE_VALUE then begin
          {$IFDEF Debug}
          LogEvent('Posting message to fax converter (' + IntToStr(ShellHandle) + ')');
          {$ENDIF}
          PostMessage(ShellHandle, apw_EndDoc, 0, 0);
          RemoveShellRegKeys;
        end else begin
          PipeWriteBuffer.Event := eEndDoc;

          pPipeName := StrAlloc(255); {NF: Added 11/01/2002}

//Debugtofile(sExtraPipeName + 'APFAXCNV 3');

          StrPCopy(pPipeName, ApdPipeName + sExtraPipeName); {NF: Added 11/01/2002}
          CallNamedPipe(pPipeName, {NF: Changed 11/01/2002}
                        @PipeWriteBuffer, sizeof(PipeWriteBuffer),
                        nil,0,
                        BytesReadFromPipe, NMPWAIT_NOWAIT);
          StrDispose(pPipeName); {NF: Added 11/01/2002}
        end;

      end;
    end;
    Dispose(FaxConvData);
  except
    ShowException(ExceptObject,ExceptAddr);
  end;
end;

procedure FaxConvConvert(Handle : THandle;var InBuffer; InBufSize : DWord); cdecl;
  {- Called by driver for each block of data sent by Windows.}
  {- Put data block in buffer.}
var
  FaxConvData : PFaxConvData absolute Handle;
begin
  try
    {$IFDEF Debug}
    LogEvent('FaxConvConvert');
    {$ENDIF}
    AddToBuffer(Handle,InBuffer,InBufSize);
  except
    ShowException(ExceptObject,ExceptAddr);
  end;
end;

exports
  FaxConvInit,
  FaxConvStartDoc,
  FaxConvEndDoc,
  FaxConvConvert;

begin
//  Debugtofile('APFAXCNV Started');
end.

