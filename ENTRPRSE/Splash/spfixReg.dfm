inherited frmWSConfig: TfrmWSConfig
  Left = 364
  Top = 196
  Caption = 'Workstation Configuration Warnings'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 244
    Height = 7
  end
  inherited TitleLbl: TLabel
    Caption = 'Configuration Warnings'
    OnDblClick = TitleLblDblClick
  end
  inherited InstrLbl: TLabel
    Height = 33
    Caption = 
      'The following warnings have been found during a routine configur' +
      'ation check of this workstation.'
  end
  object Label1: TLabel [3]
    Left = 167
    Top = 208
    Width = 285
    Height = 28
    AutoSize = False
    Caption = 
      'Click the &Fix button below to correct these problems, or to exi' +
      't without opening the accounts click the &Close button.'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    TabOrder = 2
    Visible = False
  end
  inherited ExitBtn: TButton
    Left = 98
    Caption = '&Ignore'
    TabOrder = 4
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 287
    Caption = '&Fix'
  end
  inherited NextBtn: TButton
    Caption = '&Close'
    TabOrder = 5
  end
  object ScrollBox1: TScrollBox
    Left = 178
    Top = 84
    Width = 274
    Height = 117
    VertScrollBar.Increment = 1
    BorderStyle = bsNone
    TabOrder = 1
    object panOLE: TPanel
      Left = 0
      Top = 45
      Width = 258
      Height = 21
      BevelOuter = bvNone
      TabOrder = 0
      object Label6: TLabel
        Left = 8
        Top = 7
        Width = 6
        Height = 9
        Caption = 'l'
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 22
        Top = 4
        Width = 167
        Height = 13
        Caption = 'OLE Server not registered or invalid'
      end
    end
    object panBtrieve: TPanel
      Left = 0
      Top = 0
      Width = 258
      Height = 21
      BevelOuter = bvNone
      TabOrder = 1
      object Label2: TLabel
        Left = 8
        Top = 7
        Width = 6
        Height = 9
        Caption = 'l'
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 22
        Top = 4
        Width = 191
        Height = 13
        Caption = 'Incorrect Database Engine configuration'
      end
    end
    object panGraph: TPanel
      Left = 0
      Top = 22
      Width = 258
      Height = 21
      BevelOuter = bvNone
      TabOrder = 2
      object Label4: TLabel
        Left = 8
        Top = 7
        Width = 6
        Height = 9
        Caption = 'l'
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 22
        Top = 4
        Width = 177
        Height = 13
        Caption = 'Graph Control not registered or invalid'
      end
    end
    object panSecurity: TPanel
      Left = 0
      Top = 68
      Width = 258
      Height = 21
      BevelOuter = bvNone
      TabOrder = 3
      object Label8: TLabel
        Left = 8
        Top = 7
        Width = 6
        Height = 9
        Caption = 'l'
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 22
        Top = 4
        Width = 184
        Height = 13
        Caption = 'Security Server not registered or invalid'
      end
    end
    object panCOMTK: TPanel
      Left = 0
      Top = 91
      Width = 258
      Height = 21
      BevelOuter = bvNone
      TabOrder = 4
      object Label10: TLabel
        Left = 8
        Top = 7
        Width = 6
        Height = 9
        Caption = 'l'
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clBlack
        Font.Height = -8
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
      end
      object Label11: TLabel
        Left = 22
        Top = 4
        Width = 171
        Height = 13
        Caption = 'COM Toolkit not registered or invalid'
      end
    end
  end
end
