inherited RepJCXInp: TRepJCXInp
  HelpContext = 1216
  Caption = 'Customer Exposure Report'
  ClientHeight = 197
  ClientWidth = 356
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Top = 8
    Width = 342
    Height = 139
  end
  object AccLab: Label8 [1]
    Left = 46
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
  object Label81: Label8 [2]
    Left = 33
    Top = 71
    Width = 103
    Height = 14
    Alignment = taRightJustify
    Caption = 'Report for Currency :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label811: Label8 [3]
    Left = 222
    Top = 72
    Width = 63
    Height = 14
    Alignment = taRightJustify
    Caption = 'Translate to :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 98
    Top = 162
    TabOrder = 4
  end
  inherited ClsCP1Btn: TButton
    Left = 184
    Top = 162
    TabOrder = 5
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 6
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 160
    Top = 43
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
    TabOrder = 0
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 160
    Top = 68
    Width = 57
    Height = 22
    HelpContext = 630
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MaxLength = 3
    ParentFont = False
    TabOrder = 1
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object CurrF2: TSBSComboBox
    Tag = 1
    Left = 286
    Top = 68
    Width = 57
    Height = 22
    HelpContext = 649
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MaxLength = 3
    ParentFont = False
    TabOrder = 2
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object Sum1: TBorCheck
    Left = 30
    Top = 96
    Width = 145
    Height = 20
    HelpContext = 700
    Caption = 'Summary Report :       '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 3
    TabStop = True
    TextId = 0
  end
end
