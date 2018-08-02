object JAView: TJAView
  Left = -678
  Top = -249
  Width = 608
  Height = 459
  HelpContext = 915
  ActiveControl = NLOLine2
  Caption = 'Job Totals'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object SBSPanel1: TSBSPanel
    Left = 0
    Top = 390
    Width = 592
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object NCurrLab: Label8
      Left = 241
      Top = 10
      Width = 21
      Height = 14
      Caption = '&Curr'
      FocusControl = Currency
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Panel4: TSBSPanel
      Left = 3
      Top = 5
      Width = 225
      Height = 20
      Alignment = taRightJustify
      BevelOuter = bvLowered
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      Purpose = puFrame
      object lblDetailsCode: Label8
        Left = 8
        Top = 2
        Width = 213
        Height = 14
        AutoSize = False
        Caption = 'Details : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
    end
    object TxLateChk: TBorCheck
      Left = 327
      Top = 7
      Width = 88
      Height = 20
      HelpContext = 995
      Align = alRight
      Caption = '&Translate to'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
      TabStop = True
      TextId = 0
      OnClick = TxLateChkClick
    end
    object Currency: TSBSComboBox
      Tag = 1
      Left = 263
      Top = 6
      Width = 57
      Height = 22
      HelpContext = 994
      Style = csDropDownList
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      MaxLength = 3
      ParentFont = False
      TabOrder = 1
      OnClick = CurrencyClick
      ExtendedList = True
      MaxListWidth = 90
      Validate = True
    end
    object OptBtn: TButton
      Left = 445
      Top = 7
      Width = 80
      Height = 21
      HelpContext = 986
      Caption = '&Options'
      TabOrder = 3
      OnClick = OptBtnClick
    end
  end
  object PageControl1: TPageControl
    Left = 3
    Top = 47
    Width = 586
    Height = 343
    ActivePage = StkPage
    TabIndex = 1
    TabOrder = 0
    OnChange = PageControl1Change
    object CatPage: TTabSheet
      Caption = 'Analysis'
      object NLDPanel: TSBSPanel
        Left = 3
        Top = 0
        Width = 201
        Height = 19
        Alignment = taLeftJustify
        BevelOuter = bvLowered
        Caption = '  Categories and Analysis Totals'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object NLCrPanel: TSBSPanel
        Left = 326
        Top = 0
        Width = 118
        Height = 19
        Alignment = taRightJustify
        BevelOuter = bvLowered
        Caption = 'Budget  '
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object NLDrPanel: TSBSPanel
        Left = 446
        Top = 0
        Width = 107
        Height = 19
        Alignment = taRightJustify
        BevelOuter = bvLowered
        Caption = 'Variance  '
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
      object NLOLine: TSBSOutlineB
        Left = 2
        Top = 21
        Width = 573
        Height = 290
        OnExpand = NLOLineExpand
        OnCollapse = NLOLineCollapse
        Options = [ooDrawTreeRoot]
        ItemHeight = 16
        ItemSpace = 6
        OnDrawItem = NLOLineDrawItem
        BarColor = clHighlight
        BarTextColor = clHighlightText
        HLBarColor = clBlack
        HLBarTextColor = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        TabOrder = 3
        OnClick = NLOLineClick
        OnMouseUp = NLOLineMouseUp
        ItemSeparator = '\'
        PictureOpen.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000202E0000202E00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FF7473767473767473767473767473767473767473767473767473767473
          76747376747376747376FF00FFFF00FF1382D71382D71382D71382D71382D713
          82D71382D71382D71382D71382D71382D71382D71382D7747376FF00FF1382D7
          1382D737C8FD2ABFFC19B3FB1AAEFA1BAAFA1BAAFA1AACFA1AB1FB18B6FC17BD
          FD1382D71382D7747376FF00FF1382D750D0FE52CBFD53C5FC4DBDFB32ADF91D
          A0F81DA0F81CA4F91BABFA19B2FB17BAFC1382D71382D77473761382D71382D7
          51CEFE52C8FC53C1FB55BBFB56B5F949ABF8269DF71DA1F81BA9FA19B1FB18BA
          FC1382D71382D77473761382D752C8FD51CDFE53C6FC54C0FB55BAFB56B5FA57
          B3F956B6FA44B4FA30B3FA24B7FB1382D71382D71382D77473761382D750D0FE
          51CEFE52C8FC53C3FB54BEFB55BBFB55BAFB55BCFB54C0FB53C5FC52CBFD1382
          D750D0FE1382D77473761382D750D0FE50CFFE51CCFD52C7FC53C4FC53C2FB53
          C2FB53C4FC52C7FC51CCFD50CFFE1382D750D0FE1382D77473761382D71382D7
          1382D71382D71382D71382D71382D71382D71382D71382D71382D71382D71382
          D744BEFB1382D7747376FF00FFFF00FF1382D750D0FE50CEFE51CAFD53C6FC53
          C3FC53C2FC53C2FC53C5FC52C9FD50CDFE50D0FE1382D7747376FF00FFFF00FF
          1382D73AA9F93AA9F93AA8F83AA7F81382D71382D71382D71382D71382D71382
          D71382D71382D7FF00FFFF00FFFF00FF1382D71382D71382D71382D71382D713
          82D7E312FEFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        PictureClosed.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000202E0000202E00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FF7473767473767473767473767473767473767473767473767473767473
          76747376747376FF00FFFF00FFFF00FF1382D71382D71382D71382D71382D713
          82D71382D71382D71382D71382D71382D71382D7747376FF00FFFF00FF1382D7
          1DC2FD16BFFD17BAFC19B5FB19B2FB1AB0FB1AB1FB19B4FB18B9FC16BEFD16C0
          FD1382D7747376FF00FFFF00FF1382D750D0FE4ACAFD36BEFC1EAFFA1BAAF91C
          A8F91BA9F91AADFA19B2FB18BAFC16C0FD1382D7747376FF00FFFF00FF1382D7
          50CFFE52CAFD53C4FB51BDFB2FAAF91E9FF81DA1F81CA6F91AAEFA18B6FB16BD
          FD1382D7747376FF00FFFF00FF1382D750CEFE52C8FD53C1FB55BBFB56B5FA42
          A8F8229DF71DA2F81BAAFA19B3FB17BBFD1382D7747376FF00FFFF00FF1382D7
          50CEFE52C7FD53C1FB55BBFB56B5FA57B1F953B2F939ADF922ADFA19B2FB17BB
          FD1382D7747376FF00FFFF00FF1382D750CEFE52C9FD53C2FC54BDFB56B8FA56
          B6FA56B7FA55BBFB53C1FB47C3FC3BC7FD1382D7747376FF00FFFF00FF1382D7
          50CFFE51CBFD53C6FC53C1FB54BDFB55BCFB54BDFB53C0FB53C4FC51CAFD50CF
          FE1382D7747376FF00FFFF00FF1382D750D0FE50CEFE51CAFD53C6FC53C3FC53
          C2FC53C2FC53C5FC52C9FD50CDFE50D0FE1382D7747376FF00FFFF00FF1382D7
          3AA9F93AA9F93AA8F83AA7F81382D71382D71382D71382D71382D71382D71382
          D71382D7FF00FFFF00FFFF00FFFF00FF1382D71382D71382D71382D71382D7FF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        PictureLeaf.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          080000000000000100001F2E00001F2E00000001000000000000E39F3900E3AF
          3900E7B84C00E9BF6000FF00FF00908F8E00FAE2AD00FBE5B600F6E4BC00F8E8
          C600F8E9C800FCECC900FDF1D800FDF5E400FEF8EC00FEFBF200FFFCF700FFFD
          FA00FFFEFC00FFFEFE0000000000000000000000000000000000000000000000
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
          0000000000000000000000000000000000000000000000000000040404040404
          0404040404040404040404040404040404040404040404040404040404050505
          0505050505050505050404040202020202020202020202020504040402060606
          06060606060606020504040402070707070707070707070205040404020B0B0B
          0B0B0B0B0B0B0B0205040404020C0C0C0C0C0C0C0C0C0C0205040404020D0D0D
          0D0D0D0D0D0D0D0205040404020E0E0E0E0E0E0E0E0E0E0205040404020F0F0F
          0F0F0F0F0F0F0F02050404040210101010101010101010020504040402111111
          11111111110909020504040402121212121212120A0301020404040402131313
          1313131308000204040404040202020202020202020204040404}
        PictureLeaf2.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          080000000000000100001F2E00001F2E00000001000000000000C4852900C281
          3300B1835000C29C7000CEA16900D8AB6900DAB07300DDB27100DBB37800DBB4
          7A00DBB47B00DCB67D00DCB67E00DCB67F00DCB77F002A23EB003731EC00453F
          EE00524CEF005F5AF0006D68F1007A75F200FF00FF00A891B700CDAF8E00DCB7
          8000DCB88000DCB88100DCB88200DDB98300D3B59000E3BD8400E4BE8500E1BE
          8A00E2C08F00E7C38E00E7C48E00E5C39000E4C59800E4C69A00E4C79B00E4C8
          9E00E9CA9D00DBC4AD00DEC6AF00D3C0BE00E5C9A000E6C8AC00ECD3AE00E0CB
          BA00EED5B100EDD5B200ECD7B800EDD9BB008F86E6009D95E6009591F500A19C
          F100A29FF600AFADF800BBB7F600BCBAF900DDCED200EEDCC100E8DACB00F1E0
          C800F3E2CA00F6E3C900F2E5D100F2E1D800F1E3DA00F9ECDA00FAEDDD00D3CC
          EF00D6D2F400D7D4F700EFE8EB00FAF1E400FBF2E500FBF3E700FBF5EB00FCF4
          E900FCF4EB00E4E2FA00FDF7F100FDF8F100FDF9F300FDFAF500FEFAF500FEFB
          F700F2F1FE00FEFCF800FEFCF900FEFCFA00FEFDFC00FFFEFD00FFFFFF000000
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
          0000000000000000000000000000000000000000000000000000161616161616
          1616161616161616161616161616161616161616161616161616161600000000
          0000000000000000161616003D383B60383838383B5A3A38001616003F3F3F3F
          3F443D3813113A3F001616002A1F234D3441100F0F0F1320001616003025244E
          3534564B0F0F1033001616002205074F190D311112390F2C0016160052484350
          5D5C15104A3E144C00161600280821551C2D0F37273206090016160059544E58
          5F5E535C57475156001616002E19265B1D1D1C1B29420B19001616001C1B0C1B
          1D1D1C1C1A0A0E1B0016160001010101010104021E033617001616002F454545
          45454618402B3C49001616160000000000000000000000001616}
        ParentFont = False
        ScrollBars = ssVertical
        ShowValCol = 3
        OnNeedValue = NLOLineNeedValue
        TreeColor = clNavy
        Data = {3C00}
      end
      object NLAcPanel: TSBSPanel
        Left = 206
        Top = 0
        Width = 118
        Height = 19
        Alignment = taRightJustify
        BevelOuter = bvLowered
        Caption = 'Actual Value  '
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
      end
    end
    object StkPage: TTabSheet
      HelpContext = 1000
      Caption = 'Stock/Pay'
      object NLOLine2: TSBSOutlineB
        Left = 3
        Top = 23
        Width = 539
        Height = 200
        OnExpand = NLOLineExpand
        Options = [ooDrawTreeRoot]
        ItemHeight = 13
        ItemSpace = 0
        OnDrawItem = NLOLineDrawItem
        BarColor = clHighlight
        BarTextColor = clHighlightText
        HLBarColor = clBlack
        HLBarTextColor = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        TabOrder = 0
        OnMouseUp = NLOLineMouseUp
        ItemSeparator = '\'
        PictureLeaf.Data = {
          76010000424D760100000000000036000000280000000A0000000A0000000100
          1800000000004001000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FF7F7F7F
          7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F0000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F0000FFFFFFE8A200
          CC483FCC483FCC483FE8A200FFFFFFE8A200CC483F7F7F7F0000FFFFFFCC483F
          CC483FFFFFFFCC483FCC483FFFFFFFCC483FFFFFFF7F7F7F0000FFFFFFFFFFFF
          FFFFFFBE9270CC483FE8A200FFFFFFCC483FFFFFFF7F7F7F0000FFFFFFE8A200
          CC483FBE9270FFFFFFFFFFFFCC483FCC483FCC483F7F7F7F0000FFFFFFCC483F
          CC483FFFFFFFCC483FCC483FFFFFFFCC483FFFFFFF7F7F7F0000FFFFFFE8A200
          CC483FCC483FCC483FE8A200FFFFFFFFFFFFFFFFFF7F7F7F0000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FF0000}
        PictureLeaf2.Data = {
          76010000424D760100000000000036000000280000000A0000000A0000000100
          1800000000004001000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FF7F7F7F
          7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFF00FF0000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FFF00FF0000FFFFFFCC483F
          CC483FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FFF00FF0000FFFFFFCC483F
          CC483FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FFF00FF0000FFFFFFCC483F
          CC483FCC483FCC483FE8A200FFFFFFFFFFFF7F7F7FFF00FF0000FFFFFFCC483F
          CC483FFFFFFFCC483FCC483FFFFFFFFFFFFF7F7F7FFF00FF0000FFFFFFCC483F
          CC483FFFFFFFCC483FCC483FFFFFFFFFFFFF7F7F7FFF00FF0000FFFFFFCC483F
          CC483FCC483FCC483FE8A200FFFFFFFFFFFF7F7F7FFF00FF0000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFF00FF0000}
        ParentFont = False
        ScrollBars = ssVertical
        ShowValCol = 3
        OnNeedValue = NLOLineNeedValue
        OnUpdateNode = NLOLine2UpdateNode
        TreeColor = clGray
        Data = {3000}
      end
      object NLAcPanel2: TPanel
        Left = 174
        Top = 0
        Width = 116
        Height = 19
        Alignment = taRightJustify
        BevelOuter = bvLowered
        Caption = 'Actual Value  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object NLDPanel2: TPanel
        Left = 3
        Top = 0
        Width = 170
        Height = 19
        Alignment = taLeftJustify
        BevelOuter = bvLowered
        Caption = 'Stock/Pay Rate Analysis'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object NLCrPanel2: TPanel
        Left = 291
        Top = 0
        Width = 115
        Height = 19
        Alignment = taRightJustify
        BevelOuter = bvLowered
        Caption = 'Budget  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object NLDrPanel2: TPanel
        Left = 407
        Top = 0
        Width = 116
        Height = 19
        Alignment = taRightJustify
        BevelOuter = bvLowered
        Caption = 'Variance  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
    end
  end
  object AdvDockPanel: TAdvDockPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 46
    MinimumSize = 3
    LockHeight = False
    Persistence.Location = plRegistry
    Persistence.Enabled = False
    ToolBarStyler = AdvStyler
    UseRunTimeHeight = True
    Version = '2.9.0.0'
    object AdvToolBar: TAdvToolBar
      Left = 3
      Top = 1
      Width = 586
      Height = 44
      AllowFloating = True
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'MS Sans Serif'
      CaptionFont.Style = []
      CompactImageIndex = -1
      ShowRightHandle = False
      ShowClose = False
      ShowOptionIndicator = False
      FullSize = True
      TextAutoOptionMenu = 'Add or Remove Buttons'
      TextOptionMenu = 'Options'
      ToolBarStyler = AdvStyler
      ParentOptionPicture = True
      ToolBarIndex = -1
      object AdvToolBarSeparator1: TAdvToolBarSeparator
        Left = 82
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object AdvToolBarSeparator2: TAdvToolBarSeparator
        Left = 490
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object AdvToolBarSeparator3: TAdvToolBarSeparator
        Left = 252
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object FullExBtn: TAdvGlowButton
        Left = 2
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Expand All|Opens all folders in the job tree'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000024D4944415458C3ED554D4F1351143DAFD32160491735A535468DAD0B
          3E0CB04237EAC40A62DC109AAE49E3C618E20F006DCA7FE00F3476035121240D
          35152DA0623421F8917601F603BF9044DA149A5A3AD3E7A2A64C07C7DAF8C6C6
          C8D94C72DF7D73CFBBE7BD738103FCEF20CAC085C1400C142735AA179B9FBA6A
          970774FB52B42B0E00366540576F09F4CA8073A84BD382F3535508B4755AFE6A
          07EA2EC101017DB58417EF32180F7D545DEFB11931DC77543B02A7AC4D18EE55
          2F606AE6B5ED80C9C0A3C7CED74F0225D6BEE4107CB5A5BA6EB736E14AA7E9DF
          B984FB86512856A05A16ECB5F1842981AD6C016B1BB9BD576137626367152F3F
          CC20995E81582C00002CCD769CB6389079B0C479BDDE223302F267EABBDE8AC5
          841F4BEB93A050FDCD131071606E68EE2B73099EAD4F602171676FAE985BD162
          3097865062513EF39F37643861F6E66C5ECF4ADBCFDBAB5848FA2B62AE0E27CE
          9F38F78340BF5CF9B379A3740BC06D664EB8FC2900505AC3ED273784C7C21833
          274CA65F97DBEEEA700200DACD6DE53C8F300A00886C467137721F004CFC7BBE
          9B9913EEEC96CCA9C5602EB75D8E8A58A4F49124728499113572876ADEC3715C
          86D92B9878E3413CB55C11F308A3E5935FF2F52BB7EC4A346F61D6812E6B5FAD
          167C2FEC0EA7F5D5ACF2B741412E462F8708E0284BBD19552B9E122919F9A911
          FD091C3EC76152D40728C1995F9C3C054A061FBA836100E05812884FC773C707
          8EF939F01208BA0134CA96454A302D51E27CE40EAEA8CE0256704DBAB85436DB
          0E9D64A120D96F62C3DBA7D766B69579DF01872AC9F8B2F38F7A000000004945
          4E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 0
        OnClick = FullExBtnClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 11899524
        Appearance.ColorDownTo = 11899524
        Appearance.ColorHot = 15717318
        Appearance.ColorHotTo = 15717318
        Appearance.ColorMirror = clBtnFace
        Appearance.ColorMirrorTo = clBtnFace
        Appearance.ColorMirrorHot = 15717318
        Appearance.ColorMirrorHotTo = 15717318
        Appearance.ColorMirrorDown = 11899524
        Appearance.ColorMirrorDownTo = 11899524
        Appearance.ColorMirrorChecked = 12179676
        Appearance.ColorMirrorCheckedTo = 12179676
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
      end
      object FullColBtn: TAdvGlowButton
        Left = 42
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Collapse All|Closes all folders in the job tree to the top-level'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000002014944415458C3ED554D4B1B51143D77924127A3410362C48834294A
          BB507111152C06C542B12B450A5DD47D71E72F107F81A53B2994EE4D74111162
          70820A318552C18F2E3464614B5BD058ED24928C795D0856271D92D037063177
          F7CEBD8F7339E7BEFB804ADCF7203D30301A8C83E181497CF14860C4731D10F2
          4ACC230700B71E10CA6D81550F8C4D749A4A18091468E05147E3AD2A50760B2A
          0D580B15C40E4EF136F4D530EF75DB31F9B4D9BC061E3A254C0E1B13386A4473
          1570C822BC1EB17C16E863FF471ACB5BC786798F53C2B30EC7DD19C2BCCF2814
          CF32330987DD22FD9705FA3856B3D8FF9ECEC35F2AB3A8DBFB08D2320000B5A5
          0DBB536FF82BA07FA6ABCE35B8963E008C1949BE2E87634F4CB1C0157C8F9685
          B982750C88D686637D5C87B026B107D7E2BB6207AFF76CB06786EB2674AEFA41
          2C57FCF4137BCD7CBE696E9BD0FEE5D3152607234055F53FEBD3AFC690FB7608
          008E9498EAE2B609C55F47A5FB76C19AB8CD404E924BBF63C1A9955703BF5BDB
          51B7B379F9E647068AB992D1B2D92D6E0AFCEC7F5EEA0E9EAF573E9F10AF0618
          40EAA03704C2100090CD06964AFDE5BB7E26242D9AD02D29D1043705086039C2
          0B103601DC20BF712624198451498926B8FF86F670EC48D66C3E46980670A24B
          6BC4C86FD184EEDA95A862B88AB959323E6E5193878F01AD5160A4AAE7E276C3
          C6C699BEEE0FE615ABCB2648E3690000000049454E44AE426082}
        Position = bpRight
        ShowDisabled = False
        TabOrder = 1
        OnClick = FullExBtnClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 11899524
        Appearance.ColorDownTo = 11899524
        Appearance.ColorHot = 15717318
        Appearance.ColorHotTo = 15717318
        Appearance.ColorMirror = clBtnFace
        Appearance.ColorMirrorTo = clBtnFace
        Appearance.ColorMirrorHot = 15717318
        Appearance.ColorMirrorHotTo = 15717318
        Appearance.ColorMirrorDown = 11899524
        Appearance.ColorMirrorDownTo = 11899524
        Appearance.ColorMirrorChecked = 12179676
        Appearance.ColorMirrorCheckedTo = 12179676
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
      end
      object Panel7: TPanel
        Left = 500
        Top = 2
        Width = 80
        Height = 38
        BevelOuter = bvNone
        TabOrder = 7
        object Button1: TButton
          Left = 2
          Top = 10
          Width = 78
          Height = 21
          HelpContext = 24
          Cancel = True
          Caption = 'C&lose'
          ModalResult = 2
          TabOrder = 0
          OnClick = ClsI1BtnClick
        end
      end
      object Panel8: TPanel
        Left = 262
        Top = 2
        Width = 228
        Height = 38
        BevelOuter = bvNone
        TabOrder = 6
        object Label82: Label8
          Left = 4
          Top = 12
          Width = 30
          Height = 14
          Caption = '&Period'
          FocusControl = Period
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Label83: Label8
          Left = 101
          Top = 12
          Width = 23
          Height = 14
          Caption = '&Year'
          FocusControl = Year
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
        object Period: TSBSComboBox
          Left = 39
          Top = 8
          Width = 57
          Height = 22
          Style = csDropDownList
          Color = clWhite
          DropDownCount = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          MaxLength = 2
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = CurrencyClick
          OnExit = PeriodExit
          OnKeyPress = PeriodKeyPress
          MaxListWidth = 0
        end
        object Year: TSBSComboBox
          Tag = 1
          Left = 128
          Top = 8
          Width = 57
          Height = 22
          Style = csDropDownList
          Color = clWhite
          DropDownCount = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          MaxLength = 4
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = CurrencyClick
          OnEnter = PeriodExit
          MaxListWidth = 0
        end
        object YTDChk: TBorCheck
          Left = 189
          Top = 8
          Width = 41
          Height = 20
          Hint = 
            'Show YTD|When selected shows balances upto and including the cur' +
            'rent period, otherwise shows balance for period only'
          Align = alRight
          Caption = 'YT&D'
          Color = clBtnFace
          Checked = True
          ParentColor = False
          State = cbChecked
          TabOrder = 2
          TabStop = True
          TextId = 0
          OnClick = YTDChkClick
        end
      end
      object GraphBtn: TAdvGlowButton
        Left = 92
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Graph|Displays the Graph window for the job code or contract cur' +
          'rently selected'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA79300000091494441545809636018
          05233D04186912007BAEAC069A1B02C498C84507C54E264C15F4151975000B46
          80EFB9F21F430C22B086C1452714C2A41E391A05A32130E02180990B0825F0FD
          176518FEB1586255C6F4E73883A3FE13AC723804597088E3160659FEFFFF2AAC
          0AFEB18401C541C53090220E0D78148C3A6034044643603404464360C04380B8
          1A6354D5700E0100F56D131C9033746D0000000049454E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 2
        OnClick = HistBtnClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 11899524
        Appearance.ColorDownTo = 11899524
        Appearance.ColorHot = 15717318
        Appearance.ColorHotTo = 15717318
        Appearance.ColorMirror = clBtnFace
        Appearance.ColorMirrorTo = clBtnFace
        Appearance.ColorMirrorHot = 15717318
        Appearance.ColorMirrorHotTo = 15717318
        Appearance.ColorMirrorDown = 11899524
        Appearance.ColorMirrorDownTo = 11899524
        Appearance.ColorMirrorChecked = 12179676
        Appearance.ColorMirrorCheckedTo = 12179676
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
      end
      object HistBtn: TAdvGlowButton
        Left = 132
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'History|Displays period and year-to-date balances for the job re' +
          'cord or contract selected'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA7930000057E494441545809ED566D
          4C5367143EF7DEB65C28588A16ACA844654EA593B90113338D42823F44E84C74
          4B962C247324FBD088CEC589CE26359A198C5B24D1853F332EC338E326B8F9C5
          E423C62966BA4DA94E9481B25654A820741D6DEFBBF3DEDE5BEFED0722FB6BF3
          3EF79CF39CF39EF7E97DEF17C0F3DFFF3C035BEA0A8BB7D417148DB58D66AC13
          6D361BEB7FA5650730E413C2C09B63EDC33CCBC4F6DED62C2042C9BFFEA1E2E6
          3F0F65BB066EEBA5F94EB4ED04E0A41060EA765A7F76603CAA312A01B77ACF2F
          00607763C7F908E87C78155ADA0F814070494A8401D946566037D84B1BAE84A5
          22C211051042988EBED6CF0890AD389343888301067A06BAA0E1C60118F6FF03
          1CABB91F10FC2998546EA91F08D8B62F3F8BDB841E26A38D50D3F0A4EDF04ADD
          F809295F6B39DD5ACCB108E03549302121034CFA6930D56881D9690BA0FD412B
          2C7F699DDE9ABD7ED0C0A75EB9F3C8E1F60786D3B09E459D058BDAA7CD2EB0E6
          D4357DE708201731620A78FD9D8935377B2EE6CC4ACBD368357C7C6AE20C7171
          1D170F0C23EA017D5C3258CC8B01454272FCC4B8C9C9B3262F9AF1561AAFD5FF
          72FBC1AF465C4D87C812749E492DDF76D6A11F31A26EC1D6FA828F701FF7D2EA
          C438E385F505DFE46A393EA6585A170E57FFAD8EFDE7DE4F10883051CC31F0C1
          F6E2B3FB445F7108FE1505613B5A948A8BEF9028CFDBB9F614E5E2151515B06F
          5F441FA9FC89311B32A7BFBBE0CB7E643C08C0AB60E7A7470BC78BBEE21021C0
          AF0DACC37C1202E6A6175E9A9C3C7B26F565701C07959595E076BB652AA69D6A
          9CF3A2C5BCA4552A30703A5221F921A312401F2E982903FCE13EF758E76EC843
          5735E8E20CC3405555958A8F15BCF1F2C7B90CB03D629E40199E09D5B6AB04F8
          5E3D87F73B31D3E24C53CE0D2D17174F7D258C46236CDAB409F6ECD903DDDDDD
          CA54545FC7F1FAE913E6DD9092E95B8F17CE977CD1A804E0532E94CCCD283688
          15510E6BD6AC0193C90476BB3D4A3692CACB281E27B38408A13528A7128077D7
          244A5298C765A6511B0D3CCFC3B66DDBA0A6A606CACBCB2110887A8B87A69A0D
          339FF46298F450021D950010C0849C3812E352524427C6818A58BAFA05B8439A
          A1B1B1314655904EE255BD52836CF0A81240586620480378FD8383B21F6E5D2E
          9778062ED6774357EB306467678797A862EFF090A21709AD418B54021810EE51
          92A26FC8F590DA70747676427E7EBE78011E3AF03D5CFFFD2FF17A08AF53C6BD
          9EBF43BD08C33A953995002280434E5EB97B4A5528F3656565E0743AA1B6B616
          8A8A8A647A447BF9EE09975CC090276B504E2540EB25A790F422E09AAB31743D
          D058467575351C397204AC56AB4C3DD55E7335CB17A1C7ABE3CE2827A804D856
          350DE283E2275AE0F50D592E779FBC407D252C160B94949428A911FD4B5DC7CF
          E32B7B0E2DC227D08F554B4F0F515F864A0025054EB0A3151070EC8F2FCC5EDF
          E37EEA8F051EDFC0A3E36D7BA74873056059DA5B0A832642C08E654DBF01905A
          9A16045F4675F37B3703C4EFA3F1B380CEA96E5E7D4B10FC920072D0BEACE16A
          788F0801B4C0C7731FA2BD8E807EEF83DC5D6756390687DD7D341E0D06BDEEDE
          5DA7573A1E7B7B73A4FA360DC7AF957C95C16D51C5A1C0766C71A69FE55AF06C
          9829892FA7BED7324AAF2D9D539EA761753CE5C2E11786BD271CFB5B2F75D559
          F0732E45CA3B350CBBD056DCD021C52A135300ADAAAC2F486708F3037E7ACBFF
          84D21E43BCA96D4A72D690D930438B02C1D5DFE1BBEB6ED3E3D9CAC28204843C
          2E6A046E85ADF48C5326C2ED88026871C5E1FCF8043E6123C3908D1827224633
          1EE3DDF4B92649D86D5BD224DED6B1263D55803C71F3C98566D6A72DC7B81431
          0F116D5C46B24EC30A5FD99635DD43FFA963D402949D361F2B4C6358920124F8
          ED805FA92EAD4FD3695B71FABEB2EEB93F9A33F01F56BBC356DBAFF895000000
          0049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 3
        OnClick = HistBtnClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 11899524
        Appearance.ColorDownTo = 11899524
        Appearance.ColorHot = 15717318
        Appearance.ColorHotTo = 15717318
        Appearance.ColorMirror = clBtnFace
        Appearance.ColorMirrorTo = clBtnFace
        Appearance.ColorMirrorHot = 15717318
        Appearance.ColorMirrorHotTo = 15717318
        Appearance.ColorMirrorDown = 11899524
        Appearance.ColorMirrorDownTo = 11899524
        Appearance.ColorMirrorChecked = 12179676
        Appearance.ColorMirrorCheckedTo = 12179676
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
      end
      object NomSplitBtn: TAdvGlowButton
        Left = 212
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'ObjectClone|Displays a clone Job Tree which can be used to compa' +
          're different periods, years or currencies'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA793000002A1494441545809ED544D
          68134114FE76DDEA264DAB45688A6943151A8D7AF520422A4528F6201868113C
          B407BDF873D19B570F2278F02AF82F145344DB434184185BB18882AD5A8395B8
          DA462CB635FF314D4CB2CEA464936C66D69B0AEE30EFCDF7BE37EFCDCB9BEC00
          E6F8DF3B20E81BD07D78FC3AE18E12594F8437E3822A0C3D19ED1BA51B9207F6
          78894DE336529B2339C2DFB1F95F1C23AB36450D55C0208146871337C841EA11
          0AA808AA384056C211CD9F34E710748355008BD38501AA2068FB045241DD0636
          B14E4F4B7AA2DA1E38B415BBB6B768946F4C41F0434CB3594074EF46433FBDC1
          356F31F8163FEF0DAF190C6D58003DBC7B6F9B161678B6F8FB025AED903C3D5A
          4C5E436C20B2E93FC79A05981D303BF0D73B60F810D1978F3E3EE557E1DD5CB4
          0CB96B81BC7CD9F3E7347F71E99B8659C0B000FAEC526105F238757909F9093F
          CF5DC7FFDB57E07048F0EC93D1DC2422FC258FC06406998C5AF72BAA899CD586
          B95E2FA29D5DB04423E8F28F615358A9DE5283B91D903708E8EB9571FBAA0F67
          4F5DC2E7D0347AF65B6A8259C6FB83FD985616F0F4C4714CDDB88619EF20F216
          7E9CC84A4239BB5DC2A7D03C665F7F443AB58AFB2313E874365097A17CDFE642
          D8378C7C2A85D8CC2BAC280A126D1DDC186E018964015BDA5B616D944BC13BDC
          4EC4E2C512365256D2F626F7CED216C96683B5DD094B9CFFF570BF8268B48890
          22E3E2E59358FCBA820EA703E30F33A5C446CAF5E801D2A7CF201A9E47A3C301
          D79B97B04496B921DC0268C4D4F355CC064534DB36E3F1641AD99CF11F90C6B4
          2C84E0B9720149BB037220024B2C4269AEB00AA07DD6AE269128828A3E83A0AA
          745F89565581E04A715236035A48C959AB0AB526A01D54E5B84570251B3118F3
          0720DC2DF3E4FC11820947347FD29C37610EB303BA0EFC02EA27C8A0F4540305
          0000000049454E44AE426082}
        Position = bpRight
        ShowDisabled = False
        TabOrder = 5
        OnClick = NomSplitBtnClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 11899524
        Appearance.ColorDownTo = 11899524
        Appearance.ColorHot = 15717318
        Appearance.ColorHotTo = 15717318
        Appearance.ColorMirror = clBtnFace
        Appearance.ColorMirrorTo = clBtnFace
        Appearance.ColorMirrorHot = 15717318
        Appearance.ColorMirrorHotTo = 15717318
        Appearance.ColorMirrorDown = 11899524
        Appearance.ColorMirrorDownTo = 11899524
        Appearance.ColorMirrorChecked = 12179676
        Appearance.ColorMirrorCheckedTo = 12179676
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
      end
      object ReconBtn: TAdvGlowButton
        Left = 172
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Job Ledger|Displays list of transactions which have been posted ' +
          'to the selected Job code'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D494844520000001E0000001E08060000003B30AE
          A200000006624B474400FF00FF00FFA0BDA7930000022249444154480DED54AF
          531B4114FEDE115151280251D1993B1CB2B282A1D1051118445D4C55300844FF
          840A444C99A94356740001D56907D1FF22C94C6444262A867B7CBB9BFBB57770
          A60144DEBC77EFEDB7DFDB77FB6E6F81A52C3BB0A00E487EDD8FFB37030021CD
          E8F0CFE56E04CAE6D9F41C90362A4587FDCE5A044AC67B1C231581793C8735F2
          4545B4CB9DAD3B4C27CE030A5C058A012A2496A0C4ABC32A96793AA8F08D9BAD
          EB5348B061CB6B3CEE5DED9D9898DFEE0BFD36ADAC8A71FF68CDF2CA93409AEB
          F11A79B28A1CB2B1A1C54486F42734A32CFAC0E112CDF30CD73797EBF18A8581
          91CCD394F13CE4BB600C9798425920A32CAE88B853975BC3AB485D08946CD02E
          DE3CF8FD01F1DD2B3B085666BD8B4FFF4C1CFD986E2196B7262E99C6B341E78D
          E595E608A4B91EAFC1B95455F5270F576801B5DF2E0245EEF095AE4DAB507B16
          223C20596E91F7522E10F99C6F75B2095DC137C4384795A8CEAAE0044B736B78
          097FE1BE70B876F66F6E09BC335595BFD3DFCBDD6D136F7E9F9E427068E2B2C9
          A8DF59F5788F63668DC2E19A170DCD0463E39C093678875BDC01F9A766839457
          8331A35858F5174F358B708657269F89DE9A5B241914BCB92032C0F1EAB12CE3
          A9A342479B07D7C76CE9BA7B099DF42EF6BA268ECEA6AD40E5BD897D8B452683
          CEEBAE8F27E324D7E7351282F1AA724C1FD2A8F687EF32E0B9424B056D13FB26
          8887C42C8FBEA40297EBF39EED0229BDE1125876E07F75E01E8F3AD1EE1543E3
          220000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 4
        OnClick = ReconBtnClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 11899524
        Appearance.ColorDownTo = 11899524
        Appearance.ColorHot = 15717318
        Appearance.ColorHotTo = 15717318
        Appearance.ColorMirror = clBtnFace
        Appearance.ColorMirrorTo = clBtnFace
        Appearance.ColorMirrorHot = 15717318
        Appearance.ColorMirrorHotTo = 15717318
        Appearance.ColorMirrorDown = 11899524
        Appearance.ColorMirrorDownTo = 11899524
        Appearance.ColorMirrorChecked = 12179676
        Appearance.ColorMirrorCheckedTo = 12179676
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
      end
    end
  end
  object AdvStyler: TAdvToolBarOfficeStyler
    Style = bsCustom
    BorderColorHot = clHighlight
    ButtonAppearance.Color = clBtnFace
    ButtonAppearance.ColorTo = clBtnFace
    ButtonAppearance.ColorChecked = clBtnFace
    ButtonAppearance.ColorCheckedTo = 5812223
    ButtonAppearance.ColorDown = 11899524
    ButtonAppearance.ColorDownTo = 9556991
    ButtonAppearance.ColorHot = 15717318
    ButtonAppearance.ColorHotTo = 9556223
    ButtonAppearance.BorderDownColor = clNavy
    ButtonAppearance.BorderHotColor = clNavy
    ButtonAppearance.BorderCheckedColor = clNavy
    ButtonAppearance.CaptionFont.Charset = DEFAULT_CHARSET
    ButtonAppearance.CaptionFont.Color = clWindowText
    ButtonAppearance.CaptionFont.Height = -11
    ButtonAppearance.CaptionFont.Name = 'Segoe UI'
    ButtonAppearance.CaptionFont.Style = []
    CaptionAppearance.CaptionColor = clHighlight
    CaptionAppearance.CaptionColorTo = clHighlight
    CaptionAppearance.CaptionBorderColor = clHighlight
    CaptionAppearance.CaptionColorHot = clHighlight
    CaptionAppearance.CaptionColorHotTo = clHighlight
    CaptionAppearance.CaptionTextColorHot = clBlack
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'Segoe UI'
    CaptionFont.Style = []
    ContainerAppearance.LineColor = clBtnShadow
    ContainerAppearance.Line3D = True
    Color.Color = clBtnFace
    Color.ColorTo = clBtnFace
    Color.Direction = gdVertical
    ColorHot.Color = 15717318
    ColorHot.ColorTo = 15717318
    ColorHot.Direction = gdVertical
    CompactGlowButtonAppearance.BorderColor = 12179676
    CompactGlowButtonAppearance.BorderColorHot = clHighlight
    CompactGlowButtonAppearance.BorderColorDown = clHighlight
    CompactGlowButtonAppearance.BorderColorChecked = clBlack
    CompactGlowButtonAppearance.Color = 15653832
    CompactGlowButtonAppearance.ColorTo = 12179676
    CompactGlowButtonAppearance.ColorChecked = 12179676
    CompactGlowButtonAppearance.ColorCheckedTo = 12179676
    CompactGlowButtonAppearance.ColorDisabled = 15921906
    CompactGlowButtonAppearance.ColorDisabledTo = 15921906
    CompactGlowButtonAppearance.ColorDown = 11899524
    CompactGlowButtonAppearance.ColorDownTo = 11899524
    CompactGlowButtonAppearance.ColorHot = 15717318
    CompactGlowButtonAppearance.ColorHotTo = 15717318
    CompactGlowButtonAppearance.ColorMirror = 12179676
    CompactGlowButtonAppearance.ColorMirrorTo = 12179676
    CompactGlowButtonAppearance.ColorMirrorHot = 15717318
    CompactGlowButtonAppearance.ColorMirrorHotTo = 15717318
    CompactGlowButtonAppearance.ColorMirrorDown = 11899524
    CompactGlowButtonAppearance.ColorMirrorDownTo = 11899524
    CompactGlowButtonAppearance.ColorMirrorChecked = 12179676
    CompactGlowButtonAppearance.ColorMirrorCheckedTo = 12179676
    CompactGlowButtonAppearance.ColorMirrorDisabled = 11974326
    CompactGlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    CompactGlowButtonAppearance.GradientHot = ggVertical
    CompactGlowButtonAppearance.GradientMirrorHot = ggVertical
    CompactGlowButtonAppearance.GradientDown = ggVertical
    CompactGlowButtonAppearance.GradientMirrorDown = ggVertical
    CompactGlowButtonAppearance.GradientChecked = ggVertical
    DockColor.Color = clBtnFace
    DockColor.ColorTo = clBtnFace
    DockColor.Direction = gdHorizontal
    DockColor.Steps = 128
    DragGripStyle = dsNone
    FloatingWindowBorderColor = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    GlowButtonAppearance.BorderColor = clBtnFace
    GlowButtonAppearance.BorderColorHot = clHighlight
    GlowButtonAppearance.BorderColorDown = clHighlight
    GlowButtonAppearance.BorderColorChecked = clBlack
    GlowButtonAppearance.Color = clBtnFace
    GlowButtonAppearance.ColorTo = clBtnFace
    GlowButtonAppearance.ColorChecked = 12179676
    GlowButtonAppearance.ColorCheckedTo = 12179676
    GlowButtonAppearance.ColorDisabled = 15921906
    GlowButtonAppearance.ColorDisabledTo = 15921906
    GlowButtonAppearance.ColorDown = 11899524
    GlowButtonAppearance.ColorDownTo = 11899524
    GlowButtonAppearance.ColorHot = 15717318
    GlowButtonAppearance.ColorHotTo = 15717318
    GlowButtonAppearance.ColorMirror = clBtnFace
    GlowButtonAppearance.ColorMirrorTo = clBtnFace
    GlowButtonAppearance.ColorMirrorHot = 15717318
    GlowButtonAppearance.ColorMirrorHotTo = 15717318
    GlowButtonAppearance.ColorMirrorDown = 11899524
    GlowButtonAppearance.ColorMirrorDownTo = 11899524
    GlowButtonAppearance.ColorMirrorChecked = 12179676
    GlowButtonAppearance.ColorMirrorCheckedTo = 12179676
    GlowButtonAppearance.ColorMirrorDisabled = 11974326
    GlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    GlowButtonAppearance.GradientHot = ggVertical
    GlowButtonAppearance.GradientMirrorHot = ggVertical
    GlowButtonAppearance.GradientDown = ggVertical
    GlowButtonAppearance.GradientMirrorDown = ggVertical
    GlowButtonAppearance.GradientChecked = ggVertical
    GroupAppearance.BorderColor = clHighlight
    GroupAppearance.Color = 15717318
    GroupAppearance.ColorTo = 15717318
    GroupAppearance.ColorMirror = 15717318
    GroupAppearance.ColorMirrorTo = 15717318
    GroupAppearance.Font.Charset = DEFAULT_CHARSET
    GroupAppearance.Font.Color = clWindowText
    GroupAppearance.Font.Height = -11
    GroupAppearance.Font.Name = 'Segoe UI'
    GroupAppearance.Font.Style = []
    GroupAppearance.Gradient = ggVertical
    GroupAppearance.GradientMirror = ggVertical
    GroupAppearance.TextColor = clBlack
    GroupAppearance.CaptionAppearance.CaptionColor = 15915714
    GroupAppearance.CaptionAppearance.CaptionColorTo = 15915714
    GroupAppearance.CaptionAppearance.CaptionTextColor = clBlack
    GroupAppearance.CaptionAppearance.CaptionColorHot = 15915714
    GroupAppearance.CaptionAppearance.CaptionColorHotTo = 15915714
    GroupAppearance.CaptionAppearance.CaptionTextColorHot = clBlack
    GroupAppearance.PageAppearance.BorderColor = clBlack
    GroupAppearance.PageAppearance.Color = 15717318
    GroupAppearance.PageAppearance.ColorTo = clBtnFace
    GroupAppearance.PageAppearance.ColorMirror = clBtnFace
    GroupAppearance.PageAppearance.ColorMirrorTo = clBtnFace
    GroupAppearance.PageAppearance.Gradient = ggVertical
    GroupAppearance.PageAppearance.GradientMirror = ggVertical
    GroupAppearance.TabAppearance.BorderColor = clHighlight
    GroupAppearance.TabAppearance.BorderColorHot = clHighlight
    GroupAppearance.TabAppearance.BorderColorSelected = clBlack
    GroupAppearance.TabAppearance.BorderColorSelectedHot = clHighlight
    GroupAppearance.TabAppearance.BorderColorDisabled = clNone
    GroupAppearance.TabAppearance.BorderColorDown = clNone
    GroupAppearance.TabAppearance.Color = clBtnFace
    GroupAppearance.TabAppearance.ColorTo = clWhite
    GroupAppearance.TabAppearance.ColorSelected = 15717318
    GroupAppearance.TabAppearance.ColorSelectedTo = 15717318
    GroupAppearance.TabAppearance.ColorDisabled = clNone
    GroupAppearance.TabAppearance.ColorDisabledTo = clNone
    GroupAppearance.TabAppearance.ColorHot = 15717318
    GroupAppearance.TabAppearance.ColorHotTo = 15717318
    GroupAppearance.TabAppearance.ColorMirror = clWhite
    GroupAppearance.TabAppearance.ColorMirrorTo = clWhite
    GroupAppearance.TabAppearance.ColorMirrorHot = 15717318
    GroupAppearance.TabAppearance.ColorMirrorHotTo = 15717318
    GroupAppearance.TabAppearance.ColorMirrorSelected = 15717318
    GroupAppearance.TabAppearance.ColorMirrorSelectedTo = 15717318
    GroupAppearance.TabAppearance.ColorMirrorDisabled = clNone
    GroupAppearance.TabAppearance.ColorMirrorDisabledTo = clNone
    GroupAppearance.TabAppearance.Font.Charset = DEFAULT_CHARSET
    GroupAppearance.TabAppearance.Font.Color = clWindowText
    GroupAppearance.TabAppearance.Font.Height = -11
    GroupAppearance.TabAppearance.Font.Name = 'Tahoma'
    GroupAppearance.TabAppearance.Font.Style = []
    GroupAppearance.TabAppearance.Gradient = ggVertical
    GroupAppearance.TabAppearance.GradientMirror = ggVertical
    GroupAppearance.TabAppearance.GradientHot = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorHot = ggVertical
    GroupAppearance.TabAppearance.GradientSelected = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorSelected = ggVertical
    GroupAppearance.TabAppearance.GradientDisabled = ggVertical
    GroupAppearance.TabAppearance.GradientMirrorDisabled = ggVertical
    GroupAppearance.TabAppearance.TextColor = clBlack
    GroupAppearance.TabAppearance.TextColorHot = clBlack
    GroupAppearance.TabAppearance.TextColorSelected = clBlack
    GroupAppearance.TabAppearance.TextColorDisabled = clWhite
    GroupAppearance.ToolBarAppearance.BorderColor = clBlack
    GroupAppearance.ToolBarAppearance.BorderColorHot = clHighlight
    GroupAppearance.ToolBarAppearance.Color.Color = clBtnFace
    GroupAppearance.ToolBarAppearance.Color.ColorTo = clBtnFace
    GroupAppearance.ToolBarAppearance.Color.Direction = gdHorizontal
    GroupAppearance.ToolBarAppearance.ColorHot.Color = 15717318
    GroupAppearance.ToolBarAppearance.ColorHot.ColorTo = 15717318
    GroupAppearance.ToolBarAppearance.ColorHot.Direction = gdHorizontal
    PageAppearance.BorderColor = clBlack
    PageAppearance.Color = clBtnFace
    PageAppearance.ColorTo = clBtnFace
    PageAppearance.ColorMirror = clBtnFace
    PageAppearance.ColorMirrorTo = clBtnFace
    PageAppearance.Gradient = ggVertical
    PageAppearance.GradientMirror = ggVertical
    PagerCaption.BorderColor = clBlack
    PagerCaption.Color = clBtnFace
    PagerCaption.ColorTo = clBtnFace
    PagerCaption.ColorMirror = clBtnFace
    PagerCaption.ColorMirrorTo = clBtnFace
    PagerCaption.Gradient = ggVertical
    PagerCaption.GradientMirror = ggVertical
    PagerCaption.TextColor = clBlue
    PagerCaption.Font.Charset = DEFAULT_CHARSET
    PagerCaption.Font.Color = clWindowText
    PagerCaption.Font.Height = -11
    PagerCaption.Font.Name = 'Segoe UI'
    PagerCaption.Font.Style = []
    QATAppearance.BorderColor = clGray
    QATAppearance.Color = clBtnFace
    QATAppearance.ColorTo = clBtnFace
    QATAppearance.FullSizeBorderColor = clGray
    QATAppearance.FullSizeColor = clBtnFace
    QATAppearance.FullSizeColorTo = clBtnFace
    RightHandleColor = clBtnFace
    RightHandleColorTo = clNone
    RightHandleColorHot = 15717318
    RightHandleColorHotTo = clNone
    RightHandleColorDown = 11899524
    RightHandleColorDownTo = clNone
    TabAppearance.BorderColor = clNone
    TabAppearance.BorderColorHot = clHighlight
    TabAppearance.BorderColorSelected = clBlack
    TabAppearance.BorderColorSelectedHot = clHighlight
    TabAppearance.BorderColorDisabled = clNone
    TabAppearance.BorderColorDown = clNone
    TabAppearance.Color = clBtnFace
    TabAppearance.ColorTo = clWhite
    TabAppearance.ColorSelected = clWhite
    TabAppearance.ColorSelectedTo = clBtnFace
    TabAppearance.ColorDisabled = clWhite
    TabAppearance.ColorDisabledTo = clSilver
    TabAppearance.ColorHot = 15717318
    TabAppearance.ColorHotTo = 15717318
    TabAppearance.ColorMirror = clWhite
    TabAppearance.ColorMirrorTo = clWhite
    TabAppearance.ColorMirrorHot = 15717318
    TabAppearance.ColorMirrorHotTo = 15717318
    TabAppearance.ColorMirrorSelected = clBtnFace
    TabAppearance.ColorMirrorSelectedTo = clBtnFace
    TabAppearance.ColorMirrorDisabled = clWhite
    TabAppearance.ColorMirrorDisabledTo = clSilver
    TabAppearance.Font.Charset = DEFAULT_CHARSET
    TabAppearance.Font.Color = clWindowText
    TabAppearance.Font.Height = -11
    TabAppearance.Font.Name = 'Segoe UI'
    TabAppearance.Font.Style = []
    TabAppearance.Gradient = ggVertical
    TabAppearance.GradientMirror = ggVertical
    TabAppearance.GradientHot = ggVertical
    TabAppearance.GradientMirrorHot = ggVertical
    TabAppearance.GradientSelected = ggVertical
    TabAppearance.GradientMirrorSelected = ggVertical
    TabAppearance.GradientDisabled = ggVertical
    TabAppearance.GradientMirrorDisabled = ggVertical
    TabAppearance.TextColor = clBlack
    TabAppearance.TextColorHot = clBlack
    TabAppearance.TextColorSelected = clBlack
    TabAppearance.TextColorDisabled = clGray
    TabAppearance.BackGround.Color = clBtnFace
    TabAppearance.BackGround.ColorTo = clBtnFace
    TabAppearance.BackGround.Direction = gdHorizontal
    Left = 278
    Top = 109
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 349
    Top = 110
    object MIRec: TMenuItem
      Caption = '&Budget Records'
      object Edit1: TMenuItem
        Tag = 2
        Caption = '&Edit'
        HelpContext = 988
        OnClick = Edit1Click
      end
      object Add1: TMenuItem
        Tag = 1
        Caption = '&Add'
        HelpContext = 988
        OnClick = Add1Click
      end
      object Delete1: TMenuItem
        Tag = 3
        Caption = '&Delete'
        HelpContext = 988
        OnClick = Edit1Click
      end
      object Valuation1: TMenuItem
        Tag = 4
        Caption = '&Valuation'
        OnClick = Edit1Click
      end
      object Valuation2: TMenuItem
        Caption = '&Generate Sales Application'
        OnClick = Valuation2Click
      end
      object UpdateBud1: TMenuItem
        Caption = '&Update Category level'
        OnClick = UpdateBud1Click
      end
      object UpdateBud3: TMenuItem
        Tag = 37
        Caption = 'Update &This Contract'
        Visible = False
        OnClick = UpdateBud2Click
      end
      object UpdateBud2: TMenuItem
        Tag = 32
        Caption = 'Update All &Contracts'
        OnClick = UpdateBud2Click
      end
      object UpdateAllCategoriesandContracts1: TMenuItem
        Caption = '&Update All Categories and Contracts'
        OnClick = UpdateAllCategoriesandContracts1Click
      end
    end
    object Showvalue1: TMenuItem
      Caption = 'Change &View to'
      object NDisp1: TMenuItem
        Caption = '&Actual Value/ Budget'
        HelpContext = 999
        OnClick = NDisp1Click
      end
      object NDisp2: TMenuItem
        Tag = 1
        Caption = '&Qty (Hrs) / Budget'
        HelpContext = 996
        OnClick = NDisp1Click
      end
      object NDisp3: TMenuItem
        Tag = 2
        Caption = 'Actual Value/ Qty / &Committed'
        HelpContext = 997
        OnClick = NDisp1Click
      end
    end
    object MIHist: TMenuItem
      Caption = '&History'
      HelpContext = 1001
      OnClick = HistBtnClick
    end
    object Graph1: TMenuItem
      Caption = '&Graph'
      HelpContext = 933
      OnClick = HistBtnClick
    end
    object Filter1: TMenuItem
      Caption = 'F&ilter Stk/Pay by Analysis Code'
      HelpContext = 936
      OnClick = Filter1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Expand1: TMenuItem
      Caption = '&Expand'
      HelpContext = 169
      object MIETL: TMenuItem
        Tag = 1
        Caption = '&This Level'
        HelpContext = 971
        OnClick = MIEALClick
      end
      object MIEAL: TMenuItem
        Tag = 2
        Caption = '&All Levels'
        HelpContext = 971
        OnClick = MIEALClick
      end
      object EntireGeneralLedger1: TMenuItem
        Tag = 3
        Caption = '&Entire Job Catagory Tree'
        HelpContext = 971
        OnClick = MIEALClick
      end
    end
    object MIColl: TMenuItem
      Caption = '&Collapse'
      HelpContext = 171
      object MICTL: TMenuItem
        Tag = 4
        Caption = '&This Level'
        HelpContext = 972
        OnClick = MIEALClick
      end
      object EntireGeneralLedger2: TMenuItem
        Tag = 5
        Caption = '&Entire Job Catagory Tree'
        HelpContext = 972
        OnClick = MIEALClick
      end
    end
    object ComparisonClone1: TMenuItem
      Caption = '&ObjectClone'
      HelpContext = 172
      OnClick = NomSplitBtnClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PropFlg: TMenuItem
      Caption = '&Properties'
      HelpContext = 65
      Hint = 'Access Colour & Font settings'
      OnClick = PropFlgClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object StoreCoordFlg: TMenuItem
      Caption = '&Save Coordinates'
      HelpContext = 177
      Hint = 'Make the current window settings permanent'
      OnClick = StoreCoordFlgClick
    end
    object N3: TMenuItem
      Caption = '-'
      Enabled = False
      Visible = False
    end
  end
  object SBSPopupMenu1: TSBSPopupMenu
    Left = 202
    Top = 108
    object StockCode1: TMenuItem
      Caption = '&Stock Code'
      OnClick = TimeRate1Click
    end
    object TimeRate1: TMenuItem
      Tag = 1
      Caption = '&Time Rate'
      OnClick = TimeRate1Click
    end
  end
end
