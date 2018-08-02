Unit LoggingUtils;

Interface

Uses ADODB;

Type
  // Generic interface for objects which implement a specific import type
  ISQLConversionLogging = Interface
    ['{1145DC93-D16D-44D1-9F62-C187DDB7AFC3}']
    // --- Internal Methods to implement Public Properties ---

    // ------------------ Public Properties ------------------

    // ------------------- Public Methods --------------------

    // Called from outside the data conversion process to log a fatal error
    Procedure FatalError (Const MessageText : ANSIString);

    // Called by the Read Thread to log a Btrieve Error whilst reading the source data
    Procedure BtrieveError (Const SourceRoutine, OperationDescription, CompanyCode, BtrieveFileName : ANSIString; Const ErrorStatus : LongInt);

    // Called from the code to write aq debug message to OutputDebugString
    Procedure DebugMessage (Const SourceRoutine, DebugMessage : ANSIString);

    // Called to log an Exception Message
    Procedure Exception (Const SourceRoutine, OperationDescription, ExceptionMessage : ANSIString);

    // Called to log an Error result when running a SQL Query
    Procedure SQLError (Const SourceRoutine, SQLQuery, DataPacketDumpFile : ANSIString; Const SQLResult : Integer; Const ADOConnection : TADOConnection);

    // Called to log an Exception Message when running a SQL Query
    Procedure SQLException (Const SourceRoutine, SQLQuery, DataPacketDumpFile, ExceptionMessage : ANSIString);

    // Returns the Thread Id as a hex string, if no Id is supplied the current Thread Id will be retrieved
    Function ThreadIdString (Const CurrentThreadId : Integer = 0) : ShortString;

    // Called to log an Exception Message
    Procedure UnknownVariant(Const SourceDataFile, VariantId, DataPacketDumpFile : ShortString);
  End; // ISQLConversionLogging

// Returns a reference to the logging singleton
Function Logging : ISQLConversionLogging;

Implementation

Uses EntLoggerClass, Windows, SysUtils;

Type
  TSQLConversionLogging = Class(TInterfacedObject, ISQLConversionLogging)
  Private
    FDebugLogging : Boolean;

    // Writes the supplied string to OutputDebugString
    Procedure DebugString (Const DebugString : ANSIString);

    Procedure FatalError (Const MessageText : ANSIString);

    // Called by the Read Thread to log a Btrieve Error whilst reading the source data
    Procedure BtrieveError (Const SourceRoutine, OperationDescription, CompanyCode, BtrieveFileName : ANSIString; Const ErrorStatus : LongInt);

    // Called from the code to write aq debug message to OutputDebugString
    Procedure DebugMessage (Const SourceRoutine, DebugMessage : ANSIString);

    // Called to log an Exception Message
    Procedure Exception (Const SourceRoutine, OperationDescription, ExceptionMessage : ANSIString);

    // Called to log an Error result when running a SQL Query
    Procedure SQLError (Const SourceRoutine, SQLQuery, DataPacketDumpFile : ANSIString; Const SQLResult : Integer; Const ADOConnection : TADOConnection);

    // Called to log an Exception Message when running a SQL Query
    Procedure SQLException (Const SourceRoutine, SQLQuery, DataPacketDumpFile, ExceptionMessage : ANSIString);

    // Returns the Thread Id as a hex string, if no Id is supplied the current Thread Id will be retrieved
    Function ThreadIdString (Const CurrentThreadId : Integer = 0) : ShortString;

    // Called to log an Exception Message
    Procedure UnknownVariant(Const SourceDataFile, VariantId, DataPacketDumpFile : ShortString);
  Public
    Constructor Create;

  End; // TSQLConversionLogging

Var
  SQLConversionLoggingIntf : ISQLConversionLogging;
  SQLConversionLoggingObj : TSQLConversionLogging;

//=========================================================================

