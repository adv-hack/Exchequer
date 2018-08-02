object frmProgress: TfrmProgress
  Left = 382
  Top = 268
  BorderStyle = bsToolWindow
  Caption = 'Creating SJIs'
  ClientHeight = 219
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object mProgress: TMemo
    Left = 8
    Top = 8
    Width = 257
    Height = 177
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnClose: TButton
    Left = 184
    Top = 192
    Width = 80
    Height = 21
    Caption = '&Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object btnSave: TButton
    Left = 96
    Top = 192
    Width = 80
    Height = 21
    Caption = 'S&ave Text'
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object btnStart: TButton
    Left = 8
    Top = 192
    Width = 80
    Height = 21
    Caption = '&Start'
    TabOrder = 3
    OnClick = btnStartClick
  end
  object SaveDialog1: TSaveDialog
    Left = 16
    Top = 16
  end
end
