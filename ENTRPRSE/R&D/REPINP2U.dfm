inherited RepInpMsg1: TRepInpMsg1
  Left = 631
  Top = 383
  HelpContext = 620
  ActiveControl = CurrF
  Caption = 'due Report'
  ClientHeight = 198
  ClientWidth = 308
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 6
    Width = 296
    Height = 165
  end
  object Label81: Label8 [1]
    Left = 33
    Top = 21
    Width = 97
    Height = 14
    Alignment = taRightJustify
    Caption = 'Report for Currency'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [2]
    Left = 35
    Top = 68
    Width = 95
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Maximum due date'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8 [3]
    Left = 28
    Top = 96
    Width = 102
    Height = 14
    Alignment = taRightJustify
    Caption = 'Include Payment type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label811: Label8 [4]
    Left = 192
    Top = 21
    Width = 29
    Height = 14
    Alignment = taRightJustify
    Caption = 'Txlate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lblAccountTypes: Label8 [5]
    Left = 29
    Top = 123
    Width = 101
    Height = 14
    Alignment = taRightJustify
    Caption = 'Include Trader Types'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 71
    Top = 172
    TabOrder = 8
  end
  inherited ClsCP1Btn: TButton
    Left = 157
    Top = 172
    TabOrder = 9
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 5
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 136
    Top = 17
    Width = 53
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
    TabOrder = 0
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 136
    Top = 65
    Width = 80
    Height = 22
    HelpContext = 631
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
  object IncSDueF: TBorCheck
    Left = 17
    Top = 42
    Width = 132
    Height = 20
    HelpContext = 1168
    Caption = 'Include PPD Due'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    TabStop = True
    TextId = 0
  end
  object AgeX: TSBSComboBox
    Left = 136
    Top = 92
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
      'All'
      'Cheque'
      'Electronic (BACS)'
      '2 Cheque (Alt)'
      '3 Cheque (Alt)')
    MaxListWidth = 0
  end
  object CurrF2: TSBSComboBox
    Tag = 1
    Left = 225
    Top = 17
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
    TabOrder = 1
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object cbAccountTypes: TSBSComboBox
    Left = 136
    Top = 119
    Width = 157
    Height = 22
    HelpContext = 8098
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ItemIndex = 0
    ParentFont = False
    TabOrder = 6
    Text = 'Customers & Consumers'
    Items.Strings = (
      'Customers & Consumers'
      'Customers Only'
      'Consumers Only')
    MaxListWidth = 0
  end
  object chkDueSummary: TBorCheck
    Left = 16
    Top = 142
    Width = 132
    Height = 20
    HelpContext = 1168
    Caption = 'Summary Only Report'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 7
    TabStop = True
    TextId = 0
  end
end
