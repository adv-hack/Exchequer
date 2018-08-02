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
  EuroVers        { Global Variable to indicate Euro Module *}



                : Boolean;

  NofInvLines,
  RetCode       : Integer;

  Choice,
  GlobPap,GlobInk,
  GlobAtt       : Byte;

  ViewPr,
  ViewYr        : ^Byte;   {Nom/Stk Tree View periods}

  GotPassWord,
  GotSecurity   : Boolean; {Flag to determine if Password & Security has been got!}



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
   SyssCIS       :   ^CISRecT;

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

   {$IFDEF EN550CIS}
     SyssCIS       :   ^CISRecT;
   {$ENDIF}

   OpoLineHandle
                 :  LongInt;
     
   

{$ENDIF}

   {$IFDEF WIN32}

     GlobalAllocRec:  ^GlobAllocAry;

     StkAllSet,
     StkOrdSet,
     StkExcSet    : Set of DocTypes;  { == Stock allocatable Documents == }

     DEFPrnSet     : Set of DocTypes;  { == Printable Documents == }

     RemDirNo      : LongInt;


     CCVATName,
     CCCISName     :  ^Str80;

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
     EnSecurity,      { Global Variable to indicate enhanced security is available*}
     AnalCuStk      : Boolean;     { Global Variable to indicate cuanal Available *}

     DocEditNowList: ^DocEditNListType;
     StkEditNowList: ^DocEditNListType;

     BTFileVer,
     DocEditedNow,
     StkEditedNow  : Byte;

     IsEBusTran    : Boolean;   { If BBus Tran, do not update Account/Stock when storing trans. }
     UseLoc : Boolean = False;

   {$ENDIF}

procedure DefineFiles;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{Uses ETPrompt;}

uses
  VarJCstU, VarFPosU, SysUtils, Dialogs;

{$I Varcnst2.pas}

procedure DefineFiles;
begin
    New(RepScr);
    New(RepFile);

    New(MiscRecs);
    New(MiscFile);
    FillChar(MiscRecs^,Sizeof(MiscRecs^),0);

    New(EntryRec);
    FillChar(EntryRec^,Sizeof(EntryRec^),0);

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

    New(MLocCtrl); {20.12.96}
    New(MLocFile);

    New(SyssVAT);
    New(SyssCurr);
    New(SyssDEF);
    New(SyssGCuR);
    New(SyssCurr1P);
    New(SyssGCur1P);

    New(SyssForms);
    New(SyssMod);
    New(SyssJob);  {* Added on 13.07.98 *}
    {Added on 16.11.98}
    New(SyssEDI1);
    New(SyssEDI2);
    New(SyssEDI3);

    New(CId);
    New(CInv);
    New(CStock);
    New(JBCostName);


    FillChar(SyssVAT^,SizeOf(SyssVAT^),#0);
    FillChar(SyssCurr^,SizeOf(SyssCurr^),#0);
    FillChar(SyssGCUR^,SizeOf(SyssGCUR^),#0);
    FillChar(SyssDEF^,SizeOf(SyssDEF^),#0);
    FillChar(SyssForms^,SizeOf(SyssForms^),#0);
    FillChar(SyssMod^,SizeOf(SyssMod^),#0);
    FillChar(CId^,SizeOf(CId^),#0);
    FillChar(CInv^,SizeOf(CInv^),#0);
    FillChar(CStock^,SizeOf(CStock^),#0);
    FillChar(JBCostName^,SizeOf(JBCostName^),#0);

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
    DefineJobDetl;
    DefineJobCtrl;
    DefineMLoc;   {20.12.96}
    DefineRepScr;
    DefineSys;

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

    New(CCCISName);

    FillChar(CCCISName^,Sizeof(CCCISName^),0);


    New(SyssCIS);
    FillChar(SyssCIS^,Sizeof(SyssCIS^),0);


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

      New(JALTypes);

      FillChar(JALTypes^,Sizeof(JALTypes^),0);

  {$ENDIF}


    Define_PVar;





end.
