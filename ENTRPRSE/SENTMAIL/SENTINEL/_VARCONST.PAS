unit VarConst;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{Have one file for Elert recs, one for EmailAddresses, SMSNumbers, and
output lines, linked on UserIDcode & unique (within co) ElertName}
interface

uses
  GlobVar, BtrvU2;

const

  ElPath = 'EL\';

  UIDSize = 10;

  MaxRecSize = 1000;

  pxElOutput   = 'O';
  pxElEmail    = 'E';
  pxElSMS      = 'S';
  pxElRecsSent = 'R';

  ElertFileName   = ELPath + 'Sent.dat';
  LineFileName    = ELPath + 'SentLine.Dat';

  ElertBase = 0;

  ElertF   = ElertBase + 1;
  LineF    = ElertBase + 2;

  ElertNumofKeys   = 3;
  ElertNumSegments = 8;

  elIdxElertName = 0;
  elIdxName  = 1;
  elIdxUser  = 2;

  LineNumofKeys   = 2;
  LineNumSegments = 7;


type

  TElertType = (etTimer, etEvent);

  TElertTimeType = (ettNever, ettTimeOneOnly, ettFrequency, ettFrequencyInPeriod);

  TElertExpirationType = (eetNever, eetDate, eetOnceOnly);

  TOutputLineType = (eolEmail, eolSMS, eolReport, eolCSV, eolParams);

  TElertRangeValType = (evNull, evString, evInt, evDouble);

  TElertRepeatPeriod = (epDays, epWeek, epMonth, epNever);

  TElertPriority = (elpHigh, elpMedium, elpLow);

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
    RepName    : String[10];
    NoOfParams : Word;
  end;

  TReportParamRec = Record
    RepName    : String[10];
    ParamCount : Byte;
    ParamType  : Byte;
    Params     : Array[1..2] of String[100];
  end;

  TElertActions = Record //what to do when an elert meets its conditions
    eaEmail             : Boolean;
    eaSMS               : Boolean;
    eaReport            : Boolean;
    eaCSV               : Boolean;
    Spare               : Array[1..20] of Char;
  end;

  TElertEmailAddressRec = Record
    emaUserID          : String[UIDSize];
    emaElertName        : String[30];
    NotUsed             : Array[1..2] of Char;
    emaName             : String[60];
    emaAddress          : String[100];//?
    Spare               : Array[1..100] of Char;
  end;

