inherited CompDetail4: TCompDetail4
  Left = 568
  Top = 79
  HelpContext = 38
  ActiveControl = cpVATNo
  Caption = 'CompDetail4'
  ClientHeight = 310
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 265
  end
  inherited TitleLbl: TLabel
    Top = 11
    Caption = 'Company Details'
  end
  inherited InstrLbl: TLabel
    Height = 15
    Caption = 'Company VAT Number'
  end
  object Label89: Label8 [3]
    Left = 167
    Top = 95
    Width = 118
    Height = 14
    Caption = 'Date of last VAT returns'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8 [4]
    Left = 167
    Top = 145
    Width = 184
    Height = 14
    Caption = 'Monthly interval between VAT returns'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited imgSide: TImage
    Height = 154
  end
  object Label81: Label8 [6]
    Left = 167
    Top = 194
    Width = 222
    Height = 14
    Caption = 'VAT Scheme   (see help for more information)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited HelpBtn: TButton
    Top = 282
    HelpContext = 10023
    TabOrder = 6
  end
  inherited Panel1: TPanel
    Height = 248
    TabOrder = 5
    inherited Image1: TImage
      Height = 246
    end
  end
  inherited ExitBtn: TButton
    Top = 282
    TabOrder = 7
  end
  inherited BackBtn: TButton
    Top = 282
    TabOrder = 8
  end
  inherited NextBtn: TButton
    Top = 282
    TabOrder = 9
  end
  object cpLastRet: TEditDate
    Tag = 1
    Left = 184
    Top = 112
    Width = 63
    Height = 22
    AutoSelect = False
    EditMask = '00/00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 1
    Placement = cpAbove
  end
  object cpVATMonth: TCurrencyEdit
    Tag = 1
    Left = 184
    Top = 162
    Width = 46
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 2
    ParentFont = False
    TabOrder = 2
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object cpVatIntra: TBorCheck
    Tag = 1
    Left = 167
    Top = 243
    Width = 255
    Height = 20
    Align = alRight
    Caption = 'Generate VAT Intra SSD Report?'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    TabStop = True
    TextId = 0
  end
  object cpVATNo: Text8Pt
    Tag = 1
    Left = 184
    Top = 66
    Width = 156
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TextId = 0
    ViaSBtn = False
  end
  object lstVATScheme: TComboBox
    Left = 184
    Top = 211
    Width = 241
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 3
    Items.Strings = (
      'Cash Accounting'
      'Invoice (standard)')
  end
end
