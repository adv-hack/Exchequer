unit dmMainDaybk2;

interface

uses
  SysUtils, Classes, SQLCallerU, DB, ADODB, SQLUtils, GlobVar, Dialogs, Varconst,
  Btrvu2, BtKeys1U;

const
  NonDocTypeForPurch = 22;
  NonDocTypeForSales = 7;
type
  TModuleType = (
                  mtNone = 0,
                  mtSales = 1,
                  mtPurchase = 2
                );

  TMainDataModule = class(TDataModule)
    connMain: TADOConnection;
    qryDaybkFetchData: TADOQuery;
    qryDaybkFetchDatathRunNo: TIntegerField;
    qryDaybkFetchDatathAcCode: TStringField;
    qryDaybkFetchDatathNomAuto: TBooleanField;
    qryDaybkFetchDatathOurRef: TStringField;
    qryDaybkFetchDatathFolioNum: TIntegerField;
    qryDaybkFetchDatathCurrency: TIntegerField;
    qryDaybkFetchDatathYear: TIntegerField;
    qryDaybkFetchDatathPeriod: TIntegerField;
    qryDaybkFetchDatathDueDate: TStringField;
    qryDaybkFetchDatathVATPostDate: TStringField;
    qryDaybkFetchDatathTransDate: TStringField;
    qryDaybkFetchDatathCustSupp: TStringField;
    qryDaybkFetchDatathCompanyRate: TFloatField;
    qryDaybkFetchDatathDailyRate: TFloatField;
    qryDaybkFetchDatathOldYourRef: TStringField;
    qryDaybkFetchDatathBatchLink: TVarBytesField;
    qryDaybkFetchDatathOutstanding: TStringField;
    qryDaybkFetchDatathNextLineNumber: TIntegerField;
    qryDaybkFetchDatathNextNotesLineNumber: TIntegerField;
    qryDaybkFetchDatathDocType: TIntegerField;
    qryDaybkFetchDatathVATAnalysisStandard: TFloatField;
    qryDaybkFetchDatathVATAnalysisExempt: TFloatField;
    qryDaybkFetchDatathVATAnalysisZero: TFloatField;
    qryDaybkFetchDatathVATAnalysisRate1: TFloatField;
    qryDaybkFetchDatathVATAnalysisRate2: TFloatField;
    qryDaybkFetchDatathVATAnalysisRate3: TFloatField;
    qryDaybkFetchDatathVATAnalysisRate4: TFloatField;
    qryDaybkFetchDatathVATAnalysisRate5: TFloatField;
    qryDaybkFetchDatathVATAnalysisRate6: TFloatField;
    qryDaybkFetchDatathVATAnalysisRate7: TFloatField;
    qryDaybkFetchDatathVATAnalysisRate8: TFloatField;
    qryDaybkFetchDatathVATAnalysisRate9: TFloatField;
    qryDaybkFetchDatathVATAnalysisRateT: TFloatField;
    qryDaybkFetchDatathVATAnalysisRateX: TFloatField;
    qryDaybkFetchDatathVATAnalysisRateB: TFloatField;
    qryDaybkFetchDatathVATAnalysisRateC: TFloatField;
    qryDaybkFetchDatathVATAnalysisRateF: TFloatField;
    qryDaybkFetchDatathVATAnalysisRateG: TFloatField;
    qryDaybkFetchDatathVATAnalysisRateR: TFloatField;
    qryDaybkFetchDatathVATAnalysisRateW: TFloatField;
    qryDaybkFetchDatathVATAnalysisRateY: TFloatField;
    qryDaybkFetchDatathVATAnalysisRateIAdj: TFloatField;
    qryDaybkFetchDatathVATAnalysisRateOAdj: TFloatField;
    qryDaybkFetchDatathVATAnalysisRateSpare: TFloatField;
    qryDaybkFetchDatathNetValue: TFloatField;
    qryDaybkFetchDatathTotalVAT: TFloatField;
    qryDaybkFetchDatathSettleDiscPerc: TFloatField;
    qryDaybkFetchDatathSettleDiscAmount: TFloatField;
    qryDaybkFetchDatathTotalLineDiscount: TFloatField;
    qryDaybkFetchDatathSettleDiscDays: TIntegerField;
    qryDaybkFetchDatathSettleDiscTaken: TBooleanField;
    qryDaybkFetchDatathAmountSettled: TFloatField;
    qryDaybkFetchDatathAutoIncrement: TIntegerField;
    qryDaybkFetchDatathUntilYear: TIntegerField;
    qryDaybkFetchDatathUntilPeriod: TIntegerField;
    qryDaybkFetchDatathTransportNature: TIntegerField;
    qryDaybkFetchDatathTransportMode: TIntegerField;
    qryDaybkFetchDatathRemitNo: TStringField;
    qryDaybkFetchDatathAutoIncrementType: TStringField;
    qryDaybkFetchDatathHoldFlag: TIntegerField;
    qryDaybkFetchDatathAuditFlag: TBooleanField;
    qryDaybkFetchDatathTotalWeight: TFloatField;
    qryDaybkFetchDatathDeliveryAddr1: TStringField;
    qryDaybkFetchDatathDeliveryAddr2: TStringField;
    qryDaybkFetchDatathDeliveryAddr3: TStringField;
    qryDaybkFetchDatathDeliveryAddr4: TStringField;
    qryDaybkFetchDatathDeliveryAddr5: TStringField;
    qryDaybkFetchDatathVariance: TFloatField;
    qryDaybkFetchDatathTotalOrdered: TFloatField;
    qryDaybkFetchDatathTotalReserved: TFloatField;
    qryDaybkFetchDatathTotalCost: TFloatField;
    qryDaybkFetchDatathTotalInvoiced: TFloatField;
    qryDaybkFetchDatathLongYourRef: TVarBytesField;
    qryDaybkFetchDatathUntilDate: TStringField;
    qryDaybkFetchDatathNOMVATIO: TStringField;
    qryDaybkFetchDatathExternal: TBooleanField;
    qryDaybkFetchDatathPrinted: TBooleanField;
    qryDaybkFetchDatathRevalueAdj: TFloatField;
    qryDaybkFetchDatathCurrSettled: TFloatField;
    qryDaybkFetchDatathSettledVAT: TFloatField;
    qryDaybkFetchDatathVATClaimed: TFloatField;
    qryDaybkFetchDatathBatchGL: TIntegerField;
    qryDaybkFetchDatathAutoPost: TBooleanField;
    qryDaybkFetchDatathManualVAT: TBooleanField;
    qryDaybkFetchDatathDeliveryTerms: TStringField;
    qryDaybkFetchDatathIncludeInPickingRun: TBooleanField;
    qryDaybkFetchDatathOperator: TStringField;
    qryDaybkFetchDatathNoLabels: TIntegerField;
    qryDaybkFetchDatathTagged: TIntegerField;
    qryDaybkFetchDatathPickingRunNo: TIntegerField;
    qryDaybkFetchDatathOrdMatch: TBooleanField;
    qryDaybkFetchDatathDeliveryNoteRef: TStringField;
    qryDaybkFetchDatathVATCompanyRate: TFloatField;
    qryDaybkFetchDatathVATDailyRate: TFloatField;
    qryDaybkFetchDatathOriginalCompanyRate: TFloatField;
    qryDaybkFetchDatathOriginalDailyRate: TFloatField;
    qryDaybkFetchDataPostDiscAm: TFloatField;
    qryDaybkFetchDatathSpareNomCode: TIntegerField;
    qryDaybkFetchDatathPostDiscTaken: TBooleanField;
    qryDaybkFetchDatathControlGL: TIntegerField;
    qryDaybkFetchDatathJobCode: TStringField;
    qryDaybkFetchDatathAnalysisCode: TStringField;
    qryDaybkFetchDatathTotalOrderOS: TFloatField;
    qryDaybkFetchDatathAppDepartment: TStringField;
    qryDaybkFetchDatathAppCostCentre: TStringField;
    qryDaybkFetchDatathUserField1: TStringField;
    qryDaybkFetchDatathUserField2: TStringField;
    qryDaybkFetchDatathLineTypeAnalysis1: TFloatField;
    qryDaybkFetchDatathLineTypeAnalysis2: TFloatField;
    qryDaybkFetchDatathLineTypeAnalysis3: TFloatField;
    qryDaybkFetchDatathLineTypeAnalysis4: TFloatField;
    qryDaybkFetchDatathLineTypeAnalysis5: TFloatField;
    qryDaybkFetchDatathLineTypeAnalysis6: TFloatField;
    qryDaybkFetchDatathLastDebtChaseLetter: TIntegerField;
    qryDaybkFetchDatathBatchNow: TFloatField;
    qryDaybkFetchDatathBatchThen: TFloatField;
    qryDaybkFetchDatathUnTagged: TBooleanField;
    qryDaybkFetchDatathOriginalBaseValue: TFloatField;
    qryDaybkFetchDatathUseOriginalRates: TIntegerField;
    qryDaybkFetchDatathOldCompanyRate: TFloatField;
    qryDaybkFetchDatathOldDailyRate: TFloatField;
    qryDaybkFetchDatathFixedRate: TBooleanField;
    qryDaybkFetchDatathUserField3: TStringField;
    qryDaybkFetchDatathUserField4: TStringField;
    qryDaybkFetchDatathProcess: TStringField;
    qryDaybkFetchDatathSource: TIntegerField;
    qryDaybkFetchDatathCurrencyTriRate: TFloatField;
    qryDaybkFetchDatathCurrencyTriEuro: TIntegerField;
    qryDaybkFetchDatathCurrencyTriInvert: TBooleanField;
    qryDaybkFetchDatathCurrencyTriFloat: TBooleanField;
    qryDaybkFetchDatathCurrencyTriSpare: TVarBytesField;
    qryDaybkFetchDatathVATTriRate: TFloatField;
    qryDaybkFetchDatathVATTriEuro: TIntegerField;
    qryDaybkFetchDatathVATTriInvert: TBooleanField;
    qryDaybkFetchDatathVATTriFloat: TBooleanField;
    qryDaybkFetchDatathVATTriSpare: TVarBytesField;
    qryDaybkFetchDatathOriginalTriRate: TFloatField;
    qryDaybkFetchDatathOriginalTriEuro: TIntegerField;
    qryDaybkFetchDatathOriginalTriInvert: TBooleanField;
    qryDaybkFetchDatathOriginalTriFloat: TBooleanField;
    qryDaybkFetchDatathOriginalTriSpare: TVarBytesField;
    qryDaybkFetchDatathOldOriginalTriRate: TFloatField;
    qryDaybkFetchDatathOldOriginalTriEuro: TIntegerField;
    qryDaybkFetchDatathOldOriginalTriInvert: TBooleanField;
    qryDaybkFetchDatathOldOriginalTriFloat: TBooleanField;
    qryDaybkFetchDatathOldOriginalTriSpare: TVarBytesField;
    qryDaybkFetchDatathPostedDate: TStringField;
    qryDaybkFetchDatathPORPickSOR: TBooleanField;
    qryDaybkFetchDatathBatchDiscAmount: TFloatField;
    qryDaybkFetchDatathPrePost: TIntegerField;
    qryDaybkFetchDatathAuthorisedAmnt: TFloatField;
    qryDaybkFetchDatathTimeChanged: TStringField;
    qryDaybkFetchDatathTimeCreated: TStringField;
    qryDaybkFetchDatathCISTaxDue: TFloatField;
    qryDaybkFetchDatathCISTaxDeclared: TFloatField;
    qryDaybkFetchDatathCISManualTax: TBooleanField;
    qryDaybkFetchDatathCISDate: TStringField;
    qryDaybkFetchDatathTotalCostApportioned: TFloatField;
    qryDaybkFetchDatathCISEmployee: TStringField;
    qryDaybkFetchDatathCISTotalGross: TFloatField;
    qryDaybkFetchDatathCISSource: TIntegerField;
    qryDaybkFetchDatathTimesheetExported: TBooleanField;
    qryDaybkFetchDatathCISExcludedFromGross: TFloatField;
    qryDaybkFetchDatathWeekMonth: TIntegerField;
    qryDaybkFetchDatathWorkflowState: TIntegerField;
    qryDaybkFetchDatathOverrideLocation: TStringField;
    qryDaybkFetchDatathSpare5: TVarBytesField;
    qryDaybkFetchDatathYourRef: TStringField;
    qryDaybkFetchDatathUserField5: TStringField;
    qryDaybkFetchDatathUserField6: TStringField;
    qryDaybkFetchDatathUserField7: TStringField;
    qryDaybkFetchDatathUserField8: TStringField;
    qryDaybkFetchDatathUserField9: TStringField;
    qryDaybkFetchDatathUserField10: TStringField;
    qryDaybkFetchDatathDeliveryPostCode: TStringField;
    qryDaybkFetchDatathOriginator: TStringField;
    qryDaybkFetchDatathCreationTime: TStringField;
    qryDaybkFetchDatathCreationDate: TStringField;
    qryDaybkFetchDatathOrderPaymentOrderRef: TStringField;
    qryDaybkFetchDatathOrderPaymentElement: TIntegerField;
    qryDaybkFetchDatathOrderPaymentFlags: TIntegerField;
    qryDaybkFetchDatathCreditCardType: TStringField;
    qryDaybkFetchDatathCreditCardNumber: TStringField;
    qryDaybkFetchDatathCreditCardExpiry: TStringField;
    qryDaybkFetchDatathCreditCardAuthorisationNo: TStringField;
    qryDaybkFetchDatathCreditCardReferenceNo: TStringField;
    qryDaybkFetchDatathCustomData1: TStringField;
    qryDaybkFetchDatathDeliveryCountry: TStringField;
    qryDaybkFetchDatathPPDPercentage: TFloatField;
    qryDaybkFetchDatathPPDDays: TIntegerField;
    qryDaybkFetchDatathPPDGoodsValue: TFloatField;
    qryDaybkFetchDatathPPDVATValue: TFloatField;
    qryDaybkFetchDatathPPDTaken: TIntegerField;
    qryDaybkFetchDatathPPDCreditNote: TBooleanField;
    qryDaybkFetchDatathBatchPayPPDStatus: TIntegerField;
    qryDaybkFetchDatathIntrastatOutOfPeriod: TBooleanField;
    qryDaybkFetchDatathUserField11: TStringField;
    qryDaybkFetchDatathUserField12: TStringField;
    qryDaybkFetchDatathTaxRegion: TIntegerField;
    qryDaybkFetchDatathAnonymised: TBooleanField;
    qryDaybkFetchDatathAnonymisedDate: TStringField;
    qryDaybkFetchDatathAnonymisedTime: TStringField;
    qryDaybkFetchDataPositionId: TAutoIncField;
    qryDaybkFetchDataOurRefPrefix: TStringField;
    qryDaybkFetchDatathAcCodeComputed: TStringField;
    qryDaybkFetchDatathBatchLinkComputed: TVarBytesField;
    qryDaybkFetchDatathLongYourRefComputed: TVarBytesField;
    qryDaybkFetchDatathLongYourRefTrans: TMemoField;
    qryDaybkFetchDatathBatchLinkTrans: TMemoField;
    dsDaybkFetchData: TDataSource;
    procedure DataModuleDestroy(Sender: TObject);
    procedure qryDaybkFetchDataAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
    FModuleType: TModuleType;
  public
    { Public declarations }
    constructor Create(aOwner : TComponent); overload;
    constructor Create(aOwner : TComponent; aModuleType: TModuleType); overload;
  end;

