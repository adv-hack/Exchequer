object frmXmlFunctions: TfrmXmlFunctions
  Left = 298
  Top = 88
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Xml Funcionalities'
  ClientHeight = 838
  ClientWidth = 952
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblGuid: TLabel
    Left = 4
    Top = 94
    Width = 3
    Height = 13
  end
  object Label1: TLabel
    Left = 10
    Top = 444
    Width = 22
    Height = 13
    Caption = 'XSD'
  end
  object Label2: TLabel
    Left = 480
    Top = 26
    Width = 60
    Height = 13
    Caption = 'Original XML'
  end
  object Label3: TLabel
    Left = 480
    Top = 446
    Width = 65
    Height = 13
    Caption = 'xml Transform'
  end
  object btnCrypto: TButton
    Left = 4
    Top = 6
    Width = 75
    Height = 25
    Caption = 'Crypto'
    TabOrder = 0
    OnClick = btnCryptoClick
  end
  object btnDecrypto: TButton
    Left = 84
    Top = 6
    Width = 75
    Height = 25
    Caption = 'DeCrypto'
    TabOrder = 1
    OnClick = btnDecryptoClick
  end
  object btnCompress: TButton
    Left = 4
    Top = 36
    Width = 75
    Height = 25
    Caption = 'Compress'
    TabOrder = 2
    OnClick = btnCompressClick
  end
  object btnDecompress: TButton
    Left = 84
    Top = 36
    Width = 75
    Height = 25
    Caption = 'DeCompress'
    TabOrder = 3
    OnClick = btnDecompressClick
  end
  object memXml: TMemo
    Left = 480
    Top = 44
    Width = 460
    Height = 360
    ScrollBars = ssVertical
    TabOrder = 4
    WordWrap = False
  end
  object btnGuid: TButton
    Left = 4
    Top = 66
    Width = 75
    Height = 25
    Caption = 'Guid'
    TabOrder = 5
    OnClick = btnGuidClick
  end
  object btnTransform: TButton
    Left = 4
    Top = 114
    Width = 75
    Height = 25
    Caption = 'Transform'
    TabOrder = 6
    OnClick = btnTransformClick
  end
  object btnValidate: TButton
    Left = 4
    Top = 148
    Width = 75
    Height = 25
    Caption = 'Validate?'
    TabOrder = 7
    OnClick = btnValidateClick
  end
  object memXsd: TMemo
    Left = 10
    Top = 464
    Width = 460
    Height = 360
    ScrollBars = ssVertical
    TabOrder = 8
    WordWrap = False
  end
  object memTransform: TMemo
    Left = 480
    Top = 464
    Width = 460
    Height = 360
    ScrollBars = ssVertical
    TabOrder = 9
  end
  object btnLoadCustomer: TButton
    Left = 4
    Top = 204
    Width = 101
    Height = 25
    Caption = 'Load Customer Files'
    TabOrder = 10
    OnClick = btnLoadCustomerClick
  end
  object btnTransform2: TButton
    Left = 84
    Top = 114
    Width = 75
    Height = 25
    Caption = 'Transform 2'
    TabOrder = 11
    OnClick = btnTransform2Click
  end
  object ckbFromFile: TCheckBox
    Left = 88
    Top = 154
    Width = 97
    Height = 17
    Caption = 'Load From File'
    Checked = True
    State = cbChecked
    TabOrder = 12
  end
  object btnExport: TButton
    Left = 4
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Export'
    TabOrder = 13
    OnClick = btnExportClick
  end
  object Button2: TButton
    Left = 4
    Top = 284
    Width = 75
    Height = 25
    Caption = 'Get Records'
    TabOrder = 14
    OnClick = Button2Click
  end
  object btnImport: TButton
    Left = 4
    Top = 326
    Width = 75
    Height = 25
    Caption = 'Import'
    TabOrder = 15
    OnClick = btnImportClick
  end
  object Button1: TButton
    Left = 356
    Top = 202
    Width = 75
    Height = 25
    Caption = 'Plugins'
    TabOrder = 16
  end
  object btnTestAdo: TButton
    Left = 200
    Top = 356
    Width = 75
    Height = 25
    Caption = 'Ado'
    TabOrder = 17
    OnClick = btnTestAdoClick
  end
  object Button3: TButton
    Left = 364
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 18
  end
  object Button4: TButton
    Left = 120
    Top = 356
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 19
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 94
    Top = 402
    Width = 75
    Height = 25
    Caption = 'Module Handle'
    TabOrder = 20
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 184
    Top = 402
    Width = 129
    Height = 25
    Caption = 'Show Balloon Tip'
    TabOrder = 21
    OnClick = Button6Click
  end
  object btnComExists: TButton
    Left = 658
    Top = 408
    Width = 83
    Height = 25
    Caption = 'Com application'
    TabOrder = 22
    OnClick = btnComExistsClick
  end
  object btnInstallMsi: TButton
    Left = 742
    Top = 406
    Width = 75
    Height = 25
    Caption = 'Install msi'
    TabOrder = 23
    OnClick = btnInstallMsiClick
  end
  object btnExportCom: TButton
    Left = 820
    Top = 406
    Width = 75
    Height = 25
    Caption = 'Export'
    TabOrder = 24
    OnClick = btnExportComClick
  end
  object btnChangeComProperty: TButton
    Left = 660
    Top = 438
    Width = 75
    Height = 25
    Caption = 'Property'
    TabOrder = 25
    OnClick = btnChangeComPropertyClick
  end
  object Button11: TButton
    Left = 354
    Top = 418
    Width = 75
    Height = 25
    Caption = 'Button11'
    TabOrder = 26
    OnClick = Button11Click
  end
  object btnCompany: TButton
    Left = 176
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Company'
    TabOrder = 27
    OnClick = btnCompanyClick
  end
  object DBGrid1: TDBGrid
    Left = 260
    Top = 230
    Width = 320
    Height = 120
    DataSource = DataSource1
    TabOrder = 28
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object OpenDialog1: TOpenDialog
    Left = 212
    Top = 138
  end
  object watWinXP1: TwatWinXP
    Left = 366
    Top = 144
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=ICE'
    Parameters = <>
    Left = 304
    Top = 60
  end
  object ADOCommand1: TADOCommand
    Parameters = <>
    Left = 306
    Top = 110
  end
  object ADOTable1: TADOTable
    Left = 252
    Top = 276
  end
  object DataSource1: TDataSource
    DataSet = ADOTable1
    Left = 176
    Top = 276
  end
end
