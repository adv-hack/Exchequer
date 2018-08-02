object GenProg: TGenProg
  Left = 200
  Top = 108
  Width = 404
  Height = 173
  BorderIcons = []
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SBSBackGroup1: TSBSBackGroup
    Left = 0
    Top = 0
    Width = 395
    Height = 139
    TextId = 0
  end
  object ProgLab: Label8
    Left = 5
    Top = 22
    Width = 386
    Height = 22
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8
    Left = 5
    Top = 79
    Width = 388
    Height = 15
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TextId = 0
  end
  object ProgressBar1: TProgressBar
    Left = 17
    Top = 53
    Width = 364
    Height = 21
    Min = 0
    Max = 100
    TabOrder = 0
  end
  object AbortBtn: TButton
    Left = 160
    Top = 107
    Width = 75
    Height = 25
    Caption = '&Abort'
    ModalResult = 3
    TabOrder = 1
    OnClick = AbortBtnClick
  end
end
