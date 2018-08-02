object frmDetail: TfrmDetail
  Left = 380
  Top = 59
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exchequer Enterprise Plug-In Release Code Utility '
  ClientHeight = 541
  ClientWidth = 454
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object panCustHdr: TPanel
    Left = 0
    Top = 0
    Width = 454
    Height = 61
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label82: Label8
      Left = 9
      Top = 42
      Width = 83
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'A/C Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblAcName: Label8
      Left = 167
      Top = 43
      Width = 52
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Company'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Panel2: TPanel
      Left = 5
      Top = 3
      Width = 443
      Height = 31
      BevelOuter = bvLowered
      Color = clBtnShadow
      TabOrder = 0
      object Label2: TLabel
        Left = 6
        Top = 6
        Width = 251
        Height = 19
        AutoSize = False
        Caption = 'Customer Details'
        Color = clBtnShadow
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
      end
    end
    object edtAcCode: TEdit
      Tag = 1001
      Left = 98
      Top = 39
      Width = 66
      Height = 22
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      MaxLength = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object edtAcName: TEdit
      Tag = 1001
      Left = 223
      Top = 39
      Width = 215
      Height = 22
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
  end
  object panCustDets: TPanel
    Left = 0
    Top = 61
    Width = 454
    Height = 218
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label87: Label8
      Left = 9
      Top = 33
      Width = 83
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Address'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label88: Label8
      Left = 9
      Top = 147
      Width = 83
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Telephone'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label89: Label8
      Left = 9
      Top = 173
      Width = 81
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Email Address'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label816: Label8
      Left = 9
      Top = 7
      Width = 83
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Contact'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label817: Label8
      Left = 9
      Top = 198
      Width = 83
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Comments'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object edtAcAddr1: TEdit
      Tag = 1001
      Left = 98
      Top = 30
      Width = 340
      Height = 22
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object edtAcPhone: TEdit
      Tag = 1001
      Left = 98
      Top = 144
      Width = 148
      Height = 22
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
    object edtAcEmail: TEdit
      Tag = 1001
      Left = 98
      Top = 170
      Width = 340
      Height = 22
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
    end
    object edtAcContact: TEdit
      Tag = 1001
      Left = 98
      Top = 4
      Width = 340
      Height = 22
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object edtComments: TEdit
      Tag = 1001
      Left = 98
      Top = 196
      Width = 340
      Height = 22
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
    end
    object edtAcAddr2: TEdit
      Tag = 1001
      Left = 98
      Top = 52
      Width = 340
      Height = 22
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object edtAcAddr3: TEdit
      Tag = 1001
      Left = 98
      Top = 74
      Width = 340
      Height = 22
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object edtAcAddr4: TEdit
      Tag = 1001
      Left = 98
      Top = 96
      Width = 340
      Height = 22
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object edtAcAddr5: TEdit
      Tag = 1001
      Left = 98
      Top = 118
      Width = 340
      Height = 22
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
  end
  object panSecurity: TPanel
    Left = 0
    Top = 279
    Width = 454
    Height = 255
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label81: Label8
      Left = 5
      Top = 78
      Width = 86
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Site ESN'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblSystemType: Label8
      Left = 9
      Top = 181
      Width = 82
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblSystemSecurity: Label8
      Left = 9
      Top = 156
      Width = 82
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Security Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblSystemRelease: Label8
      Left = 9
      Top = 232
      Width = 82
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Release Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label810: Label8
      Left = 9
      Top = 45
      Width = 80
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Current Date'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label811: Label8
      Left = 207
      Top = 45
      Width = 111
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Plug-In Password'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblUserCountHdr: TLabel
      Left = 239
      Top = 129
      Width = 189
      Height = 18
      AutoSize = False
      Caption = 'User Count Security'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      PopupMenu = popPlugInConfig
    end
    object lblUserCount: Label8
      Left = 237
      Top = 181
      Width = 76
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'User Count'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblUserSecurity: Label8
      Left = 237
      Top = 155
      Width = 78
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Security Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object lblUserRelease: Label8
      Left = 237
      Top = 232
      Width = 80
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Release Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Bevel1: TBevel
      Left = 9
      Top = 69
      Width = 429
      Height = 2
      Shape = bsTopLine
    end
    object Label815: Label8
      Left = 5
      Top = 104
      Width = 86
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Plug-In'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object shSysSecHdr: TShape
      Left = 10
      Top = 145
      Width = 202
      Height = 2
    end
    object shUserCountHdr: TShape
      Left = 239
      Top = 145
      Width = 200
      Height = 2
    end
    object lblSysSecHdr: TLabel
      Left = 11
      Top = 129
      Width = 199
      Height = 15
      AutoSize = False
      Caption = 'System Security'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      PopupMenu = popPlugInConfig
    end
    object Panel1: TPanel
      Left = 5
      Top = 6
      Width = 442
      Height = 31
      BevelOuter = bvLowered
      Color = clBtnShadow
      TabOrder = 13
      object Label1: TLabel
        Left = 6
        Top = 6
        Width = 366
        Height = 19
        AutoSize = False
        Caption = 'Security Details'
        Color = clBtnShadow
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
      end
    end
    object udUserCount: TUpDown
      Left = 361
      Top = 178
      Width = 12
      Height = 22
      Associate = edtUserCount
      Min = 1
      Max = 999
      Position = 1
      TabOrder = 10
      Wrap = False
    end
    object lstPlugIns: TComboBox
      Left = 98
      Top = 101
      Width = 339
      Height = 22
      Style = csDropDownList
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemHeight = 14
      ParentFont = False
      PopupMenu = popPlugInConfig
      TabOrder = 3
      OnClick = lstPlugInsClick
    end
    object btnGenSystemRelCode: TButton
      Left = 10
      Top = 204
      Width = 202
      Height = 21
      Caption = 'Generate Release Code'
      TabOrder = 7
      OnClick = btnGenSystemRelCodeClick
    end
    object lstSystemType: TComboBox
      Left = 98
      Top = 178
      Width = 70
      Height = 22
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemHeight = 14
      ParentFont = False
      TabOrder = 5
      Text = '30-Day'
      OnClick = lstSystemTypeClick
      Items.Strings = (
        '30-Day'
        'Full')
    end
    object edtSystemSecurity: TEdit
      Tag = 1
      Left = 98
      Top = 152
      Width = 111
      Height = 22
      CharCase = ecUpperCase
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      MaxLength = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnChange = lstSystemTypeClick
      OnDblClick = DispPhoneticCode
    end
    object edtSystemRelease: TEdit
      Tag = 2
      Left = 98
      Top = 229
      Width = 111
      Height = 22
      CharCase = ecUpperCase
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      MaxLength = 10
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 6
      OnDblClick = DispPhoneticCode
    end
    object edtCurrDate: TEdit
      Tag = 1001
      Left = 98
      Top = 42
      Width = 78
      Height = 22
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      MaxLength = 10
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
    end
    object edtPlugInPW: TEdit
      Left = 326
      Top = 42
      Width = 111
      Height = 22
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
      OnDblClick = edtPlugInPWDblClick
    end
    object edtUserCount: TEdit
      Tag = 1001
      Left = 326
      Top = 178
      Width = 35
      Height = 22
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      MaxLength = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      Text = '1'
      OnChange = edtUserSecurityChange
    end
    object edtUserSecurity: TEdit
      Tag = 1001
      Left = 326
      Top = 152
      Width = 111
      Height = 22
      CharCase = ecUpperCase
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      MaxLength = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnChange = edtUserSecurityChange
      OnDblClick = DispPhoneticCode
    end
    object edtUserRelease: TEdit
      Tag = 1002
      Left = 326
      Top = 229
      Width = 111
      Height = 22
      CharCase = ecUpperCase
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      MaxLength = 10
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 11
      OnDblClick = DispPhoneticCode
    end
    object meCustESN: TMaskEdit
      Tag = 1001
      Left = 98
      Top = 75
      Width = 169
      Height = 22
      Color = clTeal
      EditMask = '999-999-999-999-999-999-999;1;_'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      MaxLength = 27
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '   -   -   -   -   -   -   '
      OnExit = meCustESNExit
    end
    object btnGenUserRelCode: TButton
      Left = 239
      Top = 204
      Width = 200
      Height = 21
      Caption = 'Generate Release Code'
      TabOrder = 12
      OnClick = btnGenUserRelCodeClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 323
    Top = 4
    object File1: TMenuItem
      Caption = '&File'
      object MenuOpt_File_Clear: TMenuItem
        Caption = '&Clear'
        ShortCut = 49219
        OnClick = MenuOpt_File_ClearClick
      end
      object MenuOpt_File_SepBar1: TMenuItem
        Caption = '-'
      end
      object MenuOpt_File_Logout: TMenuItem
        Caption = '&Logout'
        OnClick = MenuOpt_File_LogoutClick
      end
      object MenuOpt_File_Exit: TMenuItem
        Caption = 'E&xit'
        OnClick = MenuOpt_File_ExitClick
      end
    end
    object Options1: TMenuItem
      Caption = '&Options'
      object MenuOpt_Options_ChangeUserPW: TMenuItem
        Caption = 'Change User Password'
        OnClick = MenuOpt_Options_ChangeUserPWClick
      end
      object MenuOpt_Options_ChangeMasterPW: TMenuItem
        Caption = 'Change Master Password'
        OnClick = MenuOpt_Options_ChangeMasterPWClick
      end
      object MenuOpt_Options_SepBar1: TMenuItem
        Caption = '-'
      end
      object MenuOpt_Options_ShowCustDets: TMenuItem
        AutoCheck = True
        Caption = 'Show Customer Detail'
        Checked = True
        OnClick = MenuOpt_Options_ShowCustDetsClick
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About...'
        OnClick = About1Click
      end
    end
  end
  object popPlugInConfig: TPopupMenu
    Left = 11
    Top = 364
    object Menu_Popup_System: TMenuItem
      AutoCheck = True
      Caption = 'Show System Security'
      OnClick = Menu_Popup_SystemClick
    end
    object Menu_Popup_ShowUserCount: TMenuItem
      AutoCheck = True
      Caption = 'Show User Count Security'
      OnClick = Menu_Popup_ShowUserCountClick
    end
  end
end
