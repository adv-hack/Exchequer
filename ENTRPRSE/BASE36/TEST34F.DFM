object Form2: TForm2
  Left = 346
  Top = 166
  Width = 436
  Height = 480
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 6
    Top = 5
    Width = 306
    Height = 409
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
  end
  object btnTest: TButton
    Left = 317
    Top = 12
    Width = 98
    Height = 25
    Caption = '&Test'
    TabOrder = 1
    OnClick = btnTestClick
  end
  object Button1: TButton
    Left = 322
    Top = 51
    Width = 87
    Height = 31
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
end
