// Turn word alignment off
{$A-}
const
  FaxF =  17;

  APFPrefix = '-++-';

type
  TFaxStatus = (fxsUnknown, fxsUrgent, fxsNormal, fxsOffPeak, fxsArchive, fxsFail);
  TKnownFaxStatus = fxsUrgent..fxsFail;
  TFaxPriority = fxsUrgent..fxsOffPeak;
  TFaxSubDirs = array[TKnownFaxStatus] of string[20];

  // 1 record per page of 1024
  TFaxDetails = record
    // Keys ...
    FaxDocName       : string[80];  // Document name as would appear in print spooler
    FaxAPFName       : string[12];  // DOS 8.3 File name; extension = APF
    FaxUserName      : string[20];  // This is the Login Name of the user

    // Other data ...
    FaxCancel        : boolean;     // = true => don't send fax and delete associated *.APF
    FaxHold          : boolean;     // = true => Hold Fax
    FaxNumber        : string[20];  // Fax number to dial
    FaxPriority      : char;        // 'N'ormal, 'U'rgent, 'O'ff-peak (see below)
    FaxUserDesc      : string[80];  // User's description of the document
    FaxFinishTime    : TDateTime;   // Time fax finished / failed sending
    FaxSenderName    : string[40];  //
    FaxRecipientName : string[40];  //
    FaxSenderEmail   : string[100]; // E-mail address of fax sender for notification
    FaxErrorCode     : longint;
    FaxBusyRetries   : Byte;     // Retry Fax Later (time specified by user)
                                    // e.g. 10 means 10 retries left to do
    FaxDontSendMeYet : Boolean;
    FaxSenderTimeStamp
                     : TDateTime; 
  end;
  PFaxDetails = ^TFaxDetails;
  // Fax priority is NOT maintained.  It is used initially to determine which
  // directory the APF file will appear in.  Subsequently, the directory determines
  // the priority.

  TFaxParams = record
    FaxServerRoot        : string[80];  // Server's local path to fax root drive
    FaxClientRoot        : string[80];  // Client's pathed map to fax root drive on server
    FaxCheckFreq         : longint;     // In minutes
    FaxDeviceName        : string[80];  // Device name
    FaxExtLine           : string[8];   // Number to dial to get an outside line
    FaxOffPeakStart      : TDateTime;   // Time off peak period starts
    FaxOffPeakEnd        : TDateTime;   // Time off peak period ends
    FaxSendAction        : char;        // On successful send ... 'A'rchive or 'D'elete
    FaxDialAttempts      : word;
    FaxDialRetryWait     : word;        // in seconds
    FaxConnectWait       : word;        // in seconds
    FaxStationID         : string[20];  // Best faxing compatibility if sender's number only
    FaxHeaderLine        : string[80];  // Optional header line - see Async Pro manual
    FaxEmailAvail        : boolean;
    FaxEmailType         : char;        // 'M' = MAPI, 'S' = SMTP
    FaxSMTPServerName    : string[40];
    FaxSenderNotify      : char;        // 'A'lways, 'F'ailure only, 'N'ever
    FaxAdminEmail        : string[100];
    FaxAdminNotify       : char;        // 'S'ize of directory, 'F'ile number, 'B'oth, 'N'one
    FaxAdminEmailDefault : boolean;     // If fax fails and no sender E-mail, send to Admin ?
    FaxAdminCheckFreq    : longint;     // In milliseconds
    FaxAdminAvailFrom    : TDateTime;   // Time fax administrator available from
    FaxAdminAvailTo      : TDateTime;   // Time fax administrator available to
    FaxArchiveSize       : longint;     // If archive directory exceeds x MB warn Admin
    FaxArchiveNum        : word;        // If archive directory exceeds x files warn Admin
    FaxSubDirs           : TFaxSubDirs;
    FaxAdminPass         : String[8]; // NF : Administrator Password (encrypted}
    FaxSystemPass        : String[8]; // NF : System Password (encrypted}
    FaxRetryMins         : integer;
    FaxNoOfRetries       : Byte;
    FaxDownTimeStart     : TDateTime;   // Down Time Start Time (for Back-Ups)
    FaxDownTimeEnd       : TDateTime;   // Down Time End Time (for Back-Ups)
    FaxModemInit : String[30];
    FaxSenderEmailAddress : String[50];
    FaxPort              : Byte;        // PR: Added for v6 to allow use of FaxManJr
    iFaxClass            : Byte;        //1, 2, 3 (= 2.0)
    FaxVersion           : Byte;        //Start at 1 for FaxManJr control
  end;
  PFaxParams = ^TFaxParams;

  TFaxCounter = record
    FaxCurCounter : longint;
  end;

  TFaxRef = record
    FaxUniqueRef : string[6];
  end;

  TFaxRec = record
    FaxRecType : char; // 'P'arams, 'D'etails, 'C'ounters, 'S'erver running, 'U'nique ref
    case byte of
      1: (FaxDetails : TFaxDetails); // Multiple records
      2: (FaxParams  : TFaxParams);  // Single record
      3: (FaxCounter : TFaxCounter); // Single record
      4: (FaxRef     : TFaxRef);     // Single record
      5: (FaxRecSize : array[1..979] of char);  // sizes the record to 980
  end;

 {-$IF not (Defined(FAXNOW3) or Defined(FAXNOW5))}

 {$IFNDEF FAXNOW3}
   {$IFNDEF FAXNOW5}
     Fax_FileDef =
        record
          RecLen,
          PageSize,
          NumIndex  :  SmallInt;
          NotUsed   :  LongInt;
          Variable  :  SmallInt;
          Reserved  :  array[1..4] of char;
          KeyBuff   :  array[1..7] of KeySpec;
          AltColt   :  AltColtSeq;
        end; // Fax_FileDefunit
   {$ENDIF}
 {$ENDIF}

