object Form1: TForm1
  Left = 45
  Top = 274
  HelpContext = 10005
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Form1'
  ClientHeight = 178
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 4
    Top = 4
    Width = 337
    Height = 93
    Caption = 'Select Directory'
    TabOrder = 0
    object Label2: TLabel
      Left = 9
      Top = 20
      Width = 24
      Height = 13
      Caption = 'Type'
    end
    object Label3: TLabel
      Left = 19
      Top = 47
      Width = 16
      Height = 13
      Caption = 'Dir:'
    end
    object Button1: TButton
      Left = 254
      Top = 14
      Width = 75
      Height = 25
      Caption = 'Select'
      TabOrder = 0
      OnClick = Button1Click
    end
    object DirType: TComboBox
      Left = 39
      Top = 18
      Width = 201
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'A - Install Connectivity Kit'
        'B - Upgrade Connectivity Kit'
        'C - Install New Company - System'
        'c - Install New Company - Data'
        'I - Install Enterprise'
        'K - ConnKit - New Company - System Dir'
        'k - ConnKit - New Company - Data Dir'
        'N - Network Enterprise Directory'
        'n - Local Enterprise Directory'
        'R - Register'
        'r - Register - Connectivity Kit'
        'T - Toolkit DLL'
        'U - Upgrade from Exchequer'
        'u - Upgrade Enterprise'
        'V - Compass - Enterprise Directory'
        'v - Customisation - Enterprise Directory'
        'W - Workstation'
        'w - Workstation - Connectivity Kit'
        'X - Crystal Reports Directory'
        'Y - Configure Toolkit'
        'y - Configure Toolkit - Data Directory'
        'Z - Install Toolkit DLL'
        'z - Upgrade Existing Toolkit DLL'
        '')
    end
    object DefDir: TComboBox
      Left = 39
      Top = 43
      Width = 202
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = 'c:\progra~1\sbs\enterp~1\'
      Items.Strings = (
        'c:\progra~1\sbs\enterp~1\')
    end
    object CB_MC: TCheckBox
      Left = 39
      Top = 70
      Width = 97
      Height = 17
      Caption = 'Multi-Currency'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 99
    Width = 337
    Height = 53
    Caption = 'Disk Space Check'
    TabOrder = 1
    object Label1: TLabel
      Left = 18
      Top = 25
      Width = 16
      Height = 13
      Caption = 'Dir:'
    end
    object Button2: TButton
      Left = 254
      Top = 17
      Width = 75
      Height = 25
      Caption = 'Check'
      TabOrder = 0
      OnClick = Button2Click
    end
    object SpaceDir: TComboBox
      Left = 38
      Top = 21
      Width = 202
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = 'd:\'
      Items.Strings = (
        'c:\'
        'c:\progra~1\sbs\enterp~1\'
        'd:\'
        'd:\enterprise\')
    end
  end
end
