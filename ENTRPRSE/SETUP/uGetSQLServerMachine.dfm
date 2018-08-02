inherited frmGetSQLServerMachine: TfrmGetSQLServerMachine
  Left = 519
  Top = 207
  HelpContext = 120
  Caption = 'SQL Server Database'
  ClientHeight = 366
  ClientWidth = 509
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 321
    Width = 486
  end
  inherited TitleLbl: TLabel
    Width = 334
    Caption = 'MS SQL Server Location'
  end
  inherited InstrLbl: TLabel
    Width = 331
    Caption = 
      'In order to create the Exchequer SQL Database we need to know wh' +
      'ere to find your Microsoft SQL Server Database Engine.'
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
  end
  inherited imgSide: TImage
    Height = 210
  end
  object Label1: TLabel [4]
    Left = 167
    Top = 85
    Width = 331
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
    Top = 152
    Width = 330
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
    Top = 226
    Width = 331
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
    Top = 262
    Width = 331
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Please select the protocol which Exchequer will use to talk to M' +
      'icrosoft SQL Server :-'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Top = 338
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
    TabOrder = 4
  end
  inherited Panel1: TPanel
    Height = 304
    TabOrder = 3
    inherited Image1: TImage
      Height = 302
    end
  end
  inherited ExitBtn: TButton
    Top = 338
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
    TabOrder = 5
  end
  inherited BackBtn: TButton
    Left = 332
    Top = 338
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
    TabOrder = 6
  end
  inherited NextBtn: TButton
    Left = 418
    Top = 338
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
    TabOrder = 7
  end
  object btnBrowse: TButton
    Left = 417
    Top = 122
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
    Left = 195
    Top = 122
    Width = 214
    Height = 22
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object edtInstance: TEdit
    Left = 195
    Top = 198
    Width = 214
    Height = 22
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object cbSQLProtocol: TComboBox
    Left = 195
    Top = 295
    Width = 214
    Height = 22
    Style = csDropDownList
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 8
    Items.Strings = (
      'TCP/IP (Recommended)'
      'Named Pipes'
      'SQL Server Default')
  end
end
