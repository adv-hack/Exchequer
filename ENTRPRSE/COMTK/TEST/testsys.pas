unit TESTSYS;

{ prutherford440 09:55 04/12/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, Windows, SysUtils, TestLog;

const
  resSystem = 0;
  resGDI    = 1;
  resUser   = 2;

type
  TSystemTest = Class
    private
      FPathList : TStringlist;
      FSysFilePath : string;
      FFilesMissing : TStringList;
      FMem : MemoryStatus;
      FRichLog : TRichLog;
      FMixedPaths : Boolean;
      function ToolkitRegistered : Boolean;
      function ExeToolkitRegistered : Boolean;
      function DiskFreeOnToolkitDrive(c : char) : Int64;
      function MemFree : Int64;
      function MemTotal : Int64;
      function WindowsVersionString : String;
      function GetPath : pChar;
      procedure LoadPath;
      function GetFreeSysResources(SysRes: Word): Word;
      //GetFreeSysResources should only be called if WindowsVersion is W95/98
      procedure FillMem;
      function GetFileDetails(const Filename : string) : string;
      function ShowFileDetails(i : integer) : string;
      function FindFirstFile(const s : string) : string;
      function GetPathFromBrackets(const s : string) : string;
    public
      constructor Create;
      destructor Destroy; override;
      procedure GetSysInfo;
      procedure ShowSystemFiles;
      function NetworkDir(const EntDir : string) : string;
      function ToolkitDir : string;
      function ToolkitExeDir : string;
      property RichLog : TRichLog read FRichLog write FRichLog;
      property SysFilePath : string read FSysFilePath write FSysFilePath;
  end;





implementation

uses
  Registry, ApiUtil, Forms, IniFiles, FileCtrl;
{$IFNDEF LTE}
const
  NoOfSysFiles = 11;
  SysFiles : Array[1..NoOfSysFiles] of String = ('ENTTOOLK.DLL',
                                                 'W32MKDE.EXE',
                                                 'WBTRCALL.DLL',
                                                 'W32MKRC.DLL',
                                                 'WBTRTHNK.DLL',
                                                 'WBTRV32.DLL',
                                                 'WBTRVRES.DLL',
                                                 'WDBUEI32.DLL',
                                                 'WDBUMK32.DLL',
                                                 'WDBUUI32.DLL',
                                                 'W32BTICM.DLL'{,
                                                 'W3AIF103.DLL',
                                                 'W3BIF104.DLL',
                                                 'W3MIF106.DLL',
                                                 'W3SCMV7.DLL'});

{$ENDIF}

var
  hInst16, HInst32: THandle;
  SR: Pointer;
  QT_Thunk : FarProc;

//External procs for finding free resources
function LoadLibrary16(LibraryName: PChar): THandle; stdcall; external kernel32 index 35;
procedure FreeLibrary16(HInstance: THandle); stdcall; external kernel32 index 36;
function GetProcAddress16(Hinstance: THandle; ProcName: PChar): Pointer; stdcall; external kernel32 index 37;


constructor TSystemTest.Create;
begin
  inherited Create;
  FPathList := TStringList.Create;
  FFilesMissing := TStringList.Create;
  SysFilePath := '';
  FillMem;
  LoadPath;
end;

destructor TSystemTest.Destroy;
begin
  if Assigned(FPathList) then
    FPathList.Free;

  if Assigned(FFilesMissing) then
    FFilesMissing.Free;

  inherited Destroy;
end;


function TSystemTest.GetFreeSysResources(SysRes: Word): Word;
var
  Thunks: Array[0..$20] of Word;
begin
  HInst32 := LoadLibrary('Kernel32');
  QT_Thunk := GetProcAddress(HInst32, 'QT_Thunk');
  if QT_Thunk <> nil then
  begin
    Thunks[0] := hInst16;
    hInst16 := LoadLibrary16('user.exe');
    if hInst16 >= 32 then
    begin
      FreeLibrary16(hInst16);
      SR := GetProcAddress16(hInst16, 'GetFreeSystemResources');
      if SR = nil then
        Result := 0
      else
      begin
        asm
          push SysRes       // push arguments
          mov edx, SR       // load 16-bit procedure pointer
          call QT_Thunk     // call thunk
          mov Result, ax    // save the result
        end;
      end;
    end
    else
      Result := 0;
  end
  else
    Result := 0;
end;

function TSystemTest.ToolkitRegistered : Boolean;
var
  TR : TRegistry;
begin
  Result := False;
  TR := TRegistry.Create;
  Try
    TR.RootKey := HKEY_LOCAL_MACHINE;
    Result := TR.KeyExists('SOFTWARE\Classes\Enterprise01.Toolkit');
  Finally
    TR.Free;
  End;
end;

function TSystemTest.ToolkitDir : string;
var
  TR : TRegistry;
begin
  Result := '';

  TR := TRegistry.Create;
  Try
    TR.RootKey := HKEY_LOCAL_MACHINE;
    if TR.OpenKeyReadOnly(
      'SOFTWARE\Classes\CLSID\{F9C1BB23-3625-11D4-A992-0050DA3DF9AD}\InprocServer32') then
        Result := ExtractFilePath(TR.ReadString(''))
    else
        Result := '';
  Finally
    Tr.Free;
  End;
end;

function TSystemTest.DiskFreeOnToolkitDrive(c : char) : Int64;
var
  s : string;
  b : byte;
begin
  Result := -1;
  b := Ord(c) - 64;
  Result := DiskFree(b);
end;

function TSystemTest.MemFree : Int64;
begin
  Result := FMem.dwAvailPhys;
end;

function TSystemTest.MemTotal : Int64;
begin
  Result := FMem.dwTotalPhys;
end;

procedure TSystemTest.FillMem;
begin
  FillChar(FMem, SizeOf(FMem), #0);
  FMem.dwLength := SizeOf(FMem);
  GlobalMemoryStatus(FMem);
end;

function TSystemTest.WindowsVersionString : String;
var
  iServicePack : Integer;
begin
  Result := GetWindowsVersionString; //ApiUtil.pas
{  Case GetWindowsVersion(iServicePack) of
    wv95 : Result := '95';
    wv98 : Result := '98';
    wvME : Result := 'ME';
    wvNT3: Result := 'NT3';
    wvNT4: Result := 'NT4';
    wvNT4TerminalServer
         : Result := 'NT4 Terminal Server';
    wv2000
         : Result := '2000';
    wv2000TerminalServer
         : Result := '2000 Terminal Server';
    wvXP : Result := 'XP';
    wvXPTerminalServer
         : Result := 'XP Terminal Server';
    wvNTOther
         : Result := 'Other';
    wv2003Server
         : Result := '2003 Server';
    wv2003TerminalServer
         : Result := '2003 Terminal Server';
    wvVista
         : Result := 'Vista';
    else
      Result := 'Version Unknown';
  end; //Case

  if iServicePack = 0 then
    Result := Format('Windows %s', [Result])
  else
    Result := Format('Windows %s Service Pack %d', [Result, iServicePack]);}
end;

function TSystemTest.GetPath : pChar;
//Caller releases the memory by calling StrDispose
var
  p1 : pchar;
  p2 : Array[0..5] of char;
  res : dword;
begin
  p2 := 'PATH';
  p1 := nil;
  res := GetEnvironmentVariable(p2, p1, 0);

  if Res > 0 then
  begin
    p1 := StrAlloc(Res);
    GetEnvironmentVariable(p2, p1, Res);
  end;
  Result := p1;

end;


procedure TSystemTest.GetSysInfo;
var
  c : char;

  procedure Line;
  begin
    FRichLog.Report(' ');
  end;

begin
  if Assigned(FRichLog) then
  begin
    FRichLog.ReportBoldU('System information');
    //FRichLog.Report(' ');

    if ToolkitRegistered then
      c := ToolkitDir[1]
    else
      c := 'c';

    FRichLog.Report(Format('%23s  %-10s', ['Operating system:',WindowsVersionString]));
    FRichLog.Report(Format('%23s  %-10s', ['Total physical memory:', IntToStr(MemTotal div (1024 * 1024))
                     + 'Mb']));
    FRichLog.Report(Format('%23s  %-10s', ['Free RAM:',IntToStr(MemFree div (1024 * 1024)) + 'Mb']));
    FRichLog.Report(Format('%23s  %-10s', ['Free space on ' + UpperCase(c) + ': drive:',IntToStr(DiskFreeOnToolkitDrive(c)
                                     div (1024 * 1024)) + 'Mb']));

    Line;

    if GetWindowsVersion in wv95Versions then
    begin
      FRichLog.ReportBoldU('Resources free');
      //FRichLog.Report(' ');
      Line;
      FRichLog.Report('System: ' + IntToStr(GetFreeSysResources(resSystem)) + '%', 1);
      FRichLog.Report('GDI: ' + IntToStr(GetFreeSysResources(resGDI)) + '%', 1);
      FRichLog.Report('User: ' + IntToStr(GetFreeSysResources(resUser)) + '%', 1);
      Line;
    end;

    FRichLog.ReportBoldU('COM Toolkit');
    FRichLog.Line;

    if ToolkitRegistered then
    begin
      FRichLog.Report('DLL Toolkit registered');
      FRichLog.Report('DLL Toolkit path: ' + ToolkitDir);
    end
    else
      FRichLog.ReportError('DLL Toolkit not registered!');

    Line;

    if ExeToolkitRegistered then
    begin
      FRichLog.Report('EXE Toolkit registered');
      FRichLog.Report('EXE Toolkit path: ' + ToolkitExeDir);
    end
    else
      FRichLog.ReportError('EXE Toolkit not registered!');

    if Trim(UpperCase(ToolkitDir)) <> Trim(UpperCase(ToolkitExeDir)) then
    begin
      FRichLog.ReportError('DLL COM Toolkit and EXE COM Toolkit are not registered to the same installation.');

      FRichLog.Line;
    end;


    FRichLog.Line;

  end;
end;

function TSystemTest.GetFileDetails(const Filename : string) : string;
var
  FDate : TDateTime;
  F : TFileStream;
  Size : Longint;
  s : string;
begin
  if FileExists(Filename) then
  begin
    FDate := FileDateToDateTime(FileAge(Filename));

    F := TFileStream.Create(Filename, fmOpenRead or fmShareDenyNone);
    Try
     Try
       Size := F.Size;
     Finally
       F.Free;
     End;
    Except
    End;

    Result := Format('%8s   %10s',[IntToStr(Size), DateTimeToStr(FDate)]);
  end
  else
    Result := '';
end;


function TSystemTest.ShowFileDetails(i : integer) : string;
var
  s : string;
  p : pchar;
begin
{$IFNDEF LTE}
  if i = 1 then
    s := ToolkitDir
  else
    s := SysFilePath;

  Result := Format('%-12s',[SysFiles[i]]);
  if FileExists(s + SysFiles[i]) then
  begin
    Result := Result + '  ' + GetFileDetails(s + SysFiles[i]);
    if i = 1 then
      Result := Result + ' ' + '(' + s + ')';
  end
  else
  begin
    s := FindFirstFile(SysFiles[i]);
    if s <> '' then
      Result := Result + '  ' + GetFileDetails(s + SysFiles[i]) + ' ' + '(' + s + ')'
    else
      FFilesMissing.Add(SysFiles[i]);
  end;
{$ELSE}
  Result := '';
{$ENDIF}
end;

procedure TSystemTest.ShowSystemFiles;
const
{$IFDEF LTE}
  ToolkitFilename = 'Enttoolk.exe';
{$ELSE}
  ToolkitFilename = 'Enttoolk.dll';
{$ENDIF}

var
  i, j : integer;
  FileDet, APath : string;

begin
(*  APath := '';
  if not FileExists(ToolkitDir + ToolkitFilename) then
    FRichLog.ReportError('Unable to find ' +  ToolkitFilename + ' in ' + ToolkitDir)
  else
  begin
    FRichlog.Report(ToolkitFilename + ' found in ' + ToolkitDir);
    FRichLog.Line;
  end;

  FRichLog.Line;

  FMixedPaths := False;
  //SysFilePath := ExtractFilePath(ParamStr(0));

{$IFNDEF LTE}
  FRichLog.ReportBoldU('System files');
  FRichLog.Report('(In ' + SysFilePath + ')', 1);
  FRichLog.Line;
  FRichLog.ReportBold(Format('File          %8s   %10s',['Size','Date']));
  for i := 1 to NoOfSysFiles do
  begin
    FileDet := ShowFileDetails(i);
    FRichLog.Report(FileDet);
    if (i = 2) then
    begin
      if (Pos('(', FileDet) > 0) and (APath = '') then
        APath := GetPathFromBrackets(FileDet)
      else
        APath := SysFilePath;
    end;

    if (i > 2) then
    begin
      if (Pos('(', FileDet) > 0) then
      begin
        if GetPathFromBrackets(FileDet) <> APath then
          FMixedPaths := True;
      end
      else
      if APath <> SysFilePath then
        FMixedPaths := True;
    end;
  end;

  FRichLog.Line;

  if FFilesMissing.Count > 0 then
  with FRichLog do
  begin
    ReportError('Unable to find the following files:');
    for i := 0 to FFilesMissing.Count - 1 do
      ReportError(FFilesMissing[i]);
    Line;
  end;

  if FMixedPaths then
  begin
    FRichLog.ReportError('Not all system files are in the same folder.');
    FRichLog.Line;
  end;
{$ENDIF}
  *)
end;

procedure TSystemTest.LoadPath;
var
  i, j : integer;
  p : pchar;
  s : string;
begin
  p := GetPath;
  s := String(p);
  i := 1;
  Repeat
    j := i;
    while (i < Length(s)) and (s[i] <> ';') do
    begin
      inc(i);
      Application.ProcessMessages;
    end;

    if (i <= Length(s)) then
    begin
      if s[i] = ';' then
        FPathList.Add(IncludeTrailingBackSlash(Copy(s, j, i - j)))
      else
        FPathList.Add(IncludeTrailingBackSlash(Copy(s, j, i - j + 1)));
    end
    else
      FPathList.Add(IncludeTrailingBackSlash(Copy(s, j, Length(s))));

    inc(i);
  Until i > Length(s);
  //StrDispose(p);
end;

function TSystemTest.FindFirstFile(const s : string) : string;
var
  i : integer;
begin
  Result := '';
  for i := 0 to FPathList.Count - 1 do
  begin
    if FileExists(FPathList[i] + s) then
    begin
      Result := FPathList[i];
      Break;
    end;
  end;
end;

function TSystemTest.GetPathFromBrackets(const s : string) : string;
var
  i : integer;
  j : integer;
begin
  i := Pos('(', s);
  j := Pos(')', s);
  if (i > 0) and (j > 0) and (j > i) then
    Result := IncludeTrailingBackSlash(Copy(s, i + 1, j - i - 1))
  else
    Result := '';
end;

function TSystemTest.NetworkDir(const EntDir : string) : string;
var
  WSNetDir : string;
begin
  If FileExists(Entdir + 'EntWRepl.Ini') Then
  Begin
    // Check Replication Path is valid
    With TIniFile.Create (EntDir + 'ENTWREPL.INI') Do
      Try
        WSNetDir := ReadString ('UpdateEngine', 'NetworkDir', '');
        If (Length(WSNetDir) > 0) Then
        Begin
          WSNetDir := IncludeTrailingBackslash (WSNetDir);

          { Check the path is valid }
          If DirectoryExists (WSNetDir) And FileExists (WSNetDir + 'COMPANY.DAT') and
                        FileExists(WSNetDir + 'Enter1.exe') Then
            // Path in entWRepl.Ini is AOK
            Result := WSNetDir
          Else
            // Path in EntWRepl.Ini is invalid
            Result := (WSNetDir + ' - Invalid Exchequer Path! ');
        End { If (Length(WSNetDir) > 0) }
        Else
          // No path defined - path is already correct
          Result := EntDir;
      Finally
        Free;
      End;
  End { If }
  else
    Result := 'File not found: ' + EntDir + 'EntWRepl.Ini';
end;





function TSystemTest.ExeToolkitRegistered: Boolean;
var
  TR : TRegistry;
begin
  Result := False;
  TR := TRegistry.Create;
  Try
    TR.RootKey := HKEY_LOCAL_MACHINE;
    Result := TR.KeyExists('SOFTWARE\Classes\Enterprise04.Toolkit');
  Finally
    TR.Free;
  End;
end;

function TSystemTest.ToolkitExeDir: string;
var
  TR : TRegistry;
begin
  Result := '';

  TR := TRegistry.Create;
  Try
    TR.RootKey := HKEY_LOCAL_MACHINE;
    if TR.OpenKeyReadOnly(
      'SOFTWARE\Classes\CLSID\{3CB675B7-B3B8-4909-BA38-CE270255A112}\LocalServer32') then //Default value so don't need to specify
        Result := ExtractFilePath(TR.ReadString(''))
      else
        Result := '';
  Finally
    Tr.Free;
  End;
end;

end.
