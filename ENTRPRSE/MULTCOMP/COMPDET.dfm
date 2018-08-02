object frmCompDet: TfrmCompDet
  Left = 418
  Top = 217
  HelpContext = 16
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Edit Form Definition'
  ClientHeight = 184
  ClientWidth = 373
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object Label81: Label8
    Left = 41
    Top = 9
    Width = 38
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 43
    Top = 34
    Width = 36
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8
    Left = 58
    Top = 61
    Width = 21
    Height = 14
    Caption = 'Path'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object lblDemoData: TLabel
    Left = 3
    Top = 165
    Width = 19
    Height = 14
    AutoSize = False
    Caption = '.'
    Visible = False
  end
  object cmName: Text8Pt
    Tag = 1
    Left = 83
    Top = 31
    Width = 280
    Height = 22
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 45
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnExit = cmNameExit
    TextId = 0
    ViaSBtn = False
  end
  object SaveBtn: TButton
    Left = 202
    Top = 159
    Width = 78
    Height = 21
    Caption = '&Save'
    TabOrder = 6
    OnClick = SaveBtnClick
  end
  object CancelBtn: TButton
    Left = 285
    Top = 159
    Width = 78
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 7
    OnClick = CancelBtnClick
  end
  object cmCode: Text8Pt
    Left = 84
    Top = 5
    Width = 77
    Height = 22
    Hint = 
      'Double click to drill down|Double clicking or using the down but' +
      'ton will drill down to the record for this field. The up button ' +
      'will search for the nearest match.'
    CharCase = ecUpperCase
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 6
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnExit = cmCodeExit
    OnKeyPress = cmCodeKeyPress
    TextId = 0
    ViaSBtn = False
    Link_to_Stock = True
    ShowHilight = True
  end
  object cmPath: Text8Pt
    Left = 83
    Top = 57
    Width = 280
    Height = 22
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
    TextId = 0
    ViaSBtn = False
  end
  object BrowseBtn: TButton
    Left = 111
    Top = 159
    Width = 78
    Height = 21
    Caption = '&Browse'
    TabOrder = 5
    OnClick = BrowseBtnClick
  end
  object panSQLDetails: TPanel
    Left = 0
    Top = 106
    Width = 366
    Height = 48
    BevelOuter = bvNone
    TabOrder = 4
    object Label84: Label8
      Left = 1
      Top = 4
      Width = 78
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Reporting User'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label85: Label8
      Left = 25
      Top = 30
      Width = 54
      Height = 14
      Alignment = taRightJustify
      Caption = 'Connection'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label86: Label8
      Left = 209
      Top = 4
      Width = 26
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Pwd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object edtRepUserId: Text8Pt
      Tag = 1
      Left = 83
      Top = 0
      Width = 123
      Height = 22
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 45
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
      TextId = 0
      ViaSBtn = False
    end
    object edtConnectionString: Text8Pt
      Left = 83
      Top = 26
      Width = 280
      Height = 22
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
      TabOrder = 2
      TextId = 0
      ViaSBtn = False
    end
    object edtRepUserPwd: Text8Pt
      Tag = 1
      Left = 240
      Top = 0
      Width = 123
      Height = 22
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 45
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
      TextId = 0
      ViaSBtn = False
    end
  end
  object chkExportToAnalytics: TCheckBox
    Left = 84
    Top = 84
    Width = 147
    Height = 17
    Caption = 'Export To Analytics'
    TabOrder = 3
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 222
    Top = 2
    object PropFlg: TMenuItem
      Caption = '&Properties'
      Hint = 'Access Colour & Font settings'
      OnClick = PropFlgClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object StoreCoordFlg: TMenuItem
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
      OnClick = StoreCoordFlgClick
    end
  end
end