{Outputline contains most of the outputs from a sentinel divided into various types
  Email or SMS Line1 contains the message lines (SMS only needs one at the moment
  but who knows what'll happen). On the first Email, Line2 is the Subject.  For
  Report Parameters, Line1 is the from, Line2 is the to and ParamType is used.
  For Reports or CSVs Line1 is the printer for reports and Line2 is the filename
  to save the csv to.}

  TElertOutputLine = Record
    eoUserID            : String[UIDSize];
    eoElertName         : String[30];
    eoOutputType        : Char;  //E, S, P, R, C
    eoLineNo            : Char; //#1 - #255
    eoParamType         : Byte; // maps to TElertRangeValType
    eoLine1             : String[255];
    eoLine2             : String[255];
    Spare               : Array[1..100] of Char;
  end;

  TElertSMSRec = Record
    esUserID           : String[UIDSize];
    esElertName         : String[30];
    NotUsed             : Array[1..2] of Char;
    esName              : String[20];
    esCountry           : String[6];  //allow plenty of room for future
    esCode              : String[12]; //     "                     "
    esNumber            : String[20]; //     "                     "
    Spare               : Array[1..100] of Char;
  end;

  TElertRangeRec = Record
    egType              : TElertRangeValType;
    egString            : String[30];
    egInt               : longint;
    egDouble            : Double;
  end;

  TElertReportRec = Record
    erElertName         : String[30];
    erInputField        : String[12]; //enough?
    erInputValue1,
    erInputValue2       : TElertRangeRec;
  end;

  TElertConditions = Record
    ecCondition         : String[255]; //sql-type statement - is 255 long enough?
  end;

  TElertRec = Record
    NotUsed             : Char;
    elUserID            : String[UIDSize];
    elElertName         : String[30];
    elType              : Char; //maps to TElertType 'T' = etTimer, 'E' = etEvent
    elPriority          : Char; //maps to TElertPriority LMH - low medium high
    elWindowID          : LongInt;
    elHandlerID         : Longint;
    elIntTermChar       : Char; //'!' to terminate integer fields
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
    elLogic             : TElertConditions;
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
    elPrintReport       : Boolean;
    elSaveCSVToFile     : Boolean;
    Spare               : Array[1..298] of Char;
  end;

  TElertRecSentRec = Record
    ersUserID           : String[6];
    ersElertName        : String[12];
    ersFileNo           : SmallInt;
    ersID               : String[30];
    ersDateLastSent     : TDateTime;
  end;

  TElertLineRec = Record
    Prefix           : Char;
    Case Byte of
       1   :  (Output : TElertOutputLine);
       2   :  (SMS    : TElertSMSRec);
       3   :  (EMail  : TElertEmailAddressRec);
       4   :  (ALine  : Array[1..MaxRecSize] of Byte);
  end;

  //File defs

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

  LineFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..LineNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;


  procedure DefineFiles(const WhichDir : String);


var

  ElertRec    : TElertRec;
  ElertFile   : ElertFileDef;

  LineRec     : TElertLineRec;
  LineFile    : LineFileDef;

{  AddressRec  : TElertEmailAddressRec;
  AddressFile : AddressFileDef;

  SMSRec      : TElertSMSRec;
  SMSFile     : SMSFileDef;

  RecsSentRec : TElertRecSentRec;
  RecsSentFile: RecsSentFileDef; }

  EntDir      : AnsiString;


implementation

uses
  SysUtils, Forms, IniFiles;

var
   eBSetDrive  :  AnsiString = '';



function GetMultiCompDir : ansistring;
const
  WORKSTATION_REPLICATION_INI = 'ENTWREPL.INI';
  SECTION_NAME = 'UpdateEngine';
  KEY_NAME = 'NetworkDir';
var
  Directory : ansistring;
  ShortDir  : ansistring;
begin
  Result:='';  ShortDir:='';

  If (ebSetDrive='') then
    Directory := ExtractFilePath(Application.ExeName)
  else
    Directory:=ebSetDrive;

  with TIniFile.Create(Directory+WORKSTATION_REPLICATION_INI) do
  try
    Result := ReadString(SECTION_NAME, KEY_NAME, '');
  finally
    Free;
  end;
  if Trim(Result) = '' then
    Result := Directory;

  ShortDir:=ExtractShortPathName(Result);

  If (ShortDir<>'') then
    Result:=ShortDir;
end;





procedure DefineElert;
const
  Idx = ElertF;
begin
  FileSpecLen[Idx] := SizeOf(ElertFile);
  FillChar(ElertFile, FileSpecLen[Idx],0);

  with ElertFile do
  begin
    RecLen := Sizeof(ElertRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := ElertNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);

    //Key 1 - UserID code + ElertName
    // UserIDCode = string[6]
    KeyBuff[1].KeyPos := BtKeyPos(@ElertRec.elUserID[1], @ElertRec);
    KeyBuff[1].KeyLen := SizeOf(ElertRec.elUserID) - 1;
    KeyBuff[1].KeyFlags := DupModSeg;
    //ElertName = String[12]
    KeyBuff[2].KeyPos := BtKeyPos(@ElertRec.elElertName[1], @ElertRec);;
    KeyBuff[2].KeyLen := SizeOf(ElertRec.elElertName) - 1;
    KeyBuff[2].KeyFlags := DupMod;

    //Key 2 - UserID Code + Name + Priority
    // UserIDCode = string[6]
    KeyBuff[3].KeyPos := BtKeyPos(@ElertRec.elUserID[1], @ElertRec);
    KeyBuff[3].KeyLen := SizeOf(ElertRec.elUserID) - 1;
    KeyBuff[3].KeyFlags := DupModSeg;
    //Name = String[12]
    KeyBuff[4].KeyPos := BtKeyPos(@ElertRec.elElertName[1], @ElertRec);;
    KeyBuff[4].KeyLen := SizeOf(ElertRec.elElertName) - 1;
    KeyBuff[4].KeyFlags := DupModSeg;

    KeyBuff[5].KeyPos := BtKeyPos(@ElertRec.elPriority, @ElertRec);
    KeyBuff[5].KeyLen := SizeOf(ElertRec.elPriority);
    KeyBuff[5].KeyFlags := DupMod;

    //Key 3 - UserID Code + Name + Type
    // UserIDCode = string[6]
    KeyBuff[6].KeyPos := BtKeyPos(@ElertRec.elUserID[1], @ElertRec);
    KeyBuff[6].KeyLen := SizeOf(ElertRec.elUserID) - 1;
    KeyBuff[6].KeyFlags := DupModSeg;
    //Name = String[12]
    KeyBuff[7].KeyPos := BtKeyPos(@ElertRec.elElertName[1], @ElertRec);;
    KeyBuff[7].KeyLen := SizeOf(ElertRec.elElertName) - 1;
    KeyBuff[7].KeyFlags := DupModSeg;

    KeyBuff[8].KeyPos := BtKeyPos(@ElertRec.elType, @ElertRec);
    KeyBuff[8].KeyLen := SizeOf(ElertRec.elType);
    KeyBuff[8].KeyFlags := DupMod;


    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(ElertRec);
  FillChar(ElertRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @ElertRec;
  FileSpecOfS[Idx] := @ElertFile;
  FileNames[Idx] := EntDir + ElertFilename;
end;

procedure DefineLine;
const
  Idx = LineF;
begin
  FileSpecLen[Idx] := SizeOf(LineFile);
  FillChar(LineFile, FileSpecLen[Idx],0);

  with LineFile do
  begin
    RecLen := Sizeof(LineRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := LineNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);
    //Key 1 Pfix + UserID + ElertName + Outputtype + LineNo
    KeyBuff[1].KeyPos := BtKeyPos(@LineRec.Prefix, @LineRec);
    KeyBuff[1].KeyLen := SizeOf(LineRec.Prefix);
    KeyBuff[1].KeyFlags := DupModSeg;
    // UserIDCode = string[6]
    KeyBuff[2].KeyPos := BtKeyPos(@LineRec.Output.eoUserID[1], @LineRec);
    KeyBuff[2].KeyLen := SizeOf(LineRec.Output.eoUserID) - 1;
    KeyBuff[2].KeyFlags := DupModSeg;
    //ElertName = String[30]
    KeyBuff[3].KeyPos := BtKeyPos(@LineRec.Output.eoElertName[1], @LineRec);;
    KeyBuff[3].KeyLen := SizeOf(LineRec.Output.eoElertName) - 1;
    KeyBuff[3].KeyFlags := DupModSeg;
    //OutputType = Char
    KeyBuff[4].KeyPos := BtKeyPos(@LineRec.Output.eoOutputType, @LineRec);;
    KeyBuff[4].KeyLen := SizeOf(LineRec.Output.eoOutputType);
    KeyBuff[4].KeyFlags := DupModSeg;
    //LineNo = Char
    KeyBuff[5].KeyPos := BtKeyPos(@LineRec.Output.eoLineNo, @LineRec);;
    KeyBuff[5].KeyLen := SizeOf(LineRec.Output.eoLineNo);
    KeyBuff[5].KeyFlags := DupMod;

    //Key 2
    // UserIDCode = string[6]
    KeyBuff[6].KeyPos := BtKeyPos(@LineRec.Output.eoUserID[1], @LineRec);
    KeyBuff[6].KeyLen := SizeOf(LineRec.Output.eoUserID) - 1;
    KeyBuff[6].KeyFlags := DupModSeg;
    //ElertName = String[30]
    KeyBuff[7].KeyPos := BtKeyPos(@LineRec.Output.eoElertName[1], @LineRec);;
    KeyBuff[7].KeyLen := SizeOf(LineRec.Output.eoElertName) - 1;
    KeyBuff[7].KeyFlags := DupMod;




    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(LineRec);
  FillChar(LineRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @LineRec;
  FileSpecOfS[Idx] := @LineFile;
  FileNames[Idx] := EntDir + LineFilename;
end;


procedure DefineFiles(const WhichDir : String);
begin
  EntDir := WhichDir;

  DefineElert;
  DefineLine;

end;


end.
