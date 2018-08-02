Unit VarConst;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

Interface

{$H-}

Uses
  Graphics, WinTypes, GlobVar, VARRec2U, BtrvU2, StrUtil, IniFiles, Forms, DLLInc;

const

{$I VerModu.Pas}

  IDX_DUMMY_CHAR = '!';
  PostMultiRunCtrl:  Boolean  =  BOn; {* Post One Run time Ctrl Line For Entire Posting Run *}
  NofChaseLtrs    =   3;            {* Max No of Chase Letters *}

{$I VARCOMNU.Pas}
{$I VARCMN3U.Pas}


Type
  tLocalPeriod       =  Record
                          CPr,CYr  :  Byte;
                          DispPrAsMonths
                                   :  Boolean;
                        end;

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
                 {024}  Access    :  Array[0..512] of Byte;
                 {528}  LastPno   :  Byte;         {  Last Printer Used  }
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
    MBACSCTL      =  'C';  {* Bacs Ctrl File *}
    BACSRCode     =  'B';  {* BACS Run Code *}


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
  {$IFDEF WCA}  { Windows Card System }
  LetterCardCode  =  'A';      { Cards }
  {$ENDIF}

  { =================================================== }



{$I VARRec.PAS}
{$I LayRec.PAS}

var

(*  global variables *)
   SyssCstm,
   SyssCstm2     :   ^CustomFRec;
   UserProfile   :   ^tPassDefType;

  bCommideaPlugInRunning : boolean;

(*  Ok,
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
  WOPOn,           { Global Variable to indicate WOP is available*}
  FullWOP,         { Global Variable to indicate Full WOP inc WIN is available*}
  STDWOP,          { Global Variable to indicate STD WOP is available*}
  EnSecurity,      { Global Variable to indicate enhanced security is available*}
  AnalCuStk      : Boolean;     { Global Variable to indicate cuanal Available *}*)

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
  InVATP,
  InCtrl,
  InCurr,
  InPopKy,
  InChangePr,
  InStock,
  InStockEnq,
//  FullStkSysOn,
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


   LayHead : TLayHeadRec;
   LayHeadFile : TLayHead_FileDef;

   LayLine : TLayLineRec;
   LayLineFile : TLayLine_FileDef;

   LaySerial : TLaySerialRec;
   LaySerialFile : TLaySerial_FileDef;

   LayBin : TLayBinRec;
   LayBinFile : TLayBin_FileDef;




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

Uses EPOSCnst,
     Dialogs,
     {$IFDEF OLE}
       Forms,
       ETStru,
     {$ENDIF}

     SysUtils,

     {$IFDEF JC}
       VarJCstU,
     {$ENDIF}

     SQLUtils,
     VARFposU
     , MultiBuyVar;


{$I VarCnst2.Pas}


