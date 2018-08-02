Unit VarConst;




{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 31/07/90                      }
{                                                              }
{               Global variables & Type definitions            }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}



Interface

{$H-}

{$REALCOMPATIBILITY ON}

{$ALIGN 1}

Uses
  Graphics,
  WinTypes,
  GlobVar,
  VARRec2U,
  BtrvU2,
  RepTreeIF;

const

// Not needed by RW, but used by various R&D modules
{$I VerModu.Pas}

  PostMultiRunCtrl:  Boolean  =  BOn; {* Post One Run time Ctrl Line For Entire Posting Run *}

  NofChaseLtrs    =   3;            {* Max No of Chase Letters *}

  {$I VARCOMNU.Pas}
  {$I VARCMN3U.Pas}


Type
  DocEditNListType    =  Array[0..100] of LongInt;

  GlobalAllocType     =  Record
                           LUnallocated,
                           LFullUnallocated,
                           LFullOwnUnalloc,
                           LFullDisc
                                  :  Double;    { Global Ledger Unallocated field }

                           LRemitDoc
                                 : String[10];

                           LLastMDoc
                                 : DocTypes;
                         end;

  GlobAllocAry       =   Array[BOff..BOn] of GlobalAllocType;

  TIntSet            =   Set of Byte; 

  EntryRecType        = Record
                   {002}  Login     :  String[12];   {  Login Name }
                   {015}  Pword     :  String[9];    {  PassWord }
                   {024}  Access    :  Array[0..1024] of Byte;
                   {528}  LastPno   :  Byte;         {  Last Printer Used  }
                        end;


  tLocalPeriod       =  Record
                          CPr,CYr  :  Byte;
                          DispPrAsMonths
                                   :  Boolean;
                        end;
Const



  { ============= Export File Settings =========== }


  ExportTCode     =  'E';
  ExportSCode     =  'F';




  { =================================================== }


  { ============= Stock Alloc File Settings =========== }


  AllocTCode      =  'A';
  AllocSCode      =  'B';
  AllocPCode      =  'P';
  AllocUCode      =  'U';
  AllocBCode      =  'O';

  {*EN431MB2B*}
  AllocB2BICode   =  '2';
  AllocB2BLCode   =  'L';

  {*EN440WOP*}
  AllocWCode      =  'W';
  AllocW2Code     =  'R';
  AllocWPCode     =  'I';



  { =================================================== }




  { ============= Custom Settings =========== }


  btCustTCode     =  'U';
  btCustSCode     =  'C';

  { =================================================== }



{$IFDEF PF_On}




  { ============= General Qty Break Settings ============= }

  QBPriceCode    =  'P';  {* Special Price *}
  QBBandCode     =  'B';  {* Band Price    *}
  QBMarginCode   =  'M';  {* Margin on Cost *}
  QBMarkupCode   =  'U';  {* Markup on Cost *}
  QBQtyBCode     =  'Q';  {* Customer Qty Break *}

  QBDiscCode     =  'D';
  QBDiscSub      =  'Q';

  { ============= General Customer Discount Settings ============= }

  CDDiscCode     =  'C';




  { ============= General Bank Settings ============= }

  MBANKHed      =  'M';  {* Bank Match Header }
  MBANKSUB      =  'E';
  MBankMSub     =  'M';  {* Manual Bank Recon Screen *}
  MBANKCTL      =  'T';  {* Bank Ctrl File *}


  Const


    MBACSCode     =  'X';  {* Bacs Header }
    MBACSSUB      =  'S';
    MBACSALSub    =  'A';  {* Individual allocation lines *}
    MBACSCTL      =  'C';  {* Bacs Ctrl File *}
    MBACSUSR      =  'U';  {* Bacs Multi user File *}
    BACSRCode     =  'B';  {* BACS Run Code *}

    BACSCCode   =  'C';  {* Cheque Type *}
    BACS2Code   =  '2';  {* Alt Cheque 2 *}
    BACS3Code   =  '3';  {* Alt Cheque 3 *}


  { ====================================================== }


{$ENDIF}

  { ============= Bill of Material Settings =========== }


  BillMatTCode     =  'B';
  BillMatSCode     =  'M';



  { =================================================== }


  { ============= General Move Nom/Stock Settings ============= }

  MoveNomTCode   =  'M';
  MoveNomSCode   =  'N';
  MoveStkSCode   =  'S';




  { =================================================== }


  { ========= Word Processed Letter Settings ========== }

  LetterTCode     =  'W';
  { SCode set to TradeCode }  { Customer/Supplier (C/S)}
  LetterStkCode   =  'K';     { Stock }
  LetterDocCode   =  'T';     { Transactions }
  LetterJobCode   =  'J';     { Jobs }
  LetterEmplCode  =  'E';     { Employees }

  LetterCISCode   =  'I';     { CIS Voucher }

  {$IFDEF WCA}  { Windows Card System }
  LetterCardCode  =  'A';      { Cards }
  {$ENDIF}

  { =================================================== }



