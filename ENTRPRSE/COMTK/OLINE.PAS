unit oLine;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarCnst3, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, MiscFunc,
     oBtrieve, ExBTTh1U, oLineSNo, oViewLns, GlobList, oLineBin, oAppView, EnterpriseBeta_TLB, oMultiBuy;

type
  TDiscountType = (dtStandard, dtMultiBuy, dtTrans);
  //AP : 20/10/2016 : ABSEXCH-12608 UpdateAccountStockAnalysis missing from .EXE COM Toolkit
  TTransactionLine = class(TBtrieveFunctions, ITransactionLine, ITransactionLine2, IRecordPosition,
                             ITransactionLine3, ITransactionLine4, IToolkitRecord,
                             IBetaTransactionLine, ITransactionLine5, ITransactionLine6, ITransactionLine7,
                             ITransactionLine8, ITransactionLine9, ITransactionLine10, ITransactionLine11)
  protected
  //PR 24/4/02 - changed these fields to protected so ITransactionDetail descendent can access them
    // Interface Type - imGeneral, imAdd, imUpdate, imClone
    FIntfType    : TInterfaceMode;

    // Parent Transaction Object (as TObject to avoid circular references)
    FTransaction : TObject;
    // Parent Transaction Lines Object (as TObject to avoid circular references)
    FTHLines     : TObject;

    // Main Toolkit Object (as TObject to avoid circular references)
    FToolkit     : TObject;

    // Unique Id Number to identify this object in the lines area
    FIdNo        : LongInt;

    // Toolkit Transaction Line
    FTL          : TBatchTLRec;

    // Line Serial No's sub-object
    FLineSnoO    : TTransLineSerialBatch;
    FLineSnoI    : ITransactionLineSerialBatch;

    //ITransactionLine2
    FLineAsNOMI  : ITransactionLineAsNOM2;
    FLineAsNOMO  : TTransactionLineAsNOM;

    FLineAsTSHI  : ITransactionLineAsTSH;
    FLineAsTSHO  : TTransactionLineAsTSH;

    FLineAsADJI  : ITransactionLineAsADJ;
    FLineAsADJO  : TTransactionLineAsADJ;

    FLineAsWORI  : ITransactionLineAsWOR;
    FLineAsWORO  : TTransactionLineAsWOR;

    FLineAsAppI  : ITransactionLineAsApplication;
    FLineAsAppO  : TTransactionLineAsApplication;

    FLineAsPayLineI  : ITransactionLineAsPayLine;
    FLineAsPayLineO  : TTransactionLineAsPayLine;

    FLineAsReturnI : ITransactionLineAsReturn;
    FLineAsReturnO : TTransactionLineAsReturn;

    // Controls restoration of original line details by .Cancel method
    FCanCancel   : Boolean;       // Availablility of .Cancel method
    FTLOrig      : TBatchTLRec;   // Original line before editing

    FRecordPosition : LongInt;
    FDetailsChanged : Boolean;
    FLineDateChanged : Boolean;

    FMultiBinI : ITransactionLineMultiBin;
    FMultiBinO : TTransLineMultiBin;

    FMultiBuyO : TMultiBuyDiscounts;
    FMultiBuyI : IMultiBuyDiscounts;

    FSaved : Boolean;

    FDetail : IDetail;
//  protected
    // ITransactionLine
    function  Get_tlLineNo: Integer; safecall;
    procedure Set_tlLineNo(Value: Integer); safecall;
    function  Get_tlGLCode: Integer; safecall;
    procedure Set_tlGLCode(Value: Integer); safecall;
    function  Get_tlCurrency: Integer; safecall;
    procedure Set_tlCurrency(Value: Integer); safecall;
    function  Get_tlCompanyRate: Double; safecall;
    procedure Set_tlCompanyRate(Value: Double); safecall;
    function  Get_tlDailyRate: Double; safecall;
    procedure Set_tlDailyRate(Value: Double); safecall;
    function  Get_tlCostCentre: WideString; safecall;
    procedure Set_tlCostCentre(const Value: WideString); safecall;
    function  Get_tlDepartment: WideString; safecall;
    procedure Set_tlDepartment(const Value: WideString); safecall;
    function  Get_tlStockCode: WideString; safecall;
    procedure Set_tlStockCode(const Value: WideString); safecall;
    function  Get_tlQty: Double; safecall;
    procedure Set_tlQty(Value: Double); safecall;
    function  Get_tlQtyMul: Double; safecall;
    procedure Set_tlQtyMul(Value: Double); safecall;
    function  Get_tlNetValue: Double; safecall;
    procedure Set_tlNetValue(Value: Double); safecall;
    function  Get_tlDiscount: Double; safecall;
    procedure Set_tlDiscount(Value: Double); safecall;
    function  Get_tlDiscFlag: WideString; safecall;
    procedure Set_tlDiscFlag(const Value: WideString); safecall;
    function  Get_tlVATCode: WideString; safecall;
    procedure Set_tlVATCode(Const Value: WideString); safecall;
    function  Get_tlVATAmount: Double; safecall;
    procedure Set_tlVATAmount(Value: Double); safecall;
    function  Get_tlPayment: WordBool; safecall;
    procedure Set_tlPayment(Value: WordBool); safecall;
    function  Get_tlQtyWOFF: Double; safecall;
    procedure Set_tlQtyWOFF(Value: Double); safecall;
    function  Get_tlQtyDel: Double; safecall;
    procedure Set_tlQtyDel(Value: Double); safecall;
    function  Get_tlCost: Double; safecall;
    procedure Set_tlCost(Value: Double); safecall;
    function  Get_tlLineDate: WideString; safecall;
    procedure Set_tlLineDate(const Value: WideString); safecall;
    function  Get_tlItemNo: WideString; safecall;
    procedure Set_tlItemNo(const Value: WideString); safecall;
    function  Get_tlDescr: WideString; safecall;
    procedure Set_tlDescr(const Value: WideString); safecall;
    function  Get_tlJobCode: WideString; safecall;
    procedure Set_tlJobCode(const Value: WideString); virtual; safecall;
    function  Get_tlAnalysisCode: WideString; safecall;
    procedure Set_tlAnalysisCode(const Value: WideString); safecall;
    function  Get_tlUnitWeight: Double; safecall;
    procedure Set_tlUnitWeight(Value: Double); safecall;
    function  Get_tlLocation: WideString; safecall;
    procedure Set_tlLocation(const Value: WideString); safecall;
    function  Get_tlChargeCurrency: Integer; safecall;
    procedure Set_tlChargeCurrency(Value: Integer); safecall;
    function  Get_tlAcCode: WideString; safecall;
    function  Get_tlLineType: TTransactionLineType; safecall;
    procedure Set_tlLineType(Value: TTransactionLineType); safecall;
    function  Get_tlFolioNum: Integer; safecall;
    function  Get_tlLineClass: WideString; safecall;
    function  Get_tlRecStatus: Smallint; safecall;
    procedure Set_tlRecStatus(Value: Smallint); safecall;
    function  Get_tlSOPFolioNum: Integer; safecall;
    procedure Set_tlSOPFolioNum(Value: Integer); safecall;
    function  Get_tlSOPABSLineNo: Integer; safecall;
    procedure Set_tlSOPABSLineNo(Value: Integer); safecall;
    function  Get_tlABSLineNo: Integer; safecall;
    function  Get_tlUserField1: WideString; safecall;
    procedure Set_tlUserField1(const Value: WideString); safecall;
    function  Get_tlUserField2: WideString; safecall;
    procedure Set_tlUserField2(const Value: WideString); safecall;
    function  Get_tlUserField3: WideString; safecall;
    procedure Set_tlUserField3(const Value: WideString); safecall;
    function  Get_tlUserField4: WideString; safecall;
    procedure Set_tlUserField4(const Value: WideString); safecall;
    function  Get_tlSSDUpliftPerc: Double; safecall;
    procedure Set_tlSSDUpliftPerc(Value: Double); safecall;
    function  Get_tlSSDCommodCode: WideString; safecall;
    procedure Set_tlSSDCommodCode(const Value: WideString); safecall;
    function  Get_tlSSDSalesUnit: Double; safecall;
    procedure Set_tlSSDSalesUnit(Value: Double); safecall;
    function  Get_tlSSDUseLineValues: WordBool; safecall;
    procedure Set_tlSSDUseLineValues(Value: WordBool); safecall;
    function  Get_tlPriceMultiplier: Double; safecall;
    procedure Set_tlPriceMultiplier(Value: Double); safecall;
    function  Get_tlQtyPicked: Double; safecall;
    procedure Set_tlQtyPicked(Value: Double); safecall;
    function  Get_tlQtyPickedWO: Double; safecall;
    procedure Set_tlQtyPickedWO(Value: Double); safecall;
    function  Get_tlSSDCountry: WideString; safecall;
    procedure Set_tlSSDCountry(const Value: WideString); safecall;
    function  Get_tlInclusiveVATCode: WideString; safecall;
    procedure Set_tlInclusiveVATCode(const Value: WideString); safecall;
    function  Get_tlBOMKitLink: Integer; safecall;
    procedure Set_tlBOMKitLink(Value: Integer); safecall;
    function  entLineTotal(ApplyDiscounts: WordBool; SettleDiscPerc: Double): Double; safecall;
    function  Get_tlOurRef: WideString; safecall;
    function  Get_tlStockCodeI: IStock; safecall;
    function  Get_tlAnalyisCodeI: IJobAnalysis; safecall;
    function  Get_tlJobCodeI: IJob; safecall;
    function  Get_tlSerialBatch: ITransactionLineSerialBatch; safecall;

    //IToolkitRecord function
    function GetData: WideString; safecall;
    function ConvertData(const DataRec: WideString): WideString; safecall;

//PR 24/4/02 - made these methods virtual so that TTransactionDetails can override them
    procedure Save; virtual; safecall;
    procedure Cancel; virtual; safecall;
    function  entDefaultVATCode(const AccountVATCode: WideString;
                                const StockVATCode: WideString): WideString; virtual; safecall;
    procedure CalcVATAmount; virtual; safecall;
    procedure CalcStockPrice; virtual; safecall;
    procedure ImportDefaults; virtual; safecall;
    procedure Check_JOB_WIP_NOM;

    Procedure InitObjects;
    procedure InitViews;

    //ITransactionLine2 methods
    function Get_tlAsNOM: ITransactionLineAsNOM; safecall;
    function Get_tlAsTSH: ITransactionLineAsTSH; safecall;
    function Get_tlAsADJ: ITransactionLineAsADJ; safecall;
    function Get_tlAsWOR: ITransactionLineAsWOR; safecall;
    function Get_tlAsPayLine: ITransactionLineAsPayLine; safecall;
    function Print(PrintAs: TTransactionLinePrintMode): IPrintJob; safecall;

    function Get_tlYear: SmallInt; safecall;
    procedure Set_tlYear(Value: SmallInt); safecall;
    function Get_tlPeriod: SmallInt; safecall;
    procedure Set_tlPeriod(Value: SmallInt); safecall;
    function Get_tlNominalMode: TNominalModeType; safecall;
    function Get_tlDocType: TDocTypes; safecall;
    function Get_tlCostApport: Double; safecall;
    procedure Set_tlCostApport(Value: Double); safecall;
    function Get_tlLineSource: Byte; safecall;

    function Get_tlCISRateCode: WideString; safecall;
    procedure Set_tlCISRateCode(const Value: WideString); safecall;
    function Get_tlCISRate: Double; safecall;
    procedure Set_tlCISRate(Value: Double); safecall;
    function ImportDefaultsForUser(const UserID: WideString) : Integer; safecall;


    //ITransactionLine3 methods
    function Get_tlMultiBin: ITransactionLineMultiBin; safecall;
    function Get_tlAltStockCodeI: IAltStockCode; safecall;
    function Get_tlRunNo: Integer; safecall;
    function Get_tlStockDeductQty: Double; safecall;
    function Get_tlUseQtyMul: WordBool; safecall;
    function Get_tlReconciliationDate: WideString; safecall;
    function Get_tlB2BLinkFolio: Integer; safecall;
    function Get_tlB2BLineNo: Integer; safecall;
    function Get_tlCOSDailyRate: Double; safecall;
    function Get_tlVATIncValue: Double; safecall;
    procedure Set_tlVATIncValue(Value: Double); safecall;
    function Get_tlBinQty: Double; safecall;

    //ITransactionLine4 methods
    function Get_tlAsReturn: ITransactionLineAsReturn; safecall;
    function CreateReturn: ITransactionLineReturnCreate; safecall;
    function Get_tlSerialReturnQty: Double; safecall;
    function Get_tlBinReturnQty: Double; safecall;

    procedure Set_tlAbsLineNo(Value : Integer); safecall;
    procedure Set_tlB2BLineNo(Value : Integer); safecall;
    procedure Set_tlB2BLinkFolio(Value : Integer); safecall;
    procedure Set_tlBinQty(Value : Double); safecall;
    procedure Set_tlCOSDailyRate(Value : Double); safecall;
    procedure Set_tlNominalMode(Value : Integer); safecall;
    procedure Set_tlQtyPack(Value : Double); safecall;
    procedure Set_tlReconciliationDate(const Value : WideString); safecall;
    procedure Set_tlStockDeductQty(Value : Double); safecall;
    procedure Set_tlUseQtyMul(Value : WordBool); safecall;

    //PR: 13/03/2009 ITransactionLine5 methods
    function Get_tlMultiBuyDiscounts: IMultiBuyDiscounts; safecall;
    function Get_tlMultiBuyDiscount: Double; safecall;
    procedure Set_tlMultiBuyDiscount(Value: Double); safecall;
    function Get_tlMultiBuyDiscountFlag: WideString; safecall;
    procedure Set_tlMultiBuyDiscountFlag(const Value: WideString); safecall;
    function Get_tlTransValueDiscount: Double; safecall;
    procedure Set_tlTransValueDiscount(Value: Double); safecall;
    function Get_tlTransValueDiscountFlag: WideString; safecall;
    procedure Set_tlTransValueDiscountFlag(const Value: WideString); safecall;
    function Get_tlTransValueDiscountType: TTransValueDiscountType; safecall;
    procedure Set_tlTransValueDiscountType(Value: TTransValueDiscountType); safecall;
    function Get_tlTotals(Index: TTransLineTotalsType): Double; safecall;

    //PR: 09/09/2009 ITransactionLine6 methods
    function Get_tlECService: WordBool; safecall;
    procedure Set_tlECService(Value: WordBool); safecall;
    function Get_tlECServiceStartDate: WideString; safecall;
    procedure Set_tlECServiceStartDate(const Value: WideString); safecall;
    function Get_tlECServiceEndDate: WideString; safecall;
    procedure Set_tlECServiceEndDate(const Value: WideString); safecall;
    function Get_tlECSalesTaxReported: Double; safecall;
    function Get_tlECPurchaseServiceTax: Double; safecall;
    procedure UpdateAccountStockAnalysis; safecall;
    //ITransactionLine6 methods
    //PR: 06/10/2009 LinkToSOR got lost between 6SQL and 6.01 - Need to add it as part of ITransactionLine6
    procedure LinkToSOR(const SORLine: ITransactionLine); safecall;

    procedure ExplodeBOM; safecall;
    procedure AddDescriptionLines; safecall;

    function Get_tlQtyPack: Double; safecall;
    function Get_tlAsApplication: ITransactionLineAsApplication; safecall;

    function UpdateUplift(NewAmount : Double): Integer; safecall;

    //PR: 04/02/2010 ITransactionLine7 methods
    function Get_tlReference: WideString; safecall;
    procedure Set_tlReference(const Value: WideString); safecall;
    function Get_tlReceiptNo: WideString; safecall;
    procedure Set_tlReceiptNo(const Value: WideString); safecall;
    function Get_tlFromPostCode: WideString; safecall;
    procedure Set_tlFromPostCode(const Value: WideString); safecall;
    function Get_tlToPostCode: WideString; safecall;
    procedure Set_tlToPostCode(const Value: WideString); safecall;

    //PR: 26/10/2011 v6.9 ITransactionLine8 methods
    function Get_tlUserField5: WideString; safecall;
    procedure Set_tlUserField5(const Value: WideString); safecall;
    function Get_tlUserField6: WideString; safecall;
    procedure Set_tlUserField6(const Value: WideString); safecall;
    function Get_tlUserField7: WideString; safecall;
    procedure Set_tlUserField7(const Value: WideString); safecall;
    function Get_tlUserField8: WideString; safecall;
    procedure Set_tlUserField8(const Value: WideString); safecall;
    function Get_tlUserField9: WideString; safecall;
    procedure Set_tlUserField9(const Value: WideString); safecall;
    function Get_tlUserField10: WideString; safecall;
    procedure Set_tlUserField10(const Value: WideString); safecall;

    // MH 01/03/2012 v6.10 ABSEXCH-12596 - ITransactionLine9 Methods
    function Get_tlThresholdCode: WideString; safecall;
    procedure Set_tlThresholdCode(const Value: WideString); safecall;

    //PR: 20/01/2016 ABSEXCH-17112 v2016 R1 ITransactionLine10 Added Nature of Transaction Code
    function Get_tlIntrastatNoTC: WideString; safecall;
    procedure Set_tlIntrastatNoTC(const Value: WideString); safecall;

    //PR: 13/02/2016 ABSEXCH-ABSEXCH-18191 v2017 R1 ITransaction11
    function UpdateReconcileFlag(NewValue: TReconcileFlagValue): Integer; safecall;
    function GetRecordAddress : Integer; virtual;


    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; override;
    procedure DoImportDefaults(const UserO : IUserProfile = nil); virtual;
    function CheckUser(const UserID : string; var Res : Integer) : IUserProfile;
    function SetPriority(Rule : TPriorityRuleType;
                     const st : string;
                     const ac : string;
                     const op : string) : string;

    // IRecordPosition Methods
    function Get_RecordPosition: Integer; virtual; safecall;

    procedure SetMultiBuyDiscounts;
    function CalcDiscountTotal(WhichDiscount : TDiscountType) : Double;
  public
    Constructor Create(Const IdNo        : LongInt;
                       Const IType       : TInterfaceMode;
                       Const Toolkit     : TObject;
                       Const ParentTrans : TObject;
                       Const ParentLines : TObject;
                       Const BtrIntf     : TCtkTdPostExLocalPtr;
                       Const TL          : TBatchTLRec;
                       Const CanCancel   : Boolean;
                       Const RecPos      : LongInt);
    Destructor Destroy; override;

    Procedure InitNewLine;
    Procedure Transform(Const IType : TInterfaceMode);
    procedure SetInvalidTimeRates(Value : Boolean);
    procedure SetAbsLineNo(var Value : longint);
    function OkToUpdate(CanUpdate : Boolean = False) : Boolean;
    function GetTimeRate(var RateR : EmplPayType; const EmpCode : string) : Boolean;
    Property IdNo : LongInt Read FIdNo;
    Property TL : TBatchTLRec Read FTL Write FTL;
    property DetailsChanged : Boolean Read FDetailsChanged;
    property LineDateChanged : Boolean Read FLineDateChanged;
    property ParentTrans : TObject read FTransaction; //Parent transaction (TTransaction) as TObject
    property LineDetail : IDetail read FDetail write FDetail;
  End; { TTransactionLine }

  TTransactionLine2 = Class(TTransactionLine)
  protected
    procedure DoImportDefaults(const UserO : IUserProfile = nil); override;
    procedure ImportDefaults; override; safecall;
    procedure CalcVATAmount; override; safecall;
    function ValidJobCode(const JCode : string) : Boolean;
    procedure Set_tlJobCode(const Value: WideString); override; safecall;
  end;


