object EditCCDep: TEditCCDep
  Left = 373
  Top = 208
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'CC/Dept Filter'
  ClientHeight = 126
  ClientWidth = 180
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
  object SBSBackGroup1: TSBSBackGroup
    Left = 5
    Top = 2
    Width = 168
    Height = 81
    TextId = 0
  end
  object Label83: Label8
    Left = 13
    Top = 14
    Width = 151
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = 'Cost Centre/Dept Filter'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8
    Left = 14
    Top = 42
    Width = 23
    Height = 14
    Caption = 'CC : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 86
    Top = 43
    Width = 28
    Height = 14
    Caption = 'Dept :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 8
    Top = 95
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 91
    Top = 95
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object Id3CCF: Text8Pt
    Tag = 1
    Left = 35
    Top = 39
    Width = 46
    Height = 22
    HelpContext = 633
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
  object Id3DepF: Text8Pt
    Tag = 1
    Left = 114
    Top = 39
    Width = 46
    Height = 22
    HelpContext = 633
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnExit = Id3CCFExit
    TextId = 0
    ViaSBtn = False
  end
end
