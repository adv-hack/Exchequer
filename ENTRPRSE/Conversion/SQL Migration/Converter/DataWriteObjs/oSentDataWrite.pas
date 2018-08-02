Unit oSentDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TSentDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    elNotUsedParam, elUserIDParam, elNameParam, elTypeParam, elPriorityParam, 
    elWindowIDParam, elHandlerIDParam, elTermCharParam, elDescriptionParam, 
    elActiveParam, elTimeTypeParam, elFrequencyParam, elTime1Param, elTime2Param, 
    elDaysOfWeekParam, elFilenoParam, elIndexNoParam, elRangeStartEgTypeParam, 
    elRangeStartEgStringParam, elRangeStartEgIntParam, elRangeStartEgOffsetParam, 
    elRangeStartEgInputParam, elRangeStartSpareParam, elRangeEndEgTypeParam, 
    elRangeEndEgStringParam, elRangeEndEgIntParam, elRangeEndEgOffsetParam, 
    elRangeEndEgInputParam, elRangeEndSpareParam, elEmailParam, elSMSParam, 
    elReportParam, elCSVParam, elRepEmailParam, elRepFaxParam, elRepPrinterParam, 
    elSpareParam, elExpirationParam, elExpirationDateParam, elRepeatPeriodParam, 
    elRepeatDataParam, elEmailReportParam, elLastDateRunParam, elNextRunDueParam, 
    elReportNameParam, elEventIndexParam, elRunOnStartupParam, elEmailCSVParam, 
    elStatusParam, elParentParam, elStartDateParam, elDeleteOnExpiryParam, 
    elPeriodicParam, elTriggerCountParam, elDaysBetweenParam, elExpiredParam, 
    elRunNowParam, elInstanceParam, elMsgInstanceParam, elSingleEmailParam, 
    elPrevStatusParam, elSingleSMSParam, elTriggeredParam, elSMSTriesParam, 
    elEmailTriesParam, elSendDocParam, elDocNameParam, elSMSRetriesNotifiedParam, 
    elEmailRetriesNotifiedParam, elEmailErrorNoParam, elSMSErrorNoParam, 
    elRepFileParam, elFaxCoverParam, elFaxTriesParam, elPrintTriesParam, 
    elFaxPriorityParam, elHasConditionsParam, elRepFolderParam, elFTPSiteParam, 
    elFTPUserNameParam, elFTPPasswordParam, elFTPPortParam, elCSVByEmailParam, 
    elCSVByFTPParam, elCSVToFolderParam, elUploadDirParam, elCSVFileNameParam, 
    elFTPTriesParam, elFTPTimeoutParam, elCSVFileRenamedParam, elFTPRetriesNotifiedParam, 
    elFaxRetriesNotifiedParam, elCompressReportParam, elRpAttachMethodParam, 
    elWorkStationParam, elWordWrapParam, elSysMessageParam, elDBFParam, 
    elQueueCounterParam, elHoursBeforeNotifyParam, elQueryStartParam, elExRepFormatParam, 
    elRecipNoParam, elNewReportParam, elNewReportNameParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TSentDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, VarConst;


{$I w:\entrprse\sentmail\sentinel\sentstructures.inc}

//=========================================================================

