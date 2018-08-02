object frmMainForm: TfrmMainForm
  Left = 329
  Top = 289
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Progress Monitor : Sales Ledger - Auto Settle.'
  ClientHeight = 90
  ClientWidth = 267
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbPrompt: TLabel
    Left = 10
    Top = 36
    Width = 65
    Height = 13
    AutoSize = False
    Caption = 'Processing :'
  end
  object lbProgress: TLabel
    Left = 80
    Top = 36
    Width = 180
    Height = 13
    AutoSize = False
  end
  object pbProgressBar: TProgressBar
    Left = 10
    Top = 10
    Width = 250
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 0
  end
  object btnClose: TButton
    Left = 97
    Top = 58
    Width = 75
    Height = 22
    Caption = '&Close'
    TabOrder = 1
    Visible = False
    OnClick = btnCloseClick
  end
end
