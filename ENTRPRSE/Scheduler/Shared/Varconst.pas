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
  FileUtil;

const


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
  QBValueCode    =  'V';  {* Value Based Discount - Cust/Supp Only *}

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
  FullStkSysOn,    { Global Variable to indicate Full stk system is available, otherwise reverts to desc only stock*}
  CISOn,           {Global Variable to indicate CIS module enabled}
  RetMOn,          { Global Variable to indicate Returns Module is available*}

  
  EBankOn,         // MH 10/01/07: Global Variable to indicate eBanking Module is available
  ODDOn,           // MH 10/01/07: Global Variable to indicate Outlook Dynamic Dashboard is available

  VRWOn,
  WebExtensionsOn,  // MH 08/02/2010: Global variable to indicate if Web Extensions is licensed

  EnSecurity       { Global Variable to indicate enhanced security is available*}



                : Boolean;

  WebExtEProcurementOn: Boolean; // CJS 18/01/2011: Global variable to indicate if the e-Procurement plug-in is licenced

  // MH 23/10/2017 2018-R1: Added module release code flag for GDPR
  GDPROn : Boolean;

  NofInvLines,
  RetCode       : Integer;

  ICEDFM,          { Global variable to indicate ICE drip feed mode enabled. 0=Off. 1 = Client, 2 = Practice *}

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

Procedure VarConst_Init;     { Called to initialise for new company }

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses Dialogs,
     {$IFDEF OLE}
       Forms,
       ETStru,
     {$ENDIF}

     SysUtils,
     {$IFNDEF SCHEDDLL}
     {$IFNDEF ADMIN}
     HelpSupU,
     BtSupU1,
     BtSupU2,
     {$ENDIF}

     {$IFDEF JC}
       VarJCstU,
     {$ENDIF}
     {$ENDIF SCHEDDLL}

     VARFposU,
     SQLUtils;


{$I VarCnst2.Pas}


{$IFDEF OLE}
{ Opens the files if not registering an ole server }
{ If we are registering an ole server, opening the }
{ files causes the server not to be registered for }
{ some reason...                                   }
Procedure OLEOpenFiles;
Var
  Open         : Boolean;
  I, PLen      : Integer;
  PAth1, Path2 : ANSIString;
