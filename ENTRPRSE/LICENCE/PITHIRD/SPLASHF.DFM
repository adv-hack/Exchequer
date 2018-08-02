object frmSplash: TfrmSplash
  Left = 353
  Top = 158
  AlphaBlendValue = 128
  BorderStyle = bsNone
  Caption = 'frmSplash'
  ClientHeight = 231
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 385
    Height = 231
    Align = alClient
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 206
      Width = 383
      Height = 24
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object Label2: TLabel
        Left = 5
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
      Width = 383
      Height = 91
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 23
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
        Left = 2
        Top = 34
        Width = 380
        Height = 31
        Alignment = taCenter
        AutoSize = False
        Caption = 'Plug-In Release Code Utility '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object lblLicencee: TLabel
        Left = 5
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
      Width = 383
      Height = 114
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      object Label82: Label8
        Left = 24
        Top = 4
        Width = 335
        Height = 49
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'A Password is required to access the system, please enter the pa' +
          'ssword below and click the OK button to enter the utility, or cl' +
          'ick the cancel button to close the utility now.'
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
      object edtPwrd: Text8Pt
        Left = 131
        Top = 56
        Width = 121
        Height = 22
        AutoSize = False
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 8
        ParentFont = False
        ParentShowHint = False
        PasswordChar = '*'
        ShowHint = True
        TabOrder = 0
        TextId = 0
        ViaSBtn = False
      end
      object btnOK: TButton
        Tag = 1
        Left = 109
        Top = 86
        Width = 80
        Height = 21
        Caption = '&OK'
        Default = True
        ModalResult = 1
        TabOrder = 1
        OnClick = btnOKClick
      end
      object btnCancel: TButton
        Tag = 1
        Left = 195
        Top = 86
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 2
        OnClick = btnCancelClick
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
