object Form1: TForm1
  Left = 217
  Top = 193
  Width = 451
  Height = 134
  Caption = 'Enterrpise Manual Upgrade Interface'
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
  object v432Pwbtn: TButton
    Left = 10
    Top = 32
    Width = 113
    Height = 25
    Caption = 'Set v4.40 Passwords'
    TabOrder = 0
    OnClick = v432PwbtnClick
  end
  object Edit1: TEdit
    Left = 4
    Top = 2
    Width = 375
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 388
    Top = 0
    Width = 29
    Height = 23
    Caption = '...'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 178
    Top = 70
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 3
    OnClick = Button2Click
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 252
    Top = 58
  end
end
