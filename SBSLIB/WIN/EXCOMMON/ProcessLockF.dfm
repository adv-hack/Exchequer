object frmProcessLock: TfrmProcessLock
  Left = 418
  Top = 332
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Currency Revaluation'
  ClientHeight = 181
  ClientWidth = 374
  Color = clBtnFace
  Constraints.MaxHeight = 212
  Constraints.MaxWidth = 382
  Constraints.MinHeight = 212
  Constraints.MinWidth = 382
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 10
    Top = 8
    Width = 353
    Height = 49
    AutoSize = False
    Caption = 
      'It was not possible to start this process as another process is ' +
      'running. Retrying now....'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lblProcessType: TLabel
    Left = 25
    Top = 84
    Width = 88
    Height = 16
    Caption = 'lblProcessType'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lblUserID: TLabel
    Left = 25
    Top = 104
    Width = 52
    Height = 16
    Caption = 'lblUserID'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lblTimeStamp: TLabel
    Left = 25
    Top = 124
    Width = 77
    Height = 16
    Caption = 'lblTimestamp'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object btnCancel: TSBSButton
    Left = 147
    Top = 152
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
    OnClick = btnCancelClick
    TextId = 0
  end
  object ProgressBar: TAdvProgress
    Left = 10
    Top = 56
    Width = 344
    Height = 17
    Min = 0
    Max = 100
    Smooth = True
    TabOrder = 1
    BarColor = clHighlight
    BkColor = clWindow
    Version = '1.2.0.0'
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 8
    Top = 144
  end
end
