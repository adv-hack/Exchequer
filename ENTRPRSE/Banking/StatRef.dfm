object frmGetStatRef: TfrmGetStatRef
  Left = 256
  Top = 110
  HelpContext = 1990
  BorderStyle = bsSingle
  Caption = 'Import Bank Statement'
  ClientHeight = 111
  ClientWidth = 317
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
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 14
  object SBSButton1: TSBSButton
    Left = 232
    Top = 8
    Width = 80
    Height = 21
    HelpContext = 1993
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    TextId = 0
  end
  object SBSButton2: TSBSButton
    Left = 232
    Top = 32
    Width = 80
    Height = 21
    HelpContext = 1994
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
    TextId = 0
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 217
    Height = 97
    Caption = 'Statement Details '
    TabOrder = 2
    object Label2: TLabel
      Left = 44
      Top = 28
      Width = 22
      Height = 14
      Alignment = taRightJustify
      Caption = 'Date'
    end
    object Label3: TLabel
      Left = 15
      Top = 60
      Width = 51
      Height = 14
      Alignment = taRightJustify
      Caption = 'Reference'
    end
    object edDate: TEditDate
      Left = 72
      Top = 24
      Width = 81
      Height = 22
      HelpContext = 1991
      AutoSelect = False
      EditMask = '00/00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 0
      Placement = cpAbove
    end
    object edtRef: Text8Pt
      Left = 72
      Top = 56
      Width = 121
      Height = 22
      HelpContext = 1992
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TextId = 0
      ViaSBtn = False
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 8
    Top = 80
  end
end
