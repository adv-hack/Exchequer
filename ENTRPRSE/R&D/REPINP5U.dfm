inherited RepInpMsg5: TRepInpMsg5
  Left = 337
  Top = 213
  HelpContext = 622
  Caption = 'Debt Chase Letters'
  ClientHeight = 210
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 176
  end
  object Label83: Label8 [1]
    Left = 16
    Top = 31
    Width = 125
    Height = 14
    Alignment = taRightJustify
    Caption = 'Account No. range from : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [2]
    Left = 200
    Top = 31
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
  object Label85: Label8 [3]
    Left = 18
    Top = 89
    Width = 123
    Height = 14
    Alignment = taRightJustify
    Caption = 'Debt Chase Letter (0-3) : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [4]
    Left = 29
    Top = 60
    Width = 112
    Height = 14
    Alignment = taRightJustify
    Caption = 'Include Account Type : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label89: Label8 [5]
    Left = 38
    Top = 123
    Width = 103
    Height = 14
    Alignment = taRightJustify
    Caption = 'Produce Letters for : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 66
    Top = 183
    TabOrder = 6
  end
  inherited ClsCP1Btn: TButton
    Left = 152
    Top = 183
    TabOrder = 7
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 8
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 145
    Top = 29
    Width = 49
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 642
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
  object ACTF: Text8Pt
    Tag = 1
    Left = 220
    Top = 29
    Width = 49
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 642
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object EMLF: TSBSComboBox
    Tag = 1
    Left = 145
    Top = 56
    Width = 126
    Height = 22
    HelpContext = 645
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 2
    Items.Strings = (
      'Statement Accounts'
      'Non Statement Accounts'
      'All Accounts')
    MaxListWidth = 77
    Validate = True
  end
  object FilterX: TSBSComboBox
    Left = 145
    Top = 119
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
      'All Accounts'
      'Hard Copy '
      'Fax '
      'Email')
    MaxListWidth = 0
  end
  object chkBackdatedTransactions: TBorCheck
    Left = 14
    Top = 149
    Width = 184
    Height = 20
    HelpContext = 6721
    Caption = 'Check for backdated transactions'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TabStop = True
    TextId = 0
  end
  object cbAgeInt: TSBSComboBox
    Left = 145
    Top = 85
    Width = 46
    Height = 22
    HelpContext = 324
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ItemIndex = 0
    ParentFont = False
    TabOrder = 3
    Text = '0'
    Items.Strings = (
      '0'
      '1'
      '2'
      '3')
    MaxListWidth = 0
  end
end
