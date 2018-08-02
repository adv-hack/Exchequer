object frmProgress: TfrmProgress
  Left = 391
  Top = 315
  BorderStyle = bsToolWindow
  Caption = 'Processing'
  ClientHeight = 89
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object Shape1: TShape
    Left = 8
    Top = 8
    Width = 257
    Height = 73
    Pen.Color = clGray
  end
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 132
    Height = 14
    Caption = 'Processing Transactions....'
    Transparent = True
  end
  object lStatus: TLabel
    Left = 24
    Top = 48
    Width = 233
    Height = 14
    AutoSize = False
    Transparent = True
  end
end
