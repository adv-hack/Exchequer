inherited JobClsInp: TJobClsInp
  Caption = 'Transfer work in progress...'
  ClientHeight = 212
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 173
  end
  object Label81: Label8 [1]
    Left = 16
    Top = 27
    Width = 269
    Height = 81
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  object Label82: Label8 [2]
    Left = 22
    Top = 119
    Width = 107
    Height = 14
    Alignment = taRightJustify
    Caption = ' W.I.P Analysis Code : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Top = 183
    TabOrder = 1
  end
  inherited ClsCP1Btn: TButton
    Top = 183
    TabOrder = 2
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 3
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 132
    Top = 114
    Width = 80
    Height = 22
    HelpContext = 658
    Color = clWhite
    EditMask = '>ccccccccc;0; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 9
    ParentFont = False
    TabOrder = 0
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
  end
end
