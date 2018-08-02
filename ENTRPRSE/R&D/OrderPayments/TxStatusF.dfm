object ccTxStatusForm: TccTxStatusForm
  Left = 249
  Top = 303
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Transaction Status'
  ClientHeight = 278
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    377
    278)
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 188
    Height = 14
    Caption = 'Processing Transaction.  Please wait...'
  end
  object lblTransID: TLabel
    Left = 16
    Top = 48
    Width = 69
    Height = 14
    Caption = 'Transaction ID'
  end
  object Label2: TLabel
    Left = 16
    Top = 72
    Width = 91
    Height = 14
    Caption = 'Transaction Status'
  end
  object lblTransactionStatus: TLabel
    Left = 120
    Top = 72
    Width = 30
    Height = 14
    Caption = '          '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblOurRef: TLabel
    Left = 120
    Top = 48
    Width = 45
    Height = 14
    Caption = 'lblOurRef'
  end
  object AdvProgressBar: TAdvProgressBar
    Left = 16
    Top = 96
    Width = 345
    Height = 18
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    Infinite = True
    InfiniteInterval = 75
    Level0Color = clNavy
    Level0ColorTo = 14811105
    Level1ColorTo = 13303807
    Level2Color = 5483007
    Level2ColorTo = 11064319
    Level3ColorTo = 13290239
    Level1Perc = 70
    Level2Perc = 90
    Position = 50
    ShowBorder = True
    ShowPercentage = False
    ShowPosition = False
    Steps = 10
    Version = '1.1.2.1'
  end
  object richStatusLog: TRichEdit
    Left = 8
    Top = 120
    Width = 361
    Height = 121
    BevelInner = bvNone
    BevelOuter = bvNone
    ScrollBars = ssVertical
    TabOrder = 0
    Visible = False
  end
  object btnClose: TButton
    Left = 288
    Top = 248
    Width = 75
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'Cancel'
    Enabled = False
    TabOrder = 1
    Visible = False
    OnClick = btnCloseClick
  end
  object txStatusPollTimer: TTimer
    Interval = 3000
    OnTimer = txStatusPollTimerTimer
    Left = 344
    Top = 8
  end
  object TransactionTimeoutTimer: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = TransactionTimeoutTimerTimer
    Left = 288
    Top = 8
  end
end
