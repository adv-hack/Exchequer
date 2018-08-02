object frmAccount: TfrmAccount
  Left = 326
  Top = 265
  BorderStyle = bsDialog
  Caption = 'Checking SMS account'
  ClientHeight = 126
  ClientWidth = 274
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
    Width = 257
    Height = 81
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 241
      Height = 57
      Alignment = taCenter
      AutoSize = False
      Caption = 'Please wait ... connecting to call centre.'
      WordWrap = True
    end
  end
  object btnClose: TButton
    Left = 99
    Top = 96
    Width = 75
    Height = 25
    Caption = '&Close'
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 240
    Top = 96
  end
end
