object Form1: TForm1
  Left = 248
  Top = 157
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 101
  ClientWidth = 343
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
  object Label1: TLabel
    Left = 10
    Top = 16
    Width = 65
    Height = 13
    Caption = 'Issue Number'
  end
  object Button1: TButton
    Left = 9
    Top = 39
    Width = 330
    Height = 57
    Caption = 'Build DLL'
    TabOrder = 1
    OnClick = Button1Click
  end
  object MaskEdit1: TMaskEdit
    Left = 87
    Top = 12
    Width = 41
    Height = 21
    EditMask = '999;1;_'
    MaxLength = 3
    TabOrder = 0
    Text = '   '
  end
end
