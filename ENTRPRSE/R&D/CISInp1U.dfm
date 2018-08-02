inherited CISVInp: TCISVInp
  Left = 647
  Top = 261
  HelpContext = 2201
  Caption = ' Generation'
  ClientHeight = 233
  ClientWidth = 368
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 7
    Top = 4
    Width = 354
    Height = 225
    HelpContext = 2173
  end
  object Label86: Label8 [1]
    Left = 55
    Top = 34
    Width = 91
    Height = 14
    Alignment = taRightJustify
    Caption = 'For which period? '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8 [2]
    Left = 236
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
  object Label82: Label8 [3]
    Left = 28
    Top = 77
    Width = 117
    Height = 14
    Alignment = taRightJustify
    Caption = 'CIS23 Voucher Start No.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [4]
    Left = 152
    Top = 58
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
  object Label84: Label8 [5]
    Left = 258
    Top = 58
    Width = 84
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
  object Label85: Label8 [6]
    Left = 28
    Top = 103
    Width = 117
    Height = 14
    Alignment = taRightJustify
    Caption = 'CIS25 Voucher Start No.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label820: Label8 [7]
    Left = 65
    Top = 135
    Width = 80
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Sort list by '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [8]
    Left = 10
    Top = 161
    Width = 135
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Aggregate Vouchers by '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 84
    Top = 200
    TabOrder = 10
  end
  inherited ClsCP1Btn: TButton
    Left = 170
    Top = 200
    TabOrder = 11
  end
  inherited SBSPanel1: TSBSPanel
    Left = 281
    Top = 172
    TabOrder = 9
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 150
    Top = 31
    Width = 80
    Height = 22
    HelpContext = 2202
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
    Left = 256
    Top = 31
    Width = 80
    Height = 22
    HelpContext = 2202
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
    OnExit = I2TransDateFExit
    Placement = cpAbove
  end
  object V23PF: Text8Pt
    Left = 150
    Top = 74
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
  object V25PF: Text8Pt
    Left = 150
    Top = 100
    Width = 80
    Height = 22
    HelpContext = 2176
    CharCase = ecUpperCase
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 5
    ParentFont = False
    TabOrder = 4
    OnExit = V25PFExit
    TextId = 0
    ViaSBtn = False
  end
  object cbSortLF: TSBSComboBox
    Left = 150
    Top = 131
    Width = 105
    Height = 22
    HelpContext = 2175
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
    TabOrder = 6
    OnChange = cbSortLFChange
    Items.Strings = (
      'Date/Sub Contractor'
      'Date/Supplier')
    MaxListWidth = 90
    Validate = True
  end
  object cbAggcb: TSBSComboBox
    Left = 150
    Top = 157
    Width = 105
    Height = 22
    HelpContext = 2180
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
    TabOrder = 8
    Items.Strings = (
      'Tax Period'
      'Individual Payment')
    MaxListWidth = 90
    Validate = True
  end
  object V23CF: Text8Pt
    Left = 256
    Top = 74
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
  object V25CF: Text8Pt
    Left = 256
    Top = 100
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
    TabOrder = 5
    TextId = 0
    ViaSBtn = False
  end
  object cbCloseP: TBorCheck
    Left = 257
    Top = 134
    Width = 85
    Height = 20
    HelpContext = 2181
    Caption = 'Close Period'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 7
    TabStop = True
    TextId = 0
  end
end
