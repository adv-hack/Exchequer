object frmUserManagement: TfrmUserManagement
  Left = 186
  Top = 235
  Width = 887
  Height = 338
  HelpContext = 389
  Caption = 'User Management'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poDefault
  Scaled = False
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  OnShow = FormShow
  TextHeight = 14
  object lvUsers: TListView
    Left = 5
    Top = 5
    Width = 772
    Height = 180
    HelpContext = 2301
    Color = clWhite
    Columns = <
      item
        Caption = 'User Name'
        MinWidth = 75
        Width = 110
      end
      item
        Caption = 'Full Name'
        MinWidth = 70
        Width = 150
      end
      item
        Caption = 'Email Address'
        MinWidth = 100
        Width = 235
      end
      item
        Caption = 'Windows User ID'
        MinWidth = 120
        Width = 165
      end
      item
        Caption = 'Status'
        MinWidth = 60
        Width = 135
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    FullDrag = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
    OnCustomDrawItem = lvUsersCustomDrawItem
    OnDblClick = lvUsersDblClick
    OnSelectItem = lvUsersSelectItem
  end
  object btnAddUser: TButton
    Left = 785
    Top = 56
    Width = 80
    Height = 21
    HelpContext = 393
    Action = actAdd
    TabOrder = 1
  end
  object btnClose: TButton
    Left = 785
    Top = 27
    Width = 80
    Height = 21
    Action = actClose
    Cancel = True
    TabOrder = 11
  end
  object btnEditUser: TButton
    Left = 785
    Top = 79
    Width = 80
    Height = 21
    HelpContext = 397
    Action = actEdit
    TabOrder = 2
  end
  object btnDeleteUser: TButton
    Left = 785
    Top = 102
    Width = 80
    Height = 21
    HelpContext = 396
    Action = actDelete
    TabOrder = 3
  end
  object btnCopyUser: TButton
    Left = 785
    Top = 125
    Width = 80
    Height = 21
    HelpContext = 395
    Action = actCopy
    TabOrder = 4
  end
  object btnResetCustom: TButton
    Left = 785
    Top = 148
    Width = 80
    Height = 21
    HelpContext = 1245
    Action = actResetCustom
    TabOrder = 5
  end
  object btnPrintSettings: TButton
    Left = 785
    Top = 171
    Width = 80
    Height = 21
    HelpContext = 1769
    Action = actPrintSettings
    TabOrder = 6
  end
  object btnResetPassword: TButton
    Left = 785
    Top = 217
    Width = 80
    Height = 21
    HelpContext = 2303
    Action = actResetPassword
    TabOrder = 8
  end
  object btnImportUsers: TButton
    Left = 785
    Top = 240
    Width = 80
    Height = 21
    HelpContext = 2304
    Action = actImportUsers
    TabOrder = 9
  end
  object btnConfiguration: TButton
    Left = 785
    Top = 263
    Width = 80
    Height = 21
    HelpContext = 2305
    Action = actConfiguration
    TabOrder = 10
  end
  object btnChangePassword: TButton
    Left = 785
    Top = 194
    Width = 80
    Height = 21
    HelpContext = 2302
    Action = actChangePassword
    TabOrder = 7
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 564
    Top = 61
  end
  object PopupMenu1: TPopupMenu
    Left = 326
    Top = 94
    object mnuAdd: TMenuItem
      Action = actAdd
    end
    object mnuEdit: TMenuItem
      Action = actEdit
    end
    object mnuDelete: TMenuItem
      Action = actDelete
    end
    object mnuCopy: TMenuItem
      Action = actCopy
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mnuResetCustom: TMenuItem
      Action = actResetCustom
    end
    object mnuPrintSettings: TMenuItem
      Action = actPrintSettings
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object mnuChangePassword: TMenuItem
      Action = actChangePassword
      Caption = '&Change Password'
    end
    object mnuResetPassword: TMenuItem
      Action = actResetPassword
      Caption = 'Re&set Password'
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuImportUsers: TMenuItem
      Action = actImportUsers
    end
    object mnuConfiguration: TMenuItem
      Action = actConfiguration
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Properties1: TMenuItem
      Action = actProperties
    end
    object SaveCoordinates1: TMenuItem
      AutoCheck = True
      Caption = '&Save Coordinates'
    end
  end
  object alMain: TActionList
    Left = 411
    Top = 65
    object actClose: TAction
      Caption = 'C&lose'
      OnExecute = actCloseExecute
    end
    object actAdd: TAction
      Caption = '&Add'
      HelpContext = 393
      Hint = 'Setup a New User'
      OnExecute = actAddExecute
    end
    object actEdit: TAction
      Caption = '&Edit'
      HelpContext = 397
      Hint = 'Edit Selected User'
      OnExecute = actEditExecute
    end
    object actCopy: TAction
      Caption = 'Cop&y'
      HelpContext = 395
      Hint = 'Copy Selected User Profile'
      OnExecute = actCopyExecute
    end
    object actDelete: TAction
      Caption = '&Delete'
      HelpContext = 396
      Hint = 'Delete Selected User'
      OnExecute = actDeleteExecute
    end
    object actResetCustom: TAction
      Caption = '&Reset Custom'
      HelpContext = 1245
      Hint = 'Reset all Custom Settings'
      OnExecute = actResetCustomExecute
    end
    object actPrintSettings: TAction
      Caption = '&Print Settings'
      HelpContext = 1769
      Hint = 'Print Password Options'
      OnExecute = actPrintSettingsExecute
    end
    object actChangePassword: TAction
      Caption = '&Change Pword'
      Hint = 'Change Password for selected User'
      OnExecute = actChangePasswordExecute
    end
    object actResetPassword: TAction
      Caption = 'Re&set Pword'
      Hint = 'Reset Password and Email to User'
      OnExecute = actResetPasswordExecute
    end
    object actImportUsers: TAction
      Caption = '&Import Users'
      Hint = 'Import User details from CSV file'
      OnExecute = actImportUsersExecute
    end
    object actConfiguration: TAction
      Caption = 'Configuratio&n'
      Hint = 'Allows User to Configure Password settings'
      OnExecute = actConfigurationExecute
    end
    object actProperties: TAction
      Caption = 'Properties'
      Hint = 'Access Colour & Font settings'
      OnExecute = actPropertiesExecute
    end
  end
end
