object frmAuthAdmin: TfrmAuthAdmin
  Left = 196
  Top = 209
  Width = 725
  Height = 433
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Authoris-e Administration'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  HelpFile = 'authoris.hlp'
  Icon.Data = {
    000001000200101010000000000028010000260000002020100000000000E802
    00004E0100002800000010000000200000000100040000000000C00000000000
    0000000000000000000000000000000000000000800000800000008080008000
    0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF0000000000000000000000000000000000000F
    FC0FFFFFF000000FCCC0000FF000000FCCC0FFFFF000000CCCCC0000F00000CC
    CCCC0FFFF00007CC0FCCC0FFF0007C0FFFFCC0FFF000000F000CCC00F000000F
    FFFFCC0FF000000F00000CC0F000000FFFFFFF7C0000000000000007C0000000
    000000000CC00000000000000000FFFF0000C0030000C0030000C0030000C003
    0000C0030000C00300008003000000030000C0030000C0030000C0030000C003
    0000C0030000FFF80000FFFF0000280000002000000040000000010004000000
    0000800200000000000000000000000000000000000000000000000080000080
    00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
    00000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFF
    FFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFCC00FFFFFF
    FFFFFFFFF000000FFFFFFFCC00FFFFFFFFFFFFFFF000000FFFFFCCCCCC00FFFF
    FFFFFFFFF000000FF000CCCCCC00000000000FFFF000000FFFFFCCCCCC00FFFF
    FFFFFFFFF000000FFFFFCCCCCC00FFFFFFFFFFFFF000000FFFCCCCCCCCCC00FF
    FFFFFFFFF000000FFFCCCCCCCCCC0000000000FFF000000FCCCCCCCCCCCC00FF
    FFFFFFFFF000000FCCCCCCCCCCCC00FFFFFFFFFFF0000077CCCC00FFCCCCCC00
    FFFFFFFFF0000077CCCC0000CCCCCC00000000FFF00007CC00FFFFFFFCCCCC00
    FFFFFFFFF00077CC00FFFFFFFCCCCC00FFFFFFFFF0000CCFFFFFFFFFFFCCCCCC
    00FFFFFFF000000FFFFFFFFFFFFCCCCC00FFFFFFF000000FF00000000000CCCC
    000000FFF000000FFFFFFFFFFFFFFCCC00FFFFFFF000000FFFFFFFFFFFFFFFCC
    CC00FFFFF000000FF0000000000000FCCC00FFFFF000000FFFFFFFFFFFFFFFFF
    7CCC00FFF000000FFFFFFFFFFFFFFFFF77CC00FFF000000FF000000000000000
    007CCC00F000000FFFFFFFFFFFFFFFFFFF77CC00F000000FFFFFFFFFFFFFFFFF
    FFFFFFCCCC00000000000000000000000000000CCC0000000000000000000000
    00000000CCCC00000000000000000000000000000000FFFFFFFFC0000003C000
    0003C0000003C0000003C0000003C0000003C0000003C0000003C0000003C000
    0003C0000003C0000003C0000003C0000003C000000380000003000000038000
    0003C0000003C0000003C0000003C0000003C0000003C0000003C0000003C000
    0003C0000003C0000003C0000003FFFFFFF0FFFFFFFF}
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label32: TLabel
    Left = 608
    Top = 192
    Width = 38
    Height = 13
    Caption = 'Label32'
    Visible = False
  end
  object Panel2: TPanel
    Left = 272
    Top = 8
    Width = 313
    Height = 353
    BevelOuter = bvLowered
    Caption = 'Panel2'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 39
      Height = 13
      Caption = 'Label1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label33: TLabel
      Left = 72
      Top = 10
      Width = 38
      Height = 13
      Caption = 'Label33'
      Visible = False
    end
    object Notebook1: TNotebook
      Left = 1
      Top = 24
      Width = 311
      Height = 328
      Align = alBottom
      PageIndex = 3
      TabOrder = 0
      OnMouseDown = Notebook1MouseDown
      OnPageChanged = Notebook1PageChanged
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgGlobalSettings'
        object PageControl2: TPageControl
          Left = 8
          Top = 16
          Width = 297
          Height = 305
          ActivePage = tabGlobal1
          TabIndex = 0
          TabOrder = 0
          OnChange = PageControl1Change
          object tabGlobal1: TTabSheet
            HelpContext = 30
            Caption = 'Mail'
            object GroupBox5: TGroupBox
              Left = 8
              Top = 200
              Width = 273
              Height = 65
              Caption = 'Administrator'
              TabOrder = 0
              object Label11: TLabel
                Left = 24
                Top = 36
                Width = 41
                Height = 13
                Caption = 'Address:'
              end
              object edtAdminEmail: TEdit
                Left = 88
                Top = 32
                Width = 121
                Height = 21
                HelpContext = 50
                TabOrder = 0
                Text = 'edtAdminEmail'
              end
            end
            object PageControl5: TPageControl
              Left = 8
              Top = 8
              Width = 273
              Height = 185
              ActivePage = TabSheet3
              TabIndex = 0
              TabOrder = 1
              object TabSheet3: TTabSheet
                Caption = 'Incoming'
                object GroupBox4: TGroupBox
                  Left = 8
                  Top = 0
                  Width = 249
                  Height = 151
                  TabOrder = 0
                  object Name: TLabel
                    Left = 48
                    Top = 28
                    Width = 31
                    Height = 13
                    Caption = 'Name:'
                  end
                  object Password: TLabel
                    Left = 30
                    Top = 52
                    Width = 49
                    Height = 13
                    Caption = 'Password:'
                  end
                  object Label13: TLabel
                    Left = 38
                    Top = 76
                    Width = 41
                    Height = 13
                    Caption = 'Address:'
                  end
                  object Label30: TLabel
                    Left = 45
                    Top = 100
                    Width = 34
                    Height = 13
                    Caption = 'Server:'
                  end
                  object edtSysName: TEdit
                    Left = 88
                    Top = 24
                    Width = 121
                    Height = 21
                    HelpContext = 52
                    TabOrder = 0
                    Text = 'edtSysName'
                  end
                  object edtSysPWord: TEdit
                    Left = 88
                    Top = 48
                    Width = 121
                    Height = 21
                    HelpContext = 53
                    PasswordChar = '*'
                    TabOrder = 1
                    Text = 'edtSysPWord'
                    OnEnter = edtAuthCodeEnter
                    OnExit = edtAuthCodeExit
                  end
                  object edtSysEmail: TEdit
                    Left = 88
                    Top = 72
                    Width = 121
                    Height = 21
                    HelpContext = 49
                    TabOrder = 2
                    Text = 'edtSysEmail'
                  end
                  object edtSysServer: TEdit
                    Left = 88
                    Top = 96
                    Width = 121
                    Height = 21
                    HelpContext = 54
                    TabOrder = 3
                    Text = 'edtSysServer'
                  end
                  object chkUseMapi: TCheckBox
                    Left = 88
                    Top = 120
                    Width = 97
                    Height = 17
                    HelpContext = 51
                    Caption = 'Use MAPI'
                    TabOrder = 4
                  end
                end
              end
              object TabSheet4: TTabSheet
                Caption = 'Outgoing'
                ImageIndex = 1
                object GroupBox16: TGroupBox
                  Left = 8
                  Top = 0
                  Width = 249
                  Height = 151
                  TabOrder = 0
                  object Label34: TLabel
                    Left = 48
                    Top = 28
                    Width = 31
                    Height = 13
                    Caption = 'Name:'
                  end
                  object Label35: TLabel
                    Left = 30
                    Top = 52
                    Width = 49
                    Height = 13
                    Caption = 'Password:'
                  end
                  object Label36: TLabel
                    Left = 38
                    Top = 76
                    Width = 41
                    Height = 13
                    Caption = 'Address:'
                  end
                  object Label37: TLabel
                    Left = 45
                    Top = 100
                    Width = 34
                    Height = 13
                    Caption = 'Server:'
                  end
                  object edtSysNameOut: TEdit
                    Left = 88
                    Top = 24
                    Width = 121
                    Height = 21
                    HelpContext = 52
                    TabOrder = 0
                    Text = 'edtSysName'
                  end
                  object edtSysPWordOut: TEdit
                    Left = 88
                    Top = 48
                    Width = 121
                    Height = 21
                    HelpContext = 53
                    PasswordChar = '*'
                    TabOrder = 1
                    Text = 'edtSysPWord'
                    OnEnter = edtAuthCodeEnter
                    OnExit = edtAuthCodeExit
                  end
                  object edtSysEmailOut: TEdit
                    Left = 88
                    Top = 72
                    Width = 121
                    Height = 21
                    HelpContext = 49
                    TabOrder = 2
                    Text = 'edtSysEmail'
                  end
                  object edtSysServerOut: TEdit
                    Left = 88
                    Top = 96
                    Width = 121
                    Height = 21
                    HelpContext = 54
                    TabOrder = 3
                    Text = 'edtSysServer'
                  end
                  object chkUseMapiOut: TCheckBox
                    Left = 88
                    Top = 120
                    Width = 97
                    Height = 17
                    HelpContext = 51
                    Caption = 'Use MAPI'
                    TabOrder = 4
                  end
                end
              end
            end
          end
          object tabDefaults: TTabSheet
            HelpContext = 31
            Caption = 'Defaults'
            ImageIndex = 1
            object GroupBox6: TGroupBox
              Left = 8
              Top = 8
              Width = 273
              Height = 113
              Caption = 'Messages'
              TabOrder = 0
              object Label12: TLabel
                Left = 8
                Top = 36
                Width = 114
                Height = 13
                Caption = 'Polling frequency (mins):'
              end
              object Label14: TLabel
                Left = 32
                Top = 68
                Width = 89
                Height = 13
                Caption = 'Delete after (days):'
              end
              object edtFrequency: TEdit
                Left = 128
                Top = 32
                Width = 121
                Height = 21
                HelpContext = 86
                TabOrder = 0
                Text = 'edtFrequency'
              end
              object edtTimeOut: TEdit
                Left = 128
                Top = 64
                Width = 121
                Height = 21
                HelpContext = 68
                TabOrder = 1
                Text = 'edtTimeOut'
              end
            end
            object GroupBox7: TGroupBox
              Left = 8
              Top = 136
              Width = 273
              Height = 129
              Caption = 'Offline period for backup'
              TabOrder = 1
              object Label15: TLabel
                Left = 48
                Top = 36
                Width = 51
                Height = 13
                Caption = 'Start Time:'
              end
              object Label16: TLabel
                Left = 43
                Top = 68
                Width = 56
                Height = 13
                Caption = 'Finish Time:'
              end
              object edtOffStart: TEdit
                Left = 128
                Top = 32
                Width = 121
                Height = 21
                HelpContext = 73
                TabOrder = 0
                Text = 'edtOffStart'
              end
              object edtOffFinish: TEdit
                Left = 128
                Top = 64
                Width = 121
                Height = 21
                HelpContext = 72
                TabOrder = 1
                Text = 'edtOffFinish'
              end
            end
          end
          object tabMsg: TTabSheet
            Caption = 'Messages'
            ImageIndex = 2
            object GroupBox11: TGroupBox
              Left = 4
              Top = 136
              Width = 281
              Height = 129
              Caption = 'Text of authorisation request email'
              TabOrder = 0
              object memMsg: TMemo
                Left = 8
                Top = 16
                Width = 265
                Height = 105
                TabOrder = 0
              end
            end
            object GroupBox13: TGroupBox
              Left = 4
              Top = 4
              Width = 281
              Height = 129
              Caption = 'Text of approval request email'
              TabOrder = 1
              object memAppMsg: TMemo
                Left = 8
                Top = 16
                Width = 265
                Height = 105
                TabOrder = 0
              end
            end
          end
          object tabSecurity: TTabSheet
            Caption = 'Security'
            ImageIndex = 3
            object Panel4: TPanel
              Left = 8
              Top = 8
              Width = 273
              Height = 265
              BevelInner = bvRaised
              BevelOuter = bvLowered
              TabOrder = 0
              object Label26: TLabel
                Left = 37
                Top = 36
                Width = 49
                Height = 13
                Alignment = taRightJustify
                Caption = 'Password:'
              end
              object edtAdminPword: TEdit
                Left = 96
                Top = 32
                Width = 121
                Height = 21
                HelpContext = 88
                MaxLength = 8
                PasswordChar = '*'
                TabOrder = 0
                OnEnter = edtAuthCodeEnter
                OnExit = edtAuthCodeExit
              end
            end
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgCompanySettings'
        object PageControl4: TPageControl
          Left = 8
          Top = 16
          Width = 297
          Height = 305
          ActivePage = tabCoDefaults
          TabIndex = 0
          TabOrder = 0
          OnChange = PageControl1Change
          object tabCoDefaults: TTabSheet
            Caption = 'Defaults'
            object GroupBox10: TGroupBox
              Left = 8
              Top = 8
              Width = 265
              Height = 153
              Caption = 'These transactions require authorisation:'
              TabOrder = 0
              object chkCoSQU: TCheckBox
                Left = 24
                Top = 24
                Width = 209
                Height = 17
                HelpContext = 87
                Caption = 'Sales Quotations (SQU)'
                TabOrder = 0
              end
              object chkCoPQU: TCheckBox
                Left = 24
                Top = 56
                Width = 209
                Height = 17
                HelpContext = 89
                Caption = 'Purchase Quotations (PQU)'
                TabOrder = 1
              end
              object chkCoPOR: TCheckBox
                Left = 24
                Top = 88
                Width = 217
                Height = 17
                HelpContext = 90
                Caption = 'Purchase Orders (POR)'
                TabOrder = 2
              end
              object chkCoPIN: TCheckBox
                Left = 24
                Top = 120
                Width = 217
                Height = 17
                HelpContext = 91
                Caption = 'Purchase Invoices (PIN)'
                TabOrder = 3
              end
            end
            object GroupBox12: TGroupBox
              Left = 8
              Top = 168
              Width = 265
              Height = 105
              Caption = 'Authorisation type'
              TabOrder = 1
              object rbAuthOnlyA: TRadioButton
                Left = 24
                Top = 20
                Width = 177
                Height = 17
                HelpContext = 60
                Caption = 'Authorisation Only (automatic)'
                Checked = True
                TabOrder = 0
                TabStop = True
              end
              object rbAuthOnlyM: TRadioButton
                Left = 24
                Top = 48
                Width = 169
                Height = 17
                HelpContext = 61
                Caption = 'Authorisation Only (manual)'
                TabOrder = 1
              end
              object rbAuthAndApprove: TRadioButton
                Left = 24
                Top = 76
                Width = 169
                Height = 17
                HelpContext = 59
                Caption = 'Approval and Authorisation'
                TabOrder = 2
              end
            end
          end
          object tabCoForms: TTabSheet
            Caption = 'Forms'
            ImageIndex = 1
            object GroupBox9: TGroupBox
              Left = 8
              Top = 8
              Width = 273
              Height = 257
              Caption = 'Forms'
              TabOrder = 0
              object Label22: TLabel
                Left = 32
                Top = 36
                Width = 78
                Height = 13
                Caption = 'Sales Quotation:'
              end
              object Label23: TLabel
                Left = 13
                Top = 76
                Width = 97
                Height = 13
                Caption = 'Purchase Quotation:'
              end
              object Label24: TLabel
                Left = 33
                Top = 116
                Width = 77
                Height = 13
                Caption = 'Purchase Order:'
              end
              object Label25: TLabel
                Left = 24
                Top = 156
                Width = 86
                Height = 13
                Caption = 'Purchase Invoice:'
              end
              object edtSQUForm: TEdit
                Left = 128
                Top = 32
                Width = 105
                Height = 21
                HelpContext = 78
                TabOrder = 0
                Text = 'edtSQUForm'
              end
              object edtPQUForm: TEdit
                Left = 128
                Top = 72
                Width = 105
                Height = 21
                HelpContext = 79
                TabOrder = 1
                Text = 'edtPQUForm'
              end
              object edtPORForm: TEdit
                Left = 128
                Top = 112
                Width = 105
                Height = 21
                HelpContext = 80
                TabOrder = 2
                Text = 'edtPORForm'
              end
              object edtPINForm: TEdit
                Left = 128
                Top = 152
                Width = 105
                Height = 21
                HelpContext = 81
                TabOrder = 3
                Text = 'edtPINForm'
              end
              object Button1: TButton
                Tag = 1
                Left = 232
                Top = 32
                Width = 23
                Height = 22
                Caption = '...'
                TabOrder = 4
                OnClick = SpeedButton1Click
              end
              object Button2: TButton
                Tag = 2
                Left = 232
                Top = 72
                Width = 23
                Height = 22
                Caption = '...'
                TabOrder = 5
                OnClick = SpeedButton1Click
              end
              object Button3: TButton
                Tag = 3
                Left = 232
                Top = 112
                Width = 23
                Height = 22
                Caption = '...'
                TabOrder = 6
                OnClick = SpeedButton1Click
              end
              object Button4: TButton
                Tag = 4
                Left = 232
                Top = 152
                Width = 23
                Height = 22
                Caption = '...'
                TabOrder = 7
                OnClick = SpeedButton1Click
              end
            end
          end
          object tabPrinting: TTabSheet
            Caption = 'Other'
            ImageIndex = 2
            object GroupBox14: TGroupBox
              Left = 8
              Top = 8
              Width = 273
              Height = 257
              TabOrder = 0
              object Label38: TLabel
                Left = 18
                Top = 176
                Width = 72
                Height = 13
                Caption = 'PIN Tolerance:'
              end
              object Label41: TLabel
                Left = 16
                Top = 144
                Width = 152
                Height = 13
                Caption = 'Check for converted PINs every'
              end
              object Label42: TLabel
                Left = 244
                Top = 144
                Width = 21
                Height = 13
                Caption = 'mins'
              end
              object chkAllowPrint: TCheckBox
                Left = 16
                Top = 40
                Width = 233
                Height = 17
                HelpContext = 57
                Caption = 'Allow printing of unauthorised transactions '
                TabOrder = 0
              end
              object chkPinFloor: TCheckBox
                Left = 16
                Top = 76
                Width = 153
                Height = 17
                HelpContext = 74
                Caption = 'Floor limit applies to PINs'
                TabOrder = 1
              end
              object chkAuthOnConvert: TCheckBox
                Left = 16
                Top = 112
                Width = 249
                Height = 17
                Caption = 'Authorise PINs converted from authorised PORs'
                TabOrder = 2
              end
              object edtPINInterval: TCurrencyEdit
                Left = 172
                Top = 140
                Width = 53
                Height = 21
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'ARIAL'
                Font.Style = []
                Lines.Strings = (
                  '0')
                MaxLength = 4
                ParentFont = False
                TabOrder = 3
                WantReturns = False
                WordWrap = False
                AutoSize = False
                BlockNegative = False
                BlankOnZero = False
                DisplayFormat = '###,###,##0 ;###,###,##0-'
                DecPlaces = 0
                ShowCurrency = False
                TextId = 0
                Value = 1E-10
              end
              object udPINInterval: TUpDown
                Left = 225
                Top = 140
                Width = 16
                Height = 21
                Associate = edtPINInterval
                Min = 0
                Max = 9999
                Position = 0
                TabOrder = 4
                Wrap = False
              end
              object edtPINTolerance: TCurrencyEdit
                Left = 96
                Top = 172
                Width = 57
                Height = 21
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'ARIAL'
                Font.Style = []
                Lines.Strings = (
                  '1')
                ParentFont = False
                TabOrder = 5
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
            end
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgAuthorizers'
        object pgcAuth: TPageControl
          Left = 8
          Top = 16
          Width = 289
          Height = 305
          ActivePage = TabSheet1
          TabIndex = 2
          TabOrder = 0
          OnChange = PageControl1Change
          object tabAuthDet: TTabSheet
            Caption = 'Details'
            object GroupBox1: TGroupBox
              Left = 8
              Top = 8
              Width = 265
              Height = 97
              TabOrder = 0
              object Label7: TLabel
                Left = 48
                Top = 28
                Width = 31
                Height = 13
                Caption = 'Name:'
              end
              object Label8: TLabel
                Left = 51
                Top = 60
                Width = 28
                Height = 13
                Caption = 'Email:'
              end
              object edtAuthName: TEdit
                Left = 96
                Top = 24
                Width = 121
                Height = 21
                HelpContext = 62
                CharCase = ecUpperCase
                ReadOnly = True
                TabOrder = 0
                Text = 'EDTAUTHNAME'
              end
              object edtAuthEmail: TEdit
                Left = 96
                Top = 56
                Width = 121
                Height = 21
                HelpContext = 63
                TabOrder = 1
                Text = 'edtAuthEmail'
              end
            end
            object GroupBox2: TGroupBox
              Left = 8
              Top = 112
              Width = 265
              Height = 153
              Caption = 'Authorisation'
              TabOrder = 1
              object Label9: TLabel
                Left = 52
                Top = 28
                Width = 28
                Height = 13
                Caption = 'Code:'
              end
              object Label10: TLabel
                Left = 56
                Top = 64
                Width = 24
                Height = 13
                Caption = 'Limit:'
              end
              object edtAuthCode: TEdit
                Left = 96
                Top = 24
                Width = 121
                Height = 21
                HelpContext = 64
                MaxLength = 10
                PasswordChar = '*'
                TabOrder = 0
                Text = 'edtAuthCode'
                OnEnter = edtAuthCodeEnter
                OnExit = edtAuthCodeExit
              end
              object edtAuthMax: TEdit
                Left = 96
                Top = 60
                Width = 121
                Height = 21
                HelpContext = 65
                TabOrder = 1
                Text = 'edtAuthMax'
              end
              object chkActive: TCheckBox
                Left = 56
                Top = 120
                Width = 97
                Height = 17
                HelpContext = 55
                Caption = 'Active'
                TabOrder = 2
              end
              object chkApprovalOnly: TCheckBox
                Left = 56
                Top = 96
                Width = 97
                Height = 17
                HelpContext = 58
                Caption = 'Approval only'
                TabOrder = 3
                OnClick = chkApprovalOnlyClick
              end
            end
          end
          object tabPermissions: TTabSheet
            Caption = 'Permissions'
            ImageIndex = 1
            object GroupBox3: TGroupBox
              Left = 8
              Top = 16
              Width = 265
              Height = 169
              HelpContext = 91
              Caption = 'Can authorise'
              TabOrder = 0
              object chkSQU: TCheckBox
                Left = 24
                Top = 40
                Width = 209
                Height = 17
                HelpContext = 91
                Caption = 'Sales Quotations (SQU)'
                TabOrder = 0
              end
              object chkPQU: TCheckBox
                Left = 24
                Top = 72
                Width = 209
                Height = 17
                HelpContext = 91
                Caption = 'Purchase Quotations (PQU)'
                TabOrder = 1
              end
              object chkPOR: TCheckBox
                Left = 24
                Top = 104
                Width = 217
                Height = 17
                HelpContext = 91
                Caption = 'Purchase Orders (POR)'
                TabOrder = 2
              end
              object chkPIN: TCheckBox
                Left = 24
                Top = 136
                Width = 217
                Height = 17
                HelpContext = 91
                Caption = 'Purchase Invoices (PIN)'
                TabOrder = 3
              end
            end
          end
          object TabSheet1: TTabSheet
            Caption = 'Defaults'
            ImageIndex = 2
            object GroupBox15: TGroupBox
              Left = 8
              Top = 8
              Width = 265
              Height = 49
              HelpContext = 102
              TabOrder = 0
              object chkCompressAttachments: TCheckBox
                Left = 24
                Top = 16
                Width = 193
                Height = 17
                HelpContext = 102
                Caption = 'Compress email attachments'
                TabOrder = 0
              end
            end
            object Panel6: TPanel
              Left = 8
              Top = 184
              Width = 265
              Height = 81
              HelpContext = 103
              BevelInner = bvRaised
              BevelOuter = bvLowered
              TabOrder = 1
              object Label31: TLabel
                Left = 20
                Top = 8
                Width = 229
                Height = 41
                HelpContext = 103
                AutoSize = False
                Caption = 
                  'When acting as an approver, use this Authoriser as my default Au' +
                  'thoriser.'
                WordWrap = True
              end
              object cbAuthDefaultAuth: TComboBox
                Left = 24
                Top = 40
                Width = 225
                Height = 21
                HelpContext = 103
                ItemHeight = 13
                TabOrder = 0
                Text = 'cbAuthDefaultAuth'
              end
            end
            object Panel7: TPanel
              Left = 8
              Top = 64
              Width = 265
              Height = 113
              HelpContext = 103
              BevelInner = bvRaised
              BevelOuter = bvLowered
              TabOrder = 2
              object lblAltAuth: TLabel
                Left = 24
                Top = 8
                Width = 205
                Height = 17
                HelpContext = 103
                AutoSize = False
                Caption = 'Alternate Authoriser/Approver'
                WordWrap = True
              end
              object Label39: TLabel
                Left = 24
                Top = 60
                Width = 191
                Height = 13
                Caption = 'Time to wait before transferring requests '
              end
              object Label40: TLabel
                Left = 104
                Top = 82
                Width = 32
                Height = 13
                Caption = '(hours)'
              end
              object cbAlternate: TComboBox
                Left = 24
                Top = 24
                Width = 225
                Height = 21
                HelpContext = 103
                ItemHeight = 13
                TabOrder = 0
                Text = 'cbAuthDefaultAuth'
              end
              object spAlt: TSpinEdit
                Left = 24
                Top = 78
                Width = 73
                Height = 22
                MaxValue = 0
                MinValue = 0
                TabOrder = 1
                Value = 0
              end
              object cbAltHoursDays: TComboBox
                Left = 104
                Top = 78
                Width = 145
                Height = 21
                ItemHeight = 13
                ItemIndex = 0
                TabOrder = 2
                Text = 'Hours'
                Items.Strings = (
                  'Hours'
                  'Days')
              end
            end
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgUsers'
        object PageControl1: TPageControl
          Left = 8
          Top = 16
          Width = 297
          Height = 305
          ActivePage = tabUserSet
          TabIndex = 0
          TabOrder = 0
          OnChange = PageControl1Change
          object tabUserSet: TTabSheet
            Caption = 'Settings'
            object Panel1: TPanel
              Left = 8
              Top = 8
              Width = 273
              Height = 121
              BevelInner = bvRaised
              BevelOuter = bvLowered
              TabOrder = 0
              object Label2: TLabel
                Left = 64
                Top = 23
                Width = 39
                Height = 13
                Caption = 'User ID:'
              end
              object Label3: TLabel
                Left = 47
                Top = 58
                Width = 56
                Height = 13
                Caption = 'User Name:'
              end
              object Label4: TLabel
                Left = 50
                Top = 92
                Width = 53
                Height = 13
                Caption = 'User Email:'
              end
              object edtUserId: TEdit
                Left = 120
                Top = 18
                Width = 121
                Height = 21
                HelpContext = 75
                CharCase = ecUpperCase
                ReadOnly = True
                TabOrder = 0
                Text = 'EDTUSERID'
              end
              object edtUserName: TEdit
                Left = 120
                Top = 52
                Width = 121
                Height = 21
                HelpContext = 76
                TabOrder = 1
                Text = 'edtUserName'
              end
              object edtUserEmail: TEdit
                Left = 120
                Top = 87
                Width = 121
                Height = 21
                HelpContext = 77
                TabOrder = 2
                Text = 'edtUserEmail'
              end
            end
            object Panel3: TPanel
              Left = 8
              Top = 136
              Width = 273
              Height = 73
              BevelInner = bvRaised
              BevelOuter = bvLowered
              TabOrder = 1
              object Label5: TLabel
                Left = 64
                Top = 14
                Width = 50
                Height = 13
                Caption = 'Floor Limit:'
              end
              object Label6: TLabel
                Left = 11
                Top = 36
                Width = 103
                Height = 13
                Caption = 'Authorisation Amount:'
              end
              object edtFloorLimit: TEdit
                Left = 136
                Top = 10
                Width = 105
                Height = 21
                HelpContext = 82
                TabOrder = 0
                Text = 'edtFloorLimit'
              end
              object edtAuthAmount: TEdit
                Left = 136
                Top = 34
                Width = 105
                Height = 21
                HelpContext = 83
                TabOrder = 1
                Text = 'edtAuthAmount'
              end
            end
            object grpEmailType: TRadioGroup
              Left = 8
              Top = 216
              Width = 273
              Height = 49
              HelpContext = 70
              Caption = 'Send emails to '
              Columns = 2
              Items.Strings = (
                'All'
                'Best Fit')
              TabOrder = 2
            end
          end
          object tabUserDef: TTabSheet
            Caption = 'Defaults'
            ImageIndex = 1
            object Panel5: TPanel
              Left = 8
              Top = 8
              Width = 273
              Height = 105
              HelpContext = 104
              BevelInner = bvRaised
              BevelOuter = bvLowered
              TabOrder = 0
              object lblDefaultApprover: TLabel
                Left = 28
                Top = 20
                Width = 83
                Height = 13
                Caption = 'Default Approver:'
              end
              object lblDefaultAuthoriser: TLabel
                Left = 24
                Top = 54
                Width = 87
                Height = 13
                Caption = 'Default Authoriser:'
              end
              object cbDefaultApprover: TComboBox
                Left = 120
                Top = 16
                Width = 129
                Height = 21
                HelpContext = 104
                Style = csDropDownList
                ItemHeight = 13
                TabOrder = 0
              end
              object cbDefaultAuthoriser: TComboBox
                Left = 120
                Top = 52
                Width = 129
                Height = 21
                HelpContext = 104
                Style = csDropDownList
                ItemHeight = 13
                TabOrder = 1
              end
            end
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgRequests'
        object PageControl3: TPageControl
          Left = 8
          Top = 16
          Width = 289
          Height = 305
          ActivePage = tabRequest
          TabIndex = 0
          TabOrder = 0
          OnChange = PageControl1Change
          object tabRequest: TTabSheet
            Caption = 'Request'
            object GroupBox8: TGroupBox
              Left = 8
              Top = 8
              Width = 265
              Height = 265
              Caption = 'Request details'
              TabOrder = 0
              object Label17: TLabel
                Left = 64
                Top = 20
                Width = 14
                Height = 13
                Caption = 'ID:'
              end
              object Label18: TLabel
                Left = 19
                Top = 51
                Width = 59
                Height = 13
                Caption = 'Transaction:'
              end
              object Label19: TLabel
                Left = 53
                Top = 82
                Width = 25
                Height = 13
                Caption = 'User:'
              end
              object Label20: TLabel
                Left = 22
                Top = 113
                Width = 56
                Height = 13
                Caption = 'Total value:'
              end
              object Label21: TLabel
                Left = 19
                Top = 143
                Width = 59
                Height = 13
                Caption = 'Time Stamp:'
              end
              object Label27: TLabel
                Left = 45
                Top = 174
                Width = 33
                Height = 13
                Alignment = taRightJustify
                Caption = 'Status:'
              end
              object Label28: TLabel
                Left = 28
                Top = 233
                Width = 50
                Height = 13
                Alignment = taRightJustify
                Caption = 'Authoriser:'
              end
              object Label29: TLabel
                Left = 32
                Top = 204
                Width = 46
                Height = 13
                Alignment = taRightJustify
                Caption = 'Approver:'
              end
              object edtEARID: TEdit
                Left = 92
                Top = 16
                Width = 160
                Height = 21
                HelpContext = 92
                TabOrder = 0
                Text = 'edtEARID'
              end
              object edtEarOurRef: TEdit
                Left = 92
                Top = 47
                Width = 160
                Height = 21
                HelpContext = 93
                ReadOnly = True
                TabOrder = 1
                Text = 'edtEarOurRef'
              end
              object edtEarUserID: TEdit
                Left = 92
                Top = 78
                Width = 160
                Height = 21
                HelpContext = 94
                ReadOnly = True
                TabOrder = 2
                Text = 'edtEarUserID'
              end
              object edtEarValue: TEdit
                Left = 92
                Top = 109
                Width = 160
                Height = 21
                HelpContext = 95
                ReadOnly = True
                TabOrder = 3
                Text = 'edtEarValue'
              end
              object edtEarTime: TEdit
                Left = 92
                Top = 139
                Width = 160
                Height = 21
                HelpContext = 96
                ReadOnly = True
                TabOrder = 4
                Text = 'edtEarTime'
              end
              object edtEARAuth: TEdit
                Left = 92
                Top = 229
                Width = 160
                Height = 21
                HelpContext = 98
                ReadOnly = True
                TabOrder = 5
                Text = 'edtEARAuth'
              end
              object edtEarStatus: TEdit
                Left = 92
                Top = 170
                Width = 160
                Height = 21
                HelpContext = 97
                ReadOnly = True
                TabOrder = 6
                Text = 'edtEarStatus'
              end
              object edtEARApp: TEdit
                Left = 92
                Top = 200
                Width = 160
                Height = 21
                HelpContext = 99
                ReadOnly = True
                TabOrder = 7
                Text = 'edtEARApp'
              end
              object vcbRequest: TVirtualComboBox
                Left = 92
                Top = 16
                Width = 161
                Height = 23
                BevelOuter = bvLowered
                Caption = 'vcbRequest'
                Constraints.MaxHeight = 23
                Constraints.MinHeight = 23
                Ctl3D = False
                ParentCtl3D = False
                TabOrder = 8
                Visible = False
                OnEnter = vcbRequestEnter
                OnGetFirst = vcbRequestGetFirst
                OnGetLast = vcbRequestGetLast
                OnGetPrevPage = vcbRequestGetPrevPage
                OnGetNextPage = vcbRequestGetNextPage
                OnGetNext = vcbRequestGetNext
                OnGetPrev = vcbRequestGetPrev
                OnShow = vcbRequestShow
                OnChange = vcbRequestChange
                FlatButton = False
              end
            end
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'Blank'
      end
    end
  end
  object btnOK: TButton
    Left = 592
    Top = 8
    Width = 80
    Height = 21
    HelpContext = 84
    Caption = '&Save'
    Enabled = False
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 592
    Top = 40
    Width = 80
    Height = 21
    HelpContext = 66
    Caption = '&Cancel'
    Enabled = False
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnAdd: TButton
    Left = 8
    Top = 336
    Width = 80
    Height = 21
    HelpContext = 56
    Caption = '&Add'
    TabOrder = 3
    OnMouseDown = btnAddMouseDown
  end
  object btnRemove: TButton
    Left = 184
    Top = 336
    Width = 80
    Height = 21
    HelpContext = 85
    Caption = '&Remove'
    Enabled = False
    TabOrder = 4
    OnClick = btnRemoveClick
  end
  object btnEdit: TButton
    Left = 592
    Top = 72
    Width = 80
    Height = 21
    HelpContext = 69
    Caption = '&Edit'
    TabOrder = 5
    OnClick = btnEditClick
  end
  object btnClose: TButton
    Left = 592
    Top = 340
    Width = 80
    Height = 21
    HelpContext = 67
    Caption = '&Close'
    TabOrder = 6
    OnClick = btnCloseClick
  end
  object panelTree: TPanel
    Left = 8
    Top = 8
    Width = 257
    Height = 313
    BevelOuter = bvNone
    Caption = 'panelTree'
    TabOrder = 7
    object tvAdmin: TTreeView
      Left = 0
      Top = 0
      Width = 257
      Height = 313
      Align = alClient
      BevelKind = bkTile
      HideSelection = False
      Images = ImageList1
      Indent = 19
      PopupMenu = PopupMenu1
      ReadOnly = True
      TabOrder = 0
      OnAdvancedCustomDrawItem = tvAdminAdvancedCustomDrawItem
      OnChange = tvAdminChange
      OnCollapsed = tvAdminCollapsed
      OnCustomDraw = tvAdminCustomDraw
      OnExpanded = tvAdminExpanded
      OnKeyUp = tvAdminKeyUp
      OnMouseUp = tvAdminMouseUp
    end
  end
  object btnFindRequest: TButton
    Left = 592
    Top = 104
    Width = 80
    Height = 21
    Caption = 'Find'
    TabOrder = 8
    Visible = False
    OnClick = btnFindRequestClick
  end
  object btnExport: TButton
    Left = 592
    Top = 136
    Width = 80
    Height = 21
    Caption = 'E&xport'
    TabOrder = 9
    OnClick = btnExportClick
  end
  object ImageList1: TImageList
    Left = 16
    Top = 288
    Bitmap = {
      494C010107000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000C6C6C600C6C6C600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007B7B7B007B7B7B007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000C6C6C600C6C6C600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000FF000000FF000000FF0000000000000000007B7B7B00C6C6C600C6C6
      C6000000000000000000C6C6C600C6C6C600C6C6C60000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF007B7B7B007B7B
      7B007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000FF00FF00000000FF0000000000007B7B7B00C6C6C600000000000000
      0000000000000000000000000000C6C6C600C6C6C60000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000FF0000FF00000000FF00000000000000000000000000000000000000
      0000000000000000000000000000C6C6C600C6C6C600C6C6C600000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C6000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B00C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600000000000000000000000000000000000000
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
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00FF000000FF00000000FF0000FF000000FF00000000FF0000FF000000FF00
      00007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000000000007B7B7B00FF00
      0000FF000000FF00000000FF0000FF000000FF000000FF000000FF000000FF00
      0000FF00000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF00000000FF000000FF0000FF000000FF000000FF000000FF00
      0000FF00000000FF000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      000000000000000000000000000000000000000000007B7B7B00FF000000FF00
      0000FF00000000FF000000FF000000FF0000FF000000FF000000FF000000FF00
      0000FF00000000FF0000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000000FF
      FF0000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      000000FF000000FF000000FF000000FF000000FF0000FF000000FF000000FF00
      0000FF000000FF00000000FF0000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000FF
      FF00000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      000000FF000000FF000000FF000000FF0000FF000000FF000000FF000000FF00
      0000FF000000FF00000000FF00000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000000FF
      FF000000000000FFFF000000000000000000000000007B7B7B00FF000000FF00
      00000000000000000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      000000FF000000FF000000FF0000FF000000FF000000FF000000FF000000FF00
      000000FF000000FF000000FF0000000000000000000000FFFF00FFFFFF0000FF
      FF0000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000000000BDBDBD0000000000000000007B7B7B00FF000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF00000000FF
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000FF
      000000FF000000FF000000FF0000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B000000000000000000000000007B7B7B0000FF0000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000FF
      000000FF000000FF0000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      000000FFFF00BDBDBD0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B0000000000000000000000000000FF000000FF
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000FF
      000000FF000000FF000000000000000000000000000000000000000000000000
      00000000000000000000BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FF
      FF00BDBDBD0000FFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF0000FF000000FF000000FF000000FF00000000FF0000FF00
      000000FF00000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD0000FFFF00BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B00FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF0000FF000000FF000000FF000000FF000000FF00000000FF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00FF0000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B000000000000000000000000007B7B7B000000
      000000000000000000007B7B7B00000000000000000000000000000000000000
      0000000000000000000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      0000000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      0000F9FFF00100000000F0FFF00100000000F0FFC00100000000E07FC0010000
      0000C07F000100000000843F0001000000001E3F000100000000FE1F00070000
      0000FF1F00070000FFFFFF8F001F0000FFFFFFC7001F0000FFFFFFE3FFFF0000
      FFFFFFF8FFFF0000FFFFFFFFFFFF0000FFFFFFFFFFFFFC7FF81FFFFFFFFFF83F
      E007001FF9FFF01FC007001FF0FFF01FC0030007F0FFF01F80030007E07FF01F
      80010001C07FF01F80010001843FF01F800100011E3FF83F80010001FE1FFEC3
      8003C001FF1FFEB9C003C001FF8FFF7DE007F003FFC7FF3DF00FF0FFFFE3FC99
      FC3FFFFFFFF8F9C3FFFFFFFFFFFFF3FF00000000000000000000000000000000
      000000000000}
  end
  object mnuAdd: TPopupMenu
    Left = 120
    Top = 336
    object Company1: TMenuItem
      Caption = '&Company'
      OnClick = Company1Click
    end
    object User1: TMenuItem
      Caption = '&User'
      OnClick = User1Click
    end
    object Authorizer1: TMenuItem
      Caption = '&Authoriser'
      OnClick = Authorizer1Click
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Exchequer forms (*.efx)|*.efx'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoNetworkButton, ofEnableSizing]
    Left = 544
    Top = 320
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 15000
    OnTimer = Timer1Timer
    Left = 648
    Top = 304
  end
  object PopupMenu1: TPopupMenu
    Left = 80
    Top = 336
    object Add1: TMenuItem
      Caption = 'Add'
      object Company2: TMenuItem
        Caption = 'Company'
        OnClick = Company1Click
      end
      object Authoriser1: TMenuItem
        Caption = 'Authoriser'
        OnClick = Authorizer1Click
      end
      object User2: TMenuItem
        Caption = 'User'
        OnClick = User1Click
      end
    end
    object Remove1: TMenuItem
      Caption = 'Remove'
      OnClick = btnRemoveClick
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      OnClick = btnEditClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Help1: TMenuItem
      Caption = '&Help'
      OnClick = Help1Click
    end
    object AboutAuthorise1: TMenuItem
      Caption = '&About Authoris-e'
      OnClick = AboutAuthorise1Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 144
    Top = 32
  end
  object dlgExport: TSaveDialog
    DefaultExt = 'csv'
    FileName = 'Authoris-e Export'
    Filter = 'Csv files (*.csv)|*.csv'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Export Authorisers && Users to Csv file'
    Left = 224
    Top = 280
  end
end
