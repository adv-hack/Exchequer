Unit AuditBase;
{$WARN SYMBOL_PLATFORM OFF}
Interface

Uses Classes, Windows, AuditIntf, AuditLog;

Type
  // MH 08/03/2012 v6.10 ABSEXCH-12127: Added Destination flag to WriteAuditData so confidential details
  // can be suppressed if the logging is writing to a plain text .log file instead of the encrypted audit file
  TAuditLogDestination = (adAuditTrail, adLogFile);

  //------------------------------

  //
  TAuditBase = Class(TInterfacedObject, IBaseAudit)
  Private
    Function WriteAuditLogFile : LongInt;
  Protected
    Function GetBeforeData : Pointer; Virtual; Abstract;
    Procedure SetBeforeData (Value : Pointer); Virtual; Abstract;
    Function GetAfterData : Pointer; Virtual; Abstract;
    Procedure SetAfterData (Value : Pointer); Virtual; Abstract;

    Function NeedAuditEntry : Boolean; Virtual; Abstract;

    Procedure WriteAuditSubTitle (AuditStrings : TStrings; Const SubTitle, DataSubject : ShortString);
    Procedure WriteChangesHeader (AuditStrings : TStrings); overload;
    Procedure WriteDataChange (AuditStrings : TStrings; Const FieldName, BeforeValue, AfterValue: ShortString); overload;

    //HV 02/02/2018 2017R1 ABSEXCH-19685: Auditing after successfully Anonymising entity
    Procedure WriteChangesHeader(AuditStrings: TStrings; ACaption1, ACaption2: String); overload;
    Procedure WriteDataChange (AuditStrings: TStrings; const AFieldName, AOriginalValue: ShortString); overload;
    
    Procedure ArchiveAudit (AuditLogFile : TAuditLogReaderWriter);  Virtual;
    Procedure WriteAuditHeader (AuditStrings : TStrings);
    // MH 08/03/2012 v6.10 ABSEXCH-12127: Added Destination flag to WriteAuditData so confidential details
    // can be suppressed if the logging is writing to a plain text .log file instead of the encrypted audit file
    Procedure WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);  Virtual; Abstract;
    Procedure WriteAuditFooter (AuditStrings : TStrings);
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Function WriteAuditEntry : LongInt;
  End; // TAuditBase

Implementation

Uses SysUtils, DateUtils, StrUtils, APIUtil,
//     {$IF Defined(ENTER1)} VarConst, {$IFEND}
//     {$IF Defined(OLE)} History, {$IFEND}
     GlobVar;

Var
  // MH 27/05/2015 v7.0.13 ABSEXCH-16325: Removed Auditing from Toolkit DLL / COM Toolkit if
  //                                      flag file is present
  SystemSupportsAuditing : Boolean;

//=========================================================================

Constructor TAuditBase.Create;
Begin // Create
  Inherited Create;

End; // Create

//------------------------------

Destructor TAuditBase.Destroy;
Begin // Destroy

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TAuditBase.WriteAuditHeader (AuditStrings : TStrings);
Begin // WriteAuditHeader
  // Hosting Application --------------------------------------
  AuditStrings.Add (Trim(AuditSystemInformation.asApplicationDescription + ' ' + AuditSystemInformation.asApplicationVersion));

  // Windows User / Workstation -------------------------------
  AuditStrings.Add ('Windows User:   ' + Trim(WinGetUserName) + ' on ' + Trim(WinGetComputerName));

  // Exchequer User (where applicable) ------------------------
  AuditStrings.Add ('Exchequer User: ' + AuditSystemInformation.asExchequerUser);

  // Date / Time ----------------------------------------------
  AuditStrings.Add ('Date/Time:      ' + FormatDateTime ('hh:nn:ss "on" dd/mm/yyyy', Now));
  AuditStrings.Add ('');


(*
IRIS Exchequer v6.7 / COM Toolkit TKCOM-
Windows User:   <UserId> on <Workstation>
Exchequer User: <Exchequer User Id>
Date/Time:      HH:MM:ss on DD/MM/YYYY

Customer Edited - ZZZZ01 - Zebedee Zero Zebra Zulu Systems Ltd

Field                  Original Value                                                 New Field Value
-----                  --------------                                                 ---------------
<Field Description >   <2345678901234567890123456789012345678901234567890123456789>   <2345678901234567890123456789012345678901234567890123456789>
Address Line 1         34 Builder's Crack Lane                                        72 Quick Fumble House
Address Line 2         Scumble                                                        Fumble
Address Line 3         Scumbleshire                                                   Nowtshire
Address Line 4         SC14 4AG                                                       NS34 9RT
Wibble Factor          0.9                                                            3.2

=====================================================================================================================================================
*)

