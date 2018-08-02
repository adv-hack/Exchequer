object frmDiag: TfrmDiag
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Sentimail Diagnostics'
  ClientHeight = 256
  ClientWidth = 398
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
  object memDiag: TMemo
    Left = 8
    Top = 8
    Width = 313
    Height = 241
    Color = clBtnFace
    TabOrder = 0
  end
  object Button1: TButton
    Left = 328
    Top = 8
    Width = 65
    Height = 25
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 1
  end
end
