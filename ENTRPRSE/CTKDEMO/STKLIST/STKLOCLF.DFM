object frmStkLocList: TfrmStkLocList
  Left = 196
  Top = 239
  Width = 586
  Height = 197
  Caption = 'frmStkLocList'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lvStockLoc: TListView
    Left = 5
    Top = 6
    Width = 472
    Height = 158
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Code'
        Width = 110
      end
      item
        Caption = 'Name'
        Width = 170
      end
      item
        Alignment = taRightJustify
        Caption = 'In Stk'
        Width = 55
      end
      item
        Alignment = taRightJustify
        Caption = 'Free'
        Width = 55
      end
      item
        Alignment = taRightJustify
        Caption = 'On Ord'
        Width = 55
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = btnViewClick
  end
  object Panel1: TPanel
    Left = 483
    Top = 6
    Width = 91
    Height = 157
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
  end
end
