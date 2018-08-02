object frmRangeFilters: TfrmRangeFilters
  Left = 281
  Top = 216
  Width = 718
  Height = 191
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Range Filters'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
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
        Alignment = taCenter
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
        Alignment = taCenter
        Caption = 'Ask'
        Width = 40
      end>
    TabStop = True
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
    Version = 'v1.12'
  end
  object btnClose: TSBSButton
    Left = 625
    Top = 26
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 1
    OnClick = btnCloseClick
    TextId = 0
  end
  object btnEdit: TSBSButton
    Left = 625
    Top = 58
    Width = 80
    Height = 21
    Caption = '&Edit'
    TabOrder = 2
    OnClick = btnEditClick
    TextId = 0
  end
  object btnDelete: TSBSButton
    Left = 625
    Top = 82
    Width = 80
    Height = 21
    Caption = '&Delete'
    TabOrder = 3
    OnClick = btnDeleteClick
    TextId = 0
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.01 for Delphi 6.01'
    Left = 651
    Top = 114
  end
end
