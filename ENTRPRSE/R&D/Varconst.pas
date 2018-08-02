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
  Classes,
  Graphics,
  WinTypes,
  GlobVar,
  VARRec2U,
  VarSortV,
  {$IFDEF PERIODFIX}
    PeriodObj,
  {$ENDIF}
  BtrvU2;

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

  EnSecurity,       { Global Variable to indicate enhanced security is available*}

  WebExtensionsOn  // MH 08/02/2010: Global variable to indicate if Web Extensions is licensed

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
   {$IFDEF PERIODFIX}
     oUserPeriod   :   TUserPeriodInfo;
   {$ENDIF}

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


   {$IFDEF GLCCDEBUG}
   Type
     pStr255 = ^Str255;

   Var
     MemStrs : Array [0..68] of pStr255;
   {$ENDIF}

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

     {$IFDEF JC}
       VarJCstU,
     {$ENDIF}

{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     MultiBuyVar,
     VARFposU,

     //PR: 06/02/2012
     QtyBreakVar,

     //PR: 28/06/2012 ABSEXCH-12956/7 v7.0
     CurrencyHistoryVar,
     BudgetHistoryVar;

     // CJS 2016-04-26 - ABSEXCH-16737 - re-order transactions after SQL migration
     // Removed references to unused units (causing compiler errors in ConvertToSQL)

     // oTaxCodesBtrieveFile, oTaxRegionsBtrieveFile, oStockTaxCodesBtrieveFile, oRegionTaxCodesBtrieveFile;


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
{$IFDEF EXSQL}
    if not SQLUtils.UsingSQL then
    begin
{$ENDIF}
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
{$IFDEF EXSQL}
    end;
{$ENDIF}
    { open data files }
    Open_System (1, TotFiles);
    Open_System(SortViewF, SortViewF);
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

Procedure LogMem (Const Descr : ShortString; Const MemAddr : Pointer; Const MemSize : Integer);
{$IFDEF GLCCDEBUG}
Var
  DbgList : TStringList;
  LI : LongWord;
{$ENDIF}
Begin // LogMem
{$IFDEF GLCCDEBUG}
  DbgList := TStringList.Create;
  Try
    If FileExists ('C:\MemAddr.Txt') Then
      DbgList.LoadFromFile('C:\MemAddr.Txt');

    Move (MemAddr, LI, 4);
    DbgList.Add (Descr + ', ' + IntToStr(LI) + ', ' + IntToStr(MemSize));

    DbgList.SaveToFile('C:\MemAddr.Txt');
  Finally
    DbgList.Free;
  End; // Try..Finally
{$ENDIF}
End; // LogMem

Initialization
//ShowMessage ('BnkRHRecType: ' + IntToStr(SizeOf(BnkRHRecType)));
//ShowMessage ('AllocCType: ' + IntToStr(SizeOf(AllocCType)));
//ShowMessage ('JobRecType: ' + IntToStr(SizeOf(JobRecType)));
//ShowMessage ('StockRec: ' + IntToStr(SizeOf(StockRec)));
//ShowMessage ('CustRec: ' + IntToStr(SizeOf(CustRec)));
//ShowMessage ('InvRec: ' + IntToStr(SizeOf(InvRec)));
//ShowMessage ('IDetail: ' + IntToStr(SizeOf(IDetail)));
//ShowMessage ('SysRec: ' + IntToStr(SizeOf(SysRec)));
//ShowMessage ('JobMiscRec: ' + IntToStr(SizeOf(JobMiscRec)) + #13 +
//             'EmplType: ' + IntToStr(SizeOf(EmplType)));
//ShowMessage ('MLocRec: ' + IntToStr(SizeOf(MLocRec)) + #13 +
//             'TeleCustType: ' + IntToStr(SizeOf(TeleCustType)));

// MH 25/10/2011 v6.9: Added for calculating positions of fields of DDF's
//ShowMessage ('Cust.CustCode: ' + IntToStr(BtKeyPos(@Cust.CustCode, @Cust)-1) + #13 +
//             'Cust.DefTagNo: ' + IntToStr(BtKeyPos(@Cust.DefTagNo, @Cust)-1) + #13 +
//             'Cust.UserDef5: ' + IntToStr(BtKeyPos(@Cust.UserDef5, @Cust)-1) + #13 +
//             'Cust.UserDef6: ' + IntToStr(BtKeyPos(@Cust.UserDef6, @Cust)-1) + #13 +
//             'Cust.UserDef7: ' + IntToStr(BtKeyPos(@Cust.UserDef7, @Cust)-1) + #13 +
//             'Cust.UserDef8: ' + IntToStr(BtKeyPos(@Cust.UserDef8, @Cust)-1) + #13 +
//             'Cust.UserDef9: ' + IntToStr(BtKeyPos(@Cust.UserDef9, @Cust)-1) + #13 +
//             'Cust.UserDef10: ' + IntToStr(BtKeyPos(@Cust.UserDef10, @Cust)-1) + #13 +
//             'Spare: ' + IntToStr(BtKeyPos(@Cust.Spare, @Cust)-1));
//ShowMessage ('Job.JobCode: ' + IntToStr(BtKeyPos(@JobRec^.JobCode, @JobRec^)-1) + #13 +
//             'JQSCode: ' + IntToStr(BtKeyPos(@JobRec^.JQSCode, @JobRec^)-1) + #13 +
//             'UserDef5: ' + IntToStr(BtKeyPos(@JobRec^.UserDef5, @JobRec^)-1) + #13 +
//             'UserDef6: ' + IntToStr(BtKeyPos(@JobRec^.UserDef6, @JobRec^)-1) + #13 +
//             'UserDef7: ' + IntToStr(BtKeyPos(@JobRec^.UserDef7, @JobRec^)-1) + #13 +
//             'UserDef8: ' + IntToStr(BtKeyPos(@JobRec^.UserDef8, @JobRec^)-1) + #13 +
//             'UserDef9: ' + IntToStr(BtKeyPos(@JobRec^.UserDef9, @JobRec^)-1) + #13 +
//             'UserDef10: ' + IntToStr(BtKeyPos(@JobRec^.UserDef10, @JobRec^)-1) + #13 +
//             'Spare2 ' + IntToStr(BtKeyPos(@JobRec^.Spare2, @JobRec^)-1));
//ShowMessage ('Stock.StockCode: ' + IntToStr(BtKeyPos(@Stock.StockCode, @Stock)-1) + #13 +
//             'Stock.ReStockPChr: ' + IntToStr(BtKeyPos(@Stock.ReStockPChr, @Stock)-1) + #13 +
//             'Stock.LastStockType: ' + IntToStr(BtKeyPos(@Stock.LastStockType, @Stock)-1) + #13 +
//             'Stock.StkUser5: ' + IntToStr(BtKeyPos(@Stock.StkUser5, @Stock)-1) + #13 +
//             'Stock.StkUser6: ' + IntToStr(BtKeyPos(@Stock.StkUser6, @Stock)-1) + #13 +
//             'Stock.StkUser7: ' + IntToStr(BtKeyPos(@Stock.StkUser7, @Stock)-1) + #13 +
//             'Stock.StkUser8: ' + IntToStr(BtKeyPos(@Stock.StkUser8, @Stock)-1) + #13 +
//             'Stock.StkUser9: ' + IntToStr(BtKeyPos(@Stock.StkUser9, @Stock)-1) + #13 +
//             'Stock.StkUser10: ' + IntToStr(BtKeyPos(@Stock.StkUser10, @Stock)-1) + #13 +
//             'Stock.Spare_2: ' + IntToStr(BtKeyPos(@Stock.Spare_2, @Stock)-1));
//ShowMessage ('Inv.RunNo: ' + IntToStr(BtKeyPos(@Inv.RunNo, @Inv)-1) + #13 +
//             'Inv.Spare5: ' + IntToStr(BtKeyPos(@Inv.Spare5, @Inv)-1) + #13 +
//             'Inv.YourRef: ' + IntToStr(BtKeyPos(@Inv.YourRef, @Inv)-1) + #13 +
//             'Inv.DocUser5: ' + IntToStr(BtKeyPos(@Inv.DocUser5, @Inv)-1) + #13 +
//             'Inv.DocUser6: ' + IntToStr(BtKeyPos(@Inv.DocUser6, @Inv)-1) + #13 +
//             'Inv.DocUser7: ' + IntToStr(BtKeyPos(@Inv.DocUser7, @Inv)-1) + #13 +
//             'Inv.DocUser8: ' + IntToStr(BtKeyPos(@Inv.DocUser8, @Inv)-1) + #13 +
//             'Inv.DocUser9: ' + IntToStr(BtKeyPos(@Inv.DocUser9, @Inv)-1) + #13 +
//             'Inv.DocUser10: ' + IntToStr(BtKeyPos(@Inv.DocUser10, @Inv)-1) + #13 +
//             'Inv.Spare600: ' + IntToStr(BtKeyPos(@Inv.Spare600, @Inv)-1)
//            );
//ShowMessage ('IDetail.tlFolio: ' + IntToStr(BtKeyPos(@Id.FolioRef, @Id)-1) + #13 +
//             'IDetail.tlToPostCode: ' + IntToStr(BtKeyPos(@Id.tlToPostCode, @Id)-1) + #13 +
//             'IDetail.LineUser5: ' + IntToStr(BtKeyPos(@Id.LineUser5, @Id)-1) + #13 +
//             'IDetail.LineUser6: ' + IntToStr(BtKeyPos(@Id.LineUser6, @Id)-1) + #13 +
//             'IDetail.LineUser7: ' + IntToStr(BtKeyPos(@Id.LineUser7, @Id)-1) + #13 +
//             'IDetail.LineUser8: ' + IntToStr(BtKeyPos(@Id.LineUser8, @Id)-1) + #13 +
//             'IDetail.LineUser9: ' + IntToStr(BtKeyPos(@Id.LineUser9, @Id)-1) + #13 +
//             'IDetail.LineUser10: ' + IntToStr(BtKeyPos(@Id.LineUser10, @Id)-1) + #13 +
//             'IDetail.Spare2: ' + IntToStr(BtKeyPos(@Id.Spare2, @Id)-1)
//            );

// MH 04/09/2009: Added for calculating positions of fields of DDF's
//ShowMessage ('JobMiscRec.EmplRec.EmpCode: ' + IntToStr(BtKeyPos(@JobMisc^.EmplRec.EmpCode, @JobMisc^)-1) + #13 +
//             'JobMisc^.EmplRec.ENINo: ' + IntToStr(BtKeyPos(@JobMisc^.EmplRec.ENINo, @JobMisc^)-1) + #13 +
//             'JobMisc^.EmplRec.LabPLOnly: ' + IntToStr(BtKeyPos(@JobMisc^.EmplRec.LabPLOnly, @JobMisc^)-1) + #13 +
//             'JobMisc^.EmplRec.UTRCode: ' + IntToStr(BtKeyPos(@JobMisc^.EmplRec.UTRCode, @JobMisc^)-1) + #13 +
//             'JobMisc^.EmplRec.VerifyNo: ' + IntToStr(BtKeyPos(@JobMisc^.EmplRec.VerifyNo, @JobMisc^)-1) + #13 +
//             'JobMisc^.EmplRec.Tagged: ' + IntToStr(BtKeyPos(@JobMisc^.EmplRec.Tagged, @JobMisc^)-1) + #13 +
//             'JobMisc^.EmplRec.CISSubType: ' + IntToStr(BtKeyPos(@JobMisc^.EmplRec.CISSubType, @JobMisc^)-1) + #13 +
//             'JobMisc^.EmplRec.emEmailAddr: ' + IntToStr(BtKeyPos(@JobMisc^.EmplRec.emEmailAddr, @JobMisc^)-1) + #13 +
//             'JobMisc^.EmplRec.Spare600: ' + IntToStr(BtKeyPos(@JobMisc^.EmplRec.Spare600, @JobMisc^)-1)
//            );


{ ******************************* Must Be Changed **************************}


  TotFiles:=16;

{ ******************************* --------------- **************************}

{$IFDEF GLCCDEBUG}
  New(MemStrs[0]);  MemStrs[0]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[0]', MemStrs[0], SizeOf(MemStrs[0]^));
{$ENDIF}


  New(DocStatus);

  FillChar(DocStatus^,SizeOf(DocStatus^),0);


  Choice:=1;

  RetCode:=1;

  NofInvLines:=15;

{$IFDEF GLCCDEBUG}
  New(MemStrs[1]);  MemStrs[1]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[1]', MemStrs[1], SizeOf(MemStrs[1]^));
{$ENDIF}

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

{$IFDEF GLCCDEBUG}
  New(MemStrs[2]);  MemStrs[2]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[2]', MemStrs[2], SizeOf(MemStrs[2]^));
{$ENDIF}
  New(CCVATName);

  FillChar(CCVATName^,Sizeof(CCVATName^),0);
  LogMem ('CCVATName', @CCVATName^, SizeOf(CCVATName^));

{$IFDEF GLCCDEBUG}
  New(MemStrs[3]);  MemStrs[3]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[3]', MemStrs[3], SizeOf(MemStrs[3]^));
{$ENDIF}
  New(CCCISName);

  FillChar(CCCISName^,Sizeof(CCCISName^),0);
  LogMem ('CCCISName', CCCISName, SizeOf(CCCISName^));

{$IFDEF GLCCDEBUG}
  New(MemStrs[4]);  MemStrs[4]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[4]', MemStrs[4], SizeOf(MemStrs[4]^));
{$ENDIF}
  New(MiscRecs);
  LogMem ('MiscRecs', MiscRecs, SizeOf(MiscRecs^));

{$IFDEF GLCCDEBUG}
  New(MemStrs[5]);  MemStrs[5]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[5]', MemStrs[5], SizeOf(MemStrs[5]^));
{$ENDIF}
  New(MiscFile);
  LogMem ('MiscFile', MiscFile, SizeOf(MiscFile^));

{$IFDEF GLCCDEBUG}
  New(MemStrs[6]);  MemStrs[6]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[6]', MemStrs[6], SizeOf(MemStrs[6]^));
{$ENDIF}
  New(RepScr);
  LogMem ('RepScr', RepScr, SizeOf(RepScr^));

{$IFDEF GLCCDEBUG}
  New(MemStrs[7]);  MemStrs[7]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[7]', MemStrs[7], SizeOf(MemStrs[7]^));
{$ENDIF}
  New(RepFile);
  LogMem ('RepFile', RepFile, SizeOf(RepFile^));

{$IFDEF GLCCDEBUG}
  New(MemStrs[8]);  MemStrs[8]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[8]', MemStrs[8], SizeOf(MemStrs[8]^));
  New(MemStrs[53]);  MemStrs[53]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[53]', MemStrs[53], SizeOf(MemStrs[53]^));
  New(MemStrs[54]);  MemStrs[54]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[54] (8A)', MemStrs[54], SizeOf(MemStrs[54]^));
  New(MemStrs[55]);  MemStrs[55]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[55] (8B)', MemStrs[55], SizeOf(MemStrs[55]^));
  New(MemStrs[56]);  MemStrs[56]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[56] (8C)', MemStrs[56], SizeOf(MemStrs[56]^));
  New(MemStrs[57]);  MemStrs[57]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[57] (8D)', MemStrs[57], SizeOf(MemStrs[57]^));
  New(MemStrs[58]);  MemStrs[58]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[58] (8E)', MemStrs[58], SizeOf(MemStrs[58]^));
  New(MemStrs[59]);  MemStrs[59]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[59] (8F)', MemStrs[59], SizeOf(MemStrs[59]^));
  New(MemStrs[60]);  MemStrs[60]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[60] (8G)', MemStrs[60], SizeOf(MemStrs[60]^));
  New(MemStrs[61]);  MemStrs[61]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[61] (8H)', MemStrs[61], SizeOf(MemStrs[61]^));
  New(MemStrs[62]);  MemStrs[62]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[62] (8I)', MemStrs[62], SizeOf(MemStrs[62]^));
  New(MemStrs[63]);  MemStrs[63]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[63] (8J)', MemStrs[63], SizeOf(MemStrs[63]^));
  New(MemStrs[64]);  MemStrs[64]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[64] (8K)', MemStrs[64], SizeOf(MemStrs[64]^));
  New(MemStrs[65]);  MemStrs[65]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[65] (8L)', MemStrs[65], SizeOf(MemStrs[65]^));
  New(MemStrs[66]);  MemStrs[66]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[66] (8M)', MemStrs[66], SizeOf(MemStrs[66]^));
  New(MemStrs[67]);  MemStrs[67]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[67] (8N)', MemStrs[67], SizeOf(MemStrs[67]^));
  New(MemStrs[68]);  MemStrs[68]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[68] (8O)', MemStrs[68], SizeOf(MemStrs[68]^));
{$ENDIF}
  New(CInv);
  LogMem ('CInv', CInv, SizeOf(CInv^));

{$IFDEF GLCCDEBUG}
  New(MemStrs[9]);  MemStrs[9]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[9]', MemStrs[9], SizeOf(MemStrs[9]^));
{$ENDIF}
  New(CId);
  LogMem ('CId', CId, SizeOf(CId^));

{$IFDEF GLCCDEBUG}
  New(MemStrs[10]);  MemStrs[10]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[10]', MemStrs[10], SizeOf(MemStrs[10]^));
{$ENDIF}
  New(CStock);
  LogMem ('CStock', CStock, SizeOf(CStock^));

{$IFDEF GLCCDEBUG}
  New(MemStrs[11]);  MemStrs[11]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[11]', MemStrs[11], SizeOf(MemStrs[11]^));
{$ENDIF}
  New(EntryRec);
  LogMem ('EntryRec', EntryRec, SizeOf(EntryRec^));

{$IFDEF GLCCDEBUG}
  New(MemStrs[12]);  MemStrs[12]^ := StringOfChar('A', 255);
  LogMem ('MemStrs[12]', MemStrs[12], SizeOf(MemStrs[12]^));
{$ENDIF}
  New(UserProfile);
  {$IFDEF PERIODFIX}
{$IFDEF GLCCDEBUG}
  New(MemStrs[13]);  MemStrs[13]^ := StringOfChar('A', 255);
{$ENDIF}
  oUserPeriod := TUserPeriodInfo.Create;
  {$ENDIF}

{$IFDEF GLCCDEBUG}
  New(MemStrs[14]);  MemStrs[14]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssJob);

