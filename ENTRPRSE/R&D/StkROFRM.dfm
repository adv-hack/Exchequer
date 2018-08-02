object ROCtrlForm: TROCtrlForm
  Left = 200
  Top = 124
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 104
  ClientWidth = 236
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SetPanel: TSBSPanel
    Left = 0
    Top = 0
    Width = 236
    Height = 73
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 80
    Top = 79
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Abort'
    ModalResult = 3
    TabOrder = 1
  end
end
