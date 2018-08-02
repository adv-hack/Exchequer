inherited frmRepInpAccountDetails: TfrmRepInpAccountDetails
  Left = 480
  Top = 290
  HelpContext = 701
  Caption = 'Misc Account Report Dlg'
  ClientHeight = 108
  ClientWidth = 323
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 6
    Width = 311
    Height = 73
  end
  object lblAccountRange: Label8 [1]
    Left = 16
    Top = 19
    Width = 119
    Height = 14
    Alignment = taRightJustify
    Caption = 'Account No. range from '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lblAccountTo: Label8 [2]
    Left = 218
    Top = 19
    Width = 9
    Height = 14
    Alignment = taRightJustify
    Caption = 'to'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lblIncludeAccountTypes: Label8 [3]
    Left = 34
    Top = 48
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
    Left = 79
    Top = 82
    TabOrder = 3
  end
  inherited ClsCP1Btn: TButton
    Left = 165
    Top = 82
    TabOrder = 4
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 5
  end
  object edtFromAccountCode: Text8Pt
    Tag = 1
    Left = 139
    Top = 17
    Width = 75
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
    OnExit = edtFromAccountCodeExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object edtToAccountCode: Text8Pt
    Tag = 1
    Left = 232
    Top = 17
    Width = 75
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
    TabOrder = 1
    OnExit = edtFromAccountCodeExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object cbAccountTypes: TSBSComboBox
    Tag = 1
    Left = 139
    Top = 44
    Width = 168
    Height = 22
    HelpContext = 8098
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
    TabOrder = 2
    Text = 'Customers & Consumers'
    Items.Strings = (
      'Customers & Consumers'
      'Customers Only'
      'Consumers Only')
    MaxListWidth = 77
    Validate = True
  end
end
