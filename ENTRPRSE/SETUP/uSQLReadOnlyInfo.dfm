inherited frmSQLReadOnlyInfo: TfrmSQLReadOnlyInfo
  Left = 745
  Top = 196
  HelpContext = 121
  Caption = 'frmSQLReadOnlyInfo'
  ClientHeight = 387
  ClientWidth = 541
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 342
    Width = 518
  end
  inherited TitleLbl: TLabel
    Width = 366
    Caption = 'MS SQL Server Information'
  end
  inherited InstrLbl: TLabel
    Width = 363
    Caption = 
      'The following information is needed to create the accounts datab' +
      'ase in Microsoft SQL Server.'
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
  end
  inherited imgSide: TImage
    Height = 231
  end
  object lblDBNameDesc: TLabel [4]
    Left = 167
    Top = 107
    Width = 363
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'The Database Name must uniquely identify the database within you' +
      'r installation of Microsoft SQL Server:-'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lblDBName: TLabel [5]
    Left = 167
    Top = 90
    Width = 97
    Height = 15
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Database Name'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Top = 359
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
    TabOrder = 3
  end
  inherited Panel1: TPanel
    Height = 325
    TabOrder = 2
    inherited Image1: TImage
      Height = 323
    end
  end
  inherited ExitBtn: TButton
    Top = 359
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
    TabOrder = 4
  end
  inherited BackBtn: TButton
    Left = 364
    Top = 359
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
    TabOrder = 5
  end
  inherited NextBtn: TButton
    Left = 450
    Top = 359
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
    TabOrder = 6
  end
  object edtDbName: TEdit
    Left = 183
    Top = 144
    Width = 121
    Height = 22
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 16
    ParentFont = False
    TabOrder = 0
    OnKeyPress = edtDbNameKeyPress
  end
  object panReportingUser: TPanel
    Left = 164
    Top = 171
    Width = 369
    Height = 179
    BevelOuter = bvNone
    TabOrder = 1
    object Label2: TLabel
      Left = 0
      Top = 87
      Width = 60
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'User Id'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 0
      Top = 115
      Width = 60
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Password'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 3
      Top = 21
      Width = 347
      Height = 60
      AutoSize = False
      Caption = 
        'The Reporting User is provided to allow third-party applications' +
        ' to access the company dataset for reporting purposes.  The User' +
        ' is specific to a particular company and the User Id must be uni' +
        'que across all company datasets.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label4: TLabel
      Left = 3
      Top = 4
      Width = 139
      Height = 15
      AutoSize = False
      Caption = 'Reporting User'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label7: TLabel
      Left = 3
      Top = 153
      Width = 359
      Height = 21
      AutoSize = False
      Caption = 
        'Please make a note of the above information for future reference' +
        '.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object edtSqlUserName: TEdit
      Left = 64
      Top = 84
      Width = 288
      Height = 22
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnKeyPress = edtSqlUserNameKeyPress
    end
    object edtSQLUserPass: TEdit
      Left = 64
      Top = 112
      Width = 288
      Height = 22
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 30
      ParentFont = False
      TabOrder = 1
    end
  end
  object ADOConnection: TADOConnection
    Left = 336
    Top = 148
  end
  object ADOQuery: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    Left = 364
    Top = 148
  end
end
