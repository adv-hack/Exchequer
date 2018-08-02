Unit MadExceptSupport;

Interface

{$IFNDEF MADEXCEPT}
  This unit should not be included
{$ENDIF}

Uses MadExcept, SysUtils, Classes, Dialogs, Inifiles;

procedure AddLicenceInfo;
procedure MadExceptLogInfo (const exceptIntf : IMEException; var handled : boolean);
procedure MadExceptHandler(const exceptIntf: IMEException; var handled: boolean);
procedure PrepareErrorList(const InifileName: string);

Var
  // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes
  MadExceptLoggingString : ShortString;
  MadExceptListLogging : Boolean;

Implementation

Uses EntLicence, Windows, Forms;

Var
  FLicencee : ShortString;
  FVersionDesc : ShortString;
  FEdition : ShortString;
  FErrorList: TStringList;

//=========================================================================

procedure AddLicenceInfo;
Begin // AddLicenceInfo
  With EnterpriseLicence Do
  Begin
    FLicencee := elLicencee;
    FVersionDesc := elLongVersionDesc;
    If (elDatabaseType = dbMSSQL) Then
      FEdition := 'SQL Edition'
    Else
      FEdition := 'Pervasive Edition';
  End; // With EnterpriseLicence
End; // AddLicenceInfo

//-------------------------------------------------------------------------

procedure MadExceptLogInfo (const exceptIntf : IMEException; var handled : boolean);
Begin // MadExceptLogInfo
  If (FLicencee <> '') Then
  Begin
    exceptIntf.BugReportHeader.Add('Licencee', FLicencee);
    exceptIntf.BugReportHeader.Add('LicencedVersion', FVersionDesc);
    exceptIntf.BugReportHeader.Add('LicencedEdition', FEdition);
  End; // If (FLicencee <> '')

  // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes
  exceptIntf.BugReportHeader.Add('LoggingString', MadExceptLoggingString);
End; // MadExceptLogInfo

//-------------------------------------------------------------------------

// CJS 14/03/2011 - ABSEXCH-10885 - Extended Error Handling
procedure PrepareErrorList(const InifileName: string);
var
  Inifile: TInifile;
begin
  Inifile := TInifile.Create(InifileName);
  FErrorList.Clear;
  try
    Inifile.ReadSectionValues('HELP', FErrorList);
  finally
    Inifile.Free;
  end;
end;

//-------------------------------------------------------------------------

// CJS 14/03/2011 - ABSEXCH-10885 - Extended Error Handling
procedure MadExceptHandler(const exceptIntf: IMEException; var handled: boolean);
var
  ErrorMsg: string;
  ErrorHelpContext: Integer;
  HelpFileName: string;

  procedure ParseError;
  var
    i: Integer;
    Value: string;
  begin
    // C0000006 = Network error.
    if (Pos('C0000006', ErrorMsg) <> 0) then
    begin
      ErrorMsg := 'A network error has occurred, and communication with the ' +
                  'network has been lost. ' +
                  #13#10#13#10 +
                  'Please contact your technical support for advice and help.';
    end
    else
    begin
      if FErrorList <> nil then
      begin
        // Look for a help context matching the error.
        for i := 0 to FErrorList.Count - 1 do
        begin
          // The Error List entries are in the format "context=identifying text",
          // that is, the key is Help Context ID, and the value is some text
          // which appears in the error message.
          //
          // e.g.
          //   9102=invalid user name
          Value := FErrorList.Values[FErrorList.Names[i]];
          if (Pos(Value, Lowercase(ErrorMsg)) <> 0) then
          begin
            ErrorHelpContext := StrToIntDef(FErrorList.Names[i], 0);
            break;
          end;
        end;
        if (ErrorHelpContext <> 0) then
          ErrorMsg := '';
      end
      else
        // If FErrorList is nil, the error happened either at start-up or at
        // shutdown. Suppress the error message display to allow the default
        // handling of the error.
        ErrorMsg := '';
    end;
  end;

begin
  if GetCurrentThreadID = MainThreadID then
  begin
    // Start by assuming that we don't have extra help available for the error.
    ErrorHelpContext := 0;
    // Extract and parse the error message to find any extra help. If this is
    // found, the ErrorHelpContext variable will have been set.
    ErrorMsg := exceptIntf.ExceptMessage;
    ParseError;
    // If the error message was not blanked by the ParseError function, it
    // means that the network connection was lost, so no Help is available.
    // Display the error message (ParseError will have amended it) instead.
    if (ErrorMsg <> '') then
      MessageDlg(ErrorMsg, mtError, [mbOk], 0);
    // Setting 'handled' to false tells madExcept to display its own dialog, if
    // possible.
    handled := False;
    // If extra help was found, display this as well (the madExcept dialog will
    // appear in front of it).
    if ErrorHelpContext <> 0 then
    begin
      HelpFileName := Application.CurrentHelpFile;
      Application.HelpFile := 'ErrorInfo.chm';
      Application.HelpContext(ErrorHelpContext);
      Application.HelpFile := HelpFileName;
    end;
  end;
end;

//-------------------------------------------------------------------------

Initialization
  FLicencee := '';
  FVersionDesc := '';
  FEdition := '';
  // CJS 14/03/2011 - ABSEXCH-10885 - Extended Error Handling
  FErrorList := TStringList.Create;

  RegisterExceptionHandler(MadExceptLogInfo, stDontSync);
  RegisterExceptionHandler(MadExceptHandler, stTrySyncCallAlways);

  // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes
  MadExceptLoggingString := '-';
  MadExceptListLogging := Not FindCmdLineSwitch ('NoListLogging', ['-', '/', '\'], True);
Finalization
  // CJS 14/03/2011 - ABSEXCH-10885 - Extended Error Handling
  FreeAndNil(FErrorList);

End.



