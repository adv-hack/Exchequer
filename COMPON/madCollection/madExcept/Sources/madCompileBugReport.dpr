// ***************************************************************
//  madCompileBugReport.dpr   version:  1.0c  ·  date: 2009-02-11
//  -------------------------------------------------------------
//  bug report compiler, see "include minimal debug info" option
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2009 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2009-02-11 1.0c (1) Delphi 2009 support
//                 (2) fixed problem when mad and map file both existed
// 2008-03-03 1.0b sometimes the right mad file was not found
// 2006-01-30 1.0a line numbers were sometimes incorrect
// 2005-10-09 1.0  initial release                   

program madCompileBugReport;

{$apptype console}

// dontTouchUses  <- this tells madExcept to not touch the uses clause

uses madExcept, madLinkDisAsm, madListHardware, madListProcesses,
     madListModules, madMapFile, Windows, SysUtils, Classes, madStrings;

{$R madExcept.res}

function ReadClipboard : AnsiString;
var mem : dword;
begin
  if OpenClipboard(0) then begin
    mem := GetClipboardData(CF_TEXT);
    result := PAnsiChar(GlobalLock(mem));
    GlobalUnlock(mem);
    CloseClipboard;
  end;
end;

function SaveStrToFile(filename, str: AnsiString) : boolean;
var c1, c2 : dword;
begin
  c1 := CreateFileA(PAnsiChar(filename), GENERIC_READ or GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_FLAG_SEQUENTIAL_SCAN, 0);
  if c1 <> INVALID_HANDLE_VALUE then begin
    result := (str = '') or (WriteFile(c1, pointer(str)^, length(str), c2, nil) and (c2 = dword(Length(str))));
    CloseHandle(c1);
  end else
    result := false;
end;

function LoadStrFromFile(filename: AnsiString) : AnsiString;
var c1, c2 : dword;
begin
  result := '';
  c1 := CreateFileA(PAnsiChar(filename), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_FLAG_SEQUENTIAL_SCAN, 0);
  if c1 <> INVALID_HANDLE_VALUE then begin
    SetLength(result, GetFileSize(c1, nil));
    if (result <> '') and (not (ReadFile(c1, pointer(result)^, Length(result), c2, nil) and (c2 = dword(Length(result))))) then
      result := '';
    CloseHandle(c1);
  end;
end;

var
  madFiles : array of record
    madFile : AnsiString;
    mapFile : TMapFile;
  end;

function FindMadFile(madFile, madSign, madFolder: AnsiString) : boolean;
var wfd             : TWin32FindDataA;
    sh, fh          : dword;
    size, date, crc : dword;
    c1, c2          : dword;
    i1              : integer;
    madFile2        : AnsiString;
