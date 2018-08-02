object frmOptions: TfrmOptions
  Left = 384
  Top = 263
  BorderStyle = bsToolWindow
  Caption = 'Options'
  ClientHeight = 72
  ClientWidth = 182
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object btnHoldFlag: TButton
    Left = 8
    Top = 8
    Width = 169
    Height = 25
    Caption = 'Set Late Payment Hold Flag'
    TabOrder = 0
    OnClick = btnHoldFlagClick
  end
  object btnCreateSJI: TButton
    Left = 8
    Top = 40
    Width = 169
    Height = 25
    Caption = 'Create Late Payment SJIs'
    TabOrder = 1
    OnClick = btnCreateSJIClick
  end
end
