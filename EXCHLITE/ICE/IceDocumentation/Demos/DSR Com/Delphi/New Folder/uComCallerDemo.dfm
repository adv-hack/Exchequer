object frmDSRCOM: TfrmDSRCOM
  Left = 393
  Top = 230
  Width = 669
  Height = 643
  Caption = 'DSR COM Demo'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 317
    Top = 9
    Width = 33
    Height = 13
    Caption = 'Inbox'
  end
  object Label2: TLabel
    Left = 317
    Top = 149
    Width = 41
    Height = 13
    Caption = 'Outbox'
  end
  object Label3: TLabel
    Left = 24
    Top = 346
    Width = 43
    Height = 13
    Caption = 'Subject'
  end
  object Label4: TLabel
    Left = 192
    Top = 346
    Width = 29
    Height = 13
    Caption = 'From'
  end
  object Label5: TLabel
    Left = 360
    Top = 346
    Width = 14
    Height = 13
    Caption = 'To'
  end
  object Label6: TLabel
    Left = 24
    Top = 392
    Width = 54
    Height = 13
    Caption = 'Msg Type'
  end
  object Label7: TLabel
    Left = 82
    Top = 392
    Width = 36
    Height = 13
    Caption = 'Status'
  end
  object Label8: TLabel
    Left = 298
    Top = 392
    Width = 28
    Height = 13
    Caption = 'Total'
  end
  object Label9: TLabel
    Left = 140
    Top = 392
    Width = 69
    Height = 13
    Caption = 'Period From'
  end
  object Label10: TLabel
    Left = 222
    Top = 392
    Width = 54
    Height = 13
    Caption = 'Period To'
  end
  object Label11: TLabel
    Left = 24
    Top = 482
    Width = 82
    Height = 13
    Caption = 'Message Body'
  end
  object lblDate: TLabel
    Left = 362
    Top = 416
    Width = 4
    Height = 13
  end
  object Label12: TLabel
    Left = 24
    Top = 436
    Width = 38
    Height = 13
    Caption = 'IrMark'
  end
  object Label13: TLabel
    Left = 166
    Top = 248
    Width = 45
    Height = 13
    Caption = 'Interval'
  end
  object Label14: TLabel
    Left = 270
    Top = 248
    Width = 21
    Height = 13
    Caption = 'min'
  end
  object btnExport: TButton
    Left = 24
    Top = 44
    Width = 135
    Height = 25
    Caption = 'Export'
    TabOrder = 0
    OnClick = btnExportClick
  end
  object btnImport: TButton
    Left = 166
    Top = 44
    Width = 135
    Height = 25
    Caption = 'Import'
    TabOrder = 1
    OnClick = btnImportClick
  end
  object lvInbox: TListView
    Left = 317
    Top = 25
    Width = 320
    Height = 120
    Columns = <
      item
        Caption = 'Guid'
        Width = 300
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 13
    ViewStyle = vsReport
  end
  object lvOutbox: TListView
    Left = 317
    Top = 165
    Width = 320
    Height = 120
    Columns = <
      item
        Caption = 'Guid'
        Width = 300
      end>
    RowSelect = True
    TabOrder = 14
    ViewStyle = vsReport
  end
  object btnDeleteInbox: TButton
    Left = 24
    Top = 108
    Width = 135
    Height = 25
    Caption = 'Delete Inbox Msg'
    TabOrder = 4
    OnClick = btnDeleteInboxClick
  end
  object btnDeleteOutbox: TButton
    Left = 166
    Top = 108
    Width = 135
    Height = 25
    Caption = 'Delete Outbox Msg'
    TabOrder = 5
    OnClick = btnDeleteOutboxClick
  end
  object btnGetInboxDetail: TButton
    Left = 24
    Top = 140
    Width = 135
    Height = 25
    Caption = 'Get Inbox Msg Detail'
    TabOrder = 6
    OnClick = btnGetInboxDetailClick
  end
  object btnGetOutboxDetail: TButton
    Left = 166
    Top = 140
    Width = 135
    Height = 25
    Caption = 'Get Outbox Msg Detail'
    TabOrder = 7
    OnClick = btnGetOutboxDetailClick
  end
  object btnLoadInboxMsgs: TButton
    Left = 24
    Top = 76
    Width = 135
    Height = 25
    Caption = 'Load Inbox Msgs'
    TabOrder = 2
    OnClick = btnLoadInboxMsgsClick
  end
  object btnLoadOutboxMsgs: TButton
    Left = 166
    Top = 76
    Width = 135
    Height = 25
    Caption = 'Load Outbox Msgs'
    TabOrder = 3
    OnClick = btnLoadOutboxMsgsClick
  end
  object mmBody: TMemo
    Left = 24
    Top = 500
    Width = 585
    Height = 85
    TabOrder = 24
  end
  object edtSubj: TEdit
    Left = 24
    Top = 364
    Width = 165
    Height = 21
    TabOrder = 15
  end
  object edtFrom: TEdit
    Left = 192
    Top = 364
    Width = 165
    Height = 21
    TabOrder = 16
  end
  object edtTo: TEdit
    Left = 360
    Top = 364
    Width = 165
    Height = 21
    TabOrder = 17
  end
  object edtMsgType: TEdit
    Left = 24
    Top = 410
    Width = 54
    Height = 21
    TabOrder = 18
  end
  object edtStatus: TEdit
    Left = 82
    Top = 410
    Width = 54
    Height = 21
    TabOrder = 19
  end
  object edtTotal: TEdit
    Left = 298
    Top = 410
    Width = 55
    Height = 21
    TabOrder = 22
  end
  object edtPeriodFrom: TEdit
    Left = 140
    Top = 410
    Width = 71
    Height = 21
    TabOrder = 20
  end
  object edtPeriodTo: TEdit
    Left = 222
    Top = 410
    Width = 71
    Height = 21
    TabOrder = 21
  end
  object sbInfo: TStatusBar
    Left = 0
    Top = 590
    Width = 661
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
  object btnGGWSendPacket: TButton
    Left = 24
    Top = 204
    Width = 135
    Height = 25
    Caption = 'GGW Send Packet'
    TabOrder = 10
    OnClick = btnGGWSendPacketClick
  end
  object btnGGWGetPending: TButton
    Left = 166
    Top = 172
    Width = 135
    Height = 25
    Caption = 'GGW Get Pending'
    TabOrder = 9
    OnClick = btnGGWGetPendingClick
  end
  object btnGGWPreparePacket: TButton
    Left = 24
    Top = 172
    Width = 135
    Height = 25
    Caption = 'GGW Prepare Packet'
    TabOrder = 8
    OnClick = btnGGWPreparePacketClick
  end
  object edtIrMark: TEdit
    Left = 24
    Top = 454
    Width = 165
    Height = 21
    TabOrder = 23
  end
  object btnActivateTimer: TButton
    Left = 24
    Top = 236
    Width = 135
    Height = 25
    Caption = 'Enable Timer'
    TabOrder = 11
    OnClick = btnActivateTimerClick
  end
  object seTimer: TSpinEdit
    Left = 214
    Top = 239
    Width = 51
    Height = 22
    MaxValue = 1440
    MinValue = 1
    TabOrder = 12
    Value = 2
  end
  object btnExport1000: TButton
    Left = 24
    Top = 286
    Width = 135
    Height = 25
    Caption = 'Export Loop (100)'
    TabOrder = 26
    OnClick = btnExport1000Click
  end
  object tmMsg: TTimer
    Enabled = False
    Interval = 120000
    OnTimer = tmMsgTimer
    Left = 194
    Top = 286
  end
end
