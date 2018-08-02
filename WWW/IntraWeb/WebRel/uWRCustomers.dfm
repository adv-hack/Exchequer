object frmCustomers: TfrmCustomers
  Left = 0
  Top = 0
  Width = 608
  Height = 280
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  OnCreate = IWAppFormCreate
  OnDestroy = IWAppFormDestroy
  DesignLeft = 291
  DesignTop = 153
  object lblhdrCustomers: TIWLabel
    Left = 20
    Top = 16
    Width = 80
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'Customers'
  end
  object cbCustomer: TIWComboBox
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
  object lblEditCustomer: TIWLabel
    Left = 24
    Top = 144
    Width = 94
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Edit Customer:'
  end
  object bnNewCustomer: TIWButton
    Left = 124
    Top = 170
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'New Customer'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 1
    OnClick = bnNewCustomerClick
  end
  object bnReturnAdmin: TIWButton
    Left = 124
    Top = 224
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
    Top = 224
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
  object bnEditCustomer: TIWButton
    Left = 240
    Top = 170
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Edit Customer'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 4
    OnClick = bnEditCustomerClick
  end
  object txtCustomer: TIWText
    Left = 32
    Top = 44
    Width = 453
    Height = 57
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Lines.Strings = (
      'To create a new customer, press the New Customer button below. '
      
        'To edit a customer, select the customer from the drop-down list ' +
        'below, '
      'and press the Edit Customer button.')
    RawText = False
    UseFrame = False
    WantReturns = True
  end
  object bnFilterCust: TIWButton
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
    OnClick = edFilterCustSubmit
  end
  object edFilterCust: TIWEdit
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
    OnSubmit = edFilterCustSubmit
    PasswordPrompt = False
  end
  object cbContainsCust: TIWCheckBox
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
  object bnDelCustomer: TIWButton
    Left = 360
    Top = 170
    Width = 109
    Height = 25
    Visible = False
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Delete Customer'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 8
    OnClick = bnDelCustomerClick
  end
end
