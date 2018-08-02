object frmCurrencyDetails: TfrmCurrencyDetails
  Left = 209
  Top = 210
  BorderStyle = bsDialog
  Caption = 'frmCurrencyDetails'
  ClientHeight = 534
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label89: Label8
    Left = 8
    Top = 200
    Width = 92
    Height = 14
    Caption = 'HIstory of changes'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Panel2: TPanel
    Left = 8
    Top = 216
    Width = 448
    Height = 313
    TabOrder = 4
    object mlHistory: TDBMultiList
      Left = 1
      Top = 1
      Width = 446
      Height = 311
      Custom.SplitterCursor = crHSplit
      Dimensions.HeaderHeight = 18
      Dimensions.SpacerWidth = 1
      Dimensions.SplitterWidth = 3
      Options.BoldActiveColumn = False
      Columns = <
        item
          Caption = 'Date'
          Field = 'D'
        end
        item
          Alignment = taRightJustify
          Caption = 'Daily Rate'
          DataType = dtFloat
          Field = 'V'
        end
        item
          Alignment = taRightJustify
          Caption = 'Company Rate'
          DataType = dtFloat
          Field = 'C'
        end
        item
          Caption = 'User'
          Field = 'U'
        end
        item
          Caption = 'N'
          Field = 'N'
          Searchable = True
          Sortable = True
          Visible = False
          IndexNo = 1
        end>
      TabStop = False
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      TabOrder = 0
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Arial'
      HeaderFont.Style = []
      HighlightFont.Charset = DEFAULT_CHARSET
      HighlightFont.Color = clWhite
      HighlightFont.Height = -11
      HighlightFont.Name = 'Arial'
      HighlightFont.Style = []
      MultiSelectFont.Charset = DEFAULT_CHARSET
      MultiSelectFont.Color = clWindowText
      MultiSelectFont.Height = -11
      MultiSelectFont.Name = 'Arial'
      MultiSelectFont.Style = []
      Version = 'v1.13'
      Dataset = dsHistory
      Active = False
      SortColIndex = 4
      SortAsc = True
    end
  end
  object btnOK: TSBSButton
    Left = 463
    Top = 16
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 5
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 463
    Top = 40
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 6
    TextId = 0
  end
  object gbGeneral: TSBSGroup
    Left = 8
    Top = 8
    Width = 221
    Height = 81
    Caption = 'Details'
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = True
    TextId = 0
    object Label81: Label8
      Left = 9
      Top = 18
      Width = 64
      Height = 14
      Alignment = taRightJustify
      Caption = 'Currency No:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 16
      Top = 42
      Width = 57
      Height = 14
      Alignment = taRightJustify
      Caption = 'Description:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object edtDesc: Text8Pt
      Left = 80
      Top = 40
      Width = 121
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 11
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TextId = 0
      ViaSBtn = False
    end
    object ceCurrNo: TCurrencyEdit
      Left = 80
      Top = 16
      Width = 49
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      MaxLength = 2
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0-'
      DecPlaces = 0
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
  end
  object gbRates: TSBSGroup
    Left = 235
    Top = 8
    Width = 221
    Height = 81
    Caption = 'Rates'
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = True
    TextId = 0
    object Label85: Label8
      Left = 48
      Top = 19
      Width = 26
      Height = 14
      Alignment = taRightJustify
      Caption = 'Daily:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label86: Label8
      Left = 26
      Top = 43
      Width = 48
      Height = 14
      Alignment = taRightJustify
      Caption = 'Company:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object ceDailyRate: TCurrencyEdit
      Left = 80
      Top = 16
      Width = 113
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.000000 ')
      ParentFont = False
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      OnExit = ceDailyRateExit
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
      DecPlaces = 6
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object ceCoRate: TCurrencyEdit
      Left = 80
      Top = 40
      Width = 113
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.000000 ')
      ParentFont = False
      TabOrder = 1
      WantReturns = False
      WordWrap = False
      OnExit = ceDailyRateExit
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
      DecPlaces = 6
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
  end
  object gbGhost: TSBSGroup
    Left = 235
    Top = 96
    Width = 221
    Height = 97
    Caption = 'Triangulation'
    TabOrder = 3
    AllowReSize = False
    IsGroupBox = True
    TextId = 0
    object Label87: Label8
      Left = 10
      Top = 42
      Width = 64
      Height = 14
      Alignment = taRightJustify
      Caption = 'Triangulation:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label88: Label8
      Left = 49
      Top = 64
      Width = 25
      Height = 14
      Alignment = taRightJustify
      Caption = 'Rate:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object chkInvert: TCheckBox
      Left = 80
      Top = 16
      Width = 49
      Height = 17
      Caption = '1/x'
      TabOrder = 0
    end
    object chkFloat: TCheckBox
      Left = 144
      Top = 16
      Width = 65
      Height = 17
      Caption = 'Float'
      TabOrder = 1
    end
    object ceGhostRate: TCurrencyEdit
      Left = 80
      Top = 64
      Width = 113
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.000000 ')
      ParentFont = False
      TabOrder = 3
      WantReturns = False
      WordWrap = False
      OnExit = ceDailyRateExit
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
      DecPlaces = 6
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object ceTriang: TCurrencyEdit
      Left = 80
      Top = 40
      Width = 41
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      ParentFont = False
      TabOrder = 2
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0-'
      DecPlaces = 0
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
  end
  object gbSymbol: TSBSGroup
    Left = 8
    Top = 96
    Width = 221
    Height = 97
    Caption = 'Symbols'
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = True
    TextId = 0
    object Label83: Label8
      Left = 36
      Top = 22
      Width = 38
      Height = 14
      Caption = 'Screen:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label84: Label8
      Left = 40
      Top = 46
      Width = 34
      Height = 14
      Caption = 'Printer:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object edtScreen: Text8Pt
      Left = 80
      Top = 19
      Width = 57
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 3
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TextId = 0
      ViaSBtn = False
    end
    object edtPrinter: Text8Pt
      Left = 80
      Top = 43
      Width = 57
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 3
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TextId = 0
      ViaSBtn = False
    end
  end
  object btnExport: TSBSButton
    Left = 463
    Top = 216
    Width = 80
    Height = 21
    Caption = 'Export &History'
    TabOrder = 7
    OnClick = btnExportClick
    TextId = 0
  end
  object dsHistory: TBtrieveDataset
    FileName = 'CurrencyHistory'
    OnGetFieldValue = dsHistoryGetFieldValue
    Left = 472
    Top = 464
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 472
    Top = 432
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CSV Files (*.csv)|*.csv'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 472
    Top = 400
  end
end
