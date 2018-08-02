{ CJS 2012-08-15 - ABSEXCH-12964 - SQL Data Migration - Moved VRW data 
                   structures to separate include file so that they can be 
                   accessed from the SQL Migration code. }
                   
Const
  RTSecurityF = 20;

  RTSecUserIdx = 0;
  RTSecReportIdx = 1;

{$IFDEF SQLConversion}
// The SQL Migration tool does not have access to the TReportPermissionType
// enumeration or the REPORT_NAME_LGTH constant
const
  REPORT_NAME_LGTH = 50;
type
  TReportPermissionType = Byte;
{$ENDIF}

Type
  // Report Tree Seccurity Record
  //
  // Index 0: rtsUserCode + rtsTreeCode
  // Index 1: rtsTreeCode + rtsUserCode
  TReportTreeSecurityRecType = Record
    rtsTreeCode     : String[REPORT_NAME_LGTH];      // Group/Report Code
    rtsUserCode     : String[10];                    // Enterprise User Id
    rtsSecurity     : TReportPermissionType;         // see RepTreeIF.Pas
    rtsSpare        : Array[1..128] Of Byte;         // For future use
  End; // TReportTreeSecurityRecType

  // Btrieve File Definition
  TReportTreeSecurityFileDefType = record
    RecLen    : SmallInt;
    PageSize  : SmallInt;
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    Reserved  : Array [1..4] Of Char;
    KeyBuff   : Array [1..4] Of KeySpec;
    AltColt   : AltColtSeq;
  End; // TReportTreeSecurityFileDefType

//-------------------------------------------------------------------------

//-------------------------------------------------------------------------

Const
  VRWReportDataF = 21;

  rtIdxRepName = 0;
  rtIdxParentName = 1;
  rtIdxFilename = 2;

Type
  // New Report Tree Record
  //
  //  Index 0:	rtRepName
  //  Index 1:	rtParentName + rtPositionNumber
  //  Index 2:	rtFilename

  TVRWReportDataRec = Record
    rtNodeType:    char;
    rtRepName:     String[REPORT_NAME_LGTH];   { Report Code }
    rtRepDesc:     String[255];  { Report Title }
    rtParentName:  String[50];	 { Link to parent record }
    rtFileName:    String[80];   { Report file name }
    rtLastRun:     TDateTime;
    rtLastRunUser: String[10];
    rtPositionNumber: LongInt;
    rtIndexFix:    char;
    rtAllowEdit:   Boolean;
    rtFileExists:  Boolean;
    rtSpace:       string[45];   { Pad record to 512 bytes }
  end;

  // Btrieve File Definition
  TVRWReportDataFileDefType = record
    RecLen    : SmallInt;
    PageSize  : SmallInt;
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    Reserved  : Array [1..4] Of Char;
    KeyBuff   : Array [1..5] Of KeySpec;
    AltColt   : AltColtSeq;
  End; // TVRWReportDataFileDefType

//-------------------------------------------------------------------------


