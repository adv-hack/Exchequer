Unit VarConst;

{$ALIGN 1}


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

Uses
  Graphics,
  IniFiles,
  WinTypes,
  GlobVar,
  BtrvU2,
  VarRec2U;

const


{$I VerModu.Pas}




  PostMultiRunCtrl:  Boolean  =  BOn; {* Post One Run time Ctrl Line For Entire Posting Run *}

  NofChaseLtrs    =   3;            {* Max No of Chase Letters *}




  {$I VARCOMNU.Pas}
  {$I VARCMN3U.Pas}


Type
  DocEditNListType    =  Array[0..10] of LongInt;

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
                   {024}  Access    :  Array[0..512] of Byte;
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
  { SCode set to TradeCode }

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
  {$IFDEF EN550CIS}
    CISOn,         {Global Variable to indicate CIS module enabled}
  {$ENDIF}
  EnSecurity       { Global Variable to indicate enhanced security is available*}



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

  CCVATName
  {$IFDEF EN550CIS}
    ,CCCISName
  {$ENDIF}
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
  InVATP,
  InCtrl,
  InCurr,
  InPopKy,
  InChangePr,
  InStock,
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
   SyssDEF       :   ^DefRecT;
   SyssForms     :   ^FormDefsRecType;
   SyssMod       :   ^ModRelRecType;
   SyssGCur      :   ^GCurRec;
   SyssCurr1P    :   ^Curr1PRec;
   SyssGCur1P    :   ^GCur1PRec;

   SyssJob       :   ^JobSRecT;
   SyssEDI1      :   ^EDI1Rec;
   SyssEDI2      :   ^EDI2Rec;
   SyssEDI3      :   ^EDI3Rec;

   SyssCstm,
   SyssCstm2     :   ^CustomFRec;

   {$IFDEF EN550CIS}
     SyssCIS       :   ^CISRecT;
   {$ENDIF}
     
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

   { Company Record and File }
   Company       :  ^CompRec;
   SyssCompany   :  ^CompRec;
   CompFile      :  Comp_FileDef;

   DictRec       :  ^DataDictRec;
   DictFile      :  ^DataDict_FileDef;

   RepGenRecs    :  ^RepGenRec;
   RepGenFile    :  ^RepGen_FileDef;

   DocStatus     :  ^DocStatusType;


