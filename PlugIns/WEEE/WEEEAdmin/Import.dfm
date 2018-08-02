object frmImport: TfrmImport
  Left = 258
  Top = 172
  BorderStyle = bsDialog
  Caption = 'Import WEEE Product Info'
  ClientHeight = 392
  ClientWidth = 516
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 44
    Width = 48
    Height = 14
    Caption = 'Filename :'
  end
  object Label2: TLabel
    Left = 8
    Top = 12
    Width = 51
    Height = 14
    Caption = 'Company :'
  end
  object lCompany: TLabel
    Left = 64
    Top = 12
    Width = 48
    Height = 14
    Caption = 'Filename :'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object memInfo: TMemo
    Left = 64
    Top = 72
    Width = 417
    Height = 281
    ReadOnly = True
    TabOrder = 2
  end
  object btnRunImport: TButton
    Left = 312
    Top = 360
    Width = 80
    Height = 21
    Caption = '&Run Import'
    TabOrder = 4
    OnClick = btnRunImportClick
  end
  object edFilename: TEdit
    Left = 64
    Top = 40
    Width = 417
    Height = 22
    TabOrder = 0
  end
  object btnBrowse: TButton
    Left = 481
    Top = 41
    Width = 25
    Height = 22
    Caption = '...'
    TabOrder = 1
    OnClick = btnBrowseClick
  end
  object btnCancel: TButton
    Left = 400
    Top = 360
    Width = 80
    Height = 21
    Caption = '&Cancel'
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object btnSave: TButton
    Left = 64
    Top = 360
    Width = 80
    Height = 21
    Caption = '&Save Log'
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object OpenDialog1: TOpenDialog
    Left = 8
    Top = 64
  end
  object SaveDialog: TSaveDialog
    Left = 144
    Top = 360
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 8
    Top = 96
  end
end