var
  MainDataModule: TMainDataModule;

implementation

{$R *.dfm}

{ TDataModule1 }

constructor TMainDataModule.Create(aOwner : TComponent; aModuleType: TModuleType);
var
  lConnStr: String;
  lRes: Integer;
begin
  inherited Create(aOwner);

  lConnStr := '';
  FModuleType := aModuleType;
  lRes := GetConnectionString(SQLUtils.GetCompanyCode(SetDrive), False, lConnStr);
  if (lRes = 0) then
  begin
    //Initialise main connection
    connMain := TADOConnection.Create(Self);
    connMain.ConnectionString := lConnStr;
    connMain.Connected := True;

    //Initialise query
    qryDaybkFetchData.Connection := connMain;
    qryDaybkFetchData.Prepared := True;
    qryDaybkFetchData.SQL.Text := 'SELECT * FROM ' + SQLUtils.GetCompanyCode(SetDrive) + '.[DOCUMENT] ' +
                                  'WHERE [OurRefPrefix] = :ourrefprefix AND ' +
                                  '[thRunNo] = 0 AND ' +
                                  '(thFolioNum > -2147483647) AND ' +
                                  '(thFolioNum < 2147483647) AND ' +
                                  'thDocType <> :thdoctype';    
    //Now we initialise query with proper where clause
    case FModuleType of
      mtSales :  {SALES SCREEN}
        begin
          qryDaybkFetchData.Parameters.ParamValues['ourrefprefix'] := 'S';
          qryDaybkFetchData.Parameters.ParamValues['thdoctype'] := NonDocTypeForSales;
        end; {mtSales}

      mtPurchase :
        begin    {PURCHASE SCREEN}
          qryDaybkFetchData.Parameters.ParamValues['ourrefprefix'] := 'P';
          qryDaybkFetchData.Parameters.ParamValues['thdoctype'] := NonDocTypeForPurch;
        end; {mtPurchase}
    end; {case}
    qryDaybkFetchData.Open;
  end
  else
    ShowMessage('Could not retrieve ConnectionStr using GetConnectionString fn, Error code=' + IntToStr(lRes));
    
end;

procedure TMainDataModule.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(connMain) then
    FreeAndNil(connMain);
end;

constructor TMainDataModule.Create(aOwner : TComponent);
begin
  inherited Create(aOwner);
end;

procedure TMainDataModule.qryDaybkFetchDataAfterScroll(DataSet: TDataSet);
var
  lKeyS: Str255;
begin
  lKeyS := FullOurRefKey(qryDaybkFetchDatathOurRef.Value);
  Status := Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^, InvOurRefK, lKeyS);
end;

end.
