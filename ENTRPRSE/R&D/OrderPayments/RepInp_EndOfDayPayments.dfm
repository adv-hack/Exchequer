inherited frmRepInpEndOfDayPayments: TfrmRepInpEndOfDayPayments
  Left = 698
  Top = 339
  HelpContext = 9003
  Caption = 'End of Day Payments Report'
  ClientHeight = 130
  ClientWidth = 328
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 12
    Top = 71
    Width = 31
    Height = 27
  end
  object lblAccountRange: Label8 [1]
    Left = 21
    Top = 15
    Width = 84
    Height = 14
    Alignment = taRightJustify
    Caption = 'Date Range from '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lblAccountTo: Label8 [2]
    Left = 188
    Top = 15
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
  object Label81: Label8 [3]
    Left = 12
    Top = 46
    Width = 93
    Height = 14
    Alignment = taRightJustify
    Caption = 'Account Code filter'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [4]
    Left = 196
    Top = 46
    Width = 111
    Height = 14
    Alignment = taRightJustify
    Caption = '(blank = All Customers)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [5]
    Left = 54
    Top = 75
    Width = 51
    Height = 14
    Alignment = taRightJustify
    Caption = 'Sort Order'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 81
    Top = 103
    TabOrder = 4
  end
  inherited ClsCP1Btn: TButton
    Left = 167
    Top = 103
    TabOrder = 5
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 6
  end
  object edtAccountCode: Text8Pt
    Tag = 1
    Left = 109
    Top = 43
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
    TabOrder = 2
    OnExit = edtAccountCodeExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object edtDateFrom: TEditDate
    Tag = 1
    Left = 109
    Top = 12
    Width = 75
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
    TabOrder = 0
    Placement = cpAbove
  end
  object edtDateTo: TEditDate
    Tag = 1
    Left = 201
    Top = 12
    Width = 75
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
    TabOrder = 1
    Placement = cpAbove
  end
  object cbSortOrder: TComboBox
    Tag = 1
    Left = 109
    Top = 72
    Width = 199
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 3
    Text = 'Credit Card Authorisation Number'
    Items.Strings = (
      'Credit Card Authorisation Number')
  end
end
