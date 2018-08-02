object frmTables: TfrmTables
  Left = 507
  Top = 339
  BorderStyle = bsDialog
  Caption = 'frmTables'
  ClientHeight = 263
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object mlTables: TMultiList
    Left = 8
    Top = 8
    Width = 265
    Height = 250
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Table Name'
        Width = 231
      end>
    TabStop = True
    OnCellPaint = mlTablesCellPaint
    OnRowDblClick = mlTablesRowDblClick
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
  object btnAdd: TButton
    Left = 280
    Top = 7
    Width = 80
    Height = 21
    Caption = '&Add'
    TabOrder = 1
    OnClick = btnAddClick
  end
  object btnEdit: TButton
    Left = 280
    Top = 31
    Width = 80
    Height = 21
    Caption = '&Edit'
    TabOrder = 2
    OnClick = btnEditClick
  end
  object btnDelete: TButton
    Left = 280
    Top = 55
    Width = 80
    Height = 21
    Caption = '&Delete'
    TabOrder = 3
    OnClick = btnDeleteClick
  end
  object Button1: TButton
    Left = 280
    Top = 231
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 4
    OnClick = Button1Click
  end
  object btnView: TButton
    Left = 280
    Top = 79
    Width = 80
    Height = 21
    Caption = '&View'
    TabOrder = 5
    OnClick = btnViewClick
  end
end
