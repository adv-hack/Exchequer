object frmUserList: TfrmUserList
  Left = 123
  Top = 166
  HelpContext = 19
  BorderStyle = bsDialog
  Caption = 'User List'
  ClientHeight = 265
  ClientWidth = 569
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object lvUsers: TListView
    Left = 8
    Top = 8
    Width = 474
    Height = 249
    Columns = <
      item
        Caption = 'Login Name'
        Width = 120
      end
      item
        Caption = 'Display Name'
        Width = 150
      end
      item
        Caption = 'Email Address'
        Width = 184
      end>
    ColumnClick = False
    FlatScrollBars = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = lvUsersChange
    OnDblClick = btnEditClick
  end
  object btnAdd: TButton
    Left = 488
    Top = 8
    Width = 73
    Height = 25
    Caption = '&Add'
    TabOrder = 1
    OnClick = btnAddClick
  end
  object btnEdit: TButton
    Left = 488
    Top = 40
    Width = 73
    Height = 25
    Caption = '&Edit'
    Enabled = False
    TabOrder = 2
    OnClick = btnEditClick
  end
  object btnDelete: TButton
    Left = 488
    Top = 72
    Width = 73
    Height = 25
    Caption = '&Delete'
    Enabled = False
    TabOrder = 3
    OnClick = btnDeleteClick
  end
  object btnClose: TButton
    Left = 488
    Top = 232
    Width = 73
    Height = 25
    Cancel = True
    Caption = '&Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object PopupMenu1: TPopupMenu
    Left = 16
    Top = 32
    object Edit1: TMenuItem
      Caption = '&Edit'
      OnClick = btnEditClick
    end
    object Add1: TMenuItem
      Caption = '&Add'
      OnClick = btnAddClick
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      OnClick = btnDeleteClick
    end
  end
end