procedure DefineLayawayHeader;
// Define Layaway Header File & Indexes
begin
  with LayHeadFile do begin
    FileSpecLen[LayHeadF]:=Sizeof(LayHeadFile);
    Fillchar(LayHeadFile,FileSpecLen[LayHeadF],0);
    RecLen:=Sizeof(LayHead);
    PageSize:=DefPageSize5;
    NumIndex:=lhNofKeys;
    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    {Key Definitions}

    {Index 0 - LayHeadFolioK : lhFolioNo + lhDummyChar}
    KeyBuff[1].KeyPos := BtKeyPos(@LayHead.lhFolioNo, @LayHead);
    KeyBuff[1].KeyLen := SizeOf(LayHead.lhFolioNo);
    KeyBuff[1].KeyFlags := ModSeg + ExtType;
    KeyBuff[1].ExtTypeVal := BInteger;
    KeyBuff[2].KeyPos := BtKeyPos(@LayHead.lhDummyChar, @LayHead);
    KeyBuff[2].KeyLen := 1;
    KeyBuff[2].KeyFlags := Modfy + AltColSeq;

    {Index 1 - LayHeadUserK : lhUserName + lhDate + lhTime}
    KeyBuff[3].KeyPos := BtKeyPos(@LayHead.lhUserName[1], @LayHead);
    KeyBuff[3].KeyLen := SizeOf(LayHead.lhUserName) - 1;
    KeyBuff[3].KeyFlags := ModSeg + AltColSeq;
    KeyBuff[4].KeyPos := BtKeyPos(@LayHead.lhDate[1], @LayHead);
    KeyBuff[4].KeyLen := SizeOf(LayHead.lhDate) - 1;
    KeyBuff[4].KeyFlags := ModSeg + AltColSeq;
    KeyBuff[5].KeyPos := BtKeyPos(@LayHead.lhTime[1], @LayHead);
    KeyBuff[5].KeyLen := SizeOf(LayHead.lhTime) - 1;
    KeyBuff[5].KeyFlags := Modfy + AltColSeq;

    {Index 2 - LayHeadDateK : lhDate + lhTime}
    KeyBuff[6].KeyPos := BtKeyPos(@LayHead.lhDate[1], @LayHead);
    KeyBuff[6].KeyLen := SizeOf(LayHead.lhDate) - 1;
    KeyBuff[6].KeyFlags := DupModSeg + AltColSeq;
    KeyBuff[7].KeyPos := BtKeyPos(@LayHead.lhTime[1], @LayHead);
    KeyBuff[7].KeyLen := SizeOf(LayHead.lhTime) - 1;
    KeyBuff[7].KeyFlags := DupMod + AltColSeq;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
  end; {With}

  FileRecLen[LayHeadF]:=Sizeof(LayHead);
{$IFDEF TRADESETUP}
  FileNames[LayHeadF] := 'TRADE\LHeader.DAT';
{$ELSE}
  FileNames[LayHeadF] := sCentralTradePath + 'LHeader.DAT';
{$ENDIF}
  FileNames[LayHeadF] := 'TRADE\LHeader.DAT';

  Fillchar(LayHead,FileRecLen[LayHeadF],0);
  RecPtr[LayHeadF] := @LayHead;
  FileSpecOfs[LayHeadF]:=@LayHeadFile;
end;

procedure DefineLayawayLines;
// Define Layaway Lines File & Indexes
begin
  with LayLineFile do begin
    FileSpecLen[LayLineF]:=Sizeof(LayLineFile);
    Fillchar(LayLineFile,FileSpecLen[LayLineF],0);
    RecLen:=Sizeof(LayLine);
    PageSize:=DefPageSize2;
    NumIndex:=llNofKeys;
    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    {Key Definitions}

    {Index 0 - LayLineK : llHeaderNo + llLineNo + llDummyChar}
    KeyBuff[1].KeyPos := BtKeyPos(@LayLine.llHeaderNo, @LayLine);
    KeyBuff[1].KeyLen := SizeOf(LayLine.llHeaderNo);
    KeyBuff[1].KeyFlags := ModSeg + ExtType;
    KeyBuff[1].ExtTypeVal := BInteger;
    KeyBuff[2].KeyPos := BtKeyPos(@LayLine.llLineNo, @LayLine);
    KeyBuff[2].KeyLen := SizeOf(LayLine.llLineNo);
    KeyBuff[2].KeyFlags := ModSeg + ExtType;
    KeyBuff[2].ExtTypeVal := BInteger;
    KeyBuff[3].KeyPos := BtKeyPos(@LayLine.llDummyChar, @LayLine);
    KeyBuff[3].KeyLen := 1;
    KeyBuff[3].KeyFlags := Modfy + AltColSeq;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
  end; {With}

  FileRecLen[LayLineF]:=Sizeof(LayLine);
{$IFDEF TRADESETUP}
  FileNames[LayLineF] := 'TRADE\LLines.DAT';
{$ELSE}
  FileNames[LayLineF] := sCentralTradePath + 'LLines.DAT';
{$ENDIF}
  FileNames[LayLineF] := 'TRADE\LLines.DAT';

  Fillchar(LayLine, FileRecLen[LayLineF],0);
  RecPtr[LayLineF] := @LayLine;
  FileSpecOfs[LayLineF]:=@LayLineFile;
