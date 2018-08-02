unit EntLogIniClass;
{$WARN SYMBOL_PLATFORM OFF}
interface

uses
  IniFiles, Classes;

const
  S_INI_FILE_NAME = 'entlog.ini';

type
  TLoggingLevel = (llNone, llError, llInfo);

  TEntLogIniFile = Class
  private
    FIni : TMemIniFile;
    FLogFileName : string;
    function GetLevel(const Index : string) : TLoggingLevel;
  public
    constructor Create(APath : string);
    destructor Destroy; override;
    property LogfileName : string read FLogFileName;
    property Level[const Index : string] : TLoggingLevel read GetLevel;
  end;

  procedure CreateLoggingIniFile(APath : string);
  procedure DestroyLoggingIniFile;
  function LoggingIniFile : TEntLogIniFile;

implementation

uses
  FileUtil, SysUtils;

var
  EntLogIniFile : TEntLogIniFile;

procedure CreateLoggingIniFile(APath : string);
begin
  if not Assigned(EntLogIniFile) then
    EntLogIniFile := TEntLogIniFile.Create(APath);
end;

//PR: 02/09/2011 - Added destroy procedure so IniFile gets reloaded from correct dir after change company.
procedure DestroyLoggingIniFile;
begin
  if Assigned(EntLogIniFile) then
  begin
    EntLogIniFile.Free;
    EntLogIniFile := nil;
  end;
end;

function LoggingIniFile : TEntLogIniFile;
begin
  Result := EntLogIniFile;
end;

{ TEntLogIniFile }

constructor TEntLogIniFile.Create(APath : string);
begin
  inherited Create;

  //If no path specified, then use root company
  if Trim(APath) = '' then
    APath := GetEnterpriseDirectory;

  APath := IncludeTrailingBackslash(APath);

  //Load the ini file into memory - if no ini file for the company data set then use the root company ini file.
  if FileExists(APath + S_INI_FILE_NAME) then
    FIni := TMemIniFile.Create(APath + S_INI_FILE_NAME)
  else
    FIni := TMemIniFile.Create(GetEnterpriseDirectory + S_INI_FILE_NAME);

  //Extract log file name
  FLogFileName := APath + 'Logs\' + FIni.ReadString('GLOBAL', 'LogFileName', 'Enterprise.Log');
end;

destructor TEntLogIniFile.Destroy;
begin
  FIni.Free;
  inherited;
end;

function TEntLogIniFile.GetLevel(const Index: string): TLoggingLevel;
var
  LogLevel : Integer;
begin
  //Return the level for the required area. If the area isn't found, try Default. If that's not found, return llNone.
  LogLevel := FIni.ReadInteger('AREAS', Index, -1);
  if LogLevel = -1 then //This area not found - try default
    LogLevel := FIni.ReadInteger('AREAS', 'Default', 0);
  if (LogLevel < Ord(llNone)) or (LogLevel > Ord(llInfo)) then
    LogLevel := 0;
  Result := TLoggingLevel(LogLevel);
end;

Initialization
  EntLogIniFile := nil;
end.
