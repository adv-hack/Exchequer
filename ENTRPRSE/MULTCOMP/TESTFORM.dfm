object Form1: TForm1
  Left = 85
  Top = 72
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Installation Functions'
  ClientHeight = 428
  ClientWidth = 518
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 4
    Top = 2
    Width = 510
    Height = 46
    Caption = ' RegisterSystem '
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 19
      Width = 59
      Height = 13
      Caption = 'System Path'
    end
    object Button1: TButton
      Left = 423
      Top = 13
      Width = 79
      Height = 25
      Caption = 'Register '
      TabOrder = 3
      OnClick = Button1Click
    end
    object SysPath: TEdit
      Left = 73
      Top = 16
      Width = 112
      Height = 21
      TabOrder = 0
      Text = 'c:\develop\entrprse\'
    end
    object OCXOnly: TCheckBox
      Left = 195
      Top = 18
      Width = 73
      Height = 17
      Caption = 'OCX Only'
      TabOrder = 1
    end
    object MultiUserBtr: TCheckBox
      Left = 270
      Top = 18
      Width = 71
      Height = 17
      Caption = 'Multi-User'
      TabOrder = 2
    end
    object Connect: TCheckBox
      Left = 350
      Top = 18
      Width = 67
      Height = 17
      Caption = 'Connect'
      TabOrder = 4
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 49
    Width = 510
    Height = 46
    Caption = ' SetClServer '
    TabOrder = 1
    object ClServer: TCheckBox
      Left = 13
      Top = 19
      Width = 85
      Height = 17
      Caption = 'Client-Server'
      TabOrder = 0
    end
    object Button2: TButton
      Left = 423
      Top = 13
      Width = 79
      Height = 25
      Caption = 'Set ClServer'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 4
    Top = 97
    Width = 510
    Height = 71
    Caption = ' InitCompany '
    TabOrder = 2
    object Label2: TLabel
      Left = 12
      Top = 19
      Width = 33
      Height = 13
      Caption = 'ExeDir'
    end
    object Label3: TLabel
      Left = 9
      Top = 43
      Width = 36
      Height = 13
      Caption = 'DataDir'
    end
    object Label4: TLabel
      Left = 202
      Top = 19
      Width = 24
      Height = 13
      Caption = 'Type'
    end
    object Label11: TLabel
      Left = 203
      Top = 43
      Width = 30
      Height = 13
      Caption = 'InstDir'
    end
    object Button3: TButton
      Left = 423
      Top = 13
      Width = 79
      Height = 25
      Caption = 'Setup'
      TabOrder = 4
      OnClick = Button3Click
    end
    object ExeDir: TEdit
      Left = 50
      Top = 16
      Width = 145
      Height = 21
      TabOrder = 0
      Text = 'c:\develop\entrprse\'
    end
    object DataDir: TEdit
      Left = 50
      Top = 40
      Width = 145
      Height = 21
      TabOrder = 1
      Text = 'c:\develop\entrprse\comp\aard01\'
    end
    object TypeList: TComboBox
      Left = 237
      Top = 16
      Width = 179
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      Items.Strings = (
        'Full Installation with Demo Data'
        'Blank Installation'
        'Upgrade existing Exchequer DOS'
        'Upgrade existing Exchequer'
        'Workstation Setup'
        'Additional Company (Blank)'
        'Register OLE Components'
        'Additional Company (Demo)')
      TabOrder = 2
    end
    object InstDir: TEdit
      Left = 236
      Top = 40
      Width = 179
      Height = 21
      TabOrder = 3
      Text = 'g:\entbtr7\'
    end
  end
  object GroupBox7: TGroupBox
    Left = 4
    Top = 170
    Width = 510
    Height = 46
    Caption = ' File Replication '
    TabOrder = 3
    object Label5: TLabel
      Left = 12
      Top = 19
      Width = 33
      Height = 13
      Caption = 'ExeDir'
    end
    object Button7: TButton
      Left = 423
      Top = 13
      Width = 79
      Height = 25
      Caption = 'Replicate'
      TabOrder = 1
      OnClick = Button7Click
    end
    object ExeDir2: TEdit
      Left = 50
      Top = 16
      Width = 234
      Height = 21
      TabOrder = 0
      Text = 'c:\progra~1\sbs\enterp~1\'
    end
  end
  object GroupBox4: TGroupBox
    Left = 4
    Top = 218
    Width = 510
    Height = 68
    Caption = ' Data Replication '
    TabOrder = 4
    object Label6: TLabel
      Left = 12
      Top = 19
      Width = 33
      Height = 13
      Caption = 'ExeDir'
    end
    object Label7: TLabel
      Left = 9
      Top = 43
      Width = 36
      Height = 13
      Caption = 'DataDir'
    end
    object Button4: TButton
      Left = 423
      Top = 13
      Width = 79
      Height = 25
      Caption = 'Copy'
      TabOrder = 0
      OnClick = Button4Click
    end
    object ExeDir3: TComboBox
      Left = 50
      Top = 16
      Width = 259
      Height = 21
      ItemHeight = 13
      Items.Strings = (
        'c:\develop\entrprse\'
        'c:\progra~1\sbs\company\'
        'c:\progra~1\sbs\enterp~1\'
        'c:\progra~1\sbs\enterp~1\company\'
        'c:\progra~1\sbs\ent1\'
        'c:\progra~1\sbs\ent1\company\aa01\')
      TabOrder = 1
      Text = 'c:\progra~1\sbs\enterp~1\'
    end
    object DataDir3: TComboBox
      Left = 50
      Top = 40
      Width = 259
      Height = 21
      ItemHeight = 13
      Items.Strings = (
        'c:\progra~1\sbs\ent1\company\aa02\'
        'c:\develop\entrprse\'
        'c:\progra~1\sbs\company\'
        'c:\progra~1\sbs\enterp~1\'
        'c:\progra~1\sbs\enterp~1\company\'
        'c:\progra~1\sbs\ent1\company\aa01\')
      TabOrder = 2
      Text = 'c:\progra~1\sbs\enterp~1\company\aa02\'
    end
  end
  object GroupBox5: TGroupBox
    Left = 4
    Top = 287
    Width = 510
    Height = 44
    Caption = ' Companies Wizard '
    TabOrder = 5
    object Label8: TLabel
      Left = 12
      Top = 19
      Width = 33
      Height = 13
      Caption = 'ExeDir'
    end
    object Button5: TButton
      Left = 423
      Top = 13
      Width = 79
      Height = 25
      Caption = 'Start Wizzing'
      TabOrder = 0
      OnClick = Button5Click
    end
    object ExeDir4: TComboBox
      Left = 51
      Top = 16
      Width = 259
      Height = 21
      ItemHeight = 13
      Items.Strings = (
        'c:\develop\entrprse\'
        'c:\progra~1\sbs\enterp~1\'
        'd:\ent1\'
        'f:\exch\'
        'f:\exch2\')
      TabOrder = 1
      Text = 'f:\exch2\'
    end
  end
  object GroupBox6: TGroupBox
    Left = 4
    Top = 333
    Width = 510
    Height = 44
    Caption = 'Check Batch File'
    TabOrder = 6
    object Label9: TLabel
      Left = 12
      Top = 19
      Width = 33
      Height = 13
      Caption = 'ExeDir'
    end
    object Button6: TButton
      Left = 423
      Top = 13
      Width = 79
      Height = 25
      Caption = 'REX.BAT'
      TabOrder = 0
      OnClick = Button6Click
    end
    object ExeDir7: TComboBox
      Left = 51
      Top = 16
      Width = 259
      Height = 21
      ItemHeight = 13
      Items.Strings = (
        'c:\develop\entrprse\'
        'c:\progra~1\sbs\enterp~1\'
        'd:\ent1\'
        'f:\exch\'
        'f:\exch2\')
      TabOrder = 1
      Text = 'f:\exch2\'
    end
  end
  object GroupBox8: TGroupBox
    Left = 4
    Top = 380
    Width = 510
    Height = 44
    Caption = ' Setup ODBC Data Sources '
    TabOrder = 7
    object Label10: TLabel
      Left = 12
      Top = 19
      Width = 33
      Height = 13
      Caption = 'ExeDir'
    end
    object Button8: TButton
      Left = 423
      Top = 12
      Width = 79
      Height = 25
      Caption = 'Setup'
      TabOrder = 0
      OnClick = Button8Click
    end
    object ExeDir5: TComboBox
      Left = 51
      Top = 16
      Width = 259
      Height = 21
      ItemHeight = 13
      Items.Strings = (
        'c:\develop\entrprse\'
        'c:\progra~1\sbs\enterp~1\'
        'd:\ent1\'
        'f:\exch\'
        'f:\exch2\')
      TabOrder = 1
      Text = 'f:\exch2\'
    end
  end
end
