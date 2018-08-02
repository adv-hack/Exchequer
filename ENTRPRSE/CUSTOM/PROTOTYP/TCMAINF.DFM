object Form1: TForm1
  Left = 323
  Top = 187
  Width = 436
  Height = 185
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnCustom1: TButton
    Left = 309
    Top = 22
    Width = 105
    Height = 33
    Caption = 'Custom1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnCustom1Click
  end
  object btnCustom2: TButton
    Left = 310
    Top = 65
    Width = 105
    Height = 33
    Caption = 'Custom2'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnCustom2Click
  end
  object Edit1: TEdit
    Left = 35
    Top = 23
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
    OnExit = Edit1Exit
  end
  object Edit2: TEdit
    Left = 35
    Top = 52
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit2'
  end
  object Edit3: TEdit
    Left = 35
    Top = 83
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Edit3'
  end
  object Button1: TButton
    Left = 22
    Top = 120
    Width = 75
    Height = 25
    Caption = 'About'
    TabOrder = 5
    OnClick = Button1Click
  end
end
