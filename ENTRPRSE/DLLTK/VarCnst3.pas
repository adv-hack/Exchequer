Unit VarCnst3;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }





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
     {$IFDEF EXWIN}
       Graphics,
       WinTypes,
       Dialogs,
     {$ENDIF}

     {$IFDEF WIN32}
       BtrvU2,
     {$ELSE}
       {$IFNDEF SET16}    { HM 08/10/97: Do not include for Toolkit Setup DLL }
         BtrvU16,
       {$ENDIF}
     {$ENDIF}

     SysUtils,
     GlobVar,
     {$IFDEF WIN32}
       VarRec2U,
     {$ELSE}
       VRec2U,
     {$ENDIF}
     {$IFDEF COMTK}
      Classes,
     {$ENDIF}
     {$IFDEF SOPDLL}
      Classes,
     {$ENDIF}
     VarConst;

Const

  SECTESTMODE =  'SECTESTMODE'; {* For release code parameter --- To Confirm --- *}
  IEDEBUGMODE =  'DEBUGMODE121';

  {* 20.2.97 add JB validate
     26.2.97 add multi location
     28.7.98 add Last_Batch_Date
     29.4.02 add Ex_Allow_QtyDel_Set for Heinz import
     30.4.02 add Ex_Allow_TotalWeight_Set +
                 Ex_Allow_TotalCost_Set also for Heinz import
     2.12.03 add Ex_DiscountDecimals                          *}

     //PR: 15/10/2013 MRD 2.5.18 v7.0.7 Added PostcodeMapping to list. Removed IMPV6 ifdefs as they make it harder to extend list
     //PR: 29/10/2013 ABSEXCH-14705 Added DefaultUser

  NoSws       =  32;

  SetUpSw     :  Array[1..NoSws] of String[25] = (
                                        {01}   'Auto_Set_Period',
                                        {02}   'Default_Nominal',
                                        {03}   'Default_Cost_Centre',
                                        {04}   'Default_Department',
                                        {05}   'Default_VAT_Code',   {* 19.08.99 *}
                                        {06}   'Auto_Set_Stock_Cost',
                                        {07}   'Deduct_BOM_Stock',
                                        {08}   'Deduct_MultiLoc_Stock',
                                        {09}   'Overwrite_Trans_No',
                                        {10}   'Overwrite_Note_Pad',
                                        {11}   'Use_Ex_Currency',
                                        {12}   'Allow_Trans_Edit',
                                        {13}   'Report_to_Printer',
                                        {14}   'Report_to_File',
                                        {15}   'Exchequer_Path',
					{16}   'Multi_Currency',
                                        {17}   'Default_Currency',
					{18}   'Update_Account_Bal',
                                        {19}   'Update_Stock_Levels',
                                        {20}   'Ignore_JobCost_Validation',
                                        {21}   'Last_Batch_Date',
                                        {22}   'Ex_Allow_QtyDel_Set',
                                        {23}   'Ex_Allow_TotalWeight_Set',
                                        {24}   'Ex_Allow_TotalCost_Set',
                                        {25}   'No_Trans_To_Closed_Job',
                                        {26}   'Discount_Decimals',
                                        {27}   'SQL_Cache_Mode',
                                        {28}   'SQL_Refresh_Interval',
                                        {29}   'Apply_VBD',
                                        {30}   'Apply_MBD',
                                        {31}   'Del_Postcode_Mapping',
                                        {32}   'Default_User'
                                              );



     { ==================== System Record ================== }
{$IFNDEF WIN32}
    StkLineType    :  Array[DocTypes] of Char       = ('I','X','I','I','I','I','I','Q','O','I','I','S','X','X','X',
                                                       'N','X','N','N','N','N','N','U','R','N','N','P','X','X','X',
                                                       'X','X','X','X','X','A','X','X','X','X','W','T','X');

  { ============= Stock Alloc File Settings =========== }


  AllocTCode      =  'A';
  AllocSCode      =  'B';
  AllocPCode      =  'P';
  AllocUCode      =  'U';
  AllocBCode      =  'O';


{$ENDIF}

{$IFDEF COMTK}
  {$I ExchCtk.Inc}
{$ELSE}
  {$IFDEF SOPDLL}
    {$I ExchCtk.Inc}
  {$ELSE}
    {$I ExchDll.Inc}
  {$ENDIF}
{$ENDIF}