{$I VARRec.PAS}

{$I VarRecRP.Pas}

//-------------------------------------------------------------------------

const
  ReportTreeF = 19;

  // Report Tree constants.
  ID_LGTH = 4;
  REPORT_NAME_LGTH = 50;

  TreeParentIDK = 0;
  TreeChildIDK = 1;

type
  TReportTreeFRec = record
    // H or R, Heading or Report, this is because a heading maybe a child node.
    BranchType     : string[1];
    ReportName     : string[REPORT_NAME_LGTH];
    ReportDesc     : string[255];
    // All children will have an ParentID. Root nodes will a parent ID set to 0 (zero)
    ParentID       : string[ID_LGTH];   // MH NOTE: Not padded so index sorts incorrectly
    // This will have to match the ParentID of the children.
    ChildID        : string[ID_LGTH];   // MH NOTE: Not padded so index sorts incorrectly
    DiskFileName   : string[30];
    LastRunDetails : string[50];
    Spare          : string[110]; // total record size is 512 bytes....don't forget the length byte!!
  end;

  TReportTreeRecType = record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array [1..4] of Char;
    KeyBuff   :  array [1..2] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

//-------------------------------------------------------------------------

{ CJS 2012-08-15 - ABSEXCH-12964 - SQL Data Migration - Moved VRW data 
                   structures to separate include file so that they can be 
                   accessed from the SQL Migration code. }
                   
{$I VRWDataStructures.inc }

var

