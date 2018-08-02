object frmUserAuthenticationSettings: TfrmUserAuthenticationSettings
  Left = 802
  Top = 276
  HelpContext = 2305
  BorderStyle = bsDialog
  Caption = 'User Authentication Settings'
  ClientHeight = 328
  ClientWidth = 462
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
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  DesignSize = (
    462
    328)
  PixelsPerInch = 96
  TextHeight = 14
  object lblPleaseSelect: TLabel
    Left = 5
    Top = 5
    Width = 447
    Height = 14
    Caption = 
      'Please select the Authentication System to control access to thi' +
      's company within Exchequer.'
  end
  object lblusrsLog: TLabel
    Left = 31
    Top = 45
    Width = 419
    Height = 14
    Caption = 
      'Users log into Exchequer using User Accounts setup and maintaine' +
      'd within Exchequer.'
  end
  object lblWinAuthentication: TLabel
    Left = 31
    Top = 205
    Width = 419
    Height = 32
    AutoSize = False
    Caption = 
      'Users log into Exchequer using their Windows User Accounts which' +
      ' are linked to an Exchequer User Profile for Exchequer specific ' +
      'configuration information.'
    WordWrap = True
  end
  object lblMinPwordLength: TLabel
    Left = 55
    Top = 164
    Width = 129
    Height = 14
    Caption = 'Minimum Password Length'
  end
  object lbl0to30: TLabel
    Left = 256
    Top = 164
    Width = 36
    Height = 14
    Caption = '(0 - 30)'
  end
  object lblExchqrPswrd: TLabel
    Left = 39
    Top = 68
    Width = 202
    Height = 14
    Caption = 'Exchequer Password Complexity Settings'
  end
  object bevel1: TBevel
    Left = 164
    Top = 34
    Width = 291
    Height = 9
    Shape = bsTopLine
  end
  object bevel2: TBevel
    Left = 157
    Top = 194
    Width = 296
    Height = 9
    Shape = bsTopLine
  end
  object lblFailedAttempts: TLabel
    Left = 178
    Top = 263
    Width = 95
    Height = 14
    Caption = 'failed login attempts'
  end
  object lblAutosuspendOption: TLabel
    Left = 5
    Top = 241
    Width = 103
    Height = 14
    Caption = 'Auto Suspend Option'
  end
  object bevel3: TBevel
    Left = 117
    Top = 248
    Width = 341
    Height = 9
    Shape = bsTopLine
  end
  object radExchequerAuthentication: TRadioButton
    Left = 15
    Top = 26
    Width = 141
    Height = 17
    Caption = 'Exchequer Authentication'
    TabOrder = 0
    OnClick = radExchequerAuthenticationClick
  end
  object radWindowsAuthentication: TRadioButton
    Left = 15
    Top = 186
    Width = 136
    Height = 17
    Caption = 'Windows Authentication'
    TabOrder = 7
    OnClick = radWindowsAuthenticationClick
  end
  object btnSave: TButton
    Left = 147
    Top = 297
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = '&Save'
    TabOrder = 11
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 235
    Top = 297
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 12
    OnClick = btnCancelClick
  end
  object udMinPwordLength: TUpDown
    Tag = 1
    Left = 235
    Top = 161
    Width = 16
    Height = 22
    Associate = edtMinPwordLength
    Min = 0
    Max = 30
    Position = 0
    TabOrder = 6
    Wrap = False
  end
  object chkUppercase: TCheckBox
    Left = 55
    Top = 86
    Width = 211
    Height = 17
    Caption = 'Must contain an Uppercase letter'
    TabOrder = 1
    OnClick = ChkboxCustomOnClickEvent
  end
  object chkLowercase: TCheckBox
    Left = 55
    Top = 105
    Width = 211
    Height = 17
    Caption = 'Must contain a Lowercase letter'
    TabOrder = 2
    OnClick = ChkboxCustomOnClickEvent
  end
  object chkNumber: TCheckBox
    Left = 55
    Top = 124
    Width = 211
    Height = 17
    Caption = 'Must contain a Number'
    TabOrder = 3
    OnClick = ChkboxCustomOnClickEvent
  end
  object chkSpecalCharacter: TCheckBox
    Left = 55
    Top = 143
    Width = 211
    Height = 17
    Caption = 'Must contain a Special character'
    TabOrder = 4
    OnClick = ChkboxCustomOnClickEvent
  end
  object chkSuspendOnLoginFailure: TCheckBox
    Left = 15
    Top = 262
    Width = 115
    Height = 17
    Caption = 'Suspend user after'
    TabOrder = 8
    OnClick = chkSuspendOnLoginFailureClick
  end
  object edtSuspendCount: TEdit
    Left = 130
    Top = 260
    Width = 27
    Height = 22
    MaxLength = 2
    TabOrder = 9
    Text = '1'
    OnExit = edtSuspendCountExit
    OnKeyPress = edtSuspendCountKeyPress
  end
  object udSuspendCount: TUpDown
    Left = 157
    Top = 260
    Width = 16
    Height = 22
    Associate = edtSuspendCount
    Min = 1
    Max = 20
    Position = 1
    TabOrder = 10
    Wrap = False
  end
  object edtMinPwordLength: TCurrencyEdit
    Tag = 1
    Left = 189
    Top = 161
    Width = 46
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'ARIAL'
    Font.Style = []
    Lines.Strings = (
      '0')
    MaxLength = 2
    ParentFont = False
    TabOrder = 5
    WantReturns = False
    WordWrap = False
    OnExit = edtMinPwordLengthExit
    OnKeyPress = edtMinPwordLengthKeyPress
    AutoSize = False
    BlockNegative = False
    BlankOnZero = False
    DisplayFormat = '###,###,##0 ;###,###,##0-'
    DecPlaces = 0
    ShowCurrency = False
    TextId = 0
    Value = 1E-10
  end
end
