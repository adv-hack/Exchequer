const

  UIDSize = 10;

  MaxRecSize = 1634;

type

  TElertType = (etTimer, etEvent, etGroup);

  TElertTransmissionType = (etrSMS, etrEmail, etrFTP, etrFax);

  TElertFrequency = (efDaily, efPeriod);

  TElertFaxPriority = (exUrgent, exNormal, exOffPeak);

  TElertStatus = (esIdle, esInProcess, esSMSReadyToGo, esEmailReadyToGo, esBothReadyToGo,
                    esInSendProcess, esError, esReportToRun, esReportEmailReadyToGo, esFaxReadyToGo,
                    esReportBothReadyToGo, esCopyReadyToGo, esFTPReadyToGo, esFTPAndCopyReadyToGo,
                    esCSVEmailReadyToGo, esCopyAndEmailReadyToGo, esFTPandEmailReadyToGo,
                    esAllCSVReadyToGo);

  TElertTimeType = (ettNever, ettTimeOneOnly, ettFrequency, ettFrequencyInPeriod);

  TElertExpirationType = (eetNever, eetDate, eetAfterTriggers);

  TOutputLineType = (eolEmailSubject, eolEmailHeader, eolEmailLine,
                    eolEmailTrailer, eolSMS, eolReport, eolCSV, eolParams, eolLogic,
                    eolEvent, eolFaxNo, eolFaxFrom, eolFaxNoteLine, eolRepEmailAdd,
                    eolRepEmailSubject, eolRepEmailLine, eolRepPrinter, eolSysEmail,
                    eolSysSMS, eolSysFax, eolSysFTP, eolSysAlerts, eolSysReports,
                    eolSysHigh, eolSysLow, eolUnknown);

  TReportDeliveryType = (erdEMail, erdURL, erdPrint, erdFile, erdFax);

  TElertRangeValType = (evNull, evString, evInt, evDouble, evPeriod, evDate, evCurrency);

  TElertRepeatPeriod = (epDays, epWeek, epMonth, epNever, epAlways);

  TElertPriority = (elpHigh, elpLow);

  TEmailRecipType = (ertTo, ertCC, ertBCC);

  TSentinelPurpose = (spQuery, spConveyor, spPoller, spReport, spReportConveyor,
                      spReportQuery, spCSVConveyor, spSystem, spEmailCheck, spVisualReportConveyor, spVisualReport);



  TElertSysSetupRec = Record
    esSMSType        : Byte; //mobile, msg centre, lycos?
    esSMSCentre      : String[20];
    esSMSUserName    : String[30];
    esSMSPassword    : String[30];
    //lots more to come
  end;


  PReportNameRec = ^TReportNameRec;
  TReportNameRec = Record
    RepGroup   : String[10];
    RepName    : String[50]; //changed from 10 to 50 to accommodate new rw
    NoOfParams : Word;
    GrpPWord   : String[8];
    //Added for new report writer
    NewRepFileName : string[30];
  end;

  PReportParamRec = ^TReportParamRec;
  TReportParamRec = Record
    ParamType  : Byte;
    Params     : Array[1..2] of String[60];
  end;

  TElertActions = Record //what to do when an elert meets its conditions
    eaEmail             : Boolean;
    eaSMS               : Boolean;
    eaReport            : Boolean;
    eaCSV               : Boolean;
    eaRepEmail          : Boolean;
    eaRepFax            : Boolean;
    eaRepPrinter        : Boolean;
    Spare               : Array[1..17] of Char;
  end;

  TElertRangeRec = Record
    egType              : TElertRangeValType;
    egString            : String[60];
    egInt               : longint;
    egOffset            : longint;
    egInput             : Boolean; //has been used as an input for FastNDX in a report
    Spare               : Array[1..3] of Byte;
  end;


