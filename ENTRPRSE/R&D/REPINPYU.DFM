inherited RepInpMsgW2: TRepInpMsgW2
  HelpContext = 668
  Caption = 'Works Order Work In Progress Report'
  ClientHeight = 182
  ClientWidth = 349
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Width = 340
    Height = 137
  end
  object AccLab: Label8 [1]
    Left = 62
    Top = 53
    Width = 78
    Height = 14
    Alignment = taRightJustify
    Caption = 'G/L Code filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label810: Label8 [2]
    Left = 32
    Top = 81
    Width = 107
    Height = 14
    Alignment = taRightJustify
    Caption = 'Product Code/Group : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [3]
    Left = 14
    Top = 22
    Width = 124
    Height = 14
    Alignment = taRightJustify
    Caption = 'Period/Year Range. from :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [4]
    Left = 203
    Top = 23
    Width = 15
    Height = 14
    Alignment = taRightJustify
    Caption = 'to :'
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
    Top = 151
    TabOrder = 5
  end
  inherited ClsCP1Btn: TButton
    Left = 171
    Top = 151
    TabOrder = 6
  end
  inherited SBSPanel1: TSBSPanel
    Left = 257
    Top = 122
    TabOrder = 7
  end
  object AccF3: Text8Pt
    Tag = 1
    Left = 139
    Top = 49
    Width = 60
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 1259
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnExit = AccF3Exit
    TextId = 0
    ViaSBtn = False
  end
  object StkFiltF: Text8Pt
    Left = 139
    Top = 77
    Width = 99
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 1248
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnExit = StkFiltFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Stock = True
    ShowHilight = True
  end
  object Sum1: TBorCheck
    Left = 14
    Top = 105
    Width = 139
    Height = 20
    HelpContext = 1260
    Caption = 'Include Unposted Adj'#39's :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    TabStop = True
    TextId = 0
  end
  object I1PrYrF: TEditPeriod
    Tag = 1
    Left = 140
    Top = 20
    Width = 59
    Height = 22
    HelpContext = 1258
    AutoSelect = False
    Color = clWhite
    EditMask = '00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 7
    ParentFont = False
    TabOrder = 0
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
    OnConvDate = I1PrYrFConvDate
    OnShowPeriod = I1PrYrFShowPeriod
  end
  object I2PrYrF: TEditPeriod
    Tag = 1
    Left = 219
    Top = 20
    Width = 59
    Height = 22
    HelpContext = 1258
    AutoSelect = False
    Color = clWhite
    EditMask = '00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 7
    ParentFont = False
    TabOrder = 1
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
    OnConvDate = I1PrYrFConvDate
    OnShowPeriod = I1PrYrFShowPeriod
  end
end
