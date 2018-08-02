unit DiskUtil;

{ markd6 14:54 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$Warn UNIT_PLATFORM OFF}
{$Warn SYMBOL_PLATFORM OFF}

Uses Classes, Dialogs, FileCtrl, Forms, SysUtils, Windows;

{$H-}

Const
  { Required Bytes Free }
  SpaceThreshold : Double =  204800.0;
  SpaceWarning   : Double = 1040000.0;


Type
  DriveInfoType = Record
    drDrive         : Char;           { Drive Letter }
    drLogicalNo     : Byte;           { Logical Drive Number, A=0, B=1, C=2, D=3, ... }
    drDriveType     : TDriveType;     { Drive Type: Floppy, CD-ROM, FIXED, ... }
    drVolume        : String[20];     { Volume Name }
    drFileSystem    : String[20];     { File System Name: FAT, HPFS, NTFS, ... }
    drCaseSensitive : Boolean;        { File System is Case Sensitive }
    drCompressed    : Boolean;        { File System is Compressed }
    drDiskSpace     : Double;         { Total Disk Space avaiable }
    drSpaceFree     : Double;         { Disk Space Free }

    drGotVolInfo    : Boolean;        { Volume Info call succeeded }
  End; { DriveInfoType }


{ Returns loadsa information about the specified drive }
Function GetDriveInfo (Var DriveInfo : DriveInfoType) : Boolean; Export;

{ Returns the Logical Drive Number for the specified Drive Letter, returns 255 if invalid }
Function LogicalDriveNo (DriveCh : Char) : Byte; Export;

{ Returns the Total Free disk space on the logical drive }
function dblDiskFree(Drive: Byte) : Double; Export;

{ Returns the Total disk space on the logical drive }
function dblDiskSize(Drive: Byte) : Double; Export;

{ Checks > 1Mb free disk space in path }
Function CheckDiskSpace (DirPath, LogPath : ShortString) : Boolean;

{ Checks the passed directory attributes }
Function CheckDirRights (DirPath, LogPath : ShortString; CheckMode : Byte) : Boolean;

{ Writes a log message to the log files directory }
Function DoLogMsg (Const LogPath, LogType, Msg1, Msg2, Msg3, Msg4 : String; Const Msg5 : String = ''): Boolean;

{ Returns a string representation of the Drive Type }
Function DriveTypeStr (Const DriveType : TDriveType) : ShortString;

{ Checks that Application.Exename has a valid non-UNC path }
Function CheckForUNCPath : Boolean;
Function CheckForUNCPathMsg (Const AppTitle, MsgTitle : ANSIString) : Boolean;


Implementation

{$IFDEF COMP}
Uses History;      // MCM Version No
{$ENDIF}

{ Writes a log message to the log files directory }
Function DoLogMsg (Const LogPath, LogType, Msg1, Msg2, Msg3, Msg4 : String; Const Msg5 : String = ''): Boolean;
Var
  LogF               : TextFile;
  TmpName, LogName   : String[12];
  I                  : SmallInt;
  pSysComp, pSysUser : PChar;
  StrLength          : DWord;
