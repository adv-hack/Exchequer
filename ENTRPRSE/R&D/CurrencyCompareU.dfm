object frmCurrUpdateConfirm: TfrmCurrUpdateConfirm
  Left = 301
  Top = 198
  Width = 889
  Height = 479
  Anchors = []
  BorderIcons = [biSystemMenu]
  Caption = 'Currency Update Confirmation'
  Color = clBtnFace
  Constraints.MinHeight = 370
  Constraints.MinWidth = 889
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlClient: TPanel
    Left = 0
    Top = 0
    Width = 873
    Height = 440
    Align = alClient
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      873
      440)
    object Notelbl: TLabel
      Left = 2
      Top = 425
      Width = 735
      Height = 15
      Anchors = [akLeft, akBottom]
      Caption = 
        '  Note: A highlighted value in the '#39'Change +/-'#39' columns indicate' +
        's the exchange rate change exceeds the tolerance % set in system' +
        ' setup'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Layout = tlBottom
    end
    object CancelBtn: TButton
      Left = 767
      Top = 60
      Width = 102
      Height = 21
      Anchors = [akTop]
      Caption = 'Cancel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = CancelBtnClick
    end
    object dbgrdCurrUpdateComp: TDBGrid
      Left = 5
      Top = 5
      Width = 740
      Height = 414
      BiDiMode = bdLeftToRight
      DataSource = ds1
      FixedColor = clBtnHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Options = [dgTitles, dgColumnResize, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      ParentBiDiMode = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Arial'
      TitleFont.Style = []
      OnColumnMoved = dbgrdCurrUpdateCompColumnMoved
      OnDrawColumnCell = dbgrdCurrUpdateCompDrawColumnCell
      Columns = <
        item
          Alignment = taLeftJustify
          Expanded = False
          FieldName = 'No'
          Width = 20
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Description'
          Width = 82
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Screen'
          Width = 40
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Printer'
          Width = 40
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Old Daily Rate'
          Title.Alignment = taRightJustify
          Width = 83
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'New Daily Rate'
          Title.Alignment = taRightJustify
          Width = 83
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DailyRateChange'
          Title.Alignment = taRightJustify
          Title.Caption = 'Change +/-'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Old Company Rate'
          Title.Alignment = taRightJustify
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'New Company Rate'
          Title.Alignment = taRightJustify
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CompanyRateChange'
          Title.Alignment = taRightJustify
          Title.Caption = 'Change +/-'
          Width = 80
          Visible = True
        end>
    end
    object ImportRatesBtn: TButton
      Left = 767
      Top = 10
      Width = 102
      Height = 21
      Anchors = [akTop]
      BiDiMode = bdLeftToRight
      Caption = 'Import Rates'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
      TabOrder = 1
      OnClick = ImportRatesBtnClick
    end
    object btnReval: TButton
      Left = 767
      Top = 35
      Width = 102
      Height = 21
      Anchors = [akTop]
      BiDiMode = bdLeftToRight
      Caption = 'Revalue G/L'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
      TabOrder = 2
      OnClick = btnRevalClick
    end
  end
  object tblCurrencyImport: TADODataSet
    CursorType = ctStatic
    LockType = ltBatchOptimistic
    OnCalcFields = tblCurrencyImportCalcFields
    FieldDefs = <
      item
        Name = 'No'
        Attributes = [faFixed]
        DataType = ftInteger
      end
      item
        Name = 'Description'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Screen'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'Printer'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'Old Daily Rate'
        Attributes = [faFixed]
        DataType = ftFloat
      end
      item
        Name = 'New Daily Rate'
        Attributes = [faFixed]
        DataType = ftFloat
      end
      item
        Name = 'Old Company Rate'
        Attributes = [faFixed]
        DataType = ftFloat
      end
      item
        Name = 'New Company Rate'
        Attributes = [faFixed]
        DataType = ftFloat
      end>
    Parameters = <>
    StoreDefs = True
    Left = 784
    Top = 400
    object tblCurrencyImportNo: TIntegerField
      FieldName = 'No'
    end
    object tblCurrencyImportDescription: TStringField
      FieldName = 'Description'
    end
    object tblCurrencyImportScreen: TStringField
      FieldName = 'Screen'
      Size = 3
    end
    object tblCurrencyImportPrinter: TStringField
      FieldName = 'Printer'
      Size = 3
    end
    object tblCurrencyImportOldDailyRate: TFloatField
      FieldName = 'Old Daily Rate'
      DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
    end
    object tblCurrencyImportNewDailyRate: TFloatField
      FieldName = 'New Daily Rate'
      DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
    end
    object tblCurrencyImportOldCompanyRate: TFloatField
      FieldName = 'Old Company Rate'
      DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
    end
    object tblCurrencyImportNewCompanyRate: TFloatField
      FieldName = 'New Company Rate'
      DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
    end
    object tblCurrencyImportDailyRateChange: TFloatField
      DisplayLabel = 'Daily Rate Change'
      FieldKind = fkCalculated
      FieldName = 'DailyRateChange'
      DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
      Calculated = True
    end
    object tblCurrencyImportCompanyRateChange: TFloatField
      DisplayLabel = 'Company Rate Change'
      FieldKind = fkCalculated
      FieldName = 'CompanyRateChange'
      DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
      Calculated = True
    end
  end
  object ds1: TDataSource
    DataSet = tblCurrencyImport
    Left = 784
    Top = 360
  end
end