implementation

uses ComServ, ETStrU, BTKeys1U, DLLTH_UP, DllErrU, DllSK01U, oTrans, oLines,
     oToolkit, SysU2, InvLst2U, BTSupU1, VarRec2U, CurrncyU, ComnUnit, ETMiscU,
     ComnU2, MultiBuyFuncs,
{$If Defined(COMPRNT)}
     EnterpriseForms_TLB,    // Type Library for Form Printing Toolkit
     oPrntJob,               // COM Toolkit Print Job Object
{$IfEnd}
     // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
     MadExcept,
     LogFile, Uplift, BtrvU2, oReturns, Profile, SQLUtils,
     LogUtil;

const
  UpdateEx2Msg = 'This field cannot be updated in this transaction and line';

  {$I EXDLLBT.INC}

{-------------------------------------------------------------------------------------------------}

Constructor TTransactionLine.Create(Const IdNo        : LongInt;
                                    Const IType       : TInterfaceMode;
                                    Const Toolkit     : TObject;
                                    Const ParentTrans : TObject;
                                    Const ParentLines : TObject;
                                    Const BtrIntf     : TCtkTdPostExLocalPtr;
                                    Const TL          : TBatchTLRec;
                                    Const CanCancel   : Boolean;
                                    Const RecPos      : LongInt);