// Returns a reference to the logging singleton
Function Logging : ISQLConversionLogging;
Begin // Logging
  If (Not Assigned(SQLConversionLoggingObj)) Then
  Begin
    SQLConversionLoggingObj := TSQLConversionLogging.Create;

    // Setup a reference to prevent it auto-destructing
    SQLConversionLoggingIntf := SQLConversionLoggingObj;
  End; // If (Not Assigned(oSQLConversionLogging))

  Result := SQLConversionLoggingIntf;
End; // Logging

//=========================================================================

Constructor TSQLConversionLogging.Create;
Begin // Create
  Inherited Create;

  FDebugLogging := FindCmdLineSwitch('EnableODSLogging', ['/', '\', '-'], True);
End; // Create

//-------------------------------------------------------------------------

// Writes the supplied string to OutputDebugString
Procedure TSQLConversionLogging.DebugString (Const DebugString : ANSIString);
Begin // DebugString
  OutputDebugString (PCHAR(DebugString));
End; // DebugString

//-------------------------------------------------------------------------

Procedure TSQLConversionLogging.FatalError (Const MessageText : ANSIString);
Begin // SectionMessage
  // Log to file
  With TEntBaseLogger.Create ('SQLConvert') Do
  Begin
    Try
      LogError('Fatal Error', MessageText);
    Finally
      Free;
    End; // Try..Finally
  End; // With TEntBaseLogger.Create

  // Log to OutputDebugString - if ODS debug logging is enabled
  If FDebugLogging Then
  Begin
    DebugString ('Fatal Error - ' + MessageText);
  End; // If FDebugLogging
End; // SectionMessage

//-------------------------------------------------------------------------

// Called by the Read Thread to log a Btrieve Error whilst reading the source data
Procedure TSQLConversionLogging.BtrieveError (Const SourceRoutine, OperationDescription, CompanyCode, BtrieveFileName : ANSIString; Const ErrorStatus : LongInt);
Var
  sDebug : ANSIString;
Begin // BtrieveError
  // Log to file
  With TEntBaseLogger.Create ('SQLConvert') Do
  Begin
    Try
      LogError('Btrieve Error ' + IntToStr(ErrorStatus) + ' in file ' + BtrieveFileName, SourceRoutine, OperationDescription, CompanyCode);
    Finally
      Free;
    End; // Try..Finally
  End; // With TEntBaseLogger.Create

  // Log to OutputDebugString - if ODS debug logging is enabled
  If FDebugLogging Then
  Begin
    sDebug := SourceRoutine + ': Btrieve Error ' + IntToStr(ErrorStatus) + ' in file ' + BtrieveFileName;
    If (OperationDescription <> '') Then
       sDebug := sDebug + ' whilst ' + OperationDescription;
    DebugString (sDebug);
  End; // If FDebugLogging
End; // BtrieveError

//-------------------------------------------------------------------------

// Called from the code to write aq debug message to OutputDebugString
Procedure TSQLConversionLogging.DebugMessage (Const SourceRoutine, DebugMessage : ANSIString);
Begin // DebugMessage
  // Log to OutputDebugString - if ODS debug logging is enabled
  If FDebugLogging Then
  Begin
    DebugString (SourceRoutine + ': ' + DebugMessage);
  End; // If FDebugLogging
End; // DebugMessage

//-------------------------------------------------------------------------

// Called to log an Exception Message
Procedure TSQLConversionLogging.Exception (Const SourceRoutine, OperationDescription, ExceptionMessage : ANSIString);
Var
  sDebug : ANSIString;
Begin // Exception
  // Log to file
  With TEntBaseLogger.Create ('SQLConvert') Do
  Begin
    Try
      LogError('Exception: ' + ExceptionMessage, SourceRoutine, OperationDescription);
    Finally
      Free;
    End; // Try..Finally
  End; // With TEntBaseLogger.Create

  // Log to OutputDebugString - if ODS debug logging is enabled
  If FDebugLogging Then
  Begin
    sDebug := SourceRoutine + ': Exception ' + QuotedStr(ExceptionMessage);
    If (OperationDescription <> '') Then
       sDebug := sDebug + ' - ' + OperationDescription;
    DebugString (sDebug);
  End; // If FDebugLogging
End; // Exception

//-------------------------------------------------------------------------

// Called to log an Exception Message
Procedure TSQLConversionLogging.UnknownVariant(Const SourceDataFile, VariantId, DataPacketDumpFile : ShortString);
Begin // UnknownVariant
  // Log to file
  With TEntBaseLogger.Create ('SQLConvert') Do
  Begin
    Try
      LogError('Unknown Variant', VariantId, SourceDataFile, DataPacketDumpFile);
    Finally
      Free;
    End; // Try..Finally
  End; // With TEntBaseLogger.Create

  // Log to OutputDebugString - if ODS debug logging is enabled
  If FDebugLogging Then
  Begin
    DebugString ('Unknown Variant ' + VariantId + ' in ' + SourceDataFile + ' (' + DataPacketDumpFile + ')');
  End; // If FDebugLogging
End; // UnknownVariant

//-------------------------------------------------------------------------

// Called to log an Error result when running a SQL Query
Procedure TSQLConversionLogging.SQLError (Const SourceRoutine, SQLQuery, DataPacketDumpFile : ANSIString; Const SQLResult : Integer; Const ADOConnection : TADOConnection);
Var
  sError : ANSIString;
Begin // SQLError
  // Extract error text from aDO Connection if it exists
  If (ADOConnection.Errors.Count > 0) Then
    sError := ADOConnection.Errors.Item[0].Description
  Else
    sError := '';

  // Log to file
  With TEntBaseLogger.Create ('SQLConvert') Do
  Begin
    Try
      LogError('SQL Error: ' + IntToStr(SQLResult), SQLQuery, sError, DataPacketDumpFile);
    Finally
      Free;
    End; // Try..Finally
  End; // With TEntBaseLogger.Create

  // Log to OutputDebugString - if ODS debug logging is enabled
  If FDebugLogging Then
  Begin
    If (sError <> '') Then
      sError := ' (' + sError + ')';
    DebugString ('Error ' + IntToStr(SQLResult) + sError + ' executing ' + QuotedStr(SQLQuery) + ' (' + DataPacketDumpFile + ')');
  End; // If FDebugLogging
End; // SQLError

//-------------------------------------------------------------------------

// Called to log an Exception Message when running a SQL Query
Procedure TSQLConversionLogging.SQLException (Const SourceRoutine, SQLQuery, DataPacketDumpFile, ExceptionMessage : ANSIString);
Begin // SQLException
  // Log to file
  With TEntBaseLogger.Create ('SQLConvert') Do
  Begin
    Try
      LogError('SQL Exception: ' + ExceptionMessage, SQLQuery, DataPacketDumpFile);
    Finally
      Free;
    End; // Try..Finally
  End; // With TEntBaseLogger.Create

  // Log to OutputDebugString - if ODS debug logging is enabled
  If FDebugLogging Then
  Begin
    DebugString ('Exception ' + QuotedStr(ExceptionMessage) + ' executing ' + QuotedStr(SQLQuery) + ' (' + DataPacketDumpFile + ')');
  End; // If FDebugLogging
End; // SQLException

//-------------------------------------------------------------------------

// Returns the Thread Id as a hex string, if no Id is supplied the current Thread Id will be retrieved
Function TSQLConversionLogging.ThreadIdString (Const CurrentThreadId : Integer = 0) : ShortString;
Begin // ThreadIdString
  If (CurrentThreadId = 0) Then
    Result := Format ('($%x)', [GetCurrentThreadId])
  Else
    Result := Format ('($%x)', [CurrentThreadId]);
End; // ThreadIdString

//-------------------------------------------------------------------------

Initialization
  SQLConversionLoggingIntf := NIL;
  SQLConversionLoggingObj := NIL;
Finalization
  // This should cause it to destroy if no hanging references are in existence
  SQLConversionLoggingIntf := NIL;
  SQLConversionLoggingObj := NIL;
End.