Unit RepObjCU;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 05/09/94                      }
{                                                              }
{                 Rep Gen Object Control Unit II               }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses Windows,
     Classes,
     GlobalTypes,
     GlobVar,
     VarConst,
     SCRTCH1U,
     MCParser,
     RepObj2U,
     RepObj3U,
     RepFNO1U,
     RwOpenF,
     ReportO,
     CIS,
     {$IFDEF GUI}
     GuiVar,
     ThingU,
     {$ENDIF}
     RpDefine,
     DicLnk2U,
     SQLUtils,
     Contnrs;

Type


  PRepSettings = ^TRepSettings;
  TRepSettings = Record
    rsTestMode,
    rsRefreshFirst,
    rsRefreshLast : Boolean;
    rsSampleCount,
    rsFirstPos,
    rsLastPos : longint;
  end;

  TPeriodDetailObject = Class
    Details : DictLinkType;
  end;

  TVRWField = Class
    OffSet : Integer;
    WantToPrint : Boolean;
    DrillDownRec : TDrillDownRec;
    FieldNo : Integer; //PR: 10/11/2015 ABSEXCH-15491 Include Field Number
  end;

  TRecordPosition = Class
  private
    FPosition : Int64;
    FFields : TObjectList;
    FWantPrint: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddField(var aFile : TFileStream; const Value : ShortString; bPrint : Boolean;
                       iFileNo : Byte; iVarNo : Integer; CalcField : Boolean);
    //PR: 10/11/2015 ABSEXCH-15491 Extended parameters to include list index
    function FieldValueList(var aFile : TFileStream; ListIndex : Integer) : TStringList;
    property Position : Int64 read FPosition write FPosition;
    property WantPrint : Boolean read FWantPrint write FWantPrint;
  end;


  RepCtrlPtr  =  ^RepCtrlObj;

  RepCtrlObj  =  Object(TGenReport)
                   Procedure RepPrintHeader(Sender  :  TObject); Virtual;
                 Public
                   TmpList : TStringList;
                   ThisRepNo  : SmallInt;       { Scratch file number for report }

                   FilesOk    : Boolean;

                   LineCount,
                   SampleNo   :  LongInt;
                   {Ln,Page    :  Integer;}

                   LineCtrl   :  RepLinePtr;

                   HedCtrl    :  RepLHedPtr;

                   ThisScrt   :  ScratchPtr;

                   FastObj    :  FastNDXOPtr;


                   Fnum,
                   Keypath    :  Integer;

                   {KeyS,}
                   KeyChk,
                   POnStr,
                   POffStr    :  Str255;

                   NewPage,
                   CDFOn,
                   DBFOn,
                   KeepRep,
                   TestMode   :  Boolean;

                   DBFCmdLine : string;

                   ExportF    :  Text;

                   RepCtrlRec :  ^ReportHedType;
                   RepGen     :  ^RepGenRec;

                   LastBreakList   :  Array[0..9] of LongInt;
                   LastTBreakFound : integer;

                   TheThing : TThing;
                   FGetLineField : TGetFieldEvent;
                   FSettings : PRepSettings;
                   InpStart, InpEnd : Str255;
                   {Constructor Create(AOwner : TObject;RepCRec  :  ReportHedType);}
                   {$IFDEF GUI}
                   OnSelectRecord : TOnSelectRecordProc;
                   OnCheckRecord  : TOnCheckRecordProc;

                   //PR: 10/11/2015 ABSEXCH-15491 Function to heck SQL records for line count in selection
                   CheckRecordSQL : TCheckRecordSQLFunc;
                   FirstPass : Boolean;
                   FPeriodList : TStringList;
                   NoOfRecsFound : longint;
                   FSQLList : TStringList;
                   FSQLIndex : Integer;
                   FTempFile : TFileStream;
                   GetDBField : TGetDBFEvent;
                   Constructor Create(AOwner : TObject;RepCRec : RepGenRec;
                                      FieldProc : TGetFieldEvent; InputProc : TGetInputEvent;
                                      FieldNameProc : TFieldFromNameProc;
                                      FieldNotify : TFieldProc;
                                      FieldValNotify : TFieldValueByNumberProc;
                                      Settings : PRepSettings);
                   {$ELSE}
                   Constructor Create(AOwner : TObject;RepCRec : RepGenRec);
                   {$ENDIF}
                   {Constructor Init(RepCRec  :  ReportHedType);}

                   {Destructor Done;}
                   Destructor Destroy; virtual;

                   Procedure ResetVar;
                   {$IFDEF GUI}
                   procedure DoSelectRecord;
                   procedure DoSelectRecordSQL;
                   procedure AddRecToTempList(sKey : string);
                   function GetFirst : Boolean;
                   function GetNext  : Boolean;
                   function GetPrevious  : Boolean;
                   function CopyDataToGuiField : Boolean;
                   {$ENDIF}

                   Procedure Open_Def(DFnam  :  Str255;
                                  Var IOFlg  :  Boolean);

                   Procedure Close_Def;

                   Procedure ExportCDF(DFnam  :  AnsiString);

                   Procedure RepPrintLn(Line2Print  :  Str255);

                   Procedure RepPage;

                   Procedure RepEnd;

                   Procedure SelectRecords(Var NoFound  :  LongInt);

                   Procedure Process_Breaks(LastOne  :  Boolean);

                   Procedure Process_File; Virtual;

                   Procedure Process_Report; Virtual;

                   procedure SetDbfCmdLine;
                   procedure ExpandDbfCmdLine;

                   Function  GetReportInput : Boolean; Virtual;
                   Procedure RepSetTabs; Virtual;
                   Procedure RepPrintPageHeader; Virtual;
                   Procedure Process; Virtual;
                   Procedure RepPrint(Sender  :  TObject); Virtual;
                   Procedure RepSetHeadingTabs; Virtual;
                   Procedure PrintColText (Const ColText : ColTextPtrType);
                   Procedure PrintColUndies (Const ColUndies : ColUndiesType);
                   Function  Start : Boolean; Virtual;
                   Procedure BuildTempData(Var NoFound : LongInt); Virtual;
                   Procedure Warn_ValErr(RVNo : Str10; ValLine : ShortString);
                   function  PeriodDetails(const DBFCode : string) : DictLinkType;
                   procedure LoadPeriods;

                 End; {Object..}


  function AddDrillDownInfo(const DataDictField   : LongInt;
                            const DriveFile       : SmallInt;
                              var LevelNo, Mode   : Byte;
                              var KeyString       : ShortString;
                              var FileNo, IndexNo : SmallInt) : Boolean;



 Var
   TmpColText : ColTextPtrType;



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Dialogs,
   Forms,
   Graphics,
   SysUtils,
   ETStrU,
   ETMiscU,
   ETDateU,
   VarFPosU,

   BtrvU2,
   BtSupU1,
   BtKeys1U,

   RpDevice,
   RpMemo,

   ExBtTh1U,

{$IFDEF DBF}
   DbfInt,
{$ENDIF}

DDFuncs,

   DicLinkU,
   PrntDlg2,
   RpCommon,
   CurrncyU,
   ComnU2,
   RwFuncs,
   ApiUtil,
   VarRec2U,
   ExThrd2U,
   OrderPaymentsVar;


 Var
   CommandPool : TBits;




function CreateTempFileName : string;
var
  TempPath,
  FName : PChar;
  Res : longint;
begin
  FName := StrAlloc(MAX_PATH + 1);
  TempPath := StrAlloc(MAX_PATH + 1);
  GetTempPath(MAX_PATH + 1, TempPath);
  Try
    Res := GetTempFileName(TempPath, 'VRW', 0, FName);
    Result := StrPas(FName);
  Finally
    StrDispose(FName);
    StrDispose(TempPath);
  End;
end;





function AddDrillDownInfo(const DataDictField   : LongInt;
                          const DriveFile       : SmallInt;
                            var LevelNo, Mode   : Byte;
                            var KeyString       : ShortString;
                            var FileNo, IndexNo : SmallInt) : Boolean;

  procedure DoNominal(Want : Boolean; KeyNo : longint);
  begin
   if Want then
   begin
    FileNo := NomF;
    IndexNo := NomCodeK;
    KeyString := FullNomKey(KeyNo);
   end;
  end;

  procedure DoJob(Want : Boolean; const KeyS : ShortString);
  begin
   if Want then
   begin
    FileNo := JobF;
    IndexNo := JobCodeK;
    KeyString := KeyS;
   end;
  end;

  procedure DoCust(Want : Boolean; const KeyS : ShortString);
  begin
   if Want then
   begin
    FileNo := CustF;
    IndexNo := CustCodeK;
    KeyString := KeyS;
   end;
  end;

  procedure DoCC(Want : Boolean; const KeyS : ShortString);
  begin
   if Want then
   begin
    FileNo := PWrdF;
    IndexNo := PWK;
                                                    // Cost centre code
    KeyString := Password.RecPfix + Password.SubType + KeyS;
   end;
  end;

  procedure DoLocation(Want : Boolean; const KeyS : ShortString);
  begin
   if Want then
   begin
    FileNo := MLocF;
    IndexNo := MLK;
    KeyString := MlocCtrl^.RecPfix + MLocCtrl^.SubType + KeyS;
   end;
  end;

  procedure DoStock(Want : Boolean; const KeyS : ShortString);
  begin
   if Want then
   begin
    FileNo := StockF;
    IndexNo := StkCodeK;
    KeyString := KeyS;
   end;
  end;


  procedure CheckRelatedFields;
  begin
    Case DataDictField of
      //ACNOM
      1030  : DoNominal(DriveFile in [1,2], Cust.DefNomCode);
      //THACC
      2002  : DoCust(DriveFile <> 3, Inv.CustCode);
      //THCTRLGL
      2028  : DoNominal(DriveFile <> 3, Inv.CtrlNom);
      //THJOBCODE
      2306  : DoJob(DriveFile <> 3, Inv.DJobCode);
      //TLACC
      3003  : DoCust(DriveFile <> 4, Id.CustCode);
      //TLCCCODE, DESC
      3088..3091
            : DoCC(DriveFile <> 4, Id.CCDep[DataDictField - 3000 in [88, 90]]);
      //TLJOBCODE
      3106  : DoJob(DriveFile <> 4, Id.JobCode);
      //TLLocation, etc
      3130..3137,
      3062  : DoLocation(DriveFile <> 4, Id.MLocStk);
      //TLNOMCOD
      3087  : DoNominal(DriveFile <> 4, Id.NomCode);
      //TLSTKCOD
      3022  : DoStock(DriveFile <> 4, Id.StockCode);
      //STCC
      5107..5110
            : DoCC(DriveFile <> 6, Stock.CCDep[DataDictField - 5000 in [107, 109]]);
      //STDEFLOC
      5078  : DoLocation(DriveFile <> 6, Stock.DefMLoc);
      //ST GL Codes
      5120..5124
            : DoNominal(DriveFile <> 6, Stock.NomCodeS[DataDictField - 5119]);

      //PR: 28/07/2015 ABSEXCH-16460 Add order payment fields for drill down
      27001..27003
            : begin
                FileNo    := InvF;
                IndexNo   := InvOurRefK;
                Case DataDictField - 27000 of
                  1 : KeyString := FullOurRefKey(OrderPaymentVatRec.vpOrderRef);
                  2 : KeyString := FullOurRefKey(OrderPaymentVatRec.vpReceiptRef);
                  3 : KeyString := FullOurRefKey(OrderPaymentVatRec.vpTransRef);
                end;
              end;

    end;//Case
   end;



