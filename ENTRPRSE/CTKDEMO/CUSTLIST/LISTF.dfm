object frmCustList: TfrmCustList
  Left = 341
  Top = 204
  Width = 537
  Height = 280
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Exchequer Enterprise COM Toolkit Demo'
  Color = clBtnFace
  Constraints.MinHeight = 250
  Constraints.MinWidth = 150
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    529
    246)
  PixelsPerInch = 96
  TextHeight = 13
  object lvCustomers: TListView
    Left = 4
    Top = 5
    Width = 422
    Height = 244
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Code'
        Width = 70
      end
      item
        Caption = 'Company'
        Width = 200
      end
      item
        Alignment = taRightJustify
        Caption = 'Balance (YTD)'
        Width = 120
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = btnViewClick
  end
  object Panel1: TPanel
    Left = 431
    Top = 5
    Width = 93
    Height = 244
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
    object btnViewNotes: TButton
      Left = 6
      Top = 139
      Width = 80
      Height = 21
      Caption = '&Notes'
      TabOrder = 4
      OnClick = btnViewNotesClick
    end
    object btnDiscounts: TButton
      Left = 6
      Top = 115
      Width = 80
      Height = 21
      Caption = '&Discounts'
      TabOrder = 5
      OnClick = btnDiscountsClick
    end
    object Button1: TButton
      Left = 6
      Top = 177
      Width = 80
      Height = 21
      Caption = 'Supp1 Discs'
      TabOrder = 6
    end
    object btnPrint: TButton
      Left = 6
      Top = 205
      Width = 80
      Height = 21
      Caption = '&Print'
      TabOrder = 7
      OnClick = btnPrintClick
    end
  end
end
