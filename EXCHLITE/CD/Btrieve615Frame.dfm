object fraBtrieve615: TfraBtrieve615
  Left = 0
  Top = 0
  Width = 540
  Height = 256
  HelpContext = 1
  TabOrder = 0
  object lblTitle: TLabel
    Left = 8
    Top = 6
    Width = 91
    Height = 20
    Caption = 'WARNING!'
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
    Width = 494
    Height = 33
    AutoSize = False
    Caption = 
      'An older version of the Btrieve database has been detected - you' +
      ' MUST follow these instructions to avoid conflicts with <APPTITL' +
      'E>.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lblOKLink: TLabel
    Left = 216
    Top = 152
    Width = 15
    Height = 13
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblOKLinkClick
  end
  object lblCancelLink: TLabel
    Left = 244
    Top = 152
    Width = 33
    Height = 13
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblCancelLinkClick
  end
  object Label2: TLabel
    Left = 46
    Top = 79
    Width = 421
    Height = 14
    AutoSize = False
    Caption = 'as IRIS Practice software, select this option.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    OnClick = Label2Click
  end
  object Label3: TLabel
    Left = 46
    Top = 122
    Width = 404
    Height = 17
    AutoSize = False
    Caption = 'select this option (not recommended).'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    OnClick = Label3Click
  end
  object radUsing615: TRadioButton
    Left = 28
    Top = 64
    Width = 443
    Height = 17
    Caption = 
      'Recommended: If you are actively using any applications which us' +
      'e Btrieve v6.15, such '
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TabStop = True
  end
  object radUsingWGE: TRadioButton
    Left = 28
    Top = 107
    Width = 436
    Height = 17
    Caption = 
      'If you are not using IRIS Practice software, or other products t' +
      'hat use Btrieve v6.15 then'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
end
