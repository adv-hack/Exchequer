object frmLocList: TfrmLocList
  Left = 188
  Top = 156
  Width = 423
  Height = 257
  Caption = 'frmLocList'
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
  object lvLocations: TListView
    Left = 5
    Top = 6
    Width = 307
    Height = 219
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Code'
        Width = 70
      end
      item
        Caption = 'Name'
        Width = 200
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = btnViewClick
  end
  object Panel1: TPanel
    Left = 316
    Top = 6
    Width = 93
    Height = 219
    Alignment = taLeftJustify
    Anchors = [akLeft, akTop, akRight, akBottom]
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
      Left = 7
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
    object btnStkLoc: TButton
      Left = 7
      Top = 114
      Width = 80
      Height = 21
      Caption = '&View Stock'
      TabOrder = 4
      OnClick = btnStkLocClick
    end
  end
end
