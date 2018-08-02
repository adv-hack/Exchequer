object frmExtTkit: TfrmExtTkit
  Left = 0
  Top = 0
  Width = 543
  Height = 634
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  TemplateProcessor = TemplateProcessor
  OnCreate = IWAppFormCreate
  DesignLeft = 291
  DesignTop = -8
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
    TabOrder = 3
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
    TabOrder = 5
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
    TabOrder = 6
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
    TabOrder = 12
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
    TabOrder = 1
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
    TabOrder = 2
    Checked = False
  end
  object lblSecCode: TIWLabel
    Left = 24
    Top = 475
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
    Top = 475
    Width = 132
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
    TabOrder = 7
    OnSubmit = bnRelCodeClick
    PasswordPrompt = False
  end
  object bnRelCode: TIWButton
    Left = 326
    Top = 472
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
    TabOrder = 8
    OnClick = bnRelCodeClick
  end
  object lblhdrToolkit: TIWLabel
    Left = 16
    Top = 443
    Width = 111
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = '30-Day Toolkit'
  end
  object lbl30SecCode: TIWLabel
    Left = 24
    Top = 555
    Width = 95
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Security Code:'
  end
  object ed30SecCode: TIWEdit
    Left = 176
    Top = 555
    Width = 132
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
    TabOrder = 9
    OnSubmit = ed30SecCodeSubmit
    PasswordPrompt = False
  end
  object bn30RelCode: TIWButton
    Left = 326
    Top = 584
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
    OnClick = bn30RelCodeClick
  end
  object ed30UserCount: TIWEdit
    Left = 176
    Top = 586
    Width = 132
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
    TabOrder = 10
    OnSubmit = bn30RelCodeClick
    PasswordPrompt = False
  end
  object lbl30UserCount: TIWLabel
    Left = 24
    Top = 586
    Width = 75
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'User Count:'
  end
  object lblhdr30UserCount: TIWLabel
    Left = 16
    Top = 523
    Width = 199
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = '30-Day Toolkit User Count'
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
    TabOrder = 13
    OnClick = bnLogoutClick
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
