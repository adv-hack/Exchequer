object frmEmail: TfrmEmail
  Left = 0
  Top = 0
  Width = 694
  Height = 402
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  OnCreate = IWAppFormCreate
  DesignLeft = 245
  DesignTop = 159
  object bnReturnAdmin: TIWButton
    Left = 356
    Top = 342
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Return to Admin'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 0
    OnClick = bnReturnAdminClick
  end
  object bnReturnMain: TIWButton
    Left = 476
    Top = 342
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Return to Main'
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
  object lblThresholdApplied: TIWLabel
    Left = 16
    Top = 228
    Width = 125
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Threshold Applied:'
  end
  object edToApplied: TIWEdit
    Left = 164
    Top = 224
    Width = 189
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edToApplied'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 2
    PasswordPrompt = False
  end
  object lblThresholdOverridden: TIWLabel
    Left = 16
    Top = 260
    Width = 147
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Threshold Overridden:'
  end
  object edToOverridden: TIWEdit
    Left = 164
    Top = 256
    Width = 189
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edToOverridden'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 3
    PasswordPrompt = False
  end
  object lblhdrEmail: TIWLabel
    Left = 20
    Top = 16
    Width = 128
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'Email Recipients'
  end
  object lblCodeRequests: TIWLabel
    Left = 16
    Top = 164
    Width = 106
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Code Requests:'
  end
  object edToRequest: TIWEdit
    Left = 164
    Top = 160
    Width = 189
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edThreshold'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 4
    PasswordPrompt = False
  end
  object lblCodeUnavailable: TIWLabel
    Left = 16
    Top = 196
    Width = 123
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Code Unavailable:'
  end
  object edToUnavailable: TIWEdit
    Left = 164
    Top = 192
    Width = 189
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edPeriod'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 5
    PasswordPrompt = False
  end
  object txtEmail: TIWText
    Left = 27
    Top = 44
    Width = 614
    Height = 69
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Lines.Strings = (
      
        'To change an email recipient, edit the fields below and press th' +
        'e Save All button. '
      ''
      
        'To stop internal notification emails from being sent, uncheck th' +
        'e Active checkbox to the right of the '
      'email details and press the Save All button.')
    RawText = False
    UseFrame = False
    WantReturns = True
  end
  object cbCUActive: TIWCheckBox
    Left = 588
    Top = 194
    Width = 77
    Height = 21
    ZIndex = 0
    Caption = 'Active'
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    DoSubmitValidation = True
    Style = stNormal
    TabOrder = 6
    Checked = True
  end
  object cbTAActive: TIWCheckBox
    Left = 588
    Top = 226
    Width = 77
    Height = 21
    ZIndex = 0
    Caption = 'Active'
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    DoSubmitValidation = True
    Style = stNormal
    TabOrder = 7
    Checked = True
  end
  object cbTOActive: TIWCheckBox
    Left = 588
    Top = 258
    Width = 77
    Height = 21
    ZIndex = 0
    Caption = 'Active'
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    DoSubmitValidation = True
    Style = stNormal
    TabOrder = 8
    Checked = True
  end
  object bnSaveAll: TIWButton
    Left = 236
    Top = 342
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Save All'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 9
    OnClick = bnSaveAllClick
  end
  object edEmailApplied: TIWEdit
    Left = 356
    Top = 224
    Width = 242
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edThreshold'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 10
    PasswordPrompt = False
  end
  object edEmailOverridden: TIWEdit
    Left = 356
    Top = 256
    Width = 242
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edPeriod'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 11
    PasswordPrompt = False
  end
  object edEmailRequest: TIWEdit
    Left = 356
    Top = 160
    Width = 242
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edThreshold'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 12
    PasswordPrompt = False
  end
  object edEmailUnavailable: TIWEdit
    Left = 356
    Top = 192
    Width = 242
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edPeriod'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 13
    PasswordPrompt = False
  end
  object lblTo: TIWLabel
    Left = 168
    Top = 132
    Width = 22
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'To:'
  end
  object lblEmailAddress: TIWLabel
    Left = 360
    Top = 132
    Width = 100
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Email Address:'
  end
  object lblESNSpecified: TIWLabel
    Left = 16
    Top = 292
    Width = 96
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'ESN Specified'
  end
  object edToESNSpecified: TIWEdit
    Left = 164
    Top = 288
    Width = 189
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edToESNSpecified'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 14
    PasswordPrompt = False
  end
  object edEmailESNSpecified: TIWEdit
    Left = 356
    Top = 288
    Width = 242
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edEmailESNSpecified'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 15
    PasswordPrompt = False
  end
  object cbESNActive: TIWCheckBox
    Left = 588
    Top = 290
    Width = 77
    Height = 21
    ZIndex = 0
    Caption = 'Active'
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    DoSubmitValidation = True
    Style = stNormal
    TabOrder = 16
    Checked = True
  end
end
