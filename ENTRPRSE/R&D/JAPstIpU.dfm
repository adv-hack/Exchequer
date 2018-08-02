inherited JPostAppFilt: TJPostAppFilt
  HelpContext = 1121
  Caption = 'Post Job Costing Applications'
  ClientHeight = 268
  ClientWidth = 301
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 7
    Top = 4
    Height = 223
  end
  object Label86: Label8 [1]
    Left = 12
    Top = 16
    Width = 277
    Height = 35
    AutoSize = False
    Caption = 'Job Application Posting'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -24
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [2]
    Left = 40
    Top = 56
    Width = 103
    Height = 14
    Alignment = taRightJustify
    Caption = 'Process only tag No :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object AccLab: Label8 [3]
    Left = 48
    Top = 84
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
  object Label82: Label8 [4]
    Left = 33
    Top = 110
    Width = 107
    Height = 14
    Alignment = taRightJustify
    Caption = 'Sub contractor. filter : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Top = 240
    TabOrder = 7
  end
  inherited ClsCP1Btn: TButton
    Top = 240
    TabOrder = 8
  end
  inherited SBSPanel1: TSBSPanel
    Top = 162
    TabOrder = 0
  end
  object PCOMChk: TBorCheck
    Left = 42
    Top = 134
    Width = 173
    Height = 20
    HelpContext = 1122
    Caption = 'Consolidate for same account'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    TabStop = True
    TextId = 0
  end
  object PJDChk: TBorCheck
    Left = 18
    Top = 152
    Width = 197
    Height = 20
    HelpContext = 1122
    Caption = 'Print Invoice Transactions'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TabStop = True
    TextId = 0
  end
  object PTSChk: TBorCheck
    Left = 28
    Top = 172
    Width = 187
    Height = 20
    HelpContext = 1123
    Caption = 'Print Applications as Certificates'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 6
    TabStop = True
    TextId = 0
  end
  object Sum1: TCurrencyEdit
    Tag = 1
    Left = 150
    Top = 54
    Width = 32
    Height = 22
    HelpContext = 482
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 2
    ParentFont = False
    TabOrder = 1
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 150
    Top = 80
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
    TabOrder = 2
    OnClick = ACFFClick
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
  object EmpF: Text8Pt
    Tag = 1
    Left = 150
    Top = 106
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
    TabOrder = 3
    OnExit = EmpFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Cust = True
    ShowHilight = True
  end
end
