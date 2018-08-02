object frmLicWiz5: TfrmLicWiz5
  Left = 360
  Top = 169
  HelpContext = 1008
  ActiveControl = btnNext
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'CD Licencing Wizard - Step 6 of 6'
  ClientHeight = 476
  ClientWidth = 629
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    629
    476)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 3
    Width = 288
    Height = 29
    AutoSize = False
    Caption = 'Confirm Details'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 33
    Width = 608
    Height = 30
    AutoSize = False
    Caption = 
      'Carefully check the following licence details and click the Writ' +
      'e Licence button if the details are correct. If the details are ' +
      'incorrect then use the "<< Previous" button to go back and corre' +
      'ct them.'
    WordWrap = True
  end
  object Bevel2: TBevel
    Left = 6
    Top = 441
    Width = 613
    Height = 4
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsBottomLine
  end
  object btnNext: TButton
    Left = 538
    Top = 451
    Width = 80
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '&Write Licence'
    TabOrder = 5
    OnClick = btnNextClick
  end
  object btnPrevious: TButton
    Left = 451
    Top = 451
    Width = 80
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '<< &Previous'
    TabOrder = 4
    OnClick = btnPreviousClick
  end
  object btnOptions: TButton
    Left = 9
    Top = 451
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'Options'
    TabOrder = 1
    OnClick = btnOptionsClick
  end
  object ScrollBox1: TScrollBox
    Left = 6
    Top = 64
    Width = 613
    Height = 374
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clWindow
    ParentColor = False
    TabOrder = 0
    DesignSize = (
      609
      370)
    object lblLicenceDescr: TLabel
      Left = 0
      Top = 0
      Width = 609
      Height = 31
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Licence Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSno: TLabel
      Left = 8
      Top = 32
      Width = 87
      Height = 13
      Caption = 'CD Serial Number:'
    end
    object Label6: TLabel
      Left = 233
      Top = 32
      Width = 25
      Height = 13
      Caption = 'ESN:'
    end
    object lblCDSno: TLabel
      Left = 114
      Top = 32
      Width = 119
      Height = 13
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblESN: TLabel
      Left = 275
      Top = 32
      Width = 330
      Height = 13
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 8
      Top = 58
      Width = 78
      Height = 13
      Caption = 'Company Name:'
    end
    object lblCompanyName: TLabel
      Left = 114
      Top = 58
      Width = 388
      Height = 13
      AutoSize = False
    end
    object Label13: TLabel
      Left = 8
      Top = 75
      Width = 65
      Height = 13
      Caption = 'Dealer Name:'
    end
    object lblDlrName: TLabel
      Left = 114
      Top = 75
      Width = 388
      Height = 13
      AutoSize = False
    end
    object Shape1: TShape
      Left = 7
      Top = 51
      Width = 593
      Height = 1
    end
    object Shape2: TShape
      Left = 7
      Top = 94
      Width = 593
      Height = 1
    end
    object Label7: TLabel
      Left = 8
      Top = 101
      Width = 88
      Height = 13
      Caption = 'Enterprise Version:'
    end
    object lblEngineType: TLabel
      Left = 8
      Top = 118
      Width = 94
      Height = 13
      AutoSize = False
      Caption = 'DB Engine:'
    end
    object lblCSVer: TLabel
      Left = 114
      Top = 118
      Width = 474
      Height = 13
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblEntVer: TLabel
      Left = 114
      Top = 101
      Width = 326
      Height = 13
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 8
      Top = 135
      Width = 85
      Height = 13
      Caption = 'Optional Modules:'
    end
    object Shape3: TShape
      Left = 7
      Top = 328
      Width = 593
      Height = 1
      Anchors = [akLeft, akRight, akBottom]
    end
    object Label4: TLabel
      Left = 452
      Top = 101
      Width = 78
      Height = 13
      Caption = 'Company Count:'
    end
    object lblCompanyCount: TLabel
      Left = 547
      Top = 101
      Width = 53
      Height = 13
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lstOptMods: TListBox
      Left = 21
      Top = 150
      Width = 573
      Height = 175
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      Columns = 2
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      TabWidth = 100
    end
    object Panel1: TPanel
      Left = 2
      Top = 334
      Width = 606
      Height = 34
      Anchors = [akLeft, akRight, akBottom]
      BevelOuter = bvNone
      Color = clWindow
      Enabled = False
      TabOrder = 1
      DesignSize = (
        606
        34)
      object Label1: TLabel
        Left = 7
        Top = 0
        Width = 118
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'Special Licence Options:'
      end
      object chkResetModRels: TCheckBox
        Left = 20
        Top = 16
        Width = 227
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'Reset Module Release Codes'
        TabOrder = 0
      end
      object chkResetCountryCode: TCheckBox
        Left = 309
        Top = 16
        Width = 227
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'Reset Country Code'
        TabOrder = 1
      end
    end
  end
  object chkSuppressLog: TCheckBox
    Left = 95
    Top = 453
    Width = 177
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Don'#39't Add Licence To Log File'
    TabOrder = 2
  end
  object chkWebRel: TCheckBox
    Left = 302
    Top = 453
    Width = 131
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Send to WebRel'
    TabOrder = 3
  end
end
