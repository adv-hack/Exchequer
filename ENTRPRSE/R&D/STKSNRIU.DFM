inherited SerRangeFrm: TSerRangeFrm
  HelpContext = 1049
  Caption = 'Generate Range'
  ClientHeight = 183
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 142
  end
  object Label83: Label8 [1]
    Left = 27
    Top = 24
    Width = 65
    Height = 14
    Alignment = taRightJustify
    Caption = 'Range start : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [2]
    Left = 165
    Top = 24
    Width = 69
    Height = 14
    Alignment = taRightJustify
    Caption = 'Range finish : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 66
    Top = 153
    TabOrder = 5
  end
  inherited ClsCP1Btn: TButton
    Left = 152
    Top = 153
    TabOrder = 6
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 0
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 16
    Top = 42
    Width = 118
    Height = 22
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
  object ACTF: Text8Pt
    Tag = 1
    Left = 158
    Top = 42
    Width = 118
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
  end
  object BorRadio1: TBorRadio
    Left = 20
    Top = 85
    Width = 98
    Height = 20
    Caption = 'Generate Serial'
    CheckColor = clWindowText
    Checked = True
    GroupIndex = 1
    TabOrder = 3
    TabStop = True
    TextId = 0
  end
  object BorRadio2: TBorRadio
    Left = 161
    Top = 85
    Width = 64
    Height = 20
    Caption = 'Batch'
    CheckColor = clWindowText
    GroupIndex = 1
    TabOrder = 4
    TextId = 0
  end
end
