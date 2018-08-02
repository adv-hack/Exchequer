unit CopyData;

//RB 31/07/2018 v12.0.0: ABSEXCH-19517: New Unit for copying data during upgrades.
  
interface

uses
  GlobVar,
  Windows,
  VarRec2U,
  BtrvU2,
  VarConst,
  SysUtils,
  BTConst,
  CustomFieldsVar,
  CustomFieldsIntf,
  BTUtil;
  
  function CopyElCSVFileData(var aErrStr : string) : Integer;

  
const
  ElertFileName = 'SMAIL\Sent.dat';
  UIDSize = 10;
  ElertNumSegments = 11;
  
type

  TElertRangeValType = (evNull, evString, evInt, evDouble, evPeriod, evDate, evCurrency);
  
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
    elCSVFileNameOld    : String[12]; //Rahul
    elCSVFileName       : String[60]; 
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
{$IFDEF EX600}
    Spare               : Array[1..665] of Char;      //726
{$ELSE}
    Spare               : Array[1..72] of Char;
{$ENDIF}
  end;

  ElertFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..ElertNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

implementation

function CopyElCSVFileData(var aErrStr : string) : Integer;
var
  lElertRec : TElertRec;
  lTempRec: TElertRec;
  lRes : Integer;
  lElertFile : TFileVar;
  lKeyS: Str255;
begin
  Result := 0;
  //Open file - can't go through EL's standard funcs as CustomFields isn't included in File arrays
  Result := BTOpenFile(lElertFile, SetDrive + ElertFileName, 0, NIL, ExBTOWNER);

  if (Result = 0) then
  begin
    try
      FillChar(lElertRec, SizeOf(lElertRec), 0);
      lKeyS := '';
      lRes := BTFindRecord(B_GetFirst, lElertFile, lElertRec, SizeOf(lElertRec), 0, lKeyS);

      //loop through every record in Sent.Dat and copy data from elcsvFileNameold to new
      while (lRes = 0) and (lRes <> 9) do
      begin
        with lElertRec do
        begin
          elCSVFileName := Trim(elCSVFileNameOld);
        end;

        lRes := BTUpdateRecord(lElertFile, lElertRec, SizeOf(lElertRec), 0, lKeyS);
        if (lRes = 0) then
          lRes := BTFindRecord(B_GetNext, lElertFile, lElertRec, SizeOf(lElertRec), 0, lKeyS)
        else
          Result := -1;
      end;
    finally
      BTCloseFile(lElertFile);
    end;
  end
  else
    aErrStr := 'Error ' + IntToStr(Result) + ' occured trying to open file ' + SetDrive + ElertFileName;
end;

end.
