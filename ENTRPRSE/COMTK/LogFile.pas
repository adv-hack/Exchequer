unit LogFile;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows;

Type
  TLoggingFile = Class(TObject)
  Private
    FLogFile     : TextFile;
    FLogFileName : ANSIString;
  Protected
  Public
    Constructor Create;

    Procedure AddLogMessage (Const IntfName, Operation : ShortString;
                             Const Data                : ShortString = '');
  end; { TLoggingFile }


Var
  LogF      : TLoggingFile;
  LoggingOn : Boolean;


implementation

//PR 13/7/04 - Turn off logging as one user was getting an io error 32 with it.
{..$DEFINE LOG_ON}

Uses FileUtil;

var
  lpCriticalSection : TRTLCriticalSection;

//------------------------------------------------------------------

Constructor TLoggingFile.Create;
Var
  LogPath : ANSIString;
  WinDir : PChar;
  RetVal : LongInt;
Begin { Create }
  Inherited Create;

  {$IFDEF LOG_ON}
    WinDir := StrAlloc(255);   

{    RetVal := GetWindowsDirectory (WinDir, StrBufSize(WinDir));
    If (RetVal > 0) Then
      FLogFileName := IncludeTrailingBackSlash (WinDir) + 'COMTK.LOG'
    Else
      FLogFileName := ExtractFileName(Application.ExeName) + 'COMTK.LOG';}

    FLogFileName := GetEnterpriseDirectory + 'Logs\COMTK.LOG';

    AssignFile (FLogFile, FLogFileName);
    if FileExists(FLogFileName) then
      Append(FLogFile)
    else
    begin
      Rewrite (FLogFile);

      Writeln (FLogFile, '');
      Writeln (FLogFile, ' TimeStamp         | Interface                        | Operation         | Data');
      Writeln (FLogFile, '-------------------+----------------------------------+-------------------+----------------------------------------------------');
    end;
    CloseFile (FLogFile);
  {$ENDIF}
End; { Create }

//------------------------------------------------------------------

// Add a message into the Log
Procedure TLoggingFile.AddLogMessage (Const IntfName, Operation : ShortString;
                                      Const Data                : ShortString = '');
var
  OutStr            : ANSIString;
  Success           : Boolean;
  Function UpdMemStat : ShortString;
  var
    MemStat : MemoryStatus;
  Begin
    MemStat.dwLength := SizeOf(MemStat);
    GlobalMemoryStatus(MemStat);
    Result := IntToStr((MemStat.dwAvailPhys + MemStat.dwAvailPageFile) div 1024) + '/' +
              IntToStr(MemStat.dwMemoryLoad) + '%';
  End;

Begin { AddLogMessage }
  {$IFDEF LOG_ON}
    If LoggingOn Then Begin
      EnterCriticalSection(lpCriticalSection);
      try
        // TimeStamp
        OutStr := Copy (FormatDateTime (' HH:MM.ss DD/MM/YY ', Now) + StringOfChar(' ', 19), 1, 19) + '  ' +

        // Interface
                  Copy (ExtractFileName(Application.ExeName) + '.' + IntfName + StringOfChar(' ', 32), 1, 32) + '   ' +

        // Operation
                  Copy (Operation + StringOfChar(' ', 17), 1, 17) + '   ' +

        // Data
                  Data;

        If (Trim(Data) = '') Then OutStr := OutStr + UpdMemStat;

        Success := False;
        while not Success do
        Try
          AddLineToFileNoMessage(OutStr, FLogFileName);
          Success := True;
        Except
          on E: Exception do
          begin
            OutStr[1] := '*';
          end;
        End;

      except
        on E:Exception do {showmessage('Neil''s IO Error : ' + E.ClassName + ' / ' + E.Message)};
      end;
      LeaveCriticalSection(lpCriticalSection);
    End; { If LoggingOn }
  {$ENDIF}
End; { AddLogMessage }

//------------------------------------------------------------------


Initialization
  {$IFDEF LOG_ON}
    LoggingOn := True;

    InitializeCriticalSection(lpCriticalSection);
  {$ELSE}
    LoggingOn := False;
  {$ENDIF}
  LogF := TLoggingFile.Create;
Finalization
  FreeAndNil (LogF);
  {$IFDEF LOG_ON}
    DeleteCriticalSection(lpCriticalSection);
  {$ENDIF}
end.
