object FrmCardList3: TFrmCardList3
  Left = 190
  Top = 136
  Width = 696
  Height = 591
  Caption = 'FrmCardList3'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object DBMultiList2: TDBMultiList
    Left = 8
    Top = 264
    Width = 425
    Height = 250
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Number'
        Field = 'N'
        Searchable = True
        Sortable = True
      end
      item
        Caption = 'Description'
        Field = 'D'
        Searchable = True
        Sortable = True
        Width = 250
        IndexNo = 1
      end>
    TabStop = True
    TabOrder = 0
    Dataset = BtrieveDataset1
    Active = True
    SortColIndex = 0
    SortAsc = True
  end
  object Button1: TButton
    Left = 608
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
  end
  object DBMultiList1: TDBMultiList
    Left = 8
    Top = 8
    Width = 388
    Height = 257
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Number'
        Field = 'N'
        Searchable = True
        Sortable = True
      end
      item
        Caption = 'Description'
        Field = 'D'
        Searchable = True
        Sortable = True
        Width = 250
        IndexNo = 1
      end>
    TabStop = True
    TabOrder = 2
    Dataset = BTGlobalDataset1
    Active = True
    SortColIndex = 0
    SortAsc = True
  end
  object BTGlobalDataset1: TBTGlobalDataset
    FileName = 'cust\cust.dat'
    OnGetFieldValue = BTGlobalDataset1GetFieldValue
    OnGetFileVar = BTGlobalDataset1GetFileVar
    OnGetDataRecord = BTGlobalDataset1GetDataRecord
    OnGetBufferSize = BTGlobalDataset1GetBufferSize
    Left = 440
    Top = 8
  end
  object BtrieveDataset1: TBtrieveDataset
    FileName = 'cust\cust.dat'
    OnGetFieldValue = BTGlobalDataset1GetFieldValue
    Left = 440
    Top = 264
  end
end
