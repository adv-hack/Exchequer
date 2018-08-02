object frmLicWiz1: TfrmLicWiz1
  Left = 324
  Top = 126
  HelpContext = 1001
  ActiveControl = lstCDType
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'CD Licencing Wizard - Step 1 of 5'
  ClientHeight = 425
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 3
    Width = 288
    Height = 29
    AutoSize = False
    Caption = 'Installation Type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 35
    Width = 335
    Height = 30
    AutoSize = False
    Caption = 
      'Select the type of CD Licence to be created, or use the template' +
      ' button to load an existing template.'
    WordWrap = True
  end
  object Bevel2: TBevel
    Left = 8
    Top = 389
    Width = 341
    Height = 4
    Shape = bsBottomLine
  end
  object lstCDType: TListBox
    Left = 21
    Top = 166
    Width = 315
    Height = 86
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 19
    ParentFont = False
    TabOrder = 1
  end
  object btnNext: TButton
    Left = 255
    Top = 399
    Width = 79
    Height = 21
    Caption = '&Next >>'
    TabOrder = 3
    OnClick = btnNextClick
  end
  object lstLicType: TListBox
    Left = 21
    Top = 118
    Width = 315
    Height = 46
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 19
    Items.Strings = (
      'Customer / End-User'
      'Demo / Reseller')
    ParentFont = False
    TabOrder = 0
  end
  object lstCDCountry: TListBox
    Left = 21
    Top = 254
    Width = 315
    Height = 125
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 19
    ParentFont = False
    TabOrder = 2
  end
  object lstExchequerEdition: TListBox
    Left = 21
    Top = 69
    Width = 315
    Height = 46
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 19
    Items.Strings = (
      'Exchequer'
      'Exchequer Small Business Edition')
    ParentFont = False
    TabOrder = 4
  end
end
