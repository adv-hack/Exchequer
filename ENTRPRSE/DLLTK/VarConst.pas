Unit VarConst;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


(* 21.11.97 *)
(* Note : VarConst is too big for 16 bit version, hence {$IFDEF WIN32}
          has to be redeclared in VarCnst3.Pas.
          Reason -> 32 bit is using shared programs which use shared VarConst,
                    therefore this VarConst has to be the same as shared VarConst. *)


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

Uses

     {$IFDEF WIN32}
       Windows,
       BtrvU2,
     {$ELSE}
       WinTypes,
       BtrvU16,
     {$ENDIF}
     GlobVar,
     {$IFDEF WIN32}
       VarRec2U,
     {$ELSE}
       VRec2U,
     {$ENDIF}
     Graphics;

{* File Constants *}

const
  PostMultiRunCtrl:  Boolean  =  BOn; {* Post One Run time Ctrl Line For Entire Posting Run *}

  {$I FilePath.Inc}
  {$I Version.Inc}   {* Add on 08.09.97 *}

  {$I VARCOMNU.PAS}
  {$I VARCMN3U.PAS}  {* Add on 28.08.97 *}

  {$I VARRec.PAS}



{$IFDEF WIN32}

Const
  { ============= EBusiness ============== }

  EBUSINESS_COUNTERS = 6;
  EBUSINESS_DOCS : array[1..EBUSINESS_COUNTERS] of
                   string = (('ESO'),('ESI'),('EPO'),('EPI'),('ESC'),('EPC'));


  { ============= Bank Import ============ }

  MBankHed  =  'M';
  MBankSub  =  'E';
  MBankCtl  =  'T';



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

    MBACSCode     =  'X';  {* Bacs Header }
    MBACSSUB      =  'S';
    MBACSALSub    =  'A';  {* Individual allocation lines *}
    MBACSCTL      =  'C';  {* Bacs Ctrl File *}
    MBACSUSR      =  'U';  {* Bacs Multi user File *}
    BACSRCode     =  'B';  {* BACS Run Code *}

    BACSCCode   =  'C';  {* Cheque Type *}
    BACS2Code   =  '2';  {* Alt Cheque 2 *}
    BACS3Code   =  '3';  {* Alt Cheque 3 *}

  { ============= Bill of Material Settings =========== }


  BillMatTCode     =  'B';
  BillMatSCode     =  'M';



  { =================================================== }

  btCustTCode     =  'U';
  btCustSCode     =  'C';

  { ============= General Move Nom/Stock Settings ============= }

  MoveNomTCode   =  'M';
  MoveNomSCode   =  'N';
  MoveStkSCode   =  'S';


  


  KeyInvFXlate  :  Array[0..11] of Integer =
                   (InvOurRefK,InvFolioK,InvCustK,InvYrRefK,InvLYRefK,
                   InvRNoK,InvCDueK,InvVATK,InvBatchK,InvDateK,InvYrPrK,InvOSK);

  KeyIDXlate : Array[0..6] of Integer =
                (IdFolioK, IdRunK, IdNomK, IdStkK, IdAnalK, IdLinkK, IdCAnalk);

  { ========= Word Processed Letter Settings ========== }

  LetterTCode     =  'W';
  { SCode set to TradeCode }  { Customer/Supplier (C/S)}
  LetterStkCode   =  'K';     { Stock }
  LetterDocCode   =  'T';     { Transactions }
  LetterJobCode   =  'J';     { Jobs }
  LetterEmplCode  =  'E';     { Employees }

  {$IFDEF EN550CIS}
    LetterCISCode   =  'I';     { CIS Voucher }
  {$ENDIF}

  {$IFDEF WCA}  { Windows Card System }
  LetterCardCode  =  'A';      { Cards }
  {$ENDIF}

  { =================================================== }


  Type

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
                             LCADate
                                   : LongDate;
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

