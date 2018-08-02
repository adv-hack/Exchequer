inherited frmEntModules: TfrmEntModules
  Left = 411
  Top = 162
  HelpContext = 31
  ActiveControl = nil
  Caption = 'Exchequer Setup Program'
  ClientHeight = 416
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 376
    Height = 6
  end
  inherited TitleLbl: TLabel
    Caption = 'Exchequer Modules'
  end
  inherited InstrLbl: TLabel
    Height = 19
    Caption = 'Please select the optional modules you want to %INSTUPG%:'
  end
  inherited imgSide: TImage
    Top = 160
    Height = 260
  end
  inherited HelpBtn: TButton
    Top = 388
    TabOrder = 2
  end
  inherited Panel1: TPanel
    Height = 354
    inherited Image1: TImage
      Height = 352
    end
  end
  inherited ExitBtn: TButton
    Top = 388
    TabOrder = 3
  end
  inherited BackBtn: TButton
    Top = 388
    TabOrder = 4
  end
  inherited NextBtn: TButton
    Top = 388
    TabOrder = 5
  end
  object ScrollBox1: TScrollBox
    Left = 168
    Top = 73
    Width = 283
    Height = 296
    HorzScrollBar.Visible = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    object panEntCore: TPanel
      Left = 4
      Top = 0
      Width = 262
      Height = 36
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      object chkCore: TCheckBox
        Left = 0
        Top = 2
        Width = 246
        Height = 17
        TabStop = False
        Caption = 'Exchequer Program Files'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkClick
      end
      object chkBarCode: TCheckBox
        Left = 19
        Top = 19
        Width = 96
        Height = 17
        TabStop = False
        Caption = 'Barcode Fonts'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        OnClick = chkClick
      end
    end
    object paneBus: TPanel
      Left = 4
      Top = 57
      Width = 251
      Height = 19
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      object chkEBus: TCheckBox
        Left = 0
        Top = 0
        Width = 126
        Height = 17
        TabStop = False
        Caption = 'eBusiness Module'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkClick
      end
    end
    object panImport: TPanel
      Left = 4
      Top = 75
      Width = 251
      Height = 19
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 2
      object chkImport: TCheckBox
        Left = 0
        Top = 0
        Width = 189
        Height = 17
        TabStop = False
        Caption = 'Import Module'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkClick
      end
    end
    object panODBC: TPanel
      Left = 4
      Top = 91
      Width = 251
      Height = 34
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 3
      object chkODBC: TCheckBox
        Left = 0
        Top = 0
        Width = 97
        Height = 17
        TabStop = False
        Caption = 'ODBC'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkClick
      end
      object chkCripple: TCheckBox
        Left = 20
        Top = 17
        Width = 220
        Height = 17
        TabStop = False
        Caption = 'Crystal Reports Add-In'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        OnClick = chkClick
      end
    end
    object panToolkit: TPanel
      Left = 4
      Top = 220
      Width = 251
      Height = 19
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 8
      object chkToolkit: TCheckBox
        Left = 0
        Top = 0
        Width = 189
        Height = 17
        TabStop = False
        Caption = 'Software Developers Kit'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkClick
      end
    end
    object panOLESave: TPanel
      Left = 4
      Top = 126
      Width = 251
      Height = 19
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 4
      object chkOLESave: TCheckBox
        Left = 0
        Top = 0
        Width = 189
        Height = 17
        TabStop = False
        Caption = 'OLE Save Functions'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkClick
      end
    end
    object panPaper: TPanel
      Left = 4
      Top = 169
      Width = 251
      Height = 19
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 5
      object chkPaper: TCheckBox
        Left = 0
        Top = 0
        Width = 209
        Height = 17
        TabStop = False
        Caption = 'Paperless Module'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkClick
      end
    end
    object panTrade: TPanel
      Left = 4
      Top = 237
      Width = 251
      Height = 19
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 9
      object chkTrade: TCheckBox
        Left = 0
        Top = 0
        Width = 189
        Height = 17
        TabStop = False
        Caption = 'Trade Counter'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkClick
      end
    end
    object panRepWrt: TPanel
      Left = 4
      Top = 186
      Width = 251
      Height = 19
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 6
      object chkRepWrt: TCheckBox
        Left = 0
        Top = 0
        Width = 189
        Height = 17
        TabStop = False
        Caption = 'Report Writer'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkClick
      end
    end
    object panElerts: TPanel
      Left = 4
      Top = 203
      Width = 251
      Height = 19
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 7
      object chkElerts: TCheckBox
        Left = 0
        Top = 0
        Width = 189
        Height = 17
        TabStop = False
        Caption = 'Sentimail'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkClick
      end
    end
    object panVRW: TPanel
      Left = 4
      Top = 254
      Width = 251
      Height = 19
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 10
      object chkVRW: TCheckBox
        Left = 0
        Top = 0
        Width = 189
        Height = 17
        TabStop = False
        Caption = 'Visual Report Writer'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkClick
      end
    end
    object panWOP: TPanel
      Left = 4
      Top = 271
      Width = 251
      Height = 19
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 11
      object chkWOP: TCheckBox
        Left = 0
        Top = 0
        Width = 189
        Height = 17
        TabStop = False
        Caption = 'Works Order Processing'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkClick
      end
    end
    object panEBanking: TPanel
      Left = 4
      Top = 38
      Width = 251
      Height = 19
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 12
      object chkEBanking: TCheckBox
        Left = 0
        Top = 0
        Width = 126
        Height = 17
        TabStop = False
        Caption = 'eBanking Module'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkClick
      end
    end
    object panOutlook: TPanel
      Left = 4
      Top = 147
      Width = 251
      Height = 19
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 13
      object chkOutlook: TCheckBox
        Left = 0
        Top = 0
        Width = 209
        Height = 17
        TabStop = False
        Caption = 'Outlook Dynamic Dashboard'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkClick
      end
    end
  end
end
