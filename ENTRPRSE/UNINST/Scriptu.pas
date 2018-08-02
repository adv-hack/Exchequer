unit ScriptU;

interface

Uses Classes, Forms, Windows;

Type
  TCmdType = (cmdComment,          { /* }
              cmdDelDir,           { DELDIR dirname }
              cmdDelFiles,         { DELFILES *.* }
              cmdUnRegCOM,         // UnReg Enterprise.COMCustomisation
              cmdNone,
              cmdStop);            { STOP }

  TScriptObj = Class(TObject)
  Private
    FBaseDir       : ShortString;
    FScriptName    : ShortString;
    FStopped       : Boolean;

    FAfterProcess  : TNotifyEvent;
    FBeforeProcess : TNotifyEvent;
  Protected
    OrigDir     : ShortString;
    ScriptLine  : ShortString;
    ScriptF     : TextFile;

    Procedure DelDirectory;
    Procedure DelFiles;
    Function  IdCommand : TCmdType;
    Procedure SetBaseDir(Value : ShortString);
    Procedure SaveDir;
    Procedure RestDir;
    Procedure UnRegisterCOMObject;
  Public
    Constructor Create;

    Function Execute : Boolean;
  Published
    Property BaseDir : ShortString read FBaseDir Write SetBaseDir;
    Property ScriptName : ShortString read FScriptName Write FScriptName;
    Property Stopped : Boolean read FStopped write FStopped;

    Property AfterProcess : TNotifyEvent read FAfterProcess write FAfterProcess;
    Property BeforeProcess : TNotifyEvent read FBeforeProcess write FBeforeProcess;
  End; { TScriptObj }


implementation

Uses Dialogs, fileCtrl, SysUtils, Registry, APIUtil, COMObj;

Const
  { Script Commands }
  CommentStr  = '/*';
  DelDirStr   = 'DELDIR ';
  DelFilesStr = 'DELFILES ';
  StopStr     = 'STOP';
  UnRegComStr = 'UNREG ';

Constructor TScriptObj.Create;
Begin
  Inherited Create;

  { Set default values }
  FBaseDir := ExtractFilePath (Application.ExeName);
  FScriptName := 'EntScrpt.Lst';
  FStopped := False;
End;

{ Ensure the directory path is AOK }
Procedure TScriptObj.SetBaseDir(Value : ShortString);
Begin
  If DirectoryExists(Value) Then Begin
    FBaseDir := Value;
    If (Not (Copy(FBaseDir, Length(FBaseDir), 1)[1] In ['\', ':'])) And (Trim(FBaseDir) <> '') Then
      FBaseDir := FBaseDir + '\';
  End; { If }
End;

{ Save the Current directory and change to the working directory }
Procedure TScriptObj.SaveDir;
Begin
  OrigDir := GetCurrentDir;
  SetCurrentDir (FBaseDir);
End;

{ restore current directory to original }
Procedure TScriptObj.RestDir;
Begin
  SetCurrentDir (OrigDir);
End;

{ restore current directory to original }
Function TScriptObj.IdCommand : TCmdType;
Var
  TempLine : ANSIString;
Begin
  Result := cmdNone;

  { Get temporary copy of scriptline in uppercase         }
  { NOTE: cannot change scriptline because case may be needed }
  TempLine := UpperCase(ScriptLine);

  { Blank Lines }
  If (Trim(TempLine) = '') Then Begin
    Result := cmdNone;
  End; { If }

  { Comment }
  If (Copy(TempLine, 1, Length(CommentStr)) = CommentStr) Then Begin
    Result := cmdComment;
  End; { If }

  { Stop Processing }
  If (Copy(TempLine, 1, Length(StopStr)) = StopStr) Then Begin
    Result := cmdStop;
  End; { If }

  { Delete Files }
  If (Copy(TempLine, 1, Length(DelFilesStr)) = DelFilesStr) And (Length(TempLine) > Length(DelFilesStr)) Then Begin
    Result := cmdDelFiles;
  End; { If }

  { Delete Directory }
  If (Copy(TempLine, 1, Length(DelDirStr)) = DelDirStr) And (Length(TempLine) > Length(DelDirStr)) Then Begin
    Result := cmdDelDir;
  End; { If }

  // Unregister COM Object
  If (Copy(TempLine, 1, Length(UnRegComStr)) = UnRegComStr) And (Length(TempLine) > Length(UnRegComStr)) Then Begin
    Result := cmdUnRegCOM;
  End; { If }
End;

{ Deletes a specified directory }
Procedure TScriptObj.DelDirectory;
Var
  FullPath : ShortString;
Begin
  FullPath := BaseDir + Trim(Copy (ScriptLine, Length (DelDirStr), Length(ScriptLine)));

  If DirectoryExists (FullPath) Then Begin
    Try
      RmDir (FullPath);
    Except
      On Exception Do ;
    End;
  End; { If }
End;

{ Deletes all files in current directory with specified filename }
Procedure TScriptObj.DelFiles;
Var
  FileInfo : TSearchRec;
  FStatus  : SmallInt;
  FullPath : ShortString;
Begin
  FullPath := ExtractFilePath(BaseDir + Trim(Copy (ScriptLine, Length (DelFilesStr), Length(ScriptLine))));

  FStatus := FindFirst(BaseDir + Trim(Copy (ScriptLine, Length (DelFilesStr), Length(ScriptLine))), faDirectory or faHidden or faReadOnly, FileInfo);

  While (FStatus = 0) Do Begin
    If (FileInfo.Name <> '.') And (FileInfo.Name <> '..') Then Begin
      Try
        { Ordinary file - take off any hidden/read only attributes }
        If ((FileInfo.Attr And faHidden) = faHidden) Or
           ((FileInfo.Attr And faReadOnly) = faReadOnly) Then Begin
          { Hidden/Read-Only }
          FileSetAttr (FullPath + FileInfo.Name, 0);
        End; { If }

        { Delete it }
        DeleteFile (FullPath + FileInfo.Name);
      Except
        On Exception Do ;
      End;
    End; { If }

    FStatus := FindNext(FileInfo);
  End; { While }

  FindClose (FileInfo);
End;

//-------------------------------------------------------------------------

// UnReg Enterprise.COMCustomisation
//
// If the specified COM Object is registered to the directory being uninstalled
// then unregister it, otherwise leave it alone
Procedure TScriptObj.UnRegisterCOMObject;
Var
  sClsId, sCOMObj, sCurrDir, sSvrFile, sSvrPath : ShortString;
  oReg    : TRegistry;

  procedure UnregisterComServer(const DLLName: string);
  type
    TRegProc = function: HResult; stdcall;
  const
    RegProcName = 'DllUnregisterServer'; { Do not localize }
  var
    Handle: THandle;
    RegProc: TRegProc;
  begin
    Handle := SafeLoadLibrary(DLLName);
    if Handle <= HINSTANCE_ERROR then
      raise Exception.CreateFmt('%s: %s', [SysErrorMessage(GetLastError), DLLName]);
    try
      RegProc := GetProcAddress(Handle, RegProcName);
      if Assigned(RegProc) then OleCheck(RegProc) else RaiseLastOSError;
    finally
      FreeLibrary(Handle);
    end;
  end;

Begin // UnRegisterCOMObject
  sCOMObj := Trim(Copy (ScriptLine, Length (UnRegComStr), Length(ScriptLine)));

  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_READ;
    oReg.RootKey := HKEY_CLASSES_ROOT;

    { Key exists - Open key and get the CLSID (aka OLE/COM Server GUID) }
    If oReg.OpenKey(sCOMOBj + '\Clsid', False) Then
    Begin
      If oReg.KeyExists('') Then
      Begin
        { CLSID stored in default entry }
        sClsId := oReg.ReadString ('');
        oReg.CloseKey;

        { Got CLSID - find entry in CLSID Section and check registered .EXE/.DLL }
        If oReg.KeyExists ('Clsid\'+sClsId+'\InprocServer32') Then
          sSvrPath := 'Clsid\'+sClsId+'\InprocServer32'
        Else
          If oReg.KeyExists ('Clsid\'+sClsId+'\LocalServer32') Then
            sSvrPath := 'Clsid\'+sClsId+'\LocalServer32'
          Else
            sSvrPath := '';

        If (sSvrPath <> '') Then
        Begin
          { Got Server details - read .EXE/.DLL details and check it exists }
          If oReg.OpenKey(sSvrPath, False) Then
          Begin
            sSvrFile := UpperCase(Trim(oReg.ReadString ('')));

            If FileExists (sSvrFile) Then
            Begin
              // Got File - Check its in current directory
              sSvrPath := UpperCase(Trim(WinGetShortPathName(ExtractFilePath(sSvrFile))));
              sCurrDir := UpperCase(Trim(WinGetShortPathName(ExtractFilePath(Application.ExeName))));

              If (sSvrPath = sCurrDir) Then
              Begin
                If (ExtractFileExt(sSvrFile) = '.EXE') Then
                Begin
                  RunApp (sSvrFile + ' /UNREGSERVER', True);
                End // Else
                Else
                  UnregisterComServer(sSvrFile);
              End; // If (sSvrPath = sCurrDir)
            End; // If FileExists (sSvrPath)
          End; // If oReg.OpenKey(SvrPath, False)
        End; // If (sSvrPath <> '')
      End; // If oReg.KeyExists('')
    End; // If oReg.OpenKey(sCOMOBj + '\Clsid', False)
  Finally
    oReg.Free;
  End; // Try..Finally
End; // UnRegisterCOMObject

//-------------------------------------------------------------------------

{ Process the script }
Function TScriptObj.Execute : Boolean;
Var
  oEntDel : TStringList;
  oCDir : String;
  Stop  : Boolean;
  iLine : SmallInt;
begin
  Result := True;

  SaveDir;

  If FileExists(BaseDir + ScriptName) Then
  Begin
    oEntDel := TStringList.Create;
    Try
      oEntDel.LoadFromFile(BaseDir + ScriptName);

      FStopped := False;

      // Process Script File
      For iLine := 0 To (oEntDel.Count - 1) Do
      Begin
        { Reformat the ScriptLine as necessary }
        ScriptLine := Trim(oEntDel.Strings[iLine]);

        { Execute the before process event handler }
        If Assigned(FBeforeProcess) Then
          FBeforeProcess(Self);

        Case IdCommand Of
          cmdComment  : { No Action Reqired };
          cmdDelDir   : DelDirectory;
          cmdDelFiles : DelFiles;
          cmdUnRegCOM : UnRegisterCOMObject;
          cmdNone     : { No Action Reqired };
          cmdStop     : FStopped := True;
        End; { Case }

        { Execute the after process event handler }
        If Assigned(FAfterProcess) Then
          FAfterProcess(Self);

        If FStopped Then Break;
      End; // For iLine
    Finally
      oEntDel.Free;
    End; // Try..Finally
  End; { If }

  { Restore original current directory }
  SetCurrentDir (oCDir);
end;

end.
