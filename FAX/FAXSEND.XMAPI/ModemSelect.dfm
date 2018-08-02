object frmModemSelect: TfrmModemSelect
  Left = 182
  Top = 194
  BorderStyle = bsDialog
  Caption = 'Select Modem'
  ClientHeight = 66
  ClientWidth = 230
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object cbPorts: TComboBox
    Left = 8
    Top = 8
    Width = 209
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
  object SBSButton1: TSBSButton
    Left = 136
    Top = 40
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
    TextId = 0
  end
  object SBSButton2: TSBSButton
    Left = 48
    Top = 40
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
    TextId = 0
  end
end
