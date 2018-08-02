TElertEmailAddressRec = Record
    emaUserID          : String[UIDSize];
    emaElertName        : String[30];
    NotUsed             : Array[1..2] of Char;
    emaName             : String[60];
    emaAddress          : String[100];//?
    emaRecipType        : Byte; //maps to TEmailRecipType
    emaRecipNo          : SmallInt;
    Spare               : Array[1..197] of Char;
  end;

{Outputline contains most of the outputs from a sentinel divided into various types
  Email or SMS Line1 contains the message lines (SMS only needs one at the moment
  but who knows what'll happen). On the first Email, Line2 is the Subject. (Now we use
  a separate output type for subject, header, & trailer)
  For Report Parameters, Line1 is the from, Line2 is the to and ParamType is used.
  For Reports or CSVs ParamType tells us what type of line it is (e.g. URL, Filelocation,
  Printer) adn Line1 gives the details of the output.}

  TElertOutputLine = Record
    eoUserID            : String[UIDSize];
    eoElertName         : String[30];
    eoOutputType        : Char;  //E, S, P, R, C
    eoLineNo            : SmallInt;
    eoTerm              : Char;
    eoParamType         : Byte; // maps to TElertRangeValType
    eoLine1             : String[255];
    eoLine2             : String[100];
    eoInstance          : SmallInt;
    eoTermChar          : Char;
    eoMsgInstance       : SmallInt;
    eoEmType            : Byte;  //Maps to TEmailRecipType
    eoEntParamType      : Byte;
    eoOffStart          : SmallInt;
    eoOffEnd            : SmallInt;
    eoEngineCounter     : longint;
    eoRfName            : string[30]; //Range filter name for vrw
    Spare               : Array[1..160] of Char;
  end;

  TElertSMSRec = Record
    esUserID           : String[UIDSize];
    esElertName         : String[30];
    NotUsed             : Array[1..2] of Char;
    esName              : String[20];
    esCountry           : String[6];  //allow plenty of room for future
    esCode              : String[12]; //     "                     "
    esNumber            : String[60]; //     "                     "
    Spare               : Array[1..200] of Char;
  end;

  TElertRecsSentRec = Record
    ersUserID           : String[UIDSize];
    ersElertName        : String[30];
    ersNotUsed          : Array[1..3] of Byte;
    ersID               : String[60];
    ersLineNo           : longint;  //for transaction lines
    ersTermChar         : Char;
    ersFileNo           : SmallInt;
    ersDateLastSent     : TDateTime;
    Spare               : Array[1..265] of Byte;
  end;

  TElertEventRec = Record
    evUserID           : String[UIDSize];
    evElertName        : String[30];
    evInstance         : SmallInt;
    evTermChar         : Char;
    evNotUsed          : Char;
    evKey              : String[60];
    evFileNo           : Byte;
    evWinID            : longint;
    evHandID           : longint;
    Spare              : Array[1..289] of Byte;
  end;

  TElertRespawnRec = Record
    ewUserID           : String[UIDSize];
    ewElertName        : String[30];
    ewInstance         : SmallInt;
    ewPurpose          : Byte;
    ewTimeStamp        : TDateTime;
    Spare              : Array[1..200] of Byte;
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

