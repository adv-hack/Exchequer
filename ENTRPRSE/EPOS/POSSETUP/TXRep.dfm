object frmTXReport: TfrmTXReport
  Left = 254
  Top = 190
  BorderStyle = bsDialog
  Caption = 'Transaction print out parameters'
  ClientHeight = 368
  ClientWidth = 545
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel4: TBevel
    Left = 288
    Top = 16
    Width = 161
    Height = 185
    Shape = bsFrame
  end
  object Bevel2: TBevel
    Left = 8
    Top = 16
    Width = 273
    Height = 89
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 25
    Top = 36
    Width = 29
    Height = 14
    Alignment = taRightJustify
    Caption = 'Start :'
  end
  object Label2: TLabel
    Left = 25
    Top = 68
    Width = 24
    Height = 14
    Alignment = taRightJustify
    Caption = 'End :'
  end
  object Label5: TLabel
    Left = 16
    Top = 8
    Width = 98
    Height = 14
    Caption = 'Date / Time Range'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 296
    Top = 8
    Width = 92
    Height = 14
    Caption = 'Tills to report on'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 8
    Top = 216
    Width = 441
    Height = 145
    Shape = bsFrame
  end
  object Label4: TLabel
    Left = 16
    Top = 208
    Width = 77
    Height = 14
    Caption = 'Types to print'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel3: TBevel
    Left = 8
    Top = 120
    Width = 273
    Height = 81
    Shape = bsFrame
  end
  object Label6: TLabel
    Left = 16
    Top = 112
    Width = 82
    Height = 14
    Caption = 'Account Types'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lstTills: TCheckListBox
    Left = 296
    Top = 24
    Width = 145
    Height = 149
    OnClickCheck = lstTillsClickCheck
    ItemHeight = 14
    TabOrder = 2
  end
  object btnAll: TButton
    Left = 296
    Top = 172
    Width = 145
    Height = 21
    Caption = 'Select All'
    TabOrder = 3
    OnClick = btnAllClick
  end
  object edStartDate: TDateTimePicker
    Left = 56
    Top = 32
    Width = 97
    Height = 22
    CalAlignment = dtaLeft
    Date = 36922.690187037
    Time = 36922.690187037
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 0
  end
  object edEndDate: TDateTimePicker
    Left = 56
    Top = 64
    Width = 97
    Height = 22
    CalAlignment = dtaLeft
    Date = 36922.690187037
    Time = 36922.690187037
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 456
    Top = 16
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 4
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 456
    Top = 40
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object DateTimePicker1: TDateTimePicker
    Left = 168
    Top = 32
    Width = 97
    Height = 22
    CalAlignment = dtaLeft
    Date = 36922.690187037
    Time = 36922.690187037
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkTime
    ParseInput = False
    TabOrder = 6
  end
  object DateTimePicker2: TDateTimePicker
    Left = 168
    Top = 64
    Width = 97
    Height = 22
    CalAlignment = dtaLeft
    Date = 36922.690187037
    Time = 36922.690187037
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkTime
    ParseInput = False
    TabOrder = 7
  end
  object cbIncludeAccType: TCheckBox
    Tag = 11
    Left = 32
    Top = 139
    Width = 145
    Height = 17
    Caption = 'Include Account Types :'
    TabOrder = 8
    OnClick = AccCheckClick
  end
  object edIncludeAccType: TEdit
    Left = 176
    Top = 136
    Width = 81
    Height = 22
    Enabled = False
    TabOrder = 9
  end
  object cbExcludeAccType: TCheckBox
    Tag = 12
    Left = 32
    Top = 171
    Width = 145
    Height = 17
    Caption = 'Exclude Account Types :'
    TabOrder = 10
    OnClick = AccCheckClick
  end
  object edExcludeAccType: TEdit
    Left = 176
    Top = 168
    Width = 81
    Height = 22
    Enabled = False
    TabOrder = 11
  end
  object cbSCR: TCheckBox
    Tag = 1
    Left = 32
    Top = 235
    Width = 49
    Height = 17
    Caption = 'SCR'
    Checked = True
    State = cbChecked
    TabOrder = 12
    OnClick = TypeCheckClick
  end
  object cmbSCRForm: TComboBox
    Tag = 1
    Left = 88
    Top = 232
    Width = 137
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 13
    Text = 'Customer Default'
    OnChange = cmbFormChange
    Items.Strings = (
      'Customer Default'
      'Exchequer Default'
      'Pick Form')
  end
  object edSCRForm: TEdit
    Tag = 1
    Left = 232
    Top = 232
    Width = 137
    Height = 22
    Enabled = False
    TabOrder = 14
  end
  object btnSCRBrowse: TButton
    Tag = 1
    Left = 368
    Top = 232
    Width = 67
    Height = 22
    Caption = 'Browse'
    Enabled = False
    TabOrder = 15
    OnClick = btnBrowseClick
  end
  object cbSIN: TCheckBox
    Tag = 2
    Left = 32
    Top = 259
    Width = 49
    Height = 17
    Caption = 'SIN'
    Checked = True
    State = cbChecked
    TabOrder = 16
    OnClick = TypeCheckClick
  end
  object cmbSINForm: TComboBox
    Tag = 2
    Left = 88
    Top = 256
    Width = 137
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 17
    Text = 'Customer Default'
    OnChange = cmbFormChange
    Items.Strings = (
      'Customer Default'
      'Exchequer Default'
      'Pick Form')
  end
  object edSINForm: TEdit
    Tag = 2
    Left = 232
    Top = 256
    Width = 137
    Height = 22
    Enabled = False
    TabOrder = 18
  end
  object btnSINBrowse: TButton
    Tag = 2
    Left = 368
    Top = 256
    Width = 67
    Height = 22
    Caption = 'Browse'
    Enabled = False
    TabOrder = 19
    OnClick = btnBrowseClick
  end
  object cbSOR: TCheckBox
    Tag = 3
    Left = 32
    Top = 283
    Width = 49
    Height = 17
    Caption = 'SOR'
    Checked = True
    State = cbChecked
    TabOrder = 20
    OnClick = TypeCheckClick
  end
  object cmbSORForm: TComboBox
    Tag = 3
    Left = 88
    Top = 280
    Width = 137
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 21
    Text = 'Customer Default'
    OnChange = cmbFormChange
    Items.Strings = (
      'Customer Default'
      'Exchequer Default'
      'Pick Form')
  end
  object edSORForm: TEdit
    Tag = 3
    Left = 232
    Top = 280
    Width = 137
    Height = 22
    Enabled = False
    TabOrder = 22
  end
  object btnSORBrowse: TButton
    Tag = 3
    Left = 368
    Top = 280
    Width = 67
    Height = 22
    Caption = 'Browse'
    Enabled = False
    TabOrder = 23
    OnClick = btnBrowseClick
  end
  object cbSRF: TCheckBox
    Tag = 4
    Left = 32
    Top = 307
    Width = 49
    Height = 17
    Caption = 'SRF'
    Checked = True
    State = cbChecked
    TabOrder = 24
    OnClick = TypeCheckClick
  end
  object cmbSRFForm: TComboBox
    Tag = 4
    Left = 88
    Top = 304
    Width = 137
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 25
    Text = 'Customer Default'
    OnChange = cmbFormChange
    Items.Strings = (
      'Customer Default'
      'Exchequer Default'
      'Pick Form')
  end
  object edSRFForm: TEdit
    Tag = 4
    Left = 232
    Top = 304
    Width = 137
    Height = 22
    Enabled = False
    TabOrder = 26
  end
  object btnSRFBrowse: TButton
    Tag = 4
    Left = 368
    Top = 304
    Width = 67
    Height = 22
    Caption = 'Browse'
    Enabled = False
    TabOrder = 27
    OnClick = btnBrowseClick
  end
  object cbSRI: TCheckBox
    Tag = 5
    Left = 32
    Top = 331
    Width = 49
    Height = 17
    Caption = 'SRI'
    Checked = True
    State = cbChecked
    TabOrder = 28
    OnClick = TypeCheckClick
  end
  object cmbSRIForm: TComboBox
    Tag = 5
    Left = 88
    Top = 328
    Width = 137
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 29
    Text = 'Customer Default'
    OnChange = cmbFormChange
    Items.Strings = (
      'Customer Default'
      'Exchequer Default'
      'Pick Form')
  end
  object edSRIForm: TEdit
    Tag = 5
    Left = 232
    Top = 328
    Width = 137
    Height = 22
    Enabled = False
    TabOrder = 30
  end
  object btnSRIBrowse: TButton
    Tag = 5
    Left = 368
    Top = 328
    Width = 67
    Height = 22
    Caption = 'Browse'
    Enabled = False
    TabOrder = 31
    OnClick = btnBrowseClick
  end
  object OpenDialog1: TOpenDialog
    Options = [ofReadOnly, ofHideReadOnly, ofNoChangeDir, ofFileMustExist, ofNoNetworkButton, ofEnableSizing]
    Left = 456
    Top = 64
  end
end
