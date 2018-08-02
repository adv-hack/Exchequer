object frmPopupList: TfrmPopupList
  Left = 358
  Top = 179
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'frmPopupList'
  ClientHeight = 333
  ClientWidth = 291
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    008888888880000000000000000000000008F8F8F80000000000000000000010
    00000000000001110000000000001191100F8F8F8F0001910000000000000191
    0077777777700191007788888770019100777777777001110007777777000000
    000000000000000000000000000000000000000000000000000000000000F800
    0000F8000000FC010000FC010000DFFF00008C01000004010000880000008800
    0000880000008800000088000000FC010000FDDD0000FFDF0000FFEF0000}
  OldCreateOrder = False
  PopupMenu = pmMain
  Scaled = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    291
    333)
  PixelsPerInch = 96
  TextHeight = 14
  object lTitle: TLabel
    Left = 8
    Top = 8
    Width = 273
    Height = 29
    AutoSize = False
    Caption = 'lTitle'
    WordWrap = True
  end
  object btnOK: TButton
    Left = 114
    Top = 304
    Width = 80
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 202
    Top = 304
    Width = 80
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object panTitle: TPanel
    Left = 8
    Top = 40
    Width = 273
    Height = 21
    Alignment = taLeftJustify
    BevelOuter = bvLowered
    Caption = 'panTitle'
    Color = clNavy
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object mlBins: TDBMultiList
    Left = 8
    Top = 64
    Width = 273
    Height = 233
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Bin Code'
        Field = 'liDescription'
        Searchable = True
        Sortable = True
        Width = 239
      end>
    TabStop = True
    OnRowDblClick = mlBinsRowDblClick
    TabOrder = 1
    Visible = False
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
    Active = False
    SortColIndex = 0
    SortAsc = True
  end
  object mlItems: TMultiList
    Left = 8
    Top = 64
    Width = 273
    Height = 233
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Description'
        Field = 'D'
        Width = 239
      end>
    TabStop = True
    OnRowDblClick = mlItemsRowDblClick
    TabOrder = 0
    Visible = False
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
  end
  object pdsUDItem: TBtrieveDataset
    OnGetFieldValue = pdsUDItemGetFieldValue
    Left = 16
    Top = 88
  end
  object pmMain: TPopupMenu
    Left = 48
    Top = 88
    object Properties1: TMenuItem
      Caption = 'Properties'
      OnClick = Properties1Click
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = 'Save Coordinates'
    end
  end
  object sdsUDItem: TSQLDatasets
    UseWindowsAuthentication = True
    Left = 80
    Top = 88
  end
end
