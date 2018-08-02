object Form1: TForm1
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Form1'
  ClientHeight = 78
  ClientWidth = 225
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
    Left = 48
    Top = 48
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Button1: TButton
    Left = 48
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 136
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = Timer1Timer
    Left = 8
  end
end
