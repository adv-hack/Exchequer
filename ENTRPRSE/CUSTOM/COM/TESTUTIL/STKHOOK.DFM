object Form1: TForm1
  Left = 788
  Top = 587
  Width = 241
  Height = 185
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 3
    Top = 2
    Width = 224
    Height = 148
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
  end
  object EntCustom1: TEntCustom
    AboutText.Strings = (
      'Test Hook v1.00')
    OnClose = EntCustom1Close
    OnConnect = EntCustom1Connect
    OnHook = EntCustom1Hook
    Left = 9
    Top = 7
  end
end
