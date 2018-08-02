object frmDSRConfigFrame: TfrmDSRConfigFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 270
  Align = alClient
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  OnEnter = FrameEnter
  object advPanel: TAdvPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 270
    Align = alClient
    BevelOuter = bvNone
    Color = 16640730
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 7485192
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    UseDockManager = True
    Version = '1.7.6.0'
    AutoHideChildren = False
    BorderColor = 16765615
    Caption.Color = 16773091
    Caption.ColorTo = 16765615
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clBlack
    Caption.Font.Height = -11
    Caption.Font.Name = 'MS Sans Serif'
    Caption.Font.Style = []
    Caption.GradientDirection = gdVertical
    Caption.Indent = 2
    Caption.ShadeLight = 255
    CollapsColor = clHighlight
    CollapsDelay = 0
    ColorTo = 14986888
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
    FullHeight = 0
    object gbPop: TAdvGroupBox
      Left = 7
      Top = 126
      Width = 525
      Height = 197
      Caption = ' E-Mail Accounts  '
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object lblDefaultEmailAccc: TLabel
        Left = 8
        Top = 26
        Width = 109
        Height = 14
        Caption = 'Default E-Mail Account'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object pnlButtons: TAdvPanel
        Left = 2
        Top = 154
        Width = 521
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = 16640730
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        UseDockManager = True
        Version = '1.7.6.0'
        BorderColor = 16765615
        Caption.Color = clHighlight
        Caption.ColorTo = clNone
        Caption.Font.Charset = DEFAULT_CHARSET
        Caption.Font.Color = clHighlightText
        Caption.Font.Height = -11
        Caption.Font.Name = 'Tahoma'
        Caption.Font.Style = []
        ColorTo = 14986888
        StatusBar.Font.Charset = DEFAULT_CHARSET
        StatusBar.Font.Color = clWindowText
        StatusBar.Font.Height = -11
        StatusBar.Font.Name = 'Tahoma'
        StatusBar.Font.Style = []
        FullHeight = 0
        object btnPop3Add: TAdvGlowButton
          Left = 9
          Top = 14
          Width = 80
          Height = 21
          Caption = '&Add New...'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          FocusType = ftHot
          ParentFont = False
          TabOrder = 0
          TabStop = True
          OnClick = btnPop3AddClick
          Appearance.BorderColor = clGray
          Appearance.ColorChecked = 16111818
          Appearance.ColorCheckedTo = 16367008
          Appearance.ColorDisabled = 15921906
          Appearance.ColorDisabledTo = 15921906
          Appearance.ColorDown = 16111818
          Appearance.ColorDownTo = 16367008
          Appearance.ColorHot = 16117985
          Appearance.ColorHotTo = 16372402
          Appearance.ColorMirrorHot = 16107693
          Appearance.ColorMirrorHotTo = 16775412
          Appearance.ColorMirrorDown = 16102556
          Appearance.ColorMirrorDownTo = 16768988
          Appearance.ColorMirrorChecked = 16102556
          Appearance.ColorMirrorCheckedTo = 16768988
          Appearance.ColorMirrorDisabled = 11974326
          Appearance.ColorMirrorDisabledTo = 15921906
        end
        object btnUpdate: TAdvGlowButton
          Left = 92
          Top = 14
          Width = 80
          Height = 21
          Caption = '&Change...'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          FocusType = ftHot
          ParentFont = False
          TabOrder = 1
          TabStop = True
          OnClick = btnUpdateClick
          Appearance.BorderColor = clGray
          Appearance.ColorChecked = 16111818
          Appearance.ColorCheckedTo = 16367008
          Appearance.ColorDisabled = 15921906
          Appearance.ColorDisabledTo = 15921906
          Appearance.ColorDown = 16111818
          Appearance.ColorDownTo = 16367008
          Appearance.ColorHot = 16117985
          Appearance.ColorHotTo = 16372402
          Appearance.ColorMirrorHot = 16107693
          Appearance.ColorMirrorHotTo = 16775412
          Appearance.ColorMirrorDown = 16102556
          Appearance.ColorMirrorDownTo = 16768988
          Appearance.ColorMirrorChecked = 16102556
          Appearance.ColorMirrorCheckedTo = 16768988
          Appearance.ColorMirrorDisabled = 11974326
          Appearance.ColorMirrorDisabledTo = 15921906
        end
        object btnPop3Delete: TAdvGlowButton
          Left = 176
          Top = 14
          Width = 80
          Height = 21
          Caption = '&Delete'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          FocusType = ftHot
          ParentFont = False
          TabOrder = 2
          TabStop = True
          OnClick = btnPop3DeleteClick
          Appearance.BorderColor = clGray
          Appearance.ColorChecked = 16111818
          Appearance.ColorCheckedTo = 16367008
          Appearance.ColorDisabled = 15921906
          Appearance.ColorDisabledTo = 15921906
          Appearance.ColorDown = 16111818
          Appearance.ColorDownTo = 16367008
          Appearance.ColorHot = 16117985
          Appearance.ColorHotTo = 16372402
          Appearance.ColorMirrorHot = 16107693
          Appearance.ColorMirrorHotTo = 16775412
          Appearance.ColorMirrorDown = 16102556
          Appearance.ColorMirrorDownTo = 16768988
          Appearance.ColorMirrorChecked = 16102556
          Appearance.ColorMirrorCheckedTo = 16768988
          Appearance.ColorMirrorDisabled = 11974326
          Appearance.ColorMirrorDisabledTo = 15921906
        end
        object btnSetDefault: TAdvGlowButton
          Left = 260
          Top = 14
          Width = 80
          Height = 21
          Caption = '&Set as Default'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          FocusType = ftHot
          ParentFont = False
          TabOrder = 3
          TabStop = True
          OnClick = btnSetDefaultClick
          Appearance.BorderColor = clGray
          Appearance.ColorChecked = 16111818
          Appearance.ColorCheckedTo = 16367008
          Appearance.ColorDisabled = 15921906
          Appearance.ColorDisabledTo = 15921906
          Appearance.ColorDown = 16111818
          Appearance.ColorDownTo = 16367008
          Appearance.ColorHot = 16117985
          Appearance.ColorHotTo = 16372402
          Appearance.ColorMirrorHot = 16107693
          Appearance.ColorMirrorHotTo = 16775412
          Appearance.ColorMirrorDown = 16102556
          Appearance.ColorMirrorDownTo = 16768988
          Appearance.ColorMirrorChecked = 16102556
          Appearance.ColorMirrorCheckedTo = 16768988
          Appearance.ColorMirrorDisabled = 11974326
          Appearance.ColorMirrorDisabledTo = 15921906
        end
      end
      object edtDefaultEmailAcc: TAdvEdit
        Tag = 9
        Left = 8
        Top = 42
        Width = 229
        Height = 22
        DisabledColor = clWindow
        ReturnIsTab = True
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'MS Sans Serif'
        LabelFont.Style = []
        Lookup.Separator = ';'
        AutoSize = False
        Color = clWindow
        Ctl3D = False
        Enabled = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
        Visible = True
        Version = '2.7.0.6'
      end
      object lvPop3: TAdvListView
        Left = 2
        Top = 17
        Width = 521
        Height = 137
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvRaised
        BevelKind = bkSoft
        BorderStyle = bsNone
        Columns = <
          item
            Caption = 'Your Name'
            Width = 150
          end
          item
            Caption = 'E-Mail Address'
            Width = 130
          end
          item
            Caption = 'Incoming Server'
            Width = 130
          end
          item
            Caption = 'Outgoing Server'
            Width = 130
          end
          item
            Caption = 'User Name'
            Width = 80
          end
          item
            Caption = 'Password'
            Width = 100
          end
          item
            Caption = 'Default'
          end
          item
            Caption = 'POP3 Port'
            Width = 60
          end
          item
            Caption = 'SMTP Port'
            Width = 60
          end>
        ColumnClick = False
        Ctl3D = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        HoverTime = -1
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        PopupMenu = ppmMail
        ShowWorkAreas = True
        TabOrder = 2
        ViewStyle = vsReport
        OnDblClick = lvPop3DblClick
        OnSelectItem = lvPop3SelectItem
        AutoHint = False
        ClipboardEnable = False
        ColumnSize.Save = False
        ColumnSize.Stretch = False
        ColumnSize.Storage = stInifile
        FilterTimeOut = 500
        PrintSettings.FooterSize = 0
        PrintSettings.HeaderSize = 0
        PrintSettings.Time = ppNone
        PrintSettings.Date = ppNone
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.PageNr = ppNone
        PrintSettings.Title = ppNone
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'MS Sans Serif'
        PrintSettings.Font.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'MS Sans Serif'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'MS Sans Serif'
        PrintSettings.FooterFont.Style = []
        PrintSettings.Borders = pbNoborder
        PrintSettings.BorderStyle = psSolid
        PrintSettings.Centered = False
        PrintSettings.RepeatHeaders = False
        PrintSettings.LeftSize = 0
        PrintSettings.RightSize = 0
        PrintSettings.ColumnSpacing = 0
        PrintSettings.RowSpacing = 0
        PrintSettings.Orientation = poPortrait
        PrintSettings.FixedWidth = 0
        PrintSettings.FixedHeight = 0
        PrintSettings.UseFixedHeight = False
        PrintSettings.UseFixedWidth = False
        PrintSettings.FitToPage = fpNever
        PrintSettings.PageNumSep = '/'
        HTMLHint = False
        HTMLSettings.Width = 100
        HeaderHotTrack = False
        HeaderDragDrop = False
        HeaderFlatStyle = True
        HeaderOwnerDraw = False
        HeaderHeight = 13
        HeaderFont.Charset = ANSI_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Arial'
        HeaderFont.Style = []
        ProgressSettings.ColorFrom = clSilver
        ProgressSettings.FontColorFrom = clBlack
        ProgressSettings.ColorTo = clWhite
        ProgressSettings.FontColorTo = clGray
        SelectionRTFKeep = False
        ScrollHint = False
        SelectionColor = clHighlight
        SelectionTextColor = clHighlightText
        SizeWithForm = True
        SortDirection = sdAscending
        SortShow = False
        SortIndicator = siLeft
        StretchColumn = False
        SubImages = False
        SubItemEdit = False
        SubItemSelect = False
        VAlignment = vtaCenter
        ItemHeight = 13
        SaveHeader = False
        LoadHeader = True
        ReArrangeItems = False
        DetailView.Visible = False
        DetailView.Column = 0
        DetailView.Font.Charset = DEFAULT_CHARSET
        DetailView.Font.Color = clBlue
        DetailView.Font.Height = -11
        DetailView.Font.Name = 'MS Sans Serif'
        DetailView.Font.Style = []
        DetailView.Height = 16
        DetailView.Indent = 0
        DetailView.SplitLine = False
        Version = '1.6.3.0'
      end
    end
    object gbEmail: TAdvGroupBox
      Left = 7
      Top = 5
      Width = 525
      Height = 118
      Caption = ' Sending/Receiving Settings '
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object Label2: TLabel
        Left = 341
        Top = 25
        Width = 90
        Height = 14
        Caption = 'Polling time (in min)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object edtPollingTime: TAdvSpinEdit
        Left = 444
        Top = 18
        Width = 66
        Height = 23
        ReturnIsTab = True
        Value = 1
        FloatValue = 1
        TimeValue = 0.0416666666666667
        HexValue = 0
        Enabled = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        IncrementFloat = 0.1
        IncrementFloatPage = 1
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'MS Sans Serif'
        LabelFont.Style = []
        MaxLength = 4
        MaxValue = 1440
        MinValue = 1
        ParentFont = False
        TabOrder = 1
        Visible = True
        Version = '1.4.1.0'
      end
      object rbConnectionType: TAdvOfficeRadioGroup
        Left = 8
        Top = 18
        Width = 322
        Height = 55
        Version = '1.0.0.0'
        Caption = ' Connection Type  '
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = rbConnectionTypeClick
        Ellipsis = False
        ShadowColor = clBlack
        ShadowOffset = 0
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'MAPI'
          'SMTP/POP3'
          'Other')
      end
      object ckbDeleteEmail: TAdvOfficeCheckBox
        Left = 8
        Top = 89
        Width = 205
        Height = 20
        Alignment = taLeftJustify
        Caption = 'Delete non related ClientLink e-mails'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReturnIsTab = True
        TabOrder = 2
        TabStop = True
        OnClick = ckbDeleteEmailClick
        Version = '1.0.0.0'
      end
      object edtOutgoingGuid: TAdvMaskEdit
        Left = 8
        Top = 131
        Width = 245
        Height = 20
        CharCase = ecUpperCase
        Color = clWindow
        Enabled = True
        EditMask = '{AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA};1;_'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 38
        ParentFont = False
        TabOrder = 3
        Text = '{        -    -    -    -            }'
        Visible = False
        AutoFocus = False
        DisabledColor = clSilver
        Flat = False
        FlatLineColor = clBlack
        FlatParentColor = True
        ShowModified = False
        FocusColor = clWindow
        FocusBorder = False
        FocusFontColor = clBlack
        LabelAlwaysEnabled = False
        LabelPosition = lpLeftTop
        LabelMargin = 4
        LabelTransparent = False
        LabelFont.Charset = ANSI_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Arial'
        LabelFont.Style = []
        ModifiedColor = clRed
        SelectFirstChar = False
        Version = '2.7.0.6'
      end
      object edtIncomingGuid: TAdvMaskEdit
        Left = 265
        Top = 131
        Width = 245
        Height = 20
        CharCase = ecUpperCase
        Color = clWindow
        Enabled = True
        EditMask = '{AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA};1;_'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 38
        ParentFont = False
        TabOrder = 4
        Text = '{        -    -    -    -            }'
        Visible = False
        AutoFocus = False
        DisabledColor = clSilver
        Flat = False
        FlatLineColor = clBlack
        FlatParentColor = True
        ShowModified = False
        FocusColor = clWindow
        FocusBorder = False
        FocusFontColor = clBlack
        LabelAlwaysEnabled = False
        LabelPosition = lpLeftTop
        LabelMargin = 4
        LabelTransparent = False
        LabelFont.Charset = ANSI_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Arial'
        LabelFont.Style = []
        ModifiedColor = clRed
        SelectFirstChar = False
        Version = '2.7.0.6'
      end
    end
  end
  object ppmMail: TPopupMenu
    OnPopup = ppmMailPopup
    Left = 324
    Top = 184
    object mniAddNew: TMenuItem
      Caption = '&Add New...'
      OnClick = mniAddNewClick
    end
    object Update1: TMenuItem
      Caption = '&Change...'
      OnClick = Update1Click
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      OnClick = Delete1Click
    end
    object mniSetasDefault: TMenuItem
      Caption = 'Set as Default'
      OnClick = mniSetasDefaultClick
    end
  end
end
