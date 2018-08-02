object frmQtyBreakProgress: TfrmQtyBreakProgress
  Left = 444
  Top = 332
  BorderStyle = bsDialog
  Caption = 'Converting Quantity Breaks'
  ClientHeight = 127
  ClientWidth = 290
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 202
    Height = 15
    Caption = 'Please wait - converting Qty Breaks'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblProgress: TLabel
    Left = 8
    Top = 48
    Width = 3
    Height = 13
  end
end
