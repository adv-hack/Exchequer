unit EntReplU;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Controls, Dialogs, FileCtrl, Forms, SysUtils, Windows, WiseUtil;

function EntReplicate(var DLLParams: ParamRec): LongBool; StdCall; export;
function SCD_ReplicateFiles(var DLLParams: ParamRec): LongBool; StdCall; export;

// MH 07/04/2017 2017-R1 ABSEXCH-18512: Example VRW Reports
// Function searches the directory and any sub-directories specified in V_REPLICATIONDIRECTORY
// and adds the files into Replicat.Txt in V_MAINDIR so that the existing replication routine
// (SCD_ReplicateFiles) will process them
function SCD_ReplicateFilesInDir(var DLLParams: ParamRec): LongBool;

Function ProcessReplication (ExeDir : ShortString) : LongInt;

implementation

Uses GlobVar, VarConst, BtrvU2, EntRegU, RegProg, GlobExcH,
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     CompUtil;


{ -v4.30c: Replicates any files necessary to all companies }
function EntReplicate(var DLLParams: ParamRec): LongBool;
Var
  ExeDir    : String;
Begin
  {$IFDEF HMTEST}
    ShowMessage ('EntReplicate');
    Result := False;
  {$ELSE}
    DllStatus := 0;

    { Get Installation Type from WISE }
    GetVariable(DLLParams, 'MAINDIR', ExeDir);
    FixPath (ExeDir);
    SystemDir := ExeDir;

    { Check paths are valid }
{$IFDEF EXSQL}
    if SQLUtils.ValidSystem(ExeDir) then
{$ELSE}
    If FileExists (ExeDir + 'ENTCOMP.DLL') And FileExists (ExeDir + 'COMPANY.DAT') Then
{$ENDIF}
    Begin
      { Do the Biz!!! }
      ProcessReplication(ExeDir);
    End { If }
    Else Begin
      DllStatus := 1;
      MessageDlg ('The directory containing the main company is invalid' + #10#13#10#13 + ExeDir, mtError, [mbOk], 0);
    End; { Else }

    Result := (DllStatus <> 0);
  {$ENDIF}
End;

{ v4.31 - Single-CD: Replicates any files necessary to all companies }
//
// 1000   - Unknown Error
// 1001   - Unknown Exception
// 1002   - Invalid Main Directory
function SCD_ReplicateFiles(var DLLParams: ParamRec): LongBool;
Var
  DllStatus : LongInt;
  ExeDir    : String;
Begin { SCD_ReplicateFiles }
  DllStatus := 1000;

  Try
    { Get Installation Type from WISE }
    GetVariable(DLLParams, 'V_MAINDIR', ExeDir);
    FixPath (ExeDir);
    SystemDir := ExeDir;

    { Check paths are valid }
{$IFDEF EXSQL}
    if SQLUtils.ValidSystem(ExeDir) then
{$ELSE}
    If FileExists (ExeDir + 'ENTCOMP.DLL') And FileExists (ExeDir + 'COMPANY.DAT') Then
{$ENDIF}
    Begin
      { Do the Biz!!! }
      DllStatus := ProcessReplication(ExeDir);
    End { If }
    Else
      { Invalid Main Directory }
      DllStatus := 1002;
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex);
      DLLStatus := 1001;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_ReplicateFiles }

//-------------------------------------------------------------------------

