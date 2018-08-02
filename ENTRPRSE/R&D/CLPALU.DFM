object CLPAl: TCLPAl
  Left = 810
  Top = 279
  ActiveControl = PAMntF
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Part Allocate'
  ClientHeight = 98
  ClientWidth = 180
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
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
    Left = 5
    Top = 2
    Width = 168
    Height = 59
    TextId = 0
  end
  object PALab: Label8
    Left = 10
    Top = 13
    Width = 157
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = 'How Much?'
    TextId = 0
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 8
    Top = 72
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = OkCP1BtnClick
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 91
    Top = 72
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PAMntF: TCurrencyEdit
    Tag = 1
    Left = 26
    Top = 30
    Width = 121
    Height = 21
    Color = clWhite
    Lines.Strings = (
      '0.67-')
    MaxLength = 12
    TabOrder = 2
    WantReturns = False
    WordWrap = False
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
    ShowCurrency = False
    TextId = 0
    Value = -0.666666
  end
end
