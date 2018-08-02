///////////////////////////////////////////////////
// Unit containing common File handling routines //
///////////////////////////////////////////////////
unit FileUtil;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}

interface
uses
  classes, StrUtil, FileCtrl, APIUtil, Windows, Registry, Dialogs;

type
  TEnterpriseVersion = (ev5, ev550, ev551, ev552);

const
  evs55x = [ev550, ev551, ev552];

var
  csWriteToFile : TRTLCriticalSection;

  function  DeleteFiles(FileList : TStringList) : boolean;
  function AddLineToFile(sLine, sFileName: String; bShowMessage : boolean = TRUE) : string;
  function AddLineToFileEx(sLine, sFileName : string; bShowMessage : boolean = TRUE) : string;
  function AddLineToFileNoMessage(sLine, sFileName: String; bShowMessage : boolean = TRUE) : string;
  procedure DebugToFile(sLineToAppend: String; sFileName : string = 'c:\Debug.txt');
  function  Check83ValidFileWithExt(var sFileName : string; sExt : string3) : Boolean;
  function  GetEntSwapDir(sCompanyDir : string) : string;
  procedure CreateFile(sFileName : String);
  function GetEnterpriseDirectory : string;
  Function GetEnterpriseDirFromReg : String;
  Function ValidEntSystemDir(EntDir : ShortString) : Boolean;
  Procedure CopyAFileInUse(sCopyFrom, sCopyTo : AnsiString);

  // Calculates the Full Path of the Exchequer Faxing directory from the
  // FaxPath specified in Exchequer System Setup.
  function CalcEnterpriseFaxingDirectory (Const FaxPath : String) : string;
  function GetEnterpriseVersion(sMainCompanyDir : string) : TEnterpriseVersion;

  // Returns TRUE if the specified file is open
  Function FileIsOpen (Const sFileName : ShortString) : Boolean;

  procedure CopyFiles(sCopyFrom, sCopyTo : string; bFailIfExists : boolean);
  procedure DeleteAllFilesInDir(sDir : string);


implementation
uses
  SysUtils, IniFiles, forms,
  VAOUtil;

function DeleteFiles(FileList : TStringList) : boolean;
// Pre    : FileList = String list with fully qualified file names
// Action : Attempts to delete as many files as possible
// Post   : Returns true if all files deleted
var
  i : integer;
  DeleteOK : boolean;
begin
  if not Assigned(FileList) then
  begin
    Result := false;
    exit;
  end;

  Result := true;
  with FileList do
    for i := 0 to Count -1 do
    begin
      // Avoid any problems with short-circuit boolean evaluation
      DeleteOK := SysUtils.DeleteFile(Strings[i]);
      Result := Result and DeleteOK;
    end;
end; // DeleteFiles

function AddLineToFile(sLine, sFileName: String; bShowMessage : boolean = TRUE) : string;
// Appends a line of text to a specified text file.
//
// sLine : Line of text to add
// sFileName : full path of file to append the line of text to.
var
  AppendFile: TextFile;
