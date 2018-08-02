object Form1: TForm1
  Left = 400
  Top = 175
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 129
  ClientWidth = 223
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 16
    Width = 37
    Height = 13
    Caption = 'Number'
  end
  object edtNum: TEdit
    Left = 52
    Top = 13
    Width = 66
    Height = 21
    TabOrder = 0
    Text = '181'
  end
  object Button1: TButton
    Left = 132
    Top = 10
    Width = 75
    Height = 25
    Caption = 'Do it now'
    TabOrder = 1
    OnClick = Button1Click
  end
  object edtNum1: TEdit
    Left = 29
    Top = 46
    Width = 170
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
  end
  object edtNum3: TEdit
    Left = 29
    Top = 96
    Width = 170
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 3
  end
  object edtNum2: TEdit
    Left = 29
    Top = 71
    Width = 170
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 4
  end
end