// MH 07/04/2017 2017-R1 ABSEXCH-18512: Example VRW Reports
// Function searches the directory and any sub-directories specified in V_REPLICATIONDIRECTORY
// and adds the files into Replicat.Txt in V_MAINDIR so that the existing replication routine
// (SCD_ReplicateFiles) will process them.
//
// Note: Directory must be off Exchequer main directory
//
function SCD_ReplicateFilesInDir(var DLLParams: ParamRec): LongBool;
Var
  ReplFile : TStringList;
  DllStatus : LongInt;
  ExeDir, SearchDir, FileSpec : String;

  //-----------------------------------

  Procedure SearchForFiles (Const SearchPath, FileSpec : String);
  Var
    FileSearchInfo : TSearchRec;
    FileSearchRes : Integer;
    RelPath : ShortString;
  Begin // SearchForFiles
    // Convert directory path being search to relative path for replication file
    RelPath := IncludeTrailingPathDelimiter(ExtractRelativePath(ExeDir, SearchPath));

    FileSearchRes := FindFirst(SearchPath + FileSpec, faAnyFile, FileSearchInfo);
    Try
      // Search for matching files
      While (FileSearchRes = 0) Do
      Begin
        If ((FileSearchInfo.Attr And faDirectory) = faDirectory) Then
        Begin
          // Subdirectory - suppress . and .. otherwise it goes into an infinite loop and crashes without an exception! StackOverflow?
          If (FileSearchInfo.Name <> '.') And (FileSearchInfo.Name <> '..') Then
            SearchForFiles (SearchPath + FileSearchInfo.Name + '\', FileSpec)
        End // If ((FileSearchInfo.Attr And faDirectory) = faDirectory)
        Else
        Begin
          // File to replicate - specified as relative to Exch main dir
          ReplFile.Add (' ' + RelPath + FileSearchInfo.Name);
        End; // Else

        FileSearchRes := FindNext(FileSearchInfo);
      End; // While (FileSearchRes = 0) And Result
    Finally
      SysUtils.FindClose (FileSearchInfo);
    End; // Try..Finally
  End; // SearchForFiles

  //-----------------------------------

Begin // SCD_ReplicateFilesInDir
  DllStatus := 1000;

  Try
    // Get Installation Directory from WISE
    GetVariable(DLLParams, 'V_MAINDIR', ExeDir);
    ExeDir := IncludeTrailingPathDelimiter(ExeDir);
    //FixPath (ExeDir);

    // Get Directory to search
    GetVariable(DLLParams, 'V_REPLICATIONDIRECTORY', SearchDir);

    // Get FileSpec to search for, e.g. *.*
    GetVariable(DLLParams, 'V_REPLICATIONFILESPEC', FileSpec);
    If (FileSpec = '') Then
      FileSpec := '*.*';

    If DirectoryExists(ExeDir) And DirectoryExists(SearchDir) Then
    Begin
      // Load in the existing Replication List to append to
      ReplFile := TStringList.Create;
      If FileExists(ExeDir + 'REPLICAT.TXT') Then
        ReplFile.LoadFromFile (ExeDir + 'REPLICAT.TXT');
      Try
        SearchForFiles (IncludeTrailingPathDelimiter(SearchDir), FileSpec);

        ReplFile.SaveToFile (ExeDir + 'REPLICAT.TXT');

        DLLStatus := 0;
      Finally
        FreeAndNIL(ReplFile);
      End; // Try..Finally
    End // If DirectoryExists(ExeDir) And DirectoryExists(SearchDir)
    Else
      // Invalid Main Directory
      DllStatus := 1002;
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex);
      DLLStatus := 1001;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; // SCD_ReplicateFilesInDir

//=========================================================================

// Processes Replicat.Txt and copies specified files out to all sub-companies
//
// 10000        - Unknown Error
// 10001        - Unknown Exception
// 10100-10199  - Btrieve Error opening Company.Dat
Function ProcessReplication (ExeDir : ShortString) : LongInt;
Const
  FNum    = CompF;
  KeyPath : Integer = CompCodeK;
Var
  ProgressWin                  : TRegisterProgress;
  ReplList                     : TStringList;
  ReplF                        : TextFile;
  DestFile                     : ShortString;
  ReplStr                      : String;
  I                            : SmallInt;
  KeyS                         : Str255;
  FromStr, ToStr               : PChar;
  Res                          : Boolean;
