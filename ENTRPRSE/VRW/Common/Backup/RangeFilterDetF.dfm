object frmRangeFilterDetail: TfrmRangeFilterDetail
  Left = 201
  Top = 139
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Range Filter Detail'
  ClientHeight = 174
  ClientWidth = 497
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
  object pnlInputType: TPanel
    Left = 5
    Top = 5
    Width = 487
    Height = 137
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object lblInputType: TLabel
      Left = 44
      Top = 37
      Width = 24
      Height = 14
      Caption = 'Type'
    end
    object lblRFDesc: Label8
      Left = 6
      Top = 11
      Width = 63
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Description'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblRFFrom: Label8
      Left = 6
      Top = 63
      Width = 63
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Range Start'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblRFTo: Label8
      Left = 6
      Top = 89
      Width = 63
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Range End'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object cbInputType: TComboBox
      Left = 74
      Top = 34
      Width = 170
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 1
      OnClick = cbInputTypeClick
    end
    object edtRFDesc: Text8Pt
      Left = 74
      Top = 8
      Width = 405
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 255
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TextId = 0
      ViaSBtn = False
    end
    object chkRFAskUser: TCheckBox
      Left = 74
      Top = 113
      Width = 187
      Height = 16
      Caption = 'Always ask the user for input'
      TabOrder = 2
    end
  end
  object btnOK: TButton
    Left = 165
    Top = 148
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 252
    Top = 148
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.01 for Delphi 6.01'
    Left = 422
    Top = 20
  end
end
