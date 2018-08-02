inherited frmWelcome: TfrmWelcome
  Left = 358
  Top = 260
  Caption = 'frmWelcome'
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited TitleLbl: TLabel
    Caption = 'Welcome'
    OnDblClick = TitleLblDblClick
  end
  inherited InstrLbl: TLabel
    Left = 2
    Top = 1
    Width = 68
    Height = 28
    Caption = ''
    Visible = False
  end
  object Label1: TLabel [4]
    Left = 167
    Top = 200
    Width = 285
    Height = 44
    AutoSize = False
    Caption = 
      'Press the Next button to start the installation. You can press t' +
      'he Exit Installation button now if you do not want to install it' +
      ' at this time.'
    WordWrap = True
    OnDblClick = Label1DblClick
  end
  inherited HelpBtn: TButton
    Enabled = False
    Visible = False
  end
  inherited ExitBtn: TButton
    Left = 13
  end
  inherited BackBtn: TButton
    Visible = False
  end
  object Notebook1: TNotebook
    Left = 163
    Top = 43
    Width = 293
    Height = 153
    PageIndex = 2
    TabOrder = 5
    object TPage
      Left = 0
      Top = 0
      Caption = 'ExchInstall'
      DesignSize = (
        293
        153)
      object Label2: TLabel
        Left = 11
        Top = 37
        Width = 6
        Height = 16
        Caption = #183
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Symbol'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 23
        Top = 39
        Width = 253
        Height = 16
        AutoSize = False
        Caption = 'Installing <APPTITLE>'
        WordWrap = True
      end
      object Label4: TLabel
        Left = 11
        Top = 55
        Width = 6
        Height = 16
        Caption = #183
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Symbol'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object Label5: TLabel
        Left = 23
        Top = 57
        Width = 253
        Height = 16
        AutoSize = False
        Caption = 'Upgrading <APPTITLE>'
        Visible = False
        WordWrap = True
      end
      object Label6: TLabel
        Left = 11
        Top = 74
        Width = 6
        Height = 16
        Caption = #183
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Symbol'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object Label7: TLabel
        Left = 23
        Top = 76
        Width = 253
        Height = 16
        AutoSize = False
        Caption = 'Adding Additional Companies'
        Visible = False
        WordWrap = True
      end
      object Label19: TLabel
        Left = 4
        Top = 6
        Width = 280
        Height = 30
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'This installation program can be used for the following tasks:-'
        WordWrap = True
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'ExchUpgrade'
      DesignSize = (
        293
        153)
      object Label10: TLabel
        Left = 23
        Top = 39
        Width = 253
        Height = 16
        AutoSize = False
        Caption = 'Upgrading <APPTITLE>'
        WordWrap = True
      end
      object Label11: TLabel
        Left = 23
        Top = 58
        Width = 253
        Height = 16
        AutoSize = False
        Caption = 'Adding Additional Companies'
        WordWrap = True
      end
      object Label12: TLabel
        Left = 11
        Top = 56
        Width = 6
        Height = 16
        Caption = #183
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Symbol'
        Font.Style = []
        ParentFont = False
      end
      object Label13: TLabel
        Left = 11
        Top = 37
        Width = 6
        Height = 16
        Caption = #183
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Symbol'
        Font.Style = []
        ParentFont = False
      end
      object Label18: TLabel
        Left = 4
        Top = 6
        Width = 280
        Height = 30
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'This installation program can be used for the following tasks:-'
        WordWrap = True
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'WorkstationSetup'
      DesignSize = (
        293
        153)
      object Label20: TLabel
        Left = 4
        Top = 6
        Width = 280
        Height = 69
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'The Workstation Setup program is used to configure a computer to' +
          ' use the <APPTITLE> System.'
        WordWrap = True
      end
    end
  end
end
