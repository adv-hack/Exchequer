object frmExtPlugs: TfrmExtPlugs
  Left = 0
  Top = 0
  Width = 549
  Height = 708
  VertScrollBar.Position = 25
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  TemplateProcessor = TemplateProcessor
  OnCreate = IWAppFormCreate
  DesignLeft = 339
  DesignTop = 3
  object capDealership: TIWLabel
    Left = 24
    Top = 15
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
    Top = 15
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
    Top = 39
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
    Top = 39
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
    Top = 63
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
    Top = 63
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
    Top = 87
    Width = 53
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Version:'
  end
  object cbDate: TIWComboBox
    Left = 175
    Top = 135
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
    UseSize = True
    DoSubmitValidation = True
    Editable = True
    TabOrder = 0
    ItemIndex = -1
    Sorted = False
  end
  object lblVersion: TIWLabel
    Left = 175
    Top = 87
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
    Top = 135
    Width = 91
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Security Date:'
  end
  object bnReturnMain: TIWButton
    Left = 174
    Top = 188
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
    TabOrder = 1
    OnClick = bnReturnMainClick
  end
  object lblSendVia: TIWLabel
    Left = 24
    Top = 163
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
    Top = 163
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
    Style = stNormal
    TabOrder = 2
    Checked = True
  end
  object cbSMS: TIWCheckBox
    Left = 324
    Top = 163
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
    Style = stNormal
    TabOrder = 3
    Checked = False
  end
  object bnLogout: TIWButton
    Left = 326
    Top = 188
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
    TabOrder = 4
    OnClick = bnLogoutClick
  end
  object capUserName: TIWLabel
    Left = 24
    Top = 111
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
    Top = 111
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
    Top = 375
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
    Top = 375
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
    Top = 375
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
  object lblhdrPasswords: TIWLabel
    Left = 16
    Top = 223
    Width = 83
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'Passwords'
  end
  object lblPlugIn: TIWLabel
    Left = 24
    Top = 251
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
    Top = 277
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
    Top = 303
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
    Top = 329
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
    Top = 248
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
    TabOrder = 5
    OnClick = bnPlugInClick
  end
  object bnDaily: TIWButton
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
    TabOrder = 6
    OnClick = bnDailyClick
  end
  object bnDirectors: TIWButton
    Left = 174
    Top = 323
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
    TabOrder = 7
    OnClick = bnDirectorsClick
  end
  object bnMCM: TIWButton
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
    TabOrder = 8
    OnClick = bnMCMClick
  end
  object img4: TIWImage
    Left = 328
    Top = 375
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
    Top = 375
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
  object lblhdrSecurity: TIWLabel
    Left = 16
    Top = 413
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
    Top = 471
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
    Top = 629
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
    Top = 471
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
    PasswordPrompt = False
  end
  object ed30SecCode: TIWEdit
    Left = 176
    Top = 629
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
    PasswordPrompt = False
  end
  object bnRelCode: TIWButton
    Left = 362
    Top = 499
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
    TabOrder = 11
    OnClick = bnRelCodeClick
  end
  object bn30RelCode: TIWButton
    Left = 361
    Top = 683
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
    TabOrder = 12
    OnClick = bn30RelCodeClick
  end
  object cbRelCodeType: TIWComboBox
    Left = 176
    Top = 502
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
    Top = 501
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
    Top = 685
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
    PasswordPrompt = False
  end
  object lbl30UserCount: TIWLabel
    Left = 24
    Top = 685
    Width = 75
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'User Count:'
  end
  object lblhdrUserCount: TIWLabel
    Left = 16
    Top = 569
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
    Top = 658
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
    Top = 657
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
    Top = 442
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
    UseSize = True
    DoSubmitValidation = True
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
    Top = 441
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
    Top = 600
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
  object lbl30PlugIn: TIWLabel
    Left = 24
    Top = 600
    Width = 44
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'PlugIn:'
  end
  object TemplateProcessor: TIWTemplateProcessorHTML
    Enabled = True
    MasterFormTag = True
    TagType = ttIntraWeb
    Left = 304
    Top = 32
  end
end
