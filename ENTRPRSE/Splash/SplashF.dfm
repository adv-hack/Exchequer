object EnterSplash: TEnterSplash
  Left = 727
  Top = 232
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Exchequer Splash'
  ClientHeight = 215
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 18
    Top = 189
    Width = 65
    Height = 14
    Caption = #169' Advanced'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lblProdName: TLabel
    Left = 19
    Top = 15
    Width = 187
    Height = 41
    AutoSize = False
    Caption = 'Exchequer'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -35
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object imgSplash: TImage
    Left = 0
    Top = 0
    Width = 358
    Height = 215
    Align = alClient
  end
  object lblLicenceType: TLabel
    Left = 29
    Top = 116
    Width = 146
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = 'Licensed To'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lblLicencee: TLabel
    Left = 29
    Top = 131
    Width = 146
    Height = 33
    Alignment = taCenter
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
    WordWrap = True
  end
  object lblDemoVer: TLabel
    Left = 29
    Top = 101
    Width = 146
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = 'Demonstration System'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lblVAOFlag: TLabel
    Left = 4
    Top = 4
    Width = 8
    Height = 13
    AutoSize = False
    Caption = '*'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 750
    OnTimer = Timer1Timer
    Left = 238
    Top = 93
  end
end
