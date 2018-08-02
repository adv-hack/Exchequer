object frmCustList: TfrmCustList
  Left = 171
  Top = 171
  BorderStyle = bsDialog
  Caption = 'Exercise 1 - Creating the COM Toolkit'
  ClientHeight = 148
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 16
    Width = 76
    Height = 13
    Caption = 'Toolkit Version: '
  end
  object lblVersion: TLabel
    Left = 128
    Top = 16
    Width = 3
    Height = 13
  end
  object btnOpen: TButton
    Left = 400
    Top = 16
    Width = 75
    Height = 25
    Caption = '&Open Toolkit'
    TabOrder = 0
    OnClick = btnOpenClick
  end
end
