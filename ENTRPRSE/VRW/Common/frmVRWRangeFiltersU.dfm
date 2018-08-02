object frmVRWRangeFilters: TfrmVRWRangeFilters
  Left = 281
  Top = 216
  HelpContext = 156
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Range Filters'
  ClientHeight = 170
  ClientWidth = 707
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object mulRangeFilters: TMultiList
    Left = 4
    Top = 5
    Width = 615
    Height = 155
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Location'
        Width = 105
      end
      item
        Caption = 'Description'
        Width = 140
      end
      item
        Caption = 'Type'
        Width = 90
      end
      item
        Caption = 'Range From'
        Width = 90
      end
      item
        Caption = 'Range To'
        Width = 90
      end
      item
        Caption = 'Ask'
        Width = 40
      end>
    TabStop = True
    OnChangeSelection = mulRangeFiltersChangeSelection
    OnRowDblClick = mulRangeFiltersRowDblClick
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
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
  end
  object btnPrint: TSBSButton
    Left = 624
    Top = 8
    Width = 80
    Height = 21
    Caption = '&Print'
    TabOrder = 1
    OnClick = btnPrintClick
    TextId = 0
  end
  object btnClose: TSBSButton
    Left = 624
    Top = 36
    Width = 80
    Height = 21
    Caption = '&Close'
    TabOrder = 2
    OnClick = btnCloseClick
    TextId = 0
  end
  object btnEdit: TSBSButton
    Left = 624
    Top = 92
    Width = 80
    Height = 21
    Caption = '&Edit'
    Enabled = False
    TabOrder = 3
    OnClick = btnEditClick
    TextId = 0
  end
  object btnDelete: TSBSButton
    Left = 624
    Top = 120
    Width = 80
    Height = 21
    Caption = '&Delete'
    Enabled = False
    TabOrder = 4
    OnClick = btnDeleteClick
    TextId = 0
  end
  object btnAdd: TSBSButton
    Left = 624
    Top = 64
    Width = 80
    Height = 21
    Caption = '&Add'
    Enabled = False
    TabOrder = 5
    OnClick = btnAddClick
    TextId = 0
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 551
    Top = 138
  end
end
