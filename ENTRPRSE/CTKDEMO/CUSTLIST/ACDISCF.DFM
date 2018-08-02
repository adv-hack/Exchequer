object frmAccountDiscounts: TfrmAccountDiscounts
  Left = 289
  Top = 281
  BorderStyle = bsDialog
  Caption = 'frmAccountDiscounts'
  ClientHeight = 226
  ClientWidth = 679
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lvDiscounts: TListView
    Left = 5
    Top = 6
    Width = 571
    Height = 215
    Columns = <
      item
        Caption = 'Stock Code'
        Width = 120
      end
      item
        Caption = 'Ccy'
        Width = 35
      end
      item
        Alignment = taCenter
        Caption = 'Typ'
        Width = 55
      end
      item
        Alignment = taRightJustify
        Caption = 'Unit Price'
        Width = 75
      end
      item
        Alignment = taCenter
        Caption = 'Band'
        Width = 45
      end
      item
        Alignment = taRightJustify
        Caption = 'Disc%'
        Width = 70
      end
      item
        Alignment = taRightJustify
        Caption = 'Disc (Val)'
        Width = 70
      end
      item
        Alignment = taRightJustify
        Caption = 'MU/MG'
        Width = 70
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Panel1: TPanel
    Left = 581
    Top = 6
    Width = 93
    Height = 215
    Alignment = taLeftJustify
    Anchors = [akLeft, akTop, akBottom]
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
