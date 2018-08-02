object frmLogin: TfrmLogin
  Left = 368
  Top = 236
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frmLogin'
  ClientHeight = 187
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 393
    Height = 187
    Align = alClient
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 162
      Width = 391
      Height = 24
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object lblCopyright: TLabel
        Left = 8
        Top = 7
        Width = 375
        Height = 17
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'Copyright Exchequer Software Ltd. 1986-2002.  All rights reserve' +
          'd, worldwide.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -9
        Font.Name = 'Small Fonts'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 391
      Height = 91
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 21
        Top = 12
        Width = 350
        Height = 23
        Alignment = taCenter
        AutoSize = False
        Caption = 'Exchequer Enterprise'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object lblVerNo: TLabel
        Left = 5
        Top = 34
        Width = 380
        Height = 31
        Alignment = taCenter
        AutoSize = False
        Caption = 'Distributor Release Code Utility '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object lblLicencee: TLabel
        Left = 7
        Top = 66
        Width = 376
        Height = 19
        Alignment = taCenter
        AutoSize = False
        Caption = 'Reading Licence, Please Wait ...'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
    end
    object panLogin: TPanel
      Left = 1
      Top = 92
      Width = 391
      Height = 70
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      object Label82: Label8
        Left = 6
        Top = 4
        Width = 380
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'Enter the Password and click the Login button to enter the Distr' +
          'ibutor Release Code Utility.'
        Color = clNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = True
        WordWrap = True
        TextId = 0
      end
      object Label4: TLabel
        Left = 47
        Top = 45
        Width = 78
        Height = 15
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Password'
      end
      object btnOK: TButton
        Tag = 1
        Left = 267
        Top = 42
        Width = 80
        Height = 21
        Caption = '&Login'
        Default = True
        ModalResult = 1
        TabOrder = 1
        OnClick = btnOKClick
      end
      object edtPwrd: Text8Pt
        Left = 133
        Top = 42
        Width = 121
        Height = 21
        AutoSize = False
        CharCase = ecUpperCase
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        PasswordChar = '*'
        ShowHint = True
        TabOrder = 0
        TextId = 0
        ViaSBtn = False
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 7
    Top = 6
  end
end
