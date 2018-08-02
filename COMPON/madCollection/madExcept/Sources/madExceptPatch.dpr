// ***************************************************************
//  madExceptPatch.dpr        version:  2.7b  ·  date: 2009-02-09
//  -------------------------------------------------------------
//  patches a binary according to the project's *.mes file
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2009 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2009-02-09 2.7b Delphi 2009 support
// 2006-02-23 2.7a undocumented MES file option "MadExcept2Only" added
// 2004-04-18 2.7  some command line /options added
// 2003-11-10 2.6  (1) error code for "specified file not found" was incorrect
//                 (2) BCB support added (.tds instead of .map)
//                 (3) map file parameter was kind of ignored (duh!)
//                 (4) help text extended for BCB
// 2003-06-09 2.5  (1) new bug report options supported
//                 (2) print button supported
//                 (3) new options SuspendThreads, AutoClose, BugReportFileSize
//                 (4) option vars are now short strings instead of char arrays
// 2002-12-03 2.3a unit initialization order option added in order to fix
//                 problems with memory management replacements like ShareMem
// 2002-10-12 2.2  (1) the exception box's title bar is now freely adjustable
//                 (2) the map file stream is now added as a resource
//                     -> this way exe packers don't trash the map file stream
//                     -> the stream can be loaded through resource APIs
//                 (3) uncompressed "map" file -> compressed "mad" file
//                 (4) ico/bmp files like "meiMail.ico" in the project's root
//                     folder automatically replace madExcept's default images
// 2002-06-19 2.1c parameters may also be relative to the current directory
// 2002-06-14 2.1b instead of entry point patching the initialization order of
//                 the units SysUtils/madTools/madExcept is now manipulated
//                 this moves some hacks out of the binary into the IDE wizard
//                 and more exceptions get caught now during finalization
// 2002-02-24 2.1a (1) you can now alternatively specify the path of mes/map
//                 (2) the map file is not deleted, anymore
// 2002-02-08 2.1  (1) madExcept now also runs 100% fine with runtime packages
//                 (2) "save bug report" button added + auto save option
//                 (3) email address max length increased to 75
//                 (4) email subject max length increased to 50
// 2001-09-27 2.0b turning freeze check off didn't work
// 2001-08-03 2.0a got rid of mailBody ("please press Ctrl+V" message)
// 2001-07-22 2.0  (1) madAppendMap.exe -> madExceptPatch.exe
//                 (2) the utility now searches & uses the project's *.mes file
// 2001-06-10 1.2a initialization of vars for madExcept.InitExceptionHandling
// 2001-04-30 1.2  entry point manipulation: automatic madExcept initialization

program madExceptPatch;

{$apptype console}

// dontTouchUses  <- this tells madExcept to not touch the uses clause

uses madExcept, madLinkDisAsm, Windows, SysUtils, madStrings, madExceptPatcher;
 
{$R madExcept.res}
{$R madExceptBitmaps.res}
{$R asInvoker.res}

// ***************************************************************

procedure Help;
begin
  WriteLn('Patches a binary according to the project''s *.mes file.');
  WriteLn;
  WriteLn('madExceptPatch BinaryFile [Path\[MesFile]] [Path\[MapFile]] [/options]');
  WriteLn;
  WriteLn('  BinaryFile :  "some.exe/dll/bpl" file, full path mandatory');
  WriteLn('  MesFile    :  "some.mes"         file, full path optional');
  WriteLn('  MapFile    :  "some.map"         file, full path optional');
  WriteLn;
  WriteLn('  /options   :  overwrite settings stored in mes file');
  WriteLn('    /enabled=0/1');
  WriteLn('    /freezeTimeout=ms');
  WriteLn;
  WriteLn('Example 1:');
  WriteLn('madExceptPatch "C:\Dir1\Test.exe"');
  WriteLn('  -> mes file is guessed at "C:\Dir1\Test.mes"');
  WriteLn('  -> map file is guessed at "C:\Dir1\Test.map"');
  WriteLn;
  WriteLn('Example 2:');
  WriteLn('madExceptPatch "C:\Dir1\Test.exe" "AllProjects.mes"');
  WriteLn('  -> mes file is guessed at "C:\Dir1\AllProjects.mes"');
  WriteLn('  -> map file is guessed at "C:\Dir1\Test.map"');
  WriteLn;
  WriteLn('Example 3:');
  WriteLn('madExceptPatch "C:\Dir1\Test.exe" "C:\Generic\AllProjects.mes"');
  WriteLn('  -> map file is guessed at "C:\Dir1\Test.map"');
  WriteLn;
  WriteLn('If no *.mes file is found, the default settings are used.');
  WriteLn;
  WriteLn('BCB users please specify the .tds file instead of the map file.');
  WriteLn;
  WriteLn('exitCode:');
  WriteLn('0 = success');
  WriteLn('1 = file not found');
  WriteLn('2 = no map file found');
  WriteLn('3 = no binary file specified');
  WriteLn('4 = incompatible module initialization code');
  WriteLn('5 = patching of unit initialization order failed');
  WriteLn('6 = the specified version variable was not found');
  WriteLn('7 = please add madExcept to the uses clause');
  WriteLn('8 = binary is in use');
  WriteLn('9 = map file couldn''t be loaded');
