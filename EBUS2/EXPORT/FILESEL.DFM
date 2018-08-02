object FrmSelectMapFile: TFrmSelectMapFile
  Left = 342
  Top = 195
  BorderStyle = bsDialog
  Caption = 'Select a map file'
  ClientHeight = 223
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object btnOK: TButton
    Left = 192
    Top = 192
    Width = 65
    Height = 25
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 264
    Top = 192
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object lvFiles: TListView
    Left = 8
    Top = 8
    Width = 321
    Height = 177
    Columns = <
      item
        Caption = 'Filename'
        Width = 100
      end
      item
        Caption = 'Description'
        Width = 217
      end>
    FullDrag = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = btnOKClick
  end
end
