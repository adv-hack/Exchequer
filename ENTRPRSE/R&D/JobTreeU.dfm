object JobView: TJobView
  Left = 100
  Top = 100
  Width = 288
  Height = 462
  HelpContext = 922
  Caption = 'CostingTree'
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
  object NLDPanel: TSBSPanel
    Left = 3
    Top = 48
    Width = 264
    Height = 19
    Alignment = taLeftJustify
    BevelOuter = bvLowered
    Caption = '  Costing Groups and Records'
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
  object NLOLine: TSBSOutlineB
    Left = 3
    Top = 71
    Width = 264
    Height = 321
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
    TabOrder = 0
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
    ParentFont = False
    ScrollBars = ssVertical
    ShowValCol = 2
    OnNeedValue = NLOLineNeedValue
    TreeColor = clNavy
    Data = {1C00}
  end
  object SBSPanel1: TSBSPanel
    Left = 0
    Top = 401
    Width = 280
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Bevel6: TBevel
      Left = 3
      Top = 1
      Width = 241
      Height = 2
      Shape = bsTopLine
    end
    object Panel4: TSBSPanel
      Left = 3
      Top = 7
      Width = 210
      Height = 20
      Alignment = taRightJustify
      BevelOuter = bvLowered
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      Purpose = puFrame
      object lblStatusCode: Label8
        Left = 8
        Top = 3
        Width = 116
        Height = 14
        AutoSize = False
        Caption = 'Status : '
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
    Width = 280
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
      Width = 274
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
        Left = 171
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
      object Panel1: TPanel
        Left = 181
        Top = 2
        Width = 80
        Height = 38
        BevelOuter = bvNone
        TabOrder = 2
        object ClsI1Btn: TButton
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
      object Panel2: TPanel
        Left = 92
        Top = 2
        Width = 79
        Height = 38
        BevelOuter = bvNone
        TabOrder = 3
        object OptBtn: TButton
          Left = 1
          Top = 10
          Width = 78
          Height = 21
          HelpContext = 974
          Caption = '&Options'
          TabOrder = 0
          OnClick = OptBtnClick
        end
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 178
    Top = 109
    object View1: TMenuItem
      Caption = '&View Job'
      HelpContext = 916
      OnClick = Edit1Click
    end
    object Add1: TMenuItem
      Tag = 1
      Caption = '&Add a New Job/Contract'
      HelpContext = 916
    end
    object Edit1: TMenuItem
      Tag = 2
      Caption = '&Edit Job'
      HelpContext = 916
      OnClick = Edit1Click
    end
    object Delete1: TMenuItem
      Tag = 3
      Caption = '&Delete Job'
      HelpContext = 850
      OnClick = Edit1Click
    end
    object Notes1: TMenuItem
      Tag = 5
      Caption = '&Notes for Job'
      HelpContext = 844
      OnClick = Edit1Click
    end
    object Print1: TMenuItem
      Caption = '&Print Job'
      HelpContext = 846
      OnClick = Print1Click
    end
    object MIFind: TMenuItem
      Caption = '&Find Job'
      HelpContext = 847
      OnClick = MIFindClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object InvJob1: TMenuItem
      Caption = '&Invoice Job / Transfer WIP'
      HelpContext = 937
      OnClick = InvJob1Click
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object FiltJobs1: TMenuItem
      Caption = 'Filte&r Jobs by Status'
    end
    object CopyJob1: TMenuItem
      Caption = '&Copy Job to new Job'
      HelpContext = 848
      OnClick = CopyJob1Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object ShowApps1: TMenuItem
      Caption = 'App&lications'
      HelpContext = 1526
      OnClick = ShowApps1Click
    end
    object Valuation1: TMenuItem
      Caption = 'Val&uation'
      HelpContext = 1539
      object Val1: TMenuItem
        Caption = '&Apply Contract Valuation to lower levels'
        OnClick = Val1Click
      end
      object Val2: TMenuItem
        Tag = 1
        Caption = '&Set Job Valuation based on Expenditure to-date'
        OnClick = Val1Click
      end
    end
    object CIS2: TMenuItem
      Caption = 'Contractors Ta&x'
      object CISL1: TMenuItem
        Tag = 1
        Caption = ' Ledger'
        OnClick = CISL1Click
      end
      object CISG1: TMenuItem
        Caption = '&Generate CIS23 && CIS25'
        OnClick = CISL1Click
      end
      object CISG2: TMenuItem
        Tag = 6
        Caption = 'G&enerate CIS24'
        OnClick = CISL1Click
      end
      object CISG3: TMenuItem
        Caption = '&Generate Monthly Return'
        OnClick = CISL1Click
      end
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object ShowTotals1: TMenuItem
      Caption = 'Show &Totals'
      HelpContext = 849
      OnClick = ShowTotals1Click
    end
    object CheckAllJobs1: TMenuItem
      Caption = 'C&heck All Jobs'
      OnClick = CheckAllJobs1Click
    end
    object CheckJobTotals2: TMenuItem
      Caption = 'Check All Highlighted &Job Totals'
      Visible = False
      OnClick = CheckJobTotals2Click
    end
    object CheckJobTotals1: TMenuItem
      Caption = '&Recalc all Job Contract Totals'
      Visible = False
      OnClick = CheckJobTotals1Click
    end
    object N4: TMenuItem
      Caption = '-'
      Visible = False
    end
    object Move1: TMenuItem
      Caption = '&Move - From (Pick up)     '
      HelpContext = 973
      ShortCut = 16461
      Visible = False
      OnClick = Move1Click
    end
    object Move2: TMenuItem
      Caption = '&Move - To (Put down)'
      HelpContext = 973
      ShortCut = 16461
      Visible = False
      OnClick = Move1Click
    end
    object CanlMove1: TMenuItem
      Caption = 'Cancel Mo&ve'
      HelpContext = 973
      Visible = False
      OnClick = Move1Click
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
        Caption = '&Entire Job Tree'
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
        Caption = '&Entire Job Tree'
        HelpContext = 972
        OnClick = MIEALClick
      end
    end
    object OptSpeed: TMenuItem
      Caption = '&Optimise for Speed'
      HelpContext = 853
      OnClick = OptSpeedClick
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
    Left = 78
    Top = 100
    object Job1: TMenuItem
      Tag = 1
      Caption = '&Job'
      OnClick = Job1Click
    end
    object Contract1: TMenuItem
      Tag = 2
      Caption = '&Contract'
      OnClick = Job1Click
    end
  end
  object PopupMenu3: TPopupMenu
    Left = 80
    Top = 149
    object Quotation2: TMenuItem
      Tag = 1
      Caption = 'Include &Quotation'
      Checked = True
      OnClick = Quotation1Click
    end
    object Active2: TMenuItem
      Tag = 2
      Caption = 'Include &Active'
      Checked = True
      OnClick = Quotation1Click
    end
    object Suspended2: TMenuItem
      Tag = 3
      Caption = 'Include Suspended'
      Checked = True
      OnClick = Quotation1Click
    end
    object Completed2: TMenuItem
      Tag = 4
      Caption = 'Include &Completed'
      Checked = True
      OnClick = Quotation1Click
    end
    object Closed2: TMenuItem
      Tag = 5
      Caption = 'Include C&losed'
      OnClick = Quotation1Click
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
    Left = 138
    Top = 120
  end
end