begin
  Mode := 0;
  LevelNo := 1;
  FileNo := 0;
  IndexNo := 0;
  KeyString := '';

        Case DataDictField of

          1000..1999  :  Begin // customer suppliers
                           FileNo := CustF;
                           IndexNo := CustCodeK;
                           KeyString := Cust.CustCode;
                         end;

          2000..2999  :  Begin // transaction headers
                           FileNo := InvF;
                           IndexNo := InvOurRefK;
                           KeyString := Inv.OurRef;
                         end;

          3000..3999  :  Begin // transaction Lines
                           FileNo := InvF;
                           IndexNo := InvFolioK;
                           KeyString := FullNomKey(Id.FolioRef);
                         end;

          4000..4999  :  Begin {* Nom Variables *}
                           FileNo := NomF;
                           IndexNo := NomCodeK;
                           KeyString := FullNomKey(Nom.NomCode);
                         end;

          5000..5999  :  Begin {* Stock Variables *}
                           FileNo := StockF;
                           IndexNo := StkCodeK;
                           KeyString := Stock.StockCode;
                         end;

          6000..6999  :  Begin {* CC/Dep Variables *}
                           FileNo := PWrdF;
                           IndexNo := PWK;
                                                                            // Cost centre code
                           KeyString := Password.RecPfix + Password.SubType + Password.CostCtrRec.PCostC;
                         end;

//          7000..7999  :  Begin {* Serial No. Variables *}
//                         end;

//          8000..8099  : Begin // Notes
//                        End;

          8100..8999  : Begin { Locations }
                           FileNo := MLocF;
                           IndexNo := MLK;
                           KeyString := MlocCtrl^.RecPfix + MLocCtrl^.SubType + MLocCtrl^.MLocLoc.loCode;
                        End;

//          9000..9999  : Begin // Combined Job Costing
//                        End;

//          10000..10499 : Begin { Job Analysis Codes }
//                           FileNo :=
//                           IndexNo :=
//                           KeyString :=
//                         End;

//          10500..10999 : Begin { Job Types }
//                         End;

//          11000..11499 : Begin { Rates Of Pay }
//                         End;

          11500..11999 : Begin { Employees }
                           FileNo := JMiscF;
                           IndexNo := JMK;
                           KeyString := JobMisc^.RecPfix + JobMisc^.SubType + JobMisc^.EmplRec.EmpCode;
                         End;

          12000..12999 : Begin { Job Records }
                           FileNo := JobF;
                           IndexNo := JobCodeK;
                           KeyString := JobRec.JobCode;
                         End;

//          13000..13999 : Begin { Job Actuals }
//                         End;
            13000      : Begin { Job Actuals }
                           FileNo := JobF;
                           IndexNo := JobCodeK;
                           KeyString := JobDetl.JobActual.JobCode;
                         End;
            13001      : Begin
                           FileNo := InvF;
                           IndexNo := InvOurRefK;
                           KeyString := JobDetl.JobActual.LineORef;
                         end;
            13002      : begin
                           FileNo := StockF;
                           IndexNo := StkCodeK;
                           KeyString := JobDetl.JobActual.StockCode;
                         end;
            13012      : begin
                           FileNo := JMiscF;
                           IndexNo := JMK;
                           KeyString := JARCode + JAECode + JobDetl.JobActual.EmplCode;
                         end;
            13015      : Begin { Job Records }
                           FileNo := InvF;
                           IndexNo := InvOurRefK;
                           KeyString := JobDetl.JobActual.InvRef;
                         End;


//          14000..14999 : Begin { Job Retentions }
//                         End;

//          15000..15999 : Begin { Job Budgets }
//                         End;
//          17000..17999 : Begin { Stock/Locations }
//                         End;
//          18000..18999 : Begin { Matched Payments }
//                         End;
//          19000..19499 : Begin { Bill Of Materials }
//                         End;
//          19500..19999 : Begin { FIFO }
//                         End;
//          20000..20499 : Begin { Discounts }
//                         End;
//          21000..21499 : Begin { User Profile }
//                         End;
//          21500..21999 : Begin // Multi-Bins
//                         End;
//          22000..22999 : Begin { Job Costing CIS Vouchers }
//                         End;
        end; {Case..}
   CheckRelatedFields;
   Result := FileNo <> 0;

end;

//==================================================================================================================================
//PR: 18/01/2010 Added functions to return the various Prefixes for any variant files where VRW is dealing with more than one variant
//in a single report
//PR: 12/02/2010 Added extra files/prefixes to comply with CS's redirect functions
//TODO: Add any remaining prefixes to improve performance
const
  //Report writer file numbers
  fnDiscounts      = 14;
  fnTransNotes     = 32;
  fnMatchPay       = 28;
  fnFIFO           = 20;
  fnJobBudgets     = 25;
  fnSerialBatch    = 16;
  fnLocations      = 26;
  fnStockLocations = 27;
  fnTimeRates      = 19;


  sPrefixes  : Array[1..NoDataF] of String[2] = ('C', 'S', '', '', '', '',                //1-6
                                                 'CC', 'CD', '', '', '', '',              //7-12
                                                 '', '', '', 'FR', '', '',                  //13-18
                                                 '', 'FS', '', '', '', '',                //19-24
                                                 '', 'CC', 'CD', 'TP', '', '',              //25-30
                                                 '', 'ND', '', '', '', '',                //31-36
                                                 '', '', '');                             //37-39

  //PR: 16/11/2012 ABSEXCH-13615 Remove QtyBreak prefixes from sDiscounts, so that they no longer appear in reports.
//  sDiscounts     = 'CC,CS,DC,DQ,DS';
  sDiscounts     = 'CC,CS';
  sJobBudgets    = 'JB,JM,JS';
  sTimeRates     = 'JE,JR';

  FilesToCheck = [fnDiscounts, fnFIFO, fnJobBudgets, fnMatchPay, fnTransNotes, fnTimeRates];

var
  CurrentPrefix : Str255;

function FirstKeyS(iFileNo : Integer) : Str255;
var
  i : Integer;
begin
  Assert((iFileNo > 0) and (iFileNo <= NoDataF), 'File Number out of range ' + IntToStr(iFileNo));
  Result := '';
  Case iFileNo of //first deal with files with more than one prefix
    fnDiscounts  :  Result := Copy(sDiscounts, 1, 2);
    fnJobBudgets :  Result := Copy(sJobBudgets, 1, 2);
    fnTimeRates  :  Result := Copy(sTimeRates, 1, 2);
    else //otherwise, one prefix only
      Result := sPrefixes[iFileNo];
  end; //Case
  CurrentPrefix := Result;
end;


function NextKeyS(iFileNo : Integer; const sKey : Str255) : Str255;
var
  i : Integer;
  sFilePrefixes : string;

  procedure GetNextPrefix;
  begin
    i := Pos(Copy(sKey, 1, 2) + ',', sFilePrefixes);
    if (i > 0) and (i < Length(sFilePrefixes) - 2) then
      Result := Copy(sFilePrefixes, i + 3, 2);
  end;

begin
  Result := '';
  Case iFileNo of
    fnDiscounts   :  begin
                       sFilePrefixes := sDiscounts;
                       GetNextPrefix;
                     end;
    fnJobBudgets  :  begin
                       sFilePrefixes := sJobBudgets;
                       GetNextPrefix;
                     end;
    fnTimeRates   :  begin
                       sFilePrefixes := sTimeRates;
                       GetNextPrefix;
                     end;
  end; //Case
  CurrentPrefix := Result;
end;

//This is the function which replaces 'Status = 0' - it checks Status but also, if necessary, checks the returned prefix
//and moves on to the next prefix if required.
function CheckStatus(iFileNo, iRealFile, iKeyPath : Integer; var KeyS : Str255; var iStatus : Integer) : Boolean;
var
  Res : Integer;
begin
  if (iFileNo in FilesToCheck) and ((iStatus = 9) or (Copy(KeyS, 1, 2) <> CurrentPrefix)) then
  begin
    repeat
      //Get next prefix and set CurrentPrefix to the result - if no more prefixes then returns ''
      KeyS := NextKeyS(iFileNo, CurrentPrefix);
      if KeyS <> '' then
        //Find first record for this prefix
        iStatus := Find_Rec(B_GetGEq,F[iRealFile],iRealFile,RecPtr[iRealFile]^,iKeyPath,KeyS)
      else
        iStatus := 9; //Gone through all the Prefixes we want
    until (iStatus <> 0) or (Copy(KeyS, 1, 2) = CurrentPrefix);
  end; //If iFileNo
  Result := iStatus = 0;
