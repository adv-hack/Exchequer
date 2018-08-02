object frmMain: TfrmMain
  Left = 100
  Top = 297
  Width = 768
  Height = 480
  HelpContext = 13
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'Xchequer Importer v6.00.nnn'
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  ShowHint = True
  WindowState = wsMaximized
  WindowMenu = Window1
  OnClose = FormClose
  OnCreate = FormCreate
  OnShortCut = FormShortCut
  PixelsPerInch = 96
  TextHeight = 13
  object imgBackground: TImage
    Left = 152
    Top = 85
    Width = 525
    Height = 232
  end
  object StatusPanel: TPanel
    Left = 0
    Top = 403
    Width = 760
    Height = 26
    Align = alBottom
    TabOrder = 0
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 141
      Height = 24
      Align = alLeft
      TabOrder = 0
      object Panel2: TPanel
        Left = 2
        Top = 1
        Width = 68
        Height = 22
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 0
        object Gauge1: TGauge
          Left = 3
          Top = 3
          Width = 62
          Height = 16
          Hint = 
            '|Shows the amount of free disk space available on the system dat' +
            'a drive'
          BackColor = clBtnFace
          BorderStyle = bsNone
          Color = clBlack
          ForeColor = clNavy
          ParentColor = False
          Progress = 85
        end
      end
      object Panel3: TPanel
        Left = 71
        Top = 1
        Width = 68
        Height = 22
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 1
        object Gauge2: TGauge
          Left = 3
          Top = 3
          Width = 62
          Height = 16
          Hint = '|Shows the progress of the current Import Job'
          BackColor = clBtnFace
          BorderStyle = bsNone
          Color = clBlack
          ForeColor = clNavy
          ParentColor = False
          Progress = 0
        end
      end
    end
    object Panel5: TPanel
      Left = 142
      Top = 1
      Width = 617
      Height = 24
      Align = alClient
      BevelInner = bvRaised
      BevelOuter = bvNone
      TabOrder = 1
      object StatusBar: TStatusBar
        Left = 1
        Top = -1
        Width = 615
        Height = 24
        Panels = <
          item
            Alignment = taCenter
            Text = '08/09/2005'
            Width = 65
          end
          item
            Alignment = taCenter
            Width = 65
          end
          item
            Width = 50
          end>
        SimplePanel = False
      end
    end
  end
  object SpeedPanelv6: TAdvDockPanel
    Left = 0
    Top = 0
    Width = 760
    Height = 46
    MinimumSize = 3
    LockHeight = False
    Persistence.Location = plRegistry
    Persistence.Enabled = False
    UseRunTimeHeight = True
    Version = '2.9.0.0'
    Visible = False
    object AdvToolBar: TAdvToolBar
      Left = 3
      Top = 1
      Width = 754
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
      ParentStyler = False
      ParentOptionPicture = True
      ToolBarIndex = -1
      object AdvToolBarSeparator1: TAdvToolBarSeparator
        Left = 89
        Top = 2
        Width = 10
        Height = 39
        LineColor = clBtnShadow
      end
      object AdvToolBarSeparator2: TAdvToolBarSeparator
        Left = 309
        Top = 2
        Width = 10
        Height = 39
        LineColor = clBtnShadow
      end
      object AdvToolBarSeparator3: TAdvToolBarSeparator
        Left = 179
        Top = 2
        Width = 10
        Height = 39
        LineColor = clBtnShadow
      end
      object btnDefaultSettings: TAdvGlowButton
        Left = 319
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Default Settings'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA7930000050B494441545809E5565D
          681C55143E77EE6EFE76D3FC27354D83BE49F5457C507CAA600A826011F3D006
          EC26D050440DDAFC349AA4A3696CFE84BE282448DC147C697CF007B4F449149F
          6C4151A1C5071BAB6993D674F3B349BA3B33D7EFCEE44E666766F3F3282EE7DC
          73CE77CEB9E7FECF12FDDF7F6CAF0BD0AEEB251B56F153114BE3DE5C53D304D3
          B46B49FDCD9417DF498FEC14E0F7678CD8EB1AA361CB3774262C22CB9A40FC29
          F0AE49DB75E466A060D4B0A90685A08341707B64CF0360C4EAB6E9723B5F685A
          E800DADB27A2CDBA5E109A41A2361CB7D11ABBF535CDCD97785BF748A90FB64D
          DF4EDA1825FAC72E0BA2271989498D8B0FA7F49EB9843EFE2899E22CF0979194
          EFECC04D5F13B17793839D3F1E3F73BE221AE527B16AAFA1E795344F3F31A3EB
          19E82EA12F57B795D681B11785A0CF6DC3693282D8150CE63998456090A06C26
          43C234A113693C4291829C053391F30D729E45400CEC90A0EEE4B9AE31C7705A
          E608A795572C63C6AEC33A080E90C0495F4DDDA7F4F212994636C7CF23118AED
          2BA77879053116BAB3327E9DB87128A9F7DEA4CD5F4E64C62C79037868710333
          5EB875939617EF058A23079861FB166ECD9291CD5965E9565C4C6664481952BA
          2BD0A68FD49BA67603405C3ABC6C64B374F7EF59B23697DCEB0BD335CEA9E640
          2345A239DBA242B190ECF0F450E77712D06423D934F90B61C589042DCECFEDBA
          B8EC4B0E7471FE36547926217289312E8E2BC81D40E17CE92738BDC370586097
          36D269CA3ED8706DA530469749885336E3902A5C4999B3B19656A62B05D1675C
          E36F2B009356AA23137D638789D14558F65958BC3347EBE915985B84E2C3573E
          FDB8770B216A3A76728498E8F662C5F152AAACABB721145EC5ADE8480E764FD9
          C066A36D4A57E09A7C8B557F450119DFEC51FCCE3F316D40F9952C3752FDD017
          C02E6537B6560E333DEB2F2E03030390206E519994922DD390C265BC113F5F9B
          9CCCBD83F0CECCCC6488D84F505D323DB998BDDBA71B002574002659CBF0D9A4
          69BE1041076C4778D3E085F179764D4B686E9F2E08C5D73B51421FDDCF047F0B
          3E9BB8FF2A317AACA9A5ED88EDF434475A4E3E4F240E79205CC342D7644C1C4B
          E8E71F26DF0F5BB3852406469B85601F01AC56E8EAD2222DDDBBAB4C2553E8F0
          34CB384FB615A197F0FC8DC399B3CC65D5B5142FAB00ECD27D1CF013C9F7BABE
          52086A396AA26FBC03A7F882636DB59665D1FC9F7FE01D30B6C05D683C12A5BA
          C647302EB784CA12426847A7CF9DFE5202EE1608266E4BC0CFF20C54D4D4FAE1
          1DED72CC9EE1CA84040A2E8C3985BB03981EEC9C01F83D384045B1522AAB91FF
          3502B309C4CA9AE5882D8AC5033E076017A7867AAE3A3ABEA44AC115C2B74EEB
          806D820314C797AEA6BE81A20545019F02A2858554F550A3FD5554984F2E13B7
          721EB0C0945AFB4727F02D6FF726E215331018515866639D1EE099350CE75CF0
          68948A4A4AA8A0B05885E02DA39C1CE910247AA607BB47A5AED8DD02059061F4
          414F814930924BD562F0C22A9CDE1160EB602A282AA6D2CA6AAAA8DD6FF3BE8A
          2A6FF1141E9D2E99C3847815F137C0927E5FE36B17A4E2654CCC6B3A7AE29D0F
          9E169AC931DA1F1CC4695B7BDFAF1191E8755895E000E195FC9567AC67A6467B
          569453D7756DD68A3759C2F86B7AF0CC6F0A57327400CA19264FF48DFD8283F6
          78980FD817C9C1AEA390BBA6E016EC908A07683E5F08963EAF2F5FCE9E0780DB
          92B788602CAF2FDF00DC939D2FC08F639693C056C13984E2826B742907FC2F18
          FF026805904CB0A2EB1C0000000049454E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 0
        OnClick = btnDefaultSettingsClick
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
      object ExitBtn: TAdvGlowButton
        Left = 359
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Exit from Importer'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA793000003C3494441545809ED574B
          48545118FECF99711E4D0F955AF420098A287A88D6449131A55650104112B932
          6B93BAC8C72693AC080BA1A06DD4A20751AD5A58183E4A28AA6924298A08825E
          D6AE929C5169E6FEFDFF19AFDE3B73E73A63469B2EE73FE77F7CFFE3FCE778E7
          0AF0FFF9C71D1099E61F08AC5F2C656CBB90980728E62A7F815F11E5FB1846DB
          B3BB7BDF295D9A535A0560599923F2ED430502D451DCE54476E3151576D6B7E9
          E965711C343B20DB262C205CEA5F831A5C22F02AA24C469F105AA5AF33F4DCCE
          49DA19C325EB2A29F923C2649A9C5C209F8EE531C7602115A5ECC06089BF1C10
          AE91634A0CD9D2198880FB66743DBB6905B60C1ED9B2C6AF09D9430E1EA2A918
          43421345BEFB4F7B1383251D0116166651F22B049CAAE4140ABC28F12A06024E
          168C248D02F3916C4725AD4B8992869895038E8D0148F538376E06C6A4B02F8B
          C84805243C3241A66387AA441DCB62F61CF09CBF009EE63390B56B0FAB4CC43A
          77F3698561ACC9382AA080EA51766C31153050BA6E09592C6FBC63453EC8F90B
          008400574D3D38B7ED24687C38B7EF543AB63186B1714BD29C3FB4D5BFC8A835
          9D8953C32DF4B231DAC7F8E8830EC5BB8F9C007038C0DDD004C2EB553A5775BD
          2A0C62311839DD0C3A561913262D0AC5A4BA48A486A9000D60A1506AEB490FAC
          17E1AA6900A03F32DEB94ADE720CA23D9DD6CEA35A0D44DE28AB16D3110881F1
          77BB32594F5C04EF12342A97217424CC8FA4913C0EC779BCEA642A0050DA3540
          F701919D136FB9AE21379193AB4BF6ABA0AB6840988E0005F60B34582DD8ACDD
          7BC155551B2F40EF8294E0AAAE53E85FB76FA935D544AFE7CF469BD32848844F
          76F94DC9F9C251DBD9DFDD78525DCC748A90881FD947275301021D6D28625C43
          D2513803A5B4F3C3F19DD32FD4C8B996F10BE7F580BBFE28D9B813B5803FBEA7
          FA4B407064DDD593F32A79D2695AF7E37EBAD6963F9FB1D013D0DEBE0175DB4F
          3541F45E9BEE06D1F63618211DDB18C3D831A39909F93A1E7D31AA4C1D60036D
          BF95B67F837923E1E04F186EAC03B97235C41E3E80C427DAD345C569107BD907
          8C4DB4B38C205A793512E5328AB47F6A64B8786D889602B3E5CF24DAD893E95D
          C10D9490D8F158729C8D730CA08B7288A461A2A91A435213351C3B316052010C
          98D61D0A828003C49BAA25793283DE95B8DFEA5B80835151BC5853B8C4BF83BC
          AF937526D164C6007D88945372D3CD3706B2EC800EF07506EF08A97E3C5EE8BA
          0C56FE28DD6C979C63D916C0005F4730E4CBCD2BA0561D24F935D144833FCB2B
          7D45C1C289BE883910C5E5257D9AEA7F4CD2CFFC1FF9973AF01BC3A93A31C7AA
          E12B0000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 1
        OnClick = ExitBtnClick
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
      object btnOpenScheduler: TAdvGlowButton
        Left = 189
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Open Scheduler'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA7930000055F494441545809ED567D
          4C5357143FF7BDB65A810545371902D5F19118C8223CC0B80D044920E090B860
          A6D9A6D328D3B94D43F6D7A221308C59164836E2168CC4250EB3B8B9295DA6C6
          5164C414A1AB011D1BF221F221A0B0694655DABEBB731E6D6D4B2D207F2DF1E5
          FCEEF9DDF371EFE97DF7DE578067CF1C56605561B894B03B22710E438030DBE4
          CE91CB519D779BF6EEACC83709026B66002D855FBCD17CE3AEF1FDF39D47665D
          8C6A260570CE85EEB1A66D1CA008E357027068EF6D473A297FF45C971803A97B
          A815CAEBB63C581C105E136EC97E2F3D3DDD3619F1E476DA15E8BC634CEC1A6B
          32E3E4C770189C1C5B94C8A591D84E4AE4521DD06379740FC6C687B41D23CD3B
          4CF6AFEFD75C2DDE44767F10FD39BB468DDB01D869601046718C0910A0590822
          13212E6A25C8B20C311131F04ECE5608D206835A980F43F73AC1CE6DF0D06651
          8FFD3B58B073FFE6D0D3471BF494EF0BF80A7D99010EE8D7BD691F5A54F456CE
          8792669E1A02352110B22002548206649CE0AEE5168C4F8C2AC901E85BBC2012
          042CCC6A7F080D5D27A1BEE384E263C06499CB1BCBF20C67148357E3B3800367
          D72571C62FE1BBD736568FDCFCF2F0715D7CACE495EABFDB3D6A86E34D1F732E
          739AE381CCE4E443EBEBAF796709DE86E2E26201273F8A762DC39D55F1F991C1
          BDBB8AC06030A069E6B22264156C4DFEACC191A115B8F0CDAE9644B5A3EF5253
          F6C02B45E2162C790F45A42CCF6F4E8BDDB47ACD9A35909D9D0D5AAD16525252
          C835232C5A10AA1B7FF477CBC0BD8E17312134705CDBD150D3D38ADC25828B39
          0803BE9FA828A8267256EE59463C363616AAABAB61DFBE7D5058580856AB95CC
          33426EDC07A1B8376C14CC65F888B43B3C0AF8E4E78C4874262060B56E830913
          438913F2F2F2E0E0C18350555505191919303C3C4CE6698163842547E6352B81
          8C4BC53FAED581DBE35180C07916FA180292741B144DDC092AA0A0A0001A1B1B
          41922430994C4E975F9DACCB73F96DA2B8CED541E25100071681364582E7BF10
          AE10B7863625AD404C4C0CF4F7F7435A5A1A545656BA45F8A6B817C29C1EC6E4
          182727ED5100DEB0B459C80EB807162AC4AB090E0E06BD5E0F414141F0525210
          1CFDE110B4B5B57945797645411DE2B4C88C3DEFE4A43D0AC013EBBEEC9C027C
          213A3A1A4A4A4AD045E1B86DF913433106BF1C78A128041BC6F167A2768ACA49
          48E37003A4097679E28E28680288FB029D88CCCC4CA0B1E3E3E37D85B86C7873
          8E60271081C2FAB17189CAC588C8AC0FB044A2639691DB4B0297E9C0CF131717
          E7C7FBD835363E3884BD1508FCACF05BA49D109C843417F939D4CA7A9AFA6A15
          8DFD39CB95DE5A5C5C65182EDB55E715E6683C0A28CBADEB45BB1901C69E9F24
          995B7B88CF0536D97AE34AEF19C931464B59FE853E075794470164C1A35641DA
          2EDB34B5D72AE9DD71EA3F25F8D9D6F27FF06BA8A67C1CBB9CB43BA614509AFB
          EBB718F03B025A7AF5296D038606E24F83D6818B0DE6FE0B4993B9CC88637F37
          C91FB7C263EA6074AA007663EF01024E99CB52FF1A36D6C32C9F3F872E5FFADE
          7C38D59166C10B682FED4047DFA544177323BF9DEC19786DF3F26EFC1A6F4433
          6B1DACD35926EE1BA3964880FF8A9E43DB1345E6F63EFDB5CAF673ED5FBD8A41
          0C815F77FE76E9EB868BC8A708054C313A0DF4AF08CF7935F6B508FCCBA57E94
          BC7C83695558165F14B86CA95AD02857AC559E18181DEFBF6DEEFB456CBE599B
          6095ADF3281E61C1CB6D5BD9FABA53C87D8ADF0228E3803E3D9173760CF9CB88
          D9885916E4ED8772EBAFFA4B9ABA07BCA24BD71B4C2A536A02637C07BAAE23A6
          93EB7897BD8B39D27493D340D3AE0005B9A3F8CCDA289B206661413A7C3DA1E4
          C3E3751B57E926E045F6694E5D17D99EE17FB302FF01CEE8CD0B06697DF90000
          000049454E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 2
        OnClick = btnOpenSchedulerClick
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
      object OpenJobQueue: TAdvGlowButton
        Left = 229
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Open Job Queue'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA79300000106494441545809ED5641
          0E823010DC128F125F6022BE42FEA1FE418EFA0E3DD63F08FFD057A8092F3078
          A6EE5430D67A6B03074A98EC94946D3B9D364B149EA12B207E054864A5F43741
          C56D13AFC093639593A225B82B6E596C8C19B92674FD7F6425E095E39B50E28C
          08802BF11606ED009F0A188640626D382690FD9A8D0F4C692E9F5BDE8214DC15
          ADB1DB3CB6071AB7F3806D1F629EFA3A059FA40DE9FD1434F31870B04D282B7D
          FB29AACB7B36B9409B997C2C0445537057F04D987FE7B04D4874420721A282A3
          9E0CF39D47131A8BEEDD84FF1458F3CA49A9BA440498EF790BB4326807F854C0
          300412877A80423D00237408DB8428407902A11E6011C21B14E84481177A315D
          3FCA7B2AE30000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 3
        OnClick = btnOpenJobQueueClick
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
      object btnViewLogs: TAdvGlowButton
        Left = 269
        Top = 2
        Width = 40
        Height = 40
        Hint = 'View the import logs'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000002704944415458C3ED954D4854511480BFF7DEE8731C251CCD2615078C
          F0A726133424B4FF85426016D122C8DCA6651095443F2EEC470AD268E74282A0
          12425A280541398621B8A8663139E95091592E1CDF68C3CCE89BD76250086731
          4E6F8CCAB3BBE79E7BCF77CFCF3DF0BF8B1049B9B3B6AF1BB4C3B15CA8A135DB
          7BF6B7456B2FEAF5125B81993C6B2A02C28D5D077B5B561CC06432D072A684A2
          FC34348D2BD142887AE65396259A1B6C6C5A0684A87751C9B2C4F9461B9B0BA2
          8310E351D972A2C4B986E820C478B5D70284ADC01C8638D0D718C9CEA09743E7
          87695A6FBF5DA2F707E6C3ED29B003B81B3700C51BC4E19D5AF6B9B8A5E0DF00
          902481E2223372A2F46700524C0974B49663C934C60D20E6221404D85268C61F
          501919537E9D0B8569884278CE85340D87D3A32F40B625998ED672A6952049B2
          C4EC8F399A2E0D11D2343A6F55E0722B84421A55BB73E8BC3FA23F40DD918DB8
          DC5E2E5C1B469204BADA2BA9A9CA656454C19269E478931D80EDA5EB70B915FD
          53909B9D42FFE00400AAAAF17E5421CF9ACAB397E384548DEA3D39CCAB1AA208
          2EB757FF369C9A0E90BDDEB4B8B6AC3532E509A078830C0E4F92BF610D99E949
          D49F1E40F1067F3F02B5D5563C4A00805743DF79D033C6CDCBDB08CEA9241B0D
          E45953B97EE71D00A5C5193C1FF88AC120B0AF328BA72FBEE05182B145C0EF57
          E97AE85A74BE200EA787FAA6F0EBDC9F66A83B656762D247D9D60C3E8FCF3233
          1B7658624BA7ED6259EC11080455EE758F46DC9B98F42DD9ABA9B2D2FFFA1B8F
          7B3F02B0B7228BA38736C4E71F88248F9EB8397BC24665B985C404119F6F9EAB
          ED6F560EC0E1F470ECA47D751AAE02FC5D00ABF213F983E443F6CC05FE000000
          0049454E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 4
        OnClick = btnViewLogsClick
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
      object btnNewFieldMap: TAdvGlowButton
        Left = 99
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Create a new Field Map'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000001914944415458C363601805231D30A20B58FB6DE465656275FECFF88F
          95BA16317EFF2C2ABEF3EC2C93DFC8E22CE80A59985942FE33FC9F87C56D1481
          FF0C0C0C7CAF5F393030301C441667C254F99F9556C1FD9F09335499063A0D60
          44815FA48EAD9EA9344D2C3B7DE4A1D181B50C7B0655086038404C82F72EAD2C
          939113BC4F300A24E5789FFDFF8F2AB6F2C42B06012E16067B2D0186893B9E10
          6599811C0F83BB9E108A98942CDF7B820EC006D8599918D858981818FF333070
          B33313E500361626F212213610602C0267E7B84AD3361760039D5B1E3188F1B1
          32849B8B3164CCBF4594C18E5A020C897692D47140B8B918031B0B13031B2B13
          43B98F1C510E10E466A55E08FCFCF38F81811152387FFDF99728832505D9A8E7
          800D67DFC0A360CAEEA704D5CB89B033288B71522F0A90837D518626FD132139
          E540ACB50483146634183230A016C5342B07A81A02A49403CCFFBF31FC65E4C2
          2AF78F91F101DDCA818E70656C5140BF7280AA51A020CA01676BCB70D3B63A1E
          F0F6C08037C9FE32FEDDCDF89F356CB4C7320AE80500440F5AEA9A6BCF8E0000
          000049454E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 5
        OnClick = btnNewFieldMapClick
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
      object btnOpenFieldMap: TAdvGlowButton
        Left = 139
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Open Field Map'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000003C64944415458C3ED97C96F1C4514C67FAFBA7A999EC5F6783C3636DE
          89080E4B726091B0420E40A200221C1117A4886B8EB905A448F90790B821212E
          488090384462554088438C4888002BE084380EB127768CB11DC7638F67BA388C
          B7B1C7B3B47DE41DBA35D5F55E7DF5BDF7BEAA1180C3AF9EB79428C74800206C
          98D9F27BAB9972F3053179C75DFEF1E3E703AA981C3E715E010744E465306A07
          00A6BE71C9A1AC4F8D65DDFCE193174C25005A446CE015E05CE5CDD667121432
          CA146E032B1501600C8085ECDDE24504469B1A42EA2707BB2CDBB1BAE28DDE9E
          AE3F3F9B6DCB2DE7D5F79F5501F0406742F95127FDD040CB9E0218199E4ACEFD
          9B555519686AF603D7D377D8636B4AFA53AEA3AB7681EEEC6D281818DF3C78ED
          4E96BF26B30C3CE873656C81B1E9A58A4152719B67F735D095DA4863AA353A2D
          E9687500A244048CD9D42C8E16A29E856D29E29EA6296A570C9288686C5DCAB6
          12A9A9A97459FAA21A4B0971CFA23FED914EEC006055093C4711F7AC72225513
          806D1333B33946328B3CD615E3D2E83D46A7B2EB9304C16C7149271C9EDBDF48
          AC1484D40A609BB5261C5CAD688ED91CEC8ED19F8E540C12F32CD20D76A8622D
          0B20335764E08955066E4C65770CE06A4547D2C5B61274A7AC5029D846557B93
          43CCB5688A6A9EEE4F70A023BA4DFCD7DE4A09BE5364AB4C858463E09F7B2BDC
          BCBBC4C3ED3E572716F97B66B9E259B8AF35424BDCD9FAB50FB0AA9F053B5065
          561FB2692B0670586690CF39281770A4082C3AA750B71E65A2E734397B5D51ED
          5A58289B82B60687444413F32C0EF5C478A4C3674D275AB297383EF6363AD854
          173930990B7864B9DE7B8EBC6E2010C900D5EF03DF8EE65CE0B43172766D7078
          FC3E7F4C2C72A83BC6D0F579AE4D6E2C76C4F982B3F153610A3E0F5C044ECA9B
          8C5464A0AF25427BA38BEF2A8E3E9EE4487E234BDDB349B815BAE39E015E8252
          00DB6A20E228224E515ADD58A9C436AE9456FB8DEE3365578B2F5CFEB279E69B
          9F95C915B67CFAA56A1754CCD926BC93ED6FD0271F82EF6F9F18E518AD7DC7CA
          8478CBFC24EFC85357DF07D08104058C7C07EA4C2D00A2F77F1F005E07481686
          A6F1FD549D7B68077312280278B1C7CB7F35BA342470B916EFCEF1F75E5B0360
          BBB959D0A910F5B0509282A3BDDE4A35C158D7870FC815C54186F11C2BE47DE5
          CAFAB11DC2B958045A6B0AC1FE10FE0198DF7603A0D8B6AE03561877668189DD
          0058BD36396059E10088EC0280620C58C48F8C85FC2F3143C0EDD03A80F02B01
          A730E65D8260B94EE779443E62C5DCABEBCC2E5B895FB79DC071EABB0689BA8B
          E55E94C13F97F8DF56ED3F6B4511A1CEE541070000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 6
        OnClick = btnOpenFieldMapClick
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
      object btnNewJob: TAdvGlowButton
        Left = 9
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Create a new Import Job'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA793000001CF494441545809636018
          E980115B004C38FD7315C37F86506C7204C5FE33541498B37712540755C004A5
          A94229093133B0303374F49FFCD9C04024A0AA0344B818186C155818D85918EA
          897504551D00F2B40027238335098EA0BA03C08EE06064B021D211347100C811
          FC50477010880E9A3900DD11134EFFC80189A1631674014AF8375FFF6378F0FE
          3F86112CCC8C0C3FFF31D80125A600310AA2AA033EFE045A0EC228564039584B
          1C06069A4601D46ABCD4A803A81202272E3E63F8FCF537DEA0C6254915073C7B
          FD8561F6BA8B0C8F5E7CC2650F4E71AA380064FAF71FBF19966DBBCE70E9F66B
          1097684C301B3E7DF599E1C4E5E7780D7CFAEA0B58FEEFDF7F0C9B0FDC617801
          0C11574B4506461C590FAC184A1074C0A7AFBF186EDC7B0B554E1C75FAEA0B86
          F79F7F300438A931B0B332E3D544B52840B7E53FB04C620013E832A87C8221C0
          C7CDC6A0A1248CAA0B8DF7F4E517602EF809160505BBAD910C838DA12C75A240
          5A8C9721D899176C382E62DD9E5B0CD7EFFF04B68698187CED5518B494F13B18
          D91C822180AC181F9B87939521C44D9D01E4607CEAD0E5A8E20049511E06572B
          05065E2E3674F309F2A9E2004B7D298216E15240B35C80CB4274F151078C8600
          7A9A18797C00AF767103221C87AE0000000049454E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 7
        OnClick = btnNewJobFileClick
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
      object btnOpenJobFile: TAdvGlowButton
        Left = 49
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Open Job File'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000002C84944415458C3CD963D4C144118869F99B9BFBDD303EEF815510941
          8D06E980184B2B2D3431464345426C8CD1D068A3B1B4C4D8694C3416C49858DA
          A89515A051A31003FE2B1A04048E3BE196DDDBB1E1472302370BA753CD7CBBEF
          7CCF7EF3EECCC03F6E62BE73F9B17D0FCD81D50A95C4F13CCE7A9AAB1DCDE119
          5300692ADC5AAC82F188B82005273B7BECA282031447A0B14A259251D1A1246D
          9D3D76494101004A2CC18E72559D8C8A334AD26A52095F0052406954505F2A6B
          1396E85082E39D3DB65530807988B298647BA9AC2BB6C43925F5A17CF401D3C4
          5F521E697B71EC69F034B5087118B8BDEE00A3D39AB199DC6F31ADC18378412A
          E069402FB7B314C803BE3D94AF603AEB30EBE4967B45AF2BC0872F299EBE1A21
          95B157DCDED7A9022EBD7D5F79F47488EFA919DF4BF087096D27C7D0B734A9F4
          D25FF879388D3D9BA3EFF528B6EDD2DC50454D657CED00B2B64BFFDB31DE0D4D
          2E29705D0FC7CDA135BCF934C14CD6A1A5B19ABA9A62A410FE013CADC9DA2E3F
          A69DBF8AC2729623650FD99FE8261670496422C43F079908EFE259F254D01740
          28A0D85CB111A596B6C7442A4B8D33C0A5BA2B5832BBF82003DB320FD8E87CDA
          AE6F5224DA481901C4AC207B1BABFF2A78D23F4CFCFDE8EFC917ECEF513F7577
          0B30A96F2EBD824037D02EDA1834FA0B024A922C8AF8F15C0B70D0782BAE2A8B
          D190A880B1C5584FD9F985BE951B79BD67FC5AD70AD33C3306A848C6884DA985
          F160692BCDB15B108DCE87EAA9DC797185694EE85E715134BDBAEEFB2C285783
          BF265F6DDB04BA7D6D0E23CB3255667C037C8FEC46878D0DF9DC1840CF9D3752
          694ADCB746D709D02F0DAE0F730037388AE00E1B62036CAADA41206F2F8F833E
          269A061EFAF34028044A99282711E2ABB907241F8169A2D647845111C7F11832
          BF130A5EE0711AADAFE079769EE22984E8C2D169630F2C78E17EE56142A1607E
          F9E5282ADC2DF60D64F91FDA4F0852E8EE460A3D530000000049454E44AE4260
          82}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 8
        OnClick = btnOpenJobFileClick
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
  object MainMenu: TMainMenu
    Left = 173
    Top = 167
    object File1: TMenuItem
      Caption = '&File'
      GroupIndex = 10
      object mniFileNew: TMenuItem
        Caption = '&New'
        Hint = 'Create a new Import Job or Field Map'
        object mniFileNewImportJob: TMenuItem
          Caption = 'Import Job'
          Hint = 'Create a new Import Job'
          ImageIndex = 0
          OnClick = mniFileNewImportJobClick
        end
        object mniFileNewFieldMap: TMenuItem
          Caption = 'Field Map'
          Hint = 'Create a new Field Map'
          ImageIndex = 2
          OnClick = mniFileNewFieldMapClick
        end
      end
      object FileCompList: TMenuItem
        Caption = '&Open'
        HelpContext = 539
        Hint = 'Open an existing Import Job or Field Map'
        object mnuFileOpenJobFile: TMenuItem
          Caption = 'Import Job'
          Hint = 'Open an existing Import Job'
          ImageIndex = 1
          ShortCut = 115
          OnClick = mnuOpenJobFileClick
        end
        object mnuFileOpenFieldMap: TMenuItem
          Caption = 'Field Map'
          Hint = 'Open an existing Field Map'
          ImageIndex = 3
          ShortCut = 117
          OnClick = OpenFieldMapClick
        end
        object ImportLog1: TMenuItem
          Caption = 'Import Log'
          Visible = False
        end
        object ImportFile1: TMenuItem
          Caption = 'Import File'
          ImageIndex = 8
          Visible = False
        end
      end
      object FileCompSepBar: TMenuItem
        Caption = '-'
        Visible = False
      end
      object Options1: TMenuItem
        Caption = 'Default Settings'
        Hint = 'View and edit the default settings'
        ShortCut = 120
        OnClick = Options1Click
      end
      object Logs1: TMenuItem
        Caption = 'View import Logs'
        Hint = 'View the import logs'
        ShortCut = 121
        OnClick = Logs1Click
      end
      object N3: TMenuItem
        Caption = '-'
        Visible = False
      end
      object Print1: TMenuItem
        Caption = '&Print'
        HelpContext = 297
        Hint = 'Print the currently selected item to printer.'
        Visible = False
      end
      object PrintSetup1: TMenuItem
        Caption = 'Print &Setup'
        HelpContext = 302
        Hint = 'Access the printer setup screen.'
        Visible = False
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mniTestForm: TMenuItem
        Caption = 'Test Form'
        ShortCut = 123
        Visible = False
      end
      object Login1: TMenuItem
        Caption = 'Re-Login'
        Hint = 'Login to Importer under a different company'
        OnClick = Login1Click
      end
      object FileExitItem: TMenuItem
        Caption = 'E&xit'
        Hint = 'Exit from Importer'
        OnClick = FileExitItemClick
      end
    end
    object XXXEdit1: TMenuItem
      Caption = '&Edit'
      GroupIndex = 20
      Visible = False
      object XXXCutItem: TMenuItem
        Caption = 'Cu&t'
        Hint = 'Cut to clipboard'
        ImageIndex = 13
      end
      object XXXCopyItem: TMenuItem
        Caption = '&Copy'
        Hint = 'Copy to clipboard'
        ImageIndex = 14
      end
      object XXXPasteItem: TMenuItem
        Caption = '&Paste'
        Hint = 'Paste from clipboard'
        ImageIndex = 15
      end
    end
    object mnuImportJobs: TMenuItem
      Caption = '&Import Jobs'
      GroupIndex = 30
      object mnuNewJobFile: TMenuItem
        Caption = 'New Import Job'
        Hint = 'Create a new Import Job'
        ShortCut = 114
        OnClick = mnuNewJobFileClick
      end
      object mnuOpenJobFile: TMenuItem
        Caption = 'Open Import Job'
        Hint = 'Open an existing Import Job'
        ShortCut = 115
        OnClick = mnuOpenJobFileClick
      end
    end
    object mnuFieldmaps: TMenuItem
      Caption = 'Field maps'
      GroupIndex = 30
      object NewFieldMap: TMenuItem
        Caption = 'New Field Map'
        Hint = 'Create a new Field Map'
        ShortCut = 116
        OnClick = NewFieldMapClick
      end
      object OpenFieldMap: TMenuItem
        Caption = 'Open Field Map'
        Hint = 'Open an existing Field Map'
        ShortCut = 117
        OnClick = OpenFieldMapClick
      end
    end
    object Records1: TMenuItem
      Caption = '&Scheduler'
      GroupIndex = 40
      object OpenScheduler1: TMenuItem
        Caption = 'Open Scheduler'
        Hint = 'Open Scheduler'
        ShortCut = 118
        OnClick = OpenScheduler1Click
      end
      object JobQueue1: TMenuItem
        Caption = 'Open Job Queue'
        Hint = 'Open the Job Queue'
        ShortCut = 119
        OnClick = JobQueue1Click
      end
    end
    object Window1: TMenuItem
      Caption = '&Window'
      GroupIndex = 90
      Hint = 'Window related commands such as Tile and Cascade'
      object WindowCascadeItem: TMenuItem
        Caption = '&Cascade'
        Hint = 'Arrange windows to overlap'
        ImageIndex = 11
        OnClick = WindowCascadeItemClick
      end
      object WindowTileItem: TMenuItem
        Caption = '&Tile'
        Hint = 'Arrange windows without overlap'
        ImageIndex = 12
        OnClick = WindowTileItemClick
      end
      object WindowArrangeItem: TMenuItem
        Caption = '&Arrange Icons'
        Hint = 'Arrange window icons at bottom of main window'
        OnClick = WindowArrangeItemClick
      end
      object WindowMinimizeItem: TMenuItem
        Caption = '&Minimize All'
        Hint = 'Minimize all windows'
        OnClick = WindowMinimizeItemClick
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      GroupIndex = 100
      Hint = 'Help topics'
      object XXXSDebug: TMenuItem
        Caption = '&Show Debug'
        Visible = False
      end
      object XXXdbClear1: TMenuItem
        Caption = '&Clear Debug'
        Visible = False
      end
      object XXXRPos: TMenuItem
        Caption = '&Reset Positions'
        Visible = False
      end
      object HBG1: TMenuItem
        Caption = '&Hide Background'
        Visible = False
      end
      object XXXDisHKey1: TMenuItem
        Caption = '&Disable Hot Keys'
        Visible = False
      end
      object XXXSPAccess1: TMenuItem
        Caption = 'Special access'
        Visible = False
        object XXXAllocSRC1: TMenuItem
          Tag = 1
          Caption = 'A&llocate SRC'
          Visible = False
        end
        object XXXAllocPPY1: TMenuItem
          Caption = 'All&ocate PPY'
          Visible = False
        end
        object XXXAllocSRC2: TMenuItem
          Tag = 1
          Caption = 'Allocate SRC &Trans'
          Visible = False
        end
        object XXXAllocPPY2: TMenuItem
          Caption = 'Allocate PPY T&rans'
          Visible = False
        end
        object XXXUnalocate1: TMenuItem
          Caption = '&Debug Cradle'
        end
        object XXXCISGen1: TMenuItem
          Caption = 'CIS Generate'
          Visible = False
        end
        object XXXReCalcGLHed1: TMenuItem
          Caption = 'Recalc G/L Heading totals'
        end
        object XXXTranCradle1: TMenuItem
          Caption = 'Transaction Cradle'
        end
        object XXXResetbusylock1: TMenuItem
          Caption = 'Reset Thread busy lock'
        end
      end
      object N2: TMenuItem
        Caption = '-'
        Visible = False
      end
      object miHelpContents: TMenuItem
        Caption = '&Help Contents'
        ImageIndex = 15
        OnClick = miHelpContentsClick
      end
      object miSearchHelp: TMenuItem
        Caption = '&Search for Help On...'
        Hint = 'Search help file for a topic'
        ImageIndex = 15
        OnClick = miSearchHelpClick
      end
      object HelpHowToUse: TMenuItem
        Caption = '&How to Use Help'
        ImageIndex = 15
        OnClick = HelpHowToUseClick
      end
      object What1: TMenuItem
        Caption = '&What'#39's This?'
        Hint = 
          '|After clicking, place cursor over any item you require help on,' +
          ' and click over it.'
        ImageIndex = 14
        ShortCut = 16496
        Visible = False
        OnClick = What1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Sess1: TMenuItem
        Tag = 1
        Caption = 'S&ession Information'
        ImageIndex = 46
        Visible = False
      end
      object mnuAbout: TMenuItem
        Caption = '&About'
        OnClick = mnuAboutClick
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 264
    Top = 104
  end
  object ApplicationEvents: TApplicationEvents
    OnHint = ApplicationEventsHint
    Left = 448
    Top = 108
  end
  object ilTBar24: TImageList
    Height = 22
    Width = 22
    Left = 40
    Top = 128
    Bitmap = {
      494C010110001300040016001600FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000580000006E00000001002000000000004097
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
      0000000000000000000000000000000000000000000000000000929395005050
      5000505050008A8F920000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000050505000AFAF
      AF00989898005050500000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CDC3BC00B1A39A00AC9F
      9600A79A9300A2958C00A3989000ADA59F00D1CFCC0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005A00
      00009C211000AD391800C65A2900D67B3900EF9C4200F7A54A00F7A54A008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200F7A54A00F7A54A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009D9D9D0050505000FFFF
      FF00AFAFAF005050500000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D4CDC800CAC0BA00C5B8B100DCD4CF00E9E6
      E200EDEBEB00EEEBEA00EAE6E200DAD3CE00B0A49D00C3BCB800D0CCC9000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FFCEA500FFD6B500FFE7D600FFF7EF00FFFFF700FFFFFF00F7A54A008400
      0000FFCEA500FFD6B500FFE7D600FFF7EF00FFFFF700FFFFFF00F7A54A000000
      000000000000000000000000000000000000000000000000000085B785000F6F
      0F00167416001A761A001A761A001878180017791700137D13000D7F0D000A7E
      0A00077C0700027B0200007000007FB07F000000000000000000000000000000
      00008A8F92000000000000000000000000000000000050505000AFAFAF00FFFF
      FF00505050008A8F92000000000000000000000000008A8F9200282828002828
      2800282828008A8F920000000000000000000000000000000000000000000000
      00000000000000000000CCC2BC00B1A39800EDEAE600F2F4F400E7E6E600D4C1
      B700D4B6A700DCBFB100E2D3CB00EDEDEB00F2F2F200E0D7D300A0968E00B8B3
      B000000000000000000000000000000000000000000000000000000000008400
      0000FFE7C600FFDEC600FFEFDE00FFF7EF00FFFFFF00FFFFFF00F7A54A008400
      0000FFE7C600FFDEC600FFEFDE00FFF7EF00FFFFFF00FFFFFF00F7A54A000000
      0000000000000000000000000000000000000000000000000000118311001F8C
      1F002A912A002F932F002E942E002C962C00299A2900239E23001CA31C0015A4
      15000DA40D00059F050001910100006F00000000000000000000000000000000
      00005050500083878A0000000000000000008A8F920050505000FFFFFF00AFAF
      AF00505050000000000000000000000000008A8F920028282800C8C8C800C8C8
      C800C8C8C800282828008A8F9200000000000000000000000000000000000000
      000000000000CAC0B900B1A39800F7F7F700EBE6E200D5AF9C00C1744E00BB5F
      3400C47D5A00C6785200BC603500C57B5800D9BBAD00EEEBEB00F7F2F000A59A
      9400CBC7C5000000000000000000000000000000000000000000000000008400
      0000FFF7E700FFEFDE00FFF7EF00FFFFF700FFFFFF00FFFFFF00F7A54A008400
      0000FFF7E700FFEFDE00FFF7EF00FFFFF700FFFFFF00FFFFFF00F7A54A000000
      0000000000000000000000000000000000000000000000000000198D19002C96
      2C00379C37003D9F3D0068B7680039A139002DA52D0019AC190024AF240058BF
      580013B213000AAD0A00049F0400027902000000000000000000000000000000
      000050505000505050005F6264000000000050505000AFAFAF00FFFFFF005050
      50008A8F920000000000000000000000000028282800FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0028282800000000000000000000000000000000000000
      0000D5CEC800B1A39800F3F2F200E9DEDA00CE917300BF5E3000C1582500BC74
      5000DCD9D800EBD4C900CA734800BF572600BD623500CF9E8700EBE6E200F4EF
      ED009A8F8800D3D0CF0000000000000000000000000000000000000000008400
      0000FFFFFF00FFFFF700FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7A54A008400
      0000FFFFFF00FFFFF700FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7A54A000000
      000000000000000000000000000000000000000000000000000022912200389C
      380043A243009DCF9D00FFFFFF009DCF9D0019AC190019AC19009DCF9D00FFFF
      FF009DCF9D000EB10E0008A30800057E05000000000000000000000000000000
      000050505000AFAFAF00505050008A8F920050505000FFFFFF00AFAFAF005050
      5000000000000000000000000000000000008A8F920028282800C8C8C800C8C8
      C800C8C8C800282828008A8F9200000000000000000000000000000000000000
      0000BFB4AB00F0EAE600F2F2F200CF937600C05C2C00C45E2C00C75F2C00C172
      4900DAC6BB00E5BDA900CC704300C65F2D00C15C2B00BF603400D4A69000F3F2
      F000C1B9B200A59E9A0000000000000000000000000000000000000000008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200F7A54A00F7A54A008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200F7A54A00F7A54A000000
      00000000000000000000000000000000000000000000000000002C962C0042A0
      420076BB7600FFFFFF00FFFFFF00FFFFFF009DCF9D009DCF9D00FFFFFF00FFFF
      FF00FFFFFF0057BD57000FA30F000B800B000000000000000000000000000000
      000050505000FFFFFF00AFAFAF0050505000AFAFAF00FFFFFF00505050008A8F
      9200000000000000000000000000000000000000000000000000282828002828
      280028282800000000000000000000000000000000000000000000000000CDC4
      BE00CEC8C200F7F7F400E2C6B800C1603200C55F2D00C7603000C9602E00C762
      3200CE795100CF744800C9623000C7602E00C7602E00C15C2B00C16C4100E5D1
      C900EFEBEA009E938D00C6C3C100000000000000000000000000000000008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200FFFFFF00F7A54A008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200FFFFFF00F7A54A000000
      0000000000000000000000000000000000000000000000000000359A35004BA5
      4B0052A852009DCF9D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF009DCF9D0018AC180018A21800128212000000000000000000000000000000
      000050505000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00505050005050
      5000505050005050500000000000000000000000000028282800FFFFFF00FFFF
      FF00FFFFFF00282828000000000000000000000000000000000000000000B7AB
      A100E0DDDB00F6F2F000D18F6E00C55E2C00C9623100C9602E00C95F2D00C56D
      4200E0C6B800E7B8A100CB6A3A00C7602D00C7602E00C7602E00C0592800D39D
      8200F7F8F700BFB2AB00ADA5A000000000000000000000000000000000008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200F7A54A00F7A54A008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200F7A54A00F7A54A000000
      00000000000000000000000000000000000000000000000000003F9F3F0053A9
      530053A9530053A953009DCF9D00FFFFFF00FFFFFF00FFFFFF00FFFFFF009DCF
      9D001EA61E001DA61D001F9E1F00188118000000000000000000000000000000
      000050505000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00AFAFAF005050500000000000000000000000000028282800FFFFFF00FFFF
      FF00FFFFFF00282828000000000000000000000000000000000000000000B1A3
      9800EAE9E800F2E1D800CE784E00CA633200CB623100C9602E00C95F2D00C46B
      4100DAD1CE00F3E1D500D4805800C75E2C00C9602E00C9623000C45D2A00CA7D
      5700F6F4F400CCC5C100A0948A00000000000000000000000000000000008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200F7A54A00F7A54A008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200F7A54A00F7A54A000000
      000000000000000000000000000000000000000000000000000045A245005AAC
      5A0053A9530053A953009DCF9D00FFFFFF00FFFFFF00FFFFFF00FFFFFF009DCF
      9D0022A3220023A02300259A25001D7F1D000000000000000000000000000000
      000050505000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00AFAF
      AF00505050008A8F920000000000000000000000000028282800A0A0A000FFFF
      FF00FFFFFF003A3A3A00C8C8C80000000000000000000000000000000000B1A3
      9800EFEEED00F2D8CC00CF754900CE663500CA633100C9602E00C9602D00C762
      3200C99C8400EDE7E500EDCCBC00CF754900C75F2C00CA633100C7602D00CA75
      4B00F6F2F000CEC7C500A3958B00000000000000000000000000000000008400
      0000FFCEA500FFD6B500FFE7D600FFF7EF00FFFFF700FFFFFF00F7A54A008400
      0000FFCEA500FFD6B500FFE7D600FFF7EF00FFFFF700FFFFFF00F7A54A000000
      00000000000000000000000000000000000000000000000000004FA74F0063B1
      630061AF61009DCF9D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF009DCF9D00269D26002A972A00217E21000000000000000000000000000000
      000050505000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00AFAFAF005050
      50008A8F920000000000000000000000000000000000C8C8C80028282800FFFF
      FF00FFFFFF00FFFFFF0028282800C8C8C800000000000000000000000000B1A3
      9800EBE9E900F4DCD000D87D5100D16A3800CB643200C9602D00C95F2D00C960
      2D00C5683A00D1A99300F4EFEB00EDC9B800CB683700CB623000CB633100CE79
      5000F8F6F400CFC9C600A79C9500000000000000000000000000000000008400
      0000FFE7C600FFDEC600FFEFDE00FFF7EF00FFFFFF00FFFFFF00F7A54A008400
      0000FFE7C600FFDEC600FFEFDE00FFF7EF00FFFFFF00FFFFFF00F7A54A000000
      000000000000000000000000000000000000000000000000000053A953006CB6
      6C0080C08000FFFFFF00FFFFFF00FFFFFF009DCF9D009DCF9D00FFFFFF00FFFF
      FF00FFFFFF0061B461002D952D00237E23000000000000000000000000000000
      000050505000FFFFFF00FFFFFF00FFFFFF00FFFFFF00AFAFAF00505050008A8F
      9200000000008A8F92002A2A2A002A2A2A00282828008A8F9200C8C8C8002828
      2800FFFFFF00FFFFFF00FFFFFF0028282800C8C8C8000000000000000000B1A3
      9800DFDCDB00FBEEE600E6936900DA734000CF683600CA653400CB683800C963
      3200C75E2B00C76B3F00E3C7BB00FAF3F000DA916D00CC633000CE653300D990
      6C00FEFEFC00CFC7C100B0A7A200000000000000000000000000000000008400
      0000FFF7E700FFEFDE00FFF7EF00FFFFF700FFFFFF00FFFFFF00F7A54A008400
      0000FFF7E700FFEFDE00FFF7EF00FFFFF700FFFFFF00FFFFFF00F7A54A000000
      00000000000000000000000000000000000000000000000000005EAF5E007ABD
      7A0070B870009DCF9D00FFFFFF009DCF9D0060AE600055A955009DCF9D00FFFF
      FF009DCF9D002E9B2E002F942F00237D23000000000000000000000000000000
      000050505000FFFFFF00FFFFFF00FFFFFF00AFAFAF00505050008A8F92000000
      00000000000028282800FFFFFF00FFFFFF00FFFFFF002828280000000000C8C8
      C80028282800FFFFFF00FFFFFF00FFFFFF0028282800C8C8C80000000000C0B5
      AC00CDC8C400FBFAF800F7C0A400EB7F4C00DA754400CF987B00E9D4CB00E1A5
      8900C75F2D00C9663700E2BFAC00FAF6F300E0A18100D46A3600D56F3E00EDC1
      AC00FBF7F600CCBFB700C8BFBA00000000000000000000000000000000008400
      0000FFFFFF00FFFFF700FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7A54A008400
      0000FFFFFF00FFFFF700FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7A54A000000
      00000000000000000000000000000000000000000000000000006BB56B008DC6
      8D0080C080006FB76F0080C0800060AE600060AE600060AE600056AA560078BB
      780045A345003A9D3A00309530001E7A1E000000000000000000000000000000
      000050505000FFFFFF00FFFFFF00AFAFAF0050505000979DA000000000000000
      00000000000028282800FFFFFF00FFFFFF00FFFFFF0028282800000000000000
      000028282800B1B1B100FFFFFF00FFFFFF00A0A0A00028282800000000000000
      0000B1A39800EFEDEB00FCEEE600FBA37500F0895500DA9C7D00EAE3E100F7EB
      E600E3AC9200E2B49C00F6EBE600F2EDE900E08F6800E1754100E7997300FBED
      E600EEEBE600BAB0AA0000000000000000000000000000000000000000008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200F7A54A00F7A54A008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200F7A54A00F7A54A000000
      000000000000000000000000000000000000000000000000000077BB77009DCF
      9D008CC68C0079BC790070B8700069B4690065B2650062B062005DAE5D0056AB
      56004EA74E0041A141002F942F00197719000000000000000000000000000000
      000050505000FFFFFF00AFAFAF00505050008A8F920000000000000000000000
      00000000000028282800FFFFFF00FFFFFF00FFFFFF0028282800000000000000
      000028282800A0A0A000FFFFFF00FFFFFF00FFFFFF0028282800000000000000
      0000C5BBB300DCDAD900FBFAFA00FFE2CE00FEB48200F3A37200E6BBA400EDE6
      E500EEEDED00EEEEEE00F2EBEA00EFBFA700F28B5900F49A6D00FADAC700FCFB
      FA00D8CEC700DAD2CD0000000000000000000000000000000000000000008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200FFFFFF00F7A54A008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200FFFFFF00F7A54A000000
      0000000000000000000000000000000000000000000000000000B1D8B10076BB
      760067B367005BAD5B0054A954004FA74F004AA44A004BA54B0046A346003FA0
      3F003B9E3B0031983100238C23008ABB8A000000000000000000000000000000
      000050505000AFAFAF00505050008A8F92000000000000000000000000000000
      00000000000028282800A0A0A000FFFFFF00FFFFFF0028282800535353005353
      530028282800FFFFFF00FFFFFF00FFFFFF00A0A0A00028282800000000000000
      000000000000C5BBB300E9E7E600FAF7F600FFF0DE00FEDAAD00FBCB9700F4C5
      9F00EBC2A600EBC1A400F6BB9500FCAD7D00FEBC9200FEE5D400FEFBFA00F0E9
      E300CDC2BC000000000000000000000000000000000000000000000000008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200F7A54A00F7A54A008C10
      08009C211000AD391800C65A2900D67B3900EF9C4200F7A54A00F7A54A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000050505000505050008A8F9200000000000000000000000000000000000000
      000000000000C8C8C80028282800FFFFFF00FFFFFF00FFFFFF00282828002828
      2800A0A0A000FFFFFF00FFFFFF00FFFFFF0028282800C8C8C800000000000000
      00000000000000000000C5BBB300EAE7E600FCFBFB00FFFFFA00FFFCEA00FFF7
      D400FFEDC200FFE6BC00FFE6C100FFEDD800FFFCF800FCFBFA00F0E6E100D0C6
      BF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000505050008A8F920000000000000000000000000000000000000000000000
      00000000000000000000C8C8C800353535007A7A7A00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A0A0A00028282800C8C8C80000000000000000000000
      0000000000000000000000000000D4CDC700C5BBB300EDEBEB00F8F7F700FEFE
      FE00FFFFFE00FFFFFE00FFFFFE00FCFBFA00F6F4F200D2CAC300D5CDC8000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C8C8C8004241400028282800282828002828
      2800282828002828280034323100C8C8C8000000000000000000000000000000
      00000000000000000000000000000000000000000000CFC7C100C5BBB300C5BB
      B300C5BBB300C5BBB300C5BBB300C5BBB300CDC5BE0000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000007368
      7E00767D84000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007D5F51007D5F5100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000079678A003A58
      A6004078B500A6B1BA000000000000000000000000007D5F5100A78475000000
      000000000000000000000000000000000000A7847500A7847500000000000000
      0000000000000000000000000000A78475007D5F510000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F6D8C003758A900297E
      E60048A7F800ABC9E200000000000000000000000000A7847500C2ABA000C2AB
      A00000000000000000000000000000000000C2ABA000C2ABA000000000000000
      00000000000000000000C2ABA000C2ABA000A784750000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B6D8E003658A7002983EB0045A9
      FC00A1CAEB000000000000000000000000000000000000000000C2ABA0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C2ABA0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008C0800009410
      08009C211000AD391800C65A2900DE7B3900EF9C4200F7A54A00F7A54A00F7A5
      4A00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A0A0A000A5898300A581
      7700926C6300AA827800AA9C9900ACAFB200526896002C7FE20043A6FC0098C7
      ED00000000000000000000000000000000000000000000000000000000000000
      0000B38E8300C69E9500C29A9100C2999100BE948B00BA918800BB928A00B78E
      8600B78C7F009F827D0000000000000000000000000000000000000000000000
      00000000000000000000000000009F827D009F827D009F827D009F827D009F82
      7D009F827D009F827D009F827D009F827D009F827D009F827D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FFCE
      A500FFD6B500FFE7D600FFF7EF00FFFFF700FFFFFF00FFFFFF00FFFFFF00F7A5
      4A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009F7E7500A5837A00000000000000
      00000000000000000000AF877200957570009899A00087BBE500A4CCEB000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000AC918300E9D8CC00EAD7C800E7CFB900E7CAB200E6C6A900E6C1A000E6BF
      9900E6BEA600A483800000000000000000000000000000000000000000000000
      00000000000000000000000000009F827D009F827D0010ACBA0019AFBF0010AC
      BA0010ACBA001FB1C20010ACBA001DB1C10010ACBA0010ACBA009F827D000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FFE7
      C600FFDEC600FFEFDE00FFF7EF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7A5
      4A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000AC7B7200B48B8100B0897F009A6D62009A6D
      62009A6D62009A6D620000000000B4867300C4AAA40000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B3988800F1E8DF00EAD9C900E6CFB900ECD6C300E6C7AA00E6C39F00E6C0
      9800E6BDA700A685830000000000000000000000000000000000000000000000
      00000000000000000000000000009F827D0080E0F5009F827D0021B2C30030B6
      CB0037BAD0002BB5C8003BBAD1003BBAD00037B9CE0030B6CB0029B4C8009F82
      7D00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FFF7
      E700FFEFDE00FFF7EF00FFFFF700FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7A5
      4A00000000000000000000000000000000000000000000000000000000009F75
      6900B6877D00B1827800B1817800B2938E00DFC9E700DDC6E600D9BEE300D3B5
      DF00D0B2DC009A6D62000000000000000000A0796F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BAA09000F5EEE900EDE2D800ECE0D600E9D6C400E6CCB400E6C7AA00E6C6
      A300E6C0AC00A988820000000000000000000000000000000000000000000000
      00000000000000000000000000009F827D0083E2F5007DDFF5009F827D0044BD
      D60061C6E50051C2DD0054C2DE004CC0DA004DC0DA0053C2DD0055C3DE0057C4
      DF009F827D000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C080000941008008C0800009410
      08009C211000AD391800C65A2900DE7B3900EF9C4200F7A54A00F7A54A00F7A5
      4A00000000000000000000000000000000000000000000000000000000009778
      6900E4D4EB00E2D1EA00DEC9E700AF8B7900E1CEE900DCC5E50090709E00D0B1
      DD00D3B6DE009A6D62000000000000000000A57E740000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BAA19000F5EFEB00F4EDE800EBE0D500EBDBCB00EAD7C600E6C9AE00E6C7
      A900E6C2B000AC8A850000000000000000000000000000000000000000000000
      00000000000000000000000000009F827D008DE9F60083E3F5007DDFF5009F82
      7D0072CCEE0072CCEE0072CCEE0072CCEE0072CCEE0072CCEE0072CCEE0072CC
      EE0072CCEE009F827D0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084000000FFCEA5008C0800009410
      08009C211000AD391800C65A2900DE7B3900EF9C4200F7A54A00FFFFFF00F7A5
      4A00000000000000000000000000000000000000000000000000000000009F80
      6E00E6D7ED00E3D1EB00E0CCE900B5927900E3D1EA00E1CEE900DCC5E5009070
      9E00D7BCE1009A6D62000000000000000000AF8B7A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BEA59300F7F1ED00F1EBE700EDE3DB00EBDCD000E6D1BD00E6CCB400E6CA
      AD00E6C3B200AD8B840000000000000000000000000000000000000000000000
      00000000000000000000000000009F827D0094EDF7008AE8F60088E7F5007DDF
      F5009F827D009F827D009F827D009F827D009F827D009F827D009F827D009F82
      7D009F827D009F827D009F827D00000000000000000000000000000000000000
      00000000000000000000000000000000000084000000FFE7C6008C0800009410
      08009C211000AD391800C65A2900DE7B3900EF9C4200F7A54A00F7A54A00F7A5
      4A0000000000000000000000000000000000000000000000000000000000A789
      7700E9DBEF0090709E00E0CBE800AB7F6F00E5D5EC00E3D2EB0090709E009070
      9E00DAC2E3009A6D62000000000000000000BD9A840000000000000000000000
      0000000000000000000000000000000000007D5F5100A7847500C2ABA0000000
      0000C2A99700F1ECE800F1EBE700EDE5DD00EBE0D600EADBCE00E8D3C000E6CE
      B400E6C4B500AF8D850000000000C2ABA000A78475007D5F5100000000000000
      00000000000000000000000000009F827D009CF3F8009CF4F7009AF2F60094EE
      F5008CE8F50084E3F5007DDFF5007DDFF5007DDFF5009F827D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084000000FFF7E700FFEFDE00FFF7
      EF00FFFFF700FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7A54A00000000000000
      000000000000000000000000000000000000000000000000000000000000A78A
      7700EBDEF100E3D2EA00E3D0EA00BDA5A100C69A7E00E5D5EC0090709E009070
      9E00DDC6E500B0897B0000000000BD9F9200B6A7A40000000000000000000000
      0000000000000000000000000000000000007D5F5100A7847500C2ABA0000000
      0000C5AD9B00F1EBE800F1EBE700EDE5E100EFE6E000EADDD100E9D7C600EBDB
      C900E6C4B500B190870000000000C2ABA000A78475007D5F5100000000000000
      00000000000000000000000000009F827D00A5F9F9009EF5F8009BF3F70097F0
      F60091ECF5008EEAF5008BE8F50083E3F50080E1F5009F827D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008C080000941008008C080000941008009C211000AD39
      1800C65A2900DE7B3900EF9C4200F7A54A00F7A54A00F7A54A00000000000000
      000000000000000000000000000000000000000000000000000000000000AC8F
      7A00EDE1F20090709E00E7D6ED0090709E00C1A49D00CB9C8000E5D5EC00E2CF
      E900DEC8E600D1B49D00BB988F00B4A09E000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C8B09D00F1EEEB00F6F0EC00F1EBE700F1EBE500EDE3DB00EDE1D600E8D5
      C300E8D2C800B28E840000000000000000000000000000000000000000000000
      00000000000000000000000000009F827D00A6FAFA00A2F8F9009BF3F8009F82
      7D009F827D009F827D009F827D009F827D009F827D009F827D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFCEA5008C080000941008009C211000AD39
      1800C65A2900DE7B3900EF9C4200F7A54A00FFFFFF00F7A54A00000000000000
      000000000000000000000000000000000000000000000000000000000000B193
      7F00EFE4F300ECE0F100EBDEF000E7D7ED00E5D5EC00BBACAA00BB918B00B48B
      8100A57F7600A5867D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C9B19C00F6F0ED00F7F1ED00F6F0EC00F1EAE600EDE5DF00EDE3DA00EDE3
      DB00EBE0DA00AF877C0000000000000000000000000000000000000000000000
      0000000000000000000000000000C4AD9D009F827D009F827D009F827D00B28E
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFE7C6008C080000941008009C211000AD39
      1800C65A2900DE7B3900EF9C4200F7A54A00F7A54A00F7A54A00000000000000
      000000000000000000000000000000000000000000000000000000000000B193
      7F00F1E8F50090709E00ECDFF20090709E00E7D7EE0090709E00E1CDE900DEC9
      E7009D776D000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CFB6A100F7F1ED00F5EFEC00F5F0ED00F2EDEA00EBE5E000ECE6E100ECE6
      E200ECE6E200A784750000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFF7E700FFEFDE00FFF7EF00FFFFF700FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00F7A54A000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B598
      8300F3EBF700F1E8F500EFE5F400EDE1F200EADDF000E7D7ED00E3D0EA00DEC8
      E7009D776D000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CBB49E00F9F3EF00F5EFEC00F4EFEC00F4EFEB00F1ECE900EEE9E500EDE7
      E300ECE6E200A784750000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008C080000941008009C211000AD391800C65A2900DE7B
      3900EF9C4200F7A54A00F7A54A00F7A54A000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B89C
      8600F5EDF80090709E00EBDDF00090709E00E7D6EE0090709E00E1CCE800E2CE
      EA009E756A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D1B69B00F9F3EF00F8F2EE00F6F0EC00F4EEEA00F1EBE800F0EAE600EEE8
      E400EDE7E300A784750000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008C080000941008009C211000AD391800C65A2900DE7B
      3900EF9C4200F7A54A00FFFFFF00F7A54A000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BA9D
      8400F8F3FA00F6F0F800F3EAF600EFE3F300EADCF000E2CEEA00E2CEEA00E2CE
      EA009A6D62000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D6B89A00D4BEA900CFB9A500D1BBA700C9B2A100C4AD9D00C4AD9D00C4AD
      9D00C4AD9D00C4AD9D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008C080000941008009C211000AD391800C65A2900DE7B
      3900EF9C4200F7A54A00F7A54A00F7A54A000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C1A3
      8A00FBF8FC0090709E00F5EEF80090709E00EADDF100C5967500CC772F00B765
      3500916A5A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C2ABA0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C2ABA0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BCA0
      8700FDFCFE00FBF8FC00F9F5FB00F7F2F900F1E8F500C79C7400F7F2F900B172
      4200AD9A90000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A7847500C2ABA000C2AB
      A00000000000000000000000000000000000C2ABA000C2ABA000000000000000
      00000000000000000000C2ABA000C2ABA000A784750000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C4A3
      8300FFFFFF00FCF9FD00FAF5FB00F7F1F900F3E9F600BF967700B88B6B00C0AB
      9F00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007D5F5100A78475000000
      000000000000000000000000000000000000A7847500A7847500000000000000
      0000000000000000000000000000A78475007D5F510000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CAA5
      8200C7AC9300C1A68F00C4A99100BA9E8A00B4988600B2927B00C0AB9E000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007D5F51007D5F5100000000000000
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
      000000000000000000000000000000000000000000000000000000000000B38E
      8300C69E9500C59D9400C49B9300C39A9200C2999100C0978F00BE958D00BD94
      8C00BF968D00C0978E00C1988F00C0978F00BF968E00BD948C00BA918900B78E
      8600AF898100A9867F00A2837F0000000000000000000000000000000000B38E
      8300C69E9500C29A9100C2999100BE948B00BA918800BB928A00B78E8600B78C
      7F009F827D000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000AC877C00BF978E00BE968D00BD948C00B38A8200B3887B00AE89
      7E00C1999000BD958C00BD948C00BA908700BC928900B98F8600B98F8600BA90
      8700B68D8400B68D8500B1888000B58A7D009A7D78000000000000000000B18F
      8300EADACD00ECDCCE00EAD6C800E9D7C900EAD7C800E9D6C600E8D2BF00E7CE
      B700E7CCB400E6CAB000E7CAB100E6C8AD00E6C5A700E6C29F00E6BEA600E6C1
      A000E6BF9900E6BEA600A384800000000000000000000000000000000000AC91
      8300E9D8CC00EAD7C800E7CFB900E7CAB200E6C6A900E6C1A000E6BF9900E6BE
      A600A48380000000000000000000000000000000000000000000000000000000
      00000000000000000000CDB7B200C09C9400B78E8600B78C7F009F827D000000
      0000B38E8300C69E9500C29A9100C2999100BE948B00BA918800BB928A00B78E
      8600B78C7F009F827D0000000000B38E8300C69E9500C29A9100C6A19A00D0B9
      B30000000000A78C7E00E9D2C100E8CBB200E7C4A600E6BF9F00E6BEA600AC91
      8300CCFFFF00C5FEFE00BCFDFD00B2FCFC00ACFBFB00A0FAFA0098FBFB008DFC
      FC0070FDFD005BFEFE0052FFFF004BFFFF00A07F7C000000000000000000B192
      8500EEE0D400ECDCCE00EAD7C700ECDDCF00EBDBCC00E8D4C100E9D5C200E8D1
      BC00E9D0BB00E8CCB200E8CDB500E7CAAE00E6C9AC00E6C4A100E6C1AA00E6C2
      A400E6C09800E6BDA700A585810000000000000000000000000000000000B398
      8800F1E8DF00EAD9C900A4838000A4838000A4838000E6C39F00E6C09800E6BD
      A700A68583000000000000000000000000000000000000000000000000000000
      00000000000000000000E1D0C300E5C5A900E6BF9900E6BEA600A48380000000
      0000AC918300E9D8CC00EAD7C800E7CFB900E7CAB200E6C6A900E6C1A000E6BF
      9900E6BEA600A483800000000000AC918300E9D8CC00EAD7C800E7D1BD00E6D6
      C90000000000A2817F00EAD7CC007D5F5100AB887700E6BDA700E6BDA700A382
      8000D2FFFF007D5F5100B3FAF9007D5F51007D5F51008FB5AF0085857A008170
      630077BFB9007D5F510064FDFD0053FFFF00A1807E000000000000000000B497
      8900F2E9E300EEE2D600EEE3DA00F1E7DE00ECDFD300ECDFD400EBDDD000EAD9
      C900EAD8C900E9D0BA00E8CFB800E7CDB400E7CFB800E6CBB000E6C6B000E6C7
      AA00E6C3A600E6BFAA00A787820000000000000000000000000000000000BAA0
      9000F5EEE900EDE2D800A4838000A4838000A4838000A4838000E6C6A300E6C0
      AC00A98882000000000000000000000000000000000000000000000000000000
      00000000000000000000C1AFAD00DCBEA300E6C09800E6BDA700A68583000000
      0000B3988800F1E8DF00EAD9C900A4838000A4838000A4838000E6C39F00E6C0
      9800E6BDA700A685830000000000B3988800F1E8DF00EAD9C900AC8E8C00C1AF
      AD0000000000AF948400EAD6CC00EAD4BD00E8CAAB00E6C09800E6BEA900AE93
      8300D8FFFF00D2FEFE00CAFDFD00C1FCFC00B7FBFB00A5FAFA00A3F9F900A0F9
      F90095FAFA008FFAFA0087FBFB0076FDFD00A2817F000000000000000000B69B
      8C00F4ECE700F0E6DD00F1EBE70000008000F2E9E200EFE5DC00EDE3DB00EBDC
      CE00EBDDD100EAD7C600EAD5C200E8D4C200E8D3BF00E7CDB400E6C7B200E6C9
      AE00E6C5A800E6C3B200A989830000000000000000000000000000000000BAA1
      9000F5EFEB00F4EDE800EBE0D500EBDBCB00A4838000A4838000E6C7A900E6C2
      B000AC8A85000000000000000000000000000000000000000000000000000000
      00000000000000000000C1AFAD00AC8E8C00E6C6A300E6C0AC00A98882000000
      0000BAA09000F5EEE900EDE2D800A4838000A4838000A4838000A4838000E6C6
      A300E6C0AC00A988820000000000BAA09000F5EEE900EDE2D800AC8E8C00C1AF
      AD0000000000B69C8C00EAD6CC007D5F51007D5F5100AC8A7900E7C0AC00B69C
      8C00DCFFFF007D5F5100C4FCFB007D5F51007D5F510097B6B00088857B0092C6
      C200868C83007D5F51007D5F510079FDFD00A6857F000000000000000000B99F
      8F00F6EFEB00F3EAE40000008000EDE5DD006A66AB00F0E9E400EDE5DD00EDE1
      D800ECE0D700EADBCE00EAD6C600E8D6C600E9D7C700E8D3BF00E7CDB900E6CC
      B500E6CAAD00E6C9B800AD8B820000000000000000000000000000000000BEA5
      9300F7F1ED00F1EBE700EDE3DB00EBDCD000A4838000A4838000E6CAAD00E6C3
      B200AD8B84000000000000000000000000000000000000000000000000000000
      00000000000000000000C1AFAD00AC8E8C00E6C7A900E6C2B000AC8A85000000
      0000BAA19000F5EFEB00F4EDE800EBE0D500EBDBCB00A4838000A4838000E6C7
      A900E6C2B000AC8A850000000000BAA19000F5EFEB00F4EDE800E9E0D700E7E1
      DB0000000000B69D8C00ECD9CF00F1E2DA00F0DFD600EED8CD00E8C4B200B69D
      8C00DFFFFF00DBFEFE00D5FDFD00CEFDFC00C9FDFC00C4FDFC00BCFCFB00B1FB
      FA00A5FAF90098FAFA0092FBFB008EFCFC00A98782000000000000000000BCA3
      9200F3EDE900F5EDE800F1EBE700EDE5E100F1EBE8006966AC00EDE5E100EFE6
      E000EDE2DA00EDE4DC00EBDFD400EADBCE00EADBCD00EAD8C900E8D1C200E8D3
      C400E7CEBC00E6C6B700AE8C810000000000000000000000000000000000C2A9
      9700F1ECE800F1EBE700EDE5DD00EBE0D600A4838000A4838000E6CEB400E6C4
      B500AF8D85000000000000000000000000000000000000000000000000000000
      00000000000000000000C1AFAD00AC8E8C00E6CAAD00E6C3B200AD8B84000000
      0000BEA59300F7F1ED00F1EBE700EDE3DB00EBDCD000A4838000A4838000E6CA
      AD00E6C3B200AD8B840000000000BEA59300F7F1ED00F1EBE700ECE2DA00E8E1
      DB0000000000B9A08E00EBD7CD007D5F51007D5F5100ECD7CC00E9CABB00B79E
      8C00E2FFFF007D5F5100D2FEFD007D5F5100A5B8B1008F867B00857063009FBF
      B8008C897E0093C8C3009FFAFA0098FBFB00A98780000000000000000000BFA7
      9500F2ECE800F7EFEB00F6F0EC00F1EBE700F1EEEB00F6F0EC0000008000F0E9
      E400F0E9E400EDE3DB00EDE2DA00EBDED200ECDFD400EBDBD000EBDBD000E8D0
      BB00E7D0BB00E7C8B900B08E800000000000000000000000000000000000C5AD
      9B00F1EBE800F1EBE700EDE5E100EFE6E000A4838000A4838000EBDBC900E6C4
      B500B19087000000000000000000000000000000000000000000000000000000
      00000000000000000000C1AFAD00AC8E8C00E6CEB400E6C4B500AF8D85000000
      0000C2A99700F1ECE800F1EBE700EDE5DD00EBE0D600A4838000A4838000E6CE
      B400E6C4B500AF8D850000000000C2A99700F1ECE800F1EBE700ECE4DD00E8E2
      DD0000000000BCA39100EAD6CC00EAD6CC00EAD6CC00EAD6CC00EACFC200BDA4
      9200E6FFFF00E2FFFF00E0FFFF00DCFFFF00D7FFFE00CFFEFD00C5FDFC00BAFD
      FC00B0FBFB00B4FAFA00A6F9F900A7FAFA00AB8981000000000000000000C2AA
      9800F1EDEA00F8F1ED00F7F1ED0000008000F6F0ED00F7F1ED00F6F0EC00F1EA
      E600F1EAE500EFE7E100EFE6E000EDE4DD00EDE3DA00EBDCD100ECDFD600EBDB
      CE00E8D4C100E8CCBF00B392810000000000000000000000000000000000C8B0
      9D00F1EEEB00F6F0EC00EADDD100A4838000A4838000A4838000E8D5C300E8D2
      C80064747300353A3A00393B3B00535454008080800000000000000000000000
      00000000000000000000C1AFAD00AC8E8C00EBDBC900E6C4B500B19087000000
      0000C5AD9B00F1EBE800F1EBE700EDE5E100EFE6E000A4838000A4838000EBDB
      C900E6C4B500B190870000000000C5AD9B00F1EBE800F1EBE700ECE5E100EAE6
      E20000000000C1A99700EAD6CC007D5F5100BAA296007D5F5100EAD6CC00C1A9
      9700EEFFFF007D5F5100E3FFFF007D5F51007D5F5100AEB9B200BEE0DC00BDF0
      EE00BDF7F500B3FBFA00AAFAF900B1FBFA00AB8A81000000000000000000C5AD
      9A00F4EFEC00F8F2EE0000008000F5F0ED0000008000F5EFEC00F5F0ED00F0EB
      E700F1EAE600EFE8E300F0E9E500EFE9E400EFE8E200EEE6E000EBDFD600EBDF
      D400EADBCE00E9D2C700B696830000000000000000000000000000000000C9B1
      9C00F6F0ED00F7F1ED00EADDD100A4838000A4838000A4838000EDE3DB005570
      72007AC4CA0094EEF50094EEF50094EEF5007AC4CA0055707200000000000000
      00000000000000000000C4B3B100AC8F8D00E8D5C300E8D2C800B28E84000000
      0000C8B09D00F1EEEB00F6F0EC00EADDD100A4838000A4838000A4838000E8D5
      C300E8D2C800B28E840000000000C8B09D00F1EEEB00F6F0EC00E7DED700C1AF
      AD0000000000C3AB980000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00C1A9
      9600F4FFFF00E5FFFF00D8FFFF00E0FFFF00DCFFFF00D7FFFE00D0FEFD00C5FD
      FC00C1FDFC00B9FCFB00AFFBFA00BDFCFB00AD897F000000000000000000C8B0
      9D00F6F0ED00F8F2EE00F5EFEC00F4EFEC00F9F3EF0000008000F4EFEC00F1EC
      E800F2ECE800EFE9E400F2EDEA00F0EBE700EDE7E200ECE4DF00ECE2DC00ECE3
      DD00EBDDD000EAD9D200B99A860000000000000000000000000000000000CFB6
      A100F7F1ED00F5EFEC00F5F0ED00F2EDEA00EBE5E000ECE6E10084817F007AC4
      CA0094EEF50094EEF50094EEF50094EEF50094EEF5007AC4CA00808080000000
      00000000000000000000C1AFAD00AC8E8C00EDE3DB00EBE0DA00AF877C000000
      0000C9B19C00F6F0ED00F7F1ED00EADDD100A4838000A4838000A4838000EDE3
      DB00EBE0DA00AF877C0000000000C9B19C00F6F0ED00F7F1ED00E4D9D100C9B8
      B40000000000C3AB960000FFFF007D5F51007D5F510000FFFF0000FFFF00C4AC
      9700F7FFFF007D5F5100E3FFFF007D5F51007D5F51007D5F5100AFB9B3009387
      7C00B6CAC4007D5F51007D5F5100C1FDFC00AA8277000000000000000000CAB2
      9E00F8F2EE00F8F2EE00F8F2EE00F8F2EE00F8F2EE00F8F2EE0000008000F1EC
      E900F4EFEB00F1ECE900F4EFEB00F3EEEA00EEE9E500EDE7E300ECE6E200EDE5
      E000ECE1D700EBDED800BD9E890000000000000000000000000000000000D6B8
      9A00D6B89A00D6B89A00D6B89A00D6B89A00D6B89A00D6B89A003A39380094EE
      F50094EEF500A3CDD300AEB3B80094EEF50094EEF50094EEF5005B5B5B000000
      00000000000000000000E8E5E200EBE6E100ECE6E200ECE6E200A78475000000
      0000CFB6A100F7F1ED00F5EFEC00F5F0ED00F2EDEA00EBE5E000ECE6E100ECE6
      E200ECE6E200A784750000000000CFB6A100F7F1ED00F6F0EC00F1E8E200ECE9
      E80000000000C9B09B0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00CBB2
      9D00FCFFFF00F4FFFF00EDFFFF00E8FFFF00E3FEFE00DCFDFD00D6FDFD00D4FE
      FE00D4FFFE00D0FEFD00C5FDFC00C5FDFC00A27F70000000000000000000CEB4
      9C00F9F3EF00F8F2EE00F8F2EE00F8F2EE00F8F2EE00F8F2EE00F4EEEA00F1EB
      E800F4EEEA00F1EBE800F4EEEA00F1EBE800F0EAE600EEE8E400EDE7E300EFE8
      E300EDE4DD00ECE5E000C0A28B0000000000000000000000000000000000D1B6
      9B00F9F3EF00F8F2EE00D6B89A00F4EEEA00F1EBE800D6B89A0027272700A3BF
      C400C47F8200DA515300E637380094EEF50094EEF50094EEF5003F3F3F000000
      00000000000000000000DDCDBB00D8BDA300D6B89A00D6B89A00A78475000000
      0000D6B89A00D6B89A00D6B89A00D6B89A00D6B89A00D6B89A00D6B89A00D6B8
      9A00D6B89A00A784750000000000D6B89A00D6B89A00D6B89A00D8BDA300DDCD
      BB0000000000C7B09A00EAD6CC007D5F5100AD9387007D5F5100EAD6CC00C5AE
      9800FEFFFF007F6D6000898C820099B4AE00A0B2AB0093877C00E1FFFF00DCFF
      FF00DDFFFF00D0FEFD00CAFDFC00C8FDFD00A07D6E000000000000000000D0B5
      9B00F9F3EF00F8F2EE00F6F0EC00F9F3EF00F8F2EE00F6F0EC00F4EEEA00F1EB
      E800F4EEEA00F1EBE800F4EEEA00F1EBE800F0EAE600EEE8E400EDE7E300F0EA
      E600EEE6E100EDE6E200C2A48D0000000000000000000000000000000000D6B8
      9A00D4BEA900CFB9A500D1BBA700C9B2A100C4AD9D00C4AD9D00313131008EE4
      EA0094EEF50094EEF500D264660094EEF50094EEF50094EEF500313131000000
      00000000000000000000ECE8E600DCC4AE000000000000000000000000000000
      0000D1B69B00F9F3EF00F8F2EE00D6B89A00F4EEEA00F1EBE800D6B89A000000
      0000000000000000000000000000D1B69B00F9F3EF00F8F2EE00DCC5AE00EDEA
      E80000000000CAAF9400EAD6CC00EAD6CC00EAD6CC00EAD6CC00EAD6CC00CBB0
      9500FFFFFF00FEFFFF00FDFFFF00FCFFFF00FBFFFF00F7FFFF00F0FFFF00E8FF
      FF00E6FFFF00DFFFFF00CFFFFF00C9FEFE00A38071000000000000000000D3B7
      9A00F8F2EE00F8F2EE00F8F2EE00F8F2EE00F8F2EE00C4AD9D00C4AD9D00C4AD
      9D00C6AF9F00C7B1A000C7B1A000C6B09F00C6B09F00C7B1A000C7B19F00C6B0
      9E00C5AE9C00C4AC9A00C5A78F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080007AC4
      CA0094EEF50094EEF500BE91950094EEF50094EEF5007AC4CA00808080000000
      00000000000000000000D3C6BE00C8B3A6000000000000000000000000000000
      0000D6B89A00D4BEA900CFB9A500D1BBA700C9B2A100C4AD9D00C4AD9D000000
      0000000000000000000000000000D6B89A00D4BEA900CFB9A500D2BFAD00D5C9
      C00000000000D0B29400CEB8A300CAB4A000CDB7A300BEA79700BEA79700CEB0
      9200CFB9A400CAB4A000CCB6A200C4AD9C00C5AE9D00C3AC9B00C3AC9B00C5AE
      9D00C0A99900BEA79700BEA79700BFA89800BFA898000000000000000000D6B8
      9A00F8F2EE00F8F2EE00F8F2EE00F8F2EE00F8F2EE00CEB39B00F8F2EE00F8F2
      EE00F6F0EC00F5EFEB00F4EEEA00D6B89A00F8F2EE00F5EFEB00F2ECE800F1EB
      E700EFE8E400EDE6E200C6A89000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006984
      86007AC4CA0094EEF5009AE1E80094EEF5007AC4CA0055707200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D6B8
      9A00F8F2EE00F8F2EE00F8F2EE00F8F2EE00F8F2EE00D2B69A00F8F2EE00F7F1
      ED00F6F0EC00F5EFEB00F4EEEA00D6B89A00F8F2EE00F4EEEA00F2ECE800F1EB
      E700EFE8E400EDE6E200C7A99100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080003E3E3E0029292900313131008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D5B9
      9E00D4BAA100D2B9A300D0B8A400CDB5A200CAB2A000CCB39D00C7AF9E00C7B0
      9F00C9B2A100C9B2A100C8B1A000C7B09F00C8B19F00CAB29F00CBB29D00CCB1
      9A00CEB19700CCAE9400C8AA9200000000000000000000000000000000000000
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
      00000000000000000000000000000000000000000000000000007D5F51007D5F
      5100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007D5F51007D5F51000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007D5F
      5100A78475000000000000000000000000000000000000000000A7847500A784
      75000000000000000000000000000000000000000000A78475007D5F51000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007D5F5100A784750000000000000000000000
      00000000000000000000A7847500A78475000000000000000000000000000000
      000000000000A78475007D5F5100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A784
      7500C2ABA000C2ABA00000000000000000000000000000000000C2ABA000C2AB
      A00000000000000000000000000000000000C2ABA000C2ABA000A78475000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009F827D009F827D009F827D009F827D009F827D009F827D009F827D009F82
      7D009F827D009F827D009F827D00000000000000000000000000000000000000
      0000000000000000000000000000A7847500C2ABA000C2ABA000000000000000
      00000000000000000000C2ABA000C2ABA0000000000000000000000000000000
      0000C2ABA000C2ABA000A7847500000000000000000000000000000000000000
      0000000000000000000000000000000000009F827D009F827D009F827D009F82
      7D009F827D009F827D009F827D009F827D009F827D009F827D009F827D000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C2ABA0000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C2ABA000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009F827D009F827D0010ACBA0019AFBF0010ACBA0010ACBA001FB1C20010AC
      BA001DB1C10010ACBA0010ACBA009F827D000000000000000000000000000000
      000000000000000000000000000000000000C2ABA00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C2ABA00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009F827D009F827D0010ACBA0019AF
      BF0010ACBA0010ACBA001FB1C20010ACBA001DB1C10010ACBA0010ACBA009F82
      7D00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B38E8300C69E9500C29A9100C2999100BE948B00BA91
      8800BB928A00B78E8600B78C7F009F827D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009F827D0080E0F5009F827D0021B2C30030B6CB0037BAD0002BB5C8003BBA
      D1003BBAD00037B9CE0030B6CB0029B4C8009F827D0000000000000000000000
      0000000000000000000000000000000000000000000000000000B38E8300C69E
      9500C29A9100C2999100BE948B00BA918800BB928A00B78E8600B78C7F009F82
      7D00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009F827D0080E0F5009F827D0021B2
      C30030B6CB0037BAD0002BB5C8003BBAD1003BBAD00037B9CE0030B6CB0029B4
      C8009F827D000000000000000000000000000000000000000000000000000000
      00000000000000000000AC918300E9D8CC00EAD7C800E7CFB900E7CAB200E6C6
      A900E6C1A000E6BF9900E6BEA600A48380000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009F827D0083E2F5007DDFF5009F827D0044BDD60061C6E50051C2DD0054C2
      DE004CC0DA004DC0DA0053C2DD0055C3DE0057C4DF009F827D00000000000000
      0000000000000000000000000000000000000000000000000000AC91830079D1
      EF006FC8EE006FC8EE006FC8EE006FC8EE006FC8EE006FC8EE006FC8EE00A483
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009F827D0083E2F5007DDFF5009F82
      7D0044BDD60061C6E50051C2DD0054C2DE004CC0DA004DC0DA0053C2DD0055C3
      DE0057C4DF009F827D0000000000000000000000000000000000000000000000
      00000000000000000000B3988800F1E8DF00EAD9C900A4838000A4838000A483
      8000E6C39F00E6C09800E6BDA700A68583000000000000000000000000000000
      0000000000000000000000000000B38E8300C69E9500C29A9100C2999100BE94
      8B009F827D008DE9F60083E3F5007DDFF5009F827D0072CCEE0072CCEE0072CC
      EE0072CCEE0072CCEE0072CCEE0072CCEE0072CCEE0072CCEE009F827D000000
      0000000000000000000000000000000000000000000000000000B398880089DF
      F00081D8EF007AD1EE0077CFEF0073CBEE0071C9EE0070C8EE006FC8EE00A685
      830000000000000000000000000000000000000000000000000000000000B38E
      8300C69E9500C29A9100C2999100BE948B009F827D008DE9F60083E3F5007DDF
      F5009F827D0072CCEE0072CCEE0072CCEE0072CCEE0072CCEE0072CCEE0072CC
      EE0072CCEE0072CCEE009F827D00000000000000000000000000000000000000
      00000000000000000000BAA09000F5EEE900EDE2D800A4838000A4838000A483
      8000A4838000E6C6A300E6C0AC00A98882000000000000000000000000000000
      0000000000000000000000000000AC918300E9D8CC00EAD7C800E7CFB900E7CA
      B2009F827D0094EDF7008AE8F60088E7F5007DDFF5009F827D009F827D009F82
      7D009F827D009F827D009F827D009F827D009F827D009F827D009F827D009F82
      7D00000000000000000000000000000000000000000000000000BAA090008FE5
      F1000B6EA7000B6EA7007DD5F0000B6EA7000B6EA7000B6EA7006FC8EE00A988
      820000000000000000000000000000000000000000000000000000000000AC91
      830079D1EF006FC8EE006FC8EE006FC8EE009F827D0094EDF7008AE8F60088E7
      F5007DDFF5009F827D009F827D009F827D009F827D009F827D009F827D009F82
      7D009F827D009F827D009F827D009F827D000000000000000000000000000000
      00000000000000000000BAA19000F5EFEB00F4EDE800EBE0D500EBDBCB00A483
      8000A4838000E6C7A900E6C2B000AC8A85000000000000000000000000000000
      0000000000000000000000000000B3988800F1E8DF00EAD9C900A4838000A483
      80009F827D009CF3F8009CF4F7009AF2F60094EEF5008CE8F50084E3F5007DDF
      F5007DDFF5007DDFF5009F827D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BAA1900093E9
      F2008BE2F10083DBF00085DCF10079D1EF0073CCEE0071CAEE0070C9EE00AC8A
      850000000000000000000000000000000000000000000000000000000000B398
      880089DFF00081D8EF007AD1EE0077CFEF009F827D009CF3F8009CF4F7009AF2
      F60094EEF5008CE8F50084E3F5007DDFF5007DDFF5007DDFF5009F827D000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BEA59300F7F1ED00F1EBE700EDE3DB00EBDCD000A483
      8000A4838000E6CAAD00E6C3B200AD8B84000000000000000000000000000000
      0000000000000000000000000000BAA09000F5EEE900EDE2D800A4838000A483
      80009F827D00A5F9F9009EF5F8009BF3F70097F0F60091ECF5008EEAF5008BE8
      F50083E3F50080E1F5009F827D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BEA5930096EC
      F3000B6EA7000B6EA7008CE2F3000B6EA7000B6EA7000B6EA70071CAEE00AD8B
      840000000000000000000000000000000000000000000000000000000000BAA0
      90008FE5F1000B6EA7000B6EA7007DD5F0009F827D00A5F9F9009EF5F8009BF3
      F70097F0F60091ECF5008EEAF5008BE8F50083E3F50080E1F5009F827D000000
      00000000000000000000000000000000000000000000000000007D5F5100A784
      7500C2ABA00000000000C2A99700F1ECE800F1EBE700EDE5DD00EBE0D600A483
      8000A4838000E6CEB400E6C4B500AF8D850000000000C2ABA000A78475007D5F
      5100000000000000000000000000BAA19000F5EFEB00F4EDE800EBE0D500EBDB
      CB009F827D00A6FAFA00A2F8F9009BF3F8009F827D009F827D009F827D009F82
      7D009F827D009F827D009F827D00000000000000000000000000000000000000
      000000000000000000007D5F5100A7847500C2ABA00000000000C2A9970097ED
      F4008EE5F30096EBF50096EBF50089E0F2007FD6F00076CEEF0072CCEE00AF8D
      850000000000C2ABA000A78475007D5F5100000000000000000000000000BAA1
      900093E9F2008BE2F10083DBF00085DCF1009F827D00A6FAFA00A2F8F9009BF3
      F8009F827D009F827D009F827D009F827D009F827D009F827D009F827D000000
      00000000000000000000000000000000000000000000000000007D5F5100A784
      7500C2ABA00000000000C5AD9B00F1EBE800F1EBE700EDE5E100EFE6E000A483
      8000A4838000EBDBC900E6C4B500B190870000000000C2ABA000A78475007D5F
      5100000000000000000000000000BEA59300F7F1ED00F1EBE700EDE3DB00EBDC
      D000A48380009F827D009F827D009F827D00B28E840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007D5F5100A7847500C2ABA00000000000C5AD9B0098EE
      F5000B6EA7009CF0F70099EEF6000B6EA7000B6EA7000B6EA70074CEEF00B190
      870000000000C2ABA000A78475007D5F5100000000000000000000000000BEA5
      930096ECF3000B6EA7000B6EA7008CE2F3000B6EA7009F827D009F827D009F82
      7D00B28E84000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C8B09D00F1EEEB00F6F0EC00EADDD100A4838000A483
      8000A4838000E8D5C300E8D2C800B28E84000000000000000000000000000000
      0000000000000000000000000000C2A99700F1ECE800F1EBE700EDE5DD00EBE0
      D600A4838000A4838000E6CEB400E6C4B500AF8D850000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C8B09D009EF3
      F6000B6EA700A0F4F8009BF0F7008CE8F6007DDFF50073D6F30077D0F000B28E
      840000000000000000000000000000000000000000000000000000000000C2A9
      970097EDF4008EE5F30096EBF50096EBF50089E0F2007FD6F00076CEEF0072CC
      EE00AF8D85000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C9B19C00F6F0ED00F7F1ED00EADDD100A4838000A483
      8000A4838000EDE3DB00EBE0DA00AF877C000000000000000000000000000000
      0000000000000000000000000000C5AD9B00F1EBE800F1EBE700EDE5E100EFE6
      E000A4838000A4838000EBDBC900E6C4B500B190870000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C9B19C00A2F6
      F7000B6EA7000B6EA70098ECF6000B6EA7000B6EA7000B6EA7007BD3F000AF87
      7C0000000000000000000000000000000000000000000000000000000000C5AD
      9B0098EEF5000B6EA7009CF0F70099EEF6000B6EA7000B6EA7000B6EA70074CE
      EF00B19087000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CFB6A100F7F1ED00F5EFEC00F5F0ED00F2EDEA00EBE5
      E000ECE6E100ECE6E200ECE6E200A78475000000000000000000000000000000
      0000000000000000000000000000C8B09D00F1EEEB00F6F0EC00EADDD100A483
      8000A4838000A4838000E8D5C300E8D2C800B28E840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CFB6A100A4F8
      F8000B6EA700A0F4F8009CF0F70098EDF60090E5F40088DEF20081D8F100A784
      750000000000000000000000000000000000000000000000000000000000C8B0
      9D009EF3F6000B6EA700A0F4F8009BF0F7008CE8F6007DDFF50073D6F30077D0
      F000B28E84000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D6B89A00D6B89A00D6B89A00D6B89A00D6B89A00D6B8
      9A00D6B89A00D6B89A00D6B89A00A78475000000000000000000000000000000
      0000000000000000000000000000C9B19C00F6F0ED00F7F1ED00EADDD100A483
      8000A4838000A4838000EDE3DB00EBE0DA00AF877C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CBB49E00A5F9
      F9000B6EA7000B6EA7000B6EA70096ECF5000B6EA7000B6EA7007FD6F100A784
      750000000000000000000000000000000000000000000000000000000000C9B1
      9C00A2F6F7000B6EA7000B6EA70098ECF6000B6EA7000B6EA7000B6EA7007BD3
      F000AF877C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D1B69B00F9F3EF00F8F2EE00D6B89A00F4EEEA00F1EB
      E800D6B89A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000CFB6A100F7F1ED00F5EFEC00F5F0ED00F2ED
      EA00EBE5E000ECE6E100ECE6E200ECE6E200A784750000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D1B69B00A6FA
      FA00A5F9F900A3F7F800A0F4F7009AF0F60094EAF5008DE3F30086DDF200A784
      750000000000000000000000000000000000000000000000000000000000CFB6
      A100A4F8F8000B6EA700A0F4F8009CF0F70098EDF60090E5F40088DEF20081D8
      F100A78475000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D6B89A00D4BEA900CFB9A500D1BBA700C9B2A100C4AD
      9D00C4AD9D000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D6B89A00D6B89A00D6B89A00D6B89A00D6B8
      9A00D6B89A00D6B89A00D6B89A00D6B89A00A784750000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6B89A00D4BE
      A900CFB9A500D1BBA700C9B2A100C4AD9D00C4AD9D00C4AD9D00C4AD9D00C4AD
      9D0000000000000000000000000000000000000000000000000000000000CBB4
      9E00A5F9F9000B6EA7000B6EA7000B6EA70096ECF5000B6EA7000B6EA7007FD6
      F100A78475000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C2ABA0000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C2ABA000000000000000
      0000000000000000000000000000D1B69B00F9F3EF00F8F2EE00D6B89A00F4EE
      EA00F1EBE800D6B89A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C2ABA00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C2ABA0000000000000000000000000000000000000000000D1B6
      9B00A6FAFA00A5F9F900A3F7F800A0F4F7009AF0F60094EAF5008DE3F30086DD
      F200A78475000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A784
      7500C2ABA000C2ABA00000000000000000000000000000000000C2ABA000C2AB
      A00000000000000000000000000000000000C2ABA000C2ABA000A78475000000
      0000000000000000000000000000D6B89A00D4BEA900CFB9A500D1BBA700C9B2
      A100C4AD9D00C4AD9D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000A7847500C2ABA000C2ABA000000000000000
      00000000000000000000C2ABA000C2ABA0000000000000000000000000000000
      0000C2ABA000C2ABA000A784750000000000000000000000000000000000D6B8
      9A00D4BEA900CFB9A500D1BBA700C9B2A100C4AD9D00C4AD9D00C4AD9D00C4AD
      9D00C4AD9D000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007D5F
      5100A78475000000000000000000000000000000000000000000A7847500A784
      75000000000000000000000000000000000000000000A78475007D5F51000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007D5F5100A784750000000000000000000000
      00000000000000000000A7847500A78475000000000000000000000000000000
      000000000000A78475007D5F5100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007D5F51007D5F
      5100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007D5F51007D5F51000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      28000000580000006E0000000100010000000000280500000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF
      FFFFFF00FFFFFFFFFFFFC3FFFFFFFF00FFFFFFFFFFFFC3FFFF807F00E0001FFF
      FFFF83FFFE001F00E0001FC000F78383FC000F00E0001FC000F30701F8000700
      E0001FC000F10701F0000300E0001FC000F00F01F0000300E0001FC000F00FC7
      E0000100E0001FC000F00383E0000100E0001FC000F00383E0000100E0001FC0
      00F00381E0000100E0001FC000F00780E0000100E0001FC000F0080060000100
      E0001FC000F0182020000100E0001FC000F0383030000300E0001FC000F07830
      30000300E0001FC000F0F80038000700E0001FFFFFF1F8003C000F00FFFFFFFF
      FFF3FC007E001F00FFFFFFFFFFFFFE00FF807F00FFFFFFFFFFFFFFFFFFFFFF00
      FFFFE7FF3FFFFFFFFFFFFF00FFFFC39F3E7FFFFFFFFFFF00FFFF838F3C7FFFFF
      FFFFFF00FFFF07DFFEFFFFFFFFC00F00FF800FF003FE003FFFC00F00FF3C1FF0
      03FE001FFFC00F00FE027FF003FE000FFFC00F00E0037FF003FE0007FF000F00
      E0037FF003FE0003FF000F00E0037FF003FE0001FF000F00E0037F10023E003F
      FF003F00E0027F10023E003FFC003F00E000FFF003FE003FFC003F00E003FFF0
      03FE0FE3FC003F00E007FFF003FFFFF3FC00FF00E007FFF003FFFEEBFC00FF00
      E007FFF003FFFF1FFC00FF00E007FFF003FFFFFFFC00FF00E007FFDFFEFFFFFF
      FFFFFF00E007FF8F3C7FFFFFFFFFFF00E00FFF9F3E7FFFFFFFFFFF00E01FFFFF
      3FFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFF00
      FFFFFFFFFFFFFFFFE0000100E007FFFFFFF8000060000100E007FC1002080000
      60000100E007FC100208000060000100E007FC100208000060000100E007FC10
      0208000060000100E007FC100208000060000100E007FC100208000060000100
      E007FC100208000060000100E0007C100208000060000100E0003C1002080000
      60000100E0001C100208000060000100E0001C100208000060000100E0001C10
      0208000060000100E0001CF01E08000060000100FFC01CF01E08000060000100
      FFE03FFFFFFFFFFFE0000100FFF07FFFFFFFFFFFE0000100FFFFFFFFFFFFFFFF
      FFFFFF00FFFFFFFFFFFFFFFFFFFFFF00FFCFFFFFFFFFFCFFFFFFFF00E7CF9FFF
      FFFE7CF9FFFFFF00E3CF1FF001FE3CF1FF001F00F7FFBFF000FF7FFBFF000F00
      FC00FFF0007FC00FFF000700FC00FFF0003FC00FFF000300FC00FE00001FC00F
      E0000100FC00FE00000FC00FE0000000FC00FE0001FFC00FE0001F00FC00FE00
      01FFC00FE0001F00C4008E0001FC4008E0001F00C4008E007F1C4008E007F100
      FC00FE007F9FC00FE007F900FC00FE00775FC00FE0077500FC00FE0078FFC00F
      E0078F00FC00FE007FFFC00FE007FF00FC07FE007FFFC00FE007FF00FC07FE00
      7FFFC00FE007FF00F7FFBE03FFFF7FFBE007FF00E3CF1E03FFFE3CF1E007FF00
      E7CF9FFFFFFE7CF9FFFFFF00FFCFFFFFFFFFFCFFFFFFFF000000000000000000
      0000000000000000000000000000}
  end
  object ilTBar16: TImageList
    Height = 22
    Width = 22
    Left = 40
    Top = 200
    Bitmap = {
      494C010110001300040016001600FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000580000006E00000001002000000000004097
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
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000C0C0C000C0C0C000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00808080000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000000000
      0000000000000000000000000000000000000000000000000000000000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000C0C0C000FFFF
      FF000000000000000000000000000000000000000000C0C0C000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00C0C0C0008080
      8000FF0000008000000080808000C0C0C000FFFFFF00FFFFFF00FFFFFF008080
      8000000000000000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C0C0
      C00000000000000000000000000000000000C0C0C00000000000FFFFFF00FFFF
      FF00FFFFFF0000000000C0C0C000000000000000000000000000000000000000
      00000000000080808000FFFFFF00FFFFFF00FFFFFF00FF00000080000000FF00
      0000FFFFFF00FFFFFF0080000000FF00000080000000FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000008000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FF00000080000000FF0000008000
      0000FFFFFF00FFFFFF00FF00000080000000FF00000080000000FFFFFF00FFFF
      FF00FFFFFF008080800000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000000000
      0000000000000000000000000000000000000000000000000000008000000080
      000000800000C0C0C000FFFFFF00C0C0C0008080800080808000C0C0C000FFFF
      FF00C0C0C0000080000000800000008000000000000000000000000000000000
      000000000000C0C0C000000000000000000000000000FFFFFF00C0C0C0000000
      000000000000000000000000000000000000C0C0C00000000000FFFFFF00FFFF
      FF00FFFFFF0000000000C0C0C000000000000000000000000000000000000000
      0000C0C0C000FFFFFF00FFFFFF00FF00000080000000FF00000080000000FF00
      000080000000FF00000080000000FF00000080000000FF00000080000000FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000008000000080
      000000800000FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000FFFFFF00FFFF
      FF00FFFFFF000080000000800000008000000000000000000000000000000000
      000000000000FFFFFF00C0C0C00000000000C0C0C000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000C0C0C000FFFFFF00C0C0C00080000000FF00000080000000FF0000008000
      0000FFFFFF00FFFFFF00FF00000080000000FF00000080000000FF000000C0C0
      C000FFFFFF00C0C0C00080808000000000000000000000000000000000008000
      00008000000080000000800000008000000080000000FFFFFF00800000008000
      00008000000080000000800000008000000080000000FFFFFF00800000000000
      0000000000000000000000000000000000000000000000000000008000000080
      000000800000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C0C0C0000080000000800000008000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF0080808000FF00000080000000FF00000080000000FF00
      0000FFFFFF00FFFFFF0080000000FF00000080000000FF000000800000008080
      8000FFFFFF00FFFFFF0080808000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000008000000080
      00000080000080808000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0
      C000808080000080000000800000008000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C0C0C0000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FF00000080000000FF00000080000000FF0000008000
      0000C0C0C000FFFFFF00FFFFFF0080000000FF00000080000000FF0000008000
      0000FFFFFF00FFFFFF0080808000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000008000000080
      00000080000080808000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0
      C000808080000080000000800000008000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0
      C000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000C0C0C000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF0080000000FF00000080000000FF00000080000000FF00
      000080000000C0C0C000FFFFFF00C0C0C00080000000FF00000080000000FF00
      0000FFFFFF00FFFFFF0080808000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000000000
      0000000000000000000000000000000000000000000000000000008000000080
      000000800000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C0C0C0000080000000800000008000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C0000000
      00000000000000000000000000000000000000000000C0C0C00000000000FFFF
      FF00FFFFFF00FFFFFF0000000000C0C0C0000000000000000000000000008080
      8000FFFFFF00FFFFFF008080800080000000FF00000080000000FF0000008000
      0000FF00000080000000FFFFFF00FFFFFF00FF00000080000000FF0000008080
      8000FFFFFF00FFFFFF0080808000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000000000
      0000000000000000000000000000000000000000000000000000008000000080
      000000800000FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000FFFFFF00FFFF
      FF00FFFFFF000080000000800000008000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C0000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000C0C0C00000000000000000008080
      8000C0C0C000FFFFFF00C0C0C000FF00000080000000FF000000FFFFFF00C0C0
      C00080000000FF000000FFFFFF00FFFFFF0080000000FF00000080000000C0C0
      C000FFFFFF00C0C0C00080808000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000000000
      0000000000000000000000000000000000000000000000000000008000000080
      000000800000C0C0C000FFFFFF00C0C0C0008080800080808000C0C0C000FFFF
      FF00C0C0C0000080000000800000008000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000C0C0
      C00000000000FFFFFF00FFFFFF00FFFFFF0000000000C0C0C000000000000000
      0000C0C0C000FFFFFF00FFFFFF0080000000FF00000080000000FFFFFF00FFFF
      FF00C0C0C000C0C0C000FFFFFF00FFFFFF00FF00000080000000FF000000FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000008000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00C0C0C0000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      000080808000FFFFFF00FFFFFF00FFFFFF0080000000FF000000C0C0C000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C00080000000FF000000FFFFFF00FFFF
      FF00FFFFFF008080800000000000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000008000000000000000000000000000000000
      000000000000FFFFFF00C0C0C000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000080808000FFFFFF00FFFFFF00FFFFFF0080000000FF0000008000
      0000FF00000080000000FF00000080000000FF000000FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000008000
      00008000000080000000800000008000000080000000FFFFFF00800000008000
      00008000000080000000800000008000000080000000FFFFFF00800000000000
      0000000000000000000000000000000000000000000000000000000000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000C0C0C000C0C0
      C00000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00C0C0C0008080
      800080000000FF00000080808000C0C0C000FFFFFF00FFFFFF00FFFFFF008080
      8000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C0C0C000000000000000
      000000000000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C00000000000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000C0C0C00000000000000000000000
      00000000000000000000000000000000000080808000C0C0C000C0C0C000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      800000008000C0C0C00000000000000000000000000080808000808080000000
      0000000000000000000000000000000000008080800080808000000000000000
      0000000000000000000000000000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000080000000
      80000000FF00C0C0C00000000000000000000000000080808000C0C0C000C0C0
      C00000000000000000000000000000000000C0C0C000C0C0C000000000000000
      00000000000000000000C0C0C000C0C0C0008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000008000000080000000
      FF00C0C0C0000000000000000000000000000000000000000000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000808080008080
      8000808080008080800080808000C0C0C00080808000000080000000FF00C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C00080808000000000000000
      00000000000000000000808080008080800080808000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800000FFFF000080800000FF
      FF000080800000FFFF000080800000FFFF000080800000FFFF00808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0008080800080808000808080008080
      800080808000808080000000000080808000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080800000000000000000000000000000000000000000000000
      00000000000000000000000000008080800000FFFF008080800000FFFF000080
      800000FFFF000080800000FFFF000080800000FFFF000080800000FFFF008080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      0000000000000000000000000000000000000000000000000000000000008080
      800080808000808080008080800080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080800000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080800000000000000000000000000000000000000000000000
      00000000000000000000000000008080800000FFFF00FFFFFF008080800000FF
      FF000080800000FFFF000080800000FFFF000080800000FFFF000080800000FF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF0080008000C0C0
      C000FFFFFF008080800000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080800000000000000000000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF0000FFFF00FFFFFF008080
      800000FFFF000080800000FFFF000080800000FFFF000080800000FFFF000080
      800000FFFF008080800000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FFFFFF00800000008000
      0000800000008000000080000000800000008000000080000000FFFFFF008000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF008000
      8000FFFFFF008080800000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080800000000000000000000000000000000000000000000000
      00000000000000000000000000008080800000FFFF00FFFFFF0000FFFF00FFFF
      FF00808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FFFFFF00800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF0080008000FFFFFF0080808000FFFFFF00FFFFFF00800080008000
      8000FFFFFF008080800000000000000000008080800000000000000000000000
      0000000000000000000000000000000000008080800080808000C0C0C0000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080800000000000C0C0C0008080800080808000000000000000
      000000000000000000000000000080808000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00C0C0C00080808000FFFFFF00800080008000
      8000FFFFFF00808080000000000080808000C0C0C00000000000000000000000
      0000000000000000000000000000000000008080800080808000C0C0C0000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080800000000000C0C0C0008080800080808000000000000000
      00000000000000000000000000008080800000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF0080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF0080008000FFFFFF0080008000C0C0C00080808000FFFFFF00FFFF
      FF00FFFFFF00C0C0C00080808000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080800000000000000000000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF0000FFFF00FFFFFF008080
      8000808080008080800080808000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF008000000080000000800000008000
      000080000000800000008000000080000000FFFFFF0080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000808080008080
      80008080800080808000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000008080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF0080008000FFFFFF0080008000FFFFFF0080008000FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF0080008000FFFFFF0080008000FFFFFF0080008000FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      00008000000080000000FFFFFF00800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF0080008000FFFFFF0080008000FFFFFF0080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0080808000FFFFFF008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000C0C0C000C0C0
      C00000000000000000000000000000000000C0C0C000C0C0C000000000000000
      00000000000000000000C0C0C000C0C0C0008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000008080800080808000000000000000
      0000000000000000000000000000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000000000000000
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
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800000000000000000008080
      8000C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF0080808000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000808080000000
      0000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800000000000808080008080800080808000808080008080
      80000000000080808000C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C0008080
      800000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF008080800000000000000000008080
      8000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C00080808000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00800000008000000080000000FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00808080000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00808080000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000080808000FFFFFF008080800080808000C0C0C000FFFFFF008080
      8000FFFFFF0080808000FFFFFF00808080008080800000FFFF00808080008080
      8000FFFFFF0080808000FFFFFF0000FFFF008080800000000000000000008080
      8000C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF0080808000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF0080000000800000008000000080000000FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000C0C0C000FFFFFF00FFFFFF00808080000000
      000080808000FFFFFF00FFFFFF00800000008000000080000000FFFFFF00FFFF
      FF00FFFFFF00808080000000000080808000FFFFFF00FFFFFF00800000008080
      80000000000080808000C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C0008080
      800000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF008080800000000000000000008080
      8000FFFFFF00C0C0C000FFFFFF0000008000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C00080808000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000000080000000FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      000000000000000000008080800080000000FFFFFF00FFFFFF00808080000000
      000080808000FFFFFF00FFFFFF0080000000800000008000000080000000FFFF
      FF00FFFFFF00808080000000000080808000FFFFFF00FFFFFF00800000008080
      80000000000080808000FFFFFF00808080008080800080808000FFFFFF008080
      8000FFFFFF0080808000FFFFFF00808080008080800000FFFF008080800000FF
      FF0080808000808080008080800000FFFF008080800000000000000000008080
      8000C0C0C000FFFFFF0000008000FFFFFF0000008000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF0080808000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000000080000000FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      000000000000000000008080800080000000FFFFFF00FFFFFF00808080000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000000080000000FFFF
      FF00FFFFFF00808080000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000080808000C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C0008080
      800000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF008080800000000000000000008080
      8000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF0000008000FFFFFF00C0C0
      C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C00080808000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000000080000000FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      000000000000000000008080800080000000FFFFFF00FFFFFF00808080000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000000080000000FFFF
      FF00FFFFFF00808080000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000080808000FFFFFF008080800080808000C0C0C000FFFFFF008080
      8000FFFFFF0080808000FFFFFF0080808000C0C0C0008080800080808000C0C0
      C0008080800000FFFF00FFFFFF0000FFFF008080800000000000000000008080
      8000C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF0000008000FFFF
      FF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF0080808000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000000080000000FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      000000000000000000008080800080000000FFFFFF00FFFFFF00808080000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000000080000000FFFF
      FF00FFFFFF00808080000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000080808000C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C0008080
      800000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF008080800000000000000000008080
      8000FFFFFF00C0C0C000FFFFFF0000008000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C00080808000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00C0C0C000800000008000000080000000FFFFFF00FFFF
      FF0080808000808080008080800080808000C0C0C00000000000000000000000
      000000000000000000008080800080000000FFFFFF00FFFFFF00808080000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000000080000000FFFF
      FF00FFFFFF00808080000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000080808000FFFFFF0080808000FFFFFF0080808000FFFFFF008080
      8000FFFFFF0080808000FFFFFF008080800080808000C0C0C000C0C0C000C0C0
      C000FFFFFF0000FFFF00FFFFFF0000FFFF008080800000000000000000008080
      8000C0C0C000FFFFFF0000008000FFFFFF0000008000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF0080808000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00C0C0C000800000008000000080000000FFFFFF008080
      8000C0C0C000FFFFFF0000FFFF00FFFFFF00C0C0C00080808000000000000000
      000000000000000000008080800080000000FFFFFF00FFFFFF00808080000000
      000080808000FFFFFF00FFFFFF00C0C0C000800000008000000080000000FFFF
      FF00FFFFFF00808080000000000080808000FFFFFF00FFFFFF00C0C0C0008080
      8000000000008080800000FFFF0000FFFF0000FFFF0000FFFF0000FFFF008080
      800000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF008080800000000000000000008080
      8000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF0000008000FFFFFF00C0C0
      C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C00080808000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0
      C000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00C0C0C000C0C0C0000000
      000000000000000000008080800080000000FFFFFF00FFFFFF00808080000000
      000080808000FFFFFF00FFFFFF00C0C0C000800000008000000080000000FFFF
      FF00FFFFFF00808080000000000080808000FFFFFF00FFFFFF00C0C0C0008080
      8000000000008080800000FFFF00808080008080800000FFFF0000FFFF008080
      8000FFFFFF0080808000FFFFFF00808080008080800080808000C0C0C0008080
      8000C0C0C0008080800080808000FFFFFF008080800000000000000000008080
      8000C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF0000008000FFFF
      FF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF0080808000000000000000000000000000000000008080
      800080808000808080008080800080808000808080008080800080808000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00808080000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00808080000000
      000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00808080000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000008080800000FFFF0000FFFF0000FFFF0000FFFF0000FFFF008080
      800000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF008080800000000000000000008080
      8000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C00080808000000000000000000000000000000000008080
      8000FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00808080008080800000FF
      FF00FF000000FF000000FF00000000FFFF00FFFFFF0000FFFF00808080000000
      0000000000000000000080808000808080008080800080808000808080000000
      0000808080008080800080808000808080008080800080808000808080008080
      800080808000808080000000000080808000808080008080800080808000C0C0
      C0000000000080808000C0C0C000808080008080800080808000C0C0C0008080
      8000FFFFFF008080800080808000C0C0C000C0C0C00080808000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF008080800000000000000000008080
      8000C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF0080808000000000000000000000000000000000008080
      800080808000808080008080800080808000808080008080800080808000FFFF
      FF0000FFFF00FFFFFF00FF000000FFFFFF0000FFFF00FFFFFF00808080000000
      00000000000000000000FFFFFF00808080000000000000000000000000000000
      000080808000FFFFFF00FFFFFF0080808000FFFFFF00FFFFFF00808080000000
      000000000000000000000000000080808000FFFFFF00FFFFFF0080808000FFFF
      FF000000000080808000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF008080
      800000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF008080800000000000000000008080
      8000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF0080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000FFFFFF0000FFFF008080800000FFFF00FFFFFF00C0C0C000C0C0C0000000
      0000000000000000000080808000808080000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080000000
      000000000000000000000000000080808000808080008080800080808000C0C0
      C000000000008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800000000000000000008080
      8000C0C0C000FFFFFF00C0C0C000FFFFFF00C0C0C00080808000FFFFFF00C0C0
      C000FFFFFF00C0C0C000FFFFFF0080808000FFFFFF00C0C0C000FFFFFF00C0C0
      C000FFFFFF00C0C0C00080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000C0C0C000FFFFFF0000FFFF00FFFFFF00C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00C0C0C000FFFFFF00C0C0C000FFFFFF0080808000C0C0C000FFFF
      FF00C0C0C000FFFFFF00C0C0C00080808000C0C0C000FFFFFF00C0C0C000FFFF
      FF00C0C0C000FFFFFF0080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000808080008080800080808000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800000000000000000000000
      0000000000000000000080808000808080000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000C0C0C000C0C0C00000000000000000000000000000000000C0C0C000C0C0
      C00000000000000000000000000000000000C0C0C000C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      000000000000000000000000000080808000C0C0C000C0C0C000000000000000
      00000000000000000000C0C0C000C0C0C0000000000000000000000000000000
      0000C0C0C000C0C0C00080808000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C0000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800000FFFF000080800000FFFF000080800000FFFF000080
      800000FFFF000080800000FFFF00808080000000000000000000000000000000
      000000000000000000000000000000000000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      000000000000000000000000000000000000808080008080800000FFFF000080
      800000FFFF000080800000FFFF000080800000FFFF000080800000FFFF008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000FFFFFF008080800000FFFF000080800000FFFF000080800000FF
      FF000080800000FFFF000080800000FFFF008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000FFFF008080800000FF
      FF000080800000FFFF000080800000FFFF000080800000FFFF000080800000FF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008080800000FFFF00FFFFFF008080800000FFFF000080800000FFFF000080
      800000FFFF000080800000FFFF000080800000FFFF0080808000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000FFFF00FFFFFF008080
      800000FFFF000080800000FFFF000080800000FFFF000080800000FFFF000080
      800000FFFF008080800000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF00FFFFFF0080000000800000008000
      0000FFFFFF00FFFFFF00FFFFFF00808080000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      800080808000FFFFFF0000FFFF00FFFFFF008080800000FFFF000080800000FF
      FF000080800000FFFF000080800000FFFF000080800000FFFF00808080000000
      00000000000000000000000000000000000000000000000000008080800000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF008080
      8000000000000000000000000000000000000000000000000000000000008080
      80008080800080808000808080008080800080808000FFFFFF0000FFFF00FFFF
      FF008080800000FFFF000080800000FFFF000080800000FFFF000080800000FF
      FF000080800000FFFF0080808000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF00FFFFFF0080000000800000008000
      000080000000FFFFFF00FFFFFF00808080000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008080800000FFFF00FFFFFF0000FFFF00FFFFFF0080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      800000000000000000000000000000000000000000000000000080808000FFFF
      FF00000080000000800000FFFF0000008000000080000000800000FFFF008080
      8000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF0000FFFF00FFFFFF0000FFFF008080800000FFFF00FFFFFF0000FF
      FF00FFFFFF008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      000080000000FFFFFF00FFFFFF00808080000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF00FFFFFF00800000008000
      000080808000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0080808000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008080800000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF008080
      8000000000000000000000000000000000000000000000000000000000008080
      800000FFFF00FFFFFF0000FFFF00FFFFFF0080808000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      000080000000FFFFFF00FFFFFF00808080000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF00FFFFFF00800000008000
      00008080800000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF0080808000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00000080000000800000FFFF0000008000000080000000800000FFFF008080
      8000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00000080000000800000FFFF008080800000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00808080000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000C0C0C0000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      000080000000FFFFFF00FFFFFF008080800000000000C0C0C000808080008080
      800000000000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0080808000FFFFFF0000FFFF00FFFFFF008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      000000000000000000008080800080808000C0C0C000000000008080800000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF008080
      800000000000C0C0C00080808000808080000000000000000000000000008080
      800000FFFF00FFFFFF0000FFFF00FFFFFF0080808000FFFFFF0000FFFF00FFFF
      FF00808080008080800080808000808080008080800080808000808080000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000C0C0C0000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      000080000000FFFFFF00FFFFFF008080800000000000C0C0C000808080008080
      800000000000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080008080800080808000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008080800080808000C0C0C0000000000080808000FFFF
      FF0000008000FFFFFF0000FFFF00000080000000800000008000FFFFFF008080
      800000000000C0C0C00080808000808080000000000000000000000000008080
      8000FFFFFF00000080000000800000FFFF000080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF00FFFFFF00C0C0C000800000008000
      000080000000FFFFFF00FFFFFF00808080000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008000000080000000FFFFFF00FFFFFF008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008080800000FF
      FF000000800000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF008080
      8000000000000000000000000000000000000000000000000000000000008080
      800000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF00FFFFFF00C0C0C000800000008000
      000080000000FFFFFF00FFFFFF00808080000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008000000080000000FFFFFF00FFFFFF008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00000080000000800000FFFF0000008000000080000000800000FFFF008080
      8000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF0000008000FFFFFF0000FFFF0000008000000080000000800000FF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00808080000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF00FFFFFF00C0C0C0008000
      00008000000080000000FFFFFF00FFFFFF008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008080800000FF
      FF000000800000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF008080
      8000000000000000000000000000000000000000000000000000000000008080
      800000FFFF000000800000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF00FFFFFF00C0C0C0008000
      00008000000080000000FFFFFF00FFFFFF008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00000080000000800000008000FFFFFF00000080000000800000FFFF008080
      8000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00000080000000800000FFFF0000008000000080000000800000FF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF00FFFFFF0080808000FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008080800000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF008080
      8000000000000000000000000000000000000000000000000000000000008080
      800000FFFF000000800000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00000080000000800000008000FFFFFF00000080000000800000FF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C0000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000000000000000
      000000000000000000000000000080808000FFFFFF00FFFFFF0080808000FFFF
      FF00FFFFFF008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000008080
      800000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000C0C0C000C0C0C00000000000000000000000000000000000C0C0C000C0C0
      C00000000000000000000000000000000000C0C0C000C0C0C000808080000000
      0000000000000000000000000000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080808000C0C0C000C0C0C000000000000000
      00000000000000000000C0C0C000C0C0C0000000000000000000000000000000
      0000C0C0C000C0C0C00080808000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800000000000000000000000
      0000000000000000000080808000808080000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      28000000580000006E0000000100010000000000280500000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF
      FFFFFF00FFFFFFFFFFFFC7FFFFC0FF00FFFFFFFFFFFFC3FFFF003F00E0001FFF
      FFFF83FFFE001F00E0001FE001F78383FC000F00E0001FC000F30701F8000700
      E0001FC000F10701F0000300E0001FC000F00F01F0000300E0001FC000F00FC7
      E0000100E0001FC000F00383E0000100E0001FC000F00383E0000100E0001FC0
      00F00381E0000100E0001FC000F00780E0000100E0001FC000F0080060000100
      E0001FC000F0182030000300E0001FC000F0383030000300E0001FC000F07830
      38000700E0001FE001F0F8003C000F00E0001FFFFFF1F8003E001F00FFFFFFFF
      FFF3FC007F003F00FFFFFFFFFFFFFE00FFC0FF00FFFFFFFFFFFFFFFFFFFFFF00
      FFFFE7FF3FFFFFFFFFFFFF00FFFFC39F3E7FFFFFFFFFFF00FFFF838F3C7FFFFF
      FFFFFF00FFFF07DFFEFFFFFFFFC00F00FF800FF003FE003FFFC00F00FF3C1FF0
      03FE001FFFC00F00FE027FF003FE000FFFC00F00E0037FF003FE0007FF000F00
      E0037FF003FE0003FF000F00E0037FF003FE0001FF000F00E0037F10023E003F
      FF003F00E0027F10023E003FFC003F00E000FFF003FE003FFC003F00E001FFF0
      03FE0FE3FC003F00E007FFF003FFFFF3FC00FF00E007FFF003FFFEEBFC00FF00
      E007FFF003FFFF1FFC00FF00E007FFF003FFFFFFFC00FF00E007FFDFFEFFFFFF
      FFFFFF00E007FF8F3C7FFFFFFFFFFF00E00FFF9F3E7FFFFFFFFFFF00E01FFFFF
      3FFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFF00
      FFFFFFFFFFFFFFFFE0000100E007FFFFFFF8000060000100E007FC1002080000
      60000100E007FC100208000060000100E007FC100208000060000100E007FC10
      0208000060000100E007FC100208000060000100E007FC100208000060000100
      E007FC100208000060000100E0007C100208000060000100E0003C1002080000
      60000100E0001C100208000060000100E0001C100208000060000100E0001C10
      0208000060000100E0001CF01E08000060000100FFC01CF01E08000060000100
      FFE03FFFFFFFFFFFE0000100FFF07FFFFFFFFFFFE0000100FFFFFFFFFFFFFFFF
      FFFFFF00FFFFFFFFFFFFFFFFFFFFFF00FFCFFFFFFFFFFCFFFFFFFF00E7CF9FFF
      FFFE7CF9FFFFFF00E3CF1FF001FE3CF1FF001F00F7FFBFF000FF7FFBFF000F00
      FC00FFF0007FC00FFF000700FC00FFF0003FC00FFF000300FC00FE00001FC00F
      E0000100FC00FE00000FC00FE0000000FC00FE0001FFC00FE0001F00FC00FE00
      01FFC00FE0001F00C4008E0001FC4008E0001F00C4008E007F1C4008E007F100
      FC00FE007F9FC00FE007F900FC00FE00775FC00FE0077500FC00FE0078FFC00F
      E0078F00FC00FE007FFFC00FE007FF00FC07FE007FFFC00FE007FF00FC07FE00
      7FFFC00FE007FF00F7FFBE03FFFF7FFBE007FF00E3CF1E03FFFE3CF1E007FF00
      E7CF9FFFFFFE7CF9FFFFFF00FFCFFFFFFFFFFCFFFFFFFF000000000000000000
      0000000000000000000000000000}
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
    Left = 374
    Top = 86
  end
end
