object frmComDSRDemo: TfrmComDSRDemo
  Left = 234
  Top = 226
  Width = 918
  Height = 526
  Caption = 'COM DSR Demo'
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
  object Label1: TLabel
    Left = 30
    Top = 8
    Width = 43
    Height = 13
    Caption = 'Exports'
  end
  object Label2: TLabel
    Left = 182
    Top = 8
    Width = 45
    Height = 13
    Caption = 'Imports'
  end
  object Label3: TLabel
    Left = 30
    Top = 224
    Width = 92
    Height = 13
    Caption = 'Company Name'
  end
  object Label4: TLabel
    Left = 160
    Top = 226
    Width = 30
    Height = 13
    Caption = 'Code'
  end
  object Label5: TLabel
    Left = 352
    Top = 8
    Width = 29
    Height = 13
    Caption = 'From'
  end
  object Label6: TLabel
    Left = 516
    Top = 4
    Width = 11
    Height = 13
    Caption = 'to'
  end
  object Label7: TLabel
    Left = 688
    Top = 10
    Width = 47
    Height = 13
    Caption = 'Period 1'
  end
  object Label8: TLabel
    Left = 746
    Top = 12
    Width = 47
    Height = 13
    Caption = 'Period 2'
  end
  object btnExport: TButton
    Left = 418
    Top = 68
    Width = 125
    Height = 25
    Caption = 'Export'
    TabOrder = 0
    OnClick = btnExportClick
  end
  object btnIMport: TButton
    Left = 548
    Top = 68
    Width = 125
    Height = 25
    Caption = 'Import'
    TabOrder = 1
    OnClick = btnIMportClick
  end
  object btngetout: TButton
    Left = 288
    Top = 100
    Width = 125
    Height = 25
    Caption = 'Get Out Msg'
    TabOrder = 10
    OnClick = btngetoutClick
  end
  object Button4: TButton
    Left = 546
    Top = 100
    Width = 125
    Height = 25
    Caption = 'Outbox Total'
    TabOrder = 12
    OnClick = Button4Click
  end
  object btnNewMessages: TButton
    Left = 30
    Top = 130
    Width = 125
    Height = 25
    Caption = 'New Messages'
    TabOrder = 13
    OnClick = btnNewMessagesClick
  end
  object lv: TListView
    Left = 0
    Top = 381
    Width = 910
    Height = 111
    Align = alBottom
    Columns = <
      item
        Caption = 'From'
        Width = 150
      end
      item
        Caption = 'Date'
        Width = 100
      end
      item
        Caption = 'Guid'
        Width = 250
      end>
    RowSelect = True
    TabOrder = 14
    ViewStyle = vsReport
  end
  object btnResend: TButton
    Left = 158
    Top = 130
    Width = 125
    Height = 25
    Caption = 'Resend'
    TabOrder = 2
    OnClick = btnResendClick
  end
  object btnSetImportPackage: TButton
    Left = 160
    Top = 100
    Width = 125
    Height = 25
    Caption = 'Set Import Package'
    TabOrder = 9
    OnClick = btnSetImportPackageClick
  end
  object btnSetExportPck: TButton
    Left = 31
    Top = 100
    Width = 125
    Height = 25
    Caption = 'Set Export Package'
    TabOrder = 8
    OnClick = btnSetExportPckClick
  end
  object btnDeleteex: TButton
    Left = 289
    Top = 68
    Width = 125
    Height = 25
    Caption = 'Delete Exp'
    TabOrder = 7
    OnClick = btnDeleteexClick
  end
  object btngetinboxmsg: TButton
    Left = 417
    Top = 100
    Width = 125
    Height = 25
    Caption = 'Get Inbox msg'
    TabOrder = 11
    OnClick = btngetinboxmsgClick
  end
  object cbExports: TComboBox
    Left = 30
    Top = 28
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
  end
  object cbImports: TComboBox
    Left = 182
    Top = 28
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
  end
  object btnGetExpPackages: TButton
    Left = 30
    Top = 68
    Width = 125
    Height = 25
    Caption = 'Get Export Packages'
    TabOrder = 5
    OnClick = btnGetExpPackagesClick
  end
  object GetImportPackages: TButton
    Left = 159
    Top = 68
    Width = 125
    Height = 25
    Caption = 'Get Import Packages'
    TabOrder = 6
    OnClick = GetImportPackagesClick
  end
  object btnDeleteOutbox: TButton
    Left = 288
    Top = 130
    Width = 125
    Height = 25
    Caption = 'Delete OutBox'
    TabOrder = 15
    OnClick = btnDeleteOutboxClick
  end
  object btnSetDaySchedule: TButton
    Left = 30
    Top = 162
    Width = 125
    Height = 25
    Caption = 'Daily Schedule'
    TabOrder = 16
    OnClick = btnSetDayScheduleClick
  end
  object btnWeeklySchedule: TButton
    Left = 160
    Top = 162
    Width = 125
    Height = 25
    Caption = 'Weekly Schedule'
    Enabled = False
    TabOrder = 17
    OnClick = btnWeeklyScheduleClick
  end
  object btnMonthlySchedule: TButton
    Left = 288
    Top = 162
    Width = 125
    Height = 25
    Caption = 'Monthly Schedule'
    Enabled = False
    TabOrder = 18
    OnClick = btnMonthlyScheduleClick
  end
  object btnOneTimeOnly: TButton
    Left = 420
    Top = 162
    Width = 125
    Height = 25
    Caption = 'One Time Schedule'
    Enabled = False
    TabOrder = 19
    OnClick = btnOneTimeOnlyClick
  end
  object btnDeleteSchedule: TButton
    Left = 548
    Top = 162
    Width = 125
    Height = 25
    Caption = 'Delete Schedule'
    TabOrder = 20
    OnClick = btnDeleteScheduleClick
  end
  object btnBulk: TButton
    Left = 30
    Top = 194
    Width = 125
    Height = 25
    Caption = 'Bulk'
    TabOrder = 21
    OnClick = btnBulkClick
  end
  object Button2: TButton
    Left = 160
    Top = 194
    Width = 125
    Height = 25
    Caption = 'Chek Mail List'
    TabOrder = 22
  end
  object edtCompany: TEdit
    Left = 30
    Top = 244
    Width = 121
    Height = 21
    TabOrder = 23
  end
  object btnCreateCompany: TButton
    Left = 290
    Top = 242
    Width = 125
    Height = 25
    Caption = 'Create Company'
    TabOrder = 24
    OnClick = btnCreateCompanyClick
  end
  object cbCompanies: TComboBox
    Left = 30
    Top = 278
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 25
  end
  object btnLoadCompanies: TButton
    Left = 188
    Top = 276
    Width = 125
    Height = 25
    Caption = 'Load Companies'
    TabOrder = 26
    OnClick = btnLoadCompaniesClick
  end
  object edtCode: TEdit
    Left = 160
    Top = 244
    Width = 121
    Height = 21
    TabOrder = 27
  end
  object edtFrom: TEdit
    Left = 348
    Top = 26
    Width = 159
    Height = 21
    TabOrder = 28
    Text = 'vmoura@exchequer.com'
  end
  object edtTo: TEdit
    Left = 514
    Top = 26
    Width = 163
    Height = 21
    TabOrder = 29
    Text = 'redbaron@exchequer.com'
  end
  object btnSync: TButton
    Left = 420
    Top = 242
    Width = 107
    Height = 25
    Caption = 'Sync'
    TabOrder = 30
    OnClick = btnSyncClick
  end
  object btnRebuild: TButton
    Left = 318
    Top = 276
    Width = 107
    Height = 25
    Caption = 'Rebuild'
    TabOrder = 31
    OnClick = btnRebuildClick
  end
  object btnCheckDripFeed: TButton
    Left = 28
    Top = 320
    Width = 125
    Height = 25
    Caption = 'checkDripfeed'
    TabOrder = 32
    OnClick = btnCheckDripFeedClick
  end
  object btnRemovedripFeed: TButton
    Left = 156
    Top = 320
    Width = 125
    Height = 25
    Caption = 'Remove drip feed'
    TabOrder = 33
    OnClick = btnRemovedripFeedClick
  end
  object btnCheckCompanies: TButton
    Left = 284
    Top = 320
    Width = 125
    Height = 25
    Caption = 'Check Companies'
    TabOrder = 34
    OnClick = btnCheckCompaniesClick
  end
  object btnCheckMails: TButton
    Left = 410
    Top = 320
    Width = 125
    Height = 25
    Caption = 'Check Mails'
    TabOrder = 35
    OnClick = btnCheckMailsClick
  end
  object btnGetDsrSettings: TButton
    Left = 666
    Top = 186
    Width = 125
    Height = 25
    Caption = 'Get Dsr Settings'
    TabOrder = 36
    OnClick = btnGetDsrSettingsClick
  end
  object btnSetDsrSettings: TButton
    Left = 666
    Top = 216
    Width = 125
    Height = 25
    Caption = 'Set Dsr Settings'
    TabOrder = 37
    OnClick = btnSetDsrSettingsClick
  end
  object btnSyncRequest: TButton
    Left = 534
    Top = 242
    Width = 101
    Height = 25
    Caption = 'Sync Request'
    TabOrder = 38
    OnClick = btnSyncRequestClick
  end
  object Button1: TButton
    Left = 696
    Top = 86
    Width = 75
    Height = 25
    Caption = 'POP login'
    TabOrder = 39
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 696
    Top = 116
    Width = 75
    Height = 25
    Caption = 'POP logout'
    TabOrder = 40
    OnClick = Button3Click
  end
  object btnLastAuditDate: TButton
    Left = 536
    Top = 320
    Width = 125
    Height = 25
    Caption = 'last audit date'
    TabOrder = 41
    OnClick = btnLastAuditDateClick
  end
  object btnAlive: TButton
    Left = 664
    Top = 320
    Width = 125
    Height = 25
    Caption = 'Check Alive'
    TabOrder = 42
    OnClick = btnAliveClick
  end
  object Button5: TButton
    Left = 428
    Top = 276
    Width = 107
    Height = 25
    Caption = 'Get Drip Feed'
    TabOrder = 43
    OnClick = Button5Click
  end
  object btnActivateCompany: TButton
    Left = 540
    Top = 276
    Width = 107
    Height = 25
    Caption = 'Activate Company'
    TabOrder = 44
    OnClick = btnActivateCompanyClick
  end
  object btnProductType: TButton
    Left = 666
    Top = 244
    Width = 125
    Height = 25
    Caption = 'Product Type'
    TabOrder = 45
    OnClick = btnProductTypeClick
  end
  object btnBulkExport: TButton
    Left = 422
    Top = 208
    Width = 107
    Height = 25
    Caption = 'Bulk Export'
    TabOrder = 46
    OnClick = btnBulkExportClick
  end
  object edtPeriod1: TEdit
    Left = 688
    Top = 30
    Width = 49
    Height = 21
    TabOrder = 47
  end
  object edtPeriod2: TEdit
    Left = 744
    Top = 30
    Width = 49
    Height = 21
    TabOrder = 48
  end
  object Button6: TButton
    Left = 654
    Top = 276
    Width = 137
    Height = 25
    Caption = 'Ex Periods'
    TabOrder = 49
    OnClick = Button6Click
  end
  object edtGuid: TEdit
    Left = 26
    Top = 356
    Width = 221
    Height = 21
    TabOrder = 50
  end
  object btnSyncDeny: TButton
    Left = 802
    Top = 276
    Width = 101
    Height = 25
    Caption = 'Deny Sync'
    TabOrder = 51
    OnClick = btnSyncDenyClick
  end
  object btnRecreateCompany: TButton
    Left = 284
    Top = 356
    Width = 125
    Height = 25
    Caption = 'Recreate Company'
    TabOrder = 52
    OnClick = btnRecreateCompanyClick
  end
  object Button7: TButton
    Left = 424
    Top = 356
    Width = 101
    Height = 25
    Caption = 'Restore'
    TabOrder = 53
    OnClick = Button7Click
  end
  object msPOP1: TmsPOPClient
    Version = '2.1'
    Host = '192.168.0.1'
    Port = 110
    MailMessage = msMessage1
    UserName = 'vmoura'
    Password = 'ten10fex'
    Left = 696
    Top = 152
  end
  object msMessage1: TmsMessage
    ContentType = 'text/plain'
    Version = '2.1'
    ReturnReceipt = False
    Left = 732
    Top = 146
  end
end
