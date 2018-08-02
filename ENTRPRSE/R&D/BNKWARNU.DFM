object BankWarnFrm: TBankWarnFrm
  Left = 312
  Top = 156
  ActiveControl = OkCP1Btn
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Bank Reconciliation'
  ClientHeight = 194
  ClientWidth = 275
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object SBSPanel1: TSBSPanel
    Left = 7
    Top = 9
    Width = 260
    Height = 136
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Image1: TImage
      Left = 10
      Top = 6
      Width = 53
      Height = 73
    end
    object BankWMsg: TLabel
      Left = 68
      Top = 6
      Width = 185
      Height = 125
      AutoSize = False
    end
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 58
    Top = 160
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 144
    Top = 160
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 2
  end
end
