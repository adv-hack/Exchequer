object frmSecAudit: TfrmSecAudit
  Left = 0
  Top = 0
  Width = 511
  Height = 675
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  OnCreate = IWAppFormCreate
  DesignLeft = 287
  DesignTop = 153
  object cbUserCode: TIWComboBox
    Left = 149
    Top = 82
    Width = 199
    Height = 21
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ItemsHaveValues = False
    NoSelectionText = '-- No Selection --'
    RequireSelection = False
    ScriptEvents = <>
    UseSize = True
    DoSubmitValidation = True
    Editable = True
    TabOrder = 0
    ItemIndex = -1
    Sorted = True
  end
  object cbDealership: TIWComboBox
    Left = 149
    Top = 112
    Width = 199
    Height = 21
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ItemsHaveValues = False
    NoSelectionText = '-- No Selection --'
    RequireSelection = False
    ScriptEvents = <>
    OnChange = cbDealershipChange
    UseSize = True
    DoSubmitValidation = True
    Editable = True
    TabOrder = 1
    ItemIndex = -1
    Sorted = True
  end
  object cbCustomer: TIWComboBox
    Left = 149
    Top = 142
    Width = 199
    Height = 21
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ItemsHaveValues = False
    NoSelectionText = '-- No Selection --'
    RequireSelection = False
    ScriptEvents = <>
    OnChange = cbCustomerChange
    UseSize = True
    DoSubmitValidation = True
    Editable = True
    TabOrder = 2
    ItemIndex = -1
    Sorted = True
  end
  object cbESN: TIWComboBox
    Left = 149
    Top = 172
    Width = 199
    Height = 21
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ItemsHaveValues = False
    NoSelectionText = '-- No Selection --'
    RequireSelection = False
    ScriptEvents = <>
    OnChange = cbESNChange
    UseSize = True
    DoSubmitValidation = True
    Editable = True
    TabOrder = 3
    ItemIndex = -1
    Sorted = True
  end
  object cbRelCode: TIWComboBox
    Left = 149
    Top = 203
    Width = 334
    Height = 21
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ItemsHaveValues = False
    NoSelectionText = '-- No Selection --'
    RequireSelection = False
    ScriptEvents = <>
    UseSize = True
    DoSubmitValidation = True
    Editable = True
    TabOrder = 4
    ItemIndex = -1
    Sorted = True
  end
  object edDateFrom: TIWEdit
    Left = 149
    Top = 51
    Width = 84
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWEdit1'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 5
    PasswordPrompt = False
  end
  object edDateTo: TIWEdit
    Left = 253
    Top = 51
    Width = 84
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWEdit2'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 6
    PasswordPrompt = False
  end
  object bnRetrieve: TIWButton
    Left = 150
    Top = 237
    Width = 120
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Retrieve Records'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 7
    OnClick = bnRetrieveClick
  end
  object lblUserCode: TIWLabel
    Left = 23
    Top = 84
    Width = 74
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'User Code:'
  end
  object lblDealership: TIWLabel
    Left = 23
    Top = 115
    Width = 75
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Dealership:'
  end
  object lblCustomer: TIWLabel
    Left = 23
    Top = 144
    Width = 66
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Customer:'
  end
  object lblESN: TIWLabel
    Left = 23
    Top = 175
    Width = 34
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'ESN:'
  end
  object lblRelCode: TIWLabel
    Left = 23
    Top = 206
    Width = 100
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Release Code:'
  end
  object lblDate: TIWLabel
    Left = 23
    Top = 55
    Width = 78
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Timestamp:'
  end
  object lblFrom: TIWLabel
    Left = 212
    Top = 31
    Width = 34
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'From'
  end
  object lblTo: TIWLabel
    Left = 331
    Top = 30
    Width = 18
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'To'
  end
  object dbgAudit: TIWDBGrid
    Left = 24
    Top = 620
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
    Columns = <>
    DataSource = WRData.dsAudit
    FooterRowCount = 0
    FromStart = True
    HighlightColor = clNone
    HighlightRows = False
    Options = [dgShowTitles]
    RefreshMode = rmAutomatic
    RowLimit = 0
    RollOver = False
    RowClick = False
    RollOverColor = clNone
    RowHeaderColor = clNone
    RowAlternateColor = clMoneyGreen
    RowCurrentColor = clNone
  end
  object bnPrevious: TIWButton
    Left = 360
    Top = 237
    Width = 60
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Previous'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 8
    OnClick = bnPreviousClick
  end
  object bnNext: TIWButton
    Left = 424
    Top = 237
    Width = 60
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Next'
    Color = clBtnFace
    DoSubmitValidation = True
    Enabled = False
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 9
    OnClick = bnNextClick
  end
  object lbOrderFrom: TIWListbox
    Left = 32
    Top = 380
    Width = 153
    Height = 221
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
    TabOrder = 10
    ItemIndex = 0
    Items.Strings = (
      'Asc Timestamp'
      'Asc User Code'
      'Asc Dealership'
      'Asc Customer'
      'Asc ESN'
      'Asc Release Code'
      'Desc Timestamp'
      'Desc User Code'
      'Desc Dealership'
      'Desc Customer'
      'Desc ESN'
      'Desc Release Code')
    MultiSelect = False
    Sorted = False
  end
  object lbOrderTo: TIWListbox
    Left = 268
    Top = 380
    Width = 153
    Height = 221
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
    TabOrder = 11
    ItemIndex = 0
    Items.Strings = (
      'Desc Timestamp')
    MultiSelect = False
    Sorted = False
  end
  object bnAdd: TIWButton
    Left = 196
    Top = 389
    Width = 61
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = '>'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 12
    OnClick = bnAddClick
  end
  object bnRemove: TIWButton
    Left = 196
    Top = 569
    Width = 61
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = '<'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 13
    OnClick = bnRemoveClick
  end
  object lblSorts: TIWLabel
    Left = 16
    Top = 282
    Width = 39
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'Sorts'
  end
  object lblFilters: TIWLabel
    Left = 16
    Top = 20
    Width = 47
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'Filters'
  end
  object txtSorts: TIWText
    Left = 20
    Top = 308
    Width = 437
    Height = 53
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Lines.Strings = (
      
        'NOTE: Sorting by fields other than timestamp will result in ALL ' +
        'records '
      
        'being retrieved in one hit. Be sure appropriate filters have bee' +
        'n selected '
      'to restrict the resultset before retrieving the records.')
    RawText = False
    UseFrame = False
    WantReturns = True
  end
  object bnReturnMain: TIWButton
    Left = 364
    Top = 170
    Width = 120
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
    TabOrder = 14
    OnClick = bnReturnMainClick
  end
  object bnReturnAdmin: TIWButton
    Left = 364
    Top = 140
    Width = 120
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
    TabOrder = 15
    OnClick = bnReturnAdminClick
  end
end
