unit LicRec;

{ Contains the Licence Structures and Constants, replaces LicGlob.Pas }

{ HM 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$IFDEF WIN32}
  {$ALIGN 1}  { Variable Alignment Disabled }
{$ENDIF}

interface

Uses SerialU;   { in x:\entrprse\multcomp\ }


{$IFNDEF WIN32}

Type
  SmallInt = Integer;

{$ENDIF}


Const
  // Database Types
  dbBtrieve = 0;
  dbMSSQL = 1;

  { Modules indices in the licModules array }
  modAccStk      = 1;             {  Account Stock Analysis }
  modImpMod      = 2;             { Import Module }
  modJobCost     = 3;             { Job Costing }
  modODBC        = 4;             { ODBC }
  modRepWrt      = 5;             { Report Writer }
  modTeleSale    = 6;             { Telesales }
  modToolDLL     = 7;             { Toolkit DLL (Developer) }
  modToolDLLR    = 8;             { Toolkit DLL (Runtime) }
  modEBus        = 9;             { eBusiness }
  modPaperless   = 10;            { Paperless Module }
  modOLESave     = 11;            { OLE Save Functions }
  modCommit      = 12;            { Commitment Accounting }
  modTrade       = 13;            { Trade Counter }
  modStdWOP      = 14;            { Standard Works Order Processing }
  modProWOP      = 15;            { Professional Works Order Processing }
  modElerts      = 16;            { Sentimail Module }
  modEnhSec      = 17;            { Enhanced Security }
  modCISRCT      = 18;            { Job Costing CIS/RCT }
  modAppVal      = 19;            { Job Costing Applications & Valuations }
  modFullStock   = 20;            { v5.61 - Full Stock (Description Only id net present) }
  modVisualRW    = 21;            { v5.61 - Visual Report Writer }
  modGoodsRet    = 22;            { v5.70 - Goods Returns }
  modEBanking    = 23;            { v5.71 - E-Banking }
  modOutlookDD   = 24;            { v5.71 - Outlook Dynamic Dashboard }
  // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
  modGDPR        = 25;            { 2018-R1 - GDPR }
  modPervEncrypt = 26;            { 2018-R1 - Pervasive File Encryption }
  modLast        = modPervEncrypt;  { Max 30 }

  { Modules indices in the licModules array }
  ucCompanies    = 1;              { Company Count for MCM }
  ucToolkit30    = 2;              { Toolkit DLL - 30-day User Count }
  ucToolkitFull  = 3;              { Toolkit DLL - Full User Count }
  ucTradeCounter = 4;              { Trade Counter User Count }
  ucElerts       = 5;              { Available Elerts }
  ucLast         = ucElerts;       { Max 20 }

  { HM 08/01/02: Added special entry for Enterprise 30-Day User count for MCM routines only }
  ucEnterprise30 = 21;           { Index of Enterprise 30-Day user count in MCM Company Options array }

  { Set containing the 30-Day User Counts }
  uc30DaySet     = [ucToolkit30, ucEnterprise30];

{$IFDEF WIN32}
  { Modules which can be auto-detected during upgrades }
  modAutoSet  = [modAccStk,     modJobCost,     modRepWrt,
                 modTeleSale,   modToolDLL,     modToolDLLR,
                 modEBus,       modPaperless,   modOLESave,
                 modCommit,     modTrade,       modElerts,
                 modEnhSec,     modCISRCT,      modAppVal,
                 modFullStock,  modVisualRW,    modEBanking,
                 modImpMod];
{$ENDIF}

  { Licence file name }
  LicFile      = 'ENTRPRSE.LIC';

  { Current Licence Version }
  LicVer431    = 3;
  LicVer440    = 4;
  LicVer600    = 5;
  LicVer70     = 6;
  // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
  LicVer2018R1 = 7;
  CurrLicVer   = LicVer2018R1;


