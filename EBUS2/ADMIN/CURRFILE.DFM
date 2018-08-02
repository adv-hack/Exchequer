object Form1: TForm1
  Left = 440
  Top = 182
  Width = 208
  Height = 93
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnCreateFile: TButton
    Left = 52
    Top = 8
    Width = 109
    Height = 25
    Caption = 'Create Code File'
    TabOrder = 0
    OnClick = btnCreateFileClick
  end
  object Button1: TButton
    Left = 52
    Top = 38
    Width = 109
    Height = 25
    Caption = 'Create Desc File'
    TabOrder = 1
    OnClick = Button1Click
  end
end