(*  global variables *)
  Ok,
  NoAbort,         { Global Variable which determines if abort allowed }
  BatchEdit,       { Global Variable to indicate Doc being edited from within a Batch *}
  RepWrtOn,        { Global Variable to indicate RW is present}
  JBCostOn,        { Global Variable to indicate Job Costing is Present *}
  JBFieldOn,       { Global Variable to indicate use of Job Costing fields, but without validation  *}
  SWInfoSOn,       { Global Variable to indicate Special switch for Info speed class version, Long Y Ref in cust ledger }
  SWBentlyOn,      { Global Variable to indicate Special switch for Info speed classBently Design version, Doc UD2 on Ord Daybook }
  EuroVers,        { Global Variable to indicate Euro Module *}
  TeleSModule,     { Global Variable to indicate TeleSModule Available *}
  eCommsModule,    { Global Variable to indicate Fax & Email comms Available *}
  eBusModule,      { Global Variable to indicate ebusiness module Available *}
  CommitAct,       { Global Variable to indicate Commitment accounting Available *}
  AnalCuStk,       { Global Variable to indicate cuanal Available *}
  WOPOn,           { Global Variable to indicate WOP is available*}
  FullWOP,         { Global Variable to indicate Full WOP inc WIN is available*}
  STDWOP,          { Global Variable to indicate STD WOP is available*}
  FullJAP,         { Global Variable to indicate Full JAP is available*}
  StdJAP,          { Global Variable to indicate STD JAP is available (Future version?)*}
  JAPOn,           { Global Variable to indicate JC Apps is available*}
  FullStkSysOn,  { Global Variable to indicate Full stk system is available, otherwise reverts to desc only stock*}
  CISOn,         {Global Variable to indicate CIS module enabled}

  RetMOn,          { Global Variable to indicate Returns Module is available*}

  EnSecurity       { Global Variable to indicate enhanced security is available*}



                : Boolean;

  // MH 23/10/2017 2018-R1: Added module release code flag for GDPR
  GDPROn : Boolean;

  NofInvLines,
  RetCode       : Integer;

  Choice,
  GlobPap,GlobInk,
  GlobAtt       : Byte;

  ViewPr,
  ViewYr        : ^Byte;   {Nom/Stk Tree View periods}

  GotPassWord,
  GotSecurity   : Boolean; {Flag to determine if Password & Security has been got!}


  GlobalAllocRec: ^GlobAllocAry;

  {Unallocated,  *Moved to Exlocal for corruption reasons
  FullUnallocated,
  FullOwnUnalloc
                : Real;

  RemitDoc      : String[10];
  LastMDoc      : DocTypes;


                  Global Ledger Unallocated field }

  {$IFDEF STK}

    StkAllSet,
    StkOrdSet,
    StkExcSet   : Set of DocTypes;  { == Stock allocatable Documents == }

  {$ENDIF}



  DEFPrnSet     : Set of DocTypes;  { == Printable Documents == }



  AccelParam,
  ExVersParam,
  RepWrtName,
  JBCostName    : ^Str20;

  CCVATName,
  CCCISName
                : ^Str80;

  RemDirNo      : LongInt;

  DocEditNowList: ^DocEditNListType;
  StkEditNowList: ^DocEditNListType;

  BTFileVer,
  DocEditedNow,
  StkEditedNow  : Byte;


  { ========== PopUp Flags ========== }


  DefPrintLock,
  AllowHotKey,
  InHelp,
  InHelpNdx,
  InCust,
  InNom,

  InCISP,

  InVATP,
  InCtrl,
  InCurr,
  InPopKy,
  InChangePr,
  InStock,
  InJobEdit,
  InStockEnq,
  InMainThread,
  InModalDialog,
  InSysSS,
  InBuildPP,
  InFindDoc,
  InGLCC,
  InDocNum       :   Boolean;         {  Flags to Show if Popup Active  }


  InSRC          :   Array[BOff..BOn] of Boolean;
  

  { ========== Record Definitions ========== }


   Cust          :   CustRec;
   CustFile      :   Cust_FileDef;

   Inv           :   InvRec;
   InvFile       :   Inv_FileDef;

   CInv          :   ^InvRec;

   Id            :   Idetail;
   IdFile        :   Idetail_Filedef;

   CId           :   ^Idetail;

   Nom           :   NominalRec;
   NomFile       :   Nominal_FileDef;

   Stock         :   StockRec;
   StockFile     :   Stock_FileDef;

   CStock        :   ^StockRec;

   MLocCtrl      :   MLocPtr;
   MLocFile      :   MLoc_FilePtr;

   NHist         :   HistoryRec;
   NHFile        :   Hist_FileDef;

   Count         :   IncrementRec;
   CountFile     :   Increment_FileDef;

   EntryRec      :   ^EntryRecType;

   UserProfile   :   ^tPassDefType;

   Password      :   PasswordRec;
   PassFile      :   PassWord_FileDef;

   MiscRecs      :   MiscRecPtr;

   MiscFile      :   Misc_FilePtr;

   RepScr        :   RepScrPtr;
   RepFile       :   Rep_FilePtr;

   Syss          :   Sysrec;
   SyssVAT       :   ^VATRecT;
   SyssCurr      :   ^CurrRec;
   SyssGCur      :   ^GCurRec;
   SyssCurr1P    :   ^Curr1PRec;
   SyssGCur1P    :   ^GCur1PRec;

   SyssDEF       :   ^DefRecT;
   SyssForms     :   ^FormDefsRecType;
   SyssJob       :   ^JobSRecT;

   SyssMod       :   ^ModRelRecType;
   SyssEDI1      :   ^EDI1Rec;
   SyssEDI2      :   ^EDI2Rec;
   SyssEDI3      :   ^EDI3Rec;

   SyssCstm,
   SyssCstm2     :   ^CustomFRec;

   SyssCIS       :   ^CISRecT;

   SyssCIS340  :   ^CIS340RecT;

   SysFile       :   Sys_FileDef;


   JobMisc,
   CJobMisc      :   JobMiscPtr;

   JobMiscFile   :   JobMisc_FilePtr;


   JobRec,
   CJobRec       :   JobRecPtr;

   JobRecFile    :   JobRec_FilePtr;


   JobCtrl       :   JobCtrlPtr;

   JobCtrlFile   :   JobCtrl_FilePtr;

   JobDetl,
   CJobDetl      :   JobDetlPtr;

   JobDetlFile   :   JobDetl_FilePtr;

   // Windows Report Writer file - too much hassle to remove it from Enterprise!
   RepGenRecs    : ^RepGenRec;
   GroupRepRec   : ^RepGenRec;

   // Data dictionary File
//   DictRec       : ^DataDictRec;
//   DictFile      : ^DataDict_FileDef;

   // Report Tree file
   ReportTreeRec : TReportTreeFRec;
   ReportTreeBtr : TReportTreeRecType;

   // Report Tree User Security file
   RTSecurity     : TReportTreeSecurityRecType;
   RTSecurityFile : TReportTreeSecurityFileDefType;

   // New Report Tree file
   VRWReportDataRec:  TVRWReportDataRec;
   VRWReportDataFile: TVRWReportDataFileDefType;


   NomView       :   NomViewPtr;
   NomViewFile   :   NomView_FilePtr;

   DocStatus     :  ^DocStatusType;

   // MH 06/10/2009: Modified to use the correct type after customers experienced range check errors
   //                HWnd = LongWord which could overflow a LongInt
   OpoLineHandle
                 :  Hwnd; //LongInt;

