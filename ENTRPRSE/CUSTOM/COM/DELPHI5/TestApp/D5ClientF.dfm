object Form1: TForm1
  Left = 480
  Top = 245
  Width = 272
  Height = 123
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
    AboutText.Strings = (
      'Delphi 5.0 COM CLient')
    Version = '5.60.033 (Delphi 5.0)'
    OnClose = EntCustom1Close
    OnConnect = EntCustom1Connect
    OnHook = EntCustom1Hook
    Left = 29
    Top = 28
  end
end