begin
  result := false;
  madFile2 := madFile;
  DeleteR(madFile2, Length(ExtractFileExt(string(madFile2))));
  size := dword(StrToIntDef(string(RetTrimStr(SubStr(madSign, 1, ','))), -777));
  date := dword(StrToIntDef(string(RetTrimStr(SubStr(madSign, 2, ','))), -777));
  crc  := dword(StrToIntDef(string(RetTrimStr(SubStr(madSign, 3, ','))), -777));
  if (size <> dword(-777)) and (date <> dword(-777)) and (crc <> dword(-777)) then
    for i1 := SubStrCount(madFolder) downto 1 do begin
      sh := FindFirstFileA(PAnsiChar(SubStr(madFolder, i1) + '\*.mad'), wfd);
      if sh <> INVALID_HANDLE_VALUE then
        try
          repeat
            if (wfd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY = 0) and
               (wfd.nFileSizeLow = size) and (wfd.nFileSizeHigh = 0) and
               FileMatch(wfd.cFileName, '*' + madFile2 + '*.mad') then begin
              fh := CreateFileA(PAnsiChar(SubStr(madFolder, i1) + '\' + wfd.cFileName),
                               GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
              if fh <> INVALID_HANDLE_VALUE then begin
                if (SetFilePointer(fh, dword(Length(CMapFileStreamDescriptor)) + 8, nil, FILE_BEGIN) > 0) and
                   ReadFile(fh, c2, 4, c1, nil) and (c1 = 4) and (c2 = date) and
                   ReadFile(fh, c2, 4, c1, nil) and (c1 = 4) and (c2 = crc ) then begin
                  SetLength(madFiles, Length(madFiles) + 1);
                  madFiles[high(madFiles)].madFile := madFile;
                  madFiles[high(madFiles)].mapFile := LoadMapFile(SubStr(madFolder, i1) + '\' + wfd.cFileName, true);
                  WriteLn('File "' + SubStr(madFolder, i1) + '\' + wfd.cFileName + '" accepted.');
                  result := true;
                end;
                CloseHandle(fh);
              end;
            end;
          until result or (not FindNextFileA(sh, wfd));
        finally Windows.FindClose(sh) end;
      if result then
        break;
    end;
  if not result then
    WriteLn('Didn''t find file "' + madFile2 + '.mad".');
end;

procedure AdjustColumn(sl: TStringList; line, index, minLen: integer);
var i1, i2 : integer;
    s1     : AnsiString;
    b1     : boolean;
begin
  for i1 := line downto 0 do
    if sl[i1] = '' then begin
      line := i1 + 2;
      break;
    end;
  for i1 := line to sl.Count - 1 do
    if sl[i1] <> '' then begin
      s1 := AnsiString(sl[i1]);
      if (Length(s1) > index) and (s1[1] <> '>') then begin
        b1 := false;
        for i2 := index to Length(s1) do begin
          if s1[i2] = ' ' then
            b1 := true
          else
            if b1 then begin
              if i2 - index < minLen then begin
                Insert(FillStr(AnsiString(''), minLen - (i2 - index)), s1, i2);
                sl[i1] := string(s1);
              end;
              break;
            end;
        end;
      end;
    end else
      break;
end;

procedure FormatColumns(sl: TStringList);

  procedure FormatColumns_(start, stop: integer);
  var i1, i2, i3 : integer;
      b1         : boolean;
  begin
    if (start <= stop) and (StrToIntDef('$' + Copy(sl[start], 1, 8), -777) <> -777) and
       (sl[start][9] = ' ') and (StrToIntDef('$' + Copy(SubStr(sl[start], 2, ' '), 2, maxInt), -777) <> -777) then begin
      i2 := 0;
      for i1 := start to stop do
        if (Length(sl[i1]) > i2) and (sl[i1][1] <> '>') then
          i2 := Length(sl[i1]);
      for i3 := i2 - 1 downto 1 do begin
        b1 := true;
        for i1 := start to stop do
          if ((i3     <= Length(sl[i1])) and (sl[i1][i3    ] <> ' ')) or
             ((i3 + 1 <= Length(sl[i1])) and (sl[i1][i3 + 1] <> ' ')) then begin
            b1 := false;
            break;
          end;
        if b1 then
          for i1 := start to stop do
            sl[i1] := RetDelete(sl[i1], i3, 1);
      end;
    end;
  end;

var i1, i2 : integer;
begin
  i2 := 0;
  for i1 := 0 to sl.Count - 1 do
    if sl[i1] = '' then begin
      if i2 > 0 then
        FormatColumns_(i2, i1 - 1);
      i2 := i1 + 2;
    end;
end;

procedure HandleBugReport(var brc: AnsiString; madFolder: AnsiString);
var sl : TStringList;
    i1, i2, i3, i4, i5, i6 : integer;
    s1, s2, s3 : AnsiString;
    b1, b2 : boolean;
    old : AnsiString;
begin
  madFiles := nil;

  if not PosTextIs1(AnsiString('date/time'), brc) then
    exit;

  i1 := PosStr(AnsiString(#$D), brc);
  if i1 = 0 then
    i1 := maxInt;
  s1 := Copy(brc, 1, i1 - 1);
  i1 := PosStr(AnsiString(':'), s1);
  if i1 > 0 then
    Delete(s1, 1, i1);
  TrimStr(s1);
  WriteLn('Found exception "' + s1 + '".');

  old := brc;

  sl := TStringList.Create;
  sl.Text := string(brc);

  b1 := false;
  b2 := true;
  i1 := 0;
  while i1 < sl.Count do begin
    if sl[i1] <> '' then begin
      s1 := RetTrimStr(SubStr(AnsiString(sl[i1]), 1, ':'));
      if IsTextEqual(ExtractFileExt(string(s1)), '.mad') then begin
        b2 := false;
        DeleteR(s1, 4);
        if FindMadFile(s1, RetTrimStr(SubStr(AnsiString(sl[i1]), 2, ':')), madFolder) then begin
          b1 := true;
          sl.Delete(i1);
          dec(i1);
        end;
      end;
    end else
      break;
    inc(i1);
  end;
  if b2 then begin
    WriteLn('The bug report is already complete.');
    exit;
  end;
  if not b1 then begin
    WriteLn('Didn''t find any of the needed "mad" files, so gave up.');
    exit;
  end;

  b2 := true;
  for i1 := 0 to sl.Count - 1 do begin
    s1 := AnsiString(sl[i1]);
    if s1 = 'disassembling:' then
      b2 := false;
    i6 := 0;
    while true do begin
      i6 := PosText('segment%', s1, i6 + 1);
      if i6 = 0 then
        break;
      i3 := -1;
      i4 := maxInt;
      for i2 := 0 to high(madFiles) do begin
        if b2 then
          // callstack: exe/dll is located before the segment/public
          i5 := PosText(madFiles[i2].madFile, s1, 1, i6)
        else
          // disassembling: exe/dll is located after the segment/public
          i5 := PosText(madFiles[i2].madFile, s1, i6 + 10, maxInt);
        if (i5 > 0) and (i5 < i4) then begin
          i3 := i2;
          i4 := i5;
        end;
      end;
      if i3 >= 0 then begin
        s2 := RetTrimStr(SubStr(SubStr(Copy(s1, i6, maxInt), 1, ' '), 1, '.'));
        Delete(s2, 1, 8);
        s3 := madFiles[i3].mapFile.FindSegment(StrToIntDef(string(s2), -777)).Unit_;
        if s3 <> '' then begin
          if b2 then begin
            s3 := s3 + '          ' + '       ';
            sl[i1] := string(s1);
            AdjustColumn(sl, i1, i6, Length(s3) + 1);
            s1 := AnsiString(sl[i1]);
            if Length(s1) < i6 + Length(s3) - 1 then
              SetLength(s1, i6 + Length(s3) - 1);
            for i3 := i6 + Length(s3) to i6 + 8 + Length(s2) - 1 do
              s1[i3] := ' ';
            Move(s3[1], s1[i6], Length(s3));
          end else begin
            Delete(s1, i6, 8 + Length(s2));
            Insert(s3, s1, i6);
          end;
        end;
      end;
    end;
    sl[i1] := string(s1);
  end;

  b2 := true;
  for i1 := 0 to sl.Count - 1 do begin
    s1 := AnsiString(sl[i1]);
    if s1 = 'disassembling:' then
      b2 := false;
    i6 := 0;
    while true do begin
      i6 := PosText('public%',  s1, i6 + 1);
      if i6 = 0 then
        break;
      i3 := -1;
      i4 := maxInt;
      for i2 := 0 to high(madFiles) do begin
        if b2 then
          // callstack: exe/dll is located before the segment/public
          i5 := PosText(madFiles[i2].madFile, s1, 1, i6)
        else
          // disassembling: exe/dll is located after the segment/public
          i5 := PosText(madFiles[i2].madFile, s1, i6 + 10, maxInt);
        if (i5 > 0) and (i5 < i4) then begin
          i3 := i2;
          i4 := i5;
        end;
      end;
      if i3 >= 0 then begin
        s2 := RetTrimStr(SubStr(SubStr(Copy(s1, i6, maxInt), 1, ' '), 1, '.'));
        Delete(s2, 1, 7);
        if (s2 <> '') and (s2[length(s2)] = ':') then
          DeleteR(s2, 1);
        s3 := madFiles[i3].mapFile.FindPublic(StrToIntDef(string(s2), -777)).Name;
        if s3 <> '' then begin
          if b2 then begin
            i4 := integer(madFiles[i3].mapFile.FindPublic(StrToIntDef(string(s2), -777)).Address);
            i5 := StrToIntDef(string('$' + Copy(SubStr(s1, 2, ' '), 2, maxInt)), -777);
            if i5 <> -777 then begin
              i5 := madFiles[i3].mapFile.FindLine(pointer(i4 + i5));
              i4 := i5 - madFiles[i3].mapFile.FindLine(pointer(i4));
            end else
              i5 := 0;
            if i5 <> 0 then
              s3 := IntToStrEx(i5, 9, ' ') + ' ' + FillStr('+' + IntToStrEx(i4), 6, ' ') + ' ' + s3
            else
              s3 := '          ' + '       ' + s3;
            if Length(s1) < i6 + Length(s3) - 17 - 1 then
              SetLength(s1, i6 + Length(s3) - 17 - 1);
            for i3 := i6 + Length(s3) - 17 to i6 + 7 + Length(s2) - 1 do
              s1[i3] := ' ';
            Move(s3[1], s1[i6 - 17], Length(s3));
          end else begin
            Delete(s1, i6, 7 + Length(s2));
            Insert(s3, s1, i6);
          end;
        end;
        for i3 := Length(s1) downto 1 do
          if s1[i3] <> ' ' then begin
            Delete(s1, i3 + 1, maxInt);
            break;
          end;
      end;
    end;
    sl[i1] := string(s1);
  end;

  FormatColumns(sl);

  brc := AnsiString(sl.Text);

  if brc <> old then
       WriteLn('The exception was updated.')
  else WriteLn('Didn''t find anything to do.');
end;

function HandleBugReports(brc: AnsiString; madFolder: AnsiString) : AnsiString;
var i1 : integer;
    s1 : AnsiString;
begin
  result := '';
  repeat
    i1 := PosText(AnsiString(#$A + 'date/time'), brc, maxInt, 1);
    if i1 > 0 then begin
      inc(i1);
      s1 := Copy(brc, i1, maxInt);
      Delete(brc, i1, maxInt);
      HandleBugReport(s1, madFolder);
      result := s1 + result;
    end else begin
      HandleBugReport(brc, madFolder);
      result := brc + result;
      break;
    end;
  until brc = '';
end;

var i1 : integer;
    s1 : AnsiString;
    bugReport, madFolder : AnsiString;
    arrCh : array [0..MAX_PATH] of AnsiChar;
    brc, brc2 : AnsiString;
begin
  GetCurrentDirectoryA(MAX_PATH, arrCh);

  bugReport := '';
  madFolder := AnsiString(ExtractFilePath(ParamStr(0))) + '|' + arrCh;
  for i1 := 1 to ParamCount do begin
    s1 := AnsiString(ParamStr(i1));
    KillChar(s1, '"');
    if GetFileAttributesA(PAnsiChar(s1)) <> dword(-1) then begin
      if GetFileAttributesA(PAnsiChar(s1)) and FILE_ATTRIBUTE_DIRECTORY = 0 then
        bugReport := s1
      else
        madFolder := madFolder + '|' + s1;
    end else begin
      WriteLn('file/directory "' + s1 + '" not found');
      Halt(0);
    end;
  end;

  if bugReport <> '' then
       brc := LoadStrFromFile(bugReport)
  else brc := ReadClipboard;

  if (bugReport = '') and (PosText(AnsiString('date/time'), brc) = 0) then begin
    WriteLn('bug report compiler, see "include minimal debug info, only" option');
    WriteLn;
    WriteLn('madCompileBugReport [BugReportFile] [MadFolder1] [MadFolderX]');
    WriteLn;
    WriteLn('  BugReportFile : "bugReport.txt" file');
    WriteLn('  MadFolder     : folder, where "mad" files are stored');
    WriteLn;
    WriteLn('The folder from which madCompileBugReport was started and');
    WriteLn('the "current" folder are always searched for "mad" files, too.');
    WriteLn;
    WriteLn('If no bug report file is specified, the clipboard is "compiled".');
    WriteLn;
    WriteLn('Example:');
    WriteLn('madCompileBugReport "c:\bugReport.txt" "c:\ReleaseBuildMadFiles"');
    Halt(0);
  end else
    if PosText(AnsiString('date/time'), brc) = 0 then begin
      WriteLn('The file "' + ExtractFileName(string(bugReport)) + '" doesn''t seem to contain a valid bug report.');
      Halt(0);
    end else
      if bugReport = '' then
        WriteLn('Bug report(s) imported from clipboard.')
      else
        WriteLn('Bug report file "' + bugReport + '" loaded.');

  brc2 := HandleBugReports(brc, madFolder);

  if brc2 <> brc then
    if bugReport <> '' then begin
      SaveStrToFile(bugReport, brc2);
      WriteLn('Bug report file "' + bugReport + '" saved.');
    end else begin
      FillClipboard(brc2);
      WriteLn('Bug report(s) copied to clipboard.');
    end;
end.
