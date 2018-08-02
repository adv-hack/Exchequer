inherited frmWSReady: TfrmWSReady
  Left = 390
  Top = 245
  HelpContext = 16
  ActiveControl = nil
  Caption = 'Exchequer Setup Program'
  ClientHeight = 295
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited InstrLbl: TLabel [0]
    Left = 193
    Width = 100
    Height = 19
    Caption = ''
  end
  inherited Bevel1: TBevel [1]
    Top = 255
    Height = 6
  end
  inherited TitleLbl: TLabel [2]
    Caption = 'Ready To Setup Workstation'
  end
  inherited HelpBtn: TButton
    Top = 267
  end
  inherited Panel1: TPanel
    Height = 233
    inherited Image1: TImage
      Height = 231
    end
  end
  inherited ExitBtn: TButton
    Top = 267
  end
  inherited BackBtn: TButton
    Top = 267
  end
  inherited NextBtn: TButton
    Top = 267
    Caption = '&Install'
  end
  object ScrollBox1: TScrollBox
    Left = 170
    Top = 42
    Width = 289
    Height = 203
    Anchors = [akLeft, akTop, akBottom]
    BorderStyle = bsNone
    Color = clBtnFace
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 5
    object panWarnTitle: TPanel
      Left = 2
      Top = 116
      Width = 268
      Height = 66
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      object Label810: Label8
        Left = 3
        Top = 6
        Width = 259
        Height = 55
        AutoSize = False
        Caption = 
          'Setup has generated the following warnings for you to check befo' +
          're proceeding. Each warning must be acknowledged by ticking the ' +
          'box before the setup can be completed.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
    end
    object panLocal: TPanel
      Left = 2
      Top = 35
      Width = 268
      Height = 47
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      object Label82: Label8
        Left = 10
        Top = 33
        Width = 82
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Local Dir:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblLocLocDir: Label8
        Left = 98
        Top = 33
        Width = 170
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label81: Label8
        Left = 3
        Top = 3
        Width = 128
        Height = 14
        Caption = 'Local Program Files Setup:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblLocEntDir: Label8
        Left = 98
        Top = 18
        Width = 170
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label87: Label8
        Left = 10
        Top = 18
        Width = 82
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Network Dir:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
    end
    object panstandard: TPanel
      Left = 3
      Top = 0
      Width = 268
      Height = 34
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 2
      object Label85: Label8
        Left = 3
        Top = 3
        Width = 138
        Height = 14
        Caption = 'Standard Workstation Setup:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label84: Label8
        Left = 10
        Top = 18
        Width = 82
        Height = 14
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Application Dir:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object lblStdEntDir: Label8
        Left = 98
        Top = 18
        Width = 170
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
    end
    object panOverwrite: TPanel
      Left = 2
      Top = 183
      Width = 268
      Height = 51
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 3
      OnClick = panOverwriteClick
      object Label812: Label8
        Left = 26
        Top = 21
        Width = 241
        Height = 31
        AutoSize = False
        Caption = 
          'The selected directory for the Local Program Files setup already' +
          ' contains a System.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        OnClick = panOverwriteClick
        TextId = 0
      end
      object chkOverwrite: TBorCheck
        Left = 6
        Top = 1
        Width = 260
        Height = 20
        Align = alRight
        Caption = 'Overwrite an existing system'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        TextId = 0
        OnClick = DoCheckyChecky
      end
    end
    object panIcons: TPanel
      Left = 2
      Top = 86
      Width = 268
      Height = 31
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 4
      object chkAllUsers: TBorCheck
        Left = 1
        Top = 5
        Width = 260
        Height = 21
        Align = alRight
        Caption = 'Add icons for all users on this workstation'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        TextId = 0
        OnClick = DoCheckyChecky
      end
    end
  end
end
