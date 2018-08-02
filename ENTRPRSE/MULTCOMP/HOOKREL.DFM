inherited frmHookRelCode: TfrmHookRelCode
  Left = 346
  Top = 157
  Caption = 'frmHookRelCode'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Release Code Required'
  end
  inherited InstrLbl: TLabel
    Left = 23
    Top = 31
    Width = 58
    Height = 41
    Visible = False
  end
  object Label1: TLabel [4]
    Left = 167
    Top = 47
    Width = 288
    Height = 30
    AutoSize = False
    Caption = 
      'You can get a new Security Code by contacting your local distrib' +
      'utor:-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label9: TLabel [5]
    Left = 166
    Top = 124
    Width = 289
    Height = 43
    AutoSize = False
    Caption = 
      'They will ask for the ESN and Security Code shown below, and wil' +
      'l give you a Release Code to enter into the Release Code field b' +
      'elow.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel [6]
    Left = 171
    Top = 220
    Width = 76
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Release Code'
    WordWrap = True
  end
  object Label4: TLabel [7]
    Left = 171
    Top = 196
    Width = 76
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Security Code'
    WordWrap = True
  end
  object Label3: TLabel [8]
    Left = 170
    Top = 172
    Width = 76
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'ESN'
    WordWrap = True
    OnDblClick = Label3DblClick
  end
  object Label5: TLabel [9]
    Left = 168
    Top = 82
    Width = 76
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Contact'
    WordWrap = True
  end
  object Label6: TLabel [10]
    Left = 168
    Top = 100
    Width = 76
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Phone Number'
    WordWrap = True
  end
  object lblPhoneNo: TLabel [11]
    Left = 252
    Top = 100
    Width = 204
    Height = 17
    AutoSize = False
    ShowAccelChar = False
    WordWrap = True
  end
  object lblPhoneContact: TLabel [12]
    Left = 252
    Top = 82
    Width = 204
    Height = 17
    AutoSize = False
    ShowAccelChar = False
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Visible = False
  end
  inherited ExitBtn: TButton
    Visible = False
  end
  inherited BackBtn: TButton
    Caption = '&Accept'
    TabOrder = 6
  end
  inherited NextBtn: TButton
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 7
  end
  object edtESN: Text8Pt
    Left = 256
    Top = 169
    Width = 179
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 3
    TextId = 0
    ViaSBtn = False
  end
  object edtSecCode: Text8Pt
    Left = 256
    Top = 193
    Width = 121
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 4
    TextId = 0
    ViaSBtn = False
  end
  object edtRelCode: Text8Pt
    Left = 257
    Top = 217
    Width = 121
    Height = 22
    EditMask = '>cccccccccc;0; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    TextId = 0
    ViaSBtn = False
  end
end