Begin { Create }
//  LogF.AddLogMessage ('ITransactionLine', 'Create (Start)');

  //Inherited Create (ComServer.TypeLib, ITransactionLines);
  //if we don't have a parent transaction then we're creating a TransactionDetails interface
  if Assigned(ParentTrans) then
    //AP : 20/10/2016 : ABSEXCH-12608 UpdateAccountStockAnalysis missing from .EXE COM Toolkit
    Inherited Create (ComServer.TypeLib, ITransactionLine11, BtrIntf)
  else
    //PL: 21/10/2016 ABSEXCH-11258 The position property was not set in the
    //Itransactiondetails object. added save position to save position property.
    Inherited Create (ComServer.TypeLib, ITransactionDetails3, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := IDetailF;

  // Initialise variables
  InitObjects;

  FIdNo := IdNo;

  FIntfType := IType;

  FCanCancel := CanCancel;

  FToolkit := Toolkit;
  FBtrIntf := BtrIntf;

  FTransaction := ParentTrans;
  FTHLines := ParentLines;


  FillChar (FTL, SizeOf(FTL), #0);
  FTL := TL;

  //PR: 22/02/2012 Save record address in record for passing into UpdateEx functions. ABSEXCH-12017
  FTL.RecordAddress := RecPos;
  FillChar (FTLOrig, SizeOf(FTLOrig), #0);
  FTLOrig := FTL;

  FRecordPosition := RecPos;
  FDetailsChanged := False;
  FLineDateChanged := False;

  FSaved := IType <> imAdd;

//  LogF.AddLogMessage ('ITransactionLine', 'Create (Finish)');
  FObjectID := tkoDetail;
End; { Create }

{-----------------------------------------}

Destructor TTransactionLine.Destroy;
Begin { Destroy }
  { Destroy sub-objects }
  InitObjects;

  inherited Destroy;

//  LogF.AddLogMessage ('ITransactionLine', 'Destroy');
End; { Destroy }

{-----------------------------------------}

Procedure TTransactionLine.InitObjects;
Begin { InitObjects }
  // Reference to parent TTransaction object (as TObject to avoid circular references) }
  FTransaction := Nil;

  // Reference to parent TTransaction Lines object (as TObject to avoid circular references) }
  FTHLines := Nil;

  // Reference to main Toolkit object
  FToolkit := Nil;

  // Line Serial No's sub-object
  FLineSnoO := Nil;
  FLineSnoI := Nil;

  FMultiBinO := nil;
  FMultiBinI := nil;

  FMultiBuyI := nil;
  FMultiBuyO := nil;

  // Transaction Btrieve object
  FBtrIntf := NIL;

  InitViews;
End; { InitObjects }

{-----------------------------------------}

Procedure TTransactionLine.InitNewLine;
Var
  oAccount : IAccount;
  IdDocHed : DocTypes;
Begin { InitNewLine }
  With (FTransaction As TTransaction), FTL Do Begin
    // Line Number set in thLines before object creation

    // Currency
    Currency := TH.Currency;

    // Quantity
    QtyMul := 1.0;
    Qty := 1.0;

    // Job Code & Analysis Code
    JobCode := TH.DJobCode;
    AnalCode := TH.DJobAnal;

    // Line Date - default to Transaction Date
    IdDocHed := TKDocTypeToEntDocType (TH.TransDocHed);
    FTL.DocHed := DocCodes[IdDocHed];
    FTL.TransRefNo := FTL.DocHed;

    If (IdDocHed In OrderSet) or ((Syss.QUAllocFlg) and (IdDocHed In QuotesSet)) then
      LineDate := TH.DueDate
    else
      LineDate := TH.TransDate;

    // Filter out non-account based transactions
    If (Not (IdDocHed In [ADJ, NMT, TSH])) Then Begin
      // Get Customer object if possible
      oAccount := ((FTransaction As TTransaction) As ITransaction).thAcCodeI;

      If Assigned(oAccount) Then Begin
        // GL Code - Default to customer default
        NomCode := oAccount.acSalesGL;

        // Default VAT Codes to customer
        VATCode := ExtractChar (oAccount.acVATCode, 'S');
        VATIncFlg := ExtractChar (oAccount.acInclusiveVATCode, 'S');

        // Default Location Code to Customer Default
        MLocStk := oAccount.acLocation;

        // Cost Centre & Department
        CC  := oAccount.acCostCentre;
        Dep := oAccount.acDepartment;
      End; { If Assigned(oAccount) }

      // Release interface
      oAccount := NIL;
    End { If (Not (IdDocHed In [ADJ, NOM, TSH])) }
    Else Begin
      // ADJ, NOM, TSH - Toolkit needs a valid VAT Code to validate the line
      if not (IdDocHed in [NMT]) then
        VATCode := 'Z';
    End; { Else }

    //PR 13/04/06 - on SRCs & PPYs set payment flag
    if IdDocHed in RecieptSet then
      Payment := True;

    If (IdDocHed = ADJ) Then Begin
      // ADJ Specific initialisation
      If Syss.AutoClearPay Then
        Reconcile := ReconC;

    End; { If (IdDocHed = ADJ) }
  End; { With FTL }
  FSaved := False;
  FTLOrig := FTL;
End; { InitNewLine }

{-----------------------------------------}

function TTransactionLine.Get_tlLineNo: Integer;
begin
  Result := FTL.LineNo;
end;

procedure TTransactionLine.Set_tlLineNo(Value: Integer);
begin
  if OkToUpdate(True) then
    FTL.LineNo := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlABSLineNo: Integer;
begin
  Result := FTL.ABSLineNo;
end;

{-----------------------------------------}

function TTransactionLine.Get_tlAcCode: WideString;
begin
  Result := FTL.CustCode;
end;

{-----------------------------------------}

function TTransactionLine.Get_tlAnalysisCode: WideString;
begin
  Result := FTL.AnalCode;
end;

procedure TTransactionLine.Set_tlAnalysisCode(const Value: WideString);
begin
  if OkToUpdate then
//    FTL.AnalCode := FullJACode(UpperCase(Value))
    //PR: 01/11/2011 v6.9 If Job Code is blank, then analysis code can be free text, so
    //don't upper case it here - if necessary it is upper-cased and padded in DllTh_Up.pas when saving.
    FTL.AnalCode := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlBOMKitLink: Integer;
begin
  Result := FTL.KitLink
end;

procedure TTransactionLine.Set_tlBOMKitLink(Value: Integer);
begin
  if OkToUpdate(True) then
    FTL.KitLink := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlChargeCurrency: Integer;
begin
  Result := FTL.TSHCCurr;
end;

procedure TTransactionLine.Set_tlChargeCurrency(Value: Integer);
begin
  if OkToUpdate then
    FTL.TSHCCurr := ValidateCurrencyNo (Value)
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlCompanyRate: Double;
begin
  Result := FTL.CoRate;
end;

procedure TTransactionLine.Set_tlCompanyRate(Value: Double);
begin
  if OkToUpdate then
    FTL.CoRate := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlCost: Double;
begin
  Result := FTL.CostPrice;
end;

procedure TTransactionLine.Set_tlCost(Value: Double);
begin
  if OkToUpdate then
    FTL.CostPrice := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlCostCentre: WideString;
begin
  Result := FTL.CC;
end;

procedure TTransactionLine.Set_tlCostCentre(const Value: WideString);
begin
  if OkToUpdate(True) then
    FTL.CC := FullCCDepKey(UpperCase(Value))
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlCurrency: Integer;
begin
  Result := FTL.Currency;
end;

procedure TTransactionLine.Set_tlCurrency(Value: Integer);
begin
  if OkToUpdate then
    FTL.Currency := ValidateCurrencyNo(Value)
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlDailyRate: Double;
begin
  Result := FTL.VATRate;
end;

procedure TTransactionLine.Set_tlDailyRate(Value: Double);
begin
  if OkToUpdate then
    FTL.VATRate := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlDepartment: WideString;
begin
  Result := FTL.Dep;
end;

procedure TTransactionLine.Set_tlDepartment(const Value: WideString);
begin
  if OkToUpdate(True) then
    FTL.Dep := FullCCDepKey(UpperCase(Value))
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlDescr: WideString;
begin
  Result := FTL.Desc;
end;

procedure TTransactionLine.Set_tlDescr(const Value: WideString);
begin
  if OkToUpdate(True) then
    FTL.Desc := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlDiscFlag: WideString;
begin
  Result := FTL.DiscountChr;
end;

procedure TTransactionLine.Set_tlDiscFlag(const Value: WideString);
begin
  if OkToUpdate then
    FTL.DiscountChr := ExtractChar(Value, ' ')
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlDiscount: Double;
begin
  Result := FTL.Discount;
end;

procedure TTransactionLine.Set_tlDiscount(Value: Double);
begin
  if OkToUpdate then
    FTL.Discount := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlFolioNum: Integer;
begin
  Result := FTL.FolioNum;
end;

{-----------------------------------------}

function TTransactionLine.Get_tlGLCode: Integer;
begin
  Result := FTL.NomCode;
end;

procedure TTransactionLine.Set_tlGLCode(Value: Integer);
begin
  if OkToUpdate then
    FTL.NomCode := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlInclusiveVATCode: WideString;
begin
  Result := FTL.VATIncFlg;
end;

procedure TTransactionLine.Set_tlInclusiveVATCode(const Value: WideString);
begin
  if OkToUpdate then
    FTL.VATIncFlg := ExtractChar(Value, ' ')
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlItemNo: WideString;
begin
  Result := FTL.Item;
end;

procedure TTransactionLine.Set_tlItemNo(const Value: WideString);
begin
  if OkToUpdate(True) then
    FTL.Item := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlJobCode: WideString;
begin
  Result := FTL.JobCode;
end;

procedure TTransactionLine.Set_tlJobCode(const Value: WideString);
begin
  if OkToUpdate then
    FTL.JobCode := FullJobCode(UpperCase(Value))
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlLineClass: WideString;
begin
  Result := FTL.LineType;
end;

{-----------------------------------------}

function TTransactionLine.Get_tlLineDate: WideString;
begin
  Result := FTL.LineDate;
end;

procedure TTransactionLine.Set_tlLineDate(const Value: WideString);
begin
  if OkToUpdate then
  begin
    FTL.LineDate := Value;
    FLineDateChanged := True;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlLineType: TTransactionLineType;
begin
  Case FTL.DocLTLink of
    0 : Result := tlTypeNormal;
    1 : Result := tlTypeLabour;
    2 : Result := tlTypeMaterials;
    3 : Result := tlTypeFreight;
    4 : Result := tlTypeDiscount;
    5   :  Result := tlTypeMaterials1;
    6   :  Result := tlTypeMaterials2;
    7   :  Result := tlTypeLabour1;
    8   :  Result := tlTypeLabour2;
    9   :  Result := tlTypeRetentions1;
    10  :  Result := tlTypeRetentions2;
    11  :  Result := tlTypeDeductions1;
    12  :  Result := tlTypeDeductions2;
    13  :  Result := tlTypeDeductions3;
    14  :  Result := tlTypeCITB;
    15  :  Result := tlTypeCIS;
    16  :  Result := tlTypeMisc1;
    17  :  Result := tlTypeMisc2;
  Else
    Raise EUnknownValue.Create ('Invalid Line Type ' + QuotedStr(IntToStr(FTL.DocLTLink)));
  End; { Case }
end;

procedure TTransactionLine.Set_tlLineType(Value: TTransactionLineType);
begin
  if OkToUpdate(True) then
    Case Value of
      tlTypeNormal     :  FTL.DocLTLink := 0;
      tlTypeLabour     :  FTL.DocLTLink := 1;
      tlTypeMaterials  :  FTL.DocLTLink := 2;
      tlTypeFreight    :  FTL.DocLTLink := 3;
      tlTypeDiscount   :  FTL.DocLTLink := 4;
      tlTypeMaterials1 :  FTL.DocLTLink := 5;
      tlTypeMaterials2 :  FTL.DocLTLink := 6;
      tlTypeLabour1    :  FTL.DocLTLink := 7;
      tlTypeLabour2    :  FTL.DocLTLink := 8;
      tlTypeRetentions1:  FTL.DocLTLink := 9;
      tlTypeRetentions2:  FTL.DocLTLink := 10;
      tlTypeDeductions1:  FTL.DocLTLink := 11;
      tlTypeDeductions2:  FTL.DocLTLink := 12;
      tlTypeDeductions3:  FTL.DocLTLink := 13;
      tlTypeCITB           :  FTL.DocLTLink := 14;
      tlTypeCIS            :  FTL.DocLTLink := 15;
      tlTypeMisc1          :  FTL.DocLTLink := 16;
      tlTypeMisc2          :  FTL.DocLTLink := 17;
    Else
      Raise EUnknownValue.Create ('Invalid LineType ' + IntToStr(Ord(Value)));
    End { Case }
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlLocation: WideString;
begin
  Result := FTL.MLocStk;
end;

procedure TTransactionLine.Set_tlLocation(const Value: WideString);
begin
  if OkToUpdate then
    FTL.MLocStk := LJVar(Value,MLocKeyLen)
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlNetValue: Double;
begin
  Result := FTL.NetValue;
end;

procedure TTransactionLine.Set_tlNetValue(Value: Double);
begin
  if OkToUpdate then
    FTL.NetValue := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlPayment: WordBool;
begin
  Result := FTL.Payment;
end;

procedure TTransactionLine.Set_tlPayment(Value: WordBool);
begin
  if OkToUpdate then
    FTL.Payment := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlPriceMultiplier: Double;
begin
  Result := FTL.PriceMulx;
end;

procedure TTransactionLine.Set_tlPriceMultiplier(Value: Double);
begin
  if OkToUpdate then
    FTL.PriceMulx := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlQty: Double;
begin
  Result := Round_Up(FTL.Qty, Syss.NoQtyDec);
end;

procedure TTransactionLine.Set_tlQty(Value: Double);
begin
  if OkToUpdate then
    FTL.Qty := Round_Up(Value, Syss.NoQtyDec)
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlQtyDel: Double;
begin
  Result := Round_Up(FTL.QtyDel, Syss.NoQtyDec);
end;

procedure TTransactionLine.Set_tlQtyDel(Value: Double);
begin
  if OkToUpdate then
    FTL.QtyDel := Round_Up(Value, Syss.NoQtyDec)
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlQtyMul: Double;
begin
  Result := Round_Up(FTL.QtyMul, Syss.NoQtyDec);
end;

procedure TTransactionLine.Set_tlQtyMul(Value: Double);
begin
  if OkToUpdate then
    FTL.QtyMul := Round_Up(Value, Syss.NoQtyDec)
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlQtyPicked: Double;
begin
  Result := Round_Up(FTL.QtyPick, Syss.NoQtyDec);
end;

procedure TTransactionLine.Set_tlQtyPicked(Value: Double);
begin
  if OkToUpdate then
    FTL.QtyPick := Round_Up(Value, Syss.NoQtyDec)
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlQtyPickedWO: Double;
begin
  Result := Round_Up(FTL.QtyPWOff, Syss.NoQtyDec);
end;

procedure TTransactionLine.Set_tlQtyPickedWO(Value: Double);
begin
  if OkToUpdate then
    FTL.QtyPWOff := Round_Up(Value, Syss.NoQtyDec)
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlQtyWOFF: Double;
begin
  Result := Round_Up(FTL.QtyWOff, Syss.NoQtyDec);
end;

procedure TTransactionLine.Set_tlQtyWOFF(Value: Double);
begin
  if OkToUpdate then
    FTL.QtyWOff := Round_Up(Value, Syss.NoQtyDec)
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlRecStatus: Smallint;
begin
  Result := FTL.Reconcile;
end;

procedure TTransactionLine.Set_tlRecStatus(Value: Smallint);
begin
  if OkToUpdate then
    FTL.Reconcile := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlSOPABSLineNo: Integer;
begin
  Result := FTL.SOPLineNo;
end;

procedure TTransactionLine.Set_tlSOPABSLineNo(Value: Integer);
begin
  if OkToUpdate then
    FTL.SOPLineNo := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlSOPFolioNum: Integer;
begin
  Result := FTL.SOPLink;
end;

procedure TTransactionLine.Set_tlSOPFolioNum(Value: Integer);
begin
  if OkToUpdate then
    FTL.SOPLink := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlSSDCommodCode: WideString;
begin
  Result := FTL.SSDCommod;
end;

procedure TTransactionLine.Set_tlSSDCommodCode(const Value: WideString);
begin
  if OkToUpdate then
    FTL.SSDCommod := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlSSDCountry: WideString;
begin
  Result := FTL.SSDCountry;
end;

procedure TTransactionLine.Set_tlSSDCountry(const Value: WideString);
begin
  if OkToUpdate then
    FTL.SSDCountry := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlSSDSalesUnit: Double;
begin
  Result := FTL.SSDSPUnit;
end;

procedure TTransactionLine.Set_tlSSDSalesUnit(Value: Double);
begin
  if OkToUpdate then
    FTL.SSDSPUnit := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlSSDUpliftPerc: Double;
begin
  Result := FTL.SSDUplift;
end;

procedure TTransactionLine.Set_tlSSDUpliftPerc(Value: Double);
begin
  if OkToUpdate then
    FTL.SSDUplift := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlSSDUseLineValues: WordBool;
begin
  Result := FTL.SSDUseLine;
end;

procedure TTransactionLine.Set_tlSSDUseLineValues(Value: WordBool);
begin
  if OkToUpdate then
    FTL.SSDUseLine := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlStockCode: WideString;
begin
  Result := FTL.StockCode;
end;

procedure TTransactionLine.Set_tlStockCode(const Value: WideString);
begin
  if OkToUpdate then
  begin
    with  FTransaction as TTransaction do
    begin
      if TH.TransDocHed = 'NOM' then
        FTL.StockCode := Value
      else
        FTL.StockCode := FullStockCode(Value);
    end
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlUnitWeight: Double;
begin
  Result := FTL.LWeight;
end;

procedure TTransactionLine.Set_tlUnitWeight(Value: Double);
begin
  if OkToUpdate then
    FTL.LWeight := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlUserField1: WideString;
begin
  Result := FTL.LineUser1;
end;

procedure TTransactionLine.Set_tlUserField1(const Value: WideString);
begin
  if OkToUpdate(True) then
  begin
    FTL.LineUser1 := Value;
    FDetailsChanged := True;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlUserField2: WideString;
begin
  Result := FTL.LineUser2;
end;

procedure TTransactionLine.Set_tlUserField2(const Value: WideString);
begin
  if OkToUpdate(True) then
  begin
    FTL.LineUser2 := Value;
    FDetailsChanged := True;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlUserField3: WideString;
begin
  Result := FTL.LineUser3;
end;

procedure TTransactionLine.Set_tlUserField3(const Value: WideString);
begin
  if OkToUpdate(True) then
  begin
    FTL.LineUser3 := Value;
    FDetailsChanged := True;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlUserField4: WideString;
begin
  Result := FTL.LineUser4;
end;

procedure TTransactionLine.Set_tlUserField4(const Value: WideString);
begin
  if OkToUpdate(True) then
  begin
    FTL.LineUser4 := Value;
    FDetailsChanged := True;
  end;
end;

{-----------------------------------------}

function TTransactionLine.Get_tlVATAmount: Double;
begin
  Result := FTL.VAT;
end;

procedure TTransactionLine.Set_tlVATAmount(Value: Double);
begin
  if OkToUpdate then
    FTL.VAT := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlVATCode: WideString;
begin
  Result := FTL.VATCode;
end;

procedure TTransactionLine.Set_tlVATCode(Const Value: WideString);
begin
  if OkToUpdate then
    FTL.VATCode := ExtractChar(Value, ' ')
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

{-----------------------------------------}

// Returns the calculated line total for the current line
function TTransactionLine.entLineTotal(ApplyDiscounts: WordBool; SettleDiscPerc: Double): Double;
var
  Total : Double;
  Res : SmallInt;
begin
  Res := EX_GETLINETOTAL(@FTL, SizeOf(FTL), ApplyDiscounts, SettleDiscPerc, Total);
  If (Res = 0) Then
    Result := Total
  Else
    // Bugger
    Raise Exception.Create ('entLineTotal Error ' + IntToStr(Res) + ' ' + QuotedStr(Ex_ErrorDescription (127, Res)));
end;

{-----------------------------------------}

function TTransactionLine.Get_tlOurRef: WideString;
begin
  Result := FTL.TransRefNo;
end;

{-----------------------------------------}

// Save method to add new lines into thLines list
Procedure TTransactionLine.Save;
Begin { Save }
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    If (FIntfType = imAdd) Then
      With FTHLines As TTransactionLines Do
      begin
        SetMultiBuyDiscounts;
        AddNewLine (Self);
        FSaved := True;
      end
    Else
      Raise EInvalidMethod.Create ('The ITransactionLine.Save method is not available');
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
End; { Save }

{-----------------------------------------}

// Changes the mode of an interface
Procedure TTransactionLine.Transform(Const IType : TInterfaceMode);
Begin { Transform }
  FIntfType := IType;
  FTLOrig := FTL;

End; { Transform }

procedure TTransactionLine.SetInvalidTimeRates(Value : Boolean);
begin
  FTL.InvalidTSHRates := Value;
end;
{-----------------------------------------}

// Cancels changes made during editing
Procedure TTransactionLine.Cancel;
Begin { Cancel }
  If FCanCancel Then
    FTL := FTLOrig
  Else
    Raise EInvalidMethod.Create ('The ITransactionLine.Cancel method is not available');
End; { Cancel }

{-----------------------------------------}

// Returns the Default VAT Code
function TTransactionLine.entDefaultVATCode(const AccountVATCode: WideString; const StockVATCode: WideString): WideString;
Var
  VATRec : TVATCodeDefaultType;
  Res    : SmallInt;
begin { entDefaultVATCode }
  FillChar (VATRec, SizeOf(VATRec), #0);
  VATRec.StockVATCode   := ExtractChar (StockVATCode, #255);
  VATRec.AccountVATCode := ExtractChar (AccountVATCode, #255);

  Res := Ex_GetCorrectVatCode(@VATRec, SizeOf(VATRec));
  If (Res = 0) Then
    Result := VATRec.DefaultVATCode
  Else
    Raise Exception.Create ('ITransactionLine.entDefaultVATCode Error ' + IntToStr(Res));
end; { entDefaultVATCode }

{-----------------------------------------}

// Calculate the VAT for the transaction line
procedure TTransactionLine.CalcVATAmount;
Var
  Res  : SmallInt;
Begin { CalcVATAmount }
  if OkToUpdate then
  begin
    Res := Ex_CalcLineTax(@FTL, SizeOf(FTL), (FTransaction As TTransaction).TH.DiscSetl);
    If (Res <> 0) Then
      Raise Exception.Create ('ITransactionLine.CalcVATAmount Error ' + IntToStr(Res));
  end
  else
    Raise EInvalidMethod.Create ('The ITransactionLine.CalcVatAmount method is not available');
End; { CalcVATAmount }

{-----------------------------------------}

// Calculates the Stock Price for the current line details
procedure TTransactionLine.CalcStockPrice;
Var
  ExStkPrRec : TBatchStkPriceRec;
  Res        : SmallInt;
begin { CalcStockPrice }
  if OkToUpdate then
  begin
    FillChar (ExStkPrRec, SizeOf(ExStkPrRec), #0);
    With ExStkPrRec Do Begin
      StockCode := FTL.StockCode;
      LocCode   := FTL.MLocStk;
      CustCode  := (FTransaction As TTransaction).TH.CustCode;
      Currency  := FTL.Currency;
      Qty       := FTL.Qty;
      PriceDate := (FTransaction As TTransaction).TH.TransDate;
    End; { With ExStkPrRec }

    Res := Ex_CalcStockPrice(@ExStkPrRec, SizeOf(ExStkPrRec));
    If (Res = 0) Then Begin
      FTL.NetValue := ExStkPrRec.Price;
      FTL.DiscountChr := ExStkPrRec.DiscChar;

      // HM 10/04/01: Modified as 5% discount coming through as 500%
      If (FTL.DiscountChr = '%') Then
        FTL.Discount := Round_Up(ExStkPrRec.DiscVal / 100, 4)
      Else
        FTL.Discount := ExStkPrRec.DiscVal
    End { If (Res = 0)  }
    Else
      // Bugger
      Raise Exception.Create ('ITransactionLine.CalcStockPrice Error ' + IntToStr(Res) + ' ' + QuotedStr(Ex_ErrorDescription (80, Res)));
  end
  else
    Raise EInvalidMethod.Create ('The ITransactionLine.CalcStockPrice method is not available');
end; { CalcStockPrice }

{-----------------------------------------}

function TTransactionLine.Get_tlStockCodeI: IStock;
begin
  With FToolkit As TToolkit Do
    Result := StockO.GetCloneInterface(FTL.StockCode);
end;

function TTransactionLine.Get_tlAltStockCodeI: IAltStockCode;
var
  oStock : IStock;
begin
  With FToolkit As TToolkit Do
  begin
    oStock := Get_tlStockCodeI;
    if Assigned(oStock) then
      Result := StockO.AltStock.GetCloneInterface(FTL.tlAltStockFolio, oStock.stFolioNum)
    else
      Result := nil;
  end;
end;

{-----------------------------------------}

// Import defaults from Customer, Stock, Location, StkLoc, etc...
procedure TTransactionLine.ImportDefaults;
begin
  if OkToUpdate then
    DoImportDefaults
  else
    Raise EInvalidMethod.Create ('The ITransactionLine.ImportDefaults method is not available');
end;

function TTransactionLine.GetTimeRate(var RateR : EmplPayType; const EmpCode : string) : Boolean;
var
  JCode    : Str10;
  siPos    : TBtrieveFileSavePos;
  GotEmp   : Boolean;
  UseORate : Byte;

    Function FindJPRLevel(JCode     :  Str10;
                     Var  UseJCode  :  Str10)  :  Boolean;


    Const
      Fnum     =  JCtrlF;
      Keypath  =  JCK;
      Fnum2    =  JobF;
      Keypath2 =  JobCatK;

    Var
      TmpStat,
      TmpKPath   : Integer;
      TmpRecAddr : LongInt;

      KeyChk,
      KeyS       : Str255;

      LOk        : Boolean;

      TmpJRec    : JobRecType;


    Begin
      Result:=BOff;  LOk:=BOff;

      KeyS:=''; KeyChk:='';    UseJCode:=JCode;

      With FBtrIntf^ do
      Begin
        TmpJRec:=LJobRec^;

        TmpKPath:=GetPosKey;

        TmpStat:=LPresrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOff,BOff);

        If (LGetMainRecPos(JobF,JCode)) then
        Begin
          KeyChk:=JBRCode+JBSubAry[3]+LJVar(JCode,EmplKeyLen);
          KeyS:=KeyChk;

          Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);

          Result:=(StatusOk and (CheckKey(KeyS,KeyChk,Length(KeyChk),BOff)));

          If (Result) then
           UseJCode:=JCode
          else
            If (Not Emptykey(LJobRec^.JobCat,JobKeyLen)) and (LJobRec^.JobCat<>JCode) then
              Result:=FindJPRLevel(LJobRec^.JobCat,UseJCode);


        end;

        TmpStat:=LPresrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOn,BOn);

        LJobRec^:=TmpJRec;
      end; {With..}
    end; {Func..}

    //PR: 09/11/2009 All attempts to get a Time Rate were including the currency as part of the key. However,
    //it should be possible to use different currencies. Changed to allow any currency.
    //P$: 17/05/2010 Employee Rate requires a different subtype from  Global/Job ('R' rather then 'E')
    function GetRate(const ACode : string; SubType : Char = JBECode) : Boolean;
    var
      KeyS, KeyChk : Str255;
      Res : Integer;
    begin
      With FBtrIntf^ do
      begin   //PR: 28/01/2010 This was searching the currency byte - needs to be StkKeyLen - 1
        KeyS := PartCCKey(JBRCode, SubType) + FullJACode(ACode) + LJVar(FTL.StockCode,StkKeyLen - 1);
        KeyChk := KeyS;
        Res := LFind_Rec(B_GetGEq, JCtrlF, 0, KeyS);

        //PR: 20/11/2009 Changed to stop it reading through all records
        //PR: 28/01/2010 Changed to not check the currency byte
        Result := (Res = 0) and CheckKey(KeyS, KeyChk, Length(KeyChk) - 1, True);

      end;
    end;


    function GetJobRate : Boolean;
    begin
      Result := GetRate(JCode);
    end;

    function GetEmpRate : Boolean;
    begin
      //PR: 17/05/2010 Need to pass in correct subtype to GetRate function
      Result := GetRate(EmpCode, 'R');
    end;

    function GetGlobalRate : Boolean;
    begin
      Result := GetRate(FullNomKey(-1));
    end;


begin
  Result := False;
  with FBtrIntf^ do
  begin

    If (Trim(EmpCode) <> '') Then
    begin
      // Get Employee Record
      SaveExLocalPosFile (JMiscF, siPos);
      GotEmp := LGetMainRec(JMiscF, PartCCKey(JARCode, JAECode) + LJVar(EmpCode,6));
      RestoreExLocalPos (siPos);

      if GotEmp then
      begin
        UseORate := LJobMisc^.EmplRec.UseORate;


        SaveExLocalPosFile (JCtrlF, siPos);

        //Find the appropriate Job Code
        if Trim(FTL.JobCode) <> '' then
          FindJPRLevel(FTL.JobCode, JCode);

        Case UseORate of
          0  :  begin
                  Result := GetEmpRate;
                  if not Result then
                    Result := GetJobRate;
                end;
          1  :  Result := GetEmpRate;
          2  :  begin
                  Result := GetJobRate;
                  if not Result then
                    Result := GetEmpRate;
                end;
          3  :  Result := GetJobRate;
          else
            Result := False;
        end; //case


        If Result Then
          RateR := LJobCtrl^.EmplPay
        Else if (UseORate in [0, 2]) then
        Begin
          // If not found try the Global time rates
          Result := GetGlobalRate;
          If Result Then
            RateR := LJobCtrl^.EmplPay;
        End; { Else }

        RestoreExLocalPos (siPos);
      end;
    end;
  end;
end;


procedure TTransactionLine.DoImportDefaults(const UserO : IUserProfile = nil);
Var
  TransHed       : TBatchTHRec;
  AccR           : CustRec;
  StockR         : StockRec;
  LocR           : MLocRec;

  GotLoc, GotStk,
  GotAcc,
  GotStkLoc      : Boolean;

  //PR: 13/09/2013 ABSEXCH-13192 Include Job for CC/Dept
  GotJob         : Boolean;
  JobR           : JobRecType;

  siPos          : TBtrieveFileSavePos;
  DocType        : DocTypes;
  RNum           : Double;
  I              : SmallInt;
  SplitMult      : Double;

  StockParam, AccParam, TmpStr : string;



  // Imports defaults for a timesheet
  Procedure ImportTSHDefaults;
  Var
    siPos           : TBtrieveFileSavePos;
    GotEmp, GotRate : Boolean;
    EmpR            : EmplType;
    RateR           : EmplPayType;


  Begin { ImportTSHDefaults }
    GotEmp := False;
    FillChar (EmpR, SizeOf(EmpR), #0);

    GotRate := False;
    FillChar (RateR, SizeOf(RateR), #0);


    With FBtrIntf^ Do Begin
      // Get Employee
      If (Trim(TransHed.EmpCode) <> '') Then Begin
        // Get Employee Record
        SaveExLocalPosFile (JMiscF, siPos);
        GotEmp := LGetMainRec(JMiscF, PartCCKey(JARCode, JAECode) + LJVar(TransHed.EmpCode,6));
        If GotEmp Then EmpR := LJobMisc^.EmplRec;
        RestoreExLocalPos (siPos);
      End; { If (Trim(TransHed.EmpCode) <> '') }

      // Get Rate Code
      If (Trim(FTL.StockCode) <> '') Then
        // Get Time Rate Record
        GotRate := GetTimeRate(RateR, TransHed.EmpCode);

      If GotRate Then Begin
        // ------------------------  Analysis Code  --------------------------
        FTL.AnalCode := RateR.EAnalCode;

        // ----------------------  Cost Ccy & Amount  ------------------------
        FTL.Currency := RateR.CostCurr;       //  - Already Set
        FTL.NetValue := RateR.Cost;

        // ---------------------  Charge Ccy & Amount  -----------------------
        FTL.TSHCCurr := RateR.ChargeCurr;
        FTL.CostPrice := RateR.ChargeOut;
      End; { If GotRate }

      If Syss.UseCCDep And GotEmp Then Begin
        // ----------------  Cost Centre / Department  ---------------------
        If (Trim(FTL.CC) = '') Then FTL.CC  := EmpR.CCDep[BOn];
        If (Trim(FTL.Dep) = '') Then FTL.Dep := EmpR.CCDep[BOff];
      End; { If Syss.UseCCDep }
    End; { With FBtrIntf^ }
  End; { ImportTSHDefaults }

begin
  OutputDebug('TTransactionLine.DoImportDefaults Start');
  Profiler.StartFunc('ITransactionLine.ImportDefaults');
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    GotStk := False;
    FillChar (StockR, SizeOf(StockR), #0);

    GotAcc := False;
    FillChar (AccR, SizeOf(AccR), #0);

    GotLoc := False;
    FillChar (LocR, SizeOf(LocR), #0);

    GotStkLoc := False;

    //PR: 13/09/2013 ABSEXCH-13192
    GotJob := False;
    FillChar (JobR, SizeOf(JobR), #0);

    // Get a local copy of the transaction header
    TransHed := (FTransaction As TTransaction).TH;

    // Calculate Document Type
    DocType := TKDocTypeToEntDocType (TransHed.TransDocHed);

    With FBtrIntf^ Do Begin
      If (Trim(FTL.StockCode) <> '') And (DocType <> TSH) Then Begin
        // Get Stock Record
        SaveExLocalPosFile (StockF, siPos);
        GotStk := LGetMainRec(StockF, FullStockCode(FTL.StockCode));
        If GotStk Then StockR := LStock;
        RestoreExLocalPos (siPos);
      End; { If (Trim(FTL.StockCode) <> '') }

      // Get customer/supplier Record
      If (Trim(TransHed.CustCode) <> '') Then Begin
        if TransHed.CustCode <> TTransactionLines(FTHLines).AccRec.CustCode then
        begin
          SaveExLocalPosFile (CustF, siPos);
          GotAcc := LGetMainRec(CustF, FullCustCode(TransHed.CustCode));
          If GotAcc Then AccR := LCust;
          RestoreExLocalPos (siPos);
        end
        else
        begin
          GotAcc := True;
          AccR := TTransactionLines(FTHLines).AccRec;
        end;
      End; { If (Trim(TransHed.CustCode) <> '') }


      //PR: 05/06/02 - Added for splitpacks
      if GotStk then
      begin
        if StockR.DPackQty and StockR.PricePack then
        begin
          if Doctype in SalesSplit then
            SplitMult := StockR.SellUnit
          else
            SplitMult := StockR.BuyUnit;
        end;
      end;

      //PR: 13/09/2013 ABSEXCH-13192 Include Job for CC/Dept but only if we have Job Costing and Enhanced Security.
      If (Trim(FTL.JobCode) <> '') then
      begin
        with (FToolkit As TToolkit).SystemSetupI.ssReleaseCodes as ISystemSetupReleaseCodes2 do
          if (rcJobCosting <> rcDisabled) and (rcEnhancedSecurity <> rcDisabled) then
        Begin
          // Get Job Record
          SaveExLocalPosFile (JobF, siPos);
          GotJob := LGetMainRec(JObF, FullJobCode(FTL.JobCode));
          If GotJob Then JobR := LJobRec^;
          RestoreExLocalPos (siPos);
        End; { If (Trim(FTL.JobCode) <> '') }
      end;

      //PR: 18/10/2010 If we have an override location on the header use it for the line location
      if AllowOverrideLocation(DocType) and not FTL.Payment and (Trim(TransHed.thOverrideLocation) <> '') then
        FTL.MLocStk := TransHed.thOverrideLocation
      else
      begin

        If GotStk And Syss.UseMLoc And (Trim(FTL.MLocStk) = '') Then
          // Default Line Location to stock default
          FTL.MLocStk := StockR.DefMLoc;

        if Assigned(UserO) then
        begin //using enhanced security - eek!
          if GotStk then StockParam := StockR.DefMLoc else StockParam := '';
          if GotAcc then AccParam := AccR.DefMLocStk else AccParam := '';
          TmpStr := SetPriority(UserO.upDefLocRule, StockParam, AccParam, UserO.upDefLocation);
          if Trim(TmpStr) <> '' then
            FTL.MLocStk := TmpStr;
        end;

      end;

      If GotStk And Syss.UseMLoc And (Trim(FTL.MLocStk) <> '') Then Begin
        // Get Location record
        SaveExLocalPosFile (MLocF, siPos);
      {$IFDEF EXSQL}
        if UsingSQL then
          UseVariantForNextCall(F[MLocF], FBtrIntf.ExClientId);
      {$ENDIF}

        GotLoc := LGetMainRec(MLocF, CostCCode + CSubCode[True] + LJVar(FTL.MLocStk, MLocKeyLen));
        If GotLoc Then LocR := LMLocCtrl^;

        If GotLoc Then
        begin
          // Get Stock-Location record
      {$IFDEF EXSQL}
        if UsingSQL then
          UseVariantForNextCall(F[MLocF], FBtrIntf.ExClientId);
      {$ENDIF}
          GotStkLoc := LGetMainRec(MLocF, CostCCode + CSubCode[False] + FullStockCode (FTL.StockCode) + LJVar(FTL.MLocStk, MLocKeyLen));
        end;

        If GotLoc And GotStkLoc Then Begin
          // Adjust Stock according to Location Override flags
          //PR: This was checking loUseCCDep - changed it to use loUseNom
          If LocR.MLocLoc.loUseNom Then
            For I := 1 To NofSNoms Do
              StockR.NomCodes[I] := LMLocCtrl^.MStkLoc.lsDefNom[I];

          If LocR.MLocLoc.loUseCPrice Then Begin
            StockR.PCurrency := LMLocCtrl^.MStkLoc.lsPCurrency;
            StockR.CostPrice := LMLocCtrl^.MStkLoc.lsCostPrice;
          End; { If LocR.MLocLoc.loUseCPrice  }

          If LocR.MLocLoc.loUseCCDep Then
            StockR.CCDep := LMLocCtrl^.MStkLoc.lsCCDep;

          If LocR.MLocLoc.loUseRPrice Then Begin
            StockR.ROCurrency := LMLocCtrl^.MStkLoc.lsROCurrency;
            StockR.ROCPrice := LMLocCtrl^.MStkLoc.lsROPrice;
          End; { If LocR.MLocLoc.loUseRPrice }
        End; { If GotLoc And GotStkLoc }

        RestoreExLocalPos (siPos);
      End; { If }


      // ---------------------------  Nominal Code  ---------------------------
      If GotStk Then Begin
        if (DocType = SRN) then
          FTL.NomCode := StockR.ReturnGL
        else
        if (DocType = PRN) then
          FTL.NomCode := StockR.PReturnGL
        else
        If (DocType <> ADJ) Then Begin
          If (DocType In PurchSplit) And Syss.AutoValStk And (StockR.StockType = StkBillCode) Then
            // When buying a BOM, force the GL to be WIP
            FTL.NomCode := StockR.NomCodeS[5]
          Else
            FTL.NomCode := StockR.NomCodeS[1 + Ord(DocType In PurchSplit) + (2 * Ord((DocType In PurchSplit) and Syss.AutoValStk))];
        End { If (DocType <> ADJ) }
        Else Begin
          // HM 27/02/01: ADJ
          If (StockR.StockType = StkBillCode) then
            FTL.NomCode := StockR.NomCodes[5]
          Else
            FTL.NomCode := StockR.NomCodes[3];
        End; { Else }
        if DocType = WOR then
        begin
          If (StockR.StockType = StkBillCode) then
            FTL.NomCode := StockR.NomCodes[5]
          Else
            FTL.NomCode := StockR.NomCodes[4];
        end;
      End; { If GotStk }

      If GotAcc Then Begin
        // For sales invoices, override account nominal code
        If ((DocType In SalesSplit) Or (Not GotStk)) And (AccR.DefNomCode <> 0) Then
          FTL.NomCode := AccR.DefNomCode;

        // ---------------------  Default Line Discount  ---------------------
        //PR 13/04/06 - added check for payment lines (Bug/Wish 20051102105526)
        if not FTL.Payment then
          FTL.Discount := AccR.Discount;

        If (AccR.CDiscCh In StkBandSet) Or (AccR.Discount <> 0) Then
          FTL.DiscountChr := AccR.CDiscCh;
      End; { If GotAcc }

      // --------------------------  VAT Code  -----------------------------
      If GotAcc And GotStk Then Begin
        // Pick default from Stock and Customer
        FTL.VatCode := Correct_PVAT(StockR.VATCode, AccR.VATCode);

        If (FTL.VatCode = VATICode) Then
          FTL.VATIncFlg := StockR.SVatIncFlg;
      End { If GotAcc And GotStk }
      Else
        If GotAcc Then Begin
          // Only got customer
          FTL.VATCode := AccR.VATCode;
          FTL.VATIncFlg := AccR.CVatIncFlg;
        End { If GotAcc }
        Else
          If GotStk Then Begin
            // Only got Stock
            FTL.VATCode := StockR.VATCode;
            FTL.VATIncFlg := StockR.SVatIncFlg;
          End; { If GotStk }

      If GotStk Then Begin
        // --------------------------  Description  --------------------------
        FTL.Desc := StockR.Desc[1];

        // ---------------------------  Intrastat  ---------------------------
        FTL.SSDCommod  := StockR.CommodCode;
        FTL.SSDSPUnit  := StockR.SuppSUnit;
        FTL.SSDUpLift  := StockR.SSDDUplift;

        // MH 18/01/2016 2016-R1 ABSEXCH-17099: SSD Country field no longer used for UK
        If (CurrentCountry <> UKCCode) Then
          FTL.SSDCountry := StockR.SSDCountry
        Else
        Begin
          // UK - For Purchases take Intrastat SSD Country from Supplier Address, for Sales
          // use the Delivery Address Country if set, otherwise use the Customer Address
          If (DocType In SalesSplit) Then
          Begin
            // Sales
            If (Trim(TransHed.thDeliveryCountry) <> '') Then
              FTL.SSDCountry := TransHed.thDeliveryCountry
            Else
              FTL.SSDCountry := AccR.acCountry;
          End // If (DocType In SalesSplit)
          Else If (DocType In PurchSplit) Then
          Begin
            // Purchases
            FTL.SSDCountry := AccR.acCountry;
          End; // If (DocType In PurchSplit)
        End; // Else

        // ---------------------------  Line Type  ---------------------------
        if not (TTransaction(FTransaction).DocType in [dtPRN, dtSRN]) then
          FTL.DocLTLink := StockR.StkLinkLT;

        // --------------------------  Unit Weight  --------------------------
        If (DocType In SalesSplit) Then
          FTL.LWeight := StockR.SWeight
        Else
          FTL.LWeight := StockR.PWeight;

        // ------------------------  Pack Quantities  ------------------------
        // Fields not currently supported through Toolkit DLL
        //FTL.UsePack := StockR.CalcPack;
        //FTL.PrxPack := StockR.ProcePack;
        //FTL.ShowCase := StockR.DPackQty;

        If (FTL.KitLink = 0) Then Begin
          // A REAL transaction line - not a bom item or additional description line

          If (DocType In SalesSplit) Then Begin
            // Sales Transaction
            If (Not StockR.DPackQty) Then
              // Not a split pack item
              FTL.QtyMul := StockR.SellUnit;

            // Field not currently supported through Toolkit DLL
            //FTL.QtyPack := StockR.SellUnit;
          End { If (Not StockR.DPackQty) }
          Else //PR 18/04/06 - QtyMul was getting set on ADJs, which was not correct [20050719080534], so added check
              //for DocType in PurchSplit
          If (DocType In PurchSplit) Then Begin
            // Purchase Transaction
            If (Not StockR.DPackQty) Then
              // Not a split pack item
              FTL.QtyMul := StockR.BuyUnit;

            // Field not currently supported through Toolkit DLL
            //FTL.QtyPack := StockR.BuyUnit;
          End; { Else }
        End; { If (KitLink = 0) }

        // ------------------------  Unit Price  ---------------------------
        If (Not (DocType In [ADJ, NMT, TSH, WOR])) Then Begin
        Profiler.StartFunc('ITransactionLine.ImportDefaults.CalcStockPrice');
          CalcStockPrice;
        Profiler.EndFunc('ITransactionLine.ImportDefaults.CalcStockPrice');
        End; { If (Not (DocType In [ADJ, NMT, TSH])) }

        If (DocType In SalesSplit+[WOR, SRN]) Then Begin
          // ----------------------  Cost Price  ---------------------------
          If (Not StockR.ShowAsKit)  {or (KitLink<>0))} Then Begin
            // Do not set cost price if Parent of Kit, as cost set in lines which are recalled
            Rnum:=Currency_ConvFT(Calc_StkCP(StockR.CostPrice, StockR.BuyUnit, StockR.CalcPack),
                                  StockR.PCurrency,
                                  TransHed.Currency,
                                  UseCoDayRate);

            FTL.CostPrice := Round_Up(Calc_IdQty(Rnum,FTL.QtyMul,Not StockR.CalcPack),Syss.NoCosDec);
          End { If (Not StockR.ShowAsKit) }
          Else
            FTL.CostPrice := 0.0;
        End { If (DocType In SalesSplit) }
        Else
        begin
          // HM 27/02/01: Added ADJ support
          If (DocType = ADJ) Then Begin
            Rnum := Currency_ConvFT(Calc_StkCP(StockR.CostPrice, StockR.BuyUnit, (StockR.DPackQty And StockR.CalcPack)),
                                    StockR.PCurrency,
                                    TransHed.Currency,
                                    UseCoDayRate);

            FTL.CostPrice := Round_Up(Rnum, Syss.NoCosDec);
          End; { If (DocType = ADJ) }
        end;
  {        if StockR.DPackQty and StockR.PricePack then
            FTL.CostPrice := FTL.CostPrice * SplitMult;}


        If ((FToolkit As TToolkit).SystemSetupI.ssReleaseCodes.rcJobCosting <> rcDisabled) Then Begin
          // ----------------------  Job Costing  ---------------------------
          // Default AnalCode from Stock - if not already set
          //PR: 24/07/2013 ABSEXCH-12729 Should only set anal code for Purchase Transactions and Stock Adjustments.
          If (DocType in PurchSplit + StkAdjSplit) and (Trim(FTL.AnalCode) = '') And (Trim(StockR.JAnalCode) <> '') Then
            FTL.AnalCode := StockR.JAnalCode;

          // WIP GL Code
          If (Trim(FTL.JobCode) <> '') And (Trim(FTL.AnalCode) <> '') Then
            Check_JOB_WIP_NOM;
        End; { If ((FToolkit As TToolkit)... }

        If Syss.UseCCDep Then Begin
          // ----------------  Cost Centre / Department  ---------------------
          If GotStk Then Begin
            If (Trim(FTL.CC) = '') Then FTL.CC  := StockR.CCDep[BOn];
            If (Trim(FTL.Dep) = '') Then FTL.Dep := StockR.CCDep[BOff];
          End; { If GotStk }

          If GotAcc Then Begin
            If (Trim(FTL.CC) = '') Then FTL.CC := AccR.CustCC;
            If (Trim(FTL.Dep) = '') Then FTL.Dep := AccR.CustDep;
          End; { If GotAcc }

          if Assigned(UserO) then
          begin //using enhanced security - eek!
            if GotStk then StockParam := StockR.CCDep[Bon] else StockParam := '';
            if GotAcc then AccParam := AccR.CustCC else AccParam := '';
            TmpStr := SetPriority(UserO.upCCDeptRule, StockParam, AccParam, UserO.upDefCostCentre);
            if Trim(TmpStr) <> '' then
              FTL.CC := TmpStr;

            if GotStk then StockParam := StockR.CCDep[Boff] else StockParam := '';
            if GotAcc then AccParam := AccR.CustDep else AccParam := '';
            TmpStr := SetPriority(UserO.upCCDeptRule, StockParam, AccParam, UserO.upDefDepartment);
            if Trim(TmpStr) <> '' then
              FTL.Dep := TmpStr;
          end;

        End; { If Syss.UseCCDep }
      End; { If GotStk }

      //PR: 15/05/2009 Added MultiBuy Discounts
      if (FIntfType = imAdd) and GotStk and GotAcc and not (DocType in [ADJ, NMT, TSH]) then
      begin
        FMultiBuyO := TMultiBuyDiscounts.Create(FTL.StockCode, TransHed.CustCode, TransHed.TransDate, TransHed.Currency, FTL.Qty);
        FMultiBuyO.BtrIntf := FBtrIntf;
        FMultiBuyO.IsSales := DocType in SalesSplit;
        FMultiBuyO.LoadList;

        FMultiBuyI := FMultiBuyO;
        SetMultiBuyDiscounts;
      end;

      // ------------------------  Calculate VAT  --------------------------
      If (Not (DocType In [ADJ, NMT, TSH])) Then
        CalcVATAmount;

      // -------------------------  Timesheets  ---------------------------
      If (DocType = TSH) Then
        ImportTSHDefaults;

      //PR: 13/09/2013 ABSEXCH-13192 If cc/dept still empty then try Job record
      If GotJob Then Begin
        If (Trim(FTL.CC) = '') Then FTL.CC := JobR.CCDep[True];
        If (Trim(FTL.Dep) = '') Then FTL.Dep := JobR.CCDep[False];
      End; { If GotAcc }

    End; { With FBtrIntf^ }
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
  Profiler.EndFunc('ITransactionLine.ImportDefaults');
  OutputDebug('TTransactionLine.DoImportDefaults End');
end;

{-----------------------------------------}

// Call standard system function to calculate the correct Nominal Code for Job Costing transactions
procedure TTransactionLine.Check_JOB_WIP_NOM;
Var
  GlobSaveInfo : TBtrieveSavePosType;
  TmpJob       : JobRecPtr;
  TmpAnal      : JobMiscPtr;
begin
  // Save all global file positions
  GlobSaveInfo := SaveSystemFilePos ([]);

  // preload Job Record
  New(TmpJob);
  TmpJob^ := JobRec^;
  If Global_GetMainRec(JobF, FTL.JobCode) Then Begin
    // preload Analysis Code record
    New(TmpAnal);
    TmpAnal^ := JobMisc^;
    If Global_GetMainRec(JMiscF, FTL.AnalCode) Then Begin
      // Calculate correct Nomoinal Code
      With FTL Do
        NomCode := Job_WIPNom(NomCode,
                              JobCode,
                              AnalCode,
                              StockCode,
                              MLocStk,
                              (FTransaction As TTransaction).TH.CustCode);
    End; { If Global_GetMainRec(JMiscF, FTL.AnalCode) }

    // Restore original Analysis Code record
    TmpAnal^ := JobMisc^;
    Dispose(TmpAnal);
  End; { If Global_GetMainRec(JobF, FTL.JobCode) }

  // Restore original Job record
  JobRec^ := TmpJob^;
  Dispose(TmpJob);

  // Restore all global file positions
  RestoreSystemFilePos (GlobSaveInfo);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlAnalyisCodeI: IJobAnalysis;
begin
  With FToolkit As TToolkit Do
    Result := JobCostingO.JobAnalysisO.GetCloneInterface(Get_tlAnalysisCode);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlJobCodeI: IJob;
begin
  With FToolkit As TToolkit Do
    Result := JobCostingO.JobO.GetCloneInterface(Get_tlJobCode);
end;

{-----------------------------------------}

function TTransactionLine.Get_tlSerialBatch : ITransactionLineSerialBatch;
begin
  // NOTE: Not available during adding as TH Folio and TL AbsLineNo not yet set
  If (FIntfType <> imAdd) Then Begin
    // Check Line Serial/Batch Number sub-object has been initialised
    If (Not Assigned(FLineSnoO)) Then Begin
      FLineSnoO := CreateTTransLineSno (FToolkit, FTransaction, Self);

      FLineSnoI := FLineSnoO;
    End; { If (Not Assigned(FLineSnoO)) }

    // Ensure SNo object is in-sync with line
    With (FTransaction As TTransaction) Do
      FLineSnoO.BuildSerialList (FIntFType,
                                 FTL.StockCode,
                                 TH.OurRef,
                                 FTL.ABSLineNo,
                                 TKDocTypeToEntDocType (TH.TransDocHed),
                                 False,
                                 FTL.Qty);

    Result := FLineSnoI;
  End { If (FIntfType <> imAdd) }
  Else
    Raise EInvalidMethod.Create ('The tlSerialBatch property is not available when adding a Transaction Line');
end;

{-----------------------------------------}

function TTransactionLine.Get_tlAsNOM: ITransactionLineAsNOM;
var
  OK : Boolean;
begin
  with  FTransaction as TTransaction do
    OK := TH.TransDocHed = 'NOM';

  if not Assigned(FLineAsNOMO) and OK then
  begin
	//PL 26/10/2016	ABSEXCH-14172 added PayInRef to ITransactionLineAsNOM as a descendant ITransactionLineAsNOM3
    FLineAsNOMO := TTransactionLineAsNOM.Create(Self, FToolkit as TToolkit, ITransactionLineAsNOM3, FIntfType, @FTL);

    FLineAsNOMI := FLineAsNOMO;
  end;

  Result := FLineAsNOMI;
end;

function TTransactionLine.Get_tlAsTSH: ITransactionLineAsTSH;
var
  OK : Boolean;
begin
  with  FTransaction as TTransaction do
    OK := TH.TransDocHed = 'TSH';

  if not Assigned(FLineAsTSHO) and OK then
  begin
    FLineAsTSHO := TTransactionLineAsTSH.Create(Self, FToolkit as TToolkit, ITransactionLineAsTSH);

    FLineAsTSHI := FLineAsTSHO;
  end;

  Result := FLineAsTSHI;
end;

function TTransactionLine.Get_tlAsADJ: ITransactionLineAsADJ;
var
  OK : Boolean;
begin
  with  FTransaction as TTransaction do
    OK := TH.TransDocHed = 'ADJ';

  if not Assigned(FLineAsADJO) and OK then
  begin
    FLineAsADJO := TTransactionLineAsADJ.Create(Self, FToolkit as TToolkit, ITransactionLineAsADJ);

    FLineAsADJI := FLineAsADJO;
  end;

  Result := FLineAsADJI;
end;

function TTransactionLine.Get_tlAsWOR: ITransactionLineAsWOR;
var
  OK : Boolean;
begin
  with  FTransaction as TTransaction do
    OK := TH.TransDocHed = 'WOR';

  if not Assigned(FLineAsWORO) and OK then
  begin
    FLineAsWORO := TTransactionLineAsWOR.Create(Self, FToolkit as TToolkit,
                                                FTransaction as TTransaction, ITransactionLineAsWOR);

    FLineAsWORI := FLineAsWORO;
  end;

  Result := FLineAsWORI;
end;

function TTransactionLine.Get_tlAsApplication: ITransactionLineAsApplication;
var
  OK : Boolean;
begin
  with  FTransaction as TTransaction do
    OK := IsApplication(TH.TransDocHed);

  if not Assigned(FLineAsAppO) and OK then
  begin
    FLineAsAppO := TTransactionLineAsApplication.Create(Self, FToolkit as TToolkit, ITransactionLineAsApplication,
                                                     imGeneral, @FTL);

    FLineAsAppI := FLineAsAppO;
  end;

  Result := FLineAsAppI;
end;

function TTransactionLine.Get_tlAsPayLine: ITransactionLineAsPayLine;
var
  bOK : Boolean;
begin
{  with  FTransaction as TTransaction do
    OK := TH.TransDocHed = 'ADJ';}

  bOK := FTL.Payment and (FTL.DocHed <> 'NOM');

  if not Assigned(FLineAsPayLineO) and bOK then
  begin
    FLineAsPayLineO := TTransactionLineAsPayLine.Create(Self,
                            FToolkit as TToolkit, FTransaction as TTransaction, ITransactionLineAsPayLine,
                            FIntfType);

    FLineAsPayLineI := FLineAsPayLineO;
  end;

  Result := FLineAsPayLineI;
end;

procedure TTransactionLine.InitViews;
begin
  FLineAsNOMI  := nil;
  FLineAsNOMO  := nil;

  FLineAsTSHI  := nil;
  FLineAsTSHO  := nil;

  FLineAsADJI  := nil;
  FLineAsADJO  := nil;

  FLineAsWORI  := nil;
  FLineAsWORO  := nil;

  FLineAsPayLineI  := nil;
  FLineAsPayLineO  := nil;

  FLineAsReturnI := nil;
  FLineAsReturnO := nil;

end;

{-----------------------------------------}

function TTransactionLine.Get_RecordPosition: Integer;
begin
  Result := FRecordPosition;
end;

function TTransactionLine.Get_tlYear: SmallInt;
begin
  Result := FTL.Year;
end;

procedure TTransactionLine.Set_tlYear(Value: SmallInt);
begin
  if OkToUpdate then
    FTL.Year := ValidateYear(Value)
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

function TTransactionLine.Get_tlPeriod: SmallInt;
begin
  Result := FTL.Period;
end;

procedure TTransactionLine.Set_tlPeriod(Value: SmallInt);
begin
  if OkToUpdate then
    FTL.Period := ValidatePeriod(Value)
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

function TTransactionLine.Get_tlNominalMode: TNominalModeType;
begin
  Result := TNominalModeType(FTL.NomMode);
end;

function TTransactionLine.Get_tlDocType: TDocTypes; safecall;
begin
  Result := TKDocTypeToTLBDocType(FTL.DocHed);
end;


{-----------------------------------------}

function TTransactionLine.Print(PrintAs: TTransactionLinePrintMode): IPrintJob;
Var
  oPrintJob  : TPrintJob;
begin { Print }
  // Only allow printing for general object and clone objects
  If (FIntfType In [imGeneral, imClone]) Then Begin
    // Create and initialise the PrintJob object
    oPrintJob := TPrintJob.Create(FToolkit, fmLabel, deftypeProductLabel, jtLabel);
    With oPrintJob Do Begin
      // Configure to print the transaction
      MainFileNum  := IDetailF;
      MainKeyPath  := IDFolioK;
      //PR: 06/01/2009 Change to use LineNo rather than AbsLineNo (Recommended by MH)
//      MainKeyRef   := FullNomKey(FTL.FolioNum) + FullNomKey(FTL.ABSLineNo);
      MainKeyRef   := FullNomKey(FTL.FolioNum) + FullNomKey(FTL.LineNo);

      TableFileNum := MainFileNum;
      TableKeyPath := MainFileNum;
      TableKeyRef  := MainKeyRef;

      DefaultAcc   := FTL.CustCode;
    End; { With oPrintJob }

    // Return reference to interface - object will be automatically destroyed when
    // user reference to it is lost
    Result := oPrintJob;
  End { If (FIntfType In [imGeneral, imClone]) }
  Else
    Raise EInvalidMethod.Create ('The Print method is not available in this object')
end; { Print }

{-----------------------------------------}

function TTransactionLine.UpdateUplift(NewAmount : Double) : Integer;
var
  OurRef, StockCode : PChar;
begin
  AuthoriseFunction(201, 'UpdateUplift');
  OurRef := StrAlloc(255);
  StockCode := StrAlloc(255);
  Try
    StrPCopy(OurRef, Get_tlOurRef);
    StrPCopy(StockCode, Get_tlStockCode);

    Result := Ex_UpdateUplift(OurRef, Get_tlAbsLineNo, StockCode, NewAmount);
  Finally
    StrDispose(OurRef);
    StrDispose(StockCode);
  End;

  if Result <> 0 then
    LastErDesc := EX_ERRORDESCRIPTION(93, Result);

end;

Function TTransactionLine.AuthoriseFunction (Const FuncNo     : Byte;
                                             Const MethodName : String;
                                             Const AccessType : Byte = 0) : Boolean;
Begin { AuthoriseFunction }
  Case FuncNo of
    // .Update Uplift
    201       : Result := not (FIntfType in [imAdd, imUpdate, imUpdateEx]);

    //CreateReturn
    202       : Result := (FIntfType = imGeneral) and
                          (TTransaction(FTransaction).DocType in [dtSIN, dtSDN, dtPIN, dtPDN, dtSRI, dtPPI, dtWOR]) and
                          TTransaction(FTransaction).TH.NomAuto and
                          (not FTL.Payment);
    //PR: 06/10/2009 LinkToSOR got lost between 6SQL and 6.01
    203       : Result := (FIntfType in [imAdd, imUpdate]) and (TTransaction(FTransaction).TH.TransDocHed = 'POR');

    //UpdateAccountStockAnalysis
    204       : Result := (FIntfType = imGeneral) and
                          (TTransaction(FTransaction).DocType in [dtSIN, dtSOR, dtPIN, dtPOR, dtSJI, dtPJI]);

    //UpdateReconcileFlag
    205       : Result := (FIntfType = imGeneral);
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

function TTransactionLine.Get_tlCostApport: Double;
begin
{$IFDEF EN550CIS}
  Result := FTL.CostApport;
{$ENDIF}
end;

procedure TTransactionLine.Set_tlCostApport(Value: Double);
begin
{$IFDEF EN550CIS}
  if OkToUpdate then
  begin
    FTL.CostApport := Value;
    FDetailsChanged := True;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
{$ENDIF}
end;

function TTransactionLine.Get_tlLineSource: Byte;
begin
  Result := FTL.AutoLineType;
end;

function TTransactionLine.Get_tlCISRateCode: WideString;
begin
  Result := FTL.CISRateCode;
end;

procedure TTransactionLine.Set_tlCISRateCode(const Value: WideString);
begin
  if OkToUpdate then
    FTL.CISRateCode := ExtractChar(Value, ' ')
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

function TTransactionLine.Get_tlCISRate: Double;
begin
  Result := FTL.CISRate;
end;

procedure TTransactionLine.Set_tlCISRate(Value: Double);
begin
  if OkToUpdate then
    FTL.CISRate := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

function TTransactionLine.ImportDefaultsForUser(const UserID: WideString) : Integer;
var
  UserO : IUserProfile;
begin
  if OkToUpdate then
  begin
    UserO := CheckUser(UserID, Result);

    if Result = 0 then
      DoImportDefaults(UserO);
  end
  else
    Raise EInvalidMethod.Create ('The ITransactionLine.ImportDefaultsForUser method is not available');
end;

function TTransactionLine.CheckUser(const UserID : string; var Res : Integer) : IUserProfile;
begin
  Result := nil;
  if EnSecurity then
  begin //Enhanced security is licenced
    with TToolkit(FToolkit).UserI do
    begin
      SavePosition;
      if (GetEqual(BuildUserIDIndex(UserID)) = 0) then
      begin //UserID is valid user
        Res := 0;
        Result := Clone;
      end
      else
        Res := 30001; //not a valid user ID
      RestorePosition;
    end;
  end
  else //Enhanced security is not licenced
    Res := 30000;
end;

function TTransactionLine.SetPriority(Rule : TPriorityRuleType;
                                 const st : string;
                                 const ac : string;
                                 const op : string) : string;
begin
  Case Rule of
    prStkAccOp : if Trim(st) <> '' then Result := st else
                   if Trim(ac) <> '' then Result := ac else
                     Result := op;

    prAccStkOp : if Trim(ac) <> '' then Result := ac else
                   if Trim(st) <> '' then Result := st else
                     Result := op;

    prOpAccStk : if Trim(op) <> '' then Result := op else
                   if Trim(ac) <> '' then Result := ac else
                     Result := st;

    prOpStkAcc : if Trim(op) <> '' then Result := op else
                   if Trim(st) <> '' then Result := st else
                     Result := ac;
  end;//Case
end;

function TTransactionLine.OkToUpdate(CanUpdate : Boolean = False) : Boolean;
begin
  Result := not (TTransaction(FTransaction).InterfaceMode in [imUpdateEx2]);

  if not Result then
  begin
    //Is it a non-financial line?
    Result := (
               (FTL.NetValue = 0) and
               (FTL.VAT = 0) and
               (FTL.CostPrice = 0) and
               (Trim(FTL.StockCode) = '')
              ) or
              ( //PR 5/12/2007 Added functionality to allow unposted Timesheet lines to be updated or deleted.
               (TTransaction(FTransaction).TH.TransDocHed = 'TSH') and
               (TTransaction(FTransaction).TH.RunNo <> -35) //make sure it hasn't been posted
              );

    if Result then
      Result := CanUpdate;
  end;
end;

function TTransactionLine.Get_tlMultiBin: ITransactionLineMultiBin;
begin
  // NOTE: Not available during adding as TH Folio and TL AbsLineNo not yet set
  If (FIntfType <> imAdd) Then Begin

    If (Not Assigned(FMultiBinO)) Then Begin
      FMultiBinO := CreateTTransLineMultiBin (FToolkit, FTransaction, Self);

      FMultiBinI := FMultiBinO;
    End; 

    // Ensure Bin object is in-sync with line
    With (FTransaction As TTransaction) Do
      FMultiBinO.BuildBinList (FIntFType,
                               FTL.StockCode,
                               TH.OurRef,
                               FTL.ABSLineNo,
                               TKDocTypeToEntDocType (TH.TransDocHed),
                               False);

    Result := FMultiBinI;
  End { If (FIntfType <> imAdd) }
  Else
    Raise EInvalidMethod.Create ('The tlMultiBin property is not available when adding a Transaction Line');

end;

function TTransactionLine.Get_tlRunNo: Integer;
begin
  Result := FTL.tlRunNo;
end;

function TTransactionLine.Get_tlStockDeductQty: Double;
begin
  Result := FTL.tlStockDeductQty;
end;

function TTransactionLine.Get_tlUseQtyMul: WordBool;
begin
  Result := FTL.tlUseQtyMul;
end;

function TTransactionLine.Get_tlReconciliationDate: WideString;
begin
  Result := FTL.tlReconciliationDate;
end;

function TTransactionLine.Get_tlB2BLinkFolio: Integer;
begin
  Result := FTL.tlB2BLinkFolio;
end;

function TTransactionLine.Get_tlB2BLineNo: Integer;
begin
  Result := FTL.tlB2BLineNo;
end;

function TTransactionLine.Get_tlCOSDailyRate: Double;
begin
  Result := FTL.tlCOSDailyRate;
end;

function TTransactionLine.Get_tlVATIncValue: Double;
begin
  Result := FTL.IncNetValue;
end;

procedure TTransactionLine.Set_tlVATIncValue(Value: Double);
begin
  FTL.IncNetValue := Value;
end;

function TTransactionLine.Get_tlBinQty: Double;
begin
  Result := FTL.BinQty;
end;

function TTransactionLine.Get_tlQtyPack: Double; safecall;
begin
  Result := FTL.tlQtyPack;
end;

procedure TTransactionLine.ExplodeBOM; safecall;
var
  j, CompCount : integer;
  ThisQty : Double;
  oStock, StockClone : IStock;
  oTrans : ITransaction;
  LinesAdded : Integer;
  StkLCount : Integer;
  RecPos, Res: Integer;

  //PR: 15/11/2012 ABSEXCH-13720 Need to store the original stock, in case of sub-boms
  ParentStockFolio : longint;

  function WantToExplode(Stk : IStock2) : Boolean;
  begin
    Result := ((FTL.DocHed[1] = 'P') and (Stk.stShowKitOnPurchase)) or
//              ((FTL.DocHed[1] in ['S', 'W']) and Stk.stShowKitOnSales);
              ((FTL.DocHed[1] = 'S') and Stk.stShowKitOnSales) or
              (FTL.DocHed[1] = 'W');
  end;

  function StockLineCount(oStock2 : IStock) : integer;
  var
    k : integer;
  begin
    Result := 1;
    for k := 6 downto 1 do
      if  Trim(oStock2.stDesc[k]) <> '' then
      begin
        Result := k;
        Break;
      end;
  end;


  function CalcCompCount(const SCode : string) : integer;
  var
    Pos, Pos1, Res, i : integer;
  begin
    Result := 0;
    oStock.SavePosition;
    Pos1 := oStock.Position;

    Res := oStock.GetEqual(oStock.BuildCodeIndex(SCode));

    if Res = 0 then
    begin
      Result := 1;

      if WantToExplode(oStock as IStock2) then
      for i := 1 to oStock.stBillOfMaterials.blComponentCount do
      begin
        if oStock.stBillOfMaterials.blComponent[i].bmStockCodeI.stType = stTypeBillOfMaterials then
        begin
          oStock.SavePosition;
          Pos := oStock.Position;

          Result := Result + CalcCompCount(oStock.stBillOfMaterials.blComponent[i].bmStockCode);

          oStock.Position := Pos;
          oStock.RestorePosition;
        end
        else
          Result := Result + StockLineCount(oStock);
      end;

    end;

    oStock.Position := Pos1;
    oStock.RestorePosition;

  end;

  procedure AddDescriptionLines(oStock2 : IStock);
  var
    k, StkCount : integer;
  begin
    StkCount := StockLineCount(oStock2);
    if StkCount > 1 then
    for k := 2 to StkCount do
    with oTrans.thLines.Add do
    begin
      tlDescr := oStock2.stDesc[k];
      //PR: 13/11/2012 ABSEXCH-13586 Need to take the folio for BomKitLink from BOM rather than component - ie oStock
      //rather than oStock2.
      //PR: 15/11/2012 ABSEXCH-13720 Need to use the original stock, in case of sub-boms
      tlBomKitLink := ParentStockFolio; //oStock.stFolioNum;
      tlLineType := tlTypeNormal;
      tlLineNo := FTL.LineNo + LinesAdded;
      tlQty := 0;
      Save;
      Inc(LinesAdded);
    end;
  end;

  procedure AddBOMLine(const SCode : string; AddParent : Boolean; ThisQty : Double; ParentPrice : Boolean);
  var
    Pos, Res, i : integer;

    procedure DoAdd;
    begin
      with oTrans.thLines.Add do
      begin
        tlStockCode := oStock.stBillOfMaterials.blComponent[i].bmStockCode;
        tlQty := oStock.stBillOfMaterials.blComponent[i].bmQuantityUsed * ThisQty;
{        tlNetValue := oStock.stBillOfMaterials.blComponent[i].bmUnitCost;
        tlCurrency := oStock.stBillOfMaterials.blComponent[i].bmUnitCostCurrency;}
        //PR: 15/11/2012 ABSEXCH-13720 Need to use the original stock, in case of sub-boms
        tlBOMKitLink := ParentStockFolio; //oStock.stFolioNum;
        tlLocation := FTL.MLocStk;
        tlLineNo := FTL.LineNo + LinesAdded;
        ImportDefaults;
        if Trim(tlCostCentre) = '' then
          tlCostCentre := oTrans.thLines[1].tlCostCentre;
        if Trim(tlDepartment) = '' then
          tlDepartment := oTrans.thLines[1].tlDepartment;
        if oTrans.thDocType = dtWOR then
          tlQtyMul := oStock.stBillOfMaterials.blComponent[i].bmQuantityUsed;
        if ParentPrice then
          tlNetValue := 0;
        Save;
        Inc(LinesAdded);
      end;

      if FTL.DocHed <> 'WOR' then
        AddDescriptionLines(oStock.stBillOfMaterials.blComponent[i].bmStockCodeI);

    end;

  begin
    Res := oStock.GetEqual(oStock.BuildCodeIndex(SCode));

    if Res = 0 then
    begin
      if WantToExplode(oStock as IStock2) then
      begin
      for i := 1 to oStock.stBillOfMaterials.blComponentCount do
      begin
          DoAdd;
          if oStock.stBillOfMaterials.blComponent[i].bmStockCodeI.stType = stTypeBillOfMaterials then
          begin
            oStock.SavePosition;
            Pos := oStock.Position;

            AddBOMLine(oStock.stBillOfMaterials.blComponent[i].bmStockCode, True,
                          ThisQty * oStock.stBillOfMaterials.blComponent[i].bmQuantityUsed,
                                     oStock.stUseKitPrice);

            oStock.Position := Pos;
            oStock.RestorePosition;
          end;

        end; //for i;
      end
      else

    end;

  end;


begin
  //Do something - what?
  oStock := Get_tlStockCodeI;
  oTrans := TTransaction(FTransaction);
  if FSaved then
  begin
    if Assigned(oStock) and (oStock.stType = stTypeBillOfMaterials) then
    begin
        oStock := (FToolkit as TToolkit).StockO;

        // CJS 07/06/2010 - make sure we are on the correct Stock record.
        oStock.SavePosition;
        RecPos := oStock.Position;
        try
          Res := oStock.GetEqual(oStock.BuildCodeIndex(Get_tlStockCode));
          ParentStockFolio := oStock.stFolioNum;
          CompCount := CalcCompCount(Get_tlStockCode);
          for j := oTrans.thLines.thLineCount downto FIdNo + 1 + StockLineCount(oStock) do
            oTrans.thLines[j].tlLineNo := oTrans.thLines[j].tlLineNo + CompCount;

          LinesAdded := 1;
          if (FTL.DocHed[1] <> 'W') then
            AddDescriptionLines(oStock);
          AddBOMLine(Get_tlStockCode, False, FTL.Qty, oStock.stUseKitPrice);

        // CJS 07/06/2010 - restore the original position in the global record.
        finally
          oStock.Position := RecPos;
          oStock.RestorePosition;
        end;

    end
    else
    if Assigned(oStock) then
    begin
      LinesAdded := 1;
      StkLCount := StockLineCount(oStock);
      for j := oTrans.thLines.thLineCount downto FIdNo + 2 do
      begin
        if oTrans.thLines[j].tlLineNo > Get_tlLineNo then
          oTrans.thLines[j].tlLineNo := oTrans.thLines[j].tlLineNo + StkLCount + 1;
      end;

      //PR: 19/04/2013 ABSEXCH-14221 Wasn't setting ParentStockFolio, so tlBOMKitLink didn't get set.
      ParentStockFolio := oStock.stFolioNum;
      AddDescriptionLines(oStock);
    end;
  end
  else
    raise EInvalidMethod.Create('The method ExplodeBOM is not available until the line has been saved');

end;

procedure TTransactionLine.AddDescriptionLines;
begin
  if FSaved then
    ExplodeBOM
  else
    raise EInvalidMethod.Create('The method AddDescriptionLines is not available until the line has been saved');

end;

procedure TTransactionLine.SetAbsLineNo(var Value : longint);
begin
  if FTL.AbsLineNo = 0 then
  begin
    inc(Value);
    FTL.AbsLineNo := Value;
  end;
end;


//============================================ TTransactionLine2 =============================================

procedure TTransactionLine2.ImportDefaults;
begin
  if OkToUpdate then
    DoImportDefaults
  else
    Raise EInvalidMethod.Create ('The ITransactionLine.ImportDefaults method is not available');
end;

procedure TTransactionLine2.DoImportDefaults(const UserO : IUserProfile = nil);
Var
  TransHed       : TBatchTHRec;
  AnalR          : JobAnalType;
  EmpR           : EmplType;
  GotAnal        : Boolean;
  GotEmp         : Boolean;
  GotTerms       : Boolean;
  siPos          : TBtrieveFileSavePos;
  DocType        : DocTypes;
  RNum           : Double;
  I              : SmallInt;
  InvR           : InvRec;
  IDR            : IDetail;
  KeyS           : Str255;




begin
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    GotAnal := False; GotEmp := False; GotTerms := False;
    // Get a local copy of the transaction header
    TransHed := (FTransaction As TTransaction).TH;

    // Calculate Document Type
    DocType := TKDocTypeToEntDocType (TransHed.TransDocHed);

    With FBtrIntf^ Do Begin
      // Get Employee
      If (Trim(FTL.AnalCode) <> '') Then Begin
        // Get JobAnalysis Record
        SaveExLocalPosFile (JMiscF, siPos);
        GotAnal := LGetMainRec(JMiscF, PartCCKey(JARCode, JAACode) + LJVar(FTL.AnalCode,AnalKeyLen));
        If GotAnal Then AnalR := LJobMisc^.JobAnalRec;
        RestoreExLocalPos (siPos);
      End; { If (Trim(TransHed.EmpCode) <> '') }

      // Get Employee
      If (Trim(TransHed.CISEmpl) <> '') Then Begin
        // Get Employee Record
        SaveExLocalPosFile (JMiscF, siPos);
        GotEmp := LGetMainRec(JMiscF, PartCCKey(JARCode, JAECode) + LJVar(TransHed.CISEmpl,6));
        If GotEmp Then EmpR := LJobMisc^.EmplRec;
        RestoreExLocalPos (siPos);
      End; { If (Trim(TransHed.EmpCode) <> '') }

      If (Trim(TransHed.thDeliveryNoteRef) <> '') and (Get_tlSOPAbsLineNo <> 0) then
      begin
        SaveExLocalPosFile (InvF, siPos);
        KeyS := TransHed.thDeliveryNoteRef;
        GotTerms := LFind_Rec(B_GetEq, InvF, InvOurRefK, KeyS) = 0;
  //      GotTerms := LGetMainRec(InvF, LJVar(TransHed.thDeliveryNoteRef, 10));
        If GotTerms Then InvR := LInv;
        RestoreExLocalPos (siPos);
        if GotTerms then
        begin
          SaveExLocalPosFile (IDetailF, siPos);
          KeyS := FullIdKey(InvR.FolioNum, Get_tlSOPAbsLineNo);
          GotTerms := LFind_Rec(B_GetEq, IDetailF, IdLinkK, KeyS) = 0;
          if GotTerms then IdR := LId;
          RestoreExLocalPos (siPos);
        end;
      end;

      if GotAnal then
      begin
        FTL.DocLTLink := AnalR.JLinkLT;
        FTL.tlDeductType := AnalR.JADedComp;
        FTL.KitLink := AnalR.JADedApply;
        FTL.tlCOSNomCode := AnalR.JARetType;
        FTL.SSDSPUnit := AnalR.JARetExp;
        FTL.tlOldSerialQty := AnalR.JARetExpInt;
        FTL.tlUseCase := AnalR.JACalcB4Ret;
        FTL.Desc := AnalR.JAnalName;

        if AnalR.JADetType = 0 then
        begin

          if FTL.LineNo = -2 then
            FTL.Discount := AnalR.JADeduct
          else
          if FTL.LineNo = -3 then
            FTL.Discount := AnalR.JARetValue;

          FTL.DiscountChr := '%';
        end
        else
        begin
          FTL.NetValue := AnalR.JADeduct;
          FTL.DiscountChr := #0;
        end;


      end;

      if GotTerms then
      begin
        FTL.Qty := IdR.Qty;
        FTL.JobCode := IdR.JobCode;
        FTL.AnalCode := IdR.AnalCode;
        FTL.DocLTLink := IdR.DocLTLink;
        if IdR.LineNo < 0 then
          FTL.LineNo := IdR.LineNo;
        FTL.Reconcile := IdR.Reconcile;
        FTL.Desc := IdR.Desc;

        FTL.VATCode := IdR.VATCode;
        FTL.KitLink := IdR.KitLink;
        FTL.tlDeductType := IdR.JAPDedType;
        FTL.Discount := IdR.Discount;
        FTL.DiscountChr := IdR.DiscountChr;

        FTL.SSDSPUnit := IdR.SSDSPUnit;
        FTL.tlCOSNomCode := IdR.COSNomCode;
        FTL.tlUseCase := IdR.ShowCase;

        FTL.tlPriceByPack := IdR.PrxPack;

        FTL.tlLiveUplift := IdR.LiveUplift;

        FTL.CC := IdR.CCDep[True];
        FTL.Dep := IdR.CCDep[False];

  //      if FTL.LineNo > 0 then
        begin
          FTL.QtyDel := IDR.QtyDel;
          FTL.QtyPWoff := IdR.QtyPWoff;
          FTL.SSDUplift := IdR.SSDUplift;
        end;
      end;


    End; { With FBtrIntf^ }
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;

procedure TTransactionLine2.CalcVATAmount;
Var
  Res  : SmallInt;
  TmpVal : Double;
Begin { CalcVATAmount }
  TmpVal := 0;
  if OkToUpdate then
  begin
    if FTL.LineNo > 0 then
    begin
      TmpVal := FTL.NetValue;
      FTL.NetValue := FTL.CostPrice;
    end;
    Res := Ex_CalcLineTax(@FTL, SizeOf(FTL), (FTransaction As TTransaction).TH.DiscSetl);
    if FTL.LineNo > 0 then
      FTL.NetValue := TmpVal;
    If (Res <> 0) Then
      Raise Exception.Create ('ITransactionLine.CalcVATAmount Error ' + IntToStr(Res));
  end
  else
    Raise EInvalidMethod.Create ('The ITransactionLine.CalcVatAmount method is not available');
End; { CalcVATAmount }

function TTransactionLine2.ValidJobCode(const JCode : string) : Boolean;

  function FindJobInContract(const oJob : IJob; const JC : string; const Contract : string) : Boolean;
  var
    Res, JPos : LongInt;
    OldIdx : Integer;
  begin
    oJob.SavePosition;
    JPos := oJob.Position;
    OldIdx := oJob.Index;
    oJob.Index := jrIdxCode;
    Res := oJob.GetEqual(oJob.BuildCodeIndex(JC));

    if Res = 0 then
    begin
      if Trim(oJob.jrParent) = '' then
        Result := False
      else
      if Trim(Contract) = Trim(oJob.jrParent) then
        Result := True
      else
        Result := FindJobInContract(oJob, oJob.jrParent, Contract);

    end
    else
      Result :=  False;


    oJob.Index := OldIdx;
    oJob.Position := JPos;
    oJob.RestorePosition;
  end;

begin
  Result := JCode = TTransaction(FTransaction).TH.DJobCode;

  if not Result then
    Result := FindJobInContract(TToolkit(FToolkit).JobCostingI.Job, JCode, TTransaction(FTransaction).TH.DJobCode);
end;

procedure TTransactionLine2.Set_tlJobCode(const Value: WideString);
begin
  FTL.InvalidJobCode := not ValidJobCode(Value);
  FTL.JobCode := Value;
end;





function TTransactionLine.Get_tlAsReturn: ITransactionLineAsReturn;
var
  OK : Boolean;
begin
  with  FTransaction as TTransaction do
    OK := Copy(TH.TransDocHed, 2, 2) = 'RN';

  if not Assigned(FLineAsReturnO) and OK then
  begin
    FLineAsReturnO := TTransactionLineAsReturn.Create(Self, FToolkit as TToolkit, ITransactionLineAsReturn, FIntfType, @FTL);

    FLineAsReturnI := FLineAsReturnO;
  end;

  Result := FLineAsReturnI

end;

function TTransactionLine.CreateReturn: ITransactionLineReturnCreate;
var
  oReturnCreate : TReturnCreateFromLine;
begin
  AuthoriseFunction(202, 'CreateReturn',1);

  oReturnCreate := TReturnCreateFromLine.Create(Self, TToolkit(FToolkit));

  oReturnCreate.Toolkit := TToolkit(FToolkit);

  Result := oReturnCreate;

end;

function TTransactionLine.Get_tlBinReturnQty: Double;
begin
  Result := FTL.BinRetQty
end;

function TTransactionLine.Get_tlSerialReturnQty: Double;
begin
  Result := FTL.SerialRetQty
end;

function TTransactionLine.GetData: WideString;
begin
  SetLength(Result, SizeOf(FTL));
  Move(FTL, Result[1], SizeOf(FTL));
end;

function TTransactionLine.ConvertData(const DataRec: WideString): WideString;
var
  LocalTL : TBatchTLRec;
begin
  Move(DataRec[1], LocalTL, SizeOf(LocalTL));
  if ExInvLineToId(LocalTL, B_CopyOnly) = 0 then
  begin
    SetLength(Result, SizeOf(ID));
    Move(ID, Result[1], SizeOf(ID));
  end
  else
    Result := '';
end;

procedure TTransactionLine.Set_tlAbsLineNo(Value: Integer);
begin
  FTL.ABSLineNo := Value;
  FTL.BDMode := 1;
end;

procedure TTransactionLine.Set_tlB2BLineNo(Value: Integer);
begin
  FTL.tlB2BLineNo := Value;
  FTL.BDMode := 1;
end;

procedure TTransactionLine.Set_tlB2BLinkFolio(Value: Integer);
begin
  FTL.tlB2BLinkFolio := Value;
  FTL.BDMode := 1;
end;

procedure TTransactionLine.Set_tlBinQty(Value: Double);
begin
  FTL.BinQty := Value;
  FTL.BDMode := 1;
end;

procedure TTransactionLine.Set_tlCOSDailyRate(Value: Double);
begin
  FTL.tlCOSDailyRate := Value;
  FTL.BDMode := 1;
end;

procedure TTransactionLine.Set_tlQtyPack(Value: Double);
begin
  FTL.tlQtyPack := Value;
  FTL.BDMode := 1;
end;

procedure TTransactionLine.Set_tlReconciliationDate(
  const Value: WideString);
begin
  FTL.tlReconciliationDate := Value;
  FTL.BDMode := 1;
end;

procedure TTransactionLine.Set_tlStockDeductQty(Value: Double);
begin
  FTL.tlStockDeductQty := Value;
  FTL.BDMode := 1;
end;

procedure TTransactionLine.Set_tlUseQtyMul(Value: WordBool);
begin
  FTL.tlUseQtyMul := Value;
  FTL.BDMode := 1;
end;

procedure TTransactionLine.Set_tlNominalMode(Value: Integer);
begin
  FTL.NomMode := Value;
  FTL.BDMode := 1;
end;

function TTransactionLine.Get_tlMultiBuyDiscount: Double;
begin
  Result := FTL.tlMultiBuyDiscount;
end;

function TTransactionLine.Get_tlMultiBuyDiscountFlag: WideString;
begin
  Result := FTL.tlMultiBuyDiscountChr;
end;

function TTransactionLine.Get_tlMultiBuyDiscounts: IMultiBuyDiscounts;
begin
  if Assigned(FMultiBuyO) then
    Result := FMultiBuyI
  else
    raise Exception.Create('The tlMultiBuyDiscounts property is not available on this line.');
end;

function TTransactionLine.Get_tlTotals(Index: TTransLineTotalsType): Double;
var
  Res : Integer;
  LineTotal, TotalWithDisc : Double;
begin
  Case Index of
    LineTotNet              : Result := entLineTotal(True, 0);
    LineTotGross            : Result := entLineTotal(False, 0);
    LineTotTotalDiscounts   : begin
                                Res := EX_GETLINETOTAL(@TL, SizeOf(TL), False, 0.0, LineTotal);
                                Res := EX_GETLINETOTAL(@TL, SizeOf(TL), True, 0.0, TotalWithDisc);
                                Result := LineTotal - TotalWithDisc;
                              end;
    LineTotTotalCost        : Result := Round_Up(FTL.CostPrice * FTL.Qty, 2);
    LineTotMultiBuyDiscount : begin
                                if FTL.tlMultiBuyDiscountChr <> '%' then
                                  Result := FTL.tlMultiBuyDiscount * FTL.Qty
                                else
                                  Result := CalcDiscountTotal(dtMultiBuy);
                              end;
    LineTotTransDiscount    : begin
                                if FTL.tlTransValueDiscountChr <> '%' then
                                  Result := FTL.tlTransValueDiscount * FTL.Qty
                                else
                                  Result := CalcDiscountTotal(dtTrans);
                              end;
  end; //Case
end;

function TTransactionLine.Get_tlTransValueDiscount: Double;
begin
  Result := FTL.tlTransValueDiscount;
end;

function TTransactionLine.Get_tlTransValueDiscountFlag: WideString;
begin
  Result := FTL.tlTransValueDiscountChr;
end;

function TTransactionLine.Get_tlTransValueDiscountType: TTransValueDiscountType;
begin
  Result := FTL.tlTransValueDiscountType;
end;


procedure TTransactionLine.SetMultiBuyDiscounts;
var
  Disc2Value : Double;
  Disc2Char : Char;
begin
  if Assigned(FMultiBuyO) and (FMultiBuyO.List.Count > 0) then
  with TMultiBuyFunctions.Create do
  Try
    GetUnitDiscountValue(FMultiBuyO.List, FTL, Disc2Value, Disc2Char);
    FTL.tlMultiBuyDiscount := Disc2Value;
    FTL.tlMultiBuyDiscountChr := Disc2Char;
    FTL.tlMBDList := FMultiBuyO.List;
  Finally
    Free;
  End;
end;

function TTransactionLine.CalcDiscountTotal(WhichDiscount: TDiscountType) : Double;
var
  DiscVal, NetVal : Double;
begin
  Result := 0;
  //Discounts are applied in order Standard, MultiBuy, TransactionValue
  NetVal := FTL.NetValue - Calc_PAmount(FTL.NetValue, FTL.Discount, FTL.DiscountChr);
  DiscVal := Calc_PAmount(NetVal, FTL.tlMultiBuyDiscount, FTL.tlMultiBuyDiscountChr);
  if WhichDiscount = dtStandard then
    Result := (FTL.NetValue - NetVal) * FTL.Qty
  else
  if WhichDiscount = dtMultiBuy then
    Result := DiscVal * FTL.Qty
  else
  if WhichDiscount = dtTrans then
  begin
    NetVal := NetVal - DiscVal;
    DiscVal := Calc_PAmount(NetVal, FTL.tlTransValueDiscount, FTL.tlTransValueDiscountChr);
    Result := DiscVal * FTL.Qty;
  end;
end;

procedure TTransactionLine.Set_tlMultiBuyDiscount(Value: Double);
begin
  if OkToUpdate then
    FTL.tlMultiBuyDiscount := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

procedure TTransactionLine.Set_tlMultiBuyDiscountFlag(
  const Value: WideString);
begin
  if OkToUpdate then
    FTL.tlMultiBuyDiscountChr := ExtractChar(Value, ' ')
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

procedure TTransactionLine.Set_tlTransValueDiscount(Value: Double);
begin
  if OkToUpdate then
    FTL.tlTransValueDiscount := Value
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

procedure TTransactionLine.Set_tlTransValueDiscountFlag(const Value: WideString);
begin
  if OkToUpdate then
    FTL.tlTransValueDiscountChr := ExtractChar(Value, ' ')
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

procedure TTransactionLine.Set_tlTransValueDiscountType(
  Value: TTransValueDiscountType);
begin
  if OkToUpdate then
  begin
    if Value in [tvdNA..tvdValueBased, tvdDescription] then
      FTL.tlTransValueDiscountType := Value
    else
      raise ERangeError.Create('Value out of range ' + IntToStr(Value));
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

function TTransactionLine.Get_tlECPurchaseServiceTax: Double;
begin
  Result := FTL.tlECPurchaseServiceTax;
end;

function TTransactionLine.Get_tlECService: WordBool;
begin
  Result := FTL.tlECService;
end;

function TTransactionLine.Get_tlECServiceEndDate: WideString;
begin
  Result := FTL.tlECServiceEndDate;
end;

function TTransactionLine.Get_tlECServiceStartDate: WideString;
begin
  Result := FTL.tlECServiceStartDate;
end;

function TTransactionLine.Get_tlECSalesTaxReported: Double;
begin
  Result := FTL.tlECSalesTaxReported;
end;

procedure TTransactionLine.Set_tlECService(Value: WordBool);
begin
  FTL.tlECService := Value;
end;

procedure TTransactionLine.Set_tlECServiceEndDate(const Value: WideString);
begin
  FTL.tlECServiceEndDate := Value;
end;

procedure TTransactionLine.Set_tlECServiceStartDate(
  const Value: WideString);
begin
  FTL.tlECServiceStartDate := Value;
end;

procedure TTransactionLine.LinkToSOR(const SORLine: ITransactionLine);
begin
  //PR: 06/10/2009 LinkToSOR got lost between 6SQL and 6.01
  AuthoriseFunction(203, 'LinkToSOR');
  if ITransactionLine2(SORLine).tlDocType <> dtSOR then
    raise Exception.Create('Link to document must be a SOR');
  Set_tlB2BLineNo(SORLine.tlAbsLineNo);
  Set_tlB2BLinkFolio(SORLine.tlFolioNum);
  Set_tlAbsLineNo(SORLine.tlAbsLineNo);
  //PR: 8/4/2009 Need to set LineNo otherwise adding a new line to trans can lead to duplicate abslinenos
  FTL.LineNo := SorLine.tlLineNo;
end;


function TTransactionLine.Get_tlFromPostCode: WideString;
begin
  Result := FTL.tlFromPostCode;
end;

function TTransactionLine.Get_tlReceiptNo: WideString;
begin
  Result := FTL.tlReceiptNo;
end;

function TTransactionLine.Get_tlReference: WideString;
begin
  Result := FTL.tlReference;
end;

function TTransactionLine.Get_tlToPostCode: WideString;
begin
  Result := FTL.tlToPostCode;
end;

procedure TTransactionLine.Set_tlFromPostCode(const Value: WideString);
begin
  FTL.tlFromPostCode := Value;
end;

procedure TTransactionLine.Set_tlReceiptNo(const Value: WideString);
begin
  FTL.tlReceiptNo := Value;
end;

procedure TTransactionLine.Set_tlReference(const Value: WideString);
begin
  FTL.tlReference := Value;
end;

procedure TTransactionLine.Set_tlToPostCode(const Value: WideString);
begin
  FTL.tlToPostCode := Value;
end;

procedure TTransactionLine.UpdateAccountStockAnalysis;
begin
  AuthoriseFunction(204, 'UpdateAccountStockAnalysis');
  with FThLines as TTransactionLines do
    EX_UPDATEACSTOCKANAL(LoadedFolio, Get_tlAbsLineNo);
end;

function TTransactionLine.Get_tlUserField10: WideString;
begin
  Result := FTL.LineUser10;
end;

function TTransactionLine.Get_tlUserField5: WideString;
begin
  Result := FTL.LineUser5;
end;

function TTransactionLine.Get_tlUserField6: WideString;
begin
  Result := FTL.LineUser6;
end;

function TTransactionLine.Get_tlUserField7: WideString;
begin
  Result := FTL.LineUser7;
end;

function TTransactionLine.Get_tlUserField8: WideString;
begin
  Result := FTL.LineUser8;
end;

function TTransactionLine.Get_tlUserField9: WideString;
begin
  Result := FTL.LineUser9;
end;

function TTransactionLine.Get_tlThresholdCode: WideString;
begin
  Result := FTL.tlThresholdCode;
end;

procedure TTransactionLine.Set_tlThresholdCode(const Value: WideString); safecall;
begin
  if OkToUpdate then
  begin
    FTL.tlThresholdCode := Value;
    FDetailsChanged := True;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

procedure TTransactionLine.Set_tlUserField10(const Value: WideString);
begin
  if OkToUpdate(True) then
  begin
    FTL.LineUser10 := Value;
    FDetailsChanged := True;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

procedure TTransactionLine.Set_tlUserField5(const Value: WideString);
begin
  if OkToUpdate(True) then
  begin
    FTL.LineUser5 := Value;
    FDetailsChanged := True;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

procedure TTransactionLine.Set_tlUserField6(const Value: WideString);
begin
  if OkToUpdate(True) then
  begin
    FTL.LineUser6 := Value;
    FDetailsChanged := True;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

procedure TTransactionLine.Set_tlUserField7(const Value: WideString);
begin
  if OkToUpdate(True) then
  begin
    FTL.LineUser7 := Value;
    FDetailsChanged := True;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

procedure TTransactionLine.Set_tlUserField8(const Value: WideString);
begin
  if OkToUpdate(True) then
  begin
    FTL.LineUser8 := Value;
    FDetailsChanged := True;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

procedure TTransactionLine.Set_tlUserField9(const Value: WideString);
begin
  if OkToUpdate(True) then
  begin
    FTL.LineUser9 := Value;
    FDetailsChanged := True;
  end
  else
    raise EInvalidUpdate.Create(UpdateEx2Msg);
end;

function TTransactionLine.Get_tlIntrastatNoTC: WideString;
begin
  Result := FTL.tlIntrastatNoTC;
end;

procedure TTransactionLine.Set_tlIntrastatNoTC(const Value: WideString);
begin
  FTL.tlIntrastatNoTC := Value;
end;

//PR: 13/02/2016 ABSEXCH-ABSEXCH-18191 v2017 R1 ITransaction11
function TTransactionLine.UpdateReconcileFlag(NewValue: TReconcileFlagValue): Integer;
var
  RecAddress : Integer;
begin
  AuthoriseFunction(205, 'UpdateReconcileFlag');

  //Check for valid value
  if (NewValue >= rfNotCleared) or (NewValue <= rfReturned) then
  begin
    //Find record address
    RecAddress := GetRecordAddress;
    if RecAddress > 0 then
    begin
      Result := EX_UPDATERECONCILEFLAG(RecAddress, NewValue);
    end
    else
      Result := 32004; //Record address not found
  end
  else
    Result := 30000; //Invalid value
end;

//Find the record address of the current line
function TTransactionLine.GetRecordAddress: Integer;
var
  KeyS : Str255;
  Res : Integer;
begin
  Result := 0;
  KeyS := FullNomKey(Get_tlFolioNum) + FullNomKey(Get_tlAbsLineNo);
  Res:= FBtrIntf^.LFind_Rec(B_GetEQ, IDetailF, IdLinkK, KeyS);
  if Res = 0 then
  begin
    Res := FBtrIntf^.LGetPos(IDetailF, Result);
    if Res <> 0 then
      Result := 0;
  end;
end;

end.