{ Check its the windows version and its the Enterprise DLL }
{$IFDEF EXWIN}
  (*
  {$IFDEF EDLL}
     { need Open_System available publicly in the enterprise  }
     { Dll so the files can be opened after the EXE passes in }
     { the data path                                          }
     Procedure Open_System(Start,Fin  :  Integer);
  {$ENDIF}

  {$IFDEF RW}
     { need Open_System available publicly in the enterprise  }
     { Report Writer so the Report Writer specific files can  }
     { be opened                                              }
     Procedure Open_System(Start,Fin  :  Integer);
  {$ENDIF}
  *)
{$ENDIF}

{ Needed available globally so change company can re-open the files }
Procedure Open_System(Start,Fin  :  Integer);

Procedure Close_Files(ByFile  :  Boolean);

// Key building routines

Function FullReportKey (Const RepCode : ShortString) : ShortString;
Function FullUserKey (Const UserCode : ShortString) : ShortString;
Function BuildUserRepKey (Const RepCode, UserCode : ShortString) : ShortString;
// used to return a correctly padded ID key. Works for ParentID, ChildID and NodeID key fields.
function FullNodeIDKey(const ID : ShortString) : ShortString;
// used to return a correctly padded RptID key.
function FullReportIDKey(const RptID : ShortString) : ShortString;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses Dialogs,
     ETStru,

     SysUtils,

     {$IFDEF JC}
       VarJCstU,
     {$ENDIF}

     {$IFDEF EXSQL}
     SQLUtils,
     {$ENDIF}

     MultiBuyVar,
     VARFposU,

     AccountContactVar,

     OrderPaymentsVar;

{$I VarCnst2.Pas}

//-------------------------------------------------------------------------

// used to return a correctly padded ID key. Works for ParentID, ChildID and NodeID key fields.
function FullNodeIDKey(const ID : ShortString) : ShortString;
begin
  Result := UpcaseStr(LJVar(ID, ID_LGTH));
end;

//------------------------------

// used to return a correctly padded RptID key.
function FullReportIDKey(const RptID : ShortString) : ShortString;
begin
  Result := UpcaseStr(LJVar(RptID, REPORT_NAME_LGTH));
end;

//------------------------------

Function FullReportKey (Const RepCode : ShortString) : ShortString;
Begin // FullReportKey
  Result := LJVar(UpperCase(Trim(RepCode)), REPORT_NAME_LGTH);
End; // FullReportKey

//------------------------------

Function FullUserKey (Const UserCode : ShortString) : ShortString;
Begin // FullUserKey
  Result := LJVar(UpperCase(Trim(UserCode)), 10);
End; // FullUserKey

//------------------------------

Function BuildUserRepKey (Const RepCode, UserCode : ShortString) : ShortString;
Begin // BuildUserRepKey
  Result := FullUserKey(UserCode) + FullReportKey(RepCode);
End; // BuildUserRepKey

//-------------------------------------------------------------------------

procedure DefineReportTreeFile;
const
  Idx = ReportTreeF;
begin
  // Setup entries within the global arrays storing the record lengths and address in memory
  FileRecLen[Idx] := Sizeof(ReportTreeRec);
  RecPtr[Idx]     := @ReportTreeRec;

  // Setup the entries within the global arrays storing the size of the Btrieve file def
  // structure and its address in memory
  FileSpecLen[Idx] := Sizeof(ReportTreeBtr);
  FileSpecOfs[Idx] := @ReportTreeBtr;

  // Initialise the Record and Btrieve structures
  FillChar(ReportTreeRec, FileRecLen[Idx], 0);
  FillChar(ReportTreeBtr, FileSpecLen[Idx], 0);

  // Define the path and filename of the data file relative to the Enterprise directory
  FileNames[Idx] := 'Reports\RWTree.Dat';

  // Define the Btrieve file structure
  with ReportTreeBtr do
  begin
    // Set the size of the Btrieve Record
    RecLen := FileRecLen[Idx];

    // Define the basic Btrieve File properties
    PageSize := DefPageSize;
    Variable := B_Variable + B_Compress + B_BTrunc; // Used for max compression

    // Define the indexes
    NumIndex := 2;

    // Index 1
    with KeyBuff[1] do
    begin
      // Position of indexed field in bytes offset from start of record
      KeyPos := BtKeyPos(@ReportTreeRec.ParentID[1], @ReportTreeRec);
      // length of segment in bytes
      KeyLen := ID_LGTH;
      // Flags for index
      KeyFlags := DupMod + AltColSeq;
    end; // with KeyBuff[1] do...

    // Index 2
    with KeyBuff[2] do
    begin
      // Position of indexed field in bytes offset from start of record
      KeyPos := BtKeyPos(@ReportTreeRec.ChildID[1], @ReportTreeRec);
      // length of segment in bytes
      KeyLen := ID_LGTH;
      // Flags for index
      KeyFlags := DupMod + AltColSeq;
    end; // with KeyBuff[2] do...

    // Definition for AutoConversion to UpperCase
    AltColt := UpperALT;
  end; // with ReportTreeBtr do...

