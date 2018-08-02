unit debuglog;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, Sentu, ElVar;

const
  LogExt = '.log';
  FlagExt = '.flg';

  ConvLogName = 'Convey';
  QueryLogName = 'Query';
  PollLogName = 'Poll';

  MaxLogFileSize = 40000;




  procedure LogIt(Where : TSentinelPurpose; s : ShortString; StandardDebug : Boolean = False);
  procedure LogError(Where : TSentinelPurpose;
                     const UID, ELName, ExtraInfo : ShortString;
                     Error : SmallInt);
  procedure LogMessage(Where : TSentinelPurpose;
                       const UID, ELName, ExtraInfo : ShortString);

  function MemFreeString : string;
  function LogInPrint : string;
  function QOK : String;

var
  LogDir : AnsiString;
  WantDebug : Boolean;

implementation

uses
   Windows, SysUtils, Forms, ApiUtil, GlobIni, GlobVar;


const
  CrLF = #13#10;
var
  Log : TStringList;

function QOK : String;
begin
  if GetQuery_OkToClose then
   Result := ' Q : True'
  else
    Result := ' Q : False';
end;

function LogInPrint : string;
begin
  if InPrint then
    Result := ': Inprint = True;' + QOK
  else
    Result := ': Inprint = False;' + QOK;
end;

function FileNo(Which : TSentinelPurpose) : ShortString;
var
 i : SmallInt;
begin
  i := 0;
  with TSentIniObject.Create(GlobalIniFileName) do
  begin
   Try
    Case Which of
      spQuery,
      spReport    : i := QueryLogCount;
      spConveyor,
      spReportConveyor,
      spCSVConveyor,
      spVisualReportConveyor : i := ConvLogCount;
      spSystem,
      spPoller   : i := PollLogCount;
    end;
   Finally
    Result := IntToStr(i);
    Free;
   End;
  end;
end;

function LogName(Which : TSentinelPurpose) : ShortString;
begin
  Case Which of
    spQuery,
    spReport    : Result := QueryLogName;
    spConveyor,
    spReportConveyor,
    spCSVConveyor,
    spVisualReportConveyor : Result := ConvLogName;
    spPoller,
    spSystem   : Result := PollLogName;
    else
      Result := '';
  end;
  Result := LogDir + Result + FileNo(Which) + LogExt;
end;

function NewFileNo(Which : TSentinelPurpose) : ShortString;
var
 i : SmallInt;
 s : string;
begin
  i := 0;
  with TSentIniObject.Create(GlobalIniFileName) do
  begin
   Try
    Case Which of
      spQuery,
      spReport    : i := QueryLogCount;
      spConveyor,
      spReportConveyor,
      spCSVConveyor,
      spVisualReportConveyor     : i := ConvLogCount;
      spSystem,
      spPoller          : i := PollLogCount;
    end;
    inc(i);
    if i > 99 then
      i := 0;

    Case Which of
      spQuery,
      spReport           : QueryLogCount := i;
      spConveyor,
      spReportConveyor,
      spCSVConveyor,
      spVisualReportConveyor
                        : ConvLogCount := i;
      spSystem,
      spPoller          : PollLogCount := i;
    end;

    s := LogName(Which);
    if FileExists(s) then
      DeleteFile(s);

   Finally
    Result := IntToStr(i);
    Free;
   End;
  end;
end;



function FlagName(Which : TSentinelPurpose) : ShortString;
begin
  Case Which of
    spQuery,
    spReport    : Result := QueryLogName;
    spConveyor,
      spReportConveyor,
      spCSVConveyor,
      spVisualReportConveyor
                : Result := ConvLogName;
    spSystem,
    spPoller    : Result := PollLogName;
    else
      Result := '';
  end;
  Result := LogDir + Result + FileNo(Which) + FlagExt;
end;


procedure LogIt(Where : TSentinelPurpose; s : ShortString; StandardDebug : Boolean = False);
var
  Start : Cardinal;
  F : TextFile;
  F1 : File;
  s1, s2 : ShortString;
  FSize : longint;
  LogFileName, FlagFileName : ShortString;

begin
  if WantDebug or StandardDebug then
  begin
    if Where = spReport then
      s := s + LogInprint;

  //  s1 := '(' + WinGetComputerName + ')' + DateTimeToStr(Now) + '>' + s + #13 + #10;
    s1 := '(' + WinGetComputerName + ')' + FormatDateTime('dd/mm/yyyy hh:nn:ss:zzz', Now) + '>' + s + #13 + #10;
    if Length(s1) > 253 then
      s1 := Copy(s1, 1, 253) + #13 + #10; //just to make sure we have a crlf
  {$IFDEF Debug}
    s2 := MemFreeString;
  {$ENDIF}
      FlagFileName := FlagName(where);
      LogFileName := LogName(where);
      AssignFile(F, FlagFileName);
      AssignFile(F1, LogFileName);
      Start := GetTickCount;
      while FileExists(FlagFileName) and (GetTickCount < Start + 1000) do
        SleepEx(2, True);

      if not FileExists(FlagFileName) then
      begin
        {$I-}
        Rewrite(F);
        if IOResult = 0 then
        begin
          if FileExists(LogFileName) then
            Reset(F1, 1)
          else
            Rewrite(F1, 1);
          FSize := FileSize(F1);
          Seek(F1, FSize);
          BlockWrite(F1, s1[1], Length(s1));
      {$IFDEF Debug}
          BlockWrite(F1, s2[1], Length(s2));
          BlockWrite(F1, CrLF, 2);
      {$ENDIF}
          CloseFile(F1);
          CloseFile(F);

          DeleteFile(FlagFileName);
          Start := GetTickCount;
          while (IOResult <> 0) and (GetTickCount < Start + 1000) do
          begin
            SleepEx(2, True);
            DeleteFile(FlagFileName);
          end;
          {$I+}
          if FSize > MaxLogFileSize then
            NewFileNo(Where);
        end;
      end;
  end;
end;

function MyQuotedStr(const s : shortstring) : ShortString;
begin
  if s <> '' then
    Result := QuotedStr(s)
  else
    Result := s;
end;


procedure LogError(Where : TSentinelPurpose;
                     const UID, ELName, ExtraInfo : ShortString;
                     Error : SmallInt);
begin
//  LogFileName := LogName(Where);
  LogIt(Where, 'Error in ' +
         Trim(UID) + '; ' + MyQuotedStr(Trim(ELName)) +
         ' (' + ExtraInfo + ') ' + 'Error: ' + IntToStr(Error), True);
end;

procedure LogMessage(Where : TSentinelPurpose;
                     const UID, ELName, ExtraInfo : ShortString);
begin
//  LogFileName := LogName(Where);
//  FlagFileName := FlagName(Where);
  LogIt(Where, Trim(UID) + '; ' + MyQuotedStr(Trim(ELName)) + ' ' + ExtraInfo, True);
end;

function MemFreeString : String;
var
  M : MemoryStatus;
  V : Double;
begin
  FillChar(M, SizeOF(M), #0);
  M.dwLength := SizeOf(M);
  GlobalMemoryStatus(M);
  V := (M.dwAvailVirtual div 1024);
  Result := Format('Available virtual memory: %9.0nkb', [V]);
end;

end.
