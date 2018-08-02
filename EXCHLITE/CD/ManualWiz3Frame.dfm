object fraManualWiz3: TfraManualWiz3
  Left = 0
  Top = 0
  Width = 540
  Height = 256
  HelpContext = 53
  TabOrder = 0
  object lblTitle: TLabel
    Left = 8
    Top = 6
    Width = 409
    Height = 20
    Caption = 'Manual Licence Entry - Counts && Database (3 of 3)'
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
    Width = 500
    Height = 21
    AutoSize = False
    Caption = 'Please enter the following details.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblCDKey: TLabel
    Left = 28
    Top = 48
    Width = 89
    Height = 13
    Caption = 'Licence Counts'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lblCompDesc: TLabel
    Left = 28
    Top = 63
    Width = 455
    Height = 19
    AutoSize = False
    Caption = 'Please enter the purchased User and Company Counts'
    WordWrap = True
  end
  object lblPervasiveTitle: TLabel
    Left = 28
    Top = 117
    Width = 194
    Height = 13
    Caption = 'Pervasive.SQL Workgroup Engine'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lblPervasiveText: TLabel
    Left = 28
    Top = 132
    Width = 455
    Height = 19
    AutoSize = False
    Caption = 
      'Please enter the Licence Key supplied for the Pervasive.SQL Work' +
      'group Engine:-'
    WordWrap = True
  end
  object lblFinish: TLabel
    Left = 481
    Top = 225
    Width = 27
    Height = 13
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = 'Finish'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblFinishClick
  end
  object lblBack: TLabel
    Left = 9
    Top = 225
    Width = 40
    Height = 13
    Cursor = crHandPoint
    Caption = '<< Back'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblBackClick
  end
  object lblPervasiveLicenceKey: TLabel
    Left = 30
    Top = 155
    Width = 40
    Height = 19
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Key'
    WordWrap = True
  end
  object Label1: TLabel
    Left = 44
    Top = 86
    Width = 27
    Height = 13
    Alignment = taRightJustify
    Caption = 'Users'
  end
  object Label5: TLabel
    Left = 148
    Top = 86
    Width = 52
    Height = 13
    Alignment = taRightJustify
    Caption = 'Companies'
  end
  object edtPervasiveLicenceKey: TEdit
    Left = 77
    Top = 152
    Width = 256
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 0
  end
  object edtUserCount: TEdit
    Left = 77
    Top = 83
    Width = 31
    Height = 21
    TabOrder = 1
    Text = '1'
  end
  object udUserCount: TUpDown
    Left = 108
    Top = 83
    Width = 12
    Height = 21
    Associate = edtUserCount
    Min = 1
    Position = 1
    TabOrder = 2
    Wrap = False
  end
  object edtCompanyCount: TEdit
    Left = 206
    Top = 83
    Width = 31
    Height = 21
    TabOrder = 3
    Text = '1'
  end
  object udCompanyCount: TUpDown
    Left = 237
    Top = 83
    Width = 12
    Height = 21
    Associate = edtCompanyCount
    Min = 1
    Max = 1000
    Position = 1
    TabOrder = 4
    Wrap = False
  end
end
