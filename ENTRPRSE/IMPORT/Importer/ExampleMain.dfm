object Form1: TForm1
  Left = 471
  Top = 244
  BorderStyle = bsDialog
  Caption = 'Importer Example Maintenance'
  ClientHeight = 140
  ClientWidth = 302
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 8
    Width = 270
    Height = 25
    Caption = 'Update &Job File'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 16
    Top = 40
    Width = 270
    Height = 25
    Caption = 'Update Default &Settings File'
    TabOrder = 1
    OnClick = Button3Click
  end
  object Button2: TButton
    Left = 16
    Top = 104
    Width = 270
    Height = 25
    Caption = '&Close'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button4: TButton
    Left = 16
    Top = 72
    Width = 270
    Height = 25
    Caption = '&View Job File'
    TabOrder = 3
    OnClick = Button4Click
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Importer Job Files (*.job)|*.job'
    Left = 16
    Top = 8
  end
end
