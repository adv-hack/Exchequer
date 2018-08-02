object BarP: TBarP
  Left = 225
  Top = 157
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 116
  ClientWidth = 179
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SBSPanel1: TSBSPanel
    Left = 5
    Top = 4
    Width = 168
    Height = 81
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label81: Label8
      Left = 19
      Top = 8
      Width = 120
      Height = 26
      Alignment = taCenter
      AutoSize = False
      Caption = '% Complete'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object SBSPanel2: TSBSPanel
      Left = 7
      Top = 33
      Width = 156
      Height = 23
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object Gauge1: TGauge
        Left = 1
        Top = 1
        Width = 153
        Height = 21
        Color = clBlack
        BorderStyle = bsNone
        ForeColor = clAqua
        BackColor = clBtnFace
        ParentColor = False
        Progress = 0
      end
    end
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 45
    Top = 90
    Width = 80
    Height = 22
    Cancel = True
    Caption = '&Abort'
    ModalResult = 3
    TabOrder = 1
    OnClick = CanCP1BtnClick
  end
end
