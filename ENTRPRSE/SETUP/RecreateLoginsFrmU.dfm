inherited RecreateLoginsFrm: TRecreateLoginsFrm
  Left = 748
  Top = 289
  HelpContext = 120
  Caption = 'Exchequer SQL - Recreate Log-ins'
  ClientHeight = 406
  ClientWidth = 507
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 361
    Width = 484
  end
  inherited TitleLbl: TLabel
    Width = 332
    Caption = 'MS SQL Server Location'
  end
  inherited InstrLbl: TLabel
    Top = 41
    Width = 329
    Caption = 
      'In order to create the Exchequer SQL Database we need to know wh' +
      'ere to find your Microsoft SQL Server Database Engine.'
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
  end
  inherited imgSide: TImage
    Top = 112
    Height = 250
  end
  object Label1: TLabel [4]
    Left = 167
    Top = 77
    Width = 329
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Please enter below the Computer Name of the computer running the' +
      ' Microsoft SQL Server Database Engine that Exchequer is to use:-'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel [5]
    Left = 167
    Top = 144
    Width = 328
    Height = 44
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'If your Microsoft SQL Server Installation is using Instance Name' +
      's then please specify below the Instance Name that Exchequer SQL' +
      ' is to install to:-'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label3: TLabel [6]
    Left = 167
    Top = 218
    Width = 329
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'If your Microsoft SQL Server Installation is NOT using Instance ' +
      'Names then please leave it blank.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label4: TLabel [7]
    Left = 167
    Top = 302
    Width = 329
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Please enter below the Database Name that Exchequer SQL is using' +
      ':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label5: TLabel [8]
    Left = 168
    Top = 251
    Width = 156
    Height = 14
    Caption = 'SQL Server Connection Protocol'
  end
  inherited HelpBtn: TButton
    Top = 378
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
    TabOrder = 5
  end
  inherited Panel1: TPanel
    Height = 344
    TabOrder = 4
    inherited Image1: TImage
      Height = 342
    end
  end
  inherited ExitBtn: TButton
    Top = 378
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
    TabOrder = 6
  end
  inherited BackBtn: TButton
    Left = 330
    Top = 378
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
    TabOrder = 7
  end
  inherited NextBtn: TButton
    Left = 416
    Top = 378
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
    TabOrder = 8
  end
  object btnBrowse: TButton
    Left = 417
    Top = 114
    Width = 79
    Height = 23
    Caption = '&Browse...'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnBrowseClick
  end
  object edtSqlServer: TEdit
    Left = 192
    Top = 114
    Width = 217
    Height = 22
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = ValidateEntries
  end
  object edtInstance: TEdit
    Left = 192
    Top = 190
    Width = 217
    Height = 22
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object edtDatabase: TEdit
    Left = 192
    Top = 338
    Width = 217
    Height = 22
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnChange = ValidateEntries
  end
  object comboConnectionProtocol: TComboBox
    Left = 192
    Top = 272
    Width = 217
    Height = 22
    ItemHeight = 14
    TabOrder = 9
    Text = 'TCP/IP (Recommended)'
    Items.Strings = (
      'TCP/IP (Recommended)'
      'Named Pipes'
      'SQL Server Default')
  end
end
