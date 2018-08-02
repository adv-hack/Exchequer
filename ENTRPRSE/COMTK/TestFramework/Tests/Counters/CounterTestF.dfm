object frmCounterMain: TfrmCounterMain
  Left = 196
  Top = 342
  BorderStyle = bsDialog
  Caption = 'Toolkit Object Counter'
  ClientHeight = 143
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnGo: TButton
    Left = 336
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 0
    OnClick = btnGoClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 321
    Height = 129
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 32
      Height = 13
      Caption = 'Label1'
    end
    object lblProgress: TLabel
      Left = 16
      Top = 48
      Width = 51
      Height = 13
      Caption = 'lblProgress'
    end
  end
end
