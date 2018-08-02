object frmImportUsers: TfrmImportUsers
  Left = 707
  Top = 304
  HelpContext = 2304
  BorderStyle = bsDialog
  Caption = 'Import User Details from CSV'
  ClientHeight = 274
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    420
    274)
  PixelsPerInch = 96
  TextHeight = 14
  object lblCSVFile: TLabel
    Left = 23
    Top = 41
    Width = 41
    Height = 14
    Alignment = taRightJustify
    Caption = 'CSV File'
  end
  object lblCaption: TLabel
    Left = 5
    Top = 5
    Width = 375
    Height = 28
    Caption = 
      'User details can be imported from a CSV file to create new users' +
      ' and update existing users.'
    WordWrap = True
  end
  object lblCreateUserDetail: TLabel
    Left = 5
    Top = 76
    Width = 373
    Height = 28
    Caption = 
      'If you want the import to create new users then you need to  spe' +
      'cify how to set them up:-'
    WordWrap = True
  end
  object lblAppended: TLabel
    Left = 22
    Top = 224
    Width = 91
    Height = 14
    Caption = 'has been supplied.'
  end
  object lblCsvFileFormatInfo: TLabel
    Left = 82
    Top = 19
    Width = 265
    Height = 14
    Cursor = crHandPoint
    HelpContext = 2304
    Caption = 'Click here for more information on the CSV file format...'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblCsvFileFormatInfoClick
  end
  object edtImportFilename: TEdit
    Left = 69
    Top = 38
    Width = 299
    Height = 22
    TabOrder = 0
  end
  object btnBrowseFile: TButton
    Left = 369
    Top = 38
    Width = 28
    Height = 22
    Caption = '...'
    TabOrder = 1
    OnClick = btnBrowseFileClick
  end
  object rbCreateUsersWithAccYes: TRadioButton
    Left = 15
    Top = 132
    Width = 355
    Height = 17
    Caption = 'Create new users with all Password Access Settings set to YES'
    TabOrder = 2
  end
  object rbCreateUsersWithAccNo: TRadioButton
    Left = 15
    Top = 152
    Width = 355
    Height = 17
    Caption = 'Create new users with all Password Access Settings set to NO'
    TabOrder = 3
  end
  object rbCopyUser: TRadioButton
    Left = 15
    Top = 172
    Width = 238
    Height = 17
    Caption = 'Create new users based on an existing user '
    TabOrder = 4
  end
  object cmbUserNameList: TComboBox
    Left = 252
    Top = 169
    Width = 145
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 5
  end
  object btnImport: TButton
    Left = 129
    Top = 248
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = '&Import'
    Enabled = False
    TabOrder = 6
    OnClick = btnImportClick
  end
  object btnCancel: TButton
    Left = 217
    Top = 248
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 7
  end
  object rbUpdateUser: TRadioButton
    Left = 15
    Top = 112
    Width = 378
    Height = 17
    Caption = 
      'Do not create new users, any new users in the CSV file will be s' +
      'kipped'
    Checked = True
    TabOrder = 8
    TabStop = True
  end
  object cbEmailUser: TCheckBox
    Left = 5
    Top = 207
    Width = 371
    Height = 17
    Caption = 
      'Email User ID'#39's and Passwords to new users where an Email Addres' +
      's'
    TabOrder = 9
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '.csv'
    Filter = 'CSV Files (*.csv)|*.csv'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 384
  end
end