{$ENDIF}

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
  EBankOn          { Global Variable to indicate eBanking module}



                : Boolean;


  //AP 27/11/2017 2018-R1: Added module release code flag for GDPR
  GDPROn        : Boolean;

  NofInvLines,
  RetCode       : Integer;

  ICEDFM,
  Choice,
  GlobPap,GlobInk,
  GlobAtt       : Byte;

  ViewPr,
  ViewYr        : ^Byte;   {Nom/Stk Tree View periods}

  GotPassWord,
  GotSecurity   : Boolean; {Flag to determine if Password & Security has been got!}

  {$IFDEF EN550CIS}
    CCCISName  : ^Str80;
  {$ENDIF}


  { ========== PopUp Flags ========== }


  DefPrintLock,
  AllowHotKey,
  InHelp,
  InHelpNdx,
  InCust,
  InNom,
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

{$IFDEF WIN32}

Var

   Cust          :   CustRec;
   CustFile      :   Cust_FileDef;

   Inv           :   InvRec;
   InvFile       :   Inv_FileDef;

   CInv          :   ^InvRec;

   Id            :   Idetail;
   IdFile        :   Idetail_Filedef;

   CId           :   ^IDetail;

   Nom           :   NominalRec;
   NomFile       :   Nominal_FileDef;

   Stock         :   StockRec;
   StockFile     :   Stock_FileDef;

   CStock        :   ^StockRec;

   MLocCtrl      :   MLocPtr;      {Added on 20.12.96 & in BtrvU2 also}
   MLocFile      :   MLoc_FilePtr;

   NHist         :   HistoryRec;
   NHFile        :   Hist_FileDef;

   Count         :   IncrementRec;
   CountFile     :   Increment_FileDef;

   {EntryRec      :   ^PassEntryType; --- To check this }
   EntryRec      :   ^EntryRecType;

   UserProfile   :   ^tPassDefType;

   Password      :   PasswordRec;
   PassFile      :   PassWord_FileDef;

   MiscRecs      :   MiscRecPtr;
   MiscFile      :   Misc_FilePtr;

   Syss          :   Sysrec;
   SyssVAT       :   ^VATRecT;
   SyssCurr      :   ^CurrRec;
   SyssGCuR      :   ^GCurRec;            { ** Rec }
   SyssCurr1P    :   ^Curr1PRec;        {* Added in v4.31 *}
   SyssGCur1P    :   ^GCur1PRec;        {* Added in v4.31 *}
   SyssDEF       :   ^DefRecT;
   SyssForms     :   ^FormDefsRecType;
   SyssJob       :   ^JobSRecT;

   SyssMod       :   ^ModRelRecType;
   SyssEDI1      :   ^EDI1Rec;            { ** Rec }
   SyssEDI2      :   ^EDI2Rec;            { ** Rec }
   SyssEDI3      :   ^EDI3Rec;            { ** Rec }

   SyssCstm,
   SyssCstm2     :   ^CustomFRec;

   SysFile       :   Sys_FileDef;

   RepScr        :   RepScrPtr;
   RepFile       :   Rep_FilePtr;

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

   NomView       :   NomViewPtr;

   NomViewFile   :   NomView_FilePtr;


   SyssCIS       :   ^CISRecT;
   SyssCIS340  :   ^CIS340RecT;

   // MH 06/10/2009: Modified to use the correct type after customers experienced range check errors
   //                HWnd = LongWord which could overflow a LongInt
   OpoLineHandle
                 :  Hwnd; //LongInt;

   

