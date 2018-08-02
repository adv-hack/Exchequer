object NTLine: TNTLine
  Left = 474
  Top = 242
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Nominal Journal Line Entry'
  ClientHeight = 351
  ClientWidth = 614
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label87: Label8
    Left = 11
    Top = 18
    Width = 54
    Height = 14
    Caption = 'Description'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8
    Left = 20
    Top = 53
    Width = 45
    Height = 14
    Caption = 'G/L Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object CCLab: Label8
    Left = 490
    Top = 33
    Width = 14
    Height = 14
    Caption = 'CC'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object DepLab: Label8
    Left = 538
    Top = 34
    Width = 22
    Height = 14
    Caption = 'Dept'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object JCLab: Label8
    Left = 20
    Top = 193
    Width = 45
    Height = 14
    Caption = 'Job Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object JALab: Label8
    Left = 391
    Top = 193
    Width = 61
    Height = 14
    Caption = 'Job Analysis'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object UDF1L: Label8
    Left = 18
    Top = 233
    Width = 100
    Height = 14
    AutoSize = False
    Caption = 'UD Field 1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object UDF2L: Label8
    Left = 138
    Top = 233
    Width = 100
    Height = 14
    AutoSize = False
    Caption = 'UD Field 2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object UDF4L: Label8
    Left = 378
    Top = 233
    Width = 100
    Height = 14
    AutoSize = False
    Caption = 'UD Field 4'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object UDF3L: Label8
    Left = 258
    Top = 233
    Width = 100
    Height = 14
    AutoSize = False
    Caption = 'UD Field 3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object CurrLab: Label8
    Left = 20
    Top = 89
    Width = 45
    Height = 14
    Caption = 'Currency'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object I1ExLab: Label8
    Left = 155
    Top = 89
    Width = 37
    Height = 14
    Caption = 'Ex.Rate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object SBSBackGroup1: TSBSBackGroup
    Left = 64
    Top = 116
    Width = 523
    Height = 59
    TextId = 0
  end
  object Label83: Label8
    Left = 146
    Top = 128
    Width = 44
    Height = 14
    Alignment = taRightJustify
    Caption = 'Debit (+) '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 258
    Top = 128
    Width = 55
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Credit (-) '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object VATLab: Label8
    Left = 353
    Top = 128
    Width = 28
    Height = 14
    Caption = 'In/Out'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object VATCLab: Label8
    Left = 400
    Top = 128
    Width = 51
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = ' Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label88: Label8
    Left = 479
    Top = 128
    Width = 98
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = ' Amount  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Bevel1: TBevel
    Left = 329
    Top = 127
    Width = 2
    Height = 40
  end
  object UDF5L: Label8
    Left = 498
    Top = 233
    Width = 100
    Height = 14
    AutoSize = False
    Caption = 'UD Field 5'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object UDF6L: Label8
    Left = 18
    Top = 273
    Width = 100
    Height = 14
    AutoSize = False
    Caption = 'UD Field 6'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object UDF7L: Label8
    Left = 138
    Top = 273
    Width = 100
    Height = 14
    AutoSize = False
    Caption = 'UD Field 7'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object UDF8L: Label8
    Left = 258
    Top = 273
    Width = 100
    Height = 14
    AutoSize = False
    Caption = 'UD Field 8'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object UDF9L: Label8
    Left = 378
    Top = 273
    Width = 100
    Height = 14
    AutoSize = False
    Caption = 'UD Field 9'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object UDF10L: Label8
    Left = 498
    Top = 273
    Width = 100
    Height = 14
    AutoSize = False
    Caption = 'UD Field 10'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object NTLDF: Text8Pt
    Tag = 1
    Left = 73
    Top = 13
    Width = 386
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 0
    TextId = 0
    ViaSBtn = False
  end
  object NTNAF: Text8Pt
    Tag = 1
    Left = 73
    Top = 49
    Width = 119
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 1
    TextId = 0
    ViaSBtn = False
  end
  object NTNDF: Text8Pt
    Left = 197
    Top = 49
    Width = 262
    Height = 22
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 2
    TextId = 0
    ViaSBtn = False
  end
  object NTCCF: Text8Pt
    Tag = 1
    Left = 464
    Top = 49
    Width = 55
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 3
    TextId = 0
    ViaSBtn = False
  end
  object NTDepF: Text8Pt
    Tag = 1
    Left = 524
    Top = 49
    Width = 54
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 4
    TextId = 0
    ViaSBtn = False
  end
  object Candb1Btn: TButton
    Tag = 1
    Left = 522
    Top = 324
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    Default = True
    ModalResult = 2
    TabOrder = 25
    OnClick = Candb1BtnClick
  end
  object NTJCF: Text8Pt
    Tag = 1
    Left = 73
    Top = 189
    Width = 120
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 12
    TextId = 0
    ViaSBtn = False
  end
  object NTJAF: Text8Pt
    Tag = 1
    Left = 458
    Top = 189
    Width = 120
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 14
    TextId = 0
    ViaSBtn = False
  end
  object THUD1F: Text8Pt
    Tag = 1
    Left = 17
    Top = 250
    Width = 115
    Height = 22
    HelpContext = 283
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 15
    TextId = 0
    ViaSBtn = False
  end
  object THUD2F: Text8Pt
    Tag = 1
    Left = 136
    Top = 250
    Width = 115
    Height = 22
    HelpContext = 283
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 16
    TextId = 0
    ViaSBtn = False
  end
  object THUD4F: Text8Pt
    Tag = 1
    Left = 374
    Top = 250
    Width = 115
    Height = 22
    HelpContext = 283
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 18
    TextId = 0
    ViaSBtn = False
  end
  object THUD3F: Text8Pt
    Tag = 1
    Left = 255
    Top = 250
    Width = 115
    Height = 22
    HelpContext = 283
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 17
    TextId = 0
    ViaSBtn = False
  end
  object NTCurrF: TSBSComboBox
    Tag = 1
    Left = 73
    Top = 85
    Width = 66
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MaxLength = 3
    ParentFont = False
    TabOrder = 5
    ExtendedList = True
    MaxListWidth = 90
    ReadOnly = True
    Validate = True
  end
  object NTExRF: TCurrencyEdit
    Tag = 1
    Left = 197
    Top = 85
    Width = 120
    Height = 22
    HelpContext = 1177
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.000000 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 6
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.000000 ;###,###,##0.000000-'
    DecPlaces = 6
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object NTJDF: Text8Pt
    Left = 199
    Top = 189
    Width = 183
    Height = 22
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 13
    TextId = 0
    ViaSBtn = False
  end
  object NTDAmtF: TCurrencyEdit
    Tag = 1
    Left = 73
    Top = 143
    Width = 120
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 7
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object NTCAmtF: TCurrencyEdit
    Tag = 1
    Left = 198
    Top = 143
    Width = 120
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 8
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object NTIOCB: TSBSComboBox
    Tag = 1
    Left = 342
    Top = 143
    Width = 55
    Height = 22
    HelpContext = 40016
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MaxLength = 1
    ParentFont = False
    TabOrder = 9
    Items.Strings = (
      'N/A'
      'Auto'
      'Manual')
    AllowChangeInExit = True
    ExtendedList = True
    MaxListWidth = 85
    ReadOnly = True
    Validate = True
  end
  object NTVATCF: TSBSComboBox
    Tag = 1
    Left = 401
    Top = 143
    Width = 51
    Height = 22
    HelpContext = 40016
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MaxLength = 1
    ParentFont = False
    TabOrder = 10
    AllowChangeInExit = True
    ExtendedList = True
    MaxListWidth = 75
    ReadOnly = True
    Validate = True
  end
  object NTVATF: TCurrencyEdit
    Tag = 1
    Left = 457
    Top = 143
    Width = 120
    Height = 22
    HelpContext = 40016
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0,00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 11
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object THUD5F: Text8Pt
    Tag = 1
    Left = 494
    Top = 250
    Width = 115
    Height = 22
    HelpContext = 283
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 19
    TextId = 0
    ViaSBtn = False
  end
  object THUD9F: Text8Pt
    Tag = 1
    Left = 374
    Top = 290
    Width = 115
    Height = 22
    HelpContext = 283
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 23
    TextId = 0
    ViaSBtn = False
  end
  object THUD10F: Text8Pt
    Tag = 1
    Left = 494
    Top = 290
    Width = 115
    Height = 22
    HelpContext = 283
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 24
    TextId = 0
    ViaSBtn = False
  end
  object THUD8F: Text8Pt
    Tag = 1
    Left = 255
    Top = 290
    Width = 115
    Height = 22
    HelpContext = 283
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 22
    TextId = 0
    ViaSBtn = False
  end
  object THUD7F: Text8Pt
    Tag = 1
    Left = 136
    Top = 290
    Width = 115
    Height = 22
    HelpContext = 283
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 21
    TextId = 0
    ViaSBtn = False
  end
  object THUD6F: Text8Pt
    Tag = 1
    Left = 17
    Top = 290
    Width = 115
    Height = 22
    HelpContext = 283
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 20
    TextId = 0
    ViaSBtn = False
  end
end