end; // procedure DefineReportTreeFile

//-------------------------------------------------------------------------

Procedure DefineRTSecurityFile;
Const
  Idx = RTSecurityF;
Begin // DefineRTSecurityFile
  // Setup entries within the global arrays storing the record lengths and address in memory
  FileRecLen[Idx]  := Sizeof(RTSecurity);
  RecPtr[Idx]      := @RTSecurity;

  // Setup the entries within the global arrays storing the size of the Btrieve file def
  // structure and its address in memory
  FileSpecLen[Idx] := Sizeof(RTSecurityFile);
  FileSpecOfs[Idx] := @RTSecurityFile;

  // Initialise the Record and Btrieve structures
  FillChar (RTSecurity, Sizeof(RTSecurity),  0);
  Fillchar (RTSecurityFile, Sizeof(RTSecurityFile), 0);

  // Define the path and filename of the data file relative to the Enterprise directory
  FileNames[Idx] := 'Reports\VRWSec.Dat';

  // Define the Btrieve file structure
  With RTSecurityFile Do
  Begin
    // Set the size of the Btrieve Record
    RecLen := FileRecLen[Idx];

    // Define the basic Btrieve File properties
    PageSize := DefPageSize;
    Variable := B_Variable + B_Compress + B_BTrunc; // Used for max compression

    // Define the indexes
    NumIndex := 2;

    // Index 0: rtsUserCode + rtsTreeCode
    With KeyBuff[1] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos := BtKeyPos(@RTSecurity.rtsUserCode[1], @RTSecurity);
      // length of segment in bytes
      KeyLen := SizeOf(RTSecurity.rtsUserCode) - 1;
      // Flags for index
      KeyFlags := ModSeg + AltColSeq;
    End; // With KeyBuff[1]
    With KeyBuff[2] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos := BtKeyPos(@RTSecurity.rtsTreeCode[1], @RTSecurity);
      // length of segment in bytes
      KeyLen := SizeOf(RTSecurity.rtsTreeCode) - 1;
      // Flags for index
      KeyFlags := Modfy + AltColSeq;
    End; // With KeyBuff[2]

    // Index 1: rtsTreeCode + rtsUserCode
    With KeyBuff[3] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos := BtKeyPos(@RTSecurity.rtsTreeCode[1], @RTSecurity);
      // length of segment in bytes
      KeyLen := SizeOf(RTSecurity.rtsTreeCode) - 1;
      // Flags for index
      KeyFlags := ModSeg + AltColSeq;
    End; // With KeyBuff[3]
    With KeyBuff[4] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos := BtKeyPos(@RTSecurity.rtsUserCode[1], @RTSecurity);
      // length of segment in bytes
      KeyLen := SizeOf(RTSecurity.rtsUserCode) - 1;
      // Flags for index
      KeyFlags := Modfy + AltColSeq;
    End; // With KeyBuff[4]

    // Definition for AutoConversion to UpperCase
    AltColt:=UpperALT;
  End; // With DataFile
End; // DefineRTSecurityFile

//-------------------------------------------------------------------------

procedure DefineVRWReportDataFile;
const
  Idx = VRWReportDataF;
