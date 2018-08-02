object frmFileList: TfrmFileList
  Left = 302
  Top = 198
  Width = 392
  Height = 327
  Caption = 'Files'
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
  object BitBtn1: TBitBtn
    Left = 304
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Directory'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object Panel1: TPanel
    Left = 8
    Top = 240
    Width = 289
    Height = 49
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 28
      Width = 56
      Height = 13
      Caption = 'Current File:'
    end
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 82
      Height = 13
      Caption = 'Current Directory:'
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 8
    Width = 289
    Height = 225
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel2'
    TabOrder = 2
    object list: TListBox
      Left = 8
      Top = 8
      Width = 273
      Height = 209
      ItemHeight = 13
      Sorted = True
      TabOrder = 0
      OnClick = listClick
    end
  end
end
