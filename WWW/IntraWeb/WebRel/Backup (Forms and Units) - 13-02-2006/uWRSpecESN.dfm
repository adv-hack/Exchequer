object frmSpecESN: TfrmSpecESN
  Left = 0
  Top = 0
  Width = 413
  Height = 158
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  TemplateProcessor = TemplateProcessor
  DesignLeft = 287
  DesignTop = 153
  object txtESN: TIWText
    Left = 24
    Top = 44
    Width = 265
    Height = 21
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    RawText = False
    UseFrame = False
    WantReturns = True
  end
  object edESN: TIWEdit
    Left = 148
    Top = 76
    Width = 239
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edESN'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 0
    OnSubmit = bnSaveChangesClick
    PasswordPrompt = False
  end
  object lblESN: TIWLabel
    Left = 24
    Top = 80
    Width = 34
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'ESN:'
  end
  object lblNewESN: TIWLabel
    Left = 20
    Top = 16
    Width = 71
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'New ESN'
  end
  object bnSaveChanges: TIWButton
    Left = 148
    Top = 107
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
  object bnCancel: TIWButton
    Left = 264
    Top = 107
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Cancel'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 2
    OnClick = bnCancelClick
  end
  object TemplateProcessor: TIWTemplateProcessorHTML
    Enabled = True
    MasterFormTag = True
    TagType = ttIntraWeb
    Left = 304
    Top = 32
  end
end
