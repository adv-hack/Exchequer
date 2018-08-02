object Form1: TForm1
  Left = 356
  Top = 568
  Width = 637
  Height = 420
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 56
    Top = 24
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Button1: TButton
    Left = 472
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 0
    OnClick = Button1Click
  end
  object mlID: TDBMultiList
    Left = 32
    Top = 48
    Width = 505
    Height = 321
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'SSD Commodity'
        Field = 'S'
        Searchable = True
        Sortable = True
        IndexNo = 9
      end
      item
        Caption = 'B2B Link'
        DataType = dtInteger
        Field = 'B'
      end
      item
        Caption = 'Folio'
        DataType = dtInteger
        Field = 'F'
        Searchable = True
        Sortable = True
      end>
    TabStop = True
    TabOrder = 1
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
    Dataset = Btd1
    Active = False
    SortColIndex = 0
    SortAsc = True
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Btrieve Files (*.Dat) | *.Dat'
    Left = 600
  end
  object Btd1: TBtrieveDataset
    OnGetFieldValue = Btd1GetFieldValue
    Left = 576
    Top = 176
  end
end
