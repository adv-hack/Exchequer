object frmMain: TfrmMain
  Left = 352
  Top = 145
  ActiveControl = meCustESN
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'frmMain'
  ClientHeight = 257
  ClientWidth = 461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  DesignSize = (
    461
    257)
  PixelsPerInch = 96
  TextHeight = 13
  object Label81: Label8
    Left = 5
    Top = 38
    Width = 100
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
  object Label83: Label8
    Left = 6
    Top = 11
    Width = 100
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Enterprise Version'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Bevel2: TBevel
    Left = 0
    Top = 0
    Width = 461
    Height = 2
    Align = alTop
    Shape = bsTopLine
  end
  object lblESNVersion: Label8
    Left = 287
    Top = 38
    Width = 167
    Height = 14
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object meCustESN: TMaskEdit
    Tag = 1001
    Left = 112
    Top = 34
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
    TabOrder = 1
    Text = '   -   -   -   -   -   -   '
    OnExit = meCustESNExit
  end
  object PageControl1: TPageControl
    Left = 6
    Top = 65
    Width = 450
    Height = 162
    ActivePage = tabshPasswords
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabIndex = 0
    TabOrder = 2
    object tabshPasswords: TTabSheet
      Caption = 'Passwords'
      object Label84: Label8
        Left = 29
        Top = 12
        Width = 100
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Plug-In Pword'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label85: Label8
        Left = 29
        Top = 40
        Width = 100
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'MCM Pword'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label86: Label8
        Left = 20
        Top = 68
        Width = 109
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Daily System Pword'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Bevel1: TBevel
        Left = 2
        Top = 93
        Width = 433
        Height = 2
        Shape = bsTopLine
      end
      object Label9: TLabel
        Left = 15
        Top = 105
        Width = 114
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Reset Ent User Counts'
      end
      object Label82: Label8
        Left = 282
        Top = 32
        Width = 141
        Height = 14
        Alignment = taCenter
        AutoSize = False
        Caption = 'Passwords Expire On'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblPWExpiry: Label8
        Left = 282
        Top = 50
        Width = 141
        Height = 14
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object edtPlugInPw: TEdit
        Tag = 1
        Left = 135
        Top = 8
        Width = 113
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
        OnDblClick = DisplayPhoneticText
      end
      object edtMCMPW: TEdit
        Tag = 2
        Left = 135
        Top = 36
        Width = 113
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
        TabOrder = 1
        OnDblClick = DisplayPhoneticText
      end
      object edtDailyPW: TEdit
        Tag = 3
        Left = 135
        Top = 64
        Width = 113
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
        TabOrder = 2
        OnDblClick = DisplayPhoneticText
      end
      object edtResetUserCount: TEdit
        Tag = 4
        Left = 135
        Top = 101
        Width = 113
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
        TabOrder = 3
        OnDblClick = DisplayPhoneticText
      end
    end
    object tabshEnterpriseSystem: TTabSheet
      Caption = 'Enterprise'
      ImageIndex = 1
      object Label1: TLabel
        Left = 15
        Top = 40
        Width = 114
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'System Security Code'
      end
      object Label2: TLabel
        Left = 15
        Top = 12
        Width = 114
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Release Type'
      end
      object Label3: TLabel
        Left = 15
        Top = 68
        Width = 114
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'System Release Code'
      end
      object edtEntSysSecCode: TEdit
        Tag = 5
        Left = 135
        Top = 36
        Width = 113
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
        TabOrder = 1
        OnDblClick = DisplayPhoneticText
        OnExit = UpdateRelCodes
      end
      object edtEntSysRelCode: TEdit
        Tag = 6
        Left = 135
        Top = 64
        Width = 113
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
        TabOrder = 2
        OnDblClick = DisplayPhoneticText
      end
      object lstEntSysRelType: TComboBox
        Left = 135
        Top = 8
        Width = 93
        Height = 22
        Style = csDropDownList
        Color = clTeal
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 14
        ItemIndex = 0
        ParentFont = False
        TabOrder = 0
        Text = '30-Day'
        OnClick = UpdateRelCodes
        Items.Strings = (
          '30-Day'
          'Full')
      end
    end
  end
  object lstEntVer: TComboBox
    Left = 112
    Top = 8
    Width = 169
    Height = 22
    Color = clTeal
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 14
    ItemIndex = 3
    ParentFont = False
    TabOrder = 0
    Text = 'v5.00 or later'
    OnClick = lstEntVerClick
    Items.Strings = (
      'v4.00 or earlier'
      'v4.30'
      'v4.31 and v4.32'
      'v5.00 or later')
  end
  object Panel1: TPanel
    Left = 0
    Top = 232
    Width = 461
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      461
      25)
    object panDate: TPanel
      Left = 2
      Top = 4
      Width = 169
      Height = 20
      Alignment = taLeftJustify
      BevelOuter = bvLowered
      Caption = '  20/05/02   (Mon)'
      TabOrder = 0
    end
    object panLicencee: TPanel
      Left = 175
      Top = 4
      Width = 284
      Height = 20
      Alignment = taRightJustify
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvLowered
      TabOrder = 1
    end
  end
  object MainMenu1: TMainMenu
    Left = 427
    Top = 4
    object File1: TMenuItem
      Caption = '&File'
      object MenuOpt_File_Exit: TMenuItem
        Caption = 'E&xit'
        OnClick = MenuOpt_File_ExitClick
      end
    end
    object MenuOpt_File_Clear: TMenuItem
      Caption = '&Clear'
      ShortCut = 49219
      OnClick = MenuOpt_File_ClearClick
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About...'
        OnClick = About1Click
      end
    end
  end
end
