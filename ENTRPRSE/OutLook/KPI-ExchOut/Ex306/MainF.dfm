object frmOurRef: TfrmOurRef
  Left = 317
  Top = 191
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Print Transaction'
  ClientHeight = 37
  ClientWidth = 306
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 11
    Width = 58
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'OurRef'
  end
  object edtOurRef: TEdit
    Left = 70
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'SIN008255'
  end
  object btnPrint: TButton
    Left = 199
    Top = 6
    Width = 100
    Height = 25
    Caption = 'Print Transaction'
    TabOrder = 1
    OnClick = btnPrintClick
  end
end
