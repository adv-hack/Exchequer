object MainDataModule: TMainDataModule
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Left = 563
  Top = 246
  Height = 495
  Width = 756
  object connMain: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;User ID=ADM1139ZZZZ01899;Initial Catalog=Exch2018R1;Dat' +
      'a Source=RAHULB-PC'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 56
    Top = 24
  end
  object qryDaybkFetchData: TADOQuery
    Connection = connMain
    CursorType = ctStatic
    Parameters = <>
    Left = 40
    Top = 112
    object qryDaybkFetchDatathRunNo: TIntegerField
      FieldName = 'thRunNo'
      Visible = False
    end
    object qryDaybkFetchDatathAcCode: TStringField
      FieldName = 'thAcCode'
      Size = 10
    end
    object qryDaybkFetchDatathNomAuto: TBooleanField
      FieldName = 'thNomAuto'
      Visible = False
    end
    object qryDaybkFetchDatathOurRef: TStringField
      FieldName = 'thOurRef'
      Size = 10
    end
    object qryDaybkFetchDatathFolioNum: TIntegerField
      FieldName = 'thFolioNum'
      Visible = False
    end
    object qryDaybkFetchDatathCurrency: TIntegerField
      FieldName = 'thCurrency'
    end
    object qryDaybkFetchDatathYear: TIntegerField
      FieldName = 'thYear'
    end
    object qryDaybkFetchDatathPeriod: TIntegerField
      FieldName = 'thPeriod'
    end
    object qryDaybkFetchDatathDueDate: TStringField
      FieldName = 'thDueDate'
      Visible = False
      Size = 8
    end
    object qryDaybkFetchDatathVATPostDate: TStringField
      FieldName = 'thVATPostDate'
      Visible = False
      Size = 8
    end
    object qryDaybkFetchDatathTransDate: TStringField
      FieldName = 'thTransDate'
      Size = 8
    end
    object qryDaybkFetchDatathCustSupp: TStringField
      FieldName = 'thCustSupp'
      Visible = False
      Size = 1
    end
    object qryDaybkFetchDatathCompanyRate: TFloatField
      FieldName = 'thCompanyRate'
    end
    object qryDaybkFetchDatathDailyRate: TFloatField
      FieldName = 'thDailyRate'
      Visible = False
    end
    object qryDaybkFetchDatathOldYourRef: TStringField
      FieldName = 'thOldYourRef'
      Visible = False
      Size = 10
    end
    object qryDaybkFetchDatathBatchLink: TVarBytesField
      FieldName = 'thBatchLink'
      Visible = False
      Size = 13
    end
    object qryDaybkFetchDatathOutstanding: TStringField
      FieldName = 'thOutstanding'
      Size = 1
    end
    object qryDaybkFetchDatathNextLineNumber: TIntegerField
      FieldName = 'thNextLineNumber'
      Visible = False
    end
    object qryDaybkFetchDatathNextNotesLineNumber: TIntegerField
      FieldName = 'thNextNotesLineNumber'
      Visible = False
    end
    object qryDaybkFetchDatathDocType: TIntegerField
      FieldName = 'thDocType'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisStandard: TFloatField
      FieldName = 'thVATAnalysisStandard'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisExempt: TFloatField
      FieldName = 'thVATAnalysisExempt'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisZero: TFloatField
      FieldName = 'thVATAnalysisZero'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRate1: TFloatField
      FieldName = 'thVATAnalysisRate1'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRate2: TFloatField
      FieldName = 'thVATAnalysisRate2'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRate3: TFloatField
      FieldName = 'thVATAnalysisRate3'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRate4: TFloatField
      FieldName = 'thVATAnalysisRate4'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRate5: TFloatField
      FieldName = 'thVATAnalysisRate5'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRate6: TFloatField
      FieldName = 'thVATAnalysisRate6'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRate7: TFloatField
      FieldName = 'thVATAnalysisRate7'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRate8: TFloatField
      FieldName = 'thVATAnalysisRate8'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRate9: TFloatField
      FieldName = 'thVATAnalysisRate9'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRateT: TFloatField
      FieldName = 'thVATAnalysisRateT'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRateX: TFloatField
      FieldName = 'thVATAnalysisRateX'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRateB: TFloatField
      FieldName = 'thVATAnalysisRateB'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRateC: TFloatField
      FieldName = 'thVATAnalysisRateC'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRateF: TFloatField
      FieldName = 'thVATAnalysisRateF'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRateG: TFloatField
      FieldName = 'thVATAnalysisRateG'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRateR: TFloatField
      FieldName = 'thVATAnalysisRateR'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRateW: TFloatField
      FieldName = 'thVATAnalysisRateW'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRateY: TFloatField
      FieldName = 'thVATAnalysisRateY'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRateIAdj: TFloatField
      FieldName = 'thVATAnalysisRateIAdj'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRateOAdj: TFloatField
      FieldName = 'thVATAnalysisRateOAdj'
      Visible = False
    end
    object qryDaybkFetchDatathVATAnalysisRateSpare: TFloatField
      FieldName = 'thVATAnalysisRateSpare'
      Visible = False
    end
    object qryDaybkFetchDatathNetValue: TFloatField
      FieldName = 'thNetValue'
    end
    object qryDaybkFetchDatathTotalVAT: TFloatField
      FieldName = 'thTotalVAT'
    end
    object qryDaybkFetchDatathSettleDiscPerc: TFloatField
      FieldName = 'thSettleDiscPerc'
      Visible = False
    end
    object qryDaybkFetchDatathSettleDiscAmount: TFloatField
      FieldName = 'thSettleDiscAmount'
      Visible = False
    end
    object qryDaybkFetchDatathTotalLineDiscount: TFloatField
      FieldName = 'thTotalLineDiscount'
      Visible = False
    end
    object qryDaybkFetchDatathSettleDiscDays: TIntegerField
      FieldName = 'thSettleDiscDays'
      Visible = False
    end
    object qryDaybkFetchDatathSettleDiscTaken: TBooleanField
      FieldName = 'thSettleDiscTaken'
      Visible = False
    end
    object qryDaybkFetchDatathAmountSettled: TFloatField
      FieldName = 'thAmountSettled'
      Visible = False
    end
    object qryDaybkFetchDatathAutoIncrement: TIntegerField
      FieldName = 'thAutoIncrement'
      Visible = False
    end
    object qryDaybkFetchDatathUntilYear: TIntegerField
      FieldName = 'thUntilYear'
      Visible = False
    end
    object qryDaybkFetchDatathUntilPeriod: TIntegerField
      FieldName = 'thUntilPeriod'
      Visible = False
    end
    object qryDaybkFetchDatathTransportNature: TIntegerField
      FieldName = 'thTransportNature'
      Visible = False
    end
    object qryDaybkFetchDatathTransportMode: TIntegerField
      FieldName = 'thTransportMode'
      Visible = False
    end
    object qryDaybkFetchDatathRemitNo: TStringField
      FieldName = 'thRemitNo'
      Visible = False
      Size = 10
    end
    object qryDaybkFetchDatathAutoIncrementType: TStringField
      FieldName = 'thAutoIncrementType'
      Visible = False
      Size = 1
    end
    object qryDaybkFetchDatathHoldFlag: TIntegerField
      FieldName = 'thHoldFlag'
      Visible = False
    end
    object qryDaybkFetchDatathAuditFlag: TBooleanField
      FieldName = 'thAuditFlag'
      Visible = False
    end
    object qryDaybkFetchDatathTotalWeight: TFloatField
      FieldName = 'thTotalWeight'
      Visible = False
    end
    object qryDaybkFetchDatathDeliveryAddr1: TStringField
      FieldName = 'thDeliveryAddr1'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathDeliveryAddr2: TStringField
      FieldName = 'thDeliveryAddr2'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathDeliveryAddr3: TStringField
      FieldName = 'thDeliveryAddr3'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathDeliveryAddr4: TStringField
      FieldName = 'thDeliveryAddr4'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathDeliveryAddr5: TStringField
      FieldName = 'thDeliveryAddr5'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathVariance: TFloatField
      FieldName = 'thVariance'
      Visible = False
    end
    object qryDaybkFetchDatathTotalOrdered: TFloatField
      FieldName = 'thTotalOrdered'
      Visible = False
    end
    object qryDaybkFetchDatathTotalReserved: TFloatField
      FieldName = 'thTotalReserved'
      Visible = False
    end
    object qryDaybkFetchDatathTotalCost: TFloatField
      FieldName = 'thTotalCost'
      Visible = False
    end
    object qryDaybkFetchDatathTotalInvoiced: TFloatField
      FieldName = 'thTotalInvoiced'
      Visible = False
    end
    object qryDaybkFetchDatathLongYourRef: TVarBytesField
      FieldName = 'thLongYourRef'
      Visible = False
      Size = 21
    end
    object qryDaybkFetchDatathUntilDate: TStringField
      FieldName = 'thUntilDate'
      Visible = False
      Size = 8
    end
    object qryDaybkFetchDatathNOMVATIO: TStringField
      FieldName = 'thNOMVATIO'
      Visible = False
      Size = 1
    end
    object qryDaybkFetchDatathExternal: TBooleanField
      FieldName = 'thExternal'
      Visible = False
    end
    object qryDaybkFetchDatathPrinted: TBooleanField
      FieldName = 'thPrinted'
      Visible = False
    end
    object qryDaybkFetchDatathRevalueAdj: TFloatField
      FieldName = 'thRevalueAdj'
      Visible = False
    end
    object qryDaybkFetchDatathCurrSettled: TFloatField
      FieldName = 'thCurrSettled'
      Visible = False
    end
    object qryDaybkFetchDatathSettledVAT: TFloatField
      FieldName = 'thSettledVAT'
      Visible = False
    end
    object qryDaybkFetchDatathVATClaimed: TFloatField
      FieldName = 'thVATClaimed'
      Visible = False
    end
    object qryDaybkFetchDatathBatchGL: TIntegerField
      FieldName = 'thBatchGL'
      Visible = False
    end
    object qryDaybkFetchDatathAutoPost: TBooleanField
      FieldName = 'thAutoPost'
      Visible = False
    end
    object qryDaybkFetchDatathManualVAT: TBooleanField
      FieldName = 'thManualVAT'
      Visible = False
    end
    object qryDaybkFetchDatathDeliveryTerms: TStringField
      FieldName = 'thDeliveryTerms'
      Visible = False
      Size = 3
    end
    object qryDaybkFetchDatathIncludeInPickingRun: TBooleanField
      FieldName = 'thIncludeInPickingRun'
      Visible = False
    end
    object qryDaybkFetchDatathOperator: TStringField
      FieldName = 'thOperator'
      Size = 10
    end
    object qryDaybkFetchDatathNoLabels: TIntegerField
      FieldName = 'thNoLabels'
      Visible = False
    end
    object qryDaybkFetchDatathTagged: TIntegerField
      FieldName = 'thTagged'
      Visible = False
    end
    object qryDaybkFetchDatathPickingRunNo: TIntegerField
      FieldName = 'thPickingRunNo'
      Visible = False
    end
    object qryDaybkFetchDatathOrdMatch: TBooleanField
      FieldName = 'thOrdMatch'
      Visible = False
    end
    object qryDaybkFetchDatathDeliveryNoteRef: TStringField
      FieldName = 'thDeliveryNoteRef'
      Visible = False
      Size = 10
    end
    object qryDaybkFetchDatathVATCompanyRate: TFloatField
      FieldName = 'thVATCompanyRate'
      Visible = False
    end
    object qryDaybkFetchDatathVATDailyRate: TFloatField
      FieldName = 'thVATDailyRate'
      Visible = False
    end
    object qryDaybkFetchDatathOriginalCompanyRate: TFloatField
      FieldName = 'thOriginalCompanyRate'
      Visible = False
    end
    object qryDaybkFetchDatathOriginalDailyRate: TFloatField
      FieldName = 'thOriginalDailyRate'
      Visible = False
    end
    object qryDaybkFetchDataPostDiscAm: TFloatField
      FieldName = 'PostDiscAm'
      Visible = False
    end
    object qryDaybkFetchDatathSpareNomCode: TIntegerField
      FieldName = 'thSpareNomCode'
      Visible = False
    end
    object qryDaybkFetchDatathPostDiscTaken: TBooleanField
      FieldName = 'thPostDiscTaken'
      Visible = False
    end
    object qryDaybkFetchDatathControlGL: TIntegerField
      FieldName = 'thControlGL'
      Visible = False
    end
    object qryDaybkFetchDatathJobCode: TStringField
      FieldName = 'thJobCode'
      Visible = False
      Size = 10
    end
    object qryDaybkFetchDatathAnalysisCode: TStringField
      FieldName = 'thAnalysisCode'
      Visible = False
      Size = 10
    end
    object qryDaybkFetchDatathTotalOrderOS: TFloatField
      FieldName = 'thTotalOrderOS'
      Visible = False
    end
    object qryDaybkFetchDatathAppDepartment: TStringField
      FieldName = 'thAppDepartment'
      Visible = False
      Size = 3
    end
    object qryDaybkFetchDatathAppCostCentre: TStringField
      FieldName = 'thAppCostCentre'
      Visible = False
      Size = 3
    end
    object qryDaybkFetchDatathUserField1: TStringField
      FieldName = 'thUserField1'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathUserField2: TStringField
      FieldName = 'thUserField2'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathLineTypeAnalysis1: TFloatField
      FieldName = 'thLineTypeAnalysis1'
      Visible = False
    end
    object qryDaybkFetchDatathLineTypeAnalysis2: TFloatField
      FieldName = 'thLineTypeAnalysis2'
      Visible = False
    end
    object qryDaybkFetchDatathLineTypeAnalysis3: TFloatField
      FieldName = 'thLineTypeAnalysis3'
      Visible = False
    end
    object qryDaybkFetchDatathLineTypeAnalysis4: TFloatField
      FieldName = 'thLineTypeAnalysis4'
      Visible = False
    end
    object qryDaybkFetchDatathLineTypeAnalysis5: TFloatField
      FieldName = 'thLineTypeAnalysis5'
      Visible = False
    end
    object qryDaybkFetchDatathLineTypeAnalysis6: TFloatField
      FieldName = 'thLineTypeAnalysis6'
      Visible = False
    end
    object qryDaybkFetchDatathLastDebtChaseLetter: TIntegerField
      FieldName = 'thLastDebtChaseLetter'
      Visible = False
    end
    object qryDaybkFetchDatathBatchNow: TFloatField
      FieldName = 'thBatchNow'
      Visible = False
    end
    object qryDaybkFetchDatathBatchThen: TFloatField
      FieldName = 'thBatchThen'
      Visible = False
    end
    object qryDaybkFetchDatathUnTagged: TBooleanField
      FieldName = 'thUnTagged'
      Visible = False
    end
    object qryDaybkFetchDatathOriginalBaseValue: TFloatField
      FieldName = 'thOriginalBaseValue'
      Visible = False
    end
    object qryDaybkFetchDatathUseOriginalRates: TIntegerField
      FieldName = 'thUseOriginalRates'
      Visible = False
    end
    object qryDaybkFetchDatathOldCompanyRate: TFloatField
      FieldName = 'thOldCompanyRate'
      Visible = False
    end
    object qryDaybkFetchDatathOldDailyRate: TFloatField
      FieldName = 'thOldDailyRate'
      Visible = False
    end
    object qryDaybkFetchDatathFixedRate: TBooleanField
      FieldName = 'thFixedRate'
      Visible = False
    end
    object qryDaybkFetchDatathUserField3: TStringField
      FieldName = 'thUserField3'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathUserField4: TStringField
      FieldName = 'thUserField4'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathProcess: TStringField
      FieldName = 'thProcess'
      Visible = False
      Size = 1
    end
    object qryDaybkFetchDatathSource: TIntegerField
      FieldName = 'thSource'
      Visible = False
    end
    object qryDaybkFetchDatathCurrencyTriRate: TFloatField
      FieldName = 'thCurrencyTriRate'
      Visible = False
    end
    object qryDaybkFetchDatathCurrencyTriEuro: TIntegerField
      FieldName = 'thCurrencyTriEuro'
      Visible = False
    end
    object qryDaybkFetchDatathCurrencyTriInvert: TBooleanField
      FieldName = 'thCurrencyTriInvert'
      Visible = False
    end
    object qryDaybkFetchDatathCurrencyTriFloat: TBooleanField
      FieldName = 'thCurrencyTriFloat'
      Visible = False
    end
    object qryDaybkFetchDatathCurrencyTriSpare: TVarBytesField
      FieldName = 'thCurrencyTriSpare'
      Visible = False
      Size = 10
    end
    object qryDaybkFetchDatathVATTriRate: TFloatField
      FieldName = 'thVATTriRate'
      Visible = False
    end
    object qryDaybkFetchDatathVATTriEuro: TIntegerField
      FieldName = 'thVATTriEuro'
      Visible = False
    end
    object qryDaybkFetchDatathVATTriInvert: TBooleanField
      FieldName = 'thVATTriInvert'
      Visible = False
    end
    object qryDaybkFetchDatathVATTriFloat: TBooleanField
      FieldName = 'thVATTriFloat'
      Visible = False
    end
    object qryDaybkFetchDatathVATTriSpare: TVarBytesField
      FieldName = 'thVATTriSpare'
      Visible = False
      Size = 10
    end
    object qryDaybkFetchDatathOriginalTriRate: TFloatField
      FieldName = 'thOriginalTriRate'
      Visible = False
    end
    object qryDaybkFetchDatathOriginalTriEuro: TIntegerField
      FieldName = 'thOriginalTriEuro'
      Visible = False
    end
    object qryDaybkFetchDatathOriginalTriInvert: TBooleanField
      FieldName = 'thOriginalTriInvert'
      Visible = False
    end
    object qryDaybkFetchDatathOriginalTriFloat: TBooleanField
      FieldName = 'thOriginalTriFloat'
      Visible = False
    end
    object qryDaybkFetchDatathOriginalTriSpare: TVarBytesField
      FieldName = 'thOriginalTriSpare'
      Visible = False
      Size = 10
    end
    object qryDaybkFetchDatathOldOriginalTriRate: TFloatField
      FieldName = 'thOldOriginalTriRate'
      Visible = False
    end
    object qryDaybkFetchDatathOldOriginalTriEuro: TIntegerField
      FieldName = 'thOldOriginalTriEuro'
      Visible = False
    end
    object qryDaybkFetchDatathOldOriginalTriInvert: TBooleanField
      FieldName = 'thOldOriginalTriInvert'
      Visible = False
    end
    object qryDaybkFetchDatathOldOriginalTriFloat: TBooleanField
      FieldName = 'thOldOriginalTriFloat'
      Visible = False
    end
    object qryDaybkFetchDatathOldOriginalTriSpare: TVarBytesField
      FieldName = 'thOldOriginalTriSpare'
      Visible = False
      Size = 10
    end
    object qryDaybkFetchDatathPostedDate: TStringField
      FieldName = 'thPostedDate'
      Visible = False
      Size = 8
    end
    object qryDaybkFetchDatathPORPickSOR: TBooleanField
      FieldName = 'thPORPickSOR'
      Visible = False
    end
    object qryDaybkFetchDatathBatchDiscAmount: TFloatField
      FieldName = 'thBatchDiscAmount'
      Visible = False
    end
    object qryDaybkFetchDatathPrePost: TIntegerField
      FieldName = 'thPrePost'
      Visible = False
    end
    object qryDaybkFetchDatathAuthorisedAmnt: TFloatField
      FieldName = 'thAuthorisedAmnt'
      Visible = False
    end
    object qryDaybkFetchDatathTimeChanged: TStringField
      FieldName = 'thTimeChanged'
      Visible = False
      Size = 6
    end
    object qryDaybkFetchDatathTimeCreated: TStringField
      FieldName = 'thTimeCreated'
      Visible = False
      Size = 6
    end
    object qryDaybkFetchDatathCISTaxDue: TFloatField
      FieldName = 'thCISTaxDue'
      Visible = False
    end
    object qryDaybkFetchDatathCISTaxDeclared: TFloatField
      FieldName = 'thCISTaxDeclared'
      Visible = False
    end
    object qryDaybkFetchDatathCISManualTax: TBooleanField
      FieldName = 'thCISManualTax'
      Visible = False
    end
    object qryDaybkFetchDatathCISDate: TStringField
      FieldName = 'thCISDate'
      Visible = False
      Size = 8
    end
    object qryDaybkFetchDatathTotalCostApportioned: TFloatField
      FieldName = 'thTotalCostApportioned'
      Visible = False
    end
    object qryDaybkFetchDatathCISEmployee: TStringField
      FieldName = 'thCISEmployee'
      Visible = False
      Size = 10
    end
    object qryDaybkFetchDatathCISTotalGross: TFloatField
      FieldName = 'thCISTotalGross'
      Visible = False
    end
    object qryDaybkFetchDatathCISSource: TIntegerField
      FieldName = 'thCISSource'
      Visible = False
    end
    object qryDaybkFetchDatathTimesheetExported: TBooleanField
      FieldName = 'thTimesheetExported'
      Visible = False
    end
    object qryDaybkFetchDatathCISExcludedFromGross: TFloatField
      FieldName = 'thCISExcludedFromGross'
      Visible = False
    end
    object qryDaybkFetchDatathWeekMonth: TIntegerField
      FieldName = 'thWeekMonth'
      Visible = False
    end
    object qryDaybkFetchDatathWorkflowState: TIntegerField
      FieldName = 'thWorkflowState'
      Visible = False
    end
    object qryDaybkFetchDatathOverrideLocation: TStringField
      FieldName = 'thOverrideLocation'
      Visible = False
      Size = 3
    end
    object qryDaybkFetchDatathSpare5: TVarBytesField
      FieldName = 'thSpare5'
      Visible = False
      Size = 54
    end
    object qryDaybkFetchDatathYourRef: TStringField
      FieldName = 'thYourRef'
    end
    object qryDaybkFetchDatathUserField5: TStringField
      FieldName = 'thUserField5'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathUserField6: TStringField
      FieldName = 'thUserField6'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathUserField7: TStringField
      FieldName = 'thUserField7'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathUserField8: TStringField
      FieldName = 'thUserField8'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathUserField9: TStringField
      FieldName = 'thUserField9'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathUserField10: TStringField
      FieldName = 'thUserField10'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathDeliveryPostCode: TStringField
      FieldName = 'thDeliveryPostCode'
      Visible = False
    end
    object qryDaybkFetchDatathOriginator: TStringField
      FieldName = 'thOriginator'
      Visible = False
      Size = 36
    end
    object qryDaybkFetchDatathCreationTime: TStringField
      FieldName = 'thCreationTime'
      Visible = False
      Size = 6
    end
    object qryDaybkFetchDatathCreationDate: TStringField
      FieldName = 'thCreationDate'
      Visible = False
      Size = 8
    end
    object qryDaybkFetchDatathOrderPaymentOrderRef: TStringField
      FieldName = 'thOrderPaymentOrderRef'
      Visible = False
      Size = 10
    end
    object qryDaybkFetchDatathOrderPaymentElement: TIntegerField
      FieldName = 'thOrderPaymentElement'
      Visible = False
    end
    object qryDaybkFetchDatathOrderPaymentFlags: TIntegerField
      FieldName = 'thOrderPaymentFlags'
      Visible = False
    end
    object qryDaybkFetchDatathCreditCardType: TStringField
      FieldName = 'thCreditCardType'
      Visible = False
      Size = 4
    end
    object qryDaybkFetchDatathCreditCardNumber: TStringField
      FieldName = 'thCreditCardNumber'
      Visible = False
      Size = 4
    end
    object qryDaybkFetchDatathCreditCardExpiry: TStringField
      FieldName = 'thCreditCardExpiry'
      Visible = False
      Size = 4
    end
    object qryDaybkFetchDatathCreditCardAuthorisationNo: TStringField
      FieldName = 'thCreditCardAuthorisationNo'
      Visible = False
    end
    object qryDaybkFetchDatathCreditCardReferenceNo: TStringField
      FieldName = 'thCreditCardReferenceNo'
      Visible = False
      Size = 70
    end
    object qryDaybkFetchDatathCustomData1: TStringField
      FieldName = 'thCustomData1'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathDeliveryCountry: TStringField
      FieldName = 'thDeliveryCountry'
      Visible = False
      Size = 2
    end
    object qryDaybkFetchDatathPPDPercentage: TFloatField
      FieldName = 'thPPDPercentage'
      Visible = False
    end
    object qryDaybkFetchDatathPPDDays: TIntegerField
      FieldName = 'thPPDDays'
      Visible = False
    end
    object qryDaybkFetchDatathPPDGoodsValue: TFloatField
      FieldName = 'thPPDGoodsValue'
      Visible = False
    end
    object qryDaybkFetchDatathPPDVATValue: TFloatField
      FieldName = 'thPPDVATValue'
      Visible = False
    end
    object qryDaybkFetchDatathPPDTaken: TIntegerField
      FieldName = 'thPPDTaken'
      Visible = False
    end
    object qryDaybkFetchDatathPPDCreditNote: TBooleanField
      FieldName = 'thPPDCreditNote'
      Visible = False
    end
    object qryDaybkFetchDatathBatchPayPPDStatus: TIntegerField
      FieldName = 'thBatchPayPPDStatus'
      Visible = False
    end
    object qryDaybkFetchDatathIntrastatOutOfPeriod: TBooleanField
      FieldName = 'thIntrastatOutOfPeriod'
      Visible = False
    end
    object qryDaybkFetchDatathUserField11: TStringField
      FieldName = 'thUserField11'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathUserField12: TStringField
      FieldName = 'thUserField12'
      Visible = False
      Size = 30
    end
    object qryDaybkFetchDatathTaxRegion: TIntegerField
      FieldName = 'thTaxRegion'
      Visible = False
    end
    object qryDaybkFetchDatathAnonymised: TBooleanField
      FieldName = 'thAnonymised'
      Visible = False
    end
    object qryDaybkFetchDatathAnonymisedDate: TStringField
      FieldName = 'thAnonymisedDate'
      Visible = False
      Size = 8
    end
    object qryDaybkFetchDatathAnonymisedTime: TStringField
      FieldName = 'thAnonymisedTime'
      Visible = False
      Size = 6
    end
    object qryDaybkFetchDataPositionId: TAutoIncField
      FieldName = 'PositionId'
      ReadOnly = True
      Visible = False
    end
    object qryDaybkFetchDataOurRefPrefix: TStringField
      FieldName = 'OurRefPrefix'
      ReadOnly = True
      Visible = False
      Size = 1
    end
    object qryDaybkFetchDatathAcCodeComputed: TStringField
      FieldName = 'thAcCodeComputed'
      ReadOnly = True
      Visible = False
      Size = 6
    end
    object qryDaybkFetchDatathBatchLinkComputed: TVarBytesField
      FieldName = 'thBatchLinkComputed'
      ReadOnly = True
      Visible = False
      Size = 12
    end
    object qryDaybkFetchDatathLongYourRefComputed: TVarBytesField
      FieldName = 'thLongYourRefComputed'
      ReadOnly = True
      Visible = False
      Size = 20
    end
    object qryDaybkFetchDatathLongYourRefTrans: TMemoField
      FieldName = 'thLongYourRefTrans'
      ReadOnly = True
      Visible = False
      BlobType = ftMemo
    end
    object qryDaybkFetchDatathBatchLinkTrans: TMemoField
      FieldName = 'thBatchLinkTrans'
      ReadOnly = True
      Visible = False
      BlobType = ftMemo
    end
  end
  object dsDaybkFetchData: TDataSource
    DataSet = qryDaybkFetchData
    Left = 160
    Top = 112
  end
end
