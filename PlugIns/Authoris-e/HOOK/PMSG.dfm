object PMsgForm: TPMsgForm
  Left = 471
  Top = 353
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Exchequer Authoris-e'
  ClientHeight = 131
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 9
    Top = 8
    Width = 233
    Height = 113
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 40
      Top = 32
      Width = 161
      Height = 41
      Alignment = taCenter
      AutoSize = False
      Caption = 'Please wait...Sending  Request'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
  end
end
