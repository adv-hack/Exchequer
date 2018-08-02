object frmMainDebug: TfrmMainDebug
  Left = 583
  Top = 634
  Width = 569
  Height = 166
  Caption = 'frmDrillDownServer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 553
    Height = 127
    Align = alClient
    Columns = <
      item
        Caption = 'Time'
        Width = 90
      end
      item
        Caption = 'Msg'
        Width = 1000
      end>
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
  end
  object PopupMenu1: TPopupMenu
    Left = 52
    Top = 42
    object Clear1: TMenuItem
      Caption = 'Clear'
      OnClick = Clear1Click
    end
  end
end
