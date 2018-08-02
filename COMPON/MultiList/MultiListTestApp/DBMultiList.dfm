object frmDBMultiList: TfrmDBMultiList
  Left = 263
  Top = 114
  Width = 696
  Height = 480
  Caption = 'frmDBMultiList'
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
  object Button1: TButton
    Left = 440
    Top = 8
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Close'
    TabOrder = 0
    OnClick = Button1Click
  end
  object DBMultiList1: TDBMultiList
    Left = 8
    Top = 8
    Width = 425
    Height = 250
    Custom.SplitterCursor = crHSplit
    Dimensions.HeaderHeight = 18
    Dimensions.SpacerWidth = 1
    Dimensions.SplitterWidth = 3
    Options.BoldActiveColumn = False
    Columns = <
      item
        Caption = 'Column 0'
      end
      item
        Caption = 'Column 1'
      end
      item
        Caption = 'Column 2'
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
    Dataset = ComTKDataset1
    Active = True
    SortColIndex = 0
    SortAsc = True
  end
  object ComTKDataset1: TComTKDataset
    Left = 8
    Top = 264
  end
end
