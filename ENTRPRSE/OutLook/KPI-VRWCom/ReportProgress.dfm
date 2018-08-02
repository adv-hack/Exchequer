object frmReportProgress: TfrmReportProgress
  Left = 356
  Top = 254
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Print Report'
  ClientHeight = 114
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 41
    Height = 14
    Caption = 'Report : '
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 53
    Height = 14
    Caption = 'Progress : '
  end
  object lReport: TLabel
    Left = 64
    Top = 8
    Width = 41
    Height = 14
    Caption = 'Report : '
  end
  object lProgress: TLabel
    Left = 64
    Top = 32
    Width = 53
    Height = 14
    Caption = 'Progress : '
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 56
    Width = 353
    Height = 25
    Min = 0
    Max = 100
    TabOrder = 0
  end
  object Button1: TButton
    Left = 280
    Top = 88
    Width = 80
    Height = 21
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = Button1Click
  end
end
