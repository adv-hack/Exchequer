Unit VarConst;

{$REALCOMPATIBILITY ON}
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


Uses
     Graphics,
     WinTypes,

     GlobVar,
     BtrvU2,
     VARRec2U;

const



{* File Constants *}


{$I FilePath.Inc}

{$I VerModU.Pas}

  Nof             =  1;

  ErrLogName  =  'ExchBuld.LOG';




Type
  FixFileRec  =  Record

                   ReBuild,
                   FixHed,
                   CreateNFile,
                   HedFixed,
                   PreImgErr
                           :  Boolean;

                   NewFileNo,
                   PageSize,
                   ProcessKey
                           :  Integer;

                   FileLength
                           :  Int64;
                   RecCount
                           :  LongInt;

                   //PR: 29/11/2017 ABSEXCH-19503 Indicates if file is encrypted 
                   Encrypted
                           : Boolean;

                 end;


  { ========= System Types ========== }

  {$I VARCOMNU.PAS}




Const

  QBDiscCode     =  'D';
  QBDiscSub      =  'Q';

  { ============= General Customer Discount Settings ============= }

  CDDiscCode     =  'C';


  BillMatTCode     =  'B';
  BillMatSCode     =  'M';

  NoteTCode      =  'N';
  NoteCCode      =  'A';  {* Cust Note Types (1)*}
  


{$I VARRec.PAS}




var

(*  global variables *)
  Ok,
  NoAbort,         { Global Variable which determines if abort allowed }
  BatchEdit,       { Global Variable to indicate Doc being edited from within a Batch *}
  WarnOnce,
  MUNoCheck,
  PurgeMode

                : Boolean;

  // MH 23/10/2017 2018-R1: Added module release code flag for GDPR
  GDPROn : Boolean;

  RetCode,
  BuildF        : Integer;

  Choice,
  MenuOpt,
  GlobPap,GlobInk,
  GlobAtt       : Byte;

  MuDelay2,
  Lnum          : LongInt;

  RemDirNo      : LongInt;

  GotPassWord,
  GotSecurity   : Boolean; {Flag to determine if Password & Security has been got!}

  FixFile       : Array[1..MaxFiles] of FixFileRec;

  FixLogF       : Text;


  GPPr,GPYr     : Integer;
  GAInc,
  GAExc,
  GTInc,
  GTExc         : Str10;



  { ========== Record Definitions ========== }
Var

   Cust          :   CustRec;
   CustFile      :   Cust_FileDef;

   Inv           :   InvRec;
   InvFile       :   Inv_FileDef;

   Id            :   Idetail;
   IdFile        :   Idetail_Filedef;

   Nom           :   NominalRec;
   NomFile       :   Nominal_FileDef;

   Stock         :   StockRec;
   StockFile     :   Stock_FileDef;

   MLocCtrl      :   MLocPtr;
   MLocFile      :   MLoc_FilePtr;

   NHist         :   HistoryRec;
   NHFile        :   Hist_FileDef;

   Count         :   IncrementRec;
   CountFile     :   Increment_FileDef;

   Password      :   PasswordRec;

   EntryRec      :   ^PassEntryType;

   PassFile      :   PassWord_FileDef;

   MiscRecs      :   MiscRecPtr;

   MiscFile      :   Misc_FilePtr;

   Syss          :   Sysrec;

   SysFile       :   Sys_FileDef;
   SyssVAT       :   VATRecT;
   SyssGCur      :   ^GCurRec;
   SyssCurr      :   CurrRec;
   SyssCurr1P    :   ^Curr1PRec;
   SyssGCur1P    :   ^GCur1PRec;
   SyssDEF       :   DefRecT;
   

   RepScr        :   RepScrPtr;
   RepFile       :   Rep_FilePtr;

   JobMisc       :   JobMiscPtr;

   JobMiscFile   :   JobMisc_FilePtr;


   JobRec        :   JobRecPtr;

   JobRecFile    :   JobRec_FilePtr;

   JobCtrl       :   JobCtrlPtr;

   JobCtrlFile   :   JobCtrl_FilePtr;


   JobDetl       :   JobDetlPtr;

   JobDetlFile   :   JobDetl_FilePtr;

   NomView       :   NomViewPtr;

   NomViewFile   :   NomView_FilePtr;




  Procedure Close_Files(ByFile  :  Boolean);

  Function Checkfile_open(FileNo  :  Integer)  :  Boolean;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  SysUtils,
  Dialogs,
  {$IFDEF EXSQL}
  SQLUtils,
  {$ENDIF}
  VARFposU;

{$I VarCnst2.Pas}


Begin

{ ******************************* Must Be Changed **************************}

  TotFiles:=16  ;

  BuildF:=Succ(Totfiles);

{ ******************************* --------------- **************************}

  MUNoCheck:=BOff;

  GotPassWord:=BOff;
  GotSecurity:=BOff;


  For RetCode:=1 to MaxFiles do
    FillChar(FixFile,Sizeof(FixFile),0);


  Choice:=1;

  RetCode:=1;

  WarnOnce:=BOn;

  RemDirNo:=0;  MuDelay2:=0;

  GPPr:=0; GPYr:=0;
  GAInc:=''; GAExc:='';
  GTInc:=''; GTExc:='';

  NoAbort:=BOff;

  BatchEdit:=BOff;

  PurgeMode:=BOff;

  New(RepScr);

  New(RepFile);


  New(EntryRec);

  FillChar(EntryRec^,Sizeof(EntryRec^),0);
  // MH 23/10/2017 2018-R1: Added module release code flag for GDPR
  GDPROn := False;

  New(MiscRecs);

  New(MiscFile);

  New(JobMisc);
  New(JobMiscFile);


  New(JobRec);
  New(JobRecFile);

  New(JobCtrl);
  New(JobCtrlFile);

  New(JobDetl);
  New(JobDetlFile);


  New(MLocCtrl);
  New(MLocFile);

  New(SyssGCur);

  FillChar(SyssGCur^,Sizeof(SyssGCur^),0);

  New(SyssCurr1P);

  FillChar(SyssCurr1P^,Sizeof(SyssCurr1P^),0);

  New(SyssGCur1P);

  FillChar(SyssGCur1P^,Sizeof(SyssGCur1P^),0);

  New(NomView);
  New(NomViewFile);


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
  DefineNomView;


  DefineJobMisc;
  DefineJobRec;
  DefineJobCtrl;
  DefineJobDetl;

  DefineMLoc;

  {DefineRepScr; Not initialised}


  DefineSys;

  { ================================================ }


  GetBtParam;




end.