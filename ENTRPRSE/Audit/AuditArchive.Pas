Unit AuditArchive;

Interface

Uses Classes, SysUtils, AuditBase, AuditLog;

Type
  TAuditArchive = Class (TAuditBase)
  Private
    FArchiveTime : TDateTime;
    FArchiveFileName : ShortString;
  Protected
    // NOTE: As there is no data we don't need to implement the Get/Set methods

    // TAuditBase
    Function NeedAuditEntry : Boolean; Override;
    Procedure ArchiveAudit (AuditLogFile : TAuditLogReaderWriter);  Override;
    // MH 08/03/2012 v6.10 ABSEXCH-12127: Added Destination flag to WriteAuditData so confidential details
    // can be suppressed if the logging is writing to a plain text .log file instead of the encrypted audit file
    Procedure WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings); Override;
  End; // TAuditArchive

Implementation

Uses AuditIntf, Dialogs;

//=========================================================================

Function TAuditArchive.NeedAuditEntry : Boolean;
Begin // NeedAuditEntry
  Result := True;
End; // NeedAuditEntry

//-------------------------------------------------------------------------

Procedure TAuditArchive.ArchiveAudit (AuditLogFile : TAuditLogReaderWriter);
Var
  AuditLogReaderWriter : TAuditLogReaderWriter;
  Res : LongInt;
Begin // ArchiveAudit
  // generate a new unique audit archive filename
  Repeat
    FArchiveTime := Now;
    FArchiveFileName := AuditDirectory + FormatDateTime ('yyyymmdd-hhnnss', FArchiveTime) + AuditFileExtension;
  Until Not FileExists(FArchiveFileName);

  // Copy the current live audit into an archive file
  AuditLogReaderWriter := TAuditLogReaderWriter.Create (FArchiveFileName);
  Try
    // Read and lock the audit log to prevent other apps writing to it whilst we are - this will fail if another
    // app is writing to it - hence the timeout loop
    If (AuditLogReaderWriter.ReadAuditLog = 0) Then
    Begin
      // Opened and locked - copy in the details from the live log
      AuditLogReaderWriter.AuditStrings.Assign(AuditLogFile.AuditStrings);

      // Write the archive audit file
      Res := AuditLogReaderWriter.WriteAuditLog;
    End // If (FAuditLogFile.ReadAuditLog = 0)
    Else
      // Unable to read audit log
      Res := 1;

    If (Res = 0) Then
    Begin
      // Clear down the current live audit
      Res := AuditLogFile.Archive;
    End; // If (Result = 0)

    If (Res <> 0) Then
      MessageDlg('An error ' + IntToStr(Res)  + ' occurred whilst trying to archive the live audit trail', mtError, [mbOK], 0);
  Finally
    AuditLogReaderWriter.Free;
  End; // Try..Finally
End; // ArchiveAudit

//-------------------------------------------------------------------------

// MH 08/03/2012 v6.10 ABSEXCH-12127: Added Destination flag to WriteAuditData so confidential details
// can be suppressed if the logging is writing to a plain text .log file instead of the encrypted audit file
Procedure TAuditArchive.WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);
Begin // WriteAuditData
  WriteAuditSubTitle (AuditStrings, 'Audit Archive Created - ' + FArchiveFileName, '');
End; // WriteAuditData

//=========================================================================


End.