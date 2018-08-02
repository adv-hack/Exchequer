object Form1: TForm1
  Left = 414
  Top = 237
  ActiveControl = CBEntVer
  BorderStyle = bsSingle
  Caption = 'Exchequer Security Release Code System'
  ClientHeight = 295
  ClientWidth = 559
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  DesignSize = (
    559
    295)
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 559
    Height = 295
    ActivePage = TabShSecPw
    Align = alClient
    TabIndex = 7
    TabOrder = 1
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Exch Security'
      object Label3: TLabel
        Left = 10
        Top = 160
        Width = 67
        Height = 14
        Caption = 'Release Code'
      end
      object Label6: TLabel
        Left = 9
        Top = 130
        Width = 68
        Height = 14
        Caption = 'Security Code'
      end
      object ecRelCode: Text8Pt
        Tag = 101
        Left = 81
        Top = 156
        Width = 150
        Height = 22
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        OnDblClick = PhoneticSecCode
        TextId = 0
        ViaSBtn = False
      end
      object ecSecCode: Text8Pt
        Tag = 1
        Left = 81
        Top = 126
        Width = 150
        Height = 22
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 20
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnDblClick = PhoneticSecCode
        OnExit = ecSecCodeExit
        TextId = 0
        ViaSBtn = False
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Exch Main User Count'
      ImageIndex = 1
      object Label8: TLabel
        Left = 9
        Top = 159
        Width = 68
        Height = 14
        Caption = 'Security Code'
      end
      object Label9: TLabel
        Left = 10
        Top = 189
        Width = 67
        Height = 14
        Caption = 'Release Code'
      end
      object Label10: TLabel
        Left = 29
        Top = 127
        Width = 45
        Height = 14
        Caption = 'No Users'
      end
      object Label85: Label8
        Left = 237
        Top = 189
        Width = 83
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object ecSecCode2: Text8Pt
        Tag = 2
        Left = 81
        Top = 155
        Width = 150
        Height = 22
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 20
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnDblClick = PhoneticSecCode
        OnExit = ecSecCode2Exit
        TextId = 0
        ViaSBtn = False
      end
      object ecRelCode2: Text8Pt
        Tag = 102
        Left = 81
        Top = 185
        Width = 150
        Height = 22
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        OnDblClick = PhoneticSecCode
        TextId = 0
        ViaSBtn = False
      end
      object evNoUsers: TCurrencyEdit
        Left = 82
        Top = 123
        Width = 40
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'ARIAL'
        Font.Style = []
        Lines.Strings = (
          '1 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        OnExit = evNoUsersExit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Modules'
      ImageIndex = 2
      object Label11: TLabel
        Left = 9
        Top = 163
        Width = 68
        Height = 14
        Caption = 'Security Code'
      end
      object Label12: TLabel
        Left = 10
        Top = 193
        Width = 67
        Height = 14
        Caption = 'Release Code'
      end
      object Label13: TLabel
        Left = 35
        Top = 130
        Width = 37
        Height = 14
        Caption = 'Module '
      end
      object ecSecCode3: Text8Pt
        Tag = 3
        Left = 81
        Top = 159
        Width = 150
        Height = 22
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 20
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnDblClick = PhoneticSecCode
        OnExit = ecSecCode3Exit
        TextId = 0
        ViaSBtn = False
      end
      object ecRelCode3: Text8Pt
        Tag = 103
        Left = 81
        Top = 189
        Width = 150
        Height = 22
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        OnDblClick = PhoneticSecCode
        TextId = 0
        ViaSBtn = False
      end
      object CBModNo: TSBSComboBox
        Left = 81
        Top = 126
        Width = 150
        Height = 22
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
        OnChange = CBModNoChange
        Items.Strings = (
          'Multi Currency'
          'Job Costing'
          'Report Writer'
          'DLL Toolkit'
          'TeleSales'
          'A/C Stk Analysis'
          'eBusiness'
          'Paperless'
          'OLE Save'
          'Commitment'
          'Trade Counter'
          'Std Works Orders'
          'Pro Works Orders'
          'Sentimail'
          'Enhanced User Profiles'
          'CIS/RCT'
          'Applications & Valuations'
          'Full Stock Control'
          'Visual Report Writer'
          'Goods Returns'
          'eBanking'
          'Outlook Dynamic Dashboard'
          'Importer'
          'GDPR'
          'Pervasive File Encryption')
        MaxListWidth = 0
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Module User Count'
      ImageIndex = 3
      object Label14: TLabel
        Left = 29
        Top = 127
        Width = 45
        Height = 14
        Caption = 'No Users'
      end
      object Label15: TLabel
        Left = 9
        Top = 159
        Width = 68
        Height = 14
        Caption = 'Security Code'
      end
      object Label16: TLabel
        Left = 10
        Top = 189
        Width = 67
        Height = 14
        Caption = 'Release Code'
      end
      object Label17: TLabel
        Left = 127
        Top = 128
        Width = 37
        Height = 14
        Caption = 'Module '
      end
      object Label83: Label8
        Left = 237
        Top = 189
        Width = 83
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object evNoUsers2: TCurrencyEdit
        Left = 82
        Top = 123
        Width = 40
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'ARIAL'
        Font.Style = []
        Lines.Strings = (
          '1 ')
        MaxLength = 3
        ParentFont = False
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        OnExit = evNoUsers2Exit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1
      end
      object ecSecCode4: Text8Pt
        Tag = 4
        Left = 81
        Top = 155
        Width = 150
        Height = 22
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 20
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnDblClick = PhoneticSecCode
        OnExit = ecSecCode4Exit
        TextId = 0
        ViaSBtn = False
      end
      object ecRelCode4: Text8Pt
        Tag = 104
        Left = 81
        Top = 185
        Width = 150
        Height = 22
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 3
        OnDblClick = PhoneticSecCode
        TextId = 0
        ViaSBtn = False
      end
      object CBModNo2: TSBSComboBox
        Left = 173
        Top = 124
        Width = 150
        Height = 22
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ItemIndex = 1
        ParentFont = False
        TabOrder = 1
        Text = 'DLL Toolkit'
        OnChange = CBModNo2Change
        Items.Strings = (
          'MCM Companies'
          'DLL Toolkit'
          'Trade Counter'
          'Sentimail Sentinels')
        MaxListWidth = 0
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'MCM'
      ImageIndex = 4
      object Label24: TLabel
        Left = 150
        Top = 121
        Width = 51
        Height = 14
        Alignment = taRightJustify
        Caption = 'Plug-In PW'
      end
      object ecPlugInPW: Text8Pt
        Tag = 2
        Left = 208
        Top = 117
        Width = 109
        Height = 22
        TabStop = False
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        OnDblClick = PhoneticPword
        TextId = 0
        ViaSBtn = False
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Plug-In'
      ImageIndex = 5
      object Label18: TLabel
        Left = 9
        Top = 129
        Width = 68
        Height = 14
        Caption = 'Security Code'
      end
      object Label19: TLabel
        Left = 10
        Top = 159
        Width = 67
        Height = 14
        Caption = 'Release Code'
      end
      object ecSecCode5: Text8Pt
        Tag = 5
        Left = 81
        Top = 125
        Width = 150
        Height = 22
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 20
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnDblClick = PhoneticSecCode
        OnExit = ecSecCode5Exit
        TextId = 0
        ViaSBtn = False
      end
      object ecRelCode5: Text8Pt
        Tag = 105
        Left = 81
        Top = 155
        Width = 150
        Height = 22
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        OnDblClick = PhoneticSecCode
        TextId = 0
        ViaSBtn = False
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Plug-In User Count'
      ImageIndex = 6
      object Label21: TLabel
        Left = 29
        Top = 127
        Width = 45
        Height = 14
        Caption = 'No Users'
      end
      object Label22: TLabel
        Left = 9
        Top = 159
        Width = 68
        Height = 14
        Caption = 'Security Code'
      end
      object Label23: TLabel
        Left = 10
        Top = 189
        Width = 67
        Height = 14
        Caption = 'Release Code'
      end
      object Label84: Label8
        Left = 237
        Top = 189
        Width = 83
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object evNoUsers3: TCurrencyEdit
        Left = 82
        Top = 123
        Width = 40
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'ARIAL'
        Font.Style = []
        Lines.Strings = (
          '1 ')
        MaxLength = 2
        ParentFont = False
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        OnExit = evNoUsers3Exit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1
      end
      object ecSecCode6: Text8Pt
        Tag = 6
        Left = 81
        Top = 155
        Width = 150
        Height = 22
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 20
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnDblClick = PhoneticSecCode
        OnExit = ecSecCode6Exit
        TextId = 0
        ViaSBtn = False
      end
      object ecRelCode6: Text8Pt
        Tag = 106
        Left = 81
        Top = 185
        Width = 150
        Height = 22
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        OnDblClick = PhoneticSecCode
        TextId = 0
        ViaSBtn = False
      end
    end
    object TabShSecPw: TTabSheet
      Caption = 'Security Pwords'
      ImageIndex = 7
      object GroupBox1: TGroupBox
        Left = 1
        Top = 117
        Width = 467
        Height = 107
        TabOrder = 0
        object Label25: TLabel
          Left = 7
          Top = 30
          Width = 143
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Resynchronise Companies'
        end
        object Label26: TLabel
          Left = 7
          Top = 54
          Width = 143
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Reset Exchequer User Count'
        end
        object Label27: TLabel
          Left = 7
          Top = 79
          Width = 143
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Reset Plug-In User Counts'
        end
        object Label28: TLabel
          Left = 160
          Top = 11
          Width = 64
          Height = 14
          Caption = 'v5.00 or later'
        end
        object Label29: TLabel
          Left = 261
          Top = 11
          Width = 95
          Height = 13
          AutoSize = False
          Caption = '--> MCM b431.009'
        end
        object Label30: TLabel
          Left = 362
          Top = 11
          Width = 95
          Height = 13
          AutoSize = False
          Caption = 'MCM b431.011 -->'
        end
        object lblv5PwordExpiry: TLabel
          Left = 262
          Top = 81
          Width = 194
          Height = 13
          Alignment = taCenter
          AutoSize = False
        end
        object Label31: TLabel
          Left = 261
          Top = 58
          Width = 80
          Height = 14
          Caption = 'Locked Daily PW'
        end
        object edtResyncComps: Text8Pt
          Tag = 1
          Left = 158
          Top = 27
          Width = 95
          Height = 22
          CharCase = ecUpperCase
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 10
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 0
          OnDblClick = PhoneticSecPwords
          TextId = 0
          ViaSBtn = False
        end
        object edtResetUser: Text8Pt
          Tag = 2
          Left = 158
          Top = 51
          Width = 95
          Height = 22
          CharCase = ecUpperCase
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 10
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 1
          OnDblClick = PhoneticSecPwords
          TextId = 0
          ViaSBtn = False
        end
        object edtResetPlugInUser: Text8Pt
          Tag = 3
          Left = 158
          Top = 76
          Width = 95
          Height = 22
          CharCase = ecUpperCase
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 10
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 2
          OnDblClick = PhoneticSecPwords
          TextId = 0
          ViaSBtn = False
        end
        object edtResyncComps009: Text8Pt
          Tag = 4
          Left = 259
          Top = 27
          Width = 95
          Height = 22
          CharCase = ecUpperCase
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 10
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 3
          OnDblClick = PhoneticSecPwords
          TextId = 0
          ViaSBtn = False
        end
        object edtResyncComps011: Text8Pt
          Tag = 5
          Left = 361
          Top = 27
          Width = 95
          Height = 22
          CharCase = ecUpperCase
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 10
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 4
          OnDblClick = PhoneticSecPwords
          TextId = 0
          ViaSBtn = False
        end
        object ecDailyPW2: Text8Pt
          Tag = 1
          Left = 348
          Top = 54
          Width = 109
          Height = 22
          TabStop = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 5
          OnDblClick = PhoneticPword
          TextId = 0
          ViaSBtn = False
        end
      end
    end
    object TabShVectron: TTabSheet
      Caption = 'Vectron'
      ImageIndex = 8
      object Label32: TLabel
        Left = 9
        Top = 126
        Width = 68
        Height = 14
        Caption = 'Security Code'
      end
      object Label33: TLabel
        Left = 10
        Top = 156
        Width = 67
        Height = 14
        Caption = 'Release Code'
      end
      object ecSecCode8: Text8Pt
        Tag = 8
        Left = 81
        Top = 122
        Width = 150
        Height = 22
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 20
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnDblClick = PhoneticSecCode
        OnExit = ecSecCode8Exit
        TextId = 0
        ViaSBtn = False
      end
      object ecRelCode8: Text8Pt
        Tag = 108
        Left = 81
        Top = 152
        Width = 150
        Height = 22
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        OnDblClick = PhoneticSecCode
        TextId = 0
        ViaSBtn = False
      end
    end
  end
  object Button2: TButton
    Left = 359
    Top = 257
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 2
    OnClick = Button2Click
  end
  object SBSPanel1: TSBSPanel
    Left = 11
    Top = 31
    Width = 540
    Height = 108
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label4: TLabel
      Left = 45
      Top = 54
      Width = 20
      Height = 14
      Caption = 'ESN'
    end
    object Label5: TLabel
      Left = 25
      Top = 29
      Width = 286
      Height = 21
      AutoSize = False
      Caption = 'Please enter the Exchequer Site Number for this site:-'
      WordWrap = True
    end
    object Label1: TLabel
      Left = 33
      Top = 6
      Width = 37
      Height = 14
      Caption = 'Version'
    end
    object Label7: TLabel
      Left = 150
      Top = 86
      Width = 42
      Height = 14
      Caption = 'Daily PW'
    end
    object Label81: Label8
      Left = 319
      Top = 85
      Width = 102
      Height = 14
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label2: TLabel
      Left = 5
      Top = 86
      Width = 63
      Height = 14
      Caption = 'Release type'
    end
    object Label20: TLabel
      Left = 325
      Top = 54
      Width = 58
      Height = 14
      Caption = 'Plug-In SNo.'
      Visible = False
    end
    object lblInstVer: TLabel
      Left = 243
      Top = 54
      Width = 68
      Height = 13
      AutoSize = False
    end
    object meESN1: TMaskEdit
      Left = 75
      Top = 50
      Width = 163
      Height = 22
      EditMask = '999-999-999-999-999-999-999;1;_'
      MaxLength = 27
      TabOrder = 1
      Text = '   -   -   -   -   -   -   '
      OnExit = meESN1Exit
    end
    object CBEntVer: TSBSComboBox
      Left = 77
      Top = 0
      Width = 145
      Height = 22
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ItemIndex = 3
      ParentFont = False
      TabOrder = 0
      Text = 'v5.00 or above'
      OnChange = CBEntVerExit
      Items.Strings = (
        'v4.0 or before'
        'v4.30'
        'v4.31'
        'v5.00 or above')
      MaxListWidth = 0
    end
    object ecDailyPW: Text8Pt
      Tag = 1
      Left = 201
      Top = 82
      Width = 109
      Height = 22
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 4
      OnDblClick = PhoneticPword
      TextId = 0
      ViaSBtn = False
    end
    object CBRelType: TSBSComboBox
      Left = 75
      Top = 82
      Width = 68
      Height = 22
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 3
      OnChange = CBRelTypeExit
      Items.Strings = (
        '30 Days'
        'Full')
      MaxListWidth = 0
    end
    object evPISNo: TCurrencyEdit
      Left = 393
      Top = 49
      Width = 88
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0 ')
      MaxLength = 6
      ParentFont = False
      TabOrder = 2
      Visible = False
      WantReturns = False
      WordWrap = False
      OnExit = evPISNoExit
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0 ;###,###,##0-'
      DecPlaces = 0
      ShowCurrency = False
      TextId = 0
      Value = 1E-10
    end
  end
  object Button1: TButton
    Left = 272
    Top = 257
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'C&lear'
    ModalResult = 2
    TabOrder = 3
    OnClick = Button1Click
  end
  object lstTrustees: TListBox
    Left = 475
    Top = 112
    Width = 77
    Height = 125
    ItemHeight = 14
    Items.Strings = (
      'MARKD6'
      'JWAYGOOD'
      'DRUSTELL'
      'NICK.MCKEOWN'
      'PRIYANKA.PATEL'
      'KOMAL.PARIKH')
    TabOrder = 4
    Visible = False
  end
  object lstReception: TListBox
    Left = 475
    Top = 239
    Width = 76
    Height = 46
    ItemHeight = 14
    Items.Strings = (
      'ABENFIELD'
      'RBEGG'
      'DEMO')
    TabOrder = 5
    Visible = False
  end
  object lstPlugInCrew: TListBox
    Left = 395
    Top = 201
    Width = 76
    Height = 46
    ItemHeight = 14
    Items.Strings = (
      'NFREWER440')
    TabOrder = 6
    Visible = False
  end
end
