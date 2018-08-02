object Form1: TForm1
  Left = 240
  Top = 179
  Width = 456
  Height = 172
  Caption = 'HTML Creator'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 46
    Height = 14
    Caption = 'XML File :'
  end
  object Label2: TLabel
    Left = 8
    Top = 44
    Width = 45
    Height = 14
    Caption = 'XSL File :'
  end
  object Label3: TLabel
    Left = 8
    Top = 76
    Width = 62
    Height = 14
    Caption = 'Output Path :'
  end
  object edXML: TEdit
    Left = 80
    Top = 8
    Width = 305
    Height = 22
    TabOrder = 0
  end
  object Button1: TButton
    Left = 384
    Top = 9
    Width = 57
    Height = 20
    Caption = 'Browse'
    TabOrder = 1
    OnClick = Button1Click
  end
  object edXSL: TEdit
    Left = 80
    Top = 40
    Width = 305
    Height = 22
    TabOrder = 2
  end
  object Button2: TButton
    Left = 384
    Top = 41
    Width = 57
    Height = 20
    Caption = 'Browse'
    TabOrder = 3
    OnClick = Button2Click
  end
  object edOutputPath: TEdit
    Left = 80
    Top = 72
    Width = 305
    Height = 22
    TabOrder = 4
  end
  object Button3: TButton
    Left = 384
    Top = 73
    Width = 57
    Height = 20
    Caption = 'Browse'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 368
    Top = 112
    Width = 75
    Height = 25
    Caption = '&Close'
    TabOrder = 7
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 288
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Create &HTML'
    TabOrder = 6
    OnClick = Button5Click
  end
  object OpenDialog1: TOpenDialog
    Left = 8
    Top = 8
  end
end
