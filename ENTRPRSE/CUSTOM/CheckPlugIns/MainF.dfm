object Form1: TForm1
  Left = 387
  Top = 168
  Width = 710
  Height = 392
  Caption = 'Exchequer 2015 R1'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object shBanner: TShape
    Left = 0
    Top = 0
    Width = 697
    Height = 43
    Align = alTop
  end
  object lblBanner: TLabel
    Left = 8
    Top = 7
    Width = 174
    Height = 29
    Caption = 'Check Plug-Ins'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 8
    Top = 52
    Width = 185
    Height = 14
    Caption = 'Your active Exchequer installation is in'
  end
  object lblExchequerDir: TLabel
    Left = 198
    Top = 52
    Width = 427
    Height = 14
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 9
    Top = 77
    Width = 406
    Height = 14
    Caption = 
      'The following active plug-ins have been found in your active Exc' +
      'hequer Installation:-'
  end
  object lblVersion: TLabel
    Left = 650
    Top = 14
    Width = 47
    Height = 14
    Alignment = taRightJustify
    Caption = 'lblVersion'
    Font.Charset = ANSI_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object scrlPlugIns: TScrollBox
    Left = 42
    Top = 104
    Width = 650
    Height = 244
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 0
  end
end