end;

procedure DefineLayawaySerial;
// Define Layaway Lines File & Indexes
begin
  with LaySerialFile do begin
    FileSpecLen[LaySerialF]:=Sizeof(LaySerialFile);
    Fillchar(LaySerialFile,FileSpecLen[LaySerialF],0);
    RecLen:=Sizeof(LaySerial);
    PageSize:=DefPageSize2;
    NumIndex:=lsNofKeys;
    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    {Key Definitions}

    {Index 0 - lsFindSerialK : lsHeaderNo + lsLineNo + lsDummyChar}
    KeyBuff[1].KeyPos := BtKeyPos(@LaySerial.lsHeaderNo, @LaySerial);
    KeyBuff[1].KeyLen := SizeOf(LaySerial.lsHeaderNo);
    KeyBuff[1].KeyFlags := DupModSeg + ExtType;
    KeyBuff[1].ExtTypeVal := BInteger;
    KeyBuff[2].KeyPos := BtKeyPos(@LaySerial.lsLineNo, @LaySerial);
    KeyBuff[2].KeyLen := SizeOf(LaySerial.lsLineNo);
    KeyBuff[2].KeyFlags := DupModSeg + ExtType;
    KeyBuff[2].ExtTypeVal := BInteger;
    KeyBuff[3].KeyPos := BtKeyPos(@LaySerial.lsDummyChar, @LaySerial);
    KeyBuff[3].KeyLen := 1;
    KeyBuff[3].KeyFlags := DupMod + AltColSeq;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
  end; {With}

  FileRecLen[LaySerialF]:=Sizeof(LaySerial);
{$IFDEF TRADESETUP}
  FileNames[LaySerialF] := 'TRADE\LSerial.DAT';
{$ELSE}
  FileNames[LaySerialF] := sCentralTradePath + 'LSerial.DAT';
{$ENDIF}
  FileNames[LaySerialF] := 'TRADE\LSerial.DAT';

  Fillchar(LaySerial, FileRecLen[LaySerialF],0);
  RecPtr[LaySerialF] := @LaySerial;
  FileSpecOfs[LaySerialF]:=@LaySerialFile;
end;

procedure DefineLayawayBin;
// Define Layaway Lines File & Indexes
begin
  with LayBinFile do begin
    FileSpecLen[LayBinF]:=Sizeof(LayBinFile);
    Fillchar(LayBinFile,FileSpecLen[LayBinF],0);
    RecLen:=Sizeof(LayBin);
    PageSize:=DefPageSize2;
    NumIndex:=lsNofKeys;
    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    {Key Definitions}

    {Index 0 - lsFindBinK : lsHeaderNo + lsLineNo + lsDummyChar}
    KeyBuff[1].KeyPos := BtKeyPos(@LayBin.lbHeaderNo, @LayBin);
    KeyBuff[1].KeyLen := SizeOf(LayBin.lbHeaderNo);
    KeyBuff[1].KeyFlags := DupModSeg + ExtType;
    KeyBuff[1].ExtTypeVal := BInteger;
    KeyBuff[2].KeyPos := BtKeyPos(@LayBin.lbLineNo, @LayBin);
    KeyBuff[2].KeyLen := SizeOf(LayBin.lbLineNo);
    KeyBuff[2].KeyFlags := DupModSeg + ExtType;
    KeyBuff[2].ExtTypeVal := BInteger;
    KeyBuff[3].KeyPos := BtKeyPos(@LayBin.lbDummyChar, @LayBin);
    KeyBuff[3].KeyLen := 1;
    KeyBuff[3].KeyFlags := DupMod + AltColSeq;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
  end; {With}

  FileRecLen[LayBinF]:=Sizeof(LayBin);
{$IFDEF TRADESETUP}
  FileNames[LayBinF] := 'TRADE\LBin.DAT';
{$ELSE}
  FileNames[LayBinF] := sCentralTradePath + 'LBin.DAT';
{$ENDIF}
  FileNames[LayBinF] := 'TRADE\LBin.DAT';

  Fillchar(LayBin, FileRecLen[LayBinF],0);
  RecPtr[LayBinF] := @LayBin;
  FileSpecOfs[LayBinF]:=@LayBinFile;
