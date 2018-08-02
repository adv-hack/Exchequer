object Form1: TForm1
  Left = 171
  Top = 192
  Width = 597
  Height = 429
  HelpContext = 666
  Caption = 'Exchequer EDF/EDZ Reader'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object Notebook1: TNotebook
    Left = 0
    Top = 56
    Width = 581
    Height = 314
    Align = alClient
    TabOrder = 0
    object TPage
      Left = 0
      Top = 0
      Caption = 'Preview'
      object Panel_ScrollBox: TSBSPanel
        Left = 0
        Top = 0
        Width = 558
        Height = 290
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvNone
        Ctl3D = True
        ParentCtl3D = False
        PopupMenu = Popup_Preview
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object ScrollBox_Preview: TScrollBox
          Left = 1
          Top = 1
          Width = 556
          Height = 288
          Align = alClient
          BorderStyle = bsNone
          Ctl3D = False
          ParentCtl3D = False
          PopupMenu = Popup_Preview
          TabOrder = 0
        end
      end
      object Panel_ScrollBar: TSBSPanel
        Left = 558
        Top = 0
        Width = 23
        Height = 290
        Align = alRight
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 1
        Visible = False
        OnResize = Panel_ScrollBarResize
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object ScrollBar_Pages: TScrollBar
          Left = 5
          Top = 1
          Width = 16
          Height = 263
          Hint = 'Scroll to change the page number'
          Enabled = False
          Kind = sbVertical
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBar_PagesChange
          OnScroll = ScrollBar_PagesScroll
        end
      end
      object StatusBar1: TStatusBar
        Left = 0
        Top = 290
        Width = 581
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Panels = <
          item
            Alignment = taCenter
            Width = 150
          end
          item
            Width = 50
          end>
        SimplePanel = False
        UseSystemFont = False
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Print'
      object SBSBackGroup1: TSBSBackGroup
        Left = 5
        Top = 1
        Width = 338
        Height = 61
        TextId = 0
      end
      object lblPrintFile: Label8
        Left = 17
        Top = 17
        Width = 311
        Height = 14
        AutoSize = False
        Caption = 'Printing File '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblPrinter: Label8
        Left = 17
        Top = 37
        Width = 316
        Height = 14
        AutoSize = False
        Caption = 'To Printer '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
    end
  end
  object AdvDockPanel: TAdvDockPanel
    Left = 0
    Top = 0
    Width = 581
    Height = 56
    MinimumSize = 3
    LockHeight = False
    Persistence.Location = plRegistry
    Persistence.Enabled = False
    ToolBarStyler = AdvToolBarStyler
    UseRunTimeHeight = True
    Version = '2.9.0.0'
    object AdvToolBar: TAdvToolBar
      Left = 3
      Top = 1
      Width = 575
      Height = 54
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
      ToolBarStyler = AdvToolBarStyler
      ParentOptionPicture = True
      ToolBarIndex = -1
      object AdvToolBarSeparator1: TAdvToolBarSeparator
        Left = 233
        Top = 2
        Width = 10
        Height = 50
        LineColor = clBtnShadow
      end
      object AdvToolBarSeparator2: TAdvToolBarSeparator
        Left = 397
        Top = 2
        Width = 10
        Height = 50
        LineColor = clBtnShadow
      end
      object AdvToolBarSeparator3: TAdvToolBarSeparator
        Left = 484
        Top = 2
        Width = 10
        Height = 50
        LineColor = clBtnShadow
      end
      object btnZoomOut: TAdvGlowButton
        Left = 79
        Top = 2
        Width = 77
        Height = 50
        Hint = 'Reduces the document image to show a larger area of the page'
        Caption = 'Zoom Out'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA79300000453494441545809E5565D
          4C1C55143E7766597617BA5D6A6A43241653FB6397EEC28A91FE506D1F5A1353
          538DD4C418FE4230D640E2833EF8D0D0B7FA62624C7D4049783036ED3615535B
          433431DA076DFC611B5C0A154CA1AC5D9186D0D5C27677E6FA9D81D9B203BBCB
          D6D298383967CEEF3DF79B7BCFDC19A2FFFB25F25800D1D2D252AE695AA910C2
          A5EBFAA4DD6E1FEFECEC9CCCA3C6A2D49C00EAEBEB37298AF206263D80D10F81
          179284F11362A76C36DB7180B9053B2FCA08A0ADADAD30168B1D43F1D751B100
          4CA2E80122A787482920999821FA6B82882507892252CAF6EEEEEE3373E6F2EE
          4B02C052AFC352F7A0440D0985C47A88479F22E129836B01E94992D101D22F7F
          413435C6016090EF00C4DB30787520B2936A0DB7B6B6BA92C9E4D7F05793AB84
          94DDEDA46CA825E170C3652106B76A1D298FEC246177929C181278A25D959595
          32140A7D63C95ED254AC5E4C7E0CBE4AE15A43EADE3749943C0C3307615AB171
          2F294F3611B12EC491C6C6C6DA1CA38C701A808686062FD6F030E1C9941DAF12
          39561B49CBBD89B20089CDFB385D41EFBCDFD1D191569F03564E4B40B7B72341
          15E5DB89ACFB8DC07248D9B21FC0DD9CEA1F1D1D7D9A725C29007575752A720F
          8249D9B887C5DDB1AD90047A820763355F60998D53009C4EE706243E48D87B72
          9742BD7B524ABDC6606CC30E43C972B3993155558D774C14AF355D86F4AE55E8
          C52DC63160D8996E472FC4EF848A52358C9A77028BB5D40A006DB11156ED86F8
          57376CC3FCF855F332A348AD000044B16744F1585AF2F42CD1C0A49EE6CB65C8
          D99B664AD45432C914009C7C630021652C2A08271C2973A1F1984EC1CBF901A0
          E98839DF55CA71A5B600C76714007EA6041E796228C7B0EC6119099909E74C25
          934C01984F38CD520B7F4E2425AB79B39CBE4E72EC071EA7E15CE961251BA701
          C0D7EF3D245FE30F8B1CF9166A9EA46B244327015E077EF9615757D770AE0ACA
          C28460303883467C8B7DFAA5D324C7FB585D1E6372FDC78F49FEF92B3E07620A
          838E8273926ACDC057EC97AAAA2A171E63A78CF491901A8935E5F807986B4A5A
          EA8AFD41DAF71F115DEFE72877AC13CA386A5D84CC4A8B007036067E150804B0
          99F2193939ACCAABDF91E01F0F9B830498540CC3ABC64F2BF12FA0F79D24BA75
          83979D1BB908351434F4FE4D5B7D8970FFA50BB03392C81841A0B9B97917B6E4
          5DA84F80B3918660174ED323789D6BA17F323D132F884CFD4D6E87FDEC979F05
          9F836F49CA0A607E84686A6ADA039D8BEC865C0FF6807F075F01F7A2DBCF2C6C
          B8BA975F79EDDA8DD8071241268FAB30D8FBE9A943AC5B59581DF7CADE77F0D0
          F19B33F1C326884C2BA1DEAB09AD754606C3E7BDDBFC9ED9A456C3B17852DBBC
          B5C2F7F86F430327D83679C500F00400D1BBCDE75F3D9BD0B6B3CD20BC3E9F7F
          6470005DCB1EA21505C0530C0F867B2B7CFEB278420BB07D3BA13D56555D7DFE
          4AB89F7B68E501F0A45889B37872F7EDA45E5352EC683F173CD1C3FEFBCECF3E
          FF52C57D9FF43F3FE13F7D7468FA11D97EE90000000049454E44AE426082}
        Position = bpMiddle
        ShowDisabled = False
        TabOrder = 0
        OnClick = Menu_View_ZoomOutClick
        Appearance.BorderColor = 12179676
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.ColorTo = 12179676
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 11899524
        Appearance.ColorDownTo = 11899524
        Appearance.ColorHot = 15717318
        Appearance.ColorHotTo = 15717318
        Appearance.ColorMirror = 12179676
        Appearance.ColorMirrorTo = 12179676
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
        Layout = blGlyphTop
      end
      object btnFullPage: TAdvGlowButton
        Left = 156
        Top = 2
        Width = 77
        Height = 50
        Hint = 'Adjusts the Zoom to show the entire page at once'
        Caption = 'Full Page'
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000006624B474400FF00FF00FFA0BDA79300000396494441545809E5955D
          4C145714C7FF33CCB01FE3B2ACBB2E4BAD816834E247C40743498AA64985B4A6
          2944978428910763A22FFAD02626364D4C1FFADA186378019E6C05428C54FA91
          A6A19A96024D9F10B5A51551564410965D7676676767C67BA77EACECECEEEC50
          5FDAC9BDF7CC9C73EEFFFEE6DEDD33C0FFFD629E6FC0172352100C7A9E3F9BB1
          1AB4EB299BEDC0C7BB9898997CA31CD6C869C6E71758781CEC3E5E4AFE707E58
          2B3133C728C73200CF0175951C3C4EA6566593DF5985B00C40DF8623B3DFAE58
          1D0491A052D6FB6A21560D40D15703414E924A14DE45594368497D656265298B
          6842A94D69C90612E8253D6FB30CB0286A181595BC0BE44BF8578E20DF22B9E2
          9677808AC6E7A6107D701B89C547F411764F006B3654C1E9ABD09FCD0C962A21
          5D70FAFA25C466266073FBC1BBD6EA6BC9D105484B8FC10BA5E32971E9606767
          E71F7A20C7503080383B89C9810B282EF1E1CDBD2D70F82B917EC51FDFC3E4B7
          ED21590C3B58967DAFA3A363343DBEF2BEA0DF802C4688F84538031BB1A9E9A3
          8CC5A93805AA3AF2999F73BAFF5655F56A6B6BAB9FFAB3F58200667F1F00CBF1
          A8D87F0C6C119F4D134C11CF57B59CDBC6B0ACCA71DCD9AC8924601A40535208
          FF398A75D5F560791B999ABBB1C576C1B7E39DBF48D6D16030584CAC61330D20
          CEDF87928CA3A462A7A19091D3BBBD8EFE1DDC8220EC328A539F690025BE4CF3
          C13BDDBA3533F02E6FD9B3BCC0339B614C03902DD527AB7242B766065512756A
          866122D9F24D03D83DE5601816B14777B36965F823536313C449EBF52D620D9B
          6900CEE182B07E0BE6C7060D858C9C3323FD364DD37EECEAEA9A338A539F6900
          9A1CD8F301A2A13B98BFF913F25D0F7FE9BD918A47AAC9F67F9A2BB7A06F8110
          D884F29A463CFCB91B4A6219EB763764D403559111BAF1D5F8C29DA13AB2F838
          29466A2E80824B31159B23C730F36B1F38BB00CFE61AD8BDEBA91BF127D3084F
          8C2225466555557A08C0614D4378212E1DEFEFFEB2574F5A315802A01A49F2E1
          79428E223A7D1B527896BA602B2D836BC336B8DED87AE29343D5ED6D6D6D67A6
          17639FC72459F30AF693D7FA2EB7EB8969836580348DCC5B0DCDA76B6CFA1B37
          34355F0B8BD2019661E011ECA7BEE9BB7C3E7DC24B80E1E532AD88335FE6D255
          56DC334A6AECF45B6BFED91612AB6F6C1E588A4BEF1308ADC4517CF2FB2B3D2F
          76E20500C97BADEDDD0F0F0D4513722D85F0B9859AAFBB2FFDF65A173412DFDF
          181C2420E60B8991C87FCEF714B9663A00B01A95490000000049454E44AE4260
          82}
        Position = bpRight
        ShowDisabled = False
        TabOrder = 1
        OnClick = Menu_View_ZoomPageClick
        Appearance.BorderColor = 12179676
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.ColorTo = 12179676
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 11899524
        Appearance.ColorDownTo = 11899524
        Appearance.ColorHot = 15717318
        Appearance.ColorHotTo = 15717318
        Appearance.ColorMirror = 12179676
        Appearance.ColorMirrorTo = 12179676
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
        Layout = blGlyphTop
      end
      object btnZoomIn: TAdvGlowButton
        Left = 2
        Top = 2
        Width = 77
        Height = 50
        Hint = 'Enlarges the document image to show more detail'
        Caption = 'Zoom In'
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000034D494441545847CD964D48545114C7FF671C15C768CC0AC20C2D984D
          0B75512092344681B828A38208C4FB286AD122835AB40895162D0AB26550BC6B
          4504194A900405A3141515642EDC18E4909550F851CDD8A43337CED337CEF77B
          A3A8DDD57D8F7BEEF99DCF7B08ABBC6895F5232B0021441511B94D68A5945F4A
          39B214232C018410E5005A01788988F7714B2935004002E894524E660B931140
          08D1414467A216BB8AE1285C1FD511991C05CD4C1BDF4A2956AE49297BB28148
          0920842802E023A22AE3B2B26A383C5E50D196A4BB235F3E400DFB801FC32648
          9B94B2DD2E444A004DD3D8AD95CA558C9C9A932915272A888CBC827A77D78438
          2BA5ECB003910460BADD50BEF70228CF65E71EE34C02449D94B2CF4A380E8013
          8E883EB1908395179526C997BB1D5000426185B1DFBC8B5F91A1C75043BD9C13
          7D52CABAAC00344DE36C6EE698E7EC6C4A29DB5A9B6FFCF74F4520076792CEA8
          BF41849F5D0605C719C2D20B711ED0348D6BBA2C9DF5ACCD0AC008C54017D447
          1F035C9752B664F2421460BEC9BCE7D83B1B2EA595B103A0BE0F23D26FE460BF
          AEEB5EBB00DC687CD8E0418E77019A63DE5C916B154AB43F0FC59D09779D36BE
          755DCFD86B623DF07F026C5A43A8DFE68C5A57E67618FBD0ACC25860A10A6213
          5205C711E9BD68E4AAAEEB49ED3BD655B11E304A50E516C079E0EAD272E0EB20
          222F6F6497037CDAEC808E9A53A0928A4595210B85DFDE01FCAFB90A2C3B6262
          236A21A26B8989184B62550531EE6780AD56CF7522401111712F70D38E2638CA
          AB2DB33FF140B8AFC37C983A755D175617A47A0B1A89A89B05B38588717D0040
          A99DF920DD73DC46443C8480B637C0E1D903E416A435C670FB9BDB86E54A29EE
          CFDC387836E0D69E71A56D124288B97CE061830791924AD0E64AD0468F71212B
          C5E428781EE08433FE29C5961712CD5DFB6B3A74BEEBFEBDF425C50666C21342
          70736A03B0DBCA121EC99452DC423984FA44E00FBE4D05B136DF79EBE9A38727
          D2C95BCE842C2884689C9F0979423261FC004694523C82F5C466FBE1A3C7CE7D
          9E085C31956682B00560C3FAA423FBF61FBAF933347BDC0A62D90058B11D8865
          05B003B1EC00A920D6B9F26A9F743F786194F962E2BB1819331C8909B962000C
          5D7FF0C82ED372D388150548E5B95507F80794E3903003A5DCA4000000004945
          4E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 2
        OnClick = Menu_View_ZoomInClick
        Appearance.BorderColor = 12179676
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.ColorTo = 12179676
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 11899524
        Appearance.ColorDownTo = 11899524
        Appearance.ColorHot = 15717318
        Appearance.ColorHotTo = 15717318
        Appearance.ColorMirror = 12179676
        Appearance.ColorMirrorTo = 12179676
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
        Layout = blGlyphTop
      end
      object btnPrevPage: TAdvGlowButton
        Left = 243
        Top = 2
        Width = 77
        Height = 50
        Hint = 'Displays the previous page in the document'
        Caption = 'Previous Page'
        DisabledPicture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000020C4944415458C3ED964D6B134118809F99CCEEE6D3DA18AC5FD883E2
          416CB5D0B307C1163CE4A6BFA2E0B5373D5A104F82FF416F010F15C183202815
          D15E7A1024A02989B5B5A926D96577C7434D13D8351B65371E9AF7343B333BF3
          BC9FF3C26117316871BDE13D066EFED3C99AE599A9D44AD436998456054B2024
          F73ED4BDBBFF0520ADE0645E9092DC89829049F9D654821385680899648099A9
          68089974944741C851A45A3FC47AC35DEA5F53495CB8DBD1ECD93A686E01BE16
          5781874301D86D27E7393E00465A6158C3F13ADEF0B0A1275656ABD780FBB58D
          C65CFFBC9535993C3D41266FC5662D1972F96DE0393017B048CBA1FE718BE6D7
          1FC9005456ABD78107834AB4D69AED2FBBB4F73A895860A57F4E083836990E85
          D8A9356301388881CAB3EA3974CFEC4A49AE5C2AA2357CDB096A6BB71C5CDB45
          592A1E003417BAC37CCE60FE728942DEA0D57699BD58ECA558D3A1FA793F069C
          580104F03B754D436218FB9E5029492EDBDBD6B1BD586B463FFE4677B0FDDDE6
          E5EB3AF3B325DAB6CBDBF75BE1152EADE20BC2F2C2F427E0CD81A61D97576B75
          6A9BADD01FAD9C893255DC59209601BFFBE5FB9ACD4610400841F1D444FC6958
          5E3CFB025802FEE8682104C5334749C7540D0395B0BC38FD085800DE05CC9E35
          993A5FE24829379AA674ADDA7EEA39FE8DBF7D8C22E4C9CCF1D4ADA15E432B63
          FE24936CAF309286640C300618CB20F905405FA1430F357FED0000000049454E
          44AE426082}
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000023B4944415458C3ED96CF4B146118C73FEFEC94BBB33BEDBA1A59A2D8
          0FA4488CDD0E1DAC8D8A0AF464D0A17F203A184960ECA9164F09521E826E1D3B
          0451907BCA5A4C8436C3A084529284408CCD555BDA7690663AE8AE2B3BEE6E35
          6387F63DCDBCEFFBCCFB799EF93ECFFBC0FF3E44B1C58131ED0106E7FFE8CB06
          E1EE23557DA5B6497678B5C7EF407670F3765C8BFC13805A058E35C954C9DC28
          0521D9F56F7D2E415B1910929D02F33905474B404876ABDCBB0AE1DC0042DA8C
          54CB871818CB74E5AFC9761C3899D09959300AE6658740D3090177CA02589C4B
          B933290D00B546C15DAD9405B0A419A01965551E5380E39DD193407FEC5E3CB0
          4E54752A2DA79AD9DE586D59B42493C3AF004340C024228CDE1F67FAF5677B00
          429DD1D3C0AD6225DA300CDE0D4D9198495A0F20A02F7F4E08683DE037859888
          7DB40420A781D0B9C1BD186B61575C32E1CBADE83ABC7D9F3411E837D28B3F50
          7C2E6B0084219AB3CF8DF56E7AAF1DA6A9C1C3EC9734572FB5E40CA6A697187C
          BAA28154326D1D000258CD9C6D9EADA89E2D2B9170CA34EC74E7B6CD27354B6B
          463EC0872CC0C4E402177B46E9ED099298CF10E91F3735566B14EB4438FCB0E3
          13F06ACDD30CDDD75FF26C64D6D4D0BFCB8BE275599B058621C2809E7D5F5ED6
          1989CF151633213878629FF569F8E2717B0CE8027E6ED8C349824367F7536B51
          352CA884C38F3AEE0267803705F77B9D4ADB8520BB03F53688703DC473201879
          F2359A4969EDBF7B19FD35409EC7DFD9A1DADA2B6C4A435201A8005446B1F10B
          1015A6C0E4B769070000000049454E44AE426082}
        Position = bpLeft
        ShowDisabled = False
        TabOrder = 3
        OnClick = Menu_View_PrevPageClick
        Appearance.BorderColor = 12179676
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.ColorTo = 12179676
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 11899524
        Appearance.ColorDownTo = 11899524
        Appearance.ColorHot = 15717318
        Appearance.ColorHotTo = 15717318
        Appearance.ColorMirror = 12179676
        Appearance.ColorMirrorTo = 12179676
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
        Layout = blGlyphTop
      end
      object btnNextPage: TAdvGlowButton
        Left = 320
        Top = 2
        Width = 77
        Height = 50
        Hint = 'Displays the next page in the document'
        Caption = 'Next Page'
        DisabledPicture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000001F04944415458C3ED964D6BD45014869F9B64928C9D69ED176DA134A8
          8BAEA45085EEBA294C17C2ECFC158A2B17DDE9D2AEDCB8F037B8AC200C08E24E
          102AB52E5C886D282D5ADB199AB4369964266E649ADE19C5C84D8BD8B3CAE57E
          9CE79EBCE79C0BFFBB89F4607DB7F50CB8FD5727252C5D1FD397B36ED354DCA2
          6C0984C6A3F75F5B0FCF05C03660A224D0351E6485D054FD4BD3108C97B34368
          2A0565EAD92134D5AACE0AA1E5915A6988F5DDF8EEEFD61A2A1C1E04097E9874
          DF4E403B11F3C0935C019AADD3E3288C89821800DDD4FACEA61001C77E4063C7
          23FCDE94A75611DCAF569C57B969C0FB76C8974F7BBD9C03CC92F072A5E6DECB
          05E0D80FA86F1FFC89E01FAFD4DC05E5008D1D8F24E916E1E8B08D1042F6B7AC
          14200AE35F859DA9C91273B3A3140AA7DCDC785E73AF28CB82288C3BDF579D7E
          062F9B9DF1D080856DEBCCCF8DF3766D0FCF6FFE6C9C4C031BB91522D9DA8994
          6E2AEB80699F1CF1D9F5C04DC57A6604DD17BCFBB04F14B5D3DB3E2A03304C03
          ABCF243CEAD6C1E6D621F546280BF44D75D1D9549A05831303B2DA01D8AF07B2
          F336B0A43C0D8B658BA1C9DE10298B11E24E75D1799D4B25EC1F2931766D18EB
          92D96B7A1541A55A997A9A4B333A89844D71DA969BD18B9B4EF156AEDD50B682
          6550B03A471F9DF983E45C1EA51700FF2CC085FD0020F4A037BCEADFC0000000
          0049454E44AE426082}
        FocusType = ftHot
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000021B4944415458C3636018E980119933E1F4CF550CFF1942C932E93F43
          4581397B27A9DA98A8E10B252166061666868EFE933F1B06C401225C0C0CB60A
          2C0CEC2C0CF5A43A82895A7129C0C9C8604D862398A899A0043818196C487404
          13B553353FD4111C443A828916590BD911134EFFC8C1A796851A16DE7CFD8FE1
          C1FBFF9886333332FCFCC760C7C0C03085A60EF8F8F33F03C34F8403BEBEFFCE
          F0F9ED5706060606060E5E766E9A87000CBC7EF88EE1CADEDB0C1F5E7E4616F6
          B20FDC7AF63F2343C9A175DEFB699606EE9E79CC7064D93974CB61C088F13FC3
          1EFBC0AD793471C0ABFBEF182EEFB9454C82EFB70FDCEA4C75075CDD7F9BE1FF
          7FCC4468AC27C2C0C4C4886E5F27551DF0F5C3775CC1CEE0EB26C7D05963CAC0
          CBC38AE22E87C02D8A544B845FDE7E83B3437D1519B4D505E17C6D7501065161
          0E86995DD60C359D6719EE3DFC0CAD3819D4191818EE53270A18092BF9F3F73F
          03132323564D148700AF30179CBD7AF37D86D59BEFC3F90D25460C6C6C4C0C6D
          132F327CF9FA1BB9F170836A0EE0E2E7641094E26378FFEC1386DC86ED0F182E
          5E7B8F9E404F1C5CEFF380AAB940DB4195819111332E2E5C7D876EF93F86FF0C
          1554CF86A2F2820CFA6EEA581D819C14181819B30F6EF03E4893A258D1488681
          47980B5B51CCC0C0C0700E52147BEDA7695D202A2FC4E098648E5E196D6BF015
          F1A64B650403DC829C0CDC829CB01CF795EE0D920169948E3A60C83A60140000
          A809ADBD7679499A0000000049454E44AE426082}
        Position = bpRight
        ShowDisabled = False
        TabOrder = 4
        OnClick = Menu_View_NextPageClick
        Appearance.BorderColor = 12179676
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.ColorTo = 12179676
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 11899524
        Appearance.ColorDownTo = 11899524
        Appearance.ColorHot = 15717318
        Appearance.ColorHotTo = 15717318
        Appearance.ColorMirror = 12179676
        Appearance.ColorMirrorTo = 12179676
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
        Layout = blGlyphTop
      end
      object btnPrint: TAdvGlowButton
        Left = 407
        Top = 2
        Width = 77
        Height = 50
        Hint = 'Print the currently displayed document to printer'
        Caption = 'Print'
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
        ShowDisabled = False
        TabOrder = 5
        OnClick = Menu_File_PrintClick
        Appearance.BorderColor = 12179676
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.ColorTo = 12179676
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 11899524
        Appearance.ColorDownTo = 11899524
        Appearance.ColorHot = 15717318
        Appearance.ColorHotTo = 15717318
        Appearance.ColorMirror = 12179676
        Appearance.ColorMirrorTo = 12179676
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
        Layout = blGlyphTop
      end
      object btnHelp: TAdvGlowButton
        Left = 494
        Top = 2
        Width = 77
        Height = 50
        Hint = 'View the On-Line Help for the Exchequer EDF Viewer'
        Caption = 'Help'
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
        ShowDisabled = False
        TabOrder = 6
        OnClick = btnHelpClick
        Appearance.BorderColor = 12179676
        Appearance.BorderColorHot = clHighlight
        Appearance.BorderColorDown = clHighlight
        Appearance.BorderColorChecked = clBlack
        Appearance.ColorTo = 12179676
        Appearance.ColorChecked = 12179676
        Appearance.ColorCheckedTo = 12179676
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 11899524
        Appearance.ColorDownTo = 11899524
        Appearance.ColorHot = 15717318
        Appearance.ColorHotTo = 15717318
        Appearance.ColorMirror = 12179676
        Appearance.ColorMirrorTo = 12179676
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
        Layout = blGlyphTop
      end
    end
  end
  object FilePrinter1: TFilePrinter
    StreamMode = smFile
    Left = 485
    Top = 192
  end
  object FilePreview1: TFilePreview
    StreamMode = smFile
    ScrollBox = ScrollBox_Preview
    ZoomInc = 25
    ZoomFactor = 90
    ShadowDepth = 0
    Left = 350
    Top = 221
  end
  object Popup_Preview: TPopupMenu
    AutoHotkeys = maManual
    Left = 53
    Top = 233
    object Popup_Preview_ZoomIn: TMenuItem
      Caption = 'Zoom &In'
      Hint = 'Zoom In|Enlarges the document image to show more detail'
      ShortCut = 16457
      OnClick = Menu_View_ZoomInClick
    end
    object Popup_Preview_ZoomOut: TMenuItem
      Caption = 'Zoom &Out'
      Hint = 
        'Zoom Out|Reduces the document image to show a larger area of the' +
        ' page'
      ShortCut = 16463
      OnClick = Menu_View_ZoomOutClick
    end
    object Popup_Preview_ZoomToPage: TMenuItem
      Caption = 'Zoom to P&age'
      Hint = 'Zoom to Page|Adjusts the Zoom to show the entire page at once'
      OnClick = Menu_View_ZoomPageClick
    end
    object Popup_Preview_ZoomToNormal: TMenuItem
      Caption = 'Zoom to Nor&mal'
      Hint = 'Zoom to Normal|Returns the Zoom to the original setting'
      OnClick = Menu_View_ZoomToNormalClick
    end
    object Popup_Preview_SepBar1: TMenuItem
      Caption = '-'
    end
    object Popup_Preview_PrevPage: TMenuItem
      Caption = 'P&revious Page'
      Hint = 'Previous Page|Displays the previous page in the document'
      ShortCut = 16464
      OnClick = Menu_View_PrevPageClick
    end
    object Popup_Preview_NextPage: TMenuItem
      Caption = '&Next Page'
      Hint = 'Next Page|Displays the next page in the document'
      ShortCut = 16462
      OnClick = Menu_View_NextPageClick
    end
    object Popup_Preview_SepBar2: TMenuItem
      Caption = '-'
    end
    object Popup_Preview_Print: TMenuItem
      Caption = '&Print'
      Hint = 'Print Document|Print the currently displayed document to printer'
      OnClick = Menu_File_PrintClick
    end
  end
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    Left = 109
    Top = 149
    object menu_File: TMenuItem
      Caption = '&File'
      object Menu_File_Print: TMenuItem
        Caption = '&Print'
        Hint = 'Print Document|Print the currently displayed document to printer'
        ImageIndex = 5
        OnClick = Menu_File_PrintClick
      end
      object Menu_File_SepBar: TMenuItem
        Caption = '-'
      end
      object Menu_File_Exit: TMenuItem
        Caption = 'E&xit'
        Hint = 'Close EDF Viewer'
        ImageIndex = 7
        OnClick = Menu_File_ExitClick
      end
    end
    object Menu_View: TMenuItem
      Caption = '&View'
      object Menu_View_ZoomIn: TMenuItem
        Caption = 'Zoom &In'
        Hint = 'Zoom In|Enlarges the document image to show more detail'
        ImageIndex = 0
        ShortCut = 16457
        OnClick = Menu_View_ZoomInClick
      end
      object Menu_View_ZoomOut: TMenuItem
        Caption = 'Zoom &Out'
        Hint = 
          'Zoom Out|Reduces the document image to show a larger area of the' +
          ' page'
        ImageIndex = 1
        ShortCut = 16463
        OnClick = Menu_View_ZoomOutClick
      end
      object Menu_View_ZoomPage: TMenuItem
        Caption = 'Zoom to Page'
        Hint = 'Zoom to Page|Adjusts the Zoom to show the entire page at once'
        ImageIndex = 2
        OnClick = Menu_View_ZoomPageClick
      end
      object ZoomtoNormal1: TMenuItem
        Caption = 'Zoom to Nor&mal'
        Hint = 'Zoom to Normal|Returns the Zoom to the original setting'
        OnClick = Menu_View_ZoomToNormalClick
      end
      object Menu_View_SepBar1: TMenuItem
        Caption = '-'
      end
      object Menu_View_PrevPage: TMenuItem
        Caption = 'Previous Page'
        Hint = 'Previous Page|Displays the previous page in the document'
        ImageIndex = 3
        ShortCut = 16464
        OnClick = Menu_View_PrevPageClick
      end
      object Menu_View_NextPage: TMenuItem
        Caption = 'Next Page'
        Hint = 'Next Page|Displays the next page in the document'
        ImageIndex = 4
        ShortCut = 16462
        OnClick = Menu_View_NextPageClick
      end
    end
    object Menu_Help: TMenuItem
      Caption = '&Help'
      object Menu_Help_Contents: TMenuItem
        Caption = '&Contents'
        Hint = 'Help Contents|View the Contents for the EDF Reader On-Line Help'
        ImageIndex = 6
        OnClick = Menu_Help_ContentsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Menu_Help_About1: TMenuItem
        Caption = '&About'
        Hint = 'About|Display Copyright and Version information'
        OnClick = Menu_Help_About1Click
      end
    end
  end
  object AbUnZipper1: TAbUnZipper
    Left = 22
    Top = 136
  end
  object AdvToolBarStyler: TAdvToolBarOfficeStyler
    Style = bsOfficeXP
    BorderColorHot = clHighlight
    ButtonAppearance.Color = clBtnFace
    ButtonAppearance.ColorTo = clBtnFace
    ButtonAppearance.ColorChecked = clBtnFace
    ButtonAppearance.ColorDown = 11899524
    ButtonAppearance.ColorHot = 15717318
    ButtonAppearance.BorderDownColor = clNavy
    ButtonAppearance.BorderHotColor = clNavy
    ButtonAppearance.BorderCheckedColor = clNavy
    ButtonAppearance.CaptionFont.Charset = DEFAULT_CHARSET
    ButtonAppearance.CaptionFont.Color = clWindowText
    ButtonAppearance.CaptionFont.Height = -11
    ButtonAppearance.CaptionFont.Name = 'Tahoma'
    ButtonAppearance.CaptionFont.Style = []
    CaptionAppearance.CaptionColor = clHighlight
    CaptionAppearance.CaptionColorTo = clHighlight
    CaptionAppearance.CaptionBorderColor = clHighlight
    CaptionAppearance.CaptionColorHot = clHighlight
    CaptionAppearance.CaptionColorHotTo = clHighlight
    CaptionFont.Charset = ANSI_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'Arial'
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
    Font.Name = 'Tahoma'
    Font.Style = []
    GlowButtonAppearance.BorderColor = 12179676
    GlowButtonAppearance.BorderColorHot = clHighlight
    GlowButtonAppearance.BorderColorDown = clHighlight
    GlowButtonAppearance.BorderColorChecked = clBlack
    GlowButtonAppearance.ColorTo = 12179676
    GlowButtonAppearance.ColorChecked = 12179676
    GlowButtonAppearance.ColorCheckedTo = 12179676
    GlowButtonAppearance.ColorDisabled = 15921906
    GlowButtonAppearance.ColorDisabledTo = 15921906
    GlowButtonAppearance.ColorDown = 11899524
    GlowButtonAppearance.ColorDownTo = 11899524
    GlowButtonAppearance.ColorHot = 15717318
    GlowButtonAppearance.ColorHotTo = 15717318
    GlowButtonAppearance.ColorMirror = 12179676
    GlowButtonAppearance.ColorMirrorTo = 12179676
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
    GroupAppearance.Font.Name = 'Tahoma'
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
    PagerCaption.Font.Name = 'Tahoma'
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
    TabAppearance.Font.Name = 'Tahoma'
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
    Left = 372
    Top = 160
  end
end
