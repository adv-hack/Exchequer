object Form_GridOptions: TForm_GridOptions
  Left = 343
  Top = 120
  HelpContext = 2500
  ActiveControl = BorCheck_Display
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Grid Options'
  ClientHeight = 235
  ClientWidth = 378
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
    Left = 6
    Top = 156
    Width = 149
    Height = 73
    Caption = 'Grid Size (millimeters)'
    TextId = 0
  end
  object Label84: Label8
    Left = 18
    Top = 177
    Width = 74
    Height = 14
    Caption = 'Horizontally (X)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8
    Left = 28
    Top = 203
    Width = 64
    Height = 14
    Caption = 'Vertically (Y)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Button_Ok: TButton
    Left = 292
    Top = 7
    Width = 80
    Height = 21
    Caption = '&Save'
    ModalResult = 1
    TabOrder = 6
    OnClick = Button_OkClick
  end
  object Button_Cancel: TButton
    Left = 292
    Top = 35
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 7
    OnClick = Button_CancelClick
  end
  object SBSGrp_PageHed: TSBSGroup
    Left = 6
    Top = 6
    Width = 279
    Height = 62
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Enabled = False
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label86: Label8
      Left = 25
      Top = 25
      Width = 249
      Height = 32
      AutoSize = False
      Caption = 
        'This option displays a grid of dots on the page to help you posi' +
        'tion the controls you place on it.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      TextId = 0
    end
  end
  object SBSGroup1: TSBSGroup
    Left = 6
    Top = 73
    Width = 279
    Height = 76
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Enabled = False
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label81: Label8
      Left = 25
      Top = 25
      Width = 246
      Height = 48
      AutoSize = False
      Caption = 
        'This option forces controls to be positioned on points of the gr' +
        'id and to be sized to the grid. This makes it easy to line up co' +
        'ntrols.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      TextId = 0
    end
  end
  object BorCheck_Display: TBorCheck
    Left = 12
    Top = 10
    Width = 98
    Height = 20
    Align = alRight
    Caption = 'Display Grid'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    TabStop = True
    TextId = 0
  end
  object BorCheck_SnapTo: TBorCheck
    Left = 13
    Top = 77
    Width = 98
    Height = 20
    Align = alRight
    Caption = 'Snap To Grid'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 3
    TabStop = True
    TextId = 0
  end
  object CcyEdit_Horz: TCurrencyEdit
    Left = 99
    Top = 174
    Width = 46
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '3 ')
    MaxLength = 2
    ParentFont = False
    TabOrder = 4
    WantReturns = False
    WordWrap = False
    OnExit = CcyEdit_HorzExit
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 3
  end
  object CcyEdit_Vert: TCurrencyEdit
    Left = 99
    Top = 200
    Width = 46
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '3 ')
    MaxLength = 2
    ParentFont = False
    TabOrder = 5
    WantReturns = False
    WordWrap = False
    OnExit = CcyEdit_VertExit
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 3
  end
end
