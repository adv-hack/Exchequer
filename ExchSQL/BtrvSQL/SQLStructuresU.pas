unit SQLStructuresU;
{$ALIGN 1}
interface

uses Types, Graphics, GlobVar, VarRec2U;

type
  TTransactionNotesRec = record
    NoteFolio :  LongInt;
    NType     :  Char;
    NoteDate  :  String[8];
    NoteAlarm :  String[8];
    LineNo    :  LongInt;
    NoteLine  :  String[100]; { Note Line }
    NoteUser  :  String[10];  { Note owner }
    TmpImpCode:  String[16];  { TmpHolding code for import }
    ShowDate  :  Boolean;
    RepeatNo  :  SmallInt;    { Repeat every X days}
    NoteFor   :  String[10];  { Note For Filter }
  end;
  PTransactionNotesRec = ^TTransactionNotesRec;

  TFinancialMatchingRec =  record
    DocCode   :  String[9];
    PayRef    :  String[9];
    SettledVal:  Double;         {* Level 0 settled *}
    OwnCVal   :  Double;         {* Own currency settled *}
    MCurrency :  Byte;
    MatchType :  Char;           {* A for Accounting based, O for ,orders *}
    OldAltRef :  String[10];     {* Alt YourRef *}
    RCurrency :  Byte;           {* Currency of Receipt Import mode *}
    RecOwnCVal:  Double;         {* Own Currency Value of Receipt Import mode *}
    AltRef    :  String[20];     {* Alt YourRef *}
  end;
  PFinancialMatchingRec = ^TFinancialMatchingRec;

  TCustomerDiscountRec = record
    CustCode: string[6];
    StockCode: string[16];
    Currency: Byte;
    DiscountType: Char;
    Price: Double;
    Band: Char;
    DiscountP: Double;
    DiscountA: Double;
    MarkUp: Double;
    UseDates: Boolean;
    StartDate: LongDate;
    EndDate: LongDate;
    QtyBreakFolio: LongInt; // CJS 2012-02-24 - v6.10 - ABSEXCH-9795
  end;
  PCustomerDiscountRec = ^TCustomerDiscountRec;

  TCustomerStockAnalysisRec = record
    csIndex      : String[26];
    csCustCode   : String[10];
    csStockCode  : String[20];
    csStkFolio   : LongInt;
    csSOQty      : Double;
    csLastDate   : LongDate;
    csLineNo     : LongInt;
    csLastPrice  : Double;
    csLPCurr     : Byte;
    csJobCode    : String[10];
    csJACode     : String[10];
    csLocCode    : String[5];
    csNomCode    : LongInt;
    csCostCentre : String[3];
    csDepartment : String[3];
    csQty        : Double;
    csNetValue   : Double;
    csDiscount   : Double;
    csVATCode    : Char;
    csCost       : Double;
    csDesc       : Array[1..6] of String[35];
    csVAT        : Double;
    csPrxPack    : Boolean;
    csQtyPack    : Double;
    csQtyMul     : Double;
    csDiscCh     : Char;
    csEntered    : Boolean;
    csUsePack    : Boolean;
    csShowCase   : Boolean;
    csLineType   : Byte;
    csPriceMulX  : Double;
    csVATIncFlg  : Char;
  end;
  PCustomerStockAnalysisRec = ^TCustomerStockAnalysisRec;

  TFiFoRec = record
    FIFOStkFolio : LongInt;    { Stock Link }
    FIFODocAbsNo : LongInt;    { Doc ABS Line No. }
    FIFODate     : LongDate;   { Date of Costing }
    FIFOQtyLeft  : Double;     { Amount Left }
    FIFODocRef   : String[10]; { Doc Link }
    FIFOQty      : Double;
    FIFOCost     : Double;     { Doc Currency Cost }
    FIFOCurr     : Byte;       { Currency of FIFO }
    FIFOCust     : String[10]; { CustCode }
    FIFOMLoc     : String[10]; { Link to Location }
    FIFOCRates   : CurrTypes;  { Currency rates of Fifo Entry }
    FIFOUseORate : Byte;       { Forces the conversion routines to apply non tri rules }
    FIFOTriR     : TriCurType; { Details of Main Triangulation }
  end;
  PFiFoRec = ^TFiFoRec;

  TSerialBatchRec = record
    SerialNo      : String[20];   { Actual Serial No. }
    BatchNo       : String[10];   { Seperate Batch No.}
    InDoc         : String[10];   { Input Doc No. }
    OutDoc        : String[10];   { Output Doc No.}
    Sold          : Boolean;      { Sold Status }
    DateIn        : LongDate;     { Date In }
    CostPrice     : Double;       { CostPrice}
    SalePrice     : Double;       { Selling Price }
    StockFolio    : LongInt;      { StkFolio }
    DateOut       : LongDate;     { Date Sold }
    SoldLine      : LongInt;      { ABS Line No of Doc Sold }
    CostCurrency  : Byte;         { Currency Cost Price }
    SalesCurrency : Byte;         {     "    Sell Price }
    BuyLine       : LongInt;      { Purchase Line       }
    BatchRec      : Boolean;      { Indicates this is solely a batch record }
    BuyQty        : Double;       { Original Batch Qty }
    QtyUsed       : Double;       { Amount Used from  Batch }
    BatchChild    : Boolean;      { Auto generated item to record sale doc for batch }
    InMLoc        : String[10];   { Location Filter }
    OutMLoc       : String[10];   { Location Filter }
    SerCRates     : CurrTypes;    { Cost Rate }
    InOrdDoc      : String[10];   { Original In Order}
    OutOrdDoc     : String[10];   { Original Out Order }
    InOrdLine     : LongInt;      { Line Number of original order }
    OutOrdLine    : LongInt;      { Line Number of original order }
    NLineCount    : LongInt;      { Notes Line Count }
    NoteFolio     : LongInt;      { Unique Folio to attach notes to }
    DateUseX      : LongDate;     { Use by Date }
    SUseORate     : Byte;         { Forces the conversion routines to apply non tri rules *}
    SerTriR       : TriCurType;   { Details of Main Triangulation }
    ChildNFolio   : LongInt;      { Child Batch link back to exact parent }
    InBinCode     : String[10];
    ReturnSNo     : Boolean;      { Flagged as came back via returns module }
    BatchRetQty   : Double;       { Amount of batch child returned }
    RetDoc        : String[10];   { Sales Return Reference for match }
    RetDocLine    : LongInt;      { Line No. of Return }
  end;
  PSerialBatchRec = ^TSerialBatchRec;

  TWindowSettingRec = record
    BkgColor      : TColor;      { General Background Colour }
    FontName      : String[32];  { Font Name }
    FontSize      : Integer;     { Font Size }
    FontColor     : TColor;      { Font Color }
    FontStyle     : TFontStyles;
    FontPitch     : TFontPitch;
    FontHeight    : Integer;
    LastColOrder  : LongInt;
    Position      : TRect;       { Last coordinates }
    FormID        : Char;
    ComponentName : String[62];  { Component name }
    IndexedComponentName: string[9];
    UserName      : String[10];  { Login code }
    HighLight     : TColor;      { Highlighted bar colors }
    HighText      : TColor;      { Highlighted bar colors }
  end;
  PWindowSettingRec = ^TWindowSettingRec;

  TLocationRec = record
    loCode      : String[3];   { Master Location Code                   }
    loName      : String[45];   {    "       "    Name                  }
    loAddr      : AddrTyp;      { Address (array[1..5] of string[30])   }
    loTel       : String[25];   { Tel                                   }
    loFax       : String[25];   { Fax                                   }
    loEmail     : String[100];  { email                                 }
    loModem     : String[25];   { modem number                          }
    loContact   : String[30];   { Contact                               }
    loCurrency  : Byte;         { Def Currency                          }
    loArea      : String[5];    { Report Area                           }
    loRep       : String[5];    { Report Rep                            }
    loTag       : Boolean;      { Tagged                                }
    loNominal   : DefMLNomType; { Def Nom (array[1..10] of LongInt)     }
    loCCDep     : CCDepType;    { Def CC Dep (array[1..2] of string[3]) }
    loUsePrice  : Boolean;      { Override Price                        }
    loUseNom    : Boolean;      { Override Noms                         }
    loUseCCDep  : Boolean;      { Override CCDep                        }
    loUseSupp   : Boolean;      { Override Supplier                     }
    loUseBinLoc : Boolean;      { Override Bin Loc                      }
    loNLineCount: LongInt;      { Notes Line Count                      }
    loUseCPrice : Boolean;      { Use Locations own cost price          }
    loUseRPrice : Boolean;      { Use Locations own re-order price      }
    loWOPWIPGL  : LongInt;      { Override WIP GL                       }
    loReturnGL  : LongInt;      { Location Return GL                    }
    loPReturnGL : LongInt;      { Location Purchase Return              }
  end;
  PLocationRec = ^TLocationRec;

  TStockLocationRec = record
    lsStkCode      :  String[20];   { Stock Code }
    lsStkFolio     :  LongInt;      {    "  Folio }
    lsLocCode      :  String[10];   { Loc Code }
    lsQtyInStock   :  Double;       { Actual Stock }
    lsQtyOnOrder   :  Double;       { OnOrder }
    lsQtyAlloc     :  Double;       { Allocated }
    lsQtyPicked    :  Double;       { Picked }
    lsQtyMin       :  Double;       { Min    }
    lsQtyMax       :  Double;       { Max    }
    lsQtyFreeze    :  Double;       { Freeze Qty }
    lsRoQty        :  Double;       { Re-Order Qty }
    lsRoDate       :  LongDate;     { Re-Order Date }
    lsRoCCDep      :  CCDepType;    { Re-Order CC/Dep }
    lsCCDep        :  CCDepType;    { Default CC/Dep }
    lsBinLoc       :  String[10];   { Bin Location }
    lsSaleBands    :  SaleBandAry;  { Pricing }
    lsRoPrice      :  Double;       { Re-Order Price }
    lsRoCurrency   :  Byte;         {     "    Currency }
    lsCostPrice    :  Double;       { Last Cost Price }
    lsPCurrency    :  Byte;         {     "     Currency }
    lsDefNom       :  DefMLNomType;
    lsStkFlg       :  Boolean;      { In Stk Take }
    lsMinFlg       :  Boolean;      { Below min Flg }
    lsTempSupp     :  String[10];   { Temp Supplier }
    lsSupplier     :  String[10];   { Main Suppplier }
    lsLastUsed     :  LongDate;     { Last used rec }
    lsQtyPosted    :  Double;       { Posted loc qty }
    lsQtyTake      :  Double;       { Stock Take Qty }
    lsROFlg        :  Boolean;      { RO Flg }
    lsLastTime     :  String[6];    { Time last used }
    lsQtyAllocWOR  :  Double;       { Allocated to WOR }
    lsQtyIssueWOR  :  Double;       { Issued to WOR }
    lsQtyPickWOR   :  Double;       { Picked on WOR }
    lsWOPWIPGL     :  LongInt;      { WIPGLCode }
    lsSWarranty    :  Byte;         { Standard warranty count in months or years }
    lsSWarrantyType:  Byte;         { Standard warranty Type 0 months or 1 years }
    lsMWarranty    :  Byte;         { Manufacturers warranty count in months or years }
    lsMWarrantyType:  Byte;         { Manufacturers warranty Type 0 months or 1 years }
    lsQtyPReturn   :  Double;       { Qty Returned on PRN }
    lsReturnGL     :  LongInt;      { G/L code used for Return G/L movement }
    lsReStockPcnt  :  Double;       { ReStock pcnt auto applied as an additional cost }
    lsReStockGL    :  LongInt;      { ReStock G/L code on auto line }
    lsBOMDedComp   :  Boolean;      { Override behaviour of deduct comp if no stock }
    lsQtyReturn    :  Double;       { Sales Return Qty }
    lsPReturnGL    :  LongInt;      { G/L code used for Purchase Return G/L movement }
  end;
  PStockLocationRec = ^TStockLocationRec;

  TAllocWizardSessionRec = record
    arcCustSupp     : Char;
    arcBankNom      : LongInt;      { Bank Nominal }
    arcCtrlNom      : LongInt;      { MDC Control G/L }
    arcPayCurr      : Byte;         { Pay In Currency }
    arcInvCurr      : Byte;         { Filter Ledger Currency }
    arcCCDep        : CCDepType;    { Default CC/DEP }
    arcSortBy       : Byte;         { Sort ledger by }
    arcAutoTotal    : Boolean;      { Indicates that list will be calculating total automatically based on allocations }
    arcSDDaysOver   : SmallInt;     { Days we will go over settlemnt discount }
    arcFromTrans    : Boolean;      { Are we allocating against an existing transaction }
    arcOldYourRef   : String[10];
    arcChequeNo2    : String[10];
    arcForceNew     : Boolean;      { Used to reset allocation database when an incomplete allocation is restored }
    arcSort2By      : Byte;         { Sort ledger by. }
    arcTotalOwn     : Double;       { Total allocated in own currency }
    arcTransValue   : Double;       { Total value of amount to be allocated }
    arcTagCount     : LongInt;      { Total No. of Items in List }
    arcTagRunDate   : LongDate;     { Date of Payment }
    arcTagRunYr     : Byte;         { Year of Payment }
    arcTagRunPr     : Byte;         { Period of Payment }
    arcSRCPIRef     : String[10];   { Paying In Ref }
    arcIncSDisc     : Boolean;      { Include settlement discount in calcualtion }
    arcTotal        : Double;       { Total allocated }
    arcVariance     : Double;       { Total Variance available }
    arcSettleD      : Double;       { Amount of settlement discount }
    arcTransDate    : LongDate;     { Transaction date }
    arcUD1          : String[30];   { User defined fields 1-4 }
    arcUD2          : String[30];
    arcUD3          : String[30];
    arcUD4          : String[30];
    arcJobCode      : String[10];   { Link to project code }
    arcAnalCode     : String[10];   { Link to analysis code }
    arcPayDetails   : AddrTyp;      { Additional payment details }
    arcIncVar       : Boolean;      { Allow over allocation for variance }
    arcOurRef       : String[10];   { Link to ourref if called from ledger }
    arcCxRate       : CurrTypes;    { Exchange rate of transaction }
    arcOpoName      : String[10];   { Login current owner name }
    arcStartDate    : LongDate;     { Date allocation commenced }
    arcStartTime    : String[6];    { Time allocation commenced }
    arcWinLogIn     : String[50];   { Windows login }
    arcLocked       : Byte;         { Flag to indicate allocation in progress by another user (2), or stored incomplete (1) }
    arcSalesMode    : Boolean;      { Cust or Supp }
    arcCustCode     : String[10];   { Account Code }
    arcUseOSNdx     : Boolean;      { Use new index }
    arcOwnTransValue: Double;       { Total of transaction in own currency }
    arcOwnSettleD   : Double;       { Total of settlement discount in own currency }
    arcFinVar       : Boolean;      { Take any surplus as variance }
    arcFinSetD      : Boolean;      { Take any surplus as settlement Discount }
    arcSortD        : Boolean;      { Sort Descending }
    arcAllocFull    : Boolean;      { Indicates we are allocating all of the receipt to avoid any rounding }
    arcCheckFail    : Boolean;      { Set when check has discovered altered tagged entries }
    arcCharge1GL    : LongInt;      { Additional charges split }
    arcCharge2GL    : LongInt;      { Additional charges split }
    arcCharge1Amt   : Double;       { Additional charges split }
    arcCharge2Amt   : Double;       { Additional charges split }
    arcYourRef      : String[20];
    arcUD5          : String[30];   { User-defined fields 5 - 10 }
    arcUD6          : String[30];
    arcUD7          : String[30];
    arcUD8          : String[30];
    arcUD9          : String[30];
    arcUD10         : String[30];
    arcUsePPD       : Boolean;
  end;
  PAllocWizardSessionRec = ^TAllocWizardSessionRec;

  TJobBudgetRec = record
    AnalysisCode :  String[10];   { Link to Analysis Record }
    HistFolio    :  LongInt;      { Analysis Folio Number for History }
    JobCode      :  String[10];   { Parent JobCode }
    StockCode    :  String[20];   { Optional Stock Code}
    BType        :  Byte;         { Relates to R/O/L/M }
    ReCharge     :  Boolean;      { Charge Item On }
    OverCost     :  Double;       { Overhead on Cost }
    UnitPrice    :  Double;       { Charging Price }
    BoQty        :  Double;       { Original Qty }
    BRQty        :  Double;       { RevisedQty }
    BoValue      :  Double;       { Original Value }
    BRValue      :  Double;       { Revised Value }
    CurrBudg     :  Byte;         { Budget Currency. Not used, always 0 in database. }
    PayRMode     :  Boolean;      { PayRate Mode }
    CurrPType    :  Byte;         { PayRate Currency }
    AnalHed      :  Byte;         { Major Heading Type 1-10 }
    OrigValuation:  Double;       { Initial valuation }
    RevValuation :  Double;       { Revised valaution }
    JBUpliftP    :  Double;       { Uplift override }
    JAPcntApp    :  Double;       { % of budget to be applied for on next valuation }
    JABBasis     :  Byte;         { Basis of valuation. 0 = incremental. 1 = Gross/YTD }
    JBudgetCurr  :  Byte;         { Budget Currency of Original and Revised budgets }
  end;
  PJobBudgetRec = ^TJobBudgetRec;

implementation

end.
