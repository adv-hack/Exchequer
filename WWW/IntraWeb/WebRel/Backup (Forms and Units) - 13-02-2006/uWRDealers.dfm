object frmDealers: TfrmDealers
  Left = 0
  Top = 0
  Width = 609
  Height = 278
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  OnCreate = IWAppFormCreate
  OnDestroy = IWAppFormDestroy
  DesignLeft = 286
  DesignTop = 154
  object cbDealership: TIWComboBox
    Left = 124
    Top = 140
    Width = 225
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
    Sorted = True
  end
  object lblEditDealer: TIWLabel
    Left = 24
    Top = 144
    Width = 77
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Edit Dealer:'
  end
  object bnNewDealer: TIWButton
    Left = 124
    Top = 170
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'New Dealer'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 1
    OnClick = bnNewDealerClick
  end
  object lblhdrDealers: TIWLabel
    Left = 20
    Top = 16
    Width = 60
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'Dealers'
  end
  object bnReturnAdmin: TIWButton
    Left = 124
    Top = 232
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
    Left = 240
    Top = 232
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
  object bnEditDealer: TIWButton
    Left = 240
    Top = 170
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Edit Dealer'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 4
    OnClick = bnEditDealerClick
  end
  object txtDealer: TIWText
    Left = 32
    Top = 44
    Width = 473
    Height = 57
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Lines.Strings = (
      'To create a new dealer, press the New Dealer button below. '
      
        'To edit a dealer, select the dealer from the drop-down list belo' +
        'w, and press the '
      'Edit Dealer button.')
    RawText = False
    UseFrame = False
    WantReturns = True
  end
  object bnFilterDealer: TIWButton
    Left = 410
    Top = 138
    Width = 55
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Filter'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 5
    OnClick = edFilterDealerSubmit
  end
  object edFilterDealer: TIWEdit
    Left = 356
    Top = 140
    Width = 32
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edDealerName'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 6
    OnSubmit = edFilterDealerSubmit
    PasswordPrompt = False
  end
  object cbContainsDealer: TIWCheckBox
    Left = 470
    Top = 140
    Width = 85
    Height = 21
    ZIndex = 0
    Caption = 'Contains'
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    DoSubmitValidation = True
    Style = stNormal
    TabOrder = 7
    Checked = False
  end
end
