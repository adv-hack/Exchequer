object frmCommonBase: TfrmCommonBase
  Left = 273
  Top = 115
  Width = 474
  Height = 185
  Caption = 'frmCommonBase'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object shBanner: TShape
    Left = 0
    Top = 0
    Width = 458
    Height = 43
    Align = alTop
  end
  object lblBanner: TLabel
    Left = 8
    Top = 7
    Width = 250
    Height = 29
    Caption = 'Your Description Here'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 302
    Top = 1
  end
end