Begin { DoLogMsg }
  Result := False;

  Try
    { Check its set }
    If (Trim(LogPath) <> '') Then
      { Check it exists }
      If DirectoryExists(LogPath) Then Begin
        { Look in directory and generate a unique name }
        LogName := '';
        For I := 1 To 9999 Do Begin
          TmpName := 'E' + IntToStr(I) + '.Log';

          If Not FileExists(LogPath + TmpName) Then Begin
            LogName := TmpName;
            Break;
          End { If }
          Else
            LogName := '';
        End; { For }

        If (Trim(LogName) <> '') Then Begin
          { Get Windows User Name }
          StrLength := 100;
          pSysUser := StrAlloc (StrLength);
          GetUserName (pSysUser, StrLength);

          { Get Computer Name }
          StrLength := 100;
          pSysComp := StrAlloc (StrLength);
          GetComputerName (pSysComp, StrLength);

          { Create log entry in enterprise logs }
          AssignFile (LogF, LogPath + LogName);
          Rewrite (LogF);
          Try
            {$IFDEF COMP}
              Writeln (LogF, 'Exchequer Multi-Company Manager ' + CurrVersion_Comp);
            {$ELSE}
              Writeln (LogF, 'Exchequer Loader');
            {$ENDIF}
            Writeln (LogF);
            Writeln (LogF, FormatDateTime ('DD/MM/YY - HH:MM:SS', Now),
                           '    Computer: ', StrPas(pSysComp),
                           '    User: ', StrPas(pSysUser));
            Writeln (LogF, '---------------------------------------------------------------');
            Writeln (LogF, 'Log Type : ' + LogType);
            Writeln (LogF);
            Writeln (LogF, Msg1);
            Writeln (LogF, Msg2);
            If (Trim(Msg3) <> '') Then Writeln (LogF, Msg3);
            If (Trim(Msg4) <> '') Then Writeln (LogF, Msg4);
            If (Trim(Msg5) <> '') Then Writeln (LogF, Msg5);
          Finally
            CloseFile (LogF);
            Result := True;
          End;
        End; { If }
      End; { If }
  Except
    On Ex:Exception Do Begin
      {MessageDlg ('The following error occurred during the startup checks of ' + #13 +
                  'the Exchequer directory:' + #13#13 +
                  '"' + Ex.Message + '".', mtError, [mbOk], 0);}
      Result := False;
    End;
  End;
End;  { DoLogMsg }


function dblDiskFree(Drive: Byte) : Double;
var
  RootPath: array[0..4] of Char;
  RootPtr: PChar;
  SectorsPerCluster,
  BytesPerSector,
  FreeClusters,
  TotalClusters: DWord;
  SPC, BPS, FC : Double;
