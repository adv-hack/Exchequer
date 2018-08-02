object StkChkFrm: TStkChkFrm
  Left = 278
  Top = 175
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
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
    Height = 91
    Align = alTop
    AutoSize = True
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label1: Label8
      Left = 8
      Top = 2
      Width = 3
      Height = 14
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label2: TLabel
      Left = 6
      Top = 76
      Width = 5
      Height = 13
      Alignment = taCenter
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
    Enabled = False
    TabOrder = 1
    Visible = False
    OnClick = CanCP1BtnClick
  end
end
