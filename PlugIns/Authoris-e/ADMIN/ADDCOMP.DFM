object frmAddCompany: TfrmAddCompany
  Left = 425
  Top = 315
  HelpContext = 1
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Add Company'
  ClientHeight = 120
  ClientWidth = 256
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 241
    Height = 41
    Alignment = taCenter
    AutoSize = False
    Caption = 'Please select the company you wish to add into Authoris-e'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object cmbCompanies: TComboBox
    Left = 8
    Top = 56
    Width = 241
    Height = 22
    Style = csDropDownList
    CharCase = ecUpperCase
    ItemHeight = 14
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 112
    Top = 88
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 184
    Top = 88
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
