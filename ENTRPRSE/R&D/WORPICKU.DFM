object WOPPickFrm: TWOPPickFrm
  Left = 225
  Top = 157
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Generate Picking List'
  ClientHeight = 129
  ClientWidth = 299
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SBSPanel3: TSBSPanel
    Left = 0
    Top = 0
    Width = 299
    Height = 97
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label1: Label8
      Left = 8
      Top = 4
      Width = 284
      Height = 67
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label2: TLabel
      Left = 6
      Top = 78
      Width = 291
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 112
    Top = 102
    Width = 80
    Height = 22
    Cancel = True
    Caption = '&Abort'
    Default = True
    TabOrder = 1
    OnClick = CanCP1BtnClick
  end
end
