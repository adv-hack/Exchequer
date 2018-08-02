unit BTSupU3;

{$ALIGN 1}

interface

Uses
  Messages,
  Graphics,
  RPDevice,
  RPDefine,
  GlobVar,
  {$IFNDEF R_W}
    {$IFNDEF COMP}
    {$IFNDEF WCA}
    {$IFNDEF EBAD}
    {$IFNDEF ENSECR}
        GlobType,
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
  {$ENDIF}
  VARRec2U,
  VarConst;


type
  // MH 02/10/2013 MRD1.1.27: Added report filter on account types
  TReportIncludeAccountTypes = (atCustomersAndConsumers=0, atCustomersOnly=1, atConsumersOnly=2);

  // CJS 2014-03-03 - ABSEXCH-15076 - Irish VAT EC Services
  // Types for use by TdExLocal and VATRepParam
  TECServiceValueType = (ecvNet, ecvVAT);
  TECServiceTotalType = (ectPurchases, ectSales);
  TECServiceTotals = array[ectPurchases..ectSales] of array[ecvNet..ecvVAT] of Double;

  NumSet          =  Set of byte;
  TReturnCtrlRec  =  Record
                       Pass2Parent,
                       ShowOnly,
                       ShowSome,
                       DisplayxParent,
                       AllowAnyField,
                       ManualClose,
                       InFindLoop      :  Boolean;
                       ActiveFindPage,
                       SearchMode      :  Byte;
                       SearchPath      :  SmallInt;
                       RecMainKey,
                       SearchKey       :  Str255;
                       MessageReturn   :  TMessage;
                       DontHide        :  NumSet;
                     end;

  TSBSMsgEvent   =  function (Sender  :  TObject;
                        Const SMode   :  Byte;
                        Const SMsg    :  ShortString)     :  Boolean of Object;

  TSBSPrintEvent   =  function (Sender  :  TObject;
                          Const SMode,
                                RMode   :  LongInt)  :  Boolean of Object;


  TSBSMoveEvent   =  function (Sender  :  TObject;
                         Const IdMode,
                               IdNo,
                               MoveX   :  LongInt)  :  Boolean of Object;

  TPrintParamPtr  =  ^TPrintParam;
  
  TPrintParam     =  Record
                       DelSwapFile,
                       PBatch     :  Boolean;

                       {Copies,
                       PrinterNo  :  Integer;}

                       PDevRec    :  TSBSPrintSetupInfo;
                       RepCaption,
                       SwapFileName,
                       FileName   :  Str255;

                       UFont      :  TFont;
                       Orient     :  TOrientation;

                       eCommLink  :  Pointer;        {* If we have anything to send via ecommModule, pick up list here *}
                     end;


  DueRepPtr     =  ^DueRepParam;

  DueRepParam   =  Record
                     Filt      :  Char;

                     CustTotal,
                     RepTotal,
                     PostTotal :  DrCrType;


                     MDCAged,
                     GlobAged,
                     CustAged,
                     RepAged,
                     PostAged  :  AgedTyp;

                     SDiscTot,
                     SAvailTot,
                     PostedBal :  Real;

                     GrandPostedBal,
                     ThisPostedBal,
                     ThisInvBal:  Double;

                     KeepCust,
                     ACFilt,
                     LastCust  :  Str10;

                     LastCtrlNom,
                     RepCtrlNom,
                     CtrlNomFilt
                               :  LongInt;

                     DueLimit  :  LongDate;

                     RCCDep    :  CCDepType;

                     RCr,
                     RPr,
                     RYr,
                     RTxCr,
                     RAgeBy    :  Byte;

                     RAgeInt   :  Integer;


                     PrevMode,
                     Summary,
                     IncSDisc,
                     OSOnly    :  Boolean;

                     AgeTit    :  AgedTitType;

                     //PR: 22/10/2009 Added to indicate that the report should print its parameters.
                     PrintParameters : Boolean;

                     // MH 02/10/2013 MRD1.1.29: Added report filter on account types
                     IncludeAccountTypes : TReportIncludeAccountTypes;
                   end;

 {$IFDEF R_W}
   {$DEFINE USE_LONGINT}
 {$ENDIF}
 {$IFDEF COMP}
   {$DEFINE USE_LONGINT}
 {$ENDIF}
 {$IFDEF WCA}
   {$DEFINE USE_LONGINT}
 {$ENDIF}
 {$IFDEF EBAD}
   {$DEFINE USE_LONGINT}
 {$ENDIF}
 {$IFDEF ENSECR}
   {$DEFINE USE_LONGINT}
 {$ENDIF}

 {$IFDEF USE_LONGINT}
   StaCtrlRecType  =  LongInt;
 {$ELSE}
   StaCtrlRecType  =  BatchRepInfoType;
 {$ENDIF}
 {$UNDEF USE_LONGINT}

