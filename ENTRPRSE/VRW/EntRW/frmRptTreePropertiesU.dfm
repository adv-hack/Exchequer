object frmRptTreeProperties: TfrmRptTreeProperties
  Left = 324
  Top = 110
  Width = 607
  Height = 233
  Caption = 'Properties'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblRepName: Label8
    Left = 4
    Top = 40
    Width = 61
    Height = 14
    Caption = 'Report name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lblRepDesc: Label8
    Left = 4
    Top = 68
    Width = 54
    Height = 14
    Caption = 'Description'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lblParentName: Label8
    Left = 4
    Top = 12
    Width = 30
    Height = 14
    Caption = 'Folder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lblFileName: Label8
    Left = 4
    Top = 140
    Width = 42
    Height = 14
    Caption = 'Filename'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object edtRepName: Text8Pt
    Left = 72
    Top = 36
    Width = 509
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 2
    TextId = 0
    ViaSBtn = False
  end
  object edtParentName: Text8Pt
    Left = 72
    Top = 8
    Width = 509
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 1
    TextId = 0
    ViaSBtn = False
  end
  object edtFileName: Text8Pt
    Left = 72
    Top = 136
    Width = 509
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 4
    TextId = 0
    ViaSBtn = False
  end
  object memRepDesc: TMemo
    Left = 72
    Top = 64
    Width = 509
    Height = 65
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
  end
  object btnOk: TSBSButton
    Left = 254
    Top = 168
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Ok'
    Default = True
    TabOrder = 0
    OnClick = btnOkClick
    TextId = 0
  end
end