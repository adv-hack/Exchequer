object MainDataModule: TMainDataModule
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Left = 182
  Top = 161
  Height = 495
  Width = 756
  object connMain: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;User ID=ADM1139ZZZZ01899;Initial Catalog=Exchequer;Data' +
      ' Source=BRD-PG00WBZY-L\SQLEXPRESS;'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 56
    Top = 24
  end
  object qryDaybkFetchData: TADOQuery
    Connection = connMain
    CursorType = ctStatic
    AfterScroll = qryDaybkFetchDataAfterScroll
    Parameters = <>
    Left = 40
    Top = 112
    object qryDaybkFetchDatathRunNo: TIntegerField
      FieldName = 'thRunNo'
    end
    object qryDaybkFetchDataCurrencyCode: TIntegerField
      FieldName = 'CurrencyCode'
    end
    object qryDaybkFetchDataDescription: TStringField
      FieldName = 'Description'
      Size = 11
    end
    object qryDaybkFetchDataPrintSymbol: TStringField
      FieldName = 'PrintSymbol'
      Size = 3
    end
    object qryDaybkFetchDatathAcCode: TStringField
      FieldName = 'thAcCode'
      Size = 10
    end
    object qryDaybkFetchDatathNomAuto: TBooleanField
      FieldName = 'thNomAuto'
    end
    object qryDaybkFetchDatathOurRef: TStringField
      FieldName = 'thOurRef'
      Size = 10
    end
    object qryDaybkFetchDatathFolioNum: TIntegerField
      FieldName = 'thFolioNum'
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
      Size = 8
    end
    object qryDaybkFetchDatathTransDate: TStringField
      FieldName = 'thTransDate'
      Size = 8
    end
    object qryDaybkFetchDatathCustSupp: TStringField
      FieldName = 'thCustSupp'
      Size = 1
    end
    object qryDaybkFetchDatathCompanyRate: TFloatField
      FieldName = 'thCompanyRate'
    end
    object qryDaybkFetchDatathDailyRate: TFloatField
      FieldName = 'thDailyRate'
    end
    object qryDaybkFetchDatathDocType: TIntegerField
      FieldName = 'thDocType'
    end
    object qryDaybkFetchDatathNetValue: TFloatField
      FieldName = 'thNetValue'
    end
    object qryDaybkFetchDatathTotalVAT: TFloatField
      FieldName = 'thTotalVAT'
    end
    object qryDaybkFetchDatathTotalLineDiscount: TFloatField
      FieldName = 'thTotalLineDiscount'
    end
    object qryDaybkFetchDatathOperator: TStringField
      FieldName = 'thOperator'
      Size = 10
    end
    object qryDaybkFetchDatathDeliveryNoteRef: TStringField
      FieldName = 'thDeliveryNoteRef'
      Size = 10
    end
    object qryDaybkFetchDatathControlGL: TIntegerField
      FieldName = 'thControlGL'
    end
    object qryDaybkFetchDatathJobCode: TStringField
      FieldName = 'thJobCode'
      Size = 10
    end
    object qryDaybkFetchDatathPostedDate: TStringField
      FieldName = 'thPostedDate'
      Size = 8
    end
    object qryDaybkFetchDatathPORPickSOR: TBooleanField
      FieldName = 'thPORPickSOR'
    end
    object qryDaybkFetchDatathYourRef: TStringField
      FieldName = 'thYourRef'
    end
    object qryDaybkFetchDatathOriginator: TStringField
      FieldName = 'thOriginator'
      Size = 36
    end
    object qryDaybkFetchDataPositionId: TAutoIncField
      FieldName = 'PositionId'
      ReadOnly = True
    end
    object qryDaybkFetchDataOurRefPrefix: TStringField
      FieldName = 'OurRefPrefix'
      ReadOnly = True
      Size = 1
    end
  end
  object dsDaybkFetchData: TDataSource
    DataSet = qryDaybkFetchData
    Left = 160
    Top = 112
  end
  object qryDetail: TADOQuery
    Connection = connMain
    CursorType = ctStatic
    Parameters = <>
    Left = 64
    Top = 264
  end
  object dsDaybookDetail: TDataSource
    DataSet = qryDetail
    Left = 176
    Top = 248
  end
end
