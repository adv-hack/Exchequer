unit OTrans;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE04}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     GlobVar, VarConst, VarCnst3, oBtrieve, MiscFunc,
     oCust, oAddr, oLines, oLine, oNotes, ExBtTH1U, oMatch, oViews,
     oLinks, oAuto, oB2B, GlobList, oAppView, EnterpriseBeta_TLB,
     oOrderPaymentDetails, oOrderPaymentMatching;

type

  TTransaction = class(TBtrieveFunctions, ITransaction, ITransaction2, ITransaction3, IBrowseInfo, IRecordPosition,
                         IBetaTransaction, {ITransactionBackDoor2,} ITransaction4, ITransaction5, ITransaction6,
                         ITransaction7, ITransaction8, ITransaction9, ITransaction10, ITransaction11, ITransaction12,
                         IToolkitRecord, IBetaTransaction2, IBetaTransaction3, ITransaction13, ITransaction14, ITransaction15,
                         ITransaction16)
  private
    // Transaction Object
    FTH             : TBatchTHRec;
    FTrans          : InvRec;

    // Delivery Address sub-object
    FDelAddrO       : TAddress;
    FDelAddrI       : IAddress;

    // Transaction Line Interface
    FTHLinesO       : TTransactionLines;
    FTHLinesI       : ITransactionLines;

    // Notes sub-object
    FNotesO         : TNotes;
    FNotesI         : INotes;

    // Matching sub-object
    FMatchingO      : TMatching;
    FMatchingI      : IMatching2;

    // Order Payments sub-object
    FOrderPaymentsO : TTransactionOrderPaymentDetailsList;
    FOrderPaymentsI : ITransactionOrderPaymentDetailsList;

    //OrderPaymentsMatching list
    FOrderPaymentMatchListO : TOrderPaymentMatchingList;
    FOrderPaymentMatchListI : IOrderPaymentMatchingList;

    // Internal Goods Analysis cache
    FGoodsFolio     : LongInt;
    FGoodsAnalysis  : Array [VatType] Of Double;

    // Internal Line Type Analysis cache
    FLineTypeFolio  : LongInt;
    FLTypeAnalysis  : Array [0..6] Of Double;

    // Our Ref has been manually assigned when adding transaction
    FOurRefAssigned : Boolean;

    // Save Method - Error Line property
    FSaveErrorLine  : SmallInt;

    FIntfType       : TInterfaceMode;
    FToolkit        : TObject;
    FParentTH       : TTransaction;

    //Views sub-objects
    //NOM
    FAsNOMO         : TTransactionAsNOM;
    FAsNOMI         : ITransactionAsNOM2;

    //TSH
    FAsTSHO         : TTransactionAsTSH;
    FAsTSHI         : ITransactionAsTSH;

    //ADJ
    FAsADJO         : TTransactionAsADJ;
    FAsADJI         : ITransactionAsADJ;

    //WOR
    FAsWORO         : TTransactionAsWOR;
    FAsWORI         : ITransactionAsWOR;

    //Application
    FAsAppO         : TTransactionAsApplication;
    FAsAppI         : ITransactionAsApplication;

    FAsBatchO       : TTransactionAsBatch;
    FAsBatchI       : ITransactionAsBatch;

    FAsReturnO      : TTransactionAsReturn;
    FAsReturnI      : ITransactionAsReturn;

    FLinksO         : TLinks;
    FLinksI         : ILinks;

    FAutoO          : TAutoTransactionSettings;
    FAutoI          : IAutoTransactionSettings;

    FSetBatchInfo   : TBatchCallBackProc;

    FOldDueDate     : String;

    FNewDueDate, FOurRef : PChar;
    FLineError : Integer;

    function OkToUpdate : Boolean;
  protected
    FTrans2 : Boolean; //specifies whether
    //AP : 12/12/2016 : ABSEXCH-17394 The function TTransaction.enumBuildSaveArray is showing an error dialog rather than just returning an error code
    EnumRes : Integer;
    // Transaction Line Interface
    FDeductLinesO       : TTransactionLines;
    FDeductLinesI       : ITransactionLines;

    // Transaction Line Interface
    FRetLinesO       : TTransactionLines;
    FRetLinesI       : ITransactionLines;
    // ITransaction
    function  Get_thOurRef: WideString; safecall;
    procedure Set_thOurRef(const Value: WideString); safecall;
    function  Get_thYourRef: WideString; safecall;
    procedure Set_thYourRef(const Value: WideString); safecall;
    function  Get_thAcCode: WideString; safecall;
    procedure Set_thAcCode(const Value: WideString); safecall;
    function  Get_thRunNo: Integer; safecall;
    function  Get_thFolioNum: Integer; safecall;
    procedure Set_thFolioNum(Value: Integer); safecall;
    function  Get_thCurrency: Smallint; safecall;
    procedure Set_thCurrency(Value: Smallint); safecall;
    function  Get_thYear: Smallint; safecall;
    procedure Set_thYear(Value: Smallint); safecall;
    function  Get_thPeriod: Smallint; safecall;
    procedure Set_thPeriod(Value: Smallint); safecall;
    function  Get_thTransDate: WideString; safecall;
    procedure Set_thTransDate(const Value: WideString); safecall;
    function  Get_thDueDate: WideString; safecall;
    procedure Set_thDueDate(const Value: WideString); safecall;
    function  Get_thCompanyRate: Double; safecall;
    procedure Set_thCompanyRate(Value: Double); safecall;
    function  Get_thDailyRate: Double; safecall;
    procedure Set_thDailyRate(Value: Double); safecall;
    function  Get_thDocType: TDocTypes; safecall;
    function  Get_thVATAnalysis(const Index: WideString): Double; safecall;
    procedure Set_thVATAnalysis(const Index: WideString; Value: Double); safecall;
    function  Get_thNetValue: Double; safecall;
    procedure Set_thNetValue(Value: Double); virtual; safecall;
    function  Get_thTotalVAT: Double; safecall;
    procedure Set_thTotalVAT(Value: Double); safecall;
    function  Get_thSettleDiscPerc: Double; safecall;
    procedure Set_thSettleDiscPerc(Value: Double); safecall;
    function  Get_thSettleDiscAmount: Double; safecall;
    procedure Set_thSettleDiscAmount(Value: Double); safecall;
    function  Get_thTotalLineDiscount: Double; safecall;
    procedure Set_thTotalLineDiscount(Value: Double); safecall;
    function  Get_thSettleDiscDays: Smallint; safecall;
    procedure Set_thSettleDiscDays(Value: Smallint); safecall;
    function  Get_thSettleDiscTaken: WordBool; safecall;
    procedure Set_thSettleDiscTaken(Value: WordBool); safecall;
    function  Get_thAmountSettled: Double; safecall;
    function  Get_thTransportNature: Smallint; safecall;
    procedure Set_thTransportNature(Value: Smallint); safecall;
    function  Get_thTransportMode: Smallint; safecall;
    procedure Set_thTransportMode(Value: Smallint); safecall;
    function  Get_thHoldFlag: Smallint; safecall;
    procedure Set_thHoldFlag(Value: Smallint); safecall;
    function  Get_thTotalWeight: Double; safecall;
    procedure Set_thTotalWeight(Value: Double); safecall;
    function  Get_thDelAddress: IAddress; safecall;
    function  Get_thTotalCost: Double; safecall;
    procedure Set_thTotalCost(Value: Double); safecall;
    function  Get_thPrinted: WordBool; safecall;
    function  Get_thManualVAT: WordBool; safecall;
    procedure Set_thManualVAT(Value: WordBool); safecall;
    function  Get_thDeliveryTerms: WideString; safecall;
    procedure Set_thDeliveryTerms(const Value: WideString); safecall;
    function  Get_thOperator: WideString; safecall;
    procedure Set_thOperator(const Value: WideString); safecall;
    function  Get_thJobCode: WideString; safecall;
    procedure Set_thJobCode(const Value: WideString); virtual; safecall;
    function  Get_thAnalysisCode: WideString; safecall;
    procedure Set_thAnalysisCode(const Value: WideString); safecall;
    function  Get_thTotalOrderOS: Double; safecall;
    procedure Set_thTotalOrderOS(Value: Double); safecall;
    function  Get_thUserField1: WideString; safecall;
    procedure Set_thUserField1(const Value: WideString); safecall;
    function  Get_thUserField2: WideString; safecall;
    procedure Set_thUserField2(const Value: WideString); safecall;
    function  Get_thUserField3: WideString; safecall;
    procedure Set_thUserField3(const Value: WideString); safecall;
    function  Get_thUserField4: WideString; safecall;
    procedure Set_thUserField4(const Value: WideString); safecall;
    function  Get_thTagged: WordBool; safecall;
    procedure Set_thTagged(Value: WordBool); safecall;
    function  Get_thNoLabels: Smallint; safecall;
    procedure Set_thNoLabels(Value: Smallint); safecall;
    function  Get_thControlGL: Integer; safecall;
    procedure Set_thControlGL(Value: Integer); safecall;
    function  Get_thProcess: TIntrastatProcess; safecall;
    procedure Set_thProcess(Value: TIntrastatProcess); safecall;
    function  Get_thSource: Integer; safecall;
    function  Get_thPostedDate: WideString; safecall;
    function  Get_thPORPickSOR: WordBool; safecall;
    procedure Set_thPORPickSOR(Value: WordBool); safecall;
    function  Get_thBatchDiscAmount: Double; safecall;
    procedure Set_thBatchDiscAmount(Value: Double); safecall;
    function  Get_thPrePost: Integer; safecall;
    procedure Set_thPrePost(Value: Integer); safecall;
    function  Get_thOutstanding: WideString; safecall;
    function  Get_thFixedRate: WordBool; safecall;
    procedure Set_thFixedRate(Value: WordBool); safecall;
    function  Get_thLongYourRef: WideString; safecall;
    procedure Set_thLongYourRef(const Value: WideString); virtual; safecall;
    function  Get_thAcCodeI: IAccount; safecall;
    function  Get_thGoodsAnalysis(const Index: WideString): Double; safecall;
    function  Get_thLineTypeAnalysis(Index: Integer): Double; safecall;
    function  entCanUpdate: WordBool; safecall;
    function  Add(TransactionType: TDocTypes): ITransaction; virtual; safecall;
    function  Update: ITransaction; safecall;
    function  Save(CalculateTotals: WordBool): Integer; virtual; safecall;
    procedure Cancel; safecall;
    function  Clone: ITransaction; safecall;
    function  Get_thLines: ITransactionLines; virtual; safecall;
    function  Get_thDeductionLines: ITransactionLines; virtual; safecall;
    function  Get_thRetentionLines: ITransactionLines; virtual; safecall;
    function  Get_SaveErrorLine: Integer; safecall;
    function  Get_thEmployeeCode: WideString; safecall;
    procedure Set_thEmployeeCode(const Value: WideString); safecall;
    procedure ImportDefaults; virtual; safecall;
    procedure UpdateTotals; safecall;
    function  Get_thNotes: INotes; safecall;
    function  Get_thTotals(TotalType: TTransTotalsType): Double; safecall;
    function  Get_thMatching: IMatching; safecall;
    function  Get_thAnalysisCodeI: IJobAnalysis; safecall;
    function  Get_thJobCodeI: IJob; safecall;


    procedure AllocateTransNo; safecall;

    function  BuildOurRefIndex(const OurRef: WideString): WideString; safecall;
    function  BuildFolioIndex(Folio: Integer): WideString; safecall;
    function  BuildAccountIndex(const AccountCode: WideString): WideString; safecall;
    function  BuildYourRefIndex(const YourRef: WideString): WideString; safecall;
    function  BuildLongYourRefIndex(const LongYourRef: WideString): WideString; safecall;
    function  BuildRunNoIndex(RunNo: Integer; const DocChar: WideString): WideString; safecall;
    function  BuildAccountDueIndex(const AccountType: WideString; const AccountCode: WideString;
                                   const DueDate: WideString): WideString; safecall;
    function  BuildPostedDateIndex(const PostedDate: WideString; const OurRef: WideString): WideString; safecall;
    function  BuildTransDateIndex(const TransDate: WideString): WideString; safecall;
    function  BuildYearPeriodIndex(AccountingYear: Integer; AccountingPeriod: Integer): WideString; safecall;
    function  BuildOutstandingIndex(const StatusChar: WideString): WideString; safecall;

    function  Get_Index: TTransactionIndex; safecall;
    procedure Set_Index(Value: TTransactionIndex); safecall;

    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    Function TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt; Override;

    // IAddress / TAddress implementation
    //PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
    function GetAddrLine (AddrIdx, Idx : Byte; DirectToLines : Boolean = True) : String;
    Procedure SetAddrLine(AddrIdx, Idx : Byte; Value : String; DirectToLines : Boolean = True);

    // IRecordPosition
    function Get_RecordPosition: Integer; safecall;

    // ITransaction2 implementation
    function Print(PrintAs: TTransactionPrintMode): IPrintJob; safecall;
    function Get_thAsNom: ITransactionAsNOM; safecall;
    function Get_thAsTSH: ITransactionAsTSH; safecall;
    function Get_thAsADJ: ITransactionAsADJ; safecall;
    function Get_thAsWOR: ITransactionAsWOR; safecall;
    function Get_thLinks: ILinks; safecall;
    function Get_thAutoSettings: IAutoTransactionSettings; safecall;
    function Copy: ITransaction2; safecall;
    function Reverse: ITransaction2; safecall;
    function Convert(DestDocType: TDocTypes): ISingleConvert; safecall;
    function BackToBackOrder: IBackToBackOrder; safecall;
    function Get_thAsBatch: ITransactionAsBatch; safecall;
    function Delete: Integer; safecall;

    function Get_thTagNo: Byte; safecall;
    procedure Set_thTagNo(Value: Byte); safecall;

    function UpdateEx(UpdateMode: TTransactionUpdateMode): ITransaction2; safecall;

    function Get_thCISTaxDue: Double; safecall;
    procedure Set_thCISTaxDue(Value: Double); safecall;
    function Get_thCISTaxDeclared: Double; safecall;
    function Get_thCISManualTax: WordBool; safecall;
    procedure Set_thCISManualTax(Value: WordBool); safecall;
    function Get_thCISDate: WideString; safecall;
    function Get_thCISTotalGross: Double; safecall;
    procedure Set_thCISTotalGross(Value: Double); safecall;
    function Get_thCISSource: Byte; safecall;
    function Get_thTotalCostApport: Double; safecall;
    procedure Set_thTotalCostApport(Value: Double); safecall;
    function Get_thCISEmployee: WideString; safecall;
    procedure Set_thCISEmployee(const Value: WideString); safecall;

    // ITransaction3 implementation
    function Get_thAutoTransaction: WordBool; safecall;
    function Get_thDeliveryRunNo: WideString; safecall;
    function Get_thExternal: WordBool; safecall;
    function Get_thSettledVat: Double; safecall;
    function Get_thVATClaimed: Double; safecall;
    function Get_thPickingRunNo: Integer; safecall;
    function Get_thDeliveryNoteRef: WideString; safecall;
    function Get_thVATCompanyRate: Double; safecall;
    function Get_thVATDailyRate: Double; safecall;
    function Get_thPostCompanyRate: Double; safecall;
    function Get_thPostDailyRate: Double; safecall;
    function Get_thPostDiscAmount: Double; safecall;
    function Get_thPostDiscTaken: WordBool; safecall;
    function Get_thLastDebtChaseLetter: Integer; safecall;
    function Get_thExported: WordBool; safecall;
    procedure Set_thExported(Value: WordBool); safecall;
    function Get_thAsApplication: ITransactionAsApplication; safecall;

    //ITransaction4
    function Get_thAsReturn: ITransactionAsReturn; safecall;
    function CreateReturn: ITransactionReturnCreate; safecall;


    //ITransaction5
    function Get_thVatPostDate: WideString; safecall;
    function BuildOutstandingIndexWithAccount(const StatusChar: WideString;
                                              const AccountCode: WideString): WideString; safecall;

    //ITransaction6
    function ApplyTTD(DiscountValue: Double; const DiscountFlag: WideString): Integer; safecall;
    procedure CalculateVBD(var VBDValue: Double; var VBDVAT: Double); safecall;

    //ITransaction7
    function Get_thWeekMonth: Smallint; safecall;
    procedure Set_thWeekMonth(Value: Smallint); safecall;
    function Get_thWorkFlowState: Integer; safecall;
    procedure Set_thWorkFlowState(Value: Integer); safecall;

    //ITransaction8
    function Get_thOverrideLocation: WideString; safecall;
    procedure Set_thOverrideLocation(const Value: WideString); safecall;

    //PR: 25/10/2011 v6.9 ITransaction9
    function Get_thUserField5: WideString; safecall;
    procedure Set_thUserField5(const Value: WideString); safecall;
    function Get_thUserField6: WideString; safecall;
    procedure Set_thUserField6(const Value: WideString); safecall;
    function Get_thUserField7: WideString; safecall;
    procedure Set_thUserField7(const Value: WideString); safecall;
    function Get_thUserField8: WideString; safecall;
    procedure Set_thUserField8(const Value: WideString); safecall;
    function Get_thUserfield9: WideString; safecall;
    procedure Set_thUserfield9(const Value: WideString); safecall;
    function Get_thUserField10: WideString; safecall;
    procedure Set_thUserField10(const Value: WideString); safecall;

    //14/10/2013 MRD 2.5.18 v7.0.7 ITransaction10
    function Get_thDeliveryPostCode: WideString; safecall;
    procedure Set_thDeliveryPostCode(const Value: WideString); safecall;

    //PR: 28/10/2010 ABSEXCH-14705 ITransaction11
    function Get_thOriginator: WideString; safecall;
    procedure Set_thOriginator(const Value: WideString); safecall;
    function Get_thCreationTime: WideString; safecall;
    function Get_thCreationDate: WideString; safecall;

    //PR: 24/04/2015 ABSEXCH-16379 Allow printed status to be set IBetaTransaction3. AddAuditNote
    //was added in IBetaTransaction2 for 2015 R1, so need to declare it here but no need to implement
    function AddAuditNote(const Text: WideString): Integer; safecall;
    procedure SetPrintedStatus(Value: WordBool); safecall;


    // CJS 2014-08-05 - v7.x Order Payments - T098 - new fields - ITransaction12
    //PR: 12/05/2015 Changed to ITransaction13
    function Get_thOrderPaymentOrderRef: WideString; safecall;
    function Get_thOrderPaymentElement: TOrderPaymentElement; safecall;
    function Get_thOrderPaymentFlags: Integer; safecall;
    procedure Set_thOrderPaymentFlags(Value: Integer); safecall;
    function Get_thCreditCardType: WideString; safecall;
    procedure Set_thCreditCardType(const Value: WideString); safecall;
    function Get_thCreditCardNumber: WideString; safecall;
    procedure Set_thCreditCardNumber(const Value: WideString); safecall;
    function Get_thCreditCardExpiry: WideString; safecall;
    procedure Set_thCreditCardExpiry(const Value: WideString); safecall;
    function Get_thCreditCardAuthorisationNo: WideString; safecall;
    procedure Set_thCreditCardAuthorisationNo(const Value: WideString); safecall;
    function Get_thCreditCardReferenceNo: WideString; safecall;
    procedure Set_thCreditCardReferenceNo(const Value: WideString); safecall;
    function Get_thCustomData1: WideString; safecall;
    procedure Set_thCustomData1(const Value: WideString); safecall;
    function Get_thOrderPaymentDetails: ITransactionOrderPaymentDetailsList; safecall;

    //PR: 09/09/2014 v7.x Order Payments
    function TakePayment: IOrderPaymentTakePayment; safecall;
    function GiveRefund: IOrderPaymentGiveRefund; safecall;

    function Get_thOrderPaymentMatching: IOrderPaymentMatchingList; safecall;

    //PR: 20/01/2016 ABSEXCH-17112 v2016 R1 Added Intrastat Out of Period flag ITransaction13
    function Get_thIntrastatOutOfPeriod: WordBool; safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    //IToolkitRecord
    function GetData: WideString; safecall;
    function ConvertData(const DataRec: WideString): WideString; safecall;

    // 'Local' methods
    Procedure CloneDetails (Const TH : TBatchTHRec);
    Procedure enumBuildSaveArray(Const oTL : TTransactionLine; Const iTL : ITransactionLine; Ptr : Pointer; Mode : LongInt);
    Procedure enumGoodsAnalysis(Const oTL : TTransactionLine; Const iTL : ITransactionLine; Ptr : Pointer; Mode : LongInt);
    Procedure enumLineTypeAnalysis(Const oTL : TTransactionLine; Const iTL : ITransactionLine; Ptr : Pointer; Mode : LongInt);
    Procedure enumPrintLineLabels(Const oTL : TTransactionLine; Const iTL : ITransactionLine; Ptr : Pointer; Mode : LongInt);
    Procedure InitObjects; virtual;
    procedure InitTransRec;
    procedure InitViews;
    Procedure LoadDetails (Const TH      : TBatchTHRec;
                           Const Trans   : InvRec;
                           Const LockPos : LongInt);
    Procedure SetChanged(Value : Boolean);
    procedure SetNextDocNo;
    procedure SetNextAutoDocNo;
    Procedure enumRecalcTotals(Const oTL : TTransactionLine; Const iTL : ITransactionLine; Ptr : Pointer; Mode : Longint);
    procedure InitHeaderTotals;
    // CS 2011-08-16 ABSEXCH-11149 - Check for invalid VATIncFlg
    Procedure UpdateHeaderTotals (Const TL : TBatchTLRec; var ErrorNo: Integer);
    function CopyReverse(Which : Byte) : ITransaction2; virtual;
    Procedure enumSaveLineDetails(Const oTL : TTransactionLine; Const iTL : ITransactionLine; Ptr : Pointer; Mode : LongInt);
    function SaveAfterUpdateEx: Integer;
    procedure GetLines;
    function Get_LineCount : Integer; safecall;
    function GetDocType : TDocTypes;

    procedure Set_thOutstanding(const Value : WideString); safecall;
    procedure Set_thDeliveryRunNo(const Value : WideString); safecall;
    procedure Set_thSource(Value : Integer); safecall;
    function Get_thTotalInvoiced: Double; safecall;
    procedure Set_thTotalInvoiced(Value : Double); safecall;
    function Get_thOrdMatch: WordBool; safecall;
    procedure Set_thOrdMatch(Value: WordBool); safecall;
    function Get_thAutoPost: WordBool; safecall;
    procedure Set_thZeroLineNos(Value: WordBool); safecall;
    procedure Set_thAllowCtrlCodes(Value: WordBool); safecall;
    function Get_thTotalReserved: Double; safecall;
    procedure Set_thTotalReserved(Value: Double); safecall;
    procedure Set_thPostDiscAmount(Value: Double); safecall;
    function Get_thVariance: Double; safecall;
    procedure Set_thVariance(Value: Double); safecall;
    function Get_thTotalOrdered: Double; safecall;
    procedure Set_thTotalOrdered(Value: Double); safecall;
    function Get_thRevalueAdj: Double; safecall;
    procedure Set_thRevalueAdj(Value: Double); safecall;
    function GetOPOutstanding : Double;

    //PR: 24/01/2015 v7.0.14 ABSEXCH-16284 ITransaction12 New fields for Prompt Payment Discount
    function Get_thPPDPercentage: Double; safecall;
    procedure Set_thPPDPercentage(Value: Double); safecall;
    function Get_thPPDDays: SmallInt; safecall;
    procedure Set_thPPDDays(Value: SmallInt); safecall;
    function Get_thPPDTaken: TPPDTakenMode; safecall;
    procedure Set_thPPDTaken(Value: TPPDTakenMode); safecall;
    function Get_thPPDGoodsValue: Double; safecall;
    function Get_thPPDVATValue: Double; safecall;
    function TakePPD: Integer; safecall;
    function Get_thPPDCreditNote: WordBool; safecall;

    //PR: 06/06/2016 ABSEXCH-17383 New UDFs
    function Get_thUserField11: WideString; safecall;
    procedure Set_thUserField11(const Value: WideString); safecall;
    function Get_thUserField12: WideString; safecall;
    procedure Set_thUserField12(const Value: WideString); safecall;

    //AP: 21/11/2017 ABSEXCH-19399 New GDPR field
    function  Get_thAnonymised: WordBool; safecall;
    function  Get_thAnonymisedDate: WideString; safecall;
    function  Get_thAnonymisedTime: WideString; safecall;

  public
    BatchIndex : integer;
    //PR 02/10/02 moved from protected to public
    procedure InitNewTrans(TransactionType: TDocTypes);
    function InUpdateMode : Boolean;
    procedure ConvertToBatchGeneral;
    function GetBatchLink : String;
    function QuietBatchSave : Integer;
    Function GetCloneInterface (Const OurRef : ShortString) : ITransaction;
    Constructor Create(Const IType    : TInterfaceMode;
                       Const Toolkit  : TObject;
                       Const ParentTH : TTransaction;
                       Const BtrIntf  : TCtkTdPostExLocalPtr);
    Destructor Destroy; override;

    Property Changed : Boolean Write SetChanged;
    Property InterfaceMode : TInterfaceMode Read FIntfType;
    Property TH : TBatchTHRec Read FTH write FTH;
    Property Toolkit : TObject Read FToolkit;
    property Trans   : InvRec read FTrans;
    property SetBatchInfo : TBatchCallBackProc read FSetBatchInfo write FSetBatchInfo;
    property BtrIntf  : TCtkTdPostExLocalPtr read fBtrIntf;
    property OldDueDate : string read FOldDueDate write FOldDueDate;
    property DocType : TDocTypes read GetDocType;
  End; { TTransaction }

  TSetTermsProc = procedure(WhichOne : Byte; const OurRef : string) of object;

  TTransaction2 = Class(TTransaction)
  private
    FTermsProc       : TSetTermsProc;
    FJobApps         : IJobApplications;
    FAbsLineCount    : longint;
  protected
    FJobCode : string;
    FDocHed  : string[3];
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    Function GetDataRecord2 (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    procedure Set_thLongYourRef(const Value: WideString); override; safecall;
    function  Add(TransactionType: TDocTypes): ITransaction; override; safecall;
    function  Save(CalculateTotals: WordBool): Integer; override; safecall;
    procedure Set_thJobCode(const Value: WideString); override; safecall;
    procedure Set_thNetValue(Value: Double); override; safecall;
    function Lock : Integer; override; safecall;
    function UnLock : Integer; override; safecall;
    Procedure enumBuildSaveArray(Const oTL : TTransactionLine; Const iTL : ITransactionLine; Ptr : Pointer; Mode : LongInt);
    function  Get_thLines: ITransactionLines; override; safecall;
    function  Get_thDeductionLines: ITransactionLines; override; safecall;
    function  Get_thRetentionLines: ITransactionLines; override; safecall;
    function CopyReverse(Which : Byte) : ITransaction2; override;
    procedure ImportDefaults; override; safecall;


    procedure InitObjects; override;
  public
    procedure SetJobCode(const JobCode : string);
    procedure SetDocType(const DType : string);
    function  GetDeductionLines: ITransactionLines;
    function  GetRetentionLines: ITransactionLines;
    procedure SetTermsProc(TProc : TSetTermsProc;  OJ : IJobApplications);
    destructor Destroy; override;
  end;

  Function CreateTTransaction (Const Toolkit : TObject; Const ClientId : Integer) : TTransaction;
  function IsApplication(const s : string) : Boolean;

implementation

uses ComServ, oToolkit, ETStrU, BtrvU2, BTSupU1, BTKeys1U, DLLTH_Up, TLBatch, EtMiscU,
{$If Defined(COMPRNT)}
     EnterpriseForms_TLB,    // Type Library for Form Printing Toolkit
     oPrntJob,               // COM Toolkit Print Job Object
{$IfEnd}
     DllErrU, BTS1, ETDateU, VarRec2U, CurrncyU, LogFile, ComnUnit, ComnU2,
      {$IFDEF COMSOP}SpDlIntf, oConvert, SpDllSup,{$ENDIF} SysU1, DelQuote, ErrLogs, oReturns, Profile,
      MultiBuyVar,
      //PR: 28/10/2011 v6.9  Audit Notes
      AuditNotes, AuditNoteIntf,
      // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
      MadExcept,
      TransactionHelperU, //PR: 24/02/2015 ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015
      oOrderPayments, SQLUtils, oOrderPaymentsTransactionInfo,
      oTakePPD, LogUtil;

const
  UpdateEx2Msg2 = 'No header fields can be updated on this transaction';

  chPrefix : Array[dtJCT..dtJPA] of Char = (#7, #5, #0, #6, #8);

  Function SetTransNat(DocHed  :  DocTypes)  :  Byte;


  Begin
    Result:=VATInvTTyp;

    If (CurrentCountry<>IECCode) then
    Begin
      If (DocHed In CreditSet) then
        Result:=VATCRDTTyp
      else
        Result:=VATInvTTyp;
    end
    else
      Result:=VATIEInvTTyp;
  end;



function IsApplication(const s : string) : Boolean;
begin
  Result := (s = 'JPA') or (s = 'JSA') or (s = 'JPT') or (s = 'JST') or (s = 'JCT');
end;

{-------------------------------------------------------------------------------------------------}

Function CreateTTransaction (Const Toolkit : TObject; Const ClientId : Integer) : TTransaction;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTTransaction }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by TTransaction object
  BtrIntf^.Open_System(CustF, CustF);
  BtrIntf^.Open_System(InvF, InvF);
  BtrIntf^.Open_System(IDetailF, IDetailF);
  BtrIntf^.Open_System(StockF, StockF);
  BtrIntf^.Open_System(MLocF, MLocF);
  BtrIntf^.Open_System(PwrdF, PwrdF);     { Transaction Notes }
  BtrIntf^.Open_System(JCtrlF, JCtrlF);   { Employee Time Rates for TSH }
  BtrIntf^.Open_System(JMiscF, JMiscF);   { Employee Records for TSH }
  BtrIntf^.Open_System(MiscF, MiscF);   { Links }
  BtrIntf^.Open_System(MultiBuyF, MultiBuyF);  {Multi-Buy Discounts}

  //PR: 13/09/2013 ABSEXCH-13192 Include Job for CC/Dept
  BtrIntf^.Open_System(JobF, JobF);



  // Create base TTransaction object
  if (ClientID >= 40) and (ClientID <= 43) then
    Result := TTransaction2.Create(imAV, Toolkit, Nil, BtrIntf)
  else
    Result := TTransaction.Create(imGeneral, Toolkit, Nil, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([CustF, InvF, IDetailF, StockF, MLocF, PwrdF, JCtrlF, JMiscF, MiscF]);
End; { CreateTTransaction }


{-------------------------------------------------------------------------------------------------}

Constructor TTransaction.Create(Const IType    : TInterfaceMode;
                                Const Toolkit  : TObject;
                                Const ParentTH : TTransaction;
                                Const BtrIntf  : TCtkTdPostExLocalPtr);
begin
  // CJS 2014-08-05 - v7.x Order Payments - T098 - new fields - ITransaction12
  //PR: 12/05/2015 Changed to ITransaction13
  Inherited Create (ComServer.TypeLib, ITransaction16, BtrIntf);

  LogF.AddLogMessage ('ITransaction', 'Create');

  // Initialise Btrieve Ancestor
  FFileNo := InvF;

  // Initialise variables
  InitObjects;
  InitTransRec;
  FGoodsFolio := -99;
  FillChar (FGoodsAnalysis, SizeOf(FGoodsAnalysis), #0);
  FLineTypeFolio := -99;
  FillChar (FLTypeAnalysis, SizeOf(FLTypeAnalysis), #0);
  FSaveErrorLine := 0;

  // Setup Link for child Customer objects to parent custom object
  FIntfType := IType;
  FToolkit := Toolkit;
  If Assigned(ParentTH) Then Begin
    FParentTH := ParentTH;
    FIndex := FParentTH.FIndex;
  End { If Assigned(ParentAc) }
  Else Begin
    FParentTH := Self;
    Set_Index(thIdxOurRef);
  End; { Else }

  // Our Ref has been manually assigned when adding transaction
  FOurRefAssigned := False;

  FObjectID := tkoDocument;
  FWhereClause := '';
End; { Create }

{-----------------------------------------}

Destructor TTransaction.Destroy;
Begin { Destroy }
  { Destroy sub-ojects }
  InitObjects;

  If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;

  LogF.AddLogMessage ('ITransaction', 'Destroy');
End; { Destroy }

{-----------------------------------------}

Procedure TTransaction.InitObjects;
Begin { Destroy }
  // Delivery Address sub-object
  FDelAddrO := Nil;
  FDelAddrI := Nil;

  // Transaction Line sub-object
  FTHLinesO := Nil;
  FTHLinesI := Nil;

  // Matching sub-object
  FMatchingO := Nil;
  FMatchingI := Nil;

  // Order Payments sub-object
  FOrderPaymentsO := NIL;
  FOrderPaymentsI := NIL;

  FNotesO := Nil;
  FNotesI := Nil;

  FToolkit  := NIL;
  FParentTH := Nil;

  FOrderPaymentMatchListO := nil;
  FOrderPaymentMatchListI := nil;

  InitViews;



End; { Destroy }

{-----------------------------------------}

// Used by TBtrieveFunctions ancestor to authorise exceution of a function
// see original definition of AuthoriseFunction in oBtrieve.Pas for a
// definition of the parameters
Function TTransaction.AuthoriseFunction (Const FuncNo     : Byte;
                                         Const MethodName : String;
                                         Const AccessType : Byte = 0) : Boolean;
Begin { AuthoriseFunction }
  Case FuncNo Of
    1..99     : Result := (FIntfType = imGeneral);

    // .Add method
    100       : Result := (FIntfType = imGeneral);
    // .Update method
    101       : Result := (FIntfType = imGeneral) and ((Get_thRunNo <> -10) or Assigned(FSetBatchInfo));
    // .Save method
    102       : Result := (FIntfType In [imAdd, imUpdate, imCopy, imUpdateEx, imUpdateEx2]);
    // .Cancel method
    103       : Result := (FIntfType in [imUpdate, imUpdateEx, imUpdateEx2]);
    // .Clone method
    104       : Result := (FIntfType = imGeneral);
    // .UpdateEx method
    105       : Result := (FIntfType = imGeneral);

    // .AllocateTransNo
    201       : Result := (FIntfType = imAdd);

    // .thNotes property
    202       : Result := (FIntfType = imGeneral);

    // .thTotals property
    203       : Result := (FIntfType In [imGeneral, imClone]);

    // .thMatching property
    204       : Result := (FIntfType = imGeneral);

    // .Print
    205       : Result := (FIntfType In [imGeneral, imClone]);
    // .Copy function
    206       : Result := (FIntfType In [imGeneral, imClone]);

    // .Reverse function
    207       : Result := (FIntfType In [imGeneral, imClone]) and not (Get_thDocType in [dtPOR, dtSOR]);

    // .Convert function
    208       : Result := (FIntfType = imGeneral);

    // .BackToBackOrder function
    209       : Result := (Get_thDocType = dtSOR) and (Get_thLines.thLineCount > 0)
                           and (FIntfType In [imGeneral, imClone]);

    // .Delete function
    210       : Result := (Get_thDocType in [dtPQU, dtSQU])
                           and (FIntfType In [imGeneral]);
    // .CreateReturn function
    211       : Result := (Get_thDocType in [dtPIN, dtPDN, dtSIN, dtSDN, dtSRN, dtSRI, dtPPI])
                           and (FIntfType In [imGeneral]) and (FTH.NomAuto);
    //ApplyTTD function
    212       : Result := (FIntfType In [imAdd, imUpdate, imCopy]);

    // thOrderPaymentDetails
    213       : Result := (FIntfType In [imGeneral, imClone]) and (Get_thDocType = dtSOR);

    // TakePayment
    214       : Result := (FIntfType In [imGeneral, imClone]) and (Get_thDocType  in [dtSOR, dtSDN, dtSIN]);

    // GiveRefund
    215       : Result := (FIntfType In [imGeneral, imClone]) and (Get_thDocType  in [dtSOR, dtSIN]);

    // thOrderPaymentMatching
    216       : Result := (FIntfType In [imGeneral, imClone]) and (Get_thDocType  in [dtSOR, dtSDN, dtSRC, dtSIN]);

    // AddAuditNote  - only allow if using Back Door
    217       : Result := (FIntfType In [imGeneral, imClone]) and not CheckRelease;
  Else
    Result := False;
  End; { Case FuncNo }

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }
End; { AuthoriseFunction }

{-----------------------------------------}

// Used by btrieve ancestor class to convert the interface index
// number into the actual Btrieve index number
Function TTransaction.TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt;
begin { TranslateIndex }
  If FromTLB Then Begin
    // Converting a TLB Index number into an Enterprise File Index Number
    Case IdxNo Of
      thIdxOurRef      : Result := 2;
      thIdxFolio       : Result := 3;
      thIdxAccount     : Result := 1;
      thIdxYourRef     : Result := 6;
      thIdxLongYourRef : Result := 8;
      thIdxRunNo       : Result := 0;
      thIdxAccountDue  : Result := 4;
      thIdxPostedDate  : Result := 5;
      thIdxBatchLink   : Result := 7;
      thIdxTransDate   : Result := 9;
      thIdxYearPeriod  : Result := 10;
      thIdxOutStanding : Result := 11;
    Else
      Raise EInvalidIndex.Create ('Index ' + IntToStr(IdxNo) + ' is not valid in the Transaction object');
    End; { Case }
  End { If FromTLB  }
  Else Begin
    // Converting an Enterprise File Index Number into a TLB Index Number
    Case IdxNo Of
      2  : Result := thIdxOurRef;
      3  : Result := thIdxFolio;
      1  : Result := thIdxAccount;
      6  : Result := thIdxYourRef;
      8  : Result := thIdxLongYourRef;
      0  : Result := thIdxRunNo;
      4  : Result := thIdxAccountDue;
      5  : Result := thIdxPostedDate;
      7  : Result := thIdxBatchLink;
      9  : Result := thIdxTransDate;
      10 : Result := thIdxYearPeriod;
      11 : Result := thIdxOutStanding;
    Else
      Raise EInvalidIndex.Create ('The Transaction object is using an invalid index');
    End; { Case }
  End; { Else }
End; { TranslateIndex }

{-----------------------------------------}

Procedure TTransaction.CopyDataRecord;
Begin { CopyDataRecord }
  With FBtrIntf^ Do Begin
    // Convert to Toolkit structure
    CopyExInvToTKInv(LInv, FTH);

    // Take copy of original transaction for reference
    FTrans := LInv;

    // Reset Linked info
    Changed := True;

    InitViews; //Reset any existing view in case trans is now a different type
  End; { With FBtrIntf^ }
End; { CopyDataRecord }

{-----------------------------------------}

// Used by btrieve ancestor class to get data
Function TTransaction.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode : SmallInt;
  KeyS      : Str255;
begin
  Result := 0;
  LastErDesc := '';

  With FBtrIntf^ Do Begin
    KeyS := SetKeyString(BtrOp, SearchKey);
    BtrOpCode := BtrOp;

    // Get record
    Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

    If (Result = 0) Then
      CopyDataRecord;

    Changed := True;
    FKeyString := KeyS;
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (20, Result);
end;

{-----------------------------------------}

function TTransaction.Get_thOurRef: WideString;
begin
  Result := FTH.OurRef;
end;

procedure TTransaction.Set_thOurRef(const Value: WideString);
begin
  if OkToUpdate then
  begin
    FTH.OurRef := Value;

    // HM 07/03/02: Added this as without this the Save method always sets it
    FOurRefAssigned := True;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thYourRef: WideString;
begin
  Result := FTH.YourRef;
end;

procedure TTransaction.Set_thYourRef(const Value: WideString);
begin
  if OkToUpdate then
    FTH.YourRef := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thAcCode: WideString;
begin
  Result := FTH.CustCode;
end;

procedure TTransaction.Set_thAcCode(const Value: WideString);
begin
  if OkToUpdate then
    FTH.CustCode := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thAmountSettled: Double;
begin
  Result := FTH.Settled;
end;

{-----------------------------------------}

function TTransaction.Get_thAnalysisCode: WideString;
begin
  Result := FTH.DJobAnal;
end;

procedure TTransaction.Set_thAnalysisCode(const Value: WideString);
begin
  if OkToUpdate then
    FTH.DJobAnal := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thBatchDiscAmount: Double;
begin
  Result := FTH.BDiscount;
end;

procedure TTransaction.Set_thBatchDiscAmount(Value: Double);
begin
  if OkToUpdate then
    FTH.BDiscount := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thCompanyRate: Double;
begin
  Result := FTH.CoRate;
end;

procedure TTransaction.Set_thCompanyRate(Value: Double);
begin
  if OkToUpdate then
    FTH.CoRate := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thControlGL: Integer;
begin
  Result := FTH.CtrlNom;
end;

procedure TTransaction.Set_thControlGL(Value: Integer);
begin
  if OkToUpdate then
    FTH.CtrlNom := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thCurrency: Smallint;
begin
  Result := FTH.Currency;
end;

procedure TTransaction.Set_thCurrency(Value: Smallint);
begin
  if OkToUpdate then
  begin
    FTH.Currency := ValidateCurrencyNo (Value);

    // HM 01/02/02: Set Currency Conversion rates in FTrans to allow thTotals to work properly
    If ExSyss.MCMode Then
      FTrans.CXrate[BOn]:=SyssCurr.Currencies[FTH.Currency].CRates[BOn]
    Else
      FTrans.CXRate := SyssCurr.Currencies[FTH.Currency].CRates;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thDailyRate: Double;
begin
  Result := FTH.VATRate;
end;

procedure TTransaction.Set_thDailyRate(Value: Double);
begin
  if OkToUpdate then
    FTH.VATRate := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}
//PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
function TTransaction.GetAddrLine (AddrIdx, Idx : Byte; DirectToLines : Boolean = True) : String;
begin
//PR: 26/11/2014 Order Payments Add Country Code
  if Idx = IDX_COUNTRY then  //Set Country Code
    Result := FTH.thDeliveryCountry
  else
  if DirectToLines or (Idx <> 5) or (ExSyss.AddressPostcodeMapping = pmDeliveryAddressLine5) then
    Result := FTH.DAddr[Idx]
  else
    Result := FTH.thDeliveryPostcode;

end;

//PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
Procedure TTransaction.SetAddrLine(AddrIdx, Idx : Byte; Value : String; DirectToLines : Boolean = True);
begin
//PR: 26/11/2014 Order Payments Add Country Code
  if OkToUpdate then
  begin
    if Idx = IDX_COUNTRY then  //Set Country Code
      FTH.thDeliveryCountry := Value
    else
    if DirectToLines or (Idx <> 5) or (ExSyss.AddressPostcodeMapping = pmDeliveryAddressLine5) then
      FTH.DAddr[Idx] := Value
    else
      FTH.thDeliveryPostcode := Value;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

function TTransaction.Get_thDelAddress: IAddress;
begin
  If (Not Assigned(FDelAddrO)) Then Begin
    { Create and initialise Customer Address Sub-Object}
    FDelAddrO := TAddress.Create(1, GetAddrLine, SetAddrLine);

    FDelAddrI := FDelAddrO;
  End; { If (Not Assigned(FDelAddrO)) }

  Result := FDelAddrI;
end;

{-----------------------------------------}

function TTransaction.Get_thDeliveryTerms: WideString;
begin
  Result := FTH.DelTerms;
end;

procedure TTransaction.Set_thDeliveryTerms(const Value: WideString);
begin
  if OkToUpdate then
    FTH.DelTerms := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thDocType: TDocTypes;
begin
  Result := TKDocTypeToTLBDocType(FTH.TransDocHed);
end;

{-----------------------------------------}

function TTransaction.Get_thDueDate: WideString;
begin
  Result := FTH.DueDate;
end;

procedure TTransaction.Set_thDueDate(const Value: WideString);
begin
  if OkToUpdate then
    FTH.DueDate := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thFixedRate: WordBool;
begin
  Result := FTH.SOPKeepRate;
end;

procedure TTransaction.Set_thFixedRate(Value: WordBool);
begin
  if OkToUpdate then
    FTH.SOPKeepRate := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thFolioNum: Integer;
begin
  Result := FTH.FolioNum;
end;

procedure TTransaction.Set_thFolioNum(Value: Integer);
begin
  if OkToUpdate then
    FTH.FolioNum := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thHoldFlag: Smallint;
begin
  Result := FTH.HoldFlg;
end;

procedure TTransaction.Set_thHoldFlag(Value: Smallint);
begin
  if OkToUpdate then
    FTH.HoldFlg := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thJobCode: WideString;
begin
  Result := FTH.DJobCode;
end;

procedure TTransaction.Set_thJobCode(const Value: WideString);
begin
  if OkToUpdate then
    FTH.DJobCode := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thManualVAT: WordBool;
begin
  Result := FTH.ManVAT;
end;

procedure TTransaction.Set_thManualVAT(Value: WordBool);
begin
  if OkToUpdate then
    FTH.ManVAT := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thNetValue: Double;
begin
  Result := FTH.InvNetVal;
end;

procedure TTransaction.Set_thNetValue(Value: Double);
begin
  if OkToUpdate then
    FTH.InvNetVal := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thNoLabels: Smallint;
begin
  Result := FTH.thNoLabels;
end;

procedure TTransaction.Set_thNoLabels(Value: Smallint);
begin
  if OkToUpdate then
    FTH.thNoLabels := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thOutstanding: WideString;
begin
  Result := FTH.AllocStat;
end;

{-----------------------------------------}

function TTransaction.Get_thPeriod: Smallint;
begin
  Result := FTH.AcPr;
end;

procedure TTransaction.Set_thPeriod(Value: Smallint);
begin
  if OkToUpdate then
    FTH.AcPr := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thPORPickSOR: WordBool;
begin
  Result := FTH.PORPickSOR;
end;

procedure TTransaction.Set_thPORPickSOR(Value: WordBool);
begin
  if OkToUpdate then
    FTH.PORPickSOR := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thPostedDate: WideString;
begin
  Result := FTH.PostDate;
end;

{-----------------------------------------}

function TTransaction.Get_thPrePost: Integer;
begin
  Result := FTH.PrePostFlg;
end;

procedure TTransaction.Set_thPrePost(Value: Integer);
begin
  if OkToUpdate then
    FTH.PrePostFlg := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thPrinted: WordBool;
begin
  Result := FTH.PrintedDoc;
end;

{-----------------------------------------}

function TTransaction.Get_thProcess: TIntrastatProcess;
begin
  Case FTH.SSDProcess Of
    ' ' : Result := ipNormal;
    'T' : Result := ipTriangulation;
    'P' : Result := ipProcess;
  Else
    Raise EValidation.Create ('Invalid SSD Process Flag (' + FTH.SSDProcess + ')');
  End; { Case FTH.SSDProcess }
end;

procedure TTransaction.Set_thProcess(Value: TIntrastatProcess);
begin
  if OkToUpdate then
    Case Value Of
      ipNormal        : FTH.SSDProcess := ' ';
      ipTriangulation : FTH.SSDProcess := 'T';
      ipProcess       : FTH.SSDProcess := 'P';
    Else
      Raise EValidation.Create ('Invalid SSD Process Flag (' + IntToStr(Ord(Value)) + ')');
    End { Case FTH.SSDProcess }
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thRunNo: Integer;
begin
  Result := FTH.RunNo;
end;

{-----------------------------------------}

function TTransaction.Get_thSettleDiscAmount: Double;
begin
  Result := FTH.DiscSetAm;
end;

procedure TTransaction.Set_thSettleDiscAmount(Value: Double);
begin
  if OkToUpdate then
    FTH.DiscSetAm := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thSettleDiscDays: Smallint;
begin
  Result := FTH.DiscDays;
end;

procedure TTransaction.Set_thSettleDiscDays(Value: Smallint);
begin
  if OkToUpdate then
    FTH.DiscDays := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thSettleDiscPerc: Double;
begin
  Result := FTH.DiscSetl;
end;

procedure TTransaction.Set_thSettleDiscPerc(Value: Double);
begin
  if OkToUpdate then
    FTH.DiscSetl := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thSettleDiscTaken: WordBool;
begin
  Result := FTH.DiscTaken;
end;

procedure TTransaction.Set_thSettleDiscTaken(Value: WordBool);
begin
  if OkToUpdate then
    FTH.DiscTaken := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thSource: Integer;
begin
  Result := FTH.ExtSource;
end;

{-----------------------------------------}

function TTransaction.Get_thTagged: WordBool;
begin
  // HM 07/09/01 (4.40): Modified to check new tagging method
  Result := FTH.Tagged <> 0;
end;

procedure TTransaction.Set_thTagged(Value: WordBool);
begin
  if OkToUpdate then
  begin
    // HM 07/09/01 (4.40): Modified to check new tagging method
    //FTH.Tagged := Value;
    If Value Then
      FTH.Tagged := 1
    Else
      FTH.Tagged := 0;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thTotalCost: Double;
begin
  Result := FTH.TotalCost;
end;

procedure TTransaction.Set_thTotalCost(Value: Double);
begin
  if OkToUpdate then
    FTH.TotalCost := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thTotalLineDiscount: Double;
begin
  Result := FTH.DiscAmount;
end;

procedure TTransaction.Set_thTotalLineDiscount(Value: Double);
begin
  if OkToUpdate then
    FTH.DiscAmount := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thTotalOrderOS: Double;
begin
  Result := FTH.TotOrdOS;
end;

procedure TTransaction.Set_thTotalOrderOS(Value: Double);
begin
  if OkToUpdate then
    FTH.TotOrdOS := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thTotalVAT: Double;
begin
  Result := FTH.InvVAT;
end;

procedure TTransaction.Set_thTotalVAT(Value: Double);
begin
  if OkToUpdate then
    FTH.InvVAT := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thTotalWeight: Double;
begin
  Result := FTH.TotalWeight;
end;

procedure TTransaction.Set_thTotalWeight(Value: Double);
begin
  if OkToUpdate then
    FTH.TotalWeight := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thTransDate: WideString;
begin
  Result := FTH.TransDate;
end;

procedure TTransaction.Set_thTransDate(const Value: WideString);
begin
  if OkToUpdate then
    FTH.TransDate := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thTransportMode: Smallint;
begin
  Result := FTH.TransMode;
end;

procedure TTransaction.Set_thTransportMode(Value: Smallint);
begin
  if OkToUpdate then
    FTH.TransMode := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thTransportNature: Smallint;
begin
  Result := FTH.TransNat;
end;

procedure TTransaction.Set_thTransportNature(Value: Smallint);
begin
  if OkToUpdate then
    FTH.TransNat := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thOperator: WideString;
begin
  Result := FTH.OpName;
end;

procedure TTransaction.Set_thOperator(const Value: WideString);
begin
  if OkToUpdate then
    FTH.OpName := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thUserField1: WideString;
begin
  Result := FTH.DocUser1;
end;

procedure TTransaction.Set_thUserField1(const Value: WideString);
begin
  if OkToUpdate then
    FTH.DocUser1 := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thUserField2: WideString;
begin
  Result := FTH.DocUser2;
end;

procedure TTransaction.Set_thUserField2(const Value: WideString);
begin
  if OkToUpdate then
    FTH.DocUser2 := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thUserField3: WideString;
begin
  Result := FTH.DocUser3;
end;

procedure TTransaction.Set_thUserField3(const Value: WideString);
begin
  if OkToUpdate then
    FTH.DocUser3 := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thUserField4: WideString;
begin
  Result := FTH.DocUser4;
end;

procedure TTransaction.Set_thUserField4(const Value: WideString);
begin
  if OkToUpdate then
    FTH.DocUser4 := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thVATAnalysis(const Index: WideString): Double;
var
  Idx : Integer;
begin
  //Result := FTH.InvVatAnal[VatCharToIdx(Index)];

  // MH 07/07/2014 v7.0.11 ABSEXCH-12347: Added validation and error handling on the VAT Code to prevent Range Check Errors
  Try
    Idx := VatCharToIdx(Index);
    If (Idx >= Low(FTH.InvVatAnal)) And (Idx <= High(FTH.InvVatAnal)) Then
      Result := FTH.InvVatAnal[Idx]
    Else
      Raise EInvalidIndex.Create ('thVATAnalysis: Invalid VAT Code (' + Index + ')');
  Except
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;

procedure TTransaction.Set_thVATAnalysis(const Index: WideString; Value: Double);
var
  Idx : Integer;
begin
//  if OkToUpdate then
//    FTH.InvVatAnal[VatCharToIdx(Index)] := Value
//  else
//    raise EInvalidUpdate.Create(UpdateEx2Msg2);

  // MH 07/07/2014 v7.0.11 ABSEXCH-12347: Added validation and error handling on the VAT Code to prevent Range Check Errors
  Try
    if OkToUpdate then
    Begin
      Idx := VatCharToIdx(Index);
      If (Idx >= Low(FTH.InvVatAnal)) And (Idx <= High(FTH.InvVatAnal)) Then
        FTH.InvVatAnal[Idx] := Value
      Else
        Raise EInvalidIndex.Create ('thVATAnalysis: Invalid VAT Code (' + Index + ')');
    End // if OkToUpdate
    else
      raise EInvalidUpdate.Create(UpdateEx2Msg2);
  Except
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;

{-----------------------------------------}

function TTransaction.Get_thYear: Smallint;
begin
  Result := FTH.AcYr;
end;

procedure TTransaction.Set_thYear(Value: Smallint);
begin
  if OkToUpdate then
    FTH.AcYr := ValidateYear(Value)
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thLongYourRef: WideString;
begin
  Result := FTH.LongYrRef;
end;

procedure TTransaction.Set_thLongYourRef(Const Value: WideString);
begin
  if OkToUpdate then
    FTH.LongYrRef := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

{-----------------------------------------}

function TTransaction.Get_thAcCodeI: IAccount;
Var
  DocType : DocTypes;
begin
  With FToolkit As TToolkit Do Begin
    // HM 19/07/01: O0ps - Added check on Trans Type to switch between Cust/Supp as appropriate
    DocType := TKDocTypeToEntDocType (FTH.TransDocHed);
    If (DocType In SalesSplit + [SRN, WOR]) Then
      { Sales }
      Result := CustomerO.GetCloneInterface(FTH.CustCode)
    Else
      If (DocType In PurchSplit + [PRN]) Then
        { Purchase }
        Result := SupplierO.GetCloneInterface(FTH.CustCode)
      Else
        { Non-Account Sales }
        Result := NIL;
  End; { With FToolkit As TToolkit }
end;

{-----------------------------------------}

function TTransaction.Get_thLines: ITransactionLines;
begin
(*  If (Not Assigned(FTHLinesO)) Then Begin
    { Create and initialise the Transaction Lines sub-object }
    FTHLinesO := TTransactionLines.Create(FIntfType, FToolkit, Self, FBtrIntf);

    FTHLinesI := FTHLinesO;
  End; { If (Not Assigned(FTHLinesO)) }

  FTHLinesO.CheckForLines; *)
  GetLines;
  Result := FTHLinesI;

end;

procedure TTransaction.GetLines;
begin
  If (Not Assigned(FTHLinesO)) Then Begin
    { Create and initialise the Transaction Lines sub-object }
    FTHLinesO := TTransactionLines.Create(FIntfType, FToolkit, Self, FBtrIntf);
    FTHLinesI := FTHLinesO;

    if IsApplication(FTH.TransDocHed) then
    begin
      FDeductLinesO := TTransactionLines.Create(FIntfType, FToolkit, Self, FBtrIntf);
      FDeductLinesI := FDeductLinesO;

      FRetLinesO := TTransactionLines.Create(FIntfType, FToolkit, Self, FBtrIntf);
      FRetLinesI := FRetLinesO;
    end;

  End; { If (Not Assigned(FTHLinesO)) }

  FTHLinesO.CheckForLines;
  if IsApplication(FTH.TransDocHed) then
  begin
    FDeductLinesO.CheckForLines(-2);
    FRetLinesO.CheckForLines(-3);
  end;
end;


function  TTransaction.Get_thDeductionLines: ITransactionLines;
begin
  if IsApplication(FTH.TransDocHed) then
  begin
    GetLines;
    Result := FDeductLinesI;
  end
  else
    Result := nil;
end;

function  TTransaction.Get_thRetentionLines: ITransactionLines;
begin
  if IsApplication(FTH.TransDocHed) then
  begin
    GetLines;
    Result := FRetLinesI;
  end
  else
    Result := nil;
end;


{-----------------------------------------}

// 'Changed' property - used to cause internal total properties to be recalculated
Procedure TTransaction.SetChanged(Value : Boolean);
begin
  If Value Then Begin
    // Reset Goods Analysis Cache
    FGoodsFolio := -99;

    // Reset link to thLine sub-object so it reloads the lines
    If Assigned(FTHLinesO) Then
      FTHLinesO.LoadedFolio := -1919191919;
  End; { If Value }
end;

{-----------------------------------------}

// Line enum proc for Goods Analysis array
Procedure TTransaction.enumGoodsAnalysis(Const oTL : TTransactionLine; Const iTL : ITransactionLine; Ptr : Pointer; Mode : LongInt);
Var
  VatIdx : VATType;
Begin { enumGoodsAnalysis }
  With iTl Do Begin
    // Resolve VATCode/InclusiveVATCode into a proper VATType code
    VATIdx := GetVATNo(ExtractChar(tlVATCode, #255), ExtractChar(tlInclusiveVATCode, #255));

    FGoodsAnalysis[VatIdx] := FGoodsAnalysis[VatIdx] + entLineTotal(True, 0);
  End; { With iTl }
End; { enumGoodsAnalysis }

// Control procedure for Goods analysis array
function TTransaction.Get_thGoodsAnalysis(const Index: WideString): Double;
Var
  I     : SmallInt;
begin
  // check to see if cache can be used
  If (FTH.FolioNum <> FGoodsFolio) Then Begin
    // Recalculate Goods Analysis Array
    FillChar (FGoodsAnalysis, SizeOf(FGoodsAnalysis), #0);

    // Force the transaction lines to be loaded/updated
    Get_thLines;

    // Start the enum of the transaction lines, for the recalculation proc
    FTHLinesO.EnumLines (enumGoodsAnalysis, NIL, 0);

    // Update cache info
    If (FTH.FolioNum <> 0) Then
      FGoodsFolio := FTH.FolioNum;
  End; { If (FTH.FolioNum <> FGoodsFolio) }

  Result := FGoodsAnalysis[GetVATNo(ExtractChar(Index, #255), #0)];
end;

{-----------------------------------------}

// Line enum proc for Line Type Analysis array
Procedure TTransaction.enumLineTypeAnalysis(Const oTL : TTransactionLine; Const iTL : ITransactionLine; Ptr : Pointer; Mode : LongInt);
Var
  VatIdx : VATType;
Begin { enumLineTypeAnalysis }
  With iTl Do
    // Accumulate Line Type analysis
    FLTypeAnalysis[tlLineType] := FLTypeAnalysis[tlLineType] + entLineTotal(False, 0);
End; { enumLineTypeAnalysis }

// Control procedure for Line Type analysis array
function TTransaction.Get_thLineTypeAnalysis(Index: Integer): Double;
Var
  I     : SmallInt;
begin
  If (Index >= 0) And (Index <= 6) Then Begin
    // check to see if cache can be used
    If (FTH.FolioNum <> FLineTypeFolio) Then Begin
      // Recalculate Goods Analysis Array
      FillChar (FLTypeAnalysis, SizeOf(FLTypeAnalysis), #0);

      // Force the transaction lines to be loaded/updated
      Get_thLines;

      // Start the enum of the transaction lines, for the recalculation proc
      FTHLinesO.EnumLines (enumLineTypeAnalysis, NIL, 0);

      // Update cache info
      If (FTH.FolioNum <> 0) Then
        FLineTypeFolio := FTH.FolioNum;
    End; { If (FTH.FolioNum <> FLineTypeFolio) }

    Result := FLTypeAnalysis[Index];
  End { If (Index >= 0) And (Index <= 6) }
  Else
    Raise EUnknownValue.Create ('Invalid Line Type (' + IntToStr(Index) + ') retrieving thLineTypeAnalysis');
end;

{-----------------------------------------}

// Returns True if the transaction can be updated
function TTransaction.entCanUpdate: WordBool;
Var
  TmpRecAddr         : LongInt;
  TmpStat, TmpKPath  : Integer;
  sOurRef            : ANSIString;
  Res                : LongInt;
begin { entCanUpdate }
  Result := False;

  // Save Current Position
  TmpKPath := GetPosKey;
  TmpStat  := Presrv_BTPos (InvF, TmpKPath, F[InvF], TmpRecAddr, BOff, BOff);

  sOurRef := FTH.OurRef;
  Res := Ex_TranCanBeUpdated(PChar(sOurRef));
  Result := (Res = 0);

  // restore original position
  If (TmpStat = 0) Then Begin
    // Restore original position
    TmpStat := Presrv_BTPos(InvF, TmpKPath, F[InvF], TmpRecAddr, BOn, BOff);
  End; { If (TmpStat = 0) }
end; { entCanUpdate }

{-----------------------------------------}

procedure TTransaction.InitTransRec;
begin
  FillChar (FTH, SizeOf(FTH), #0);
  FillChar (FTrans, SizeOf(FTrans), #0);

end;

{-----------------------------------------}

// Add Method - returns and interface for a new transaction of the specified type
function TTransaction.Add(TransactionType: TDocTypes): ITransaction;
Var
  TransO  : TTransaction;
  DocHed : DocTypes;
begin
  if not (TransactionType in [dtJCT..dtJPA]) then
  begin
    AuthoriseFunction(100, 'Add');

    DocHed := TKDocTypeToEntDocType(TLBDocTypeToTKDocType(TransactionType));
    if not CanAddTransType(DocHed) then
      raise Exception.Create('Transactions of type ' + DocCodes[DocHed] + ' cannot be added');

    // Create a new Transaction object
    TransO := TTransaction.Create(imAdd, FToolkit, Self, FBtrIntf);
    TransO.InitNewTrans(TransactionType);

    Result := TransO;
  end
  else
    raise Exception.Create('Document type cannot be added here');
end;

// Used by the .Add method to setup the detail within a new transaction object
procedure TTransaction.InitNewTrans(TransactionType: TDocTypes);
Var
  lPr, lYr : Byte;
begin
  // Initialise Header
  InitTransRec;
  With FTH Do Begin
    // Document Type
    TransDocHed := TLBDocTypeToTKDocType (TransactionType);
    OurRef := TransDocHed;

    // Transaction Date - Default to Today
    TransDate := FormatDateTime ('YYYYMMDD', Now);

    //PR: 03/05/2017 v2017 R1 ABSEXCH-18663 On Orders set blank DueDate
    if TransactionType in [dtSOR, dtPOR] then
      DueDate := TransDate;

    // Accounting Period & Year
    If (Not Syss.AutoPrCalc) Then Begin
      // 'Set Period Relative To Date' is off - default to F6 Period & Year
      AcPr := Syss.CPr;
      AcYr := Syss.CYr;
    End { If (Not Syss.AutoPrCalc) }
    Else Begin
      // 'Set Period Relative To Date' is ON
      (* HM 11/07/01: Modified to use same period calculation as Enterprise
      AcPr:=Fin_Pr(TransDate);
      AcYr:=TxlateYrVal(Fin_Yr(TransDate), BOn);
      *)
      SimpleDate2Pr(TransDate, lPr, lYr);
      AcPr := lPr;
      AcYr := lYr;
    End; { Else }

    // Currency
    // Allocate default currency according to Enterprise System version
    If ExSyss.MCMode Then
      // Assumes Euro or Global
      Currency := 1
    Else
      // Single Currency
      Currency := 0;

    // Currency Rates
    CoRate := 1.0;
    VATRate := 1.0;

    thAllowCtrlCodes := False;
    thZeroLineNos := False;
  End; { With FTH }

  // Create lines sub object
  Get_thLines;
end;

{-----------------------------------------}

function TTransaction.Update: ITransaction;
Var
  TransO  : TTransaction;
  FuncRes : LongInt;
  TempInv : InvRec;
  P : TBatchCallBackProc;
begin
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Transaction Header
  if (Get_thRunNo <> -10) or not Assigned(FSetBatchInfo) then
    FuncRes := Lock
  else
  begin //Deal with batch member
    FIndex := 2;
    P := FSetBatchInfo;
    FuncRes := GetEqual(Get_thOurRef);
    FSetBatchInfo := P;
    if FuncRes = 0 then
      FuncRes := DummyLock;
    FIndex := 7;
  end;

  If (FuncRes = 0) Then Begin
    // Create an update object
    if IsApplication(FTH.TransDocHed) then
      TransO := TTransaction2.Create(imUpdate, FToolkit, Self, FBtrIntf)
    else
      TransO := TTransaction.Create(imUpdate, FToolkit, Self, FBtrIntf);

    TransO.SetBatchInfo := FSetBatchInfo;
    TransO.BatchIndex := BatchIndex;
    // Pass current Account Record and Locking Details into sub-object
    TransO.LoadDetails(FTH, FTrans, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := TransO;
  End; { If (FuncRes = 0) }
end;

Procedure TTransaction.LoadDetails (Const TH      : TBatchTHRec;
                                    Const Trans   : InvRec;
                                    Const LockPos : LongInt);
begin
  // Setup header
  FTH := TH;
  FTrans := Trans;

  // Load transaction lines
  Get_thLines;

  // Set locking info
  LockCount := 1;
  LockPosition := LockPos;
end;

{-----------------------------------------}

procedure TTransaction.SetNextDocNo;
Var
  pDocType, pNextNo : PChar;
  Res      : SmallInt;
begin
  // Check transaction reference numbers are being handled manually
  If (Not ExSyss.OverWORef) Then
    // Check OurRef has been assigned
    If (Not FOurRefAssigned) Then Begin
      pDocType := StrAlloc(255);
      pNextNo := StrAlloc(255);

      StrPCopy (pDocType, FTH.TransDocHed);

      Res := Ex_GetNextTransNo (pDocType, pNextNo, True);
      If (Res = 0) Then Begin
        // Return Document Number
        FTH.OurRef := pNextNo;

        FOurRefAssigned := True;
      End { If (Res = 0) }
      Else
        // Error - raise exception
        Raise Exception.Create ('TTransaction.SetNextDocNo - ' + LastErDesc);

      StrDispose(pNextNo);
      StrDispose(pDocType);
    End; { If (Not FOurRefAssigned) }
end;

{-----------------------------------------}

procedure TTransaction.AllocateTransNo;
begin
  AuthoriseFunction(201, 'AllocateTransNo');

  SetNextDocNo;
end;

{-----------------------------------------}

// Line enum proc for Line Type Analysis array
Procedure TTransaction.enumBuildSaveArray(Const oTL : TTransactionLine; Const iTL : ITransactionLine; Ptr : Pointer; Mode : LongInt);
Var
  TLArray : ^TLArrayInfoType;
  RateR   : EmplPayType;
Begin { enumBuildSaveArray }
  // Dereference pointer to TLArray
  TLArray := Ptr;
  //This protected variable is being used by the child classes too so it is needed to initialize it as '0' here
  EnumRes := 0;

  if Get_thDocType = dtTSH then //Set invalid flag for timerates
    oTL.SetInvalidTimeRates(not oTL.GetTimeRate(RateR, Get_thEmployeeCode));

  // Add line into TLArray
  EnumRes := EX_ADDTLARRAYLINE (TLArray^, oTL.TL);

  //AP : 12/12/2016 : ABSEXCH-17394 The function TTransaction.enumBuildSaveArray is showing an error dialog rather than just returning an error code
  //Instead of showing message dialog, system will raise an exception.
  If (EnumRes <> 0) Then
  Begin
    Raise Exception.Create(LastErDesc);
  End; { If (EnumRes <> 0) }
End; { enumBuildSaveArray }

function TTransaction.Save(CalculateTotals: WordBool): Integer;
Type
  LineArrayType = Array [1..10000] Of TBatchTLRec;
Var
  SaveInfo              : TBtrieveSavePosType;
  SaveInfo2             : TBtrieveFileSavePos;
  TLArray               : TLArrayInfoType;
  pLines                : ^LineArrayType;
  I, BtrOp, Res         : SmallInt;
  {LineTotal, DiscTotal  : Double;}
  LastErr               : ShortString;
  BatchInfo             : TBatchInfo;
  OldIdx                : integer;
  BatchCalc             : Boolean;
  TmpQty : Double;

  function IsVarianceGL(GLCode : longint) : Boolean;
  begin
    with Toolkit as TToolkit do
      Result := GLCode = SystemSetupI.ssGLCtrlCodes[ssGLCurrencyVariance];
  end;


begin
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    AuthoriseFunction(102, 'Save');
    Profiler.StartFunc('ITransaction.Save');
    OutputDebug('ITransaction.Save Start');

    if FIntfType = imUpdateEx2 then
      FTH.UpdateExMode := 1
    else
      FTH.UpdateExMode := 0;


    if Get_thDocType in [dtPBT, dtSBT] then
    begin
      BatchCalc := CalculateTotals;
      CalculateTotals := False;
    end;

    // Reset the Save Error Line property
    FSaveErrorLine := 0;

    if FIntfType = imUpdateEx then
      Result := SaveAfterUpdateEx
    else
    begin

      // Save current file positions in main files
      SaveInfo := SaveSystemFilePos ([]);

      If (FIntfType in [imUpdate, imUpdateEx2]) Then Begin
        // Updating - Reposition on original Locked Transaction
        Result := PositionOnLock;
        BtrOp := B_Update;

      End { If (FIntfType = imUpdate) }
      Else Begin
        // Adding - no need to do anything
        Result := 0;
        BtrOp := B_Insert;

        if Get_thAutoSettings.atAutoTransaction then
          SetNextAutoDocNo
        else
        // Check OurRef has been assigned
        If (Not ExSyss.OverWORef) And (Not FOurRefAssigned) Then
          SetNextDocNo;
      End; { Else }

      If (Result = 0) Then Begin
        // Build array of TL Lines for Ex_StoreTrans
        Result := Ex_CreateTLArray (FTHLinesO.Lines.Count + 1, TLArray);

        // Load TLArray using the lines enum function
        //AP : 12/12/2016 : ABSEXCH-17394 The function TTransaction.enumBuildSaveArray is showing an error dialog rather than just returning an error code
        //Exception from enumBuildSaveArray is being handled here.
        Try
          FTHLinesO.EnumLines (enumBuildSaveArray, @TLArray, 0);
        Except
          Result := EnumRes;
        End;

        // Update Transaction details before storing
        FTH.LineCount := TLArray.NumTL;

        If CalculateTotals Then
          InitHeaderTotals;

        pLines := TLArray.TLArray;
        For I := 1 To TLArray.NumTL Do
          With pLines^[I] Do Begin
            // OurRef
            TransRefNo := FTH.OurRef;

            // Folio Number - probably not set- but won't hurt
            FolioNum := FTH.FolioNum;

            // Account Code
            CustCode := FTH.CustCode;

            // Currency & Rates
            If (FTH.TransDocHed <> 'NOM') and not IsVarianceGL(NomCode) and ((FTH.TransDocHed <> 'TSH') or (Currency = FTH.Currency)
                                                 or (Currency = 0)) and not FTH.thAllowCtrlCodes Then Begin
              // HM 27/02/01: Not for Nominal Trasfers as it prevents multi-ccy NOM's
              // PR 8/12/05: Added exclusion for Timesheets
              Currency := FTH.Currency;
              CoRate := FTH.CoRate;
              VATRate := FTH.VATRate;
            End; { If (FTH.TransDocHed <> 'NOM') }

            // Update Transaction Header Totals if specified
            If CalculateTotals Then
            begin
              // CS 2011-08-16 ABSEXCH-11149 - Check for invalid VATIncFlg
              UpdateHeaderTotals (pLines^[I], Result);
              pLines^[I].RtnErrCode := Result;
            end;

            (****
            // Update Transaction Header Totals if specified
            If CalculateTotals Then Begin
              // Cost
              FTH.TotalCost := FTH.TotalCost + Round_Up(CostPrice * Qty, 2);

              // VAT - Check not Manual VAT
              If (Not FTH.ManVAT) And (VAT <> 0.0) Then Begin
                // Update VAT Analysis & Totals
                VatIdx := VatCharToIdx(VATCode);
                FTH.InvVatAnal[VatIdx] := FTH.InvVatAnal[VatIdx] + VAT;

                FTH.InvVat := FTH.InvVat + VAT;
              End; { If (Not ManVAT) }

              // Value - exlcuding Line and Settlement Discount
              Res := EX_GETLINETOTAL(@Plines^[I], SizeOf(Plines^[I]), False, 0.0, LineTotal);

              // HM 30/11/00: Modified for SRI Payment Lines
              If (FTH.TransDocHed <> 'SRI') Or (Not Payment) Then
                FTH.InvNetVal := FTH.InvNetVal + LineTotal;

              // Line Discount
              Res := EX_GETLINETOTAL(@Plines^[I], SizeOf(Plines^[I]), True, 0.0, DiscTotal);
              FTH.DiscAmount := FTH.DiscAmount + (LineTotal - DiscTotal);
            End; { If UpdateTotals }
            ****)
          End; { With pLines^[I] }

        // CS 2011-08-16 ABSEXCH-11149 - Check for invalid VATIncFlg
        if (Result = 0) then
        begin
          //PR 10/12/2007 Set Settlement Discount Amount if not already set
          if FTH.DiscSetAm < 0.000001 then   //PR: 30/03/2009 Wasn't taking line discount into account when calculating settlement discount amount
            FTH.DiscSetAm := Calc_PAmount(FTH.InvNetVal - FTH.DiscAmount, FTH.DiscSetl, '%');

          FTH.DiscSetAm := Round_Up(FTH.DiscSetAm, 2);

          // Add/Update Transaction
          SaveExLocalPos(SaveInfo2);
          if Assigned(FSetBatchInfo) and Assigned(FParentTH) then
          begin //batchmember
            FTH.RunNo := -10;
            if BtrOp = B_Insert then
              FTH.BatchLink := FParentTH.Get_thOurRef;
            FTH.NomAuto := False;
            BatchEdit := True;
          end;
          //PR: 10/07/2009 GetVBDValue for SRI/PPI validation
          if EX_GETVBDVALUE(@FTH, TLArray.TLArray, SizeOf(FTH), TLArray.UsedSize, FTH.thVBDValue, FTH.thVBDVAT) <> 0 then
            FTH.thVBDValue := 0;
          Result := EX_STORETRANS(@FTH, TLArray.TLArray, SizeOf(FTH), TLArray.UsedSize, FIndex, BtrOp);
          if Assigned(FSetBatchInfo) then
            BatchEdit := False;
          RestoreExLocalPos(SaveInfo2);
        end;



        If (Result = 0) Then Begin
          //PR 2/10/02: if this is a batch header and we've just added it then
          //we want to turn into an update object rather than a clone
          if not IsBatchHeader(FTH.TransDocHed) or (FIntfType = imUpdate) then
          begin
          // HM 14/03/01: Convert into Clone object after a successful Save
            FIntfType := imClone;
     {       if IsBatchHeader(FTH.TransDocHed) and not BatchCalc then
                FTH.TotalInvoiced := 0;}
          end
          else
          begin
            oldIdx := {Get_Index}FIndex;
            FIndex := 2;
            GetDataRecord (B_GetEq, BuildOurRefIndex(Get_thOurRef));
            FIntfType := imUpdate;
            Lock;
            FIndex := OldIdx; //Set_Index(OldIdx);
          end;

          FTHLinesO.Transform (imClone);

          if Assigned(FSetBatchInfo) then
            ConvertToBatchGeneral;


          if Assigned(FSetBatchInfo) then //Batch line
          begin
            FillChar(BatchInfo, SizeOf(BatchInfo), 0);
            BatchInfo.biNetVal := Get_thTotals(TransTotNetInCcy);
            BatchInfo.biVat := Get_thTotalVat;
            BatchInfo.biTransO := Self;
            FSetBatchInfo(BatchInfo, BtrOp);
            if BatchInfo.biSaveResult <> 0 then
              Result := 30224;
          end;

        End { If }
        Else
          If (TLArray.NumTL > 0) Then Begin
            // Try to identify which line caused the problem
            pLines := TLArray.TLArray;
            For I := 1 To TLArray.NumTL Do
              // Check RtnErrCode to see which line had the problem
              If (pLines^[I].RtnErrCode <> 0) Then
              begin
                FSaveErrorLine := I;
                // CS 2011-08-16 ABSEXCH-11149 - Check for invalid VATIncFlg
                LastErDesc := Ex_ErrorDescription (21, pLines^[I].RtnErrCode);
              end;
          End; { If }

        // Release TLArray memory
        LastErr := LasterDesc;
        Ex_DestroyTLArray (TLArray);
        LasterDesc := LastErr;
      End; { If (Res = 0) }

    Profiler.EndFunc('ITransaction.Save');
      // Restore original file positions
      RestoreSystemFilePos (SaveInfo);
    end;
    OutputDebug('ITransaction.Save End');
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;

// Return line number of the line that caused the error during the last .Save call
function TTransaction.Get_SaveErrorLine: Integer;
begin
  Result := FSaveErrorLine;
end;

{-----------------------------------------}

procedure TTransaction.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

{-----------------------------------------}

// Creates a read-only copy of the transaction object
function TTransaction.Clone: ITransaction;
Var
  TransO : TTransaction;
begin
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Transaction object
  TransO := TTransaction.Create(imClone, FToolkit, Self, FBtrIntf);

  // Load transaction details
  TransO.CloneDetails(FTH);

  // return interface onto object
  Result := TransO;
end;

Procedure TTransaction.CloneDetails (Const TH : TBatchTHRec);
begin
  // Setup header
  FTH := TH;

  // Load transaction lines
  Get_thLines;
end;

{-----------------------------------------}

function TTransaction.BuildOurRefIndex(const OurRef: WideString): WideString;
begin
  // 2  -  Our Ref (InvOurRefK)
  Result := FullOurRefKey(OurRef);
end;

{-----------------------------------------}

function TTransaction.BuildFolioIndex(Folio: Integer): WideString;
begin
  // 3 - FolioNo  (InvFolioK)
  Result := FullNomKey(Folio);
end;

{-----------------------------------------}

function TTransaction.BuildAccountIndex(const AccountCode: WideString): WideString;
begin
  // 1 - CustCode + CustSupp + NormFlg (InvCustK)
  Result := UpperCase(LJVar(AccountCode,6));
end;

{-----------------------------------------}

function TTransaction.BuildYourRefIndex(const YourRef: WideString): WideString;
begin
  // Index 6 - Your Ref  (InvYrRefK)
  Result := LJVar(YourRef,DocYRef1Len);
end;

{-----------------------------------------}

function TTransaction.BuildLongYourRefIndex(const LongYourRef: WideString): WideString;
begin
  // Index 8 - Long YourRef (InvLYRefK)
  Result := LJVar(LongYourRef,DocYRef2Len);
end;

{-----------------------------------------}

function TTransaction.BuildRunNoIndex(RunNo: Integer; const DocChar: WideString): WideString;
begin
  // Index 0 - RunNo + DocCode[1] + Folio No. (InvRNoK)
  Result := FullNomKey (RunNo) + ExtractChar(DocChar, #0);

  // NOTE: Folio Number hidden to simplify index - DocChar can be used to jump
  //       straight in to sales or purchase transactions.
end;

{-----------------------------------------}

function TTransaction.BuildAccountDueIndex(const AccountType: WideString; const AccountCode: WideString;
                                           const DueDate: WideString): WideString; safecall;
begin
  // 4 - CustSupp + CustCode + DueDate + NormFlg (InvCDueK)
  Result := ExtractChar(AccountType, 'C') + FullCustCode(AccountCode) + DueDate;
end;

{-----------------------------------------}

function TTransaction.BuildPostedDateIndex(const PostedDate: WideString; const OurRef: WideString): WideString;
begin
  // 5 - VATDate + OurRef (InvVatK)
  Result := PostedDate + FullOurRefKey(OurRef);
end;

{-----------------------------------------}

  { TODO -cEL : TTransaction.BuildBatchIndex not coded }

  // 7 - BatchLink (InvBatchK)/(PSOP Due DATE)

{-----------------------------------------}

function TTransaction.BuildTransDateIndex(const TransDate: WideString): WideString;
begin
  // 9- Transaction Date (InvDateK)
  Result := TransDate;
end;

{-----------------------------------------}

function TTransaction.BuildYearPeriodIndex(AccountingYear: Integer; AccountingPeriod: Integer): WideString;
begin
  // 10 - Transaction Period (InvYrPrK)
  Result := Chr(AccountingYear) + Chr(AccountingPeriod);
end;

{-----------------------------------------}

function TTransaction.BuildOutstandingIndex(const StatusChar: WideString): WideString;
begin
  // 11 - AllocStat (InvOSK)
  Result := ExtractChar(StatusChar, #0);
end;

{-----------------------------------------}

function TTransaction.Get_Index: TTransactionIndex;
begin
  Result := Inherited Get_Index;
end;

procedure TTransaction.Set_Index(Value: TTransactionIndex);
begin
  Inherited Set_Index (Value);
end;

{-----------------------------------------}

function TTransaction.Get_thEmployeeCode: WideString;
begin
  Result := FTH.EmpCode;
end;

procedure TTransaction.Set_thEmployeeCode(Const Value: WideString);
begin
  if OkToUpdate then
    FTH.EmpCode := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;



{-----------------------------------------}

procedure TTransaction.InitHeaderTotals;
begin
  With FTH Do Begin
    // Cost
    TotalCost := 0.0;

    // Line Discount
    DiscAmount := 0.0;

    // VAT - Check not Manual VAT
    If (Not ManVAT) Then Begin
      // VAT Analysis & Total
      FillChar (InvVatAnal, SizeOf(InvVatAnal), #0);
      InvVat := 0.0;
    End; { If (Not ManVAT) }

    // Value
    InvNetVal := 0.0;

    //TotalCost2
    TotalCost2 := 0.0;

    //PR: 20/01/2009 - Added TSH check as total hours are stored in TotalInvoiced
    if IsApplication(FTH.TransDocHed) or (Get_thDocType in [dtTSH]) then
    begin
      TotalInvoiced := 0.0;
      thTotalOrdered := 0.0;
    end;
  End; { With FTH }
end;

{-----------------------------------------}

// Update Transaction Header Totals
Procedure TTransaction.UpdateHeaderTotals (Const TL : TBatchTLRec;
  var ErrorNo: Integer);
Var
  LineTotal, DiscTotal,
  dVAT                  : Double;
  Res, VatIdx           : SmallInt;
  VATChar               : Char;
  GotStk                : Boolean;
  StockR                : StockRec;
  SplitMult             : Double;
  siPos                 : TBtrieveFileSavePos;
  DocType               : DocTypes;
  TmpVat,
  TmpSettleDisc         : Double;
  NomCurr : CurrTypes;
  UOR : Byte;
  ZeroValue: Boolean;

  TmpQty : Double;

  //PR: 30/06/2016 v2016 R2 ABSEXCH-17492 Don't try to calculate VAT for lines which shouldn't have it
  function LineCanHaveVAT : Boolean;
  var
    DocType : TDocTypes;
  begin
    DocType := Get_thDocType;

    //Invoices, Credits, Orders, Quotes, Delivery Notes, Journal Invoices and Credits
    Result := DocType in [dtSIN,dtSJI,dtSCR,dtSJC,dtSOR,dtSDN,dtSQU,dtPIN,dtPJI,dtPCR,dtPJC,dtPOR,dtPDN,dtPQU];

    //Check invoice lines on direct transactions (SRI, PPI, SRF, PRF)
    if not Result and (DocType in [dtSRI, dtPPI, dtSRF, dtPRF]) then
      Result := not TL.Payment;

    //Check nominal transfers which can have vat
    if not Result and (DocType = dtNMT) then
      Result := (TL.NOMVatType > 0);
  end; //LineCanHaveVAT

begin { UpdateHeaderTotals }
  DocType := TKDocTypeToEntDocType(FTH.TransDocHed);
  VATChar := #0;
  VATIdx := 0;
  UOR := 0;
//  If (FTH.TransDocHed <> 'NOM') Then
    With TL Do Begin
      GotStk := False;
      SplitMult := 1;


      //PR: 05/06/02 - Added code to adjust the value + vat for split pack items
      With FBtrIntf^ Do Begin
        If (Trim(TL.StockCode) <> '') And (FTH.TransDocHed <> 'TSH') Then Begin
          // Get Stock Record
          SaveExLocalPosFile (StockF, siPos);
          GotStk := LGetMainRec(StockF, FullStockCode(TL.StockCode));
          If GotStk Then StockR := LStock;
          RestoreExLocalPos (siPos);
        End; { If (Trim(FTL.StockCode) <> '') }
      end; //with


      //PR: 02/11/2010 Moved from below as these weren't being initialised unless a nom had vat. Caused ABSEXCH-10399
      //PR: 06/06/2011 Wasn't using system rates when AutoSetTransCurrencyRates was true ABSEXCH-11464
      if ExSyss.UseExCrRate then
        NomCurr := SyssCurr^.Currencies[TL.Currency].CRates
      else
      begin
        NomCurr[False] := TL.CoRate;
        NomCurr[True]  := TL.VATRate;
      end;

(*      if GotStk then
      begin
        DocType := TKDocTypeToEntDocType(FTH.TransDocHed);
        if StockR.DPackQty and StockR.PricePack then
        begin
          if Doctype in SalesSplit then
            SplitMult := StockR.SellUnit
          else
            SplitMult := StockR.BuyUnit;
        end;
      end; *)
      // Cost
      if IsApplication(FTH.TransDocHed) then
      begin
        if (LineNo > 0) then
        begin
          FTH.TotalCost := FTH.TotalCost + Round_Up(CostPrice, 2);
          if ((FTH.TransDocHed = 'JPA') or (FTH.TransDocHed = 'JSA')) then
          begin
            if (FTH.TransNat = 2) then
            begin
              if LineNo > 0 then
                FTH.TotalInvoiced := FTH.TotalInvoiced + Round_Up(QtyDel, 2);
            end
            else
              FTH.TotalInvoiced := FTH.TotalCost;

          end;
        end;
        if ((FTH.TransDocHed = 'JPA') or (FTH.TransDocHed = 'JSA')) then
        begin
          if FTH.TransMode = 3 then //Final application so header total must be zero
          begin
            FTH.TotalInvoiced := 0;
//            FTH.TotalCost := 0;
          end;
        end;
      end
      else
      //PR: 22/01/2009 Total Cost on Timesheet header should always be 0.
      if (DocType <> TSH) and ((DocType <> WOR) or (StockR.StockType <> StkBillCode)) then
        FTH.TotalCost := FTH.TotalCost + Round_Up(CostPrice * Qty, 2);

      // CS 2011-08-16 ABSEXCH-11149 - VATIncFlg on zero-value lines
      // Ignore VAT check on zero-valued lines
      Res := EX_GETLINETOTAL(@TL, SizeOf(TL), True, 0.0, LineTotal);
      ZeroValue := (LineTotal = 0.0) And (Trim(TL.StockCode) = '');

      // VAT - Check not Manual VAT
      //PR: 16/11/2015 ABSEXCH-16090 Removed check for VAT <> 0.0
      //PR: 30/06/2016 v2016 R2 ABSEXCH-17492
      If (Not FTH.ManVAT) and LineCanHaveVAT And (Not ZeroValue) Then
      Begin
        // HM 22/03/01: Modified to support Manual VAT
        If (VATCode in ['M', 'I']) Then
        begin
          // CS 2011-08-16 ABSEXCH-11149 - Check for invalid VATIncFlg
          if (VATIncFlg = #0) then
            ErrorNo := 30119
          else
            VATChar := VATIncFlg;
        end
        Else
          VATChar := VATCode;

        if ((FTH.TransDocHed <> 'NOM') or (TL.NOMVatType <> 0)) and not IsApplication(FTH.TransDocHed) then
        begin
          // Update VAT Analysis & Totals
          //PR 18/08/03 - This was passing the settlement discount amount rather than percentage to
          //Ex_CalcLineTax, causing some strange vat amounts.

{          if FTH.DiscTaken then
            TmpSettleDisc := FTH.DiscSetAm
          else
            TmpSettleDisc := 0.0;}
          TmpSettleDisc := FTH.DiscSetl;

          Res := Ex_CalcLineTax(@TL, SizeOf(TL), TmpSettleDisc);

          //PR: 11/11/2011 v6.9 Add check here to prevent invalid line vat code passing as it would cause
          //a range check error below. ABSEXCH-11604
          if not (VATChar in VATSet) then
            ErrorNo := 30107
          else
            VatIdx := VatCharToIdx(VATChar);


          // CS 2011-08-16 ABSEXCH-11149 - Check for invalid VATIncFlg
          // PR: 11/11/2011 v6.9 Add check for invalid line vat code. ABSEXCH-11604
          if (ErrorNo <> 30119) and (ErrorNo <> 30107) then
          begin
            //PR: 19/05/2010 For NOMs we need to convert the VAT into consolidated before adding to header VAT.
            if FTH.TransDocHed <> 'NOM' then
            begin
              FTH.InvVatAnal[VatIdx] := FTH.InvVatAnal[VatIdx] + VAT;
              FTH.InvVat := FTH.InvVat + VAT;
            end
            else
            begin
  {            NomCurr[False] := TL.CoRate;
              NomCurr[True]  := TL.VATRate;}
              UOR := fxUseORate (BOff, BOn, NomCurr, FTrans.UseORate, TL.Currency, 0);
              //PR: 20/05/2011 Changed to take XRate from line rather than table
              dVAT :=  Round_Up(Conv_TCurr(VAT, GetVATExchangeRate(NomCurr, TL.Currency), TL.Currency, UOR, BOff),2);
              FTH.InvVatAnal[VatIdx] := FTH.InvVatAnal[VatIdx] + dVAT;
              FTH.InvVat := FTH.InvVat + dVAT;
            end;
          end;
        end;
      End; { If (Not ManVAT) }

      // Value - exlcuding Line and Settlement Discount
      Res := EX_GETLINETOTAL(@TL, SizeOf(TL), False, 0.0, LineTotal);



      LineTotal := LineTotal{ * SplitMult};

      // HM 30/11/00: Modified for SRI Payment Lines
      If ((FTH.TransDocHed <> 'SRI') and (FTH.TransDocHed <> 'SRF') and
          (FTH.TransDocHed <> 'PPI') and (FTH.TransDocHed <> 'PRF')) Or (Not Payment) Then
      begin //PR: 21/01/2009 - Added check for Timesheets so that line total gets converted to consolidated
        if (FTH.TransDocHed <> 'NOM') and (FTH.TransDocHed <> 'TSH') then
          FTH.InvNetVal := FTH.InvNetVal + LineTotal
        else
        begin
           //PR: 19/05/2010 moved above to allow Nom line VAT to be converted
(*          NomCurr[False] := TL.CoRate;
          NomCurr[True]  := TL.VATRate; *)

          UOR := fxUseORate (BOff, BOn, NomCurr, FTrans.UseORate, TL.Currency, 0);
//         LineTotal := Round_Up(Conv_TCurr(LineTotal, XRate(NomCurr,False,TL.Currency), TL.Currency, UOR, BOff),2);
          //PR: 24/05/2011 Convert currency lines using line xrates if available, otherwise system rates (ABSEXCH-11342)
          LineTotal := Round_Up(Conv_TCurr(LineTotal, GetExchangeRate(NomCurr, TL.Currency), TL.Currency, UOR, BOff),2);

          FTH.InvNetVal := FTH.InvNetVal + LineTotal;

        end;

      end;

      // Line Discount
      Res := EX_GETLINETOTAL(@TL, SizeOf(TL), True, 0.0, DiscTotal);

//      DiscTotal := DiscTotal{ * SplitMult};

      FTH.DiscAmount := FTH.DiscAmount + (LineTotal - DiscTotal);

      FTH.TotalCost2 := FTH.TotalCost2 + TL.CostApport;
    End; { With TL }
end; { UpdateHeaderTotals }

{-----------------------------------------}

// Line enum proc for UpdateTotals function
Procedure TTransaction.enumRecalcTotals(Const oTL : TTransactionLine;
                                        Const iTL : ITransactionLine; Ptr : Pointer; Mode : longint);
var
  ErrorNo: Integer;
Begin { enumRecalcTotals }
  // CS 2011-08-16 ABSEXCH-11149 - Check for invalid VATIncFlg
  ErrorNo := 0;
  UpdateHeaderTotals (oTL.TL, ErrorNo);
End; { enumRecalcTotals }

{-----------------------------------------}

// Recalculate the Transaction Totals
procedure TTransaction.UpdateTotals;
begin
  // Initialise the transaction totals to 0.0
  InitHeaderTotals;

  // run through the lines updating the totals
  //Bugfix 2/9/03 - was calling the wrong enum proc so causing an accessviolation
//  FTHLinesO.EnumLines (enumBuildSaveArray, NIL, 0);
  FTHLinesO.EnumLines (enumRecalcTotals, NIL, 0);
end;

{-----------------------------------------}

// Import default settings from Customer, etc...
procedure TTransaction.ImportDefaults;
Var
  SaveInfo : TBtrieveFileSavePos;
  DocType  : DocTypes;
  KeyS     : Str255;
  I        : SmallInt;

  LocalCust : CustRec;
begin
  OutputDebug('TTransaction.ImportDefaults Start');

  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    Profiler.StartFunc('ITransaction.ImportDefaults');

    // Calculate Document Type
    DocType := TKDocTypeToEntDocType (FTH.TransDocHed);

    If (DocType In (SalesSplit + PurchSplit - [SBT, PBT])) Then Begin
      // Sales & Purchase Transactions - excluding batches


      // Load Customer and import defaults
      If (Trim(FTH.CustCode) <> '') Then
        With FBtrIntF^ Do Begin
          // Save current position in Customer File
          SaveExLocalPosFile (CustF, SaveInfo);

          // Load customer detail
          KeyS := FullCustCode (FTH.CustCode);
          If LGetMainRec(CustF, KeyS) Then Begin
            // Got Customer OK - Copy Details out

            // Control GL Code
            FTH.CtrlNom := LCust.DefCtrlNom;

            // Currency
            FTH.Currency := LCust.Currency;

            // Delivery Address
            For I := Low(FTH.DAddr) To High(FTH.DAddr) Do
              FTH.DAddr[I] := LCust.DAddr[I];

            //PR: 15/10/2013 MRD 2.5.18 Set delivery postcode
            FTH.thDeliveryPostcode := LCust.acDeliveryPostcode;

            //PR: 12/01/2015 ABSEXCH-16011 Include Delivery Country Code
            FTH.thDeliveryCountry := LCust.acDeliveryCountry;

            // Due Date using Payment Terms
            if not (Get_thDocType in [dtSOR, dtPOR]) then
              FTH.DueDate := CalcDueDate (FTH.TransDate, LCust.PayTerms);

            if (FTH.TransDocHed = 'POR') or
               (FTH.TransDocHed = 'SOR') or
               (FTH.TransDocHed = 'PDN') or
               (FTH.TransDocHed = 'SDN') then
            FTH.Tagged := LCust.DefTagNo;

            // Check Use EC/Intrastat Fields to see if Intrastat needs to be setup
            With FToolkit As TToolkit Do
              If SystemSetupI.ssUseIntrastat Then Begin
                FTH.DelTerms := LCust.SSDDelTerms;
                FTH.TransMode := LCust.SSDModeTr;

                //PR: 16/02/2016 v2016 R1 ABSEXCH-17309 Changed to use new function in DllTh_Up
                FTH.TransNat := DefaultNatureOfTransaction(TKDocTypeToEntDocType(FTH.TransDocHed));
              End; { If SystemSetupI.ssUseIntrastat }

            // Settlement Discount
            // HM 07/04/01: Changed as wasn't dividing by 100 to convert the 10% stored on
            //              the Customer record to 0.1 as used by the Transaction record -
            //              resulting in 1000% discounts!!!!
            //              It also wasn't checking the SystemSetup default percentage either

            //PR: 19/04/02:
            //Changed decimal places from 2 to 4.  Value of 1.25% needs to convert to 0.0125 -
            //with 2 dec places it was being converted to 0.01

            //PR: 24/02/2015 ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015.
            if SettlementDiscountSupportedForDate(FTH.TransDate) then
            begin
              If (LCust.DefSetDisc <> 0) Then Begin
                FTH.DiscSetl := Round_Up(LCust.DefSetDisc/100,4);
                FTH.DiscDays := LCust.DefSetDDays;
              End { If }
              Else
                With FToolkit As TToolkit Do
                  If (SystemSetupI.ssSettlementDiscount <> 0) Then Begin
                    FTH.DiscSetl := Round_Up(SystemSetupI.ssSettlementDiscount/100,4);
                    FTH.DiscDays := SystemSetupI.ssSettlementDays;
                  End { If }
                  Else Begin
                    FTH.DiscSetl := 0;
                    FTH.DiscDays := 0;
                  End; { Else }
            end //if SettlementDiscountSupportedForDate(FTH.TransDate)
            else
            begin //PR: 27/08/2015 ABSEXCH-16802 Take PPD Defaults from a/c record

              //Save copy of a/c record
              LocalCust := LCust;
              //PR: 27/08/2015 ABSEXCH-16790 Replace a/c reco with Head Office if applicable;
              if (TKDocTypeToEntDocType(FTH.TransDocHed) in [PQU, POR, SQU, SOR]) and (Trim(LCust.SOPInvCode) <> '') then
                LGetMainRecPosKey (CustF, CustCodeK, FullCustCode(LCust.SOPInvCode));

              if LCust.acPPDMode <> pmPPDDisabled then
              begin
                FTH.thPPDPercentage := Round_Up(LCust.DefSetDisc/100,4);
                FTH.thPPDDays := LCust.DefSetDDays;
              end;
            end; //PPD

            //Restore a/c
            LCust := LocalCust;

            GetLines;
            FTHLinesO.AccRec := LCust;
          End; { If (Res = 0) }

          // Restore starting position in Customer File
          RestoreExLocalPos (SaveInfo);
        End; { With FBtrIntF }
    End; { If (DocType In ... }
    Profiler.EndFunc('ITransaction.ImportDefaults');
    OutputDebug('TTransaction.ImportDefaults End');
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;

{-----------------------------------------}

function TTransaction.Get_thNotes: INotes;
begin
  AuthoriseFunction(202, 'thNotes', 1);

  { Check Notes sub-object has been initialised }
  If (Not Assigned(FNotesO)) Then Begin
    { Create and initialise Customer Details }
    FNotesO := TNotes.Create(imGeneral,
                             FToolkit,
                             FBtrIntF,
                             'DOC',
                             '2',
                             False);

    FNotesI := FNotesO;
  End; { If (Not Assigned(FNotesO)) }

  FNotesO.SetStartKey (FTH.OurRef, NoteTCode + NoteDCode + FullNCode(FullNomKey(FTH.FolioNum)));

  Result := FNotesI;
end;

{-----------------------------------------}

function TTransaction.Get_thTotals(TotalType: TTransTotalsType): Double;
Var
  UOR     : Byte;
  DocType : DocTypes;
begin
  UOR := 0;
  AuthoriseFunction(203, 'thTotals', 1);

  Result := 0;

  Case TotalType Of
    // Transaction Total = Net Value + VAT - Line Discount - Settlement Discount (if taken)
    // Equivalent to the ITotal function in Enterprise
    TransTotSignedInCcy             : With FTH Do Begin
                                        Result := InvNetVal + InvVAT - DiscAmount;

                                        If DiscTaken Then
                                          // Settlement Discount Taken - reduce total by Settlement Discount
                                          Result := Result - DiscSetAm;

                                        // Apply sign by Transaction Type
                                        DocType := TKDocTypeToEntDocType (TransDocHed);
                                        Result := Round_Up(Result * DocCnst[DocType] * DocNotCnst, 2);
                                      End; { With FTH }

    TransTotSignedInBase            : With FTH Do Begin
                                        (****
                                        // Get Transaction Total In Currency
                                        Result := Get_thTotals(TransTotSignedInCcy);

                                        // Convert to Base Currency using current rates
                                        UOR := fxUseORate (BOff, BOn, FTrans.CXRate, FTrans.UseORate, FTrans.Currency, 0);
                                        Result := Conv_TCurr(Result, XRate(FTrans.CXRate,BOff,FTrans.Currency), FTrans.Currency, UOR, BOff);
                                        *****)

                                        // Get Transaction Total In Currency and remove sign
                                        DocType := TKDocTypeToEntDocType (TransDocHed);
                                        Result := DocCnst[DocType] * DocNotCnst * Get_thTotals(TransTotSignedInCcy);

                                        // Remove VAT Element as that needs converting using Daily Rates
                                        Result := Result - InvVAT;

                                        // Convert to Base Currency using current rates
                                        UOR := fxUseORate (BOff, BOn, FTrans.CXRate, FTrans.UseORate, FTrans.Currency, 0);
                                        Result := Round_Up(Conv_TCurr(Result, XRate(FTrans.CXRate,BOff,FTrans.Currency), FTrans.Currency, UOR, BOff), 2);

                                        // Convert VAT Element to BASE using Daily Rates
                                        Result := Result + Round_Up(Conv_TCurr(InvVAT, FTrans.CXRate[BON], FTrans.Currency, UOR, BOff), 2);

                                        // Add in Currency Variance
                                        Result := Result + Round_Up (FTrans.Variance, 2) +
                                                           Round_Up (FTrans.ReValueAdj, 2) +
                                                           Round_up (FTrans.PostDiscAm, 2);

                                        // Re-apply the sign
                                        Result := Result * DocCnst[DocType] * DocNotCnst;
                                      End;

    // Unsigned Transaction Total
    TransTotInCcy                   : Begin
                                        DocType := TKDocTypeToEntDocType (FTH.TransDocHed);
                                        Result := Get_thTotals(TransTotSignedInCcy) * DocCnst[DocType] * DocNotCnst;
                                      End;

    // Unsigned Transaction Total in Base Currency
    TransTotInBase                  : Begin
                                        DocType := TKDocTypeToEntDocType (FTH.TransDocHed);
                                        Result := Get_thTotals(TransTotSignedInBase) * DocCnst[DocType] * DocNotCnst;
                                      End;

    TransTotSettledInBase           : Result := Round_Up(FTrans.Settled, 2);

                                      //PR: 03/03/2015 ABSEXCH-16075 For SOR/SDN may have OrderPayments
    TransTotOutstandingInCcy        : if Get_thDocType in [dtSOR, dtSDN] then
                                        Result := Round_Up(GetOPOutstanding, 2)
                                      else
                                        Result := Round_Up(CurrencyOS (FTrans, BOn, BOff, BOff), 2);

                                      //PR: 03/03/2015 ABSEXCH-16075 For SOR/SDN may have OrderPayments
    TransTotOutstandingInBase       : if Get_thDocType in [dtSOR, dtSDN] then
                                        Result := Round_Up(Conv_TCurr(GetOPOutstanding, XRate(FTrans.CXRate,BOff,FTrans.Currency), FTrans.Currency, UOR, BOff),2)
                                      else
                                        Result := Round_Up(BaseTotalOs (FTrans), 2);

    TransTotNetInCcy                : Result := Round_Up(Get_thTotals(TransTotInCcy) - FTH.InvVAT, 2);

    TransTotNetInBase               : With FTH Do Begin
                                        Result := Get_thTotals(TransTotNetInCcy);

                                        // Convert to Base Currency using current rates
                                        UOR := fxUseORate (BOff, BOn, FTrans.CXRate, FTrans.UseORate, FTrans.Currency, 0);
                                        Result := Round_Up(Conv_TCurr(Result, XRate(FTrans.CXRate,BOff,FTrans.Currency), FTrans.Currency, UOR, BOff),2);
                                      End; { TransTotNetInBase }

    TransTotCostInBase              : Begin
                                        Result := FTH.TotalCost;

                                        // Convert to Base Currency using current rates
                                        UOR := fxUseORate (BOff, BOn, FTrans.CXRate, FTrans.UseORate, FTrans.Currency, 0);
                                        Result := Round_Up(Conv_TCurr(Result, XRate(FTrans.CXRate,BOff,FTrans.Currency), FTrans.Currency, UOR, BOff),2);
                                      End; { TransTotCostInBase }

    // HM 30/01/01: Added new Totals for Variance Support
    TransTotVarianceSignedInBase    : Result := Round_Up(FTrans.Variance + FTrans.PostDiscAm, 2);

    TransTotRevalAdjustSignedInBase : Result := Round_Up(FTrans.RevalueADJ, 2);
  Else
    Raise EUnknownValue.Create ('Unknown TotalType ' + QuotedStr(IntToStr(Ord(TotalType))));
  End; { Case TotalType }
end;

{-----------------------------------------}

function TTransaction.Get_thMatching: IMatching;
var
  UseIndex0 : Boolean;
begin
  AuthoriseFunction(204, 'thMatching', 1);

  { Check Matching sub-object has been initialised }
  If (Not Assigned(FMatchingO)) Then Begin
    { Create and initialise Customer Details }
    FMatchingO := CreateTMatching (12, FToolkit);

    FMatchingI := FMatchingO;
  End; { If (Not Assigned(FMatchingO)) }

  {PR: Added extra conditions to determine which index is used. Taken
   from ObjDrilU.pas. Also change to GetDataRecord in oMatch.pas to deal with
   Returns correctly.}
  UseIndex0 := (Trim(FTrans.RemitNo) <> '') or
               (FTrans.OrdMatch) or (FTrans.InvDocHed In [ADJ,TSH]);

  if FTrans.thOrderPaymentElement <> opeNA then
    UseIndex0 := not (FTrans.thOrderPaymentElement in [opeOrderPayment, opeDeliveryPayment, opeInvoicePayment]);

  // Check Matching sub-object is looking at the current transaction
  FMatchingO.SetStartKey (FTrans.OurRef, UseIndex0);

  Result := FMatchingI;
end;

{-----------------------------------------}

function TTransaction.Get_thAnalysisCodeI: IJobAnalysis;
begin
  With FToolkit As TToolkit Do
    Result := JobCostingO.JobAnalysisO.GetCloneInterface(Get_thAnalysisCode);
end;

{-----------------------------------------}

function TTransaction.Get_thJobCodeI: IJob;
begin
  With FToolkit As TToolkit Do
    Result := JobCostingO.JobO.GetCloneInterface(Get_thJobCode);
end;

{-------------------------------------------------------------------------------------------------}

function TTransaction.Print (PrintAs: TTransactionPrintMode): IPrintJob;
Const
  sModeErr = 'The ITransaction.Print Method does not support the specified mode (%d) for this transaction type (%s) - Please notify your Technical Support';
Var
  oPrintJob  : TPrintJob;
  FormMode   : TEFPrintFormMode;
  ImportDefs : TEFImportDefaultsType;
  THDocType  : DocTypes;
  JobType    : TPrintJobType;
  MainFNum, MainKPath   : SmallInt;
  TableFNum, TableKPath : SmallInt;
  MainKRef, TableKRef   : ShortString;
  DefAcc                : ShortString;
begin
{$If Defined(COMPRNT)}
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    Try
      // Only allow printing for general object and clone objects
      AuthoriseFunction(205, 'Print', 0);
      OutputDebug('ITransaction.Print Start');

      JobType := jtForm;

      // Identify subtype for ImportDefaults from Transaction Type
      THDocType := TKDocTypeToEntDocType (FTH.TransDocHed);
      Case THDocType Of
        SIN  : ImportDefs := deftypeSalesInvoice;
        SRI  : ImportDefs := deftypeSalesInvoiceWithReceipt;
        SCR  : ImportDefs := deftypeSalesCreditNote;
        SRF  : ImportDefs := deftypeSalesRefund;
        SQU  : ImportDefs := deftypeSalesQuote;
        SOR  : ImportDefs := deftypeSalesOrder;
        SDN  : ImportDefs := deftypeSalesDeliveryNote;
        SRC  : ImportDefs := deftypeSalesReceipt;
        SJI  : ImportDefs := deftypeSalesJournalInvoice;
        SJC  : ImportDefs := deftypeSalesJournalCredit;
        PIN  : ImportDefs := deftypePurchaseInvoice;
        PPY  : ImportDefs := deftypePurchasePayment;
        PCR  : ImportDefs := deftypePurchaseCreditNote;
        PQU  : ImportDefs := deftypePurchaseQuotation;
        POR  : ImportDefs := deftypePurchaseOrder;
        PDN  : ImportDefs := deftypePurchaseDeliveryNote;
        PJI  : ImportDefs := deftypePurchaseJournalInvoice;
        PJC  : ImportDefs := deftypePurchaseJournalCredit;
        PPI  : ImportDefs := deftypePurchasePaymentWithInvoice;
        PRF  : ImportDefs := deftypePurchaseRefund;
        TSH  : ImportDefs := deftypeTimesheet;
        WOR  : ImportDefs := deftypeWorksOrder;
        NMT  : ImportDefs := deftypeNominalTransfer;
        SBT,
        PBT  : ImportDefs := deftypeBatch;
        ADJ  : ImportDefs := deftypeStockAdjustment;

        // HM 09/03/04: Added Apps & Vals document types
        JPT  : ImportDefs := defTypeJobPurchaseTerms;
        JST  : ImportDefs := defTypeJobSalesTerms;
        JCT  : ImportDefs := defTypeJobContractTerms;
        JPA  : if FTH.thPostDiscTaken then
                 ImportDefs := defTypeJobPurchaseApplicationCertified
               else
                 ImportDefs := defTypeJobPurchaseApplication;
        JSA  : if FTH.thPostDiscTaken then
                 ImportDefs := defTypeJobSalesApplicationCertified
               else
                 ImportDefs := defTypeJobSalesApplication;

        // MH 28/07/05: Added Return Note defaults
        SRN  : ImportDefs := deftypeSalesReturnNote;
        PRN  : ImportDefs := deftypePurchaseReturnNote;
      Else
        Raise ENotSupported.Create ('The ' + FTH.TransDocHed + ' Transaction Type is not supported by the ITransaction.Print Method - Please notify your Technical Support');
      End; { Case }

      // Setup the default Transaction printing details
      MainFNum  := InvF;
      MainKPath := InvOurRefK;
      MainKRef  := FullOurRefKey(FTH.OurRef);
      TableFNum  := IDetailF;
      TableKPath := IdFolioK;
      TableKRef  := FullNomKey(FTH.FolioNum);
      DefAcc := FTH.CustCode;

      // Identify FormMode from PrintAs parameter
      Case PrintAs Of
        // Default Print Job
        thpmDefault           : If (THDocType = NMT) Then
                                  FormMode := fmNomTransfer
                                Else If (THDocType = ADJ) Then
                                  FormMode := fmStockAdjustment
                                // MH 06/07/2012 v7.0 ABSEXCH-12584: SRC's need to be printed as a Remittance Advice in order to show the Matching
                                //Else If (THDocType = PPY) Then
                                Else If (THDocType In [SRC, PPY]) Then
                                  FormMode := fmRemittanceAdvice
                                Else If (THDocType IN [SBT, PBT]) Then
                                  FormMode := fmBatchDocs
                                Else
                                  FormMode := fmNormalDocs;

        // Pro-Forma
        thpmSalesProForma     : If (THDocType In [SQU, SOR]) Then Begin
                                  FormMode := fmNormalDocs;
                                  ImportDefs := deftypeSalesProForma;
                                End { If (THDocType In [SQU, SOR]) }
                                Else
                                  Raise ENotSupported.Create (Format(sModeErr, [Ord(PrintAs), FTH.TransDocHed]));

        // Debit Note - PPY's only
        thpmPPYDebitNote      : If (THDocType = PPY) Then Begin
                                  FormMode := fmNomTransfer;
                                  ImportDefs := deftypePurchasePaymentDebitNote;
                                End { If (THDocType = PPY) }
                                Else
                                  Raise ENotSupported.Create (Format(sModeErr, [Ord(PrintAs), FTH.TransDocHed]));

        // Deliver Labels - effecively just a header label
        thpmDeliveryLabel     : If Not (THDocType In [SBT, PBT, ADJ, TSH, NMT]) Then Begin
                                  FormMode := fmLabel;
                                  ImportDefs := deftypeDeliveryLabel;
                                  JobType := jtLabel;
                                End
                                Else
                                  Raise ENotSupported.Create (Format(sModeErr, [Ord(PrintAs), FTH.TransDocHed]));

        // Sales Quote as Sales Order  (Poor man's SPOP)
        thpmSQUAsOrder        : If (THDocType = SQU) Then Begin
                                  FormMode := fmNormalDocs;
                                  ImportDefs := deftypeSalesOrder;
                                End
                                Else
                                  Raise ENotSupported.Create (Format(sModeErr, [Ord(PrintAs), FTH.TransDocHed]));

        // Sales Quote as Sales Delivery Note  (Poor man's SPOP)
        thpmSQUAsDeliveryNote : If (THDocType = SQU) Then Begin
                                  FormMode := fmNormalDocs;
                                  ImportDefs := deftypeSalesDeliveryNote;
                                End
                                Else
                                  Raise ENotSupported.Create (Format(sModeErr, [Ord(PrintAs), FTH.TransDocHed]));

        // Stock Labels - Only works in conjunction with ImportDefaults
        thpmStockLabels       : If Not (THDocType In [SBT, PBT, ADJ, TSH, NMT]) Then Begin
                                  FormMode := fmLabel;
                                  ImportDefs := deftypeTransProductLabels;
                                  JobType := jtLabelRun;
                                End
                                Else
                                  Raise ENotSupported.Create (Format(sModeErr, [Ord(PrintAs), FTH.TransDocHed]));

        // Print Labels for Serial Numbers on Line - Only works in conjunction with ImportDefaults
        thpmSerialLabels      : If (THDocType In [SQU, SOR, SDN, PQU, POR, PDN]) Then Begin
                                  FormMode := fmSerialLabel;
                                  ImportDefs := deftypeTransSerialLabels;
                                  JobType := jtLabelRun;
                                End
                                Else
                                  Raise ENotSupported.Create (Format(sModeErr, [Ord(PrintAs), FTH.TransDocHed]));

        thpmWorksIssueNote    : If (THDocType = ADJ) Then Begin
                                  FormMode := fmStockAdjustment;
                                  ImportDefs := deftypeWorksIssueNote;
                                End
                                Else
                                  Raise ENotSupported.Create (Format(sModeErr, [Ord(PrintAs), FTH.TransDocHed]));

        thpmConsignmentNote   : If (THDocType = SDN) Then Begin
                                  FormMode := fmNormalDocs;
                                  ImportDefs := deftypeConsignmentNote;
                                End
                                Else
                                  Raise ENotSupported.Create (Format(sModeErr, [Ord(PrintAs), FTH.TransDocHed]));

        // Individual Picking List
        thpmPickingList       : If (THDocType In [SOR, SDN, WOR]) Then Begin
                                  FormMode := fmNormalDocs;
                                  ImportDefs := deftypePickingList;
                                End
                                Else
                                  Raise ENotSupported.Create (Format(sModeErr, [Ord(PrintAs), FTH.TransDocHed]));

        // Custom / Consolidated Picking List
        thpmCustomPickingList : If (THDocType In [SOR, SDN, WOR]) Then Begin
                                  FormMode := fmPickListConsolidated;
                                  ImportDefs := defTypeConsolidatedPickingList;

                                  // Table contains the transaction lines
                                  TableFNum  := ReportF;
                                  TableKPath := RpK;
                                  TableKRef  := FullNomKey(1);

                                  // Setup link to Account for Import Defaults
                                  DefAcc     := '';
                                End
                                Else
                                  Raise ENotSupported.Create (Format(sModeErr, [Ord(PrintAs), FTH.TransDocHed]));

        // Transaction Header + Notes
        thpmNotes             : Begin
                                  FormMode := fmTransNotes;
                                  ImportDefs := defTypeTransNotes;

                                  // Change to link to Transaction Notes
                                  TableFNum := PwrdF;
                                  TableKPath := PWK;
                                  TableKRef  := NoteTCode + NoteDCode + FullNCode(FullNomKey(FTH.FolioNum))
                                End;

        // Job Costing Backing Sheet
        thpmJCBackingSheet    : Begin
                                  FormMode := fmJobBackingSheet;
                                  ImportDefs := defTypeJCBackingSheet;

                                  // Change to link to Transaction Notes
                                  TableFNum := JDetlF;
                                  TableKPath := JDLedgerK;
                                  TableKRef  := JBRCode + JBECode + FullJobCode(FTH.DJobCode) + #1;
                                End;

        // MH 28/07/05: Added Goods Returns for v5.70
        thpmSRNAsRepairQuote  : Begin
                                  FormMode := fmNormalDocs;
                                  ImportDefs := defTypeSRNAsRepairQuote;
                                End;

        // MH 17/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
        thpmSRCAsVATReceipt   : If (THDocType = SRC) And (FTH.thOrderPaymentElement In [Ord(opeOrderPayment)..Ord(opeInvoiceRefund)]) Then
                                Begin
                                  FormMode := fmOrderPaymentsVATReceipt;
                                  If (FTH.InvNetVal > 0) Then
                                    ImportDefs := defTypePaymentSRCAsVATReceipt
                                  Else
                                    ImportDefs := defTypeRefundSRCAsVATReceipt;
                                End // If (THDocType = SRC) And (FTH.thOrderPaymentElement In [opeOrderPayment..opeInvoiceRefund])
                                Else
                                  Raise ENotSupported.Create (Format(sModeErr, [Ord(PrintAs), FTH.TransDocHed]));

    (*  HM 19/11/02: Can't do the matching until after v5.01 ships as requires changes to
                     DictNary.Dat, DicLinkU, DicLnk2U, etc...

        // Transaction Header + Matching in Table
        Matching transactions
                 [Order procesing]
                 SOR, SDN,
                 SIN.

                 POR, PDN,
                 PIN.

                 [WOP/ Order Processing]
                 WOR, ADJ, NOM

                 [Financial matchuing]
                 SIN, SCR, SJI, SJC, SRC

                 PIN, PCR, PJC, PJI, PPY
    *)

      Else
        Raise ENotSupported.Create (Format('The ITransaction.Print Method does not support the specified PrintAs (%d) parameter  - Please notify your Technical Support', [Ord(PrintAs)]));
      End; { Case PrintAs }

      OutputDebug(Format('ITransaction.Print. OurRef=%s; PrintAs=%d; FormMode=%d', [FTH.OurRef, Ord(PrintAs), Ord(FormMode)]));
      // Create and initialise the PrintJob object
      oPrintJob := TPrintJob.Create(FToolkit, FormMode, ImportDefs, JobType);
      With oPrintJob Do Begin
        // Configure to print the transaction
        MainFileNum  := MainFNum;
        MainKeyPath  := MainKPath;
        MainKeyRef   := MainKRef;

        TableFileNum := TableFNum;
        TableKeyPath := TableKPath;
        TableKeyRef  := TableKRef;

        DefaultAcc   := DefAcc;

        // For Label Runs need to import the data now
        If (ImportDefs = deftypeTransSerialLabels) Or (ImportDefs = deftypeTransProductLabels) Then Begin
          // Stock/Serial Labels - need to import all lines as separate items
          With FormsToolkitI.PrintJob.ImportDefaults Do Begin
            idType   := ImportDefs;
            idAcCode := DefaultAcc;

            // Main File = Invoice
            idMainFileNo    := MainFileNum;
            idMainIndexNo   := MainKeyPath;
            idMainKeyString := MainKeyRef;

            // Tabl = Lines
            idTableFileNo    := TableFileNum;
            idTableIndexNo   := TableKeyPath;
            idTableKeyString := TableKeyRef;

            // Add Labels in FormsTK will load the Trans and run through the lines adding
            // items into the PrintJob for Serial Numbers where applicable
            AddLabels;
          End; { With FPrintToolkitI.PrintJob.ImportDefaults }
        End; { If (PrintAs = thpmStockLabels) }
      End; { With oPrintJob }

      // Return reference to interface - object will be automatically destroyed when
      // user reference to it is lost
      Result := oPrintJob;
    Except
      on E: Exception do
      begin
        AddErrorLog ('ITransaction.Print', E.Message);
        raise;
      end;
    End;
    OutputDebug('ITransaction.Print End');
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
{$IfEnd}
end;

{-------------------------------------------------------------------------------------------------}

// Mode = Bit Field
//   1 - Serial Labels - Line Picked Qty
//   2 - Stock Lines Only
//   4 - Serial/Batch Lines Only
//   8 -
Procedure TTransaction.enumPrintLineLabels(Const oTL : TTransactionLine; Const iTL : ITransactionLine; Ptr : Pointer; Mode : LongInt);
Var
  oPrintJob : TPrintJob;
  FuncRes   : LongInt;
  Cont      : Boolean;
Begin { enumPrintLineLabels }
  // Check to see if any filtering is required
  If ((Mode And 2) = 2) Or ((Mode And 4) = 4) Then
    With iTL Do Begin
      // Check for a valid Stock code
      Cont := (Trim(tlStockCode) <> '') And Assigned(tlStockCodeI);

      If Cont And ((Mode And 4) = 4) Then
        // Check for Serial/Batch usage
        Cont := tlSerialBatch.tlUsesSerialBatchNo;
    End { If ((Mode And 2) = 2) Or ((Mode And 4) = 4) }
  Else
    Cont := True;

  If Cont Then Begin
    // Convert Ptr to PrintJob Object
    oPrintJob := TPrintJob(Ptr);

    // Add a new Form for this printjob
    With oPrintJob.FormsToolkitI.PrintJob.pjForms.Add Do Begin
      // Mode
      fdMode := EnterpriseForms_TLB.fmLabel;

      // Form Name - use default from global Settings
      fdFormName := SyssForms^.FormDefs.PrimaryForm[21];

      // Number of copies of each label
      If ((Mode And 1) = 1) Then Begin
        // Bit 1 - If set use Picked Qty else use Line Qty
        If (iTL.tlQtyPicked <> 0.0) Then
          fdLabelCopies := Trunc(Round_Up(iTL.tlQtyPicked, 0))
        Else
          fdLabelCopies := Trunc(Round_Up(iTL.tlQty, 0));
      End { If ((Mode And 1) = 1)  }
      Else
        // Default - Use Line Qty
        fdLabelCopies := Trunc(Round_Up(iTL.tlQty, 0));

      // Main File - Transaction Line
      fdMainFileNo := IDetailF;
      fdMainIndexNo := IdLinkK;
      fdMainKeyString := FullNomKey(iTL.tlFolioNum) + FullNomKey(iTL.tlABSLineNo);

      // Table File - Not Applicable to Labels

      // Save the Form Job if valid
      If (fdLabelCopies > 0) And (Trim(fdFormName) <> '') Then
        // Save the form
        FuncRes := Save;
    End; { With oPrintJob.FormsToolkitI.PrintJob.pjForms.Add }
  End; { If Cont }
End; { enumPrintLineLabels}

{-------------------------------------------------------------------------------------------------}

procedure TTransaction.InitViews;
begin
  FAsNOMO := nil;
  FAsNOMI := nil;

  FAsTSHO := nil;
  FAsTSHI := nil;

  FAsADJO := nil;
  FAsADJI := nil;

  FAsWORO := nil;
  FAsWORI := nil;

  FLinksO := nil;
  FLinksI := nil;

  FAutoO := nil;
  FAutoI := nil;

  FAsBatchO := nil;
  FAsBatchI := nil;

  FAsReturnO := nil;
  FAsReturnI := nil;

  FSetBatchInfo := nil;

end;


function TTransaction.Get_thAsNom: ITransactionAsNOM;
begin
  if not Assigned(FAsNOMO) and (FTH.TransDocHed = 'NOM') then
  begin
    FAsNOMO := TTransactionAsNOM.Create(Self, @FTH, ITransactionAsNOM2);

    FAsNOMI := FAsNOMO;
  end;

  Result := FAsNOMI;
end;

function TTransaction.Get_thAsTSH: ITransactionAsTSH;
begin
  if not Assigned(FAsTSHO) and (FTH.TransDocHed = 'TSH') then
  begin
    FAsTSHO := TTransactionAsTSH.Create(Self, @FTH, ITransactionAsTSH);

    FAsTSHI := FAsTSHO;
  end;

  Result := FAsTSHI;
end;

function TTransaction.Get_thAsADJ: ITransactionAsADJ;
begin
  if not Assigned(FAsADJO) and (FTH.TransDocHed = 'ADJ') then
  begin
    FAsADJO := TTransactionAsADJ.Create(Self, @FTH, ITransactionAsADJ);

    FAsADJI := FAsADJO;
  end;

  Result := FAsADJI;
end;

function TTransaction.Get_thAsWOR: ITransactionAsWOR;
begin
  if not Assigned(FAsWORO) and (FTH.TransDocHed = 'WOR') then
  begin
    FAsWORO := TTransactionAsWOR.Create(Self, @FTH, ITransactionAsWOR);

    FAsWORI := FAsWORO;
  end;

  Result := FAsWORI;
end;

function TTransaction.Get_thAsApplication: ITransactionAsApplication;
begin
  if not Assigned(FAsAppO) and IsApplication(FTH.TransDocHed) then
  begin
    FAsAppO := TTransactionAsApplication.Create(Self, @FTH, ITransactionAsApplication);
    FAsAppO.Trans2 := Self;

    FAsAppI := FAsAppO;
  end;

  Result := FAsAppI;
end;

function TTransaction.GetData: WideString;
begin
  SetLength(Result, SizeOf(FTH));
  Move(FTH, Result[1], SizeOf(FTH));
end;

function TTransaction.ConvertData(const DataRec: WideString): WideString;
var
  LocalTH : TBatchTHRec;
  DummyInv : InvRec;
  EditNo : Byte;
begin
  EditNo := 0;
  Move(DataRec[1], LocalTH, SizeOf(LocalTH));
  if ExInvToInv(LocalTH, B_CopyOnly, DummyInv, EditNo) = 0 then
  begin
    SetLength(Result, SizeOf(Inv));
    Move(Inv, Result[1], SizeOf(Inv))
  end
  else
    Result := '';
end;

function TTransaction.Get_thLinks: ILinks;
begin
  if Not Assigned(FLinksO) then
  begin
    FLinksO := TLinks.Create(imGeneral, FBtrIntf, 'T', '', FTH.FolioNum);

    FLinksI := FLinksO;
  end;

  FLinksO.OwnerType := 'T';
  FLinksO.OwnerCode := '';
  FLinksO.OwnerFolio := FTH.FolioNum;
  Result := FLinksI;

end;

function TTransaction.Get_thAutoSettings: IAutoTransactionSettings;
begin
  if Not Assigned(FAutoO) then
  begin
    FAutoO := TAutoTransactionSettings.Create(@FTH, FIntfType);

    FAutoI := FAutoO;
  end;

  Result := FAutoI;
end;

procedure TTransaction.SetNextAutoDocNo;
var
  AnInv : InvRec;
  AcPr, AcYr : Byte;
begin
  FillChar(AnInv, SizeOf(AnInv), #0);
  AnInv.InvDocHed := TKDocTypeToEntDocType(FTH.TransDocHed);

  SetNextAutoDocNos(AnInv, True);

  FTH.OurRef := AnInv.OurRef;
  FTH.FolioNum := AnInv.FolioNum;
  FTH.RunNo := -2;

  //Set default dates & periods if blank
  if FTH.TransDate = '' then
    FTH.TransDate := Today;
  if FTH.AutoEndDate = '' then
    FTH.AutoEndDate := '21491231';
  SimpleDate2Pr(Today, AcPr, AcYr);
  if FTH.AcYr = 0 then
    FTH.AcYr := AcYr;
  if FTH.AcPr = 0 then
    FTH.AcPr := AcPr;
  SimpleDate2Pr('21491231', AcPr, AcYr);
  if FTH.AutoEndYr = 0 then
    FTH.AutoEndYr := AcYr;
  if FTH.AutoEndPr = 0 then
    FTH.AutoEndPr := AcPr;

end;

function TTransaction.CopyReverse(Which : Byte): ITransaction2;
{Returns a clone of the resulting copied or reversed transaction. Raises
an exception if not successful.

Which: 1 = Copy, 2 = Reverse}
{Change at Mark's request (MTGP) to return an add object}
var
  P : PChar;
  S : String;
  Res : SmallInt;
  OldIdx : Byte;
  OldOurRef : string;
  Err : string;
  TransO : TTransaction;
  DType : DocTypes;
  i : longint;
  AsNom : ITransactionAsNOM2;
begin
DType := TKDocTypeToEntDocType(FTH.TransDocHed);
{$IFDEF OLD}
  {$IFDEF COMSOP}
  //Save original file position & Index
  OldIdx := Get_Index;
  OldOurRef := FTH.OurRef;
  P := StrAlloc(255);
  Try
    StrPCopy(P, FTH.OurRef);

    Res := SP_INITDLL;
    if Res = 0 then
    begin
      Res := SP_COPYTRANSACTION(P);
      SP_CLOSEDLL;
      if Res = 0 then
      begin
        S := StrPas(P);
        Set_Index(thIdxOurRef);
        Res := GetEqual(BuildOurRefIndex(S));
        if Res = 0 then
          Result := Clone as ITransaction2
        else
          Res := 100 + Res;
      end;
    end;
  Finally
    StrDispose(P);
  // restore original position and index
    GetEqual(BuildOurRefIndex(OldOurRef));
    Set_Index(OldIdx);

  End;

  if Res <> 0 then
  begin
    Result := nil;
    Case Which of
      1 : Err := 'Copy';
      2 : Err := 'Reverse';
    end;
    raise Exception.Create('Exception in ITransaction2.' + Err + ': ' + IntToStr(Res));
  end;
  {$ELSE}
  Result := nil;
  {$ENDIF}
{$ELSE}
  TransO := TTransaction.Create(imCopy, FToolkit, Self, FBtrIntf);

  // Load transaction details
  TransO.CloneDetails(FTH);

  if Which = 2 then
  begin //reverse
    DType := TKDocTypeToEntDocType(FTH.TransDocHed);
    DType := ReverseDoc(DType);
    TransO.FTH.TransDocHed := DocCodes[DType];
  end;

  TransO.Set_thOurRef(FTH.TransDocHed);


  //Need to reset exchange rates to current
  TransO.Set_thDailyRate(ISystemSetup(TToolkit(FToolkit).SystemSetupO).ssCurrency[FTH.Currency].scDailyRate);
  TransO.Set_thCompanyRate(ISystemSetup(TToolkit(FToolkit).SystemSetupO).ssCurrency[FTH.Currency].scCompanyRate);

  //Reset hold flag
  TransO.Set_thHoldFlag(0);

  //PR: 16/09/2014  v7.x Order Payments - T102 Clear OP-specific fields

  TransO.FTH.thOrderPaymentElement := 0;
  TransO.FTH.thOrderPaymentFlags := 0;

  //Blank out strings
  FillChar(TransO.FTH.thOrderPaymentOrderRef, SizeOf(TransO.FTH.thOrderPaymentOrderRef), 0);
  FillChar(TransO.FTH.thCreditCardType, SizeOf(TransO.FTH.thCreditCardType), 0);
  FillChar(TransO.FTH.thCreditCardNumber, SizeOf(TransO.FTH.thCreditCardNumber), 0);
  FillChar(TransO.FTH.thCreditCardExpiry, SizeOf(TransO.FTH.thCreditCardExpiry), 0);
  FillChar(TransO.FTH.thCreditCardAuthorisationNo, SizeOf(TransO.FTH.thCreditCardAuthorisationNo), 0);
  FillChar(TransO.FTH.thCreditCardReferenceNo, SizeOf(TransO.FTH.thCreditCardReferenceNo), 0);
  FillChar(TransO.FTH.thCustomData1, SizeOf(TransO.FTH.thCustomData1), 0);

  //PR: 26/01/2016 ABSEXCH-17112 v2016 R1 Clear Intrastat Out of Period flag
  TransO.FTH.thIntrastatOutOfPeriod := False;

  TransO.Get_thLines;
  // return interface onto object
  Result := TransO;

  if DType = NMT then
  begin
    //Need to reverse all values in new nom
    for i := 1 to Result.thLines.thLineCount do
    begin
      Result.thLines[i].tlNetValue := -Result.thLines[i].tlNetValue;
      Result.thLines[i].tlVatAmount := -Result.thLines[i].tlVatAmount;
    end;

    Result.thNetValue := -Result.thNetValue;
    Result.thTotalVat := -Result.thTotalVat;

    AsNom := Result.thAsNom as ITransactionAsNom2;

    if AsNom.tnVatIO = vioInput then
      AsNom.tnVatIO := vioOutput
    else
    if AsNom.tnVatIO = vioOutput then
      AsNom.tnVatIO := vioInput;

    For i := 0 to 20 do
      TransO.FTH.InvVatAnal[i] := -TransO.FTH.InvVATAnal[i];
  end;

{$ENDIF}
end;

function TTransaction.Copy: ITransaction2;
begin
  AuthoriseFunction(206, 'Copy');
  Result := CopyReverse(1);
end;

function TTransaction.Reverse: ITransaction2;
begin
  AuthoriseFunction(207, 'Reverse');
  Result := CopyReverse(2);
end;

function TTransaction.Convert(DestDocType: TDocTypes): ISingleConvert;
var
  TempRec : TBatchConvRec;
  ResObject : TSingleConvert;
begin
  AuthoriseFunction(208, 'Convert');

  if not SPOPOn and ( (Get_thDocType in SPOPGroup) or (DestDocType in SPOPGroup)) then
    raise EInvalidMethod.Create('This installation of Exchequer is not licenced for Order Processing');

  if DocToOk(FTH.OurRef, DestDocType) then
  begin
    FillChar(TempRec, SizeOf(TempRec), 0);

    TempRec.cvDocFrom := FTH.OurRef;
    TempRec.cvDocToType := TLBDocTypeToTKDocType(DestDocType);

    ResObject := TSingleConvert.Create(FToolkit);
    ResObject.SetDetails(TempRec);

    Result := ResObject;
  end
  else
    raise Exception.Create('Invalid conversion: ' +
                             System.Copy(FTH.OurRef, 1, 3) + ' to ' + TLBDocTypeToTKDocType(DestDocType));
end;

function TTransaction.BackToBackOrder: IBackToBackOrder;
var
  FB2BO : TBackToBackOrder;
begin
  AuthoriseFunction(209, 'BackToBackOrder', 1);

  FB2BO := TBackToBackOrder.Create;

  FB2BO.OurRef := FTH.OurRef;
  FB2BO.LCount := Get_thLines.thLineCount;
  FB2BO.Toolkit := FToolkit;

  Result := FB2BO;

end;

function TTransaction.Get_thAsBatch: ITransactionAsBatch;
var
  SaveInfo              : TBtrieveSavePosType;
  SaveInfo2, SaveInfo3  : TBtrieveFileSavePos;
  Res                   : longint;
  TransO, TransO2       : TTransaction;
  oldIdx                : Byte;
begin
  if IsBatchHeader(FTH.TransDocHed) then
  begin
    if not Assigned(FAsBatchO) then
    begin
      SaveInfo := SaveSystemFilePos ([]);
      SaveExLocalPos(SaveInfo2);

      FAsBatchO := TTransactionAsBatch.Create(Self, FToolkit, @FTH, ITransactionAsBatch);

      TransO := TTransaction.Create(imGeneral, FToolkit, Self, FBtrIntf);

      Try
        TransO.Set_Index(thIdxBatchLink);
        Res := TransO.GetGreaterThanOrEqual(FTH.OurRef);

        while (Res = 0) and (Trim(FTH.OurRef) = Trim(TransO.GetBatchLink)) do
        begin
          TransO.SaveExLocalPos(SaveInfo3);
          FAsBatchO.AddToList(TransO);

          TransO := TTransaction.Create(imGeneral, FToolkit, Self, FBtrIntf);
          TransO.RestoreExLocalPos(SaveInfo3);
          Res := TransO.GetNext;
        end;
      Finally
        TransO := nil;
      End;

      RestoreExLocalPos(SaveInfo2);
      RestoreSystemFilePos (SaveInfo);
      FAsBatchI := FAsBatchO;
    end;
  end
  else
    FAsBatchI := nil;

  Result := FAsBatchI;
end;

function TTransaction.InUpdateMode : Boolean;
begin
  Result := FIntfType = imUpdate;
end;

procedure TTransaction.ConvertToBatchGeneral;
begin
  FIntfType := imGeneral;
  FTHLinesO.Transform (imGeneral);
end;

function TTransaction.GetBatchLink : String;
begin
  Result := FTH.BatchLink;
end;

function TTransaction.QuietBatchSave : Integer;
var
  SaveInfo              : TBtrieveSavePosType;
  SaveInfo2             : TBtrieveFileSavePos;
  TLArray               : TLArrayInfoType;
begin
  SaveInfo := SaveSystemFilePos ([]);
  Result := PositionOnLock;
  SaveExLocalPos(SaveInfo2);

  if Result = 0 then
  begin
    Result := Ex_CreateTLArray (FTHLinesO.Lines.Count + 1, TLArray);

    if Result = 0 then
      Result := EX_STORETRANS(@FTH, TLArray.TLArray, SizeOf(FTH), TLArray.UsedSize, FIndex, B_Update);
  end;

  RestoreExLocalPos(SaveInfo2);
  // Restore original file positions
  RestoreSystemFilePos (SaveInfo);

end;

function TTransaction.Delete: Integer;
var
  KeyS : PChar;
  Res : LongInt;
begin
  AuthoriseFunction(210, 'Delete');

  KeyS := StrAlloc(255);

  Try
    StrPCopy(KeyS, Get_thOurRef);
    Result := Ex_DeleteQuote(KeyS);
    if Result = 0 then
    begin
      //Position transaction on next record in index
      Res := GetNext;
      if Res = 9 then
        GetLast;
    end;
  Finally
    StrDispose(KeyS);
  End;

end;

function TTransaction.Get_thTagNo: Byte;
begin
  Result := FTH.Tagged;
end;

procedure TTransaction.Set_thTagNo(Value: Byte); safecall;
begin
  if OkToUpdate then
  begin
    if (Value <= 99) then
      FTH.Tagged := Value
    else
      raise EValidation.Create('Invalid TagNo (' + IntToStr(Value) + ')');
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

function TTransaction.UpdateEx(UpdateMode: TTransactionUpdateMode): ITransaction2;
Var
  TransO  : TTransaction;
  FuncRes : LongInt;
  TempInv : InvRec;
  P : TBatchCallBackProc;
  CreateMode : TInterfaceMode;
begin
  CreateMode := imUpdateEx;
  Result := Nil;
  AuthoriseFunction(105, 'UpdateEx');
  FOldDueDate := Get_thDueDate;

  // Lock Current Transaction Header
  if (Get_thRunNo <> -10) or not Assigned(FSetBatchInfo) then
    FuncRes := Lock
  else
  begin //Deal with batch member
    FIndex := 2;
    P := FSetBatchInfo;
    FuncRes := GetEqual(Get_thOurRef);
    FSetBatchInfo := P;
    if FuncRes = 0 then
      FuncRes := DummyLock;
    FIndex := 7;
  end;

  If (FuncRes = 0) Then Begin
    Case UpdateMode of
      umDefault      : CreateMode := imUpdateEx;
      umNonFinancial : CreateMode := imUpdateEx2;
    end;
    // Create an update object
    TransO := TTransaction.Create(CreateMode, FToolkit, Self, FBtrIntf);

    TransO.SetBatchInfo := FSetBatchInfo;
    TransO.BatchIndex := BatchIndex;
    TransO.OldDueDate := FOldDueDate;
    // Pass current Account Record and Locking Details into sub-object
    TransO.LoadDetails(FTH, FTrans, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := TransO;
  End; { If (FuncRes = 0) }
end;

function TTransaction.SaveAfterUpdateEx: Integer;
begin
  //Store header udfs + tagged + HoldFlg
  Result := Ex_StoreTransHed(@FTH, SizeOf(FTH));

  //PR: 28/10/2011 v6.9
  if Result = 0 then
    AuditNote.AddNote(anTransaction, Inv.FolioNum, anEdit);

  if (Result = 0) then
  begin
    //Allocate memory for pchars - used in updateduedate & updatelinedate
    FNewDueDate := StrAlloc(255);
    FOurRef := StrAlloc(255);
    Try
      //Do we need to update duedate?
      if (FOldDueDate <> Get_thDueDate) then
      begin
        StrPCopy(FNewDueDate, Get_thDueDate);
        StrPCopy(FOurRef, Get_thOurRef);

        Result := Ex_UpdateDueDate(FOurRef, FNewDueDate);
      end;

      if Result = 0 then
      begin
        FLineError := 0;
        FTHLinesO.EnumLines (enumSaveLineDetails, NIL, 0);
        Result := FLineError;
        if FLineError = 0 then
          FSaveErrorLine := 0;
      end;

    Finally
      StrDispose(FNewDueDate);
      StrDispose(FOurRef);
    End;
  end;

  if Result <> 0 then
  //Set error message
  begin
    Case Result of
      30000, 30004 : LastErDesc := Ex_ErrorDescription (162, Result); //UpdateLineDate
      30001, 30002 : LastErDesc := Ex_ErrorDescription (149, Result); //UpdateDueDate
      else
        LastErDesc := Ex_ErrorDescription (133, Result); //StoreTransHedOrDetl
    end;//case
  end;
end;

Procedure TTransaction.enumSaveLineDetails(Const oTL : TTransactionLine; Const iTL : ITransactionLine;
                                            Ptr : Pointer; Mode : LongInt);
begin
  if FLineError = 0 then
    inc(FSaveErrorLine);

  //PR: 07/03/2012 Original change for ABSEXCH-12017 (as below) wasn't
  //checking LineDateChanged.
  if (FLineError = 0) and (oTL.DetailsChanged or oTL.LineDateChanged) then
    FLineError := Ex_StoreTransDetl(@oTL.TL, SizeOf(TBatchTLRec));

  //PR: 23/02/2012 Removed call to Ex_UpdateLineDate. Line date is now updated
  //(for COMTk only) in Ex_StoreTransDetl ABSEXCH-12017
end;

Function TTransaction.GetCloneInterface (Const OurRef : ShortString) : ITransaction;
Var
  SaveInfo : TBtrieveFileSavePos;
  lOurRef  : ShortString;
  Res      : LongInt;
Begin { GetCloneInterface }
  Result := NIL;

  // Reformat as valid account code
  lOurRef := FullOurRefKey(OurRef);

  // Check not blank
  If (Trim(lOurRef) <> '') Then Begin
    // Save Current Position and index
    SaveExLocalPosRec (SaveInfo, @FTH, SizeOf(FTH));

    // Find record for AcCode
    Set_Index(thIdxOurRef);
    Res := GetDataRecord (B_GetEq, lOurRef);
    If (Res = 0) Then Begin
      // Got Record - generate and return a Clone interface
      Result := Clone;
    End; { If (Res = 0) }

    // Restore Original Index and position
    RestoreExLocalPosRec (SaveInfo, @FTH, SizeOf(FTH));
  End; { If (Trim(lAcCode) <> '') }
End; { GetCloneInterface }

function TTransaction.Get_thCISTaxDue: Double;
begin
  Result := FTH.CISTax;
end;

procedure TTransaction.Set_thCISTaxDue(Value: Double);
begin
  if OkToUpdate then
    FTH.CISTax := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

function TTransaction.Get_thCISTaxDeclared: Double;
begin
  Result := FTH.CISDeclared;
end;

function TTransaction.Get_thCISManualTax: WordBool;
begin
  Result := BoolToWordBool(FTH.CISManualTax);
end;

procedure TTransaction.Set_thCISManualTax(Value: WordBool);
begin
  if OkToUpdate then
    FTH.CISManualTax := WordBoolToBool(Value)
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

function TTransaction.Get_thCISDate: WideString;
begin
  Result := FTH.CISDate;
end;

function TTransaction.Get_thCISTotalGross: Double;
begin
  Result := FTH.CISGross;
end;

procedure TTransaction.Set_thCISTotalGross(Value: Double);
begin
  if OkToUpdate then
    FTH.CISGross := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

function TTransaction.Get_thCISSource: Byte;
begin
  Result := FTH.CISHolder;
end;

function TTransaction.Get_thTotalCostApport: Double;
begin
  Result := FTH.TotalCost2;
end;

procedure TTransaction.Set_thTotalCostApport(Value: Double);
begin
  if OkToUpdate then
    FTH.TotalCost2 := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

function TTransaction.Get_thCISEmployee: WideString;
begin
  Result := FTH.CISEmpl;
end;

procedure TTransaction.Set_thCISEmployee(const Value: WideString);
begin
  if OkToUpdate then
    FTH.CISEmpl := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;


function TTransaction.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;

function TTransaction.OkToUpdate : Boolean;
begin
  Result := not (FIntfType in [imUpdateEx2]);
end;

function TTransaction.BuildOutstandingIndexWithAccount(const StatusChar: WideString;
                                                       const AccountCode: WideString): WideString;
begin
  Result := BuildOutstandingIndex(StatusChar) + LJVar(AccountCode, 6);
end;

function TTransaction.Get_thAutoTransaction: WordBool;
begin
  Result := FTH.thAutoTransaction;
end;

function TTransaction.Get_thDeliveryRunNo: WideString;
begin
  Result := FTH.thDeliveryRunNo;
end;

function TTransaction.Get_thExternal: WordBool;
begin
  Result := FTH.thExternal;
end;

function TTransaction.Get_thSettledVat: Double;
begin
  Result := FTH.thSettledVAT;
end;

function TTransaction.Get_thVATClaimed: Double;
begin
  Result := FTH.thVATClaimed;
end;

function TTransaction.Get_thPickingRunNo: Integer;
begin
  Result := FTH.thPickingRunNo;
end;

function TTransaction.Get_thDeliveryNoteRef: WideString;
begin
  Result := FTH.thDeliveryNoteRef;
end;

function TTransaction.Get_thVATCompanyRate: Double;
begin
  Result := FTH.thVATCompanyRate;
end;

function TTransaction.Get_thVATDailyRate: Double;
begin
  Result := FTH.thVATDailyRate;
end;

function TTransaction.Get_thPostCompanyRate: Double;
begin
  Result := FTH.thPostCompanyRate;
end;

function TTransaction.Get_thPostDailyRate: Double;
begin
  Result := FTH.thPostDailyRate;
end;

function TTransaction.Get_thPostDiscAmount: Double;
begin
  Result := FTH.thPostDiscAmount;
end;

function TTransaction.Get_thPostDiscTaken: WordBool;
begin
  Result := FTH.thPostDiscTaken;
end;

function TTransaction.Get_thLastDebtChaseLetter: Integer;
begin
  Result := FTH.thLastDebtChaseLetter;
end;

function TTransaction.Get_thExported: WordBool; safecall;
begin
  Result := FTH.thExported;
end;

procedure TTransaction.Set_thExported(Value: WordBool); safecall;
begin
  FTH.thExported := Value;
end;

function TTransaction.Get_RecordPosition: Integer;
Var
  RecPos : LongInt;
Begin
  // Get Record Position
  FBtrIntf^.LGetPos(InvF, RecPos);
  Result := RecPos;
End;

//======================================================================

procedure TTransaction2.SetJobCode(const JobCode : string);
begin
  FJobCode := FullJobCode(JobCode);
end;

function TTransaction2.CopyReverse(Which: Byte): ITransaction2;
var
  P : PChar;
  S : String;
  Res : SmallInt;
  OldIdx : Byte;
  OldOurRef : string;
  Err : string;
  TransO : TTransaction2;
  DType : DocTypes;
  i : longint;
begin
  TransO := TTransaction2.Create(imCopy, FToolkit, Self, FBtrIntf);

  // Load transaction details
  TransO.CloneDetails(FTH);
  TransO.Set_thOurRef(FTH.TransDocHed);

  //Need to reset exchange rates to current
  TransO.Set_thDailyRate(ISystemSetup(TToolkit(FToolkit).SystemSetupO).ssCurrency[FTH.Currency].scDailyRate);
  TransO.Set_thCompanyRate(ISystemSetup(TToolkit(FToolkit).SystemSetupO).ssCurrency[FTH.Currency].scCompanyRate);

  //Reset hold flag
  TransO.Set_thHoldFlag(0);

  TransO.Get_thLines;
  // return interface onto object
  Result := TransO;
end;

Function TTransaction2.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS, KeyChk      : Str255;
  OldIdx : SmallInt;
  Loop : Boolean;
begin
{Used for finding applications or terms belonging to a particular job. The jobcode is in the longyrref field,
prefixed with a char to indicate which type.}
BtrOpCode2 := 0;
 if FIntfType = imMasterTerms then
   Result := GetDataRecord2(BtrOp, SearchKey)
 else
 begin
  Result := 0;
  LastErDesc := '';

  OldIdx := FIndex;
  Set_Index(thIdxLongYourRef);

  With FBtrIntf^ Do Begin

    KeyS := chPrefix[Get_thDocType] + FJobCode;
    KeyChk := KeyS;

    Case BtrOp of
      B_GetFirst    :  begin
                          BtrOpCode := B_GetGEq;
                          BtrOpCode2 := B_GetNext;
                        end;

      B_GetLast     :  begin
                          KeyS := KeyS + #255;
                          BtrOpCode := B_GetLessEq;
                          BtrOpCode2 := B_GetPrev;
                       end;
      B_GetNext     :  begin
                          BtrOpCode := B_GetNext;
                          BtrOpCode2 := B_GetNext;
                        end;

      B_GetPrev     :  begin
                          BtrOpCode := B_GetPrev;
                          BtrOpCode2 := B_GetPrev;
                       end;

      else
        BtrOpCode := BtrOp;


    end;
{    KeyS := SearchKey;
    BtrOpCode := BtrOp;}



    // Get record
    Loop := True;
    Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

    while (Result = 0) and Loop do
    begin
      {Not as simple as one might hope - there appear to be empty keys mixed in - presumably
      where a string has been set to '' rather than being blanked out completely. So pass over seemingly
      empty keys.}
      If (Result = 0) and (CheckKey(KeyChk, LInv.TransDesc, Length(KeyChk), True) or
                           (LInv.TransDesc = '')) Then
      begin
        if LInv.TransDesc = '' then
        begin
          Result := LFind_Rec (BtrOpCode2, FFileNo, FIndex, KeyS);
          Loop := True;
        end
        else
        begin
          CopyDataRecord;
          Loop := False;
        end;

      end
      else
        Result := 9;

    end;

    Changed := True;
    FKeyString := KeyS;
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (20, Result);
 end;
end;

Function TTransaction2.AuthoriseFunction (Const FuncNo     : Byte;
                                         Const MethodName : String;
                                         Const AccessType : Byte = 0) : Boolean;
Begin { AuthoriseFunction }
  Case FuncNo Of
    5..8      : Result := (FIntfType in [imGeneral, imAV]);

    11,14     : Result := (FIntfType in [imMasterTerms, imAV]); //Get equal in masterterms

    // .Add method
    100       : Result := (FIntfType in [imMasterTerms, imAV]);
    // .Update method
    101       : Result := (FIntfType in [imMasterTerms, imAV]);
    // .Save method
    102       : Result := (FIntfType In [imAdd, imUpdate, imCopy, imUpdateEx, imUpdateEx2, imMasterTerms]);
    // .Cancel method
    103       : Result := (FIntfType in [imUpdate, imUpdateEx, imUpdateEx2]);
    // .Clone method
    104       : Result := (FIntfType in [imGeneral, imAV]);
    // .UpdateEx method
    105       : Result := (FIntfType = imGeneral);

    // .AllocateTransNo
    201       : Result := (FIntfType = imAdd);

    // .thNotes property
    202       : Result := (FIntfType = imGeneral);

    // .Print
    205       : Result := (FIntfType In [imGeneral, imClone]);
    // .Copy
    206       : Result := (FIntfType In [imGeneral, imClone, imAV]);

    // .thOrderPaymentDetails
    207       : Result := (FIntfType In [imGeneral, imClone]) And (FTH.TransDocHed = 'SOR');
  Else
    Result := False;
  End; { Case FuncNo }

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }
End; { AuthoriseFunction }

procedure TTransaction2.Set_thLongYourRef(const Value: WideString);
begin
  raise Exception.Create('Property thLongYourRef cannot be set in this object');
end;

procedure TTransaction2.SetDocType(const DType : string);
begin
  FTH.TransDocHed := DType;
  FDocHed := DType;
end;

function TTransaction2.Add(TransactionType: TDocTypes): ITransaction;
Var
  TransO  : TTransaction;
begin
  AuthoriseFunction(100, 'Add');

  // Create a new Transaction object
  TransO := TTransaction2.Create(imAdd, FToolkit, Self, FBtrIntf);
  TransO.InitNewTrans(TransactionType);

  Result := TransO;
end;

function TTransaction2.Save(CalculateTotals: WordBool): Integer;
Type
  LineArrayType = Array [1..10000] Of TBatchTLRec;
Var
  SaveInfo              : TBtrieveSavePosType;
  SaveInfo2             : TBtrieveFileSavePos;
  TLArray               : TLArrayInfoType;
  pLines                : ^LineArrayType;
  I, BtrOp, Res         : SmallInt;
  {LineTotal, DiscTotal  : Double;}
  LastErr               : ShortString;
  BatchInfo             : TBatchInfo;
  OldIdx                : integer;
  BatchCalc             : Boolean;
  IsMasterTerms         : Boolean;
  TermsType             : Byte;
begin
  FAbsLineCount := 0;
  AuthoriseFunction(102, 'Save');

  IsMasterTerms := FIntfType = imMasterTerms;
  // Reset the Save Error Line property
  FSaveErrorLine := 0;

  begin

    // Save current file positions in main files
    SaveInfo := SaveSystemFilePos ([]);

    If (FIntfType in [imUpdate]) Then Begin
      // Updating - Reposition on original Locked Transaction
      Result := PositionOnLock;
      BtrOp := B_Update;

    End { If (FIntfType = imUpdate) }
    Else Begin
      // Adding - no need to do anything
      Result := 0;
      BtrOp := B_Insert;


      // Check OurRef has been assigned
      If (Not ExSyss.OverWORef) And (Not FOurRefAssigned) Then
        SetNextDocNo;
    End; { Else }

    If (Result = 0) Then Begin
      // Build array of TL Lines for Ex_StoreTrans
      Result := Ex_CreateTLArray (FTHLinesO.Lines.Count +
                                  FDeductLinesO.Lines.Count +
                                  FRetLinesO.Lines.Count + 1, TLArray);

      // Load TLArray using the lines enum function
      //AP : 12/12/2016 : ABSEXCH-17394 The function TTransaction.enumBuildSaveArray is showing an error dialog rather than just returning an error code
      //Exception from enumBuildSaveArray is being handled here.
      Try
        FTHLinesO.EnumLines (enumBuildSaveArray, @TLArray, 0);
      Except
        Result := EnumRes;
      End;
      Try
        FRetLinesO.EnumLines (enumBuildSaveArray, @TLArray, 0);
      Except
        Result := EnumRes;
      End;
      Try
        FDeductLinesO.EnumLines (enumBuildSaveArray, @TLArray, 0);
      Except
        Result := EnumRes;
      End;

      // Update Transaction details before storing
      FTH.LineCount := TLArray.NumTL;

      If CalculateTotals Then
        InitHeaderTotals;

      pLines := TLArray.TLArray;
      For I := 1 To TLArray.NumTL Do
        With pLines^[I] Do Begin
          // OurRef
          TransRefNo := FTH.OurRef;

          // Folio Number - probably not set- but won't hurt
          FolioNum := FTH.FolioNum;

          // Account Code
          CustCode := FTH.CustCode;

          // Currency & Rates
          If (FTH.TransDocHed <> 'NOM') Then Begin
            // HM 27/02/01: Not for Nominal Trasfers as it prevents multi-ccy NOM's
            Currency := FTH.Currency;
            CoRate := FTH.CoRate;
            VATRate := FTH.VATRate;
          End; { If (FTH.TransDocHed <> 'NOM') }

          // Update Transaction Header Totals if specified
          If CalculateTotals Then
          begin
            // CS 2011-08-16 ABSEXCH-11149 - Check for invalid VATIncFlg
            UpdateHeaderTotals (pLines^[I], Result);
            pLines^[I].RtnErrCode := Result;
          end;

          // Update Transaction Header Totals if specified
          {If CalculateTotals Then }Begin
            // Cost
            if (LineNo > 0) and ((FTH.TransDocHed = 'JPA') or (FTH.TransDocHed = 'JSA')) then
              if (FTH.TransNat = 2) then
                FTH.TotalInvoiced := FTH.TotalInvoiced + CostPrice;
            (****
            // VAT - Check not Manual VAT
            If (Not FTH.ManVAT) And (VAT <> 0.0) Then Begin
              // Update VAT Analysis & Totals
              VatIdx := VatCharToIdx(VATCode);
              FTH.InvVatAnal[VatIdx] := FTH.InvVatAnal[VatIdx] + VAT;

              FTH.InvVat := FTH.InvVat + VAT;
            End; { If (Not ManVAT) }

            // Value - exlcuding Line and Settlement Discount
            Res := EX_GETLINETOTAL(@Plines^[I], SizeOf(Plines^[I]), False, 0.0, LineTotal);

            // HM 30/11/00: Modified for SRI Payment Lines
            If (FTH.TransDocHed <> 'SRI') Or (Not Payment) Then
              FTH.InvNetVal := FTH.InvNetVal + LineTotal;

            // Line Discount
            Res := EX_GETLINETOTAL(@Plines^[I], SizeOf(Plines^[I]), True, 0.0, DiscTotal);
            FTH.DiscAmount := FTH.DiscAmount + (LineTotal - DiscTotal);  ****)
          End; { If UpdateTotals }

        End; { With pLines^[I] }

      // CS 2011-08-16 ABSEXCH-11149 - Check for invalid VATIncFlg
      if (Result = 0) then
      begin
        // Add/Update Transaction
        SaveExLocalPos(SaveInfo2);
        if Assigned(FSetBatchInfo) and Assigned(FParentTH) then
        begin //batchmember
          FTH.RunNo := -10;
          if BtrOp = B_Insert then
            FTH.BatchLink := FParentTH.Get_thOurRef;
          FTH.NomAuto := False;
          BatchEdit := True;
        end;
        Result := EX_STOREJAPTRANS(@FTH, TLArray.TLArray, SizeOf(FTH), TLArray.UsedSize, FIndex, BtrOp,
                                      FBtrIntf^);
        Unlock;
        RestoreExLocalPos(SaveInfo2);
      end;



      If (Result = 0) Then Begin
        // HM 14/03/01: Convert into Clone object after a successful Save
        FIntfType := imClone;
        FTHLinesO.Transform (imClone);


      End { If }
      Else
        If (TLArray.NumTL > 0) Then Begin
          // Try to identify which line caused the problem
          pLines := TLArray.TLArray;
          For I := 1 To TLArray.NumTL Do
            // Check RtnErrCode to see which line had the problem
            If (pLines^[I].RtnErrCode <> 0) Then
            begin
              FSaveErrorLine := I;
              // CS 2011-08-16 ABSEXCH-11149 - Check for invalid VATIncFlg
              LastErDesc := Ex_ErrorDescription (21, pLines^[I].RtnErrCode);
            end;
        End; { If }

      // Release TLArray memory
      LastErr := LasterDesc;
      Ex_DestroyTLArray (TLArray);
      LasterDesc := LastErr;
    End; { If (Res = 0) }

    // Restore original file positions
    RestoreSystemFilePos (SaveInfo);

    if IsMasterTerms and Assigned(FTermsProc) then
    begin
      if Get_thDocType = dtJPT then
        TermsType := 1
      else
        Termstype := 0;

      if (Result = 0) and not CheckOnly then
        FTermsProc(TermsType, FTH.OurRef)
      else
        FTermsProc(TermsType, '');

      FTermsProc := nil;
      FJobApps := nil;

    end;

  end;
end;

procedure TTransaction2.Set_thJobCode(const Value: WideString);
begin
  if Trim(FTH.DJobCode) <> '' then
    raise Exception.Create('Property thJobCode is read-only in this object')
  else
    FTH.DJobCode := FullJobCode(Value);
end;

Function TTransaction2.GetDataRecord2 (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode : SmallInt;
  KeyS      : Str255;
begin
  Result := 0;
  LastErDesc := '';

  With FBtrIntf^ Do Begin
    KeyS := SearchKey;
    BtrOpCode := BtrOp;

    // Get record
    Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

    If (Result = 0) Then
      CopyDataRecord;

    Changed := True;
    FKeyString := KeyS;
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (20, Result);
end;

procedure TTransaction2.Set_thNetValue(Value: Double);
begin
  raise Exception.Create('thNetValue cannot be written to in this object');
end;

//Override Lock & Unlock methods to use multiple locks rather than single - needed to update terms transactions when
//application is updated
function TTransaction2.Lock : Integer;
Var
  SaveInfo : TBtrieveFileSavePos;
  lRes     : LongInt;
begin
  With FBtrIntf^ Do Begin
    // Save position in global file
    SaveMainPos(SaveInfo);

    // Save Record Position into LockPos so we can later use it for unlocking
    Result := LGetPos (FFileNo, FLockPosition);
    If (Result = 0) Then Begin
      // Copy locked record position into data record
      SetDataRecOfsPtr (FFileNo, FLockPosition, RecPtr[FFileNo]^);

      // Reread and lock record
      Result := GetDirect(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex, B_MultLock + B_SingNWLock);
      If (Result = 0) Then
        // Record Locked
        Inc (FLockCount)
      Else
        // Error
        Inc (Result, 31000);
    End { If (Result = 0) }
    Else
      // Error getting current record position
      Inc (Result, 30000);

    // restore position in global file
    RestoreMainPos(SaveInfo);
  End; { With FBtrIntf^ }
end;

// Unlocks a previously locked record
function TTransaction2.Unlock: Integer;
Var
  KeyS : Str255;
begin
  If (FLockCount > 0) Then Begin
    // Copy locked record position into data record
    SetDataRecOfsPtr(FFileNo, FLockPosition, RecPtr[FFileNo]^);

    // Unlock Record
    FillChar (KeyS, Sizeof(KeyS), #0);
    Result := Find_Rec(B_Unlock, F[FFileNo], FFileNo, RecPtr[FFileNo]^, -1, KeyS);
    If (Result <> 0) Then Inc (Result, 30000);

    Dec(FLockCount);
  End; { If (FLockCount > 0) }
end;

function TTransaction2.Get_thLines: ITransactionLines;
begin
  GetLines;
  Result := FTHLinesI;
end;

function  TTransaction2.Get_thDeductionLines: ITransactionLines;
begin
  GetLines;
  Result := FDeductLinesI;
end;

function  TTransaction2.Get_thRetentionLines: ITransactionLines;
begin
  GetLines;
  Result := FRetLinesI;
end;


Procedure TTransaction2.InitObjects;
Begin { Destroy }
  inherited;
  // Transaction Line sub-object
  FDeductLinesO := Nil;
  FDeductLinesI := Nil;

  FRetLinesO := Nil;
  FRetLinesI := Nil;

  FTermsProc := nil;

End; { Destroy }

procedure TTransaction2.ImportDefaults;
var
  GotEmp,
  GotInv  : Boolean;
  EmpR    : EmplType;
  InvR    : InvRec;
  KeyS    : Str255;
  siPos   : TBtrieveFileSavePos;
begin
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    GotEmp := False; GotInv := False;

    with FBtrIntf^ do
    begin
      if Trim(FTH.thDeliveryNoteRef) <> '' then
      begin
        KeyS := FTH.thDeliveryNoteRef;
        SaveExLocalPosFile (InvF, siPos);
        GotInv := LFind_Rec(B_GetEq, InvF, InvOurRefK, KeyS) = 0;
        If GotInv Then InvR := LInv;
        RestoreExLocalPos (siPos);
      end;

      if GotInv  then
      begin
        if (Trim(FTH.CISEmpl) = '') then
          FTH.CISEmpl := InvR.CISEmpl;
        FTH.DJobCode := InvR.DJobCode;
        if (FTH.TransDocHed = 'JPA') or (FTH.TransDocHed = 'JSA') then
          FTH.TransNat := InvR.TransMode;
  {      else
          FTH.TransMode := InvR.TransMode;}
      end;

      If (Trim(FTH.CISEmpl) <> '') Then Begin
        // Get Employee Record
        SaveExLocalPosFile (JMiscF, siPos);
        GotEmp := LGetMainRec(JMiscF, PartCCKey(JARCode, JAECode) + LJVar(FTH.CISEmpl,6));
        If GotEmp Then EmpR := LJobMisc^.EmplRec;
        RestoreExLocalPos (siPos);
      End; { If (Trim(TransHed.EmpCode) <> '') }

      if GotEmp and (FTH.TransDocHed = 'JPA') then
        FTH.CustCode := EmpR.Supplier;
    end;
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;

function  TTransaction2.GetDeductionLines: ITransactionLines;
begin
  Result := Get_thDeductionLines;
end;

function  TTransaction2.GetRetentionLines: ITransactionLines;
begin
  Result := Get_thRetentionLines;
end;


procedure TTransaction2.SetTermsProc(TProc : TSetTermsProc;  OJ : IJobApplications);
begin
  FTermsProc := TProc;
  FJobApps := OJ;
end;

Destructor TTransaction2.Destroy;
begin
  inherited;
end;

Procedure TTransaction2.enumBuildSaveArray(Const oTL : TTransactionLine; Const iTL : ITransactionLine; Ptr : Pointer; Mode : LongInt);
Var
  TLArray : ^TLArrayInfoType;
  RateR   : EmplPayType;
Begin { enumBuildSaveArray }
  // Dereference pointer to TLArray
  TLArray := Ptr;
  //This protected variable is being used by the child classes too so it is needed to initialize it as '0' here
  EnumRes := 0;

  if Get_thDocType = dtTSH then //Set invalid flag for timerates
    oTL.SetInvalidTimeRates(not oTL.GetTimeRate(RateR, Get_thEmployeeCode));
  if FIntfType = imAdd then
    oTL.SetAbsLineNo(FAbsLineCount)
  else //Update
    oTL.SetAbsLineNo(FTH.LineCount);
  // Add line into TLArray
  EnumRes := EX_ADDTLARRAYLINE (TLArray^, oTL.TL);

  //AP : 12/12/2016 : ABSEXCH-17394 The function TTransaction.enumBuildSaveArray is showing an error dialog rather than just returning an error code
  //Instead of showing message dialog, system will raise an exception.
  If (EnumRes <> 0) Then
  Begin
    Raise Exception.Create(LastErDesc);
  End; { If (EnumRes <> 0) }
End; { enumBuildSaveArray }

function TTransaction.Get_LineCount : Integer;
begin
  Result := FTrans.ILineCount;
end;

function TTransaction.GetDocType : TDocTypes;
begin
  Result := Get_thDocType;
end;

procedure TTransaction.Set_thOutstanding(const Value : WideString);
begin
  FTH.AllocStat := ExtractChar(Value, #0);
  FTH.BDMode := 1;
end;

procedure TTransaction.Set_thDeliveryRunNo(const Value : WideString);
begin
  FTH.thDeliveryRunNo := Value;
  FTH.BDMode := 1;
end;

procedure TTransaction.Set_thSource(Value : Integer);
begin
  FTH.ExtSource := Value;
  FTH.BDMode := 1;
end;

function TTransaction.Get_thTotalInvoiced: Double;
begin
  Result := FTH.TotalInvoiced;
end;


procedure TTransaction.Set_thTotalInvoiced(Value : Double);
begin
  FTH.TotalInvoiced := Value;
  FTH.BDMode := 1;
end;

function TTransaction.Get_thOrdMatch: WordBool;
begin
  Result := FTH.thOrdMatch;
end;

procedure TTransaction.Set_thOrdMatch(Value: WordBool);
begin
  FTH.thOrdMatch := Value;
  FTH.BDMode := 1;
end;

function TTransaction.Get_thAutoPost: WordBool;
begin
  Result := FTH.thAutoPost;
end;

procedure TTransaction.Set_thZeroLineNos(Value: WordBool);
begin
  FTH.thZeroLineNos := Value;
end;

procedure TTransaction.Set_thAllowCtrlCodes(Value: WordBool);
begin
  FTH.thAllowCtrlCodes := Value;
end;

function TTransaction.Get_thTotalReserved: Double;
begin
  Result := FTH.thTotalReserved;
end;

procedure TTransaction.Set_thTotalReserved(Value: Double);
begin
  FTH.thTotalReserved := Value;
end;

{function TTransaction.Get_thPostDiscAmount: Double;
begin
  Result := FTH.thPostDiscAmount;
end;}

procedure TTransaction.Set_thPostDiscAmount(Value: Double);
begin
  FTH.thPostDiscAmount := Value;
end;

function TTransaction.Get_thVariance: Double;
begin
  Result := FTH.thVariance;
end;

procedure TTransaction.Set_thVariance(Value: Double);
begin
  FTH.thVariance := Value;
end;

function TTransaction.Get_thTotalOrdered: Double;
begin
  Result := FTH.thTotalOrdered;
end;

procedure TTransaction.Set_thTotalOrdered(Value: Double);
begin
  FTH.thTotalOrdered := Value;
end;

function TTransaction.Get_thRevalueAdj: Double;
begin
  Result := FTH.thRevalueAdj;
end;

procedure TTransaction.Set_thRevalueAdj(Value: Double);
begin
  FTH.thRevalueAdj := Value;
end;


function TTransaction.Get_thAsReturn: ITransactionAsReturn;
begin
  if not Assigned(FAsReturnO) and ((FTH.TransDocHed = 'PRN') or (FTH.TransDocHed = 'SRN')) then
  begin
    FAsReturnO := TTransactionAsReturn.Create(Self, @FTH, ITransactionAsReturn, Self);

    FAsReturnI := FAsReturnO;
  end;

  Result := FAsReturnI;
end;

function TTransaction.CreateReturn: ITransactionReturnCreate;
var
  oReturnCreate : TReturnCreateFromTrans;
begin
  AuthoriseFunction(211, 'CreateReturn',1);

  oReturnCreate := TReturnCreateFromTrans.Create(Self, TToolkit(FToolkit));

  oReturnCreate.Toolkit := TToolkit(FToolkit);

  Result := oReturnCreate;
end;


function TTransaction.Get_thVatPostDate: WideString;
begin
  Result := FTH.thVatPostDate;
end;

function TTransaction.ApplyTTD(DiscountValue: Double;
  const DiscountFlag: WideString): Integer;
begin
  AuthoriseFunction(212, 'ApplyTTD');
  Result := 0;
  if (Pos('%', DiscountFlag) <> 1) or (DiscountValue >= 0) and (DiscountValue <= 100) then
  begin
    FTH.thTTDValue := DiscountValue;
    FTH.thTTDFlag := ExtractChar(DiscountFlag, ' ');
    if FTH.thTTDFlag <> '%' then
    begin
      FTH.thTTDFlag := ' ';
    end
    else
      FTH.thTTDValue := FTH.thTTDValue / 100;

  end
  else
  begin
    Result := 30000;
    LastErDesc := 'Invalid Discount';
  end;
end;

procedure TTransaction.CalculateVBD(var VBDValue: Double; var VBDVAT: Double);
var
  i, Res : integer;
  TLArray               : TLArrayInfoType;

begin
  GetLines;
  Res := Ex_CreateTLArray (FTHLinesO.Lines.Count + 1, TLArray);

  if Res = 0 then
  begin
    // Load TLArray using the lines enum function
    //AP : 12/12/2016 : ABSEXCH-17394 The function TTransaction.enumBuildSaveArray is showing an error dialog rather than just returning an error code
    //Exception from enumBuildSaveArray is being handled here.
    Try
      FTHLinesO.EnumLines (enumBuildSaveArray, @TLArray, 0);
    Except
      Res := EnumRes;
    End;

    // Update Transaction details
    FTH.LineCount := TLArray.NumTL;

    UpdateTotals;

    Try
      Res := EX_GETVBDVALUE(@FTH, TLArray.TLArray, SizeOf(FTH), TLArray.UsedSize, VBDValue, VBDVAT);
    Finally
      Ex_DestroyTLArray (TLArray);
    End;

    end;

    if Res <> 0 then
    raise Exception.Create('Unable to execute Get_VBDValue');
end;


function TTransaction.Get_thWeekMonth: Smallint;
begin
  Result := FTH.thWeekMonth;
end;

function TTransaction.Get_thWorkFlowState: Integer;
begin
  Result := FTH.thWorkFlowState;
end;

procedure TTransaction.Set_thWeekMonth(Value: Smallint);
begin
  FTH.thWeekMonth := Value;
end;

procedure TTransaction.Set_thWorkFlowState(Value: Integer);
begin
  FTH.thWorkFlowState := Value;
end;

//PR: 15/10/2010 New field for LIVE
function TTransaction.Get_thOverrideLocation: WideString;
begin
  Result := FTH.thOverrideLocation;
end;

procedure TTransaction.Set_thOverrideLocation(const Value: WideString);
begin
  FTH.thOverrideLocation := Value;
end;

function TTransaction.Get_thUserField10: WideString;
begin
  Result := FTH.DocUser10;
end;

function TTransaction.Get_thUserField5: WideString;
begin
  Result := FTH.DocUser5;
end;

function TTransaction.Get_thUserField6: WideString;
begin
  Result := FTH.DocUser6;
end;

function TTransaction.Get_thUserField7: WideString;
begin
  Result := FTH.DocUser7;
end;

function TTransaction.Get_thUserField8: WideString;
begin
  Result := FTH.DocUser8;
end;

function TTransaction.Get_thUserfield9: WideString;
begin
  Result := FTH.DocUser9;
end;

procedure TTransaction.Set_thUserField10(const Value: WideString);
begin
  if OkToUpdate then
    FTH.DocUser10 := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

procedure TTransaction.Set_thUserField5(const Value: WideString);
begin
  if OkToUpdate then
    FTH.DocUser5 := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

procedure TTransaction.Set_thUserField6(const Value: WideString);
begin
  if OkToUpdate then
    FTH.DocUser6 := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

procedure TTransaction.Set_thUserField7(const Value: WideString);
begin
  if OkToUpdate then
    FTH.DocUser7 := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

procedure TTransaction.Set_thUserField8(const Value: WideString);
begin
  if OkToUpdate then
    FTH.DocUser8 := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

procedure TTransaction.Set_thUserfield9(const Value: WideString);
begin
  if OkToUpdate then
    FTH.DocUser9 := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg2);
end;

function TTransaction.Get_thDeliveryPostCode: WideString;
begin
  Result := FTH.thDeliveryPostCode;
end;

procedure TTransaction.Set_thDeliveryPostCode(const Value: WideString);
begin
  FTH.thDeliveryPostCode := Value;
end;

//PR: 28/10/2010 ABSEXCH-14705 ITransaction11
function TTransaction.Get_thCreationDate: WideString;
begin
  Result := FTH.thCreationDate;
end;

function TTransaction.Get_thCreationTime: WideString;
begin
  Result := FTH.thCreationTime;
end;

function TTransaction.Get_thOriginator: WideString;
begin
  Result := FTH.thOriginator;
end;

procedure TTransaction.Set_thOriginator(const Value: WideString);
begin
  FTH.thOriginator := Value;
end;

// CJS 2014-08-05 - v7.x Order Payments - T098 - new fields - ITransaction12
function TTransaction.Get_thCreditCardAuthorisationNo: WideString;
begin
  Result := FTH.thCreditCardAuthorisationNo;
end;

function TTransaction.Get_thCreditCardExpiry: WideString;
begin
  Result := FTH.thCreditCardExpiry;
end;

function TTransaction.Get_thCreditCardNumber: WideString;
begin
  Result := FTH.thCreditCardNumber;
end;

function TTransaction.Get_thCreditCardReferenceNo: WideString;
begin
  Result := FTH.thCreditCardReferenceNo;
end;

function TTransaction.Get_thCreditCardType: WideString;
begin
  Result := FTH.thCreditCardType;
end;

function TTransaction.Get_thCustomData1: WideString;
begin
  Result := FTH.thCustomData1;
end;

function TTransaction.Get_thOrderPaymentElement: TOrderPaymentElement;
begin
  Result := FTH.thOrderPaymentElement;
end;

function TTransaction.Get_thOrderPaymentFlags: Integer;
begin
  Result := FTH.thOrderPaymentFlags;
end;

function TTransaction.Get_thOrderPaymentOrderRef: WideString;
begin
  Result := FTH.thOrderPaymentOrderRef;
end;

procedure TTransaction.Set_thCreditCardAuthorisationNo(
  const Value: WideString);
begin
  FTH.thCreditCardAuthorisationNo := Value;
end;

procedure TTransaction.Set_thCreditCardExpiry(const Value: WideString);
begin
  FTH.thCreditCardExpiry := Value;
end;

procedure TTransaction.Set_thCreditCardNumber(const Value: WideString);
begin
  FTH.thCreditCardNumber := Value;
end;

procedure TTransaction.Set_thCreditCardReferenceNo(
  const Value: WideString);
begin
  FTH.thCreditCardReferenceNo := Value;
end;

procedure TTransaction.Set_thCreditCardType(const Value: WideString);
begin
  FTH.thCreditCardType := Value;
end;

procedure TTransaction.Set_thCustomData1(const Value: WideString);
begin
  FTH.thCustomData1 := Value;
end;

procedure TTransaction.Set_thOrderPaymentFlags(Value: Integer);
begin
  FTH.thOrderPaymentFlags := Value;
end;

//------------------------------

function TTransaction.Get_thOrderPaymentDetails: ITransactionOrderPaymentDetailsList;
Begin // Get_thOrderPaymentDetails
  AuthoriseFunction(213, 'thOrderPaymentDetails', 1);

  // Check sub-object has been initialised
  If (Not Assigned(FOrderPaymentsO)) Then
  Begin
    FOrderPaymentsO := CreateTTransactionOrderPaymentDetails;
    FOrderPaymentsI := FOrderPaymentsO;
  End; // If (Not Assigned(FOrderPaymentsO))

  // Check sub-object is looking at the current transaction
  FOrderPaymentsO.SetStartKey (FTrans.OurRef);

  Result := FOrderPaymentsI;
End; // Get_thOrderPaymentDetails

//------------------------------

function TTransaction.TakePayment: IOrderPaymentTakePayment;
var
  KeyS : Str255;
  Res : integer;
begin
  AuthoriseFunction(214, 'TakePayment');
  KeyS := FullCustCode(FTrans.CustCode);

  Res := FBtrIntf.LFind_Rec(B_GetEq, CustF, CustCodeK, KeyS);
  Result := TOrderPaymentPayment.Create(FTrans, FBtrIntf.LCust);
end;

function TTransaction.GiveRefund: IOrderPaymentGiveRefund;
var
  KeyS : Str255;
  Res : integer;
begin
  AuthoriseFunction(215, 'GiveRefund');
  KeyS := FullCustCode(FTrans.CustCode);

  Res := FBtrIntf.LFind_Rec(B_GetEq, CustF, CustCodeK, KeyS);
  Result := TOrderPaymentRefund.Create(Self, BtrIntf.LCust, FToolkit as TToolkit);
end;

function TTransaction.Get_thOrderPaymentMatching: IOrderPaymentMatchingList;
begin
  AuthoriseFunction(216, 'thOrderPaymentMatching', 1);

  if not Assigned(FOrderPaymentMatchListO) then
  begin
    if SQLUtils.UsingSQL then
      FOrderPaymentMatchListO := TMSSQLOrderPaymentMatchingList.Create(FTH.OurRef, FToolkit, FBtrIntf)
    else
      FOrderPaymentMatchListO := TPervasiveOrderPaymentMatchingList.Create(FTH.OurRef, FToolkit, FBtrIntf);

    FOrderPaymentMatchListI := FOrderPaymentMatchListO;
  end;
  FOrderPaymentMatchListO.OurRef := FTH.OurRef;


  Result := FOrderPaymentMatchListI;
end;

function TTransaction.AddAuditNote(const Text : WideString) : Integer; safecall;
var
  Res : Integer;
begin
  AuthoriseFunction(217, 'Add AuditNote');

  Result := AuditNote.AddCustomAuditNote(anTransaction, FTH.FolioNum, Text);
end;

//PR: 03/03/2015 ABSEXCH-16075 For SOR/SDN may have OrderPayments so return O/S using OP functions
function TTransaction.GetOPOutstanding: Double;
var
  iOPPaymentInfo : IOrderPaymentsTransactionInfo;
  Outstanding : Double;
begin
  //Check if this transaction is part of Order Payments
  if FBtrIntf.LInv.thOrderPaymentElement <> opeNA then
  begin
    iOPPaymentInfo := OPTransactionInfo (FBtrIntf.LInv);
    Try
     Result := iOPPaymentInfo.optMaxPayment;
    Finally
      iOPPaymentInfo := nil;
    End;
  end
  else //if FBtrIntf.LInv.thOurderPaymentElement <> opeNA
    Result := 0.0;
end;

//PR: 24/01/2015 v7.0.14 ABSEXCH-16284 ITransaction12 New fields for Prompt Payment Discount
function TTransaction.Get_thPPDPercentage: Double; safecall;
begin
  Result := FTH.thPPDPercentage;
end;

procedure TTransaction.Set_thPPDPercentage(Value: Double); safecall;
begin
  FTH.thPPDPercentage := Value;
end;

function TTransaction.Get_thPPDDays: SmallInt; safecall;
begin
  Result := FTH.thPPDDays;
end;

procedure TTransaction.Set_thPPDDays(Value: SmallInt); safecall;
begin
  FTH.thPPDDays := Value;
end;

function TTransaction.Get_thPPDTaken: TPPDTakenMode; safecall;
begin
  Result := FTH.thPPDTaken;
end;

procedure TTransaction.Set_thPPDTaken(Value: TPPDTakenMode); safecall;
begin
  FTH.thPPDTaken := Value;
end;

function TTransaction.Get_thPPDGoodsValue: Double; safecall;
begin
  Result := FTH.thPPDGoodsValue;
end;

function TTransaction.Get_thPPDVATValue: Double; safecall;
begin
  Result := FTH.thPPDVATValue;
end;

function TTransaction.TakePPD: Integer;
var
  TakePPDO : ITakePPD;
  KeyS : Str255;
  SaveInfo : TBtrieveFileSavePos;
  oCust : CustRec;
begin
  //Get an instance of ITakePPDO
  TakePPDO := GetTakePPD;

  //If LCust isn't populated with the correct account record, go and find it
  if FBtrIntf.LCust.CustCode <> FTH.CustCode then
  begin
    SaveExLocalPosFile (CustF, SaveInfo);
    Try
      KeyS := FullCustCode (FTH.CustCode);
      if FBtrIntf.LGetMainRec(CustF, KeyS) then
        TakePPDO.tpAccount := FBtrIntf.LCust
      else
        raise EUnknownValue.Create('Account record ' + KeyS + ' not found.');
    Finally
      RestoreExLocalPos (SaveInfo);
    End;
  end
  else
    TakePPDO.tpAccount := FBtrIntf.LCust;

  //PR: 04/09/2015 2015 R1 ABSEXCH-16821 Need to open IncF in ExLocal, otherwise hangs when trying to get new doc no
  FBtrIntf.Open_System(IncF, IncF);


  //Set properties
  TakePPDO.tpDate := EtDateU.Today;
  TakePPDO.AddInvoice(FBtrIntf.LInv);
  TakePPDO.tpExLocal := FBtrIntf;

  //Run process
  Result := TakePPDO.Execute;

  //Set last error string from TakePPD object's error string
  if Result <> 0 then
    LastErDesc := TakePPDO.tpErrorString;
end;

function TTransaction.Get_thPPDCreditNote: WordBool; safecall;
begin
  Result := FTH.thPPDCreditNote;
end;

procedure TTransaction.SetPrintedStatus(Value: WordBool);
begin
  FTH.PrintedDoc := WordBoolToBool(Value);
end;

function TTransaction.Get_thIntrastatOutOfPeriod: WordBool;
begin
  Result := FTH.thIntrastatOutOfPeriod;
end;

function TTransaction.Get_thUserField11: WideString; safecall;
begin
  Result := FTH.DocUser11;
end;

procedure TTransaction.Set_thUserField11(const Value: WideString); safecall;
begin
  FTH.DocUser11 := Value;
end;

function TTransaction.Get_thUserField12: WideString; safecall;
begin
  Result := FTH.DocUser12;
end;

procedure TTransaction.Set_thUserField12(const Value: WideString); safecall;
begin
  FTH.DocUser12 := Value;
end;

//AP: 21/11/2017 ABSEXCH-19399 New GDPR field
function TTransaction.Get_thAnonymised: WordBool;
begin
  Result := FTH.thAnonymised;
end;

function TTransaction.Get_thAnonymisedDate: WideString;
begin
  Result := FTH.thAnonymisedDate;
end;

function TTransaction.Get_thAnonymisedTime: WideString;
begin
  Result := FTH.thAnonymisedTime;
end;



end.

