object Form_SizeDialog: TForm_SizeDialog
  Left = 355
  Top = 174
  HelpContext = 5010
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Add Paper Size'
  ClientHeight = 189
  ClientWidth = 399
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object SBSBackGroup1: TSBSBackGroup
    Left = 5
    Top = 2
    Width = 302
    Height = 43
    TextId = 0
  end
  object Label_Descr: Label8
    Left = 18
    Top = 18
    Width = 54
    Height = 14
    Caption = 'Description'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object SBSBackGroup2: TSBSBackGroup
    Left = 5
    Top = 50
    Width = 302
    Height = 50
    Caption = 'Paper Size (millimeters):'
    TextId = 0
  end
  object Label84: Label8
    Left = 43
    Top = 71
    Width = 30
    Height = 14
    Caption = 'Height'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8
    Left = 195
    Top = 71
    Width = 37
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Width'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object SBSBackGroup3: TSBSBackGroup
    Left = 5
    Top = 103
    Width = 302
    Height = 80
    Caption = 'Paper Margins (millimeters):'
    TextId = 0
  end
  object Label811: Label8
    Left = 44
    Top = 125
    Width = 30
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Top'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label810: Label8
    Left = 30
    Top = 154
    Width = 44
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Bottom'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label813: Label8
    Left = 204
    Top = 154
    Width = 30
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Right'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label812: Label8
    Left = 204
    Top = 125
    Width = 30
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Left'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Button_Ok: TButton
    Left = 314
    Top = 10
    Width = 80
    Height = 21
    Caption = '&Save'
    ModalResult = 1
    TabOrder = 0
    OnClick = Button_OkClick
  end
  object Button_Cancel: TButton
    Left = 314
    Top = 41
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = Button_CancelClick
  end
  object Text_Description: Text8Pt
    Left = 79
    Top = 15
    Width = 219
    Height = 22
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnChange = Text_DescriptionChange
    TextId = 0
    ViaSBtn = False
  end
  object Ccy_Height: TCurrencyEdit
    Left = 79
    Top = 68
    Width = 40
    Height = 22
    Alignment = taLeftJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '1 ')
    MaxLength = 3
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
    Value = 1
  end
  object Ccy_Width: TCurrencyEdit
    Left = 238
    Top = 68
    Width = 39
    Height = 22
    Alignment = taLeftJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '1 ')
    MaxLength = 3
    ParentFont = False
    TabOrder = 4
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1
  end
  object Ccy_Top: TCurrencyEdit
    Left = 79
    Top = 122
    Width = 39
    Height = 22
    Alignment = taLeftJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '1 ')
    MaxLength = 3
    ParentFont = False
    TabOrder = 5
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1
  end
  object Ccy_Left: TCurrencyEdit
    Left = 238
    Top = 122
    Width = 39
    Height = 22
    Alignment = taLeftJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '1 ')
    MaxLength = 3
    ParentFont = False
    TabOrder = 6
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1
  end
  object Ccy_Right: TCurrencyEdit
    Left = 238
    Top = 151
    Width = 39
    Height = 22
    Alignment = taLeftJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '1 ')
    MaxLength = 3
    ParentFont = False
    TabOrder = 7
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1
  end
  object Ccy_Bottom: TCurrencyEdit
    Left = 79
    Top = 151
    Width = 39
    Height = 22
    Alignment = taLeftJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '1 ')
    MaxLength = 3
    ParentFont = False
    TabOrder = 8
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1
  end
end
