object frmPluginsFunctions: TfrmPluginsFunctions
  Left = 194
  Top = 166
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Import/Export Plugins Funcionalities'
  ClientHeight = 768
  ClientWidth = 1021
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
    Left = 210
    Top = 164
    Width = 3
    Height = 13
  end
  object btnExportCustomer: TButton
    Left = 34
    Top = 94
    Width = 143
    Height = 25
    Caption = 'Export Customers'
    TabOrder = 0
    OnClick = btnExportCustomerClick
  end
  object btnReiceveCustomers: TButton
    Left = 32
    Top = 156
    Width = 143
    Height = 25
    Caption = 'Receive one Customers'
    TabOrder = 1
    OnClick = btnReiceveCustomersClick
  end
  object btnImport: TButton
    Left = 30
    Top = 226
    Width = 143
    Height = 25
    Caption = 'Import'
    TabOrder = 2
    OnClick = btnImportClick
  end
  object edtGuid: TEdit
    Left = 34
    Top = 194
    Width = 325
    Height = 21
    TabOrder = 3
  end
  object RichEdit1: TRichEdit
    Left = 488
    Top = 40
    Width = 525
    Height = 709
    PlainText = True
    TabOrder = 4
    WantReturns = False
  end
  object Button1: TButton
    Left = 44
    Top = 402
    Width = 75
    Height = 25
    Caption = 'Set Header'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 44
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Get Header'
    TabOrder = 6
    OnClick = Button2Click
  end
  object edtGuid2: TEdit
    Left = 36
    Top = 266
    Width = 325
    Height = 21
    TabOrder = 7
  end
  object Button3: TButton
    Left = 36
    Top = 334
    Width = 93
    Height = 25
    Caption = 'GGW Pending'
    TabOrder = 8
    OnClick = Button3Click
  end
  object btnDelete: TButton
    Left = 44
    Top = 490
    Width = 141
    Height = 25
    Caption = 'Delete Outbox Message'
    TabOrder = 9
    OnClick = btnDeleteClick
  end
end
