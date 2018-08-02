unit CopyFilesClass;

interface

Uses Classes, Dialogs, SysUtils, Windows;

Type
  TCopyFiles = Class(TObject)
  Private
    FDirectoryLog : TStringList;
    FFileLog : TStringList;
    FErrorFile : ShortString;
    FErrorNo : LongInt;
  Public
    Property cfDirectoryLog : TStringList Read FDirectoryLog;
    Property cfErrorFile : ShortString Read FErrorFile;
    Property cfErrorNo : LongInt Read FErrorNo;
    Property cfFileLog : TStringList Read FFileLog;

    Constructor Create;
    Destructor Destroy; Override;

    // Checks for the specified file in network directory and copies it/them to the Local Directory
    function CopyFiles (Const NetDir, LocalDir, FName : ShortString; Const WantSub : Boolean = False) : Boolean;

    // Adds the specified files into the Directory and File logs without copying them
    Procedure LogFiles (SearchDir, FileSpec : ShortString; Const WantSub : Boolean = False);

    // Runs thorugh FFileLog and FDirectoryLog removing previously copied files
    Procedure RemoveLoggedFiles;
  End; // TCopyFiles

implementation

Uses ProgressF;

//=========================================================================

Constructor TCopyFiles.Create;
Begin // Create
  Inherited Create;
  FDirectoryLog := TStringList.Create;
  FFileLog := TStringList.Create;
End; // Create

//------------------------------

Destructor TCopyFiles.Destroy;
Begin // Destroy
  FFileLog.Free;
  FDirectoryLog.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Checks for the specified file in network directory and copies it/them to the Local Directory
function TCopyFiles.CopyFiles (Const NetDir, LocalDir, FName : ShortString; Const WantSub : Boolean = False) : Boolean;
Var
  NetFInfo, LclFInfo        : TSearchRec;
  SrchRes, FAttr            : Integer;
  SubDirName,
  DestName, DestDir, SrcDir : ShortString;
  WantCopy                  : Boolean;
  cpFromFile, cpToFile      : ANSIString;
  I                         : Smallint;
Begin // CopyFiles
  Result := True;

  // Calculate True directory paths
  SrcDir  := ExtractFilePath (NetDir + FName);
  DestDir := ExtractFilePath (LocalDir + FName);

  // Check Network Directory exists
  If DirectoryExists (SrcDir) Then
  Begin
    // Ensure local directory exists
    If (Not DirectoryExists (DestDir)) Then
    Begin
      ForceDirectories(DestDir);
      FDirectoryLog.Add (DestDir);
    End; // If (Not DirectoryExists (DestDir))

    Result := DirectoryExists (DestDir);
    If Result Then
    Begin
      // check 1+ files exist on network with matching name (including wildcards)
      // MH 18/09/2013 v7.0.6 ABSEXCH-14626: Added Try..Finally and FindClose
      SrchRes := FindFirst(NetDir + FName, faAnyFile, NetFInfo);
      Try
        While (SrchRes = 0) And Result Do
        Begin
          If ((NetFInfo.Attr And faDirectory) = faDirectory) Then
          Begin
            // Subdirectory
            If WantSub And (NetFInfo.Name <> '.') And (NetFInfo.Name <> '..') Then
            Begin
              // Valid Directory - need to call function recursively to copy subdirectories
              SubDirName := SrcDir + NetFInfo.Name + '\*.*';
              Delete (SubDirName, 1, Length(NetDir));

              Result := CopyFiles (NetDir, LocalDir, SubDirName, WantSub);
            End; // If WantSub And (NetFInfo.Name <> '.') And (NetFInfo.Name <> '..')
          End // If ((NetFInfo.Attr And faDirectory) = faDirectory)
          Else
          Begin
  //          lstProgress.Items[Pred(lstProgress.Items.Count)] := lstProgress.Items[Pred(lstProgress.Items.Count)] + #9'Updated';
  //          lstProgress.ItemIndex := Pred(lstProgress.Items.Count);
  //          lstProgress.Refresh;

            // Copy file across
            cpFromFile := SrcDir + NetFInfo.Name;
            cpToFile := DestDir + NetFInfo.Name;

            ProgressDialog.UpdateStageProgress (cpToFile);

            Result := CopyFile (PCHAR(cpFromFile), PCHAR(cpToFile), False);
            If Result Then
              FFileLog.Add (cpToFile)
            Else
            Begin
              FErrorFile := cpFromFile;
              FErrorNo := GetLastError;
            End; // Else
          End; // Else

          SrchRes := FindNext(NetFInfo);
        End; // While (SrchRes = 0) And Result
      Finally
        SysUtils.FindClose(NetFInfo);
      End; // Try..Finally
    End; // If Result
  End; // If DirectoryExists (SrcDir)
