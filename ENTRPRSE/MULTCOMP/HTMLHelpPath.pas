unit HTMLHelpPath;

interface

{$IFDEF SETD}
Uses Forms, WiseUtil;

{ Reads the Licence and setups the Module Rights variable within the WISE Script }
Function SCD_SetHTMLPath (var DLLParams: ParamRec): LongBool; StdCall; export;

{ Loads the specified HTML Help Context Id as WISE 9 doesn't apepar to support HTML Help }
Function SCD_LoadHTMLHelpContextId (var DLLParams: ParamRec): LongBool; StdCall; export;
{$ENDIF}

// Returns TRUE if the specified path is on a drive that will require the HTML Help path to be set
Function NeedsHTMLHelpPath (Const AppsDir : ShortString) : Boolean;

Procedure RegisterHTMLHelpPath(Const AppsDir : ShortString);

implementation

Uses Dialogs, Registry, Windows, SysUtils, CompUtil, APIUtil;

//=========================================================================

{$IFDEF SETD}
// Get the directory that SetupWks.Exe is running from and add it into the
// HTML Help Path if it is remote
Function SCD_SetHTMLPath (var DLLParams: ParamRec): LongBool;
Var
  V_MainDir : String;
Begin // SCD_SetHTMLPath
  GetVariable (DLLParams, 'V_LONGMAINDIR', V_MainDir);
  //FixPath (V_MainDir);
  If DirectoryExists(V_MainDir) Then
  Begin
    // Check for remote drives
    If NeedsHTMLHelpPath (V_MainDir) Then
    Begin
      RegisterHTMLHelpPath(V_MainDir);
    End; // If NeedsHTMLHelpPath (V_MainDir)
  End; // If DirectoryExists(V_MainDir)
End; // SCD_SetHTMLPath

//=========================================================================

{ Loads the specified HTML Help Context Id as WISE 9 doesn't apepar to support HTML Help }
Function SCD_LoadHTMLHelpContextId (var DLLParams: ParamRec): LongBool; StdCall; Export;
Var
  V_ContextId, V_HelpFile : ANSIString;
  HelpContext : LongInt;
  hHelp : THandle;
Begin // SCD_LoadHTMLHelpContextId
  // Get help file path/name from calling wise script
  GetVariable (DLLParams, 'HELPFILE', V_HelpFile);

  // Get context id from calling wise script
  GetVariable (DLLParams, 'V_CONTEXTID', V_ContextId);
  HelpContext := StrToIntDef(V_ContextId, -1);

  If FileExists(V_HelpFile) And (HelpContext <> -1) Then
    RunApp(ExtractFilePath(V_HelpFile) + 'HHUtil.Exe /HelpContext:' + IntToStr(HelpContext) + ' /HelpPath:' + V_HelpFile, False);
End; // SCD_LoadHTMLHelpContextId
{$ENDIF}

//=========================================================================

// Returns TRUE if the specified path is on a drive that will require the HTML Help path to be set
Function NeedsHTMLHelpPath (Const AppsDir : ShortString) : Boolean;
Var
  sDrive : ANSIString;
Begin // NeedsHTMLHelpPath
  sDrive := ExtractFileDrive(AppsDir);
  Result := (GetDriveType(PCHAR(sdrive)) = DRIVE_REMOTE);
End; // NeedsHTMLHelpPath

//=========================================================================

Procedure RegisterHTMLHelpPath(Const AppsDir : ShortString);
Var
  oRegistry : TRegistry;
  sHTMLPaths : ANSIString;
Begin // RegisterHTMLHelpPath
  oRegistry := TRegistry.Create;
  Try
    oRegistry.RootKey := HKEY_LOCAL_MACHINE;

    // Open the HTML Help key, creating if necesary
    If oRegistry.OpenKey('SOFTWARE\Microsoft\HTMLHelp\1.x\ItssRestrictions', True) Then
    Begin
      // Get the current setting
      sHTMLPaths := Trim(oRegistry.ReadString('UrlAllowList'));

      // Warn if the string is long as we have no idea what impact a long path has
      If (Length(sHTMLPaths) > 1024) Then ShowMessage('Warning: ItssRestrictions > 1k, please contact your technical support');

      // Check to see whether the path is already present
      If (Pos(UpperCase(AppsDir) + ';', UpperCase(sHTMLPaths)) = 0) Then
      Begin
        // Not present - add it
        If (sHTMLPaths <> '') Then
        Begin
          If (sHTMLPaths[Length(sHTMLPaths)] <> ';') Then
            sHTMLPaths[Length(sHTMLPaths)] := ';';
        End; // If (sOutPutPath <> '')

        sHTMLPaths := sHTMLPaths + IncludeTrailingPathDelimiter(AppsDir) + ';file://' + IncludeTrailingPathDelimiter(AppsDir);

        oRegistry.WriteString('UrlAllowList', sHTMLPaths);
      End; // If (Pos(UpperCase(AppsDir), UpperCase(sHTMLPaths)) = 0)

      oRegistry.CloseKey;
    End // If OpenKey('SOFTWARE\Microsoft\HTMLHelp\1.x\ItssRestrictions', False)
    Else
      { ? } ;
  Finally
    oRegistry.Free;
  End; // Try..Finally
End; // RegisterHTMLHelpPath

//-------------------------------------------------------------------------

end.
