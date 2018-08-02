inherited RepJCEInp: TRepJCEInp
  Left = 373
  Top = 246
  HelpContext = 1217
  Caption = 'Employee List'
  ClientHeight = 175
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 141
  end
  object Label83: Label8 [1]
    Left = 30
    Top = 63
    Width = 107
    Height = 14
    Alignment = taRightJustify
    Caption = 'Employee Type Filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [2]
    Left = 58
    Top = 90
    Width = 79
    Height = 14
    Alignment = taRightJustify
    Caption = 'Sort Report by : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Top = 151
    TabOrder = 3
  end
  inherited ClsCP1Btn: TButton
    Top = 151
    TabOrder = 4
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 5
  end
  object SxSF: TSBSComboBox
    Tag = 1
    Left = 137
    Top = 60
    Width = 88
    Height = 22
    HelpContext = 8066
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
    MaxListWidth = 90
    Validate = True
  end
  object Sum1: TBorCheck
    Left = 20
    Top = 31
    Width = 132
    Height = 20
    HelpContext = 8066
    Caption = 'Show Time Rates :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 0
    TabStop = True
    TextId = 0
  end
  object SortXCB: TSBSComboBox
    Tag = 1
    Left = 137
    Top = 87
    Width = 88
    Height = 22
    HelpContext = 8066
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
    Items.Strings = (
      'Code'
      'Surname'
      'Sub Contract Name')
    MaxListWidth = 90
    Validate = True
  end
end
