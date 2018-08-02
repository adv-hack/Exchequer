Unit AuditMissing;

Interface

Uses Classes, SysUtils, AuditBase;

Type
  TMissingAudit = Class (TAuditBase)
  Protected
    // NOTE: As there is no data we don't need to implement the Get/Set methods

    // TAuditBase
    Function NeedAuditEntry : Boolean; Override;
    // MH 08/03/2012 v6.10 ABSEXCH-12127: Added Destination flag to WriteAuditData so confidential details
    // can be suppressed if the logging is writing to a plain text .log file instead of the encrypted audit file
    Procedure WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings); Override;
  End; // TTraderAudit

Implementation

Uses AuditIntf, Dialogs;

//=========================================================================

Function TMissingAudit.NeedAuditEntry : Boolean;
Begin // NeedAuditEntry
  Result := Not DirectoryExists(AuditDirectory);
  If Result Then
  Begin
    // Try to create the missing directory
    ForceDirectories (AuditDirectory);
  End // If Result
  Else
  Begin
    // Audit directory OK - check for audit file
    Result := Not FileExists(LiveAuditFilePath);
  End; // Else
End; // NeedAuditEntry

//-------------------------------------------------------------------------

// MH 08/03/2012 v6.10 ABSEXCH-12127: Added Destination flag to WriteAuditData so confidential details
// can be suppressed if the logging is writing to a plain text .log file instead of the encrypted audit file
Procedure TMissingAudit.WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);
Begin // WriteAuditData
  WriteAuditSubTitle (AuditStrings, 'Missing Audit File Created', '');
End; // WriteAuditData

//=========================================================================


End.