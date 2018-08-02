unit ProcMonDebugOutput;
 
interface

uses
  Windows;

const
//      FILE_WRITE_ACCESS           = $00000002;
//      METHOD_BUFFERED             = $00000000;
//      FILE_DEVICE_PROCMON_LOG     = $00009535;
//      IOCTL_EXTERNAL_LOG_DEBUGOUT = CTL_CODE(FILE_DEVICE_PROCMON_LOG,
//                                             $81,
//                                             METHOD_BUFFERED,
//                                             FILE_WRITE_ACCESS);
  IOCTL_EXTERNAL_LOG_DEBUGOUT = $95358204;

type
  TProcessMonitorLogger = class
  private
    class function Open(): THandle;
    class procedure Close();
    {$IF CompilerVersion >= 21}
    class constructor Create;
    class destructor Destroy;
    {$IFEND}
  public
    class function Output(const AOutputString: {$ifdef UNICODE}String{$else}WideString{$endif}): Boolean;
  end;
  PML = TProcessMonitorLogger;

implementation

var
  FDevice: THandle; // = INVALID_HANDLE_VALUE

{ TProcessMonitorLogger }

//function CTL_CODE(const ADevType, AFunc, AMethod, AAccess: Cardinal): Cardinal; inline;
//begin
//  Result := (ADevType shl 16) or (AAccess shl 14) or (AFunc shl 2) or AMethod;
//end;
 
{$IF CompilerVersion >= 21}
class constructor TProcessMonitorLogger.Create;
begin
  FDevice := INVALID_HANDLE_VALUE;
end;
 
class destructor TProcessMonitorLogger.Destroy;
begin
  Close();
end;
{$IFEND}
 
class procedure TProcessMonitorLogger.Close;
begin
  if INVALID_HANDLE_VALUE <> FDevice then
    begin
      CloseHandle(FDevice);
      FDevice := INVALID_HANDLE_VALUE;
    end;
end;
 
class function TProcessMonitorLogger.Open(): THandle;
begin
  if INVALID_HANDLE_VALUE = FDevice then
    FDevice := CreateFile('\\.\Global\ProcmonDebugLogger',
                            GENERIC_READ or GENERIC_WRITE,
                            FILE_SHARE_READ or FILE_SHARE_WRITE or FILE_SHARE_DELETE,
                            nil,
                            OPEN_EXISTING,
                            FILE_ATTRIBUTE_NORMAL,
                            0);
  Result := FDevice;
end;
 
class function TProcessMonitorLogger.Output(const AOutputString: {$ifdef UNICODE}String{$else}WideString{$endif}): Boolean;
var
  lProcMonHwnd: THandle;
  lInputLength: Cardinal;
  lOutputLength: Cardinal;
  lLastError: Cardinal;
begin
  Result := False;
  if AOutputString = '' then
    SetLastError(ERROR_INVALID_PARAMETER)
  else
    begin
      lProcMonHwnd := Open();
      if lProcMonHwnd <> INVALID_HANDLE_VALUE then
        begin
          lInputLength := Length(AOutputString) * SizeOf(WideChar);
          lOutputLength := 0;
          Result := DeviceIoControl(lProcMonHwnd,
                                    IOCTL_EXTERNAL_LOG_DEBUGOUT,
                                    PWideChar(AOutputString),
                                    lInputLength,
                                    nil,
                                    0,
                                    lOutputLength,
                                    nil);
          if not Result then
            begin
              lLastError := GetLastError();
              if lLastError = ERROR_INVALID_PARAMETER then
                SetLastError(ERROR_WRITE_FAULT);
            end;
        end
      else
        SetLastError(ERROR_BAD_DRIVER);
    end;
end;
 
{$IF CompilerVersion < 21}
initialization
  FDevice := INVALID_HANDLE_VALUE;
finalization
  TProcessMonitorLogger.Close();
{$IFEND}
end.