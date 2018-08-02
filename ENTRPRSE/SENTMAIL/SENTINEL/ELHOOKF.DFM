object Form1: TForm1
  Left = 192
  Top = 107
  Width = 117
  Height = 93
  Caption = 'Form1'
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
  object EntCustom1: TEntCustom
    OnClose = EntCustom1Close
    OnConnect = EntCustom1Connect
    OnHook = EntCustom1Hook
    Left = 8
    Top = 16
  end
end
