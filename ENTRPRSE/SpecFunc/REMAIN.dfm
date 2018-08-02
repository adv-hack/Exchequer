object MainForm: TMainForm
  Left = 433
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Special Functions - For Exchequer Accounting System.'
  ClientHeight = 381
  ClientWidth = 630
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object MainPnl: TPanel
    Left = 190
    Top = 0
    Width = 440
    Height = 381
    Align = alClient
    TabOrder = 0
    object PageControl: TPageControl
      Left = 1
      Top = 34
      Width = 438
      Height = 312
      ActivePage = SelectFunctionPage
      Align = alClient
      TabOrder = 0
      object SelectOptionPage: TTabSheet
        Caption = 'SelectOptionPage'
        ImageIndex = 1
        TabVisible = False
        object OptionGroup: TRadioGroup
          Left = 0
          Top = 4
          Width = 429
          Height = 297
          Caption = 'Options'
          TabOrder = 0
        end
      end
      object SelectFunctionPage: TTabSheet
        Caption = 'SelectFunctionPage'
        TabVisible = False
        object Panel1: TPanel
          Left = 0
          Top = 273
          Width = 430
          Height = 29
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 0
          object Label1: TLabel
            Left = 6
            Top = 8
            Width = 163
            Height = 13
            AutoSize = False
            Caption = 'Choose by Special Function No.'
          end
          object FunctionMsgLbl: TLabel
            Left = 216
            Top = 8
            Width = 209
            Height = 14
            Alignment = taRightJustify
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object edtFuncNo: TEdit
            Left = 164
            Top = 4
            Width = 45
            Height = 22
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = '0'
            OnChange = edtFuncNoChange
          end
        end
        object FuncsPageControl: TPageControl
          Left = 0
          Top = 0
          Width = 430
          Height = 273
          ActivePage = CustomFuncsPage
          Align = alClient
          TabIndex = 1
          TabOrder = 1
          OnChange = FuncsPageControlChange
          object FuncsPage: TTabSheet
            Caption = 'General'
            object FuncsList: TListBox
              Left = 0
              Top = 0
              Width = 422
              Height = 244
              Style = lbOwnerDrawFixed
              Align = alClient
              Color = clWhite
              ExtendedSelect = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -9
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 0
              OnClick = FuncsListClick
              OnDblClick = FuncsListDblClick
              OnDrawItem = FuncsListDrawItem
            end
          end
          object CustomFuncsPage: TTabSheet
            Caption = 'Custom'
            ImageIndex = 1
            object CustomFuncsList: TListBox
              Left = 0
              Top = 0
              Width = 422
              Height = 244
              Style = lbOwnerDrawFixed
              Align = alClient
              Color = clWhite
              ExtendedSelect = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -9
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
              ParentFont = False
              TabOrder = 0
              OnClick = FuncsListClick
              OnDblClick = FuncsListDblClick
              OnDrawItem = FuncsListDrawItem
            end
          end
        end
      end
      object SelectFilesPage: TTabSheet
        Caption = 'SelectFilesPage'
        ImageIndex = 3
        TabVisible = False
        object FileList: TCheckListBox
          Left = 0
          Top = 0
          Width = 430
          Height = 276
          Align = alClient
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 0
          OnClick = FileListClick
        end
        object Panel3: TPanel
          Left = 0
          Top = 276
          Width = 430
          Height = 26
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object AllFilesBtn: TButton
            Left = 0
            Top = 4
            Width = 80
            Height = 21
            Caption = '&All'
            TabOrder = 0
            OnClick = AllFilesBtnClick
          end
          object NoFilesBtn: TButton
            Left = 84
            Top = 4
            Width = 80
            Height = 21
            Caption = 'N&one'
            TabOrder = 1
            OnClick = NoFilesBtnClick
          end
        end
      end
      object PurgeOrdersPage: TTabSheet
        Caption = 'PurgeOrdersPage'
        ImageIndex = 6
        TabVisible = False
        object Label83: Label8
          Left = 12
          Top = 44
          Width = 121
          Height = 14
          Alignment = taRightJustify
          Caption = 'Purge up to and including'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label84: Label8
          Left = 9
          Top = 81
          Width = 124
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Include Account :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label85: Label8
          Left = 208
          Top = 81
          Width = 89
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Exclude Account :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label86: Label8
          Left = 9
          Top = 117
          Width = 124
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Include Account type :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label87: Label8
          Left = 206
          Top = 117
          Width = 92
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Excl Account type:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label2: TLabel
          Left = 0
          Top = 0
          Width = 430
          Height = 28
          Align = alTop
          AutoSize = False
          Caption = 
            ' Warning! The Purge process is destructive and purged data will ' +
            'be permanently deleted.   Ensure you have a full Exchequer backu' +
            'p before committing to this process.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object edtPOYear: TEditPeriod
          Left = 137
          Top = 40
          Width = 66
          Height = 22
          AutoSelect = False
          Color = clWhite
          EditMask = '00/0000;0;'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 7
          ParentFont = False
          TabOrder = 0
          Text = '011996'
          Placement = cpAbove
          EPeriod = 1
          EYear = 96
          ViewMask = '00/0000;0;'
        end
        object edtPOIncludeAcct: Text8Pt
          Left = 137
          Top = 76
          Width = 66
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnExit = edtPOIncludeAcctExit
          TextId = 0
          ViaSBtn = False
        end
        object edtPOExcludeAcct: Text8Pt
          Left = 299
          Top = 76
          Width = 66
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          TextId = 0
          ViaSBtn = False
        end
        object edtPOIncludeType: Text8Pt
          Left = 137
          Top = 112
          Width = 66
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          TextId = 0
          ViaSBtn = False
        end
        object edtPOExcludeType: Text8Pt
          Left = 299
          Top = 112
          Width = 66
          Height = 22
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          TextId = 0
          ViaSBtn = False
        end
        object POShrinkChk: TBorCheck
          Left = 51
          Top = 149
          Width = 98
          Height = 20
          Caption = 'Shrink File Size'
          CheckColor = clWindowText
          Color = clBtnFace
          ParentColor = False
          TabOrder = 5
          TabStop = True
          TextId = 0
        end
      end
      object PurgeAccountsPage: TTabSheet
        Caption = 'PurgeAccountsPage'
        ImageIndex = 5
        TabVisible = False
        object Label82: Label8
          Left = 11
          Top = 44
          Width = 165
          Height = 14
          Alignment = taRightJustify
          Caption = 'Purge all years up to and including'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label4: TLabel
          Left = 0
          Top = 0
          Width = 430
          Height = 28
          Align = alTop
          AutoSize = False
          Caption = 
            ' Warning! The Purge process is destructive and purged data will ' +
            'be permanently deleted.   Ensure you have a full Exchequer backu' +
            'p before committing to this process.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object PAShrinkChk: TBorCheck
          Left = 25
          Top = 227
          Width = 166
          Height = 20
          Caption = 'Shrink file sizes after purge'
          CheckColor = clWindowText
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          TabStop = True
          TextId = 0
        end
        object PARemoveCustomersChk: TBorCheck
          Left = 8
          Top = 77
          Width = 183
          Height = 20
          Caption = 'Remove empty Customer records'
          CheckColor = clWindowText
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          TabStop = True
          TextId = 0
        end
        object PARemoveSuppliersChk: TBorCheck
          Left = 13
          Top = 165
          Width = 178
          Height = 20
          Caption = 'Remove empty Supplier records'
          CheckColor = clWindowText
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
          TabStop = True
          TextId = 0
        end
        object PARemoveStockChk: TBorCheck
          Left = 18
          Top = 107
          Width = 173
          Height = 20
          Caption = 'Remove empty Stock records'
          CheckColor = clWindowText
          Color = clBtnFace
          ParentColor = False
          TabOrder = 3
          TabStop = True
          TextId = 0
        end
        object PARemoveLocationsChk: TBorCheck
          Left = 13
          Top = 195
          Width = 178
          Height = 20
          Caption = 'Remove empty Location records'
          CheckColor = clWindowText
          Color = clBtnFace
          ParentColor = False
          TabOrder = 4
          TabStop = True
          TextId = 0
        end
        object PARemoveSerialChk: TBorCheck
          Left = 18
          Top = 135
          Width = 173
          Height = 20
          Caption = 'Remove used Serial records'
          CheckColor = clWindowText
          Color = clBtnFace
          ParentColor = False
          TabOrder = 5
          TabStop = True
          TextId = 0
        end
        object PAYearSpin: TUpDown
          Left = 221
          Top = 40
          Width = 17
          Height = 22
          Associate = edtPAYear
          Min = 1950
          Max = 2049
          Position = 1999
          TabOrder = 6
          Thousands = False
          Wrap = False
        end
        object PAErrorTxt: TStaticText
          Left = 0
          Top = 284
          Width = 430
          Height = 18
          Align = alBottom
          AutoSize = False
          BorderStyle = sbsSunken
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object edtPAYear: TMaskEdit
          Left = 188
          Top = 40
          Width = 33
          Height = 22
          Color = clWhite
          EditMask = '9999;1;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 4
          ParentFont = False
          TabOrder = 8
          Text = '1999'
          OnChange = edtPAYearChange
          OnExit = edtPAYearExit
        end
      end
      object PasswordPage: TTabSheet
        Caption = 'Password'
        ImageIndex = 7
        TabVisible = False
        object lblPassword: TLabel
          Left = 72
          Top = 112
          Width = 50
          Height = 14
          Caption = 'Password'
        end
        object lblPasswordRequired: TLabel
          Left = 8
          Top = 4
          Width = 413
          Height = 33
          AutoSize = False
          Caption = 
            'A password is required to activate this function. Please contact' +
            ' your technical support, quoting the security code below in orde' +
            'r to obtain the password.'
          WordWrap = True
        end
        object lblDebugResponse: TLabel
          Left = 132
          Top = 136
          Width = 90
          Height = 14
          Caption = 'lblDebugResponse'
        end
        object lblSecurityCode: TLabel
          Left = 56
          Top = 80
          Width = 67
          Height = 14
          Caption = 'Security code'
        end
        object lblPhonetic: TLabel
          Left = 212
          Top = 78
          Width = 11
          Height = 14
          Caption = '( )'
        end
        object edtResponse: TMaskEdit
          Left = 132
          Top = 108
          Width = 112
          Height = 22
          Color = clWhite
          EditMask = '>ccc-ccc-ccc-ccc;0;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 15
          ParentFont = False
          TabOrder = 0
          OnChange = edtResponseChange
        end
        object lblChallenge: TStaticText
          Left = 132
          Top = 78
          Width = 73
          Height = 18
          AutoSize = False
          BorderStyle = sbsSunken
          TabOrder = 1
        end
      end
      object ProcessPage: TTabSheet
        Caption = 'ProcessPage'
        ImageIndex = 2
        TabVisible = False
        object ReadyToProcessLbl: TLabel
          Left = 0
          Top = 271
          Width = 243
          Height = 14
          Align = alBottom
          Caption = 'Click the finish button to apply the special function.'
        end
        object FunctionLbl: TLabel
          Left = 4
          Top = 4
          Width = 581
          Height = 14
          AutoSize = False
          Caption = 'Special function'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object InfoLbl: Label8
          Left = 16
          Top = 24
          Width = 409
          Height = 237
          AutoSize = False
          Caption = 'InfoLbl'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          WordWrap = True
          TextId = 0
        end
        object ProgressBar: TProgressBar
          Left = 0
          Top = 285
          Width = 430
          Height = 17
          Align = alBottom
          Min = 0
          Max = 100
          TabOrder = 0
        end
      end
      object ReportPage: TTabSheet
        Caption = 'ReportPage'
        ImageIndex = 4
        TabVisible = False
        object RichEdit1: TRichEdit
          Left = 0
          Top = 0
          Width = 430
          Height = 302
          Align = alClient
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
          WantTabs = True
          WordWrap = False
        end
      end
      object InfoPage: TTabSheet
        Caption = 'InfoPage'
        ImageIndex = 8
        TabVisible = False
        object edtInfo: TRichEdit
          Left = 0
          Top = 0
          Width = 430
          Height = 302
          Align = alClient
          BorderStyle = bsNone
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 438
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 1
      object PageTitleLbl: TLabel
        Left = 4
        Top = 8
        Width = 84
        Height = 16
        Caption = 'Select option'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object ButtonPnl: TPanel
      Left = 1
      Top = 346
      Width = 438
      Height = 34
      Align = alBottom
      TabOrder = 2
      object NavButtonPnl: TPanel
        Left = 184
        Top = 1
        Width = 253
        Height = 32
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object BackBtn: TButton
          Left = 2
          Top = 6
          Width = 80
          Height = 21
          Caption = '< &Back'
          Enabled = False
          TabOrder = 0
          OnClick = BackBtnClick
        end
        object NextBtn: TButton
          Left = 86
          Top = 6
          Width = 80
          Height = 21
          Caption = '&Next >'
          TabOrder = 1
          OnClick = NextBtnClick
        end
        object CancelBtn: TButton
          Left = 170
          Top = 6
          Width = 80
          Height = 21
          Caption = '&Close'
          TabOrder = 2
          OnClick = CancelBtnClick
        end
      end
      object SaveBtn: TButton
        Left = 4
        Top = 8
        Width = 80
        Height = 21
        Caption = '&Save'
        TabOrder = 1
        Visible = False
        OnClick = SaveBtnClick
      end
    end
  end
  object ImagePnl: TPanel
    Left = 0
    Top = 0
    Width = 190
    Height = 381
    Align = alLeft
    TabOrder = 1
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 188
      Height = 379
      Align = alClient
      Picture.Data = {
        07544269746D617036210100424D36210100000000003604000028000000BE00
        00007C0100000100080000000000001D01001F2E00001F2E0000000100000000
        00008C6A5F009270660095756A0099776D003F8E2B003F923600428A03004594
        07005098160048A112006B953B003FAC62003FB26E003FBA7B0040AA620040B5
        7500BF8D5A0082A458009D807500A2817700A3877C00A5897F00BF9F7F0084AF
        6C009AB77C00C18E5B00C2905E00C4946300C6986600C8986700CA9C6C00C099
        7300CEA17100C6A17D00CFA77A00D0A57600D1A77800D4AB7C00EFCE7F00EED0
        7F00F0D37B00F1D67B00F0D27E00F0D57E00F1D97A00F1D97E003FC084003FC6
        8C004AC892006CCFA3006ED3A70077D2A900AE8D8300B3928600B6958B00BA9B
        8F00A29F9D00B59B91009BBB85009CBD8800BBA29800BCB8B600BEBBB900C09F
        9500C4A28100CBA98600CBAC8900D6AE8000D7B08100D9B38400D1B08C00DBB6
        8800DEBA8B00C0A09500CAAF9100C2A49900CAB39A00D1B59300D6BA9700DABC
        9400D0B79E00D4BB9B00D8BE9B00E0BD8F00E1BE9000C3ABA100CAB3A400CEBA
        A400C7B2AA00CBB3A900C3BCAD00CBBBAA00D0B0A400D2BCA300D1BEA900DCBC
        AF00C4BDB100C9BEB100C1BEBB00CABFBB00B1C1910099DABB00DCC29D00EFCF
        8000EED08000F0D28000F0D58000F1D68400F1D98000F2D98500F2DC8600F1D7
        8B00F2DB8B00E3C29400E5C69800E6C89A00E9CB9D00F2DB9300F2DC9900F3E0
        9D00CFC0AB00D6C1A300DCC4A200DFC8A600D4C2AB00D8C5A800DDCBAD00C9D0
        AE00C6C0B500CCC3B400C6C1BC00CBC3BB00CEC8BD00D2C4B400DCC2B500D4C9
        B200DACCB300D2C3BB00DAC3BA00D3CBBC00DDCABD00C9D3B200DDD0B000D4D7
        BD00D9D0BC00E6CDA300EACEA000E2CCA900ECD2A400E4D0AD00EED5A800EDD9
        AB00F3DDA300F0D7A900F3DEAA00E2C3B600E6C8B600E3C5B900E5C9BB00E8CC
        BD00E4D3B100E7D9B700EBDBB300E4D5BD00E7DABD00E8DBBC00F3DFB000F3DE
        BA00F4E0A400F3E0AD00F4E1B300F4E3BB009EE0C200BBE1CD00CBC5C100CDC9
        C300CECACA00D3C6C000D3CBC300DCCBC300D2CDCA00DACEC900D6D0C400DAD3
        C400D4D8C000D4D0CC00DCD4CA00DED8CD00D5D2D100DAD5D200DCD8D500DDDA
        D900E6CCC100E8CEC200E1CFC800E3D5C500E9D1C500E4D9C300E8DCC300E1D3
        CC00EAD4CA00E2DBCC00ECD9CE00F2DEC600F0DDCD00E1D6D000E3DBD300EDDA
        D200E4DDDA00E8DED900F0DED500F0DFD800C4E1D100C1E9D600E7E0CF00EAE1
        CD00F5E5C100F6E8C400F8E9C600F2E3CC00F6E9CA00F8EACC00E6E0D300EAE3
        D400EFE8D700E5E0DD00EAE3DB00EEE8DB00F1E1D400F5EAD200F8ECD300F2E2
        DB00F2EBDC00F8EED900F9F0DD00D8EFE300E5E2E100EBE5E200EEE8E500EDEA
        E900F3E6E000F4EBE300F4EDE900F8EEE800E4F2EA00F6F0E300FAF2E400F4F0
        EE00FBF5EA00FCF8EE00FCF8EF00F6F2F100F9F5F300FBF8F400FCF9F8000000
        0000FAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFDFAFAFAFAFAFAFAFAFAFA
        FAFAFAFAFAFAFAFAFAFAFAFDFAFAFDFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFA
        FAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFA
        FAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFA
        FAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFA
        FAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF9FAFAFA
        0000F9F9F8F9F9F8F9F9F8F9F9F9F8F9F8FAF9F9F9F9F9F9F9F9F9F9F9F9F9F9
        FAFAFAFAFAF9F9F9FAFAF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F8
        F9F8F9F9F8F9F9F8F9F9F8F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9
        F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F8FAF9F8F9F9F8F9
        F8F9F9F8F9F9F8F9F8F9F9F8F9F8F9F8F9F8F9F8F9F8F9F8F9F8F9F8F9F8F9F8
        F9F8F9F8F9F8F9F8F9F8F9F8F9F8F9F8F8F9F8F8F9F8F8F9F8F9F8F8F8F8F8F8
        0000F9F9F8F9F9F8F9F9F8F9F8F9F9F8F9F9F8F9F8F9F8F9F8F9F8F9F8F9F8F9
        F9F9F9F9F9F9F9F9F9F9F9F8F8F9F8F9F8F9F8F9F8F9F8F8F9F8F8F9F8F8F9F8
        F9F9F8F9F9F8F9F9F8F9F9F8F9F8F9F8F9F8F8F9F8F8F9F8F9F8F9F8F9F8F9F8
        F8F9F8F9F8F8F9F8F8F9F8F8F9F8F8F9F8F8F9F8F8F9F8F9F8F9F8F9F9F8F9F9
        F8F9F9F8F9F8F9F9F8F9F8F9F8F9F8F9F8F9F8F9F8F9F8F9F8F9F8F9F8F9F8F9
        F8F9F8F9F8F9F8F9F8F9F8F9F8F9F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        0000F9F8F9F8F9F9F8F9F8F9F8F8F9F9F8F9F9F8F9F9F8F9F9F8F9F9F8F9F9F8
        F9F9F8F9F9F9F9F9F9F9F8FAF8F9F9F8F9F9F8F9F9F8FAF8F9F8F9F8F9F8F9F8
        F9F8F9F8F8F9F9F8F9F9F8F9F9F8F9F8F9F9F8F9F9F8F9F9F8F9F9F8F9F9F8FA
        F9F8F9F9F8F9F9F8F9F8FAF8F9F8F9F9F8F9F9F8F9F9F8F9F9F8F9F8F9F9F8F9
        F9F8F8F9F8F9F8F8F9F8F9F8F9F8F8F8F8F9F8F9F8F8F9F8F9F8F9F8F8F8F9F8
        F9F8F8F8F9F8F9F8F8F8F8F8F9F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        0000F8F9F8F9F8F9F8F8F9F8F8F9F8F8F9F8F9F9F8F9F9F8F9F9F8F9F9F8F9F9
        F8F9F9F8F9F8F9F8F8F9F8F9F9F8F9F9F8F9F9F8F9F9F8F9F9F8F8F9F8F9F8F9
        F8F8F9F8F8F9F8F8F8F9F8F8F9F8F8F9F8F9F9F8F9F9F8F9F9F8F9F9F8F9F9F8
        F9F9F8F9F8F8F9F9F8F8F9F8F9F8F8F9F8F9F8F9F8F9F8F8F9F8F8F8F8F8F9F8
        F8F9F8F8F8F9F8F9F8F8F8F8F8F8F9F8F8F8F8F8F8F9F8F8F8F8F8F8F9F8F8F8
        F8F8F9F8F8F8F8F8F9F8F8F8F8F8F8F8F8F8F8F8F6F8F6F8F8F8F8F8F8F8F8F8
        0000F8F9F8F9F8F9F8F9F8F9F8F8F8F9F8F9F9F8F9F8F9F9F8F9F9F8F9F9F8F9
        F9F8F9F9F8F9F9F8F9F9F8F9F8F9F9F8F9F9F8F9F8F9F8F9F8F8F9F8F8F9F8F8
        F8F9F8F9F8F9F8F8F9F8F8F9F8F8F8F8F8F8F8F8F8F8F9F8F9F8F9F8F9F8F9F8
        F9F8F9F8F8F9F8F9F8F9F8F9F8F9F8F8F9F8F9F8F9F8F8F9F8F9F8F9F8F8F8F8
        F9F8F9F8F9F8F8F8F8F9F8F8F9F8F8F9F8F8F9F8F8F8F8F9F8F8F9F8F8F9F8F8
        F9F8F8F9F8F8F8F9F8F8F8F8F8F8F8F8F8F8F6F8F8F6F8F8F6F8F6F8F8F6F8F8
        0000F9F8F9F8F9F8F8F9F8F8F8F8F9F8F9F8F9F8F9F8F9F8F9F9F8F9F9F8F9F9
        F8F9F9F8F9F9F8F9F9F8F9F9F8F9F8F9F9F8F9F8F9F8F9F8F9F8F8F8F9F8F8F9
        F8F8F9F8F9F8F9F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F9F8F9F8
        F8F8F9F8F9F8F9F8F8F8F9F8F8F8F9F8F8F8F9F8F8F8F9F8F9F8F8F8F9F8F8F9
        F8F8F8F8F8F8F8F8F8F8F9F8F8F8F8F8F9F8F8F8F8F8F8F8F9F8F8F8F8F8F9F8
        F8F8F8F8F9F8F8F8F8F8F8F8F8F8F8F8F6F8F8F6F8F8F6F8F8F6F8F6F8F8F6F8
        0000F8F8F8F8F8F8F8F8F8F8F8F9F8F8F8F9F8F8F8F8F9F8F8F8F9F8F8F9F8F9
        F8F9F9F8F8F9F9F8F9F8F8F9F8F9F8F8F8F9F8F9F8F8F8F9F8F8F9F8F8F8F9F8
        F8F9F8F8F8F8F8F8F8F8F8F8F8F8F8F8F3F8F8F3F8F8F8F8F8F8F8F8F8F8F8F8
        F9F8F8F8F8F8F8F8F9F8F8F8F9F8F8F8F9F8F8F8F9F8F8F8F8F8F9F8F8F9F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F6F8F6F8F6F8F6F8F6F8F8F8F6F8F8F6
        0000F8F8F8F8F8F8F8F8F8F8F8F8F9F8F9F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F9F8F8F9F8F8F8F8F9F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F3F8F5F8F5F8F3F8F5F3F8F5F8F3F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6
        0000F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F9F8F8F8F8F9F8F8F8F9F8F8F8F9
        F8F8F8F9F8F8F9F8F8F9F8F9F8F8F9F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F3F8F5F8F5F2F5F5F5F5F2F5F5F2F5F8F5F3F8F8F5F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8
        0000F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F9F8F8
        F8F8F8F8F8F9F8F8F9F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F5F8F5F5F2F5F5F2F1F2F5F5F2F5F5F5F5F5F5F5F8F5F8F5
        F8F6F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8
        0000F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F9F8F8F9F8F8F8F8F8F8F9F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F6F8F5F5F2F5F1F1F1F1E8EEE3E3F1E8EFF1F1F5F5F5F5F5F5F8
        F5F8F8F5F8F8F8F6F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F6F8F8F8F8F8F8F8F6F8F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F6F8F6F8F6
        0000F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F9F8F8F8F9F8F8F8F9F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F6F8F5F2F5F5F5F1E8EDE3E3EDE3E3E3E3E3E3E3EEE8F1EFF5F5F5F5
        F5F5F8F5F8F5F8F8F8F6F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F6F8F8F8F8F8F8F8F8F8F6F8F8F8F6
        F8F8F8F8F8F8F6F8F8F8F8F8F6F6F8F6F6F8F6F6F8F6F6F8F6F8F6F8F6F6F8F6
        0000F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F5F8F5F5F1F1EEE3E3E3E2E2DFE2DEE1E2E2E2E3E3E3E3E3F1EEF1F1
        F2F5F5F5F2F6F5F8F5F8F8F3F8F8F6F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F6F8F8F8F8F8F8F6F8F8F8F8F6F8
        F8F8F8F6F8F8F8F6F8F8F8F6F8F6F6F8F6F6F8F6F6F8F6F6F8F6F8F6F6F8F6F8
        0000F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F6F3F8F5F5F1F1E3E3E3E2DEE1DECECECECECEDEDEDEE1E2E2E3E3E3E3EE
        E8F1F1F5F5F2F5F3F5F6F5F8F3F8F8F6F8F8F6F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F6F8F8F8F8F8F8F6F8F8F8F8F6F8F8F8F8F6F8F8F8F8F6
        F8F8F8F8F6F8F8F8F6F8F8F6F6F6F8F6F6F8F6F6F8F6F6F8F6F6F8F6F8F6F6F6
        0000F8F8F8F6F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F6F8F6F5F5F5F1F1E3E3E2DEDECEBBB9BABBBBBBBBBEBBCEC9DEDEDEE2E2E3E3
        E3E3E8EEF5E8F5F5F5F2F6F5F6F5F8F5F8F6F8F6F8F8F8F6F8F8F8F6F8F8F8F6
        F8F8F8F6F8F8F8F6F8F8F8F8F6F8F8F6F8F8F6F8F8F8F8F6F8F6F8F8F6F8F6F8
        F8F6F8F8F8F6F8F6F8F8F6F8F6F6F6F6F6F6F6F6F8F6F6F8F6F6F6F6F8F6F6F6
        0000F8F8F8F8F6F8F8F8F8F8F8F6F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F6F8F8F8F8F8F6
        F8F6F3F5F5F1F1E3E3E2DECECEBBB9F7EDBEB9B6B6BABABABBBBBECECEDEDEE2
        E2E2E3E3E3EEE8F1F5F5F5F5F2F6F5F8F3F6F8F8F6F8F8F8F6F8F8F8F8F6F8F8
        F8F8F6F8F8F8F8F8F6F8F8F8F8F6F8F8F6F8F6F8F8F8F6F8F8F8F6F8F8F6F8F8
        F6F8F8F6F8F6F8F6F8F6F8F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6
        0000F8F8F8F6F8F8F8F8F6F8F8F8F8F6F8F8F6F8F8F8F8F8F8F8F8F6F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F6F8F8F8F8F8F8F8F8F8F6F8F8F8F6F8F8F8F8F6F8F6
        F8F5F5F5F5F1E3E3E2DECEBBBBB4EECED0F7FCEFBEAFB2B6B6B9BABBBBBBCECE
        DEDEE2E2E3E3E3E3E8EEF1F5F5F5F5F5F5F3F6F6F8F6F8F8F8F6F8F8F8F8F6F8
        F8F8F8F6F8F8F8F6F8F8F8F6F8F8F6F8F8F6F8F6F8F6F8F8F6F8F8F6F8F8F6F8
        F6F8F6F6F8F6F6F8F6F8F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6
        0000F8F8F6F8F8F8F6F8F8F8F8F6F8F8F8F8F8F6F8F8F8F6F8F8F8F8F6F8F8F8
        F6F8F8F8F6F8F8F8F6F8F8F8F8F6F8F8F8F6F8F8F8F8F6F8F8F8F8F6F8F8F6F6
        F6F5F5F5EEE3E3E2DECEBBBAB0E2C79B9B8AB5ECFBFEEDBEAFAFB6B6B6BABBBB
        BBCEDEDEDEE2E2E3E3E3E3E8F1E8F1F5F5F5F5F6F5F8F3F8F6F8F8F8F8F6F8F8
        F6F8F6F8F8F6F8F8F6F8F6F8F6F8F6F8F6F8F8F8F6F8F8F6F8F6F8F6F8F6F8F6
        F6F8F6F8F6F8F6F8F6F6F8F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6
        0000F8F6F8F8F8F6F8F8F8F8F6F8F8F8F8F6F8F8F8F8F6F8F8F8F8F6F8F8F8F8
        F8F6F8F8F8F8F6F8F8F8F8F6F8F8F8F8F6F8F8F8F8F6F8F8F8F8F6F8F8F6F8F6
        F5F5F5E8E3E3E2DEBBBBB6B2BECE869B9B9B9B9B8AC2ECFCFEEDBDAFAFB6B6B6
        BABABBBBCECEDEDEE2E2E3E3E3E8F1F1E8F5F5F5F6F6F6F6F8F6F8F6F8F8F6F8
        F8F6F8F6F8F6F6F8F6F6F6F6F8F5F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8
        F6F6F6F6F6F6F6F6F6F8F6F6F6F6EAF6F6F6F6F6F6EAF6F6F6F6F6F6F6F6F6F6
        0000F8F8F6F8F8F6F8F6F8F8F6F8F6F8F6F8F8F6F8F6F8F8F6F8F6F8F8F6F8F8
        F8F8F6F8F8F8F8F6F8F8F8F8F6F8F8F8F8F6F8F6F8F8F6F8F6F8F8F6F8F6F6F5
        F6F5F1E3E3E2DECEBBB7B6B9D18A9B9B9B9B9B9B9B9B9B8AC7ECFCFEEDBCAEB2
        B6B6B6BABBBBBBCEDEDEDEE2E2E3E3E3F1F1F1F5F5F5F8F5F6F8F6F8F6F8F8F6
        F8F6F8F6F6F6F8F6F5F6F6F6F6F6F8F5F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8
        F6F8F6F8F6F8F6F8F6F6F6F6F6F6F6F6F6F6F6F6F6EAF6F6F6F6EAF6F6F6F6F6
        0000F8F6F8F8F6F8F8F8F6F8F8F8F8F6F8F8F6F8F8F8F6F8F8F6F8F8F6F8F8F6
        F8F8F8F8F6F8F8F8F8F6F8F8F8F8F6F8F8F8F6F8F8F6F8F8F8F6F8F6F8F6F5F5
        F5F1E8E3E2DECEBBB9B6AFE7B19B9B9B9B9B9B9B9B9B9B9B9B9B8AC7ECFCFCEC
        BC83B2B6B6B6BABBBBBBCEDEDEE2DFE3E3E8E8F1F5F5F5F8F5F8F6F8F6F6F8F6
        F6F6F6F5F6F6F6F6F5F5F6F6F6F6F5F6F8F6F6F6F6F6F6F8F6F8F6F8F6F8F6F6
        F6F6F6F6F6F8F6F6F6F6F6F6EAF6EAF6EAF6EAF6EAF6F6EAF6EAF6F6EAF6EAF6
        0000F6F8F6F8F6F8F6F8F6F8F6F8F6F8F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F8
        F8F8F6F8F8F6F8F8F8F8F6F8F8F8F6F8F6F8F6F8F6F8F6F8F6F8F6F6F6F6F5F5
        F1E8E3E3DECEBBBAB6AED3B19B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B8ABAEC
        FCFBECB9AEB2B6B6B6BABBBBCECEDEDFE2E3E3F1E8F1F5F5F6F6F6F6F8F6F6F6
        F5F6F6F3F5F6F5F5F5F5F5F5F5F6F5F6F6F6F5F6F8F6F6F6F8F6F6F8F6F6F8F6
        F8F6F8F6F6F6F6F6F6F6F6EAF6F6F6EAF6F6F6EAF6F6EAF6EAF6F6EAF6F6F6EA
        0000F8F6F8F6F8F8F6F8F8F6F8F8F6F8F6F8F8F6F8F6F8F8F6F8F8F6F8F8F6F8
        F6F8F8F6F8F8F6F8F6F8F8F8F6F8F8F6F8F8F6F8F8F6F8F6F8F6F6F8F5F6F5F1
        E8E3E3DEDEBBBAB6AECEB3869B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B
        8AB5ECFBF7D0B084B2B6B6B7BABBCEDEDEE2E3E3E8F5E8F5F6F5F6F6F6F6F6F6
        F6F5F5F5F5F5F1F5F1F5E8F5E8F5F5F5F5F6F5F6F6F5F6F6F6F6F6F6F6F6F6F6
        F6F8F6F6F6F6F6F6F6F6F6EAF6F6EAF6F6EAF6F6EAF6EAF6EAF6EAF6F6EAF6F6
        0000F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F8F6F8F6F8F6F8F6F8F6F8
        F6F8F8F6F8F6F8F6F8F6F6F8F6F6F8F6F8F6F6F6F8F6F8F6F6F6F6F6F5F5F5E8
        E8E2E2DEBBBAB6AFC2BA869B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B
        9B9B9B8AB5E1F7EEBFAF84B6B6BABAC9DEDEDFE3E3E8F1F5EAF5F6F5F6F6F5F6
        F5F5F5E8F1E8E8E8E8E8E8E8F1E8F1F5E8F5F5F5F5F6F5F6F6F6F6F6F6F6F6F6
        F6F6F6F6F6F6F6F6F6F6F6EAF6EAF6F6EAF6EAF6EAF6EAF6EAF6EAF6EAF6F6EA
        0000F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6
        F8F6F8F6F8F6F6F8F6F8F6F6F8F6F6F6F6F6F8F6F6F6F6F6F6F6F5F6F5F5F1E8
        E3E3DECEBBB7AFB2C78A9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B
        9B9B9B9B9B9B8AB5CEEFEDBDB2AFB7BBBBDEDEE2E0E8E8F5F1EAF5F6F6F5F6F5
        F5E8F1E8E8E8E3E3E3E3E3E3E3E3E8E8F1F1E8F5F1F5F5F5F6F6F6F6F6F6F6F6
        F6F6F6F6F6F6F6F8F6EAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6EA
        0000F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6
        F8F6F8F6F6F6F6F6F5F6F6F6F5F6F6F6F5F6F5F6F6F6F6F8F5F6F6F5F5F1E8E8
        E2DFDEBBBAB684C88A9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B
        9B9B9B9B9B9B9B9B9B8AB3BEE2D0B9B2BAC9CEDFE2E0E8F1EAF5F5F5F5F5EAF1
        E8F1E8E3E3E0E2DFE2DFE2DFE0E2E3E3E3E8F1E8F5F1EAF5EAF5F5F6F5F6F6F6
        F5F6F6F6F6F6F6F6F6EAF6EAF6EAF6EAF6EAF6EAF6EAEAF6EAF6EAF6EAF6EAF6
        0000F6F6F6F6F6F6F6F6F6F6F6F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6F8F6
        F6F6F6F6F6F6F6F5F5F6F5F6F5F5F6F5F6F5F6F5F6F6F5F6F6F5F6F5F1E8E8E3
        E2DEC9BAB7AEC4B19B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B
        9B9B9B9B9B9B9B9B9B9B9B9B8AB3B9CEBDB2B5CEDFE3E3E8F5F1EAF5EAF1F5E8
        E8E3E3E0DFDEDEDEDEDED6DEDEDFDEDFE3E2E0E3E8E8E8E8F1EAF1EAF5EAF6F5
        EAF6F6F6EAF6F6F6EAF6EAF6EAEAF6EAEAF6EAF6EAF6EAF6EAEAF6EAF6EAF6EA
        0000F6F8F6F6F8F6F8F6F8F6F8F6F6F6F6F6F6F8F6F6F8F6F6F6F6F8F6F8F6F6
        F6F6F6F6F6F5F5F5F5F5F5EAF1F5F5F1F5F5F5EAF5F5F5F5F5F5F5EAE8F1E3E0
        DECEBBB7B2B38C869B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B
        9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B8AB1B5B5B7DFE3E3E8E8F1EAF1E8E8E8E8
        E3DFDFDFDECEC9C9BBBBBBBBC9CEDECEDEDFE2DFE3E3E8E8E8E8E8F5E8F5EAF5
        EAF6EAF6F5F6EAF6F6EAF6EAEAEAF6EAF6EAEAEAF6EAF6EAF6EAF6EAEAEAEAEA
        0000F6F6F8F6F6F6F6F6F6F6F6F6F8F6F8F6F6F6F6F6F6F6F8F6F6F6F6F6F6F6
        F6F6F6F5F6F5F5F1F5F1F5E8F1E8F1E8F1EAF1F1E8F5EAF1EAF1E8F1E8E8E3DF
        DEC9BAB6B18C8A9D9D9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B
        9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B8AB4DFE0E3E8F1E8F5E8F1E8E8E3
        DFDFDECEC9BBB2AFAFB6B7BAB7BBBBBBC9DEDEDEDFDFE0E3E3E3E8E8E8F1EAE8
        F5EAF5EAEAF6EAF6EAEAEAEAF6EAEAEAEAEAF6EAEAEAF6EAEAEAEAEAF6EAEAF6
        0000F6F8F6F6F8F6F8F6F8F6F8F6F6F6F6F8F6F8F6F6F8F6F6F8F6F8F6F6F6F6
        F6F5F6F5F5F5F5F1E8F5E8E8E8E8E8E8E8E8E8E8F5E8F1E8E8F5E8E8E8E3DFDF
        CEBBBA849EB19F9E9E9E9D9D9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B
        9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B86B2DEDFE0E3E3E8F1E8E8E8E3E3DF
        DFCEC9BBBA828A9D8A636384B6B6B7B7BABBC9C9CEDEDEDFE0DFE0E3E8E8E8F5
        E8EAF5EAF5EAEAF6EAEAEAEAEAEAEAF6EAEAEAEAEAF6EAEAEAF6EAEAEAEAF6EA
        0000F6F6F6F6F6F6F6F6F6F6F6F6F6F6F8F6F6F6F6F6F6F6F8F6F6F6F6F6F5F6
        F5F6F5F5F1E8F1E8F1E8E8E3E3E8E3E3E8E3E8E3E8E8E3E8E8E3E8E3E3E2DFDE
        BBBAB68AB1C4C1C1C0C09E9F9D9E9D9D9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B
        9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B8AB2C9DEDEE0E2E0E8E8E8E3E3DFDFDE
        C9C9BAB7B6899D9E9D9D9D8A6382AEB2B6B7B7BABBC9C9CED6DEDFDFE0E0E3E8
        E8E8E8E8EAF5E8EAEAEAEAEAEAEAF5EAEAF6EAEAF6EAEAEAEAEAEAF6EAEAEAEA
        0000F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F8F6F8F6F6F6F6F6F8F6F6F6F5
        F6F5F5F5F5E8F5E8E8E3E3E3E3E3E3E3E2E3E3E3E3E3E3E3E3E3E3E0E2DFDEC9
        C9BA849DB3C8C8C4C4C4C1C1C0C09E9E9E9D9D9D9B9B9B9B9B9B9B9B9B9B9B9B
        9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B89B6BBC9DEDFE0E0E3E8E3E3E0E0DEDEC9
        C9BAB68B9D89C09E9E9E9D9D9D9B83638284B2B6B7B7BAC9BBC9DEDEDFDFE0DF
        E0E0E8E8E8EAE8E9E9EAE9EAEAEAEAEAEAEAEAEAEAEAEAEAEAF6EAEAEAEAEAEA
        0000F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F8F6F6F6F6F6F6F6F5
        F5F5F5F5F5E8E8E8E3E3E3E3E3DFE3DFE3DFE3DFE3DFE2DFE0E2DFE2DFDEDEBB
        BBB7898ACACAC8CAC8C8C8C4C4C1C1C0C0C09E9E9E9D9D9D9B9B9B9B9B9B9B9B
        9B9B9B9B9B9B9B9B9B9B9B9B9B9B89B6B7C9C9DFDFE0E0E3E0E3E0DFDFDEC9BB
        B7B6909D9DB1C0C0C0C09E9E9D9E8A9B8A8382AE8BB6B6B7BABBC9C9D6D6DEDF
        DFE0E0E0E8E8E8E8E8E9E9EAE9EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA
        0000F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F8F6F6F6F6F6F6F6F6F6F6F5
        F5F5F5F5E8F1E8E8E3E3E3E3E2DFE2DFDFE2DFE2DFDFDFDFDFDFDFDFDEDEC9BB
        BAB7898ACFCFCFCFCACAC8C8C8C8C8C4C4C1C1C0C0C09E9E9E9D9D9B9B9B9B9B
        9B9B9B9B9B9B9B9B9B9B9B9B9B83B6B7BBC9DEDFDFE0E0E3E0E2DFDFDEC9BBB7
        B68B9E9D9EB1C4C1C1C0C0C09F9E8A9E9D9D9B896382848BB6B7B7BAC9BBC9D6
        D6DFDFE0E0E0E0E8E5E8E9E8EAE9EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA
        0000F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F8F6F5F6
        F5F5F5EAF1E3BDB0B2AEB4BCBABECEBBE2DFDEDFDFDFDFDFDEDFDEDEDEC9BBBB
        B7B6898AD3D3D2D2CFCFCFCFCFC8CAC8C8C8C4C4C4C1C1C0C09E9E9E9D9D9D9B
        9B9B9B9B9B9B9B9B9B9B9B8683B6B6B7C9C9DEDFDFE0E0DFDFDFDFC9C9BAB7B6
        8B9E9EC09EB1C8C4C4C1C1C0C0C08C9E9E9E9D9E9D9B63828384B6B7B7B7BBC9
        C9D6D6D6DFE0E4E0E5E0E8E9E9EAE9EAE9EAEAEAEAEAEAEAEAEAEAE9EAEAEAEA
        0000F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6
        F5F5F5F5DFAFC7D2D3F0F3F3F3F3F3F1D0CEBEBADEDEDEDEDEDEDED6C9CEBBBA
        B7B6898AE7E7E7D3D3D3D2D2CFCFCFCFCACAC8C8C8C8C4C4C4C1C1C0C09E9E9E
        9D9D9D9B9B9B9B9B9B9B8A838BB7BAC9C9DEDFDFE0E0E2E0DFDED6BBBBB78B8B
        9EC0C0C0C0B2C8C8C4C4C4C1C1C1B3C0C09EC09E9D9E9D9D8A638284B290B7BA
        C3BBC9C9D6DFDFDFDBE0E5E8E9E9E8E9E9E9EAE9EAE9EAEAEAEAE9EAE9EAEAE9
        0000F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6
        F5F6F5F1AECACFCFF0F3F3F3F3F3F3F3F3F3F3F1E1CECDBACED6CEC9CEC9BBB7
        B7B6848AD1F0F0E7E7E7E7D3D3D3D2CFCFCFCFCFCACAC8C8C8C8C4C4C1C1C1C0
        C09E9E9D9E9D9B9B9B89838BB7BAC5C9D6DFDFDFE0DFDFDFDED6BBBAB78B8BC0
        C0C1C1C1C1B2C8C8C8C8C8C8C4C1B3C1C1C0C0C09E9E9E9E9D9D9D8382838BB6
        90B7C3C9C9D6D7D7DFE5E0E0E5E9E8E9E9EAE9E9EAEAE9EAE9EAEAE9EAE9EAE9
        0000F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6
        F5F6EAB9C7CACFD3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3E2CEBBB9C9BBBBBA
        B7B6B28ACDF1F0F0F0F0E7E7E7E7E7D3D3D3D2CFCFCFCFCACAC8C8C8C8C8C4C4
        C1C1C0C0C09E9E9D83838BB7B7C9C9D6DEDFDFDFDFDFDFD6D6BBB7B78B8BC1C1
        C1C4C1C4C4B4CACACAC8C8C8C8C8B3C4C4C4C1C1C0C0C09E9E9E9E9D9D8A6382
        84B7B7B7C9C9C9D7D7D7E0E5E0E5E9E9E9E9E9E9E9EAE9E9E9E9EAE9E9EAE9E9
        0000F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6EA
        F6F6F5B2CACFCFE7F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3E2CEBAB6
        B6B7B689B5F2F1F1F0F1F0F0F0F0E7E7E7E7D3D3D3D2D2CFCFCFCFCFC8CAC8C8
        C8C4C4C4C1C1C063848B90BAC5C9D6D6DFDFDFE0DFDFD6C9C9BAB78B8BC1C4C4
        C4C4C8C8C4B4CFCFCACACAC8CAC8C2C8C8C4C4C4C1C1C1C0C09EC09D9E9E9D9D
        8963AE90B7C3C9C6D6D7D7E0E5E0E5E9E5E9E9E9EAE9E9E9E9E9EAE9E9E9EAE9
        0000EAF6F6F6F6F6F6F6F6F6F6F6F6F6EAF6F6F6F6F6F6F6F6F6F6F6F6F6F6F6
        F6F5DFB5C8CFCFF0F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        E2CEB9838AEEF3F2F2F1F2F1F0F1F0F0F0F0E7E7E7E7D3D3D3D2CFD2CFCFCACA
        CAC8C8C8C8C280838B90BAC3C9C9D6DFDFDFDBDFD6D6C9C9B7B78B8BC4C4C4C8
        C4C8C8C8C8B5CFCFCFCFCFCACACAC2C8C8C8C8C8C4C4C1C1C1C1C0C09E9E9E9E
        9D9D8A63AE8BC3C5C9D7D7DBE0E5E0E6E9E9E9E9E9E9E9E9E9E9E9EAE9E9EAE9
        0000EAF6F6F6F6EAF6F6EAF6F6EAF6F6F6F6EAF6F6EAF6F6EAF6F6EAF6F6F6EA
        F6F6E2C2CACFCFF1F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3E2D0E1D1F2F2F2F2F3F1F1F1F0F0F0F0F0F0E7E7E7E7D3D3D3D2CFCF
        CFCFCFCAB380838B90B7C3C9C9D6DFD7DFDFDFD7D6C9C9B7908B8BC4C8C8C8C8
        C8C8C8CAC8B5D3D2D2CFCFCFCFCFC2CACAC8C8C8C8C8C4C4C4C1C1C1C1C0C09E
        9E9E9E9D9D8963AFC3D6D7DBDFE5E5E8E6E9E9E9E9E9E9E9E9E9E9E9E9EAE9E9
        0000EAF6EAF6F6F6F6F6F6EAF6F6F6F6EAF6F6F6F6F6F6F6F6EAF6F6F6F6F6F6
        EAF6CEB5CACACFF1F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3E2D1D0D1F1F2F2F2F2F1F1F0F1F0F0F0F0E7E7E7E7D3D3D3
        D2D2CFB26081848BB6B7C9C9D6D6D7DFDFD7D6D6C9C9B7B78B8BC8C8C8C8C8CA
        C8CFCACACFB5D3D3D3D3D2D2CFCFC7CFCFCACACAC8C8C8C8C8C4C4C4C1C1C1C1
        C0C09E9E9E9E8A9D83AEC3DFE5DBE0E6E9E9E6E9E9E9E9E9E9E9E9E9E9E9E9E9
        0000EAEAF6EAF6F6F6EAF6F6F6F6EAF6F6F6EAF6F6EAF6F6F6EAF6EAF6F6F6F6
        F6F6BBC8CACFCFF3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3E2E1D0D1F2F2F2F2F1F1F1F0F1F0F0F0F0E7E7E7
        E7D3B26061818B8BB7C5BBC9D6D6D7DFD6D6D6C9C9B7908B8BC8C8CAC8CACACA
        CACFCFCFCFB5E7E7D3D3D3D3D3D2C7CFCFCFCFCACACACAC8C8C8C8C8C8C4C4C1
        C1C0C1C09E9E8C9D9E9DAFD7E5E5E0E5E6E9E6E9E9E9E9E9E9E9E9E9E9E9E6E9
        0000EAEAEAEAF6F6EAF6F6EAF6EAF6F6EAF6F6EAF6F6EAF6F6EAF6F6EAF6F6F6
        F6F6B6CACACACFF3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F1D0D0CEE1F3F2F2F2F1F2F0F1F0F0F0F0
        F0E7605A81818B90B7C3C9C9D6D7D6D6D6C9C5BBB7B78B8BC8CACACACACFCFCF
        CFCFCFCFD2B9F0E7E7E7E7D3D3D3CDD3D2CFCFCFCFCFCACACAC8C8C8C8C8C4C8
        C1C4C1C1C1C08CC09E9EAEDBE0E5E5E5E6E6E9E9E9E9E9E6E9E9E9E9E9E9E9E9
        0000EAEAEAEAF6F6EAF6EAF6F6F6EAF6F6EAF6F6EAF6F6EAF6F6EAF6F6EAF6EA
        F6F6B2CACACFD3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F1E1D1D0ECF3F2F2F2F1F1F0F1
        F0D15A5A80848B90B7B7C3C9C5C9D6C9C9C9C3B7908B8BCACACACACFCFCFCFCF
        CFD2CFD2D2BCF0F0F0E7E7E7E7E7CDD3D3D3D3D2CFCFCFCFCFCFCA3C56C8C8C8
        C8C4C4C4C1C1B3C0C0C0B1E0DBE5E5E5E6E6E6E9E9E9E9E6E9E9E9E9E9E6E9E9
        0000EAEAEAEAEAF6F6EAF6EAF6EAF6F6EAF6F6EAF6F6EAF6F6EAF6F6EAF6F6EA
        F6F6B6C8CACFD2F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F1D1D0D1E1F3F2F2F2
        F1D15A6081818B9090B7C3BAC5C9C5C9C3B7B7908B8BCACFCFCFCFCFCFD2CFD2
        D3D2D3D3D3BDF0F0F0F0F0F0E7E7CEE7D3D3D3D3D3D2D2CFCFCF594B35C2C8CA
        C8C8C8C8C8C4B3C1C1C1B2DBE5E5E5E5E6E6E6E6E9E6E9E6E6E9E6E9E6E9E6E9
        0000EAEAEAEAEAEAF6F6EAF6EAF6F6EAF6F6EAF6EAF6F6EAF6F6EAF6F6EAF6F6
        EAF6AEC8CACFE7F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F1D0D0CEE1
        F3D05A6061818B8B9090B7B7B7C3B7B7B790908B8BCACFCFCFD2CFD2D3D2D3D3
        D3D3D3E7D3BDF1F0F1F0F0F0F0F0CEE7E7E7E7E7D3D3D3D3D2CF599B5C86CACA
        CAC8CAC8C8C8B3C8C4C1B2E5DBE5E5E5E6E6E6E9E6E6E6E9E6E6E9E6E6E9E9E6
        0000EAEAEAEAEAEAEAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6
        EAF6B2C8CACFE7F3F3F3F3F3F3F3F3F3F3F3E2E2F0F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3EE
        E1BD80806181818B8B9090B790B79090B68B878BCFCFD2CFD3D2D3D3D3D3D3D3
        E7E7E7E7E7BDF1F2F1F1F0F1F0F0D1F0F0E7E7E7E7E7D3D3D3D3CA394BCFCFCF
        CFCFCAC8CAC8C2C8C8C4AFDBE5E5E6E5E6E6E6E6E6E6E6E9E6E6E6E6E6E9E6E6
        0000EAEAEAEAEAE9EAEAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6EA
        F6DFB2C8CACFF0F3F3F3F3F3F3F3F3F3D06151515761AFBDE1F0F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3EECEBA8483878B8B908B908B8B8B858BCFD2D3D2D3D3D3D3D3E7E7E7E7
        E7E7F0E7F0BDF3F2F1F2F1F1F0F1F0D0F0F0F0F0E7E7E7E7E7D3D3D3D3D2D2CF
        CFCFCFCFCACAC2C8C8C8AEDBE5E5E5E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E9E6
        0000EAEAEAEAEAEAEAEAEAF6EAEAEAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6EAF6
        EAE2C2C8CACFF0F3F3F3F3F3F3F3F3EE5B4747484748484F515781AFBDE2F1F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3EECEB48484878B8581878BCFD3D3D3D3D3E7D3E7E7E7E7F0E7
        F0F0F0F0F0BDF3F2F3F2F2F2F1F1F1D1F0F0F0F0F0F0F0E7E7E7C23955D3D3D3
        D2D2CFCFCFCFC7CFC8CAB1E5E5E5E5E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6
        0000EAEAE9EAEAE9EAEAEAF6EAF6EAEAEAEAF6EAF6EAF6EAF6EAF6EAF6EAF6EA
        F6BBC2C8CACFF3F3F3F3F3F3F3F3F3BD4747474748474848485348534F525781
        B4BDE2F1F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3EDCEB4848184D2D3D3E7D3E7E7E7E7F0E7F0F0F0F0
        F0F0F0F0F0BEF7F3F3F3F3F2F2F2F1E1F1F1F1F0F0F0F0F0F0F002010055E7D3
        D3D3D3D2CFCFCDCFCFCFB2E5E5E5E6E5E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6
        0000EAE9EAE9EAEAE9EAEAEAF6EAEAF6EAF6EAEAEAF6EAF6EAEAEAEAEAF6EAEA
        EABBC8C8CACAF3F3F3F3F3F3F3F3F3B047474747474847484848484853535354
        544F795B89B0BDE2F1F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3EDD0CEC7D1E7E7E7F0E7F0F0F0F0F0F0F0
        F0F1F0F1F1BEF7F7F7F3F2F3F3F3F3E1F2F2F1F1F1F0F1F0F0B3013F3414E7E7
        E7D3D3D3D3D2CDCFCFCFB5E5E5E5E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6DD
        0000EAE9EAE9EAE9EAE9EAEAEAEAEAEAEAEAF6EAF6EAEAEAF6EAF6EAF6EAEAF6
        EAB9C8CACACFF3F3F3F3F3F3F3F3F38545474747474748474848485348535353
        53545454715466797883B4BDE2F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3E2CED0CDE7F0F0F0F0F0F0F1F0
        F1F1F1F2F1BEFBF8FBF3FBF3F7F3F3E1F3F3F2F2F2F1F1F0F1B3035F3F12F0E7
        E7E7E7E7D3D3CDD3D2D2B4DDE5DDE6E6DDE6E6E6E6E6E6DDE6E6E6E6E6E6E6E6
        0000E9EAE9EAE9E9E9EAE9EAEAF6EAEAEAEAEAEAEAF5EAF6EAEAF6EAEAF6EAEA
        F6B2C8C8CAD2F3F3F3F3F3F3F3F3F35B45454747474747484748484848485353
        53535454547171547171716679788BB4BEE2F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3E2D0CED0F0F0F1F1F2
        F1F2F2F1F2BEFBFBFBFBF3FBF3FBF3E1F3F2F3F3F2F2F1F2F1F103361358F0F0
        F0E7F0E7E7E7CED3D3D3B5D7E5DDE6DDE6E6DDE6DDE6E6E6E6E6E6E6E6E6DDE6
        0000E9E9E9E9E9E9E9E9E9E9EAEAEAF6EAEAEAEAEAF6EAEAF5EAEAF6EAEAF5EA
        EAB4C8C8CAD3F3F3F3F3F3F3F3F3EE5045454745474747474847484848534853
        535353545454717154717171717271727A7D6184B9BEE2F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F1D0D0BFF1F2
        F2F3F2F3F2BEFCFBF8FCFBFBFBF3FBEDF3F7F3F3F3F2F3F2F1F2C2143CF1F0F0
        F0F0F0F0F0E7CEE7E7D3B5D7E6E6DDE6E6DDE6E6E6DDE6DDE6E6E6E6E6E6E6DD
        0000E9EAE9E9E9E9E9E9E9E9E9EAEAEAEAEAEAEAEAEAEAEAEAF6EAEAEAEAEAF6
        EAAEC8CACAE7F3F3F3F3F3F3F3F3E24D45454547454747474748474848484848
        5353535354545471715471717171727272727273737A7C818BBCD0E2F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3647FF3F3F3F3F3F3F3F1D0F3
        F2F3F2F3F2BFFCFCFCFCF8FCFBFBF8ECFBF3FBF3F7F3F2F3F3F3F2F1F2F1F1F1
        F0F1F0F0F0F0D0E7E7F0CED7E5DDE6DDE6E6DDE6DDE6E6E6DDE6E6DDE6E6DDE6
        0000E9E9E9E9E9E9E9E9E9E9E9E9EAEAF6EAEAEAEAF5EAEAEAEAEAF6EAEAEAEA
        EAB2C8C8CAE7F3F3F3F3F3F3F3F3BD4D45454545474547474747484748484853
        48535353535454547171547171717172717272737373737474747B7C81B2BCD0
        E2F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F36407098FF3F3F3F3F3F3F3E1F3
        F2F3F3F7F3BFFDFCFCFCFCFCFBFCFBE1FBFBF8FBF7F3FBF2F3F2F3F2F3F2F2F2
        F1F1F0F1F0F0D1F0F0F0CED7DDE6DDDDDDE6DDE6DDE6DDE6DDE6DDE6E6DDE6DD
        0000E9E9E9E9E9E9E9E9E9E9E9E9E9EAEAEAEAEAEAEAF5EAEAF6EAEAEAF5EAEA
        DFB2C8C8CAF0F3F3F3F3F3F3F3F3BC4445454545454745474747474847484848
        484853535353545454717154717171717271727273737373747374747492917B
        8785B2BDE1F0F3F3F3F3F3F3F3F3F3F3F3F3F37F0608C9F2F3F3F3F3F3F3E2F2
        F7F7F3FBFBBEFDFDFCFCFCFCFCFAFCEEF2FBFBF3FCF3FBFBF3F3B80A11F3F2F3
        F2F2F1F1F1F0D1F0F0F0D1D7E5DDDDDDE6DDDDE6DDE6DDE6DDE6DDE6DDE6DDDD
        0000E9E9E9E9E9E9E9E9E9E9E9E9E6EAEAEAEAEAEAEAEAEAEAEAEAF5EAEAEAF5
        DFC2C8C8CAF1F3F3F3F3F3F3F3F3B14444454445454547454747474748474848
        4853485353535354545471715471717171727172727373737374737474749292
        929294917E8781B4BDE2F1F3F3F3F3F3F3F3F3F38FC9F2F3F3F3F3F3F3F3E2ED
        F3FBFBF3FCBEFDFCFDFDFCFCFCFCFCFCECFAFBFCFBFCF3FCF7FB1805047FF2F3
        F2F3F2F2F2F1D1F1F1F0D1BAE6DDDDDDDDDDDDDDE6DDDDDDE6DDDDE6DDDDDDDD
        0000E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9EAEAEAEAEAEAEAEAEAEAEAEAEAEAEA
        BBC2C8C8CAF3F3F3F3F3F3F3F3F3614445444545454545474547474747484748
        4848484853535353545454717154717171717271727273737373747374747492
        92929294929494949488858BB0BEE2F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3E2EE
        FBFBFCFBF8BFFEFCFEFCFEFCFCFDFCFCE1FCFCFCFAFBFBFBF8FB3A0F0E8DF7F3
        F3F2F3F3F2F2E1F2F1F1D1B7DDE6E6DDDDDDDDDDDDDDDDDDDDDDDDE6DDDDDDDA
        0000E9E6E9E9E6E9E9E9E6E9E9E9E6E9E9EAEAEAEAEAEAEAEAEAEAEAEAEAEAEA
        BBC2C8CACAF3F3F3F3F3F3F3F3F3564444444544454545454745474747474847
        4848485348535353535454547171547171717172717272737373737473747474
        92929292949494949494969696957E85B2BCCEEEF3F3F3F3F3F3F3F3F3F3E2FB
        FCF8FBFCFBBFFEFEFEFEFDFCFEFCFDFCF7EEFCFCFCFCFCFCFBF83B2E0C8DFBF7
        F3FBF2F3F3F3E1F3F2F2F0BADDE5DDE6DDDDDDDDDDDDDDDDDDDDDDDDE6DDDADD
        0000E9E6E9E9E9E6E9E9E9E9E6E9E9E9E9E9EAEAEAEAEAEAEAEAEAEAEAEAEAEA
        B4C4C8CACFF3F3F3F3F3F3F3F3ED4C4344444445444545454547454747474748
        4748484848485353535354545471717171717171727172727373737374737474
        749292929294929494949496969696999996A08884B4EEF3F3F3F3F3F3F3D0FB
        F8FCFCFCFCBFFEFEFDFEFEFEFDFEFCFEFCECFCFCFDFCFCFCFCFC3A0D0E8DFBF8
        FBF3FBF7F3F7D1F3F3F2F2B7DDDDE6DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDA
        0000E9E6E9E9E6E9E9E9E9E6E9E9E9E9E6E9E9EAEAEAE9EAE9EAE9EAEAEAEAEA
        B2C8C8C8D2F3F3F3F3F3F3F3F3E2464343444444454445454545474547474747
        4847484848534853535353545454715471717171717271727273737373747374
        7474929292929494949494949496969699999999999783EDF3F3F3F3F3F3E1FC
        FCFAFCFCFCBFFEFEFEFEFEFEFEFDFEFDFDFBECFCFDFCFCFDFCFCEE173AF8FBFC
        FBFBF8FBF3FBE1F3F3F3F3B7DDDDDDDDE6DDDDDDDDDDDDDDDDDDDDE6DDDDDDDA
        0000E9E6E6E9E9E6E9E9E6E9E9E9E9E6E9E9E9E9EAEAEAEAE9EAEAE9EAEAEAEA
        B2C8C8C8E7F3F3F3F3F3F3F3F3BE462543434444444544454545454745474747
        4748474848484848535353535454547154717171717172717272737373737473
        74747492929292949294949496949696969999999A9997B4F3F3F3F3F3F3E1FC
        FCFCFCFDFCBFFEFEFEFEFEFEFEFEFEFEFEFDEFEFFDFEFCFCFDFCFCFCFCFCFCFC
        F8FBFBFBFBF8E1FBF3FBF2B6E6DDDDDDDDDDDDDDDDDDDDDADDDDDDDDDDDDDADC
        0000E6E6E9E6E9E9E6E9E9E6E9E6E9E9E6E9E6E9E9EAEAEAEAE9EAEAEAEAEAEA
        AEC4C8C8E7F3F3F3F3F3F3F3F3B9432543434344444445444545454547454747
        4747484748484853485353535354547154717171717171727172727373737374
        7374747492929292949494949494969496969999999A9984F3F3F3F3F3F3E1FC
        FCFCFCFDFEBFFEFEFEFEFEFEFEFEFEFEFEFEFDEDF7FCFDFDFCFDFCFCFCFDFCFC
        FCFCFAFCFBEDF2FBFBF3FBAFDDDDDDE6DDE6DDDADDDADDDADDDADDDDDDDADADA
        0000E6E6E6E9E6E6E9E6E9E6E9E9E6E9E6E9E9E6E9EAEAEAEAEAE9EAEAEAEAEA
        B1C8C8C8F1F3F3F3F3F3F3F3F389254325434343444444454445454545474547
        4747474847484848484853535353545471547171717171717271727273737373
        7473747474929292929492949494969496969699999999B7F3F3F3F3F3F1EEFC
        FDFCFEFCFDBFFEFEFEFEFEFEFEFEFEFEFEFEFEFEEDEFFEFEFDFCFEFCFDFCFCFD
        FCFCFCFCFBD0FCFBF8FBFBB2DDDDDDDDDDDDDDDDDADCDADADADCDDDCDADADADC
        0000E6E6E6E6E6E9E6E6E9E6E9E6E6E9E9E6E9E6E9E9EAEAE9EAEAE9EAEAEADF
        B1C8C8C8F1F3F3F3F3F3F3F3F361252543254343434444444544454545454745
        4747474748474848485348535353535454715471717171717172717272737373
        7374737474749292929294949494949494969696999999B4F3F3F3F3F3E2FBFE
        FCFEFCFEFDBFFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEEFECFEFEFEFDFEFCFEFCFC
        FDFCFCFDEDF2FCFCFBFCF8BADDDDDDDDDDDDDDDDDADADADCDADADDDADADADADA
        0000E6E6E6E6E6E6E6E9E6E9E6E6E9E6E9E6E6E9E6E6EAE9EAE9EAE9EAEAEADF
        B3C4C8C8F3F3F3F3F3F3F3F3F34C252525432543434344444445444545454547
        4547474747484748484848485353535354547154717171717171727172727373
        7373747374747492929292949294949496949696969996BDF3F3F3F3F3E1FDFD
        FEFEFEFEFEBFFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFCECEFFEFDFEFEFCFEFC
        FDFDFCECEFFCFCFCFCFCFCBADCDDDDDDDADCDDDDDDDADADADCDADDDCDAD9DADA
        0000E6E6E6E6E6E6E6E6E6E6E9E6E6E9E6E9E6E9E6E9E9EAE9EAE9EAE9EAE9BB
        B3C8C8C8F3F3F3F3F3F3F3F3E24C252525254325434343444444454445454545
        4745474747474847484848534853535353545471547171717171717271727273
        7373737473747474929292929494929494969496969695CEF3F3F3F3F3EDFEFE
        FDFEFDFEFEBFFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFBECEDF7FEFEFEFD
        FDF7ECEFFDFCFDFCFCFCFCBBDCDCDDDADDDCDDDDDDDCDADADADADCDADADADAD9
        0000E6E6E6E6E6E6E9E6E6E6E6E9E6E9E6E9E6E9E6E9E6E9EAE9EAE9EAE9EABA
        C4C4C8CFF3F3F3F3F3F3F3F3D046222525252543254343434444444544454545
        4547454747474748474848484848535353535454715471717171717172717272
        7373737374737474749292929294949494949494969688E2F3F3F3F3F3ECFEFE
        FEFEFEFEFEBFFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEF7ECEDEFED
        EDEFFEFDFEFCFDFCFDFCFCB0DCDADCDCDCDCDCDDDDDCDADCD9DADCDCDAD9D9D9
        0000E6E6E6E6E6E6E6E6E6E6E6E6E9E6E6E9E6E9E6E9E6E9E9EAE9EAE9EAE9B9
        C4C4C8CFF3F3F3F3F3F3F3F3BD43222525252525432543434344444445444545
        4545474547474747484748484853485353535354547154717171717171727172
        7273737373747374747492929292949294949496949687F3F3F3F3F3F3ECFEFE
        FEFEFEFEFEBFFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE
        FEFEFEFEFEFCFDFEFCFDFCB0DCDCDADCDADCDADCDCDDDCDADAD9DCDAD9D9D9D9
        0000E6E6E6E6E6E6E6E6E6E6E6E6E6E9E6E6E6E6E6E6E6E6E9E9EAE9EAE9EAB2
        C4C8C8D2F3F3F3F3F3F3F3F3B924252425252525254325434343444444454445
        4545454745474747474847484848484853535353545471547171717171717271
        7272737373737473747474929292929492949494969489F3F3F3F3F3F1EFFEFE
        FEFEFEFEFEBFFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE
        FEFEFEFEFEFEFEFDFEFCFEBFDCDADCDCDCDADCDADCDCDCDAD9DADAD9D9D9D9D9
        0000E6E6E6E6DDE6E6E6E6E6E6E6E6E6E6E9E6E6E9E6E6E6E6E9E9EAEAEAE9B2
        C4C4C8E7F3F3F3F3F3F3F3F38924242524252525252543254343434444444544
        4545454547454747474748474848485348535353535454715471717171717172
        71727273737373747374747492929292949294949496B2F3F3F3F3F3E2FCFEFE
        FEFEFEFEFEBFFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE
        FEFEFEFEFEFEFEFEFEFEFDBFDADADADCD9DADCDADCDCDCDCDAD9DAD9D9D9D9D9
        0000E6E6DDE6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E9E6E6E6E9E9EAE9EA83
        C4C4C8F0F3F3F3F3F3F3F3F35822242424252525252525432543434344444445
        4445454545474547474747484748484848485353535354547154717171717171
        72717272737373737473747474929292929492949494BCF3F3F3F3F3D0FEFEFE
        FEFEFEFEFEBFFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE
        FEFEFEFEFEFEFEFEFEFEFEBFDAD9DAD9DAD9DADCDADCDCDDDCD9DAD9D9D9D9D9
        0000E6E6E6DDE6E6E6E6E6E6E6E6E6E6E6E6E9E6E6E9E6E6E6E6E6E9E9EAE9B1
        C4C8C8F0F3F3F3F3F3F3F3F14C23242425242524252525254325434343444444
        4544454545454745474747474847484848534853535353545471547171717171
        71727172727373737374737474749292929294929491BEF3F3F3F3F3E1FEFEFE
        FEFEFEFEFEBFFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE
        FEFEFEFEFEFEFEFEFEFEFEBFCBD9DAD9D9D9D9DADCDADCDCDCDADAD9D9D9D9D8
        0000E6E6E6E6DDE6E6E6DDE6E6E6DDE6E6E6E6E6E6E6E6E6E6E6E6E9E9E9DFB1
        C4C4C8F1F3F3F3F3F3F3F3E24A23232424252425252525252543254343434444
        4445444545454547454747474748474848484848535353535454715471717171
        71717271727273737373747374747492929292949293E2F3F3F3F3F3ECFEFEFE
        FEFEFEFEFEBFFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE
        FEFEFEFEFEFEFEFEFEFEFEBFC6DADAD9D9D9D9DADADCD9DADCDDD9D9D8D9D9D8
        0000E6DDE6E6DDE6DDE6E6E6DDE6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E9E9DFB3
        C4C4C8F3F3F3F3F3F3F3F3D04123242324242524252425252525432543434344
        4444454445454545474547474747484748484848485353535354547154717171
        71717172717272737373737473747474929292929487EDF3F3F3F3F3E1FEFEFE
        FEFEFEFEFEBFFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE
        FEFEFEFEFEFEFEFEFEFEFEEEC6D9D9D9D9D9D9D9DADADCDADCDCD9D9D9D8D9D8
        0000E6DDE6DDE6E6E6DDE6E6E6E6DDE6E6E6E6E6E6E6E6E6E6E6E6E6E6E9BBB3
        C4C4C8F3F3F3F3F3F3F3F3BD2223232423242425242525252525254325434343
        4444444544454545454745474747474847484848484853535353545471547171
        71717171727172727373737374737474749292929285F3F3F3F3F3F1EFFEFEFE
        FEFEFEFEFEBFFEFEFDFEEFEDFCFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE
        FEFEFEFEFEFEFEFEFEFEFEEFC6D9D9DAD9D9D9D9D9DADADCD9DCD9D9D9D8D9D8
        0000E6DDE6E6DDE6DDE6E5E6DDE6E6E6DDE6E6E6E6E6E6E6E6E6E6E6E6E9BAC0
        C4C8CFF3F3F3F3F3F3F3F3B02323232323242424242425252525252543254343
        4344444445444545454547454747474748474848484848535353535454715471
        7171717171727172727373737374737474749292928BF3F3F3F3F3E2FCFEFEFE
        FEFEFEFEFEBFFEFEFDFEBFEFBCB9BFEFFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE
        FEFEFEFEFEFEFEFEFEFEFEEFC6D9D9D9D9D9D9D9D9D9DADADAD9D9D9D8D9D8D8
        0000E6DDE6DDE6DDE6DDE6DDE6E6DDE6E6DDE6E6E6E6E6E6E6E6E6E6E6E6B6C0
        C4C4CFF3F3F3F3F3F3F3F3571D1E232323242324242524252425252525432543
        4343444444454445454545474547474747484748484848485353535354547154
        717171717171727172727373737374737474749292B2F2F3F3F3F3D0FEFEFEFE
        FEFEFEFEFEBFFEFDFEFDBFFEFEFEF7E1BCBCE1F7FEFEFEFEFEFEFEFEFEFEFEFE
        FEFEFEFEFEFEFEFEFEFEFEEFC6D8D9D9D9D9D9D9D9D9D9D9DAD9D9D9D8D8D9D8
        0000E6DDE6DDE6DDE6DDE6DDE6DDE6E5E6DDE6DDE6E6E6E6E6E6E6E6E6E6B2C1
        C4C8D3F3F3F3F3F3F3F3F3161010101A1C1E2424242424242525252525254325
        4343434444444544454545454745474747474847484848484853535353545471
        547171717171717271727273737373747374747491BDF3F3F3F3F3E1FEFEFEFE
        FEFEFEFEFEBFFEFCFEFDBFFED532ACEBFEFEEFBFBCBCEFFBFEFEFEFEFEFEFEFE
        FEFEFEFEFEFEFEFEFEFEFEEFB7D8D9D9D8D8D9D9D9D9D9D9D9DAD8D9D8D9D8D9
        0000DDE6DDE6DDE6DDDDE6DDE6E6DDE6DDE6DDE6E6E6E6E6E6E6E6E6E6E6B2C1
        C4C4D3F3F3F3F3F3F3F3F11F191919191919191C1E2324252425242525252543
        2543434344444445444545454547454747474748474848484848535353535454
        71547171717171717271727273737373747374747BD0F3F3F3F3F3EDFEFEFEFE
        FEFEFEFEFEBFFEFDFEFCBFFEEB32302FFEFDFEFEFEFCEDBFB9BFEFFEFEFEFEFE
        FEFEFEFEFEFEFEFEFEFEFEF790D9D9D8D9D8D8D9D8D9D9D9DAD9D8D8D9D8D9AB
        0000DDDDE5E6DDE6DDE6DDDDDDE6DDE6DDE6DDE6DDE6E6E6E6E6E6E6E6E683C1
        C4C4F0F3F3F3F3F3F3F3E21B101A1A191A1A191A1A1A1D202425242525252525
        4325434343444444454445454545474547474747484748484848485353535354
        54715471717171717172717272737373737473747DE2F3F3F3F3F3ECFEFEFEFE
        FEFEFEFEFEBFFDFCFDFEBFFDFDFDFDF4FEFEFDFEFEFEFEFEFEFBECBCBCE1F7FE
        FEFEFEFEFEFEFEFEFEFEFEFEB7D8D9D9D8D8D8D8D9D8D8D9D9D8D9D8D8D8D8D8
        0000DDDDDDDDE6DDDDE6DDE6DDE6DDE6DDE6DDDDE6E6E6DDE6E6E6DDE6E6B1C1
        C4C4F0F3F3F3F3F3F3F3D01A1A1A1A1A1A1A1A1A1A1A1A1A1B20242524252525
        2543254343434444444544454545454745474747474847484848484853535353
        54547154717171717171727172727373737374737CF1F3F3F3F3EEF7FDFEFEFE
        FEFEFEFEFEBFFCFCFCFCBFFEFCFEFEFCFEFDFEFEFDFEFDFEFEFEFEFEFEF7BFBC
        BCECFCFEFEFEFEFEFEFEFEFE90D9D8D9D9D8D8D8D8D8D8D9D9D8D8D8D8D8D8D8
        0000DDDDE5DDDDE6DDDDE6DDE6DDDDE6DDE6E6DDE6E6E6E6DDE6E6E6E6D789C1
        C4C8F3F3F3F3F3F3F3F38C1A1B1A1B1A1B1A1B1A1B1A1B1A1B1A1B1E25242525
        2525432543434344444445444545454547454747474748474848484848535353
        535454715471717171717172717272737373737481F3F3F3F3F3E1FEFEFEFEFE
        FEFEFEFEFDBFFCFCFEFCBFFCFCFEFCFEFCFEFCFEFDFEFEFDFEFDFEFEFEFEFEFE
        FCEFBDBCBEEFFEFEFEFEFEFE90D8D8D8D8D8D8D8D8D8D8D9D8D8D8ABD9ABD9D8
        0000DDDDDDE5DCDDE5DDDDE5DDE5DDE5DDE5DDE5DDE5E5E6E6E5E5E6DDD68CC0
        C4C4F3F3F3F3F3F3F3F35B1B1B1A1B1B1A1B1B1A1B1B1A1B1B1A1B1B1B202525
        2525254325434343444444454445454545474547474747484748484848485353
        5353545471547171717171717271727273737373B2F3F3F3F3F3E1FEFEFEFEFE
        FEFDFEFEFDBFFCFCFCFCBFFCFCFCFCFCFDFEFDFEFCFEFDFEFDFEFEFDFEFEFEFE
        FEFEF7FEFBECB9BCE1FEFEFE84D9D8D8D8D8D9D9ABD9D8D9D9D8ABD9ABD9ABD8
        0000DDDDDCDCDDDCDDDDDCDDDDE5DCDDE5DDE5DDE5DDE5E6DDE6E5E6E5BA8CC1
        C4CAF3F3F3F3F3F3F3F34C1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1D23
        2525252543254343434444444544454545454745474747474847484848484853
        5353535454715471717171717172717272737373B9F3F3F3F3F3E1FEFDFEFDFE
        FEFDFEFDFDBFFBFCFCFCBFFCFCFCFEFCFCFCFCFCFEFEFCFEFEFCFEFEFDFEFDFE
        FEFEB0383EBFEFFEBFFEFEFE84D8D8ABD9D8D8D8D8ABD8D8D9ABD9ABD9ABD8AB
        0000DCDDDCDDDCDDDCDDDDDCDDDDE5DCDDDDE5DDE5DDDDE5E6DDE6DDE6B7C0C1
        C4CAF3F3F3F3F3F3F3F3401B1C1B1C1B1D1B1C1B1C1B1D1B1C1B1C1B1C1B1C1B
        1E25252525432543434344444445444545454547454747474748474848484848
        5353535354547154717171717171727172727373BDF3F3F3F3F3ECFEFEFEFEFD
        FDFDFDFCFEBEFBFBFCFCBFFBFCFCFCFEFCFCFCFCFCFCFEFDFEFCFEFCFEFEFEFD
        FEFDEC3E383838FEBFF7FEFEBBD8D8D8ABD9ABD9ABD9D8D9D8ABD8D8ABD9ABD8
        0000DCDCDCDDDCDDDCDCDDDCDDE5DCDDDDDDE5DDE5DDE5DDE5E6E5E6DDB2C0C1
        C4D2F3F3F3F3F3F3F3EE211D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D
        1D1E232525254325434343444444454445454545474547474747484748484848
        485353535354547154717171717171727172727AE1F3F3F3F3F3EDFEFDFDFDFD
        FCFEFCFDFDBEFBFBFBFBBFFCFCFCFCFCFCFCFCFCFCFCFCFCFCFEFDFEFCFEFCFE
        FEFEFDFEFDBFAEFEBFEFFEFEBBD8ABD8ABD8D8ABD9ABD8D8D8ABD9ABABABD9AB
        0000DCDCDCDCDDDCDDDCDCDCDCDDDDE5DCDDDDDDE5DCDDE5DDE5E5DDE5B2C0C1
        C4D3F3F3F3F3F3F3F3E21D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D
        1D1D1D2325252543254343434444444544454545454745474747474847484848
        484853535353545471547171717171717271727CEDF3F3F3F3E2F7FDFCFEFCFE
        FCFDFDFCFCBFF7FBFBFBBFBEECF7FCFCFCFCFCFEFCFCFCFCFCFCFCFEFCFEFEFC
        FEFDFEFDFEFEFEFEEDEFFEFEBAD8ABD8ABD8ABD9ABABD8D8D8ABABD9ABD9ABAB
        0000DCDCDCDCDCDCDCDCDCDCDCDCDDDDDDE5DCDDDDDDE5DCDDE5E6DDE68BC0C1
        C4E7F3F3F3F3F3F3F3CD1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E
        1E1E1E1D20252525432543434344444445444545454547454747474748474848
        4848485353535354547154717171717171727178F3F3F3F3F3D0FCFEFCFDFDFC
        FCFCFDFCFCBEF7F7FBFBF7EFECBEBCB4BFEFFBFCFCFCFEFCFCFCFCFCFDFCFCFE
        FEFCFEFEFCFEFEFEEFEFFEFDBAD8ABABD8ABD8ABD8ABD8D8ABD9ABABD8ABABAB
        0000DCDCDCDCDCDCD9DCDCDCDCDCDDE5DCDDDCDDE5DDDDE5DDE5DDE5DD63C0C1
        C4F0F3F3F3F3F3F3F38C1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E
        1E1E1E1E1E202525254325434343444444454445454545474547474747484748
        4848484853535353545471547171717171717283F3F3F3F3F3E2FDFDFCFCFCFD
        FCFCFCFCFCBDF7F7F7F7FBFBF7FBFBFBEFE1BCBCBCECEFFCFCFCFEFCFCFCFCFC
        FCFEFDFEFCFEFCFEEFEFFEFEB0D8ABABABABD8ABABD8ABD8ABABABABABABD8AB
        0000DCDCDCDCDADCDCDCDCDCDCDCDCDDDCDCDDE5DDDDDDE5DCDDE5E5E589C0C1
        C4F1F3F3F3F3F3F3F35E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E
        1E1E201E1E1E2025252543254343434444444544454545454745474747474847
        48484848485353535354547154717171717171B2F2F3F3F3F3E1FCFCFCFCFCFC
        FCF8FCFBFCBDF2F7F7F7F7F7F7FBF7FBFBFBFBFBFCEDBEBCBCBFECF7FCFCFCFC
        FCFCFCFCFEFDFEFCEFEFFCFEBCABD8ABABD8ABABABABD8ABABABAAABABABABAB
        0000DCDCD9DCDCD9DCDCD9DCDCDCDCDDDDDDDCDCDDDDE5DCDDE5DDE6C6B1C0C1
        C4F3F3F3F3F3F3F3F35020202020202020202020202020202020202020202020
        2020201E20202020252525432543434344444445444545454547454747474748
        47484848484853535353545471547171717171BDF3F3F3F3F3E1FCFCFCF8FCFB
        FCFBF9FBFBBDF2F2F7F2F7F7F7F7F7F7FBFBF7FBFBFBFCFBFCEFECBFBCBCBFEF
        FCFCFCFCFCFCFEFCEFBFFEFDBFABABD8ABABABD8ABD8ABABABAAABAAABABABAB
        0000DCDCDCD9DCDCD9DCDCDCD9DCDCDCDDDDE5DCDDDDDDDCDDE5DDE5D78AC0C1
        C8F3F3F3F3F3F3F3F34120202020202020202020202020202020202020202020
        2020202020202020232525254325434343444444454445454545474547474747
        48474848484848535353535454715471717152BEF3F3F3F3F1EDFCFBFCF8FCF8
        FBFBF8FBF3BDF2F2F2F2EEEEF7F2F7F7F7F7FBF7FBFBFBFBFCFBFCFBFCFCEFEC
        BCBCBCECEFFCFCFDEFBFFEFCBFABABABD8ABABABABABABD8AAAAABAAABAAABAA
        0000DCD9DCDCD9DCDCD9DCD9DCDCDCDCDCDDDCDDDCDDDDDDDCDCDDE5C38CC0C0
        CAF3F3F3F3F3F3F3F04120202020202020202020202020202020202020202020
        2020232023202023202425252543254343434444444544454545454745474747
        47484748484848485353535354547154717179E2F3F3F3F3E2F7FCF8FBFBFBF8
        FBF3FBF3FBBDEFF2EFF2BCBDB0BCBDE1EFF7F7F7F7F7FBFBF7FBFBFCFBFBFCFC
        FCFCFCEFBFB0BCBFECBFFCFEBFABD8ABABABABABABD8ABABABAAAAABAAABAAAB
        0000DCDADCD9DBD9DCDADCDBD9DCDCDCDCDDDCDDDCDDDDDDDCDCDDDDB78CC0C1
        CAF3F3F3F3F3F3F3E22323232323232323232323232323232323232323232323
        2323232323232323232324252525432543434344444445444545454547454747
        4747484748484848485353535354547154715EEEF3F3F3F3D1FBF8FBFBF8FBF3
        FBF8F7F3F3BDEFF2EEF2BCF2F2F2EFECBDB9B9BCD0EDF7F7FBFBFBF7FBFBFBFB
        FBFCFCFCFCFCFCF7ECEFFCFCBFA5ABABABABABABABABABABAAAAABAAABAAABAA
        0000DAD9D9DCD9DCD9DCD9DCD9DCD9DCDCDCDCDCDCDCDCDDDCDDDCDDB29FC0C1
        D3F3F3F3F3F3F3F3BA2323242324232423242324232423242324232423242324
        2324232423232323232424252525254325434343444444454445454545474547
        47474748474848484848535353535454715461F3F3F3F3F3D0FBF8F7F3FBF3FB
        F3F3F3F3F3BCEEEEEEF2BCF2D43365ADF2F7EFEFECBEB0B9BCD0EDFBFBFBF7FB
        FBFBFBFCFCFCFCFCFCFCFCFCBFA5ABABABABABABABABABAAAAAAAAABAAABAAAB
        0000D9DCD9DCD9D9DCD9DCD9DCD9DCD9DCDCDCDCDCDCDCDCDDDCDDDCB19EC0C1
        D3F3F3F3F3F3F3F38C2424242424242424242424242424242424242424242424
        2424242424242424242424242525252543254343434444444544454545454745
        4747474748474848484848535353535454718BF3F3F3F3F3ECF3FBF3FBF3F3F3
        F3F3F3F2F3BCEEEEEEEEBDEFD431302FF2EFF2F2F2F2F7F7EFECBFB9BCBDBFEC
        FBFBFBFBFBFBFCFCFCFCFCFCEFA5ABABABABABABABABABAAAAAAAAAAAAAAABAA
        0000D9D9DAD9D9D9D9DBD9DCD9DCD9D9DCDADCDCDCDCDCDCDCDCDCDCB1C09FC0
        F0F3F3F3F3F3F3F37C2524252425242524252425242524252425242524252425
        2425242524252425242524252525252525432543434344444445444545454547
        454747474748474848484848535353535454B4F2F3F3F3F3D0F3F3F3F3F3F3F2
        F3F2F3F3F1BCEDEEEDEEBCEEEEEEEEF2EEF2EFF2F2F2F2F2F7F2F7F7F7F7EDBF
        BCB9BCBFEDFBFBFBFBFCFCFCEDA4AAABABABABABABABABAAAAAAAAAAAAAAABAA
        0000D9D9D9D8D9D9DCD9DCD9DCD9DBD9DCDCDCDCDCDCDCDCDCDCDCDC639EC0C1
        F0F3F3F3F3F3F3F35D2525252525252525252525252525252525252525252525
        2525252525252525252525252525252525254325434343444444454445454545
        47454747474748474848484848535353534FBDF3F3F3F3EDEDF3F2F3F3F2F3F3
        F1F1F1F1F1B9EDEDF0EDBCEEEEEEEEEEEFF2EEF2EFF2EFF2F2F2F2F7F2F7F7F7
        F7F7F7ECBFBDBCBCBFF7FBFCEDA1AAABABABABABABABABAAAAAAAAAAAAAAAAAA
        0000D9D8D8D9D8D8D9D9D9D9DCD9D9D9D9DCDCDCDCDCDCDCDCDCDCDC89C0C0C0
        F3F3F3F3F3F3F3F3462525252525252525252525252525252525252525252525
        2525252525252525252525252525252525252543254343434444444544454545
        454745474747474847484848484853535352E1F3F3F3F3D1F3F2F3F3F1F1F1F1
        F3F1F0F1F1B9E2EDE2EDB9EDEEEDEEEEEEEEEEEEF2EEF2EFF2EFF2F2F2F2F7F2
        F7F7E162B4ECFBFBD0BEFBFBEDA3AAAAABAAABABABABABA9A9AAAAAAAAA9AAAA
        0000D9D8D9D8D9D8D9D9DCD9D9DCD9DCD9DADCDCDCDCDCDCDCDCDCC6B19EC0C1
        F3F3F3F3F3F3F3ED462543434325434343254343432543434325434343254343
        4325434343254343432543434325432525252525432543434344444445444545
        45454745474747474847484848484853535DE2F2F3F3F3D1F2F1F1F1F3F1F1F0
        F1F0F1F0F0B9E2E2E2EDB9EDEDEDEDF0EEEEEEEEEEEEEEF2EFF2EFF2EFF2F2F2
        F2F7BF38383838E1EFBDFBFBED90AAAAAAAAABABAAABAAA9A9AAAAAAAAA9AAAA
        0000D9D8D8D9D8D9D8D9D9D9D9D9DCD9D9D9DCDADCDCDCDCDCDCDCC68AC09FC8
        F3F3F3F3F3F3F3E2444444444444444444444444444444444444444444444444
        4444444444444444444444444444444444432525254325434343444444454445
        454545474547474747484748484848485357F3F3F3F3F3D0F1F1F1F1F0F0F1F0
        F0F0F0F0E7B9D1D1E2E2B9E2E2EDE2EDEDEDEEEDEEEEEEEEEEEEF2EEF2EFF2EF
        F2F2F2EFBFAE3DE1F7BEF7FBF790AAAAAAABAAABABAAAAA9A9AAA9AAA9AAAAA9
        0000D8D8D9D8D8D8D9D8D8D9D8D8D9D9D9D9DCDCDCDADCDCDCDCDCB78C9EC0C8
        F3F3F3F3F3F3F3C7444544454445444544454445444544454445444544454445
        4445444544454445444544454445444544454425252543254343434444444544
        454545454745474747474847484848484881F3F3F3F3F3BEF1F0F1F0F0F0F0F0
        E7F0E7E7E7B4D1D1D1E1B9E2E2E2EDE2EDE2EDEDEEF0EEEEEEEEEEEFF2EEF2EF
        F2EFF2F2F2F2F7F2F7BDF7F7F790AAAAAAAAAAABAAABA9A9A8A9A9A8A9AAAAA9
        0000D8D8D8D8D9D8D8D9D8D8D9D8D9D9D9D9D9DCDCDCDCDCDADCDAB79DC0C0CF
        F3F3F3F3F3F3F3B3454545454545454545454545454545454545454545454545
        4545454545454545454545454545454545454545444325254325434344444445
        4445454545474547474747484748484848B2F2F3F3F3F3D1F0F0F0F0E7F0E7E7
        E7E7E7E7E4B4CED1D1D1B4D1E2E1D1E2E2EDE2EDEDE2EDEEF0EEEEEEEEF2EEF2
        EEF2EFF2EFF2F2F7EFBEF7F2F790AAAAAAAAAAAAABAAA9A9A9A8A9A9A8A9AAA9
        0000D8D8D8D8D8D8D8D8D8D9D8D8D9D9D9D9DCD9DCDADCDCDCDADCB29D9FC0D2
        F3F3F3F3F3F3F387454747454747454747454747454747454747454747454747
        4547474547474547474547474547474547474547474545254325434343444444
        4544454545454745474747474847484848BCF3F3F3F3E2D3F0E7F0E7E7E7E7E7
        E4E7E4D3E4B4CECECECEB4BDCDD1E2D1E2E2E2E2EDE2EDEDEDEDEDEEEEEEEEEE
        EEEEF2EEF2EFF2F2F2B9F2F7F28BAAAAAAAAAAAAABAAA9A9A8A9A9A9A8A9A8A9
        0000D8D8D8ABD8D8D8D8D8D8D8D8D8D9DCD9D9DCDCDCDADCDADCDAB19E9EC0E7
        F3F3F3F3F3F3F37C474747474747474747474747474747474747474747474747
        4747474747474747474747474747474747474747474747474544432543434444
        444544454545454745474747474847484FBDF3F3F3F3CEF0E7E7E7E7E4E7E4E4
        D3E4D2D2D2AFCECDD0CECDBDB4B4AEB4B0B9BDBED1E2E2EDE2EDEDEDEDEDEEEE
        F0EFEEEEEEF2EFF2EFB0EFF2F284A9AAAAAAAAAAABAAA8A9A8A9A8A9A8A9A8A9
        0000D8ABD8D8ABD8D8D8D8D8D8D8D8D8D9D9D9DADCDADCDCDCDADCB19DC09FF0
        F3F3F3F3F3F3F34E474847484748474847484748474847484748474847484748
        4748474847484748474847484748474847484748474847484847474544434344
        4444454445454545474547474747484751E2F3F3F3F3D0E4E7E4E7E4D3E4D2D2
        D2D2CCCFCFB2CDCDCDCECDCECED0CED0CECECDB9B9B0B4B0B9BDBFE2EDEDEDED
        EEEDEEEEEEEEEEF2EEB9EFF2EF8BA9AAAAAAAAAAAAAAA8A8A8A9A8A9A8A9A8A9
        0000D8D8ABD8D8D8ABD8D8D8D8D8D8D8D9D9D8D9DADCDADCDCD9DC639E9EC0F3
        F3F3F3F3F3F3E24E484848484848484848484848484848484848484848484848
        4848484848484848484848484848484848484848484848484848484848484744
        4444444544454545454745474747474857F0F2F3F3F3CED3E4D3E4D2D2D2CCCF
        CFCFCFCCCAAFC7CDBDC7CDCECDCECECED1CED0D1D1D1D1D1D1BEBDB9B0B4B0B9
        BDD0E1EEEEF0EEEEEFBDEEF2EFB7A9A9A9A9AAAAABA9A8A9A8A8A8A8A9A8A8A9
        0000D8ABD8D8D8ABD8ABD8D8D8D8D8D8D9D9D8D9D9DCD9DCD9DCD9899DC09FF3
        F3F3F3F3F3F3D053485348534853485348534853485348534853485348534853
        4853485348534853485348534853485348534853485348534853485348534853
        484847454544454545454745474747475BF3F3F3F3F3BAD2D2D2CCD2CFCCCFCC
        CACACACACAAEC2BAC7C7C7CDCDCDCECDCECECECECED1CED1D1D1D1E2E2E2E2E2
        BFBEB9B0B4B4B9BCD0B9EEEEEEB7A9AAA9A9AAAAAAA9A8A8A9A8A8A8A8A8A9A8
        0000D8D8ABD8ABD8D8ABD8D8D8D8D8D8D8D9D8D9D9DCD9DCD9DCC6899D9FC4F2
        F3F3F3F3F3F3C754545454545454545454545454545454545454545454545454
        5454545454545454545454545454545454545454545454545454545454545454
        5454545454484847474545474547474789F5F3F3F3F0CDCFCFCFCFCACACACACA
        CAC8C8C8C8B2B2B5BAC2BAC7BACDC7CDCDCECECECECED1CED0DED1D1D1E2E1E2
        E2E2EDE2EDEDEDD0D0BFEEEEEEB7A9A9A9AAA9AAABA877A8A8A89AA89AA8A8A8
        0000D8ABD8ABD8ABD8ABD8ABD8D8ABD8D8D8D8D8D9D9DCD9DCD9C68A9E9EC8F3
        F3F3F3F3F3F3B354545454545454545454545454545454545454545454545454
        5454545454545454545454545454545454545454545454545454545454545454
        54545454547154545471545353484848B2F2F3F3F3E2CFCCCACACACACAC8CAC8
        C8C8C8C4C4C4AEB1B5B5B5BAC2BAC7CDBDC7CDCECDCECECECED1CED1D1D1D1E2
        D1E2E2E2E2EDE2EDEDEDF0EDEEB6A8A8A9A9A9AAAAA9777777A8A8A8A89AA8A8
        0000D8ABD8ABD8ABD8ABD8ABD8ABD8D8D8D8D8D8DCD9DCD9DCDCB78A9E9ECAF3
        F3F3F3F3F3F38871717171717171717171717171717171717171717171717171
        7171717171717171717171717171717171717171717171717171717171717171
        71717171717171717171717171717171C3F3F3F3F3CECACACAC8CAC8C8C8C4C8
        C4C4C4C4C4C19FB1AEB1B2B2B5B5C2BAC7BAC7CDCDCDCDCECECECECECED1CED1
        D1E2D1E1E2E2E2EDE2EDEDE2EDB7A8A8A8A9A9AAAA7777777777A8A8A8A89AA8
        0000D8ABD8ABD8ABD8ABD8ABD8ABD8D8D8ABD8D8D9DCDCD9DCD9B79B9E9ED2F3
        F3F3F3F3F3F37D71717171717171717171717171717171717171717171717171
        7171717171717171717171717171717171717171717171717171717171717171
        71717171717171717171717171717171D0F3F3F3F3CDC8C8CAC8C4C8C4C4C4C4
        C4C1C49FC19F9F9F9F8C8A8A89898389AEAEAFAFB5B4CDCDCDCDCECECECED1CE
        D0D1D1D1E2D1E2E2E2E2EDE2ED8B9AA8A8A8AAA9A877707777777777A8A8A8A8
        0000ABABABD8ABD8ABD8ABD8ABD8ABD8ABD8D8D8D8D9D9DBD9D9B29D9E9ED3F3
        F3F3F3F3F3F37A72717272727272727272727272727272727272727272727272
        7272727272727272727272727272727272727272727272727272727272727272
        72727272727272727272727272727272E2F2F3F3F3C7C8C4C4C4C4C4C4C4C19F
        C49F9F9F9F9F9E9C9E9C9C9C9C9C9C9E9E9F9E8C8CB1B189AEB2AEB0B0B5BDC7
        CECED1CED1D1D1E1D1E2E2E2D188A89AA8A8AAA9A877707577777777A877A877
        0000ABABABABABABABABABABABABABABD8ABD8ABD8D8D8D9D9DB849D9E9EF0F3
        F3F3F3F3F3E26673737273727272727272727272727272727272727272727272
        7272727272727272727272727272727272727272727272727272727272727272
        7272727272727272727272727272727AF1F3F3F3F3C2C4C4C4C4C1C19FC19F9F
        9F9F9F9C9E9C9C9C9C9C9C9C9E9C9F9F9F9FC1C1C1C1C4C4C8C8C8C8C4C7C2B2
        B5AEB4AFB0B4B4CDBDD0D1BEAE97A8A8A8A8A9A9777570707577777777777777
        0000ABABABABABABABABD8ABD8ABD8ABABABABD8D8D8D8D9D9D9899D9E9EF0F3
        F3F3F3F3F3E17373737373737373737373737373737373737373737373737373
        7373737373737373737373737373737373737373737373737373737373737373
        7373737373737373737373737373737DF3F3F3F3E2C0C49FC19FC19F9F9F9F9C
        9E9C9C9C9C9C9C9C9E9C9F9F9F9FC1C1C1C4C4C4C4C8C8CBC8CACCCCCACFCCD2
        D2E4D2E7E4E7CECEC388888E97A8A8A8A8A8A9A8757075757075777777777777
        0000ABAAABAAABABABABABABABD8ABABD8ABABD8D8D8D9D8D9D9639D9DC0F3F3
        F3F3F3F3F3C77474747474747474747474747474747474747474747474747474
        7474747474747474747474747474747474747474747474747474747474747474
        747474747474747474747474747474A0F2F3F3F3D09F9F9F9F9F9F9C9F9C9C9C
        9C9C9C9C9E9C9F9F9F9F9FC1C1C4C4C4C4C4CBC8CACCC8CCCACCCFCCD2D2E4D3
        E4E7E4E4D9AA9A7798777798A8A8A8A898A8A9A8757070757570757675757575
        0000AAABAAABABABABABABABABABABABABD8ABD8ABD8D9D8D9D9899B9E9EF3F3
        F3F3F3F3F3C37492749274927492749274927492749274927492749274927492
        7492749274927492749274927492749274927492749274927492749274927492
        749274927492749274927492749292C2F3F3F3F3CD9F9F9E9C9E9C9C9C9C9C9C
        9C9E9E9F9F9F9FC1C1C1C4C4C4C4C8CBC8CCC8CCCACFCCCFE4D2D2E4E7E4DBDB
        D8D8ABABA9A8777677777677A89877A898A8A9A8757070707075707070707070
        0000AAAAAAAAABABABABABABABABABABABABABABABD8D8D8D8C6899D9DC8F3F3
        F3F3F3F3F3A39292929292929292929292929292929292929292929292929292
        9292929292929292929292929292929292929292929292929292929292929292
        929292929292929292929292929292C9F3F3F3F3C29C9C9C9C9C9C9C9C9E9C9F
        9F9FC19FC1C1C4C4C4C8C8CBC8CACCC8CCCFCCCFE4D2D2E4E4DBDBD8ABABABAB
        ABABABAAAAA8707677777776777777989898A8A8707070757070707570757570
        0000ABAAABAAABAAABAAABABABAAABABABABABABABD8D8D8D8C68A9D9EC4F3F3
        F3F3F3F3F37E9494949494949494949494949494949494949494949494949494
        9494949494949494949494949494949494949494949494949494949494949494
        949494949494949494949494949494D1F3F3F3F38A9C9C9C9C9E9C9F9F9F9FC1
        C1C1C1C4C4C4C8CBC8CACCC8CCCACFCCD2D2E4DBDBCBD8ABABABAAABABABAAAB
        AAABABABAAA8707575757777757677987798A877756E70707070707075707075
        0000ABAAAAAAAAAAAAABAAABABABAAABABABABABABABD8D8D8B7869D9ECFF3F3
        F3F3F3F3F37E9694969496949694969496949694969496949694969496949694
        9694969496949694969496949694969496949694969496949694969496949694
        969496949694969496949694969494E1F3F3F3EE8A9C9E9E9F9F9F9FC1C1C4C4
        C4C4CBC8C8CBC8CACCCACCCFCCD2DBCBD8D8ABABABABABABABABABAAABABABAA
        ABAAABABAAA87070707075777075777677A8A877756E70707570707070707070
        0000AAAAABAAABAAABAAABABAAABABABABABABABABABD8D8D8909B9D9ECFF3F3
        F3F3F3F3F3909996969996969696969696969696969696969696969696969696
        9696969696969696969696969696969696969696969696969696969696969696
        969696969696969696969696969995F3F3F3F3E29F9F9FC19FC1C4C4C4C4C4C8
        CBC8CACACCCACFCCCCCCDBD8ABABABABABABABABABABABABAAABABABAAABAAAB
        AAABAAABAA777070707075707070757076A87777707070707070707070707070
        0000AAAAAAAAAAAAAAABAAABAAABAAABABABABABABABD8D8D8B29B9D9EE7F3F3
        F3F3F3F3F3E2A099999999999999999999999999999999999999999999999999
        9999999999999999999999999999999999999999999999999999999999999999
        9999999999999999999999999999A0F2F3F3F3CDC1C1C1C1C4C4C4C8CBC8CACC
        C8CCCFCBCBCBA7AAAAD8D8ABABABABABABABABABABABABABABAAABAAABAAABAA
        AAAAABAAAAA87070707070707070707076777775707070707070707070707070
        0000AAAAAAAAAAABAAAAAAAAAAAAABAAABABABABABABABABD8849B9D9EF0F3F3
        F3F3F3F3F3F3F1E2E2E2E2BDBDBDCDD6CAD6C9CAD6CAC9C3B6B3B7A3A4A3A3A4
        A3A3A488888887A0A095A0A0A095A0A0A095A09A999A999A999A999A999A999A
        999A999A999A999A999A999A9997CEF3F3F3F3C9AAAAAAAAA7ABA7ABA7A7ABA7
        A7ABAAAAAAAAAAAAAAABD8ABABABABABABABABABABABAAABAAABAAAAAAAAAAAB
        AAAAAAABAAA8707070757070757070707677766E707070707070707070707070
        0000AAAAAAAAAAAAAAAAAAAAAAAAAAABAAABABAAABABABABD88B9B9D9EF1F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3EEE2E2E2E2E2E1E2E1E2E1E2D0BDBDBDCE
        CAD6CADECAD6CAC9B7B5B7A3C3D1F3F3F3F3F3C5AAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAABD8ABABABABABABABABABAAABAAABAAAAAAAAABAAAAAA
        AAAAAAAAAAA87070707070707070756E75A8756E707070707070707070707070
        0000AAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAABAAABAAABD8D8A584899EF1F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3A1AAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAA9ABABABABABABABABABABAAABAAABAAABAAAAAAAAAAAAAA
        AAAAAAABAAA8706E707070707070706E75A8756E7070707070707070706E7070
        0000AAAAAAA9AAAAAAAAAAAAAAAAAAAAAAABAAABAAABABABD8D8D8A3AECEF3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3E2A2AAAAAAAAAAAAAAAAAAAAA9AA
        AAAAAAAAAAAAA9AAAAAAAAABABABABABABAAABAAAAAAAAAAAAAAAAAAAAAAAAAA
        A9AAAAAAAAA86E6E706E706E70706E6E75A8756E706E706E706E706E706E7070
        0000AAAAA9AAAAA9AAAAAAAAAAAAAAAAAAAAABAAABAAABABD8D8D8D8ABB7E2F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3C9A6AAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAA9AAAAAAABABAAABABAAABAAAAAAAAAAAAAAAAAAAAAAAAAAA9
        AAAAAAAAAAA8706E6E7070706E70706E7577756E707070707070707070706E70
        0000AAA9AAA9AAAAAAA9AAAAAAA9AAAAAAAAAAABAAABAAABD8ABD8D8D8ABC6C9
        D0E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2EDF3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3D1A2AAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAA9AAAAA9AAA9AAAAABABAAABAAABAAAAAAAAAAAAAAAAAAAAAAAAAAA9AA
        AAAAAAAAAAA86E6E706E6E70706E6E6E7577756E706E706E6E6E6E6E7070706E
        0000A6AAA9AAA9AAA9AAA9AAA9AAAAAAA9AAAAAAABAAAAABABD8ABD8ABD8D8D8
        ABD8D8D8D8D9D8D8D8CBC6C6A4C6A4C6A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4
        A1A4A4A4C6A4A4A4A39090909090909090C3C6C6C6C6C6C6C6C6C6C6C6C6C6C5
        C6A4C6C6A4C6C6B7B7B7B3B7B7B7B7C9C5A2A6AAAAA9AAA9AAAAA9AAA9AAAAA9
        AAAAA9AAAAA9AAA9AAA9AAABABAAABAAAAAAAAAAAAAAAAAAAAA9AAA9AAAAAAA9
        AAA9AAA9AAA86E6E706E706E706E706E7577706E70706E70706E70706E6E706E
        0000A6A9AAA9A9A9AAA9A6AAAAA9AAA9AAAAAAAAAAAAABAAABD8ABABD8ABD8D8
        D8ABD8D8D8D9D8D9D8D9D8D9D8D8D8D8D8D8D8D8D8D8D8D8D8ABD8D8ABABABAB
        ABABABD8D8D8D8D8ABD8ABABABABABABABABABAAAAABAAAAAAAAAAAAAAAAA6AA
        A6AAA6AAA6AAA6A6A6A9AAA6A6AAA6AAA6AAA6A6AAA6AAAAA9AAAAA9AAA6AAA6
        A6AAAAA9AAAAA9AAA9A9AAABABAAABAAAAAAAAAAAAAAAAAAAAA9AAAAA9AAA9AA
        A9AAAAA9AAA8706E6E706E706E706E707070706E706E706E70706E706E706E70
        0000A9A9A9A9AAA9AAA9AAA9AAA9AAAAA9AAA6AAAAAAAAABABABD8ABABD8ABD8
        D8D8D8ABD8D8D9D8D9D8D9D8D9D8D8D8D8D8D8ABD8D8D8ABD8D8ABD8ABABABAB
        AAABAAABD8D8ABD8ABD8ABABABABABABAAABAAABAAABAAAAAAAAAAAAA6AAA6A6
        AAA6AAA9AAA6AAA9AAA6AAA6AAA9AAA6AAA9AAA9AAA9AAA9AAA9AAA6A6AAA6A6
        AAA6AAA9AAA6A9AAA9A9AAABABAAAAABAAAAAAAAAAAAAAAAAAA9AAA9AAA9AAAA
        A9AAA9AAAAA86E6E6E6E6E6E6E6E6E70706E6E706E6E6E6D6E6E6E6D706E6E6E
        0000A6AAA9AAA9AAA9A9A6A9A9A9AAA6AAA9AAAAA6AAAAAAABABD8ABABD8ABD8
        ABD8D8D8D8ABD8D9D8D9D8D8D8D8D8ABD8D8D8D8D8ABD8ABABABD8ABABABABAB
        ABABAAAAABD8D8ABD8ABABABABABABABABABABAAAAAAAAAAAAAAA6AAA9AAA6A9
        AAA6A6AAA6AAA9AAA9AAA6AAA9AAA6AAA9AAA6AAA9AAAAA9AAA6A6AAA9AAA9AA
        A6AAA9AAA9A9AAA9A9A9A6AAAAABAAAAAAAAAAAAAAAAA6A6AAA6AAA6AAAAA9AA
        A6AAA6AAAAA8706E6E6E6E706E706E6E6E6E706D6D6E6F6E6F6E706E6D6E706E
        0000A6A9A9A6AAA9A9A9A9A9A9A9AAA9AAA9AAAAA6AAAAAAAAABABABABD8ABD8
        ABD8D8D8ABD8D8D8D8D8D8D8ABD8D8D8ABD8D8D8ABD8ABD8ABABD8ABABABABAB
        ABAAABAAAAABD8ABD8ABABABABABABABAAABAAABAAABAAAAAAA6AAAAA6A6AAA9
        A6AAA9AAA6A6A6A6AAA6A6AAA9AAA6AAA9A6AAA9AAA9AAA9AAA9AAA9AAA9AAA9
        AAA9AAA9A9AAA9A9AAA9A9AAAAABAAAAAAAAAAAAAAA9AAA6A6A6A6AAA6AAA9AA
        A6A6A9AAAA986E6E6E706E6E6E6E6E70706E6D6D6E6D6D706D6E6E706D706E6D
        0000A9A9AAA9A9A9AAA9A9A6A9AAA9A9A9A6A6AAAAAAA9AAABAAABABABABD8AB
        D8ABD8D8D8ABD8D8ABD8ABD8ABD8ABD8D8D8ABD8D8ABD8ABD8ABABABABABABAA
        ABABABABAAABABD8D8ABD8ABABABABAAABABABAAAAAAAAAAAAAAAAAAAAA9A6AA
        A9AAA9A6AAA9AAA9A6AAA9AAA9AAA9AAA9A6A6A6A6A9A6A6A6A6A6A6A6A9A6A9
        A6A9A9A9A9A9A9A9A9A9A9A9AAABABAAA6AAAAAAAAA9AAA9AAA9AAA9AAA9A6A9
        A9A9A9A6AA776E6E6D6E6E706E6E6E706E6D6D6D706D6E6D6D6E6D6D6E6D6D6E
        0000A9A9A99AA9A9A9A9AAA9A9A6A9A9A9A9AAA9AAAAAAA9AAABABABABABABAB
        ABD8ABD8D8ABD8ABD8D8ABD8D8ABD8D8ABD8D8D8ABD8ABD8ABABABABABABABAA
        ABAAABAAABAAABABD8ABD8ABABABABAAABAAAAABAAABAAAAAAA6AAAAA9AAA9A6
        AAA9A6A9A6A9A6A9A9A9AAA9AAA9A9A6A9AAA9AAA9A9A9A9A9A9A9A9A9A9A9A9
        A9A6A9A6A9A9AAA9A9A9A9A9AAABAAAAAAA6AAA6A9AAA9A6AAA9A9A6A9A6A9A6
        A9A9A9A9AAA876706D6E6D6E6D6E6E6E6E706D6B6D6D6D6D6D6F6D6D6D6E6D6D
        00009A9AA89A9A9AA9A6A9A9AAA9A9A9A9AAA9A6AAA9AAAAAAAAABABABABABAB
        D8ABD8ABD8D8D8ABD8ABD8D8ABD8ABD8ABD8D8D8ABD8ABD8ABABABABABABABAA
        ABAAABAAABAAAAABD8ABABABABABABABAAABAAAAABAAAAA6AAAAAAA9AAA9AAA9
        A6A6A9A9A9A9A9A9AAA9A6A6A6A9A6A9AAA9AAA9A9A6A9A9AAA9A9AAA9A9A9A9
        AAA9A9A9AAA9A6A9AAA9A9A9AAABAAA9AAAAA6A9AAA9AAA9A6A9A9A9A6A9A9A9
        AAA9A9A9AA9A77706D6D6E6D6E6D6E6E6E6D6D6D6F6B6F6D6D6D6D6D6D706D6D
        00009A9A9A9A9A9A9AA9A9A9A9A9A6A9A9A9A9A9AAA9AAAAA6AAABD8ABAAABAB
        D8ABD8ABABD8ABD8D8ABD8ABD8D8ABD8D8ABD8ABD8ABABABABABABABABABABAA
        ABABAAABAAAAAAAAABD8ABABABABABABABAAAAAAAAAAA6AAA9AAA6A9A6A6A6A9
        A9A9A9AAA9A9A9A9A9A9A9A9A9A9A9A9A9A6A9A6A9AAA9A9A9A9A9A9A9A9A9A9
        A9A9A6A9A9A9A9A9A9A9A99AA6AAAAAAAAAAA9AAA9A6A6A9A9A9A9A9A9A9AAA9
        A9A9A9A9AAA8766E6D6E6D6E6D6E6D6E6E6D6B6D6D6B6D6F6D6D6D6D6D6D6D6D
        0000A9A8A9A8A99A9AA8A9A9A9A9A9A9A9A9A9A9AAA9AAA9AAAAABABABABABAB
        D8ABABABD8ABD8ABABABD8ABD8ABD8ABD8ABABABABD8ABABABABABAAABABABAA
        ABAAABABABAAAAAAAAABABABABAAABAAABAAAAABAAAAA6AAAAA9AAA9A9A9A9AA
        A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A6A9A9A6A9A9A9A9A9A9A9A9A9A9
        A9A9A9A9A9A9A9A9A9A99A9AA9AAAAAAAAA6AAA9A6A9A9A9A9A9A9A9A9A9A9A9
        A9A9A9A9A6A876706C6E6D6D6E6D6D6E6D6D6D6B6D6D6B6D6D6B6D6D6B6D6D6D
        00009AA89A9AA89A9A9A9AA9A9A9A9A9A9A9A9A9A9A9A6A6AAAAAAABABABAAAB
        ABABD8ABABABABD8ABD8ABD8ABD8ABD8ABABD8ABABABABABABAAABABABABABAA
        ABAAABAAABAAAAAAAAABABABABABABA7AAABAAAAAAAAA6AAA9AAA9A9AAA9A9A6
        A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9
        A9A9A9A9A9A9A9A9A99AA89AA9A6AAABA9A6A9A6A9A9AAA9A9A9A9A9A9A9A9A9
        A9A9A9A9A69A776F6D6D6D6D6D6D6E6C6E6D6B6D6D6B6D6B6D6D6B6D6D6D6D6D
        0000A89A98A898A89A9A9AA9A9A9A9A9A9A9A9A9A6A9A6A9A6AAAAABAAABABAB
        A7ABABABD8ABABABABABABABABABABABABABABD8ABABABABABA7ABAAABAAABAA
        ABAAAAAAAAAAAAA6A6AAABABAAABAAABAAAAAAAAAAAAA6AAA6A6A6A6A9A6A6A9
        A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9
        A9A9A6A9A9A9A6A9A89A9AA8A9AAAAAAA6A6A9A6A9AAA9A9A9A9A9A9A9A9A9A9
        A9A9A9A9A9A998706C6E6D6D6D6E6E6E6C6D6B6D6B6D6B6D6B6D6D6B6D6B6D6B
        000098A89898A898A89A9A9A9A9AA9A9A9A9A9A9A9A9A6A9A9AAAAABABA7ABAA
        ABABABABABD8A7D8ABABABABD8ABABABD8A7D8ABABABABABABABA7ABAAABAAAB
        AAABAAAAAAAAAAA6A6A6AAAAABABAAABAAABAAAAAAA6AAA9A6A6A6A9A6A9A6A9
        A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9
        A9A9A9A9A9A9A6A99A9A9A9AA89AAAAAA9A6A9A6A9A6A9A9A9A9A9A9A9A9A9A9
        A9A9A9A9A9A998752D6D6D6D6D6D6E6C6D6D6B6D6B6D6B6D6B6D6B6D6B6D6B6D
        00009898A89898A8989AA89A9A9A9AA9A9A9A9A9A9A9A9A9A9A6AAABABAAABAB
        AAABABAAABABABABABD8ABABABD8ABABABABABABD8A7ABA7AAABABAAABAAAAAB
        AAAAAAAAAAAAAAA6A6A6A9AAABAAAAABABAAAAAAAAA6A6A6A6A6A9A9A9A9A9A9
        A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A99AA9A9A9A9A9A9A9A9A9A9A9A99A
        A9A9A9A9A9A9A9A9A99A9A9A98A8A9AAA6A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9
        A9A9A9A9A9A998706C6D6D6C6D6D6C6D6D6B6B6C6B6D6B6D6B6D6B6D6B6D6B6C
        000077989898989898989AA89AA89A9AA9A9A9A9A9A9A9A9A9A9AAAAABABA7AA
        ABABABABABABABABABABABABABABD8ABABABABABABABABABAAABABA7AAABABAA
        ABAAABAAAAAAAAA6A6A6A9A6AAABABAAABAAAAAAAAA6A6A6A6A9A9A9A9A9A9A9
        A9A9A9A9A9A9A9A9A9A99AA9A9A9A9A9A9A9A99AA9A9A9A9A9A9A9A9A99AA9A9
        A9A9A9A9A9A99AA99A9AA89A9898A9A6A6A9A9A9A9A9A9A9A9A9A9A9A9A9A99A
        9AA9A99A9AA998706C6D6D6D6C6D6E6C6B6B6D6B6B6D6B6D6B6B6C6B6B6B6B6B
        0000777677989898989898A89A989A9A9AA9A9A9A9A9A9A9A9A9A6AAABABAAAB
        ABA7ABABABABABABABABABABABABABABABABABABABABABAAABABA7ABAAABABAA
        ABAAABAAAAAAAAA6A6A6A9A6AAAAABAAAAAAAAAAAAA6A6A6A6A9A9A9A9A9A9A9
        A9A9A9A9A9A9A9A9A9A99AA9A9A9A9A9A9A9A99AA9A9A9A9A9A9A9A9A99AA9A9
        A9A9A9A9A9A99A9A9AA8989A98989AA6A6A9A9A9A9A9A9A9A9A9A9A9A9A9A99A
        A89A9A9AA8A9A8752B6D6C6D6D6D6C6D6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B
        000077767677989898989898A89A9A9A9AA9A9A9A9A9A9A9A9A9A6AAABAAABAB
        AAABAAABABABABD8ABABABABABABABABABABABABABAAABAAABAAABAAABAAABAA
        ABAAAAAAAAA6A6AAA6A6A9A9A9AAABAAAAAAAAAAAAA6A6A6A6A6A9A9A9A9A9A9
        A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A99AA9A9A9A9A9A9A9
        A9A9A9A9A9A9A99A9A9898989898A8A9A6A9A9A9A9A9A9A9A9A9A99AA9A9A99A
        9AA89A9A98A9A9752D6D6D6C6B6C6E6C6B6A6B6B6C6B6B6B6B6B6C6B6B6C6B6B
        000077767776987698769898989AA89A9AA89AA9A99AA9A9A99AA6AAABABAAAB
        A7AAABABAAABABAAABABABABABABABABABABABABABAAABABAAABAAABAAABA7AA
        AAAAAAAAAAAAA6A9A9A6A9A9A9A6AAABAAAAAAAAAAA6A9A6A6A9A9A9A9A9A9A9
        9AA9A99A9AA9A9A99AA9A9A99AA9A99AA9A99AA9A99AA9A99AA9A9A9A9A99A9A
        A9A9A9A9A99A9A9AA89898989898A89AA6A9A99AA9A9A99AA9A9A9A99A9A9AA8
        9AA89AA89A9A9A752C6B6C6B6C6D6C6B6B6B6A6B6B6A6B6B6C6B6B6C6B6B6C6B
        00007776987676777676779898989AA898A89A9AA99AA9A9A9A9A9AAAAABAAAB
        AAABA7AAABAAABAAABABD8ABABABABABABABABABABA7AAABABAAABAAABAAABAA
        ABAAAAAAAAA6A6A6A9A9A9A9A99AA9AAAAAAAAAAAAA6A9A6A9A9A9A9A9A9A9A9
        9AA99AA99AA9A99AA9A99AA9A99AA9A99AA9A99AA9A99AA99AA99AA9A99AA99A
        9A9A9A9A9A9A9A989A9898989898779AA9A9A99AA9A9A99AA99A9AA99AA8989A
        A89A989A989AA8752D6C6B6B6D6C6D6C6B6B6A6B6B6A6B6B6C6B6B6C6B6B6C6B
        000077767698767776777676989898989AA89A9AA99AA9A99AA9A9A6AAABABAA
        ABAAABAAABABABAAABABABABABABABABABABAAABAAABAAABAAABAAABABAAAAAB
        AAAAAAAAAAAAA9A9A6A6A9A9A9A99AA6AAAAAAA6A6A9A6A9A9A9A9A9A9A9A99A
        A9A99AA9A99AA9A99AA99AA9A99AA99AA99A9AA9A99AA9A99AA99AA99AA99AA9
        A89AA89A98A89A989898989877767698A9A9A99AA99AA9A99AA89AA99AA89A98
        9A98A89898989A702D6A6B6C6D6C6C6B6B6A6B6B6C6A6B6C6B6A6B6C6B6A6B6A
        000077767676777676777677769898989AA89A9AA99AA99AA9A9A9A9AAABAAAB
        AAABAAABAAABAAABAAABABABABABABABABABAAABABAAABAAABAAABAAABAAAAAA
        AAAAAAAAAAA6A9A6A6A9A9A9A9A99AA9A6AAAAA6A6A9A6A9A6A9A9A9A9A9A99A
        A9A99AA9A99A9AA9A99AA99A9AA99AA99AA99AA99AA9A99AA9A99A9AA99AA9A9
        A89A989A989AA89898989877767676779A9AA9A9A99AA9A99A9AA89A9AA89A98
        9A989898779A98702D6B6C6C6C6C6B6A6A6B6A6B6C6A6B6A6B6A6B6C6A6B6A6B
        00007776767677767677767698989898A89AA8A9A99A9AA99AA9A9A6AAABAAAB
        AAABAAABAAABAAABAAABAAABABABABABABAAABABABAAABAAABAAAAABAAAAABAA
        AAAAAAAAAAA6A6A6A9A6A9A9A9A99AA9A9AAAAAAA9A6A9A6A9A6A9A9A9A99AA9
        A99AA9A99AA99AA99AA9A99A9AA9A99AA99AA99AA9A99AA99AA99A9AA99AA99A
        9A989AA89A9898989898777677767676989AA9A99AA9A99A9A9AA89AA89A989A
        9898989877989A706C6B6C6C6D6C6C6A6B6A6B6A6B6A6B6A6B6A6B6C6A6B6A6B
        0000767676767677767698769898989898989A9A9A9A9AA99AA99AA9AAABAAAB
        AAA7AAAAABAAABAAABAAABA7ABABAAABAAABAAA7AAABAAABAAABAAAAAAAAAAAA
        A6AAA6A6A6A6A9A9A6A9A9A9A9A99AA99AA6A6A6A9A9A9A9A9A9A9A9A99AA99A
        9AA99A9AA99A9AA99AA99AA99A9A9A9AA99AA99AA99AA9A9A89A9A9A9AA99AA8
        A898A898989898779877767676777676769A9AA99A9AA99AA89AA8989A989898
        989898989898A8766E6A6A6C6C6C6B6A6A6A6A6A6A6A6A6A6A6A6A6A6B6A6A6A
        0000767676767676777676767798769877989AA89AA99A9A9AA9A99AAAAAABAA
        A7AAABAAAAABAAABAAA7AAABABA7ABAAABAAABAAABAAABAAABAAABAAAAABAAAA
        AAA6A6A6A9A6A9A6A9A9A9A9A9A99AA9A89AA9A6A6A6A9A99AA9A9A99AA99A9A
        A99A9AA99A9A9AA99A9AA99AA99A9A9AA99A9AA9A99AA99AA89A9A9A9A9A9A98
        A89AA89A9898987798767677767676767698A9A99AA89AA898A898A898A89877
        9898989877989A76706B2B6A6C6C6B2B6A6A6A6A6A6A6A6A6A6A6A6A6B6A6A6A
        000076767676767676777676767676779898989AA8A99A9AA99A9AA9AAAAAAAA
        AAABAAA7AAABAAABA7ABAAABABABA7ABABABA7AAABAAA7AAAAABAAA7AAAAAAAA
        AAAAA6A6A9A9A9A9A9A99AA99AA99AA99A989AA9AAA69AA99AA99AA99A9A9AA9
        9A9A9A9AA8A99AA99A9A9A9AA99A9A9A9A9AA99A9A9A9A9A989A9A9A9A9A9AA8
        98A89898A8A898987676767676767676769A9AA9A8989A989898987798987798
        98987798989898776F6A6A6C6C6B2D696A6A6A6A6A6A6A6A6A6A6A6A6A6A6B2B
        00007676767676767676777676769898989898989A9AA99A9A9A9A9AAAA7AAAB
        AAA7AAABAAA7AAABAAA7AAABABA7ABABABABABAAA7AAAAAAABAAA7AAAAAAAAAA
        AAAAA6A6A9A9A6A9A9A99AA99A9A9A9A9A98989AA9A6A69AA99AA99AA99A9A9A
        A99A9A9A9AA99A9AA99AA89A989AA89A989AA99AA89AA99A9A9A989AA89A989A
        989A9898989A987776767676767676767698989A9A98989A9898987798989898
        9898989898989876752B2B6A6C6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A
        00007676767676767676767676769877989899989A9A9A9A9A9A9A9AA6AAABAA
        AAA7AAAAABAAA7AAABAAA7AAABABABA7ABABA7AAAAAAABAAA7AAAAAAAAAAAAAA
        AAAAA6A6A9A9A6A9A9A99AA99A9A9A9A9A98989A9AA9A6A9A99A9AA99A9A9A9A
        A99A9A9A9A9A9A9A9A9A989898A898989AA89A98A89A9A9A9AA898989898A898
        989A98987798987676777676767676767676989A9A9898989898989877989898
        7698769877987698752A2B6A6C6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A
        0000757676767576767676777676767698989898A89A989A9AA99A9AA6AAA7AA
        AAAAABAAA7AAAAABAAA7AAAAABABA7ABABAAAAAAABA7AAAAAAAAAAABAAAAA6AA
        A6A6AAA6A6A9A9A9A99A9A9A9A9AA99AA898989A9AA9A6A9A99AA99A9A9A9A9A
        9A9AA99A9A989A9A9898A89A989A989A9898989A98989898989A989A98989A98
        989898989877767676767676767676767676769A9A9898779898987698779898
        9876767676767676756A2B6A6C6A696A696A696A696A6A6A6A6A6A6A6A6A6A6A
        0000757576767676767676767676769876989898989A9A9AA89A9A9AA9A6AAAA
        AAAAAAABAAA7AAAAAAAAABAAABABABA7AAABAAA7AAAAAAABAAAAAAAAAAAAA6A6
        A6AAA6A6A9A9A99AA99A9A9A9A9A9A9A9A9A9898989AA9A69A9A9A9A9A9A9A9A
        9A9A9A9A9A98A89A989898989898989898989898989A989A98989898989A989A
        987798989876767676767676767676767675769A9A9877987698989876989898
        7698767676767677756B2A2D6A6A6A696A696A696A696A6A6A6A6A6A6A6A6A6A
        000075757675767576767576767676989876989898989A9A9A9A9A9A9AA6AAAA
        AAABAAA7AAAAABAAA7AAAAAAABABAAABAAA7AAAAAAABAAAAABA6AAAAAAAAA6AA
        A6A6A6A6A9A9A99A9AA99A9A9A9A9AA89A9A989898989AA9A99A9A9A9A9A9A9A
        9A9A9AA89A98989898A898989A989898989A989898989898989A989898989898
        98779876987776767676767676767576756F7598A89898987798987698987776
        9877767676767698756A2B6C6A6A696A696A696A696A696A6A6A6A6A6A6A6A6A
        00007570757075757676767676767676989877989A989A9A9A9AA89A9AA9AAAA
        AAAAAAAAA7AAAAAAAAABAAAAAAABAAAAAAAAA7AAAAAAAAAAAAAAAAAAA6A6A6AA
        AAA6A9A9A9A9A99A9A9A9A9A9A9A9A9A9A9898989877989AA99A9A9A9A9A9A9A
        9AA8989A98989898989A989898989A989898989A989898989898989A98987798
        98769898767676767676767675767675756B6D769A9A98779876989898777676
        7676767676767698766A292D6A69696A692B2A2B2A2B2A2B2A2B2A2B2B2B2B2B
        000075707570707575767576767676767677989898989A9A9A9A9A9AA8A9AAAA
        AAAAAAAAAAAAABAAA7AAAAABAAAAA7AAABAAAAA7AAAAAAAAAAAAAAAAA6A6A6AA
        AAA6A9A69AA9A99A9A9A9A9A9A9A9AA898989898987798989A9A9A9A9A9A9AA8
        9A9AA898989A98989898989898989898989A9898989A989A9898989898779898
        769876777676767676767676767676766F6C6D75989A98779898769876767676
        7676767676767698756C292D6A69696A692B2A2B2A2B2A2B2A2B2A2B2B2B2B2B
        000075707570757075757676767676767698779898989A9A9A9A9A9A9AA9AAAA
        AAAAAAAAAAABAAA7AAAAAAAAABAAA7AAAAAAABAAA7AAAAAAAAA6AAAAA6A6A6A6
        A6A6A6A6A99A9A9A9A9A9A9A9A9A9A98A89A989898987698989A9A9A9A9A9A98
        9A9A9AA89898989A98989A989A98989A9898989898989A987798769898987798
        987676767676767676767676757675756F6D6C70779898987798767676767676
        7676767676767676756A2D2B2B69692B2A2B2A2B2A2B2A2B2A2B2A2B692B2B2B
        000075707575757075757676767676769898987698A8989A9A9A9A9A9A9AA6AA
        AAAAAAAAAAAAAAAAAAAAAAABAAAAAAA7AAAAAAAAAAAAAAAAAAA6A6AAA6A6A6A6
        A6A6A6A99A9A9A9A9A9A9A9A9A9A9A98A898989877767676989A9A9A9A9AA898
        9A9A9A9A98A898989898989898989898989898989A9898987798987698779898
        9876767676767676757676767575756F6D6C6C6D769898987798767676767676
        7676767676767676756C2D2B2B696A2A2A6A696A2A2B2A2B2A2B2A2B2A2B2B6A
        00007575707070757075767676767676989877989898989AA89A9A9A9A9AA9AA
        AAAAAAAAAAABAAA7AAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAA6A6A6A6A6A6A6
        A6A6A99A9A9A9A9A9A9A9A9A9A9A9A98A89898987776767676989A9A9A9A9A98
        9AA89A98989A98989898A8989A98989898987798989898779898769898769876
        777676767676767676767676756F756E2D6C2D2D7598A8989877767676767676
        7676767676767698752D292B2B696A2A2A6A696A2A2B2A2B2A2B2A2B2A2B2B6A
        000075756E6C70757575767675767676769876987798989A9A9A9A9A9A9AA9A6
        AAAAAAAAAAAAAAAAABAAAAAAA7AAAAABAAAAAAAAAAAAAAA6A6A6A6A6A6A6A9A6
        A6A99A9A9A9A9A9A9A9A9A9A9A9A9A98A89898989876767675769A9A9A9A9A98
        98989898A89898989898989898989A9898989876989898779876989876989877
        767676767675767675767675757570706C6C6C6C70769AA89876767676767676
        7676767676767676756D292B2A2A2A2A2A2B2A2B2A2B2A6A692B2A2B692B2A2B
        00006D6D6D6C7075707575757676767676769876989898A89A9A9A9A9A9A9AA6
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAABA6AAAAAAAAAAAAAAAAA6A6A6A6A6A6A9A9
        A69A9A9A9A9A9A9A9A9A9A9A9A9A9A989898987798767676757676989A9A9898
        9A98989898989898987798989898989898989877989876987798987698987698
        769876767676767676767575756F75702D6C6C2D6C7577987676767676767676
        767676767675767675756B2B2A2A2A2A2A696A692B2A2B696A692B2A2B2A2B2A
        00002D6C2D6C7075757075757676767676767698989898A89A9A9A9AA89A9AA6
        AAAAA6AAAAAAAAAAAAABAAAAA7AAAAAAAAAAAAAAAAAAAAAAA6A6A6A6A6A6A99A
        A9A69A9A9A9A9A9A9A9A9A9AA89A9A989898987776767676767575769A9A9898
        9898A89898769876987798769898989898779898769898987698779898987698
        98989876767576767576766F7570706E6C6C6C2D2C6D76987676767676767676
        757675767576767576766F2B2A2A2A2A2A696A692B2A2B696A692B2A2B2A2B2A
        00006C6C6C6D707575707576767576767676769877989898989A9A9A9A9A9AA9
        AAAAA6AAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAA6A6A6A6A6A6A6A9A9
        A9A99A9A9A9A9A9A9A9A9A9A9A9A9A9898989877767676757675757598989A98
        98A8989898779898769898987698987798769898989898989898769876989877
        989876767676767675767575756F6D6C6C6C6C2D2C6D75987776767676767675
        767576767676757676986F282A2A2A2A2A692A2A2B2A2B2A2B2A2B2A2B2A2B2A
        00006C6C6C6C6D7075707576767676767676769898769898989A9A9A9A9AA8A6
        AAAAA6AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6A6A6A6A9A6A9A9A9
        A9A99A9A9A9A9A9A9A9A9A9A9A9A98A898989876767676767575756D70989A98
        9898989877987698989876989877989876989898987798989898989898769876
        7676767676767675757575756F6D6C6C6C6C2D2D2D6C6D757776767676767576
        767676757575767676986F28672A2A2A2A2A2A2A2A6A692B2A2B696A2A2B2A2B
        00006C6C6C6C2D6D70707575767576767676769876989898989A9A9A9A9A9AA9
        AAAAA6AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6AAA6A6A9A9A6A9A9A9
        9A9A9A9A9A9A9A9A9A9A9A9A9A98989898779876767676757575706D6C759898
        9877987698987798769898769876987798987698769898779876987798987676
        76767676767676756F7570756D2D6C6C6D2D2D2D2D2D2C707676767676767675
        767676757575757676986F2A2A692A2A2A2A69692A6A692B2A2B696A2A2B2A2B
        00006C6C6C6C6C6C6D707575757676767676767677989898989A9A9A9A9A9A9A
        AAA6AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6A6A6A6A6A9A9A9A9A9
        9A9A9A9A9A9A9A9A9AA89A9A9898989898777676767675756F75756D6D70769A
        9876989877987676989898989898767698769898779898989898987698987676
        767676767675756F7575706D6C6C6C6C2D2D2D2D2D2D2C709876767676757676
        767675757075706F76A8752A282A2A2A2A6969692A2A2A2A2A2B2A2B2A6A692B
        00006C6C6C6C6C6C2D707075757676767676767676989898989AA89A9A9A9A9A
        AAA6AAAAA6AAA6AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6A6A6A6A6A9A9A9A9A9
        9A9A9A9A9A9A9A9A9A9A9AA898989898989876767675757075756D6D6C6D7598
        9898987798987676767776767776767677987676777698767776987677767676
        76767676767675757570706C2D6C6D6C2D2D2D2D2D2D6C6E7576767676767575
        757675707570757076A875282A2A692A2A692A2A2A2A2A2A2A692B2A2B696A69
        00006C6C6C6C6C6C6C70757075767676767676767798769898989A9A9A9AA8A9
        AAA6A6A6AAA6A6AAAAAAAAAAAAAAAAAAAAAAAAAAA6A6A6A6A6A6A6A9A99AA99A
        9A9A9A9A9A9A9A9A9A9A98A8989898769877767676756F7570706C6C6C2C6E76
        9898987798767676767676767676767676767676767676767676767676767676
        76767576767576757575706C6C6C6C6C2D2D2D2D6C6C6C2D6C75767676767675
        707675757075707576986F282A2A696969692A2A2A2A2A2A2A692B2A2B2A2B69
        00006C6C6C6C6D2D6C7075757576767676767676779898989898989A9A9A9AA9
        AAA6A6A6AAAAAAAAAAAAAAAAAAAAAAA6AAA6AAAAAAA6A6A6A9A6A99AA99A9A9A
        9A9A9A9A9A9A9A9A9A98989A9898777676767676767575756F6D6C6C2D2D2D6D
        7698767676767676767676767676767676767676767676767676767676767676
        76757675767675756F75706C6C6C2D2D2D2D2D2D6C6C2D2C6D75777676767675
        6F7575707570757676776F2A2A2A2A69696969692A2A2A2B2A2B696A692A2A2B
        00002D6C6C6C6C6C6D6D707575757676757676767677989898989A989A9A9A9A
        A6A6A6A6AAAAAAAAAAAAAAAAAAAAA6A6A6AAA6AAA6A6A6A9A9A9A9A99A9A9A9A
        9A9A9A9A9A9A9A9AA89898989898777676767675756F70706D2D6C6C2D2D2C2D
        7075767676767676767676767676767676767676767676767676767676767676
        767675767675756F7570706C6C6C2D2D2D2D2D2D6C6C2D2D6C70757675757575
        707570757075707677766F282A2A2A69696969692A2A2A2B2A2B696A692A2A2B
        00002D2D6C6C6D6C6C2D6D70757076767676767676769877989898989A9A989A
        A9A6A6A6A6A6A6A6A6A6AAAAAAA6A6A6A6A6A6A6A9A9A99AA9A69A9A9A9A9A9A
        9A9A9A9A9A9A9A9AA89898989877987676767675756B6C6C6C6C2D2D2D2D6C6C
        2D70767676767576767676757676757676767676767676767676767676767676
        7676767675757575706D2D6C6C6C6C6C2D2D2D2D2D2D2D2D2D6C707675707570
        7570757570757077986F6D2B2A692A69692A69692A2A2A2A2A6A696A2A69692A
        00002D2D2D6C6C6C6C6C6C6D7075757675767676767698987698A8989A9AA89A
        9AA6AAA6A6A6A6A6A6A6AAA6A6A6A6A6A6A6A6A6A9A9A9A99AA6A9A9A99A9A9A
        9A9A9A9A9A9A9A989A98A898987798767675766F6D2D2D6C6C2D2D2D2D2D2D2D
        2C6E767676767675767675767576767676767676767676767676767676767675
        767576767676756F756D2D6C6C6C2D2D2D2D2D2D2D2D6C6C6C2C707675707570
        7575707570757098766D2D2B2B2A676969692A2A2A2A2A69692A2A2A2B2A2A2A
        00002D2D2D2D6C6C6D2D6C6C6D7576767576767676767798989898989A9A9AA8
        9AA6AAA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A9A9A9A99AA6A9A9A99A9A9A
        9A9A9A9A9A9A9A989898989898777676767676752D6C6C6C2D2D2D2D2D2D2D2D
        2C6D757676767676767675767675767675767676767676767676767676767675
        7676757576757570706D2D6C6C6C2D2D2D2D2D2D2D2D6C6C6C2C707575757570
        7570757075757576762D2C2D2A2A696969692A2A2A2A2A69692A2A2A2B2A2A2A
        00002D2D2D2D2D6C6C6C6C6C6E7575767676767676767676987698989A9AA89A
        9AA9AAA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A99AA9A9A9A69AA9A99AA99A9A
        9A9A9A9A9A9A9A989A9898987798767676757675706D6C6C6C2D2D2D2D2D2D6C
        2D2D6C7576767676757676757676767676757675767676767675767676757676
        767676756F7575706C6C6C6C6C6C6C6C2D2D2D2D6C6C2D2D2D2D6D7576757570
        7575707570757677756A2D2D69696927272A69692A2A2A2A2A2A2A2A2A2A2A2A
        00002D2D2D6C2D2D6C6C6C6C6E757575767676767676767698987798989A9AA8
        9AA6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A9A9A9A9A69AA9A9A99A9A9A9A9A
        9A9A9A9A9A9A98A8989898779876757676767575756D6C6C6C6C2D2D2D2D2D2D
        2D2D2C6D75757676767676767576767576767576757676767576767576767675
        76767575757075706C6C6C6C6C2D2D2D2D6C6C2D6C6C2D2D2D2B6C6E75767570
        70706F7570707676756A2D2D69696868686969692A2A2A2A2A2A2A2A2A2A2A2A
        00002D2D2D6C2D2D6C6C6C6C6E75707576767676767676769898989898989A9A
        9AA6A6A9A6A6A6A6A6A6A6A6A6A6A6A6A6A6A9A9A9A9A9A9A99A9A9A9A9A9A9A
        9A9A9A9A9A9A9898A8989876767676767675756F706D2D2D6C6C2D2D2D2D2D2D
        2D2D6C2C6D757676767576767676767675767676757676767675767676757676
        75767676757570702D6C6D6C6C2D2D2D2D6C6C2D2D2D2D2D2D2B2C2D75757575
        706C6D706C6E7676752B2D2D6A68696969692A2A2A2A2A2A2A2A2A2A2A2A2A2A
        00006C2D2D2D2D2D2D6C6C6C70757575767675767676769876989898989A9A9A
        9AA6A6A9A6A6A6A6A6A6A6A6A6A6A6A9A9A9A9A99AA99AA9A9A99A9A9A9A9A9A
        9AA89A9A9A9A989898777676767675767676756F6D6C6C6C2D2D6C6C2D2D2D6C
        2D2D2D2D6D757676767675767576767676757676767675767676767576767576
        7676767575756D6D6C6C6C6C6C2D6C6C2D6C6C2D2D2D2D2D2D2B2D6C75767570
        706D6C6D6C7076706C6C6C2D2B2A272A2A2A2A2A2A2A2A2A2A692A2A2A2A2A2A
        00006C2D2D2D2D2D2D6C6C6C6D706E7075767676767676769898769898A89A9A
        9AA9A6A9A6A6A9A6A6A6A6A6A6A9A9A9A99AA9A9A99AA69AA9A99AA99A9A9AA8
        9A9A9A9A9AA89898779876767676767575756F6E2D2D6C6C2D2D6C6C2D2D2D6C
        2D2D2D2D6C707576767676767676757676767675767676767576767676757675
        7575756F6D706C6C6C6C6C6C6C2D6C6C2D6C6C2D2D2D2D2D2D2B2D6A70707570
        706C2D6C2D7076702C2D6C2D2D2A272A2A2A2A2A2A2A2A2A2A692A2A2A2A2A2A
        00006C2D2D2D6C6C6C2D2D6C6C6C2D6D7575767576767677987698989898989A
        9AA9A6A9A9A9A9A6A6A9A6A6A9A9A9A9A9A9A99AA6A99AA99A9AA99A9A9A9A9A
        9A9A9A9A98989898987776767576757575706D2D2D2D2D2D2D2D2D2D2D6C6C6C
        2D2B2D2D2B2C7076767676757675767675767676767576757676767576767675
        75756F6C6C6C6C6C6C6C6C2D2D2D2D2D2D6C6C2D6C6C2D2D2B6C6A2D296E7070
        2D6C6C6C2D7076702C2D6C6C2D2A2A27272A2A2A2A2A2A2A2A2A2A2A2A68682A
        00002D2D2D2D6C6C6C6C6C6C6C6C2D6D75757676767676767698989898989898
        9A9AA6A6A9A9A9A69AA9A9A9A6A6A6A6A9A9A9A99AA99A9A9A9A9A9A9A9A9A9A
        9A9A9A9A98989877987676767575756F75706D2D2D2D2D2D2D2D2D2D2D2D2D2B
        6C6C2B2D2D2B6C70757675757576767676767576767676767675767676757676
        6F75706D2D2D6C6D6C6C6C2D6C6C2D2D6C2D2D2D2D2D6A6C2D2B2D2D2D6D756D
        2D6C6C6C2D707670292D2D2D2B2A272A2A2A2A2A2A2A2A2A2A692A2A692A672A
        00002D2D2D2D6C6C6C6C6C6C6C6C6C6D7075757676767676767798769898A898
        989AA6A6A9A9A9A9A9A69AA9A6A6A6A6A6A99AA9A69AA9A99A9A9A9A9A9A9A9A
        9A9A9A9898987798767676757070757570706D2D2D2D2D2D2D2D2D2D2D2D2D2B
        6C6C2B2D2D2B296C757570707576757675767676767576767676757676767675
        7570706C6C6C6C6C6C6C6C2D6C6C2D2D6C2D2D2D2D2D6A6C2D2B2D2D2D6D706E
        2D6D6C6C6C75766F2C2D2D2D2B2A272A2A2A2A2A2A2A2A2A2A692A2A692A2A2A
        00006C6C6C2D2D2D2D2D2D6C6C6C6C6C6C7075767675767676767698989A9898
        9AA8A9A6A6A9A9A9A9A99AA9A69AA9A9A9A9A9A99AA69A9A9A9A9A9A9A9A9A9A
        9A9A9A98779876767676767575756F756D6C2D2D2D2D2D6C2D2D2D6C6C2D2D2B
        2D2D2B2D2B2D2B6C70757570757675757576757676767576767676757676756F
        756D6C6C6C6C2D2D2D2D2D6C2D2D6C6C6C2D2D2D6C6C2D2D2D2D2D2B6C6C6C6C
        6C6C6C6C7075766B292D6C6A2D2A2A2A2A2727272A2A2A2A2A2A2A2A2A2A2A69
        00006C2D2D2D2D2D2D2D2D2D6C6C6C6C6C707576767676767676769898989898
        A89AA9A6A6A9A9A9A9A9A9A9A9A9A9A9A9A6A9A9A9A9A99A9A9A9A9A9A9A9A9A
        9A9AA8989898987676757676757575756D2C6C6C6C2D2D2D6C6C6C2D2D2B2D2D
        6A6C2B2D2B2D2B6C6C707575757570757676767676767575767676757575756F
        6E6C6C6C6C6C2D2D2D6C6C2D6C6C2D2D2D2D2D6C6C6C2D6C6A2D2D6A6C2B2D6E
        706C2D6C7575706B292D2B2D2D2A696869272A2A6869682A2A6869692A2A272A
        00006C2D2D2D2D2D2D2D2D2D6C6C6C6C6C6E7575767576767676769877989898
        9AA8A6A6A9A9A9A9A9A9A9A9A9A9A9A9A9A6A9A99AA9A99A9A9A9A9A9A9A9A9A
        9AA89A987798767676767676766F70706D2D6C6C6C2D2D2D6C6C6C2D2D2B2D2D
        6A6C2B2D2B2D2B2D2D6D7070707570707576757575757570767575756F70756E
        6C6C6C6C6C6C2D2D2D6C6C2D6C6C2D2D2D2D2D6C6C6C2D6C6A2D2D6A6C2B2D70
        706D2C6C76752C2D6A2D2B2D2D2B6968682A2A2A6768692A2A6869692A2A272A
        00002D2D2B2D2D2D6C2D2D2D2D2D6C6C6D6C6D75757676767676767677989898
        989AA9A6A6A99AA9A9A9A9A69AA9A9A9A99AA9A99A9A9A9A9A9A9A9A9A9A9A9A
        9A9898987776767676767675756F6C6C6C2D6C6C2D2D2D2D2D2D2B2D2D2B2D2B
        6C6A2D6A6C6A6C6A6C6A6C6C6E756D6D70757575757570757075757075756D6C
        6C6C6C6C6C2D2D2D2D2D2D2D6C6C2D2D2D2D2D2D6C6C2D2D2B2D2D2B2D2B2D6B
        6C6C2D6C76752D292D6A6C2B2D2D6967676927272A2A2A2A67272A2A2A2A2A2A
        00002D2D2B2D2D2D6C2D2D2D2D2D6C6D6C2D6C70767676767676767677989898
        98A8A9A6A69A9AA9A9A9A9A69AA9A9A9A99AA9A99A9A9A9A9A9A9A9A9A9A9AA8
        9898987698767676767675756D6C2D2D2D2D6C6C2D2D2D2D2D2D2B6C6C2D2D2B
        6C6A2D6A6C6A6C6A6C2B2D6E706D6D2D6E707570707570757075707570756D6D
        6C6C6C6D2D2D2D2D2D2D2D2D6C6C2D2D2D2D2D2D6C6C2D2D2B2D2D2B2D2B2B2D
        2D6D2D6C76752D292D6A6C2B2D2D6968676927272A2A2A2A672A2A2A2A69692A
        00002D2B2D6C2B2D2D2D2D2D2D2D6C6C6C6C6D70767675767676767677987698
        98989AA6A99A9AA9A9A9A9A9A9A99AA9A9A9A99A9A9A9A9A9A9A9A9A9A9AA89A
        9898767698767676767675702D2D2D2D2D2D6C6C2D2D2D2D2D2B2D6C6C2D2B2D
        2B2D2B2D2B2D2B2D6A2D2D70706D2D6C6C6D7575707575707570757075757570
        6C6C6C6C6C2D2D2D2D2D2D2D6C6C2D2D2D2D2D2D6C6C2B6C6C2B2D2B2D2B2B2D
        2D6C6C6D76752D292D2B2D2B2D2D2B27272A2A2A2A2A2A2A2A2A2A2A2A69692A
        00006C2B2D6A2D2D6C2D2D6C6C2D6C6C6C2D6D75757575767676767677989876
        98989AA99A9A9AA9A9A9A9A9A9A9A99AA9A99A9A9A9A9A9A9A9A9A9A9A989A98
        98987676777676767676756F6C2D2D2D2D2D2D2D2D2D2D2B2D2D2B2D2B2D2B6C
        2B2D2B2D2B2D6A6C2B2D2B6C6E706E6C2D707575707570757570757075707570
        6C6C6C6C6C6C2D2D2D2D2D2D2D2D2D6C6C2D2D2D2D2B2D2D2B2D2D2B2D2B2D2B
        2D6C6E70756F2D2B2D2D2B2D2D2D2B2A2A6968682A2A2A6969692A2A2A2A2A69
        00006C2B2D6A2D2D6C2D2D6C6C2D6C6C6C2D6D70707575767676767677989876
        989898A9A99A9AA9A9A9A9A9A9A6A9A99A9AA99A9A9A9A9A9A9A9A9A9A9A9898
        98987776767676767675706D6C2D2D2D2D2D2D2D2D2D2D2B2D2D2B2D2B2D2B6C
        2B2D2B2D2B2D6A6C2B2D2B296D75702D6C6D7075757075757570757575707570
        6D2D6C6C6C6C2D2D2D2D2D2D2D2D2D6C6C2D2D2D2D2B2D2D2B2D2D2B2D2B2D2B
        2D2D7075706D2B2D2B2D2D2B2D2D2B2A2A6968682A2A2A6969692A2A2A2A2A69
        00006C2B2D2B2D2D2B2D2D6C6C6C6C6C2D6C6C6C6E7576767676767676989898
        7798989AA6A99AA99AA9A9A9A69AA9A99AA99A9A9A9A9A9A9A9A9A9A9AA89898
        989876987676767675706D6C6C6C2D2D2D2D2D2D2D2D2D2B2D2D2B2D2B2D2B2D
        6A6C6A2D2B6C6A2D6A6C2B296D70706C6C6C6C70757570757075707570757570
        6C6C6C6C6C2D6C6C2D6C6C2D2D6C6C6C2D2D2D2D2D2B2D6C6C2B2D6A2D2B6A2B
        2D2970766D2C2D2B2D2D6A6C2D2B2D2A2A2A27272A27272A672769696927272A
        00002B2D2B2D2B2D6A2D2D2D2D2D6C6C2D6C6C2D6E7576767676767676769898
        7698989AA6A69A9AA99AA9A9A99AA99A9A9A9A9A9A9A9A9A9A9A9A9A98A89898
        9876987676767676756D2D6C6C6C2D2D2D2D2D2D2D2D2B2D2D2B2D2B2D2B2D6A
        2D2B6C2B2D2B6A6C2B2D2B6C6A6D70706D2D6C6D6D6D6E6D6D6D6D6E6D6D6D6D
        6C6C2D6C6C6C6C6C2D2D2D2D2D2D2D2D2D2D2D2D6C6A2D6C6A2D2B2D2B2D2B2B
        2B2D70766D2C6A2D2D2B2D2B2D2D2D2A2A692A2A2A2A2A2A2A272A2A6869692A
        00002B2D2B2D2B2D6A2D2D2D2D2D6C6C2D6C6C6C707575767676767676767798
        7698989AA6A69A9A9AA99AA9A99A9A9A9A9A9A9A9A9A9A9A9A9A9AA8989A9898
        76767776767676766F2D6C6C6C6C2D2D2D2D2D2D2D2D2B2D2D2D2B2D2B2D2B6C
        2B2D6A2D2B2B6A6C2B2D2B6C2B2D6E706D2D6C6C6C2D6D6C2D6C2D6C6C6C2D6C
        6C6C2D6C6C6C6C6C2D2D2D2D2D2D2D2D2D2D2D2D6C6A2D6C6A2D2B2D2B2D2B2B
        2B2975766D2C6A2D2D2B2D2B2D2D2D2A2A692A2A2A2A2A2A2A272A2A6869692A
        00002B2B2B2B2D2B2D2D2D2D2D2D2D2D6C6C6C6C707570757676767676767677
        9876989AA9A99A9A9A9AA9A9A99A9A9A9A9A9A9A9A9A9AA89A9A9A9A98989898
        76767676767676756E6C6C6C2D2D2D2D2D2D2D2D2D2D2D2B2D2B6C6A6C2B2D2B
        6A6A2B2B2B2B2B2B2D2B2D2B2D6A6C6D2D6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C
        6C6C6C2D2D2D2D2D2D2D2D2D6C6C2D2D2D2D2D2D6C6A2D2B2D2B2D2B6C6A2B2B
        2B2B70766D296C2B2D2B2D2B2D2B2D2B2A2769692A2A2A67692A2A2A2A672A67
        00002B2B2B2B6C6A2D2D2B6C6C6C2D2D6C2D6C6C6D7070757576767676767677
        989898989AA99A9A9A9AA99A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A98989898
        987776767675756F6C6C6C6C2D2D2D2D2D2D2D2D2D2D2D2D2B2D6A2D2D2B2D2B
        6A6A2B2B2B2B2D2B2B2B2B2D2B6C6A2D6C6D6C6C6C6C6C6C6C6C6C6C6C6C6D6C
        6D2D6C2D2D2D2D2D2D6C6C2D6C6C2D6C6C2D2D2B2D2D2B2D2B2D2B2D6A6C2B6A
        6A2B6D706B2D2B6C6A2D2B2D6A6C6A2B2A69672A2A2A2A69672A2A2A2A69672A
        00002B2B2B2B6C6A2D2D2B6C6C6C2D2D6C2D6C6C6C6C70757076767676767676
        779876989AA99A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9AA898989898
        989876767675706D2D6C6C6C2D2D2D2D2D2D2D2D2D2D2B2D2B2D2B2D2B2D2B2D
        2B2B2B2B2B2B2D2B2B2B2B2D2B6C6A2D6C6C6C6C6C6D6C6C6C6D6C6C6C6D6C6C
        6C6C2D2D2D2D2D2D2D6C6C2D2D2D2D6C6C2D2D2B2D2D2B2D2B2D2B2D6A6C2B6A
        6A6C2D2D6C6A2D6A6C2B2D2B6C6A6C2A2A69672A2A2A2A69692A2A2A2A69692A
        00002B2B2B6A2B2B6C6A6C2D2D2D2D2D2D2D6C6C6C6D70757575767676767676
        769898989AA99A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9898A8989898
        989876767675706D2D6C6C6C2D2D2D2D6C6C2D2D2D2B2D2D2B2D2B6C6A2D2B2B
        2B2B2B2B2B2B6A6A2B2B2D2B2D2B2D2B6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6D
        6C6C2D2D2D2D2D2D6C6C6C6C2D2D6C6C2D6C6C2B2D2D2D2B2D6A6C2B6A6A2D2B
        2B6C6C2D6C6A2D2B2D6A6C2B2D2B2D2B2A276869692A2A69692A2A2A2A2A2A2A
        00002B2B2B6A2B2B6C6A6C2D2D2D6C6C2D2D6C6C2D6D70757575757676767676
        769877989AA99A9AA9A99A9A9A9A9A9A9A9A9A9A9A9A9A9AA89A989898989898
        779876767675706D2D6C6C6C2D2D2D2D6C6C2D2D2D2B2D2D2B2D6A6C6A2D2B2B
        6A6A2B2B2B6A6A6A2B2B2D6A6C2B2B2B6C6C6C6C6C6D2D6C6C6D6C6C6C6C6C6C
        6C6C2D2D6C6C2D2D6C6C6C6C2D2D6C6C2D6C6C2B2D2D2D2B2D6A6C2B6A6A2D2B
        2B6C6C2D6A6A2D2B2D6A6C6A2D2B2D2B2A27686968272A69692A2A2A2A2A2A2A
        00002B6A6A2B6A6A6C2B2D2D2B2D6C6C2D2D2D2D6C6D70757070757676767676
        767798769AA99A9AA9A9A99A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A98A8989876
        989876757675706D2D6C2D2D2D2D2D6C6C2D2D2D2D6A6C2B2D2B6C6A2D2B2D2B
        6A6A2B2B2B6A6A2B2B2B2B6C6A6C2B2B6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C
        6C6C2D2D6C6C2D2D6C2D2D6C6C6C6C6C6C2D2B2D2D2B2D2B2D2B2D2B2D2B2D2B
        2B6C6C6A6A6A2D6A6C2B2D6A6C6A2D2B2B672A2A2768692A2A2A2A2A272A2A2A
        00002B6A6A2B2B2B6A6C6A6C6C6C2D2D6C6C6C6C6C6D6D6C6D70757676767676
        7676769898A99A9A9AA99A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9AA89898989898
        7798767575756F6D2D6C6C6C2D2D2D6C6C6C2D2D2D6C6C2B2B2B2D2B2B2B2B2B
        2B2B2B2B2B2B2B2B2B2B2B2D2B2D6A6C2B2D6C6C6C6D2D6C6C6C6C6C6C6D6C6C
        6C2D2D2D2D2D6C6C6C2D2D2D6C6C2D2D6A6C6C2B6C6A6C2B2D2B2D2B2B2B2B6A
        6C2D2B6A2A2B2D2D2B2D2B2D2B2D2D2B2B2A2A672A69692A2A69672A672A2A68
        00002B6A6A2B2B2B6A6A6C6A6C6C2D2D6C6C6C6C6C6C6C2D6D70757676767676
        76767676A89A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9898987798
        9876767675756F6D2D6C6C6C2D2D2D6C6C6C2D2D2D6C6C2B2B2B2D2B2B2B2B2B
        2B2B2B2B2B2B2B2B2B2B2B2D2B2D6A6C2B2D2D6C6C6C6C6C6C6C6C6C6C6C6C6C
        2D2D2D2D2D2D6C6C6C2D2D2D6C6C2D2D6A6C6C2B6C6A6C2B2D2B2D2B2B2B2B6A
        6C2D2B692B2B2D2D2B2D2B2D2B2D2D2B2B2A2A672A69692A672A672A672A2A68
        00002B6A6A2B6A6A2B2B2B2D2B2D2D2D2D2D2D2D2D2D6C6C6C70757676767676
        7676767698A99A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A98A898989877
        989876767575706D2D2D2D2D2D2D2D2D2D2D6C6C2B2D2D2B2D2B6A6A2B2B2B2B
        2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2D2B6C6C6C6C6C6C6C6C6D6C6C6C6C
        2D2D2D2D2D2D2D2D2D6C6C2D2D2D2D2D2D2D2B2D2B2D2B6C6A6C6A2D2B2B2B2D
        2B2D2A2A696A2B6C6A2D2D2B2D2B2D2D2B2A272768696967672A2A2A6927272A
        00002B2B2B6A2B2B2B6A6A2D2B2D6C6C2D2D2D2D2D2D6C6C6C70757575767676
        7676767698A9A99A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A98989898987776
        76767676756F6D6C6C2D2D2D2D2D2D6C6C2D2D2B2D2B2D2B2D2B6A6A6A2B2B6A
        2B2B6A6A6A2B2B2B2B2B2B2B2B2B6A6A2B2B2D2D6C6C6C6C6C6C6C6C6C6C2D2D
        6C6C6C2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2B2D2B2D2B2D2B2D2B6C2B2B2B2D
        2D2B2B2A2A2B2B2B2D2B2D2B6C6A2D2B2D2A272767696926672A2A2A2A672A2A
        00002B2B2B6A2B2B2B6A6A2D2B2D6C6C2D2D2D2D2D2D6C6C6C70707575767676
        7676767698A9A99A9A9A9A9A9A9A9A9A9A9A9A9A9AA89A9A9A98989877987698
        76767675756B2C6C6C2D2D2D2D2D2D6C6C2D2D2B2D2B2D2B2D2B6A6A6A2B2B6A
        2B2B6A6A6A2B2B2B2B2B2B2B2B2B6A6A2B2B2B2D6C6C6C6C6C6C6C6C6C6C2D2D
        6C6C6C2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2B2D2B2D2B2D2B2D2B6C2B2B2B2D
        2D2B2B2A2A2A2B2B2D2B2D2B6C6A2D2B2D2A2727676969672A672A2A2A2A672A
        00002B6A6A2B6A6A6A2B2B6A6C6A2D2D2D2D2D2D2D2D6C6C6C6C6E7575767576
        76767676989A9A9A9A9A9A9A9A9AA89A9A9A9AA89A9A9A9A9A98989898779876
        98757675756D6C6C6C2D2D2D2D6C6C6C2D2D2D2B2D2B2D2B2B2D2B2B2B2B2B6A
        2B2B2B2B2B2B2B2B2B2B6A6A6A2B6A6A2B2B2B2D6C6C6C6C6C6C2D6C6C2D2D2D
        2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D6C6C2D2B2D2B2D2B2D2B2D2B2D2B2B2B2D
        2D2B2A2B696A2A2B2B2D6A6C2B2D2B2D2D2B6967682A2A2A2A2A2A2A2727272A
        00002B6A6A6A6A6A6A2B2B6A6A6C2B2D2D2D2D6C6C2D6C6C6C2D6D7575757676
        7676767698989A9A9A9A9A9A9AA89A9A9A9AA89A9A9A9A9A9A98A89898987798
        7676767575706D6C2D2D2D2D6C2D2D2D2D2D6C6A6C2B2D6A2B2D2B6A6A2B2B6A
        2B2B2B2B2B2B6A6A2B2B6A6A6A2B2B2B2B2D2B2B2D6C6C6C6C6C6C6C2D2D6C6C
        2D2D2D2D2D2D6C6C2D2D2D2D2D2D2D6C6C2D2B2D6A6C2B2D2B6C6A2D6A6A2D2D
        2B6A696A2A2B2A6A6A2D2B6C2B2D2B2D2D2B6A672A2A2A272A2A27272727272A
        00002B2B2B6A2B2B2B2B2B2B6A6C2B2D2D2D2D6C6C2D2D6C6C2D6D7070757676
        7576767676989A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A98989898779876
        767676757570706C2D2D2D2D6C2D2D2D2D2D6C6C6A2D2B6C2B2D2B6A6A2B2B6A
        2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2D2B2B2D6C6C6C2D6C6C2D2D2D6C6C
        2D2D2D2D2D2D6C6C2D2D2D2D2D2D2D6C6C2D2B2D6A6C2B2D2B6C6A2D6A6A2D2D
        2B6A696A2A2B2A6A6A2D2B2D2B2D2B2D2D2B2B672A672A26272A2A272727272A
        00002B2B2B2B2B2B2B6A6A2B2B2D2B2D6C2D2D2D2D2D2D6C6C6C6D6D70757676
        767676769898A99A9A9A9A9A9A9A9A9A9A9A9A9A9AA89A9A9A98989898779876
        767676757575706D2C2D2D2D2D6C6C2D2D2D6C6C6A2D2B6C2B2B2B2B2B2B2B2B
        2B2B2B6A6A6A6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B2D2B6C6C6C2D6C6C6C2D2D
        2D2D2D6C6C2D6C6C2D6C6C2D2D2D2D6C6A2D2D2B2D2B2D2B2D2B2B2B6A6C2D2D
        2A69692B696A2A2B2B6A6C2B2D2B2D2B2D2D2B266767272727692A2A68686827
        00002B2B2B2B2B2B2B6A6A2B2B2D2B2D6C2D2D2D2D2D2D6C6C6D2D2D70757676
        757676767698A9A99A9A9A9A9A9A9A9A9A9A9A9A9A9AA89A9A98989898779876
        7676767575706D6C2D2D2D2D2D6C6C2D2D2D6C6A6C2B2D6A2B2B2B2B2B2B2B2B
        2B2B2B6A6A6A6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2D6C6C6C2D6C6C6C2D2D
        2D2D2D6C6C2D6C6C2D6C6C2D2D2D2D6C6A2D2D2B2D2B2D2B2D2B2B2B6A6C2D2D
        2A69692B696A2A2A2B6A6C2B2D2B2D2B2D2D2B672767272727692A2A69686827
        00006A2B2B6A2B2B2B6A6A6A6A2D2B2D6A2D2D2D2D2D2D6C6C6C6C6C70757675
        7676767676989AA99A9A9A9A9A9A9A9A9AA89A9A9A9A9A9A9A98987798987676
        76767675756B6C2D2D2D2D2D2D2D2D2D2D2D2B2D2B2D2B6C2B2D2B2B2B2B2B2B
        2B2B6A2B2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B6A2D6C6C6C2D6C6C2D6C6C
        2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2B2D2D2B2D2B6C2B2D6A6A2B2B2D6C2D
        2A2A2A2B2A2B6969692B2B2D2B6A6C2B2D2D2A2A2727272727272A2A6927272A
        00006A2B2B2B2B2B2B2B2B6A6A2B6C6A2D6C6C2D2D2D2D2D6C6C6C6C70757575
        7676767676779A9A9A9A9A9A9A9A9AA89A9A9A9A9A9A9A98A898989876989876
        767676756D6C6C6C6C2D2D2D2D2D2D6C6C6A2D2D2B6A6A2D6A6C2B2B2B6A6A2B
        2B2B2B2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B6A2D2D6C6C6C2D2D2D6C6C
        2D6C6C2D2D2D2D2D2D2D2D2D2D2D2B6C6C2B2D2D2B2D2B2D2B2B2B2B6A6C2D2D
        2A2A2B2A6A692B2A2A2B2B2D2B2B6C6A6C6C2B2A27272727272A672A672A2A2A
        00006A2B2B2B2B2B2B2B2B6A6A2B6C6A2D6C6C2D2D2D2D2D2D6C6C6C70757075
        7676767676779A9A9A9A9A9A9A9A9A9A9A9A9AA89A9A9A9898A8989876989876
        767676752D2D6C6C6C2D2D2D2D2D2D6C6C6A2D2D2B6A6A2D6A6C2B2B2B6A6A2B
        2B2B2B2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B6A2B2D2D6C6C2D2D2D6C6C
        2D6C6C2D2D2D2D2D2D2D2D2D2D2D2B6C6C2B2D2D2B2D2B2D2B2B2B2B6C6A2D2B
        2A2B2A2B696A2A2A2A2B2B2B2D2B6A6C6C6A2D2A27272727272A672A672A672A
        00002B2B2B6A6A6A2B2B2B2B2B2B6C6A2D2D2D2D2D2D6C6C2D6C6C6C70757075
        7676767676769A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9898989877987676
        767576756B2D6C2D2D2D2D2D2D2D2D6C2D2B6C6C2B2B2B6C2B2B2B2B2B2B2B6A
        6A6A2B2B2B2B6A6A2B2B2B6A6A2B2B2B2B2B2B2B2B2B6A6A2D6C6C2D2D6C2D2D
        6C6C6C2D2D2D2D2D6C2D2D2D6C6A2D2D6A2D2D6A6C6A6C6A6C2B2B2B2D2D6A2B
        2A2B696A2A2B692B2A696A2B2D2B2B2D2B2D6A6A686767272727272767272769
        00006A2B2B6A2B2B2B2B2B2B2B2B2D2B2D2B2D6C6C2D2D2D2D6C6C6C6D6E7570
        7576767676779AA99A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9898A8989898987676
        767676756C6C6C2D2D2D2D2D2D2D2D2D6C6A2D2B2D2B2D2B2B2B2B2B2B2B2B2B
        2B2B6A2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2D2B6C2D2D6C2D2D
        2D2D2D2D2D6C6C6C2D2D2D6C6C2B2D6C6A2D2B2D6A6C6A2D2B2B2B2B2D2D2B2A
        2A2A69692B2A2B2A2A2A2A2B2D2B2B2B2B2D2B2B686767686827272767696769
        00006A2B2B6A2B2B2B2B2B2B2B2B2D2B2D2B2D6C6C2D2D2D2D6C6C6C2D6D7075
        757576767676A89A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9AA89898989877989876
        767676756C2D6C2D2D2D2D2D2D2D2D2D6C6A2D2B2D2B2D2B2B2B2B2B2B2B2B2B
        2B2B6A2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2B2D2D6C2D6C2D2D
        2D2D2D2D2D6C6C6C2D2D2D6C6C2B2D6C6A2D2B2D6A6C6A2D2B2B2B2B2D2D2B2A
        2A2A69692B2A2B2A2A2A2A2B2B2D2B2B2B2D2B2B696768686827272767696967
        00002B2A2B2B2B2B2B6A6A6A6A2B2D2B2D2B2D2D2D2D2D2D6C6C6C6C6C6D7075
        707676767676989A9A9A9AA89A9A9A9A9A9A9A9A9A9A9A989A98989877987676
        767576756C2D2D2D2D2D2D2D2D2D2D2D2D2B2D2D6A6A6A2B2B2B2B2B2B2B2B6A
        2B2B2B2B2B6A6A2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2D2B6C6C2D2D2D
        2D2D2D2D2D2D2D2D2D2D2D2D2D2B2D2D2D2D2B6C2B2D2B6A6A2B2B6C2D2D2A2A
        2B2A2B2A2A2A2A69692A2A2A2B2D6A6C6A2D2B2D2A27276767272A6727272727
        00002B696A2A6A6A2B6A6A6A6A2B2D2B2D2B2D2D2D2D2D2D6C6C6C6C6C6D7075
        75757676767676A8A99A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9898989877769876
        7676756F6C2D2D2D2D2D2D2D2D2D2D6C2D2D6A6C6A6A6A2B2B2B6A2B2B2B2B6A
        2B2B2B6A6A6A6A2B2B2B2B2B2B2B6A6A2B2B2B6A6A2B2B2B2B2B2D6C6C2D2D2D
        2D2D2D6C6C2D2D2D2D2D2D2D2D6A6C2D2D2D2B6C2B2D2B6A6A2B2B6C2D2B2A2A
        2B2A2B2A69692A69692A2A2A2B2B6C6A6C2B2D2D2A2A276767672A6727272727
        00006A696A2A6A6A2B2B2B6A6A2B2B2B2D2B2D2D2D2D2D2D2D6C6C6C6C6D7075
        75757676767676989A9A9A9A9A9A9A9A9A9A9A9A9A9A9A989898989877987676
        7676756F6D2D2D6C6C2D2D2D2D2D2D6C2D2D6A6C2B6A6A2B6A6A6A2B2B2B2B6A
        2B2B2B6A6A2B2B2B2B2B2B2B2B2B6A6A2B2B2B6A6A6A2B2B2B2B2D6C2D2D2D2D
        2D2D2D6C6C2D2D2D2D2D2D2D6C6A6C6C2B2D2B6C2B2D2B2B2B2B2D2D2B2B2A2A
        2B2A2B2A69692A2A2A2A2A2A2B2B2D6A6A2B2D2D6A69262A67272A6727272727
        00002B2A2B2B2B2B2B2B2B2B2B2B6A6A2D2B2D2D2D2D6C6C2D6C6C6C6C6D7075
        75757676767676989A9A9A9A9A9A9A9A9A9A9A9A9AA898989898987798767676
        7675756F6C2D2D6C6C6C2D2D2D2D2D2D2D2B2D2D6A6A6A6A6A6A2B2B2B6A6A2B
        6A6A2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B6A2B2B2B2B2B2D2D2D2D2D
        2D2D2D2D2D2D2D2D2D2D2D6C6C2B2D2D2B6C6A6C2B2D2B6A6A6A6C2D2D2A2A2A
        2B2A6A692B2A2A69696969692A2B2B2B2B2B2D2B6C69262727272A6727276767
        00002B2A2B2B2B2B2B2B2B2B2B2B6A6A2D2B2D2D2D2D6C6C2D6C6C6C6C6D7075
        7575767676767598A99A9A9A9A9A9A9A9A9A9A9AA89A989A9898989877767676
        7676756F6C2D6C6C6C6C2D2D2D2D2D2D2D2B2D2D6A6A6A6A6A6A2B2B2B6A6A2B
        6A6A2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B6A2B2B2B2B2B2B2D2D2D2D
        2D2D2D2D2D2D2D2D2D2D2D6C6C2B2D2D2B6C6A6C2B2D2B6A6A6A6C2D2D2A2A2A
        2B2A6A692B2A2A69696969692A2A2B2B2B2B2D2B6C69272727272A6727276767
        0000692B2B2B2B2B2B2B2B6A6A2B2B2B6C6A6C2D2D2D2D2D6C6C6C6C2D6D7075
        75757676767575989A9A9A9A9A9A9A9A9A9A9A9AA89898989898989877767676
        7676756F6D2D6C6C6C2D2D2D2D2D2D2D2D2B2D2B2D6A6A6A6A6A2B2B2B2B2B2B
        2B2B2B6A6A6A6A6A2B2B2B2B2B2B2B2B6A6A6A2B2B6A2B2B2B2B2B2B2D2D2D2D
        2D6C6C6C6C2D2D2D2D2D2D2D2D2D2D2B2D6A6C2B6C6A2B2B2B2B2D2D2B2A2A69
        692B2A6A2A2B2A6969692A2A2A696A2B2B2B2B2B2D2A2A26276926272A262727
        00002B2A2B2A2B2B2B2B2B2B2B2B2B2B2B2D2B2D2D2D6C6C6C2D6C6C6C6D7075
        75757676767675989A9A9A9A9A9A9A9A9A9A9A9AA898989A9898987798767676
        7676756F706D6C2D2D2D2D2D6C2D2D2D6C6A6C6A2D2B2B2B2B2B2B2B2B2B2B2B
        2B2B2B2B2B2B2B2B2B2B6A2B2B2B2B2B2B2B6A6A6A6A2B2B2B2B2B6A6A2D6C6C
        2D2D2D2D6C6C2D2D2D2D2D2D2D2D2B2D6A6C6C6A2B2B2B6A6A2D2D2D2A2A2B2A
        2A2B2A2B2A2A2A2A2A2A69692A2A2B2B2B2D2B2B2D2A2A2627272A672A262727
        00002B2A2B2A2B2B2B2B2B2B2B2B2B2B2B2D2B2D2D2D6C6C6C2D6C6C6C6D7570
        75757576767576989A9A9A9A9A9A9A9A9A9A9A9A9898A8989898989877767676
        7676756F756D2D2D2D2D2D2D6C2D2D2D6C6A6C6A2D2B2B2B2B2B2B2B2B2B2B2B
        2B2B2B2B2B2B2B2B2B2B6A2B2B2B2B2B2B2B6A6A6A6A2B2B2B2B2B6A6A2D6C6C
        2D2D2D2D6C6C2D2D2D2D2D2D2D2D2B2D6A6C6C6A2B2B2B6A6A2D2D2B2B2A2B2A
        2A2B2A2B2A2A2A2A2A2A69692A2A2A2B2D2B2B2B2D2A2A2627272A672A262727
        00002A2B2A2B2B2B6A2B2B2B2B2B2B2B2B2D2B6C2D2D6C6C6C6C6C6C2D6D7570
        757075767676759898A99A9A9A9A9A9A9AA89A9A9898A89A9898987798767676
        7676756F6D6C6C2D2D2D2D2D6C2D2D2D6A6C2B2D2B2B2B6A2B2B2B2B2B2B2B2B
        6A6A6A2B2B2B2B6A6A6A2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B6C6C
        2D2D2D2D6C6C2D2D2D6C6C6C2D2D2B2D2B6C6A6C2B2B6A6A2D2D2D2B2A2A2A69
        692B2A2A2A2A2A69692A2A2A2A69692B2B2B2B2B2D696927272A672A67676767
        00002A2B2A6A2A2B2B6A6A2B2B2B6A6A2B2D2B6C6C2D2D2D2D6C6C6C6C6C6E70
        7570757676767676989AA99A9A9A9A9AA89A9A989A9A9A98989A987798767676
        7676756F6C6C6C2D2D6C2D2D2D2D2D2D2B2D2B2B6A6A6A6A2B2B6A6A6A6A6A2B
        6A6A6A6A6A2B2B6A6A6A6A2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2D
        2D2D2D6C6C2D6C6C2D6C6C2D2D2D2B6C6C2B2D6A2D2B6A2B2D6C6C2A2A2A2A2A
        2A2A2A2A2A2A2A6969692A692A69692A2B2D2B2B6C6A6927262A676727676767
        00002A2B2A6A2A2B2B6A6A2B2B2B6A6A2B2D2B6C6C2D2D2D2D2D6C6C6C6C6C70
        7570757676757676989AA99A9A9A9A9A9AA89A989A9A9A98A898989898767676
        767675706C6C6C2D2D6C2D2D2D2D2D2D2D2B2D2B6A6A6A2B2B2B6A6A6A6A6A2B
        2B2B2B6A6A2B2B2B6A6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2D
        2D2D2D6C6C2D6C6C2D6C6C2D2D2D2B6C6C2B2D6A2D2B2B2B2D6C6C2A2A2A2A2A
        2A2A2A2A2A2A2A69696969692A2A2A2A2B2D2B2B6C6A2B272667276727676727
        00002A6A692B2B2B6A6A6A6A6A2B2B2B2B2B2D2D6C6C2D2D2D2D6C6C6C6C6C70
        7570757676767576779AA99A9A9A9AA89A9A9A9A9A9A98989898779898767676
        7676756F6C6C6C2D2D2D2D2D2D2D2D2D6C6A2D2B2B2B2B2B2B2B2B2B2B2B2B2B
        2B2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B6A6A2B6A6A6A2B2B6A6A2B2B2B2B2B2B
        2D2D2D6C6C2D2D2D6C2D2D6A6C6C6A6C2B2D2D2B2B2B2B6C6C2D2B692A2A2A69
        692A2A2A2A2A692A2A69692A2A2A2A2A2B2B2B2B2B2D2A686727272767272727
        00002A6A692B2B2B6A2B2B6A6A6A2B2B2B2B2D2D2D6C2D2D2D2D6C6C6C6C6C70
        757075767676767576A9A99A9A9A9A9A9A9A9A9A9A9A98989877987698767676
        767575706C6C6D2D2D2D2D2D2D2D2D2D6C6A2D2B2B2B2B2B2B2B2B2B2B2B2B2B
        6A6A6A2B2B2B2B2B2B2B2B6A6A6A6A2B6A6A2B6A6A6A2B2B6A6A2B2B2B2B6A6A
        2D2D2D6C6C2D2D2D6C2D2D6A6C6C6C6C2B2D2D2B2B2B2B6C6C2D2B692A2A6969
        692A2A2A2A2A692A2A2A2A2A2A2A2A2A2A2B2B2B2B2B6A686727272767272727
        00002B2A2A2B696A2B2B2B6A6A6A2B2B2B2D2B2D2D2D2D2D2D2D2D2D6C6C6C70
        757075767576767576A9A99A9A9A9A9A9A9A9A9A9AA898989898779898767676
        757570706D2D6C6C6C6C2D2D2D2D2D2B6C6C6A6C2B2B2B2B2B2B2B2B2B2B2B2B
        6A6A6A2B2B2B2B6A6A6A2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B6A6A
        2B2D2D6C6C2D2D2D2D2D2D2B2D2D2D2D2B2D2B2B2B2B2B2D2D2B2B2A2A2A6969
        692A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2B2B2B6A6A6A2A2727676727272727
        00002B2A2A2B696A2B6A6A2B2B2B2B2B6A2D2B2D6C6A2D2D2D2D2D2D6C6C6C70
        7570757575767675769A9A9A9A9A9A9A9A9A9AA89A989A989898779876987576
        757575706C6C6C6C6C6C6C6C2D6C6C2B2D2B6C6C2B6A6A6A6A6A2B2B2B2B2B2B
        2B2B2B2B2B2B2B6A6A6A2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B
        2B6A6C2D2D2D2D2D2D2D2D6C6C2B2D2D2B2D2B6C2B2B2D2D2D2B2A2A2A2A2A2A
        2A69692A2A2A2A2A2A696A2A2B2A2A2A2A2A2B2B2B2D2B6968672727272A672A
        00002B2A2A2B696A2B6A6A2B2B2B2B2B6A2D2B2D6C6A2D2D2D2D2D2D6C6C6C70
        7570707575767675769A9A9A9A9A9A9A9A9A9AA8989898989898779898767676
        75756F706D2D6C6C6C6C6C6C2D6C6C2B2D2B6C6C2B6A6A6A6A6A2B2B2B2B2B2B
        2B2B2B2B2B2B2B6A6A6A2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B
        2B6A6C2D2D2D2D2D2D2D2D6C6C2B2D2D2B2D2B6C2B2B2D2D2D2A2A2A2A2A2A2A
        2A69692A2A2A2A2A2A696A2A2B2A2A2A2A2A2B2B2B2D2B6A69682727272A672A
        00006A2B2A6A696A2A2B2B2B2B2B6A6A2B6C6A2D2D2B2D2D6C6C6C2D6C6C6C70
        7570757075767675769A9A9A9A9A9A9A9A9A9A9AA898989A9876987798767676
        757575706C2D2D2D2D2D2D2D6C2D2D6A6C2B2D2B2B2B2B2B6A6A2B2B2B2B2B6A
        2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B6A6A6A2B2B2B2B2B2B2B2B2B2B2B6A6A
        2B2B2D2D2D2D2D2D2D2D2D2D2D2B2D2D2B6C6A2B2B2D2D6C6A2A2A2A69692A2A
        2A2A2A2A2A2A2A69692A2B2A6A69692A2A2A2A2B6A2D2B6A69672A672A262767
        00002B2B2B2A2B2A2B2B2B2B6A6A2B2B2B2D2B6C2D2B6C6C2D2D2D6C6C6C6C70
        757075707676767576989A9A9A9AA89A9A9A9A9A9898A8989898779898767676
        757570706C2D2D2D2D2D2D2D2D6C6C2B2D2B2D2B2B2B2B2B6A6A2B2B2B2B2B2B
        2B2B2B6A6A2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B6A6A6A
        6A2B2B2D2D2D6C6C2D6C6C2B2D2D6A6C2B2D2B6A6A6C2D2D2A6969692A2A2A2A
        2A69692A2A2A2A2A2A696A2A2A2A2A2A2A2A2A2B2B2D2B2D2A6767672727272A
        00002B2B2B2A2B2A2B2B2B2A6A6A2B2B2B2D2B6C2D2B6C6C2D2D2D6C6C6C6C70
        7570757075767675767698A99A9A9A9A9A9A9A9A9898A8989898779876767676
        757575706C2D2D2D2D2D2D2D2D6C6C2B2D2B2D2B2B2B2B2B6A6A2B2B2B2B2B2B
        2B2B2B6A6A2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B6A6A6A
        6A2B2B2B2D2D6C6C2D6C6C2B2D2D6A6C2B2D2B6A6A6C2D2B2A6969692A2A2A2A
        2A69692A2A2A2A2A2A696A2A2A2A2A2A2A2A2A2B2B2D2B2D2A6767672727272A
        00006A2B2B6A2A2B2A2B2B6A6A2B2B2B6A2D2B6C6C2B2D2D2D6C6C2D6C6C6C70
        7570757076767676767698A99A9A9A9A9A9A9A9A98989A989898779876767676
        757570706C2D2D2D2D2D2D2D2D6C6A2D6A6C2B2D2B2B2B2B2B2B2B2B2B2B2B2B
        6A6A2B6A6A2B2B2B2B2B6A2B2B2B6A6A2B2B2B2B2B6A2B2B2B2B2B2B2B2B2B2B
        2B2B2B2B6C6C2D2D2D6A6C2D2B2D6A6C2B6A6A2B2D2D6C6A2A2A2A6969692A2A
        2A2A69692A2A692A2A2A69696969692A2A2A69692B2B6C6A6A2A262727676727
        00006A2A2B2B2B2B2B2B2B2B6A6A2B2B2B2D2B2D6C6C2D2D6C6C6C2D6C6C6C70
        7575707575767676757677A99A9A9A9A9A9A9AA89A9898989877987676767675
        757575706C2D2D6C6C2D2D2D2D2D2B2D6A6C2B2D2B2B2B2B6A6A2B6A6A2B2B2B
        6A6A2B2B2B2B2B2B2B2B6A2B2B2B6A6A2B2B2B6A6A6A2B2B2B2B2B2B2B6A2B2B
        2B2B2B6A6C6C2D2D2B2D2D2B2D2B2D2B2D6A6A2B6C6C6C692A69692A69692A2A
        2A6969692A2A692A2A2A2A696A696A2A2A2B2A2A6A6A6C2B2B2A672727696767
        00002B2A2B2B2B2B2B2B2B2B6A6A2B2B2B2D2B2D6C6C2D2D6C2D2D2D6C6C6C6E
        70757075757676767575989A9A9A9A9A9A9A9A9A9898A8987698989876767675
        707570706C2D2D6C6C2D2D2D2D2D2D2B2D2B2D2B2B2B2B2B6A6A2B6A6A2B2B2B
        6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B6A2B2B
        2B2B2B6A6A2D2D2D2D2B2D2D2B2D2B2D2B2B2B2B6C6C6A2A2A69692A2A2A2A2A
        2A69692A2A2A692A2A2A2A2A6A692B2A2A2B2A2A6A6A2B2D2B2B6727272A6727
        00002B6A6A6A2B2B2B696A6A6A2B2B2B6A2D2B2D2D2B2D2D2D2D2D2D6C6C6C6D
        6D707575757676767675989A9A9A9A9A9AA89A9A98A898989877987676767675
        6F7575706D2D2D2D2D2D6C6C2D2D2D2B2D2D2B2B2B2B2B6A2B2B2B2B2B2B2B2B
        2B2B6A2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B6A6A2B6A6A2B2B2B2B2B2B2B2B
        6A2B2B2B2B2B2D2D2D2B2D2B2D2B2D6C6A2B2B2B2D2D2B2A2A2A2A2A2A2A2A69
        692A2A2A69692A2A2A2A2A2A2A2A2B2A2B2A6969692A2B6A6C2B2A266727272A
        00002B6A6A692B2B2B6A6A6A6A2B2B2B6A2D2B2D2D2B2D2D2D2D2D2D6C6D6C2D
        6D707570757676767575779A9A9A9A9A9A9A9A9AA89A98989876989876767675
        6F6E706E6C2D2D2D2D2D6C6C2D2D2D2B2D2D2B2B2B2B2B6A2B2B2B2B2B2B2B2B
        2B2B6A2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B6A6A2B6A6A2B2B2B2B2B2B2B2B
        6A2B2B2B2B2B2D2D2D2B2D2B2D2B2D6C6A2B2B2D2D2B2A2A2A2A2A2A2A2A2A69
        692A2A2A69692A2A2A2A2A2A2A2A2B2A2B2A6969692A2B6A6C2B2A266727272A
        00002B2A2B2A2B2B2B2B2B2B2B2B2B2B2B2B2D2B2D2D2D2D2D2D2D6C6C6C6C2D
        6D707575757676767570779A9A9A9A9A9A9A9A9A989898987798769876767575
        6F6C6C6C6C6C2D6C6C6C2D2D2D2D2D6A6C2B2D2B2B2B2B2B2B2B2B2B2B2B2B6A
        6A6A2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B6A2B2B2B6A6A2B2B2B2B2B
        2B2B2B2B6A6A2D2D6C2B2D2B2D2B2D2B2B2B2D2D2D2B69692A2A2A2A2A2A2A2A
        2A2A2A2A69692A2A2A2A2A2A2A2A2A2A2A2A2A2A2A696A6A6C6A696727676727
        00002B2B2B6A2B2B6A2B2B2B2B2B2B2B2B2D2B2D6C6A6C6C2D2D2D6C6C6C6C6E
        7070757076767676757076A99A9A9A9A9A9A9AA8989898987698987776767675
        6F706C6C6C6C2D6C6C2D2D2D6C2D2B2D2B2D6A6A6A6A6A2B2B2B2B2B2B2B2B2B
        2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B6A6A2B2B2B2B2B2B
        2B2B2B2B2B2A6A6C2D2B2D2B2D2B2D6A6A2B2D2D2D2B2A69692A2A692A2A2A2A
        2A2A2A2A2A2A2A2A2A2A2A2A2A69692A2A2A2B2A2A69696A6C6C2A2727272727
        00002B2B2B6A2B2B6A2B2B2B2B2B2B2B2B2D2B2D6C6A6C6C2D2D2D6C6C6C6C70
        75757075757675767675769AA99A9A9A9A9AA89A989A98987798769876767675
        70756D2D6C6C2D6C6C2D2D2D6C2D2B2D2B2D6A6A6A6A6A2B2B2B2B2B2B2B2B2B
        2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B6A6A2B2B2B2B2B2B
        2B2B2B2B2B2A6A6C2B2D2D2B2D2B2D6A6A2B2D2D2D2A2A69692A2A692A2A2A2A
        2A2A2A2A2A2A2A2A2A2A2A2A2A69692A2A2A2B2A2A6969696A6C2B2A27272727
        00006A2B2B2B2B2B2B2D2B2B2B2B2B2B2B2D2B2D2D2B2D2D2D2D2D2D6C6C6C70
        70757075707576757676779A9A9A9A9A9A9A9A98989898987798987676767675
        70756D2D6C6C6C2D2D2D6C6C6C2D2B2D6A6A2B2B2B2B2B6A2B2B6A6A2B2B2B2B
        6A6A6A6A6A2B2B2B2B2B2B6A6A2B6A6A2B2B2B2B2B2B6A6A2B2B2B6A6A6A2B2B
        6A2B2B2B2B2A2B2B2D6A6C6A2D2B2D6A6A2D2D2D2B2A69692A2A2A2A6969692A
        2A2A69692A672A2A2A2A2A2A69692A2A2A2A2B2A2A2A2A2A2B2D2D2A2726272A
        00002B2A2B2B2B2B6A2D2B6A6A2B2B2B2B2D2B6C6C2B2D6C6C2D2D6C2D6C6C6D
        7070757075707676767576A89AA69A9AA89A9A98989898987798767676767675
        6F75706E6C2D2D6C6C2D6C6C2B2D2B2D2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B6A
        2B2B6A2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B6A2B2B
        2B2B2B2B2A2B2A2B2B2D2B2D6A6A2B2B2B6C6C6C2A2A2A69692A2A2A2A2A6969
        692A2A2A2A672A69692A2A2A2A2A2A2A2A6969692B2A2A2A2B2B2D2B26676727
        00002B2A2B2B2B2B6A2B2B6C6A2B2B2B2B2D2B6C6C2B2D6C6C2D2D6C2D2D6C2D
        6C70757570757676767676989AA99A9A9A9AA8989A9898987798767676767675
        6F7570706D2D2D6C6C2D6C6C2B2D2B2D2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B6A
        2B2B6A2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B6A2B2B
        2B2B2B2B2A2B2A2B2B2D2B2D6A6A2B2B2B6C6C6A2B2A2A69692A2A2A2A2A6969
        692A2A2A2A672A69692A2A2A2A2A2A2A2A6969692B2A2A2A2B2B2D2B27676727
        00002B2A2B2B2B2B2B2B2B2D2B2D2B2B6A2B2B2D6A6C6C6C6C6C6C6C6C6C6C6C
        6D70757075707676767675769AA69A9A9A9A98A8989898989898987677767675
        6F756D6C6C6C2D6C6C6C6C6C2D2B2D2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B
        2B2B2B2B2B2B2B2B2B2B2B6A6A2B6A6A2B2B2B6A6A2B2B2B6A6A6A6A6A2B6A6A
        6A2B2A6A692B2A2B2B2B2D2B2D2B2B2B2B2D2D2A2A2A692A2A69692A6969692A
        2A69692A2A2A2A2A2A2A2A2A2A2A6969692A6969692A2A69692B2D2B69262727
        00002B696A2B6A6A2B6A6A2D2B2D2B2B6A2B2B2D6A6C6C6C2D6C6C2D6C6C6C6C
        6C70757575757676757675759A9A9A9A9AA89A98989A98989877987676767675
        6F756D2C6C6C2D6C6C6C6C6C6C2B2D2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B
        2B2B2B2B2B2B2B2B2B2B2B6A6A2B6A6A6A6A6A6A6A2B2B2B6A6A6A6A6A2B6A6A
        6A2B2A6A696A2A2B6A2B2D2B2D2B2B2B2D2D2B2A2A2A692A2A69692A69692A2A
        2A6969272A2A2A2A2A692A2A69696969692A6969692A2A6969692D2B6A272727
        00002B696A2B6A6A2B6A6A2B2D6A2D2B2B2D2B2D6A6C2D2D2D2D2D2D2D2D6C6C
        6D7075707676767576767570989A9A9A9A9898A8989898989877767676767575
        756F6D6C6C6C2D2D2D2D6C6C6C2B2D6A6A2B2B2B2B2B2B2B6A6A2B2B2B6A6A2B
        2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B6A6A6A6A6A2B2B2B6A6A6A2B2B2B6A6A
        2B6A692B2A6A2A2B692B2D2B2D2B6A6C2D6C6A2A2A2A69692A2A2A2A69672A2A
        2A2A69682A2A2A2A2A69696969692A2A2A2A69692A2A2A2A2A692B2D2B2A2627
        00002B2A2B2B2B2B2B2B2B2B6A6C2B2D6A2B2B6C6A6C2D2D6C2D2D6C6C6C6C6E
        75707570757576767676757576A99A9A9898989A9898A898987698767675756F
        75706D2D2D2D2D2D2D6C6C6C2D2B2D6A6C2B2B6A6A2B2B6A6A6A6A2B2B6A6A2B
        2B2B6A2B2B2B6A6A2B2B2B6A6A2B2B2B2B2B2B6A6A2B2B2B2B2B2B6A6A2B2B2B
        6A6A696A2A2B69692A2B2B6C2B2B6A6C6C6C2A2A2A2A2A2A2A2A2A692A672A68
        682A2A692A672A2A2A2A6967272A2A6969692A2A69692A2A2A2B2B2B2D2A2627
        00002B2A2B2B2B2B2B2B2B2B6A6C2B2D6A2B2B6C6A6C2D2D6C2D2D6C6C6C6C70
        757570757075757675767575769A9A9A9898989898A898989898767676757075
        75706D2D2D2D2D2D2D6C6C6C2D2B2D6A6C2B2B6A6A2B2B6A6A6A6A2B2B6A6A2B
        2B2B6A2B2B2B6A6A2B2B2B6A6A2B2B2B2B2B2B6A6A2B2B2B2B2B2B6A6A2B2B2B
        6A6A696A2A2B69692A2B2B6C2B2B6C6C6C6A2A2A2A2A2A2A2A2A2A692A672A68
        682A2A69672A2A672A2A6769272A2A6969692A2A69692A2A2A2B2A2B2D2A2727
        00002B2A2B2B6A6A6A2B2B2B2B2B2D2D2B2D2B6C6A6C2D2D6C2D2D2D6C6C6C70
        70757570757075757676757075989AA99A989898989A98987798767676766F75
        75706D2D2D2D2D2D2D6C6C6C2B2D2B2D2B2D2B2B2B2B2B2B2B2B2B2B2B2B2B2B
        6A6A2B2B2B6A6A6A2B2B2B2B2B2B6A6A2B2B6A2B2B2B2B2B2B2B2B2B2B6A2B2B
        2B2A2B696A2A2B2A2B2A2B2B2B2B2D2D2D2B2A2A2A2A69692A2A2A6968682A69
        692727682A2A272A672A2A2A2A2A2A2A2A6969692A2A2A2A2A2A2A2B2D2B2A27
        00006A696A2B696A6A2B2B2D6A6A2D2D2D2B2D6A2D2B6C6C2D2D2D2D6C6C6C6D
        6E707570757570757676757075989A9A98A89A98989898987776767676767575
        70756D2D2D6C6C2D2D2D2D2D2B6C6A6C2B2D6A6A2B2B2B2B6A6A2B2B2B2B2B2B
        2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2A2B2B2B2B2B2B6A6A
        6A2A2B2A2B2A2B2A2B2A2B2B2B2B6C6C6C6969692A2A2A27276967682A672A2A
        2A2A69692727692A2A2A69692A2A692A2A2A69692A2A2A6969692A2B2B2D2A27
        00006A696A2B696A6A2B2B2D6A6A2D2D2D2D2D6A2D2B6C6C2D2D2D2D6C6C6C2D
        6D707575757675757676757575779A9A989A9898A89898987776767676767675
        756F6D2D6C6C6C2D2D2D2D2D2B6C6A6C2B2D6A6A2B2B2B2B6A6A2B2B2B2B2B2B
        2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2A2B2B2B2B2B2B6A6A
        6A2A2B2A2B2A2B2A2B2A2B2B2B2D6C6C696969692A2A2A27276967682A672A2A
        2A2A69692727692A2A2A69692A2A692A2A2A69692A2A2A6969692A2A2B2D2A27
        00006A2A2B2A6A6A2B2B2B2B2B2B6C6C2D2D2D6C2D2B6C6C2D2D2D2D6C6C6C6C
        6D707570767675767675767670769A9A9A9AA8989A98A8987676767676767575
        6F756D2D6C6C2D2D2D2D2D2D2B2B2B2D2D2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B
        2B2B2B2B2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B
        2B2A2B696A2A6A696A2A2B696A6C2D2D2A2A2A6969692A2A2A69692A2A2A2A2A
        2A2A2A2A2A672A2A2A2A2A2A2A69692A2A2A69692A2A2A69692A69696A2B2B68
        00002B2A2B2A2B2B6A6A6A2B2B2D6A6C2D2D2D2D2D2D6C6C2D6C6C2D6C6C6C6C
        6D70757076767676767676766F769AA99A9A9A989898A8987676767676757575
        70706D6C6C2D2D2D2D2D2D2D2B2D2B6C6A6C2B2B2B2B2B6A6A6A2B6A6A2B2B2B
        2B2B2B6A6A2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B6A6A6A2B2B2B2B2B2B2B
        2B2A2B696A2A2B2A2B6969696C6C2D2B2A2A2A2A69692A2A2A69696969696969
        6927272A2A2A2A2A2A2A696969672A2A2A2A2A2A2A2A2A2A2A2A6969696A6A69
        00002B2A2B2A2B2B6A6A6A2B2B2D2B2D2D2D2D2D2D2D6C6C2D6C6C2D6C6C6C6C
        6D70757076767576767576766F769AA99A9A9898989898987776767676756F75
        7570702D2D2D2D2D2D2D2D2D2B2D2B6A6C6A2B2B2B2B2B6A6A6A2B6A6A2B2B2B
        2B2B2B6A6A2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B6A6A6A2B2B2B2B2B2B2B
        2B2A2B696A2A2B2A2B69692A2D2D2B2B2A2A2A2A2A2A2A2A2A69696969696969
        6927272A2A2A2A2A2A2A696969672A2A2A2A2A2A2A2A2A2A2A672A2A696A6A6A
        00002B2A2B2A2B2B2B2B2B6C6A2D2B2D2D2D2D2D2D2D2D2D2D2D2D2D6C6C6C2D
        6C707575757676767576767575759A9A9A98989A989A98987776767676756F76
        75756D2D2D2D2D6C6C2D2D2B2D2B2B2D2B2D2B2B2B2B2B6A2B2B2B2B2B6A6A2B
        2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2A2B2B2B2B2B2B2B2B6A6A2B2B2B6A6A6A
        2B696A692B2A6A696A2A2A2A2D2D2B2A2A2A2A692A2A2A2A2A69692A2A2A6827
        272A2A2768682A696927272A6969692A2A276967692A2A672A692A2A2A2B2B2B
        00006A2A2B2A2B2B2B2B2B6C6A2D2B2D2D2D2D6C6C6C2D2D2D2D2D2D6C6D6C6E
        707075707576757676757676757598A99A989898989898987776767676757576
        75756B2D2D2D2D6C6C2D6C6A2D6A6A2D2B2B2B2B2B2B2B6A2B2B2B2B2B6A6A2B
        2B2B2B2B2B2B2B2B2B2B6A2B2B2B2B2A2B2B2B2B2B2B2B2B6A6A2B2B2B6A6A6A
        6A696A692B2A6A696A2A2A2B2B2B2B2A2A2A2A692A2A2A2A2A69692A27276827
        272A2A2768682A676827272A2A27682A2A276967692A2A2A2A692A2A2A2A2B2B
        00006A2A2B2A2B2B6A6A6A2D2B2D2B2D2D2D2D6C6C6C2D2D2D2D2D2D6C6C6C70
        7570757075707676767676757575989AA99898A8989898777676767676767670
        75706D2D2D6C6C2D2D2D6C6C2B6C6A2D2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B
        2B2B2B2B2B2B2B2B2B2B6A2B2B6A6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B696A
        692B2A2B2A2B2A2B2A696A2B2B2A2A2A2A2A2A2A2A2A2A2A2A2A2A692727692A
        2A2A2A2A69692A27272A2A2A2A27272A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2B2B
        00002B696A2A6A6A6A2B2B6C6A2D2B2D2D2D2D2D2D2D6C6C2D2D2D2D6C6C6C6D
        6D70757570757676767575757075769AA69AA898989876987676767676767570
        6C6D6C6C2D6C6C2D2D2D2B2D2B2D2B6C6A6C2B2B2B2B2B2B2B2B6A6A2B2B2B2B
        2B2B6A2B2B2B6A6A2B2B2B6A6A6A2B2B6A6A6A6A6A2B6A6A2B2B2B6A692B2A2B
        2A2B2A2B2A2B696A2A2A2B2D2A272768692A2A692A2A2A68682A2A2A2A2A2A69
        692A2A2A2A2A2A2A2A692A2A69692A69692A2A2A2A69692A2A2A2A2A2A2A2A2B
        00002B696A2A6A6A6A2B2B6C6A2D2B2D2D2D2D2D2D2D6C6C2D2D2D2D6C6C6C6C
        6C707570757575767676757075707698A6A99A9898987776767676767676756B
        2D2D6C6C2D6C6C2D2D2D2B2D2B2D2B6C6A6C2B2B2B2B2B2B2B2B6A6A2B2B2B2B
        2B2B6A2B2B2B6A6A2B2B2B6A6A6A2B2B6A6A6A6A6A2B6A6A2B2B2B6A692B2A2B
        2A2B2A2B2A2B696A2A2A2B2D2A262668692A2A692A2A2A68682A2A2A2A2A2A69
        692A2A2A2A2A2A2A2A692A2A69692A69692A2A2A2A69692A2A2A2A2A2A2A2A2A
        00002B696A6A2B2B2B6A6A6C6A2D2B2D6C2D2D2D2D2D6C6C6C6C2D2D6C6D2D6C
        6D707575707576767676757075707598A99A9A9898989876767676767676756D
        2D6C6C2D2D2D2D2D2D2B2D2B6C2B2D2B2B2B2B2B2B6A6A6A2B2B6A6A2B2B2B2B
        2B2B6A2B2B2B2B2B2B2B6A2B2A2B2B2B2B2B2B2B2B6A2B2B2B2A2B2A2B2A2B2A
        2B2A2B696A2A2B2A2A2B2B2B2A2667682A2A2A2A2A2A69692A2A2A2A2A2A692A
        2A27272A2A2A2A696927272727272A2A2A2A2A2A2A27276969692A2A2A69692A
        00002B2A2B2B2B2B2B2B2B6A6A2D2B2D6C2D2D6C2D2D6C6E706C2C2D6C6C6C6C
        6D707570757075757575757075706D77A69A9A98989898767676767675767570
        6D6C6C6C2D2D2D2D2D2B2D2B2D2B2D2D6A6A2B2B2B2B2B6A2B2B2B2B2B2B2B2B
        6A6A6A2B2B2B2B2B6A6A6A6A6A2B2B2B6A6A2B2B2A2B6A692B2A2B2A2B692B2A
        2B2A2B696A696A692A2D2B2A676767682A2A2A2A2A2A68272A69692A69692A67
        2A2A69692A2A6927272A2A2A672A2A2A2A672A272A2A2A2A2A2A69692A2A2A2A
        00002B2A2B2B2B2B2B2B2B6A6A2D2B2D6C2D2D6C2D2D6C6E706D6C2D2D2D6C6C
        6D7075757075707075707570756E6C76A99A9A98989898767676767670757675
        706C6C6C2D2D2D2D2D2B2D2B2D2B2D2D6A6A2B2B2B2B2B6A2B2B2B2B2B2B2B2B
        6A6A6A2B2B2B2B2B6A6A6A6A6A2B2B2B6A6A2B2B2A2B6A692B2A2B2A2B692B2A
        2B2A2B696A696A692B2D2B27676767682A2A2A2A2A2A68272A69692A69692A67
        2A2A69692A2A6927272A2A2A672A2A2A2A672A272A2A2A2A2A2A69692A2A2A2A
        00002B2A2B692B2B2B2B2B6A6A2D6A6C2D6C6C6C2D2D2D6C6D70702C2D6C6C6C
        6D707575707575707570757075706C759A9A9898989898777676767670757675
        702D6C6C2D2D2D2D6C6A2D2B2D2B2D2B2B2B6A6A6A6A6A6A6A6A6A2B2B2B2B2B
        2B2B2B2B2B2B6A6A2B2B2B2B2B2B6A6A2B2B2B6A692B2A2B2A2B2A6A692B2A2B
        2A6A692B2A2B2A2B6A2B2B2727272727272A2A2A2A2A69692A2A2A2A2A2A692A
        672A272A2A2A692A2A2A67692A2A2A2A672A2A2A2A272769692A69692A2A2A2A
        00002B2A2B692B2B2B2B2B6A6A2D6A6C2D6C6C6C6C6C6C2D6C7075706C2D6C6C
        6C6D706D7075707570757570756D6C75989A9898779876989876767675757575
        706C6C6C2D2D2D2D6C6C6A6C2B2D2B2D2B2B6A6A6A6A6A6A6A6A6A2B2B2B2B2B
        6A696A6A6A2B6A6A2B2B2B2B2B2B6A696A692B696A2A2B2A2B696A696A2A2B2A
        6A696A2A2B2A696A6C69682727272727272A2A2A696969692A27272A2A2A692A
        672A272A2A2A2A2A2A6968692A672A6967692A2A2A272769692A27272A2A2A2A
        00002B2A2B2A2B2B2B2B2B6A6A2D2B2D6C2D2D6C6C6C6C6C6C707576702D6C6C
        6C6C2D6D707575707570757075706C70779A9A76989898987676767676757075
        6E6C6C6C2D2D2D2D2D2D6A6C2B2D2B2D2B2B2B2B2B6A6A6A2B2B2B2B2B2B2B2B
        6A696A6A6A2B2B2B2B2B2B2B2B2B2B2A6A692B2A2B2A2B2A2B696A2A2B2A2B2A
        6A2A2B2A2B2A6A6A6C69262727272727272A2A2A6969692A2A27272A2A2A2A2A
        672A672A2A2A27272769692A2A672A69696927272A2A2A2A2A2A27272A2A2A2A
        00002B2A2B2A2B2B2B6A6A2B2B6C2B2D6C2D2D2D2D2D2D6C6C6C7076756E6C6C
        6C6C2D6C7075757075707575756E6C70769A9A9898779898767676767675706D
        6C6C6C6C6C2D2D2D2D2D2B2D6A2D2B2D2B2B2B2B2B6A6A2B2B2B2B6A6A2B2B2B
        2B2B2B2B2B2B2B2B2B2B2B6A692B2B2B2A2B2A2B2A6A2A2B2A2B2A2B2A2B2A2B
        2A2B2A2B69692B2B2B2A2627676727272767682A69692A276869692A2A2A2A2A
        2A69692A2727272727272A2A69692A69692A27272A2A2A2A2A692A2A682A2A2A
        00002B2A2B2A2B2B2B6A6A2B2B6C2B2D6C2D2D2D2D2D2D6C6C2D6D7576756E6C
        6C6C6C6D6D70757570757575706D6C6C759A9AA898989876987676757675706F
        6C6C6C6C6C2D2D2D2D2D2B2D6A2D2B2D2B2B2B2B2B6A6A2B2B2B2B6A6A2B2B2B
        2B2B2B2B2B2B2B2B2B2B2B6A692B2B2B2A2B2A2B2A6A2A2B2A2B2A2B2A2B2A2B
        2A2B2A2B69692B2B2A2A2627676727272767672A69692A276869692A2A2A2A2A
        2A69696727272727272A272A69692A69692A27272A2A2A2A2A692A2A682A2A2A
        0000692B2A2B2B2B6A6A6A2B2B6C2B2D6C2D2D2D2D2D2D6C6C2D6D7575767570
        2D6C6C6C2D6D7075757075706D2D6C2D70A8A99A989877767676767676757575
        6D2D2D2D2D2D2D2D6C6A2D2D6A2D2B6C6A6A2B2B2B2B2B2B2B2B2B6A6A2B2B2B
        2B2B2B2B2B2B2A2B2B2B692B2A6A692B2A2B2A2B2A6A2A2B2A2B2A2B2A6A2A2B
        2A2B2A2B2A2A2D2B27676727272727272727272A69692768692A2A2A69692A69
        696767272727272727682A672A672A2A2A2A69692A2A2A2A2A2A2A2A672A672A
        00002A2B2A2B2B2B6A2B2B2B2B2D2B2D2D6C6C2D2D2D2D6C6C2D6D7575767670
        2D2D6D2D6C6C6D70756D6D6D6C6C6C2C7098A99A987798767676767576757575
        6D2D2D2D6C2D2D2D2D2B2D2D2B2D2B2D2B2B2B2B2B2B2B2B6A6A2B2B6A6A6A2B
        2B2B6A2B2B2B2A2B2A2B2A2B2A2B2A2B2A2B696A696A696A2A2B2A2B2A2B2A2B
        692B2A2A2A2B2D2B26272727272727272727272A2A672A696927272A69696927
        2769696727272727272A672A26272A27272A2A2A2A2A2A69692A2A2A2A2A2A2A
        00002A2B2A2B2B2B6A2B2B2B2B2D2B2D2D6C6C2D2D2D2D6C6C2D6D7575767675
        2D6C2D6C6C6C2D6E706C2D6C6C6C6C2D6E779A9A989877767676767675757070
        6D2D2D2D6C2D2D2D2D2B2D2D2B2D2B2D2B2B2B2B2B2B2B2B6A6A2B2B6A6A6A2B
        2B2B6A2B2B2B2A2B2A2B2A2B2A2B2A2B2A2B696A696A696A2A2B2A2B2A2B2A2B
        692B2A2A2B2D2B2A27272727272727272727272A2A672A696927272A69696927
        2769696926272727272A672A26272A27272A672A2A2A2A69692A2A2A2A2A2A2A
        0000692B2A2B2B2B2B2B2B2B2B2D2B2D2D2D2D2D2D2D6C6C6C6C6D7570757676
        706C2D6C6C6C6C6C6C6C6C6C6C6D2D2D6D76A89A98987677767676757575706D
        6C6C6C6C6C2D2D2D2D2B2D2D2B2D2B2D6A6A2B2B2B6A6A2B2B2B2B2B2B2B2B2B
        6A6A2B2B2B2B696A2B2A2B2A2B2A6A692B2A2B2A2B2A2B2A2B696A696A2A6A69
        6A2A2B696A2D2A672727272727272727272727272A2A2A2A2A27272A2A672A2A
        2A6969276967272A67272A6727272A2A672727682A2A2A27272A27276968682A
        0000692B2A2B2B2B2B2B2B2B2B6C6A6C6C2D2D2D2D2D2D2D6C2D6D7570757676
        75706D6C6C6C6C6C6C6C6C6C6C6C6C2D6D7598A998777676767676766F75706D
        2D6C6C2D6C2D2D2D6C6A2D2D6A6C6A2D2B2B2B2B2B6A6A2B2B2B6A6A6A2B2B6A
        2B2B6A6A6A2B2A2B2A2B692B2A2B2A2B2A2B2A2B2A2B2A2B2A2B2A6A696A2A2B
        2A2B2A2B6C6A2A2767272727272727272727272769692A2A2A2A2A2A6969672A
        2A2A2A2A68672727272727276767272A2A26672A68272A68692A2A2A2A2A2A2A
        0000692B2A2B2B2B2B2B2B2B2B6C6A6C6C2D2D2D2D2D2D2D2D2D6D7570757576
        7676702D6C6D6C6C6C6C6D6C6C6C6C6C6D6E989A98777676767676757575706D
        2D6C6C2D6C2D2D2D6C6A2D2D6A6C6A2D2B2B2B2B2B6A6A2B2B2B6A6A6A2B2B6A
        2B2B6A6A6A2B2A2B2A2B692B2A2B2A2B2A2B2A2B2A2B2A2B2A2B2A6A696A2A2B
        2A2A2A2D6A6A272667272727272727272727272769692A2A2A2A2A2A6969672A
        2A2A2A2A68672727272727276767272A2A262A2A67272769672A2A2A2A2A2A2A
        00002A69692B2B2B2B2B2B2B2B2D6A6C6C2D2D2D2D2D2D6C6C6C6D7575707075
        7676702D6C6C6C6C6C6C6C6C6D6C6C6C6C6C76A9989876767676767676756F6D
        2D6C2D2D2D2D2D2D2D2B6C6C2B2D2B6C6A2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B
        2B2B6A6A696A2A2B696A692B2A2B2A2B2A2B2A2B2A6A2A2B2A2B2A2B2A2B6969
        692A2B2D2B2A676727272727272727676727276727276969692A2A2727272A2A
        2A2727276767272A672A26272A672A272A262A2A2667672A2A2769692A2A672A
        00002A69696A2B2B2B6A6A2B2B2D6A6C6C6C6C2D2D2D2D6C6C6C6D7570757575
        767676706D2D6C6D6C6D6C6D6C6C6D6C2D2C75A99A987576767676757675706D
        2D6C2D2D2D6C6C2D2B2D6C6A2D2B2D6A6A2B6A6A6A2B2B6A6A6A2B2B2B6A6A2B
        2B2B6A6A696A2A2B696A2A2B2A2B2A2B2A2B2A2B2A6A2A2B2A6A692B2A2B6969
        692A2B2D2B26676727272767272767676727276727276869696969272727692A
        2727272767682769672A26272A672A27272727272A67672A2A686969692A672A
        00002A2B2A6A2B2B2B6A6A2B2B6C2B2D2D6C6C2D6C6C2D6C6C2D6D7570757676
        767677766F6C6C6C6C6C6C6C6C6C6C6C2D2D70A89A987576757676767675706D
        2D2D2D2D2D6C6C2D2B2D2B2D2B6A6A2D2B2B6A6A6A2B2B6A2B2B2B2B2B6A6A2B
        2B2B2B2B2A2B2A2B2A2B2A2B2A2B2A2B2A2B2A6A696A2A2B2A6A692B2A2A6969
        2A2B2B2B2A2767672727276727276767272727272727682A2A69692A672A6927
        272A67272A2767676727272727272727272727272A672A2A2A692A2A692A2A2A
        00002A6A692B2B2B2B2B2B2B2B2D2B2D2D2D2D6C6C6C2D2D2D2D6D7570757676
        76767676766F6C2D6C6C6C6C6C6C2D2D2D2D70989A987576767576757675706C
        2D2D6C6C2D2D2D2D2B2D2B2D2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B
        2B2B2B2B2A2B696A2A2B692B2A2B696A2A2B2A6A692B2A2B2A2B2A2B2A2A6969
        2A2B2D272727272767272727272727272727272727272A2A2A2A2A2A69692669
        6767672727276727276767672727272A67272A672727272A2A2A672A67276869
        00002A6A692B2B2B2B2B2B2B2B2D2B2D2D2D2D6C6C6C2D2D2D2D6D7575707576
        7675767676756C2D6C6C6C6C6C6C2D2D2D2D6D75A89876757676757675756F6D
        2C2D6C6C2D2D2D2D2B2D2B2D2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B
        2B2B2B2B2A2B696A2A2B692B2A2B696A2A2B2A6A692B2A2B2A2B2A2B2A2A6969
        2B2D2B272627272767272727272727272727272727272A672A2A2A2A69672769
        6767672727276727276767672727272A67272A672727272A2A2A26672A676869
        00002A69692B6A6A2A6A6A2B2B2D6A6C2B6C6C6C6C6C6C6C2D2D6D7570757075
        7676767676756B2D6C6C6C6C2D2D2D2D2D2D2C6E9A987676757676757575706C
        2D2D2D2D2D2D2D2B6C6A2B2B2B2B2B6C2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B6A
        6A6A6A2A2B2A6A692B2A2B2A2B2A6A692B2A2B696A2A2B2A2B2A2B2A2A692A2A
        2B2D2A2726272727272727272727272727272727272727676869692A26276967
        672A67272767272727272727676767272727272727672A69696926272A2A2A67
        00002A2B2A6A2B2B2B2B2B2B6A6C2B2D6A2D2D6C6C2D2D2D2D6C6D6D70757075
        757676767676756D2C6C6C6C2D2D2D2D2D2D2C6E989A76767675767675706D6C
        2D6C2D2D2D2D2D2B6C6C2B2B2B2B2B2D2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B
        2B2B2B2A2B696A696A692B2A2B696A2A2B2A2B2A2B2A2A2A69692A2A2A2A696A
        2D2A2A67672727272727276727276767272727672727272A2A27272727276827
        27276767272727696767272767676727276727272767676967272A6727696768
        00002A2B2A6A2B2B2B2B2B2B6A6C2B2D6A2D2D6C6C2D2D2D2D6C6C6C70757570
        75757675767676706C6C6C2D2D2D2D2D2D2D2C6E989A767676757676706D2D2D
        2D6C2D2D2D2D2D2B6C6C2B2B2B2B2B2D2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B
        2B2B2B2A2B696A696A692B2A2B696A2A2B2A2B2A2B2A2A2A69692A2A2A2A696A
        2D2A2667672727272727276727276767272727672727272A2A27272727276827
        27276767272727696767272767676727276727272767676967272A6727696768
        00002A2A2A2B2A2B2B2B2B2B2B2D2B2D6A2D2D2D2D2D6C6C6C6C6C6C70757570
        7570757675757775706C2D2D2D2D2D2D2D6C2D6D76987776767676756D2D6C2D
        2D2D6C6C2D6C6C2B2D6A6C6A2B6A6A2D2B2B6A6A2B2B2B6A2B2B6A2B2B6A6A2B
        2B2B2B2A2B2A6A692B2A2B2A2B2A69692A2A2A2B2A2B2A2A69692A2A2A2A2B2B
        2B672727272727272727272727272727272767276767272A672A672727272727
        272727272767272A6727272727676727272727272727272A672A26272A272769
        0000692A2A2B2A2B6A2B2B2B2B2D2B2D6A6C6C2D2D2D6C6C6C6C6C6C6D707075
        7075707575707576752D2C2D2D2D6C2D2D6C2C6C75989876757675706C2D6C2D
        2D2D6C6C2D6C6C2B2D2B6C6A2D6A6C2B2D2B6A6A2B2B2B6A2B2B6A6A2B2B2B2B
        2B2B2B6A692B2A6A696A2A2B2A6A69692A2A692A2A692A2A69692A2A2A696A6A
        69262727272767672727272727276767276767272727276767672A672A676727
        2727272767672727272727272767672A672A2627272A672A266727676727272A
        0000692A2A2B2B2B6A2B2B2B6A6C2B2D6A6C6C2D2D2D6C6C6C6C6C6C2D6D7075
        7570757075707576756E6C2D2D2D6C2D2D2D2D6C6D779A987576756F6D2D6C2D
        2D2D6C6C2D6C6C2B2D2B2D2B2D6A6C2B2D2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B
        2B2B2B6A692B2A6A696A2A2B2A6A69692A2A692A2A692A2A69692A2A2A6A6C69
        6726272727276767272727272727676727272727272727676727272A67692627
        2767672727272727272727272767672A672A2627272A672A262767672727272A
        0000692B2A2B2B2B6A2B2B2B6A6A2D2B2D2D2D6C2D2D6C6C2D2D6C6C2D6D7575
        75707570757075757676702C2D2D2D2D2D2D6C2D2D75A977757675706C6C6C6C
        6C6C6C6C2D2D2B2D2D2B2D2B2D2B2D2B2D2B2B2B2B2B2B2B2B2B2B2B2B6A6A2A
        6A6A2B2B2A6A692B2A2B2A2B2A2B2A2A2A2A6969692A69692A2A2A2A2B2B2D2A
        2627272727272727272727676767272767272727676727276767672727272767
        6767676727276727272727272727272727272A67272727272727272727272727
        0000692B2A2B2B2B2B2B2B2B6A6A6C6A2D2D2D6C6C6C6C6C2D6C6C6C6C6D6E70
        70707575707570757576756D2D2D2D2D2D2D6C2D2C759877757575706D2D6C6C
        6C6C6C6C2D2D2B2D2D2B2D2B2D2B2D2B2D2B2B2B2B6A6A2B6A6A2B2B6A6A6A2A
        6A6A6A2B2A6A692B2A2B2A2B2A2B2A2A2A2A6969692A69692A2A2A2A2B2D2A67
        2727272727272727276767676767272767272727676727276769672727272767
        6767276727276727272727272727272727272A67272727272727272767676727
        0000692B2A6A2B2B2B2B2B2B2B6A6C6A2D6C6C6C6C6C6C2D2D6C6C6C6C6C6C2D
        6D70757075757075757576706D2C2D2D2D2D2D2D29709876767570706D2D6C2D
        2D6C6C6C2D2D2B2D2B2D2B2D2B2D2B2D2B2D2B2B2B6A6A2B6A6A2B6A6A2B2B2B
        6A6A6A6A692B2A2B2A2B2A2B2A2B2A2A2A2A2A2A2A2A2A2A69692A2B2B6C6726
        272727272727276767676767676767672727272727272767672A672727272727
        6727276727276727272727276767272727272727272727676727676767676727
        00002A2A2B696A6A6A6A6A2B2B2D2B2D2B2D2D2D2D2D2D2D2D2D6C6C6C2D6C6C
        6C6C707575707575757576756D2C2D6C6C2D2D2D2970989876756D6D6C6C2D6C
        6C2D2D2D2D2D2B6C6A6C2B2D2B2B2B2D2B2D6A6A2B2B2B2B2B2B6A6A2B2B2B2B
        2B2B2B6A692B2A2B2A2B692B2A2A2A2A69692A2A2A2A2A2A2A2A2B2B2B6A6767
        2727272727272727272727276767272727272727272727272727276767672727
        2727676727276767672727676767272727272727272727676727676727272768
        00002A2A2B696A6A6A6A6A2B2B2D2B2D2B2D2D2D2D2D2D2D2D2D6C6C6C6C6C6C
        6C6C6D707570707070707575706C2D2D6C2D2D2D2B6D709A98706D2D6C6C2D6C
        6C2D2D2D2D2D2B6C6A6C2B2D2B2B2B2D2B2D6A6A2B2B2B2B2B2B6A6A2B2B2B2B
        2B2B2B6A692B2A2B2A2B692B2A2A2A2A69692A2A2A2A2A2A2A2A2B2B2B696767
        2727272727272727272727276767272727272727272727272727276767672727
        2727676727276767672727676767272727272727272727676727676727272768
        00002A2B2A2B2A2B2B2B2B2B2B2D2B2D2B2D2D2D2D2D2D2D2D2D6C6C6C6C6C6C
        6C6C6C6D70706C6C6C6C6E75766F2D2D2D6C6C2D2D2B6C9898756D2D6C6C2D2D
        2D6C2D2D2D2D2B6C6A2D2B2D6A2D2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B
        2B2B2B2A2B2A6A692B2A2B2A2B6969692A2A2A69692A2A2A2A2A2B6A6A262727
        6727276767272727672727676727272727272727676767272727272727272727
        2727272727272767672727272767672727272727676767272767676727676767
        0000696A692B2A2B2B2B2B2B6C6A2D2B2D2D2B6C6C6C2D2D6C2D2D6C6C6D2D6C
        6C6D2D6C6D6D6C6C6C6C6C707575706C2D2D2D2D2B2C6C7798706D2D6C2D2D2D
        2D2D6C6C2D2D2D2B2D2B6C6A2D2B2D2B6A6A2B2B2B2B2B2B2B2B6A6A6A2B2B6A
        2B2B2B696A2A2B696A696A2A2A69692A2A2A2A69692A2A2A692B2B6A69272727
        2727272727276767272727276767272727676727272727272727272727272727
        2767672767676727272727272727272727672727272727272727272769262727
        0000696A692B2A2B2B2B2B2B6C6A2D2B2D2D2B6C6C6C2D2D6C2D2D2D6C6C2D6C
        6C6C6C6C6C6C6C6C6C6C6C6C7070756D2C2D2D2D2B296C7798756D2D2D2D2D2D
        2D2D6C6C2D2D2D2B2D2B6C6A2D2B2D2B6A6A2B2B2B2B2B2B2B2B6A6A6A2B2B6A
        2B2B2B696A2A2B696A696A2A2A69692A2A2A2A69692A2A2A692B2D6967272727
        2727272727276767272727276767272727676727272727272727272727272727
        2767672767676727272727272727272727672727272727272727272769262727
        00002A2B2A2B2A2B2B2B2B2B6A6A2D2B2D2D2B2D6C6C6C6C2D2D2D2D2D2D2D6C
        6C6C6C6C6C6C6C6C6C6C6C6C6C70756D2C2D2D2D6A2D6A7598756E2C2D2D2D6C
        6C2D6C6C2D2D2D6A6C2B2D2B2D2D2B2B2B2B2B2B2B2B2B2B2B2B2B6A6A2B2B6A
        2B2B696A692B2A2B2A2B2A2A2A2A2A2A69692A2A2A2A2A2B6A6A2B2726272727
        6767672727272727276767272727676727676727272727272727272727276727
        2727276767672727272727272727272727272727272727272727676767272727
        00002A6A692B2A2B2B2B2B6A6A2D6A6C2B2D2D2D2D2D6C6C6C2D2D2D2D6C6C6C
        6C6C6C6D2D6C6C6C6C6C6C6C6C6D6D706E2D2D6A6C2B6C6D7698702C2D6C6C2D
        2D2D2D2D6C2B2D6A6C2D2B2B2D2D2B2D2B2B2B2B2B2B2B2B2B2B2B2B2B6A6A2B
        6A6A692B2A2B2A2B2A2B2A2A2A69692A69692A2A2A692A2B6C6A2A2626272727
        6767676767272727276767672727676727272727272727272767672767676727
        2727276727272727276767272727272727272727272727272727272727272727
        00002A6A692B2A2B2B2B2B6A6C2B6C6A2D2D2B2D2D2D2D6C6C2D2D2D6C6C6C6C
        6D2D6C6C6C6C6C6C6C6C6C6C6C6C6C70706C2D6C2B2D2B2C709A702C2D6C6C2D
        2D2D2D2D6A2D2B6C6A2D2B2B2D2B2D2B2B2B2B2B2B2B2B2B2B2B2B2B2B6A6A2B
        6A6A2B2A2B2A2B2A2B2A2B2A2A69692A2A2A2A2A2A692A2B6C69262727272727
        2727276767272727272727676727272727272727272727272767672767672727
        2727272727272727276767272727272727272727272727272727272727272727
        00002A2B2A2B2A2B2B6A6A2B2D6A2D2B2D2D2B2D2D2D2D2D2D6C6C2D6C6C6C6C
        6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6D6D2D6C2D2D6A6C29709A702C2D6C6C6C
        6C6C2D2D6A2D2B6C6A2D2B2B2D6A6C6A2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B6A
        2B2A2B2A2B2A2B2A6A69692A2A2A2A2A2A2A2A2A2A692B2B6A69272727272727
        2727272727272727672727276767272767272767272727676767672727272767
        6727272727272767672727272767672727272727272727272767676727676727
        00002A2B2A2B2A2B2B6A6A2B2D6A2B2D2B2D2D2B2D2D2D2D2D6C6C2D6C6D2D6C
        6C6C6C6C6C6C6C6C6C6C6C6C6C2D6C2D2D6C6C2D2D6A6C297098756C6C2D6C6C
        6C6C2D2D6A2D2B6C6A2D2B2B2D6A6C6A2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B6A
        2B2A2B2A2B2A2B2A6A69692A2A2A2A2A2A2A2A2A2A692B2B6968272727272727
        2727272727272727672727276767272767272767272727676767672727272767
        6727272727272767672727272767672727272727272727272767676727676727
        0000692B2A6A696A6A6A6A2B2B2B2D2B2D2D2B6C6C2D2D6C6C2D2D2D6C6C2D2D
        6C2D6C6C6C6C6C6C6C6D6C6C2D2D2D6C6C6C6C2D6C6A2D286D7676706C2D2D6C
        6C6C2D2B2D2B2D2B2D2B2B2B2D6A6C2B2B6A6A6A2B2B2B2B6A6A6A2B2B2B2B2B
        2B2A6A2A2B696A2A2A2A2A2A2A6969696969692A2A2B2B2B2726272727276767
        2767672727272727272727676767272767676727676727272727276767672727
        2727272727272727272727272767672727276767272727272727676767272767
        0000692B2A2B696A2B6A6A2B2B2B6A6C2B2D2D2B2D2D2D2D2D2D2D2D2D6C2D2D
        2D6C6C6C6C6C2D2D2D6C6C6C2D2D2D6C6C6C6C6C2D2D2B2B6B6E75756C2D2D6C
        6C2D6C6A2D2B2D2B2D2B2B2B2D2B2D2B6A6A2B2B6A2B2B2B2B2B2B2B2B2B2B6A
        2A2B2A2B2A6A696969692A2A2A692A2A69692A2A2B2B2B2A2727272727672727
        2727276767272727276767276767272767272727272727676727272727276727
        2727272727272727272727272727272727676767272727676727272767272767
        0000692B2A2B696A2B6A6A2B2B2B6A6C2B2D2D2B2D2D2D2D2D2D2D2D2D2D2D2D
        2D6C6C6C6C6C2D2D2D6C6C2D2D2D2D6C6C2D6C6C2D2D2B2B292D76766C2D2D6C
        6C2D6C6A2D2B2D2B2D2B2D2B2D2B2D2B6A6A2B2B6A2B2B2B2B2B2B2B2B2B2B6A
        2A2B2A2B2A6A696969692A2A2A692A2A69692A2A2B2D2A262727272727672727
        2727276767272727276767276767272767272727272727676727272727276727
        2727272727272727272727272727272727676767272727676727272767272767
        00002A2A2B2A2B2A2B2B2B2B2B2B2D2B2D2D2B2D2D2D2D2D2D2D2D2D2D2D2D2D
        2D2D2D2D2D6C6C6C6C2D2D2D2D2D2D2D2D6C6C6C6C6C2B2B2B2D76766D2C2D2D
        2D2D2B2D2B2D2B6C6A2D2B2D2B2D2B2B2B2B2B2B6A6A6A2B2B2B2B2B2B2B2B2B
        696A2A2B2A6A69692A2A2A2A2A2A2A2A2A2A2A2B2B6A2A262727272727672727
        6727272727272727672727272727272727676727676727676727272727272727
        2767672727272767672727272767672727672727676727272727676767272727
        00002A2A2B2A6A692B6A6A2B2B2B2D2B2D2B2D2D2D2D2D6C6C2D2D2D2D2D2D2D
        2D2D2D6C6C6C6C6C6C2D2D2D2D2D2D2D2D2D6C6C2D2D2D2B2B2D76766C2D2D2D
        2D6C2B2D2B2D2B2D6A6C2B2D2B2D2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B6A
        2A2B2A2B2A2A2A6969692A2A2A2A2A2A2A2A2A2B2B6927262767672727272727
        2767672727672727272727272727272727676727272727676767672727272727
        2727272767672767672727276767272727672727672727676727676727272727
        00002A2A2B2A6A692B696A2B2B2B2D2B2D2B2D2D2D2D2D6C6C2D2D2D2D2D2D2D
        2D2D2D6C6C6C6C2D2D2D2D2D2D2D2D2D2D2D6C6C2D2D2D2D2A2B7075702D6C2D
        2D6C2B2D2B2D2B2D6A6C2B2D2B2D2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B6A
        2A2B2A2B2A2A2A6969692A2A2A2A2A2A2A2A2A2D2A6727272767672727272727
        2767672727672727272727272727272727676727272727676767672727272727
        2727272767672767672727276767272727672727672727676727676727272727
        00002A2A2A2A2B2A2B6A6A6A6A2B2D2B2D6A6C2D2D2D2D2D2D2D2D2D2D2D6C6C
        2D2D2D6C2D2D2D2D2D2D6C6C2D2D2D2D2D2D6C6C2D2D6C2D2B6A6C7075702D2D
        2D2D2B2D6A2D2B2D2D2B2D2B2D6A6C2B2B2B6A6A2B2B2B6A2B2B6A6A2B2B2B2B
        2A2B2A6A6969692A2A2A2A2A2A692A2A696A2B2B2A6767672727272727272727
        2727272727272727272727276767272727676727272767676767672727276767
        6767672727272767676727276767272727272727272727272727272767272727
        0000692A2A2A2B2A2B6A6A6A6A2B6C6A2D6A6C2D2D2D2D2D2D2D2D6C2D2D6C6C
        2D2D2D6C2D2D2D6C6C2D6C6C2D2D6C6C6C6C2D2D2D2D6C6C6C2A296D76702D2D
        2D2D2B2D6A6C6A2D2D2B6C6A6C6A6A2B2B2B6A6A2B2B2B6A2B2B6A6A2B2B2B2B
        2A2B696A6969692A2A2A2A6969692A2A696A2D2A672767672727272727272727
        6727272767272727272727276767272727676727272767276767672727276767
        6767676727272767676727276767272727272727272727272727272767272727
        0000692A2A2A2B2A6A2B2B2B2B2B6C6A2D6A6C2D2D2B2D2D2D2D2D6C6C6C6C2D
        2D2D2D6C2D2D2D6C6C2D2D6C2D2D6C6C6C6C2D2D2D2D2D6C6C2B296D76702D2D
        2B2D2D2B6C6A6C2B2D2B6C6A6C2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2A2B
        2A2B692B2A69692A69692A69692A2A2A2B2B2B2A262727272767672727272727
        6727272767672727276767272727272727676727272727272727276727276727
        2767676727272727272727272727276767272727272727676727272727272727
        00002A6969692B2A6A2B2B6A6A2B2D2B2D6A6C2D2B6C6C6C2D2D2D2D6C6C2D2D
        2D2D2D2D6C6C2D2D2D2D2D2D6C6C2D2D2D2D6C6C2D2D2D2D2D2B2B6D76752C2D
        2D6A2D2D6A2D2D2B6C6A2D2B2D2B2D2B2B2B2B2B6A6A6A2B2B2B2B6A6A6A692B
        2A2B2A69692A2A6969692A2A2A2A2A2A2D2A2727272727272767672727672727
        2727272727272727276767676767272727272767272767672727276767676727
        2767672727272727272727272727676767672727272727272727272727272767
        00002A6969692B2A6A2B2B6A6A2B2D2B2D6A6C2D2B6C6C6C2D2D2D2D6C6C2D2D
        2D2D2D2D6C6C2D2D2D2D2D2D6C6C2D2D2D2D6C6C2D2D2D2D2D2D2B6B706E2D2D
        2D6A2D2D6A2D2D2B6C6A2D2B2D2B2D2B2B2B2B2B6A6A6A2B2B2B2B6A6A6A692B
        2A2B2A69692A2A6969692A2A2A2A2A2B2D2A2627272727272767672727672727
        2727272727272727276767676767272727272767272767672727276767676727
        2767672727272727272727272727676767672727272727272727272727272767
        00002A69692A2B2A2B2B2B2B2B2B2D2B2D2B2D2D2B2D2D2D2D6C6C6C2D2D6C6C
        2D2D2D2D6C6C6C2D2D2D6C6C2D2D2D6C6C6C2D2D6C6C2D2D2D6C2B6C2D6C6C2D
        2D2B2D2D6A2D2B2D2B2D2B2D2B6A6A2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2A6A
        2A2B6969692A2A6969692A2A2A2A2B2B6A692767672767672727272727672727
        2727276767272727272727272727676727676727676727272767672727272727
        2727272727276727272727272727272727272727676727272727272727272727
        00002A2A2B2A2B2A2B6A6A2B2B6A2B2B2D6A6C2D6C6C2D2D2D2D2D2D2D2D2D2D
        2D2D2D2D2D2D2D2D2D6C6C6C2D2D2D2D2D2D6C6C6C6C2D2D2B2D2D2B2D6D706C
        2B2D2B2D6A2D2B6C6A2B2D2D2B2B2B6A6A6A2B2B2B6A6A2B2B2B6A6A2A2B2A6A
        2A2B2A69692A2A692A2A2A2A2A2A2B2B2A676727272727272767676767272727
        6767676767272727672727272727272727676767272727272727272727272767
        6727272727272727272727276767276767672727272727272727272727272727
        00002A2A2B2A2B2A2B6A6A2B2B6A2B2B2D6A6C2D6C6C2D2D2D2D2D2D2D2D2D2D
        2D2D2D2D2D2D2D2D2D6C6C6C2D2D2D2D2D2D6C6C6C6C2D2D2B2D2D2B2D6F756C
        292D2B2D6A2D2B6C6A2B2D2D2B2B2B6A6A6A2B2B2B6A6A2B2B2B6A6A2A2B2A6A
        2A2B2A69692A2A692A2A2A2A2A2B2B2B26676727272727272767676767272727
        6767676767272727672727272727272727676767272727272727272727272767
        6727272727272727272727276767276767672727272727272727272727272727
        00002A2A2A6A2A2B2A2B2B2B6A6A2D2B2D6A6C6C6C6C2D2D6C2D2D2D2D2D2D2D
        2D2D2D2D2D2D2D6C6C2D2D2D2D2D2D2D2D2D2D2D2D2D2D6C6A2D2D2B2D70706D
        292D2B2D2B2D2B2D2B6C6A6C2B6A6A6A2B2B2B2B2B2B2B2B2B2B6A6A692B2A2B
        2A2B2A69692A2A2A2A2A2A2A2A6C696967672727272727272727276767672727
        2727272727272727272727272727272727272767272727272727276727272767
        6727272727272727272767672727272727276767672727272727272767272727
        00002A2A2A6A696A692B2B2B6A6A2D2B2D2B2D6C6C2D2B2D6C2D2D2D6C6C2D2D
        2D6C6C2D2D2D2D6C6C2D2D6C2D2D6C6C6C6C2D2D2D2D2D6C6A2D2B2D2B70752D
        2C2D2B2D2B2D2B2D2B6C6A6C2B6A6A2B2B2B2B2B2B2B2B6A2B2B6A696A2A2B69
        2A2A692A2A2A2A2A2A2A692A2B2B2B6767272727272727272727672727272727
        2727272727272727276767272727272727272727676767272727276767676727
        2727272727272727272767272727276767272727676727272727272727676767
        00002A2A2A2B696A6A2B2B2B6A6A2D2B2D2B2D6C6C2D2B2D2D2D2D2D6C6C2D2D
        2D6C6C2D2D2D2D6C6C2D2D6C2D2D6C6C6C6C2D2D2D2D2D2D2B2D2B2B2D6D706D
        6C2D2B2D2B2D2B2D2B6C6A6C2B2B2B2B2B2B2B2B2B2B2B6A2B2B6A692B2A2B69
        2A2A692A2A2A2A2A2A2A692B2B2A2A2627272727272727272767672727272727
        2727272727272727276767272727272727272727676767272727276767676727
        2727272727272727272727272727276767272727676727272727272727676767
        00002A2A2A2A2B2A6A2B2B2B2B6A6A6A2D2B2D2B6C6C2B2D2D2D2D2D2D2D2D2D
        2D2D2D2D6C6C2D6C6C6C6C2D2D2D2D2D2D2D2D2D2D6C6C2D2B2D2B2B2B6C6D75
        702B2D2B6C2B2D2B2B2D2B2D2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2A2B2A2B2A
        2A2A2A2A2A2A2A2A2A2A2A2D2B67672727272767672727276767272727672727
        2767676727276767272727272727272727272767272767672727272767672727
        2727272727272767672727676767272727276767276767272767272767272727
        00002A2A2A2A2B2A6A2B2B2B2B2B6A6A2D2B2D2B6C6C6A6C2D2D2D2D2D2D6C2D
        2D2D2D2D6C6C6C6C6C6C6C2D6C6C2D2D2D2D2D2D2D6C6C2B2D2D2B2B6A296D77
        75282D2D6A6C6A2B2B2D2B2D2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2A2B2A2B2A
        69692A2A2A2A2A692A2A2B2B2B67672727272767672727276767272727672727
        2767676727276767272727676727272727676767272767672727272767672727
        2727272727272767672767676767272727276767276767272767272767272727
        00002A2A2A2B2A2B2B2B2B6A6A2B2D2B2D2B2D2B2D2D6A6C2D6C6C2D6C6C6C2D
        2D2D2D2D2D2D6C6C6C2D2D6C6C6C6C2D2D6C6C2D2D2D2D2D2B2D2B2B6A2B6B76
        762D292D2B6C6A2B2B2D2B2D2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2A2B2A2B2A
        69692A69692A2A692A2A2D2A2A26272727272727272727272727272727272727
        2767672727276767272727676727272727676727676767272727272767672767
        6727276767676727272767672727272727672727272727272727272727272727
        00002A696A2A2B2A2B2B2B6A6A6A2B2B2D2B2D2D2B2D2D2B2D6C6C2D2D2D2D2D
        2D6C6C2D2D2D2D6C6C2D2D2D2D2D2D2D2D6C6C2D2D2D2D6A6C2B2B2B2B2B6A6E
        706F6C2B2D2B2B2D2B6C6A6C2B2B2B2B6A6A2B2B2B2B2B2B6A6A2A2B2A6A692A
        2A2A2A69692A2A2A2B2B2B2A2627272767672727272727272727272727272727
        6727272727272727272727272727272727272727272767272767672767672767
        6727276767676767672727276767276767672727272727272727272727676727
        00002A696A2A2B2A2B2B2B6A6A6A2B2B2D2B2D2D2B2D2D2B2D6C6C2D2D2D2D2D
        2D6C6C2D2D2D2D6C6C2D2D2D2D2D2D2D2D6C6C2D2D2D2D6A6C2B2B2B2B2B2B2C
        70766F292B2B2B2D2B6C6A6C2B2B2B2B6A6A2B2B2B2B2B2B6A6A2A2B2A6A692A
        2A2A2A69692A2A2A2B2B2A2A2627272767672727272727272727272727272727
        6727272727272727272727272727272727272727272767272767672767672767
        6727276767676767672727276767276767672727272727272727272727676727
        00002A2A2B2A2B2A6A2B2B6A6A2B6A6A6C2B2D6C6C2D2B2D2D2D2D2D6C6C2D6C
        6C2D2D2D2D2D2D2D2D6C6C2D2D2D2D2D2D2D2D2D2D2D2B2D2B2B6A6A6A2B2B29
        75986F296C2B2B2D2B2D6A6A6A2B2B2B2B2B2B2B2B6A6A2B2B2A2B696A696A2A
        2A2A2A2A2A2A2A696A6A26272727272727272727272727272767672727272727
        6767672727272727672727276767676767272727272767672727272727276727
        2767672727272727272727272727272727272727272727272727272727676727
        00006969692B2B2B2A2B2B6A6A2B2B2B2D6A6C6A2D2D2D2D2B2D2D2D2D2D2D6C
        6C6C6C2D6C6C2D2D2D2D2D2D2D2D2D6C6C2B2D2D6C6C6A2D2B2B2B2B2B2B2B29
        75986D292B2B2B2B2D2B2B2B2B2B2B2B6A6A6A6A6A2B2B2B2B2A6A696A2A2B2A
        2A2A692A2A2A2A2B2B6727276727272767672767672727272767672727276767
        2727272727272727272727276767272727272727272767672727272767672727
        2727272727276727272727276767276767672727272727272727272767272767
        00006969692B2B2B2A2B2B6A6A2B2B2B2D6A6C6A2D2D2D2D2B2D2D2D2D2D2D6C
        6C6C6C2D6C6C2D2D2D2D2D2D2D2D2D6C6C2B2D2D6C6C6A2D2B2B2B2B2B2B2B2B
        6D75706D2B2B2B2B2D2B2B2B2B2B2B2B6A6A6A6A6A2B2B2B2B2A6A696A2A2B2A
        2A2A692A2A2A2B2D672A26676727272767672767672727272767672727276767
        2727272727272727272727276767272727272727272767672727272767672727
        2727272727276727272727276767276767672727272727272727272767272767
        00002A2A2A2B2A2B2B2B2B2B6A6A2B2B2D2B2D2B2D2D2D2D6A6C6C6C2D2D2D6C
        6C6C6C2D2D2D2D2D2D2D6C6C2D2D2D2D2D2D2D2D2B2D2D2B2D2B6A6A2B2B2B2B
        2D6C75756C2B6A6C6A2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2A2B2A2B69692A
        2A2A2A69692B2B2B272727272727272727272727276727276727276767272727
        2727272727272727272727272727276767272727676727272727272727276727
        2727276767672727276767272727272727676767272767676727272727676727
        00002A2A2A2B696A2B2B2B2B6A6A2B2B2D2B2D2B2D2D2D6C6A6C6C6C2D2D2D6C
        6C2D2D2D2D2D2D2D2D2D6C6C2D2D2D6C6C2D2D2B2D2D2B2D2B2B6A6A2B6A6A2B
        292D76756C2B6A6C6A6A2B2B6A2B2B2B2B2B6A6A2B2B2B6A696A2A2A2A69692A
        2A2A2A69692D2A27676727272767676727272727276727276727276767276767
        2767672727272727272727272727276767272767272727676727272727272727
        2727276767676727272767272727272727276767676767272767272727676727
        00002A2A2A2B696A2B2B2B2B6A6A2B2B2D2B2D2B2D2D2B6C6C2D2D2D2D2D2D6C
        6C2D2D2D2D2D2D2D2D2D2D2D2D2D2D6C6C2D2D2B2D2D2B2D2B2B2B2B2B6A6A2B
        2B2B75752D2D2B2B6A6A2B2B6A2B2B2B2B2B6A6A2B2B2B6A696A2A2A2A2A2A2A
        2A2A692A2B2B2A27676727272767676767672727272727276767272727276767
        2767672727272727272727272727276767272767272727676727272727272727
        2727272727276727272727272727272727272727676727272767272727272727
        00002A2A2A2A2B2A6A6A6A6A6A2B2B2D2B6C6A2D2B2D2D2B2D2D2B2D2D2D2D6C
        6C2D2D6C6C6C6C6C6C6C2D2D6C6C2D2D2B6C6C6A2D2D2B6A6A2B2B2B2B2B2B2B
        2B6A6D6D2C2D2D2B2B2B2B2B6A2B2B2B2B2B2B6A6A2B2B2B2A2B2A2A2A2A2A2A
        2A2A692B2B2A2727676727272767676767672727272727276767272727272727
        6727276767672727272727676767272727272767676767272767672727276727
        2767672727272727276727276767272727272727272727676727272727272727
        00002A2A2A2A2B2A6A6A6A6A6A2B2B2D2B6C6A2D2B2D2D2B2D2D2B2D2D2D2D6C
        6C2D2D6C6C6C6C6C6C6C2D2D6C6C2D2D2B6C6C6A2D2D2B6A6A2B2B2B2B2B2B2B
        2B692D6C6D6C2D2D2B2B2B2B6A2B2B2B2B2B2B6A6A2B2B2B2A2B2A2A2A2A2A2A
        2A2A692D2A272627676727272767676767672727272727276767272727272727
        6727276767672727272727676767272727272767676767272767672727276727
        2767672727272727276727276767272727272727272727676727272727272727
        00002A2A2A2A6A696A2B2B2B2B2B2B2B2B6C6A2D2B2D2D2B2D2D2D6C2D2D2D2D
        2D2D2D2D2D2D2D6C6C2D2D2D6C6C6C2D2D2D6C6C2B2D2B2B2B2B2B2B2B2B2B6A
        6A2A2B6D756D2D2D2B2B2B2B6A2B2B2B2B2B2B6A6A2B2A6A2A2B2A2A2A2A2A2A
        2A2A2B2B2A686727272727272727272727272727272727272727272727672727
        2727272727272727272727272727272727272727272767672727272727276727
        2727272727272727272727272727272727272727276767272727676727272727
        00002A2A2A2B2A2B2B2B2B2B2B2B2B2B2D2B2D2B2D2D2B2D2D2D2D2D2D2D6C6C
        2D2D2D2D2D2D6C2D2D2D2D2D2D2D6C2D2D2B2D2D2B6C6A2B2B2B2B2B2B6A6A6A
        6A2B286F766E292D2D2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2A2B2A2A2A2A2A2A
        2A2B2B2B26272727272727272727272767676727272767676727272727276767
        6727272727272727672727676727272727676727272727272727276727272727
        2727272767672727276767676727276767276767272727676727272727272727
        00002A2A2A2B2A2B2B2B2B2B2B2B2B2B2D2B2D2B2D2D2B2D2D2D2D2D2D2D6C6C
        2D2D2D2D2D2D6C2D2D2D2D2D2D2D6C2D2D2B2D2D2B6C6A2B2B2B2B2B2B6A6A6A
        6A2B2B6B756E2D2D2D2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B2A2B2A2A2A2A2A2A
        2B2B2B6726272727272727272727272727676727272767676727272727276767
        6727272727272727672727676727272727676727272727272727276727272727
        2727272767672727276767676727276767276767272727676727272727272727
        00002A2A2A2B2A2B2B2B2B2B2B2B2B2B2D2B2D2B2D2D2B2D2D2D2D2D2D2D2D6C
        6C6C6C2D6C6C2D6C6C2D2D2D2D2D2D2B2D2D2B2D2D2B2D2B2B2B2B2B2B2B2B2B
        2B2B2B2B6C6C6C2D2D6C2B2B6A6A6A2B2B2B2B2B2B2B2A6A2A2B692A2A69692B
        2D2B262627272727272767272727272727272727272727276767676767272727
        2727272727276767272727676767272727272727676727676727276727276727
        2767672767676727276767272767672727272727276767272767272727272767
        00002A2A2A2B696A6A6A6A2B2B2B2B2B2B2D2B2D2B2D2B2D2B2D2D2D2D2D6C2D
        2D6C6C2D2D2D6C2D2D2D2D6C6C6C2D6C6A2D6C6A2D2B6A2B2B2B2B2B2B2B2B2B
        2B2B6A2B2D6D706C2B2D2B2B2B2B2B2B2B2B2B6A6A2B2A6A2A2B2A2A2A2A2A2B
        2B2B672627676727272727272727272767672727272727272727276767672727
        2727272727272727272727676727272727676727676727676727272727272727
        2767676767672767676727272727272727276767272727676727272767272767
        00002A2A2A2B696A6A6A6A2B2B2B2B2B2B2D2B2D2B2D2B2D2B2D2D2D2D2D6C2D
        2D6C6C2D2D2D6C2D2D2D2D6C6C6C2D6C6A2D6C6A2D2B6A2B2B2B2B2B2B2B2B2B
        2B2B6A2B2B6F706C2B2D2D2B2B2B2B2B2B2B2B6A6A2B2A6A2A2B2A2A2A2A2B2D
        2A2A672727676727272727272727272767672727272727272727276767672727
        2727272727272727272727676727272727676727676727676727272727272727
        2767676767672767676727272727272727276767272727676727272767272767
        00002A6A692B2A2B2B2B2B2B2B2B2B2B2D2B2D2B2D2B2D2B2D6C6C6C2D2D2D6C
        6C2D2D2D2D2D2D2D2D2D2D2D6C6A2D6C6A2D2B2D2B2D2B2B2B6A2B2B2B6A6A2B
        2B2B2B2B2A6C6C2D2D2B2D2D6A2B2B2B2B2B2B6A6A2B2A2B2A2B2A69692B2B2B
        6967272727676727272727272727272727676727272767672727272727272727
        2727272727276767272727272727272727272767676727272727272727276727
        2727272767672727272767676727276767276767272727676767272767676727
        00002A6A692B2A2B2B2B2B2B2B2B2B2B2D2B2D2B2D2B2D2B2D6C6C6C2D2D2D6C
        6C2D2D2D2D2D2D2D2D2D2D2D6C6A2D2D2B6C2B2D2B2D2B2B2B6A2B2B6A6A6A2B
        2B2B2B2B2A2B2D2D2D2B2D2D6C2A2B6A2B2B2B6A6A2B2A2B2A2B2A696A2B2B69
        6767272727676767272727676767272727676727272767672727272727272727
        2727272767676767272727272767672727272767676727272727272727276727
        2727272767672727272767676727276767676767676727676767272727676727
        00002A2B2A2B2A2B2B6A6A2B2B2B2B2B2D2B2D2B2D2B2D2D2B2D2D2B2D2D2D2D
        2D2D2D2D2D2D2D2D2D2D2D2B6C6C2B2D2D6A6C6A2B2B2B2B2B2B2B2B6A6A2B2B
        2B2B2B2A2B2B2D6D2D6C2D2D2B2B2B6A6A2B2B2B2B2A2B2A2A2A2A696A2D2A67
        6767276767272767272727676767272767672727272767672727272727672727
        2727272767672727272727276767672727676727272727272727272727272727
        2727272727276727272727272727272727672727676727272727272727272767
        0000692B2A2B2A2B2B2B2B2B2B2B2B2B6A2D2B2D2B2D2D2B2D2D2B6C2D2B2D2D
        2D2D2D2D2D2D6C2D2D2D2D2B2D2D2B6C6A2D2B2D2B6A6A2B2B6A6A6A2B6A6A2B
        2B2B2B2A2B2B6B706E2B2D6A2D6C692B6A6A2B2B2B2A2B2A69692A6A6C2A2A27
        6767276767272727676727272727272727276767672767672727272727272727
        6727272727272727272727272727276767272767272727272727272767672727
        2767676727276727276767272767672727272727272727272727272767272727
        0000692B2A2B2A2B2B2B2B2B2B2B2B2B6A2D2B2D2B2D2D2B2D2D2B6C2D2B2D2D
        2D2D2D2D2D2D6C2D2D2D2D2B2D2D2B6C6A2D2B2D2B6A6A2B2B6A6A6A2B6A6A2B
        2B2B2B2A2B2B6A706E2D2B6C2B6C6A2B6A6A2B2B2B2A2B2A69692B6A6A2A2727
        6767276767272727676727272727272727276767672767672727272727272727
        6727272727272727272727272727276767272767272727272727272767672727
        2767676727276727276767272767672727272727272727272727272767272727
        00002A2B2A2B2A2B2B2B2B2B2B2B6A6A2B2D2B2D6C6A2D2D2B6C6C2B2D2D2D6C
        6C2D2D2D6C6C2B2D2D2B2D6C6A6C2B6C6A2D6A6A2B2B2B2B2B6A2B2B6A6A2B2B
        2B2B2B2A6A2B6A6C6C6C6C6A6A6C6A6A2B2B2B2A2B2A2B2A2A2B2B2B2A272727
        6767676767272767272767676727272727272727276727272727272727272727
        2767676767676767272727272727272727272727272727272727276727276767
        6727272727272727272727272727272727272727276767272727272767272767
        00002A2B2A6A2A2B2B6A6A2B2B2B6A6A6C2B2D2B6C6A2D2D2B2D2D2B2D2D2D2B
        2D2D2D2D2D2D2D2B2D2D2B2D2B2D6A2D2B2D2B2B2B2B2B2B2B2B2B2B2B6A6A2B
        2B2A2B2A2B692B2B70756B296A2D2B6A6A6A2A2B696A692A2A2B2D2B26272767
        2727672727272727272727272727272727272727276727276727276767276767
        2767672727276767276767276767272727272727272727272767672767676727
        2727272767672727272767672727272727276767676767272727676727676767
        00002A2B2A6A2A2B2B6A6A2B2B2B6A6A6C2B2D2B6C6A2D2D2B2D2D2B2D2D2D2B
        2D2D2D2D2D2D2D2B2D2D2B2D2B2D6A2D2B2D2B2B2B2B2B2B2B2B2B2B2B6A6A2B
        2B2A2B2A2B692B2A6F756D296A2D2B6C6A692B2A6A69692A2B2B2B2A26272767
        2727672727272727272727272727272727272727276727276727276767276767
        2767672727276767276767276767272727272727272727272767672767676727
        2727272767672727272767672727272727276767676767272727676727676767
        0000696A696A2A2B2B2B2B2B2B2B2B2B2D6A6C2B2D2D2B2D2D6A6C2D2B2D2D2B
        2D2D2D2D2D2D2D6A6C2D2B2D2B2D2B2D2B2D2B2B2B2B2B2B2B2B6A6A2B6A6A2B
        2B2B2A2B2A2B2A2B6A6C2D2D2B2B2D2B2D2A2B2A2B2A2A6A6A6A272627272727
        2727276767272767272727272727272727272767676767672727276767272727
        2727276767272727272727272727676727272727272727272767672727276767
        6767676727276767676727276767676767272727276767272727272727272767
        0000696A692B2A2B2B2B2B2B2B2B2B2B2D6A6C2B2D2D2B2D2D6A6C6C2B2D6C2B
        2D6C6A6C2D2B2D6C6A2D2B2D2B2D2B2D2B2B2B2B2B2B2B6A6A2B6A6A6A2B2B6A
        6A6A2A2B2A2B2A2A2B2D6E6D2B2B2B2D2B2B2B2A2B2A2B6C6A69676727272727
        2727272727272767272727676727272727272767676767672727272727272727
        2727276767272727272727276767676767272727272727272767672767672727
        2767676727276767676727272727272727272727272727272767272727272727
        00002A2B2A2B2A2B2B2B2B2B2B2B6A6A2D2B2D2B2D2D2B2D2D6A6C6C2B2D6C2B
        2D6C6A6C2D2B2D2D2D2B2B2D2B2D6A2D2B2B2B2B2B2B2B6A6A2B2B2B6A2B2B6A
        6A6A2A2B2A2B2A2A2B6A70702B2B2B2D2B2D2A2B2A2B2B2D2A67276727272727
        2727272727272727272727676727272727272767676727272727272727272727
        2727276767272727272727276767272767272727272727272767672767672727
        2727272727272727272727272727272727272727272727272767272727272727
        00002A2B2A6A2B2B2B2B2B2B2B6A6A6A2B2D2B2D2D2D2D2B2D2D2B2D2D2B6C6C
        2B2D2D2B2D2D2B2D2D6A6C6A2D2B6C2B2D2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B
        2B2B2A2B2A2B2A2B2A6A6C6C2D2B2B6A6C2B2B2B2A2B2D2B2A26272727272727
        2727276767272727272767272727272727276767672727272727272727272727
        2727272727272727272727272727272727272767272727272727276727272767
        6727272767672727272727276767676767272727272727272727272727272727
        00002A6A696A2B2B2B2B2B6A2B6A6A6A2B2D2B2D2D2D2B2D2B2D2D2B2D2D6A6C
        2D2B2D2D2B2D2D2D2B6C6A6C2B2D6A2D2B2B2B2B6A6A2B2B2B2B2B2B2B6A6A2B
        2B2B2A2B2A2B2A2B2A2B2B2D2D2D2B6A6C2B2B6A6A2B2B2A6926272727272727
        2727676767276767272767272727272727276727272727272727272727272727
        2727272727272727272727272727272727272767272727272727276727276767
        6767272767672727272727276767676767272727272727272727272767272727
        00002A6A696A2B2B2B2B2B6A6A2B2B2B2B6C6A6C2D2B6C6A2D2B2D6C2B2D6C6A
        2D2D2B2D2D2B6C2D2B2D2B2D2B2D2B2B2B2B2B2B6A6A2B2B2B2B2B2B2B6A6A2B
        2B2B2A2B2A6A692B2A2A2B2D2D2D2B6A6A2B2B6A6A2D2A266767276767272727
        6767672727276767272727272727272727272727272727272727272727272727
        2727276767272727272727272727272727272727272727272767672767676727
        2767676727272727272727272767672727272727272727272727272767272727
        00002B2A2B692B2B2B2B2B2B6A6A2B2B2D6A6C6A2D2B6C6A2D2B2D2B2D2D2B2D
        2D2B2D6A6C6A6C2B2D2B2D2B2D2B2D2B2B2B2B2B2B2B2B6A6A2B6A6A6A2B2A2B
        2A2B696A2A6A692B2A692A2D2D2D2B6A6A2B2B6C6C6A26272727276767272727
        6767276767272727676727272727272727272767672727276727276767672727
        6767672727672727672727676727272727272727272767672727276727272727
        2727676727272727276767272767672727676767272727272727272727272767
        00002B2A2B692B2B2B2B2B2B6A6A2B2B2D6A6C6A2D2B6C6A2D2B2D2B2D2D2B2D
        2D2B2D6A6C6A6C2B2D2B2D2B2B2D2B2B2B2B2B2B2B2B2B6A6A2B6A6A6A2B2A2B
        2A2B696A2A6A692B2A692A2B2D2D2B6A6A2B2D6C6C6926272727276767272727
        6767276767272727676727272727272727272767672727276727276767672727
        6767672727672727672727676727272727272727272767672727276727272727
        2727676727272727276767272767672727676767272727272727272727272767
        00002B696A2A2B2B2B2B2B2B2B2B2B2B2B2D2B2D2B2D6A6C2B2D2B2D2B2D2D2B
        2D6C6C2B2D2B2D2B2D2B2B2D2B2B6C2B2B2B2B2B6A6A2B2B2B2B6A6A2B6A692B
        2A2B2A2B2A2B2A2A2A2A2A2A2B2D2D2B2B2B2D2D6A6867276767272727676727
        2727272727676767272727272767672727272727272727272727276767272727
        2727276767672727272727676767272767676767272727272727272727272767
        6727272727276727272727272727272727272727272727676727272767272727
        00002B2A2B2A6A6A2B2B2B2B2B2B6A6A6A2D2B2D6A6C2B2D6A2D2B2D6A6C2B2D
        2B2D2B2D2B2D2B2D2B2B2D2B6C6A2B2B2B2B2B2B6A6A2B2B2B6A2B2B2B6A692B
        2A6A2A2B2A2B2A2B2A2A2A2A2B2D2D2B2B2D2D2B2A2727272727276767272727
        2727276767272727272727272767676767672727272727272727276767272727
        2727272727276767672727272727276767272727272767676727276727272767
        6767672727276727272727272727272727676767272727676767272727272727
        00002B2A2B2A6A6A2B2B2B2B2B2B6A6A6A2D2B2D6A6C2B2D6A2D2B2D6A6C2B2D
        2B2D2B2D2B2D2B2D2B2B2D2B6C6A2B2B2B2B2B2B6A6A2B2B2B6A2B2B2B6A692B
        2A6A2A2B2A2B2A2B2A2A2A2A2A2D6C6A6C2D2B2A2A2727272727276767272727
        2727276767272727272727272767676767672727272727272727276767272727
        2727272727276767672727272727276767272727272767676727276727272767
        6767672727276727272727272727272727676767272727676767272727272727
        00002B696A692B2B2B2B2B2B2B2B6A6A2B6C6A2D2B2D6A6C2B2D2B2D2B2D6A6C
        6A2D2B2D2B2D6A2D2B2D6A6C2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B6A2B2A6A
        69692B2A2B2A2B69692A2A2A692B6B706D2D2A69676967672727272727676727
        2727672727676727676727272727272727276767676727272727276767276767
        2727272727676767676767272727676727272727272767676727272727272727
        2767672767672767672727272727272727672727272727272727272727272727
        00006A2A2B6A2B2B2B2B2B2B2B2B2B2B6A6A6C2B2D2B6C6A2D2B2D2B2D2B2D2B
        6C6A6C2B2D2B6C2B2D2B6C6A2B2B2B2B2B2B2B2B2B2B6A2B2B2B2B2B6A692B69
        6A2A2B2A6A696969692A696969286D76752828672A6767272727272727676727
        2727672727672727676727272727272727276767676767672727276767676767
        2727272727276767276767272727276767272727272727272727272767672727
        2727272767672767672727276767272727272727276767272727676727272727
        00006A2A2B2B2B2B2B2B2B2B2B2B2B2B6A2B2B2D2B2D2B2D2B2D2B2D2B2D2B2D
        2D6A6C2B2D2B2D2B2D2B6C6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B6A692B2A
        2B2A2B2A6A69692A2A2A69692A286F766F2A2A2A676767272727272727272727
        2727672727272727272727272727272727272767676767672727276767676767
        2727272727276767276767272727276767272727272727272727276767672727
        2727272767672727272727276767272727276767276767272727676727272727
        00006A696A2B2B2B2B2B2B2B2B2B2B2B2B2B2B6A6C6A2D2B2D2B2D2B2D2B6C6A
        2D2B2D2B6C6A2D2B2B2D2B2B2B2B6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2A2B2A
        2B2A2B2A2A2A2A2A2A2A2A2A2A2B6C6F6A2A68682A2627692727676727272727
        2727272727276767272727272767676727272727272767672727272727272727
        6767672727672727672727272727676727272727272727686727276827272727
        2727272727272727276767272727272727676767272727272727272727676727
        00006A696A2B2B2B2B2B2B2B2B2B2B2B2B2B2B6A6C6A2D2B2D2B2D2B2D2B6C6A
        2D2B2D2B6C6A2D2B2B2D2B2B2B2B6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2A2B2A
        2B2A2B2A2A2A2A2A2A2A2A2A2B2B2B282A2B68672A2627692727676727272727
        2727272727276767272727272767676727272727272767672727272727272727
        6767672727672727672727272727676727272727272727686727276827272727
        2727272727272727276767272727272727676767272727272727272727676727
        00002B2A2B2B6A6A2B2B2B2B2B2B6A6A2B6C6A2D6A6A2D2B6C6A6C2B2D2B6C6A
        2D2B2D6A2D2B2D2B2B2B2B2B2B2B6A2B2B2B6A6A6A6A2B2B2B2B2B2A2B2A2B2A
        2B2A69692A2A2A2A2A2A2A2B6C6969272B2B6867272727272727272727272727
        2727276767272727272727272727676727272767672727276767272727272727
        2727272727272727272727276767272727272727676767272727272727272767
        6767672727272727272727272727676767672727272727272767272727272767
        00002B2A2B2B6A6A6A2B2B2B2B2B2B2B2B2B2B6C6A6A6C6A6C2B2D2B6C6A2D6A
        6C2B2D2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B6A6A2B2B2A2B2A2B2A2B2A2B
        2A2B2A2A2A2A2A2A2A2A6A6A2B2A2727696A6967272727676767272727272727
        2727672727272767676767272727272727272767672727272727272727676767
        2727272727272727272727676767272727272727676727276767672767672727
        2767672727272727272727272727276767676767272727272727676767272727
        00002B2A2B2B6A6A6A2B2B2B2B2B2B2B2B2B2B6C6A6A6C6A6C2B2D2B6C6A2D6A
        6C2B2D2B2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B6A6A2B2B2A2B2A2B2A2B2A2B
        2A2B2A2A2A2A2A2A2A2A6A6A2A27262769696969272727676767272727272727
        2727672727272767676767272727272727272767672727272727272727676767
        2727272727272727272727676767272727272727676727276767672767672727
        2767672727272727272727272727276767676767272727272727676767272727
        00002B2A2B2B6A6A2B2B2B2B2B2B2B2B2B2B2B2B6A6A6C6A6C2D2B2D2B2D2B2D
        2B2D2B6C6A6A6A2B2B2B2B2B2B2B2B6A6A6A2B2B6A6A2B2B2B2B2A2B2A2B2A2B
        2A6969692A2A2A2A2B2B2D2A2727272767682B2B672727272727272727272767
        2727672727272767676727272767672727272727272727276767272727272727
        2767672727272727272727676767676727272727272727272727272727272727
        2727272767672727272727276767276767276767272727272767676727676727
        00002B2A2B2B2B2B2B2B2B6A6A2B2B2B6A6A6A2B2B2B2D2B2D2B2D2B2B2B2D2B
        2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B6A6A6A6A6A2B2B2A2B696A2A69692A
        2A2A2A2A692A2A2A2B2D2A272727276767676A692A2727672727272727272727
        2727272727272727272767272727272727272727272727272727276767272727
        2727272767672727272727276767272727272727272767676727272727272727
        2767672727276767672727272727676767672727272727676727272727272727
        00002B2A2B2B2B2B2B2B2B6A6A2B2B2B6A6A6A2B2B2B2D2B2B2D2B2D2B2B2D2B
        2B2B2B2B2B2B2B2B2B6A6A2B2B2B2B2B2B6A6A6A6A6A2B2B2A2B696A2A69692A
        2A2A2A2A692A2A2B2B2B2726272727676767696A2A2727672727272727272727
        2727272727272727272767272727272727272727272727272727276767272727
        2727272767672727272727276767272727272727272767676727272727272727
        2767672727276767672727272727676767672727272727676727272727272727
        00002B2A2B2B2B2B2B2B2B6A6A2B2B2B6A2B2B2B2B2B6A6A2B2D2B2B2B2B2B6A
        6A6A6A2B2B2B6A6A6A2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2A2B2A2B2A69692A
        2A2A2A2A692A2B2D2B696767272727276767672A2B6967272727272727272767
        2727272727276767272727272767672727272727276727272727276767676767
        2727272727272727672727276767676727272727676727272727272727272727
        2727272727272727272727276767672727276767272727272727272727272727
        00002B2A2B6A2B2B6A2B2B6A6A2B2B2B2B2B2B6A6A6A6A6A2B6C6A6A6A6A2B6A
        6A6A6A6A2B2B6A6A6A2B2B2B6A6A2B2B2B2B2B2B2B2B2B2B2A2B2A2B2A69692A
        2A2A2A2A696A6A2D2A676767272727276767672A2B6967276767272727272767
        2727272727276767272727272767672727272767676727272767672727676767
        6727272727272727672727276767676727272727676727272727272727276727
        2727272727272727272727276767672727276767272727272727272727272727
        00002B2A2B6A2B2B6A2B2B2B2B2B2B2B2B2B2B6A6A6A2B2B2B6A6A6A6A6A2B2B
        2B2B2B6A2B2B2B6A6A6A6A2B2B2B2B2B2B2B2B2B2B2B2B2A2B2A2B2A2A2A2A2A
        2A2A69692A6A6C2A2767272727272767272767682A2A2A266767272727272727
        2727272727272767676767272727272727272767672727272767672727672727
        6727272727272727272727272727272727676727272727272727272727276727
        2727272727272727276727276767676767672727272727272727272727272727
        00006A2A2B2B2B2B2B2B2B2B2B2B2B2B6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B
        2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B6A6A2B2B6A6A2B2B696A2A2B2A2A2A2A2A
        2A2A69692B2B2B69682767676767672727272727272A2A672727676727272767
        2727272727676727676727272727272727272727272767672727276767272727
        2727272727272727676767672727676727676727272727272727276727272767
        6727272767672727276767272727272727272727272727272767272727272727
        00006A2A2B2B2B2B2B2B2B2B2B2B2B2B6A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B
        2B2B2B2B2B2B2B2B2B2B6A6A2B2B2B6A6A2B2B6A6A2B2B696A2A2B2A2A2A2A2A
        2A2A696A2B2B2A67672767676767672727272727272A2A682727676727272767
        2727272727676727676727272727272727272727272767672727276767272727
        2727272727272727676767672727676727676727272727272727276727272767
        6727272767672727276767272727272727272727272727272767272727272727
        00006A2A2B2A6A6A6A2B2B2B2B2B2B2B6A6A6A2B2B2B2B2B2B2B2B2B2B2B2B6A
        6A6A6A2B2B2B6A6A6A2B2B2B6A6A2B2B2B2B2B2B2B2A2B2A2B2A2A2A2A69692A
        2A2A6A6A2B2A2627272727272727272727272727272A2A2A2727272727676767
        2727272727272727272727272727272727272767676727272767672727272727
        2727276767676767276767272727272727686827676727272767672727276767
        6767672727272727272767672727272727272727272727272727272727676727
        00002B2A2B2A6A6A6A6A6A2B2B6A2B2B2B6A6A2B2B6A6A6A6A2B2B2B2B2B2B2B
        2B2B2B2B2B2B6A6A6A2B2B2B2B2B2B2B2B6A6A2B2B2A2B2A2B2A2A2A2A2A2A2A
        2A692B2B2A27262727276767272727272727676727272A2B2727272727272727
        6767272727272727676727272727272727272727272767676727272727272727
        2767672727276767276767276767272767272727272767672727272767672727
        2767676727272727272727272727272727272727272727272767272767272727
        00002B2A2B2A6A6A6A6A6A2B2B6A2B2B2B6A6A2B2B6A6A6A6A2B2B2B2B2B2B2B
        2B2B2B2B2B2B6A6A6A2B2B2B2B2B2B2B2B6A6A2B2B2A2B2A2B2A2A2A2A2A2A2A
        2B6A2B2A262727272727676727272727272767672727272A2A27272727272727
        6767272727272727676727272727272727272727272767676727272727272727
        2767672727276767276767276767272767272727272767672727272767672727
        2767676727272727272727272727272727272727272727272767272767272727
        0000}
    end
    object lblVersion: TLabel
      Left = 137
      Top = 364
      Width = 48
      Height = 14
      Alignment = taRightJustify
      Caption = 'v6.00.000'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Rich Text Files (*.RTF)|*.RTF|Text Files (*.TXT)|*.TXT'
    Left = 32
    Top = 4
  end
  object SaveDialog: TSaveDialog
    Filter = 'Rich Text Files (*.RTF)|*.RTF|Text Files (*.TXT)|*.TXT'
    Left = 60
    Top = 4
  end
  object PrintDialog: TPrintDialog
    Left = 88
    Top = 4
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 4
    Top = 4
  end
end