Type
  // MH 16/11/2012 v7.0: Added support for Small Business Edition
  TExchequerEdition = (eeStandard=0, eeSmallBusiness=1);

  //------------------------------

  { Array of bytes representing the Exchequer Site Number }
  ESNByteArrayType = Array[1..8] Of Byte;

  //-------------------------------------------------------------------------

  { Old v4.30c/v4.31 CD Licence and Enterprise Licence Structure }
  Old431LicenceRecType = Record
    { Dialog 1 - Type }
    licLicType     : Byte;            { 0=Customer/End-User, 1=Demo/Reseller, 2=Standard Demo }
    licType        : Byte;            { 0=Install, 1=Upgrade, 2=Auto-Upgrade }
    licCountry     : Byte;            { 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA }

    { Dialog 2 - Customer Details }
    licCompany     : String [45];     { Company Name }
    licISN         : ESNByteArrayType;    { Installation Serial Number }

    { Dialog 3 - CD Serial Number }
    licSerialNo    : SerialNoStrType;

    { Dialog 4 - Enterprise Version }
    licEntCVer     : Byte;            { 0-Prof, 1-Euro, 2-MC }
    licEntModVer   : Byte;            { 0-Basic, 1-Stock, 2-SPOP }
    licEntClSvr    : Byte;            { 0-Non C/S, 1=C/S, 2=Workgroup }
    licUserCnt     : SmallInt;        { User Count }

    { Dialog 5 - Client-Server Engine }
    licClServer    : Byte;            { 0-None, 1=NT, 2=Netware }
    licCSUserCnt   : SmallInt;        { Client-Server Engine User Count }

    { Dialog 6 - Modules - see above for indices }
    licModules     : Array[1..30] Of Byte; { 0-No, 1-30-Day, 2-Full }

    {  }
    {$IFDEF WIN32}
    licExpiry      : TDateTime;       { Licence Expiry date }
    {$ELSE}
    licExpiry      : Double;          { Licence Expiry date }
    {$ENDIF}

    { HM 29/07/99: Added Dealer name }
    licDealer      : String[30];      { Dealer Description }

    { HM 30/07/99: Added Options for backdoors, etc... }
    licOptions     : Array [1..1] Of Byte;   { 1: Reset Mod Rel Codes - 0=False, 1=True }

    { HM 25/08/99: Added secondary ESN to handle multi-site situations }
    licESN2        : ESNByteArrayType;    { Installation Serial Number }

    { HM 22/11/99: Added Options for backdoors, etc... }
    licResetCountry : Boolean;         { Reset Country Code during upgrades }

    licSpare        : Array [1..90] Of Char;
  End; { Old431LicenceRecType }

  //-------------------------------------------------------------------------

  { Enterprise v4.40 CD Licence structure - Entrprse.Lic }
  { NOTE: licCopyLicence in ExCommon\LicFuncU must be    }
  {       updated whenever this structure is changed.    }
  Old440LicenceRecType = Record
    { Dialog 1 - Type }
    licLicType      : Byte;            { 0=Customer/End-User, 1=Demo/Reseller, 2=Standard Demo }
    licType         : Byte;            { 0=Install, 1=Upgrade, 2=Auto-Upgrade }
    licCountry      : Byte;            { 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA }

    { Dialog 2 - Customer Details }
    licCompany      : String [45];       { Company Name }
    licDealer       : String [30];       { Dealer Description }
    licESN          : ESNByteArrayType;  { Exchequer Site Number 1 }
    licESN2         : ESNByteArrayType;  { Exchequer Site Number 2 }

    { Dialog 3 - CD Serial Number }
    licSerialNo     : SerialNoStrType;

    { Dialog 4 - Enterprise Version }
    licEntCVer      : Byte;            { 0-Prof, 1-Euro, 2-MC }
    licEntModVer    : Byte;            { 0-Basic, 1-Stock, 2-SPOP }
    licEntClSvr     : Byte;            { 0-Non C/S, 1=C/S }
    licUserCnt      : SmallInt;        { Enterprise User Count }

    { Dialog 5 - Client-Server Engine }
    licClServer     : Byte;            { 0-None, 1=NT, 2=Netware }
    licCSUserCnt    : SmallInt;        { Client-Server Engine User Count }

    { Dialog 6 - Modules - see above for indices }
    licModules      : Array [1..30] Of Byte;      { 0-No, 1-30-Day, 2-Full }
    licUserCounts   : Array [1..20] Of SmallInt;  { Module User Counts }

    { Licence Expiry Date - not currently used }
    licExpiry       : Double;          { Actually TDateTime but stored as Double for DOS compatibility }

    { Misc Backdoor options }
    licResetModRels : Boolean;         { Reset Mod Rel Codes During Upgrade }
    licResetCountry : Boolean;         { Reset Country Code during upgrades }

    { HM 06/07/01: Added Issue Number to make expiring Auto-Upgrades easier }
    licAutoUpgIssue : SmallInt;        { Auto-Upgrade Issue Number }

    { HM 02/10/03: Extended for Pervasive.SQL 8 }
    licPSQLLicKey   : String[30];      { P.SQL v8 licence string (C/s + WGE) }
    licPSQLWGEVer   : Byte;            { 0=Not Licenced, 1=P.SQL WGE v8,  }

    // HM 23/08/04: Added Edition for v5.61
    licEntEdition   : SmallInt;

    // MH 22/11/05: Added Product Type flag to differentiate between Exchequer & LITE
    licProductType  : Byte;            { 0=Exchequer, 1=LITE Customer, 2=LITE Accountant}

    // MH 20/11/05: Added CD Key for IRIS licencing
    licCDKey        : String[25];      // five blocks of five chars - separators removed to reduce space required

    { Spare for future use }
    licSpare        : Array [1..337] Of Char;
  End; // Old440LicenceRecType

  //-------------------------------------------------------------------------

  // Enterprise v6.00 CD Licence structure - Entrprse.Lic
  //
  // NOTE: licCopyLicence in ExCommon\LicFuncU must be updated whenever this structure is changed.
  //
  CDLicenceRecType = Record
    { Dialog 1 - Type }
    licLicType      : Byte;            { 0=Customer/End-User, 1=Demo/Reseller, 2=Standard Demo }
    licType         : Byte;            { 0=Install, 1=Upgrade, 2=Auto-Upgrade }
    licCountry      : Byte;            { 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA }

    { Dialog 2 - Customer Details }
    licCompany      : String [45];       { Company Name }
    licDealer       : String [30];       { Dealer Description }
    licESN          : ESNByteArrayType;  { Exchequer Site Number 1 }
    licESN2         : ESNByteArrayType;  { Exchequer Site Number 2 }

    { Dialog 3 - CD Serial Number }
    licSerialNo     : SerialNoStrType;

    { Dialog 4 - Enterprise Version }
    licEntDB        : Byte;            // EX600 - 0-Btrieve, 1-MS SQL
    licEntCVer      : Byte;            { 0-Prof, 1-Euro, 2-MC }
    licEntModVer    : Byte;            { 0-Basic, 1-Stock, 2-SPOP }
    licEntClSvr     : Byte;            { 0-Non C/S, 1=C/S }
    licUserCnt      : SmallInt;        { Enterprise User Count }

    { Dialog 5 - Client-Server Engine }
    licClServer     : Byte;            { 0-None, 1=NT, 2=Netware }
    licCSUserCnt    : SmallInt;        { Client-Server Engine User Count }

    { Dialog 6 - Modules - see above for indices }
    {$IFDEF LIC600}
    licModules      : Array[1..60] Of Byte; { EX600 - 0-No, 1-30-Day, 2-Full }
    {$ELSE}
    licModules      : Array[1..30] Of Byte; { 0-No, 1-30-Day, 2-Full }
    {$ENDIF}
    licUserCounts   : Array [1..20] Of SmallInt;  { Module User Counts }

    { Licence Expiry Date - not currently used }
    licExpiry       : Double;          { Actually TDateTime but stored as Double for DOS compatibility }

    { Misc Backdoor options }
    licResetModRels : Boolean;         { Reset Mod Rel Codes During Upgrade }
    licResetCountry : Boolean;         { Reset Country Code during upgrades }

    { HM 06/07/01: Added Issue Number to make expiring Auto-Upgrades easier }
    licAutoUpgIssue : SmallInt;        { Auto-Upgrade Issue Number }

    { HM 02/10/03: Extended for Pervasive.SQL 8 }
    licPSQLLicKey   : String[30];      { P.SQL v8 licence string (C/s + WGE) }
    licPSQLWGEVer   : Byte;            { 0=Not Licenced, 1=P.SQL WGE v8,  }

    // HM 23/08/04: Added Edition for v5.61
    licEntEdition   : SmallInt;

    // MH 22/11/05: Added Product Type flag to differentiate between Exchequer & LITE
    licProductType  : Byte;            { 0=Exchequer, 1=LITE Customer, 2=LITE Accountant}

    // MH 20/11/05: Added CD Key for IRIS licencing
    licCDKey        : String[25];      // five blocks of five chars - separators removed to reduce space required

    // MH 16/11/2012 v7.0: Added support for Small Business Edition
    licExchequerEdition : TExchequerEdition;

    { Spare for future use }
    licSpare        : Array [1..499] Of Char;
  End; // CDLicenceRecType

  //=========================================================================

  { Enterprise v4.40 Licence structure - Entrprse.Dat }
  { NOTE: licCopyLicence in ExCommon\LicFuncU must be }
  {       updated whenever this structure is changed. }
  OldEnt440LicenceRecType = Record
    { Dialog 1 - Type }
    licLicType      : Byte;             { 0=Customer/End-User, 1=Demo/Reseller, 2=Standard Demo }
    licType         : Byte;             { 0=Install, 1=Upgrade, 2=Auto-Upgrade }
    licCountry      : Byte;             { 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA }

    { Dialog 2 - Customer Details }
    licCompany      : String [45];      { Company Name }
    licISN          : ESNByteArrayType; { Installation Serial Number }

    { Dialog 3 - CD Serial Number }
    licSerialNo     : SerialNoStrType;

    { Dialog 4 - Enterprise Version }
    licEntCVer      : Byte;             { 0-Prof, 1-Euro, 2-MC }
    licEntModVer    : Byte;             { 0-Basic, 1-Stock, 2-SPOP }
    licEntClSvr     : Byte;             { 0-Non C/S, 1=C/S }
    licUserCnt      : SmallInt;         { Enterprise User Count }

    { Dialog 5 - Client-Server Engine }
    licClServer     : Byte;             { 0-None, 1=NT, 2=Netware }
    licCSUserCnt    : SmallInt;         { Client-Server Engine User Count }

    { Dialog 6 - Modules - see above for indices }
    licModules      : Array[1..30] Of Byte; { 0-No, 1-30-Day, 2-Full }

    { Licence Expiry Date - not currently used }
    licExpiry       : Double;           { Actually TDateTime but stored as Double for DOS compatibility }

    { HM 29/07/99: Added Dealer name }
    licDealer       : String[30];       { Dealer Description }

    { HM 30/07/99: Added Options for backdoors, etc... }
    licResetModRels : Boolean;          { Reset Mod Rel Codes - 0=False, 1=True }

    { HM 25/08/99: Added secondary ESN to handle multi-site situations }
    licESN2         : ESNByteArrayType; { Installation Serial Number }

    { HM 22/11/99: Added Options for backdoors, etc... }
    licResetCountry : Boolean;          { Reset Country Code during upgrades }

    { HM 20/06/01: Added User Counts array for v4.40 }
    licUserCounts   : Array [1..20] Of SmallInt;  { Module User Counts }

    { HM 06/07/01: Added Issue Number to make expiring Auto-Upgrades easier }
    licAutoUpgIssue : SmallInt;        { Auto-Upgrade Issue Number }

    { HM 07/10/03: Extended for Pervasive.SQL 8 }
    licPSQLWGEVer   : Byte;            { 0=Not Licenced, 1=P.SQL WGE v8,  }

    // MH 22/11/05: Added Product Type flag to differentiate between Exchequer & LITE
    licProductType  : Byte;            { 0=Exchequer, 1=LITE Customer, 2=LITE Accountant }

    // MH 20/11/05: Added CD Key for IRIS licencing
    licCDKey        : String[25];      // five blocks of five chars - separators removed to reduce space required

    // HM 06/03/06: Added Edition into Enterprise Licence as needed for LITE
    licEntEdition   : SmallInt;

    licSpare        : Array [1..18] Of Char;
  End; { OldEnt440LicenceRecType }

  {------------------------------------------------------------------}

  // Exchequer v6.00 Licence structure - Entrprse.Dat
  //
  // NOTE: licCopyLicence in ExCommon\LicFuncU must be updated whenever this structure is changed.
  //
  EntLicenceRecType = Record
    { Dialog 1 - Type }
    licLicType      : Byte;             { 0=Customer/End-User, 1=Demo/Reseller, 2=Standard Demo }
    licType         : Byte;             { 0=Install, 1=Upgrade, 2=Auto-Upgrade }
    licCountry      : Byte;             { 0=Any, 1=UK, 2=NZ, 3=Sing, 4=Aus, 5=EIRE, 6=RSA }

    { Dialog 2 - Customer Details }
    licCompany      : String [45];      { Company Name }
    licISN          : ESNByteArrayType; { Installation Serial Number }

    { Dialog 3 - CD Serial Number }
    licSerialNo     : SerialNoStrType;

    { Dialog 4 - Enterprise Version }
    {$IFDEF LIC600}
    licEntDB        : Byte;             // EX600 - 0-Btrieve, 1-MS SQL
    {$ENDIF}
    licEntCVer      : Byte;             { 0-Prof, 1-Euro, 2-MC }
    licEntModVer    : Byte;             { 0-Basic, 1-Stock, 2-SPOP }
    licEntClSvr     : Byte;             { 0-Non C/S, 1=C/S }
    licUserCnt      : SmallInt;         { Enterprise User Count }

    { Dialog 5 - Client-Server Engine }
    licClServer     : Byte;             { 0-None, 1=NT, 2=Netware }
    licCSUserCnt    : SmallInt;         { Client-Server Engine User Count }

    { Dialog 6 - Modules - see above for indices }
    {$IFDEF LIC600}
    licModules      : Array[1..60] Of Byte; { EX600 - 0-No, 1-30-Day, 2-Full }
    {$ELSE}
    licModules      : Array[1..30] Of Byte; { 0-No, 1-30-Day, 2-Full }
    {$ENDIF}

    { Licence Expiry Date - not currently used }
    licExpiry       : Double;           { Actually TDateTime but stored as Double for DOS compatibility }

    { HM 29/07/99: Added Dealer name }
    licDealer       : String[30];       { Dealer Description }

    { HM 30/07/99: Added Options for backdoors, etc... }
    licResetModRels : Boolean;          { Reset Mod Rel Codes - 0=False, 1=True }

    { HM 25/08/99: Added secondary ESN to handle multi-site situations }
    licESN2         : ESNByteArrayType; { Installation Serial Number }

    { HM 22/11/99: Added Options for backdoors, etc... }
    licResetCountry : Boolean;          { Reset Country Code during upgrades }

    { HM 20/06/01: Added User Counts array for v4.40 }
    licUserCounts   : Array [1..20] Of SmallInt;  { Module User Counts }

    { HM 06/07/01: Added Issue Number to make expiring Auto-Upgrades easier }
    licAutoUpgIssue : SmallInt;        { Auto-Upgrade Issue Number }

    { HM 07/10/03: Extended for Pervasive.SQL 8 }
    licPSQLWGEVer   : Byte;            { 0=Not Licenced, 1=P.SQL WGE v8,  }

    // MH 22/11/05: Added Product Type flag to differentiate between Exchequer & LITE
    licProductType  : Byte;            { 0=Exchequer, 1=LITE Customer, 2=LITE Accountant }

    // MH 20/11/05: Added CD Key for IRIS licencing
    licCDKey        : String[25];      // five blocks of five chars - separators removed to reduce space required

    // HM 06/03/06: Added Edition into Enterprise Licence as needed for LITE
    licEntEdition   : SmallInt;

    // MH 16/11/2012 v7.0: Added support for Small Business Edition
    licExchequerEdition : TExchequerEdition;

    {$IFDEF LIC600}
    licSpare        : Array [1..499] Of Char; // EX600
    {$ELSE}
    licSpare        : Array [1..18] Of Char;
    {$ENDIF}
  End; { EntLicenceRecType }

  //-------------------------------------------------------------------------

implementation
(*
Uses Dialogs, SysUtils;

Initialization
  ShowMessage ('Old431LicenceRecType: ' + IntToStr(SizeOf(Old431LicenceRecType)) + #13 +
               'CDLicenceRecType: ' + IntToStr(SizeOf(CDLicenceRecType)) + #13 +
               'EntLicenceRecType: ' + IntToStr(SizeOf(EntLicenceRecType)));
(*               
*)
end.