{$ENDIF}

   {$IFDEF WIN32}

     GlobalAllocRec:  ^GlobAllocAry;

     StkAllSet,
     StkOrdSet,
     StkExcSet    : Set of DocTypes;  { == Stock allocatable Documents == }

     DEFPrnSet     : Set of DocTypes;  { == Printable Documents == }

     CCVATName     :  ^Str80;

     DocStatus     :  ^DocStatusType;

     TeleSModule,     { Global Variable to indicate TeleSModule Available *}
     eCommsModule,    { Global Variable to indicate Fax & Email comms Available *}
     eBusModule,      { Global Variable to indicate ebusiness module Available *}
     CommitAct,       { Global Variable to indicate Commitment accounting Available *}
     WOPOn,           { Global Variable to indicate WOP is available*}
     FullWOP,         { Global Variable to indicate Full WOP inc WIN is available*}
     STDWOP,          { Global Variable to indicate STD WOP is available*}
     FullJAP,         { Global Variable to indicate Full JAP is available*}
     StdJAP,          { Global Variable to indicate STD JAP is available (Future version?)*}
     JAPOn,           { Global Variable to indicate JC Apps is available*}
     FullStkSysOn,  { Global Variable to indicate Full stk system is available, otherwise reverts to desc only stock*}
     VisualRWLicenced,
     CISOn,         {Global Variable to indicate CIS module enabled}

     RetMOn,     {Global Variable to indicate Returns module enabled}
     VRWOn,
     EnSecurity,      { Global Variable to indicate enhanced security is available*}
     WebExtensionsOn,  // MH 08/02/2010: Global variable to indicate if Web Extensions is licensed
     AnalCuStk      : Boolean;     { Global Variable to indicate cuanal Available *}

     WebExtEProcurementOn: Boolean; // CJS 18/01/2011: Global variable to indicate if the e-Procurement plug-in is licenced

     DocEditNowList: ^DocEditNListType;
     StkEditNowList: ^DocEditNListType;

     BTFileVer,
     DocEditedNow,
     StkEditedNow  : Byte;

     IsEBusTran    : Boolean;   { If BBus Tran, do not update Account/Stock when storing trans. }
     UseLoc : Boolean = False;
     CheckOnly : Boolean;



     KeyStrings : Array[1..MaxFiles] of Str255;

     function SetKeyString(BtrOp, FileNo : SmallInt; const SearchKey : string) : String;

   {$ENDIF}

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{Uses ETPrompt;}

uses
  VarJCstU, MultiBuyVar;

function SetKeyString(BtrOp, FileNo : SmallInt; const SearchKey : string) : String;
begin
  if BtrOp in [B_GetNext, B_GetPrev] then
    Result := KeyStrings[FileNo]
  else
    Result := SearchKey;
end;

Begin

{$IFDEF WIN32}
  StkAllSet    := [SOR];
  StkOrdSet    := [POR];
  StkExcSet    := [SQU,PQU,WOR,WIN,SRN,PRN];

  IsEBusTran:=False;

{$ENDIF}

  {* For version 4.31 *}
  AssignBOwner(ExBTOWNER);

  {$IFDEF EN550CIS}
    New(CCCISName);

    FillChar(CCCISName^,Sizeof(CCCISName^),0);
  {$ENDIF}


  {$IFDEF EN550CIS}
    New(SyssCIS);
    FillChar(SyssCIS^,Sizeof(SyssCIS^),0);

    New(SyssCIS340);
    FillChar(SyssCIS340^,Sizeof(SyssCIS340^),0);

  {$ENDIF}


    New(JobStatusL);

    FillChar(JobStatusL^,Sizeof(JobStatusL^),0);

    New(JobXDesc);

    FillChar(JobXDesc^,Sizeof(JobXDesc^),0);

    New(JobCHTDescL);

    FillChar(JobCHTDescL^,Sizeof(JobCHTDescL^),0);

    New(EmplTDescL);

    FillChar(EmplTDescL^,Sizeof(EmplTDescL^),0);

  {$IFDEF JC}
    New(JobStatusL);

    FillChar(JobStatusL^,Sizeof(JobStatusL^),0);

    New(JobXDesc);

    FillChar(JobXDesc^,Sizeof(JobXDesc^),0);

    New(JobCHTDescL);

    FillChar(JobCHTDescL^,Sizeof(JobCHTDescL^),0);

    New(EmplTDescL);

    FillChar(EmplTDescL^,Sizeof(EmplTDescL^),0);

    {$IFDEF EN560}
      New(JALTypes);

      FillChar(JALTypes^,Sizeof(JALTypes^),0);

    {$ENDIF}
  {$ENDIF}

    New(SyssEDI2);
    FillChar(SyssEDI2^,Sizeof(SyssEDI2^),0);

    Define_PVar;

    CheckOnly := False;

   DefineMultiBuyDiscounts;


end.