(* Code modified to that immediately above
  {$IFNDEF RW}
    {$IFNDEF COMP}
      StaCtrlRecType  =  BatchRepInfoType;
    {$ELSE}
      { Multi-Company Manager }
      StaCtrlRecType  =  LongInt;
    {$ENDIF}
  {$ELSE}
    { Report Writer }
    StaCtrlRecType  =  LongInt;
  {$ENDIF} *)

  {StaCtrlRecType  =  Record

                       StaAgedDate  :  LongDate;

                       ShowMonthDoc,
                       SepCr,
                       UseScr,
                       FoundSta     :  Boolean;

                       RepPtr       :  Pointer;

                       ThisCr       :  Byte;

                       CrFlags      :  Array[0..CurrencyType] of Boolean;

                       SFName       :  Str255;
                     end;}


      StaCtrlRec =    ^StaCtrlRecType;


  CustRepParam  =  Record
		     Filt    :  Char;
                     FiltSet :  CharSet;
                     StaStart,
                     StaEnd  :  Str30;

                     AgeDate :  LongDate;

                     ShowOS,
                     StSepCr,
                     StkLabXComp
                             :  Boolean;

                     AccTFilt:  Str10;

                     DebtLevel,
                     NonIncStat,
                     SFiltBy,
                     RCr,
                     SAgeBy  :  Byte;

                     SBalIncF
                             :  Byte;

                     SAgeInt :  Integer;

                     StkLabFolio,
                     StkLabLineNo,
                     StkLabCopies,
                     StkLabQtyMode
                             :  LongInt;


                     ScrPtr  :  StaCtrlRec;

                     // MH 29/10/2013 v7.X MRD1.1: Added report filter on account types
                     IncludeAccountTypes : TReportIncludeAccountTypes;
		   end;

  CustRepPtr    =  ^CustRepParam;


  { ============== Posting Summary Record ================ }

  // CJS - 18/04/2011: ABSEXCH-11252 - Posting Run performance enhancements
  PostingSummaryRec = record
    DocumentType: DocTypes;
    Totals: Array[1..3] of Real;
  end;

  PostingSummaryArray =  Array[False..True, 1..MaxPostingAnalysisTypes] of PostingSummaryRec;





  PostRepPtr    =  ^PostRepParam;

  PostRepParam  =  Record
                     CustTotal,
                     RepTotal  :  DrCrDType;
                     LastCust  :  Str10;
                     DueLimit  :  LongDate;

                     AccrualMode:  Byte;
                     PostJCDBk,
                     NoIDCheck,
                     Summary,
                     AllRuns,
                     IsReRun   :  Boolean;
                     LastRunNo :  LongInt;
                     IncDocFilt,
                     DayBkFlt  :  DocSetType;
                     PParam    :  TPrintParam;
                     PostSummary: PostingSummaryArray;
                     AfterRevaluation
                                : Boolean; //PR: 24/05/2016 ABSEXCH-17450 Indicates posting run after a revaluation
                   end;


  MoveRepPtr    =  ^MoveRepParam;

  MoveRepParam  =  Record
                     LastRunNo,
                     MoveNCode,
                     NewNCat,
                     WasNCat    :   LongInt;
                     NewNType   :   Char;

                     MoveSCode,
                     NewSCode,
                     WasSGrp,
                     NewSGrp    :   Str20;

                     MoveMode   :   Byte;

                     MoveNom,
                     GrpNom     :  NominalRec;

                     WasViewNo:  LongInt;

                     GrpNomView,
                     MoveNomView  :  NomViewRec;

                     MoveStk,
                     GrpStk     :  StockRec;

                     MoveJob,
                     GrpJob     :  JobRecType;

                     MoveCust   :  CustRec;
                     CustMode   :  Boolean;
                   end;


  DocRepPtr     =  ^DocRepParam;

  DocRepParam   =  Record

                   ReconCode,
                   NomToo,
                   LastNom,
                   FolStart,
                   FolEnd    :  LongInt;

                   LastCust,
                   CustFilt  :  Str10;

                   StartBal,
                   RunStartBal,
                   StatTotal,
                   ClearedTotal,
                   NomBal,
                   RepTotal  :  Double;

                   SDate,
                   EDate,
                   DueLimit  :  LongDate;

                   CustTot,
                   RepTotals :  Totals;

                   CommitMode,
                   RCr,RTxCr,
                   RYr,RPr,
                   RYr2,RPr2 :  Byte;

                   RCrDr,
                   DCrDr     :  DrCrDType;

                   RCCDep    :  CCDepType;

                   QuoteMode,
                   Summary,
                   ShowPIMode,
                   CCDpTag,
                   ByDate,
                   ShowOCbal :  Boolean;

                   LastDoc   :  DocTypes;

                   DayBkFlt  :  DocSetType;

                   LastDocType,
                   DocWanted :  Str5;

                   //PR: 22/10/2009 Added to indicate that the report should print its parameters.
                   PrintParameters : Boolean;

                   // MH 02/10/2013 MRD1.1.29: Added report filter on account types
                   IncludeAccountTypes : TReportIncludeAccountTypes;
                 end;


    VATAry        =  Array[VATType] of Real;

    IONetTyp      =  Array[False..True,1..2] of Real;

    TIRTBox       =  Record
                       IncSet    :  Set of VATType;
                       BoxTotal  :  Double;
                     end; {Rec..}

    TIRTBoxAry    =  Array[1..2,1..2] of TIRTBox;

    TIRVInput     =  Record
                       TCodes   :  Array[1..3] of String[35];
                     end;



    VATRepPtr     =  ^VATRepParam;

    VATRepParam   =  Record
                     VATStartD,
                     VATEndD   :  LongDate;

                     RepTotals,
                     OPrAnal,
                     SplitTotals,
                     OPSplitTotals,
                     RateTotals,
                     OPRateTotals,
                     IPrGoodsAnal,
                     IPrVATAnal:  VATAry;


                     VATTot,
                     GoodsTot,
                     NoClaimOVAT,
                     CashAccCS
                               :  Real;

                     OPrTotals,
                     EECTotals,
                     EECAqui   :  IONetTyp;

                     IPrTotals,
                     EPrTotals :  Array[False..True,1..2,VATType] of Real;

                     // CJS 2014-03-03 - ABSEXCH-15076 - Irish VAT EC Services
                     RepECServiceTotals: TECServiceTotals;

                     // CJS 2015-05-28 - ABSEXCH-16260 - VAT100 report Box 8
                     FreeOfChargeTotals: Double;

                     VISYr,VISPr,
                     VYr,VPr   :  Byte;


                     VATScheme,
                     AquiCode,
                     LastDocType,
                     VATCode1,
                     VATCode2,
                     RevChargeFlag
                               :  Char;

                     CurrentVATCode,
                     CurrentSection,
                     LastSection : Char;

                     AutoCloseVAT,
                     Summary   :  Boolean;

                     ThisVRate,
                     LastVRate :  VATType;

                     IRVATInp  :  TIRVInput;

         // ABSEXCH-13793. 13/05/2013. Add option to export VAT Return to XML format
                     WantXMLOutput : boolean;
                     XMLOutputPath : string;
         // ABSEXCH-14371. 25/07/2013. Add option to submit VAT 100 online.
                     XMLOutputFile : string;
		   end;


    CVATRepPtr     =  ^CVATRepParam;

    CVATRepParam   =  Record

                      PrintTri,
                      PrintServices,
                      CloseCIS,
                      AllowEditCIS,
                      HasCISNdx :  Boolean;

                      VATStartD,
                      VATEndD   :  LongDate;

                      Linepp,
                      VLineNo,
                      QNo,QYr,
                      TotPages,
                      TotLines  :  LongInt;

                      RepTotals :  DrCrType;

                      CISGMode,
                      CISSMode,
                      VSYr,VSPr,
                      VYr,VPr   :  Byte;

                      VATTot,
                      GoodsTot  :  Real;

                      VATChk    :  Char;

                      EDIHedTit :  Str80;

                      RepTot    :  Real;
                      MatTot,
                      GrossTot,
                      TriTot
                                :  Double;

                      VType     :  String[2];
                      VSig      :  String[35];
                      PParam    :  TPrintParam;
		    end;

  TAggSSD       =  Record
                     CommodCode  :  Str10;
                     DelivTerms  :  Str5;
                     TransNat    :  Integer;
                     TransMode   :  Byte;
                     CC          :  Str5;
                     COrig       :  Str5;
                     UnitSupp    :  Str10;
                     ConsCount   :  LongInt;

                   end;


  ISVATRepPtr    =  ^ISVATRepParam;

  ISVATRepParam  =  Record
                     SDate,
                     EDate   :  LongDate;

                     VPr,VYr :  Integer;

                     TotITem,
                     ItemRun :  LongInt;

                     VATChk  :  Char;

                     Summary :  Boolean;

                     LastCommod,
                     ThisCommod  :  Str255;

                     AggCommod
                             :  TAggSSD;

                     RepTot,
                     AggTot  :  AgedTyp;

		   end;

  PFormRepPtr    =  ^PFormRepParam;

  PFormRepParam  =  Record
                      PFnum,
                      PKeypath,
                      Fnum,
                      Keypath    :  Integer;
                      RCr,
                      DefMode,
                      SFiltX,
                      ReportMode :  Byte;

                      AccSort,
                      UseOwnForm,
                      UsePaperLess,
                      UseCustomFilter,
                      UseCustomForm,
                      BatchStart :  Boolean;

                      KeyRef,
                      PKeyRef    :  Str255;

                      RForm      :  Str10;

                      PParam     :  TPrintParam;

                      CStart,
                      CEnd,
                      CustFilt   :  Str10;

                      CoKey      :  Str255;

                      SDate,
                      EDate      :  LongDate;

                      Descr      : ShortString;
                      WinTitle   : ShortString;
                      AddBatchInfo
                                 : StaCtrlRecType;
                    end;


  BatchPRepPtr    =  ^BatchPRepParam;

  BatchPRepParam  =  Record

                       ReconCode,
                       NomToo,
                       LastNom   :  LongInt;

                       LastCust,
                       CustFilt  :  Str10;

                       BSTot,
                       RepTot,
                       SDiscTot,
                       PayTot  :  Real;


                       CustTot,
                       RepTotal  :  Totals;

                       RCr,RTxCr,
                       RYr,RPr,
                       RYr2,RPr2 :  Byte;

                       RCrDr,
                       DCrDr     :  DrCrType;

                       RCCDep    :  CCDepType;

                       BACSCTPtr :  Pointer;
                       SPMode,
                       Summary,
                       ShowPIMode,
                       ShowOCbal :  Boolean;

                       // MH 17/08/2015 2015-R1 ABSEXCH-16755: Added PPD Columns
                       PPDTot    : Double;
                     end;


  PUnPostPtr    =  ^PUnPostParam;
                                                                
  PUnPostParam  =  Record
                     UnPostPr,UnPostYr
                       :  Byte;

                     UnResetVAT,
                     RecalcVATPr
                       :  Boolean;

                     FromRunUP,
                     ToRunUP
                       :  LongInt;  {From/Too run number for unpist by run number}
                   end;
  {$IFDEF STK}


    Const
      MaxNoStkTots  =  16;

    Type

      StkRepAry  =  Array[1..MaxNoStkTots] of Real;

      { ============= Stock Report Control =========== }

      StkRepRecPtr  =  ^StkRepRec;

      StkRepRec  =  Record
                      Mode,
                      Fnum,Keypth  :  Integer;

                      FCr,FTxCR,
                      RYr,
                      PrS,PrE,
                      SubMode,
                      NoAnals      :  Byte;

                      Level,
                      RepLimit     :  LongInt;

                      Locfilt,
                      CustFilt     :  String[10];

                      LevKey,
                      PaLS,PaLE,
                      Parnt        :  String[20];

                      BandCh,
                      RepOrd       :  Char;


                      NTotals,
                      BTotals,
                      DTotals,
                      BSTotals     :  StkRepAry;


                      Ok2Print,
                      NoBotD,
                      IncludeAll,
                      HasValue,
                      ShowBudg,
                      CustMode     :  Boolean;

                      NCCDep       :  CCDepType;

                    end;


    PBrkRepPtr    =  ^PBrkRepParam;

    PBrkRepParam  =  Record
                       FGMode,
                       OrderMode,
                       SingProd:  Boolean;

                       SDate,
                       EDate   :  LongDate;

                       RepNomCode,
                       LastBSNom
                               :  LongInt;


                       RepTot,
                       CustTot,
                       ProdTot :  Totals;

                       BSOBal,
                       OBalTot,
                       CBalTot :  Double;

                       LocFilt,
                       LastCust,
                       CustFilt:  Str10;

                       LastProd,
                       StkToo  :  Str20;

                       Rcr,
                       PrF,YrF,
                       PrT,YrT,
                       RTxCr   :  Byte;

                       RCCDep  :  CCDepType;

                       //PR: 21/10/2009 Added to indicate that the report should print its parameters.
                       PrintParameters : Boolean;

                       // MH 02/10/2013 MRD1.1.27: Added report filter on account types
                       IncludeAccountTypes : TReportIncludeAccountTypes;
                     end;


    { ======================= Customer Report ======================= }


    SListRepPtr    =  ^SListRepParam;

    SListRepParam  =  Record
                       ShowQty,
                       ShowBins,
                       ShowLive
                               :  Boolean;

                       LastNomCode
                               :  LongInt;

                       LocFilt,
                       LastSupp,
                       RepValType,
                       CustFilt
                               :  Str10;

                       StkToo  :  Str20;

                       VBSTot,
                       VRepTot,
                       BSTot,
                       RepTot,
                       BQtyTot,
                       RQtyTot,
                       AgeAvQty,
                       AgeAvUP :  Double;


                       RepOrd  :  Char;

                       StkAgeDate
                               :  LongDate;
                       //PR: 21/10/2009 Added to indicate that the report should print its parameters.
                       PrintParameters : Boolean;
                     end;


    SHistRepPtr    =  ^SHistRepParam;

    SHistRepParam  =  Record

                        StkToo,
                        LastStk   :  Str20;

                        LocFilt,
                        CustFilt  :  Str10;

                        StkTot,
                        RepTotal  :  Totals;

                        RCr,RTxCr,
                        RYr,RPr,
                        RYr2,RPr2
                                  :  Byte;

                        SDate,
                        EDate     :  LongDate;


                        RCCDep    :  CCDepType;

                        Summary,
                        ShowOCbal,
                        SingProd  :  Boolean;

                        LastDoc   :  DocTypes;

                        DocWanted :  Str5;
                      end;


    KitRepPtr     =  ^KitRepParam;

    KitRepParam   =  Record
                       EDate   :  LongDate;

                       BSTot,
                       BSTotC,
                       RepTot,
                       RepTotC :  Real;

                       ShowQty,
                       ExpBOM,
                       UseFree,
                       ScanOrd :  Boolean;

                       LocFilt,
                       CustFilt,
                       LastDocNo,
                       ROrdNo  :  Str10;

                       StockFilt,
                       STCode  :  Str20;

                       SKitQty :  Real;

                       KitFolio,
                       KitLevel:  LongInt;

                       RCr     :  Byte;

                     end;


    ShortRepPtr     =  ^ShortRepParam;

    ShortRepParam   =  Record
                       LocFilt,
                       CustFilt  :  Str10;

                       LastStk   :  Str20;


                       StkTot    :  AgedTyp;

                       RCr       :  Byte;

                       AgeMode,
                       QUOMode   :  Byte;


                       RCCDep    :  CCDepType;

                       LastDoc   :  DocTypes;

                       DocWanted :  Str5;

                       AnalMode  :  Char;

                     end;


      PPickRepPtr    =  ^PPickRepParam;

      PPickRepParam  =  Record
                          MatchK     :  Str255;
                          PickRNo    :  LongInt;
                          Fnum2,
                          Keypath2   :  Integer;
                          PRMode,
                          SFiltX,
                          DefMode    :  Byte;

                          LRForm     :  Str255;
                          
                          BatchStart :  Boolean;

                          PParam     :  TPrintParam;

                          PSOPInp    :  SOPInpRec;

                        end;


    WOPRepPtr     =  ^WOPRepParam;

    WOPRepParam   =  Record
                       SDate,
                       EDate,
                       EstCompDate
                               :  LongDate;

                       HaveIssue,
                       CouldIssue,
                       CouldBuild,
                       BSTot,
                       BSTotC,
                       RepTot,
                       RepTotC :  Double;

                       UseSalesOB
                               :  Boolean;

                       LocFilt,
                       CustFilt,
                       LinkDocNo,
                       StartDocNo,
                       EndDocNo:  Str10;

                       StockFilt,
                       LastFolioStr,
                       STCode  :  Str20;

                       SKitQty :  Real;

                       LastGL,
                       LastFolio,
                       GLFilt

                               :  LongInt;

                       SortOrd,
                       FiltOrd,
                       AnalOrd,
                       RPr,RYr,
                       RPr2,RYr2,
                       TagFilt :  Byte;

                     end;

  BINRepPtr     =  ^BINRepParam;

  BINRepParam   =  Record
                     SDate,
                     EDate
                             :  LongDate;

                     BSTot,
                     BSTotC,
                     RepTot,
                     RepTotC :  Double;

                     LocFilt,
                     LastLoc,
                     LastBin,
                     OrdRef,
                     BinFilt :  Str10;

                     StockFilt,
                     LastStk,
                     STCode  :  Str20;

                     StkFolioFilt
                             :  LongInt;
                     SortOrd,
                     FiltOrd,
                     AnalOrd,
                     RPr,RYr,
                     RPr2,RYr2,
                     TagFilt :  Byte;

                     AllAccs,
                     UseDates:  Boolean;
                   end;

    RETRepPtr     =  ^RETRepParam;

    RETRepParam   =  Record
                       SDate,
                       EDate
                               :  LongDate;

                       StkTot,
                       BreakTot,
                       RepTotal  :  AgedTyp;

                       BSTot,
                       BSTotC,
                       RepTot,
                       RepTotC :  Double;

                       RepDocHed
                               :  DocTypes;
                       Summary,
                       UseSales
                               :  Boolean;

                       LocFilt,
                       CustFilt,
                       LinkDocNo,
                       LastCustStr,
                       SLocTit,
                       StartDocNo,
                       EndDocNo:  Str10;

                       StockFilt,
                       LastStkStr,
                       STCode  :  Str20;

                       LastFolio

                               :  LongInt;


                       SortOrd,
                       FiltOrd,
                       AnalOrd,
                       RPr,RYr,
                       RPr2,RYr2,
                       RCr,RTxCR,
                       TagFilt :  Byte;

                       XReasonCodes : array of Boolean;
{
                       XReasonCodes
                               :  Array[0..50] of Boolean;
}
                       XStatusCodes
                               :  Array[0..50] of Boolean;

                     end;


