object Frm_FieldEdit: TFrm_FieldEdit
  Left = 384
  Top = 189
  HelpContext = 328
  Anchors = [akLeft]
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Change User Field'
  ClientHeight = 95
  ClientWidth = 254
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 22
    Top = 7
    Width = 61
    Height = 14
    Alignment = taRightJustify
    Caption = 'Field Caption'
  end
  object EBox_FCaption: TEdit
    Left = 90
    Top = 4
    Width = 157
    Height = 22
    BiDiMode = bdLeftToRight
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 15
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 0
    Text = 'EBox_FCaption'
  end
  object Btn_Cancel: TButton
    Left = 136
    Top = 67
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object Btn_OK: TButton
    Left = 48
    Top = 67
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 3
    OnClick = Btn_OKClick
  end
  object ChBox_FEnabled: TCheckBoxEx
    Tag = 1
    Left = 18
    Top = 29
    Width = 85
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Field Enabled'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    Modified = False
    ReadOnly = False
  end
  object cbContainsPIIData: TCheckBoxEx
    Tag = 1
    Left = 4
    Top = 47
    Width = 99
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Contains PII Data'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    Modified = False
    ReadOnly = False
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 190
    Top = 31
  end
end
