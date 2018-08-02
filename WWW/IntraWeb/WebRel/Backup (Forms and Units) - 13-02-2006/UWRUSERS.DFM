object frmUsers: TfrmUsers
  Left = 0
  Top = 0
  Width = 610
  Height = 313
  Background.Fixed = False
  HandleTabs = False
  SupportedBrowsers = [brIE, brNetscape6]
  OnCreate = IWAppFormCreate
  OnDestroy = IWAppFormDestroy
  DesignLeft = 287
  DesignTop = 153
  object cbUser: TIWComboBox
    Left = 109
    Top = 156
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
  object lblEditUser: TIWLabel
    Left = 24
    Top = 160
    Width = 63
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Caption = 'Edit User:'
  end
  object bnNewUser: TIWButton
    Left = 109
    Top = 186
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'New User'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 1
    OnClick = bnNewUserClick
  end
  object lblhdrUsers: TIWLabel
    Left = 20
    Top = 16
    Width = 45
    Height = 16
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = [fsBold]
    Caption = 'Users'
  end
  object bnReturnAdmin: TIWButton
    Left = 109
    Top = 240
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
    Left = 225
    Top = 240
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
  object bnEditUser: TIWButton
    Left = 225
    Top = 186
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Edit User'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 4
    OnClick = bnEditUserClick
  end
  object txtUser: TIWText
    Left = 32
    Top = 44
    Width = 521
    Height = 92
    ZIndex = 0
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    Lines.Strings = (
      
        'To create a new user, press the New User button below. To edit a' +
        ' user, select the user '
      
        'from the drop-down list below, and press the Edit User button. T' +
        'o change a user'#39's '
      
        'password, select the user in the drop-down box and press the Cha' +
        'nge Pword button. '
      
        'The new password will then be emailed to the selected user; prov' +
        'ided that "Supress'
      'notification" is not ticked.')
    RawText = False
    UseFrame = False
    WantReturns = True
  end
  object bnPWChange: TIWButton
    Left = 341
    Top = 186
    Width = 109
    Height = 25
    ZIndex = 0
    ButtonType = btButton
    Caption = 'Change Pword'
    Color = clBtnFace
    DoSubmitValidation = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    TabOrder = 5
    OnClick = bnPWChangeClick
  end
  object bnFilterUser: TIWButton
    Left = 395
    Top = 154
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
    TabOrder = 6
    OnClick = edFilterUserSubmit
  end
  object edFilterUser: TIWEdit
    Left = 341
    Top = 156
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
    TabOrder = 7
    OnSubmit = edFilterUserSubmit
    PasswordPrompt = False
  end
  object cbContainsUser: TIWCheckBox
    Left = 455
    Top = 156
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
    TabOrder = 8
    Checked = False
  end
  object cbPwordNotification: TIWCheckBox
    Left = 455
    Top = 188
    Width = 145
    Height = 21
    ZIndex = 0
    Caption = 'Supress notification?'
    Editable = True
    Font.Color = clNone
    Font.Enabled = True
    Font.Size = 10
    Font.Style = []
    ScriptEvents = <>
    DoSubmitValidation = True
    Style = stNormal
    TabOrder = 9
    Checked = False
  end
end