{$IFDEF EX600}
  {$I w:\entrprse\sentmail\sentinel\ElLineRecs600.inc}
{$ELSE}
  {$I w:\entrprse\sentmail\sentinel\ElLineRecs571.inc}
{$ENDIF}




  TElertReportRec = Record
    erElertName         : String[30];
    erInputField        : String[12]; //enough?
    erInputValue1,
    erInputValue2       : TElertRangeRec;
  end;

  TElertConditions = Record   //Not used
    ecCondition         : String[255]; //sql-type statement - is 255 long enough?
  end;


  PElertRec = ^TElertRec;
  TElertRec = Record
    NotUsed             : Char;
    elUserID            : String[UIDSize];
    elElertName         : String[30];
    elType              : Char; //maps to TElertType 'T' = etTimer, 'E' = etEvent, 'G' - Group heading
    elPriority          : Char; //maps to TElertPriority LMH - low medium high
    elWindowID          : LongInt;
    elHandlerID         : Longint;
    elTermChar          : Char; //'!' to terminate integer fields
    elDescription       : String[60];
    elActive            : Boolean;
    elTimeType          : Byte; //maps to TElertTimeType
    elFrequency         : smallint;   // in minutes (smallest time interval 10 minutes?)
    elTime1             : TDateTime;  // Time in day OR start of frequency period
    elTime2             : TDateTime;  // End of frequency period if required
    elDaysOfWeek        : byte;       // Bit 0 = Monday ... bit 6 = Sunday
    elFileno            : SmallInt;
    elIndexNo           : Smallint;
    elRangeStart        : TElertRangeRec;
    elRangeEnd          : TElertRangeRec;
    elActions           : TElertActions;
   // elLogic             : TElertConditions;
    elExpiration        : Byte; //maps to TElertExpirationType
    elExpirationDate    : TDateTime;
    elRepeatPeriod      : Byte; //maps to TElertRepeatPeriod
    elRepeatData        : Smallint; //interval in days for re-including data
    elEmailReport       : Boolean;
    elLastDateRun       : TDateTime;
    elNextRunDue        : TDateTime;
    elReportName        : String[12];
    elEventIndex        : SmallInt;
    elRunOnStartup      : Boolean;
    elEmailCSV          : Boolean;
    elStatus            : Byte;
    elParent            : String[30];
    elStartDate         : TDateTime;
    elDeleteOnExpiry    : Boolean;
    elPeriodic          : Boolean;
    elTriggerCount      : SmallInt;
    elDaysBetween       : SmallInt;
    elExpired           : Boolean;
    elRunNow            : Boolean;
    elInstance          : SmallInt; //for event-driven elerts 1-255
    elMsgInstance       : SmallInt;
    elSingleEmail       : Boolean;
    elPrevStatus        : Byte;
    elSingleSMS         : Boolean;
    elTriggered         : SmallInt; //how many times elert has been triggered
    elSMSTries          : Byte;
    elEmailTries        : Byte;
    elSendDoc           : Boolean;
    elDocName           : String[8];
    elSMSRetriesNotified: Boolean;
    elEmailRetriesNotified : Boolean;
    elEmailErrorNo      : SmallInt;
    elSMSErrorNo        : SmallInt;
    elRepFile           : String[12];
    elFaxCover          : String[8];
    elFaxTries          : Byte;
    elPrintTries        : Byte;
    elFaxPriority       : Byte;
    elHasConditions     : Boolean;
    elRepFolder         : String[99];
    elFTPSite           : String[80];
    elFTPUserName       : String[20];
    elFTPPassword       : String[20];
    elFTPPort           : SmallInt;
    elCSVByEmail        : Boolean;
    elCSVByFTP          : Boolean;
    elCSVToFolder       : Boolean;
    elUploadDir         : String[99];
    elCSVFileNameOld    : String[12]; //RB 31/07/2018 v12.0.0: ABSEXCH-19517: Renamed elCSVFileName -> elCSVFileNameOld
    elFTPTries          : Byte;
    elFTPTimeout        : Byte;
    elCSVFileRenamed    : Boolean;
    elFTPRetriesNotified : Boolean;
    elFaxRetriesNotified : Boolean;
    elCompressReport    : Boolean;
    elRpAttachMethod    : Byte;
    elWorkStation       : String[30];
    elWordWrap          : Boolean;
    elSysMessage        : Byte; {1 = SMS Notification}
    elDBF               : Boolean;
    elQueueCounter      : SmallInt;
    elHoursBeforeNotify : SmallInt;
    elQueryStart        : TDateTime;
    elExRepFormat       : Byte; //Extended report format - 0 & 1 - n/a, 2 - HTML, 3 - Excel (.xls)  255 indicates Adobe PDF
    elRecipNo           : SmallInt;
    elNewReport         : Boolean;
    elNewReportName     : String[50];
    elCSVFileName       : String[60]; //RB 31/07/2018 v12.0.0: ABSEXCH-19517: New field elCSVFileName with size 60.
{$IFDEF EX600}
    Spare               : Array[1..665] of Char; 
{$ELSE}
    Spare               : Array[1..72] of Char;
{$ENDIF}
  end;



  TElertLineRec = Record
    Prefix           : Char;
    Case Byte of
       1   :  (Output : TElertOutputLine);
       2   :  (SMS    : TElertSMSRec);
       3   :  (EMail  : TElertEmailAddressRec);
       4   :  (Event  : TElertEventRec);
       5   :  (Respawn : TElertRespawnRec);
       6   :  (RecsSent : TElertRecsSentRec);
       7   :  (ALine  : Array[1..MaxRecSize] of Byte);
  end;

