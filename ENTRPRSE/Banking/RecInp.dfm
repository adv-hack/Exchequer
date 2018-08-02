object frmBankRecInput: TfrmBankRecInput
  Left = 190
  Top = 114
  HelpContext = 1902
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Bank Reconciliation'
  ClientHeight = 350
  ClientWidth = 364
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object Panel2: TPanel
    Left = 8
    Top = 80
    Width = 257
    Height = 185
    HelpContext = 1902
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object Label3: TLabel
      Left = 16
      Top = 8
      Width = 73
      Height = 14
      Caption = 'Statement Date'
    end
    object Label4: TLabel
      Left = 120
      Top = 8
      Width = 99
      Height = 14
      Caption = 'Reference (optional)'
    end
    object Label5: TLabel
      Left = 16
      Top = 56
      Width = 75
      Height = 14
      Caption = 'Initial Sequence'
    end
    object Label6: TLabel
      Left = 120
      Top = 56
      Width = 90
      Height = 14
      Caption = 'Statement Balance'
    end
    object Label7: TLabel
      Left = 16
      Top = 104
      Width = 75
      Height = 14
      Caption = 'Group Lines By'
    end
    object edtStatementDate: TEditDate
      Left = 16
      Top = 24
      Width = 89
      Height = 22
      HelpContext = 1905
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
    object ceBalance: TCurrencyEdit
      Left = 120
      Top = 72
      Width = 121
      Height = 21
      HelpContext = 1909
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      MaxLength = 13
      ParentFont = False
      TabOrder = 3
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
    object edtRef: Text8Pt
      Left = 120
      Top = 24
      Width = 121
      Height = 22
      HelpContext = 1906
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
    object cbSequence: TSBSComboBox
      Left = 16
      Top = 72
      Width = 89
      Height = 22
      HelpContext = 1907
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ItemIndex = 0
      ParentFont = False
      TabOrder = 2
      Text = 'Date'
      Items.Strings = (
        'Date'
        'Reference'
        'Amount')
      MaxListWidth = 0
    end
    object chkUncleared: TBorCheck
      Left = 16
      Top = 152
      Width = 129
      Height = 20
      HelpContext = 1908
      Align = alRight
      Caption = 'Uncleared items only'
      Color = clBtnFace
      Checked = True
      ParentColor = False
      State = cbChecked
      TabOrder = 5
      TabStop = True
      TextId = 0
    end
    object cbGroupBy: TSBSComboBox
      Left = 16
      Top = 120
      Width = 137
      Height = 22
      HelpContext = 1907
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ItemIndex = 0
      ParentFont = False
      TabOrder = 4
      Text = 'Reference and Date'
      Items.Strings = (
        'Reference and Date'
        'Reference Only')
      MaxListWidth = 0
    end
  end
  object btnCancel: TSBSButton
    Left = 277
    Top = 40
    Width = 80
    Height = 21
    HelpContext = 1918
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
    OnClick = btnCancelClick
    TextId = 0
  end
  object btnOK: TSBSButton
    Left = 277
    Top = 16
    Width = 80
    Height = 21
    HelpContext = 1917
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
    TextId = 0
  end
  object pnlGLCode: TPanel
    Left = 8
    Top = 8
    Width = 257
    Height = 65
    HelpContext = 1902
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 69
      Height = 14
      Caption = 'Bank GL Code'
    end
    object Label2: TLabel
      Left = 120
      Top = 8
      Width = 45
      Height = 14
      Caption = 'Currency'
    end
    object edtGLCode: Text8Pt
      Left = 16
      Top = 24
      Width = 89
      Height = 22
      HelpContext = 1903
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnExit = edtGLCodeExit
      TextId = 0
      ViaSBtn = False
    end
    object cbCurrency: TSBSComboBox
      Left = 120
      Top = 24
      Width = 121
      Height = 22
      HelpContext = 1904
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 1
      OnExit = cbCurrencyExit
      ExtendedList = True
      MaxListWidth = 0
    end
  end
  object Panel1: TPanel
    Left = 8
    Top = 280
    Width = 257
    Height = 57
    HelpContext = 6720
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object chkUseReconDate: TBorCheck
      Left = 16
      Top = 16
      Width = 137
      Height = 20
      HelpContext = 6720
      Align = alRight
      Caption = 'Use Reconciliation Date'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
      TextId = 0
      OnClick = chkUseReconDateClick
    end
    object edtReconDate: TEditDate
      Left = 160
      Top = 16
      Width = 89
      Height = 22
      HelpContext = 6720
      AutoSelect = False
      Enabled = False
      EditMask = '00/00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 1
      Placement = cpAbove
    end
  end
end
