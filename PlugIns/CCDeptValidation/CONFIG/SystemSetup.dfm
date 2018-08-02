object FrmSystemSetup: TFrmSystemSetup
  Left = 591
  Top = 431
  BorderStyle = bsDialog
  Caption = 'System Setup'
  ClientHeight = 112
  ClientWidth = 188
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 169
    Height = 65
    Shape = bsFrame
  end
  object cbVAT: TCheckBox
    Left = 24
    Top = 32
    Width = 145
    Height = 17
    Caption = ' Enable VAT Validation'
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 8
    Top = 80
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 96
    Top = 80
    Width = 80
    Height = 21
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
