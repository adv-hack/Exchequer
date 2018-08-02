object Form_BoxOptions: TForm_BoxOptions
  Left = 219
  Top = 148
  HelpContext = 410
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Box Options'
  ClientHeight = 171
  ClientWidth = 412
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
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object SBSBackGroup1: TSBSBackGroup
    Left = 4
    Top = -1
    Width = 316
    Height = 44
    TextId = 0
  end
  object Label81: Label8
    Left = 19
    Top = 16
    Width = 50
    Height = 14
    Alignment = taRightJustify
    Caption = 'Line width'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Button_Ok: TButton
    Left = 328
    Top = 41
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 12
    OnClick = Button_OkClick
  end
  object Button_Cancel: TButton
    Left = 327
    Top = 70
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 13
    OnClick = Button_CancelClick
  end
  object SBSPanel2: TSBSPanel
    Left = 4
    Top = 92
    Width = 316
    Height = 34
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Enabled = False
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label1: TLabel
      Left = 28
      Top = 11
      Width = 39
      Height = 14
      Caption = 'Borders'
    end
  end
  object SBSPanel3: TSBSPanel
    Left = 4
    Top = 48
    Width = 316
    Height = 39
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Enabled = False
    TabOrder = 4
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label82: Label8
      Left = 34
      Top = 15
      Width = 31
      Height = 14
      Alignment = taRightJustify
      Caption = 'Colour'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
  end
  object Button_Colour: TButton
    Left = 327
    Top = 5
    Width = 80
    Height = 21
    Caption = 'Co&lour'
    TabOrder = 11
    OnClick = Panel_ColourDblClick
  end
  object CcyEdit_Width: TCurrencyEdit
    Left = 74
    Top = 13
    Width = 44
    Height = 22
    Alignment = taLeftJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '0 ')
    MaxLength = 2
    ParentFont = False
    TabOrder = 0
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
  object Panel_Colour: TPanel
    Left = 74
    Top = 57
    Width = 44
    Height = 24
    BevelOuter = bvLowered
    Color = clWindowFrame
    TabOrder = 2
    OnDblClick = Panel_ColourDblClick
  end
  object Check_Fill: TCheckBox
    Left = 168
    Top = 61
    Width = 119
    Height = 17
    Caption = 'Fill Box with Colour'
    TabOrder = 3
  end
  object Check_Left: TCheckBox
    Left = 195
    Top = 101
    Width = 44
    Height = 17
    Caption = 'Left'
    TabOrder = 7
  end
  object Check_Top: TCheckBox
    Left = 74
    Top = 101
    Width = 53
    Height = 17
    Caption = 'Top'
    TabOrder = 5
  end
  object Check_Bottom: TCheckBox
    Left = 129
    Top = 101
    Width = 62
    Height = 17
    Caption = 'Bottom'
    TabOrder = 6
  end
  object Check_Right: TCheckBox
    Left = 251
    Top = 101
    Width = 61
    Height = 17
    Caption = 'Right'
    TabOrder = 8
  end
  object SBSPanel5: TSBSPanel
    Left = 4
    Top = 130
    Width = 316
    Height = 36
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 9
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label_If: Label8
      Left = 6
      Top = 6
      Width = 247
      Height = 25
      AutoSize = False
      Caption = 'If'
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
    Left = 239
    Top = 135
    Width = 75
    Height = 25
    Caption = '&If'
    TabOrder = 10
    OnClick = Button_IfClick
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 335
    Top = 105
  end
end
