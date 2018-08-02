object frmMultiList: TfrmMultiList
  Left = 217
  Top = 189
  Width = 680
  Height = 480
  Caption = 'frmMultiList'
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
  object mlList: TMultiList
    Left = 8
    Top = 8
    Width = 550
    Height = 433
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'A'
        Field = 'A'
        Searchable = True
        Sortable = True
        Visible = False
      end
      item
        Caption = 'B'
        Field = 'B'
        Searchable = True
        Sortable = True
      end
      item
        Caption = 'C'
        Field = 'C'
        Searchable = True
        Sortable = True
      end
      item
        Caption = 'D'
        Field = 'D'
      end
      item
        Caption = 'E'
        Field = 'E'
        Searchable = True
        Sortable = True
      end>
    TabStop = True
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
  object btnAddItems: TButton
    Left = 568
    Top = 8
    Width = 97
    Height = 25
    Caption = 'Add Items'
    TabOrder = 1
    OnClick = btnAddItemsClick
  end
  object Button1: TButton
    Left = 568
    Top = 40
    Width = 97
    Height = 25
    Caption = 'Sort Column A'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 567
    Top = 72
    Width = 97
    Height = 25
    Caption = 'Sort Column B'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 568
    Top = 104
    Width = 97
    Height = 25
    Caption = '&Close'
    TabOrder = 4
    OnClick = Button3Click
  end
end
