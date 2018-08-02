object frmImportStatement: TfrmImportStatement
  Left = 190
  Top = 114
  BorderIcons = [biHelp]
  BorderStyle = bsSingle
  Caption = 'Importing Statement'
  ClientHeight = 105
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 297
    Height = 89
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 24
      Width = 3
      Height = 14
    end
    object ProgressBar1: TProgressBar
      Left = 32
      Top = 48
      Width = 241
      Height = 17
      Min = 0
      Max = 100
      TabOrder = 0
    end
  end
end
