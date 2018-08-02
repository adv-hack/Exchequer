object frmReportDesigner: TfrmReportDesigner
  Left = 569
  Top = 298
  Width = 701
  Height = 341
  HelpContext = 159
  Caption = 'frmReportDesigner'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  Menu = RWMainMenu
  OldCreateOrder = False
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  PixelsPerInch = 96
  TextHeight = 14
  object scRegionWindow: TScrollBox
    Left = 0
    Top = 59
    Width = 685
    Height = 201
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnMouseMove = scRegionWindowMouseMove
  end
  object StatusBar: TPanel
    Left = 0
    Top = 260
    Width = 685
    Height = 22
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 377
      Height = 22
      Align = alLeft
      BevelOuter = bvNone
      BorderWidth = 1
      TabOrder = 0
      object pnlCursorPos: TPanel
        Left = 0
        Top = 0
        Width = 150
        Height = 22
        BevelOuter = bvLowered
        Caption = 'X: 100mm  Y: 200mm'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object pnlSelectionCriteria: TPanel
        Left = 312
        Top = 0
        Width = 33
        Height = 22
        BevelOuter = bvLowered
        Caption = 'SEL'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object pnlRangeFilter: TPanel
        Left = 282
        Top = 0
        Width = 28
        Height = 22
        BevelOuter = bvLowered
        Caption = 'RF'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object pnlControlPos: TPanel
        Left = 152
        Top = 0
        Width = 128
        Height = 22
        BevelOuter = bvLowered
        Caption = 'T:10, L:10, H:4, W:30'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object pnlPrintIf: TPanel
        Left = 347
        Top = 0
        Width = 28
        Height = 22
        BevelOuter = bvLowered
        Caption = 'IF'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
    end
    object pnlHint: TPanel
      Left = 377
      Top = 0
      Width = 231
      Height = 22
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvLowered
      TabOrder = 1
      object pnlProgress: TPanel
        Left = 1
        Top = 1
        Width = 78
        Height = 20
        Align = alLeft
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Visible = False
      end
      object pbReportProgress: TProgressBar
        Left = 79
        Top = 1
        Width = 151
        Height = 20
        Align = alClient
        Min = 0
        Max = 100
        Smooth = True
        TabOrder = 1
        Visible = False
      end
    end
    object pnlCancel: TPanel
      Left = 608
      Top = 0
      Width = 77
      Height = 22
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      object btnCancelPrint: TButton
        Left = 1
        Top = 1
        Width = 75
        Height = 21
        Caption = '&Cancel'
        Enabled = False
        TabOrder = 0
        OnClick = btnCancelPrintClick
      end
    end
  end
  object AdvDockPanel: TAdvDockPanel
    Left = 0
    Top = 0
    Width = 685
    Height = 59
    MinimumSize = 3
    LockHeight = False
    Persistence.Location = plRegistry
    Persistence.Enabled = False
    ToolBarStyler = AdvToolBar
    UseRunTimeHeight = False
    Version = '2.9.0.0'
    object AdvToolBar1: TAdvToolBar
      Left = 3
      Top = 1
      Width = 436
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
      TextAutoOptionMenu = 'Add or Remove Buttons'
      TextOptionMenu = 'Options'
      ToolBarStyler = AdvToolBar
      ParentOptionPicture = True
      ToolBarIndex = -1
      object AdvToolBarSeparator1: TAdvToolBarSeparator
        Left = 42
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object AdvToolBarSeparator2: TAdvToolBarSeparator
        Left = 252
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object AdvToolBarSeparator3: TAdvToolBarSeparator
        Left = 302
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object tbSaveReport: TAdvGlowButton
        Left = 2
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Save Report...'
        DisabledPicture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000001694944415458C363601805231D30A20B7C7136AB67606060B8F4F413
          8AF8AB6973493258ECFA0506BD750B191818197E30FEFFBF987BEFE967D8D431
          51C317870E1E6458BC7811C3E2C58B3025FF3370FC67604CF8EC64A64833073C
          7CF490E1F2C58B0C972F5EC4A58495919121F28B8BA9124D1C40246065FCCF18
          3E900E60F8CFC0C036A00EC00658F0E68FFF48DCFFFF18FE336277AFBC9C3CA6
          F6FFFF29738010271BC3BB6FBFE07CF613C7187E585833303062E45C063B7B7B
          143EF39F5F0CE2D7CE53E60019410E0619410E84C0BEB5104C6530E06960D401
          38D300D792F50C8C1252D4C9FFCF9F327C8B0D222D04A8653903030303A3A434
          19E500147CF8FC85E1C1B3976459AC2025CE20C0CB4366410405DC9C1C0C0A52
          E26439809B936308274218F8FAFDC7C04681002F0F83813ACFC086C0EBF71FC9
          325C54909F603A18FC69809B9383A8D44C7507FC5EBB9C8151448C3A25E19B57
          A43BE0D7F409A39D965140170000551A5B6D939A8F470000000049454E44AE42
          6082}
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA793000001AA494441545809636018
          05233D0418D103E08BB3D97F90D8A5A79F40141CBF9A3617CE26862176FD0283
          DEBA850C0C8C0CEF19FFFF77E7DE7BFA34367D4CD80449153B74F020C3E2C58B
          C01843EF7F06C1FF0C8CFB3F3B993961C8010598809862F4F0D14386CB172F82
          310EC3B8191919367F7131754197A78A03D00DC5C1E762FCCFB81E5D8E9E0E60
          00262E9E017500BAE5203E0B88C08A1981A2402703493062FCFF8FE13F23F600
          93979307AB412680291F998B938DD301429C6C0CEFBEFD826B643F718CE18785
          35305B815C06170633ECECEDC1348C60FEF38B41FCDA7918172F8D611AAC1CC0
          AB8B02499EBDA750ECC41EA6145840AAD65107E04C845C4BD633304A48911AA2
          58D5FF7FFE94E15B6C1056399C51402DCB41B6324A4A8328AC186708C0547FF8
          FC85E1C1B397302E49B482943883002F46E1876206410770737230800C42D145
          2407A49790529C51404823B5E40986C0D7EF3F06360A407168A08E3F1E29090D
          A242E0F5FB8F64D9212AC8CF40281D0CFE3400F201089315044468C21905BFD7
          2E6760141123C208C24AFEBF798553114E07FC9A3E01A7A65189D110A0660800
          00CA6F5D98E5B78C2E0000000049454E44AE426082}
        ShowDisabled = False
        TabOrder = 0
        OnClick = tbSaveReportClick
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
      object tbReportText: TAdvGlowButton
        Left = 52
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Add '#39'free form'#39' text'
        DisabledPicture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000001C24944415458C3ED57BF4BC35010FE4E0B065A11B4D2B7D83CA9B37F
          81CE767573AB8B82D4FFC13F4110A3838BC1558863BBD4215467675B4875696C
          2D9484DA45CFA13F6C8586C82BA890DB2E77C97DEFBBCBC73D20B25F361A75A4
          E16541480D1F30159D7CA2AE52401ABE00F1D6D737E13AF9F9C2C08D7D832308
          D007EEE652433F29DDCDA900B87E6908BB95945F671A3F742CE8E5F5443BFB01
          56A2783DD186DD4A4E8C0702387DCE98CEC1BCA3D482734F12909B149F19F398
          0A1B8BCD623E5D05134C74D5FA0F00E826EA4C30F3E92A36169B45301502F3AD
          DB7B79532A1F4D7BDA6F4AE523EBF65E0633F00B160B9B78B166499AA55C985C
          7E6773AFB21D6A76FE0F034CE8025C1B4A064303514FB498DD5E7C3477CA00F6
          1FB7EB002EC75BD2FBBDF80385B094FFB916440022001180FFA38441CAF813E5
          9B1A80EFCA38951648C317962B52954E1CF2CCD3E5316BAA05E4316BF2CCD32B
          9D382C57A4A4E18BC90C1067ED5652B75B4910B0CB9A6F02505AC9A0F9821839
          E32903005910D746990B6CC1E14A35B7562A2BD5AF74AAE817FFF90C3CF80BC5
          4CFC4D692F7CF0170480AD700018751ED9DAEDD765E76A6755F562D2EDD33EAC
          11DD07FF947D020567A38FFF0814C70000000049454E44AE426082}
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000001BD494441545847ED97CB4EC2401486CFC185464B205CBC2C2424E056
          BA358AB43E81185F411385457912588026FA0A467C0229A2710B6E85A4C18517
          2E91508D2EE41843A8058180AD5613BA6B3A99FEF3CDCCC977100C7ED0E0FFC3
          DF0AE04ED46380E053A81046A41093D542C99D9059408A7ECE09392964165AEF
          6D04DC7B75110102AD8F7E5B59D89CBED514E0E8618ECD541DB1D69C04909676
          CDDC400142AE0278279FB40080FCF314248A1E1580210210022FED98452D09DC
          FB750E0952831148C8ACDF5EE27C4C2D1ABFF1F0F0C264A5083E6A0A10252B4C
          C86C78BE90CAC99648A6E214D5E7EACB2D48A62E39A4466A7D6D59D71B72727A
          4184263EC82FB511FD3F010EBD490EC750D9CB7EDB426FC46FE5836D2BD54CC0
          F000070B49164DA0DC6724B00262B36811E5084139ACD40061FB3AD8563F3413
          E844AE26D20D79E7F85180118111811101DD09A82B63B7CAF7E3856858471888
          C08740AEDA4B8145A6168B173D1CBC32395D84645CF6855D05F14AB608671567
          BAA790744AE9EF2B5987151B2EA52BB6726463E64E93961FDFCFB2E75587D217
          F4D7F26663C2AA1A1341A7C644F10820C8F66C4C863DD97A8CD7D57CBF13C8F0
          00EFDF27C2307AA3965C0000000049454E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 1
        OnClick = tbReportTextClick
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
      object tbReportImage: TAdvGlowButton
        Left = 92
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Add an Image'
        DisabledPicture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000018C4944415458C3ED94CD2E03511480BF4E27A3950ADA2ED828763C00
          1184E0152C2DEDED3D046FE00D2458B68958F8A936B1A8049D8541D262DA8E36
          B4A6A6331644489B68992161EEEADE734ECEF9EEF983FF7E3C8D84AB097D1E8B
          E12F79B4882D8DB6ED366B2ED8F99BC1A017D1CBDC4A5C9FFE1580703B4CF68B
          B4894C350B21D85DD32EBF87F1162004271AABCBE761A24908C1A9EEEE7C85F0
          7D0221383962EF2156138F238D6C443B039EA9268A66D507F17AD04D22C0A1A3
          0045DD02DD6A61E3385C825F194317E04700725A999C566EA84BCA1A4959730E
          C0A899ACC7D2ACC7D21835B34EBF779267FFB4D0B4BF96C7702771897A5779B9
          27AF981D8D00705F3108F8451666FA9C2B81922D113FCEBEBDE3A90C4AB6C47D
          C5602DA6707C51A23B20D11D90ECCF40A56AB0B52D63BDDB3396059BDB329D3D
          61CA7A8DE8D10DBD411FA10EC9FE0C44F7144A0FD53AF983E9E5BAF00840D530
          D938C8F0D4A037BE0570729E2725ABF5DB5592107CFE0F32B5A8133DBAB5B704
          4303219617C7DC45E402B8007F13C03DCFFAA49118CC698A7A0000000049454E
          44AE426082}
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA793000001C6494441545809ED543B
          4FC250183D858687C1A0C0A08BAFCD5F408C8F417F83A3A39B83A389838E3AC9
          E0EEEE60A28E9018169440E200092A83A809A808089147115A7B9B0642A9F482
          655069FAF57EDFB95FCF3D3DB72DF0DF0F46CD004F883B868055B5394D4CC0D6
          A6DBBCAFD9273718E4519761C661046BC4DE4190DB05E5A1AB00D710B038C5C2
          CC62875684AE02C8438F5819CC772142770192080B83054A117D114044D86511
          168DEDE89B00A5084FA8B2413065B04AE027F56D9A472227B451B046061C8F25
          71E2508C96535701794E5C9C44CB1272A1FAC701FABA05F2D21D878180DFE9C0
          5BAE04126A9B1B8EE740426D4E0DEBDA815A9DC789EF4E0A922B4903B10C2E6F
          B24AF8DBBAEBCFD01F7A44FABD2C11FAC34F58714F4AF947B9069B95C5DAF284
          54D35EBA7220912A20184D35B88391240846163FF225107D2860D46692A2D1A4
          91503B50AED6707E1187203419497E2662F631174A5C1DDEEB178C3B2C700E9B
          9A4D1A19B503DE40028562B58DAEC81BF19CAD4878B5C6E3F42A894FF13D9100
          8A0B9580D87D069178BA8D8E319960B0585BF0749E139D786DC13A15545B303B
          EDC4F6FA5C279E9EE7A81CE8999DE2C6818081030307283E943FDEF205CF0993
          FB8916F4AE0000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 2
        OnClick = tbReportImageClick
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
      object tbReportBox: TAdvGlowButton
        Left = 132
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Add a Box'
        DisabledPicture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000754944415458C363601805A360A40346386BCDC17ABADA1C62DFC8C0
          C0C0C034D021C08245EC13C3FFFF4F6813DE8C320C0C0C7CF81DF0FFFF138650
          87D53471C0EA03A10C8C8C5AC842031E05A30E1875C0A803461D30EA805107B0
          60AD32571F08A561754CB03DC0875E650EEB281805A360140000F5490F746D0C
          88D90000000049454E44AE426082}
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000734944415458C3ED96B10D80300C04DF286364103A182299D20C11BA
          0CC21EA6430845509948F057596E7CB28B3740C8DF91A35A567B75729A040086
          DE1B088DDE06B3EAB36F1901C47B01B38A3C6717012D0A91746E753F01052840
          010A508002A119995AD4318E1FFF81788DCC4F9F8010B203DCB51048A4C6C186
          0000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 3
        OnClick = tbReportBoxClick
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
      object tbReportDBField: TAdvGlowButton
        Left = 172
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Add a Database Field'
        DisabledPicture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000001D84944415458C3ED96416B13511485BF33C66693EAC658D068282A08
          492AB452BA71D3B49BEEECDA759722FE01F10F14D7FE040B5270A338C54577A5
          051713901A444489128314E2625233D7CD44A76012B4F362A13DABC7BB0FEEE1
          DC7BCF7D70DCA18151BF96032E80B5112D2275582C599A043283C336012C0359
          8C7D64EFF183D778D15BE6A7F647400003BAF1F934700DB84AE47DC20F9E216B
          52AD1C4A116F48851A184F81E7401D08E3B215803B98AEB8ED81245ED5449722
          300F7629BEFD06ACB1506EB827D0C3467016E336508C6FDED0E93C6169DA1C94
          E00FA896F7905EC4FD0130C9D858DE510FF423516A009F13CD59184D095ED672
          C86E819D015D04C6E34813AC05B4109B542BA11B05164B6DA43AE8722239401E
          3401ECFE4DF27F2B816775C43A9034A2EFC03A0B950FEEA7E0974D0737802520
          42AC512DBF1BFD26F18329FCE07AAA46B4BA15E625DDF48C73697235687A91ED
          DC9DCB36FB1258DD0ECF7B112BC029479AFD88E0F1FDD9DF240E34A14C330E93
          03648466FA6E4361B9DEF9DE6CF6619A991F6D850F00241B3FBC13A6881302FF
          8340E1D82BF0F14829903968976A2BFEE8F4E6366D186AF755C0643B896FB80B
          74E31CC39751D215076E335311F832EC5D24BE9AD976720F9CE048E02744C98D
          136F1000F10000000049454E44AE426082}
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000001E24944415458C3ED96BD6B145114C57FE711B2B27F4112106BDD8F42
          C21A09443491405A893641D2043B09E9AC2DEC826015ECC4C24E11911527A689
          206B58C4ECAE46B0B072491750C92CD9B9164E6016DD0DC1794B2039D5CCBD3C
          EE993BE7DEF3E0B8433DB3417D1818056B22B688F493ABB9769A045CEFB415C1
          1E03158CEFC89E13D46679F331DB2702B4811660401698019E10B980A0966775
          D37926A02AC61CB00894819DF8CC45E015A6695E56E54F0349ACD51D6D2E0177
          C1C6E3E857E03A53F9AA7F02FB58AD9DC178044CC49167B45AD798391FF9D0C0
          DF98CC7F435A8AF5017085C1C19C2F117639B55D053EC46F59E0427F7EC1EBFA
          30B23B60A741256024CE34C0BE005B887B4C1676FC74208A9A4865D078A238C0
          395011787198E28727305D309C9511F3C0AF44661B98C7ECADFF290058FF2C76
          F76E020F803DC40D5C1470B968FD21F0671C152FA91F4CE59FA626C2E54A9893
          74CB1967D3341D83868B6CE5F658A6D195C0F246587011EF818C27F7DD8D6074
          A994A9FF5384322D782C0E704A68211918E86C870DED3F2F96324AB3F2FD4A68
          00928DFCFF26ECDF85E48480178C1DFB0EBC3B521D18E85C976A0AEB98DBB461
          A8D9B503267B08841E3F388C6B1C6C46C9ADD8D3CD4C13C0E6817719F1C9CC56
          923E70822381DF204B9730470881BE0000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 4
        OnClick = tbReportDBFieldClick
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
      object tbReportFormula: TAdvGlowButton
        Left = 212
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Add a Formula'
        DisabledPicture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000002014944415458C3EDD6B96B55411406F09F31064D22A27141081805C1
          42B048A18832280A760A0EDADB28E83F64A3621A8B116C442C8C1910820B8295
          4DC8821689FA24628C897BE1289798EDE90B36EF830B33E7CCDCF9E62CDFBD34
          D1C47FC6AA2557A4DC81DDD8502C137821860F8D20D0BAC4E17B71729E750F70
          6F6509A4DC39E7F071CC603B9E352A058B456077C5FF480C7756A2065A16F16D
          AC8C9FAF5411B62E93C036297F2FE39A18A6568E40CABD38828E8AF544657C1B
          4FA4BC192D6278B5481DAD4637C6C530BBDC1474E235DE556CE3182DCF7B2977
          E13CDA17BD5E0C5FB11FA7EBD781948FE360995D13C358C577066BC5707D193A
          D2854BE813C3707D3AB0B030EDC1CD32EFC63964316429B7E222A670550C3529
          8FA117C3F574C142E829911B29617E89411C2AB73D5AD2784B0CDFCA9E11ECAC
          B70D17C2667C14C374C5D68F499CC501F48BA156F1BFC13A29B73782401B66E7
          29B6FBD88229310CCED9F36BFD9A4610F8F4C78B526EC1A11285F552DE370F69
          F8DC0802357448796DC576185B71038F7142CA1B2AFE2ECCCC49DB5F1318C577
          EC2AB7DF56080C8A61A27C253FE35465CFAEDF45FBCF047ECAF050692BF8823E
          0C14FF2CAE6040CA6D52DE841D785AFFFFC0C2B88B0B52EE11C368494B95E464
          A907523E8621310CD51B81B715F99D9973400D9731BD8468ADC6C3DFA2D54413
          4D34310F7E00CBBE94A7D9D37ABB0000000049454E44AE426082}
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000002104944415458C3EDD64D888E511407F01FA37CCD82309128D120B1B0
          91C5747DCC6C58B0B81B4A7616169394F219CD6C268B29242B8A85D5134BB318
          CC33929DC647622852221F35F9288AB270474F4FDE77BC7ADF6CDE7F3D75EF39
          CFE9FCEFFF9C7BBA34D1C47FC6A409FFC8F2366CC5A2647980DB62785B0F0253
          2648BE031730ADE4E9C3A1C612C8F205A5E42318C35A5CAA5709AA29B0A590FC
          8C18BA1BD10393ABF89614D6571BD584D514585A58AF96E53FD2FAA9185E378E
          4096EF412FDA0AD65385F55E9C93E52BD122868755FA682AD661440C1FFFB604
          F3F1082F0BB6110CA5EF952C6FC75DCCAB7ABC18BEA11B976B9F03597E1207D2
          2E8861B8E0CB304B0C9D7F3147DAF1045D6218AC6D0E541E4CDBB133EDD7E316
          7AC4D023CBA72705DFA0430CA3B27C187B3058CB2DA8840D68C18D24F31DF4E3
          503A6D6F2AE36E317C4F31D7B1A9D66B58092BF0410CEF0BB66378812BD887A3
          62182DF81F638E2C9F5B0F02ADF8F487663B865549FAFE52CCF8FF33EB41E033
          6694FA620A0E261516625729663CF1977A10788A36593EBB603B8CD5D886B338
          25CB1717FCCB31562ADB3F1318C20F6C4EA75F8323E817C3FD44E60B2E16623A
          5323D6A1097F8DE18174ADE02BBA7022F93FA203C76579AB2C5F96F6E76B7F0F
          54C67EDC93E51BC57013A32592CFF13C29D48701315CAB55816785F13B564A30
          9ADE05EF26185A5371FAF7D06AA289269AF8037E02144E903C1CA4D0C9000000
          0049454E44AE426082}
        Position = bpRight
        ShowDisabled = False
        TabOrder = 5
        OnClick = tbReportFormulaClick
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
      object tbRunReport: TAdvGlowButton
        Left = 262
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Run the report'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA793000002A7494441545809636018
          05031C028C30FB1D02B62BFC67FA3789E11F03274C8C2A3413C377660686DC7D
          EBBC1F62338F0526F89FF1AF29C37F465F0646980895E8FF0C0C7F19FE2F069A
          F6108831101386089D05E021A0AC2A2CCCC6C54613EB7F7DFB257C1087C97007
          A8E94BA8195BCAE0504699F0D9E34FD47099008F026666A63FB814512A8ECF6C
          B803D474C52E526A112EFDF8CC8647012727EB2F06066092453265CAEEA7605E
          8EAB3443DC8CEB603621C24C998F01A41E591DC46C6411041BEE00841082E56F
          2C02E794FBC8C1D9F8187C5C788DC4D08A57F5CF5FFFE01ABEFEFC0B67E363B0
          B3C063159F32B81C5E07ECB8FC0EAC3047429A01161D60013C04380A80EAF128
          4191C2EB00E4B85C94A189A2915A1CBC0ED870F60DD89E00605AE8DCF208CC46
          27D425B91840F2E8E2C4F299F029646765620061901A6E7666066C18263FFDFC
          6F86175F517311481F218C37043CF584E0FA91A3032E88C438FFF22FC385577F
          19CC25991982D55918F8D91991647133F13A0096F04096E32A07C0890E584E80
          ACF80F0C8013CFFE329C033AC6499E85C14B8999818305BF43F03A809872005B
          BEFF05CCB13BEEFD610039C6479985C14C1A77DEC4EB0062CA017CF9FEC38FFF
          0C4BAEFE665877F34FAFE2D44FDFEE67F36D06851432C6EB0062CA01701410C8
          F7DFFEFC97666064DCA438EDF31E0626C692FB193CF07A071E41BBEEFD096564
          F8BF0AD975A4B0D376FC2056F96F6052697990C5DB04D2803704400AA88C3FFD
          67F8DFF68B997732CC5CBA380018CCC0B606632F0BF3BF9E5BE97C90D20DEA02
          9A3A0068318391043383913853719535C724A89D2814480D8A00B91C60020346
          2D8AEE23FF19FE953EC8E23F81228AC6A14508DC61F8FFBF085B9643B31BCC65
          0293D4215E018D491762E6D122D672A07AEA2195499F45A967DA48320900D7E1
          AEA800569DB50000000049454E44AE426082}
        ShowDisabled = False
        TabOrder = 6
        OnClick = tbRunReportClick
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
      object tbReportTree: TAdvGlowButton
        Left = 312
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Return to Report Tree'
        DisabledPicture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000026A4944415458C3ED97CF6A135114C67FF7CE6426C94C4A5BDBD8486B
          F11FA288ABA22E5C545CAAA020E8AAA8F806AE7C029F4228B8D03710DD68370A
          A2D44D17425DA8855205DB6A923699CC3D2E52A26327335389D645BED59D3B73
          391FE7FBEE3967A08F3E7619EAD707B98F83E6148AFD80157B4233A766F8D873
          02F20CCD076E039594334D8407EA264BBD20A03BAB4F8C67080EE0A098915926
          7B41C0EEAC42FCA82089C801376436F3F79BC02286C7EA16F5F80CFC5DE48113
          585CE82EC1BF807078770980D3DD03DD305082F228384E6F92F08A3BA016D0C5
          A76AEA8D49CE80EBC0F8BE9E05DF820F721A533B939E81921FA95561CDB0FCB0
          CAFA7C036909CA6EBF2B9D74A95CF3C90DEE4451750078914CC0CD470D93D78C
          5EF4285FF6501AC4B4F94900F6C04EED641AE919C8BB51CE16B8633F2B74B066
          90503A7BAD6F06652BAC628682A2D44A3201A5DA1EE88260CDB0FCA8CAF78506
          D214008A0773F8C71CF69C2F6079291931A41070DDDF7B55F4FA0C682AD77DC6
          020FD33058458D1890565BAA54585616020919D4744C17D615E186E08C441B68
          5835E8BC466D8B229B6A6A613D9940C1CD6EA7A6B03AB7C19727756A8B4167BF
          7CC963EC8A4F61725B98CFE985C8CD4E203768313C5D6078BA808410D60D7649
          D3AA09EE68DC58D136600A817CACF1DEDF5B65FDF526FE510767AF26F82A148F
          E4A85CF53BB7418CD59668B8EB149242C0B6C1B6628D77E8EE101208E18641E9
          2DC319B087AC883F529A528C0416554CFCFD8F335EB7892D03429AB2B2BD1B4E
          B0042C67D25F44C488FC614B7EABCEBE6B260FA5E591E37845AFB7B3800A70EC
          799A132FD5B9E7A6FF3FD0C77F831F9354AF7D100984920000000049454E44AE
          426082}
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000027E4944415458C3ED97BD6B144118C67F33B3B77B9F2189E6E3C42028
          223636B1B008922888858242F0A311B44D91CAC2D2CA46FC0FA2E914FF022D44
          0216410C424240410B099822603EEF626E6FE7B5B878E4727BB79B78468B7BAA
          99D919DE87E77DDE7766A18D36FE31D4CE894C904333866208F0424F681EAA3B
          BC6B3901798BC337A681C18833EB0897D45DA65B414057470B9C8B111C2087E2
          8D4C72BE15049CEA28205F9B90A648035332197BFF32F00ACBB8BAC7523881BF
          8B2EE0360607B8119E82838070B9B1070E06B9C61E68848E1CF4F680EBB64684
          F77C07F5129DBEAFCECEF8CD15F05C387AA465C1B7910719C716C6A315C8656B
          7A5550B02C3EDF60F5E31652169453F9963BE391BF9925D1B9978CAA0BC0E3E6
          04BC64AD61929A9E2B197AAF65501AC456F8890F4EC75EED64D7A21548D67663
          65C0EB37D5B9BF629140AA6BE5358B7214261DA3A12835DB9C8052150F3480BF
          62597CB1C1FAFC1652924A773A9E207BDAE5D0C5142613A188258280E7EDBEAB
          6ACBA74393BF95A5DFCF60B72C26AD110B52AEA42A12C6C421D044414DD57441
          51116C0AEE6153B327D8B0E8A446D545911506E7179A134879F1ED541296A736
          597A5DA4F0C5AFAEF75ECDD07F3D4BEA585D9839A5903F526027129D86EEE114
          DDC3292480A06871729A7241F07A4C987EB3D19D705709FE36DED747CBAC7EF8
          49F6948BDBA7F17F08E99309F2A3D96A358835951475377C85CC3527E038E098
          50E39D78D085F842B069517ADB70169C2E53E38F884B29848061111B5EFF61C6
          03B3DF565CA22473F5B7E100D3C04CACFC8B046225D8E795FC4C0D7D5EAF5340
          8D50960946D08CA1F528C5625FECD76CACC0AA80EB3CA534F0043EB57F07DAF8
          7FF00B6A23B2AB46D81BF60000000049454E44AE426082}
        ShowDisabled = False
        TabOrder = 7
        OnClick = tbReportTreeClick
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
      object tbCancelReport_SourceImages: TAdvGlowButton
        Left = 392
        Top = 2
        Width = 40
        Height = 40
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA793000001BA494441545809636018
          E98011160096A1AB3859FF72B932FE676087895183FECFC8F0F337F3B7DDC757
          877DC7661E0B4C90FD378FFB7FC6FFEB617C6AD1400F3100CD0E049AB7018831
          10134CE43FE33F56189BDA343EB3E10EA0B6A5C49A078F02CF106D4B634B1962
          F591A4EEECF1279607D733ACC6A669C04300EE000919DEBBD85C480D314939FE
          3BB8CC81478194ACC02B0686FF28EAB65F7A07E67BEA09314CD9F514CC264428
          4B703280D423AB9394E67B8DCC4766C3430059909E6C780860B314D927396ED2
          D894502C86D701B06007591E37E33A51969929F13180D413A518A808AF033CF4
          85804A2028C795B81010E261856820921CDC6960C745482E0005E994DD4F89F2
          1355A3006431CCD645199A30265569BC698098720096EFF5A644E07418CFC38B
          45FF6D19C2E00AFE31F4321E653801E2E375004801B158ECF45A7C4A2D502419
          195601F9841D3024CA0152131DD0E728086F1410530E909AEF516C0772F03A40
          459C13A80482CC94F9200C2A93035E100DB803E051C0FA97F9F86FE6BF88BC4A
          7A5083B216C9BAE00E7054657C02D4BD1A88C942C082862C7D83270AC8723EAA
          A635A85C3CBCFF0C8FF1C88E4AD137040001CD5F09771BC3FC0000000049454E
          44AE426082}
        ShowDisabled = False
        TabOrder = 8
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
      object tbRunReport_SourceImages: TAdvGlowButton
        Left = 352
        Top = 2
        Width = 40
        Height = 40
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA793000002A7494441545809636018
          05031C028C30FB1D02B62BFC67FA3789E11F03274C8C2A3413C377660686DC7D
          EBBC1F62338F0526F89FF1AF29C37F465F0646980895E8FF0C0C7F19FE2F069A
          F6108831101386089D05E021A0AC2A2CCCC6C54613EB7F7DFB257C1087C97007
          A8E94BA8195BCAE0504699F0D9E34FD47099008F026666A63FB814512A8ECF6C
          B803D474C52E526A112EFDF8CC8647012727EB2F06066092453265CAEEA7605E
          8EAB3443DC8CEB603621C24C998F01A41E591DC46C6411041BEE00841082E56F
          2C02E794FBC8C1D9F8187C5C788DC4D08A57F5CF5FFFE01ABEFEFC0B67E363B0
          B3C063159F32B81C5E07ECB8FC0EAC3047429A01161D60013C04380A80EAF128
          4191C2EB00E4B85C94A189A2915A1CBC0ED870F60DD89E00605AE8DCF208CC46
          27D425B91840F2E8E2C4F299F029646765620061901A6E7666066C18263FFDFC
          6F86175F517311481F218C37043CF584E0FA91A3032E88C438FFF22FC385577F
          19CC25991982D55918F8D91991647133F13A0096F04096E32A07C0890E584E80
          ACF80F0C8013CFFE329C033AC6499E85C14B8999818305BF43F03A809872005B
          BEFF05CCB13BEEFD610039C6479985C14C1A77DEC4EB0062CA017CF9FEC38FFF
          0C4BAEFE665877F34FAFE2D44FDFEE67F36D06851432C6EB0062CA01701410C8
          F7DFFEFC97666064DCA438EDF31E0626C692FB193CF07A071E41BBEEFD096564
          F8BF0AD975A4B0D376FC2056F96F6052697990C5DB04D2803704400AA88C3FFD
          67F8DFF68B997732CC5CBA380018CCC0B606632F0BF3BF9E5BE97C90D20DEA02
          9A3A0068318391043383913853719535C724A89D2814480D8A00B91C60020346
          2D8AEE23FF19FE953EC8E23F81228AC6A14508DC61F8FFBF085B9643B31BCC65
          0293D4215E018D491762E6D122D672A07AEA2195499F45A967DA48320900D7E1
          AEA800569DB50000000049454E44AE426082}
        ShowDisabled = False
        TabOrder = 9
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
  object RWMainMenu: TMainMenu
    Left = 422
    Top = 111
    object menuFile: TMenuItem
      Caption = '&File'
      object miSaveReport: TMenuItem
        Caption = '&Save Report'
        ShortCut = 16467
        OnClick = sbSaveReportClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object miPrint: TMenuItem
        Caption = '&Print'
        ShortCut = 16464
        OnClick = miPrintClick
      end
      object miCancelPrint: TMenuItem
        Caption = 'Cancel print'
        Visible = False
        OnClick = btnCancelPrintClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object miCloseReport: TMenuItem
        Caption = '&Close Report Designer'
        OnClick = miCloseReportClick
      end
    end
    object menuEdit: TMenuItem
      Caption = '&Edit'
      OnClick = menuEditClick
      object miCut: TMenuItem
        Caption = 'Cu&t'
        ShortCut = 16472
        OnClick = miCutClick
      end
      object miCopy: TMenuItem
        Caption = '&Copy'
        ShortCut = 16451
        OnClick = miCopyClick
      end
      object miPaste: TMenuItem
        Caption = '&Paste'
        ShortCut = 16470
        OnClick = miPasteClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object miDelete: TMenuItem
        Caption = '&Delete'
        OnClick = miDeleteClick
      end
    end
    object menuControls: TMenuItem
      Caption = '&Controls'
      object miAddText: TMenuItem
        Caption = 'Add &Text Control'
        ShortCut = 16468
        OnClick = tbReportTextClick
      end
      object miAddImage: TMenuItem
        Caption = 'Add &Image Control'
        ShortCut = 16457
        OnClick = tbReportImageClick
      end
      object miAddBox: TMenuItem
        Caption = 'Add &Box Control'
        ShortCut = 16450
        OnClick = tbReportBoxClick
      end
      object miAddDBField: TMenuItem
        Caption = 'Add &DB Field Control'
        ShortCut = 16452
        OnClick = tbReportDBFieldClick
      end
      object miAddFormula: TMenuItem
        Caption = 'Add &Formula Control'
        ShortCut = 16454
        OnClick = tbReportFormulaClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object miControlsTree: TMenuItem
        Caption = '&Controls Tree'
        OnClick = miControlsTreeClick
      end
    end
    object menuReport: TMenuItem
      Caption = '&Report'
      object miDefaultFont: TMenuItem
        Caption = '&Default Font'
        OnClick = miDefaultFontClick
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object miRangeFilters: TMenuItem
        Caption = '&Range Filters'
        OnClick = miRangeFiltersClick
      end
      object miInputFields: TMenuItem
        Caption = '&Input Fields'
        OnClick = miInputFieldsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miAddReportSection: TMenuItem
        Caption = 'Add New &Section Header/Footer'
        OnClick = miAddReportSectionClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object miReportProperties: TMenuItem
        Caption = 'Report &Properties'
        OnClick = miReportPropertiesClick
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object Contents1: TMenuItem
        Caption = 'Help &Contents'
        OnClick = Contents1Click
      end
      object SearchforHelpOn1: TMenuItem
        Caption = '&Search for Help On...'
        OnClick = SearchforHelpOn1Click
      end
      object HowtoUseHelp1: TMenuItem
        Caption = '&How to Use Help'
        OnClick = HowtoUseHelp1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Caption = '&About Visual Report Writer'
        OnClick = About1Click
      end
    end
  end
  object ilRegionIcons: TImageList
    AllocBy = 1
    Height = 21
    Masked = False
    Left = 517
    Top = 97
    Bitmap = {
      494C010107000900040010001500FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003F0000000100200000000000003F
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000039FF000039FF000039
      FF00D6EFFF000039FF000039FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF0094636B00D6EFFF009463
      6B0094636B00D6EFFF0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B00D6EFFF009463
      6B0094636B00D6EFFF0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000039FF00D6EFFF000039
      FF000039FF00D6EFFF000039FF000039FF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF0094636B00D6EFFF0094636B009463
      6B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000039FF000039FF000039
      FF00D6EFFF000039FF000039FF00D6EFFF000039FF00D6EFFF000039FF000039
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF0094636B00D6EFFF0094636B009463
      6B00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF00D6EFFF00D6EFFF000039
      FF00D6EFFF000039FF00D6EFFF000039FF000039FF00D6EFFF000039FF000039
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF009463
      6B00D6EFFF0094636B00D6EFFF0094636B0094636B00D6EFFF0094636B009463
      6B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF009463
      6B00D6EFFF0094636B00D6EFFF0094636B0094636B00D6EFFF0094636B009463
      6B00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF00D6EFFF00D6EFFF009463
      6B0094636B0094636B0094636B0094636B0094636B0094636B0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF009463
      6B0094636B0094636B0094636B0094636B0094636B0094636B0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF009463
      6B0094636B0094636B0094636B0094636B0094636B0094636B0094636B009463
      6B0094636B0094636B0094636B00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF0094636B0094636B009463
      6B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF0094636B0094636B0094636B00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF0094636B0094636B0094636B00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF0094636B0094636B0094636B00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF0094636B0094636B009463
      6B0094636B0094636B0094636B0094636B0094636B0094636B0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B0094636B0094636B0094636B0094636B0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B0094636B0094636B0094636B0094636B0094636B009463
      6B0094636B0094636B0094636B00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF0094636B00D6EFFF0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF0094636B00D6EFFF0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF0094636B00D6EFFF0094636B009463
      6B0094636B0094636B0094636B00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF0094636B0094636B009463
      6B0094636B0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF0094636B0094636B00D6EF
      FF0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B00D6EF
      FF0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B00D6EF
      FF0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B00D6EFFF009463
      6B0094636B00D6EFFF0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B00D6EFFF009463
      6B0094636B00D6EFFF0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B00D6EFFF009463
      6B0094636B00D6EFFF0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B00D6EFFF009463
      6B0094636B00D6EFFF0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF0094636B00D6EFFF0094636B009463
      6B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF0094636B00D6EFFF0094636B009463
      6B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF0094636B00D6EFFF0094636B009463
      6B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF0094636B00D6EFFF0094636B009463
      6B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF009463
      6B00D6EFFF0094636B00D6EFFF0094636B0094636B00D6EFFF0094636B009463
      6B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF009463
      6B00D6EFFF0094636B00D6EFFF0094636B0094636B00D6EFFF0094636B009463
      6B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF009463
      6B00D6EFFF0094636B00D6EFFF0094636B0094636B00D6EFFF0094636B009463
      6B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF009463
      6B00D6EFFF0094636B00D6EFFF0094636B0094636B00D6EFFF0094636B009463
      6B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF009463
      6B0094636B0094636B0094636B0094636B0094636B0094636B0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF009463
      6B0094636B0094636B0094636B0094636B0094636B0094636B0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF009463
      6B0094636B0094636B0094636B0094636B0094636B0094636B0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF000039
      FF000039FF000039FF000039FF000039FF000039FF000039FF000039FF000039
      FF000039FF000039FF000039FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF0094636B0094636B0094636B00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF0094636B0094636B0094636B00D6EFFF00D6EFFF000039FF000039FF000039
      FF000039FF000039FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF000039FF000039FF000039FF00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B0094636B0094636B0094636B0094636B0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF000039FF000039FF000039
      FF000039FF000039FF000039FF000039FF000039FF000039FF000039FF000039
      FF000039FF000039FF000039FF00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B0094636B0094636B0094636B0094636B0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B0094636B0094636B0094636B0094636B0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF0094636B00D6EFFF0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF000039FF000039FF000039
      FF00D6EFFF000039FF000039FF00D6EFFF000039FF00D6EFFF000039FF000039
      FF000039FF000039FF000039FF00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF0094636B00D6EFFF0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF0094636B0094636B009463
      6B00D6EFFF0094636B0094636B00D6EFFF0094636B00D6EFFF0094636B009463
      6B0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000039FF000039FF000039
      FF000039FF000039FF000039FF000039FF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B009463
      6B0094636B0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF000039FF000039FF00D6EF
      FF000039FF000039FF000039FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B00D6EF
      FF0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B00D6EF
      FF0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF0094636B0094636B00D6EF
      FF0094636B0094636B0094636B00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00D6EF
      FF00D6EFFF00D6EFFF00D6EFFF00D6EFFF00424D3E000000000000003E000000
      28000000400000003F0000000100010000000000F80100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000}
  end
  object ThemeManager1: TThemeManager
    Left = 244
    Top = 96
  end
  object AdvToolBar: TAdvToolBarOfficeStyler
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
    Left = 320
    Top = 98
  end
end
