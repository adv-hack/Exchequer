inherited PickInpMsg: TPickInpMsg
  HelpContext = 495
  Caption = 'Generate Picking List'
  ClientHeight = 229
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 191
  end
  object Label87: Label8 [1]
    Left = 35
    Top = 21
    Width = 124
    Height = 14
    Alignment = taRightJustify
    Caption = 'Print up to Delivery Date : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [2]
    Left = 36
    Top = 44
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
  object Label81: Label8 [3]
    Left = 16
    Top = 68
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
  object Label82: Label8 [4]
    Left = 17
    Top = 81
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
    Top = 203
    TabOrder = 11
  end
  inherited ClsCP1Btn: TButton
    Left = 152
    Top = 203
    TabOrder = 12
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 0
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 161
    Top = 17
    Width = 80
    Height = 22
    HelpContext = 473
    AutoSelect = False
    Color = clWhite
    EditMask = '00/00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 1
    Placement = cpAbove
  end
  object Sum2: TBorCheck
    Left = 42
    Top = 112
    Width = 132
    Height = 20
    HelpContext = 475
    Caption = 'Auto-enter picked qty :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TabStop = True
    TextId = 0
  end
  object Sum3: TBorCheck
    Left = 34
    Top = 130
    Width = 140
    Height = 20
    HelpContext = 476
    Caption = 'Print list for each order :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 7
    TabStop = True
    TextId = 0
  end
  object Sum4: TBorCheck
    Left = 42
    Top = 149
    Width = 132
    Height = 20
    HelpContext = 477
    Caption = 'Print Consolidated list :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 9
    TabStop = True
    TextId = 0
  end
  object Sum5: TBorCheck
    Left = 35
    Top = 168
    Width = 139
    Height = 20
    HelpContext = 478
    Caption = 'Explode Bill of Materials :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 10
    TabStop = True
    TextId = 0
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 161
    Top = 42
    Width = 80
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
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
  object Sum6: TBorCheck
    Left = 12
    Top = 94
    Width = 162
    Height = 20
    HelpContext = 474
    Caption = 'Exclude prev printed orders :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    TabStop = True
    TextId = 0
  end
  object Sum1: TCurrencyEdit
    Left = 161
    Top = 67
    Width = 43
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 2
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
  object IncAllBins: TBorCheck
    Left = 180
    Top = 112
    Width = 107
    Height = 20
    HelpContext = 1580
    Caption = 'Inc. all avail bins:'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 6
    TabStop = True
    TextId = 0
  end
  object ExcNPick1: TBorCheck
    Left = 180
    Top = 130
    Width = 107
    Height = 20
    HelpContext = 1581
    Caption = 'Excl. non picked:'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 8
    TabStop = True
    TextId = 0
    Visible = False
  end
end
