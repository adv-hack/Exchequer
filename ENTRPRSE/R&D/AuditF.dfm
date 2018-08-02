object frmAudit: TfrmAudit
  Left = 442
  Top = 340
  Width = 794
  Height = 380
  HelpContext = 40170
  ActiveControl = memAuditTrail
  Caption = 'System Audit Trail'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poDefault
  Scaled = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 9
    Width = 48
    Height = 14
    Caption = 'Audit Trail'
  end
  object cmbAvailableAuditFiles: TComboBox
    Left = 62
    Top = 5
    Width = 304
    Height = 22
    Style = csDropDownList
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 8
    OnClick = cmbAvailableAuditFilesClick
  end
  object btnArchive: TButton
    Left = 681
    Top = 69
    Width = 80
    Height = 21
    Caption = 'A&rchive'
    TabOrder = 3
    OnClick = btnArchiveClick
  end
  object btnFind: TButton
    Left = 681
    Top = 94
    Width = 80
    Height = 21
    Caption = '&Find'
    TabOrder = 4
    OnClick = btnFindClick
  end
  object btnCopy: TButton
    Left = 681
    Top = 119
    Width = 80
    Height = 21
    Caption = '&Copy'
    TabOrder = 5
    OnClick = btnCopyClick
  end
  object btnSaveAs: TButton
    Left = 681
    Top = 144
    Width = 80
    Height = 21
    Caption = '&Save As'
    TabOrder = 6
    OnClick = btnSaveAsClick
  end
  object btnSelectAll: TButton
    Left = 681
    Top = 169
    Width = 80
    Height = 21
    Caption = 'Select All'
    TabOrder = 7
    OnClick = btnSelectAllClick
  end
  object btnClose: TButton
    Left = 681
    Top = 32
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'C&lose'
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object panMemoHost: TPanel
    Left = 5
    Top = 32
    Width = 608
    Height = 279
    BevelOuter = bvNone
    TabOrder = 0
    object memAuditTrail: TMemo
      Left = 0
      Top = 0
      Width = 608
      Height = 279
      Align = alClient
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Lucida Console'
      Font.Style = []
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object panProgress: TPanel
    Left = 103
    Top = 108
    Width = 540
    Height = 77
    Cursor = crHourGlass
    TabOrder = 1
    object lblProgress: TLabel
      Left = 20
      Top = 20
      Width = 500
      Height = 14
      Alignment = taCenter
      AutoSize = False
    end
    object ProgressBar1: TProgressBar
      Left = 20
      Top = 40
      Width = 500
      Height = 17
      Cursor = crHourGlass
      Min = 0
      Max = 100
      TabOrder = 0
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 24
    Top = 50
    object mnuArchive: TMenuItem
      Tag = 1
      Caption = 'A&rchive'
      HelpContext = 228
      Hint = 
        'Choosing this option allows you to add a new General Ledger reco' +
        'rd within the currently open heading.'
      OnClick = btnArchiveClick
    end
    object mnuFind: TMenuItem
      Caption = '&Find'
      HelpContext = 180
      OnClick = btnFindClick
    end
    object mnuCopy: TMenuItem
      Caption = '&Copy'
      OnClick = btnCopyClick
    end
    object mnuSaveAs: TMenuItem
      Caption = '&Save As'
      OnClick = btnSaveAsClick
    end
    object mnuSelectAll: TMenuItem
      Caption = 'Select &All'
      OnClick = btnSelectAllClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuProperties: TMenuItem
      Caption = '&Properties'
      OnClick = mnuPropertiesClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object StoreCoordFlg: TMenuItem
      Caption = '&Save Coordinates'
      HelpContext = 177
      Hint = 'Make the current window settings permanent'
      OnClick = StoreCoordFlgClick
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.TXT'
    Filter = 'Text Files|*.TXT|All Files|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save Audit Trail Text'
    Left = 165
    Top = 52
  end
  object FindDialog1: TFindDialog
    Options = [frDown, frHideMatchCase, frHideWholeWord, frHideUpDown, frMatchCase]
    OnFind = FindDialog1Find
    Left = 94
    Top = 50
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 240
    Top = 49
  end
end
