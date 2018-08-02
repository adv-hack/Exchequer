object frmPIIProgress: TfrmPIIProgress
  Left = 503
  Top = 268
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Show PII Tree'
  ClientHeight = 57
  ClientWidth = 318
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial Narrow'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 155
    Height = 15
    Caption = 'Please wait. Loading PII Information...'
  end
  object barProgress: TAdvProgressBar
    Left = 8
    Top = 28
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
