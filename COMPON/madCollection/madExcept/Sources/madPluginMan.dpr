// ***************************************************************
//  madPluginMan.dpr          version:  1.0a  ·  date: 2008-01-14
//  -------------------------------------------------------------
//  madExcept plugin manager - automated plugin installer  
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2008 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2008-01-14 1.0b support for Delphi 2007 added
// 2006-01-30 1.0a limited supported for BCB added      
// 2005-07-17 1.0  initial release                   

program madPluginMan;

// dontTouchUses

uses madExcept, madLinkDisAsm, Windows, SysUtils, madStrings;

{$R madExcept.res}

var root : string;

function CreateDpk(version, imageBase: dword; fileName, descr: string) : string;
begin
  result := 'package ' + fileName + IntToStrEx(version) + '0;' + #$D#$A + #$D#$A +
            '{$ALIGN ON}'            + #$D#$A +
            '{$ASSERTIONS ON}'       + #$D#$A +
            '{$BOOLEVAL OFF}'        + #$D#$A +
            '{$DEBUGINFO ON}'        + #$D#$A +
            '{$EXTENDEDSYNTAX ON}'   + #$D#$A +
            '{$IMPORTEDDATA ON}'     + #$D#$A +
            '{$IOCHECKS ON}'         + #$D#$A +
            '{$LOCALSYMBOLS ON}'     + #$D#$A +
            '{$LONGSTRINGS ON}'      + #$D#$A +
            '{$OPENSTRINGS ON}'      + #$D#$A +
            '{$OPTIMIZATION ON}'     + #$D#$A +
            '{$OVERFLOWCHECKS OFF}'  + #$D#$A +
            '{$RANGECHECKS OFF}'     + #$D#$A +
            '{$REFERENCEINFO ON}'    + #$D#$A +
            '{$SAFEDIVIDE OFF}'      + #$D#$A +
            '{$STACKFRAMES OFF}'     + #$D#$A +
            '{$TYPEDADDRESS OFF}'    + #$D#$A +
            '{$VARSTRINGCHECKS ON}'  + #$D#$A +
            '{$WRITEABLECONST ON}'   + #$D#$A +
            '{$MINENUMSIZE 1}'       + #$D#$A +
            '{$IMAGEBASE ' + IntToHexEx(imageBase) + '}' + #$D#$A +
            '{$DESCRIPTION ''' + fileName + ' - ' + descr + '''}' + #$D#$A +
            '{$DESIGNONLY}'          + #$D#$A +
            '{$IMPLICITBUILD OFF}'   + #$D#$A + #$D#$A +
            'requires'               + #$D#$A +
            '  madExcept_;'          + #$D#$A + #$D#$A +
            'contains'               + #$D#$A +
            '  ' + fileName + ' in ''' + fileName + '.pas'';' + #$D#$A + #$D#$A +
            'end.';
end;

