object AltSCRec: TAltSCRec
  Left = 559
  Top = 270
  HelpContext = 597
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Alternative Code Entry'
  ClientHeight = 201
  ClientWidth = 537
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefaultPosOnly
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object NPNotePanel: TPanel
    Left = 6
    Top = 10
    Width = 525
    Height = 159
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label89: Label8
      Left = 48
      Top = 12
      Width = 55
      Height = 14
      Caption = 'Stock Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label81: Label8
      Left = 2
      Top = 37
      Width = 102
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Alternative Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 35
      Top = 60
      Width = 69
      Height = 14
      Caption = 'Account Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label83: Label8
      Left = 223
      Top = 12
      Width = 63
      Height = 14
      Caption = 'Stored Desc.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label84: Label8
      Left = 237
      Top = 36
      Width = 47
      Height = 14
      Caption = 'Alt. Desc.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label85: Label8
      Left = 236
      Top = 61
      Width = 48
      Height = 14
      Caption = 'A/C Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label86: Label8
      Left = 212
      Top = 87
      Width = 72
      Height = 14
      Caption = 'Re-Order Price'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label87: Label8
      Left = 217
      Top = 112
      Width = 67
      Height = 14
      Caption = 'Re-Order. Qty'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label88: Label8
      Left = 194
      Top = 136
      Width = 91
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Replacement Qty'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label810: Label8
      Left = 352
      Top = 87
      Width = 66
      Height = 14
      Caption = 'Display Order'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object ACSCode: Text8Pt
      Left = 109
      Top = 10
      Width = 96
      Height = 22
      TabStop = False
      AutoSize = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
      TextId = 0
      ViaSBtn = False
    end
    object UROChk: TBorCheck
      Tag = 1
      Left = 4
      Top = 83
      Width = 118
      Height = 20
      HelpContext = 615
      Caption = 'Use Re-Order Price'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 6
      TabStop = True
      TextId = 0
      OnClick = UROChkClick
    end
    object ACSDesc: Text8Pt
      Left = 290
      Top = 10
      Width = 223
      Height = 22
      TabStop = False
      AutoSize = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
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
    object ACADesc: Text8Pt
      Tag = 1
      Left = 290
      Top = 34
      Width = 223
      Height = 22
      HelpContext = 612
      AutoSize = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      TextId = 0
      ViaSBtn = False
    end
    object ACACName: Text8Pt
      Left = 290
      Top = 58
      Width = 223
      Height = 22
      HelpContext = 613
      TabStop = False
      AutoSize = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 5
      TextId = 0
      ViaSBtn = False
    end
    object ROPF: TCurrencyEdit
      Tag = 1
      Left = 342
      Top = 84
      Width = 80
      Height = 22
      HelpContext = 614
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      MaxLength = 13
      ParentFont = False
      TabOrder = 8
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
    object SRRPCF: TSBSComboBox
      Tag = 1
      Left = 290
      Top = 84
      Width = 48
      Height = 22
      HelpContext = 614
      Style = csDropDownList
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      MaxLength = 3
      ParentFont = False
      TabOrder = 7
      ExtendedList = True
      MaxListWidth = 90
      Validate = True
    end
    object ACACode: Text8Pt
      Tag = 1
      Left = 109
      Top = 34
      Width = 97
      Height = 22
      HelpContext = 611
      AutoSize = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnExit = ACACodeExit
      TextId = 0
      ViaSBtn = False
    end
    object ACCode: Text8Pt
      Tag = 1
      Left = 109
      Top = 58
      Width = 58
      Height = 22
      HelpContext = 613
      AutoSize = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnExit = ACCodeExit
      TextId = 0
      ViaSBtn = False
    end
    object UseRQChk: TBorCheck
      Tag = 1
      Left = 4
      Top = 132
      Width = 118
      Height = 20
      HelpContext = 615
      Caption = 'Replace Qty'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 12
      TabStop = True
      TextId = 0
      OnClick = UROChkClick
    end
    object MEQF: TCurrencyEdit
      Tag = 1
      Left = 290
      Top = 109
      Width = 60
      Height = 22
      HelpContext = 614
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      MaxLength = 13
      ParentFont = False
      TabOrder = 11
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
    object RQtyF: TCurrencyEdit
      Tag = 1
      Left = 290
      Top = 133
      Width = 60
      Height = 22
      HelpContext = 614
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      MaxLength = 13
      ParentFont = False
      TabOrder = 13
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
    object UseMEQChk: TBorCheck
      Tag = 1
      Left = 4
      Top = 108
      Width = 118
      Height = 20
      HelpContext = 615
      Caption = 'Use Re-Order Qty'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 10
      TabStop = True
      TextId = 0
      OnClick = UROChkClick
    end
    object DOLF: TCurrencyEdit
      Tag = 1
      Left = 421
      Top = 84
      Width = 40
      Height = 22
      HelpContext = 614
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      MaxLength = 10
      ParentFont = False
      TabOrder = 9
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0-'
      DecPlaces = 0
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 184
    Top = 175
    Width = 80
    Height = 21
    Hint = 
      'Store the Record|This button allows you to store the current rec' +
      'ord during an add or edit.'
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = CanCp1BtnClick
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 273
    Top = 175
    Width = 80
    Height = 21
    Hint = 
      'Cancel record changes|Cancel any changes to the current record d' +
      'uring an add/edit.'
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = CanCp1BtnClick
  end
end
