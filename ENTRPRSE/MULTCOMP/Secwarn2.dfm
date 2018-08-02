inherited frmSecWarn: TfrmSecWarn
  Left = 357
  Top = 294
  HelpContext = 12
  ActiveControl = nil
  Caption = 'frmSecWarn'
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Left = 13
  end
  inherited TitleLbl: TLabel
    Caption = 'Security Check'
  end
  inherited InstrLbl: TLabel
    Left = 57
    Top = 50
    Width = 80
    Height = 46
    Caption = ''
    Visible = False
  end
  inherited ExitBtn: TButton
    Width = 80
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 280
    Width = 80
    Cancel = True
    Caption = '&Skip'
  end
  inherited NextBtn: TButton
    Left = 367
    Width = 85
    Caption = '&Continue'
  end
  object Notebook1: TNotebook
    Left = 164
    Top = 43
    Width = 291
    Height = 194
    PageIndex = 1
    TabOrder = 5
    object TPage
      Left = 0
      Top = 0
      Caption = 'Install'
      object Label8: TLabel
        Left = 5
        Top = 5
        Width = 285
        Height = 43
        AutoSize = False
        Caption = 
          'Please note that this Exchequer product has a built-in security ' +
          'check. This helps us to prevent software theft and ensures that ' +
          'all users of Exchequer are registered.'
        WordWrap = True
      end
      object Label4: TLabel
        Left = 6
        Top = 58
        Width = 74
        Height = 21
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Days to Expiry'
        WordWrap = True
      end
      object lblExpDate: TLabel
        Left = 139
        Top = 58
        Width = 144
        Height = 21
        AutoSize = False
        Caption = '(Someday xth SomeMonth)'
        WordWrap = True
      end
      object Label5: TLabel
        Left = 5
        Top = 163
        Width = 285
        Height = 21
        AutoSize = False
        Caption = 'Click the Skip button to perform this at a later date.'
        WordWrap = True
      end
      object Label6: TLabel
        Left = 5
        Top = 143
        Width = 285
        Height = 17
        AutoSize = False
        Caption = 'To get a new Security Code now, click the Continue button.'
        WordWrap = True
      end
      object ccySecDays: TCurrencyEdit
        Left = 85
        Top = 54
        Width = 35
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'ARIAL'
        Font.Style = []
        Lines.Strings = (
          '0')
        MaxLength = 2
        ParentFont = False
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        OnChange = ccySecDaysChange
        AutoSize = False
        BlockNegative = False
        BlankOnZero = False
        DisplayFormat = '#0'
        ShowCurrency = False
        TextId = 0
        Value = 1E-10
      end
      object SBSUpDown1: TSBSUpDown
        Left = 120
        Top = 54
        Width = 15
        Height = 25
        Associate = ccySecDays
        Min = 0
        Max = 30
        Position = 0
        TabOrder = 1
        Wrap = False
        OnClick = SBSUpDown1Click
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Upgrade'
      object Label1: TLabel
        Left = 5
        Top = 143
        Width = 285
        Height = 17
        AutoSize = False
        Caption = 'To get a new Security Code now, click the Continue button.'
        WordWrap = True
      end
      object Label3: TLabel
        Left = 5
        Top = 52
        Width = 285
        Height = 54
        AutoSize = False
        Caption = 
          'Your current Security Code expires in xx days and you will need ' +
          'to get a new Security Code from your Local Distributor.'
        WordWrap = True
      end
      object Label2: TLabel
        Left = 5
        Top = 163
        Width = 285
        Height = 21
        AutoSize = False
        Caption = 'Click the %SKIP% button to perform this at a later date.'
        WordWrap = True
      end
      object Label7: TLabel
        Left = 5
        Top = 5
        Width = 285
        Height = 43
        AutoSize = False
        Caption = 
          'Please note that this Exchequer product has a built-in security ' +
          'check. This helps us to prevent software theft and ensures that ' +
          'all users of Exchequer are registered.'
        WordWrap = True
      end
    end
  end
end
