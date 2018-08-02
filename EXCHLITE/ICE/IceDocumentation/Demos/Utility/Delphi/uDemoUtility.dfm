object frmDemoUtility: TfrmDemoUtility
  Left = 380
  Top = 316
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Demo Utility'
  ClientHeight = 119
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnCompress: TButton
    Left = 12
    Top = 44
    Width = 80
    Height = 25
    Caption = 'Compress'
    TabOrder = 0
    OnClick = btnCompressClick
  end
  object btnDecompress: TButton
    Left = 95
    Top = 44
    Width = 80
    Height = 25
    Caption = 'Decompress'
    TabOrder = 1
    OnClick = btnDecompressClick
  end
  object btnEncrypt: TButton
    Left = 178
    Top = 44
    Width = 80
    Height = 25
    Caption = 'Encrypt'
    TabOrder = 2
    OnClick = btnEncryptClick
  end
  object btnDecrypt: TButton
    Left = 261
    Top = 44
    Width = 80
    Height = 25
    Caption = 'Decrypt'
    TabOrder = 3
    OnClick = btnDecryptClick
  end
  object btnGetXml: TButton
    Left = 344
    Top = 44
    Width = 80
    Height = 25
    Caption = 'Get Xml'
    TabOrder = 4
    OnClick = btnGetXmlClick
  end
  object btnCreateFile: TButton
    Left = 12
    Top = 76
    Width = 80
    Height = 25
    Caption = 'Create File'
    TabOrder = 5
    OnClick = btnCreateFileClick
  end
  object odFiles: TOpenDialog
    Left = 28
    Top = 6
  end
end
