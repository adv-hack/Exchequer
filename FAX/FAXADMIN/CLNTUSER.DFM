object frmClientLoginList: TfrmClientLoginList
  Left = 303
  Top = 169
  HelpContext = 26
  BorderStyle = bsDialog
  Caption = 'Client Login List'
  ClientHeight = 295
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lvUsers: TListView
    Left = 8
    Top = 8
    Width = 321
    Height = 249
    Columns = <
      item
        Caption = 'Machine Name'
        Width = 150
      end
      item
        Caption = 'User Name'
        Width = 150
      end>
    ColumnClick = False
    FlatScrollBars = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object btnClose: TButton
    Left = 256
    Top = 264
    Width = 73
    Height = 25
    Caption = '&Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
end
