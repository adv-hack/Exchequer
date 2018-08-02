unit FaxUtils;

{ nfrewer440 10:20 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$IFNDEF VER130}
  {$ALIGN 1}  { Variable Alignment Disabled }
{$ENDIF}

interface

uses
  VarConst, Classes, Forms, IniFiles, APIUtil{, OoMisc};

const

  DEFAULT_USER = 'DEFAULT_USER';
  SENDER_NAME = 'SenderName';
  SENDER_EMAIL = 'SenderEmail';

  CRLF = #13#10;
  TAB = #9;
  APF_EXT = '.TIF';
  OLD_APF_EXT = '.APF';
  FIND_EXT = '.??F'; //Show both TIF & APF files in browser
  KILO = 1024;
  MEGA = KILO * KILO;
  MILLI_SECS = 1000;
  SECS_PER_MIN = 60;

type
  TFaxDirs = array[TKnownFaxStatus] of string;
  TIniReadWrite = (iniRead,iniWrite);

function LastSubDir(const DirName : string) : string;
function LeftPadStr(Str : string; Len : byte; ch : char) : string;
function RightPadStr(Str : string; Len : byte; ch : char) : string;
function SpacePad(Str : string; Len : byte) : string;
function PriorityCharToEnum(Priority : char) : TKnownFaxStatus;
function PriorityEnumToDesc(Priority : TKnownFaxStatus) : string;
function SetFaxDirectories(var FaxDirs : TFaxDirs; sFaxServerRoot : string) : boolean;
function GetDirFileCount(DirName : string) : integer;
function GetDirSize(DirName : string) : integer;
function InTimePeriod(StartTime, EndTime : TDateTime) : boolean;
function LastSubStringPos(SubStr, Str : string) : integer;

procedure SetBtrieveLocation;
procedure ShowBtrieveError(Msg : string; Status : integer);
procedure Delay(DelayTime : word; App : TApplication);
function SetIniFileName(var IniFileName : string) : boolean;
procedure UserDefaults(FaxFrom, SenderEmail : PChar; IniReadWrite : TIniReadWrite);
//procedure SetPipename;

function Fax_Version : string;

implementation

uses
  UFaxBtrv, BtrvU2, Dialogs, SysUtils, GlobVar, ExchequerRelease;

type
  TDirParse = (dirTotalSize, dirFileNum);

const
  BuildNo = '014';

function Fax_Version : string;
begin
  Result := 'Version: ' + ExchequerModuleVersion(emFax, BuildNo);
end;

//-----------------------------------------------------------------------

function LastSubDir(const DirName : string) : string;
// Pre  : DirName = Path only (no filename)
// Post : Returns the lowest level sub-directory
var
  Found : boolean;
  Posn : integer;
begin
  Found := false;
  Posn := length(DirName);
  while (Posn > 0) and not Found do begin
    Found := DirName[Posn] = '\';
    if not Found then dec(Posn);
  end;

  Result := copy(DirName,Posn+1,length(DirName)-Posn);
end; // LastSubDir

//-----------------------------------------------------------------------

function LeftPadStr(Str : string; Len : byte; ch : char) : string;
// Pre  : Str = string to process
//        Len = total length of new string
//        ch  = character to pad with
// Post : Str is left padded to length, Len with characters, ch if possible
var
  PadLength : byte;
begin
  if Len < length(Str) then
  begin
    Result := Str;
    exit;
  end
  else
  begin
    PadLength := Len - Length(Str);
    SetLength(Result, PadLength);
    FillChar(Result[1],PadLength,ch);
    Result := Result + Str;
  end;
end; // LeftPadStr

//-----------------------------------------------------------------------

function RightPadStr(Str : string; Len : byte; ch : char) : string;
// Pre  : Str = string to right pad with spaces
//        Len = total length of space padded string
//        ch  = character to pad with
// Post : Str is right padded to length, Len with characters, ch if possible
begin
  if Len <= Length(Str) then
  begin
    Result := Str;
    exit;
  end
  else
  begin
    SetLength(Result,Len);
    FillChar(Result[1],Len,ch);
    Result := Str + copy(Result,1,Len-Length(Str));
  end;
