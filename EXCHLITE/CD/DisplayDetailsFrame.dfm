object fraDisplaysDets: TfraDisplaysDets
  Left = 0
  Top = 0
  Width = 540
  Height = 256
  HelpContext = 65
  TabOrder = 0
  object lblTitle: TLabel
    Left = 8
    Top = 6
    Width = 157
    Height = 20
    Caption = 'Install <APPTITLE>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblIntro: TLabel
    Left = 9
    Top = 27
    Width = 496
    Height = 34
    AutoSize = False
    Caption = 
      'The following licence information has been specified for your <T' +
      'YPE> of <APPTITLE>, please check this information carefully befo' +
      're continuing:-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    OnDblClick = lblIntroDblClick
  end
  object lblContinue: TLabel
    Left = 458
    Top = 136
    Width = 42
    Height = 13
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = 'Continue'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblContinueClick
  end
  object lblInfo: TLabel
    Left = 10
    Top = 63
    Width = 100
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'CD-Key:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object Label1: TLabel
    Left = 10
    Top = 81
    Width = 100
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Company Name:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object Label3: TLabel
    Left = 10
    Top = 99
    Width = 100
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Version:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object Label7: TLabel
    Left = 10
    Top = 117
    Width = 100
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Pervasive.SQL:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblCDKey: TLabel
    Left = 119
    Top = 63
    Width = 370
    Height = 13
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblCompanyName: TLabel
    Left = 119
    Top = 81
    Width = 370
    Height = 13
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblLITEVer: TLabel
    Left = 119
    Top = 99
    Width = 370
    Height = 13
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
  object lblPervasive: TLabel
    Left = 119
    Top = 117
    Width = 370
    Height = 13
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
  end
end