{$IFDEF GLCCDEBUG}
  New(MemStrs[15]);  MemStrs[15]^ := StringOfChar('A', 255);
{$ENDIF}
  New(ViewPr);
{$IFDEF GLCCDEBUG}
  New(MemStrs[16]);  MemStrs[16]^ := StringOfChar('A', 255);
{$ENDIF}
  New(ViewYr);

  ViewPr^:=0;
  ViewYr^:=0;

{$IFDEF GLCCDEBUG}
  New(MemStrs[17]);  MemStrs[17]^ := StringOfChar('A', 255);
{$ENDIF}
  New(AccelParam);

  FillChar(AccelParam^,Sizeof(AccelParam^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[18]);  MemStrs[18]^ := StringOfChar('A', 255);
{$ENDIF}
  New(ExVersParam);
  FillChar(ExVersParam^,Sizeof(ExVersParam^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[19]);  MemStrs[19]^ := StringOfChar('A', 255);
{$ENDIF}
  New(RepWrtName);

  FillChar(RepWrtName^,Sizeof(RepWrtName^),0);

  RepWrtName^:='EXREPWRT.EXE';

{$IFDEF GLCCDEBUG}
  New(MemStrs[20]);  MemStrs[20]^ := StringOfChar('A', 255);
{$ENDIF}
  New(JBCostName);

  FillChar(JBCostName^,Sizeof(JBCostName^),0);

  JBCostName^:='EXJBCOST.EXE';

  DocEditedNow:=0;
  StkEditedNow:=0;

{$IFDEF GLCCDEBUG}
  New(MemStrs[21]);  MemStrs[21]^ := StringOfChar('A', 255);
{$ENDIF}
  New(DocEditNowList);

  FillChar(DocEditNowList^,Sizeof(DocEditNowList^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[22]);  MemStrs[22]^ := StringOfChar('A', 255);
{$ENDIF}
  New(StkEditNowList);

  FillChar(StkEditNowList^,Sizeof(StkEditNowList^),0);

  RemDirNo:=0;

{$IFDEF GLCCDEBUG}
  New(MemStrs[23]);  MemStrs[23]^ := StringOfChar('A', 255);
{$ENDIF}
  New(JobMisc);
{$IFDEF GLCCDEBUG}
  New(MemStrs[24]);  MemStrs[24]^ := StringOfChar('A', 255);
{$ENDIF}
  New(CJobMisc);
{$IFDEF GLCCDEBUG}
  New(MemStrs[25]);  MemStrs[25]^ := StringOfChar('A', 255);
{$ENDIF}
  New(JobMiscFile);

  FillChar(CJobMisc^,Sizeof(CJobMisc^),0);


{$IFDEF GLCCDEBUG}
  New(MemStrs[26]);  MemStrs[26]^ := StringOfChar('A', 255);
{$ENDIF}
  New(JobRec);
{$IFDEF GLCCDEBUG}
  New(MemStrs[27]);  MemStrs[27]^ := StringOfChar('A', 255);
{$ENDIF}
  New(CJobRec);
{$IFDEF GLCCDEBUG}
  New(MemStrs[28]);  MemStrs[28]^ := StringOfChar('A', 255);
{$ENDIF}
  New(JobRecFile);

  FillChar(CJobRec^,Sizeof(CJobRec^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[29]);  MemStrs[29]^ := StringOfChar('A', 255);
{$ENDIF}
  New(JobCtrl);
{$IFDEF GLCCDEBUG}
  New(MemStrs[30]);  MemStrs[30]^ := StringOfChar('A', 255);
{$ENDIF}
  New(JobCtrlFile);


{$IFDEF GLCCDEBUG}
  New(MemStrs[31]);  MemStrs[31]^ := StringOfChar('A', 255);
{$ENDIF}
  New(JobDetl);
{$IFDEF GLCCDEBUG}
  New(MemStrs[32]);  MemStrs[32]^ := StringOfChar('A', 255);
{$ENDIF}
  New(CJobDetl);
{$IFDEF GLCCDEBUG}
  New(MemStrs[33]);  MemStrs[33]^ := StringOfChar('A', 255);
{$ENDIF}
  New(JobDetlFile);

  FillChar(CJobDetl^,Sizeof(CJobDetl^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[34]);  MemStrs[34]^ := StringOfChar('A', 255);
{$ENDIF}
  New(NomView);
{$IFDEF GLCCDEBUG}
  New(MemStrs[35]);  MemStrs[35]^ := StringOfChar('A', 255);
{$ENDIF}
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

{$IFDEF GLCCDEBUG}
  New(MemStrs[36]);  MemStrs[36]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssVAT);
  FillChar(SyssVAT^,Sizeof(SyssVAT^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[37]);  MemStrs[37]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssCIS);
  FillChar(SyssCIS^,Sizeof(SyssCIS^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[38]);  MemStrs[38]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssCIS340);
  FillChar(SyssCIS340^,Sizeof(SyssCIS340^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[39]);  MemStrs[39]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssCurr);
  FillChar(SyssCurr^,Sizeof(SyssCurr^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[40]);  MemStrs[40]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssGCur);
  FillChar(SyssGCur^,Sizeof(SyssGCur^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[41]);  MemStrs[41]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssCurr1P);

  FillChar(SyssCurr1P^,Sizeof(SyssCurr1P^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[42]);  MemStrs[42]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssGCur1P);

  FillChar(SyssGCur1P^,Sizeof(SyssGCur1P^),0);


{$IFDEF GLCCDEBUG}
  New(MemStrs[43]);  MemStrs[43]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssDEF);
  FillChar(SyssDEF^,Sizeof(SyssDEF^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[44]);  MemStrs[44]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssForms);
  FillChar(SyssForms^,Sizeof(SyssForms^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[45]);  MemStrs[45]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssMod);

  FillChar(SyssMod^,Sizeof(SyssMod^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[46]);  MemStrs[46]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssEDI1);

  FillChar(SyssEDI1^,Sizeof(SyssEDI1^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[47]);  MemStrs[47]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssEDI2);

  FillChar(SyssEDI2^,Sizeof(SyssEDI2^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[48]);  MemStrs[48]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssEDI3);

  FillChar(SyssEDI3^,Sizeof(SyssEDI3^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[49]);  MemStrs[49]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssCstm);

  FillChar(SyssCstm^,Sizeof(SyssCstm^),0);

{$IFDEF GLCCDEBUG}
  New(MemStrs[50]);  MemStrs[50]^ := StringOfChar('A', 255);
{$ENDIF}
  New(SyssCstm2);

  FillChar(SyssCstm2^,Sizeof(SyssCstm2^),0);


{$IFDEF GLCCDEBUG}
  New(MemStrs[51]);  MemStrs[51]^ := StringOfChar('A', 255);
{$ENDIF}
  New(MLocCtrl);
{$IFDEF GLCCDEBUG}
  New(MemStrs[52]);  MemStrs[52]^ := StringOfChar('A', 255);
{$ENDIF}
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

  DefineSortView;
  DefineSortViewDefault;
  DefineSortTemp;

  {If (DeBug) then
    Ch:=ReadKey;}

  DefineMLoc;

  DefineRepScr;
  DefineSys;

  {$IFDEF JC}
    Define_PVar;

  {$ENDIF}

  {$IFDEF SOP}
  DefineMultiBuyDiscounts;
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
  {$IFNDEF NOAUTOOPEN}
    {$IFNDEF TOOLSMENU}
    {$IFDEF OLE}
      { Don't open the data files if registering the server }
      OLEOpenFiles;
    {$ELSE}


      { Multi User check - do not run for DLL/OLE, or else it hangs! }

      {$IFNDEF REP_ENGINE}
        {$IFNDEF RW_GUI}
          ULFirstIn:=CheckFile_Open(JMiscF);
        {$ENDIF}
      {$ENDIF}

      { Open data files }



       Open_System(1,TotFiles);
       Open_System(SortViewF, SVUDefaultF);
       {$IFDEF SOP}
       Open_System(MultiBuyF,MultiBuyF);
       {$ENDIF}

       //PR: 06/02/2012 ABSEXCH-9795
       {$IFDEF STK}
       Open_System(QtyBreakF,QtyBreakF);
       {$ENDIF}

       //PR: 28/06/2012 ABSEXCH-12956/7 v7.0
       Open_System(CurrencyHistoryF, CurrencyHistoryF);
       Open_System(BudgetHistoryF, BudgetHistoryF);

//oTaxCodesBtrieveFile.CreateTaxCodesFile(SetDrive);
//oTaxRegionsBtrieveFile.CreateTaxRegionsFile(SetDrive);
//oStockTaxCodesBtrieveFile.CreateStockTaxCodesFile(SetDrive);
//oRegionTaxCodesBtrieveFile.CreateRegionTaxCodesFile(SetDrive);

    {$ENDIF} {OLE}
    {$ENDIF} {ToolsMenu}
  {$ENDIF} // NOAUTOOPEN
  {$ENDIF}   {EDLL}



Finalization
  {* All Pointers Destroyed via HeapVarTidy in SysU2 v4.01b, 15/12/1997 *}

  {$IFDEF PERIODFIX}
  FreeAndNIL(oUserPeriod);
  {$ENDIF}

end.
