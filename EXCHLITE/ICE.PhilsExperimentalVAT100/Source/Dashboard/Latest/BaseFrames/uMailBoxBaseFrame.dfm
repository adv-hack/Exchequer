object frmMailBoxBaseFrame: TfrmMailBoxBaseFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 270
  Align = alClient
  Ctl3D = False
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  ParentCtl3D = False
  ParentFont = False
  TabOrder = 0
  OnEnter = FrameEnter
  OnExit = FrameExit
  OnResize = FrameResize
  object advPanelMail: TAdvPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 270
    Align = alClient
    BevelInner = bvLowered
    Color = 16445929
    Font.Charset = ANSI_CHARSET
    Font.Color = 7485192
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    UseDockManager = True
    Version = '1.7.6.0'
    AutoHideChildren = False
    BorderColor = 16765615
    Caption.Color = 16773091
    Caption.ColorTo = 16765615
    Caption.Font.Charset = ANSI_CHARSET
    Caption.Font.Color = clBlack
    Caption.Font.Height = -15
    Caption.Font.Name = 'Tahoma'
    Caption.Font.Style = [fsBold]
    Caption.GradientDirection = gdVertical
    Caption.ShadeLight = 255
    Caption.Text = 'Inbox'
    Caption.TopIndent = 3
    CollapsColor = clHighlight
    CollapsDelay = 0
    ColorTo = 15587527
    ColorMirror = 15587527
    ColorMirrorTo = 16773863
    Indent = 5
    ShadowColor = clBlack
    ShadowOffset = 0
    StatusBar.BorderColor = 16765615
    StatusBar.BorderStyle = bsSingle
    StatusBar.Font.Charset = DEFAULT_CHARSET
    StatusBar.Font.Color = 7485192
    StatusBar.Font.Height = -11
    StatusBar.Font.Name = 'Tahoma'
    StatusBar.Font.Style = []
    StatusBar.Color = 16245715
    StatusBar.ColorTo = 16109747
    StatusBar.GradientDirection = gdVertical
    TextVAlign = tvaCenter
    FullHeight = 0
    object AdvOutlook: TAdvOutlookList
      Left = 2
      Top = 28
      Width = 439
      Height = 94
      Align = alClient
      BorderColor = clWhite
      Columns = <
        item
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          HeaderFont.Charset = ANSI_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -11
          HeaderFont.Name = 'Arial'
          HeaderFont.Style = []
        end>
      Color = clWhite
      GroupItemHeight = 34
      GroupShowCount = True
      HeaderDragDrop = ddDisabled
      HeaderHeight = 25
      HideSelection = False
      Images = imgStatus
      DragType = dtVCL
      LookUp.Method = lmDirect
      GroupColumnDisplay = gdHidden
      ProgressAppearance.CompleteColor = 14059353
      ProgressAppearance.CompleteFontColor = clBlack
      ProgressAppearance.Level3Color = 14059353
      ProgressAppearance.Level3ColorTo = 9648131
      ProgressAppearance.Level1Perc = 50
      ProgressAppearance.Level2Perc = 85
      ProgressAppearance.ShowPercentage = False
      ProgressAppearance.ShowGradient = False
      ProgressAppearance.Steps = 1
      PreviewSettings.Font.Charset = ANSI_CHARSET
      PreviewSettings.Font.Color = clBlue
      PreviewSettings.Font.Height = -11
      PreviewSettings.Font.Name = 'Arial'
      PreviewSettings.Font.Style = []
      SelectionOptions = [soMultiSelect]
      ShowHint = False
      ShowNodes = True
      SortSettings.Enabled = False
      SortSettings.SortGroups = False
      TabOrder = 0
      TabStop = True
      URLSettings.FontStyle = [fsUnderline]
      Version = '1.3.9.0'
      OnDrawItemProp = AdvOutlookDrawItemProp
      OnItemClick = AdvOutlookItemClick
      OnSelectionChange = AdvOutlookSelectionChange
    end
    object advPanelCaption: TAdvPanel
      Left = 2
      Top = 2
      Width = 439
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      Color = 16773091
      Font.Charset = ANSI_CHARSET
      Font.Color = 7485192
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      UseDockManager = True
      Version = '1.7.6.0'
      AutoHideChildren = False
      BorderColor = 16765615
      Caption.Color = 16773091
      Caption.ColorTo = 16768452
      Caption.Font.Charset = ANSI_CHARSET
      Caption.Font.Color = clBlack
      Caption.Font.Height = -15
      Caption.Font.Name = 'Tahoma'
      Caption.Font.Style = [fsBold]
      Caption.ShadeLight = 255
      Caption.TopIndent = 5
      CollapsColor = clHighlight
      CollapsDelay = 0
      ColorTo = 16768452
      ColorMirror = 15587527
      ColorMirrorTo = 16773863
      Indent = 5
      ShadowColor = clBlack
      ShadowOffset = 0
      StatusBar.BorderColor = 16765615
      StatusBar.BorderStyle = bsSingle
      StatusBar.Font.Charset = DEFAULT_CHARSET
      StatusBar.Font.Color = 7485192
      StatusBar.Font.Height = -11
      StatusBar.Font.Name = 'Tahoma'
      StatusBar.Font.Style = []
      StatusBar.Color = 16245715
      StatusBar.ColorTo = 16109747
      StatusBar.GradientDirection = gdVertical
      TextVAlign = tvaCenter
      FullHeight = 26
    end
    object advPanelDetails: TAdvPanel
      Left = 2
      Top = 122
      Width = 439
      Height = 146
      Align = alBottom
      BevelInner = bvLowered
      Color = clWhite
      Constraints.MinHeight = 110
      Font.Charset = ANSI_CHARSET
      Font.Color = 7485192
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      UseDockManager = True
      Visible = False
      Version = '1.7.6.0'
      AutoHideChildren = False
      BorderColor = 16765615
      BorderWidth = 5
      Caption.Color = clWhite
      Caption.ColorTo = clWhite
      Caption.Font.Charset = ANSI_CHARSET
      Caption.Font.Color = clBlack
      Caption.Font.Height = -15
      Caption.Font.Name = 'Tahoma'
      Caption.Font.Style = [fsBold]
      Caption.GradientDirection = gdVertical
      Caption.ShadeLight = 255
      CollapsColor = clHighlight
      CollapsDelay = 0
      ColorTo = clWhite
      ColorMirror = clWhite
      ColorMirrorTo = clWhite
      Indent = 5
      ShadowColor = clBlack
      ShadowOffset = 0
      StatusBar.BorderColor = 16765615
      StatusBar.BorderStyle = bsSingle
      StatusBar.Font.Charset = DEFAULT_CHARSET
      StatusBar.Font.Color = 7485192
      StatusBar.Font.Height = -11
      StatusBar.Font.Name = 'Tahoma'
      StatusBar.Font.Style = []
      StatusBar.Color = 16245715
      StatusBar.ColorTo = 16109747
      StatusBar.GradientDirection = gdVertical
      TextVAlign = tvaCenter
      DesignSize = (
        439
        146)
      FullHeight = 110
      object lblFrom: TLabel
        Left = 7
        Top = 51
        Width = 425
        Height = 16
        Align = alTop
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblTo: TLabel
        Left = 5
        Top = 73
        Width = 17
        Height = 14
        Caption = 'To:'
        Constraints.MaxWidth = 20
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblTo_: TLabel
        Left = 26
        Top = 73
        Width = 3
        Height = 14
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblDt: TLabel
        Left = 5
        Top = 127
        Width = 58
        Height = 14
        Caption = 'Date/Time:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblAttachments: TLabel
        Left = 5
        Top = 91
        Width = 74
        Height = 14
        Caption = 'Attachments:'
        Constraints.MaxWidth = 75
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblAttach: TLabel
        Left = 83
        Top = 91
        Width = 3
        Height = 14
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblDateTime: TLabel
        Left = 66
        Top = 127
        Width = 3
        Height = 14
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lbSt: TLabel
        Left = 5
        Top = 109
        Width = 38
        Height = 14
        Caption = 'Status:'
        Constraints.MaxWidth = 75
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblStatus: TLabel
        Left = 46
        Top = 109
        Width = 3
        Height = 14
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object AdvProgress: TAdvProgressBar
        Left = 272
        Top = 114
        Width = 160
        Height = 25
        Anchors = [akTop, akRight]
        BorderColor = 16765615
        CompletionSmooth = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        Level0Color = 16765615
        Level0ColorTo = 16765615
        Level1Color = 16765615
        Level1ColorTo = 16765615
        Level2Color = 16765615
        Level2ColorTo = 16765615
        Level3Color = 16765615
        Level3ColorTo = 16765615
        Level1Perc = 20
        Level2Perc = 80
        Position = 0
        Rounded = False
        ShowBorder = True
        ShowGradient = False
        Stacked = True
        Steps = 1
        Version = '1.1.1.0'
      end
      object mmSubject: TMemo
        Left = 7
        Top = 7
        Width = 425
        Height = 44
        TabStop = False
        Align = alTop
        BorderStyle = bsNone
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        HideSelection = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object imgStatus: TImageList
    Left = 284
    Top = 100
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006B5A52006B5A52006352
      42005A4239000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008C7363008C736300D6A58C0094736300EFA5
      8400C6947300634A390063523900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008C736B009C8C7B00F7DECE00DEC6B500F7CE
      BD00F7BDA500AD7B630063523900000000000000000000000000000000000000
      000000000000000000006B738C004A5AA500314AAD001039BD00314AA5003952
      A5005A638C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084736B00E7CEDE00FFF7F700FFEFE700F7E7DE00F7D6
      C600EFC6AD00F7BD9C00C69473005A4239000000000000000000000000000000
      000000000000425AAD00294AB5001842B5002142A50021213900293984002131
      94001031AD0042529C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001884B500107BAD00187B
      AD003194BD006BADCE008C7B7300F7F7F700FFFFFF00EFEFE70084736B00A594
      8400B59C8C00CEA58C00DE9C7B006B4A4A000000000063636300636363000000
      00004A63AD00294ABD003952BD008C8CA500CEAD940084736B00D69C7B009C6B
      73004A396B001831A50042529C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001884B5004AB5E7002184BD009CF7
      F70084D6F700B5E7F700A5949400BDB5AD00F7F7EF00FFF7F7007B6B63006B5A
      4A008C7B6B00947B6B00CE9C7B00634A4200000000000000000000000000636B
      9C002952CE005A63A500BDADAD00F7CEA500F7CE9C00CEB59400F7D6A500FFCE
      AD00C6848C00393173001839A5005A638C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000218CBD005AC6F700218CBD009CFF
      FF0084E7FF00BDEFFF00ADB5AD00F7F7EF00FFFFFF00FFFFFF00F7F7EF008473
      63007B635A00E7BDAD00E7BDA500734A5A006B6B6B006B6B6B00000000004263
      BD003152CE006B7BC600FFEFD600F7E7CE00F7D6BD00F7CEB500F7DEB500FFDE
      B500FFCEAD00735A8C0029398C003952A5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000298CC60063CEFF002994C6009CFF
      FF008CEFFF00B5F7FF00C6E7E700B5B5AD009C948C00FFFFFF00D6CEC600E7DE
      D6006B5A4A0084736300846B5A0000000000000000000000000000000000315A
      D6004A63BD00C6BDCE00FFF7E700FFF7EF00FFE7D600F7DECE00FFE7CE00F7DE
      B500F7CEA500C69C8C0021318C002142AD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000298CC60063CEFF00319CCE00C6FF
      FF009CF7FF00ADF7FF00D6F7F700BDBDBD00BDBDB500F7F7F700ADA59C00FFEF
      EF00C6B5AD006B5A4A0073736B0000000000000000006B6B6B00000000002152
      EF00313963008C8C9400CECEC600FFF7F700FFF7EF00212121004A424200635A
      52009C846B00AD9C9400212129001039BD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002994C6006BD6FF0042A5CE00DEFF
      FF00A5FFFF00A5FFFF00C6FFFF00D6FFFF00CEEFE700B5B5AD008C7B73007B73
      630073635200B5C6C6005AA5C60000000000000000000000000000000000315A
      DE004263D600A5B5DE00FFFFF700FFFFFF00FFFFFF004A4A4A00B5AD9C00DEC6
      AD00F7CEAD00BD9C940021399C002142B5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002994C6007BE7FF003194C600FFFF
      FF00FFFFFF00F7FFFF00F7FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00F7FFFF00EFF7FF003994BD00000000007373730073737300000000004A63
      C6003963DE00738CDE00FFFFFF00FFFFFF00FFFFFF0063636300EFE7DE00FFEF
      DE00FFDEBD008C7B9C002142A5003952A5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003194CE0084EFFF0084E7FF002994
      C6002994C600218CBD00218CBD00218CBD00218CBD002184BD001884B500187B
      B5002184B5002984B5002184B500000000000000000000000000000000006373
      A500315AEF00426BDE0094ADEF00FFFFFF00FFFFFF009C9C9400FFF7EF00FFEF
      DE00BDB5BD004252A5001842C6005A6B94000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000319CCE0094F7FF008CF7FF008CF7
      FF008CF7FF008CF7FF008CF7FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00107BAD000000000000000000000000000000000073737300737373000000
      00004A6BBD00315AE7004A6BDE007B94E700D6D6EF00B5ADAD00EFE7D600949C
      C6005263A500214AC600425AAD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000319CCE00F7F7FF009CFFFF009CFF
      FF009CFFFF009CFFFF00F7F7F700218CBD002184BD001884B5001884B5001884
      B500187BB5000000000000000000000000000000000000000000000000000000
      0000000000005A6BB5004263D6004263DE005A73C600424A6B004263D600395A
      C600214AD6004A63AD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000319CCE00F7F7FF00FFFF
      FF00FFFFFF00F7F7F700298CC600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000006373A5004A63C600315ADE002152EF00315ADE004263
      BD00636B9C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000319CCE00319C
      CE003194CE002994C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FF87FFFF00000000FE01FFFF00000000
      FE01FC0700000000FC00F8030000000080009001000000000000E00000000000
      00002000000000000001E000000000000001A000000000000001E00000000000
      00012000000000000001E0000000000000079001000000000007F80300000000
      81FFFC0700000000C3FFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
  object tmBox: TTimer
    Enabled = False
    Interval = 3000
    Left = 286
    Top = 156
  end
end