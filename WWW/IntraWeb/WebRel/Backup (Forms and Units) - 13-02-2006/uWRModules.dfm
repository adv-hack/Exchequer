object frmModules: TfrmModules
  Left = 0
  Top = 0
  Width = 406
  Height = 385
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  DesignLeft = 287
  DesignTop = 153
  object edModuleName: TIWEdit
    Left = 148
    Top = 160
    Width = 238
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edModuleName'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 0
    PasswordPrompt = False
  end
  object lblModuleName: TIWLabel
    Left = 24
    Top = 164
    Width = 44
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Name:'
  end
  object bnSaveChanges: TIWButton
    Left = 264
    Top = 280
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Save Changes'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 1
    OnClick = bnSaveChangesClick
  end
  object lblhdrModules: TIWLabel
    Left = 20
    Top = 16
    Width = 140
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'Modules / Plug-Ins'
  end
  object txtModules: TIWText
    Left = 24
    Top = 48
    Width = 369
    Height = 109
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Lines.Strings = (
      'To register a new module, enter the name below, check the '
      'user count security checkbox if necessary and press the Save '
      'Changes button.'
      ''
      'To register a plug-in proceed as above with the Plug-In box '
      'checked.')
    RawText = False
    UseFrame = False
    WantReturns = True
  end
  object bnReturnAdmin: TIWButton
    Left = 148
    Top = 336
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
    TabOrder = 2
    OnClick = bnReturnAdminClick
  end
  object bnReturnMain: TIWButton
    Left = 264
    Top = 336
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
    TabOrder = 3
    OnClick = bnReturnMainClick
  end
  object cbPlugIn: TIWCheckBox
    Left = 148
    Top = 216
    Width = 121
    Height = 21
    ZIndex = 0
    Caption = 'Plug-In'
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    DoSubmitValidation = True
    OnClick = cbPlugInClick
    Style = stNormal
    TabOrder = 4
    Checked = False
  end
  object cbUserCount: TIWCheckBox
    Left = 148
    Top = 192
    Width = 153
    Height = 21
    ZIndex = 0
    Caption = 'User Count Security'
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    DoSubmitValidation = True
    Style = stNormal
    TabOrder = 5
    Checked = False
  end
  object edPlugCode: TIWEdit
    Left = 148
    Top = 248
    Width = 238
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edModuleName'
    MaxLength = 0
    ReadOnly = True
    Required = False
    ScriptEvents = <>
    TabOrder = 6
    PasswordPrompt = False
  end
  object txtPlugIns: TIWText
    Left = 24
    Top = 248
    Width = 117
    Height = 41
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Lines.Strings = (
      'Plug-In Code:'
      '(Plug-Ins only)')
    RawText = False
    UseFrame = False
    WantReturns = True
  end
end