End; // WriteAuditHeader

//-------------------------------------------------------------------------

Procedure TAuditBase.WriteAuditFooter (AuditStrings : TStrings);
Begin // WriteAuditFooter
  AuditStrings.Add ('');
  AuditStrings.Add (StringOfChar ('=', 150));
  AuditStrings.Add ('');
End; // WriteAuditFooter

//-------------------------------------------------------------------------

Procedure TAuditBase.WriteAuditSubTitle (AuditStrings : TStrings; Const SubTitle, DataSubject : ShortString);
Begin // WriteAuditSubTitle
  AuditStrings.Add (SubTitle + IfThen (DataSubject = '', '', ' - ' + DataSubject));
End; // WriteAuditSubTitle

//-------------------------------------------------------------------------

Procedure TAuditBase.WriteChangesHeader (AuditStrings : TStrings);
Begin // WriteChangesHeader
  AuditStrings.Add('');
  AuditStrings.Add('Field                  Original Value                                                 New Field Value');
  AuditStrings.Add('-----                  --------------                                                 ---------------');
End; // WriteChangesHeader

//-------------------------------------------------------------------------

Procedure TAuditBase.WriteDataChange (AuditStrings : TStrings; Const FieldName, BeforeValue, AfterValue: ShortString);
Var
  sLine : ShortString;
Begin // WriteDataChange
  sLine := '####################   ############################################################   ############################################################';

  Move((Trim(FieldName) + StringOfChar(' ', 20))[1], sLine[1], 20);
  Move((Trim(BeforeValue) + StringOfChar(' ', 60))[1], sLine[24], 60);
  Move((Trim(AfterValue) + StringOfChar(' ', 60))[1], sLine[87], 60);

  AuditStrings.Add(sLine);
End; // WriteDataChange

//-------------------------------------------------------------------------

// Creates a log file in the Logs directory in the event of failure to write to the audit log
Function TAuditBase.WriteAuditLogFile : LongInt;
Var
  LogLines : TStringList;

  //------------------------------

  Function GetUniqueLogFileName (CompanyDir : ShortString ) : ShortString;
  Begin // GetUniqueLogFileName
    // Create Logs directory if missing
    CompanyDir := IncludeTrailingPathDelimiter(CompanyDir);
    If (Not DirectoryExists(CompanyDir + 'Logs')) Then
      ForceDirectories (CompanyDir + 'Logs');

    // Generate a unique filename within the directory
    Repeat
      Result := CompanyDir + 'Logs\E' + IntToStr(Random(9999998) + 1) + '.Log';
    Until (Not FileExists(Result));
  End; // GetUniqueLogFileName

  //------------------------------

Begin // WriteAuditLogFile
  Result := 0;

  LogLines := TStringList.Create;
  Try
    // Write standard format header
    LogLines.Add ('Program. Version : ' + AuditSystemInformation.asApplicationVersion);
    LogLines.Add (ParamStr(0));
    LogLines.Add (DateTimeToStr(Now) + '. User : ' + AuditSystemInformation.asExchequerUser + ' Company : ' + AuditSystemInformation.asCompanyName);
    LogLines.Add (StringOfChar('-',80));
    LogLines.Add ('Log Type : Failed to write to audit trail');
    LogLines.Add ('');

    // Write standard format audit entry
    WriteAuditHeader (LogLines);
    // MH 08/03/2012 v6.10 ABSEXCH-12127: Added Destination flag to WriteAuditData so confidential details
    // can be suppressed if the logging is writing to a plain text .log file instead of the encrypted audit file
    WriteAuditData (adLogFile, LogLines);
    WriteAuditFooter (LogLines);

    // Generate unique filename and save
    LogLines.SaveToFile (GetUniqueLogFileName(SetDrive));
  Finally
    FreeAndNIL(LogLines);
  End; // Try..Finally
End; // WriteAuditLogFile

//------------------------------

Procedure  TAuditBase.ArchiveAudit (AuditLogFile : TAuditLogReaderWriter);
Begin // ArchiveAudit
  // Dummy routine to be overridden in descendants that need to archive the audit file
End; // ArchiveAudit

//------------------------------

// -2    Unknown Exception writing log
//  0    AOK
//  1    Unable to read audit log
Function TAuditBase.WriteAuditEntry : LongInt;
Var
  FAuditLogFile : TAuditLogReaderWriter;
  TimeoutAt : TDateTime;
