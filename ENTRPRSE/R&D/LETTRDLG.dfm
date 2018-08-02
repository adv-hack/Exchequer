object LetterDlg: TLetterDlg
  Left = 350
  Top = 189
  ActiveControl = DescMemo
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Letter Information'
  ClientHeight = 180
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label81: Label8
    Left = 28
    Top = 9
    Width = 42
    Height = 14
    Alignment = taRightJustify
    Caption = 'Filename'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8
    Left = 20
    Top = 35
    Width = 50
    Height = 14
    Alignment = taRightJustify
    Caption = 'Created at'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8
    Left = 16
    Top = 112
    Width = 54
    Height = 14
    Alignment = taRightJustify
    Caption = 'Description'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 57
    Top = 61
    Width = 13
    Height = 14
    Alignment = taRightJustify
    Caption = 'By'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8
    Left = 47
    Top = 88
    Width = 23
    Height = 14
    Alignment = taRightJustify
    Caption = 'Type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object DescMemo: TMemo
    Tag = 1
    Left = 74
    Top = 110
    Width = 253
    Height = 64
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 100
    ParentFont = False
    TabOrder = 5
  end
  object OkBtn: TButton
    Left = 338
    Top = 7
    Width = 80
    Height = 21
    Caption = '&OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = OkBtnClick
  end
  object CancBtn: TButton
    Left = 338
    Top = 35
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = CancBtnClick
  end
  object PathEdt: Text8Pt
    Left = 73
    Top = 6
    Width = 236
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
    TabOrder = 0
    OnChange = PathEdtChange
    OnDblClick = PathEdtDblClick
    TextId = 0
    ViaSBtn = False
  end
  object DatTimEdt: Text8Pt
    Tag = 1
    Left = 73
    Top = 32
    Width = 253
    Height = 22
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
    TabOrder = 2
    TextId = 0
    ViaSBtn = False
  end
  object UserEdt: Text8Pt
    Tag = 1
    Left = 73
    Top = 58
    Width = 253
    Height = 22
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
    TabOrder = 3
    TextId = 0
    ViaSBtn = False
  end
  object TypeList: TSBSComboBox
    Tag = 1
    Left = 73
    Top = 84
    Width = 253
    Height = 22
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 4
    MaxListWidth = 0
  end
  object btnBrowse: TButton
    Left = 309
    Top = 7
    Width = 17
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = PathEdtDblClick
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 344
    Top = 88
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
  object OpenDialog1: TOpenDialog
    Filter = 
      'Document (*.DOC)|*.DOC|Image (*.BMP,*.GIF)|*.BMP;*.GIF|Sound (*.' +
      'WAV)|*.WAV|Video (*.AVI,*.MPG)|*.AVI;*.MPG|All Files|*.*'
    FilterIndex = 5
    Options = [ofPathMustExist, ofFileMustExist]
    Title = 'Change Linked File'
    Left = 341
    Top = 125
  end
  object SpellCheck4Modal1: TSpellCheck4Modal
    Version = 'TSpellCheck4Modal v5.70.001 for Delphi 6.01'
    Left = 374
    Top = 126
  end
end