End; // CopyFiles

//-------------------------------------------------------------------------

// Adds the specified files into the Directory and File logs without copying them
Procedure TCopyFiles.LogFiles (SearchDir, FileSpec : ShortString; Const WantSub : Boolean = False);
Var
  NetFInfo   : TSearchRec;
  SrchRes    : Integer;
Begin // LogFiles
  // Check specified directory exists
  SearchDir := IncludeTrailingPathDelimiter(SearchDir);
  If DirectoryExists (SearchDir) Then
  Begin
    // MH 18/09/2013 v7.0.6 ABSEXCH-14626: Added Try..Finally and FindClose
    SrchRes := FindFirst(SearchDir + FileSpec, faAnyFile, NetFInfo);
    Try
      While (SrchRes = 0) Do
      Begin
        If ((NetFInfo.Attr And faDirectory) = faDirectory) Then
        Begin
          // Subdirectory
          If WantSub And (NetFInfo.Name <> '.') And (NetFInfo.Name <> '..') Then
          Begin
            // Valid Directory - need to call function recursively to copy subdirectories
            LogFiles (SearchDir + NetFInfo.Name, FileSpec, WantSub);
            FDirectoryLog.Add (SearchDir + NetFInfo.Name);
          End; // If WantSub And (NetFInfo.Name <> '.') And (NetFInfo.Name <> '..')
        End // If ((NetFInfo.Attr And faDirectory) = faDirectory)
        Else
        Begin
          // Copy file across
          FFileLog.Add (SearchDir + NetFInfo.Name);
        End; // Else

        SrchRes := FindNext(NetFInfo);
      End; // While (SrchRes = 0) And Result
    Finally
      SysUtils.FindClose(NetFInfo);
    End; // Try..Finally
  End; // If DirectoryExists (SearchDir)
End; // LogFiles

//-------------------------------------------------------------------------

// Runs thorugh FFileLog and FDirectoryLog removing previously copied files
Procedure TCopyFiles.RemoveLoggedFiles;
Var
  iFile, iError : LongInt;
Begin // RemoveLoggedFiles
  For iFile := 0 To (FFileLog.Count - 1) Do
  Begin
    ProgressDialog.UpdateStageProgress (FFileLog[iFile]);
    If (Not SysUtils.DeleteFile(FFileLog[iFile])) Then
    Begin
      iError := GetLastError;
      MessageDlg ('An error ' + IntToStr(iError) + ' ' + QuotedStr(SysErrorMessage(iError)) +
                  ' occurred whilst deleting ' + FFileLog[iFile], mtWarning, [mbOK], 0);
    End; // If (Not DeleteFile(FFileLog[iFile]))
  End; // For iFile

  // MH 18/09/2013 v7.0.6 ABSEXCH-14626: Changed loop to run forwards instead of backwards as
  // the FDirectoryLog entries are in the correct order (nodes first, root last)
  For iFile := 0 To (FDirectoryLog.Count - 1) Do
  Begin
    ProgressDialog.UpdateStageProgress (FDirectoryLog[iFile]);
    RmDir(FDirectoryLog[iFile]);
  End; // For iFile
End; // RemoveLoggedFiles

//-------------------------------------------------------------------------

end.
