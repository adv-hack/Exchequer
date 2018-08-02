object frmMain: TfrmMain
  Left = 419
  Top = 411
  Width = 585
  Height = 470
  Caption = 'Main Form'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 125
    Height = 436
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object Bevel1: TBevel
      Left = 3
      Top = 201
      Width = 113
      Height = 3
    end
    object btnDummyStartPolling: TButton
      Left = 10
      Top = 212
      Width = 100
      Height = 25
      Caption = 'Dummy Start Polling'
      TabOrder = 0
      OnClick = btnDummyStartPollingClick
    end
    object btnAddIR: TButton
      Left = 10
      Top = 12
      Width = 100
      Height = 25
      Caption = 'Add IR Mark'
      TabOrder = 1
      OnClick = btnAddIRClick
    end
    object btnPostDoc: TButton
      Left = 10
      Top = 48
      Width = 100
      Height = 25
      Caption = 'Post Document'
      TabOrder = 2
      OnClick = btnPostDocClick
    end
    object btnBeginPolling: TButton
      Left = 10
      Top = 88
      Width = 100
      Height = 25
      Caption = 'Begin Polling'
      TabOrder = 3
      OnClick = btnBeginPollingClick
    end
    object btnReassignURL: TButton
      Left = 10
      Top = 124
      Width = 100
      Height = 25
      Caption = 'Reassign URL'
      TabOrder = 4
      OnClick = btnReassignURLClick
    end
    object btnDelete: TButton
      Left = 10
      Top = 164
      Width = 100
      Height = 25
      Caption = 'Delete'
      TabOrder = 5
      OnClick = btnDeleteClick
    end
  end
  object PageControl2: TPageControl
    Left = 125
    Top = 0
    Width = 452
    Height = 436
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Commentary'
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 444
        Height = 408
        Align = alClient
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Sample XML'
      ImageIndex = 1
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 444
        Height = 408
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object XMLDocument1: TXMLDocument
    Left = 40
    Top = 268
    DOMVendorDesc = 'MSXML'
  end
end
