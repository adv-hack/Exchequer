inherited GLReconFrm: TGLReconFrm
  HelpContext = 560
  Caption = 'General Ledger Bank Reconciliation'
  PixelsPerInch = 96
  TextHeight = 14
  object Label82: Label8 [1]
    Left = 32
    Top = 34
    Width = 103
    Height = 14
    Alignment = taRightJustify
    Caption = 'Report for Currency :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [2]
    Left = 57
    Top = 63
    Width = 81
    Height = 14
    Alignment = taRightJustify
    Caption = 'Bank G/L Code : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    TabOrder = 3
  end
  inherited ClsCP1Btn: TButton
    TabOrder = 4
    OnClick = ClsCP1BtnClick
  end
  object CurrF: TSBSComboBox
    Tag = 1
    Left = 142
    Top = 31
    Width = 57
    Height = 22
    HelpContext = 561
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
    OnExit = CurrFExit
    AllowChangeInExit = True
    ExtendedList = True
    MaxListWidth = 90
    Validate = True
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 140
    Top = 59
    Width = 69
    Height = 22
    HelpContext = 562
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
  end
end
