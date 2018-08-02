inherited frmAdditionalInfo: TfrmAdditionalInfo
  Left = 367
  Top = 173
  HelpContext = 62
  VertScrollBar.Tracking = True
  Caption = 'frmAdditionalInfo'
  ClientHeight = 304
  ClientWidth = 573
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 259
    Width = 550
  end
  inherited TitleLbl: TLabel
    Width = 398
    Caption = 'Additional Information'
  end
  inherited InstrLbl: TLabel
    Left = 66
    Top = 57
    Width = 73
    Caption = ''
    Visible = False
  end
  inherited imgSide: TImage
    Height = -279
  end
  object Label810: Label8 [4]
    Left = 167
    Top = 46
    Width = 387
    Height = 31
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'The sections below provide access to additional information on i' +
      'nstalling and configuring the system and should be read before c' +
      'ontinuing.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    TextId = 0
  end
  inherited HelpBtn: TButton
    Top = 276
    Visible = False
  end
  inherited Panel1: TPanel
    Height = 242
    inherited Image1: TImage
      Height = 240
    end
  end
  inherited ExitBtn: TButton
    Top = 276
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 396
    Top = 276
    Anchors = [akLeft, akBottom]
    Visible = False
  end
  inherited NextBtn: TButton
    Left = 482
    Top = 276
    Anchors = [akLeft, akBottom]
    Caption = '&Continue >>'
  end
  object ScrollBox1: TScrollBox
    Left = 167
    Top = 83
    Width = 399
    Height = 173
    HorzScrollBar.Visible = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsNone
    Color = clBtnFace
    Ctl3D = False
    ParentColor = False
    ParentCtl3D = False
    TabOrder = 5
    object panWorkstation: TPanel
      Left = 1
      Top = 0
      Width = 380
      Height = 51
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      DesignSize = (
        380
        51)
      object Label811: Label8
        Left = 10
        Top = 18
        Width = 366
        Height = 29
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'The Workstation Setup must be run on each workstation to configu' +
          're it to use the accounts system.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label1: TLabel
        Left = 10
        Top = 2
        Width = 367
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Workstation Setup'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Tag = 1
        Left = 327
        Top = 2
        Width = 45
        Height = 13
        Cursor = crHandPoint
        Caption = 'More Info'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = LoadHelp
      end
    end
    object panExcelAddIns: TPanel
      Left = 1
      Top = 52
      Width = 380
      Height = 51
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      DesignSize = (
        380
        51)
      object Label81: Label8
        Left = 10
        Top = 18
        Width = 366
        Height = 32
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'The Excel Add-In'#39's allow access to the Accounts Data from within' +
          ' an Excel Spreadsheet for budgeting, management reports, etc...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label3: TLabel
        Left = 10
        Top = 2
        Width = 367
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Add-Ins for Microsoft Excel'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label17: TLabel
        Tag = 2
        Left = 327
        Top = 2
        Width = 45
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'More Info'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = LoadHelp
      end
    end
    object panImport: TPanel
      Left = 1
      Top = 104
      Width = 380
      Height = 36
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 2
      DesignSize = (
        380
        36)
      object Label82: Label8
        Left = 10
        Top = 18
        Width = 366
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'The Import Module allows data to be imported into Exchequer.  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label5: TLabel
        Left = 10
        Top = 2
        Width = 367
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Exchequer Import Module'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Tag = 3
        Left = 327
        Top = 2
        Width = 45
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'More Info'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = LoadHelp
      end
    end
    object panSentimail: TPanel
      Left = 1
      Top = 147
      Width = 380
      Height = 51
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 3
      DesignSize = (
        380
        51)
      object Label83: Label8
        Left = 10
        Top = 18
        Width = 366
        Height = 30
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Sentimail is used to monitor defined accounting events, alerting' +
          ' staff via email, SMS or fax when specific conditions are met.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label7: TLabel
        Left = 10
        Top = 2
        Width = 367
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Exchequer Sentimail'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Tag = 4
        Left = 327
        Top = 2
        Width = 45
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'More Info'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = LoadHelp
      end
    end
    object panCRWAddIn: TPanel
      Left = 1
      Top = 253
      Width = 380
      Height = 51
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 4
      DesignSize = (
        380
        51)
      object Label84: Label8
        Left = 10
        Top = 18
        Width = 366
        Height = 34
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'The Crystal Reports Add-In provides additional functions for use' +
          ' within the Crystal Reports Formula Editor.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label9: TLabel
        Left = 10
        Top = 2
        Width = 367
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Add-In for Crystal Reports'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label10: TLabel
        Tag = 6
        Left = 327
        Top = 2
        Width = 45
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'More Info'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = LoadHelp
      end
    end
    object panTradeCounter: TPanel
      Left = 1
      Top = 197
      Width = 380
      Height = 51
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 5
      DesignSize = (
        380
        51)
      object Label85: Label8
        Left = 10
        Top = 18
        Width = 366
        Height = 30
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'The Exchequer Trade Counter is a Point of Sale (POS) system that' +
          ' can be installed locally on PC'#39's.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label11: TLabel
        Left = 10
        Top = 2
        Width = 367
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Exchequer Trade Counter'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Tag = 5
        Left = 327
        Top = 2
        Width = 45
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'More Info'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = LoadHelp
      end
    end
    object panSDK: TPanel
      Left = 1
      Top = 309
      Width = 380
      Height = 51
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 6
      DesignSize = (
        380
        51)
      object Label86: Label8
        Left = 10
        Top = 18
        Width = 366
        Height = 34
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'The SDK provides information on customising Exchequer itself, an' +
          'd on linking in Third-Party Applications to the Exchequer databa' +
          'se.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label13: TLabel
        Left = 10
        Top = 2
        Width = 367
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Exchequer Software Developers Kit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label14: TLabel
        Tag = 7
        Left = 327
        Top = 2
        Width = 45
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'More Info'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = LoadHelp
      end
    end
    object panEBusiness: TPanel
      Left = 1
      Top = 363
      Width = 380
      Height = 65
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 7
      DesignSize = (
        380
        65)
      object Label87: Label8
        Left = 10
        Top = 18
        Width = 366
        Height = 46
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'The eBusiness module provides an interface between Exchequer and' +
          ' a web-site allowing eBis-XML transactions to be imported and se' +
          'lected items of data to be exported to the web-site.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label15: TLabel
        Left = 10
        Top = 2
        Width = 367
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Exchequer eBusiness Module'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label16: TLabel
        Tag = 8
        Left = 327
        Top = 2
        Width = 45
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'More Info'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = LoadHelp
      end
    end
    object panODBC: TPanel
      Left = 1
      Top = 429
      Width = 380
      Height = 53
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 8
      DesignSize = (
        380
        53)
      object Label88: Label8
        Left = 10
        Top = 18
        Width = 366
        Height = 34
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'ODBC allows applications such as Microsoft Word and Excel, or re' +
          'porting tools like Crystal Reports to access the accounts databa' +
          'se.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label4: TLabel
        Left = 10
        Top = 2
        Width = 367
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'ODBC Data Access'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label18: TLabel
        Tag = 9
        Left = 327
        Top = 2
        Width = 45
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'More Info'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = LoadHelp
      end
    end
  end
end
