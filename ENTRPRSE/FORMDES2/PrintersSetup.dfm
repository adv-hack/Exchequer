object FrmPrintersSetup: TFrmPrintersSetup
  Left = 404
  Top = 257
  BorderStyle = bsDialog
  Caption = 'Printers Setup'
  ClientHeight = 178
  ClientWidth = 227
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object mlPrinters: TMultiList
    Left = 6
    Top = 4
    Width = 129
    Height = 169
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Printer'
        Field = 'P'
        Searchable = True
        Sortable = True
        Width = 95
      end>
    TabStop = True
    OnRowDblClick = mlPrintersRowDblClick
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
  object btnEdit: TButton
    Left = 141
    Top = 56
    Width = 80
    Height = 21
    Caption = '&Edit'
    TabOrder = 1
    OnClick = btnEditClick
  end
  object btnDelete: TButton
    Left = 141
    Top = 80
    Width = 80
    Height = 21
    Caption = '&Delete'
    TabOrder = 2
    OnClick = btnDeleteClick
  end
  object btnClose: TButton
    Left = 141
    Top = 24
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
end
