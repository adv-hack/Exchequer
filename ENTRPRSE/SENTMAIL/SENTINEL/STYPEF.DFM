object Form1: TForm1
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Sentinel Type'
  ClientHeight = 125
  ClientWidth = 235
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 222
    Height = 81
    Caption = 'Which type of Sentinel do you wish to add?'
    TabOrder = 0
    object rbTypeAlert: TRadioButton
      Left = 24
      Top = 24
      Width = 113
      Height = 17
      Caption = 'Email/SMS Alert'
      TabOrder = 0
    end
    object rbTypeReport: TRadioButton
      Left = 24
      Top = 48
      Width = 113
      Height = 17
      Caption = 'Report'
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 164
    Top = 96
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Button2: TButton
    Left = 88
    Top = 96
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
end