begin
  Result := '';
  try
    if sFileName <> '' then begin
      AssignFile(AppendFile, sFileName);
      if FileExists(sFileName) then Append(AppendFile)
      else Rewrite(AppendFile);
      if sLine <> '' then Writeln(AppendFile,sLine);
      CloseFile(AppendFile);
    end;{if}
  except
    on E: Exception do begin
      Result := 'AddLineToFile - ' + sFileName + ' : ' + E.Message;
      if bShowMessage then begin
        MsgBox('AddLineToFile caused the following error, whilst writing to the file :'
        + sFileName + #13#13 + E.Message, mtError, [mbOK], mbOK, 'AddLineToFile Error');
      end;{if}
    end;{on}
  end;{try}
end;

function AddLineToFileNoMessage(sLine, sFileName: String; bShowMessage : boolean = TRUE) : string;
// Appends a line of text to a specified text file. If there is an exception then no message
// is shown - the caller must handle the exception
// sLine : Line of text to add
// sFileName : full path of file to append the line of text to.
var
  AppendFile: TextFile;
begin
  Result := '';
  if sFileName <> '' then begin
    AssignFile(AppendFile, sFileName);
    if FileExists(sFileName) then Append(AppendFile)
    else Rewrite(AppendFile);
    if sLine <> '' then Writeln(AppendFile,sLine);
    CloseFile(AppendFile);
  end;{if}
end;


function AddLineToFileEx(sLine, sFileName : string; bShowMessage : boolean = TRUE) : string;
var
  iTries : integer;
begin
  iTries := 0;
  Repeat
    inc(iTries);
    EnterCriticalSection(csWriteToFile);
    Result := AddLineToFile(sLine, sFileName, bShowMessage);
    LeaveCriticalSection(csWriteToFile);
    if Result <> '' then SleepEx(100, TRUE);
  until (iTries >= 100) or (Result = '');
end;


procedure DebugToFile(sLineToAppend: String; sFileName : string = 'c:\Debug.txt');
// Appends a string to default file : c:\debug.txt
// Used for debugging.
//
// sLineToAppend : Line of text to add
// sFileName : full path of file to append the line of text to.
begin
  AddLineToFile(DateToStr(Date) + ' ' + TimeToStr(Time) + '  ' + sLineToAppend, sFileName);
end;

Function Check83ValidFileWithExt(var sFileName : string; sExt : string3) : Boolean;
// Checks to see if a filename is a valid file name with the given extension.
var
  iDotPos : smallint;
  sFileNoExt : string8;
begin
  Result := TRUE;
  sFileName := Trim(sFileName);
  iDotPos := Pos('.',sFileName);

  if (sExt = '') and (iDotPos <> 0) then sExt := copy(sFilename,iDotPos + 1,3);

  if (Length(sFileName) = 0) or (Pos(' ',sFileName) > 0) or (iDotPos > 9) or (iDotPos = 1)
  then Result := FALSE
  else begin
    if iDotPos = 0 then
      begin
        if length(sFileName) > 8 then Result := FALSE
        else sFileNoExt := sFileName;
      end
    else sFileNoExt := Copy(sFilename,1,iDotPos - 1);
  end;{if}

  if Result then begin
    if sExt = '' then sFileName := sFileNoExt
    else sFileName := sFileNoExt + '.' + sExt;
  end;{if}

end;

function GetEntSwapDir(sCompanyDir : string) : string;
begin
  Result := IncludeTrailingBackslash(sCompanyDir) + 'SWAP\';
  if not DirectoryExists(Result) then CreateDir(Result);
end;

procedure CreateFile(sFileName : String);
var
  TheFile : TextFile;
begin
  if sFileName <> '' then begin
    AssignFile(TheFile, sFileName);
    if FileExists(sFileName) then Append(TheFile)
    else Rewrite(TheFile);
    CloseFile(TheFile);
  end;{if}
end;

function GetEnterpriseDirectory : string;
//var
//  EntDir, DataDir : string;
begin
  Result := VAOInfo.vaoCompanyDir;
(***
  EntDir := ExtractFilePath(Application.ExeName);
  DataDir := Entdir;

  // Check for Local Program Files
  If FileExists (ExtractFilePath(Application.ExeName) + 'ENTWREPL.INI') Then
    With TIniFile.Create (ExtractFilePath (Application.ExeName) + 'ENTWREPL.INI') Do
      Try
        DataDir := IncludeTrailingBackslash(ReadString ('UpdateEngine', 'NetworkDir', EntDir));
        If Not FileExists (DataDir + 'COMPANY.DAT') Then
          DataDir := EntDir;
      Finally
        Free;
      End;
  Result := DataDir;
***)
end;

//-------------------------------------------------------------------------

// Calculates the Full Path of the Exchequer Faxing directory from the
// FaxPath specified in Exchequer System Setup.
function CalcEnterpriseFaxingDirectory (Const FaxPath : String) : string;
Var
  CurDir : ANSIString;
begin { CalcEnterpriseFaxingDirectory }
  // Check for Relative Path - relative paths start with '?:\...'
  If (FaxPath <> '') And (Copy (FaxPath, 2, 1) <> ':') Then Begin
    // Relative Path - Save current directory
    GetDir (0, CurDir);
    Try
      // Change current directory to Exchequer Main Company directory
      ChDir(GetEnterpriseDirectory);

      // Expand the Relative Path into a full path
      Result := IncludeTrailingPathDelimiter(ExpandFileName(FaxPath));
    Finally
      // Restore original directory
      ChDir(CurDir);
    End;
  End { If (Value <> '') }
  Else
    // Not relative path
    Result := IncludeTrailingPathDelimiter(UpperCase(Trim(FaxPath)));
End; { CalcEnterpriseFaxingDirectory }

//-------------------------------------------------------------------------

Procedure CopyAFileInUse(sCopyFrom, sCopyTo : AnsiString);
var
  Src, Dst : Pchar;
  InitF : TIniFile;
begin
  if GetWindowsVersion in wv95Versions then
    begin
      InitF := TIniFile.Create('WinInit.Ini');

      Src := StrAlloc(255);
      Dst := StrAlloc(255);

      GetShortPathName(PCHAR(sCopyFrom), Src, 255);
      GetShortPathName(PCHAR(sCopyTo), Dst, 255);

      InitF.WriteString ('Rename', Dst, Src);

      StrDispose(Src);
      StrDispose(Dst);

      InitF.Free;
    end
  else begin
    MoveFileEx(PCHAR(sCopyFrom), PCHAR(sCopyTo), MOVEFILE_DELAY_UNTIL_REBOOT Or MOVEFILE_REPLACE_EXISTING);
  end;
end;

function GetEnterpriseVersion(sMainCompanyDir : string) : TEnterpriseVersion;
begin
  Result := ev5;
  if FileExists(sMainCompanyDir + 'ENTFORMS.EXE')
  and FileExists(sMainCompanyDir + 'ENTDATAQ.DLL')
  then begin
    Result := ev550;
    if FileExists(sMainCompanyDir + 'ENTDRILL.EXE') then
    begin
      Result := ev551;
      if FileExists(sMainCompanyDir + 'ENRENDER.DLL')
      then Result := ev552;
    end;{if}
  end;{if}
end;

Function GetEnterpriseDirFromReg : String;
//Var
//  sNetworkPath, TmpStr : String;
//  EntWReplINI : TInifile;
Begin { GetEnterpriseDir }
  Result := GetEnterpriseDirectory;

(***
//  Result := 1002;

  Result := '';

  Try
    // Look in Registry to identify the Exchequer directory from registered OLE/COM Objects
    With TRegistry.Create Do
      Try
        // Require Read-Only rights to the Registry
        Access := KEY_READ;

        // Firstly check for a registered OLE Server
        RootKey := HKEY_CLASSES_ROOT;

        //--------------------------------------

        If KeyExists('Enterprise.OLEServer\Clsid') Then
          { Key exists - Open key and get the CLSID (aka OLE/COM Server GUID) }
          If OpenKey('Enterprise.OLEServer\Clsid', False) Then Begin
            If KeyExists('') Then Begin
              { Read CLSID stored in default entry }
              TmpStr := ReadString ('');
              CloseKey;

              { Got CLSID - find entry in CLSID Section and check for registered .EXE }
              If KeyExists ('Clsid\'+TmpStr+'\LocalServer32') Then
                { Got Server details - read .EXE details and check it exists }
                If OpenKey('Clsid\'+TmpStr+'\LocalServer32', False) Then Begin
                  TmpStr := ReadString ('');

                  If FileExists (TmpStr) Then Begin
                    { Got OLE Server - Check for full system }
                    TmpStr := ExtractFilePath(TmpStr);

                    // For local program files, use the network directory.
                    if fileExists(TmpStr + 'ENTWREPL.INI') then begin
                      EntWReplINI := TInifile.Create(TmpStr + 'ENTWREPL.INI');
                      sNetworkPath := EntWReplINI.ReadString('UpdateEngine', 'NetworkDir', TmpStr);
                      if (Trim(sNetworkPath) <> '') and DirectoryExists(IncludeTrailingBackslash(sNetworkPath))
                      then TmpStr := IncludeTrailingBackslash(sNetworkPath);
                      EntWReplINI.Free;
                    end;{if}

                    If ValidEntSystemDir (TmpStr) Then Result := TmpStr;
                  End; { If FileExists (ClsId) }
                End; { If OpenKey(... }
            End; { If KeyExists('') }

            CloseKey;
          End; { If OpenKey('Enterprise.OLEServer\Clsid' }

        //--------------------------------------

//        If (Result <> 0) Then
          // OLE Server not registered - try ????

        //--------------------------------------

        If (Result <> '') Then
          // Check for Local Program Files - data may be in a different directory
          If FileExists (Result + 'ENTWREPL.INI') Then
            With TIniFile.Create (Result + 'ENTWREPL.INI') Do
              Try
                // Read the path which points to the enterprise network dir - usually blank
                TmpStr := ReadString ('UpdateEngine', 'NetworkDir', '');
                If (Trim(TmpStr) <> '') Then Begin
                  // Got a network dir - check the path is valid before returning it
                  TmpStr := IncludeTrailingBackslash (TmpStr);
                  If ValidEntSystemDir (TmpStr) Then Begin
                    // Valid Enterprise directory - return path
                    Result := TmpStr;
//                    If (Length(TmpStr) <= StrBufSize(EnterpriseDir)) Then Begin
//                      Result := 0;
//                      StrPCopy (EnterpriseDir, TmpStr);
//                    End { If }
  //                  Else
                      // Pchar parameter not long enough
//                      Result := 1003;
                  End; { If ValidEntSystemDir}
                End; { If (Trim(TmpStr) <> '') }
              Finally
                Free;
              End;
      Finally
        Free;
      End;
  Except
    On E : Exception Do Begin
      Result := TmpStr;
    End; { On E : Exception }
  End; { Try..Except }
***)
End; { GetEnterpriseDir }

Function ValidEntSystemDir(EntDir : ShortString) : Boolean;
Begin { ValidEntSystemDir }
  EntDir := IncludeTrailingBackslash (EntDir);

{$IFDEF EXSQL}
  Result := ValidSystem(EntDir);
{$ELSE}
  // Check for system files in specified directory
  Result := FileExists (EntDir + 'Company.Dat') And          // MCM Database
            FileExists (EntDir + 'Entrprse.Exe') And         // Splash Screen
            FileExists (EntDir + 'EntComp.Dll') And          // MCM Library
            FileExists (EntDir + 'Enter1.Exe') And           // Exchequer
            FileExists (EntDir + 'EntCustm.Dll') And         // Customisation Library
            FileExists (EntDir + 'ExchqSS.Dat') And          // System Setup Database
            FileExists (EntDir + 'ExchqNum.Dat') And         // Document Numbers Database
            FileExists (EntDir + 'Cust\Custsupp.Dat');       // Customer/Supplier Database
{$ENDIF}
End; { ValidEntSystemDir }

//-------------------------------------------------------------------------

// Returns TRUE if the specified file is open 
Function FileIsOpen (Const sFileName : ShortString) : Boolean;
Var
  FS : TFileStream;
Begin // FileIsOpen
  Result := False;

  // Check the filename is set and the file exists
  If (Trim(SFileName) <> '') Then
  Begin
    If FileExists(SFileName) Then
    Begin
      Try
        FS := TFileStream.Create (sFileName, fmOpenReadWrite or fmShareExclusive);
        FS.Free;
      Except
        // file is in use or does not exist, check exception objects info
        Result := True;
      End;
    End; // If FileExists(SFileName)
  End; // If (Trim(SFileName) <> '')
End; // FileIsOpen

//-------------------------------------------------------------------------

procedure CopyFiles(sCopyFrom, sCopyTo : string; bFailIfExists : boolean);
var
  sCopyFromDir : string;
  SearchRec : TSearchRec;
  bContinue : boolean;
  asNewFileName, asFileName : ANSIString;

begin{CopyFiles}
  if not DirectoryExists(sCopyTo) then exit;
  sCopyFromDir := ExtractFilePath(sCopyFrom);

  // Copy All Files
  bContinue := (FindFirst(sCopyFrom, faAnyFile, SearchRec) = 0);
  while bContinue do begin
    if ((faDirectory and SearchRec.Attr) > 0) then // its a dir
    else begin
      // Copy File
      asFileName := sCopyFromDir + SearchRec.Name;
      asNewFileName := sCopyTo + SearchRec.Name;
      CopyFile(PChar(asFileName), PChar(asNewFileName), bFailIfExists);
    end;{if}

    // Next
    bContinue := (FindNext(SearchRec) = 0);
  end;{while}

  FindClose(SearchRec);
end;{CopyFiles}

procedure DeleteAllFilesInDir(sDir : string);
var
  SearchRec : TSearchRec;
  bContinue : boolean;
  asFileName : ANSIString;

begin{DeleteAllFilesInDir}
  if not DirectoryExists(sDir) then exit;

  // Delete All Files
  bContinue := (FindFirst(sDir + '*.*', faAnyFile, SearchRec) = 0);
  while bContinue do begin
    if ((faDirectory and SearchRec.Attr) > 0) then
    begin
      // its a dir
      // Next
      bContinue := (FindNext(SearchRec) = 0);
    end else
    begin
      // Delete File
      asFileName := sDir + SearchRec.Name;
      DeleteFile(PChar(asFileName));
      bContinue := (FindFirst(sDir + '*.*', faAnyFile, SearchRec) = 0);
    end;{if}

    // First
  end;{while}

  FindClose(SearchRec);
end;{CopyFiles}

initialization
  InitializeCriticalSection(csWriteToFile);

finalization
  DeleteCriticalSection(csWriteToFile);

end.
