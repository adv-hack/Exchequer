object frmSelectDept: TfrmSelectDept
  Left = 432
  Top = 183
  ActiveControl = lvDepartments
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Select Department'
  ClientHeight = 255
  ClientWidth = 180
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
  object lvDepartments: TListView
    Left = 5
    Top = 5
    Width = 169
    Height = 216
    Columns = <
      item
        Caption = 'Department Code'
        Width = 250
      end>
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
  end
  object btnSelect: TButton
    Left = 50
    Top = 228
    Width = 80
    Height = 21
    Caption = '&Select'
    TabOrder = 1
    OnClick = btnSelectClick
  end
end
