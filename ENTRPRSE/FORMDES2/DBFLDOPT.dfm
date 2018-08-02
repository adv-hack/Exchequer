object Form_DbFldOpt: TForm_DbFldOpt
  Left = 143
  Top = 168
  HelpContext = 610
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Database Field Options'
  ClientHeight = 250
  ClientWidth = 453
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object SBSBackGroup1: TSBSBackGroup
    Left = 5
    Top = 0
    Width = 356
    Height = 166
    TextId = 0
  end
  object Label81: Label8
    Left = 45
    Top = 15
    Width = 39
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 27
    Top = 42
    Width = 57
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Description'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8
    Left = 57
    Top = 68
    Width = 27
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8
    Left = 34
    Top = 90
    Width = 50
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Alignment'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label86: Label8
    Left = 38
    Top = 117
    Width = 46
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Decimals'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label_Description: Label8
    Left = 91
    Top = 42
    Width = 178
    Height = 14
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    OnDblClick = Label_DescriptionDblClick
    TextId = 0
  end
  object Label_Type: Label8
    Left = 91
    Top = 68
    Width = 161
    Height = 14
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Button_Save: TButton
    Left = 369
    Top = 10
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 9
    OnClick = Button_SaveClick
  end
  object Button_Cancel: TButton
    Left = 369
    Top = 38
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 10
    OnClick = Button_CancelClick
  end
  object Panel_Font: TSBSPanel
    Left = 5
    Top = 170
    Width = 356
    Height = 36
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Enabled = False
    TabOrder = 5
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label_Font: Label8
      Left = 9
      Top = 6
      Width = 253
      Height = 25
      AutoSize = False
      Caption = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
  end
  object Button_Select: TButton
    Left = 275
    Top = 13
    Width = 80
    Height = 21
    Caption = '&Select'
    TabOrder = 1
    OnClick = Button_SelectClick
  end
  object Text_ShortCode: Text8Pt
    Left = 89
    Top = 12
    Width = 121
    Height = 22
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 8
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnDblClick = Button_SelectClick
    OnExit = Text_ShortCodeExit
    TextId = 0
    ViaSBtn = False
  end
  object Button_SelectFont: TButton
    Left = 275
    Top = 176
    Width = 80
    Height = 25
    Caption = '&Font'
    TabOrder = 6
    OnClick = Button_SelectFontClick
  end
  object Ccy_Decs: TCurrencyEdit
    Left = 89
    Top = 114
    Width = 32
    Height = 22
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 1
    ParentFont = False
    TabOrder = 3
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object Combo_Align: TSBSComboBox
    Left = 89
    Top = 87
    Width = 264
    Height = 22
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 2
    Items.Strings = (
      'Left Justified'
      'Centred Horizontally'
      'Right Justified')
    MaxListWidth = 0
  end
  object BorChk_BlankZero: TBorCheck
    Left = 16
    Top = 140
    Width = 241
    Height = 20
    Align = alRight
    Caption = 'Leave blank if value is 0.00'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    TextId = 0
  end
  object SBSPanel3: TSBSPanel
    Left = 5
    Top = 210
    Width = 356
    Height = 36
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 7
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label_If: Label8
      Left = 6
      Top = 6
      Width = 265
      Height = 26
      AutoSize = False
      Caption = 'Print If:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
  end
  object Button_If: TButton
    Left = 275
    Top = 216
    Width = 80
    Height = 25
    Caption = '&If'
    TabOrder = 8
    OnClick = Button_IfClick
  end
  object FontDialog1: TFontDialog
    HelpContext = 20200
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Options = [fdEffects, fdShowHelp]
    Left = 384
    Top = 110
  end
end
