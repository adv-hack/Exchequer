object frmGDPRConfiguration: TfrmGDPRConfiguration
  Left = 509
  Top = 374
  HelpContext = 2311
  BorderStyle = bsDialog
  Caption = 'GDPR Configuration'
  ClientHeight = 301
  ClientWidth = 530
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 5
    Top = 5
    Width = 439
    Height = 291
    HelpContext = 2311
    ActivePage = tabTraderSettings
    TabIndex = 0
    TabOrder = 0
    object tabTraderSettings: TTabSheet
      Caption = 'Trader Settings'
      object lblTraderRetPer: TLabel
        Left = 25
        Top = 75
        Width = 113
        Height = 14
        Alignment = taRightJustify
        Caption = 'Trader Retention Period'
      end
      object lblTraderYear: TLabel
        Left = 195
        Top = 75
        Width = 62
        Height = 14
        Caption = 'Years (1-30)'
      end
      object lblTraderRetPeriod: Label8
        Left = 5
        Top = 5
        Width = 78
        Height = 14
        Caption = 'Retention Period'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object bvlTS1: TBevel
        Left = 88
        Top = 11
        Width = 336
        Height = 2
        Shape = bsTopLine
      end
      object lblTraderDesc: TLabel
        Left = 15
        Top = 24
        Width = 381
        Height = 42
        Caption = 
          'Please specify the period that you need to retain your Accountin' +
          'g Records for, this will start from the end of the financial  ye' +
          'ar containing the Trader'#39's latest transaction.'
        WordWrap = True
      end
      object lblTraderAnoSett: Label8
        Left = 5
        Top = 101
        Width = 113
        Height = 14
        Caption = 'Anonymisation Settings'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object bvlTS2: TBevel
        Left = 123
        Top = 109
        Width = 301
        Height = 2
        Shape = bsTopLine
      end
      object lblTraderAno: TLabel
        Left = 15
        Top = 120
        Width = 152
        Height = 14
        Caption = 'When Traders are anonymised:'
      end
      object lblTraderNotes: TLabel
        Left = 53
        Top = 142
        Width = 28
        Height = 14
        Alignment = taRightJustify
        Caption = 'Notes'
      end
      object lblTraderLetters: TLabel
        Left = 47
        Top = 167
        Width = 34
        Height = 14
        Alignment = taRightJustify
        Caption = 'Letters'
      end
      object lblTraderLinks: TLabel
        Left = 56
        Top = 192
        Width = 25
        Height = 14
        Alignment = taRightJustify
        Caption = 'Links'
      end
      object lblTraderMiscSett: Label8
        Left = 5
        Top = 218
        Width = 110
        Height = 14
        Caption = 'Miscellaneous Settings'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object bvlTS3: TBevel
        Left = 120
        Top = 226
        Width = 304
        Height = 2
        Shape = bsTopLine
      end
      object udTraderRetPer: TUpDown
        Left = 175
        Top = 72
        Width = 16
        Height = 22
        Associate = edtTraderRetPer
        Min = 1
        Max = 30
        Position = 6
        TabOrder = 1
        Wrap = False
      end
      object chkTraderDispPIIInfoWin: TCheckBox
        Left = 15
        Top = 237
        Width = 345
        Height = 17
        Caption = 'Display the PII Information Window when a Trader is closed'
        TabOrder = 5
      end
      object cmbTraderNotes: TComboBox
        Left = 86
        Top = 138
        Width = 333
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 1
        TabOrder = 2
        Text = 'Delete all Notes'
        Items.Strings = (
          'Leave Notes intact'
          'Delete all Notes')
      end
      object cmbTraderLetters: TComboBox
        Left = 86
        Top = 163
        Width = 333
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 2
        TabOrder = 3
        Text = 'Delete all the Letter records and delete the Letter files'
        Items.Strings = (
          'Leave Letters intact'
          'Delete all the Letter records, but leave the Letter files intact'
          'Delete all the Letter records and delete the Letter files')
      end
      object cmbTraderLinks: TComboBox
        Left = 86
        Top = 188
        Width = 333
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 1
        TabOrder = 4
        Text = 'Delete all the Link records, but leave the linked files intact'
        Items.Strings = (
          'Leave Links intact'
          'Delete all the Link records, but leave the linked files intact'
          'Delete all the Link records and delete the linked files')
      end
      object edtTraderRetPer: TCurrencyEdit
        Tag = 1
        Left = 143
        Top = 72
        Width = 32
        Height = 22
        HelpContext = 1236
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '6')
        MaxLength = 2
        ParentFont = False
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        OnExit = edtTraderRetPerExit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 6
      end
    end
    object tabEmpSettings: TTabSheet
      Caption = 'Employee Settings'
      ImageIndex = 3
      object lblEmployeeRetPer: TLabel
        Left = 11
        Top = 75
        Width = 127
        Height = 14
        Alignment = taRightJustify
        Caption = 'Employee Retention Period'
      end
      object lblEmployeeYear: TLabel
        Left = 195
        Top = 75
        Width = 62
        Height = 14
        Caption = 'Years (1-30)'
      end
      object lblEmployeeRetPeriod: Label8
        Left = 5
        Top = 5
        Width = 78
        Height = 14
        Caption = 'Retention Period'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object bvlEmp1: TBevel
        Left = 88
        Top = 11
        Width = 336
        Height = 2
        Shape = bsTopLine
      end
      object lblEmployeeDesc: TLabel
        Left = 15
        Top = 24
        Width = 381
        Height = 42
        Caption = 
          'Please specify the period that you need to retain your Accountin' +
          'g Records for, this will start from the end of the financial  ye' +
          'ar containing the Employee'#39's latest transaction.'
        WordWrap = True
      end
      object lblEmployeeAnoSett: Label8
        Left = 5
        Top = 101
        Width = 113
        Height = 14
        Caption = 'Anonymisation Settings'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object bvlEmp2: TBevel
        Left = 123
        Top = 109
        Width = 301
        Height = 2
        Shape = bsTopLine
      end
      object lblEmployeeAno: TLabel
        Left = 15
        Top = 120
        Width = 166
        Height = 14
        Caption = 'When Employees are anonymised:'
      end
      object lblEmployeeNotes: TLabel
        Left = 53
        Top = 142
        Width = 28
        Height = 14
        Alignment = taRightJustify
        Caption = 'Notes'
      end
      object lblEmployeeLetters: TLabel
        Left = 47
        Top = 167
        Width = 34
        Height = 14
        Alignment = taRightJustify
        Caption = 'Letters'
      end
      object lblEmployeeLinks: TLabel
        Left = 56
        Top = 192
        Width = 25
        Height = 14
        Alignment = taRightJustify
        Caption = 'Links'
      end
      object lblEmployeeMiscSett: Label8
        Left = 5
        Top = 218
        Width = 110
        Height = 14
        Caption = 'Miscellaneous Settings'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object bvlEmp3: TBevel
        Left = 120
        Top = 226
        Width = 304
        Height = 2
        Shape = bsTopLine
      end
      object udEmployeeRetPer: TUpDown
        Left = 175
        Top = 72
        Width = 16
        Height = 22
        Associate = edtEmployeeRetPer
        Min = 1
        Max = 30
        Position = 6
        TabOrder = 1
        Wrap = False
      end
      object chkEmployeeDispPIIInfoWin: TCheckBox
        Left = 15
        Top = 237
        Width = 345
        Height = 17
        Caption = 'Display the PII Information Window when a Employee is closed'
        TabOrder = 5
      end
      object cmbEmployeeNotes: TComboBox
        Left = 86
        Top = 138
        Width = 333
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 1
        TabOrder = 2
        Text = 'Delete all Notes'
        Items.Strings = (
          'Leave Notes intact'
          'Delete all Notes')
      end
      object cmbEmployeeLetters: TComboBox
        Left = 86
        Top = 163
        Width = 333
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 2
        TabOrder = 3
        Text = 'Delete all the Letter records and delete the Letter files'
        Items.Strings = (
          'Leave Letters intact'
          'Delete all the Letter records, but leave the Letter files intact'
          'Delete all the Letter records and delete the Letter files')
      end
      object cmbEmployeeLinks: TComboBox
        Left = 86
        Top = 188
        Width = 333
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 1
        TabOrder = 4
        Text = 'Delete all the Link records, but leave the linked files intact'
        Items.Strings = (
          'Leave Links intact'
          'Delete all the Link records, but leave the linked files intact'
          'Delete all the Link records and delete the linked files')
      end
      object edtEmployeeRetPer: TCurrencyEdit
        Tag = 1
        Left = 143
        Top = 72
        Width = 32
        Height = 22
        HelpContext = 1236
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '6')
        MaxLength = 2
        ParentFont = False
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        OnExit = edtEmployeeRetPerExit
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '###,###,##0 ;###,###,##0-'
        DecPlaces = 0
        ShowCurrency = False
        TextId = 0
        Value = 6
      end
    end
    object tabNotification: TTabSheet
      Caption = 'Notifications'
      ImageIndex = 2
      object shpNotifiStatus: TShape
        Left = 25
        Top = 58
        Width = 363
        Height = 38
        Brush.Color = clRed
        Shape = stRoundRect
      end
      object bvlNotifi: TBevel
        Left = 171
        Top = 13
        Width = 253
        Height = 2
        Shape = bsTopLine
      end
      object lblNotifiAnoStatus: Label8
        Left = 5
        Top = 5
        Width = 161
        Height = 14
        Caption = 'Anonymisation Status Notification'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblNotifiDesc: TLabel
        Left = 15
        Top = 24
        Width = 389
        Height = 28
        Caption = 
          'The Anonymisation Status Notification is shown on entities that ' +
          'have either been anonymised or are scheduled for anonymisation.'
        WordWrap = True
      end
      object lblAnonStatus: TLabel
        Left = 26
        Top = 65
        Width = 361
        Height = 24
        Alignment = taCenter
        AutoSize = False
        Caption = 'Anonymised 30/09/2017'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object btnBackColor: TButton
        Left = 80
        Top = 100
        Width = 125
        Height = 21
        Hint = 'Edit Background Colour'
        Caption = 'Edit Background Colour'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btnBackColorClick
      end
      object btnFontColor: TButton
        Left = 208
        Top = 100
        Width = 125
        Height = 21
        Hint = 'Edit Font Colour'
        Caption = 'Edit Font Colour'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnFontColorClick
      end
    end
    object tabCompanyAno: TTabSheet
      Caption = 'Company Anonymisation'
      ImageIndex = 1
      TabVisible = False
      object lblCompAddDesc: TLabel
        Left = 15
        Top = 141
        Width = 355
        Height = 42
        Caption = 
          'Please identify any entities in the list below that contain PII ' +
          'or confidential information, they will then be included within t' +
          'he Company Anonymisation process.'
        WordWrap = True
      end
      object lblCompAddAnonEnt: Label8
        Left = 5
        Top = 122
        Width = 157
        Height = 14
        Caption = 'Additional Anonymisation Entities'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object bvlComp2: TBevel
        Left = 167
        Top = 130
        Width = 257
        Height = 2
        Shape = bsTopLine
      end
      object lblCompAnonSett: Label8
        Left = 5
        Top = 5
        Width = 113
        Height = 14
        Caption = 'Anonymisation Settings'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object bvlComp1: TBevel
        Left = 123
        Top = 13
        Width = 301
        Height = 2
        Shape = bsTopLine
      end
      object lblCompDesc: TLabel
        Left = 15
        Top = 24
        Width = 169
        Height = 14
        Caption = 'When the Company is anonymised:'
      end
      object lblCompNotes: TLabel
        Left = 53
        Top = 46
        Width = 28
        Height = 14
        Alignment = taRightJustify
        Caption = 'Notes'
      end
      object lblCompLetters: TLabel
        Left = 47
        Top = 71
        Width = 34
        Height = 14
        Alignment = taRightJustify
        Caption = 'Letters'
      end
      object lblCompLinks: TLabel
        Left = 56
        Top = 96
        Width = 25
        Height = 14
        Alignment = taRightJustify
        Caption = 'Links'
      end
      object cmbCompNotes: TComboBox
        Left = 86
        Top = 42
        Width = 333
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 1
        TabOrder = 0
        Text = 'Delete all Notes'
        Items.Strings = (
          'Leave Notes intact'
          'Delete all Notes')
      end
      object cmbCompLetters: TComboBox
        Left = 86
        Top = 67
        Width = 333
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 2
        TabOrder = 1
        Text = 'Delete all the Letter records and delete the Letter files'
        Items.Strings = (
          'Leave Letters intact'
          'Delete all the Letter records, but leave the Letter files intact'
          'Delete all the Letter records and delete the Letter files')
      end
      object cmbCompLinks: TComboBox
        Left = 86
        Top = 92
        Width = 333
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 1
        TabOrder = 2
        Text = 'Delete all the Link records, but leave the linked files intact'
        Items.Strings = (
          'Leave Links intact'
          'Delete all the Link records, but leave the linked files intact'
          'Delete all the Link records and delete the linked files')
      end
      object chkCompAnonCostCentre: TCheckBox
        Left = 15
        Top = 188
        Width = 85
        Height = 17
        Caption = 'Cost Centres'
        TabOrder = 3
      end
      object chkCompAnonDepartments: TCheckBox
        Left = 15
        Top = 205
        Width = 81
        Height = 17
        Caption = 'Departments'
        TabOrder = 4
      end
      object chkCompAnonLocations: TCheckBox
        Left = 15
        Top = 222
        Width = 68
        Height = 17
        Caption = 'Locations'
        TabOrder = 5
      end
    end
  end
  object btnOK: TButton
    Left = 446
    Top = 25
    Width = 80
    Height = 21
    Hint = 'Store the record'
    Caption = '&OK'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 446
    Top = 49
    Width = 80
    Height = 21
    Hint = 'Cancel record changes'
    Cancel = True
    Caption = '&Cancel'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Left = 488
    Top = 96
  end
end
