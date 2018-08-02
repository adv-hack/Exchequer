object Form_PageNoOptions: TForm_PageNoOptions
  Left = 231
  Top = 161
  HelpContext = 910
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Page Number Options'
  ClientHeight = 138
  ClientWidth = 430
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
    Left = 5
    Top = -1
    Width = 333
    Height = 95
    TextId = 0
  end
  object Label81: Label8
    Left = 21
    Top = 16
    Width = 62
    Height = 14
    Alignment = taRightJustify
    Caption = 'Leading Text'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 25
    Top = 41
    Width = 58
    Height = 14
    Alignment = taRightJustify
    Caption = 'Trailing Text'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label88: Label8
    Left = 35
    Top = 68
    Width = 47
    Height = 14
    Caption = 'Alignment'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Button_Save: TButton
    Left = 349
    Top = 8
    Width = 75
    Height = 25
    Caption = '&Save'
    ModalResult = 1
    TabOrder = 5
    OnClick = Button_SaveClick
  end
  object Button_Cancel: TButton
    Left = 348
    Top = 45
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 6
    OnClick = Button_CancelClick
  end
  object SBSPanel2: TSBSPanel
    Left = 5
    Top = 98
    Width = 333
    Height = 36
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Enabled = False
    TabOrder = 3
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label_Font: Label8
      Left = 5
      Top = 6
      Width = 242
      Height = 25
      AutoSize = False
      Caption = 'Text'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
  end
  object Edit_Leading: Text8Pt
    Left = 86
    Top = 12
    Width = 246
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 255
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnChange = UpdateText
    TextId = 0
    ViaSBtn = False
  end
  object Edit_Trailing: Text8Pt
    Left = 86
    Top = 38
    Width = 246
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 255
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnChange = UpdateText
    TextId = 0
    ViaSBtn = False
  end
  object Button_SelectFont: TButton
    Left = 256
    Top = 104
    Width = 75
    Height = 25
    Caption = '&Font'
    TabOrder = 4
    OnClick = Button_SelectFontClick
  end
  object Combo_Align: TSBSComboBox
    Left = 86
    Top = 64
    Width = 246
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
    Left = 367
    Top = 77
  end
end
