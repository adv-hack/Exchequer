object frmRecordSizes: TfrmRecordSizes
  Left = 433
  Top = 176
  Hint = '|Close this window'
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Std Record Sizes'
  ClientHeight = 379
  ClientWidth = 219
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object lbRecordSizes: TListBox
    Left = 8
    Top = 16
    Width = 201
    Height = 321
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
    TabWidth = 20
  end
  object btnClose: TButton
    Left = 70
    Top = 352
    Width = 80
    Height = 21
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
end
