object Form1: TForm1
  Left = 288
  Top = 153
  Width = 522
  Height = 504
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SQLList: TDBMultiList
    Left = 0
    Top = 0
    Width = 514
    Height = 221
    Custom.SplitterCursor = crHSplit
    Columns = <
      item
        Caption = 'Abbreviation'
        Field = 'abbrev'
        Searchable = True
        Sortable = True
      end
      item
        Caption = 'State'
        Field = 'name'
        Searchable = True
        Sortable = True
      end>
    TabStop = True
    Align = alClient
    TabOrder = 0
    Dataset = SQLDatasets1
  end
  object Panel1: TPanel
    Left = 0
    Top = 435
    Width = 514
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Button1: TButton
      Left = 376
      Top = 8
      Width = 115
      Height = 25
      Caption = 'Show Suppliers'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 248
      Top = 8
      Width = 115
      Height = 25
      Caption = 'Show Customers'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object BTrieveList: TDBMultiList
    Left = 0
    Top = 221
    Width = 514
    Height = 214
    Custom.SplitterCursor = crHSplit
    Columns = <
      item
        Caption = 'Customer Code'
        Field = '0'
        Searchable = True
        Sortable = True
      end
      item
        Caption = 'Company'
        Field = '1'
      end
      item
        Caption = 'Contact'
        Field = '2'
      end>
    TabStop = True
    Align = alBottom
    TabOrder = 2
    Dataset = BtrieveDataset1
  end
  object SQLDatasets1: TSQLDatasets
    PrimaryKey = 'abbrev'
    ServerAlias = 'pvideodb'
    TableName = 'states'
    Left = 16
    Top = 32
  end
  object BtrieveDataset1: TBtrieveDataset
    FileName = 'C:\Entrprse\cust\custsupp.dat'
    SearchKey = 'C'
    SearchIndex = 5
    OnGetFieldValue = BtrieveDataset1GetFieldValue
    Left = 16
    Top = 248
  end
end
