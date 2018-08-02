object FrmTillList: TFrmTillList
  Left = 337
  Top = 233
  HelpContext = 35
  BorderStyle = bsDialog
  Caption = 'Edit Till List'
  ClientHeight = 230
  ClientWidth = 376
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object btnEdit: TButton
    Left = 288
    Top = 32
    Width = 80
    Height = 21
    Caption = '&Edit'
    TabOrder = 2
    OnClick = btnEditClick
  end
  object btnDelete: TButton
    Left = 288
    Top = 56
    Width = 80
    Height = 21
    Caption = '&Delete'
    TabOrder = 3
    OnClick = btnDeleteClick
  end
  object btnClose: TButton
    Left = 288
    Top = 204
    Width = 80
    Height = 21
    Caption = '&Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object btnAdd: TButton
    Left = 288
    Top = 8
    Width = 80
    Height = 21
    Caption = '&Add'
    TabOrder = 1
    OnClick = btnAddClick
  end
  object lvTills: TListView
    Left = 8
    Top = 40
    Width = 273
    Height = 185
    Columns = <
      item
        Caption = 'No'
        Width = 25
      end
      item
        Caption = 'Name'
        Width = 120
      end
      item
        Caption = 'Company'
        Width = 84
      end
      item
        Caption = 'Setup'
        Width = 40
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = lvTillsChange
    OnClick = lvTillsClick
    OnDblClick = lvTillsDblClick
  end
  object edName: TEdit
    Left = 8
    Top = 8
    Width = 273
    Height = 22
    Enabled = False
    TabOrder = 5
  end
end
