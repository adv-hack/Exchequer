object frmCustSelect: TfrmCustSelect
  Left = 224
  Top = 265
  BorderStyle = bsSingle
  Caption = 'Select Customer Record'
  ClientHeight = 217
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 134
    Top = 191
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 225
    Top = 191
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object lvCust: TListView
    Left = 4
    Top = 5
    Width = 431
    Height = 180
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
    OnDblClick = btnOKClick
  end
end
