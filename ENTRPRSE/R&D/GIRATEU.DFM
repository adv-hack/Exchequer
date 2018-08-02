object GetInCrate: TGetInCrate
  Left = 355
  Top = 208
  HelpContext = 282
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Inclusive '
  ClientHeight = 106
  ClientWidth = 252
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
  object SBSPanel1: TSBSPanel
    Left = 3
    Top = 1
    Width = 244
    Height = 77
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label81: Label8
      Left = 45
      Top = 34
      Width = 70
      Height = 14
      Caption = 'Inclusive Rate '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label84: Label8
      Left = 30
      Top = 4
      Width = 185
      Height = 14
      Caption = 'Base the inclusive on which rate?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TextId = 0
    end
    object DefVATF: TSBSComboBox
      Tag = 1
      Left = 123
      Top = 31
      Width = 53
      Height = 22
      HelpContext = 105
      Style = csDropDownList
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      MaxLength = 1
      ParentFont = False
      TabOrder = 0
      ExtendedList = True
      MaxListWidth = 75
      ReadOnly = True
      Validate = True
    end
  end
  object ClsCP1Btn: TButton
    Left = 134
    Top = 83
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'C&ancel'
    ModalResult = 2
    TabOrder = 2
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 49
    Top = 83
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
end