end;

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


  {If (DeBug) then
    Ch:=ReadKey;}

  DefineRepScr;
  DefineSys;
End;

function GetLayawayDir : string;
begin
  Result := '';
  If FileExists (ExtractFilePath(Application.ExeName) + 'ENTWREPL.INI') Then begin
    With TIniFile.Create (ExtractFilePath (Application.ExeName) + 'ENTWREPL.INI') Do begin
      Try
        Result := UpperCase(IncludeTrailingBackslash(ReadString ('UpdateEngine', 'NetworkDir', '')));
      Finally
        Free;
      End;
    end;{with}
  end;{if}
end;


Initialization
//ShowMessage('TBatchTHRec : ' + IntToStr(SizeOf(TBatchTHRec)));

//  showmessage(IntToStr(SizeOf(TLayHeadRec)));
//  showmessage(IntToStr(SizeOf(TLayLineRec)));

  SBSIN := TRUE;
{ ******************************* Must Be Changed **************************}

//  TotFiles:=15  ;
//  TotFiles := 20; // 5 more for layaway
  TotFiles := 21; // 1 more for layaway bins

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
  eCommsModule:=Boff;
  AnalCuStk:=BOff;

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

  FillChar(StkEditNowList^, Sizeof(StkEditNowList^),0);

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

  New(UserProfile);
  FillChar(UserProfile^,Sizeof(UserProfile^),0);

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

  sCentralTradePath := GetLayawayDir;

  DefineLayawayHeader;
  DefineLayawayLines;
  DefineLayawaySerial;
  DefineLayawayBin;

  DefineMultiBuyDiscounts;

  {$IFDEF JC}
    Define_PVar;

  {$ENDIF}

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

  FullStkSysOn := TRUE;

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




  GetBtParam;

  AssignBOwner(ExBTOWNER);


Finalization
    Dispose(ExMainCoPath);
    Dispose(GlobalAllocRec);
    Dispose(SyssVAT);
    Dispose(SyssCurr);
    Dispose(SyssGCuR);
    Dispose(SyssCurr1P);
    Dispose(SyssGCuR1P);

    Dispose(SyssDEF);
    Dispose(SyssForms);
    Dispose(SyssJob);

    Dispose(SyssMod);
    Dispose(SyssEDI1);
    Dispose(SyssEDI2);
    Dispose(SyssEDI3);
    Dispose(SyssCstm);
    Dispose(SyssCstm2);

    Dispose(DocStatus);

    Dispose(CCVATName);

    Dispose(MiscRecs);
    Dispose(MiscFile);
    Dispose(RepScr);
    Dispose(RepFile);
    Dispose(CInv);
    Dispose(CId);
    Dispose(CStock);
    Dispose(EntryRec);
    Dispose(UserProfile);
    Dispose(ViewPr);
    Dispose(ViewYr);
    Dispose(AccelParam);
    Dispose(ExVersParam);
    Dispose(RepWrtName);
    Dispose(JBCostName);

    Dispose(DocEditNowList);
    Dispose(StkEditNowList);

    Dispose(JobMisc);
    Dispose(JobMiscFile);

    Dispose(JobRec);
    Dispose(JobRecFile);

    Dispose(JobCtrl);
    Dispose(JobCtrlFile);

    Dispose(JobDetl);
    Dispose(JobDetlFile);

    Dispose(CJobMisc);

    Dispose(CJobRec);
    Dispose(CJobDetl);

    {$IFDEF JC}
       Dispose(JobStatusL);
       Dispose(JobXDesc);
       Dispose(JobCHTDescL);
       Dispose(EmplTDescL);
    {$ENDIF}

    Dispose(MLocCtrl);
    Dispose(MLocFile);

end.
