object frmOneCompany: TfrmOneCompany
  Left = 185
  Top = 168
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Company Setup'
  ClientHeight = 315
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDefaultPosOnly
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object btnOK: TButton
    Left = 401
    Top = 37
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 401
    Top = 64
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object pgcCompany: TPageControl
    Left = 0
    Top = 0
    Width = 393
    Height = 315
    ActivePage = tabLogs
    Align = alLeft
    TabIndex = 4
    TabOrder = 0
    OnChange = pgcCompanyChange
    object tabEnterprise: TTabSheet
      Caption = 'General'
      DesignSize = (
        385
        286)
      object Label87: Label8
        Left = 5
        Top = 12
        Width = 45
        Height = 14
        Caption = 'Company'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label819: Label8
        Left = 5
        Top = 60
        Width = 49
        Height = 14
        Caption = 'Set Period'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object cbxCompany: TSBSComboBox
        Left = 57
        Top = 8
        Width = 185
        Height = 22
        Color = clGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
        OnChange = cbxCompanyChange
        OnKeyDown = ControlsKeyDown
        OnKeyPress = ControlsKeyPress
        MaxListWidth = 0
      end
      object grpDefaults: TSBSGroup
        Left = 0
        Top = 165
        Width = 385
        Height = 121
        Align = alBottom
        Caption = 'Default import values for missing data'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        AllowReSize = False
        IsGroupBox = True
        TextId = 0
        object Label84: Label8
          Left = 9
          Top = 28
          Width = 57
          Height = 14
          Caption = 'Cost Centre'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label85: Label8
          Left = 11
          Top = 61
          Width = 55
          Height = 14
          Caption = 'Department'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label86: Label8
          Left = 25
          Top = 93
          Width = 41
          Height = 14
          Caption = 'Location'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label814: Label8
          Left = 129
          Top = 28
          Width = 46
          Height = 14
          Caption = 'Customer'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label815: Label8
          Left = 136
          Top = 61
          Width = 39
          Height = 14
          Caption = 'Supplier'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label816: Label8
          Left = 256
          Top = 61
          Width = 47
          Height = 14
          Caption = 'Sales G/L'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label817: Label8
          Left = 257
          Top = 28
          Width = 48
          Height = 14
          Caption = 'Purch G/L'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label823: Label8
          Left = 127
          Top = 93
          Width = 50
          Height = 14
          Caption = 'VAT Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object edtLocation: Text8Pt
          Left = 76
          Top = 88
          Width = 45
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnExit = edtLocationExit
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
        object edtDept: Text8Pt
          Left = 76
          Top = 56
          Width = 45
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnExit = edtDeptExit
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
        object edtCostCentre: Text8Pt
          Left = 76
          Top = 23
          Width = 45
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnExit = edtCostCentreExit
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
        object edtCustomer: Text8Pt
          Left = 186
          Top = 24
          Width = 63
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnExit = edtCustSuppCodeExit
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
        object edtSupplier: Text8Pt
          Left = 186
          Top = 57
          Width = 63
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnExit = edtCustSuppCodeExit
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
        object edtSalesNom: Text8Pt
          Left = 314
          Top = 57
          Width = 47
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          OnExit = edtNomCodeExit
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
        object edtPurchNom: Text8Pt
          Left = 314
          Top = 24
          Width = 47
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnExit = edtNomCodeExit
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
        object cbxVATCodes: TSBSComboBox
          Left = 185
          Top = 88
          Width = 88
          Height = 22
          Color = clGreen
          DropDownCount = 6
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          MaxLength = 1
          ParentFont = False
          TabOrder = 5
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          MaxListWidth = 0
        end
      end
      object chkKeepTransNo: TBorCheck
        Left = 0
        Top = 32
        Width = 285
        Height = 20
        Caption = 'Maintain transaction number on replication (if possible)'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
        TextId = 0
        OnKeyDown = ControlsKeyDown
        OnKeyPress = ControlsKeyPress
      end
      object cbxPeriod: TSBSComboBox
        Left = 57
        Top = 56
        Width = 184
        Height = 22
        Style = csDropDownList
        Color = clGreen
        DropDownCount = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 2
        OnChange = cbxPeriodChange
        OnKeyDown = ControlsKeyDown
        OnKeyPress = ControlsKeyPress
        Items.Strings = (
          'based on transaction date'
          'to current period in Exchequer'
          'manually')
        MaxListWidth = 0
      end
      object pnlPeriodInfo: TPanel
        Left = 240
        Top = 56
        Width = 137
        Height = 25
        Anchors = [akTop, akRight]
        BevelOuter = bvNone
        TabOrder = 3
        Visible = False
        object lblPeriodsPerYear: Label8
          Left = 78
          Top = 4
          Width = 52
          Height = 14
          Caption = '(12 per yr)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label820: Label8
          Left = 8
          Top = 4
          Width = 9
          Height = 14
          Caption = 'to'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object edtPeriod: TEditPeriod
          Left = 24
          Top = 0
          Width = 49
          Height = 22
          AutoSelect = False
          Color = clGreen
          EditMask = '00/0000;0;'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 7
          ParentFont = False
          TabOrder = 0
          Text = '012000'
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          Placement = cpAbove
          EPeriod = 1
          EYear = 100
          ViewMask = '00/0000;0;'
        end
      end
    end
    object tabXML: TTabSheet
      Caption = 'XML'
      ImageIndex = 1
      object grpXMLDirs: TGroupBox
        Left = 0
        Top = 0
        Width = 385
        Height = 113
        Align = alTop
        Caption = 'XML Directories'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label810: Label8
          Left = 45
          Top = 23
          Width = 35
          Height = 14
          Caption = 'Search'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label812: Label8
          Left = 42
          Top = 55
          Width = 38
          Height = 14
          Caption = 'Archive'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label88: Label8
          Left = 64
          Top = 87
          Width = 16
          Height = 14
          Caption = 'Fail'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object edtXMLSearchDir: Text8Pt
          Left = 84
          Top = 19
          Width = 185
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
        object btnArchiveDir: TButton
          Left = 276
          Top = 52
          Width = 80
          Height = 21
          Caption = 'S&earch'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = btnSearchClick
          OnKeyPress = ControlsKeyPress
          OnKeyUp = ControlsKeyDown
        end
        object btnSearchDir: TButton
          Left = 275
          Top = 20
          Width = 80
          Height = 21
          Caption = '&Search'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnSearchClick
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
        end
        object edtXMLArchiveDir: Text8Pt
          Left = 84
          Top = 51
          Width = 185
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
        object btnFailDir: TButton
          Left = 276
          Top = 84
          Width = 80
          Height = 21
          Caption = 'S&earch'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = btnSearchClick
          OnKeyPress = ControlsKeyPress
          OnKeyUp = ControlsKeyDown
        end
        object edtXMLFailDir: Text8Pt
          Left = 84
          Top = 83
          Width = 185
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
      end
      object grpEmailAccount: TGroupBox
        Left = 0
        Top = 113
        Width = 385
        Height = 98
        Align = alClient
        Caption = 'XML E-mails to be received by this user account'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label818: Label8
          Left = 9
          Top = 25
          Width = 71
          Height = 14
          Alignment = taRightJustify
          Caption = 'Account Name'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label89: Label8
          Left = 30
          Top = 54
          Width = 50
          Height = 14
          Alignment = taRightJustify
          Caption = 'Password'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object edtEmailAccount: Text8Pt
          Left = 84
          Top = 21
          Width = 218
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 40
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
        object edtEmailPassword: Text8Pt
          Left = 84
          Top = 50
          Width = 218
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 40
          ParentFont = False
          ParentShowHint = False
          PasswordChar = '*'
          ShowHint = True
          TabOrder = 1
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
      end
      object grpAdmin: TGroupBox
        Left = 0
        Top = 211
        Width = 385
        Height = 75
        Align = alBottom
        Caption = 'Administrator Notification'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object Label821: Label8
          Left = 19
          Top = 49
          Width = 61
          Height = 14
          Alignment = taRightJustify
          Caption = 'Admin E-mail'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label822: Label8
          Left = 17
          Top = 20
          Width = 62
          Height = 14
          Caption = 'Notify admin.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object edtAdminEmail: Text8Pt
          Left = 84
          Top = 45
          Width = 218
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 100
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
        object cbxNotifyAdmin: TSBSComboBox
          Left = 84
          Top = 16
          Width = 184
          Height = 22
          Style = csDropDownList
          Color = clGreen
          DropDownCount = 3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 1
          OnChange = cbxPeriodChange
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          Items.Strings = (
            'never'
            'of exchange XML transactions'
            'of all XML transactions')
          MaxListWidth = 0
        end
      end
    end
    object tabDragNet: TTabSheet
      Caption = 'Dr@gNet'
      ImageIndex = 3
      object Label81: Label8
        Left = 9
        Top = 13
        Width = 72
        Height = 14
        Caption = 'Dr@gNet Code'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object grpNumbering: TSBSGroup
        Left = 0
        Top = 192
        Width = 385
        Height = 94
        Align = alBottom
        Caption = 'Transaction Numbering'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = True
        TextId = 0
        object Label82: Label8
          Left = 21
          Top = 26
          Width = 59
          Height = 14
          Caption = 'Order Prefix'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label83: Label8
          Left = 39
          Top = 61
          Width = 41
          Height = 14
          Caption = 'Starts at'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object edtOrderPrefix: Text8Pt
          Left = 87
          Top = 22
          Width = 41
          Height = 22
          Color = clGreen
          EditMask = '>LLL;0; '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 3
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
        object chkUseAsOurRef: TBorCheck
          Left = 202
          Top = 18
          Width = 127
          Height = 20
          Caption = 'Use as Our Ref ?'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 2
          TextId = 0
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
        end
        object edtStartsAt: TMaskEdit
          Left = 87
          Top = 57
          Width = 81
          Height = 21
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
        end
      end
      object chkUseCatalogues: TBorCheck
        Left = 144
        Top = 8
        Width = 108
        Height = 20
        Caption = 'Use Catalogues ?'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
        TextId = 0
        OnKeyDown = ControlsKeyDown
        OnKeyPress = ControlsKeyPress
      end
      object edtDragNetCode: Text8Pt
        Left = 87
        Top = 9
        Width = 25
        Height = 22
        Color = clGreen
        EditMask = '>A;0; '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 1
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnKeyDown = ControlsKeyDown
        OnKeyPress = ControlsKeyPress
        TextId = 0
        ViaSBtn = False
      end
    end
    object tabPosting: TTabSheet
      Caption = 'Posting'
      ImageIndex = 4
      object grpHoldOptions: TGroupBox
        Left = 0
        Top = 197
        Width = 385
        Height = 89
        Align = alBottom
        Caption = 'Posting Options'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object chkWarningPersists: TBorCheck
          Left = 24
          Top = 46
          Width = 233
          Height = 20
          Caption = 'Transactions with "Warnings" post on "Hold"'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          TextId = 0
        end
        object chkHoldPersists: TBorCheck
          Left = 48
          Top = 22
          Width = 209
          Height = 20
          Caption = 'Transactions on "Hold" post on "Hold"'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 1
          TextId = 0
        end
      end
    end
    object tabLogs: TTabSheet
      Caption = 'Logs'
      ImageIndex = 4
      object GroupBox1: TGroupBox
        Left = 0
        Top = 198
        Width = 385
        Height = 88
        Align = alBottom
        Caption = 'Log Directories'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label811: Label8
          Left = 25
          Top = 23
          Width = 29
          Height = 14
          Caption = 'Import'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label813: Label8
          Left = 19
          Top = 55
          Width = 35
          Height = 14
          Caption = 'Posting'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object edtImportLogDir: Text8Pt
          Left = 64
          Top = 19
          Width = 185
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
        object btnImportLogDir: TButton
          Left = 255
          Top = 20
          Width = 80
          Height = 21
          Caption = '&Search'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnSearchClick
        end
        object btnPostingLogDir: TButton
          Left = 256
          Top = 52
          Width = 80
          Height = 21
          Caption = 'S&earch'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btnSearchClick
        end
        object edtPostLogDir: Text8Pt
          Left = 64
          Top = 51
          Width = 185
          Height = 22
          Color = clGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnKeyDown = ControlsKeyDown
          OnKeyPress = ControlsKeyPress
          TextId = 0
          ViaSBtn = False
        end
      end
    end
  end
  object btnDefaultDirs: TButton
    Left = 401
    Top = 91
    Width = 80
    Height = 21
    Hint = 'Automatically set-up required directories.'
    Cancel = True
    Caption = '&Default Dirs'
    TabOrder = 3
    OnClick = btnDefaultDirsClick
  end
end