Begin
  Result := 10000;

  Try
    { Check for file to replicate }
    If FileExists (ExeDir + 'REPLICAT.TXT') Then Begin
      { Got file - load into StringList for processing }
      ReplList := TStringList.Create;
      Try
        { Load Replication List }
        ReplList.LoadFromFile (ExeDir + 'REPLICAT.TXT');

        { Check we've got something to replicate }
        If (ReplList.Count > 0) Then Begin
          { open company database }
          Status := Open_File(F[FNum], ExeDir + FileNames[FNum], 0);

          If StatusOk Then Begin
            { Create progress form }
            ProgressWin := TRegisterProgress.Create(Application);
            Try
              With ProgressWin Do Begin
                Caption := 'Replicating Files';
                Title := 'Replicating Files';
                Descr := 'Please wait while updated files are being copied to each company';
                ShowProgInfo := True;
                ProgMin := 1;
                ProgMax := Used_Recs(F[Fnum],Fnum);
                ProgPos := 1;
              End; { With }

              { Step through each company }
              Status := Find_Rec(B_GetFirst, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
              While StatusOk Do
              Begin
                If (Company^.RecPFix = cmCompDet) Then
                Begin
                  With Company^.CompDet Do
                  Begin
                    If (UpperCase(Trim(CompPath)) <> UpperCase(ExeDir)) Then
                    Begin
                      // MH 02/03/2009: Added section to delete Excheqr.Sys files from company
                      // directories as v6.00.003 installer seems to be creating them somehow
                      If FileExists (IncludeTrailingPathDelimiter(Trim(CompPath)) + 'Excheqr.Sys') Then
                      Begin
                        SysUtils.DeleteFile(IncludeTrailingPathDelimiter(Trim(CompPath)) + 'Excheqr.Sys');
                      End; // If FileExists (IncludeTrailingPathDelimiter(Trim(CompPath)) + 'Excheqr.Sys')

                      If (Not ProgressWin.Visible) Then
                      Begin
                        ProgressWin.Show;
                        ProgressWin.Refresh;
                      End; { If }

                      With ProgressWin.Label3 Do
                      Begin
                        Caption := Trim(CompName);
                        Refresh;
                      End; { With }

                      For I := 0 To (ReplList.Count - 1) Do
                      Begin
                        With ProgressWin.Label4 Do
                        Begin
                          Caption := Copy(ReplList.Strings[I], 2, Length(ReplList.Strings[I]));
                          Refresh;
                        End; { With }

                        FromStr := StrAlloc (250);
                        ToStr   := StrAlloc (250);

                        DestFile := Trim(CompPath) + Trim(Copy(ReplList.Strings[I], 2, Length(ReplList.Strings[I])));

                        { HM 09/12/99: Ensure destination directory exists }
                        ForceDirectories(ExtractFilePath(DestFile));

                        StrPCopy (FromStr, Trim(ExeDir) + Trim(Copy(ReplList.Strings[I], 2, Length(ReplList.Strings[I]))));
                        StrPCopy (ToStr, DestFile);

                        Res := CopyFile (FromStr, ToStr, (ReplList.Strings[I][1] = '*'));

                        StrDispose (FromStr);
                        StrDispose (ToStr);
                      End; { For }
                    End; { With }
                  End; { With Company^.CompDet }
                End; // If (Company^.RecPFix = cmCompDet)

                ProgressWin.ProgPos := Succ(ProgressWin.ProgPos);
                Status := Find_Rec(B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
              End; { While }

              { close company database }
              Close_File(F[CompF]);

              Result := 0;
            Finally
              ProgressWin.Free;
            End; { Try }
          End { If }
          Else
            { Btrieve Error opening Company.Dat }
            Result := 10100 + Status;
        End { If (ReplList.Count > 0) }
        Else Begin
          { No Items To Replicate }
          Result := 0;
        End; { Else }
      Finally
        ReplList.Destroy;
      End; { Try }
    End { If FileExists (ExeDir + 'REPLICAT.TXT') }
    Else Begin
      { No Replication File }
      Result := 0;
    End; { Else }
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex);
      Result := 10001;
    End; { On }
  End;
End;

end.

