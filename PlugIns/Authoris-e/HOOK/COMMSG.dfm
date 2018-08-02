object frmComMsg: TfrmComMsg
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Exchequer Authoris-e'
  ClientHeight = 130
  ClientWidth = 291
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 273
    Height = 89
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel1'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 241
      Height = 73
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
  end
  object btnYes: TBitBtn
    Left = 50
    Top = 104
    Width = 80
    Height = 21
    Caption = '&Yes'
    Default = True
    ModalResult = 6
    TabOrder = 1
    Visible = False
    NumGlyphs = 2
  end
  object btnNo: TBitBtn
    Left = 162
    Top = 104
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&No'
    ModalResult = 7
    TabOrder = 2
    Visible = False
    NumGlyphs = 2
  end
  object btnOK: TBitBtn
    Left = 106
    Top = 104
    Width = 80
    Height = 21
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
    NumGlyphs = 2
  end
end
