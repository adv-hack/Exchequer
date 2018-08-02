object frmIncVatRate: TfrmIncVatRate
  Left = 344
  Top = 276
  BorderStyle = bsDialog
  Caption = 'Inclusive VAT Rate'
  ClientHeight = 124
  ClientWidth = 224
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
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
  object lDesc: TLabel
    Left = 16
    Top = 16
    Width = 188
    Height = 14
    Caption = 'Base the inclusive on which rate ?'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 24
    Top = 52
    Width = 76
    Height = 14
    Caption = 'Inclusive Rate : '
  end
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 209
    Height = 81
    Shape = bsFrame
  end
  object cmbIncVATCode: TComboBox
    Tag = 6
    Left = 104
    Top = 48
    Width = 91
    Height = 22
    BevelInner = bvNone
    BevelOuter = bvNone
    Style = csDropDownList
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 136
    Top = 96
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
end
