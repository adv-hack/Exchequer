object frmEncryptProgress: TfrmEncryptProgress
  Left = 482
  Top = 236
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'frmEncryptProgress'
  ClientHeight = 50
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object lblProcessing: TLabel
    Left = 8
    Top = 4
    Width = 301
    Height = 13
    AutoSize = False
    Caption = 'Processing...'
  end
  object barProgress: TAdvProgressBar
    Left = 8
    Top = 24
    Width = 301
    Height = 18
    CompletionSmooth = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    Infinite = True
    Level0ColorTo = 14811105
    Level1ColorTo = 13303807
    Level2Color = 5483007
    Level2ColorTo = 11064319
    Level3ColorTo = 13290239
    Level1Perc = 70
    Level2Perc = 90
    Position = 0
    ShowBorder = True
    ShowPercentage = False
    ShowPosition = False
    Steps = 20
    Version = '1.1.2.1'
  end
end