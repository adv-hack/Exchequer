object frmThresholds: TfrmThresholds
  Left = 0
  Top = 0
  Width = 476
  Height = 447
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  OnCreate = IWAppFormCreate
  DesignLeft = 287
  DesignTop = 153
  object bnReturnCust: TIWButton
    Left = 268
    Top = 342
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Return to Cust'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 4
    OnClick = bnReturnCustClick
  end
  object lblhdrThresholds: TIWLabel
    Left = 20
    Top = 16
    Width = 85
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'Thresholds'
  end
  object bnNew: TIWButton
    Left = 268
    Top = 342
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'New'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 0
    OnClick = bnNewClick
  end
  object bnReturnAdmin: TIWButton
    Left = 28
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
    TabOrder = 1
    OnClick = bnReturnAdminClick
  end
  object bnReturnMain: TIWButton
    Left = 148
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
    TabOrder = 2
    OnClick = bnReturnMainClick
  end
  object bnSave: TIWButton
    Left = 268
    Top = 238
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Save'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 3
    OnClick = bnSaveClick
  end
  object txtThreshold: TIWText
    Left = 25
    Top = 44
    Width = 440
    Height = 157
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Lines.Strings = (
      
        'To edit a threshold, select the threshold from the grid below, c' +
        'hange the '
      
        'threshold and period values in the edit boxes and click the Save' +
        ' button.'
      ''
      
        'To add a new threshold, enter threshold and period values in the' +
        ' edit '
      
        'boxes below, select the release code the threshold applies to, a' +
        'nd click '
      'the New button. '
      ''
      
        'To remove a threshold, select the threshold from the grid below,' +
        ' and '
      'click the Delete button.')
    RawText = False
    UseFrame = False
    WantReturns = True
  end
  object gdThresholds: TIWGrid
    Left = 24
    Top = 388
    Width = 77
    Height = 33
    Visible = False
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
    ColumnCount = 3
    OnCellClick = gdThresholdsCellClick
    RowCount = 1
  end
  object lblThreshold: TIWLabel
    Left = 24
    Top = 244
    Width = 70
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Threshold:'
  end
  object lblReleaseCodes: TIWLabel
    Left = 24
    Top = 312
    Width = 107
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Release Codes:'
  end
  object cbRelCode: TIWComboBox
    Left = 148
    Top = 308
    Width = 229
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
    TabOrder = 5
    ItemIndex = -1
    Sorted = True
  end
  object edThreshold: TIWEdit
    Left = 148
    Top = 240
    Width = 109
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
    TabOrder = 6
    PasswordPrompt = False
  end
  object lblPeriod: TIWLabel
    Left = 24
    Top = 276
    Width = 47
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Period:'
  end
  object edPeriod: TIWEdit
    Left = 148
    Top = 272
    Width = 109
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
    TabOrder = 7
    PasswordPrompt = False
  end
  object bnDelete: TIWButton
    Left = 268
    Top = 270
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Delete'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 8
    OnClick = bnDeleteClick
  end
  object lblhdrCurrent: TIWLabel
    Left = 24
    Top = 212
    Width = 114
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Current Selection:'
  end
  object lblCurrent: TIWLabel
    Left = 148
    Top = 212
    Width = 40
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'None'
  end
  object lblNoThresholds: TIWLabel
    Left = 28
    Top = 396
    Width = 238
    Height = 16
    Visible = False
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'There are no global thresholds.'
  end
end
