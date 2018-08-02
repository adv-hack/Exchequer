object FrmSetup: TFrmSetup
  Left = 293
  Top = 174
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'EPOS Setup'
  ClientHeight = 382
  ClientWidth = 353
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
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object pcSetup: TPageControl
    Left = 8
    Top = 8
    Width = 337
    Height = 337
    ActivePage = tsGeneral
    MultiLine = True
    TabIndex = 0
    TabOrder = 0
    OnChange = pcSetupChange
    object tsGeneral: TTabSheet
      HelpContext = 18
      Caption = 'General'
      object Bevel6: TBevel
        Left = 8
        Top = 8
        Width = 313
        Height = 273
        Shape = bsFrame
      end
      object lTillCurrency: TLabel
        Left = 24
        Top = 60
        Width = 66
        Height = 14
        Caption = 'Till Currency :'
      end
      object Label7: TLabel
        Left = 24
        Top = 106
        Width = 132
        Height = 14
        Caption = 'Cash Only Customer Type :'
      end
      object Label21: TLabel
        Left = 24
        Top = 28
        Width = 51
        Height = 14
        Caption = 'Company :'
      end
      object Bevel16: TBevel
        Left = 8
        Top = 184
        Width = 313
        Height = 97
        Shape = bsFrame
      end
      object Label31: TLabel
        Left = 24
        Top = 192
        Width = 71
        Height = 14
        Caption = 'Discounting :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel24: TBevel
        Left = 8
        Top = 88
        Width = 313
        Height = 98
        Shape = bsFrame
      end
      object cmbCurrency: TComboBox
        Left = 96
        Top = 56
        Width = 209
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 1
        OnChange = SetChanged
      end
      object edCashCustType: TEdit
        Left = 160
        Top = 102
        Width = 145
        Height = 22
        MaxLength = 4
        TabOrder = 2
        OnChange = SetChanged
      end
      object cmbCompany: TComboBox
        Left = 96
        Top = 26
        Width = 209
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 0
        OnChange = cmbCompanyChange
      end
      object rbEntDiscounts: TRadioButton
        Left = 48
        Top = 240
        Width = 225
        Height = 17
        Caption = 'Use and Modify Exchequer Discounts'
        TabOrder = 5
        OnClick = SetChanged
      end
      object rbTCMDiscounts: TRadioButton
        Left = 48
        Top = 216
        Width = 225
        Height = 17
        Caption = 'TCM Extra Discounting (additional)'
        Checked = True
        TabOrder = 4
        TabStop = True
        OnClick = SetChanged
      end
      object cbDepositsOnCashCust: TCheckBox
        Left = 24
        Top = 134
        Width = 257
        Height = 17
        Caption = 'Allow Cash Only customers to leave deposits ?'
        TabOrder = 3
        OnClick = SetChanged
      end
      object cbAllowWriteOffs4CashCust: TCheckBox
        Left = 24
        Top = 158
        Width = 265
        Height = 17
        Caption = 'Allow Cash Only customers to write off amounts ?'
        TabOrder = 6
        OnClick = SetChanged
      end
    end
    object tsOperational: TTabSheet
      HelpContext = 21
      Caption = 'Operational'
      ImageIndex = 7
      object Bevel15: TBevel
        Left = 8
        Top = 8
        Width = 313
        Height = 273
        Shape = bsFrame
      end
      object Bevel10: TBevel
        Left = 8
        Top = 144
        Width = 313
        Height = 74
        Shape = bsFrame
      end
      object Label1: TLabel
        Left = 24
        Top = 152
        Width = 132
        Height = 14
        Caption = 'After Tender, return to :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel9: TBevel
        Left = 8
        Top = 216
        Width = 313
        Height = 65
        Shape = bsFrame
      end
      object Label22: TLabel
        Left = 48
        Top = 248
        Width = 101
        Height = 14
        Caption = 'Round up / down to :'
      end
      object cbAutoAddLine: TCheckBox
        Left = 24
        Top = 20
        Width = 177
        Height = 17
        Caption = 'Automatically Repeat Add Line ?'
        TabOrder = 0
        OnClick = SetChanged
      end
      object cbModifyVATRate: TCheckBox
        Left = 24
        Top = 44
        Width = 241
        Height = 15
        Caption = 'Allow modify VAT rate on a transaction line ?'
        TabOrder = 1
        OnClick = SetChanged
      end
      object rbAFLogin: TRadioButton
        Left = 48
        Top = 172
        Width = 89
        Height = 17
        Caption = 'Login Screen'
        TabOrder = 2
        OnClick = SetChanged
      end
      object rbAFNewTX: TRadioButton
        Left = 48
        Top = 192
        Width = 113
        Height = 17
        Caption = 'New Transaction'
        Checked = True
        TabOrder = 3
        TabStop = True
        OnClick = SetChanged
      end
      object cbRoundChange: TCheckBox
        Left = 24
        Top = 226
        Width = 97
        Height = 17
        Caption = 'Round Change'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = SetChanged
      end
      object edRoundto: TCurrencyEdit
        Left = 160
        Top = 243
        Width = 57
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'ARIAL'
        Font.Style = []
        Lines.Strings = (
          '0.00 ')
        ParentFont = False
        TabOrder = 5
        WantReturns = False
        WordWrap = False
        OnChange = SetChanged
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object cbKeepOrigLayawayDate: TCheckBox
        Left = 24
        Top = 68
        Width = 233
        Height = 17
        Caption = 'Keep original Layaway date ?'
        TabOrder = 6
        OnClick = SetChanged
      end
      object cbCashback: TCheckBox
        Left = 24
        Top = 92
        Width = 233
        Height = 17
        Caption = 'Cashback when overpaying other MOPs ?'
        TabOrder = 7
        OnClick = SetChanged
      end
      object cbDeliveryAddress: TCheckBox
        Left = 24
        Top = 116
        Width = 294
        Height = 17
        Caption = 'Get Delivery Address from Customer Delivery Address ?'
        TabOrder = 8
        OnClick = SetChanged
      end
    end
    object tsPrinting: TTabSheet
      Caption = 'Printing'
      ImageIndex = 4
      object pcPrinting: TPageControl
        Left = 4
        Top = 7
        Width = 325
        Height = 282
        ActivePage = TabSheet6
        Style = tsButtons
        TabIndex = 0
        TabOrder = 0
        object TabSheet6: TTabSheet
          Caption = 'Receipts'
          ImageIndex = 4
          object Bevel14: TBevel
            Left = 0
            Top = 16
            Width = 313
            Height = 230
            Shape = bsFrame
          end
          object Label13: TLabel
            Left = 16
            Top = 88
            Width = 30
            Height = 14
            Caption = 'Form :'
          end
          object Label14: TLabel
            Left = 8
            Top = 8
            Width = 87
            Height = 14
            Caption = 'Receipt Printing'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label15: TLabel
            Left = 16
            Top = 40
            Width = 37
            Height = 14
            Caption = 'Printer :'
          end
          object Label24: TLabel
            Left = 16
            Top = 136
            Width = 34
            Height = 14
            Caption = 'Paper :'
          end
          object Label25: TLabel
            Left = 16
            Top = 184
            Width = 21
            Height = 14
            Caption = 'Bin :'
          end
          object edReceiptForm: TEdit
            Left = 16
            Top = 104
            Width = 225
            Height = 22
            MaxLength = 8
            TabOrder = 1
            OnChange = SetChanged
          end
          object btnBrowse1: TButton
            Left = 240
            Top = 104
            Width = 56
            Height = 20
            Caption = 'Browse'
            TabOrder = 2
            OnClick = btnBrowseForForm
          end
          object cmbReceiptPrinter: TComboBox
            Left = 16
            Top = 56
            Width = 281
            Height = 22
            Style = csDropDownList
            ItemHeight = 14
            TabOrder = 0
            OnChange = SetChanged
            OnClick = cmbPrinterClick
          end
          object cmbRecPrintPaper: TComboBox
            Left = 16
            Top = 152
            Width = 281
            Height = 22
            Style = csDropDownList
            ItemHeight = 14
            TabOrder = 3
            OnChange = SetChanged
          end
          object cmbRecPrintBin: TComboBox
            Left = 16
            Top = 200
            Width = 281
            Height = 22
            Style = csDropDownList
            ItemHeight = 14
            TabOrder = 4
            OnChange = SetChanged
          end
        end
        object TabSheet5: TTabSheet
          Caption = 'Invoices'
          ImageIndex = 1
          object Bevel5: TBevel
            Left = 0
            Top = 16
            Width = 313
            Height = 230
            Shape = bsFrame
          end
          object Label16: TLabel
            Left = 8
            Top = 8
            Width = 85
            Height = 14
            Caption = 'Invoice Printing'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label17: TLabel
            Left = 16
            Top = 40
            Width = 37
            Height = 14
            Caption = 'Printer :'
          end
          object Label23: TLabel
            Left = 16
            Top = 88
            Width = 30
            Height = 14
            Caption = 'Form :'
          end
          object Label26: TLabel
            Left = 16
            Top = 136
            Width = 34
            Height = 14
            Caption = 'Paper :'
          end
          object Label2: TLabel
            Left = 16
            Top = 184
            Width = 21
            Height = 14
            Caption = 'Bin :'
          end
          object edInvoiceForm: TEdit
            Left = 16
            Top = 104
            Width = 225
            Height = 22
            MaxLength = 8
            TabOrder = 1
            OnChange = SetChanged
          end
          object cmbInvPrintPaper: TComboBox
            Left = 16
            Top = 152
            Width = 281
            Height = 22
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 3
            OnChange = SetChanged
          end
          object cmbInvPrintBin: TComboBox
            Left = 16
            Top = 200
            Width = 281
            Height = 22
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 4
            OnChange = SetChanged
          end
          object cmbInvoicePrinter: TComboBox
            Left = 16
            Top = 56
            Width = 281
            Height = 22
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 0
            OnChange = SetChanged
            OnClick = cmbPrinterClick
          end
          object btnBrowse2: TButton
            Left = 240
            Top = 104
            Width = 56
            Height = 20
            Caption = 'Browse'
            TabOrder = 2
            OnClick = btnBrowseForForm
          end
        end
        object TabSheet7: TTabSheet
          Caption = 'Orders'
          ImageIndex = 2
          object Bevel2: TBevel
            Left = 0
            Top = 16
            Width = 313
            Height = 230
            Shape = bsFrame
          end
          object Label5: TLabel
            Left = 8
            Top = 8
            Width = 78
            Height = 14
            Caption = 'Order Printing'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label8: TLabel
            Left = 16
            Top = 40
            Width = 37
            Height = 14
            Caption = 'Printer :'
          end
          object Label10: TLabel
            Left = 16
            Top = 88
            Width = 30
            Height = 14
            Caption = 'Form :'
          end
          object Label11: TLabel
            Left = 16
            Top = 136
            Width = 34
            Height = 14
            Caption = 'Paper :'
          end
          object Label28: TLabel
            Left = 16
            Top = 184
            Width = 21
            Height = 14
            Caption = 'Bin :'
          end
          object cmbOrderPrinter: TComboBox
            Left = 16
            Top = 56
            Width = 281
            Height = 22
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 0
            OnChange = SetChanged
            OnClick = cmbPrinterClick
          end
          object btnBrowse3: TButton
            Left = 240
            Top = 104
            Width = 56
            Height = 20
            Caption = 'Browse'
            TabOrder = 2
            OnClick = btnBrowseForForm
          end
          object edOrderForm: TEdit
            Left = 16
            Top = 104
            Width = 225
            Height = 22
            MaxLength = 8
            TabOrder = 1
            OnChange = SetChanged
          end
          object cmbOrderPaper: TComboBox
            Left = 16
            Top = 152
            Width = 281
            Height = 22
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 3
            OnChange = SetChanged
          end
          object cmbOrderBin: TComboBox
            Left = 16
            Top = 200
            Width = 281
            Height = 22
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 4
            OnChange = SetChanged
          end
        end
      end
    end
    object tsTransactions: TTabSheet
      Caption = 'Transactions'
      ImageIndex = 6
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 329
        Height = 209
        BevelOuter = bvNone
        TabOrder = 0
        object Bevel3: TBevel
          Left = 8
          Top = 16
          Width = 313
          Height = 186
          Shape = bsFrame
        end
        object Bevel23: TBevel
          Left = 8
          Top = 96
          Width = 313
          Height = 106
          Shape = bsFrame
        end
        object Label29: TLabel
          Left = 16
          Top = 8
          Width = 114
          Height = 14
          Caption = 'Normal Transactions'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label39: TLabel
          Left = 16
          Top = 88
          Width = 74
          Height = 14
          Caption = 'Tag Numbers'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object rbSINs: TRadioButton
          Left = 40
          Top = 27
          Width = 129
          Height = 17
          Caption = 'Create SINs and SRIs'
          TabOrder = 0
          OnClick = rbSINsClick
        end
        object rbPickedSORs: TRadioButton
          Left = 40
          Top = 47
          Width = 121
          Height = 17
          Caption = 'Create Picked SORs'
          TabOrder = 1
          OnClick = rbSINsClick
        end
        object rbUnpickedSORs: TRadioButton
          Left = 40
          Top = 67
          Width = 129
          Height = 17
          Caption = 'Create Unpicked SORs'
          TabOrder = 2
          OnClick = rbSINsClick
        end
        object Panel3: TPanel
          Left = 16
          Top = 104
          Width = 273
          Height = 89
          BevelOuter = bvNone
          TabOrder = 3
          object lSORTagNo: TLabel
            Left = 24
            Top = 6
            Width = 77
            Height = 14
            Caption = 'Default Tag No :'
          end
          object edSORTagNo: TEdit
            Left = 104
            Top = 2
            Width = 121
            Height = 22
            MaxLength = 2
            TabOrder = 0
            Text = 'edSORTagNo'
            OnChange = SetChanged
          end
          object rbDefTag: TRadioButton
            Left = 24
            Top = 32
            Width = 185
            Height = 17
            Caption = 'Only Use Default Tag No'
            Checked = True
            TabOrder = 1
            TabStop = True
            OnClick = SetChanged
          end
          object rbCustTag: TRadioButton
            Left = 24
            Top = 52
            Width = 185
            Height = 17
            Caption = 'Only Use Customer Tag No'
            TabOrder = 2
            OnClick = SetChanged
          end
          object rbCustDefTag: TRadioButton
            Left = 24
            Top = 72
            Width = 249
            Height = 17
            Caption = 'Use Customer Tag, if zero then use Default'
            TabOrder = 3
            OnClick = SetChanged
          end
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 208
        Width = 329
        Height = 81
        BevelOuter = bvNone
        TabOrder = 1
        object Bevel4: TBevel
          Left = 8
          Top = 16
          Width = 313
          Height = 57
          Shape = bsFrame
        end
        object Label30: TLabel
          Left = 16
          Top = 8
          Width = 122
          Height = 14
          Caption = 'Negative Transactions'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object rbNegSRFs: TRadioButton
          Left = 40
          Top = 46
          Width = 137
          Height = 17
          Caption = 'Create SRFs and SCRs'
          TabOrder = 1
          OnClick = SetChanged
        end
        object rbNegSINs: TRadioButton
          Left = 40
          Top = 26
          Width = 137
          Height = 17
          Caption = 'Create SINs and SRIs'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = SetChanged
        end
      end
    end
    object tsNominals: TTabSheet
      Caption = 'G/L Codes'
      ImageIndex = 3
      object Bevel7: TBevel
        Left = 8
        Top = 16
        Width = 313
        Height = 252
        Shape = bsFrame
      end
      object Label4: TLabel
        Left = 16
        Top = 40
        Width = 123
        Height = 14
        Caption = 'Cash Payment G/L Code :'
      end
      object Label6: TLabel
        Left = 16
        Top = 124
        Width = 135
        Height = 14
        Caption = 'Cheque Payment G/L Code :'
      end
      object Label12: TLabel
        Left = 16
        Top = 212
        Width = 139
        Height = 14
        Caption = 'Write-Off Amount G/L Code :'
      end
      object lCashGLDesc: TLabel
        Left = 16
        Top = 68
        Width = 138
        Height = 14
        Caption = '                                              '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lChequeGLDesc: TLabel
        Left = 16
        Top = 152
        Width = 138
        Height = 14
        Caption = '                                              '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lWriteOffGLDesc: TLabel
        Left = 16
        Top = 240
        Width = 138
        Height = 14
        Caption = '                                              '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel11: TBevel
        Left = 16
        Top = 98
        Width = 297
        Height = 2
      end
      object Bevel12: TBevel
        Left = 16
        Top = 186
        Width = 297
        Height = 2
      end
      object edCashNom: TEdit
        Tag = 1
        Left = 160
        Top = 36
        Width = 145
        Height = 22
        MaxLength = 10
        TabOrder = 0
        OnChange = SetChanged
        OnExit = NominalExit
      end
      object edChequeNom: TEdit
        Tag = 2
        Left = 160
        Top = 120
        Width = 145
        Height = 22
        MaxLength = 10
        TabOrder = 1
        OnChange = SetChanged
        OnExit = NominalExit
      end
      object edWriteOffNom: TEdit
        Tag = 3
        Left = 161
        Top = 207
        Width = 144
        Height = 22
        MaxLength = 10
        TabOrder = 2
        OnChange = SetChanged
        OnExit = NominalExit
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Defaults'
      ImageIndex = 1
      object Bevel18: TBevel
        Left = 8
        Top = 200
        Width = 313
        Height = 81
        Shape = bsFrame
      end
      object Bevel17: TBevel
        Left = 8
        Top = 16
        Width = 313
        Height = 73
        Shape = bsFrame
      end
      object lStockLoc: TLabel
        Left = 24
        Top = 220
        Width = 77
        Height = 14
        Caption = 'Stock Location :'
      end
      object Bevel1: TBevel
        Left = 8
        Top = 104
        Width = 313
        Height = 81
        Shape = bsFrame
      end
      object Label9: TLabel
        Left = 16
        Top = 96
        Width = 46
        Height = 14
        Caption = 'Intrastat'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lDelTerms: TLabel
        Left = 21
        Top = 121
        Width = 78
        Height = 14
        Caption = 'Delivery Terms :'
      end
      object lMOT: TLabel
        Left = 21
        Top = 153
        Width = 95
        Height = 14
        Caption = 'Mode of Transport :'
      end
      object Label32: TLabel
        Left = 16
        Top = 192
        Width = 31
        Height = 14
        Caption = 'Stock'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label33: TLabel
        Left = 16
        Top = 8
        Width = 104
        Height = 14
        Caption = 'Customer Account'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lAccCode: TLabel
        Left = 21
        Top = 60
        Width = 75
        Height = 14
        Caption = 'Account Code :'
      end
      object edStockLocation: TEdit
        Left = 120
        Top = 216
        Width = 89
        Height = 22
        MaxLength = 6
        TabOrder = 4
        OnChange = SetChanged
        OnExit = edStockLocationExit
      end
      object cmbDeliveryTerms: TComboBox
        Left = 120
        Top = 117
        Width = 185
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 2
        OnChange = SetChanged
        Items.Strings = (
          'EXW (Ex Works)'
          'FOB (Free on board)'
          'CIF (Cost/Insurance/Freight)'
          'DDU (Delivered Domicile)'
          'DDP (Delivered Domicile)'
          'XXX (Other)')
      end
      object cmbModeOfTrans: TComboBox
        Left = 120
        Top = 149
        Width = 185
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 3
        OnChange = SetChanged
        Items.Strings = (
          '1 (Sea)'
          '2 (Rail)'
          '3 (Road)'
          '4 (Air)'
          '5 (Post)'
          '6 (Not Allocated)'
          '7 (Fixed Installation)'
          '8 (Inland waterway)'
          '9 (Own propulsion)')
      end
      object cbUseDefaultAcc: TCheckBox
        Left = 24
        Top = 32
        Width = 177
        Height = 17
        Caption = 'Use Customer Account Default'
        TabOrder = 0
        OnClick = cbUseDefaultAccClick
      end
      object edAccCode: TEdit
        Left = 120
        Top = 56
        Width = 89
        Height = 22
        MaxLength = 6
        TabOrder = 1
        OnChange = SetChanged
        OnExit = edAccCodeExit
      end
      object cbFilterSerialByLoc: TCheckBox
        Left = 24
        Top = 250
        Width = 177
        Height = 17
        Caption = 'Filter serial numbers by location'
        TabOrder = 5
        OnClick = SetChanged
      end
    end
    object tsCashDrawer: TTabSheet
      Caption = 'Cash Drawer'
      ImageIndex = 2
      object Bevel8: TBevel
        Left = 8
        Top = 8
        Width = 313
        Height = 273
        Shape = bsFrame
      end
      object Label18: TLabel
        Left = 24
        Top = 28
        Width = 118
        Height = 14
        Caption = 'Kick-out Escape Codes :'
      end
      object Label19: TLabel
        Left = 24
        Top = 60
        Width = 85
        Height = 14
        Caption = 'Send Kick-out to :'
      end
      object Label38: TLabel
        Left = 24
        Top = 92
        Width = 56
        Height = 14
        Caption = 'Baud Rate :'
      end
      object Bevel25: TBevel
        Left = 8
        Top = 160
        Width = 313
        Height = 121
        Shape = bsFrame
      end
      object cbOpenDrawerOnCash: TCheckBox
        Left = 40
        Top = 176
        Width = 217
        Height = 17
        Caption = 'Open Cash Drawer On Cash Sales'
        TabOrder = 4
        OnClick = SetChanged
      end
      object cbOpenDrawerOnCard: TCheckBox
        Left = 40
        Top = 200
        Width = 217
        Height = 17
        Caption = 'Open Cash Drawer On Card Sales'
        TabOrder = 5
        OnClick = SetChanged
      end
      object cbOpenDrawerOnCheque: TCheckBox
        Left = 40
        Top = 224
        Width = 217
        Height = 17
        Caption = 'Open Cash Drawer On Cheque Sales'
        TabOrder = 6
        OnClick = SetChanged
      end
      object cbOpenDrawerOnAccount: TCheckBox
        Left = 40
        Top = 248
        Width = 217
        Height = 17
        Caption = 'Open Cash Drawer On Account Sales'
        TabOrder = 7
        OnClick = SetChanged
      end
      object edKickOutCodes: TEdit
        Left = 152
        Top = 24
        Width = 153
        Height = 22
        TabOrder = 0
        OnChange = SetChanged
      end
      object cmbCashDrawerCOM: TComboBox
        Left = 152
        Top = 56
        Width = 153
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 1
        OnChange = SetChanged
        Items.Strings = (
          'COM 1'
          'COM 2'
          'COM 3'
          'COM 4'
          'COM 5'
          'COM 6'
          'COM 7'
          'COM 8')
      end
      object btnTestKick: TButton
        Left = 152
        Top = 120
        Width = 153
        Height = 25
        Caption = 'Test Kick-Out'
        TabOrder = 3
        OnClick = btnTestKickClick
      end
      object cmbBaudRate: TComboBox
        Left = 152
        Top = 88
        Width = 153
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 2
        OnChange = SetChanged
        Items.Strings = (
          '9600'
          '19200'
          '38400'
          '57600'
          '115200')
      end
    end
    object tsCreditCards: TTabSheet
      Caption = 'Credit Cards'
      ImageIndex = 5
      object lvCards: TListView
        Left = 8
        Top = 8
        Width = 225
        Height = 273
        Columns = <
          item
            Caption = 'No'
            Width = 25
          end
          item
            Caption = 'Card Type'
            Width = 112
          end
          item
            Caption = 'GL Code'
            Width = 60
          end>
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lvCardsChange
        OnDblClick = btnEditCardClick
      end
      object btnEditCard: TButton
        Left = 240
        Top = 256
        Width = 81
        Height = 25
        Caption = 'Edit'
        TabOrder = 1
        OnClick = btnEditCardClick
      end
    end
    object tsNonStock: TTabSheet
      Caption = 'Non-Stock'
      ImageIndex = 8
      object Bevel13: TBevel
        Left = 8
        Top = 16
        Width = 313
        Height = 265
        Shape = bsFrame
      end
      object ldefGLCode: TLabel
        Left = 56
        Top = 67
        Width = 88
        Height = 14
        Caption = 'Default G/L Code :'
      end
      object lNonStockGLDesc: TLabel
        Left = 56
        Top = 96
        Width = 138
        Height = 14
        Caption = '                                              '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lDefVATCode: TLabel
        Left = 56
        Top = 139
        Width = 90
        Height = 14
        Caption = 'Default VAT Rate :'
      end
      object lStockItem: TLabel
        Left = 56
        Top = 227
        Width = 55
        Height = 14
        Caption = 'Stock Item :'
      end
      object Bevel19: TBevel
        Left = 38
        Top = 40
        Width = 2
        Height = 109
      end
      object Bevel20: TBevel
        Left = 38
        Top = 199
        Width = 2
        Height = 38
      end
      object Label20: TLabel
        Left = 16
        Top = 8
        Width = 165
        Height = 14
        Caption = 'When adding Non-Stock items'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edNonStockNom: TEdit
        Tag = 4
        Left = 152
        Top = 64
        Width = 153
        Height = 22
        MaxLength = 10
        TabOrder = 0
        OnChange = SetChanged
        OnExit = NominalExit
      end
      object rbUseDefaults: TRadioButton
        Left = 32
        Top = 32
        Width = 129
        Height = 17
        Caption = 'Use These Defaults :'
        TabOrder = 1
        OnClick = rbUseDefaultsClick
      end
      object rbDefaultFromStockItem: TRadioButton
        Left = 32
        Top = 192
        Width = 177
        Height = 17
        Caption = 'Take Defaults from Stock Item'
        TabOrder = 2
        OnClick = rbUseDefaultsClick
      end
      object edNonStockItem: TEdit
        Tag = 4
        Left = 120
        Top = 224
        Width = 185
        Height = 22
        MaxLength = 16
        TabOrder = 3
        OnChange = SetChanged
        OnExit = edNonStockItemExit
      end
      object cmbVATRate: TComboBox
        Left = 152
        Top = 136
        Width = 153
        Height = 22
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 4
        OnChange = SetChanged
      end
    end
    object tsCCDept: TTabSheet
      Caption = 'CC / Dept'
      ImageIndex = 9
      object Bevel22: TBevel
        Left = 8
        Top = 16
        Width = 313
        Height = 89
        Shape = bsFrame
      end
      object Bevel21: TBevel
        Left = 8
        Top = 128
        Width = 313
        Height = 153
        Shape = bsFrame
      end
      object Label34: TLabel
        Left = 16
        Top = 120
        Width = 141
        Height = 14
        Caption = 'For each transaction line :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label35: TLabel
        Left = 56
        Top = 35
        Width = 63
        Height = 14
        Caption = 'Cost Centre :'
      end
      object Label36: TLabel
        Left = 56
        Top = 71
        Width = 61
        Height = 14
        Caption = 'Department :'
      end
      object Label37: TLabel
        Left = 16
        Top = 8
        Width = 45
        Height = 14
        Caption = 'Defaults'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object rbCCDefaults: TRadioButton
        Left = 56
        Top = 240
        Width = 129
        Height = 17
        Caption = 'Use The Defaults'
        TabOrder = 4
        OnClick = SetChanged
      end
      object rbCCEnterprise: TRadioButton
        Left = 56
        Top = 200
        Width = 177
        Height = 17
        Caption = 'Use Exchequer rules to assign'
        TabOrder = 3
        OnClick = SetChanged
      end
      object edCC: TEdit
        Tag = 4
        Left = 128
        Top = 32
        Width = 153
        Height = 22
        MaxLength = 10
        TabOrder = 0
        OnChange = SetChanged
        OnExit = edCCExit
      end
      object edDept: TEdit
        Tag = 4
        Left = 128
        Top = 68
        Width = 153
        Height = 22
        MaxLength = 10
        TabOrder = 1
        OnChange = SetChanged
        OnExit = edDeptExit
      end
      object rbCCCustomer: TRadioButton
        Left = 56
        Top = 160
        Width = 161
        Height = 17
        Caption = 'Get from customer defaults'
        TabOrder = 2
        OnClick = SetChanged
      end
    end
  end
  object btnClose: TButton
    Left = 264
    Top = 352
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object btnSave: TButton
    Left = 176
    Top = 352
    Width = 80
    Height = 21
    Caption = '&Save'
    Enabled = False
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object OpenDialog1: TOpenDialog
    Options = [ofReadOnly, ofHideReadOnly, ofNoChangeDir, ofFileMustExist, ofNoNetworkButton, ofEnableSizing]
    Left = 8
    Top = 352
  end
end
