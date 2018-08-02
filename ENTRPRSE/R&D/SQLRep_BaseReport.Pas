Unit SQLRep_BaseReport;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}
{$WARN SYMBOL_PLATFORM OFF}
Interface

Uses Graphics, SysUtils, ReportU, EntLoggerClass;

Type
  TSQLRep_BaseReport = Object(TGenReport)
  Public
    oReportLogger : TEntSQLReportLogger;

    Constructor Create(AOwner  :  TObject);
    Destructor  Destroy; Virtual;
    Function SQLLoggingArea : String; Virtual;
    Procedure WriteSQLErrorMsg (Const sqlErrorMsg : String);
  End; // TSQLRep_BaseReport

Implementation

//=========================================================================

Constructor TSQLRep_BaseReport.Create(AOwner : TObject);
Begin // Create
  Inherited Create(AOwner);

  bIsSQLReport := True;
  oReportLogger := TEntSQLReportLogger.Create(SQLLoggingArea);
End; // Create

Destructor TSQLRep_BaseReport.Destroy;
Begin // Destroy
  FreeAndNIL(oReportLogger);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TSQLRep_BaseReport.SQLLoggingArea : String;
Begin // SQLLoggingArea
  Raise EAbstractError.Create('SQLLoggingArea Not Implemented');
End; // SQLLoggingArea

//-------------------------------------------------------------------------

// SQL Error - write to report
Procedure TSQLRep_BaseReport.WriteSQLErrorMsg (Const sqlErrorMsg : String);
Begin // WriteSQLErrorMsg
  DefFont (0,[fsBold]);
  // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
  Self.CRLF;
  Self.PrintLeft('Error: ' + sqlErrorMsg, RepFiler1.MarginLeft);
  Self.CRLF;
  Self.CRLF;

  //xd1 - Exception Message
  oReportLogger.LogError('Query Error', sqlErrorMsg);
End; // WriteSQLErrorMsg

//-------------------------------------------------------------------------

End.