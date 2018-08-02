object FrmValidation: TFrmValidation
  Left = 381
  Top = 223
  BorderStyle = bsDialog
  Caption = 'Validation Input'
  ClientHeight = 127
  ClientWidth = 263
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 32
    Width = 249
    Height = 57
    Shape = bsFrame
  end
  object lLabel: TLabel
    Left = 56
    Top = 52
    Width = 28
    Height = 14
    Alignment = taRightJustify
    Caption = 'lLabel'
  end
  object lTitle: TLabel
    Left = 8
    Top = 8
    Width = 176
    Height = 14
    Caption = 'You must input a value for this field :'
  end
  object edValue: TEdit
    Left = 96
    Top = 48
    Width = 145
    Height = 22
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 192
    Top = 96
    Width = 65
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
end
