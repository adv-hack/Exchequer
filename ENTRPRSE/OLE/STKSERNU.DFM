object StkSerNo: TStkSerNo
  Left = 243
  Top = 185
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Add Serial/Batch Number'
  ClientHeight = 242
  ClientWidth = 383
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Position = poDefault
  Scaled = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object SBSPanel1: TSBSBackGroup
    Left = 6
    Top = 2
    Width = 371
    Height = 46
    TextId = 0
  end
  object Label88: Label8
    Left = 17
    Top = 19
    Width = 36
    Height = 14
    Caption = 'Ser No.'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label89: Label8
    Left = 230
    Top = 19
    Width = 47
    Height = 14
    Caption = 'Batch No.'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object SBSPanel2: TSBSBackGroup
    Left = 6
    Top = 50
    Width = 371
    Height = 149
    TextId = 0
  end
  object Label810: Label8
    Left = 21
    Top = 79
    Width = 33
    Height = 14
    Caption = 'In Doc.'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object CurrLab1: Label8
    Left = 226
    Top = 62
    Width = 45
    Height = 14
    Caption = 'Currency'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label87: Label8
    Left = 293
    Top = 62
    Width = 70
    Height = 14
    Caption = 'Unit Cost Price'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object CurrLab2: Label8
    Left = 226
    Top = 106
    Width = 45
    Height = 14
    Caption = 'Currency'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8
    Left = 288
    Top = 106
    Width = 75
    Height = 14
    Caption = 'Unit Sales Price'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label811: Label8
    Left = 12
    Top = 124
    Width = 42
    Height = 14
    Caption = 'Out Doc.'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label812: Label8
    Left = 11
    Top = 167
    Width = 42
    Height = 14
    Caption = 'Out Date'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 170
    Top = 149
    Width = 40
    Height = 14
    Caption = 'Orig.Qty'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8
    Left = 242
    Top = 149
    Width = 44
    Height = 14
    Caption = 'Available'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object UseLab: Label8
    Left = 334
    Top = 149
    Width = 19
    Height = 14
    Caption = 'Use'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
    TextId = 0
  end
  object InLocLab: Label8
    Left = 174
    Top = 62
    Width = 35
    Height = 14
    Caption = 'In Locn'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object OutLocLab: Label8
    Left = 171
    Top = 107
    Width = 44
    Height = 14
    Caption = 'Out Locn'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 107
    Top = 211
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 14
    OnClick = CanCP1BtnClick
  end
  object CanCP1Btn: TButton
    Left = 192
    Top = 211
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 15
    OnClick = CanCP1BtnClick
  end
  object SNoF: Text8Pt
    Tag = 1
    Left = 57
    Top = 17
    Width = 141
    Height = 22
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 0
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    OnExit = SNoFExit
    TextId = 0
  end
  object BNoF: Text8Pt
    Tag = 1
    Left = 280
    Top = 17
    Width = 85
    Height = 22
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 0
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    OnExit = BNoFExit
    TextId = 0
  end
  object InF: Text8Pt
    Tag = 1
    Left = 57
    Top = 78
    Width = 109
    Height = 22
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 0
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    TextId = 0
  end
  object OutF: Text8Pt
    Tag = 1
    Left = 57
    Top = 122
    Width = 109
    Height = 22
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 0
    ParentFont = False
    ReadOnly = True
    TabOrder = 6
    TextId = 0
  end
  object ODF: TEditDate
    Tag = 1
    Left = 57
    Top = 164
    Width = 81
    Height = 22
    AutoSelect = False
    EditMask = '00/00/0000;0;'
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    ReadOnly = True
    TabOrder = 10
    Placement = cpAbove
    AllowBlank = True
  end
  object InCF: TSBSComboBox
    Tag = 1
    Left = 222
    Top = 78
    Width = 53
    Height = 22
    Color = clWhite
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MaxLength = 3
    ParentFont = False
    TabOrder = 4
    ExtendedList = True
    MaxListWidth = 90
    ReadOnly = True
    Validate = True
  end
  object UCF: TCurrencyEdit
    Tag = 1
    Left = 280
    Top = 78
    Width = 85
    Height = 22
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object OutCF: TSBSComboBox
    Tag = 1
    Left = 222
    Top = 122
    Width = 53
    Height = 22
    Color = clWhite
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MaxLength = 3
    ParentFont = False
    TabOrder = 8
    ExtendedList = True
    MaxListWidth = 90
    ReadOnly = True
    Validate = True
  end
  object USF: TCurrencyEdit
    Tag = 1
    Left = 280
    Top = 122
    Width = 85
    Height = 22
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 9
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object OQF: TCurrencyEdit
    Tag = 1
    Left = 148
    Top = 164
    Width = 65
    Height = 22
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 11
    WantReturns = False
    WordWrap = False
    OnEnter = OQFEnter
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object AQF: TCurrencyEdit
    Left = 224
    Top = 164
    Width = 65
    Height = 22
    TabStop = False
    Color = clBtnFace
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    ReadOnly = True
    TabOrder = 12
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object UQF: TCurrencyEdit
    Tag = 1
    Left = 300
    Top = 164
    Width = 65
    Height = 22
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0.00 ')
    ParentFont = False
    TabOrder = 13
    Visible = False
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object LocInF: Text8Pt
    Tag = 1
    Left = 169
    Top = 78
    Width = 50
    Height = 22
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 0
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    OnExit = LocInFExit
    TextId = 0
  end
  object LocOutF: Text8Pt
    Tag = 1
    Left = 169
    Top = 122
    Width = 50
    Height = 22
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 0
    ParentFont = False
    ReadOnly = True
    TabOrder = 7
    OnExit = LocInFExit
    TextId = 0
  end
end