procedure RemoveComments(var content: string);
var i1, i2 : integer;
begin
  i1 := 1;
  while i1 < Length(content) do begin
    case content[i1] of
      '/' : if content[i1 + 1] = '/' then begin
              i2 := PosStr(#$D#$A, content, i1 + 2);
              if i2 = 0 then
                i2 := maxInt;
              Delete(content, i1, i2 - i1);
            end else
              inc(i1);
      '{' : begin
              i2 := PosStr('}', content, i1 + 1, maxInt);
              if i2 = 0 then
                i2 := maxInt;
              Delete(content, i1, i2 - i1 + 1);
            end;
      '(' : if content[i1 + 1] = '*' then begin
              i2 := PosStr('*)', content, i1 + 2);
              if i2 = 0 then
                i2 := maxInt;
              Delete(content, i1, i2 - i1 + 2);
            end else
              inc(i1);
      '''': begin
              repeat
                inc(i1);
              until (i1 = Length(content)) or (content[i1] = '''');
              inc(i1);
            end;
      else  inc(i1);
    end;
  end;
end;

procedure FormatString(var str: string);
var s1     : string;
    b1     : boolean;
    i1, i2 : integer;
begin
  s1 := str;
  str := '';
  b1 := false;
  i2 := 0;
  for i1 := 1 to Length(s1) do
    if s1[i1] = '''' then begin
      b1 := not b1;
      if b1 then
        i2 := i1 + 1
      else
        str := str + Copy(s1, i2, i1 - i2);
    end;
end;

function CompileDelphi(version: integer; bcb: boolean; fileName, descr: string) : string;

  function VersionToDir(version: integer; forceDelphi: boolean) : string;
  begin
    case version of
      9  : result := 'Delphi2005';
      10 : result := 'DeXter';
      11 : result := 'DeXter';
      else if bcb and (not forceDelphi) then
                result := 'BCB'     + IntToStrEx(version)
           else result := 'Delphi ' + IntToStrEx(version);
    end;
  end;

  function VersionToName(version: integer) : string;
  begin
    case version of
      9  : result := 'Delphi2005';
      10 : if bcb then
                result := 'BCB 2006'
           else result := 'Delphi 2006';
      11 : if bcb then
                result := 'BCB 2007'
           else result := 'Delphi 2007';
      else if bcb then
                result := 'BCB '    + IntToStrEx(version)
           else result := 'Delphi ' + IntToStrEx(version);
    end;
  end;

var s1, s2 : string;
    fh     : dword;
    c1     : dword;
    b1     : boolean;
    si     : TStartupInfo;
    pi     : TProcessInformation;
    arrCh  : array [0..MAX_PATH] of char;
begin
  b1 := false;
  if version > 7 then begin
    s1 := 'BDS';
    c1 := version - 6;
  end else
    if bcb then begin
      s1 := 'C++Builder';
      c1 := version;
    end else begin
      s1 := 'Delphi';
      c1 := version;
    end;
  s1 := RegReadStr(HKEY_LOCAL_MACHINE, 'Software\Borland\' + s1 + '\' + IntToStrEx(c1) + '.0', 'RootDir');
  if s1 <> '' then begin
    if s1[Length(s1)] <> '\' then
      s1 := s1 + '\';
    s1 := s1 + 'Bin\dcc32.exe';
    fh := CreateFile(pchar(root + '\' + fileName + IntToStrEx(version) + '0.dpk'), GENERIC_WRITE, 0, nil, CREATE_ALWAYS, 0, 0);
    if fh <> INVALID_HANDLE_VALUE then begin
      s2 := CreateDpk(version, $5f000000 + dword(Random($100)) shl 16, fileName, descr);
      b1 := WriteFile(fh, pchar(s2)^, Length(s2), c1, nil) and (c1 = dword(Length(s2)));
      CloseHandle(fh);
      if b1 then begin
        ZeroMemory(@si, sizeOf(si));
        si.cb := sizeOf(si);
        si.dwFlags := STARTF_USESHOWWINDOW;
        si.wShowWindow := SW_HIDE;
        s1 := '"' + s1 + '"';
        s1 := s1 + ' -e. -n. -o. -r. -b -q';
        if bcb then
          s1 := s1 + ' -jphne';
        GetModuleFileName(HInstance, arrCh, MAX_PATH);
        s2 := '"' + ExtractFilePath(RetDeleteR(ExtractFilePath(arrCh), 1)) + VersionToDir(version, false) + '"';
        s1 := s1 + ' -u' + s2 + ';';
        ReplaceText(s2, 'madExcept', 'madDisAsm');
        s1 := s1 + s2 + ';';
        ReplaceText(s2, 'madDisAsm', 'madBasic');
        s1 := s1 + s2;
        if bcb and (version <= 7) then begin
          GetModuleFileName(HInstance, arrCh, MAX_PATH);
          s2 := '"' + ExtractFilePath(RetDeleteR(ExtractFilePath(arrCh), 1)) + VersionToDir(version, true) + '"';
          s1 := s1 + ' -u' + s2 + ';';
          ReplaceText(s2, 'madExcept', 'madDisAsm');
          s1 := s1 + s2 + ';';
          ReplaceText(s2, 'madDisAsm', 'madBasic');
          s1 := s1 + s2;
        end;
        s1 := s1 + ' "' + fileName + IntToStrEx(version) + '0.dpk"';
        b1 := CreateProcess(nil, pchar(s1), nil, nil, false, 0, nil, pchar(root), si, pi);
        if b1 then begin
          CloseHandle(pi.hThread);
          WaitForSingleObject(pi.hProcess, INFINITE);
          b1 := GetExitCodeProcess(pi.hProcess, c1) and (c1 = 0);
          CloseHandle(pi.hProcess);
        end;
      end;
    end;
    if b1 then
         result := 'plugin installation into ' + VersionToName(version) + ' succeeded...' + #$D#$A
    else result := 'plugin installation into ' + VersionToName(version) + ' failed...'    + #$D#$A;
  end;
end;

var filePath   : string;
    fileName   : string;
    fileExt    : string;
    content    : string;
    name       : string;
    descr      : string;
    s1         : string;
    fh         : dword;
    c1         : dword;
    i1, i2, i3 : integer;
    b1         : boolean;
begin
  Randomize;
  root := RegReadStr(HKEY_CURRENT_USER, 'Software\madshi\madExcept', 'plugin root');
  if root <> '' then begin
    if ParamCount = 1 then begin
      s1 := ParamStr(1);
      KillChar(s1, '"');
      fh := CreateFile(pchar(s1), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
      if fh <> INVALID_HANDLE_VALUE then begin
        SetLength(content, GetFileSize(fh, nil));
        if (not ReadFile(fh, pointer(content)^, Length(content), c1, nil)) or (c1 <> dword(Length(content))) then
          content := '';
        CloseHandle(fh);
        if content <> '' then begin
          RemoveComments(content);
          i1 := PosText('RegisterBugReportPlugin', content);
          if i1 > 0 then begin
            i1 := PosStr('(', content, i1, maxInt);
            if i1 > 0 then begin
              b1 := false;
              i3 := 0;
              for i2 := i1 + 1 to Length(content) do
                case content[i2] of
                  '''' : begin
                           b1 := not b1;
                           if i3 = 0 then
                             i3 := i2;
                         end;
                  ','  : if (i3 > 0) and (not b1) then begin
                           descr := Copy(content, i3, i2 - i3);
                           if name = '' then begin
                             name := descr;
                             descr := '';
                             i3 := 0;
                           end else
                             break;
                         end;
                end;
              if (name <> '') and (descr <> '') then begin
                FormatString(name);
                FormatString(descr);
                filePath := ExtractFilePath(s1);
                fileName := ExtractFileName(s1);
                fileExt  := ExtractFileExt(fileName);
                DeleteR(fileName, Length(fileExt));
                CreateDirectory(pchar(root), nil);
                if IsTextEqual(filePath, root + '\' + fileName) or
                   CopyFile(pchar(s1), pchar(root + '\' + fileName + '.pas'), false) then begin
                  s1 := CompileDelphi( 4, false, fileName, descr) +
                        CompileDelphi( 5, true,  fileName, descr) +
                        CompileDelphi( 5, false, fileName, descr) +
                        CompileDelphi( 6, true,  fileName, descr) +
                        CompileDelphi( 6, false, fileName, descr) +
                        CompileDelphi( 7, false, fileName, descr) +
                        CompileDelphi( 9, false, fileName, descr) +
                        CompileDelphi(10, true,  fileName, descr) +
                        CompileDelphi(10, false, fileName, descr) +
                        CompileDelphi(11, true,  fileName, descr) +
                        CompileDelphi(11, false, fileName, descr);
                  PostMessage(HWND_BROADCAST, RegisterWindowMessage('madExceptIdeCheckPlugins'), 0, 0);
                  MessageBox(0, pchar(s1), 'madExcept Plugin Manager', MB_OK);
                end else MessageBox(0, 'Copying the plugin to the plugin root directory failed.', 'madExcept Plugin Manager', MB_ICONERROR);
              end else MessageBox(0, 'The specified plugin has an incorrect format.', 'madExcept Plugin Manager', MB_ICONERROR);
            end else MessageBox(0, 'The specified plugin has an incorrect format.', 'madExcept Plugin Manager', MB_ICONERROR);
          end else MessageBox(0, 'The specified plugin has an incorrect format.', 'madExcept Plugin Manager', MB_ICONERROR);
        end else MessageBox(0, 'The specified plugin could not be read.', 'madExcept Plugin Manager', MB_ICONERROR);
      end else MessageBox(0, 'Please just double click on one plugin at a time.', 'madExcept Plugin Manager', MB_ICONERROR);
    end else MessageBox(0, 'Please just double click on one plugin at a time.', 'madExcept Plugin Manager', MB_ICONERROR);
  end else MessageBox(0, 'Plugin root directory not found.', 'madExcept Plugin Manager', MB_ICONERROR);
end.
