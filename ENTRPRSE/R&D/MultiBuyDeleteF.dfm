inherited frmMBDBlockDelete: TfrmMBDBlockDelete
  Left = 274
  Top = 236
  HelpContext = 675
  Caption = 'Multi-Buy Discount Block Delete'
  ClientHeight = 183
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Height = 141
  end
  object Label81: Label8 [1]
    Left = 28
    Top = 30
    Width = 85
    Height = 14
    Alignment = taRightJustify
    Caption = 'Product / Group : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label86: Label8 [2]
    Left = 19
    Top = 84
    Width = 87
    Height = 14
    Alignment = taRightJustify
    Caption = 'Date Range from :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8 [3]
    Left = 194
    Top = 86
    Width = 15
    Height = 14
    Alignment = taRightJustify
    Caption = 'to :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 67
    Top = 154
    TabOrder = 5
  end
  inherited ClsCP1Btn: TButton
    Left = 153
    Top = 154
    TabOrder = 6
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 7
  end
  object ACFF: Text8Pt
    Tag = 1
    Left = 111
    Top = 25
    Width = 99
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    HelpContext = 683
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnExit = ACFFExit
    TextId = 0
    ViaSBtn = False
    Link_to_Stock = True
    ShowHilight = True
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 111
    Top = 82
    Width = 80
    Height = 22
    HelpContext = 682
    AutoSelect = False
    Color = clWhite
    EditMask = '00/00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 2
    Placement = cpAbove
  end
  object I2TransDateF: TEditDate
    Tag = 1
    Left = 206
    Top = 82
    Width = 80
    Height = 22
    HelpContext = 682
    AutoSelect = False
    Color = clWhite
    EditMask = '00/00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 3
    Placement = cpAbove
  end
  object DelAll1: TBorCheckEx
    Left = 16
    Top = 109
    Width = 175
    Height = 22
    Caption = 'Delete for all Stock Records'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    TabStop = True
    TextId = 0
  end
  object DelExp1: TBorCheckEx
    Left = 12
    Top = 56
    Width = 179
    Height = 20
    Caption = 'Delete Expired within Date Range'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    TabStop = True
    TextId = 0
    OnClick = DelExp1Click
  end
end
