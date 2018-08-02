object frmAccrualRepDlg: TfrmAccrualRepDlg
  Left = 373
  Top = 295
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Accruals Report'
  ClientHeight = 74
  ClientWidth = 232
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 14
  object btnOk: TButton
    Left = 32
    Top = 45
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancle: TButton
    Left = 120
    Top = 45
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object chkInclude: TCheckBox
    Left = 24
    Top = 16
    Width = 177
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Include Delivery Notes on Hold?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 592
    Top = 104
  end
end
