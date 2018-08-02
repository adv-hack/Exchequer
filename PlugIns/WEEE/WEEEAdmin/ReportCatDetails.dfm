object frmReportCatDetails: TfrmReportCatDetails
  Left = 357
  Top = 270
  BorderStyle = bsDialog
  Caption = 'Report Category Details'
  ClientHeight = 116
  ClientWidth = 248
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 20
    Width = 31
    Height = 14
    Caption = 'Code :'
  end
  object Label2: TLabel
    Left = 8
    Top = 52
    Width = 60
    Height = 14
    Caption = 'Description :'
  end
  object edCode: TEdit
    Left = 72
    Top = 16
    Width = 57
    Height = 22
    MaxLength = 10
    TabOrder = 0
  end
  object edDescription: TEdit
    Left = 72
    Top = 48
    Width = 169
    Height = 22
    MaxLength = 100
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 72
    Top = 88
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 160
    Top = 88
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 8
    Top = 80
  end
end