end; // RightPadStr

//-----------------------------------------------------------------------

function SpacePad(Str : string; Len : byte) : string;
// Pre  : Str = string to right pad with spaces
//        Len = total length of space padded string
// Post : Str will be maximum length, Len and if neccessary right padded with spaces
begin
  Result := copy(RightPadStr(Str,Len,' '),1,Len);
end;

//-----------------------------------------------------------------------

function PriorityCharToEnum(Priority : char) : TKnownFaxStatus;
// Pre  : Priority as a letter
// Post : Equivalent priority as an enumerated type
begin
  case Upcase(Priority) of
    'N' : Result := fxsNormal;
    'U' : Result := fxsUrgent;
    'O' : Result := fxsOffPeak;
    'A' : Result := fxsArchive;
  else
    Result := fxsFail;
  end; // case
end; // PriorityCharToEnum

//-----------------------------------------------------------------------

function PriorityEnumToDesc(Priority : TKnownFaxStatus) : string;
// Pre  : Priority as an enumerated type
// Post : Equivalent priority as descriptive string
begin
  case Priority of
    fxsNormal  : Result := 'normal';
    fxsUrgent  : Result := 'urgent';
    fxsOffPeak : Result := 'off peak';
    fxsArchive : Result := 'atchived';
    fxsFail    : Result := 'failed';
  else
    Result := 'unknown';
  end; // case
end; // PriorityEnumToDesc

//-----------------------------------------------------------------------

function SetFaxDirectories(var FaxDirs : TFaxDirs; sFaxServerRoot : string) : boolean;
// Pre : Fax Btrieve file assumed to be open
begin
  FaxDirs[fxsUrgent] := sFaxServerRoot + 'Urgent';
  FaxDirs[fxsNormal] := sFaxServerRoot + 'Normal';
  FaxDirs[fxsOffPeak] := sFaxServerRoot + 'OffPeak';
  FaxDirs[fxsArchive] := sFaxServerRoot + 'Archived';
  FaxDirs[fxsFail] := sFaxServerRoot + 'Failed';
end; // SetFaxDirectories

//-----------------------------------------------------------------------

procedure ShowBtrieveError(Msg : string; Status : integer);
// Notes : Show message with Btrieve error information
begin
  MessageDlg(Msg + CRLF + 'Error Code: ' + IntToStr(Status) + CRLF +
    Set_StatMes(Status), mtWarning, [mbOK], 0);
end;

//-----------------------------------------------------------------------

function ParseDirectory(DirName : string; DirParse : TDirParse) : integer;
// Pre    : DirName = Drive and path of directory
// Action : DirParse = dirTotalSize returns size of directory
//          DirParse = dirFileNum returns number of files in directory
var
  SearchRec : TSearchRec;
  Count : longint;
  FileFound : boolean;
begin
  Count := 0;
  FileFound := FindFirst(IncludeTrailingBackslash(DirName) + '*.*', faAnyFile, SearchRec) = 0;
  while FileFound do
  begin
    if DirParse = dirTotalSize then
      inc(Count, SearchRec.Size)
    else
      inc(Count, 1);
    FileFound := FindNext(SearchRec) = 0;
  end;
  FindClose(SearchRec);
  Result := Count;
end; // ParseDirectory

//-----------------------------------------------------------------------

function GetDirFileCount(DirName : string) : integer;
// Pre  : DirName = Drive and path of directory
// Post : Returns number of files in directory
begin
  Result := ParseDirectory(DirName, dirFileNum);
end;

//-----------------------------------------------------------------------

function GetDirSize(DirName : string) : integer;
// Pre  : DirName = Drive and path of directory
// Post : Returns size of directory
begin
  Result := ParseDirectory(DirName, dirTotalSize);
end;

//-----------------------------------------------------------------------

function InTimePeriod(StartTime, EndTime : TDateTime) : boolean;
// Post : Returns true if the current time is within the defined time period
var
  CurTime : TDateTime;
