object DocNumRec: TDocNumRec
  Left = 552
  Top = 253
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Document Number Record'
  ClientHeight = 152
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
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
  object SBSBackGroup1: TSBSBackGroup
    Left = 7
    Top = 6
    Width = 268
    Height = 102
    TextId = 0
  end
  object Label82: Label8
    Left = 57
    Top = 79
    Width = 71
    Height = 14
    Caption = '&Next Number : '
    FocusControl = NNumF
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label81: Label8
    Left = 44
    Top = 26
    Width = 83
    Height = 14
    Caption = 'Document Type : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 61
    Top = 119
    Width = 80
    Height = 22
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = CanCP1BtnClick
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 146
    Top = 119
    Width = 80
    Height = 22
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = CanCP1BtnClick
  end
  object NNumF: TCurrencyEdit
    Tag = 1
    Left = 129
    Top = 74
    Width = 80
    Height = 25
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    HideSelection = False
    Lines.Strings = (
      '0 ')
    ParentFont = False
    TabOrder = 0
    WantReturns = False
    WordWrap = False
    OnEnter = NNumFEnter
    OnExit = NNumFExit
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
  object SCodeF: Text8Pt
    Tag = 1
    Left = 129
    Top = 21
    Width = 80
    Height = 22
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
    TabOrder = 3
    TextId = 0
    ViaSBtn = False
  end
  object SCDescF: Text8Pt
    Tag = 1
    Left = 129
    Top = 47
    Width = 138
    Height = 22
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
    TabOrder = 4
    TextId = 0
    ViaSBtn = False
  end
end