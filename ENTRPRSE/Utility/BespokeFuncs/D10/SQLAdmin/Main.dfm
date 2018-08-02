object frmBespokeSQLAdmin: TfrmBespokeSQLAdmin
  Left = 355
  Top = 295
  BorderStyle = bsSingle
  Caption = 'Bespoke SQL Administrator'
  ClientHeight = 390
  ClientWidth = 609
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object btnClose: TButton
    Left = 520
    Top = 360
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 0
    OnClick = btnCloseClick
  end
  object pcTabs: TPageControl
    Left = 8
    Top = 8
    Width = 593
    Height = 345
    ActivePage = tsDatabases
    TabIndex = 3
    TabOrder = 1
    object tsExchequer: TTabSheet
      Caption = 'IRIS Exchequer'
      object bvIRISExchequer: TBevel
        Left = 8
        Top = 16
        Width = 569
        Height = 113
        Shape = bsFrame
      end
      object lExchSQLDBNameTit: TLabel
        Left = 24
        Top = 72
        Width = 185
        Height = 14
        Caption = 'IRIS Exchequer SQL Database Name : '
      end
      object lExchSQLDBName: TLabel
        Left = 208
        Top = 72
        Width = 361
        Height = 13
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lExchSQLServerNameTit: TLabel
        Left = 24
        Top = 96
        Width = 172
        Height = 14
        Caption = 'IRIS Exchequer SQL Server Name : '
      end
      object lExchSQLServerName: TLabel
        Left = 208
        Top = 96
        Width = 361
        Height = 13
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lIRISExchequer: TLabel
        Left = 16
        Top = 8
        Width = 81
        Height = 14
        Caption = 'IRIS Exchequer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        Left = 24
        Top = 32
        Width = 158
        Height = 14
        Caption = 'IRIS Exchequer Database Type : '
      end
      object lExchDBType: TLabel
        Left = 208
        Top = 32
        Width = 69
        Height = 14
        Caption = 'lExchDBType'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel1: TBevel
        Left = 8
        Top = 56
        Width = 569
        Height = 73
        Shape = bsFrame
      end
    end
    object tsReadOnly: TTabSheet
      Caption = 'Read Only User'
      ImageIndex = 1
      object Bevel2: TBevel
        Left = 8
        Top = 16
        Width = 569
        Height = 289
        Shape = bsFrame
      end
      object Label4: TLabel
        Left = 24
        Top = 68
        Width = 59
        Height = 14
        Caption = 'User Name :'
      end
      object Label5: TLabel
        Left = 16
        Top = 8
        Width = 108
        Height = 14
        Caption = 'Read Only SQL User'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 24
        Top = 92
        Width = 59
        Height = 14
        Caption = 'Password : '
      end
      object lROUserDatabases: TLabel
        Left = 24
        Top = 124
        Width = 84
        Height = 14
        Caption = 'User Databases :'
      end
      object Label13: TLabel
        Left = 24
        Top = 36
        Width = 66
        Height = 14
        Caption = 'Login Status :'
      end
      object lROLoginStatus: TLabel
        Left = 160
        Top = 36
        Width = 71
        Height = 14
        Caption = '(not created)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edROUserName: TEdit
        Left = 160
        Top = 64
        Width = 193
        Height = 22
        PasswordChar = '*'
        ReadOnly = True
        TabOrder = 0
      end
      object edROPassword: TEdit
        Left = 160
        Top = 88
        Width = 193
        Height = 22
        PasswordChar = '*'
        ReadOnly = True
        TabOrder = 1
      end
      object btnSaveROUser: TButton
        Left = 360
        Top = 65
        Width = 75
        Height = 22
        Caption = 'Save'
        Enabled = False
        TabOrder = 2
        OnClick = btnSaveROUserClick
      end
      object btnSaveROPassword: TButton
        Left = 360
        Top = 89
        Width = 75
        Height = 22
        Caption = 'Save'
        Enabled = False
        TabOrder = 3
        OnClick = btnSaveROPasswordClick
      end
      object btnROCreateAll: TButton
        Left = 160
        Top = 265
        Width = 273
        Height = 22
        Caption = 'Create Users for all Databases'
        TabOrder = 4
        OnClick = btnROCreateAllClick
      end
      object btnCreateROLogin: TButton
        Left = 360
        Top = 33
        Width = 75
        Height = 22
        Caption = 'Create Login'
        TabOrder = 5
        OnClick = btnCreateROLoginClick
      end
      object lbROUserDatabases: TListBox
        Left = 160
        Top = 120
        Width = 273
        Height = 137
        ItemHeight = 14
        TabOrder = 6
      end
    end
    object tsReadWrite: TTabSheet
      Caption = 'Read/Write User'
      ImageIndex = 3
      object Bevel4: TBevel
        Left = 8
        Top = 16
        Width = 569
        Height = 289
        Shape = bsFrame
      end
      object Label6: TLabel
        Left = 24
        Top = 68
        Width = 59
        Height = 14
        Caption = 'User Name :'
      end
      object Label8: TLabel
        Left = 24
        Top = 92
        Width = 56
        Height = 14
        Caption = 'Password :'
      end
      object Label15: TLabel
        Left = 24
        Top = 36
        Width = 66
        Height = 14
        Caption = 'Login Status :'
      end
      object lRWUserDatabases: TLabel
        Left = 24
        Top = 124
        Width = 84
        Height = 14
        Caption = 'User Databases :'
      end
      object lRWLoginStatus: TLabel
        Left = 160
        Top = 36
        Width = 71
        Height = 14
        Caption = '(not created)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label17: TLabel
        Left = 16
        Top = 8
        Width = 113
        Height = 14
        Caption = 'Read Write SQL User'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edRWPassword: TEdit
        Left = 160
        Top = 88
        Width = 193
        Height = 22
        PasswordChar = '*'
        ReadOnly = True
        TabOrder = 0
      end
      object edRWUserName: TEdit
        Left = 160
        Top = 64
        Width = 193
        Height = 22
        PasswordChar = '*'
        ReadOnly = True
        TabOrder = 1
      end
      object btnSaveRWUser: TButton
        Left = 360
        Top = 65
        Width = 75
        Height = 22
        Caption = 'Save'
        Enabled = False
        TabOrder = 2
        OnClick = btnSaveRWUserClick
      end
      object btnSaveRWPassword: TButton
        Left = 360
        Top = 89
        Width = 75
        Height = 22
        Caption = 'Save'
        Enabled = False
        TabOrder = 3
        OnClick = btnSaveRWPasswordClick
      end
      object btnCreateRWLogin: TButton
        Left = 360
        Top = 33
        Width = 75
        Height = 22
        Caption = 'Create Login'
        TabOrder = 4
        OnClick = btnCreateRWLoginClick
      end
      object lbRWUserDatabases: TListBox
        Left = 160
        Top = 120
        Width = 273
        Height = 137
        ItemHeight = 14
        TabOrder = 5
      end
      object btnRWCreateAll: TButton
        Left = 160
        Top = 265
        Width = 273
        Height = 22
        Caption = 'Create Users for all Databases'
        TabOrder = 6
        OnClick = btnRWCreateAllClick
      end
    end
    object tsDatabases: TTabSheet
      Caption = 'Databases'
      ImageIndex = 2
      object Bevel3: TBevel
        Left = 8
        Top = 16
        Width = 569
        Height = 289
        Shape = bsFrame
      end
      object Label9: TLabel
        Left = 16
        Top = 8
        Width = 168
        Height = 14
        Caption = 'Bespoke SQL Database Names'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnAdd: TButton
        Left = 16
        Top = 272
        Width = 73
        Height = 21
        Caption = '&Add'
        TabOrder = 0
        OnClick = btnAddClick
      end
      object btnEdit: TButton
        Left = 96
        Top = 272
        Width = 80
        Height = 21
        Caption = '&Edit'
        TabOrder = 1
        OnClick = btnEditClick
      end
      object btnDelete: TButton
        Left = 184
        Top = 272
        Width = 80
        Height = 21
        Caption = '&Delete'
        TabOrder = 2
        OnClick = btnDeleteClick
      end
      object mlDatabases: TMultiList
        Left = 16
        Top = 32
        Width = 553
        Height = 233
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Code'
            Width = 131
          end
          item
            Caption = 'Description'
            Width = 200
          end
          item
            Caption = 'Database'
            Width = 180
          end>
        TabStop = True
        OnCellPaint = mlDatabasesCellPaint
        OnRowDblClick = mlDatabasesRowDblClick
        TabOrder = 3
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Arial'
        HeaderFont.Style = []
        HighlightFont.Charset = DEFAULT_CHARSET
        HighlightFont.Color = clWhite
        HighlightFont.Height = -11
        HighlightFont.Name = 'Arial'
        HighlightFont.Style = []
        MultiSelectFont.Charset = DEFAULT_CHARSET
        MultiSelectFont.Color = clWindowText
        MultiSelectFont.Height = -11
        MultiSelectFont.Name = 'Arial'
        MultiSelectFont.Style = []
        Version = 'v1.13'
      end
      object btnGetConnectionString: TButton
        Left = 448
        Top = 272
        Width = 121
        Height = 21
        Caption = '&Get Connection String'
        TabOrder = 4
        OnClick = btnGetConnectionStringClick
      end
      object btnTables: TButton
        Left = 360
        Top = 272
        Width = 80
        Height = 21
        Caption = '&Tables'
        TabOrder = 5
        OnClick = btnTablesClick
      end
      object btnView: TButton
        Left = 272
        Top = 272
        Width = 80
        Height = 21
        Caption = '&View'
        TabOrder = 6
        OnClick = btnViewClick
      end
    end
  end
  object MainMenu1: TMainMenu
    object File1: TMenuItem
      Caption = '&File'
      object Login1: TMenuItem
        Caption = '&Login'
        OnClick = Login1Click
      end
      object ResetXMLFile1: TMenuItem
        Caption = 'Reset XML File'
        OnClick = ResetXMLFile1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About'
        OnClick = About1Click
      end
    end
  end
end
