unit MainF;

{ markd6 14:23 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, FileCtrl, StdCtrls, TEditVal, IniFiles, Mask, ParamO;

type
  CmdType = (cmdUnknown,
             cmdComment,
             cmdCopyFiles,
             cmdRunFile);

  TfrmUpdateEng = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Timer1: TTimer;
    lstProgress: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    IniF, InitF  : TIniFile;
    Check4LSTs   : Boolean;
    FirstTime    : Boolean;
    GlobWantCopy : Byte;       { 0=Check, 1=Copy, 2=Abort }
    LstName      : ShortString;
    ParamParser  : TParamParser;

    Function CheckFile (Const NetDir, LocalDir, FName : ShortString;
                        Const WantOvr, WantSub        : Boolean) : Boolean;
    Function  IdCommand (Const ScriptLine : ShortString)  : CmdType;
    Function  IsWinNT : Boolean;
    Function  NeedUpdate(Const NetFName, LclFName : ShortString) : Boolean;
    Function  RunFile(Const RunPath, CmdLine : ShortString) : Boolean;
    Procedure W95_AddIniEntry(SrcF, DestF : ANSIString);
    Procedure WNT_AddIniEntry(SrcF, DestF : ANSIString);

    Procedure ProcessLSTFile (Const LstF : String);
    Procedure SetParams(Const CmdLine : ANSIString);
  protected
  public
    NeedReboot : Boolean;
    LocalDir : String;
    NetworkDir : String;
  end;

Var
  frmUpdateEng    : TfrmUpdateEng;


implementation

{$R *.DFM}

Uses DiskUtil, History, StrUtil, ExchequerRelease;

{---------------------------------------------------------------------------}

{ Initialise local variables }
procedure TfrmUpdateEng.FormCreate(Sender: TObject);
Var
  Parm : ShortString;
  I    : Byte;
begin
  { Init variables }
  FirstTime := True;
  GlobWantCopy := 0;
  LstName := 'EntWRepl.Lst';
  Check4LSTs := True;
  ParamParser := Nil;
  NeedReboot := False;
  NetworkDir := '';

  { Analyze parameters }
  If (ParamCount > 0) Then Begin
    For I := 1 To ParamCount Do Begin
      Parm := Uppercase(Trim(ParamStr(I)));

      If (Parm = '/AUTO') Then Begin
        GlobWantCopy := 1;  { Copy files }
      End; { If }

      If (Copy (Parm, 1, 5) = '/LST:') Then Begin
        { Alternate list file }
        Delete (Parm, 1, 5);
        LstName := Parm;
        Check4LSTs := False;
      End; { If /LST: }    
    End; { For }
  End; { If }

  { Set window title to application title }
  Caption := Application.Title;

  lstProgress.Items.Clear;
  lstProgress.Items.Add(ExchequerReleaseName + ' Update Engine Build ' + EntRegVerNo);
  lstProgress.Items.Add(GetCopyrightMessage);
  lstProgress.Items.Add('All rights reserved');
  lstProgress.Items.Add('');

  { Open .INI file }
  IniF := TIniFile.Create (ChangeFileExt(Application.ExeName, '.INI'));
  InitF := Nil;

  //
  // NOTE: Doesn't use branding files as it is responsible for copying them down to the
  //       workstation so it gets a bit "chicken and egg"-y
  //
end;

{---------------------------------------------------------------------------}

procedure TfrmUpdateEng.FormDestroy(Sender: TObject);
begin
  // Destroy Parameter parser if created
  If Assigned(ParamParser) Then
    ParamParser.Destroy;

  { Destroy .INI file interface }
  IniF.Destroy;

  { Destroy interface to Win95 WinInit.Ini file if setup }
  If Assigned(InitF) Then
    InitF.Destroy;
end;

{---------------------------------------------------------------------------}

procedure TfrmUpdateEng.FormActivate(Sender: TObject);
begin
  If FirstTime Then Begin
    FirstTime := False;

    Refresh;

    Timer1.Enabled := True;
  End; { If }
end;

{---------------------------------------------------------------------------}

Procedure TfrmUpdateEng.SetParams(Const CmdLine : ANSIString);
Var
  CommLine             : String;
  BrackPos1, BrackPos2 : Integer;
Begin { SetParams }
  If (Not Assigned(ParamParser)) Then
    ParamParser := TParamParser.Create('');

  If Assigned(ParamParser) Then Begin
    CommLine := '';

    { Translate Command Line }
    BrackPos1 := Pos ('(', CmdLine);
    BrackPos2 := Pos (')', CmdLine);

    { Check to see if we've got all the brackets and the positions are feasible }
    If (BrackPos1 > 3) And (BrackPos2 > (BrackPos1 + 1)) Then Begin
      { Get Parameter }
      CommLine := Trim(Copy (CmdLine, BrackPos1 + 1, BrackPos2 - BrackPos1 - 1));
    End; { If }

    ParamParser.ParamStr := CommLine;
  End; { If }
End; { SetParams }

{---------------------------------------------------------------------------}

Procedure TfrmUpdateEng.ProcessLSTFile (Const LstF : String);
Var
  Param1           : ShortString;
  WantOVR, WantSub : Boolean;
  ReplList         : TStringList;
  I                : SmallInt;
Begin { ProcessLSTFile }
  { Check for replication list on network }
  If FileExists(NetworkDir + LstF) Then Begin
    // Create StringList to store .LST file commands
    ReplList := TStringList.Create;
    Try
      // Load .LST file
      ReplList.LoadFromFile (NetworkDir + LstF);

      If (ReplList.Count > 0) Then Begin
        { Process instructions }
        For I := 0 To Pred(ReplList.Count) Do Begin
          Case IdCommand (ReplList[I]) Of
            cmdUnknown    : ;

            cmdComment    : ;

            { Copy a set of files }
            cmdCopyFiles  : Begin
                              SetParams (ReplList[I]);

                              { Get Files= parameter }
                              Param1 := ParamParser.GetParamStr ('Files');
                              If (Param1 <> '') Then Begin
                                { Check 'Overwrite Existing Files' parameter }
                                WantOVR := ParamParser.GetParamBool ('Ovr', True);

                                { Check 'Copy Subdirectory' parameter }
                                WantSub := ParamParser.GetParamBool ('SubD', False);

                                {$B+}
                                NeedReboot := NeedReboot Or CheckFile (NetworkDir, LocalDir, Param1, WantOvr, WantSub);
                                {$B-}
                              End; { If }
                            End;

            { Run a file in the local directory }
            cmdRunFile    : Begin
                              SetParams (ReplList[I]);

                              { Get Files= parameter }
                              Param1 := ParamParser.GetParamStr ('Cmd');
                              If (Param1 <> '') Then Begin
                                RunFile(LocalDir, Param1);
                              End; { If }
                            End;
          End; { Case }

          Application.ProcessMessages;

          If (GlobWantCopy = 2) Then Begin
            { User said not to copy files }
            Break;
          End; { If (GlobWantCopy = 2) }
        End; { For I }
      End; { If (ReplList.Count > 0) }
    Finally
      ReplList.Destroy;
    End;
  End; { If FileExists(NetDir + LstF) }
End; { ProcessLSTFile }

{---------------------------------------------------------------------------}

procedure TfrmUpdateEng.Timer1Timer(Sender: TObject);
Var
  ReplFiles : TStringList;
  I         : SmallInt;
begin
  Timer1.Enabled := False;

  lstProgress.Items.Add('Checking Network Directory for updated files...');

  { Get and check network dir }
  NetworkDir := UpperCase(Trim(IniF.ReadString('UpdateEngine', 'NetworkDir', '')));
  LocalDir := UpperCase(Trim(ExtractFilePath(Application.ExeName)));
  LocalDir := UpperCase(Trim(IniF.ReadString('UpdateEngine', 'LocalDir', LocalDir)));
  If (Length(NetworkDir) > 0) Then
    { Check it ends in a backslash }
    NetworkDir := IncludeTrailingBackslash(NetworkDir);

  { Check path is set }
  If (NetworkDir <> '') Then Begin
    { Check directory is valid }
    If CheckDirRights (NetworkDir, '', 1) Then Begin
      { Check the Update Engine itself is up-to-date }
//      NeedReboot := CheckFile (NetworkDir, LocalDir, ExtractFileName(Application.ExeName), True, False);
      NeedReboot := FALSE;

      { If need to reboot to install update engine then don't bother with other files yet }
      If (Not NeedReboot) Then Begin
        // Process main .LST Gile
        ProcessLSTFile(LstName);

        If Check4LSTs Then Begin
          { Check ReplFile.Lst for additional replication files }
          If FileExists (NetworkDir + 'ReplFile.Lst') Then Begin
            // use stringlist to load file
            ReplFiles := TStringList.Create;
            Try
              // remove any duplicate entries from list as it loads
              ReplFiles.Sorted := True;
              ReplFiles.Duplicates := dupIgnore;
              ReplFiles.LoadFromFile (NetworkDir + 'ReplFile.Lst');

              If (ReplFiles.Count > 0) Then
                For I := 0 To Pred(ReplFiles.Count) Do Begin
                  // process the list file
                  ProcessLSTFile(ReplFiles[I]);
                End; { For I }
            Finally
              ReplFiles.Destroy;
            End;
          End; { If FileExists (NetworkDir + 'ReplFile.Lst') }
        End; { If Check4LSTs }
      End; { If }

      If NeedReboot Then Begin
        { A file is being copied during startup - ask user to reboot }
        MessageDlg ('Some files were already in use and couldn''t be copied, ' +
                    'please restart your computer and they will be copied ' +
                    'whilst Windows starts up.', mtWarning, [mbOk], 0);
      End; { If }

      If (Not FindCmdLineSwitch ('pause', ['/', '-'], True)) Then
        PostMessage (Self.Handle, WM_CLOSE, 0, 0);
    End; { If }
  End { If }
  Else Begin
    { Network directory path isn't set }
    MessageDlg ('The Exchequer Network Directory is not set or is set incorrectly', mtError, [mbOk], 0);
  End; { Else }
end;

{---------------------------------------------------------------------------}

{ Checks for the specified file in both local and network drives and }
{ compares them and updates the local machine where necessary        }
function TfrmUpdateEng.CheckFile (Const NetDir, LocalDir, FName : ShortString;
                                  Const WantOvr, WantSub        : Boolean) : Boolean;
Var
  NetFInfo, LclFInfo        : TSearchRec;
  SrchRes, FAttr            : Integer;
  SubDirName,
  DestName, DestDir, SrcDir : ShortString;
  WantCopy                  : Boolean;
  cpFromFile, cpToFile      : ANSIString;
  I                         : Smallint;
Begin
  Result := False;

  { Calculate True directory paths }
  SrcDir  := ExtractFilePath (NetDir + FName);
  DestDir := ExtractFilePath (LocalDir + FName);

  { Check Network Directory exists }
  If DirectoryExists (SrcDir) Then Begin
    If Not DirectoryExists (DestDir) Then Begin
      { Ensure local directory exists }
      ForceDirectories(DestDir);
    End; { If }

    If DirectoryExists (DestDir) Then Begin
      { check 1+ files exist on network with matching name (including wildcards) }
      SrchRes := FindFirst(NetDir + FName, faAnyFile, NetFInfo);
      While (SrchRes = 0) Do Begin
        If ((NetFInfo.Attr And faDirectory) <> faDirectory) Then Begin
          { Not a subdirectory }
          lstProgress.Items.Add ('  ' + UpperCase(NetFInfo.Name));
          lstProgress.ItemIndex := Pred(lstProgress.Items.Count);
          lstProgress.Refresh;

          { Check to see if a local file exists }
          If FileExists(DestDir + NetFInfo.Name) Then Begin
            { Check to see if file should be overwritten }
            WantCopy := WantOvr And NeedUpdate(SrcDir + NetFInfo.Name, DestDir + NetFInfo.Name);

            If WantCopy Then Begin
              { Remove any file attributes that may cause a problem }
              FAttr := FileGetAttr(DestDir + NetFInfo.Name);
              If (FAttr <> -1) Then Begin
                { Got file attributes - reset }
                FAttr := FileSetAttr (DestDir + NetFInfo.Name, 0);
              End; { If }
            End; { If }
          End { If }
          Else
            WantCopy := True;

          If WantCopy And (GlobWantCopy = 0) Then Begin
            { Ask if user wants to copy files }
            If (MessageDlg ('Your Exchequer Program Files need to be updated. Do you want to update them from ' +
                            'the network copy of Exchequer now?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
              GlobWantCopy := 1
            Else Begin
              GlobWantCopy := 2;
              WantCopy := False;
            End; { Else }
          End; { If Result And (GlobWantCopy = 0) }
        End { If }
        Else Begin
          { Subdirectory }
          WantCopy := False;
          If WantSub And (NetFInfo.Name <> '.') And (NetFInfo.Name <> '..') Then Begin
            { Valid Directory - need to call function recursivly to copy subdirectories }
            SubDirName := SrcDir + NetFInfo.Name + '\*.*';
            Delete (SubDirName, 1, Length(NetDir));

            Result := CheckFile (NetDir, LocalDir, SubDirName, WantOvr, WantSub);
          End; { If }
        End; { Else }

        If WantCopy Then Begin
          lstProgress.Items[Pred(lstProgress.Items.Count)] := lstProgress.Items[Pred(lstProgress.Items.Count)] + #9'Updated';
          lstProgress.ItemIndex := Pred(lstProgress.Items.Count);
          lstProgress.Refresh;

          { Copy file across }
          cpFromFile := SrcDir + NetFInfo.Name;
          cpToFile := DestDir + NetFInfo.Name;
          If Not CopyFile(PCHAR(cpFromFile), PCHAR(cpToFile), False) Then Begin
            { Copy failed - copy to local file with unique name and tell windows to do during restart }
            I := 1;
            DestName := NetFInfo.Name;
            While FileExists (DestDir + DestName) And (I < 999) Do Begin
              DestName := ChangeFileExt (DestName, '.' + IntToStr(I));

              Inc(I);
            End; { While }

            cpFromFile := SrcDir + NetFInfo.Name;
            cpToFile := DestDir + DestName;
            If CopyFile(PCHAR(cpFromFile), PCHAR(cpToFile), False) Then Begin
              { Temporary file is in place }
              If IsWinNT Then Begin
                { Windows NT - use MoveFileEx to setup }
                WNT_AddIniEntry(DestDir + DestName, DestDir + NetFInfo.Name);
              End { If }
              Else Begin
                { Windows 95 - Add into WinInit.Ini }
                W95_AddIniEntry(DestDir + DestName, DestDir + NetFInfo.Name);
              End; { Else }
            End { If }
            Else Begin
              { Error copying in temporary file }
              lstProgress.Items[Pred(lstProgress.Items.Count)] := lstProgress.Items[Pred(lstProgress.Items.Count)] + #9'Failed';
              lstProgress.ItemIndex := Pred(lstProgress.Items.Count);
              lstProgress.Refresh;
            End; { Else }

            { File is being copied during Windows Startup }
            Result := True;
          End; { If }
        End { If }
        Else Begin
          lstProgress.Items[Pred(lstProgress.Items.Count)] := lstProgress.Items[Pred(lstProgress.Items.Count)] + #9'OK';
          lstProgress.ItemIndex := Pred(lstProgress.Items.Count);
          lstProgress.Refresh;
        End; { If }

        SrchRes := FindNext(NetFInfo);

        Application.ProcessMessages;
      End; { While }
    End { If }
    Else Begin
      { Local directory doesn't exist and couldn't be created }

    End; { Else }
  End; { If }
End;

{---------------------------------------------------------------------------}

{ Returns True if OS is Win NT }
Function TfrmUpdateEng.IsWinNT : Boolean;
Var
  OSVersionInfo: TOSVersionInfo;
Begin { IsWinNT }
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);

  If GetVersionEx(OSVersionInfo) Then
    Result := (OSVersionInfo.dwPlatformId = 2)
  Else
    Result := False;
End;  { IsWinNT }

{---------------------------------------------------------------------------}

{ Adds an entry to Win95's WinInit.Ini file for copying files during startup }
Procedure TfrmUpdateEng.W95_AddIniEntry(SrcF, DestF : ANSIString);
Var
  Src, Dst : Array [0..255] Of Char;
Begin { W95_AddIniEntry }
  If Not Assigned(InitF) Then Begin
    { Create Interface }
    InitF := TIniFile.Create('WinInit.Ini');
  End; { If }

  FillChar (Src, SizeOf(Src), #0);
  FillChar (Dst, SizeOf(Dst), #0);

  GetShortPathName(PCHAR(SrcF), Src, 255);
  GetShortPathName(PCHAR(DestF), Dst, 255);

  InitF.WriteString ('Rename', Dst, Src);
End;  { W95_AddIniEntry }

{---------------------------------------------------------------------------}

{ Adds an entry to Win95's WinInit.Ini file for copying files during startup }
Procedure TfrmUpdateEng.WNT_AddIniEntry(SrcF, DestF : ANSIString);
Begin { WNT_AddIniEntry }
  MoveFileEx(PCHAR(SrcF), PCHAR(DestF), MOVEFILE_DELAY_UNTIL_REBOOT Or MOVEFILE_REPLACE_EXISTING);
End;  { WNT_AddIniEntry }

{---------------------------------------------------------------------------}

{ Identifies the command in the string }
Function TfrmUpdateEng.IdCommand (Const ScriptLine : ShortString)  : CmdType;
Const
  { Script Commands }
  CommentStr = '/*';
  CopyStr    = 'COPY';
  RunFileStr = 'RUN';
Var
  TempLine : ShortString;
Begin
  { Get temporary copy of scriptline in uppercase         }
  TempLine := UpperCase(Trim(ScriptLine));

  { Set default result }
  Result := cmdUnknown;

  { Comment }
  If (Copy(TempLine, 1, Length(CommentStr)) = CommentStr) Then Begin
    Result := cmdComment;
  End; { If }

  { Copy }
  If (Copy(TempLine, 1, Length(CopyStr)) = CopyStr) Then Begin
    Result := cmdCopyFiles;
  End; { If }

  { Run File }
  If (Copy(TempLine, 1, Length(RunFileStr)) = RunFileStr) Then Begin
    Result := cmdRunFile;
  End; { If }
End;

{---------------------------------------------------------------------------}

{ Returns True if the local file need to be updated with the network file }
Function TfrmUpdateEng.NeedUpdate (Const NetFName, LclFName : ShortString) : Boolean;
Begin { NeedUpdate }
  Result := False;

  { Check network file exists }
  If FileExists(NetFName) Then Begin
    { Check local file exists - I know we have already done this, but VB taught me to program really defensively }
    If FileExists(LclFName) Then Begin
      { Get files date }
      Result := (FileAge(NetFName) <> FileAge(LclFName));
    End { If }
    Else
      Result := True;
  End; { If }
End;  { NeedUpdate }

{---------------------------------------------------------------------------}

{ Runs a specified file }
Function TfrmUpdateEng.RunFile(Const RunPath, CmdLine : ShortString) : Boolean;
Var
  CmdPath : ANSIString;
Begin
  lstProgress.Items.Add ('  Running ' + CmdLine);
  lstProgress.ItemIndex := Pred(lstProgress.Items.Count);
  lstProgress.Refresh;

  { Run Command Line }
  CmdPath := RunPath + CmdLine;
  Result := (WinExec (PCHAR(CmdPath), SW_SHOWNORMAL) > 31);
End;

{---------------------------------------------------------------------------}


end.
