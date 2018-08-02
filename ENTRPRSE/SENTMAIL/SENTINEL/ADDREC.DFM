object frmAddRecs: TfrmAddRecs
  Left = 376
  Top = 376
  Width = 302
  Height = 179
  Caption = 'Please wait  -  Recording existing data'
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
    Left = 10
    Top = 8
    Width = 273
    Height = 105
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object lblProgress: TLabel
      Left = 12
      Top = 32
      Width = 249
      Height = 25
      Alignment = taCenter
      AutoSize = False
    end
  end
  object Button1: TButton
    Left = 208
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = Button1Click
  end
end