{ Check its the windows version and its the Enterprise DLL }
{$IFDEF EXWIN}
  Procedure Open_System (Start, Fin : Integer);
  Procedure Close_Files (ByFile : Boolean);

  {$IFNDEF COMTK}
  {$IFNDEF OLE}
    Procedure LoadCompanyOpt;
    Function  LoadnLockCompanyOpt : Boolean;
    Procedure PutCompanyOpt (Const Unlock : Boolean);

    procedure BTDelay(dt  :  Word);
  {$ENDIF}
  {$ENDIF}  
{$ENDIF}


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses Dialogs,
     Forms,
     SysUtils,
     VARFposU,
     {$IFNDEF OLE}
     BtSupU1,
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
(*
ShowMessage ('CompRec: ' + IntToStr(SizeOf(CompRec)) + #13 +
             'CompanyDetRec: ' + IntToStr(SizeOf(CompanyDetRec)) + #13 +
             'CompanyOptions: ' + IntToStr(SizeOf(CompanyOptions)) + #13 +
             'HookSecurityRecType: ' + IntToStr(SizeOf(HookSecurityRecType)) + #13 +
             'UserCountXRefType: ' + IntToStr(SizeOf(UserCountXRefType)) + #13 +
             'CompOptRelCodeType: ' + IntToStr(SizeOf(CompOptRelCodeType)));
(*   *)

// HM 19/09/01: Added warning message so record sizes can't be accidentally F'd again
If (SizeOf(CompRec) <> 1024) Then
  MessageDlg('The CompVar.CompRec structure is not 1024 bytes', mtError, [mbOK], 0);


{ ******************************* Must Be Changed **************************}

  TotFiles:=15  ;

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
  EuroVers:=BOff;
  SWInfoSOn:=BOff;
  SWBentlyOn:=BOff;

  TeleSModule:=BOff;
  eBusModule:=BOff;
  eCommsModule:=BOff;
  AnalCuStk:=BOff;
  CommitAct:=BOff;
  WOPOn:=BOff;
  FullWOP:=BOff;
  STDWOP:=BOff;

  {$IFDEF EN550CIS}
    CISOn:=BOff;
  {$ENDIF}

  EnSecurity:=BOff;

  BTFileVer:=0;
  GotPassWord:=BOff;
  GotSecurity:=BOff;

  {RemitDoc:='';

  LastMDoc:=FOL;}

  { =========== Hot Key Definitions ============ }

    AllowHotKey:=BOn;
    InHelp:=BOff;
    InHelpNdx:=BOff;
    InCust:=BOff;
    InNom:=BOff;
    InVATP:=BOff;
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

    FillChar(InSRC,Sizeof(InSRC),0);

    InStockEnq:=BOff;

  { ============================================ }


  { =========== Btrieve File Definitions ============ }

  New(CCVATName);

  FillChar(CCVATName^,Sizeof(CCVATName^),0);

  {$IFDEF EN550CIS}
    New(CCCISName);

    FillChar(CCCISName^,Sizeof(CCCISName^),0);
  {$ENDIF}

  New(MiscRecs);

  New(MiscFile);

  New(RepScr);

  New(RepFile);

  New(CInv);

  New(CId);

  New(CStock);

  New(EntryRec);

  New(UserProfile);
  FillChar(UserProfile^,Sizeof(UserProfile^),0);

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

  New(SyssVAT);
  FillChar(SyssVAT^,Sizeof(SyssVAT^),0);

  {$IFDEF EN550CIS}
    New(SyssCIS);
    FillChar(SyssCIS^,Sizeof(SyssCIS^),0);
  {$ENDIF}

  New(SyssCurr);
  FillChar(SyssCurr^,Sizeof(SyssCurr^),0);

  New(SyssDEF);
  FillChar(SyssDEF^,Sizeof(SyssDEF^),0);

  New(SyssForms);
  FillChar(SyssForms^,Sizeof(SyssForms^),0);

  New(SyssMod);
  FillChar(SyssMod^,Sizeof(SyssMod^),0);

  New(SyssGCur);
  FillChar(SyssGCur^,Sizeof(SyssGCur^),0);

  New(SyssCurr1P);
  FillChar(SyssCurr1P^,Sizeof(SyssCurr1P^),0);

  New(SyssGCur1P);
  FillChar(SyssGCur1P^,Sizeof(SyssGCur1P^),0);

  New(SyssJob);
  FillChar(SyssJob^,Sizeof(SyssJob^),0);

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

  New(SyssEDI1);
  FillChar(SyssEDI1^,Sizeof(SyssEDI1^),0);
  New(SyssEDI2);
  FillChar(SyssEDI2^,Sizeof(SyssEDI2^),0);
  New(SyssEDI3);
  FillChar(SyssEDI3^,Sizeof(SyssEDI3^),0);


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


  {If (DeBug) then
    Ch:=ReadKey;}

  DefineMLoc;

  DefineRepScr;
  DefineSys;

  DefineCompany;

  DefineRepGenRecs;

  { ================================================ }


  { ======== Set up Copy Records ======== }

    CId^:=Id;

    CInv^:=Inv;

    CStock^:=Stock;

    FillChar(EntryRec^,Sizeof(EntryRec^),0);

  { ===================================== }


  { =========== Printable Document Definitions ============ }


  { == Docs where a Print def allowed (JC) replicated == }

  DEFPrnSet :=  [SIN,SCR,SJI,SJC,SRF,SRI,SBT,SQU,SOR,SDN,PIN,PCR,PJI,PJC,PRF,PPI,PPY,PBT,PQU,POR,NMT,ADJ,TSH];


  { ======== Determine Stock allocation control ======== }

  {$IFDEF STK}

    {$IFDEF PF_On}

      StkAllSet    :=  [SOR];

      StkOrdSet    :=  [POR];

      StkExcSet    :=  [SQU,PQU];

    {$ELSE}

      StkAllSet    :=  [SQU];

      StkOrdSet    :=  [PQU];

      StkExcSet    :=  [SOR];

    {$ENDIF}

  {$ENDIF}



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

    { Need to open company database for OLE Server }
    If FileExists (ExtractFilePath (Application.ExeName) + 'ENTWREPL.INI') Then Begin
      { Replication is setup - get network path from replication config file }
      SetDrive := GetReplPath;

      If (Trim(SetDrive) = '') Then
        { No path set - use default }
        SetDrive := PathToShort(ExtractFilePath (Application.ExeName));
    End { If }
    Else
      { No Replication - carry on as normal }
      SetDrive := PathToShort(ExtractFilePath (Application.ExeName));

    GetBtParam;

    { Open data files }
    Open_System(CompF, CompF);
  {$IFEND}
  { ENDIF}

Finalization
  {* All Pointers Destroyed via HeapVarTidy in SysU2 v4.01b, 15/12/1997 *}

  { These pointers are specific to the company dll }
  Dispose(SyssCompany);
  Dispose(Company);
  FreeMem (RepGenRecs, SizeOf (RepGenRecs^));
  FreeMem (RepGenFile, SizeOf (RepGenFile^));
end.
