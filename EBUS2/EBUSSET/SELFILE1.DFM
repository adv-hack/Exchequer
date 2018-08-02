object FrmSelectFile: TFrmSelectFile
  Left = 407
  Top = 189
  BorderStyle = bsDialog
  Caption = 'Select a file'
  ClientHeight = 193
  ClientWidth = 224
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object btnOK: TButton
    Left = 152
    Top = 8
    Width = 65
    Height = 25
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 152
    Top = 40
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object lvFiles: TListView
    Left = 8
    Top = 8
    Width = 137
    Height = 177
    Columns = <
      item
        Caption = 'Filename'
        Width = 133
      end>
    FullDrag = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = lvFilesDblClick
  end
end
