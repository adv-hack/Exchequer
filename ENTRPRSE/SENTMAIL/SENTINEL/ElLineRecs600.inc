  TElertEmailAddressRec = Record
    emaUserID          : String[UIDSize];
    emaElertName        : String[30];
    emaInstance          : SmallInt; //  These 5 fields are not uses but are only
    emaOutputType        : Char;     //  to keep indexes compatible for sql
    emaLineNo            : SmallInt; //
    emaDummyLineNo       : longint;   //
    emaTermChar          : Char;     //
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
    eoInstance          : SmallInt;
    eoOutputType        : Char;  //E, S, P, R, C
    eoLineNo            : SmallInt;
    eoDummyLineNo       : longint; //not used - for sql compatibility
    eoTermChar          : Char;
    eoKey               : String[60];

    eoParamType         : Byte; // maps to TElertRangeValType
    eoLine1             : String[255];
    eoLine2             : String[100];
    eoMsgInstance       : SmallInt;
    eoEmType            : Byte;  //Maps to TEmailRecipType
    eoEntParamType      : Byte;
    eoOffStart          : SmallInt;
    eoOffEnd            : SmallInt;
    eoEngineCounter     : longint;
    eoRfName            : string[30]; //Range filter name for vrw
    SysTimeStamp        : TDateTime; //PR 23/10/2008 Added time stamp for SentSys.dat to avoid SQL locking problem
    Spare               : Array[1..152] of Char;
  end;

  TElertSMSRec = Record
    esUserID           : String[UIDSize];
    esElertName         : String[30];
    esInstance         : SmallInt;  /////////////
    esOutputType       : Char;      //  Not used -
    esLineNo           : SmallInt;  //     here to keep indexes compatible for sql
    esDummyLineNo      : longint;   //
    esTermChar         : Char;      //
    esKey              : String[60];/////////////

    esName              : String[20];
    esCountry           : String[6];  //allow plenty of room for future
    esCode              : String[12]; //     "                     "
    esNumber            : String[60]; //     "                     "
    Spare               : Array[1..200] of Char;
  end;

  TElertRecsSentRec = Record
    ersUserID           : String[UIDSize];
    ersElertName        : String[30];
    ersInstance         : SmallInt; //not used
    ersOutputType       : char;     //not used
    ersDummyLineno      : SmallInt; //not used
    ersLineNo           : longint;  //for transaction lines
    ersTermChar         : Char;
    ersID               : String[60];

    ersFileNo           : SmallInt;
    ersDateLastSent     : TDateTime;
    Spare               : Array[1..265] of Byte;
  end;

  TElertEventRec = Record
    evUserID           : String[UIDSize];
    evElertName        : String[30];
    evInstance         : SmallInt;
    evOutputType       : Char;     //  Not used -
    evLineNo           : SmallInt; //     here to keep indexes compatible for sql
    evDummyLineNo      : longint;   //
    evTermChar         : Char;
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
    ewOutputType       : Char;      //----------
    ewLineNo           : SmallInt;  //  Not used -
    ewDummyLineNo      : longint;   //    here to keep indexes compatible for sql
    ewTermChar         : Char;      //
    ewKey              : String[60];//-----------

    ewPurpose          : Byte;
    ewTimeStamp        : TDateTime;
    Spare              : Array[1..200] of Byte;
  end;
