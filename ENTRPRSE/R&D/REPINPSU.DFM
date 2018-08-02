inherited RepInpMsgS: TRepInpMsgS
  HelpContext = 1209
  Caption = 'Reprint Backing Sheet'
  PixelsPerInch = 96
  TextHeight = 14
  object Label81: Label8 [1]
    Left = 19
    Top = 45
    Width = 132
    Height = 14
    Alignment = taRightJustify
    Caption = 'Backing Sheet for Invoice : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    TabOrder = 2
  end
  inherited ClsCP1Btn: TButton
    TabOrder = 4
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 3
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 154
    Top = 40
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
  object RePInv: TBorCheck
    Left = 16
    Top = 65
    Width = 151
    Height = 20
    Caption = 'Reprint invoice as well :'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    TabStop = True
    TextId = 0
  end
end
