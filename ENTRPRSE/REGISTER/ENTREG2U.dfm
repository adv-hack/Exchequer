inherited SetupTemplate1: TSetupTemplate1
  Left = 443
  Top = 126
  ActiveControl = nil
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exchequer Component Setup'
  ClientHeight = 455
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    463
    455)
  PixelsPerInch = 96
  TextHeight = 14
  object lblBtrUser: Label8 [0]
    Left = 13
    Top = 4
    Width = 144
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -9
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    TextId = 0
  end
  inherited Bevel1: TBevel
    Left = 13
    Top = 410
  end
  inherited TitleLbl: TLabel
    Width = 295
    Caption = 'Component Setup'
    Font.Charset = ANSI_CHARSET
    Font.Height = -21
    Font.Name = 'Arial'
  end
  inherited InstrLbl: TLabel
    Top = 42
    Height = 44
    Caption = 
      'This program is used to configure various components used by <AP' +
      'PTITLE>. Select the components you want to configure and click t' +
      'he &Setup button.'
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Arial'
    ParentFont = False
    OnDblClick = InstrLblDblClick
  end
  object lblEntVer: Label8 [4]
    Left = 13
    Top = 3
    Width = 144
    Height = 14
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    TextId = 0
  end
  inherited imgSide: TImage
    Height = 245
  end
  inherited HelpBtn: TButton
    Top = 427
    TabOrder = 2
    TabStop = False
    Visible = False
  end
  inherited Panel1: TPanel
    Height = 393
    DesignSize = (
      145
      393)
    inherited Image1: TImage
      Height = 391
    end
    object lblVersion: TLabel
      Left = 3
      Top = 380
      Width = 3
      Height = 14
      Anchors = [akLeft, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
  inherited ExitBtn: TButton
    Top = 427
    TabOrder = 3
    TabStop = False
    Visible = False
  end
  inherited BackBtn: TButton
    Top = 427
    Caption = '&Setup'
    TabOrder = 4
  end
  inherited NextBtn: TButton
    Top = 427
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 5
  end
  object Notebook1: TNotebook
    Left = 167
    Top = 88
    Width = 284
    Height = 320
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 1
    object TPage
      Left = 0
      Top = 0
      Caption = 'Options'
      object chkOLEServer: TCheckBox
        Left = 10
        Top = 85
        Width = 241
        Height = 20
        Caption = 'Setup Exchequer OLE Server'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 4
      end
      object chkGraphs: TCheckBox
        Left = 10
        Top = 64
        Width = 240
        Height = 20
        Caption = 'Setup Exchequer Graphs'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
      end
      object chkCOMCust: TCheckBox
        Left = 10
        Top = 1
        Width = 257
        Height = 20
        Caption = 'Setup Exchequer COM Customisation'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
      end
      object chkCOMToolkit: TCheckBox
        Left = 10
        Top = 22
        Width = 257
        Height = 20
        Caption = 'Setup Exchequer COM Toolkits'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
      end
      object chkSecurity: TCheckBox
        Left = 10
        Top = 106
        Width = 240
        Height = 20
        Caption = 'Setup Exchequer Security Server'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 5
      end
      object chkDBFWriter: TCheckBox
        Left = 10
        Top = 43
        Width = 262
        Height = 20
        Caption = 'Setup Exchequer DBF Writer'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 2
      end
      object chkExchOutlookToday: TCheckBox
        Left = 10
        Top = 127
        Width = 240
        Height = 20
        Caption = 'Setup Outlook Dynamic Dashboard Controls'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 6
      end
      object chkExchSetupClientSync: TCheckBox
        Left = 10
        Top = 148
        Width = 240
        Height = 20
        Caption = 'Setup GovLink Plug-Ins'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 7
      end
      object chkExchSentimail: TCheckBox
        Left = 10
        Top = 169
        Width = 240
        Height = 20
        Caption = 'Setup Sentimail Plug-In'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 8
      end
      object chkConfigDB: TCheckBox
        Left = 10
        Top = 232
        Width = 152
        Height = 20
        Caption = 'Configure Database Engine'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 11
      end
      object chkExchSpell: TCheckBox
        Left = 10
        Top = 190
        Width = 240
        Height = 20
        Caption = 'Setup Spell Checker'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 9
      end
      object chkExchHTMLHelp: TCheckBox
        Left = 10
        Top = 253
        Width = 176
        Height = 20
        Caption = 'Enable HTML Help Support'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 12
      end
      object chkFaxComponents: TCheckBox
        Left = 10
        Top = 211
        Width = 240
        Height = 20
        Caption = 'Setup Faxing Components'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 10
      end
      object chkCreditCardAddin: TCheckBox
        Left = 10
        Top = 274
        Width = 159
        Height = 17
        Caption = 'Setup Credit Card Add-in'
        TabOrder = 13
      end
      object chkExcelExportUtilities: TCheckBox
        Left = 10
        Top = 295
        Width = 224
        Height = 17
        Caption = 'Setup Exchequer Excel Export Utilities'
        TabOrder = 14
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Progress'
      object ListBox1: TListBox
        Left = 11
        Top = 11
        Width = 267
        Height = 249
        BorderStyle = bsNone
        Color = clBtnFace
        Ctl3D = False
        ItemHeight = 14
        Items.Strings = (
          'Configuring Components, Please Wait...')
        ParentCtl3D = False
        TabOrder = 0
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'LITE Options'
      object chkLITECOMCust: TCheckBox
        Left = 10
        Top = 1
        Width = 257
        Height = 20
        Caption = 'Setup COM Customisation'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
      end
      object chkLITECOMToolkit: TCheckBox
        Left = 10
        Top = 23
        Width = 257
        Height = 20
        Caption = 'Setup COM Toolkits'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
      end
      object chkLITEDBFWriter: TCheckBox
        Left = 10
        Top = 44
        Width = 262
        Height = 20
        Caption = 'Setup DBF Writer'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 2
      end
      object chkLITEGraphs: TCheckBox
        Left = 10
        Top = 66
        Width = 240
        Height = 20
        Caption = 'Setup Graph Control'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
      end
      object chkLITEOLEServer: TCheckBox
        Left = 10
        Top = 88
        Width = 241
        Height = 20
        Caption = 'Setup OLE Server for Excel Plug-Ins'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 4
      end
      object chkLITESecurity: TCheckBox
        Left = 10
        Top = 154
        Width = 240
        Height = 20
        Caption = 'Setup Plug-In Security Server'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 5
      end
      object chkLITEConfigDB: TCheckBox
        Left = 10
        Top = 176
        Width = 152
        Height = 20
        Caption = 'Configure Database Engine'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 6
      end
      object chkLITEICE: TCheckBox
        Left = 10
        Top = 132
        Width = 240
        Height = 20
        Caption = 'Setup ClientLink Plug-Ins'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 7
      end
      object chkLITESpeller: TCheckBox
        Left = 10
        Top = 110
        Width = 240
        Height = 20
        Caption = 'Setup Spell Checker'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 8
      end
    end
  end
end
