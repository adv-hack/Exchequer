object frmRepDelivery: TfrmRepDelivery
  Left = 299
  Top = 169
  BorderStyle = bsDialog
  Caption = 'Report/CSV Delivery'
  ClientHeight = 206
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 119
    Width = 313
    Height = 50
    Shape = bsFrame
  end
  object rgType: TRadioGroup
    Left = 8
    Top = 8
    Width = 313
    Height = 105
    Caption = 'Type'
    Columns = 2
    Items.Strings = (
      'Email address'
      'URL'
      'Printer'
      'File location'
      'Fax')
    TabOrder = 0
  end
  object edtDelivery: TEdit
    Left = 16
    Top = 136
    Width = 297
    Height = 22
    TabOrder = 1
  end
  object Button1: TButton
    Left = 176
    Top = 176
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 248
    Top = 176
    Width = 65
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