Begin // DefineVRWReportDataFile
  // Setup entries within the global arrays storing the record lengths and address in memory
  FileRecLen[Idx]  := Sizeof(VRWReportDataRec);
  RecPtr[Idx]      := @VRWReportDataRec;

  // Setup the entries within the global arrays storing the size of the Btrieve file def
  // structure and its address in memory
  FileSpecLen[Idx] := Sizeof(VRWReportDataFile);
  FileSpecOfs[Idx] := @VRWReportDataFile;

  // Initialise the Record and Btrieve structures
  FillChar (VRWReportDataRec, Sizeof(VRWReportDataRec),  0);
  Fillchar (VRWReportDataFile, Sizeof(VRWReportDataFile), 0);

  // Define the path and filename of the data file relative to the Enterprise directory
  FileNames[Idx] := 'Reports\VRWTree.Dat';

  // Define the Btrieve file structure
  With VRWReportDataFile Do
  Begin
    // Set the size of the Btrieve Record
    RecLen := FileRecLen[Idx];

    // Define the basic Btrieve File properties
    PageSize := DefPageSize;
    Variable := B_Variable + B_Compress + B_BTrunc; // Used for max compression

    // Define the indexes
    NumIndex := 3;

    // Index 0: rtRepName
    With KeyBuff[1] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos := BtKeyPos(@VRWReportDataRec.rtRepName[1], @VRWReportDataRec);
      // length of segment in bytes
      KeyLen := SizeOf(VRWReportDataRec.rtRepName) - 1;
      // Flags for index
      KeyFlags := Modfy + AltColSeq;
    End; // With KeyBuff[1]

    // Index 1: rtParentName + rtPositionNumber + '!'
    With KeyBuff[2] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos := BtKeyPos(@VRWReportDataRec.rtParentName[1], @VRWReportDataRec);
      // length of segment in bytes
      KeyLen := SizeOf(VRWReportDataRec.rtParentName) - 1;
      // Flags for index
      KeyFlags := DupModSeg + AltColSeq;
    End; // With KeyBuff[2]

    With KeyBuff[3] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos := BtKeyPos(@VRWReportDataRec.rtPositionNumber, @VRWReportDataRec);
      // length of segment in bytes
      KeyLen := SizeOf(VRWReportDataRec.rtPositionNumber);
      // Flags for index
      KeyFlags := DupModSeg + ExtType;
      // Key type
      ExtTypeVal := BInteger;
    End; // With KeyBuff[3]

    With KeyBuff[4] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos := BtKeyPos(@VRWReportDataRec.rtIndexFix, @VRWReportDataRec);
      // length of segment in bytes
      KeyLen := SizeOf(VRWReportDataRec.rtIndexFix);
      // Flags for index
      KeyFlags := DupMod + AltColSeq;
    End; // With KeyBuff[4]

    // Index 2: rtFilename
    With KeyBuff[5] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos := BtKeyPos(@VRWReportDataRec.rtFilename[1], @VRWReportDataRec);
      // length of segment in bytes
      KeyLen := SizeOf(VRWReportDataRec.rtFilename) - 1;
      // Flags for index
      KeyFlags := Modfy + AltColSeq;
    End; // With KeyBuff[5]

    // Definition for AutoConversion to UpperCase
    AltColt:=UpperALT;
  End; // With DataFile
End; // DefineVRWReportDataFile

//-------------------------------------------------------------------------
(*
Procedure DefineDataDict;
Const
  Idx = DictF;
Begin
  // Setup entries within the global arrays storing the record lengths and address in memory
  FileRecLen[Idx] := Sizeof(DictRec^);
  RecPtr[Idx]     := @DictRec^;

  // Setup the entries within the global arrays storing the size of the Btrieve file def
  // structure and its address in memory
  FileSpecLen[Idx] := Sizeof(DictFile^);
  FileSpecOfs[Idx] := @DictFile^;

  // Initialise the Record and Btrieve structures
  Fillchar (DictRec^,  FileRecLen[Idx],  0);
  Fillchar (DictFile^, FileSpecLen[Idx], 0);

  // Define the path and filename of the data file relative to the Enterprise directory
  FileNames[Idx] := Path5 + RepDictNam;     // Reports\Dictnary.Dat

  // Define the Btrieve file structure
  With DictFile^ Do
  Begin
    // Set the size of the Btrieve Record
    RecLen := Sizeof(DictRec^);

    // Define the basic Btrieve File properties
    PageSize := DefPageSize;
    Variable := B_Variable + B_Compress + B_BTrunc;     {* Used for max compression *}

    // Define the indexes
    NumIndex := DINofKeys;

    // Index 0 - (RecPfix+SubType) + VarName (DIK)
    With KeyBuff[1] Do
    Begin
      KeyPos:=1;
      KeyLen:=2;
      KeyFlags:=DupModSeg;
    End; // With KeyBuff[1]
    With KeyBuff[2] Do
    Begin
      KeyPos:=4;
      KeyLen:=14;
      KeyFlags:=DupMod;
    End; // With KeyBuff[2]

    // Index 1 - (RecPfix+SubType) +  Var Desc [1..10] (DISecK)
    With KeyBuff[3] Do
    Begin
      KeyPos:=1;
      KeyLen:=2;
      KeyFlags:=DupModSeg+Mank;
    End; // With KeyBuff[3]
    With KeyBuff[4] Do
    Begin
      KeyPos:=19;
      KeyLen:=10;
      KeyFlags:=DupMod+Mank;
    End; // With KeyBuff[4]

    // Definition for AutoConversion to UpperCase
    AltColt:=UpperALT;
  End; // With DictFile^
end; {..}
*)
//-------------------------------------------------------------------------

Initialization

{ ******************************* Must Be Changed **************************}

  TotFiles:=16  ;

