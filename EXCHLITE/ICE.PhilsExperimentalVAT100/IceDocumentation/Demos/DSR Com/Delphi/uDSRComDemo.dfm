object frmDSRCOM: TfrmDSRCOM
  Left = 356
  Top = 147
  Width = 625
  Height = 432
  Caption = 'DSR COM Demo'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label13: TLabel
    Left = 172
    Top = 360
    Width = 45
    Height = 13
    Caption = 'Interval'
  end
  object Label14: TLabel
    Left = 276
    Top = 360
    Width = 21
    Height = 13
    Caption = 'min'
  end
  object sbInfo: TStatusBar
    Left = 0
    Top = 379
    Width = 617
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object btnActivateTimer: TButton
    Left = 30
    Top = 348
    Width = 135
    Height = 25
    Caption = 'Enable Timer'
    TabOrder = 0
    OnClick = btnActivateTimerClick
  end
  object seTimer: TSpinEdit
    Left = 220
    Top = 351
    Width = 51
    Height = 22
    MaxValue = 1440
    MinValue = 1
    TabOrder = 1
    Value = 15
  end
  object PcDemo: TPageControl
    Left = 18
    Top = 22
    Width = 585
    Height = 321
    ActivePage = tbsOutBox
    TabIndex = 0
    TabOrder = 3
    object tbsOutBox: TTabSheet
      Caption = 'OutBox'
      object Label2: TLabel
        Left = 0
        Top = 124
        Width = 41
        Height = 13
        Caption = 'Outbox'
      end
      object Label15: TLabel
        Left = 4
        Top = 4
        Width = 95
        Height = 13
        Caption = 'Export Packages'
      end
      object lvOutbox: TListView
        Left = 0
        Top = 143
        Width = 577
        Height = 150
        Align = alBottom
        Columns = <
          item
            Caption = 'Subject'
            Width = 200
          end
          item
            Caption = 'To'
            Width = 200
          end
          item
            Caption = 'Sent'
            Width = 150
          end
          item
            Caption = 'Guid'
            Width = 150
          end>
        RowSelect = True
        TabOrder = 7
        ViewStyle = vsReport
      end
      object btnExport: TButton
        Left = 4
        Top = 48
        Width = 135
        Height = 25
        Caption = 'Export'
        TabOrder = 1
        OnClick = btnExportClick
      end
      object btnLoadOutboxMsgs: TButton
        Left = 142
        Top = 48
        Width = 135
        Height = 25
        Caption = 'Load Outbox Msgs'
        TabOrder = 2
        OnClick = btnLoadOutboxMsgsClick
      end
      object btnDeleteOutbox: TButton
        Left = 281
        Top = 48
        Width = 135
        Height = 25
        Caption = 'Delete Outbox Msg'
        TabOrder = 3
        OnClick = btnDeleteOutboxClick
      end
      object btnGetExportPackages: TButton
        Left = 420
        Top = 48
        Width = 135
        Height = 25
        Caption = 'Get Export Packages'
        TabOrder = 4
        OnClick = btnGetExportPackagesClick
      end
      object cbExportPackages: TComboBox
        Left = 4
        Top = 20
        Width = 200
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
      end
      object btnAddExportPackage: TButton
        Left = 4
        Top = 80
        Width = 135
        Height = 25
        Caption = 'Add Export Packages'
        TabOrder = 5
        OnClick = btnAddExportPackageClick
      end
      object btnDeleteExportPackage: TButton
        Left = 142
        Top = 80
        Width = 135
        Height = 25
        Caption = 'Delete Export Package'
        TabOrder = 6
        OnClick = btnDeleteExportPackageClick
      end
    end
    object tbsInbox: TTabSheet
      Caption = 'Inbox'
      ImageIndex = 1
      object Label1: TLabel
        Left = 6
        Top = 125
        Width = 33
        Height = 13
        Caption = 'Inbox'
      end
      object Label3: TLabel
        Left = 4
        Top = 4
        Width = 97
        Height = 13
        Caption = 'Import Packages'
      end
      object btnImport: TButton
        Left = 4
        Top = 48
        Width = 135
        Height = 25
        Caption = 'Import'
        TabOrder = 1
        OnClick = btnImportClick
      end
      object btnDeleteInbox: TButton
        Left = 281
        Top = 48
        Width = 135
        Height = 25
        Caption = 'Delete Inbox Msg'
        TabOrder = 3
        OnClick = btnDeleteInboxClick
      end
      object btnLoadInboxMsgs: TButton
        Left = 142
        Top = 48
        Width = 135
        Height = 25
        Caption = 'Load Inbox Msgs'
        TabOrder = 2
        OnClick = btnLoadInboxMsgsClick
      end
      object lvInbox: TListView
        Left = 0
        Top = 143
        Width = 577
        Height = 150
        Align = alBottom
        Columns = <
          item
            Caption = 'Subject'
            Width = 200
          end
          item
            Caption = 'From'
            Width = 200
          end
          item
            Caption = 'Received'
            Width = 150
          end
          item
            Caption = 'Guid'
            Width = 150
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 7
        ViewStyle = vsReport
      end
      object cbImportPackages: TComboBox
        Left = 4
        Top = 20
        Width = 200
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
      end
      object btnGetImportPackages: TButton
        Left = 420
        Top = 48
        Width = 135
        Height = 25
        Caption = 'Get Import Packages'
        TabOrder = 4
        OnClick = btnGetImportPackagesClick
      end
      object btnAddImportPackage: TButton
        Left = 4
        Top = 80
        Width = 135
        Height = 25
        Caption = 'Add Import Package'
        TabOrder = 5
        OnClick = btnAddImportPackageClick
      end
      object btnDeleteImportPackage: TButton
        Left = 142
        Top = 80
        Width = 135
        Height = 25
        Caption = 'Delete Import Package'
        TabOrder = 6
        OnClick = btnDeleteImportPackageClick
      end
    end
    object tbsGGW: TTabSheet
      Caption = 'GGW'
      ImageIndex = 2
      object btnGGWSendPacket: TButton
        Left = 280
        Top = 12
        Width = 135
        Height = 25
        Caption = 'GGW Send Packet'
        TabOrder = 0
        OnClick = btnGGWSendPacketClick
      end
      object btnGGWGetPending: TButton
        Left = 144
        Top = 12
        Width = 135
        Height = 25
        Caption = 'GGW Get Pending'
        TabOrder = 1
        OnClick = btnGGWGetPendingClick
      end
      object btnGGWPreparePacket: TButton
        Left = 6
        Top = 12
        Width = 135
        Height = 25
        Caption = 'GGW Prepare Packet'
        TabOrder = 2
        OnClick = btnGGWPreparePacketClick
      end
    end
  end
  object tmMsg: TTimer
    Enabled = False
    Interval = 120000
    OnTimer = tmMsgTimer
    Left = 190
    Top = 286
  end
end