Begin // WriteAuditEntry
  // Check to see if an audit entry is required
  // MH 27/05/2015 v7.0.13 ABSEXCH-16325: Removed Auditing from Toolkit DLL / COM Toolkit if
  //                                      flag file is present
  If SystemSupportsAuditing And NeedAuditEntry Then
  Begin
    // Create an audit log read-write object
    FAuditLogFile := TAuditLogReaderWriter.Create(LiveAuditFilePath);
    Try
      // Loop around trying to lock and update the audit file until it succeeds or reaches the timeout period
      TimeoutAt := IncSecond(Now, 15);
      Repeat
        // Read and lock the audit log to prevent other apps writing to it whilst we are - this will fail if another
        // app is writing to it - hence the timeout loop
        If (FAuditLogFile.ReadAuditLog = 0) Then
        Begin
          // Opened and locked - write the audit details
          ArchiveAudit (FAuditLogFile);
          WriteAuditHeader (FAuditLogFile.AuditStrings);
          // MH 08/03/2012 v6.10 ABSEXCH-12127: Added Destination flag to WriteAuditData so confidential details
          // can be suppressed if the logging is writing to a plain text .log file instead of the encrypted audit file
          WriteAuditData (adAuditTrail, FAuditLogFile.AuditStrings);
          WriteAuditFooter (FAuditLogFile.AuditStrings);

          // Write the audit file and free the lock
          Result := FAuditLogFile.WriteAuditLog;
        End // If (FAuditLogFile.ReadAuditLog = 0)
        Else
          // Unable to read audit log
          Result := 1;
      Until (Result = 0) Or (Now > TimeoutAt);

      If (Result <> 0) Then
      Begin
        // Audit write failed - write log to exchequer logs folder
        Result := WriteAuditLogFile;
      End; // If (Result <> 0)
    Finally
      FAuditLogFile.Free;
    End; // Try..Finally
  End // If SystemSupportsAuditing And NeedAuditEntry
  Else
    Result := 0;
End; // WriteAuditEntry

//=========================================================================

// MH 27/05/2015 v7.0.13 ABSEXCH-16325: Removed Auditing from Toolkit DLL / COM Toolkit if
//                                      flag file is present
{$IF Defined(EXDLL)}
Function CheckForAuditFlagFile : Boolean;
Var
  ModuleNameBuffer : Array [0..255] of char;
  LengthModuleName : Integer;
Begin // CheckForAuditFlagFile
  Result := False;

  // Extract Toolkit Path and Name from Windows
  FillChar(ModuleNameBuffer, SizeOf(ModuleNameBuffer), #0);
  LengthModuleName := GetModuleFileName(HInstance, ModuleNameBuffer, SizeOf(ModuleNameBuffer));
  If (LengthModuleName > 0) Then
    // Check for the file
    Result := FileExists(IncludeTrailingBackslash(ExtractFileDir(ModuleNameBuffer)) + 'EntDll32.NOA');
End; // CheckForAuditFlagFile
{$IFEND}

//=========================================================================

procedure TAuditBase.WriteDataChange(AuditStrings: TStrings; const AFieldName, AOriginalValue: ShortString);
var
  sLine : ShortString;
begin // WriteDataChange
  //Don't change
  sLine := '                                                                                                                                                  ';
  Move((Trim(AFieldName) + StringOfChar(' ', 20))[1], sLine[1], 20);
  Move((Trim(AOriginalValue) + StringOfChar(' ', 100))[1], sLine[24], 100);

  AuditStrings.Add(sLine);
end;

//=========================================================================

procedure TAuditBase.WriteChangesHeader(AuditStrings: TStrings; ACaption1, ACaption2: String);
var
  lTempStr: String;
  i: Integer;
begin
  AuditStrings.Add('');
  lTempStr := '';
  for i := 1 to (23 - (Length(ACaption1))) do
  begin
    lTempStr := lTempStr + ' ';
  end;
  //AuditStrings.Add(aCaption1 + '                  ' + aCaption2);
  AuditStrings.Add(aCaption1 + lTempStr + ACaption2);
  AuditStrings.Add('-----                  --------------');
end;

//=========================================================================

Initialization
  // MH 27/05/2015 v7.0.13 ABSEXCH-16325: Removed Auditing from Toolkit DLL / COM Toolkit if
  //                                      flag file is present
  {$IF Defined(EXDLL)}
    // Check for flag file to disable auditing on startup so we don't get a performance hit
    // whenever a Customer/Consumer/Supplier is updated.
    SystemSupportsAuditing := Not CheckForAuditFlagFile;
  {$ELSE}
    SystemSupportsAuditing := True;
  {$IFEND}
End.