end;

// ***************************************************************

procedure DoIt;
var project  : TProject;
    root     : AnsiString;
    binary   : AnsiString;
    mes, map : AnsiString;
    b1       : boolean;
    s1, s2   : AnsiString;
    i1, i2   : integer;
begin
  binary := '';
  mes    := '';
  map    := '';
  b1 := LoadDefaultSettings(project);
  for i1 := 1 to ParamCount do begin
    s1 := AnsiString(ParamStr(i1));
    KillChar(s1, '"');
    if (s1 = '') or (s1[1] = '/') or (GetFileAttributesA(PAnsiChar(s1)) = dword(-1)) then begin
      if PosTextIs1(AnsiString('/enabled='), s1) or
         PosTextIs1(AnsiString( 'enabled='), s1) then begin
        if s1[1] = '/' then
             Delete(s1, 1, Length('/enabled='))
        else Delete(s1, 1, Length( 'enabled='));
        project.Enabled := (s1 = '1') or IsTextEqual(s1, AnsiString('yes')) or IsTextEqual(s1, AnsiString('on'));
      end else
        if PosTextIs1(AnsiString('/freezeTimeout='), s1) or
           PosTextIs1(AnsiString( 'freezeTimeout='), s1) then begin
          if s1[1] = '/' then
               Delete(s1, 1, Length('/freezeTimeout='))
          else Delete(s1, 1, Length( 'freezeTimeout='));
          project.FreezeTimeout  := StrToIntDef(string(s1), 0);
          project.CheckForFreeze := project.FreezeTimeout <> 0;
        end else begin
          if (s1 <> '/?') and (s1 <> '-?') then
            WriteLn('File "' + s1 + '" not found.')
          else
            Help;
          Halt(1);
        end;
    end else begin
      if ExtractFilePath(string(s1)) = '' then begin
        s2 := AnsiString(GetCurrentDir);
        if (s2 <> '') and (s2[Length(s2)] <> '\') then s2 := s2 + '\';
        s1 := s2 + s1;
        if GetFileAttributesA(PAnsiChar(s1)) = dword(-1) then begin
          WriteLn('File "' + s1 + '" not found.');
          Halt(1);
        end;
      end;
      if IsTextEqual(ExtractFileExt(string(s1)), '.mes') then begin
        mes := s1;
        LoadSettingsFromIni(RetDeleteR(mes, 4), project);
      end else
        if IsTextEqual(ExtractFileExt(string(s1)), '.map') or IsTextEqual(ExtractFileExt(string(s1)), '.tds') then
          map := s1
        else
          binary := s1;
    end;
  end;
  if project.MadExcept2Only then begin
    WriteLn('This project may only be compiled with madExcept 2.');
    Halt(7);
  end else
    if binary <> '' then begin
      root := RetDelete(binary, PosStr(AnsiString('.'), binary, maxInt, 1), maxInt);
      if map = '' then begin
        map := root + '.map';
        if GetFileAttributesA(PAnsiChar(map)) = dword(-1) then begin
          map := root + '.tds';
          if GetFileAttributesA(PAnsiChar(map)) = dword(-1) then begin
            WriteLn('No map file found.');
            Halt(2);
          end;
        end;
      end;
      if mes = '' then
        if GetFileAttributesA(PAnsiChar(root + '.mes')) <> dword(-1) then
          LoadSettingsFromIni(root, project)
        else
          if GetFileAttributesA(PAnsiChar(root + '.amf')) <> dword(-1) then begin
            WriteLn('Settings loaded from "' + root + '.amf" (old format!).');
            LoadSettingsFromIni(root, project);
          end else begin
            WriteLn('No *.mes file found for this project.');
            if not b1 then begin
              WriteLn('No default settings found in the registry.');
              WriteLn('Using factory default settings.');
            end else
              WriteLn('Default settings loaded from registry.');
          end;
      i2 := PatchBinary(project, binary, root, map, true, s1);
      for i1 := 1 to SubStrCount(s1) do begin
        s2 := SubStr(s1, i1);
        if s2 <> '' then
          WriteLn(Copy(s2, 2, maxInt));
      end;
      Halt(i2);
    end else
      if ParamCount = 0 then begin
        Help;
        Halt(3);
      end else begin
        WriteLn('Where is the binary file, please?');
        Halt(3);
      end;
end;

begin
  DoIt;
end.
