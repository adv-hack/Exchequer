object frmEnablecustomButtons: TfrmEnablecustomButtons
  Left = 643
  Top = 251
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Enable Custom Buttons'
  ClientHeight = 702
  ClientWidth = 654
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 0
    Top = 33
    Width = 654
    Height = 669
    ActivePage = daybk2Sheet
    Align = alClient
    TabIndex = 3
    TabOrder = 0
    object custlst2Sheet: TTabSheet
      Caption = 'Cust/Supp List'
      object GroupBox4: TGroupBox
        Left = 8
        Top = 32
        Width = 105
        Height = 145
        Caption = 'Customers'
        TabOrder = 0
        object btnToggleCustList: TSpeedButton
          Left = 72
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleCustListClick
        end
        object chkCustLst1: TCheckBox
          Left = 16
          Top = 40
          Width = 80
          Height = 17
          Caption = 'Button 1'
          TabOrder = 0
          OnClick = chkChangedClick
        end
        object chkCustLst2: TCheckBox
          Left = 16
          Top = 56
          Width = 80
          Height = 17
          Caption = 'Button 2'
          TabOrder = 1
          OnClick = chkChangedClick
        end
        object chkCustLst3: TCheckBox
          Left = 16
          Top = 72
          Width = 80
          Height = 17
          Caption = 'Button 3'
          TabOrder = 2
          OnClick = chkChangedClick
        end
        object chkCustLst4: TCheckBox
          Left = 16
          Top = 88
          Width = 80
          Height = 17
          Caption = 'Button 4'
          TabOrder = 3
          OnClick = chkChangedClick
        end
        object chkCustLst5: TCheckBox
          Left = 16
          Top = 104
          Width = 80
          Height = 17
          Caption = 'Button 5'
          TabOrder = 4
          OnClick = chkChangedClick
        end
        object chkCustLst6: TCheckBox
          Left = 16
          Top = 120
          Width = 80
          Height = 17
          Caption = 'Button 6'
          TabOrder = 5
          OnClick = chkChangedClick
        end
      end
      object GroupBox5: TGroupBox
        Left = 120
        Top = 32
        Width = 105
        Height = 145
        Caption = 'Suppliers'
        TabOrder = 1
        object btnToggleSuppList: TSpeedButton
          Left = 72
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleSuppListClick
        end
        object chkSuppLst1: TCheckBox
          Left = 16
          Top = 40
          Width = 80
          Height = 17
          Caption = 'Button 1'
          TabOrder = 0
          OnClick = chkChangedClick
        end
        object chkSuppLst2: TCheckBox
          Left = 16
          Top = 56
          Width = 80
          Height = 17
          Caption = 'Button 2'
          TabOrder = 1
          OnClick = chkChangedClick
        end
        object chkSuppLst3: TCheckBox
          Left = 16
          Top = 72
          Width = 80
          Height = 17
          Caption = 'Button 3'
          TabOrder = 2
          OnClick = chkChangedClick
        end
        object chkSuppLst4: TCheckBox
          Left = 16
          Top = 88
          Width = 80
          Height = 17
          Caption = 'Button 4'
          TabOrder = 3
          OnClick = chkChangedClick
        end
        object chkSuppLst5: TCheckBox
          Left = 16
          Top = 104
          Width = 80
          Height = 17
          Caption = 'Button 5'
          TabOrder = 4
          OnClick = chkChangedClick
        end
        object chkSuppLst6: TCheckBox
          Left = 16
          Top = 120
          Width = 80
          Height = 17
          Caption = 'Button 6'
          TabOrder = 5
          OnClick = chkChangedClick
        end
      end
      object btnToggleTraderList: TButton
        Left = 8
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Toggle All'
        TabOrder = 2
        OnClick = btnToggleTraderListClick
      end
      object btnRandomCustSupp: TButton
        Left = 88
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Random'
        TabOrder = 3
        OnClick = btnRandomCustSuppClick
      end
      object btnTraderAllOff: TButton
        Left = 168
        Top = 0
        Width = 75
        Height = 25
        Caption = 'All Off'
        TabOrder = 4
        OnClick = btnTraderAllOffClick
      end
    end
    object custr3uSheet: TTabSheet
      Caption = 'Cust/Supp Ledger'
      ImageIndex = 1
      object GroupBox6: TGroupBox
        Left = 8
        Top = 32
        Width = 105
        Height = 145
        Caption = 'Customer Ledger'
        TabOrder = 0
        object btnToggleCustLedger: TSpeedButton
          Left = 72
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleCustLedgerClick
        end
        object chkCustLedger1: TCheckBox
          Left = 16
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 0
          OnClick = chkChangedClick
        end
        object chkCustLedger2: TCheckBox
          Left = 16
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 1
          OnClick = chkChangedClick
        end
        object chkCustLedger3: TCheckBox
          Left = 16
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 2
          OnClick = chkChangedClick
        end
        object chkCustLedger4: TCheckBox
          Left = 16
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 3
          OnClick = chkChangedClick
        end
        object chkCustLedger5: TCheckBox
          Left = 16
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 4
          OnClick = chkChangedClick
        end
        object chkCustLedger6: TCheckBox
          Left = 16
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 5
          OnClick = chkChangedClick
        end
      end
      object GroupBox7: TGroupBox
        Left = 120
        Top = 32
        Width = 105
        Height = 145
        Caption = 'Supplier Ledger'
        TabOrder = 1
        object btnToggleSuppLedger: TSpeedButton
          Left = 72
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleSuppLedgerClick
        end
        object chkSuppLedger1: TCheckBox
          Left = 16
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 0
          OnClick = chkChangedClick
        end
        object chkSuppLedger2: TCheckBox
          Left = 16
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 1
          OnClick = chkChangedClick
        end
        object chkSuppLedger3: TCheckBox
          Left = 16
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 2
          OnClick = chkChangedClick
        end
        object chkSuppLedger4: TCheckBox
          Left = 16
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 3
          OnClick = chkChangedClick
        end
        object chkSuppLedger5: TCheckBox
          Left = 16
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 4
          OnClick = chkChangedClick
        end
        object chkSuppLedger6: TCheckBox
          Left = 16
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 5
          OnClick = chkChangedClick
        end
      end
      object btnToggleCustSuppLedger: TButton
        Left = 8
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Toggle All'
        TabOrder = 2
        OnClick = btnToggleCustSuppLedgerClick
      end
      object btnRandomCustSuppLedger: TButton
        Left = 88
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Random'
        TabOrder = 3
        OnClick = btnRandomCustSuppLedgerClick
      end
      object btnLedgerAllOff: TButton
        Left = 168
        Top = 0
        Width = 75
        Height = 25
        Caption = 'All Off'
        TabOrder = 4
        OnClick = btnLedgerAllOffClick
      end
    end
    object jobmn2uSheet: TTabSheet
      Caption = 'Job Record'
      ImageIndex = 2
      object GroupBox8: TGroupBox
        Left = 8
        Top = 32
        Width = 521
        Height = 145
        Caption = 'Job Record'
        TabOrder = 0
        object Label17: TLabel
          Left = 7
          Top = 19
          Width = 22
          Height = 14
          Caption = 'Main'
        end
        object Bevel13: TBevel
          Left = 104
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label18: TLabel
          Left = 115
          Top = 19
          Width = 28
          Height = 14
          Caption = 'Notes'
        end
        object Bevel14: TBevel
          Left = 208
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label19: TLabel
          Left = 215
          Top = 19
          Width = 34
          Height = 14
          Caption = 'Ledger'
        end
        object Bevel15: TBevel
          Left = 312
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label20: TLabel
          Left = 322
          Top = 19
          Width = 50
          Height = 14
          Caption = 'Purch Ret.'
        end
        object Bevel16: TBevel
          Left = 416
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label21: TLabel
          Left = 422
          Top = 19
          Width = 49
          Height = 14
          Caption = 'Sales Ret.'
        end
        object btnToggleJobMain: TSpeedButton
          Left = 72
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleJobMainClick
        end
        object btnToggleJobNotes: TSpeedButton
          Left = 176
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleJobNotesClick
        end
        object btnToggleJobLedger: TSpeedButton
          Left = 280
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleJobLedgerClick
        end
        object btnToggleJobPurchRet: TSpeedButton
          Left = 384
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleJobPurchRetClick
        end
        object btnToggleJobRet: TSpeedButton
          Left = 488
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleJobRetClick
        end
        object chkJobNotes1: TCheckBox
          Left = 120
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 0
          OnClick = chkChangedClick
        end
        object chkJobNotes2: TCheckBox
          Left = 120
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 1
          OnClick = chkChangedClick
        end
        object chkJobLedger1: TCheckBox
          Left = 224
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 2
          OnClick = chkChangedClick
        end
        object chkJobLedger2: TCheckBox
          Left = 224
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 3
          OnClick = chkChangedClick
        end
        object chkJobPurchRet1: TCheckBox
          Left = 328
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 4
          OnClick = chkChangedClick
        end
        object chkJobPurchRet2: TCheckBox
          Left = 328
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 5
          OnClick = chkChangedClick
        end
        object chkJobSalesRet1: TCheckBox
          Left = 432
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 6
          OnClick = chkChangedClick
        end
        object chkJobSalesRet2: TCheckBox
          Left = 432
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 7
          OnClick = chkChangedClick
        end
        object chkJobMain1: TCheckBox
          Left = 16
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 8
          OnClick = chkChangedClick
        end
        object chkJobMain2: TCheckBox
          Left = 16
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 9
          OnClick = chkChangedClick
        end
        object chkJobNotes3: TCheckBox
          Left = 120
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 10
          OnClick = chkChangedClick
        end
        object chkJobNotes4: TCheckBox
          Left = 120
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 11
          OnClick = chkChangedClick
        end
        object chkJobLedger3: TCheckBox
          Left = 224
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 12
          OnClick = chkChangedClick
        end
        object chkJobLedger4: TCheckBox
          Left = 224
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 13
          OnClick = chkChangedClick
        end
        object chkJobPurchRet3: TCheckBox
          Left = 328
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 14
          OnClick = chkChangedClick
        end
        object chkJobPurchRet4: TCheckBox
          Left = 328
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 15
          OnClick = chkChangedClick
        end
        object chkJobSalesRet3: TCheckBox
          Left = 432
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 16
          OnClick = chkChangedClick
        end
        object chkJobSalesRet4: TCheckBox
          Left = 432
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 17
          OnClick = chkChangedClick
        end
        object chkJobMain3: TCheckBox
          Left = 16
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 18
          OnClick = chkChangedClick
        end
        object chkJobMain4: TCheckBox
          Left = 16
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 19
          OnClick = chkChangedClick
        end
        object chkJobNotes5: TCheckBox
          Left = 120
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 20
          OnClick = chkChangedClick
        end
        object chkJobNotes6: TCheckBox
          Left = 120
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 21
          OnClick = chkChangedClick
        end
        object chkJobLedger5: TCheckBox
          Left = 224
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 22
          OnClick = chkChangedClick
        end
        object chkJobLedger6: TCheckBox
          Left = 224
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 23
          OnClick = chkChangedClick
        end
        object chkJobPurchRet5: TCheckBox
          Left = 328
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 24
          OnClick = chkChangedClick
        end
        object chkJobPurchRet6: TCheckBox
          Left = 328
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 25
          OnClick = chkChangedClick
        end
        object chkJobSalesRet5: TCheckBox
          Left = 432
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 26
          OnClick = chkChangedClick
        end
        object chkJobSalesRet6: TCheckBox
          Left = 432
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 27
          OnClick = chkChangedClick
        end
        object chkJobMain5: TCheckBox
          Left = 16
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 28
          OnClick = chkChangedClick
        end
        object chkJobMain6: TCheckBox
          Left = 16
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 29
          OnClick = chkChangedClick
        end
      end
      object btnToggleJobRecord: TButton
        Left = 8
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Toggle All'
        TabOrder = 1
        OnClick = btnToggleJobRecordClick
      end
      object btnRandomJobRec: TButton
        Left = 88
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Random'
        TabOrder = 2
        OnClick = btnRandomJobRecClick
      end
      object btnJobRecAllOff: TButton
        Left = 168
        Top = 0
        Width = 75
        Height = 25
        Caption = 'All Off'
        TabOrder = 3
        OnClick = btnJobRecAllOffClick
      end
    end
    object daybk2Sheet: TTabSheet
      Caption = 'Daybooks'
      ImageIndex = 3
      object GroupBox1: TGroupBox
        Left = 8
        Top = 32
        Width = 633
        Height = 145
        Caption = ' Sales Daybook '
        TabOrder = 0
        object Label1: TLabel
          Left = 7
          Top = 19
          Width = 22
          Height = 14
          Caption = 'Main'
        end
        object Bevel1: TBevel
          Left = 104
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label2: TLabel
          Left = 115
          Top = 19
          Width = 35
          Height = 14
          Caption = 'Quotes'
        end
        object Bevel2: TBevel
          Left = 208
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label3: TLabel
          Left = 215
          Top = 19
          Width = 23
          Height = 14
          Caption = 'Auto'
        end
        object Bevel3: TBevel
          Left = 312
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label4: TLabel
          Left = 322
          Top = 19
          Width = 34
          Height = 14
          Caption = 'History'
        end
        object Bevel4: TBevel
          Left = 416
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label5: TLabel
          Left = 422
          Top = 19
          Width = 34
          Height = 14
          Caption = 'Orders'
        end
        object Bevel5: TBevel
          Left = 520
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label6: TLabel
          Left = 530
          Top = 19
          Width = 65
          Height = 14
          Caption = 'Order History'
        end
        object btnToggleDaybookMain: TSpeedButton
          Left = 72
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleDaybookMainClick
        end
        object btnToggleDaybookQuotes: TSpeedButton
          Left = 176
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleDaybookQuotesClick
        end
        object btnToggleDaybookAuto: TSpeedButton
          Left = 280
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleDaybookAutoClick
        end
        object btnToggleDaybookHistory: TSpeedButton
          Left = 384
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleDaybookHistoryClick
        end
        object btnToggleDaybookOrders: TSpeedButton
          Left = 488
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleDaybookOrdersClick
        end
        object btnToggleDaybookOrderHist: TSpeedButton
          Left = 600
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleDaybookOrderHistClick
        end
        object chkSalesDBkQuotes1: TCheckBox
          Left = 120
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 0
          OnClick = chkChangedClick
        end
        object chkSalesDBkQuotes2: TCheckBox
          Left = 120
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 1
          OnClick = chkChangedClick
        end
        object chkSalesDBkAuto1: TCheckBox
          Left = 224
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 2
          OnClick = chkChangedClick
        end
        object chkSalesDBkAuto2: TCheckBox
          Left = 224
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 3
          OnClick = chkChangedClick
        end
        object chkSalesDBkHistory1: TCheckBox
          Left = 328
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 4
          OnClick = chkChangedClick
        end
        object chkSalesDBkHistory2: TCheckBox
          Left = 328
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 5
          OnClick = chkChangedClick
        end
        object chkSalesDBkOrders1: TCheckBox
          Left = 432
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 6
          OnClick = chkChangedClick
        end
        object chkSalesDBkOrders2: TCheckBox
          Left = 432
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 7
          OnClick = chkChangedClick
        end
        object chkSalesDBkOrderHistory1: TCheckBox
          Left = 536
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 8
          OnClick = chkChangedClick
        end
        object chkSalesDBkOrderHistory2: TCheckBox
          Left = 536
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 9
          OnClick = chkChangedClick
        end
        object chkSalesDBkMain1: TCheckBox
          Left = 16
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 10
          OnClick = chkChangedClick
        end
        object chkSalesDBkMain2: TCheckBox
          Left = 16
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 11
          OnClick = chkChangedClick
        end
        object chkSalesDBkQuotes3: TCheckBox
          Left = 120
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 12
          OnClick = chkChangedClick
        end
        object chkSalesDBkQuotes4: TCheckBox
          Left = 120
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 13
          OnClick = chkChangedClick
        end
        object chkSalesDBkAuto3: TCheckBox
          Left = 224
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 14
          OnClick = chkChangedClick
        end
        object chkSalesDBkAuto4: TCheckBox
          Left = 224
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 15
          OnClick = chkChangedClick
        end
        object chkSalesDBkHistory3: TCheckBox
          Left = 328
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 16
          OnClick = chkChangedClick
        end
        object chkSalesDBkHistory4: TCheckBox
          Left = 328
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 17
          OnClick = chkChangedClick
        end
        object chkSalesDBkOrders3: TCheckBox
          Left = 432
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 18
          OnClick = chkChangedClick
        end
        object chkSalesDBkOrders4: TCheckBox
          Left = 432
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 19
          OnClick = chkChangedClick
        end
        object chkSalesDBkOrderHistory3: TCheckBox
          Left = 536
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 20
          OnClick = chkChangedClick
        end
        object chkSalesDBkOrderHistory4: TCheckBox
          Left = 536
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 21
          OnClick = chkChangedClick
        end
        object chkSalesDBkMain3: TCheckBox
          Left = 16
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 22
          OnClick = chkChangedClick
        end
        object chkSalesDBkMain4: TCheckBox
          Left = 16
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 23
          OnClick = chkChangedClick
        end
        object chkSalesDBkQuotes5: TCheckBox
          Left = 120
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 24
          OnClick = chkChangedClick
        end
        object chkSalesDBkQuotes6: TCheckBox
          Left = 120
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 25
          OnClick = chkChangedClick
        end
        object chkSalesDBkAuto5: TCheckBox
          Left = 224
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 26
          OnClick = chkChangedClick
        end
        object chkSalesDBkAuto6: TCheckBox
          Left = 224
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 27
          OnClick = chkChangedClick
        end
        object chkSalesDBkHistory5: TCheckBox
          Left = 328
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 28
          OnClick = chkChangedClick
        end
        object chkSalesDBkHistory6: TCheckBox
          Left = 328
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 29
          OnClick = chkChangedClick
        end
        object chkSalesDBkOrders5: TCheckBox
          Left = 432
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 30
          OnClick = chkChangedClick
        end
        object chkSalesDBkOrders6: TCheckBox
          Left = 432
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 31
          OnClick = chkChangedClick
        end
        object chkSalesDBkOrderHistory5: TCheckBox
          Left = 536
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 32
          OnClick = chkChangedClick
        end
        object chkSalesDBkOrderHistory6: TCheckBox
          Left = 536
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 33
          OnClick = chkChangedClick
        end
        object chkSalesDBkMain5: TCheckBox
          Left = 16
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 34
          OnClick = chkChangedClick
        end
        object chkSalesDBkMain6: TCheckBox
          Left = 16
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 35
          OnClick = chkChangedClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 184
        Width = 633
        Height = 145
        Caption = ' Purchase Daybook '
        TabOrder = 1
        object Label7: TLabel
          Left = 7
          Top = 19
          Width = 22
          Height = 14
          Caption = 'Main'
        end
        object Bevel6: TBevel
          Left = 104
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object Label8: TLabel
          Left = 115
          Top = 19
          Width = 35
          Height = 14
          Caption = 'Quotes'
        end
        object Bevel7: TBevel
          Left = 208
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object Label9: TLabel
          Left = 215
          Top = 19
          Width = 23
          Height = 14
          Caption = 'Auto'
        end
        object Bevel8: TBevel
          Left = 312
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object Label10: TLabel
          Left = 322
          Top = 19
          Width = 34
          Height = 14
          Caption = 'History'
        end
        object Bevel9: TBevel
          Left = 416
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object Label11: TLabel
          Left = 422
          Top = 19
          Width = 34
          Height = 14
          Caption = 'Orders'
        end
        object Bevel10: TBevel
          Left = 520
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object Label12: TLabel
          Left = 530
          Top = 19
          Width = 65
          Height = 14
          Caption = 'Order History'
        end
        object btnPurchToggleDaybookMain: TSpeedButton
          Left = 72
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnPurchToggleDaybookMainClick
        end
        object btnPurchToggleDaybookQuotes: TSpeedButton
          Left = 176
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnPurchToggleDaybookQuotesClick
        end
        object btnPurchToggleDaybookAuto: TSpeedButton
          Left = 280
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnPurchToggleDaybookAutoClick
        end
        object btnPurchToggleDaybookHist: TSpeedButton
          Left = 384
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnPurchToggleDaybookHistClick
        end
        object btnPurchToggleDaybookOrders: TSpeedButton
          Left = 488
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnPurchToggleDaybookOrdersClick
        end
        object btnPurchToggleDaybookOrderHist: TSpeedButton
          Left = 600
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnPurchToggleDaybookOrderHistClick
        end
        object chkPurchDBkMain1: TCheckBox
          Left = 16
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 0
          OnClick = chkChangedClick
        end
        object chkPurchDBkMain2: TCheckBox
          Left = 16
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 1
          OnClick = chkChangedClick
        end
        object chkPurchDBkQuotes1: TCheckBox
          Left = 120
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 2
          OnClick = chkChangedClick
        end
        object chkPurchDBkQuotes2: TCheckBox
          Left = 120
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 3
          OnClick = chkChangedClick
        end
        object chkPurchDBkAuto1: TCheckBox
          Left = 224
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 4
          OnClick = chkChangedClick
        end
        object chkPurchDBkAuto2: TCheckBox
          Left = 224
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 5
          OnClick = chkChangedClick
        end
        object chkPurchDBkHistory1: TCheckBox
          Left = 328
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 6
          OnClick = chkChangedClick
        end
        object chkPurchDBkHistory2: TCheckBox
          Left = 328
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 7
          OnClick = chkChangedClick
        end
        object chkPurchDBkOrders1: TCheckBox
          Left = 432
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 8
          OnClick = chkChangedClick
        end
        object chkPurchDBkOrders2: TCheckBox
          Left = 432
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 9
          OnClick = chkChangedClick
        end
        object chkPurchDBkOrderHistory1: TCheckBox
          Left = 536
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 10
          OnClick = chkChangedClick
        end
        object chkPurchDBkOrderHistory2: TCheckBox
          Left = 536
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 11
          OnClick = chkChangedClick
        end
        object chkPurchDBkMain3: TCheckBox
          Left = 16
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 12
          OnClick = chkChangedClick
        end
        object chkPurchDBkMain4: TCheckBox
          Left = 16
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 13
          OnClick = chkChangedClick
        end
        object chkPurchDBkQuotes3: TCheckBox
          Left = 120
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 14
          OnClick = chkChangedClick
        end
        object chkPurchDBkQuotes4: TCheckBox
          Left = 120
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 15
          OnClick = chkChangedClick
        end
        object chkPurchDBkAuto3: TCheckBox
          Left = 224
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 16
          OnClick = chkChangedClick
        end
        object chkPurchDBkAuto4: TCheckBox
          Left = 224
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 17
          OnClick = chkChangedClick
        end
        object chkPurchDBkHistory3: TCheckBox
          Left = 328
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 18
          OnClick = chkChangedClick
        end
        object chkPurchDBkHistory4: TCheckBox
          Left = 328
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 19
          OnClick = chkChangedClick
        end
        object chkPurchDBkOrders3: TCheckBox
          Left = 432
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 20
          OnClick = chkChangedClick
        end
        object chkPurchDBkOrders4: TCheckBox
          Left = 432
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 21
          OnClick = chkChangedClick
        end
        object chkPurchDBkOrderHistory3: TCheckBox
          Left = 536
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 22
          OnClick = chkChangedClick
        end
        object chkPurchDBkOrderHistory4: TCheckBox
          Left = 536
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 23
          OnClick = chkChangedClick
        end
        object chkPurchDBkMain5: TCheckBox
          Left = 16
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 24
          OnClick = chkChangedClick
        end
        object chkPurchDBkMain6: TCheckBox
          Left = 16
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 25
          OnClick = chkChangedClick
        end
        object chkPurchDBkQuotes5: TCheckBox
          Left = 120
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 26
          OnClick = chkChangedClick
        end
        object chkPurchDBkQuotes6: TCheckBox
          Left = 120
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 27
          OnClick = chkChangedClick
        end
        object chkPurchDBkAuto5: TCheckBox
          Left = 224
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 28
          OnClick = chkChangedClick
        end
        object chkPurchDBkAuto6: TCheckBox
          Left = 224
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 29
          OnClick = chkChangedClick
        end
        object chkPurchDBkHistory5: TCheckBox
          Left = 328
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 30
          OnClick = chkChangedClick
        end
        object chkPurchDBkHistory6: TCheckBox
          Left = 328
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 31
          OnClick = chkChangedClick
        end
        object chkPurchDBkOrders5: TCheckBox
          Left = 432
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 32
          OnClick = chkChangedClick
        end
        object chkPurchDBkOrders6: TCheckBox
          Left = 432
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 33
          OnClick = chkChangedClick
        end
        object chkPurchDBkOrderHistory5: TCheckBox
          Left = 536
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 34
          OnClick = chkChangedClick
        end
        object chkPurchDBkOrderHistory6: TCheckBox
          Left = 536
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 35
          OnClick = chkChangedClick
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 336
        Width = 633
        Height = 145
        Caption = ' Nominal Daybook '
        TabOrder = 2
        object Label13: TLabel
          Left = 7
          Top = 19
          Width = 22
          Height = 14
          Caption = 'Main'
        end
        object Bevel11: TBevel
          Left = 208
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object Label14: TLabel
          Left = 219
          Top = 19
          Width = 23
          Height = 14
          Caption = 'Auto'
        end
        object Bevel12: TBevel
          Left = 312
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object Label15: TLabel
          Left = 319
          Top = 19
          Width = 34
          Height = 14
          Caption = 'History'
        end
        object Bevel40: TBevel
          Left = 416
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object Bevel41: TBevel
          Left = 104
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object Bevel42: TBevel
          Left = 520
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object btnNomToggleDaybookMain: TSpeedButton
          Left = 72
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnNomToggleDaybookMainClick
        end
        object btnNomToggleDaybookAuto: TSpeedButton
          Left = 280
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnNomToggleDaybookAutoClick
        end
        object btnNomToggleDaybookHist: TSpeedButton
          Left = 384
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnNomToggleDaybookHistClick
        end
        object chkNomDBkMain1: TCheckBox
          Left = 16
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 0
          OnClick = chkChangedClick
        end
        object chkNomDBkMain2: TCheckBox
          Left = 16
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 1
          OnClick = chkChangedClick
        end
        object chkNomDBkAuto1: TCheckBox
          Left = 224
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 2
          OnClick = chkChangedClick
        end
        object chkNomDBkAuto2: TCheckBox
          Left = 224
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 3
          OnClick = chkChangedClick
        end
        object chkNomDBkHistory1: TCheckBox
          Left = 328
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 4
          OnClick = chkChangedClick
        end
        object chkNomDBkHistory2: TCheckBox
          Left = 328
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 5
          OnClick = chkChangedClick
        end
        object chkNomDBkMain3: TCheckBox
          Left = 16
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 6
          OnClick = chkChangedClick
        end
        object chkNomDBkMain4: TCheckBox
          Left = 16
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 7
          OnClick = chkChangedClick
        end
        object chkNomDBkAuto3: TCheckBox
          Left = 224
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 8
          OnClick = chkChangedClick
        end
        object chkNomDBkAuto4: TCheckBox
          Left = 224
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 9
          OnClick = chkChangedClick
        end
        object chkNomDBkHistory3: TCheckBox
          Left = 328
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 10
          OnClick = chkChangedClick
        end
        object chkNomDBkHistory4: TCheckBox
          Left = 328
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 11
          OnClick = chkChangedClick
        end
        object chkNomDBkMain5: TCheckBox
          Left = 16
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 12
          OnClick = chkChangedClick
        end
        object chkNomDBkMain6: TCheckBox
          Left = 16
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 13
          OnClick = chkChangedClick
        end
        object chkNomDBkAuto5: TCheckBox
          Left = 224
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 14
          OnClick = chkChangedClick
        end
        object chkNomDBkAuto6: TCheckBox
          Left = 224
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 15
          OnClick = chkChangedClick
        end
        object chkNomDBkHistory5: TCheckBox
          Left = 328
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 16
          OnClick = chkChangedClick
        end
        object chkNomDBkHistory6: TCheckBox
          Left = 328
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 17
          OnClick = chkChangedClick
        end
      end
      object btnToggleAllDaybook: TButton
        Left = 8
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Toggle All'
        TabOrder = 3
        OnClick = btnToggleAllDaybookClick
      end
      object btnRandomDaybook: TButton
        Left = 88
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Random'
        TabOrder = 4
        OnClick = btnRandomDaybookClick
      end
      object btnDbkAllOff: TButton
        Left = 168
        Top = 0
        Width = 75
        Height = 25
        Caption = 'All Off'
        TabOrder = 5
        OnClick = btnDbkAllOffClick
      end
      object GroupBoxWorDaybook: TGroupBox
        Left = 8
        Top = 488
        Width = 633
        Height = 145
        Caption = 'Works Order Daybook '
        TabOrder = 6
        object Label53: TLabel
          Left = 7
          Top = 19
          Width = 22
          Height = 14
          Caption = 'Main'
        end
        object Bevel44: TBevel
          Left = 208
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object Bevel48: TBevel
          Left = 312
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object Label55: TLabel
          Left = 319
          Top = 19
          Width = 34
          Height = 14
          Caption = 'History'
        end
        object Bevel49: TBevel
          Left = 416
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object Bevel50: TBevel
          Left = 104
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object Bevel51: TBevel
          Left = 520
          Top = 24
          Width = 12
          Height = 114
          Shape = bsLeftLine
        end
        object btnWORToggleDaybookMain: TSpeedButton
          Left = 72
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnWORToggleDaybookMainClick
        end
        object btnWORToggleDaybookHist: TSpeedButton
          Left = 384
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnWORToggleDaybookHistClick
        end
        object chkWORDbkMain1: TCheckBox
          Left = 16
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 0
          OnClick = chkChangedClick
        end
        object chkWORDbkMain2: TCheckBox
          Left = 16
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 1
          OnClick = chkChangedClick
        end
        object chkWORDbkHistory1: TCheckBox
          Left = 328
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 2
          OnClick = chkChangedClick
        end
        object chkWORDbkHistory2: TCheckBox
          Left = 328
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 3
          OnClick = chkChangedClick
        end
        object chkWORDbkMain3: TCheckBox
          Left = 16
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 4
          OnClick = chkChangedClick
        end
        object chkWORDbkMain4: TCheckBox
          Left = 16
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 5
          OnClick = chkChangedClick
        end
        object chkWORDbkHistory3: TCheckBox
          Left = 328
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 6
          OnClick = chkChangedClick
        end
        object chkWORDbkHistory4: TCheckBox
          Left = 328
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 7
          OnClick = chkChangedClick
        end
        object chkWORDbkMain5: TCheckBox
          Left = 16
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 8
          OnClick = chkChangedClick
        end
        object chkWORDbkMain6: TCheckBox
          Left = 16
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 9
          OnClick = chkChangedClick
        end
        object chkWORDbkHistory5: TCheckBox
          Left = 328
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 10
          OnClick = chkChangedClick
        end
        object chkWORDbkHistory6: TCheckBox
          Left = 328
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 11
          OnClick = chkChangedClick
        end
      end
    end
    object jobdbk2uSheet: TTabSheet
      Caption = 'Job Daybook'
      ImageIndex = 4
      object GroupBox9: TGroupBox
        Left = 8
        Top = 32
        Width = 521
        Height = 289
        Caption = 'Job Daybook '
        TabOrder = 0
        object Label22: TLabel
          Left = 7
          Top = 19
          Width = 61
          Height = 14
          Caption = 'Job Pre-Post'
        end
        object Bevel17: TBevel
          Left = 104
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label23: TLabel
          Left = 115
          Top = 19
          Width = 55
          Height = 14
          Caption = 'Timesheets'
        end
        object Bevel18: TBevel
          Left = 208
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label24: TLabel
          Left = 215
          Top = 19
          Width = 57
          Height = 14
          Caption = 'T/sheet Hist'
        end
        object Bevel19: TBevel
          Left = 312
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label25: TLabel
          Left = 322
          Top = 19
          Width = 56
          Height = 14
          Caption = 'Purch Apps'
        end
        object Bevel20: TBevel
          Left = 416
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label26: TLabel
          Left = 422
          Top = 19
          Width = 59
          Height = 14
          Caption = 'Pur App Hist'
        end
        object Label27: TLabel
          Left = 7
          Top = 155
          Width = 55
          Height = 14
          Caption = 'Sales Apps'
        end
        object Bevel21: TBevel
          Left = 104
          Top = 160
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label28: TLabel
          Left = 115
          Top = 155
          Width = 58
          Height = 14
          Caption = 'Sls App Hist'
        end
        object Bevel22: TBevel
          Left = 208
          Top = 160
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label29: TLabel
          Left = 215
          Top = 155
          Width = 52
          Height = 14
          Caption = 'P/L Retent.'
        end
        object Bevel23: TBevel
          Left = 312
          Top = 160
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label30: TLabel
          Left = 322
          Top = 155
          Width = 53
          Height = 14
          Caption = 'S/L Retent.'
        end
        object Bevel24: TBevel
          Left = 416
          Top = 160
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object btnToggleJobDbkPrepost: TSpeedButton
          Left = 72
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleJobDbkPrepostClick
        end
        object btnToggleJobDbkTimesheets: TSpeedButton
          Left = 176
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleJobDbkTimesheetsClick
        end
        object btnToggleJobDbkTSheetHist: TSpeedButton
          Left = 280
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleJobDbkTSheetHistClick
        end
        object btnToggleJobDbkPurchApps: TSpeedButton
          Left = 384
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleJobDbkPurchAppsClick
        end
        object btnToggleJobDbkPurchAppHist: TSpeedButton
          Left = 488
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleJobDbkPurchAppHistClick
        end
        object btnToggleJobDbkSalesApps: TSpeedButton
          Left = 72
          Top = 152
          Width = 23
          Height = 22
          OnClick = btnToggleJobDbkSalesAppsClick
        end
        object btnToggleJobDbkSalesAppHist: TSpeedButton
          Left = 176
          Top = 152
          Width = 23
          Height = 22
          OnClick = btnToggleJobDbkSalesAppHistClick
        end
        object btnToggleJobDbkPLRetent: TSpeedButton
          Left = 280
          Top = 152
          Width = 23
          Height = 22
          OnClick = btnToggleJobDbkPLRetentClick
        end
        object btnToggleJobDbkSLRetent: TSpeedButton
          Left = 384
          Top = 152
          Width = 23
          Height = 22
          OnClick = btnToggleJobDbkSLRetentClick
        end
        object chkJobTimesheets1: TCheckBox
          Left = 120
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 0
          OnClick = chkChangedClick
        end
        object chkJobTimesheets2: TCheckBox
          Left = 120
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 1
          OnClick = chkChangedClick
        end
        object chkJobTimesheetHist1: TCheckBox
          Left = 224
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 2
          OnClick = chkChangedClick
        end
        object chkJobTimesheetHist2: TCheckBox
          Left = 224
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 3
          OnClick = chkChangedClick
        end
        object chkJobPurchApps1: TCheckBox
          Left = 328
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 4
          OnClick = chkChangedClick
        end
        object chkJobPurchApps2: TCheckBox
          Left = 328
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 5
          OnClick = chkChangedClick
        end
        object chkJobPurchAppHist1: TCheckBox
          Left = 432
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 6
          OnClick = chkChangedClick
        end
        object chkJobPurchAppHist2: TCheckBox
          Left = 432
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 7
          OnClick = chkChangedClick
        end
        object chkJobPrePost1: TCheckBox
          Left = 16
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 8
          OnClick = chkChangedClick
        end
        object chkJobPrePost2: TCheckBox
          Left = 16
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 9
          OnClick = chkChangedClick
        end
        object chkJobTimesheets3: TCheckBox
          Left = 120
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 10
          OnClick = chkChangedClick
        end
        object chkJobTimesheets4: TCheckBox
          Left = 120
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 11
          OnClick = chkChangedClick
        end
        object chkJobTimesheetHist3: TCheckBox
          Left = 224
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 12
          OnClick = chkChangedClick
        end
        object chkJobTimesheetHist4: TCheckBox
          Left = 224
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 13
          OnClick = chkChangedClick
        end
        object chkJobPurchApps3: TCheckBox
          Left = 328
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 14
          OnClick = chkChangedClick
        end
        object chkJobPurchApps4: TCheckBox
          Left = 328
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 15
          OnClick = chkChangedClick
        end
        object chkJobPurchAppHist3: TCheckBox
          Left = 432
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 16
          OnClick = chkChangedClick
        end
        object chkJobPurchAppHist4: TCheckBox
          Left = 432
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 17
          OnClick = chkChangedClick
        end
        object chkJobPrePost3: TCheckBox
          Left = 16
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 18
          OnClick = chkChangedClick
        end
        object chkJobPrePost4: TCheckBox
          Left = 16
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 19
          OnClick = chkChangedClick
        end
        object chkJobTimesheets5: TCheckBox
          Left = 120
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 20
          OnClick = chkChangedClick
        end
        object chkJobTimesheets6: TCheckBox
          Left = 120
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 21
          OnClick = chkChangedClick
        end
        object chkJobTimesheetHist5: TCheckBox
          Left = 224
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 22
          OnClick = chkChangedClick
        end
        object chkJobTimesheetHist6: TCheckBox
          Left = 224
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 23
          OnClick = chkChangedClick
        end
        object chkJobPurchApps5: TCheckBox
          Left = 328
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 24
          OnClick = chkChangedClick
        end
        object chkJobPurchApps6: TCheckBox
          Left = 328
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 25
          OnClick = chkChangedClick
        end
        object chkJobPurchAppHist5: TCheckBox
          Left = 432
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 26
          OnClick = chkChangedClick
        end
        object chkJobPurchAppHist6: TCheckBox
          Left = 432
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 27
          OnClick = chkChangedClick
        end
        object chkJobPrePost5: TCheckBox
          Left = 16
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 28
          OnClick = chkChangedClick
        end
        object chkJobPrePost6: TCheckBox
          Left = 16
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 29
          OnClick = chkChangedClick
        end
        object chkJobSalesAppHist1: TCheckBox
          Left = 120
          Top = 176
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 30
          OnClick = chkChangedClick
        end
        object chkJobSalesAppHist2: TCheckBox
          Left = 120
          Top = 192
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 31
          OnClick = chkChangedClick
        end
        object chkJobPLRetentions1: TCheckBox
          Left = 224
          Top = 176
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 32
          OnClick = chkChangedClick
        end
        object chkJobPLRetentions2: TCheckBox
          Left = 224
          Top = 192
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 33
          OnClick = chkChangedClick
        end
        object chkJobSLRetentions1: TCheckBox
          Left = 328
          Top = 176
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 34
          OnClick = chkChangedClick
        end
        object chkJobSLRetentions2: TCheckBox
          Left = 328
          Top = 192
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 35
          OnClick = chkChangedClick
        end
        object chkJobSalesApps1: TCheckBox
          Left = 16
          Top = 176
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 36
          OnClick = chkChangedClick
        end
        object chkJobSalesApps2: TCheckBox
          Left = 16
          Top = 192
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 37
          OnClick = chkChangedClick
        end
        object chkJobSalesAppHist3: TCheckBox
          Left = 120
          Top = 208
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 38
          OnClick = chkChangedClick
        end
        object chkJobSalesAppHist4: TCheckBox
          Left = 120
          Top = 224
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 39
          OnClick = chkChangedClick
        end
        object chkJobPLRetentions3: TCheckBox
          Left = 224
          Top = 208
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 40
          OnClick = chkChangedClick
        end
        object chkJobPLRetentions4: TCheckBox
          Left = 224
          Top = 224
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 41
          OnClick = chkChangedClick
        end
        object chkJobSLRetentions3: TCheckBox
          Left = 328
          Top = 208
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 42
          OnClick = chkChangedClick
        end
        object chkJobSLRetentions4: TCheckBox
          Left = 328
          Top = 224
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 43
          OnClick = chkChangedClick
        end
        object chkJobSalesApps3: TCheckBox
          Left = 16
          Top = 208
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 44
          OnClick = chkChangedClick
        end
        object chkJobSalesApps4: TCheckBox
          Left = 16
          Top = 224
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 45
          OnClick = chkChangedClick
        end
        object chkJobSalesAppHist5: TCheckBox
          Left = 120
          Top = 240
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 46
          OnClick = chkChangedClick
        end
        object chkJobSalesAppHist6: TCheckBox
          Left = 120
          Top = 256
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 47
          OnClick = chkChangedClick
        end
        object chkJobPLRetentions5: TCheckBox
          Left = 224
          Top = 240
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 48
          OnClick = chkChangedClick
        end
        object chkJobPLRetentions6: TCheckBox
          Left = 224
          Top = 256
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 49
          OnClick = chkChangedClick
        end
        object chkJobSLRetentions5: TCheckBox
          Left = 328
          Top = 240
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 50
          OnClick = chkChangedClick
        end
        object chkJobSLRetentions6: TCheckBox
          Left = 328
          Top = 256
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 51
          OnClick = chkChangedClick
        end
        object chkJobSalesApps5: TCheckBox
          Left = 16
          Top = 240
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 52
          OnClick = chkChangedClick
        end
        object chkJobSalesApps6: TCheckBox
          Left = 16
          Top = 256
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 53
          OnClick = chkChangedClick
        end
      end
      object btnToggleJobDaybook: TButton
        Left = 8
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Toggle All'
        TabOrder = 1
        OnClick = btnToggleJobDaybookClick
      end
      object btnRandomJobDbk: TButton
        Left = 88
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Random'
        TabOrder = 2
        OnClick = btnRandomJobDbkClick
      end
      object btnJobDbkAllOff: TButton
        Left = 168
        Top = 0
        Width = 75
        Height = 25
        Caption = 'All Off'
        TabOrder = 3
        OnClick = btnJobDbkAllOffClick
      end
    end
    object stockuSheet: TTabSheet
      Caption = 'Stock'
      ImageIndex = 5
      object GroupBox10: TGroupBox
        Left = 8
        Top = 32
        Width = 625
        Height = 425
        Caption = 'Stock '
        TabOrder = 0
        object Label31: TLabel
          Left = 7
          Top = 19
          Width = 22
          Height = 14
          Caption = 'Main'
        end
        object Bevel25: TBevel
          Left = 104
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label32: TLabel
          Left = 115
          Top = 19
          Width = 40
          Height = 14
          Caption = 'Defaults'
        end
        object Bevel26: TBevel
          Left = 208
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label33: TLabel
          Left = 215
          Top = 19
          Width = 45
          Height = 14
          Caption = 'VAT/Web'
        end
        object Bevel27: TBevel
          Left = 312
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label34: TLabel
          Left = 322
          Top = 19
          Width = 24
          Height = 14
          Caption = 'WOP'
        end
        object Bevel28: TBevel
          Left = 416
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label35: TLabel
          Left = 422
          Top = 19
          Width = 38
          Height = 14
          Caption = 'Returns'
        end
        object Label36: TLabel
          Left = 7
          Top = 155
          Width = 54
          Height = 14
          Caption = 'Qty Breaks'
        end
        object Bevel29: TBevel
          Left = 104
          Top = 160
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label37: TLabel
          Left = 115
          Top = 155
          Width = 45
          Height = 14
          Caption = 'Multi Disc'
        end
        object Bevel30: TBevel
          Left = 208
          Top = 160
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label38: TLabel
          Left = 215
          Top = 155
          Width = 34
          Height = 14
          Caption = 'Ledger'
        end
        object Bevel31: TBevel
          Left = 312
          Top = 160
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label39: TLabel
          Left = 322
          Top = 155
          Width = 27
          Height = 14
          Caption = 'Value'
        end
        object Bevel32: TBevel
          Left = 416
          Top = 160
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Bevel33: TBevel
          Left = 520
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label40: TLabel
          Left = 526
          Top = 19
          Width = 28
          Height = 14
          Caption = 'Notes'
        end
        object Label41: TLabel
          Left = 423
          Top = 155
          Width = 23
          Height = 14
          Caption = 'Build'
        end
        object Bevel34: TBevel
          Left = 520
          Top = 160
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label42: TLabel
          Left = 530
          Top = 155
          Width = 27
          Height = 14
          Caption = 'Serial'
          Enabled = False
        end
        object Label43: TLabel
          Left = 7
          Top = 291
          Width = 21
          Height = 14
          Caption = 'Bins'
          Enabled = False
        end
        object Bevel35: TBevel
          Left = 104
          Top = 296
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Bevel36: TBevel
          Left = 208
          Top = 296
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Bevel37: TBevel
          Left = 312
          Top = 296
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Bevel38: TBevel
          Left = 416
          Top = 296
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Bevel39: TBevel
          Left = 520
          Top = 296
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object btnToggleStockMain: TSpeedButton
          Left = 72
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleStockMainClick
        end
        object btnToggleStockDefs: TSpeedButton
          Left = 176
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleStockDefsClick
        end
        object btnToggleStockVatWeb: TSpeedButton
          Left = 280
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleStockVatWebClick
        end
        object btnToggleStockWOP: TSpeedButton
          Left = 384
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleStockWOPClick
        end
        object btnToggleStockReturns: TSpeedButton
          Left = 488
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleStockReturnsClick
        end
        object btnToggleStockNotes: TSpeedButton
          Left = 592
          Top = 16
          Width = 23
          Height = 22
          Visible = False
          OnClick = btnToggleStockNotesClick
        end
        object btnToggleStockQtyBreaks: TSpeedButton
          Left = 72
          Top = 152
          Width = 23
          Height = 22
          OnClick = btnToggleStockQtyBreaksClick
        end
        object btnToggleStockMultiBuy: TSpeedButton
          Left = 176
          Top = 152
          Width = 23
          Height = 22
          OnClick = btnToggleStockMultiBuyClick
        end
        object btnToggleStockLedger: TSpeedButton
          Left = 280
          Top = 152
          Width = 23
          Height = 22
          OnClick = btnToggleStockLedgerClick
        end
        object btnToggleStockValue: TSpeedButton
          Left = 384
          Top = 152
          Width = 23
          Height = 22
          OnClick = btnToggleStockValueClick
        end
        object btnToggleStockBuild: TSpeedButton
          Left = 488
          Top = 152
          Width = 23
          Height = 22
          OnClick = btnToggleStockBuildClick
        end
        object btnToggleStockSerial: TSpeedButton
          Left = 592
          Top = 152
          Width = 23
          Height = 22
          Enabled = False
          OnClick = btnToggleStockSerialClick
        end
        object btnToggleStockBins: TSpeedButton
          Left = 72
          Top = 288
          Width = 23
          Height = 22
          Enabled = False
          OnClick = btnToggleStockBinsClick
        end
        object Label52: TLabel
          Left = 528
          Top = 40
          Width = 85
          Height = 42
          Caption = 'No custom buttons on Notes tab'
          WordWrap = True
        end
        object chkStockNotes3: TCheckBox
          Left = 536
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 56
          Visible = False
          OnClick = chkChangedClick
        end
        object chkStockNotes2: TCheckBox
          Left = 536
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 55
          Visible = False
          OnClick = chkChangedClick
        end
        object chkStockNotes1: TCheckBox
          Left = 536
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 54
          Visible = False
          OnClick = chkChangedClick
        end
        object chkStockDefaults1: TCheckBox
          Left = 120
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 0
          OnClick = chkChangedClick
        end
        object chkStockDefaults2: TCheckBox
          Left = 120
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 1
          OnClick = chkChangedClick
        end
        object chkStockVATWeb1: TCheckBox
          Left = 224
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 2
          OnClick = chkChangedClick
        end
        object chkStockVATWeb2: TCheckBox
          Left = 224
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 3
          OnClick = chkChangedClick
        end
        object chkStockWOP1: TCheckBox
          Left = 328
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 4
          OnClick = chkChangedClick
        end
        object chkStockWOP2: TCheckBox
          Left = 328
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 5
          OnClick = chkChangedClick
        end
        object chkStockReturns1: TCheckBox
          Left = 432
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 6
          OnClick = chkChangedClick
        end
        object chkStockReturns2: TCheckBox
          Left = 432
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 7
          OnClick = chkChangedClick
        end
        object chkStockMain1: TCheckBox
          Left = 16
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 8
          OnClick = chkChangedClick
        end
        object chkStockMain2: TCheckBox
          Left = 16
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 9
          OnClick = chkChangedClick
        end
        object chkStockDefaults3: TCheckBox
          Left = 120
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 10
          OnClick = chkChangedClick
        end
        object chkStockDefaults4: TCheckBox
          Left = 120
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 11
          OnClick = chkChangedClick
        end
        object chkStockVATWeb3: TCheckBox
          Left = 224
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 12
          OnClick = chkChangedClick
        end
        object chkStockVATWeb4: TCheckBox
          Left = 224
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 13
          OnClick = chkChangedClick
        end
        object chkStockWOP3: TCheckBox
          Left = 328
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 14
          OnClick = chkChangedClick
        end
        object chkStockWOP4: TCheckBox
          Left = 328
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 15
          OnClick = chkChangedClick
        end
        object chkStockReturns3: TCheckBox
          Left = 432
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 16
          OnClick = chkChangedClick
        end
        object chkStockReturns4: TCheckBox
          Left = 432
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 17
          OnClick = chkChangedClick
        end
        object chkStockMain3: TCheckBox
          Left = 16
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 18
          OnClick = chkChangedClick
        end
        object chkStockMain4: TCheckBox
          Left = 16
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 19
          OnClick = chkChangedClick
        end
        object chkStockDefaults5: TCheckBox
          Left = 120
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 20
          OnClick = chkChangedClick
        end
        object chkStockDefaults6: TCheckBox
          Left = 120
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 21
          OnClick = chkChangedClick
        end
        object chkStockVATWeb5: TCheckBox
          Left = 224
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 22
          OnClick = chkChangedClick
        end
        object chkStockVATWeb6: TCheckBox
          Left = 224
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 23
          OnClick = chkChangedClick
        end
        object chkStockWOP5: TCheckBox
          Left = 328
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 24
          OnClick = chkChangedClick
        end
        object chkStockWOP6: TCheckBox
          Left = 328
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 25
          OnClick = chkChangedClick
        end
        object chkStockReturns5: TCheckBox
          Left = 432
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 26
          OnClick = chkChangedClick
        end
        object chkStockReturns6: TCheckBox
          Left = 432
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 27
          OnClick = chkChangedClick
        end
        object chkStockMain5: TCheckBox
          Left = 16
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 28
          OnClick = chkChangedClick
        end
        object chkStockMain6: TCheckBox
          Left = 16
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 29
          OnClick = chkChangedClick
        end
        object chkStockMBDiscounts1: TCheckBox
          Left = 120
          Top = 176
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 30
          OnClick = chkChangedClick
        end
        object chkStockMBDiscounts2: TCheckBox
          Left = 120
          Top = 192
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 31
          OnClick = chkChangedClick
        end
        object chkStockLedger1: TCheckBox
          Left = 224
          Top = 176
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 32
          OnClick = chkChangedClick
        end
        object chkStockLedger2: TCheckBox
          Left = 224
          Top = 192
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 33
          OnClick = chkChangedClick
        end
        object chkStockValue1: TCheckBox
          Left = 328
          Top = 176
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 34
          OnClick = chkChangedClick
        end
        object chkStockValue2: TCheckBox
          Left = 328
          Top = 192
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 35
          OnClick = chkChangedClick
        end
        object chkStockQtyBreaks1: TCheckBox
          Left = 16
          Top = 176
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 36
          OnClick = chkChangedClick
        end
        object chkStockQtyBreaks2: TCheckBox
          Left = 16
          Top = 192
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 37
          OnClick = chkChangedClick
        end
        object chkStockMBDiscounts3: TCheckBox
          Left = 120
          Top = 208
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 38
          OnClick = chkChangedClick
        end
        object chkStockMBDiscounts4: TCheckBox
          Left = 120
          Top = 224
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 39
          OnClick = chkChangedClick
        end
        object chkStockLedger3: TCheckBox
          Left = 224
          Top = 208
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 40
          OnClick = chkChangedClick
        end
        object chkStockLedger4: TCheckBox
          Left = 224
          Top = 224
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 41
          OnClick = chkChangedClick
        end
        object chkStockValue3: TCheckBox
          Left = 328
          Top = 208
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 42
          OnClick = chkChangedClick
        end
        object chkStockValue4: TCheckBox
          Left = 328
          Top = 224
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 43
          OnClick = chkChangedClick
        end
        object chkStockQtyBreaks3: TCheckBox
          Left = 16
          Top = 208
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 44
          OnClick = chkChangedClick
        end
        object chkStockQtyBreaks4: TCheckBox
          Left = 16
          Top = 224
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 45
          OnClick = chkChangedClick
        end
        object chkStockMBDiscounts5: TCheckBox
          Left = 120
          Top = 240
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 46
          OnClick = chkChangedClick
        end
        object chkStockMBDiscounts6: TCheckBox
          Left = 120
          Top = 256
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 47
          OnClick = chkChangedClick
        end
        object chkStockLedger5: TCheckBox
          Left = 224
          Top = 240
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 48
          OnClick = chkChangedClick
        end
        object chkStockLedger6: TCheckBox
          Left = 224
          Top = 256
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 49
          OnClick = chkChangedClick
        end
        object chkStockValue5: TCheckBox
          Left = 328
          Top = 240
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 50
          OnClick = chkChangedClick
        end
        object chkStockValue6: TCheckBox
          Left = 328
          Top = 256
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 51
          OnClick = chkChangedClick
        end
        object chkStockQtyBreaks5: TCheckBox
          Left = 16
          Top = 240
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 52
          OnClick = chkChangedClick
        end
        object chkStockQtyBreaks6: TCheckBox
          Left = 16
          Top = 256
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 53
          OnClick = chkChangedClick
        end
        object chkStockNotes4: TCheckBox
          Left = 536
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 57
          Visible = False
          OnClick = chkChangedClick
        end
        object chkStockNotes5: TCheckBox
          Left = 536
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 58
          Visible = False
          OnClick = chkChangedClick
        end
        object chkStockNotes6: TCheckBox
          Left = 536
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 59
          Visible = False
          OnClick = chkChangedClick
        end
        object chkStockBuild1: TCheckBox
          Left = 432
          Top = 176
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 60
          OnClick = chkChangedClick
        end
        object chkStockBuild2: TCheckBox
          Left = 432
          Top = 192
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 61
          OnClick = chkChangedClick
        end
        object chkStockSerial1: TCheckBox
          Left = 536
          Top = 176
          Width = 74
          Height = 17
          Caption = 'Button 1'
          Enabled = False
          TabOrder = 62
          OnClick = chkChangedClick
        end
        object chkStockSerial2: TCheckBox
          Left = 536
          Top = 192
          Width = 74
          Height = 17
          Caption = 'Button 2'
          Enabled = False
          TabOrder = 63
          OnClick = chkChangedClick
        end
        object chkStockBuild3: TCheckBox
          Left = 432
          Top = 208
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 64
          OnClick = chkChangedClick
        end
        object chkStockBuild4: TCheckBox
          Left = 432
          Top = 224
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 65
          OnClick = chkChangedClick
        end
        object chkStockSerial3: TCheckBox
          Left = 536
          Top = 208
          Width = 74
          Height = 17
          Caption = 'Button 3'
          Enabled = False
          TabOrder = 66
          OnClick = chkChangedClick
        end
        object chkStockSerial4: TCheckBox
          Left = 536
          Top = 224
          Width = 74
          Height = 17
          Caption = 'Button 4'
          Enabled = False
          TabOrder = 67
          OnClick = chkChangedClick
        end
        object chkStockBuild5: TCheckBox
          Left = 432
          Top = 240
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 68
          OnClick = chkChangedClick
        end
        object chkStockBuild6: TCheckBox
          Left = 432
          Top = 256
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 69
          OnClick = chkChangedClick
        end
        object chkStockSerial5: TCheckBox
          Left = 536
          Top = 240
          Width = 74
          Height = 17
          Caption = 'Button 5'
          Enabled = False
          TabOrder = 70
          OnClick = chkChangedClick
        end
        object chkStockSerial6: TCheckBox
          Left = 536
          Top = 256
          Width = 74
          Height = 17
          Caption = 'Button 6'
          Enabled = False
          TabOrder = 71
          OnClick = chkChangedClick
        end
        object chkStockBins1: TCheckBox
          Left = 16
          Top = 312
          Width = 74
          Height = 17
          Caption = 'Button 1'
          Enabled = False
          TabOrder = 72
          OnClick = chkChangedClick
        end
        object chkStockBins2: TCheckBox
          Left = 16
          Top = 328
          Width = 74
          Height = 17
          Caption = 'Button 2'
          Enabled = False
          TabOrder = 73
          OnClick = chkChangedClick
        end
        object chkStockBins3: TCheckBox
          Left = 16
          Top = 344
          Width = 74
          Height = 17
          Caption = 'Button 3'
          Enabled = False
          TabOrder = 74
          OnClick = chkChangedClick
        end
        object chkStockBins4: TCheckBox
          Left = 16
          Top = 360
          Width = 74
          Height = 17
          Caption = 'Button 4'
          Enabled = False
          TabOrder = 75
          OnClick = chkChangedClick
        end
        object chkStockBins5: TCheckBox
          Left = 16
          Top = 376
          Width = 74
          Height = 17
          Caption = 'Button 5'
          Enabled = False
          TabOrder = 76
          OnClick = chkChangedClick
        end
        object chkStockBins6: TCheckBox
          Left = 16
          Top = 392
          Width = 74
          Height = 17
          Caption = 'Button 6'
          Enabled = False
          TabOrder = 77
          OnClick = chkChangedClick
        end
      end
      object btnToggleStock: TButton
        Left = 8
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Toggle All'
        TabOrder = 1
        OnClick = btnToggleStockClick
      end
      object btnRandomStock: TButton
        Left = 88
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Random'
        TabOrder = 2
        OnClick = btnRandomStockClick
      end
      object btnStockAllOff: TButton
        Left = 168
        Top = 0
        Width = 75
        Height = 25
        Caption = 'All Off'
        TabOrder = 3
        OnClick = btnStockAllOffClick
      end
    end
    object saletx2uSheet: TTabSheet
      Caption = 'Sales'
      ImageIndex = 6
      object GroupBox11: TGroupBox
        Left = 8
        Top = 32
        Width = 209
        Height = 273
        Caption = 'Sales/Purchases Record'
        TabOrder = 0
        object Label44: TLabel
          Left = 7
          Top = 19
          Width = 27
          Height = 14
          Caption = 'Sales'
        end
        object Bevel43: TBevel
          Left = 104
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label45: TLabel
          Left = 11
          Top = 147
          Width = 46
          Height = 14
          Caption = 'Purchase'
        end
        object Label46: TLabel
          Left = 111
          Top = 19
          Width = 56
          Height = 14
          Caption = 'Sales View'
        end
        object Bevel45: TBevel
          Left = 104
          Top = 152
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label47: TLabel
          Left = 114
          Top = 147
          Width = 57
          Height = 14
          Caption = 'Purch View'
        end
        object btnToggleSalesSales: TSpeedButton
          Left = 72
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleSalesSalesClick
        end
        object btnToggleSalesPurch: TSpeedButton
          Left = 72
          Top = 144
          Width = 23
          Height = 22
          OnClick = btnToggleSalesPurchClick
        end
        object btnToggleSalesSalesView: TSpeedButton
          Left = 176
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleSalesSalesViewClick
        end
        object btnToggleSalesPurchView: TSpeedButton
          Left = 176
          Top = 144
          Width = 23
          Height = 22
          OnClick = btnToggleSalesPurchViewClick
        end
        object chkPurchEdit1: TCheckBox
          Left = 16
          Top = 168
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 0
          OnClick = chkChangedClick
        end
        object chkPurchEdit2: TCheckBox
          Left = 16
          Top = 184
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 1
          OnClick = chkChangedClick
        end
        object chkSalesView1: TCheckBox
          Left = 120
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 2
          OnClick = chkChangedClick
        end
        object chkSalesView2: TCheckBox
          Left = 120
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 3
          OnClick = chkChangedClick
        end
        object chkPurchView1: TCheckBox
          Left = 120
          Top = 168
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 4
          OnClick = chkChangedClick
        end
        object chkPurchView2: TCheckBox
          Left = 120
          Top = 184
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 5
          OnClick = chkChangedClick
        end
        object chkSalesEdit1: TCheckBox
          Left = 16
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 6
          OnClick = chkChangedClick
        end
        object chkSalesEdit2: TCheckBox
          Left = 16
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 7
          OnClick = chkChangedClick
        end
        object chkPurchEdit3: TCheckBox
          Left = 16
          Top = 200
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 8
          OnClick = chkChangedClick
        end
        object chkPurchEdit4: TCheckBox
          Left = 16
          Top = 216
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 9
          OnClick = chkChangedClick
        end
        object chkSalesView3: TCheckBox
          Left = 120
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 10
          OnClick = chkChangedClick
        end
        object chkSalesView4: TCheckBox
          Left = 120
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 11
          OnClick = chkChangedClick
        end
        object chkPurchView3: TCheckBox
          Left = 120
          Top = 200
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 12
          OnClick = chkChangedClick
        end
        object chkPurchView4: TCheckBox
          Left = 120
          Top = 216
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 13
          OnClick = chkChangedClick
        end
        object chkSalesEdit3: TCheckBox
          Left = 16
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 14
          OnClick = chkChangedClick
        end
        object chkSalesEdit4: TCheckBox
          Left = 16
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 15
          OnClick = chkChangedClick
        end
        object chkPurchEdit5: TCheckBox
          Left = 16
          Top = 232
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 16
          OnClick = chkChangedClick
        end
        object chkPurchEdit6: TCheckBox
          Left = 16
          Top = 248
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 17
          OnClick = chkChangedClick
        end
        object chkSalesView5: TCheckBox
          Left = 120
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 18
          OnClick = chkChangedClick
        end
        object chkSalesView6: TCheckBox
          Left = 120
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 19
          OnClick = chkChangedClick
        end
        object chkPurchView5: TCheckBox
          Left = 120
          Top = 232
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 20
          OnClick = chkChangedClick
        end
        object chkPurchView6: TCheckBox
          Left = 120
          Top = 248
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 21
          OnClick = chkChangedClick
        end
        object chkSalesEdit5: TCheckBox
          Left = 16
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 22
          OnClick = chkChangedClick
        end
        object chkSalesEdit6: TCheckBox
          Left = 16
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 23
          OnClick = chkChangedClick
        end
      end
      object btnToggleSales: TButton
        Left = 8
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Toggle All'
        TabOrder = 1
        OnClick = btnToggleSalesClick
      end
      object btnRandomSales: TButton
        Left = 88
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Random'
        TabOrder = 2
        OnClick = btnRandomSalesClick
      end
      object btnSalesAllOff: TButton
        Left = 168
        Top = 0
        Width = 75
        Height = 25
        Caption = 'All Off'
        TabOrder = 3
        OnClick = btnSalesAllOffClick
      end
    end
    object stkdjuSheet: TTabSheet
      Caption = 'Stock Adjust'
      ImageIndex = 7
      object GroupBox12: TGroupBox
        Left = 8
        Top = 32
        Width = 209
        Height = 145
        Caption = 'Stock Adjust'
        TabOrder = 0
        object Label48: TLabel
          Left = 7
          Top = 19
          Width = 53
          Height = 14
          Caption = 'Stk Adj Edit'
        end
        object Bevel46: TBevel
          Left = 104
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label49: TLabel
          Left = 115
          Top = 19
          Width = 54
          Height = 14
          Caption = 'Stk Adj Vw'
        end
        object btnToggleStkAdjEdit: TSpeedButton
          Left = 72
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleStkAdjEditClick
        end
        object btnToggleStkAdjView: TSpeedButton
          Left = 176
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleStkAdjViewClick
        end
        object chkStockView1: TCheckBox
          Left = 120
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 0
          OnClick = chkChangedClick
        end
        object chkStockView2: TCheckBox
          Left = 120
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 1
          OnClick = chkChangedClick
        end
        object chkStockEdit1: TCheckBox
          Left = 16
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 2
          OnClick = chkChangedClick
        end
        object chkStockEdit2: TCheckBox
          Left = 16
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 3
          OnClick = chkChangedClick
        end
        object chkStockView3: TCheckBox
          Left = 120
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 4
          OnClick = chkChangedClick
        end
        object chkStockView4: TCheckBox
          Left = 120
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 5
          OnClick = chkChangedClick
        end
        object chkStockEdit3: TCheckBox
          Left = 16
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 6
          OnClick = chkChangedClick
        end
        object chkStockEdit4: TCheckBox
          Left = 16
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 7
          OnClick = chkChangedClick
        end
        object chkStockView5: TCheckBox
          Left = 120
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 8
          OnClick = chkChangedClick
        end
        object chkStockView6: TCheckBox
          Left = 120
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 9
          OnClick = chkChangedClick
        end
        object chkStockEdit5: TCheckBox
          Left = 16
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 10
          OnClick = chkChangedClick
        end
        object chkStockEdit6: TCheckBox
          Left = 16
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 11
          OnClick = chkChangedClick
        end
      end
      object btnToggleStockAdjust: TButton
        Left = 8
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Toggle All'
        TabOrder = 1
        OnClick = btnToggleStockAdjustClick
      end
      object btnRandomStkAdj: TButton
        Left = 88
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Random'
        TabOrder = 2
        OnClick = btnRandomStkAdjClick
      end
      object btnStkAdjAllOff: TButton
        Left = 168
        Top = 0
        Width = 75
        Height = 25
        Caption = 'All Off'
        TabOrder = 3
        OnClick = btnStkAdjAllOffClick
      end
    end
    object wordoc2uSheet: TTabSheet
      Caption = 'Works Order'
      ImageIndex = 8
      object GroupBox13: TGroupBox
        Left = 8
        Top = 32
        Width = 209
        Height = 145
        Caption = 'Works Order'
        TabOrder = 0
        object Label50: TLabel
          Left = 7
          Top = 19
          Width = 45
          Height = 14
          Caption = 'WOR Edit'
        end
        object Bevel47: TBevel
          Left = 104
          Top = 24
          Width = 12
          Height = 113
          Shape = bsLeftLine
        end
        object Label51: TLabel
          Left = 115
          Top = 19
          Width = 54
          Height = 14
          Caption = 'WOR View'
        end
        object btnToggleWOREdit: TSpeedButton
          Left = 72
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleWOREditClick
        end
        object btnToggleWORView: TSpeedButton
          Left = 176
          Top = 16
          Width = 23
          Height = 22
          OnClick = btnToggleWORViewClick
        end
        object chkWORView1: TCheckBox
          Left = 120
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 0
          OnClick = chkChangedClick
        end
        object chkWORView2: TCheckBox
          Left = 120
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 1
          OnClick = chkChangedClick
        end
        object chkWOREdit1: TCheckBox
          Left = 16
          Top = 40
          Width = 74
          Height = 17
          Caption = 'Button 1'
          TabOrder = 2
          OnClick = chkChangedClick
        end
        object chkWOREdit2: TCheckBox
          Left = 16
          Top = 56
          Width = 74
          Height = 17
          Caption = 'Button 2'
          TabOrder = 3
          OnClick = chkChangedClick
        end
        object chkWORView3: TCheckBox
          Left = 120
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 4
          OnClick = chkChangedClick
        end
        object chkWORView4: TCheckBox
          Left = 120
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 5
          OnClick = chkChangedClick
        end
        object chkWOREdit3: TCheckBox
          Left = 16
          Top = 72
          Width = 74
          Height = 17
          Caption = 'Button 3'
          TabOrder = 6
          OnClick = chkChangedClick
        end
        object chkWOREdit4: TCheckBox
          Left = 16
          Top = 88
          Width = 74
          Height = 17
          Caption = 'Button 4'
          TabOrder = 7
          OnClick = chkChangedClick
        end
        object chkWORView5: TCheckBox
          Left = 120
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 8
          OnClick = chkChangedClick
        end
        object chkWORView6: TCheckBox
          Left = 120
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 9
          OnClick = chkChangedClick
        end
        object chkWOREdit5: TCheckBox
          Left = 16
          Top = 104
          Width = 74
          Height = 17
          Caption = 'Button 5'
          TabOrder = 10
          OnClick = chkChangedClick
        end
        object chkWOREdit6: TCheckBox
          Left = 16
          Top = 120
          Width = 74
          Height = 17
          Caption = 'Button 6'
          TabOrder = 11
          OnClick = chkChangedClick
        end
      end
      object btnToggleWOR: TButton
        Left = 8
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Toggle All'
        TabOrder = 1
        OnClick = btnToggleWORClick
      end
      object btnRandomWOR: TButton
        Left = 88
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Random'
        TabOrder = 2
        OnClick = btnRandomWORClick
      end
      object btnWORAllOff: TButton
        Left = 168
        Top = 0
        Width = 75
        Height = 25
        Caption = 'All Off'
        TabOrder = 3
        OnClick = btnWORAllOffClick
      end
    end
  end
  object controlPanel: TPanel
    Left = 0
    Top = 0
    Width = 654
    Height = 33
    Align = alTop
    TabOrder = 1
    object Label16: TLabel
      Left = 168
      Top = 8
      Width = 228
      Height = 16
      Caption = '<== Click here to apply the changes'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBtnFace
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object btnSetHookPointStatus: TButton
      Left = 8
      Top = 2
      Width = 153
      Height = 25
      Caption = 'Set Hook Point Status'
      TabOrder = 0
      OnClick = btnSetHookPointStatusClick
    end
    object btnToggleEverything: TButton
      Left = 544
      Top = 2
      Width = 99
      Height = 25
      Caption = 'Toggle Everything'
      TabOrder = 1
      OnClick = btnToggleEverythingClick
    end
  end
end
