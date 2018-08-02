object Form1: TForm1
  Left = 118
  Top = 204
  Width = 696
  Height = 480
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
      'Delphi 7.1 COM Client')
    Version = '5.60.033 (Delphi 7.1)'
    OnClose = EntCustom1Close
    OnConnect = EntCustom1Connect
    OnHook = EntCustom1Hook
    Left = 34
    Top = 24
  end
end
