object frmIntFind: TfrmIntFind
  Left = 309
  Top = 241
  Width = 357
  Height = 139
  ActiveControl = Edit1
  Caption = 'Find'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  PixelsPerInch = 96
  TextHeight = 13
  object APanel: TPanel
    Left = 8
    Top = 8
    Width = 241
    Height = 97
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 40
      Top = 24
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = 'Find:'
    end
    object Label2: TLabel
      Left = 16
      Top = 60
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = 'Operation:'
    end
    object Edit1: TEdit
      Left = 72
      Top = 20
      Width = 145
      Height = 21
      TabOrder = 0
    end
    object cbOp: TComboBox
      Left = 72
      Top = 56
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'GetEqual'
        'GetGreaterThan'
        'GetGreaterThanOrEqual'
        'GetLessThan'
        'GetLessThanOrEqual')
    end
  end
  object Button1: TButton
    Left = 264
    Top = 8
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 264
    Top = 40
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
