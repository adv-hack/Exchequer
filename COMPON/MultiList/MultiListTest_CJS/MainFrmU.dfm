object Form1: TForm1
  Left = 406
  Top = 111
  Width = 548
  Height = 586
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    540
    552)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 260
    Width = 49
    Height = 13
    Caption = 'Search for'
  end
  object TimeToOpenSQLLbl: TLabel
    Left = 436
    Top = 68
    Width = 65
    Height = 13
    Caption = 'Time to open:'
  end
  object DBMultiList1: TDBMultiList
    Left = 4
    Top = 4
    Width = 425
    Height = 247
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Options.MultiSelection = True
    Columns = <
      item
        Caption = 'Position'
        DataType = dtInteger
        Field = 'PositionID'
        Sortable = True
        Visible = False
      end
      item
        Caption = 'Our Ref'
        Field = 'thOurRef'
        Searchable = True
        Sortable = True
      end
      item
        Caption = 'Net Value'
        Field = 'thNetValue'
        Searchable = True
        Sortable = True
      end
      item
        Caption = 'Code'
        Field = 'thAcCode'
        Searchable = True
        Sortable = True
        Width = 64
      end
      item
        Caption = 'Date'
        DataType = dtDate
        Field = 'thTransDate'
        Searchable = True
        Sortable = True
      end>
    TabStop = True
    TabOrder = 0
    Anchors = [akLeft, akTop, akRight]
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
    Dataset = SQLDatasets1
    Active = False
    SortColIndex = 0
    SortAsc = True
  end
  object OpenBtn: TButton
    Left = 436
    Top = 36
    Width = 75
    Height = 25
    Caption = '&Open'
    TabOrder = 1
    OnClick = OpenBtnClick
  end
  object SearchTxt: TEdit
    Left = 60
    Top = 256
    Width = 157
    Height = 21
    TabOrder = 2
  end
  object SearchBtn: TButton
    Left = 220
    Top = 256
    Width = 75
    Height = 25
    Caption = '&Search'
    TabOrder = 3
    OnClick = SearchBtnClick
  end
  object DBMultiList2: TDBMultiList
    Left = 4
    Top = 296
    Width = 425
    Height = 250
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = '0'
        Field = '0'
        Searchable = True
        Sortable = True
      end
      item
        Caption = '1'
        Field = '1'
      end>
    TabStop = True
    TabOrder = 4
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
    Dataset = BtrieveDataset1
    Active = False
    SortColIndex = 0
    SortAsc = True
  end
  object Button1: TButton
    Left = 436
    Top = 324
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 5
    OnClick = Button1Click
  end
  object SelectAllBtn: TButton
    Left = 440
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Select &all'
    TabOrder = 6
    OnClick = SelectAllBtnClick
  end
  object SQLDatasets1: TSQLDatasets
    ConnectionString = 
      'Provider=SQLOLEDB.1;Data Source=P004435\IRISEXCHEQUER;Initial Ca' +
      'talog=EXCH63;User Id=EXCH63_ADMIN;Password=.eP96A3274A8511D44C49' +
      '250BA1ACA'
    Database = 'EXCH63'
    Password = '.eP96A3274A8511D44C49250BA1ACA'
    ServerAlias = 'P004435\IRISEXCHEQUER'
    TableName = 'ZZZZ01.DOCUMENT'
    UserName = 'EXCH63_ADMIN'
    OnGetDisplayValue = SQLDatasets1GetDisplayValue
    OnGetFieldValue = SQLDatasets1GetFieldValue
    UseWindowsAuthentication = False
    Left = 436
    Top = 8
  end
  object BtrieveDataset1: TBtrieveDataset
    FileName = 'C:\EXCHEQR\CUST\CUSTSUPP.DAT'
    OnGetFieldValue = BtrieveDataset1GetFieldValue
    Left = 436
    Top = 296
  end
end
