inherited RepJCCISVInp: TRepJCCISVInp
  Left = 437
  Top = 250
  HelpContext = 1217
  Caption = 'Print '
  ClientHeight = 175
  ClientWidth = 343
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Width = 336
    Height = 141
    HelpContext = 2156
  end
  object Label83: Label8 [1]
    Left = 79
    Top = 26
    Width = 35
    Height = 14
    Alignment = taRightJustify
    Caption = ' Type : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [2]
    Left = 117
    Top = 50
    Width = 28
    Height = 14
    Alignment = taCenter
    Caption = 'Prefix'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8 [3]
    Left = 201
    Top = 50
    Width = 83
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Counter '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 93
    Top = 151
    TabOrder = 4
  end
  inherited ClsCP1Btn: TButton
    Left = 179
    Top = 151
    TabOrder = 5
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 6
  end
  object SxSF: TSBSComboBox
    Tag = 1
    Left = 114
    Top = 23
    Width = 88
    Height = 22
    HelpContext = 2157
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
    TabOrder = 0
    OnChange = SxSFChange
    Items.Strings = (
      'CIS23'
      'CIS24'
      'CIS25')
    MaxListWidth = 90
    Validate = True
  end
  object V23CF: Text8Pt
    Left = 199
    Top = 66
    Width = 87
    Height = 22
    Color = clWhite
    EditMask = '9999999999;0;_'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 3
    TextId = 0
    ViaSBtn = False
  end
  object V23PF: Text8Pt
    Left = 115
    Top = 66
    Width = 80
    Height = 22
    CharCase = ecUpperCase
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 5
    ParentFont = False
    TabOrder = 2
    TextId = 0
    ViaSBtn = False
  end
  object cbRenum: TBorCheck
    Left = 25
    Top = 66
    Width = 85
    Height = 20
    Caption = 'Renumber'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    TabStop = True
    TextId = 0
    OnClick = cbRenumClick
  end
end
