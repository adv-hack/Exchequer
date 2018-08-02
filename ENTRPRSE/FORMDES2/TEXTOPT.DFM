object Form_TextOptions: TForm_TextOptions
  Left = 225
  Top = 129
  HelpContext = 210
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Text Options'
  ClientHeight = 217
  ClientWidth = 518
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
    Left = 7
    Top = -2
    Width = 423
    Height = 97
    TextId = 0
  end
  object Label81: Label8
    Left = 48
    Top = 14
    Width = 21
    Height = 14
    Caption = 'Text'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label88: Label8
    Left = 22
    Top = 70
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
    Left = 436
    Top = 4
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
    OnClick = Button_SaveClick
  end
  object Button_Cancel: TButton
    Left = 437
    Top = 39
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 7
    OnClick = Button_CancelClick
  end
  object SBSPanel2: TSBSPanel
    Left = 7
    Top = 100
    Width = 423
    Height = 59
    HelpContext = 10000
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Enabled = False
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label_Font: Label8
      Left = 6
      Top = 6
      Width = 327
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
  object Memo_Text: TMemo
    Left = 73
    Top = 12
    Width = 349
    Height = 49
    MaxLength = 255
    TabOrder = 0
    OnChange = Edit_TextChange
  end
  object Combo_Align: TSBSComboBox
    Left = 73
    Top = 66
    Width = 349
    Height = 22
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 1
    Items.Strings = (
      'Left Justified'
      'Centred Horizontally'
      'Right Justified')
    MaxListWidth = 0
  end
  object Button_SelectFont: TButton
    Left = 349
    Top = 105
    Width = 75
    Height = 25
    HelpContext = 10000
    Caption = '&Font'
    TabOrder = 3
    OnClick = Button_SelectFontClick
  end
  object SBSPanel3: TSBSPanel
    Left = 7
    Top = 172
    Width = 423
    Height = 36
    HelpContext = 10100
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'SBSPanel3'
    TabOrder = 4
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label_If: Label8
      Left = 6
      Top = 6
      Width = 327
      Height = 25
      AutoSize = False
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
    Left = 349
    Top = 177
    Width = 75
    Height = 25
    HelpContext = 10100
    Caption = '&If'
    TabOrder = 5
    OnClick = Button_IfClick
  end
  object chkSymbolFont: TBorCheck
    Left = 350
    Top = 134
    Width = 75
    Height = 20
    Align = alRight
    Caption = 'Symbol'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 8
    TextId = 0
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
    Left = 458
    Top = 73
  end
end
