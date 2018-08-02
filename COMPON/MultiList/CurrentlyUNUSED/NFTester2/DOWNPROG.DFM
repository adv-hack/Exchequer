object FrmDownloadItems: TFrmDownloadItems
  Left = 376
  Top = 275
  BorderStyle = bsDialog
  Caption = 'Uploading...'
  ClientHeight = 103
  ClientWidth = 256
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 241
    Height = 65
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 48
      Top = 16
      Width = 37
      Height = 14
      Alignment = taRightJustify
      Caption = 'Status :'
    end
    object lStatus: TLabel
      Left = 88
      Top = 16
      Width = 45
      Height = 14
      Caption = 'Initialising'
    end
    object Label2: TLabel
      Left = 60
      Top = 32
      Width = 25
      Height = 14
      Alignment = taRightJustify
      Caption = 'Item :'
    end
    object lName: TLabel
      Left = 88
      Top = 32
      Width = 32
      Height = 14
      Caption = '(none)'
    end
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 80
    Width = 241
    Height = 17
    Min = 0
    Max = 100
    TabOrder = 1
  end
  object WaitForOpen: TTimer
    Enabled = False
    Interval = 100
    OnTimer = WaitForOpenTimer
    Left = 216
    Top = 16
  end
end
