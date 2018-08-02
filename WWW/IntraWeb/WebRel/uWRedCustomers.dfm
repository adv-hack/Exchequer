object frmedCustomers: TfrmedCustomers
  Left = 0
  Top = 0
  Width = 607
  Height = 746
  VertScrollBar.Position = 82
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  OnCreate = IWAppFormCreate
  DesignLeft = 263
  DesignTop = 6
  object lblCustomer: TIWLabel
    Left = 24
    Top = -30
    Width = 110
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Customer Name:'
  end
  object lblParent: TIWLabel
    Left = 24
    Top = -2
    Width = 46
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Parent:'
  end
  object bnSaveChanges: TIWButton
    Left = 148
    Top = 284
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
    TabOrder = 0
    OnClick = bnSaveChangesClick
  end
  object bnReturnAdmin: TIWButton
    Left = 148
    Top = 325
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
    TabOrder = 1
    OnClick = bnReturnAdminClick
  end
  object bnReturnMain: TIWButton
    Left = 264
    Top = 325
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
    TabOrder = 2
    OnClick = bnReturnMainClick
  end
  object lblhdrCustomers: TIWLabel
    Left = 20
    Top = -66
    Width = 80
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'Customers'
  end
  object bnCancel: TIWButton
    Left = 264
    Top = 284
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
    TabOrder = 3
    OnClick = bnCancelClick
  end
  object cbParent: TIWComboBox
    Left = 144
    Top = -6
    Width = 226
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
    TabOrder = 4
    ItemIndex = -1
    Sorted = True
  end
  object edCustomer: TIWEdit
    Left = 144
    Top = -34
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
    FriendlyName = 'edCustomer'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 5
    PasswordPrompt = False
  end
  object memoCustomer: TIWMemo
    Left = 25
    Top = 119
    Width = 288
    Height = 150
    ZIndex = 0
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    RawText = False
    ReadOnly = False
    Required = False
    TabOrder = 6
    WantReturns = False
    FriendlyName = 'IWMemo1'
  end
  object lblCustNotes: TIWLabel
    Left = 24
    Top = 99
    Width = 108
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Customer Notes:'
  end
  object lblEditESN: TIWLabel
    Left = 24
    Top = 470
    Width = 62
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Edit ESN:'
  end
  object bnNewESN: TIWButton
    Left = 148
    Top = 568
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'New ESN'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 7
    OnClick = bnNewESNClick
  end
  object bnEditESN: TIWButton
    Left = 264
    Top = 568
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Edit ESN'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 8
    OnClick = bnEditESNClick
  end
  object txtESN: TIWText
    Left = 32
    Top = 394
    Width = 409
    Height = 57
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Lines.Strings = (
      'To create a new ESN for this customer, press the New ESN button '
      
        'below. To edit a customer ESN, select the ESN from the list belo' +
        'w, '
      'and press the Edit ESN button.')
    RawText = False
    UseFrame = False
    WantReturns = True
  end
  object lblCustESNs: TIWLabel
    Left = 20
    Top = 366
    Width = 118
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'Customer ESNs'
  end
  object lbESN: TIWListbox
    Left = 148
    Top = 470
    Width = 225
    Height = 89
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
    TabOrder = 9
    ItemIndex = -1
    MultiSelect = False
    Sorted = True
  end
  object lblActive: TIWLabel
    Left = 384
    Top = 470
    Width = 49
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = '* Active'
  end
  object cbRestrict30: TIWCheckBox
    Left = 148
    Top = 51
    Width = 181
    Height = 21
    ZIndex = 0
    Caption = 'Restrict to 30-day codes'
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    DoSubmitValidation = True
    Style = stNormal
    TabOrder = 10
    Checked = False
  end
  object cbActive: TIWCheckBox
    Left = 148
    Top = 75
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
    TabOrder = 11
    Checked = True
  end
  object gdThresholds: TIWGrid
    Left = 24
    Top = 743
    Width = 77
    Height = 33
    ZIndex = 0
    BorderColors.Color = clNone
    BorderColors.Light = clNone
    BorderColors.Dark = clNone
    BGColor = clSkyBlue
    BorderSize = 1
    BorderStyle = tfDefault
    CellPadding = 2
    CellSpacing = 2
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FrameBuffer = 40
    Lines = tlAll
    UseFrame = False
    UseWidth = False
    ColumnCount = 2
    RowCount = 1
  end
  object lblThresholds: TIWLabel
    Left = 20
    Top = 614
    Width = 85
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'Thresholds'
  end
  object bnThresholds: TIWButton
    Left = 32
    Top = 704
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Thresholds'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 12
    OnClick = bnThresholdsClick
  end
  object txtThresholds: TIWText
    Left = 32
    Top = 642
    Width = 409
    Height = 57
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Lines.Strings = (
      
        'Listed below are the threshold overrides for the current custome' +
        'r. To'
      
        'override additional global thresholds, remove overrides or chang' +
        'e'
      'override thresholds, click the Thresholds button below.')
    RawText = False
    UseFrame = False
    WantReturns = True
  end
  object lblNoOverrides: TIWLabel
    Left = 32
    Top = 742
    Width = 382
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'There are no threshold overrides for this customer.'
  end
  object bnFilterCust: TIWButton
    Left = 430
    Top = -8
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
    TabOrder = 13
    OnClick = edFilterCustSubmit
  end
  object edFilterCust: TIWEdit
    Left = 376
    Top = -6
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
    TabOrder = 14
    OnSubmit = edFilterCustSubmit
    PasswordPrompt = False
  end
  object cbContainsCust: TIWCheckBox
    Left = 490
    Top = -4
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
    TabOrder = 15
    Checked = False
  end
  object lblCustomerCode: TIWLabel
    Left = 24
    Top = 26
    Width = 105
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Customer Code:'
  end
  object edCustomerCode: TIWEdit
    Left = 144
    Top = 22
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
    FriendlyName = 'edCustomerCode'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 16
    PasswordPrompt = False
  end
end
