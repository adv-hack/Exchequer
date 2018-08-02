object frmStatus: TfrmStatus
  Left = 295
  Top = 201
  BorderStyle = bsDialog
  Caption = 'Status'
  ClientHeight = 221
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 8
    Width = 225
    Height = 209
    Items.Strings = (
      'Idle'
      'Processing query'
      'SMS messages ready to go'
      'Email messages ready to go'
      'SMS and Email messages ready to go'
      'Sending messages'
      'Error'
      'Report ready to run'
      'Report ready to send')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 240
    Top = 16
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 240
    Top = 48
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
