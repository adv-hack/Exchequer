object frmExtMods: TfrmExtMods
  Left = 0
  Top = 0
  Width = 535
  Height = 713
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  TemplateProcessor = TemplateProcessor
  OnCreate = IWAppFormCreate
  DesignLeft = 300
  DesignTop = 0
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
    Left = 175
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
    Left = 175
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
    Left = 175
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
    Top = 248
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
    Left = 175
    Top = 160
    Width = 286
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
    Left = 175
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
  object lblPlugIn: TIWLabel
    Left = 24
    Top = 276
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
    Top = 302
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
    Top = 328
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
    Top = 354
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
  object bnPlugIn: TIWButton
    Left = 174
    Top = 273
    Width = 137
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Request Password'
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
    Left = 174
    Top = 323
    Width = 137
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Request Password'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 2
    OnClick = bnDailyClick
  end
  object bnDirectors: TIWButton
    Left = 174
    Top = 348
    Width = 137
    Height = 25
    Visible = False
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Request Password'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 3
    OnClick = bnDirectorsClick
  end
  object bnMCM: TIWButton
    Left = 174
    Top = 298
    Width = 137
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Request Password'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 4
    OnClick = bnMCMClick
  end
  object bnReturnMain: TIWButton
    Left = 174
    Top = 213
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
    TabOrder = 5
    OnClick = bnReturnMainClick
  end
  object lblSendVia: TIWLabel
    Left = 24
    Top = 188
    Width = 61
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Send via:'
  end
  object cbEmail: TIWCheckBox
    Left = 176
    Top = 188
    Width = 73
    Height = 21
    ZIndex = 0
    Caption = 'Email'
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    DoSubmitValidation = True
    OnClick = cbEmailClick
    Style = stNormal
    TabOrder = 6
    Checked = True
  end
  object cbSMS: TIWCheckBox
    Left = 324
    Top = 188
    Width = 65
    Height = 21
    ZIndex = 0
    Caption = 'SMS'
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    DoSubmitValidation = True
    OnClick = cbSMSClick
    Style = stNormal
    TabOrder = 7
    Checked = False
  end
  object img1: TIWImage
    Left = 16
    Top = 400
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
    Top = 400
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
    Top = 400
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
  object bnLogout: TIWButton
    Left = 326
    Top = 213
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
    TabOrder = 8
    OnClick = bnLogoutClick
  end
  object lblSecCode: TIWLabel
    Left = 24
    Top = 499
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
    Top = 633
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
    Top = 499
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
    TabOrder = 9
    OnSubmit = edSecCodeSubmit
    PasswordPrompt = False
  end
  object ed30SecCode: TIWEdit
    Left = 176
    Top = 633
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
  object bnRelCode: TIWButton
    Left = 360
    Top = 527
    Width = 137
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Request Code'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 11
    OnClick = bnRelCodeClick
  end
  object bn30RelCode: TIWButton
    Left = 360
    Top = 687
    Width = 137
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Request Code'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 12
    OnClick = bn30RelCodeClick
  end
  object cbRelCodeType: TIWComboBox
    Left = 176
    Top = 529
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
    TabOrder = 13
    ItemIndex = 0
    Items.Strings = (
      '30 Day')
    Sorted = False
  end
  object lblRelCodeType: TIWLabel
    Left = 24
    Top = 529
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
    Top = 689
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
    TabOrder = 14
    OnSubmit = ed30UserCountSubmit
    PasswordPrompt = False
  end
  object lbl30UserCount: TIWLabel
    Left = 24
    Top = 689
    Width = 75
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'User Count:'
  end
  object lblhdrSecurity: TIWLabel
    Left = 16
    Top = 441
    Width = 122
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    AutoSize = False
    Caption = 'Module Security'
  end
  object lblhdrUserCount: TIWLabel
    Left = 16
    Top = 573
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
    Top = 662
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
    TabOrder = 15
    ItemIndex = 0
    Items.Strings = (
      '30 Day')
    Sorted = False
  end
  object lbl30RelCodeType: TIWLabel
    Left = 24
    Top = 661
    Width = 138
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Release Code Type:'
  end
  object cbModule: TIWComboBox
    Left = 176
    Top = 469
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
    OnChange = cbModuleChange
    UseSize = True
    DoSubmitValidation = False
    Editable = True
    TabOrder = 16
    ItemIndex = -1
    Items.Strings = (
      '30 Day'
      'Full Release')
    Sorted = True
  end
  object lblModule: TIWLabel
    Left = 24
    Top = 469
    Width = 52
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Module:'
  end
  object cb30Module: TIWComboBox
    Left = 176
    Top = 604
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
    OnChange = cb30ModuleChange
    UseSize = True
    DoSubmitValidation = True
    Editable = True
    TabOrder = 17
    ItemIndex = -1
    Items.Strings = (
      '30 Day'
      'Full Release')
    Sorted = True
  end
  object lbl30Module: TIWLabel
    Left = 24
    Top = 604
    Width = 52
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Module:'
  end
  object capUserName: TIWLabel
    Left = 24
    Top = 136
    Width = 75
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'User Name'
  end
  object lblUserName: TIWLabel
    Left = 175
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
  object img4: TIWImage
    Left = 328
    Top = 400
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
    Top = 400
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
  object TemplateProcessor: TIWTemplateProcessorHTML
    Enabled = True
    MasterFormTag = True
    TagType = ttIntraWeb
    Left = 304
    Top = 32
  end
end
