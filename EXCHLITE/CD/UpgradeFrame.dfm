object fraUpgrade: TfraUpgrade
  Left = 0
  Top = 0
  Width = 540
  Height = 256
  TabOrder = 0
  object lblTitle: TLabel
    Left = 8
    Top = 6
    Width = 245
    Height = 20
    Caption = 'Upgrade Existing <APPTITLE>'
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
    Width = 330
    Height = 13
    Caption = 
      'This CD allows you to upgrade an existing installation of <APPTI' +
      'TLE>.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label17: TLabel
    Left = 38
    Top = 221
    Width = 467
    Height = 31
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'NOTE: Due to Notebook controls not working within TFrames there ' +
      'are multiple panels at the top of this window with different err' +
      'ors on them.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
    WordWrap = True
  end
  object panNotFound: TPanel
    Left = 5
    Top = 44
    Width = 535
    Height = 74
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    Visible = False
    object lblNotFound: TLabel
      Left = 4
      Top = 7
      Width = 496
      Height = 36
      AutoSize = False
      Caption = 
        'An existing installation of <APPTITLE> could not be found, eithe' +
        'r find the directory manually or cancel the Upgrade.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object lblFindLITEDir: TLabel
      Left = 390
      Top = 45
      Width = 110
      Height = 13
      Cursor = crHandPoint
      Alignment = taRightJustify
      Caption = 'Find Directory Manually'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = lblFindLITEDirClick
    end
    object lblBackToOptions: TLabel
      Left = 4
      Top = 45
      Width = 25
      Height = 13
      Cursor = crHandPoint
      Caption = 'Back'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = lblBackToOptionsClick
    end
  end
  object panFound: TPanel
    Left = 5
    Top = 44
    Width = 529
    Height = 98
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    Visible = False
    object lblFound: TLabel
      Left = 4
      Top = 7
      Width = 355
      Height = 13
      Caption = 
        'An existing installation of <APPTITLE> was found in the followin' +
        'g directory:-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblFoundDir: TLabel
      Left = 15
      Top = 29
      Width = 474
      Height = 13
      AutoSize = False
      Caption = '<FoundDir>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblBackToOptions2: TLabel
      Left = 4
      Top = 53
      Width = 25
      Height = 13
      Cursor = crHandPoint
      Caption = 'Back'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = lblBackToOptionsClick
    end
    object lblUpgrade: TLabel
      Left = 459
      Top = 52
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
      OnClick = lblUpgradeClick
    end
  end
end
