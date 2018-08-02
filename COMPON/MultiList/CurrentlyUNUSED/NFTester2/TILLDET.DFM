object FrmTillDetails: TFrmTillDetails
  Left = 374
  Top = 251
  HelpContext = 53
  BorderStyle = bsDialog
  Caption = 'Till Details'
  ClientHeight = 145
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 16
    Width = 233
    Height = 89
    Shape = bsFrame
  end
  object Label81: Label8
    Left = 24
    Top = 38
    Width = 75
    Height = 14
    Alignment = taRightJustify
    Caption = 'Till Description :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 51
    Top = 70
    Width = 48
    Height = 14
    Alignment = taRightJustify
    Caption = 'Till Name :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lTillNo: Label8
    Left = 16
    Top = 8
    Width = 42
    Height = 14
    Caption = 'Till No 1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TextId = 0
  end
  object edTillDesc: Text8Pt
    Left = 104
    Top = 34
    Width = 121
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
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
  object edTillName: Text8Pt
    Left = 104
    Top = 66
    Width = 121
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 8
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TextId = 0
    ViaSBtn = False
  end
  object btnOK: TButton
    Left = 88
    Top = 112
    Width = 73
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 168
    Top = 112
    Width = 73
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
