object frmRecFind: TfrmRecFind
  Left = 184
  Top = 224
  HelpContext = 2001
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Find'
  ClientHeight = 128
  ClientWidth = 377
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
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 273
    Height = 113
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 55
      Top = 20
      Width = 35
      Height = 14
      Alignment = taRightJustify
      Caption = 'Find by'
    end
    object Label2: TLabel
      Left = 30
      Top = 60
      Width = 60
      Height = 14
      Alignment = taRightJustify
      Caption = 'Value to find'
    end
    object ceAmount: TCurrencyEdit
      Left = 104
      Top = 56
      Width = 121
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      ParentFont = False
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object edtDate: TEditDate
      Left = 104
      Top = 56
      Width = 121
      Height = 22
      AutoSelect = False
      EditMask = '00/00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 1
      Placement = cpAbove
    end
    object edtDocNo: Text8Pt
      Left = 104
      Top = 56
      Width = 121
      Height = 22
      HelpContext = 2003
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnExit = edtDocNoExit
      TextId = 0
      ViaSBtn = False
    end
    object cbFindBy: TSBSComboBox
      Left = 104
      Top = 16
      Width = 145
      Height = 22
      HelpContext = 2002
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ItemIndex = 0
      ParentFont = False
      TabOrder = 3
      Text = 'Document No'
      OnChange = cbFindByChange
      Items.Strings = (
        'Document No'
        'Account Code'
        'Amount'
        'Date'
        'Line Description'
        'Reference')
      MaxListWidth = 0
    end
  end
  object btnOK: TSBSButton
    Left = 288
    Top = 16
    Width = 80
    Height = 21
    HelpContext = 2004
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 288
    Top = 40
    Width = 80
    Height = 21
    HelpContext = 2005
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    TextId = 0
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 312
    Top = 96
  end
end
