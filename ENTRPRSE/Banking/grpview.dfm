object frmGroupView: TfrmGroupView
  Left = 237
  Top = 114
  Width = 520
  Height = 322
  HelpContext = 2006
  Caption = 'frmGroupView'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 504
    Height = 229
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object mlTrans: TDBMultiList
      Left = 0
      Top = 0
      Width = 504
      Height = 229
      HelpContext = 2006
      Custom.SplitterCursor = crHSplit
      Dimensions.HeaderHeight = 18
      Dimensions.SpacerWidth = 1
      Dimensions.SplitterWidth = 3
      Options.BoldActiveColumn = False
      Columns = <
        item
          Caption = 'Doc'
          Color = clWhite
          Field = 'D'
          Searchable = True
          Sortable = True
          Width = 30
        end
        item
          Caption = 'Period'
          Color = clWhite
          Field = 'P'
          Width = 52
        end
        item
          Caption = 'A/C'
          Color = clWhite
          Field = 'A'
          Searchable = True
          Sortable = True
          Width = 52
          IndexNo = 1
        end
        item
          Caption = 'Details'
          Color = clWhite
          Field = 'N'
          Searchable = True
          Sortable = True
          IndexNo = 5
        end
        item
          Alignment = taRightJustify
          Caption = 'Amount'
          Color = clWhite
          Field = 'M'
          Searchable = True
          Sortable = True
          Width = 70
          IndexNo = 4
        end
        item
          Caption = 'Status'
          Color = clWhite
          Field = 'S'
          Searchable = True
          Sortable = True
          Width = 60
          IndexNo = 2
        end
        item
          Caption = 'Date'
          Color = clWhite
          Field = 'T'
          Searchable = True
          Sortable = True
          Width = 60
          IndexNo = 3
        end
        item
          Caption = 'Column 7'
          Searchable = True
          Sortable = True
          Visible = False
          IndexNo = 7
        end
        item
          Caption = 'Column 8'
          Searchable = True
          Sortable = True
          Visible = False
          IndexNo = 8
        end>
      TabStop = True
      OnColumnClick = mlTransColumnClick
      OnChangeSelection = mlTransChangeSelection
      OnRowDblClick = mlTransRowDblClick
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
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
      Dataset = btData
      Active = False
      SortColIndex = 0
      SortAsc = True
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 229
    Width = 504
    Height = 54
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      504
      54)
    object btnView: TSBSButton
      Left = 168
      Top = 17
      Width = 80
      Height = 21
      HelpContext = 2008
      Anchors = []
      Caption = '&View'
      TabOrder = 0
      OnClick = btnViewClick
      TextId = 0
    end
    object btnClose: TSBSButton
      Left = 256
      Top = 17
      Width = 80
      Height = 21
      HelpContext = 2009
      Anchors = []
      Cancel = True
      Caption = '&Close'
      TabOrder = 1
      OnClick = btnCloseClick
      TextId = 0
    end
  end
  object btData: TBtrieveDataset
    OnFilterRecord = btDataFilterRecord
    OnGetFieldValue = btDataGetFieldValue
    Left = 320
    Top = 192
  end
end
