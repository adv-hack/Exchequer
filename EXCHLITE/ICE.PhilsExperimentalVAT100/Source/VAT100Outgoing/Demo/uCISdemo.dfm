object Form1: TForm1
  Left = 279
  Top = 645
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'CIS Demo'
  ClientHeight = 217
  ClientWidth = 485
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnPostDoc: TButton
    Left = 36
    Top = 76
    Width = 75
    Height = 25
    Caption = 'Post'
    TabOrder = 0
    OnClick = btnPostDocClick
  end
  object edtFileName: TAdvFileNameEdit
    Left = 26
    Top = 20
    Width = 355
    Height = 21
    Flat = False
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'MS Sans Serif'
    LabelFont.Style = []
    Lookup.Separator = ';'
    Color = clWindow
    Enabled = True
    TabOrder = 1
    Visible = True
    Version = '1.3.0.2'
    ButtonStyle = bsButton
    ButtonWidth = 18
    Etched = False
    Glyph.Data = {
      CE000000424DCE0000000000000076000000280000000C0000000B0000000100
      0400000000005800000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00D00000000DDD
      00000077777770DD00000F077777770D00000FF07777777000000FFF00000000
      00000FFFFFFF0DDD00000FFF00000DDD0000D000DDDDD0000000DDDDDDDDDD00
      0000DDDDD0DDD0D00000DDDDDD000DDD0000}
    FilterIndex = 0
    DialogOptions = []
    DialogKind = fdOpen
  end
  object Button1: TButton
    Left = 114
    Top = 76
    Width = 75
    Height = 25
    Caption = 'Post File'
    TabOrder = 2
    OnClick = Button1Click
  end
end
