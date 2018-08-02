inherited RepInpMsgF: TRepInpMsgF
  HelpContext = 707
  Caption = ' - EC Sales List'
  ClientHeight = 152
  ClientWidth = 323
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Width = 312
    Height = 113
  end
  object Label86: Label8 [1]
    Left = 20
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
    Left = 201
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
  object Label81: Label8 [3]
    Left = 58
    Top = 83
    Width = 52
    Height = 14
    Alignment = taRightJustify
    Caption = 'Signatory :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
    TextId = 0
  end
  object Label82: Label8 [4]
    Left = 18
    Top = 59
    Width = 92
    Height = 14
    Alignment = taRightJustify
    Caption = 'Period M/Q/A1/A2 :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 75
    Top = 123
    TabOrder = 5
  end
  inherited ClsCP1Btn: TButton
    Left = 161
    Top = 123
    TabOrder = 6
  end
  inherited SBSPanel1: TSBSPanel
    Left = 247
    Top = 61
    TabOrder = 4
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 115
    Top = 31
    Width = 80
    Height = 22
    HelpContext = 678
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
    TabOrder = 0
    Placement = cpAbove
  end
  object I2TransDateF: TEditDate
    Tag = 1
    Left = 221
    Top = 31
    Width = 80
    Height = 22
    HelpContext = 678
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
  object ECSigF: Text8Pt
    Left = 115
    Top = 80
    Width = 121
    Height = 22
    Color = clWhite
    EditMask = '>ccccccccccccccccc;0; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 17
    ParentFont = False
    TabOrder = 3
    Visible = False
    TextId = 0
    ViaSBtn = False
  end
  object ECIEPF: Text8Pt
    Left = 115
    Top = 56
    Width = 70
    Height = 22
    Color = clWhite
    EditMask = '>cc;0; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 2
    ParentFont = False
    TabOrder = 2
    Visible = False
    OnExit = ECIEPFExit
    TextId = 0
    ViaSBtn = False
  end
end
