object Form_Designer: TForm_Designer
  Left = 212
  Top = 101
  Width = 891
  Height = 720
  HelpContext = 100
  Caption = 'Form Designer - Exchequer'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = True
  Scaled = False
  ShowHint = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object StatusBar1: TStatusBar
    Left = 0
    Top = 642
    Width = 875
    Height = 19
    Panels = <
      item
        Width = 120
      end
      item
        Width = 50
      end>
    SimplePanel = False
    SimpleText = 'dsfgds'
  end
  object Panel_Page: TPanel
    Left = 0
    Top = 59
    Width = 875
    Height = 583
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 1
    object SBSPage1: TSBSPage
      Left = 1
      Top = 1
      Width = 873
      Height = 581
      Align = alClient
      PopupMenu = Popup_Page
      TabOrder = 0
      OnClick = SBSPage1Click
      OnDblClick = Popup_Page_OrderClick
      Controller = FormController
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      OnMessage = SBSPage1Message
    end
  end
  object AdvDockPanel: TAdvDockPanel
    Left = 0
    Top = 0
    Width = 875
    Height = 59
    MinimumSize = 3
    LockHeight = False
    Persistence.Location = plRegistry
    Persistence.Enabled = False
    ToolBarStyler = AdvStyler
    UseRunTimeHeight = False
    Version = '2.9.0.0'
    object AdvToolBar: TAdvToolBar
      Left = 3
      Top = 1
      Width = 869
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
      DockableTo = [daLeft, daTop]
      FullSize = True
      TextAutoOptionMenu = 'Add or Remove Buttons'
      TextOptionMenu = 'Options'
      ToolBarStyler = AdvStyler
      ParentOptionPicture = True
      ToolBarIndex = -1
      object AdvToolBarSeparator1: TAdvToolBarSeparator
        Left = 169
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object AdvToolBarSeparator2: TAdvToolBarSeparator
        Left = 259
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object AdvToolBarSeparator3: TAdvToolBarSeparator
        Left = 309
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object AdvToolBarSeparator4: TAdvToolBarSeparator
        Left = 479
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object AdvToolBarSeparator5: TAdvToolBarSeparator
        Left = 689
        Top = 2
        Width = 10
        Height = 40
        LineColor = clBtnShadow
      end
      object Btn_Preview: TAdvGlowButton
        Left = 219
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Print Preview|Prints the active form definition to a preview win' +
          'dow'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA79300000432494441545809E5555F
          6C535518FF9DDBF6F61F5B3BC6ACC38E31448606879A8DD04532E39F890F060C
          624093451E4CF461C40717DF7CD627C53D39B366CE68647343319A4240D4E8D6
          41A20646186B60B88DB2C258DBB5EBDADEDB7B3DA74DBBB6F6DE6EAD1A139BFB
          9D7BCEF7FDBEEFFBF53BDF3917F8BFFF487601DE1F131C04923D5B576C2E18F8
          EFBA7692A56238257B0E810F2EC40620E3A012385FAFE50051C22827F17B8FEE
          268BF9F6D5AC6988D5C00A639A6A35D860E21C1217777DE8962B0BA3D4B56511
          D0D2FA39EA290973E924CA22C0FE1BDB86D64D1AD49448A26C028C8486467194
          4882BAB210E54B9AC43DB412092E7672B511B5AB0516C25DBD23E1865FCE3109
          B20C02D296A35459944520189301262A098A99FEB62D289648C95E560542B313
          084CBA119EBB06291A01D1EA60585F0BCB9647D1D9D9A9EFEEEE8E29254EEBE9
          494E4F81FC9BF0972B7731331F5901D0999623687FB80A0B239F2238F53BCCB6
          2DA8A409F98AF590E2CB08DFBC8AC0F5DF2089C2942449FBFBFBFB2F5237C547
          95C0058F1FDEBBCB39CEDB6A4DD0FDFA3162C1DBD8F4D41154D43D9463678B78
          680133DFF721EC9D5C9465F9F1BEBEBE4B4C5F4854091472F08E0C6261C20DDB
          735DF8E19A8804EDFA6CDCA13D75C9A52C2530F56D37ABC8A456ABDDD1D3D323
          240D79836A0F7CEDF6626236947179D9510DFFF88FB0EF398C939763F005A219
          5BFE84701AD43DF92A263E7F679B280A1DD4DE4BE52F8F2A81D607ABF1488335
          E54400A3EF3C16B57A04AB9AE0BBEC4DE955469DD94A1BF231043C6387296CED
          0404FAAD5D1612D4175867D020EAF7C2507D1F1AEEADC0DB2F3626F5C506B3AD
          01FE497793124EB502AC09D35BB075E33A34C7A3E0788352AC827AA2D3337D05
          1B0A892A817DBB37625F969777A4124B5E1FFC614171FFB7DB7373894B011661
          8E0D85449540F63DC0AECCA7ED8DB873F12CE45808DF8CCD43CA3B012CC1F6BC
          AD09DE485E03E798AD90B0B885F4491D4F3FF6469D064CF4F42D5AEE076BACC8
          B80BBB1AAB9218B52134730511DF7510429C4A38D50AB43C409330C9F2E61D07
          307DA6173BE8796F686B862CC959D69569D43F87E9B34E967CC8E974FEBC62C9
          9DA95620179A5A59B736C3D6F23C667FFA0C64FC4BD49AA2A8B79932228971CC
          5F3A07CFF07B10228BD3F4266CEBE8E8503C05F474A702B331FF5BC0744AE2F7
          9CC7ADD1219604C69A7A68D8E9A03D11B9FD07AD8A0839211EA3C9E3B4FC5D81
          482CB81C4FBCEE3A71FC8BFC7825136081D8BF0DD32F62F89607ACDB39DE04E3
          063B2C9B77E2AD276A92B10F1C7AE5D84D7FF828C711B9D2C41F710D0D7CC27C
          D342D213F65E4B05185E4DDEDCA5CFC46EDF7FF0142D413B47886C31E9DF700D
          1FFF28ED9B01A515FFD4FBD9175E3A4DB7E2991409DD6BAEE1C15E966BCD4DC8
          9C4A91532706DA2D467E94DE1D242A24DE4DC7F8D708B084A7BF1A6CB59AF483
          5633DFC2D6FF09F91370C793910DF2C4B10000000049454E44AE426082}
        Position = bpRight
        ShowDisabled = False
        TabOrder = 0
        OnClick = Menu_File_PreviewClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_Print: TAdvGlowButton
        Left = 179
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Print Form|Prints the active form definition'
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
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 1
        OnClick = Menu_File_PrintClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_Save: TAdvGlowButton
        Left = 129
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Save Form|Saves the active form definition'
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
        Position = bpRight
        ShowDisabled = False
        TabOrder = 2
        OnClick = Menu_File_SaveClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_Line: TAdvGlowButton
        Left = 439
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Add Line|Adds a line control to the active form definition'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000010B4944415458C3EDD73D52C3301086E177035C84830077006A187E2A
          13A0CB15E830A426409DCD1D2C971C8AA58887613C022C47EB34DECA1E69FC7C
          5A4B9E318C35D610A5E10C0D2566D21EDA75C757F539662FC004ADF780E2E7F0
          C479E505668BC6F944F818AE031A0A600EC81A974B8E0FDEDBD37C3AA0F54D04
          7F8B4D151FDC9EBBE0F90324E27903F4C00176F21CB56A0A24E37936E1AA9A62
          F2F48D9B5D75C5377F0531FCF4E835E511B24DBC7F804C78BF4DA8D52DE4C1D3
          3BB0C6CB5C785A80360ED79C1C2E363D44B24DBC5B000D77C0A307FE7F0067FC
          EF0003E0BF7F8A97610694DE78BC03CB30437868EE5CF1780784FDE6CA10BBF7
          C4E365266898A3E162FC9F186B88FA02743F8E1220E4CFB10000000049454E44
          AE426082}
        Position = bpRight
        ShowDisabled = False
        TabOrder = 3
        OnClick = Popup_Page_LineClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_Open: TAdvGlowButton
        Left = 89
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Open Form|Opens an existing form definition'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA793000001CC494441545809ED56BD
          4A034110FEE6EEB88BC108162A11F314B1B008422CC40710C146D0D622950FE0
          0BF806FED43E818D886021421A83A0A5085A582886A4887AEBCC453792DC4F48
          6EB54998D99BDD99FBE6CBCCDEB2C0E837AAC03F57807EE757FBC8C1C2360825
          5EF7587BC5C22E6DE0A2D731D88A26A0CEE0E01E970C53648D933A1496693388
          8D8BEBCB67E9A8072CB09D949C43B84A8453758445990CAB8E06F8449E4BAFA7
          094696FDE74C821F7DC90B479DC04785B6F0CCB6960E01BD64C49864D475D8DC
          66608D6D2D9D16E8258386C24A37FADF1200EF9F2E06C92D98C801D35380EB76
          BD3AD8545DE111A06358D91D9AAFBEC757C07381B9D9D4927F53CE03AA02BF51
          91793C81DC38C7E8A382ED34859604CD922152BD4CA46B7887FF2618F10432E1
          A7B1BC38B4125D0B463401E2D2CB1E902813EA23818027FF9E4998482E98B6DD
          0F018934A1EA15C59B07418E6EC1985440428C688D3BAC04399A40D0020931A1
          ED0D28C831040C7E82849A24170D27E0F009EDD8E237A32A8C808D279DCDE4F7
          0FB4D0522115280457AC6A40C2F382879141E1904A77F51F6CAE75DBA4323EF8
          525A0E2EA596B58A6673A6ED496954D480EB1CA055D8036E53021DC18C2A9042
          05BE0045FE4822CFA461170000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 4
        OnClick = Menu_File_OpenClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_NewLabel: TAdvGlowButton
        Left = 49
        Top = 2
        Width = 40
        Height = 40
        Hint = 'New Label|Creates a new label definition'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000013A4944415458C3ED96BD4A03411485BFBBAEC610A2AD55DA20D85B8A
          ADD809225898407C0C512C7C0B23769636DB8AE04B88859D8D5DFCD934D9B916
          4121666718661016DC530EF7BB1C66EE3D0CD4FAEF92DF0783EC730872082C39
          B0918AE95DEEB46E43996F25258547EE4600BA2A2A07718CD540E9D9BC4D99A9
          0B61FCC1BF54250DBCFB80AAFA16C9009096AC455F615F647E437E1AA1B9310B
          17314C7573A0977DACA5C8A6AA58D74A9364D46936EECEB66512CA589F2025B9
          07BA220ED76A7819E7E7C06928E31AC2AEE7E5AD4732750E54D7C09357A8187D
          8C64CAB76082D95AD474C3D5A8408B4EABF910C35437888EB37C0FA4AF988603
          7B359A9C0C77979F4319EB13285C81B641DCC323C518188432AE216CFB7D2E64
          2592A973C06AC0F87D2E66EA42189B01BD9ECE9553B98ADEC431B56A4DF505D0
          0698EAD67894610000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 5
        OnClick = Menu_File_NewClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_NewForm: TAdvGlowButton
        Left = 9
        Top = 2
        Width = 40
        Height = 40
        Hint = 'New Form|Creates a new form definition'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000B84944415458C3636018E980119BE084D33F5731FC670825CBC4FF0C
          1505E6EC9DC42A67A2A66F948498195898193AFA4FFE6C18100788703130D82A
          B030B0B330D413EB08266AC7A90027238335098E60A245C212E06064B021D211
          4CB44ADDFC504770107004132DB318B223269CFE91834D0D0B352DBCF9FA1FC3
          83F7FF312D616664F8F98FC18E8181610A4D1DF0F1E77F06869FFF492871681C
          0503920D471D30EA8051078C3A60D401A30E1875C0A803869C03460100C0482B
          2E9B24FC0C0000000049454E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 6
        OnClick = Menu_File_NewClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_DefFont: TAdvGlowButton
        Left = 269
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Default Font|Displays a Font Dialog to allow the forms default f' +
          'ont to be changed'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA793000002D5494441545809ED544B
          4F144110AE9A7D8044D10B9A0821A220ABF84838783151241A9F8445082A175F
          E164E2D9239EBC9B186300B97842C2EE06438831FA038C892705C5E805BD7890
          25211076A7FC76D91D7A7B7A7667B8C2A46ABABEAFBBBABFA9EE1EA2ED67AB57
          80375380D158E28E088FA9B942B4B030F7B97188866C95AF145B950698FAB1F8
          2D9DC797D4D7C74E9ED1F94A38B080E78726F762D24EB8CB58AC7E175981B02A
          F4BBBA2311AB0764186EB2BEA18E0F5E7DA6F114580009DD30CE9427A5AEF1F7
          620705780209186D4DEDC7DC67E19E665B14681B0209B0C9EEC6CA7ACE3F701B
          261C0FB20DFA641B131922266B40A3FF32C9E3524EEA1AFEA4CF9772DEC8B780
          176D538D44725A9D8A89A6C2127E0D4EE08E4194EF6DF02D20B496EDC50A5813
          EF820953E2F6B7AE05C04F70C7A0A6E769F374954394097C0BC07DD14FFFD272
          26FA3637374348AE557C4F7578E582823D435F02C6628903B87EA7B459661ECE
          5F59CD7176D64EE45AD52D9F3F255F02B292BF5A5AF9C55974F0FBF5AFE89C55
          05208E8F378CEF405BD67C09C09EEAE55FC117BE2999992959828976A56B2217
          35CE052B0A183B32D5C2C4ED5AE6FBFB73DD4B2A27F646458A3CAE6D7F31F66A
          5139AFAE757EF870F2110ED99375E4BC7FE206FC7010024BC412E24E84AAA543
          ABBBF7DDFD756E4525D538AC0263CC3460E09B58A849E5B1B80A8B716DA66AF1
          1AC004DC6896912D902F9B934799E878016EAA417ED96D282B201B96B2C93E15
          5D7DD636BED36B6CD92D60E15E2D5184B92F644B5AE31D68333D0088C38B5613
          CD442F014CC05DE62960B8357582488E69191F0767BB2735AE048EB4A4AAC812
          5500D1FA399A28195800DE5B20A2DF7D62A65421CFB35996C83B742EC11DC381
          BDFCAA79BAD62194C02840088566BEA98CCB879C71FD6CF2BCFA2AFC9E67540E
          71F56A68AD0BADCB8C024662C97694FFA0367AEEDE7CFC8BC619217E5CAE4AE1
          A35C1535266F935BAE02FF01F65FAC4F41CEDE4D0000000049454E44AE426082}
        ShowDisabled = False
        TabOrder = 7
        OnClick = spButt_DefFontClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_Box: TAdvGlowButton
        Left = 399
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Add Box|Adds a box control to the active form definition'
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
        TabOrder = 8
        OnClick = Popup_Page_BoxClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object btn_Bitmap: TAdvGlowButton
        Left = 359
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Add Image|Adds an image control to the active form definition'
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
        TabOrder = 9
        OnClick = Popup_Page_BitmapClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_Text: TAdvGlowButton
        Left = 319
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Add Text Field|Adds a text control to the active form definition'
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
        TabOrder = 10
        OnClick = Popup_Page_TextClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_Group: TAdvGlowButton
        Left = 649
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Add Group|Adds a Group control to the active form definition'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000001C649444154584763641860C038C0F6330C2E07284CFD3C818191411F
          1E2AFF190B1F64F35CA0249414A67E316060FCDF8F3093E1E2836CDE02181F25
          0414A67D3EC0C8C0600F93B4157A531022F69C2207AC79256970F89DC8049899
          FF19180E3EC8E27520CA01D972771954B8BE5212000C77BE71334C7DA48C1400
          2438E03F2383E3834CDE0394B84061FA6707C6FF0CFB890B81A95F0C6C855F3B
          E8F37CEC9FF258D991E107CF8507858C1F287240FF7F01068E2F0639B277F75F
          FCC25F78F8ADE801E47485910BD6EF3FEEC0F8FFDFFE00276BAAE6900DFB8EFE
          FFCFC8E418E8688912A24439E0ECE41B131819907207962031CAD570C4175214
          39E0DCA4EB07181819E1B9039B4546B91A78436CD401340F8173536EA024AE94
          9B012869821E0E40491A29370350D2C4A803867608A0E7FBD9EAEB0F3032E02F
          17A89A06461D30E842809CEA99A25C408E85E87A887200A8016927FCDA5E8FE7
          E384298F941D187EF25CA44A8384FD8B7E8EDCDD0397BEF0171C7A2B7A106783
          04BD514AFF26195AAB78C01BA536426F0A83C45F50D42C5FF752C2E0C83B1178
          BF007FB31CD2313140EA981450A96302EF1730FC67B880B363428DD44EAA1954
          6DF9926A3948FD803B0000FFEE9A3040F990DF0000000049454E44AE426082}
        Position = bpRight
        ShowDisabled = False
        TabOrder = 11
        OnClick = SpButt_GroupClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_Page: TAdvGlowButton
        Left = 609
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Add Page Number|Adds a page number control to the active form de' +
          'finition'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000001ED4944415458C3ED96CD6E12511480BFB98340496BA780C41008E884
          D874C9C2A451625C68A22E5CF91E3E871BEB1BB871E303E8C2851A168DB4D618
          6AFC2136C512DA323803B5C00CC28C1B638C3691A95C5CC859DDDC9C7BCE77CF
          DFBDF0BF8B72D4E64AC9DE0125754C9B8F6F9F0F5D1F55598CF33667A32A01C1
          B5BB2FEC67FF04201E8142364028A05C1A15428C3BA7DA8CC2051F1042466169
          61858B23420859D53DFF1D22FC070821B3C57E865859771E1EA51318A7C3F786
          CBB6E5FDEE445570FAEEB27480B6E381E3F93A233505538029805480B5377B3C
          2D7D02A05C3178B2BA3D5980775B9F7FACB76A2DBE0E86930568985D12B10800
          75E3906462EE58767C0D22B36DF3A8F891A1EB61F707ACBEAEF3EAED3ED681C3
          DAE62E9B15835B57170905553900C113824C729E86D921145439978DD26CF500
          583C130340158ABC08CC468214F2299EAFEFD0ED0D28E45394CABB34AD2E857C
          4A7E0ACA1583D617870F5513552814376A54AA2643D7A3B85123796A163DADC9
          2BC2BD66876ABD8D61F518BA1ED57A9B86D905A05A6F631ED87223706539CB61
          B7CFBD072FB9793947F464983BF74BDC28E8A44FCF4DA60D0DAB474015C4B519
          F6CD0E9EE7918846263709070397253D86100AB63364498FFB6ABBBFFE90E432
          0BE4320B00E869CD77D14D5FC3A9FC2ADF00F229B1D6C7DF1727000000004945
          4E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 12
        OnClick = Popup_Page_PageNoClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_Formula: TAdvGlowButton
        Left = 569
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Add Formula|Adds a formula control to the active form definition'
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
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 13
        OnClick = Popup_Page_FormulaClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object btn_DbTable: TAdvGlowButton
        Left = 529
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Add Table|Adds a table control to the active form definition'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000F14944415458C3ED96BB0DC2301086BF4348D9009AAC0065203D2300
          6B904978AC01ECC1A38415D2C006A97E8AB801E1109010027CA5EFB7EFCED677
          6708F6EF66B70BF37DA17706CC92E82A66E3D337D0ACF0E526B615FE58461FC0
          E9729FD0E9E2A71230B19DF4A291CF3FDF15236009209866BD68E5D32E76C54A
          C6F09EEFE34F1012F063283B9B71F06F555BD071871CC14E5EA5E8626ADDC3D0
          4F81A92518D4A9A24C449DFA657E431F30B17E88A1951822C601C31FC4304C43
          C831367EF82D06A5EE223798F28A4691BE360D9368FC00C3D4B5BA5996040C7F
          10C3B77CC9EA4FC332C0B0D63474897CE513040B7601595461CA5A9D25FE0000
          000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 14
        OnClick = Popup_Page_TableClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_DbField: TAdvGlowButton
        Left = 489
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'Add Database Field|Adds a database field control to the active f' +
          'orm definition'
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
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 15
        OnClick = Popup_Page_FieldClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_Close: TAdvGlowButton
        Left = 699
        Top = 2
        Width = 40
        Height = 40
        Hint = 'Exit|Closes the Form Designer'
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
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 16
        OnClick = Menu_File_ExitClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object Btn_Help: TAdvGlowButton
        Left = 739
        Top = 2
        Width = 40
        Height = 40
        Hint = 
          'What'#39's This ?|Once you have clicked this button, place the point' +
          'er over any control you require help with, and click over it.'
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
        TabOrder = 17
        OnClick = SuppQFBtnClick
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
      object AdvGlowMenuButton1: TAdvGlowMenuButton
        Left = 779
        Top = 46
        Width = 85
        Height = 40
        Caption = 'Select Style'
        FocusType = ftHot
        ShowDisabled = False
        TabOrder = 18
        Visible = False
        Appearance.BorderColor = clBtnFace
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = clBtnFace
        Appearance.ColorTo = clBtnFace
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = clOlive
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
        DropDownMenu = PopupMenu1
      end
    end
  end
  object MainMenu: TMainMenu
    AutoHotkeys = maManual
    Left = 61
    Top = 174
    object Menu_File: TMenuItem
      Caption = '&File'
      object Menu_File_New: TMenuItem
        Caption = '&New'
        object Menu_File_Form: TMenuItem
          Caption = '&Form'
          Hint = 'Creates a new form definition'
          ImageIndex = 0
          OnClick = Menu_File_NewClick
        end
        object Menu_File_Label: TMenuItem
          Caption = '&Label'
          Hint = 'Creates a new label definition'
          ImageIndex = 1
          OnClick = Menu_File_NewClick
        end
      end
      object Menu_File_Open: TMenuItem
        Caption = '&Open'
        Hint = 'Opens an existing form definition'
        ImageIndex = 2
        ShortCut = 16463
        OnClick = Menu_File_OpenClick
      end
      object Menu_File_Save: TMenuItem
        Caption = '&Save'
        Hint = 'Saves the active form definition'
        ImageIndex = 3
        ShortCut = 16467
        OnClick = Menu_File_SaveClick
      end
      object Menu_File_SaveAs: TMenuItem
        Caption = 'Save &As...'
        Hint = 'Saves the active form definition with a new name'
        OnClick = Menu_File_SaveAsClick
      end
      object Menu_File_Delete: TMenuItem
        Caption = '&Delete'
        Hint = 'Deletes the active form definition'
        OnClick = Menu_File_DeleteClick
      end
      object Menu_File_SepBar: TMenuItem
        Caption = '-'
      end
      object Menu_File_Reopen: TMenuItem
        Caption = '&Reopen'
        object N01: TMenuItem
          AutoHotkeys = maManual
          Caption = '0 '
          OnClick = ReopenClick
        end
        object N11: TMenuItem
          Caption = '1 '
          OnClick = ReopenClick
        end
        object N21: TMenuItem
          Caption = '2 '
          OnClick = ReopenClick
        end
        object N31: TMenuItem
          Caption = '3 '
          OnClick = ReopenClick
        end
        object N41: TMenuItem
          Caption = '4 '
          OnClick = ReopenClick
        end
        object N51: TMenuItem
          Caption = '5 '
          OnClick = ReopenClick
        end
        object N61: TMenuItem
          Caption = '6 '
          OnClick = ReopenClick
        end
        object N71: TMenuItem
          Caption = '7 '
          OnClick = ReopenClick
        end
        object N81: TMenuItem
          Caption = '8 '
          OnClick = ReopenClick
        end
        object N91: TMenuItem
          Caption = '9 '
          OnClick = ReopenClick
        end
      end
      object Menu_File_SepBar2: TMenuItem
        Caption = '-'
      end
      object Menu_File_Print: TMenuItem
        Caption = '&Print'
        Hint = 'Prints the active form definition'
        ImageIndex = 4
        OnClick = Menu_File_PrintClick
      end
      object Menu_File_Preview: TMenuItem
        Caption = 'Print Preview'
        Hint = 'Prints the active form definition to a preview window'
        ImageIndex = 5
        OnClick = Menu_File_PreviewClick
      end
      object Menu_File_SepBar3: TMenuItem
        Caption = '-'
      end
      object Menu_File_Exit: TMenuItem
        Caption = 'E&xit'
        Hint = 'Quits the application'
        ImageIndex = 6
        OnClick = Menu_File_ExitClick
      end
    end
    object Menu_Edit: TMenuItem
      Caption = '&Edit'
      object Menu_Edit_Cut: TMenuItem
        Caption = 'Cu&t'
        Hint = 'Cuts the selection and puts it on the clipboard'
        ImageIndex = 7
        ShortCut = 16472
        OnClick = Menu_Edit_CutClick
      end
      object Menu_Edit_Copy: TMenuItem
        Caption = '&Copy'
        Hint = 'Copies the selection and puts it on the clipboard'
        ImageIndex = 8
        ShortCut = 16451
        OnClick = Menu_Edit_CopyClick
      end
      object Menu_Edit_Paste: TMenuItem
        Caption = '&Paste'
        Hint = 'Inserts the clipboard contents'
        ImageIndex = 9
        ShortCut = 16470
        OnClick = Menu_Edit_PasteClick
      end
    end
    object Menu_Controls: TMenuItem
      Caption = '&Controls'
      object Menu_Ctrl_Text: TMenuItem
        Caption = '&Text'
        Hint = 'Adds a text control to the active form definition'
        ImageIndex = 10
        OnClick = Popup_Page_TextClick
      end
      object Menu_Ctrl_Bitmap: TMenuItem
        Caption = '&Image'
        Hint = 'Adds an image control to the active form definition'
        ImageIndex = 11
        OnClick = Popup_Page_BitmapClick
      end
      object Menu_Ctrl_Box: TMenuItem
        Caption = 'Bo&x'
        Hint = 'Adds a box control to the active form definition'
        ImageIndex = 12
        OnClick = Popup_Page_BoxClick
      end
      object Menu_Ctrl_Line: TMenuItem
        Caption = '&Line'
        Hint = 'Adds a line control to the active form definition'
        ImageIndex = 13
        OnClick = Popup_Page_LineClick
      end
      object Menu_Ctrl_Database: TMenuItem
        Caption = '&Database'
        object Menu_Ctrl_DB_Field: TMenuItem
          Caption = '&Field'
          Hint = 'Adds a database field control to the active form definition'
          ImageIndex = 14
          OnClick = Popup_Page_FieldClick
        end
        object Menu_Ctrl_DB_Table: TMenuItem
          Caption = '&Table'
          Hint = 'Adds a table control to the active form definition'
          ImageIndex = 15
          OnClick = Popup_Page_TableClick
        end
        object Menu_Ctrl_DB_Formula: TMenuItem
          Caption = 'F&ormula'
          Hint = 'Adds a formula control to the active form definition'
          ImageIndex = 16
          OnClick = Popup_Page_FormulaClick
        end
      end
      object Menu_Ctrl_PageNo: TMenuItem
        Caption = '&Page Number'
        Hint = 'Adds a page number control to the active form definition'
        ImageIndex = 17
        OnClick = Popup_Page_PageNoClick
      end
      object Menu_Ctrl_Group: TMenuItem
        Caption = '&Group'
        Hint = 'Adds a group control to the active form definition'
        ImageIndex = 18
        OnClick = SpButt_GroupClick
      end
      object Menu_Ctrl_SepBar1: TMenuItem
        Caption = '-'
      end
      object Menu_Ctrl_Order: TMenuItem
        Caption = 'O&rder'
        Hint = 'Sets the drawing order of the controls'
        OnClick = Popup_Page_OrderClick
      end
      object Menu_Ctrl_SepBar2: TMenuItem
        Caption = '-'
      end
      object Menu_Ctrl_DelCtrl: TMenuItem
        Caption = 'D&eleted Controls'
        Hint = 'Displays a list of controls which have been deleted'
        OnClick = Menu_Ctrl_DelCtrlClick
      end
    end
    object Menu_Options: TMenuItem
      Caption = '&Options'
      OnClick = Menu_OptionsClick
      object Menu_Options_Grid: TMenuItem
        Caption = '&Grid Size'
        Hint = 'Sets options for the grid'
        OnClick = Menu_Options_GridClick
      end
      object Menu_Options_PaperSizes: TMenuItem
        Caption = 'Paper &Sizes'
        Hint = 'Allows paper sizes to be added, edited, or deleted'
        OnClick = Menu_Options_PaperSizesClick
      end
      object Menu_Options_SepBar1: TMenuItem
        Caption = '-'
      end
      object Menu_Options_Page: TMenuItem
        Caption = '&Form Options'
        Hint = 'Sets options for the active form definition'
        OnClick = Popup_Page_OptionsClick
      end
      object Menu_Options_SepBar2: TMenuItem
        Caption = '-'
      end
      object Menu_Options_Signatures: TMenuItem
        Caption = 'System Setup - Email/Fax Signatures'
        OnClick = Menu_Options_SignaturesClick
      end
      object Menu_Options_FormDefs: TMenuItem
        Caption = 'System Setup - Form Definition Sets'
        Hint = 'Sets the default forms that will print'
        OnClick = Menu_Options_FormDefsClick
      end
      object Menu_Options_PrnCodes: TMenuItem
        Caption = 'System Setup - Printer Control Codes'
        Hint = 'Setup the Printer Control Codes for Text Forms'
        OnClick = Menu_Options_PrnCodesClick
      end
      object Menu_Options_PCCDefs: TMenuItem
        Caption = 'System Setup - PCC Defaults'
        Hint = 'Sets the Default Printer for Printer Control Code Forms'
        OnClick = Menu_Options_PCCDefsClick
      end
      object Menu_Options_SepBar3: TMenuItem
        Caption = '-'
      end
      object Menu_Options_Toolbar: TMenuItem
        Caption = '&Toolbar'
        Checked = True
        OnClick = Menu_Options_ToolbarClick
      end
      object Menu_Options_StatusLine: TMenuItem
        Caption = 'Status &Line'
        Checked = True
        OnClick = Menu_Options_StatusLineClick
      end
    end
    object Menu_Help: TMenuItem
      Caption = '&Help'
      object Menu_Help_Contents: TMenuItem
        Caption = '&Help Contents'
        Hint = 'Displays topics available in the help file'
        ImageIndex = 19
        OnClick = Menu_Help_ContentsClick
      end
      object Menu_Help_SepBar1: TMenuItem
        Caption = '-'
      end
      object Menu_Help_TechSuppRep: TMenuItem
        Caption = '&Print Form Report'
        OnClick = Menu_Help_TechSuppRepClick
      end
      object Menu_Help_DictRep: TMenuItem
        Caption = 'Print Dictionary Report'
        Visible = False
        OnClick = Menu_Help_DictRepClick
      end
      object Menu_Help_SepBar2: TMenuItem
        Caption = '-'
      end
      object Menu_Help_About: TMenuItem
        Caption = '&About'
        Hint = 'Displays program information, version number and copyright'
        OnClick = Menu_Help_AboutClick
      end
    end
  end
  object Popup_Page: TPopupMenu
    Left = 132
    Top = 173
    object Popup_Page_Text: TMenuItem
      Caption = '&Text'
      Hint = 'Adds a text control to the active form definition'
      OnClick = Popup_Page_TextClick
    end
    object Popup_Page_Bitmap: TMenuItem
      Caption = '&Image'
      Hint = 'Adds a image control to the active form definition'
      OnClick = Popup_Page_BitmapClick
    end
    object Popup_Page_Box: TMenuItem
      Caption = 'Bo&x'
      Hint = 'Adds a box control to the active form definition'
      OnClick = Popup_Page_BoxClick
    end
    object Popup_Page_Line: TMenuItem
      Caption = '&Line'
      Hint = 'Adds a line control to the active form definition'
      OnClick = Popup_Page_LineClick
    end
    object Popup_Page_Database: TMenuItem
      Caption = '&Database'
      object Popup_Page_Field: TMenuItem
        Caption = '&Field'
        Hint = 'Adds a database field control to the active form definition'
        OnClick = Popup_Page_FieldClick
      end
      object Popup_Page_Table: TMenuItem
        Caption = '&Table'
        Hint = 'Adds a table control to the active form definition'
        OnClick = Popup_Page_TableClick
      end
      object Popup_Page_Formula: TMenuItem
        Caption = 'F&ormula'
        Hint = 'Adds a formula control to the active form definition'
        OnClick = Popup_Page_FormulaClick
      end
    end
    object Popup_Page_PageNo: TMenuItem
      Caption = '&Page Number'
      Hint = 'Adds a page number control to the active form definition'
      OnClick = Popup_Page_PageNoClick
    end
    object Popup_Page_Group: TMenuItem
      Caption = '&Group'
      Hint = 'Adds a group control to the active form definition'
      OnClick = SpButt_GroupClick
    end
    object Popup_Page_SepBar2: TMenuItem
      Caption = '-'
    end
    object Popup_Page_Order: TMenuItem
      Caption = 'O&rder'
      Hint = 'Sets the drawing order of the controls'
      OnClick = Popup_Page_OrderClick
    end
    object Popup_Page_SepBar: TMenuItem
      Caption = '-'
    end
    object Popup_Page_Options: TMenuItem
      Caption = '&Options...'
      Hint = 'Sets options for the active form definition'
      OnClick = Popup_Page_OptionsClick
    end
  end
  object Popup_Text: TPopupMenu
    Left = 204
    Top = 161
    object Popup_Text_Align: TMenuItem
      Caption = 'Align to &Grid'
      Hint = 'Aligns the control to the grid'
      OnClick = Popup_Box_
    end
    object Popup_Text_Front: TMenuItem
      Caption = 'Bring To &Front'
      Hint = 'Brings the control to the front of the drawing order'
      OnClick = Popup_Text_FrontClick
    end
    object Popup_Text_Back: TMenuItem
      Caption = 'Send To &Back'
      Hint = 'Sends the control to the back of the drawing order'
      OnClick = Popup_Text_BackClick
    end
    object Popup_Text_SepBar2: TMenuItem
      Caption = '-'
    end
    object Popup_Text_Options: TMenuItem
      Caption = '&Options'
      Hint = 'Displays the options for the control'
      OnClick = Popup_Text_OptionsClick
    end
    object Popup_Text_Font: TMenuItem
      Caption = '&Font'
      OnClick = Popup_Text_FontClick
    end
    object Popup_Text_If: TMenuItem
      Caption = 'I&f'
      OnClick = Popup_Bitmap_IfClick
    end
  end
  object Popup_Bitmap: TPopupMenu
    Left = 253
    Top = 191
    object Popup_Bitmap_Align: TMenuItem
      Caption = 'Align to &Grid'
      Hint = 'Aligns the control to the grid'
      OnClick = Popup_Box_
    end
    object Popup_Bitmap_Front: TMenuItem
      Caption = 'Bring To &Front'
      Hint = 'Brings the control to the front of the drawing order'
      OnClick = Popup_Text_FrontClick
    end
    object Popup_Bitmap_Back: TMenuItem
      Caption = 'Send To &Back'
      Hint = 'Sends the control to the back of the drawing order'
      OnClick = Popup_Text_BackClick
    end
    object Popup_Bitmap_SepBar2: TMenuItem
      Caption = '-'
    end
    object Popup_Bitmap_Edit: TMenuItem
      Caption = '&Edit'
      Hint = 'Runs a bitmap editor'
      OnClick = Popup_Bitmap_EditClick
    end
    object Popup_Bitmap_SepBar1: TMenuItem
      Caption = '-'
    end
    object Popup_Bitmap_Options: TMenuItem
      Caption = '&Change Image'
      Hint = 'Allows a different image to be selected'
      OnClick = Popup_Text_OptionsClick
    end
    object Popup_Bitmap_SepBar3: TMenuItem
      Caption = '-'
    end
    object Popup_Bitmap_If: TMenuItem
      Caption = '&If'
      OnClick = Popup_Bitmap_IfClick
    end
  end
  object FormController: TSBSController
    Paper.psBorderWidth = 16
    Paper.psPageHeight = 420
    Paper.psPageWidth = 420
    Paper.psScaling = 3
    Paper.psDeskColour = clBtnShadow
    Grid.grDisplayGrid = True
    Grid.grSnapToGrid = False
    Grid.grXSpacing = 4
    Grid.grYSpacing = 4
    Page = SBSPage1
    FormDetails.ftFormType = ftForm
    FormDetails.ftPaperWidth = 210
    FormDetails.ftPaperHeight = 297
    FormDetails.ftTopMargin = 20
    FormDetails.ftLeftMargin = 10
    FormDetails.ftRightMargin = 10
    FormDetails.ftBottomMargin = 20
    FormDetails.ftSections = [stPageHead, stBodyHead, stBody, stBodyFoot, stPageFoot]
    FormDetails.ftOrientation = fdoPortrait
    FormDetails.ftCopies = 0
    FormDetails.ftDefaultFont.Charset = DEFAULT_CHARSET
    FormDetails.ftDefaultFont.Color = clBlack
    FormDetails.ftDefaultFont.Height = -12
    FormDetails.ftDefaultFont.Name = 'Arial'
    FormDetails.ftDefaultFont.Style = []
    FormDetails.ftHeaderSep = 90
    FormDetails.ftBodyHeadSep = 180
    FormDetails.ftBodySep = 700
    FormDetails.ftBodyFootSep = 800
    FormDetails.ftBinId = 0
    FormDetails.ftPaperId = 0
    FormDetails.ftLbTop = 0
    FormDetails.ftLbLeft = 0
    FormDetails.ftLbWidth = 0
    FormDetails.ftLbHeight = 0
    FormDetails.ftLbCols = 0
    FormDetails.ftLbRows = 0
    FormDetails.ftLbColGap = 0
    FormDetails.ftLbRowGap = 0
    FormDetails.ftPurpose = 0
    Popup_Text = Popup_Text
    Popup_Bitmap = Popup_Bitmap
    Popup_Box = Popup_Box
    Popup_Line = Popup_Box
    Popup_DbField = Popup_Text
    Popup_DbTable = Popup_Box
    Popup_DbFormula = Popup_Text
    Popup_Pageno = Popup_Text
    Popup_Group = Popup_Group
    OnTextOptions = FormControllerTextOptions
    OnBitmapOptions = FormControllerBitmapOptions
    OnBoxOptions = FormControllerBoxOptions
    OnLineOptions = FormControllerLineOptions
    OnFieldOptions = FormControllerFieldOptions
    OnTableOptions = FormControllerTableOptions
    OnFormulaOptions = FormControllerFormulaOptions
    OnPageNoOptions = FormControllerPageNoOptions
    OnGroupOptions = FormControllerGroupOptions
    OnIf = FormControllerIf
    OnZOrder = FormControllerZOrder
    Help_Text = 200
    Help_Bitmap = 300
    Help_Box = 400
    Help_Line = 500
    Help_Field = 600
    Help_Table = 700
    Help_Formula = 800
    Help_PageNo = 900
    Help_Group = 1000
    Left = 62
    Top = 90
  end
  object OpenDialog: TOpenDialog
    HelpContext = 20000
    Filter = 'Form Designer Forms (*.EFX)|*.EFX|All files|*.*'
    Options = [ofHideReadOnly, ofShowHelp, ofPathMustExist, ofFileMustExist, ofShareAware]
    Left = 143
    Top = 291
  end
  object SaveDialog: TSaveDialog
    HelpContext = 20100
    Filter = 'Form Designer Forms (*.EFX)|*.EFX'
    Options = [ofHideReadOnly, ofShowHelp, ofPathMustExist, ofShareAware]
    Left = 220
    Top = 294
  end
  object Popup_Group: TPopupMenu
    Left = 451
    Top = 160
    object Popup_Group_Align: TMenuItem
      Caption = 'Align to &Grid'
      Hint = 'Aligns the control to the grid'
      OnClick = Popup_Box_
    end
    object Popup_Group_Front: TMenuItem
      Caption = 'Bring To &Front'
      Hint = 'Brings the control to the front of the drawing order'
      OnClick = Popup_Text_FrontClick
    end
    object Popup_Group_Back: TMenuItem
      Caption = 'Send To &Back'
      Hint = 'Sends the control to the back of the drawing order'
      OnClick = Popup_Text_BackClick
    end
    object Popup_Group_SepBar1: TMenuItem
      Caption = '-'
    end
    object Popup_Group_NewRow: TMenuItem
      Caption = '&Add Row'
      Hint = 'Add a new row at the position the mouse was clicked'
      OnClick = Popup_Group_NewRowClick
    end
    object Popup_Group_DeleteRow: TMenuItem
      Caption = '&Delete Row'
      OnClick = Popup_Group_DeleteRowClick
    end
    object Popup_Group_SepBar2: TMenuItem
      Caption = '-'
    end
    object Popup_Group_If: TMenuItem
      Caption = '&If'
      Hint = 'Displays the options for the control'
      OnClick = Popup_Bitmap_IfClick
    end
  end
  object Popup_Box: TPopupMenu
    Left = 363
    Top = 172
    object MenuItem1: TMenuItem
      Caption = 'Align to &Grid'
      Hint = 'Aligns the control to the grid'
      OnClick = Popup_Box_
    end
    object MenuItem2: TMenuItem
      Caption = 'Bring To &Front'
      Hint = 'Brings the control to the front of the drawing order'
      OnClick = Popup_Text_FrontClick
    end
    object MenuItem3: TMenuItem
      Caption = 'Send To &Back'
      Hint = 'Sends the control to the back of the drawing order'
      OnClick = Popup_Text_BackClick
    end
    object MenuItem4: TMenuItem
      Caption = '-'
    end
    object MenuItem5: TMenuItem
      Caption = '&Options'
      Hint = 'Displays the options for the control'
      OnClick = Popup_Text_OptionsClick
    end
    object Popup_Box_If: TMenuItem
      Caption = 'I&f'
      OnClick = Popup_Bitmap_IfClick
    end
  end
  object AdvStyler: TAdvToolBarOfficeStyler
    Style = bsCustom
    BorderColor = clBtnFace
    BorderColorHot = clHighlight
    ButtonAppearance.Color = clBtnFace
    ButtonAppearance.ColorTo = clBtnFace
    ButtonAppearance.ColorChecked = clBtnFace
    ButtonAppearance.ColorCheckedTo = 5812223
    ButtonAppearance.ColorDown = 11899524
    ButtonAppearance.ColorDownTo = 9556991
    ButtonAppearance.ColorHot = 15717318
    ButtonAppearance.ColorHotTo = 9556223
    ButtonAppearance.BorderDownColor = 7293771
    ButtonAppearance.BorderHotColor = 12937777
    ButtonAppearance.BorderCheckedColor = 7293771
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
    CompactGlowButtonAppearance.ColorDisabledTo = clOlive
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
    DragGripStyle = dsSingleLine
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
    GlowButtonAppearance.ColorDisabledTo = clOlive
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
    TabAppearance.BackGround.Direction = gdVertical
    Left = 598
    Top = 154
  end
  object PopupMenu1: TPopupMenu
    Left = 802
    Top = 132
    object bsOffice2003Blue1: TMenuItem
      Caption = 'bsOffice2003Blue'
      OnClick = bsOffice2003Blue1Click
    end
    object bsOffice2003Classic1: TMenuItem
      Tag = 3
      Caption = 'bsOffice2003Classic'
      OnClick = bsOffice2003Blue1Click
    end
    object bsOffice2003Olive1: TMenuItem
      Tag = 2
      Caption = 'bsOffice2003Olive'
      OnClick = bsOffice2003Blue1Click
    end
    object bsOffice2003Silver1: TMenuItem
      Tag = 1
      Caption = 'bsOffice2003Silver'
      OnClick = bsOffice2003Blue1Click
    end
    object bsOffice2007Luna1: TMenuItem
      Tag = 4
      Caption = 'bsOffice2007Luna'
      OnClick = bsOffice2003Blue1Click
    end
    object bsOffice2007Obsidian1: TMenuItem
      Tag = 5
      Caption = 'bsOffice2007Obsidian'
      OnClick = bsOffice2003Blue1Click
    end
    object bsOffice2007Silver1: TMenuItem
      Tag = 9
      Caption = 'bsOffice2007Silver'
      OnClick = bsOffice2003Blue1Click
    end
    object bsOfficeXP1: TMenuItem
      Tag = 10
      Caption = 'bsOfficeXP'
      OnClick = bsOffice2003Blue1Click
    end
    object bsWhidbeyStyle1: TMenuItem
      Tag = 7
      Caption = 'bsWhidbeyStyle'
      OnClick = bsOffice2003Blue1Click
    end
    object bsWindowsXP1: TMenuItem
      Tag = 6
      Caption = 'bsWindowsXP'
      OnClick = bsOffice2003Blue1Click
    end
  end
end
