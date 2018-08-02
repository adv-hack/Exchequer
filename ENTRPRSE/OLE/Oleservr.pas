unit oleservr;

{ markd6 12:58 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, Dialogs, Forms, StrUtils, SysUtils, DB, BtrListO, ExBtTh1U,
{$WARN UNIT_DEPRECATED OFF}
  OleAuto,
{$WARN UNIT_DEPRECATED ON}
  GlobVar, VarConst, VarRec2U, OleStatU, CompInfo, AppsVals, Math, AuditNotes;

Const
  TrueInt = -1;
  FalseInt = 0;
  {ServerVer = 'b211'{4.10';}

Type
  { Enterprise OLE Server object }
  TEnterpriseServer = class(TAutoObject)
  private
    // Cache to record the results of analysing the transactions for a job
    AppsAnalCache : TApplicationsAnalysisCache;
    // Cache to record the results of analysing the line types of a transaction or group of transactions
    TransLineTypeCache : TAppValLineTypeAnalysisCache;
    JobLineTypeCache   : TAppValLineTypeAnalysisCache;
    // Flag to indicate whether or not we are recursing into SaveGLViewValue
    // routine.
    FirstPass: Boolean;

    Function    GetNominalRec (      BtrObj   : TdPostExLocalPtr;
                               Const NominalCode : LongInt) : Boolean;
    Function    GetCustRec (      BtrObj   : TdPostExLocalPtr;
                            Const CustCode : String;
                            Const IsCust   : Boolean) : Boolean;
    Function    GetStockRec (      BtrObj  : TdPostExLocalPtr;
                             Const StockId : String) : Boolean;
    Function    GetCCDepRec (      BtrObj  : TdPostExLocalPtr;
                             Const CCDepId : String;
                             Const IsCC    : Boolean) : Boolean; 
    Function    ValidateCCDeptCode (Const CompObj : TCompanyInfo;
                                    Const CCDepId : String;
                                    Const IsCC    : Boolean) : Boolean; 
    Function    GetJobRec (      BtrObj  : TdPostExLocalPtr;
                           Const JobId : String) : Boolean;
    Function    GetJobMiscRec (      BtrObj : TdPostExLocalPtr;
                               Const JAId   : String;
                               Const JAMode : Byte) : Boolean;
    Function    GetEmplRec (BtrObj   : TdPostExLocalPtr;
                            EmplCode : ShortString) : Boolean;
    Function    GetLocRec (BtrObj  : TdPostExLocalPtr;
                           LocId : String) : Boolean;
    Function    GetStkLocRec (BtrObj          : TdPostExLocalPtr;
                              CreateIfMissing : Boolean) : Boolean;
    Function    GetAltStkRec (BtrObj   : TdPostExLocalPtr;
                              StockFol : LongInt;
                              AltId    : String;
                              AccId    : String) : Boolean;
    procedure   UpdateComplist(Sender: TObject);

    Procedure   BuildDicLink (Const CompObj     : TCompanyInfo;
                              Var   DicLink     : DictLinkType;
                              Const ThePeriod,
                                    TheYear,
                                    TheCurrency : SmallInt;
                              Var   PrYrMode    : Byte);

    // Finds a specified Time-Rate record
    Function GetTimeRate (BtrObj   : TdPostExLocalPtr;
                          EmplCode : ShortString;
                          RateCode : ShortString) : Boolean;

    // Copied from x:\entrprse\r&d\WOPCT1I.PAS
    Procedure Time2Mins(Var MTime                :  LongInt;
                        Var Days,Hrs,Mins        :  Extended;
                            SetMode              :  Byte);

    { === G/L View Functions ================================================= }
    function GetGLViewRec(BtrObj: TdPostExLocalPtr; const NomViewNo: Integer;
                          const ViewCode: string): Boolean;

    //GS 31/10/2011 method for writing an audit note
    procedure WriteAuditNote(TypeOfRecord: TAuditNoteOwnerType; TypeOfModification: TAuditNoteFunction; CompObj : TCompanyInfo);
    
    //HV 26/06/2018 2017R1.1 ABSEXCH-20793: provided support for entry in anonymisation control center if user changes Account Status to from OLE.
    function SetAnonymisationStatus(var ACompObj: TCompanyInfo): Integer;

    Function SQLSaveNominalValue(CompObj    : TCompanyInfo;
                                 SetValue  : SmallInt;
                                 TheYear   : SmallInt;
                                 ThePeriod : SmallInt;
                                 TheCcy    : SmallInt;
                                 NomCode   : LongInt;
                                 CCDept    : String;
                                 NomCDType : String; {'C' / 'D' / 'N' }
                                 NewValue  : Double) : SmallInt;

    { Creates a multi-line Nominal Transfer }
    Function  AddNomLines_AutoReversing (Var Company         : String;
                                         Var TransDate       : String;
                                         Var TheYear         : SmallInt;
                                         Var ThePeriod       : SmallInt;
                                         Var TranDesc        : String;
                                         Var VATCountry      : String;
                                         Var VATFlag         : String;
                                         Var THUserFieldList : Variant;  // HM 17/06/04: Added for EntAddNOMUDFLines
                                         Var GLList          : Variant;
                                         Var DescList        : Variant;
                                         Var CurrList        : Variant;
                                         Var AmtList         : Variant;
                                         Var RateList        : Variant;
                                         Var VATCodeList     : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                         Var IncVATCodeList  : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                         Var VATAmountList   : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                         Var CCList          : Variant;
                                         Var DeptList        : Variant;
                                         Var JobList         : Variant;
                                         Var AnalList        : Variant;
                                         Var PayRefList      : Variant;
                                         Var ResetJCGL       : String;   // MH 21/04/06: 'Y'/'N'
                                         Var TLUDF1List      : Variant;  // MH 18/03/2011
                                         Var TLUDF2List      : Variant;
                                         Var TLUDF3List      : Variant;
                                         Var TLUDF4List      : Variant;
                                         Var TLUDF5List      : Variant;
                                         Var TLUDF6List      : Variant;
                                         Var TLUDF7List      : Variant;
                                         Var TLUDF8List      : Variant;
                                         Var TLUDF9List      : Variant;
                                         Var TLUDF10List     : Variant;
                                         Const AutoReversing : Boolean) : SmallInt;
  protected
  public
    Destroying : Boolean;
    BtrList    : TBtrListO;

    Constructor Create; OverRide;
    Destructor  Destroy; OverRide;

    Function    BoolToBoolInt (Const TheBool : Boolean) : Integer;
    // SSK 30/08/2016 R3 ABSEXCH-12531 : Added function to validate period
    Function  ValidatePeriod (aPeriod: SmallInt; aCompObj: TCompanyInfo) : Boolean;

  Automated
    { Returns the current exchequer version number }
    Function Version : String;

    { returns the description of the specified nominal code }
    Function GetCompanyName(Var FindCode : String;
                            Var CompName : String) : SmallInt;

    { === Nominal Budget Functions === }
    { returns the description of the specified nominal code }
    Function GetNominalName(Var Company : String;
                            Var NomCode : LongInt;
                            Var NomName : String) : SmallInt;

    { returns a value from the specified nominal code, based on }
    { the passed ValueReq                                       }
    { Modes:  1  =  Budget1                                     }
    {         2  =  Budget2                                     }
    {         3  =  Actual (balance, 5-4)                       }
    {         4  =  Debit                                       }
    {         5  =  Credit                                      }
    Function GetNominalValue(Var ValueReq  : SmallInt;
                             Var Company   : String;
                             Var TheYear   : SmallInt;
                             Var ThePeriod : SmallInt; { 0 = YTD }
                             Var TheCcy    : SmallInt;
                             Var NomCode   : LongInt;
                             Var NomCC     : String;
                             Var NomDept   : String;
                             Var NomCDType : String;  {'C' / 'D' / 'N' }
                             Var NomValue  : Double;
                             Var Commited  : SmallInt) : SmallInt;
    { Saves the passed value to the specified nominal code, based }
    { on the passed SetValue                                      }
    { Modes:  1  =  Budget1                                       }
    {         2  =  Budget2                                       }
    Function SaveNominalValue(Var SetValue  : SmallInt;
                              Var Company   : String;
                              Var TheYear   : SmallInt;
                              Var ThePeriod : SmallInt;
                              Var TheCcy    : SmallInt;
                              Var NomCode   : LongInt;
                              Var NomCC     : String;
                              Var NomDept   : String;
                              Var NomCDType : String; {'C' / 'D' / 'N' }
                              Var NewValue  : Double) : SmallInt;

    { Creates a Nominal Transfer between FromGL and ToGL for NewValue}
    Function  AddNomTransfer  (Var Company    : String;
                               Var TheYear    : SmallInt;
                               Var ThePeriod  : SmallInt;
                               Var TheCcy     : SmallInt;
                               Var FromGL     : LongInt;
                               Var ToGL       : LongInt;
                               Var CostCentre : String;
                               Var Dept       : String;
                               Var JobCode    : String;
                               Var AnalCode   : String;
                               Var Descr      : String;
                               Var NewValue   : Double) : SmallInt;


    { === Customer function === }
    { Returns a customer value based on ValueReq }
    { ValueReq: 0 = Balance     }
    {           1 = Net Sales   }
    {           2 = Costs       }
    {           3 = Margin      }
    {           4 = Acc Debit   }
    {           5 = Acc Credit  }
    {           6 = Budget      }
    Function GetCustValue(Var ValueReq  : SmallInt;
                          Var Company   : String;
                          Var TheYear   : SmallInt;
                          Var ThePeriod : SmallInt;
                          Var CustCode  : String;
                          Var CustValue : Double) : SmallInt;
    { Sets a customer value  }
    { ValueReq: 0 = Budget   }
    Function SaveCustValue(Var SetValue  : SmallInt;
                           Var Company   : String;
                           Var TheYear   : SmallInt;
                           Var ThePeriod : SmallInt;
                           Var CustCode  : String;
                           Var NewValue  : Double) : SmallInt;

    { === Supplier functions === }
    { Returns a supplier value based on ValueReq }
    { ValueReq: 0 = Balance     }
    {           1 = Net Sales   }
    {           2 = Costs       }
    {           3 = Margin      }
    {           4 = Acc Debit   }
    {           5 = Acc Credit  }
    {           6 = Budget      }
    Function GetSuppValue(Var ValueReq  : SmallInt;
                          Var Company   : String;
                          Var TheYear   : SmallInt;
                          Var ThePeriod : SmallInt;
                          Var SuppCode  : String;
                          Var SuppValue : Double) : SmallInt;
    { Sets a supplier value  }
    { ValueReq: 0 = Budget   }
    Function SaveSuppValue(Var SetValue  : SmallInt;
                           Var Company   : String;
                           Var TheYear   : SmallInt;
                           Var ThePeriod : SmallInt;
                           Var SuppCode  : String;
                           Var NewValue  : Double) : SmallInt;

    { Stock functions }
    { Returns a string from the stock item, identified by MiscStrNo }
    Function GetStockMiscStr (Var Company   : String;
                              Var StockId   : String;
                              Var LocCode   : String;
                              Var MiscStrNo : SmallInt;
                              Var MiscStr   : String) : SmallInt;

    { Saves a string into the specified stock item }
    Function SaveStockMiscStr (Var Company   : String;
                               Var StockId   : String;
                               Var LocCode   : String;
                               Var MiscStrNo : SmallInt;
                               Var NewStr    : String) : SmallInt;

    { Returns an integer from the stock item, identified by MiscIntNo }
    Function GetStockMiscInt (Var Company     : String;
                              Var StockId     : String;
                              Var LocCode     : String;
                              Var MiscIntNo   : SmallInt;
                              Var MiscIntBand : String;
                              Var MiscInt     : LongInt) : SmallInt;

    { Saves an integer into the specified stock item }
    Function SaveStockMiscInt (Var Company     : String;
                               Var StockId     : String;
                               Var LocCode     : String;
                               Var MiscIntNo   : SmallInt;
                               Var MiscIntBand : String;
                               Var NewInt      : LongInt) : SmallInt;

    { Returns an double from the stock item, identified by MiscValNo }
    Function GetStockMiscVal (Var Company     : String;
                              Var StockId     : String;
                              Var LocCode     : String;
                              Var MiscValNo   : SmallInt;
                              Var MiscValBand : String;
                              Var MiscVal     : Double) : SmallInt;

    { Saves an double into the specified stock item }
    Function SaveStockMiscVal (Var Company     : String;
                               Var StockId     : String;
                               Var LocCode     : String;
                               Var MiscValNo   : SmallInt;
                               Var MiscValBand : String;
                               Var NewVal      : Double) : SmallInt;

    { Returns a stock value based on ReqValue  }
    { ReqValue: 1 = Qty Sold                   }
    {           2 = Sales                      }
    {           3 = Costs                      }
    {           4 = Margin                     }
    {           5 = Budget                     }
    {           10= Posted Stock Level         }
    Function GetStockValue (Var ValueReq  : SmallInt;
                            Var Company   : String;
                            Var TheYear   : SmallInt;
                            Var ThePeriod : SmallInt;
                            Var TheCcy    : SmallInt;
                            Var StockId   : String;
                            Var LocCode   : String;
                            Var StockVal  : Double) : SmallInt;
    { Saves a stock value, based on ReqValue   }
    { ReqValue: 1 = Budget                     }
    Function SaveStockValue (Var SetValue  : SmallInt;
                             Var Company   : String;
                             Var TheYear   : SmallInt;
                             Var ThePeriod : SmallInt;
                             Var TheCcy    : SmallInt;
                             Var StockId   : String;
                             Var LocCode   : String;
                             Var NewValue  : Double) : SmallInt;

    { Returns a Cost Centre or Department name }
    { CCDpType: C = Cost Centre                }
    {           D = Department                 }
    Function GetCCDepName(Var Company  : String;
                          Var CCDpType : String;
                          Var CCDpCode : String;
                          Var CCDpName : String) : SmallInt;

    { Gets the location name }
    Function GetLocationName(Var Company : String;
                             Var LocCode : String;
                             Var LocName : String) : SmallInt;

    { Gets the currency name from the system setup info }
    Function GetCurrencyName(Var Company  : String;
                             Var CurrNo   : SmallInt;
                             Var CurrName : String) : SmallInt;

    { Converts the ODBC Ints into a Kosher Double }
    Function ConvertInts (Const Int2 : SmallInt;
                          Const Int4 : LongInt) : Double;

    Function DocSign(Const DocType : String) : SmallInt;

    Function GetJobTotalStr(Var ValueReq : SmallInt;
                            Var Company  : String;
                            Var TotalStr : String) : SmallInt;

    Function GetJobBudgetValue(Var ValueReq  : SmallInt;
                               Var Company   : String;
                               Var TheYear   : SmallInt;
                               Var ThePeriod : SmallInt; { 0 = YTD }
                               Var TheCcy    : SmallInt;
                               Var JobCode   : String;
                               Var HistFolio : LongInt;
                               Var Committed : WordBool;
                               Var HistValue : Double) : SmallInt;

    Function GetJCBudgetValue (Var ValueReq  : SmallInt;
                               Var Company   : String;
                               Var BudgType  : String;
                               Var TotalType : SmallInt;
                               Var Committed : SmallInt;
                               Var TheYear   : SmallInt;
                               Var ThePeriod : SmallInt;
                               Var TheCcy    : SmallInt;
                               Var JobCode   : String;
                               Var StockId   : String;
                               Var HistVal   : Double) : SmallInt;

    Function SaveJCBudgetValue (Var SetValue  : SmallInt;
                                Var Company   : String;
                                Var BudgType  : String;
                                Var TotalType : SmallInt;
                                Var Committed : SmallInt;
                                Var TheYear   : SmallInt;
                                Var ThePeriod : SmallInt;
                                Var TheCcy    : SmallInt;
                                Var JobCode   : String;
                                Var StockId   : String;
                                Var NewValue  : Double) : SmallInt;

    Function GetJobMiscStr(Var Company  : String;
                           Var JobCode  : String;
                           Var JobStr   : String;
                           Var JobStrNo : SmallInt) : SmallInt;

    Function GetJobMiscInt(Var Company  : String;
                           Var JobCode  : String;
                           Var JobInt   : LongInt;
                           Var JobIntNo : SmallInt) : SmallInt;

    Function GetJobMiscVal(Var Company  : String;
                           Var JobCode  : String;
                           Var JobDub   : Double;
                           Var JobDubNo : SmallInt) : SmallInt;

    Function GetCurrencyRate(Var Company  : String;
                             Var RateType : String;
                             Var Currency : SmallInt;
                             Var CurrRate : Double) : SmallInt;

    Function GetGLTxMove(Var Company    : String;
                         Var NomCode    : LongInt;
                         Var StartDate  : Variant;
                         Var EndDate    : Variant;
                         Var Currency   : SmallInt;
                         Var CostCentre : String;
                         Var Department : String;
                         Var AccCode    : String;
                         Var TxMoveAmt  : Double) : SmallInt;

    Function ConvertAmount(Var Company  : String;
                           Var FromCcy  : SmallInt;
                           Var ToCcy    : SmallInt;
                           Var Amount   : Double;
                           Var RateType : SmallInt) : SmallInt;

    Function GetCustAging(Var Company     : String;
                          Var CustCode    : String;
                          Var AcType      : String;
                          Var AgePeriod   : String;
                          Var AgedDate    : Variant;
                          Var AgeInterval : SmallInt;
                          Var WantCat     : SmallInt;
                          Var AgeValue    : Double) : SmallInt;

    Function GetCustSalesPrice(Var Company  : String;
                               Var CustCode : String;
                               Var AcType   : String;
                               Var StockId  : String;
                               Var Location : String;
                               Var Currency : SmallInt;
                               Var Quantity : Double;
                               Var Price    : Double) : SmallInt;

    Function GetAcMiscStr (Var Company   : String;
                           Var CustCode  : String;
                           Var AcType    : String;
                           Var MiscStrNo : SmallInt;
                           Var MiscStr   : String) : SmallInt;

    Function GetAcMiscInt (Var Company     : String;
                           Var CustCode    : String;
                           Var AcType      : String;
                           Var MiscIntNo   : SmallInt;
                           Var MiscInt     : LongInt) : SmallInt;

    Function GetAcMiscVal (Var Company     : String;
                           Var CustCode    : String;
                           Var AcType      : String;
                           Var MiscValNo   : SmallInt;
                           Var MiscVal     : Double) : SmallInt;

    Function SaveAcMiscStr (Var Company   : String;
                            Var CustCode  : String;
                            Var AcType    : String;
                            Var MiscStrNo : SmallInt;
                            Var NewStr    : String) : SmallInt;

    Function SaveAcMiscInt (Var Company   : String;
                            Var CustCode  : String;
                            Var AcType    : String;
                            Var MiscIntNo : SmallInt;
                            Var NewInt    : LongInt) : SmallInt;

    Function SaveAcMiscVal (Var Company   : String;
                            Var CustCode  : String;
                            Var AcType    : String;
                            Var MiscValNo : SmallInt;
                            Var NewVal    : Double) : SmallInt;

    Function GetTeleValue (Var ValueReq  : SmallInt;
                           Var Company   : String;
                           Var CustCode  : String;
                           Var StockId   : String;
                           Var TheCcy    : SmallInt;
                           Var TheYear   : SmallInt;
                           Var ThePeriod : SmallInt;
                           Var CostCntr  : String;
                           Var Dept      : String;
                           Var LocCode   : String;
                           Var StockVal  : Double;
                           Var AcType    : String) : SmallInt; // PL 30/08/2016 R3 ABSEXCH-16676 added AcType to indicate supplier or customer

    Function SaveTeleValue (Var SetValue  : SmallInt;
                            Var Company   : String;
                            Var CustCode  : String;
                            Var StockId   : String;
                            Var TheCcy    : SmallInt;
                            Var TheYear   : SmallInt;
                            Var ThePeriod : SmallInt;
                            Var CostCntr  : String;
                            Var Dept      : String;
                            Var LocCode   : String;
                            Var NewValue  : Double;
                            Var AcType    : String) : SmallInt; // PL 30/08/2016 R3 ABSEXCH-16676 added AcType to indicate supplier or customer

    Function GetGLJobActual(Var Company    : String;
                            Var TheCcy     : SmallInt;
                            Var StartPr    : SmallInt;
                            Var StartYr    : SmallInt;
                            Var EndPr      : SmallInt;
                            Var EndYr      : SmallInt;
                            Var NomCode    : LongInt;
                            Var JobCode    : String;
                            Var AnalCode   : String;
                            Var StkCode    : String;
                            Var LocCode    : String;
                            Var CostCentre : String;
                            Var Department : String;
                            Var AccCode    : String;
                            Var GLActuals  : Double) : SmallInt;

    Function GetCurrTriBools (Var Company  : String;
                              Var Currency : SmallInt;
                              Var BoolNo   : SmallInt;
                              Var BoolVar  : String) : SmallInt;

    Function GetCurrTriCurr (Var Company  : String;
                             Var Currency : SmallInt;
                             Var CurrNo   : SmallInt) : SmallInt;

    Function GetCurrTriRate (Var Company  : String;
                             Var Currency : SmallInt;
                             Var TriRate  : Double) : SmallInt;

    Function GetSysFlag (Var Company : String;
                         Var FlagNo  : SmallInt;
                         Var FlagVal : String) : SmallInt;

    { Creates a multi-line Nominal Transfer }
    Function  AddNomLines (Var Company         : String;
                           Var TransDate       : String;
                           Var TheYear         : SmallInt;
                           Var ThePeriod       : SmallInt;
                           Var TranDesc        : String;
                           Var VATCountry      : String;
                           Var VATFlag         : String;
                           Var THUserFieldList : Variant;  // HM 17/06/04: Added for EntAddNOMUDFLines
                           Var GLList          : Variant;
                           Var DescList        : Variant;
                           Var CurrList        : Variant;
                           Var AmtList         : Variant;
                           Var RateList        : Variant;
                           Var VATCodeList     : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                           Var IncVATCodeList  : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                           Var VATAmountList   : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                           Var CCList          : Variant;
                           Var DeptList        : Variant;
                           Var JobList         : Variant;
                           Var AnalList        : Variant;
                           Var PayRefList      : Variant;
                           Var ResetJCGL       : String;   // MH 21/04/06: 'Y'/'N'
                           Var TLUDF1List      : Variant;  // MH 18/03/2011
                           Var TLUDF2List      : Variant;
                           Var TLUDF3List      : Variant;
                           Var TLUDF4List      : Variant;
                           Var TLUDF5List      : Variant;
                           Var TLUDF6List      : Variant;
                           Var TLUDF7List      : Variant;
                           Var TLUDF8List      : Variant;
                           Var TLUDF9List      : Variant;
                           Var TLUDF10List     : Variant) : SmallInt;

    // MH 09/10/2014 v7.0.12 ABSEXCH-15632: Added Auto-Reversing Support to AddNOMLines
    Function  AddNomLines_AutoRev (Var Company         : String;
                                   Var TransDate       : String;
                                   Var TheYear         : SmallInt;
                                   Var ThePeriod       : SmallInt;
                                   Var TranDesc        : String;
                                   Var VATCountry      : String;
                                   Var VATFlag         : String;
                                   Var THUserFieldList : Variant;  // HM 17/06/04: Added for EntAddNOMUDFLines
                                   Var GLList          : Variant;
                                   Var DescList        : Variant;
                                   Var CurrList        : Variant;
                                   Var AmtList         : Variant;
                                   Var RateList        : Variant;
                                   Var VATCodeList     : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                   Var IncVATCodeList  : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                   Var VATAmountList   : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                   Var CCList          : Variant;
                                   Var DeptList        : Variant;
                                   Var JobList         : Variant;
                                   Var AnalList        : Variant;
                                   Var PayRefList      : Variant;
                                   Var ResetJCGL       : String;   // MH 21/04/06: 'Y'/'N'
                                   Var TLUDF1List      : Variant;  // MH 18/03/2011
                                   Var TLUDF2List      : Variant;
                                   Var TLUDF3List      : Variant;
                                   Var TLUDF4List      : Variant;
                                   Var TLUDF5List      : Variant;
                                   Var TLUDF6List      : Variant;
                                   Var TLUDF7List      : Variant;
                                   Var TLUDF8List      : Variant;
                                   Var TLUDF9List      : Variant;
                                   Var TLUDF10List     : Variant) : SmallInt;

    Function GetAltStkMiscStr (Var Company   : String;
                               Var StockId   : String;
                               Var AltId     : String;
                               Var AccId     : String;
                               Var MiscFldNo : SmallInt;
                               Var MiscStr   : String;
                               Var MiscInt   : SmallInt;
                               Var MiscDub   : Double) : SmallInt;

    Function SaveAltStkFld (Var Company   : String;
                            Var StockId   : String;
                            Var AltId     : String;
                            Var AccId     : String;
                            Var MiscFldNo : SmallInt;
                            Var MiscStr   : String;
                            Var MiscInt   : SmallInt;
                            Var MiscDub   : Double) : SmallInt;

    {$IFDEF FUNCWIZ}
      Function DispFuncWizard (Var WizStr : String) : SmallInt;
    {$ENDIF}

    Function PrimeLoginDets (Var UserId   : String;
                             Var PassWord : String) : SmallInt;

    Function SaveJobMiscStr (Var Company   : String;
                             Var JobCode   : String;
                             Var MiscStrNo : SmallInt;
                             Var NewStr    : String) : SmallInt;

    Function GetNomAltCode(Var Company : String;
                           Var NomCode : LongInt;
                           Var AltCode : String) : SmallInt;

    Function SaveGLMiscStr (Var Company   : String;
                            Var NomCode   : LongInt;
                            Var MiscStrNo : SmallInt;
                            Var NewStr    : String) : SmallInt;

    Function GetAnalDesc(Var Company  : String;
                         Var AnalCode : String;
                         Var AnalDesc : String) : SmallInt;

    Function SelectData (Var DataString : String;
                         Var DataType : SmallInt) : SmallInt;

    // Creates a multi-line Timesheet
    // HM 11/03/02: Replaced by AddTSHLinesEx
    {Function AddTSHLines (Const Company        : String;
                          Const EmployeeCode   : String;
                          Const TSHDesc        : String;
                          Const TheYear        : SmallInt;
                          Const ThePeriod      : SmallInt;
                          Const TSHWeekNo      : SmallInt;
                          Var   JobCodeList    : Variant;
                          Var   RateCodeList   : Variant;
                          Var   AnalCodeList   : Variant;
                          Var   CCList         : Variant;
                          Var   DeptList       : Variant;
                          Var   HoursList      : Variant;
                          Var   NarrativeList  : Variant;
                          Var   ChargeRateList : Variant) : SmallInt;}

    // MH 02/11/2011 v6.9: Removed obsolete function
    // HM 11/03/02: Added extended version to allow cost info to be specified
//    Function AddTSHLinesEx (Const Company        : String;
//                            Const EmployeeCode   : String;
//                            Const TSHDesc        : String;
//                            Const TheYear        : SmallInt;
//                            Const ThePeriod      : SmallInt;
//                            Const TSHWeekNo      : SmallInt;
//                            Var   THUDFields     : Variant;
//                            Var   JobCodeList    : Variant;
//                            Var   RateCodeList   : Variant;
//                            Var   AnalCodeList   : Variant;
//                            Var   CCList         : Variant;
//                            Var   DeptList       : Variant;
//                            Var   HoursList      : Variant;
//                            Var   NarrativeList  : Variant;
//                            Var   ChargeRateList : Variant;
//                            Var   CostCcyList    : Variant;
//                            Var   HourlyCostList : Variant;
//                            Var   TLUDField1     : Variant;
//                            Var   TLUDField2     : Variant) : SmallInt;

    // Creates a multi-line Timesheet and returns and error description
    Function AddTSHLinesErrorDesc (Const Company        : String;
                                   Const EmployeeCode   : String;
                                   Const TSHDesc        : String;
                                   Const TransDate      : String;
                                   Const TheYear        : SmallInt;
                                   Const ThePeriod      : SmallInt;
                                   Const TSHWeekNo      : SmallInt;
                                   Var   THUDFields     : Variant;
                                   Var   JobCodeList    : Variant;
                                   Var   RateCodeList   : Variant;
                                   Var   AnalCodeList   : Variant;
                                   Var   CCList         : Variant;
                                   Var   DeptList       : Variant;
                                   Var   HoursList      : Variant;
                                   Var   NarrativeList  : Variant;
                                   Var   ChargeRateList : Variant;
                                   Var   CostCcyList    : Variant;
                                   Var   HourlyCostList : Variant;
                                   Var   TLUDField1     : Variant;
                                   Var   TLUDField2     : Variant;
                                   Var   TLUDField3     : Variant;
                                   Var   TLUDField4     : Variant;
                                   Var   TLUDField5     : Variant;
                                   Var   TLUDField6     : Variant;
                                   Var   TLUDField7     : Variant;
                                   Var   TLUDField8     : Variant;
                                   Var   TLUDField9     : Variant;
                                   Var   TLUDField10    : Variant;
                                   Const ValidMode      : SmallInt;
                                   Var   ErrorDesc      : String) : SmallInt;

    Function GetEmployeeStr (Var Company   : String;
                             Var EmplCode  : String;
                             Var MiscStrNo : SmallInt;
                             Var MiscStr   : String) : SmallInt;

    Function GetTimeRateStr (Var Company      : String;
                             Var EmplCode     : String;
                             Var TimeRateCode : String;
                             Var MiscStrNo    : SmallInt;
                             Var MiscStr      : String) : SmallInt;

    Function GetAnalMiscStr (Var Company  : String;
                             Var AnalCode  : String;
                             Var AnalStr   : String;
                             Var AnalStrNo : SmallInt) : SmallInt;

    Function SaveAnalMiscStr (Var Company   : String;
                              Var AnalCode  : String;
                              Var AnalStrNo : SmallInt;
                              Var NewStr    : String) : SmallInt;

    Function GetAnalMiscInt (Var Company   : String;
                             Var AnalCode  : String;
                             Var AnalInt   : LongInt;
                             Var AnalIntNo : SmallInt) : SmallInt;

    Function SaveAnalMiscInt (Var Company   : String;
                              Var AnalCode  : String;
                              Var AnalIntNo : SmallInt;
                              Var NewInt    : LongInt) : SmallInt;

    Function GetAnalMiscDbl (Var Company   : String;
                             Var AnalCode  : String;
                             Var AnalDbl   : Double;
                             Var AnalDblNo : SmallInt) : SmallInt;

    Function SaveAnalMiscDbl (Var Company   : String;
                              Var AnalCode  : String;
                              Var AnalDblNo : SmallInt;
                              Var NewDbl    : Double) : SmallInt;

    // Creates a new Job Record
    Function AddJob (Const Company       : String;
                     Const OLEJobType    : String;    // 'J'=Job, 'C'=Contract
                     Const ParentJobCode : String;
                     Const JobCode       : String;
                     Const JobDesc       : String;
                     Const JobManager    : String;
                     Const JobTypeCode   : String;    // Job Type Code
                     Const StartDate     : String;
                     Const EndDate       : String;
                     Const CustomerCode  : String;
                     Const ContactName   : String;
                     Const ChargeType    : String;
                     Const PriceQuoted   : Double;
                     Const PriceCurrency : SmallInt;
                     Const SORReference  : String;
                     Const JobStatus     : String;
                     Var   UserFieldList : Variant;
                     Var   ErrString     : String) : SmallInt;

    // Returns the Basis (Incremental, Gross Inc, Gross) for the specified Terms
    Function GetJobTermsBasis(Const Company, TermsOurRef : String; Var ContractBasis : String) : SmallInt;

    // Returns a specified value from the applications for a specific job and analysis code:-
    Function GetJobAppsValue(Company, JobCode, AnalCode : String; Const WantValue : SmallInt; Var AppsValue : Double) : SmallInt;

    // Returns a specified value from the applications for a specific job, sub-contractor
    // and optional analysis code:-
    //
    //   1   JPA Applied Total for all JPA's
    //   2   JPA Certified Total for all JPA's
    //
    Function GetJobAppsSubcontractorValue(Company, JobCode, EmplCode, AnalCode : String; Const WantValue : SmallInt; Var AppsValue : Double) : SmallInt;

    // Returns a specified value from the applications for a specific job, Customer
    // and optional analysis code:-
    //
    //   1   Applied Total for all JSA's
    //   2   Certified Total for all JSA's
    //
    Function GetJobAppsCustomerValue(Company, JobCode, CustCode, AnalCode : String; Const WantValue : SmallInt; Var AppsValue : Double) : SmallInt;

    // Returns a specified value from the applications for a specific job, Customer
    // and optional analysis code:-
    //
    //   1   Applied Value
    //   2   Cumulative Applied Value
    //   3   Certified Value
    //   4   Cumulative Certified Value
    //
    Function GetJobTermsValue(Company, OurRef, AnalCode : String; Const WantValue : SmallInt; Var RetValue : Double) : SmallInt;

    // Returns a line type total from the specific transaction
    Function GetTransactionLineTypeValue(Company, OurRef : String; LineType : SmallInt; Var RetValue : Double) : SmallInt;

    // Returns a line type total from the transactions for a specified job
    Function GetJobLineTypeValue(Company, JobCode : String; LineType : SmallInt; Var RetValue : Double) : SmallInt;

    // Returns a string from the Location item identified by MiscStrNo
    Function GetLocationMiscStr (Company, LocCode : String; Const MiscStrNo : SmallInt; Var MiscStr : String) : SmallInt;

    // Returns an integer from the Location item identified by MiscIntNo
    Function GetLocationMiscInt (Company, LocCode : String; Const MiscIntNo : SmallInt; Var MiscInt : LongInt) : SmallInt;

    // Updates a string on the Location record with the item being identified by MiscStrNo:-
    Function SaveLocationMiscStr (Company, LocCode : String; Const MiscStrNo : SmallInt; NewStr : String) : SmallInt;

    // Updates an integer on the Location record with the item being identified by MiscIntNo
    Function SaveLocationMiscInt (Company, LocCode : String; Const MiscIntNo : SmallInt; NewInt : LongInt) : SmallInt;

    { === G/L View Functions ================================================= }

    { Returns a string value from the specifed G/L view, based on the passed
      StrNo value:

      StrNo:  1 = AltCode
              2 = Desc
    }
    function GetGLViewMiscStr(var Company: string;
                              var NomViewNo: LongInt;
                              var ViewCode: string;
                              var StrNo: SmallInt;
                              var RetStr: string): SmallInt;

    { Returns a value from the specified G/L View, based on
      the passed Mode:

      Modes:  1  =  Budget1
              2  =  Budget2
              3  =  Actual (balance, 5-4)
              4  =  Debit
              5  =  Credit
    }
    function GetGLViewValue(var Mode      : SmallInt;
                            var Company   : String;
                            var TheYear   : SmallInt;
                            var ThePeriod : SmallInt; { 0 = YTD }
                            var TheCcy    : SmallInt;
                            var NomViewNo : LongInt;
                            var ViewCode  : string;
                            var NomValue  : Double) : SmallInt;

    { Returns the actual G/L code that the specified G/L view record is
      linked to. }
    function GetGLViewLinkCode(var Company: string;
                               var NomViewNo: integer;
                               var ViewCode: string;
                               var RetCode: Integer): SmallInt;


    { Updates one of the string values, based on the supplied MiscStrNo:

        MiscStrNo:  1 = AltCode
                    2 = Desc
    }
    function SaveGLViewMiscStr (var Company   : String;
                                var NomViewNo : LongInt;
                                var ViewCode  : string;
                                var MiscStrNo : SmallInt;
                                var NewStr    : String) : SmallInt;

    { Saves the passed value to the specified G/L View, based
      on the passed SetValue:

        SetValue:  1  =  Budget1
                   2  =  Budget2
    }
    function SaveGLViewValue(var SetValue  : SmallInt;
                             var Company   : string;
                             var TheYear   : SmallInt;
                             var ThePeriod : SmallInt;
                             var TheCcy    : SmallInt;
                             var NomViewNo : LongInt;
                             var ViewCode  : string;
                             var NewValue  : Double) : SmallInt;

    // ABSEXCH-15479: Added new CheckUserPermission method for James' SQL add-in for H4H to force login and check user permissions
    function CheckUserPermission(Const Company      : String;
                                 Const PermissionNo : LongInt) : SmallInt;

    // MH 02/12/2014 ABSEXCH-15836: Added Read-Write support for new account Country fields
    Function GetCountryName(Var CountryCode, CountryName : String) : SmallInt;

    // SSK 29/08/2016 R3 ABSEXCH-14589: added to return JobTypeName
    Function GetJobTypeName(Var Company, JobTypeCode : String; Var JobTypeName : String) : SmallInt;
  end;

var
  Instances : Integer;

implementation

uses ETDateU,
     ETMiscU,
     ETStrU,
     BtrvU2,
     BtSupU1,
     BtKeys1U,
     EntServF,
     CurrncyU,
     OLEProgr,
     SalePric,
     SysU1,
     SysU2,
     SysU3,
     Crypto,
     History,
     JobSup1U,

     {$IFDEF FUNCWIZ}
       FuncWiz,
     {$ENDIF}
     {$IFDEF DEBUGON}
       DebugWin,
     {$ENDIF}
     Comnu2,
     MiscU,
     EntLicence,        // Exchequer Licencing Object (EnterpriseLicence)
     ValidateVAT,       // VAT Code routines
     Brand,
     SavePos,
     {$IFDEF EXSQL}
       SQLUtils,
       SQLCallerU,
       SQLRep_Config,
     {$ENDIF}
     AuditIntf,
     CacheNomCodes,
     oCacheDataRecord,
     CacheCustAgeing,
     CacheCCDept,
     EntLoggerClass,
     Variants,
     ExWrap1U,

     // MH 10/09/2013 v7.0.6 ABSEXCH-14598: Modified to pickup new longer Bank Account No / Sort Code
     EncryptionUtils,

     // MH 28/10/2013 v7.0.7 ABSEXCH-14705: Added Transaction Originator fields
     TransactionOriginator,

     //PR: 04/07/2012 ABSEXCH-12957
     BudgetHistoryVar,

     // MH 02/12/2014 ABSEXCH-15836: Added Read-Write support for new account Country fields
     CountryCodes, CountryCodeUtils,

     SQLTransactionLines,
     EntLogIniClass,
     //HV 26/06/2018 2017R1.1 ABSEXCH-20793: provided support for entry in anonymisation control center if user changes Account Status to from OLE.
     oAnonymisationDiaryObjDetail,
     oAnonymisationDiaryBtrieveFile,
     oAnonymisationDiaryObjIntf;

Const
  AutoReversingNOM = True;

{***********************************************************************}
{* RegisterOLEServer: Registers the OLE Class with windows.            *}
{***********************************************************************}
procedure RegisterOLEServer;
const
  EntServerInfo : TAutoClassInfo = (AutoClass: TEnterpriseServer;
                                    ProgID: 'Enterprise.OLEServer';
                                    ClassID: '{D7AF2B20-8D38-11CF-BD36-444553540000}';
                                    Description: 'Exchequer OLE Server';
                                    Instancing: acMultiInstance);
begin
  Automation.RegisterClass(EntServerInfo);
end;


Function GetSecIIF (Const Check : Boolean; Const TrueNo, FalseNo : LongInt) : LongInt;
Begin { GetSecIIF }
  If Check Then
    Result := TrueNo
  Else
    Result := FalseNo;
End;  { GetSecIIF }


{************************************************************************}
{* TEnterpriseServer: Exchequer OLE Server object. Allows data access  *}
{*                    to the nominals, customers, suppliers and stock   *}
{*                    by any application the can perform OLE automation *}
{************************************************************************}
Constructor TEnterpriseServer.Create;
Begin
  Inherited Create;

  Destroying := False;
  Inc (Instances);

  StartLogging(SetDrive);

  BtrList := TBtrListO.Create;
  BtrList.OnCompListChanged := UpdateComplist;
  Form_EnterpriseOleServer.OnUpdateStats := UpdateCompList;

  FirstPass := True;

  SkipLogon := False;
End;

Destructor TEnterpriseServer.Destroy;
Begin
  Destroying := True;
  Form_EnterpriseOleServer.OnUpdateStats := Nil;
  Dec (Instances);
  FreeAndNIL(AppsAnalCache);
  FreeAndNIL(TransLineTypeCache);
  FreeAndNIL(JobLineTypeCache);
  BtrList.Free;
  BtrList := Nil;

  StopLogging;

  Inherited Destroy;
End;

{ returns an integer style boolean }
Function TEnterpriseServer.BoolToBoolInt (Const TheBool : Boolean) : Integer;
Begin
  If TheBool Then
    Result := TrueInt
  Else
    Result := FalseInt;
End;

{ retrieves the specified nominal record }
Function TEnterpriseServer.GetNominalRec (      BtrObj      : TdPostExLocalPtr;
                                          Const NominalCode : LongInt) : Boolean;
Var
  KeyS : Str255;
Begin
  With BtrObj^ Do Begin
    { Check to see if the record is loaded }
    If (LNom.NomCode <> NominalCode) Then Begin
      { Record Not Loaded - Load }
      KeyS := FullNomKey(NominalCode);
      Result := LGetMainRec (NomF, KeyS);
    End { If }
    Else
      { Record already loaded }
      Result := True;
  End; { If }
End;

{ retrieves the specified customer record }
Function TEnterpriseServer.GetCustRec (      BtrObj   : TdPostExLocalPtr;
                                       Const CustCode : String;
                                       Const IsCust   : Boolean) : Boolean;
Var
  KeyS : Str255;
Begin
  With BtrObj^ Do Begin
    { Check to see if the record is loaded }
    If (LCust.CustCode <> CustCode) Then Begin
      { Record Not Loaded - Load }
      KeyS := FullCustCode(CustCode);
      Result := LGetMainRec (CustF, KeyS);
    End { If }
    Else
      { Record already loaded }
      Result := True;
  End; { If }
End;

{ retrieves the stock record }
Function TEnterpriseServer.GetStockRec (      BtrObj  : TdPostExLocalPtr;
                                        Const StockId : String) : Boolean;
Var
  KeyS : Str255;
Begin
  With BtrObj^ Do Begin
    { Check to see if the record is loaded }
    If (LStock.StockCode <> StockId) Then Begin
      { Record Not Loaded - Load }
      KeyS := FullStockCode(UpperCase(StockId));
      Result := LGetMainRec (StockF, KeyS);
    End { If }
    Else
      { Record already loaded }
      Result := True;
  End; { If }
End;

//-------------------------------------------------------------------------

{ Retrieves a Cost Centre / Department }
Function TEnterpriseServer.GetCCDepRec (      BtrObj  : TdPostExLocalPtr;
                                        Const CCDepId : String;
                                        Const IsCC    : Boolean) : Boolean;
Var
  KeyS : Str255;
Begin
  With BtrObj^, LPassword Do Begin
    { Check to see if the record is loaded }
    If (SubType <> CSubCode[IsCC]) Or (CostCtrRec.PCostC <> CCDepId) Then Begin
      { Record Not Loaded - Load }
      KeyS := FullCCKey (CostCCode, CSubCode[IsCC], UpperCase(CCDepId));
      Result := LGetMainRec (PWrdF, KeyS);
    End { If }
    Else
      { Record already loaded }
      Result := True;
  End; { If }
End;

//------------------------------

Function TEnterpriseServer.ValidateCCDeptCode (Const CompObj : TCompanyInfo;
                                               Const CCDepId : String;
                                               Const IsCC    : Boolean) : Boolean;
Var
  oCCDepCache : TCostCentreDepartmentCache;
Begin // GetCCDepRec
  If IsCC Then
    oCCDepCache := CompObj.CostCentreCache
  Else
    oCCDepCache := CompObj.DepartmentCache;

  // Check for CC/Dept presence in cache
  Result := (oCCDepCache.GetCCDept(CCDepId) <> NIL);
  If (Not Result) Then
  Begin
    // If not found then go to the data file
    Result := GetCCDepRec(CompObj.CompanyBtr, CCDepId, IsCC);

    // If found then add into the cache for next time
    If Result Then
      oCCDepCache.AddToCache (CCDepId);
  End; // If (Not Result)
End; // GetCCDepRec

//-------------------------------------------------------------------------

{ Retrieves a Job record }
Function TEnterpriseServer.GetJobRec (      BtrObj : TdPostExLocalPtr;
                                      Const JobId  : String) : Boolean;
Var
  KeyS : Str255;
Begin
  With BtrObj^ Do Begin
    { Check to see if the record is loaded }
    If (LJobRec.JobCode <> JobId) Then Begin
      { Record Not Loaded - Load }
      KeyS := FullJobCode(JobId);
      Result := LGetMainRec (JobF, KeyS);
    End { If }
    Else
      { Record already loaded }
      Result := True;
  End; { If }
End;

{ Retrieves a Job Analysis record }
Function TEnterpriseServer.GetJobMiscRec (      BtrObj : TdPostExLocalPtr;
                                          Const JAId   : String;
                                          Const JAMode : Byte) : Boolean;
Var
  KeyS : Str255;
Begin
  With BtrObj^ Do Begin
    { Check to see if the record is loaded }
    If (LJobMisc.JobAnalRec.JAnalCode <> JAId) Then Begin
      { Record Not Loaded - Load }
      KeyS := FullJAKey (JARCode, JASubAry[JAMode], JAId);
      Result := LGetMainRec (JMiscF, KeyS);
    End { If }
    Else
      { Record already loaded }
      Result := True;
  End; { If }
End;

{ Retrieves a Job Analysis record }
Function TEnterpriseServer.GetEmplRec (BtrObj   : TdPostExLocalPtr;
                                       EmplCode : ShortString) : Boolean;
Var
  KeyS : Str255;
Begin
  With BtrObj^ Do Begin
    { Check to see if the record is loaded }
    If (LJobMisc.EmplRec.EmpCode <> EmplCode) Then Begin
      { Record Not Loaded - Load }
      KeyS := PartCCKey (JARCode, JAECode) + FullCustCode(EmplCode);
      Result := LGetMainRec (JMiscF, KeyS);
    End { If }
    Else
      { Record already loaded }
      Result := True;
  End; { If }
End;

{ Retrieves a Location Record }
Function TEnterpriseServer.GetLocRec (BtrObj  : TdPostExLocalPtr;
                                      LocId : String) : Boolean;
Var
  KeyS : Str255;
Begin
  With BtrObj^ Do Begin
    LocId := Full_MLocKey(UpperCase(Trim(LocId)));

    { Check to see if the record is loaded }
    If (LMLoc.MLocLoc.loCode <> LocId) Then Begin
      { Record Not Loaded - Load }
      KeyS := PartCCKey(CostCCode, CSubCode[True]) + LocId;

      Result := LGetMainRec (MLocF, KeyS);

      If Result Then
        LMLoc^ := LMLocCtrl^
      Else
        FillChar (LMLoc^, SizeOf (LMLoc^), #0);
    End { If }
    Else
      { Record already loaded }
      Result := True;
  End; { If }
End;

{ Retrieves a Stock/Location XRef Record }
Function TEnterpriseServer.GetStkLocRec (BtrObj          : TdPostExLocalPtr;
                                         CreateIfMissing : Boolean) : Boolean;
Var
  StockId, LocId   : String;
  KeyS             : Str255;
Begin
  With BtrObj^ Do Begin
    StockId := FullStockCode(UpperCase(Trim(LStock.StockCode)));
    LocId   := Full_MLocKey(UpperCase(Trim(LMLoc^.MLocLoc.loCode)));

    { Check to see if the record is loaded }
    If (LMStkLoc^.MStkLoc.lsStkCode <> StockId) Or
       (LMStkLoc^.MStkLoc.lsLocCode <> LocId) Then Begin
      { Record Not Loaded - Load }
      KeyS:=PartCCKey(CostCCode,CSubCode[BOff]) + StockId + LocId;

      Result := LGetMainRec (MLocF, KeyS);

      If Result Then
        LMStkLoc^ := LMLocCtrl^
      Else Begin
        { No Stock/Location Record }
        FillChar (LMStkLoc^, SizeOf (LMStkLoc^), #0);
        If CreateIfMissing Then Begin
          { Create new record }
          LMStkLoc^.RecPFix := CostCCode;
          LMStkLoc^.SubType := CSubCode[BOff];
          SetROConsts(LStock, LMStkLoc^.MStkLoc, LMLoc^.MLocLoc);
        End; { If CreateIfMissing }
      End; { Else }
    End { If }
    Else
      { Record already loaded }
      Result := True;
  End; { If }
End;

{ Retrieves an Alternate Stock Code Record }
Function TEnterpriseServer.GetAltStkRec (BtrObj   : TdPostExLocalPtr;
                                         StockFol : LongInt;
                                         AltId    : String;
                                         AccId    : String) : Boolean;
Var
  KeyS     : Str255;
  Res      : SmallInt;
  ContSrch : Boolean;
Begin { GetAltStkRec }
  With BtrObj^ Do Begin
    Result := False;

    AltId   := FullStockCode(UpperCase(Trim(AltId)));
    AccId   := FullCustCode(UpperCase(Trim(AccId)));

    { Check to see if the record is loaded }
    If (LMAltCode^.SdbStkRec.sdStkFolio <> StockFol) Or            { Stock Folio }
       (LMAltCode^.SdbStkRec.sdAltCode  <> AltId) Or               { Alt Code }
       (LMAltCode^.SdbStkRec.sdSuppCode <> AccId) Then Begin       { Account Code }
      { Record Not Loaded - Load }
      KeyS:=PartCCKey(NoteTCode,NoteCCode) + FullNomKey(StockFol) + AltId;

      With LMLocCtrl^, SdbStkRec Do Begin
        ContSrch := True;
        Res := LFind_Rec(B_GetGEq, MLocF, 1, KeyS);
        While (Res = 0) And (RecPFix = NoteTCode) And (SubType = NoteCCode) And ContSrch And (Not Result) Do Begin
          { Check to see if its one of the records we want to check }
          ContSrch := (sdStkFolio = StockFol) And (sdCode1 = AltId);

          If ContSrch Then Begin
            If (Trim(AccId) = Trim(sdSuppCode)) Then Begin
              { Account code matches that on alt stock record }
              LMAltCode^ := LMLocCtrl^;
              Result := True;
            End { If }
            Else Begin
              { wrong record - try next }
              Res := LFind_Rec(B_GetNext, MLocF, 1, KeyS);
            End; { Else }
          End; { If }
        End; { While }
      End; { With }
    End { If }
    Else
      { Record already loaded }
      Result := True;

    If (Not Result) Then
      FillChar (LMAltCode^, SizeOf (LMAltCode^), #0);
  End; { With BtrObj^ }
End;  { GetAltStkRec }


// Copied from x:\entrprse\r&d\WOPCT1I.PAS
Procedure TEnterpriseServer.Time2Mins(Var MTime                :  LongInt;
                                      Var Days,Hrs,Mins        :  Extended;
                                          SetMode              :  Byte);
Var
  TimeLeft  :  Extended;
Begin { Time2Mins }
  Case  SetMode of
    0  :  Begin
            Days:=Trunc(MTime/1440);
            TimeLeft:=Round(MTime-(Days*1440));

            Hrs:=Trunc(TimeLeft/60);

            Mins:=Round(TimeLeft-(Hrs*60));
          end;

    1  :  Begin
            MTime:=Round((Days*1440)+(Hrs*60)+Mins);

          end;
  end;{Case..}
End; { Time2Mins }


{***********************************************************************}
{* Returns the current exchequer version number                        *)
{***********************************************************************}
function TEnterpriseServer.Version : String;
begin
  Result := Branding.pbProductName + ' OLE Server - ' + CurrVersion_OLE;
end;


{***********************************************************************}
{* GetNominalName: Returns the name of the passed nominal code in the  *}
{*                 specified companies data.                           *}
{***********************************************************************}
Function TEnterpriseServer.GetNominalName(Var Company : String;
                                          Var NomCode : LongInt;
                                          Var NomName : String) : SmallInt;
Var
  CompObj : TCompanyInfo;
  oNominal  : TCachedDataRecord;
  bContinue : Boolean;
Begin
  Result := 0;
  NomName := '';

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (487) Then
    Begin
      { Get Nominal Record }
      // MH 23/08/2011 - v6.8 - Added Caching of Nominal Code records
      oNominal := CompObj.NominalCodeCache.GetNominalCode (NomCode);
      If Assigned(oNominal) Then
      Begin
        // Copy details out of cache into LNom record
        oNominal.DownloadRecord (@CompObj.CompanyBtr^.LNom);
        bContinue := True;
      End // If Assigned(oNominal)
      Else
      Begin
        // Lookup nominal and add to cache for next time
        bContinue := GetNominalRec (CompObj.CompanyBtr, NomCode);
        If bContinue Then
          CompObj.NominalCodeCache.AddToCache (CompObj.CompanyBtr^.LNom.NomCode, @CompObj.CompanyBtr^.LNom, SizeOf(NominalRec));
      End; // Else

      //If GetNominalRec (CompObj.CompanyBtr, NomCode) Then
      If bContinue Then
        NomName := CompObj.CompanyBtr.LNom.Desc
      Else
        Result := ErrNom;
    End // If CompObj.CheckSecurity (487)
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End;


{***********************************************************************}
{* GetNominalValue: Returns a value for the specified nominal code in  *}
{*                  the specified companies data. ValueReq indicates   *}
{*                  which of the nominal values is required:           *}
{*                      1   Budget1                                    *}
{*                      2   Budget2 aka Revised Budget 1               *}
{*                      3   Actual (balance, 5-4)                      *}
{*                      4   Debit                                      *}
{*                      5   Credit                                     *}
{*                      6   Cleared                                    *}
// MH 04/05/2016 2016-R2 ABSEXCH-17353: Added Revised Budgets 1-5 to GL History
{*                      7   Revised Budget 2                           *}
{*                      8   Revised Budget 3                           *}
{*                      9   Revised Budget 4                           *}
{*                      10  Revised Budget 5                           *}
{***********************************************************************}
Function TEnterpriseServer.GetNominalValue(Var ValueReq  : SmallInt;
                                           Var Company   : String;
                                           Var TheYear   : SmallInt;
                                           Var ThePeriod : SmallInt; { 0 = YTD }
                                           Var TheCcy    : SmallInt;
                                           Var NomCode   : LongInt;
                                           Var NomCC     : String;
                                           Var NomDept   : String;
                                           Var NomCDType : String;
                                           Var NomValue  : Double;
                                           Var Commited  : SmallInt) : SmallInt;
Var
  Key        : Str255;
  DicLink    : DictLinkType;
  CompObj    : TCompanyInfo;
  IsCC       : Boolean;
  PrYrMode   : Byte;
  BaseOffset : Double;
  NYear, nPeriod : SmallInt;
  CCDept     : CCDepType;
  oNominal   : TCachedDataRecord;
  bContinue  : Boolean;


  { HM 18/3/99: Copied from code supplied by EL from Enterprise }
  { ==== Procedure to check if nom is being added into tha P&L section ==== }
  Function In_PandL(GLCat  :  LongInt)  :  Boolean;
  Const
    Fnum     =  NomF;
    Keypath  =  NomCodeK;
  Var
    KeyS, KeyChk         : Str255;
    FoundOk              : Boolean;
    TmpKPath             : Integer;
    TmpRecAddr, PALStart : LongInt;
    TmpNom               : ^NominalRec;
  Begin { In_PandL }
    With CompObj, CompanyBtr^ Do Begin
      { Save record and position }
      New (TmpNom);
      TmpNom^:=LNom;
      TmpKPath:=GetPosKey;
      LPresrv_BTPos(NomF, TmpKPath, F[NomF], TmpRecAddr, BOff, BOff);

      PALStart:=LSyss.NomCtrlCodes[PLStart];

      FoundOK:=(GLCat=PALStart);

      If (Not FoundOk) Then Begin
        KeyChk:=FullNomKey(GLCat);

        KeyS:=KeyChk;

        Status:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

        While (StatusOk) and (Not FoundOk) do
          With LNom do Begin
            FoundOk:=(Cat=PALStart);


            If (Not FoundOk) then Begin
              KeyChk:=FullNomKey(Cat);

              KeyS:=KeyChk;

              Status:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);
            End; { If }
          End; { With }
      End; { If (Not FoundOk) }

      { Restore Record and position }
      LPresrv_BTPos(NomF,TmpKPath,F[NomF],TmpRecAddr,BOn,BOff);
      LNom:=TmpNom^;
      Dispose (TmpNom);

      Result := FoundOk;
    End; { With CompObj, CompanyBtr^ }
  End; { In_PandL }


Begin
  Result   := 0;
  NomValue := 0.0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (487{20}) Then Begin
      // MH 23/08/2011 - v6.8 - Added Caching of Nominal Code records
      oNominal := CompObj.NominalCodeCache.GetNominalCode (NomCode);
      If Assigned(oNominal) Then
      Begin
        // Copy details out of cache into LNom record
        oNominal.DownloadRecord (@CompObj.CompanyBtr^.LNom);
        bContinue := True;
      End // If Assigned(oNominal)
      Else
      Begin
        // Lookup nominal and add to cache for next time
        bContinue := GetNominalRec (CompObj.CompanyBtr, NomCode);
        If bContinue Then
          CompObj.NominalCodeCache.AddToCache (CompObj.CompanyBtr^.LNom.NomCode, @CompObj.CompanyBtr^.LNom, SizeOf(NominalRec));
      End; // Else

      //If GetNominalRec (CompObj.CompanyBtr, NomCode) Then
      If bContinue Then
      Begin
        // HM 13/09/01: Extended to support combined CC & Dept histroy
        IsCC := (UpperCase(Trim(NomCDType)) = 'C');
        //NomCCDep := UpperCase(Trim(NomCCDep));
        CCDept[BOff] := FullCCDepKey (UpperCase(Trim(NomDept)));
        CCDept[BOn]  := FullCCDepKey (UpperCase(Trim(NomCC)));

        // Check Cost Centre Code if set
        If (Trim(CCDept[BOn]) <> '') Then
          // MH 22/08/2011 - v6.8 - Added Caching of CC/Dept
          //If Not GetCCDepRec (CompObj.CompanyBtr, CCDept[BOn], True) Then
          If Not ValidateCCDeptCode (CompObj, CCDept[BOn], True) Then
            Result := ErrCC;

        // Check Department Code if set
        If (Result = 0) And (Trim(CCDept[BOff]) <> '') Then
          // MH 22/08/2011 - v6.8 - Added Caching of CC/Dept
          //If Not GetCCDepRec (CompObj.CompanyBtr, CCDept[BOff], False) Then
          If Not ValidateCCDeptCode (CompObj, CCDept[BOff], False) Then
              Result := ErrDept;

        If (Result = 0) Then Begin
          BaseOffset := 0.0;
          With CompObj, CompanyBtr^ Do
            { HM 12/03/99: Extended for Control GL Codes }
            {If (LNom.NomType In ['B', 'C']) And (ThePeriod >= 101) And (ThePeriod <= 199) Then Begin}

            { HM 25/05/00: Ignore for budgets as budgets are not accumulated in this way }
            // MH 04/05/2016 2016-R2 ABSEXCH-17353: Added Revised Budgets 1-5 to GL History
            If (ValueReq <> 1) And (ValueReq <> 2) And ((ValueReq < 7) Or (ValueReq > 10)) Then
            Begin
              { HM 18/03/99: Extended for headers }
              If (ThePeriod >= 101) And (ThePeriod <= 199) And (LNom.NomType <> PLNHCode) And (ValueReq > 2) Then Begin
                { Subtract YTD last year for balance sheet and control codes, for headers check that }
                { its not in the P&L section before subtracting                                      }
                If (LNom.NomType In [BankNHCode, CtrlNHCode]) Or ((LNom.NomType = NomHedCode) And (Not In_PandL(NomCode))) Then Begin
                   { CTD Period Offset - need to get rid of previous years YTD total which is carried forward }
                   NYear := Pred(TheYear);
                   nPeriod := 0;
                   GetNominalValue(ValueReq,
                                   Company,
                                   nYear,
                                   nPeriod,
                                   TheCcy,
                                   NomCode,
                                   NomCC,
                                   NomDept,
                                   NomCDType,
                                   BaseOffset,
                                   Commited);
                End; { If }
              End; { If }
            End; // If (ValueReq <> 1) And (ValueReq <> 2) And ((ValueReq < 7) Or (ValueReq > 10))

          { HM 21/02/00: Added support for Commitment Accounting }
          If (Commited <> 0) Then
            //Key := CommitKey + CalcCCKeyHistP(NomCode, IsCC, NomCCDep)
            Key := CommitKey + CalcCCKeyHistP(NomCode, IsCC, CalcCCDepKey(IsCC, CCDept))
          Else
            //Key := CalcCCKeyHistP(NomCode, IsCC, NomCCDep);
            Key := CalcCCKeyHistP(NomCode, IsCC, CalcCCDepKey(IsCC, CCDept));

          (*
          With DicLink Do Begin
            DCr  := TheCcy;
            If (ThePeriod = 0) Then
              DPr := YTD
            Else
              DPr := ThePeriod;
            If (TheYear = 0) Then
              DYr := YTD
            Else
              DYr := TheYear - 1900;
          End; { With }
          *)
          BuildDicLink (CompObj, DicLink, ThePeriod, TheYear, TheCcy, PrYrMode);

          With CompObj, CompanyBtr^ Do
            Case ValueReq Of
              { Budget1 }
              1 : NomValue := GetNomStats(Key, 4, LNom.NomType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
              { Budget2 aka Revised Budget 1 }
              2 : NomValue := GetNomStats(Key, 5, LNom.NomType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
              { Actual (balance, 5-4) }
              3 : NomValue := GetNomStats(Key, 3, LNom.NomType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
              { Debit }
              4 : NomValue := GetNomStats(Key, 1, LNom.NomType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
              { Credit }
              5 : NomValue := GetNomStats(Key, 2, LNom.NomType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
              { Cleared }
              6 : NomValue := GetNomStats(Key, 6, LNom.NomType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;

              // MH 04/05/2016 2016-R2 ABSEXCH-17353: Added Revised Budgets 1-5 to GL History
              // Revised Budget 2
              7  : NomValue := GetNomStats(Key, 7, LNom.NomType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
              // Revised Budget 3
              8  : NomValue := GetNomStats(Key, 8, LNom.NomType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
              // Revised Budget 4
              9  : NomValue := GetNomStats(Key, 9, LNom.NomType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
              // Revised Budget 5
              10 : NomValue := GetNomStats(Key, 10, LNom.NomType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
            End; { Case }
        End; { If }
      End { If }
      Else
        { Invalid nominal code }
        Result := ErrNom;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    { Invalid Company }
    Result := ErrComp;
End;

// CJS 2013-06-18 - ABSEXCH-14012 - OLE performance mods
Function TEnterpriseServer.SQLSaveNominalValue(CompObj    : TCompanyInfo;
                             SetValue  : SmallInt;
                             TheYear   : SmallInt;
                             ThePeriod : SmallInt;
                             TheCcy    : SmallInt;
                             NomCode   : LongInt;
                             CCDept    : String;
                             NomCDType : String; {'C' / 'D' / 'N' }
                             NewValue  : Double) : SmallInt;
var
  SubType: Integer;
  Qry: AnsiString;
begin
  with CompObj.CompanyBtr^ do
  begin
    {
      PROCEDURE [ZZZZ01].[isp_SaveNominalValue](
          @SaveValue  int			    -- 1=Budget1, 2=Budget2
        , @SubType    varchar(1)	-- 0=GL, 1=GL/Cost Centre, 2=GL/Department, 3=GL/CC/Department
        , @GLCode     int
        , @Year			  int
        , @Period			int
        , @Currency		int
        , @CCDep			varchar(6)
        , @NewBudget  float)
    }
    SubType := 0;
    if Trim(NomCDType) <> '' then
      case NomCDType[1] of
        'C' : SubType := 1;
        'D' : SubType := 2;
        'K' : SubType := 3;
      end;
    Qry := Format('exec [COMPANY].isp_SaveNominalValue %d, %d, %d, ' +
                  '%d, %d, %d, ''%s'', %f',
                  [
                    SetValue,
                    SubType,
                    NomCode,
                    TheYear,
                    ThePeriod,
                    TheCCY,
                    CCDept,
                    NewValue
                  ]);
    Result := CompObj.SQLCaller.ExecSQL(Qry, CompObj.CompanyCode);
  end;
end;

{***********************************************************************}
{* SaveNominalValue: Saves NewValue into the specified field of the    *}
{*                   specified Nominal Code in the specified Companies *}
{*                   Data. SetValue indicates which field of the       *}
{*                   Nominal Code to set:                              *}
{*                      1  Budget1                                     *}
// MH 04/05/2016 2016-R2 ABSEXCH-17353: Added Revised Budgets 1-5 to GL History
{*                      2  Budget2 aka Revised Budget 1                *}
{*                      3  Revised Budget 2                            *}
{*                      4  Revised Budget 3                            *}
{*                      5  Revised Budget 4                            *}
{*                      6  Revised Budget 5                            *}
{***********************************************************************}
Function TEnterpriseServer.SaveNominalValue(Var SetValue  : SmallInt;
                                            Var Company   : String;
                                            Var TheYear   : SmallInt;
                                            Var ThePeriod : SmallInt;
                                            Var TheCcy    : SmallInt;
                                            Var NomCode   : LongInt;
                                            Var NomCC     : String;
                                            Var NomDept   : String;
                                            Var NomCDType : String;
                                            Var NewValue  : Double) : SmallInt;
Const
  FNum = NHistF;
  KPath = NHK;
Var
  Key       : Str255;
  CompObj   : TCompanyInfo;
  IsCC      : Boolean;
  YTDPer    : SmallInt;
  CCDept    : CCDepType;
  NewHist   : HistoryRec;
  NomVal    : Double;
  ValueReq  : SmallInt;
  GetPeriod : SmallInt;
  GetYear   : SmallInt;
  GetCommit : SmallInt;

  //PR: 04/07/2012 ABSEXCH-12957
  PreviousRevisedBudget : Double;

  CCDepStr: string;

Procedure UpdateRecVal;
Begin
  With CompObj.CompanyBtr^ Do
    Case SetValue Of
      { Budget }
      1 : LNHist.Budget := NewValue;
      // MH 04/05/2016 2016-R2 ABSEXCH-17353: Added Revised Budgets 1-5 to GL History
      // Budget2 aka Revised Budget 1
      2 : LNHist.RevisedBudget1 := NewValue;
      // Revised Budget 2
      3 : LNHist.RevisedBudget2 := NewValue;
      // Revised Budget 3
      4 : LNHist.RevisedBudget3 := NewValue;
      // Revised Budget 4
      5 : LNHist.RevisedBudget4 := NewValue;
      // Revised Budget 5
      6 : LNHist.RevisedBudget5 := NewValue;
    End; { Case }
End;

//PR: 20/07/2012 ABSEXCH-13183 Moved storing record from below as it needs to be done in different places,
//depending upon whether or not a ytd budget record is being added.
procedure StoreRevisedBudgetChangeRec;
begin
   with CompObj.CompanyBtr^ do
   begin
      //PR: 04/07/2012 ABSEXCH-12957 Store revised budget change record.
      if (LStatus = 0) and (SetValue = 2) then
      begin
        FillChar(LBudgetHistory, SizeOf(LBudgetHistory), 0);
        with LBudgetHistory do
        begin
          bhGLCode      := NomCode;
          bhPeriod      := ThePeriod;
          bhYear        := TheYear - 1900;
          bhCurrency    := TheCCY;
          bhValue       := LNHist.RevisedBudget1;
          bhChange      := bhValue - PreviousRevisedBudget;

          bhDateChanged := FormatDateTime('yyyymmdd', SysUtils.Date);
          bhTimeChanged := FormatDateTime('hhnnss', SysUtils.Time);
          bhUser        := CompObj.UserInfo.Login;

          LAdd_Rec(BudgetHistoryF, 0);

        end;
      end;
   end;
end;

Begin
  PreviousRevisedBudget := 0;
  If (ThePeriod > 0) Then Begin
    If (TheYear > 0) Then Begin
      { Load Company Data }
      Result := BtrList.OpenSaveCompany (Company, CompObj);
      If (Result = 0) Then Begin
        // SSK 30/08/2016 R3 ABSEXCH-12531 : Added condition to validate period
        If ValidatePeriod(ThePeriod, CompObj)  Then {Check Period against System Setup Period}
        Begin
          If CompObj.CheckSecurity (487{20}) Then Begin
            If GetNominalRec (CompObj.CompanyBtr, NomCode) Then Begin
              With CompObj.CompanyBtr^ Do Begin
                // HM 13/09/01: Extended to support combined CC & Dept histroy
                IsCC := (UpperCase(Trim(NomCDType)) = 'C');
                //NomCCDep := UpperCase(Trim(NomCCDep));
                CCDept[BOff] := FullCCDepKey (UpperCase(Trim(NomDept)));
                CCDept[BOn]  := FullCCDepKey (UpperCase(Trim(NomCC)));

                { Check Cost Centre Code if set }
                If (Trim(CCDept[BOn]) <> '') Then
                  If Not GetCCDepRec (CompObj.CompanyBtr, CCDept[BOn], True) Then
                    Result := ErrCC;

                { Check Department Code if set }
                If (Result = 0) And (Trim(CCDept[BOff]) <> '') Then
                  If Not GetCCDepRec (CompObj.CompanyBtr, CCDept[BOff], False) Then
                      Result := ErrDept;

                If (Result = 0) Then Begin
                  // CJS 2013-06-18 - ABSEXCH-14012 - OLE performance mods - SQL
                  //                  version calls stored procedure
                  If SQLUtils.UsingSQL and SQLReportsConfiguration.UseOLESaveNominalBudgetSP Then Begin
                    // SQL version
                    if (NomCDType = 'K') then
                      CCDepStr := LJVar(CCDept[True], ccKeyLen) + LJVar(CCDept[False], ccKeyLen)
                    else
                      CCDepStr := LJVar(CCDept[IsCC], ccKeyLen) + LJVar(CCDept[not IsCC], ccKeyLen);
                    Result := SQLSaveNominalValue(CompObj, SetValue, TheYear,
                               ThePeriod, TheCcy, NomCode, CCDepStr, NomCDType,
                               NewValue);
                  End
                  Else
                  Begin
                    // Btrieve version
                    {Key := FullNHistKey(LNom.NomType,FullNHCode (FullNomKey(NomCode)),TheCcy,TheYear-1900,ThePeriod);}
                    Key := FullNHistKey(LNom.NomType,
                                        FullNHCode (CalcCCKeyHistP(NomCode, IsCC, CalcCCDepKey(IsCC, CCDept))),
                                        TheCcy,
                                        TheYear-1900,
                                        ThePeriod);

                    If (Not LCheckExsists(Key, FNum, KPath)) Then Begin
                      { Record doesn't exist - Set and Add }
                      FillChar (LNHist, SizeOf (LNHist), #0);
                      With LNHist Do Begin
                        {Code := FullNHCode (FullNomKey(NomCode));}
                        Code := FullNHCode (CalcCCKeyHistP(NomCode, IsCC, CalcCCDepKey(IsCC, CCDept)));
                        ExClass := LNom.NomType;
                        Cr := TheCcy;
                        Yr := TheYear - 1900;
                        Pr := ThePeriod;
                      End; { With }

                      UpdateRecVal;

                      LStatus := LAdd_Rec (Fnum, KPath);
                      If Not LStatusOk Then
                        Result := ErrBtrBase + LStatus;

                      //PR: 20/07/2012 ABSEXCH-13183 store revision change before we look for and possibly add ytd record.
                      StoreRevisedBudgetChangeRec;

                      { HM 01/03/00: Check for YTD entry }
                      If (LNom.NomType In YTDSet) Then YTDPer := YTD Else YTDPer := YTDNCF;
                      Key := FullNHistKey(LNom.NomType,
                                          FullNHCode (CalcCCKeyHistP(NomCode, IsCC, CalcCCDepKey(IsCC, CCDept))),
                                          TheCcy,
                                          TheYear-1900,
                                          YTDPer);
                      If (Not LCheckExsists(Key, FNum, KPath)) Then Begin
                        { Record doesn't exist - Set and Add }
                        FillChar (NewHist, SizeOf (NewHist), #0);
                        With NewHist Do Begin
                          Code := FullNHCode (CalcCCKeyHistP(NomCode, IsCC, CalcCCDepKey(IsCC, CCDept)));
                          ExClass := LNom.NomType;
                          Cr := TheCcy;
                          Yr := TheYear - 1900;
                          Pr := YTDPer;

                          // HM 14/12/04: Modified to import previous years balance where appropriate
                          If (LNom.NomType In YTDSet) Then
                          Begin
                            { Dr }
                            GetCommit := 0;
                            GetPeriod := 0;
                            GetYear := TheYear - 1;
                            ValueReq  := 5;
                            If (GetNominalValue(ValueReq, Company, GetYear, GetPeriod, TheCcy, NomCode, NomCc, NomDept, NomCDType, NomVal, GetCommit) = 0) Then
                              Sales := NomVal;
                            {  Cr  }
                            ValueReq := 4;
                            If (GetNominalValue(ValueReq, Company, GetYear, GetPeriod, TheCcy, NomCode, NomCc, NomDept, NomCDType, NomVal, GetCommit) = 0) Then
                              Purchases := NomVal;
                            { Cleared Balance for that Nominal in Cr Currency }
                            ValueReq := 6;
                            If (GetNominalValue(ValueReq, Company, GetYear, GetPeriod, TheCcy, NomCode, NomCc, NomDept, NomCDType, NomVal, GetCommit) = 0) Then
                              Cleared := NomVal;
                          End; // If (LNom.NomType In YTDSet)
                        End; { With }

                        LNHist := NewHist;
                        LStatus := LAdd_Rec (Fnum, KPath);
                        If Not LStatusOk Then
                          Result := ErrBtrBase + LStatus;
                      End; { If (Not LCheckExsists }
                    End { If }
                    Else Begin
                      { found - get rec and update }
                      GLobLocked:=BOff;
                      Ok:=LGetMultiRec(B_GetEq,B_MultLock,Key,KPAth,Fnum,BOn,GlobLocked);
                      {GetMultiRecAddr (B_GetEq,B_MultLock,Key,KPAth,Fnum,BOn,GlobLocked, RecAddr);}
                      LGetRecAddr(FNum);

                      //PR: 04/07/2012 ABSEXCH-12957 Store revised budget change record.
                      PreviousRevisedBudget := LNHist.RevisedBudget1;
                      UpdateRecVal;

                      { update record }
                      LStatus := LPut_Rec (Fnum, KPath);
                      {Status := UnlockMultiSing(F[Fnum], Fnum, RecAddr);
                      Report_BError (FNum, Status);}
                      LUnlockMLock(FNum);
                      If Not LStatusOk Then
                        Result := ErrBtrBase + LStatus;

                      //PR: 20/07/2012 ABSEXCH-13183 store revision change.
                      StoreRevisedBudgetChangeRec;

                    End; { Else }

                    If (Result = 0) And (UpperCase(Trim(NomCDType)) = 'K') Then Begin
                      // Combined Cost Centre and Department - Call again to update Cost Centre records
                      NomCDType := 'C';
                      Result := SaveNominalValue(SetValue,
                                                 Company,
                                                 TheYear,
                                                 ThePeriod,
                                                 TheCcy,
                                                 NomCode,
                                                 NomCC,
                                                 NomDept,
                                                 NomCDType,
                                                 NewValue);
                    End; { If (Result = 0) And (UpperCase(Trim(NomCDType)) = 'K') }
                  End; { If SQLUtils.UsingSQL... }
                End; { If Result = 0... }


                (*
                *)
              End; { With }
            End { If }
            Else
              { Cannot load nominal }
              Result := ErrNom;
          End { If }
          Else
            Result := ErrPermit;
        End { If ValidatePeriod }
        Else
          Result := ErrPeriod;
      End; { If (Result = 0) }
    End { If }
    Else
      { Invalid Year }
      Result := ErrYear;
  End { If }
  Else
    { Invalid Period }
    Result := ErrPeriod;
End;



{***********************************************************************}
{* GetCustName: Returns the name of the specified Customer.            *}
{***********************************************************************}
(* HM 12/05/98 Replaced by GetAcMiscStr
Function TEnterpriseServer.GetCustName (Var Company  : String;
                                        Var CustCode : String;
                                        Var CustName : String) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin
  Result := 0;
  CustName := '';

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (30) Then Begin
      { Get Nominal Record }
      If GetCustRec (CompObj.CompanyBtr, CustCode, True) Then
        CustName := CompObj.CompanyBtr.LCust.Company
      Else
        Result := ErrCust;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End;
*)

{***********************************************************************}
{* GetCustValue: Returns a value for the specified customer code in    *}
{*               the specified companies data. ValueReq indicates      *}
{*               which of the customer values is required:             *}
{*                  0  Balance                                         *}
{*                  1  Net Sales                                       *}
{*                  2  Costs                                           *}
{*                  3  Margin                                          *}
{*                  4  Acc Debit                                       *}
{*                  5  Acc Credit                                      *}
{*                  6  Budget                                          *}
{*                  7  Committed                                       *}
{*                  9  Revised Budget                                  *}
{***********************************************************************}
Function TEnterpriseServer.GetCustValue(Var ValueReq  : SmallInt;
                                        Var Company   : String;
                                        Var TheYear   : SmallInt;
                                        Var ThePeriod : SmallInt;
                                        Var CustCode  : String;
                                        Var CustValue : Double) : SmallInt;
Var
  ChkCr    :  Boolean;
  DicLink  : DictLinkType;
  CompObj  : TCompanyInfo;
  PrYrMode : Byte;
Begin
  Result := 0;

  CustValue := 0.0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then
    If CompObj.CheckSecurity (477{38}) Then Begin
      If GetCustRec (CompObj.CompanyBtr, CustCode, True) Then Begin
        (*With DicLink Do Begin
          DCr  := 0;
          If (ThePeriod = 0) Then
            DPr := YTD
          Else
            DPr := ThePeriod;
          If (TheYear = 0) Then
            DYr := YTD
          Else
            DYr := TheYear - 1900;
        End; { With } *)
        BuildDicLink (CompObj, DicLink, ThePeriod, TheYear, 0, PrYrMode);

        ChkCr := (ValueReq <> 4);

        CustValue := GetCustStats(CompObj.CompanyBtr.LCust.CustCode,
                                  ValueReq,
                                  ChkCr,
                                  DicLink,
                                  CompObj.CompanyBtr,
                                  PrYrMode);
      End { If }
      Else
        Result := ErrCust
    End { If }
    Else
      Result := ErrPermit
  Else
    Result := ErrComp;
End;


{***********************************************************************}
{* SaveCustValue: Saves NewValue into the specified field of the       *}
{*                specified Customer Code in the specified Companies   *}
{*                Data. SetValue indicates which field of the Customer *}
{*                set:                                                 *}
{*                      1  Budget                                      *}
{***********************************************************************}
Function TEnterpriseServer.SaveCustValue(Var SetValue  : SmallInt;
                                         Var Company   : String;
                                         Var TheYear   : SmallInt;
                                         Var ThePeriod : SmallInt;
                                         Var CustCode  : String;
                                         Var NewValue  : Double) : SmallInt;
Const
  FNum = NHistF;
  KPath = NHK;
Var
  Key       : Str255;
  CompObj   : TCompanyInfo;
//  GetPeriod : SmallInt;
//  GetYear   : SmallInt;
//  ValueReq  : SmallInt;
//  CustValue : Double;

  Procedure UpdateRecVal;
  Begin
    With CompObj.CompanyBtr^ Do
      Case SetValue Of
        { Budget }
        1 : LNHist.Budget := NewValue;
        { Budget2 }
        2 : LNHist.RevisedBudget1 := NewValue;
      End; { Case }
  End;

Begin
  If (ThePeriod > 0) Then Begin
    If (TheYear > 0) Then Begin
      { Load Company Data }
      Result := BtrList.OpenSaveCompany (Company, CompObj);
      If (Result = 0) Then Begin
        // SSK 30/08/2016 R3 ABSEXCH-12531 : Added condition to validate period
        If ValidatePeriod(ThePeriod, CompObj)  Then {Check Period against System Setup Period}
        Begin
          If CompObj.CheckSecurity (477{38}) Then Begin
            If GetCustRec (CompObj.CompanyBtr, CustCode, True) Then
              With CompObj.CompanyBtr^ Do Begin
                Key := FullNHistKey(CustHistCde,FullNHCode (FullCustCode(CustCode)),0,TheYear-1900,ThePeriod);

                If (Not LCheckExsists(Key, FNum, KPath)) Then Begin
                  { Record doesn't exist - Set and Add }
                  LResetRec (FNum);
                  With LNHist Do Begin
                    Code := FullNHCode (FullCustCode(CustCode));
                    ExClass := CustHistCde;
                    Cr := 0;
                    Yr := TheYear - 1900;
                    Pr := ThePeriod;
                  End; { With }

                  // MH 21/04/06: Added support for Budget2
                  //LNHist.Budget := NewValue;
                  UpdateRecVal;

                  LStatus := LAdd_Rec (Fnum, KPath);
                  If Not LStatusOk Then
                    Result := ErrBtrBase + LStatus;

                  // HM 21/12/04: Create YTD if missing
                  Key := FullNHistKey(CustHistCde,
                                      FullNHCode (FullCustCode(CustCode)),
                                      0,
                                      TheYear-1900,
                                      YTD);
                  If (Not LCheckExsists(Key, FNum, KPath)) Then Begin
                    LAdd_NHist(CustHistCde,
                               FullNHCode (FullCustCode(CustCode)),
                               0,
                               TheYear - 1900,
                               YTD,
                               NHistF,
                               NHK);

  (***

                    { Record doesn't exist - Set and Add }
                    FillChar (NewHist, SizeOf (NewHist), #0);
                    With NewHist Do Begin
                      Code := FullNHCode (FullCustCode(CustCode));
                      ExClass := CustHistCde;
                      Cr := 0;
                      Yr := TheYear - 1900;
                      Pr := YTD;

  //                    CalcPurgeOB:=True;

                      { Dr }
                      GetPeriod := 0;
                      GetYear := TheYear - 1;
                      ValueReq  := 2; // CRDR[BON]
                      If (GetCustValue(ValueReq, Company, GetYear, GetPeriod, CustCode, CustValue) = 0) Then
                        Sales := CustValue;
                      {  Cr  }
                      ValueReq := 1; // CRDR[BOFF]
                      If (GetCustValue(ValueReq, Company, GetYear, GetPeriod, CustCode, CustValue) = 0) Then
                        Purchases := CustValue;
                      { Cleared Balance for that Nominal in Cr Currency }
                      ValueReq := 8; // Cleared
                      If (GetCustValue(ValueReq, Company, GetYear, GetPeriod, CustCode, CustValue) = 0) Then
                        Cleared := CustValue;

  //                    CalcPurgeOB:=False;
                    End; { With }

                    LNHist := NewHist;
                    LStatus := LAdd_Rec (Fnum, KPath);
                    If Not LStatusOk Then
                      Result := ErrBtrBase + LStatus;
  ***)
                  End; { If (Not LCheckExsists }
                End { If }
                Else Begin
                  { found - get rec and update }
                  GLobLocked:=BOff;
                  Ok:=LGetMultiRec(B_GetEq,B_MultLock,Key,KPAth,Fnum,BOn,GlobLocked);
                  {GetMultiRecAddr (B_GetEq,B_MultLock,Key,KPAth,Fnum,BOn,GlobLocked, RecAddr);}
                  LGetRecAddr(FNum);

                  // MH 21/04/06: Added support for Budget2
                  //LNHist.Budget := NewValue;
                  UpdateRecVal;

                  { update record }
                  LStatus := LPut_Rec (Fnum, KPath);

                  //GS 31/10/2011 Add Audit History Notes for v6.9
                  if LStatus = 0 then
                  begin
                    WriteAuditNote(anAccount, anEdit, CompObj);
                  end;

                  {Status := UnlockMultiSing(F[Fnum], Fnum, RecAddr);
                  Report_BError (FNum, Status);}
                  LUnlockMLock(FNum);
                  If Not LStatusOk Then
                    Result := ErrBtrBase + LStatus;
                End;
              End { With }
            Else
              Result := ErrCust;
          End { If }
          Else
            Result := ErrPermit;
        End { If ValidatePeriod }
        Else
          Result := ErrPeriod;
      End; { If (Result = 0) }
    End { If }
    Else
      Result := ErrYear;
  End { If }
  Else
    Result := ErrPeriod;
End;


{***********************************************************************}
{* GetSuppName: Returns the name of the specified Supplier.            *}
{***********************************************************************}
(* HM 12/05/98 Replaced by GetAcMiscStr
Function TEnterpriseServer.GetSuppName (Var Company  : String;
                                        Var SuppCode : String;
                                        Var SuppName : String) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin
  Result := 0;
  SuppName := '';

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (40) Then Begin
      { Get Nominal Record }
      If GetCustRec (CompObj.CompanyBtr, SuppCode, False) Then
        SuppName := CompObj.CompanyBtr.LCust.Company
      Else
        Result := ErrSupp;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End;
*)

{***********************************************************************}
{* GetSuppValue: Returns a value for the specified supplier code in    *}
{*               the specified companies data. ValueReq indicates      *}
{*               which of the supplier values is required:             *}
{*                  0  Balance                                         *}
{*                  1  Net Sales                                       *}
{*                  2  Costs                                           *}
{*                  3  Margin                                          *}
{*                  4  Acc Debit                                       *}
{*                  5  Acc Credit                                      *}
{*                  6  Budget                                          *}
{*                  9  Revised Budget                                  *}
{***********************************************************************}
Function TEnterpriseServer.GetSuppValue(Var ValueReq  : SmallInt;
                                        Var Company   : String;
                                        Var TheYear   : SmallInt;
                                        Var ThePeriod : SmallInt;
                                        Var SuppCode  : String;
                                        Var SuppValue : Double) : SmallInt;
Var
  ChkCr    : Boolean;
  DicLink  : DictLinkType;
  CompObj  : TCompanyInfo;
  PrYrMode : Byte;
Begin
  Result := 0;
  SuppValue := 0.0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then
    If CompObj.CheckSecurity (482{48}) Then Begin
      If GetCustRec (CompObj.CompanyBtr, SuppCode, False) Then Begin
        {With DicLink Do Begin
          DCr  := 0;
          If (ThePeriod = 0) Then
            DPr := YTD
          Else
            DPr := ThePeriod;
          If (TheYear = 0) Then
            DYr := YTD
          Else
            DYr := TheYear - 1900;
        End; { With }
        BuildDicLink (CompObj, DicLink, ThePeriod, TheYear, 0, PrYrMode);

        ChkCr := (ValueReq = 5);

        SuppValue := GetCustStats(CompObj.CompanyBtr.LCust.CustCode, ValueReq, ChkCr, DicLink, CompObj.CompanyBtr, PrYrMode);
      End { If }
      Else
        Result := ErrSupp
    End { If }
    Else
      Result := ErrPermit
  Else
    Result := ErrComp;
End;

{***********************************************************************}
{* SaveSuppValue: Saves NewValue into the specified field of the       *}
{*                specified supplier Code in the specified Companies   *}
{*                Data. SetValue indicates which field of the supplier *}
{*                is set:                                              *}
{*                      1  Budget                                      *}
{***********************************************************************}
Function TEnterpriseServer.SaveSuppValue(Var SetValue  : SmallInt;
                                         Var Company   : String;
                                         Var TheYear   : SmallInt;
                                         Var ThePeriod : SmallInt;
                                         Var SuppCode  : String;
                                         Var NewValue  : Double) : SmallInt;
Const
  FNum = NHistF;
  KPath = NHK;
Var
  Key     : Str255;
  CompObj : TCompanyInfo;

  Procedure UpdateRecVal;
  Begin
    With CompObj.CompanyBtr^ Do
      Case SetValue Of
        { Budget }
        1 : LNHist.Budget := NewValue;
        { Budget2 }
        2 : LNHist.RevisedBudget1 := NewValue;
      End; { Case }
  End;

Begin
  If (ThePeriod > 0) Then
    If (TheYear > 0) Then Begin
      { Load Company Data }
      Result := BtrList.OpenSaveCompany (Company, CompObj);
      If (Result = 0) Then
      begin
        // SSK 30/08/2016 R3 ABSEXCH-12531 : Added condition to validate period
        If ValidatePeriod(ThePeriod, CompObj)  Then {Check Period against System Setup Period}
        Begin
          If CompObj.CheckSecurity (482{48}) Then Begin
            If GetCustRec (CompObj.CompanyBtr, SuppCode, False) Then Begin
              With CompObj.CompanyBtr^ Do Begin
                Key := FullNHistKey(CustHistCde,FullNHCode (FullCustCode(SuppCode)),0,TheYear-1900,ThePeriod);

                If (Not LCheckExsists(Key, FNum, KPath)) Then Begin
                  { Record doesn't exist - Set and Add }
                  LResetRec (FNum);
                  With LNHist Do Begin
                    Code := FullNHCode (FullCustCode(SuppCode));
                    ExClass := CustHistCde;
                    Cr := 0;
                    Yr := TheYear - 1900;
                    Pr := ThePeriod;
                  End; { With }

                  // MH 21/04/06: Added support for Budget2
                  //LNHist.Budget := NewValue;
                  UpdateRecVal;

                  Status := LAdd_Rec (Fnum, KPath);
                  If Not LStatusOk Then
                    Result := ErrBtrBase + LStatus;

                  // HM 21/12/04: Create YTD if missing
                  Key := FullNHistKey(CustHistCde,
                                      FullNHCode (FullCustCode(SuppCode)),
                                      0,
                                      TheYear-1900,
                                      YTD);
                  If (Not LCheckExsists(Key, FNum, KPath)) Then
                  Begin
                    LAdd_NHist(CustHistCde,
                               FullNHCode (FullCustCode(SuppCode)),
                               0,
                               TheYear - 1900,
                               YTD,
                               NHistF,
                               NHK);
                  End; // If (Not LCheckExsists(Key, FNum, KPath))
                End { If }
                Else Begin
                  { found - get rec and update }
                  GLobLocked:=BOff;
                  Ok:=LGetMultiRec(B_GetEq,B_MultLock,Key,KPAth,Fnum,BOn,GlobLocked);
                  {GetMultiRecAddr (B_GetEq,B_MultLock,Key,KPAth,Fnum,BOn,GlobLocked, RecAddr);}
                  LGetRecAddr(FNum);

                  // MH 21/04/06: Added support for Budget2
                  //LNHist.Budget := NewValue;
                  UpdateRecVal;

                  { update record }
                  LStatus := LPut_Rec (Fnum, KPath);

                  //GS 31/10/2011 Add Audit History Notes for v6.9
                  if LStatus = 0 then
                  begin
                    WriteAuditNote(anAccount, anEdit, CompObj);
                  end;

                  {Status := UnlockMultiSing(F[Fnum], Fnum, RecAddr);
                  Report_BError (FNum, Status);}
                  LUnlockMLock(FNum);
                  If Not LStatusOk Then
                    Result := ErrBtrBase + LStatus;
                End;
              End; { With }
            End { If }
            Else
              Result := ErrSupp
          End { If }
          Else
            Result := ErrPermit;
        End { If ValidatePeriod }
        Else
          Result := ErrPeriod;
      end;
    End { If }
    Else
      Result := ErrYear
  Else
    Result := ErrPeriod;
End;


{***********************************************************************}
{* GetStockValue: Returns a value for the specified stock, from the    *}
{*                specified companies data. ValueReq indicates which   *}
{*                of the stock values is required:                     *}
{*                  1  Qty Sold                                        *}
{*                  2  Sales                                           *}
{*                  3  Costs                                           *}
{*                  4  Margin                                          *}
{*                  5  Budget                                          *}
{*                  6  Budget2                                         *}
{*                  10 Posted Stock Level                              *}
{*                  11 Qty Used                                        *}
{***********************************************************************}
Function TEnterpriseServer.GetStockValue (Var ValueReq  : SmallInt;
                                          Var Company   : String;
                                          Var TheYear   : SmallInt;
                                          Var ThePeriod : SmallInt;
                                          Var TheCcy    : SmallInt;
                                          Var StockId   : String;
                                          Var LocCode   : String;
                                          Var StockVal  : Double) : SmallInt;
Var
  DicLink  : DictLinkType;
  CompObj  : TCompanyInfo;
  PrYrMode : Byte;
  NYear, NPeriod : SmallInt;
  BaseOffset : Double;
Begin
  Result := 0;
  StockVal := 0.0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then
    If CompObj.CheckSecurity (490{108}) Then Begin
      { Get Stock Record }
      If GetStockRec (CompObj.CompanyBtr, StockId) Then Begin
        { Check location code }
        LocCode := UpperCase(Trim(LocCode));
        If (LocCode <> '') Then Begin
          If GetLocRec (CompObj.CompanyBtr, LocCode) Then
            LocCode := CompObj.CompanyBtr.LMLoc^.MLocLoc.loCode
          Else
            Result := ErrLoc;
        End; { If }

        If (Result = 0) Then
        Begin
          // MH 21/03/07: Added section for Qty Used to subtract previous years YTD for periods 101-199 as
          // they are accumulating the previous years whereas periods 1-99 don't
          BaseOffset := 0.0;
          If (ThePeriod >= 101) And (ThePeriod <= 199) And (ValueReq = 11) Then
          Begin
             { CTD Period Offset - need to get rid of previous years YTD total which is carried forward }
             NYear := Pred(TheYear);
             nPeriod := 0;
             GetStockValue(ValueReq,
                             Company,
                             nYear,
                             nPeriod,
                             TheCcy,
                             StockId,
                             LocCode,
                             BaseOffset);
          End; // If (ThePeriod >= 101) And (ThePeriod <= 199) And (ValueReq = 11)

          {With DicLink Do Begin
            DCr  := TheCcy;
            If (ThePeriod = 0) Then
              DPr := YTD
            Else
              DPr := ThePeriod;
            If (TheYear = 0) Then
              DYr := YTD
            Else
              DYr := TheYear - 1900;
          End; { With }
          BuildDicLink (CompObj, DicLink, ThePeriod, TheYear, TheCcy, PrYrMode);

          With CompObj, CompanyBtr^ Do
            {StockVal := GetStkStats(FullNomKey(LStock.StockFolio),
                                    ValueReq,
                                    LStock.StockType,
                                    DicLink,
                                    CompanyBtr);}
            StockVal := GetStkStats(CalcKeyHist(LStock.StockFolio, LocCode),
                                    ValueReq,
                                    LStock.StockType,
                                    DicLink,
                                    CompanyBtr,
                                    PrYrMode) - BaseOffset;
        End; { If }
      End { If }
      Else
        Result := ErrStock;
    End { If }
    Else
      Result := ErrPermit
  Else
    Result := ErrComp;
End;


{***********************************************************************}
{* SaveStockValue: Saves NewValue into the specified field of the      *}
{*                 specified stock Code in the specified Companies     *}
{*                 Data. SetValue indicates which field of the stock   *}
{*                 is set:                                             *}
{*                    1  Budget                                        *}
{*                    2  Budget2                                        *}
{***********************************************************************}
Function TEnterpriseServer.SaveStockValue (Var SetValue  : SmallInt;
                                           Var Company   : String;
                                           Var TheYear   : SmallInt;
                                           Var ThePeriod : SmallInt;
                                           Var TheCcy    : SmallInt;
                                           Var StockId   : String;
                                           Var LocCode   : String;
                                           Var NewValue  : Double) : SmallInt;
Const
  FNum = NHistF;
  KPath = NHK;
Var
  Key     : Str255;
//  RecAddr : LongInt;
  CompObj : TCompanyInfo;
Begin
  If (ThePeriod > 0) Then Begin
    If (TheYear > 0) Then Begin
      { Load Company Data }
      Result := BtrList.OpenSaveCompany (Company, CompObj);
      If (Result = 0) Then Begin
        // SSK 30/08/2016 R3 ABSEXCH-12531 : Added condition to validate period
        If ValidatePeriod(ThePeriod, CompObj)  Then {Check Period against System Setup Period}
        Begin
          If CompObj.CheckSecurity (492{109}) Then Begin
            If GetStockRec (CompObj.CompanyBtr, StockId) Then Begin
              { Check location code }
              LocCode := UpperCase(Trim(LocCode));
              If (LocCode <> '') Then Begin
                If GetLocRec (CompObj.CompanyBtr, LocCode) Then
                  LocCode := CompObj.CompanyBtr.LMLoc^.MLocLoc.loCode
                Else
                  Result := ErrLoc;
              End; { If }

              If (Result = 0) Then
                With CompObj.CompanyBtr^ Do Begin
                  {Key := FullNHistKey(LStock.StockType,
                                      FullNHCode (FullNomKey(LStock.StockFolio)),
                                      TheCcy,
                                      TheYear-1900,
                                      ThePeriod);}
                  Key := FullNHistKey(LStock.StockType,
                                      FullNHCode (CalcKeyHist(LStock.StockFolio, LocCode)),
                                      TheCcy,
                                      TheYear-1900,
                                      ThePeriod);

                  If (Not LCheckExsists(Key, FNum, KPath)) Then Begin
                    { Record doesn't exist - Set and Add }
                    LResetRec (FNum);
                    With LNHist Do Begin
                      {Code := FullNHCode (FullNomKey(LStock.StockFolio));}
                      Code := FullNHCode (CalcKeyHist(LStock.StockFolio, LocCode));
                      ExClass := LStock.StockType;
                      Cr := TheCcy;
                      Yr := TheYear - 1900;
                      Pr := ThePeriod;
                    End; { With }

                    If (SetValue = 1) Then
                      LNHist.Budget := NewValue
                    Else
                      LNHist.RevisedBudget1 := NewValue;

                    LStatus := LAdd_Rec (Fnum, KPath);
                    If Not LStatusOk Then
                      Result := ErrBtrBase + LStatus;
                  End { If }
                  Else Begin
                    { found - get rec and update }
                    GLobLocked:=BOff;
                    Ok:=LGetMultiRec(B_GetEq,B_MultLock,Key,KPAth,Fnum,BOn,GlobLocked);
                    {GetMultiRecAddr (B_GetEq,B_MultLock,Key,KPAth,Fnum,BOn,GlobLocked, RecAddr);}
                    LGetRecAddr(FNum);

                    If (SetValue = 1) Then
                      LNHist.Budget := NewValue
                    Else
                      LNHist.RevisedBudget1 := NewValue;

                    { update record }
                    LStatus := LPut_Rec (Fnum, KPath);

                    //GS 31/10/2011 Add Audit History Notes for v6.9
                    if LStatus = 0 then
                    begin
                      WriteAuditNote(anStock, anEdit, CompObj);
                    end;

                    {Status := UnlockMultiSing(F[Fnum], Fnum, RecAddr);}
                    LUnlockMLock(FNum);
                    If Not LStatusOk Then
                      Result := ErrBtrBase + LStatus;
                  End;
                End { With }
            End { If }
            Else
              Result := ErrStock;
          End { If }
          Else
            Result := ErrPermit;
        End { If ValidatePeriod }
        Else
          Result := ErrPeriod;
      End; { If (Result = 0) }
    End { If }
    Else
      Result := ErrYear;
  End { If }
  Else
    Result := ErrPeriod;
End;


{***********************************************************************}
{* AddNomTransfer: Adds a Nominal Transfer between FromGL and ToGL of  *}
{*                 NewValue. Can be used for a Fixed Asset Register    *}
{*                 in Excel.                                           *}
{***********************************************************************}
Function TEnterpriseServer.AddNomTransfer  (Var Company    : String;
                                            Var TheYear    : SmallInt;
                                            Var ThePeriod  : SmallInt;
                                            Var TheCcy     : SmallInt;
                                            Var FromGL     : LongInt;
                                            Var ToGL       : LongInt;
                                            Var CostCentre : String;
                                            Var Dept       : String;
                                            Var JobCode    : String;
                                            Var AnalCode   : String;
                                            Var Descr      : String;
                                            Var NewValue   : Double) : SmallInt;
Const
  FNum    = IDetailF;
  KeyPath = IdFolioK;

Var
  I         : Integer;
  Done      : Boolean;
  CompObj : TCompanyInfo;

  { Adds te Nominal Transfer Header record }
  Procedure CreateNomHed;
  Const
    Fnum       =  InvF;
    Keypath    =  InvRNoK;
  Begin
    With CompObj, CompanyBtr^ Do Begin
      LResetRec(Fnum);

      With LInv do Begin
        NomAuto:=BOn;

        InvDocHed:=NMT;

        TransDate := Today;
        AcPr      := ThePeriod;
        AcYr      := TxlateYrVal(TheYear,BOn);

        TransDesc := Descr;

        (* 24/09/03: Modified on EL's instruction to set to 0 for Pro and 1 for Euro/Global
        Currency  := TheCcy;
        CXrate:=LSyssCurr.Currencies[Currency].CRates;
        SetTriRec (Currency, UseORate, CurrTriR);   { HM 15/12/99 - v4.31 }

        // 15/04/99: Added setting of VATCRate and Origrates
        VATCRate  := CXrate;
        OrigRates := CXrate;
        SetTriRec (Syss.VATCurr, UseORate, VATTriR); { HM 15/12/99 - v4.31 }
        SetTriRec (Currency, UseORate, OrigTriR);    { HM 15/12/99 - v4.31 }
        *)

        // 24/09/03: Modified on EL's instruction to set to 0 for Pro and 1 for Euro/Global
        If IsMultiCcy Then
          Currency   := 1
        Else
          Currency   := 0;
        CXrate[BOff] := 1;
        CXrate[BOn]  := 1;
        VATCRate     := CXrate;
        OrigRates    := CXrate;

        { HM 15/12/99 - v4.31 }
        SetTriRec (0,            UseORate, CurrTriR);  { Note: EL Said to use 0 }
        SetTriRec (Syss.VATCurr, UseORate, VATTriR);
        SetTriRec (0,            UseORate, OrigTriR);

        // MH 13/04/06: Corrected NEXT line number field
        //ILineCount := 2;
        ILineCount := 3;

        // MH 28/10/2013 v7.0.7 ABSEXCH-14705: Added Transaction Originator fields
        SetOriginator(LInv);

        LSetNextDocNos(LInv,BOn);

        LStatus:=LAdd_Rec(Fnum,KeyPath);

        //GS 31/10/2011 Add Audit History Notes for v6.9
        if LStatus = 0 then
        begin
          WriteAuditNote(anTransaction, anCreate, CompObj);
        end;

        {Report_BError(FNum, Status);}
      End; { With }
    End; { With }
  End;

  { adds the 2 transfer lines to the nom }
  Procedure CreateNomLines;
  Begin
    With CompObj.CompanyBtr^ Do Begin
      LResetRec(IDetailF);

      With LId do Begin
        DocPRef := LInv.OurRef;
        FolioRef := LInv.FolioNum;

        LineNo:=RecieptCode;

        Desc := LInv.TransDesc;

        Qty:=1;
        QtyMul := 1;          { HM 15/12/99 - v4.31 }
        PriceMulX := 1.0;     { HM 15/12/99 - v4.31 }

        // 24/09/03: Modified due to changes for currency/rates on header
        //Currency := LInv.Currency;
        Currency := TheCcy;

        // 24/09/03: Modified due to changes for currency/rates on header
        //CXRate:=LInv.CXRate;  { HM 15/12/99 - v4.31 }
        CXrate:=LSyssCurr.Currencies[Currency].CRates;
        SetTriRec (Currency, UseORate, CurrTriR);

        PYr:=LInv.ACYr;
        PPr:=LInv.AcPr;

        Payment:=SetRPayment(LInv.InvDocHed);

        If (LSyss.AutoClearPay) then
          Reconcile:=ReconC;

        IDDocHed:=LInv.InvDocHed;

        PDate:=LInv.TransDate;

        If CompObj.CompanyBtr.LSyss.UseCCDep Then Begin
          CCDep[BOn]  := FullCCDepKey(CostCentre);
          CCDep[BOff] := FullCCDepKey(Dept);
        End; { If }
      End; { With }

      LId.JobCode  := FullJobCode(JobCode);
      LId.AnalCode := FullJACode(AnalCode);
    End; { With }
  End;

Begin
  Result := 0;

  For I := 1 To 11 Do Begin
    Case I OF
      1  : Begin { Company }
             Result := BtrList.OpenSaveCompany (Company, CompObj);
             If (Result = 0) Then Begin
               If Not CompObj.CheckSecurity (488{25}) Then
                 Result := ErrPermit
             End; { If (Result = 0) }
           End;

      2  : Begin { Year }
           End;

      3  : Begin { Period }
             If (ThePeriod < 1) Or (ThePeriod > CompObj.CompanyBtr.LSyss.PrInYr) Then
               Result := ErrPeriod;
           End;

      4  : Begin { Currency }
             (* HM 15/09/98: Modified as OLE Server doesn't use Compiler Definitions
             {$IFDEF MC_ON}
               If Not (TheCCy In [1..29]) Then
             {$ELSE}
               If (TheCcy <> 0) Then
             {$ENDIF}
                 Result := ErrCcy;
             *)
             If CompObj.IsMultiCcy Then Begin
               { Multi-Currency Company }
               If Not (TheCCy In [1..CurrencyType]) Then
                 Result := ErrCcy;
             End { If }
             Else Begin
               { Single Currency Company }
               If (TheCcy <> 0) Then
                 Result := ErrCcy;
             End; { Else }
           End;

      5  : With CompObj, CompanyBtr^ Do Begin { FromGL }
             Result := ErrFromGL;
             If GetNominalRec (CompanyBtr, FromGL) And
                ((Not (LNom.NomType In [CtrlNHCode, CarryFlg, NomHedCode])) And (LNom.HideAC <> 1)) Then
             Begin
               { HM 15/12/99 - v4.31 - Added Checking of GL Currency }
               If (TheCCy=LNom.DefCurr) or (LNom.DefCurr=0) or (TheCCy=0) Then
                 Result := 0;

               // HM 22/10/03: Extended to check the Force JC flag
               If LNom.ForceJC Then
               Begin
                 // Job Code & Analysis Code must be specified
                 If (Trim(JobCode) = '') Then
                 Begin
                   Result := ErrJobCode;
                 End // If (Trim(JobCode) = '')
                 Else
                 Begin
                   If (Trim(AnalCode) = '') Then
                   Begin
                     Result := ErrJobAnal;
                   End // If (Trim(JobCode) = '')
                 End; // Else
               End; // If LNom.ForceJC
             End; // If GetNominalRec (...
           End;

      6  : With CompObj, CompanyBtr^ Do Begin { ToGL }
             Result := ErrToGL;
             If GetNominalRec (CompanyBtr, ToGL) And
                ((Not (LNom.NomType In [CtrlNHCode, CarryFlg, NomHedCode])) And (LNom.HideAC <> 1)) Then
             Begin
               { HM 15/12/99 - v4.31 - Added Checking of GL Currency }
               If (TheCCy=LNom.DefCurr) or (LNom.DefCurr=0) or (TheCCy=0) Then
                 Result := 0;

               // HM 22/10/03: Extended to check the Force JC flag
               If LNom.ForceJC Then
               Begin
                 // Job Code & Analysis Code must be specified
                 If (Trim(JobCode) = '') Then
                 Begin
                   Result := ErrJobCode;
                 End // If (Trim(JobCode) = '')
                 Else
                 Begin
                   If (Trim(AnalCode) = '') Then
                   Begin
                     Result := ErrJobAnal;
                   End // If (Trim(JobCode) = '')
                 End; // Else
               End; // If LNom.ForceJC
             End; // If GetNominalRec (...
           End;

      {$IFDEF PF_On}
      7  : If CompObj.CompanyBtr.LSyss.UseCCDep Then Begin { Cost Centre }
             Result := ErrCC;
             If GetCCDepRec (CompObj.CompanyBtr, CostCentre, BOn) Then
             begin
               If (CompObj.CompanyBtr^.LPassword.CostCtrRec.HideAC=1) then
               begin
                 Result := ErrInactiveCC   // PL 30/08/2016 R3 ABSEXCH-15689 : Added code to check inactive CC / Dept
               end
               else
                 Result := 0;
             end;
           End;

      8  : If CompObj.CompanyBtr.LSyss.UseCCDep Then Begin { Department }
             Result := ErrDept;
             If GetCCDepRec (CompObj.CompanyBtr, Dept, BOff) Then
             begin
               If (CompObj.CompanyBtr^.LPassword.CostCtrRec.HideAC=1) then
               begin
                 Result := ErrInactiveDept   // PL 30/08/2016 R3 ABSEXCH-15689 : Added code to check inactive CC / Dept
               end
               else
                 Result := 0;
             end;
           End;

      { Job Code }
      9  : If (Trim(JobCode) <> '') Or (Trim(AnalCode) <> '') Then Begin
             Result := ErrJobCode;
             If (Trim(JobCode) <> '') Then Begin
               { Its an error if Anal is set and job isn't }
               If GetJobRec (CompObj.CompanyBtr, JobCode) Then Begin
                 { Check its not a contract }
                 If (CompObj.CompanyBtr.LJobRec.JobType = JobJobCode) Then Begin
                   { HM 07/08/00: Check Job is not closed }
                   If (CompObj.CompanyBtr.LJobRec.JobStat <> 5) Then
                     Result := 0
                   Else
                     Result := ErrJobClosed;
                 End; { If (LJobRec.JobType = JobJobCode) }
               End; { If GetJobRec (CompObj.CompanyBtr, JobCode) }
             End; { If (Trim(JobCode) <> '') }
           End;

      { Job Analysis Code }
      10 : If (Trim(JobCode) <> '') Or (Trim(AnalCode) <> '') Then Begin
             Result := ErrJobAnal;
             If (Trim(AnalCode) <> '') Then Begin
               { Its an error if job is set and anal isn't }
               If GetJobMiscRec (CompObj.CompanyBtr, AnalCode, 2) Then Begin
                 Result := 0;
               End; { If }
             End; { If (Trim(AnalCode) <> '') }
           End;
      {$ENDIF}

      11 : With CompObj.CompanyBtr^ Do Begin { AOK - Add Nominal Transfer }
             CreateNomHed;

             If LStatusOk Then Begin
               CreateNomLines;

               With LId Do Begin
                 Done := True;

                 { From }
                 AbsLineNo := 1;
                 NetValue := NewValue;
                 NomCode := FromGL;

                 Repeat
                   LStatus := LAdd_Rec(FNum, KeyPath);
                   {Report_BError(FNum, Status);}

                   { HM 17/06/99: Added to update Job Costing }
                   LUpdate_JobAct(LId, LInv);

                   AbsLineNo := 2;
                   NomCode := ToGL;
                   NetValue := NetValue * DocNotCnst;

                   Done := (Not Done);
                 Until Done Or (Not LStatusOk);
               End; { With }
             End; { If }
           End;
    End; { Case }

    If (Result <> 0) Then Break;
  End; { For }
End;


{***********************************************************************}
{* GetStockMiscStr: Returns a string value from the specified stock    *}
{*                 record. The value returned is specified using the   *}
{*                 MiscStrNo parameter, values are:                    *}
{*                                                                     *}
{*                   1  : Description line 1                           *}
{*                   2  : Description line 2                           *}
{*                   3  : Description line 3                           *}
{*                   4  : Description line 4                           *}
{*                   5  : Description line 5                           *}
{*                   6  : Description line 6                           *}
{*                   7  : AltCode                                      *}
{*                   8  : Unit Of Stock                                *}
{*                   9  : Unit Of Sale                                 *}
{*                   10 : Unit Of Purchase                             *}
{*                   11 : User Field 1                                 *}
{*                   12 : User Field 2                                 *}
{*                   13 : Preferred Supplier                           *}
{*                   14 : Bar Code                                     *}
{*                   15 : Commodity Code                               *}
{*                   16 : SSD Unit Description                         *}
{*                                                                     *}
{*                   HM 26/10/99: v4.31 fields added                   *}
{*                   17 : User Field 3                                 *}
{*                   18 : User Field 4                                 *}
{*                   19 : Job Analysis Code;                           *}
{*                   20 : Default VAT Code;                            *}
{*                   21 : Default Location                             *}
{*                   22 : Bin Location                                 *}
{*                   23 : Department                                   *}
{*                   24 : Cost Centre                                  *}
{*                   25 : Include On Web                               *}
{*                   26 : Web Live Category                            *}
{*                   27 : SSD Country                                  *}
{*                   28 : Image File                                   *}
{*                   29 : Stock Category                               *}
{*                                                                     *}
{*                   HM 25/06/02: Added WOP Support                    *}
{*                   30 : Auto Calc Prod Time                          *}
{*                                                                     *}
{*                   31 : Stock Valuation Method                       *}
{*                                                                     *}
{*                   HM 01/08/05: Added Returns Support                *}
{*                   32 : Sales Warranty                               *}
{*                   33 : Manufacturer Warranty                        *}
{*                   34 : Restock Charge %/Amount                      *}
{*                   //GS 27/10/2011 ABSEXCH-11706:                    *}
{*                   //added support for UDEFs 6-10                    *}
{*                   39 : User Field 5                                 *}
{*                   40 : User Field 6                                 *}
{*                   41 : User Field 7                                 *}
{*                   42 : User Field 8                                 *}
{*                   43 : User Field 9                                 *}
{*                   44 : User Field 10                                 *}
{***********************************************************************}
Function TEnterpriseServer.GetStockMiscStr (Var Company   : String;
                                            Var StockId   : String;
                                            Var LocCode   : String;
                                            Var MiscStrNo : SmallInt;
                                            Var MiscStr   : String) : SmallInt;
Const
  WarrantyChars : Array [0..3] Of Char = ('D', 'W', 'M', 'Y');
Var
  CompObj : TCompanyInfo;
  GotLoc  : Boolean;

  Function IIF (Const Want1          : Boolean;
                Const Param1, Param2 : ShortString) : ShortString;
  Begin
    If Want1 Then
      Result := Param1
    Else
      Result := Param2;
  End;

Begin
  Result := 0;
  MiscStr := '';

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (489{108}) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        { Get Stock Record }
        If GetStockRec (CompanyBtr, StockId) Then Begin
          { Check location code }
          GotLoc := False;
          LocCode := UpperCase(Trim(LocCode));
          If (LocCode <> '') Then Begin
            { Get Location Record }
            If GetLocRec (CompanyBtr, LocCode) Then Begin
              { Got Location }
              LocCode := LMLoc^.MLocLoc.loCode;
              GotLoc := True;

              { Get Stock/Location XRef record }
              GetStkLocRec (CompanyBtr, False);
            End { If }
            Else Begin
              Result := ErrLoc;
              FillChar (LMStkLoc^, SizeOf (LMStkLoc^), #0);
            End; { Else }
          End; { If }

          Case MiscStrNo Of
            1..6  : MiscStr := LStock.Desc[MiscStrNo];
            7     : MiscStr := LStock.AltCode;
            8     : MiscStr := LStock.UnitK;
            9     : MiscStr := LStock.UnitS;
            10    : MiscStr := LStock.UnitP;
            11    : MiscStr := LStock.StkUser1;
            12    : MiscStr := LStock.StkUser2;
            13    : MiscStr := IIF (GotLoc And LMLoc.MLocLoc.loUseSupp,
                                    LMStkLoc.MStkLoc.lsSupplier,
                                    LStock.Supplier);
            14    : MiscStr := LStock.BarCode;
            15    : MiscStr := LStock.CommodCode;
            16    : MiscStr := LStock.UnitSupp;

            { HM 26/10/99: v4.31 fields added }
            17    : MiscStr := LStock.StkUser3;
            18    : MiscStr := LStock.StkUser4;
            19    : MiscStr := LStock.JAnalCode;

            // MH 24/11/05: Modified VAT Code behaviour so that Inclusive VAT Codes are returned as 'IS'
            //20    : MiscStr := LStock.VATCode;
            20    : MiscStr := GetVATCodeDesc (LStock.VATCode, LStock.SVATIncFlg);

            21    : MiscStr := LStock.DefMLoc;
            22    : MiscStr := IIF (GotLoc, LMStkLoc.MStkLoc.lsBinLoc, LStock.BinLoc);
            23    : MiscStr := IIF (GotLoc And LMLoc^.MLocLoc.loUseCCDep,
                                    LMStkLoc.MStkLoc.lsCCDep[False],
                                    LStock.CCDep[False]); { Dept }
            24    : MiscStr := IIF (GotLoc And LMLoc^.MLocLoc.loUseCCDep,
                                    LMStkLoc.MStkLoc.lsCCDep[True],
                                    LStock.CCDep[True]);  { CC }
            25    : MiscStr := YesNoBo(LStock.WebInclude=1);
            26    : MiscStr := LStock.WebLiveCat;                  { Web current catalogue entry }
                    // MH 18/01/2016 2016-R1 ABSEXCH-17099: Removed Country of Origin from Stock Record for UK Companies
            27    : If (Syss.USRCntryCode <> UKCCode) Then
                      MiscStr := LStock.SSDCountry                 { Intrastat Country of origin }
                    Else
                      MiscStr := '';
            28    : MiscStr := LStock.ImageFile;                   { Associated bitmap image }
            29    : MiscStr := LStock.StockCat;

            // HM 25/06/02: Added WOP Support
            30    : MiscStr := YesNoBo(LStock.CalcProdTime);

            // HM 17/06/04: Added Stock Valuation method
            31    : Case LStock.StkValType Of
                      'A' : MiscStr := 'Average';
                      'C' : MiscStr := 'Last Cost';
                      'F' : MiscStr := 'FIFO';
                      'L' : MiscStr := 'LIFO';
                      'R' : If (LStock.SerNoWAvg = 1) Then
                              MiscStr := 'Serial/Batch Average Cost'
                            Else
                              MiscStr := 'Serial/Batch';
                      'S' : MiscStr := 'Standard';
                    Else
                      MiscStr := 'Unknown Valuation Method, please notify your Techical Support';
                    End; { Case }

            // MH 01/08/05: Added Goods Returns functionality for 5.70
            // Sales Warranty
            32    : Begin
                      If GotLoc Then
                        MiscStr := IntToStr(LMStkLoc.MStkLoc.lsSWarranty) + WarrantyChars[LMStkLoc.MStkLoc.lsSWarrantyType]
                      Else
                        MiscStr := IntToStr(LStock.SWarranty) + WarrantyChars[LStock.SWarrantyType];
                    End; // Sales Warranty
            // Manufacturer Warranty
            33    : Begin
                      If GotLoc Then
                        MiscStr := IntToStr(LMStkLoc.MStkLoc.lsMWarranty) + WarrantyChars[LMStkLoc.MStkLoc.lsMWarrantyType]
                      Else
                        MiscStr := IntToStr(LStock.MWarranty) + WarrantyChars[LStock.MWarrantyType];
                    End; // Manufacturer Warranty
            // Restock Charge %/Amount
            34    : Begin
                      If (LStock.ReStockPChr = '%') Then
                        MiscStr := FormatFloat(GenPcnt2dMask,LStock.ReStockPcnt*100)
                      Else
                        MiscStr := FormatFloat(GenProfileMask,LStock.ReStockPcnt);
                    End; // Restock Charge %/Amount

             // Re-Order Supplier
             35   : Begin
                      If GotLoc Then
                        MiscStr := CompObj.CompanyBtr^.LMStkLoc^.MStkLoc.lsTempSupp
                      Else
                        MiscStr := LStock.SuppTemp
                    End; // Re-Order Supplier

             // Re-Order CostCentre/Department
             36,
             37   : Begin
                      If GotLoc Then
                        MiscStr := CompObj.CompanyBtr^.LMStkLoc^.MStkLoc.lsROCCDep[(MiscStrNo=37)]
                      Else
                        MiscStr := CompObj.CompanyBtr^.LStock.ROCCDep[(MiscStrNo=37)];
                    End; // Re-Order CostCentre/Department

             // Stock Type
             38   : Begin
                      Case LStock.StockType Of
                        'G' : MiscStr := 'Group';
                        'P' : MiscStr := 'Product';
                        'D' : MiscStr := 'Description Only';
                        'M' : MiscStr := 'Bill Of Materials';
                        'X' : MiscStr := 'Discontinued';
                      Else
                        MiscStr := 'Unknown';
                      End; // Case LStock.StockType
                    End; // Stock Type
            //GS 27/10/2011 ABSEXCH-11706:
            //added support for UDEFs 6-10
            39    : MiscStr := LStock.StkUser5;
            40    : MiscStr := LStock.StkUser6;
            41    : MiscStr := LStock.StkUser7;
            42    : MiscStr := LStock.StkUser8;
            43    : MiscStr := LStock.StkUser9;
            44    : MiscStr := LStock.StkUser10;

            // MH 09/09/2014 v7.1 ABSEXCH-15052
            45    : MiscStr := YesNoBo(LStock.stIsService);
          End { Case }
        End { If GetStockRec }
        Else
          Result := ErrStock;
      End; { With CompObj, CompanyBtr^ }
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End;


{***********************************************************************}
{* GetStockMiscInt: Returns a long integer value from the specified    *}
{*                 stock record. The value is specified using the      *}
{*                 MiscIntNo parameter, values are:                    *}
{*                                                                     *}
{*                   1  : Sales G/L Code                               *}
{*                   2  : Cost Of Sales G/L Code                       *}
{*                   3  : Write Offs G/L Code                          *}
{*                   4  : Stock Value G/L Code                         *}
{*                   5  : Work In Progress Code                        *}
{*                   6  : Sales Price Currency (MiscIntBand = A-H)     *}
{*                   7  : Cost Currency                                *}
{*                   8  : Re-Order Currency                            *}
{*                   9  : Default Line Type                            *}
{*                                                                     *}
{*                   HM 25/06/02: Added WOP Support                    *}
{*                   10 : WOP WIP GL                                   *}
{*                   11 : Product Assembly time (Days)                 *}
{*                   12 : Product Assembly time (Hours)                *}
{*                   13 : Product Assembly time (Minutes)              *}
{*                   14 : Re-Order Lead Time (Days)                    *}
{*                                                                     *}
{*                   HM 01/08/05: Added Returns Support                *}
{*                   15 : Sales Return GL                              *}
{*                   16 : Purchase Return GL                           *}
{*                                                                     *}
{*                 MiscIntBand is used to specify the Sales Price Band *}
{*                 when getting the Sales Price Currency               *}
{***********************************************************************}
Function TEnterpriseServer.GetStockMiscInt (Var Company     : String;
                                            Var StockId     : String;
                                            Var LocCode     : String;
                                            Var MiscIntNo   : SmallInt;
                                            Var MiscIntBand : String;
                                            Var MiscInt     : LongInt) : SmallInt;
Var
  CompObj : TCompanyInfo;
  GotLoc  : Boolean;
  D, H, M : Extended;

  Function IIF (Const Want1          : Boolean;
                Const Param1, Param2 : LongInt) : LongInt;
  Begin
    If Want1 Then
      Result := Param1
    Else
      Result := Param2;
  End;

  //-------------------------------------------------------

Begin
  Result := 0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (489{108}) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        { Get Stock Record }
        If GetStockRec (CompanyBtr, StockId) Then Begin
          { Check location code }
          GotLoc := False;
          LocCode := UpperCase(Trim(LocCode));
          If (LocCode <> '') Then Begin
            { Get Location Record }
            If GetLocRec (CompanyBtr, LocCode) Then Begin
              { Got Location }
              LocCode := LMLoc^.MLocLoc.loCode;
              GotLoc := True;

              { Get Stock/Location XRef record }
              GetStkLocRec (CompanyBtr, False);
            End { If }
            Else Begin
              Result := ErrLoc;
              FillChar (LMStkLoc^, SizeOf (LMStkLoc^), #0);
            End; { Else }
          End; { If }

          If (Result = 0) Then
            Case MiscIntNo Of
              1      : MiscInt := IIF (GotLoc And LMLoc.MLocLoc.loUseNom, LMStkLoc.MStkLoc.lsDefNom[1], LStock.NomCodes[1]);
              2      : MiscInt := IIF (GotLoc And LMLoc.MLocLoc.loUseNom, LMStkLoc.MStkLoc.lsDefNom[2], LStock.NomCodes[2]);
              3      : MiscInt := IIF (GotLoc And LMLoc.MLocLoc.loUseNom, LMStkLoc.MStkLoc.lsDefNom[3], LStock.NomCodes[3]);
              4      : MiscInt := IIF (GotLoc And LMLoc.MLocLoc.loUseNom, LMStkLoc.MStkLoc.lsDefNom[4], LStock.NomCodes[4]);
              5      : MiscInt := IIF (GotLoc And LMLoc.MLocLoc.loUseNom, LMStkLoc.MStkLoc.lsDefNom[5], LStock.NomCodes[5]);
              6      : If (Length(MiscIntBand) > 0) And (MiscIntBand[1] In ['A'..'H']) Then
                         MiscInt := IIF (GotLoc And LMLoc.MLocLoc.loUsePrice,
                                         LMStkLoc.MStkLoc.lsSaleBands[1 + Ord(MiscIntBand[1]) - Ord('A')].Currency,
                                         LStock.SaleBands[1 + Ord(MiscIntBand[1]) - Ord('A')].Currency);
              7      : MiscInt := IIF (GotLoc {And LMLoc.MLocLoc.loUsePrice}, LMStkLoc.MStkLoc.lsPCurrency, LStock.PCurrency);
              8      : MiscInt := IIF (GotLoc {And LMLoc.MLocLoc.loUsePrice}, LMStkLoc.MStkLoc.lsRoCurrency, LStock.ROCurrency);

              { HM 26/10/99: v4.31 fields added }
              9      : MiscInt := LStock.StkLinkLT;

              // HM 25/06/02: v5.00.002(?) WOP Fields added
              10     : MiscInt := IIF (GotLoc And LMLoc.MLocLoc.loUseNom, LMStkLoc.MStkLoc.lsWOPWIPGL, LStock.WOPWIPGL);
              11..13 : Begin
                         Time2Mins (LStock.ProdTime, D, H, M, 0);
                         Case MiscIntNo Of
                           11 : MiscInt := Round(D);
                           12 : MiscInt := Round(H);
                           13 : MiscInt := Round(M);
                         End; { Case }
                       End;
              14     : MiscInt := LStock.LeadTime;

              // Sales Return GL
              15    : MiscInt := IIF (GotLoc And LMLoc.MLocLoc.loUseNom, LMStkLoc.MStkLoc.lsReturnGL, LStock.ReturnGL);
              // Purchase Return GL
              16    : MiscInt := IIF (GotLoc And LMLoc.MLocLoc.loUseNom, LMStkLoc.MStkLoc.lsPReturnGL, LStock.PReturnGL);
            End { Case }
        End { If }
        Else
          Result := ErrStock;
      End; { With }
    End { If }
    Else
      Result := ErrPermit
  End { If }
  Else
    Result := ErrComp;
End;


{***********************************************************************}
{* GetStockMiscVal: Returns a double value from the specified          *}
{*                 stock record. The value is specified using the      *}
{*                 MiscValNo parameter, values are:                    *}
{*                                                                     *}
{*                   1  : Min Stock                                    *}
{*                   2  : Max Stock                                    *}
{*                   3  : Sales Price (MiscIntBand = A-H)              *}
{*                   4  : Cost Price                                   *}
{*                   5  : Re-Order Price                               *}
{*                   6  : Stock Take Quantity                          *}
{*                   7  : Stock Freeze Quantity                        *}
{*                   8  : Actual Physical Stock                        *}
{*                   10 : Allocated Stock                              *}
{*                   11 : Stock On Order                               *}
{*                   12 : Picked Stock                                 *}
{*                   13 : Stock Units in SSD Unit                      *}
{*                   14 : Sales Unit Weight                            *}
{*                   15 : Purchase Unit Weight                         *}
{*                                                                     *}
{*                   HM 27/10/99: v4.31 mods                           *}
{*                   16 : Selling Qty Multiple                         *}
{*                   17 : Purchase Qty   "                             *}
{*                   18 : Intrastat Uplift Dispatch default %          *}
{*                   19 : Intrastat Uplift Arrivals default %          *}
{*                                                                     *}
{*                   HM 25/06/02: Added WOP Support                    *}
{*                   20 :  Min Economic Build Qty                      *}
{*                                                                     *}
{*                   HM 05/08/02: Added WOP Support                    *}
{*                   21 :  Qty allocated to WOR                        *}
{*                   22 :  Qty issued to WOR                           *}
{*                   23 :  Qty issued now, but not processed           *}
{*                                                                     *}
{*                   HM 19/09/03:                                      *}
{*                   24 :  Qty Outstanding on SOR's                    *}
{*                                                                     *}
{*                   25 :  WOP Reorder Qty                             *}
{*                                                                     *}
{*                   HM 01/08/05: Added Returns Support                *}
{*                   26 : Purchase Qty Returned                        *}
{*                   27 : Sales Qty Returned                           *}
{*                                                                     *}
{*                 MiscIntBand is used to specify the Sales Price Band *}
{*                 when getting the Sales Price                        *}
{***********************************************************************}
Function TEnterpriseServer.GetStockMiscVal (Var Company     : String;
                                            Var StockId     : String;
                                            Var LocCode     : String;
                                            Var MiscValNo   : SmallInt;
                                            Var MiscValBand : String;
                                            Var MiscVal     : Double) : SmallInt;
Var
  CompObj : TCompanyInfo;
  GotLoc  : Boolean;

  Function IIF (Const Want1          : Boolean;
                Const Param1, Param2 : Double) : Double;
  Begin
    If Want1 Then
      Result := Param1
    Else
      Result := Param2;
  End;

Begin
  Result := 0;
  MiscVal := 0.0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (489{108}) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        { Get Stock Record }
        If GetStockRec (CompanyBtr, StockId) Then Begin
          { Check location code }
          GotLoc := False;
          LocCode := UpperCase(Trim(LocCode));
          If (LocCode <> '') Then Begin
            { Get Location Record }
            If GetLocRec (CompanyBtr, LocCode) Then Begin
              { Got Location }
              LocCode := LMLoc^.MLocLoc.loCode;
              GotLoc := True;

              { Get Stock/Location XRef record }
              GetStkLocRec (CompanyBtr, False);
            End { If }
            Else Begin
              Result := ErrLoc;
              FillChar (LMStkLoc^, SizeOf (LMStkLoc^), #0);
            End; { Else }
          End; { If }

          If (Result = 0) Then
            Case MiscValNo Of
              1  : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsQtyMin, LStock.QtyMin);
              2  : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsQtyMax, LStock.QtyMax);
              3  : If (Length(MiscValBand) > 0) And (MiscValBand[1] In ['A'..'H']) Then
                     MiscVal := IIF (GotLoc And LMLoc.MLocLoc.loUsePrice,
                                     LMStkLoc.MStkLoc.lsSaleBands[1 + Ord(MiscValBand[1]) - Ord('A')].SalesPrice,
                                     LStock.SaleBands[1 + Ord(MiscValBand[1]) - Ord('A')].SalesPrice);
              { HM 19/08/98: Modified Cost/RO price not to check override flag }
              4  : MiscVal := IIF (GotLoc {And LMLoc.MLocLoc.loUsePrice}, LMStkLoc.MStkLoc.lsCostPrice, LStock.CostPrice);
              5  : MiscVal := IIF (GotLoc {And LMLoc.MLocLoc.loUsePrice}, LMStkLoc.MStkLoc.lsRoPrice, LStock.ROCPrice);
              6  : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsQtyTake, LStock.QtyTake);
              7  : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsQtyFreeze, LStock.QtyFreeze);

              { Actual Physical Stock }
              8  : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsQtyInStock, LStock.QtyInStock);

              { Allocated Stock }
              // HM 23/05/03: Modified to take 'Picking Order Allocates Stock' flag into account
              //10 : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsQtyAlloc, LStock.QtyAllocated);
              10 : MiscVal := IIF (GotLoc, IIF (Syss.UsePick4All, LMStkLoc.MStkLoc.lsQtyPicked, LMStkLoc.MStkLoc.lsQtyAlloc),
                                           IIF (Syss.UsePick4All, LStock.QtyPicked, LStock.QtyAllocated));

              { Stock On Order}
              11 : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsQtyOnOrder, LStock.QtyOnOrder);
              { Picked Stock }
              12 : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsQtyPicked, LStock.QtyPicked);

              { Stock Units in SSD Unit }
              13 : MiscVal := LStock.SuppSUnit;
              { Sales Unit Weight }
              14 : MiscVal := LStock.SWeight;
              { Purchase Unit Weight }
              15 : MiscVal := LStock.PWeight;

              { HM 27/10/99: Added v4.31 fields }
              16 : MiscVal := LStock.SellUnit;               { Selling Qty Multiple }
              17 : MiscVal := LStock.BuyUnit;                { Purchase Qty   "     }

              18 : MiscVal := LStock.SSDDUplift;             { Intrastat Uplift Dispatch default % }
              19 : MiscVal := LStock.SSDAUpLift;             { Intrastat Uplift Arrivals default % }

              // HM 25/06/02: v5.00.002(?) WOP Fields added
              20 : MiscVal := LStock.MinEccQty;

              // HM 05/08/02: Added WOP Support
              21 : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsQtyAllocWOR, LStock.QtyAllocWOR);  // Qty allocated to WOR
              22 : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsQtyIssueWOR, LStock.QtyIssueWOR);  // Qty issued to WOR
              23 : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsQtyPickWOR, LStock.QtyPickWOR);    // Qty issued now, but not processed

              // HM 18/09/03: Re-added this field (formerly known as 10!) due to popular request
              24 : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsQtyAlloc, LStock.QtyAllocated);

              // HM 22/11/04: Added Get/Set for Re-Order Qty fields
              25 : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsRoQty, LStock.ROQty);

              // HM HM 01/08/05: Added Returns Support
              // Purchase Qty Returned
              26 : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsQtyPReturn, LStock.QtyPReturn);
              // Sales Qty Returned
              27 : MiscVal := IIF (GotLoc, LMStkLoc.MStkLoc.lsQtyReturn, LStock.QtyReturn);
            End { Case }
        End { If }
        Else
          Result := ErrStock;
      End; { With }
    End { If }
    Else
      Result := ErrPermit
  End { If }
  Else
    Result := ErrComp;
End;


{***********************************************************************}
{* SaveStockMiscStr: Saves a string value to the specified stock       *}
{*                   record. The value updated is specified using the  *}
{*                   MiscStrNo parameter, values are:                  *}
{*                                                                     *}
{*                   1  : Description line 1                           *}
{*                   2  : Description line 2                           *}
{*                   3  : Description line 3                           *}
{*                   4  : Description line 4                           *}
{*                   5  : Description line 5                           *}
{*                   6  : Description line 6                           *}
{*                   7  : AltCode                                      *}
{*                   8  : Unit Of Stock                                *}
{*                   9  : Unit Of Sale                                 *}
{*                   10 : Unit Of Purchase                             *}
{*                   11 : User Field 1                                 *}
{*                   12 : User Field 2                                 *}
{*                   13 : Preferred Supplier                           *}
{*                   14 : Bar Code                                     *}
{*                   15 : Commodity Code                               *}
{*                   16 : SSD Unit Description                         *}
{*                                                                     *}
{*                   MH 01/08/05: Added Goods Returns                  *}
{*                   30 : Sales Warranty (in 6M format)                *}
{*                   31 : Manufacturer Warranty (in 6M format)         *}
{*                   32 : Restock Charge %/Amount                      *}
{***********************************************************************}
Function TEnterpriseServer.SaveStockMiscStr (Var Company   : String;
                                             Var StockId   : String;
                                             Var LocCode   : String;
                                             Var MiscStrNo : SmallInt;
                                             Var NewStr    : String) : SmallInt;
Var
  FNum, KPath : SmallInt;
  KeyR, KeyS  : Str255;
  CompObj     : TCompanyInfo;
  StockMode   : Boolean;
  OpMode      : Byte; { 0=Sweet FA, 1=Adding, 2=Updating }
  WarrantyLength, WarrantyType : Byte;
  // PKR. 04/02/2016. ABSEXCH-17242. Validate Commodity Code
  // Added as parameters to Val(), used for validation of Commodity Code
  iCode : integer;
  // MH 31/05/2016 2016-R2 ABSEXCH-17488: Changed to Int64 to avoid overflows with 10 digit TARIC codes > MaxLongInt
  iValue : Int64;
  // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
  iLen : Integer;

  Function CheckWarranty (WarrantyStr : ShortString; Var WarrantyLength, WarrantyType : Byte) : Boolean;
  Var
    sNum : ShortString;
    ErrCode, StrVal : Integer;
    I : Byte;
  Begin // CheckWarranty
    WarrantyLength := 0;
    WarrantyType := 0;

    WarrantyStr := UpperCase(Trim(WarrantyStr));
    If (WarrantyStr <> '') And (Length(WarrantyStr) <= 4) Then
    Begin
      // Validate and extract warranty string in format nnnX where nnn is a number 0-255 and X is one of D/W/M/Y
      Result := (WarrantyStr[Length(WarrantyStr)] In ['D', 'W', 'M', 'Y']);

      If Result Then
      Begin
        Case WarrantyStr[Length(WarrantyStr)] Of
          'D' : WarrantyType := 0;
          'W' : WarrantyType := 1;
          'M' : WarrantyType := 2;
          'Y' : WarrantyType := 3;
        End; //  : WarrantyType := 0;

        For I := 1 To (Length(WarrantyStr) - 1) Do
        Begin
          Result := WarrantyStr[I] In ['0'..'9'];
          If Result Then
            sNum := sNum + WarrantyStr[I]
          Else
            Break;
        End; // For I

        If Result Then
        Begin
          // Decode number and check within range
          Val(sNum, StrVal, ErrCode);
          Result := (ErrCode = 0) And (StrVal >= 0) And (StrVal <= 99);
          If Result Then WarrantyLength := StrVal;
        End; // If Result
      End; // If Result
    End // If (WarrantyStr <> '') And (Length(WarrantyStr) <= 4)
    Else
      Result := WarrantyStr = '';
  End; // CheckWarranty

Begin
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then Begin
    If CompObj.CheckSecurity (491{111}) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        StockMode := True;

        { Get Stock Record }
        If GetStockRec (CompanyBtr, StockId) Then Begin
          { Check location code }
          LocCode := UpperCase(Trim(LocCode));
          If (LocCode <> '') Then Begin
            { Get Location Record }
            If GetLocRec (CompanyBtr, LocCode) Then Begin
              { Got Location }
              LocCode := LMLoc^.MLocLoc.loCode;

              { Check which record we wanna update }
              Case MiscStrNo Of
                13     : StockMode := Not LMLoc^.MLocLoc.loUseSupp;   { Supplier }
                22     : StockMode := False;                          { Bin Location }
                23, 24 : StockMode := Not LMLoc^.MLocLoc.loUseCCDep;  { Dept, CC }
                34,35  : StockMode := False;                          // Reorder CC/Dept
              End; { Case }

              If StockMode And ((MiscStrNo = 13) Or (MiscStrNo = 23) Or (MiscStrNo = 24)) Then
                Result := ErrStkLocDis;
            End { If }
            Else
              Result := ErrLoc;
          End; { If }
        End { If }
        Else
          Result := ErrStock;

        If (Result = 0) Then Begin
          If StockMode Then Begin
            { Update Stock }
            FNum  := StockF;
            KPath := StkCodeK;
            KeyS  := LStock.StockCode;
          End { If }
          Else Begin
            { Update Stock/Location XRef }
            FNum  := MLocF;
            KPath := MLK;
            KeyS  := PartCCKey(CostCCode,CSubCode[BOff]) + LStock.StockCode + LMLoc.MLocLoc.loCode;
          End; { Else }
          KeyR := KeyS;

          OpMode := 0; { Knackered }
          LStatus:=LFind_Rec(B_GetGEq,FNum,KPath,KeyS);

          { HM 16/12/99: Modified to create StkLoc records where necessary }
          If LStatusOk And CheckKey(KeyR,KeyS,Length(KeyR),BOn) Then Begin
            { found - get rec and update }
            GLobLocked:=BOff;
            Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked);
            LGetRecAddr(FNum);

            If OK And GlobLocked Then Begin
              OpMode := 2; { Editing }

              If (FNum = MLocF) Then LMStkLoc^ := LMLocCtrl^;
            End { If }
            Else
              Result := ErrRecLock;
          End { If }
          Else Begin
            { No Record Found }
            If (FNum = MLocF) Then Begin
              { Create StkLoc Record }
              OpMode := 1; { Add }

              FillChar (LMStkLoc^, SizeOf (LMStkLoc^), #0);
              LMStkLoc^.RecPFix := CostCCode;
              LMStkLoc^.SubType := CSubCode[BOff];
              LMStkLoc^.MStkLoc.lsLocCode:=LMLoc^.MLocLoc.loCode;
              SetROConsts(LStock, LMStkLoc^.MStkLoc, LMLoc^.MLocLoc);
            End { If }
            Else
              Result := ErrStock;
          End; { Else }

          If (Result = 0) Then Begin
            Case MiscStrNo Of
              1..6 : LStock.Desc[MiscStrNo] := NewStr;
              7    : LStock.AltCode := FullStockCode(NewStr);
              8    : LStock.UnitK := NewStr;
              9    : LStock.UnitS := NewStr;
              10   : LStock.UnitP := NewStr;
              11   : LStock.StkUser1 := NewStr;
              12   : LStock.StkUser2 := NewStr;
              13   : Begin
                       NewStr := UpperCase(Trim(NewStr));
                       If (NewStr <> '') Then Begin
                         { Validate Supplier Code before saving }
                         If GetCustRec (CompanyBtr, NewStr, True) Then Begin
                           If (LCust.CustSupp = 'S') Then
                             Case StockMode Of
                               False : LMStkLoc^.MStkLoc.lsSupplier := LCust.CustCode;
                               True  : LStock.Supplier := LCust.CustCode;
                             End { Case }
                           Else Begin
                             { Invalid Supplier Code }
                             Result := ErrSupp;
                           End; { Else }
                         End { If }
                         Else
                           { Invalid Supplier Code }
                           Result := ErrSupp;
                       End { If }
                       Else Begin
                         { Blank supplier code }
                         Case StockMode Of
                           False : LMStkLoc^.MStkLoc.lsSupplier := FullCustCode('');
                           True  : LStock.Supplier := FullCustCode('');
                         End { Case }
                       End; { Else }

                       If StockMode Then LStock.SuppTemp := LStock.Supplier;
                     End;
              14   : LStock.BarCode := FullBarCode(NewStr);
              15   : begin
                       // PKR. 04/02/2016. ABSEXCH-17242. Validate Commodity Code
                       // Validation rules for Commodity Code:
                       // - If Intrastat is swtched on, then the Commodity Code must be blank or 8 characters.
                       // - If Intrastat is switched off, then no validation.
                       NewStr := Trim(NewStr); // Trimmed to avoid validation errors
                       if (Syss.Intrastat) then
                       begin
                         // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
                         iLen := Length(NewStr);
                         if (iLen = 0) or (iLen = 8) or (iLen = 10) then
                         Begin
                           // If it passed the first test, and it is 8 or 10 characters long, check it's numeric
                           if (iLen = 8) or (iLen = 10) then
                           begin
                             // if iCode > 0 then the integer conversion failed.
                             Val(NewStr, iValue, iCode);
                             if (iCode <> 0) then
                               Result := ErrValue;
                           end;
                         End // if (iLen = 0) or (iLen = 8) or (iLen = 10)
                         Else
                           Result := ErrValue;
                       end;
                       LStock.CommodCode := NewStr;
                     end;
              16   : LStock.UnitSupp := NewStr;

              { HM 26/10/99: v4.31 fields added }
              17   : LStock.StkUser3 := NewStr;
              18   : LStock.StkUser4 := NewStr;
              19   : Begin { Job Analysis }
                       NewStr := UpperCase(Trim(NewStr));
                       If (NewStr <> '') Then Begin
                         { Validate Analysis Code before saving }
                         If GetJobMiscRec (CompObj.CompanyBtr, NewStr, 2) Then
                           LStock.JAnalCode := LJobMisc.JobAnalRec.JAnalCode
                         Else
                           Result := ErrJobAnal;
                       End { If }
                       Else Begin
                         { Blank supplier code }
                         LStock.JAnalCode := FullJACode('');
                       End; { Else }
                     End; { Job Analysis }

                // MH 24/11/05: Modified VAT Code behaviour so that Inclusive VAT Codes are returned as 'IS'
//              20   : If (Length(Trim(NewStr)) > 0) Then Begin
//                       NewStr := UpperCase(Trim(NewStr)[1]);
//                       If (NewStr[1] In VatSet) Then
//                         LStock.VATCode := NewStr[1]
//                       Else
//                         Result := ErrVATCode;
//                     End
//                     Else
//                       { No code specified }
//                       Result := ErrVATCode;
              20   : Begin
                       // Validate the new codes together and set the VAT Code fields
                       If (ValidateVATCodeString (votStock, NewStr, False, LStock.VATCode, LStock.SVATIncFlg) <> 0) Then
                       Begin
                         Result := ErrVATCode;
                       End; // If (ValidateVATCodeString (NewStr, LStock.VATCode, LStock.SVATIncFlg) <> 0)
                     End;

              21   : Begin { Default Location }
                       LocCode := UpperCase(Trim(NewStr));
                       If (LocCode <> '') Then Begin
                         { Get Location Record }
                         If GetLocRec (CompanyBtr, LocCode) Then Begin
                           { Got Location }
                           LStock.DefMLoc := LMLoc^.MLocLoc.loCode;
                         End { If }
                         Else
                           Result := errLoc;
                       End { If }
                       Else
                         { Blank Location }
                         LStock.DefMLoc := Full_MLocKey('');
                     End;
              22   : Begin
                       NewStr := UpperCase(LJVar(NewStr,BinLocLen));
                       Case StockMode Of
                         False : Begin
                                   LMStkLoc^.MStkLoc.lsBinLoc := NewStr;
                                 End;
                         True  : Begin
                                   LStock.BinLoc := NewStr;
                                   LStock.TempBLoc := NewStr;
                                 End;
                       End; { Case }
                     End;
              23,24
                   : Begin
                       { Validate new Department/CostCentre Code }
                       NewStr := UpperCase(Trim(NewStr));

                       If (NewStr <> '') Then
                       Begin
                         If GetCCDepRec (CompObj.CompanyBtr, NewStr, (MiscStrNo=24)) Then
                           Case StockMode Of
                             False : LMStkLoc^.MStkLoc.lsCCDep[(MiscStrNo=24)] := LPassword.CostCtrRec.PCostC;
                             True  : LStock.CCDep[(MiscStrNo=24)] := LPassword.CostCtrRec.PCostC;
                           End { Case }
                         Else
                           Result := ErrDept
                       End { If }
                       Else
                         { Blank Department/Cost Centre }
                         Case StockMode Of
                           False : LMStkLoc^.MStkLoc.lsCCDep[(MiscStrNo=24)] := FullCCDepKey('');
                           True  : LStock.CCDep[(MiscStrNo=24)] := FullCCDepKey('');
                         End; { Case }
                     End;
              25   : If (Length(Trim(NewStr)) > 0) Then Begin
                       NewStr := UpperCase(Trim(NewStr)[1]);
                       If (NewStr[1] In ['Y', 'N']) Then
                         LStock.WebInclude := Ord(NewStr[1] = 'Y')
                       Else
                         Result := ErrValue;
                     End
                     Else
                       Result := ErrValue;
              26   : LStock.WebLiveCat := NewStr;                  { Web current catalogue entry }
                     // MH 18/01/2016 2016-R1 ABSEXCH-17099: Removed Country of Origin from Stock Record for UK Companies
              27   : If (Syss.USRCntryCode <> UKCCode) Then
                       LStock.SSDCountry := NewStr                  {    "     Country of origin }
                     Else
                       FillChar(LStock.SSDCountry, SizeOf(LStock.SSDCountry), #0);
              28   : LStock.ImageFile := NewStr;                   { Associated bitmap image }

              // HM 25/06/02: Added WOP Support
              29   : If (Length(Trim(NewStr)) > 0) Then Begin
                       NewStr := UpperCase(Trim(NewStr)[1]);
                       If (NewStr[1] In ['Y', 'N']) Then
                         LStock.CalcProdTime := (NewStr[1] = 'Y')
                       Else
                         Result := ErrValue;
                     End
                     Else
                       Result := ErrValue;

              // MH 01/08/05: Added Goods Returns
              // Sales Warranty (in 6M format)
              30   : If CheckWarranty (NewStr, WarrantyLength, WarrantyType) Then
                     Begin
                       LStock.SWarranty := WarrantyLength;
                       LStock.SWarrantyType := WarrantyType;
                     End // If CheckWarranty (NewStr, WarrantyLength, WarrantyType)
                     Else
                       Result := ErrValue;
              // Manufacturer Warranty (in 6M format)
              31   : If CheckWarranty (NewStr, WarrantyLength, WarrantyType) Then
                     Begin
                       LStock.MWarranty := WarrantyLength;
                       LStock.MWarrantyType := WarrantyType;
                     End // If CheckWarranty (NewStr, WarrantyLength, WarrantyType)
                     Else
                       Result := ErrValue;
              // Restock Charge %/Amount
              32    : Begin
                        NewStr := UpperCase(Trim(NewStr));
                        If (NewStr <> '') Then
                        Begin
                          // Discount set - perform basic validation
                          If (Length(NewStr) > 1) And (NewStr[Length(NewStr)] = '%') Then
                          Begin
                            // Percentage
                            Delete(NewStr, Length(NewStr), 1);
                            Try
                              LStock.ReStockPcnt := Round_Up(StrToFloat(NewStr) / 100, 4);
                              LStock.ReStockPChr := '%';
                            Except
                              On Exception Do
                                Result := ErrValue;
                            End; // Try..Except
                          End // If (Length(NewStr) > 1) And (NewStr[Length(NewStr)] = '%')
                          Else
                          Begin
                            // Amount
                            Try
                              LStock.ReStockPcnt := StrToFloat(NewStr);
                              LStock.ReStockPChr := #0;
                            Except
                              On Exception Do
                                Result := ErrValue;
                            End; // Try..Except
                          End; // Else
                        End // If (NewStr <> '')
                        Else
                        Begin
                          // OK - resetting to 0
                          LStock.ReStockPChr := #0;
                          LStock.ReStockPcnt := 0.0;
                        End; // Else
                      End; // Restock Charge %/Amount

              // Re-Order Supplier
              33    : Begin
                        NewStr := UpperCase(Trim(NewStr));
                        If (NewStr <> '') Then
                        Begin
                          { Validate Supplier Code before saving }
                          If GetCustRec (CompanyBtr, NewStr, True) Then
                          Begin
                            If (LCust.CustSupp = 'S') Then
                              // Re-Order Supplier onloy on Stock Record
                              LStock.SuppTemp := LCust.CustCode
                            Else
                              { Invalid Supplier Code }
                              Result := ErrSupp;
                          End { If }
                          Else
                            { Invalid Supplier Code }
                            Result := ErrSupp;
                        End { If }
                        Else Begin
                          { Blank supplier code }
                          LStock.SuppTemp := FullCustCode('');
                        End; { Else }
                      End; // Re-Order Supplier

              // Re-Order CostCentre/Department
              34,35 : Begin
                        { Validate new  Code }
                        NewStr := UpperCase(Trim(NewStr));
                        If (NewStr <> '') Then
                        Begin
                          If GetCCDepRec (CompObj.CompanyBtr, NewStr, (MiscStrNo=35)) Then
                            Case StockMode Of
                              False : LMStkLoc^.MStkLoc.lsROCCDep[(MiscStrNo=35)] := LPassword.CostCtrRec.PCostC;
                              True  : LStock.ROCCDep[(MiscStrNo=35)] := LPassword.CostCtrRec.PCostC;
                            End { Case }
                          Else
                           Result := ErrDept
                        End { If }
                        Else
                          { Blank Department/Cost Centre }
                          Case StockMode Of
                            False : LMStkLoc^.MStkLoc.lsROCCDep[(MiscStrNo=35)] := FullCCDepKey('');
                            True  : LStock.ROCCDep[(MiscStrNo=35)] := FullCCDepKey('');
                          End; { Case }
                      End; // Re-Order CostCentre/Department
              //GS 27/10/2011 ABSEXCH-11706:
              //added support for UDEFs 6-10
              39   : LStock.StkUser5 := NewStr;
              40   : LStock.StkUser6 := NewStr;
              41   : LStock.StkUser7 := NewStr;
              42   : LStock.StkUser8 := NewStr;
              43   : LStock.StkUser9 := NewStr;
              44   : LStock.StkUser10 := NewStr;

              // MH 09/09/2014 v7.1 ABSEXCH-15052: Added Stock EC Service Flag
              45   : If (Length(Trim(NewStr)) > 0) Then
                     Begin
                       NewStr := UpperCase(Trim(NewStr)[1]);
                       If (NewStr[1] In ['Y', 'N']) Then
                       Begin
                         If (NewStr[1] = 'Y') Then
                         Begin
                           If ((CurrentCountry = UKCCode) Or (CurrentCountry = IECCode)) And
                              SyssVAT.VATRates.EnableECServices And
                              (LStock.StockType = StkDescCode) Then
                             LStock.stIsService := True
                           Else
                             Result := ErrValue;
                         End // If (NewStr[1] = 'Y')
                         Else
                           LStock.stIsService := False
                       End // If (NewStr[1] In ['Y', 'N'])
                       Else
                         Result := ErrValue;
                     End // If (Length(Trim(NewStr)) > 0)
                     Else
                       Result := ErrValue;
            End; { Case }

            If (Result = 0) Then Begin
              { Update last amendment date/time }
              Case FNum Of
                StockF : Begin
                           With LStock Do Begin
                             LastUsed := Today;
                             TimeChange := TimeNowStr;
                           End; { LStock }

                           CheckStockNdx(LStock);
                         End;
                MLocF  : Begin
                           LMLocCtrl^ := LMStkLoc^;

                           With LMLocCtrl^.MStkLoc Do Begin
                             lsLastUsed := Today;
                             lsLastTime := TimeNowStr;
                           End; { LMLocCtrl^.MStkLoc }
                         End;
              End; { Case FNum }

              Case OpMode Of
                { Add new record }
                1 :
                begin
                  LStatus := LAdd_Rec (Fnum, KPath);

                  //GS 31/10/2011 Add Audit History Notes for v6.9
                  if LStatus = 0 then
                  begin
                    WriteAuditNote(anStock, anCreate, CompObj);
                  end;

                end;
                { update existing record }
                2 :
                begin
                  LStatus := LPut_Rec (Fnum, KPath);

                  //GS 31/10/2011 Add Audit History Notes for v6.9
                  if LStatus = 0 then
                  begin
                    WriteAuditNote(anStock, anEdit, CompObj);
                  end;

                end;
              End; { Case OpMode }
            End; { If }

            If (OpMode = 2) Then Begin
              { Unlock record}
              LUnlockMLock(FNum);
            End; { If (OpMode = 2) }

            If (Result = 0) Then Begin
              If (LStatus = 0) Then Begin
                Result := 0;

                { Update duplicate Stock/Location record }
                If (Not StockMode) Then
                  LMStkLoc^ := LMLocCtrl^;
              End { If }
              Else
                Result := ErrBtrBase + LStatus;
            End; { If }
          End; { If (Result = 0) }
        End; { If (Result = 0) }
      End { With }
    End { If }
    Else
      Result := ErrPermit;
  End; { If (Result = 0) }
End;


{***********************************************************************}
{* SaveStockMiscInt: Saves a Long Int value to the specified stock     *}
{*                   record. The value updated is specified using the  *}
{*                   MiscIntNo parameter, values are:                  *}
{*                                                                     *}
{*                     1  : Sales G/L Code                             *}
{*                     2  : Cost Of Sales G/L Code                     *}
{*                     3  : Write Offs G/L Code                        *}
{*                     4  : Stock Value G/L Code                       *}
{*                     5  : Work In Progress Code                      *}
{*                     6  : Sales Price Currency (MiscIntBand = A-H)   *}
{*                     7  : Cost Currency                              *}
{*                     8  : Re-Order Currency                          *}
{*                     9  : Default Line Type                          *}
{*                                                                     *}
{*                     HM 25/06/02: Added WOP Support                  *}
{*                     10 : WOP WIP GL                                 *}
{*                     11 : Product Assembly time (Days)               *}
{*                     12 : Product Assembly time (Hours)              *}
{*                     13 : Product Assembly time (Minutes)            *}
{*                     14 : Re-Order Lead Time (Days)                  *}
{*                                                                     *}
{*                     HM 01/08/05: Added Returns Support              *}
{*                     15 : Sales Return GL                            *}
{*                     16 : Purchase Return GL                         *}
{*                                                                     *}
{*                   MiscIntBand is used to specify the Sales Price    *}
{*                   Band when getting the Sales Price Currency        *}
{***********************************************************************}
Function TEnterpriseServer.SaveStockMiscInt (Var Company     : String;
                                             Var StockId     : String;
                                             Var LocCode     : String;
                                             Var MiscIntNo   : SmallInt;
                                             Var MiscIntBand : String;
                                             Var NewInt      : LongInt) : SmallInt;
Var
  FNum, KPath : SmallInt;
  KeyR, KeyS  : Str255;
  ValidErr    : Boolean;
  CompObj     : TCompanyInfo;
  StockMode   : Boolean;
  OpMode      : Byte; { 0=Sweet FA, 1=Adding, 2=Updating }
  D, H, M     : Extended;
  lOK         : Boolean;
Begin
  { Load Company Data }
  // MH 06/10/06: Modified to allow IAO to save Stock/GL Codes without an OLE Save release code
  If (Branding.pbProduct = ptLITE) Then
    // IAO
    Result := IfThen(BtrList.OpenCompany (Company, CompObj), 0, ErrComp)
  Else
    // Exchequer
    Result := BtrList.OpenSaveCompany (Company, CompObj);

  If (Result = 0) Then Begin
    If CompObj.CheckSecurity (491{111}) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        StockMode := True;

        { Get Stock Record }
        If GetStockRec (CompanyBtr, StockId) Then Begin
          { Check location code }
          LocCode := UpperCase(Trim(LocCode));
          If (LocCode <> '') Then Begin
            { Get Location Record }
            If GetLocRec (CompanyBtr, LocCode) Then Begin
              { Got Location }
              LocCode := LMLoc^.MLocLoc.loCode;

              { Check which record we wanna update }
              Case MiscIntNo Of
                1..5, 10, 15, 16   : StockMode := Not LMLoc^.MLocLoc.loUseNom;      { GL Codes }
                6{..8}     : StockMode := Not LMLoc^.MLocLoc.loUsePrice;    { Price Currencies }
                7..8       : StockMode := False;
              End; { Case }

              If StockMode And (((MiscIntNo > 1) And (MiscIntNo < 6)) Or (MiscIntNo = 10) Or (MiscIntNo = 15) Or (MiscIntNo = 16)) Then
                Result := ErrStkLocDis;
            End { If }
            Else
              Result := ErrLoc;
          End; { If }
        End { If }
        Else
          Result := ErrStock;

        If (Result = 0) Then Begin
          If StockMode Then Begin
            { Update Stock }
            FNum  := StockF;
            KPath := StkCodeK;
            KeyS  := LStock.StockCode;
          End { If }
          Else Begin
            { Update Stock/Location XRef }
            FNum  := MLocF;
            KPath := MLK;
            KeyS  := PartCCKey(CostCCode,CSubCode[BOff]) + LStock.StockCode + LMLoc.MLocLoc.loCode;
          End; { Else }
          KeyR := KeyS;

          OpMode := 0; { Knackered }
          LStatus:=LFind_Rec(B_GetGEq,FNum,KPath,KeyS);

          { HM 16/12/99: Modified to create StkLoc records where necessary }
          If LStatusOk And CheckKey(KeyR,KeyS,Length(KeyR),BOn) Then Begin
            { found - get rec and update }
            GLobLocked:=BOff;
            Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked);
            LGetRecAddr(FNum);

            If OK And GlobLocked Then Begin
              OpMode := 2; { Editing }

              If (FNum = MLocF) Then LMStkLoc^ := LMLocCtrl^;
            End { If }
            Else
              Result := ErrRecLock;
          End { If }
          Else Begin
            { No Record Found }
            If (FNum = MLocF) Then Begin
              { Create StkLoc Record }
              OpMode := 1; { Add }

              FillChar (LMStkLoc^, SizeOf (LMStkLoc^), #0);
              LMStkLoc^.RecPFix := CostCCode;
              LMStkLoc^.SubType := CSubCode[BOff];
              LMStkLoc^.MStkLoc.lsLocCode:=LMLoc^.MLocLoc.loCode;
              SetROConsts(LStock, LMStkLoc^.MStkLoc, LMLoc^.MLocLoc);
            End { If }
            Else
              Result := ErrStock;
          End; { Else }

          If (Result = 0) Then Begin
            ValidErr := False;

            Case MiscIntNo Of
              { GL Codes }
              1..5  : If GetNominalRec(CompObj.CompanyBtr, NewInt) {And (LNom.NomType In ['A', 'B'])} Then
                      Begin
                        // MH 18/10/06: Added validation on GL Classes
                        If Syss.UseGLClass Then
                        Begin
                          lOK := True;
                          Case MiscIntNo Of
                            // Sales G/L Code
                            1  : lOK := (LNom.NomType = 'A');
                            // Cost Of Sales G/L Code
                            2  : lOK := (LNom.NomType = 'A');
                            // Write Offs/Closing Stock G/L Code
                            3  : lOK := (LNom.NomType In ['A', 'B']) And (LNom.NomClass = 20);
                            // Stock Value G/L Code
                            4  : lOK := (LNom.NomType In ['A', 'B']) And (LNom.NomClass = 40);
                            // Finished Goods/Work In Progress Code
                            5  : lOK := (LNom.NomType In ['A', 'B']) And (LNom.NomClass = 30);
                          End; // Case MiscIntNo
                        End // If Syss.UseGLClass
                        Else
                          lOK := (LNom.NomType In ['A', 'B']);

                        If (Not lOK) Then
                        Begin
                          ValidErr := True;
                          Result := ErrNom;  { invalid GL Code }
                        End; // If (Not lOK)

                        If (Result = 0) Then
                        Begin
                          Case StockMode Of
                            False : LMStkLoc^.MStkLoc.lsDefNom[MiscIntNo] := NewInt;
                            True  : LStock.NomCodes[MiscIntNo] := NewInt;
                          End { Case }
                        End; // If (Result = 0)
                      End // If GetNominalRec(
                      Else Begin
                        ValidErr := True;
                        Result := ErrNom;  { invalid GL Code }
                      End; { Else }

              { Sales Price Bands - Currency }
              6     : If IsMultiCcy And (NewInt In [1..CurrencyType]) Then Begin
                        MiscIntBand := UpperCase(MiscIntBand);

                        If (Length(MiscIntBand) > 0) And (MiscIntBand[1] In ['A'..'H']) Then
                          Case StockMode Of
                            False : LMStkLoc^.MStkLoc.lsSaleBands[1 + Ord(MiscIntBand[1]) - Ord('A')].Currency := NewInt;
                            True  : LStock.SaleBands[1 + Ord(MiscIntBand[1]) - Ord('A')].Currency := NewInt;
                          End { Case }
                        Else Begin
                          ValidErr := True;
                          Result := ErrPrice; { Invalid price band }
                        End; { Else }
                      End { If }
                      Else Begin
                        ValidErr := True;
                        Result := ErrCcy;  { invalid currency }
                      End; { Else }

              { Cost Price Currency }
              7     : If IsMultiCcy And (NewInt In [1..CurrencyType]) Then
                        Case StockMode Of
                          False : LMStkLoc^.MStkLoc.lsPCurrency := NewInt;
                          True  : LStock.PCurrency := NewInt;
                        End { Case }
                      Else Begin
                        ValidErr := True;
                        Result := ErrCcy;  { invalid currency }
                      End; { Else }

              { Re-Order Currency }
              8     : If IsMultiCcy And (NewInt In [1..CurrencyType]) Then
                        Case StockMode Of
                          False : LMStkLoc^.MStkLoc.lsRoCurrency := NewInt;
                          True  : LStock.ROCurrency := NewInt;
                        End { Case }
                      Else Begin
                        ValidErr := True;
                        Result := ErrCcy;  { invalid currency }
                      End; { Else }

              { HM 26/10/99: v4.31 fields added }
              9     : If (NewInt >= 0) And (NewInt <= 4) Then
                        LStock.StkLinkLT := NewInt
                      Else Begin
                        ValidErr := True;
                        Result := ErrLineType;
                      End; { Else }

              // HM 25/06/02: Added WOP Support
              10     : If GetNominalRec(CompObj.CompanyBtr, NewInt) And (LNom.NomType In ['A', 'B']) Then
                         Case StockMode Of
                           False : LMStkLoc^.MStkLoc.lsWOPWIPGL := NewInt;
                           True  : LStock.WOPWIPGL := NewInt;
                         End { Case }
                       Else Begin
                         ValidErr := True;
                         Result := ErrNom;  { invalid GL Code }
                       End; { Else }
              11..13 : If (NewInt >= 0) Then Begin
                         Time2Mins (LStock.ProdTime, D, H, M, 0);
                         Case MiscIntNo Of
                           11 : D := NewInt;
                           12 : H := NewInt;
                           13 : M := NewInt;
                         End; { Case }
                         Time2Mins (LStock.ProdTime, D, H, M, 1);
                       End { If (NewInt >= 0) }
                       Else Begin
                         ValidErr := True;
                         Result := ErrValue;  { invalid value }
                       End; { Else }
              14     : If (NewInt >= 0) Then
                         LStock.LeadTime := NewInt
                       Else Begin
                         ValidErr := True;
                         Result := ErrValue;  { invalid value }
                       End; { Else }

              // HM 01/08/05: Added Returns Support              *}
              // Sales Return GL
              15 : If GetNominalRec(CompObj.CompanyBtr, NewInt) And (LNom.NomType In ['A', 'B']) Then
                     Case StockMode Of
                       False : LMStkLoc^.MStkLoc.lsReturnGL := NewInt;
                       True  : LStock.ReturnGL := NewInt;
                     End { Case }
                   Else Begin
                     ValidErr := True;
                     Result := ErrNom;  { invalid GL Code }
                   End; { Else }
              // Purchase Return GL
              16 : If GetNominalRec(CompObj.CompanyBtr, NewInt) And (LNom.NomType In ['A', 'B']) Then
                     Case StockMode Of
                       False : LMStkLoc^.MStkLoc.lsPReturnGL := NewInt;
                       True  : LStock.PReturnGL := NewInt;
                     End { Case }
                   Else Begin
                     ValidErr := True;
                     Result := ErrNom;  { invalid GL Code }
                   End; { Else }
            End; { Case }

            If (Not ValidErr) Then Begin
              { Update last amendment date/time }
              Case FNum Of
                StockF : Begin
                           With LStock Do Begin
                             LastUsed := Today;
                             TimeChange := TimeNowStr;
                           End; { LStock }

                           CheckStockNdx(LStock);
                         End;
                MLocF  : Begin
                           LMLocCtrl^ := LMStkLoc^;

                           With LMLocCtrl^.MStkLoc Do Begin
                             lsLastUsed := Today;
                             lsLastTime := TimeNowStr;
                           End; { LMLocCtrl^.MStkLoc }
                         End;
              End; { Case FNum }

              Case OpMode Of
                { Add new record }
                1 :
                begin
                  LStatus := LAdd_Rec (Fnum, KPath);

                  //GS 31/10/2011 Add Audit History Notes for v6.9
                  if LStatus = 0 then
                  begin
                    WriteAuditNote(anStock, anCreate, CompObj);
                  end;

                end;
                { update existing record }
                2 :
                begin
                  LStatus := LPut_Rec (Fnum, KPath);

                  //GS 31/10/2011 Add Audit History Notes for v6.9
                  if LStatus = 0 then
                  begin
                    WriteAuditNote(anStock, anEdit, CompObj);
                  end;

                end;
              End; { Case OpMode }
            End; { If }

            If (OpMode = 2) Then Begin
              { Unlock record }
              {Status := UnlockMultiSing(F[Fnum], Fnum, RecAddr);}
              LUnLockMLock(FNum);
            End; { If (OpMode = 2) Then }

            If (Not ValidErr) Then Begin
              If (LStatus = 0) Then Begin
                Result := 0;

                { Update duplicate Stock/Location record }
                If (Not StockMode) Then
                  LMStkLoc^ := LMLocCtrl^;
              End { If }
              Else
                Result := ErrBtrBase + LStatus;
            End; { If }
          End; { If (Result = 0) }
        End; { If (Result = 0) }
      End; { With }
    End { If }
    Else
      Result := ErrPermit
  End; { If (Result = 0) }
End;


{***********************************************************************}
{* SaveStockMiscVal: Saves a Long Int value to the specified stock     *}
{*                   record. The value updated is specified using the  *}
{*                   MiscIntNo parameter, values are:                  *}
{*                                                                     *}
{*                   1  : Min Stock                                    *}
{*                   2  : Max Stock                                    *}
{*                   3  : Sales Price (MiscIntBand = A-H)              *}
{*                   4  : Cost Price                                   *}
{*                   5  : Re-Order Price                               *}
{*                   9  : Stock Take Quantity                          *}
{*                   13 : Stock Units in SSD Unit                      *}
{*                   14 : Sales Unit Weight                            *}
{*                   15 : Purchase Unit Weight                         *}
{*                                                                     *}
{*                   HM 25/06/02: Added WOP Support                    *}
{*                   20 :  Min Economic Build Qty                      *}
{*                                                                     *}
{*                   HM 01/08/05: Added Returns Support                *}
{*                   28 : Restock Charge %                             *}
{*                                                                     *}
{*                   MiscIntBand is used to specify the Sales Price    *}
{*                   Band when getting the Sales Price Currency        *}
{***********************************************************************}
Function TEnterpriseServer.SaveStockMiscVal (Var Company     : String;
                                             Var StockId     : String;
                                             Var LocCode     : String;
                                             Var MiscValNo   : SmallInt;
                                             Var MiscValBand : String;
                                             Var NewVal      : Double) : SmallInt;
Var
  FNum, KPath : SmallInt;
  KeyR, KeyS  : Str255;
  ValidErr    : Boolean;
  CompObj     : TCompanyInfo;
  StockMode   : Boolean;
  OpMode      : Byte; { 0=Sweet FA, 1=Adding, 2=Updating }
Begin
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then Begin
    If CompObj.CheckSecurity (491{111}) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        StockMode := True;

        { Get Stock Record }
        If GetStockRec (CompanyBtr, StockId) Then Begin
          { Check location code }
          LocCode := UpperCase(Trim(LocCode));
          If (LocCode <> '') Then Begin
            { Get Location Record }
            If GetLocRec (CompanyBtr, LocCode) Then Begin
              { Got Location }
              LocCode := LMLoc^.MLocLoc.loCode;

              { Check which record we wanna update }
              Case MiscValNo Of
                1..2 : StockMode := False;                          { Min/Max Stock Levels }
                3    : StockMode := Not LMLoc^.MLocLoc.loUsePrice;  { Prices }
                { HM 19/08/98: Modified Cost/RO price not to check override flag }
                4..5 : StockMode := False;
                9    : StockMode := False;
                21   : StockMode := False;
              End; { Case }

              If StockMode And (MiscValNo = 3) Then
                Result := ErrStkLocDis;
            End { If }
            Else
              Result := ErrLoc;
          End; { If }
        End { If }
        Else
          Result := ErrStock;

        If (Result = 0) Then Begin
          If StockMode Then Begin
            { Update Stock }
            FNum  := StockF;
            KPath := StkCodeK;
            KeyS  := LStock.StockCode;
          End { If }
          Else Begin
            { Update Stock/Location XRef }
            FNum  := MLocF;
            KPath := MLK;
            KeyS  := PartCCKey(CostCCode,CSubCode[BOff]) + LStock.StockCode + LMLoc.MLocLoc.loCode;
          End; { Else }
          KeyR := KeyS;

          OpMode := 0; { Knackered }
          LStatus:=LFind_Rec(B_GetGEq,FNum,KPath,KeyS);

          { HM 16/12/99: Modified to create StkLoc records where necessary }
          If LStatusOk And CheckKey(KeyR,KeyS,Length(KeyR),BOn) Then Begin
            { found - get rec and update }
            GLobLocked:=BOff;
            Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked);
            LGetRecAddr(FNum);

            If OK And GlobLocked Then Begin
              OpMode := 2; { Editing }

              If (FNum = MLocF) Then LMStkLoc^ := LMLocCtrl^;
            End { If }
            Else
              Result := ErrRecLock;
          End { If }
          Else Begin
            { No Record Found }
            If (FNum = MLocF) Then Begin
              { Create StkLoc Record }
              OpMode := 1; { Add }

              FillChar (LMStkLoc^, SizeOf (LMStkLoc^), #0);
              LMStkLoc^.RecPFix := CostCCode;
              LMStkLoc^.SubType := CSubCode[BOff];
              LMStkLoc^.MStkLoc.lsLocCode:=LMLoc^.MLocLoc.loCode;
              SetROConsts(LStock, LMStkLoc^.MStkLoc, LMLoc^.MLocLoc);
            End { If }
            Else
              Result := ErrStock;
          End; { Else }

          If (Result = 0) Then Begin
            ValidErr := False;

            Case MiscValNo Of
              1  : If (NewVal >= 0.0) Then Begin
                     If StockMode Then Begin
                       { Stock }
                       LStock.QtyMin := NewVal;

                       // HM 23/05/03: Added setting of MinFlg/lsMinFlg so Re-Order list is updated correctly
                       LStock.MinFlg := (FreeStock(LStock) < LStock.QtyMin) And (LStock.QtyMin <> 0);
                     End { If StockMode }
                     Else
                       { Stock-Location X-Ref }
                       With LMStkLoc^.MStkLoc Do Begin
                         lsQtyMin := NewVal;

                         // HM 23/05/03: Added setting of MinFlg/lsMinFlg so Re-Order list is updated correctly
                         If Syss.FreeExAll Then
                           lsMinFlg := (lsQtyInStock < lsQtyMin) And (lsQtyMin <> 0)
                         Else
                           If Syss.UsePick4All Then
                             lsMinFlg := ((lsQtyInStock - lsQtyPicked) < lsQtyMin) And (lsQtyMin <> 0)
                           Else   //PR: 18/11/2015 ABSEXCH-10246 Amended to take account of WOR Allocations
                             lsMinFlg := ((lsQtyInStock - lsQtyAlloc -
                                             IfThen(Syss.UseWIss4All, lsQtyPickWOR, lsQtyAllocWOR)) < lsQtyMin) And (lsQtyMin <> 0);
                       End; { With LMStkLoc^.MStkLoc  }
                   End { If (NewVal >= 0.0) }
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }

              2  : If (NewVal >= 0.0) Then
                     Case StockMode Of
                       False : LMStkLoc^.MStkLoc.lsQtyMax := NewVal;
                       True  : LStock.QtyMax := NewVal;
                     End { Case }
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }

              3  : If (NewVal >= 0.0) Then Begin
                     // HM 19/05/03: Added to eliminate case sensitivity of code below
                     MiscValBand := UpperCase(MiscValBand);

                     If (Length(MiscValBand) > 0) And (MiscValBand[1] In ['A'..'H']) Then Begin
                       Case StockMode Of
                         False : LMStkLoc^.MStkLoc.lsSaleBands[1 + Ord(MiscValBand[1]) - Ord('A')].SalesPrice := NewVal;
                         True  : LStock.SaleBands[1 + Ord(MiscValBand[1]) - Ord('A')].SalesPrice := NewVal;
                       End; { Case }
                     End { If }
                     Else Begin
                       ValidErr := True;
                       Result := ErrPrice; { Invalid price band }
                     End; { Else }
                   End { If }
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }

              4  : If (NewVal >= 0.0) Then Begin
                     { HM 19/08/98: Modified to stop Cost Price being set on Bill Of Materials items }
                     If (LStock.StockType <> 'M') Then Begin
                       Case StockMode Of
                         False : LMStkLoc^.MStkLoc.lsCostPrice := NewVal;
                         True  : LStock.CostPrice := NewVal;
                       End; { Case }

                       If LSyss.AutoBillUp Then Begin
                         { Set 'Update Build Costs' flag }
                         CompObj.UpdateSys(1);
                       End; { If }
                     End { If }
                     Else Begin
                       ValidErr := True;
                       Result := ErrStock;  { invalid Stock Code - Cannot do BOM items }
                     End; { Else }
                   End { If }
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }

              5  : If (NewVal >= 0.0) Then
                     Case StockMode Of
                       False : LMStkLoc^.MStkLoc.lsRoPrice := NewVal;
                       True  : LStock.ROCPrice := NewVal;
                     End { Case }
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }

              9  : If (NewVal >= 0.0) Then
                     Case StockMode Of
                       False : With LMStkLoc^.MStkLoc Do Begin
                                 lsQtyTake := NewVal;
                                 lsStkFlg := True;
                               End;
                       True  : With LStock Do Begin
                                 QtyTake := NewVal;
                                 StkFlg := True;
                               End;
                     End { Case }
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }

              { Stock Units in SSD Unit }
              13 : If (NewVal >= 0.0) Then Begin
                     LStock.SuppSUnit := NewVal;
                   End { If }
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }

              { Sales Unit Weight }
              14 : If (NewVal >= 0.0) Then Begin
                     LStock.SWeight := NewVal;
                   End { If }
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }

              { Purchase Unit Weight }
              15 : If (NewVal >= 0.0) Then Begin
                     LStock.PWeight := NewVal;
                   End { If }
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }

              { HM 27/10/99: Added v4.31 fields }
              { Selling Qty Multiple }
              16 : If (NewVal >= 0.0) Then Begin
                     LStock.SellUnit := NewVal;
                   End { If }
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }
              { Purchase Qty   "     }
              17 : If (NewVal >= 0.0) Then Begin
                     LStock.BuyUnit := NewVal;
                   End { If }
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }

              18,
              19 : If (NewVal >= 0.0) And (NewVal <= 100.0) Then
                     Case MiscValNo Of
                       18 : LStock.SSDDUplift := NewVal;             { Intrastat Uplift Dispatch default % }
                       19 : LStock.SSDAUpLift := NewVal;             { Intrastat Uplift Arrivals default % }
                     End { Case }
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }

              // HM 25/06/02: Added WOP Support
              20 : If (NewVal >= 0.0) Then
                     LStock.MinEccQty := NewVal                     { Minimum Economic Build Quantity }
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }

              // HM 22/11/04: Added Get/Set for Re-Order Qty fields
              21 : If (NewVal >= 0.0) Then
                     Case StockMode Of
                       False : With LMStkLoc^.MStkLoc Do
                               Begin
                                 lsRoQty := Round_Up(NewVal, Syss.NoQtyDec);
                                 lsROFlg := (lsRoQty > 0);
                               End; // With LMStkLoc^.MStkLoc
                       True  : With LStock Do
                               Begin
                                 ROQty := Round_Up(NewVal, Syss.NoQtyDec);
                                 ROFlg := (ROQty > 0);
                               End; // With LStock
                     End { Case }
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }
              // HM 01/08/05: Added Returns Support
              // Restock Charge %
              28 : If (NewVal >= 0.0) And (NewVal <= 100.0) Then
                     LStock.ReStockPcnt := Round_Up(NewVal, 2)
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }

              // MH 04/04/2012 v6.10.1 ABSEXCH-12548: Added support for writing Intrastat State Uplift Despatches%
              // MH 16/05/2012 v6.10.1 ABSEXCH-12548: Extended range to +/- 100
              29 : If (NewVal >= -100.0) And (NewVal <= 100.0) Then
                     LStock.SSDDUplift := NewVal  // NOTE: No rounding in Exchequer
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }

              // MH 04/04/2012 v6.10.1 ABSEXCH-12547: Added support for writing Intrastat State Uplift Arrivals%
              // MH 16/05/2012 v6.10.1 ABSEXCH-12548: Extended range to +/- 100
              30 : If (NewVal >= -100.0) And (NewVal <= 100.0) Then
                     LStock.SSDAUpLift := NewVal  // NOTE: No rounding in Exchequer
                   Else Begin
                     ValidErr := True;
                     Result := ErrValue;  { invalid Value }
                   End; { Else }
            End; { Case }

            If (Not ValidErr) Then Begin
              { Update last amendment date/time }
              Case FNum Of
                StockF : Begin
                           With LStock Do Begin
                             LastUsed := Today;
                             TimeChange := TimeNowStr;
                           End; { LStock }

                           CheckStockNdx(LStock);
                         End;
                MLocF  : Begin
                           LMLocCtrl^ := LMStkLoc^;

                           With LMLocCtrl^.MStkLoc Do Begin
                             lsLastUsed := Today;
                             lsLastTime := TimeNowStr;
                           End; { LMLocCtrl^.MStkLoc }
                         End;
              End; { Case FNum }

              Case OpMode Of
                { Add new record }
                1 :
                begin
                  LStatus := LAdd_Rec (Fnum, KPath);

                  //GS 31/10/2011 Add Audit History Notes for v6.9
                  if LStatus = 0 then
                  begin
                    WriteAuditNote(anStock, anCreate, CompObj);
                  end;

                end;
                { update existing record }
                2 :
                begin
                  LStatus := LPut_Rec (Fnum, KPath);

                  //GS 31/10/2011 Add Audit History Notes for v6.9
                  if LStatus = 0 then
                  begin
                    WriteAuditNote(anStock, anEdit, CompObj);
                  end;

                end;
              End; { Case OpMode }
            End; { If (Not ValidErr) }

            If (OpMode = 2) Then Begin
              { Unlock record }
              {Status := UnlockMultiSing(F[Fnum], Fnum, RecAddr);}
              LUnLockMLock(FNum);
            End; { If (OpMode = 2) }

            If (Not ValidErr) Then Begin
              If (LStatus = 0) Then Begin
                Result := 0;

                { Update duplicate Stock/Location record }
                If (Not StockMode) Then
                  LMStkLoc^ := LMLocCtrl^;
              End { If }
              Else
                Result := ErrBtrBase + LStatus;
            End; { If }
          End; { If (Result = 0) }
        End; { If (Result = 0) }
      End; { With CompObj, CompanyBtr^ }
    End { If }
    Else
      Result := ErrPermit
  End; { If (Result = 0) }
End;


{ Updates the OLE Server window }
procedure TEnterpriseServer.UpdateComplist(Sender: TObject);
Var
  CompObj   : TCompanyInfo;
  I, Idx    : Integer;
  Sep : Str255;
begin
  { Check we aren't shutting down }
  If Assigned (BtrList) Then
    With Form_EnterpriseOleServer Do Begin
      { Save Position & Re-Initialise the list }
      Idx := List_Info.ItemIndex;
      InitList;

      If (Not Self.Destroying) Then Begin
        FillChar (Sep, SizeOf(Sep), '-');
        Sep[0] := #255;

        If DispStats Then Begin
          List_Info.Items.Add(Sep);
          List_Info.Items.Add('Instances: ' + IntToStr(Instances));
          List_Info.Items.Add(Sep);
          List_Info.Items.Add('Performance:');
          List_Info.Items.Add('  Requests:' + IntToStr(OpenComp));
          List_Info.Items.Add('  Hits:' + IntToStr(CacheHit));
          List_Info.Items.Add(Sep);
          List_Info.Items.Add('Companies Loaded (' + IntToStr(BtrList.Companies.Count) + '/' + IntToStr(MaxListItems) + '):');

          With BtrList Do
            If (Companies.Count > 0) Then
              For I := 0 To Pred(Companies.Count) do Begin
                CompObj := TCompanyInfo(Companies.Items[I]);
                List_Info.Items.Add('  ' + CompObj.CompanyCode + #9 + CompObj.CompanyName + ' (' + IntToStr(CompObj.ClientId) + ')');
              End; { For }
        End; { If }
      End; { If }

      { Re-Position in list }
      If (Idx < Pred(List_Info.Items.Count)) Then
        List_Info.ItemIndex := Idx
      Else
        List_Info.ItemIndex := Pred(List_Info.Items.Count);
    End; { With }
end;


{***********************************************************************}
{* GetCCDepName: Returns a Cost Centre or Department name              *}
{*                                                                     *}
{*               CCDpType: C = Cost Centre                             *}
{*                         D = Department                              *}
{***********************************************************************}
Function TEnterpriseServer.GetCCDepName(Var Company  : String;
                                        Var CCDpType : String;
                                        Var CCDpCode : String;
                                        Var CCDpName : String) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin
  Result := 0;
  CCDpName := '';

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (GetSecIIF (CCDpType = 'C', 485{98}, 486{99})) Then Begin
      If GetCCDepRec (CompObj.CompanyBtr, CCDpCode, (CCDpType = 'C')) Then
        With CompObj.CompanyBtr^Do
          CCDpName := LPassword.CostCtrRec.CCDesc
      Else
        If (CCDpType = 'C') Then
          Result := ErrCC
        Else
          Result := ErrDept;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End;


{***********************************************************************}
{* GetCompanyName: Returns the company name                            *}
{***********************************************************************}
Function TEnterpriseServer.GetCompanyName(Var FindCode : String;
                                          Var CompName : String) : SmallInt;
Const
  FNum    = CompF;
  KeyPath : Integer = CompCodeK;
Var
  KeyS : Str255;
  Stat : SmallInt;
Begin
  Result := 0;

  KeyS := FullCompCodeKey(cmCompDet, FindCode);
  Stat := Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, KeyPath, KeyS);
  If (Stat = 0) Then Begin
    CompName := Trim(Company^.CompDet.CompName);
  End { If }
  Else
    { Btrieve Error }
    If (Stat = 4) Then
      Result := ErrComp
    Else
      Result := ErrBtrBase + Stat;
End;


{***********************************************************************}
{* GetCompanyName: Returns the company name                            *}
{***********************************************************************}
Function TEnterpriseServer.GetLocationName(Var Company : String;
                                           Var LocCode : String;
                                           Var LocName : String) : SmallInt;
//Var
//  CompObj : TCompanyInfo;
Begin
//  Result := 0;
//  LocName := '';
//
//  { Load Company Data }
//  If BtrList.OpenCompany (Company, CompObj) Then Begin
//    If CompObj.CheckSecurity (489{108}) Then Begin
//      If GetLocRec (CompObj.CompanyBtr, LocCode) Then
//        With CompObj.CompanyBtr^ Do
//          LocName := LMLoc^.MLocLoc.loName
//      Else
//        Result := ErrLoc;
//    End { If }
//    Else
//      Result := ErrPermit;
//  End { If }
//  Else
//    Result := ErrComp;
  Result := GetLocationMiscStr(Company, LocCode, 1, LocName);
End;


{***********************************************************************}
{* GetCompanyName: Returns the company name                            *}
{***********************************************************************}
Function TEnterpriseServer.GetCurrencyName(Var Company  : String;
                                           Var CurrNo   : SmallInt;
                                           Var CurrName : String) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin
  Result := 0;
  CurrName := '';

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    With CompObj, CompanyBtr^ Do Begin
      If IsMultiCcy Then Begin
        If (CurrNo In [Low(LSyssCurr.Currencies)..High(LSyssCurr.Currencies)]) Then
          CurrName := LSyssCurr.Currencies[CurrNo].Desc
        Else
          Result := ErrCcy;
      End { If IsMultiCcy }
      Else Begin
        { Single Currency }
        If (CurrNo = 0) Then Begin
          CurrName := 'Single Currency'
        End { If (CurrNo = 0) }
        Else Begin
          Result := ErrCcy;
        End; { Else }
      End; { Else }
    End; { With CompObj, CompanyBtr^ }
  End { If }
  Else
    Result := ErrComp;
End;


{ Reconstitutes a SmallInt and LongInt that form }
{ a Real into a double.                          }
Function TEnterpriseServer.ConvertInts (Const Int2 : SmallInt;
                                        Const Int4 : LongInt) : Double;
Var
  TheRealArray : Array [1..6] Of Char;
  TheReal      : Real;
Begin
  { Note: Keep in sync with equivalent proc in EntFuncs.Dll }
  Move (Int2, TheRealArray[1], 2);
  Move (Int4, TheRealArray[3], 4);
  Move (TheRealArray[1], TheReal, 6);

  Result := TheReal;
End;


{ Returns the DocCnst signing constant for the specified invoice }
{ type                                                           }
Function TEnterpriseServer.DocSign(Const DocType : String) : SmallInt;
Var
  ReqDoc : ShortString;
  I      : DocTypes;
Begin
  Result := 0;
  ReqDoc := UpperCase(Copy(DocType, 1, 3));

  If (Trim(ReqDoc) <> '') Then
    For I := Low(DocTypes) To High(DocTypes) Do
      If (DocCodes[I] = ReqDoc) Then
        Result := DocCnst[I];
End;


{***********************************************************************}
{* GetJobBudgetValue: Returns a value for the specified budget in      *}
{*                    the specified companies data. ValueReq indicates *}
{*                    which of the history values is required:         *}
{*                      1 Budget Qty                                   *}
{*                      2 Budget Value                                 *}
{*                      3 Revised Budget Qty                           *}
{*                      4 Revised Budget Value                         *}
{*                      5 Actual Qty                                   *}
{*                      6 Actual Value                                 *}
{*                    If Committed is set then the Committed history   *}
{*                    values are used instead of the posted values     *}
{***********************************************************************}
Function TEnterpriseServer.GetJobBudgetValue(Var ValueReq  : SmallInt;
                                             Var Company   : String;
                                             Var TheYear   : SmallInt;
                                             Var ThePeriod : SmallInt; { 0 = YTD }
                                             Var TheCcy    : SmallInt;
                                             Var JobCode   : String;
                                             Var HistFolio : LongInt;
                                             Var Committed : WordBool;
                                             Var HistValue : Double) : SmallInt;
Var
  Key      : Str255;
  DicLink  : DictLinkType;
  CompObj  : TCompanyInfo;
  HistType : Char;
  PrYrMode : Byte;
Begin
  Result   := 0;
  HistValue := 0.0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (515{208}) Then Begin  { Job Records, View Totals }
      If GetJobRec (CompObj.CompanyBtr, JobCode) Then
        With CompObj.CompanyBtr^ Do Begin
          { Check for Job Type }
          If Committed Then
            HistType := CommitHCode
          Else
            HistType := LJobRec.JobType;

          Key := FullJDHistKey(LJobRec.JobCode, HistFolio);

          {With DicLink Do Begin
            DCr  := TheCcy;
            If (ThePeriod = 0) Then
              DPr := YTD
            Else
              DPr := ThePeriod;
            If (TheYear = 0) Then
              DYr := YTD
            Else
              DYr := TheYear - 1900;
          End; { With }
          BuildDicLink (CompObj, DicLink, ThePeriod, TheYear, TheCcy, PrYrMode);

          With CompObj, CompanyBtr^ Do
            Case ValueReq Of
              { Budget Qty }
              1 : HistValue := GetJBudgStats(Key, 0, HistType, DicLink, CompanyBtr, PrYrMode);
              { Budget Value }
              2 : HistValue := GetJBudgStats(Key, 1, HistType, DicLink, CompanyBtr, PrYrMode);
              { Revised Budget Qty }
              3 : HistValue := GetJBudgStats(Key, 2, HistType, DicLink, CompanyBtr, PrYrMode);
              { Revised Budget Value }
              4 : HistValue := GetJBudgStats(Key, 3, HistType, DicLink, CompanyBtr, PrYrMode);
              { Actual Qty }
              5 : HistValue := GetJBudgStats(Key, 4, HistType, DicLink, CompanyBtr, PrYrMode);
              { Actual Value }
              6 : HistValue := GetJBudgStats(Key, 5, HistType, DicLink, CompanyBtr, PrYrMode);
              { Debit / Purchase }
              7 : HistValue := GetJBudgStats(Key, 6, HistType, DicLink, CompanyBtr, PrYrMode);
              { Credit / Sales }
              8 : HistValue := GetJBudgStats(Key, 7, HistType, DicLink, CompanyBtr, PrYrMode);
            End; { Case }
        End { With }
      Else
        { Invalid Job code }
        Result := ErrJobCode;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    { Invalid Company }
    Result := ErrComp;
End;



{**********************************************************************}
{* SaveJCBudgetValue: Saves NewValue into the specified field of the  *}
{*                    specified budget in the specified Companies     *}
{*                    Data. SetValue indicates which field is set:    *}
{*                      1 Budget Qty                                  *}
{*                      2 Budget Value                                *}
{*                      3 Revised Budget Qty                          *}
{*                      4 Revised Budget Value                        *}
{*                   HM - 10/03/04 - Extended for Apps & Vals         *}
{*                      5 Next Valuation Amount                       *}
{*                      6 Next Valuation Percentage                   *}
{*                   MH 14/06/07 v5.71.002: Added support for recharge and overhead charge % *}
{*                      7 : Recharge                                  *}
{*                      8 : Overhead Charge%                          *}
{*                   HM - 27/10/08 - Extended for Budget Currency     *}
{*                      9 Budget Currency                             *}
{**********************************************************************}
Function TEnterpriseServer.SaveJCBudgetValue (Var SetValue  : SmallInt;
                                              Var Company   : String;
                                              Var BudgType  : String;
                                              Var TotalType : SmallInt;
                                              Var Committed : SmallInt;
                                              Var TheYear   : SmallInt;
                                              Var ThePeriod : SmallInt;   // Stores Basis for 5/6
                                              Var TheCcy    : SmallInt;
                                              Var JobCode   : String;
                                              Var StockId   : String;
                                              Var NewValue  : Double) : SmallInt;
Const
  FNum = NHistF;
  KPath = NHK;
Var
  KeyS, KeyR        : Str255;
  CompObj           : TCompanyInfo;
  HistType          : Char;
  GotRec, IsPayMode : Boolean;
  lAnalysis         : ^JobAnalType;
  lPayRate          : ^EmplPayType;
  Locked            : Boolean;
  YTDPer, NewCcy    : SmallInt;
  NewHist   : HistoryRec;
  HistValue : Double;
  ValueReq  : SmallInt;
  GetPeriod : SmallInt;
  GetYear   : SmallInt;
  GetCommit : WordBool;
  JCode     : String;
Begin
  Result := 0;

  If (ThePeriod > 0) Then Begin
    If (TheYear > 0) Then Begin
      { Load Company Data }
      Result := BtrList.OpenSaveCompany (Company, CompObj);
      If (Result = 0) Then Begin
        // SSK 30/08/2016 R3 ABSEXCH-12531 : Added condition to validate period
        If ValidatePeriod(ThePeriod, CompObj)  Then {Check Period against System Setup Period}
        Begin
          If CompObj.CheckSecurity (517{208}) Then Begin
            { Check we have a valid Budget Type }
            BudgType := UpperCase(Trim(BudgType));

            // HM 11/09/01: Added specific support for Pay-Rate Budgets
            IsPayMode := (Length(BudgType) = 1) And (BudgType[1] = 'P');
            If IsPayMode Then BudgType := JBSCode;

            If (Length(BudgType) = 1) And (BudgType[1] In [JBBCode, JBMCode, JBSCode]) Then Begin
              { Get Job Record }
              If GetJobRec (CompObj.CompanyBtr, JobCode) Then
                { Get Job Budget Record }
                With CompObj, CompanyBtr^ Do Begin
                  New (lAnalysis);
                  FillChar (lAnalysis^, SizeOf(lAnalysis^), #0);
                  New (lPayRate);
                  FillChar (lPayRate^, SizeOf(lPayRate^), #0);

                  If (BudgType[1] = JBMCode) Then Begin
                    StockId := FullNomKey (TotalType);
                  End; { If }

                  { Always load record too make sure we have the latest and greatest }
                  KeyS := PartCCKey(JBRCode, BudgType[1]) + FullJBCode(JobCode, 0{TheCcy}, StockId);
                  KeyR := KeyS;
                  GotRec := LGetMainRec (JCtrlF, KeyS);

                  // HM 11/09/01: Added creating of Job budget record for Anal and Pay-Rate/Stock Budgets
                  If (Not GotRec) And (BudgType[1] In [JBBCode, JBSCode]) Then Begin
                    // Validate the Anal Code, Stock Code or Total Type - if OK then add a new budget record
                    If (BudgType[1] = JBBCode) Then Begin
                      // Analysis Budgets - Get Analysis Record
                      GotRec := GetJobMiscRec (CompObj.CompanyBtr, FullJACode(Trim(StockId)), 2);
                      If GotRec Then
                        // Make local temporary copy of Analysis record
                        lAnalysis^ := LJobMisc.JobAnalRec
                      Else
                        // Invalid Analysis Code
                        Result := ErrJobAnal;
                    End { If (BudgType[1] = JBBCode) }
                    Else
                      If (BudgType[1] = JBSCode) And (Not IsPayMode) Then Begin
                        // Stock Budget - Validate Stock Code
                        GotRec := GetStockRec (CompObj.CompanyBtr, FullStockCode(Trim(StockId)));
                        If (Not GotRec) Then
                          Result := ErrStock;
                      End { If (BudgType[1] = JBSCode) }
                      Else Begin
                        // Pay-Rate Budget - Validate Pay-Rate Code
                        GotRec := GetTimeRate (CompanyBtr, '', Trim(StockId));
                        If GotRec Then
                          lPayRate^ := LJobCtrl^.EmplPay
                        Else
                          Result := ErrTimeRate;
                      End; { Else }

                    If GotRec Then Begin
                      // Details validated OK - Create new Job Budget record
                      LResetRec (JCtrlF);
                      With LJobCtrl^ Do Begin
                        RecPFix := JBRCode;
                        SubType := BudgType[1];

                        JobBudg.JobCode := FullJobCode(JobCode);
                        JobBudg.PayRMode := IsPayMode;
                        JobBudg.ReCharge := (LJobRec.ChargeType = 3);
                        JobBudg.JBudgetCurr := TheCcy;
                        Case BudgType[1] Of
                          // Analysis Budgets
                          JBBCode : Begin
                                      JobBudg.AnalCode := UpCaseStr (FullJACode(StockId));
                                      JobBudg.BType := lAnalysis.JAType;
                                      JobBudg.AnalHed := lAnalysis.AnalHed;

                                      JobBudg.BudgetCode := FullJBCode(JobBudg.JobCode, 0, JobBudg.AnalCode);
                                      //JobBudg.Code2NDX := FullJBDDKey (JobBudg.JobCode, JobBudg.AnalHed);
                                      JobBudg.Code2NDX := FullJobCode(JobBudg.JobCode)+FullNomKey(JobBudg.AnalHed)+HelpKStop;
                                    End; // Analysis Budgets

                          // Pay-Rate/Stock Budgets
                          JBSCode : Begin
                                      JobBudg.StockCode := LStock.StockCode;

                                      If IsPayMode Then Begin
                                        JobBudg.AnalCode  := lPayRate.EAnalCode;
                                        JobBudg.StockCode := FullStockCode (lPayRate.EStockCode);
                                        JobBudg.UnitPrice := Currency_ConvFT(lPayRate.Cost,
                                                                             lPayRate.CostCurr,
                                                                             JobBudg.CurrBudg,
                                                                             UseCoDayRate);
                                        If IsMultiCcy Then JobBudg.CurrPType := lPayRate.CostCurr;
                                      End { If IsPayMode }
                                      Else
                                        JobBudg.AnalCode := LStock.JAnalCode;

                                      JobBudg.BudgetCode := FullJBCode(JobBudg.JobCode, 0, JobBudg.StockCode);
                                      //JobBudg.Code2NDX := FullJDAnalKey (JobBudg.JobCode, JobBudg.AnalCode);
                                      JobBudg.Code2NDX := FullJobCode(JobBudg.JobCode)+FullJACode(JobBudg.AnalCode);
                                    End; // Pay-Rate/Stock Budgets
                        End; { Case BudgType[1] }

                        // Generate new folio number
                        KeyS := FullJobCode(lJobRec.JobCode);
                        Locked := False;
                        If LGetMultiRec(B_GetDirect,B_MultLock,KeyS,JobCodeK,JobF,BOn,Locked) And Locked Then Begin
                          LGetRecAddr(JobF);

                          JobBudg.HistFolio := LJobRec.ALineCount;
                          Inc (LJobRec.ALineCount);

                          LStatus:=LPut_Rec(JobF,JobCodeK);
                          If (lStatus <> 0) Then
                            // Return Btrieve error code
                            Result := 600 + LStatus;
                          LUnLockMLock(JobF);
                        End { If LGetMultiRec }
                        Else
                          Result := ErrRecLock;
                      End; { With }

                      If (Result = 0) Then Begin
                        GotRec := (LAdd_Rec (JCtrlF, 0) = 0);

                        If GotRec Then
                          KeyS := KeyR;
                      End; { If (Result = 0) }
                    End; { If GotRec }
                  End; { If (Not GotRec) }

                  If GotRec And CheckKey(KeyR,KeyS,Length(KeyR),BOn) Then Begin
                    // HM 10/03/04: Modified to enter this section for the new Apps & Vals fields which are
                    // always picked up from the budget record rather than the history record
                    If (Not LSyssJob.JobSetup.PeriodBud) Or (SetValue In [5..9]) Then Begin
                      { Budgets are on Budget Record - lock and update }
                      GLobLocked:=BOff;
                      Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,0,JCtrlF,BOn,GlobLocked);
                      LGetRecAddr(JCtrlF);

                      If OK And GlobLocked Then Begin
                        With LJobCtrl^.JobBudg Do
                          Case SetValue Of
                            1 : BoQty   := NewValue;    { Orig Qty }
                            2 : BoValue := NewValue;    { Orig Budget }
                            3 : BrQty   := NewValue;    { Revised Qty }
                            4 : BRValue := NewValue;    { Revised Budget }

                            // HM - 10/03/04 - Extended for Apps & Vals
                            5 : Begin
                                  RevValuation := NewValue;
                                  JABBasis := ThePeriod - 1;

                                  // Calculate Percentage
                                  If (BRValue <> 0.0) Then
                                  Begin
                                    JAPcntApp := Round_Up(DivWchk(RevValuation,BRValue)*100,2);
                                  End // If
                                  Else
                                  Begin
                                    JAPcntApp := Round_Up(DivWchk(RevValuation,BOValue)*100,2);
                                  End; // Else
                                End;
                            6 : Begin
                                  JAPcntApp := NewValue;

                                  // Calculate Amount
                                  If (BRValue <> 0.0) Then
                                  Begin
                                    RevValuation := Round_Up(DivWchk(JAPcntApp,100)*BRValue,2);
                                  End // If
                                  Else
                                  Begin
                                     RevValuation := Round_Up(DivWchk(JAPcntApp,100)*BOValue,2);
                                  End; // Else
                                End;

                            // MH 14/06/07 v5.71.002: Added support for recharge and overhead charge %
                            7 : Begin // Recharge
                                  // NOTE: in order to bodge a boolean into a double I am using 0.0 to represent False
                                  // and 100 to represent true and in order to prevent rounding errors potentially screwing
                                  // things up I then compare it against 50 so that it doesn't matter whether it is 0.00000001
                                  // or 99.99999, the results will be the same.
                                  If (NewValue < 50) Then
                                    Recharge := False
                                  Else
                                    Recharge := True;
                                End; // Recharge
                            8 : Begin // Overhead Charge%
                                  OverCost := Round_Up(NewValue, 2);

                                  // Supports 0% - 99.99%
                                  If (OverCost < 0.0) Or (OverCost >= 100) Then
                                    Result := ErrValue;
                                End; // // Overhead Charge%

                            // MH 27/10/08: Added support for Budget Cuyrrency (MD Events)
                            9 : Begin // Budget Currency
                                  NewCcy := Round(NewValue);
                                  If CompObj.IsMultiCcy Then
                                  Begin
                                     // Multi-Currency Company
                                     If Not (NewCcy In [1..CurrencyType]) Then
                                       Result := ErrCcy;
                                  End // If CompObj.IsMultiCcy
                                  Else
                                  Begin
                                    // Single Currency Company }
                                    If (NewCcy <> 0) Then
                                      Result := ErrCcy;
                                  End; // Else

                                  If (Result = 0) Then
                                    JBudgetCurr := NewCcy;
                                End; // Budget Currency
                          End; { Case }

                        // Don't do update if there is a validation error
                        If (Result = 0) Then
                        Begin
                          { update record }
                          LStatus := LPut_Rec (JCtrlF, 0);
                          If (LStatus = 0) Then
                            Result := 0
                          Else
                            Result := ErrBtrBase + LStatus;
                        End; // If (Result = 0)

                        LUnlockMLock(JCtrlF);
                      End { If }
                      Else
                        Result := ErrRecLock;
                    End { If }
                    Else Begin
                      { Budgets are in history - now it gets complicated }
                      If (Committed <> 0) Then
                        HistType := CommitHCode
                      Else
                        HistType := LJobRec.JobType;

                      KeyS := FullNHistKey(HistType,
                                           FullNHCode (FullJDHistKey(LJobRec.JobCode, LJobCtrl^.JobBudg.HistFolio)),
                                           TheCcy,
                                           TheYear-1900,
                                           ThePeriod);


                      If (Not LCheckExsists(KeyS, FNum, KPath)) Then Begin
                        { Record doesn't exist - Set and Add }
                        LResetRec (FNum);
                        With LNHist Do Begin
                          Code := FullNHCode (FullJDHistKey(LJobRec.JobCode, LJobCtrl^.JobBudg.HistFolio));
                          ExClass := HistType;
                          Cr := TheCcy;
                          Yr := TheYear - 1900;
                          Pr := ThePeriod;
                        End; { With }

                        //LNHist.Budget := NewValue;
                        Case SetValue Of
                          1 : LNHist.Value1 := NewValue;
                          2 : LNHist.Budget := NewValue;
                          3 : LNHist.Value2 := NewValue;
                          4 : LNHist.RevisedBudget1 := NewValue;
                        End; { Case }

                        LStatus := LAdd_Rec (Fnum, KPath);
                        If Not LStatusOk Then
                          Result := ErrBtrBase + LStatus;

                        // HM 14/12/04: Check for YTD entry and create if missing
                        If (LJobRec.JobType In YTDSet) Then YTDPer := YTD Else YTDPer := YTDNCF;
                        KeyS := FullNHistKey(HistType,
                                             FullNHCode (FullJDHistKey(LJobRec.JobCode, LJobCtrl^.JobBudg.HistFolio)),
                                             TheCcy,
                                             TheYear-1900,
                                             YTDPer);
                        If (Not LCheckExsists(KeyS, FNum, KPath)) Then
                        Begin
                          // Record doesn't exist - Set and Add
                          FillChar (NewHist, SizeOf (NewHist), #0);
                          With NewHist Do Begin
                            Code := FullNHCode (FullJDHistKey(LJobRec.JobCode, LJobCtrl^.JobBudg.HistFolio));
                            ExClass := HistType;
                            Cr := TheCcy;
                            Yr := TheYear - 1900;
                            Pr := YTDPer;

                            If (LJobRec.JobType In YTDSet) Then
                            Begin
                              GetPeriod := 0;
                              GetYear   := TheYear - 1;
                              GetCommit := (Committed <> 0);
                              JCode := LJobRec.JobCode;

                              // Actual Qty
                              ValueReq := 5;
                              If (GetJobBudgetValue(ValueReq, Company, GetYear, GetPeriod, TheCcy, JCode, LJobCtrl^.JobBudg.HistFolio, GetCommit, HistValue) = 0) Then
                                Cleared := HistValue;

                              // Debits / Purchases
                              ValueReq := 7;
                              If (GetJobBudgetValue(ValueReq, Company, GetYear, GetPeriod, TheCcy, JCode, LJobCtrl^.JobBudg.HistFolio, GetCommit, HistValue) = 0) Then
                                Purchases := HistValue;

                              // Credit / Sales
                              ValueReq := 8;
                              If (GetJobBudgetValue(ValueReq, Company, GetYear, GetPeriod, TheCcy, JCode, LJobCtrl^.JobBudg.HistFolio, GetCommit, HistValue) = 0) Then
                                Sales := HistValue;
                            End; // If (LNom.NomType In YTDSet)
                          End; { With }

                          LNHist := NewHist;
                          LStatus := LAdd_Rec (Fnum, KPath);
                          If Not LStatusOk Then
                            Result := ErrBtrBase + LStatus;
                        End; { If (Not LCheckExsists }
                      End { If }
                      Else Begin
                        { found - get rec and update }
                        GLobLocked:=BOff;
                        Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked);
                        LGetRecAddr(FNum);

                        Case SetValue Of
                          1 : LNHist.Value1 := NewValue;
                          2 : LNHist.Budget := NewValue;
                          3 : LNHist.Value2 := NewValue;
                          4 : LNHist.RevisedBudget1 := NewValue;
                        End; { Case }

                        { update record }
                        LStatus := LPut_Rec (Fnum, KPath);
                        LUnlockMLock(FNum);
                        If Not LStatusOk Then
                          Result := ErrBtrBase + LStatus;
                      End;
                    End; { Else }
                  End { If }
                  Else
                    Result := ErrBudget;

                  Dispose (lPayRate);
                  Dispose (lAnalysis);
                End { With }
              Else
                { Invalid Job code }
                Result := ErrJobCode;
            End { If }
            Else
              { Invalid Budget Type }
              Result := ErrBudget;
          End { If }
          Else
            Result := ErrPermit;
        End { If ValidatePeriod }
        Else
          Result := ErrPeriod;            
      End; { If (Result = 0) }
    End { If }
    Else
      Result := ErrYear;
  End { If }
  Else
    Result := ErrPeriod;
End;



{***********************************************************************}
{* GetJobTotalStr: Returns a value for the specified budget in      *}
{*                    the specified companies data. ValueReq indicates *}
{*                    which of the history values is required:         *}
{*                      1 Budget Qty                                   *}
{*                      2 Budget Value                                 *}
{*                      3 Revised Budget Qty                           *}
{*                      4 Revised Budget Value                         *}
{*                      5 Actual Qty                                   *}
{*                      6 Actual Value                                 *}
{*                    If Committed is set then the Committed history   *}
{*                    values are used instead of the posted values     *}
{***********************************************************************}
Function TEnterpriseServer.GetJobTotalStr(Var ValueReq : SmallInt;
                                          Var Company  : String;
                                          Var TotalStr : String) : SmallInt;
Var
  CompObj  : TCompanyInfo;
Begin
  Result   := 0;
  TotalStr := '';

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then
  Begin
    If CompObj.CheckSecurity (515) Then
    Begin
      With CompObj.CompanyBtr^.LSyssJob.JobSetup Do Begin  { Job Records, View Totals }
        If (ValueReq >= Low(SummDesc)) And (ValueReq <= High(SummDesc)) Then
          TotalStr := SummDesc[ValueReq]
        Else
          TotalStr := 'Profit';
      End; { With }
    End // If CompObj.CheckSecurity (515)
    Else
      Result := ErrPermit;
  End { If }
  Else
    { Invalid Company }
    Result := ErrComp;
End;


{ Sets the DicLink Year, Period and Currency based on the passed values }
Procedure TEnterpriseServer.BuildDicLink (Const CompObj     : TCompanyInfo;
                                          Var   DicLink     : DictLinkType;
                                          Const ThePeriod,
                                                TheYear,
                                                TheCurrency : SmallInt;
                                          Var   PrYrMode    : Byte);
Begin { BuildDicLink }
  With DicLink, CompObj Do Begin
    { Set mode to default }
    PrYrMode := 0;

    { Currency }
    DCr := TheCurrency;

    { Period }
    DYr := 0;
    If (ThePeriod = 0) Then Begin
      { 0 = YTD - Total for everything up to specified year }
      DPr := YTD;
    End { If }
    Else
      If (ThePeriod = -99) Then
        { -99 = F6 Period }
        DPr := CompanyBtr^.LSyss.CPr
      Else
        If (ThePeriod = -98) Then Begin
          { -98 = CTD - Total for everything ever }
          DPr := YTD;
          DYr := 255;
        End { If }
        Else
          If (ThePeriod >= 101) And (ThePeriod <= 199) Then Begin
            { CTD Period Offset }
            Dpr := ThePeriod - 100;
            PrYrMode := 1; { CTD Period/Year }
          End { If }
          Else
            { Normal Period }
            DPr := ThePeriod;

    { Don't reset the Year if doing CTD }
    If (DYr = 0) Then Begin
      { Year }
      If (TheYear = 0) Then
        DYr := YTD
      Else
        If (TheYear = -99) Then
          { -99 = F6 Year }
          DYr := CompanyBtr^.LSyss.CYr
        Else
          DYr := TheYear - 1900;
    End; { If }
  End; { With }
End; { BuildDicLink }


{*************************************************************************}
{* GetJCBudgetValue: Returns a value for the specified Job Budget Record *}
{*                   specified companies data. ValueReq indicates which  *}
{*                   of the stock values is required:                    *}
{*                      1 Budget Qty                                     *}
{*                      2 Budget Value                                   *}
{*                      3 Revised Budget Qty                             *}
{*                      4 Revised Budget Value                           *}
{*                      5 Actual Qty                                     *}
{*                      6 Actual Value                                   *}
{*                   HM - 10/03/04 - Extended for Apps & Vals            *}
{*                      7 Valuation To Date                              *}
{*                      8 Next Valuation Amount                          *}
{*                      9 Next Valuation Percentage                      *}
{*************************************************************************}
Function TEnterpriseServer.GetJCBudgetValue (Var ValueReq  : SmallInt;
                                             Var Company   : String;
                                             Var BudgType  : String;
                                             Var TotalType : SmallInt;
                                             Var Committed : SmallInt;
                                             Var TheYear   : SmallInt;
                                             Var ThePeriod : SmallInt;
                                             Var TheCcy    : SmallInt;
                                             Var JobCode   : String;
                                             Var StockId   : String;
                                             Var HistVal   : Double) : SmallInt;
Var
  CompObj        : TCompanyInfo;
  KeyS           : Str255;
  GotRec         : Boolean;
  SpecialContractMode : Boolean;
  Commit         : WordBool;
  nYear, nPeriod : SmallInt;
  BaseOffset     : Double;
  oAnalCode      : TCachedDataRecord;
  oJobCode       : TCachedDataRecord;

  //------------------------------

  Function AccumulateContractTotal : SmallInt;
  Var
    slJobs : TStringList;
    sJob : String;
    iJob : LongInt;
    lHistVal : Double;

    // Recursively run through the Job Tree loading the Jobs for the specified JobCode
    Procedure FindJobs (ParentCode : ShortString);
    Var
      sKey : Str255;
      iRes : SmallInt;
      TmpRecAddr : LongInt;
    Begin // FindJobs
      ParentCode := FullJobCode(ParentCode);

      With CompObj, CompanyBtr^ Do
      Begin
        sKey := ParentCode;
        iRes := LFind_Rec(B_GetGEq, JobF, JobCatK, sKey);
        While (iRes = 0) And (LJobRec.JobCat = ParentCode) Do
        Begin
          If (LJobRec.JobType = JobGrpCode) Then
          Begin
            // Process sub-contract
            LGetPos (JobF, TmpRecAddr);
            FindJobs (LJobRec.JobCode);
            Move(TmpRecAddr,LJobRec^,Sizeof(TmpRecAddr));
            LGetDirect(JobF, JobCatK, 0);
          End // If (LJobRec.JobType = JobGrpCode)
          Else
            // Job
            slJobs.Add (LJobRec.JobCode);

          iRes := LFind_Rec(B_GetNext, JobF, JobCatK, sKey);
        End; // While (iRes = 0) And (LJobRec.JobCat = ParentCode)
      End; // With CompObj, CompanyBtr^
    End; // FindJobs

  Begin // AccumulateContractTotal
    Result := 0;

    // Build up a list of jobs within the requested contract - it is easier to cache them up at the
    // start as the OLE function we are calling will change the position
    slJobs := TStringList.Create;
    Try
      FindJobs (JobCode);

      If (slJobs.Count > 0) Then
      Begin
        For iJob := 0 To (slJobs.Count - 1) Do
        Begin
          sJob := slJobs[iJob];
          Result := GetJCBudgetValue (ValueReq, Company, BudgType, TotalType, Committed, TheYear, ThePeriod, TheCcy, sJob, StockId, lHistVal);
          If (Result = 0) Then
            HistVal := HistVal + lHistVal
          Else
            Break
        End; // For iJob
      End; // If (slJobs.Count > 0)
    Finally
      slJobs.Free;
    End; // Try..Finally
  End; // AccumulateContractTotal

  //------------------------------

Begin
  Result := 0;
  HistVal := 0.0;

  SpecialContractMode := False;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then
    If CompObj.CheckSecurity (515{208}) Then Begin
      { Check we have a valid Budget Type }
      BudgType := UpperCase(Trim(BudgType));
      If (Length(BudgType) = 1) And (BudgType[1] In [JBBCode, JBMCode, JBSCode]) Then Begin
        { Get Job Record }
        //If GetJobRec (CompObj.CompanyBtr, JobCode) Then

        // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added caching on Job Codes
        oJobCode := CompObj.JobCodeCache.GetJobCode (JobCode);
        If Assigned(oJobCode) Then
        Begin
          // Copy details out of cache into LNom record
          oJobCode.DownloadRecord (@CompObj.CompanyBtr^.LJobRec^);
          GotRec := True;
        End // If Assigned(oJobCode)
        Else
        Begin
          // Lookup job and add to cache for next time
          GotRec := GetJobRec (CompObj.CompanyBtr, JobCode);
          If GotRec Then
            CompObj.JobCodeCache.AddToCache (CompObj.CompanyBtr^.LJobRec^.JobCode, @CompObj.CompanyBtr^.LJobRec^, SizeOf(JobRecType));
        End; // Else

        If GotRec Then
        Begin
          { Get Job Budget Record }
          With CompObj, CompanyBtr^ Do Begin
            GotRec := True;
            If (BudgType[1] = JBMCode) Then Begin
              StockId := FullNomKey (TotalType);
            End { If }
            Else
              If (BudgType[1] = JBBCode) Then Begin
                { Validate Analysis Code }
                If (Trim(StockId) <> '') Then
                Begin
                  // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added caching on Analysis Codes
                  oAnalCode := CompObj.AnalysisCodeCache.GetAnalysisCode (StockId);
                  If Assigned(oAnalCode) Then
                  Begin
                    // Copy details out of cache into LNom record
                    oAnalCode.DownloadRecord (@CompObj.CompanyBtr^.LJobMisc^);
                    GotRec := True;
                  End // If Assigned(oAnalCode)
                  Else
                  Begin
                    // Lookup nominal and add to cache for next time
                    GotRec := GetJobMiscRec (CompObj.CompanyBtr, StockId, 2);
                    If GotRec Then
                      CompObj.AnalysisCodeCache.AddToCache (CompObj.CompanyBtr^.LJobMisc.JobAnalRec.JAnalCode, @CompObj.CompanyBtr^.LJobMisc^, SizeOf(JobMiscRec));
                  End; // Else

                  { check code exists }
                  //GotRec := GetJobMiscRec (CompObj.CompanyBtr, StockId, 2)
                End // If (Trim(StockId) <> '')
                Else
                  { Cannot be blank }
                  GotRec := False;
              End; { If }

            If GotRec Then Begin
              { HM 08/03/99: Modified on EL's advice as record is always consolidated }
              KeyS := FullJBCode(JobCode, 0{TheCcy}, StockId);

              { Check to see if the record is already loaded }
              If (LJobCtrl^.RecPFix <> JBRCode) Or
                 (LJobCtrl^.SubType <> BudgType[1]) Or
                 (Not CheckKey(LJobCtrl^.JobBudg.BudgetCode,KeyS,Length(LJobCtrl^.JobBudg.BudgetCode),BOn)) Then
              Begin
                { Record Not Loaded - Load }
                KeyS := PartCCKey(JBRCode, BudgType[1]) + KeyS;
                GotRec := LGetMainRec (JCtrlF, KeyS);

                If (Not GotRec) And (LJobRec.JobType = JobGrpCode) And (Not LSyssJob.JobSetup.PeriodBud) Then
                Begin
                  // The record we attempted to load is only created when actuals are first posted
                  // for contracts so if it fails we should run through the jobs within the contract
                  // and accumulate the individual settings
                  Result := AccumulateContractTotal;
                  SpecialContractMode := True;
                End; // If (Not GotRec) And (LJobRec.JobType = JobGrpCode) And LSyssJob.JobSetup.PeriodBud
              End { If }
              Else
                { Record already loaded }
                GotRec := True;

              If GotRec And (Not SpecialContractMode) Then Begin
                // HM 10/03/04: Modified to enter this section for the new Apps & Vals fields which are
                // always picked up from the budget record rather than the history record
                If ((ValueReq In [1..4]) And (Not LSyssJob.JobSetup.PeriodBud)) Or (ValueReq In [7..12]) Then
                Begin
                  With LJobCtrl^.JobBudg Do
                  begin
                    Case ValueReq Of
                      1  : HistVal := BoQty;     { Orig Qty }
                      2  : HistVal := BoValue;   { Orig Budget }
                      3  : HistVal := BrQty;     { Revised Qty }
                      4  : HistVal := BRValue;   { Revised Budget }

                      // HM - 10/03/04 - Extended for Apps & Vals
                      7  : HistVal := OrigValuation;
                      8  : HistVal := RevValuation;
                      9  : HistVal := JAPcntApp;

                      // MH 14/06/07 v5.71.002: Added support for recharge and overhead charge %
                      10 : HistVal := OverCost;
                      // NOTE: in order to bodge a boolean into a double I am using 0.0 to represent False
                      // and 100 to represent true and in order to prevent rounding errors potentially screwing
                      // things up I then compare it against 50 so that it doesn't matter whether it is 0.00000001
                      // or 99.99999, the results will be the same.
                      11 : HistVal := IfThen(Recharge, 100.0, 0.0);
                      12 : HistVal := JBudgetCurr;
                    End; { Case }
                    if (ValueReq <> 12) then
                      HistVal := JBBCurrency_TXlate(HistVal, JBudgetCurr, TheCcy);
                  End;
                End // If ((ValueReq In [1..4]) And (Not LSyssJob.JobSetup.PeriodBud)) Or (ValueReq In [7..11])
                Else Begin
                  Commit := (Committed <> 0);
                  Result := GetJobBudgetValue(ValueReq,
                                              Company,
                                              TheYear,
                                              ThePeriod,
                                              TheCcy,
                                              JobCode,
                                              LJobCtrl^.JobBudg.HistFolio,
                                              Commit,
                                              HistVal);

                  // HM 17/03/03: Modified to support Period 1xx calls
                  If (ValueReq In [5, 6]) And ((ThePeriod >= 101) And (ThePeriod <= 199)) Then Begin
                    // Calc previous year YTD to subtract from this years calculated total to generate
                    // correct 1xx value
                    nYear := Pred(TheYear);
                    nPeriod := 0;
                    BaseOffset := 0.0;
                    Result := GetJobBudgetValue(ValueReq,
                                                Company,
                                                nYear,
                                                nPeriod,
                                                TheCcy,
                                                JobCode,
                                                LJobCtrl^.JobBudg.HistFolio,
                                                Commit,
                                                BaseOffset);

                    // Subtract from existing total to get 1xx total
                    HistVal := HistVal - BaseOffSet;
                  End; { If (ValueReq ... }
                End; { Else }
              End { If }
              Else Begin
                //Result := ErrBudget;
                If (Not SpecialContractMode) Then
                Begin
                  // HM 24/05/99: Modified to return 0 if budget record doesn't exist
                  //              due to wingeing from everyone.
                  Result := 0;
                  HistVal := 0.0;
                End; // If (Not SpecialContractMode)
              End; { Else }
            End { If }
            Else
              { Invalid Analysis Code }
              Result := ErrJobAnal;
          End { If }
        End // If GotRec
        Else
          { Invalid Job code }
          Result := ErrJobCode;
      End { If }
      Else
        { Invalid Budget Type }
        Result := ErrBudget;
    End { If }
    Else
      Result := ErrPermit
  Else
    Result := ErrComp;
End;


{***********************************************************************}
{* GetJobMiscStr: Returns a specified string from the specifid Job     *}
{***********************************************************************}
Function TEnterpriseServer.GetJobMiscStr(Var Company  : String;
                                         Var JobCode  : String;
                                         Var JobStr   : String;
                                         Var JobStrNo : SmallInt) : SmallInt;
Var
  CompObj : TCompanyInfo;
  oJobCode : TCachedDataRecord;
  GotRec    : Boolean;
Begin { GetJobMiscStr }
  Result := 0;
  JobStr := '';

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (514{206}) Then Begin
      { Get Job Record }
      //If GetJobRec (CompObj.CompanyBtr, JobCode) Then Begin

      // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added caching on Job Codes
      oJobCode := CompObj.JobCodeCache.GetJobCode (JobCode);
      If Assigned(oJobCode) Then
      Begin
        // Copy details out of cache into LNom record
        oJobCode.DownloadRecord (@CompObj.CompanyBtr^.LJobRec^);
        GotRec := True;
      End // If Assigned(oJobCode)
      Else
      Begin
        // Lookup job and add to cache for next time
        GotRec := GetJobRec (CompObj.CompanyBtr, JobCode);
        If GotRec Then
          CompObj.JobCodeCache.AddToCache (CompObj.CompanyBtr^.LJobRec^.JobCode, @CompObj.CompanyBtr^.LJobRec^, SizeOf(JobRecType));
      End; // Else

      If GotRec Then
      Begin
        With CompObj.CompanyBtr.LJobRec^ Do Begin
          Case JobStrNo Of
            1  : JobStr := JobDesc;          { Name/Description }
            2  : JobStr := CustCode;         { Customer }
            3  : JobStr := JobCat;           { Code of Parent on Tree }
            4  : JobStr := JobAltCode;       { Alternative search code}
            5  : JobStr := Contact;          { Contact }
            6  : JobStr := JobMan;           { Job Manager's name }
            7  : JobStr := PoutDateB(StartDate);        { Start Date }
            8  : JobStr := PoutDateB(EndDate);          { End Date }
            9  : JobStr := PoutDateB(RevEDate);         { Revised completion date }
            10 : JobStr := SORRef;           { Sales Order Number}
            11 : JobStr := UserDef1;         { User def 1 string }
            12 : JobStr := UserDef2;         { User def 2 string }
            13 : JobStr := UserDef3;         { User def 3}
            14 : JobStr := UserDef4;         { User def 4}

            // MH 19/04/06: Added Job Type for Wish 20050804104641
            15 : JobStr := JobAnal;

            // MH 19/04/06: Added QSCode for Wish 20050408172159
            16 : JobStr := JQSCode;

            // MH 28/10/2011 v6.9: Added support for udefs 5-10
            17 : JobStr := UserDef5;
            18 : JobStr := UserDef6;
            19 : JobStr := UserDef7;
            20 : JobStr := UserDef8;
            21 : JobStr := UserDef9;
            22 : JobStr := UserDef10;
          End; { Case }
        End; { With }
      End // If GotRec
      Else
        Result := ErrJobCode;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End;  { GetJobMiscStr }


{***********************************************************************}
{* GetJobMiscStr: Returns a specified integer from the specifid Job    *}
{***********************************************************************}
Function TEnterpriseServer.GetJobMiscInt(Var Company  : String;
                                         Var JobCode  : String;
                                         Var JobInt   : LongInt;
                                         Var JobIntNo : SmallInt) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin { GetJobMiscInt }
  Result := 0;
  JobInt := 0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (514{206}) Then Begin
      { Get Job Record }
      If GetJobRec (CompObj.CompanyBtr, JobCode) Then Begin
        With CompObj.CompanyBtr.LJobRec^ Do Begin
          Case JobIntNo Of
            1  : JobInt := ChargeType;          { Charge Type }
            2  : JobInt := CurrPrice;           { Quote Currency }
            3  : JobInt := JobStat;             { Status }
          End; { Case }
        End; { With }
      End { If }
      Else
        Result := ErrJobCode;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End;  { GetJobMiscInt }


{***********************************************************************}
{* GetJobMiscVal: Returns a specified double from the specific Job     *}
{***********************************************************************}
Function TEnterpriseServer.GetJobMiscVal(Var Company  : String;
                                         Var JobCode  : String;
                                         Var JobDub   : Double;
                                         Var JobDubNo : SmallInt) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin { GetJobMiscVal }
  Result := 0;
  JobDub := 0.0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (514{206}) Then Begin
      { Get Job Record }
      If GetJobRec (CompObj.CompanyBtr, JobCode) Then Begin
        With CompObj.CompanyBtr.LJobRec^ Do Begin
          Case JobDubNo Of
            1  : JobDub := QuotePrice;
          End; { Case }
        End; { With }
      End { If }
      Else
        Result := ErrJobCode;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End;  { GetJobMiscVal }


{**********************************************************************}
{* GetCurrencyRate: Returns the the Company ("C") or Daily ("D") Rate *}
{*                  for a specified currency depending on RateType    *}
{**********************************************************************}
Function TEnterpriseServer.GetCurrencyRate(Var Company  : String;
                                           Var RateType : String;
                                           Var Currency : SmallInt;
                                           Var CurrRate : Double) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin { GetCurrencyRate }
  Result := 0;
  CurrRate := 0.0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.IsMultiCcy Then Begin
      { Check Rate Type is "C" or "D" }
      RateType := UpperCase(Trim(RateType));
      If (Length(RateType) = 1) And (RateType[1] In ['C', 'D']) Then Begin
        { Check currency is valid }
        If (Currency In [0..CurrencyType]) Then Begin
          With CompObj.CompanyBtr^ Do Begin
            { Get Rate }
            Case RateType[1] Of
              'C' : CurrRate := LSyssCurr.Currencies[Currency].CRates[False];
              'D' : CurrRate := LSyssCurr.Currencies[Currency].CRates[True];
            End; { Case }

            { Return 1.0 if 0.0 }
            If (CurrRate = 0.0) Then CurrRate := 1.0;

            { Check 1/x flag }
            If LSyssGCur.GhostRates.TriInvert[Currency] Then
              CurrRate := Round_Up(1/CurrRate,6);
          End; { If }
        End { If }
        Else
          Result := ErrCcy;
      End { If }
      Else
        Result := ErrRateType;
    End { If CompObj.IsMultiCcy }
    Else Begin
      { Single Currency }
      Result := ErrCcy;
    End; { Else }
  End { If }
  Else
    Result := ErrComp;
End;


{**********************************************************************}
{* GetGLTxMove: Calculates the movement over a specified period for a
{*              specified GL Code with optional filtering on Ac, CC,
{*              Dept, Currency.
{**********************************************************************}
Function TEnterpriseServer.GetGLTxMove(Var Company    : String;
                                       Var NomCode    : LongInt;
                                       Var StartDate  : Variant;
                                       Var EndDate    : Variant;
                                       Var Currency   : SmallInt;
                                       Var CostCentre : String;
                                       Var Department : String;
                                       Var AccCode    : String;
                                       Var TxMoveAmt  : Double) : SmallInt;
Var
  frmOLEProgress : TfrmOLEProgress;
  CompObj        : TCompanyInfo;
  SDate, EDate   : LongDate;
  KeyS           : Str255;
  WantTrans      : Boolean;
  LineAmt        : Double;
  UOR            : Byte;
Begin { CalcTXMovement }
  Try
    Result := 0;
    TxMoveAmt := 0.0;

    { Load Company Data }
    If BtrList.OpenCompany (Company, CompObj) Then Begin
      If CompObj.CheckSecurity (487{20}) Then Begin
        If GetNominalRec (CompObj.CompanyBtr, NomCode) Then Begin
          With CompObj, CompanyBtr^ Do Begin
            { Check Nominal Type is valid }
            If (Result = 0) Then Begin
              If (LNom.NomType In ['F', 'H']) Then
                Result := ErrNom;
            End; { If }

            { Check Currency }
            If (Result = 0) Then Begin
              If (Currency <0) Or (Currency > CurrencyType) Then
                Result := ErrCcy;
            End; { If }

            { Check Cost Centre if req }
            If (Result = 0) And (CostCentre <> '') Then Begin
              If GetCCDepRec (CompanyBtr, CostCentre, True) Then
                CostCentre := LPassword.CostCtrRec.PCostC
              Else
                Result := ErrCC;
            End; { If }

            { Check Department if req }
            If (Result = 0) And (Department <> '') Then Begin
              If GetCCDepRec (CompanyBtr, Department, False) Then
                Department := LPassword.CostCtrRec.PCostC
              Else
                Result := ErrDept;
            End; { If }

            { Check Account if req }
            If (Result = 0) And (AccCode <> '') Then Begin
              If GetCustRec (CompanyBtr, AccCode, True) Then
                AccCode := LCust.CustCode
              Else
                Result := ErrAccCode;
            End; { If }

            If (Result = 0) Then Begin
              { Everything is AOK or blank - Check Dates }
              SDate := FormatDateTime('YYYYMMDD', StartDate);
              EDate := FormatDateTime('YYYYMMDD', EndDate);

              If (EDate >= SDate) Then Begin
                { Display progress dialog }
                frmOLEProgress := TfrmOLEProgress.Create(Application.MainForm);
                Try
                  { Pass through the invoice for the date range }
                  KeyS := SDate;
                  LStatus:=LFind_Rec(B_GetGEq,InvF,InvDateK,KeyS);

                  With frmOLEProgress Do Begin
                    Caption := 'CalcTXMovement';
                    lstInfo.Items.Add('Calculating GL Transaction Movement...');
                    lstInfo.Items.Add('   GL Code' + #9 + IntToStr(NomCode));
                    lstInfo.Items.Add('   Start Date' + #9 + FormatDateTime('DD/MM/YY', StartDate));
                    lstInfo.Items.Add('   End Date' + #9 + FormatDateTime('DD/MM/YY', EndDate));
                    lstInfo.Items.Add('   Currency' + #9 + IntToStr(Currency));
                    lblProg.Caption := '';
                  End; { With }
                  frmOLEProgress.Show;

                  While LStatusOk And (Not frmOLEProgress.Aborted) And
                        ((LInv.TransDate >= SDate) And (LInv.TransDate <= EDate)) Do Begin
                    { Check its posted (RunNo > 0) and its a normal transaction }
                    If (LInv.RunNo > 0) And (LInv.FolioNum > 0) Then Begin
                      { Update progress }
                      frmOLEProgress.lblProg.Caption := LInv.OurRef +
                                                        ' - ' +
                                                        POutDate(LInv.TransDate);

                      { Check its a document type we want }
                      WantTrans := Not (LInv.InvDocHed In PSOPSet +
                                                          QuotesSet +
                                                          StkAdjSplit +
                                                          TSTSplit);

                      { Check Account if req }
                      If WantTrans And (Trim(AccCode) <> '') Then Begin
                        WantTrans := (AccCode = LInv.CustCode);
                      End; { If }

                      { Check Currency }
                      If WantTrans Then Begin
                        { 0=Consolidated (All Currencies) or >0 Specific Currency }
                        WantTrans := (Currency = 0) Or (Currency = LInv.Currency);
                      End; { If }

                      If WantTrans Then Begin
                        { Transaction Valid - Process and Check the lines }
                        KeyS := FullNomKey(LInv.FolioNum) + FullNomKey(1);

                        LStatus:=LFind_Rec(B_GetGEq,IDetailF,IdLinkK,KeyS);

                        While LStatusOk And (LId.FolioRef = LInv.FolioNum) Do Begin
                          WantTrans := True;

                          { Check GL Code }
                          If WantTrans Then Begin
                            WantTrans := (NomCode = LId.NomCode);
                          End; { If }

                          { Check Cost Centre if req }
                          If WantTrans And (Trim(CostCentre) <> '') Then Begin
                            WantTrans := (CostCentre = LId.CCDep[True]);
                          End; { If }

                          { Check Department if req }
                          If WantTrans And (Trim(Department) <> '') Then Begin
                            WantTrans := (Department = LId.CCDep[False]);
                          End; { If }

                          If WantTrans Then Begin
                            { Do the Biz - Calc line total in transaction currency }
                            LineAmt := DetLTotal (LId, False, False, 0.0) * DocNotCnst;

                            If (Currency = 0) And (Currency <> LInv.Currency) Then Begin
                              { Convert to Consolidated if not already consolidated }
                              UOR:=fxUseORate(False,BOn,LId.CXRate,LId.UseORate,LId.Currency,0);
                              LineAmt := Round_Up (Conv_TCurr(LineAmt, XRate(LId.CXRate, False, LId.Currency),LId.Currency,UOR,False), 2);
                            End; { If }

                            TxMoveAmt := TxMoveAmt + LineAmt;
                          End; { If }

                          LStatus:=LFind_Rec(B_GetNext,IDetailF,IdLinkK,KeyS);
                        End; { While }
                      End; { If }
                    End; { If }

                    LStatus:=LFind_Rec(B_GetNext,InvF,InvDateK,KeyS);

                    Application.ProcessMessages;
                  End; { While }

                  If frmOLEProgress.Aborted Then
                    { Aborted by User }
                    Result := ErrUserAbort;
                Finally
                  frmOLEProgress.Free;
                End;
              End { If }
              Else
                { Invalid End Date }
                Result := ErrEndDate;
            End; { If }
          End; { With }
        End { If }
        Else
          { Invalid nominal code }
          Result := ErrNom;
      End { If }
      Else
        Result := ErrPermit;
    End { If }
    Else
      Result := ErrComp;
  Except
    On EX:Exception Do
      Result := ErrUnknown;
  End;
End;  { CalcTXMovement }


{**********************************************************************}
{* GetCustSalesPrice: Returns a Sales Price for the customer including
{*                    any discounts due.
{*
{* AgePeriod:         D=Days, W=Weeks, M=Months
{* AgeInterval:       1-255
{* WantCat:           0=Current, 1=1M, 2=2M, 3=3M, 4=4M+
{**********************************************************************}
Function TEnterpriseServer.GetCustAging(Var Company     : String;
                                        Var CustCode    : String;
                                        Var AcType      : String;
                                        Var AgePeriod   : String;
                                        Var AgedDate    : Variant;
                                        Var AgeInterval : SmallInt;
                                        Var WantCat     : SmallInt;
                                        Var AgeValue    : Double) : SmallInt;
Var
  CompObj                : TCompanyInfo;
  CacheObj               : TCachedAccountAgeingInfo;
  AgePrd, AgeInt, CatGry : Byte;
  AgeDate                : LongDate;
  AcErr                  : SmallInt;
  sQuery                 : AnsiString;
  SQLAgeingCols          : Array [0..4] Of Double;
  UseSQLStoredProc       : Boolean;
Begin
  Try
    Result := 0;
    AgeValue := 0.0;

    If (AcType = 'C') Then
      AcErr := ErrCust
    Else
      AcErr := ErrSupp;

    { Load Company Data }
    If BtrList.OpenCompany (Company, CompObj) Then
    Begin
      If CompObj.CheckSecurity (GetSecIIF (AcType = 'C', 476{38}, 481{48})) Then
      Begin
        // Check for previously calculated values in the Ageing Cache
        CacheObj := CompObj.AgeIngCache.GetAgeing (AcType, CustCode, AgePeriod, FormatDateTime('YYYYMMDD', AgedDate), AgeInterval);
        If Assigned(CacheObj) Then
        Begin
          AgeValue := CacheObj.AgePeriod[WantCat+1];
        End // If Assigned(CacheObj)
        Else
        Begin
          // MH 02/05/2012 v6.10 ABSEXCH-12891: Disabled SQL check as someone removed the stored procedure in v6.9!
          // Check whether to use the stored procedure for the SQL Edition
          //UseSQLStoredProc := SQLUtils.UsingSQL And SQLReportsConfiguration.UseAgeingStoredProc;
          UseSQLStoredProc := False;

          If (Not UseSQLStoredProc) Then
          Begin
            // Pervasive Edition - Check Customer Code upfront - done in stored proc for SQL
            If GetCustRec (CompObj.CompanyBtr, CustCode, True) Then
            Begin
              If (CompObj.CompanyBtr.LCust.CustSupp <> AcType) Then
                Result := AcErr;
            End // If (CompObj.CompanyBtr.LCust.CustSupp = AcType)
            Else
              Result := AcErr;
          End; // If (Not UseSQLStoredProc)

          If (Result = 0) Then
          Begin
            // Perform common validation
            AgePrd := 0;
            AgeInt := 0;
            CatGry := 0;

            { Check AgePeriod is 'D', 'W' or 'M' }
            If (Length(AgePeriod) = 1) Then
            Begin
              Case UpperCase(AgePeriod)[1] Of
                'D' : AgePrd := 1;
                'M' : AgePrd := 3;
                'W' : AgePrd := 2;
              Else
                { Invalid Aging Type }
                Result := ErrAgeUnits;
              End; { Case }
            End { If }
            Else
              { Invalid Aging Type }
              Result := ErrAgeUnits;

            If (Result = 0) Then
            Begin
              { Check AgePeriod }
              If (WantCat < 0) Or (WantCat > 4) Then
                Result := ErrPeriod
              Else
                Catgry := WantCat;
            End; { If }

            If (Result = 0) Then
            Begin
              { Check Ageing Interval }
              If (AgeInterval < 1) Or (AgeInterval > 255) Then
                Result := ErrAgeInt
              Else
                AgeInt := AgeInterval;
            End; { If }
          End; // If (Result = 0)

          If (Result = 0) Then
          Begin
            { Do the Biz! }
            AgeDate := FormatDateTime('YYYYMMDD', AgedDate);

            {$IFDEF EXSQL}
              AgeValue := 0;

              If UseSQLStoredProc Then
              Begin
                sQuery := '[COMPANY].isp_OLE_AccountAgedBalance ' +
                              '@strAccountCode=' + QuotedStr(Trim(CustCode)) + ', ' +
                              '@strAccountType=' + QuotedStr(Trim(AcType)) + ', ' +
                              '@datEffectiveDate=' + QuotedStr(FormatDateTime('d mmmm yyyy', AgedDate)) + ', ' +
                              '@strAgeBy=' + QuotedStr(AgePeriod) + ', ' +
                              '@intAgeingInterval=' + IntToStr(AgeInt);

                CompObj.Logger.StartQuery(sQuery);
                CompObj.sqlCaller.Select(sQuery, CompObj.CompanyCode);
                CompObj.Logger.FinishQuery;
                Try
                  If (CompObj.sqlCaller.ErrorMsg = '') Then
                  Begin
                    If (CompObj.sqlCaller.Records.RecordCount > 0) Then
                    Begin
                      CompObj.Logger.QueryRowCount(CompObj.sqlCaller.Records.RecordCount);

                      // Initialise the totals
                      FillChar(SQLAgeingCols, SizeOf(SQLAgeingCols), #0);

                      // Run through results for Line Currency and then for Consolidated if nothing found
                      With CompObj.sqlCaller Do
                      Begin
                        Records.First;
                        SQLAgeingCols[0] := Records.FieldByName('P0').AsFloat;
                        SQLAgeingCols[1] := Records.FieldByName('P1').AsFloat;
                        SQLAgeingCols[2] := Records.FieldByName('P2').AsFloat;
                        SQLAgeingCols[3] := Records.FieldByName('P3').AsFloat;
                        SQLAgeingCols[4] := Records.FieldByName('P4').AsFloat;
                      End; // With CompObj.sqlCaller

                      AgeValue := SQLAgeingCols[WantCat];

                      // Add to cache so we don't have to keep scanning the transactions
                      CompObj.AgeIngCache.AddToCache (AcType,
                                                      CustCode,
                                                      AgePeriod,
                                                      AgeDate,
                                                      AgeInt,
                                                      SQLAgeingCols[0],
                                                      SQLAgeingCols[1],
                                                      SQLAgeingCols[2],
                                                      SQLAgeingCols[3],
                                                      SQLAgeingCols[4]);
                    End // If (sqlCaller.Records.RecordCount > 0)
                    Else
                      // No data returned = invalid account
                      Result := AcErr;
                  End // If (CompObj.sqlCaller.ErrorMsg = '')
                  Else
                  Begin
                    MessageDlg ('The following error occurred whilst retrieving the data - ' + QuotedStr(CompObj.sqlCaller.ErrorMsg),
                                mtError, [mbOK], 0);
                    CompObj.Logger.LogError('Query Error', CompObj.sqlCaller.ErrorMsg);
                  End; // Else
                Finally
                  CompObj.sqlCaller.Close;
                End; // Try..Finally
              End // If UseSQLStoredProc
              Else
            {$ENDIF}
                AgeValue := CalcCustAgeing (CompObj.CompanyBtr,
                                            CompObj.AgeIngCache,
                                            AgeDate,
                                            AgePrd,
                                            AgeInt,
                                            Catgry);
          End; // If (Result = 0)
        End; // Else
      End // If CompObj.CheckSecurity (
      Else
        Result := ErrPermit;
    End // If BtrList.OpenCompany (Company, CompObj)
    Else
      Result := ErrComp;
  Except
    On EX:Exception Do
      Result := ErrUnknown;
  End;
End;


{**********************************************************************}
{* GetCustSalesPrice: Returns a Sales Price for the customer including
{*                    any discounts due.
{**********************************************************************}
Function TEnterpriseServer.GetCustSalesPrice(Var Company  : String;
                                             Var CustCode : String;
                                             Var AcType   : String;
                                             Var StockId  : String;
                                             Var Location : String;
                                             Var Currency : SmallInt;
                                             Var Quantity : Double;
                                             Var Price    : Double) : SmallInt;
Var
  CompObj        : TCompanyInfo;
  DiscCh         : Char;
  FoundOk        : Boolean;
  lPrice, DiscR, TmpPr  : Real;
  AcErr          : SmallInt;
Begin
  Try
    Result := 0;
    Price := 0.0;

    If (AcType = 'C') Then
      AcErr := ErrCust
    Else
      AcErr := ErrSupp;

    { Load Company Data }
    If BtrList.OpenCompany (Company, CompObj) Then Begin
      If CompObj.CheckSecurity (GetSecIIF (AcType = 'C', 475{30}, 480{40})) Then Begin
        { Check Customer Code }
        If GetCustRec (CompObj.CompanyBtr, CustCode, True) Then Begin
          If (CompObj.CompanyBtr.LCust.CustSupp = AcType) Then Begin
            { Check Stock Code }
            If GetStockRec (CompObj.CompanyBtr, StockId) Then Begin
              { Check Quantity }
              If (Quantity > 0.0) Then Begin
                { Check Currency }
                If (Currency < 0) Or (Currency > CurrencyType) Then
                  { Invalid Currency }
                  Result := ErrCcy;

                { Check Location }
                If (Result = 0) And (Trim(Location) <> '') Then Begin
                  If GetLocRec (CompObj.CompanyBtr, Location) Then Begin
                    { Got Location }
                    Location := CompObj.CompanyBtr^.LMLoc^.MLocLoc.loCode;
                  End { If }
                  Else
                    { Invalid Location }
                    Result := ErrLoc;
                End; { If ]

                { Get Sales Price }
                If (Result = 0) Then
                  With CompObj, CompanyBtr^ Do Begin
                    DiscCh := ' ';
                    DiscR := 0.0;
                    FoundOk := True;

                    If (LCust.CustSupp = 'C') Then Begin
                      { Customer - default to band 'A' price }
                      With LStock Do
                        lPrice := Currency_ConvFT(SaleBands[1].SalesPrice, SaleBands[1].Currency, Currency, UseCoDayRate);
                    End { If }
                    Else Begin
                      { Supplier - default to cost price }
                      With LStock Do
                        lPrice := Currency_ConvFT(CostPrice, PCurrency, Currency, UseCoDayRate);
                    End; { Else }
                    TmpPr := lPrice;

                    Calc_StockPrice(CompObj.CompanyBtr,
                                    LStock,
                                    LCust,
                                    Currency,
                                    Quantity,
                                    Today,
                                    lPrice,
                                    DiscR,
                                    DiscCh,
                                    Location,
                                    FoundOk);

// MH 19/04/06: Removed this sections as it was overwriting the returned price if no discounts were defined but
// the Customer had a Qty Break.
//                    If (Not FoundOK) Then Begin
//                      { Error in pricing - set to default }
//                      Price := TmpPr;
//                    End { If }
//                    Else Begin
                      { Got price }
                      If (LCust.CustSupp = 'C') Then
                        Price := lPrice - Calc_PAmount(Round_Up(lPrice, LSyss.NoNetDec), DiscR, DiscCh)
                      Else
                        Price := lPrice - Calc_PAmount(Round_Up(lPrice, LSyss.NoCosDec), DiscR, DiscCh);
//                    End; { Else }
                  End; { With }
              End { If }
              Else
                Result := ErrQuantity;
            End { If }
            Else
              Result := ErrStock;
          End { If }
          Else
            Result := AcErr;
        End { If }
        Else
          Result := AcErr;
      End { If }
      Else
        Result := ErrPermit;
    End { If }
    Else
      Result := ErrComp;
  Except
    On EX:Exception Do
      Result := ErrUnknown;
  End;
End;


{**********************************************************************}
{* ConvertAmount: Converts the amount from the From Ccy top the To Ccy
{*                using the current currency rates.
{**********************************************************************}
Function TEnterpriseServer.ConvertAmount(Var Company  : String;
                                         Var FromCcy  : SmallInt;
                                         Var ToCcy    : SmallInt;
                                         Var Amount   : Double;
                                         Var RateType : SmallInt) : SmallInt;
Var
  CompObj   : TCompanyInfo;
  CoDayRate : Boolean;
Begin { ConvertAmount }
  Try
    Result := 0;

    { Load Company Data }
    If BtrList.OpenCompany (Company, CompObj) Then Begin
      If CompObj.IsMultiCcy Then Begin
        { Check they're different - no point converting if they are the same or amount is zero }
        If (FromCcy <> ToCcy) And (Amount <> 0.0) Then Begin
          { Check From Currency }
          If (FromCcy >= 0) And (FromCcy <= CurrencyType) Then Begin
            { Check To Currency }
            If (ToCcy >= 0) And (ToCcy <= CurrencyType) Then Begin
              { Check Rate Type }
              If (RateType >= 0) And (RateType <= 2) Then Begin
                { ?? }
                Case RateType Of
                  0 : Begin { Use sys setup flag to determine }
                        CoDayRate := (CompObj.CompanyBtr^.LSyss.TotalConv = XDayCode);
                      End;
                  1 : Begin { daily rates }
                        CoDayRate := True;
                      End;
                  2 : Begin { Company rates }
                        CoDayRate := False;
                      End;
                End; { Case }

                Amount := Round_Up (Currency_ConvFT(Amount, FromCcy, ToCcy, CoDayRate), 2);
              End { If }
              Else Begin
                { Invalid Rate Type }
                Result := ErrRateType;
              End; { Else }
            End { If }
            Else Begin
              { Invalid To Currency }
              Result := ErrCcy;
            End; { Else }
          End { If }
          Else Begin
            { Invalid From Currency }
            Result := ErrCcy;
          End; { Else }
        End; { If }
      End { If CompObj.IsMultiCcy }
      Else Begin
        { Single Currency }
        Result := ErrCcy;
      End; { Else }
    End { If }
    Else
      Result := ErrComp;
  Except
    On EX:Exception Do
      Result := ErrUnknown;
  End;
End;  { ConvertAmount }


{***********************************************************************}
{* GetAcMiscStr: Returns a string value from the specified customer/   *}
{*               supplier record. The value returned is specified      *}
{*               using the MiscStrNo parameter, values are:            *}
{*                                                                     *}
{*                   1  : Company Name                                 *}
{*                   2  : Address Line 1                               *}
{*                   3  : Address Line 2                               *}
{*                   4  : Address Line 3                               *}
{*                   5  : Address Line 4                               *}
{*                   6  : Address Line 5                               *}
{*                   7  : Contact                                      *}
{*                   8  : Phone                                        *}
{*                   9  : Fax                                          *}
{*                   10 : Phone2                                       *}
{*                   11 : UserDef1                                     *}
{*                   12 : UserDef2                                     *}
{*                   13 : CustCC                                       *}
{*                   14 : CustDep                                      *}
{*                   15 : AreaCode                                     *}
{*                   16 : RepCode                                      *}
{*                   17 : Delivery Address Line 1                      *}
{*                   18 : Delivery Address Line 2                      *}
{*                   19 : Delivery Address Line 3                      *}
{*                   20 : Delivery Address Line 4                      *}
{*                   21 : Delivery Address Line 5                      *}
{*                   22 : Statement To                                 *}
{*                   23 : VAT Code                                     *}
{*                   24 : VAT Inclusion for EEC  Y/N                   *}
{*                   25 : Invoice To                                   *}
{*                   26 : User Defined 3                               *}
{*                   27 : User Defined 4                               *}
{*                   28 : Alternate Code                               *}
{*                   29 : Default Location                             *}
{*                   30 : Post Code                                    *}
{*                   31 : Email address for Statment/ Remittance       *}
{*                   32 : Send reader & reset                          *}
{*                   33 : Zip Attachments                              *}
{*                   34 : When sending XML, send HTML                  *}
{*                   35 : Web Catalogues                               *}
{*                   36 : NOT USED                                     *}
{*                   37 : Delivery Terms                               *}
{*                   38 : Line Discount                                *}
{*                                                                     *)
{*                   // HM 25/06/02: v5.00.002                         *)
{*                   39 : VAT Reg No                                   *}
{*                   40 : Trading Terms 1                              *}
{*                   41 : Trading Terms 2                              *}
{*                   //GS 27/10/2011 ABSEXCH-11706:                    *}
{*                   //added support for UDEFs 6-10                    *}
{*                   51 : User Defined 5                               *}
{*                   52 : User Defined 6                               *}
{*                   53 : User Defined 7                               *}
{*                   54 : User Defined 8                               *}
{*                   55 : User Defined 9                               *}
{*                   56 : User Defined 10                              *}
                     // MH 10/09/2013 v7.0.6 ABSEXCH-14598: Added Mandate Fields
{*                   57 : Bank Mandate ID                              *}
{*                   58 : Mandate Date                                 *}
                     // MH 18/10/2013 v7.0.7 ABSEXCH-14703: Added Delivery Postcode
{*                   59 : Delivery Postcode                            *}
                     // MH 22/10/2014 Order Payments: Added Order Payments support
{*                   60 : Allow Order Payments Yes/No                  *}
                     // MH 02/12/2014 ABSEXCH-15836: Added Read-Write support for new account Country fields
{*                   61 : Country                                      *}
{*                   62 : Delivery Country                             *}
                     // MH 20/05/2015 v7.0.14 ABSEXCH-16284: Added PPD OLE Functions
{*                   63 : PPD Mode                                     *}
                     // PKR. 25/01/2016. ABSEXCH-17111. Add Intrastat Default to QR flag.
{*                   64 Default To QR                                  *}
{***********************************************************************}
Function TEnterpriseServer.GetAcMiscStr (Var Company   : String;
                                         Var CustCode  : String;
                                         Var AcType    : String;
                                         Var MiscStrNo : SmallInt;
                                         Var MiscStr   : String) : SmallInt;
Var
  CompObj : TCompanyInfo;
  AcErr   : SmallInt;
Begin
  Result := 0;
  MiscStr := '';

  If (AcType = 'C') Then
    AcErr := ErrCust
  Else
    AcErr := ErrSupp;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (GetSecIIF (AcType = 'C', 475{30}, 480{40})) Then Begin
      { Check Customer Code }
      If GetCustRec (CompObj.CompanyBtr, CustCode, True) Then Begin
        If (CompObj.CompanyBtr.LCust.CustSupp = AcType) Then Begin
          With CompObj, CompanyBtr^, LCust Do
            Case MiscStrNo Of
              1      : MiscStr := Company;
              2..6   : MiscStr := Addr[Pred(MiscStrNo)];
              7      : MiscStr := Contact;
              8      : MiscStr := Phone;
              9      : MiscStr := Fax;
              10     : MiscStr := Phone2;
              11     : MiscStr := UserDef1;
              12     : MiscStr := UserDef2;
              13     : MiscStr := CustCC;
              14     : MiscStr := CustDep;
              15     : MiscStr := AreaCode;
              16     : MiscStr := RepCode;
              17..21 : MiscStr := DAddr[MiscStrNo - 16];

              { HM 27/10/99-: v4.31 mods }
              22     : MiscStr := RemitCode;             { Statement To }

              // MH 24/11/05: Modified VAT Code behaviour so that Inclusive VAT Codes are returned as 'IS'
              //23     : MiscStr := VATCode;               { VAT Code }
              23     : MiscStr := GetVATCodeDesc (VATCode, CVATIncFlg);

              24     : MiscStr := YesNoBo (EECMember);   { VAT Inclusion for EEC }
              25     : MiscStr := SOPInvCode;            { Invoice To }
              26     : MiscStr := UserDef3;
              27     : MiscStr := UserDef4;
              28     : MiscStr := CustCode2;             { Alternate Code }
              29     : MiscStr := DefMLocStk;            { Default Multi Loc Stock }
              30     : MiscStr := PostCode;

              31     : MiscStr := EmailAddr;             { Email address for Statment/ Remittance }
              32     : MiscStr := YesNoBo(EmlSndRdr);    { On next email transmnision, send reader & reset }
              // 09/02/01: Extended to support EDZ forms
              //33     : MiscStr := YesNoBo(EmlZipAtc);    { Default Zip attachement }
              33     : Case EmlZipAtc Of
                         0 : MiscStr := 'NO';
                         1 : MiscStr := 'ZIP';
                         2 : MiscStr := 'EDZ';
                       Else
                         MiscStr := '???';
                       End; { Case }
              34     : MiscStr := YesNoBo(EmlSndHTML);   { When sending XML, send HTML }
              35     : MiscStr := WebLiveCat;            { Web Catalogues }
              //36     : MiscStr := VATRetRegC;            { Country of VAT registration }
              37     : MiscStr := SSDDelTerms;           {     "     Delivery Terms }

              // HM 07/11/00: Added Line Discount
              38     : MiscStr := PPR_PamountStr(Discount,CDiscCh);

              // HM 25/06/02: v5.00.002
              39     : MiscStr := VATRegNo;
              40     : MiscStr := STerms[1];
              41     : MiscStr := STerms[2];

              // HM 15/10/02: Added Bank Dets for v5.01
              // HM 06/01/03: Added support for Cheque 2/3
              42     : Case PayType Of
                         'B' : MiscStr := 'BACS';
                         'C' : MiscStr := 'CHEQUE';
                         '2' : MiscStr := 'CHEQUE 2';
                         '3' : MiscStr := 'CHEQUE 3';
                       Else
                         Result := ErrValue;
                       End; { Else }
              // MH 10/09/2013 v7.0.6 ABSEXCH-14598: Modified to pickup new longer Bank Account No / Sort Code
              //43     : MiscStr := BankAcc;            // Bank A/C
              //44     : MiscStr := BankSort;           // Sort Code
              43     : MiscStr := DecryptBankAccountCode(acBankAccountCode);            // Bank A/C
              44     : MiscStr := DecryptBankSortCode(acBankSortCode);           // Sort Code
              45     : MiscStr := BankRef;            // Bank Ref.
              46     : If (CustSupp = 'C') Then
                         Case DirDeb Of
                           0 : MiscStr := 'First Request';
                           1 : MiscStr := 'Ongoing Request';
                           2 : MiscStr := 'Re-present Last Request';
                           3 : MiscStr := 'Last Request';
                         Else
                           Result := ErrValue;
                         End
                       Else
                         // Only available for Customers
                         Result := ErrAccCode;

              // HM 23/05/03: Added Paperless send methods
              // Statement / Remittance
              47     : Case StatDMode Of
                         0 : MiscStr := '0-Print Hard Copy';
                         1 : MiscStr := '1-Via Fax';
                         2 : MiscStr := '2-Via Email';
                         3 : MiscStr := '3-Fax & Hard Copy';
                         4 : MiscStr := '4-Email & Hard Copy';
                       Else
                         MiscStr := 'Unknown Method';
                       End; { Case StatDMode }
              // Invoice
              48     : Case InvDMode Of
                         0 : MiscStr := '0-Print Hard Copy';
                         1 : MiscStr := '1-Via Fax';
                         2 : MiscStr := '2-Via Email';
                         3 : MiscStr := '3-Fax & Hard Copy';
                         4 : MiscStr := '4-Email & Hard Copy';
                         5 : MiscStr := '5-XML eBis';
                       Else
                         MiscStr := 'Unknown Method';
                       End; { Case InvDMode }

              // HM 18/08/03: Added Account Status for v5.52
              49     : Case AccStatus Of
                         0 : MiscStr := 'O-Open';
                         1 : MiscStr := 'N-See Notes';
                         2 : MiscStr := 'H-On Hold';
                         3 : MiscStr := 'C-Closed';
                       Else
                         MiscStr := 'Unknown Status';
                       End; { Case AccStatus }

              // MH 06/11/06: Added Their Code for Us for Volac
              50     : MiscStr := Trim(LCust.RefNo);
              //GS 27/10/2011 ABSEXCH-11706:
              //added support for UDEFs 6-10
              51     : MiscStr := UserDef5;
              52     : MiscStr := UserDef6;
              53     : MiscStr := UserDef7;
              54     : MiscStr := UserDef8;
              55     : MiscStr := UserDef9;
              56     : MiscStr := UserDef10;
              // MH 10/09/2013 v7.0.6 ABSEXCH-14598: Added Mandate Fields
              57     : MiscStr := DecryptBankMandateID(acMandateID);
              58     : MiscStr := PoutDateB(acMandateDate);
              // MH 18/10/2013 v7.0.7 ABSEXCH-14703: Added Delivery Postcode
              59     : MiscStr := acDeliveryPostcode;

              // MH 22/10/2014 Order Payments: Added Order Payments support
              60     : MiscStr := IfThen(acAllowOrderPayments, 'Yes', 'No');

              // MH 02/12/2014 ABSEXCH-15836: Added Read-Write support for new account Country fields
              61     : MiscStr := acCountry;
              62     : MiscStr := acDeliveryCountry;
              // MH 20/05/2015 v7.0.14 ABSEXCH-16284: Added PPD OLE Functions
              63     : Case acPPDMode Of
                         pmPPDDisabled                         : MiscStr := '0 - Disabled';
                         pmPPDEnabledWithAutoJournalCreditNote : MiscStr := '1 - Enabled - Auto ' + IfThen (CustSupp = 'C', 'SJC', 'PJC');
                         pmPPDEnabledWithAutoCreditNote        : MiscStr := '2 - Enabled - Auto ' + IfThen (CustSupp = 'C', 'SCR', 'PCR');
                         pmPPDEnabledWithManualCreditNote      : MiscStr := '3 - Enabled - Manual ' + IfThen (CustSupp = 'C', 'SCR', 'PCR');
                       End; // Case acPPDMode
              // PKR. 25/01/2016. ABSEXCH-17111. Add Intrastat Default to QR flag.
              64     : MiscStr := YesNoBo(acDefaultToQR);
              // SS 24/08/2016 ABSEXCH-15847 Added 11 to 15 UDF functions
              65     : MiscStr := CCDCardNo;
              66     : MiscStr := POutDate(CCDSDate);
              67     : MiscStr := POutDate(CCDEDate);
              68     : MiscStr := CCDName;
              69     : MiscStr := CCDSARef;
            End { Case }
        End { If }
        Else
          Result := AcErr;
      End { If }
      Else
        Result := AcErr;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End;


{***********************************************************************}
{* GetAcMiscInt: Returns a long integer value from the specified       *}
{*                 Customer/Supplier record. The value is specified    *)
{*                 using the MiscIntNo parameter, values are:          *}
{*                   1  : Sales G/L Code                               *}
{*                   2 : Currency                                      *}
{*                   3 : Sales GL Code                                 *}
{*                   4 : Cost Of Sales GL Code                         *}
{*                   5 : Control GL Code                               *}
{*                                                                     *}
{*                   HM 15/10/02: Added Bank Dets for v5.01            *}
{*                   9  : Direct Debit Mode   (1-4)  (Customers only)  *}
{***********************************************************************}
Function TEnterpriseServer.GetAcMiscInt (Var Company     : String;
                                         Var CustCode    : String;
                                         Var AcType      : String;
                                         Var MiscIntNo   : SmallInt;
                                         Var MiscInt     : LongInt) : SmallInt;
Var
  CompObj : TCompanyInfo;
  AcErr   : SmallInt;
Begin
  Result := 0;

  If (AcType = 'C') Then
    AcErr := ErrCust
  Else
    AcErr := ErrSupp;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (GetSecIIF (AcType = 'C', 475{30}, 480{40})) Then Begin
      { Check Customer Code }
      If GetCustRec (CompObj.CompanyBtr, CustCode, True) Then Begin
        If (CompObj.CompanyBtr.LCust.CustSupp = AcType) Then Begin
          With CompObj, CompanyBtr^, LCust Do
            Case MiscIntNo Of
              1  : MiscInt := Currency;
              2  : MiscInt := DefNomCode;    { Sales }
              3  : MiscInt := DefCOSNom;     { Cost Of Sales }
              4  : MiscInt := DefCtrlNom;    { Control }

              { HM 27/10/99-: v4.31 mods }
              5  : MiscInt := PayTerms;
              6  : MiscInt := DefSetDDays;
              7  : MiscInt := FDefPageNo;

              8  : MiscInt := SSDModeTr;

              // MH 19/04/06: Added Tag No for wish list item
              9  : MiscInt := DefTagNo;      // Tag No

              // MH 22/10/2014 Order Payments: Added Order Payments support
              10 : MiscInt := acOrderPaymentsGLCode;
            End { Case }
        End { If }
        Else
          Result := AcErr;
      End { If }
      Else
        Result := AcErr;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End;


{***********************************************************************}
{* GetAcMiscVal: Returns a long integer value from the specified       *}
{*               Customer/Supplier record. The value is specified      *}
{*               using the MiscValNo parameter, values are:            *}
{*                   1  : Credit Limit                                 *}
{***********************************************************************}
Function TEnterpriseServer.GetAcMiscVal (Var Company     : String;
                                         Var CustCode    : String;
                                         Var AcType      : String;
                                         Var MiscValNo   : SmallInt;
                                         Var MiscVal     : Double) : SmallInt;
Var
  CompObj : TCompanyInfo;
  AcErr   : SmallInt;
Begin
  Result := 0;

  If (AcType = 'C') Then
    AcErr := ErrCust
  Else
    AcErr := ErrSupp;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (GetSecIIF (AcType = 'C', 475{30}, 480{40})) Then Begin
      { Check Customer Code }
      If GetCustRec (CompObj.CompanyBtr, CustCode, True) Then Begin
        If (CompObj.CompanyBtr.LCust.CustSupp = AcType) Then Begin
          With CompObj, CompanyBtr^, LCust Do
            Case MiscValNo Of
              1  : MiscVal := CreditLimit;

              { HM 27/10/99: v4.31 mods }
              2  : MiscVal := DefSetDisc;

              // HM 17/06/04: v5.61
              3  : MiscVal := BOrdVal;
            End { Case }
        End { If }
        Else
          Result := AcErr;
      End { If }
      Else
        Result := AcErr;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End;


{***********************************************************************}
{* SaveAcMiscStr: Saves a string value to the specified Customer/      *}
{*                supplier record. The value updated is specified      *}
{*                using the MiscStrNo parameter, values are:           *}
{*                                                                     *}
{*                   1  : Company Name                                 *}
{*                   2  : Address Line 1                               *}
{*                   3  : Address Line 2                               *}
{*                   4  : Address Line 3                               *}
{*                   5  : Address Line 4                               *}
{*                   6  : Address Line 5                               *}
{*                   7  : Contact                                      *}
{*                   8  : Phone                                        *}
{*                   9  : Fax                                          *}
{*                   10 : Phone2                                       *}
{*                   11 : UserDef1                                     *}
{*                   12 : UserDef2                                     *}
{*                   13 : CustCC                                       *}
{*                   14 : CustDep                                      *}
{*                   15 : AreaCode                                     *}
{*                   16 : RepCode                                      *}
{*                   17 : Delivery Address Line 1                      *}
{*                   18 : Delivery Address Line 2                      *}
{*                   19 : Delivery Address Line 3                      *}
{*                   20 : Delivery Address Line 4                      *}
{*                   21 : Delivery Address Line 5                      *}
{*                                                                     *}
{*                   38 : Line Discount                                *}
{*                                                                     *)
{*                   // HM 25/06/02: v5.00.002                         *)
{*                   39 : VAT Reg No                                   *}
{*                   40 : Trading Terms 1                              *}
{*                   41 : Trading Terms 2                              *}
{*                   //GS 27/10/2011 ABSEXCH-11706:                    *}
{*                   //added support for UDEFs 6-10                    *}
{*                   51 : User Defined 5                               *}
{*                   52 : User Defined 6                               *}
{*                   53 : User Defined 7                               *}
{*                   54 : User Defined 8                               *}
{*                   55 : User Defined 9                               *}
{*                   56 : User Defined 10                              *}
// MH 10/09/2013 v7.0.6 ABSEXCH-14598: Added Mandate Fields
{*                   57 : Bank Mandate ID                              *}
{*                   58 : Mandate Date                                 *}
// MH 18/10/2013 v7.0.7 ABSEXCH-14703: Added Delivery Postcode
{*                   59 : Delivery Postcode                            *}
{***********************************************************************}
Function TEnterpriseServer.SaveAcMiscStr (Var Company   : String;
                                          Var CustCode  : String;
                                          Var AcType    : String;
                                          Var MiscStrNo : SmallInt;
                                          Var NewStr    : String) : SmallInt;
Const
  FNum  = CustF;
  KPath = CustCodeK;
Var
  TmpCust          : ^CustRec;
  KeyR, KeyS, KeyT : Str255;
  CompObj          : TCompanyInfo;
  AcErr            : SmallInt;
  iTraderAudit     : IBaseAudit;
  Idx              : Integer;
Begin
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then Begin
    If (AcType = 'C') Then
      AcErr := ErrCust
    Else
      AcErr := ErrSupp;

    If CompObj.CheckSecurity (GetSecIIF (AcType = 'C', 478{32}, 483{42})) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        KeyS := FullCustCode(CustCode);
        KeyR := KeyS;

        LStatus:=LFind_Rec(B_GetGEq,FNum,KPath,KeyS);

        If LStatusOk And CheckKey(KeyR,KeyS,Length(KeyR),BOn) Then Begin
          { Check account type }
          If (CompObj.CompanyBtr.LCust.CustSupp = AcType) Then Begin
            { found - get rec and update }
            GLobLocked:=BOff;
            Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked);
            {GetMultiRecAddr (B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked, RecAddr);}
            LGetRecAddr(FNum);

            If OK And GlobLocked Then
            Begin
              // MH 03/03/2011 v6.7 ABSEXCH-10687: Added Trader Audit trail
              iTraderAudit := NewAuditInterface (atTrader);
              Try
                iTraderAudit.BeforeData := @LCust;

                Case MiscStrNo Of
                  1    : LCust.Company := FullCompKey(NewStr);
                  2..6 : LCust.Addr[Pred(MiscStrNo)] := NewStr;
                  7    : LCust.Contact := NewStr;
                  8    : LCust.Phone := FullCustPhone(NewStr);
                  9    : LCust.Fax := NewStr;
                  10   : LCust.Phone2 := NewStr;
                  11   : LCust.UserDef1 := NewStr;
                  12   : LCust.UserDef2 := NewStr;
                  13   : Begin
                           { Validata new CC Code }
                           If (Trim(NewStr) <> '') Then Begin
                             If Not GetCCDepRec (CompObj.CompanyBtr, NewStr, True) Then Begin
                               Result := ErrCC
                             End; { If }
                           End; { If }

                           If (Result = 0) Then Begin
                             //LCust.CustCC := LPassword.CostCtrRec.PCostC;
                             //PR: 28/01/2009 If NewStr was blank, then LPassword would contain whatever data it had from the most
                             //recent Find_Rec call on PWordF - usually the UserID. Changed to use NewStr.
                             LCust.CustCC := LJVar(UpperCase(NewStr), CCKeyLen);
                           End; { if }
                         End;
                  14   : Begin
                           { Validata new Department Code }
                           If (Trim(NewStr) <> '') Then Begin
                             If Not GetCCDepRec (CompObj.CompanyBtr, NewStr, False) Then Begin
                               Result := ErrDept
                             End; { If }
                           End; { If }

                           If (Result = 0) Then Begin
                             //LCust.CustDep := LPassword.CostCtrRec.PCostC;
                             //PR: 28/01/2009 If NewStr was blank, then LPassword would contain whatever data it had from the most
                             //recent Find_Rec call on PWordF  - usually the UserID. Changed to use NewStr.
                             LCust.CustDep := LJVar(UpperCase(NewStr), CCKeyLen);
                           End; { if }
                         End;
                  15   : LCust.AreaCode := NewStr;
                  16   : LCust.RepCode := NewStr;
                  17..21
                       : LCust.DAddr[MiscStrNo - 16] := NewStr;

                  { HM 27/10/99: v4.31 mods }
                  22, 25 : Begin { Statement To & Invoice To }
                             NewStr := UpperCase(Trim(NewStr));

                             If (NewStr <> '') Then Begin
                               { Code Set - validate }
                               NewStr := FullCustCode(NewStr);
                               KeyT := NewStr;

                               New(TmpCust);
                               TmpCust^ := LCust;

                               If LCheckRecExsists(KeyT, CustF, CustCodeK) Then Begin
                                 { Check its correct type }
                                 If (LCust.CustSupp = TmpCust^.CustSupp) And (LCust.CustCode <> TmpCust^.CustCode) Then Begin
                                   NewStr := LCust.CustCode;
                                   LCust := TmpCust^;

                                   Case MiscStrNo Of
                                     22 : LCust.RemitCode := NewStr;
                                     25 : LCust.SOPInvCode := NewStr;
                                   End; { Case MiscStrNo }
                                 End { If }
                                 Else Begin
                                   Result := ErrAccCode;
                                   LCust := TmpCust^;
                                 End; { Else }
                               End { If }
                               Else Begin
                                 Result := ErrAccCode;
                                 LCust := TmpCust^;
                               End; { If }

                               Dispose(TmpCust);
                             End { If }
                             Else Begin
                               { Blank code }
                               Case MiscStrNo Of
                                 22 : LCust.RemitCode := FullCustCode('');
                                 25 : LCust.SOPInvCode := FullCustCode('');
                               End; { Case MiscStrNo }
                             End; { Else }
                           End;
                  // MH 24/11/05: Modified VAT Code behaviour so that Inclusive VAT Codes are returned as 'IS'
  //                23     : If (Length(Trim(NewStr)) > 0) Then Begin
  //                           NewStr := UpperCase(Trim(NewStr)[1]);
  //                           If (NewStr[1] In VatSet) Then
  //                             LCust.VATCode := NewStr[1]
  //                           Else
  //                             Result := ErrVATCode;
  //                         End
  //                         Else
  //                           { No code specified }
  //                           Result := ErrVATCode;
                  23     : Begin
                             // Validate the new codes together and set the VAT Code fields
                             If (ValidateVATCodeString (IfThen (AcType = 'C', votCustomer, votSupplier), NewStr, LCust.EECMember, LCust.VATCode, LCust.CVATIncFlg) <> 0) Then
                             Begin
                               Result := ErrVATCode;
                             End; // If (ValidateVATCodeString (NewStr, LCust.VATCode, LCust.CVATIncFlg) <> 0)
                           End;

                  24     : If (Length(Trim(NewStr)) > 0) Then Begin
                             NewStr := UpperCase(Trim(NewStr)[1]);
                             If (NewStr[1] In ['Y', 'N']) Then
                               LCust.EECMember := NewStr[1] = 'Y'
                             Else
                               Result := ErrValue;
                           End;
                  26     : LCust.UserDef3 := NewStr;
                  27     : LCust.UserDef4 := NewStr;
                  28     : LCust.CustCode2 := FullCustCode2(UpperCase(NewStr));             { Alternate Code }
                  { Default Multi Loc Stock }
                  29     : Begin
                             NewStr := UpperCase(Trim(NewStr));
                             If (NewStr <> '') Then Begin
                               { Get Location Record }
                               If GetLocRec (CompanyBtr, NewStr) Then Begin
                                 { Got Location }
                                 LCust.DefMLocStk := LMLoc^.MLocLoc.loCode;
                               End { If }
                               Else
                                 Result := errLoc;
                             End { If }
                             Else
                               { Blank Location }
                               LCust.DefMLocStk := Full_MLocKey('');
                           End;
                  30     : LCust.PostCode := FullPostCode(NewStr);
                  { Email address for Statment/ Remittance }
                  31     : LCust.EmailAddr := FullEmailAddr(NewStr);
                  32, 34 : If (Length(Trim(NewStr)) > 0) Then Begin
                             NewStr := UpperCase(Trim(NewStr)[1]);
                             If (NewStr[1] In ['Y', 'N']) Then
                               Case MiscStrNo Of
                                 32 : LCust.EmlSndRdr  := NewStr[1] = 'Y'; { On next email transmnision, send reader & reset }
                                 //33 : LCust.EmlZipAtc  := NewStr[1] = 'Y'; { Default Zip attachement }
                                 34 : LCust.EmlSndHTML := NewStr[1] = 'Y'; { When sending XML, send HTML }
                               End { Case }
                             Else
                               Result := ErrValue;
                           End;
                  // 09/02/01: Extended to support EDZ forms
                  33     : If (Length(Trim(NewStr)) > 0) Then Begin
                             NewStr := UpperCase(Trim(NewStr));

                             If (NewStr = 'N') Or (NewStr = 'NO') Then
                               // NO - send unzipped
                               LCust.EmlZipAtc := 0
                             Else
                               If (NewStr = 'Y') Or (NewStr = 'YES') Or
                                  (NewStr = 'Z') Or (NewStr = 'ZIP') Then
                                 // YES or ZIP - sed as PK-ZIP format
                                 LCust.EmlZipAtc := 1
                               Else
                                 If (NewStr = 'E') Or (NewStr = 'EDZ') Then Begin
                                   // YES or ZIP - send as EDZ format
                                   If (LCust.EmlZipAtc <> 2) Then
                                     LCust.EmlSndRdr := True;
                                   LCust.EmlZipAtc := 2;
                                 End { If (NewStr = 'EDZ') }
                                 Else
                                   // unknown format
                                   Result := ErrValue;
                           End;
  (*
                33     : Case EmlZipAtc Of
                           0 : MiscStr := 'NO';
                           1 : MiscStr := 'ZIP';
                           2 : MiscStr := 'EDZ';
                         Else
                           MiscStr := '???';
                         End; { Case }
  *)
                  35     : LCust.WebLiveCat := NewStr;            { Web Catalogues }
                  //36     : MiscStr := VATRetRegC;          { Country of VAT registration - Not Implemented in Exch/Ent }
                  { Delivery Terms }
                  37     : Begin
                             // PKR. 10/02/2016. ABSEXCH-17252. Return error if not EC member
                             if LCust.EECMember then
                             begin
                               NewStr := Trim(NewStr);
                               If (NewStr = '') Or ValidDelTerms(NewStr) Then
                                 LCust.SSDDelTerms := NewStr          {     "     Delivery Terms }
                               Else
                                 Result := ErrValue;
                             end
                             else
                             begin
                               // Not an EC Member.
                               Result := ErrValue;
                             end;
                           End;

                  // HM 07/11/00: Added Line Discount
                  38     : Begin
                             NewStr := UpperCase(Trim(NewStr));
                             If (NewStr <> '') Then Begin
                               // Discount set - perform basic validation
                               If ((Length(NewStr) = 1) And (NewStr[1] In ['A'..'H'])) Or
                                  ((Length(NewStr) > 1) And (NewStr[Length(NewStr)] = '%')) Then Begin
                                 // Either a discount band or a percentage
                                 ProcessInputPAmount(LCust.Discount,LCust.CDiscCH,NewStr);
                               End { If }
                               Else
                                 Result := ErrValue;
                             End { If (NewStr <> '')  }
                             Else
                               // OK - resetting to 0
                               ProcessInputPAmount(LCust.Discount,LCust.CDiscCH,NewStr);
                           End;

                  // HM 25/06/02: v5.00.002
                  39     : LCust.VATRegNo := UpperCase(FullCVATKey(NewStr));
                  40     : LCust.STerms[1] := NewStr;
                  41     : LCust.STerms[2] := NewStr;

                  // HM 15/10/02: Added Bank Dets for v5.01
                  // HM 06/01/03: Added support for Cheque 2/3
                  42     : Begin
                             NewStr := Uppercase(Trim(NewStr));
                             If (NewStr[1] In ['B', 'C', '2', '3']) Then
                               LCust.PayType := NewStr[1]    // PayType     (B=BACS/C=Cheque,2=CHEQUE2/3=CHEQUE3)
                             Else
                               Result := ErrValue;
                           End;
                  // MH 10/09/2013 v7.0.6 ABSEXCH-14598: Modified to pickup new longer Bank Account No / Sort Code
                  //43     : LCust.BankAcc := NewStr;          // Bank A/C
                  //44     : MiscStr := BankSort;           // Sort Code
                  43     : LCust.acBankAccountCode := EncryptBankAccountCode(NewStr);            // Bank A/C
                  44     : LCust.acBankSortCode := EncryptBankSortCode(NewStr);         // Sort Code
                  45     : LCust.BankRef := NewStr;          // Bank Ref.
                  46     : If (LCust.CustSupp = 'C') Then Begin
                             NewStr := Uppercase(Trim(NewStr));
                             If (NewStr <> '') Then
                               Case NewStr[1] Of                // Direct Debit Mode
                                 'F' : LCust.DirDeb := 0;         // First Request
                                 'O' : LCust.DirDeb := 1;         // Ongoing Request
                                 'R' : LCust.DirDeb := 2;         // Re-present Last Request
                                 'L' : LCust.DirDeb := 3;         // Last Request
                               Else
                                 Result := ErrValue;
                               End
                             Else
                               // Cannot be blank
                               Result := ErrValue;
                           End { If (CustSupp = 'C') }
                           Else
                             // Only available for Customers
                             Result := ErrAccCode;

                  // HM 23/05/03: Added Paperless send methods
                  // Statement / Remittance
                  47     : Begin
                             NewStr := Trim(NewStr);
                             If (Length(NewStr) > 0) Then
                               If (NewStr[1] In ['0'..'4']) Then
                                 LCust.StatDMode := Ord(NewStr[1]) - Ord('0')
                               Else
                                 // Invalid Delivery Mode
                                 Result := ErrDeliveryMode
                             Else
                               // Cannot be blank
                               Result := ErrValue;
                           End;
                  // Invoice
                  48     : Begin
                             NewStr := Trim(NewStr);
                             If (Length(NewStr) > 0) Then
                               If (NewStr[1] In ['0'..'5']) Then
                                 LCust.InvDMode := Ord(NewStr[1]) - Ord('0')
                               Else
                                 // Invalid Delivery Mode
                                 Result := ErrDeliveryMode
                             Else
                               // Cannot be blank
                               Result := ErrValue;
                           End;

                  // HM 18/08/03: Added Account Status for v5.52
                  49     : Begin
                             NewStr := UpperCase(Trim(NewStr));
                             If (Length(NewStr) > 0) Then
                               If (NewStr[1] In ['O', 'N', 'H', 'C']) Then
                               begin
                                 Case NewStr[1] Of
                                   'O' : LCust.AccStatus := 0;
                                   'N' : LCust.AccStatus := 1;
                                   'H' : LCust.AccStatus := 2;
                                   'C' : LCust.AccStatus := 3;
                                 End; // Case NewStr[1]
                                 //HV 26/06/2018 2017R1.1 ABSEXCH-20793: provided support for entry in anonymisation control center if user changes Account Status to from OLE.
                                 if GDPROn then
                                   Result := SetAnonymisationStatus(CompObj);
                               end
                               Else
                                 // Invalid Status
                                 Result := ErrValue
                             Else
                               // Cannot be blank
                               Result := ErrValue;
                           End;

                  // MH 06/11/06: Added Their Code for Us for Volac
                  50     : Begin
                             LCust.RefNo := FullRefNo(NewStr);
                           End;
                  //GS 27/10/2011 ABSEXCH-11706:
                  //added support for UDEFs 6-10
                  51   : LCust.UserDef5 := NewStr;
                  52   : LCust.UserDef6 := NewStr;
                  53   : LCust.UserDef7 := NewStr;
                  54   : LCust.UserDef8 := NewStr;
                  55   : LCust.UserDef9 := NewStr;
                  56   : LCust.UserDef10 := NewStr;
                  // MH 10/09/2013 v7.0.6 ABSEXCH-14598: Added Mandate Fields
                  57   : LCust.acMandateID := EncryptBankMandateID(NewStr);
                  58   : Begin
                           // Validate the date
                           If (Trim(NewStr) <> '') Then
                           Begin
                             Try
                               // Exception will be raised if date isn't understandable
                               LCust.acMandateDate := FormatDatetime ('YYYYMMDD', StrToDate(NewStr));
                             Except
                               On Exception Do
                                 Result := ErrDate;
                             End;
                           End // If (Trim(NewStr) <> '')
                           Else
                             // Error - No date specified
                             Result :=  ErrValue;
                         End; // 58 - Mandate Date
                  // MH 18/10/2013 v7.0.7 ABSEXCH-14703: Added Delivery Postcode
                  59     : LCust.acDeliveryPostcode := NewStr;

                  // MH 20/05/2015 v7.0.14 ABSEXCH-16284: Added PPD OLE Functions
                  60     : Begin
                             NewStr := Trim(NewStr);
                             If (Length(NewStr) > 0) Then
                             Begin
                               If (LCust.CustSupp = 'C') Then
                               Begin
                                 // Customers - Can be 0-2
                                 If (NewStr[1] In ['0'..'2']) Then
                                   LCust.acPPDMode := TTraderPPDMode(Ord(NewStr[1]) - Ord('0'))
                                 Else
                                   // Invalid Delivery Mode
                                   Result := ErrValue
                               End // If (LCust.CustSupp = 'C')
                               Else
                               Begin
                                 // Suppliers - can be 0, 1, 3
                                 If (NewStr[1] In ['0', '1', '3']) Then
                                   LCust.acPPDMode := TTraderPPDMode(Ord(NewStr[1]) - Ord('0'))
                                 Else
                                   // Invalid Mode
                                   Result := ErrValue
                               End; // Else

                               // MH 26/06/2015 v7.0.14 ABSEXCH-16600: Added validation of PPD Percentage and Days
                               If (Result = 0) And (LCust.acPPDMode = pmPPDDisabled) Then
                               Begin
                                 // Zero down the PPD Percentage and Days if PPD is disabled for the account
                                 LCust.DefSetDisc := 0.0;
                                 LCust.DefSetDDays := 0;
                               End; // If (Result = 0) And (LCust.acPPDMode = pmPPDDisabled)
                             End // If (Length(NewStr) > 0)
                             Else
                               // Cannot be blank
                               Result := ErrValue;
                           End; // 60 - PPD Mode

                  // MH 02/12/2014 ABSEXCH-15836: Added Read-Write support for new account Country fields
                  61     : Begin
                             // Address Country must be valid
                             Idx := ISO3166CountryCodes.IndexOf(ifCountry2, NewStr);
                             If (Idx >= 0) Then
                               LCust.acCountry := ISO3166CountryCodes.ccCountryDetails[Idx].cdCountryCode2
                             Else
                               // Error - Invalid Country
                               Result :=  ErrValue;
                           End; // 61 - Country Code
                  62     : Begin
                             // Delivery Address Country can be blank if the entire delivery address is blank
                             If (Trim(NewStr) = '')
                                And
                                (Trim(LCust.DAddr[1]) = '') And (Trim(LCust.DAddr[2]) = '') And
                                (Trim(LCust.DAddr[3]) = '') And (Trim(LCust.DAddr[4]) = '') And
                                (Trim(LCust.DAddr[5]) = '') And (Trim(LCust.acDeliveryPostCode) = '') Then
                               LCust.acDeliveryCountry := '  '
                             Else
                             Begin
                               // Otherwise it must be a valid country
                               Idx := ISO3166CountryCodes.IndexOf(ifCountry2, NewStr);
                               If (Idx >= 0) Then
                                 LCust.acDeliveryCountry := ISO3166CountryCodes.ccCountryDetails[Idx].cdCountryCode2
                               Else
                                 // Error - Invalid Country
                                 Result :=  ErrValue;
                             End; // Else
                           End; // 62 - Delivery Address Country Code

                  { Default to QR Code }
                  // PKR. 25/01/2016. ABSEXCH-17111. Default to QR for Intrastat
                  63     : begin
                             // PKR. 10/02/2016. ABSEXCH-17252. Return error if not EC member.
                             if (LCust.EECMember) then
                             begin
                               if (acType = 'C') then
                               begin
                                 If (Length(Trim(NewStr)) > 0) Then
                                 Begin
                                   NewStr := UpperCase(Trim(NewStr)[1]);
                                   If (NewStr[1] In ['Y', 'N']) Then
                                     LCust.acDefaultToQR := NewStr[1] = 'Y'
                                   Else
                                     Result := ErrValue;
                                 End
                               end
                               else
                               begin
                                 // Not a Customer Record
                                 Result := ErrCust;
                               end;
                             end
                             else
                             begin
                               // Not an EC Member.
                               Result := ErrValue;
                             end;
                           end;
                 // SS 24/08/2016 ABSEXCH-15847 Added functions for 11 to 15 UDF
                  64   : LCust.CCDCardNo := NewStr;// 64 - UserDef11
                  65   : Begin
                           // Validate the date
                           If (Trim(NewStr) <> '') Then
                           Begin
                             Try
                               // Exception will be raised if date isn't understandable
                               LCust.CCDSDate:= FormatDatetime ('YYYYMMDD', StrToDate(NewStr));
                             Except
                               On Exception Do
                                 Result := ErrDate;
                             End;
                           End // If (Trim(NewStr) <> '')
                           Else
                             // Error - No date specified
                             Result :=  ErrValue;
                         End; // 58 - UserDef12
                  66  :  Begin
                           // Validate the date
                           If (Trim(NewStr) <> '') Then
                           Begin
                             Try
                               // Exception will be raised if date isn't understandable
                               LCust.CCDEDate:= FormatDatetime ('YYYYMMDD', StrToDate(NewStr));
                             Except
                               On Exception Do
                                 Result := ErrDate;
                             End;
                           End // If (Trim(NewStr) <> '')
                           Else
                             // Error - No date specified
                             Result :=  ErrValue;
                         End; // 58 - UserDef13
                  67   : LCust.CCDName := NewStr; //67 - Userdef14
                  68   : LCust.CCDSARef := NewStr; //68 - Userdef15

                End; { Case }

                If (Result = 0) Then Begin
                  LCust.LastUsed := Today;
                  LCust.TimeChange := TimeNowStr;

                  { HM 26/01/00: Added to stop indexing problems }
                  CheckCustNdx(LCust);

                  { update record }
                  LStatus := LPut_Rec (Fnum, KPath);

                  //GS 31/10/2011 Add Audit History Notes for v6.9
                  if LStatus = 0 then
                  begin
                    WriteAuditNote(anAccount, anEdit, CompObj);
                  end;

                End; { If }

                { Unlock record}
                LUnlockMLock(FNum);

                If (Result = 0) Then
                Begin
                  If (LStatus = 0) Then
                  Begin
                    Result := 0;

                    // MH 03/03/2011 v6.7 ABSEXCH-10687: Added Trader Audit trail
                    iTraderAudit.AfterData := @LCust;
                    iTraderAudit.WriteAuditEntry;
                  End // If (LStatus = 0)
                  Else
                    Result := ErrBtrBase + LStatus;
                End; { If }
              Finally
                iTraderAudit := NIL;
              End; // Try..Finally
            End { If }
            Else
              Result := ErrRecLock;
          End { If }
          Else
            Result := AcErr;
        End { If }
        Else
          Result := AcErr;
      End { With }
    End { If }
    Else
      Result := ErrPermit
  End; { If (Result = 0) }
End;

//HV 26/06/2018 2017R1.1 ABSEXCH-20793: provided support for entry in anonymisation control center if user changes Account Status to from OLE.
function TEnterpriseServer.SetAnonymisationStatus(var ACompObj: TCompanyInfo): Integer;
var
  lAnonDiaryDetail: IAnonymisationDiaryDetails;
  lAnonEntityType: TAnonymisationDiaryEntity;
  lRes: Integer;
  lKeyS: Str255;
  lEmpRes: Integer;
begin
  lKeyS := EmptyStr;
  with ACompObj.CompanyBtr.LCust do
  begin
    if (acAnonymisationStatus = asAnonymised) then
    begin
      // Added check on Trader Anonymised?
      Result := ErrTraderAnonymised;
    end
    else
    begin
      case CustSupp of
        'U' : lAnonEntityType := adeCustomer;
        'C' : lAnonEntityType := adeCustomer;
        'S' : lAnonEntityType := adeSupplier;
      end;

      lAnonDiaryDetail := CreateSingleAnonObj;
      if Assigned(lAnonDiaryDetail) then
      begin
        case AccStatus of
          0, 1, 2 :
          begin
            acAnonymisationStatus := asNotRequested;
            acAnonymisedDate := '';
            acAnonymisedTime := '';
            //Remove Entry from AnonymisationDiary Table
            lAnonDiaryDetail.adOLESetDrive := ACompObj.CompanyPath;
            lRes := lAnonDiaryDetail.RemoveEntity(lAnonEntityType, CustCode);
          end;
          3 :
          begin
            //Add Entry into AnonymisationDiary Table
            lAnonDiaryDetail.adEntityType := lAnonEntityType;
            lAnonDiaryDetail.adEntityCode := CustCode;
            lAnonDiaryDetail.adOLESetDrive := ACompObj.CompanyPath;

            lRes := lAnonDiaryDetail.AddEntity;
            if lRes = 0 then
            begin
              acAnonymisationStatus := asPending;
              acAnonymisedDate := lAnonDiaryDetail.adAnonymisationDate;
              acAnonymisedTime := TimeNowStr;
            end;

            //Validation check for the Employee associated with the Trader account
            if lAnonEntityType = adeSupplier then
            begin
              //Search sub contractor and closed them as well
              with ACompObj.CompanyBtr^ do
              begin
                lKeyS := PartCCKey(JARCode, JAECode);
                lEmpRes := LFind_Rec(B_GetFirst, JMiscF, JMK, lKeyS);
                with LJobMisc.EmplRec do
                begin
                  while (lEmpRes = 0) do
                  begin
                    if (EType = 2) and (emStatus <> emsClosed) and
                       (emAnonymisationStatus <> asAnonymised) and
                       (Trim(Supplier) = Trim(CustCode)) then
                    begin
                      emStatus := emsClosed;    {1: close the sub-contractor}
                      emAnonymisationStatus := asPending;
                      emAnonymisedDate := acAnonymisedDate;
                      emAnonymisedTime := TimeNowStr;
                      lEmpRes := LPut_Rec(JMiscF, JMK);
                    end;
                    lEmpRes := LFind_Rec(B_GetNext, JMiscF, JMK, lKeyS);
                  end;//while (lEmpRes = 0) do
                end;//with JobMisc.EmplRec do
              end;//with ACompObj.CompanyBtr^ do
            end;//if lAnonEntityType = adeSupplier then            
          end;
        end; //case AccStatus of
        Result := 0;
      end; //if Assigned(lAnonDiaryDetail) then
    end; //else
  end; //with ACompObj.CompanyBtr.LCust do    
end;


{***********************************************************************}
{* SaveAcMiscInt: Saves a Long Int value to the specified customer/    *}
{*                supplier record. The value updated is specified      *}
{*                using the MiscIntNo parameter, values are:           *}
{*                                                                     *}
{*                   1 : Currency                                      *}
{*                   2 : Sales GL Code                                 *}
{*                   3 : Cost Of Sales GL Code                         *}
{*                   4 : Control GL Code                               *}
{***********************************************************************}
Function TEnterpriseServer.SaveAcMiscInt (Var Company   : String;
                                          Var CustCode  : String;
                                          Var AcType    : String;
                                          Var MiscIntNo : SmallInt;
                                          Var NewInt    : LongInt) : SmallInt;
Const
  FNum  = CustF;
  KPath = CustCodeK;
Var
  CompObj     : TCompanyInfo;
  KeyR, KeyS  : Str255;
  AcErr       : SmallInt;

  { Lifted from InvListU. Returns True if Code is used by setup }
  Function Check_NCCodes(NCode : LongInt; AllowDr : Boolean)   :   Boolean;
  Var
    n        :  NomCtrlType;
    NCC      :  LongInt;
    FoundOk  :  Boolean;
  Begin
    FoundOk:=BOff;

    For  n:=InVAT to FreightNC do
      With CompObj.CompanyBtr^.LSyss do Begin
        NCC:=NomCtrlCodes[n];

        FoundOk:=((NCC=NCode)  and (((N<>Debtors) and (N<>Creditors)) or (Not AllowDr)));

        If (FoundOk) then
          Break;
      End; { With }

    Result := FoundOk;
  end;

Begin
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then Begin
    If (AcType = 'C') Then
      AcErr := ErrCust
    Else
      AcErr := ErrSupp;

    If CompObj.CheckSecurity (GetSecIIF (AcType = 'C', 478{32}, 483{42})) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        KeyS := FullCustCode(CustCode);
        KeyR := KeyS;

        LStatus:=LFind_Rec(B_GetGEq,FNum,KPath,KeyS);

        If LStatusOk And CheckKey(KeyR,KeyS,Length(KeyR),BOn) Then Begin
          { Check account type }
          If (CompObj.CompanyBtr.LCust.CustSupp = AcType) Then Begin
            { found - get rec and update }
            GLobLocked:=BOff;
            Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked);
            {GetMultiRecAddr (B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked, RecAddr);}
            LGetRecAddr(FNum);

            If OK And GlobLocked Then Begin
              Case MiscIntNo Of
                { Currency }
                1     : If CompObj.IsMultiCcy And (NewInt In [1..CurrencyType]) Then Begin
                          LCust.Currency := NewInt
                        End { If CompObj.IsMultiCcy And (NewInt In [1..30]) }
                        Else Begin
                          { Single Currency or Invalid Currency No }
                          Result := ErrCcy;
                        End; { Else }

                { Sales/Cost Of Sales/Control GL Codes }
                2..4  : If (NewInt = 0) Or GetNominalRec(CompObj.CompanyBtr, NewInt) Then Begin
                          Case MiscIntNo Of
                            { Sales GL }
                            2 : If (NewInt = 0) Or (LNom.NomType In [BankNHCode,PLNHCode]) Then
                                  LCust.DefNomCode := NewInt
                                Else
                                  Result := ErrNom;  { invalid GL Code }

                            { Cost Of Sales GL }
                            3 : If (NewInt = 0) Or (LNom.NomType In [BankNHCode,PLNHCode]) Then
                                  LCust.DefCOSNom := NewInt
                                Else
                                  Result := ErrNom;  { invalid GL Code }

                            { Control GL }
                            4 : If (NewInt = 0) Or ((LNom.NomType = CtrlNHCode) And (Not Check_NCCodes(LNom.NomCode, False))) Then
                                  LCust.DefCtrlNom := NewInt
                                Else
                                  Result := ErrNom;  { invalid GL Code }
                          End { Case }
                        End { If }
                        Else
                          Result := ErrNom;  { invalid GL Code }

                { HM 27/10/99: v4.31 mods }
                { Payment Terms }
                5     : If (NewInt >= 0) And (NewInt < 1000) Then
                          LCust.PayTerms := NewInt
                        Else
                          Result := ErrValue;
                { Settlement Days }
                // MH 26/06/2015 v7.0.14 ABSEXCH-16600: Added validation of PPD Percentage and Days
                6     : If ((LCust.acPPDMode <> pmPPDDisabled) And (NewInt >= 0) And (NewInt <= 999))
                           Or
                           ((LCust.acPPDMode = pmPPDDisabled) And (NewInt = 0)) Then
                          LCust.DefSetDDays := NewInt
                        Else
                          Result := ErrValue;
                { Form Def Set }
                7     : If (NewInt >= 0) And (NewInt <= 255) Then
                          LCust.FDefPageNo := NewInt
                        Else
                          Result := ErrValue;

                { Default Mode of transport }
                8     : begin
                          // PKR. 10/02/2016. ABSEXCH-17252. Return error if EC Member disabled.
                          if (LCust.EECMember) then
                          begin
                            // PKR. 10/02/2016. ABSEXCH-17252. Return error if EC Member disabled.
                            // Also allow zero value to effectively "blank" the value out.
                            If (NewInt = 0) or (ValidModeTran(NewInt)) Then
                              LCust.SSDModeTr := NewInt
                            Else
                              Result := ErrValue;
                          end
                          else
                          begin
                            // Not an EC Member.
                            Result := ErrValue;
                          end;
                        end;

                // MH 19/04/06: Added Tag No for wish list item
                9     : If (NewInt >= 0) And (NewInt <= 99) Then
                          LCust.DefTagNo := NewInt
                        Else
                          Result := ErrValue;

                // MH 22/10/2014 Order Payments: Added Order Payments support
                // 10 = Allow Order Payments - validate the GL Code
                10    : If Syss.ssEnableOrderPayments Then
                        Begin
                          // Order Payments enabled - validate the GL Code
                          If GetNominalRec(CompObj.CompanyBtr, NewInt) Then
                          Begin
                            // Must be an Active Balance Sheet GL Code
                            If (LNom.NomType <> BankNHCode) Or (LNom.HideAC <> 0) Then
                              Result := ErrNom;  { invalid GL Code }

                            // If GL Classes are enabled then it must be a Bank Account
                            If (Result = 0) And Syss.UseGLClass And (LNom.NomClass <> 10) Then
                              Result := ErrNom;  { invalid GL Code }

                            // GL Currency must be compatible with account currency
                            If (Result = 0) And (LNom.DefCurr <> 0) And (LNom.DefCurr <> LCust.Currency) Then
                              Result := ErrNom;  { invalid GL Code }

                            If (Result = 0) Then
                            Begin
                              LCust.acAllowOrderPayments := True;
                              LCust.acOrderPaymentsGLCode := LNom.NomCode;
                            End; // If (Result = 0)
                          End // If GetNominalRec(CompObj.CompanyBtr, NewInt)
                          Else
                            Result := ErrNom;  { invalid GL Code }
                        End // If Syss.ssEnableOrderPayments
                        Else
                        Begin
                          // Order Payments disabled
                          LCust.acAllowOrderPayments := False;
                          LCust.acOrderPaymentsGLCode := 0;
                        End;

                // 11 = Disable Order Payments
                11    : Begin
                          LCust.acAllowOrderPayments := False;
                          LCust.acOrderPaymentsGLCode := 0;
                        End;
              End; { Case }

              If (Result = 0) Then Begin
                LCust.LastUsed := Today;
                LCust.TimeChange := TimeNowStr;

                { HM 26/01/00: Added to stop indexing problems }
                CheckCustNdx(LCust);

                { update record }
                LStatus := LPut_Rec (Fnum, KPath);

                //GS 31/10/2011 Add Audit History Notes for v6.9
                  if LStatus = 0 then
                  begin
                    WriteAuditNote(anAccount, anEdit, CompObj);
                  end;

              End; { If }

              { Unlock record}
              LUnlockMLock(FNum);

              If (Result = 0) Then Begin
                If (LStatus = 0) Then
                  Result := 0
                Else
                  Result := ErrBtrBase + LStatus;
              End; { If }
            End { If }
            Else
              Result := ErrRecLock;
          End { If }
          Else
            Result := AcErr;
        End { If }
        Else
          Result := AcErr;
      End { With }
    End { If }
    Else
      Result := ErrPermit
  End; { If (Result = 0) }
End;


{***********************************************************************}
{* SaveAcMiscVal: Saves a Double value to the specified Customer/      *}
{*                supplier record. The value updated is specified      *}
{*                using the MiscIntNo parameter, values are:           *}
{*                                                                     *}
{*                   1  : Credit Limit                                 *}
{***********************************************************************}
Function TEnterpriseServer.SaveAcMiscVal (Var Company   : String;
                                          Var CustCode  : String;
                                          Var AcType    : String;
                                          Var MiscValNo : SmallInt;
                                          Var NewVal    : Double) : SmallInt;
Const
  FNum  = CustF;
  KPath = CustCodeK;
Var
  KeyR, KeyS  : Str255;
  CompObj     : TCompanyInfo;
  AcErr       : SmallInt;
Begin
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then Begin
    If (AcType = 'C') Then
      AcErr := ErrCust
    Else
      AcErr := ErrSupp;

    If CompObj.CheckSecurity (GetSecIIF (AcType = 'C', 478{32}, 483{42})) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        KeyS := FullCustCode(CustCode);
        KeyR := KeyS;

        LStatus:=LFind_Rec(B_GetGEq,FNum,KPath,KeyS);

        If LStatusOk And CheckKey(KeyR,KeyS,Length(KeyR),BOn) Then Begin
          { Check account type }
          If (CompObj.CompanyBtr.LCust.CustSupp = AcType) Then Begin
            { found - get rec and update }
            GLobLocked:=BOff;
            Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked);
            {GetMultiRecAddr (B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked, RecAddr);}
            LGetRecAddr(FNum);

            If OK And GlobLocked Then Begin
              Case MiscValNo Of
                { Credit Limit }
                1  : If (NewVal >= 0.0) Then
                       LCust.CreditLimit := Round_Up(NewVal,2)
                     Else
                       { invalid Value }
                       Result := ErrValue;

                { HM 27/10/99: v4.31 mods }
                2  : Begin
                       NewVal := Round_Up(NewVal, 2);

                       // MH 26/06/2015 v7.0.14 ABSEXCH-16600: Added validation of PPD Percentage and Days
                       If ((LCust.acPPDMode <> pmPPDDisabled) And (NewVal >= 0.0) And (NewVal <= 99.99))
                          Or
                          ((LCust.acPPDMode = pmPPDDisabled) And (NewVal = 0.0)) Then
                         LCust.DefSetDisc := NewVal
                       Else
                         { invalid Value }
                         Result := ErrValue;
                     End;
              End; { Case }

              If (Result = 0) Then Begin
                LCust.LastUsed := Today;
                LCust.TimeChange := TimeNowStr;

                { HM 26/01/00: Added to stop indexing problems }
                CheckCustNdx(LCust);

                { update record }
                LStatus := LPut_Rec (Fnum, KPath);

                //GS 31/10/2011 Add Audit History Notes for v6.9
                if LStatus = 0 then
                begin
                  WriteAuditNote(anAccount, anEdit, CompObj);
                end;
                
              End; { If }

              { Unlock record}
              LUnlockMLock(FNum);

              If (Result = 0) Then Begin
                If (LStatus = 0) Then
                  Result := 0
                Else
                  Result := ErrBtrBase + LStatus;
              End; { If }
            End { If }
            Else
              Result := ErrRecLock;
          End { If }
          Else
            Result := AcErr;
        End { If }
        Else
          Result := AcErr;
      End { With }
    End { If }
    Else
      Result := ErrPermit
  End; { If (Result = 0) }
End;


{***********************************************************************}
{* GetTeleValue: Returns a value from the Telesales History for the    *}
{*               specified customer/stock with optional filtering on   *}
{*               cost centre, department and location:                 *}
{*                  1  Qty Sold                                        *}
{***********************************************************************}
Function TEnterpriseServer.GetTeleValue (Var ValueReq  : SmallInt;
                                         Var Company   : String;
                                         Var CustCode  : String;
                                         Var StockId   : String;
                                         Var TheCcy    : SmallInt;
                                         Var TheYear   : SmallInt;
                                         Var ThePeriod : SmallInt;
                                         Var CostCntr  : String;
                                         Var Dept      : String;
                                         Var LocCode   : String;
                                         Var StockVal  : Double;
                                         Var AcType    : String) : SmallInt; // PL 30/08/2016 R3 ABSEXCH-16676 added AcType to indicate supplier or customer
Var
  DicLink  : DictLinkType;
  CompObj  : TCompanyInfo;
  PrYrMode : Byte;
Begin
  Result := 0;
  StockVal := 0.0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then
    If CompObj.CheckSecurity (494{33}) Then Begin
      { Check Customer Code }
      If GetCustRec (CompObj.CompanyBtr, CustCode, True) Then Begin
        If (CompObj.CompanyBtr.LCust.CustSupp = AcType) Then Begin
          { Get Stock Record }
          If GetStockRec (CompObj.CompanyBtr, StockId) Then Begin
            If (TheCcy >= 0) And (TheCcy <= CurrencyType) Then Begin
              { Check Cost Centre }
              If (Trim(CostCntr) <> '') Then Begin
                If GetCCDepRec (CompObj.CompanyBtr, CostCntr, True) Then
                  CostCntr := CompObj.CompanyBtr^.LPassword.CostCtrRec.PCostC
                Else
                  Result := ErrCC;
              End; { If }

              { Check Department }
              If (Result = 0) And (Trim(Dept) <> '') Then Begin
                If GetCCDepRec (CompObj.CompanyBtr, Dept, False) Then
                  { Got Department }
                  Dept := CompObj.CompanyBtr^.LPassword.CostCtrRec.PCostC
                Else
                  Result := ErrDept;
              End; { If }

              { Check Location }
              If (Result = 0) And (Trim(LocCode) <> '') Then Begin
                If GetLocRec (CompObj.CompanyBtr, LocCode) Then Begin
                  { Got Location }
                  LocCode := CompObj.CompanyBtr^.LMLoc^.MLocLoc.loCode;
                End { If }
                Else
                  { Invalid Location }
                  Result := ErrLoc;
              End; { If }

              If (Result = 0) Then Begin
                BuildDicLink (CompObj, DicLink, ThePeriod, TheYear, TheCcy, PrYrMode);

                With CompObj, CompanyBtr^ Do
                  StockVal := GetTeleStkStats(CKHistKey(LCust.CustCode, LocCode, CostCntr, Dept, LStock.StockFolio),
                                              ValueReq,
                                              DicLink,
                                              CompanyBtr,
                                              PrYrMode);
              End; { If }
            End { If }
            Else
              Result := ErrCcy;
          End { If }
          Else
            Result := ErrStock;
        End { If }
        Else // PL 30/08/2016 R3 ABSEXCH-16676 condition for appropriate Error msg
        Begin
          If(AcType='C') Then
            Result:= ErrCust   { is a supplier not a customer }
          Else
            Result := ErrSupp;
        end;
      End { If }
      Else
      Begin
        { Invalid code }
        If(AcType='C') Then
          Result:= ErrCust   { is a supplier not a customer }
        Else
          Result := ErrSupp;
      end;
    End { If }
    Else
      Result := ErrPermit
  Else
    Result := ErrComp;
End;


{***********************************************************************}
{* SaveTeleValue: Saves NewValue into the specified field of the       *}
{*                 Telesales for the specified customer/stock,         *}
{*                    1  Budget                                        *}
{***********************************************************************}
Function TEnterpriseServer.SaveTeleValue (Var SetValue  : SmallInt;
                                          Var Company   : String;
                                          Var CustCode  : String;
                                          Var StockId   : String;
                                          Var TheCcy    : SmallInt;
                                          Var TheYear   : SmallInt;
                                          Var ThePeriod : SmallInt;
                                          Var CostCntr  : String;
                                          Var Dept      : String;
                                          Var LocCode   : String;
                                          Var NewValue  : Double;
                                          Var AcType    : String) : SmallInt; // PL 30/08/2016 R3 ABSEXCH-16676 added AcType to indicate supplier or customer
Const
  FNum = NHistF;
  KPath = NHK;
Var
  Key, Key2 : Str255;
  RecAddr   : LongInt;
  CompObj   : TCompanyInfo;
  GoTit     : Boolean;
  Dummy     : Byte;
Begin
  Result := 0;

  If (ThePeriod > 0) And (ThePeriod < 100) Then Begin
    If (TheYear > 0) Then Begin
      { Load Company Data }
      Result := BtrList.OpenSaveCompany (Company, CompObj);
      If (Result = 0) Then Begin
        If CompObj.CheckSecurity (494{33}) Then Begin
          { Check Customer Code }
          If GetCustRec (CompObj.CompanyBtr, CustCode, True) Then Begin
            If (CompObj.CompanyBtr.LCust.CustSupp = AcType) Then Begin  //            // PL 30/08/2016 R3 ABSEXCH-16676 added AcType to indicate supplier or customer
              { Get Stock Record }
              If GetStockRec (CompObj.CompanyBtr, StockId) Then Begin
                If (TheCcy >= 0) And (TheCcy <= CurrencyType) Then Begin
                  { Check Cost Centre }
                  If (Trim(CostCntr) <> '') Then Begin
                    If GetCCDepRec (CompObj.CompanyBtr, CostCntr, True) Then
                      CostCntr := CompObj.CompanyBtr^.LPassword.CostCtrRec.PCostC
                    Else
                      Result := ErrCC;
                  End; { If }

                  { Check Department }
                  If (Result = 0) And (Trim(Dept) <> '') Then Begin
                    If GetCCDepRec (CompObj.CompanyBtr, Dept, False) Then
                      { Got Department }
                      Dept := CompObj.CompanyBtr^.LPassword.CostCtrRec.PCostC
                    Else
                      Result := ErrDept;
                  End; { If }

                  { Check Location }
                  If (Result = 0) And (Trim(LocCode) <> '') Then Begin
                    If GetLocRec (CompObj.CompanyBtr, LocCode) Then Begin
                      { Got Location }
                      LocCode := CompObj.CompanyBtr^.LMLoc^.MLocLoc.loCode;
                    End { If }
                    Else
                      { Invalid Location }
                      Result := ErrLoc;
                  End; { If }

                  If (Result = 0) Then
                    With CompObj.CompanyBtr^ Do Begin
                      Key := FullNHistKey(cuStkHistCode,
                                          CKHistKey(LCust.CustCode, LocCode, CostCntr, Dept, LStock.StockFolio),
                                          TheCcy,
                                          TheYear-1900,
                                          ThePeriod);
                      Key2 := Key;

                      { Load record }
                      GoTit := LCheckExsists(Key, FNum, KPath);

                      If (Not GoTit) Then Begin
                        { Record doesn't exist - Add new and then update }
                        LAdd_NHist(cuStkHistCode,
                                   CKHistKey(LCust.CustCode, LocCode, CostCntr, Dept, LStock.StockFolio),
                                   TheCcy,
                                   TheYear - 1900,
                                   ThePeriod,
                                   Fnum,
                                   KPath);

                        { Now get record }
                        Key := Key2;
                        GoTit := LCheckExsists(Key, FNum, KPath);
                      End; { If }

                      If GoTit Then Begin
                        { found - get rec and update }
                        GLobLocked:=BOff;
                        Ok:=LGetMultiRec(B_GetEq,B_MultLock,Key,KPAth,Fnum,BOn,GlobLocked);
                        {GetMultiRecAddr (B_GetEq,B_MultLock,Key,KPAth,Fnum,BOn,GlobLocked, RecAddr);}
                        LGetRecAddr(FNum);

                        LNHist.Budget := NewValue;

                        { update record }
                        LStatus := LPut_Rec (Fnum, KPath);
                        {Status := UnlockMultiSing(F[Fnum], Fnum, RecAddr);}
                        LUnlockMLock(FNum);
                        If Not LStatusOk Then
                          Result := ErrBtrBase + LStatus;

                        // HM 29/05/03: Added YTD Creation
(*
                        Dummy := 0;  // Doesn't appear to be used at this time

                        // Fake the Local Period system for EL's functions
                        With UserProfile^ Do Begin
                          UCPr := ThePeriod;
                          UCYr := TheYear - 1900;
                        End; { With UserProfile^ }

                        LFillBudget (FNum, KPath, Dummy, Key2);
*)
                      End;
                    End { With }
                End { If }
                Else
                  Result := ErrCcy;
              End { If }
              Else
                Result := ErrStock;
            End { If }
            Else
            Begin
              // PL 30/08/2016 R3 ABSEXCH-16676 condition for appropriate Error msg
              If(AcType='C') Then
                Result:= ErrCust { is a supplier not a customer }
              Else
                Result := ErrSupp;
            end
          End { If }
          Else
          Begin
            // PL 30/08/2016 R3 ABSEXCH-16676 condition for appropriate Error msg
            If(AcType='C') Then
              Result:= ErrCust { is a supplier not a customer }
            Else
              Result := ErrSupp;
          end
        End { If }
        Else
          Result := ErrPermit;
      End; { If (Result = 0) }
    End { If }
    Else
      Result := ErrYear;
  End { If }
  Else
    Result := ErrPeriod;
End;


{*****************************************************************************}
{*                                                                           *}
{*****************************************************************************}
Function TEnterpriseServer.GetGLJobActual(Var Company    : String;
                                          Var TheCcy     : SmallInt;
                                          Var StartPr    : SmallInt;
                                          Var StartYr    : SmallInt;
                                          Var EndPr      : SmallInt;
                                          Var EndYr      : SmallInt;
                                          Var NomCode    : LongInt;
                                          Var JobCode    : String;
                                          Var AnalCode   : String;
                                          Var StkCode    : String;
                                          Var LocCode    : String;
                                          Var CostCentre : String;
                                          Var Department : String;
                                          Var AccCode    : String;
                                          Var GLActuals  : Double) : SmallInt;
Const
  FNum = JDetlF;
Var
  frmOLEProgress      : TfrmOLEProgress;
  CompObj             : TCompanyInfo;
  oReportLogger       : TEntSQLReportLogger;
  GotCC, GotDept, GotAc, GotStock, GotLoc, GotAnal, WantTrans : Boolean;
  SDate, EDate        : LongDate;
  oNominal, oJobCode, oAnalCode : TCachedDataRecord;
  bContinue  : Boolean;

  //------------------------------

  Procedure ProcessTransactionLine;
  Var
    LineAmt : Double;
    UOR     : Byte;
  Begin // ProcessTransactionLine
    With CompObj.CompanyBtr^ Do
    Begin
      { Check Document Type }
      WantTrans := Not (LId.IdDocHed In PSOPSet +
                                        QuotesSet +
                                        StkAdjSplit +
                                        TSTSplit);

      { Check Location if req }
      If WantTrans And GotLoc Then Begin
        WantTrans := (LocCode = LId.MLocStk);
      End; { If }


      { Check Account if req }
      If WantTrans And GotAc Then Begin
        WantTrans := (AccCode = LId.CustCode);
      End; { If }

      { Check Cost Centre if req }
      If WantTrans And GotCC Then Begin
        WantTrans := (CostCentre = LId.CCDep[True]);
      End; { If }

      { Check Department if req }
      If WantTrans And GotDept Then Begin
        WantTrans := (Department = LId.CCDep[False]);
      End; { If }

      If WantTrans Then Begin
        { Do the Biz - Calc line total in transaction currency }
        LineAmt := DetLTotal (LId, False, False, 0.0) * DocNotCnst;

        If (TheCcy = 0) And (TheCcy <> LId.Currency) Then Begin
          { Convert to Consolidated if not already consolidated }
          UOR:=fxUseORate(False,BOn,LId.CXRate,LId.UseORate,LId.Currency,0);
          LineAmt := Round_Up (Conv_TCurr(LineAmt, XRate(LId.CXRate, False, LId.Currency),LId.Currency,UOR,False), 2);
        End; { If }

        GLActuals := GLActuals + LineAmt;
      End; { If }
    End; // With CompObj.CompanyBtr^
  End; // ProcessTransactionLine

  //------------------------------

  // CJS 2014-06-27 - ABSEXCH-15398 - OLE Performance - ENTGLJOBACTUAL
  Procedure FindSQLTransactionLines;
  Var
    Lines: TSQLStoredProcedureTransactionLines;
    QryJobCode: AnsiString;
    Params: AnsiString;
  Begin // FindSQLTransactionLines
    Lines := CompObj.SQLStoredProcedureTransactionLines;
    Lines.Logger := CompObj.Logger;
    Lines.Logger.Level := llInfo;
    Lines.SQLCaller := CompObj.SQLCaller;
    QryJobCode := QuotedStr(UpperCase(LJVar(JobCode, 10)));

    // Main parameters
    Params := Format('@iv_GLCode = %d, @iv_StartPeriod = %d, @iv_StartYear = %d, @iv_EndPeriod = %d, @iv_EndYear = %d, @iv_Currency = %d, @iv_JobCode = %s', [NomCode, StartPr, StartYr, EndPr, EndYr, TheCCY, QryJobCode]);

    // Optional Analysis Code
    If GotAnal Then
      Params := Params + ', @iv_AnalysisCode = ' + QuotedStr(UpperCase(Trim(AnalCode)));

    // Optional Stock Code
    If GotStock Then
      Params := Params + ', @iv_StockCode = ' + QuotedStr(UpperCase(Trim(StkCode)));

    // Optional Location Code
    If GotLoc Then
      Params := Params + ', @iv_LocationCode = ' + QuotedStr(UpperCase(Trim(LocCode)));

    // Optional Cost Centre Code
    If GotCC Then
      Params := Params + ', @iv_CostCentre = ' + QuotedStr(UpperCase(Trim(CostCentre)));

    // Optional Department Code
    If GotDept Then
      Params := Params + ', @iv_Department = ' + QuotedStr(UpperCase(Trim(Department)));

    // Optional Account Code
    If GotAc Then
      Params := Params + ', @iv_AccountCode = ' + QuotedStr(UpperCase(Trim(AccCode)));

    // Read and process all the lines
    Lines.StoredProcedure := 'EXEC [COMPANY].esp_GLJobActual ' + Params;
    Lines.CompanyCode := CompObj.CompanyCode;
    Lines.OpenFile;
    Lines.First;
    while not Lines.EOF do
    begin
      Lines.ReadRecordInto(CompObj.CompanyBtr.LId);

      ProcessTransactionLine;

      Lines.Next;
    end;
    Lines.CloseFile;
  End; // FindSQLTransactionLines

  //------------------------------

  Procedure FindPervasiveTransactionLines;
  Var
    KeyS, KeyChk, KeyS2 : Str255;
    RecAddr             : LongInt;
    WantTrans : Boolean;
    KPath               : Integer;
  Begin // FindPervasiveTransactionLines
    With CompObj.CompanyBtr^ Do
    Begin
      { Pass through the posted Job Actuals for the Job/Currency }
      If GotAnal Then Begin
        { Use Job-Analysis Index - 01 - (RecPfix+SubType) +  AnalKey + Cr+Yr+Pr }
        KPath := JDAnalK;

        If (TheCcy > 0) Then Begin
          KeyS := FullNHistKey(PartCCKey(JBRCode, JBECode),
                               FullJobCode(JobCode) + FullJACode(AnalCode),
                               TheCcy,
                               StartYr,
                               StartPr);
          KeyChk := KeyS;
          SetLength(KeyChk, 23);
        End { If }
        Else Begin
          KeyS := PartCCKey(JBRCode, JBECode) + FullJobCode(JobCode) + FullJACode(AnalCode);
          KeyChk := KeyS;
        End; { Else }
      End { If }
      Else Begin
        { Use Job Index }
        KPath := JDLedgerK;

        If (TheCcy > 0) Then Begin
          { Specific Currency }
          KeyS := FullJAKey (JBRCode, JBECode, FullJobCode(JobCode))+#1+Chr(TheCcy)
        End { If }
        Else Begin
          { All Currencies }
          KeyS := FullJAKey (JBRCode, JBECode, FullJobCode(JobCode))+#1;
        End; { Else }

        KeyChk := KeyS;
      End; { Else }

      LStatus:=LFind_Rec(B_GetGEq,FNum,KPath,KeyS);
      While LStatusOk And CheckKey(KeyS,KeyChk,Length(KeyChk),BOn) And (Not frmOLEProgress.Aborted) Do
      Begin
        With LJobDetl.JobActual Do
        Begin
          { Check date is in range and its posted }
          If (Pr2Fig(ActYr,ActPr) >= Pr2Fig(StartYr,StartPr)) And
             (Pr2Fig(ActYr,ActPr) <= Pr2Fig(EndYr,EndPr)) And
             Posted Then
          Begin
            { Update progress }
            frmOLEProgress.lblProg.Caption := LineORef +
                                              ' - ' +
                                              POutDate(JDate);

            { Check GL Code }
            WantTrans := (OrigNCode = NomCode);

            If WantTrans And GotStock Then
              WantTrans := (StkCode = LJobDetl.JobActual.StockCode);

            { Check its a document type we want }
            If WantTrans Then
            Begin
              { Link to Transaction Line }
              KeyS2 := FullNomKey(LineFolio) + FullNomKey(LineNo);
              LStatus:=LFind_Rec(B_GetEq,IDetailF,IdLinkK,KeyS2);
              If LStatusOk And (LId.FolioRef = LineFolio) And (LId.ABSLineNo = LineNo) Then
                ProcessTransactionLine;
            End; // If WantTrans
          End; // If (Pr2Fig(ActYr,ActPr) >= ...
        End; // With LJobDetl.JobActual

        LStatus:=LFind_Rec(B_GetNext,FNum,KPath,KeyS);

        Application.ProcessMessages;
      End; // While LStatusOk And CheckKey(KeyS,KeyChk,Length(KeyChk),BOn) And (Not frmOLEProgress.Aborted)
    End; // With CompObj.CompanyBtr^
  End; // FindPervasiveTransactionLines

  //------------------------------

Begin { GetGLJobActual }
  Result := 0;
  GLActuals := 0.0;

  (*
  // oReportLogger := TEntSQLReportLogger.Create('OLEGLJobActual');
  Try
    oReportLogger.StartQuery('GetGLJobActual(Company=' + Company + ', ' +
                                             'TheCcy=' + IntToStr(TheCcy) + ', ' +
                                             'StartPr=' + IntToStr(StartPr) + ', ' +
                                             'StartYr=' + IntToStr(StartYr) + ', ' +
                                             'EndPr=' + IntToStr(EndPr) + ', ' +
                                             'EndYr=' + IntToStr(EndYr) + ', ' +
                                             'NomCode=' + IntToStr(NomCode) + ', ' +
                                             'JobCode=' + JobCode + ', ' +
                                             'AnalCode=' + AnalCode + ', ' +
                                             'StkCode=' + StkCode + ', ' +
                                             'LocCode=' + LocCode + ', ' +
                                             'CostCentre=' + CostCentre + ', ' +
                                             'Department=' + Department + ', ' +
                                             'AccCode=' + AccCode + ')');

  *)

    { Load Company Data }
    If BtrList.OpenCompany (Company, CompObj) Then Begin
      If CompObj.CheckSecurity (487{20}) Then Begin
        //oReportLogger := CompObj.Logger;
        // MH 23/08/2011 - v6.8 - Added Caching of Nominal Code records
        oNominal := CompObj.NominalCodeCache.GetNominalCode (NomCode);
        If Assigned(oNominal) Then
        Begin
          // Copy details out of cache into LNom record
          oNominal.DownloadRecord (@CompObj.CompanyBtr^.LNom);
          bContinue := True;
        End // If Assigned(oNominal)
        Else
        Begin
          // Lookup nominal and add to cache for next time
          bContinue := GetNominalRec (CompObj.CompanyBtr, NomCode);
          If bContinue Then
            CompObj.NominalCodeCache.AddToCache (CompObj.CompanyBtr^.LNom.NomCode, @CompObj.CompanyBtr^.LNom, SizeOf(NominalRec));
        End; // Else

        //If GetNominalRec (CompObj.CompanyBtr, NomCode) Then
        If bContinue Then
        Begin
          With CompObj, CompanyBtr^ Do Begin
            { Check Nominal Type is valid }
            If (Result = 0) Then Begin
              If (LNom.NomType In ['F', 'H']) Then
                Result := ErrNom;
            End; { If }

            { Check Currency }
            If (Result = 0) Then Begin
              If (TheCcy < 0) Or (TheCcy > CurrencyType) Then
                Result := ErrCcy;
            End; { If }

            { Check Job Code }
            If (Result = 0) Then
            Begin
              // MH 11/06/2014 v7.0.11 ABSEXCH-15398: Added caching on Job Codes
              oJobCode := CompObj.JobCodeCache.GetJobCode (JobCode);
              If Assigned(oJobCode) Then
              Begin
                // Copy details out of cache into LNom record
                oJobCode.DownloadRecord (@CompObj.CompanyBtr^.LJobRec^);
                bContinue := True;
              End // If Assigned(oJobCode)
              Else
              Begin
                // Lookup job and add to cache for next time
                bContinue := GetJobRec (CompObj.CompanyBtr, JobCode);
                If bContinue Then
                  CompObj.JobCodeCache.AddToCache (CompObj.CompanyBtr^.LJobRec^.JobCode, @CompObj.CompanyBtr^.LJobRec^, SizeOf(JobRecType));
              End; // Else

              If bContinue Then
                JobCode := LJobRec^.JobCode
              Else
                Result := ErrJobCode;
            End; { If }

            { Check Analysis Code }
            GotAnal := False;
            If (Result = 0) And (AnalCode <> '') Then
            Begin
              // MH 11/06/2014 v7.0.11 ABSEXCH-15398: Added caching on Analysis Codes
              oAnalCode := CompObj.AnalysisCodeCache.GetAnalysisCode (AnalCode);
              If Assigned(oAnalCode) Then
              Begin
                // Copy details out of cache into LNom record
                oAnalCode.DownloadRecord (@CompObj.CompanyBtr^.LJobMisc^);
                bContinue := True;
              End // If Assigned(oAnalCode)
              Else
              Begin
                // Lookup nominal and add to cache for next time
                bContinue := GetJobMiscRec (CompObj.CompanyBtr, AnalCode, 2);
                If bContinue Then
                  CompObj.AnalysisCodeCache.AddToCache (CompObj.CompanyBtr^.LJobMisc.JobAnalRec.JAnalCode, @CompObj.CompanyBtr^.LJobMisc^, SizeOf(JobMiscRec));
              End; // Else

              If bContinue Then
              Begin
                AnalCode := LJobMisc^.JobAnalRec.JAnalCode;
                GotAnal := True;
              End { If }
              Else
                Result := ErrJobAnal;
            End; { If }

            { Check Stock }
            GotStock := False;
            If (Result = 0) And (StkCode <> '') Then Begin
              If GetStockRec (CompanyBtr, StkCode) Then Begin
                StkCode := LStock.StockCode;
                GotStock := True;
              End { If }
              Else
                Result := ErrStock;
            End; { If }

            { Check Location }
            GotLoc := False;
            If (Result = 0) And (LocCode <> '') Then Begin
              If GetLocRec (CompanyBtr, LocCode) Then Begin
                LocCode := LMLoc^.MLocLoc.loCode;
                GotLoc := True;
              End { If }
              Else
                Result := ErrLoc;
            End; { If }

            { Check Cost Centre if req }
            GotCC := False;
            If (Result = 0) And (CostCentre <> '') Then Begin
              // MH 11/06/2014 v7.0.11 ABSEXCH-15398: Added caching of CC/Dept to EntGLJobActual
              CostCentre := UpperCase(LJVar(CostCentre, CCKeyLen));
              If ValidateCCDeptCode (CompObj, CostCentre, True) Then
                GotCC := True
              Else
                Result := ErrCC;
            End; { If }

            { Check Department if req }
            GotDept := False;
            If (Result = 0) And (Department <> '') Then Begin
              // MH 11/06/2014 v7.0.11 ABSEXCH-15398: Added caching of CC/Dept to EntGLJobActual
              Department := UpperCase(LJVar(Department, CCKeyLen));
              If ValidateCCDeptCode (CompObj, Department, False) Then
                GotDept := True
              Else
                Result := ErrDept;
            End; { If }

            { Check Account if req }
            GotAc := False;
            If (Result = 0) And (AccCode <> '') Then Begin
              If GetCustRec (CompanyBtr, AccCode, True) Then Begin
                AccCode := LCust.CustCode;
                GotAc := True;
              End { If }
              Else
                Result := ErrAccCode;
            End; { If }

            If (Result = 0) Then Begin
              { Everything is AOK or blank - Check Periods }
              If (StartYr > 1900) Then StartYr := StartYr - 1900;
              If (EndYr > 1900) Then EndYr := EndYr - 1900;

              If (Pr2Fig(EndYr,EndPr) >= Pr2Fig(StartYr,StartPr)) Then Begin
                { Display progress dialog }
                frmOLEProgress := TfrmOLEProgress.Create(Application.MainForm);
                Try
                  With frmOLEProgress Do
                  Begin
                    Caption := 'EntGLJobActual';
                    lstInfo.Items.Add('Calculating GL Job Actuals...');
                    lstInfo.Items.Add('   GL Code' + #9 + IntToStr(NomCode));
                    lstInfo.Items.Add('   Job' + #9 + JobCode);
                    lstInfo.Items.Add('   Period Range' + #9 + POutDate(SDate) + ' to ' + POutDate(EDate));
                    lstInfo.Items.Add('   Currency' + #9 + IntToStr(TheCcy));
                    If GotAnal Then lstInfo.Items.Add('   Analysis' + #9 + AnalCode);
                    If GotAc Then lstInfo.Items.Add('   Account' + #9 + AccCode);
                    If GotCC Then lstInfo.Items.Add('   CostCentre' + #9 + CostCentre);
                    If GotDept Then lstInfo.Items.Add('   Department' + #9 + Department);
                    If GotStock Then lstInfo.Items.Add('   Stock' + #9 + StkCode);
                    If GotLoc Then lstInfo.Items.Add('   Location' + #9 + LocCode);
                    lblProg.Caption := '';
                  End; { With }

                  // CJS 2014-06-27 - ABSEXCH-15398 - OLE Performance - ENTGLJOBACTUAL
                  If SQLUtils.UsingSQL and SQLReportsConfiguration.UseOLESQLTransactionLines Then
                  begin
                    try
                      FindSQLTransactionLines;
                    except
                      on E:Exception do
                      begin
                        Result := ErrInternalErr;
                      end;
                    end;
                  end
                  Else
                  Begin
                    frmOLEProgress.Show;
                    FindPervasiveTransactionLines;
                  End; // Else

                  If frmOLEProgress.Aborted Then
                    { Aborted by User }
                    Result := ErrUserAbort;
                Finally
                  frmOLEProgress.Free;
                End;
              End { If }
              Else
                { Invalid End Date }
                Result := ErrEndDate;
            End; { If }
          End; { With }
        End { If }
        Else
          { Invalid nominal code }
          Result := ErrNom;
      End { If }
      Else
        Result := ErrPermit;
    End { If }
    Else
      Result := ErrComp;

  (*
    oReportLogger.FinishQuery;
  Finally
    FreeAndNIL(oReportLogger);
  End; // Try..Finally
  *)
End;  { GetGLJobActual }


Function TEnterpriseServer.GetCurrTriBools (Var Company  : String;
                                            Var Currency : SmallInt;
                                            Var BoolNo   : SmallInt;
                                            Var BoolVar  : String) : SmallInt;
Var
  CompObj : TCompanyInfo;
  BoolVal : Boolean;
Begin { GetCurrTriBools }
  Result := 0;
  BoolVal := False;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    With CompObj, CompanyBtr^ Do Begin
      If IsMultiCcy And (Currency In [Low(LSyssCurr.Currencies)..High(LSyssCurr.Currencies)]) Then Begin
        If (BoolNo = 1) Then Begin
          { Return 1/X flag from ghost currency table }
          BoolVal := LSyssGCur.GhostRates.TriInvert[Currency];
        End { If }
        Else Begin
          { Return floating currency flag from ghost currency table }
          BoolVal := LSyssGCur.GhostRates.TriFloat[Currency];
        End; { Else }
      End { If }
      Else Begin
        { Single Currency or invalid Currency Number }
        Result := ErrCcy;
      End; { Else }
    End; { With CompObj, CompanyBtr^ }
  End { If }
  Else
    Result := ErrComp;

  If BoolVal Then BoolVar := 'Y' Else BoolVar := 'N';
End; { GetCurrTriBools }


Function TEnterpriseServer.GetCurrTriCurr (Var Company  : String;
                                           Var Currency : SmallInt;
                                           Var CurrNo   : SmallInt) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin { GetCurrTriCurr }
  Result := 0;
  CurrNo := 0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    With CompObj, CompanyBtr^ Do Begin
      If IsMultiCcy And (Currency In [Low(LSyssCurr.Currencies)..High(LSyssCurr.Currencies)]) Then Begin
        { Return 1/X flag from ghost currency table }
        CurrNo := LSyssGCur.GhostRates.TriEuro[Currency];
      End { If }
      Else Begin
        { Single Currency or invalid Currency Number }
        Result := ErrCcy;
      End; { Else }
    End; { With CompObj, CompanyBtr^ }
  End { If }
  Else
    Result := ErrComp;
End; { GetCurrTriCurr }


Function TEnterpriseServer.GetCurrTriRate (Var Company  : String;
                                           Var Currency : SmallInt;
                                           Var TriRate  : Double) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin { GetCurrTriRate }
  Result := 0;
  TriRate := 0.0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    With CompObj, CompanyBtr^ Do Begin
      If IsMultiCcy And (Currency In [Low(LSyssCurr.Currencies)..High(LSyssCurr.Currencies)]) Then Begin
        { Return 1/X flag from ghost currency table }
        TriRate := LSyssGCur.GhostRates.TriRates[Currency];

        If (TriRate = 0.0) Then TriRate := 1.0;
      End { If }
      Else Begin
        { Single Currency or invalid Currency Number }
        Result := ErrCcy;
      End; { Else }
    End; { With CompObj, CompanyBtr^ }
  End { If }
  Else
    Result := ErrComp;
End; { GetCurrTriRate }


Function TEnterpriseServer.GetSysFlag (Var Company : String;
                                       Var FlagNo  : SmallInt;
                                       Var FlagVal : String) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin { GetSysFlag }
  Result := 0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    With CompObj, CompanyBtr^ Do Begin
      Case FlagNo Of
        { Use Cost Centres and Departments }
        1 : Begin
              If LSyss.UseCCDep Then Begin
                FlagVal := 'Y'
              End { Else }
              Else Begin
                FlagVal := 'N';
              End; { Else }
            End;
      Else
        Result := ErrUnknown;
      End; { Case FlagNo }
    End; { With CompObj, CompanyBtr }
  End { If }
  Else
    Result := ErrComp;
End; { GetSysFlag }

//-------------------------------------------------------------------------

{ Creates a multi-line Nominal Transfer }
// MH 09/10/2014 v7.0.12 ABSEXCH-15632: Split out to separate function for Auto-Reversing Support to AddNOMLines
Function TEnterpriseServer.AddNomLines (Var Company         : String;
                                        Var TransDate       : String;
                                        Var TheYear         : SmallInt;
                                        Var ThePeriod       : SmallInt;
                                        Var TranDesc        : String;
                                        Var VATCountry      : String;
                                        Var VATFlag         : String;
                                        Var THUserFieldList : Variant;  // HM 17/06/04: Added for EntAddNOMUDFLines
                                        Var GLList          : Variant;
                                        Var DescList        : Variant;
                                        Var CurrList        : Variant;
                                        Var AmtList         : Variant;
                                        Var RateList        : Variant;
                                        Var VATCodeList     : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                        Var IncVATCodeList  : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                        Var VATAmountList   : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                        Var CCList          : Variant;
                                        Var DeptList        : Variant;
                                        Var JobList         : Variant;
                                        Var AnalList        : Variant;
                                        Var PayRefList      : Variant;
                                        Var ResetJCGL       : String;    // MH 21/04/06: 'Y'/'N'
                                        Var TLUDF1List      : Variant;
                                        Var TLUDF2List      : Variant;
                                        Var TLUDF3List      : Variant;
                                        Var TLUDF4List      : Variant;
                                        Var TLUDF5List      : Variant;
                                        Var TLUDF6List      : Variant;
                                        Var TLUDF7List      : Variant;
                                        Var TLUDF8List      : Variant;
                                        Var TLUDF9List      : Variant;
                                        Var TLUDF10List     : Variant) : SmallInt;
Begin // AddNomLines
  Result := AddNomLines_AutoReversing (Company, TransDate, TheYear, ThePeriod, TranDesc, VATCountry, VATFlag,
                                       THUserFieldList, GLList, DescList, CurrList, AmtList, RateList, VATCodeList,
                                       IncVATCodeList, VATAmountList, CCList, DeptList, JobList, AnalList, PayRefList,
                                       ResetJCGL, TLUDF1List, TLUDF2List, TLUDF3List, TLUDF4List, TLUDF5List,
                                       TLUDF6List, TLUDF7List, TLUDF8List, TLUDF9List, TLUDF10List, Not AutoReversingNOM);
End; // AddNomLines

//------------------------------

// MH 09/10/2014 v7.0.12 ABSEXCH-15632: Added Auto-Reversing Support to AddNOMLines
Function  TEnterpriseServer.AddNomLines_AutoRev (Var Company         : String;
                                                 Var TransDate       : String;
                                                 Var TheYear         : SmallInt;
                                                 Var ThePeriod       : SmallInt;
                                                 Var TranDesc        : String;
                                                 Var VATCountry      : String;
                                                 Var VATFlag         : String;
                                                 Var THUserFieldList : Variant;  // HM 17/06/04: Added for EntAddNOMUDFLines
                                                 Var GLList          : Variant;
                                                 Var DescList        : Variant;
                                                 Var CurrList        : Variant;
                                                 Var AmtList         : Variant;
                                                 Var RateList        : Variant;
                                                 Var VATCodeList     : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                                 Var IncVATCodeList  : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                                 Var VATAmountList   : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                                 Var CCList          : Variant;
                                                 Var DeptList        : Variant;
                                                 Var JobList         : Variant;
                                                 Var AnalList        : Variant;
                                                 Var PayRefList      : Variant;
                                                 Var ResetJCGL       : String;   // MH 21/04/06: 'Y'/'N'
                                                 Var TLUDF1List      : Variant;  // MH 18/03/2011
                                                 Var TLUDF2List      : Variant;
                                                 Var TLUDF3List      : Variant;
                                                 Var TLUDF4List      : Variant;
                                                 Var TLUDF5List      : Variant;
                                                 Var TLUDF6List      : Variant;
                                                 Var TLUDF7List      : Variant;
                                                 Var TLUDF8List      : Variant;
                                                 Var TLUDF9List      : Variant;
                                                 Var TLUDF10List     : Variant) : SmallInt;
Begin // AddNomLines_AutoRev
  Result := AddNomLines_AutoReversing (Company, TransDate, TheYear, ThePeriod, TranDesc, VATCountry, VATFlag,
                                       THUserFieldList, GLList, DescList, CurrList, AmtList, RateList, VATCodeList,
                                       IncVATCodeList, VATAmountList, CCList, DeptList, JobList, AnalList, PayRefList,
                                       ResetJCGL, TLUDF1List, TLUDF2List, TLUDF3List, TLUDF4List, TLUDF5List,
                                       TLUDF6List, TLUDF7List, TLUDF8List, TLUDF9List, TLUDF10List, AutoReversingNOM);
End; // AddNomLines_AutoRev

//------------------------------

// MH 09/10/2014 v7.0.12 ABSEXCH-15632: Split the AddNomLines functionality out into separate
//                                      routines because if we added the AutoReversing parameter (33rd)
//                                      onto the public function then the first two parameters
//                                      (Company and TransDate) were totally screwed and it crashed
//                                      unpredictably.
Function TEnterpriseServer.AddNomLines_AutoReversing (Var Company         : String;
                                                      Var TransDate       : String;
                                                      Var TheYear         : SmallInt;
                                                      Var ThePeriod       : SmallInt;
                                                      Var TranDesc        : String;
                                                      Var VATCountry      : String;
                                                      Var VATFlag         : String;
                                                      Var THUserFieldList : Variant;  // HM 17/06/04: Added for EntAddNOMUDFLines
                                                      Var GLList          : Variant;
                                                      Var DescList        : Variant;
                                                      Var CurrList        : Variant;
                                                      Var AmtList         : Variant;
                                                      Var RateList        : Variant;
                                                      Var VATCodeList     : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                                      Var IncVATCodeList  : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                                      Var VATAmountList   : Variant;  // HM 02/06/03: Added for EntAddNOMVATLines
                                                      Var CCList          : Variant;
                                                      Var DeptList        : Variant;
                                                      Var JobList         : Variant;
                                                      Var AnalList        : Variant;
                                                      Var PayRefList      : Variant;
                                                      Var ResetJCGL       : String;    // MH 21/04/06: 'Y'/'N'
                                                      Var TLUDF1List      : Variant;
                                                      Var TLUDF2List      : Variant;
                                                      Var TLUDF3List      : Variant;
                                                      Var TLUDF4List      : Variant;
                                                      Var TLUDF5List      : Variant;
                                                      Var TLUDF6List      : Variant;
                                                      Var TLUDF7List      : Variant;
                                                      Var TLUDF8List      : Variant;
                                                      Var TLUDF9List      : Variant;
                                                      Var TLUDF10List     : Variant;
                                                      Const AutoReversing : Boolean) : SmallInt;
Const
  ErrGLList   = 544;
  ErrDescList = 545;
  ErrCurrList = 546;
  ErrAmount   = 547;
  ErrAmtList  = 548;
  ErrNonZero  = 549;
  ErrCostList = 550;
  ErrDeptList = 551;
  ErrJobList  = 552;
  ErrAnalList = 553;
  ErrRate     = 554;
  ErrRateList = 555;
  ErrPayRefList = 556;
  ErrUserFldList = 584;  // Invalid User Fields List

Type
  NomLinesRecType = Record
    nlGL            : LongInt;
    nlDesc          : String[60];
    nlCurr          : SmallInt;
    nlAmount        : Double;
    nlRates         : CurrTypes;
    nlCostC         : String[3];
    nlDept          : String[3];
    nlJobCode       : String[10];
    nlAnalCode      : String[10];

    nmDefCurr       : Byte;
    nmForceJC       : Boolean;     // Force JobCode/AnalysisCode

    // HM 31/07/00: Enhanced Job Costing integration
    nmAnalCOS       : LongInt;     // COS Of Sales GL Code
    nmAnalWIP       : LongInt;     // Work In Progress GL Code

    // HM 02/06/03: Added VAT fields
    nlVATFlag       : Char;
    nlVATCode       : Char;
    nlIncVATCode    : Char;
    nlVATAmount     : Double;
    nlBaseVATAmount : Double;
    nlOrigNet       : Double;

    // PR 30/01/2009
    nlPayRef        : String[10];

    // MH 18/03/2011 v6.4 ABSEXCH-11090: Added TL Udef Fields for Jelf
    nlUser1         : String[30];
    nlUser2         : String[30];
    nlUser3         : String[30];
    nlUser4         : String[30];
    // MH 01/11/2011 v6.9: Extended to 10 UDef Fields
    nlUser5         : String[30];
    nlUser6         : String[30];
    nlUser7         : String[30];
    nlUser8         : String[30];
    nlUser9         : String[30];
    nlUser10        : String[30];
  End; { NomLinesRecType }
  NomLinesRecPtr = ^NomLinesRecType;

Var
  NomLines     : TList;
  NomLineRec   : NomLinesRecPtr;
  NomTHUDFs    : Array [1..10] Of String[30];
  CompObj      : TCompanyInfo;
  I            : LongInt;
  tmpVar       : Variant;

  // Fields for TH details
  NOMTransDate : LongDate;
  NOMVATFlag   : Char;



  Procedure ProcessStringArray (Const StrArray : Variant;
                                Const ProcMode : Byte;
                                Const WantType : Integer;
                                Const ListErr  : SmallInt);
  Var
    I       : LongInt;
    TmpRate : Double;
  Begin { ProcessStringArray }
    If (Result = 0) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        { Process Descriptions }
        If VarIsArray(StrArray) Then Begin
          { Check it is sized correctly }
          If ((VarArrayHighBound(StrArray,1) - VarArrayLowBound(StrArray,1)) = Pred(NomLines.Count)) Then Begin
            For I := VarArrayLowBound(StrArray,1) To VarArrayHighBound(StrArray,1) Do Begin
              tmpVar := StrArray[I];

              If (varType(tmpVar) = WantType) Then Begin
                { Load record from list }
                NomLineRec := NomLinesRecPtr(NomLines.Items[Pred(I)]);

                Case ProcMode Of
                  { Line Descriptions }
                  1 : NomLineRec^.nlDesc := tmpVar;

                  { Line Currency }
                  2 : With NomLineRec^ Do Begin
                        nlCurr := tmpVar;

                        { Validate currency }
                        If IsMultiCcy Then Begin
                          { Multi-Currency - 1..CurrencyType }
                          If (nlCurr < 1) Or (nlCurr > CurrencyType) Then Begin
                            { Invalid Currency }
                            Result := ErrCcy;
                          End; { If }

                          { HM 15/12/99 - v4.31 - Added GL Currency Check }
                          If (nmDefCurr <> 0) And (nlCurr <> 0) And (nmDefCurr <> nlCurr) Then
                            Result := ErrCcy;
                        End { If IsMultiCcy }
                        Else Begin
                          { Single Currency - 0 Only }
                          If (nlCurr <> 0) Then Begin
                            { Invalid Currency }
                            Result := ErrCcy;
                          End; { If }
                        End; { Else }

                        If (Result = 0) Then Begin
                          { Assign default Currency Rates }
                          nlRates := LSyssCurr.Currencies[nlCurr].CRates;
                        End; { If (Result = 0) }
                      End; { 2 - Currency }

                  { Amount }
                  3 : Begin
                        NomLineRec^.nlAmount := Round_Up(tmpVar,2);
                        (* HM 24/07/00: Extended to allow zero amounts
                        { Validate currency }
                        If (NomLineRec^.nlAmount = 0.0) Then Begin
                          { Invalid Amount }
                          Result := ErrAmount;
                        End; { If (NomLineRec^.nlAmount = 0.0) }
                        *)
                      End; { 3 - Amount }

                  { Cost Centre }
                  4 : With NomLineRec^ Do Begin
                        { Check CC/Dept are turned on }
                        If LSyss.UseCCDep Then Begin
                          nlCostC := UpperCase(tmpVar);

                          If GetCCDepRec (CompObj.CompanyBtr, nlCostC, BOn) Then
                            If (LPassword.CostCtrRec.HideAC=1) then   // PL 30/08/2016 R3 ABSEXCH-15689 : Added code to check inactive CC / Dept
                              Result := ErrInactiveCC
                            else
                              nlCostC := LPassword.CostCtrRec.PCostC
                          Else
                            { Invalid Cost Centre }
                            Result := ErrCC;
                        End; { If }
                      End; { 4 - Cost Centre }

                  { Department }
                  5 : With NomLineRec^ Do Begin
                        { Check CC/Dept are turned on }
                        If LSyss.UseCCDep Then Begin
                          nlDept := UpperCase(tmpVar);

                          If GetCCDepRec (CompObj.CompanyBtr, nlDept, BOff) Then
                            If (LPassword.CostCtrRec.HideAC=1) then  // PL 30/08/2016 R3 ABSEXCH-15689 : Added code to check inactive CC / Dept
                              Result := ErrInactiveDept
                            Else
                              nlDept := LPassword.CostCtrRec.PCostC
                          Else
                            { Invalid Department }
                            Result := ErrDept;
                        End; { If }
                      End; { 5 - Department }

                  { Job Code }
                  6 : With NomLineRec^ Do Begin
                        nlJobCode := UpperCase(Trim(tmpVar));

                        If (nlJobCode <> '') Then
                        Begin
                          If GetJobRec (CompObj.CompanyBtr, nlJobCode) Then
                          Begin
                            nlJobCode := LJobRec.JobCode;

                            { Check Job Type }
                            If (LJobRec.JobType <> JobJobCode) Then
                            Begin
                              { Invalid Job Type }
                              Result := ErrJobCode;
                            End // If (LJobRec.JobType <> JobJobCode)
                            Else
                            Begin
                              // MH 21/04/06: Added new versions in XLA which don't Reset the JC GL Codes
                              If (ResetJCGL = 'Y') Then
                              Begin
                                { Check job is not closed }
                                Case LJobRec.JobStat Of
                                  // Quotation, Active, Suspended
                                  1, 2, 3   : nlGL := nmAnalWIP;
                                  // Complete
                                  4         : nlGL := nmAnalCOS;
                                  // Closed
                                  5         : Result := ErrJobClosed;
                                Else
                                  { Unknown }
                                  Result := ErrJobClosed;
                                End; { Case LJobRec.JobStat }
                              End
                              Else
                              //AP:14/07/2017:2017R2:ABSEXCH-17880:OLE not respecting the Job Closed status when Adding Nominal Journals
                              Begin
                                If (LJobRec.JobStat = 5) then
                                  Result := ErrJobClosed;
                              End;// If (ResetJCGL = 'Y')
                            End; // Else
                          End // If GetJobRec (CompObj.CompanyBtr, nlJobCode)
                          Else Begin
                            { Invalid Job Code }
                            Result := ErrJobCode;
                          End; { Else }
                        End // If (nlJobCode <> '')
                        Else
                        Begin
                          // HM 22/10/03: Extended to check the Force JC flag
                          If nmForceJC Then
                          Begin
                            // Job Code must be specified
                            Result := ErrJobCode;
                          End; // Else
                        End; // Else
                      End; { 6 - Job Code }

                  { Analysis Code }
                  7 : With NomLineRec^ Do Begin
                        nlAnalCode := UpperCase(Trim(TmpVar));
                        nmAnalCOS  := 0;
                        nmAnalWIP  := 0;

                        If (nlAnalCode <> '') Then Begin
                          If GetJobMiscRec (CompObj.CompanyBtr, nlAnalCode, 2) Then Begin
                            { Got Analysis Record - cache GL Codes for later }
                            nlAnalCode := LJobMisc.JobAnalRec.JAnalCode;
                            nmAnalCOS  := LJobMisc.JobAnalRec.WIPNom[BOn];
                            nmAnalWIP  := LJobMisc.JobAnalRec.WIPNom[BOff];
                          End { If GetJobMiscRec (CompObj.CompanyBtr, nlAnalCode, 2) }
                          Else
                            { Invalid Job analysis Code }
                            Result := ErrJobAnal;
                        End // If (nlAnalCode <> '')
                        Else
                        Begin
                          // HM 22/10/03: Extended to check the Force JC flag
                          If nmForceJC Then
                          Begin
                            // Analysis Code must be specified
                            Result := ErrJobAnal;
                          End; // Else
                        End; // Else
                      End; { 7 - Job Analysis Code }

                  { Currency Rate }
                  8 : With NomLineRec^ Do Begin
                        TmpRate := Round_Up(TmpVar,6);

                        If UseCoDayRate Then Begin
                          { Daily Rate }
                          If (TmpRate < 0.00) Then Begin
                            { Invalid Rates }
                            Result := ErrRate;
                          End { If }
                          Else Begin
                            { Rates must be > 0 or 0 to use global rates }
                            If (TmpRate > 0.00) Then Begin
                              { Replace global rates with specified rates }
                              nlRates[BOn] := TmpRate;
                            End; { If }
                          End; { Else }
                        End { If }
                        Else Begin
                          { Company Rate }
                          If (TmpRate <> 0.00) Then Begin
                            { Invalid Rates }
                            Result := ErrRate;
                          End; { If (TmpRate <> 0.00) }
                        End; { Else }
                      End; { 8 - line rate }

                  { Line VAT Code }
                  9  : With NomLineRec^ Do
                         // Check VAT is turned on for this Transaction
                         If (NOMVATFlag <> ' ') Then Begin
                           // Extract first character from string
                           nlVATCode := (UpperCase(Trim(TmpVar)) + ' ')[1];

                           // Check to see if VAT is being applied to this line
                           If (nlVATCode <> ' ') Then Begin
                             // Check it is a valid VAT Code
                             If (nlVATCode In (VatSet-['I', 'M'])) Then
                             begin
                               //PL: 20/10/2016 ABSEXCH- 17736 "EntAddNomVATLines" and "EntAddNomVATLines5AR"
                               //should not allow VAT Code "A" and "D" in Exchequer
                               if (nlVATCode IN ['A','D']) then
                               begin
                                 Result := ErrVATCode;
                               end
                               else
                               begin
                                 // Valid VAT Code - not Inclusive VAT - Setup line as Manual VAT
                                 nlVATFlag := 'M';
                               end;
                             end
                             Else
                             Begin
                               If (nlVATCode = 'I') Then
                                 // Inclusive VAT - Setup line as Auto VAT
                                 nlVATFlag := 'A'
                               Else Begin
                                 // Invalid Line VAT Flag
                                 Result := ErrVATCode;
                                 nlVATCode := ' ';
                               End; { If Not (nlVATCode In VatSet) }
                             End; { Else }
                           End { If (nlVATFlag <> ' ') }
                           Else Begin
                             // VAT not turned on on this Line
                             nlVATCode := ' ';
                             nlVATFlag := ' ';
                           End; { Else }
                         End { If (nlVATFlag <> ' ') }
                         Else Begin
                           // VAT not turned on on this Transaction
                           nlVATCode := ' ';
                           nlVATFlag := ' ';
                         End; { Else }

                  { Line Inclusive VAT Code }
                  10 : With NomLineRec^ Do
                         // Check Inclusive VAT is turned on for this line (VatFlag = 'A')
                         If (nlVATFlag = 'A') Then Begin
                           // Extract first character from string
                           nlIncVATCode := (UpperCase(Trim(TmpVar)) + ' ')[1];

                           // Check it is a valid VAT Code and it isn't inclusive itself
                           If (Not (nlIncVATCode In VatSet)) Or (nlIncVatCode In ['I', 'M']) Then Begin
                             // Invalid Line VAT Flag or Inclusive VAT Code
                             Result := ErrVATCode;
                             nlIncVATCode := ' ';
                           End; { If Not (nlVATCode In VatSet) }
                         End { If (NOMVATFlag <> ' ') }
                         Else
                           // VAT not turned on on this line or not Inclusive VAT
                           nlIncVATCode := ' ';

                  { Line VAT Amount }
                  11 : With NomLineRec^ Do
                         // Check VAT is turned on for this line
                         If (nlVATFlag = 'M') Then Begin
                           // Import the passed VAT Amount
                           nlVATAmount := Round_Up(tmpVar,2);

                           // Check the sign is correct
                           If ((nlAmount < 0.0) And (nlVATAmount > 0.0)) Or
                              ((nlAmount > 0.0) And (nlVATAmount < 0.0)) Then
                             // Error - signs must be the same
                             Result := ErrVATAmount;
                         End { If (NOMVATFlag = 'M') }
                         Else
                           // VAT not turned on on this line
                           nlVATAmount := 0.0;

                   12 : NomLineRec^.nlPayRef := tmpVar;

                   // MH 18/03/2011 v6.4 ABSEXCH-11090: Added TL Udef Fields for Jelf
                   13 : NomLineRec^.nlUser1 := Trim(tmpVar);
                   14 : NomLineRec^.nlUser2 := Trim(tmpVar);
                   15 : NomLineRec^.nlUser3 := Trim(tmpVar);
                   16 : NomLineRec^.nlUser4 := Trim(tmpVar);
                   // MH 01/11/2011 v6.9: Extended to 10 UDef Fields
                   17 : NomLineRec^.nlUser5 := Trim(tmpVar);
                   18 : NomLineRec^.nlUser6 := Trim(tmpVar);
                   19 : NomLineRec^.nlUser7 := Trim(tmpVar);
                   20 : NomLineRec^.nlUser8 := Trim(tmpVar);
                   21 : NomLineRec^.nlUser9 := Trim(tmpVar);
                   22 : NomLineRec^.nlUser10 := Trim(tmpVar);
                End; { Case }

                NomLineRec := Nil;
              End { If (varType(tmpVar) = WantType) }
              Else Begin
                { Not a valid String }
                Result := ListErr;
              End; { Else }

              If (Result <> 0) Then Begin
                Break;
              End; { If }
            End; { For I }
          End { If }
          Else Begin
            { Incorrect number of elements }
            Result := ListErr;
          End; { Else }
        End { If }
        Else Begin
          { Not an array }
          Result := ListErr;
        End; { Else }
      End; { With CompObj, CompanyBtr^ }
    End; { If }
  End; { ProcessStringArray }

  //------------------------------

  { Perform Post Load checks }
  Procedure PostLoadChecks;
  Var
    NomLineRec      : NomLinesRecPtr;
    TotVal, LineVal : Double;
    I               : SmallInt;
    VatId           : IDetail;
  Begin { PostLoadChecks }
    If (NomLines.Count > 0) Then Begin
      TotVal := 0.0;

      For I := 0 To Pred(NomLines.Count) Do Begin
        NomLineRec := NomLinesRecPtr(NomLines.Items[I]);

        With CompObj.CompanyBtr^, NomLineRec^ Do Begin
          // Check to see if Inclusive VAT needs to be calculated
          If (nlVatFlag = 'A') Then Begin
            // Inclusive VAT - Calculate VAT Amount using a dummy Id record
            FillChar(VATId, SizeOf(VATId), #0);
            With VATId Do Begin
              IDDocHed := NMT;

              NetValue := nlAmount;
              Currency := nlCurr;

              VATCode := nlVATCode;
              VATIncFlg := nlIncVATCode;

              Qty       := 1.0;
              QtyMul    := 1.0;
              PriceMulX := 1.0;

              CXRate:=nlRates;
              SetTriRec (Currency, UseORate, CurrTriR);
            End; { With VATId }

            // Call CalcVAT in MiscU here
            CalcVAT(VATId, 0.0);

            // Copy updated fields back out again for use later
            nlOrigNet := nlAmount;        // Original pre-CalcVat amount required on transaction line
            nlAmount := VATId.NetValue;   // Should now be less the inclusive VAT
            nlVatAmount := VATId.VAT;     // The Inclusive VAT value
            nlVATCode := 'M';             // Change VAT Code to 'M' to indicate Inclusive VAT has been calculated
          End; { If (nlVatFlag = 'A') }

          // Check to see if any VAT needs to be included in the line total
          If (nlVATFlag <> ' ') And (nlVATAmount <> 0.0) Then Begin
            // Convert VAT Amount to Base Currency for use on header
            nlBaseVatAmount := Round_Up(Conv_TCurr(nlVATAmount,nlRates[UseCoDayRate],nlCurr,0,BOff),2);

            // VAT on line
            LineVal := nlBaseVATAmount
          End { If (nlVATFlag <> ' ') And (nlVATAmount <> 0.0) }
          Else
            LineVal := 0.0;

          { Check Net Total = 0 - not forgetting to convert to base as we go }
          LineVal := LineVal + Round_Up(Conv_TCurr(nlAmount,nlRates[UseCoDayRate],nlCurr,0,BOff),2);
          TotVal := TotVal + LineVal;

          { Check Job+Anal both set or not set }
          If ((nlJobCode <> '') And (nlAnalCode = '')) Or
             ((nlJobCode = '') And (nlAnalCode <> '')) Then Begin
            { Invalid Analysis Code }
            Result := ErrJobAnal;
          End; { If }
        End; { With }

        If (Result <> 0) Then Begin
          Break;
        End; { If (Result <> 0) }
      End; { For }

      If (Result = 0) Then Begin
        { Round total to 2dp - otherwise easy to get problems due to rounding }
        TotVal := Round_Up(TotVal,2);
        If (TotVal <> 0.00) Then Begin
          { Total must be zero OR ELSE! }
          Result := ErrNonZero
        End; { If (TotVal <> 0.00) }
      End; { If (Result = 0) }
    End; { If (NomLines.Count > 0) }
  End; { PostLoadChecks }

  //------------------------------

  { Remove any Zero value lines from NOM to eliminate wastage }
  Procedure KillZeros;
  Var
    NomLineRec : NomLinesRecPtr;
    I          : SmallInt;
  Begin { KillZeros }
    If (NomLines.Count > 0) Then Begin
      I := 0;

      While (I <= Pred(NomLines.Count)) Do Begin
        NomLineRec := NomLinesRecPtr(NomLines.Items[I]);

        // HM 03/06/03: Extended to check VAT Amount so that VAT Only lines are possible
        If (NomLineRec^.nlAmount = 0.0) And (NomLineRec^.nlVATAmount = 0.0) Then Begin
          { Zero Amount - remove line }
          Dispose(NomLineRec);
          NomLines.Delete(I);
        End { If (NomLineRec^.nlAmount = 0.0) }
        Else
          { Non-Zero - keep it }
          Inc (I);
      End; { For }
    End; { If (NomLines.Count > 0) }
  End; { KillZeros }

  //------------------------------

  Function ProcessHeaderUDFs : Integer;
  Var
    I, iLBound, iHBound  : LongInt;
    TmpRate : Double;
  Begin // ProcessHeaderUDFs
    Result := 0;
    FillChar(NomTHUDFs, SizeOf(NomTHUDFs), #0);

    // Check they supplied an array
    If VarIsArray(THUserFieldList) Then
    Begin
      // Work out how big the array is
      iLBound := VarArrayLowBound(THUserFieldList, 1);
      iHBound := VarArrayHighBound(THUserFieldList, 1);
      If (iLBound <= iHBound) Then
      Begin
        For I := iLBound To iHBound Do
        Begin
          // Check it is a string
          If (varType(THUserFieldList[I]) = varOleStr) And (I In [Low(NomTHUDFs)..High(NomTHUDFs)]) Then
          Begin
            NomTHUDFs[I] := THUserFieldList[I];
          End // If (varType(THUserFieldList(I)) = varOleStr) And (I In [Low(NomTHUDFs)..High(NomTHUDFs)])
          Else
          Begin
            Result := ErrUserFieldsList;
            Break;
          End; // Else
        End; // For I
      End; // If (iLBound <= iHBound)
    End // If VarIsArray(THUserFieldList)
    Else
      Result := ErrUserFieldsList;
  End; // ProcessHeaderUDFs

  //------------------------------

  Procedure AddNomTrans;
  Var
    NomLineRec : NomLinesRecPtr;
    TotVal     : Double;
    I          : SmallInt;
  Begin { AddNomTrans }
    If (NomLines.Count > 0) Then Begin
      { Add Transaction Header }
      With CompObj, CompanyBtr^ Do Begin
        LResetRec(InvF);

        With LInv do Begin
          NomAuto:=BOn;

          InvDocHed:=NMT;

          // HM 02/06/03: Added ability to specify transaction date externally in EntAddNOMVATLines
          //TransDate := Today;
          TransDate := NOMTransDate;
          AcPr      := ThePeriod;
          AcYr      := TxlateYrVal(TheYear,BOn);

          // 15/04/99: Default Currency to 1 instead of 0 and set all rates to 1.0
          //Currency     := 1;
          // 24/09/03: Modified on EL's instruction to set to 0 for Pro and 1 for Euro/Global
          If IsMultiCcy Then
            Currency   := 1
          Else
            Currency   := 0;
          CXrate[BOff] := 1;
          CXrate[BOn]  := 1;
          VATCRate     := CXrate;
          OrigRates    := CXrate;

          { HM 15/12/99 - v4.31 }
          SetTriRec (0,            UseORate, CurrTriR);  { Note: EL Said to use 0 }
          SetTriRec (Syss.VATCurr, UseORate, VATTriR);
          SetTriRec (0,            UseORate, OrigTriR);

          TransDesc := TranDesc;

          // MH 13/04/06: Corrected NEXT line number field
          //ILineCount := NomLines.Count;
          ILineCount := NomLines.Count + 1;

          // Check to see if the VAT Totals need to be updated
          If (NOMVATFlag <> ' ') Then Begin
            // Set the Header NOM VAT I/O flag - converting from the Excel User Interface values
            Case NOMVATFlag Of
              ' '      : NOMVatIO := #0;
              'I', 'O' : NOMVatIO := NOMVATFlag;
            Else
              // Unhandled Value - raise exception to stop transaction being stored and ensure the error is noticed
              Raise Exception.Create ('TEnterpriseServer.AddNomLines.AddNomTrans: Unknown NOMVATFlag value ' + QuotedStr(NOMVATFlag));
            End; { Case NOMVATFlag }

            // Run through the lines updating the VAT Totals on the header
            For I := 0 To Pred(NomLines.Count) Do Begin
              NomLineRec := NomLinesRecPtr(NomLines.Items[I]);

              With NomLineRec^ Do
                // Check whether the line has a VAT implication
                If (nlVATFlag <> ' ') Then Begin
                  // Update Total VAT with Base equiv of Line VAT
                  InvVAT := InvVAT + nlBaseVATAmount;

                  // Update the VAT Analysis array with Base equiv of Line VAT
                  InvVatAnal[GetVATNo(nlVATcode, nlIncVATCode)] := InvVatAnal[GetVAtNo(nlVATcode, nlIncVATCode)] +
                                                                   nlBaseVATAmount;
                End; { If (nlVATFlag <> ' ') }
            End; { For I }
          End; { If (NOMVATFlag <> ' ') }

          // MH 01/11/2011 v6.9: Extended to support 10 Header UDef Fields
          DocUser1 := NomTHUDFs[1];
          DocUser2 := NomTHUDFs[2];
          DocUser3 := NomTHUDFs[3];
          DocUser4 := NomTHUDFs[4];
          DocUser5 := NomTHUDFs[5];
          DocUser6 := NomTHUDFs[6];
          DocUser7 := NomTHUDFs[7];
          DocUser8 := NomTHUDFs[8];
          DocUser9 := NomTHUDFs[9];
          DocUser10 := NomTHUDFs[10];

          // MH 28/10/2013 v7.0.7 ABSEXCH-14705: Added Transaction Originator fields
          SetOriginator(LInv);

          // MH 09/10/2014 v7.0.12 ABSEXCH-15632: Added Auto-Reversing Support to AddNOMLines
          UnTagged := AutoReversing;

          LSetNextDocNos(LInv,BOn);

          LStatus:=LAdd_Rec(InvF, InvRNoK);

          //GS 31/10/2011 Add Audit History Notes for v6.9
          if LStatus = 0 then
          begin
            WriteAuditNote(anTransaction, anCreate, CompObj);
          end;
        End; { With }

        If (LStatus = 0) Then Begin
          For I := 0 To Pred(NomLines.Count) Do Begin
            NomLineRec := NomLinesRecPtr(NomLines.Items[I]);

            With NomLineRec^ Do Begin
              LResetRec(IDetailF);

              With LId do Begin
                DocPRef := LInv.OurRef;
                FolioRef:=LInv.FolioNum;
                LineNo:=RecieptCode;
                AbsLineNo := Succ(I);

                Desc := nlDesc;

                NomCode := nlGL;
                NetValue := nlAmount;
                Currency:=nlCurr;

                Qty:=1;
                QtyMul := 1.0;            { HM 15/12/99 - v4.31 }
                PriceMulX := 1.0;         { HM 15/12/99 - v4.31 }

                CXRate:=nlRates;
                SetTriRec (Currency, UseORate, CurrTriR);  { HM 15/12/99 - v4.31 }

                PYr:=LInv.ACYr;
                PPr:=LInv.AcPr;

                Payment:=SetRPayment(LInv.InvDocHed);

                If (LSyss.AutoClearPay) then
                  Reconcile:=ReconC;

                IDDocHed:=LInv.InvDocHed;

                PDate:=LInv.TransDate;

                If CompObj.CompanyBtr.LSyss.UseCCDep Then Begin
                  CCDep[BOn]  := FullCCDepKey(nlCostC);
                  CCDep[BOff] := FullCCDepKey(nlDept);
                End; { If }

                JobCode  := FullJobCode(nlJobCode);
                AnalCode := FullJACode(nlAnalCode);

                // Check to see if the VAT fields need to be set
                If (NOMVATFlag <> ' ') And (nlVATFlag <> ' ') Then Begin
                  Case nlVATFlag Of
                    ' ' : NOMIOFlg := 0;
                    'A' : NOMIOFlg := 1;
                    'M' : NOMIOFlg := 2;
                  Else
                    // Unhandled Value - raise exception to stop transaction being stored and ensure the error is noticed
                    Raise Exception.Create ('TEnterpriseServer.AddNomLines.AddNomTrans: Unknown nlVATFlag value ' + QuotedStr(nlVATFlag));
                  End; { Case nlVATFlag }
                  VATCode     := nlVATCode;
                  VATIncFlg   := nlIncVATCode;
                  VAT         := nlVATAmount;
                  IncNetValue := nlOrigNet;
                End; { If (NOMVATFlag <> ' ') And (nlVATFlag <> ' ') }

                //PR: 30/01/2009 Added PayInref
                if not (VArIsNull(PayRefList) or VarIsEmpty(PayRefList))then
                  StockCode := Pre_PostPayInKey(PayInCode, nlPayRef);

                // MH 18/03/2011 v6.4 ABSEXCH-11090: Added TL Udef Fields for Jelf
                LineUser1 := NomLineRec^.nlUser1;
                LineUser2 := NomLineRec^.nlUser2;
                LineUser3 := NomLineRec^.nlUser3;
                LineUser4 := NomLineRec^.nlUser4;
                // MH 01/11/2011 v6.9: Extended to 10 UDef Fields
                LineUser5 := NomLineRec^.nlUser5;
                LineUser6 := NomLineRec^.nlUser6;
                LineUser7 := NomLineRec^.nlUser7;
                LineUser8 := NomLineRec^.nlUser8;
                LineUser9 := NomLineRec^.nlUser9;
                LineUser10 := NomLineRec^.nlUser10;
              End; { With }

              LStatus := LAdd_Rec(IDetailF, IdFolioK);

              If (LStatus = 0) Then
                { HM 17/06/99: Added to update Job Costing }
                LUpdate_JobAct(LId, LInv);
            End; { With NomLineRec^ }
          End; { For }
        End; { If (LStatus = 0) }
      End; { If (NomLines.Count > 0) }
    End; { With CompObj.CompanyBtr^ }
  End; { AddNomTrans }

Begin { AddNomLines }
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then
  Begin
    // SSK 30/08/2016 R3 ABSEXCH-12531 : Added condition to validate period
    If ValidatePeriod(ThePeriod, CompObj)  Then {Check Period against System Setup Period}
    Begin
      If CompObj.CheckSecurity (488) Then
      Begin
        With CompObj, CompanyBtr^ Do
        Begin
          // HM 02/06/03: Validate optional Transaction Date
          If (Trim(TransDate) <> '') Then Begin
            Try
              // Exception will be raised if date isn't understandable
              NOMTransDate := FormatDatetime ('YYYYMMDD', StrToDate(TransDate));
            Except
              On Exception Do
                Result := ErrDate;
            End;
          End { If }
          Else
            // No date specified - use today
            NOMTransDate := Today;

          // HM 02/06/03: Validate VAT Fields for Header
          If (Result = 0) Then Begin
            // No idea what to do with VATCountry yet - for future use
            //Var VATCountry : String;

            // // Check the VAT I/O Flag for the Header
            NOMVATFlag := (UpperCase(Trim(VATFlag)) + ' ')[1];
            If (Not (NomVATFlag In [' ', 'I', 'O'])) Then
              // Invalid Header VAT Flag
              Result := ErrHeaderVATFlag;
          End; { If (Result = 0) }

          // MH 01/11/2011 v6.9: Extended to support 10 Header UDef Fields
          If (Result = 0) Then
          Begin
            Result := ProcessHeaderUDFs
          End; // If (Result = 0)

          If (Result = 0) Then Begin
            NomLines := TList.Create;
            Try
              { Process GL Codes list creating array as necessary }
              If VarIsArray(GLList) Then Begin
                For I := VarArrayLowBound(GLList,1) To VarArrayHighBound(GLList,1) Do Begin
                  tmpVar := GLList[I];

                  If (varType(tmpVar) = varInteger) Then Begin
                    New (NomLineRec);
                    FillChar (NomLineRec^, SizeOf(NomLineRec^), #0);
                    With NomLineRec^ Do Begin
                      nlGL := tmpVar;

                      { Get GL Code record }
                      If GetNominalRec (CompanyBtr, nlGL) Then Begin
                        { Check it is a valid type and not inactive }
                        If (LNom.NomType In [CtrlNHCode, CarryFlg, NomHedCode]) Or (LNom.HideAC = 1) Then
                          Result := errNom
                        Else
                        Begin
                          nmDefCurr := LNom.DefCurr;
                          nmForceJC := LNom.ForceJC;
                        End; // Else
                      End { If GetNominalRec (CompanyBtr, nlGL) }
                      Else Begin
                        { Invalid GL Code }
                        Result := errNom;
                      End; { Else }
                    End; { With NomLineRec }

                    If (Result = 0) Then Begin
                      NomLines.Add(NomLineRec);
                    End; { If }
                  End { If (varType(tmpVar) = varInteger) }
                  Else Begin
                    { Not a valid integer }
                    Result := 511;
                  End; { Else }

                  If (Result <> 0) Then Begin
                    Break;
                  End; { If }
                End; { For I }

                If (Result = 0) And (NomLines.Count < 2) Then Begin
                  { Not enough lines }
                  Result := ErrGLList;
                End; { If }
              End { If }
              Else Begin
                Result := ErrGLList;
              End; { Else }

              ProcessStringArray (DescList, 1, varOleStr,   ErrDescList);
              ProcessStringArray (CurrList, 2, varSmallInt, ErrCurrList);
              ProcessStringArray (AmtList,  3, varDouble,   ErrAmtList);
              ProcessStringArray (RateList, 8, varDouble,   ErrRateList);
              ProcessStringArray (CCList,   4, varOleStr,   ErrCostList);
              ProcessStringArray (DeptList, 5, varOleStr,   ErrDeptList);
              ProcessStringArray (AnalList, 7, varOleStr,   ErrAnalList);
              ProcessStringArray (JobList,  6, varOleStr,   ErrJobList);

              // HM 02/06/03: Added processing of VAT Lists for EntAddNOMVATLines
              If (NomVATFlag In ['I', 'O']) Then Begin
                // NOM is specified as including VAT - process the VAT columns

                // VAT Code
                ProcessStringArray (VATCodeList, 9, varOleStr, ErrVATCodeList);

                // Inclusive VAT Code
                ProcessStringArray (IncVATCodeList, 10, varOleStr, ErrIncVATCodeList);

                // VAT Amount
                ProcessStringArray (VATAmountList, 11, varDouble, ErrVATAmountList);
              End; { If (NomVATFlag In ['I', 'O'])) }

              //PR: 30/01/2009 Added PayInref
              if not (VArIsNull(PayRefList) or VarIsEmpty(PayRefList))then
                ProcessStringArray (PayRefList,  12, varOleStr,   ErrPayRefList);

              // MH 18/03/2011 v6.4 ABSEXCH-11090: Added TL Udef Fields for Jelf
              ProcessStringArray (TLUDF1List,  13, varOleStr,   ErrUserFldList);
              ProcessStringArray (TLUDF2List,  14, varOleStr,   ErrUserFldList);
              ProcessStringArray (TLUDF3List,  15, varOleStr,   ErrUserFldList);
              ProcessStringArray (TLUDF4List,  16, varOleStr,   ErrUserFldList);
              // MH 01/11/2011 v6.9: Extended to 10 UDef Fields
              ProcessStringArray (TLUDF5List,  17, varOleStr,   ErrUserFldList);
              ProcessStringArray (TLUDF6List,  18, varOleStr,   ErrUserFldList);
              ProcessStringArray (TLUDF7List,  19, varOleStr,   ErrUserFldList);
              ProcessStringArray (TLUDF8List,  20, varOleStr,   ErrUserFldList);
              ProcessStringArray (TLUDF9List,  21, varOleStr,   ErrUserFldList);
              ProcessStringArray (TLUDF10List, 22, varOleStr,   ErrUserFldList);

              If (Result = 0) Then
                { Filter out any Zero Amount lines }
                KillZeros;

              If (Result = 0) Then Begin
                { Do post load checks }
                PostLoadChecks;
              End; { If }

              If (Result = 0) Then Begin
                { Add the git }
                AddNomTrans;
              End; { If }
            Finally
              { De-allocate records and destroy list }
              While (NomLines.Count > 0) Do Begin
                NomLineRec := NomLinesRecPtr(NomLines.Items[0]);
                Dispose(NomLineRec);
                NomLines.Delete(0);
              End; { While (NomLines.Count > 0) }

              NomLines.Destroy;
            End;
          End; { If (Result = 0) }
        End; { With CompObj, CompanyBtr }
      End // If CompObj.CheckSecurity (488)
      Else
        Result := ErrPermit;
    End { If ValidatePeriod }
    Else
      Result := ErrPeriod;
  End; { If (Result = 0) }
End; { AddNomLines }


{----------------------------------------------------------------------------}


{*************************************************************************}
{* GetAltStkMiscStr: Returns a string value from the specified stock     *}
{*                   record. The value returned is specified using the   *}
{*                   MiscStrNo parameter, values are:                    *}
{*                                                                       *}
{*                   1  : Description                                    *}
{*************************************************************************}
Function TEnterpriseServer.GetAltStkMiscStr (Var Company   : String;
                                             Var StockId   : String;
                                             Var AltId     : String;
                                             Var AccId     : String;
                                             Var MiscFldNo : SmallInt;
                                             Var MiscStr   : String;
                                             Var MiscInt   : SmallInt;
                                             Var MiscDub   : Double) : SmallInt;
Var
  CompObj  : TCompanyInfo;
  KeyS     : Str255;
Begin
  Result := 0;
  MiscStr := '';
  MiscInt := 0;
  MiscDub := 0.0;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (493{108}) Then Begin
      { Get Stock Record }
      If GetStockRec (CompObj.CompanyBtr, StockId) Then Begin
        { Check for account code }
        AccId := Trim(AccId);
        If (AccId <> '') Then Begin
          { Code set - check it is valid }
          If GetCustRec (CompObj.CompanyBtr, AccId, False) Then Begin
            { Reset Account Code }
            AccId := CompObj.CompanyBtr^.LCust.CustCode;
          End { If }
          Else Begin
            { Invalid Account Code }
            Result := ErrAccCode;
            AccId := '';
          End; { If }
        End; { If }

        If (Result = 0) Then Begin
          With CompObj, CompanyBtr^ Do Begin
            If GetAltStkRec (CompObj.CompanyBtr, LStock.StockFolio, AltId, AccId) Then Begin
              Case MiscFldNo Of
                1  : Begin
                       MiscStr := LMAltCode^.SdbStkRec.sdDesc;
                     End;
                2  : Begin
                       MiscInt := LMAltCode^.SdbStkRec.sdROCurrency;
                     End;
                3  : Begin
                       MiscDub := LMAltCode^.SdbStkRec.sdRoPrice;
                     End;
              End { Case }
            End { If }
            Else
              { Invalid Alternate Code }
              Result := ErrAltCode;
          End; { With }
        End; { If }
      End { If }
      Else
        { Invalid Stock Code }
        Result := ErrStock;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End;


{**********************************************************************}
{* SaveAltStkFld: Returns a string value from the specified stock     *}
{*                record. The value returned is specified using the   *}
{*                MiscStrNo parameter, values are:                    *}
{*                                                                    *}
{*                   1  : Description                                 *}
{**********************************************************************}
Function TEnterpriseServer.SaveAltStkFld (Var Company   : String;
                                          Var StockId   : String;
                                          Var AltId     : String;
                                          Var AccId     : String;
                                          Var MiscFldNo : SmallInt;
                                          Var MiscStr   : String;
                                          Var MiscInt   : SmallInt;
                                          Var MiscDub   : Double) : SmallInt;
Const
  FNum  = MLocF;
  KPath = 2;
Var
  KeyR, KeyS      : Str255;
  RecAddr, L1     : LongInt;
  CompObj         : TCompanyInfo;
Begin
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then Begin
    If CompObj.CheckSecurity (493{108}) Then Begin
      { Get Stock Record }
      If GetStockRec (CompObj.CompanyBtr, StockId) Then Begin
        { Check for account code }
        AccId := Trim(AccId);
        If (AccId <> '') Then Begin
          { Code set - check it is valid }
          If GetCustRec (CompObj.CompanyBtr, AccId, False) Then Begin
            { Reset Account Code }
            AccId := CompObj.CompanyBtr^.LCust.CustCode;
          End { If }
          Else Begin
            { Invalid Account Code }
            Result := ErrAccCode;
            AccId := '';
          End; { If }
        End; { If }

        If (Result = 0) Then Begin
          With CompObj, CompanyBtr^ Do Begin
            If GetAltStkRec (CompObj.CompanyBtr, LStock.StockFolio, AltId, AccId) Then Begin
              { Now get and lock the Alt Stock record }
              KeyS := PartCCKey(NoteTCode,NoteCCode) + FullNomKey(LMAltCode^.SdbStkRec.sdFolio) + FullNomKey(LStock.StockFolio);
              KeyR := KeyS;
              L1 := LMAltCode^.SdbStkRec.sdFolio;

              LStatus:=LFind_Rec(B_GetGEq,FNum,KPath,KeyS);

              { HM 26/01/99: Checkkey don't work as fullnomkey ends idx string }
              {If LStatusOk And CheckKey(KeyR,KeyS,10,BOn) Then Begin}
              If LStatusOk And (L1 = LMLocCtrl^.SdbStkRec.sdFolio) And
                               (LStock.StockFolio = LMLocCtrl^.SdbStkRec.sdStkFolio) Then Begin
                { found - get rec and update }
                GLobLocked:=BOff;
                Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked);
                LGetRecAddr(FNum);

                If OK And GlobLocked Then Begin
                  With LMLocCtrl^, SdbStkRec Do Begin
                    Case MiscFldNo Of
                      1  : Begin
                             sdDesc := MiscStr;
                           End;
                      2  : If sdOverRO Then Begin
                             sdROCurrency := MiscInt;
                           End { If }
                           Else Begin
                             { Can't set R/O details as doesn#t have own price }
                             Result := ErrNoROPrice;
                           End;
                      3  : If sdOverRO Then Begin
                             sdRoPrice := MiscDub;
                           End { If }
                           Else Begin
                             { Can't set R/O details as doesn#t have own price }
                             Result := ErrNoROPrice;
                           End;
                    End; { Case }
                  End; { With }

                  If (Result = 0) Then Begin
                    LMLocCtrl^.SdbStkRec.sdLastUsed := Today;
                    LMLocCtrl^.SdbStkRec.sdLastTime := TimeNowStr;

                    { update record }
                    LStatus := LPut_Rec (Fnum, KPath);

                    //GS 31/10/2011 Add Audit History Notes for v6.9
                    if LStatus = 0 then
                    begin
                      WriteAuditNote(anStock, anEdit, CompObj);
                    end;

                  End; { If }

                  { Unlock record}
                  LUnlockMLock(FNum);

                  If (Result = 0) Then Begin
                    If (LStatus = 0) Then
                      Result := 0
                    Else
                      Result := ErrBtrBase + LStatus;
                  End; { If }
                End { If }
                Else
                  Result := ErrRecLock;
              End { If }
              Else
                { Invalid Alternate Code }
                Result := ErrAltCode;
            End { If }
            Else
              { Invalid Alternate Code }
              Result := ErrAltCode;
          End; { With }
        End; { If }
      End { If }
      Else
        { Invalid Stock Code }
        Result := ErrStock;
    End { If }
    Else
      Result := ErrPermit;
  End; { If (Result = 0) }
End;


{ Function to allow the setting of the UserId and Password through EntFuncs.DLL }
{ to allow access to history without login dialog                               }
Function TEnterpriseServer.PrimeLoginDets (Var UserId   : String;
                                           Var PassWord : String) : SmallInt;
Begin { PrimeLoginDets }
  Result := 0;

  Try
    { Set to checking user Id's }
    SkipLogon := False;

    { Set Default Details - correctly padded out }
    BtrList.BaseUser^.Login := LJVar(UserId,LoginKeyLen);

    // HM 11/04/00: Modified as PWord sometime padded, sometime not
    //BtrList.BaseUser^.Pword := EnCode(LJVar(Password,8));
    BtrList.BaseUser^.Pword := Trim(UpperCase(Password));
  Except
    On Ex:Exception Do
      Result := 1000;
  End; { Try..Except }
End; { PrimeLoginDets }


{ Save it }
Function TEnterpriseServer.SaveJobMiscStr (Var Company   : String;
                                           Var JobCode   : String;
                                           Var MiscStrNo : SmallInt;
                                           Var NewStr    : String) : SmallInt;
Const
  FNum  = JobF;
  KPath = JobCodeK;
Var
  TmpCust          : ^CustRec;
  KeyR, KeyS, KeyT : Str255;
  RecAddr          : LongInt;
  CompObj          : TCompanyInfo;
  AcErr            : SmallInt;
Begin
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then Begin
    If CompObj.CheckSecurity (516{206}) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        KeyS := FullJobCode(JobCode);
        KeyR := KeyS;

        LStatus:=LFind_Rec(B_GetGEq,FNum,KPath,KeyS);

        If LStatusOk And CheckKey(KeyR,KeyS,Length(KeyR),BOn) Then Begin
          { found - get rec and update }
          GLobLocked:=BOff;
          Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked);
          LGetRecAddr(FNum);

          If OK And GlobLocked Then Begin
            Case MiscStrNo Of
              { Name/Description }
              1  : LJobRec.JobDesc := NewStr;

              // HM 23/05/03: Added Save Job Manager's name
              6  : LJobRec.JobMan  := NewStr;

              7  : Begin { Start Date }
                     { Check before End and Revised End-Date if set }
                     LJobRec.StartDate := NewStr;
                   End;
              8  : Begin { End Date }
                     { Check after Start Date! }
                     If (NewStr >= LJobRec.StartDate) Then
                       LJobRec.EndDate := NewStr
                     Else
                       Result := ErrEndDate;
                   End;
              9  : Begin { Revised End Date }
                     { Check after Start Date! }
                     If (NewStr >= LJobRec.StartDate) Then
                       LJobRec.RevEDate := NewStr
                     Else
                       Result := ErrRevDate;
                   End;
              11 : LJobRec.UserDef1 := NewStr;         { User def 1 string }
              12 : LJobRec.UserDef2 := NewStr;         { User def 2 string }
              13 : LJobRec.UserDef3 := NewStr;         { User def 3}
              14 : LJobRec.UserDef4 := NewStr;         { User def 4}

              // MH 19/04/06: Added QS Code for Wish 20050408172159
              15 : LJobRec.JQSCode := NewStr;

              // MH 28/10/2011 v6.9: Added support for udefs 5-10
              16 : LJobRec.UserDef5 := NewStr;
              17 : LJobRec.UserDef6 := NewStr;
              18 : LJobRec.UserDef7 := NewStr;
              19 : LJobRec.UserDef8 := NewStr;
              20 : LJobRec.UserDef9 := NewStr;
              21 : LJobRec.UserDef10 := NewStr;
            End; { Case }

            If (Result = 0) Then Begin
              { update record }
              LStatus := LPut_Rec (Fnum, KPath);

              // MH 20/08/2013 v7.0.6 ABSEXCH-14534: Added caching on Job Codes
              If (LStatus = 0) Then
              Begin
                // Update the cache of Analysis Code details to include the changes
                CompObj.JobCodeCache.UpdateCache (CompObj.CompanyBtr^.LJobRec^.JobCode, @CompObj.CompanyBtr^.LJobRec^, SizeOf(JobRecType));
              End; // If (LStatus = 0)

              //GS 31/10/2011 Add Audit History Notes for v6.9
              // MH 22/11/2011 v6.9 ABSEXCH-12193: Fixed typo where anStock was being passed so the notes weren't being written
              if LStatus = 0 then
              begin
                WriteAuditNote(anJob, anEdit, CompObj);
              end;

            End; { If }

            { Unlock record}
            LUnlockMLock(FNum);

            If (Result = 0) Then Begin
              If (LStatus = 0) Then
                Result := 0
              Else
                Result := ErrBtrBase + LStatus;
            End; { If (Result = 0) }
          End { If OK And GlobLocked }
          Else
            Result := ErrRecLock;
        End { If LStatusOk And CheckKey... }
        Else
          Result := ErrJobCode;
      End; { With CompObj, CompanyBtr^ }
    End { If CompObj.CheckSecurity (206) }
    Else
      Result := ErrPermit
  End; { If (Result = 0) }
End;


{************************************************************************}
{* GetNomAltCode: Returns the Alternate Code of the passed nominal code *}
{*                in the specified companies data.                      *}
{************************************************************************}
Function TEnterpriseServer.GetNomAltCode(Var Company : String;
                                         Var NomCode : LongInt;
                                         Var AltCode : String) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin
  Result := 0;
  AltCode := '';

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then
  Begin
    If CompObj.CheckSecurity (487) Then
    Begin
      { Get Nominal Record }
      If GetNominalRec (CompObj.CompanyBtr, NomCode) Then
        AltCode := CompObj.CompanyBtr.LNom.AltCode
      Else
        Result := ErrNom;
    End // If CompObj.CheckSecurity (487{20})
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End;


{***********************************************************************}
{* SaveGLMiscStr: Saves a string value to the specified GL Code record *}
{*                The value updated is specified using the MiscStrNo   *}
{*                parameter, values are:                               *}
{*                                                                     *}
{*                   1  : Alternate Code                               *}
{***********************************************************************}
Function TEnterpriseServer.SaveGLMiscStr (Var Company   : String;
                                          Var NomCode   : LongInt;
                                          Var MiscStrNo : SmallInt;
                                          Var NewStr    : String) : SmallInt;
Const
  FNum  = NomF;
  KPath = NomCodeK;
Var
  KeyS     : Str255;
  RecAddr  : LongInt;
  CompObj  : TCompanyInfo;
Begin { SaveGLMiscStr }
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then Begin
    If CompObj.CheckSecurity (487{20}) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        KeyS := FullNomKey(NomCode);

        LStatus:=LFind_Rec(B_GetGEq,FNum,KPath,KeyS);

        If LStatusOk And (LNom.NomCode = NomCode) Then Begin
          { found - get rec and update }
          GLobLocked:=BOff;
          Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked);
          LGetRecAddr(FNum);

          If OK And GlobLocked Then Begin
            With LNom Do
              Case MiscStrNo Of
                1  : AltCode := UpcaseStr(LJVar(NewStr,Pred(SizeOf(AltCode))));

              End; { Case }

            { Check validation results }
            If (Result = 0) Then Begin
              { update record }
              LStatus := LPut_Rec (Fnum, KPath);
            End; { If }

            { Unlock record}
            LUnlockMLock(FNum);

            If (Result = 0) Then Begin
              If (LStatus = 0) Then
                Result := 0
              Else
                Result := ErrBtrBase + LStatus;
            End; { If }
          End { If }
          Else
            Result := ErrRecLock;
        End { If }
        Else
          Result := ErrNom;
      End { With }
    End { If }
    Else
      Result := ErrPermit
  End; { If (Result = 0) }
End; { SaveGLMiscStr }

//-----------------------------------------------------------------------------

// Creates a multi-line Timesheet and returns and error description
//
// ValidMode: Bit field - 0 = No Effect,
//                        1 = Enforce Time Rate for Job,
//                        2 = ?
//                        4 = ?
//                        8 = ?
//
Function TEnterpriseServer.AddTSHLinesErrorDesc (Const Company        : String;
                                                 Const EmployeeCode   : String;
                                                 Const TSHDesc        : String;
                                                 Const TransDate      : String;
                                                 Const TheYear        : SmallInt;
                                                 Const ThePeriod      : SmallInt;
                                                 Const TSHWeekNo      : SmallInt;
                                                 Var   THUDFields     : Variant;
                                                 Var   JobCodeList    : Variant;
                                                 Var   RateCodeList   : Variant;
                                                 Var   AnalCodeList   : Variant;
                                                 Var   CCList         : Variant;
                                                 Var   DeptList       : Variant;
                                                 Var   HoursList      : Variant;
                                                 Var   NarrativeList  : Variant;
                                                 Var   ChargeRateList : Variant;
                                                 Var   CostCcyList    : Variant;
                                                 Var   HourlyCostList : Variant;
                                                 Var   TLUDField1     : Variant;
                                                 Var   TLUDField2     : Variant;
                                                 Var   TLUDField3     : Variant;
                                                 Var   TLUDField4     : Variant;
                                                 Var   TLUDField5     : Variant;
                                                 Var   TLUDField6     : Variant;
                                                 Var   TLUDField7     : Variant;
                                                 Var   TLUDField8     : Variant;
                                                 Var   TLUDField9     : Variant;
                                                 Var   TLUDField10    : Variant;
                                                 Const ValidMode      : SmallInt;
                                                 Var   ErrorDesc      : String) : SmallInt;
Type
  TSHLinesRecType = Record
    // Line fields
    tsJobCode      : String[JobKeyLen];
    tsRateCode     : String[JobKeyLen];
    tsAnalCode     : String[AnalKeyLen];
    tsCostCentre   : String[CCKeyLen];
    tsDepartment   : String[CCKeyLen];
    tsHours        : Double;
    tsNarrative    : String[30];
    tsChargeAmt    : Double;
    tsCostAmt      : Double;
    tsCostCcy      : SmallInt;

    // Defaulted Fields
    tsChargeCcy    : SmallInt;

    // Optional Defaults
    tsDefAnalCode  : String[AnalKeyLen];
    tsDefNarrative : String[30];
    tsDefChargeAmt : Double;

    // Default Cost details
    tsDefCostAmt    : Double;
    tsDefCostCcy    : SmallInt;
    tsCostDefaulted : Boolean;

    // User Defined Fields
    tsUDF1          : String[30];
    tsUDF2          : String[30];
    // MH 01/11/2011 v6.9: Extended to 10 UDef Fields
    tsUDF3          : String[30];
    tsUDF4          : String[30];
    tsUDF5          : String[30];
    tsUDF6          : String[30];
    tsUDF7          : String[30];
    tsUDF8          : String[30];
    tsUDF9          : String[30];
    tsUDF10         : String[30];

    // MH 02/08/06: Added field for Time-Rate Job Code for Noble Denton (ValidMode 1) so that
    // we can enforce Time-Rates for Jobs only
    tsTimeRateJob   : String[JobKeyLen];
  End; { TSHLinesRecType }
  TSHLinesRecPtr = ^TSHLinesRecType;

Var
  TSHLines   : TList;
  TSHLineRec : TSHLinesRecPtr;
  CompObj    : TCompanyInfo;
  I          : LongInt;
  tmpVar     : Variant;
  lEmployee  : EmplType;
  lUDFields  : Array [1..10] Of String[30];
  lTransDate : LongDate;

  //---------------------------------------------------------

  Procedure ProcessTSHArray (Const TSHArray : Variant;
                             Const ProcMode : Byte;
                             Const WantType : Integer;
                             Const ListErr  : SmallInt);
  Var
    I, Res  : LongInt;
    TmpRate : Double;

    //-------------------------------------------------------------------

    // Find the specified Employee or Global Time-Rate
    //
    // MH 15/04/04: Extended to handle Job Pay Rates and the new switch
    // on the employee record to control how rates are looked up
    Function GetEmpTimeRate (Var LineRec : TSHLinesRecType) : Boolean;
    Const
      // NOTE: Can't use an enumeration and Array of xxx as that causes an Internal
      //       Error 1030 within the compiler as it can't handle the locally declared
      //       enumeration.
      rstGlobal = 0;
      rstOwn    = 1;
      rstJob    = 2;
    Var
      RateSearch      : Array Of Byte;
      lStatus, iArray : SmallInt;
      KeyS, KeyChk    : Str255;
      bFoundJobRate   : Boolean;
      sNextJob        : String[JobKeyLen];

      // Loads the local dynamic array with the search order instructions for
      // finding the payrate
      Procedure ArrayBuilder (TheArray : Array Of Byte);
      Var
        iArray : SmallInt;
      Begin
        SetLength(RateSearch, High(TheArray)+1);
        For iArray := 0 To High(TheArray) Do
        Begin
          RateSearch[iArray] := TheArray[iArray];
        End; // For iArray
      End;

    Begin { GetEmpTimeRate }
      Result := False;

      With CompObj, CompanyBtr^ Do
      Begin
        // Load the local dynamic array with the search order instructions for
        // finding the payrate
        Case lEmployee.UseORate Of
          0 : ArrayBuilder ([rstOwn, rstJob, rstGlobal]);
          1 : ArrayBuilder ([rstOwn]);
          2 : ArrayBuilder ([rstJob, rstOwn, rstGlobal]);
          3 : ArrayBuilder ([rstJob]);
        End; // Case lEmployee.UseORate

        // Run through the dynamic array searching as instructed for the payrate
        For iArray := 0 To High(RateSearch) Do
        Begin
          Case RateSearch[iArray] Of
            rstGlobal : Begin
                          // Search for a matching Global Time-Rate
                          KeyS := PartCCKey(JBRCode, JBECode) + FullJBCode(FullNomKey(-1), 0, LineRec.tsRateCode);
                          lStatus := LFind_Rec(B_GetGEq, JCtrlF, JCK, KeyS);
                          While (lStatus = 0) And (LJobCtrl^.RecPfix = JBRCode) And (LJobCtrl^.SubType = JBECode) And
                                (LJobCtrl^.EmplPay.EmpCode = FullNomKey(-1)) And (Not Result) Do Begin
                            // Check for desired Rate Code
                            Result := (LJobCtrl^.EmplPay.EStockCode = LineRec.tsRateCode);

                            If (Not Result) Then
                              lStatus := LFind_Rec(B_GetNext, JCtrlF, JCK, KeyS);
                          End; { While }
                        End; // rstGlobal
            rstOwn    : Begin
                          // Search for an Employee specific Time-Rate first
                          KeyS := PartCCKey(JBRCode, JBPCode) + FullJBCode(LJVar(lEmployee.EmpCode,6), 0, LineRec.tsRateCode);
                          lStatus := LFind_Rec(B_GetGEq, JCtrlF, JCK, KeyS);
                          While (lStatus = 0) And (LJobCtrl^.RecPfix = JBRCode) And (LJobCtrl^.SubType = JBPCode) And
                                (LJobCtrl^.EmplPay.EmpCode = lEmployee.EmpCode) And (Not Result) Do Begin
                            // Check for desired Rate Code
                            Result := (LJobCtrl^.EmplPay.EStockCode = LineRec.tsRateCode);

                            If (Not Result) Then
                              lStatus := LFind_Rec(B_GetNext, JCtrlF, JCK, KeyS);
                          End; { While }
                        End; // rstOwn
            rstJob    : Begin
                          // Search the Job Tree from the Line Job upwards for the Pay Rates
                          sNextJob := LineRec.tsJobCode;
                          Repeat
                            If GetJobRec (CompanyBtr, sNextJob) Then
                            Begin
                              // Look for any payrate against the job - seems a bit strange - shouldn't
                              // we look for the payrate we want? But this is how Exchequer does it!
                              KeyS := JBRCode + JBECode + FullEmpKey(sNextJob);
                              KeyChk := KeyS;
                              lStatus := LFind_Rec(B_GetGEq, JCtrlF, JCK, KeyS);

                              // Use the first job we find that has any pay rates defined
                              bFoundJobRate := (lStatus = 0) And CheckKey (KeyS, KeyChk, Length(KeyChk), BOff);

                              // Setup the next job code to examine as the parent of this job
                              sNextJob := LJobRec.JobCat;
                            End // If GetJobRec (CompanyBtr, sNextJob)
                            Else
                            Begin
                              // Cannot load Job
                              lStatus := 4;
                            End; // Else
                          Until (lStatus <> 0) Or (Trim(sNextJob) = '') Or bFoundJobRate;

                          If bFoundJobRate Then
                          Begin
                            // Search for a matching Job Time-Rate
                            KeyS := PartCCKey(JBRCode, JBECode) + FullJBCode(LJobRec.JobCode, 0, LineRec.tsRateCode);
                            lStatus := LFind_Rec(B_GetGEq, JCtrlF, JCK, KeyS);
                            While (lStatus = 0) And (LJobCtrl^.RecPfix = JBRCode) And (LJobCtrl^.SubType = JBECode) And
                                  (Trim(LJobCtrl^.EmplPay.EmpCode) = Trim(LJobRec.JobCode)) And (Not Result) Do Begin
                              // Check for desired Rate Code
                              Result := (LJobCtrl^.EmplPay.EStockCode = LineRec.tsRateCode);

                              If (Not Result) Then
                                lStatus := LFind_Rec(B_GetNext, JCtrlF, JCK, KeyS);
                            End; { While }
                          End; // If bFoundJobRate
                        End; // rstJob
          Else
            Raise Exception.Create ('AddTSHLinesErrorDesc - Unknown RateSearch value (' + IntToStr(Ord(RateSearch[iArray])) + ')');
          End; // Case RateSearch[iArray]

          If Result Then
          Begin
            Break;
          End; // If Result
        End; // For iArray

        If Result Then
          With LJobCtrl^.EmplPay Do
          Begin
            // Copy Time-Rate fields into Line Record for later use
            LineRec.tsDefAnalCode := EAnalCode;

            LineRec.tsDefNarrative := PayRDesc;

            LineRec.tsDefChargeAmt := Round_Up (ChargeOut, LSyss.NoNetDec);
            LineRec.tsChargeCcy := ChargeCurr;

            LineRec.tsDefCostAmt := Round_Up (Cost, LSyss.NoCOSDec);
            LineRec.tsDefCostCcy := CostCurr;

            // MH 02/08/06: Added field for Time-Rate Job Code for Noble Denton (ValidMode 1) so that
            // we can enforce Time-Rates for Jobs only
            LineRec.tsTimeRateJob := Trim(EmpCode);
          End; { With LJobCtrl^.EmplPay }
      End; { With CompObj, CompanyBtr^ }
    End; { GetEmpTimeRate }

    //-------------------------------------------------------------------


  Begin { ProcessStringArray }
    If (Result = 0) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        { Process Descriptions }
        If VarIsArray(TSHArray) Then Begin
          { Check it is sized correctly }
          If ((VarArrayHighBound(TSHArray,1) - VarArrayLowBound(TSHArray,1)) = Pred(TSHLines.Count)) Then Begin
            For I := VarArrayLowBound(TSHArray,1) To VarArrayHighBound(TSHArray,1) Do Begin
              tmpVar := TSHArray[I];

              If (varType(tmpVar) = WantType) Then Begin
                { Load record from list }
                TSHLineRec := TSHLinesRecPtr(TSHLines.Items[Pred(I)]);

                Case ProcMode Of
                  { Time-Rate Codes }
                  1   : Begin
                          TSHLineRec^.tsRateCode := FullJobCode(tmpVar);

// MH 02/08/06: Modified for Noble Denton XLA so that they can enforce Time Rates for Jobs only
//                          If Not GetEmpTimeRate (TSHLineRec^) Then
//                            // Invalid Time-Rate Code
//                            Result := ErrTimeRate;

                          If GetEmpTimeRate (TSHLineRec^) Then
                          Begin
                            If ((ValidMode AND 1) = 1) Then
                            Begin
                              // Raise error if Time Rate not for Line Job
                              If (Trim(LJobCtrl^.EmplPay.EmpCode) <> Trim(TSHLineRec^.tsJobCode)) Then
                              Begin
                                Result := ErrTimeRate;
                                ErrorDesc := 'Rate ' + Trim(TSHLineRec^.tsRateCode) + ' has not been set for the Job ' + Trim(TSHLineRec^.tsJobCode);
                              End; // If (Trim(LJobCtrl^.EmplPay.EmpCode) <> Trim(TSHLineRec^.tsJobCode))
                            End; // If ((ValidMode AND 1) = 1)
                          End // If GetEmpTimeRate (TSHLineRec^)
                          Else
                          Begin
                            // Invalid Time-Rate Code
                            Result := ErrTimeRate;

                            // MH 11/12/06: Modified message for Noble Denton
                            If ((ValidMode AND 1) = 1) Then
                              ErrorDesc := 'Rate ' + Trim(TSHLineRec^.tsRateCode) + ' has not been set for the Job ' + Trim(TSHLineRec^.tsJobCode);
                          End; // Else
                        End; { Time-Rate Codes }

                  { Analysis Code }
                  2   : Begin
                          TSHLineRec^.tsAnalCode := FullJACode(tmpVar);

                          If (Trim(TSHLineRec^.tsAnalCode) = '') Then
                            // No Analysis Code specified - substitute ddefault from Time-Rate record
                            TSHLineRec^.tsAnalCode := TSHLineRec^.tsDefAnalCode;

                          If (Trim(TSHLineRec^.tsAnalCode) <> '') Then Begin
                            // Load Analysis Code record }
                            If GetJobMiscRec (CompObj.CompanyBtr, TSHLineRec^.tsAnalCode, 2) Then Begin
                              {$IFDEF EN550CIS}
                                // Got Analysis Record - Check its not a revenue code
                                If (LJobMisc.JobAnalRec.JAType = JobXRev) Then
                                  Result := ErrJobAnal;
                              {$ENDIF}
                            End { If GetJobMiscRec (CompObj.CompanyBtr, nlAnalCode, 2) }
                            Else
                              { Invalid Job analysis Code }
                              Result := ErrJobAnal;
                          End { If }
                          Else
                            { Invalid Job analysis Code }
                            Result := ErrJobAnal;
                        End; { Analysis Code }

                  { Cost Centre }
                  3   : With TSHLineRec^ Do Begin
                          { Check CC/Dept are turned on }
                          If LSyss.UseCCDep Then Begin
                            tsCostCentre := FullCCDepKey(tmpVar);

                            If (Trim(tsCostCentre) = '') Then
                              // No Cost Centre specified - substitute default from Employee record
                              tsCostCentre := lEmployee.CCDep[BOn];

                            If Not GetCCDepRec (CompObj.CompanyBtr, tsCostCentre, BOn) Then Begin
                              { Invalid Cost Centre }
                              Result := ErrCC;
                            End; { If Not GetCCDepRec (CompObj.CompanyBtr, nlCostC, BOn) }
                          End; { If }
                        End; { 3 - Cost Centre }

                  { Department }
                  4   : With TSHLineRec^ Do Begin
                          { Check CC/Dept are turned on }
                          If LSyss.UseCCDep Then Begin
                            tsDepartment := FullCCDepKey(tmpVar);

                            If (Trim(tsDepartment) = '') Then
                              // No Cost Centre specified - substitute default from Employee record
                              tsDepartment := lEmployee.CCDep[BOff];

                            If Not GetCCDepRec (CompObj.CompanyBtr, tsDepartment, BOff) Then Begin
                              { Invalid Department }
                              Result := ErrDept;
                            End; { If Not GetCCDepRec (CompObj.CompanyBtr, nlDept, BOff) }
                          End; { If }
                        End; { 4 - Department }

                  { Hours }
                  5   : With TSHLineRec^ Do Begin
                          tsHours := Round_Up (tmpVar, LSyss.NoQtyDec);

                          // MH 19/04/06: Allow -ve value lines
                          // HM 06/06/02: Allow Zero value lines to pass validation - filter them out later
                          //              without returning an error
                          //If (tsHours < 0.0) Then
                          //  Result := ErrHours;
                        End; { Hours }

                  { Narrative }
                  6   : With TSHLineRec^ Do Begin
                          tsNarrative := TmpVar;

                          If (tsNarrative = '') Then
                            // No Narrative specified - substitute default from Time-Rate record
                            // NOTE: Don't trim - then space can be used if they WANT a blank narrative
                            tsNarrative := tsDefNarrative;
                        End; { Narrative }

                  { Charge-Out Rate }
                  7   : With TSHLineRec^ Do Begin
                          tsChargeAmt := Round_Up (tmpVar, LSyss.NoNetDec);

                          If (tsChargeAmt = -1) Then
                            // No Charge-Out Rate specified - substitute default from Time-Rate record
                            tsChargeAmt := tsDefChargeAmt;
                        End; { Charge-Out Rate }

                  { Cost Currency }
                  8   : With TSHLineRec^ Do Begin
                          tsCostCcy := tmpVar;

                          If (tsCostCcy = -1) Then Begin
                            // No Hourly Cost Currency specified - substitute default cost info from Time-Rate record
                            tsCostCcy := tsDefCostCcy;
                            tsCostAmt := tsDefCostAmt;
                            tsCostDefaulted := True;     // mark as defaulted for when processing the hourly cost
                          End { If (tsCostCcy = -1) }
                          Else
                            // Not defaulted - check user has permissions to manually override the cost element
                            If CompObj.CheckSecurity (519{406}) Then Begin
                              // Got permission - Validate currency for version
                              If IsMultiCcy Then Begin
                                { Multi-Currency - 1..CurrencyType }
                                If (tsCostCcy < 1) Or (tsCostCcy > CurrencyType) Then
                                  { Invalid Currency }
                                  Result := ErrCcy;
                              End { If IsMultiCcy }
                              Else Begin
                                { Single Currency - 0 Only }
                                If (tsCostCcy <> 0) Then
                                  { Invalid Currency }
                                  Result := ErrCcy;
                              End; { Else }
                            End { If CompObj.CheckSecurity (406) }
                            Else
                              Result := ErrPermit;
                        End; { Cost Currency }

                  { Hourly Cost }
                  9   : With TSHLineRec^ Do Begin
                          // Check to see if cost details have already been defaulted
                          If (Not tsCostDefaulted) Then Begin
                            // Not default - process specified details
                            tsCostAmt := Round_Up (tmpVar, LSyss.NoNetDec);

                            If (tsCostAmt = -1) Or tsCostDefaulted Then Begin
                              // No Hourly Cost Rate specified - substitute default from Time-Rate record
                              tsCostCcy := tsDefCostCcy;
                              tsCostAmt := tsDefCostAmt;
                            End { If (tsCostAmt = -1) Or tsCostDefaulted }
                            Else
                              // Not defaulted - check user has permissions to manually override the cost element
                              If (Not CompObj.CheckSecurity (519{406})) Then
                                Result := ErrPermit;
                          End; { If (Not tsCostDefaulted) }
                        End; { Hourly Cost }

                  // UDef 1
                  10  : With TSHLineRec^ Do
                        Begin
                          tsUDF1 := tmpVar;
                        End; // UDef 1

                  // UDef 2
                  11  : With TSHLineRec^ Do
                        Begin
                          tsUDF2 := tmpVar;
                        End; // UDef 2

                  // MH 01/11/2011 v6.9: Extended to 10 UDef Fields
                  12  : TSHLineRec^.tsUDF3 := tmpVar;
                  13  : TSHLineRec^.tsUDF4 := tmpVar;
                  14  : TSHLineRec^.tsUDF5 := tmpVar;
                  15  : TSHLineRec^.tsUDF6 := tmpVar;
                  16  : TSHLineRec^.tsUDF7 := tmpVar;
                  17  : TSHLineRec^.tsUDF8 := tmpVar;
                  18  : TSHLineRec^.tsUDF9 := tmpVar;
                  19  : TSHLineRec^.tsUDF10 := tmpVar;
                End; { Case }

                TSHLineRec := Nil;
              End { If (varType(tmpVar) = WantType) }
              Else
                { Not a valid String }
                Result := ListErr;

              If (Result <> 0) Then Begin
                Break;
              End; { If }
            End; { For I }
          End { If }
          Else
            { Incorrect number of elements }
            Result := ListErr;
        End { If }
        Else
          { Not an array }
          Result := ListErr;
      End; { With CompObj, CompanyBtr^ }
    End; { If }
  End; { ProcessTSHArray }

  //---------------------------------------------------------

  { Remove any Zero value lines from TSH to eliminate wastage }
  Procedure KillZeros;
  Var
    TSHLineRec : TSHLinesRecPtr;
    I          : SmallInt;
  Begin { KillZeros }
    If (TSHLines.Count > 0) Then Begin
      I := 0;

      While (I <= Pred(TSHLines.Count)) Do Begin
        TSHLineRec := TSHLinesRecPtr(TSHLines.Items[I]);

        If (TSHLineRec^.tsHours = 0.0) Then
        Begin
          { Zero Hours - remove line }
          Dispose(TSHLineRec);
          TSHLines.Delete(I);
        End // If (TSHLineRec^.tsHours = 0.0)
        Else
          { Non-Zero - keep it }
          Inc (I);
      End; { For }
    End; { If (TSHLines.Count > 0) }
  End; { KillZeros }

  //---------------------------------------------------------

  Procedure AddTimesheet;
  Var
    IDLines   : Array Of Idetail;
    I         : SmallInt;
  Begin { AddTimesheet }
    // Check we have some lines
    If (TSHLines.Count > 0) Then Begin
      { Setup variable size array for the ID Lines }
      SetLength(IDLines, TSHLines.Count);

      With CompObj, CompanyBtr^ Do Begin
        // Build the TSH Header record
        LResetRec (InvF);
        With LInv Do Begin
          InvDocHed := TSH;
          NomAuto := True;

          TransDesc := TSHDesc;

          // MH 13/10/06: Added ability to specify transaction date in excel functions
          //TransDate := Today;
          TransDate := lTransDate;

          AcPr      := ThePeriod;
          AcYr      := TxlateYrVal(TheYear,BOn);

          { Week / Month No }
          DiscDays := TSHWeekNo;
          // MH 04/02/2010 (v6.3): Also set new Week/Month field on header for TSH
          thWeekMonth := DiscDays;


          { Employee Code - FullEmpKey not available for use so used LJVAR directly }
          BatchLink := UpCaseStr(LJVar(lEmployee.EmpCode, EmplKeyLen));

          { Logged In Operator }
          OpName := UserInfo.Login;

          { Currency and Rates }
          If IsMultiCcy Then
            Currency := 1
          Else
            Currency := 0;
          CXRate := LSyssCurr.Currencies[Currency].CRates;
          {VATCRate     := CXrate;
          OrigRates    := CXrate;}
          SetTriRec (Currency, UseORate, CurrTriR);
          {SetTriRec (Syss.VATCurr, UseORate, VATTriR);
          SetTriRec (0,            UseORate, OrigTriR);}

          // MH 13/04/06: Corrected NEXT line number field
          //ILineCount := TSHLines.Count;
          ILineCount := TSHLines.Count + 1;

          DocUser1 := lUDFields[1];
          DocUser2 := lUDFields[2];
          DocUser3 := lUDFields[3];
          DocUser4 := lUDFields[4];
          DocUser5 := lUDFields[5];
          DocUser6 := lUDFields[6];
          DocUser7 := lUDFields[7];
          DocUser8 := lUDFields[8];
          DocUser9 := lUDFields[9];
          DocUser10 := lUDFields[10];

          // Transaction stored later after lines have been built
        End; { With LInv }

        If (LStatus = 0) Then Begin
          // build the array of transaction lines
          For I := 0 To Pred(TSHLines.Count) Do Begin
            TSHLineRec := TSHLinesRecPtr(TSHLines.Items[I]);

            With TSHLineRec^ Do Begin
              FillChar (IDLines[I], SizeOf(IdLines[I]), #0);
              With IDLines[I] do Begin
                IDDocHed  := LInv.InvDocHed;
                //DocPRef   := LInv.OurRef;          // Not available until TH stored
                //FolioRef  := LInv.FolioNum;        // Not available until TH stored
                LineNo    := Succ(I);
                AbsLineNo := Succ(I);
                PYr       := LInv.ACYr;
                PPr       := LInv.AcPr;

                { Job Code }
                JobCode := tsJobCode;

                { Time-Rate Code }
                StockCode := FullStockCode(tsRateCode);

                { Analysis Code }
                AnalCode := tsAnalCode;

                { Hours }
                Qty := tsHours;
                QtyMul := 1.0;            { HM 15/12/99 - v4.31 }
                PriceMulX := 1.0;         { HM 15/12/99 - v4.31 }

                { Narrative }
                Desc := tsNarrative;

                { Charge-Out Rate }
                CostPrice := tsChargeAmt;
                Reconcile := tsChargeCcy;

                { Cost / Hour }
                NetValue := tsCostAmt;
                Currency := tsCostCcy;
                CXRate:=LSyssCurr.Currencies[Currency].CRates;
                SetTriRec(Currency, UseORate, CurrTriR);

                { Cost Centre / Department }
                If CompObj.CompanyBtr.LSyss.UseCCDep Then Begin
                  CCDep[BOn]  := FullCCDepKey(tsCostCentre);
                  CCDep[BOff] := FullCCDepKey(tsDepartment);
                End; { If }

                NomMode := TSTNomMode;
                Payment:=SetRPayment(LInv.InvDocHed);
                PDate:=LInv.TransDate;

                { Update Invoice Header Totals }
                LInv.InvNetVal := LInv.InvNetVal + Round_Up (Currency_ConvFT (DetLTotal(IDLines[I], BOff,BOff, 0),
                                                                              Currency,
                                                                              0, //Currency,
                                                                              UseCoDayRate), 2);
                LInv.TotalInvoiced := LInv.TotalInvoiced + Qty;

                // User Defined Fields
                LineUser1 := tsUDF1;
                LineUser2 := tsUDF2;
                // MH 01/11/2011 v6.9: Extended to 10 UDef Fields
                LineUser3 := tsUDF3;
                LineUser4 := tsUDF4;
                LineUser5 := tsUDF5;
                LineUser6 := tsUDF6;
                LineUser7 := tsUDF7;
                LineUser8 := tsUDF8;
                LineUser9 := tsUDF9;
                LineUser10 := tsUDF10
              End; { With }
            End; { With TSHLineRec^ }
          End; { For I }

          // MH 28/10/2013 v7.0.7 ABSEXCH-14705: Added Transaction Originator fields
          SetOriginator(LInv);

          // Add TSH header record
          LSetNextDocNos(LInv, BOn);
          LStatus:=LAdd_Rec(InvF, InvRNoK);

          //GS 31/10/2011 Add Audit History Notes for v6.9
              if LStatus = 0 then
              begin
                WriteAuditNote(anTransaction, anCreate, CompObj);
              end;

          If (LStatus = 0) Then Begin
            // Add TSH Lines
            For I := 0 To Pred(TSHLines.Count) Do Begin
              LID := IDLines[I];
              With LId Do Begin
                DocPRef   := LInv.OurRef;
                FolioRef  := LInv.FolioNum;
              End; { With IDLines[I] }

              // Store Line
              LStatus := LAdd_Rec(IDetailF, IdFolioK);

              If (LStatus = 0) Then
                LUpdate_JobAct(LId, LInv);
            End; { For I }
          End; { If (LStatus = 0) }
        End; { If (LStatus = 0) }
      End; { With CompObj.CompanyBtr^ Do Begin}
    End; { If (TSHLines.Count > 0) }
  End; { AddTimesheet }

  //---------------------------------------------------------

  // validate misc header fields - period, year, udef
  Function ValidateHeaderFields : SmallInt;
  Var
    iArray, iValidate  : Byte;
  Begin // ValidateHeaderFields
    Result := 0;

    For iValidate := 1 To 4 Do
    Begin
      Case iValidate Of
        // Period
        1  : Begin
               If (ThePeriod < 1) Or (ThePeriod > CompObj.CompanyBtr.LSyss.PrInYr) Then
               Begin
                 Result := ErrPeriod;
               End; // If (ThePeriod < 1) Or (ThePeriod > CompObj.CompanyBtr.LSyss.PrInYr)
             End; // 1 - Period

        // Year
        2  : Begin
               If (TheYear < 1990) Or (TheYear > 2050) Then
               Begin
                 Result := ErrYear;
               End; // If (TheYear < 1990) Or (TheYear > 2050)
             End; // 2 - Year

        // UDef Fields
        3  : Begin
               For iArray := Low(lUDFields) To High(lUDFields) Do
               Begin
                 lUDFields[iArray] := '';
               End; // For iArray

               If VarIsArray(THUDFields) Then Begin
                 For iArray := VarArrayLowBound(THUDFields,1) To VarArrayHighBound(THUDFields,1) Do
                 Begin
                   If (iArray >= Low(lUDFields)) And (iArray <= High(lUDFields)) Then
                   Begin
                     lUDFields[iArray] := THUDFields[iArray];
                   End; // If (iArray >= Low(lUDFields)) And (iArray <= High(lUDFields))
                 End; // For iArray
               End; // If VarIsArray(JobCodeList)
             End; // 3 - UDef Fields

        // Transaction Date
        4  : Begin
               // MH 13/10/06: Added ability to specify transaction date in excel functions
               If (Trim(TransDate) <> '') Then Begin
                 Try
                   // Exception will be raised if date isn't understandable
                   lTransDate := FormatDatetime ('YYYYMMDD', StrToDate(TransDate));
                 Except
                   On Exception Do
                     Result := ErrDate;
                 End;
               End { If }
               Else
                 // No date specified - use today
                 lTransDate := Today;
             End; // 4 - Transaction Date
      End; // Case iValidate

      If (Result <> 0) Then Break;
    End; // For iValidate
  End; // ValidateHeaderFields

  //---------------------------------------------------------

Begin { AddTSHLinesErrorDesc }
  FillChar (lEmployee, SizeOf (lEmployee), #0);
  ErrorDesc := '';

  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then Begin
    // SSK 30/08/2016 R3 ABSEXCH-12531 : Added condition to validate period
    If ValidatePeriod(ThePeriod, CompObj)  Then {Check Period against System Setup Period}
    Begin
      If CompObj.CheckSecurity (518{20}) Then
        With CompObj, CompanyBtr^ Do Begin
          TSHLines := TList.Create;
          Try
            // Get Employee record
            If GetEmplRec (CompanyBtr, EmployeeCode) Then Begin
              lEmployee := LJobMisc.EmplRec;

              // HM 07/06/02: Added check on Certificate Expiry Date for Sub-Contractors
              // HM 20/04/04: Added check on CIS Type <> N/A or 4P before checking the expiry date
              If (lEmployee.EType = 2) And (Not (lEmployee.CISType In [0, 4])) Then
              Begin
                If (lEmployee.CertExpiry < Today) Then
                  Result := ErrEmplCertExp;
              End; { If (lEmployee.EType = 2) }

              // HM 02/06/03: Added check on Labour Costs
              If (Result = 0) And lEmployee.LabPLOnly Then
                // TSH's cannot be added for this employee
                Result := ErrEmplCode;

              // MH 02/01/2018 2018-R1 ABSEXCH-19552: Added check on Employee Status
              If (Result = 0) And (LEmployee.emStatus <> emsOpen) Then
                Result := ErrEmployeeClosed;
            End { If GetEmplRec (CompanyBtr, EmployeeCode) }
            Else
              { Failed to load employee }
              Result := ErrEmplCode;

            If (Result = 0) Then
            Begin
              // validate misc header fields - period, year, udef, trans date
              Result := ValidateHeaderFields;
            End; // If (Result = 0)

            If (Result = 0) Then Begin
              { Process Job Codes list creating array as necessary }
              If VarIsArray(JobCodeList) Then Begin
                For I := VarArrayLowBound(JobCodeList,1) To VarArrayHighBound(JobCodeList,1) Do Begin
                  tmpVar := JobCodeList[I];

                  If (varType(tmpVar) = varOLEStr) Then Begin
                    New (TSHLineRec);
                    FillChar (TSHLineRec^, SizeOf(TSHLineRec^), #0);
                    With TSHLineRec^ Do Begin
                      // HM 15/04/04: Added Uppercase as was causing problems reading the pay-rates
                      tsJobCode := UpperCase(FullJobCode(TmpVar));

                      { Get Job Code record }
                      If GetJobRec (CompanyBtr, tsJobCode) Then
                      Begin
                        // HM 14/04/04: Added check to ensure it isn't a contract
                        If (LJobRec.JobType = JobJobCode) Then
                        Begin
                          { Check it is a valid job }
                          If (LJobRec.JobStat = 5) Then
                            // Closed
                            Result := ErrJobClosed;
                        End // If (LJobRec.JobType <> JobJobCode)
                        Else
                        Begin
                          { Invalid Job Code - Contracts not allowed }
                          Result := ErrJobCode
                        End; // Else
                      End // If GetJobRec (CompanyBtr, tsJobCode)
                      Else
                        { Invalid Job Code }
                        Result := ErrJobCode
                    End; { With NomLineRec }

                    If (Result = 0) Then Begin
                      TSHLines.Add(TSHLineRec);
                    End; { If }
                  End { If (varType(tmpVar) = varInteger) }
                  Else
                    { Not a valid string }
                    Result := ErrJobCode;

                  If (Result <> 0) Then
                    Break;
                End; { For I }
              End { If }
              Else
                // Not an array
                Result := ErrJobList;
            End; { If (Result = 0) }

            If (Result = 0) Then ProcessTSHArray (RateCodeList,    1, varOLEStr, ErrTimeRateList);
            If (Result = 0) Then ProcessTSHArray (AnalCodeList,    2, varOLEStr, ErrAnalList);
            If (Result = 0) Then ProcessTSHArray (CCList,          3, varOLEStr, ErrCCList);
            If (Result = 0) Then ProcessTSHArray (DeptList,        4, varOLEStr, ErrDeptList);
            If (Result = 0) Then ProcessTSHArray (HoursList,       5, varDouble, ErrHoursList);
            If (Result = 0) Then ProcessTSHArray (NarrativeList,   6, varOLEStr, ErrNarrList);
            If (Result = 0) Then ProcessTSHArray (ChargeRateList,  7, varDouble, ErrChargeRateList);

            // HM 11/03/02: Added support for Cost Information
            If (Result = 0) Then ProcessTSHArray (CostCcyList,     8, varSmallInt, ErrCostCcyList);
            If (Result = 0) Then ProcessTSHArray (HourlyCostList,  9, varDouble,   ErrHourlyCostList);

            // HM 29/11/04: Added support for User Defined Field 1 & 2
            If (Result = 0) Then ProcessTSHArray (TLUDField1,     10, varOLEStr, ErrUserFieldsList);
            If (Result = 0) Then ProcessTSHArray (TLUDField2,     11, varOLEStr, ErrUserFieldsList);
            // MH 01/11/2011 v6.9: Extended to 10 UDef Fields
            If (Result = 0) Then ProcessTSHArray (TLUDField3,     12, varOLEStr, ErrUserFieldsList);
            If (Result = 0) Then ProcessTSHArray (TLUDField4,     13, varOLEStr, ErrUserFieldsList);
            If (Result = 0) Then ProcessTSHArray (TLUDField5,     14, varOLEStr, ErrUserFieldsList);
            If (Result = 0) Then ProcessTSHArray (TLUDField6,     15, varOLEStr, ErrUserFieldsList);
            If (Result = 0) Then ProcessTSHArray (TLUDField7,     16, varOLEStr, ErrUserFieldsList);
            If (Result = 0) Then ProcessTSHArray (TLUDField8,     17, varOLEStr, ErrUserFieldsList);
            If (Result = 0) Then ProcessTSHArray (TLUDField9,     18, varOLEStr, ErrUserFieldsList);
            If (Result = 0) Then ProcessTSHArray (TLUDField10,    19, varOLEStr, ErrUserFieldsList);

            If (Result = 0) Then
              // HM 06/06/02: Remove any Zero value lines from TSH
              KillZeros;

            If (Result = 0) Then
              // Add the Timesheet into Exchequer
              AddTimesheet;
          Finally
            { De-allocate records and destroy list }
            While (TSHLines.Count > 0) Do Begin
              TSHLineRec := TSHLinesRecPtr(TSHLines.Items[0]);
              Dispose(TSHLineRec);
              TSHLines.Delete(0);
            End; { While (TSHLines.Count > 0) }

            TSHLines.Destroy;
          End;
        End { With CompObj, CompanyBtr }
      Else
        // User not allowed to add Timesheets
        Result := ErrPermit;
    End { If ValidatePeriod }
    Else
      Result := ErrPeriod;
  End; { If (Result = 0) }
End; { AddTSHLinesErrorDesc }

//-------------------------------------------------------------------------

(* MH 02/11/2011 v6.9: Removed obsolete function
// Creates a multi-line Timesheet - used by the EntAddTimesheet and
// EntAddTimesheetWithCosts functions in EntStk2.Xla.
Function TEnterpriseServer.AddTSHLinesEx (Const Company        : String;
                                          Const EmployeeCode   : String;
                                          Const TSHDesc        : String;
                                          Const TheYear        : SmallInt;
                                          Const ThePeriod      : SmallInt;
                                          Const TSHWeekNo      : SmallInt;
                                          Var   THUDFields     : Variant;
                                          Var   JobCodeList    : Variant;
                                          Var   RateCodeList   : Variant;
                                          Var   AnalCodeList   : Variant;
                                          Var   CCList         : Variant;
                                          Var   DeptList       : Variant;
                                          Var   HoursList      : Variant;
                                          Var   NarrativeList  : Variant;
                                          Var   ChargeRateList : Variant;
                                          Var   CostCcyList    : Variant;
                                          Var   HourlyCostList : Variant;
                                          Var   TLUDField1     : Variant;
                                          Var   TLUDField2     : Variant) : SmallInt;
Var
  ErrorDesc : String;
Begin // AddTSHLinesEx
  ErrorDesc := '';
  Result := AddTSHLinesErrorDesc (Company, EmployeeCode, TSHDesc, '', TheYear, ThePeriod, TSHWeekNo,
                                  THUDFields, JobCodeList, RateCodeList, AnalCodeList, CCList,
                                  DeptList, HoursList, NarrativeList, ChargeRateList, CostCcyList,
                                  HourlyCostList, TLUDField1, TLUDField2, 0, ErrorDesc);
End; // AddTSHLinesEx
*)

//-----------------------------------------------------------------------------

// Returns a String from the Employee record
Function TEnterpriseServer.GetEmployeeStr (Var Company   : String;
                                           Var EmplCode  : String;
                                           Var MiscStrNo : SmallInt;
                                           Var MiscStr   : String) : SmallInt;
Var
  CompObj    : TCompanyInfo;
Begin { GetEmployeeStr }
  Result := 0;
  MiscStr := '';

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    { Check user has rights to 'Job Costing - Access Employee Records' }
    If CompObj.CheckSecurity (495{221}) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        { Load Employee details }
        If GetEmplRec (CompanyBtr, FullCustCode(EmplCode)) Then Begin
          Case MiscStrNo Of
            1  : MiscStr := LJobMisc.EmplRec.EmpName;
          End { Case }
        End { If GetStockRec }
        Else
          Result := ErrEmplCode;
      End; { With CompObj, CompanyBtr^ }
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End; { GetEmployeeStr }

//-----------------------------------------------------------------------------

// Finds a specified Time-Rate record
Function TEnterpriseServer.GetTimeRate (BtrObj   : TdPostExLocalPtr;
                                        EmplCode : ShortString;
                                        RateCode : ShortString) : Boolean;
Var
  KeyS : Str255;
  lStatus : SmallInt;
Begin { GetTimeRate }
  Result := False;

  With BtrObj^ Do Begin
    If (Trim(RateCode) <> '') Then Begin
      { Pad out codes correctly }
      RateCode := FullJobCode (RateCode);
      EmplCode := FullCustCode (EmplCode);

      { If Employee Code set then look for a matching Employee specific Time-Rate }
      If (Trim(EmplCode) <> '') Then Begin
        // Search for an Employee specific Time-Rate first
        KeyS := PartCCKey(JBRCode, JBPCode) + FullJBCode(EmplCode, 0, RateCode);
        lStatus := LFind_Rec(B_GetGEq, JCtrlF, JCK, KeyS);
        While (lStatus = 0) And (LJobCtrl^.RecPfix = JBRCode) And (LJobCtrl^.SubType = JBPCode) And
              (LJobCtrl^.EmplPay.EmpCode = EmplCode) And (Not Result) Do Begin
          // Check for desired Rate Code
          Result := (LJobCtrl^.EmplPay.EStockCode = RateCode);

          If (Not Result) Then
            lStatus := LFind_Rec(B_GetNext, JCtrlF, JCK, KeyS);
        End; { While ... }
      End; { If (Trim(EmplCode) <> '') }

      If (Not Result) Then Begin
        // Search for a matching Global Time-Rate
        KeyS := PartCCKey(JBRCode, JBECode) + FullJBCode(FullNomKey(-1), 0, RateCode);
        lStatus := LFind_Rec(B_GetGEq, JCtrlF, JCK, KeyS);
        While (lStatus = 0) And (LJobCtrl^.RecPfix = JBRCode) And (LJobCtrl^.SubType = JBECode) And
              (LJobCtrl^.EmplPay.EmpCode = FullNomKey(-1)) And (Not Result) Do Begin
          // Check for desired Rate Code
          Result := (LJobCtrl^.EmplPay.EStockCode = RateCode);

          If (Not Result) Then
            lStatus := LFind_Rec(B_GetNext, JCtrlF, JCK, KeyS);
        End; { While ... }
      End; { If (Not Result) }
    End; { If (Trim(RateCode) <> '') }
  End; { If }
End; { GetTimeRate }

//-----------------------------------------------------------------------------

// Returns a String from a Time-Rate record
Function TEnterpriseServer.GetTimeRateStr (Var Company      : String;
                                           Var EmplCode     : String;
                                           Var TimeRateCode : String;
                                           Var MiscStrNo    : SmallInt;
                                           Var MiscStr      : String) : SmallInt;
Var
  CompObj   : TCompanyInfo;
Begin { GetTimeRateStr }
  Result := 0;
  MiscStr := '';

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    { Check user has rights to 'Job Costing - Employee Records, Rates' }
    If CompObj.CheckSecurity (496{222}) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        { Load Time-Rate details }
        If GetTimeRate (CompanyBtr, EmplCode, TimeRateCode) Then
          Case MiscStrNo Of
            1  : MiscStr := LJobCtrl^.EmplPay.PayRDesc;
          End { Case }
        Else
          // No Time-Rate found
          Result := ErrTimeRate;
      End; { With CompObj, CompanyBtr^ }
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
End; { GetTimeRateStr }

//-----------------------------------------------------------------------------

// Obselete function - use GetAnalMiscStr
Function TEnterpriseServer.GetAnalDesc(Var Company  : String;
                                       Var AnalCode : String;
                                       Var AnalDesc : String) : SmallInt;
Var
  Id : SmallInt;
Begin
  Id := 1;
  Result := GetAnalMiscStr (Company, AnalCode, AnalDesc, Id);
End;

//------------------------------

// GetAnalMiscStr: Returns a misc string from the Analysis Code record
Function TEnterpriseServer.GetAnalMiscStr(Var Company  : String;
                                          Var AnalCode  : String;
                                          Var AnalStr   : String;
                                          Var AnalStrNo : SmallInt) : SmallInt;
Var
  CompObj   : TCompanyInfo;
  I         : CISTaxType;
  oAnalCode : TCachedDataRecord;
  GotRec    : Boolean;
Begin { GetAnalMiscStr }
  Result := 0;
  AnalStr := '';

{$IFDEF EN550CIS}
  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (479{236}) Then Begin
      { Get Analysis Code Record }
      //If GetJobMiscRec (CompObj.CompanyBtr, AnalCode, 2) Then

      // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added caching on Analysis Codes
      oAnalCode := CompObj.AnalysisCodeCache.GetAnalysisCode (AnalCode);
      If Assigned(oAnalCode) Then
      Begin
        // Copy details out of cache into LNom record
        oAnalCode.DownloadRecord (@CompObj.CompanyBtr^.LJobMisc^);
        GotRec := True;
      End // If Assigned(oAnalCode)
      Else
      Begin
        // Lookup AnalCode and add to cache for next time
        GotRec := GetJobMiscRec (CompObj.CompanyBtr, AnalCode, 2);
        If GotRec Then
          CompObj.AnalysisCodeCache.AddToCache (CompObj.CompanyBtr^.LJobMisc.JobAnalRec.JAnalCode, @CompObj.CompanyBtr^.LJobMisc^, SizeOf(JobMiscRec));
      End; // Else

      If GotRec Then
      Begin
        With CompObj.CompanyBtr.LJobMisc.JobAnalRec Do
          Case AnalStrNo Of
            // Description
            1  : AnalStr := JAnalName;

            // Analysis Type
            2  : Case JAType Of
                   JobXRev : AnalStr := 'Revenue';
                   JobXMat : AnalStr := 'Materials';
                   JobXOH  : AnalStr := 'Overheads';
                   JobXLab : AnalStr := 'Labour';
                 Else
                   AnalStr := 'Unknown Analysis Code Type';
                 End; { Case }

            // Category
            3  : AnalStr := SyssJob^.JobSetup.SummDesc[AnalHed];

            // Deduct CIS Tax
            4  : With SyssCIS^.CISRates DO Begin
                   AnalStr := '0 - N/A';
                   For I := Low(CISRate) To High(CISRate) Do
                     If (CISRate[I].Code = CISTaxRate) Then Begin
                       AnalStr := CISRate[I].Code + ' - ' + CISRate[I].Desc;
                       Break;
                     End; { If (CISRate[I].Code = CISTaxRate) }
                 End; { With SyssCIS^.CISRates }

            // Revenue
            //5  : AnalStr := '???';
          End { Case AnalStrNo }
      End // If GotRec
      Else
        Result := ErrJobAnal;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
{$ELSE}
  Result := ErrUnknown;
{$ENDIF}
End;

//------------------------------

Function TEnterpriseServer.SaveAnalMiscStr (Var Company   : String;
                                            Var AnalCode  : String;
                                            Var AnalStrNo : SmallInt;
                                            Var NewStr    : String) : SmallInt;
Const
  FNum  = JMiscF;
  KPath = JMK;
Var
  CompObj    : TCompanyInfo;
  KeyR, KeyS : Str255;
  I          : CISTaxType;
Begin
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then Begin
    If CompObj.CheckSecurity (484{236}) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        KeyS := FullJAKey (JARCode, JASubAry[2], AnalCode);
        KeyR := KeyS;

        LStatus:=LFind_Rec(B_GetGEq,FNum,KPath,KeyS);

        If LStatusOk And CheckKey(KeyR,KeyS,Length(KeyR),BOn) Then Begin
          { found - get rec and update }
          GLobLocked:=BOff;
          Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked);
          LGetRecAddr(FNum);

          If OK And GlobLocked Then Begin
            Case AnalStrNo Of
              // Deduct CIS Tax - 0=N/A, C=Construct, T=Technical
              1  : With SyssCIS^.CISRates Do Begin
                     NewStr := UpperCase(NewStr) + ' ';
                     // HM 14/04/04: Extended to check for NewStr[1] as wasn't working as string was '0 '!
                     If (NewStr[1] = '0') Then
                       LJobMisc.JobAnalRec.CISTaxRate := #0
                     Else
                       If (NewStr[1] In ['C', 'T']) Then Begin
                         Result := ErrValue;
                         NewStr := UpperCase(NewStr);

                         For I := Low(CISRate) To High(CISRate) Do
                           If (CISRate[I].Code = NewStr[1]) Then Begin
                             LJobMisc.JobAnalRec.CISTaxRate := CISRate[I].Code;
                             Result := 0;
                             Break;
                           End; { If (CISRate[I].Code = CISTaxRate) }
                       End { If (NewStr[1] In ['C', 'T']) }
                       Else
                         Result := ErrCISDeductType;
                   End; { With SyssCIS^.CISRates }
            End; { Case AnalStrNo }

            If (Result = 0) Then Begin
              { update record }
              LStatus := LPut_Rec (Fnum, KPath);

              // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added caching on Analysis Codes
              If (LStatus = 0) Then
              Begin
                // Update the cache of Analysis Code details to include the changes
                AnalysisCodeCache.UpdateCache (LJobMisc.JobAnalRec.JAnalCode, @LJobMisc^, SizeOf(JobMiscRec));
              End; // If (LStatus = 0)
            End; { If }

            { Unlock record}
            LUnlockMLock(FNum);

            If (Result = 0) Then Begin
              If (LStatus = 0) Then
                Result := 0
              Else
                Result := ErrBtrBase + LStatus;
            End; { If (Result = 0) }
          End { If OK And GlobLocked }
          Else
            Result := ErrRecLock;
        End { If LStatusOk And CheckKey... }
        Else
          Result := ErrJobCode;
      End; { With CompObj, CompanyBtr^ }
    End { If CompObj.CheckSecurity (236) }
    Else
      Result := ErrPermit
  End; { If (Result = 0) }
End;

//-------------------------------------------------------------------------

// GetAnalMiscStr: Returns a misc string from the Analysis Code record
Function TEnterpriseServer.GetAnalMiscInt(Var Company   : String;
                                          Var AnalCode  : String;
                                          Var AnalInt   : LongInt;
                                          Var AnalIntNo : SmallInt) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin { GetAnalMiscInt }
  Result := 0;
  AnalInt := 0;

{$IFDEF EN550CIS}
  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (479{236}) Then Begin
      { Get Job Record }
      If GetJobMiscRec (CompObj.CompanyBtr, AnalCode, 2) Then
        With CompObj.CompanyBtr.LJobMisc.JobAnalRec Do
          Case AnalIntNo Of
            // P&L GL Code
            1  : AnalInt := WIPNom[BOn];

            // WIP GL Code
            2  : AnalInt := WIPNom[BOff];

            // Uplift Control GL Code
            3  : AnalInt := UpliftGL;

            // Line Type
            4  : AnalInt := JLinkLT;
          End { Case }
      Else
        Result := ErrJobAnal;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
{$ELSE}
  Result := ErrUnknown;
{$ENDIF}
End;  { GetAnalMiscInt }

//------------------------------

Function TEnterpriseServer.SaveAnalMiscInt (Var Company   : String;
                                            Var AnalCode  : String;
                                            Var AnalIntNo : SmallInt;
                                            Var NewInt    : LongInt) : SmallInt;
Const
  FNum  = JMiscF;
  KPath = JMK;
Var
  CompObj    : TCompanyInfo;
  KeyR, KeyS : Str255;
Begin
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then Begin
    If CompObj.CheckSecurity (484{236}) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        KeyS := FullJAKey (JARCode, JASubAry[2], AnalCode);
        KeyR := KeyS;

        LStatus:=LFind_Rec(B_GetGEq,FNum,KPath,KeyS);

        If LStatusOk And CheckKey(KeyR,KeyS,Length(KeyR),BOn) Then Begin
          { found - get rec and update }
          GLobLocked:=BOff;
          Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked);
          LGetRecAddr(FNum);

          If OK And GlobLocked Then Begin
            Case AnalIntNo Of
              // Uplift Control GL Code
              1  : Begin
                     If (NewInt > 0) Then Begin
                       // Validate GL Code
                       If GetNominalRec (CompanyBtr, NewInt) And
                          (Not (LNom.NomType In [CtrlNHCode, CarryFlg, NomHedCode])) Then
                         LJobMisc.JobAnalRec.UpliftGL := LNom.NomCode
                       Else
                         Result := ErrNom;
                     End { If (NewInt > 0) }
                     Else
                       // Blank uplift details out
                       With LJobMisc.JobAnalRec Do Begin
                         UpliftGL := 0;
                         UpliftP  := 0.0;
                       End; { With LJobMisc.JobAnalRec }
                   End;
            End; { Case AnalIntNo }

            If (Result = 0) Then Begin
              { update record }
              LStatus := LPut_Rec (Fnum, KPath);

              // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added caching on Analysis Codes
              If (LStatus = 0) Then
              Begin
                // Update the cache of Analysis Code details to include the changes
                AnalysisCodeCache.UpdateCache (LJobMisc.JobAnalRec.JAnalCode, @LJobMisc^, SizeOf(JobMiscRec));
              End; // If (LStatus = 0)
            End; { If }

            { Unlock record}
            LUnlockMLock(FNum);

            If (Result = 0) Then Begin
              If (LStatus = 0) Then
                Result := 0
              Else
                Result := ErrBtrBase + LStatus;
            End; { If (Result = 0) }
          End { If OK And GlobLocked }
          Else
            Result := ErrRecLock;
        End { If LStatusOk And CheckKey... }
        Else
          Result := ErrJobCode;
      End; { With CompObj, CompanyBtr^ }
    End { If CompObj.CheckSecurity (236) }
    Else
      Result := ErrPermit
  End; { If (Result = 0) }
End;

//-------------------------------------------------------------------------

// GetAnalMiscStr: Returns a misc Double from the Analysis Code record
Function TEnterpriseServer.GetAnalMiscDbl(Var Company   : String;
                                          Var AnalCode  : String;
                                          Var AnalDbl   : Double;
                                          Var AnalDblNo : SmallInt) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin { GetAnalMiscDbl }
  Result := 0;
  AnalDbl := 0;

{$IFDEF EN550CIS}
  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then Begin
    If CompObj.CheckSecurity (479{236}) Then Begin
      { Get Job Record }
      If GetJobMiscRec (CompObj.CompanyBtr, AnalCode, 2) Then
        With CompObj.CompanyBtr.LJobMisc.JobAnalRec Do
          Case AnalDblNo Of
            // P&L GL Code
            1  : AnalDbl := UpliftP * 100;

          End { Case }
      Else
        Result := ErrJobAnal;
    End { If }
    Else
      Result := ErrPermit;
  End { If }
  Else
    Result := ErrComp;
{$ELSE}
  Result := ErrUnknown;
{$ENDIF}
End;  { GetAnalMiscDbl }

//------------------------------

Function TEnterpriseServer.SaveAnalMiscDbl (Var Company   : String;
                                            Var AnalCode  : String;
                                            Var AnalDblNo : SmallInt;
                                            Var NewDbl    : Double) : SmallInt;
Const
  FNum  = JMiscF;
  KPath = JMK;
Var
  CompObj    : TCompanyInfo;
  KeyR, KeyS : Str255;
  I          : CISTaxType;
Begin
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then Begin
    If CompObj.CheckSecurity (484{236}) Then Begin
      With CompObj, CompanyBtr^ Do Begin
        KeyS := FullJAKey (JARCode, JASubAry[2], AnalCode);
        KeyR := KeyS;

        LStatus:=LFind_Rec(B_GetGEq,FNum,KPath,KeyS);

        If LStatusOk And CheckKey(KeyR,KeyS,Length(KeyR),BOn) Then Begin
          { found - get rec and update }
          GLobLocked:=BOff;
          Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KPAth,Fnum,BOn,GlobLocked);
          LGetRecAddr(FNum);

          If OK And GlobLocked Then Begin
            Case AnalDblNo Of
              // Uplift %
              1  : With LJobMisc.JobAnalRec Do Begin
                     // Can only set if Uplift GL Code is set
                     If (UpliftGL > 0) Or (NewDbl = 0.0) Then Begin
                       UpliftP := Round_Up(NewDbl / 100, 4);
                       If (LJobMisc.JobAnalRec.UpliftP < 0) Or (LJobMisc.JobAnalRec.UpliftP > 1) Then
                         Result := ErrValue;
                     End { If (UpliftGL > 0) }
                     Else
                       Result := ErrNom;
                   End;
            End; { Case AnalDblNo }

            If (Result = 0) Then Begin
              { update record }
              LStatus := LPut_Rec (Fnum, KPath);

              // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added caching on Analysis Codes
              If (LStatus = 0) Then
              Begin
                // Update the cache of Analysis Code details to include the changes
                AnalysisCodeCache.UpdateCache (LJobMisc.JobAnalRec.JAnalCode, @LJobMisc^, SizeOf(JobMiscRec));
              End; // If (LStatus = 0)
            End; { If }

            { Unlock record}
            LUnlockMLock(FNum);

            If (Result = 0) Then Begin
              If (LStatus = 0) Then
                Result := 0
              Else
                Result := ErrBtrBase + LStatus;
            End; { If (Result = 0) }
          End { If OK And GlobLocked }
          Else
            Result := ErrRecLock;
        End { If LStatusOk And CheckKey... }
        Else
          Result := ErrJobCode;
      End; { With CompObj, CompanyBtr^ }
    End { If CompObj.CheckSecurity (236) }
    Else
      Result := ErrPermit
  End; { If (Result = 0) }
End;

//-----------------------------------------------------------------------------

// Creates a new Job Record
Function TEnterpriseServer.AddJob (Const Company       : String;
                                   Const OLEJobType    : String;    // 'J'=Job, 'C'=Contract
                                   Const ParentJobCode : String;    // Parent of new job within Job Tree - blank for root
                                   Const JobCode       : String;    // Code for new job
                                   Const JobDesc       : String;    // Description
                                   Const JobManager    : String;    // Manager
                                   Const JobTypeCode   : String;    // Job Type Code
                                   Const StartDate     : String;    // Start Date in DD/MM/YYYY format
                                   Const EndDate       : String;    // End Date in DD/MM/YYYY format
                                   Const CustomerCode  : String;    // Customer Code
                                   Const ContactName   : String;    // Contact
                                   Const ChargeType    : String;    // Charge Type - T=Time&Mats, F=Fixed Price, C=Cost Plus%, N=Non-Productive
                                   Const PriceQuoted   : Double;    // Price Quoted in jrPriceCurrency
                                   Const PriceCurrency : SmallInt;  // Currency for jrPriceQuoted
                                   Const SORReference  : String;    // Order Reference
                                   Const JobStatus     : String;    // Status - Q=Quotation, A=Active, S=Suspended, C=completed, L=Closed
                                   Var   UserFieldList : Variant;   // User definable fields
                                   Var   ErrString     : String     // Error Text for error 599
                                  ) : SmallInt;
Var
  CompObj    : TCompanyInfo;
  lJobDets   : JobRecType;

  //------------------------------

  // Validates the parameters passed in for the new Job Record, returns 0 if
  // successful else returns an OLE Server error code
  Function ValidateJobDets : SmallInt;
  Var
    SDate, EDate  : TDateTime;
    I, J, UDFIdx  : Byte;
    tmpVar        : Variant;
    S             : ShortString;
  Begin // ValidateJobDets
    Result := 0;

    For I := 1 To 14 Do
      With CompObj, CompanyBtr^ Do
      Begin
        Case I Of
          1  : Begin // Job Code - must be set and not already exist
                 lJobDets.JobCode := FullJobCode(UpperCase(JobCode));
                 If (Trim(lJobDets.JobCode) = '') Or GetJobRec(CompanyBtr,lJobDets.JobCode) Then
                   // Job Code must be set, and cannot already exist
                   Result := ErrJobCode;
               End;  // Job Code

          2  : Begin // Job Parent - must be blank or a valid Job Code (Type = Contract)
                 lJobDets.JobCat := FullJobCode(UpperCase(ParentJobCode));
                 If (Trim(lJobDets.JobCat) <> '') Then
                 Begin
                   // Parent Code set - get record and check type
                   If GetJobRec(CompanyBtr, lJobDets.JobCat) Then
                   Begin
                     If (LJobRec.JobType <> JobGrpCode) Then
                     Begin
                       // Parent Code must be a group
                       Result := ErrInternalErr;
                       ErrString := 'Parent Jobs must be of type Contract';
                     End; // If (LJobRec.JobType <> JobGrpCode)
                   End // If GetJobRec(CompanyBtr^, lJobDets.JobCat)
                   Else Begin
                     // Specified Parent job Code doesn't exist
                     Result := ErrInternalErr;
                     ErrString := 'The Parent Job Code does not exist';
                   End; // Else
                 End; // If (Trim(lJobDets.JobCat) <> '')
               End; // Job Parent

          3  : Begin // Manager
                 // Check field length
                 If (Length(Trim(JobManager)) <= (SizeOf(lJobDets.JobMan) - 1)) Then
                   // OK
                   lJobDets.JobMan := Trim(JobManager)
                 Else Begin
                   // Field too long
                   Result := ErrInternalErr;
                   ErrString := Format ('The Job Manager field is too long (Length=%d, Max=%d)', [Length(Trim(JobManager)), SizeOf(lJobDets.JobMan) - 1]);
                 End; // Else
               End; // Manager

          4  : Begin // Job Description
                 // Check field length
                 If (Length(Trim(JobDesc)) <= (SizeOf(lJobDets.JobDesc) - 1)) Then
                   // OK
                   lJobDets.JobDesc := FullJobDesc(JobDesc)
                 Else Begin
                   // Field too long
                   Result := ErrInternalErr;
                   ErrString := Format ('The Job Description field is too long (Length=%d, Max=%d)', [Length(Trim(JobDesc)), SizeOf(lJobDets.JobDesc) - 1]);
                 End; // Else
               End; // Job Description

          // HM 16/06/04: Modified validation for contracts to the basics
          5  : If (OLEJobType <> 'C') Then
               Begin // Job Type Code
                 lJobDets.JobAnal := FullCCDepKey(UpperCase(JobTypeCode));
                 If (Trim(lJobDets.JobAnal) = '') Or (Not GetJobMiscRec (CompanyBtr, lJobDets.JobAnal, 1)) Then
                 Begin
                   // Job Code must be set, and cannot already exist
                   Result := ErrInternalErr;
                   ErrString := 'The Job Type must be set to a valid Job Type Code';
                 End; // If (Trim(...
               End; // Job Type Code

          // HM 16/06/04: Modified validation for contracts to the basics
          6  : If (OLEJobType <> 'C') Then
               Begin // Job Start Date/End Date - DD/MM/YYYY format
                 Try
                   // Exception will be raised if date isn't understandable
                   lJobDets.StartDate := FormatDatetime ('YYYYMMDD', StrToDate(StartDate));
                 Except
                   On Exception Do
                   Begin
                     Result := ErrInternalErr;
                     ErrString := 'The Start Date must be a valid date in DD/MM/YYYY format';
                   End; // On Exception
                 End;

                 // Check to see if the End Date is set
                 If (Result = 0) Then
                 Begin
                   Try
                     // Exception will be raised if date isn't understandable
                     lJobDets.EndDate := FormatDatetime ('YYYYMMDD', StrToDate(EndDate));

                     If (lJobDets.StartDate > lJobDets.EndDate) Then
                     Begin
                       Result := ErrInternalErr;
                       ErrString := 'The End Date must be on or after the Start Date';
                     End; // If (lJobDets.StartDate > lJobDets.EndDate)
                   Except
                     On Exception Do
                     Begin
                       Result := ErrInternalErr;
                       ErrString := 'The End Date must be a valid date in DD/MM/YYYY format';
                     End; // On Exception
                   End;
                 End; // If (Result = 0)
               End // Job Start Date
               Else
               Begin
                 // HM 23/06/04: Wasn't initialising Start Date
                 lJobDets.StartDate := FormatDatetime ('YYYYMMDD', Now);
               End; // Else

          // HM 16/06/04: Modified validation for contracts to the basics
          8  : If (OLEJobType <> 'C') Then
               Begin // Customer Code - must be set and valid
                 lJobDets.CustCode := FullCustCode(UpperCase(CustomerCode));
                 If (Trim(lJobDets.CustCode) <> '') Then
                 Begin
                   // Get account details
                   If (Not GetCustRec(CompanyBtr,lJobDets.CustCode, True)) Or (LCust.CustSupp <> 'C') Then
                     // Invalid Customer Account Code
                     Result := ErrCust;
                 End // If (Trim(lJobDets.CustCode) = '')
                 Else
                   // Cannot be left blank
                   Result := ErrCust;
               End; // Customer Code

          9  : Begin // Contact Name
                 // Check field length
                 If (Length(Trim(ContactName)) <= (SizeOf(lJobDets.Contact) - 1)) Then
                   // OK
                   lJobDets.Contact := Trim(ContactName)
                 Else Begin
                   // Field too long
                   Result := ErrInternalErr;
                   ErrString := Format ('The Contact field is too long (Length=%d, Max=%d)', [Length(Trim(ContactName)), SizeOf(lJobDets.Contact) - 1]);
                 End; // Else
               End; // Contact Name

          10 : Begin // Charge Type - T=Time&Mats, F=Fixed Price, C=Cost Plus%, N=Non-Productive
                 Case (Trim(UpperCase(ChargeType)) + ' ')[1] Of
                   // Time & Materials
                   'T' : lJobDets.ChargeType := 1;
                   // Fixed Price
                   'F' : lJobDets.ChargeType := 2;
                   // Cost Plus %
                   'C' : lJobDets.ChargeType := 3;
                   // Non-Productive
                   'N' : lJobDets.ChargeType := 4;
                 Else
                   Result := ErrInternalErr;
                   ErrString := 'The Charge type must be ''T'', ''F'', ''C'' or ''N''';
                 End; // Case (Trim(UpperCase(ChargeType)) + ' ')[1]
               End; // Charge Type - T=Time&Mats, F=Fixed Price, C=Cost Plus%, N=Non-Productive

          // HM 16/06/04: Modified validation for contracts to the basics
          11 : If (OLEJobType <> 'C') Then
               Begin // Price Quoted & Currency
                 // No validation on price
                 lJobDets.QuotePrice := PriceQuoted;

                 // Validate the Currency Number depending on the Licenced Currrency Version
                 Case EnterpriseLicence.elCurrencyVersion Of
                   cvPro    : If (PriceCurrency <> 0) Then Result := ErrCcy;
                   cvEuro   : If (PriceCurrency < 1) Or (PriceCurrency > 2) Then Result := ErrCcy;
                   cvGlobal : If (PriceCurrency < 1) Or (PriceCurrency > 89) Then Result := ErrCcy;
                 Else
                   Raise Exception.Create ('TEnterpriseServer.AddJob: Unhandled Currency Version');
                 End; // Case E

                 If (Result = 0) Then
                   // Validated OK
                   lJobDets.CurrPrice := PriceCurrency;
               End // Price Quoted & Currency
               Else
               Begin
                 // Contract - No validation on price or currency
                 lJobDets.QuotePrice := PriceQuoted;
                 If (EnterpriseLicence.elCurrencyVersion = cvPro) Then
                 Begin
                   lJobDets.CurrPrice := 0;
                 End // If ()
                 Else
                 Begin
                   lJobDets.CurrPrice := 1;
                 End; // Else
               End; // Else

          12 : Begin // Order Reference
                 // Check field length
                 If (Length(Trim(SORReference)) <= (SizeOf(lJobDets.SORRef) - 1)) Then
                   // OK
                   lJobDets.SORRef := Trim(SORReference)
                 Else Begin
                   // Field too long
                   Result := ErrInternalErr;
                   ErrString := Format ('The Order Reference field is too long (Length=%d, Max=%d)', [Length(Trim(SORReference)), SizeOf(lJobDets.SORRef) - 1]);
                 End; // Else
               End; // Order Reference

          13 : Begin // Status - Q=Quotation, A=Active, S=Suspended, C=completed, L=Closed
                 Case (Trim(UpperCase(JobStatus)) + ' ')[1] Of
                   // Quotation
                   'Q' : lJobDets.JobStat := 1;
                   // Active
                   'A' : lJobDets.JobStat := 2;
                   // Suspended
                   'S' : lJobDets.JobStat := 3;
                   // Completed
                   'C' : lJobDets.JobStat := 4;
                   // Closed
                   'L' : lJobDets.JobStat := 5;
                 Else
                   Result := ErrInternalErr;
                   ErrString := 'The Job Status must be ''Q'', ''A'', ''S'', ''C'' or ''L''';
                 End; // Case (Trim(UpperCase(JobStatus)) + ' ')[1]
               End; // Status

          14 : Begin // User definable fields
                 // Const UserFieldList : Variant;
                 UDFIdx := 1;

                 If VarIsArray(UserFieldList) Then
                   For J := VarArrayLowBound(UserFieldList,1) To VarArrayHighBound(UserFieldList,1) Do
                   Begin
                     tmpVar := UserFieldList[J];

                     If (varType(tmpVar) = varOLEStr) Then
                     Begin
                       // Extract string from variant to improve performance and readability
                       S := Trim(tmpVar);

                       // Check field length
                       If (Length(S) <= (SizeOf(lJobDets.UserDef1) - 1)) Then
                       Begin
                         // OK
                         Case UDFIdx Of
                           1  : lJobDets.UserDef1 := S;
                           2  : lJobDets.UserDef2 := S;
                           3  : lJobDets.UserDef3 := S;
                           4  : lJobDets.UserDef4 := S;
                           5  : lJobDets.UserDef5 := S;
                           6  : lJobDets.UserDef6 := S;
                           7  : lJobDets.UserDef7 := S;
                           8  : lJobDets.UserDef8 := S;
                           9  : lJobDets.UserDef9 := S;
                           10 : lJobDets.UserDef10 := S;
                         Else
                           Result := ErrUserFieldsList;
                         End;

                         Inc(UDFIdx);
                       End // If (Length(S) <= (SizeOf(lJobDets.UserDef1) - 1))
                       Else Begin
                         // Field too long
                         Result := ErrInternalErr;
                         ErrString := Format ('The User Defined field %d is too long (Length=%d, Max=%d)', [UDFIdx, Length(S), SizeOf(lJobDets.UserDef1) - 1]);
                       End; // Else
                     End // If (varType(tmpVar) = varOLEStr)
                     Else
                       Result := ErrUserFieldsList;

                     If (Result <> 0) Then
                       Break;
                   End // For J
                 Else
                   // Invalid User Fields List
                   Result := ErrUserFieldsList;
               End; // User definable fields
        End; // Case I

        If (Result <> 0) Then
          Break;
      End; // With CompObj, CompanyBtr^
  End; // ValidateJobDets

  //------------------------------

Begin // AddJob
  ErrString := '';

  // Create and initialise the structures for storing the processed details
  FillChar (lJobDets, SizeOf(lJobDets), #0);

  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then
  Begin
    If CompObj.CheckSecurity (513{207}) Then
      With CompObj, CompanyBtr^ Do
      Begin
        // Validate Job Record fields
        Result := ValidateJobDets;

        If (Result = 0) Then
        Begin
          // Fill out the details
          lJobRec^ := lJobDets;
          With lJobRec^ Do
          Begin
            // Set Job Type
            If (OLEJobType <> 'C') Then
            Begin
              // Job
              JobType := JobJobCode;
            End // If (OLEJobType <> 'C')
            Else
            Begin
              // Contract (Job Tree structure)
              JobType := JobGrpCode;
            End; // Else

            // Copy default VAT Code in from System Setup
            VATCode := LSyss.VATCode;

            // Note & Analysis Counters
            NlineCount:=1;
            ALineCount:=1000; {* Offset to avoid static anal types *}

            // Set Job Folio number
            JobFolio := LGetNextCount(JBF,    // Job Record
                                      True,   // Increment
                                      False,  // Update Last Posting Run Value
                                      0);     // Last Posting Run Value
          End; // With lJobRec^

          // Add the job
          lStatus := LAdd_Rec (JobF, JobCodeK);

          //GS 31/10/2011 Add Audit History Notes for v6.9
          if LStatus = 0 then
          begin
            WriteAuditNote(anJob, anCreate, CompObj);
          end;

          If LStatusOk Then
            // Create analysis budget headings etc...
            LCheck_JMajorHed(lJobRec^)
          Else
            Result := ErrBtrBase + LStatus;
        End; // If (Result = 0)
      End // With CompObj, CompanyBtr
    Else
      // User not allowed to add Jobs
      Result := ErrPermit;
  End; { If (Result = 0) }
End; // AddJob

//-----------------------------------------------------------------------------

// Returns the Basis (Incremental, Gross Inc, Gross) for the specified Terms
Function TEnterpriseServer.GetJobTermsBasis(Const Company, TermsOurRef : String; Var ContractBasis : String) : SmallInt;
Var
  CompObj : TCompanyInfo;
  sKey    : Str255;
  iStatus : SmallInt;
Begin // GetJobTermsBasis
  ContractBasis := '';

  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then
  Begin
    If CompObj.CheckSecurity (514{208}) Then
    Begin
      With CompObj, CompanyBtr^ Do
      Begin
        sKey := FullOurRefKey(TermsOurRef);
        iStatus := LFind_Rec(B_GetEq, InvF, InvOurRefK, sKey);
        If (iStatus = 0) And (LInv.InvDocHed In [JCT,JST,JPT]) Then
        Begin
          Case LInv.TransMode Of
            0 : ContractBasis := 'Incremental';
            1 : ContractBasis := 'Gross Incremental';
            2 : ContractBasis := 'Gross';
          Else
            ContractBasis := 'Unknown Basis (' + IntToStr(LInv.TransMode) + ')';
          End; // Case LInv.TransMode
        End // If (iStatus = 0)
        Else
        Begin
          Result := ErrAppsValsContract;
        End; // Else
      End; // With CompObj, CompanyBtr
    End // If CompObj.CheckSecurity (208)
    Else
    Begin
      // User not allowed to add Jobs
      Result := ErrPermit;
    End; // Else
  End; { If (Result = 0) }
End; // GetJobTermsBasis

//-----------------------------------------------------------------------------

// Returns a specified value from the applications for a specific job and analysis code:-
//
//   1   JPA Applied Total for all JPA or JSA's
//   2   JPA Certified Total for all JPA or JSA's
//
// Add a +100 offset to get JSA figures
//
Function TEnterpriseServer.GetJobAppsValue(Company, JobCode, AnalCode : String; Const WantValue : SmallInt; Var AppsValue : Double) : SmallInt;
Var
  CompObj     : TCompanyInfo;
  JobAppsTots : TAppAnalysisTotals;
Begin // GetJobAppsValue
  AppsValue := 0.00;

  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then
  Begin
    If CompObj.CheckSecurity (514{208}) Then   { Job Records, View Totals }
    Begin
      With CompObj, CompanyBtr^ Do
      Begin
        // Validate Job Code
        JobCode := UpperCase(FullJobCode(JobCode));
        If GetJobRec (CompanyBtr, JobCode) Then
        Begin
          // Build Job Apps cache
          If Not Assigned(AppsAnalCache) Then
          Begin
            AppsAnalCache := TApplicationsAnalysisCache.Create;
          End; // If Not Assigned(AppsAnalCache)
          Result := AppsAnalCache.UpdateJobTotals(aamJobTotals, CompanyBtr, JobCode, '', '');

          If (Result = 0) Then
          Begin
            // Get the correct set of totals from the cache
            If (Trim(AnalCode) = '') Then
            Begin
              // Take totals off Inv
              If (WantValue >= 100) Then
              Begin
                JobAppsTots := AppsAnalCache.SalesTotals;
              End // If (WantValue >= 100)
              Else
              Begin
                JobAppsTots := AppsAnalCache.PurchaseTotals;
              End; // Else
            End // If (Trim(AnalCode) = '')
            Else
            Begin
              // Validate Analysis Code
              AnalCode := UpperCase(FullJACode(AnalCode));
              If GetJobMiscRec (CompanyBtr, AnalCode, 2) Then
              Begin
                // Take totals off transaction lines for the Analysis Code
                If (WantValue >= 100) Then
                Begin
                  JobAppsTots := AppsAnalCache.SalesAnalysisTotals [AnalCode];
                End // If (WantValue >= 100)
                Else
                Begin
                  JobAppsTots := AppsAnalCache.PurchaseAnalysisTotals [AnalCode];
                End; // Else
              End // If GetJobMiscRec (CompanyBtr, AnalCode, 2)
              Else
              Begin
                Result := ErrJobAnal;
              End; // If Not GetJobMiscRec (CompanyBtr, AnalCode, 2)
            End; // Else

            If (Result = 0) Then
            Begin
              Case (WantValue Mod 100) Of
                // Applied Total for all JPA or JSA's
                1 : AppsValue := JobAppsTots.aatApplied;
                // Certified Total for all JPA or JSA's
                2 : AppsValue := JobAppsTots.aatCertified;
              Else
                Raise Exception.Create ('TEnterpriseServer.GetJobAppsValue: Unknown Value');
              End; // Case
            End; // If (Result = 0)
          End; // If (Result = 0)
        End // If GetJobRec (CompanyBtr, JobCode)
        Else
        Begin
          Result := ErrJobCode;
        End; // Else
      End; // With CompObj, CompanyBtr^
    End // If CompObj.CheckSecurity (208)
    Else
    Begin
      // User not allowed to add Jobs
      Result := ErrPermit;
    End; // Else
  End; { If (Result = 0) }
End; // GetJobAppsValue

//-----------------------------------------------------------------------------

// Returns a specified value from the applications for a specific job, sub-contractor
// and optional analysis code:-
//
//   1   JPA Applied Total for all JPA's
//   2   JPA Certified Total for all JPA's
//
Function TEnterpriseServer.GetJobAppsSubcontractorValue(Company, JobCode, EmplCode, AnalCode : String; Const WantValue : SmallInt; Var AppsValue : Double) : SmallInt;
Var
  CompObj     : TCompanyInfo;
  JobAppsTots : TAppAnalysisTotals;
Begin // GetJobAppsSubcontractorValue
  AppsValue := 0.00;

  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then
  Begin
    If CompObj.CheckSecurity (514{208}) Then   { Job Records, View Totals }
    Begin
      With CompObj, CompanyBtr^ Do
      Begin
        // Validate Job Code
        JobCode := UpperCase(FullJobCode(JobCode));
        If GetJobRec (CompanyBtr, JobCode) Then
        Begin
          // Validate Employee (Sub-contractor) Code
          EmplCode := UpperCase(LJVar(EmplCode,EmplKeyLen));
          If GetEmplRec (CompanyBtr, EmplCode) Then
          Begin
            // Build Job Apps cache
            If Not Assigned(AppsAnalCache) Then
            Begin
              AppsAnalCache := TApplicationsAnalysisCache.Create;
            End; // If Not Assigned(AppsAnalCache)
            Result := AppsAnalCache.UpdateJobTotals(aamSubcontractorTotals, CompanyBtr, JobCode, EmplCode, '');

            If (Result = 0) Then
            Begin
              // Get the correct set of totals from the cache
              If (Trim(AnalCode) = '') Then
              Begin
                JobAppsTots := AppsAnalCache.PurchaseTotals;
              End // If (Trim(AnalCode) = '')
              Else
              Begin
                // Validate Analysis Code
                AnalCode := UpperCase(FullJACode(AnalCode));
                If GetJobMiscRec (CompanyBtr, AnalCode, 2) Then
                Begin
                  // Take totals off transaction lines for the Analysis Code
                  JobAppsTots := AppsAnalCache.PurchaseAnalysisTotals [AnalCode];
                End // If GetJobMiscRec (CompanyBtr, AnalCode, 2)
                Else
                Begin
                  Result := ErrJobAnal;
                End; // If Not GetJobMiscRec (CompanyBtr, AnalCode, 2)
              End; // Else

              Case WantValue Of
                // Applied Total for all JPA or JSA's
                1 : AppsValue := JobAppsTots.aatApplied;
                // Certified Total for all JPA or JSA's
                2 : AppsValue := JobAppsTots.aatCertified;
              Else
                Raise Exception.Create ('TEnterpriseServer.GetJobAppsSubcontractorValue: Unknown Value');
              End; // Case
            End; // If (Result = 0)
          End // If GetEmplRec (CompanyBtr, EmplCode)
          Else
          Begin
            Result := ErrEmplCode;
          End; // Else
        End // If GetJobRec (CompanyBtr, JobCode)
        Else
        Begin
          Result := ErrJobCode;
        End; // Else
      End; // With CompObj, CompanyBtr^
    End // If CompObj.CheckSecurity (208)
    Else
    Begin
      // User not allowed to add Jobs
      Result := ErrPermit;
    End; // Else
  End; { If (Result = 0) }
End; // GetJobAppsSubcontractorValue

//-----------------------------------------------------------------------------

// Returns a specified value from the applications for a specific job, Customer
// and optional analysis code:-
//
//   1   Applied Total for all JSA's
//   2   Certified Total for all JSA's
//
Function TEnterpriseServer.GetJobAppsCustomerValue(Company, JobCode, CustCode, AnalCode : String; Const WantValue : SmallInt; Var AppsValue : Double) : SmallInt;
Var
  CompObj     : TCompanyInfo;
  JobAppsTots : TAppAnalysisTotals;
Begin // GetJobAppsCustomerValue
  AppsValue := 0.00;

  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then
  Begin
    If CompObj.CheckSecurity (514{208}) Then   { Job Records, View Totals }
    Begin
      With CompObj, CompanyBtr^ Do
      Begin
        // Validate Job Code
        JobCode := UpperCase(FullJobCode(JobCode));
        If GetJobRec (CompanyBtr, JobCode) Then
        Begin
          // Validate Customer Code
          CustCode := FullCustCode(CustCode);
          If GetCustRec (CompanyBtr, CustCode, True) And (LCust.CustSupp = 'C') Then
          Begin
            // Build Job Apps cache
            If Not Assigned(AppsAnalCache) Then
            Begin
              AppsAnalCache := TApplicationsAnalysisCache.Create;
            End; // If Not Assigned(AppsAnalCache)
            Result := AppsAnalCache.UpdateJobTotals(aamCustomerTotals, CompanyBtr, JobCode, '', CustCode);

            If (Result = 0) Then
            Begin
              // Get the correct set of totals from the cache
              If (Trim(AnalCode) = '') Then
              Begin
                JobAppsTots := AppsAnalCache.SalesTotals;
              End // If (Trim(AnalCode) = '')
              Else
              Begin
                // Validate Analysis Code
                AnalCode := UpperCase(FullJACode(AnalCode));
                If GetJobMiscRec (CompanyBtr, AnalCode, 2) Then
                Begin
                  // Take totals off transaction lines for the Analysis Code
                  JobAppsTots := AppsAnalCache.SalesAnalysisTotals [AnalCode];
                End // If GetJobMiscRec (CompanyBtr, AnalCode, 2)
                Else
                Begin
                  Result := ErrJobAnal;
                End; // If Not GetJobMiscRec (CompanyBtr, AnalCode, 2)
              End; // Else

              Case WantValue Of
                // Applied Total for all JPA or JSA's
                1 : AppsValue := JobAppsTots.aatApplied;
                // Certified Total for all JPA or JSA's
                2 : AppsValue := JobAppsTots.aatCertified;
              Else
                Raise Exception.Create ('TEnterpriseServer.GetJobAppsCustomerValue: Unknown Value');
              End; // Case
            End; // If (Result = 0)
          End // If GetCustRec (CompanyBtr, CustCode, True) And (LCust.CustSupp = 'C')
          Else
          Begin
            Result := ErrCust;
          End; // Else
        End // If GetJobRec (CompanyBtr, JobCode)
        Else
        Begin
          Result := ErrJobCode;
        End; // Else
      End; // With CompObj, CompanyBtr^
    End // If CompObj.CheckSecurity (208)
    Else
    Begin
      // User not allowed to add Jobs
      Result := ErrPermit;
    End; // Else
  End; { If (Result = 0) }
End; // GetJobAppsCustomerValue

//-----------------------------------------------------------------------------

// Returns a specified value from the applications for a specific job, Customer
// and optional analysis code:-
//
//   1   Applied To Date Value
//   2   Certified To Date Value
//   3   Budget Value
//
Function TEnterpriseServer.GetJobTermsValue(Company, OurRef, AnalCode : String; Const WantValue : SmallInt; Var RetValue : Double) : SmallInt;
Var
  CompObj     : TCompanyInfo;
  iStatus     : SmallInt;
  sKey        : Str255;
Begin // GetJobTermsValue
  RetValue := 0.00;

  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then
  Begin
    If CompObj.CheckSecurity (514{208}) Then   { Job Records, View Totals }
    Begin
      With CompObj, CompanyBtr^ Do
      Begin
        // Get Terms record
        sKey := FullOurRefKey(OurRef);
        iStatus := LFind_Rec(B_GetEq, InvF, InvOurRefK, sKey);
        If (IStatus = 0) Then
        Begin
          If (Trim(AnalCode) = '') Then
          Begin
            // No analysis code - use header totals
            Case WantValue Of
              // Cumulative Applied Value
              1  : RetValue := LInv.TotalReserved;
              // Cumulative Certified Value
              2  : RetValue := LInv.TotalOrdered;
              // Budget
              3  : RetValue := LInv.TotalCost;
            Else
              Raise Exception.Create ('TEnterpriseServer.GetJobTermsValue: Unknown Value');
            End; // Case WantValue
          End // If (Trim(AnalCode) = '')
          Else
          Begin
            // Validate Analysis Code and process the terms lines
            AnalCode := UpperCase(FullJACode(AnalCode));
            If GetJobMiscRec (CompanyBtr, AnalCode, 2) Then
            Begin
              // Run though Lines for Analysis Totals
              sKey := FullIdKey (LInv.FolioNum, 1);
              iStatus := LFind_Rec(B_GetGEq, IDetailF, IdFolioK, sKey);
              While (iStatus = 0) And (LId.FolioRef = LInv.FolioNum) Do
              Begin
                If (LId.AnalCode = AnalCode) Then
                Begin
                  Case WantValue Of
                    // Cumulative Applied Value
                    1  : RetValue := RetValue + LId.QtyDel;
                    // Cumulative Certified Value
                    2  : RetValue := RetValue + LId.QtyPWOff;
                    // Budget
                    3  : RetValue := RetValue + LId.CostPrice;
                  Else
                    Raise Exception.Create ('TEnterpriseServer.GetJobTermsValue: Unknown Value');
                  End; // Case WantValue
                End; // If (Trim(LId.AnalCode) = AnalCode)

                iStatus := LFind_Rec(B_GetNext, IDetailF, IdFolioK, sKey);
              End; // While (iStatus = 0) And (LId.FolioRef = LInv.FolioNum)
            End // If GetJobMiscRec (CompanyBtr, AnalCode, 2)
            Else
            Begin
              Result := ErrJobAnal;
            End; // If Not GetJobMiscRec (CompanyBtr, AnalCode, 2)
          End; // Else
        End // If (IStatus = 0)
        Else
        Begin
          Result := ErrAppsValsContract;
        End; // Else
      End; // With CompObj, CompanyBtr^
    End // If CompObj.CheckSecurity (208)
    Else
    Begin
      // User not allowed to add Jobs
      Result := ErrPermit;
    End; // Else
  End; { If (Result = 0) }
End; // GetJobTermsValue

//-----------------------------------------------------------------------------

// Returns a line type total from the specific transaction:-
//
//   0   Normal                          9   Retention 1
//   1   Labour                          10  Retention 2
//   2   Materials                       11  Deduction 1
//   3   Freight                         12  Deduction 2
//   4   Discount                        13  Deduction 3
//   5   Materials 1                     14  CITB
//   6   Materials 2                     15  CIS
//   7   Labour 1                        16  Misc 1
//   8   Labour 2                        17  Misc 2
//
Function TEnterpriseServer.GetTransactionLineTypeValue(Company, OurRef : String; LineType : SmallInt; Var RetValue : Double) : SmallInt;
Var
  CompObj     : TCompanyInfo;
  iStatus     : SmallInt;
  sKey        : Str255;
Begin // GetTransactionLineTypeValue
  Result := 0;
  RetValue := 0.00;

  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then
  Begin
    If CompObj.CheckSecurity (514{208}) Then   { Job Records, View Totals }
    Begin
      With CompObj, CompanyBtr^ Do
      Begin
        // Get Transaction
        sKey := FullOurRefKey(OurRef);
        iStatus := LFind_Rec(B_GetEq, InvF, InvOurRefK, sKey);
        If (IStatus = 0) Then
        Begin
          // Build Line Type cache
          If Not Assigned(TransLineTypeCache) Then
          Begin
            TransLineTypeCache := TAppValLineTypeAnalysisCache.Create;
          End; // If Not Assigned(TransLineTypeCache)
          TransLineTypeCache.BuildTransTotals(CompanyBtr, LInv);

          Try
            RetValue := TransLineTypeCache.ltaTotal [LineType];
          Except
            On Exception Do
              Result := ErrLineType;
          End; // Try..Finally
        End // If (IStatus = 0)
        Else
        Begin
          Result := ErrAppsValsContract;
        End; // Else
      End; // With CompObj, CompanyBtr^
    End // If CompObj.CheckSecurity (208)
    Else
    Begin
      // User not allowed to add Jobs
      Result := ErrPermit;
    End; // Else
  End; { If (Result = 0) }
End; // GetTransactionLineTypeValue

//-----------------------------------------------------------------------------

// Returns a line type total from the applications for a specified job:-
//
//   0   Normal                          9   Retention 1
//   1   Labour                          10  Retention 2
//   2   Materials                       11  Deduction 1
//   3   Freight                         12  Deduction 2
//   4   Discount                        13  Deduction 3
//   5   Materials 1                     14  CITB
//   6   Materials 2                     15  CIS
//   7   Labour 1                        16  Misc 1
//   8   Labour 2                        17  Misc 2
//
// Add 100 offset for sales (0-17 = Purchase, 100-117 = Sales)
//
Function TEnterpriseServer.GetJobLineTypeValue(Company, JobCode : String; LineType : SmallInt; Var RetValue : Double) : SmallInt;
Var
  CompObj     : TCompanyInfo;
  iStatus     : SmallInt;
  sKey        : Str255;
Begin // GetJobLineTypeValue
  Result := 0;
  RetValue := 0.00;

  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then
  Begin
    If CompObj.CheckSecurity (514{208}) Then   { Job Records, View Totals }
    Begin
      With CompObj, CompanyBtr^ Do
      Begin
        // Validate Job Code
        JobCode := UpperCase(FullJobCode(JobCode));
        If GetJobRec (CompanyBtr, JobCode) Then
        Begin
          // Build Line Type cache
          If Not Assigned(JobLineTypeCache) Then
          Begin
            JobLineTypeCache := TAppValLineTypeAnalysisCache.Create;
          End; // If Not Assigned(JobLineTypeCache)
          If (LineType >= 100) Then
          Begin
            // Sales Applications
            JobLineTypeCache.BuildJobTotals(ltmJobSalesTotals, CompanyBtr, JobCode);
          End // If (LineType >= 100)
          Else
          Begin
            // Purchase Applications
            JobLineTypeCache.BuildJobTotals(ltmJobPurchaseTotals, CompanyBtr, JobCode);
          End; // Else

          Try
            RetValue := JobLineTypeCache.ltaTotal [LineType Mod 100];
          Except
            On Exception Do
              Result := ErrLineType;
          End; // Try..Finally
        End // If GetJobRec (CompanyBtr, JobCode)
        Else
        Begin
          Result := ErrJobCode;
        End; // Else
      End; // With CompObj, CompanyBtr^
    End // If CompObj.CheckSecurity (208)
    Else
    Begin
      // User not allowed to add Jobs
      Result := ErrPermit;
    End; // Else
  End; { If (Result = 0) }
End; // GetJobLineTypeValue

//-----------------------------------------------------------------------------


// HM 08/08/03: Not needed at this time as the EntJCSaveAnalBudget function can be used
//// Creates a new Analysis Budget record for the specified Job
//Function TEnterpriseServer.AddJobAnalBudgie (Const Company      : String;
//                                             Const JobCode      : String;    // Code for existing job
//                                             Const AnalysisCode : String;    // Analysis Code
//                                             Const BudgetAmt    : Double;    // Budget Amount
//                                             Const BudgetQty    : Double;    // Qudget Quantity
//                                             Var   ErrString    : String     // Error Text for error 599
//                                            ) : SmallInt;
//Var
//  CompObj     : TCompanyInfo;
//  lBudgetDets : JobBudgType;
//  lStatus     : SmallInt;
//
//  //------------------------------
//
//  // Validates the parameters passed in for the new Job Record, returns 0 if
//  // successful else returns an OLE Server error code
//  Function ValidateBudgie : SmallInt;
//  Var
//    I   : Byte;
//  Begin // ValidateBudgie
//    Result := 0;
//
//    For I := 1 To 3 Do
//      With CompObj, CompanyBtr^ Do
//      Begin
//        Case I Of
//          1  : Begin // Job Code - must be set and must be a valid job of type job
//                 lBudgetDets.JobCode := FullJobCode(UpperCase(JobCode));
//                 If (Trim(lBudgetDets.JobCode) <> '') Then
//                 Begin
//                   // Parent Code set - get record and check type
//                   If GetJobRec(CompanyBtr, lBudgetDets.JobCode) Then
//                   Begin
//                     If (LJobRec.JobType = JobJobCode) Then
//                     Begin
//                       // Copy info in from Job record
//
//
//                     End // If (LJobRec.JobType = JobJobCode)
//                     Else Begin
//                       // Job Code must be a Job
//                       Result := ErrInternalErr;
//                       ErrString := 'The Job must be a Job and not a Contract';
//                     End; // If (LJobRec.JobType <> JobGrpCode)
//                   End // If GetJobRec(CompanyBtr^, lJobDets.JobCat)
//                   Else
//                     // Specified Job Code doesn't exist
//                     Result := ErrJobCode;
//                 End // If (Trim(lJobDets.JobCat) <> '')
//                 Else
//                   // Specified Job Code is blank
//                   Result := ErrJobCode;
//               End; // Job Code
//
//          2  : Begin // Analysis Code
//                 lBudgetDets.AnalCode := FullJACode(UpperCase(AnalysisCode));
//                 If (Trim(lBudgetDets.AnalCode) <> '') Then
//                 Begin
//                   If GetJobMiscRec (CompanyBtr, lBudgetDets.AnalCode, 2) Then
//                   Begin
//                     // Copy info in from Analysis Code record
//
//
//                   End // If GetJobMiscRec (CompanyBtr, lBudgetDets.AnalCode, 2)
//                   Else
//                     // Anal Code must be set and exist
//                     Result := ErrJobAnal;
//                 End // If (Trim(lBudgetDets.AnalCode) <> '')
//                 Else
//                   // Anal Code must be set and exist
//                   Result := ErrJobAnal;
//               End;
//
//          3  : Begin // Budget Value & Qty
//
//               End; // Budget Value & Qty
//        End; // Case I
//
//        If (Result <> 0) Then
//          Break;
//      End; // With CompObj, CompanyBtr^
//  End; // ValidateBudgie
//
//  //------------------------------
//
//Begin // AddJobAnalBudgie
//  Result := 0;
//  ErrString := '';
//
//  // Create and initialise the structures for storing the processed details
//  FillChar (lBudgetDets, SizeOf(lBudgetDets), #0);
//
//  Result := BtrList.OpenSaveCompany (Company, CompObj);
//  If (Result = 0) Then
//  Begin
//    If CompObj.CheckSecurity (212) Then
//      With CompObj, CompanyBtr^ Do
//      Begin
//        // Check for Period Budgetting
//        If (Not LSyssJob.JobSetup.PeriodBud) Then
//        Begin
//          // Validate Analysis Budget fields
//          Result := ValidateBudgie;
//
//          If (Result = 0) Then
//          Begin
//            // Fill out the details
//            FillChar (LJobCtrl^, SizeOf(LJobCtrl^), #0);
//            With LJobCtrl^ Do
//            Begin
//              RecPfix := JBRCode;
//              SubType := JBBCode;
//
//              JobBudg := lBudgetDets;
//              With JobBudg Do
//              Begin
//
//                //BudgetCode := FullJBCode(JobCode, 0{TheCcy}, AnalCode);
//              End; // With JobBudg
//            End; // With LJobCtrl^
//
//            // Add the job
//            lStatus := 99;//LAdd_Rec (JobF, JobCodeK);
//            If LStatusOk Then
//              // Create analysis budget headings etc...
//              //LCheck_JMajorHed(lJobRec^)
//            Else
//              Result := ErrBtrBase + LStatus;
//          End; // If (Result = 0)
//        End // If (Not LSyssJob.JobSetup.PeriodBud)
//        Else Begin
//          Result := ErrInternalErr;
//          ErrString := 'This function cannot be used with Job Costing Period Budgeting';
//        End; // Else
//      End // With CompObj, CompanyBtr
//    Else
//      // User not allowed to add Jobs
//      Result := ErrPermit;
//  End; { If (Result = 0) }
//End; // AddJobAnalBudgie

//-----------------------------------------------------------------------------

// Returns a string from the Location item identified by MiscStrNo:-
//
//   1     Name
//   2     Address Line 1
//   3     Address Line 2
//   4     Address Line 3
//   5     Address Line 4
//   6     Address Line 5
//
Function TEnterpriseServer.GetLocationMiscStr (      Company, LocCode : String;
                                               Const MiscStrNo        : SmallInt;
                                               Var   MiscStr          : String) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin
  Result := 0;
  MiscStr := '';

  // Load Company Data
  If BtrList.OpenCompany (Company, CompObj) Then
  Begin
    If CompObj.CheckSecurity (489) Then
    Begin
      With CompObj, CompanyBtr^ Do
      Begin
        LocCode := UpperCase(Trim(LocCode));
        If (LocCode <> '') Then
        Begin
          // Get Location Record
          If GetLocRec (CompanyBtr, LocCode) Then
          Begin
            { Got Location }
            LocCode := LMLoc^.MLocLoc.loCode;

            Case MiscStrNo Of
              // Name
              1    : MiscStr := LMLoc^.MLocLoc.loName;
              // Address
              2..6 : MiscStr := LMLoc^.MLocLoc.loAddr[MiscStrNo-1];
              // Contact
              7    : MiscStr := LMLoc^.MLocLoc.loContact;
              // Phone
              8    : MiscStr := LMLoc^.MLocLoc.loTel;
              // Fax
              9    : MiscStr := LMLoc^.MLocLoc.loFax;
              // Modem
              10   : MiscStr := LMLoc^.MLocLoc.loModem;
              // Email
              11   : MiscStr := LMLoc^.MLocLoc.loEmail;
              // CC
              12   : MiscStr := LMLoc^.MLocLoc.loCCDep[BOn];
              // Dept
              13   : MiscStr := LMLoc^.MLocLoc.loCCDep[BOff];
              // Override Sales Prices
              14   : MiscStr := IfThen (LMLoc^.MLocLoc.loUsePrice, 'Yes', 'No');
              // Override Cost Price
              15   : MiscStr := IfThen (LMLoc^.MLocLoc.loUseCPrice, 'Yes', 'No');
              // Override Re-Order Price
              16   : MiscStr := IfThen (LMLoc^.MLocLoc.loUseRPrice, 'Yes', 'No');
              // Override CC/Dept
              17   : MiscStr := IfThen (LMLoc^.MLocLoc.loUseCCDep, 'Yes', 'No');
              // Override Supplier
              18   : MiscStr := IfThen (LMLoc^.MLocLoc.loUseSupp, 'Yes', 'No');
              // Override GL Codes
              19   : MiscStr := IfThen (LMLoc^.MLocLoc.loUseNom, 'Yes', 'No');
            End; { Case }
          End // If GetLocRec (CompanyBtr, LocCode)
          Else
            Result := ErrLoc;
        End // If (LocCode <> '')
        Else
          Result := ErrLoc;
      End; // With CompObj, CompanyBtr^
    End // If CompObj.CheckSecurity (489)
    Else
      Result := ErrPermit;
  End // If BtrList.OpenCompany (Company, CompObj)
  Else
    Result := ErrComp;
End;

//------------------------------

// Returns an integer from the Location item identified by MiscIntNo:-
Function TEnterpriseServer.GetLocationMiscInt (      Company, LocCode : String;
                                               Const MiscIntNo        : SmallInt;
                                               Var   MiscInt          : LongInt) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin
  Result := 0;

  // Load Company Data
  If BtrList.OpenCompany (Company, CompObj) Then
  Begin
    If CompObj.CheckSecurity (489) Then
    Begin
      With CompObj, CompanyBtr^ Do
      Begin
        LocCode := UpperCase(Trim(LocCode));
        If (LocCode <> '') Then
        Begin
          // Get Location Record
          If GetLocRec (CompanyBtr, LocCode) Then
          Begin
            { Got Location }
            LocCode := LMLoc^.MLocLoc.loCode;

            Case MiscIntNo Of
              // Sales GL
              1  : MiscInt := LMLoc.MLocLoc.loNominal[1];
              // Cost Of Sales GL
              2  : MiscInt := LMLoc.MLocLoc.loNominal[2];
              // Closing Stk/Write Offs
              3  : MiscInt := LMLoc.MLocLoc.loNominal[3];
              // Stock Value GL
              4  : MiscInt := LMLoc.MLocLoc.loNominal[4];
              // BOM/Finished Goods
              5  : MiscInt := LMLoc.MLocLoc.loNominal[5];
              // WOP WIP GL
              6  : MiscInt := LMLoc.MLocLoc.loWOPWIPGL;
              // Purchase Return GL
              7  : MiscInt := LMLoc.MLocLoc.loPReturnGL;
              // Sales Return GL
              8  : MiscInt := LMLoc.MLocLoc.loReturnGL;
            End; { Case }
          End // If GetLocRec (CompanyBtr, LocCode)
          Else
            Result := ErrLoc;
        End // If (LocCode <> '')
        Else
          Result := ErrLoc;
      End; // With CompObj, CompanyBtr^
    End // If CompObj.CheckSecurity (489)
    Else
      Result := ErrPermit;
  End // If BtrList.OpenCompany (Company, CompObj)
  Else
    Result := ErrComp;
End;

//------------------------------

// Updates a string on the Location record with the item being identified by MiscStrNo:-
Function TEnterpriseServer.SaveLocationMiscStr (      Company, LocCode : String;
                                                Const MiscStrNo        : SmallInt;
                                                      NewStr           : String) : SmallInt;
Type
  TUpdateTypes = (updNone, updCCDept, updGL);

Var
  CompObj        : TCompanyInfo;
  KeyR, KeyS     : Str255;
  GlobLocked, OK : Boolean;
  UpdateType     : TUpdateTypes;
  OrigVal        : Boolean;

  //------------------------------

  // Updates the Stock-Location records for a specified location with updated details
  Function UpdateStkLocRecs (Const LocRec : MLocLocType; Const UpdType : TUpdateTypes) : SmallInt;
  Const
    Fnum     =  MLocF;
    Keypath  =  MLSecK;
  Var
    LocDets      : MLocLocType;
    KeyS, KeyChk : Str255;
    LOk, Locked  : Boolean;
    lStatus      : SmallInt;
  Begin // UpdateStkLocRecs
    Result := 0;
    LocDets := LocRec;

    With CompObj.CompanyBtr^ Do
    Begin
      KeyChk := PartCCKey(CostCCode,CSubCode[BOff]) + LocDets.loCode;
      KeyS:=KeyChk;

      lStatus := LFind_Rec(B_GetGEq, Fnum, Keypath, KeyS);

      While (lStatus = 0) and CheckKey(KeyChk, KeyS, Length(KeyChk), BOff) Do
      Begin
        // Lock record
        LOk := LGetMultiRec (B_GetDirect, B_MultLock, KeyS, KeyPath, Fnum, BOn, Locked);
        If (LOk) and (Locked) then
        Begin
          // Get position - LAddr isn't used but this primes internal vars used by LUnlockMLock
          LGetRecAddr(FNum);

          Case UpdType Of
            updCCDept : Begin
                          LMLocCtrl^.MStkLoc.lsCCDep := LocDets.loCCDep;
                        End; // updCCDept
            updGL     : Begin
                          LMLocCtrl^.MStkLoc.lsDefNom    := LocDets.loNominal;
                          LMLocCtrl^.MStkLoc.lsWOPWIPGL  := LocDets.loWOPWIPGL;
                          LMLocCtrl^.MStkLoc.lsReturnGL  := LocDets.loReturnGL;
                          LMLocCtrl^.MStkLoc.lsPReturnGL := LocDets.loPReturnGL;
                        End; // updGL
          End; // Case UpdType

          // Update record and free lock
          lStatus := LPut_Rec(Fnum, KeyPath);

          LUnlockMLock(FNum);
        End; // If (LOk) and (Locked)

        lStatus := LFind_Rec(B_GetNext, Fnum, Keypath, KeyS);
      End; // While (lStatus = 0)) and (CheckKey(KeyChk, KeyS, Length(KeyChk), BOff))
    End; // With CompObj.CompanyBtr^
  End; // UpdateStkLocRecs

  //------------------------------

  Function ValidateYesNo(Const NewStr : ShortString; Var BoolRes : Boolean) : SmallInt;
  Begin // ValidateYesNo
    If (NewStr = 'Y') Or (NewStr = 'YES') Or (NewStr = 'N') Or (NewStr = 'NO') Then
    Begin
      Result := 0;
      BoolRes := (NewStr = 'Y') Or (NewStr = 'YES');
    End // If (NewStr = 'Y') Or (NewStr = 'YES') Or (NewStr = 'N') Or (NewStr = 'NO')
    Else
      Result := ErrValue;
  End; // ValidateYesNo

  //------------------------------

Begin
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then
  Begin
    If CompObj.CheckSecurity (491{111}) Then
    Begin
      With CompObj, CompanyBtr^ Do
      Begin
        LocCode := Trim(UpperCase(LocCode));

        KeyS := PartCCKey(CostCCode, CSubCode[True]) + Full_MLocKey(LocCode);
        KeyR := KeyS;

        LStatus:=LFind_Rec(B_GetGEq,MLocF,MLK,KeyS);
        If LStatusOk And CheckKey(KeyR,KeyS,Length(KeyR),BOn) Then
        Begin
          { found - get rec and update }
          GLobLocked:=BOff;
          Ok := LGetMultiRec(B_GetEq,B_MultLock,KeyS,MLK,MLocF,BOn,GlobLocked);
          LGetRecAddr(MLocF);

          If OK And GlobLocked Then
          Begin
            UpdateType := updNone;

            Case MiscStrNo Of
              // Name
              1    : LMLocCtrl.MLocLoc.loName := NewStr;
              // Address
              2..6 : LMLocCtrl.MLocLoc.loAddr[MiscStrNo-1] := NewStr;
              // Contact
              7    : LMLocCtrl.MLocLoc.loContact := NewStr;
              // Phone
              8    : LMLocCtrl.MLocLoc.loTel := NewStr;
              // Fax
              9    : LMLocCtrl.MLocLoc.loFax := NewStr;
              // Modem
              10   : LMLocCtrl.MLocLoc.loModem := NewStr;
              // Email
              11   : LMLocCtrl.MLocLoc.loEmail := NewStr;
              // CC / Dept
              12,13: Begin
                       If LMLocCtrl.MLocLoc.loUseCCDep Then
                       Begin
                         NewStr := UpperCase(Trim(NewStr));
                         If (NewStr <> '') Then
                         Begin
                           If GetCCDepRec (CompObj.CompanyBtr, NewStr, (MiscStrNo=12)) Then
                           Begin
                             If (LMLocCtrl.MLocLoc.loCCDep[(MiscStrNo = 12)] <> LPassword.CostCtrRec.PCostC) Then UpdateType := updCCDept;
                             LMLocCtrl.MLocLoc.loCCDep[(MiscStrNo = 12)] := LPassword.CostCtrRec.PCostC;
                           End // If GetCCDepRec (CompObj.CompanyBtr, NewStr, (MiscStrNo=12))
                           Else
                             Result := IfThen(MiscStrNo = 12, ErrCC, ErrDept);
                         End // If (NewStr <> '')
                         Else
                           { Blank Department/Cost Centre }
                           LMLocCtrl.MLocLoc.loCCDep[(MiscStrNo = 12)] := Full_MLocKey('');
                       End // If LMLocCtrl.MLocLoc.loUseNom
                       Else
                         Result := ErrStkLocDis;
                     End; // CC / Dept
              // Override Sales Prices
              14   : Begin
                       NewStr := UpperCase(Trim(NewStr));
                       If (NewStr <> '') Then
                         Result := ValidateYesNo(NewStr, LMLocCtrl.MLocLoc.loUsePrice)
                       Else
                         Result := ErrValue;
                     End; // // Override Sales Prices
              // Override Cost Price
              15   : Begin
                       NewStr := UpperCase(Trim(NewStr));
                       If (NewStr <> '') Then
                         Result := ValidateYesNo(NewStr, LMLocCtrl.MLocLoc.loUseCPrice)
                       Else
                         Result := ErrValue;
                     End; // // Override Cost Price
              // Override Re-Order Price
              16   : Begin
                       NewStr := UpperCase(Trim(NewStr));
                       If (NewStr <> '') Then
                         Result := ValidateYesNo(NewStr, LMLocCtrl.MLocLoc.loUseRPrice)
                       Else
                         Result := ErrValue;
                     End; // // Override Re-Order Price
              // Override CC/Dept
              17   : Begin
                       NewStr := UpperCase(Trim(NewStr));
                       If (NewStr <> '') Then
                         Result := ValidateYesNo(NewStr, LMLocCtrl.MLocLoc.loUseCCDep)
                       Else
                         Result := ErrValue;
                     End; // // Override CC/Dept
              // Override Supplier
              18   : Begin
                       NewStr := UpperCase(Trim(NewStr));
                       If (NewStr <> '') Then
                         Result := ValidateYesNo(NewStr, LMLocCtrl.MLocLoc.loUseSupp)
                       Else
                         Result := ErrValue;
                     End; // // Override Supplier
              // Override GL Codes
              19   : Begin
                       NewStr := UpperCase(Trim(NewStr));
                       If (NewStr <> '') Then
                       Begin
                         OrigVal := LMLocCtrl.MLocLoc.loUseNom;
                         Result := ValidateYesNo(NewStr, LMLocCtrl.MLocLoc.loUseNom);
                         If (Result = 0) And (OrigVal <> LMLocCtrl.MLocLoc.loUseNom) And LMLocCtrl.MLocLoc.loUseNom Then
                           UpdateType := updGL;
                       End // If (NewStr <> '')
                       Else
                         Result := ErrValue;
                   End; // // Override GL Codes
            End; // Case MiscStrNo

            // Check for validation errors before updating
            If (Result = 0) Then
            Begin
              { update existing record }
              LStatus := LPut_Rec (MLocF, MLK);
            End; // If (Result = 0)

            { Unlock record}
            LUnlockMLock(MLocF);

            If (Result = 0) Then
            Begin
              If (LStatus = 0) Then
              Begin
                Result := 0;

                { Update duplicate Stock/Location record }
                LMLoc^ := LMLocCtrl^;
                LMStkLoc^ := LMLocCtrl^;

                If (UpdateType <> updNone) Then
                Begin
                  Result := UpdateStkLocRecs (LMLoc^.MLocLoc, UpdateType);
                End; // If (UpdateType <> updNone)
              End // If (LStatus = 0)
              Else
                Result := ErrBtrBase + LStatus;
            End; // If (Result = 0)
          End // If OK And GlobLocked
          Else
            Result := ErrRecLock;
        End // If LStatusOk And CheckKey(KeyR,KeyS,Length(KeyR),BOn)
        Else
          Result := ErrLoc;
      End; // With CompObj, CompanyBtr^
    End { If }
    Else
      Result := ErrPermit;
  End; { If (Result = 0) }
End;

//------------------------------

// Updates an integer on the Location record with the item being identified by MiscIntNo
Function TEnterpriseServer.SaveLocationMiscInt (      Company, LocCode : String;
                                                Const MiscIntNo        : SmallInt;
                                                      NewInt           : LongInt) : SmallInt;
Var
  CompObj        : TCompanyInfo;
  KeyR, KeyS     : Str255;
  GlobLocked, OK : Boolean;
Begin
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  If (Result = 0) Then
  Begin
    If CompObj.CheckSecurity (491{111}) Then
    Begin
      With CompObj, CompanyBtr^ Do
      Begin
        LocCode := Trim(UpperCase(LocCode));

        KeyS := PartCCKey(CostCCode, CSubCode[True]) + Full_MLocKey(LocCode);
        KeyR := KeyS;

        LStatus:=LFind_Rec(B_GetGEq,MLocF,MLK,KeyS);
        If LStatusOk And CheckKey(KeyR,KeyS,Length(KeyR),BOn) Then
        Begin
          { found - get rec and update }
          GLobLocked:=BOff;
          Ok := LGetMultiRec(B_GetEq,B_MultLock,KeyS,MLK,MLocF,BOn,GlobLocked);
          LGetRecAddr(MLocF);

          If OK And GlobLocked Then
          Begin
            Case MiscIntNo Of
              // GL Codes
              1..8  : Begin
                        If LMLocCtrl.MLocLoc.loUseNom Then
                        Begin
                          If GetNominalRec(CompObj.CompanyBtr, NewInt) And (LNom.NomType In ['A', 'B']) Then
                          Begin
                            Case MiscIntNo Of
                              // Sales GL
                              1  : LMLocCtrl.MLocLoc.loNominal[1] := NewInt;
                              // Cost Of Sales GL
                              2  : LMLocCtrl.MLocLoc.loNominal[2] := NewInt;
                              // Closing Stk/Write Offs
                              3  : LMLocCtrl.MLocLoc.loNominal[3] := NewInt;
                              // Stock Value GL
                              4  : LMLocCtrl.MLocLoc.loNominal[4] := NewInt;
                              // BOM/Finished Goods
                              5  : LMLocCtrl.MLocLoc.loNominal[5] := NewInt;
                              // WOP WIP GL
                              6  : LMLocCtrl.MLocLoc.loWOPWIPGL := NewInt;
                              // Purchase Return GL
                              7  : LMLocCtrl.MLocLoc.loPReturnGL := NewInt;
                              // Sales Return GL
                              8  : LMLocCtrl.MLocLoc.loReturnGL := NewInt;
                            End; // Case MiscIntNo
                          End // If GetNominalRec(CompObj.CompanyBtr, NewInt) And (LNom.NomType In ['A', 'B'])
                          Else
                            Result := ErrNom;  { invalid GL Code }
                        End // If LMLocCtrl.MLocLoc.loUseNom
                        Else
                          Result := ErrStkLocDis;
                      End; // // GL Codes
            End; // Case MiscIntNo

            // Check for validation errors before updating
            If (Result = 0) Then
            Begin
              { update existing record }
              LStatus := LPut_Rec (MLocF, MLK);
            End; // If (Result = 0)

            { Unlock record}
            LUnlockMLock(MLocF);

            If (Result = 0) Then
            Begin
              If (LStatus = 0) Then
              Begin
                Result := 0;

                { Update duplicate Stock/Location record }
                LMLoc^ := LMLocCtrl^;
                LMStkLoc^ := LMLocCtrl^;
              End // If (LStatus = 0)
              Else
                Result := ErrBtrBase + LStatus;
            End; // If (Result = 0)
          End // If OK And GlobLocked
          Else
            Result := ErrRecLock;
        End // If LStatusOk And CheckKey(KeyR,KeyS,Length(KeyR),BOn)
        Else
          Result := ErrLoc;
      End; // With CompObj, CompanyBtr^
    End { If }
    Else
      Result := ErrPermit;
  End; { If (Result = 0) }
End;

//-------------------------------------------------------------------------

{$IFDEF FUNCWIZ}
{ Displays a modal function wizard dialog }
Function TEnterpriseServer.DispFuncWizard (Var WizStr : String) : SmallInt;
var
  frmFunctionWizard: TfrmFunctionWizard;
Begin { DispFuncWizard }
  Result := 0;
  WizStr := 'DispFuncWizard';

  frmFunctionWizard := TfrmFunctionWizard.Create(Application.MainForm);
  Try

    frmFunctionWizard.ShowModal;

  Finally
    frmFunctionWizard.Free;
  End;
End;  { DispFuncWizard }
{$ENDIF}

Function TEnterpriseServer.SelectData (Var DataString : String; Var DataType : SmallInt) : SmallInt;
Var
  Tmp  : String;
  I    : SmallInt;
Begin { SelectData }
  Result := 0;

  Tmp := '';
  If (Length(DataString) > 0) Then
    For I := Length(DataString) DownTo 1 Do
      Tmp := Tmp + DataString[I];
  DataString := Tmp;
End; { SelectData }


function TEnterpriseServer.GetGLViewMiscStr(var Company: string;
  var NomViewNo: LongInt; var ViewCode: string; var StrNo: SmallInt;
  var RetStr: string): SmallInt;
var
  CompObj : TCompanyInfo;
const
  msAltCode = 1;
  msDesc    = 2;
begin
  Result := 0;
  RetStr := '';
  { Load Company Data }
  if BtrList.OpenCompany (Company, CompObj) then
  begin
    if CompObj.CheckSecurity (567) then
    begin
      { Get G/L View Record }
      if GetGLViewRec(CompObj.CompanyBtr, NomViewNo, ViewCode) then
      begin
        case StrNo of
          msAltCode: RetStr := CompObj.CompanyBtr.LNomView^.NomViewLine.AltCode;
          msDesc:    RetStr := CompObj.CompanyBtr.LNomView^.NomViewLine.Desc;
        end;
      end
      else
        Result := ErrNom;
    end
    else
      Result := ErrPermit;
  end { If }
  else
    Result := ErrComp;
end;

function TEnterpriseServer.GetGLViewRec(BtrObj: TdPostExLocalPtr;
  const NomViewNo: LongInt; const ViewCode: string): Boolean;
var
  Key: Str255;
  FuncRes: Integer;
begin
  with BtrObj^ do
  begin
    { Check to see if the record is loaded }
    if (LNomView^.NomViewLine.NomViewNo <> NomViewNo) or
       (Trim(LNomView^.NomViewLine.ViewCode) <> Trim(ViewCode)) then
    begin
      { Record not loaded - Load now }
      Key := FullNVCode(NVRCode, NVVSCode, NomViewNo, ViewCode, True);
      FuncRes := LFind_Rec(B_GetEq, NomViewF, NVCodeK, Key);

      Result := (FuncRes = 0);

      if (not Result) then
        LResetRec(NomViewF);

    end
    else
      { Record already loaded }
      Result := True;
  end;
end;

function TEnterpriseServer.GetGLViewValue(
  var Mode: SmallInt;
  var Company: String;
  var TheYear, ThePeriod, TheCcy: SmallInt;
  var NomViewNo: Integer;
  var ViewCode: String;
  var NomValue: Double): SmallInt;
var
  Key        : Str255;
  DicLink    : DictLinkType;
  CompObj    : TCompanyInfo;
  IsCC       : Boolean;
  PrYrMode   : Byte;
  BaseOffset : Double;
  NYear, nPeriod : SmallInt;
  CCDept     : CCDepType;
  NomCode    : Integer;
  ABSViewIdx : Integer;
//  NomCC, NomDept, NomCDType: string;

  { HM 18/3/99: Copied from code supplied by EL from Enterprise }
  { ==== Procedure to check if nom is being added into the P&L section ==== }
  function In_PandL(GLCat  :  LongInt)  :  Boolean;
  const
    Fnum     =  NomF;
    Keypath  =  NomCodeK;
  var
    KeyS, KeyChk         : Str255;
    FoundOk              : Boolean;
    TmpKPath             : Integer;
    TmpRecAddr, PALStart : LongInt;
    TmpNom               : ^NominalRec;
  begin { In_PandL }
    with CompObj, CompanyBtr^ do
    begin
      { Save record and position }
      New (TmpNom);
      TmpNom^:=LNom;
      TmpKPath:=GetPosKey;
      LPresrv_BTPos(NomF, TmpKPath, F[NomF], TmpRecAddr, BOff, BOff);

      PALStart:=LSyss.NomCtrlCodes[PLStart];

      FoundOK:=(GLCat=PALStart);

      if (not FoundOk) then
      begin
        KeyChk := FullNomKey(GLCat);
        KeyS   := KeyChk;
        Status := LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);
        while ((StatusOk) and (not FoundOk)) do
          with LNom do
          begin
            FoundOk:=(Cat=PALStart);
            if (not FoundOk) then
            begin
              KeyChk := FullNomKey(Cat);
              KeyS   := KeyChk;
              Status := LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);
            end; { if not FoundOk... }
          end; { with LNom do... }
      end; { if (not FoundOk)... }

      { Restore Record and position }
      LPresrv_BTPos(NomF,TmpKPath,F[NomF],TmpRecAddr,BOn,BOff);
      LNom := TmpNom^;
      Dispose (TmpNom);

      Result := FoundOk;
    end; { with CompObj, CompanyBtr^ do... }
  end; { function In_PandL... }

begin
  Result   := 0;
  NomValue := 0.0;

  { Load Company Data }
  if BtrList.OpenCompany(Company, CompObj) then
  begin
    if CompObj.CheckSecurity(567) then
    begin
      if GetGLViewRec(CompObj.CompanyBtr, NomViewNo, ViewCode) then
      begin
        NomCode      := CompObj.CompanyBtr^.LNomView.NomViewLine.LinkGL;
        ABSViewIdx   := CompObj.CompanyBtr^.LNomView.NomViewLine.ABSViewIdx;

        CCDept[BOff] := FullCCDepKey(CompObj.CompanyBtr^.LNomView.ViewCtrl.LinkCCDep[BOff]);
        CCDept[BOn]  := FullCCDepKey(CompObj.CompanyBtr^.LNomView.ViewCtrl.LinkCCDep[BOn]);

//        NomCC   := CCDept[BOn];
//        NomDept := CCDept[BOff];
        IsCC    := (Trim(CCDept[BOn]) <> '');

        { Check Cost Centre Code, if set. }
        if (Trim(CCDept[BOn]) <> '') then
          if not GetCCDepRec(CompObj.CompanyBtr, CCDept[BOn], True) then
            Result := ErrCC;

        { Check Department Code, if set. }
        if ((Result = 0) and (Trim(CCDept[BOff]) <> '')) then
          if not GetCCDepRec(CompObj.CompanyBtr, CCDept[BOff], False) then
            Result := ErrDept;

        if (Result = 0) then
        begin
          BaseOffset := 0.0;
          with CompObj, CompanyBtr^ do
          begin
            { HM 25/05/00: Ignore for budgets as budgets are not accumulated in this way. }
            if (Mode <> 1) and (Mode <> 2) then
            begin
              if (ThePeriod >= 101) and (ThePeriod <= 199) and (LNom.NomType <> PLNHCode) and (Mode > 2) then
              begin
                { Subtract YTD last year for balance sheet and control codes,
                  for headers check that its not in the P&L section before
                  subtracting. }
                if (LNom.NomType in [BankNHCode, CtrlNHCode]) or ((LNom.NomType = NomHedCode) and (not In_PandL(NomCode))) then
                begin
                   { CTD Period Offset - need to get rid of previous years YTD
                     total which is carried forward. }
                   NYear   := Pred(TheYear);
                   nPeriod := 0;
                   GetGLViewValue(Mode,
                                  Company,
                                  nYear,
                                  nPeriod,
                                  TheCcy,
                                  NomViewNo,
                                  ViewCode,
                                  BaseOffset
                                 );
                end; { if (LNom.NomType in... }
              end; { if (ThePeriod >= 101)... }
            end; { if (Mode <> 1) and (Mode <> 2) then... }
          end; { with CompObj, CompanyBtr^ do... }

          Key := CalcCCKeyHistP(NomCode, IsCC, CalcCCDepKey(IsCC, CCDept));

          BuildDicLink(CompObj, DicLink, ThePeriod, TheYear, TheCcy, PrYrMode);

          with CompObj, CompanyBtr^ do
          begin
            case Mode of
              { Budget1 }
              1 : NomValue := GetGLViewStats(NomViewNo, ABSViewIdx, 4, LNomView.NomViewLine.ViewType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
              { Budget2 }
              2 : NomValue := GetGLViewStats(NomViewNo, ABSViewIdx, 5, LNomView.NomViewLine.ViewType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
              { Actual (balance, 5-4) }
              3 : NomValue := GetGLViewStats(NomViewNo, ABSViewIdx, 3, LNomView.NomViewLine.ViewType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
              { Debit }
              4 : NomValue := GetGLViewStats(NomViewNo, ABSViewIdx, 1, LNomView.NomViewLine.ViewType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
              { Credit }
              5 : NomValue := GetGLViewStats(NomViewNo, ABSViewIdx, 2, LNomView.NomViewLine.ViewType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
              { Cleared }
              6 : NomValue := GetGLViewStats(NomViewNo, ABSViewIdx, 6, LNomView.NomViewLine.ViewType, DicLink, CompanyBtr, PrYrMode) - BaseOffset;
            end; { case Mode of... }
          end; { with CompObj, CompanyBtr^ do... }
        end; { if Result = 0... }
      end { if GetGLViewRec... }
      else
        { Invalid nominal code }
        Result := ErrNom;
    end { if CompObj.CheckSecurity... }
    else
      Result := ErrPermit;
  end { if BtrList.OpenCompany... }
  else
    { Invalid Company }
    Result := ErrComp;
end;

function TEnterpriseServer.GetGLViewLinkCode(var Company: string;
  var NomViewNo: integer; var ViewCode: string; var RetCode: Integer): SmallInt;
var
  CompObj: TCompanyInfo;
begin
  Result := 0;

  { Load Company Data }
  if BtrList.OpenCompany(Company, CompObj) then
  begin
    if CompObj.CheckSecurity(567) then // Change to 567 when correct permissions for GL Views are installed.
    begin
      if GetGLViewRec(CompObj.CompanyBtr, NomViewNo, ViewCode) then
      begin
        RetCode := CompObj.CompanyBtr^.LNomView.NomViewLine.LinkGL;
      end
      else
        { Invalid nominal code }
        Result := ErrNom;
    end { if CompObj.CheckSecurity... }
    else
      Result := ErrPermit;
  end { if BtrList.OpenCompany... }
  else
    { Invalid Company }
    Result := ErrComp;

end;

function TEnterpriseServer.SaveGLViewMiscStr(var Company: String;
  var NomViewNo: Integer; var ViewCode: string; var MiscStrNo: SmallInt;
  var NewStr: String): SmallInt;
const
  FNum  = NomViewF;
  KPath = NVCodeK;
var
  Key     : Str255;
  RecAddr : LongInt;
  CompObj : TCompanyInfo;
begin
  { Load Company Data }
  Result := BtrList.OpenSaveCompany (Company, CompObj);
  if (Result = 0) then
  begin
    if CompObj.CheckSecurity (567) then
    begin
      if GetGLViewRec(CompObj.CompanyBtr, NomViewNo, ViewCode) then
      begin
        with CompObj, CompanyBtr^ do
        begin
          { Found - get rec and update }
          GlobLocked := BOff;
          Key := FullNVCode(NVRCode, NVVSCode, NomViewNo, ViewCode, True);
          Ok := LGetMultiRec(B_GetEq, B_MultLock, Key, KPath, Fnum, BOn, GlobLocked);
          LGetRecAddr(FNum);
          if (OK and GlobLocked) then
          begin
            with LNomView.NomViewLine do
              case MiscStrNo of
                1: AltCode := UpcaseStr(LJVar(NewStr, Pred(SizeOf(AltCode))));
                2: begin
                     Desc := NewStr;
                     AutoDesc := False;
                   end;
              end; { case MiscStrNo... }

            LStatus := LPut_Rec(Fnum, KPath);

            { Unlock record}
            LUnlockMLock(FNum);

            if (Result = 0) then
            begin
              if (LStatus = 0) then
                Result := 0
              else
                Result := ErrBtrBase + LStatus;
            end; { if (Result = 0)... }
          end { if (OK and GlobLocked)... }
          else
            Result := ErrRecLock;
        end; { with CompObj... }
      end { if GetGLViewRec... }
      else
        Result := ErrNom;
    End { If }
    Else
      Result := ErrPermit
  End; { If (Result = 0) }
end;

function TEnterpriseServer.SaveGLViewValue(var SetValue: SmallInt;
  var Company: string; var TheYear, ThePeriod, TheCcy: SmallInt;
  var NomViewNo: LongInt; var ViewCode: string;
  var NewValue: Double): SmallInt;
const
  FNum  = NHistF;
  KPath = NHK;
var
  Key       : Str255;
  CompObj   : TCompanyInfo;
  IsCC      : Boolean;
  YTDPer    : SmallInt;
  CCDept    : CCDepType;
  NewHist   : HistoryRec;
  NomVal    : Double;
  ValueReq  : SmallInt;
  GetPeriod : SmallInt;
  GetYear   : SmallInt;
  NomCode   : Integer;

  procedure UpdateRecVal;
  begin
    with CompObj.CompanyBtr^ do
      case SetValue of
        { Budget }
        1 : LNHist.Budget := NewValue;
        { Budget2 }
        2 : LNHist.RevisedBudget1 := NewValue;
      end; { Case }
  end;

begin
  if (ThePeriod > 0) then
  begin
    if (TheYear > 0) then
    begin
      { Load Company Data }
      Result := BtrList.OpenSaveCompany(Company, CompObj);
      if (Result = 0) then
      begin
        // SSK 30/08/2016 R3 ABSEXCH-12531 : Added condition to validate period
        If ValidatePeriod(ThePeriod, CompObj)  Then {Check Period against System Setup Period}
        Begin
          if CompObj.CheckSecurity (567) then
          begin
            if GetGLViewRec(CompObj.CompanyBtr, NomViewNo, ViewCode) then
            begin
              with CompObj.CompanyBtr^ do
              begin
                // HM 13/09/01: Extended to support combined CC & Dept histroy
                CCDept[BOff] := FullCCDepKey(CompObj.CompanyBtr^.LNomView.ViewCtrl.LinkCCDep[BOff]);
                CCDept[BOn]  := FullCCDepKey(CompObj.CompanyBtr^.LNomView.ViewCtrl.LinkCCDep[BOn]);

                // If this is the first pass through this routine, and both Cost
                // Centre and Department are specified in the G/L View, do the
                // Department update (the routine will recurse to do the Cost
                // Centre update).
                if FirstPass and
                   ((Trim(CCDept[BOn]) <> '') and (Trim(CCDept[BOff]) <> '')) then
                  IsCC := False
                else
                  IsCC := (Trim(CCDept[BOn]) <> '');

                NomCode := LNomView.NomViewLine.LinkGL;
                Key := FullNHistKey(LNomView.NomViewLine.ViewType,
                                    PostNVIdx(NomViewNo, LNomView.NomViewLine.ABSViewIdx),
                                    TheCcy,
                                    TheYear-1900,
                                    ThePeriod);

                if (not LCheckExsists(Key, FNum, KPath)) then
                begin
                  { Record doesn't exist - Set and Add }
                  FillChar (LNHist, SizeOf (LNHist), #0);
                  with LNHist do
                  begin
                    {Code := FullNHCode (FullNomKey(NomCode));}
                    Code := FullNHCode (CalcCCKeyHistP(NomCode, IsCC, CalcCCDepKey(IsCC, CCDept)));
                    ExClass := LNom.NomType;
                    Cr := TheCcy;
                    Yr := TheYear - 1900;
                    Pr := ThePeriod;
                  end; { with LNHList... }

                  UpdateRecVal;

                  LStatus := LAdd_Rec (Fnum, KPath);
                  if not LStatusOk then
                    Result := ErrBtrBase + LStatus;

                  { HM 01/03/00: Check for YTD entry }
                  if (LNomView.NomViewLine.ViewType in YTDSet) then
                    YTDPer := YTD
                  else
                    YTDPer := YTDNCF;
                  Key := FullNHistKey(LNomView.NomViewLine.ViewType,
                                      FullNHCode (CalcCCKeyHistP(NomCode, IsCC, CalcCCDepKey(IsCC, CCDept))),
                                      TheCcy,
                                      TheYear-1900,
                                      YTDPer);
                  if (Not LCheckExsists(Key, FNum, KPath)) then
                  begin
                    { Record doesn't exist - Set and Add }
                    FillChar (NewHist, SizeOf (NewHist), #0);
                    with NewHist do
                    begin
                      Code := FullNHCode(CalcCCKeyHistP(NomCode, IsCC, CalcCCDepKey(IsCC, CCDept)));
                      ExClass := LNom.NomType;
                      Cr := TheCcy;
                      Yr := TheYear - 1900;
                      Pr := YTDPer;

                      // HM 14/12/04: Modified to import previous years balance where appropriate
                      if (LNomView.NomViewLine.ViewType in YTDSet) then
                      begin
                        { Dr }
                        GetPeriod := 0;
                        GetYear := TheYear - 1;
                        ValueReq  := 5;
                        if (GetGLViewValue(ValueReq, Company, GetYear, GetPeriod, TheCcy, NomViewNo, ViewCode, NomVal) = 0) Then
                          Sales := NomVal;
                        {  Cr  }
                        ValueReq := 4;
                        If (GetGLViewValue(ValueReq, Company, GetYear, GetPeriod, TheCcy, NomViewNo, ViewCode, NomVal) = 0) Then
                          Purchases := NomVal;
                        { Cleared Balance for that Nominal in Cr Currency }
                        ValueReq := 6;
                        If (GetGLViewValue(ValueReq, Company, GetYear, GetPeriod, TheCcy, NomViewNo, ViewCode, NomVal) = 0) Then
                          Cleared := NomVal;
                      End; // If (LNom.NomType In YTDSet)
                    End; { With }

                    LNHist := NewHist;
                    LStatus := LAdd_Rec (Fnum, KPath);
                    if not LStatusOk then
                      Result := ErrBtrBase + LStatus;
                  end; { If (Not LCheckExsists }
                end { If }
                else
                begin
                  { found - get rec and update }
                  GlobLocked:=BOff;
                  Ok := LGetMultiRec(B_GetEq, B_MultLock, Key, KPath, Fnum, BOn, GlobLocked);

                  LGetRecAddr(FNum);

                  UpdateRecVal;

                  { update record }
                  LStatus := LPut_Rec(Fnum, KPath);

                  LUnlockMLock(FNum);
                  if not LStatusOk then
                    Result := ErrBtrBase + LStatus;
                end; { Else }

                // If this is the first time through this routine, and both the
                // Cost Centre and Department are set, we need to recurse into
                // the routine to update the Cost Centre records (the first pass
                // will update the Department records).
                if FirstPass and (Result = 0) and
                   ((Trim(CCDept[BOn]) <> '') and (Trim(CCDept[BOff]) <> '')) then
                begin
                  // Recursing, so no longer on first pass.
                  FirstPass := False;
                  // Combined Cost Centre and Department - Call again to update Cost Centre records
                  Result := SaveGLViewValue(SetValue,
                                            Company,
                                            TheYear,
                                            ThePeriod,
                                            TheCcy,
                                            NomViewNo,
                                            ViewCode,
                                            NewValue);
                  // Reset flag ready for future calls to SaveGLViewValue.
                  FirstPass := True;
                end; { if (Result = 0) and (UpperCase(Trim(NomCDType)) = 'K')... }
              end; { with CompObj.CompanyBtr^... }
            end { if GetGLViewRec... }
            else
              { Cannot load nominal }
              Result := ErrNom;
          end { if CompObj.CheckSecurity... }
          else
            Result := ErrPermit;
        End { If ValidatePeriod }
        Else
          Result := ErrPeriod;            
      end; { if (Result = 0) }
    end { if TheYear > 0... }
    else
      { Invalid Year }
      Result := ErrYear;
  end { if ThePeriod > 0... }
  else
    { Invalid Period }
    Result := ErrPeriod;
end;

//GS 31/10/2011
//method to handle adding an audit note to records that are created / edited
//via the excel OLE plugin
procedure TEnterpriseServer.WriteAuditNote(
  TypeOfRecord: TAuditNoteOwnerType;
  TypeOfModification: TAuditNoteFunction;
  CompObj : TCompanyInfo);

var
  oAuditNote : TAuditNote;
  CustomerCode: String;
  FolioNumber: LongInt;
begin

  //deterine the note record identifier by record type
  Case TypeOfRecord of
   anAccount:
   begin
     CustomerCode := CompObj.CompanyBtr.LCust.CustCode;
   end;
   anStock:
   begin
     FolioNumber := CompObj.CompanyBtr.LStock.StockFolio;
   end;
   anTransaction:
   begin
     FolioNumber := CompObj.CompanyBtr.LInv.FolioNum;
   end;
   anJob:
   begin
     FolioNumber := CompObj.CompanyBtr.LJobRec.JobFolio;
   end;
  end;

    //create an audit note object
    oAuditNote := TAuditNote.Create(EntryRec.Login, @CompObj.CompanyBtr.LocalF^[PwrdF], CompObj.CompanyBtr.ExClientID);

    //write an audit note
    if TypeOfRecord = anAccount then
    begin
      //identify note record by customer code
      oAuditNote.AddNote(TypeOfRecord, CustomerCode, TypeOfModification);
    end
    else
    begin
      //identify note record by folio number
      oAuditNote.AddNote(TypeOfRecord, FolioNumber, TypeOfModification);
    end;

    //dispose of the notes object
    FreeAndNil(oAuditNote);

end;

//-------------------------------------------------------------------------

// ABSEXCH-15479: Added new CheckUserPermission method for James' SQL add-in for H4H to force login and check user permissions
function TEnterpriseServer.CheckUserPermission(Const Company      : String;
                                               Const PermissionNo : LongInt) : SmallInt;
Var
  CompObj : TCompanyInfo;
Begin // CheckUserPermission
  If BtrList.OpenCompany (Company, CompObj) Then
  Begin
    If CompObj.CheckSecurity (PermissionNo) Then
      Result := 0
    Else
      Result := ErrPermit;
  End // If BtrList.OpenCompany (Company, CompObj)
  Else
    // Invalid Company
    Result := ErrComp;
End; // CheckUserPermission

//-------------------------------------------------------------------------

// MH 02/12/2014 ABSEXCH-15836: Added Read-Write support for new account Country fields
Function TEnterpriseServer.GetCountryName(Var CountryCode, CountryName : String) : SmallInt;
Begin // GetCountryName
  Result := 0;
  CountryName := CountryCodeName (ifCountry2, CountryCode);
End; // GetCountryName

//-------------------------------------------------------------------------
// SSK 30/08/2016 R3 ABSEXCH-12531 : Added Function to validate period
function TEnterpriseServer.ValidatePeriod(aPeriod: SmallInt;
  aCompObj: TCompanyInfo): Boolean;
begin
  ValidatePeriod := False;
  if assigned (aCompObj) then
    ValidatePeriod := not ((aPeriod < 1) Or (aPeriod > aCompObj.CompanyBtr.LSyss.PrinYr));
end;

function TEnterpriseServer.GetJobTypeName(var Company, JobTypeCode,
  JobTypeName: String): SmallInt;
Var
  CompObj    : TCompanyInfo;
  oJobCode   : TCachedDataRecord;
  GotRec     : Boolean;

begin
  Result := 0;
  JobTypeName := '';
  GotRec := false;

  { Load Company Data }
  If BtrList.OpenCompany (Company, CompObj) Then
  Begin
    If CompObj.CheckSecurity (514) Then {206}
    Begin
      GotRec := GetJobMiscRec(compobj.CompanyBtr, JobTypeCode, 1);
      if GotRec then
        JobTypeName := CompObj.CompanyBtr.LJobMisc^.JobTypeRec.JTypeName
      else
        Result := ErrJobTypeCode;
    End
    Else
      Result := ErrPermit;
  End { If OpenCompany }
  Else
    Result := ErrComp;
end;

Initialization
  RegisterOLEServer;

  Application.HelpFile := ExtractFilePath(Application.ExeName) + 'EnterOle.Chm';

  Instances := 0;
end.

