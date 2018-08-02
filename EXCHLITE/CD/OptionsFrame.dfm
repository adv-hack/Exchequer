object fraOptions: TfraOptions
  Left = 0
  Top = 0
  Width = 540
  Height = 256
  HelpContext = 58
  TabOrder = 0
  object Label1: TLabel
    Left = 8
    Top = 6
    Width = 74
    Height = 20
    Caption = 'Welcome'
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
    Width = 368
    Height = 13
    Caption = 
      'This CD allows you to install <APPTITLE>, the following options ' +
      'are available:-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 28
    Top = 52
    Width = 148
    Height = 13
    Caption = 'Install <APPTITLE> Demo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 28
    Top = 69
    Width = 474
    Height = 28
    AutoSize = False
    Caption = 
      'This option installs a single-user time limited demonstration ve' +
      'rsion of <APPTITLE> for you to evaluate.'
    WordWrap = True
  end
  object lblInstallDemo: TLabel
    Left = 443
    Top = 52
    Width = 58
    Height = 13
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = 'Install &Demo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblInstallDemoClick
  end
  object Label3: TLabel
    Left = 28
    Top = 104
    Width = 112
    Height = 13
    Caption = 'Install <APPTITLE>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 28
    Top = 121
    Width = 474
    Height = 30
    AutoSize = False
    Caption = 
      'This option installs a licensed version of <APPTITLE>, please no' +
      'te that you must have purchased <APPTITLE> in order to use this ' +
      'option.'
    WordWrap = True
  end
  object lblInstallLITE: TLabel
    Left = 474
    Top = 104
    Width = 27
    Height = 13
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = 'Install'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblInstallLITEClick
  end
  object Label4: TLabel
    Left = 28
    Top = 156
    Width = 126
    Height = 13
    Caption = 'Upgrade <APPTITLE>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label10: TLabel
    Left = 28
    Top = 169
    Width = 474
    Height = 42
    AutoSize = False
    Caption = 
      'This option upgrades an existing licensed installation of <APPTI' +
      'TLE>, this can be used to upgrade to a newer version of <APPTITL' +
      'E> or to install additional companies or features.'
    WordWrap = True
  end
  object lblUpgradeLITE: TLabel
    Left = 461
    Top = 156
    Width = 41
    Height = 13
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = 'Upgrade'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblUpgradeLITEClick
  end
end
