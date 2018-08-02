object Form1: TForm1
  Left = 322
  Top = 304
  Width = 412
  Height = 151
  Caption = 'Form1'
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
    Left = 141
    Top = 16
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = 'Record'
  end
  object Button1: TButton
    Left = 304
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 0
    OnClick = Button1Click
  end
  object spRecNo: TSpinEdit
    Left = 184
    Top = 16
    Width = 97
    Height = 22
    MaxValue = 8
    MinValue = 1
    TabOrder = 1
    Value = 1
  end
  object chkStop: TCheckBox
    Left = 280
    Top = 64
    Width = 97
    Height = 17
    Caption = 'Stop'
    TabOrder = 2
  end
end
