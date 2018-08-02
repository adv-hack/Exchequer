object frmScanEnterprise: TfrmScanEnterprise
  Left = 327
  Top = 258
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Scanning Exchequer Data Sets, Please Wait...'
  ClientHeight = 58
  ClientWidth = 453
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblProgress: TLabel
    Left = 24
    Top = 10
    Width = 406
    Height = 13
    Alignment = taCenter
    AutoSize = False
    ShowAccelChar = False
    Transparent = True
  end
  object ProgressBar1: TProgressBar
    Left = 24
    Top = 29
    Width = 406
    Height = 22
    Min = 0
    Max = 100
    Position = 50
    TabOrder = 0
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 250
    OnTimer = ScanEnterprise
    Left = 254
    Top = 23
  end
end