{$ENDIF}

{$IFDEF JC}
  JobCRep1Ptr    =  ^JobC1RepParam;

  JobC1RepParam  =  Record
                      Filt    :  Char;
                      FiltSet :  CharSet;
                      StaStart,
                      StaEnd  :  Str30;

                      LastJob,
                      JobFilt :  Str10;

                      ShowER,
                      NeedPage,
                      StkDetl,
                      QtyMode
                              :  Boolean;

                      SortOrd,
                      LastCIS,
                      RepType,
                      ExpTol  :  Byte;

                      RepSDate,
                      RepEDate:  LongDate;

                      CISCount:  Int64;

                      EDIHedTit,
                      CISFName,
                      RepKey1,
                      RepKey2 :  Str255;

                      RepKPath:  Integer;

                      TPg,TLn :  LongInt;

                      LineTot,
                      StkTot,
                      RepTotal:  Totals;

                      RCr,RTxCr,
                      RYr,RPr,
                      RYr2,RPr2
                              :  Byte;


                    end;



  JobCRep2Ptr    =  ^JobC2RepParam;

  JobC2RepParam  =  Record
                       SDate,
                       EDate
                                 :  LongDate;

                       JobToo,
                       LastJob   :  Str20;

                       JobFilt,
                       JobTFilt,
                       CustFilt  :  Str10;

                       StkTot,
                       RepTotal  :  Totals;

                       RCr,RTxCr,
                       RYr,RPr,
                       RYr2,RPr2
                                 :  Byte;


                       RCCDep    :  CCDepType;

                       SingProd,
                       ShowOCbal,
                       QtyMode,
                       Summary,
                       ByDate,
                       UnInv
                                 :  Boolean;

		     end;

  JobCRep3Ptr    =  ^JobC3RepParam;


  JobC3RepParam  =  Record

                      JobToo,
                      LastJob   :  Str20;

                      JobFilt,
                      LastCust,
                      CustFilt  :  Str10;

                      StkTot,
                      JobTot,
                      RepTotal  :  Totals;

                      RCr,RTxCr,
                      RYr,RPr,
                      RYr2,RPr2,
                      AHedFilt
                                :  Byte;


                      RCCDep    :  CCDepType;

                      SingProd,
                      ShowOCbal,
                      QtyMode,
                      Summary,
                      UnInv
                                :  Boolean;

                      RePCObjPtr
                                :  Pointer;

                    end;


    JobCRep4Ptr    =  ^JobC4RepParam;


    JCAppsTotals   =  Array[0..20] of Double;

    JCAppTotalRec  =  Record
                        RepTotal  :  JCAppsTotals;
                      end;

    JobC4RepParam  =  Record

                        JobToo,
                        QSFilt,
                        LastJob   :  Str20;

                        JobFilt,
                        LastCust,
                        EmpFilt,
                        JCTFilt,
                        JobTFilt,
                        CustFilt  :  Str10;

                        JARepTotal:  Array[0..4] of JCAppTotalRec;

                        RCr,RTxCr,
                        RYr,RPr,
                        RYr2,RPr2,
                        CertMode,
                        SortOrd
                                  :  Byte;


                        RCCDep    :  CCDepType;

                        SingProd,
                        ShowOCbal,
                        SalesMode,
                        QtyMode,
                        Summary,
                        UnInv
                                  :  Boolean;

                        SDate,
                        EDate     :  LongDate;

                        RePCObjPtr
                                  :  Pointer;

                      end;

{$ENDIF}


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


end.
