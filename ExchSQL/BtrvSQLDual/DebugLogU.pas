unit DebugLogU;
{
  This unit provides a simple debug-log.

  To switch logging on, create a C:\EXCHLOGS file (note that there is no
  extension). Optionally this can contain (in INI file format) an entry
  specifying a path to save the log-file to:

    [SETTINGS]
    LOGFILE = C:\TEMP\LOGFILE.TXT

  If this entry is absent, the log will be saved to C:\BTRVSQLDUAL.LOG.

  The Log(Msg) function adds Msg to the log, if logging is active.
}
interface

uses SysUtils, Classes, Inifiles, Windows, SyncObjs;

procedure Log(Msg: string);
function BtrOpDesc(Op: Integer): string;

implementation

var
  Msgs: TStringList;
  UseLogging: Boolean;
  LogPath: string;
  Inifile: TInifile;
  LogCallProtector: TCriticalSection;

procedure Log(Msg: string);
var
  Line: string;
begin
  if UseLogging then
  begin
    LogCallProtector.Acquire;
    try
      Line := FormatDateTime('dd/mm/yyyy hh:nn:ss:zzz : ', Now) + Msg;
      Msgs.Add(Line);
      try

        // The Log is saved to file whenever an entry is added. This slows the
        // application down significantly, but ensures that the log entries are
        // not lost in the case that the application terminates without shutting
        // down properly.
        Msgs.SaveToFile(LogPath);

        // The log entry is also sent to the Windows debug output. This can be
        // viewed using the DebugView application.
        //
        // See: http://www.microsoft.com/technet/sysinternals/Miscellaneous/DebugView.mspx
        OutputDebugString(PChar('BTRVSQLDUAL: ' + Line));

      except
        on E:Exception do
          Msgs.Add(E.message);
      end;
    finally
      LogCallProtector.Release;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function BtrOpDesc(Op: Integer): string;
const
  BtOps : Array[0..40] of string[16] = ('Open', 'Close', 'Insert', 'Update',
                                        'Delete', 'GetEqual', 'GetNext', 'GetPrev',
                                        'GetGreater', 'GetGEq', 'GetLess', 'GetLessEq',
                                        'GetFirst', 'GetLast', 'Create', 'Stat',
                                        'Extend', 'SetDir', 'GetDir', 'BeginTrans',
                                        'EndTrans', 'AbortTrans', 'GetPos', 'GetDirect',
                                        'StepNext', 'Stop', 'Version', 'Unlock',
                                        'Reset', 'SetOwner', 'ClearOwner', 'CreateSuppIdx',
                                        'DropSuppIdx', 'StepFirst', 'StepLast', 'StepPrev',
                                        'GetNextExt', 'GetPrevExt', 'StepNextExt', 'StepPrevExt',
                                        'InsertExt');

  BtLocks : Array[1..4] of string[17] = ('+SingleLockWait', '+SingleLockNoWait',
                                         '+MultiLockWait', '+MultiLockNoWait');

var
  sLock : string;
  iLock : Integer;
begin
  // Only use this if logging is active.
  if UseLogging then
  begin
    LogCallProtector.Acquire;
    try
      if Op > 100 then
      begin
        iLock := Op div 100;
        Op := Op - (iLock * 100);
        sLock := BtLocks[iLock];
      end
      else
      if Op > 50 then
      begin
        Op := Op-50;
        sLock := '+GetKey';
      end
      else
        sLock := '';

      if Op <= 40 then
        Result :=  BtOps[Op] + sLock
      else
        Result := 'Unknown Btrieve Operation: '  + IntToStr(Op);
    finally
      LogCallProtector.Release;
    end;
  end
  else
    Result := IntToStr(Op);
end;

// -----------------------------------------------------------------------------

initialization

  // Check for the existance of the 'flag' file. Activate logging if it is
  // found.
  UseLogging := FileExists('c:\EXCHLOGS');

  Inifile := TInifile.Create('c:\EXCHLOGS');
  try
    // Read the path for the log-file.
    LogPath := Inifile.ReadString('SETTINGS', 'LOGFILE', 'c:\BTRVSQLDUAL.' + ExtractFileName(ParamStr(0)) + '.LOG');
  finally
    Inifile.Free;
  end;
  Msgs := TStringList.Create;

  LogCallProtector := TCriticalSection.Create;

// -----------------------------------------------------------------------------

finalization

  LogCallProtector.Free;
  Msgs.Free;

// -----------------------------------------------------------------------------

end.