Type

  DictLinkType  =  Record
                     DCr,
                     DPr,
                     DYr   :  Byte;
                   end;


  ExSysRec = Record

             Spare3    :  Array[1..2] of Char;

             Opt       :  Char;

             BatchPath,
             RFileN,
             ExPath    :  Str255;

             ImpDisplay
                       :  Boolean;

             RejectBatch
                       :  Boolean;

             CheckDupli
                       :  Boolean;

             ReverseTrans
                       :  Boolean;
             AutoSetPr :  Boolean;

	     MCMode    :  Boolean;

	     UpAccBal  :  Boolean;

             UpStkBal  :  Boolean;

             DeductBOM :  Boolean;

             DelBatFile:  Boolean;

             UseEOFFlg :  Boolean;

             AutoSetStkCost
                       :  Boolean;

             OverWORef,
             OverWNPad :  Boolean;

             UseExCrRate
                       :  Boolean;

             WarnFError,
             AllowEdit,
             RepPrn,
             RepFile   :  Boolean;

             DefNom    :  LongInt;

             DefCust   :  String[10];
             DefSupp   :  String[10];
             DefCCDep  :  CCDepType;
             DefStk    :  String[20];
             DefVAT    :  Char;
             DefSValTyp:  Char;
             DefCur    :  Byte;

             LastDate  :  LongDate;

             RPrnNo    :  Integer;

             UserName  :  String[30];

             Expansion :  string[38];

             JBIgnore  :  Boolean;  {* 20.2.97 *}

             UseMLoc   :  Boolean;  {* 27.2.97 *}

             {LastDate  :  String[8]; {* 28.7.98 *}
             AllowQtyDel : Boolean; {* 29.4.02 *}
             AllowTotWeight : Boolean; {* 30.4.02 *}
             AllowTotCost : Boolean; {* 30.4.02 *}
             NoTranToClosedJob : Boolean; {10/3/02}
             DiscountDec : Byte; //2/12/03

             //SQL fields 12/05/2008
              SQLCachingMode : Byte;
              SQLReloadCacheInterval : longint;

              //PR: 23/06/2009 Importer Fields for Advanced Discounts
              ImpUseVBD,
              ImpUseMBD  : Boolean;

              //PR: 15/10/2013 MRD 2.5.18
              AddressPostcodeMapping : Byte;

              //PR: 29/10/2013 ABSEXCH-14705
              DefaultUser : string;

              //PR: 16/01/2015
              DefaultCountryCode : string;

           end;

{$IFNDEF WIN32}

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

{$ENDIF}

VAR

   ExSyss        :  ExSysRec;

   RemDirNo      :  LongInt;

   OVExPathName  :  Str80;
   {RemDirNo      :   LongInt;}


{$IFNDEF WIN32}

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

   EntryRec      :   ^PassEntryType;

   Password      :   PasswordRec;
   PassFile      :   PassWord_FileDef;

   MiscRecs      :   MiscRecPtr;
   MiscFile      :   Misc_FilePtr;

   Syss          :   Sysrec;

   SyssVAT       :   ^VATRecT;
   SyssCurr      :   ^CurrRec;
   SyssDEF       :   ^DefRecT;
   SyssGCuR      :   ^GCurRec;
   SyssJob       :   ^JobSRecT;

   SyssEDI1      :   ^EDI1Type;
   SyssEDI2      :   ^EDI2Type;
   SyssEDI3      :   ^EDI3Type;

   SyssForms     :   ^FormDefsRecType;

   SyssMod       :   ^ModRelRecType;

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

{$ENDIF}


   {$IFNDEF WIN32}

     GlobalAllocRec:  ^GlobAllocAry;

     StkAllSet,
     StkOrdSet,
     StkExcSet    : Set of DocTypes;  { == Stock allocatable Documents == }

     DEFPrnSet     : Set of DocTypes;  { == Printable Documents == }

     CCVATName     :  ^Str80;

     DocStatus     :  ^DocStatusType;

   {$ENDIF}


Implementation

{$IFNDEF SET16}    { HM 08/10/97: Do not include for Toolkit Setup DLL }
uses
  VarFPosU, ApiUtil;
  {.$I VarCnst2.Pas}
{$ENDIF}
var
  RecSizeErrString : string;


procedure CheckRecSize(ThisSize, CorrectSize : Integer; Name : string);
begin
  if ThisSize <> CorrectSize then
    RecSizeErrString := RecSizeErrString + Format('The %s record structure should be %d bytes but is %d bytes'#10, [Name, CorrectSize, ThisSize]);
end;


Initialization
  RecSizeErrString := '';
  {$IFNDEF COMTK}
  {$IFNDEF SOPDLL}
  CheckRecSize(SizeOf(TBatchAutoBankRec), 276, 'TBatchAutoBankRec');
  CheckRecSize(SizeOf(TBatchBOMImportRec), 248, 'TBatchBOMImportRec');
  CheckRecSize(SizeOf(TBatchBOMLinesRec), 20000, 'TBatchBOMLinesRec');
  CheckRecSize(SizeOf(TBatchCCDepRec), 292, 'TBatchCCDepRec');
  CheckRecSize(SizeOf(TBatchCURec), 1564, 'TBatchCURec');
  CheckRecSize(SizeOf(TBatchCurrRec), 312, 'TBatchCurrRec');
  CheckRecSize(SizeOf(TBatchDiscRec), 280, 'TBatchDiscRec');
  CheckRecSize(SizeOf(TBatchEmplRec), 684, 'TBatchEmplRec');
  CheckRecSize(SizeOf(TBatchJHRec), 492, 'TBatchJHRec');
  CheckRecSize(SizeOf(TBatchJobAnalRec), 328, 'TBatchJobAnalRec');
  CheckRecSize(SizeOf(TBatchJobRateRec), 292, 'TBatchJobRateRec');
  CheckRecSize(SizeOf(TBatchLinesRec), 145160, 'TBatchLinesRec');
  CheckRecSize(SizeOf(TBatchMatchRec), 308, 'TBatchMatchRec');
  CheckRecSize(SizeOf(TBatchMLocRec), 696, 'TBatchMLocRec');
  CheckRecSize(SizeOf(TBatchNomRec), 368, 'TBatchNomRec');
  CheckRecSize(SizeOf(TBatchNotesRec), 376, 'TBatchNotesRec');
  CheckRecSize(SizeOf(TBatchSerialRec), 408, 'TBatchSerialRec');
  CheckRecSize(SizeOf(TBatchSKAltRec), 364, 'TBatchSKAltRec');
  CheckRecSize(SizeOf(TBatchSKRec), 1648, 'TBatchSKRec');
  CheckRecSize(SizeOf(TBatchSLRec), 828, 'TBatchSLRec');
  CheckRecSize(SizeOf(TBatchSRLinesRec), 54000, 'TBatchSRLinesRec');
  CheckRecSize(SizeOf(TBatchStkPriceRec), 316, 'TBatchStkPriceRec');
  CheckRecSize(SizeOf(TBatchSysRec), 1256, 'TBatchSysRec');
  CheckRecSize(SizeOf(TBatchTHRec), 1722, 'TBatchTHRec'); //PR: 28/10/2013 ABSEXCH-14705
  CheckRecSize(SizeOf(TBatchTLRec), 764, 'TBatchTLRec');
  CheckRecSize(SizeOf(TBatchVATRec), 300, 'TBatchVATRec');
  CheckRecSize(SizeOf(THistoryBalRec), 296, 'THistoryBalRec');
  CheckRecSize(SizeOf(TSaleBandAry), 288, 'TSaleBandAry');
  CheckRecSize(SizeOf(TSaleBandsRec), 36, 'TSaleBandsRec');
  CheckRecSize(SizeOf(TUserProfileType), 480, 'TUserProfileType');

  CheckRecSize(SizeOf(TBatchLinkRec), 516, 'TBatchLinkRec');
  CheckRecSize(SizeOf(TBatchBinRec), 768, 'TBatchBinRec');
  CheckRecSize(SizeOf(TBatchMultiBuyDiscount), 324, 'TBatchMultiBuyDiscount');

  if RecSizeErrString <> '' then
    msgBox(RecSizeErrString, mtError, [mbOK], mbOK, 'Record Size Error');
  {$ENDIF}
  {$ENDIF}
{$IFNDEF WIN32}
  StkAllSet    := [SOR];
  StkOrdSet    := [POR];
  StkExcSet    := [SQU,PQU];
{$ENDIF}

end.
