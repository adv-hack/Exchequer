object frmGLList: TfrmGLList
  Left = 192
  Top = 114
  Width = 308
  Height = 273
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'General Ledger Code Search List'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poDefault
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object dmlGLCodes: TDBMultiList
    Left = 0
    Top = 2
    Width = 300
    Height = 201
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Alignment = taRightJustify
        Caption = 'Code'
        Color = clWhite
        DataType = dtInteger
        Field = 'C'
        Searchable = True
        Sortable = True
      end
      item
        Caption = 'Description'
        Color = clWhite
        Field = 'D'
        Searchable = True
        Sortable = True
        Width = 164
        IndexNo = 1
      end>
    TabStop = True
    OnRowDblClick = dmlGLCodesRowDblClick
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    PopupMenu = PopupMenu1
    TabOrder = 0
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Arial'
    HeaderFont.Style = []
    HighlightFont.Charset = DEFAULT_CHARSET
    HighlightFont.Color = clWhite
    HighlightFont.Height = -11
    HighlightFont.Name = 'Arial'
    HighlightFont.Style = []
    MultiSelectFont.Charset = DEFAULT_CHARSET
    MultiSelectFont.Color = clWindowText
    MultiSelectFont.Height = -11
    MultiSelectFont.Name = 'Arial'
    MultiSelectFont.Style = []
    Version = 'v1.13'
    Dataset = ctkGL
    Active = False
    SortColIndex = 0
    SortAsc = True
  end
  object pnlButtons: TPanel
    Left = 41
    Top = 206
    Width = 217
    Height = 33
    BevelOuter = bvNone
    TabOrder = 1
    object btnOK: TSBSButton
      Left = 25
      Top = 8
      Width = 80
      Height = 21
      Caption = '&OK'
      ModalResult = 1
      PopupMenu = PopupMenu1
      TabOrder = 1
      TextId = 0
    end
    object btnCancel: TSBSButton
      Left = 113
      Top = 8
      Width = 80
      Height = 21
      Caption = '&Cancel'
      ModalResult = 2
      PopupMenu = PopupMenu1
      TabOrder = 0
      TextId = 0
    end
  end
  object ctkGL: TComTKDataset
    OnFilterRecord = ctkGLFilterRecord
    OnGetFieldValue = ctkGLGetFieldValue
    Left = 272
    Top = 208
  end
  object PopupMenu1: TPopupMenu
    Top = 216
    object Properties1: TMenuItem
      Caption = 'Properties'
      OnClick = Properties1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = 'Save Coordinates'
    end
  end
end
