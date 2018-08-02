object frmStockList: TfrmStockList
  Left = 175
  Top = 183
  Width = 554
  Height = 273
  Caption = 'frmStockList'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    546
    239)
  PixelsPerInch = 96
  TextHeight = 13
  object lvStock: TListView
    Left = 5
    Top = 5
    Width = 438
    Height = 236
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'StockCode'
        Width = 110
      end
      item
        Caption = 'Description'
        Width = 220
      end
      item
        Caption = 'Supplier'
        Width = 75
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = btnViewClick
  end
  object Panel1: TPanel
    Left = 448
    Top = 5
    Width = 93
    Height = 236
    Alignment = taLeftJustify
    Anchors = [akTop, akRight, akBottom]
    BevelOuter = bvLowered
    TabOrder = 1
    object btnAdd: TButton
      Left = 6
      Top = 38
      Width = 80
      Height = 21
      Caption = '&Add'
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnEdit: TButton
      Left = 6
      Top = 62
      Width = 80
      Height = 21
      Caption = '&Edit'
      TabOrder = 2
      OnClick = btnEditClick
    end
    object btnView: TButton
      Left = 6
      Top = 86
      Width = 80
      Height = 21
      Caption = '&View'
      TabOrder = 3
      OnClick = btnViewClick
    end
    object btnClose: TButton
      Left = 6
      Top = 6
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Close'
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnViewLoc: TButton
      Left = 6
      Top = 113
      Width = 80
      Height = 21
      Caption = '&View Locations'
      TabOrder = 4
      OnClick = btnViewLocClick
    end
    object btnViewNotes: TButton
      Left = 6
      Top = 139
      Width = 80
      Height = 21
      Caption = '&Notes'
      TabOrder = 5
      OnClick = btnViewNotesClick
    end
  end
end
