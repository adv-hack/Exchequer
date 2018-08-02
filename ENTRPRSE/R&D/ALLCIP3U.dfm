inherited AllocWAPLInp: TAllocWAPLInp
  Left = 570
  Top = 216
  HelpContext = 1448
  ActiveControl = GLPay1F
  Caption = 'Set Additional Charges'
  ClientHeight = 166
  ClientWidth = 467
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Top = 4
    Width = 458
    Height = 127
  end
  object Label89: Label8 [1]
    Left = 15
    Top = 61
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
  object Label824: Label8 [2]
    Left = 21
    Top = 14
    Width = 223
    Height = 29
    AutoSize = False
    Caption = 'Additional Charges Split'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label825: Label8 [3]
    Left = 277
    Top = 61
    Width = 43
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Amount'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label826: Label8 [4]
    Left = 15
    Top = 88
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
  object Label828: Label8 [5]
    Left = 277
    Top = 88
    Width = 43
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Amount'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 150
    Top = 140
    ModalResult = 0
    TabOrder = 7
  end
  inherited ClsCP1Btn: TButton
    Left = 236
    Top = 140
    TabOrder = 8
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 0
  end
  object GLPay1F: Text8Pt
    Tag = 1
    Left = 67
    Top = 57
    Width = 88
    Height = 22
    HelpContext = 275
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnExit = GLPay1FExit
    TextId = 0
    ViaSBtn = False
  end
  object GLPay1NameF: Text8Pt
    Left = 177
    Top = 57
    Width = 143
    Height = 22
    HelpContext = 40105
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    TextId = 0
    ViaSBtn = False
  end
  object GLPayAmt1: TCurrencyEdit
    Tag = 1
    Left = 334
    Top = 57
    Width = 100
    Height = 22
    HelpContext = 1362
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    MaxLength = 12
    ParentFont = False
    TabOrder = 3
    WantReturns = False
    WordWrap = False
    OnEnter = GLPayAmt1Enter
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = True
    TextId = 0
    Value = 1E-10
  end
  object GLPay2F: Text8Pt
    Tag = 1
    Left = 67
    Top = 84
    Width = 88
    Height = 22
    HelpContext = 275
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnExit = GLPay1FExit
    TextId = 0
    ViaSBtn = False
  end
  object GLPay2NameF: Text8Pt
    Left = 177
    Top = 84
    Width = 143
    Height = 22
    HelpContext = 40105
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
    TextId = 0
    ViaSBtn = False
  end
  object GLPayAmt2: TCurrencyEdit
    Tag = 1
    Left = 334
    Top = 84
    Width = 100
    Height = 22
    HelpContext = 1362
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    MaxLength = 12
    ParentFont = False
    TabOrder = 6
    WantReturns = False
    WordWrap = False
    OnEnter = GLPayAmt2Enter
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = True
    TextId = 0
    Value = 1E-10
  end
end
