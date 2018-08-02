object frmIntNone: TfrmIntNone
  Left = 0
  Top = 0
  Width = 657
  Height = 356
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  TemplateProcessor = TemplateProcessor
  OnCreate = IWAppFormCreate
  DesignLeft = 278
  DesignTop = 154
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
    Left = 175
    Top = 160
    Width = 326
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
  object edPlugIn: TIWEdit
    Left = 175
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
    TabOrder = 5
    PasswordPrompt = False
  end
  object edMCM: TIWEdit
    Left = 175
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
    TabOrder = 6
    PasswordPrompt = False
  end
  object edDaily: TIWEdit
    Left = 175
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
    TabOrder = 7
    PasswordPrompt = False
  end
  object edDirectors: TIWEdit
    Left = 175
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
    TabOrder = 8
    PasswordPrompt = False
  end
  object lblPlugIn: TIWLabel
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
    TabOrder = 9
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
    TabOrder = 10
    OnClick = bnLogOutClick
  end
  object lblMCMLast: TIWLabel
    Left = 506
    Top = 250
    Width = 0
    Height = 0
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
  end
  object lbldailyLast: TIWLabel
    Left = 506
    Top = 275
    Width = 0
    Height = 0
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
  end
  object TemplateProcessor: TIWTemplateProcessorHTML
    Enabled = True
    MasterFormTag = True
    TagType = ttIntraWeb
    Left = 115
    Top = 50
  end
end
