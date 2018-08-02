object frmModemTest: TfrmModemTest
  Left = 329
  Top = 268
  BorderStyle = bsDialog
  Caption = 'Modem Testing'
  ClientHeight = 119
  ClientWidth = 310
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lModemName: TLabel
    Left = 8
    Top = 8
    Width = 65
    Height = 13
    Caption = 'lModemName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object label1: TLabel
    Left = 8
    Top = 52
    Width = 74
    Height = 13
    Caption = 'Number to dial :'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 32
    Width = 297
    Height = 2
    Shape = bsFrame
  end
  object edNumber: TEdit
    Left = 88
    Top = 48
    Width = 217
    Height = 21
    TabOrder = 0
  end
  object btnClose: TButton
    Left = 240
    Top = 88
    Width = 65
    Height = 25
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 2
  end
  object btnTest: TButton
    Left = 96
    Top = 88
    Width = 65
    Height = 25
    Caption = '&Test'
    TabOrder = 1
    OnClick = btnTestClick
  end
  object btnCancel: TButton
    Left = 168
    Top = 88
    Width = 65
    Height = 25
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
end
