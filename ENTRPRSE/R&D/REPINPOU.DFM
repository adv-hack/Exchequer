inherited RepInpMsgO: TRepInpMsgO
  HelpContext = 672
  Caption = 'Stock Shortages Report'
  ClientHeight = 165
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 127
  end
  object Label89: Label8 [1]
    Left = 52
    Top = 47
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
  object Label83: Label8 [2]
    Left = 28
    Top = 21
    Width = 114
    Height = 14
    Alignment = taRightJustify
    Caption = 'Cost Centre/Dept Filter :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8 [3]
    Left = 65
    Top = 73
    Width = 79
    Height = 14
    Alignment = taRightJustify
    Caption = 'Age Report by : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object LocLab: Label8 [4]
    Left = 84
    Top = 100
    Width = 59
    Height = 14
    Alignment = taRightJustify
    Caption = 'Locn Filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Top = 137
    TabOrder = 6
  end
  inherited ClsCP1Btn: TButton
    Top = 137
    TabOrder = 7
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 0
  end
  object AccF3: Text8Pt
    Tag = 1
    Left = 145
    Top = 44
    Width = 60
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
    TabOrder = 3
    OnExit = AccF3Exit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object Id3CCF: Text8Pt
    Tag = 1
    Left = 145
    Top = 18
    Width = 46
    Height = 22
    HelpContext = 633
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object Id3DepF: Text8Pt
    Tag = 1
    Left = 196
    Top = 18
    Width = 46
    Height = 22
    HelpContext = 633
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object AgeX: TSBSComboBox
    Left = 145
    Top = 70
    Width = 78
    Height = 22
    HelpContext = 634
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 4
    Items.Strings = (
      'Days'
      'Weeks'
      'Months')
    MaxListWidth = 0
  end
  object LocF: Text8Pt
    Tag = 1
    Left = 145
    Top = 96
    Width = 46
    Height = 22
    HelpContext = 688
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnExit = LocFExit
    TextId = 0
    ViaSBtn = False
  end
end
