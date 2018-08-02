unit SysHalc;
{-----------------------------------------------------------------------------
                          OS Unique Code

       SysHalc Copyright 2000 (c) Griffin Solutions, Inc.

       20 July 2000

          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl                    web: www.grifsolu.com
          Warner Robins, GA  31088

      -------------------------------------------------------------
      This unit handles operating system-specific calls to allow changing
      between Windows, Linux, and any other environment that Borland creates
      a Delphi compiler. Most translations occur in SysUtils.  This unit is
      any other necessary commands.

      Changes:

------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   {$IFDEF WIN32}
   Windows,
   {$ENDIF}
   {$IFDEF LINUX}
   Types,
   Libc,
   {$ENDIF}
   SysUtils,
   gs6_glbl;


function gsStrCompare(const Str1, Str2: gsUTFString): integer;
function gsStrCompareI(const Str1, Str2: gsUTFString): integer;
function gsStrPosition(const Pat, Str: gsUTFString): integer;
function gsStrPosWild(const Pat, Str: gsUTFString): integer;
function gsStrLowerCase(const Str: gsUTFString): gsUTFString;
function gsStrUpperCase(const Str: gsUTFString): gsUTFString;

function gsBufCompare(Buf1, Buf2: gsUTFPChar): integer;
function gsBufCompareI(Buf1, Buf2: gsUTFPChar): integer;

procedure gsSysOEMToChar(NativeStr, AnsiStr: PChar; MaxLen: longint);
procedure gsSysCharToOEM(AnsiStr, NativeStr: PChar; MaxLen: longint);

Function gsSysTruncate(Handle: integer; Position: Int64): Integer;

Function gsSysLockFile(Handle: Integer; Position, Length: Int64): Boolean;
Function gsSysUnlockFile(Handle: Integer; Position, Length: Int64): Boolean;
Function gsSysFlushFileBuffers(Handle: Integer): Boolean;
procedure gsSysSleep(MS: integer);
function gsSysRootDirectory: string;

{no Linux Code}


{$IFDEF WIN32}
function gsSysSpawn(const CmdLine: string; Visibility : integer): integer;
function gsSysSpawnAndWait(const CmdLine: string; Visibility : integer): integer;
{$ENDIF}

implementation


function gsStrCompare(const Str1, Str2: gsUTFString): integer;
begin
   Result := AnsiCompareStr(Str1,Str2);
end;

function gsStrCompareI(const Str1, Str2: gsUTFString): integer;
begin
   Result := AnsiCompareText(Str1,Str2);
end;

function gsStrPosition(const Pat, Str: gsUTFString): integer;
begin
   Result := AnsiPos(Pat, Str);
end;

function gsStrPosWild(const Pat, Str: gsUTFString): integer;
var
   s1: gsUTFString;
   s2: gsUTFString;
   i: integer;
   astrbegin: boolean;
   astrend: boolean;
begin
   Result := 0;
   if Length(Pat) = 0 then exit;
   if Length(Pat) > Length(Str) then exit;
   s1 := Pat;
   astrbegin := s1[1] = '*';
   if astrbegin then
   begin
      if (Length(s1) = 1) then
      begin
         Result := 1;
         exit;
      end;
      Delete(s1,1,1);
   end;
   astrend := s1[Length(s1)] = '*';
   if astrend then
   begin
      if (Length(s1) = 1) then
      begin
         Result := 1;
         exit;
      end;
      Delete(s1,Length(s1),1);
   end;
   s2 := Str;
   if not astrbegin then
   begin
      for i := 1 to length(s1) do
      begin
         if s1[i] = '?' then s2[i] := '?';
      end;
   end;
   Result := gsStrPosition(s1,s2);
end;

function gsStrLowerCase(const Str: string): string;
begin
   Result := AnsiLowerCase(Str);
end;

function gsStrUpperCase(const Str: string): string;
begin
   Result := AnsiUpperCase(Str);
end;


function gsBufCompare(Buf1, Buf2: gsUTFPChar): integer;
begin
   Result := AnsiStrComp(Buf1,Buf2);
end;

function gsBufCompareI(Buf1, Buf2: gsUTFPChar): integer;
begin
   Result := AnsiStrIComp(Buf1,Buf2);
end;


procedure gsSysCharToOEM(AnsiStr, NativeStr: PChar; MaxLen: longint);
begin
{$IFDEF WIN32}
   CharToOEMBuff(AnsiStr,NativeStr,MaxLen);
{$ENDIF}
{$IFDEF LINUX}
   if AnsiStr <> NativeStr then StrLCopy(NativeStr,AnsiStr,MaxLen);
{$ENDIF}
end;

procedure gsSysOEMToChar(NativeStr, AnsiStr: PChar; MaxLen: longint);
begin
{$IFDEF WIN32}
   OEMToCharBuff(NativeStr,AnsiStr,MaxLen);
{$ENDIF}
{$IFDEF LINUX}
   if AnsiStr <> NativeStr then StrLCopy(AnsiStr,NativeStr,MaxLen);
{$ENDIF}
end;

Function gsSysFlushFileBuffers(Handle: Integer): Boolean;
begin
{$IFDEF WIN32}
   Result := Windows.FlushFileBuffers(Handle);
{$ENDIF}
{$IFDEF LINUX}
   Result := fsync(Handle) <> -1;
{$ENDIF}
end;


Function gsSysTruncate(Handle: integer; Position: Int64): Integer;
{$IFDEF WIN32}
{$IFNDEF HASINT64}
var
   psn: Integer;
begin
   psn := trunc(Position);
   if FileSeek(Handle, psn, 0) <> -1 then
{$ELSE}
begin
   if FileSeek(Handle, Position, 0) <> -1 then
{$ENDIF}
   begin
      if Windows.SetEndOfFile(Handle) then
         Result := 0
      else
         Result := -1;
   end
   else
      Result := -1;
end;
{$ENDIF}
{$IFDEF LINUX}
begin
    Result := ftruncate(Handle,Position);
end;
{$ENDIF}

Function gsSysUnlockFile(Handle: Integer; Position, Length: Int64): Boolean;
{$IFDEF WIN32}
begin
   Result := Windows.UnLockFile(Handle,Int64Rec(Position).Lo,Int64Rec(Position).Hi,
                                Int64Rec(Length).Lo,Int64Rec(Length).Hi);
end;
{$ENDIF}
{$IFDEF LINUX}
var
   LockVar: TFlock;
begin
   with LockVar do
   begin
     l_whence := SEEK_SET;
     l_start := 0;
     l_len := 0;
     l_type := F_UNLCK;
   end;
   Result := fcntl(Handle, F_SETLK, LockVar) <> -1;
end;
{$ENDIF}

Function gsSysLockFile(Handle: Integer; Position, Length: Int64): Boolean;
{$IFDEF WIN32}
begin
   Result := Windows.LockFile(Handle,Int64Rec(Position).Lo,Int64Rec(Position).Hi,
                                Int64Rec(Length).Lo,Int64Rec(Length).Hi);
end;
{$ENDIF}
{$IFDEF LINUX}
var
   LockVar: TFlock;
begin
   with LockVar do
   begin
     l_whence := SEEK_SET;
     l_start := 0;
     l_len := 0;
     l_type := F_WRLCK;
   end;
   Result := fcntl(Handle, F_SETLK, LockVar) <> -1;
end;
{$ENDIF}


procedure gsSysSleep(MS: integer);
begin
   {$IFDEF WIN32}
   Sleep(MS);
   {$ENDIF}
   {$IFDEF LINUX}
   Sleep((MS+999) div 1000);
   {$ENDIF}
end;


function gsSysRootDirectory: string;
{$IFDEF WIN32}
var
   WindowDirectory: array[0..MAX_PATH] of char;
begin
   GetWindowsDirectory(WindowDirectory, MAX_PATH);
   Result := StrPas(WindowDirectory);
end;
{$ENDIF}
{$IFDEF LINUX}
begin
   Result := '/usr/';
end;
{$ENDIF}


{no Linux Code}


{$IFDEF WIN32}
function gsSysSpawnAndWait(const CmdLine: string; Visibility : integer): integer;
var
   zCmdLine:array[0..512] of char;
   zCurDir:array[0..255] of char;
   WorkDir:String;
   StartupInfo:TStartupInfo;
   ProcessInfo:TProcessInformation;
   r: DWord;
begin
   StrPCopy(zCmdLine,CmdLine);
   GetDir(0,WorkDir);
   StrPCopy(zCurDir,WorkDir);
   FillChar(StartupInfo,Sizeof(StartupInfo),#0);
   StartupInfo.cb := Sizeof(StartupInfo);
   StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
   StartupInfo.wShowWindow := Visibility;
   if not CreateProcess(
      nil,
      zCmdLine,                      { pointer to command line string }
      nil,                           { pointer to process security attributes}
      nil,                           { pointer to thread security attributes }
      false,                         { handle inheritance flag }
      CREATE_NEW_CONSOLE or          { creation flags }
      NORMAL_PRIORITY_CLASS,
      nil,                           { pointer to new environment block }
      nil,                           { pointer to current directory name }
      StartupInfo,                   { pointer to STARTUPINFO }
      ProcessInfo) then Result := -1 { pointer to PROCESS_INF }
   else
   begin
      CloseHandle(ProcessInfo.hThread);
      WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
      CloseHandle(ProcessInfo.hProcess);
      GetExitCodeProcess(ProcessInfo.hProcess,r);
      Result := r;
   end;
end;

function gsSysSpawn(const CmdLine: string; Visibility : integer): integer;
var
   zCmdLine:array[0..512] of char;
   zCurDir:array[0..255] of char;
   WorkDir:String;
   StartupInfo:TStartupInfo;
   ProcessInfo:TProcessInformation;
   ProcBool: Bool;
begin
   StrPCopy(zCmdLine,CmdLine);
   GetDir(0,WorkDir);
   StrPCopy(zCurDir,WorkDir);
   FillChar(StartupInfo,Sizeof(StartupInfo),#0);
   StartupInfo.cb := Sizeof(StartupInfo);
   StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
   StartupInfo.wShowWindow := Visibility;
   ProcBool := CreateProcess(
      nil,
      zCmdLine,                      { pointer to command line string }
      nil,                           { pointer to process security attributes}
      nil,                           { pointer to thread security attributes }
      false,                         { handle inheritance flag }
      DETACHED_PROCESS or            { creation flags }
      NORMAL_PRIORITY_CLASS,
      nil,                           { pointer to new environment block }
      nil,                           { pointer to current directory name }
      StartupInfo,                   { pointer to STARTUPINFO }
      ProcessInfo);
   if ProcBool then
   begin
      Result := 0;
      CloseHandle(ProcessInfo.hThread);
      CloseHandle(ProcessInfo.hProcess);
   end
   else
      Result := abs(GetLastError);
end;

{$ENDIF}

end.
