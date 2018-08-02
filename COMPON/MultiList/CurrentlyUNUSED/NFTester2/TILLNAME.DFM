object FrmTillNames: TFrmTillNames
  Left = 276
  Top = 267
  HelpContext = 53
  BorderStyle = bsDialog
  Caption = 'Till Names'
  ClientHeight = 185
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object lvTills: TListView
    Left = 8
    Top = 8
    Width = 299
    Height = 137
    Columns = <
      item
        Caption = 'Till No'
        Width = 45
      end
      item
        Caption = 'Till Description'
        Width = 150
      end
      item
        Caption = 'Till Name'
        Width = 100
      end>
    ColumnClick = False
    FlatScrollBars = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = btnEditClick
  end
  object btnClose: TButton
    Left = 234
    Top = 152
    Width = 73
    Height = 25
    Caption = '&Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object btnEdit: TButton
    Left = 8
    Top = 152
    Width = 73
    Height = 25
    Caption = '&Edit Till'
    TabOrder = 2
    OnClick = btnEditClick
  end
end
