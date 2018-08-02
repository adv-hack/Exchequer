inherited CompDetail3: TCompDetail3
  HelpContext = 37
  ActiveControl = cpPhone
  Caption = 'CompDetail3'
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited TitleLbl: TLabel
    Caption = 'Company Details'
  end
  inherited InstrLbl: TLabel
    Height = 16
    Caption = 'Telephone Number'
  end
  object Label88: Label8 [3]
    Left = 167
    Top = 99
    Width = 58
    Height = 14
    Caption = 'Fax Number'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [4]
    Left = 170
    Top = 147
    Width = 38
    Height = 14
    Alignment = taRightJustify
    Caption = 'Country'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited HelpBtn: TButton
    HelpContext = 10022
    TabOrder = 4
  end
  inherited Panel1: TPanel
    TabOrder = 3
  end
  inherited ExitBtn: TButton
    TabOrder = 5
  end
  inherited BackBtn: TButton
    TabOrder = 6
  end
  inherited NextBtn: TButton
    TabOrder = 7
  end
  object cpPhone: Text8Pt
    Tag = 1
    Left = 183
    Top = 66
    Width = 229
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 15
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TextId = 0
    ViaSBtn = False
  end
  object cpFax: Text8Pt
    Tag = 1
    Left = 183
    Top = 116
    Width = 229
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 15
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TextId = 0
    ViaSBtn = False
  end
  object cpCountry: TSBSComboBox
    Tag = 1
    Left = 183
    Top = 164
    Width = 229
    Height = 22
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 2
    Items.Strings = (
      'Australia'
      'New Zealand'
      'Singapore'
      'South Africa'
      'United Kingdom')
    MaxListWidth = 0
  end
end
