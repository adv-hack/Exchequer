object frmSystemSetup: TfrmSystemSetup
  Left = 139
  Top = 163
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = 'eBusiness System Setup - v7.0.7.155'
  ClientHeight = 411
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  HelpFile = 'Ebus.chm'
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000010000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000000000000000000000000000000000000000000000000000BB
    B50000000000000000000000000000000BBB5560000000000000000000000000
    0000BB55566600000000000000000000000000BBB55566600000000000000088
    88888888BBB5556668888800000000777777777777BBB555666778000000007F
    FFFFFFF78888BBB5556668000000007F77CFFFF787777BBB555666000000007F
    7FFFFFF787FFFFFBBB5556600000007F77CFFFF787777777BBB555660000007F
    7FFFFFF787FFF77777BBB5566000007F77CFFFF787777777777BBB556600007F
    7FFFFFF787FFF7777778BBB55660007F7F779FF78777777777787BBB5560007F
    7F7FFFF787FFFFFFFF7878BBB566007F7F77CFF787777777777878BBB556007F
    7F7FFFF7877788888888780BBB56007F77BFFFF7877787787778780BBBB5007F
    7FFFFFF78888888888887800BBB5007F77CFFFF77777777777777800BBB0007F
    FFFFFFF7474477777777786BBBB0007777777777777777777777785BBB000444
    4444444444444444444444BBBB0004444444444444444444444444BB00000000
    0000000000000000BBBBB0000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFC3FFFFFFF81FFFFFFF00FFFFFFC01FFF8000003F8000003F8000
    003F8000003F8000001F8000000F800000078000000380000001800000018000
    0000800000008000002080000020800000308000003180000001800000038000
    00038000000FFFFFF07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = EditKeyDown
  OnKeyPress = EditKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object panSettings: TPanel
    Left = 216
    Top = 8
    Width = 297
    Height = 393
    BevelOuter = bvLowered
    TabOrder = 1
    object nbSettings: TNotebook
      Left = 1
      Top = 1
      Width = 295
      Height = 391
      Align = alClient
      PageIndex = 1
      TabOrder = 0
      OnPageChanged = nbSettingsPageChanged
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgBlank'
        object Label50: TLabel
          Left = 8
          Top = 8
          Width = 83
          Height = 14
          Caption = 'Global Settings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object panGlobal: TPanel
          Left = 1
          Top = 24
          Width = 293
          Height = 97
          BevelOuter = bvNone
          Enabled = False
          TabOrder = 0
          object Label32: TLabel
            Left = 12
            Top = 15
            Width = 116
            Height = 14
            Caption = 'Check for Imports every'
          end
          object Label33: TLabel
            Left = 180
            Top = 15
            Width = 58
            Height = 14
            Caption = '(Mins:Secs)'
          end
          object Label58: TLabel
            Left = 67
            Top = 52
            Width = 60
            Height = 14
            Alignment = taRightJustify
            Caption = 'lblPassword'
            Visible = False
          end
          object edEmailFreq: Text8Pt
            Tag = 1
            Left = 133
            Top = 11
            Width = 41
            Height = 22
            HelpContext = 9
            EditMask = '!99:00;0; '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 5
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            Text = '0000'
            OnExit = edEmailFreqExit
            TextId = 0
            ViaSBtn = False
          end
          object edtPassword: TEdit
            Tag = 1
            Left = 133
            Top = 48
            Width = 100
            Height = 22
            CharCase = ecUpperCase
            MaxLength = 12
            PasswordChar = '*'
            TabOrder = 1
            Visible = False
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        HelpContext = 2
        Caption = 'pgCompany'
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 101
          Height = 14
          Caption = 'Company Settings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object pcCompany: TPageControl
          Tag = 1
          Left = 7
          Top = 32
          Width = 281
          Height = 353
          ActivePage = TabSheet2
          TabIndex = 3
          TabOrder = 0
          OnChange = pcCompanyChange
          object tsImportDefaults: TTabSheet
            Caption = '&Import Defaults'
            object panCompImport: TPanel
              Left = 0
              Top = 0
              Width = 273
              Height = 324
              HelpContext = 32
              Align = alClient
              BevelOuter = bvNone
              Enabled = False
              TabOrder = 0
              object lCostCentre: TLabel
                Left = 5
                Top = 20
                Width = 63
                Height = 14
                Alignment = taRightJustify
                Caption = 'Cost Centre :'
              end
              object lDept: TLabel
                Left = 7
                Top = 44
                Width = 61
                Height = 14
                Alignment = taRightJustify
                Caption = 'Department :'
              end
              object lLocation: TLabel
                Left = 21
                Top = 68
                Width = 47
                Height = 14
                Alignment = taRightJustify
                Caption = 'Location :'
              end
              object Label13: TLabel
                Left = 16
                Top = 108
                Width = 52
                Height = 14
                Alignment = taRightJustify
                Caption = 'Customer :'
              end
              object Label14: TLabel
                Left = 23
                Top = 132
                Width = 45
                Height = 14
                Alignment = taRightJustify
                Caption = 'Supplier :'
              end
              object Label15: TLabel
                Left = 14
                Top = 167
                Width = 54
                Height = 14
                Alignment = taRightJustify
                Caption = 'VAT Code :'
              end
              object Label16: TLabel
                Left = 11
                Top = 202
                Width = 57
                Height = 14
                Alignment = taRightJustify
                Caption = 'Purch. G/L :'
              end
              object Label17: TLabel
                Left = 15
                Top = 226
                Width = 53
                Height = 14
                Alignment = taRightJustify
                Caption = 'Sales G/L :'
              end
              object edCostCentre: TEdit
                Left = 72
                Top = 16
                Width = 57
                Height = 22
                CharCase = ecUpperCase
                TabOrder = 0
                OnExit = edCostCentreExit
              end
              object edDepartment: TEdit
                Left = 72
                Top = 40
                Width = 57
                Height = 22
                CharCase = ecUpperCase
                TabOrder = 1
                OnExit = edDepartmentExit
              end
              object edLocation: TEdit
                Left = 72
                Top = 64
                Width = 57
                Height = 22
                CharCase = ecUpperCase
                TabOrder = 2
                OnExit = edLocationExit
              end
              object edCustomer: TEdit
                Left = 72
                Top = 104
                Width = 97
                Height = 22
                CharCase = ecUpperCase
                TabOrder = 3
                OnExit = edCustomerExit
              end
              object edSupplier: TEdit
                Left = 72
                Top = 128
                Width = 97
                Height = 22
                CharCase = ecUpperCase
                TabOrder = 4
                OnExit = edSupplierExit
              end
              object cmbVATCode: TComboBox
                Left = 72
                Top = 163
                Width = 193
                Height = 22
                Style = csDropDownList
                ItemHeight = 0
                TabOrder = 5
              end
              object edPurchNom: TEdit
                Left = 72
                Top = 200
                Width = 97
                Height = 22
                CharCase = ecUpperCase
                MaxLength = 9
                TabOrder = 6
                OnExit = edPurchNomExit
              end
              object edSalesNom: TEdit
                Left = 72
                Top = 224
                Width = 97
                Height = 22
                CharCase = ecUpperCase
                MaxLength = 9
                TabOrder = 7
                OnExit = edPurchNomExit
              end
              object cmbLocOrigin: TComboBox
                Left = 136
                Top = 64
                Width = 129
                Height = 22
                ItemHeight = 14
                TabOrder = 8
                Text = 'Account, Stock, Default'
                Items.Strings = (
                  'Stock then Default'
                  'Stock, Default, Account'
                  'Stock, Account, Default'
                  'Account, Default, Stock'
                  'Account, Stock, Default'
                  'Default only')
              end
            end
          end
          object TabSheet3: TTabSheet
            Caption = '&Text Files'
            ImageIndex = 2
            object panCompTextFiles: TPanel
              Left = 0
              Top = 0
              Width = 273
              Height = 324
              HelpContext = 33
              Align = alClient
              BevelOuter = bvNone
              Enabled = False
              TabOrder = 0
              object Bevel5: TBevel
                Left = 112
                Top = 16
                Width = 155
                Height = 22
              end
              object Bevel6: TBevel
                Left = 112
                Top = 48
                Width = 155
                Height = 22
              end
              object Bevel7: TBevel
                Left = 112
                Top = 80
                Width = 155
                Height = 22
              end
              object Bevel9: TBevel
                Left = 112
                Top = 112
                Width = 155
                Height = 22
              end
              object Label21: TLabel
                Left = 8
                Top = 116
                Width = 101
                Height = 14
                Alignment = taRightJustify
                Caption = 'Invoice Fail Text File :'
              end
              object Label20: TLabel
                Left = 9
                Top = 84
                Width = 100
                Height = 14
                Alignment = taRightJustify
                Caption = 'Invoice OK Text File :'
              end
              object Label19: TLabel
                Left = 14
                Top = 52
                Width = 95
                Height = 14
                Alignment = taRightJustify
                Caption = 'Order Fail Text File :'
              end
              object Label18: TLabel
                Left = 15
                Top = 20
                Width = 94
                Height = 14
                Alignment = taRightJustify
                Caption = 'Order OK Text File :'
              end
              object btnOrderOKTextBrowse: TButton
                Left = 245
                Top = 17
                Width = 21
                Height = 20
                HelpContext = 33
                Caption = '...'
                TabOrder = 1
                TabStop = False
                OnClick = FileBrowse
              end
              object edOrderOKText: TEdit
                Left = 112
                Top = 16
                Width = 134
                Height = 22
                HelpContext = 33
                MaxLength = 12
                TabOrder = 0
              end
              object btnOrderFailTextBrowse: TButton
                Left = 245
                Top = 49
                Width = 21
                Height = 20
                HelpContext = 33
                Caption = '...'
                TabOrder = 3
                TabStop = False
                OnClick = FileBrowse
              end
              object edOrderFailText: TEdit
                Left = 112
                Top = 48
                Width = 134
                Height = 22
                HelpContext = 33
                MaxLength = 12
                TabOrder = 2
              end
              object btnInvoiceOKTextBrowse: TButton
                Left = 245
                Top = 81
                Width = 21
                Height = 20
                HelpContext = 33
                Caption = '...'
                TabOrder = 5
                TabStop = False
                OnClick = FileBrowse
              end
              object edInvoiceOKText: TEdit
                Left = 112
                Top = 80
                Width = 134
                Height = 22
                HelpContext = 33
                MaxLength = 12
                TabOrder = 4
              end
              object btnInvoiceFailTextBrowse: TButton
                Left = 245
                Top = 113
                Width = 21
                Height = 20
                HelpContext = 33
                Caption = '...'
                TabOrder = 7
                TabStop = False
                OnClick = FileBrowse
              end
              object edInvoiceFailText: TEdit
                Left = 112
                Top = 112
                Width = 134
                Height = 22
                HelpContext = 33
                MaxLength = 12
                TabOrder = 6
              end
              object btnEditText: TButton
                Left = 112
                Top = 152
                Width = 155
                Height = 25
                HelpContext = 136
                Caption = 'Edit Text Files'
                TabOrder = 8
                OnClick = btnEditTextClick
              end
            end
          end
          object tsFileLock: TTabSheet
            Caption = 'File Locking'
            ImageIndex = 3
            object PanCompFileLock: TPanel
              Left = 0
              Top = 0
              Width = 273
              Height = 324
              HelpContext = 29
              Align = alClient
              BevelOuter = bvNone
              Enabled = False
              TabOrder = 0
              object Bevel13: TBevel
                Left = 3
                Top = 82
                Width = 267
                Height = 61
                Shape = bsFrame
              end
              object Bevel14: TBevel
                Left = 3
                Top = 154
                Width = 267
                Height = 62
                Shape = bsFrame
              end
              object Bevel15: TBevel
                Left = 3
                Top = 226
                Width = 267
                Height = 62
                Shape = bsFrame
              end
              object Label11: TLabel
                Left = 8
                Top = 74
                Width = 100
                Height = 14
                Caption = 'Stock File Locking'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label12: TLabel
                Left = 8
                Top = 146
                Width = 137
                Height = 14
                Caption = 'Stock Group File Locking'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label35: TLabel
                Left = 8
                Top = 220
                Width = 133
                Height = 14
                Caption = 'Transaction File Locking'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Bevel12: TBevel
                Left = 3
                Top = 10
                Width = 267
                Height = 61
                Shape = bsFrame
              end
              object Label10: TLabel
                Left = 7
                Top = 2
                Width = 125
                Height = 14
                Caption = 'Customer File Locking'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Panel1: TPanel
                Left = 5
                Top = 16
                Width = 263
                Height = 53
                HelpContext = 29
                BevelOuter = bvNone
                TabOrder = 0
                object Label45: TLabel
                  Left = 14
                  Top = 31
                  Width = 51
                  Height = 14
                  Caption = 'File Exists '
                end
                object rbCustLockFile: TRadioButton
                  Left = 4
                  Top = 6
                  Width = 60
                  Height = 17
                  Caption = 'Filename'
                  TabOrder = 0
                  OnClick = rbCustLockFileClick
                end
                object edCustLockFile: TEdit
                  Left = 67
                  Top = 3
                  Width = 81
                  Height = 22
                  MaxLength = 12
                  TabOrder = 1
                end
                object rbCustLockExt: TRadioButton
                  Left = 156
                  Top = 6
                  Width = 64
                  Height = 17
                  Caption = 'Extension'
                  Checked = True
                  TabOrder = 2
                  TabStop = True
                  OnClick = rbCustLockFileClick
                end
                object edCustLockExt: TEdit
                  Left = 225
                  Top = 3
                  Width = 33
                  Height = 22
                  MaxLength = 3
                  TabOrder = 3
                end
                object cmbCustLockType: TComboBox
                  Left = 67
                  Top = 27
                  Width = 191
                  Height = 22
                  Style = csDropDownList
                  ItemHeight = 14
                  TabOrder = 4
                  Items.Strings = (
                    'when creating the export file'
                    'when the export file is created')
                end
              end
              object Panel2: TPanel
                Left = 5
                Top = 88
                Width = 263
                Height = 53
                HelpContext = 29
                BevelOuter = bvNone
                TabOrder = 1
                object Label47: TLabel
                  Left = 14
                  Top = 31
                  Width = 51
                  Height = 14
                  Caption = 'File Exists '
                end
                object rbStockLockFile: TRadioButton
                  Left = 4
                  Top = 5
                  Width = 60
                  Height = 17
                  Caption = 'Filename'
                  TabOrder = 0
                  OnClick = rbCustLockFileClick
                end
                object edStockLockFile: TEdit
                  Left = 67
                  Top = 2
                  Width = 81
                  Height = 22
                  MaxLength = 12
                  TabOrder = 1
                end
                object rbStockLockExt: TRadioButton
                  Left = 156
                  Top = 5
                  Width = 64
                  Height = 17
                  Caption = 'Extension'
                  Checked = True
                  TabOrder = 2
                  TabStop = True
                  OnClick = rbCustLockFileClick
                end
                object edStockLockExt: TEdit
                  Left = 225
                  Top = 2
                  Width = 33
                  Height = 22
                  MaxLength = 3
                  TabOrder = 3
                end
                object cmbStockLockType: TComboBox
                  Left = 67
                  Top = 27
                  Width = 191
                  Height = 22
                  Style = csDropDownList
                  ItemHeight = 14
                  TabOrder = 4
                  Items.Strings = (
                    'when creating the export file'
                    'when the export file is created')
                end
              end
              object Panel3: TPanel
                Left = 5
                Top = 160
                Width = 263
                Height = 54
                HelpContext = 29
                BevelOuter = bvNone
                TabOrder = 2
                object Label48: TLabel
                  Left = 14
                  Top = 31
                  Width = 51
                  Height = 14
                  Caption = 'File Exists '
                end
                object rbSGroupLockFile: TRadioButton
                  Left = 4
                  Top = 6
                  Width = 60
                  Height = 17
                  Caption = 'Filename'
                  TabOrder = 0
                  OnClick = rbCustLockFileClick
                end
                object edSGroupLockFile: TEdit
                  Left = 67
                  Top = 3
                  Width = 81
                  Height = 22
                  MaxLength = 12
                  TabOrder = 1
                end
                object rbSGroupLockExt: TRadioButton
                  Left = 156
                  Top = 6
                  Width = 64
                  Height = 17
                  Caption = 'Extension'
                  Checked = True
                  TabOrder = 2
                  TabStop = True
                  OnClick = rbCustLockFileClick
                end
                object edSGroupLockExt: TEdit
                  Left = 225
                  Top = 3
                  Width = 33
                  Height = 22
                  MaxLength = 3
                  TabOrder = 3
                end
                object cmbSGLockType: TComboBox
                  Left = 67
                  Top = 27
                  Width = 191
                  Height = 22
                  Style = csDropDownList
                  ItemHeight = 14
                  TabOrder = 4
                  Items.Strings = (
                    'when creating the export file'
                    'when the export file is created')
                end
              end
              object Panel4: TPanel
                Left = 5
                Top = 235
                Width = 263
                Height = 46
                HelpContext = 29
                BevelOuter = bvNone
                TabOrder = 3
                object Label49: TLabel
                  Left = 14
                  Top = 28
                  Width = 51
                  Height = 14
                  Caption = 'File Exists '
                end
                object rbTXLockFile: TRadioButton
                  Left = 4
                  Top = 3
                  Width = 60
                  Height = 17
                  Caption = 'Filename'
                  TabOrder = 0
                  OnClick = rbCustLockFileClick
                end
                object edTXLockFile: TEdit
                  Left = 67
                  Top = 0
                  Width = 81
                  Height = 22
                  MaxLength = 12
                  TabOrder = 1
                end
                object rbTXLockExt: TRadioButton
                  Left = 156
                  Top = 3
                  Width = 64
                  Height = 17
                  Caption = 'Extension'
                  Checked = True
                  TabOrder = 2
                  TabStop = True
                  OnClick = rbCustLockFileClick
                end
                object edTXLockExt: TEdit
                  Left = 225
                  Top = 0
                  Width = 33
                  Height = 22
                  MaxLength = 3
                  TabOrder = 3
                end
                object cmbTXLockType: TComboBox
                  Left = 67
                  Top = 24
                  Width = 191
                  Height = 22
                  Style = csDropDownList
                  ItemHeight = 14
                  TabOrder = 4
                  Items.Strings = (
                    'when creating the export file'
                    'when the export file is created')
                end
              end
            end
          end
          object TabSheet2: TTabSheet
            Caption = 'Other'
            ImageIndex = 1
            object panCompOther: TPanel
              Left = 0
              Top = 0
              Width = 273
              Height = 324
              Align = alClient
              BevelOuter = bvNone
              Enabled = False
              TabOrder = 0
              object Bevel20: TBevel
                Left = 0
                Top = 289
                Width = 273
                Height = 34
                Shape = bsFrame
              end
              object Label27: TLabel
                Left = 21
                Top = 12
                Width = 112
                Height = 14
                Alignment = taRightJustify
                Caption = 'After processing XML :'
              end
              object Label25: TLabel
                Left = 6
                Top = 298
                Width = 55
                Height = 14
                Caption = 'Set Period :'
              end
              object Label26: TLabel
                Left = 200
                Top = 298
                Width = 9
                Height = 14
                Caption = 'to'
              end
              object Bevel17: TBevel
                Left = 0
                Top = 35
                Width = 273
                Height = 252
                Shape = bsFrame
              end
              object Bevel16: TBevel
                Left = 0
                Top = 0
                Width = 273
                Height = 33
                Shape = bsFrame
              end
              object cmbAfterProcess: TComboBox
                Left = 136
                Top = 6
                Width = 129
                Height = 22
                HelpContext = 34
                Style = csDropDownList
                ItemHeight = 14
                TabOrder = 0
                Items.Strings = (
                  'Archive XML File'
                  'Delete XML File')
              end
              object cbMaintainTXNo: TCheckBox
                Left = 20
                Top = 46
                Width = 226
                Height = 17
                HelpContext = 36
                Caption = 'Maintain transaction number on replication'
                TabOrder = 1
              end
              object cbHoldTXHeld: TCheckBox
                Left = 20
                Top = 64
                Width = 193
                Height = 17
                HelpContext = 37
                Caption = 'Transactions on Hold - Post as Held'
                TabOrder = 2
              end
              object cbHoldTXWarn: TCheckBox
                Left = 20
                Top = 82
                Width = 225
                Height = 17
                HelpContext = 38
                Caption = 'Transactions with warnings - Post as Held'
                TabOrder = 3
              end
              object cmbSetPeriod: TComboBox
                Left = 64
                Top = 294
                Width = 129
                Height = 22
                HelpContext = 39
                Style = csDropDownList
                ItemHeight = 14
                TabOrder = 4
                OnChange = cmbSetPeriodChange
                Items.Strings = (
                  'by Transaction Date'
                  'to period in Exchequer'
                  'manually')
              end
              object edPeriod: TEditPeriod
                Left = 216
                Top = 294
                Width = 49
                Height = 22
                HelpContext = 39
                AutoSelect = False
                EditMask = '00/0000;0;'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                MaxLength = 7
                ParentFont = False
                TabOrder = 5
                Text = '011996'
                Placement = cpAbove
                EPeriod = 1
                EYear = 96
                ViewMask = '00/0000;0;'
              end
              object chkReapplyEntPricing: TCheckBox
                Left = 20
                Top = 101
                Width = 233
                Height = 17
                HelpContext = 137
                Caption = 'Re-apply Exchequer Pricing'
                TabOrder = 6
              end
              object chkAltYourRef: TCheckBox
                Left = 20
                Top = 119
                Width = 233
                Height = 17
                Caption = 'Populate Alt Ref with Your Ref from XML'
                TabOrder = 7
              end
              object chkUseMatching: TCheckBox
                Left = 20
                Top = 138
                Width = 193
                Height = 17
                Caption = 'Match Invoices to original Orders'
                TabOrder = 8
              end
              object chkSentimailEvent: TCheckBox
                Left = 20
                Top = 156
                Width = 245
                Height = 17
                Caption = 'Post Transaction generates a Sentimail event'
                TabOrder = 9
              end
              object chkUdf1: TCheckBox
                Left = 20
                Top = 175
                Width = 237
                Height = 17
                Caption = 'Import User Field1 rather than User Field 4'
                TabOrder = 10
              end
              object chkGeneralNotes: TCheckBox
                Left = 20
                Top = 193
                Width = 181
                Height = 17
                Caption = 'Add Notes as General Notes'
                TabOrder = 11
              end
              object chkCCDepFromXml: TCheckBox
                Left = 20
                Top = 212
                Width = 157
                Height = 17
                Caption = 'Take CC/Dept from XML'
                TabOrder = 12
              end
              object chkBasda309: TCheckBox
                Left = 20
                Top = 232
                Width = 229
                Height = 17
                Caption = 'Use BASDA eBIS-XML 3.09 Schema'
                TabOrder = 13
              end
              object chkDescLinesFromXML: TCheckBox
                Left = 20
                Top = 251
                Width = 245
                Height = 17
                Caption = 'Use stock description lines from XML'
                TabOrder = 14
              end
            end
          end
          object tabCharges: TTabSheet
            Caption = 'Charges'
            ImageIndex = 4
            object grpLineTypes: TGroupBox
              Left = 16
              Top = 32
              Width = 249
              Height = 121
              Caption = 'Line Types'
              TabOrder = 3
              object Label22: TLabel
                Left = 19
                Top = 20
                Width = 122
                Height = 14
                Alignment = taRightJustify
                Caption = 'Freight Transaction Line :'
              end
              object Label23: TLabel
                Left = 27
                Top = 52
                Width = 114
                Height = 14
                Alignment = taRightJustify
                Caption = 'Misc. Transaction Line :'
              end
              object Label24: TLabel
                Left = 10
                Top = 84
                Width = 131
                Height = 14
                Alignment = taRightJustify
                Caption = 'Discount Transaction Line :'
              end
              object cmbFreightTX: TComboBox
                Left = 144
                Top = 16
                Width = 97
                Height = 22
                HelpContext = 35
                Style = csDropDownList
                ItemHeight = 0
                TabOrder = 0
              end
              object cmbMiscTX: TComboBox
                Left = 144
                Top = 48
                Width = 97
                Height = 22
                HelpContext = 35
                Style = csDropDownList
                ItemHeight = 0
                TabOrder = 1
              end
              object cmbDiscountTX: TComboBox
                Left = 144
                Top = 80
                Width = 97
                Height = 22
                HelpContext = 35
                Style = csDropDownList
                ItemHeight = 0
                TabOrder = 2
              end
            end
            object grpStk: TGroupBox
              Left = 16
              Top = 32
              Width = 249
              Height = 121
              Caption = 'Stock Codes'
              TabOrder = 1
              object Label51: TLabel
                Left = 37
                Top = 24
                Width = 39
                Height = 14
                Alignment = taRightJustify
                Caption = 'Freight :'
              end
              object Label52: TLabel
                Left = 48
                Top = 56
                Width = 28
                Height = 14
                Alignment = taRightJustify
                Caption = 'Misc :'
              end
              object Label53: TLabel
                Left = 28
                Top = 88
                Width = 48
                Height = 14
                Alignment = taRightJustify
                Caption = 'Discount :'
              end
              object edFreightStk: TEdit
                Left = 80
                Top = 21
                Width = 153
                Height = 22
                TabOrder = 0
                OnExit = edFreightStkExit
              end
              object edMiscStk: TEdit
                Left = 80
                Top = 53
                Width = 153
                Height = 22
                TabOrder = 1
                OnExit = edFreightStkExit
              end
              object edDiscStk: TEdit
                Left = 80
                Top = 85
                Width = 153
                Height = 22
                TabOrder = 2
                OnExit = edFreightStkExit
              end
            end
            object grpDesc: TGroupBox
              Left = 16
              Top = 160
              Width = 249
              Height = 121
              HelpContext = 139
              Caption = 'Descriptions'
              TabOrder = 2
              object Label54: TLabel
                Left = 19
                Top = 24
                Width = 39
                Height = 14
                Alignment = taRightJustify
                Caption = 'Freight :'
              end
              object Label55: TLabel
                Left = 30
                Top = 56
                Width = 28
                Height = 14
                Alignment = taRightJustify
                Caption = 'Misc :'
              end
              object Label56: TLabel
                Left = 10
                Top = 88
                Width = 48
                Height = 14
                Alignment = taRightJustify
                Caption = 'Discount :'
              end
              object edFreightDesc: TEdit
                Left = 64
                Top = 21
                Width = 177
                Height = 22
                TabOrder = 0
              end
              object edMiscDesc: TEdit
                Left = 64
                Top = 53
                Width = 177
                Height = 22
                TabOrder = 1
              end
              object edDiscDesc: TEdit
                Left = 64
                Top = 85
                Width = 177
                Height = 22
                TabOrder = 2
              end
            end
            object Panel5: TPanel
              Left = 0
              Top = 0
              Width = 265
              Height = 33
              BevelOuter = bvNone
              Caption = 'Panel5'
              TabOrder = 0
              object Label57: TLabel
                Left = 16
                Top = 11
                Width = 80
                Height = 14
                Caption = 'For charges use'
              end
              object cbUseStockForCharges: TComboBox
                Left = 104
                Top = 8
                Width = 161
                Height = 22
                HelpContext = 138
                ItemHeight = 14
                TabOrder = 0
                OnChange = cbUseStockForChargesChange
                Items.Strings = (
                  'Line Types and Descriptions'
                  'Stock Codes')
              end
            end
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        HelpContext = 6
        Caption = 'pgDirectory'
        object Label2: TLabel
          Left = 8
          Top = 8
          Width = 98
          Height = 14
          Caption = 'Directory Defaults'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label5: TLabel
          Left = 24
          Top = 76
          Width = 102
          Height = 14
          Alignment = taRightJustify
          Caption = 'Customer Export Dir :'
        end
        object Bevel8: TBevel
          Left = 128
          Top = 72
          Width = 158
          Height = 22
        end
        object Bevel1: TBevel
          Left = 128
          Top = 104
          Width = 158
          Height = 22
        end
        object Bevel2: TBevel
          Left = 128
          Top = 136
          Width = 158
          Height = 22
        end
        object Bevel3: TBevel
          Left = 128
          Top = 168
          Width = 158
          Height = 22
        end
        object Bevel4: TBevel
          Left = 128
          Top = 200
          Width = 158
          Height = 22
        end
        object Label7: TLabel
          Left = 10
          Top = 140
          Width = 116
          Height = 14
          Alignment = taRightJustify
          Caption = 'Stock Group Export Dir :'
        end
        object Label8: TLabel
          Left = 7
          Top = 172
          Width = 119
          Height = 14
          Alignment = taRightJustify
          Caption = 'Transactions Export Dir :'
        end
        object Label9: TLabel
          Left = 12
          Top = 204
          Width = 114
          Height = 14
          Alignment = taRightJustify
          Caption = 'COM Pricing Export Dir :'
        end
        object Label6: TLabel
          Left = 43
          Top = 108
          Width = 83
          Height = 14
          Alignment = taRightJustify
          Caption = 'Stock Export Dir :'
        end
        object Bevel11: TBevel
          Left = 14
          Top = 55
          Width = 265
          Height = 2
        end
        object btnCustDirBrowse: TButton
          Tag = 2
          Left = 264
          Top = 73
          Width = 21
          Height = 20
          HelpContext = 104
          Caption = '...'
          Enabled = False
          TabOrder = 2
          TabStop = False
          OnClick = btnCustDirBrowseClick
        end
        object btnStockDirBrowse: TButton
          Tag = 2
          Left = 264
          Top = 105
          Width = 21
          Height = 20
          HelpContext = 104
          Caption = '...'
          Enabled = False
          TabOrder = 4
          TabStop = False
          OnClick = btnCustDirBrowseClick
        end
        object btnSGDirBrowse: TButton
          Tag = 2
          Left = 264
          Top = 137
          Width = 21
          Height = 20
          HelpContext = 104
          Caption = '...'
          Enabled = False
          TabOrder = 6
          TabStop = False
          OnClick = btnCustDirBrowseClick
        end
        object btnTXDirBrowse: TButton
          Tag = 2
          Left = 264
          Top = 169
          Width = 21
          Height = 20
          HelpContext = 104
          Caption = '...'
          Enabled = False
          TabOrder = 8
          TabStop = False
          OnClick = btnCustDirBrowseClick
        end
        object btnCOMPriceDirBrowse: TButton
          Tag = 2
          Left = 264
          Top = 201
          Width = 21
          Height = 20
          HelpContext = 104
          Caption = '...'
          Enabled = False
          TabOrder = 10
          TabStop = False
          OnClick = btnCustDirBrowseClick
        end
        object edCustExportDir: Text8Pt
          Tag = 2
          Left = 128
          Top = 72
          Width = 137
          Height = 22
          HelpContext = 104
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 1
          OnExit = edCustExportDirExit
          TextId = 0
          ViaSBtn = False
        end
        object edStockExportDir: Text8Pt
          Tag = 2
          Left = 128
          Top = 104
          Width = 137
          Height = 22
          HelpContext = 104
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 3
          OnExit = edCustExportDirExit
          TextId = 0
          ViaSBtn = False
        end
        object edStockGrpExportDir: Text8Pt
          Tag = 2
          Left = 128
          Top = 136
          Width = 137
          Height = 22
          HelpContext = 104
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 5
          OnExit = edCustExportDirExit
          TextId = 0
          ViaSBtn = False
        end
        object edTXExportDir: Text8Pt
          Tag = 2
          Left = 128
          Top = 168
          Width = 137
          Height = 22
          HelpContext = 104
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 7
          OnExit = edCustExportDirExit
          TextId = 0
          ViaSBtn = False
        end
        object edCOMPricingDir: Text8Pt
          Tag = 2
          Left = 128
          Top = 200
          Width = 137
          Height = 22
          HelpContext = 104
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 9
          OnExit = edCustExportDirExit
          TextId = 0
          ViaSBtn = False
        end
        object panDirInherit: TPanel
          Left = 8
          Top = 24
          Width = 281
          Height = 31
          BevelOuter = bvNone
          Enabled = False
          TabOrder = 0
          object cbDirInherited: TCheckBox
            Tag = 12
            Left = 8
            Top = 8
            Width = 169
            Height = 17
            HelpContext = 12
            Caption = 'Use global settings as default'
            TabOrder = 0
            OnClick = cbInheritedClick
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgEmail'
        object Label3: TLabel
          Left = 8
          Top = 8
          Width = 78
          Height = 14
          Caption = 'Email Settings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object pcEmail: TPageControl
          Tag = 3
          Left = 7
          Top = 88
          Width = 281
          Height = 265
          ActivePage = TabSheet9
          TabIndex = 2
          TabOrder = 2
          OnChange = pcEmailChange
          object TabSheet7: TTabSheet
            Caption = '&Server'
            object panEmailServer: TPanel
              Left = 0
              Top = 0
              Width = 273
              Height = 236
              Align = alClient
              BevelOuter = bvNone
              Enabled = False
              TabOrder = 0
              object Label34: TLabel
                Left = 17
                Top = 16
                Width = 58
                Height = 14
                Alignment = taRightJustify
                Caption = 'Email Type'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lServerName: TLabel
                Left = 32
                Top = 88
                Width = 99
                Height = 14
                Caption = 'SMTP Server Name :'
                Enabled = False
              end
              object Bevel19: TBevel
                Left = 16
                Top = 72
                Width = 241
                Height = 73
                Shape = bsFrame
              end
              object Bevel18: TBevel
                Left = 16
                Top = 48
                Width = 241
                Height = 97
                Shape = bsFrame
              end
              object rbMAPI: TRadioButton
                Left = 32
                Top = 40
                Width = 49
                Height = 17
                HelpContext = 18
                Caption = 'MAPI'
                Checked = True
                TabOrder = 0
                TabStop = True
                OnClick = EmailTypeClick
              end
              object rbSMTP: TRadioButton
                Left = 32
                Top = 64
                Width = 49
                Height = 17
                HelpContext = 18
                Caption = 'SMTP'
                TabOrder = 1
                OnClick = EmailTypeClick
              end
              object edServerName: TEdit
                Left = 32
                Top = 106
                Width = 209
                Height = 22
                HelpContext = 18
                Enabled = False
                MaxLength = 40
                TabOrder = 2
              end
            end
          end
          object TabSheet8: TTabSheet
            Caption = '&Import'
            ImageIndex = 2
            object panEmailImport: TPanel
              Left = 0
              Top = 0
              Width = 273
              Height = 236
              Align = alClient
              BevelOuter = bvNone
              Enabled = False
              TabOrder = 0
              object Label29: TLabel
                Left = 33
                Top = 19
                Width = 77
                Height = 14
                Alignment = taRightJustify
                Caption = 'Account Name :'
              end
              object Label30: TLabel
                Left = 10
                Top = 51
                Width = 100
                Height = 14
                Alignment = taRightJustify
                Caption = 'Account Password :'
              end
              object edEmailAccName: TEdit
                Left = 114
                Top = 15
                Width = 151
                Height = 22
                HelpContext = 19
                MaxLength = 40
                TabOrder = 0
              end
              object edEmailAccPass: TEdit
                Left = 114
                Top = 47
                Width = 151
                Height = 22
                HelpContext = 19
                MaxLength = 40
                TabOrder = 1
              end
            end
          end
          object TabSheet9: TTabSheet
            Caption = 'Notification'
            ImageIndex = 1
            object panEmailNotify: TPanel
              Left = 0
              Top = 0
              Width = 273
              Height = 236
              Align = alClient
              BevelOuter = bvNone
              Enabled = False
              TabOrder = 0
              object Label31: TLabel
                Left = 8
                Top = 80
                Width = 100
                Height = 14
                Caption = 'Notify Administrator :'
              end
              object Label28: TLabel
                Left = 8
                Top = 176
                Width = 149
                Height = 14
                Caption = 'Administrator'#39's Email Address :'
              end
              object cbEmailConfirmProcess: TCheckBox
                Left = 8
                Top = 16
                Width = 209
                Height = 17
                HelpContext = 22
                Caption = 'Send Confirmation on Email processed'
                TabOrder = 0
              end
              object cbEmailConfirmReceipt: TCheckBox
                Left = 8
                Top = 48
                Width = 209
                Height = 17
                HelpContext = 24
                Caption = 'Send Confirmation on receipt of Email'
                TabOrder = 1
              end
              object rbNotifyNever: TRadioButton
                Left = 40
                Top = 101
                Width = 49
                Height = 17
                HelpContext = 25
                Caption = 'Never'
                TabOrder = 2
              end
              object rbNotifyExchange: TRadioButton
                Left = 40
                Top = 123
                Width = 177
                Height = 17
                HelpContext = 25
                Caption = 'Only exchange XML transactions'
                TabOrder = 3
              end
              object rbNotifyAllXML: TRadioButton
                Left = 40
                Top = 145
                Width = 121
                Height = 17
                HelpContext = 25
                Caption = 'All XML transactions'
                TabOrder = 4
              end
              object edAdminEmail: TEdit
                Left = 8
                Top = 192
                Width = 257
                Height = 22
                HelpContext = 26
                MaxLength = 100
                TabOrder = 5
              end
            end
          end
        end
        object panEmailAvail: TPanel
          Tag = 3
          Left = 8
          Top = 57
          Width = 281
          Height = 28
          BevelOuter = bvNone
          Enabled = False
          TabOrder = 1
          object cbEmailAvail: TCheckBox
            Tag = 3
            Left = 8
            Top = 8
            Width = 97
            Height = 17
            HelpContext = 16
            Caption = 'Email Available ?'
            TabOrder = 0
            OnClick = cbEmailAvailClick
          end
        end
        object panEmailInherit: TPanel
          Left = 8
          Top = 24
          Width = 281
          Height = 41
          BevelOuter = bvNone
          Enabled = False
          TabOrder = 0
          object Bevel10: TBevel
            Left = 6
            Top = 31
            Width = 265
            Height = 2
          end
          object cbEmailInherited: TCheckBox
            Tag = 13
            Left = 8
            Top = 8
            Width = 169
            Height = 17
            HelpContext = 12
            Caption = 'Use global settings as default'
            TabOrder = 0
            OnClick = cbInheritedClick
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        HelpContext = 8
        Caption = 'pgFTP'
        object Label4: TLabel
          Left = 8
          Top = 8
          Width = 69
          Height = 14
          Caption = 'FTP Settings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object pcFTP: TPageControl
          Tag = 4
          Left = 7
          Top = 56
          Width = 281
          Height = 297
          ActivePage = TabSheet5
          TabIndex = 2
          TabOrder = 1
          OnChange = pcFTPChange
          object TabSheet6: TTabSheet
            Caption = 'Site Settings'
            ImageIndex = 2
            object panFTPSite: TPanel
              Left = 0
              Top = 0
              Width = 273
              Height = 268
              HelpContext = 21
              Align = alClient
              BevelOuter = bvNone
              Enabled = False
              TabOrder = 0
              object Label38: TLabel
                Left = 17
                Top = 20
                Width = 68
                Height = 14
                Alignment = taRightJustify
                Caption = 'Site Address :'
              end
              object Label39: TLabel
                Left = 39
                Top = 52
                Width = 46
                Height = 14
                Alignment = taRightJustify
                Caption = 'Site Port :'
              end
              object Label40: TLabel
                Left = 9
                Top = 84
                Width = 76
                Height = 14
                Alignment = taRightJustify
                Caption = 'Site Username :'
              end
              object Label41: TLabel
                Left = 8
                Top = 116
                Width = 77
                Height = 14
                Alignment = taRightJustify
                Caption = 'Site Password :'
              end
              object edFTPSiteAddress: TEdit
                Left = 88
                Top = 16
                Width = 177
                Height = 22
                MaxLength = 40
                TabOrder = 0
              end
              object edFTPSitePort: TCurrencyEdit
                Left = 88
                Top = 48
                Width = 41
                Height = 22
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'ARIAL'
                Font.Style = []
                Lines.Strings = (
                  '0.00 ')
                MaxLength = 4
                ParentFont = False
                TabOrder = 1
                WantReturns = False
                WordWrap = False
                AutoSize = False
                BlockNegative = False
                BlankOnZero = False
                DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
                ShowCurrency = False
                TextId = 0
                Value = 1E-10
              end
              object edFTPSiteUser: TEdit
                Left = 88
                Top = 80
                Width = 177
                Height = 22
                MaxLength = 20
                TabOrder = 2
              end
              object edFTPSitePass: TEdit
                Left = 88
                Top = 112
                Width = 177
                Height = 22
                MaxLength = 20
                PasswordChar = '*'
                TabOrder = 3
              end
            end
          end
          object TabSheet4: TTabSheet
            Caption = 'Proxy Settings'
            object panFTPProxy: TPanel
              Left = 0
              Top = 0
              Width = 273
              Height = 268
              HelpContext = 31
              Align = alClient
              BevelOuter = bvNone
              Enabled = False
              TabOrder = 0
              object Label37: TLabel
                Left = 7
                Top = 20
                Width = 78
                Height = 14
                Alignment = taRightJustify
                Caption = 'Proxy Address :'
              end
              object Label36: TLabel
                Left = 29
                Top = 52
                Width = 56
                Height = 14
                Alignment = taRightJustify
                Caption = 'Proxy Port :'
              end
              object edFTPProxyAddress: TEdit
                Left = 88
                Top = 16
                Width = 177
                Height = 22
                MaxLength = 40
                TabOrder = 0
              end
              object edFTPProxyPort: TCurrencyEdit
                Left = 88
                Top = 48
                Width = 41
                Height = 22
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'ARIAL'
                Font.Style = []
                Lines.Strings = (
                  '0.00 ')
                MaxLength = 4
                ParentFont = False
                TabOrder = 1
                WantReturns = False
                WordWrap = False
                AutoSize = False
                BlockNegative = False
                BlankOnZero = False
                DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
                ShowCurrency = False
                TextId = 0
                Value = 1E-10
              end
              object cbFTPProxyPassive: TCheckBox
                Left = 88
                Top = 84
                Width = 121
                Height = 17
                Caption = 'Proxy Passive Mode'
                TabOrder = 2
              end
            end
          end
          object TabSheet5: TTabSheet
            Caption = 'Upload Directories'
            ImageIndex = 1
            object panFTPDir: TPanel
              Left = 0
              Top = 0
              Width = 273
              Height = 268
              HelpContext = 27
              Align = alClient
              BevelOuter = bvNone
              Enabled = False
              TabOrder = 0
              object Label46: TLabel
                Left = 1
                Top = 116
                Width = 85
                Height = 14
                Alignment = taRightJustify
                Caption = 'Transactions Dir :'
              end
              object Label44: TLabel
                Left = 37
                Top = 84
                Width = 49
                Height = 14
                Alignment = taRightJustify
                Caption = 'Stock Dir :'
              end
              object Label43: TLabel
                Left = 18
                Top = 52
                Width = 68
                Height = 14
                Alignment = taRightJustify
                Caption = 'Customer Dir :'
              end
              object Label42: TLabel
                Left = 42
                Top = 20
                Width = 44
                Height = 14
                Alignment = taRightJustify
                Caption = 'Root Dir :'
              end
              object edFTPRootDir: TEdit
                Left = 88
                Top = 16
                Width = 177
                Height = 22
                MaxLength = 50
                TabOrder = 0
              end
              object edFTPCustDir: TEdit
                Left = 88
                Top = 48
                Width = 177
                Height = 22
                MaxLength = 50
                TabOrder = 1
              end
              object edFTPStockDir: TEdit
                Left = 88
                Top = 80
                Width = 177
                Height = 22
                MaxLength = 50
                TabOrder = 2
              end
              object edFTPTXDir: TEdit
                Left = 88
                Top = 112
                Width = 177
                Height = 22
                MaxLength = 50
                TabOrder = 3
              end
            end
          end
        end
        object panFTPInherit: TPanel
          Left = 8
          Top = 24
          Width = 281
          Height = 25
          BevelOuter = bvNone
          Enabled = False
          TabOrder = 0
          object cbFTPInherited: TCheckBox
            Tag = 14
            Left = 8
            Top = 8
            Width = 169
            Height = 17
            Caption = 'Use global settings as default'
            TabOrder = 0
            OnClick = cbInheritedClick
          end
        end
      end
    end
  end
  object btnEdit: TButton
    Left = 520
    Top = 72
    Width = 65
    Height = 25
    HelpContext = 10
    Caption = '&Edit'
    TabOrder = 4
    OnClick = btnEditClick
  end
  object btnOK: TButton
    Left = 520
    Top = 8
    Width = 65
    Height = 25
    Caption = '&OK'
    Enabled = False
    TabOrder = 2
    OnClick = btnOKClick
    OnKeyDown = EditKeyDown
    OnKeyPress = EditKeyPress
  end
  object btnCancel: TButton
    Left = 520
    Top = 40
    Width = 65
    Height = 25
    Caption = '&Cancel'
    Enabled = False
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object btnClose: TButton
    Left = 520
    Top = 376
    Width = 65
    Height = 25
    HelpContext = 20
    Caption = '&Close'
    TabOrder = 5
    OnClick = btnCloseClick
  end
  object btnAddCo: TButton
    Left = 8
    Top = 376
    Width = 97
    Height = 25
    HelpContext = 1
    Caption = 'A&dd Company'
    TabOrder = 6
    OnClick = btnAddCoClick
  end
  object btnRemoveCo: TButton
    Left = 111
    Top = 376
    Width = 98
    Height = 25
    HelpContext = 11
    Caption = '&Remove Company'
    TabOrder = 7
    OnClick = btnRemoveCoClick
  end
  object panOptions: TPanel
    Left = 8
    Top = 8
    Width = 201
    Height = 361
    BevelOuter = bvNone
    TabOrder = 0
    object tvOptions: TTreeView
      Left = 0
      Top = 0
      Width = 201
      Height = 361
      Align = alClient
      HideSelection = False
      Images = ImageList1
      Indent = 19
      ReadOnly = True
      TabOrder = 0
      OnChange = tvOptionsChange
      Items.Data = {
        040000001F0000000000000000000000FFFFFFFFFFFFFFFF0000000003000000
        06476C6F62616C250000000300000003000000FFFFFFFFFFFFFFFF0000000000
        0000000C4469722044656661756C74731E0000000300000003000000FFFFFFFF
        FFFFFFFF000000000000000005456D61696C1C0000000300000003000000FFFF
        FFFFFFFFFFFF0000000000000000034654502B0000000100000001000000FFFF
        FFFFFFFFFFFF000000000400000012436F6D70616E7920312028454E54453031
        29280000000300000003000000FFFFFFFFFFFFFFFF00000000000000000F436F
        6D70616E792044657461696C73250000000300000003000000FFFFFFFFFFFFFF
        FF00000000000000000C4469722044656661756C74731E000000020000000200
        0000FFFFFFFFFFFFFFFF000000000000000005456D61696C1C00000002000000
        02000000FFFFFFFFFFFFFFFF0000000000000000034654502B00000001000000
        01000000FFFFFFFFFFFFFFFF000000000400000012436F6D70616E7920322028
        454E5445303229280000000300000003000000FFFFFFFFFFFFFFFF0000000000
        0000000F436F6D70616E792044657461696C73250000000200000002000000FF
        FFFFFFFFFFFFFF00000000000000000C4469722044656661756C74731E000000
        0200000002000000FFFFFFFFFFFFFFFF000000000000000005456D61696C1C00
        00000200000002000000FFFFFFFFFFFFFFFF0000000000000000034654502B00
        00000100000001000000FFFFFFFFFFFFFFFF000000000400000012436F6D7061
        6E7920332028454E5445303329280000000300000003000000FFFFFFFFFFFFFF
        FF00000000000000000F436F6D70616E792044657461696C7325000000030000
        0003000000FFFFFFFFFFFFFFFF00000000000000000C4469722044656661756C
        74731E0000000300000003000000FFFFFFFFFFFFFFFF00000000000000000545
        6D61696C1C0000000300000003000000FFFFFFFFFFFFFFFF0000000000000000
        03465450}
    end
  end
  object ImageList1: TImageList
    Left = 16
    Top = 304
    Bitmap = {
      494C010104000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF007B7B7B00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007B7B7B007B7B7B007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B
      7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF000000000000000000000000000000000000000000FFFF
      FF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF0000000000000000000000
      00000000000000000000FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B
      7B00FFFFFF007B7B7B00FFFFFF00FFFFFF000000000000000000000000000000
      0000FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00000000000000
      0000000000000000000000000000FFFFFF007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF000000000000000000000000000000000000000000FFFFFF007B7B
      7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF000000000000000000000000000000
      000000000000FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B
      7B00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00FF000000FF000000FF000000FF0000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00FF000000FF00000000FF0000FF000000FF00000000FF0000FF000000FF00
      00007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B00FF00
      0000FF000000FF00000000FF0000FF000000FF000000FF000000FF000000FF00
      0000FF00000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF0000000000000000000000000000007B0000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF00000000FF000000FF0000FF000000FF000000FF000000FF00
      0000FF00000000FF000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000007B0000000000000000000000000000000000000000000000
      7B00000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B00FF000000FF000000FF0000007B7B7B000000
      000000000000000000000000000000000000000000007B7B7B00FF000000FF00
      0000FF00000000FF000000FF000000FF0000FF000000FF000000FF000000FF00
      0000FF00000000FF0000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00FF00000000FF0000FF000000FF000000FF0000007B7B
      7B000000000000000000000000000000000000000000FF000000FF000000FF00
      000000FF000000FF000000FF000000FF000000FF0000FF000000FF000000FF00
      0000FF000000FF00000000FF0000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF0000007B000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B00FF000000FF00000000FF0000FF000000FF000000FF000000FF00
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      000000FF000000FF000000FF000000FF0000FF000000FF000000FF000000FF00
      0000FF000000FF00000000FF00000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000000FF
      FF000000000000FFFF0000000000000000000000000000000000000000000000
      FF0000007B00000000000000000000007B0000007B0000007B00000000000000
      000000007B000000FF0000000000000000000000000000000000000000000000
      0000FF000000FF00000000FF000000FF000000FF0000FF000000FF000000FF00
      000000FF000000000000000000000000000000000000FF000000FF000000FF00
      000000FF000000FF000000FF0000FF000000FF000000FF000000FF000000FF00
      000000FF000000FF000000FF0000000000000000000000FFFF00FFFFFF0000FF
      FF0000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000000000BDBDBD0000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF0000007B000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000FF000000FF0000FF000000FF000000FF00000000FF
      000000FF000000000000000000000000000000000000FF000000FF00000000FF
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000FF
      000000FF000000FF000000FF0000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF00000000FF0000FF000000FF000000FF000000FF00000000FF000000FF
      000000FF0000000000000000000000000000000000007B7B7B0000FF0000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000FF
      000000FF000000FF0000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      000000FFFF00BDBDBD0000000000000000000000000000000000000000000000
      00000000000000007B0000000000000000000000000000000000000000000000
      7B00000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000FF0000FF000000FF000000FF000000FF00000000FF000000FF
      000000000000000000000000000000000000000000000000000000FF000000FF
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000FF
      000000FF000000FF000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FF
      FF00BDBDBD0000FFFF0000000000000000000000000000000000000000000000
      00000000FF0000000000000000000000000000007B0000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      00000000000000FF000000FF0000FF000000FF000000FF000000FF00000000FF
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF0000FF000000FF000000FF000000FF00000000FF0000FF00
      000000FF00000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD0000FFFF00BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF0000FF000000FF000000FF000000FF000000FF00000000FF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7F0000000000000000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7F0000000000000000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFFFFFFFFFFFFFFFFF81FFFFFFFFFFFFF
      E007001FFF7FFFFFC007001FF777FFFFC0030007FBEFFC1F80030007FFFFF80F
      80010001FE3FF00F80010001E633F00780010001FE3FF00780010001FFFFF007
      8003C001FBEFF00FC003C001F777F80FE007F003FF7FFE3FF00FF0FFFFFFFFFF
      FC3FFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
end