{ ******************************* --------------- **************************}



  New(DocStatus);

  FillChar(DocStatus^,SizeOf(DocStatus^),0);


  Choice:=1;

  RetCode:=1;

  NofInvLines:=15;


  {Unallocated:=0;

  FullUnallocated:=0;

  FullOwnUnalloc:=0;}

  New(GlobalAllocRec);

  FillChar(GlobalAllocRec^,Sizeof(GlobalAllocRec^),0);


  NoAbort:=BOff;

  BatchEdit:=BOff;

  RepWrtOn:=BOff;
  JBCostOn:=BOff;
  JBFieldOn:=BOff;
  SWInfoSOn:=BOff;
  SWBentlyOn:=BOff;
  EuroVers:=BOff;

  TeleSModule:=BOff;
  eBusModule:=BOff;
  eCommsModule:=BOff;
  AnalCuStk:=BOff;
  CommitAct:=BOff;
  WOPOn:=BOff;
  
  FullWOP:=BOff;
  STDWOP:=BOff;

  JAPOn:=BOff;
  FullJAP:=BOff;
  STDJAP:=BOff;

  FullStkSysOn:=BOn;

  CISOn:=BOff;

  RetMOn:=BOff;

  EnSecurity:=BOff;


  // MH 23/10/2017 2018-R1: Added module release code flag for GDPR
  GDPROn := False;
  GotPassWord:=BOff;
  GotSecurity:=BOff;
  BTFileVer:=0;

  {RemitDoc:='';

  LastMDoc:=FOL;}

  { =========== Hot Key Definitions ============ }

    AllowHotKey:=BOn;
    InHelp:=BOff;
    InHelpNdx:=BOff;
    InCust:=BOff;
    InNom:=BOff;
    InVATP:=BOff;

    InCISP:=BOff;

    INCtrl:=BOff;
    InCurr:=BOff;
    InPopKy:=BOff;
    InChangePr:=BOff;
    InFindDoc:=BOff;
    InStock:=BOff;
    InMainThread:=BOff;
    InModalDialog:=BOff;
    InBuildPP:=BOff;
    DefPrintLock:=BOff;
    InSysSS:=BOff;
    InDocNum:=BOff;
    InGLCC:=BOff;
    InJobEdit:=BOff;

    FillChar(InSRC,Sizeof(InSRC),0);

    InStockEnq:=BOff;

  { ============================================ }


  { =========== Btrieve File Definitions ============ }

  New(CCVATName);

  FillChar(CCVATName^,Sizeof(CCVATName^),0);

  New(CCCISName);

  FillChar(CCCISName^,Sizeof(CCCISName^),0);

  New(MiscRecs);

  New(MiscFile);

  New(RepScr);

  New(RepFile);

  New(CInv);

  New(CId);

  New(CStock);

  New(EntryRec);

  New(UserProfile);

  New(SyssJob);

  New(ViewPr);
  New(ViewYr);

  ViewPr^:=0;
  ViewYr^:=0;

  New(AccelParam);

  FillChar(AccelParam^,Sizeof(AccelParam^),0);

  New(ExVersParam);
  FillChar(ExVersParam^,Sizeof(ExVersParam^),0);

  New(RepWrtName);

  FillChar(RepWrtName^,Sizeof(RepWrtName^),0);

  RepWrtName^:='EXREPWRT.EXE';

  New(JBCostName);

  FillChar(JBCostName^,Sizeof(JBCostName^),0);

  JBCostName^:='EXJBCOST.EXE';

  DocEditedNow:=0;
  StkEditedNow:=0;

  New(DocEditNowList);

  FillChar(DocEditNowList^,Sizeof(DocEditNowList^),0);

  New(StkEditNowList);

  FillChar(StkEditNowList^,Sizeof(StkEditNowList^),0);

  RemDirNo:=0;

  New(JobMisc);
  New(CJobMisc);
  New(JobMiscFile);

  FillChar(CJobMisc^,Sizeof(CJobMisc^),0);


  New(JobRec);
  New(CJobRec);
  New(JobRecFile);

  FillChar(CJobRec^,Sizeof(CJobRec^),0);

  New(JobCtrl);
  New(JobCtrlFile);


  New(JobDetl);
  New(CJobDetl);
  New(JobDetlFile);

  FillChar(CJobDetl^,Sizeof(CJobDetl^),0);


  {$IFDEF JC}
    New(JobStatusL);

    FillChar(JobStatusL^,Sizeof(JobStatusL^),0);

    New(JobXDesc);

    FillChar(JobXDesc^,Sizeof(JobXDesc^),0);

    New(JobCHTDescL);

    FillChar(JobCHTDescL^,Sizeof(JobCHTDescL^),0);

    New(EmplTDescL);

    FillChar(EmplTDescL^,Sizeof(EmplTDescL^),0);

    New(JALTypes);

    FillChar(JALTypes^,Sizeof(JALTypes^),0);

  {$ENDIF}

  New(SyssVAT);
  FillChar(SyssVAT^,Sizeof(SyssVAT^),0);

  New(SyssCIS);
  FillChar(SyssCIS^,Sizeof(SyssCIS^),0);

  New(SyssCIS340);
  FillChar(SyssCIS340^,Sizeof(SyssCIS340^),0);

  New(SyssCurr);
  FillChar(SyssCurr^,Sizeof(SyssCurr^),0);

  New(SyssGCur);
  FillChar(SyssGCur^,Sizeof(SyssGCur^),0);

  New(SyssCurr1P);

  FillChar(SyssCurr1P^,Sizeof(SyssCurr1P^),0);

  New(SyssGCur1P);

  FillChar(SyssGCur1P^,Sizeof(SyssGCur1P^),0);


  New(SyssDEF);
  FillChar(SyssDEF^,Sizeof(SyssDEF^),0);

  New(SyssForms);
  FillChar(SyssForms^,Sizeof(SyssForms^),0);

  New(SyssMod);

  FillChar(SyssMod^,Sizeof(SyssMod^),0);

  New(SyssEDI1);

  FillChar(SyssEDI1^,Sizeof(SyssEDI1^),0);

  New(SyssEDI2);

  FillChar(SyssEDI2^,Sizeof(SyssEDI2^),0);

  New(SyssEDI3);

  FillChar(SyssEDI3^,Sizeof(SyssEDI3^),0);

  New(SyssCstm);

  FillChar(SyssCstm^,Sizeof(SyssCstm^),0);

  New(SyssCstm2);

  FillChar(SyssCstm2^,Sizeof(SyssCstm2^),0);


  New(MLocCtrl);
  New(MLocFile);

  DefineCust;
  DefineDoc;
  DefineIDetail;
  DefineNominal;


  {If (DeBug) then
    Ch:=ReadKey;}

  DefineStock;
  DefineNumHist;
  DefineCount;
  DefinePassWord;
  DefineMiscRecs;


  DefineJobMisc;
  DefineJobRec;
  DefineJobCtrl;
  DefineJobDetl;


  {If (DeBug) then
    Ch:=ReadKey;}

  New(NomView);
  New(NomViewFile);

  DefineNomView;

  DefineMLoc;

  DefineRepScr;
  DefineSys;

  {$IFDEF JC}
    Define_PVar;

  {$ENDIF}

  //PR: 10/06/2009
  DefineMultiBuyDiscounts;

  GetMem (RepGenRecs, SizeOf(RepGenRec));
  GetMem (GroupRepRec, SizeOf(RepGenRec));
  FileNames[RepGenF] := 'Reports\Reports.Dat';

  // Configure Data Dictionary file
