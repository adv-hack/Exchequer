object MainForm: TMainForm
  Left = 114
  Top = 66
  Width = 1024
  Height = 586
  Caption = 'Exchequer'
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIForm
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poDefault
  WindowMenu = Window1
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object imgCentreLeft: TImage
    Left = 0
    Top = 174
    Width = 382
    Height = 98
    AutoSize = True
    Visible = False
  end
  object imgTopRight: TImage
    Left = 829
    Top = 48
    Width = 219
    Height = 80
    AutoSize = True
    Visible = False
  end
  object SBSPanel1: TSBSPanel
    Left = 0
    Top = 516
    Width = 1016
    Height = 19
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object StatusBar: TStatusBar
      Left = 0
      Top = 0
      Width = 1016
      Height = 19
      Align = alClient
      Panels = <
        item
          Width = 196
        end
        item
          Width = 500
        end>
      SimplePanel = False
      SizeGrip = False
    end
    object SBSPanel2: TSBSPanel
      Left = 1
      Top = 2
      Width = 64
      Height = 17
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = 'Disk'
      TabOrder = 1
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object Gauge1: TGauge
        Left = 1
        Top = 1
        Width = 61
        Height = 15
        Hint = 
          '|Shows the amount of free disk space available on the Exchequer ' +
          'drive'
        BackColor = clBtnFace
        BorderStyle = bsNone
        Color = clBlack
        ForeColor = clLime
        ParentColor = False
        ParentShowHint = False
        Progress = 0
        ShowHint = True
      end
    end
    object SBSPanel3: TSBSPanel
      Left = 67
      Top = 2
      Width = 64
      Height = 17
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 2
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object Gauge2: TGauge
        Left = 1
        Top = 1
        Width = 61
        Height = 15
        Hint = 
          '|Shows the amount of free resource memory available to Enterpris' +
          'e.'
        BackColor = clBtnFace
        BorderStyle = bsNone
        Color = clBtnFace
        ForeColor = clLime
        ParentColor = False
        ParentShowHint = False
        Progress = 0
        ShowHint = True
      end
    end
    object SBSPanel_Print: TSBSPanel
      Left = 133
      Top = 2
      Width = 63
      Height = 17
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 3
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object Gauge3: TGauge
        Left = 1
        Top = 1
        Width = 61
        Height = 15
        Hint = 'Print Progress|Shows the progress of the current print job.'
        Align = alClient
        BackColor = clBtnFace
        BorderStyle = bsNone
        Color = clBtnFace
        ForeColor = clLime
        ParentColor = False
        ParentShowHint = False
        Progress = 0
        ShowHint = True
        Visible = False
      end
      object Label_PrntProg: TLabel
        Left = 1
        Top = 1
        Width = 61
        Height = 15
        Hint = 
          '|Shows the current financial period Exchequer is set to. Double ' +
          'click here, or use F6 to change.'
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Transparent = True
        OnDblClick = Label_PrntProgDblClick
      end
    end
  end
  object AdvDockPanel: TAdvDockPanel
    Left = 0
    Top = 0
    Width = 1016
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
      Width = 1010
      Height = 44
      AllowFloating = False
      Locked = True
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
      object Bevel0: TAdvToolBarSeparator
        Left = 42
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object Bevel1: TAdvToolBarSeparator
        Left = 292
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object Bevel2: TAdvToolBarSeparator
        Left = 422
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object Bevel3: TAdvToolBarSeparator
        Left = 592
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object Bevel4: TAdvToolBarSeparator
        Left = 722
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object Bevel5: TAdvToolBarSeparator
        Left = 812
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object FAddBtn: TAdvGlowButton
        Left = 2
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Add a new transaction|A quick way to add a new transaction, with' +
          'out having to open the daybooks'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA793000002B6494441545809E557CD
          6B1341147FB3D19B085E042B7A2CA227452AD860F0E0C57693DD54ADEDFF21D4
          4BC59BE0FF209E2A28CD6E3E8C78B22A4691228A208A78B0D054BD78F056C93C
          7FA39DC96CB29B2669120F5DDEEBCCBCAFDFCB9B37DB59A2DDFE885E0A902D66
          4F7223E54AC169381E82EF41B0A21F4CB481C9738CE5AA1FBEC5BC2B429C6DEC
          98C454E0CF0AC13761390EEE863E09A2C5B2173E2041C829D90576C9CA8B057F
          DC117C0F16A7C03D13905725D1D5477EF825C9393181E930E7128B2538EE03EF
          847E0916F3E57C50890B129BC054317BDE91CE63FC82BD714E7DC836A5232F54
          73A567ADBE6D09B825F7041AAD06C3FDE041D24F6AA4CE542E2D7FB6833AF602
          ED22007E07B2418323241DA054E3AEC2500BCD910AB8813787B22F6965A77161
          E25A447DEBF5EDC83A6901C0D9B21FDED7FA3D7AA232E3222FA2F18CA8D36472
          EC6C2775A24E12DD80D22460B6C02DE44F03FC1894432554E0B8BB9C37C7DA24
          4082BDA122DBC11D69B04C022CB8BF9ADA81BB9C33D1A4366DF600D1612D6C1D
          55C36DB7E7652F88B8BDA8D7A843631A2C530178AB7F2E184642631AC54E40CB
          463ADA09D447862C785D63D93DB001E138B88DE2F6B275CFDDD06FF34B14B0A8
          6B9D5D81151AD18353B0425B8F49006FA8704B36F40147DE609904AA5EF80E2F
          A38FC346C7AFFF50F58AEF354EB30770751281B80E83E881D6962DA33AE72DA2
          AE96B8DA2DD88678355B4BDCFFA643EF152413E06150ADE28569FB9E68B6E02F
          1AAA20A57305F3EFE0C1128B75C791976D7005104D0092EA4CE12B3B720EA5F9
          8DE5A06853A61AF3A55CC91C3F1DB82D01A578982B3D611619CC775E09C1DF84
          743271F741C4A7D80494A2920F5E4A16E7307F03EE8B9868B5C1225D9E29A8BE
          8A8D814AC7CA9B4234E67FFB306966F16FA63FCDF022C94072047C14AC680D7F
          D698E829B8A74F33F8ED72FA03C926D080CD9326C20000000049454E44AE4260
          82}
        ShowDisabled = False
        TabOrder = 0
        OnClick = FAddBtnClick
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
      object MainSDBkBtn: TAdvGlowButton
        Left = 52
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Sales Transactions|Displays the Sales Transactions Daybook'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D494844520000001E0000001E08060000003B30AE
          A2000002274944415448C7E5964F4893611CC73FCF66DB9AAD9A8D70B3284FC5
          FA433A58268B6D505017411484A093834EFD391816646448D0A14387EAA01DC4
          435D841466141D660415D6EC0F6B3A66E0215D5B268A6D6DF6EEE9501DB47710
          BA771DFC1E7FCFFBE3F37CBF3CBCBF1FAC35894207777D2E4F5EE21782F2D542
          02A1D71796D7CAD43EECF6BACE48296F0A005914837F8175EA31C876ADA3D615
          A83BB40697ADA4C9BCC5C60E8F0FD3662B525148BC7F43E26D585B70B5FF28DE
          8B57D11B0C4BEAF1C7430C5FEBD006AC371A397CBE032597257836402A1A61BD
          B5822AF721663FC6B5736CA974B0CE5CCEE4B310A9680480CCEC57E28F82457B
          5CAAFA96FC4CFEC72295FB6BB0D81D9ABC6A552D66D2BCBBDF8771E3269A7AFB
          A93FD7BEE20BE8D58A0D3BED570A354C874748A7926C75EEC551EB664FF309CC
          1536A65EBD44E615D59EC1C9E9CE5539FEA3F1E003EE351F27D4758985C414BB
          1B9AA83BDDA65DD4CB35F1E42103A74EA2E47254FB8E940E0CF07D7E0E2597D5
          F6CFB5ED603DCEC6163E8D3C67261E43E874381B5B306CB03036D8AF1D383B3F
          87FD808BED759E25F5D8D0002F6EDDD00E9C8A46E83DE6C1B6CB4999C904C04C
          6C8CC54CBA3443E2CBF807CDC6A2E652054B64168452F2792C241308E904D242
          C83B324FAA348B801055BF57A09ED6D0685BC9A20692BF2217EEDB9E7DD692AD
          B73DDE9A4E10978B05090C87C53F395616745D40DF7F59E801BAFDB52E5D5ED6
          4B8979558E9F8E5E67CDEB27B944AACC89A217180000000049454E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 1
        OnClick = MainSDBkBtnClick
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
      object MainPDBkBtn: TAdvGlowButton
        Left = 92
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Purchase Transactions|Displays the Purchase Transactions Daybook'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D494844520000001E0000001E08060000003B30AE
          A2000001804944415448C7ED96CF2BC3611CC75FCFD74E1C961DD42C2127343F
          520E2C6DFF801C94FF80A4A669CC414AA961C28A567273935D56E4E0A0B49472
          58349696B9AC4CA184683C0E4A6DB36C6DDFAFC3BC6FCFE7E9E9D5E7FDEEF9F4
          815293C87631DA3A671194D90454140A590E8D4FA6D7743F425B3C7681F48244
          16A7C10CB0F2A30D42BAD4B65AC952AF561BACCBF74163773D35CDC694DAF569
          9CC8514C5D70534F039681F68C7A2276876F688B879BC782ACFE55EB23DB38DA
          3C4C5957390E9C515567A077CC5A70C639EBE9E185C0D20100B566A3766000A1
          7C8D83E4DBBB7A19A7CB60D2D3E7B401103E8CAA0F1E5CEB4F39478E62ECF982
          EA834F76C32462F724DF925C04AF885FDEAAFB9DBEC13B61CE8357459F5CAAAB
          F4C07967EC77EFE377EFFF5B5D24B0E415C4BBE6194B4154209B8067093E90B7
          9A8085C0840481DC5809B99C5A5A9D00F840740E9BDD959AADB78ED6851909D3
          C582AC8426444E1D3FE9F4B32036FF64A107B09B173B14E5A34B22CB0B817843
          AE794A5E9F15146B5984AC24120000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 2
        OnClick = MainSDBkBtnClick
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
      object MainNDBkBtn: TAdvGlowButton
        Left = 132
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Nominal Journal Transactions|Displays the Nominal Journal Transa' +
          'ctions Daybook'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D494844520000001E0000001E08060000003B30AE
          A2000001BC4944415448C7E5D64F48D36118C0F1EFFBEE0FB239B6311DB98159
          931463ED10785029BC75E822840A059DF2241DC44818A88354842E1D228845C2
          400FDE3BD4418AA2F3BCC4C405A510DB6013A68B6DEDF77AA84BCCC162DB9BB0
          E7F8BE0F7C789FF779795E68B710B53612A1CB630A312E11F646912BF1FD85BA
          E0BD6B81874AF0AC59A71B8827AB1C7956A2123C6E75A9658D755FAB6173BD89
          F6D19B745C0D52C96539DADEACDA774E4C223B1DE462AF9A0CDF18C735750F80
          72EA07271F76FE86EF4C63E9F1D70DCB7FAA8F5101A38277611961B5B6E48E6B
          649B38DADEC2E2F3E39999D50803D9D72FF9954EE1BEFF00EBC54BFA60210499
          A72B088B056F38A20F06C8BF7D43E1F3476CC323386EDDD60703A4569750A522
          DD8FC2487B2718861EB87CF08DEC4614B3A79BAED9398C9F053D304036FA9CF2
          E1775C5377B1F6F6E98355A9447A2D02D284F9824F1F0C70F2E93DC73BEF9A33
          8F13A1806AE640A87B2CEA88F3052B45115445FB3C5682A4400C29280878A150
          192DB014F8F9DD5ED18178725E5BA98522FDA7E5877783BD6E6DDFDB44A83F02
          6A51FB73CA9B9D4F80D87FF9D0037C0906AE9B242306CAD6083218FFBA4EDBC7
          29DEB77BE84DA9364B0000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 3
        OnClick = MainSDBkBtnClick
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
      object MainADBkBtn: TAdvGlowButton
        Left = 172
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Stock Adjustment Transactions|Displays the Stock Adjustments Tra' +
          'nsactions Daybook'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D494844520000001E0000001E08060000003B30AE
          A2000002054944415448C7E5964D48545114C77FD7798D391FE9441F66253853
          D9CC2812A2519469CDA8A1B9983E36D12A68579B267415145154B389162D6A17
          B5486811485A4158649B164513324C4945496AA1101A7DBC392D06859A8922DF
          7D2E3CCBFBBF8F1FFF73CF3BE7C07C0BF527C1DF9AD8A2443509B8670B19EA3B
          DAF5FB9991EF62A0F5FC11112E086295C11C7041DE6BA23A75A73A2F58A04C37
          D8F8DF0F0FEDADA3D06970EBFE206F8627EC0157AF5D4EE7C10600BC2E27A72F
          F75B93EABFC59EE62ACC8C904C8FD0B13D8852E8073B1C05B46FAB24991EE146
          EF7396FADC34D456E807EFD8E8A76451113D0F52F43E4A6366845834A41F1C8B
          8601B8FD30C5A789299E24DF11DDB4068FCBA90F5CEC5948635D05CF521F181E
          FD0C404F7F8A42A7C1CEADEBF455F5AEA6F52C301C942EF170FDDC3E00DC4559
          A7B14898EEBEA41EC7B148183323BC7E3F3E7336F9E51B63E393D457AFA26C99
          D77AC781D58BA9A92C65E0E95B0E7475FFA2ED6FABE1E4E108BBA3555CBCF6D8
          5AC7D34575F3DE8B1C6DA6BA2321EB53DDD118E4FB0F93BB032F73B4E9EA2E5F
          51C286E0BFB5F9BC3DC7DF92B06C1E66E7715C59D232B58DC5B9030B5F4199F6
          CF63C52B9010A829855C1264CCAE45602580085786EEC4E376BEF1685694FAF2
          B6333EDBD65B7F4BE20470DCF6DFC9F7D17B4AC1D53959E80102CD895A60B328
          71CDCEF1B1B3CCFBF809F857959F57EDB2B60000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 4
        OnClick = MainSDBkBtnClick
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
      object MainJDBkBtn: TAdvGlowButton
        Left = 212
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Job Costing Transactions|Displays the Job Costing Transactions D' +
          'aybook'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D494844520000001E0000001E08060000003B30AE
          A2000001274944415448C7EDD6BF4BC35010C0F1EF854E4AA17512051174F1D7
          2414298258296E82E2EAEAE8D26233150A0E465AC14529B80905FF0DFB37386A
          BBAA60864220839C834EDA84982671686E7CEF8ECFBBE33D78306E219E3B95DA
          26AADBC0E4C8CAE585F973293334B17A7A82728548540DFE828DA1692AB5B847
          6D78ACCF0429DE5B59A25EDE612E978B0C0E14FB6BAB3476CBCC4FE59385E318
          750AA7700AA770BCF074360BC0BBE324071F6F14282D2ED0B76D1E5F5E9383DB
          87070C5C97A3CE3DAAFAE7FA4C5878EBBA4DB7D70F85FA75ECA2FAE157F8F0DC
          0B8DFA742C4F08CB280EA23788F116F5ADF61AF5ECF7016E6959D5049F937E5D
          53D102A6998F03168FAF6D03A847A6B42C09D6F1C03E03B9FB9F0F3D40C55C07
          2D22323192D23CB718FBF8043DEA46F553A9A21D0000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 5
        OnClick = JobCosting2Click
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
      object MainWOBkBtn: TAdvGlowButton
        Left = 252
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Works Order Transactions|Displays the Works Order Processing Tra' +
          'nsactions Daybook'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D494844520000001E0000001E08060000003B30AE
          A20000026B4944415448C7E596CF6B134114C73FB36EB2DB16DB9A507F549B4D
          4B5BA57A1149A8D15A8208E2BF2182075110C542B12054C1A32741BCF977B496
          B6C4E20F046FAD49DBA4286850116DB39B343B1E366E13D38064D3F4D0771976
          66673EEF7DDFCCBC81BD66A2D6403A347E5E0819175269F30AE9C94C8EFDDBA7
          D680DE14F0042990C84604580556B69741DEDB69A9951A19E8DE25B063FBAF9D
          A3FDC66855BF163168BF15478B86ABE75C8D397384A81FAC5F18A0E3EE257CFD
          5D958B5F1FA1E3F6C52AA794402B9D135768B97C12A4AC1F6CCE7E74221CEE2D
          DB8E0A7AAC0F8A36DA702F42F76D395AFACF4A2C7B93DA9C4B39E0585F99CC61
          44AB9FDCD42242532B9CF2478C0A87EB061716BF60FFD8702301D047FB01F8F5
          6C1E8096F86045C4B250C47A9BF106464ACCC4324AB00D351C7440A3036CA6BF
          63BD49534865D14B60A5A305DFF143E4DF659066C123183067936E9E95601BBE
          A12398F34E9F39BD846A0450C341B4A801FB14CCB9A4F7E304602DAC38329EED
          451F7164365F2E39ED8CD3EAF141771F98FFB1B16A5E99E5B6B9FA8DE2E79FF8
          4FF760AF5BC842D15DDC5C58416EE4D12206EAB14EECDF16F90F9F1A13F1DF28
          5423801609937FBF865CCF97BCB23113CBF84F75E33B7198FCEB55D8B41B082E
          E5CD3778D095D91D9B5A443502084D25379B6CCC95E9E6B92C6FB9E94A706E66
          EBDB7AB5E2AD1E6742E3B281F58050E6A1A82BE2A657A7DD005B0259DC49F0F6
          E758C894946208D8408AA752D8D9A680A5144785B3F39EF7AC4DDE699AD402BE
          966A44341D1A3BD0B4E76D3A34FE40C044D38F53B62B3B29E0C5AE3CE89DC8EF
          9F5190311BBBD50BC4C83C7ACC9EB73F67B6CFE3165C14B70000000049454E44
          AE426082}
        Position = bpRight
        ShowDisabled = False
        TabOrder = 6
        OnClick = MainSDBkBtnClick
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
      object MainSODBkBtn: TAdvGlowButton
        Left = 302
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Sales Order Book|Opens the Sales Order Daybook'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000002894944415458C3ED975F48537114C73F77CE692ECD19CECC6C69FE21
          9348CD4403EB21AD070B7CB0A782204AEC29881E84A4222A4522887AA887028D
          0A7BF0C507891ECAC8FE9956AC2C8773256ACEE972E36E6E6EF7F6B0B0744CA5
          5DB0879DC7730EBFF3BDDFF3FB9E737F10B115362154E0C51B6BB98CDCA06C31
          E1E2AE9DFAAEBF7DEA90C9322908EC551480CCED853ED54AB7200240BDDC44D1
          D4C754573B7ED14174D23A128B2BD0E6160120CDB8B07777E0347603A049D9C8
          DAF26A6252339461C03336C4B71BA79125096D4E2192C785CBD20F80DFE564B0
          B99689C7F7884DCB429B5388DBFC89C1A613885FDF29C380CBF2195992483F76
          014115352F667BF28059FB3859F577D124A70190BCEF0843D74F31FAF02AD9E7
          EE87CF40DCA63C04958A91964BCCFE9C98DF9A2F3D68B3B6CF150FE84D4057B2
          1FAF6D9459BB357C0031A919184E36E31E3631D050C3F09DF3F85D4E007CA203
          75425230B5BF7D3EA75D191568738BC86E68C550D7847BC8C848EB9540A1781D
          BEE9C9A07C9F636A2EAEA80C57E795B0A6B812CF0F4B00584E01A2E93DDEC9B1
          3F49B28CFD75271A7D3AD13A7DF89770A2B30597D9485C66FE9CE4120AF6042E
          5CE5611C1F9E636EAE25B1B892286D028EBE6778C6BF63A86B544605F1F9A578
          6DA38803BD00E80F1E47575615A030368ECD676ECD9B03AB32B7B2E1E8D965CD
          8190DBB0FBB5B54616E43665979170A8AC44FF28B20B22001655C1EEEA8E1A10
          DAEA1BDF8675F0E5FA1D9116FC1B0059C0A3C4C17E9F1CE49354926749002A19
          B3120026A783BF23CA27999604F0B4BDCA0874850BE055EFC2FF00A1A3B4747D
          FFB276C1CC8C70C0901E7B4DAB555720851ED78B99D5EAA6E7A3CDB26D4BD2B8
          265AF5D22B8A3723EFC0FFD27E01DCD8E1E7D2B878EE0000000049454E44AE42
          6082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 7
        OnClick = MainSDBkBtnClick
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
      object MainTSBtn: TAdvGlowButton
        Left = 342
        Top = 2
        Width = 40
        Height = 40
        Hint = 'TeleSales|Opens the TeleSales Wizard.'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA7930000023F494441545809ED5641
          4F134114FE66BB0836E98540034D140F8A414D8C2007428CF8033C7A32863F60
          F0C0D968942B31D15FC08DBB72F0624A889E2C5CD004E2A19A580D0509692421
          C08EF36DD8763BCEB68157B9D8CDBEDDEF7D3379EF9B376F270BB4AFFFBD02CA
          55808B375EF6FABEF702D0D7CD78D618EF0DADF4CAE13EA6BFAC4C9549B4C27C
          57103FA51E9BE4F7ADB1ACD2EA9AEFAB6DC33F32D692DB294029F4E984F05D5D
          1DA30F1EE6EF250C3BE920503BDFB3C1BBFCD33B07F604A7007B52DC4FA7CF8E
          698DB138D70C2BA571AEAC9E99794F8CD5DD5E9DF70F1D0D0CB9C21FBB02F120
          23C34BE8CB7D8B537FE18537762BD54F110960F2C14BABF5112D6FC1F26DD7B3
          89D3F64515F8593A2FD62B125058BE052CCB348804F4F66790CE7462B3540955
          F4E432D8ADECA1FCA38281C19E90FBBABE19BE931EA21EB872338789BB97C1C4
          3462724C464C236E64A20A442BE7AA99A468561B71C4E49A9948C0A7420928D4
          522CBE5EAB3A715C251D4024E0B629FF05B3D7F9A3C42C3957CEE493D3E361BA
          B9D9F7E13BE921EA81A4A0C7E14515E04A17512BFBDC6CADE39BAD3C12291270
          7524177E019F3F9A5E3011F905B009D91BDC1E438122F94E32D116F0D3630FF0
          2CA011936332621A71231355802B2FAE6D550F223663F44912374A1C8D8904F0
          C48339F5A260BFD7F72208FB04545A07D5C118106D412C4E33B8AB3DCCBB2639
          2BA0A13700E70F337E6DEDBCFAF07662CA15EC249C5380EF05CF0F0E53DD506A
          D8FC1D0F1C052E1A5185FD33A919B4AF76055A58813F546FA60C72AAFE8D0000
          000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 8
        OnClick = TeleSales1Click
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
      object MainPODBkBtn: TAdvGlowButton
        Left = 382
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Purchase Order Book|Opens the Purchase Order Daybook'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000025E4944415458C3ED973B4C536114C77F7DDC7AA1D022A9974A4320A9
          812AA28BA880A2442441314613770737139D49343111898389138B838B9B8B83
          4D20112369140C0A034F4551486AA5A5A04DE9FB711D1A09525B8ABD090EFD8F
          E79CFB7DBF73CE77CFBD1F14B4C3526572BC19F5B4CAC8B795DD4C75B7E5A8E4
          D868D3660C96A94045BBA200328F36DBD43BDD8202803697A0E1BE574443D1D4
          033A2D558D35543759D7FDB1708CAF8E395C134E000C6623D6361B464B993215
          F0CE7B506BD448363342B18ED1C7AFF9D03F09403418E5658F9DD9FE49CAAACA
          916C66BCF31E067B9EE39EFDAE4C0500CCF595D476D403100FC7708E2D62EB6C
          E0E3C014C1D5001D772E5222950270E0FC61861E0C30FE6484CEDECBCA9F8144
          2C8146D000E09E71B1A7CEBCBEF9EFE952D3BC8FB5653FC1D5803215589A7611
          8FC6F9B1B0827BC645E3D596540BD622182DBBD3E245631100117F98E2727DFE
          0081653FC94412D150C4C99BED980F5A00D8651009FD0CA6C5877DA194BF5454
          A602D6D375EB6760A324DB5EE65E4C13F0AEA13795A48C322C0C7FA6B4C29035
          FB6D016492ED5C03DFC61719BC67A7FAB8159D5E87736C11FF928F1337DA9579
          0B4C5689A20C9908A2C0995B5D7FCC019355E2D8B5D69CE6404E00CDD7DBB2FA
          0551A0B6A3FEAF2D2A7C0B0A00DB3E84A72ED9AF80EA69F7FD77792DDCDB7DA4
          D0827F039055449458381197D36C497532B225805AE68B12002BBEF43C34F1E4
          A72D01869E754D018E7C01DE8E7B36FF94DB9B9A2A67731AC5E1B0EA427595F8
          50AFD79E2599F9F2924D1E4F88F713DE8543FBCBDD3A413D120D04FA0AF7C0FF
          52BF00E3A5BD1333E28F460000000049454E44AE426082}
        Position = bpRight
        ShowDisabled = False
        TabOrder = 9
        OnClick = MainSDBkBtnClick
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
      object MainCustBtn: TAdvGlowButton
        Left = 432
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Customer Records|Access Customer List.'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000016A4944415458C3ED962148434118C77F1B33886528580411DB8D9914
          4E41B0998C13C166F0C0A22808BA2A0C3128DA3CB0D9661034886188EDEA16AE
          182C3389161765960BCFC79EBEC7F6F604DFBF7C771F07DF9FEF7EDC7D90EABF
          2BE34F9436CBED380B5E9D55BED5CC26DD815C279329184943588D19C2E5DF18
          28F5B303D91482BF07E156F9B8233CA7959DFE3C446DB603CEF6C940446929E6
          8001E04519FBD4BD810C27210B6F0007C08827F7A88C5DE88A8190C515700E5C
          007BCAD8572DC50C30AC8CBD8FD58096220734816765AC0C387304EC2A63339E
          DC2D30A18C2DFE780541F380E71F2F00A3C061522FE1988BCDA4E681968BF958
          0CF87FAB0E6A009FC03CA023D4CAF7E40A94B1EFC035B0A2A558F2C137E8961F
          6E5F74711C980ED581A079C0D79975E00EB8D152D481376012A8016B4015D807
          1EB4140D600AA8034361182885EC82D4522C02B32E7DE90CA08CB55A8A02B0EA
          31DCF2001C7D2CF78FD3A952F54A5F1773664582A584930000000049454E44AE
          426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 10
        OnClick = OpenBtnClick
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
      object MainSuppBtn: TAdvGlowButton
        Left = 512
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Supplier Records|Access Supplier List.'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000001934944415458C3ED96314B43311485BFAAA038B8A89BA0202E0E6672
          73A8E0E05274A88B3F4144A343C0828B43910C1A1D942E2A8A88D8C5C94E3A58
          1CDC323889E0E2A422881544A42E293C4B4B2B7D7D157C071E977713B8879393
          9B0B21FE3B22C589F85C225FCF82E9CDE48F9A4D8D56A0A514C9D0188D36E149
          9D4D3855C903F12015680A4DF0F74C389F582B699E8DE462308D28CF4299BD01
          11A81252E82E60D0FD5E1AABF2FE1088B05E45F11560D993FA9242478D55D99A
          3D5045F121C002ABC6AA252974071003D2C6AA8F208EA0CFC5330063D52B70E8
          21780DE48C55A39EDC1BB067AC9AAD48A0DC3CE079C7AF801C909242CF18AB2E
          02ED84C6AA27601C6807CEA5D0560A3DE627817499CF4B226BACEA05A6813620
          23851EF1E51614BF5615D43892426780476012C896306DAB23E9CF1148A17B9C
          F30BE874F1C5C51C30E00A034C00CD552B506E1EF0281303B69CDBDF8161E016
          48B9F57D6007B891423F00FDC0FD6FAE61A579E0C0495EE882DBC069A10718AB
          76A5D077401478068E816EE0B3A6B1BC789C0E11C22F7C03A60E80D1E3644099
          0000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 11
        OnClick = OpenBtnClick
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
      object MainSListBtn: TAdvGlowButton
        Left = 552
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Stock Records|Access Stock List.'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000001714944415458C3ED962D48444110C77F77984EB16830C86A30196C76
          C306CB81E10C36B3C12FD8E08120864358F02B28974504CF62F2C2A2E10E8326
          B397B62A08E2679067D983F371A7EFE4BD77826FCAB2C32EF367E6C7CC4062FF
          DD527E476E3EEF4519F064B7F02566BAD319E86A263201A3D31096228670FA27
          06727166209D40F0F7205CC86F368567A7B01C4F23F2586AF13626016D9890BA
          1F1875D78A35CA73FE1160C01A556D5F408AAD80C1D781D506D787907AC2055D
          0466819EB60504A9B5907ACC05DFB046AD08A97B812C701D570986DD7906608D
          7A040E4361A0D53EE09BE397C033501452CF59A32E62ED84D6A87B6012C800E7
          42EA1B21B58C751F70B00D09A9678035A0DC00E1EF05F8A75500214742EA3270
          074C01D5C84B20A41E74E4D7ADCF9D0F6140580A30C7B3C09E90FA0A7801C681
          5BA0D8F0A65B48ED073A638D7A0D631F387029AF77C17DE0D41AF5EEEEDBC071
          937F6FA1F4016BD4D377B05AA36A402D99F58905B14FCF8D7360180ED9EE0000
          000049454E44AE426082}
        Position = bpRight
        ShowDisabled = False
        TabOrder = 12
        OnClick = SList1Click
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
      object MainNomBtn: TAdvGlowButton
        Left = 602
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'General Ledger|Set Up new General Ledger Accounts and Groups, ex' +
          'plore and drill-down on general ledger history.'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000025B4944415458C3ED97BF6B136118C73FCF7B77B9CB8FC3D6368DB564
          70500B0A221DEC200E0E62174110A10A852E2EDD9C1C5C1C5DEC209D44F02F50
          A8B8F903B1482CD4450CFE1844B43620ADA64D13F3E3EE7508F6A289492B49EA
          D0EFF4DEF13CF7FDDEF37CEF7DEF811D6C33A4F642DFC6453185701CB01B6628
          AEC904736D17A09F60F2911430D222670DCD299924D50E016A63F589D14D9003
          B8088FF41D4EB44380B9B1F218241A81C40038368834CB8B004FF5FC1698B486
          622947BE70454E6766EA2B603B31924310765A91FF63B3051C3B468F7B53CF26
          F6D50BE875F763189DB7BD32048B8BF502504E17BFBEDD0D046C0F02134623E9
          C6E681EC9CC7EAB30A85F73E00464C080F2BFACE98D8C9EA3B2CDE2861F60B89
          09AB356B0D5720C00E65EBB82BB0385D249FF6B1FA85DE3113E508E58C4F3EED
          63B881590BEF3C42B94D16B486CB6C16B772BF4C3EEDE31E33D873298474A061
          7F7FA4866F0F3D5444484C7686BCA980F2578D9FD7448615CAEE8609FF8097D7
          D5809EA0CFABCF3D32B74AC1D63166123F6F75A602CAA9127BEB3AF04E52E83B
          6BD173D2EC7C05AC0141D95078E3A37D10057652612715A525CDF7C795CE7A40
          14B8A32695AC66F96EB9FB1E00E83F675278EBB1F2A0C2FA2B9FD848F5ACF8F1
          C16F185FCAF87CBE5EFCED5EFC82B5B1596D5980111392576D56662BAC2D782C
          DFAB56C2DC25448F18440F078757F880812EEBF65600C0880AF1718BF87873B7
          0F5D0EB57923EA12FE2301865EEA22EB977A016B7B53080B5D9804E6C90DBE68
          3C17CC1D7409C914C85184F6FE186A349A97C4D48C1C7A9DDB19C976F00B3F01
          582AA0BC9712E9590000000049454E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 13
        OnClick = MainNomBtnClick
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
      object MainStockBtn: TAdvGlowButton
        Left = 642
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Stock Tree|Set Up new Stock Items and Groups, explore and drill-' +
          'down on stock history'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000002784944415458C3ED974B48545118C77FE7CE38F73A8F704C93C9262B
          B35908924A2F92A4452FC3A8302B84B0681312B409DCB4A8559B0229212821A2
          8DD6225A94416585D068252A8C249114E658A6E938639AAFD3CAD1B8E3A36166
          74E17FF5DD7BBEEF7CBF7BEE775EB0AC459698F920ABB0A15086200F50434628
          5C16A7A88F3880ACC3C857DC40EE3C317E247BC569DC910050825627DB17901C
          C086E085BCCBAE48001883D6040E2C664859059A0A42CC1567065ECBC6FFC824
          25FC190DF07BB85CECFF5EA91F0155B3E24C85786DBEE461FE6C019A6A25C176
          433E4E59AF07B0DB323018A25FF68A411047891E00458BE1EC4B0C01B0389A2E
          428BB96D36A72F7D2BB85ABB85A79E7500A4250E92B7D1CB95436FB95093CFCF
          407CC838D538C1BDD267FA8619B9A60154932F5427E3930A27AB0ED01788A774
          471B8996119A3B9369ED4AC2A84CFEE3DBFA2D99B10985DCB41F737FF68C5CC6
          F986C8E35D8977C0CAB9FC56CAF7BDD3B5DF3C5117B4F7541CA56F48A3FAEC93
          3016A259A4C58D03D0EDB344B90666912BA59F6C670F8F9AD3191C36717E7733
          396B7B22372B17E274FF4C2D87377FE665BB9323B70A397EA780CE7E5BEC00AC
          EA1815C5AFA8BF584351CE27DC1D0E8A6F17303A6E880DC0949C763FD78ADE50
          B2F523DE012B2D5D49D107181A8DD3BDB39B4700300819FD22ACF5A471FD792E
          3BD3BDA42604E8F65978D894417AB28FAC35BDD107C874FC6243928FEAF79B82
          F55098D5C1A5830DBA85282BB597C111539827A206D73184A889C9062065B1D8
          D6FE60496C464B08C020BB6398D5AB07F0AF7623F810839B4023014743E87B41
          BDCB86499481C84610D983A1442269C2AA548A4C4F60F94AB6AC29FD05C1B1AC
          8FD721C4850000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 14
        OnClick = MainStockBtnClick
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
      object MainJobBtn: TAdvGlowButton
        Left = 682
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Job Tree|Set Up new Job records and Contracts, explore and drill' +
          '-down on job history'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000002484944415458C3ED97DD4B93511CC73FE7D9CBF3B8D7A6E63275582A
          9A0926DD04451156F40F044134B0EE92EE0AF2B22E0B29082FA36EBAEB2AA8AE
          C25E14D6C28264613292B1D2580D5F3636B7354F17916F5BCDB667EE66DFABF3
          1CCE79BE1F7EBFDF7983AA2A2CB1FE43DEC38EC2208223809A7786C275E1654C
          7700398A91103EE06081393124A7C4003E3D0094D55698435B3007B023782E1F
          70540F00E36A2B4B23560BB81B405341887FCDB3002FA5FF3F9CA484543A4E22
          794D9CFE36921B0155B3D1D204355A21F322932D40536DECB0DF958FDD7B7201
          5CF60E0C86F297BD62109838970B80A26DE3EAABCD035019AD15A1D5F2B1D0E0
          A10FDDF8A22E468F8F6FE81F8DD4333CD5CE933937001E4B9293BB220C1F08E0
          3465727FB4CE6B0D40352F1602985C70F02252BFA1EFFE8C870BFE3EEACC692E
          777CA65E4DF37EDEC9EBEF75F9CD3779194B095F24A57269A297A69A657C275E
          D16C4996B01115A187A16696B30A43DDD34599970CE08FBA0038B633AAC3565C
          846299DF196CD0529501B018B3002CA44D9501E8712E0130FEA3B63200675A66
          01B811E864BEC82894B40CF739625CED0A726BAA9DEE67FD9CF57CC165CE108C
          5B49FC34F0E8F05B7D01B232F794BCD91BA0C7B9C4ED4F6DDC996E5BDD09CFB7
          86F58D406A456172D18127CF7AF7B686F16ED1B0E81AE87ADACFD7A4C6C5BDA1
          321D4605D46A4D70A52BC860FB4C99000C728E95BFDF84369F8025DE44677353
          10DBED4330B10D2F013FF1C637F9DF05639D76CC6210441F027D2F861289E41D
          366544EC0FC4AB4FB2AAFEE817D4549B87529541B60000000049454E44AE4260
          82}
        Position = bpRight
        ShowDisabled = False
        TabOrder = 15
        OnClick = JobCosting1Click
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
      object DDn1Btn: TAdvGlowButton
        Left = 692
        Top = 46
        Width = 40
        Height = 40
        Hint = 
          'Drill-Down|Use this to display the next level of data for the it' +
          'em selected on a list'
        DisabledPicture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002574944415478DA6264201678F7F2004911201680626CE0
          03107F01E2170C5B8BBF10632C231116832C53C063292EF003881F001DF2823C
          0778F77200490D322C4607A090B8812B441871582E02B59C85817AE006B6D060
          C462B904D4725A0050DAB8812CC084C3E7B40212403B64B0870024CE4D70057B
          828B368382181FD1362DD87B95E1C1CB4FB8A42F0043029463502CC31BE7F1CE
          DA0C0EBA32443BE0C0E527F81CA001F4F019A023FE302105BD0003FD0028B465
          90D3800203FD810CD0E32C2CD0128E8790EA85C03825167CF8FA83E1C2BD5784
          9481A25B8411E800055242607F7B18DEB4E058B91A18FF8F8935EE0D139DE31E
          1D08B090EA8083047CF7E0D547528C6301458103394E074505CCC2891BCF01E3
          FC355941C0CCA0E64E560E10E4616798B9FD22C3CBF7DF18FC2D54182485B8C9
          7204D9958DBE9228437D94258300373B98DFB8EC3859E690ED800460C988C876
          3F8151F189BE0E0059B8E1F81D868D27EE82F3BD00370759E630419B512483C2
          5907180480E9607EA13BC3F949B124D51348E00F0BD401249705EB6BFCA8510E
          7C0039E00DB97501281A40A5DEC6E37719369CB8438E116F98196EEFFA05CC8A
          A0DA908D149D1B8116EE3CFB10DC46280830621004E60650154C4AF003F12D58
          227C00C43AA41644B02C48267882680F6C2D7E436A6284590ECA82A0E027D1F7
          3FC00E40CB8637F035C9D0C10460F17B10D4EA0116C50EBAB20C0AE2C0E6DA65
          925AC87F305BC5909611515101B214940561EDC4C0964DC426C43B40CB9F50A5
          595EE06F048E0A50F013D906C068960FC28EC9A0E89A0D8ACE299DBAE7000106
          004D08DA7F87D230270000000049454E44AE426082}
        FocusType = ftHot
        HotPicture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000029A4944415478DA6264201618951800C90020B60762071C
          AA0E00F105205EC870AEE70231C632126131C8B27A3C96E2020F80B811E89005
          E439C0A8440148CE27C36274000A89445C21C288C3F200A8E5020CD40389D842
          83198BE50940723910733050170430485A29303C3FB611B703203E5FCE403B60
          0074C447A0234E60460124CECFE30A7657174306454941A26D5AB5E32CC387D7
          1F71493B02A303946318589004F1C67986BF294390952AD10E3874EE3E3E07CC
          077AD810E8880F4C4841EFC0403F000AED021083092A50CF407F900FF4B8000B
          B4843320A47AC6C6D3449BFCF6D337867BF79F1152068AEE0046A0031A480981
          B593D3F0A605CDB8690C37AEDE27D6B80D4CD0B27DA080030BA9896FE7A93B78
          E55FBC7A478A7102A028F84F8ED341510102B79FBE6598B2E208C393072FC90A
          026660C9D4408EC6FFEC6C0CB3D79F6078F2FA0B83AFBD3603173F0FC3BD7B2F
          48368785DCC833D69062989AE7C920CACF09E6A74FD84E9639643BA03CD402CE
          7EFDF13BC3FDE7EFE9EB806B8FDF312CDC758961D3C16B0C5FBE7E63E0E1E622
          CB1C2668338AF4CABD7D0383101F07C3DAD60886C76B4B18EC8C14C931E60328
          040E92530F9C9C96448D72E000C8011BC8AD0B40D1B0F9C42D8675FBAF319C3A
          799D1C233632031B072F805911541B4A90A2732E30FE371CBEC920076C23D427
          D833FC616563387BE93E49C10FC499B044D808C4EB49D17D6E5E363C0B920926
          22DA03E77A36909A18619683B2E0EC1D17C10D10129BEC13D0B36122BE261946
          3930F700C381B3F7189EBD7CC76069A0C4202B2900AC05496A217FC06C96435A
          4644458586B622380B6AC90A81F9E659F3884D888540CB27E0EE17409AE5F389
          312934C092419097131CFC44B60116002D4F1C541D9341DA351B149D533A75CF
          01020C00CF70E390BA35DCE90000000049454E44AE426082}
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002494944415478DA6264201678F71A00C90020B60762071C
          AA0E00F105205EC8B0B5F80231C632126131C8B27A3C96E2020F80B811E89005
          E439C0BB570148CE27C36274000A89445C21C288C3F200A8E5020CD40389D842
          83118BE50950CB690116001D9188DB01109FAF67A02D28043A6202A60320717E
          1E57B027B868332888F111EFD5BD57191EBCFC844BDA11E808508E61604112C4
          1BE7F1CEDA0C0EBA32443BE0C0E527F81C301FE86143A0233E302105BD0303FD
          0028B40B400C26A8403D03FD413ED0E3022CD012CE8090EA85C03825167CF8FA
          83E1C2BD57849481A23B8011E880065242607F7B18DEB4E058B91A18FF8F8935
          6E0313B46C1F28E0C0426AE23B48C0770F5E7D24C538015014FC27C7E9A0A880
          593871E339609CBF262B0858C80DBB8D27EE80E35A418C1F5C461828BD6658B0
          E72AFD1CA0AF24CA501F65C920C0CD0EE6372E3B4EDF104800FA1A91ED7E02A3
          E2137D1D00B270C3F13BC0A8B80BCEF702DC1C6499C3046D46915EA5CD3AC020
          C0C3CE30BFD09DE1FCA45892EA09E4320B140207C9A907D6D7F851A31C380072
          C00672EB0250348072C2C6E3771936007305399989115A1B9E27A63E400606C0
          5C008A777F0B6586004B158685C02CD8405A4EF800C48AB044D8486A4B085410
          C1B220996022A23DB0B57803A989116639280B6E00174A4F486DB24F40CF8689
          F89A64E86002B0F83D086AF5008B62075D590605716073ED32492DE40F14354A
          419682B220AC9D18D8B289D88488A3514A46B3BCC0DF081C15A0E027B20D40A0
          593E283A2683A26B36283AA774EA9E03041800043FDA6BA775B51B0000000049
          454E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 16
        Visible = False
        OnClick = DDn1BtnClick
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
      object DDa1Btn: TAdvGlowButton
        Left = 732
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'ObjectDrill|Use this when viewing a transaction to drill-across ' +
          'to any other record linked to the transaction currently displaye' +
          'd.'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA793000002A8494441545809ED564B
          681351143D7792466835D65F954803C656FC2C545C9496FA59F9598815C58D52
          1004C14DC1A5421151B07651A96075AD8834585A70614A37AD9B0A158C0A5682
          08C54F69B109D2C4603BF3BC133B9997E40DA4937465C2BDF3EE3DF7FBEE7B33
          04A8FCFEF709903C00F110BBB1C1730B75DED3325EA4FC115475980ECDCF16E9
          9F71F3669EFC10FDF0610ECF6120CEAA1BDAD5FDB271A8E978F09B1C7CE468DB
          CDAEAB17DFCB982C6B59650EE759DEC9EC9A12495F3304CECA4C9A3E70A3F789
          DF29A9DD00D0EEE45422DE90367EDF77CA913D0276D8C7BC4244ED4DC74E6536
          C8976E0A82EE8C0F0FF699C5E409D498C04AB3008282C43DAB8E3C816906EB99
          CB4E863074020D98898510B3A451B7299B2C3730C680791179292F91A65D188F
          0C3E5365D5B2A0819EAC5C4681087D5D1D9794C5CD32D909D015BC118FF098C1
          066657B463CBAFDB239F3647E5E0B4EE7F21EBF9325F4A1BE206AA51EBEDC03A
          ED0CFE88FD6CB127C48A457C913019AFC5F75435421BE727B66D4A7E615B0CD3
          E94E3A079DE5A229A701398A9B99E00FCA0119B3E4DE0F7BF0349619D44CD0EF
          0B84C3E16515B5F298AB7A87FDF070F14C05D349E6D4A217E1CFA17F10E16D29
          C5CD249AF928E038F632B696B980A23FD72F2E184B6106A2050ECB04BC4A7F03
          2D70389CE6BA99EBAF23437795712EC0A5ADE445120EE621B64A88D84AE992BA
          01815687D43F7019EF1C6CAEE08206C4038478FC016536C2087F5884D2E6122C
          68001A9FBF5332815127935B9CE4C096136DDB1BFDF19E404D6AAB8C5B722CE1
          4F7D4DAE1EABF7FB3A4B7DFDAC9C396F816EE0DA64A2F624B36557ADAD538985
          51360C33974C394740C09A62320A8FA1FC4614139BEF93D3808030F21D543A07
          E92ADC0DC6B9EC3022FE6F0CA46C442551AC8A56BD52592A5865026E26F01711
          8DABC1D2598AA90000000049454E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 17
        OnClick = DDa1BtnClick
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
      object QFBtn: TAdvGlowButton
        Left = 772
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'ObjectFind|A quick way to find Customers/Suppliers, transactions' +
          ' etc.'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA79300000498494441545809ED565B
          4C1C5518FECECC94B2CB452EB5142542D36A5A316EC16A3008D89A5E7C50B62A
          A49A08811062D280F1415F343EF8D4174D4C344622028909AD94AA49A931518B
          46638DB68BB688B585D41528451061E5D6DD99E377B6BBEBEEC22E506C5F74F2
          7FF39FFF72FEF3CD3933E70CF05FBFC40A2640D4D5D5E599A6992D84B05B9635
          96909030D8D4D434B6821A0B5297245055557587A669CF71D047D8FB56225C24
          8D538CBD6F18C69B2433437B451293404343C35A8FC77390C50FB0E21A022229
          13B0A501DA1A48EF2CF0D728A0B40A024352CAC6D6D6D6A357CDE5DD1725C0A9
          CEE2547FC81245101A442ED5E63288B41CBAC2C4F2418EFC04ABEF6360C2AD02
          6A460EB6B4B4BC4843B5A9E28B1E1DAEAFAFB7FB7CBE13F46F873D1D5A6923B4
          4D251089A9744589229792056D633144820D72F41C1F4896141414583D3D3D5F
          44652F6A2E20E070385E6566B9B06740DFF93C0407A00D5D037252346C4ED790
          779386F4440D1603335EDE8480C8DC0891BA0172A8870E941616167EEE72B9DC
          CA88870802D5D5D5F95CF37721344D2F7B16485EEFEFBB2149E0C15CC33FB094
          80CE0133EC025B3375ACB36B189D96F0918D48CD06B82C18EBD7D8F11EA7D3D9
          D4DDDDCD1EB4628811EEE7DBDE485B1779F70381F55E671328B9CDC0E0A485D3
          974DCC9BFFD453B1FB6E31B033CFC0F17E2F14396DCB1E9817BF01E6A61C6EB7
          BB8CF54E10314531F5072B2A2A74369C04B4DB7728E5C7AC0F3835ECC3C9E1C8
          C155706C56E2B35F7D18983001A93C84B11682EF045B24241F533A1E42046C36
          DB2626AE07D71E6A2A692899F64A0C4CCA507DE50BC7BC4FA26FDC8A886BD9F9
          C194E26023960E11D0753D472589E49B955A1D924235FC35E3150B11E0CB97EC
          4FD413FC6A55372E43A07F4A40C754E10446FC59F31EBF5ACD4DCE4D05BB5FAD
          19B416D12102DCF9DC8C4BE9611FF529D1B866991C0A76BD88252E2D18E71E3E
          C265380DEF1C307A2EE8BE261DD88C54DF2E758B87108140D211A5CDDE63FCAC
          82DF95F22C1F72F212A4FB3BD5C1E491FD816AC44304019E7EAF33F93775B0C8
          FE2FD95CA1582664CF6192E7B60834B5B5B5F52F55410B4FE8E8E898E591FA82
          F2593F1C811C74A9E6F2C0C1ADEFDF83FCFDBCCAFF83755E518DA5A04727F014
          3BCBD3CCCEC72896432E08694264E4F11F2062D746C4E5B90CF3E43BC0A533CA
          AD1EDFCE6D7D9C87D157CA110F0B08A86492F894A7191753EE95631774C9BD5D
          A81F0F23118280CE6EFCD4D4D34AFE0B582E4EFBCCB8DA7AD58B9CC41A827868
          CB9D77CD9D3DF3E3D76CC714951833585B5BFB00A7F23526DC4BC41393C166EE
          A62FF3732E61BB7D7266DE18FE731A19C9891DC73B0F57D2B7A8C42510E8216A
          6A6A76B0FD28514AE41269C430F10BF109A7FB687373F305B6FDF2F8FEA70F0C
          4D4CBD2169F1D3466652627B57E7A1A7682E10B1C0F32F3976EDAB7CCB3333FF
          8C9F046BC69A092E26A3D741067EEEEDDA7AB723FB8AD7DCAE48CC5EF1E53BB6
          6DCB3FDFD7DB113EDC7523A0062189634112CA5E8CC4755B02356010BBCA9F68
          9F9AF3EE57B61A302BD956F451E7A16F957DC3B0DB59F176D19E72B9D759F9D2
          0D1B347AA087F73D5916EDFBDFFE1BB3EA94FD2F00D8010000000049454E44AE
          426082}
        Position = bpRight
        ShowDisabled = False
        TabOrder = 18
        OnClick = CustQFBtnClick
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
      object DiaryBtn: TAdvGlowButton
        Left = 822
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Diary|Access the Diary'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA79300000354494441545809ED5649
          4C135118FE6629146AB09445518450141094258A8A31F120899E883191238AC6
          68A29278F1AE113D927820315C3C698209D183810310A346440E0459145030A4
          209445A0B658DB99F1BD57A6CC40CB1401BDD0BCE5FBFFFFFB97795B0A6CFD22
          588117CDEFF3698F80CA28944B3B130C06CEC08E86D637053CF84EC613B882B3
          278F77331C66582B5F5C11A75E11EC339E22459633A8AD7DC65152629BE1286E
          9B8CAFCCA875B5511CAE87E3733C3F3C648BED443927697D596055B1F7E1749C
          24985AC07187555D41EC0C2EA63998F87824155D1E1BC3E186D5F9DC8758C573
          AAF77AF24FD59F57019D2531AA4A9B9CEA7CCE093AB1AEC54C1162D072B43840
          558E2C70E69B011C18750510D501D2756DC1E30DCA6EF7120E2A970123BE02AE
          40EB226A0582971784415F021A3F4D4191397C9512B0DC81F8E85A047C5D0EA3
          781077EF41E3E2BE8BBB2CBA64A184B5F275D564C7F325A1820AB116D01ECA16
          4A47B9B487B22DCFA15B81B27D629F5F416A28C78DD2891CFA9A34C1740564D9
          F8394563DC0C48EEFD9C36AE6E0BB4867F85FF7B01BA2D08F7D53EBF8C575D4E
          0C8CB96036713898614571562279B3F41E0AD9BF81D179BCED9DC4E5D3997A63
          18C9B000595670EF490F06475DC1102D9D1338533C8F8A523BD3CD7B7C68EA18
          6389A7E6BC4C1769013C63AF324CCC7AE1971464A7C6A1B6AA18772AF219BB95
          1421D14F26D217B232CFDF39E0275788886B6A862B906233A3BA72E9F5FCE1F2
          B104D151027890334D247BCA36D45C3B049F24E3765D27D144DE0C0B50437D1B
          77A3FA690FBCBF2558CC226E946505CF80D512059047D231E551E911CF865BA0
          468A310BC84DDF8E246B343C5E3F3E0ECFAAA675CD1117B0C36AC6AD73397870
          A9082691C7CBF6514C92F3B1AEECC4D9700B3AFAA751D3F0997DF9FDCA42B816
          FCA03783F8C244AE249DD7D30D0B28CC8C475AB205234E37AED4B407739DC84B
          02DBFBA0E6EF80610174B9EF5EC8C7EB6E27FA1D81872837CD8A63FB1357648C
          2137E368CE4AFD0AA24611B8478B8AE6215F3D79CCCE2F8A9B329184CF4AEDA6
          7235B8EE1092BF4BE3AA61D3660563DAD8BA02A04875C418784B09D884F68B97
          659A23189AAC481033D03AE8CD9304E12A076527536CD02003DF79417E549A1E
          DDB74121B7C26CCC0AFC010BD6165FE043789C0000000049454E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 19
        OnClick = DiaryBtnClick
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
      object PrintBtn: TAdvGlowButton
        Left = 862
        Top = 2
        Width = 40
        Height = 40
        Hint = 'ObjectPrint|Print the currently selected record'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA79300000265494441545809ED5741
          6B1341147EBB74D7261831C921688327D1A21E0A22B1041103FE83F607845C15
          51D01FD18322F80372CAA522F5EC25A0D046915EA4D0426FA655D09410D975CD
          92F17B2B33ED6E7737494DA28784793B6FDE7BF37D6FDFCCCE6E88A6BF7F5C01
          2D8EFF59E3E7239DB4C5B8987EBE1E89F58785D9A7517133510EB633B9D06889
          F5938A0E80B8B97A9C7312BE6902911528954A62EFD3BBBF5A7F5E42C6602CD6
          C3243281B0E071D87C8F61B95CBE2D8458D1346D0164266494ED17C03681FFB8
          5AADBE85EE359540A552C9F47ABD5D58CF42C6D95A8EE35CACD56A074CA29600
          991560181BF9DAFD347DCB1BA0A08C699ACCC53AA90470F7A73DCB982EB75EFD
          A0F41757A2A7A4127B12CAA051F4D9663714465520D43B01A3AA80655959ECFE
          09501261BF6525914AA0DD6EBBDD6E789964F0A87AC330D466504B00F2F6A808
          FAE11CE55215084EEA743A64DB76D07CA2712291A0544A6D7C1F4664025812CA
          2CAF50F2CA5DDF846107D6D61B6AAD3E193E815C2E47F9598B92CEF6B09CBE78
          0B1806B07CC6230355015DD7F771182917360A5D389FA373D7AE7AB68EED52F3
          FBE04B329FFF53F27D71405F0DC3C390173C057B525709B8AEBB81243EC2711D
          72AC31F9EB0D35EF983F68985FBA1C34C9F17B24D090039540BD5E778BC5E21D
          9CD3F7701E2C204033936716D1E721C4771403CA21A1028CCF70AC4304641355
          7EC15CD0BDA6DE86DE287079DE7056F14DE97D94345B367DD8F15E6081A8C3E1
          8D4B699ACB240E0DD034412F1F144E2D430D6DEA1C08F54EC038332807DFD9DC
          4DFFDD0D3A372E2E3601FE53D1EFBB3E0E9C7D8CC1FD54FEDB0AFC065AFCAAF1
          F00207540000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 20
        OnClick = PrintBtnClick
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
        Left = 942
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Exit|'
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
        TabOrder = 21
        OnClick = FileExitItemClick
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
      object WhatTBtn: TAdvGlowButton
        Left = 982
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Whats This?|Once you have clicked this button, place the pointer' +
          ' over any control you require help with, and click over it.'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA7930000039B494441545809ED5749
          4C1441147D55CD30C0B0081A458C2223C6B8846834440F1E100F4613E355E301
          898932E8C583678F6A343171C3A807E31225E162704D4CF460F4E042DC706106
          14D0B801031850A6ABFC3DCD52DD3DDD33634CB830A95F5DF5DFFBBF7EFFFE5D
          5D034CFD2639032CDDF5179C8C960BCE3740CA5248363B6ECFE4178075689A7E
          BB6DD7B4705C9762975A008D522BFB3E50C318DB2781255EBE097FCD218F46BE
          E55DC00126BCB80696348060C3AF555288F344AE2049A7B508C66B3FD6059E7B
          19712F3078BABF96167F489C741727132CE7523C327C18133771CD40F0D4E036
          0979890C5D3984A5D2A494D8DA519F772D1139A1F3B2D3D14A48FE800CB24812
          B6B9F91CE5850C7DC3123D4340D780804E0590900C0C71F0B5E150E0A91D6776
          C5CA33D2D7A30FBE24FD2212479B5FC0B17F8D0FCB666816ECF3A0C0C1472368
          F9AA5BF4CAA4B5F45B6EC5FD032CA6E8E0A8819F62B096080917CFCF6438B6DE
          EF589CF828C9E538549589E20037A68964F1C7990335B0FD1C6C2611B271C6A7
          1B166828CA3693F6A95FA0FECE6FECBC398CB73FCDB72D3B83612371C60D1C03
          566F5759020836441712C1B5E2CB0B27D2DED81AC3CBEF3ADEF7085CFF3091D5
          923C8B4B726769CB4B8FF795A99A0C7522245FC754856D7CB5750477DB47E2DA
          70EF44C54DCB9AB0EAA5A28C135C3AAEF16A82CE91C49B25004AFFBCB8D6A58B
          F40A446CD8A2228EED4B4D37BA006E476236867DCA4A558D255F12A37BBBCAF0
          18070B398E54FB91E3333370E2E91F8429480F13FA84B01215B704C0194C4F2A
          C3659CA581AADE8F02BF6972B665044DEF92DD3D39B3AD61098076BE6EA2A4D4
          2AE7689895632EDEDC16C3C557666D2433665276A91C5B00E85441AFB1B1218D
          E1EA5B30A673BD32F949C532D4490C5AB3CFDC50CD5B5341DBF85E878E373FCC
          5D2FD247D567C35DA632A66B37558CAB93AEBA9C6EC6E0F9F91CE377D3DEFFF5
          17A8E824FE98718C411E57F9A4736FE0B34AB004600042E0B0714D263B2A7CB8
          BC390B8D5BB2B178BA968C6EE292397C3B02E808E53652169E9916EEFDEA39A6
          A99F1EE28A6273ECCE8E238FDB43B94DF191D2392D19D529441D7186495CDBAD
          B00E63E33176BE879D499FC1107D8EF7807CDB1DBA165B2A0712E3EE63B4B6C7
          39C0582FFD0389616548F054749304BF42E37C927F6951C6F9B6C8EE80A5F255
          47CE47A0A09150C10D72504DAA1724E936E3505AE5B5B8E1D0F51118E0B84CE6
          B17C3C88D1C1FFFE6332EA76EA327919F80B05462E865670280E000000004945
          4E44AE426082}
        Position = bpRight
        ShowDisabled = False
        TabOrder = 22
        OnClick = WhatTBtnClick
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
      object btnOpenConsumersList: TAdvGlowButton
        Left = 472
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Consumer Records|Access Consumer List.'
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000018E4944415458C3EDD63F68544110C7F14F622CECFC03366B65616125
          222456A9B4D24238B18A6011C146712B895809C16A450BC1C22E0441D1800812
          D022A5A0C5D516362B82120BB194D8AC709E77EF9E77DE45F04DB330FC607E3B
          F37D6F9626FEF798EA4EB42E2F6D8DB3E0E3BBCBBFD49CDEEE0ECCF432D980B1
          DD103E1A3384670731D09A6407A61B08FE3D08AF2CA59EF0DC598E93F9116DB9
          DA473B21037F18393A8E9DF8109277A31B9872BB66E14BB8897D1DB98D90CC8F
          C440CDE217711F0F702D249F73740C7B43B23E5603399A41C6FB90CC568CE51E
          8E94D4732C84E4CBC011F47B0F74ECF1C3D88F5B153E578BC9F9A29DEB557C58
          08C3CF8B5668BE1736BE8664A36AC50FF31EF856CEDD159A053CC4DB1CBDC68D
          7E6C0CC3C01E7CC26A48CE0FD09EC1F5C2C2D190B4475E4665966B3897A3535D
          057795F340D13EC52276E050AD11F47B0F74EDF145BCC0B31CB5B1898378850B
          7893A34D7C2CD066BCACCB40AB6617667374127325BD520CC0099C2E375FC193
          BFF915741A59E777B8CAACDBCDAE6FA24EFC0086AC6D45A543752D0000000049
          454E44AE426082}
        TabOrder = 23
        OnClick = OpenBtnClick
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
      object agbExportToExcel: TAdvGlowButton
        Left = 902
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Export Lists|Export the current list to Microsoft Excel'
        HelpContext = 2330
        DisabledPicture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000467414D410000B18F0BFC6105000000097048597300000EC200000E
          C20115284A800000001974455874536F667477617265007061696E742E6E6574
          20342E302E3137336E9F630000022B494441545847ED96594F22411485F909FE
          509FEE9B711DC72592687C301A0CBEA1E2026E911075225187C5250A8A22AB01
          41202AB61066DE907B535DE966AAD30DC36832E1245F5275BAB8E726D54D95A9
          A38E5A55369F855034046EDF1E585D0BC0ECF6ABF05C8048320227973FC1E9D9
          8499AD59E8B1F5FF015BFEF74A6692E00BFA61F3680BCCEB93C23011C5F7A22E
          5255D26F5454DC0873A7165D2CA7D6AF6D006131DA12153782284C048BD196A8
          B8116AB51A8121D95296CF957ED30D5C4582709F8AC2E1B9877BD6DD05F2EEEA
          5FC6C8CA38F795416D6BC01BF4D18F4B52092C3BF330B63201E95C9A3C7F28C0
          D72172801E2C465BCAA2FD8B43F05A0FC7C0B39B73B0FF58A571F55715C657CD
          AA0652CF290243FCA9009F2BFDA61B40D60E1D145AA95620F394A1B1CBEB56AD
          41D04730A46D5B80F4DA0620F610E785C2F1B0EAB98C37E92330C475E7E673A5
          DF5203C3F65148A413BC81E8430CFA6C83AA35883BB2476088E3DAC9E74ABFA5
          069C9E0D0A7E29BD80549668FC695BF06DF93B942B652AB07DBC03FB81031AE3
          FBD0F812CAFFF71872F518549D01B2DF740337B13005C6EB5B80F329C734E48A
          39F22E6E2FF83A440ED083C5684B2E8827219EF91888DB20FB38460F9F294F4B
          6C0AC190B67E054651067D490372801E2C465BA2E2461085896031DA12153782
          284C048BD1169E80F89DE3455314A445E37FBF88A7B7BC7E038DFAF44BA951E1
          7DE0F8F204960EEC742F60F6BFD7EFEE912E36ECE87F90C9F40152DCF070DBCC
          D7030000000049454E44AE426082}
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA8640000001974455874536F667477
          617265007061696E742E6E657420342E302E3137336E9F630000024249444154
          5847ED96EB4B145118C6F78FE9736AA578C342E8832059869F05A1C81B461F84
          052FA45914A2B91A92482C6B168A371659F39288D7AD74152B306FB881B26511
          8B7FC0A3EFCB39D3CC768619B75541F6811F9CF3CCD9F779E1CCEC398EB8E28A
          560B9B7E74CD77C3D95785FCB602083BF65A0EAE606071108D234D28F19423A7
          291717AB2FFD8358FEFF1AFB328EE763AD287B5D81AC27D9CA3015ABFB9F2DD9
          0907AD1B5515B743EEE04D4BF2866E9F6D0384883197AAB81D54612A448CB954
          C5ED2045210B7B7E31FBABA81A70CF7A3014F0A2DEFB58F3F25B0BD8EB3FFA32
          52EB33355F2AA60D348FB6F08FB77E6EE146CB2DA43FCAC2F4B719F65CE36DDA
          3A4206582162CCA52F9A549B8C8D1F9B1CD83EF91245AFEEF078FFE017321AAE
          1A1A9808BE6728C41578A1CDF5FEB11B20EEBA8B3934140E61767D8EC795BD4E
          C31A428A4262B6054442CD650CAFF84419A0E743AFE1B9A479C9C55048E5B453
          9BEBFDA81A48A94BC7C8EA3B110F789787915873C5B08670CE543114726FA254
          9BEBFDA81A28F69471F0DADE1A82BFBFF3F8D4B620F9612A76FFEC7281FB6F1E
          A07AA096C7F43E44BE84F2FF9E42DC5F3D863340FAC76EE0ADBF87037D475B40
          F3ECA7D7F171FB137B1D539DDA3A4206582162CC250BD24948673E05D236489F
          C6E4D133FD6929452131FD0AEC2275660DC8002B448CB954C5EDA00A532162CC
          A52A6E0755980A11632E3A01E93BA78BA62AC88CC8FF7E158BA1807503913AF5
          4BA95DD17DE099AF11859D457C2F10F6C92B7C2DED8218C6751EE4701C028870
          E580821A00CE0000000049454E44AE426082}
        ShowDisabled = False
        TabOrder = 24
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
        DropDownButton = True
        DropDownSplit = False
        DropDownMenu = popExportList
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 17
    Top = 199
    object File1: TMenuItem
      Caption = '&File'
      GroupIndex = 10
      Hint = 'File related commands'
      object FileCompList: TMenuItem
        Caption = '&Open Company'
        HelpContext = 539
        Hint = 
          'Choose a new company to open from the list of available companie' +
          's.'
        ImageIndex = 0
        Visible = False
        OnClick = FCLClick
      end
      object FileCompSepBar: TMenuItem
        Caption = '-'
        Visible = False
      end
      object Print1: TMenuItem
        Caption = '&Print'
        HelpContext = 297
        Hint = 'Print the currently selected item to printer.'
        ImageIndex = 1
        OnClick = PrintBtnClick
      end
      object PrintSetup1: TMenuItem
        Caption = 'Print &Setup'
        HelpContext = 302
        Hint = 'Access the printer setup screen.'
        ImageIndex = 2
        OnClick = PrintSetup1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object FileExitItem: TMenuItem
        Caption = 'E&xit'
        Hint = 'Exit Exchequer.'
        ImageIndex = 3
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
        OnClick = XXXCopyItemClick
      end
      object XXXPasteItem: TMenuItem
        Caption = '&Paste'
        Hint = 'Paste from clipboard'
        ImageIndex = 15
        OnClick = XXXPasteItemClick
      end
    end
    object Daybooks1: TMenuItem
      Caption = '&Transactions'
      GroupIndex = 30
      object Sales1: TMenuItem
        Caption = '&Sales Transactions'
        HelpContext = 1
        ImageIndex = 4
        OnClick = MainSDBkBtnClick
      end
      object SODT1: TMenuItem
        Caption = 'Sales &Order Transactions'
        HelpContext = 1
        ImageIndex = 5
        OnClick = MainSDBkBtnClick
      end
      object SRN1: TMenuItem
        Caption = 'Sales &Return Transactions'
        HelpContext = 1659
        ImageIndex = 56
        OnClick = MainSDBkBtnClick
      end
      object N24: TMenuItem
        Caption = '-'
      end
      object Purch1: TMenuItem
        Caption = '&Purchase Transactions'
        HelpContext = 1
        ImageIndex = 6
        OnClick = MainSDBkBtnClick
      end
      object PODT1: TMenuItem
        Caption = 'P&urchase Order Transactions'
        HelpContext = 1
        ImageIndex = 7
        OnClick = MainSDBkBtnClick
      end
      object PRN1: TMenuItem
        Caption = 'Purchase R&eturn Transactions'
        HelpContext = 1652
        ImageIndex = 57
        OnClick = MainSDBkBtnClick
      end
      object N25: TMenuItem
        Caption = '-'
      end
      object Nom1: TMenuItem
        Caption = '&Nominal Transactions'
        HelpContext = 12
        ImageIndex = 8
        OnClick = MainSDBkBtnClick
      end
      object N26: TMenuItem
        Caption = '-'
      end
      object Stock1: TMenuItem
        Caption = 'Stoc&k Transactions'
        HelpContext = 390
        ImageIndex = 9
        OnClick = MainSDBkBtnClick
      end
      object WOP1: TMenuItem
        Caption = '&Works Order Processing Transactions'
        ImageIndex = 55
        OnClick = MainSDBkBtnClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object AddN1: TMenuItem
        Caption = '&Quick Add a new transaction'
        HelpContext = 9
        ImageIndex = 10
        OnClick = FAddBtnClick
      end
      object TeleSales1: TMenuItem
        Caption = '&TeleSales'
        HelpContext = 770
        ImageIndex = 12
        OnClick = TeleSales1Click
      end
      object JobCosting2: TMenuItem
        Caption = '&Job Costing Transactions'
        ImageIndex = 11
        OnClick = JobCosting2Click
      end
    end
    object Records1: TMenuItem
      Caption = '&Records'
      GroupIndex = 40
      object Cust1: TMenuItem
        Caption = '&Customers'
        HelpContext = 16
        ImageIndex = 16
        ShortCut = 113
        OnClick = OpenBtnClick
      end
      object mnuConsumers: TMenuItem
        Caption = 'Co&nsumers'
        OnClick = OpenBtnClick
      end
      object Supp1: TMenuItem
        Caption = '&Suppliers'
        HelpContext = 85
        ImageIndex = 17
        ShortCut = 114
        OnClick = OpenBtnClick
      end
      object N29: TMenuItem
        Caption = '-'
      end
      object NominalLedger1: TMenuItem
        Caption = '&General Ledger'
        HelpContext = 174
        ImageIndex = 18
        ShortCut = 115
        OnClick = MainNomBtnClick
      end
      object NominalLedger2: TMenuItem
        Caption = 'General Ledger &Views'
        ImageIndex = 18
        ShortCut = 8307
        OnClick = NominalLedger2Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object STree1: TMenuItem
        Caption = 'Stock &Tree'
        HelpContext = 150
        ImageIndex = 19
        ShortCut = 8314
        OnClick = MainStockBtnClick
      end
      object SList1: TMenuItem
        Caption = 'Stock &List'
        HelpContext = 178
        ImageIndex = 20
        ShortCut = 122
        OnClick = SList1Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object MLoc1: TMenuItem
        Caption = 'L&ocations'
        HelpContext = 501
        ImageIndex = 52
        OnClick = MLoc1Click
      end
      object CC1: TMenuItem
        Caption = 'C&ost Centres'
        HelpContext = 399
        ImageIndex = 53
        OnClick = CC1Click
      end
      object Dep1: TMenuItem
        Caption = '&Departments'
        HelpContext = 399
        ImageIndex = 54
        OnClick = CC1Click
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object JobCosting1: TMenuItem
        Caption = '&Job Costing Tree'
        HelpContext = 920
        ImageIndex = 21
        ShortCut = 118
        Visible = False
        OnClick = JobCosting1Click
      end
      object Empl1: TMenuItem
        Caption = '&Employees/Sub-contractors'
        ImageIndex = 22
        OnClick = Empl1Click
      end
      object JAnal1: TMenuItem
        Caption = 'Job &Analysis && Types'
        ImageIndex = 23
        OnClick = JAnal1Click
      end
    end
    object Search1: TMenuItem
      Caption = '&Search'
      GroupIndex = 50
      object QFCust1: TMenuItem
        Caption = 'for &Customer'
        HelpContext = 33
        ImageIndex = 24
        ShortCut = 119
        OnClick = CustQFBtnClick
      end
      object forConsumer1: TMenuItem
        Tag = 1
        Caption = 'for Consu&mer'
        ShortCut = 119
        OnClick = CustQFBtnClick
      end
      object QFSupp1: TMenuItem
        Tag = 2
        Caption = 'for &Supplier'
        HelpContext = 33
        ImageIndex = 25
        ShortCut = 119
        OnClick = CustQFBtnClick
      end
      object QFTrans1: TMenuItem
        Tag = 3
        Caption = 'for &Transaction'
        HelpContext = 33
        ImageIndex = 26
        ShortCut = 119
        OnClick = CustQFBtnClick
      end
      object QFStk1: TMenuItem
        Tag = 4
        Caption = 'for Stoc&k'
        HelpContext = 33
        ImageIndex = 27
        ShortCut = 119
        OnClick = CustQFBtnClick
      end
      object QFSerialF: TMenuItem
        Tag = 5
        Caption = 'for S&erial/Batch'
        HelpContext = 33
        ImageIndex = 28
        ShortCut = 119
        OnClick = CustQFBtnClick
      end
      object QFBinF: TMenuItem
        Tag = 6
        Caption = 'for B&in'
        HelpContext = 33
        ImageIndex = 28
        ShortCut = 119
        OnClick = CustQFBtnClick
      end
      object QFJobF: TMenuItem
        Tag = 7
        Caption = 'for &Job'
        HelpContext = 33
        ImageIndex = 29
        ShortCut = 119
        OnClick = CustQFBtnClick
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object mnuoptOrderPaymentsTracker: TMenuItem
        Caption = 'Order Payments Tracker'
        ShortCut = 24689
        OnClick = mnuoptOrderPaymentsTrackerClick
      end
      object mnuoptOrderPaymentsTrackerSep: TMenuItem
        Caption = '-'
      end
      object ObjectDrill1: TMenuItem
        Caption = '&ObjectDrill'
        HelpContext = 468
        ImageIndex = 30
        ShortCut = 8311
        OnClick = DDa1BtnClick
      end
      object ObjectCC1: TMenuItem
        Caption = 'O&bjectCredit Controller'
        HelpContext = 720
        Hint = 
          'Displays the ObjectCredit Controller for the last selected accou' +
          'nt.'
        ImageIndex = 31
        ShortCut = 16497
        OnClick = ObjectCC1Click
      end
      object ObjectStk1: TMenuItem
        Caption = 'ObjectStock En&quiry'
        HelpContext = 719
        ImageIndex = 32
        ShortCut = 16506
        OnClick = ObjectStk1Click
      end
      object ObjPrice1: TMenuItem
        Caption = 'Object&Price Lookup'
        HelpContext = 798
        ImageIndex = 47
        ShortCut = 24698
        OnClick = ObjPrice1Click
      end
    end
    object Proc1: TMenuItem
      Caption = '&Procedures'
      GroupIndex = 60
      object ChnagePr1: TMenuItem
        Caption = 'C&hange Period'
        HelpContext = 253
        ImageIndex = 33
        ShortCut = 117
        OnClick = ChangePr1Click
      end
      object N30: TMenuItem
        Caption = '-'
      end
      object GLRecon1: TMenuItem
        Caption = 'Reconcile &G/L Account'
        HelpContext = 559
        object GLRec1: TMenuItem
          Caption = '&Manual Reconciliation'
          ImageIndex = 50
          OnClick = GLRecon1Click
        end
        object GLRec2: TMenuItem
          Caption = '&Automatic Reconciliation'
          ImageIndex = 51
          OnClick = GLRecon1Click
        end
        object BankReconciliation: TMenuItem
          Caption = 'Bank Reconciliation Wizard'
          Visible = False
          OnClick = BankReconciliationClick
        end
        object BankRecReport: TMenuItem
          Caption = 'Statement Report'
          Visible = False
          OnClick = BankRecReportClick
        end
      end
      object PostingMenu1: TMenuItem
        Caption = '&Posting Menu'
        HelpContext = 48
        object PADBk1: TMenuItem
          Caption = '&Post all Daybooks'
          HelpContext = 48
          ImageIndex = 48
          OnClick = PADBk1Click
        end
        object PRep1: TMenuItem
          Caption = 'Posting &Reports'
          HelpContext = 48
          object G1: TMenuItem
            Caption = '&General Ledger Based'
            HelpContext = 715
            OnClick = PostingReport1Click
          end
          object DocBased1: TMenuItem
            Tag = 5
            Caption = '&Document Based'
            HelpContext = 716
            OnClick = PostingReport1Click
          end
        end
        object AutoDbkPost1: TMenuItem
          Tag = 20
          Caption = '&Automatic Daybook Post'
          HelpContext = 48
          OnClick = PADBk1Click
        end
        object XXXPartialUnpost1: TMenuItem
          Caption = 'Partial Unpost'
          HelpContext = 1231
          object XXXPartialUnpost2: TMenuItem
            Caption = '&By &Period'
            OnClick = PartialUnpost1Click
          end
          object XXXPartialUnpost3: TMenuItem
            Tag = 1
            Caption = 'By Posting &Run'
            OnClick = PartialUnpost1Click
          end
        end
        object XXXTotalUnpost1: TMenuItem
          Caption = 'Total Unpost'
          HelpContext = 1232
          OnClick = XXXTotalUnpost1Click
        end
      end
      object N31: TMenuItem
        Caption = '-'
      end
      object Batches1: TMenuItem
        Caption = '&Batch Payments'
        HelpContext = 40000
        object BPPY1: TMenuItem
          Caption = '&Purchase Payments'
          HelpContext = 40100
          ImageIndex = 49
          OnClick = BPPY1Click
        end
        object BPRep1: TMenuItem
          Caption = 'P&ayment Report'
          HelpContext = 40100
          OnClick = BPRep1Click
        end
        object BPRun1: TMenuItem
          Caption = 'Reproduce Pa&yment Batch'
          HelpContext = 40100
          OnClick = BPPY1Click
        end
        object BSRC1: TMenuItem
          Caption = '&Sales Receipts'
          HelpContext = 40100
          OnClick = BPPY1Click
        end
        object BPRep2: TMenuItem
          Caption = 'R&eceipt Report'
          HelpContext = 40100
          OnClick = BPRep1Click
        end
        object BPRun2: TMenuItem
          Caption = 'Reproduce Re&ceipt Batch'
          HelpContext = 40100
          OnClick = BPPY1Click
        end
      end
      object eRCT1: TMenuItem
        Caption = 'eRCT'
        OnClick = eRCT1Click
      end
      object N32: TMenuItem
        Caption = '-'
      end
      object XXXRAlloc1: TMenuItem
        Caption = 'R&etrieve Stored Allocations'
        object XXXSAlloc1: TMenuItem
          Tag = 1
          Caption = '&Customer Allocations'
          Visible = False
          OnClick = XXXAllocSRC1Click
        end
        object XXXPAlloc1: TMenuItem
          Caption = '&Supplier Allocations'
          Visible = False
          OnClick = XXXAllocSRC1Click
        end
      end
      object N33: TMenuItem
        Caption = '-'
      end
      object IRO1: TMenuItem
        Tag = 1
        Caption = '&Interactive Re-Ordering'
        ImageIndex = 34
        OnClick = SList1Click
      end
      object ST1: TMenuItem
        Tag = 2
        Caption = 'Stock &Take'
        ImageIndex = 35
        OnClick = SList1Click
      end
      object SV1: TMenuItem
        Caption = '&Stock Valuation'
        OnClick = SV1Click
      end
      object N34: TMenuItem
        Caption = '-'
      end
      object RGL1: TMenuItem
        Caption = '&Revalue General Ledger'
        HelpContext = 382
        ImageIndex = 36
        OnClick = RGL1Click
      end
      object N35: TMenuItem
        Caption = '-'
      end
      object Accruals1: TMenuItem
        Caption = '&Accruals'
        object PAccrualRep: TMenuItem
          Caption = 'P&urchase Delivery Note Accrual Report'
          OnClick = PAccrualRepClick
        end
        object PAccruals: TMenuItem
          Caption = 'Generate &Purchase Delivery Note Accruals'
          OnClick = PAccrualsClick
        end
        object SAccrualRep: TMenuItem
          Caption = 'S&ales Delivery Note Accrual Report'
          OnClick = PAccrualRepClick
        end
        object SAccruals: TMenuItem
          Caption = 'Generate &Sales Delivery Note Accruals'
          OnClick = PAccrualsClick
        end
        object N27: TMenuItem
          Caption = '-'
        end
        object PRAccrual1: TMenuItem
          Caption = 'Generate Purchase &Return Accruals'
          HelpContext = 1655
          OnClick = PRAccrual1Click
        end
        object SRAccrual1: TMenuItem
          Caption = 'Generate Sales R&eturn Accruals'
          OnClick = PRAccrual1Click
        end
      end
      object N36: TMenuItem
        Caption = '-'
      end
      object Export1: TMenuItem
        Caption = 'E&xport'
        Visible = False
        object VATCSV1: TMenuItem
          Caption = 'V&AT CSV'
          object ArrivalsECSSD1: TMenuItem
            Caption = '&Arrivals EC SSD'
            OnClick = ArrivalsECSSD1Click
          end
          object DispatchesECSSD1: TMenuItem
            Caption = '&Dispatches EC SSD'
            OnClick = DispatchesECSSD1Click
          end
          object ECSalesList2: TMenuItem
            Caption = 'E&C Sales List'
            OnClick = VEDIECSL1Click
          end
          object NewECSalesList2: TMenuItem
            Caption = 'E&C Sales List'
            OnClick = NewECSalesListJan10OnwardsClick
          end
        end
        object VATEDI1: TMenuItem
          Caption = '&VAT EDI'
          Visible = False
          object VEDIECSL1: TMenuItem
            Caption = '&EC Sales List'
            OnClick = VEDIECSL1Click
          end
          object NewECSalesListJan10Onwards: TMenuItem
            Caption = 'E&C Sales List'
            Visible = False
            OnClick = NewECSalesListJan10OnwardsClick
          end
          object VECSSDD1: TMenuItem
            Tag = 1
            Caption = '&Dispatches EC SSD'
            OnClick = VEDIECSL1Click
          end
          object VECSSDA1: TMenuItem
            Tag = 2
            Caption = '&Arrivals EC SSD'
            Visible = False
            OnClick = VEDIECSL1Click
          end
        end
        object CISEDI1: TMenuItem
          Caption = '&CIS EDI'
          object CISEDI2: TMenuItem
            Caption = '&Vouchers'
            OnClick = CISEDI2Click
          end
          object CISEDI3: TMenuItem
            Tag = 2
            Caption = '&End of Year (CIS36)'
            OnClick = CISEDI2Click
          end
        end
        object CISXML1: TMenuItem
          Caption = 'CIS &XML'
          object CISXML2: TMenuItem
            Caption = '&Monthly Return'
            OnClick = CISXML2Click
          end
        end
      end
      object N37: TMenuItem
        Caption = '-'
      end
      object Commitment1: TMenuItem
        Caption = 'Commitment Accounting'
        object RemoveCommit: TMenuItem
          Caption = '&Remove Committed Values from G/L'
          OnClick = RemoveCommitClick
        end
      end
      object N38: TMenuItem
        Caption = '-'
      end
      object XXXCIS2: TMenuItem
        Caption = '&Contractors Tax'
        object XXXCISL1: TMenuItem
          Tag = 1
          Caption = ' Ledger'
          OnClick = XXXCISGen1Click
        end
        object XXXCISG1: TMenuItem
          Caption = '&Generate CIS23 && CIS25'
          OnClick = XXXCISGen1Click
        end
        object XXXCISG2: TMenuItem
          Tag = 6
          Caption = 'G&enerate CIS24'
          OnClick = XXXCISGen1Click
        end
      end
      object N42: TMenuItem
        Caption = '-'
      end
      object IntrastatControlCentre1: TMenuItem
        Caption = 'Intrastat Control Centre'
        OnClick = IntrastatControlCentre1Click
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object mnuoptAnonymisationControlCentre: TMenuItem
        Caption = 'Anonymisation Control Centre'
        OnClick = mnuoptAnonymisationControlCentreClick
      end
    end
    object Reports1: TMenuItem
      Caption = 'Rep&orts'
      GroupIndex = 70
      object CreditControl1: TMenuItem
        Caption = '&Credit Control'
        object PayDueRep1: TMenuItem
          Tag = 1
          Caption = '&Payments due by Report'
          HelpContext = 620
          OnClick = AgedDebtors1Click
        end
        object RepDueRep1: TMenuItem
          Tag = 2
          Caption = '&Receipts due by Report'
          HelpContext = 620
          OnClick = AgedDebtors1Click
        end
        object mnuoptEndofDayPaymentsReport: TMenuItem
          Caption = 'Receipts in Date Range'
          OnClick = mnuoptEndofDayPaymentsReportClick
        end
        object AgedDebtors1: TMenuItem
          Tag = 3
          Caption = 'Aged &Debtors'
          object ADCons1: TMenuItem
            Tag = 3
            Caption = '&Consolidated'
            HelpContext = 42
            OnClick = AgedDebtors1Click
          end
          object ADMDC1: TMenuItem
            Tag = 13
            Caption = '&Split by Control Account'
            HelpContext = 42
            OnClick = AgedDebtors1Click
          end
        end
        object AgedCreditors1: TMenuItem
          Tag = 4
          Caption = 'Aged &Creditors'
          object ACCons1: TMenuItem
            Tag = 4
            Caption = '&Consolidated'
            HelpContext = 42
            OnClick = AgedDebtors1Click
          end
          object ACMDC1: TMenuItem
            Tag = 14
            Caption = '&Split by Control Account'
            HelpContext = 42
            OnClick = AgedDebtors1Click
          end
        end
        object mnuCustTransOnHoldRep: TMenuItem
          Tag = 1
          Caption = 'Customer Transactions on Hold'
          OnClick = mnuTransactionsOnHoldRepClick
        end
        object mnuSuppTransOnHoldRep: TMenuItem
          Tag = 2
          Caption = 'Supplier Transactions on Hold'
          OnClick = mnuTransactionsOnHoldRepClick
        end
        object Statements1: TMenuItem
          Tag = 2
          Caption = '&Statement Run'
          HelpContext = 621
          OnClick = Statements1Click
        end
        object ChaseLetters1: TMenuItem
          Tag = 3
          Caption = '&Chase Letters'
          HelpContext = 622
          OnClick = Statements1Click
        end
      end
      object NominalBased1: TMenuItem
        Caption = '&General Ledger Based'
        object TrialBalance1: TMenuItem
          Caption = '&Trial Balance'
          HelpContext = 623
          object Fulltb1: TMenuItem
            Tag = 1
            Caption = '&Full Trial Balance'
            HelpContext = 623
            OnClick = Fulltb1Click
          end
          object SimTB1: TMenuItem
            Tag = 8
            Caption = '&Simplified Trial Balance'
            HelpContext = 623
            OnClick = Fulltb1Click
          end
        end
        object ProfitLoss1: TMenuItem
          Tag = 2
          Caption = '&Profit && Loss'
          HelpContext = 624
          object mniProfitLossPeriodYear: TMenuItem
            Tag = 2
            Caption = 'Profit && Loss (Period && Year)'
            OnClick = Fulltb1Click
          end
          object mniProfitLossPriorYearComparison: TMenuItem
            Caption = 'Profit && Loss (Prior Year Comparison)'
            Enabled = False
            Visible = False
          end
        end
        object BalanceSheet1: TMenuItem
          Tag = 3
          Caption = '&Balance Sheet'
          HelpContext = 625
          object mniBalanceSheetPeriodYear: TMenuItem
            Tag = 3
            Caption = 'Balance Sheet (Period && Year)'
            OnClick = Fulltb1Click
          end
          object mniBalanceSheetPriorYearComparison: TMenuItem
            Caption = 'Balance Sheet (Prior Year Comparison)'
            Enabled = False
            Visible = False
          end
          object SApp1: TMenuItem
            Tag = 4
            Caption = 'Balance Sheet Movement'
            HelpContext = 626
            OnClick = Fulltb1Click
          end
        end
        object mniN15: TMenuItem
          Caption = '-'
        end
        object NomHist1: TMenuItem
          Tag = 2
          Caption = 'G&eneral Ledger History'
          HelpContext = 627
          OnClick = DocAnal1Click
        end
        object mniN16: TMenuItem
          Caption = '-'
        end
        object mniGLMonthlyBreakdown: TMenuItem
          Caption = 'GL Monthly Breakdown'
          Enabled = False
          Visible = False
        end
        object CCDepRep1: TMenuItem
          Caption = '&Cost Centre/ Dept Analysis'
          HelpContext = 629
          OnClick = CCDepRep1Click
        end
        object Accruals2: TMenuItem
          Caption = '&Accruals'
          object PAccrualRep2: TMenuItem
            Caption = '&Purchase Accruals'
            OnClick = PAccrualRepClick
          end
          object SAccrualRep2: TMenuItem
            Caption = '&Sales Accruals'
            OnClick = PAccrualRepClick
          end
        end
        object mniN17: TMenuItem
          Caption = '-'
        end
        object PRep2: TMenuItem
          Caption = 'Posting &Reports'
          HelpContext = 48
          object G2: TMenuItem
            Caption = 'Posting Run - &General Ledger Based'
            HelpContext = 715
            OnClick = PostingReport1Click
          end
          object DocBased2: TMenuItem
            Tag = 5
            Caption = 'Posting Run - &Document Based'
            HelpContext = 716
            OnClick = PostingReport1Click
          end
          object mniPrePostingReport: TMenuItem
            Caption = 'Pre-Posting Report'
            Enabled = False
            Visible = False
          end
        end
        object NomCode1: TMenuItem
          Tag = 4
          Caption = 'G&eneral Ledger Codes List'
          OnClick = List1Click
        end
        object mniNominalswithVAT: TMenuItem
          Caption = 'Nominals with VAT'
          Enabled = False
          Visible = False
        end
        object BankRec1: TMenuItem
          Tag = 1
          Caption = '&Bank Reconciliation'
          HelpContext = 580
          OnClick = BankRec1Click
        end
      end
      object CustRep1: TMenuItem
        Caption = '&Customer Based Reports'
        object List1: TMenuItem
          Caption = '&List of Traders'
          OnClick = Statements1Click
        end
        object mnuTradersonHoldRep: TMenuItem
          Caption = 'Traders on Hol&d'
          OnClick = mnuTradersonHoldRepClick
        end
        object AccDet1: TMenuItem
          Tag = 8
          Caption = '&Trader Details'
          HelpContext = 701
          OnClick = Statements1Click
        end
        object TradLed1: TMenuItem
          Tag = 5
          Caption = 'Trading &Ledger'
          HelpContext = 701
          OnClick = Statements1Click
        end
        object TradingHistory1: TMenuItem
          Tag = 8
          Caption = 'Trading &History'
          HelpContext = 704
          OnClick = DocAnal1Click
        end
        object mniVATTransactions: TMenuItem
          Caption = 'VAT Tran&sactions'
          Enabled = False
          Visible = False
        end
        object Labels2: TMenuItem
          Tag = 10
          Caption = 'Mailing &Labels '
          OnClick = Statements1Click
        end
        object VATRegList1: TMenuItem
          Tag = 9
          Caption = '&VAT Reg List '
          OnClick = List1Click
        end
      end
      object SuppRep1: TMenuItem
        Caption = '&Supplier Based Reports'
        object List2: TMenuItem
          Tag = 1
          Caption = '&List of Traders '
          OnClick = List1Click
        end
        object AccDet2: TMenuItem
          Tag = 8
          Caption = '&Trader Details'
          OnClick = Statements1Click
        end
        object TradLedg2: TMenuItem
          Tag = 5
          Caption = '&Trading Ledger'
          OnClick = Statements1Click
        end
        object Labels3: TMenuItem
          Tag = 10
          Caption = 'Mailing &Labels '
          OnClick = Statements1Click
        end
        object mniVATTransactions1: TMenuItem
          Caption = 'VAT Tran&sactions '
          Enabled = False
          Visible = False
        end
        object TradingHistory2: TMenuItem
          Tag = 9
          Caption = 'Trading &History'
          OnClick = DocAnal1Click
        end
        object VATRegList2: TMenuItem
          Tag = 10
          Caption = '&VAT Reg List'
          OnClick = List1Click
        end
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object SBased1: TMenuItem
        Caption = '&Stock Based'
        object SalesAnal1: TMenuItem
          Caption = '&Sales Analysis'
          object PrAnal1: TMenuItem
            Tag = 1
            Caption = '&Period Analysis'
            HelpContext = 660
            OnClick = PrAnal1Click
          end
          object CCAnal1: TMenuItem
            Tag = 2
            Caption = '&Cost Centre Analysis'
            HelpContext = 661
            OnClick = PrAnal1Click
          end
          object StkPRep1: TMenuItem
            Tag = 10
            Caption = 'Stock Sales by &Product'
            HelpContext = 662
            OnClick = StkPRep1Click
          end
          object StkCRep1: TMenuItem
            Tag = 11
            Caption = 'Stock Sales by &Customer'
            HelpContext = 662
            OnClick = StkPRep1Click
          end
        end
        object PriceList1: TMenuItem
          Tag = 8
          Caption = '&Price List'
          HelpContext = 664
          OnClick = PrAnal1Click
        end
        object N18: TMenuItem
          Caption = '-'
        end
        object SList2: TMenuItem
          Tag = 3
          Caption = 'S&tock List'
          HelpContext = 628
          OnClick = SList2Click
        end
        object mniNegativeStock: TMenuItem
          Caption = '&Negative Stock'
          Enabled = False
          Visible = False
        end
        object mniN14: TMenuItem
          Caption = '-'
        end
        object ReOrderList1: TMenuItem
          Tag = 1
          Caption = '&Re-Order Report'
          HelpContext = 666
          OnClick = SList2Click
        end
        object N19: TMenuItem
          Caption = '-'
        end
        object ValuationReport1: TMenuItem
          Tag = 4
          Caption = '&Valuation Report - Live'
          HelpContext = 667
          OnClick = SList2Click
        end
        object mniValuationReportLIVE: TMenuItem
          Tag = 5
          Caption = 'Valuation Report - Posted'
          OnClick = SList2Click
        end
        object ValRep2: TMenuItem
          Caption = '&Reconciliation/Valuation Report'
          HelpContext = 668
          OnClick = ValRep2Click
        end
        object ValRep3: TMenuItem
          Tag = 3
          Caption = '&Finished Goods Reconciliation Report'
          OnClick = ValRep2Click
        end
        object AgingReport1: TMenuItem
          Tag = 44
          Caption = 'Stock &Aging Report'
          OnClick = SList2Click
        end
        object mniN13: TMenuItem
          Caption = '-'
        end
        object StkHist1: TMenuItem
          Caption = 'Stock Full &History'
          HelpContext = 669
          OnClick = StkHist1Click
        end
        object mniStockSalesHistory: TMenuItem
          Caption = 'Stock Sal&es History'
          Enabled = False
          Visible = False
        end
        object mniStockPurchaseHistory: TMenuItem
          Caption = 'Stock Pur&chase History '
          Enabled = False
          Visible = False
        end
        object N20: TMenuItem
          Caption = '-'
        end
        object Backlog1: TMenuItem
          Caption = 'Stock Stat&us '
          Visible = False
          object OrdBkRep1: TMenuItem
            Tag = 5
            Caption = '&Sales Back Order '
            HelpContext = 670
            OnClick = KitBKRep1Click
          end
          object KitBKRep1: TMenuItem
            Tag = 1
            Caption = '&BOM Back Order'
            HelpContext = 671
            OnClick = KitBKRep1Click
          end
          object OrdShort1: TMenuItem
            Tag = 11
            Caption = 'Sales &Order Shortages'
            HelpContext = 672
            OnClick = KitBKRep1Click
          end
          object KitShortRep1: TMenuItem
            Tag = 2
            Caption = 'BO&M Shortages'
            HelpContext = 673
            OnClick = KitBKRep1Click
          end
          object OnOrder1: TMenuItem
            Tag = 12
            Caption = 'Stock on &Purchase Order '
            HelpContext = 674
            Visible = False
            OnClick = KitBKRep1Click
          end
        end
        object N21: TMenuItem
          Caption = '-'
        end
        object StkTakeList1: TMenuItem
          Tag = 2
          Caption = 'Stock Ta&ke Sheet'
          HelpContext = 675
          OnClick = SList2Click
        end
        object N22: TMenuItem
          Caption = '-'
        end
        object Labels1: TMenuItem
          Tag = 11
          Caption = '&Labels'
          HelpContext = 676
          OnClick = Statements1Click
        end
        object mniN19: TMenuItem
          Caption = '-'
        end
        object mniBOMReports: TMenuItem
          Caption = 'BOM Reports'
          Enabled = False
          Visible = False
          object mniComponentusage: TMenuItem
            Caption = 'Component usage'
          end
          object mniBOMComponents: TMenuItem
            Caption = 'BOM Components'
          end
          object mniBOMbuild: TMenuItem
            Caption = 'BOM build'
          end
        end
        object N23: TMenuItem
          Caption = '-'
        end
        object Bins1: TMenuItem
          Caption = 'B&ins'
          Visible = False
          object StockbyBin1: TMenuItem
            Tag = 1
            Caption = '&Stock Availability by Bin'
            OnClick = StockbyBin1Click
          end
          object StockHistorybyBin1: TMenuItem
            Tag = 3
            Caption = '&Bin History'
            OnClick = StockbyBin1Click
          end
        end
        object N28: TMenuItem
          Caption = '-'
        end
        object Returns1: TMenuItem
          Caption = '&Returns'
          object SalesRetAnal1: TMenuItem
            Tag = 1
            Caption = '&Sales Return Analysis'
            OnClick = SalesRetAnal1Click
          end
          object PurchRetAnal1: TMenuItem
            Caption = '&Purchase Return Analysis'
            OnClick = SalesRetAnal1Click
          end
        end
      end
      object mniN18: TMenuItem
        Caption = '-'
      end
      object mniSalesPurchaseOrders: TMenuItem
        Caption = 'Sales && Purchase Orders'
        object mniSalesOrders: TMenuItem
          Caption = '&Sales Orders'
          object mniOrdersStatus: TMenuItem
            Tag = 1
            Caption = 'Orders Status'
            OnClick = mniOrdersStatusClick
          end
          object mniOrdersDeliverednotInvoiced: TMenuItem
            Tag = 3
            Caption = 'Orders Delivered not Invoiced'
            OnClick = mniOrdersStatusClick
          end
          object mniOrdersnotFullyAllocated: TMenuItem
            Tag = 5
            Caption = 'Orders not Fully Allocated'
            OnClick = mniOrdersStatusClick
          end
          object mniSummaryReport: TMenuItem
            Tag = 7
            Caption = 'Picked Orders - Summary'
            OnClick = mniOrdersStatusClick
          end
          object mniDetailedReport: TMenuItem
            Tag = 8
            Caption = 'Picked Orders - Detailed'
            OnClick = mniOrdersStatusClick
          end
        end
        object mniPurchaseOrders: TMenuItem
          Caption = '&Purchase Orders'
          object mniOrdersStatus1: TMenuItem
            Tag = 2
            Caption = 'Orders Status'
            OnClick = mniOrdersStatusClick
          end
          object mniOrdersReceivednotInvoiced: TMenuItem
            Tag = 4
            Caption = 'Orders Received not Invoiced'
            OnClick = mniOrdersStatusClick
          end
          object mniOrdersPartReceived: TMenuItem
            Tag = 6
            Caption = 'Orders Part Received'
            OnClick = mniOrdersStatusClick
          end
        end
      end
      object DaybookReports1: TMenuItem
        Caption = '&Daybook Reports'
        object SalesDaybook1: TMenuItem
          Tag = 10
          Caption = '&Sales Daybook'
          HelpContext = 712
          OnClick = DocAnal1Click
        end
        object PurchaseDaybook1: TMenuItem
          Tag = 20
          Caption = '&Purchase Daybook'
          HelpContext = 712
          OnClick = DocAnal1Click
        end
        object ReceiptsDaybook1: TMenuItem
          Tag = 30
          Caption = '&Receipts Daybook'
          HelpContext = 713
          OnClick = DocAnal1Click
        end
        object PaymentsDaybook1: TMenuItem
          Tag = 40
          Caption = 'Pa&yments Daybook'
          HelpContext = 714
          OnClick = DocAnal1Click
        end
        object NominalDaybook1: TMenuItem
          Tag = 70
          Caption = '&Nominal Daybook'
          OnClick = DocAnal1Click
        end
        object SORDBook1: TMenuItem
          Tag = 50
          Caption = 'Sales &Order Daybook'
          HelpContext = 713
          OnClick = DocAnal1Click
        end
        object PORDBook1: TMenuItem
          Tag = 60
          Caption = 'P&urchase Order Daybook'
          HelpContext = 714
          OnClick = DocAnal1Click
        end
        object mniStockAdjustmentsDaybook: TMenuItem
          Caption = 'Stock Adjustments Daybook'
          Enabled = False
          Visible = False
        end
        object mniJobDaybook: TMenuItem
          Caption = 'Job Daybook'
          Enabled = False
          Visible = False
        end
      end
      object VRep1: TMenuItem
        Caption = '&VAT Reports'
        object VRet1: TMenuItem
          Caption = '&VAT Returns'
          HelpContext = 706
          OnClick = VRet1Click
        end
        object ECSalesList1: TMenuItem
          Tag = 4
          Caption = '&EC Sales List'
          HelpContext = 707
          OnClick = VRet1Click
        end
        object NewECSalesListRepJan10Onwards: TMenuItem
          Caption = 'E&C Sales List'
          Visible = False
          OnClick = NewECSalesListRepJan10OnwardsClick
        end
        object ECSalesDetailsRep: TMenuItem
          Tag = 1
          Caption = 'EC Sales List Breakdown'
          OnClick = NewECSalesListRepJan10OnwardsClick
        end
        object mniVATReconciliation1: TMenuItem
          Caption = 'VAT &Reconciliation'
          Enabled = False
          Visible = False
        end
        object ISReport1: TMenuItem
          Caption = '&Intrastat Report'
          object Arrivals1: TMenuItem
            Tag = 2
            Caption = '&Arrivals EC SSD'
            HelpContext = 708
            OnClick = VRet1Click
          end
          object Dispatches1: TMenuItem
            Tag = 1
            Caption = '&Dispatches EC SSD'
            HelpContext = 708
            OnClick = VRet1Click
          end
        end
      end
      object GeneralReports1: TMenuItem
        Caption = '&Misc. Reports'
        object DocAnal1: TMenuItem
          Caption = '&Document Analysis Report'
          HelpContext = 677
          OnClick = DocAnal1Click
        end
        object mnuPrintDocuments1: TMenuItem
          Tag = 88
          Caption = '&Print Range of Documents'
          OnClick = Statements1Click
        end
        object mniAuditTrail1: TMenuItem
          Caption = 'Audit Trail'
          object mniNomAuditTrail1: TMenuItem
            Tag = 3
            Caption = '&Nominal Based Audit Trail'
            HelpContext = 709
            OnClick = DocAnal1Click
          end
          object mniDocAudit1: TMenuItem
            Tag = 7
            Caption = '&Document Based Audit Trail'
            HelpContext = 710
            OnClick = DocAnal1Click
          end
          object AuditNotesReport: TMenuItem
            Caption = '&Audit Notes Report'
            object Customers1: TMenuItem
              Caption = '&Customers'
              OnClick = Customer1Click
            end
            object Jobs1: TMenuItem
              Caption = '&Jobs'
              OnClick = Jobs1Click
            end
            object Stock2: TMenuItem
              Caption = '&Stock'
              OnClick = Stock2Click
            end
            object Suppliers1: TMenuItem
              Caption = '&Suppliers'
              OnClick = Supplier1Click
            end
            object transactions1: TMenuItem
              Caption = '&Transactions'
              OnClick = transactions1Click
            end
          end
        end
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object JobCostR1: TMenuItem
        Caption = '&Job Costing Based'
        Visible = False
        object JCRBS1: TMenuItem
          Caption = '&Reprint Backing Sheet'
          HelpContext = 1209
          OnClick = JCRBS1Click
        end
        object JCEL1: TMenuItem
          Caption = '&Employee Based'
          object JCEL2: TMenuItem
            Tag = 1
            Caption = '&Employee List'
            HelpContext = 1217
            OnClick = JCEL2Click
          end
          object JCEL3: TMenuItem
            Tag = 2
            Caption = '&Global Time Rates List'
            OnClick = JCEL2Click
          end
        end
        object mniN20: TMenuItem
          Caption = '-'
        end
        object Suby1: TMenuItem
          Caption = '&Sub-Contractor Based'
          Visible = False
          object Suby2: TMenuItem
            Tag = 1
            Caption = '&Sub-Contractors List'
            OnClick = Suby2Click
          end
          object mniSubContractorsUnverified: TMenuItem
            Caption = 'Sub-Co&ntractors Unverified'
            Enabled = False
            Visible = False
          end
          object CISRet2: TMenuItem
            Tag = 22
            Caption = 'CIS &Monthly Return'
            OnClick = CISRet1Click
          end
          object RCTRet1: TMenuItem
            Tag = 21
            Caption = 'R&CT47/48/30 Return'
            OnClick = CISRet1Click
          end
        end
        object JCJH1: TMenuItem
          Caption = '&Job History'
          HelpContext = 1218
          OnClick = JCJH1Click
        end
        object JCCE1: TMenuItem
          Caption = '&Customer Exposure'
          HelpContext = 1216
          OnClick = JCCE1Click
        end
        object JCBA1: TMenuItem
          Caption = '&Budget Analysis'
          HelpContext = 1215
          OnClick = JCBA1Click
        end
        object JCAA1: TMenuItem
          Caption = '&Actual Analysis'
          HelpContext = 901
          OnClick = JCAA1Click
        end
        object JCWIP1: TMenuItem
          Caption = '&Work in Progress'
          HelpContext = 1219
          OnClick = JCWIP1Click
        end
        object JCBR1: TMenuItem
          Caption = '&Billing Report'
          HelpContext = 1214
          OnClick = JCBR1Click
        end
        object N12: TMenuItem
          Caption = '-'
        end
        object AppsRep1: TMenuItem
          Caption = 'A&pplication Reports'
          HelpContext = 1553
          object AppsRep2: TMenuItem
            Tag = 3
            Caption = '&Purchase Application Analysis'
            OnClick = AppsRep2Click
          end
          object AppsRep4: TMenuItem
            Tag = 4
            Caption = '&Sales Application Analysis'
            OnClick = AppsRep2Click
          end
          object AppsRep20: TMenuItem
            Tag = 20
            Caption = 'P&urchase Applications Due'
            OnClick = AppsRep2Click
          end
          object AppsRep21: TMenuItem
            Tag = 21
            Caption = 'S&ales Applications Due'
            OnClick = AppsRep2Click
          end
        end
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object WOPRep1: TMenuItem
        Caption = '&Works Order Based'
        object WOPF1: TMenuItem
          Tag = 1
          Caption = '&Fulfilment'
          HelpContext = 1224
          OnClick = WOPF1Click
        end
        object WOPF3: TMenuItem
          Tag = 11
          Caption = '&Single Order Explosion'
          HelpContext = 1225
          OnClick = WOPF1Click
        end
        object WOPF2: TMenuItem
          Tag = 2
          Caption = '&Order Status'
          HelpContext = 1226
          OnClick = WOPF1Click
        end
        object KitBKRep2: TMenuItem
          Tag = 1
          Caption = '&Trial Kitting Report'
          HelpContext = 1227
          OnClick = KitBKRep1Click
        end
        object WOPWIP1: TMenuItem
          Caption = '&Works Orders in Progress'#13#10
          HelpContext = 1228
          OnClick = WOPWIP1Click
        end
      end
      object RWSepBar: TMenuItem
        Caption = '-'
        Visible = False
      end
      object ReportWriters1: TMenuItem
        Caption = '&Report Writers'
        Hint = 'Exchequer Reporting Utilities'
        object RWriter: TMenuItem
          Caption = '&Report Writer'
          ImageIndex = 37
          OnClick = RWriterClick
        end
        object VisualReportWriter1: TMenuItem
          Caption = 'Visual Report Writer'
          Hint = 'Visual Report Writer'
          OnClick = VisualReportWriter1Click
        end
      end
      object mniCustomReports: TMenuItem
        Caption = 'Custom Reports'
        Visible = False
      end
    end
    object Utilities1: TMenuItem
      Caption = '&Utilities'
      GroupIndex = 80
      object Diary1: TMenuItem
        Caption = '&Workflow Diary'
        ImageIndex = 38
        OnClick = DiaryBtnClick
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object VS1: TMenuItem
        Caption = '&VAT SetUp'
        HelpContext = 280
        ImageIndex = 39
        ShortCut = 116
        OnClick = VS1Click
      end
      object CS1: TMenuItem
        Caption = '&Currency Setup'
        HelpContext = 419
        ImageIndex = 40
        ShortCut = 16505
        OnClick = CS1Click
      end
      object SS1: TMenuItem
        Caption = '&System Setup'
        object GS1: TMenuItem
          Caption = '&General Settings'
          HelpContext = 49
          OnClick = GS1Click
        end
        object mniUserManagement: TMenuItem
          Caption = '&User Management'
          HelpContext = 389
          OnClick = mniUserManagementClick
        end
        object mniMyUserProfile: TMenuItem
          Caption = 'My User &Profile'
          HelpContext = 389
          OnClick = mniMyUserProfileClick
        end
        object mniChangeMyPassword: TMenuItem
          Caption = 'Change &My Password'
          HelpContext = 1230
          OnClick = mniChangeMyPasswordClick
        end
        object LockScreen1: TMenuItem
          Caption = 'Loc&k Exchequer'
          HelpContext = 1223
          OnClick = LockScreen1Click
        end
        object DocNum1: TMenuItem
          Caption = '&Document Numbers'
          HelpContext = 387
          OnClick = DocNum1Click
        end
        object CCodes1: TMenuItem
          Caption = '&Control Codes'
          HelpContext = 310
          OnClick = CCodes1Click
        end
        object RetReasons1: TMenuItem
          Caption = '&Return Line Reasons'
          OnClick = RetReasons1Click
        end
        object XXXMUO1: TMenuItem
          Caption = '&Licence options'
          object XXXSysLic1: TMenuItem
            Caption = '&System Licence'
            OnClick = XXXSysLic1Click
          end
          object XXXMULic1: TMenuItem
            Tag = 1
            Caption = '&Multi User Licence'
            OnClick = XXXMULic1Click
          end
          object XXXRSetMU1: TMenuItem
            Tag = 2
            Caption = '&Reset Logged in Users'
            OnClick = XXXMULic1Click
          end
          object XXXLicMod1: TMenuItem
            Caption = '&Licence Modules'
            OnClick = XXXLicMod1Click
          end
        end
        object mnuTraderBankCardAudit: TMenuItem
          Caption = 'System Audit'
          OnClick = mnuTraderBankCardAuditClick
        end
        object XXXErrLogs1: TMenuItem
          Caption = '&Error Logs'
          Visible = False
          OnClick = XXXErrLogs1Click
        end
        object MenItem_UserFields: TMenuItem
          Caption = 'User Defined Fields'
          OnClick = MenItem_UserFieldsClick
        end
        object mnuoptCreditCardPaymentGateway: TMenuItem
          Caption = 'Credit Card Payment Gateway'
          OnClick = mnuoptCreditCardPaymentGatewayClick
        end
      end
      object CIS1: TMenuItem
        Caption = 'CIS Setup'
        Visible = False
        OnClick = CIS1Click
      end
      object N41: TMenuItem
        Caption = '-'
      end
      object eBankingSetup: TMenuItem
        Caption = 'eBanking Setup'
        OnClick = eBankingSetupClick
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object FormDesigner1: TMenuItem
        Caption = '&Form Designer'
        HelpContext = 115
        ImageIndex = 41
        OnClick = FormDesigner1Click
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object MoveStk1: TMenuItem
        Caption = '&Move Stock Category'
        Visible = False
        OnClick = MoveStk1Click
      end
      object N39: TMenuItem
        Caption = '-'
        Visible = False
      end
      object mnuCheckSQLPostingCompatibility: TMenuItem
        Caption = 'Check SQL Posting Compatibility'
        Visible = False
        OnClick = mnuCheckSQLPostingCompatibilityClick
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object DataReuild1: TMenuItem
        Caption = '&Data Rebuild'
        object XXXCAcc1: TMenuItem
          Caption = '&Check All Accounts'
          HelpContext = 1229
          OnClick = XXXCAcc1Click
        end
        object XXXCAllGLYTDBal: TMenuItem
          Caption = 'Check All General Ledger Cumulative / YTD Balances'
          OnClick = XXXCAllGLYTDBalClick
        end
        object XXXCASL1: TMenuItem
          Caption = 'Check All &Stock levels'
          HelpContext = 1229
          OnClick = XXXCASL1Click
        end
        object XXXCGBOM1: TMenuItem
          Caption = 'Check All Stock &BOM Costs'
          HelpContext = 1229
          OnClick = XXXCGBOM1Click
        end
        object XXXCAGLT1: TMenuItem
          Caption = 'Check Every &G/L Actual Totals'
          OnClick = XXXReCalcGLHed1Click
        end
        object XXXCACCDL1: TMenuItem
          Caption = 'Check All CC/&Dept balances'
          HelpContext = 1229
          OnClick = XXXCACCDL1Click
        end
        object XXXCAJT1: TMenuItem
          Caption = 'Check All &Job Totals'
          HelpContext = 1229
          OnClick = XXXCAJT1Click
        end
        object XXXVerifyJA1: TMenuItem
          Tag = 43
          Caption = '&Verify All Job Actuals'
          Visible = False
          OnClick = XXXRestJA1Click
        end
        object XXXRestJA1: TMenuItem
          Tag = 42
          Caption = '&Reset All Job Actuals'
          HelpContext = 1229
          OnClick = XXXRestJA1Click
        end
        object CheckCustomerStockAnalysis1: TMenuItem
          Caption = 'Check Customer Stock &Analysis'
          OnClick = CheckCustomerStockAnalysis1Click
        end
        object mnuUnallocateAllTransactions: TMenuItem
          Caption = '&Unallocate All Transactions'
          object mnuUnallocateCustomers: TMenuItem
            Caption = '&Customers'
            OnClick = mnuUnallocateCustomersClick
          end
          object mnuUnallocateConsumers: TMenuItem
            Tag = 1
            Caption = 'C&onsumers'
            OnClick = mnuUnallocateCustomersClick
          end
          object mnuUnallocateSuppliers: TMenuItem
            Tag = 2
            Caption = '&Suppliers'
            OnClick = mnuUnallocateCustomersClick
          end
        end
      end
      object DelAudit1: TMenuItem
        Caption = 'D&elete Audited Data'
        object Purge1: TMenuItem
          Tag = 1
          Caption = '&Accounting Data'
          OnClick = Purge1Click
        end
        object Purge2: TMenuItem
          Tag = 2
          Caption = '&Orders'
          OnClick = Purge1Click
        end
      end
      object N40: TMenuItem
        Caption = '-'
      end
      object SpellCheck1: TMenuItem
        Caption = 'Spell Check'
        ShortCut = 8315
        OnClick = SpellCheck1Click
      end
    end
    object Window1: TMenuItem
      Caption = '&Window'
      GroupIndex = 90
      Hint = 'Window related commands such as Tile and Cascade'
      object WindowCascadeItem: TMenuItem
        Caption = '&Cascade'
        Hint = 'Arrange windows to overlap'
        ImageIndex = 42
        OnClick = WindowCascadeItemClick
      end
      object WindowTileItem: TMenuItem
        Caption = '&Tile'
        Hint = 'Arrange windows without overlap'
        ImageIndex = 43
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
      OnClick = Help1Click
      object XXXSDebug: TMenuItem
        Caption = '&Show Debug'
        Visible = False
        OnClick = XXXSDebugClick
      end
      object XXXdbClear1: TMenuItem
        Caption = '&Clear Debug'
        OnClick = XXXdbClear1Click
      end
      object XXXRPos: TMenuItem
        Caption = '&Reset Positions'
        Visible = False
        OnClick = XXXRPosClick
      end
      object HBG1: TMenuItem
        Caption = '&Hide Background'
        OnClick = HBG1Click
      end
      object ScreenPosition1: TMenuItem
        Caption = 'Screen Position'
        object MenItem_SaveCoordinates: TMenuItem
          Caption = '&Save Coordinates'
          OnClick = MenItem_SaveCoordinatesClick
        end
        object MenItem_ResetToDefault: TMenuItem
          Caption = '&Reset To Default'
          OnClick = MenItem_ResetToDefaultClick
        end
      end
      object XXXDisHKey1: TMenuItem
        Caption = '&Disable Hot Keys'
        OnClick = XXXDisHKey1Click
      end
      object XXXSPAccess1: TMenuItem
        Caption = 'Special access'
        Visible = False
        object XXXAllocSRC1: TMenuItem
          Tag = 1
          Caption = 'A&llocate SRC'
          Visible = False
          OnClick = XXXAllocSRC1Click
        end
        object XXXAllocPPY1: TMenuItem
          Caption = 'All&ocate PPY'
          Visible = False
          OnClick = XXXAllocSRC1Click
        end
        object XXXAllocSRC2: TMenuItem
          Tag = 1
          Caption = 'Allocate SRC &Trans'
          Visible = False
          OnClick = XXXAllocSRC1Click
        end
        object XXXAllocPPY2: TMenuItem
          Caption = 'Allocate PPY T&rans'
          Visible = False
          OnClick = XXXAllocSRC1Click
        end
        object XXXUnalocate1: TMenuItem
          Caption = '&Debug Cradle'
          OnClick = XXXUnalocate1Click
        end
        object XXXCISGen1: TMenuItem
          Caption = 'CIS Generate'
          Visible = False
          OnClick = XXXCISGen1Click
        end
        object XXXReCalcGLHed1: TMenuItem
          Caption = 'Recalc G/L Heading totals'
          OnClick = XXXReCalcGLHed1Click
        end
        object XXXTranCradle1: TMenuItem
          Caption = 'Transaction Cradle'
          OnClick = XXXTranCradle1Click
        end
        object XXXResetbusylock1: TMenuItem
          Caption = 'Reset Thread busy lock'
          OnClick = XXXResetbusylock1Click
        end
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object HelpT1: TMenuItem
        Caption = '&Help Contents'
        ImageIndex = 44
        OnClick = HelpT1Click
      end
      object HelpSearchItem: TMenuItem
        Caption = '&Search for Help On...'
        Hint = 'Search help file for a topic'
        ImageIndex = 44
        OnClick = HelpSearchItemClick
      end
      object HelpHowToUse: TMenuItem
        Caption = '&How to Use Help'
        ImageIndex = 44
        OnClick = HelpHowToUseClick
      end
      object What1: TMenuItem
        Caption = '&What'#39's This?'
        Hint = 
          '|After clicking, place cursor over any item you require help on,' +
          ' and click over it.'
        ImageIndex = 45
        ShortCut = 16496
        OnClick = WhatTBtnClick
      end
      object UpdateInformationDetails1: TMenuItem
        Caption = 'Last Upgrade Information'
        HelpContext = 40181
        Visible = False
        OnClick = UpdateInformationDetails1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Sess1: TMenuItem
        Tag = 1
        Caption = 'S&ession Information'
        GroupIndex = 100
        ImageIndex = 46
        OnClick = About1Click
      end
      object About1: TMenuItem
        Caption = '&About'
        GroupIndex = 100
        OnClick = About1Click
      end
      object XXXBang: TMenuItem
        Caption = 'Bang!'
        GroupIndex = 100
        Visible = False
        OnClick = XXXBangClick
      end
    end
    object XXXmnuCustomerPortal: TMenuItem
      Caption = 'Customer Portal'
      GroupIndex = 100
      OnClick = XXXmnuCustomerPortalClick
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 343
    Top = 201
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
  object tmPeriodDebug: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmPeriodDebugTimer
    Left = 582
    Top = 83
  end
  object ThemeManager1: TThemeManager
    Options = [toAllowNonClientArea, toAllowControls, toSubclassWinControl]
    Left = 195
    Top = 248
  end
  object popExportList: TPopupMenu
    OnPopup = popExportListPopup
    Left = 26
    Top = 72
  end
end
