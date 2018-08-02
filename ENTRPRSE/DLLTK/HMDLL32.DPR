Library Hmdll32;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  INITDLLU in 'INITDLLU.PAS',
  DLLPFrm1,
  DLL01U,
  DLLMiscU,
  DLLTH_UP,
  DLLSK01U,
  PrntMsgU,
  DllErrU,
  BankU1,
  Uplift,
  DllJobU,
  DLLSrBOM,
  DLLBTGen in 'DLLBTGen.pas',
  TLBatch in 'Tlbatch.pas',
  Crypto in '..\MULTCOMP\Crypto.pas' {$IFDEF WIN32},
  Security in 'Security.pas' {$ENDIF},
  MemMap in '..\R&D\Memmap.pas';

{$I Version.Inc}

{$IFNDEF WIN32}
Type
  ShortString = String;
{$ENDIF}


FUNCTION EX_VERSION : SHORTSTRING; EXPORT; STDCALL;
Begin
  Result := Ver;
End;

{* ========================================================================== *}

EXPORTS

  EX_ERRORDESCRIPTION INDEX 1000,

  {* Print Form starts from 200 onwards.. , 300 .. for internal usage ..*}
  {$IFDEF WIN32}
    Ex_GetRecAddress Index 300,  { DLLMiscU.pas }
    {Ex_GetRecWithAddress Index 301,}  {* Index has been changed as 122 *}

    CS_CHANGEDOCTXLATE INDEX 400,

    EX_INITPRINTFORM INDEX 200,
    EX_ADDTRANSFORM INDEX 201,
    EX_PRINTFORM INDEX 202,
    EX_ENDPRINTFORM INDEX 203,
    EX_PRINTFILETO INDEX 204,  {This is for Internal Usage }
    EX_PRINT2 INDEX 205,       {  "      "       "         }

    { TLBATCH.PAS - 32bit & VB only }

    EX_INITSTRUCTURE    Index 206,
    EX_CREATETLARRAY    Index 207,
    EX_ADDTLARRAYLINE   Index 208,
    EX_DESTROYTLARRAY   Index 209,
    EX_GETTLARRAY       Index 210,
    EX_GETTLARRAYLINE   Index 211,
    EX_EDITTLARRAYLINE  Index 212,
    { Indexes to 219 reserved for VB Functions }

    EX_DEFAULTFORM      Index 220,
    EX_DEFAULTEMAILDETS Index 221,
    EX_PRINTTOEMAIL     Index 222,
  {$ENDIF}

  {---------------------------------------}
  EX_INITDLL INDEX 1,                   { InitDLLU.pas }
  EX_CLOSEDLL INDEX 2,                  { InitDLLU.pas }

  EX_GETACCOUNT  INDEX 3,               { DLL01U.Pas }
  EX_STOREACCOUNT  INDEX 4,             { DLL01U.Pas }
  EX_UNLOCKACCOUNT INDEX 5,             { DLL01U.Pas }
  EX_GETACCOUNTBALANCE INDEX 6,         { DLL01U.Pas }
  EX_STOREDISCMATRIX INDEX 7,           { DLL01U.Pas }
  EX_GETDISCMATRIX INDEX 8,             { DLL01U.Pas }

  EX_INITBTRIEVE INDEX 9,               { InitDLLU.pas }

  EX_GETTRANS INDEX 20,                 { DLLTH_Up.pas }
  EX_STORETRANS INDEX 21,               { DLLTH_Up.pas }
  EX_GETNEXTTRANSNO INDEX 22,           { DLLTH_Up.pas }
  EX_GETTOTALTRANSLINES INDEX 23,       { DLLTH_Up.pas }
  EX_GETTRANSHED INDEX 24,              { DLLTH_Up.pas }
  EX_GETTRANSLINE INDEX 25,             { DLLTH_Up.pas }
  EX_CONVERTFOLIO INDEX 26,             { DLLTH_Up.pas }

  EX_GETSTOCK INDEX 30,                 { DLLSK01U.pas }
  EX_STORESTOCK INDEX 31,               { DLLSK01U.pas }
  EX_UNLOCKSTOCK INDEX 32,              { DLLSK01U.pas }

  EX_VERSION INDEX 33,                  { }

  EX_TESTMODE INDEX 34,                 { InitDLLU.pas }

  EX_GETGLACCOUNT INDEX 44,             { DLL01U.pas }
  EX_STOREGLACCOUNT INDEX 45,           { DLL01U.pas }

  EX_GETSTOCKBOM INDEX 46,              { DLLSrBOM.pas }
  EX_GETLINESERIALNOS INDEX 47,         { DLLSrBOM.pas }

  EX_ACCOUNTFILESIZE INDEX 48,          { DLL01U.pas }
  EX_HASOUTSTANDING INDEX 49,           { DLL01U.pas }

  EX_STORESTOCKBOM INDEX 50,            { DLLSrBOM.pas }

  EX_GETSTKALT INDEX 51,                { DLLSK01U.PAS }

  EX_STORESTKALT INDEX 52,              { DLLSK01U.PAS }

  {* Job Costing functions are in DLLJobU.Pas *}
  {* ----------------------- *}
  EX_GETJOB INDEX 60,
  EX_STOREJOB INDEX 61,
  EX_GETJOBANALYSIS INDEX 62,
  EX_GETJOBEMPLOYEE INDEX 63,
  EX_GETJOBTIMERATE INDEX 64,

  {* ----------------------- *}

  EX_GETSTOCKLOC INDEX 70,              { DLlSK01U.pas }
  EX_STORESTOCKLOC INDEX 71,            { DLlSK01U.pas }
  EX_GETLOCATION INDEX 72,              { DLlSK01U.pas }
  EX_STORELOCATION INDEX 73,            { DLlSK01U.pas }

  EX_ROUNDUP INDEX 74,                  { DLLTH_Up.pas }

  EX_GETMATCH INDEX 75,                 { DLLSK01U.pas }
  EX_STOREMATCH INDEX 76,               { DLLSK01U.pas }

  EX_GETNOTES INDEX 77,                 { DLLSK01U.pas }
  EX_STORENOTES INDEX 78,               { DLLSK01U.pas }

  EX_GETCCDEP INDEX 79,                 { DLLMiscU.pas }

  EX_CALCSTOCKPRICE INDEX 80,           { DLLSK01U.pas }

  EX_GETVATRATE INDEX 81,               { DLLMiscU.pas }

  EX_SILENTLOCK INDEX 82,               { DLLMiscU.pas }

  EX_SETRELEASECODE INDEX 83,           { InitDLLU.pas }

  EX_INITDLLPATH INDEX 84,              { InitDLLU.pas }

  EX_GETTLLINE INDEX 85,                { DLLTH_Up.pas }

  EX_GETDATAPATH INDEX 86,              { InitDLLU.pas }

  EX_GETTHBYFOLIO INDEX 87,             { DLLTH_Up.pas }

  EX_GETTHBYRUNNO INDEX 88,             { DLLTH_Up.pas }

  STORETH INDEX 89,                     { DLLTH_Up.pas }

  EX_GETCURRENCY INDEX 90,              { DLLMiscU.pas }

  EX_GETSYSDATA INDEX 91,               { DLLMiscU.pas }

  EX_STOREAUTOBANK INDEX 92,            { DLLMiscU.pas }

  EX_UPDATEUPLIFT INDEX 93,             { Uplift.Pas }

  EX_STOREEACHBOMLINE INDEX 94,         { DLLSrBOM.pas }

  EX_GETSERIALBATCH INDEX 95,           { DLLSrBOM.Pas }

  EX_STORESERIALBATCH INDEX 96,         { DLLSrBOM.Pas }

  EX_USESERIALBATCH INDEX 97,           { DLLSrBOM.Pas }

  EX_UPDATEUPLIFT2 INDEX 98,            { Uplift.Pas }

  EX_CONVERTAMOUNT INDEX 99,            { DLLTH01U.Pas }

  {* ------- Btrieve functions for internal use - Index 101 to 199 ------------ *}

  EX_BTRIEVEFINDREC INDEX 101,          { DLLBTGEN.pas }

  EX_BTRIEVEGETPOS INDEX 102,           { DLLBTGEN.pas }

  EX_BTRIEVESETPOS INDEX 103,           { DLLBTGEN.pas }

  {* ------- Next number should start from 120 -------- *}

  EX_CHECKPASSWORD INDEX 120,           { DLLMiscU.Pas }
  EX_CLOSEDATA     INDEX 121,           { InitDLLU }
  EX_GETRECORDADDRESS INDEX 122,        { DLLMiscU }
  EX_GETRECWITHADDRESS INDEX 123,       { DLLMiscU }
  EX_BTRIEVERECCOUNT INDEX 124,         { DLLBTGEN }
  EX_STORETRANSHED INDEX 125,           { DLLTH01U }
  EX_GETJOBTYPE INDEX 126,              { DLLJOBU }
  EX_GETLINETOTAL INDEX 127,            { DLLTH01U }
  EX_SETCALCLINECOUNT INDEX 128,        { DLLTH01U }
  EX_OVERRIDEINI INDEX 129,             { INITDLLU }
  EX_TRANCANBEUPDATED INDEX 130,        { DLLTH01U }
  EX_READINIVALUE INDEX 131,            { INITDLLU }
  EX_UNLOCKRECORD INDEX 132,            { DLLMiscU }
  EX_STORETRANSDETL INDEX 133,          { DTLLTH_UP }
  {$IFDEF WIN32}
  EX_CHECKSECURITY INDEX 134,           { SECURITY }
  EX_GETECOMMSDATA INDEX 135,           { DLLMiscU }
  EX_CONV_TCURR INDEX 136,              { DLLTH_UP for Internal Use Only }
  EX_FILESIZE INDEX 137,                { DLLMiscU }
  EX_DATETOENTPERIOD INDEX 138,         { DLLMiscU }

  EX_GETENTDATA INDEX 148;              { R&D\MemMap.Pas }
  {$ENDIF WIN32}

{$R *.RES}

Begin


end.

