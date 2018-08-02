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
  IniFiles,
  WinTypes,
  GlobVar,
  VarRec2U,
  BtrvU2,
  SQLUtils;

const


{$I x:\entrprse\r&d\VerModu.Pas}




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



{ IFDEF PF_On}




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


{ ENDIF}

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

{$I VARRecRp.PAS}

{$I CompVar.Pas}




var

(*  global variables *)
  Ok,
  NoAbort,         { Global Variable which determines if abort allowed }
  BatchEdit,       { Global Variable to indicate Doc being edited from within a Batch *}
  RepWrtOn,        { Global Variable to indicate Report Generator is Present *}
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

  EnSecurity,       { Global Variable to indicate enhanced security is available*}

  WebExtensionsOn  // MH 08/02/2010: Global variable to indicate if Web Extensions is licensed


                : Boolean;
                
  WebExtEProcurementOn: Boolean; // CJS 18/01/2011: Global variable to indicate if the e-Procurement plug-in is licenced

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

   NomView       :   NomViewPtr;

   NomViewFile   :   NomView_FilePtr;

   { Company Record and File }
   Company       :  ^CompRec;
   SyssCompany   :  ^CompRec;
   CompFile      :  Comp_FileDef;

   DictRec       :  ^DataDictRec;
   DictFile      :  ^DataDict_FileDef;

   RepGenRecs    :  ^RepGenRec;
   RepGenFile    :  ^RepGen_FileDef;

   DocStatus     :  ^DocStatusType;

   // MH 06/10/2009: Modified to use the correct type after customers experienced range check errors
   //                HWnd = LongWord which could overflow a LongInt
   OpoLineHandle
                 :  Hwnd; //LongInt;


{ Check its the windows version and its the Enterprise DLL }
{$IFDEF EXWIN}
  Procedure Open_System (Start, Fin : Integer);
  Procedure Close_Files (ByFile : Boolean);

  {$IFNDEF COMTK}
  {$IFNDEF OLE}
    Procedure LoadCompanyOpt;
    {$IFNDEF BUREAUDLL}
    Function  LoadnLockCompanyOpt : Boolean;
    Procedure PutCompanyOpt (Const Unlock : Boolean);
    {$ENDIF}

    procedure BTDelay(dt  :  Word);
  {$ENDIF}
  {$ENDIF}

  // HM 11/06/04: Published so that the Data Copy Wizard can call it prior to
  //              copying the Report Writer reports
  Procedure DefineRepGenRecs;
{$ENDIF}


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses Dialogs,
     Forms,
     SysUtils,

     {$IFDEF JC}
       VarJCstU,
     {$ENDIF}

     VARFposU,
     {$IFDEF OLE}
       VAOUtil,
     {$ELSE}
       {$IFNDEF BUREAUDLL}
       BtSupU1,
       {$ENDIF}
     {$ENDIF}
     PathUtil;

{$I VarCnst2.Pas}

{$I VarCnst3.Pas}

{$I MCmpFile.Pas}


{ IFDEF OLE}

  Function GetReplPath : Str255;
  Var
    IniF : TIniFile;
    EXISN     : ISNArrayType;
  Begin { GetReplPath }
    Result := '';

    IniF := TIniFile.Create (ExtractFilePath (Application.ExeName) + 'ENTWREPL.INI');
    Try
      Result := IniF.ReadString ('UpdateEngine', 'NetworkDir', '');

      If (Length(Result) > 0) Then
        If (Result[Length(Result)] <> '\') Then
          Result := Result + '\';
    Finally
      IniF.Destroy;
    End;
  End;  { GetReplPath }

{ ENDIF}

Initialization

//ShowMessage ('CompRec: ' + IntToStr(SizeOf(CompRec)) + #13 +
//             'CompanyDetRec: ' + IntToStr(SizeOf(CompanyDetRec)) + #13 +
//             'CompanyOptions: ' + IntToStr(SizeOf(CompanyOptions)) + #13 +
//             'HookSecurityRecType: ' + IntToStr(SizeOf(HookSecurityRecType)) + #13 +
//             'UserCountXRefType: ' + IntToStr(SizeOf(UserCountXRefType)) + #13 +
//             'AccessControlType: ' + IntToStr(SizeOf(AccessControlType)) + #13 +
//             'CompOptRelCodeType: ' + IntToStr(SizeOf(CompOptRelCodeType)));

// HM 19/09/01: Added warning message so record sizes can't be accidentally F'd again
{$IFDEF EX600}
If (SizeOf(CompRec) <> 1536) Then
  MessageDlg('The CompVar.CompRec structure is not 1536 bytes', mtError, [mbOK], 0);
{$ELSE}
If (SizeOf(CompRec) <> 1024) Then
  MessageDlg('The CompVar.CompRec structure is not 1024 bytes', mtError, [mbOK], 0);
{$ENDIF}


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

  New(Company);
  FillChar(Company^,Sizeof(Company^),0);
  New(SyssCompany);
  FillChar(SyssCompany^,Sizeof(SyssCompany^),0);

  GetMem (RepGenRecs, SizeOf (RepGenRecs^));
  GetMem (RepGenFile, SizeOf (RepGenFile^));

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

  DefineCompany;

  DefineRepGenRecs;

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


  { HM 03/09/99: Set owners so can open data files for read/write access }
  AssignBOwner(ExBTOWNER);

  {$IFDEF COMP}
    (* Not needed as all files are opened as needed in dll calls
    GetBtParam;

    SetDrive := PathToShort(ExtractFilePath (Application.ExeName));

    { Open data files }
    Open_System(MiscF, MiscF);
    Open_System(CompF, CompF);

    LoadCompanyOpt;
    *)
  {$ENDIF}

  // HM 26/11/02: Modified IFDEF for Excel Drill-Down Server
  { IFDEF OLE}
  {$IF Defined(OLE) And (Not Defined(Drill))}

    { need to hard code the enter key tab on - otherwise login looks like it don't work }
    Syss.TxLateCR := True;

// HM 06/08/04: Replaced for VAO Mods
//    { Need to open company database for OLE Server }
//    If FileExists (ExtractFilePath (Application.ExeName) + 'ENTWREPL.INI') Then Begin
//      { Replication is setup - get network path from replication config file }
//      SetDrive := GetReplPath;
//
//      If (Trim(SetDrive) = '') Then
//        { No path set - use default }
//        SetDrive := PathToShort(ExtractFilePath (Application.ExeName));
//    End { If }
//    Else
//      { No Replication - carry on as normal }
//      SetDrive := PathToShort(ExtractFilePath (Application.ExeName));

    // HM 06/08/04: Take pathing info from VAO Info object which is VAO/LPF aware
    SetDrive := VAOInfo.vaoCompanyDir;

    GetBtParam;

    { Open data files }
    Open_System(CompF, CompF);
  {$IFEND}
  { ENDIF}

  // this coditional define added to open PWrdF, MLocF file in OLE Server
  {$IFDEF OLE}
    Open_System(PWrdF, PWrdF);
    Open_System(MLocF, MLocF);
  {$ENDIF}

Finalization
  {* All Pointers Destroyed via HeapVarTidy in SysU2 v4.01b, 15/12/1997 *}

  { These pointers are specific to the company dll }
  Dispose(SyssCompany);
  Dispose(Company);
  FreeMem (RepGenRecs, SizeOf (RepGenRecs^));
  FreeMem (RepGenFile, SizeOf (RepGenFile^));
end.