end;
//==================================================================================================================================


 { ======== Function to Check master inclusion ====== }

 Function File_Include(Fnum  :  Integer)  :  Boolean;

 Var
   TmpBo   : Boolean;
   KeyS    : Str255;
   LStatus : Integer;
 Begin

   TmpBo:=BOff;

   Case Fnum of

     1,2  :  TmpBo:=(Cust.CustSupp=TradeCode[(Fnum=1)]);

     {*431RW  HM 03/04/00: Added Discount Matrix }
     14   :  With MiscRecs^ Do Begin
                        { Customer/Supplier Discounts }
               TmpBo := ((RecMFix = CDDiscCode) And (SubType In [TradeCode[BOff], TradeCode[BOn]])) Or
                        { Customer/Supplier/Stock Quantity Breaks }
                        ((RecMFix = QBDiscCode) And (SubType In [TradeCode[BOff], TradeCode[BOn], QBDiscSub]));
             End; { If }

     { Job Costing - Rates Of Pay (Employee & Global) }
     19   :  With JobCtrl^ Do
               TmpBo:=(RecPfix = JBRCode) And (SubType In [JBECode, JBPCode]);

     { Job Costing - Budgets }
     25   :  With JobCtrl^ Do
               TmpBo:=(RecPfix = JBRCode) And (SubType In [JBBCode, JBMCode, JBSCode]);

     {*431RW HM 03/04/00: Customer and Supplier Notes }

     //PR: 07/11/2011 v6.9 Added check to avoid AuditNotes being returned.
     15, 29, 30, 31, 32
          :  begin
               TmpBo := Password.NotesRec.NType in ['1', '2'];

               //Original check to ensure correct account type
               if FNum in [29, 30] then
               With Password, NotesRec Do
               Begin
                 TmpBo := TmpBo and (RecPfix = NoteTCode) And (SubType = NoteCCode);

                 If TmpBo Then Begin
                   { Get Account Record and check type }
                   KeyS := NoteFolio;
                   LStatus:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyS);
                   If (LStatus = 0) And CheckKey(NoteFolio, KeyS, Length(NoteFolio), BOn) Then
                     TmpBo := (Cust.CustSupp = TradeCode[FNum = 29])
                   Else
                     TmpBo := False;
                 End; { If TmpBo}
               End; { With }
             end; //Notes

     else    TmpBo:=BOn;

   end; {Case..}


   File_Include:=TmpBo;

 end; {Func..}



 { ======= Function to Set up initial Check key ======= }


 Function File_CheckKey(Fnum  :  Integer)  :  Str255;

 Var
   KeyS   :  Str255;

 Begin

   Blank(KeyS,Sizeof(KeyS));

   Case Fnum of

     7,8  :  KeyS:=PartCCKey(CostCCode,CSubCode[(Fnum=7)]);

     {*431RW  HM 29/03/00: Added Bill Of Materials }
     10   :  KeyS:=PartCCKey(BillMatTCode, BillMatSCode);

     13   :  KeyS:=PartCCKey(PassUCode,C0);

     {*431RW  HM 29/03/00: Added Job Notes }
     15   :  KeyS:=PartCCKey(NoteTCode, NoteJCode);

     16   :  KeyS:=PartCCKey(MFIFOCode,MSernSub);

     { Job Costing - Analysis Codes }
     17   :  KeyS:=PartCCKey(JARCode, JAACode);

     { Job Costing - Job Types }
     18   :  KeyS:=PartCCKey(JARCode, JATCode);

     {*431RW HM 29/03/00: Added FIFO }
     20   :  KeyS:=PartCCKey(MFIFOCode, MFIFOSub);

     { Job Costing - Employees }
     21   :  KeyS:=PartCCKey(JARCode, JAECode);

     { Job Costing - Actuals }
     23   :  KeyS:=PartCCKey(JBRCode, JBECode);

     { Job Costing - Retentions }
     24   :  KeyS:=PartCCKey(JBRCode, JBPCode);

     { Locations }
     26   :  KeyS:=PartCCKey(CostCCode, CSubCode[True]);

     { Stock Locations }
     27   :  KeyS:=PartCCKey(CostCCode, CSubCode[False]);

     { HM 25/01/99: Matched Payments added }
     28   :  KeyS:=PartCCKey('T', 'P');

     {*431RW HM 03/04/00: Customer and Supplier Notes }
     29,
     30   :  KeyS:=PartCCKey(NoteTCode, NoteCCode);

     {*431RW HM 03/04/00: Stock Notes }
     31   :  KeyS:=PartCCKey(NoteTCode, NoteSCode);

     {*431RW HM 12/04/00: Transaction Notes }
     32   :  KeyS:=PartCCKey(NoteTCode, NoteDCode);

     //PR: 20/01/03 CIS Vouchers
     33   :  KeyS := PartCCKey(JATCode, JBSCode);

     //PR: 08/09/03 Multi-bins
     34   :  KeyS := PartCCKey(BRRecCode, MSernSub);

     //PR: 12/03/2009 Alt Stock Codes
     35   :  KeyS := NoteTCode; //AltStockCodes are N1, N2, N3, NA
   end; {Case..}

   File_CheckKey:=KeyS;

 end; {Func..}




  { ======= Procedure to Set up initial Btrv Functions key ======= }


 Procedure File_BtrvDrv(    Fnum    :  Integer;
                        Var BFunc1,
                            BFunc2  :  Integer);


 Begin

   Case Fnum of

     7,   8,
     16, 17,
     18, 21,
     23, 24, 25,
     26, 27,

     { HM 04/01/99: Matched Payments added }
     28,

     {*431RW HM 29/03/00: Added new files }
     10, 15,
     20, 29,
     30, 31,
     32
     //PR: 20/01/03 new file for CIS Vouchers
     ,33
     //PR: 08/09/03 Multibins
     ,34, 35 //PR: 12/03/2009 35 for Alt Stock Codes
{     36 //PR: 10/06/2009 36 for Multi-Buy Discounts}
          :  Begin
               BFunc1:=B_GetGEq;
               BFunc2:=B_GetNext;
             end;
     else    Begin
               BFunc1:=B_StepFirst;
               BFunc2:=B_StepNext;
             end;

   end; {Case..}

 end; {Proc..}



{ ======= Procedure to Reset contents of all data files ===== }

  Procedure Reset_DataRecs;

  Var
    n  :  Byte;

  Begin

    For n:=1 to TotFiles do
      If (n<>SysF) then
        ResetRec(n);

  end; {Proc..}






   { ---------------------------------------------------------------- }

   {  RepCtrl Methods }

   { ---------------------------------------------------------------- }


  {$IFDEF GUI}
  Constructor RepCtrlObj.Create(AOwner : TObject;RepCRec : RepGenRec;
                                FieldProc : TGetFieldEvent;
                                InputProc : TGetInputEvent;
                                FieldNameProc : TFieldFromNameProc;
                                FieldNotify : TFieldProc;
                                FieldValNotify : TFieldValueByNumberProc;
                                Settings  : PRepSettings);
  {$ELSE}
  Constructor RepCtrlObj.Create(AOwner : TObject;RepCRec : RepGenRec);
  {$ENDIF}
  {Constructor RepCtrlObj.Init(RepCRec  :  ReportHedType);}
  var
    Res : Integer;
    DelFile : string;

  Begin
    Inherited Create(AOwner);

    TheThing := TThing.Create;
    FSQLList := TStringList.Create;
    FSQLList.Sorted := True;
    FSQLList.Duplicates := dupAccept;
    FSQLList.CaseSensitive := True;
    FTempFile := TFileStream.Create(CreateTempFilename, fmOpenReadWrite or fmShareDenyNone);

    ThisRepNo := -1;

    InpStart := '';
    InpEnd := '';

    { Create thread files }
    FilesOk := False;
    If Not Assigned(RepExLocal) then { Open up files here }
      FilesOk:=Create_VRWReportFiles
    Else
      FilesOk := True;

    If FilesOk then
      MTExLocal:=RepExLocal;

    { Stop it drawing the line under the titles - cos it gets it in the wrong place }
    RNoPageLine:=Bon;

    New(RepCtrlRec);
    RepCtrlRec^:=RepCRec.ReportHed;

    New(RepGen);
    RepGen^:=RepCRec;



    New(LineCtrl,Init(RepCtrlRec^.RepName, MtExLocal));
    LineCtrl^.OnValErr := Warn_ValErr;
    LineCtrl^.GetDBFEvent := TheThing.GetDBFEvent;
    LineCtrl^.GetFMLEvent := TheThing.GetFMLEvent;
    LineCtrl^.GetFmtDateEvent := TheThing.FormatDate;
    LineCtrl^.SetPeriodDetails := TheThing.SetPeriodDetails;
    LineCtrl^.GetFieldFromName := FieldNameProc;
    LineCtrl^.NotifyField := FieldNotify;
    LineCtrl^.NotifyFieldValue := FieldValNotify;
    TheThing.GetPeriod := PeriodDetails;



    {$IFDEF GUI}
    LineCtrl^.FirstPass := {FirstPass} True;
    {$ENDIF}
    TheThing.LinePtr := LineCtrl;

    New(HedCtrl,Init(RepCtrlRec^.RepName));


    (* Moved to ?
    If (RepCtrlRec^.RepType<>RepNomCode) then
      New(ThisScrt,Init(9000, MtExLocal));

    *)
    {$IFDEF GUI}
    //PR: 18/03/2011 Even though the Scratch file is no longer used for SQL, it was still being created.
    If not SQLUtils.UsingSQL and (RepCtrlRec^.RepType<>RepNomCode) then
    begin
      //PR 2/3/05 Close and delete scratchfile to avoid btrieve 22 errors
      Res:=Close_File(F[ReportF]);

      If (Res = 0) then
      Begin

        {$I-}

        DelFile := SetDrive+FileNames[ReportF];

        if FileExists(DelFile) then
          DeleteFile(DelFile);

        FileNames[ReportF] := '';
        {$I+}

      end;

      FillChar(RecPtr[ReportF]^, FileRecLen[ReportF], 0);
      New(ThisScrt,Init(9000));
    end;
    {$ELSE}
    ThisScrt := Nil;
    {$ENDIF}

    Fnum:=FileTxlate(RepCtrlRec^.DriveFile,Keypath);
    TheThing.DrivingFile := FNum;

    LineCtrl.RepDrive := Fnum;
    LineCtrl.OrigFile := RepCtrlRec^.DriveFile;
    HedCtrl.RepDrive  := Fnum;
    HedCtrl.OrigFile := RepCtrlRec^.DriveFile;

    ResetVar;

{    TestMode:=RepCtrlRec^.TestMode;

    SampleNo:=RepCtrlRec^.SampleNo;}

    if Assigned(Settings) then
    begin
      TestMode := Settings.rsTestMode;
      SampleNo := Settings.rsSampleCount;
      FSettings := Settings;
    end;



    LineCtrl^.RunNomCtrl:=(RepCtrlRec^.RepType=RepNomCode);

    {$IFDEF GUI}
    TmpList := TStringList.Create;
    TmpList.Sorted := False;
    LineCtrl^.GetLineField := FieldProc;
    LineCtrl^.GetInput := InputProc;
    FGetLineField := FieldProc;
    {$ENDIF}

    LineCtrl^.InitRepFObj(RepGenF,RGK, MtExLocal);

    HedCtrl^.InitHedFObj(RepGenF,RGK, MtExLocal);

{$IFDEF DBF}
//RepCtrlRec^.RepDest := 3;
{$ENDIF}

    CDFOn:=(RepCtrlRec^.RepDest=2);
    DBFOn := RepCtrlRec^.RepDest=3;
    SetDbfCmdLine;

    {If (CDFOn) then
      Open_Def(RepCRec.LastPath,CDFOn);}

    POnStr:='';
    POffStr:='';

    FPeriodList := TStringList.Create;

    InitLastEmployment;
  end; {Constructor..}


  {* ------------------------ *}


  Destructor RepCtrlObj.Destroy; {Done;}
  var
    i, j : integer;
    AList : TStringList;
  Begin
    Dispose(LineCtrl,Done);

    for i := 0 to FPeriodList.Count - 1 do
      FPeriodList.Objects[i].Free;

    FPeriodList.Free;

    Dispose(HedCtrl,Done);

    { get rid of scratch file }
    //PR: 18/03/2011 Even though the Scratch file is no longer used for SQL, it was still being created.
    If not SQLUtils.UsingSQL and (RepCtrlRec^.RepType<>RepNomCode) and Assigned(ThisScrt) then
      Dispose(ThisScrt,Done);
    If (ThisRepNo > -1) Then
      CommandPool[ThisRepNo] := False;

    Dispose(RepGen);
    Dispose(RepCtrlRec);

    If (CDFOn) then
      Close_Def;

    if DBFOn then
      if Trim(DbfCmdLine) <> '' then
      begin
        ExpandDbfCmdLine;
        RunApp(DbfCmdLine, False);
      end;

    {$IFDEF GUI}
      TmpList.Free;
      if Assigned(FSQLList) then
      begin
        for i := 0 to FSQLList.Count - 1 do
        begin
          if Assigned(FSQLList.Objects[i]) then
            FSQLList.Objects[i].Free;
        end;
        FSQLList.Free;
      end;

      if Assigned(FTempFile) then
        FTempFile.Free;
    {$ENDIF}

    Inherited Destroy;

    {PR 6/02/2008 RepExLocal was being destroyed in finalization which was causing problems in SQL
    as BtrvSQL.Dll may already have been unloaded at that point}
    Dispose(RepExLocal, Destroy);
    RepExLocal := nil;
  end; {Destructor..}


  {* ------------------------ *}


  Procedure RepCtrlObj.ResetVar;

  Begin

    If (LineCount>0) then
    Begin
      LineCtrl^.LineTotals(1,255);  {* Reset all sub totals & Break Status *}

      LineCtrl^.FirstGo:=BOn;
    end;

    {Ln:=0;

    Page:=1;}

    RepRunCount:=1;

    LineCount:=0;

    KeyS:='';

    KeyChk:='';

    NewPage:=BOn;

    KeepRep:=BOn;


  end;

  {* ------------------------ *}



  { ============ Open/Close Files ============ }

  Procedure RepCtrlObj.Open_Def(DFnam  :  Str255;
                            Var IOFlg  :  Boolean);

  Var
    TmpIO  :  Integer;

  Begin
    {$I-}
    TmpIO:=0;

    Assign(ExportF,DFnam);

    ReWrite(ExportF);

    TmpIO:=IOResult;

    Report_IOError(TmpIO,DFnam);

    IOFlg:=(TmpIO=0);

    {$I+}

  end;



  Procedure RepCtrlObj.Close_Def;

  Begin
    {$I-}

    Close(ExportF);

    {$I+}

    If (IOResult<>0) then ;
  end;




  { ============ Export Line ============ }

  Procedure RepCtrlObj.ExportCDF(DFnam  :  AnsiString);

  Var
    TmpIO  :  Integer;

  Begin
    {$I-}

    Writeln(ExportF,DFnam);

    TmpIO:=IOResult;

    Report_IOError(TmpIO,DFnam);

    PrntOk:=(TmpIO=0);

    {$I+}

  end;




  {* ------------------------ *}


  {* Print Line with Global effects *}

  Procedure RepCtrlObj.RepPrintLn(Line2Print  :  Str255);
  Begin
    SendLine(Line2Print);
  end;


  { ======================= Report Page ======================= }

  Procedure RepCtrlObj.RepPage;


  Begin
    (* {RW32}
    With Printer_Def do
    Begin

      If (Page>1) then
      Begin
        Println(ConCat(ConDon,Dson,'('+Syss.UserName+'). '+RepCtrlRec^.RepDesc,'/... continued',ConDof,DsOf));
        Inc(Ln);
      end;


      StdPage(Page);


      RepPrintLn(LineCtrl^.FillHeader);


      Println(ConCat(ConDon,ConstStr('=',132),ConDof));

      Ln:=Ln+4;
    end;

    NewPage:=BOn;
    *)
  end;




  {* ------------------------ *}


  Procedure RepCtrlObj.SelectRecords(Var NoFound  :  LongInt);

  Var
    WantSavePos,
    Selected,
    PassFileFilt,
    Abort,
    ForceEnd,
    FoundFirst,
    FastNDX
              :  Boolean;

    TmpStat,
    B_FuncGet,
    B_FuncNext
              :  Integer;

    MainRecPos,
    RecAddr,
    TotalCount,
    Count,
    NoChecked
              :  LongInt;


  Begin
    GroupRepRec^ := RepGen^;

    NoFound:=0;

    TotalCount:=Used_Recs(F[Fnum],Fnum);

    Count:=0;

    NoChecked:=0;  Abort:=BOff; ForceEnd:=BOff; FoundFirst:=BOn;

    FastNDX:=BOff;

    PassFileFilt:=BOff;

    (* {RW32}
    PopUp(BotW);

    PopShadw(StaW);

    WriteCtrPop(1,StaW,' - Exchequer Report Writer - ');

    WriteCtrPop(3,StaW,'Generating '+Copy(RepCtrlRec^.RepDesc,1,30));

    WriteCtrPop(4,StaW,'% Complete');

    WriteCtrPop(StaW[4],StaW,'<Any> Key to Abort');

    Draw_Scale(PBarW);
    *)

    { Update thread window for progress info }
//    ShowStatus(2,'Processing Report ('+IntToStr(NoFound)+'/'+IntToStr(TotalCount)+').');

    InitProgress(TotalCount);


    KeyChk:=File_CheckKey(RepCtrlRec^.DriveFile);

    File_BtrvDrv(RepCtrlRec^.DriveFile,B_FuncGet,B_FuncNext);
    WantSavePos := (B_FuncNext <> B_StepNext);

    KeyS:=KeyChk;

    With GroupRepRec^.ReportHed do
    Begin

      if Assigned(FSettings) then
      begin
        RefreshPos := FSettings^.rsRefreshFirst;
        RefreshEnd := FSettings^.rsRefreshLast;
        FirstPos := FSettings^.rsFirstPos;
        LastPos := FSettings^.rsLastPos;

      end;

      FastNDX:=(DrivePath>0);

      If (FastNDX) then Begin
        WantSavePos := False;
        New(FastObj,Init(FastNDXOrdL^[DriveFile,DrivePath],FNDXInpNo,RepName,MtExLocal, InpStart, InpEnd));
      End; { If }

      RefreshPos:=(RefreshPos or (FirstPos=0)); {* Force refresh *}

      RefreshEnd:=(RefreshEnd or (LastPos=0)); {* Force refresh *}

      If (RefreshPos) then
      Begin

        If (FastNDX) then
        Begin
          KeyChk:=FastObj^.KeyChk;
          KeyS:=KeyChk;

          Status:=FastObj^.Find_FastNDX(B_GetGEq,KeyS);

        end
        else
        Begin
          if RepCtrlRec^.DriveFile in FilesToCheck then
          begin
            B_FuncGet := B_GetGEq;
//            B_FuncGet := B_GetFirst;
            B_FuncNext := B_GetNext;
            KeyS := FirstKeyS(RepCtrlRec^.DriveFile);
          end;
          Status:=Find_Rec(B_FuncGet,F[Fnum],FNum,RecPtr[FNum]^,KeyPath,KeyS);
        end;
      end
      else
      Begin
        SetDataRecOfs(Fnum,FirstPos);

        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

        Count:=FirstTot;

        If (FastNDX) and (StatusOk) and (FastObj^.LinkUp) then {* Bring Link file In Line *}
          FastObj^.Jump_NDXStart(FirstPos);

      end;
    end;

   {$IFNDEF GUI}
   While (StatusOk) and ((CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) or (FastNDX))
          {$IFDEF THREDZ}
            and (Not ThreadRec^.THAbort)
          {$ENDIF}
          And (Not Abort) and (Not ForceEnd) do
   {$ELSE}
   //PR: 8/3/05 Wasn't checking key correctly so causing problems in variant files
//    while not Abort and (Status = 0) and ((CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) or (FastNDX)) and not ForceEnd do
    while not Abort and
         CheckStatus(RepCtrlRec^.DriveFile, FNum, KeyPath, KeyS, Status) and
         ((CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) or (FastNDX)) and not ForceEnd do
   {$ENDIF}
    Begin
      If WantSavePos Then Begin
        { Save main record position here if not STEPing }
        TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],MainRecPos,BOff,BOff);
      End; { If }

      Selected:=BOn;

      RecAddr:=0;

      {Loop_CheckKey(PrntOk);}

      Inc(Count);

      {$IFDEF GUI}
        {$IFNDEF GUI2}
        if Assigned(OnCheckRecord) then
          OnCheckRecord(Count, TotalCount, Abort);
        {$ELSE}
        ShowStatus(2,'Processing Report ('+IntToStr(NoFound)+'/'+IntToStr(TotalCount)+').');
        UpdateProgress(Count);
        {$ENDIF}
      {$ELSE}
      ShowStatus(2,'Processing Report ('+IntToStr(NoFound)+'/'+IntToStr(TotalCount)+').');
      UpdateProgress(Count);
      {$ENDIF}

      //PR: 27/03/2014 ABSEXCH-15214 Check that we want to include this record BEFORE getting all the data fields.
      PassFileFilt:=File_Include(RepCtrlRec^.DriveFile);

      if FastNDX then
        PassFileFilt := PassFileFilt and FastObj.WantThisRec;

      if PassFileFilt then
      begin
        LineCtrl^.FillObject(Selected);

        With LineCtrl^ do
          Abort:= Abort or (SelErr or FmulaErr);
      end;

      //PR: 27/03/2014 ABSEXCH-15214 Moved this check above
{      PassFileFilt:=File_Include(RepCtrlRec^.DriveFile);

      if FastNDX then
        PassFileFilt := PassFileFilt and FastObj.WantThisRec;}

      NoChecked:=NoChecked+Ord(PassFileFilt);

      If (Selected) and (PassFileFilt) and (Not Abort) then
      Begin

        Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Get Preserve File Posn *}

        If (FoundFirst) then
        With GroupRepRec^.ReportHed do
        Begin
          FirstPos:=RecAddr;
          FirstTot:=Count;

          FoundFirst:=BOff;

        end;

        if SQLUtils.UsingSQL then
          AddRecToTempList(LineCtrl^.FullSortKey)
        else
          ThisScrt^.Add_Scratch(Fnum,Keypath,RecAddr,LineCtrl^.FullSortKey,'');



        Inc(NoFound);

        //PR: 15/10/2014 Reset Order Payment link transaction
        OPLinkTransaction := '';

        {* Check for Abort if test mode and sample found *}

        ForceEnd:=((NoFound=SampleNo) and (TestMode));

        With GroupRepRec^.ReportHed do
        Begin
          ForceEnd:=(ForceEnd or ((LastPos=RecAddr) and (Not RefreshEnd)));

          If (RefreshEnd) then
            LastPos:=RecAddr;
        end;

      end;

      (* {RW32}
      MakeWindow(BotW);

      WriteCtrPop(2,BotW,'Records Processed/Selected : '+Form_Int(NoChecked,0)+'/'+Form_Int(NoFound,0));
      *)

      If WantSavePos Then Begin
        { Restore main record pos here if not STEPing }
        TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],MainRecPos,BOn,BOff);
      End; { If }

      If (FastNDX) then
        Status:=FastObj^.Find_FastNDX(B_GetNext,KeyS)
      else
        Status:=Find_Rec(B_FuncNext,F[Fnum],FNum,RecPtr[FNum]^,KeyPath,KeyS);

    end; {While..}

    (* {RW32}
    If (FastNDX) then
      Show_Bar(Round(DivWChk(TotalCount,TotalCount)*100),PBarW);

    RmWin;
    RmWin;
    *)

    If (FastNDX) then
      Dispose(FastObj,Done);

    LineCtrl^.LineTotals(2,0); {* Reset Current Values *}

    if Assigned(FSettings) then
    begin
      FSettings^.rsFirstPos := GroupRepRec^.ReportHed.FirstPos;
      FSettings^.rsLastPos := GroupRepRec^.ReportHed.LastPos;
    end;

  end; {Proc..}


  {* ------------------------ *}


  Procedure RepCtrlObj.Process_Breaks(LastOne  :  Boolean);

  Var
    n         :       Byte;
    MadeGap   :       Boolean;

    function SumToCSV(ColT : ColTextPtrType) : AnsiString;
    var
      i : integer;
      s : string;
    begin
      Result := '';
      with ColT^ do
        If (NumCols > 0) Then
          For I := 1 To NumCols Do
          begin
            s := Cols[I].ColVal;
            //Need to remove tab char from start of string
            if (Length(s) > 0) then
              if (s[1] = #9) then
                Delete(s, 1, 1);
            Result := Result + s + ',';
          end;

      i := Length(Result);
      if i > 0 then
        if Result[i] = ',' then
          Delete(Result, i, 1);
    end;



  Begin

    MadeGap:=BOff;

    With RepCtrlRec^ do
    Begin


      With LineCtrl^ do
      Begin

{        if LastOne then
          Move(LastBreakList, BreakList, SizeOf(LastBreakList))
        else}
        begin
          Move(BreakList, LastBreakList, SizeOf(LastBreakList));
          LastTBreakFound := TBreakFound;
        end;


        If (SubTOn) {and (Not FirstGo)} then
        Begin

          For n:=MaxNoSort downto 1 do
          Begin

            If (BreakList[n]<>0) then
            Begin

              If (SummOn) then
              Begin

                If (IncInSumm(n)) then
                Begin
                  { Mark break as printed }
                  PrntBrkList[n] := True;

                  If (n<>NOTBreaks) then
                  Begin
                    {RepPrintLn(FillTULine(BOff));}

                    PrintColUndies(LineCtrl^.FillUndies(BOff));

                    {Inc(Ln);}
                  end;

                  {RepPrintLn(FillSummary(n,(n=NOTBreaks)));}
                  FillSummary(n,(n=NOTBreaks), RepDest = 2);
                  if RepDest <> 2 then
                    PrintColText (ColText)
                  else
                  if CSVTotals then
                    ExportCDF(SumToCSV(ColText));


                  If (n<>NOTBreaks) then Begin
                    { HM Aded 13/3/97: To put line under subtotal }
                    {PrintColUndies(LineCtrl^.FillUndies(BOff));}
                    RepFiler1.CRLF;
                  end;
                end
                else
                  ReduceBreak(n);

                Inc(LineCount);

                Inc(RepRunCount);

                {Inc(Ln);}
              end
              else
              Begin

                {RepPrintLn(FillTULine(BOff));}
                if RepDest = 2 then
                begin
                  if CSVTotals then
                    ExportCDF(LineCtrl^.FillCDFTotals(n, Bon));
                end
                else
                begin
                  PrintColUndies(LineCtrl^.FillUndies(BOff));

                  RepPrintLn(FillTotal(n,BOn));
                end;

                {Ln:=Ln+2;}

              end;


            end; {If Break set}

          end; {Loop..}

        end; {If We are totaling..}


        FirstGo:=BOff;

        If (Not LastOne) then
        Begin
          For n:=1 to MaxNoSort Do Begin
            If (BreakList[n]<>0) then Begin
              { HM 10/02/98: Removed Summary filter }
              { HM 08/06/98: Extended filter to check for items printed in summary breaks }
              If (FindObj(BreakList[n])) and
                 ((Not SummOn) Or (SummOn And PrntBrkList[n])) and
                 (Not MadeGap) then Begin
                MadeGap:=BOn;

                Case RepField^.RepFieldRec^.RepDet.Break of
                  { HM 08/06/98: ON Breaks modified to not print a blank line }
                  2   :   ;

                  { Line Break }
                  3   :   Begin
                            RepPrintLn('')
                          end;

                  { Page Break }
                  4   :  If (Not NewPage) then {* Don't start a new page if we are at the beginning of one *}
                          Begin
                            RepFiler1.NewPage;
                          end;
                end; {Case..}

              end; {If..}

              If HedCtrl^.HasHed(n) Then Begin
                { Print Sub Heading }
                RepSetHeadingTabs;                 { Set tabs for sub-headings }
                HedCtrl^.FillColText(n);           { Calculate sub-heading values }
                PrintColText (HedCtrl^.ColText);   { print sub-headings }
                RepSetTabs;                        { set normal line tabs }
              End; { If }

              BreakList[n]:=0;
              PrntBrkList[n] := False;

              LineTotals(1,n); {* Reset that break level *}
            End; {If Set..}
          End; {Loop..}
        end; {If Forced last line *}

        TBreakFound:=0;
      end; {With LineCtrl..}
    end; {With RepCtrl..}
  end;{Proc..}



  { ======================= Report End ======================= }

  Procedure RepCtrlObj.RepEnd;

  Var
    Selected  :  Boolean;

  Begin
    Selected:=BOff;

    With LineCtrl^ do
      If (SubTOn) Then Begin
        { blanks all the records }
        Reset_DataRecs;

        LineCtrl^.FillObject(Selected);

        If (LastTBreakFound<>0) then
          Process_Breaks(BOn);

        {RepPrintLn(FillTULine(BOff));}
        PrintColUndies(LineCtrl^.FillUndies(BOn));

        if RepCtrlRec^.RepDest <> 2 then
          RepPrintLn(FillTotal(0,BOff))
        else
        if RepCtrlRec^.CSVTotals then
          ExportCDF(FillCDFTotals(0,BOff));

        {RepPrintLn(FillTULine(BOn));}
        {PrintColUndies(LineCtrl^.FillUndies(BOn));}
      end;

    { Restore font to normal }
    With RepFiler1.Canvas.Font Do Begin
      Color := TColor(RepCtrlRec^.DefFont.fColor);
      Style := TFontStyles(RepCtrlRec^.DefFont.fStyle);
    End; { With }
    ICount := LineCount;
    PrintEndPage;

    {StdBot;}
  end;



  {* ------------------------ *}


  Procedure RepCtrlObj.Process_File;
  Const
    Fnum2     =  ReportF;
    Keypath2  =  RpK;
  Var
    Selected  :  Boolean;
    TSelect   :  ShortString;
    FErr      :  Byte;
    RecNo,NumRecs : LongInt;
  Begin
    FErr:=0;

    TSelect:='';

    KeyChk:=FullNomKey(9000);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[FNum2],FNum2,RecPtr[FNum2]^,KeyPath2,KeyS);

    RecNo   := 1;
    NumRecs := Used_Recs(F[FNum2],FNum2);
    ShowStatus(2,'Printing Report ('+IntToStr(RecNo)+'/'+IntToStr(NumRecs)+').');

{$IFDEF DBF}
    WantNewDBF := True;
    if DBFOn then
      CreateDBFLists;

{$ENDIF}

    While (StatusOk) And
          {$IFDEF THREDZ}
            (Not ThreadRec^.THAbort) And
          {$ENDIF}
          (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and {(PrntOk) and} (KeepRep) do
    With RepCtrlRec^ do Begin

      {Stppout(PrntOk);} {RW32}

      ThisScrt^.Get_Scratch(RepScr^);

      Selected:=BOff;

      {RepGenRecs^.ReportHed.CurrBreak:=Ord(LineCtrl^.FirstGo);}
      GroupRepRec^.ReportHed.CurrBreak:=Ord(LineCtrl^.FirstGo);

      LineCtrl^.FillObject(Selected);

      {TSelect:=RepGenRecs^.ReportHed.RepSelect;}
      TSelect:=GroupRepRec^.ReportHed.RepSelect;

      KeepRep:=LineCtrl^.Evaluate_Expression(TSelect,FErr);

(*      If (LineCtrl^.SelErr) then {* Abort with warning *}
      Begin

        Warn_ValErr('H',TSelect);

        KeepRep:=BOff;

      end; *)

      { Check for new page }
      If (RepFiler1.LinesLeft < 8) Then
        RepFiler1.NewPage;

      If (KeepRep) then
        Case RepDest of

//          2  :  ExportCDF(LineCtrl^.FillCDFLine);  {* Output in CDF *}

          3  :  LineCtrl^.WriteDBFRecord;

          else  With LineCtrl^ do
                Begin


                  If (TBreakFound<>0) then
                    Process_Breaks(BOff);

                  {* Calculate any Totals *}

                  LineTotals(0,0);

                  NewPage:=BOff;

                  If (Not SummOn) Then Begin
                    {RepPrintLn(LineCtrl^.FillLine);}

                    if RepDest = 2 then
                    begin
                      ExportCDF(LineCtrl^.FillCDFLine);
                    end
                    else
                    begin

                      LineCtrl^.FillColText;
                      PrintColText (LineCtrl^.ColText);

                      Inc(LineCount);

                      Inc(RepRunCount);
                    end;
                  End; { If }

                end;

        end; {Case..}

        //PR: 15/10/2014 Reset Order Payment link transaction
        OPLinkTransaction := '';


      Status:=Find_Rec(B_GetNext,F[FNum2],FNum2,RecPtr[FNum2]^,KeyPath2,KeyS);

      Inc(RecNo);
      ShowStatus(2,'Printing Report ('+IntToStr(RecNo)+'/'+IntToStr(NumRecs)+').');
    end; {While..}

    If not (RepCtrlRec^.RepDest in [{2,} 3]) then
      RepEnd;

{$IFDEF DBF}
    if DBFOn then
    begin
      FreeDBFLists;
    end;
{$ENDIF}

  end;{Proc..}


 {* ------------------------ *}


 Procedure RepCtrlObj.Process_Report;

 Var
   RecSelected  :  LongInt;


 Begin

   LoadPeriods;

   RecSelected:=0;


   SelectRecords(RecSelected);
   DDFuncs.FreeDataDictList;

   NoOfRecsFound := RecSelected;

{$IFNDEF GUI}
   If (RecSelected>0) then
   Begin

     Process_File;

   end;
{$ELSE}
{   if Assigned(OnFinished) then
     OnFinished;}
{$ENDIF}

 end;


 {=============================================================================}

 { Loads any input into the report object }
 Function RepCtrlObj.GetReportInput : Boolean;
 Begin
   Result := Inherited GetReportInput;

   RepTitle := RepCtrlRec^.RepDesc;
   PageTitle := RepTitle;
 End;

 { Sets the tab positions for fields }
 Procedure RepCtrlObj.RepSetTabs;
 Var
   ColWidths : ColWidthsType;
   CStart    : Double;
   I         : SmallInt;
   CJust     : TPrintJustify;
 Begin
   With RepFiler1 Do Begin
     { go through the fields calculating the tab positions and justification }
     ColWidths := LineCtrl^.GetColWidths;

     If (ColWidths[0].Width > 0) Then Begin
       ClearTabs;

       CStart := MarginLeft;

       For I := 1 To ColWidths[0].Width Do Begin
         Case ColWidths[I].Just Of
           'C'      : CJust := pjCenter;
           'L'      : CJust := pjLeft;
           'R', 'B' : CJust := pjRight;
         Else
           CJust := pjLeft;
         End; { Case }

         SetTab (CStart, CJust, ColWidths[I].Width, 4, 0, 0);

         CStart := CStart + ColWidths[I].Width + RepCtrlRec^.ColSpace;
       End; { For }
     End; { If }
   End; { With }
 End;

 { Sets the tab positions for fields }
 Procedure RepCtrlObj.RepSetHeadingTabs;
 Var
   ColWidths : ColWidthsType;
   CStart    : Double;
   I         : SmallInt;
   CJust     : TPrintJustify;
 Begin
   With RepFiler1 Do Begin
     { go through the fields calculating the tab positions and justification }
     ColWidths := HedCtrl^.GetColWidths;

     If (ColWidths[0].Width > 0) Then Begin
       ClearTabs;

       CStart := MarginLeft;

       For I := 1 To ColWidths[0].Width Do Begin
         Case ColWidths[I].Just Of
           'C'      : CJust := pjCenter;
           'L'      : CJust := pjLeft;
           'R', 'B' : CJust := pjRight;
         Else
           CJust := pjLeft;
         End; { Case }

         SetTab (CStart, CJust, ColWidths[I].Width, 4, 0, 0);

         CStart := CStart + ColWidths[I].Width + RepCtrlRec^.ColSpace;
       End; { For }
     End; { If }
   End; { With }
 End;

 { Prints the Column headers }
 Procedure RepCtrlObj.RepPrintPageHeader;
 Begin
   With RepFiler1 Do Begin
     DefFont(0,[fsBold]);

     { Print the header line }
     SendText(LineCtrl^.FillHeader);

     { draw line under the titles }
     SetPen(clBlack, psSolid, -2, pmCopy);
     MoveTo(MarginLeft-1,YD2U(CursorYPos));
     LineTo((PageWidth+1-MarginRight),YD2U(CursorYPos));
     MoveTo(MarginLeft-1,YD2U(CursorYPos));

     { Start next line }
     RepFiler1.CRLF;

     DefFont(0,[]);
   End; { With }
 End;

 { Called by the Thread Controller to generate and print the report }
 Procedure RepCtrlObj.Process;
 Var
   RecSelected  :  LongInt;
   KeyS2        :  Str255;
   PrnNotify    :  PrintNotifyPtr;
 Begin
   Inherited Process;

   { set up GroupRepRec }
(*   GroupRepRec^ := RepGen^;

   ShowStatus (0, RepCtrlRec^.RepDesc);

   { Create scratch file }
   If (RepCtrlRec^.RepType<>RepNomCode) then Begin
     ThisRepNo := CommandPool.OpenBit;
     CommandPool[ThisRepNo] := True;

     New(ThisScrt,Init(9000 + ThisRepNo));
   End; { If } *)

   { Generate Scratch file }
   RecSelected := 0;
   BuildTempData(RecSelected);

   { Print the report }
//   RepFiler1.Execute;



   { update the last printed date }
(*   With MtExLocal^ Do Begin
     KeyS2 := FullRepKey_NDX (ReportGenCode, RepGroupCode, RepCtrlRec^.RepName);
     LStatus := LFind_Rec(B_GetEq, RepGenF, RGNdxK, KeyS2);

     If LStatusOk Then Begin
       With LRepGen^.ReportHed Do Begin
         LastRun := Today;
         LastOpo := EntryRec^.Login;
         FirstPos := GroupRepRec^.ReportHed.FirstPos;
         FirstTot := GroupRepRec^.ReportHed.FirstTot;
         LastPos := GroupRepRec^.ReportHed.LastPos;


       End; { With }

       LStatus := LPut_Rec(RepGenF, RgNdxK);

       New (PrnNotify);
       PrnNotify.RepName := LRepGen^.ReportHed.RepName;
       SendMessage (Application.MainForm.Handle, WM_UpdateTree, 0, LongInt(PrnNotify));
     End; { If }
   End; { With } *)

{   if Assigned(OnFinished) then
     OnFinished;}

 End;

 Procedure RepCtrlObj.BuildTempData(Var NoFound : LongInt);
 Begin
   SelectRecords (NoFound);
 End;

 Procedure RepCtrlObj.RepPrint(Sender  :  TObject);
 Begin
   Process_File;
 End;

 Procedure RepCtrlObj.PrintColText (Const ColText : ColTextPtrType);
 Var
   TabStr : ShortString;
   I, J   : SmallInt;
 Begin
   TmpColText := ColText;
   With RepFiler1, TmpColText^ Do Begin
     TabStr := '';

     If (NumCols > 0) Then
       For I := 1 To NumCols Do Begin
         { Set Font }
         Bold      := (fsBold In TFontStyles(Cols[I].FontStyle));
         Italic    := (fsItalic In TFontStyles(Cols[I].FontStyle));
         StrikeOut := (fsStrikeOut In TFontStyles(Cols[I].FontStyle));
         UnderLine := (fsUnderLine In TFontStyles(Cols[I].FontStyle));
         Canvas.Font.Color := TColor(Cols[I].FontColor);

         { Print Text }
         SendText (TabStr + Cols[I].ColVal);

         { need to keep a track of tabs, otherwise everything is put in the first tab }
         TabStr := TabStr + #9;

         { also take care any embedded tabs. i.e. Debit/Credit columns }
         If (Pos (#9, Copy(Cols[I].ColVal, 2, Length(Cols[I].ColVal) - 1)) > 0) Then
           TabStr := TabStr + #9;
       End; { For }

     { Start new line }
     CRLF;
   End; { With }
 End;

 Procedure RepCtrlObj.PrintColUndies (Const ColUndies : ColUndiesType);
 Const
   UndySet = ['-', '='];
 Var
   TabStr  : ShortString;
   I       : SmallInt;
   TabInfo : PTab;
 Begin
   With RepFiler1 Do Begin
     TabStr := '';

     For I := Low(ColUndies) To High(ColUndies) Do Begin
       If (ColUndies[I] = #0) Then Break;

       { need to keep a track of tabs, otherwise everything is put in the first tab }
       TabStr := TabStr + #9;

       { Check we need to draw an underline }
       If (ColUndies[I] In UndySet) Then Begin
         TabInfo := RepFiler1.GetTab (I + 1);

         If Assigned(TabInfo) Then Begin
           If (ColUndies[I] = '-') Then Begin
             SetPen(clBlack, psSolid, -1, pmCopy);

             MoveTo(XI2U(TabInfo.Pos), YD2U(CursorYPos)-({YI2U}(LineHeight)/2));
             LineTo(XI2U(TabInfo.Pos + TabInfo.Width),YD2U(CursorYPos)-({YI2U}(LineHeight)/2));
             MoveTo(1, YD2U(CursorYPos));
           End { If }
           Else Begin
             SetPen(clBlack, psSolid, -2, pmCopy);

             MoveTo(XI2U(TabInfo.Pos), YD2U(CursorYPos)-({YI2U}(LineHeight)/2));
             LineTo(XI2U(TabInfo.Pos + TabInfo.Width),YD2U(CursorYPos)-({YI2U}(LineHeight)/2));
             MoveTo(1, YD2U(CursorYPos));

             (*
             MoveTo(XI2U(TabInfo.Pos), YD2U(CursorYPos)-(YI2U(LineHeight) * 0.4));
             LineTo(XI2U(TabInfo.Pos + TabInfo.Width),YD2U(CursorYPos)-(YI2U(LineHeight) * 0.4));
             MoveTo(1, YD2U(CursorYPos));

             MoveTo(XI2U(TabInfo.Pos), YD2U(CursorYPos)-(YI2U(LineHeight) * 0.6));
             LineTo(XI2U(TabInfo.Pos + TabInfo.Width),YD2U(CursorYPos)-(YI2U(LineHeight) * 0.6));
             MoveTo(1, YD2U(CursorYPos));
             *)
           End; { Else }
         End; { If }
       End; { If }
     End; { For }

     CRLF;          { Put lines on a separate line }
   End; { With }
 End;

 Function RepCtrlObj.Start  :  Boolean;
 Var
   mbRet : Word;
 Begin
   Result:=GetReportInput;

   If (Result) then Begin
     RDevRec.feEmailSubj := Trim(RepGen^.ReportHed.RepDesc) + ' Report';
     RDevRec.feFaxMsg := RDevRec.feEmailSubj + #13#10;

{$IFNDEF DBF}
     If ((Not CDFOn) And SelectPrinter(RDevRec)) Or
        (CDFOn And SelectCDFFile(RepCtrlRec^.LastPath)) Then Begin
{$ELSE DBF}
     If ((Not (CDFOn or DBFOn)) And SelectPrinter(RDevRec)) Or
        (CDFOn And SelectCDFFile(RepCtrlRec^.LastPath)) or
        (DBFOn And SelectDBFFile(RepCtrlRec^.LastPath)) Then Begin
{$ENDIF}
                   {RepCtrlRec :  ^ReportHedType;
                   RepGen     :  ^RepGenRec;}

       (* Moved to create
       If (Not Assigned(RepExLocal)) and (Result) then { Open up files here }
         Result:=Create_ReportFiles;

       If (Result) then
         MTExLocal:=RepExLocal;
       *)
       Result := FilesOk;

       { Set The Font }
       CopyFont (RFont, RepCtrlRec^.DefFont, False);

       If (Result) then Begin
         { Initialise printer settings }
         If (RepCtrlRec^.PaprOrient = 'L') Then
           ROrient := RpDefine.poLandScape
         Else
           ROrient := RpDefine.poPortrait;

         InitRep1;

         RepFiler1.LineHeightMethod := lhmFont;
       End; { If }

       If (CDFOn) Then
       begin
         Open_Def(RepCtrlRec^.LastPath,CDFOn);
         Result := CDFOn;
       end
{$IFDEF DBF}
       else
       if DBFOn then
         StartDBF(RepCtrlRec^.LastPath)
{$ENDIF}
       ;
     End { If }
     Else
       { Cancelled in printer dialog }
       Result := False;
   End; { If }
 end;

{ need to keep declaration in sync with rwValErrorEvent }
Procedure RepCtrlObj.Warn_ValErr(RVNo    :  Str10;
                                 ValLine :  ShortString);
  Var
    ErrStr    :  Str255;
    mbRet     :  Word;
    ThStr     :  Str255;
    ClientIdR :  ClientIdType;
  Begin
(*    ThStr:='';
    ErrStr:=RepCtrlRec^.RepDesc + #10#13 +
            'The Report Global Selection is incorrect.' + #10#13 +
            'Field '+RVNo+' is incorrect.';

    With MtExLocal^ do
      If (Assigned(LThShowMsg)) then Begin
        If (Assigned(ExClientId)) then
          ThStr:=#13+'In thread '+Form_Int(ThreadRec^.THIdNo{ExClientId.TaskId},0);

        LThShowMsg(nil,2,ErrStr+ThStr);
      End
      Else
        MessageDlg (ErrStr, mtError, [mbOk], 0); *)

  LineCtrl^.VErrCode := veBadSyntax;
  LineCtrl^.VErrMsg  := 'Invalid syntax' + QuotedStr(ValLine);
end;

procedure RepCtrlObj.LoadPeriods;
var
  GRec : TGUIFieldRec;
  iYear : SmallInt;
  sYear : string;
  PeriodObj : TPeriodDetailObject;
begin
  if Assigned(FGetLineField) then
  while FGetLineField(GRec) = 0 do
  begin
//    if GRec.PeriodField then
    begin
      PeriodObj := TPeriodDetailObject.Create;
      if Trim(GRec.Year) = '' then
        sYear := ''
      else
      begin
        iYear := StrToInt(GRec.Year);

        if iYear > 1900 then
          iYear := iYear - 1900;

        sYear := IntToStr(iYear);
      end;

      LineCtrl^.RepField^.Calc_PrYr(GRec.Period,sYear,PeriodObj.Details.DPr,PeriodObj.Details.DYr);
      PeriodObj.Details.DCr := GRec.Currency;

      FPeriodList.AddObject({GRec.VarRef + }IntToStr(GRec.FieldNo), PeriodObj);

    end;

  end;

end;

function RepCtrlObj.PeriodDetails(const DBFCode : string) : DictLinkType;
var
  i : Integer;
begin
  i := FPeriodList.IndexOf(DBFCode);
  if i > -1 then
    with FPeriodList.Objects[i] as TPeriodDetailObject do
      Result := Details;
end;

Procedure RepCtrlObj.RepPrintHeader(Sender  :  TObject);
Var
  LocalNode          : NodePtr;
  InpField           : RepFieldPtr;

  Function InpData (Const RD : ReportDetailType) : String;
  Begin { InpData }
    With RD Do
      Case RepLIType Of
      { Date }
      1  : Result := POutDateB(DRange[1]) + #9 + POutDateB(DRange[2]);

      { Period }
      2  : Result := PPR_OutPr(PrRange[1,1], PrRange[1,2]) + #9 + PPR_OutPr(PrRange[2,1], PrRange[2,2]);

      { Value }
      3  : Result := SysUtils.Format('%0.2f', [VRange[1]]) + #9 + SysUtils.Format('%0.2f', [VRange[2]]);

      { Currency }
      5  : Result := SSymb (CrRange[1]) + #9 + SSymb (CrRange[2]);

      4,         { ASCII }
      6,         { Document No. }
      7,         { Customer Code }
      8,         { Supplier Code }
      9,         { Nominal Code }
      10,        { Stock Code }
      11,        { Cost Centre Code }
      12,        { Department Code }
      13,        { Location Code }
      17,        { Job Code }
      18 : Begin { Bin Code }
             Result := ASCStr[1] + #9 + ASCStr[2];
           End;
    Else
      Result := 'Unknown Data';
    End; { Case }
  End; { InpData }

  Procedure FaxCoverPage;
  Var
    oNewPage, oPrnHead : TNotifyEvent;
    Memo               : TMemoBuf;
  Begin { FaxCoverPage }
    With RepFiler1 Do Begin
      DefFont (16, [fsBold]);
      YPos := PageHeight * 0.24;
      PrintCenter ('FAX TRANSMISSION', (PageWidth - MarginLeft) / 2);
      CRLF;
      CRLF;
      DefFont (10, [fsBold]);
      PrintCenter (Trim(PageTitle) + ' Report', (PageWidth - MarginLeft) / 2);
      CRLF;
      CRLF;

      DefFont (4, [fsBold]);
      ClearTabs;
      SetTab (15, pjRight, 30, 4, 0, 0);   { Description }
      SetTab (55, pjLeft, 150, 4, 0, 0);   { Data }

      PrintLn (#9 + 'F.A.O.:' + #9 + RDevRec.feFaxTo);
      CRLF;
      PrintLn (#9 + 'Fax No.:' + #9 + RDevRec.feFaxToNo);
      CRLF;
      PrintLn (#9 + 'FROM:' + #9 + RDevRec.feFaxFrom + ' (' + Trim(Syss.UserName) + ')');
      CRLF;
      PrintLn (#9 + 'DATE:' + #9 + FormatDateTime ('dddd dd mmm yyyy', Now));
      CRLF;
      CRLF;

      ClearTabs;
      SetTab (20, pjLeft, 170, 4, 0, 0);
      PrintLn (#9 + 'Number of pages including this one:-  ' + Macro (midTotalPages));

      DefFont (4, []);
      CRLF;
      PrintLn (#9 + 'If this or any of the following pages are missing or unreadable please call: ' + Syss.DetailTel);

      DefFont (4, [fsBold, fsUnderline]);
      CRLF;
      PrintLn (#9 + 'Message');

      If (Trim(RDevRec.feFaxMsg) <> '') Then Begin
        DefFont (3, []);
        CRLF;

        Memo := TMemoBuf.Create;
        Try
          Memo.Text := Trim(RDevRec.feFaxMsg);
          Memo.PrintStart := 30;
          Memo.PrintEnd   := PageWidth - 30;
          PrintMemo(Memo, 0, False);
        Finally
          Memo.Free;
        End;
      End; { If (Trim(RDevRec.feFaxMsg) <> '') }

      { Start New Page }
      oNewPage := OnNewPage;
      OnNewPage := Nil;
      oPrnHead := OnPrintHeader;
      OnPrintHeader := Nil;
      NewPage;
      OnNewPage     := oNewPage;
      OnPrintHeader := oPrnHead;
    End; { With RepFiler1 }
  End; { FaxCoverPage }

  Procedure InpDataPage;
  Begin { InpDataPage }
    With RepFiler1 Do Begin
      { Company Name / Date-Time }
      PrintHedTit;

      { Report Name / User }
      PrintStdPage;

      { Print Line }
      //RepPrintPageHeader;
      SetPen(clBlack, psSolid, -2, pmCopy);
      MoveTo(MarginLeft-1,YD2U(CursorYPos));
      LineTo((PageWidth+1-MarginRight),YD2U(CursorYPos));
      MoveTo(MarginLeft-1,YD2U(CursorYPos));

      { Start next line }
      CRLF;

      { Define Tabs for info section }
      ClearTabs;
      SetTab (MarginLeft, pjLeft, 25, 4, 0, 0);
      SetTab (NA,         pjLeft, 90, 4, 0, 0); {   Description }
      DefFont (0, [fsBold]);
      CRLF;
      PrintLn ('General Information');
      DefFont (0, []);
      With RepCtrlRec^ Do Begin
        PrintLn (#9'F6 Period' + #9 + Format('%2.2d/%4.4d', [Syss.CPr, 1900 + Syss.CYr]));
        PrintLn (#9'Last Printed' + #9 + POutDateB(LastRun) + ' by ' + LastOpo);
        Print   (#9'Test Mode' + #9);
        If TestMode Then
          PrintLn (Format('On (Refresh Start: %s, Refresh End: %s, Count: %d)',
                          [YesNoBo(RefreshPos), YesNoBo(RefreshEnd), SampleNo]))
        Else
          PrintLn ('Off');
      End; { With RepCtrlRec^ }

      { Define Tabs for info section }
      ClearTabs;                                 { Title }
      SetTab (MarginLeft, pjLeft, 12, 4, 0, 0); {   Field No }
      SetTab (NA,         pjLeft, 35, 4, 0, 0); {   Description }
      SetTab (NA,         pjLeft, 30, 4, 0, 0); {   Data Type }
      SetTab (NA,         pjLeft, 50, 4, 0, 0); {   Value 1 }
      SetTab (NA,         pjLeft, 50, 4, 0, 0); {   Value 2 }

      DefFont (0, [fsBold]);
      CRLF;
      PrintLn ('Input Fields');
      DefFont (0, [fsUnderLine]);
      PrintLn (#9 +
               '' + #9 +
               'Description' + #9 +
               'DataType' + #9 +
               'Value1' + #9 +
               'Value2');
      DefFont (0, []);

      If Assigned(LineCtrl) Then
        With LineCtrl^ Do
          If Assigned (InpObj) Then Begin
            LocalNode := InpObj^.GetFirst;
            If Assigned(LocalNode) Then
              While Assigned(LocalNode) Do Begin
                InpField := LocalNode^.LITem;

                With InpField^.RepfieldRec^, RepDet Do
                  PrintLn (#9 + 'I' + IntToStr(RepVarNo) +
                           #9 + RepLDesc +
                           #9 + RepInpTypesL^[RepLIType] +
                           #9 + InpData(RepDet));

                LocalNode := InpObj^.GetNext(LocalNode);
              End { While Assigned(LocalNode) }
            Else
              PrintLn (#9'No Input Fields Defined');
          End; { If Assigned (InpObj)  }

      { Footer }
      CRLF;
      SetPen(clBlack, psSolid, -2, pmCopy);
      MoveTo(MarginLeft-1,YD2U(CursorYPos));
      LineTo((PageWidth+1-MarginRight),YD2U(CursorYPos));
      MoveTo(MarginLeft-1,YD2U(CursorYPos));

      { Start New Page }
      RepSetTabs;
      NewPage;
    End; { With RepFiler1 }
  End; { InpDataPage }

Begin { RepPrintHeader }
  With RepFiler1 Do Begin
    If (CurrentPage=1) Then Begin
      { Check to see if fax cover page wanted }
      If (RDevRec.fePrintMethod = 1) And (RDevRec.feCoverSheet = 'AAAAAAAA') Then Begin
        { Print Fax Cover Page }
        FaxCoverPage;

        If RepCtrlRec^.PrnInpData Then
          InpDataPage
        Else
          RepSetTabs;
      End { If }
      Else Begin
        { Not Faxing - normal operation }
        If RepCtrlRec^.PrnInpData Then
          InpDataPage
        Else
          Inherited;
      End; { Else }
    End { If }
    Else
      Inherited;
  End; { With }
End; { RepPrintHeader }

procedure RepCtrlObj.SetDbfCmdLine;
var
  KeyS1 : Str255;
  TmpLck : Boolean;
  i : integer;
begin
  DbfCmdLine := '';
  With MTExLocal^ Do Begin
    if DBFOn then
    begin
      KeyS1 := FullRepKey_RGK(ReportGenCode, RepCommandType, RepCtrlRec^.ReportKey);
      if LFind_Rec(B_GetEq, RepGenF, RGK, KeyS1) = 0 then
      begin
        DbfCmdLine := Trim(LRepGen^.RCommand.Command);
      end;
    end;
  end;
end;

procedure RepCtrlObj.ExpandDbfCmdLine;
var
  i : integer;
begin
  i := Pos('%1', DbfCmdLine);
  if i > 0 then
  begin
    Delete(DbfCmdLine, i, 2);
    Insert(RepCtrlRec^.LastPath, DbfCmdLine, i);
  end;
end;

{$IFDEF GUI}
procedure RepCtrlObj.DoSelectRecord;
var
  N : NodePtr;
  PrintObj : TPrintIfObj;

  procedure ClearTmpList;
  var
    i : Integer;
  begin
    for i := 0 to TmpList.Count - 1 do
      if Assigned(TmpList.Objects[i]) then
        TmpList.Objects[i].Free;
    TmpList.Clear;
  end;

begin
  if Assigned(OnSelectRecord) then
  begin
    ClearTmpList;

    N := LineCtrl.GetFirst;

    while N <> nil do
    begin
      PrintObj := TPrintIfObj.Create;
      PrintObj.WantPrint := RepFieldPtr(N^.LItem).RepfieldRec.RepDet.SpareBool;
      TmpList.AddObject(RepFieldPtr(N^.LItem).FillField(False), PrintObj);

      N := LineCtrl.GetNext(N);

    end;

{    if Back then
      Dec(RepRunCount)
    else
      inc(RepRunCount);}

    OnSelectRecord(TmpList);
  end;

end;

procedure RepCtrlObj.DoSelectRecordSQL;
begin
  //PR: 24/05/2010 Added check that FSQLList.Count > 0
  if Assigned(OnSelectRecord) then
    if FSQLList.Count > 0 then
      with FSQLList.Objects[FSQLIndex] as TRecordPosition do
        OnSelectRecord(FieldValueList(FTempFile, FSQLIndex));

end;

procedure RepCtrlObj.AddRecToTempList(sKey : string);
var
  N : NodePtr;
  bPrint : Boolean;
  oRecPos : TRecordPosition;
  s : ShortString;
begin
  oRecPos := TRecordPosition.Create;
  oRecPos.Position := FTempFile.Position;
  N := LineCtrl.GetFirst;

  while N <> nil do
  begin
    bPrint := RepFieldPtr(N^.LItem).RepfieldRec.RepDet.SpareBool;
    s := RepFieldPtr(N^.LItem).FillField(False);
    oRecPos.AddField(FTempFile, s, bPrint, FNum, RepFieldPtr(N^.LItem).RepfieldRec.RepDict.VarNo,
       RepFieldPtr(N^.LItem).RepfieldRec.RepDet.CalcField);

    N := LineCtrl.GetNext(N);
  end;

  FSQLList.AddObject(sKey, oRecPos);
end;

function RepCtrlObj.GetFirst : Boolean;
Const
  Fnum2     =  ReportF;
  Keypath2  =  RpK;
Var
  Selected  :  Boolean;
  TSelect   :  ShortString;
  FErr      :  Byte;
  RecNo,NumRecs : LongInt;
//  KeyChk, KeyS : Str255;
Begin
  FErr:=0;
  LineCtrl^.FirstPass := False;
  TSelect:='';
  if SQLUtils.UsingSQL then
  begin
    //PR: 01/06/2010 Assign 2nd pass dbf event handler to get fields from cached file rather than db
    LineCtrl^.GetDBFEvent := GetDBField;
    FSQLIndex := 0;
    Result := False;

    //Go through records until one passes check
    while not Result and (FSQLIndex < FSQLList.Count) do
    begin
      if (FSQLIndex < FSQLList.Count) then
      begin
        DoSelectRecordSQL;
        Result := CheckRecordSQL;
        if not Result then
          //Failed so go to next record
          inc(FSQLIndex);
      end;
    end;
  end
  else
  begin
    KeyChk:=FullNomKey(9000);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[FNum2],FNum2,RecPtr[FNum2]^,KeyPath2,KeyS);

    Result := (Status = 0) and  (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff));

    if Result then
    begin
      RepRunCount := 1;
      CopyDataToGUIField;
    end;
  end;
end;

function RepCtrlObj.GetNext  : Boolean;
Const
  Fnum2     =  ReportF;
  Keypath2  =  RpK;
begin
  //PR: 22/01/2010 Need to increment Record Count before getting data
  Inc(RepRunCount);
  if SQLUtils.UsingSQL then
  begin
    Result := False;

    //Go through records until one passes check
    while not Result and (FSQLIndex < FSQLList.Count) do
    begin
      inc(FSQLIndex);
      if (FSQLIndex < FSQLList.Count) then
      begin
        DoSelectRecordSQL;
        Result := CheckRecordSQL;
      end;
    end;
  end
  else
  begin
    Status:=Find_Rec(B_GetNext,F[FNum2],FNum2,RecPtr[FNum2]^,KeyPath2,KeyS);

    Result := (Status = 0) and  (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff));
    while Result and not CopyDataToGuiField do
    begin
      Status:=Find_Rec(B_GetNext,F[FNum2],FNum2,RecPtr[FNum2]^,KeyPath2,KeyS);

      Result := (Status = 0) and  (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff));
    end;
  end;

{  if Result then
    Inc(RepRunCount);}
end;

function RepCtrlObj.GetPrevious  : Boolean;
Const
  Fnum2     =  ReportF;
  Keypath2  =  RpK;
begin
  //PR: 22/01/2010 Need to decrement Record Count before getting data
  Dec(RepRunCount);
  if SQLUtils.UsingSQL then
  begin
    Result := False;

    //Go through records until one passes check
    while not Result and (FSQLIndex >= 0) do
    begin
      Dec(FSQLIndex);
      if (FSQLIndex >= 0) then
      begin
        DoSelectRecordSQL;
        Result := CheckRecordSQL;
      end;
    end;
  end
  else
  begin
    Status:=Find_Rec(B_GetPrev,F[FNum2],FNum2,RecPtr[FNum2]^,KeyPath2,KeyS);

    Result := (Status = 0) and  (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff));
    while Result and not CopyDataToGuiField do
    begin
      Status:=Find_Rec(B_GetPrev,F[FNum2],FNum2,RecPtr[FNum2]^,KeyPath2,KeyS);

      Result := (Status = 0) and  (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff));
    end;
  end;
{  if Result then
    Dec(RepRunCount);}
end;


function RepCtrlObj.CopyDataToGUIField : Boolean;
Var
  Selected  :  Boolean;
  TSelect   :  ShortString;
  FErr      :  Byte;
  RecNo,NumRecs : LongInt;
begin
  With RepCtrlRec^ do Begin

    {Stppout(PrntOk);} {RW32}

    ThisScrt^.Get_Scratch(RepScr^);

    Selected:=BOn;

    {RepGenRecs^.ReportHed.CurrBreak:=Ord(LineCtrl^.FirstGo);}
    GroupRepRec^.ReportHed.CurrBreak:=Ord(LineCtrl^.FirstGo);

    LineCtrl^.FillObject(Selected);

(*{    TSelect:=GroupRepRec^.ReportHed.RepSelect;

    KeepRep:=LineCtrl^.Evaluate_Expression(TSelect,FErr);}

    If (LineCtrl^.SelErr) then {* Abort with warning *}
    Begin

//      Warn_ValErr('H',TSelect);

      KeepRep:=BOff;

    end; *)

    If Selected then
      DoSelectRecord;

    Result := Selected;
  end;

end;


{$ENDIF}


{ TRecordPosition }
//PR: 10/11/2015 ABSEXCH-15491 Extended parameters to include list index
function TRecordPosition.FieldValueList(
  var aFile: TFileStream; ListIndex : Integer): TStringList;
//Reads values from TFileStream and adds them into TStringList;
var
  PrintObj : TPrintIfObj;
  oVRWField : TVRWField;
  AList : TStringList;
  i : integer;
  s : Str255;
  sDrillDownKey : ShortString;
begin
  aFile.Seek(FPosition, soFromBeginning);
  AList := TStringList.Create;

  //Find
  for i := 0 to FFields.Count - 1 do
  begin
    oVRWField := TVRWField(FFields[i]);
    s[0] := Char(oVRWField.Offset);
    aFile.Read(s[1], oVRWField.Offset);

    //PR: 10/11/2015 ABSEXCH-15491 If field is line count (SYSREPC) then replace first pass value with correct value
    if oVRWField.FieldNo = LINE_COUNTER then
      s := IntToStr(ListIndex + 1);

    PrintObj := TPrintIfObj.Create;
    PrintObj.WantPrint := oVRWField.WantToPrint;

    //PR: 22/02/2011 DRillDwon info is now stored in the file and list
    PrintObj.DrillDownRec := oVRWField.DrillDownRec;
    sDrillDownKey[0] := Char(oVRWField.DrillDownRec.Offset);
    aFile.Read(sDrillDownKey[1], oVRWField.DrillDownRec.Offset);
    PrintObj.DrillDownKey := sDrillDownKey;

    AList.AddObject(s, PrintObj);
  end;

  Result := AList;
end;

procedure TRecordPosition.AddField(var aFile : TFileStream; const Value : ShortString; bPrint : Boolean;
                                   iFileNo : Byte; iVarNo : Integer; CalcField : Boolean);
//Writes a string value out to the file and adds the length of the string to the list.
var
  oVRWField : TVRWField;

  //PR: 22/02/2011 Need to get drilldown info at this stage
  iLevel, iMode : Byte;
  sKey : ShortString;
  LFileNo : SmallInt;
  LIndexNO : SmallInt;
begin
  oVRWField := TVRWField.Create;
  oVRWField.Offset := Length(Value);
  oVRWField.WantToPrint := bPrint;

  //PR: 10/11/2015 ABSEXCH-15491 Include Field number
  oVRWField.FieldNo := iVarNo;

  //PR: 22/02/2011 Need to get drilldown info at this stage
//  if not CalcField then
  begin
    AddDrillDownInfo(iVarNo, iFileNo, iLevel, iMode, sKey, LFileNo, LIndexNo);
    oVRWField.DrillDownRec.FileNo := LFileNo;
    oVRWField.DrillDownRec.IndexNo := LIndexNo;
    oVRWfield.DrillDownRec.Offset := Length(sKey);
  end;

  FFields.Add(oVRWField);
  aFile.Write(Value[1], oVRWField.Offset);
//  if not CalcField then
    aFile.Write(sKey[1], oVRWField.DrillDownRec.Offset);  //Write DrillDown keystring to file.

end;

constructor TRecordPosition.Create;
begin
  inherited Create;
  FFields := TObjectList.Create;
end;

destructor TRecordPosition.Destroy;
begin
  FFields.Free;
  inherited;
end;

Initialization
  CommandPool := TBits.Create;
Finalization
  CommandPool.Free;
end. {Unit..}
