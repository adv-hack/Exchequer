inherited RETInpMsg: TRETInpMsg
  Left = 329
  HelpContext = 492
  Caption = 'Returns'
  ClientHeight = 187
  ClientWidth = 336
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 6
    Width = 325
    Height = 153
  end
  object Label87: Label8 [1]
    Left = 201
    Top = 21
    Width = 47
    Height = 14
    Alignment = taRightJustify
    Caption = 'Run No. : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [2]
    Left = 62
    Top = 52
    Width = 115
    Height = 14
    Alignment = taRightJustify
    Caption = 'Generate for Location : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [3]
    Left = 46
    Top = 30
    Width = 74
    Height = 14
    Caption = '(0 includes all)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [4]
    Left = 46
    Top = 17
    Width = 103
    Height = 14
    Alignment = taRightJustify
    Caption = 'Process only tag No :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 85
    Top = 161
    TabOrder = 8
  end
  inherited ClsCP1Btn: TButton
    Left = 171
    Top = 161
    TabOrder = 9
  end
  inherited SBSPanel1: TSBSPanel
    Left = 243
    Top = 168
    TabOrder = 10
  end
  object Sum2: TBorCheck
    Left = 13
    Top = 75
    Width = 182
    Height = 20
    HelpContext = 483
    Caption = 'Print Credits :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 3
    TabStop = True
    TextId = 0
  end
  object AgeInt: TCurrencyEdit
    Left = 250
    Top = 17
    Width = 52
    Height = 22
    HelpContext = 482
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '1 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1
  end
  object PDNote: TSBSComboBox
    Left = 200
    Top = 74
    Width = 103
    Height = 22
    HelpContext = 483
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 4
    ExtendedList = True
    MaxListWidth = 250
  end
  object PrnScrnB: TBorCheck
    Left = 48
    Top = 130
    Width = 147
    Height = 19
    HelpContext = 490
    Caption = 'Print to Screen :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 7
    TabStop = True
    TextId = 0
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 200
    Top = 46
    Width = 103
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
    TabOrder = 2
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object Sum1: TCurrencyEdit
    Left = 156
    Top = 17
    Width = 32
    Height = 22
    HelpContext = 482
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '99 ')
    MaxLength = 2
    ParentFont = False
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
    Value = 99
  end
  object PInvDoc: TSBSComboBox
    Left = 200
    Top = 101
    Width = 103
    Height = 22
    HelpContext = 483
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 6
    ExtendedList = True
    MaxListWidth = 250
  end
  object Sum3: TBorCheck
    Left = 95
    Top = 102
    Width = 100
    Height = 20
    HelpContext = 483
    Caption = 'Print Invoice :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TabStop = True
    TextId = 0
  end
end
