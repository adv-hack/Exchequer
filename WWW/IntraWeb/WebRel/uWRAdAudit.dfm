object frmAdminAudit: TfrmAdminAudit
  Left = 0
  Top = 0
  Width = 511
  Height = 294
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  OnCreate = IWAppFormCreate
  DesignLeft = 287
  DesignTop = 153
  object bnReturnMain: TIWButton
    Left = 368
    Top = 173
    Width = 126
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
    TabOrder = 0
    OnClick = bnReturnMainClick
  end
  object bnReturnAdmin: TIWButton
    Left = 368
    Top = 141
    Width = 126
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
    TabOrder = 2
    ItemIndex = -1
    Sorted = True
  end
  object cbAuditType: TIWComboBox
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
    OnChange = cbAuditTypeChange
    UseSize = True
    DoSubmitValidation = True
    Editable = True
    TabOrder = 3
    ItemIndex = -1
    Items.Strings = (
      'Dealers'
      'Users'
      'Customers'
      'ESNs'
      'Modules'
      'Thresholds'
      'Logins')
    Sorted = False
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
    TabOrder = 4
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
    TabOrder = 5
    PasswordPrompt = False
  end
  object bnRetrieve: TIWButton
    Left = 150
    Top = 205
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
    TabOrder = 6
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
  object lblAuditType: TIWLabel
    Left = 23
    Top = 115
    Width = 74
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Audit Type:'
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
    Top = 244
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
    Left = 368
    Top = 205
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
    TabOrder = 7
    OnClick = bnPreviousClick
  end
  object bnNext: TIWButton
    Left = 434
    Top = 205
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
    TabOrder = 8
    OnClick = bnNextClick
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
  object lblDescription: TIWLabel
    Left = 23
    Top = 178
    Width = 74
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Description'
  end
  object edDescSubstr: TIWEdit
    Left = 149
    Top = 174
    Width = 208
    Height = 21
    ZIndex = 0
    BGColor = clNone
    DoSubmitValidation = True
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'edDescSubstr'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    TabOrder = 9
    PasswordPrompt = False
  end
  object cbChanged: TIWComboBox
    Left = 149
    Top = 144
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
    TabOrder = 10
    ItemIndex = -1
    Sorted = True
  end
  object lblChanged: TIWLabel
    Left = 23
    Top = 146
    Width = 102
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Entity Changed:'
  end
  object cbSortAsc: TIWCheckBox
    Left = 368
    Top = 88
    Width = 121
    Height = 21
    ZIndex = 0
    Caption = 'Sort Ascending'
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    DoSubmitValidation = True
    Style = stNormal
    TabOrder = 11
    Checked = False
  end
  object cbRetrieveAll: TIWCheckBox
    Left = 368
    Top = 112
    Width = 97
    Height = 21
    ZIndex = 0
    Caption = 'Retrieve All'
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    DoSubmitValidation = True
    Style = stNormal
    TabOrder = 12
    Checked = False
  end
end
