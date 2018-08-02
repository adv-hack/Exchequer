object frmERM: TfrmERM
  Left = 369
  Top = 359
  Width = 404
  Height = 172
  Caption = 'frmERM'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 64
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 256
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Panel1: TPanel
    Left = 16
    Top = 8
    Width = 369
    Height = 89
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 32
      Height = 13
      Caption = 'Label1'
    end
    object Label2: TLabel
      Left = 8
      Top = 64
      Width = 32
      Height = 13
      Caption = 'Label2'
    end
  end
end
