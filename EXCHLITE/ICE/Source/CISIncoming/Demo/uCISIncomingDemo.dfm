object Form1: TForm1
  Left = 541
  Top = 349
  Width = 431
  Height = 318
  Caption = 'CIS Incoming Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 110
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Check'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 114
    Top = 164
    Width = 75
    Height = 25
    Caption = 'Call Export'
    TabOrder = 1
    OnClick = Button2Click
  end
end
