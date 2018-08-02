object frmProgress: TfrmProgress
  Left = 385
  Top = 285
  BorderStyle = bsToolWindow
  Caption = 'Progress'
  ClientHeight = 74
  ClientWidth = 336
  Color = clCream
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 68
    Height = 13
    Caption = 'Please Wait...'
  end
  object Label2: TLabel
    Left = 16
    Top = 40
    Width = 41
    Height = 13
    Caption = 'Status : '
  end
  object lStatus: TLabel
    Left = 64
    Top = 40
    Width = 47
    Height = 13
    Caption = 'Initialising'
  end
end
