Library Entdll32;

{$REALCOMPATIBILITY ON}
{$WARN SYMBOL_PLATFORM OFF}
uses
  {$IFDEF TC}
  ShareMem,
  {$ENDIF}
  INITDLLU in 'INITDLLU.PAS',
  DLL01U in 'DLL01U.PAS',
  DLLMiscU in 'DLLMiscU.PAS',
  DLLTH_UP in 'DLLTH_UP.PAS',
  DLLSK01U in 'DLLSK01U.PAS',
  PrntMsgU in 'PrntMsgU.PAS',
  DllErrU in 'DllErrU.PAS',
  BankU1 in 'BankU1.PAS',
  Uplift in 'Uplift.PAS',
  DllJobU in 'DllJobU.PAS',
  DLLSrBOM in 'DLLSrBOM.PAS',
  DLLBTGen in 'DLLBTGen.pas',
  TLBatch in 'Tlbatch.pas',
  Crypto in 'x:\Entrprse\MULTCOMP\Crypto.pas',
  MemMap in '..\R&D\MemMap.pas',
  Security in 'Security.pas',
  MLocFunc in 'MLocFunc.pas',
  oMCMSec in 'x:\Entrprse\MULTCOMP\OMCMSEC.PAS',
  UserProf in 'UserProf.pas',
  DelQuote in 'DelQuote.pas',
  PRNTFRM5 in 'PRNTFRM5.PAS',
  TKIntf in 'x:\Entrprse\FORMDES2\TKINTF.PAS',
  links in 'links.pas',
  dll_conv in 'dll_conv.pas',
  dllbin in 'dllbin.pas',
  VarCnst3 in 'VarCnst3.pas',
  EBusTKit in 'EBusTKit.pas',
  SpDllErr in 'SPDLLERR.PAS',
  GlobVar in 'GlobVar.pas',
  ErrLogs in 'ErrLogs.pas',
  VarConst in 'VarConst.pas',
  BTS1 in 'BTS1.pas',
  Fifolu in 'FIFOLU.PAS',
  CISFuncs in 'CISFUNCS.PAS',
  Validate in 'Validate.pas',
  spdlintf in 'SpDlIntf.pas',
  dll_abstl in 'dll_abstl.pas',
  DLSQLSup in 'DLSQLSup.pas',
  TransCancelF in '\Entrprse\R&D\OrderPayments\TransCancelF.pas',
  DLLMultiBuy in 'DLLMultiBuy.pas',
  IntrastatXML in '\Entrprse\R&D\Intrastat\IntrastatXML.pas',

  //PR: 05/09/2017 Added for password complexity changes v2017 R2
  PasswordComplexityConst in 'w:\Entrprse\R&D\Password Complexity\PasswordComplexityConst.pas',
  SHA3_256 in 'w:\Compon\SHA3_256Hash\SHA3_256.pas',
  Mem_Util in 'w:\Compon\SHA3_256Hash\Mem_Util.pas',
  Hash in 'w:\Compon\SHA3_256Hash\Hash.pas',
  BTypes in 'w:\Compon\SHA3_256Hash\BTypes.pas',
  SHA3 in 'w:\Compon\SHA3_256Hash\SHA3.pas';

