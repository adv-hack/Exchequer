object BEntryLine: TBEntryLine
  Left = 301
  Top = 208
  HelpContext = 40011
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Batch Entry Transaction'
  ClientHeight = 236
  ClientWidth = 607
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
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
  object SBSPanel1: TSBSPanel
    Left = 3
    Top = 4
    Width = 602
    Height = 197
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label88: Label8
      Left = 24
      Top = 15
      Width = 38
      Height = 14
      Caption = 'Our Ref'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label81: Label8
      Left = 28
      Top = 45
      Width = 34
      Height = 14
      Caption = 'A/C No'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 40
      Top = 75
      Width = 22
      Height = 14
      Caption = 'Date'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label83: Label8
      Left = 18
      Top = 104
      Width = 43
      Height = 14
      Caption = 'Your Ref'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label84: Label8
      Left = 213
      Top = 16
      Width = 45
      Height = 14
      Caption = 'G/L Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object CCLab1: Label8
      Left = 222
      Top = 46
      Width = 38
      Height = 14
      AutoSize = False
      Caption = 'CC/Dep'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Id1JALab: Label8
      Left = 421
      Top = 75
      Width = 42
      Height = 14
      Caption = 'Analysis'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Id1JCLab: Label8
      Left = 420
      Top = 47
      Width = 45
      Height = 14
      Caption = 'Job Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label85: Label8
      Left = 8
      Top = 134
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
    object Label86: Label8
      Left = 216
      Top = 76
      Width = 41
      Height = 14
      Caption = 'Net Total'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object VATCClab: Label8
      Left = 168
      Top = 106
      Width = 90
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = ' Code/Content'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label89: Label8
      Left = 436
      Top = 106
      Width = 26
      Height = 14
      Caption = 'Total'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TextId = 0
    end
    object lblServiceTo: TLabel
      Left = 215
      Top = 164
      Width = 9
      Height = 14
      Caption = 'to'
    end
    object Id1ORefF: Text8Pt
      Left = 65
      Top = 11
      Width = 91
      Height = 22
      HelpContext = 142
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
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
    object Id1ACF: Text8Pt
      Tag = 1
      Left = 65
      Top = 41
      Width = 91
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking or using the down but' +
        'ton will drill down to the record for this field. The up button ' +
        'will search for the nearest match.'
      HelpContext = 238
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
      OnExit = Id1ACFExit
      TextId = 0
      ViaSBtn = False
      Link_to_Cust = True
      ShowHilight = True
    end
    object Id1DateF: TEditDate
      Tag = 1
      Left = 65
      Top = 71
      Width = 91
      Height = 22
      HelpContext = 40002
      AutoSelect = False
      Color = clWhite
      EditMask = '00/00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      OnExit = Id1DateFExit
      Placement = cpAbove
    end
    object Id1YRefF: Text8Pt
      Tag = 1
      Left = 65
      Top = 101
      Width = 91
      Height = 22
      HelpContext = 40019
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 3
      OnChange = Id1YRefFChange
      OnExit = Id1YRefFExit
      TextId = 0
      ViaSBtn = False
    end
    object Id1Desc1F: Text8Pt
      Tag = 1
      Left = 65
      Top = 131
      Width = 340
      Height = 22
      HelpContext = 40012
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 60
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 4
      TextId = 0
      ViaSBtn = False
    end
    object Id1NomF: Text8Pt
      Tag = 1
      Left = 261
      Top = 11
      Width = 94
      Height = 22
      HelpContext = 40010
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 8
      OnExit = Id1NomFExit
      TextId = 0
      ViaSBtn = False
    end
    object Id1CCF: Text8Pt
      Tag = 1
      Left = 261
      Top = 41
      Width = 46
      Height = 22
      HelpContext = 272
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 10
      OnExit = Id1CCFExit
      TextId = 0
      ViaSBtn = False
    end
    object Id1DepF: Text8Pt
      Tag = 1
      Left = 309
      Top = 41
      Width = 46
      Height = 22
      HelpContext = 272
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 11
      OnExit = Id1CCFExit
      TextId = 0
      ViaSBtn = False
    end
    object Id1JCF: Text8Pt
      Tag = 1
      Left = 467
      Top = 42
      Width = 125
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking or using the down but' +
        'ton will drill down to the record for this field. The up button ' +
        'will search for the nearest match.'
      HelpContext = 465
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 15
      OnExit = Id1JCFExit
      TextId = 0
      ViaSBtn = False
      Link_to_Job = True
      ShowHilight = True
    end
    object Id1JAF: Text8Pt
      Tag = 1
      Left = 467
      Top = 71
      Width = 125
      Height = 22
      HelpContext = 466
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 16
      OnExit = Id1JAFExit
      TextId = 0
      ViaSBtn = False
    end
    object Id3VATF: TSBSComboBox
      Tag = 1
      Left = 261
      Top = 101
      Width = 41
      Height = 22
      HelpContext = 40016
      Style = csDropDownList
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      MaxLength = 1
      ParentFont = False
      TabOrder = 13
      OnClick = Id3VATFChange
      OnExit = Id3VATFChange
      AllowChangeInExit = True
      ExtendedList = True
      MaxListWidth = 75
      ReadOnly = True
      Validate = True
    end
    object Id1NetF: TCurrencyEdit
      Tag = 1
      Left = 261
      Top = 71
      Width = 144
      Height = 22
      HelpContext = 40015
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
      ReadOnly = True
      TabOrder = 12
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
    object Id1VATF: TCurrencyEdit
      Tag = 1
      Left = 304
      Top = 101
      Width = 101
      Height = 22
      HelpContext = 40016
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
      ReadOnly = True
      TabOrder = 14
      WantReturns = False
      WordWrap = False
      OnExit = Id1VATFExit
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
    object Id1Desc2F: Text8Pt
      Left = 360
      Top = 11
      Width = 232
      Height = 22
      HelpContext = 250
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 9
      TextId = 0
      ViaSBtn = False
    end
    object IdTotF: TCurrencyEdit
      Left = 467
      Top = 101
      Width = 125
      Height = 22
      HelpContext = 40017
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Lines.Strings = (
        '0.00 ')
      ParentFont = False
      TabOrder = 17
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
    object chkService: TBorCheck
      Left = 64
      Top = 161
      Width = 73
      Height = 18
      Align = alRight
      Caption = 'EC Service'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 5
      TabStop = True
      TextId = 0
      OnClick = chkServiceClick
    end
    object dtServiceStart: TEditDate
      Tag = 1
      Left = 144
      Top = 161
      Width = 65
      Height = 22
      AutoSelect = False
      Color = clWhite
      EditMask = '00/00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 6
      Placement = cpAbove
    end
    object dtServiceEnd: TEditDate
      Tag = 1
      Left = 232
      Top = 161
      Width = 65
      Height = 22
      AutoSelect = False
      Color = clWhite
      EditMask = '00/00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 7
      Placement = cpAbove
    end
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 221
    Top = 208
    Width = 80
    Height = 21
    HelpContext = 278
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = CanCP1BtnClick
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 306
    Top = 208
    Width = 80
    Height = 21
    HelpContext = 279
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = CanCP1BtnClick
  end
end