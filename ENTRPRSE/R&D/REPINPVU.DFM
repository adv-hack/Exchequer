inherited RepInpMsgV: TRepInpMsgV
  HelpContext = 706
  Caption = 'Returns'
  ClientHeight = 230
  ClientWidth = 301
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Width = 296
    Height = 189
  end
  object Label85: Label8 [1]
    Left = 60
    Top = 98
    Width = 85
    Height = 14
    Alignment = taRightJustify
    Caption = 'Tax Period/Year : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8 [2]
    Left = 59
    Top = 119
    Width = 178
    Height = 14
    Caption = 'Period = Number of last Month in Tax '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [3]
    Left = 59
    Top = 131
    Width = 99
    Height = 14
    Alignment = taCenter
    Caption = 'Returns, i.e. Jan=01.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8 [4]
    Left = 215
    Top = 97
    Width = 9
    Height = 14
    Caption = 'to'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8 [5]
    Left = 14
    Top = 48
    Width = 135
    Height = 14
    AutoSize = False
    Caption = 'T2.1 Tax on resale stocks :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label86: Label8 [6]
    Left = 14
    Top = 72
    Width = 135
    Height = 14
    AutoSize = False
    Caption = 'T2.2 Other service/goods :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8 [7]
    Left = 14
    Top = 24
    Width = 135
    Height = 14
    AutoSize = False
    Caption = 'T1.1 Tax charged by you :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Top = 201
    TabOrder = 6
  end
  inherited ClsCP1Btn: TButton
    Top = 201
    TabOrder = 7
  end
  inherited SBSPanel1: TSBSPanel
    Top = 140
    TabOrder = 8
    inherited Animated1: TAnimated
      Top = 1
    end
  end
  object I1PrYrF: TEditPeriod
    Tag = 1
    Left = 148
    Top = 94
    Width = 59
    Height = 22
    HelpContext = 656
    AutoSelect = False
    Color = clWhite
    EditMask = '00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 7
    ParentFont = False
    TabOrder = 3
    Text = '011996'
    OnExit = I1PrYrFExit
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
  end
  object Sum1: TBorCheck
    Left = 14
    Top = 147
    Width = 149
    Height = 20
    HelpContext = 655
    Caption = 'Close Period after Report : '
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TabStop = True
    TextId = 0
  end
  object I2PrYrF: TEditPeriod
    Tag = 1
    Left = 232
    Top = 94
    Width = 59
    Height = 22
    HelpContext = 656
    AutoSelect = False
    Color = clWhite
    EditMask = '00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 7
    ParentFont = False
    TabOrder = 4
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
  end
  object T21F: Text8Pt
    Left = 148
    Top = 44
    Width = 135
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 35
    ParentFont = False
    TabOrder = 1
    TextId = 0
    ViaSBtn = False
  end
  object T22F: Text8Pt
    Left = 148
    Top = 68
    Width = 135
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 35
    ParentFont = False
    TabOrder = 2
    TextId = 0
    ViaSBtn = False
  end
  object T11F: Text8Pt
    Left = 148
    Top = 20
    Width = 135
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 35
    ParentFont = False
    TabOrder = 0
    TextId = 0
    ViaSBtn = False
  end
end