begin
  RootPtr := nil;

  StrCopy(RootPath, 'A:\');
  RootPath[0] := Chr(Ord('A') + Drive);
  RootPtr := RootPath;

  If GetDiskFreeSpace(RootPtr, SectorsPerCluster, BytesPerSector, FreeClusters, TotalClusters) Then Begin
    SPC := SectorsPerCluster;
    BPS := BytesPerSector;
    FC  := FreeClusters;

    Result := SPC * BPS * FC;
  End { If }
  Else
    { Call Failed }
    Result := -1;
end;


function dblDiskSize(Drive: Byte) : Double;
var
  RootPath: array[0..4] of Char;
  RootPtr: PChar;
  SectorsPerCluster,
  BytesPerSector,
  FreeClusters,
  TotalClusters: DWord;
  SPC, BPS, TC : Double;
begin
  RootPtr := nil;

  StrCopy(RootPath, 'A:\');
  RootPath[0] := Chr(Ord('A') + Drive);
  RootPtr := RootPath;

  If GetDiskFreeSpace(RootPtr, SectorsPerCluster, BytesPerSector, FreeClusters, TotalClusters) Then Begin
    SPC := SectorsPerCluster;
    BPS := BytesPerSector;
    TC  := TotalClusters;

    Result := SPC * BPS * TC;
  End { If }
  Else
    { Call failed }
    Result := -1;
end;


{ Returns the Logical Drive Number for the specified Drive Letter }
Function LogicalDriveNo (DriveCh : Char) : Byte;
Begin
  Result := 255;    { Error }

  Try
    { Convert to uppercase }
    DriveCh := UpperCase(DriveCh)[1];

    If (DriveCh In ['A'..'Z']) Then
      Result := Ord(DriveCh) - Ord('A');
  Except
    On Ex:Exception Do
      ;
  End;
End;

{ Checks the passed drive and returns available info }
Function GetDriveInfo (Var DriveInfo : DriveInfoType) : Boolean;
Var
  DriveBits                  : set of 0..25;
  DriveCh                    : Char;
  OldErrorMode               : Integer;
  NotUsed, VolFlags          : DWord;
  pDrive, pVolName, pSysName : PChar;
Begin
  { Convert Drive Letter to uppercase }
  DriveCh := UpperCase(DriveInfo.drDrive)[1];
  pDrive := StrAlloc (100);
  StrPCopy (pDrive, DriveCh + ':\');

  { Initialise the DriveInfo }
  FillChar (DriveInfo, SizeOf(DriveInfo), #0);

  DriveInfo.drDrive := DriveCh;
  DriveInfo.drLogicalNo := LogicalDriveNo (DriveCh);
  Result := (DriveInfo.drLogicalNo In [0..25]);

  If Result Then Begin
    { Valid Drive Letter specified - Check the drive is a valid drive }
    Integer(DriveBits) := GetLogicalDrives;
    Result := (DriveInfo.drLogicalNo In DriveBits);
  End; { If }

  If Result Then Begin
    { Get Type of Drive:- Floppy, CD-ROM, etc }
    DriveInfo.drDriveType := TDriveType(GetDriveType(pDrive));
  End; { If }

  If Result Then Begin
    { Get Volume Information:- File System + Compression }
    OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
    try
      pVolName := StrAlloc (100);
      pSysName := StrAlloc (100);

      If GetVolumeInformation(pDrive,           { Drive }
                              pVolName,         { Volume Name }
                              100,              { Volume Name Length }
                              nil,              { Volume Serial Number }
                              NotUsed,          { Max filename length }
                              VolFlags,         { Volume Flags }
                              pSysName,         { File System Name }
                              100) Then Begin   { File system Name Length }
        { Volume Name }
        DriveInfo.drVolume := StrPas(pVolName);

        { File System Name }
        DriveInfo.drFileSystem := StrPas(pSysName);

        { Case Sensitive }
        DriveInfo.drCaseSensitive := (VolFlags and FS_CASE_SENSITIVE) <> 0;

        { Compressed }
        DriveInfo.drCompressed := (VolFlags and FS_VOL_IS_COMPRESSED) <> 0;

        { Total disk space }
        DriveInfo.drDiskSpace := dblDiskSize(DriveInfo.drLogicalNo);

        { Free Disk Space }
        DriveInfo.drSpaceFree := dblDiskFree(DriveInfo.drLogicalNo);

        DriveInfo.drGotVolInfo := True;
      End; { If }

      StrDispose(pVolName);
      StrDispose(pSysName);
    Finally
      SetErrorMode(OldErrorMode);
    End;
  End; { If }

  StrDispose(pDrive);
End;


{ Checks there is > 1Mb disk space free. Reeturns True if the system can be run }
Function CheckDiskSpace (DirPath, LogPath : ShortString) : Boolean;
Var
  ErrMsg : PChar;
  FS     : Double;
  LD     : Byte;
Begin { CheckDiskSpace }
  Result := True;

  DirPath := UpperCase(Trim(DirPath));

  If (Length(DirPath) >= 2) Then Begin
    { Get drive number }
    LD := LogicalDriveNo (DirPath[1]);

    If (LD In [0..25]) Then Begin
      { Valid Drive No - Check space free }
      FS := dblDiskFree(LD);
      If (FS < SpaceWarning) Then Begin
        ErrMsg := StrAlloc (255);
        StrPCopy (ErrMsg, 'There are only ' + Trim(Format('%20.0n', [FS])) +
                          ' bytes free in the following directory:' +
                          #13#10#13#10 + '"' + Copy(DirPath,1,100) + '"' +
                          #13#10#13#10 + 'Please make more disk space available');
        Application.MessageBox (ErrMsg, 'Low Disk Space', (MB_OK or MB_ICONWARNING));
        StrDispose(ErrMsg);

        Result := DoLogMsg (LogPath,
                            'Directory Check - ' + DirPath,
                            'Low Disk Space',
                            Trim(Format('%20.0n', [FS])) + ' bytes free',
                            '',
                            '');
        If Result Then
          Result := (FS > SpaceThreshold);
      End; { If }
    End; { If }
  End; { If }
End;  { CheckDiskSpace }


{ Checks the user has rights to the directory }
Function CheckDirRights (DirPath, LogPath : ShortString; CheckMode : Byte) : Boolean;
Var
  TestF                  : TextFile;
  ErrMsg                 : PChar;
  FName, FName2, TestStr : ShortString;
  Atts                   : Integer;
  LD                     : Byte;
  Created                : Boolean;


  { Look in directory and generate a unique name - assuming I have rights to look of course }
  Procedure UniqueNames;
  Var
    TmpName  : String[12];
    ThisUser : String[3];
    I       : SmallInt;
  Begin { UniqueName }
    FName := '';

    { HM 04/01/00: Modified as getting too many sharing violations }
    Randomize;
    ThisUser := Format ('%3.3d', [Random(999)]);

    For I := 1 To 9999 Do Begin
      TmpName := 'T' + ThisUser + IntToStr(I) + '.SWP';

      If Not FileExists(DirPath + TmpName) Then Begin
        FName := TmpName;
        Break;
      End; { If }
    End; { For }
  End;  { UniqueName }

Begin { CheckDirRights }
  Result := True;

  DirPath := UpperCase(Trim(DirPath));
  If (DirPath <> '') Then
    If Not (DirPath[Length(DirPath)] In [':', '\']) Then
      DirPath := DirPath + '\';

  If (Length(DirPath) >= 2) Then Begin
    { Get drive number }
    LD := LogicalDriveNo (DirPath[1]);

    If (LD In [0..25]) Then Begin
      { Check directory exists }
      If DirectoryExists (DirPath) Then Begin
        { Valid Drive No - Get directory attributes }
        Atts := FileGetAttr(DirPath);

        If (Atts <> -1) Then Begin
          { Check for Read-Only - you can still write to files in a read-only directory. Weird!!! }
          If ((Atts and faReadOnly) = faReadOnly) Then Begin
            ErrMsg := StrAlloc (255);
            StrPCopy (ErrMsg, 'The directory "' + DirPath + '" is set as Read-Only. Please ' +
                              'remove this attribute as it may cause problems.');
            Application.MessageBox (ErrMsg, 'Directory Attributes', (MB_OK or MB_ICONWARNING));
            StrDispose(ErrMsg);

            {$B+}
            Result := Result And DoLogMsg (LogPath,
                                           'Directory Check - ' + DirPath,
                                           'Directory set as Read-Only', '', '', '');
            {$B-}
          End; { If }

          { Check for hidden - you can still see directories that are hidden. Weird!!! }
          If ((Atts and faHidden) = faHidden) Then Begin
            ErrMsg := StrAlloc (255);
            StrPCopy (ErrMsg, 'The directory "' + DirPath + '" is set as Hidden. Please ' +
                              'remove this attribute as it may cause problems.');
            Application.MessageBox (ErrMsg, 'Directory Attributes', (MB_OK or MB_ICONWARNING));
            StrDispose(ErrMsg);

            {$B+}
            Result := Result And DoLogMsg (LogPath,
                                           'Directory Check - ' + DirPath,
                                           'Directory set as Hidden', '', '', '');
            {$B-}
          End; { If }

          { Check for system - cos simon wants it }
          If ((Atts and faSysFile) = faSysFile) Then Begin
            ErrMsg := StrAlloc (255);
            StrPCopy (ErrMsg, 'The directory "' + DirPath + '" is set as System. Please ' +
                              'remove this attribute as it may cause problems.');
            Application.MessageBox (ErrMsg, 'Directory Attributes', (MB_OK or MB_ICONWARNING));
            StrDispose(ErrMsg);

            {$B+}
            Result := Result And DoLogMsg (LogPath,
                                           'Directory Check - ' + DirPath,
                                           'Directory set as System', '', '', '');
            {$B-}
          End; { If }
        End; { If }

        If (CheckMode = 2) Then Begin
          { Generate unique filename in directory }
          UniqueNames;
          If (FName <> '') Then Begin
            { Create file }
            Created := False;
            Try
              AssignFile (TestF, DirPath + FName);
              Rewrite (TestF);
              Created := True;
              CloseFile (TestF);
            Except
              On Ex:Exception Do Begin
                MessageDlg ('The following exception occurred creating "' + DirPath + FName + '":' +
                            #13#10#13#10 + Ex.Message + #10#13#13#10 +
                            'Please ensure the user has rights to the directory',
                            mtError, [mbOk], 0);

                {$B+}
                Result := Result And DoLogMsg (LogPath,
                                               'Directory Check - ' + DirPath,
                                               'File Creation Check (' + FName + ')',
                                               Ex.Message, '', '');
                {$B-}
              End; { On }
            End;

            If Created Then Begin
              { Open and write to file }
              Try
                AssignFile (TestF, DirPath + FName);
                Rewrite (TestF);
                Try
                  Write (TestF, 'Test File');
                Finally
                  CloseFile (TestF);
                End;
              Except
                On Ex:Exception Do Begin
                  MessageDlg ('The following exception occurred writing to "' + DirPath + FName + '":' +
                              #13#10#13#10 + Ex.Message + #10#13#13#10 +
                              'Please ensure the user has rights to the directory',
                              mtError, [mbOk], 0);

                  {$B+}
                  Result := Result And DoLogMsg (LogPath,
                                                 'Directory Check - ' + DirPath,
                                                 'File Write Check (' + FName + ')', Ex.Message, '', '');
                  {$B-}
                End; { On }
              End;
            End; { If }

            If Created Then Begin
              { Open and read from file }
              Try
                AssignFile (TestF, DirPath + FName);
                Reset (TestF);
                Try
                  Read (TestF, TestStr);
                Finally
                  CloseFile (TestF);
                End;
              Except
                On Ex:Exception Do Begin
                  MessageDlg ('The following exception occurred reading "' + DirPath + FName + '":' +
                              #13#10#13#10 + Ex.Message + #10#13#13#10 +
                              'Please ensure the user has rights to the directory',
                              mtError, [mbOk], 0);

                  {$B+}
                  Result := Result And DoLogMsg (LogPath,
                                                 'Directory Check - ' + DirPath,
                                                 'File Read Check (' + FName + ')', Ex.Message, '', '');
                  {$B-}
                End; { On }
              End;
            End; { If }

            If Created Then Begin
              { Generate filename for rename operation }
              FName2 := FName;
              Fname2[Length(Fname2)] := 'R';

              { rename file }
              If RenameFile(DirPath + FName, DirPath + FName2) Then
                { Renamed OK }
                FName := FName2
              Else Begin
                { Rename failed }
                MessageDlg ('The file "' + DirPath + FName + '" could not be renamed or "' +
                            DirPath + FName2 + '" already exists. Please ensure the user ' +
                            'has rights to the directory and the file doesn''t already exist.',
                            mtError, [mbOk], 0);

                {$B+}
                Result := Result And DoLogMsg (LogPath,
                                               'Directory Check - ' + DirPath,
                                               'File Rename Check (' + FName + ')', '', '', '');
                {$B-}
              End; { Else }
            End; { If }

            If Created Then Begin
              { Delete file }
              ErrMsg := StrAlloc (255);
              StrPCopy (ErrMsg, DirPath + FName);
              If Not DeleteFile(ErrMsg) Then Begin
                MessageDlg ('The file "' + DirPath + FName + '" could not be deleted, ' +
                            'please ensure the user has rights to the directory',
                            mtError, [mbOk], 0);

                {$B+}
                Result := Result And DoLogMsg (LogPath,
                                               'Directory Check - ' + DirPath,
                                               'File Deletion Check (' + FName + ')', '', '', '');
                {$B-}
              End;
              StrDispose(ErrMsg);
            End; { If }
          End { If }
          Else Begin
            { Directory doesn't exist or user doesn't have rights to see it }
            ErrMsg := StrAlloc (255);
            StrPCopy (ErrMsg, 'The directory rights could not be checked because no unique filename ' +
                              'could be generated for "' + DirPath + '".');
            Application.MessageBox (ErrMsg, 'Directory Rights', (MB_OK or MB_ICONWARNING));
            StrDispose(ErrMsg);

            {$B+}
            Result := Result And DoLogMsg (LogPath,
                                           'Directory Check - ' + DirPath,
                                           'Cannot generate unique filename', '', '', '');
            {$B-}
          End; { Else }
        End; { If (CheckMode = 2) }
      End { If }
      Else Begin
        { Directory doesn't exist or user doesn't have rights to see it }
        ErrMsg := StrAlloc (255);
        StrPCopy (ErrMsg, 'The directory "' + DirPath + '" either does not exist, or the ' +
                          'user does not have Access Rights to it. Please check the directory ' +
                          'exists and the user has Create, Erase, Modify, Read, Scan & Write ' +
                          'rights in the directory.');
        Application.MessageBox (ErrMsg, 'Directory Rights', (MB_OK or MB_ICONWARNING));
        StrDispose(ErrMsg);

        {$B+}
        Result := Result And DoLogMsg (LogPath,
                                       'Directory Check - ' + DirPath,
                                       'Missing directory', '', '', '');
        {$B-}
      End; { Else }
    End; { If }
  End; { If }
End;  { CheckDirRights }


{ Returns a string representation of the Drive Type }
Function DriveTypeStr (Const DriveType : TDriveType) : ShortString;
Begin { DriveTypeStr }
  Case DriveType Of
    dtFloppy   : Result := 'Floppy Disk';
    dtFixed    : Result := 'Fixed Disk';
    dtNetwork  : Result := 'Network';
    dtCDROM    : Result := 'CD-ROM';
    dtRAM      : Result := 'RAM-Drive';
  Else
    Result := 'Unknown';
  End; { Case }
End; { DriveTypeStr }


Function CheckForUNCPath : Boolean;
Var
  ExPath         : ShortString;
Begin { CheckForUNCPath }
  ExPath := UpperCase(ExtractFilePath(Application.ExeName));

  { Check for smallest valid path - 'C:\A\' }
  Result := (Length(ExPath) > 4);

  If Result Then Begin
    { OK so far - check for UNC }
    Result := (ExPath[1] In ['A'..'Z']) And (ExPath[2] = ':');
  End; { If Result }
End; { CheckForUNCPath }


Function CheckForUNCPathMsg (Const AppTitle, MsgTitle : ANSIString) : Boolean;
Var
  ErrString      : ANSIString;
  ExPath         : ShortString;
Begin { CheckForUNCPathMsg }
  Result := CheckForUNCPath;

  If (Not Result) Then Begin
    ExPath := UpperCase(ExtractFilePath(Application.ExeName));

    ErrString := AppTitle + ' has been run from an invalid execution path:-' + #13#13 +
                 '"' + ExPath + '"' + #13#13 +
                 AppTitle + ' must be run from a Drive and Path in the format "X:\EXCH\",'#13 +
                 'common to all workstations using ' + AppTitle + '.';

    Application.MessageBox (PChar(ErrString),
                            PChar(MsgTitle),
                            MB_ICONSTOP Or MB_OK);
  End; { If }
End; { CheckForUNCPathMsg }

end.
