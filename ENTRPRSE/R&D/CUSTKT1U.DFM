object CuStkT1: TCuStkT1
  Left = 620
  Top = 269
  HelpContext = 500
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Stock Analysis Entry Record'
  ClientHeight = 178
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object SBSPanel1: TSBSPanel
    Left = 6
    Top = 4
    Width = 387
    Height = 131
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 9
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label85: Label8
      Left = 202
      Top = 103
      Width = 71
      Height = 14
      Caption = 'Last Price Paid'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label84: Label8
      Left = 7
      Top = 104
      Width = 70
      Height = 14
      Caption = 'Date Last Sold'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 11
      Top = 73
      Width = 66
      Height = 14
      Caption = 'Display Order'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label81: Label8
      Left = 59
      Top = 42
      Width = 18
      Height = 14
      Caption = 'A/C'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Id3SCodeLab: Label8
      Left = 22
      Top = 12
      Width = 55
      Height = 14
      Caption = 'Stock Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label83: Label8
      Left = 189
      Top = 74
      Width = 85
      Height = 14
      Caption = 'Repeat Order Qty'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
  end
  object CSLastP: TCurrencyEdit
    Left = 282
    Top = 103
    Width = 95
    Height = 22
    HelpContext = 820
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    TabOrder = 6
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
  object CSRepQ: TCurrencyEdit
    Tag = 1
    Left = 282
    Top = 73
    Width = 95
    Height = 22
    HelpContext = 818
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 12
    ParentFont = False
    TabOrder = 4
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
  object OkCP1Btn: TButton
    Tag = 1
    Left = 117
    Top = 148
    Width = 80
    Height = 21
    HelpContext = 257
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 7
    OnClick = CanCP1BtnClick
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 201
    Top = 148
    Width = 80
    Height = 21
    HelpContext = 258
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 8
    OnClick = CanCP1BtnClick
  end
  object CSStkCode: Text8Pt
    Tag = 1
    Left = 86
    Top = 12
    Width = 290
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 781
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnExit = CSStkCodeExit
    TextId = 0
    ViaSBtn = False
    Link_to_Stock = True
    ShowHilight = True
  end
  object CSAcc: Text8Pt
    Left = 86
    Top = 42
    Width = 80
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 771
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
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
    Link_to_Cust = True
    ShowHilight = True
  end
  object CSComp: Text8Pt
    Left = 173
    Top = 42
    Width = 204
    Height = 22
    HelpContext = 771
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 30
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 2
    OnDblClick = CSCompDblClick
    TextId = 0
    ViaSBtn = False
  end
  object CSDisp: TCurrencyEdit
    Tag = 1
    Left = 86
    Top = 73
    Width = 80
    Height = 22
    HelpContext = 817
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 12
    ParentFont = False
    TabOrder = 3
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
  object CSLastD: TEditDate
    Left = 86
    Top = 103
    Width = 80
    Height = 22
    HelpContext = 819
    TabStop = False
    AutoSelect = False
    Color = clBtnFace
    EditMask = '00/00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
    Placement = cpAbove
  end
end
