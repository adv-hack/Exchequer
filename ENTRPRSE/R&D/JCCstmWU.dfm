inherited JCustomTag: TJCustomTag
  HelpContext = 1121
  Caption = 'WIP Custom Tag'
  ClientHeight = 208
  ClientWidth = 301
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 7
    Top = 4
    Height = 163
  end
  object Label86: Label8 [1]
    Left = 17
    Top = 33
    Width = 90
    Height = 14
    Alignment = taRightJustify
    Caption = 'Date Range. from :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8 [2]
    Left = 195
    Top = 35
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
  object Label810: Label8 [3]
    Left = 44
    Top = 59
    Width = 66
    Height = 14
    Alignment = taRightJustify
    Caption = 'Tag up to % : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [4]
    Left = 27
    Top = 85
    Width = 84
    Height = 14
    Alignment = taRightJustify
    Caption = 'Sub Cont./Empl  : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object AccLab: Label8 [5]
    Left = 17
    Top = 111
    Width = 93
    Height = 14
    Alignment = taRightJustify
    Caption = 'Account No. filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Top = 176
    TabOrder = 1
  end
  inherited ClsCP1Btn: TButton
    Top = 176
    TabOrder = 2
  end
  inherited SBSPanel1: TSBSPanel
    Top = 162
    TabOrder = 0
  end
  object PJDChk: TBorCheck
    Left = 15
    Top = 134
    Width = 113
    Height = 20
    HelpContext = 1122
    Caption = 'Reset existing tags'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 8
    TabStop = True
    TextId = 0
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 112
    Top = 31
    Width = 80
    Height = 22
    HelpContext = 682
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
    TabOrder = 3
    Placement = cpAbove
  end
  object I2TransDateF: TEditDate
    Tag = 1
    Left = 206
    Top = 31
    Width = 80
    Height = 22
    HelpContext = 682
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
    TabOrder = 4
    Placement = cpAbove
  end
  object AgeInt: TCurrencyEdit
    Left = 112
    Top = 56
    Width = 62
    Height = 22
    Hint = 
      'Enter Run Noumber.|Enter the run number of the posting report yo' +
      'u wish to reprint. 0 for unposted items, -1 for all posting runs' +
      '.'
    HelpContext = 650
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00% ')
    ParentFont = False
    TabOrder = 5
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00% ;###,###,##0.00%-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object SubCF: Text8Pt
    Tag = 1
    Left = 112
    Top = 81
    Width = 80
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 652
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnExit = SubCFExit
    TextId = 0
    ViaSBtn = False
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 113
    Top = 107
    Width = 80
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 652
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
end
