object frmVrTest: TfrmVrTest
  Left = 195
  Top = 137
  Width = 430
  Height = 201
  Caption = 'frmVrTest'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 72
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 32
    Top = 104
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object cbRequest: TComboBox
    Left = 32
    Top = 32
    Width = 209
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnDrawItem = cbRequestDrawItem
  end
  object Button1: TButton
    Left = 328
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 328
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
end
