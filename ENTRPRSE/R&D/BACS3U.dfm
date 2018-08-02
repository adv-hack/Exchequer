inherited BatchRunInp: TBatchRunInp
  HelpContext = 40119
  Caption = 'Set Batch Payment Date'
  PixelsPerInch = 96
  TextHeight = 14
  object Label84: Label8 [1]
    Left = 27
    Top = 60
    Width = 109
    Height = 14
    Alignment = taRightJustify
    Caption = 'Payment Period/Year : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8 [2]
    Left = 60
    Top = 29
    Width = 75
    Height = 14
    Alignment = taRightJustify
    Caption = 'Payment Date : '
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
    TabOrder = 3
  end
  inherited SBSPanel1: TSBSPanel
    TabOrder = 4
  end
  object I1PrYrF: TEditPeriod
    Tag = 1
    Left = 138
    Top = 58
    Width = 59
    Height = 22
    HelpContext = 40037
    AutoSelect = False
    EditMask = '00/0000;0;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 7
    ParentFont = False
    TabOrder = 1
    Text = '011996'
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
    OnConvDate = I1PrYrFConvDate
    OnShowPeriod = I1PrYrFShowPeriod
  end
  object I1TransDateF: TEditDate
    Tag = 1
    Left = 138
    Top = 25
    Width = 80
    Height = 22
    HelpContext = 40036
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
    TabOrder = 0
    OnExit = I1TransDateFExit
    Placement = cpAbove
  end
end
