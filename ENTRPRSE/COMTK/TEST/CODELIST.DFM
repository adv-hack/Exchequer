object frmCodeList: TfrmCodeList
  Left = 192
  Top = 107
  BorderIcons = [biMaximize]
  BorderStyle = bsDialog
  Caption = 'frmCodeList'
  ClientHeight = 217
  ClientWidth = 446
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 345
    Height = 193
    Caption = 'Panel1'
    TabOrder = 0
    object lvCodes: TListView
      Left = 8
      Top = 8
      Width = 329
      Height = 177
      Columns = <
        item
          Caption = 'Code'
          Width = 100
        end
        item
          Caption = 'Name'
          Width = 200
        end>
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = lvCodesDblClick
    end
  end
  object btnOK: TButton
    Left = 360
    Top = 8
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 360
    Top = 40
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
