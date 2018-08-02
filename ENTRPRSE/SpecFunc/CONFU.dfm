inherited ConfigForm: TConfigForm
  Tag = 100
  Left = 389
  Top = 118
  HelpContext = 2
  Caption = 'Configure Compass'
  ClientHeight = 291
  ClientWidth = 418
  PixelsPerInch = 96
  TextHeight = 13
  object Label86: Label8 [0]
    Left = 16
    Top = 161
    Width = 189
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Exchequer Directory Path : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  inherited PageControl1: TPageControl
    Width = 418
    Height = 291
    OnChange = PageControl1Change
    inherited TabSheet1: TTabSheet
      HelpContext = 2
      Caption = 'General'
      inherited SBSPanel4: TSBSBackGroup
        Width = 406
        Height = 231
      end
      object Label81: Label8
        Left = 24
        Top = 49
        Width = 181
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Type of Exchequer Connection : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label83: Label8
        Left = 59
        Top = 78
        Width = 146
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Server Operating System : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label84: Label8
        Left = 16
        Top = 132
        Width = 189
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'This Workstation Operating System : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label87: Label8
        Left = 16
        Top = 160
        Width = 189
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'This Workstation Number : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label814: Label8
        Left = 16
        Top = 108
        Width = 189
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Novell Client Server - Ethernet : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label815: Label8
        Left = 248
        Top = 108
        Width = 75
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Token Ring : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label82: Label8
        Left = 32
        Top = 21
        Width = 173
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Exchequer Directory Path : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object MUType: TSBSComboBox
        Left = 210
        Top = 45
        Width = 145
        Height = 22
        HelpContext = 7
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 2
        OnChange = MUTypeExit
        Items.Strings = (
          'Multi User'
          'Client Server'
          'Single User')
        MaxListWidth = 0
      end
      object SERVOS: TSBSComboBox
        Left = 210
        Top = 75
        Width = 145
        Height = 22
        HelpContext = 8
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 3
        OnChange = SERVOSExit
        Items.Strings = (
          'NT 3.51'
          'NT 4.x'
          'Windows (NT) 2000'
          'Novell 3.x'
          'Novell 4.x'
          'Windows 95'
          'Windows 98'
          'Citrix NT 3.51/4.x/5.x'
          'Citrix Novell')
        MaxListWidth = 0
      end
      object WSOS: TSBSComboBox
        Left = 210
        Top = 129
        Width = 145
        Height = 22
        HelpContext = 9
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 6
        OnChange = WSOSExit
        Items.Strings = (
          'NT 3.51'
          'NT 4.x'
          'Windows (NT) 2000'
          'Novell 3.x'
          'Novell 4.x'
          'Windows 95'
          'Windows 98')
        MaxListWidth = 0
      end
      object WKNo: TCurrencyEdit
        Left = 210
        Top = 157
        Width = 80
        Height = 22
        HelpContext = 10
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'ARIAL'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        ParentFont = False
        TabOrder = 7
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object NEChk: TBorRadio
        Left = 208
        Top = 104
        Width = 16
        Height = 20
        Checked = True
        GroupIndex = 1
        TabOrder = 4
        TabStop = True
        TextId = 0
      end
      object NTChk: TBorRadio
        Left = 324
        Top = 104
        Width = 15
        Height = 20
        GroupIndex = 1
        TabOrder = 5
        TextId = 0
      end
      object ThisSrvChk: TBorCheck
        Left = 34
        Top = 182
        Width = 190
        Height = 20
        Caption = 'This is the NT Server (NT only) :  '
        Color = clBtnFace
        ParentColor = False
        TabOrder = 8
        TextId = 0
        OnClick = ThisSrvChkClick
      end
      object ExPath: Text8Pt
        Left = 210
        Top = 18
        Width = 121
        Height = 22
        HelpContext = 6
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = BrowseBtn2Click
        TextId = 0
        ViaSBtn = False
      end
      object BrowseBtn2: TButton
        Left = 336
        Top = 18
        Width = 71
        Height = 21
        HelpContext = 6
        Caption = '&Browse'
        TabOrder = 1
        OnClick = BrowseBtn2Click
      end
    end
    inherited TabSheet2: TTabSheet
      HelpContext = 3
      Caption = 'Network'
      object SBSBackGroup1: TSBSBackGroup
        Left = 5
        Top = 2
        Width = 406
        Height = 231
        TextId = 0
      end
      object Label85: Label8
        Left = 11
        Top = 26
        Width = 189
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Novell Server System Path : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label89: Label8
        Left = 11
        Top = 76
        Width = 189
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'NT Network adaptor name -NT only : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label810: Label8
        Left = 11
        Top = 102
        Width = 189
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'NT IPX Maximum Packet Size -NT only : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label811: Label8
        Left = 11
        Top = 127
        Width = 189
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'NT Virtual Machine No. -NT only : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label812: Label8
        Left = 11
        Top = 155
        Width = 332
        Height = 14
        Alignment = taCenter
        AutoSize = False
        Caption = 'You many need to also set the Frame Type via the Registry.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object Label813: Label8
        Left = 11
        Top = 51
        Width = 189
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Novell BSPXCOM Time Out : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SRVPath: Text8Pt
        Left = 205
        Top = 22
        Width = 121
        Height = 22
        Enabled = False
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
        OnDblClick = BrowseBtnClick
        OnExit = SRVPathExit
        TextId = 0
        ViaSBtn = False
      end
      object BrowseBtn: TButton
        Left = 331
        Top = 22
        Width = 71
        Height = 21
        Caption = '&Browse'
        TabOrder = 1
        OnClick = BrowseBtnClick
      end
      object NWAName: TSBSComboBox
        Left = 205
        Top = 73
        Width = 145
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 2
        OnChange = NWANameExit
        Items.Strings = (
          'No adaptors found!')
        MaxListWidth = 0
      end
      object IPXMPS: TCurrencyEdit
        Left = 205
        Top = 99
        Width = 80
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'ARIAL'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        ParentFont = False
        TabOrder = 3
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object Set2Btn: TButton
        Left = 331
        Top = 102
        Width = 71
        Height = 21
        Caption = '&Set'
        TabOrder = 4
        OnClick = Set2BtnClick
      end
      object IPXVMN: TCurrencyEdit
        Left = 205
        Top = 124
        Width = 80
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'ARIAL'
        Font.Style = []
        Lines.Strings = (
          '0 ')
        ParentFont = False
        TabOrder = 5
        WantReturns = False
        WordWrap = False
        AutoSize = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object Set3Btn: TButton
        Left = 331
        Top = 127
        Width = 71
        Height = 21
        Caption = '&Set'
        TabOrder = 6
        OnClick = Set3BtnClick
      end
      object NovBSPX: Text8Pt
        Left = 205
        Top = 48
        Width = 121
        Height = 22
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 7
        OnDblClick = BrowseBtnClick
        TextId = 0
        ViaSBtn = False
      end
      object Set1Btn: TButton
        Left = 331
        Top = 48
        Width = 71
        Height = 21
        Caption = '&Set'
        TabOrder = 8
        OnClick = Set1BtnClick
      end
    end
    inherited TabSheet3: TTabSheet
      HelpContext = 4
      Caption = 'Btrieve'
      object SBSBackGroup2: TSBSBackGroup
        Left = 5
        Top = 2
        Width = 406
        Height = 231
        TextId = 0
      end
      object Label816: Label8
        Left = 15
        Top = 22
        Width = 113
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Btrieve Engine Type : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label817: Label8
        Left = 251
        Top = 20
        Width = 156
        Height = 18
        Alignment = taCenter
        AutoSize = False
        Caption = 'Btrieve Engine Settings'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object Label819: Label8
        Left = 139
        Top = 43
        Width = 75
        Height = 14
        Alignment = taCenter
        AutoSize = False
        Caption = 'Current'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        TextId = 0
      end
      object Label820: Label8
        Left = 228
        Top = 43
        Width = 82
        Height = 14
        Alignment = taCenter
        AutoSize = False
        Caption = 'Recommended'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        TextId = 0
      end
      object BTEType: TSBSComboBox
        Left = 130
        Top = 18
        Width = 120
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
        OnExit = BTETypeExit
        Items.Strings = (
          'Local (Multi User)'
          'Server (Client Server)')
        MaxListWidth = 0
      end
      object ScrollBox1: TScrollBox
        Left = 12
        Top = 58
        Width = 389
        Height = 130
        TabOrder = 1
        object Label818: Label8
          Left = 6
          Top = 5
          Width = 113
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Maximum Files : '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label821: Label8
          Left = 6
          Top = 29
          Width = 113
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Maximum Handles : '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label822: Label8
          Left = -1
          Top = 101
          Width = 120
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Compression Buffer (k): '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label823: Label8
          Left = -1
          Top = 125
          Width = 120
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Operation Bundle Limit : '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label824: Label8
          Left = 6
          Top = 149
          Width = 113
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Initiation Time Limit : '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label825: Label8
          Left = 6
          Top = 173
          Width = 113
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Share Remote Files : '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label826: Label8
          Left = 6
          Top = 53
          Width = 113
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Maximum Locks : '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label827: Label8
          Left = 6
          Top = 77
          Width = 113
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Pre-version 6 mode : '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label828: Label8
          Left = 6
          Top = 197
          Width = 113
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Interface : '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label829: Label8
          Left = 6
          Top = 222
          Width = 113
          Height = 14
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Client Server Protocol : '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object BTC1: TCurrencyEdit
          Left = 123
          Top = 2
          Width = 80
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0 ')
          ParentFont = False
          TabOrder = 0
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTD1: TCurrencyEdit
          Left = 216
          Top = 2
          Width = 80
          Height = 22
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Lines.Strings = (
            '0 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTBtn1: TButton
          Tag = 1
          Left = 305
          Top = 3
          Width = 60
          Height = 21
          Caption = '&Set'
          TabOrder = 2
          OnClick = BTBtn1Click
        end
        object BTBtn2: TButton
          Tag = 2
          Left = 305
          Top = 27
          Width = 60
          Height = 21
          Caption = '&Set'
          TabOrder = 5
          OnClick = BTBtn1Click
        end
        object BTBtn5: TButton
          Tag = 5
          Left = 305
          Top = 99
          Width = 60
          Height = 21
          Caption = '&Set'
          TabOrder = 14
          OnClick = BTBtn1Click
        end
        object BTBtn6: TButton
          Tag = 6
          Left = 305
          Top = 123
          Width = 60
          Height = 21
          Caption = '&Set'
          TabOrder = 17
          OnClick = BTBtn1Click
        end
        object BTBtn7: TButton
          Tag = 7
          Left = 305
          Top = 147
          Width = 60
          Height = 21
          Caption = '&Set'
          TabOrder = 20
          OnClick = BTBtn1Click
        end
        object BTBtn8: TButton
          Tag = 8
          Left = 305
          Top = 171
          Width = 60
          Height = 21
          Caption = '&Set'
          TabOrder = 23
          OnClick = BTBtn1Click
        end
        object BTD7: TCurrencyEdit
          Left = 216
          Top = 146
          Width = 80
          Height = 22
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Lines.Strings = (
            '0 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 19
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTD6: TCurrencyEdit
          Left = 216
          Top = 122
          Width = 80
          Height = 22
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Lines.Strings = (
            '0 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 16
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTD5: TCurrencyEdit
          Left = 216
          Top = 98
          Width = 80
          Height = 22
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Lines.Strings = (
            '0 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 13
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTD2: TCurrencyEdit
          Left = 216
          Top = 26
          Width = 80
          Height = 22
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Lines.Strings = (
            '0 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 4
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTC2: TCurrencyEdit
          Left = 123
          Top = 26
          Width = 80
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0 ')
          ParentFont = False
          TabOrder = 3
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTC5: TCurrencyEdit
          Left = 123
          Top = 98
          Width = 80
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0 ')
          ParentFont = False
          TabOrder = 12
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTC6: TCurrencyEdit
          Left = 123
          Top = 122
          Width = 80
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0 ')
          ParentFont = False
          TabOrder = 15
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTC7: TCurrencyEdit
          Left = 123
          Top = 146
          Width = 80
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0 ')
          ParentFont = False
          TabOrder = 18
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTC3: TCurrencyEdit
          Left = 123
          Top = 50
          Width = 80
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0 ')
          ParentFont = False
          TabOrder = 6
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTD3: TCurrencyEdit
          Left = 216
          Top = 50
          Width = 80
          Height = 22
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Lines.Strings = (
            '0 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 7
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTBtn3: TButton
          Tag = 3
          Left = 305
          Top = 51
          Width = 60
          Height = 21
          Caption = '&Set'
          TabOrder = 8
          OnClick = BTBtn1Click
        end
        object BTC4: TCurrencyEdit
          Left = 123
          Top = 74
          Width = 80
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0 ')
          ParentFont = False
          TabOrder = 9
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTD4: TCurrencyEdit
          Left = 216
          Top = 74
          Width = 80
          Height = 22
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Lines.Strings = (
            '0 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 10
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTBtn4: TButton
          Tag = 4
          Left = 305
          Top = 75
          Width = 60
          Height = 21
          Caption = '&Set'
          TabOrder = 11
          OnClick = BTBtn1Click
        end
        object BTC9: Text8Pt
          Left = 123
          Top = 194
          Width = 80
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 24
          TextId = 0
          ViaSBtn = False
        end
        object BTD9: Text8Pt
          Left = 216
          Top = 194
          Width = 80
          Height = 22
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 25
          OnDblClick = BrowseBtnClick
          TextId = 0
          ViaSBtn = False
        end
        object BTBtn9: TButton
          Tag = 9
          Left = 305
          Top = 195
          Width = 60
          Height = 21
          Caption = '&Set'
          TabOrder = 26
          OnClick = BTBtn1Click
        end
        object BTC8: TCurrencyEdit
          Left = 123
          Top = 170
          Width = 80
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '0 ')
          ParentFont = False
          TabOrder = 21
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTD8: TCurrencyEdit
          Left = 216
          Top = 170
          Width = 80
          Height = 22
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Lines.Strings = (
            '0 ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 22
          WantReturns = False
          WordWrap = False
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###,###,##0 ;###,###,##0-'
          DecPlaces = 0
          ShowCurrency = False
          TextId = 0
          Value = 1E-10
        end
        object BTC10: Text8Pt
          Left = 123
          Top = 218
          Width = 80
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 27
          Text = 'N/A'
          TextId = 0
          ViaSBtn = False
        end
        object BTD10: Text8Pt
          Left = 216
          Top = 218
          Width = 80
          Height = 22
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 28
          Text = 'N/A'
          OnDblClick = BrowseBtnClick
          TextId = 0
          ViaSBtn = False
        end
        object Set10Btn: TButton
          Tag = 11
          Left = 305
          Top = 219
          Width = 60
          Height = 21
          Caption = '&Set'
          TabOrder = 29
          OnClick = BTBtn1Click
        end
      end
      object SetChk: TBorCheck
        Left = 28
        Top = 200
        Width = 206
        Height = 20
        Caption = 'Use recommended values when setting'
        Color = clBtnFace
        Checked = True
        ParentColor = False
        State = cbChecked
        TabOrder = 2
        TextId = 0
        OnClick = SetChkClick
      end
      object SetAllBtn: TButton
        Tag = 9999
        Left = 321
        Top = 199
        Width = 60
        Height = 21
        Caption = '&Set All'
        Enabled = False
        TabOrder = 3
        OnClick = BTBtn1Click
      end
    end
    object TabSheet5: TTabSheet
      HelpContext = 5
      Caption = 'Printers'
      object SBSBackGroup4: TSBSBackGroup
        Left = 5
        Top = 2
        Width = 406
        Height = 231
        TextId = 0
      end
      object PrintList1: TListBox
        Left = 10
        Top = 14
        Width = 395
        Height = 171
        ItemHeight = 13
        TabOrder = 0
      end
      object PrnMasChk: TBorCheck
        Left = 16
        Top = 200
        Width = 383
        Height = 20
        Caption = 
          'Use this list of printers as a master list for comparison with o' +
          'ther workstations'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
        TextId = 0
      end
    end
  end
  inherited SBSPanel1: TSBSPanel
    Left = 334
    Top = 241
    Caption = ''
  end
  inherited OkCP1Btn: TButton
    Left = 124
    Top = 266
  end
  inherited ClsCP1Btn: TButton
    Left = 214
    Top = 266
  end
  object OpenDialog1: TOpenDialog
    Options = [ofPathMustExist]
    Left = 6
    Top = 266
  end
end
