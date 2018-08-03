object MainDataModule: TMainDataModule
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Left = 603
  Top = 155
  Height = 495
  Width = 756
  object connMain: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;User ID=ADM1139ZZZZ01899;Initial Catalog=Exchequer;Data' +
      ' Source=RAHULB-PC;'
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
    SQL.Strings = (
      ''
      
        ' SELECT [thRunNo] ,[thOurRef]   ,[thAcCode],Convert(date, [thTra' +
        'nsDate], 103) as thTransDate_1,(Str(thYear+1900) + '#39'-'#39'+lTrim(Str' +
        '(thperiod))) as Period ,'
      
        ' [thNetValue] + [thTotalVAT] as Amount ,[thHoldFlag] ,CurrencyCo' +
        'de , Curr.Description ,'
      
        ' Curr.PrintSymbol ,[thNomAuto]  ,[thFolioNum] ,[thCurrency] ,[th' +
        'DueDate]  ,[thCustSupp] ,[thCompanyRate] ,'
      
        ' [thDailyRate]   ,[thDocType]     ,[thTotalLineDiscount] ,[thOpe' +
        'rator]          ,[thDeliveryNoteRef]   ,[thControlGL]         ,[' +
        'thJobCode]           ,'
      
        ' [thPostedDate]        ,[thPORPickSOR]        ,[thYourRef]      ' +
        '     ,[thOriginator]        ,[PositionId]          ,'
      
        ' [OurRefPrefix]        ,[thTagged]           ,[thPrinted]       ' +
        '    ,[thIncludeInPickingRun]'
      
        ' FROM ZZZZ01.[DOCUMENT] Doc inner join ZZZZ01.[CURRENCY] Curr on' +
        ' Doc.thcurrency = Curr.currencycode'
      
        ' where [OurRefPrefix] = '#39'S'#39' and [thRunNo] = 0 and (Doc.thFolioNu' +
        'm > -2147483647) and (Doc.thFolioNum < 2147483647) and Doc.thDoc' +
        'Type <> 7 ')
    Left = 40
    Top = 112
    object qryDaybkFetchDatathRunNo: TIntegerField
      FieldName = 'thRunNo'
      Visible = False
    end
    object qryDaybkFetchDataCurrencyCode: TIntegerField
      FieldName = 'CurrencyCode'
      Visible = False
    end
    object qryDaybkFetchDataDescription: TStringField
      FieldName = 'Description'
      Visible = False
      Size = 11
    end
    object qryDaybkFetchDatathAcCode: TStringField
      DisplayLabel = 'A/C'
      FieldName = 'thAcCode'
      Size = 10
    end
    object qryDaybkFetchDatathNomAuto: TBooleanField
      FieldName = 'thNomAuto'
      Visible = False
    end
    object qryDaybkFetchDatathOurRef: TStringField
      DisplayLabel = 'Our Ref'
      FieldName = 'thOurRef'
      Size = 10
    end
    object qryDaybkFetchDatathFolioNum: TIntegerField
      FieldName = 'thFolioNum'
      Visible = False
    end
    object qryDaybkFetchDatathCurrency: TIntegerField
      FieldName = 'thCurrency'
      Visible = False
    end
    object qryDaybkFetchDataPeriod: TStringField
      FieldName = 'Period'
      ReadOnly = True
      Size = 21
    end
    object qryDaybkFetchDatathDueDate: TStringField
      DisplayLabel = 'Due Date'
      FieldName = 'thDueDate'
      Visible = False
      Size = 8
    end
    object qryDaybkFetchDatathCustSupp: TStringField
      FieldName = 'thCustSupp'
      Visible = False
      Size = 1
    end
    object qryDaybkFetchDatathCompanyRate: TFloatField
      FieldName = 'thCompanyRate'
      Visible = False
    end
    object qryDaybkFetchDatathDailyRate: TFloatField
      FieldName = 'thDailyRate'
      Visible = False
    end
    object qryDaybkFetchDatathDocType: TIntegerField
      FieldName = 'thDocType'
      Visible = False
    end
    object qryDaybkFetchDatathTotalLineDiscount: TFloatField
      FieldName = 'thTotalLineDiscount'
      Visible = False
    end
    object qryDaybkFetchDatathOperator: TStringField
      DisplayLabel = 'User'
      FieldName = 'thOperator'
      Size = 10
    end
    object qryDaybkFetchDatathDeliveryNoteRef: TStringField
      FieldName = 'thDeliveryNoteRef'
      Visible = False
      Size = 10
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
    object qryDaybkFetchDatathPostedDate: TStringField
      FieldName = 'thPostedDate'
      Visible = False
      Size = 8
    end
    object qryDaybkFetchDatathPORPickSOR: TBooleanField
      FieldName = 'thPORPickSOR'
      Visible = False
    end
    object qryDaybkFetchDataPrintSymbol: TStringField
      DisplayLabel = 'Currency'
      FieldName = 'PrintSymbol'
      OnGetText = qryDaybkFetchDataPrintSymbolGetText
      Size = 3
    end
    object qryDaybkFetchDatathYourRef: TStringField
      DisplayLabel = 'Your Ref'
      FieldName = 'thYourRef'
    end
    object qryDaybkFetchDatathOriginator: TStringField
      FieldName = 'thOriginator'
      Visible = False
      Size = 36
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
    object qryDaybkFetchDataAmount: TFloatField
      FieldName = 'Amount'
      ReadOnly = True
      DisplayFormat = '0.00'
    end
    object qryDaybkFetchDatathHoldFlag: TIntegerField
      DisplayLabel = 'Status'
      FieldName = 'thHoldFlag'
      OnGetText = qryDaybkFetchDatathHoldFlagGetText
    end
    object qryDaybkFetchDatathTagged: TIntegerField
      FieldName = 'thTagged'
      Visible = False
    end
    object qryDaybkFetchDatathPrinted: TBooleanField
      FieldName = 'thPrinted'
      Visible = False
    end
    object qryDaybkFetchDatathIncludeInPickingRun: TBooleanField
      FieldName = 'thIncludeInPickingRun'
      Visible = False
    end
    object qryDaybkFetchDatathTransDate_1: TStringField
      DisplayLabel = 'Date'
      FieldName = 'thTransDate_1'
      Size = 10
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
      Visible = False
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
      Visible = False
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
      Visible = False
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
      Visible = False
    end
    object qryDetailtlLocation: TStringField
      DisplayLabel = 'Location'
      FieldName = 'tlLocation'
      Visible = False
      Size = 3
    end
    object qryDetailtlQtyPicked: TFloatField
      DisplayLabel = 'Qty Picked'
      FieldName = 'tlQtyPicked'
      Visible = False
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
