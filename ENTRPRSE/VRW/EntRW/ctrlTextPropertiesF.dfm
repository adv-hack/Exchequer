object frmTextProperties: TfrmTextProperties
  Left = 330
  Top = 169
  HelpContext = 75
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Text Properties'
  ClientHeight = 162
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Scaled = False
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 14
  object GroupBox1: TGroupBox
    Left = 5
    Top = 1
    Width = 428
    Height = 86
    TabOrder = 0
    object Label81: Label8
      Left = 5
      Top = 15
      Width = 58
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Text'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 5
      Top = 59
      Width = 58
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Alignment'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object memText: TMemo
      Left = 66
      Top = 13
      Width = 354
      Height = 39
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 255
      ParentFont = False
      TabOrder = 0
      OnChange = memTextChange
    end
    object cbAlignment: TComboBox
      Left = 66
      Top = 57
      Width = 193
      Height = 22
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 1
      OnClick = cbAlignmentClick
      Items.Strings = (
        'Left Justified'
        'Centred Horizontally'
        'Right Justified')
    end
  end
  object btnOK: TSBSButton
    Left = 439
    Top = 7
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 439
    Top = 34
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    TextId = 0
  end
  object GroupBox2: TGroupBox
    Left = 5
    Top = 90
    Width = 428
    Height = 68
    Caption = ' Font Example '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object lblFontExample: TLabel
      Left = 6
      Top = 17
      Width = 416
      Height = 45
      AutoSize = False
      Caption = 'abcdefghijklmnopqrstuvwxyz 1234567890'
      OnDblClick = btnChangeFontClick
    end
  end
  object btnChangeFont: TSBSButton
    Left = 439
    Top = 135
    Width = 80
    Height = 21
    Caption = 'Change &Font'
    TabOrder = 4
    OnClick = btnChangeFontClick
    TextId = 0
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Options = [fdEffects, fdForceFontExist]
    Left = 460
    Top = 88
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 384
    Top = 107
  end
end
