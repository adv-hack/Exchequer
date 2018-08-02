object frmUpdateCommittedBal: TfrmUpdateCommittedBal
  Left = 263
  Top = 123
  BorderStyle = bsDialog
  Caption = 'Update Committed Balances'
  ClientHeight = 130
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object lblProgress: TLabel
    Left = 72
    Top = 64
    Width = 3
    Height = 14
  end
  object Label2: TLabel
    Left = 72
    Top = 32
    Width = 211
    Height = 14
    Caption = 'Please wait. Updating committed balances...'
  end
end
