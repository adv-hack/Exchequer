object frmIntPlugs: TfrmIntPlugs
  Left = 0
  Top = 0
  Width = 539
  Height = 753
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  TemplateProcessor = TemplateProcessor
  OnCreate = IWAppFormCreate
  DesignLeft = 292
  DesignTop = -12
  object capDealership: TIWLabel
    Left = 24
    Top = 40
    Width = 75
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Dealership:'
  end
  object lblDealership: TIWLabel
    Left = 176
    Top = 40
    Width = 90
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'ABC Systems'
  end
  object capCustomer: TIWLabel
    Left = 24
    Top = 64
    Width = 66
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Customer:'
  end
  object lblCustomer: TIWLabel
    Left = 176
    Top = 64
    Width = 82
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'MS Systems'
  end
  object capESN: TIWLabel
    Left = 24
    Top = 88
    Width = 34
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'ESN:'
  end
  object lblESN: TIWLabel
    Left = 176
    Top = 88
    Width = 188
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = '123-456-789-012-345-678-901'
  end
  object capVersion: TIWLabel
    Left = 24
    Top = 112
    Width = 53
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Version:'
  end
  object lblhdrPasswords: TIWLabel
    Left = 16
    Top = 192
    Width = 83
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'Passwords'
  end
  object cbDate: TIWComboBox
    Left = 176
    Top = 160
    Width = 325
    Height = 21
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ItemsHaveValues = False
    NoSelectionText = ' '
    RequireSelection = True
    ScriptEvents = <>
    OnChange = cbDateChange
    UseSize = True
    DoSubmitValidation = True
    Editable = True
    TabOrder = 0
    ItemIndex = -1
    Sorted = False
  end
  object lblVersion: TIWLabel
    Left = 176
    Top = 112
    Width = 178
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Exchequer Enterprise v5.01'
  end
  object lblDate: TIWLabel
    Left = 24
    Top = 160
    Width = 91
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Security Date:'
  end
  object edPlugIn: TIWEdit
    Left = 176
    Top = 224
    Width = 169
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edPlugIn'
    MaxLength = 0
    ReadOnly = True
    Required = False
    ScriptEvents = <>
    TabOrder = 14
    PasswordPrompt = False
  end
  object edMCM: TIWEdit
    Left = 176
    Top = 248
    Width = 169
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edMCM'
    MaxLength = 0
    ReadOnly = True
    Required = False
    ScriptEvents = <>
    TabOrder = 15
    PasswordPrompt = False
  end
  object edDaily: TIWEdit
    Left = 176
    Top = 272
    Width = 169
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edDaily'
    MaxLength = 0
    ReadOnly = True
    Required = False
    ScriptEvents = <>
    TabOrder = 16
    PasswordPrompt = False
  end
  object edDirectors: TIWEdit
    Left = 176
    Top = 296
    Width = 169
    Height = 21
    Visible = False
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edDirectors'
    MaxLength = 0
    ReadOnly = True
    Required = False
    ScriptEvents = <>
    TabOrder = 17
    PasswordPrompt = False
  end
  object lblSecPlugIn: TIWLabel
    Left = 24
    Top = 224
    Width = 48
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Plug-In:'
  end
  object lblMCM: TIWLabel
    Left = 24
    Top = 248
    Width = 37
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'MCM:'
  end
  object lblDaily: TIWLabel
    Left = 24
    Top = 272
    Width = 90
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Daily System:'
  end
  object lblDirectors: TIWLabel
    Left = 24
    Top = 296
    Width = 62
    Height = 16
    Visible = False
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Directors:'
  end
  object lblhdrSecurity: TIWLabel
    Left = 16
    Top = 393
    Width = 122
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    AutoSize = False
    Caption = 'Plug-In Security'
  end
  object lblSecCode: TIWLabel
    Left = 24
    Top = 451
    Width = 95
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Security Code:'
  end
  object lbl30SecCode: TIWLabel
    Left = 24
    Top = 609
    Width = 95
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Security Code:'
  end
  object edSecCode: TIWEdit
    Left = 176
    Top = 451
    Width = 169
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edSecCode'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 6
    OnSubmit = edSecCodeSubmit
    PasswordPrompt = False
  end
  object ed30SecCode: TIWEdit
    Left = 176
    Top = 609
    Width = 169
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'ed30SecCode'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 10
    OnSubmit = ed30SecCodeSubmit
    PasswordPrompt = False
  end
  object edRelCode: TIWEdit
    Left = 176
    Top = 509
    Width = 169
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edRelCode'
    MaxLength = 0
    ReadOnly = True
    Required = False
    ScriptEvents = <>
    TabOrder = 18
    PasswordPrompt = False
  end
  object bnRelCode: TIWButton
    Left = 362
    Top = 479
    Width = 137
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Get Release Code'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 8
    OnClick = bnRelCodeClick
  end
  object ed30RelCode: TIWEdit
    Left = 176
    Top = 694
    Width = 169
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'ed30RelCode'
    MaxLength = 0
    ReadOnly = True
    Required = False
    ScriptEvents = <>
    TabOrder = 19
    PasswordPrompt = False
  end
  object bn30RelCode: TIWButton
    Left = 361
    Top = 663
    Width = 137
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Get Release Code'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 13
    OnClick = bn30RelCodeClick
  end
  object lblRelCode: TIWLabel
    Left = 24
    Top = 509
    Width = 100
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Release Code:'
  end
  object cbRelCodeType: TIWComboBox
    Left = 176
    Top = 482
    Width = 169
    Height = 21
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ItemsHaveValues = False
    NoSelectionText = ' '
    RequireSelection = True
    ScriptEvents = <>
    OnChange = cbRelCodeTypeChange
    UseSize = True
    DoSubmitValidation = True
    Editable = True
    TabOrder = 7
    ItemIndex = 0
    Items.Strings = (
      '30 Day')
    Sorted = False
  end
  object lblRelCodeType: TIWLabel
    Left = 24
    Top = 481
    Width = 138
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Release Code Type:'
  end
  object ed30UserCount: TIWEdit
    Left = 176
    Top = 665
    Width = 169
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'ed30UserCode'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 12
    OnSubmit = ed30UserCountSubmit
    PasswordPrompt = False
  end
  object lbl30UserCount: TIWLabel
    Left = 24
    Top = 665
    Width = 75
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'User Count:'
  end
  object lbl30RelCode: TIWLabel
    Left = 24
    Top = 693
    Width = 100
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Release Code:'
  end
  object lblhdrUserCount: TIWLabel
    Left = 16
    Top = 549
    Width = 83
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'User Count'
  end
  object cb30RelCodeType: TIWComboBox
    Left = 176
    Top = 638
    Width = 169
    Height = 21
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ItemsHaveValues = False
    NoSelectionText = ' '
    RequireSelection = True
    ScriptEvents = <>
    OnChange = cb30RelCodeTypeChange
    UseSize = True
    DoSubmitValidation = True
    Editable = True
    TabOrder = 11
    ItemIndex = 0
    Items.Strings = (
      '30 Day')
    Sorted = False
  end
  object lbl30RelCodeType: TIWLabel
    Left = 24
    Top = 637
    Width = 138
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Release Code Type:'
  end
  object cbPlugIn: TIWComboBox
    Left = 176
    Top = 422
    Width = 169
    Height = 21
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ItemsHaveValues = False
    NoSelectionText = ' '
    RequireSelection = True
    ScriptEvents = <>
    OnChange = cbPlugInChange
    UseSize = True
    DoSubmitValidation = True
    Editable = True
    TabOrder = 5
    ItemIndex = -1
    Items.Strings = (
      '30 Day'
      'Full Release')
    Sorted = True
  end
  object lblModule: TIWLabel
    Left = 24
    Top = 421
    Width = 48
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Plug-In:'
  end
  object cb30PlugIn: TIWComboBox
    Left = 176
    Top = 580
    Width = 169
    Height = 21
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ItemsHaveValues = False
    NoSelectionText = ' '
    RequireSelection = True
    ScriptEvents = <>
    OnChange = cb30PlugInChange
    UseSize = True
    DoSubmitValidation = True
    Editable = True
    TabOrder = 9
    ItemIndex = -1
    Items.Strings = (
      '30 Day'
      'Full Release')
    Sorted = True
  end
  object lbl30PlugIn: TIWLabel
    Left = 24
    Top = 580
    Width = 48
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Plug-In:'
  end
  object bnPlugIn: TIWButton
    Left = 362
    Top = 221
    Width = 137
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Get Password'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 1
    OnClick = bnPlugInClick
  end
  object bnDaily: TIWButton
    Left = 362
    Top = 271
    Width = 137
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Get Password'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 3
    OnClick = bnDailyClick
  end
  object bnDirectors: TIWButton
    Left = 362
    Top = 296
    Width = 137
    Height = 25
    Visible = False
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Get Password'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 4
    OnClick = bnDirectorsClick
  end
  object bnMCM: TIWButton
    Left = 362
    Top = 246
    Width = 137
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Get Password'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 2
    OnClick = bnMCMClick
  end
  object bnReturnMain: TIWButton
    Left = 362
    Top = 105
    Width = 137
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Return To Main'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 20
    OnClick = bnReturnMainClick
  end
  object capUserName: TIWLabel
    Left = 24
    Top = 136
    Width = 79
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'User Name:'
  end
  object lblUserName: TIWLabel
    Left = 176
    Top = 136
    Width = 95
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Mr User Name'
  end
  object img1: TIWImage
    Left = 16
    Top = 350
    Width = 100
    Height = 25
    ZIndex = 0
    DoSubmitValidation = True
    ScriptEvents = <>
    UseBorder = False
    UseSize = True
    JpegOptions.CompressionQuality = 90
    JpegOptions.Performance = jpBestSpeed
    JpegOptions.ProgressiveEncoding = False
    JpegOptions.Smoothing = True
  end
  object img2: TIWImage
    Left = 120
    Top = 350
    Width = 100
    Height = 25
    ZIndex = 0
    DoSubmitValidation = True
    ScriptEvents = <>
    UseBorder = False
    UseSize = True
    JpegOptions.CompressionQuality = 90
    JpegOptions.Performance = jpBestSpeed
    JpegOptions.ProgressiveEncoding = False
    JpegOptions.Smoothing = True
  end
  object img3: TIWImage
    Left = 224
    Top = 350
    Width = 100
    Height = 25
    ZIndex = 0
    DoSubmitValidation = True
    ScriptEvents = <>
    UseBorder = False
    UseSize = True
    JpegOptions.CompressionQuality = 90
    JpegOptions.Performance = jpBestSpeed
    JpegOptions.ProgressiveEncoding = False
    JpegOptions.Smoothing = True
  end
  object img4: TIWImage
    Left = 328
    Top = 350
    Width = 100
    Height = 25
    ZIndex = 0
    DoSubmitValidation = True
    ScriptEvents = <>
    UseBorder = False
    UseSize = True
    JpegOptions.CompressionQuality = 90
    JpegOptions.Performance = jpBestSpeed
    JpegOptions.ProgressiveEncoding = False
    JpegOptions.Smoothing = True
  end
  object img5: TIWImage
    Left = 432
    Top = 350
    Width = 100
    Height = 25
    ZIndex = 0
    DoSubmitValidation = True
    ScriptEvents = <>
    UseBorder = False
    UseSize = True
    JpegOptions.CompressionQuality = 90
    JpegOptions.Performance = jpBestSpeed
    JpegOptions.ProgressiveEncoding = False
    JpegOptions.Smoothing = True
  end
  object bnLogOut: TIWButton
    Left = 362
    Top = 55
    Width = 137
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Logout'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 21
    OnClick = bnLogOutClick
  end
  object TemplateProcessor: TIWTemplateProcessorHTML
    Enabled = True
    MasterFormTag = True
    TagType = ttIntraWeb
    Left = 100
    Top = 65
  end
end
