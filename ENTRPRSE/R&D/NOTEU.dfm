object NoteCtrl: TNoteCtrl
  Left = 566
  Top = 258
  HelpContext = 66
  VertScrollBar.Visible = False
  ActiveControl = NPLine
  BorderIcons = [biMinimize]
  BorderStyle = bsDialog
  Caption = 'Note Entry'
  ClientHeight = 56
  ClientWidth = 587
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Panel24: TPanel
    Left = -2
    Top = -1
    Width = 588
    Height = 56
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 0
    object NPLine: Text8Pt
      Left = 79
      Top = 28
      Width = 418
      Height = 22
      HelpContext = 113
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 63
      ParentFont = False
      TabOrder = 1
      OnKeyDown = NPDateKeyDown
      OnKeyPress = NPDateKeyPress
      TextId = 0
      ViaSBtn = False
    end
    object NBOkBtn: TBitBtn
      Left = 500
      Top = 5
      Width = 80
      Height = 21
      Caption = '&OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 2
      OnClick = NBOkBtnClick
      NumGlyphs = 4
    end
    object NBCanBtn: TBitBtn
      Left = 500
      Top = 28
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ModalResult = 2
      ParentFont = False
      TabOrder = 3
      OnClick = NBOkBtnClick
      NumGlyphs = 4
      Spacing = 0
    end
    object NPNotePanel: TPanel
      Left = 78
      Top = 4
      Width = 419
      Height = 22
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 4
      object Label89: Label8
        Left = 13
        Top = 4
        Width = 28
        Height = 14
        Caption = 'Notes'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label81: Label8
        Left = 75
        Top = 4
        Width = 14
        Height = 14
        Caption = 'To:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label82: Label8
        Left = 276
        Top = 4
        Width = 71
        Height = 14
        Caption = 'Repeat every :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label83: Label8
        Left = 385
        Top = 4
        Width = 24
        Height = 14
        Caption = 'days'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object NPAlaChk: TBorCheck
        Left = 147
        Top = 2
        Width = 50
        Height = 16
        HelpContext = 114
        Caption = 'Alarm'
        CheckColor = clWindowText
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        TabStop = True
        TextId = 0
      end
      object NPAlarm: TEditDate
        Left = 203
        Top = 2
        Width = 67
        Height = 18
        HelpContext = 114
        AutoSelect = False
        AutoSize = False
        Color = clWhite
        EditMask = '00/00/0000;0;'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        TabOrder = 2
        Text = '15031995'
        OnKeyDown = NPDateKeyDown
        OnKeyPress = NPDateKeyPress
        Placement = cpAbove
      end
      object NPFor: Text8Pt
        Left = 92
        Top = 2
        Width = 52
        Height = 18
        HelpContext = 579
        AutoSize = False
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnExit = NPForExit
        OnKeyDown = NPDateKeyDown
        OnKeyPress = NPDateKeyPress
        TextId = 0
        ViaSBtn = False
      end
      object NPRepeat: TCurrencyEdit
        Left = 348
        Top = 2
        Width = 35
        Height = 18
        HelpContext = 114
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'ARIAL'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        MaxLength = 4
        ParentFont = False
        TabOrder = 3
        WantReturns = False
        WordWrap = False
        OnKeyPress = NPRepeatKeyPress
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
    object Panel4: TPanel
      Left = 4
      Top = 4
      Width = 70
      Height = 21
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 5
      object NPDateChk: TBorCheck
        Left = 3
        Top = 3
        Width = 61
        Height = 16
        HelpContext = 112
        Caption = 'Date'
        CheckColor = clWindowText
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TabStop = True
        TextId = 0
        OnClick = NPDateChkClick
      end
    end
    object NPDate: TEditDate
      Left = 4
      Top = 28
      Width = 72
      Height = 21
      HelpContext = 112
      AutoSelect = False
      AutoSize = False
      Color = clWhite
      EditMask = '00/00/0000;0;'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 0
      Text = '15031995'
      OnKeyDown = NPDateKeyDown
      OnKeyPress = NPDateKeyPress
      Placement = cpAbove
      AllowBlank = True
    end
  end
  object NotesPopupM: TPopupMenu
    OnPopup = NotesPopupMPopup
    Left = 120
    Top = 5
    object Add1: TMenuItem
      Caption = '&Add'
      OnClick = Add1Click
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      OnClick = Add1Click
    end
    object Insert1: TMenuItem
      Caption = '&Insert'
      OnClick = Add1Click
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      OnClick = Delete1Click
    end
    object Switch1: TMenuItem
      Caption = '&Switch To'
      object GeneralNotes1: TMenuItem
        Caption = '&General Notes'
        OnClick = GeneralNotes1Click
      end
      object DatedNotes1: TMenuItem
        Caption = '&Dated Notes'
        OnClick = DatedNotes1Click
      end
      object AuditHistoryNotes1: TMenuItem
        Caption = '&Audit History Notes'
        OnClick = AuditHistoryNotes1Click
      end
    end
    object Clear1: TMenuItem
      Caption = 'C&lear'
      OnClick = Clear1Click
    end
    object View1: TMenuItem
      Caption = '&View Source'
      OnClick = View1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
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
    object N3: TMenuItem
      Caption = '-'
      Enabled = False
      Visible = False
    end
  end
  object SpellCheck4Modal1: TSpellCheck4Modal
    Version = 'TSpellCheck4Modal v5.70.001 for Delphi 6.01'
    Left = 96
    Top = 6
  end
end
