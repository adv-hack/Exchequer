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
      ' Source=sonanis-pc;'
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
    Parameters = <
      item
        Name = 'DocType1'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'DocType2'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'SELECT [tlFolioNum],[tlStockCodeTrans1],[tlOurRef]'
      '      ,[tlGLCode]'
      '      ,[tlLineType]      '
      '      ,[tlDepartment]'
      '      ,[tlCostCentre]      '
      '      ,[tlDocType]'
      '      ,[tlQty]'
      '      ,[tlQtyMul]'
      '      ,[tlNetValue]'
      '      ,[tlDiscount]'
      '      ,[tlVATCode]'
      '      ,[tlVATAmount]'
      '      ,[tlPaymentCode]'
      '      ,[tlCost]'
      '      ,[tlAcCode]'
      '      ,[tlLineDate]'
      '      ,[tlDescription]'
      '      ,[tlJobCode]'
      '      ,[tlAnalysisCode]'
      '      ,[tlStockDeductQty]'
      '      ,[tlLocation]'
      '      ,[tlQtyPicked]'
      '      ,[tlQtyPickedWO]'
      '      ,[tlUsePack]'
      '      ,[tlSerialQty]'
      '      ,[tlQtyPack]'
      '      ,[tlAcCodeTrans]'
      #9'  ,PositionId'
      '      '
      '  FROM [ZZZZ01].[DETAILS]'
      ''
      '  where tlDocType = :DocType1  or tlDocType = :DocType2'
      '  ')
    Left = 64
    Top = 264
    object qryDetailtlFolioNum: TIntegerField
      FieldName = 'tlFolioNum'
      Visible = False
    end
    object qryDetailtlStockCodeTrans1: TMemoField
      DisplayLabel = 'Code'
      FieldName = 'tlStockCodeTrans1'
      ReadOnly = True
      BlobType = ftMemo
    end
    object qryDetailtlDescription: TStringField
      DisplayLabel = 'Description'
      FieldName = 'tlDescription'
      Size = 60
    end
    object qryDetailtlOurRef: TStringField
      DisplayLabel = 'Our Ref'
      FieldName = 'tlOurRef'
      Size = 10
    end
    object qryDetailtlGLCode: TIntegerField
      DisplayLabel = 'GL Code'
      FieldName = 'tlGLCode'
    end
    object qryDetailtlLineType: TStringField
      FieldName = 'tlLineType'
      Visible = False
      Size = 1
    end
    object qryDetailtlDepartment: TStringField
      DisplayLabel = 'Department'
      FieldName = 'tlDepartment'
      Size = 3
    end
    object qryDetailtlCostCentre: TStringField
      DisplayLabel = 'Cost Centre'
      FieldName = 'tlCostCentre'
      Size = 3
    end
    object qryDetailtlDocType: TIntegerField
      FieldName = 'tlDocType'
      Visible = False
    end
    object qryDetailtlQty: TFloatField
      DisplayLabel = 'Qty'
      FieldName = 'tlQty'
      DisplayFormat = '0.00'
    end
    object qryDetailtlQtyMul: TFloatField
      DisplayLabel = 'Qty Mulltiplier'
      FieldName = 'tlQtyMul'
      DisplayFormat = '0.00'
    end
    object qryDetailtlNetValue: TFloatField
      DisplayLabel = 'Net Value'
      FieldName = 'tlNetValue'
      DisplayFormat = '0.00'
    end
    object qryDetailtlDiscount: TFloatField
      DisplayLabel = 'Discount'
      FieldName = 'tlDiscount'
      DisplayFormat = '0.00'
    end
    object qryDetailtlVATCode: TStringField
      DisplayLabel = 'VAT Code'
      FieldName = 'tlVATCode'
      Size = 1
    end
    object qryDetailtlVATAmount: TFloatField
      DisplayLabel = 'VAT Amount'
      FieldName = 'tlVATAmount'
      Visible = False
      DisplayFormat = '0.00'
    end
    object qryDetailtlPaymentCode: TStringField
      FieldName = 'tlPaymentCode'
      Visible = False
      Size = 1
    end
    object qryDetailtlCost: TFloatField
      FieldName = 'tlCost'
      Visible = False
    end
    object qryDetailtlAcCode: TStringField
      DisplayLabel = 'Ac Code'
      FieldName = 'tlAcCode'
      Size = 10
    end
    object qryDetailtlLineDate: TStringField
      FieldName = 'tlLineDate'
      Visible = False
      Size = 8
    end
    object qryDetailtlJobCode: TStringField
      FieldName = 'tlJobCode'
      Visible = False
      Size = 10
    end
    object qryDetailtlAnalysisCode: TStringField
      FieldName = 'tlAnalysisCode'
      Visible = False
      Size = 10
    end
    object qryDetailtlStockDeductQty: TFloatField
      DisplayLabel = 'Deduct Qty'
      FieldName = 'tlStockDeductQty'
    end
    object qryDetailtlLocation: TStringField
      DisplayLabel = 'Location'
      FieldName = 'tlLocation'
      Size = 3
    end
    object qryDetailtlQtyPicked: TFloatField
      DisplayLabel = 'Qty Picked'
      FieldName = 'tlQtyPicked'
    end
    object qryDetailtlQtyPickedWO: TFloatField
      FieldName = 'tlQtyPickedWO'
      Visible = False
    end
    object qryDetailtlUsePack: TBooleanField
      FieldName = 'tlUsePack'
      Visible = False
    end
    object qryDetailtlSerialQty: TFloatField
      FieldName = 'tlSerialQty'
      Visible = False
    end
    object qryDetailtlQtyPack: TFloatField
      FieldName = 'tlQtyPack'
      Visible = False
    end
    object qryDetailtlAcCodeTrans: TStringField
      FieldName = 'tlAcCodeTrans'
      ReadOnly = True
      Visible = False
      Size = 10
    end
    object qryDetailPositionId: TAutoIncField
      FieldName = 'PositionId'
      ReadOnly = True
      Visible = False
    end
  end
  object dsDaybookDetail: TDataSource
    DataSet = qryDetail
    Left = 176
    Top = 248
  end
end
