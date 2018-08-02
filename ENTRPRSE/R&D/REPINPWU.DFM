inherited RepInpMsgW: TRepInpMsgW
  HelpContext = 706
  Caption = 'Returns'
  ClientHeight = 197
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 157
  end
  object Label85: Label8 [1]
    Left = 59
    Top = 72
    Width = 85
    Height = 14
    Alignment = taRightJustify
    Caption = 'Tax Period/Year : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [2]
    Left = 47
    Top = 97
    Width = 178
    Height = 14
    Caption = 'Period = Number of last Month in Tax '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [3]
    Left = 47
    Top = 109
    Width = 99
    Height = 14
    Alignment = taCenter
    Caption = 'Returns, i.e. Jan=01.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [4]
    Left = 20
    Top = 21
    Width = 121
    Height = 14
    Alignment = taRightJustify
    Caption = 'Rate for Fringe Benefits :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8 [5]
    Left = 17
    Top = 47
    Width = 124
    Height = 14
    Alignment = taRightJustify
    Caption = 'Rate for Imported Goods :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Top = 167
    TabOrder = 5
  end
  inherited ClsCP1Btn: TButton
    Top = 167
    TabOrder = 6
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 4
  end
  object I1PrYrF: TEditPeriod
    Tag = 1
    Left = 143
    Top = 69
    Width = 59
    Height = 22
    HelpContext = 656
    AutoSelect = False
    EditMask = '00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 7
    ParentFont = False
    TabOrder = 2
    Text = '011996'
    OnExit = I1PrYrFExit
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
  end
  object Sum1: TBorCheck
    Left = 10
    Top = 128
    Width = 149
    Height = 20
    HelpContext = 655
    Caption = 'Close Period after Report :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 3
    TabStop = True
    TextId = 0
  end
  object Id3VATF: TSBSComboBox
    Tag = 1
    Left = 143
    Top = 16
    Width = 98
    Height = 22
    HelpContext = 249
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MaxLength = 1
    ParentFont = False
    TabOrder = 0
    AllowChangeInExit = True
    MaxListWidth = 75
    Validate = True
  end
  object Id4VATF: TSBSComboBox
    Tag = 1
    Left = 143
    Top = 42
    Width = 98
    Height = 22
    HelpContext = 249
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MaxLength = 1
    ParentFont = False
    TabOrder = 1
    AllowChangeInExit = True
    MaxListWidth = 75
    Validate = True
  end
end
