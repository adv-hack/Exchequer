object EditCustCaption: TEditCustCaption
  Left = 501
  Top = 228
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Alter Custom Field'
  ClientHeight = 139
  ClientWidth = 180
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object SBSBackGroup1: TSBSBackGroup
    Left = 5
    Top = 2
    Width = 168
    Height = 97
    TextId = 0
  end
  object PALab: Label8
    Left = 10
    Top = 13
    Width = 157
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = 'Field Caption'
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
    Top = 112
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 91
    Top = 112
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object BorCheck1: TBorCheck
    Left = 18
    Top = 64
    Width = 94
    Height = 20
    HelpContext = 1271
    Caption = 'Hide field?'
    CheckColor = clWindowText
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    TabStop = True
    TextId = 0
  end
  object fCaption: Text8Pt
    Left = 43
    Top = 33
    Width = 93
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 15
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TextId = 0
    ViaSBtn = False
  end
end