begin
  CurTime := Time;
  if StartTime <= EndTime then
     Result := (CurTime >= StartTime) and (CurTime <= EndTime) // Period during day
  else
    Result := (CurTime >= StartTime) or (CurTime <= EndTime); // Period spans midnight
end; // InTimePeriod

//-----------------------------------------------------------------------

procedure SetBtrieveLocation;
// Action : SetDrive global (determines Btrieve file location) is set to either
//          the application's directory or to that specified by subsequent
//          command line parameter to '/DIR:'.
var
  ParamNo : byte;
  BtrieveDir : string;
begin
  // ParamStr[0] = Application name and location
  ParamNo := 1;
  BtrieveDir := '';
  while (BtrieveDir = '') and (ParamNo < ParamCount) do begin
    if UpperCase(ParamStr(ParamNo)) = '/DIR:' then BtrieveDir := ParamStr(ParamNo+1);
    inc(ParamNo);{NF : Cheers for leaving this out Jim :) }
  end;{while}

  if BtrieveDir = '' then SetDrive := IncludeTrailingBackslash(ExtractFileDir(Paramstr(0)))
  else SetDrive := IncludeTrailingBackslash(BtrieveDir);
end; // SetBtrieveLocation

//-----------------------------------------------------------------------

function LastSubStringPos(SubStr, Str : string) : integer;
// Pre  : SubStr = Sub string to search for
//        Str = String to search through
// Post : Returns the position of the last occurrence of Substr in Str.
//        If not found returns 0.
var
  CurPosn : integer;
  Finished : boolean;
begin
  CurPosn := Pos(Substr,Str);
  Finished := CurPosn <> 0;
  while not Finished do
  begin
    Delete(Str,1,CurPosn+length(SubStr)-1);
    if Pos(SubStr,Str) > 0 then
      CurPosn := Pos(SubStr,Str)
    else
      Finished := true;
  end;
  Result := CurPosn;
end;

//-----------------------------------------------------------------------

procedure Delay(DelayTime : word; App : TApplication);
// Pre : Delay time in millisecs
const
  MILLISEC_ADJ = 1 / (24 * 60 * 60 * 1000);
var
  ElapsedTime,
  OriginalTime : TDateTime;
  Delay : double;
begin
  OriginalTime := Now;
  Delay := DelayTime / MILLISEC_ADJ;

  repeat
    ElapsedTime := Now - OriginalTime;
    App.ProcessMessages;
  until (ElapsedTime > Delay);
end;

//-----------------------------------------------------------------------

function SetIniFileName(var IniFileName : string) : boolean;
const
  INI_FILE_NAME = 'EntFxUsr.ini';
var
  IniFileHandle : Text;
begin
  Result := true;

{  IniFileName := ExtractFilePath(ParamStr(0)) + INI_FILE_NAME;}
  IniFileName := SetDrive + INI_FILE_NAME; {NF : modified to use command line parameter DIR}

  if not FileExists(IniFileName) then
  begin
    AssignFile(IniFileHandle,IniFileName);
    try
      System.Rewrite(IniFileHandle);
      CloseFile(IniFileHandle);
    except
      Result := false;
    end;
  end;
end; // SetIniFileName

procedure UserDefaults(FaxFrom, SenderEmail : PChar; IniReadWrite : TIniReadWrite);
const
  MAX_USER_NAME = 100;
var
  UserName : string;
  IniFileName : string;
begin
  if SetIniFileName(IniFileName) then
    with TIniFile.Create(IniFileName) do
    try
      UserName := WinGetUserName;
      if IniReadWrite = iniRead then
        begin
          StrPCopy(FaxFrom, copy(ReadString(UserName, SENDER_NAME, ''), 1, 80));
          StrPCopy(SenderEmail, copy(ReadString(UserName, SENDER_EMAIL, ''), 1, 100));
        end
      else begin
        WriteString(UserName, SENDER_NAME, FaxFrom);
        WriteString(UserName, SENDER_EMAIL, SenderEmail);
      end;{if}
    finally
      Free;
    end;
end; // FindUserDefaults

end.
