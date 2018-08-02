object frmCurrencyList: TfrmCurrencyList
  Left = 214
  Top = 167
  Width = 639
  Height = 277
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'COM Toolkit Demo - Currency List'
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
  object lvCurrency: TListView
    Left = 5
    Top = 4
    Width = 620
    Height = 239
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Width = 30
      end
      item
        Caption = 'Description'
        Width = 100
      end
      item
        Caption = 'Scr'
        Width = 35
      end
      item
        Caption = 'Prn'
        Width = 35
      end
      item
        Alignment = taRightJustify
        Caption = 'Daily Rate'
        Width = 90
      end
      item
        Alignment = taRightJustify
        Caption = 'Company Rate'
        Width = 90
      end
      item
        Alignment = taCenter
        Caption = '1/X'
        Width = 35
      end
      item
        Alignment = taCenter
        Caption = 'Float'
        Width = 35
      end
      item
        Caption = 'Tri Ccy'
      end
      item
        Alignment = taRightJustify
        Caption = 'Tri Rate'
        Width = 90
      end>
    TabOrder = 0
    ViewStyle = vsReport
  end
end
