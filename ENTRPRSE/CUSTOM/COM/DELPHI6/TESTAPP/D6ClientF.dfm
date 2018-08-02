object Form1: TForm1
  Left = 306
  Top = 123
  Width = 222
  Height = 173
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
      'Delphi 6.01 COM Client')
    Version = '5.60.033 (Delphi 6.01)'
    OnClose = EntCustom1Close
    OnConnect = EntCustom1Connect
    OnHook = EntCustom1Hook
    Left = 22
    Top = 23
  end
end
