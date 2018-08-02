inherited WORIssMsg: TWORIssMsg
  HelpContext = 1332
  Caption = 'Generate Works Order Picking List'
  ClientHeight = 191
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 159
  end
  object Label83: Label8 [1]
    Left = 36
    Top = 18
    Width = 123
    Height = 14
    Alignment = taRightJustify
    Caption = 'Generate from Location : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [2]
    Left = 16
    Top = 42
    Width = 140
    Height = 14
    Caption = 'Include only orders with tag :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [3]
    Left = 17
    Top = 55
    Width = 109
    Height = 14
    Caption = '(0 includes all orders)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 66
    Top = 167
    TabOrder = 7
  end
  inherited ClsCP1Btn: TButton
    Left = 152
    Top = 167
    TabOrder = 8
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 0
  end
  object Sum3: TBorCheck
    Left = 34
    Top = 110
    Width = 140
    Height = 20
    HelpContext = 476
    Caption = 'Print list for each order :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TabStop = True
    TextId = 0
  end
  object Sum4: TBorCheck
    Left = 42
    Top = 129
    Width = 132
    Height = 20
    HelpContext = 477
    Caption = 'Print Consolidated list :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 6
    TabStop = True
    TextId = 0
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 161
    Top = 16
    Width = 80
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object Sum6: TBorCheck
    Left = 12
    Top = 72
    Width = 162
    Height = 20
    HelpContext = 474
    Caption = 'Exclude prev printed orders :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 3
    TabStop = True
    TextId = 0
  end
  object Sum1: TCurrencyEdit
    Left = 161
    Top = 41
    Width = 43
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 2
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
  object Sum2: TBorCheck
    Left = 42
    Top = 90
    Width = 132
    Height = 20
    HelpContext = 475
    Caption = 'Auto-enter picked qty :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    TabStop = True
    TextId = 0
  end
end
