object frmMatchingList: TfrmMatchingList
  Left = 363
  Top = 261
  BorderStyle = bsSingle
  Caption = 'frmMatchingList'
  ClientHeight = 186
  ClientWidth = 556
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
  object lvMatching: TListView
    Left = 5
    Top = 4
    Width = 546
    Height = 176
    Columns = <
      item
        Caption = 'Doc Code'
        Width = 100
      end
      item
        Caption = 'Pay Ref'
        Width = 100
      end
      item
        Caption = 'Type'
        Width = 40
      end
      item
        Alignment = taRightJustify
        Caption = 'Base'
        Width = 90
      end
      item
        Alignment = taRightJustify
        Caption = 'Doc'
        Width = 90
      end
      item
        Alignment = taRightJustify
        Caption = 'Receipt'
        Width = 90
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
end
