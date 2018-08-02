object frmInstructions: TfrmInstructions
  Left = 0
  Top = 0
  Width = 209
  Height = 103
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  TemplateProcessor = IWTemplateProcessor
  DesignLeft = 286
  DesignTop = 154
  object bnInstrx: TIWButton
    Left = 47
    Top = 56
    Width = 120
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Return'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 0
    OnClick = bnInstrxClick
  end
  object IWTemplateProcessor: TIWTemplateProcessorHTML
    Enabled = True
    MasterFormTag = True
    TagType = ttIntraWeb
    Left = 16
    Top = 16
  end
end