Begin
  Open := True;

  { Check we got some params }
  If (ParamCount > 0) Then
    Open := (UpperCase (ParamStr(1)) <> '/REGSERVER') And
            (UpperCase (ParamStr(1)) <> '/UNREGSERVER');

  If Open Then Begin
    { Check to see if we've got a command line directory }
    If (Not FileExists (SetDrive + FileNames[SysF])) Then Begin
      { Have to try directory containing the EXE }
      Path1 := ExtractFilePath(Application.EXEName);
      SetDrive := Path1;

      { Try to get short filename equivalent }
      Path2 := ConstStr (#0, 60);
      PLen := GetShortPathName (PCHAR(Path1), PCHAR(Path2), Length (Path2));
      If (PLen > 0) Then
        SetDrive := Trim(Path2);

      { Display msg if still no data }
      If (Not FileExists (SetDrive + FileNames[SysF])) Then
        MessageDlg ('Error: Cannot find data', mtError, [mbOk], 0);
    End; { If }

    { open data files }
    Open_System (1, TotFiles);
  End; { If }
End;
{$ENDIF}


{ Called when a new company is loaded }
Procedure VarConst_Init;
Begin
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

  DefineNomView;


  {If (DeBug) then
    Ch:=ReadKey;}

  DefineRepScr;
  DefineSys;
End;

Initialization
  //PR: 17/08/2011 Under Windows 7, need to pass a path through, as Current Directory seems to be System32.
  //PR: 03/02/2012 Pre-v6.10 this was restriced to the Service. However, it's safer to use it for the standard engine as well.
  if Trim(SetDrive) = '' then
    SetDrive := GetEnterpriseDirectory;

{ ******************************* Must Be Changed **************************}


  TotFiles:=16;

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

  // MH 08/02/2010: Global variable to indicate if Web Extensions is licensed
  WebExtensionsOn := False;

  // CS 11/03/2013: ABSEXCH-14112 - Default global variable to indicate if the
  // eProcurements module is active
  WebExtEProcurementOn := False;

  // MH 23/10/2017 2018-R1: Added module release code flag for GDPR
  GDPROn := False;

  VRWOn := BOff;

  ICEDFM:=0;

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

  New(NomView);
  New(NomViewFile);

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

  DefineNomView;


  {If (DeBug) then
    Ch:=ReadKey;}

  DefineMLoc;

  DefineRepScr;
  DefineSys;

  {$IFDEF JC}
    Define_PVar;

  {$ENDIF}

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

      StkExcSet    :=  [SQU,PQU,WOR,WIN,SRN,PRN];


    {$ELSE}

      StkAllSet    :=  [SQU];

      StkOrdSet    :=  [PQU];

      StkExcSet    :=  [SOR,WOR,WIN,SRN,PRN];

    {$ENDIF}

  {$ENDIF}

   OpoLineHandle:=0;



  { ======================================================= }




  GetBtParam;



  {$IFDEF DBD}
   If (Debug) and (ExMainCoPath^='') then {* For debug purposes, force it to be same as set drive*}
     ExMainCoPath^:=SetDrive;

  {$ENDIF}


  { Don't open the data files if it's the Form design DLL }
  {$IFNDEF EDLL}
    {$IFNDEF TOOLSMENU}
    {$IFDEF OLE}
      { Don't open the data files if registering the server }
      OLEOpenFiles;
    {$ELSE}


      { Multi User check - do not run for DLL/OLE, or else it hangs! }

      {$IFNDEF REP_ENGINE}
        {$IFNDEF RW_GUI}
          {$IFNDEF SCHEDDLL} //PR: This calls a B_Reset, so don't call it for Schedule.dll
          ULFirstIn:=CheckFile_Open(JMiscF);
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}

      { Open data files }


      {$IFNDEF SCHEDULER}
      Open_System(1,TotFiles);
      {$ENDIF}
    {$ENDIF} {OLE}
    {$ENDIF} {ToolsMenu}
  {$ENDIF}   {EDLL}

{$IFNDEF ADMIN}
{$IFNDEF SCHEDDLL}

        //PR: 10/12/2010 ABSEXCH-2530; ABSEXCH-3008; Need to initialise flags correctly for posting.
        //PR: 03/02/2012 ABSEXCH-2478  Load module release record before checking for Job Costing

        //Moved Open_System call from below.
        Open_System(SysF,SysF);

        //Load System Setup record as it is required by Check_ModRel

        //PR: 30/07/2012 ABSEXCH-13229 Ensure that we don't lock system records
        GlobLocked:=BOff;
        GetMultiSys(False, GlobLocked, SysR);

        GlobLocked:=BOff;
        GetMultiSys(False, GlobLocked, ModRR);

        JBCostOn := Check_ModRel(2,BOn);



        If (JBCostOn) then
        Begin
          CISOn:=(Check_ModRel(16,BOn) or Debug);

          GlobLocked:=BOff;

          If GetMultiSys(BOff,GlobLocked,CISR) then
            Init_STDCISList;
          Close_Files(True);

               FullJAP:=(Check_ModRel(17,BOn) or Debug);

             JAPOn:=FullJAP { or StdJAP};

        end;


        TeleSModule:=Check_ModRel(5,BOn);

        CommitAct:=Check_ModRel(10,BOn);  {*EX431*}

        If (TeleSModule) then {* Auto Release *}
          AnalCuStk:=TeleSModule
        else
          AnalCuStk:=Check_ModRel(6,BOn);

           FullWOP:=Check_ModRel(13,BOn);
           STDWOP:=Check_ModRel(12,BOn);

           WOPOn:=FullWOP or StdWOP;


           RetMOn:=Check_ModRel(20,BOn) or Debug;

          FullStkSysOn:=(Check_ModRel(18,BOn) or Debug or WOPOn);
{$ENDIF SCHEDDLL}
{$ENDIF ADMIN}
{$IFDEF SCHEDULER}
  Open_System(MLocF, MLocF);
{$ENDIF}
Finalization
  {* All Pointers Destroyed via HeapVarTidy in SysU2 v4.01b, 15/12/1997 *}


end.