//  GetMem (DictRec, SizeOf (DictRec^));
//  GetMem (DictFile, SizeOf (DictFile^));
//  DefineDataDict;

  DefineReportTreeFile;
  DefineRTSecurityFile;
  DefineVRWReportDataFile;

  //PR: 03/02/2014 ABSEXCH-14974
  DefineAccountContactFiles;
  DefineOrderPaymentsFile;

  { ================================================ }


  { ======== Set up Copy Records ======== }

    CId^:=Id;

    CInv^:=Inv;

    CStock^:=Stock;

    FillChar(EntryRec^,Sizeof(EntryRec^),0);

    FillChar(UserProfile^,Sizeof(UserProfile^),0);

  { ===================================== }


  { =========== Printable Document Definitions ============ }


  { == Docs where a Print def allowed (JC) replicated == }

  DEFPrnSet :=  [SIN,SCR,SJI,SJC,SRF,SRI,SBT,SQU,SOR,SDN,PIN,PCR,PJI,PJC,PRF,PPI,PPY,PBT,PQU,POR,NMT,ADJ,TSH];


  { ======== Determine Stock allocation control ======== }

  {$IFDEF STK}

    {$IFDEF PF_On}

      StkAllSet    :=  [SOR];

      StkOrdSet    :=  [POR];

      StkExcSet    :=  [SQU,PQU,WOR,WIN];

    {$ELSE}

      StkAllSet    :=  [SQU];

      StkOrdSet    :=  [PQU];

      StkExcSet    :=  [SOR,WOR,WIN];

    {$ENDIF}

  {$ENDIF}

   OpoLineHandle:=0;



  { ======================================================= }


  GetBtParam;

  // HM 04/04/05: Added as ExMainCoPath usually screws up everything when set
  ExMainCoPath^ := '';

  {$IFDEF DBD}
   If (Debug) and (ExMainCoPath^='') then {* For debug purposes, force it to be same as set drive*}
     ExMainCoPath^:=SetDrive;

  {$ENDIF}


Finalization
  {* All Pointers Destroyed via HeapVarTidy in SysU2 v4.01b, 15/12/1997 *}

//  FreeMem (DictRec, SizeOf (DictRec^));
//  FreeMem (DictFile, SizeOf (DictFile^));

  FreeMem (RepGenRecs, SizeOf(RepGenRec));
  FreeMem (GroupRepRec, SizeOf(RepGenRec));

end.