{*V5TKSMEM - Switched from DLLPFRM1 to PRNTFRM5}

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

  EX_GETLASTERRORDESC INDEX 1001,

  {* Print Form starts from 200 onwards.. , 300 .. for internal usage ..*}
  {$IFDEF WIN32}
    Ex_GetRecAddress Index 300,  { DLLMiscU.pas }
    {Ex_GetRecWithAddress Index 301,}  {* Index has been changed as 122 *}

    { HM 24/10/00: Added for Windows Card System }
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

  {$ENDIF}

  {---------------------------------------}
  EX_INITDLL INDEX 1,                   { InitDLLU.pas }
  EX_CLOSEDLL INDEX 2,                  { InitDLLU.pas }
  EX_INITDLLWAIT INDEX 153,             { InitDLLU.pas }

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

  EX_CONVERTAMOUNT INDEX 99,            { DLLTH_Up.Pas }

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
  EX_STORETRANSHED INDEX 125,           { DLLTH_Up }
  EX_GETJOBTYPE INDEX 126,              { DLLJOBU }
  EX_GETLINETOTAL INDEX 127,            { DLLTH_Up }
  EX_SETCALCLINECOUNT INDEX 128,        { DLLTH_Up }
  EX_OVERRIDEINI INDEX 129,             { INITDLLU }
  EX_TRANCANBEUPDATED INDEX 130,        { DLLTH_Up }
  EX_READINIVALUE INDEX 131,            { INITDLLU }
  EX_UNLOCKRECORD INDEX 132,            { DLLMiscU }
  EX_STORETRANSDETL INDEX 133,          { DTLLTH_UP }
  {$IFDEF WIN32}
  EX_CHECKSECURITY INDEX 134,           { SECURITY }
  EX_GETECOMMSDATA INDEX 135,           { DLLMiscU }
  EX_CONV_TCURR INDEX 136,              { DLLTH_UP for Internal Use Only }
  EX_FILESIZE INDEX 137,                { DLLMiscU }
  EX_DATETOENTPERIOD INDEX 138,         { DLLMiscU }
  EX_DEFAULTFORM INDEX 139,             { DLLPFrm1 }
  EX_DEFAULTEMAILDETS INDEX 140,        { DLLPFrm1 }
  EX_PRINTTOEMAIL INDEX 141,            { DLLPFrm1 }

  EX_CALCULATETRANSTOTAL INDEX 142,     { DLLTH_UP }
  EX_STOREEBUSTRANS INDEX 143,          { DLLTH_UP }
  EX_CALCLINETAX INDEX 144,             { DLLTH_UP }
  EX_GETCORRECTVATCODE INDEX 145,       { DLLTH_UP }

  EX_GETSTOCKBYFOLIO INDEX 146,         { DLLSK01U }
  EX_GETEBUSTRANS INDEX 147,            { DLLTH_UP }
  EX_GETENTDATA INDEX 148,              { R&D\MemMap.Pas }
  EX_UPDATEDUEDATE INDEX 149,           { DLLTH_UP }
  EX_GETTAXWORD INDEX 150,              {DllMiscU}
  EX_CHECKMODULERELEASECODE INDEX 151,  {DllMiscU}
  EX_REMOVEDISCOUNTS INDEX 152,         { DLLTH_UP }

  // DelQuote - Enterprise v5.00 Quote Deletion function
  EX_DELETEQUOTE                        Index 154,

  EX_DELETEDISCMATRIX Index 155,        { DLL01U }

  EX_GETCOMPANYID                       Index 156,

  // UserProf - Enterprise v5.00 User Profiles
  EX_GETUSERPROFILE                     Index 500,

  EX_STORECURRENCY                        Index 157,

  EX_UPDATEPAYINREF                      Index 158, { DLLTH_UP }

  EX_GETLINK                            Index 159,  {Links}
  EX_STORELINK                          Index 160,  {Links}
  EX_DELETELINK                         Index 161,  {Links}
  EX_UPDATELINEDATE                     Index 162,  {DLLTH_UP}
  {$IFNDEF CONV}
  EX_UNUSESERIALBATCH                   Index 163,  {DLLSrBOM}
  {$ELSE}
  EX_UNUSESERIALBATCH                   Index 163,  {DLLSrBOM}
  EX_CHECKCONVERSION                    Index 164,  {Dll_Conv}
  EX_CONVERTTRANSACTION                 Index 165,  {Dll_Conv}
  EX_BACKTOBACKORDER                    Index 166,  {Dll_Conv}
  {$ENDIF}
  EX_STOREJOBEMPLOYEE                   Index 167,  {DllJobU}
  EX_STOREJOBANALYSIS                   Index 168,  {DllJobU}
  EX_STOREJOBTYPE                       Index 169,  {DllJobU}
  EX_STOREJOBTIMERATE                   Index 170,  {DllJobU}
  EX_DELETEMATCH                        Index 171,  {DllSk01U}
  EX_GETMULTIBIN                        Index 172,  {DllBin}
  EX_STOREMULTIBIN                      Index 173,  {DllBin}
  EX_USEMULTIBIN                        Index 174,  {DllBin}
  EX_UNUSEMULTIBIN                      Index 175,  {DllBin}
  EX_SETJAINVOICEDFLAG                  Index 176,  {DllJobU}
  EX_UPDATECISDATE                      Index 177,  {Dllth_Up}
  EX_RESETLINESERIALCOUNT               Index 178,  {Dllth_Up}
  EX_DELETESERIALBATCH                  Index 179,  {DLLSrBOM}
  EX_UPDATESERIALBATCHCOST              Index 180,  {DLLSrBOM}
  EX_RESETADJNOMFLAGS                   Index 181,  {Dllth_Up}
  EX_SETLINEGLCODE                      Index 182,  {Dllth_Up}

  {$IFDEF GMGSPECIAL}
  EX_GMGRESETSTOCKGLS                   Index 183,   {Dllth_Up}
  {$ENDIF}

  EX_UPDATERECONCILEFLAG                Index 184,   {Dllth_Up}
  EX_UPDATEPRINTEDSTATUS                Index 185,   {Dllth_Up}
  EX_DELETESTOCK                        Index 186,   {DLLSK01U.pas}
  EX_UPDATETXFIELD                      Index 187,   {Dllth_Up}
  EX_INCLUDEHIDDENLINES                 Index 188,   {Dllth_Up}
  EX_GETLINEVALUE                       Index 189,   {Dllth_Up}
  EX_UPDATEINVALIDMATCHES               Index 190,   {DLLSK01U.pas}
  EX_UPPERCASESTOCKLOCATIONS            Index 191,   {Dllth_Up}
  EX_SETSTOCKLOCATIONS                  Index 192,   {Dllth_Up}
  EX_UPDATEAUDITDATE                    Index 193,   {DllMiscU}
  EX_DELETEFIFO                         Index 194,   {DllSk01U}
  EX_GETMULTIBUY                        Index 195,   {DllMultiBuy}
  EX_STOREMULTIBUY                      Index 196,   {DllMultiBuy}
  EX_DELETEMULTIBUY                     Index 197,   {DllMultiBuy}

  EX_UPDATEACSTOCKANAL                  Index 198;    {Dllth_Up}
  {$ENDIF WIN32}

{$R *.RES}

Begin


end.

