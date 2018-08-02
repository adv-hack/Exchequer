object AutoTxPop: TAutoTxPop
  Left = 635
  Top = 300
  HelpContext = 51
  ActiveControl = ASDate1F
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Automatic Settings'
  ClientHeight = 261
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object SBSBackGroup1: TSBSBackGroup
    Left = 9
    Top = 57
    Width = 350
    Height = 157
    TextId = 0
  end
  object Label4: TLabel
    Left = 56
    Top = 151
    Width = 135
    Height = 14
    Caption = 'Repeat until Date (or Period)'
  end
  object Label1: TLabel
    Left = 46
    Top = 77
    Width = 144
    Height = 14
    Caption = 'Date/Period of next auto entry'
  end
  object Label3: TLabel
    Left = 14
    Top = 114
    Width = 182
    Height = 14
    Caption = 'Increment by how many days/periods'
  end
  object SBSPanel1: TSBSPanel
    Left = 9
    Top = 12
    Width = 350
    Height = 41
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 11
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    Purpose = puFrame
  end
  object ClsCP1Btn: TButton
    Left = 195
    Top = 227
    Width = 80
    Height = 23
    Cancel = True
    Caption = 'C&lose'
    ModalResult = 2
    TabOrder = 10
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 111
    Top = 227
    Width = 80
    Height = 23
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 9
    OnClick = OkCP1BtnClick
  end
  object ASDate1F: TEditDate
    Tag = 3
    Left = 197
    Top = 74
    Width = 72
    Height = 22
    HelpContext = 54
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
    ReadOnly = True
    TabOrder = 2
    OnExit = ASDate2FExit
    Placement = cpAbove
  end
  object ASPeriod1F: TEditPeriod
    Tag = 2
    Left = 272
    Top = 74
    Width = 62
    Height = 22
    HelpContext = 55
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
    ReadOnly = True
    TabOrder = 3
    Text = '011996'
    OnExit = ASPeriod2FExit
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
    OnConvDate = ASPeriod1FConvDate
    OnShowPeriod = ASPeriod1FShowPeriod
  end
  object ASDate2F: TEditDate
    Tag = 3
    Left = 197
    Top = 148
    Width = 72
    Height = 22
    HelpContext = 57
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
    ReadOnly = True
    TabOrder = 6
    OnExit = ASDate2FExit
    Placement = cpAbove
  end
  object ASPeriod2F: TEditPeriod
    Tag = 2
    Left = 272
    Top = 148
    Width = 62
    Height = 22
    HelpContext = 58
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
    ReadOnly = True
    TabOrder = 7
    Text = '011996'
    OnExit = ASPeriod2FExit
    Placement = cpAbove
    EPeriod = 1
    EYear = 96
    ViewMask = '000/0000;0;'
    OnConvDate = ASPeriod1FConvDate
    OnShowPeriod = ASPeriod1FShowPeriod
  end
  object ASAF: TBorCheck
    Tag = 1
    Left = 16
    Top = 181
    Width = 196
    Height = 20
    HelpContext = 59
    Caption = '&Auto-create when posting daybook'
    Color = clBtnFace
    Enabled = False
    ParentColor = False
    TabOrder = 8
    TabStop = True
    TextId = 0
  end
  object ASDF: TBorRadio
    Tag = 1
    Left = 19
    Top = 22
    Width = 145
    Height = 20
    HelpContext = 50
    Caption = 'Create on specific &dates'
    Enabled = False
    GroupIndex = 1
    TabOrder = 0
    TabStop = True
    TextId = 0
    OnClick = ASDFClick
  end
  object ASPF: TBorRadio
    Tag = 1
    Left = 195
    Top = 22
    Width = 107
    Height = 20
    HelpContext = 53
    Caption = 'Create by &period'
    Enabled = False
    GroupIndex = 1
    TabOrder = 1
    TabStop = True
    TextId = 0
    OnClick = ASDFClick
  end
  object ASNPerF: TCurrencyEdit
    Tag = 1
    Left = 197
    Top = 110
    Width = 72
    Height = 22
    HelpContext = 56
    Color = clWhite
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 3
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object ASKDF: TBorCheck
    Tag = 3
    Left = 272
    Top = 110
    Width = 74
    Height = 20
    Caption = 'Keep Date'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TabStop = True
    TextId = 0
  end
end
