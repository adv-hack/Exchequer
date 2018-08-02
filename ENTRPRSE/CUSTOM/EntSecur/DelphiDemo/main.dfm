object frmMain: TfrmMain
  Left = 564
  Top = 304
  Width = 494
  Height = 409
  Caption = 'Enterprise Security - Third Party'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object lblVer: TLabel
    Left = 374
    Top = 12
    Width = 96
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Version'
  end
  object Label1: TLabel
    Left = 13
    Top = 107
    Width = 68
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Security Type'
  end
  object Bevel1: TBevel
    Left = 7
    Top = 194
    Width = 462
    Height = 8
    Shape = bsTopLine
  end
  object Label2: TLabel
    Left = 35
    Top = 333
    Width = 410
    Height = 14
    Caption = 
      '* If the security record does not exist it will be created using' +
      ' the editable fields above'
  end
  object Label3: TLabel
    Left = 19
    Top = 80
    Width = 6
    Height = 14
    Caption = #8224
  end
  object Label4: TLabel
    Left = 29
    Top = 127
    Width = 6
    Height = 14
    Caption = #8224
  end
  object Label5: TLabel
    Left = 49
    Top = 160
    Width = 381
    Height = 30
    Alignment = taCenter
    AutoSize = False
    Caption = 
      #8224' This field isn'#39't read from the security record on "Read Securi' +
      'ty" but if it differs from what'#39's currently recorded, the securi' +
      'ty record will be updated'
    WordWrap = True
  end
  object Label6: TLabel
    Left = 8
    Top = 102
    Width = 6
    Height = 14
    Caption = #8224
  end
  object edtSystemID: TLabeledEdit
    Left = 83
    Top = 32
    Width = 169
    Height = 22
    CharCase = ecUpperCase
    EditLabel.Width = 48
    EditLabel.Height = 14
    EditLabel.Caption = 'System ID'
    LabelPosition = lpLeft
    LabelSpacing = 3
    TabOrder = 1
  end
  object edtESN: TLabeledEdit
    Left = 83
    Top = 8
    Width = 169
    Height = 22
    Color = clBtnFace
    EditLabel.Width = 20
    EditLabel.Height = 14
    EditLabel.Caption = 'ESN'
    LabelPosition = lpLeft
    LabelSpacing = 3
    ReadOnly = True
    TabOrder = 0
  end
  object edtSecurityID: TLabeledEdit
    Left = 83
    Top = 56
    Width = 169
    Height = 22
    EditLabel.Width = 52
    EditLabel.Height = 14
    EditLabel.Caption = 'Security ID'
    LabelPosition = lpLeft
    LabelSpacing = 3
    TabOrder = 2
  end
  object edtDescription: TLabeledEdit
    Left = 83
    Top = 80
    Width = 302
    Height = 22
    EditLabel.Width = 54
    EditLabel.Height = 14
    EditLabel.Caption = 'Description'
    LabelPosition = lpLeft
    LabelSpacing = 3
    TabOrder = 3
  end
  object cbSecurityType: TComboBox
    Left = 83
    Top = 104
    Width = 145
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 4
    Items.Strings = (
      'System Only'
      'User Count Only'
      'System and User Count')
  end
  object edtMessage: TLabeledEdit
    Left = 83
    Top = 128
    Width = 302
    Height = 22
    EditLabel.Width = 44
    EditLabel.Height = 14
    EditLabel.Caption = 'Message'
    LabelPosition = lpLeft
    LabelSpacing = 3
    TabOrder = 5
  end
  object btnPlugin1: TButton
    Left = 392
    Top = 32
    Width = 80
    Height = 21
    Caption = 'Plugin 1'
    TabOrder = 6
    OnClick = PluginBtnClick
  end
  object btnPlugin2: TButton
    Left = 392
    Top = 56
    Width = 80
    Height = 21
    Caption = 'Plugin 2'
    TabOrder = 7
    OnClick = PluginBtnClick
  end
  object btnPlugin3: TButton
    Left = 392
    Top = 80
    Width = 80
    Height = 21
    Caption = 'Plugin 3'
    TabOrder = 8
    OnClick = PluginBtnClick
  end
  object btnPlugin4: TButton
    Left = 392
    Top = 104
    Width = 80
    Height = 21
    Caption = 'Plugin 4'
    TabOrder = 9
    OnClick = PluginBtnClick
  end
  object edtSystemStatus: TLabeledEdit
    Left = 83
    Top = 208
    Width = 250
    Height = 22
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clBtnFace
    EditLabel.Width = 70
    EditLabel.Height = 14
    EditLabel.Caption = 'System Status'
    LabelPosition = lpLeft
    LabelSpacing = 3
    ReadOnly = True
    TabOrder = 10
  end
  object edtLicUserCount: TLabeledEdit
    Left = 83
    Top = 240
    Width = 121
    Height = 22
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clBtnFace
    EditLabel.Width = 71
    EditLabel.Height = 14
    EditLabel.Caption = 'Lic User Count'
    LabelPosition = lpLeft
    LabelSpacing = 3
    ReadOnly = True
    TabOrder = 11
  end
  object edtCurrUserCount: TLabeledEdit
    Left = 83
    Top = 272
    Width = 121
    Height = 22
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clBtnFace
    EditLabel.Width = 78
    EditLabel.Height = 14
    EditLabel.Caption = 'Curr User Count'
    LabelPosition = lpLeft
    LabelSpacing = 3
    ReadOnly = True
    TabOrder = 12
  end
  object btnReadSecurity: TButton
    Left = 392
    Top = 207
    Width = 80
    Height = 21
    Caption = 'Read Security*'
    TabOrder = 13
    OnClick = btnReadSecurityClick
  end
  object btnAddUser: TButton
    Left = 392
    Top = 231
    Width = 80
    Height = 21
    Caption = 'Add User'
    TabOrder = 14
    OnClick = btnAddUserClick
  end
  object btnRemoveUser: TButton
    Left = 392
    Top = 255
    Width = 80
    Height = 21
    Caption = 'Remove User'
    TabOrder = 15
    OnClick = btnRemoveUserClick
  end
  object btnResetCount: TButton
    Left = 392
    Top = 279
    Width = 80
    Height = 21
    Caption = 'Reset Count'
    TabOrder = 16
    OnClick = btnResetCountClick
  end
  object pnlStatusBar: TPanel
    Left = 0
    Top = 352
    Width = 478
    Height = 19
    Align = alBottom
    Alignment = taLeftJustify
    BevelInner = bvLowered
    TabOrder = 17
  end
  object edtExpiryDate: TLabeledEdit
    Left = 83
    Top = 302
    Width = 121
    Height = 22
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clBtnFace
    EditLabel.Width = 55
    EditLabel.Height = 14
    EditLabel.Caption = 'Expiry Date'
    LabelPosition = lpLeft
    LabelSpacing = 3
    ReadOnly = True
    TabOrder = 18
  end
end
