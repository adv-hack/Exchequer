object CCDepView: TCCDepView
  Left = 407
  Top = 183
  Width = 392
  Height = 361
  Caption = 'Cost Center/Department Breakdown'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object NLDPanel: TSBSPanel
    Left = 3
    Top = 48
    Width = 146
    Height = 19
    Alignment = taLeftJustify
    BevelOuter = bvLowered
    Caption = 'Cost Centre/Department'
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
    Left = 152
    Top = 48
    Width = 116
    Height = 19
    Alignment = taRightJustify
    BevelOuter = bvLowered
    Caption = 'Value '
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
    Left = 270
    Top = 48
    Width = 83
    Height = 19
    Alignment = taRightJustify
    BevelOuter = bvLowered
    Caption = '% of Total '
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
    Left = 3
    Top = 70
    Width = 374
    Height = 222
    OnExpand = NLOLineExpand
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
      080000000000000100001F2E00001F2E00000001000000000000893B0C00893C
      0E0090461A0091481E009851270098532A00A1633F00A76B4600A9704F00AE73
      4E00B57E5B00C4852900BE884500D6A55B00C0977F00D7A96500D9AF6F00D9AF
      7000DAB17300DBB37700DBB37800DBB47A00DBB57C00DCB57D00DCB67F00DCB7
      7F00352DED00FF00FF008E7DCC008E7ECF00B48F8000CDB08F00CFAD9800D8B2
      9400D0B19F00E3BD8400DFBCA100DCBEAA00CCB5B900E4C08A00E7C38E00E6C5
      9400E7C89B00EACA9800E8C99C00E8C99D00EBCC9E00DEC6B600EACFA800EAD0
      AA00F1D6AD00F1D7AF00E8CDB800EBD4B200ECD6B500EED2BA00ECD7B900EDD9
      BB00F2D9B300A693C400AA9CD700C1AFC900C5AFC800D2C5DA00E6D2C500F2DF
      C300F0D9C500F5DDC600EEDFD500F5E0C200F2E1C700F3E1C800F6E5CD00F4E4
      CE00F7E4D200F7EAD700F9EAD600F9EAD800F9EDDD00FAEEDE00F5EBE400FAEF
      E000FAEEE300FAF0E200FBF2E600FCF3E700F7F2EF00FCF5EC00FDF7F000FDF8
      F200FDF8F300FDFAF600FEFDFB00FFFFFF000000000000000000000000000000
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
      00000000000000000000000000000000000000000000000000001B1B1B1B1B1B
      1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B0B0B0B
      0B0B0B0B0B0B0B0B0B1B1B1B0B2832324E55514D484532322B0B1B1B0B3B1C3B
      41151312102A230D0D0B1B1B0B3A3232535857544F4C3232330B1B1B0B3C1D3B
      461817151330230D0F0B1B1B0B3F3D264B39383635472B272D0B1B0505050505
      0505050505492E2C310B0543434343434343434343052911140B434337212443
      4337212443430555590B4A42000A02344A040904344A0516190B522507525252
      250552525252055B5C0B5A400350205A4401442F505A051E0C0B5D5D0E060856
      5D220608565D1F1A3E0B1B5D5D5D5D5D5D5D5D5D5D0B0B0B0B1B}
    PictureLeaf2.Data = {
      36050000424D3605000000000000360400002800000010000000100000000100
      080000000000000100001F2E00001F2E0000000100000000000090461A00BA73
      080098532A0099552D009F5C3400A05F3800A0613C00A1633F00C4852900C48B
      3600BE884500B1835000B6836300BD926600C6914500C7975400CA9A5400D6A5
      5B00C0977F00C59B7F00D7A96500D9AF6F00D9AF7000DAB17300DBB37700DBB3
      7800DBB47A00DBB57C00DCB57D00DCB67D00DCB67F00DCB77F00352DED00FF00
      FF008E7DCC008E7ECF00B48F8000D1AC8C00CDB08F00DCB78000DCB88100DCB8
      8200D8B29400DDB49800DAB79D00E3BD8400D6B9A700DCBEAA00CCB5B900E4C0
      8A00E7C38E00E6C59400E7C89B00EACA9800E8C99C00E8C99D00EBCC9E00DEC6
      B600EACFA800EAD0AA00EBD1AC00F1D6AD00F1D7AF00EBD4B200ECD5B500ECD6
      B500ECD6B600EED2BA00ECD7B900ECD8B900ECD8BA00EDD9BB00EDDABD00F2D9
      B300A693C400AA9CD700C1AFC900C5AFC800D2C5DA00E6D2C500E7D8CF00F2DF
      C300F0D9C500F5DDC600F5E0C200F2E1C700F3E1C800F6E5CD00F4E4CE00F7E4
      D200F7EAD700F9EAD600F9EAD700F7EAD900F9EAD800F9EDDD00FAEEDE00FAEF
      E000FAEEE300FAF0E200FBF2E600FCF3E700FCF5EC00FCF6EE00FDF7F000FDF8
      F200FDF8F300FDF9F300FDFAF600FEFCF800FEFCFA00FEFCFB00FEFDFB00FEFD
      FC00FFFEFD00FFFFFF0000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000212121212121
      2121212121212121212121212121212121212121212121212121212121080808
      08080808080808080821212108323D3D5F65615E57543D3D35082121084A224A
      511A181715342D111108212108493D3D63686664605B3D3D3E082121084B234A
      551E1C1A183A2D1114082121084E4C305A4744413F5635313708210202020202
      5D484745425838363B080253535353530228271F1D403316190853432A2A5353
      53026F6D6C6B5C656908592C000400525902292827463C1B1F08622F05620C13
      620272716E6D676C70086A39064F032E6A0201090F0E10240A08735007071273
      732B2B250B0D26204D0821737373737308080808080808080821}
    ParentFont = False
    PopupMenu = PopupMenu1
    ScrollBars = ssVertical
    ShowValCol = 2
    OnNeedValue = NLOLineNeedValue
    TreeColor = clNavy
    Data = {3F00}
  end
  object AdvDockPanel: TAdvDockPanel
    Left = 0
    Top = 0
    Width = 377
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
      Width = 371
      Height = 44
      AllowFloating = False
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
      object AdvToolBarSeparator2: TAdvToolBarSeparator
        Left = 122
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object GraphBtn: TAdvGlowButton
        Left = 2
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Show Graph|Displays the Graph window for the G/L account or head' +
          'ing currently selected'
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
        TabOrder = 0
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
        Left = 42
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Show G/L History|Displays period and year-to-date balances for t' +
          'he General Ledger record or group selected'
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
        TabOrder = 1
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
      object ReconBtn: TAdvGlowButton
        Left = 82
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Show Reconciliation screen|Displays list of transactions which c' +
          'an be reconciled'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA793000002DA494441545809ED564D
          685341109E7DD15A9A7830050FFEB4088237F1921F7F2EDAD04BF3D394C69F5A
          DB0822C583527AD15BAE5E447BF0A245B188686A9B3FF5207810252D5A3C796F
          0D1EAD4893A069F3C66F9F647969AB4DCD1305136677676627F3CD9B9D9DF788
          1ABFFF290381C9B03F980CEE373FB36616ACE001B09598C44A5F5DC96090053F
          D675EDB93FEDDF59D9B7340080EF00C01B7FA2FB762C1653BE0389509FD0B549
          80360916773281CC47F0066D32664CD767BE4510F723B01B22C13471C9B32522
          FFB44CB417A86DE0F7BD3DF0AE844C5C0824BA4F32D33DE86C00BF9AEE99BA0C
          5E91A6380B98A7A1D44B8074C2559E580C01FC35138D43B661DC4887A7AE60AD
          2295018D458E8927AA766B1074E2ACD90C4FF8AA2B11EA85BF14C00F1A7BCCB7
          32E1E430320C95A151D3AA62513B7532FE647888996F12F1EC9350D2BD16789D
          10EBFFBD2B19EE411D587ACCEBA3FEC2A2D107909C9FF781D1E9E22E5DD87E54
          2D2C6B25547BEEA2B7695ADAFF4E1F50B7C08A462483C0391F41CB7D06DE01E7
          59DC3B3778A30F64BA13ABAEA2E5152AFB0002E8057809E032A336927D600D70
          0486DB29670C2B8E006E1435FA804AC5DF60163B0F6D5F89BB964EDA585E8405
          9F2724CACBF3799F7B4002C8913FE639035D6EB1C37542CAE6A1DE8666653D3C
          EB7C1CA5DD8C77C0D8A2CFF595482BE3168CC1E766415A18EB430C452A80D1E9
          9217D76744EDD4C8C8D7F1B0A7F95AC5DCDEDA3E5058F8A0E32DD88F6F830744
          6049C84CDFB73BDB0689662AA6C6AA02D005EF46E4BD867603133A6195B588C7
          CB1C89448B9FE6F6B01087094ED113B22DCEF641B957650C414686C55A2A2CCC
          9D02B8B7E29589DC85CFF3A72BB279457066B17E3EDFE1EAC753DF25227440C2
          1168F846D6FB20A316C459C78B9971F08AFE4006C45178B7A19E52F6D642D4FE
          65298A0C24A48E047760AD22CB03B03BDBCF0361C4B1AD1811F1F725313BBBE4
          7016E4F51BB1975BCE61AF41FF5606BE03A555273023C6E2BA0000000049454E
          44AE426082}
        Position = bpRight
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
      object Panel2: TPanel
        Left = 132
        Top = 2
        Width = 86
        Height = 39
        BevelOuter = bvNone
        TabOrder = 3
        object Button1: TButton
          Left = 2
          Top = 10
          Width = 80
          Height = 21
          HelpContext = 24
          Cancel = True
          Caption = 'C&lose'
          ModalResult = 2
          TabOrder = 0
          OnClick = ClsI1BtnClick
        end
      end
    end
  end
  object SBSPanel1: TSBSPanel
    Left = 0
    Top = 292
    Width = 377
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    DesignSize = (
      377
      32)
    object Bevel6: TBevel
      Left = 3
      Top = 1
      Width = 639
      Height = 2
    end
    object GlValueF: TCurrencyEdit
      Left = 152
      Top = 8
      Width = 116
      Height = 22
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'ARIAL'
      Font.Style = []
      Lines.Strings = (
        '0.00 ')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      AutoSize = False
      BlockNegative = False
      BlankOnZero = False
      DisplayFormat = '###,###,##0.00 ;###,###,##0.00-'
      ShowCurrency = True
      TextId = 0
      Value = 1E-10
    end
    object GLCaption: TSBSPanel
      Left = 3
      Top = 8
      Width = 146
      Height = 21
      Alignment = taLeftJustify
      BevelOuter = bvLowered
      Caption = 'G/L'
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
      Purpose = puFrame
    end
    object OptBtn: TButton
      Left = 274
      Top = 9
      Width = 80
      Height = 21
      Hint = 
        'General Ledger record options|Gives access to options for ammend' +
        'ing General Ledger Records.'
      Anchors = [akRight, akBottom]
      Caption = '&Options'
      TabOrder = 2
      OnClick = OptBtnClick
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 11
    Top = 76
    object MIHist: TMenuItem
      Caption = '&History'
      HelpContext = 180
      Hint = 
        'Displays period and year-to-date balances for the General Ledger' +
        ' record or group selected'
      OnClick = HistBtnClick
    end
    object Graph1: TMenuItem
      Caption = '&Graph'
      HelpContext = 182
      Hint = 
        'Displays the Graph window for the G/L account or heading current' +
        'ly selected'
      OnClick = HistBtnClick
    end
    object Recon1: TMenuItem
      Caption = '&Reconcile'
      Hint = 'Drills down to the currently highlighted G/L Code'
      OnClick = HistBtnClick
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
    CompactGlowButtonAppearance.Color = clBtnFace
    CompactGlowButtonAppearance.ColorTo = clBtnFace
    CompactGlowButtonAppearance.ColorChecked = 12179676
    CompactGlowButtonAppearance.ColorCheckedTo = 12179676
    CompactGlowButtonAppearance.ColorDisabled = 15921906
    CompactGlowButtonAppearance.ColorDisabledTo = 15921906
    CompactGlowButtonAppearance.ColorDown = 11899524
    CompactGlowButtonAppearance.ColorDownTo = 11899524
    CompactGlowButtonAppearance.ColorHot = 15717318
    CompactGlowButtonAppearance.ColorHotTo = 15717318
    CompactGlowButtonAppearance.ColorMirror = clBtnFace
    CompactGlowButtonAppearance.ColorMirrorTo = clBtnFace
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
    Left = 308
    Top = 104
  end
end