Constructor TSentDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TSentDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TSentDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].Sent (' + 
                                           'elNotUsed, ' + 
                                           'elUserID, ' + 
                                           'elName, ' + 
                                           'elType, ' + 
                                           'elPriority, ' + 
                                           'elWindowID, ' + 
                                           'elHandlerID, ' + 
                                           'elTermChar, ' + 
                                           'elDescription, ' + 
                                           'elActive, ' + 
                                           'elTimeType, ' + 
                                           'elFrequency, ' + 
                                           'elTime1, ' + 
                                           'elTime2, ' + 
                                           'elDaysOfWeek, ' + 
                                           'elFileno, ' + 
                                           'elIndexNo, ' + 
                                           'elRangeStartEgType, ' + 
                                           'elRangeStartEgString, ' + 
                                           'elRangeStartEgInt, ' + 
                                           'elRangeStartEgOffset, ' + 
                                           'elRangeStartEgInput, ' + 
                                           'elRangeStartSpare, ' + 
                                           'elRangeEndEgType, ' + 
                                           'elRangeEndEgString, ' + 
                                           'elRangeEndEgInt, ' + 
                                           'elRangeEndEgOffset, ' + 
                                           'elRangeEndEgInput, ' + 
                                           'elRangeEndSpare, ' + 
                                           'elEmail, ' + 
                                           'elSMS, ' + 
                                           'elReport, ' + 
                                           'elCSV, ' + 
                                           'elRepEmail, ' +
                                           'elRepFax, ' + 
                                           'elRepPrinter, ' + 
                                           'elSpare, ' + 
                                           'elExpiration, ' + 
                                           'elExpirationDate, ' + 
                                           'elRepeatPeriod, ' + 
                                           'elRepeatData, ' + 
                                           'elEmailReport, ' + 
                                           'elLastDateRun, ' + 
                                           'elNextRunDue, ' + 
                                           'elReportName, ' + 
                                           'elEventIndex, ' + 
                                           'elRunOnStartup, ' + 
                                           'elEmailCSV, ' + 
                                           'elStatus, ' + 
                                           'elParent, ' + 
                                           'elStartDate, ' + 
                                           'elDeleteOnExpiry, ' + 
                                           'elPeriodic, ' + 
                                           'elTriggerCount, ' + 
                                           'elDaysBetween, ' + 
                                           'elExpired, ' + 
                                           'elRunNow, ' + 
                                           'elInstance, ' + 
                                           'elMsgInstance, ' + 
                                           'elSingleEmail, ' + 
                                           'elPrevStatus, ' + 
                                           'elSingleSMS, ' + 
                                           'elTriggered, ' + 
                                           'elSMSTries, ' + 
                                           'elEmailTries, ' + 
                                           'elSendDoc, ' + 
                                           'elDocName, ' + 
                                           'elSMSRetriesNotified, ' + 
                                           'elEmailRetriesNotified, ' + 
                                           'elEmailErrorNo, ' + 
                                           'elSMSErrorNo, ' + 
                                           'elRepFile, ' + 
                                           'elFaxCover, ' + 
                                           'elFaxTries, ' + 
                                           'elPrintTries, ' +
                                           'elFaxPriority, ' + 
                                           'elHasConditions, ' + 
                                           'elRepFolder, ' + 
                                           'elFTPSite, ' + 
                                           'elFTPUserName, ' + 
                                           'elFTPPassword, ' + 
                                           'elFTPPort, ' + 
                                           'elCSVByEmail, ' + 
                                           'elCSVByFTP, ' + 
                                           'elCSVToFolder, ' + 
                                           'elUploadDir, ' + 
                                           'elCSVFileName, ' + 
                                           'elFTPTries, ' + 
                                           'elFTPTimeout, ' + 
                                           'elCSVFileRenamed, ' + 
                                           'elFTPRetriesNotified, ' + 
                                           'elFaxRetriesNotified, ' + 
                                           'elCompressReport, ' + 
                                           'elRpAttachMethod, ' + 
                                           'elWorkStation, ' + 
                                           'elWordWrap, ' + 
                                           'elSysMessage, ' + 
                                           'elDBF, ' + 
                                           'elQueueCounter, ' + 
                                           'elHoursBeforeNotify, ' + 
                                           'elQueryStart, ' + 
                                           'elExRepFormat, ' + 
                                           'elRecipNo, ' + 
                                           'elNewReport, ' + 
                                           'elNewReportName' + 
                                           ') ' + 
              'VALUES (' + 
                       ':elNotUsed, ' + 
                       ':elUserID, ' + 
                       ':elName, ' + 
                       ':elType, ' + 
                       ':elPriority, ' + 
                       ':elWindowID, ' + 
                       ':elHandlerID, ' + 
                       ':elTermChar, ' + 
                       ':elDescription, ' +
                       ':elActive, ' + 
                       ':elTimeType, ' + 
                       ':elFrequency, ' + 
                       ':elTime1, ' + 
                       ':elTime2, ' + 
                       ':elDaysOfWeek, ' + 
                       ':elFileno, ' + 
                       ':elIndexNo, ' + 
                       ':elRangeStartEgType, ' + 
                       ':elRangeStartEgString, ' + 
                       ':elRangeStartEgInt, ' + 
                       ':elRangeStartEgOffset, ' + 
                       ':elRangeStartEgInput, ' + 
                       ':elRangeStartSpare, ' + 
                       ':elRangeEndEgType, ' + 
                       ':elRangeEndEgString, ' + 
                       ':elRangeEndEgInt, ' + 
                       ':elRangeEndEgOffset, ' + 
                       ':elRangeEndEgInput, ' + 
                       ':elRangeEndSpare, ' + 
                       ':elEmail, ' + 
                       ':elSMS, ' + 
                       ':elReport, ' + 
                       ':elCSV, ' + 
                       ':elRepEmail, ' + 
                       ':elRepFax, ' + 
                       ':elRepPrinter, ' + 
                       ':elSpare, ' + 
                       ':elExpiration, ' + 
                       ':elExpirationDate, ' + 
                       ':elRepeatPeriod, ' + 
                       ':elRepeatData, ' + 
                       ':elEmailReport, ' + 
                       ':elLastDateRun, ' + 
                       ':elNextRunDue, ' + 
                       ':elReportName, ' + 
                       ':elEventIndex, ' + 
                       ':elRunOnStartup, ' + 
                       ':elEmailCSV, ' + 
                       ':elStatus, ' + 
                       ':elParent, ' +
                       ':elStartDate, ' + 
                       ':elDeleteOnExpiry, ' + 
                       ':elPeriodic, ' + 
                       ':elTriggerCount, ' + 
                       ':elDaysBetween, ' + 
                       ':elExpired, ' + 
                       ':elRunNow, ' + 
                       ':elInstance, ' + 
                       ':elMsgInstance, ' + 
                       ':elSingleEmail, ' + 
                       ':elPrevStatus, ' + 
                       ':elSingleSMS, ' + 
                       ':elTriggered, ' + 
                       ':elSMSTries, ' + 
                       ':elEmailTries, ' + 
                       ':elSendDoc, ' + 
                       ':elDocName, ' + 
                       ':elSMSRetriesNotified, ' + 
                       ':elEmailRetriesNotified, ' + 
                       ':elEmailErrorNo, ' + 
                       ':elSMSErrorNo, ' + 
                       ':elRepFile, ' + 
                       ':elFaxCover, ' + 
                       ':elFaxTries, ' + 
                       ':elPrintTries, ' + 
                       ':elFaxPriority, ' + 
                       ':elHasConditions, ' + 
                       ':elRepFolder, ' + 
                       ':elFTPSite, ' + 
                       ':elFTPUserName, ' + 
                       ':elFTPPassword, ' + 
                       ':elFTPPort, ' + 
                       ':elCSVByEmail, ' + 
                       ':elCSVByFTP, ' + 
                       ':elCSVToFolder, ' + 
                       ':elUploadDir, ' + 
                       ':elCSVFileName, ' + 
                       ':elFTPTries, ' + 
                       ':elFTPTimeout, ' + 
                       ':elCSVFileRenamed, ' + 
                       ':elFTPRetriesNotified, ' +
                       ':elFaxRetriesNotified, ' +
                       ':elCompressReport, ' +
                       ':elRpAttachMethod, ' +
                       ':elWorkStation, ' +
                       ':elWordWrap, ' +
                       ':elSysMessage, ' +
                       ':elDBF, ' +
                       ':elQueueCounter, ' +
                       ':elHoursBeforeNotify, ' +
                       ':elQueryStart, ' +
                       ':elExRepFormat, ' +
                       ':elRecipNo, ' +
                       ':elNewReport, ' +
                       ':elNewReportName' +
                       ')';

  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    elNotUsedParam := FindParam('elNotUsed');
    elUserIDParam := FindParam('elUserID');
    elNameParam := FindParam('elName');
    elTypeParam := FindParam('elType');
    elPriorityParam := FindParam('elPriority');
    elWindowIDParam := FindParam('elWindowID');
    elHandlerIDParam := FindParam('elHandlerID');
    elTermCharParam := FindParam('elTermChar');
    elDescriptionParam := FindParam('elDescription');
    elActiveParam := FindParam('elActive');
    elTimeTypeParam := FindParam('elTimeType');
    elFrequencyParam := FindParam('elFrequency');
    elTime1Param := FindParam('elTime1');
    elTime2Param := FindParam('elTime2');
    elDaysOfWeekParam := FindParam('elDaysOfWeek');
    elFilenoParam := FindParam('elFileno');
    elIndexNoParam := FindParam('elIndexNo');
    elRangeStartEgTypeParam := FindParam('elRangeStartEgType');
    elRangeStartEgStringParam := FindParam('elRangeStartEgString');
    elRangeStartEgIntParam := FindParam('elRangeStartEgInt');
    elRangeStartEgOffsetParam := FindParam('elRangeStartEgOffset');
    elRangeStartEgInputParam := FindParam('elRangeStartEgInput');
    elRangeStartSpareParam := FindParam('elRangeStartSpare');
    elRangeEndEgTypeParam := FindParam('elRangeEndEgType');
    elRangeEndEgStringParam := FindParam('elRangeEndEgString');
    elRangeEndEgIntParam := FindParam('elRangeEndEgInt');
    elRangeEndEgOffsetParam := FindParam('elRangeEndEgOffset');
    elRangeEndEgInputParam := FindParam('elRangeEndEgInput');
    elRangeEndSpareParam := FindParam('elRangeEndSpare');
    elEmailParam := FindParam('elEmail');
    elSMSParam := FindParam('elSMS');
    elReportParam := FindParam('elReport');
    elCSVParam := FindParam('elCSV');
    elRepEmailParam := FindParam('elRepEmail');
    elRepFaxParam := FindParam('elRepFax');
    elRepPrinterParam := FindParam('elRepPrinter');
    elSpareParam := FindParam('elSpare');
    elExpirationParam := FindParam('elExpiration');
    elExpirationDateParam := FindParam('elExpirationDate');
    elRepeatPeriodParam := FindParam('elRepeatPeriod');
    elRepeatDataParam := FindParam('elRepeatData');
    elEmailReportParam := FindParam('elEmailReport');
    elLastDateRunParam := FindParam('elLastDateRun');
    elNextRunDueParam := FindParam('elNextRunDue');
    elReportNameParam := FindParam('elReportName');
    elEventIndexParam := FindParam('elEventIndex');
    elRunOnStartupParam := FindParam('elRunOnStartup');
    elEmailCSVParam := FindParam('elEmailCSV');
    elStatusParam := FindParam('elStatus');
    elParentParam := FindParam('elParent');
    elStartDateParam := FindParam('elStartDate');
    elDeleteOnExpiryParam := FindParam('elDeleteOnExpiry');
    elPeriodicParam := FindParam('elPeriodic');
    elTriggerCountParam := FindParam('elTriggerCount');
    elDaysBetweenParam := FindParam('elDaysBetween');
    elExpiredParam := FindParam('elExpired');
    elRunNowParam := FindParam('elRunNow');
    elInstanceParam := FindParam('elInstance');
    elMsgInstanceParam := FindParam('elMsgInstance');
    elSingleEmailParam := FindParam('elSingleEmail');
    elPrevStatusParam := FindParam('elPrevStatus');
    elSingleSMSParam := FindParam('elSingleSMS');
    elTriggeredParam := FindParam('elTriggered');
    elSMSTriesParam := FindParam('elSMSTries');
    elEmailTriesParam := FindParam('elEmailTries');
    elSendDocParam := FindParam('elSendDoc');
    elDocNameParam := FindParam('elDocName');
    elSMSRetriesNotifiedParam := FindParam('elSMSRetriesNotified');
    elEmailRetriesNotifiedParam := FindParam('elEmailRetriesNotified');
    elEmailErrorNoParam := FindParam('elEmailErrorNo');
    elSMSErrorNoParam := FindParam('elSMSErrorNo');
    elRepFileParam := FindParam('elRepFile');
    elFaxCoverParam := FindParam('elFaxCover');
    elFaxTriesParam := FindParam('elFaxTries');
    elPrintTriesParam := FindParam('elPrintTries');
    elFaxPriorityParam := FindParam('elFaxPriority');
    elHasConditionsParam := FindParam('elHasConditions');
    elRepFolderParam := FindParam('elRepFolder');
    elFTPSiteParam := FindParam('elFTPSite');
    elFTPUserNameParam := FindParam('elFTPUserName');
    elFTPPasswordParam := FindParam('elFTPPassword');
    elFTPPortParam := FindParam('elFTPPort');
    elCSVByEmailParam := FindParam('elCSVByEmail');
    elCSVByFTPParam := FindParam('elCSVByFTP');
    elCSVToFolderParam := FindParam('elCSVToFolder');
    elUploadDirParam := FindParam('elUploadDir');
    elCSVFileNameParam := FindParam('elCSVFileName');
    elFTPTriesParam := FindParam('elFTPTries');
    elFTPTimeoutParam := FindParam('elFTPTimeout');
    elCSVFileRenamedParam := FindParam('elCSVFileRenamed');
    elFTPRetriesNotifiedParam := FindParam('elFTPRetriesNotified');
    elFaxRetriesNotifiedParam := FindParam('elFaxRetriesNotified');
    elCompressReportParam := FindParam('elCompressReport');
    elRpAttachMethodParam := FindParam('elRpAttachMethod');
    elWorkStationParam := FindParam('elWorkStation');
    elWordWrapParam := FindParam('elWordWrap');
    elSysMessageParam := FindParam('elSysMessage');
    elDBFParam := FindParam('elDBF');
    elQueueCounterParam := FindParam('elQueueCounter');
    elHoursBeforeNotifyParam := FindParam('elHoursBeforeNotify');
    elQueryStartParam := FindParam('elQueryStart');
    elExRepFormatParam := FindParam('elExRepFormat');
    elRecipNoParam := FindParam('elRecipNo');
    elNewReportParam := FindParam('elNewReport');
    elNewReportNameParam := FindParam('elNewReportName');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TSentDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TElertRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    elNotUsedParam.Value := ConvertCharToSQLEmulatorVarChar(NotUsed);                                           // SQL=varchar, Delphi=Char
    elUserIDParam.Value := elUserID;                                                                            // SQL=varchar, Delphi=String[UIDSize]
    elNameParam.Value := elElertName;                                                                           // SQL=varchar, Delphi=String[30]
    elTypeParam.Value := ConvertCharToSQLEmulatorVarChar(elType);                                               // SQL=varchar, Delphi=Char
    elPriorityParam.Value := ConvertCharToSQLEmulatorVarChar(elPriority);                                       // SQL=varchar, Delphi=Char
    elWindowIDParam.Value := elWindowID;                                                                        // SQL=int, Delphi=LongInt
    elHandlerIDParam.Value := elHandlerID;                                                                      // SQL=int, Delphi=Longint
    elTermCharParam.Value := ConvertCharToSQLEmulatorVarChar(elTermChar);                                       // SQL=varchar, Delphi=Char
    elDescriptionParam.Value := elDescription;                                                                  // SQL=varchar, Delphi=String[60]
    elActiveParam.Value := elActive;                                                                            // SQL=bit, Delphi=Boolean
    elTimeTypeParam.Value := elTimeType;                                                                        // SQL=int, Delphi=Byte
    elFrequencyParam.Value := elFrequency;                                                                      // SQL=int, Delphi=smallint
    elTime1Param.Value := DateTimeToSQLDateTimeOrNull(elTime1);                                                                              // SQL=datetime, Delphi=TDateTime
    elTime2Param.Value := DateTimeToSQLDateTimeOrNull(elTime2);                                                                              // SQL=datetime, Delphi=TDateTime
    elDaysOfWeekParam.Value := elDaysOfWeek;                                                                    // SQL=int, Delphi=byte
    elFilenoParam.Value := elFileno;                                                                            // SQL=int, Delphi=SmallInt
    elIndexNoParam.Value := elIndexNo;                                                                          // SQL=int, Delphi=Smallint
    elRangeStartEgTypeParam.Value := elRangeStart.egType;                                                        // SQL=int, Delphi=Byte
    elRangeStartEgStringParam.Value := elRangeStart.egString;                                                    // SQL=varchar, Delphi=String[60]
    elRangeStartEgIntParam.Value := elRangeStart.egInt;                                                          // SQL=int, Delphi=longint
    elRangeStartEgOffsetParam.Value := elRangeStart.egOffset;                                                    // SQL=int, Delphi=longint
    elRangeStartEgInputParam.Value := elRangeStart.egInput;                                                      // SQL=bit, Delphi=Boolean
    elRangeStartSpareParam.Value := CreateVariantArray (@elRangeStart.Spare, SizeOf(elRangeStart.Spare));// SQL=varbinary, Delphi=Array[1..3] of Byte
    elRangeEndEgTypeParam.Value := elRangeEnd.egType;                                                            // SQL=int, Delphi=Byte
    elRangeEndEgStringParam.Value := elRangeEnd.egString;                                                        // SQL=varchar, Delphi=String[60]
    elRangeEndEgIntParam.Value := elRangeEnd.egInt;                                                              // SQL=int, Delphi=longint
    elRangeEndEgOffsetParam.Value := elRangeEnd.egOffset;                                                        // SQL=int, Delphi=longint
    elRangeEndEgInputParam.Value := elRangeEnd.egInput;                                                          // SQL=bit, Delphi=Boolean
    elRangeEndSpareParam.Value := CreateVariantArray (@elRangeEnd.Spare, SizeOf(elRangeEnd.Spare));// SQL=varbinary, Delphi=Array[1..3] of Byte
    elEmailParam.Value := elActions.eaEmail;                                                                     // SQL=bit, Delphi=Boolean
    elSMSParam.Value := elActions.eaSMS;                                                                         // SQL=bit, Delphi=Boolean
    elReportParam.Value := elActions.eaReport;                                                                   // SQL=bit, Delphi=Boolean
    elCSVParam.Value := elActions.eaCSV;                                                                         // SQL=bit, Delphi=Boolean
    elRepEmailParam.Value := elActions.eaRepEmail;                                                               // SQL=bit, Delphi=Boolean
    elRepFaxParam.Value := elActions.eaRepFax;                                                                   // SQL=bit, Delphi=Boolean
    elRepPrinterParam.Value := elActions.eaRepPrinter;                                                           // SQL=bit, Delphi=Boolean
    elSpareParam.Value := CharArrayToVarChar(elActions.Spare);                                                                       // SQL=varchar, Delphi=Array[1..17] of Char
    elExpirationParam.Value := elExpiration;                                                                    // SQL=int, Delphi=Byte
    elExpirationDateParam.Value := DateTimeToSQLDateTimeOrNull(elExpirationDate);                                                            // SQL=datetime, Delphi=TDateTime
    elRepeatPeriodParam.Value := elRepeatPeriod;                                                                // SQL=int, Delphi=Byte
    elRepeatDataParam.Value := elRepeatData;                                                                    // SQL=int, Delphi=Smallint
    elEmailReportParam.Value := elEmailReport;                                                                  // SQL=bit, Delphi=Boolean
    elLastDateRunParam.Value := DateTimeToSQLDateTimeOrNull(elLastDateRun);                                                                  // SQL=datetime, Delphi=TDateTime
    elNextRunDueParam.Value := DateTimeToSQLDateTimeOrNull(elNextRunDue);                                                                    // SQL=datetime, Delphi=TDateTime
    elReportNameParam.Value := elReportName;                                                                    // SQL=varchar, Delphi=String[12]
    elEventIndexParam.Value := elEventIndex;                                                                    // SQL=int, Delphi=SmallInt
    elRunOnStartupParam.Value := elRunOnStartup;                                                                // SQL=bit, Delphi=Boolean
    elEmailCSVParam.Value := elEmailCSV;                                                                        // SQL=bit, Delphi=Boolean
    elStatusParam.Value := elStatus;                                                                            // SQL=int, Delphi=Byte
    elParentParam.Value := elParent;                                                                            // SQL=varchar, Delphi=String[30]
    elStartDateParam.Value := DateTimeToSQLDateTimeOrNull(elStartDate);                                                                      // SQL=datetime, Delphi=TDateTime
    elDeleteOnExpiryParam.Value := elDeleteOnExpiry;                                                            // SQL=bit, Delphi=Boolean
    elPeriodicParam.Value := elPeriodic;                                                                        // SQL=bit, Delphi=Boolean
    elTriggerCountParam.Value := elTriggerCount;                                                                // SQL=int, Delphi=SmallInt
    elDaysBetweenParam.Value := elDaysBetween;                                                                  // SQL=int, Delphi=SmallInt
    elExpiredParam.Value := elExpired;                                                                          // SQL=bit, Delphi=Boolean
    elRunNowParam.Value := elRunNow;                                                                            // SQL=bit, Delphi=Boolean
    elInstanceParam.Value := elInstance;                                                                        // SQL=int, Delphi=SmallInt
    elMsgInstanceParam.Value := elMsgInstance;                                                                  // SQL=int, Delphi=SmallInt
    elSingleEmailParam.Value := elSingleEmail;                                                                  // SQL=bit, Delphi=Boolean
    elPrevStatusParam.Value := elPrevStatus;                                                                    // SQL=int, Delphi=Byte
    elSingleSMSParam.Value := elSingleSMS;                                                                      // SQL=bit, Delphi=Boolean
    elTriggeredParam.Value := elTriggered;                                                                      // SQL=int, Delphi=SmallInt
    elSMSTriesParam.Value := elSMSTries;                                                                        // SQL=int, Delphi=Byte
    elEmailTriesParam.Value := elEmailTries;                                                                    // SQL=int, Delphi=Byte
    elSendDocParam.Value := elSendDoc;                                                                          // SQL=bit, Delphi=Boolean
    elDocNameParam.Value := elDocName;                                                                          // SQL=varchar, Delphi=String[8]
    elSMSRetriesNotifiedParam.Value := elSMSRetriesNotified;                                                    // SQL=bit, Delphi=Boolean
    elEmailRetriesNotifiedParam.Value := elEmailRetriesNotified;                                                // SQL=bit, Delphi=Boolean
    elEmailErrorNoParam.Value := elEmailErrorNo;                                                                // SQL=int, Delphi=SmallInt
    elSMSErrorNoParam.Value := elSMSErrorNo;                                                                    // SQL=int, Delphi=SmallInt
    elRepFileParam.Value := elRepFile;                                                                          // SQL=varchar, Delphi=String[12]
    elFaxCoverParam.Value := elFaxCover;                                                                        // SQL=varchar, Delphi=String[8]
    elFaxTriesParam.Value := elFaxTries;                                                                        // SQL=int, Delphi=Byte
    elPrintTriesParam.Value := elPrintTries;                                                                    // SQL=int, Delphi=Byte
    elFaxPriorityParam.Value := elFaxPriority;                                                                  // SQL=int, Delphi=Byte
    elHasConditionsParam.Value := elHasConditions;                                                              // SQL=bit, Delphi=Boolean
    elRepFolderParam.Value := elRepFolder;                                                                      // SQL=varchar, Delphi=String[99]
    elFTPSiteParam.Value := elFTPSite;                                                                          // SQL=varchar, Delphi=String[80]
    elFTPUserNameParam.Value := elFTPUserName;                                                                  // SQL=varchar, Delphi=String[20]
    elFTPPasswordParam.Value := elFTPPassword;                                                                  // SQL=varchar, Delphi=String[20]
    elFTPPortParam.Value := elFTPPort;                                                                          // SQL=int, Delphi=SmallInt
    elCSVByEmailParam.Value := elCSVByEmail;                                                                    // SQL=bit, Delphi=Boolean
    elCSVByFTPParam.Value := elCSVByFTP;                                                                        // SQL=bit, Delphi=Boolean
    elCSVToFolderParam.Value := elCSVToFolder;                                                                  // SQL=bit, Delphi=Boolean
    elUploadDirParam.Value := elUploadDir;                                                                      // SQL=varchar, Delphi=String[99]
    elCSVFileNameParam.Value := elCSVFileName;                                                                  // SQL=varchar, Delphi=String[12]
    elFTPTriesParam.Value := elFTPTries;                                                                        // SQL=int, Delphi=Byte
    elFTPTimeoutParam.Value := elFTPTimeout;                                                                    // SQL=int, Delphi=Byte
    elCSVFileRenamedParam.Value := elCSVFileRenamed;                                                            // SQL=bit, Delphi=Boolean
    elFTPRetriesNotifiedParam.Value := elFTPRetriesNotified;                                                    // SQL=bit, Delphi=Boolean
    elFaxRetriesNotifiedParam.Value := elFaxRetriesNotified;                                                    // SQL=bit, Delphi=Boolean
    elCompressReportParam.Value := elCompressReport;                                                            // SQL=bit, Delphi=Boolean
    elRpAttachMethodParam.Value := elRpAttachMethod;                                                            // SQL=int, Delphi=Byte
    elWorkStationParam.Value := elWorkStation;                                                                  // SQL=varchar, Delphi=String[30]
    elWordWrapParam.Value := elWordWrap;                                                                        // SQL=bit, Delphi=Boolean
    elSysMessageParam.Value := elSysMessage;                                                                    // SQL=int, Delphi=Byte
    elDBFParam.Value := elDBF;                                                                                  // SQL=bit, Delphi=Boolean
    elQueueCounterParam.Value := elQueueCounter;                                                                // SQL=int, Delphi=SmallInt
    elHoursBeforeNotifyParam.Value := elHoursBeforeNotify;                                                      // SQL=int, Delphi=SmallInt
    elQueryStartParam.Value := DateTimeToSQLDateTimeOrNull(elQueryStart);                                                                    // SQL=datetime, Delphi=TDateTime
    elExRepFormatParam.Value := elExRepFormat;                                                                  // SQL=int, Delphi=Byte
    elRecipNoParam.Value := elRecipNo;                                                                          // SQL=int, Delphi=SmallInt
    elNewReportParam.Value := elNewReport;                                                                      // SQL=bit, Delphi=Boolean
    elNewReportNameParam.Value := elNewReportName;                                                              // SQL=varchar, Delphi=String[50]
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

