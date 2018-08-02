unit LogUtil;

interface

Uses Classes, Forms, SysUtils, Windows;

Type
  TLogFile = Class(TStringList)
  Private
    FSavedName : ShortString;
  Public
    Property SavedName : ShortString Read FSavedName;

    Constructor Create (Const AppDesc : ShortString);
    Procedure SaveLog;
  End; // TLogFile

Var
  // Directory LOG files will be put in - defaults to \Logs off .EXE dir
  LogDir : ShortString;

//PR: 31/08/2016 ABSEXCH-16704 Debug function
procedure OutputDebug(const Msg : AnsiString);

implementation

Uses APIUtil, Dialogs, IniFiles, EntLogIniClass, VAOUtil;

//PR: 31/08/2016 ABSEXCH-16704 New class to log using OutputDebugString
type
  TOutputLog = Class
  private
    FEnabled : Boolean;
    FDesc : string;
  public
    constructor Create;
    procedure WriteOutput(const Msg : AnsiString);
  end;

Var
  // Random number in range 1-999 used to group log files for a session together
  iUser : SmallInt;

  //PR: 31/08/2016 ABSEXCH-16704 Instance of TOutputLog
  OutputLog : TOutputLog;

//PR: 31/08/2016 ABSEXCH-16704 Debug function
procedure OutputDebug(const Msg : AnsiString);
begin
  //Create on the first call
  if not Assigned(OutputLog) then
    OutputLog := TOutputLog.Create;

  if Assigned(OutputLog) then
    OutputLog.WriteOutput(Msg);
end;

//=========================================================================

// Internal function to return a log file name, creates the LOGS directory if missing
Function GetNewLogName : ShortString;
Var
  sFileName : ShortString;
  iFile     : SmallInt;
Begin // GetNewLogName
  // Check the Logs directory exists
  Result := LogDir;
  If (Not DirectoryExists(Result)) Then
  Begin
    ForceDirectories (Result);
  End; // If (Not DirectoryExists(Result))

  // Generate a unique filename within the directory using Enterprise conventions
  iFile := 1;
  Repeat
    sFileName := 'E' + IntToStr(iUser) + IntToStr(iFile) + '.Log';
    Inc(iFile);
  Until (Not FileExists(Result + sFileName)) Or (iFile > 9999);

  Result := Result + sFileName;
End; // GetNewLogName

//=========================================================================

// AppDesc - Description of Log Source e.g. 'COM Toolkit TKCOM-570.284'
Constructor TLogFile.Create (Const AppDesc : ShortString);
Var
  Buffer : array[0..254] of Char;
  ModuleName : ShortString;
  Len    : SmallInt;
Begin // Create
  Inherited Create;

  FSavedName := '';

  Add (AppDesc);
  If IsLibrary Then
  Begin
    // Get DLL Name for log
    ModuleName := '';
    Len := GetModuleFileName(HInstance, Buffer, SizeOf(Buffer));
    If (Len > 0) Then ModuleName := ExtractFilePath(Buffer) + ExtractFileName(Buffer);
    Add (Application.ExeName + '/' + ModuleName);
  End // If IsLibrary
  Else
    Add (Application.ExeName);
  Add (FormatDateTime ('DD/MM/YY - HH:MM:SS', Now) +
                 '    Computer: ' +  WinGetComputerName +
                 '    User: ' +  WinGetUserName);
  Add ('---------------------------------------------------------------');
End; // Create

//-------------------------------------------------------------------------

Procedure TLogFile.SaveLog;
Var
  sLogName : ShortString;
  iSave    : SmallInt;
Begin // SaveLog
  // Identify Filename and save - give it a few goes to ensure a unique filename
  For iSave := 1 To 5 Do
  Begin
    sLogName := GetNewLogName;
    If (Not FileExists(sLogName)) Then
    Begin
      FSavedName := sLogName;
      SaveToFile (sLogName);
      Break;
    End // If (Not FileExists(LogName))
    Else
      Sleep(50);
  End; // For iSave
End; // SaveLog

//=========================================================================

{ TOutputLog }

constructor TOutputLog.Create;
var
  sPrefix : string;
begin
  inherited Create;

  //Check whether to enable. Ini file should be in the Exchequer MCM folder
  with TIniFile.Create(VAOInfo.vaoCompanyDir + EntLogIniClass.S_INI_FILE_NAME) do
  Try
    FEnabled := ReadBool('COMTK', 'Enabled', False);

    if FEnabled then ///Read description to link debug strings
    begin
      FDesc := ReadString('COMTK', 'Desc', 'TKPRINT');
      FDesc := '[' + FDesc + '] ';
    end;
  Finally
    Free;
  End;
end;

procedure TOutputLog.WriteOutput(const Msg: AnsiString);
begin
  if FEnabled then
    OutputDebugString(PChar(FDesc + Msg));
end;

Initialization
  Randomize;
  iUser := Random(998) + 1;  // Generate random Id in range 1-999
  LogDir := ExtractFilePath(Application.ExeName) + 'LOGS\';

  //PR: 31/08/2016 ABSEXCH-16704
  OutputLog := nil;

Finalization
  //PR: 31/08/2016 ABSEXCH-16704
  if Assigned(OutputLog) then
    FreeAndNil(OutputLog);
end.
