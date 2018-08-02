object Form1: TForm1
  Left = 76
  Top = 165
  Width = 569
  Height = 375
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
  object Label1: TLabel
    Left = 232
    Top = 24
    Width = 46
    Height = 13
    Caption = 'EmpCode'
  end
  object Label2: TLabel
    Left = 232
    Top = 48
    Width = 23
    Height = 13
    Caption = 'Rate'
  end
  object Label3: TLabel
    Left = 232
    Top = 72
    Width = 28
    Height = 13
    Caption = 'Hours'
  end
  object Button1: TButton
    Left = 8
    Top = 88
    Width = 121
    Height = 25
    Caption = 'Accum Totals'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 296
    Top = 136
    Width = 129
    Height = 97
    ItemHeight = 13
    TabOrder = 1
  end
  object ComboBox1: TComboBox
    Left = 296
    Top = 25
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = 'A'
    Items.Strings = (
      'A'
      'B'
      'C')
  end
  object ComboBox2: TComboBox
    Left = 295
    Top = 48
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = '1'
    Items.Strings = (
      '1'
      '2'
      '3')
  end
  object Button2: TButton
    Left = 296
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Add To List'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 384
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Sort list'
    TabOrder = 5
    OnClick = Button3Click
  end
  object ListBox2: TListBox
    Left = 8
    Top = 120
    Width = 153
    Height = 97
    ItemHeight = 13
    TabOrder = 6
  end
  object Edit1: TEdit
    Left = 296
    Top = 72
    Width = 142
    Height = 21
    TabOrder = 7
  end
  object Button4: TButton
    Left = 464
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 8
    OnClick = Button4Click
  end
end
